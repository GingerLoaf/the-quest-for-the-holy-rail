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

        [Header("Building Rendering")]
        [field: SerializeField] public Mesh BuildingMesh { get; set; }
        [field: SerializeField] public Material BuildingMaterial { get; set; }

        [Header("Ramp Settings")]
        [field: SerializeField] public bool EnableRamps { get; set; } = true;
        [field: SerializeField] public Mesh RampMesh { get; set; }
        [field: SerializeField] public Material RampMaterial { get; set; }
        [field: SerializeField] public int RampCount { get; set; } = 500;
        [field: SerializeField] public float RampRadius { get; set; } = 500f;
        [field: SerializeField] public float RampLengthMin { get; set; } = 5f;
        [field: SerializeField] public float RampLengthMax { get; set; } = 15f;
        [field: SerializeField] public float RampWidthMin { get; set; } = 3f;
        [field: SerializeField] public float RampWidthMax { get; set; } = 8f;
        [field: SerializeField] public float RampAngleMin { get; set; } = 10f;
        [field: SerializeField] public float RampAngleMax { get; set; } = 35f;

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

        [SerializeField, HideInInspector]
        private List<RampData> _generatedRamps = new List<RampData>();

        // Runtime GPU buffers (recreated from serialized data as needed)
        private GraphicsBuffer _buildingBuffer;
        private GraphicsBuffer _counterBuffer;
        private GraphicsBuffer _argsBuffer;

        // Ramp GPU buffers
        private GraphicsBuffer _rampBuffer;
        private GraphicsBuffer _rampArgsBuffer;
        private MaterialPropertyBlock _rampPropertyBlock;
        private bool _rampBuffersInitialized;

        // Render state
        private Bounds _renderBounds;
        private MaterialPropertyBlock _propertyBlock;
        private bool _buffersInitialized;

        // Kernel
        private int _generateKernel;

        public int ActualBuildingCount => _generatedBuildings.Count;
        public int ActualRampCount => _generatedRamps.Count;
        public bool HasData => _generatedBuildings.Count > 0;
        public bool HasRampData => _generatedRamps.Count > 0;
        public bool IsGenerated => HasData;
        public IReadOnlyList<BuildingData> Buildings => _generatedBuildings;
        public IReadOnlyList<RampData> Ramps => _generatedRamps;

        private void OnEnable()
        {
            // Recreate GPU buffers from serialized data if we have it
            if (HasData && !_buffersInitialized)
            {
                InitializeBuffersFromSerializedData();
            }
            if (HasRampData && !_rampBuffersInitialized)
            {
                InitializeRampBuffersFromSerializedData();
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

            if (HasRampData && !_rampBuffersInitialized)
            {
                InitializeRampBuffersFromSerializedData();
            }

            if (HasData && BuildingMesh != null && BuildingMaterial != null && _buffersInitialized)
            {
                RenderBuildings();
            }

            if (HasRampData && RampMesh != null && RampMaterial != null && _rampBuffersInitialized)
            {
                RenderRamps();
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

            // Generate ramps if enabled
            if (EnableRamps)
            {
                if (RampMesh == null)
                {
                    Debug.LogWarning("CityManager: Ramps enabled but RampMesh is not assigned! Assign a cube mesh.");
                }
                if (RampMaterial == null)
                {
                    Debug.LogWarning("CityManager: Ramps enabled but RampMaterial is not assigned! Assign the RampMaterial from Assets/HolyRail/Materials/");
                }

                GenerateRamps();
                InitializeRampBuffersFromSerializedData();
            }

            var rampInfo = EnableRamps ? $", {_generatedRamps.Count} ramps" : "";
            Debug.Log($"CityManager: Generated {_generatedBuildings.Count} buildings (from {BuildingCount} attempts){rampInfo}");
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

        private void GenerateRamps()
        {
            _generatedRamps.Clear();

            var random = new System.Random(Seed + 12345); // Different seed offset for ramps
            var centerPos = transform.position;

            // Street grid parameters (must match CityGenerator.compute)
            float gridSize = StreetWidth * 2.0f; // Building + street

            // Buildings are at gridSize * 0.25 offset within each cell
            // North-South streets run between building columns at X = cellX * gridSize + gridSize * 0.75
            // We want ramps ONLY on North-South streets, avoiding intersections with E-W streets

            float streetCenterOffset = gridSize * 0.75f; // Center of N-S street within a cell

            // Calculate grid cells within the ramp radius
            int cellsInRadius = Mathf.CeilToInt(RampRadius / gridSize);

            int attempts = 0;
            int maxAttempts = RampCount * 10; // Limit attempts to avoid infinite loop

            while (_generatedRamps.Count < RampCount && attempts < maxAttempts)
            {
                attempts++;

                // Random dimensions
                float length = RampLengthMin + (float)random.NextDouble() * (RampLengthMax - RampLengthMin);
                float width = RampWidthMin + (float)random.NextDouble() * (RampWidthMax - RampWidthMin);
                float angle = RampAngleMin + (float)random.NextDouble() * (RampAngleMax - RampAngleMin);
                float depth = 0.5f; // Thickness of the ramp

                // Pick a random grid cell within the ramp radius (centered on city center)
                int cellOffsetX = random.Next(-cellsInRadius, cellsInRadius + 1);
                int cellOffsetZ = random.Next(-cellsInRadius, cellsInRadius + 1);

                // X position: Center of North-South street (between building columns)
                // The street runs at x = cellOffsetX * gridSize + streetCenterOffset from center
                float streetX = centerPos.x + cellOffsetX * gridSize + streetCenterOffset;

                // Z position: Place within the cell but avoid E-W street intersections
                // Stay in the first half of the cell (building row area, 0.0 to 0.5 of gridSize)
                float zPadding = length * 0.5f + 2f; // Padding for ramp length plus margin
                float zMin = zPadding;
                float zMax = gridSize * 0.5f - zPadding;

                if (zMax <= zMin)
                {
                    // Cell too small for this ramp, skip
                    continue;
                }

                float localZ = zMin + (float)random.NextDouble() * (zMax - zMin);
                float streetZ = centerPos.z + cellOffsetZ * gridSize + localZ;

                // Check if within ramp radius
                float distFromCenter = Mathf.Sqrt(
                    (streetX - centerPos.x) * (streetX - centerPos.x) +
                    (streetZ - centerPos.z) * (streetZ - centerPos.z)
                );

                if (distFromCenter > RampRadius)
                {
                    continue;
                }

                // Calculate vertical rise based on angle and length
                float angleRad = angle * Mathf.Deg2Rad;
                float rampRise = length * Mathf.Sin(angleRad);
                float rampRun = length * Mathf.Cos(angleRad);

                // Align ramp with Z axis - facing forward (+Z direction)
                // Tilt the ramp up by rotating around X axis (negative angle tilts front up)
                var finalRotation = Quaternion.Euler(-angle, 0f, 0f);

                // Position Y: center of the tilted ramp
                float yOffset = rampRise * 0.5f;

                var rampPosition = new Vector3(streetX, yOffset + centerPos.y, streetZ);

                // Check if ramp intersects any buildings using a generous bounding box
                bool intersectsBuilding = false;

                // Create bounds that encompass the full ramp footprint
                var rampMin = new Vector3(
                    rampPosition.x - width * 0.5f - 1f,
                    0f,
                    rampPosition.z - rampRun * 0.5f - 1f
                );
                var rampMax = new Vector3(
                    rampPosition.x + width * 0.5f + 1f,
                    rampRise + 2f,
                    rampPosition.z + rampRun * 0.5f + 1f
                );

                foreach (var building in _generatedBuildings)
                {
                    var buildingMin = new Vector3(
                        building.Position.x - building.Scale.x * 0.5f,
                        0f,
                        building.Position.z - building.Scale.z * 0.5f
                    );
                    var buildingMax = new Vector3(
                        building.Position.x + building.Scale.x * 0.5f,
                        building.Position.y + building.Scale.y * 0.5f,
                        building.Position.z + building.Scale.z * 0.5f
                    );

                    // AABB intersection test
                    if (rampMin.x < buildingMax.x && rampMax.x > buildingMin.x &&
                        rampMin.z < buildingMax.z && rampMax.z > buildingMin.z)
                    {
                        intersectsBuilding = true;
                        break;
                    }
                }

                if (intersectsBuilding)
                    continue;

                // Scale: X = width, Y = thickness (small), Z = length along slope
                var ramp = new RampData
                {
                    Position = rampPosition,
                    Scale = new Vector3(width, depth, length),
                    Rotation = finalRotation,
                    Angle = angle
                };

                _generatedRamps.Add(ramp);
            }

            if (_generatedRamps.Count < RampCount)
            {
                Debug.LogWarning($"CityManager: Only placed {_generatedRamps.Count} ramps out of {RampCount} requested (couldn't find valid positions for the rest)");
            }
        }

        private void InitializeRampBuffersFromSerializedData()
        {
            if (_generatedRamps.Count == 0)
            {
                Debug.Log("CityManager: No ramps to initialize buffers for.");
                return;
            }

            if (RampMesh == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize ramp buffers - RampMesh is null. Assign a cube mesh.");
                return;
            }

            if (RampMaterial == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize ramp buffers - RampMaterial is null. Assign RampMaterial from Assets/HolyRail/Materials/");
                return;
            }

            Debug.Log($"CityManager: Initializing ramp buffers for {_generatedRamps.Count} ramps...");

            // Release any existing ramp buffers
            ReleaseRampBuffers();

            int rampStride = Marshal.SizeOf<RampData>();

            // Create and populate ramp buffer from serialized data
            _rampBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, _generatedRamps.Count, rampStride);
            _rampBuffer.SetData(_generatedRamps.ToArray());

            // Create indirect args buffer for RenderMeshIndirect
            _rampArgsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, 5 * sizeof(uint));
            uint[] args = new uint[]
            {
                RampMesh.GetIndexCount(0),
                (uint)_generatedRamps.Count,
                RampMesh.GetIndexStart(0),
                RampMesh.GetBaseVertex(0),
                0
            };
            _rampArgsBuffer.SetData(args);

            // Create property block for ramp material
            _rampPropertyBlock = new MaterialPropertyBlock();
            _rampPropertyBlock.SetBuffer("_RampBuffer", _rampBuffer);

            _rampBuffersInitialized = true;
            Debug.Log($"CityManager: Ramp buffers initialized successfully. Mesh: {RampMesh.name}, Material: {RampMaterial.name}");
        }

        private void RenderRamps()
        {
            if (_rampArgsBuffer == null || _rampPropertyBlock == null)
                return;

            // Update material buffer reference
            _rampPropertyBlock.SetBuffer("_RampBuffer", _rampBuffer);

            var renderParams = new RenderParams(RampMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _rampPropertyBlock,
                shadowCastingMode = ShadowCastingMode.On,
                receiveShadows = true
            };

            Graphics.RenderMeshIndirect(renderParams, RampMesh, _rampArgsBuffer);
        }

        private void ReleaseRampBuffers()
        {
            _rampBuffer?.Release();
            _rampArgsBuffer?.Release();

            _rampBuffer = null;
            _rampArgsBuffer = null;

            _rampBuffersInitialized = false;
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
            ReleaseRampBuffers();
            _generatedBuildings.Clear();
            _generatedRamps.Clear();

            // Find and clear any BuildingColliderPools that reference this CityManager
            var colliderPools = FindObjectsByType<BuildingColliderPool>(FindObjectsSortMode.None);
            foreach (var pool in colliderPools)
            {
                if (pool.CityManager == this)
                {
                    pool.Clear();
                }
            }
        }

        private void OnDisable()
        {
            // Only release GPU buffers, keep serialized data for persistence
            ReleaseBuffers();
            ReleaseRampBuffers();
        }

        private void OnDestroy()
        {
            ReleaseBuffers();
            ReleaseRampBuffers();
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

            // Draw ramp radius (if enabled)
            if (EnableRamps)
            {
                Gizmos.color = new Color(0.2f, 0.4f, 0.8f, 0.5f);
                DrawCircle(transform.position + Vector3.up * 6f, RampRadius, 48);
            }

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
