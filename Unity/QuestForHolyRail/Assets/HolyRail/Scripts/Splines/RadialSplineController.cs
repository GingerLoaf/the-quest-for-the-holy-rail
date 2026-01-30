using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Splines;
using Unity.Mathematics;
using StarterAssets;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.Splines
{
    /// <summary>
    /// GPU-powered system that radially clones a master spline around a circle.
    /// All clones are oriented toward the center, update in real-time in the editor,
    /// and work with the existing grinding system.
    /// </summary>
    [ExecuteAlways]
    public class RadialSplineController : MonoBehaviour
    {
        [Header("Master Spline")]
        [field: SerializeField]
        public SplineContainer MasterSpline { get; private set; }

        [Header("Radial Configuration")]
        [field: SerializeField]
        public float CircleRadius { get; private set; } = 10f;

        [field: SerializeField, Range(1, 32)]
        public int CloneCount { get; private set; } = 8;

        [Header("Mirroring")]
        [field: SerializeField, Tooltip("Flip spline shape on X axis for alternating clones")]
        public bool MirrorX { get; private set; }

        [field: SerializeField, Tooltip("Flip spline shape on Z axis for alternating clones")]
        public bool MirrorZ { get; private set; }

        [field: SerializeField]
        public RadialSymmetryMode SymmetryMode { get; private set; } = RadialSymmetryMode.None;

        [Header("Spline Noise")]
        [field: SerializeField, Tooltip("Enable procedural noise deformation on spline knots")]
        public bool NoiseEnabled { get; private set; }

        [field: SerializeField]
        public SplineNoiseType NoiseType { get; private set; } = SplineNoiseType.Simplex;

        [field: SerializeField]
        public float NoiseFrequency { get; private set; } = 1f;

        [field: SerializeField]
        public float NoiseAmplitude { get; private set; } = 0.5f;

        [field: SerializeField, Tooltip("Per-axis amplitude multiplier")]
        public Vector3 NoiseScale { get; private set; } = Vector3.one;

        [field: SerializeField]
        public int NoiseSeed { get; private set; }

        [Header("Rendering")]
        [field: SerializeField]
        public Material SplineMaterial { get; private set; }

        [field: SerializeField, Tooltip("Auto-extracted from SplineExtrude if not set")]
        public Mesh SourceMesh { get; private set; }

        [Header("Debug")]
        [field: SerializeField]
        public bool ShowGizmos { get; private set; } = true;

        // Clone data for GPU
        private List<RadialCloneData> _cloneData = new List<RadialCloneData>();

        // Grindable spline containers (child GameObjects)
        private List<SplineContainer> _grindableContainers = new List<SplineContainer>();

        // GPU rendering resources
        private GraphicsBuffer _transformBuffer;
        private GraphicsBuffer _argsBuffer;
        private MaterialPropertyBlock _propertyBlock;
        private Bounds _renderBounds;
        private bool _buffersInitialized;

        // Dirty tracking
        private bool _needsRegeneration;
        private Vector3 _lastPosition;
        private Quaternion _lastRotation;

        // Original knot data for non-destructive noise application
        private List<List<BezierKnot>> _originalKnots = new List<List<BezierKnot>>();
        private bool _knotsCached;
        private bool _isApplyingNoise;

        // Edit debouncing - don't regenerate while user is actively dragging
        private double _lastSplineEditTime;
        private const double EditDebounceSeconds = 0.15;

        public IReadOnlyList<RadialCloneData> CloneData => _cloneData;
        public int ActiveCloneCount => _cloneData.Count;

        private void OnEnable()
        {
            SubscribeToSplineChanges();

            if (_cloneData.Count > 0 && !_buffersInitialized)
            {
                InitializeBuffers();
            }
            else if (MasterSpline != null)
            {
                Regenerate();
            }
        }

        private void OnDisable()
        {
            UnsubscribeFromSplineChanges();
            ReleaseBuffers();
        }

        private void OnDestroy()
        {
            ReleaseBuffers();
            ClearGrindableContainers();
        }

        private void Update()
        {
            // Check if transform has changed
            if (transform.position != _lastPosition || transform.rotation != _lastRotation)
            {
                _needsRegeneration = true;
                _lastPosition = transform.position;
                _lastRotation = transform.rotation;
            }

            if (_needsRegeneration)
            {
#if UNITY_EDITOR
                // In editor, debounce during active spline editing to prevent fighting
                if (!Application.isPlaying)
                {
                    double timeSinceEdit = EditorApplication.timeSinceStartup - _lastSplineEditTime;
                    if (timeSinceEdit < EditDebounceSeconds)
                    {
                        // Still editing, defer regeneration until user stops dragging
                        if (_buffersInitialized && SplineMaterial != null && SourceMesh != null)
                        {
                            RenderClones();
                        }
                        return;
                    }
                }
#endif
                _needsRegeneration = false;
                Regenerate();
            }

            if (_buffersInitialized && SplineMaterial != null && SourceMesh != null)
            {
                RenderClones();
            }
        }

#if UNITY_EDITOR
        private void OnValidate()
        {
            // Delay regeneration to avoid issues during serialization
            EditorApplication.delayCall += () =>
            {
                if (this != null)
                {
                    _needsRegeneration = true;
                }
            };
        }
#endif

        /// <summary>
        /// Full rebuild of all clone data and grindable containers.
        /// </summary>
        public void Regenerate()
        {
            if (MasterSpline == null)
            {
                Debug.LogWarning("RadialSplineController: No master spline assigned.");
                return;
            }

            // Try to auto-extract mesh from SplineExtrude
            if (SourceMesh == null)
            {
                TryExtractMeshFromSplineExtrude();
            }

            // Cache original knots before applying noise
            CacheOriginalKnots();

            // Apply noise to master spline (non-destructive, uses cached originals)
            ApplyNoiseToMasterSpline();

            CalculateCloneTransforms();

            // Position the master spline at clone position 0
            PositionMasterSpline();

            CreateGrindableContainers();
            InitializeBuffers();
        }

        /// <summary>
        /// Cache original knot positions from master spline for non-destructive noise.
        /// Only caches once per master spline assignment.
        /// </summary>
        private void CacheOriginalKnots()
        {
            if (MasterSpline == null)
                return;

            // Check if cache is valid
            bool needsRecache = !_knotsCached || _originalKnots.Count != MasterSpline.Splines.Count;

            if (!needsRecache)
            {
                // Verify knot counts match
                for (int s = 0; s < MasterSpline.Splines.Count; s++)
                {
                    if (_originalKnots[s].Count != MasterSpline.Splines[s].Count)
                    {
                        needsRecache = true;
                        break;
                    }
                }
            }

            if (!needsRecache)
                return;

            _originalKnots.Clear();

            foreach (var spline in MasterSpline.Splines)
            {
                var knotList = new List<BezierKnot>();
                foreach (var knot in spline.Knots)
                {
                    knotList.Add(knot);
                }
                _originalKnots.Add(knotList);
            }

            _knotsCached = true;
        }

        /// <summary>
        /// Force recache of original knots. Call this after manually editing the master spline.
        /// </summary>
        public void InvalidateKnotCache()
        {
            _knotsCached = false;
        }

        /// <summary>
        /// Apply noise offsets to master spline knots.
        /// Uses cached original positions for non-destructive editing.
        /// </summary>
        private void ApplyNoiseToMasterSpline()
        {
            if (MasterSpline == null || _originalKnots.Count == 0)
                return;

            _isApplyingNoise = true;
            try
            {
                for (int s = 0; s < MasterSpline.Splines.Count && s < _originalKnots.Count; s++)
                {
                    var spline = MasterSpline.Splines[s];
                    var originalKnotList = _originalKnots[s];

                    for (int k = 0; k < spline.Count && k < originalKnotList.Count; k++)
                    {
                        var originalKnot = originalKnotList[k];
                        var noisyKnot = originalKnot;

                        if (NoiseEnabled && NoiseAmplitude > 0f)
                        {
                            noisyKnot.Position = ApplyNoiseToPosition(originalKnot.Position, s, k);
                        }

                        spline[k] = noisyKnot;
                    }
                }
            }
            finally
            {
                _isApplyingNoise = false;
            }
        }

        /// <summary>
        /// Apply noise offset to a single knot position.
        /// </summary>
        private float3 ApplyNoiseToPosition(float3 originalPos, int splineIndex, int knotIndex)
        {
            // Create sample position with seed offset for variation
            var seedOffset = new float3(NoiseSeed * 17.31f, NoiseSeed * 31.17f, NoiseSeed * 47.73f);
            var samplePos = originalPos * NoiseFrequency + seedOffset;

            // Add unique offset per knot to prevent all knots moving identically
            samplePos += new float3(knotIndex * 7.13f, splineIndex * 11.37f, 0f);

            // Sample noise for each axis
            var noiseValue = SplineNoise.SampleNoise3D(samplePos, NoiseType, 1f);

            // Apply per-axis amplitude scaling
            var offset = noiseValue * NoiseAmplitude * (float3)NoiseScale;

            return originalPos + offset;
        }

        /// <summary>
        /// Position the master spline at clone position 0 on the circle.
        /// </summary>
        private void PositionMasterSpline()
        {
            if (MasterSpline == null || _cloneData.Count == 0)
                return;

            var clone0 = _cloneData[0];
            MasterSpline.transform.position = clone0.Position;
            MasterSpline.transform.rotation = new Quaternion(clone0.Rotation.x, clone0.Rotation.y, clone0.Rotation.z, clone0.Rotation.w);
            MasterSpline.transform.localScale = clone0.Scale;
        }

        /// <summary>
        /// Calculate radial positions and rotations for all clones.
        /// </summary>
        private void CalculateCloneTransforms()
        {
            _cloneData.Clear();

            var center = transform.position;
            float angleStep = 360f / CloneCount;

            for (int i = 0; i < CloneCount; i++)
            {
                float angle = i * angleStep;
                float rad = angle * Mathf.Deg2Rad;

                // Position on circle
                var pos = center + new Vector3(
                    Mathf.Sin(rad) * CircleRadius,
                    0f,
                    Mathf.Cos(rad) * CircleRadius
                );

                // Rotation facing center
                var toCenter = (center - pos).normalized;
                var rotation = Quaternion.LookRotation(toCenter, Vector3.up);

                // Calculate mirror scale based on toggles and symmetry mode
                var scale = CalculateMirrorScale(i, angle);

                _cloneData.Add(new RadialCloneData
                {
                    Position = pos,
                    Rotation = new Vector4(rotation.x, rotation.y, rotation.z, rotation.w),
                    Scale = scale,
                    CloneIndex = i
                });
            }
        }

        /// <summary>
        /// Calculate mirror scale based on clone index, angle, and symmetry mode.
        /// </summary>
        private Vector3 CalculateMirrorScale(int index, float angle)
        {
            float scaleX = 1f;
            float scaleZ = 1f;

            // Individual flip toggles (alternating pattern)
            if (MirrorX && index % 2 == 1)
                scaleX = -1f;
            if (MirrorZ && index % 2 == 1)
                scaleZ = -1f;

            // Radial symmetry modes (based on angle quadrant/octant)
            switch (SymmetryMode)
            {
                case RadialSymmetryMode.TwoFold:
                    // Mirror across 180 axis
                    if (angle >= 180f)
                        scaleX *= -1f;
                    break;

                case RadialSymmetryMode.FourFold:
                    // Mirror in quadrants (90 segments)
                    int quadrant = (int)(angle / 90f) % 4;
                    if (quadrant == 1 || quadrant == 2)
                        scaleX *= -1f;
                    if (quadrant == 2 || quadrant == 3)
                        scaleZ *= -1f;
                    break;

                case RadialSymmetryMode.EightFold:
                    // Mirror in octants (45 segments)
                    int octant = (int)(angle / 45f) % 8;
                    if (octant % 2 == 1)
                        scaleX *= -1f;
                    if (octant >= 4)
                        scaleZ *= -1f;
                    break;
            }

            return new Vector3(scaleX, 1f, scaleZ);
        }

        /// <summary>
        /// Create child GameObjects with SplineContainer for grinding detection.
        /// Skip index 0 since the master spline serves as the grindable spline at that position.
        /// </summary>
        private void CreateGrindableContainers()
        {
            ClearGrindableContainers();

            if (MasterSpline == null || MasterSpline.Splines == null || MasterSpline.Splines.Count == 0)
                return;

            foreach (var clone in _cloneData)
            {
                // Skip index 0 - master spline is already at this position
                if (clone.CloneIndex == 0)
                    continue;

                var go = new GameObject($"GrindSpline_{clone.CloneIndex}");
                go.transform.SetParent(transform);
                go.transform.position = clone.Position;
                go.transform.rotation = new Quaternion(clone.Rotation.x, clone.Rotation.y, clone.Rotation.z, clone.Rotation.w);
                go.transform.localScale = clone.Scale;

                var container = go.AddComponent<SplineContainer>();
                CopySplineKnots(MasterSpline, container, clone.Scale);

                _grindableContainers.Add(container);
            }

            // Notify grinding system to refresh its cache (runtime only)
            if (Application.isPlaying)
            {
                var grindController = FindFirstObjectByType<ThirdPersonController_RailGrinder>();
                grindController?.RefreshSplineContainers();
            }
        }

        /// <summary>
        /// Copy spline knots from master to clone container.
        /// </summary>
        private void CopySplineKnots(SplineContainer source, SplineContainer target, Vector3 mirrorScale)
        {
            // Clear existing splines (Splines is IReadOnlyList, so use RemoveSplineAt)
            while (target.Splines.Count > 0)
            {
                target.RemoveSplineAt(0);
            }

            foreach (var sourceSpline in source.Splines)
            {
                var newSpline = new Spline();
                newSpline.Closed = sourceSpline.Closed;

                foreach (var knot in sourceSpline.Knots)
                {
                    var newKnot = knot;

                    // Apply mirror scale to knot position
                    var pos = knot.Position;
                    pos.x *= mirrorScale.x;
                    pos.z *= mirrorScale.z;
                    newKnot.Position = pos;

                    // Mirror tangents as well
                    var tangentIn = knot.TangentIn;
                    tangentIn.x *= mirrorScale.x;
                    tangentIn.z *= mirrorScale.z;
                    newKnot.TangentIn = tangentIn;

                    var tangentOut = knot.TangentOut;
                    tangentOut.x *= mirrorScale.x;
                    tangentOut.z *= mirrorScale.z;
                    newKnot.TangentOut = tangentOut;

                    newSpline.Add(newKnot);
                }

                target.AddSpline(newSpline);
            }
        }

        /// <summary>
        /// Clear all child grindable containers.
        /// </summary>
        private void ClearGrindableContainers()
        {
            foreach (var container in _grindableContainers)
            {
                if (container != null && container.gameObject != null)
                {
#if UNITY_EDITOR
                    if (!Application.isPlaying)
                        DestroyImmediate(container.gameObject);
                    else
#endif
                        Destroy(container.gameObject);
                }
            }
            _grindableContainers.Clear();

            // Also clean up any orphaned children
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i);
                if (child.name.StartsWith("GrindSpline_"))
                {
#if UNITY_EDITOR
                    if (!Application.isPlaying)
                        DestroyImmediate(child.gameObject);
                    else
#endif
                        Destroy(child.gameObject);
                }
            }
        }

        /// <summary>
        /// Try to extract mesh from SplineExtrude component on master spline.
        /// </summary>
        private void TryExtractMeshFromSplineExtrude()
        {
            if (MasterSpline == null)
                return;

            var meshFilter = MasterSpline.GetComponent<MeshFilter>();
            if (meshFilter != null && meshFilter.sharedMesh != null)
            {
                SourceMesh = meshFilter.sharedMesh;
                Debug.Log($"RadialSplineController: Auto-extracted mesh '{SourceMesh.name}' from MeshFilter");
            }
        }

        /// <summary>
        /// Initialize GPU buffers for instanced rendering.
        /// </summary>
        private void InitializeBuffers()
        {
            ReleaseBuffers();

            if (_cloneData.Count == 0 || SourceMesh == null)
                return;

            int stride = Marshal.SizeOf<RadialCloneData>(); // 44 bytes

            _transformBuffer = new GraphicsBuffer(
                GraphicsBuffer.Target.Structured,
                _cloneData.Count,
                stride
            );
            _transformBuffer.SetData(_cloneData.ToArray());

            _argsBuffer = new GraphicsBuffer(
                GraphicsBuffer.Target.IndirectArguments,
                1,
                5 * sizeof(uint)
            );
            _argsBuffer.SetData(new uint[]
            {
                SourceMesh.GetIndexCount(0),
                (uint)_cloneData.Count,
                SourceMesh.GetIndexStart(0),
                SourceMesh.GetBaseVertex(0),
                0
            });

            _propertyBlock = new MaterialPropertyBlock();
            _propertyBlock.SetBuffer("_CloneBuffer", _transformBuffer);

            // Calculate render bounds to encompass all clones
            float maxExtent = CircleRadius + 50f; // Add padding for mesh size
            _renderBounds = new Bounds(
                transform.position,
                new Vector3(maxExtent * 2f, 100f, maxExtent * 2f)
            );

            _buffersInitialized = true;
        }

        /// <summary>
        /// Release GPU buffers.
        /// </summary>
        private void ReleaseBuffers()
        {
            _transformBuffer?.Release();
            _transformBuffer = null;

            _argsBuffer?.Release();
            _argsBuffer = null;

            _propertyBlock = null;
            _buffersInitialized = false;
        }

        /// <summary>
        /// Render all clones using GPU instancing.
        /// </summary>
        private void RenderClones()
        {
            if (_argsBuffer == null || _propertyBlock == null || SplineMaterial == null || SourceMesh == null)
                return;

            _propertyBlock.SetBuffer("_CloneBuffer", _transformBuffer);

            var renderParams = new RenderParams(SplineMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _propertyBlock,
                receiveShadows = true,
                shadowCastingMode = ShadowCastingMode.On
            };

            Graphics.RenderMeshIndirect(
                renderParams,
                SourceMesh,
                _argsBuffer
            );
        }

        /// <summary>
        /// Subscribe to spline change events.
        /// </summary>
        private void SubscribeToSplineChanges()
        {
            Spline.Changed += OnSplineChanged;
        }

        /// <summary>
        /// Unsubscribe from spline change events.
        /// </summary>
        private void UnsubscribeFromSplineChanges()
        {
            Spline.Changed -= OnSplineChanged;
        }

        /// <summary>
        /// Handle spline change events.
        /// </summary>
        private void OnSplineChanged(Spline spline, int knotIndex, SplineModification modification)
        {
            // Ignore changes we're making programmatically during noise application
            if (_isApplyingNoise)
                return;

            if (MasterSpline == null)
                return;

#if UNITY_EDITOR
            // Track edit time for debouncing
            _lastSplineEditTime = EditorApplication.timeSinceStartup;
#endif

            // Check if the changed spline belongs to our master
            for (int s = 0; s < MasterSpline.Splines.Count; s++)
            {
                if (ReferenceEquals(MasterSpline.Splines[s], spline))
                {
                    // User edited the spline - update the cached original to reflect their edit
                    // We need to account for the fact that the spline currently has noise applied
                    if (_knotsCached && knotIndex >= 0 && s < _originalKnots.Count && knotIndex < _originalKnots[s].Count)
                    {
                        // Get the current (edited) knot from the spline
                        var editedKnot = spline[knotIndex];

                        // If noise was applied, the user is editing the noisy position
                        // We need to store their edit as the new "original" (pre-noise) position
                        // by subtracting what the noise offset would have been
                        if (NoiseEnabled && NoiseAmplitude > 0f)
                        {
                            var originalPos = _originalKnots[s][knotIndex].Position;
                            var noiseOffset = ApplyNoiseToPosition(originalPos, s, knotIndex) - originalPos;
                            editedKnot.Position = (float3)editedKnot.Position - noiseOffset;
                        }

                        _originalKnots[s][knotIndex] = editedKnot;
                    }
                    else
                    {
                        // Cache structure changed, need full recache
                        _knotsCached = false;
                    }

                    _needsRegeneration = true;
                    return;
                }
            }
        }

