using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
using StarterAssets;
using HolyRail.City;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.Vines
{
    public enum AttractorMode
    {
        Surface,
        Volume,
        Mixed,
        Free,  // Independent flowing splines without branching
        Path,  // Follows CityManager corridors
        Billboard  // Cable splines connecting billboards
    }

    // Level chunk spline characteristics as RANGES (extracted from LevelChunk prefabs)
    public static class LevelChunkRules
    {
        // Height variation range (Y span per spline)
        public const float HeightVariationMin = 0.7f;
        public const float HeightVariationMax = 7.5f;

        // Lateral span range (X displacement)
        public const float LateralSpanMin = 9.5f;
        public const float LateralSpanMax = 20f;

        // Noise frequency range (lower = smoother curves)
        public const float FrequencyMin = 0.08f;
        public const float FrequencyMax = 0.2f;

        // Curviness ratio range (lateral/forward)
        public const float CurvinessMin = 0.5f;
        public const float CurvinessMax = 0.65f;
    }

    [ExecuteInEditMode]
    public class VineGenerator : MonoBehaviour
    {
        private const int FixedPointScale = 10000;
        private const int MaxNodes = 50000;
        private const int ThreadGroupSize = 64;

        [System.Serializable]
        [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Sequential)]
        public struct VineNode
        {
            public Vector3 Position;
            public int ParentIndex;
            public int IsTip;
            public int LastGrowIteration;  // Track when this node last grew for branching cooldown
        }

        [System.Serializable]
        [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Sequential)]
        public struct VineAttractor
        {
            public Vector3 Position;
            public int Active;
        }

        private struct AttractorTarget
        {
            public Vector3 Position;
            public Vector3 Normal;
            public float Weight;
            public bool IsBillboard;
        }

        [Header("Editor")]
        [field: SerializeField] public bool AutoRegenerate { get; set; } = false;

        [Header("Algorithm Settings")]
        [field: SerializeField] public ComputeShader VineComputeShader { get; private set; }
        [field: SerializeField] public int Seed { get; set; } = 12345;
        [field: SerializeField, Range(1, 500)] public int MaxIterations { get; set; } = 100;
        [field: SerializeField] public float StepSize { get; set; } = 0.3f;
        [field: SerializeField] public float AttractionRadius { get; set; } = 5f;
        [field: SerializeField, Range(0.01f, 1f)] public float KillRadius { get; set; } = 0.2f;

        [Header("Attractor Generation")]
        [field: SerializeField] public int AttractorCount { get; set; } = 5000;
        [field: SerializeField] public LayerMask AttractorSurfaceLayers { get; set; } = ~0;
        [field: SerializeField] public Bounds AttractorBounds { get; set; } = new Bounds(Vector3.zero, Vector3.one * 10f);
        [field: SerializeField, Range(0f, 2f)] public float AttractorSurfaceOffset { get; set; } = 0.1f;
        [field: SerializeField] public bool UseMultiDirectionRaycasts { get; set; } = true;
        [field: SerializeField] public AttractorMode AttractorGenerationMode { get; set; } = AttractorMode.Surface;

        [Header("Root Points")]
        [field: SerializeField] public List<Transform> RootPoints { get; private set; } = new List<Transform>();

        [Header("Noise")]
        [field: SerializeField, Range(0f, 1f)] public float NoiseStrength { get; set; } = 0.1f;
        [field: SerializeField] public float NoiseScale { get; set; } = 1f;

        [Header("Branching")]
        [field: SerializeField, Range(0f, 1f)] public float BranchDensity { get; set; } = 0.3f;
        public int EffectiveBranchCooldown => Mathf.RoundToInt(Mathf.Lerp(15, 1, BranchDensity));

        [Header("Branch Separation")]
        [field: SerializeField, Range(0f, 5f)] public float MinBranchSeparation { get; set; } = 0f;

        [Header("Obstacle Avoidance")]
        [field: SerializeField] public bool EnableObstacleAvoidance { get; set; } = false;
        [field: SerializeField, Range(0.1f, 5f)] public float ObstacleAvoidanceDistance { get; set; } = 0.5f;

        [Header("Direction Bias")]
        [field: SerializeField] public Vector3 ForwardDirection { get; set; } = Vector3.forward;
        [field: SerializeField, Range(0f, 2f)] public float ForwardBias { get; set; } = 0.5f;

        [Header("Free Mode Settings")]
        [field: SerializeField] public int FreeSplineCount { get; set; } = 10;
        [field: SerializeField] public Vector2 FreeLengthRange { get; set; } = new Vector2(20f, 50f);
        [field: SerializeField] public int FreePointsPerSpline { get; set; } = 20;
        [field: SerializeField] public Vector3 FreeNoiseAmplitude { get; set; } = new Vector3(2f, 2f, 0f);  // Right, Up, Forward
        [field: SerializeField] public Vector3 FreeNoiseFrequency { get; set; } = new Vector3(0.5f, 0.3f, 0f);  // Right, Up, Forward

        [Header("Path Mode Settings")]
        [field: SerializeField] public CityManager CityManager { get; set; }
        [field: SerializeField] public int VinesPerCorridor { get; set; } = 3;
        [field: SerializeField] public Vector2 PathLengthRange { get; set; } = new Vector2(50f, 200f);
        [field: SerializeField] public float PathCorridorWidth { get; set; } = 20f;
        [field: SerializeField] public float PathStartOffset { get; set; } = 10f;
        [field: SerializeField] public bool StartBelowGround { get; set; } = true;
        [field: SerializeField] public float GroundStartDepth { get; set; } = 5f;
        [field: SerializeField] public bool PathEnableBillboardVines { get; set; } = false;

        [Header("Path Mode - Attraction")]
        [field: SerializeField, Range(0f, 1f)]
        public float BillboardAttractionStrength { get; set; } = 0f;

        [field: SerializeField, Range(0f, 1f)]
        public float GraffitiAttractionStrength { get; set; } = 0f;

        [field: SerializeField]
        public float AttractorSearchRadius { get; set; } = 50f;

        [Header("Billboard Mode Settings")]
        [field: SerializeField] public float BillboardMaxConnectionDistance { get; set; } = 100f;
        [field: SerializeField] public float BillboardSagAmount { get; set; } = 5f;
        [field: SerializeField] public int BillboardPointsPerSpline { get; set; } = 15;
        [field: SerializeField, Range(0f, 1f)] public float BillboardConnectionOffset { get; set; } = 0.1f;
        [field: SerializeField] public float BillboardInwardOffset { get; set; } = 2f;
        [field: SerializeField] public bool BillboardSameSideOnly { get; set; } = true;

        [Header("Level Chunk Influence")]
        [field: SerializeField, Range(0f, 1f)]
        public float LevelChunkInfluence { get; set; } = 0f;

        [Header("Volume Height")]
        [field: SerializeField]
        public Vector2 VolumeHeightRange { get; set; } = new Vector2(2f, 15f);  // Min/max Y height for vine spawning

        [Header("Vine Spacing")]
        [field: SerializeField]
        public float MinVineSpacing { get; set; } = 5f;  // Minimum distance between vine start points

        [Header("Ground Vines")]
        [field: SerializeField, Range(0f, 1f)]
        public float GroundVineRatio { get; set; } = 0f;  // Ratio of vines that emerge from ground level

        [HideInInspector]
        [field: SerializeField]
        public float VineStartRange { get; set; } = 0.8f;  // Legacy - kept for old methods

        [Header("Visualization")]
        [field: SerializeField] public bool ShowAttractors { get; set; } = true;
        [field: SerializeField] public bool ShowNodes { get; set; } = true;
        [field: SerializeField] public bool ShowConnections { get; set; } = true;
        [field: SerializeField] public Color AttractorColor { get; set; } = Color.cyan;
        [field: SerializeField] public Color NodeColor { get; set; } = Color.green;
        [field: SerializeField] public Color ConnectionColor { get; set; } = Color.yellow;
        [field: SerializeField] public float GizmoSize { get; set; } = 0.05f;
        [field: SerializeField, Range(0.05f, 1f)] public float AttractorGizmoSize { get; set; } = 0.15f;

        [Header("Spline Conversion")]
        [field: SerializeField, Range(2, 100)] public int MinSplineLength { get; set; } = 2;
        [field: SerializeField, Range(10, 1000)] public int MaxSplineCount { get; set; } = 200;
        [field: SerializeField, Range(0f, 10f)] public float MinSplineWorldLength { get; set; } = 0.5f;

        [Header("Path Smoothing")]
        [field: SerializeField] public bool EnablePathSmoothing { get; set; } = true;
        [field: SerializeField, Range(0f, 1f)] public float SmoothingTolerance { get; set; } = 0.15f;

        [Header("Mesh Rendering")]
        [field: SerializeField] public Material VineMaterial { get; set; }
        [field: SerializeField, Range(0.01f, 0.5f)] public float VineRadius { get; set; } = 0.05f;
        [field: SerializeField, Range(3, 16)] public int VineSegments { get; set; } = 4;
        [field: SerializeField, Range(4, 64)] public int VineSegmentsPerUnit { get; set; } = 4;
        [field: SerializeField] public bool GenerateMeshes { get; set; } = true;

        [Header("Pickup Spawning")]
        [field: SerializeField] public GameObject PickUpPrefab { get; set; }
        [field: SerializeField] public int PickUpCount { get; set; } = 3;
        [field: SerializeField, Range(0.05f, 0.45f)] public float MinPickUpSpacing { get; set; } = 0.1f;
        [field: SerializeField] public float PickUpHeightOffset { get; set; } = 1.0f;

        [Header("Glow Effects")]
        [field: SerializeField] public float GlowLength { get; set; } = 8f;
        [field: SerializeField] public float GlowBrightness { get; set; } = 1f;
        [field: SerializeField] public float GlowShowHideDuration { get; set; } = 0.25f;

        // Branch connection data for rail grinding transitions
        [System.Serializable]
        public class BranchConnection
        {
            public SplineContainer FromSpline;
            public bool FromEnd; // true = end of spline (t=1), false = start of spline (t=0)
            public List<SplineContainer> ConnectedSplines = new List<SplineContainer>();
        }

        // Generated data (serialized to persist through Play mode)
        [SerializeField, HideInInspector]
        private List<VineNode> _generatedNodes = new List<VineNode>();
        [SerializeField, HideInInspector]
        private List<VineAttractor> _generatedAttractors = new List<VineAttractor>();
        [SerializeField, HideInInspector]
        private List<SplineContainer> _generatedSplines = new List<SplineContainer>();
        [SerializeField, HideInInspector]
        private List<BranchConnection> _branchConnections = new List<BranchConnection>();

        // Loop mode vine tracking
        [SerializeField, HideInInspector]
        private List<SplineContainer> _halfASplines = new List<SplineContainer>();
        [SerializeField, HideInInspector]
        private List<SplineContainer> _halfBSplines = new List<SplineContainer>();

        public IReadOnlyList<SplineContainer> HalfASplines => _halfASplines;
        public IReadOnlyList<SplineContainer> HalfBSplines => _halfBSplines;

        // Compute buffers
        private ComputeBuffer _nodeBuffer;
        private ComputeBuffer _attractorBuffer;
        private ComputeBuffer _voteXBuffer;
        private ComputeBuffer _voteYBuffer;
        private ComputeBuffer _voteZBuffer;
        private ComputeBuffer _voteCountBuffer;
        private ComputeBuffer _counterBuffer;

        // Kernel indices
        private int _clearVotesKernel;
        private int _voteKernel;
        private int _growKernel;
        private int _pruneKernel;

        // Cached glow material (loaded from Assets)
        private Material _scrollingGradientMaterial;

        private Material GetScrollingGradientMaterial()
        {
            if (_scrollingGradientMaterial == null)
            {
#if UNITY_EDITOR
                _scrollingGradientMaterial = AssetDatabase.LoadAssetAtPath<Material>(
                    "Assets/HolyRail/Materials/ScrollingGradient.mat");
#endif
            }
            return _scrollingGradientMaterial;
        }

        public int NodeCount => _generatedNodes.Count;
        public int AttractorCount_Active => _generatedAttractors.FindAll(a => a.Active == 1).Count;
        public int SplineCount => _generatedSplines.Count;
        public bool HasData => _generatedNodes.Count > 0;
        public IReadOnlyList<BranchConnection> BranchConnections => _branchConnections;

        public List<SplineContainer> GetConnectedSplines(SplineContainer fromSpline, bool atEnd)
        {
            foreach (var connection in _branchConnections)
            {
                if (connection.FromSpline == fromSpline && connection.FromEnd == atEnd)
                {
                    return connection.ConnectedSplines;
                }
            }
            return null;
        }

        public void Regenerate()
        {
            if (AttractorGenerationMode != AttractorMode.Free && AttractorGenerationMode != AttractorMode.Path && VineComputeShader == null)
            {
                Debug.LogError("VineGenerator: ComputeShader is not assigned!");
                return;
            }

            if (AttractorGenerationMode != AttractorMode.Free && AttractorGenerationMode != AttractorMode.Path && RootPoints.Count == 0)
            {
                Debug.LogError("VineGenerator: No root points assigned!");
                return;
            }

            Clear();

            // Free mode bypasses attractors and GPU algorithm
            if (AttractorGenerationMode == AttractorMode.Free)
            {
                GenerateFreeSplines();
                Debug.Log($"VineGenerator (Free): Generated {_generatedNodes.Count} nodes across {FreeSplineCount} splines");
                return;
            }

            // Path mode follows CityManager corridors
            if (AttractorGenerationMode == AttractorMode.Path)
            {
                GeneratePathSplines();
                return;
            }

            // Billboard mode connects billboards with sagging cables
            if (AttractorGenerationMode == AttractorMode.Billboard)
            {
                GenerateBillboardSplines();
                return;
            }

            // Step 1: Generate attractors via raycasts
            GenerateAttractorsFromScene();

            if (_generatedAttractors.Count == 0)
            {
                Debug.LogWarning("VineGenerator: No attractors generated. Check bounds and layer mask.");
                return;
            }

            // Step 2: Initialize root nodes
            InitializeRootNodes();

            // Step 3: Run GPU algorithm
            RunGPUAlgorithm();

            Debug.Log($"VineGenerator: Generated {_generatedNodes.Count} nodes from {_generatedAttractors.Count} attractors");

            // Debug: Report closest attractor distance from each root
            if (_generatedNodes.Count <= RootPoints.Count && _generatedAttractors.Count > 0)
            {
                foreach (var root in RootPoints)
                {
                    if (root == null) continue;
                    float minDist = float.MaxValue;
                    foreach (var att in _generatedAttractors)
                    {
                        float dist = Vector3.Distance(root.position, att.Position);
                        if (dist < minDist) minDist = dist;
                    }
                    Debug.Log($"VineGenerator: Root '{root.name}' at {root.position} - nearest attractor is {minDist:F2} units away (AttractionRadius = {AttractionRadius})");
                }
            }
        }

        private void GenerateAttractorsFromScene()
        {
            var random = new System.Random(Seed);
            _generatedAttractors = new List<VineAttractor>();

            switch (AttractorGenerationMode)
            {
                case AttractorMode.Surface:
                    GenerateSurfaceAttractors(random, AttractorCount);
                    break;
                case AttractorMode.Volume:
                    GenerateVolumeAttractors(random, AttractorCount);
                    break;
                case AttractorMode.Mixed:
                    GenerateSurfaceAttractors(random, AttractorCount / 2);
                    GenerateVolumeAttractors(random, AttractorCount / 2);
                    break;
            }

            // Filter out attractors that are inside or near obstacles
            FilterAttractorsNearObstacles();
        }

        private void FilterAttractorsNearObstacles()
        {
            if (!EnableObstacleAvoidance)
                return;

            int originalCount = _generatedAttractors.Count;
            _generatedAttractors = _generatedAttractors
                .Where(a => !Physics.CheckSphere(a.Position, ObstacleAvoidanceDistance))
                .ToList();

            int removed = originalCount - _generatedAttractors.Count;
            if (removed > 0)
                Debug.Log($"VineGenerator: Filtered {removed} attractors near obstacles");
        }

        private void GenerateSurfaceAttractors(System.Random random, int count)
        {
            var directions = UseMultiDirectionRaycasts
                ? new[]
                {
                    Vector3.down, Vector3.up,
                    Vector3.left, Vector3.right,
                    Vector3.forward, Vector3.back
                }
                : new[] { Vector3.down };

            float maxRayDist = Mathf.Max(AttractorBounds.size.x, AttractorBounds.size.y, AttractorBounds.size.z);

            for (int i = 0; i < count; i++)
            {
                var point = RandomPointInBounds(random, AttractorBounds);
                var dir = directions[i % directions.Length];

                if (Physics.Raycast(point, dir, out var hit, maxRayDist, AttractorSurfaceLayers))
                {
                    _generatedAttractors.Add(new VineAttractor
                    {
                        Position = hit.point + hit.normal * AttractorSurfaceOffset,
                        Active = 1
                    });
                }
            }
        }

        private void GenerateVolumeAttractors(System.Random random, int count)
        {
            for (int i = 0; i < count; i++)
            {
                var point = RandomPointInBounds(random, AttractorBounds);
                _generatedAttractors.Add(new VineAttractor
                {
                    Position = point,
                    Active = 1
                });
            }
        }

        private void GenerateFreeSplines()
        {
            var random = new System.Random(Seed);
            _generatedNodes.Clear();
            _generatedAttractors.Clear();  // Free mode doesn't use attractors

            var forward = ForwardDirection.normalized;
            // Handle case where forward is parallel to up
            var right = Mathf.Abs(Vector3.Dot(forward, Vector3.up)) > 0.99f
                ? Vector3.Cross(Vector3.forward, forward).normalized
                : Vector3.Cross(Vector3.up, forward).normalized;
            var up = Vector3.Cross(forward, right);

            // Project bounds onto local axes to get extents
            var boundsCenter = AttractorBounds.center;
            var boundsSize = AttractorBounds.size;

            // Calculate extent along each axis using absolute dot products
            float forwardExtent = (Mathf.Abs(forward.x) * boundsSize.x +
                                   Mathf.Abs(forward.y) * boundsSize.y +
                                   Mathf.Abs(forward.z) * boundsSize.z) * 0.5f;
            float rightExtent = (Mathf.Abs(right.x) * boundsSize.x +
                                 Mathf.Abs(right.y) * boundsSize.y +
                                 Mathf.Abs(right.z) * boundsSize.z) * 0.5f;
            float upExtent = (Mathf.Abs(up.x) * boundsSize.x +
                              Mathf.Abs(up.y) * boundsSize.y +
                              Mathf.Abs(up.z) * boundsSize.z) * 0.5f;

            for (int splineIdx = 0; splineIdx < FreeSplineCount; splineIdx++)
            {
                // Random length for this spline
                float splineLength = Mathf.Lerp(FreeLengthRange.x, FreeLengthRange.y, (float)random.NextDouble());

                // Random starting position within bounds
                // Constrain forward position so spline fits: start can be anywhere from back to (front - length)
                float maxForwardStart = forwardExtent - splineLength;
                float forwardStart = Mathf.Lerp(-forwardExtent, maxForwardStart, (float)random.NextDouble());

                // Random position on perpendicular plane (full bounds extent)
                float rightPos = Mathf.Lerp(-rightExtent, rightExtent, (float)random.NextDouble());
                float upPos = Mathf.Lerp(-upExtent, upExtent, (float)random.NextDouble());

                var startPos = boundsCenter + forward * forwardStart + right * rightPos + up * upPos;

                // Generate the spline path
                int pointCount = FreePointsPerSpline;

                // Noise offset unique to this spline for variation (different seed per axis)
                float noiseOffsetRight = splineIdx * 100f;
                float noiseOffsetUp = splineIdx * 100f + 33f;
                float noiseOffsetForward = splineIdx * 100f + 67f;

                int splineStartNodeIndex = _generatedNodes.Count;

                for (int i = 0; i < pointCount; i++)
                {
                    float t = (float)i / (pointCount - 1);

                    // Sample Perlin noise for each axis with independent frequency
                    // Noise returns [0,1], remap to [-1,1] then multiply by amplitude
                    float noiseRight = (Mathf.PerlinNoise(t * FreeNoiseFrequency.x + noiseOffsetRight, 0f) * 2f - 1f) * FreeNoiseAmplitude.x;
                    float noiseUp = (Mathf.PerlinNoise(t * FreeNoiseFrequency.y + noiseOffsetUp, 100f) * 2f - 1f) * FreeNoiseAmplitude.y;
                    float noiseForward = (Mathf.PerlinNoise(t * FreeNoiseFrequency.z + noiseOffsetForward, 200f) * 2f - 1f) * FreeNoiseAmplitude.z;

                    var position = startPos
                        + forward * (t * splineLength + noiseForward)
                        + up * noiseUp
                        + right * noiseRight;

                    // Obstacle avoidance: push position away from obstacles
                    if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                    {
                        var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                        var dir = (position - prevPos).normalized;
                        float dist = Vector3.Distance(prevPos, position);

                        if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                        {
                            // Push position back along travel direction and away along surface normal
                            position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                        }
                    }

                    _generatedNodes.Add(new VineNode
                    {
                        Position = position,
                        ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                        IsTip = (i == pointCount - 1) ? 1 : 0,
                        LastGrowIteration = 0
                    });
                }
            }
        }

        private void GeneratePathSplines()
        {
            if (CityManager == null)
            {
                Debug.LogError("VineGenerator: CityManager not assigned for Path mode!");
                return;
            }

            if (!CityManager.HasValidCorridorSetup)
            {
                Debug.LogError("VineGenerator: CityManager does not have valid corridor setup!");
                return;
            }

            var random = new System.Random(Seed);
            _generatedNodes.Clear();
            _generatedAttractors.Clear();

            // Gather enabled corridor paths
            var corridorPaths = new List<IReadOnlyList<Vector3>>();
            if (CityManager.EnableCorridorA && CityManager.CorridorPathA != null && CityManager.CorridorPathA.Count > 0)
                corridorPaths.Add(CityManager.CorridorPathA);
            if (CityManager.EnableCorridorB && CityManager.CorridorPathB != null && CityManager.CorridorPathB.Count > 0)
                corridorPaths.Add(CityManager.CorridorPathB);
            if (CityManager.EnableCorridorC && CityManager.CorridorPathC != null && CityManager.CorridorPathC.Count > 0)
                corridorPaths.Add(CityManager.CorridorPathC);

            if (corridorPaths.Count == 0)
            {
                Debug.LogWarning("VineGenerator: No corridor paths available! Generate city first.");
                return;
            }

            int totalVines = 0;
            int attractedVines = 0;
            int corridorVines = 0;
            int skippedDueToSpacing = 0;
            var vineStartPositions = new List<Vector3>();

            // Calculate total vines across all corridors
            int totalRequestedVines = VinesPerCorridor * corridorPaths.Count;

            // Calculate effective attraction and attracted vine count
            float effectiveAttraction = Mathf.Max(BillboardAttractionStrength, GraffitiAttractionStrength);
            int attractedVineCount = Mathf.RoundToInt(totalRequestedVines * effectiveAttraction);

            // Generate attracted vines first (connecting billboards/graffiti)
            if (attractedVineCount > 0)
            {
                var attractorTargets = GatherAttractorTargets(BillboardAttractionStrength, GraffitiAttractionStrength);

                if (attractorTargets.Count >= 2)
                {
                    var usedPairs = new HashSet<(int, int)>();

                    for (int i = 0; i < attractedVineCount; i++)
                    {
                        var pair = SelectAttractorPair(attractorTargets, usedPairs, random);
                        if (!pair.HasValue)
                            break;

                        var (start, end) = pair.Value;

                        // Track vine start position for spacing
                        vineStartPositions.Add(start.Position);

                        GenerateAttractedVine(start, end, random, totalVines);
                        totalVines++;
                        attractedVines++;
                    }
                }
            }

            // Calculate remaining corridor vines to generate
            int remainingVines = totalRequestedVines - attractedVines;

            // Generate remaining vines along each corridor path
            if (remainingVines > 0)
            {
                // Distribute remaining vines across corridors
                int vinesPerPath = remainingVines / corridorPaths.Count;
                int extraVines = remainingVines % corridorPaths.Count;

                for (int pathIdx = 0; pathIdx < corridorPaths.Count; pathIdx++)
                {
                    var path = corridorPaths[pathIdx];
                    int vinesForThisPath = vinesPerPath + (pathIdx < extraVines ? 1 : 0);

                    // Calculate total path length for distributing vines
                    float totalPathLength = 0f;
                    for (int i = 1; i < path.Count; i++)
                    {
                        totalPathLength += Vector3.Distance(path[i - 1], path[i]);
                    }

                    // Distribute vines along the path
                    for (int vineIdx = 0; vineIdx < vinesForThisPath; vineIdx++)
                    {
                        // Pick a position along the path
                        float targetDist = (float)random.NextDouble() * totalPathLength;
                        float accumulatedDist = 0f;
                        int segmentIdx = 0;
                        float segmentT = 0f;

                        // Find which segment this distance falls on
                        for (int i = 1; i < path.Count; i++)
                        {
                            float segmentLength = Vector3.Distance(path[i - 1], path[i]);
                            if (accumulatedDist + segmentLength >= targetDist)
                            {
                                segmentIdx = i - 1;
                                segmentT = (targetDist - accumulatedDist) / segmentLength;
                                break;
                            }
                            accumulatedDist += segmentLength;
                        }

                        // Interpolate position on the path
                        Vector3 pathPos = Vector3.Lerp(path[segmentIdx], path[Mathf.Min(segmentIdx + 1, path.Count - 1)], segmentT);

                        // Calculate tangent direction along the path
                        Vector3 tangent;
                        if (segmentIdx + 1 < path.Count)
                        {
                            tangent = (path[segmentIdx + 1] - path[segmentIdx]).normalized;
                        }
                        else if (segmentIdx > 0)
                        {
                            tangent = (path[segmentIdx] - path[segmentIdx - 1]).normalized;
                        }
                        else
                        {
                            tangent = Vector3.forward;
                        }

                        // Calculate right vector (perpendicular to tangent, in horizontal plane)
                        Vector3 right = Vector3.Cross(Vector3.up, tangent).normalized;
                        if (right.sqrMagnitude < 0.01f)
                        {
                            right = Vector3.right;
                        }

                        // Determine if this is a ground vine
                        bool isGroundVine = (float)random.NextDouble() < GroundVineRatio;

                        // Offset position laterally within corridor width
                        float lateralOffset = ((float)random.NextDouble() * 2 - 1) * PathCorridorWidth / 2;

                        // Determine height
                        float height;
                        if (isGroundVine)
                        {
                            height = 0f;
                        }
                        else
                        {
                            height = Mathf.Lerp(VolumeHeightRange.x, VolumeHeightRange.y, (float)random.NextDouble());
                        }

                        Vector3 startPos = pathPos + right * lateralOffset;
                        startPos.y = height;

                        // Check spacing against existing vines
                        bool tooClose = false;
                        foreach (var existingPos in vineStartPositions)
                        {
                            if (Vector3.Distance(startPos, existingPos) < MinVineSpacing)
                            {
                                tooClose = true;
                                break;
                            }
                        }

                        if (tooClose)
                        {
                            skippedDueToSpacing++;
                            continue;
                        }

                        vineStartPositions.Add(startPos);

                        // Random vine length
                        float vineLength = Mathf.Lerp(PathLengthRange.x, PathLengthRange.y, (float)random.NextDouble());

                        if (isGroundVine)
                        {
                            // Ground vines rise from ground while following corridor curve
                            float targetHeight = Mathf.Lerp(VolumeHeightRange.x, VolumeHeightRange.y, (float)random.NextDouble()) * 0.5f;

                            GenerateGroundVine(
                                path,
                                targetDist,
                                vineLength,
                                lateralOffset,
                                targetHeight,
                                random,
                                totalVines
                            );
                        }
                        else
                        {
                            // Non-ground vines follow the corridor curve
                            GenerateCorridorFollowingVine(
                                path,
                                targetDist,
                                vineLength,
                                lateralOffset,
                                height,
                                random,
                                totalVines
                            );
                        }
                        totalVines++;
                        corridorVines++;
                    }
                }
            }

            if (skippedDueToSpacing > 0)
            {
                Debug.Log($"VineGenerator (Path): Skipped {skippedDueToSpacing} vines due to MinVineSpacing ({MinVineSpacing}m)");
            }

            string attractionInfo = effectiveAttraction > 0
                ? $" ({attractedVines} attracted, {corridorVines} corridor)"
                : "";
            Debug.Log($"VineGenerator (Path): Generated {_generatedNodes.Count} nodes across {totalVines} vines{attractionInfo} following {corridorPaths.Count} corridor path(s)");

            // Optionally generate billboard-connecting vines
            if (PathEnableBillboardVines)
            {
                int nodesBefore = _generatedNodes.Count;
                int chainsCreated = GenerateBillboardChains();
                if (chainsCreated > 0)
                {
                    Debug.Log($"VineGenerator (Path): Added {_generatedNodes.Count - nodesBefore} billboard vine nodes across {chainsCreated} chain(s)");
                }
            }
        }

        private void GenerateBillboardSplines()
        {
            if (CityManager == null)
            {
                Debug.LogError("VineGenerator: CityManager not assigned for Billboard mode!");
                return;
            }

            if (!CityManager.HasBillboardData)
            {
                Debug.LogError("VineGenerator: CityManager has no billboard data! Generate city first.");
                return;
            }

            _generatedNodes.Clear();
            _generatedAttractors.Clear();

            int totalChains = GenerateBillboardChains();

            Debug.Log($"VineGenerator (Billboard): Generated {_generatedNodes.Count} nodes across {totalChains} continuous cable chain(s)");
        }

        private int GenerateBillboardChains()
        {
            if (CityManager == null || !CityManager.HasBillboardData)
                return 0;

            var billboards = CityManager.Billboards;
            if (billboards.Count < 2)
                return 0;

            var random = new System.Random(Seed + 999);  // Different seed offset for billboard vines
            int totalChains = 0;

            if (BillboardSameSideOnly)
            {
                // Separate billboards by corridor side (based on normal X direction)
                var leftSide = billboards.Where(b => b.Normal.x > 0).OrderBy(b => b.Position.z).ToList();
                var rightSide = billboards.Where(b => b.Normal.x <= 0).OrderBy(b => b.Position.z).ToList();

                if (leftSide.Count >= 2)
                    totalChains += GenerateBillboardChain(leftSide, random, 0);
                if (rightSide.Count >= 2)
                    totalChains += GenerateBillboardChain(rightSide, random, leftSide.Count);
            }
            else
            {
                // Zigzag: connect all billboards sorted by Z
                var sortedBillboards = billboards.OrderBy(b => b.Position.z).ToList();
                totalChains = GenerateBillboardChain(sortedBillboards, random, 0);
            }

            return totalChains;
        }

        private int GenerateBillboardChain(List<BillboardData> sortedBillboards, System.Random random, int noiseIndexOffset)
        {
            if (sortedBillboards.Count < 2) return 0;

            int chainsCreated = 0;
            bool chainActive = false;

            for (int i = 0; i < sortedBillboards.Count - 1; i++)
            {
                var billboardA = sortedBillboards[i];
                var billboardB = sortedBillboards[i + 1];

                float dist = Vector3.Distance(billboardA.Position, billboardB.Position);

                // If gap too large, end current chain and skip
                if (dist > BillboardMaxConnectionDistance)
                {
                    if (chainActive && _generatedNodes.Count > 0)
                    {
                        var lastNode = _generatedNodes[_generatedNodes.Count - 1];
                        lastNode.IsTip = 1;
                        _generatedNodes[_generatedNodes.Count - 1] = lastNode;
                        chainsCreated++;
                    }
                    chainActive = false;
                    continue;
                }

                var startPos = billboardA.Position + billboardA.Normal * BillboardInwardOffset;
                var endPos = billboardB.Position + billboardB.Normal * BillboardInwardOffset;

                bool isFirstInChain = !chainActive;
                if (isFirstInChain) chainActive = true;

                bool isLastSegment = (i == sortedBillboards.Count - 2) ||
                    (i + 2 < sortedBillboards.Count &&
                     Vector3.Distance(billboardB.Position, sortedBillboards[i + 2].Position) > BillboardMaxConnectionDistance);

                GenerateBillboardSegment(startPos, endPos, random, i + noiseIndexOffset, isFirstInChain, isLastSegment);
            }

            // Finalize last chain
            if (chainActive && _generatedNodes.Count > 0)
            {
                var lastNode = _generatedNodes[_generatedNodes.Count - 1];
                if (lastNode.IsTip != 1)
                {
                    lastNode.IsTip = 1;
                    _generatedNodes[_generatedNodes.Count - 1] = lastNode;
                }
                chainsCreated++;
            }

            return chainsCreated;
        }

        private void GenerateBillboardSegment(Vector3 startPos, Vector3 endPos, System.Random random, int noiseOffset, bool isFirstInChain, bool isLastSegment)
        {
            int pointCount = BillboardPointsPerSpline;

            // Skip first point if continuing a chain (previous segment ended at this position)
            int startIndex = isFirstInChain ? 0 : 1;

            for (int i = startIndex; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);

                // Linear interpolation between billboard positions
                var position = Vector3.Lerp(startPos, endPos, t);

                // Apply parabolic sag: sagY = -4 * sagAmount * t * (1 - t)
                // This gives 0 at t=0, -sagAmount at t=0.5, and 0 at t=1
                float sagY = -4f * BillboardSagAmount * t * (1f - t);
                position.y += sagY;

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Parent index: only root node has -1
                int parentIndex = (isFirstInChain && i == 0) ? -1 : _generatedNodes.Count - 1;

                // Tip: only the very last node of a chain
                int isTip = (isLastSegment && i == pointCount - 1) ? 1 : 0;

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = parentIndex,
                    IsTip = isTip,
                    LastGrowIteration = 0
                });
            }
        }

        private void GeneratePathForTwoSegmentCorridor(
            Vector3 convergence,
            Vector3 waypoint,
            Vector3 endPoint,
            System.Random random,
            int corridorIdx,
            ref int totalVines)
        {
            // Calculate full path length (convergence -> waypoint -> end point)
            float segment1Length = Vector3.Distance(convergence, waypoint);
            float segment2Length = Vector3.Distance(waypoint, endPoint);
            float totalCorridorLength = segment1Length + segment2Length;

            // Direction vectors for each segment
            var dir1 = (waypoint - convergence).normalized;
            var dir2 = (endPoint - waypoint).normalized;

            // Perpendicular direction (use first segment's direction for lateral offset)
            var right = Vector3.Cross(Vector3.up, dir1).normalized;

            for (int vineIdx = 0; vineIdx < VinesPerCorridor; vineIdx++)
            {
                // Random lateral offset within corridor width
                float lateralOffset = Mathf.Lerp(-PathCorridorWidth / 2, PathCorridorWidth / 2, (float)random.NextDouble());

                // Random start position along the corridor (based on VineStartRange)
                float maxStartDistance = (totalCorridorLength - PathLengthRange.x) * VineStartRange;
                float startDistance = PathStartOffset + (float)random.NextDouble() * Mathf.Max(0, maxStartDistance);

                // Random length for this vine (clamped to remaining corridor length)
                float maxAvailableLength = totalCorridorLength - startDistance;
                float vineLength = Mathf.Lerp(PathLengthRange.x, PathLengthRange.y, (float)random.NextDouble());
                vineLength = Mathf.Min(vineLength, maxAvailableLength);

                // Skip if vine would be too short
                if (vineLength < PathLengthRange.x * 0.5f)
                    continue;

                // Generate path points for two-segment corridor
                GenerateTwoSegmentPathVine(
                    convergence,
                    waypoint,
                    endPoint,
                    segment1Length,
                    segment2Length,
                    lateralOffset,
                    startDistance,
                    vineLength,
                    random,
                    corridorIdx * 100 + vineIdx
                );
                totalVines++;
            }
        }

        private void GenerateTwoSegmentPathVine(
            Vector3 convergence,
            Vector3 waypoint,
            Vector3 endPoint,
            float segment1Length,
            float segment2Length,
            float lateralOffset,
            float startDistance,
            float vineLength,
            System.Random random,
            int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;
            float totalLength = segment1Length + segment2Length;

            // Direction vectors
            var dir1 = (waypoint - convergence).normalized;
            var dir2 = (endPoint - waypoint).normalized;
            var right1 = Vector3.Cross(Vector3.up, dir1).normalized;
            var right2 = Vector3.Cross(Vector3.up, dir2).normalized;

            // Per-vine: sample random target values within level chunk ranges
            // Use noiseOffset as seed for consistency across regenerations
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Target amplitude from level chunk ranges (half span = amplitude)
            float targetAmplitudeX = Mathf.Lerp(
                LevelChunkRules.LateralSpanMin / 2f,
                LevelChunkRules.LateralSpanMax / 2f,
                vineRandom
            );
            float targetAmplitudeY = Mathf.Lerp(
                LevelChunkRules.HeightVariationMin / 2f,
                LevelChunkRules.HeightVariationMax / 2f,
                vineRandomY
            );

            // Target frequency from level chunk range (smoother curves)
            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            // Blend current settings toward randomized level chunk targets
            float influencedAmplitudeX = Mathf.Lerp(FreeNoiseAmplitude.x, targetAmplitudeX, LevelChunkInfluence);
            float influencedAmplitudeY = Mathf.Lerp(FreeNoiseAmplitude.y, targetAmplitudeY, LevelChunkInfluence);
            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);
                float distanceAlongPath = startDistance + t * vineLength;

                // Determine which segment we're in and calculate position
                Vector3 basePosition;
                Vector3 currentDir;
                Vector3 currentRight;

                if (distanceAlongPath <= segment1Length)
                {
                    // In first segment: convergence -> waypoint
                    currentDir = dir1;
                    currentRight = right1;
                    basePosition = convergence + dir1 * distanceAlongPath + currentRight * lateralOffset;
                }
                else
                {
                    // In second segment: waypoint -> end point
                    float distInSegment2 = distanceAlongPath - segment1Length;
                    currentDir = dir2;
                    currentRight = right2;
                    basePosition = waypoint + dir2 * distInSegment2 + currentRight * lateralOffset;
                }

                // Sample noise for lateral and vertical movement using influenced values
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * influencedAmplitudeX;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * influencedAmplitudeY;

                // Clamp lateral noise to stay within corridor bounds
                float maxLateralOffset = PathCorridorWidth / 2;
                noiseRight = Mathf.Clamp(noiseRight, -maxLateralOffset, maxLateralOffset);

                var position = basePosition
                    + currentRight * noiseRight
                    + Vector3.up * noiseUp;

                // Clamp to stay above ground (y >= 0)
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private void GeneratePathVine(Vector3 start, Vector3 direction, float length, Vector3 right, System.Random random, int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;

            // If starting below ground, offset the start position
            if (StartBelowGround)
            {
                start.y = -GroundStartDepth;
            }

            // Per-vine: sample random target values within level chunk ranges
            // Use noiseOffset as seed for consistency across regenerations
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Target amplitude from level chunk ranges (half span = amplitude)
            float targetAmplitudeX = Mathf.Lerp(
                LevelChunkRules.LateralSpanMin / 2f,
                LevelChunkRules.LateralSpanMax / 2f,
                vineRandom
            );
            float targetAmplitudeY = Mathf.Lerp(
                LevelChunkRules.HeightVariationMin / 2f,
                LevelChunkRules.HeightVariationMax / 2f,
                vineRandomY
            );

            // Target frequency from level chunk range (smoother curves)
            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            // Blend current settings toward randomized level chunk targets
            float influencedAmplitudeX = Mathf.Lerp(FreeNoiseAmplitude.x, targetAmplitudeX, LevelChunkInfluence);
            float influencedAmplitudeY = Mathf.Lerp(FreeNoiseAmplitude.y, targetAmplitudeY, LevelChunkInfluence);
            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);

                // Sample noise for lateral and vertical movement using influenced values
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * influencedAmplitudeX;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * influencedAmplitudeY;

                // Clamp lateral noise to stay within corridor bounds
                float maxLateralOffset = PathCorridorWidth / 2;
                noiseRight = Mathf.Clamp(noiseRight, -maxLateralOffset, maxLateralOffset);

                var position = start
                    + direction * (t * length)
                    + right * noiseRight
                    + Vector3.up * noiseUp;  // Use world up for vertical noise

                // Clamp to stay above ground (y >= 0)
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private void GenerateVolumePathVine(Vector3 start, Vector3 direction, float length, Vector3 right, System.Random random, int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;

            // Per-vine: sample random target values within level chunk ranges
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Target amplitude from level chunk ranges (half span = amplitude)
            float targetAmplitudeX = Mathf.Lerp(
                LevelChunkRules.LateralSpanMin / 2f,
                LevelChunkRules.LateralSpanMax / 2f,
                vineRandom
            );
            float targetAmplitudeY = Mathf.Lerp(
                LevelChunkRules.HeightVariationMin / 2f,
                LevelChunkRules.HeightVariationMax / 2f,
                vineRandomY
            );

            // Target frequency from level chunk range
            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            // Blend current settings toward randomized level chunk targets
            float influencedAmplitudeX = Mathf.Lerp(FreeNoiseAmplitude.x, targetAmplitudeX, LevelChunkInfluence);
            float influencedAmplitudeY = Mathf.Lerp(FreeNoiseAmplitude.y, targetAmplitudeY, LevelChunkInfluence);
            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);

                // Sample noise for lateral and vertical undulation
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * influencedAmplitudeX;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * influencedAmplitudeY;

                var position = start
                    + direction * (t * length)
                    + right * noiseRight
                    + Vector3.up * noiseUp;

                // Clamp to stay above ground (y >= 0)
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private (Vector3 position, Vector3 tangent) SampleCorridorPath(IReadOnlyList<Vector3> path, float distance)
        {
            if (path.Count < 2)
            {
                return (path[0], Vector3.forward);
            }

            float accumulatedDist = 0f;

            for (int i = 1; i < path.Count; i++)
            {
                float segmentLength = Vector3.Distance(path[i - 1], path[i]);
                if (accumulatedDist + segmentLength >= distance)
                {
                    float t = (distance - accumulatedDist) / segmentLength;
                    var position = Vector3.Lerp(path[i - 1], path[i], t);
                    var tangent = (path[i] - path[i - 1]).normalized;
                    return (position, tangent);
                }
                accumulatedDist += segmentLength;
            }

            // Past end of path - return last point and tangent
            var lastTangent = (path[path.Count - 1] - path[path.Count - 2]).normalized;
            return (path[path.Count - 1], lastTangent);
        }

        private void GenerateCorridorFollowingVine(
            IReadOnlyList<Vector3> corridorPath,
            float startDistance,
            float vineLength,
            float lateralOffset,
            float height,
            System.Random random,
            int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;

            // Per-vine: sample random target values within level chunk ranges
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Target amplitude from level chunk ranges (half span = amplitude)
            float targetAmplitudeX = Mathf.Lerp(
                LevelChunkRules.LateralSpanMin / 2f,
                LevelChunkRules.LateralSpanMax / 2f,
                vineRandom
            );
            float targetAmplitudeY = Mathf.Lerp(
                LevelChunkRules.HeightVariationMin / 2f,
                LevelChunkRules.HeightVariationMax / 2f,
                vineRandomY
            );

            // Target frequency from level chunk range
            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            // Blend current settings toward randomized level chunk targets
            float influencedAmplitudeX = Mathf.Lerp(FreeNoiseAmplitude.x, targetAmplitudeX, LevelChunkInfluence);
            float influencedAmplitudeY = Mathf.Lerp(FreeNoiseAmplitude.y, targetAmplitudeY, LevelChunkInfluence);
            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);
                float currentDistance = startDistance + t * vineLength;

                // Sample the corridor path at this distance
                var (pathPos, tangent) = SampleCorridorPath(corridorPath, currentDistance);

                // Calculate right vector perpendicular to tangent in horizontal plane
                var right = Vector3.Cross(Vector3.up, tangent).normalized;
                if (right.sqrMagnitude < 0.01f)
                {
                    right = Vector3.right;
                }

                // Sample noise for lateral and vertical undulation
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * influencedAmplitudeX;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * influencedAmplitudeY;

                // Build position: path position + lateral offset + noise
                var position = pathPos
                    + right * (lateralOffset + noiseRight)
                    + Vector3.up * (height + noiseUp);

                // Clamp to stay above ground (y >= 0)
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private void GenerateGroundVine(
            IReadOnlyList<Vector3> corridorPath,
            float startDistance,
            float vineLength,
            float lateralOffset,
            float targetHeight,
            System.Random random,
            int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;

            // Per-vine noise parameters (smaller amplitude to stay within corridor)
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Lateral noise amplitude - constrained to stay within corridor bounds
            float maxLateralNoise = (PathCorridorWidth / 2f) - Mathf.Abs(lateralOffset);
            maxLateralNoise = Mathf.Max(maxLateralNoise * 0.5f, 0.5f); // At least some wiggle room

            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);
                float currentDistance = startDistance + t * vineLength;

                // Sample the corridor path at this distance
                var (pathPos, tangent) = SampleCorridorPath(corridorPath, currentDistance);

                // Calculate right vector perpendicular to tangent in horizontal plane
                var right = Vector3.Cross(Vector3.up, tangent).normalized;
                if (right.sqrMagnitude < 0.01f)
                {
                    right = Vector3.right;
                }

                // Interpolate height from ground (0) to target height
                float currentHeight = Mathf.Lerp(0f, targetHeight, t);

                // Small lateral noise, clamped to corridor bounds
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * maxLateralNoise;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * 1f;

                // Clamp total lateral offset to stay within corridor
                float totalLateralOffset = lateralOffset + noiseRight;
                float halfWidth = PathCorridorWidth / 2f;
                totalLateralOffset = Mathf.Clamp(totalLateralOffset, -halfWidth, halfWidth);

                // Build position: path position + clamped lateral offset + height
                var position = pathPos
                    + right * totalLateralOffset
                    + Vector3.up * (currentHeight + noiseUp);

                // Clamp to stay above ground
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private List<AttractorTarget> GatherAttractorTargets(float billboardWeight, float graffitiWeight)
        {
            var targets = new List<AttractorTarget>();

            if (CityManager == null)
                return targets;

            // Gather billboard positions
            if (billboardWeight > 0f && CityManager.HasBillboardData)
            {
                foreach (var billboard in CityManager.Billboards)
                {
                    targets.Add(new AttractorTarget
                    {
                        Position = billboard.Position,
                        Normal = billboard.Normal,
                        Weight = billboardWeight,
                        IsBillboard = true
                    });
                }
            }

            // Gather graffiti positions
            if (graffitiWeight > 0f && CityManager.GraffitiSpots != null && CityManager.GraffitiSpots.Count > 0)
            {
                foreach (var graffiti in CityManager.GraffitiSpots)
                {
                    targets.Add(new AttractorTarget
                    {
                        Position = graffiti.Position,
                        Normal = graffiti.Normal,
                        Weight = graffitiWeight,
                        IsBillboard = false
                    });
                }
            }

            return targets;
        }

        private (AttractorTarget start, AttractorTarget end)? SelectAttractorPair(
            List<AttractorTarget> targets,
            HashSet<(int, int)> usedPairs,
            System.Random random)
        {
            if (targets.Count < 2)
                return null;

            // Build list of valid pairs with weights
            var validPairs = new List<(int startIdx, int endIdx, float weight)>();

            for (int i = 0; i < targets.Count; i++)
            {
                for (int j = i + 1; j < targets.Count; j++)
                {
                    // Skip already used pairs
                    if (usedPairs.Contains((i, j)) || usedPairs.Contains((j, i)))
                        continue;

                    float dist = Vector3.Distance(targets[i].Position, targets[j].Position);

                    // Skip pairs outside valid vine length range
                    // Use PathLengthRange for min/max, capped by AttractorSearchRadius
                    if (dist < PathLengthRange.x || dist > Mathf.Min(PathLengthRange.y, AttractorSearchRadius))
                        continue;

                    // Combined weight favors higher attraction strengths
                    float pairWeight = targets[i].Weight + targets[j].Weight;
                    validPairs.Add((i, j, pairWeight));
                }
            }

            if (validPairs.Count == 0)
                return null;

            // Weighted random selection
            float totalWeight = 0f;
            foreach (var pair in validPairs)
                totalWeight += pair.weight;

            float selection = (float)random.NextDouble() * totalWeight;
            float accumulated = 0f;

            foreach (var pair in validPairs)
            {
                accumulated += pair.weight;
                if (accumulated >= selection)
                {
                    usedPairs.Add((pair.startIdx, pair.endIdx));
                    return (targets[pair.startIdx], targets[pair.endIdx]);
                }
            }

            // Fallback to first valid pair
            var fallback = validPairs[0];
            usedPairs.Add((fallback.startIdx, fallback.endIdx));
            return (targets[fallback.startIdx], targets[fallback.endIdx]);
        }

        private void GenerateAttractedVine(
            AttractorTarget start,
            AttractorTarget end,
            System.Random random,
            int noiseOffset)
        {
            int pointCount = FreePointsPerSpline;

            // Per-vine noise parameters
            float vineRandom = Mathf.PerlinNoise(noiseOffset * 0.1f, 0f);
            float vineRandomY = Mathf.PerlinNoise(noiseOffset * 0.1f, 50f);

            // Target amplitude from level chunk ranges
            float targetAmplitudeX = Mathf.Lerp(
                LevelChunkRules.LateralSpanMin / 2f,
                LevelChunkRules.LateralSpanMax / 2f,
                vineRandom
            );
            float targetAmplitudeY = Mathf.Lerp(
                LevelChunkRules.HeightVariationMin / 2f,
                LevelChunkRules.HeightVariationMax / 2f,
                vineRandomY
            );

            // Target frequency from level chunk range
            float targetFreqX = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, vineRandom);
            float targetFreqY = Mathf.Lerp(LevelChunkRules.FrequencyMin, LevelChunkRules.FrequencyMax, 1f - vineRandom);

            // Blend current settings toward randomized level chunk targets
            float influencedAmplitudeX = Mathf.Lerp(FreeNoiseAmplitude.x, targetAmplitudeX, LevelChunkInfluence);
            float influencedAmplitudeY = Mathf.Lerp(FreeNoiseAmplitude.y, targetAmplitudeY, LevelChunkInfluence);
            float influencedFreqX = Mathf.Lerp(FreeNoiseFrequency.x, targetFreqX, LevelChunkInfluence);
            float influencedFreqY = Mathf.Lerp(FreeNoiseFrequency.y, targetFreqY, LevelChunkInfluence);

            // Calculate direction and perpendicular vectors
            Vector3 direction = (end.Position - start.Position).normalized;
            float totalLength = Vector3.Distance(start.Position, end.Position);

            Vector3 right = Vector3.Cross(Vector3.up, direction).normalized;
            if (right.sqrMagnitude < 0.01f)
                right = Vector3.right;

            // Small sag amount like billboard cables (reduced for more flowing paths)
            float sagAmount = BillboardSagAmount * 0.3f;

            for (int i = 0; i < pointCount; i++)
            {
                float t = (float)i / (pointCount - 1);

                // Base position interpolated between start and end
                Vector3 basePosition = Vector3.Lerp(start.Position, end.Position, t);

                // Apply parabolic sag
                float sagY = -4f * sagAmount * t * (1f - t);

                // Endpoint fade: noise fades to 0 at both ends
                // endpointFade = 1 - (2 * |t - 0.5|)^2 gives smooth fade
                float distFromCenter = Mathf.Abs(t - 0.5f) * 2f;
                float endpointFade = 1f - distFromCenter * distFromCenter;

                // Sample noise with endpoint fade
                float noiseRight = (Mathf.PerlinNoise(t * influencedFreqX + noiseOffset, 0f) * 2f - 1f) * influencedAmplitudeX * endpointFade;
                float noiseUp = (Mathf.PerlinNoise(t * influencedFreqY + noiseOffset + 33f, 100f) * 2f - 1f) * influencedAmplitudeY * endpointFade;

                var position = basePosition
                    + right * noiseRight
                    + Vector3.up * (sagY + noiseUp);

                // Clamp to stay above ground
                position.y = Mathf.Max(position.y, 0f);

                // Apply obstacle avoidance if enabled
                if (EnableObstacleAvoidance && i > 0 && Physics.CheckSphere(position, ObstacleAvoidanceDistance))
                {
                    var prevPos = _generatedNodes[_generatedNodes.Count - 1].Position;
                    var dir = (position - prevPos).normalized;
                    float dist = Vector3.Distance(prevPos, position);

                    if (Physics.SphereCast(prevPos, ObstacleAvoidanceDistance * 0.5f, dir, out var hit, dist + ObstacleAvoidanceDistance))
                    {
                        position = hit.point - dir * ObstacleAvoidanceDistance + hit.normal * ObstacleAvoidanceDistance;
                    }
                }

                // Final ground clamp after obstacle avoidance
                position.y = Mathf.Max(position.y, 0f);

                _generatedNodes.Add(new VineNode
                {
                    Position = position,
                    ParentIndex = (i == 0) ? -1 : _generatedNodes.Count - 1,
                    IsTip = (i == pointCount - 1) ? 1 : 0,
                    LastGrowIteration = 0
                });
            }
        }

        private Vector3 RandomPointInBounds(System.Random random, Bounds bounds)
        {
            return new Vector3(
                bounds.min.x + (float)random.NextDouble() * bounds.size.x,
                bounds.min.y + (float)random.NextDouble() * bounds.size.y,
                bounds.min.z + (float)random.NextDouble() * bounds.size.z
            );
        }

        private void InitializeRootNodes()
        {
            _generatedNodes = new List<VineNode>();

            foreach (var root in RootPoints)
            {
                if (root == null) continue;

                _generatedNodes.Add(new VineNode
                {
                    Position = root.position,
                    ParentIndex = -1,
                    IsTip = 1,
                    LastGrowIteration = -EffectiveBranchCooldown  // Allow immediate growth on first iteration
                });
            }
        }

        private void RunGPUAlgorithm()
        {
            // Get kernel indices
            _clearVotesKernel = VineComputeShader.FindKernel("ClearVotes");
            _voteKernel = VineComputeShader.FindKernel("Vote");
            _growKernel = VineComputeShader.FindKernel("Grow");
            _pruneKernel = VineComputeShader.FindKernel("Prune");

            // Create buffers
            int nodeStride = System.Runtime.InteropServices.Marshal.SizeOf<VineNode>();
            int attractorStride = System.Runtime.InteropServices.Marshal.SizeOf<VineAttractor>();

            _nodeBuffer = new ComputeBuffer(MaxNodes, nodeStride);
            _attractorBuffer = new ComputeBuffer(_generatedAttractors.Count, attractorStride);
            _voteXBuffer = new ComputeBuffer(MaxNodes, sizeof(int));
            _voteYBuffer = new ComputeBuffer(MaxNodes, sizeof(int));
            _voteZBuffer = new ComputeBuffer(MaxNodes, sizeof(int));
            _voteCountBuffer = new ComputeBuffer(MaxNodes, sizeof(int));
            _counterBuffer = new ComputeBuffer(2, sizeof(int));

            try
            {
                // Initialize node buffer with root nodes
                var nodeArray = new VineNode[MaxNodes];
                for (int i = 0; i < _generatedNodes.Count; i++)
                {
                    nodeArray[i] = _generatedNodes[i];
                }
                _nodeBuffer.SetData(nodeArray);

                // Initialize attractor buffer
                _attractorBuffer.SetData(_generatedAttractors.ToArray());

                // Initialize counter [0] = node count, [1] = new nodes this iteration
                var counterData = new int[] { _generatedNodes.Count, 0 };
                _counterBuffer.SetData(counterData);

                // Set buffers for all kernels
                SetBuffersForKernel(_clearVotesKernel);
                SetBuffersForKernel(_voteKernel);
                SetBuffersForKernel(_growKernel);
                SetBuffersForKernel(_pruneKernel);

                // Set parameters
                VineComputeShader.SetInt("_MaxNodes", MaxNodes);
                VineComputeShader.SetInt("_AttractorCount", _generatedAttractors.Count);
                VineComputeShader.SetInt("_Seed", Seed);
                VineComputeShader.SetInt("_FixedPointScale", FixedPointScale);
                VineComputeShader.SetInt("_BranchCooldown", EffectiveBranchCooldown);
                VineComputeShader.SetFloat("_StepSize", StepSize);
                VineComputeShader.SetFloat("_AttractionRadius", AttractionRadius);
                VineComputeShader.SetFloat("_KillRadius", KillRadius);
                VineComputeShader.SetFloat("_NoiseStrength", NoiseStrength);
                VineComputeShader.SetFloat("_NoiseScale", NoiseScale);
                VineComputeShader.SetVector("_ForwardDirection", ForwardDirection.normalized);
                VineComputeShader.SetFloat("_ForwardBias", ForwardBias);

                // Run algorithm iterations
                int nodeGroupCount = Mathf.CeilToInt(MaxNodes / (float)ThreadGroupSize);
                int attractorGroupCount = Mathf.CeilToInt(_generatedAttractors.Count / (float)ThreadGroupSize);

                for (int iteration = 0; iteration < MaxIterations; iteration++)
                {
                    // Update node count parameter
                    counterData = new int[2];
                    _counterBuffer.GetData(counterData);
                    int currentNodeCount = counterData[0];

                    VineComputeShader.SetInt("_NodeCount", currentNodeCount);
                    VineComputeShader.SetInt("_CurrentIteration", iteration);

                    // Reset new nodes counter for this iteration
                    counterData[1] = 0;
                    _counterBuffer.SetData(counterData);

                    // Clear votes
                    VineComputeShader.Dispatch(_clearVotesKernel, nodeGroupCount, 1, 1);

                    // Attractors vote for nearest tips
                    VineComputeShader.Dispatch(_voteKernel, attractorGroupCount, 1, 1);

                    // Tips with votes grow new nodes
                    int currentGroupCount = Mathf.CeilToInt(currentNodeCount / (float)ThreadGroupSize);
                    VineComputeShader.Dispatch(_growKernel, Mathf.Max(1, currentGroupCount), 1, 1);

                    // Prune attractors near nodes
                    VineComputeShader.Dispatch(_pruneKernel, attractorGroupCount, 1, 1);

                    // Check if no new nodes were created (early termination)
                    _counterBuffer.GetData(counterData);
                    if (counterData[1] == 0)
                    {
                        Debug.Log($"VineGenerator: Converged at iteration {iteration}");
                        break;
                    }

                    // Check if we hit max nodes
                    if (counterData[0] >= MaxNodes - 1)
                    {
                        Debug.LogWarning($"VineGenerator: Hit max node limit at iteration {iteration}");
                        break;
                    }
                }

                // Read back results
                _counterBuffer.GetData(counterData);
                int finalNodeCount = counterData[0];

                _nodeBuffer.GetData(nodeArray);
                _generatedNodes = new List<VineNode>();
                for (int i = 0; i < finalNodeCount; i++)
                {
                    _generatedNodes.Add(nodeArray[i]);
                }

                // Read back attractor state
                var attractorArray = new VineAttractor[_generatedAttractors.Count];
                _attractorBuffer.GetData(attractorArray);
                _generatedAttractors = new List<VineAttractor>(attractorArray);

                // Filter out nodes that are too close to obstacles
                FilterNodesNearObstacles();
            }
            finally
            {
                // Cleanup buffers
                ReleaseBuffers();
            }
        }

        private void FilterNodesNearObstacles()
        {
            if (!EnableObstacleAvoidance)
                return;

            // Find nodes too close to obstacles
            var nodesToRemove = new HashSet<int>();
            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                if (Physics.CheckSphere(_generatedNodes[i].Position, ObstacleAvoidanceDistance))
                    nodesToRemove.Add(i);
            }

            if (nodesToRemove.Count == 0)
                return;

            // Rebuild node list with updated parent indices
            var newNodes = new List<VineNode>();
            var oldToNew = new Dictionary<int, int>();

            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                if (nodesToRemove.Contains(i))
                    continue;

                var node = _generatedNodes[i];
                int newParent = -1;
                if (node.ParentIndex >= 0 && !nodesToRemove.Contains(node.ParentIndex))
                {
                    oldToNew.TryGetValue(node.ParentIndex, out newParent);
                    if (!oldToNew.ContainsKey(node.ParentIndex))
                        newParent = -1;
                }

                oldToNew[i] = newNodes.Count;
                newNodes.Add(new VineNode
                {
                    Position = node.Position,
                    ParentIndex = newParent,
                    IsTip = node.IsTip,
                    LastGrowIteration = node.LastGrowIteration
                });
            }

            Debug.Log($"VineGenerator: Filtered {nodesToRemove.Count} nodes near obstacles");
            _generatedNodes = newNodes;
        }

        private void SetBuffersForKernel(int kernel)
        {
            VineComputeShader.SetBuffer(kernel, "_Nodes", _nodeBuffer);
            VineComputeShader.SetBuffer(kernel, "_Attractors", _attractorBuffer);
            VineComputeShader.SetBuffer(kernel, "_VoteX", _voteXBuffer);
            VineComputeShader.SetBuffer(kernel, "_VoteY", _voteYBuffer);
            VineComputeShader.SetBuffer(kernel, "_VoteZ", _voteZBuffer);
            VineComputeShader.SetBuffer(kernel, "_VoteCount", _voteCountBuffer);
            VineComputeShader.SetBuffer(kernel, "_Counter", _counterBuffer);
        }

        private void ReleaseBuffers()
        {
            _nodeBuffer?.Release();
            _attractorBuffer?.Release();
            _voteXBuffer?.Release();
            _voteYBuffer?.Release();
            _voteZBuffer?.Release();
            _voteCountBuffer?.Release();
            _counterBuffer?.Release();

            _nodeBuffer = null;
            _attractorBuffer = null;
            _voteXBuffer = null;
            _voteYBuffer = null;
            _voteZBuffer = null;
            _voteCountBuffer = null;
            _counterBuffer = null;
        }

        public List<SplineContainer> ConvertToSplines()
        {
            Debug.Log($"[VineSpline] ConvertToSplines called (continuous path-based). Application.isPlaying: {Application.isPlaying}");

            if (_generatedNodes.Count == 0)
            {
                Debug.LogWarning("VineGenerator: No nodes to convert. Run Regenerate first.");
                return new List<SplineContainer>();
            }

            // Clear existing splines and branch connections
            ClearSplines();
            ClearCombinedMesh();
            _branchConnections.Clear();

            // Build child lookup: nodeIndex -> list of children
            var childLookup = new Dictionary<int, List<int>>();
            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                childLookup[i] = new List<int>();
            }

            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                int parent = _generatedNodes[i].ParentIndex;
                if (parent >= 0 && parent < _generatedNodes.Count)
                {
                    childLookup[parent].Add(i);
                }
            }

            // Find all leaf nodes (nodes with no children)
            var leafNodes = new List<int>();
            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                if (childLookup[i].Count == 0)
                {
                    leafNodes.Add(i);
                }
            }

            // Count roots and branch points for logging
            int rootCount = 0;
            var branchPoints = new HashSet<int>();
            for (int i = 0; i < _generatedNodes.Count; i++)
            {
                if (_generatedNodes[i].ParentIndex == -1)
                {
                    rootCount++;
                }
                if (childLookup[i].Count >= 2)
                {
                    branchPoints.Add(i);
                }
            }

            if (rootCount == 1)
            {
                Debug.Log("VineGenerator: Single root mode - 1 root point detected");
            }

            Debug.Log($"VineGenerator: Found {leafNodes.Count} leaf nodes, {branchPoints.Count} branch points, {rootCount} root(s)");

            // Optional: Filter close branches if MinBranchSeparation > 0
            if (MinBranchSeparation > 0f)
            {
                FilterCloseBranches(branchPoints, childLookup);
            }

            // Trace continuous paths from each leaf back to its root
            // Each path is a complete spline from root to leaf tip
            var paths = new List<List<int>>();

            foreach (int leaf in leafNodes)
            {
                var path = new List<int>();
                int current = leaf;

                // Trace back to root
                while (current >= 0)
                {
                    path.Add(current);
                    current = _generatedNodes[current].ParentIndex;
                }

                // Reverse to get root-to-leaf order
                path.Reverse();
                paths.Add(path);
            }

            // Calculate world length for each path
            var pathsWithLength = new List<(List<int> path, float worldLength)>();
            for (int i = 0; i < paths.Count; i++)
            {
                var path = paths[i];
                float worldLength = 0f;
                for (int j = 1; j < path.Count; j++)
                {
                    worldLength += Vector3.Distance(
                        _generatedNodes[path[j - 1]].Position,
                        _generatedNodes[path[j]].Position);
                }
                pathsWithLength.Add((path, worldLength));
            }

            // Sort by world length (longest first) so main trunk gets meshed first
            pathsWithLength.Sort((a, b) => b.worldLength.CompareTo(a.worldLength));

            // Filter paths by length requirements
            var validPaths = new List<(List<int> path, float worldLength)>();
            int filteredByNodeCount = 0;
            int filteredByWorldLength = 0;

            foreach (var (path, worldLength) in pathsWithLength)
            {
                // Skip paths with too few nodes
                if (path.Count < MinSplineLength)
                {
                    filteredByNodeCount++;
                    continue;
                }

                // Skip paths that are too short in world space
                if (worldLength < MinSplineWorldLength)
                {
                    filteredByWorldLength++;
                    continue;
                }

                validPaths.Add((path, worldLength));
            }

            if (validPaths.Count == 0)
            {
                Debug.LogWarning("VineGenerator: All paths filtered! Try lowering MinSplineLength or MinSplineWorldLength");
            }

            if (filteredByNodeCount > 0 || filteredByWorldLength > 0)
            {
                Debug.Log($"VineGenerator: Filtered {filteredByNodeCount} paths (< {MinSplineLength} nodes), {filteredByWorldLength} paths (< {MinSplineWorldLength}m world length)");
            }

            // Limit to MaxSplineCount
            int validPathCount = validPaths.Count;
            if (validPaths.Count > MaxSplineCount)
            {
                validPaths = validPaths.GetRange(0, MaxSplineCount);
            }

            // Ensure we have a material for mesh rendering
            var materialToUse = VineMaterial;
            if (materialToUse == null && GenerateMeshes)
            {
                materialToUse = CreateDefaultVineMaterial();
            }

            int processedCount = 0;
            int totalPaths = validPaths.Count;
            int totalOriginalPoints = 0;
            int totalSmoothedPoints = 0;

            // Create splines for valid paths
            for (int pathIdx = 0; pathIdx < validPaths.Count; pathIdx++)
            {
                var (path, worldLength) = validPaths[pathIdx];

#if UNITY_EDITOR
                if (totalPaths > 50)
                {
                    float progress = (float)processedCount / totalPaths;
                    EditorUtility.DisplayProgressBar("Converting Vines to Splines",
                        $"Processing path {processedCount + 1} of {totalPaths}...", progress);
                }
#endif

                // Create SplineContainer at world origin so knot positions work correctly
                var splineGO = new GameObject($"VinePath_{_generatedSplines.Count}");
                splineGO.transform.SetParent(transform, true);
                splineGO.transform.position = Vector3.zero;
                splineGO.transform.rotation = Quaternion.identity;
                // Ensure world scale is (1,1,1) regardless of parent's scale
                var parentScale = transform.lossyScale;
                splineGO.transform.localScale = new Vector3(
                    1f / parentScale.x,
                    1f / parentScale.y,
                    1f / parentScale.z
                );

                var splineContainer = splineGO.AddComponent<SplineContainer>();
                if (splineContainer.Splines.Count > 0)
                {
                    splineContainer.RemoveSplineAt(0);
                }
                var spline = splineContainer.AddSpline();

                // Convert node indices to positions
                var positions = path.Select(i => (float3)_generatedNodes[i].Position).ToList();
                totalOriginalPoints += positions.Count;

                // Apply smoothing if enabled
                if (EnablePathSmoothing && SmoothingTolerance > 0)
                {
                    var smoothed = new List<float3>();
                    SplineUtility.ReducePoints(positions, smoothed, SmoothingTolerance);
                    positions = smoothed;
                }
                totalSmoothedPoints += positions.Count;

                // Add knots from (possibly smoothed) positions
                foreach (var pos in positions)
                {
                    var knot = new BezierKnot(pos);
                    spline.Add(knot, TangentMode.AutoSmooth);
                }

#if UNITY_EDITOR
                if (!Application.isPlaying)
                {
                    EditorUtility.SetDirty(splineContainer);
                }
#endif

                // Generate mesh directly on this spline's GameObject
                if (GenerateMeshes)
                {
                    var meshFilter = splineGO.AddComponent<MeshFilter>();
                    var meshRenderer = splineGO.AddComponent<MeshRenderer>();

                    meshRenderer.sharedMaterial = materialToUse;

                    var splineExtrude = splineGO.AddComponent<SplineExtrude>();
                    splineExtrude.Container = splineContainer;
                    splineExtrude.Radius = VineRadius;
                    splineExtrude.Sides = VineSegments;
                    splineExtrude.SegmentsPerUnit = VineSegmentsPerUnit;
                    splineExtrude.Capped = true;
                    splineExtrude.Rebuild();

                    // Always add SplineMeshController for glow effects
                    var meshController = splineGO.AddComponent<SplineMeshController>();
                    meshController.MeshTarget = meshRenderer;
                    meshController.glowLength = GlowLength;
                    meshController.glowBrightness = GlowBrightness;
                    meshController.showHideDuration = GlowShowHideDuration;
                    meshController.glowMix = 0f; // Start hidden
                    meshController.glowLocation = 0f;
                }

                _generatedSplines.Add(splineContainer);
                processedCount++;
            }

