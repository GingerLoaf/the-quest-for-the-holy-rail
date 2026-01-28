using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
using StarterAssets;
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
        Free  // Independent flowing splines without branching
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

        [Header("Direction Bias")]
        [field: SerializeField] public Vector3 ForwardDirection { get; set; } = Vector3.forward;
        [field: SerializeField, Range(0f, 2f)] public float ForwardBias { get; set; } = 0.5f;

        [Header("Free Mode Settings")]
        [field: SerializeField] public int FreeSplineCount { get; set; } = 10;
        [field: SerializeField] public Vector2 FreeLengthRange { get; set; } = new Vector2(20f, 50f);
        [field: SerializeField] public int FreePointsPerSpline { get; set; } = 20;
        [field: SerializeField] public Vector3 FreeNoiseAmplitude { get; set; } = new Vector3(2f, 2f, 0f);  // Right, Up, Forward
        [field: SerializeField] public Vector3 FreeNoiseFrequency { get; set; } = new Vector3(0.5f, 0.3f, 0f);  // Right, Up, Forward

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
            if (AttractorGenerationMode != AttractorMode.Free && VineComputeShader == null)
            {
                Debug.LogError("VineGenerator: ComputeShader is not assigned!");
                return;
            }

            if (AttractorGenerationMode != AttractorMode.Free && RootPoints.Count == 0)
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
            }
            finally
            {
                // Cleanup buffers
                ReleaseBuffers();
            }
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

            // Track which edges have been meshed to avoid z-fighting on shared trunk sections
            // Key is (min node index, max node index) to make edge order-independent
            var meshedEdges = new HashSet<(int, int)>();

            // Collect meshes for batching
            var meshesToCombine = new List<CombineInstance>();
            var tempSplineObjects = new List<GameObject>();

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
                // This is critical for grinding speed: GetLength() returns local-space length,
                // but TransformPoint() uses world scale. If world scale != 1, grinding speed is wrong.
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

                // Generate mesh for batching - only for un-meshed portions of the path
                if (GenerateMeshes)
                {
                    // Find the first un-meshed edge in this path
                    int meshStartIdx = 0;
                    for (int i = 1; i < path.Count; i++)
                    {
                        var edge = MakeEdgeKey(path[i - 1], path[i]);
                        if (!meshedEdges.Contains(edge))
                        {
                            meshStartIdx = i - 1;
                            break;
                        }
                        meshStartIdx = i; // All edges so far are meshed, start from next
                    }

                    // Mark all edges from meshStartIdx onward as meshed
                    for (int i = meshStartIdx + 1; i < path.Count; i++)
                    {
                        var edge = MakeEdgeKey(path[i - 1], path[i]);
                        meshedEdges.Add(edge);
                    }

                    // Only create mesh if we have un-meshed portion
                    if (meshStartIdx < path.Count - 1)
                    {
                        // Create a temporary spline for just the un-meshed portion
                        var meshPositions = new List<float3>();
                        for (int i = meshStartIdx; i < path.Count; i++)
                        {
                            meshPositions.Add((float3)_generatedNodes[path[i]].Position);
                        }

                        // Apply smoothing to mesh portion if enabled
                        if (EnablePathSmoothing && SmoothingTolerance > 0)
                        {
                            var smoothed = new List<float3>();
                            SplineUtility.ReducePoints(meshPositions, smoothed, SmoothingTolerance);
                            meshPositions = smoothed;
                        }

                        // Create temporary spline container for mesh generation
                        var tempMeshGO = new GameObject($"TempMesh_{pathIdx}");
                        tempMeshGO.transform.SetParent(transform, true);
                        tempMeshGO.transform.position = Vector3.zero;
                        tempMeshGO.transform.rotation = Quaternion.identity;
                        tempMeshGO.transform.localScale = Vector3.one;

                        var tempSplineContainer = tempMeshGO.AddComponent<SplineContainer>();
                        if (tempSplineContainer.Splines.Count > 0)
                        {
                            tempSplineContainer.RemoveSplineAt(0);
                        }
                        var tempSpline = tempSplineContainer.AddSpline();

                        foreach (var pos in meshPositions)
                        {
                            var knot = new BezierKnot(pos);
                            tempSpline.Add(knot, TangentMode.AutoSmooth);
                        }

                        var meshFilter = tempMeshGO.AddComponent<MeshFilter>();
                        var splineExtrude = tempMeshGO.AddComponent<SplineExtrude>();
                        splineExtrude.Container = tempSplineContainer;
                        splineExtrude.Radius = VineRadius;
                        splineExtrude.Sides = VineSegments;
                        splineExtrude.SegmentsPerUnit = VineSegmentsPerUnit;
                        splineExtrude.Capped = true;
                        splineExtrude.Rebuild();

                        if (meshFilter.sharedMesh != null && meshFilter.sharedMesh.vertexCount > 0)
                        {
                            meshesToCombine.Add(new CombineInstance
                            {
                                mesh = meshFilter.sharedMesh,
                                transform = tempMeshGO.transform.localToWorldMatrix
                            });
                        }

                        tempSplineObjects.Add(tempMeshGO);
                    }
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

            // Combine all meshes into one for single draw call
            if (GenerateMeshes && meshesToCombine.Count > 0)
            {
                CombineVineMeshes(meshesToCombine, materialToUse, tempSplineObjects);
            }

            // Log creation and smoothing statistics
            var smoothingInfo = EnablePathSmoothing && SmoothingTolerance > 0
                ? $", smoothed {totalOriginalPoints} -> {totalSmoothedPoints} points ({100 - (totalSmoothedPoints * 100 / Mathf.Max(1, totalOriginalPoints))}% reduction)"
                : "";
            Debug.Log($"VineGenerator: Created {_generatedSplines.Count} continuous splines from {paths.Count} total paths ({validPathCount} valid, max {MaxSplineCount}, batched into 1 mesh{smoothingInfo})");

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

            return _generatedSplines;
        }

        // Helper to create an order-independent edge key for deduplication
        private static (int, int) MakeEdgeKey(int a, int b)
        {
            return a < b ? (a, b) : (b, a);
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

        private void CombineVineMeshes(List<CombineInstance> meshesToCombine, Material material, List<GameObject> tempObjects)
        {
            // Create combined mesh
            var combinedMesh = new Mesh();
            combinedMesh.name = "CombinedVineMesh";
            combinedMesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32; // Support large meshes
            combinedMesh.CombineMeshes(meshesToCombine.ToArray(), true, true);
            combinedMesh.RecalculateBounds();

            // Create single GameObject for all vines
            _combinedMeshObject = new GameObject("VineMesh_Combined");
            _combinedMeshObject.transform.SetParent(transform, false);
            _combinedMeshObject.transform.position = Vector3.zero;
            _combinedMeshObject.transform.rotation = Quaternion.identity;

            var meshFilter = _combinedMeshObject.AddComponent<MeshFilter>();
            meshFilter.sharedMesh = combinedMesh;

            var meshRenderer = _combinedMeshObject.AddComponent<MeshRenderer>();
            meshRenderer.sharedMaterial = material;

            // Destroy temporary mesh generation objects (they are not spline containers, just temp mesh holders)
            foreach (var tempGO in tempObjects)
            {
                if (Application.isPlaying)
                {
                    Destroy(tempGO);
                }
                else
                {
                    DestroyImmediate(tempGO);
                }
            }

            Debug.Log($"VineGenerator: Combined {meshesToCombine.Count} meshes into 1 (verts: {combinedMesh.vertexCount}, tris: {combinedMesh.triangles.Length / 3})");
        }

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
        }

        private void OnDisable()
        {
            ReleaseBuffers();
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