#if UNITY_EDITOR
        private void OnDrawGizmosSelected()
        {
            if (!ShowGizmos)
                return;

            var center = transform.position;

            // Draw circle
            Gizmos.color = new Color(0.5f, 0.8f, 1f, 0.5f);
            DrawGizmoCircle(center, CircleRadius, 32);

            // Draw clone positions
            foreach (var clone in _cloneData)
            {
                Gizmos.color = new Color(1f, 0.5f, 0.2f, 0.8f);
                Gizmos.DrawWireSphere(clone.Position, 0.5f);

                // Draw direction arrow toward center
                var rotation = new Quaternion(clone.Rotation.x, clone.Rotation.y, clone.Rotation.z, clone.Rotation.w);
                var forward = rotation * Vector3.forward;
                Gizmos.color = Color.green;
                Gizmos.DrawRay(clone.Position, forward * 2f);

                // Indicate mirroring with colored lines
                if (clone.Scale.x < 0 || clone.Scale.z < 0)
                {
                    Gizmos.color = Color.magenta;
                    if (clone.Scale.x < 0)
                        Gizmos.DrawRay(clone.Position, rotation * Vector3.right * 1.5f);
                    if (clone.Scale.z < 0)
                        Gizmos.DrawRay(clone.Position, rotation * Vector3.up * 1.5f);
                }
            }
        }

        private void DrawGizmoCircle(Vector3 center, float radius, int segments)
        {
            float angleStep = 360f / segments;
            Vector3 prevPoint = center + new Vector3(0, 0, radius);

            for (int i = 1; i <= segments; i++)
            {
                float angle = i * angleStep * Mathf.Deg2Rad;
                Vector3 point = center + new Vector3(Mathf.Sin(angle) * radius, 0, Mathf.Cos(angle) * radius);
                Gizmos.DrawLine(prevPoint, point);
                prevPoint = point;
            }
        }
#endif
    }
}
