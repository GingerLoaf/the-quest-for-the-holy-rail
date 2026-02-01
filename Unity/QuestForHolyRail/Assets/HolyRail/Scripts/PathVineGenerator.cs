using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
using System.Collections.Generic;
using System.Linq;
using HolyRail.City;
using StarterAssets;
using Random = UnityEngine.Random;

namespace HolyRail
{
    public struct GraffitiCandidate
    {
        public Vector3 Position;
        public Vector3 SplineTangent;
        public float DistanceToWall;
        public float SplineDistance;  // Cumulative distance along all splines (for segmenting)
    }

    public class PathVineGenerator : MonoBehaviour
    {
        [Header("References")]
        [SerializeField] private CityManager _cityManager;
        [SerializeField] private Transform _splineParent;

        [Header("Vine Settings")]
        [SerializeField] private int _vinesPerCorridor = 3;
        [SerializeField] private Vector2 _vineLengthRange = new Vector2(25f, 120f);
        [SerializeField] private float _corridorWidth = 20f;
        [SerializeField] private Vector2 _heightRange = new Vector2(2f, 15f);
        [SerializeField] private float _minVineSpacing = 5f;
        [SerializeField] private float _pointSpacing = 2f;
        [SerializeField] private bool _mirrorX;

        [Header("Noise Settings")]
        [SerializeField] private float _lateralNoiseAmplitude = 5f;
        [SerializeField] private float _lateralNoiseFrequency = 0.1f;
        [SerializeField] private float _verticalNoiseAmplitude = 3f;
        [SerializeField] private float _verticalNoiseFrequency = 0.1f;

        [Header("Avoidance Settings")]
        [SerializeField] private float _groundPadding = 1f;
        [SerializeField] private LayerMask _rampLayer;
        [SerializeField] private float _rampPadding = 2f;
        [SerializeField] private float _buildingPadding = 3f;

        private IReadOnlyList<BuildingData> _buildingCache;

        [Header("Waypoint Exclusion")]
        [SerializeField] private bool _excludeConvergencePoint = true;
        [SerializeField] private float _convergencePointPadding = 25f;

        [SerializeField] private bool _excludeEndpointA = true;
        [SerializeField] private bool _excludeEndpointB = true;
        [SerializeField] private bool _excludeEndpointC = true;
        [SerializeField] private float _endpointPadding = 25f;

        [SerializeField] private bool _excludeConvergenceEndPoint = true;
        [SerializeField] private float _convergenceEndPointPadding = 25f;

        [SerializeField] private bool _excludeFinalEndPoint = true;
        [SerializeField] private float _finalEndPointPadding = 25f;

        [SerializeField] private bool _excludeJunctionAB = true;
        [SerializeField] private bool _excludeJunctionBC = true;
        [SerializeField] private float _junctionPadding = 25f;

        [Header("Smoothing")]
        [SerializeField] private bool _enableSmoothing = true;
        [SerializeField] private float _smoothingTolerance = 0.5f;

        [Header("Grinding")]
        [SerializeField] private bool _makeGrindable = true;

        [Header("Mesh Rendering")]
        [SerializeField] private bool _generateMesh = true;
        [SerializeField] private Material _vineMaterial;
        [SerializeField] private float _vineRadius = 0.1f;
        [SerializeField] private int _meshSides = 8;
        [SerializeField] private int _segmentsPerUnit = 4;

        [Header("Editor")]
        [SerializeField] private bool _liveUpdate;

        [Header("Graffiti Sampling")]
        [SerializeField] private float _graffitiSampleSpacing = 3f;

        public bool LiveUpdate => _liveUpdate;

        private readonly List<GameObject> _generatedVines = new List<GameObject>();

        private void Start()
        {
            // Refresh grind controller's spline cache for any pre-existing vines (generated in editor)
            if (_makeGrindable && _generatedVines.Count > 0)
            {
                var grindController = FindFirstObjectByType<ThirdPersonController_RailGrinder>();
                grindController?.RefreshSplineContainers();
            }
        }

        private readonly List<SplineSample> _cachedSplineSamples = new List<SplineSample>();
        private int _vineIndex;
        private IReadOnlyList<Vector3> _currentCorridor;

