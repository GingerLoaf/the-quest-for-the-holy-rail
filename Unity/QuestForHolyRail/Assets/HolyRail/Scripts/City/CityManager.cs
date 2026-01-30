using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace HolyRail.City
{
    [System.Serializable]
    public class LoopHalfData
    {
        public int BuildingStartIndex;
        public int BuildingCount;
        public int RampStartIndex;
        public int RampCount;
        public int BillboardStartIndex;
        public int BillboardCount;
        public int GraffitiStartIndex;
        public int GraffitiCount;
        public List<Vector3> PathPoints = new List<Vector3>();
        public Vector3 CurrentOffset;
        public int HalfId;
    }

    [System.Serializable]
    public class LoopModeState
    {
        public bool IsActive;
        public LoopHalfData HalfA = new LoopHalfData { HalfId = 0 };
        public LoopHalfData HalfB = new LoopHalfData { HalfId = 1 };
        public int FrontHalfId;
        public float HalfLength;
        public Vector3 ForwardDirection;
    }

    [ExecuteInEditMode]
    public class CityManager : MonoBehaviour
    {
        [Header("Building Rendering")]
        [field: SerializeField] public Mesh BuildingMesh { get; set; }
        [field: SerializeField] public Material BuildingMaterial { get; set; }

        [Header("Ramp Settings")]
        [field: SerializeField] public bool EnableRamps { get; set; } = true;
        [field: SerializeField] public Mesh RampMesh { get; set; }
        [field: SerializeField] public Material RampMaterial { get; set; }
        [field: SerializeField] public int RampCount { get; set; } = 50;
        [field: SerializeField] public float RampLengthMin { get; set; } = 5f;
        [field: SerializeField] public float RampLengthMax { get; set; } = 15f;
        [field: SerializeField] public float RampWidthMin { get; set; } = 3f;
        [field: SerializeField] public float RampWidthMax { get; set; } = 8f;
        [field: SerializeField] public float RampAngleMin { get; set; } = 10f;
        [field: SerializeField] public float RampAngleMax { get; set; } = 35f;
        [field: SerializeField] public float RampYOffset { get; set; } = -1f;

        [Header("Billboard Settings")]
        [field: SerializeField] public bool EnableBillboards { get; set; } = true;
        [field: SerializeField] public Mesh BillboardMesh { get; set; }
        [field: SerializeField] public Material BillboardMaterial { get; set; }
        [field: SerializeField] public int BillboardCount { get; set; } = 30;
        [field: SerializeField] public float BillboardWidthMin { get; set; } = 8f;
        [field: SerializeField] public float BillboardWidthMax { get; set; } = 15f;
        [field: SerializeField] public float BillboardHeightMin { get; set; } = 4f;
        [field: SerializeField] public float BillboardHeightMax { get; set; } = 8f;
        [field: SerializeField] public float BillboardYOffsetMin { get; set; } = 3f;
        [field: SerializeField] public float BillboardYOffsetMax { get; set; } = 15f;
        [field: SerializeField] public float BillboardDepth { get; set; } = 0.3f;
        [field: SerializeField] public float BillboardInwardOffset { get; set; } = 2f;

        [Header("Graffiti Settings")]
        [field: SerializeField] public bool EnableGraffiti { get; set; } = true;
        [field: SerializeField] public GameObject GraffitiSpotPrefab { get; set; }
        [field: SerializeField] public int GraffitiCount { get; set; } = 30;
        [field: SerializeField] public float GraffitiYOffsetMin { get; set; } = 0.5f;
        [field: SerializeField] public float GraffitiYOffsetMax { get; set; } = 3f;
        [field: SerializeField] public float GraffitiMinSpacing { get; set; } = 15f;
        [field: SerializeField] public float GraffitiEdgeClearance { get; set; } = 0.5f;
        [field: SerializeField, Range(0f, 1f)] public float GraffitiOnBillboardPercent { get; set; } = 0.3f;
        [field: SerializeField] public float GraffitiBillboardAvoidDistance { get; set; } = 5f;
        [field: SerializeField] public float GraffitiProjectionWidth { get; set; } = 6f;
        [field: SerializeField] public float GraffitiProjectionHeight { get; set; } = 3f;
        [field: SerializeField] public float GraffitiWallOffset { get; set; } = 2.0f;

        [Header("Generation Parameters")]
        [field: SerializeField] public int Seed { get; set; } = 12345;

        [Header("Corridor Layout")]
        [field: SerializeField] public Transform ConvergencePoint { get; private set; }
        [field: SerializeField] public Transform EndpointA { get; private set; }
        [field: SerializeField] public Transform EndpointB { get; private set; }
        [field: SerializeField] public Transform EndpointC { get; private set; }

        [Header("Corridor Toggles")]
        [field: SerializeField] public bool EnableCorridorA { get; private set; } = true;
        [field: SerializeField] public bool EnableCorridorB { get; private set; } = true;
        [field: SerializeField] public bool EnableCorridorC { get; private set; } = true;

        [Header("Convergence End Point")]
        [field: SerializeField] public Transform ConvergenceEndPoint { get; private set; }
        [field: SerializeField] public bool EnableConvergenceEndPlaza { get; private set; } = true;
        [field: SerializeField] public float ConvergenceEndRadius { get; private set; } = 20f;
        [field: SerializeField, Range(1, 3)] public int EndPlazaRingRows { get; private set; } = 2;

        [Header("Junction Points")]
        [field: SerializeField] public Transform JunctionAB { get; private set; }
        [field: SerializeField] public bool EnableJunctionAB { get; private set; } = true;
        [field: SerializeField] public Transform JunctionBC { get; private set; }
        [field: SerializeField] public bool EnableJunctionBC { get; private set; } = true;
        [field: SerializeField] public float JunctionRadius { get; private set; } = 15f;

        [Header("Final End Point")]
        [field: SerializeField] public Transform FinalEndPoint { get; private set; }
        [field: SerializeField] public bool EnableFinalEndPoint { get; private set; } = true;
        [field: SerializeField] public float FinalEndPointRadius { get; private set; } = 15f;

        [Header("Corridor Settings")]
        [field: SerializeField] public float CorridorWidth { get; set; } = 30f;
        [field: SerializeField] public float BuildingSetback { get; set; } = 2f;
        [field: SerializeField] public float BuildingSpacing { get; set; } = 15f;
        [field: SerializeField] public float ConvergenceRadius { get; set; } = 50f;
        [field: SerializeField, Range(1, 10)] public int BuildingRows { get; set; } = 1;
        [field: SerializeField] public bool EnablePlazaRing { get; set; } = true;
        [field: SerializeField, Range(1, 3)] public int PlazaRingRows { get; set; } = 1;

        [Header("Corridor Curve")]
        [field: SerializeField] public float CorridorNoiseAmplitude { get; set; } = 20f;
        [field: SerializeField] public float CorridorNoiseFrequency { get; set; } = 0.02f;

        [Header("Building Heights")]
        [field: SerializeField] public float BuildingHeightMin { get; set; } = 20f;
        [field: SerializeField] public float BuildingHeightMax { get; set; } = 80f;
        [field: SerializeField] public float BuildingWidthMin { get; set; } = 8f;
        [field: SerializeField] public float BuildingWidthMax { get; set; } = 15f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowBounds { get; set; } = true;
        [field: SerializeField] public bool AutoGenerateOnStart { get; set; } = true;
        [field: SerializeField] public bool AutoGenerateInEditor { get; set; } = false;

        [Header("Loop Mode")]
        [field: SerializeField] public bool IsLoopMode { get; set; } = false;

        // Loop mode state (serialized for persistence)
        [SerializeField, HideInInspector]
        private LoopModeState _loopState = new LoopModeState();

        // Track if loop mode shader offsets need to be (re)applied
        private bool _loopOffsetsNeedUpdate = true;

        public LoopModeState LoopState => _loopState;
        public IReadOnlyList<Vector3> CorridorPathA => _corridorPathA;
        public IReadOnlyList<Vector3> CorridorPathB => _corridorPathB;
        public IReadOnlyList<Vector3> CorridorPathC => _corridorPathC;
        public IReadOnlyList<Vector3> CorridorPathB_ToAB => _corridorPathB_ToAB;
        public IReadOnlyList<Vector3> CorridorPathB_ToBC => _corridorPathB_ToBC;

        public event System.Action OnCityRegenerated;

        // Serialized generated data (persists through play mode)
        [SerializeField, HideInInspector]
        private List<BuildingData> _generatedBuildings = new List<BuildingData>();

        [SerializeField, HideInInspector]
        private List<RampData> _generatedRamps = new List<RampData>();

        [SerializeField, HideInInspector]
        private List<BillboardData> _generatedBillboards = new List<BillboardData>();

        [SerializeField, HideInInspector]
        private List<GraffitiSpotData> _generatedGraffitiSpots = new List<GraffitiSpotData>();

        // Cached corridor paths for gizmo visualization
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathA = new List<Vector3>();
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathB = new List<Vector3>();
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathC = new List<Vector3>();

        // Corridor B branch paths (when junctions are used)
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathB_ToAB = new List<Vector3>();
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathB_ToBC = new List<Vector3>();

        // Runtime GPU buffers (recreated from serialized data as needed)
        private GraphicsBuffer _buildingBuffer;
        private GraphicsBuffer _argsBuffer;

        // Ramp GPU buffers
        private GraphicsBuffer _rampBuffer;
        private GraphicsBuffer _rampArgsBuffer;
        private MaterialPropertyBlock _rampPropertyBlock;
        private bool _rampBuffersInitialized;

        // Billboard GPU buffers
        private GraphicsBuffer _billboardBuffer;
        private GraphicsBuffer _billboardArgsBuffer;
        private MaterialPropertyBlock _billboardPropertyBlock;
        private bool _billboardBuffersInitialized;

        // Render state
        private Bounds _renderBounds;
        private MaterialPropertyBlock _propertyBlock;
        private bool _buffersInitialized;

        // Cached arrays for GPU buffer uploads (avoids allocations during leapfrog)
        private BuildingData[] _buildingArrayCache;
        private RampData[] _rampArrayCache;
        private BillboardData[] _billboardArrayCache;

        // Random number generator for deterministic generation
        private System.Random _random;

        // Cached pool references to avoid FindObjectsByType allocations during leapfrog
        private BuildingColliderPool[] _cachedColliderPools;
        private GraffitiSpotPool[] _cachedGraffitiPools;

        public int ActualBuildingCount => _generatedBuildings.Count;
        public int ActualRampCount => _generatedRamps.Count;
        public int ActualBillboardCount => _generatedBillboards.Count;
        public int ActualGraffitiCount => _generatedGraffitiSpots.Count;
        public bool HasData => _generatedBuildings.Count > 0;
        public bool HasRampData => _generatedRamps.Count > 0;
        public bool HasBillboardData => _generatedBillboards.Count > 0;
        public bool HasGraffitiData => _generatedGraffitiSpots.Count > 0;
        public bool IsGenerated => HasData;
        public IReadOnlyList<BuildingData> Buildings => _generatedBuildings;
        public IReadOnlyList<RampData> Ramps => _generatedRamps;
        public IReadOnlyList<BillboardData> Billboards => _generatedBillboards;
        public IReadOnlyList<GraffitiSpotData> GraffitiSpots => _generatedGraffitiSpots;

        public bool HasValidCorridorSetup
        {
            get
            {
                // Must have convergence point
                if (ConvergencePoint == null)
                    return false;

                // At least one corridor must be enabled
                bool hasEnabledCorridor = EnableCorridorA || EnableCorridorB || EnableCorridorC;
                if (!hasEnabledCorridor)
                    return false;

                // Each enabled corridor needs either its waypoint endpoint OR ConvergenceEndPoint
                bool hasEndPoint = ConvergenceEndPoint != null;

                if (EnableCorridorA && EndpointA == null && !hasEndPoint)
                    return false;
                if (EnableCorridorB && EndpointB == null && !hasEndPoint)
                    return false;
                if (EnableCorridorC && EndpointC == null && !hasEndPoint)
                    return false;

                // Junction validation: if junctions enabled and assigned, endpoints must also be set
                if (EnableJunctionAB && JunctionAB != null && (EndpointA == null || EndpointB == null))
                    return false;
                if (EnableJunctionBC && JunctionBC != null && (EndpointB == null || EndpointC == null))
                    return false;

                return true;
            }
        }

        public int EnabledCorridorCount
        {
            get
            {
                int count = 0;
                if (EnableCorridorA) count++;
                if (EnableCorridorB) count++;
                if (EnableCorridorC) count++;
                return count;
            }
        }

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
            if (HasBillboardData && !_billboardBuffersInitialized)
            {
                InitializeBillboardBuffersFromSerializedData();
            }
        }

        private void Start()
        {
            // Cache pool references to avoid FindObjectsByType allocations during leapfrog
            if (Application.isPlaying)
            {
                _cachedColliderPools = FindObjectsByType<BuildingColliderPool>(FindObjectsSortMode.None);
                _cachedGraffitiPools = FindObjectsByType<GraffitiSpotPool>(FindObjectsSortMode.None);
            }

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

            if (HasBillboardData && !_billboardBuffersInitialized)
            {
                InitializeBillboardBuffersFromSerializedData();
            }

            // Update loop mode shader offsets if needed (only on first init or after leapfrog)
            if (_loopState.IsActive && _buffersInitialized && _loopOffsetsNeedUpdate)
            {
                UpdateHalfOffsets();
                _loopOffsetsNeedUpdate = false;
            }

            if (HasData && BuildingMesh != null && BuildingMaterial != null && _buffersInitialized)
            {
                RenderBuildings();
            }

            if (HasRampData && RampMesh != null && RampMaterial != null && _rampBuffersInitialized)
            {
                RenderRamps();
            }

            if (HasBillboardData && BillboardMesh != null && BillboardMaterial != null && _billboardBuffersInitialized)
            {
                RenderBillboards();
            }
        }

        [ContextMenu("Generate City")]
        public void Generate()
        {
            if (!HasValidCorridorSetup)
            {
                Debug.LogError("CityManager: Corridor transforms not assigned! Assign ConvergencePoint and all three Endpoints.");
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

            // Initialize random generator with seed
            _random = new System.Random(Seed);

            // Reset loop state
            _loopState = new LoopModeState();
            _loopState.IsActive = IsLoopMode;
            _loopOffsetsNeedUpdate = true;

            // Generate corridor paths (only for enabled corridors)
            var convergencePos = ConvergencePoint.position;
            var endPos = ConvergenceEndPoint != null ? ConvergenceEndPoint.position : Vector3.zero;
            endPos.y = convergencePos.y; // Flatten to same height

            // In loop mode, only generate corridor A
            bool generateCorridorA = IsLoopMode || (EnableCorridorA && EndpointA != null);
            bool generateCorridorB = !IsLoopMode && EnableCorridorB && EndpointB != null;
            bool generateCorridorC = !IsLoopMode && EnableCorridorC && EndpointC != null;

            // Clear B branch paths
            _corridorPathB_ToAB.Clear();
            _corridorPathB_ToBC.Clear();

            // Helper to check if a junction is active
            bool useJunctionAB = EnableJunctionAB && JunctionAB != null && ConvergenceEndPoint != null;
            bool useJunctionBC = EnableJunctionBC && JunctionBC != null && ConvergenceEndPoint != null;
            bool useFinalEndPoint = EnableFinalEndPoint && FinalEndPoint != null && ConvergenceEndPoint != null;

            // Pre-generate shared straight line from ConvergenceEndPoint to FinalEndPoint
            List<Vector3> sharedFinalSegment = null;
            if (useFinalEndPoint)
            {
                var finalPos = FinalEndPoint.position;
                finalPos.y = convergencePos.y;
                sharedFinalSegment = GenerateStraightPathSegment(endPos, finalPos);
            }

            // Pre-generate shared Junction→End segments so all corridors merge properly
            List<Vector3> sharedSegmentABToEnd = null;
            List<Vector3> sharedSegmentBCToEnd = null;
            Vector3 junctionABPos = Vector3.zero;
            Vector3 junctionBCPos = Vector3.zero;

            if (useJunctionAB)
            {
                junctionABPos = JunctionAB.position;
                junctionABPos.y = convergencePos.y;
                // Use fixed noise offset 100 for JunctionAB→End (shared by A and B-AB)
                sharedSegmentABToEnd = GenerateCurvedPathSegment(junctionABPos, endPos, 100, 0);
            }

            if (useJunctionBC)
            {
                junctionBCPos = JunctionBC.position;
                junctionBCPos.y = convergencePos.y;
                // Use fixed noise offset 200 for JunctionBC→End (shared by B-BC and C)
                sharedSegmentBCToEnd = GenerateCurvedPathSegment(junctionBCPos, endPos, 200, 0);
            }

            if (generateCorridorA && EndpointA != null)
            {
                if (useJunctionAB)
                {
                    // A: Start→EndpointA→JunctionAB + shared JunctionAB→End
                    _corridorPathA = new List<Vector3>();
                    var segStartToA = GenerateCurvedPathSegment(convergencePos, EndpointA.position, 0, 0);
                    _corridorPathA.AddRange(segStartToA);
                    var segAToJunctionAB = GenerateCurvedPathSegment(EndpointA.position, junctionABPos, 0, 1);
                    for (int i = 1; i < segAToJunctionAB.Count; i++)
                        _corridorPathA.Add(segAToJunctionAB[i]);
                    for (int i = 1; i < sharedSegmentABToEnd.Count; i++)
                        _corridorPathA.Add(sharedSegmentABToEnd[i]);
                }
                else
                {
                    _corridorPathA = GenerateCurvedPath(convergencePos, EndpointA.position, 0);
                }
            }

            if (generateCorridorB)
            {
                // Corridor B: if both junctions enabled, create TWO branches
                if (useJunctionAB && useJunctionBC)
                {
                    // Generate shared segment: Start → EndpointB
                    var sharedStartToB = GenerateCurvedPathSegment(convergencePos, EndpointB.position, 1, 0);

                    // Branch to JunctionAB: Start→EndpointB→JunctionAB + shared JunctionAB→End
                    _corridorPathB_ToAB = new List<Vector3>(sharedStartToB);
                    var segBToJunctionAB = GenerateCurvedPathSegment(EndpointB.position, junctionABPos, 1, 1);
                    for (int i = 1; i < segBToJunctionAB.Count; i++)
                        _corridorPathB_ToAB.Add(segBToJunctionAB[i]);
                    for (int i = 1; i < sharedSegmentABToEnd.Count; i++)
                        _corridorPathB_ToAB.Add(sharedSegmentABToEnd[i]);

                    // Branch to JunctionBC: Start→EndpointB→JunctionBC + shared JunctionBC→End
                    _corridorPathB_ToBC = new List<Vector3>(sharedStartToB);
                    var segBToJunctionBC = GenerateCurvedPathSegment(EndpointB.position, junctionBCPos, 1, 2);
                    for (int i = 1; i < segBToJunctionBC.Count; i++)
                        _corridorPathB_ToBC.Add(segBToJunctionBC[i]);
                    for (int i = 1; i < sharedSegmentBCToEnd.Count; i++)
                        _corridorPathB_ToBC.Add(sharedSegmentBCToEnd[i]);

                    // Main path uses AB branch for backwards compatibility
                    _corridorPathB = new List<Vector3>(_corridorPathB_ToAB);
                }
                else if (useJunctionAB)
                {
                    // B→JunctionAB: Start→EndpointB→JunctionAB + shared JunctionAB→End
                    _corridorPathB = new List<Vector3>();
                    var segStartToB = GenerateCurvedPathSegment(convergencePos, EndpointB.position, 1, 0);
                    _corridorPathB.AddRange(segStartToB);
                    var segBToJunctionAB = GenerateCurvedPathSegment(EndpointB.position, junctionABPos, 1, 1);
                    for (int i = 1; i < segBToJunctionAB.Count; i++)
                        _corridorPathB.Add(segBToJunctionAB[i]);
                    for (int i = 1; i < sharedSegmentABToEnd.Count; i++)
                        _corridorPathB.Add(sharedSegmentABToEnd[i]);
                }
                else if (useJunctionBC)
                {
                    // B→JunctionBC: Start→EndpointB→JunctionBC + shared JunctionBC→End
                    _corridorPathB = new List<Vector3>();
                    var segStartToB = GenerateCurvedPathSegment(convergencePos, EndpointB.position, 1, 0);
                    _corridorPathB.AddRange(segStartToB);
                    var segBToJunctionBC = GenerateCurvedPathSegment(EndpointB.position, junctionBCPos, 1, 1);
                    for (int i = 1; i < segBToJunctionBC.Count; i++)
                        _corridorPathB.Add(segBToJunctionBC[i]);
                    for (int i = 1; i < sharedSegmentBCToEnd.Count; i++)
                        _corridorPathB.Add(sharedSegmentBCToEnd[i]);
                }
                else
                {
                    _corridorPathB = GenerateCurvedPath(convergencePos, EndpointB.position, 1);
                }
            }

            if (generateCorridorC)
            {
                if (useJunctionBC)
                {
                    // C: Start→EndpointC→JunctionBC + shared JunctionBC→End
                    _corridorPathC = new List<Vector3>();
                    var segStartToC = GenerateCurvedPathSegment(convergencePos, EndpointC.position, 2, 0);
                    _corridorPathC.AddRange(segStartToC);
                    var segCToJunctionBC = GenerateCurvedPathSegment(EndpointC.position, junctionBCPos, 2, 1);
                    for (int i = 1; i < segCToJunctionBC.Count; i++)
                        _corridorPathC.Add(segCToJunctionBC[i]);
                    for (int i = 1; i < sharedSegmentBCToEnd.Count; i++)
                        _corridorPathC.Add(sharedSegmentBCToEnd[i]);
                }
                else
                {
                    _corridorPathC = GenerateCurvedPath(convergencePos, EndpointC.position, 2);
                }
            }

            // Append straight line from ConvergenceEndPoint to FinalEndPoint (shared by all corridors)
            if (useFinalEndPoint && sharedFinalSegment != null && sharedFinalSegment.Count > 0)
            {
                // Helper to append final segment to a path
                void AppendFinalSegment(List<Vector3> path)
                {
                    if (path != null && path.Count > 0)
                    {
                        for (int i = 1; i < sharedFinalSegment.Count; i++)
                            path.Add(sharedFinalSegment[i]);
                    }
                }

                if (generateCorridorA) AppendFinalSegment(_corridorPathA);
                if (generateCorridorB) AppendFinalSegment(_corridorPathB);
                if (_corridorPathB_ToAB.Count > 0) AppendFinalSegment(_corridorPathB_ToAB);
                if (_corridorPathB_ToBC.Count > 0) AppendFinalSegment(_corridorPathB_ToBC);
                if (generateCorridorC) AppendFinalSegment(_corridorPathC);
            }

            // Collect all enabled paths for overlap checking
            var allPaths = new List<List<Vector3>>();
            var pathToIndex = new Dictionary<List<Vector3>, int>();

            if (generateCorridorA && _corridorPathA.Count > 0)
            {
                pathToIndex[_corridorPathA] = allPaths.Count;
                allPaths.Add(_corridorPathA);
            }
            if (generateCorridorB && _corridorPathB.Count > 0)
            {
                pathToIndex[_corridorPathB] = allPaths.Count;
                allPaths.Add(_corridorPathB);
            }
            if (generateCorridorC && _corridorPathC.Count > 0)
            {
                pathToIndex[_corridorPathC] = allPaths.Count;
                allPaths.Add(_corridorPathC);
            }
            // Add B branch paths for building generation
            if (_corridorPathB_ToAB.Count > 0)
            {
                pathToIndex[_corridorPathB_ToAB] = allPaths.Count;
                allPaths.Add(_corridorPathB_ToAB);
            }
            if (_corridorPathB_ToBC.Count > 0)
            {
                pathToIndex[_corridorPathB_ToBC] = allPaths.Count;
                allPaths.Add(_corridorPathB_ToBC);
            }

            // In loop mode, calculate path midpoint and setup half data
            int pathMidpointIndex = 0;
            if (IsLoopMode && _corridorPathA.Count > 0)
            {
                pathMidpointIndex = _corridorPathA.Count / 2;
                SetupLoopModeHalves(pathMidpointIndex);
            }

            // Generate buildings along enabled corridors (with overlap checking)
            // In loop mode, track which half each building belongs to
            if (generateCorridorA && _corridorPathA.Count > 0)
            {
                if (IsLoopMode)
                {
                    _loopState.HalfA.BuildingStartIndex = _generatedBuildings.Count;
                    GenerateCorridorBuildingsForHalf(_corridorPathA, allPaths, pathToIndex[_corridorPathA], 0, pathMidpointIndex);
                    _loopState.HalfA.BuildingCount = _generatedBuildings.Count - _loopState.HalfA.BuildingStartIndex;

                    _loopState.HalfB.BuildingStartIndex = _generatedBuildings.Count;
                    GenerateCorridorBuildingsForHalf(_corridorPathA, allPaths, pathToIndex[_corridorPathA], pathMidpointIndex, _corridorPathA.Count);
                    _loopState.HalfB.BuildingCount = _generatedBuildings.Count - _loopState.HalfB.BuildingStartIndex;
                }
                else
                {
                    GenerateCorridorBuildings(_corridorPathA, allPaths, pathToIndex[_corridorPathA]);
                }
            }
            if (generateCorridorB && _corridorPathB.Count > 0)
                GenerateCorridorBuildings(_corridorPathB, allPaths, pathToIndex[_corridorPathB]);
            // Generate buildings for B->BC branch if it exists (separate from B->AB)
            if (_corridorPathB_ToBC.Count > 0)
                GenerateCorridorBuildings(_corridorPathB_ToBC, allPaths, pathToIndex[_corridorPathB_ToBC]);
            if (generateCorridorC && _corridorPathC.Count > 0)
                GenerateCorridorBuildings(_corridorPathC, allPaths, pathToIndex[_corridorPathC]);

            // Generate plaza ring around convergence point (start plaza)
            if (EnablePlazaRing)
            {
                GeneratePlazaRing(allPaths);
            }

            // Generate end plaza ring around ConvergenceEndPoint (if set and enabled)
            // In loop mode, skip the end plaza
            if (!IsLoopMode && ConvergenceEndPoint != null && EnableConvergenceEndPlaza)
            {
                GenerateEndPlazaRing(allPaths);
            }

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

                if (generateCorridorA && _corridorPathA.Count > 0)
                {
                    if (IsLoopMode)
                    {
                        _loopState.HalfA.RampStartIndex = _generatedRamps.Count;
                        GenerateCorridorRampsForHalf(_corridorPathA, 0, pathMidpointIndex);
                        _loopState.HalfA.RampCount = _generatedRamps.Count - _loopState.HalfA.RampStartIndex;

                        _loopState.HalfB.RampStartIndex = _generatedRamps.Count;
                        GenerateCorridorRampsForHalf(_corridorPathA, pathMidpointIndex, _corridorPathA.Count);
                        _loopState.HalfB.RampCount = _generatedRamps.Count - _loopState.HalfB.RampStartIndex;
                    }
                    else
                    {
                        GenerateCorridorRamps(_corridorPathA);
                    }
                }
                if (generateCorridorB && _corridorPathB.Count > 0)
                    GenerateCorridorRamps(_corridorPathB);
                if (_corridorPathB_ToBC.Count > 0)
                    GenerateCorridorRamps(_corridorPathB_ToBC);
                if (generateCorridorC && _corridorPathC.Count > 0)
                    GenerateCorridorRamps(_corridorPathC);
                InitializeRampBuffersFromSerializedData();
            }

            // Generate billboards if enabled
            if (EnableBillboards)
            {
                if (BillboardMesh == null)
                {
                    Debug.LogWarning("CityManager: Billboards enabled but BillboardMesh is not assigned! Assign a cube mesh.");
                }
                if (BillboardMaterial == null)
                {
                    Debug.LogWarning("CityManager: Billboards enabled but BillboardMaterial is not assigned! Assign the BillboardMaterial from Assets/HolyRail/Materials/");
                }

                Debug.Log($"CityManager: Starting billboard generation. Path lengths: A={_corridorPathA.Count}, B={_corridorPathB.Count}, C={_corridorPathC.Count}");
                if (generateCorridorA && _corridorPathA.Count > 0)
                {
                    if (IsLoopMode)
                    {
                        _loopState.HalfA.BillboardStartIndex = _generatedBillboards.Count;
                        GenerateCorridorBillboardsForHalf(_corridorPathA, 0, pathMidpointIndex);
                        _loopState.HalfA.BillboardCount = _generatedBillboards.Count - _loopState.HalfA.BillboardStartIndex;

                        _loopState.HalfB.BillboardStartIndex = _generatedBillboards.Count;
                        GenerateCorridorBillboardsForHalf(_corridorPathA, pathMidpointIndex, _corridorPathA.Count);
                        _loopState.HalfB.BillboardCount = _generatedBillboards.Count - _loopState.HalfB.BillboardStartIndex;
                    }
                    else
                    {
                        GenerateCorridorBillboards(_corridorPathA);
                    }
                }
                if (generateCorridorB && _corridorPathB.Count > 0)
                    GenerateCorridorBillboards(_corridorPathB);
                if (_corridorPathB_ToBC.Count > 0)
                    GenerateCorridorBillboards(_corridorPathB_ToBC);
                if (generateCorridorC && _corridorPathC.Count > 0)
                    GenerateCorridorBillboards(_corridorPathC);
                Debug.Log($"CityManager: Billboard generation complete. Total billboards: {_generatedBillboards.Count}");
                InitializeBillboardBuffersFromSerializedData();

                // Auto-setup billboard textures
                var textureSetup = GetComponent<BillboardTextureSetup>();
                if (textureSetup == null)
                {
                    textureSetup = gameObject.AddComponent<BillboardTextureSetup>();
                }
                textureSetup.AutoSetup();
            }

            // Generate graffiti spots if enabled
            if (EnableGraffiti)
            {
                if (GraffitiSpotPrefab == null)
                {
                    Debug.LogWarning("CityManager: Graffiti enabled but GraffitiSpotPrefab is not assigned!");
                }

                if (generateCorridorA && _corridorPathA.Count > 0)
                {
                    if (IsLoopMode)
                    {
                        _loopState.HalfA.GraffitiStartIndex = _generatedGraffitiSpots.Count;
                        GenerateCorridorGraffitiSpotsForHalf(_corridorPathA, 0, pathMidpointIndex);
                        _loopState.HalfA.GraffitiCount = _generatedGraffitiSpots.Count - _loopState.HalfA.GraffitiStartIndex;

                        _loopState.HalfB.GraffitiStartIndex = _generatedGraffitiSpots.Count;
                        GenerateCorridorGraffitiSpotsForHalf(_corridorPathA, pathMidpointIndex, _corridorPathA.Count);
                        _loopState.HalfB.GraffitiCount = _generatedGraffitiSpots.Count - _loopState.HalfB.GraffitiStartIndex;
                    }
                    else
                    {
                        GenerateCorridorGraffitiSpots(_corridorPathA);
                    }
                }
                if (generateCorridorB && _corridorPathB.Count > 0)
                    GenerateCorridorGraffitiSpots(_corridorPathB);
                if (_corridorPathB_ToBC.Count > 0)
                    GenerateCorridorGraffitiSpots(_corridorPathB_ToBC);
                if (generateCorridorC && _corridorPathC.Count > 0)
                    GenerateCorridorGraffitiSpots(_corridorPathC);
                Debug.Log($"CityManager: Graffiti generation complete. Total graffiti spots: {_generatedGraffitiSpots.Count}");

                // Re-initialize any GraffitiSpotPools that reference this CityManager
                var graffitiPools = FindObjectsByType<GraffitiSpotPool>(FindObjectsSortMode.None);
                foreach (var pool in graffitiPools)
                {
                    if (pool.CityManager == this)
                    {
                        pool.Initialize();
                    }
                }
            }

            var rampInfo = EnableRamps ? $", {_generatedRamps.Count} ramps" : "";
            var billboardInfo = EnableBillboards ? $", {_generatedBillboards.Count} billboards" : "";
            var graffitiInfo = EnableGraffiti ? $", {_generatedGraffitiSpots.Count} graffiti spots" : "";
            var loopInfo = IsLoopMode ? " (Loop Mode)" : "";
            int corridorCount = IsLoopMode ? 1 : EnabledCorridorCount;
            Debug.Log($"CityManager: Generated {_generatedBuildings.Count} buildings across {corridorCount} corridors{rampInfo}{billboardInfo}{graffitiInfo}{loopInfo}");

            if (IsLoopMode)
            {
                Debug.Log($"CityManager Loop Mode: HalfA has {_loopState.HalfA.BuildingCount} buildings, {_loopState.HalfA.RampCount} ramps, {_loopState.HalfA.BillboardCount} billboards, {_loopState.HalfA.GraffitiCount} graffiti");
                Debug.Log($"CityManager Loop Mode: HalfB has {_loopState.HalfB.BuildingCount} buildings, {_loopState.HalfB.RampCount} ramps, {_loopState.HalfB.BillboardCount} billboards, {_loopState.HalfB.GraffitiCount} graffiti");
            }

            OnCityRegenerated?.Invoke();
        }

        private List<Vector3> GenerateCurvedPath(Vector3 start, Vector3 waypoint, int corridorIndex)
        {
            // If ConvergenceEndPoint is set, create two-segment path: start -> waypoint -> end
            if (ConvergenceEndPoint != null)
            {
                var path = new List<Vector3>();
                var endPos = ConvergenceEndPoint.position;
                endPos.y = start.y; // Maintain height

                // Segment 1: start to waypoint
                var segment1 = GenerateCurvedPathSegment(start, waypoint, corridorIndex, 0);
                path.AddRange(segment1);

                // Segment 2: waypoint to end (use different noise offset)
                var segment2 = GenerateCurvedPathSegment(waypoint, endPos, corridorIndex, 1);
                // Skip first point of segment 2 as it duplicates waypoint
                for (int i = 1; i < segment2.Count; i++)
                {
                    path.Add(segment2[i]);
                }

                return path;
            }
            else
            {
                // Original behavior: single segment from start to waypoint (endpoint)
                return GenerateCurvedPathSegment(start, waypoint, corridorIndex, 0);
            }
        }

        private List<Vector3> GenerateCurvedPathSegment(Vector3 start, Vector3 end, int corridorIndex, int segmentIndex)
        {
            var path = new List<Vector3>();
            var baseDirection = (end - start);
            baseDirection.y = 0; // Keep paths horizontal
            var distance = baseDirection.magnitude;
            baseDirection = baseDirection.normalized;

            var right = Vector3.Cross(Vector3.up, baseDirection).normalized;
            float noiseOffset = corridorIndex * 1000f + segmentIndex * 500f; // Unique noise per corridor and segment

            for (float d = 0; d <= distance; d += BuildingSpacing)
            {
                float t = d / distance;
                var basePoint = start + baseDirection * d;
                basePoint.y = start.y; // Maintain convergence point height

                // Perlin noise for organic curve (zero at endpoints for smooth connection)
                float envelope = Mathf.Sin(t * Mathf.PI); // 0 at start/end, 1 at middle
                float noise = (Mathf.PerlinNoise(d * CorridorNoiseFrequency + noiseOffset, 0f) * 2f - 1f);
                float offset = noise * CorridorNoiseAmplitude * envelope;

                path.Add(basePoint + right * offset);
            }

            // Ensure we include the endpoint
            if (path.Count > 0 && Vector3.Distance(path[path.Count - 1], end) > BuildingSpacing * 0.5f)
            {
                var endPoint = end;
                endPoint.y = start.y;
                path.Add(endPoint);
            }

            return path;
        }

        private List<Vector3> GenerateStraightPathSegment(Vector3 start, Vector3 end)
        {
            var path = new List<Vector3>();
            var baseDirection = (end - start);
            baseDirection.y = 0; // Keep paths horizontal
            var distance = baseDirection.magnitude;
            baseDirection = baseDirection.normalized;

            for (float d = 0; d <= distance; d += BuildingSpacing)
            {
                var point = start + baseDirection * d;
                point.y = start.y;
                path.Add(point);
            }

            // Ensure we include the endpoint
            if (path.Count > 0 && Vector3.Distance(path[path.Count - 1], end) > BuildingSpacing * 0.5f)
            {
                var endPoint = end;
                endPoint.y = start.y;
                path.Add(endPoint);
            }

            return path;
        }

        private List<Vector3> GenerateJunctionPath(Vector3 start, Vector3 waypoint, Vector3 junction, Vector3 end, int corridorIndex, int branchIndex = 0)
        {
            var path = new List<Vector3>();
            int baseOffset = branchIndex * 3; // Offset noise for branch uniqueness

            // Segment 1: Start to Waypoint
            var segment1 = GenerateCurvedPathSegment(start, waypoint, corridorIndex, baseOffset);
            path.AddRange(segment1);

            // Segment 2: Waypoint to Junction
            var junctionPos = junction;
            junctionPos.y = start.y;
            var segment2 = GenerateCurvedPathSegment(waypoint, junctionPos, corridorIndex, baseOffset + 1);
            for (int i = 1; i < segment2.Count; i++)
                path.Add(segment2[i]);

            // Segment 3: Junction to End
            var endPos = end;
            endPos.y = start.y;
            var segment3 = GenerateCurvedPathSegment(junctionPos, endPos, corridorIndex, baseOffset + 2);
            for (int i = 1; i < segment3.Count; i++)
                path.Add(segment3[i]);

            return path;
        }

        private void GenerateCorridorBuildings(List<Vector3> path, List<List<Vector3>> allPaths, int currentPathIndex)
        {
            var convergencePos = ConvergencePoint.position;

            for (int i = 0; i < path.Count; i++)
            {
                var point = path[i];

                // Skip buildings near start convergence plaza
                if (Vector3.Distance(point, convergencePos) < ConvergenceRadius)
                    continue;

                // Skip buildings near end convergence plaza (if enabled)
                if (ConvergenceEndPoint != null && EnableConvergenceEndPlaza)
                {
                    if (Vector3.Distance(point, ConvergenceEndPoint.position) < ConvergenceEndRadius)
                        continue;
                }

                // Skip buildings near JunctionAB
                if (EnableJunctionAB && JunctionAB != null)
                {
                    if (Vector3.Distance(point, JunctionAB.position) < JunctionRadius)
                        continue;
                }

                // Skip buildings near JunctionBC
                if (EnableJunctionBC && JunctionBC != null)
                {
                    if (Vector3.Distance(point, JunctionBC.position) < JunctionRadius)
                        continue;
                }

                // Skip buildings near FinalEndPoint
                if (EnableFinalEndPoint && FinalEndPoint != null)
                {
                    if (Vector3.Distance(point, FinalEndPoint.position) < FinalEndPointRadius)
                        continue;
                }

                // Calculate tangent direction from path
                Vector3 tangent;
                if (i < path.Count - 1)
                    tangent = (path[i + 1] - point).normalized;
                else if (i > 0)
                    tangent = (point - path[i - 1]).normalized;
                else
                    continue; // Single point path, skip

                var right = Vector3.Cross(Vector3.up, tangent).normalized;

                // Place multiple rows of buildings on both sides
                float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                for (int row = 0; row < BuildingRows; row++)
                {
                    // Only innermost row (row 0) needs colliders
                    bool needsCollider = (row == 0);

                    float rowOffset = CorridorWidth / 2 + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                    // Check left side doesn't overlap with other corridors
                    var leftPos = point - right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(leftPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(leftPos, tangent, needsCollider);
                    }

                    // Check right side doesn't overlap with other corridors
                    var rightPos = point + right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(rightPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(rightPos, tangent, needsCollider);
                    }
                }
            }
        }

        private void SetupLoopModeHalves(int pathMidpointIndex)
        {
            if (_corridorPathA.Count == 0)
                return;

            // Split path points into two halves
            _loopState.HalfA.PathPoints.Clear();
            _loopState.HalfB.PathPoints.Clear();

            for (int i = 0; i <= pathMidpointIndex && i < _corridorPathA.Count; i++)
            {
                _loopState.HalfA.PathPoints.Add(_corridorPathA[i]);
            }

            for (int i = pathMidpointIndex; i < _corridorPathA.Count; i++)
            {
                _loopState.HalfB.PathPoints.Add(_corridorPathA[i]);
            }

            // Calculate half length
            float halfLength = 0f;
            for (int i = 1; i < _loopState.HalfA.PathPoints.Count; i++)
            {
                halfLength += Vector3.Distance(_loopState.HalfA.PathPoints[i - 1], _loopState.HalfA.PathPoints[i]);
            }
            _loopState.HalfLength = halfLength;

            // Calculate forward direction (from start to midpoint)
            if (_loopState.HalfA.PathPoints.Count >= 2)
            {
                var start = _loopState.HalfA.PathPoints[0];
                var end = _loopState.HalfA.PathPoints[_loopState.HalfA.PathPoints.Count - 1];
                _loopState.ForwardDirection = (end - start).normalized;
            }

            _loopState.FrontHalfId = 0;
            _loopState.HalfA.CurrentOffset = Vector3.zero;
            _loopState.HalfB.CurrentOffset = Vector3.zero;

            Debug.Log($"CityManager Loop Mode: Path split at index {pathMidpointIndex}, half length = {halfLength:F1}m");
        }

        private void GenerateCorridorBuildingsForHalf(List<Vector3> path, List<List<Vector3>> allPaths, int currentPathIndex, int startIndex, int endIndex)
        {
            var convergencePos = ConvergencePoint.position;

            for (int i = startIndex; i < endIndex && i < path.Count; i++)
            {
                var point = path[i];

                // Skip buildings near start convergence plaza
                if (Vector3.Distance(point, convergencePos) < ConvergenceRadius)
                    continue;

                // In loop mode, skip end plaza check since we don't generate it

                // Calculate tangent direction from path
                Vector3 tangent;
                if (i < path.Count - 1)
                    tangent = (path[i + 1] - point).normalized;
                else if (i > 0)
                    tangent = (point - path[i - 1]).normalized;
                else
                    continue;

                var right = Vector3.Cross(Vector3.up, tangent).normalized;

                // Place multiple rows of buildings on both sides
                float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                for (int row = 0; row < BuildingRows; row++)
                {
                    bool needsCollider = (row == 0);
                    float rowOffset = CorridorWidth / 2 + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                    var leftPos = point - right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(leftPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(leftPos, tangent, needsCollider);
                    }

                    var rightPos = point + right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(rightPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(rightPos, tangent, needsCollider);
                    }
                }
            }
        }

        private void GenerateCorridorRampsForHalf(List<Vector3> path, int startIndex, int endIndex)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate path length for this half
            float halfLength = 0f;
            for (int i = startIndex + 1; i < endIndex && i < path.Count; i++)
            {
                halfLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute ramps in this half
            int rampsPerHalf = Mathf.Max(1, RampCount / 6); // Half of 1/3 corridors = 1/6
            float rampSpacing = halfLength / (rampsPerHalf + 1);

            float accumulatedDistance = rampSpacing;
            int pathIndex = startIndex;
            float segmentProgress = 0f;

            for (int rampNum = 0; rampNum < rampsPerHalf && pathIndex < endIndex - 1 && pathIndex < path.Count - 1; rampNum++)
            {
                while (pathIndex < endIndex - 1 && pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var rampPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        if (Vector3.Distance(rampPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;

                        if (TryPlaceRamp(rampPos, tangent))
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                        }
                        else
                        {
                            accumulatedDistance = rampSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private void GenerateCorridorBillboardsForHalf(List<Vector3> path, int startIndex, int endIndex)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate path length for this half
            float halfLength = 0f;
            for (int i = startIndex + 1; i < endIndex && i < path.Count; i++)
            {
                halfLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute billboards in this half
            int billboardsPerHalf = Mathf.Max(1, BillboardCount / 6);
            float billboardSpacing = halfLength / (billboardsPerHalf + 1);

            float accumulatedDistance = billboardSpacing;
            int pathIndex = startIndex;
            float segmentProgress = 0f;
            int billboardNum = 0;

            for (int num = 0; num < billboardsPerHalf && pathIndex < endIndex - 1 && pathIndex < path.Count - 1; num++)
            {
                while (pathIndex < endIndex - 1 && pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var billboardPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        if (Vector3.Distance(billboardPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = billboardSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;
                        bool placeOnLeft = billboardNum % 2 == 0;

                        if (TryPlaceBillboard(billboardPos, tangent, placeOnLeft))
                        {
                            accumulatedDistance = billboardSpacing;
                            segmentProgress += accumulatedDistance;
                            billboardNum++;
                        }
                        else
                        {
                            accumulatedDistance = billboardSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private bool IsPositionTooCloseToOtherCorridors(Vector3 position, List<List<Vector3>> allPaths, int excludePathIndex)
        {
            // Minimum distance from another corridor's center to place a building
            float minDistance = CorridorWidth / 2 + BuildingSetback;

            for (int pathIndex = 0; pathIndex < allPaths.Count; pathIndex++)
            {
                if (pathIndex == excludePathIndex)
                    continue;

                var otherPath = allPaths[pathIndex];
                float distToPath = GetDistanceToPath(position, otherPath);

                if (distToPath < minDistance)
                    return true;
            }

            return false;
        }

        private float GetDistanceToPath(Vector3 position, List<Vector3> path)
        {
            float minDist = float.MaxValue;

            for (int i = 0; i < path.Count - 1; i++)
            {
                float dist = DistanceToLineSegment(position, path[i], path[i + 1]);
                minDist = Mathf.Min(minDist, dist);
            }

            return minDist;
        }

        private float DistanceToLineSegment(Vector3 point, Vector3 lineStart, Vector3 lineEnd)
        {
            // Project point onto line segment (in XZ plane)
            var line = lineEnd - lineStart;
            line.y = 0;
            var toPoint = point - lineStart;
            toPoint.y = 0;

            float lineLengthSq = line.sqrMagnitude;
            if (lineLengthSq < 0.0001f)
                return toPoint.magnitude;

            float t = Mathf.Clamp01(Vector3.Dot(toPoint, line) / lineLengthSq);
            var closest = lineStart + line * t;
            closest.y = point.y;

            return Vector3.Distance(new Vector3(point.x, 0, point.z), new Vector3(closest.x, 0, closest.z));
        }

        private void GeneratePlazaRing(List<List<Vector3>> allPaths)
        {
            var convergencePos = ConvergencePoint.position;
            float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;

            // Calculate angular positions of corridor exits to leave gaps
            var corridorAngles = new List<float>();
            foreach (var path in allPaths)
            {
                if (path.Count >= 2)
                {
                    // Get direction from convergence toward corridor (use second point to get direction)
                    var dir = path[1] - convergencePos;
                    dir.y = 0;
                    float angle = Mathf.Atan2(dir.x, dir.z);
                    corridorAngles.Add(angle);
                }
            }

            // Place buildings in a ring, skipping corridor exits
            float circumference = 2 * Mathf.PI * ConvergenceRadius;
            int buildingCount = Mathf.FloorToInt(circumference / (avgBuildingWidth + BuildingSetback));
            float angleStep = 2 * Mathf.PI / buildingCount;

            // Half-width of corridor gap in radians
            float corridorGapAngle = Mathf.Atan2(CorridorWidth / 2 + BuildingSetback, ConvergenceRadius);

            for (int row = 0; row < PlazaRingRows; row++)
            {
                float ringRadius = ConvergenceRadius + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                for (int i = 0; i < buildingCount; i++)
                {
                    float angle = i * angleStep;

                    // Check if this angle is within a corridor exit gap
                    bool inCorridorGap = false;
                    foreach (float corridorAngle in corridorAngles)
                    {
                        float angleDiff = Mathf.Abs(Mathf.DeltaAngle(angle * Mathf.Rad2Deg, corridorAngle * Mathf.Rad2Deg)) * Mathf.Deg2Rad;
                        if (angleDiff < corridorGapAngle)
                        {
                            inCorridorGap = true;
                            break;
                        }
                    }

                    if (inCorridorGap)
                        continue;

                    // Place building facing inward toward plaza center
                    var pos = convergencePos + new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)) * ringRadius;
                    var facingDir = (convergencePos - pos).normalized;
                    PlaceBuilding(pos, facingDir, needsCollider: true);
                }
            }
        }

        private void GenerateEndPlazaRing(List<List<Vector3>> allPaths)
        {
            if (ConvergenceEndPoint == null)
                return;

            var endPlazaPos = ConvergenceEndPoint.position;
            endPlazaPos.y = ConvergencePoint.position.y; // Maintain height consistency
            float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;

            // Calculate angular positions of corridor entrances to leave gaps
            var corridorAngles = new List<float>();
            foreach (var path in allPaths)
            {
                if (path.Count >= 2)
                {
                    // Get direction from end plaza toward corridor (use second-to-last point to get direction)
                    var dir = path[path.Count - 2] - endPlazaPos;
                    dir.y = 0;
                    float angle = Mathf.Atan2(dir.x, dir.z);
                    corridorAngles.Add(angle);
                }
            }

            // Place buildings in a ring, skipping corridor entrances
            float circumference = 2 * Mathf.PI * ConvergenceEndRadius;
            int buildingCount = Mathf.FloorToInt(circumference / (avgBuildingWidth + BuildingSetback));
            float angleStep = 2 * Mathf.PI / buildingCount;

            // Half-width of corridor gap in radians
            float corridorGapAngle = Mathf.Atan2(CorridorWidth / 2 + BuildingSetback, ConvergenceEndRadius);

            for (int row = 0; row < EndPlazaRingRows; row++)
            {
                float ringRadius = ConvergenceEndRadius + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                for (int i = 0; i < buildingCount; i++)
                {
                    float angle = i * angleStep;

                    // Check if this angle is within a corridor entrance gap
                    bool inCorridorGap = false;
                    foreach (float corridorAngle in corridorAngles)
                    {
                        float angleDiff = Mathf.Abs(Mathf.DeltaAngle(angle * Mathf.Rad2Deg, corridorAngle * Mathf.Rad2Deg)) * Mathf.Deg2Rad;
                        if (angleDiff < corridorGapAngle)
                        {
                            inCorridorGap = true;
                            break;
                        }
                    }

                    if (inCorridorGap)
                        continue;

                    // Place building facing inward toward end plaza center
                    var pos = endPlazaPos + new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)) * ringRadius;
                    var facingDir = (endPlazaPos - pos).normalized;
                    PlaceBuilding(pos, facingDir, needsCollider: true);
                }
            }
        }

        private void PlaceBuilding(Vector3 position, Vector3 corridorDirection, bool needsCollider = true)
        {
            // Random height and width
            float height = RandomRange(BuildingHeightMin, BuildingHeightMax);
            float width = RandomRange(BuildingWidthMin, BuildingWidthMax);

            // Rotation: face perpendicular to corridor (so building faces into corridor)
            // Add some random variation (0, 90, 180, or 270 degrees offset for variety)
            float baseAngle = Mathf.Atan2(corridorDirection.x, corridorDirection.z) * Mathf.Rad2Deg;
            int rotationVariation = _random.Next(0, 4) * 90;
            var rotation = Quaternion.Euler(0, baseAngle + rotationVariation, 0);

            // Style variation
            int styleIndex = _random.Next(0, 8);

            var building = new BuildingData
            {
                Position = new Vector3(position.x, position.y + height * 0.5f, position.z),
                Scale = new Vector3(width, height, width),
                Rotation = rotation,
                NeedsCollider = needsCollider ? 1 : 0,
                StyleIndex = styleIndex
            };

            _generatedBuildings.Add(building);
        }

        private void GenerateCorridorRamps(List<Vector3> path)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate total path length for ramp distribution
            float totalLength = 0f;
            for (int i = 1; i < path.Count; i++)
            {
                totalLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute ramps evenly along this corridor (1/3 of total ramps per corridor)
            int rampsPerCorridor = Mathf.Max(1, RampCount / 3);
            float rampSpacing = totalLength / (rampsPerCorridor + 1);

            float accumulatedDistance = rampSpacing; // Start offset from convergence
            int pathIndex = 0;
            float segmentProgress = 0f;

            for (int rampNum = 0; rampNum < rampsPerCorridor && pathIndex < path.Count - 1; rampNum++)
            {
                // Find the point along the path at this distance
                while (pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        // Ramp position is within this segment
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var rampPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        // Skip if too close to start convergence plaza
                        if (Vector3.Distance(rampPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        // Skip if too close to end convergence plaza
                        if (ConvergenceEndPoint != null && EnableConvergenceEndPlaza)
                        {
                            if (Vector3.Distance(rampPos, ConvergenceEndPoint.position) < ConvergenceEndRadius)
                            {
                                accumulatedDistance = rampSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionAB
                        if (EnableJunctionAB && JunctionAB != null)
                        {
                            if (Vector3.Distance(rampPos, JunctionAB.position) < JunctionRadius)
                            {
                                accumulatedDistance = rampSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionBC
                        if (EnableJunctionBC && JunctionBC != null)
                        {
                            if (Vector3.Distance(rampPos, JunctionBC.position) < JunctionRadius)
                            {
                                accumulatedDistance = rampSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to FinalEndPoint
                        if (EnableFinalEndPoint && FinalEndPoint != null)
                        {
                            if (Vector3.Distance(rampPos, FinalEndPoint.position) < FinalEndPointRadius)
                            {
                                accumulatedDistance = rampSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Calculate tangent at this point
                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;

                        // Try to place ramp
                        if (TryPlaceRamp(rampPos, tangent))
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                        }
                        else
                        {
                            // Skip this position, try next
                            accumulatedDistance = rampSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        // Move to next segment
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private bool TryPlaceRamp(Vector3 position, Vector3 direction)
        {
            // Random dimensions
            float length = RandomRange(RampLengthMin, RampLengthMax);
            float width = RandomRange(RampWidthMin, RampWidthMax);
            float angle = RandomRange(RampAngleMin, RampAngleMax);
            float depth = 0.5f; // Thickness of the ramp

            // Calculate vertical rise based on angle and length
            float angleRad = angle * Mathf.Deg2Rad;
            float rampRun = length * Mathf.Cos(angleRad);

            // Ramp faces along corridor direction
            float yaw = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
            var finalRotation = Quaternion.Euler(-angle, yaw, 0f);

            // Position Y: Place ramp so back-bottom edge sits flush with ground
            float yOffset = (depth * 0.5f * Mathf.Cos(angleRad)) + (length * 0.5f * Mathf.Sin(angleRad));
            yOffset += RampYOffset;

            var rampPosition = new Vector3(position.x, position.y + yOffset, position.z);

            // Create bounds for collision checks
            float rampPadding = 1.5f;
            var rampMin = new Vector3(
                rampPosition.x - width * 0.5f - rampPadding,
                0f,
                rampPosition.z - rampRun * 0.5f - rampPadding
            );
            var rampMax = new Vector3(
                rampPosition.x + width * 0.5f + rampPadding,
                10f,
                rampPosition.z + rampRun * 0.5f + rampPadding
            );

            // Check if ramp intersects any buildings
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

                if (rampMin.x < buildingMax.x && rampMax.x > buildingMin.x &&
                    rampMin.z < buildingMax.z && rampMax.z > buildingMin.z)
                {
                    return false;
                }
            }

            // Check if ramp intersects any existing ramps
            foreach (var existingRamp in _generatedRamps)
            {
                float existingAngleRad = existingRamp.Angle * Mathf.Deg2Rad;
                float existingRun = existingRamp.Scale.z * Mathf.Cos(existingAngleRad);
                float existingWidth = existingRamp.Scale.x;

                var existingMin = new Vector3(
                    existingRamp.Position.x - existingWidth * 0.5f - rampPadding,
                    0f,
                    existingRamp.Position.z - existingRun * 0.5f - rampPadding
                );
                var existingMax = new Vector3(
                    existingRamp.Position.x + existingWidth * 0.5f + rampPadding,
                    10f,
                    existingRamp.Position.z + existingRun * 0.5f + rampPadding
                );

                if (rampMin.x < existingMax.x && rampMax.x > existingMin.x &&
                    rampMin.z < existingMax.z && rampMax.z > existingMin.z)
                {
                    return false;
                }
            }

            var ramp = new RampData
            {
                Position = rampPosition,
                Scale = new Vector3(width, depth, length),
                Rotation = finalRotation,
                Angle = angle
            };

            _generatedRamps.Add(ramp);
            return true;
        }

        private void GenerateCorridorBillboards(List<Vector3> path)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate total path length for billboard distribution
            float totalLength = 0f;
            for (int i = 1; i < path.Count; i++)
            {
                totalLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute billboards evenly along this corridor (1/3 of total billboards per corridor)
            int billboardsPerCorridor = Mathf.Max(1, BillboardCount / 3);
            float billboardSpacing = totalLength / (billboardsPerCorridor + 1);

            float accumulatedDistance = billboardSpacing; // Start offset from convergence
            int pathIndex = 0;
            float segmentProgress = 0f;

            for (int billboardNum = 0; billboardNum < billboardsPerCorridor && pathIndex < path.Count - 1; billboardNum++)
            {
                // Find the point along the path at this distance
                while (pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        // Billboard position is within this segment
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var billboardPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        // Skip if too close to start convergence plaza
                        if (Vector3.Distance(billboardPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = billboardSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        // Skip if too close to end convergence plaza
                        if (ConvergenceEndPoint != null && EnableConvergenceEndPlaza)
                        {
                            if (Vector3.Distance(billboardPos, ConvergenceEndPoint.position) < ConvergenceEndRadius)
                            {
                                accumulatedDistance = billboardSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionAB
                        if (EnableJunctionAB && JunctionAB != null)
                        {
                            if (Vector3.Distance(billboardPos, JunctionAB.position) < JunctionRadius)
                            {
                                accumulatedDistance = billboardSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionBC
                        if (EnableJunctionBC && JunctionBC != null)
                        {
                            if (Vector3.Distance(billboardPos, JunctionBC.position) < JunctionRadius)
                            {
                                accumulatedDistance = billboardSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to FinalEndPoint
                        if (EnableFinalEndPoint && FinalEndPoint != null)
                        {
                            if (Vector3.Distance(billboardPos, FinalEndPoint.position) < FinalEndPointRadius)
                            {
                                accumulatedDistance = billboardSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Calculate tangent at this point
                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;

                        // Alternate left and right sides
                        bool placeOnLeft = billboardNum % 2 == 0;
                        if (TryPlaceBillboard(billboardPos, tangent, placeOnLeft))
                        {
                            accumulatedDistance = billboardSpacing;
                            segmentProgress += accumulatedDistance;
                        }
                        else
                        {
                            // Skip this position, try next
                            accumulatedDistance = billboardSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        // Move to next segment
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private bool TryPlaceBillboard(Vector3 pathPosition, Vector3 tangent, bool placeOnLeft)
        {
            // Random dimensions
            float width = RandomRange(BillboardWidthMin, BillboardWidthMax);
            float height = RandomRange(BillboardHeightMin, BillboardHeightMax);
            float depth = BillboardDepth;

            // Calculate perpendicular direction (right of path)
            var right = Vector3.Cross(Vector3.up, tangent).normalized;

            // Billboard faces INWARD toward the corridor center
            // If on left side, normal points right (+right)
            // If on right side, normal points left (-right)
            var normal = placeOnLeft ? right : -right;

            // Position: on the corridor-facing surface of buildings, offset inward
            float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
            float sideOffset = CorridorWidth / 2 + BuildingSetback - avgBuildingWidth / 2 - BillboardInwardOffset;
            var position = pathPosition + (placeOnLeft ? -right : right) * sideOffset;

            // Randomize Y offset within range
            float yOffset = RandomRange(BillboardYOffsetMin, BillboardYOffsetMax);
            position.y = pathPosition.y + yOffset + height * 0.5f;

            // Rotation: face into corridor
            // The billboard's forward (-Z) should point toward corridor center (same as normal)
            float yaw = Mathf.Atan2(normal.x, normal.z) * Mathf.Rad2Deg;
            var rotation = Quaternion.Euler(0f, yaw, 0f);

            // Check if billboard intersects any existing billboards (simplified 2D check)
            float billboardPadding = 2.0f;
            foreach (var existingBillboard in _generatedBillboards)
            {
                float dx = Mathf.Abs(position.x - existingBillboard.Position.x);
                float dz = Mathf.Abs(position.z - existingBillboard.Position.z);
                float minDistX = (width + existingBillboard.Scale.x) * 0.5f + billboardPadding;
                float minDistZ = (width + existingBillboard.Scale.x) * 0.5f + billboardPadding;

                if (dx < minDistX && dz < minDistZ)
                {
                    return false;
                }
            }

            var billboard = new BillboardData
            {
                Position = position,
                Scale = new Vector3(width, height, depth),
                Rotation = rotation,
                Normal = normal
            };

            _generatedBillboards.Add(billboard);
            return true;
        }

        private void GenerateCorridorGraffitiSpots(List<Vector3> path)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate total path length for graffiti distribution
            float totalLength = 0f;
            for (int i = 1; i < path.Count; i++)
            {
                totalLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute graffiti evenly along this corridor (1/3 of total graffiti per corridor)
            int graffitiPerCorridor = Mathf.Max(1, GraffitiCount / 3);

            // Determine how many go on billboards vs walls
            int graffitiOnBillboards = Mathf.RoundToInt(graffitiPerCorridor * GraffitiOnBillboardPercent);
            int graffitiOnWalls = graffitiPerCorridor - graffitiOnBillboards;

            // Place graffiti on billboards first
            PlaceGraffitiOnBillboards(graffitiOnBillboards);

            // Then place remaining on walls
            float graffitiSpacing = totalLength / (graffitiOnWalls + 1);

            float accumulatedDistance = graffitiSpacing;
            int pathIndex = 0;
            float segmentProgress = 0f;

            for (int graffitiNum = 0; graffitiNum < graffitiOnWalls && pathIndex < path.Count - 1; graffitiNum++)
            {
                while (pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var graffitiPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        // Skip if too close to start convergence plaza
                        if (Vector3.Distance(graffitiPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = graffitiSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        // Skip if too close to end convergence plaza
                        if (ConvergenceEndPoint != null && EnableConvergenceEndPlaza)
                        {
                            if (Vector3.Distance(graffitiPos, ConvergenceEndPoint.position) < ConvergenceEndRadius)
                            {
                                accumulatedDistance = graffitiSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionAB
                        if (EnableJunctionAB && JunctionAB != null)
                        {
                            if (Vector3.Distance(graffitiPos, JunctionAB.position) < JunctionRadius)
                            {
                                accumulatedDistance = graffitiSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to JunctionBC
                        if (EnableJunctionBC && JunctionBC != null)
                        {
                            if (Vector3.Distance(graffitiPos, JunctionBC.position) < JunctionRadius)
                            {
                                accumulatedDistance = graffitiSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Skip if too close to FinalEndPoint
                        if (EnableFinalEndPoint && FinalEndPoint != null)
                        {
                            if (Vector3.Distance(graffitiPos, FinalEndPoint.position) < FinalEndPointRadius)
                            {
                                accumulatedDistance = graffitiSpacing;
                                segmentProgress += accumulatedDistance;
                                continue;
                            }
                        }

                        // Calculate tangent at this point
                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;

                        // Alternate left and right sides
                        bool placeOnLeft = graffitiNum % 2 == 0;
                        if (TryPlaceGraffitiSpotOnWall(graffitiPos, tangent, placeOnLeft))
                        {
                            accumulatedDistance = graffitiSpacing;
                            segmentProgress += accumulatedDistance;
                        }
                        else
                        {
                            // Skip this position, try next
                            accumulatedDistance = graffitiSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        // Move to next segment
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private void GenerateCorridorGraffitiSpotsForHalf(List<Vector3> path, int startIndex, int endIndex)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate path length for this half
            float halfLength = 0f;
            for (int i = startIndex + 1; i < endIndex && i < path.Count; i++)
            {
                halfLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute graffiti in this half
            int graffitiPerHalf = Mathf.Max(1, GraffitiCount / 6);

            // Determine how many go on billboards vs walls
            int graffitiOnBillboards = Mathf.RoundToInt(graffitiPerHalf * GraffitiOnBillboardPercent);
            int graffitiOnWalls = graffitiPerHalf - graffitiOnBillboards;

            // Place graffiti on billboards first
            PlaceGraffitiOnBillboards(graffitiOnBillboards);

            // Then place remaining on walls
            float graffitiSpacing = halfLength / (graffitiOnWalls + 1);

            float accumulatedDistance = graffitiSpacing;
            int pathIndex = startIndex;
            float segmentProgress = 0f;
            int graffitiNum = 0;

            for (int num = 0; num < graffitiOnWalls && pathIndex < endIndex - 1 && pathIndex < path.Count - 1; num++)
            {
                while (pathIndex < endIndex - 1 && pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var graffitiPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        if (Vector3.Distance(graffitiPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = graffitiSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;
                        bool placeOnLeft = graffitiNum % 2 == 0;

                        if (TryPlaceGraffitiSpotOnWall(graffitiPos, tangent, placeOnLeft))
                        {
                            accumulatedDistance = graffitiSpacing;
                            segmentProgress += accumulatedDistance;
                            graffitiNum++;
                        }
                        else
                        {
                            accumulatedDistance = graffitiSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private void PlaceGraffitiOnBillboards(int count)
        {
            if (_generatedBillboards.Count == 0 || count <= 0)
                return;

            // Track which billboards already have graffiti
            var usedBillboardIndices = new HashSet<int>();
            foreach (var graffiti in _generatedGraffitiSpots)
            {
                if (graffiti.BillboardIndex >= 0)
                    usedBillboardIndices.Add(graffiti.BillboardIndex);
            }

            // Try to place graffiti on random unused billboards
            int placed = 0;
            int maxAttempts = count * 3;
            int attempts = 0;

            while (placed < count && attempts < maxAttempts)
            {
                attempts++;

                // Pick a random billboard
                int billboardIndex = _random.Next(_generatedBillboards.Count);

                if (usedBillboardIndices.Contains(billboardIndex))
                    continue;

                var billboard = _generatedBillboards[billboardIndex];

                // Ensure graffiti stays fully within billboard bounds
                float graffitiSize = 2f; // Approximate graffiti decal size
                float margin = graffitiSize * 0.5f + 0.5f; // Half size plus extra margin

                // Skip billboards that are too small for graffiti
                if (billboard.Scale.y < graffitiSize + 1f || billboard.Scale.x < graffitiSize + 1f)
                    continue;

                // Y position: keep graffiti fully within billboard height
                float billboardBottom = billboard.Position.y - billboard.Scale.y * 0.5f;
                float billboardTop = billboard.Position.y + billboard.Scale.y * 0.5f;
                float minY = billboardBottom + margin;
                float maxY = billboardTop - margin;
                float yPos = RandomRange(minY, maxY);

                // X offset along billboard width (in billboard's local space)
                float maxXOffset = billboard.Scale.x * 0.5f - margin;
                float xOffset = RandomRange(-maxXOffset, maxXOffset);

                // Calculate position: start at billboard center, offset in front, then adjust
                var billboardRight = billboard.Rotation * Vector3.right;
                var position = billboard.Position + billboard.Normal * 0.5f; // In front of billboard
                position += billboardRight * xOffset; // Horizontal offset along billboard
                position.y = yPos;

                // DecalProjector projects along -Z
                // billboard.Normal points toward corridor, so forward (+Z) = billboard.Normal
                // This makes -Z point into the billboard surface
                var graffitiRotation = Quaternion.LookRotation(billboard.Normal, Vector3.up);

                var graffiti = new GraffitiSpotData
                {
                    Position = position,
                    Rotation = graffitiRotation,
                    Normal = -billboard.Normal, // Direction decal projects (into billboard)
                    BillboardIndex = billboardIndex
                };

                _generatedGraffitiSpots.Add(graffiti);
                usedBillboardIndices.Add(billboardIndex);
                placed++;
            }
        }

        private bool TryPlaceGraffitiSpotOnWall(Vector3 pathPosition, Vector3 tangent, bool placeOnLeft)
        {
            // Calculate perpendicular direction (right of path)
            var right = Vector3.Cross(Vector3.up, tangent).normalized;

            // Find the nearest building on the correct side
            var searchDirection = placeOnLeft ? -right : right;
            var building = FindNearestBuildingOnSide(pathPosition, searchDirection);

            if (building == null)
            {
                return false; // No building found on this side
            }

            var buildingData = building.Value;

            // Calculate position on the building's corridor-facing surface
            // The corridor-facing surface is the side closest to the path
            float halfWidth = buildingData.Scale.x * 0.5f;
            float halfDepth = buildingData.Scale.z * 0.5f;

            // Determine which face of the building faces the corridor
            var toPath = pathPosition - buildingData.Position;
            toPath.y = 0;

            // Get building's local axes from rotation
            var buildingForward = buildingData.Rotation * Vector3.forward;
            var buildingRight = buildingData.Rotation * Vector3.right;

            // Find which axis is most aligned with the direction to the path
            float dotForward = Vector3.Dot(toPath.normalized, buildingForward);
            float dotRight = Vector3.Dot(toPath.normalized, buildingRight);

            Vector3 surfaceNormal;
            Vector3 surfaceOffset;

            if (Mathf.Abs(dotForward) > Mathf.Abs(dotRight))
            {
                // Front or back face
                surfaceNormal = dotForward > 0 ? buildingForward : -buildingForward;
                surfaceOffset = surfaceNormal * halfDepth;
            }
            else
            {
                // Left or right face
                surfaceNormal = dotRight > 0 ? buildingRight : -buildingRight;
                surfaceOffset = surfaceNormal * halfWidth;
            }

            // Position in front of the building surface (toward corridor)
            // surfaceNormal points toward corridor, so add offset in that direction
            // DecalProjector projects 5.29 units backward, so we need enough offset to prevent clipping
            var position = buildingData.Position + surfaceOffset + surfaceNormal * GraffitiWallOffset;

            // Add random horizontal offset along the wall surface
            var alongWall = Vector3.Cross(Vector3.up, surfaceNormal).normalized;

            // Determine the wall's half-extent based on which face we're on
            // For front/back face (Z), wall extends in X direction
            // For left/right face (X), wall extends in Z direction
            float wallHalfExtent;
            var localNormal = Quaternion.Inverse(buildingData.Rotation) * surfaceNormal;
            if (Mathf.Abs(localNormal.z) > Mathf.Abs(localNormal.x))
            {
                wallHalfExtent = halfWidth;  // X extent for Z-facing wall
            }
            else
            {
                wallHalfExtent = halfDepth;  // Z extent for X-facing wall
            }

            // Calculate safe offset range that keeps graffiti corners within wall
            float graffitiHalfWidth = GraffitiProjectionWidth * 0.5f;
            float safeMaxOffset = wallHalfExtent - GraffitiEdgeClearance - graffitiHalfWidth;

            if (safeMaxOffset <= 0)
            {
                return false; // Building wall too narrow for graffiti
            }

            float randomOffset = RandomRange(-safeMaxOffset, safeMaxOffset);
            position += alongWall * randomOffset;

            // Calculate safe Y range that keeps graffiti corners within building height
            float graffitiHalfHeight = GraffitiProjectionHeight * 0.5f;
            float buildingTop = buildingData.Position.y + buildingData.Scale.y * 0.5f;
            float buildingBottom = buildingData.Position.y - buildingData.Scale.y * 0.5f;

            // Safe Y range: far enough from edges that graffiti fits entirely
            float safeYMin = buildingBottom + GraffitiEdgeClearance + graffitiHalfHeight;
            float safeYMax = buildingTop - GraffitiEdgeClearance - graffitiHalfHeight;

            if (safeYMax <= safeYMin)
            {
                return false; // Building too short for graffiti
            }

            // Also respect player-reachable height constraints
            float playerYMin = pathPosition.y + GraffitiYOffsetMin;
            float playerYMax = pathPosition.y + GraffitiYOffsetMax;

            // Clamp to intersection of safe range and player range
            float actualYMin = Mathf.Max(safeYMin, playerYMin);
            float actualYMax = Mathf.Min(safeYMax, playerYMax);

            if (actualYMax <= actualYMin)
            {
                return false; // No valid Y range for this building
            }

            position.y = RandomRange(actualYMin, actualYMax);

            // Check spacing from other graffiti spots
            foreach (var existingGraffiti in _generatedGraffitiSpots)
            {
                float dx = position.x - existingGraffiti.Position.x;
                float dz = position.z - existingGraffiti.Position.z;
                float distSq = dx * dx + dz * dz;

                if (distSq < GraffitiMinSpacing * GraffitiMinSpacing)
                {
                    return false;
                }
            }

            // Check that graffiti doesn't partially overlap with any billboard
            // We check all 4 corners of the graffiti projection area to detect split images
            // (graffitiHalfWidth and graffitiHalfHeight are already defined above)

            // Get vectors along the wall surface for calculating corners
            var graffitiRight = Vector3.Cross(Vector3.up, surfaceNormal).normalized;
            var graffitiUp = Vector3.up;

            // Calculate the 4 corners of where graffiti would project on the wall
            var corners = new Vector3[4]
            {
                position + graffitiRight * graffitiHalfWidth + graffitiUp * graffitiHalfHeight,
                position + graffitiRight * graffitiHalfWidth - graffitiUp * graffitiHalfHeight,
                position - graffitiRight * graffitiHalfWidth + graffitiUp * graffitiHalfHeight,
                position - graffitiRight * graffitiHalfWidth - graffitiUp * graffitiHalfHeight,
            };

            // Check that all 4 corners stay within the target building's surface
            foreach (var corner in corners)
            {
                if (!IsPointOnBuildingSurface(corner, buildingData, surfaceNormal, margin: 0.5f))
                {
                    return false; // Graffiti would extend beyond building surface
                }
            }

            // Check that no other buildings intersect the graffiti projection
            if (DoesGraffitiIntersectOtherBuildings(corners, buildingData, surfaceNormal))
            {
                return false; // Another building would catch part of the projection
            }

            foreach (var billboard in _generatedBillboards)
            {
                int cornersInBillboard = 0;

                foreach (var corner in corners)
                {
                    if (IsPointInsideBillboard(corner, billboard))
                    {
                        cornersInBillboard++;
                    }
                }

                // If some but not all corners are inside billboard = split image = reject
                if (cornersInBillboard > 0 && cornersInBillboard < 4)
                {
                    return false; // Would split across billboard and wall
                }

                // If all 4 corners inside, also reject (graffiti fully on billboard - use billboard placement instead)
                if (cornersInBillboard == 4)
                {
                    return false;
                }
            }

            // Rotation: DecalProjector projects along -Z (backward)
            // surfaceNormal points toward corridor (away from wall)
            // We want -Z to point at wall, so forward (+Z) should point toward corridor = surfaceNormal
            var rotation = Quaternion.LookRotation(surfaceNormal, Vector3.up);

            var graffiti = new GraffitiSpotData
            {
                Position = position,
                Rotation = rotation,
                Normal = -surfaceNormal, // Normal points INTO wall
                BillboardIndex = -1 // Not on a billboard
            };

            _generatedGraffitiSpots.Add(graffiti);
            return true;
        }

        private BuildingData? FindNearestBuildingOnSide(Vector3 pathPosition, Vector3 searchDirection)
        {
            BuildingData? nearest = null;
            float nearestDistSq = float.MaxValue;
            float maxSearchDistance = CorridorWidth + BuildingWidthMax * 2;

            foreach (var building in _generatedBuildings)
            {
                // Only consider innermost row buildings (those with colliders)
                if (building.NeedsCollider == 0)
                    continue;

                var toBuilding = building.Position - pathPosition;
                toBuilding.y = 0;

                // Check if building is in the correct direction
                float dot = Vector3.Dot(toBuilding.normalized, searchDirection);
                if (dot < 0.5f) // Must be roughly in the search direction
                    continue;

                float distSq = toBuilding.sqrMagnitude;
                if (distSq > maxSearchDistance * maxSearchDistance)
                    continue;

                if (distSq < nearestDistSq)
                {
                    nearestDistSq = distSq;
                    nearest = building;
                }
            }

            return nearest;
        }

        private bool IsPointInsideBillboard(Vector3 point, BillboardData billboard)
        {
            // Transform point to billboard's local space
            var toPoint = point - billboard.Position;
            var localPos = Quaternion.Inverse(billboard.Rotation) * toPoint;

            // Check if point is within billboard bounds (with small margin)
            float halfWidth = billboard.Scale.x * 0.5f;
            float halfHeight = billboard.Scale.y * 0.5f;
            float halfDepth = billboard.Scale.z * 0.5f + 0.5f; // Extra depth margin for projection

            return Mathf.Abs(localPos.x) <= halfWidth &&
                   Mathf.Abs(localPos.y) <= halfHeight &&
                   Mathf.Abs(localPos.z) <= halfDepth;
        }

        private bool IsPointOnBuildingSurface(Vector3 point, BuildingData building, Vector3 surfaceNormal, float margin = 0f)
        {
            // Transform point to building's local space
            var toPoint = point - building.Position;
            var localPos = Quaternion.Inverse(building.Rotation) * toPoint;

            float halfWidth = building.Scale.x * 0.5f - margin;
            float halfHeight = building.Scale.y * 0.5f - margin;
            float halfDepth = building.Scale.z * 0.5f - margin;

            // Determine which face based on surface normal (in building local space)
            var localNormal = Quaternion.Inverse(building.Rotation) * surfaceNormal;

            // Check bounds based on which face we're on
            if (Mathf.Abs(localNormal.z) > Mathf.Abs(localNormal.x))
            {
                // Front/back face - check X and Y bounds
                return Mathf.Abs(localPos.x) <= halfWidth &&
                       Mathf.Abs(localPos.y) <= halfHeight;
            }
            else
            {
                // Left/right face - check Z and Y bounds
                return Mathf.Abs(localPos.z) <= halfDepth &&
                       Mathf.Abs(localPos.y) <= halfHeight;
            }
        }

        private bool DoesGraffitiIntersectOtherBuildings(Vector3[] corners, BuildingData targetBuilding, Vector3 surfaceNormal)
        {
            float projectionDepth = 6f; // Slightly more than DecalProjector depth (5.29)

            foreach (var building in _generatedBuildings)
            {
                // Skip the target building
                if (building.Position == targetBuilding.Position)
                    continue;

                // Only check nearby buildings (innermost row)
                if (building.NeedsCollider == 0)
                    continue;

                // Check if any corner falls within this building's corridor-facing surface projection area
                foreach (var corner in corners)
                {
                    if (IsPointInBuildingProjectionVolume(corner, building, surfaceNormal, projectionDepth))
                        return true;
                }
            }
            return false;
        }

        private bool IsPointInBuildingProjectionVolume(Vector3 point, BuildingData building, Vector3 corridorNormal, float projectionDepth)
        {
            // Transform point to building's local space
            var toPoint = point - building.Position;
            var localPos = Quaternion.Inverse(building.Rotation) * toPoint;
            var localNormal = Quaternion.Inverse(building.Rotation) * corridorNormal;

            float halfWidth = building.Scale.x * 0.5f;
            float halfHeight = building.Scale.y * 0.5f;
            float halfDepth = building.Scale.z * 0.5f;

            // Determine which face of this building faces the corridor based on the corridor normal
            // The corridor-facing surface is the one whose outward normal aligns with corridorNormal
            if (Mathf.Abs(localNormal.z) > Mathf.Abs(localNormal.x))
            {
                // Front/back face (Z face)
                float surfaceZ = localNormal.z > 0 ? halfDepth : -halfDepth;

                // Check if point is within X,Y bounds and within projection depth of the surface
                if (Mathf.Abs(localPos.x) <= halfWidth &&
                    Mathf.Abs(localPos.y) <= halfHeight)
                {
                    // Point is in front of surface (toward corridor) and within projection depth
                    float distFromSurface = localNormal.z > 0 ? (localPos.z - surfaceZ) : (surfaceZ - localPos.z);
                    if (distFromSurface >= 0 && distFromSurface <= projectionDepth)
                        return true;
                }
            }
            else
            {
                // Left/right face (X face)
                float surfaceX = localNormal.x > 0 ? halfWidth : -halfWidth;

                // Check if point is within Z,Y bounds and within projection depth of the surface
                if (Mathf.Abs(localPos.z) <= halfDepth &&
                    Mathf.Abs(localPos.y) <= halfHeight)
                {
                    // Point is in front of surface (toward corridor) and within projection depth
                    float distFromSurface = localNormal.x > 0 ? (localPos.x - surfaceX) : (surfaceX - localPos.x);
                    if (distFromSurface >= 0 && distFromSurface <= projectionDepth)
                        return true;
                }
            }

            return false;
        }

        private float RandomRange(float min, float max)
        {
            return min + (float)_random.NextDouble() * (max - min);
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

            // Calculate render bounds based on all corridor points
            Vector3 minBounds = Vector3.one * float.MaxValue;
            Vector3 maxBounds = Vector3.one * float.MinValue;

            void ExpandBounds(Vector3 point)
            {
                minBounds = Vector3.Min(minBounds, point);
                maxBounds = Vector3.Max(maxBounds, point);
            }

            if (HasValidCorridorSetup)
            {
                ExpandBounds(ConvergencePoint.position);
                if (EndpointA != null) ExpandBounds(EndpointA.position);
                if (EndpointB != null) ExpandBounds(EndpointB.position);
                if (EndpointC != null) ExpandBounds(EndpointC.position);
                if (ConvergenceEndPoint != null) ExpandBounds(ConvergenceEndPoint.position);
                if (JunctionAB != null) ExpandBounds(JunctionAB.position);
                if (JunctionBC != null) ExpandBounds(JunctionBC.position);
                if (FinalEndPoint != null) ExpandBounds(FinalEndPoint.position);
            }

            // Add padding and ensure minimum size
            var boundsCenter = (minBounds + maxBounds) * 0.5f;
            var boundsSize = maxBounds - minBounds;
            boundsSize = Vector3.Max(boundsSize, Vector3.one * 500f); // Minimum bounds
            boundsSize += Vector3.one * 200f; // Padding
            boundsSize.y = BuildingHeightMax + 100f; // Height based on buildings
            boundsCenter.y = BuildingHeightMax * 0.5f;

            _renderBounds = new Bounds(boundsCenter, boundsSize);

            // Create property block for material
            _propertyBlock = new MaterialPropertyBlock();
            _propertyBlock.SetBuffer("_BuildingBuffer", _buildingBuffer);

            // Initialize offset uniforms (default to zero for non-loop mode)
            _propertyBlock.SetVector("_HalfAOffset", Vector3.zero);
            _propertyBlock.SetVector("_HalfBOffset", Vector3.zero);
            _propertyBlock.SetInt("_HalfBStartIndex", int.MaxValue);

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

            // Initialize offset uniforms (default to zero for non-loop mode)
            _rampPropertyBlock.SetVector("_HalfAOffset", Vector3.zero);
            _rampPropertyBlock.SetVector("_HalfBOffset", Vector3.zero);
            _rampPropertyBlock.SetInt("_HalfBStartIndex", int.MaxValue);

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

        private void InitializeBillboardBuffersFromSerializedData()
        {
            if (_generatedBillboards.Count == 0)
            {
                Debug.Log("CityManager: No billboards to initialize buffers for.");
                return;
            }

            if (BillboardMesh == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize billboard buffers - BillboardMesh is null. Assign a cube mesh.");
                return;
            }

            if (BillboardMaterial == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize billboard buffers - BillboardMaterial is null. Assign BillboardMaterial from Assets/HolyRail/Materials/");
                return;
            }

            Debug.Log($"CityManager: Initializing billboard buffers for {_generatedBillboards.Count} billboards...");

            // Release any existing billboard buffers
            ReleaseBillboardBuffers();

            int billboardStride = Marshal.SizeOf<BillboardData>();

            // Create and populate billboard buffer from serialized data
            _billboardBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, _generatedBillboards.Count, billboardStride);
            _billboardBuffer.SetData(_generatedBillboards.ToArray());

            // Create indirect args buffer for RenderMeshIndirect
            _billboardArgsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, 5 * sizeof(uint));
            uint[] args = new uint[]
            {
                BillboardMesh.GetIndexCount(0),
                (uint)_generatedBillboards.Count,
                BillboardMesh.GetIndexStart(0),
                BillboardMesh.GetBaseVertex(0),
                0
            };
            _billboardArgsBuffer.SetData(args);

            // Create property block for billboard material
            _billboardPropertyBlock = new MaterialPropertyBlock();
            _billboardPropertyBlock.SetBuffer("_BillboardBuffer", _billboardBuffer);

            // Initialize offset uniforms (default to zero for non-loop mode)
            _billboardPropertyBlock.SetVector("_HalfAOffset", Vector3.zero);
            _billboardPropertyBlock.SetVector("_HalfBOffset", Vector3.zero);
            _billboardPropertyBlock.SetInt("_HalfBStartIndex", int.MaxValue);

            _billboardBuffersInitialized = true;
            Debug.Log($"CityManager: Billboard buffers initialized successfully. Mesh: {BillboardMesh.name}, Material: {BillboardMaterial.name}");
        }

        private void RenderBillboards()
        {
            if (_billboardArgsBuffer == null || _billboardPropertyBlock == null)
                return;

            // Update material buffer reference
            _billboardPropertyBlock.SetBuffer("_BillboardBuffer", _billboardBuffer);

            var renderParams = new RenderParams(BillboardMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _billboardPropertyBlock,
                shadowCastingMode = ShadowCastingMode.On,
                receiveShadows = true
            };

            Graphics.RenderMeshIndirect(renderParams, BillboardMesh, _billboardArgsBuffer);
        }

        private void ReleaseBillboardBuffers()
        {
            _billboardBuffer?.Release();
            _billboardArgsBuffer?.Release();

            _billboardBuffer = null;
            _billboardArgsBuffer = null;

            _billboardBuffersInitialized = false;
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
            _argsBuffer?.Release();

            _buildingBuffer = null;
            _argsBuffer = null;

            _buffersInitialized = false;
        }

        [ContextMenu("Clear")]
        public void Clear()
        {
            ReleaseBuffers();
            ReleaseRampBuffers();
            ReleaseBillboardBuffers();
            _generatedBuildings.Clear();
            _generatedRamps.Clear();
            _generatedBillboards.Clear();
            _generatedGraffitiSpots.Clear();
            _corridorPathA.Clear();
            _corridorPathB.Clear();
            _corridorPathC.Clear();

            // Reset loop state
            _loopState = new LoopModeState();
            _loopOffsetsNeedUpdate = true;

            // Find and clear any BuildingColliderPools that reference this CityManager
            var colliderPools = FindObjectsByType<BuildingColliderPool>(FindObjectsSortMode.None);
            foreach (var pool in colliderPools)
            {
                if (pool.CityManager == this)
                {
                    pool.Clear();
                }
            }

            // Find and clear any GraffitiSpotPools that reference this CityManager
            var graffitiPools = FindObjectsByType<GraffitiSpotPool>(FindObjectsSortMode.None);
            foreach (var pool in graffitiPools)
            {
                if (pool.CityManager == this)
                {
                    pool.Clear();
                }
            }
        }

        /// <summary>
        /// Applies a position offset to the specified loop half.
        /// Uses offset-based rendering - only tracks the offset, does NOT modify CPU data.
        /// GPU shaders apply the offset during rendering.
        /// </summary>
        public void ApplyOffsetToHalf(LoopHalfData half, Vector3 offset)
        {
            if (!_loopState.IsActive || half == null)
                return;

            // Track the cumulative offset (no CPU data modification needed)
            half.CurrentOffset += offset;

            // Update path points for this half (these are still needed for gameplay logic)
            for (int i = 0; i < half.PathPoints.Count; i++)
            {
                half.PathPoints[i] += offset;
            }

            // Mark that shader offsets need updating
            _loopOffsetsNeedUpdate = true;

            Debug.Log($"CityManager: Applied offset {offset} to half {half.HalfId} (offset-based, no CPU data modified)");
        }

        /// <summary>
        /// Updates shader uniforms to apply half offsets during rendering.
        /// This is the zero-rebuild approach - no GPU buffer uploads, just uniform updates.
        /// </summary>
        public void UpdateHalfOffsets()
        {
            if (!_loopState.IsActive)
                return;

            // Calculate the relative offset (HalfB offset relative to HalfA)
            // Since HalfA is at index 0, its offset is used as the base
            var halfAOffset = _loopState.HalfA.CurrentOffset;
            var halfBOffset = _loopState.HalfB.CurrentOffset;

            // Update building shader uniforms
            if (_propertyBlock != null)
            {
                _propertyBlock.SetVector("_HalfAOffset", halfAOffset);
                _propertyBlock.SetVector("_HalfBOffset", halfBOffset);
                _propertyBlock.SetInt("_HalfBStartIndex", _loopState.HalfB.BuildingStartIndex);
            }

            // Update ramp shader uniforms
            if (_rampPropertyBlock != null)
            {
                _rampPropertyBlock.SetVector("_HalfAOffset", halfAOffset);
                _rampPropertyBlock.SetVector("_HalfBOffset", halfBOffset);
                _rampPropertyBlock.SetInt("_HalfBStartIndex", _loopState.HalfB.RampStartIndex);
            }

            // Update billboard shader uniforms
            if (_billboardPropertyBlock != null)
            {
                _billboardPropertyBlock.SetVector("_HalfAOffset", halfAOffset);
                _billboardPropertyBlock.SetVector("_HalfBOffset", halfBOffset);
                _billboardPropertyBlock.SetInt("_HalfBStartIndex", _loopState.HalfB.BillboardStartIndex);
            }

            // Expand render bounds to accommodate moved geometry
            ExpandRenderBoundsForOffsets();
        }

        /// <summary>
        /// Expands render bounds to encompass all possible positions based on current half offsets.
        /// </summary>
        private void ExpandRenderBoundsForOffsets()
        {
            if (_generatedBuildings.Count == 0 && _generatedBillboards.Count == 0)
                return;

            // Expand bounds to include both half offsets
            var maxOffset = Vector3.Max(
                new Vector3(Mathf.Abs(_loopState.HalfA.CurrentOffset.x), Mathf.Abs(_loopState.HalfA.CurrentOffset.y), Mathf.Abs(_loopState.HalfA.CurrentOffset.z)),
                new Vector3(Mathf.Abs(_loopState.HalfB.CurrentOffset.x), Mathf.Abs(_loopState.HalfB.CurrentOffset.y), Mathf.Abs(_loopState.HalfB.CurrentOffset.z))
            );

            // Expand size by maximum offset plus padding
            var newSize = _renderBounds.size + maxOffset * 2f + Vector3.one * 100f;
            var newCenter = _renderBounds.center + (_loopState.HalfA.CurrentOffset + _loopState.HalfB.CurrentOffset) * 0.25f;

            _renderBounds = new Bounds(newCenter, newSize);
        }

        /// <summary>
        /// Re-uploads all geometry data to GPU buffers after positions have changed.
        /// Uses cached arrays to avoid allocations during leapfrog operations.
        /// </summary>
        public void RefreshGPUBuffers()
        {
            RefreshGPUBuffersWithOffset(Vector3.zero);
        }

        /// <summary>
        /// Re-uploads all geometry data to GPU buffers after positions have changed.
        /// Expands render bounds by the given offset to avoid iterating all geometry.
        /// </summary>
        public void RefreshGPUBuffersWithOffset(Vector3 offset)
        {
            if (_buildingBuffer != null && _generatedBuildings.Count > 0)
            {
                // Resize cache if needed
                if (_buildingArrayCache == null || _buildingArrayCache.Length < _generatedBuildings.Count)
                {
                    _buildingArrayCache = new BuildingData[_generatedBuildings.Count];
                }
                _generatedBuildings.CopyTo(_buildingArrayCache);
                _buildingBuffer.SetData(_buildingArrayCache, 0, 0, _generatedBuildings.Count);
            }

            if (_rampBuffer != null && _generatedRamps.Count > 0)
            {
                // Resize cache if needed
                if (_rampArrayCache == null || _rampArrayCache.Length < _generatedRamps.Count)
                {
                    _rampArrayCache = new RampData[_generatedRamps.Count];
                }
                _generatedRamps.CopyTo(_rampArrayCache);
                _rampBuffer.SetData(_rampArrayCache, 0, 0, _generatedRamps.Count);
            }

            if (_billboardBuffer != null && _generatedBillboards.Count > 0)
            {
                // Resize cache if needed
                if (_billboardArrayCache == null || _billboardArrayCache.Length < _generatedBillboards.Count)
                {
                    _billboardArrayCache = new BillboardData[_generatedBillboards.Count];
                }
                _generatedBillboards.CopyTo(_billboardArrayCache);
                _billboardBuffer.SetData(_billboardArrayCache, 0, 0, _generatedBillboards.Count);
            }

            // Expand render bounds incrementally rather than recalculating from all geometry
            ExpandRenderBounds(offset);
        }

        /// <summary>
        /// Expands _renderBounds to encompass geometry that moved by the given offset.
        /// This is much faster than iterating all geometry during leapfrogs.
        /// </summary>
        private void ExpandRenderBounds(Vector3 offset)
        {
            if (_generatedBuildings.Count == 0 && _generatedBillboards.Count == 0)
                return;

            // If this is the first time or we don't have valid bounds, do a full recalculation
            if (_renderBounds.size.magnitude < 1f)
            {
                RecalculateRenderBoundsFull();
                return;
            }

            // Expand bounds to include the new positions of moved geometry
            // The offset tells us how far geometry moved, so we expand in that direction
            if (offset.sqrMagnitude > 0.01f)
            {
                // Expand bounds to include both old and new positions
                // Add the offset magnitude plus padding to the bounds in the offset direction
                float expansion = offset.magnitude + 100f;
                var expandedSize = _renderBounds.size + new Vector3(
                    Mathf.Abs(offset.x) > 0.01f ? expansion : 0f,
                    Mathf.Abs(offset.y) > 0.01f ? expansion : 0f,
                    Mathf.Abs(offset.z) > 0.01f ? expansion : 0f
                );
                var newCenter = _renderBounds.center + offset * 0.5f;
                _renderBounds = new Bounds(newCenter, expandedSize);
            }
        }

        /// <summary>
        /// Full recalculation of _renderBounds from all geometry positions.
        /// Only called on initialization or when bounds are invalid.
        /// </summary>
        private void RecalculateRenderBoundsFull()
        {
            if (_generatedBuildings.Count == 0 && _generatedBillboards.Count == 0)
                return;

            // Find min/max extents of all geometry
            var min = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue);
            var max = new Vector3(float.MinValue, float.MinValue, float.MinValue);

            foreach (var building in _generatedBuildings)
            {
                var pos = building.Position;
                var halfHeight = building.Scale.y * 0.5f;
                min = Vector3.Min(min, pos - new Vector3(50f, 0f, 50f));
                max = Vector3.Max(max, pos + new Vector3(50f, halfHeight * 2f, 50f));
            }

            foreach (var billboard in _generatedBillboards)
            {
                var pos = billboard.Position;
                var scale = billboard.Scale;
                min = Vector3.Min(min, pos - new Vector3(scale.x, 0f, scale.x));
                max = Vector3.Max(max, pos + new Vector3(scale.x, scale.y, scale.x));
            }

            // Add padding for safety
            min -= Vector3.one * 50f;
            max += Vector3.one * 50f;

            _renderBounds = new Bounds((min + max) * 0.5f, max - min);
        }

        /// <summary>
        /// Notifies all BuildingColliderPools to resync their spatial grids after a leapfrog.
        /// </summary>
        public void ResyncColliderPool()
        {
            // Use cached pools to avoid GC allocations from FindObjectsByType
            if (_cachedColliderPools != null)
            {
                foreach (var pool in _cachedColliderPools)
                {
                    if (pool != null && pool.CityManager == this)
                    {
                        pool.ResyncAfterLeapfrog();
                    }
                }
            }

            if (_cachedGraffitiPools != null)
            {
                foreach (var pool in _cachedGraffitiPools)
                {
                    if (pool != null && pool.CityManager == this)
                    {
                        pool.ResyncAfterLeapfrog();
                    }
                }
            }
        }

        /// <summary>
        /// Defers collider pool resync to the next frame to spread out leapfrog work.
        /// </summary>
        public void ResyncColliderPoolDeferred()
        {
            StartCoroutine(ResyncColliderPoolNextFrame());
        }

        private System.Collections.IEnumerator ResyncColliderPoolNextFrame()
        {
            // Wait until the end of frame so GPU buffer upload can complete
            yield return new WaitForEndOfFrame();

            // Use cached pools to avoid GC allocations from FindObjectsByType
            if (_cachedColliderPools != null)
            {
                foreach (var pool in _cachedColliderPools)
                {
                    if (pool != null && pool.CityManager == this)
                    {
                        // Use async version to spread spatial grid rebuild over multiple frames
                        pool.ResyncAfterLeapfrogAsync();
                    }
                }
            }

            if (_cachedGraffitiPools != null)
            {
                foreach (var pool in _cachedGraffitiPools)
                {
                    if (pool != null && pool.CityManager == this)
                    {
                        pool.ResyncAfterLeapfrog();
                    }
                }
            }
        }

        /// <summary>
        /// Performs a leapfrog operation, moving the back half to the front.
        /// Called by LoopModeController when player reaches the trigger threshold.
        /// Note: Prefer using MoveHalf() directly from LoopModeController for position-based half selection.
        /// </summary>
        public void TriggerLeapfrog()
        {
            if (!_loopState.IsActive)
                return;

            // Get back half (the one that's not currently front)
            var backHalf = _loopState.FrontHalfId == 0 ? _loopState.HalfB : _loopState.HalfA;

            // Calculate offset: move back half forward by two half-lengths (to become the new front)
            Vector3 offset = _loopState.ForwardDirection * _loopState.HalfLength * 2f;

            // Apply offset to half (only updates tracked offset, no CPU data modification)
            ApplyOffsetToHalf(backHalf, offset);

            // Update shader uniforms for offset-based rendering (no GPU buffer upload!)
            UpdateHalfOffsets();

            // Swap front/back identities
            _loopState.FrontHalfId = (_loopState.FrontHalfId + 1) % 2;

            // Resync collider pool (now uses offsets instead of rebuilding)
            ResyncColliderPool();

            Debug.Log($"CityManager: Leapfrog complete (zero-rebuild). New front half is {_loopState.FrontHalfId}");
        }

        /// <summary>
        /// Moves geometry for a specific half by the given offset.
        /// Called by LoopModeController after determining which half to move based on player position.
        /// Uses zero-rebuild approach - updates offsets instead of GPU buffers.
        /// </summary>
        public void MoveHalf(int halfId, Vector3 offset)
        {
            if (!_loopState.IsActive)
                return;

            var sw = System.Diagnostics.Stopwatch.StartNew();

            var half = halfId == 0 ? _loopState.HalfA : _loopState.HalfB;
            ApplyOffsetToHalf(half, offset);
            var applyTime = sw.ElapsedMilliseconds;

            UpdateHalfOffsets();
            var updateTime = sw.ElapsedMilliseconds;

            ResyncColliderPoolDeferred();
            var resyncTime = sw.ElapsedMilliseconds;

            Debug.Log($"CityManager: Moved half {halfId} by {offset.magnitude:F1}m (zero-rebuild) - ApplyOffset:{applyTime}ms, UpdateUniforms:{updateTime - applyTime}ms, ResyncColliders:{resyncTime - updateTime}ms, Total:{resyncTime}ms");
        }

        /// <summary>
        /// Gets the front half data for loop mode.
        /// </summary>
        public LoopHalfData GetFrontHalf()
        {
            if (!_loopState.IsActive)
                return null;
            return _loopState.FrontHalfId == 0 ? _loopState.HalfA : _loopState.HalfB;
        }

        /// <summary>
        /// Gets the back half data for loop mode.
        /// </summary>
        public LoopHalfData GetBackHalf()
        {
            if (!_loopState.IsActive)
                return null;
            return _loopState.FrontHalfId == 0 ? _loopState.HalfB : _loopState.HalfA;
        }

        private void OnDisable()
        {
            // Only release GPU buffers, keep serialized data for persistence
            ReleaseBuffers();
            ReleaseRampBuffers();
            ReleaseBillboardBuffers();
        }

        private void OnDestroy()
        {
            ReleaseBuffers();
            ReleaseRampBuffers();
            ReleaseBillboardBuffers();
        }

        private void OnValidate()
        {
            // Auto-regenerate in editor when properties change
            if (AutoGenerateInEditor && !Application.isPlaying && HasValidCorridorSetup)
            {
                // Delay the generation to avoid issues during serialization
                #if UNITY_EDITOR
                UnityEditor.EditorApplication.delayCall += () =>
                {
                    if (this != null && AutoGenerateInEditor && !Application.isPlaying)
                    {
                        Generate();
                    }
                };
                #endif
            }
        }

        private void OnDrawGizmosSelected()
        {
            if (!ShowBounds)
                return;

            // Draw convergence point and radius
            if (ConvergencePoint != null)
            {
                // Inner plaza radius (open area)
                Gizmos.color = new Color(1f, 0.8f, 0f, 0.8f);
                Gizmos.DrawWireSphere(ConvergencePoint.position, ConvergenceRadius);
                Gizmos.color = new Color(1f, 0.8f, 0f, 0.3f);
                Gizmos.DrawSphere(ConvergencePoint.position, 5f);

                // Plaza ring outer edge (if enabled)
                if (EnablePlazaRing)
                {
                    float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                    float outerRingRadius = ConvergenceRadius + BuildingSetback + (PlazaRingRows - 1) * (avgBuildingWidth + BuildingSetback) + avgBuildingWidth;
                    Gizmos.color = new Color(1f, 0.5f, 0f, 0.5f);
                    Gizmos.DrawWireSphere(ConvergencePoint.position, outerRingRadius);
                }
            }

            // Draw convergence end point and radius (destination plaza)
            if (ConvergenceEndPoint != null)
            {
                // Inner end plaza radius (open area)
                Gizmos.color = new Color(0f, 0.8f, 1f, 0.8f);
                Gizmos.DrawWireSphere(ConvergenceEndPoint.position, ConvergenceEndRadius);
                Gizmos.color = new Color(0f, 0.8f, 1f, 0.3f);
                Gizmos.DrawSphere(ConvergenceEndPoint.position, 5f);

                // End plaza ring outer edge (if enabled)
                if (EnableConvergenceEndPlaza)
                {
                    float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                    float outerRingRadius = ConvergenceEndRadius + BuildingSetback + (EndPlazaRingRows - 1) * (avgBuildingWidth + BuildingSetback) + avgBuildingWidth;
                    Gizmos.color = new Color(0f, 0.5f, 1f, 0.5f);
                    Gizmos.DrawWireSphere(ConvergenceEndPoint.position, outerRingRadius);
                }
            }

            // Draw junction points (brighter when enabled)
            if (JunctionAB != null)
            {
                Gizmos.color = EnableJunctionAB ? Color.magenta : new Color(0.5f, 0.25f, 0.5f, 0.4f);
                Gizmos.DrawWireSphere(JunctionAB.position, JunctionRadius);
                Gizmos.DrawSphere(JunctionAB.position, 3f);
            }

            if (JunctionBC != null)
            {
                Gizmos.color = EnableJunctionBC ? Color.magenta : new Color(0.5f, 0.25f, 0.5f, 0.4f);
                Gizmos.DrawWireSphere(JunctionBC.position, JunctionRadius);
                Gizmos.DrawSphere(JunctionBC.position, 3f);
            }

            // Draw final end point
            if (FinalEndPoint != null)
            {
                Gizmos.color = EnableFinalEndPoint ? Color.red : new Color(0.5f, 0.25f, 0.25f, 0.4f);
                Gizmos.DrawSphere(FinalEndPoint.position, 5f);
                if (ConvergenceEndPoint != null)
                    Gizmos.DrawLine(ConvergenceEndPoint.position, FinalEndPoint.position);
            }

            // Draw waypoint endpoints (enabled corridors shown brighter)
            if (EndpointA != null)
            {
                Gizmos.color = EnableCorridorA ? new Color(0f, 1f, 0.5f, 0.8f) : new Color(0.5f, 0.5f, 0.5f, 0.4f);
                Gizmos.DrawSphere(EndpointA.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointA.position);
                if (ConvergenceEndPoint != null && EnableCorridorA)
                    Gizmos.DrawLine(EndpointA.position, ConvergenceEndPoint.position);
            }
            if (EndpointB != null)
            {
                Gizmos.color = EnableCorridorB ? new Color(0f, 1f, 0.5f, 0.8f) : new Color(0.5f, 0.5f, 0.5f, 0.4f);
                Gizmos.DrawSphere(EndpointB.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointB.position);
                if (ConvergenceEndPoint != null && EnableCorridorB)
                    Gizmos.DrawLine(EndpointB.position, ConvergenceEndPoint.position);
            }
            if (EndpointC != null)
            {
                Gizmos.color = EnableCorridorC ? new Color(0f, 1f, 0.5f, 0.8f) : new Color(0.5f, 0.5f, 0.5f, 0.4f);
                Gizmos.DrawSphere(EndpointC.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointC.position);
                if (ConvergenceEndPoint != null && EnableCorridorC)
                    Gizmos.DrawLine(EndpointC.position, ConvergenceEndPoint.position);
            }

            // Draw generated corridor paths with width
            Gizmos.color = new Color(0.2f, 0.6f, 1f, 0.5f);
            DrawCorridorPath(_corridorPathA);
            DrawCorridorPath(_corridorPathB);
            DrawCorridorPath(_corridorPathC);

            // Draw B branch paths (orange)
            Gizmos.color = new Color(1f, 0.5f, 0f, 0.5f);
            if (_corridorPathB_ToAB != null && _corridorPathB_ToAB.Count > 0)
                DrawCorridorPath(_corridorPathB_ToAB);
            if (_corridorPathB_ToBC != null && _corridorPathB_ToBC.Count > 0)
                DrawCorridorPath(_corridorPathB_ToBC);
        }

        private void DrawCorridorPath(List<Vector3> path)
        {
            if (path == null || path.Count < 2)
                return;

            for (int i = 0; i < path.Count - 1; i++)
            {
                var current = path[i];
                var next = path[i + 1];

                // Draw center line
                Gizmos.DrawLine(current + Vector3.up * 2f, next + Vector3.up * 2f);

                // Draw corridor width
                var direction = (next - current).normalized;
                var right = Vector3.Cross(Vector3.up, direction).normalized;
                float halfWidth = CorridorWidth * 0.5f;

                Gizmos.DrawLine(current + right * halfWidth + Vector3.up, next + right * halfWidth + Vector3.up);
                Gizmos.DrawLine(current - right * halfWidth + Vector3.up, next - right * halfWidth + Vector3.up);
            }
        }
    }
}
