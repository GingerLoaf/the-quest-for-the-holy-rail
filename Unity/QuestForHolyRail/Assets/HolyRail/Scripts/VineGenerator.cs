using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;

namespace HolyRail.Vines
{
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

        [Header("Algorithm Settings")]
        [field: SerializeField] public ComputeShader VineComputeShader { get; private set; }
        [field: SerializeField] public int Seed { get; set; } = 12345;
        [field: SerializeField, Range(1, 500)] public int MaxIterations { get; set; } = 100;
        [field: SerializeField, Range(0.01f, 2f)] public float StepSize { get; set; } = 0.3f;
        [field: SerializeField, Range(0.1f, 20f)] public float AttractionRadius { get; set; } = 5f;
        [field: SerializeField, Range(0.01f, 1f)] public float KillRadius { get; set; } = 0.2f;

        [Header("Attractor Generation")]
        [field: SerializeField, Range(100, 50000)] public int AttractorCount { get; set; } = 5000;
        [field: SerializeField] public LayerMask AttractorSurfaceLayers { get; set; } = ~0;
        [field: SerializeField] public Bounds AttractorBounds { get; set; } = new Bounds(Vector3.zero, Vector3.one * 10f);
        [field: SerializeField, Range(0f, 2f)] public float AttractorSurfaceOffset { get; set; } = 0.1f;
        [field: SerializeField] public bool UseMultiDirectionRaycasts { get; set; } = true;

        [Header("Root Points")]
        [field: SerializeField] public List<Transform> RootPoints { get; private set; } = new List<Transform>();

        [Header("Noise")]
        [field: SerializeField, Range(0f, 1f)] public float NoiseStrength { get; set; } = 0.1f;
        [field: SerializeField] public float NoiseScale { get; set; } = 1f;

        [Header("Branching")]
        [field: SerializeField, Range(1, 20)] public int BranchCooldown { get; set; } = 3;

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
        [field: SerializeField, Range(2, 100)] public int MinSplineLength { get; set; } = 3;

        [Header("Mesh Rendering")]
        [field: SerializeField] public Material VineMaterial { get; set; }
        [field: SerializeField, Range(0.01f, 0.5f)] public float VineRadius { get; set; } = 0.05f;
        [field: SerializeField, Range(3, 16)] public int VineSegments { get; set; } = 6;
        [field: SerializeField, Range(4, 64)] public int VineSegmentsPerUnit { get; set; } = 8;
        [field: SerializeField] public bool GenerateMeshes { get; set; } = true;

        // Generated data (serialized to persist through Play mode)
        [SerializeField, HideInInspector]
        private List<VineNode> _generatedNodes = new List<VineNode>();
        [SerializeField, HideInInspector]
        private List<VineAttractor> _generatedAttractors = new List<VineAttractor>();
        [SerializeField, HideInInspector]
        private List<SplineContainer> _generatedSplines = new List<SplineContainer>();

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

        public void Regenerate()
        {
            if (VineComputeShader == null)
            {
                Debug.LogError("VineGenerator: ComputeShader is not assigned!");
                return;
            }

            if (RootPoints.Count == 0)
            {
                Debug.LogError("VineGenerator: No root points assigned!");
                return;
            }

            Clear();

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
            var directions = UseMultiDirectionRaycasts
                ? new[]
                {
                    Vector3.down, Vector3.up,
                    Vector3.left, Vector3.right,
                    Vector3.forward, Vector3.back
                }
                : new[] { Vector3.down };

            var random = new System.Random(Seed);
            _generatedAttractors = new List<VineAttractor>();

            float maxRayDist = Mathf.Max(AttractorBounds.size.x, AttractorBounds.size.y, AttractorBounds.size.z);

            for (int i = 0; i < AttractorCount; i++)
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
                    LastGrowIteration = -BranchCooldown  // Allow immediate growth on first iteration
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
                VineComputeShader.SetInt("_BranchCooldown", BranchCooldown);
                VineComputeShader.SetFloat("_StepSize", StepSize);
                VineComputeShader.SetFloat("_AttractionRadius", AttractionRadius);
                VineComputeShader.SetFloat("_KillRadius", KillRadius);
                VineComputeShader.SetFloat("_NoiseStrength", NoiseStrength);
                VineComputeShader.SetFloat("_NoiseScale", NoiseScale);

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
            if (_generatedNodes.Count == 0)
            {
                Debug.LogWarning("VineGenerator: No nodes to convert. Run Regenerate first.");
                return new List<SplineContainer>();
            }

            // Clear existing splines
            ClearSplines();

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

            // Ensure we have a material for mesh rendering
            var materialToUse = VineMaterial;
            if (materialToUse == null && GenerateMeshes)
            {
                materialToUse = CreateDefaultVineMaterial();
            }

            // For each leaf, trace back to root and create spline
            foreach (int leaf in leafNodes)
            {
                var path = new List<int>();
                int current = leaf;

                while (current >= 0)
                {
                    path.Add(current);
                    current = _generatedNodes[current].ParentIndex;
                }

                // Path is leaf-to-root, reverse to get root-to-leaf
                path.Reverse();

                // Skip short paths
                if (path.Count < MinSplineLength)
                    continue;

                // Create SplineContainer at world origin so knot positions work correctly
                var splineGO = new GameObject($"VineSpline_{_generatedSplines.Count}");
                splineGO.transform.SetParent(transform, true);
                splineGO.transform.position = Vector3.zero;
                splineGO.transform.rotation = Quaternion.identity;

                var splineContainer = splineGO.AddComponent<SplineContainer>();
                var spline = splineContainer.AddSpline();

                // Add knots (positions are world space, spline is at origin so they match)
                foreach (int nodeIndex in path)
                {
                    var node = _generatedNodes[nodeIndex];
                    var knot = new BezierKnot(node.Position);
                    spline.Add(knot, TangentMode.AutoSmooth);
                }

                // Add mesh rendering via SplineExtrude
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

                    // Rebuild the mesh
                    splineExtrude.Rebuild();
                }

                _generatedSplines.Add(splineContainer);
            }

            Debug.Log($"VineGenerator: Created {_generatedSplines.Count} splines from {leafNodes.Count} leaf nodes");

            return _generatedSplines;
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