        private struct SplineSample
        {
            public Vector3 Position;
            public Vector3 Tangent;
            public float CumulativeDistance;
        }

        private float _totalSplineLength;

        public float GetTotalSplineLength() => _totalSplineLength;

        public void Generate()
        {
            Clear();
            _vineIndex = 0;

            if (_cityManager == null)
            {
                Debug.LogError("PathVineGenerator: CityManager reference is not set.");
                return;
            }

            if (_splineParent == null)
            {
                Debug.LogError("PathVineGenerator: Spline parent reference is not set.");
                return;
            }

            _buildingCache = _cityManager.Buildings;

            GenerateVinesForCorridor(_cityManager.CorridorPathA, "A");
            GenerateVinesForCorridor(_cityManager.CorridorPathB, "B");
            if (_cityManager.CorridorPathB_ToBC != null && _cityManager.CorridorPathB_ToBC.Count > 1)
                GenerateVinesForCorridor(_cityManager.CorridorPathB_ToBC, "B_ToBC");
            GenerateVinesForCorridor(_cityManager.CorridorPathC, "C");

            CacheSplineSamples();

            Debug.Log($"PathVineGenerator: Generated {_generatedVines.Count} vines, cached {_cachedSplineSamples.Count} samples.");

            // Auto-generate meshes when not in live update mode
            if (_generateMesh && !_liveUpdate)
            {
                GenerateMeshes();
            }

            if (_makeGrindable)
            {
                var grindController = FindFirstObjectByType<ThirdPersonController_RailGrinder>();
                grindController?.RefreshSplineContainers();
            }
        }

        public void Clear()
        {
            // Destroy tracked vines
            foreach (var vine in _generatedVines)
            {
                if (vine != null)
                {
                    if (Application.isPlaying)
                        Destroy(vine);
                    else
                        DestroyImmediate(vine);
                }
            }
            _generatedVines.Clear();
            _cachedSplineSamples.Clear();

            // Also destroy any orphaned children of _splineParent
            if (_splineParent != null)
            {
                for (int i = _splineParent.childCount - 1; i >= 0; i--)
                {
                    var child = _splineParent.GetChild(i).gameObject;
                    if (Application.isPlaying)
                        Destroy(child);
                    else
                        DestroyImmediate(child);
                }
            }

            _vineIndex = 0;

            if (_makeGrindable)
            {
                var grindController = FindFirstObjectByType<ThirdPersonController_RailGrinder>();
                grindController?.RefreshSplineContainers();
            }
        }

        public void GenerateMeshes()
        {
            if (_vineMaterial == null)
            {
                Debug.LogWarning("PathVineGenerator: No vine material assigned.");
                return;
            }

            int count = 0;
            foreach (var vine in _generatedVines)
            {
                if (vine == null) continue;

                // Skip if already has mesh components
                if (vine.GetComponent<SplineExtrude>() != null) continue;

                var container = vine.GetComponent<SplineContainer>();
                if (container == null) continue;

                vine.AddComponent<MeshFilter>();
                var meshRenderer = vine.AddComponent<MeshRenderer>();
                meshRenderer.sharedMaterial = _vineMaterial;

                var splineExtrude = vine.AddComponent<SplineExtrude>();
                splineExtrude.Container = container;
                splineExtrude.Radius = _vineRadius;
                splineExtrude.Sides = _meshSides;
                splineExtrude.SegmentsPerUnit = _segmentsPerUnit;
                splineExtrude.Rebuild();
                count++;
            }

            Debug.Log($"PathVineGenerator: Added meshes to {count} vines.");
        }

