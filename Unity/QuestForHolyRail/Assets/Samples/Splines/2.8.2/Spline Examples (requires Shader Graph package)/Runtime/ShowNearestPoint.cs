using System;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;

namespace Unity.Splines.Examples
{
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

        private SplineContainer[] _splineContainers;
        private LineRenderer _lineRenderer;
        private float _previousSplineParameter = -1f;
        private SplineContainer _previousContainer = null;
        private bool _hasValidPreviousState = false;
        
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
                if (container == null || container.Spline == null)
                    continue;

                using var native = new NativeSpline(container.Spline, container.transform.localToWorldMatrix);
                float distance = SplineUtility.GetNearestPoint(native, worldPosition, out float3 point, out float t);

                if (distance < nearestDistance)
                {
                    nearestDistance = distance;
                    nearestPosition = point;
                    nearestT = t;
                    nearestContainer = container;
                }
            }

            return new NearestPointResult(nearestPosition, nearestDistance, nearestT, nearestContainer);
        }

        /// <summary>
        /// Gets the nearest point on splines with travel direction based on previous position.
        /// This method tracks the change in spline parameter over time to determine direction.
        /// </summary>
        /// <param name="worldPosition">The world position to query from</param>
        /// <param name="previousT">The previous spline parameter value</param>
        /// <param name="previousContainer">The previous spline container</param>
        /// <param name="directionThreshold">Minimum change in parameter to detect direction (prevents noise)</param>
        /// <param name="splineContainers">Optional array of spline containers to search</param>
        /// <returns>Result containing position, distance, parameter, container, and travel direction</returns>
        public static NearestPointResult GetNearestPointWithDirection(
            float3 worldPosition,
            float previousT,
            SplineContainer previousContainer,
            float directionThreshold = 0.001f,
            SplineContainer[] splineContainers = null)
        {
            var result = GetNearestPointOnSplines(worldPosition, splineContainers);

            // Determine travel direction
            var direction = SplineTravelDirection.Unknown;

            // Only calculate direction if we're on the same spline container as before
            if (previousContainer != null && result.Container == previousContainer && previousT >= 0)
            {
                float tDelta = result.SplineParameter - previousT;

                // Handle wrapping for closed splines
                if (result.Container.Spline.Closed)
                {
                    // Check if we wrapped around
                    if (math.abs(tDelta) > 0.5f)
                    {
                        // We likely wrapped, adjust the delta
                        if (tDelta > 0)
                            tDelta -= 1f;
                        else
                            tDelta += 1f;
                    }
                }

                if (math.abs(tDelta) < directionThreshold)
                {
                    direction = SplineTravelDirection.Stationary;
                }
                else if (tDelta > 0)
                {
                    direction = SplineTravelDirection.StartToEnd;
                }
                else
                {
                    direction = SplineTravelDirection.EndToStart;
                }
            }

            return new NearestPointResult(result.Position, result.Distance, result.SplineParameter, result.Container, direction);
        }

        private void Start()
        {
            if (!TryGetComponent(out _lineRenderer))
                Debug.LogError("ShowNearestPoint requires a LineRenderer.");
            _lineRenderer.positionCount = 2;
            _splineContainers = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);
            if (NearestPoint == null)
                Debug.LogError("Nearest Point GameObject is null");
        }

        private void Update()
        {
            NearestPointResult result;

            if (_hasValidPreviousState)
            {
                result = GetNearestPointWithDirection(
                    transform.position,
                    _previousSplineParameter,
                    _previousContainer,
                    _directionThreshold,
                    _splineContainers);
            }
            else
            {
                result = GetNearestPointOnSplines(transform.position, _splineContainers);
                _hasValidPreviousState = true;
            }

            _lineRenderer.SetPosition(0, transform.position);
            _lineRenderer.SetPosition(1, result.Position);
            NearestPoint.position = result.Position;

            // Store current state for next frame
            _previousSplineParameter = result.SplineParameter;
            _previousContainer = result.Container;
        }
    }
}