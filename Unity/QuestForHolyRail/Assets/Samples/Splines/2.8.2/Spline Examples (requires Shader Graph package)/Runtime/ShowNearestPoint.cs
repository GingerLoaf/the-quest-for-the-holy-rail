using System;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;

namespace Unity.Splines.Examples
{
    // Visualize the nearest point on a spline to a roving sphere.
    [RequireComponent(typeof(LineRenderer))]
    public class ShowNearestPoint : MonoBehaviour
    {
        [field: SerializeField] public Transform NearestPoint { get; private set; }
        private SplineContainer[] _splineContainers;
        private LineRenderer _lineRenderer;
        
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
            var nearest = new float4(0, 0, 0, float.PositiveInfinity);

            foreach (var container in _splineContainers)
            {
                using var native = new NativeSpline(container.Spline, container.transform.localToWorldMatrix);
                float d = SplineUtility.GetNearestPoint(native, transform.position, out float3 p, out float t);
                if (d < nearest.w)
                    nearest = new float4(p, d);
            }

            _lineRenderer.SetPosition(0, transform.position);
            _lineRenderer.SetPosition(1, nearest.xyz);
            NearestPoint.position = nearest.xyz;
        }
    }
}