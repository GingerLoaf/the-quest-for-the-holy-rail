using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.Trees
{
    [ExecuteInEditMode]
    public class SpaceColonizationTree : MonoBehaviour
    {
        private struct TreeNode
        {
            public Vector3 Position;
            public int ParentIndex;
            public float DistanceFromRoot;
        }

        private struct Attractor
        {
            public Vector3 Position;
            public bool Active;
        }

        [Header("Editor")]
        [field: SerializeField] public bool AutoUpdate { get; set; } = false;

        [Header("Seed")]
        [field: SerializeField] public int Seed { get; set; } = 12345;

        [Header("Algorithm")]
        [field: SerializeField, Range(1, 1000)] public int MaxIterations { get; set; } = 100;
        [field: SerializeField, Range(0.1f, 2f)] public float StepSize { get; set; } = 0.5f;
        [field: SerializeField, Range(0.5f, 20f)] public float AttractionRadius { get; set; } = 5f;
        [field: SerializeField, Range(0.1f, 5f)] public float KillRadius { get; set; } = 0.5f;

        [Header("Volume")]
        [field: SerializeField] public Bounds AttractorBounds { get; set; } = new Bounds(Vector3.zero, Vector3.one * 10f);
        [field: SerializeField, Range(100, 10000)] public int AttractorCount { get; set; } = 1000;

        [Header("Roots")]
        [field: SerializeField] public List<Transform> RootPoints { get; private set; } = new List<Transform>();

        [Header("Direction")]
        [field: SerializeField] public Vector3 BiasDirection { get; set; } = Vector3.forward;
        [field: SerializeField, Range(0f, 1f)] public float BiasStrength { get; set; } = 0.15f;

        [Header("Variation")]
        [field: SerializeField, Range(0f, 1f)] public float NoiseStrength { get; set; } = 0.25f;
        [field: SerializeField] public float NoiseScale { get; set; } = 0.5f;

        [Header("Branching")]
        [field: SerializeField, Range(0f, 1f)] public float BranchDensity { get; set; } = 0.8f;
        [field: SerializeField, Range(0f, 90f)] public float MinBranchSpreadAngle { get; set; } = 20f;
        [field: SerializeField, Range(0f, 10f)] public float MinBranchSeparation { get; set; } = 0.5f;

        [Header("Filtering")]
        [field: SerializeField, Range(2, 50)] public int MinSplineNodeCount { get; set; } = 3;
        [field: SerializeField, Range(0.5f, 20f)] public float MinSplineWorldLength { get; set; } = 1f;

        [Header("Smoothing")]
        [field: SerializeField] public bool EnablePathSmoothing { get; set; } = true;
        [field: SerializeField, Range(0f, 2f)] public float SmoothingTolerance { get; set; } = 0.8f;

        [Header("Material")]
        [field: SerializeField] public Material TaperedMaterial { get; set; }

        [Header("Mesh")]
        [field: SerializeField, Range(0.02f, 0.5f)] public float TubeRadius { get; set; } = 0.08f;
        [field: SerializeField, Range(3, 12)] public int TubeSides { get; set; } = 6;
        [field: SerializeField, Range(1, 8)] public int SegmentsPerUnit { get; set; } = 4;

        [Header("Taper")]
        [field: SerializeField] public bool EnableEndTapering { get; set; } = true;
        [field: SerializeField, Range(0f, 5f)] public float EndTaperDistance { get; set; } = 1.5f;
        [field: SerializeField, Range(0f, 1f)] public float DistanceTaperStrength { get; set; } = 0.3f;

        [Header("Visualization")]
        [field: SerializeField] public bool ShowAttractors { get; set; } = false;
        [field: SerializeField] public bool ShowNodes { get; set; } = true;
        [field: SerializeField] public Color NodeColor { get; set; } = Color.green;
        [field: SerializeField] public Color LineColor { get; set; } = Color.yellow;
        [field: SerializeField] public Color AttractorColor { get; set; } = Color.cyan;
        [field: SerializeField] public float GizmoSize { get; set; } = 0.1f;

        private List<TreeNode> _nodes = new List<TreeNode>();
        private List<Attractor> _attractors = new List<Attractor>();
        private List<SplineContainer> _generatedSplines = new List<SplineContainer>();
        private System.Random _random;

        public int NodeCount => _nodes.Count;
        public int SplineCount => _generatedSplines.Count;
        public int ActiveAttractorCount => _attractors.Count(a => a.Active);
        public bool HasTreeData => _nodes.Count > 0;
        public bool HasMeshData => _generatedSplines.Count > 0;
        public bool HasData => HasTreeData || HasMeshData;

        /// <summary>
        /// Phase 1: Generate tree structure (nodes only, no meshes).
        /// Results are shown as gizmo lines in the scene view.
        /// </summary>
        public void GenerateTree()
        {
            ClearTree();
            _random = new System.Random(Seed);

            ScatterAttractors();
            InitializeRoots();
            RunColonization();

            Debug.Log($"SpaceColonizationTree: Generated {_nodes.Count} nodes, {ActiveAttractorCount} attractors remaining");

#if UNITY_EDITOR
            SceneView.RepaintAll();
#endif
        }

        /// <summary>
        /// Phase 2: Generate meshes from existing tree structure.
        /// Requires GenerateTree() to have been called first.
        /// </summary>
        public void GenerateMeshes()
        {
            if (_nodes.Count == 0)
            {
                Debug.LogWarning("SpaceColonizationTree: No tree data. Call GenerateTree() first.");
                return;
            }

            ClearMeshes();

            var paths = ExtractPaths();
            CreateSplinesAndMeshes(paths);

            Debug.Log($"SpaceColonizationTree: Created {_generatedSplines.Count} splines from {paths.Count} paths");
        }

        /// <summary>
        /// Clears tree node data (keeps meshes).
        /// </summary>
        public void ClearTree()
        {
            _nodes.Clear();
            _attractors.Clear();

#if UNITY_EDITOR
            if (!Application.isPlaying)
                UnityEditor.SceneManagement.EditorSceneManager.MarkSceneDirty(gameObject.scene);
#endif
        }

        /// <summary>
        /// Clears generated meshes and splines (keeps tree nodes).
        /// </summary>
        public void ClearMeshes()
        {
            foreach (var splineContainer in _generatedSplines)
            {
                if (splineContainer != null)
                {
#if UNITY_EDITOR
                    if (!Application.isPlaying)
                        DestroyImmediate(splineContainer.gameObject);
                    else
#endif
                        Destroy(splineContainer.gameObject);
                }
            }
            _generatedSplines.Clear();

#if UNITY_EDITOR
            if (!Application.isPlaying)
                UnityEditor.SceneManagement.EditorSceneManager.MarkSceneDirty(gameObject.scene);
#endif
        }

        /// <summary>
        /// Clears everything (tree nodes and meshes).
        /// </summary>
        public void Clear()
        {
            ClearMeshes();
            ClearTree();
        }

        private void ScatterAttractors()
        {
            var center = transform.TransformPoint(AttractorBounds.center);
            var extents = AttractorBounds.extents;

            for (int i = 0; i < AttractorCount; i++)
            {
                var localPos = new Vector3(
                    (float)(_random.NextDouble() * 2 - 1) * extents.x,
                    (float)(_random.NextDouble() * 2 - 1) * extents.y,
                    (float)(_random.NextDouble() * 2 - 1) * extents.z
                );

                _attractors.Add(new Attractor
                {
                    Position = center + localPos,
                    Active = true
                });
            }
        }

        private void InitializeRoots()
        {
            if (RootPoints == null || RootPoints.Count == 0)
            {
                _nodes.Add(new TreeNode
                {
                    Position = transform.position,
                    ParentIndex = -1,
                    DistanceFromRoot = 0f
                });
                Debug.Log($"SpaceColonizationTree: Using transform position as root: {transform.position}");
                return;
            }

            foreach (var root in RootPoints)
            {
                if (root != null)
                {
                    _nodes.Add(new TreeNode
                    {
                        Position = root.position,
                        ParentIndex = -1,
                        DistanceFromRoot = 0f
                    });
                    Debug.Log($"SpaceColonizationTree: Added root at {root.position}");
                }
            }
        }

        private void RunColonization()
        {
            int branchCooldown = Mathf.RoundToInt(Mathf.Lerp(15, 1, BranchDensity));
            var lastGrowIteration = new Dictionary<int, int>();

            // Check if any attractors are within range of roots
            int attractorsInRange = 0;
            foreach (var node in _nodes)
            {
                foreach (var attractor in _attractors)
                {
                    if (Vector3.Distance(attractor.Position, node.Position) <= AttractionRadius)
                        attractorsInRange++;
                }
            }

            if (attractorsInRange == 0)
            {
                Debug.LogWarning($"SpaceColonizationTree: No attractors within AttractionRadius ({AttractionRadius}) of root nodes. " +
                    $"Try increasing AttractionRadius or moving roots closer to AttractorBounds.");
                return;
            }

            for (int iteration = 0; iteration < MaxIterations; iteration++)
            {
                var nodeVotes = new Dictionary<int, List<int>>();

                for (int a = 0; a < _attractors.Count; a++)
                {
                    if (!_attractors[a].Active)
                        continue;

                    int nearestNode = -1;
                    float nearestDist = AttractionRadius;

                    for (int n = 0; n < _nodes.Count; n++)
                    {
                        float dist = Vector3.Distance(_attractors[a].Position, _nodes[n].Position);
                        if (dist < nearestDist)
                        {
                            nearestDist = dist;
                            nearestNode = n;
                        }
                    }

                    if (nearestNode >= 0)
                    {
                        if (!nodeVotes.ContainsKey(nearestNode))
                            nodeVotes[nearestNode] = new List<int>();
                        nodeVotes[nearestNode].Add(a);
                    }
                }

                if (nodeVotes.Count == 0)
                    break;

                var newNodes = new List<TreeNode>();

                foreach (var kvp in nodeVotes)
                {
                    int nodeIndex = kvp.Key;
                    var attractorIndices = kvp.Value;
                    var node = _nodes[nodeIndex];

                    if (lastGrowIteration.TryGetValue(nodeIndex, out int lastIter))
                    {
                        if (iteration - lastIter < branchCooldown)
                            continue;
                    }

                    Vector3 avgDir = Vector3.zero;
                    foreach (int a in attractorIndices)
                    {
                        avgDir += (_attractors[a].Position - node.Position).normalized;
                    }
                    avgDir = avgDir.normalized;

                    if (BiasStrength > 0f && BiasDirection.sqrMagnitude > 0.001f)
                    {
                        avgDir = Vector3.Lerp(avgDir, BiasDirection.normalized, BiasStrength).normalized;
                    }

                    if (NoiseStrength > 0f)
                    {
                        float noiseX = Mathf.PerlinNoise(node.Position.x * NoiseScale, node.Position.z * NoiseScale) * 2f - 1f;
                        float noiseY = Mathf.PerlinNoise(node.Position.y * NoiseScale, node.Position.x * NoiseScale) * 2f - 1f;
                        float noiseZ = Mathf.PerlinNoise(node.Position.z * NoiseScale, node.Position.y * NoiseScale) * 2f - 1f;

                        var noiseDir = new Vector3(noiseX, noiseY, noiseZ).normalized;
                        avgDir = Vector3.Lerp(avgDir, noiseDir, NoiseStrength).normalized;
                    }

                    var newPos = node.Position + avgDir * StepSize;
                    float newDist = node.DistanceFromRoot + StepSize;

                    if (MinBranchSeparation > 0f)
                    {
                        bool tooClose = false;

                        // Build ancestor set for this node - we're allowed to be close to our own lineage
                        var ancestors = new HashSet<int>();
                        int current = nodeIndex;
                        while (current >= 0)
                        {
                            ancestors.Add(current);
                            current = _nodes[current].ParentIndex;
                        }

                        for (int i = 0; i < _nodes.Count; i++)
                        {
                            // Skip ancestors - we're supposed to grow from them
                            if (ancestors.Contains(i))
                                continue;

                            if (Vector3.Distance(newPos, _nodes[i].Position) < MinBranchSeparation)
                            {
                                tooClose = true;
                                break;
                            }
                        }
                        foreach (var pendingNode in newNodes)
                        {
                            if (Vector3.Distance(newPos, pendingNode.Position) < MinBranchSeparation)
                            {
                                tooClose = true;
                                break;
                            }
                        }
                        if (tooClose)
                            continue;
                    }

                    newNodes.Add(new TreeNode
                    {
                        Position = newPos,
                        ParentIndex = nodeIndex,
                        DistanceFromRoot = newDist
                    });

                    lastGrowIteration[nodeIndex] = iteration;
                }

                foreach (var newNode in newNodes)
                {
                    _nodes.Add(newNode);
                }

                for (int a = 0; a < _attractors.Count; a++)
                {
                    if (!_attractors[a].Active)
                        continue;

                    foreach (var newNode in newNodes)
                    {
                        if (Vector3.Distance(_attractors[a].Position, newNode.Position) < KillRadius)
                        {
                            var attractor = _attractors[a];
                            attractor.Active = false;
                            _attractors[a] = attractor;
                            break;
                        }
                    }
                }

                int activeCount = _attractors.Count(att => att.Active);
                if (activeCount == 0)
                    break;
            }
        }

        private List<List<int>> ExtractPaths()
        {
            var childLookup = new Dictionary<int, List<int>>();
            for (int i = 0; i < _nodes.Count; i++)
            {
                int parent = _nodes[i].ParentIndex;
                if (parent >= 0)
                {
                    if (!childLookup.ContainsKey(parent))
                        childLookup[parent] = new List<int>();
                    childLookup[parent].Add(i);
                }
            }

            var leafNodes = new List<int>();
            for (int i = 0; i < _nodes.Count; i++)
            {
                if (!childLookup.ContainsKey(i))
                    leafNodes.Add(i);
            }

            var paths = new List<List<int>>();

            foreach (int leaf in leafNodes)
            {
                var path = new List<int>();
                int current = leaf;

                while (current >= 0)
                {
                    path.Add(current);
                    current = _nodes[current].ParentIndex;
                }

                path.Reverse();

                if (path.Count < MinSplineNodeCount)
                    continue;

                float worldLength = 0f;
                for (int i = 1; i < path.Count; i++)
                {
                    worldLength += Vector3.Distance(_nodes[path[i - 1]].Position, _nodes[path[i]].Position);
                }
                if (worldLength < MinSplineWorldLength)
                    continue;

                paths.Add(path);
            }

            paths.Sort((a, b) => b.Count.CompareTo(a.Count));

            return paths;
        }

        private void CreateSplinesAndMeshes(List<List<int>> paths)
        {
            var meshedSegments = new HashSet<(int, int)>();
            int processedCount = 0;

#if UNITY_EDITOR
            Material taperedMat = TaperedMaterial;
            if (taperedMat == null)
            {
                taperedMat = AssetDatabase.LoadAssetAtPath<Material>(
                    "Assets/HolyRail/Materials/ScrollingGradientTapered.mat");
            }
#else
            Material taperedMat = TaperedMaterial;
#endif

            foreach (var path in paths)
            {
                var splineGO = new GameObject($"TreeSpline_{processedCount}");
#if UNITY_EDITOR
                if (!Application.isPlaying)
                    Undo.RegisterCreatedObjectUndo(splineGO, "Create Tree Spline");
#endif
                splineGO.transform.SetParent(transform, false);

                var splineContainer = splineGO.AddComponent<SplineContainer>();
                if (splineContainer.Splines.Count > 0)
                    splineContainer.RemoveSplineAt(0);

                var spline = splineContainer.AddSpline();

                var positions = path.Select(i => (float3)_nodes[i].Position).ToList();

                if (EnablePathSmoothing && SmoothingTolerance > 0)
                {
                    var smoothed = new List<float3>();
                    SplineUtility.ReducePoints(positions, smoothed, SmoothingTolerance);
                    positions = smoothed;
                }

                foreach (var pos in positions)
                {
                    var knot = new BezierKnot(pos);
                    spline.Add(knot, TangentMode.AutoSmooth);
                }

                int meshStartIndex = 0;
                for (int i = 1; i < path.Count; i++)
                {
                    int nodeA = path[i - 1];
                    int nodeB = path[i];
                    var segment = nodeA < nodeB ? (nodeA, nodeB) : (nodeB, nodeA);

                    if (meshedSegments.Contains(segment))
                        meshStartIndex = i;
                    else
                        break;
                }

                for (int i = meshStartIndex + 1; i < path.Count; i++)
                {
                    int nodeA = path[i - 1];
                    int nodeB = path[i];
                    var segment = nodeA < nodeB ? (nodeA, nodeB) : (nodeB, nodeA);
                    meshedSegments.Add(segment);
                }

                int uniqueNodeCount = path.Count - meshStartIndex;
                if (uniqueNodeCount >= 2)
                {
                    var meshGO = new GameObject($"TreeMesh_{processedCount}");
#if UNITY_EDITOR
                    if (!Application.isPlaying)
                        Undo.RegisterCreatedObjectUndo(meshGO, "Create Tree Mesh");
#endif
                    meshGO.transform.SetParent(splineGO.transform, false);

                    var meshSplineContainer = meshGO.AddComponent<SplineContainer>();
                    if (meshSplineContainer.Splines.Count > 0)
                        meshSplineContainer.RemoveSplineAt(0);
                    var meshSpline = meshSplineContainer.AddSpline();

                    int actualMeshStart = meshStartIndex > 0 ? meshStartIndex - 1 : meshStartIndex;

                    float overlapDistance = 0f;
                    if (meshStartIndex > 0 && actualMeshStart < meshStartIndex)
                    {
                        overlapDistance = Vector3.Distance(
                            _nodes[path[actualMeshStart]].Position,
                            _nodes[path[meshStartIndex]].Position
                        );
                    }

                    for (int i = actualMeshStart; i < path.Count; i++)
                    {
                        var pos = _nodes[path[i]].Position;
                        var knot = new BezierKnot(pos);
                        meshSpline.Add(knot, TangentMode.AutoSmooth);
                    }

                    var meshFilter = meshGO.AddComponent<MeshFilter>();
                    var meshRenderer = meshGO.AddComponent<MeshRenderer>();

                    var splineExtrude = meshGO.AddComponent<SplineExtrude>();
                    splineExtrude.Container = meshSplineContainer;
                    splineExtrude.Radius = TubeRadius;
                    splineExtrude.Sides = TubeSides;

#if UNITY_EDITOR
                    var so = new SerializedObject(splineExtrude);
                    var shapeProp = so.FindProperty("m_Shape");
                    if (shapeProp != null)
                    {
                        var sidesProp = shapeProp.FindPropertyRelative("m_Sides");
                        if (sidesProp != null)
                        {
                            sidesProp.intValue = TubeSides;
                            so.ApplyModifiedPropertiesWithoutUndo();
                        }
                    }
#endif

                    splineExtrude.SegmentsPerUnit = SegmentsPerUnit;
                    splineExtrude.Capped = false;
                    splineExtrude.Rebuild();

                    float meshSplineLength = meshSpline.GetLength();
                    var mesh = meshFilter.sharedMesh;
                    if (mesh != null && meshSplineLength > 0.001f)
                    {
                        var uvs = new List<Vector2>();
                        mesh.GetUVs(0, uvs);

                        var uv2s = new List<Vector2>(uvs.Count);
                        for (int k = 0; k < uvs.Count; k++)
                        {
                            float splineT = Mathf.Clamp01(uvs[k].y / meshSplineLength);
                            uv2s.Add(new Vector2(splineT, 0f));
                        }
                        mesh.SetUVs(1, uv2s);
                    }

                    if (taperedMat != null)
                        meshRenderer.sharedMaterial = taperedMat;

                    bool isBranchMesh = meshStartIndex > 0;
                    float distanceFromRootStart = CalculateDistanceFromRoot(path, meshStartIndex);
                    float distanceFromRootEnd = CalculateDistanceFromRoot(path, path.Count - 1);
                    float splineLength = meshSplineLength;

                    float startTaperT = 0f;
                    if (isBranchMesh && overlapDistance > 0f && splineLength > 0.001f)
                        startTaperT = overlapDistance / splineLength;

                    float effectiveEndTaper = EnableEndTapering ? EndTaperDistance : 0f;

                    var propBlock = new MaterialPropertyBlock();
                    propBlock.SetFloat("_Radius", TubeRadius);
                    propBlock.SetFloat("_SplineLength", splineLength);
                    propBlock.SetFloat("_EndTaperDistance", effectiveEndTaper);
                    propBlock.SetFloat("_IsBranchMesh", isBranchMesh ? 1f : 0f);
                    propBlock.SetFloat("_StartTaperT", startTaperT);
                    propBlock.SetFloat("_DistanceTaperStrength", DistanceTaperStrength);
                    propBlock.SetFloat("_DistanceFromRootStart", distanceFromRootStart);
                    propBlock.SetFloat("_DistanceFromRootEnd", distanceFromRootEnd);
                    propBlock.SetFloat("_DistanceFromRoot", (distanceFromRootStart + distanceFromRootEnd) * 0.5f);
                    meshRenderer.SetPropertyBlock(propBlock);

                    var meshController = meshGO.AddComponent<SplineMeshController>();
                    meshController.MeshTarget = meshRenderer;
                    meshController.glowMix = 0f;
                    meshController.glowLocation = 0f;
                }

                _generatedSplines.Add(splineContainer);
                processedCount++;
            }

#if UNITY_EDITOR
            if (!Application.isPlaying)
                UnityEditor.SceneManagement.EditorSceneManager.MarkSceneDirty(gameObject.scene);
#endif
        }

        private float CalculateDistanceFromRoot(List<int> path, int startIndex)
        {
            if (path == null || path.Count < 2 || startIndex <= 0)
                return 0f;

            float distToStart = 0f;
            for (int i = 1; i <= startIndex && i < path.Count; i++)
            {
                distToStart += Vector3.Distance(
                    _nodes[path[i - 1]].Position,
                    _nodes[path[i]].Position
                );
            }

            float totalLength = distToStart;
            for (int i = startIndex + 1; i < path.Count; i++)
            {
                totalLength += Vector3.Distance(
                    _nodes[path[i - 1]].Position,
                    _nodes[path[i]].Position
                );
            }

            return totalLength > 0f ? distToStart / totalLength : 0f;
        }

        private void OnDrawGizmosSelected()
        {
            // Always draw attractor bounds
            Gizmos.color = new Color(1f, 1f, 0f, 0.3f);
            Gizmos.matrix = transform.localToWorldMatrix;
            Gizmos.DrawWireCube(AttractorBounds.center, AttractorBounds.size);
            Gizmos.matrix = Matrix4x4.identity;

            // Draw attractors if enabled
            if (ShowAttractors)
            {
                Gizmos.color = AttractorColor;
                foreach (var attractor in _attractors)
                {
                    if (attractor.Active)
                        Gizmos.DrawSphere(attractor.Position, GizmoSize * 0.3f);
                }
            }

            // Draw tree structure when nodes exist
            if (_nodes.Count > 0)
            {
                // Draw lines between nodes (yellow)
                Gizmos.color = LineColor;
                foreach (var node in _nodes)
                {
                    if (node.ParentIndex >= 0)
                    {
                        Gizmos.DrawLine(node.Position, _nodes[node.ParentIndex].Position);
                    }
                }

                // Draw all nodes as spheres (green)
                if (ShowNodes)
                {
                    Gizmos.color = NodeColor;
                    foreach (var node in _nodes)
                    {
                        Gizmos.DrawSphere(node.Position, GizmoSize);
                    }
                }
            }
        }
    }
}
