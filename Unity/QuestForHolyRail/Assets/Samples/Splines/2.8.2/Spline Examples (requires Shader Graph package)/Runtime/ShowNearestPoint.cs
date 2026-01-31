using System;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;

namespace Unity.Splines.Examples
{
    /// <summary>
    /// Simple spatial grid for fast radius queries on SplineContainers.
    /// </summary>
    internal class SplineContainerSpatialGrid
    {
        private readonly Dictionary<Vector2Int, List<int>> _cells = new();
        private readonly float _cellSize;
        private SplineContainer[] _items;

        public int CellCount => _cells.Count;

        public SplineContainerSpatialGrid(float cellSize)
        {
            _cellSize = cellSize;
        }

        public void Initialize(SplineContainer[] items)
        {
            _cells.Clear();
            _items = items;

            for (int i = 0; i < items.Length; i++)
            {
                if (items[i] == null)
                    continue;

                var cellKey = GetCellKey(items[i].transform.position);

                if (!_cells.TryGetValue(cellKey, out var list))
                {
                    list = new List<int>();
                    _cells[cellKey] = list;
                }

                list.Add(i);
            }
        }

        public void GetItemsInRadius(Vector3 center, float radius, List<int> results)
        {
            results.Clear();

            if (_items == null)
                return;

            var minCell = GetCellKey(center - new Vector3(radius, 0, radius));
            var maxCell = GetCellKey(center + new Vector3(radius, 0, radius));
            var radiusSq = radius * radius;

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int z = minCell.y; z <= maxCell.y; z++)
                {
                    var cellKey = new Vector2Int(x, z);

                    if (_cells.TryGetValue(cellKey, out var itemIndices))
                    {
                        foreach (var index in itemIndices)
                        {
                            var itemPos = _items[index].transform.position;
                            var dx = itemPos.x - center.x;
                            var dz = itemPos.z - center.z;
                            var distSq = dx * dx + dz * dz;

                            if (distSq <= radiusSq)
                            {
                                results.Add(index);
                            }
                        }
                    }
                }
            }
        }

        private Vector2Int GetCellKey(Vector3 worldPosition)
        {
            int x = Mathf.FloorToInt(worldPosition.x / _cellSize);
            int z = Mathf.FloorToInt(worldPosition.z / _cellSize);
            return new Vector2Int(x, z);
        }
    }

    /// <summary>
    /// Direction of travel along a spline.
    /// </summary>
    public enum SplineTravelDirection
    {
        Unknown,
        StartToEnd,
        EndToStart,
        Stationary
    }

    /// <summary>
    /// Result data for nearest point queries on splines.
    /// </summary>
    public struct NearestPointResult
    {
        public float3 Position;
        public float Distance;
        public float SplineParameter;
        public SplineContainer Container;
        public SplineTravelDirection TravelDirection;

        public NearestPointResult(float3 position, float distance, float splineParameter, SplineContainer container, SplineTravelDirection travelDirection = SplineTravelDirection.Unknown)
        {
            Position = position;
            Distance = distance;
            SplineParameter = splineParameter;
            Container = container;
            TravelDirection = travelDirection;
        }
    }

    // Visualize the nearest point on a spline to a roving sphere.
    [RequireComponent(typeof(LineRenderer))]
    public class ShowNearestPoint : MonoBehaviour
    {
        [field: SerializeField] public Transform NearestPoint { get; private set; }
        [SerializeField, Tooltip("Minimum change in spline parameter to detect direction (prevents noise)")]
        private float _directionThreshold = 0.001f;
        [SerializeField, Tooltip("Search radius for finding nearby splines (smaller = faster, but may miss distant splines)")]
        private float _searchRadius = 50f;
        [SerializeField, Tooltip("Cell size for spatial grid (smaller = more cells, larger = more items per cell)")]
        private float _gridCellSize = 30f;

        private SplineContainer[] _splineContainers;
        private SplineContainerSpatialGrid _splineGrid;
        private List<int> _nearbyIndices = new List<int>();
        private SplineContainer[] _nearbyContainersBuffer = new SplineContainer[64];
        private LineRenderer _lineRenderer;
        private float _previousSplineParameter = -1f;
        private SplineContainer _previousContainer = null;
        private bool _hasValidPreviousState = false;
        private float3 _previousWorldPosition;
        
        /// <summary>
        /// Finds the nearest point on any spline in the scene to the given world position.
        /// This function can be called from anywhere in the codebase.
        /// </summary>
        /// <param name="worldPosition">The world position to query from</param>
        /// <param name="splineContainers">Optional array of spline containers to search. If null, searches all splines in the scene.</param>
        /// <returns>Result containing the nearest point position, distance, spline parameter, and container reference</returns>
        public static NearestPointResult GetNearestPointOnSplines(float3 worldPosition, SplineContainer[] splineContainers = null)
        {
            if (splineContainers == null || splineContainers.Length == 0)
            {
                splineContainers = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);
            }

            var nearestPosition = float3.zero;
            var nearestDistance = float.PositiveInfinity;
            var nearestT = 0f;
            SplineContainer nearestContainer = null;

            foreach (var container in splineContainers)
            {
                if (container == null)
                    continue;

                // Check Splines collection directly instead of Spline property
                var splines = container.Splines;
                if (splines == null || splines.Count == 0)
                    continue;

                foreach (var spline in splines)
                {
                    if (spline == null || spline.Count < 2)
                        continue;

                    using var native = new NativeSpline(spline, container.transform.localToWorldMatrix);
                    float distance = SplineUtility.GetNearestPoint(native, worldPosition, out float3 point, out float t);

                    if (distance < nearestDistance)
                    {
                        nearestDistance = distance;
                        nearestPosition = point;
                        nearestT = t;
                        nearestContainer = container;
                    }
                }
            }

            return new NearestPointResult(nearestPosition, nearestDistance, nearestT, nearestContainer);
        }

        /// <summary>
        /// Gets the nearest point on splines with travel direction based on a facing direction.
        /// Use this when starting a grind to determine direction based on which way the player is facing.
        /// </summary>
        /// <param name="worldPosition">The world position to query from</param>
        /// <param name="facingDirection">The direction the player is facing (e.g., transform.forward)</param>
        /// <param name="splineContainers">Optional array of spline containers to search</param>
        /// <returns>Result containing position, distance, parameter, container, and travel direction</returns>
        public static NearestPointResult GetNearestPointWithFacingDirection(
            float3 worldPosition,
            float3 facingDirection,
            SplineContainer[] splineContainers = null)
        {
            var result = GetNearestPointOnSplines(worldPosition, splineContainers);

            if (result.Container == null)
                return result;

            // Get the first valid spline from the container
            Spline spline = null;
            foreach (var s in result.Container.Splines)
            {
                if (s != null && s.Count >= 2)
                {
                    spline = s;
                    break;
                }
            }
            if (spline == null)
                return result;

            // Get tangent at nearest point
            using var native = new NativeSpline(spline, result.Container.transform.localToWorldMatrix);
            float3 tangent = math.normalize(native.EvaluateTangent(result.SplineParameter));

            // Flatten both vectors to horizontal plane for more intuitive direction matching
            float3 flatFacing = math.normalize(new float3(facingDirection.x, 0, facingDirection.z));
            float3 flatTangent = math.normalize(new float3(tangent.x, 0, tangent.z));

            // Dot product tells us if facing aligns with tangent direction
            float dotProduct = math.dot(flatFacing, flatTangent);

            var direction = dotProduct >= 0
                ? SplineTravelDirection.StartToEnd
                : SplineTravelDirection.EndToStart;

            return new NearestPointResult(result.Position, result.Distance, result.SplineParameter, result.Container, direction);
        }

        /// <summary>
        /// Gets the nearest point on splines with travel direction based on previous position.
        /// This method tracks the change in spline parameter and world position to determine direction.
        /// </summary>
        /// <param name="worldPosition">The world position to query from</param>
        /// <param name="previousT">The previous spline parameter value</param>
        /// <param name="previousContainer">The previous spline container</param>
        /// <param name="previousWorldPosition">The previous world position</param>
        /// <param name="directionThreshold">Minimum change in parameter to detect direction (prevents noise)</param>
        /// <param name="splineContainers">Optional array of spline containers to search</param>
        /// <returns>Result containing position, distance, parameter, container, and travel direction</returns>
        public static NearestPointResult GetNearestPointWithDirection(
            float3 worldPosition,
            float previousT,
            SplineContainer previousContainer,
            float3 previousWorldPosition,
            float directionThreshold = 0.001f,
            SplineContainer[] splineContainers = null)
        {
            var result = GetNearestPointOnSplines(worldPosition, splineContainers);

            // Determine travel direction
            var direction = SplineTravelDirection.Unknown;

            // Only calculate direction if we're on the same spline container as before
            if (previousContainer != null && result.Container == previousContainer && previousT >= 0)
            {
                // Calculate movement vector in world space
                float3 movementVector = worldPosition - previousWorldPosition;
                float movementDistance = math.length(movementVector);

                // If barely moved, mark as stationary
                if (movementDistance < directionThreshold)
                {
                    direction = SplineTravelDirection.Stationary;
                }
                else
                {
                    // Get the first valid spline from the container
                    Spline splineForTangent = null;
                    foreach (var s in result.Container.Splines)
                    {
                        if (s != null && s.Count >= 2)
                        {
                            splineForTangent = s;
                            break;
                        }
                    }
                    if (splineForTangent == null)
                        return result;

                    // Get tangent at current position to determine direction along spline
                    using var native = new NativeSpline(splineForTangent, result.Container.transform.localToWorldMatrix);
                    float3 tangent = native.EvaluateTangent(result.SplineParameter);
                    tangent = math.normalize(tangent);

                    // Dot product tells us if movement aligns with tangent direction
                    float dotProduct = math.dot(math.normalize(movementVector), tangent);

                    if (dotProduct > 0.1f) // Threshold to avoid noise
                    {
                        direction = SplineTravelDirection.StartToEnd;
                    }
                    else if (dotProduct < -0.1f)
                    {
                        direction = SplineTravelDirection.EndToStart;
                    }
                    else
                    {
                        // Fallback to parameter delta if movement is perpendicular
                        float tDelta = result.SplineParameter - previousT;

                        if (splineForTangent.Closed && math.abs(tDelta) > 0.5f)
                        {
                            tDelta = tDelta > 0 ? tDelta - 1f : tDelta + 1f;
                        }

                        direction = tDelta > 0 ? SplineTravelDirection.StartToEnd : SplineTravelDirection.EndToStart;
                    }
                }
            }

            return new NearestPointResult(result.Position, result.Distance, result.SplineParameter, result.Container, direction);
        }

        private void Start()
        {
            if (!TryGetComponent(out _lineRenderer))
                Debug.LogError("ShowNearestPoint requires a LineRenderer.");
            _lineRenderer.positionCount = 2;
            RefreshSplineContainers();
            if (NearestPoint == null)
                Debug.LogError("Nearest Point GameObject is null");
        }

        public void RefreshSplineContainers()
        {
            _splineContainers = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);

            // Build spatial grid for fast radius queries
            _splineGrid = new SplineContainerSpatialGrid(_gridCellSize);
            _splineGrid.Initialize(_splineContainers);

            Debug.Log($"ShowNearestPoint: Refreshed spline cache, found {_splineContainers.Length} containers, grid has {_splineGrid.CellCount} cells");
        }

        private void Update()
        {
            // DISABLED: This debug visualization was causing 35ms/frame overhead
            // The player controller has its own grind detection - this is not needed for gameplay
            return;

            // Get only nearby containers using spatial grid
            _nearbyIndices.Clear();
            _splineGrid?.GetItemsInRadius(transform.position, _searchRadius, _nearbyIndices);

            // Build filtered array (resize buffer if needed)
            int nearbyCount = _nearbyIndices.Count;
            if (_nearbyContainersBuffer.Length < nearbyCount)
            {
                _nearbyContainersBuffer = new SplineContainer[nearbyCount * 2];
            }
            for (int i = 0; i < nearbyCount; i++)
            {
                _nearbyContainersBuffer[i] = _splineContainers[_nearbyIndices[i]];
            }

            // Create array segment for the query methods
            var nearbyContainers = new SplineContainer[nearbyCount];
            Array.Copy(_nearbyContainersBuffer, nearbyContainers, nearbyCount);

            NearestPointResult result;

            if (_hasValidPreviousState)
            {
                result = GetNearestPointWithDirection(
                    transform.position,
                    _previousSplineParameter,
                    _previousContainer,
                    _previousWorldPosition,
                    _directionThreshold,
                    nearbyContainers);
            }
            else
            {
                result = GetNearestPointOnSplines(transform.position, nearbyContainers);
                _hasValidPreviousState = true;
            }

            _lineRenderer.SetPosition(0, transform.position);
            _lineRenderer.SetPosition(1, result.Position);
            NearestPoint.position = result.Position;

            // Store current state for next frame
            _previousSplineParameter = result.SplineParameter;
            _previousContainer = result.Container;
            _previousWorldPosition = transform.position;
        }
    }
}