        private void GenerateVinesForCorridor(IReadOnlyList<Vector3> corridor, string corridorName)
        {
            if (corridor == null || corridor.Count < 2)
            {
                Debug.LogWarning($"PathVineGenerator: Corridor {corridorName} is empty or invalid.");
                return;
            }

            _currentCorridor = corridor;

            float corridorLength = CalculateCorridorLength(corridor);
            if (corridorLength < _vineLengthRange.x)
            {
                Debug.LogWarning($"PathVineGenerator: Corridor {corridorName} is too short ({corridorLength:F1}m).");
                return;
            }

            var usedStarts = new List<float>();

            for (int i = 0; i < _vinesPerCorridor; i++)
            {
                float vineLength = Random.Range(_vineLengthRange.x, _vineLengthRange.y);
                vineLength = Mathf.Min(vineLength, corridorLength);

                float maxStart = corridorLength - vineLength;
                float startDist = FindValidStartDistance(usedStarts, maxStart, vineLength);

                if (startDist < 0f)
                {
                    Debug.LogWarning($"PathVineGenerator: Could not find valid start for vine {i} in corridor {corridorName}.");
                    continue;
                }

                usedStarts.Add(startDist);

                var points = GenerateVinePoints(corridor, startDist, vineLength);
                if (points.Count < 2)
                    continue;

                var splineContainer = CreateSpline(points, $"Vine_{corridorName}_{_vineIndex}");
                if (splineContainer != null)
                {
                    _generatedVines.Add(splineContainer.gameObject);
                    _vineIndex++;

                    // Create mirrored vine if enabled
                    if (_mirrorX)
                    {
                        // Mirror points across the path centerline (not global X)
                        var mirroredPoints = new List<Vector3>(points.Count);
                        foreach (var p in points)
                        {
                            var mirrored = MirrorPointAcrossPath(p, corridor);
                            mirrored = ApplyAvoidance(mirrored);
                            mirrored = ClampToCorridorBounds(mirrored);

                            // Skip points near exclusion waypoints
                            if (!IsNearExclusionWaypoint(mirrored))
                                mirroredPoints.Add(mirrored);
                        }

                        // Refine mirrored points for segment avoidance
                        mirroredPoints = RefinePointsForAvoidance(mirroredPoints);

                        if (mirroredPoints.Count >= 2)
                        {
                            var mirroredSpline = CreateSpline(mirroredPoints, $"Vine_{corridorName}_{_vineIndex}_Mirror");
                            if (mirroredSpline != null)
                            {
                                _generatedVines.Add(mirroredSpline.gameObject);
                                _vineIndex++;
                            }
                        }
                    }
                }
            }
        }

        private float FindValidStartDistance(List<float> usedStarts, float maxStart, float vineLength)
        {
            const int maxAttempts = 50;

            for (int attempt = 0; attempt < maxAttempts; attempt++)
            {
                float candidate = Random.Range(0f, maxStart);
                bool valid = true;

                foreach (float used in usedStarts)
                {
                    if (Mathf.Abs(candidate - used) < _minVineSpacing)
                    {
                        valid = false;
                        break;
                    }
                }

                if (valid)
                    return candidate;
            }

            return -1f;
        }

        private float CalculateCorridorLength(IReadOnlyList<Vector3> corridor)
        {
            float length = 0f;
            for (int i = 0; i < corridor.Count - 1; i++)
            {
                length += Vector3.Distance(corridor[i], corridor[i + 1]);
            }
            return length;
        }

        private (Vector3 position, Vector3 tangent) SampleCorridorPath(IReadOnlyList<Vector3> corridor, float distance)
        {
            float accumulated = 0f;
            for (int i = 0; i < corridor.Count - 1; i++)
            {
                float segLen = Vector3.Distance(corridor[i], corridor[i + 1]);
                if (accumulated + segLen >= distance)
                {
                    float t = (distance - accumulated) / segLen;
                    var pos = Vector3.Lerp(corridor[i], corridor[i + 1], t);
                    var tangent = (corridor[i + 1] - corridor[i]).normalized;
                    return (pos, tangent);
                }
                accumulated += segLen;
            }

            // Past end - return last point
            int last = corridor.Count - 1;
            return (corridor[last], (corridor[last] - corridor[last - 1]).normalized);
        }

