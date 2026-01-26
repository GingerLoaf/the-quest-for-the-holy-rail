using System;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;

namespace Unity.Splines.Examples
{
    /// <summary>
    /// Result data for nearest point queries on splines.
    /// </summary>
    public struct NearestPointResult
    {
        public float3 Position;
        public float Distance;
        public float SplineParameter;
        public SplineContainer Container;

        public NearestPointResult(float3 position, float distance, float splineParameter, SplineContainer container)
        {
            Position = position;
            Distance = distance;
            SplineParameter = splineParameter;
            Container = container;
        }
    }

    // Visualize the nearest point on a spline to a roving sphere.
    [RequireComponent(typeof(LineRenderer))]
    public class ShowNearestPoint : MonoBehaviour
    {
        [field: SerializeField] public Transform NearestPoint { get; private set; }
        private SplineContainer[] _splineContainers;
        private LineRenderer _lineRenderer;
        
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
            var result = GetNearestPointOnSplines(transform.position, _splineContainers);

            _lineRenderer.SetPosition(0, transform.position);
            _lineRenderer.SetPosition(1, result.Position);
            NearestPoint.position = result.Position;
        }
    }
}