#if UNITY_EDITOR
            EditorUtility.ClearProgressBar();
#endif

            // Branch connections are no longer needed since splines are now continuous from root to tip
            // Each spline is a complete path - no junctions to track
            Debug.Log($"VineGenerator: Created {_generatedSplines.Count} continuous splines (no branch connections needed)");

            // Log creation and smoothing statistics
            var smoothingInfo = EnablePathSmoothing && SmoothingTolerance > 0
                ? $", smoothed {totalOriginalPoints} -> {totalSmoothedPoints} points ({100 - (totalSmoothedPoints * 100 / Mathf.Max(1, totalOriginalPoints))}% reduction)"
                : "";
            var meshInfo = GenerateMeshes ? ", per-spline meshes" : "";
            Debug.Log($"VineGenerator: Created {_generatedSplines.Count} continuous splines from {paths.Count} total paths ({validPathCount} valid, max {MaxSplineCount}{meshInfo}{smoothingInfo})");

            // Validate generated splines
            int validSplines = 0;
            foreach (var splineContainer in _generatedSplines)
            {
                if (splineContainer != null && splineContainer.Spline != null && splineContainer.Spline.Count > 0)
                {
                    validSplines++;
                }
            }
            Debug.Log($"[VineSpline] {validSplines}/{_generatedSplines.Count} splines are valid for grinding");

            // Notify rail grinder to refresh its spline cache
            var railGrinder = ThirdPersonController_RailGrinder.Instance;
            if (railGrinder != null)
            {
                //railGrinder.RefreshSplineContainers();
            }
            else
            {
                Debug.LogWarning("[VineSpline] ThirdPersonController_RailGrinder.Instance is null - splines won't be grindable until player spawns");
            }

            // Spawn pickups on generated splines
            SpawnPickUpsOnSplines();

            // In Path or Billboard mode with loop mode enabled, assign vines to halves
            if ((AttractorGenerationMode == AttractorMode.Path || AttractorGenerationMode == AttractorMode.Billboard)
                && CityManager != null && CityManager.IsLoopMode)
            {
                AssignVinesToHalves(CityManager.LoopState);
            }

            return _generatedSplines;
        }

        private void FilterCloseBranches(HashSet<int> branchPoints, Dictionary<int, List<int>> childLookup)
        {
            if (branchPoints.Count < 2) return;

            var branchList = branchPoints.ToList();
            var toRemove = new HashSet<int>();

            // Check each pair of branch points
            for (int i = 0; i < branchList.Count; i++)
            {
                if (toRemove.Contains(branchList[i])) continue;

                var posI = _generatedNodes[branchList[i]].Position;

                for (int j = i + 1; j < branchList.Count; j++)
                {
                    if (toRemove.Contains(branchList[j])) continue;

                    var posJ = _generatedNodes[branchList[j]].Position;
                    float dist = Vector3.Distance(posI, posJ);

                    if (dist < MinBranchSeparation)
                    {
                        // Remove the branch point with fewer children
                        int childCountI = childLookup[branchList[i]].Count;
                        int childCountJ = childLookup[branchList[j]].Count;

                        int nodeToRemove = childCountI <= childCountJ ? branchList[i] : branchList[j];
                        toRemove.Add(nodeToRemove);

                        Debug.Log($"VineGenerator: Pruning branch point {nodeToRemove} (too close to another branch, dist={dist:F2}m)");
                    }
                }
            }

            // Remove the pruned branch points
            foreach (int node in toRemove)
            {
                branchPoints.Remove(node);
            }

            if (toRemove.Count > 0)
            {
                Debug.Log($"VineGenerator: Filtered {toRemove.Count} branch points due to MinBranchSeparation ({MinBranchSeparation}m)");
            }
        }

        [SerializeField, HideInInspector]
        private GameObject _combinedMeshObject;

        private void ClearCombinedMesh()
        {
            if (_combinedMeshObject != null)
            {
                if (Application.isPlaying)
                    Destroy(_combinedMeshObject);
                else
                    DestroyImmediate(_combinedMeshObject);

                _combinedMeshObject = null;
            }
        }

        private Material CreateDefaultVineMaterial()
        {
            // Create a simple green vine material using URP Lit shader
            var shader = Shader.Find("Universal Render Pipeline/Lit");
            if (shader == null)
            {
                shader = Shader.Find("Standard");
            }

            var material = new Material(shader);
            material.name = "DefaultVineMaterial";
            material.color = new Color(0.2f, 0.5f, 0.15f); // Dark green
            material.SetFloat("_Smoothness", 0.3f);

            return material;
        }

        private void SpawnPickUpsOnSplines()
        {
            if (PickUpPrefab == null || PickUpCount <= 0 || _generatedSplines.Count == 0)
                return;

            var random = new System.Random(Seed + 12345); // Different seed for pickups

            for (int i = 0; i < PickUpCount; i++)
            {
                int splineIndex = random.Next(_generatedSplines.Count);
                var randomSpline = _generatedSplines[splineIndex];

                if (randomSpline == null || randomSpline.Spline == null)
                    continue;

                float randomT = MinPickUpSpacing + (float)random.NextDouble() * (1f - 2f * MinPickUpSpacing);

                randomSpline.Evaluate(randomT, out float3 position, out float3 tangent, out float3 upVector);

                var rotation = math.lengthsq(tangent) < float.Epsilon || math.lengthsq(upVector) < float.Epsilon
                    ? Quaternion.identity
                    : Quaternion.LookRotation(tangent, upVector);

                var spawnPos = (Vector3)position + (Vector3)math.normalize(upVector) * PickUpHeightOffset;

                var pickupInstance = Instantiate(PickUpPrefab, spawnPos, rotation, randomSpline.transform);

                // Set collection radius to account for height offset so player can collect while grinding
                var pickupScript = pickupInstance.GetComponent<HolyRail.Scripts.PickUp>();
                if (pickupScript != null)
                {
                    pickupScript.CollectionRadius = PickUpHeightOffset + 0.5f;
                }
            }

            Debug.Log($"VineGenerator: Spawned {PickUpCount} pickups across {_generatedSplines.Count} splines");
        }

        public void Clear()
        {
            _generatedNodes.Clear();
            _generatedAttractors.Clear();
            ClearSplines();
            ClearCombinedMesh();
            ReleaseBuffers();
        }

        private void ClearSplines()
        {
            foreach (var spline in _generatedSplines)
            {
                if (spline != null)
                {
                    if (Application.isPlaying)
                        Destroy(spline.gameObject);
                    else
                        DestroyImmediate(spline.gameObject);
                }
            }
            _generatedSplines.Clear();
            _halfASplines.Clear();
            _halfBSplines.Clear();
        }

        /// <summary>
        /// Assigns generated splines to loop mode halves based on their MIDPOINT position.
        /// Using midpoint instead of start position ensures vines that span the junction
        /// are assigned to the half where most of their length resides.
        /// Should be called after ConvertToSplines() when CityManager is in loop mode.
        /// </summary>
        public void AssignVinesToHalves(City.LoopModeState loopState)
        {
            if (loopState == null || !loopState.IsActive)
                return;

            _halfASplines.Clear();
            _halfBSplines.Clear();

            foreach (var splineContainer in _generatedSplines)
            {
                if (splineContainer == null || splineContainer.Spline == null || splineContainer.Spline.Count == 0)
                    continue;

                // Use midpoint of spline instead of start position
                // This ensures vines spanning the junction are assigned to the correct half
                Vector3 midPos = GetSplineMidpoint(splineContainer);

                // Determine which half this spline belongs to based on midpoint
                float distToHalfA = GetDistanceToPathPoints(midPos, loopState.HalfA.PathPoints);
                float distToHalfB = GetDistanceToPathPoints(midPos, loopState.HalfB.PathPoints);

                if (distToHalfA <= distToHalfB)
                {
                    _halfASplines.Add(splineContainer);
                }
                else
                {
                    _halfBSplines.Add(splineContainer);
                }
            }

            Debug.Log($"VineGenerator: Assigned {_halfASplines.Count} vines to HalfA, {_halfBSplines.Count} vines to HalfB");
        }

        /// <summary>
        /// Gets the world-space midpoint of a spline by evaluating at t=0.5.
        /// </summary>
        private Vector3 GetSplineMidpoint(SplineContainer container)
        {
            if (container?.Spline == null || container.Spline.Count == 0)
                return Vector3.zero;

            // Evaluate at t=0.5 to get midpoint
            container.Spline.Evaluate(0.5f, out float3 pos, out _, out _);
            return container.transform.TransformPoint(pos);
        }

        private float GetDistanceToPathPoints(Vector3 position, List<Vector3> pathPoints)
        {
            if (pathPoints == null || pathPoints.Count == 0)
                return float.MaxValue;

            float minDist = float.MaxValue;
            foreach (var point in pathPoints)
            {
                float dist = Vector3.Distance(position, point);
                minDist = Mathf.Min(minDist, dist);
            }
            return minDist;
        }

        /// <summary>
        /// Moves all splines belonging to the specified half by the given offset.
        /// Used during loop mode leapfrog operations.
        /// Note: We only move the transform - SplineExtrude mesh is in local space
        /// and moves automatically. No rebuild needed (rebuild was causing huge hitch).
        /// </summary>
        public void MoveVineHalf(int halfId, Vector3 offset)
        {
            var splinesToMove = halfId == 0 ? _halfASplines : _halfBSplines;

            if (splinesToMove == null || splinesToMove.Count == 0)
            {
                Debug.LogWarning($"VineGenerator: No splines to move for half {halfId}");
                return;
            }

            int movedCount = 0;
            foreach (var splineContainer in splinesToMove)
            {
                if (splineContainer != null)
                {
                    splineContainer.transform.position += offset;
                    movedCount++;
                    // Note: SplineExtrude.Rebuild() is NOT needed here!
                    // The extruded mesh is in local space and moves with the transform.
                    // Calling Rebuild() was causing massive frame hitches during leapfrog.
                }
            }

            Debug.Log($"VineGenerator: Moved {movedCount} vines for half {halfId} by {offset}");
        }

        private void OnEnable()
        {
            if (CityManager != null)
            {
                CityManager.OnCityRegenerated += HandleCityRegenerated;
            }
        }

        private void OnDisable()
        {
            if (CityManager != null)
            {
                CityManager.OnCityRegenerated -= HandleCityRegenerated;
            }
            ReleaseBuffers();
        }

        private void HandleCityRegenerated()
        {
            if (AttractorGenerationMode == AttractorMode.Path ||
                AttractorGenerationMode == AttractorMode.Billboard)
            {
                Regenerate();
            }
        }

        private void OnDrawGizmos()
        {
            if (!HasData) return;

            // Draw attractors
            if (ShowAttractors)
            {
                Gizmos.color = AttractorColor;
                foreach (var attractor in _generatedAttractors)
                {
                    if (attractor.Active == 1)
                    {
                        Gizmos.DrawWireSphere(attractor.Position, AttractorGizmoSize);
                    }
                }
            }

            // Draw nodes
            if (ShowNodes)
            {
                Gizmos.color = NodeColor;
                foreach (var node in _generatedNodes)
                {
                    Gizmos.DrawSphere(node.Position, GizmoSize);
                }
            }

            // Draw connections
            if (ShowConnections)
            {
                Gizmos.color = ConnectionColor;
                foreach (var node in _generatedNodes)
                {
                    if (node.ParentIndex >= 0 && node.ParentIndex < _generatedNodes.Count)
                    {
                        Gizmos.DrawLine(node.Position, _generatedNodes[node.ParentIndex].Position);
                    }
                }
            }
        }

        private void OnDrawGizmosSelected()
        {
            // Draw bounds
            Gizmos.color = new Color(1f, 0.5f, 0f, 0.5f); // Orange
            Gizmos.DrawWireCube(AttractorBounds.center, AttractorBounds.size);

            // Draw root points
            Gizmos.color = Color.red;
            foreach (var root in RootPoints)
            {
                if (root != null)
                {
                    Gizmos.DrawSphere(root.position, GizmoSize * 2f);
                }
            }
        }
    }
}