        private List<Vector3> GenerateVinePoints(IReadOnlyList<Vector3> corridor, float startDist, float length)
        {
            var points = new List<Vector3>();

            // Random lateral offset within corridor width
            float lateralOffset = Random.Range(-_corridorWidth * 0.5f, _corridorWidth * 0.5f);
            // Random base height
            float baseHeight = Random.Range(_heightRange.x, _heightRange.y);
            // Random noise seed for this vine
            float noiseSeed = Random.Range(0f, 1000f);

            int numPoints = Mathf.Max(2, Mathf.CeilToInt(length / _pointSpacing) + 1);

            for (int i = 0; i < numPoints; i++)
            {
                float t = i / (float)(numPoints - 1);
                float dist = startDist + t * length;

                var (pos, tangent) = SampleCorridorPath(corridor, dist);

                // Calculate perpendicular vector (right direction)
                var right = Vector3.Cross(Vector3.up, tangent).normalized;

                // Apply lateral offset
                var point = pos + right * lateralOffset;

                // Apply base height
                point.y += baseHeight;

                // Apply Perlin noise undulation
                float noiseX = Mathf.PerlinNoise(dist * _lateralNoiseFrequency + noiseSeed, 0f) * 2f - 1f;
                float noiseY = Mathf.PerlinNoise(dist * _verticalNoiseFrequency + noiseSeed, 100f) * 2f - 1f;

                point += right * noiseX * _lateralNoiseAmplitude;
                point.y += noiseY * _verticalNoiseAmplitude;

                // Avoidance and corridor bounds
                point = ApplyAvoidance(point);
                point = ClampToCorridorBounds(point);

                // Skip points near exclusion waypoints (convergence points, endpoints, junctions)
                if (IsNearExclusionWaypoint(point))
                    continue;

                points.Add(point);
            }

            // Refine points to ensure segments don't pass through obstacles
            points = RefinePointsForAvoidance(points);

            return points;
        }

