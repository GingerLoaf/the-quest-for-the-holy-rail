using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace HolyRail.City
{
    [ExecuteInEditMode]
    public class CityManager : MonoBehaviour
    {
        private const int ThreadGroupSize = 64;

        [Header("Compute Shader")]
        [field: SerializeField] public ComputeShader CityGeneratorShader { get; private set; }

        [Header("Rendering")]
        [field: SerializeField] public Mesh BuildingMesh { get; set; }
        [field: SerializeField] public Material BuildingMaterial { get; set; }

        [Header("Generation Parameters")]
        [field: SerializeField] public int Seed { get; set; } = 12345;
        [field: SerializeField] public float MapSize { get; set; } = 2000f;
        [field: SerializeField] public int BuildingCount { get; set; } = 50000;

        [Header("Zone Settings")]
        [field: SerializeField] public float DowntownRadius { get; set; } = 400f;
        [field: SerializeField, Range(0f, 1f)] public float DowntownDensity { get; set; } = 0.8f;
        [field: SerializeField, Range(0f, 1f)] public float IndustrialDensity { get; set; } = 0.4f;

        [Header("Building Heights")]
        [field: SerializeField] public float DowntownHeightMin { get; set; } = 20f;
        [field: SerializeField] public float DowntownHeightMax { get; set; } = 80f;
        [field: SerializeField] public float IndustrialHeightMin { get; set; } = 5f;
        [field: SerializeField] public float IndustrialHeightMax { get; set; } = 20f;

        [Header("Street Layout")]
        [field: SerializeField] public float StreetWidth { get; set; } = 12f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowBounds { get; set; } = true;
        [field: SerializeField] public bool AutoGenerateOnStart { get; set; } = true;

        // Serialized generated data (persists through play mode)
        [SerializeField, HideInInspector]
        private List<BuildingData> _generatedBuildings = new List<BuildingData>();

        // Runtime GPU buffers (recreated from serialized data as needed)
        private GraphicsBuffer _buildingBuffer;
        private GraphicsBuffer _counterBuffer;
        private GraphicsBuffer _argsBuffer;

        // Render state
        private Bounds _renderBounds;
        private MaterialPropertyBlock _propertyBlock;
        private bool _buffersInitialized;

        // Kernel
        private int _generateKernel;

        public int ActualBuildingCount => _generatedBuildings.Count;
        public bool HasData => _generatedBuildings.Count > 0;
        public bool IsGenerated => HasData;
        public IReadOnlyList<BuildingData> Buildings => _generatedBuildings;

        private void OnEnable()
        {
            // Recreate GPU buffers from serialized data if we have it
            if (HasData && !_buffersInitialized)
            {
                InitializeBuffersFromSerializedData();
            }
        }

        private void Start()
        {
            if (AutoGenerateOnStart && Application.isPlaying && !HasData)
            {
                Generate();
            }
        }

        private void Update()
        {
            // Ensure buffers exist if we have data
            if (HasData && !_buffersInitialized)
            {
                InitializeBuffersFromSerializedData();
            }

            if (HasData && BuildingMesh != null && BuildingMaterial != null && _buffersInitialized)
            {
                RenderBuildings();
            }
        }

        [ContextMenu("Generate City")]
        public void Generate()
        {
            if (CityGeneratorShader == null)
            {
                Debug.LogError("CityManager: ComputeShader is not assigned!");
                return;
            }

            if (BuildingMesh == null)
            {
                Debug.LogError("CityManager: Building mesh is not assigned!");
                return;
            }

            if (BuildingMaterial == null)
            {
                Debug.LogError("CityManager: Building material is not assigned!");
                return;
            }

            Clear();

            // Get kernel
            _generateKernel = CityGeneratorShader.FindKernel("GenerateCity");

            // Calculate buffer sizes
            int buildingStride = Marshal.SizeOf<BuildingData>();

            // Create temporary buffers for generation
            var tempBuildingBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, BuildingCount, buildingStride);
            _counterBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, 1, sizeof(int));

            // Initialize counter to 0
            _counterBuffer.SetData(new int[] { 0 });

            // Set shader parameters
            CityGeneratorShader.SetBuffer(_generateKernel, "_BuildingBuffer", tempBuildingBuffer);
            CityGeneratorShader.SetBuffer(_generateKernel, "_Counter", _counterBuffer);

            CityGeneratorShader.SetInt("_Seed", Seed);
            CityGeneratorShader.SetFloat("_MapSize", MapSize);
            CityGeneratorShader.SetInt("_BuildingCount", BuildingCount);
            CityGeneratorShader.SetFloat("_DowntownRadius", DowntownRadius);
            CityGeneratorShader.SetFloat("_DowntownDensity", DowntownDensity);
            CityGeneratorShader.SetFloat("_IndustrialDensity", IndustrialDensity);
            CityGeneratorShader.SetFloat("_DowntownHeightMin", DowntownHeightMin);
            CityGeneratorShader.SetFloat("_DowntownHeightMax", DowntownHeightMax);
            CityGeneratorShader.SetFloat("_IndustrialHeightMin", IndustrialHeightMin);
            CityGeneratorShader.SetFloat("_IndustrialHeightMax", IndustrialHeightMax);
            CityGeneratorShader.SetFloat("_StreetWidth", StreetWidth);
            CityGeneratorShader.SetVector("_CityCenter", transform.position);

            // Dispatch compute shader
            int threadGroups = Mathf.CeilToInt(BuildingCount / (float)ThreadGroupSize);
            CityGeneratorShader.Dispatch(_generateKernel, threadGroups, 1, 1);

            // Read back actual building count
            int[] counterData = new int[1];
            _counterBuffer.GetData(counterData);
            int actualCount = counterData[0];

            // Read back building data and store in serialized list
            var buildingArray = new BuildingData[actualCount];
            tempBuildingBuffer.GetData(buildingArray, 0, 0, actualCount);

            _generatedBuildings = new List<BuildingData>(buildingArray);

            // Release temporary generation buffer
            tempBuildingBuffer.Release();
            _counterBuffer.Release();
            _counterBuffer = null;

            // Now initialize the rendering buffers from serialized data
            InitializeBuffersFromSerializedData();

            Debug.Log($"CityManager: Generated {_generatedBuildings.Count} buildings (from {BuildingCount} attempts)");
        }

        private void InitializeBuffersFromSerializedData()
        {
            if (_generatedBuildings.Count == 0)
                return;

            if (BuildingMesh == null || BuildingMaterial == null)
                return;

            // Release any existing buffers
            ReleaseBuffers();

            int buildingStride = Marshal.SizeOf<BuildingData>();

            // Create and populate building buffer from serialized data
            _buildingBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, _generatedBuildings.Count, buildingStride);
            _buildingBuffer.SetData(_generatedBuildings.ToArray());

            // Create indirect args buffer for RenderMeshIndirect
            // Args: [indexCount, instanceCount, startIndex, baseVertex, startInstance]
            _argsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, 5 * sizeof(uint));
            uint[] args = new uint[]
            {
                BuildingMesh.GetIndexCount(0),
                (uint)_generatedBuildings.Count,
                BuildingMesh.GetIndexStart(0),
                BuildingMesh.GetBaseVertex(0),
                0
            };
            _argsBuffer.SetData(args);

            // Calculate render bounds (large enough to always be visible)
            float maxHeight = Mathf.Max(DowntownHeightMax, IndustrialHeightMax);
            _renderBounds = new Bounds(
                transform.position + Vector3.up * maxHeight * 0.5f,
                new Vector3(MapSize + 100f, maxHeight + 100f, MapSize + 100f)
            );

            // Create property block for material
            _propertyBlock = new MaterialPropertyBlock();
            _propertyBlock.SetBuffer("_BuildingBuffer", _buildingBuffer);

            _buffersInitialized = true;
        }

        private void RenderBuildings()
        {
            if (_argsBuffer == null || _propertyBlock == null)
                return;

            // Update material buffer reference
            _propertyBlock.SetBuffer("_BuildingBuffer", _buildingBuffer);

            var renderParams = new RenderParams(BuildingMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _propertyBlock,
                shadowCastingMode = ShadowCastingMode.On,
                receiveShadows = true
            };

            Graphics.RenderMeshIndirect(renderParams, BuildingMesh, _argsBuffer);
        }

        private void ReleaseBuffers()
        {
            _buildingBuffer?.Release();
            _counterBuffer?.Release();
            _argsBuffer?.Release();

            _buildingBuffer = null;
            _counterBuffer = null;
            _argsBuffer = null;

            _buffersInitialized = false;
        }

        [ContextMenu("Clear")]
        public void Clear()
        {
            ReleaseBuffers();
            _generatedBuildings.Clear();
        }

        private void OnDisable()
        {
            // Only release GPU buffers, keep serialized data for persistence
            ReleaseBuffers();
        }

        private void OnDestroy()
        {
            ReleaseBuffers();
        }

        private void OnDrawGizmosSelected()
        {
            if (!ShowBounds)
                return;

            // Draw city bounds
            Gizmos.color = new Color(0f, 1f, 0.5f, 0.3f);
            float halfMap = MapSize * 0.5f;
            Gizmos.DrawWireCube(transform.position, new Vector3(MapSize, 10f, MapSize));

            // Draw downtown radius
            Gizmos.color = new Color(1f, 0.5f, 0f, 0.5f);
            DrawCircle(transform.position + Vector3.up * 5f, DowntownRadius, 32);

            // Draw center marker
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(transform.position, 5f);
        }

        private void DrawCircle(Vector3 center, float radius, int segments)
        {
            float angleStep = 360f / segments;
            Vector3 prevPoint = center + new Vector3(radius, 0, 0);

            for (int i = 1; i <= segments; i++)
            {
                float angle = i * angleStep * Mathf.Deg2Rad;
                Vector3 point = center + new Vector3(Mathf.Cos(angle) * radius, 0, Mathf.Sin(angle) * radius);
                Gizmos.DrawLine(prevPoint, point);
                prevPoint = point;
            }
        }
    }
}
