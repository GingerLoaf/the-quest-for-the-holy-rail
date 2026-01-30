using System;
using StarterAssets;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;
using Random = UnityEngine.Random;

namespace HolyRail.Scripts.LevelGeneration
{
    public class HexSection : MonoBehaviour
    {
        public event Action<HexSection> PlayerEnteredFirstTime;

        [Header("Hex Geometry")]
        [field: SerializeField] public float Circumradius { get; set; } = HexConstants.DefaultCircumradius;
        [field: SerializeField] public int EntryEdge { get; set; } = 3;
        [field: SerializeField] public int ExitEdge { get; set; } = 0;

        [Header("Connection Points")]
        [field: SerializeField] public HexEdgePoint[] EntryPoints { get; set; }
        [field: SerializeField] public HexEdgePoint[] ExitPoints { get; set; }

        [Header("Content")]
        [field: SerializeField] public bool HasShop { get; set; }

        [Header("Generation Metadata")]
        [field: SerializeField] public int Seed { get; set; }
        [field: SerializeField] public string ConfigName { get; set; }

        [Header("Pickup Spawning")]
        [field: SerializeField] public GameObject PickUpPrefab { get; set; }
        [field: SerializeField] public int PickUpCount { get; set; } = 5;
        [field: SerializeField] public float MinPickUpSpacing { get; set; } = 0.1f;
        [field: SerializeField] public float PickUpHeightOffset { get; set; } = 1f;

        public bool PlayerIsInside { get; private set; }
        public bool HasBeenVisited { get; private set; }
        public int SectionIndex { get; set; }

        public SplineMeshController[] SplineMeshControllers;

        private Transform _playerTransform;

        public void InitializeSplineMeshControllers()
        {
            if (SplineMeshControllers == null || SplineMeshControllers.Length == 0)
                SplineMeshControllers = GetComponentsInChildren<SplineMeshController>();

            if (SplineMeshControllers == null)
                return;

            foreach (var controller in SplineMeshControllers)
            {
                if (controller != null)
                    controller.glowLocation = 0f;
            }
        }

        private void Awake()
        {
            if (ThirdPersonController_RailGrinder.Instance != null)
                _playerTransform = ThirdPersonController_RailGrinder.Instance.transform;

            SpawnPickUps();
        }

        private void Update()
        {
            if (_playerTransform == null)
                return;

            var localPos = transform.InverseTransformPoint(_playerTransform.position);
            bool wasInside = PlayerIsInside;
            PlayerIsInside = HexConstants.IsPointInsideHex(localPos, Circumradius);

            if (PlayerIsInside && !wasInside && !HasBeenVisited)
            {
                HasBeenVisited = true;
                PlayerEnteredFirstTime?.Invoke(this);
            }
        }

        public Vector3? GetEntryAveragePosition()
        {
            return GetAveragePosition(EntryPoints);
        }

        public Vector3? GetExitAveragePosition()
        {
            return GetAveragePosition(ExitPoints);
        }

        private Vector3? GetAveragePosition(HexEdgePoint[] points)
        {
            if (points == null || points.Length == 0)
                return null;

            var sum = Vector3.zero;
            int count = 0;

            foreach (var point in points)
            {
                if (point == null)
                    continue;

                sum += point.transform.position;
                count++;
            }

            return count > 0 ? sum / count : null;
        }

        private void SpawnPickUps()
        {
            if (PickUpPrefab == null || PickUpCount <= 0)
                return;

            var splineContainers = GetComponentsInChildren<SplineContainer>();
            if (splineContainers.Length == 0)
                return;

            for (int i = 0; i < PickUpCount; i++)
            {
                var randomSpline = splineContainers[Random.Range(0, splineContainers.Length)];
                if (randomSpline == null || randomSpline.Spline == null)
                    continue;

                float randomT = Random.Range(MinPickUpSpacing, 1f - MinPickUpSpacing);
                randomSpline.Evaluate(randomT, out float3 position, out float3 tangent, out float3 normal);

                var rotation = math.lengthsq(tangent) < float.Epsilon || math.lengthsq(normal) < float.Epsilon
                    ? Quaternion.identity
                    : Quaternion.LookRotation(tangent, normal);

                var spawnPos = new Vector3(position.x, position.y + PickUpHeightOffset, position.z);
                Instantiate(PickUpPrefab, spawnPos, rotation, transform);
            }
        }

        private void OnDrawGizmos()
        {
            DrawHexOutline(Color.white, 0.3f);
            DrawEdgeHighlight(EntryEdge, Color.green);
            DrawEdgeHighlight(ExitEdge, Color.red);
        }

        private void OnDrawGizmosSelected()
        {
            DrawHexOutline(Color.yellow, 1f);
            DrawEdgeHighlight(EntryEdge, Color.green);
            DrawEdgeHighlight(ExitEdge, Color.red);

            // Draw entry/exit direction arrows
            var entryMid = transform.TransformPoint(HexConstants.GetEdgeMidpoint(EntryEdge, Circumradius));
            var exitMid = transform.TransformPoint(HexConstants.GetEdgeMidpoint(ExitEdge, Circumradius));
            var entryNormal = transform.TransformDirection(HexConstants.GetEdgeNormal(EntryEdge, Circumradius));
            var exitNormal = transform.TransformDirection(HexConstants.GetEdgeNormal(ExitEdge, Circumradius));

            Gizmos.color = Color.green;
            Gizmos.DrawRay(entryMid, -entryNormal * 5f);
            Gizmos.color = Color.red;
            Gizmos.DrawRay(exitMid, exitNormal * 5f);
        }

        private void DrawHexOutline(Color color, float alpha)
        {
            Gizmos.color = new Color(color.r, color.g, color.b, alpha);
            var vertices = HexConstants.GetAllVertices(Circumradius);

            for (int i = 0; i < HexConstants.EdgeCount; i++)
            {
                var v0 = transform.TransformPoint(vertices[i]);
                var v1 = transform.TransformPoint(vertices[(i + 1) % HexConstants.EdgeCount]);
                Gizmos.DrawLine(v0, v1);
            }
        }

        private void DrawEdgeHighlight(int edgeIndex, Color color)
        {
            if (edgeIndex < 0 || edgeIndex >= HexConstants.EdgeCount)
                return;

            Gizmos.color = color;
            var v0 = transform.TransformPoint(HexConstants.GetVertex(edgeIndex, Circumradius));
            var v1 = transform.TransformPoint(HexConstants.GetVertex((edgeIndex + 1) % HexConstants.EdgeCount, Circumradius));
            Gizmos.DrawLine(v0, v1);

            // Draw thicker by offsetting slightly
            var offset = Vector3.up * 0.1f;
            Gizmos.DrawLine(v0 + offset, v1 + offset);
        }
    }
}