        private bool IsNearExclusionWaypoint(Vector3 point)
        {
            if (_cityManager == null)
                return false;

            // Convergence Point (start plaza)
            if (_excludeConvergencePoint && _cityManager.ConvergencePoint != null)
            {
                float radiusSq = _convergencePointPadding * _convergencePointPadding;
                if ((point - _cityManager.ConvergencePoint.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Endpoint A
            if (_excludeEndpointA && _cityManager.EndpointA != null)
            {
                float radiusSq = _endpointPadding * _endpointPadding;
                if ((point - _cityManager.EndpointA.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Endpoint B
            if (_excludeEndpointB && _cityManager.EndpointB != null)
            {
                float radiusSq = _endpointPadding * _endpointPadding;
                if ((point - _cityManager.EndpointB.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Endpoint C
            if (_excludeEndpointC && _cityManager.EndpointC != null)
            {
                float radiusSq = _endpointPadding * _endpointPadding;
                if ((point - _cityManager.EndpointC.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Convergence End Point (end plaza)
            if (_excludeConvergenceEndPoint && _cityManager.ConvergenceEndPoint != null)
            {
                float radiusSq = _convergenceEndPointPadding * _convergenceEndPointPadding;
                if ((point - _cityManager.ConvergenceEndPoint.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Final End Point
            if (_excludeFinalEndPoint && _cityManager.FinalEndPoint != null)
            {
                float radiusSq = _finalEndPointPadding * _finalEndPointPadding;
                if ((point - _cityManager.FinalEndPoint.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Junction AB
            if (_excludeJunctionAB && _cityManager.JunctionAB != null)
            {
                float radiusSq = _junctionPadding * _junctionPadding;
                if ((point - _cityManager.JunctionAB.position).sqrMagnitude < radiusSq)
                    return true;
            }

            // Junction BC
            if (_excludeJunctionBC && _cityManager.JunctionBC != null)
            {
                float radiusSq = _junctionPadding * _junctionPadding;
                if ((point - _cityManager.JunctionBC.position).sqrMagnitude < radiusSq)
                    return true;
            }

            return false;
        }

        private Vector3 ApplyAvoidance(Vector3 point)
        {
            // Ground avoidance (Y=0)
            float minY = _groundPadding;
            if (point.y < minY)
                point.y = minY;

            // Ramp avoidance - raycast down to find ramps
            if (_rampLayer != 0)
            {
                var rayOrigin = point + Vector3.up * 100f;
                if (Physics.Raycast(rayOrigin, Vector3.down, out var hit, 200f, _rampLayer))
                {
                    float rampMinY = hit.point.y + _rampPadding;
                    if (point.y < rampMinY)
                        point.y = rampMinY;
                }
            }

            // Building avoidance - check against building data directly
            if (_buildingCache != null && _buildingCache.Count > 0)
            {
                foreach (var building in _buildingCache)
                {
                    float dist = CalculateDistanceToBuildingSurface(point, building);
                    if (dist < _buildingPadding && dist > -_buildingPadding)
                    {
                        // Push away from building - find direction
                        var toPoint = point - building.Position;
                        toPoint.y = 0;
                        if (toPoint.sqrMagnitude > 0.001f)
                        {
                            point = building.Position + toPoint.normalized *
                                (GetBuildingHalfExtent(building, toPoint.normalized) + _buildingPadding);
                            point.y = Mathf.Max(point.y, _groundPadding);
                        }
                    }
                }
            }

            return point;
        }

        private Vector3 ClampToCorridorBounds(Vector3 point)
        {
            if (_currentCorridor == null || _currentCorridor.Count < 2)
                return point;

            // Find the nearest point on the corridor path
            float minDistSq = float.MaxValue;
            Vector3 nearestOnCorridor = point;
            Vector3 corridorTangent = Vector3.forward;

            for (int i = 0; i < _currentCorridor.Count - 1; i++)
            {
                var a = _currentCorridor[i];
                var b = _currentCorridor[i + 1];

                // Project point onto segment (ignoring Y)
                var aFlat = new Vector3(a.x, 0f, a.z);
                var bFlat = new Vector3(b.x, 0f, b.z);
                var pFlat = new Vector3(point.x, 0f, point.z);

                var ab = bFlat - aFlat;
                float abLenSq = ab.sqrMagnitude;
                if (abLenSq < 0.0001f) continue;

                float t = Mathf.Clamp01(Vector3.Dot(pFlat - aFlat, ab) / abLenSq);
                var projectedFlat = aFlat + ab * t;
                float distSq = (pFlat - projectedFlat).sqrMagnitude;

                if (distSq < minDistSq)
                {
                    minDistSq = distSq;
                    // Keep Y from the corridor interpolation
                    nearestOnCorridor = Vector3.Lerp(a, b, t);
                    nearestOnCorridor.y = 0f; // Corridor is at ground level
                    corridorTangent = (b - a).normalized;
                }
            }

            // Calculate lateral offset from corridor center
            var right = Vector3.Cross(Vector3.up, corridorTangent).normalized;
            var toPoint = new Vector3(point.x - nearestOnCorridor.x, 0f, point.z - nearestOnCorridor.z);
            float lateralDist = Vector3.Dot(toPoint, right);

            // Clamp to corridor width
            float maxLateral = _corridorWidth * 0.5f;
            if (Mathf.Abs(lateralDist) > maxLateral)
            {
                float clampedLateral = Mathf.Sign(lateralDist) * maxLateral;
                point.x = nearestOnCorridor.x + right.x * clampedLateral;
                point.z = nearestOnCorridor.z + right.z * clampedLateral;
            }

            return point;
        }

        private Vector3 MirrorPointAcrossPath(Vector3 point, IReadOnlyList<Vector3> corridor)
        {
            if (corridor == null || corridor.Count < 2)
                return point;

            // Find the nearest point on the corridor path
            float minDistSq = float.MaxValue;
            Vector3 nearestOnCorridor = point;
            Vector3 corridorTangent = Vector3.forward;

            for (int i = 0; i < corridor.Count - 1; i++)
            {
                var a = corridor[i];
                var b = corridor[i + 1];

                // Project point onto segment (ignoring Y)
                var aFlat = new Vector3(a.x, 0f, a.z);
                var bFlat = new Vector3(b.x, 0f, b.z);
                var pFlat = new Vector3(point.x, 0f, point.z);

                var ab = bFlat - aFlat;
                float abLenSq = ab.sqrMagnitude;
                if (abLenSq < 0.0001f) continue;

                float t = Mathf.Clamp01(Vector3.Dot(pFlat - aFlat, ab) / abLenSq);
                var projectedFlat = aFlat + ab * t;
                float distSq = (pFlat - projectedFlat).sqrMagnitude;

                if (distSq < minDistSq)
                {
                    minDistSq = distSq;
                    nearestOnCorridor = new Vector3(projectedFlat.x, 0f, projectedFlat.z);
                    corridorTangent = (b - a).normalized;
                }
            }

            // Calculate perpendicular (right) vector
            var right = Vector3.Cross(Vector3.up, corridorTangent).normalized;

            // Calculate lateral distance from corridor center
            var toPoint = new Vector3(point.x - nearestOnCorridor.x, 0f, point.z - nearestOnCorridor.z);
            float lateralDist = Vector3.Dot(toPoint, right);

            // Mirror: reflect across the centerline (negate lateral offset)
            var mirrored = new Vector3(
                nearestOnCorridor.x - right.x * lateralDist,
                point.y,  // Keep Y unchanged
                nearestOnCorridor.z - right.z * lateralDist
            );

            return mirrored;
        }

        private List<Vector3> RefinePointsForAvoidance(List<Vector3> points, int maxDepth = 4)
        {
            if (maxDepth <= 0 || points.Count < 2)
                return points;

            var refined = new List<Vector3> { points[0] };
            bool needsRefinement = false;

            for (int i = 0; i < points.Count - 1; i++)
            {
                var a = points[i];
                var b = points[i + 1];
                var mid = (a + b) * 0.5f;

                // Check if midpoint needs avoidance correction
                var corrected = ApplyAvoidance(mid);
                corrected = ClampToCorridorBounds(corrected);
                float delta = Vector3.Distance(mid, corrected);

                // Also check for building intersection along segment
                bool segmentIntersects = CheckSegmentIntersectsBuildings(a, b);

                if (delta > 0.1f || segmentIntersects)
                {
                    // Insert corrected midpoint
                    refined.Add(corrected);
                    needsRefinement = true;
                }

                refined.Add(b);
            }

            // Recurse if we made changes
            if (needsRefinement)
                return RefinePointsForAvoidance(refined, maxDepth - 1);

            return refined;
        }

        private bool CheckSegmentIntersectsBuildings(Vector3 a, Vector3 b)
        {
            if (_buildingCache == null || _buildingCache.Count == 0)
                return false;

            // Check midpoint and endpoints against buildings
            var mid = (a + b) * 0.5f;
            foreach (var building in _buildingCache)
            {
                if (CalculateDistanceToBuildingSurface(a, building) < _buildingPadding * 0.5f)
                    return true;
                if (CalculateDistanceToBuildingSurface(b, building) < _buildingPadding * 0.5f)
                    return true;
                if (CalculateDistanceToBuildingSurface(mid, building) < _buildingPadding * 0.5f)
                    return true;
            }
            return false;
        }

        private float GetBuildingHalfExtent(BuildingData building, Vector3 direction)
        {
            var localDir = Quaternion.Inverse(building.Rotation) * direction;
            float halfWidth = building.Scale.x * 0.5f;
            float halfDepth = building.Scale.z * 0.5f;
            return Mathf.Abs(localDir.x) * halfWidth + Mathf.Abs(localDir.z) * halfDepth;
        }

        private SplineContainer CreateSpline(List<Vector3> points, string name)
        {
            var go = new GameObject(name);
            go.transform.SetParent(_splineParent);
            go.transform.localPosition = Vector3.zero;
            go.transform.localRotation = Quaternion.identity;
            go.transform.localScale = Vector3.one;

            var container = go.AddComponent<SplineContainer>();

            // Remove default spline
            if (container.Splines.Count > 0)
                container.RemoveSplineAt(0);

            var spline = container.AddSpline();

            // Convert to float3 list
            var positions = points.Select(p => (float3)p).ToList();

            // Optional smoothing
            if (_enableSmoothing && positions.Count > 2)
            {
                var smoothed = new List<float3>();
                SplineUtility.ReducePoints(positions, smoothed, _smoothingTolerance);
                if (smoothed.Count >= 2)
                    positions = smoothed;
            }

            // Add knots
            foreach (var pos in positions)
            {
                spline.Add(new BezierKnot(pos), TangentMode.AutoSmooth);
            }

            return container;
        }

        private void CacheSplineSamples()
        {
            _cachedSplineSamples.Clear();
            _totalSplineLength = 0f;

            // If _generatedVines is empty (e.g., after domain reload), rebuild from _splineParent children
            IEnumerable<GameObject> vinesToProcess = _generatedVines;
            if (_generatedVines.Count == 0 && _splineParent != null)
            {
                var childVines = new List<GameObject>();
                for (int i = 0; i < _splineParent.childCount; i++)
                {
                    var child = _splineParent.GetChild(i).gameObject;
                    if (child.GetComponent<SplineContainer>() != null)
                        childVines.Add(child);
                }
                vinesToProcess = childVines;
            }

            foreach (var vineGO in vinesToProcess)
            {
                var container = vineGO.GetComponent<SplineContainer>();
                if (container == null) continue;

                var spline = container.Spline;
                float length = spline.GetLength();

                for (float dist = 0; dist < length; dist += _graffitiSampleSpacing)
                {
                    float t = dist / length;
                    _cachedSplineSamples.Add(new SplineSample
                    {
                        Position = (Vector3)spline.EvaluatePosition(t),
                        Tangent = ((Vector3)spline.EvaluateTangent(t)).normalized,
                        CumulativeDistance = _totalSplineLength + dist
                    });
                }

                _totalSplineLength += length;
            }
        }

        public void EnsureSplineCacheValid()
        {
            if (_cachedSplineSamples.Count == 0)
                CacheSplineSamples();
        }

        public List<GraffitiCandidate> GetGraffitiCandidatePositions(
            IReadOnlyList<BuildingData> buildings,
            float maxWallDistance = 15f)
        {
            var candidates = new List<GraffitiCandidate>();

            foreach (var sample in _cachedSplineSamples)
            {
                // Skip positions near exclusion waypoints
                if (IsNearExclusionWaypoint(sample.Position))
                    continue;

                float nearestWallDist = FindDistanceToNearestWall(sample.Position, buildings);

                if (nearestWallDist <= maxWallDistance)
                {
                    candidates.Add(new GraffitiCandidate
                    {
                        Position = sample.Position,
                        SplineTangent = sample.Tangent,
                        DistanceToWall = nearestWallDist,
                        SplineDistance = sample.CumulativeDistance
                    });
                }
            }

            // Don't sort globally - CityManager handles segment-based selection
            return candidates;
        }

        private float FindDistanceToNearestWall(Vector3 point, IReadOnlyList<BuildingData> buildings)
        {
            float nearest = float.MaxValue;

            foreach (var building in buildings)
            {
                float dist = CalculateDistanceToBuildingSurface(point, building);
                if (dist < nearest)
                    nearest = dist;
            }

            return nearest;
        }

        private float CalculateDistanceToBuildingSurface(Vector3 point, BuildingData building)
        {
            float halfWidth = building.Scale.x * 0.5f;
            float halfDepth = building.Scale.z * 0.5f;

            var toPoint = point - building.Position;
            toPoint.y = 0;

            var buildingForward = building.Rotation * Vector3.forward;
            var buildingRight = building.Rotation * Vector3.right;

            float dotForward = Vector3.Dot(toPoint, buildingForward);
            float dotRight = Vector3.Dot(toPoint, buildingRight);

            float distForward = Mathf.Abs(dotForward) - halfDepth;
            float distRight = Mathf.Abs(dotRight) - halfWidth;

            if (distForward <= 0 && distRight <= 0)
            {
                return Mathf.Max(distForward, distRight);
            }
            else if (distForward <= 0)
            {
                return distRight;
            }
            else if (distRight <= 0)
            {
                return distForward;
            }
            else
            {
                return Mathf.Sqrt(distForward * distForward + distRight * distRight);
            }
        }

        public float GetDistanceToNearestSpline(Vector3 point)
        {
            float nearestDistSq = float.MaxValue;

            foreach (var sample in _cachedSplineSamples)
            {
                float distSq = (point - sample.Position).sqrMagnitude;
                if (distSq < nearestDistSq)
                    nearestDistSq = distSq;
            }

            return nearestDistSq < float.MaxValue ? Mathf.Sqrt(nearestDistSq) : float.MaxValue;
        }
    }
}
