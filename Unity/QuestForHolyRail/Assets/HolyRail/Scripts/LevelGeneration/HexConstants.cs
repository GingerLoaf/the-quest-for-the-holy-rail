using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public static class HexConstants
    {
        public const float DefaultCircumradius = 40f;
        public const int EdgeCount = 6;
        public const float DegreesPerEdge = 360f / EdgeCount;

        // Shop spawn probability
        public const float DefaultShopChance = 0.02f;

        // Gameplay constants derived from ThirdPersonController_RailGrinder
        public const float GrindDetectionThreshold = 2f;
        public const float GrindTriggerOffset = -0.5f;
        public const float GrindSpeed = 8f;
        public const float GrindSpeedBoosted = 12f;
        public const float WallRideDetectionRadius = 1.5f;
        public const float WallRideSpeed = 10f;
        public const float JumpHeight = 1.2f;
        public const float Gravity = -15f;
        public const int BillboardLayer = 7;

        // Rail placement constraints
        public const float RailMinClearance = 0.5f;
        public const float WallRailMaxDistance = 5f;
        public const float DefaultMinRailSpacing = 4f;

        // Boundary wall defaults
        public const float DefaultBoundaryWallHeight = 8f;
        public const float DefaultBoundaryWallThickness = 1f;

        public static bool AreEdgesAdjacent(int edgeA, int edgeB)
        {
            int diff = Mathf.Abs(edgeA - edgeB);
            return diff == 1 || diff == EdgeCount - 1;
        }

        public static Vector3 GetVertex(int index, float circumradius)
        {
            float angleDeg = DegreesPerEdge * index;
            float angleRad = angleDeg * Mathf.Deg2Rad;
            return new Vector3(
                circumradius * Mathf.Cos(angleRad),
                0f,
                circumradius * Mathf.Sin(angleRad)
            );
        }

        public static Vector3 GetEdgeMidpoint(int edgeIndex, float circumradius)
        {
            var v0 = GetVertex(edgeIndex, circumradius);
            var v1 = GetVertex((edgeIndex + 1) % EdgeCount, circumradius);
            return (v0 + v1) * 0.5f;
        }

        public static Vector3 GetEdgeNormal(int edgeIndex, float circumradius)
        {
            var mid = GetEdgeMidpoint(edgeIndex, circumradius);
            return mid.normalized;
        }

        public static int GetOppositeEdge(int edgeIndex)
        {
            return (edgeIndex + 3) % EdgeCount;
        }

        public static Vector3[] GetAllVertices(float circumradius)
        {
            var vertices = new Vector3[EdgeCount];
            for (int i = 0; i < EdgeCount; i++)
                vertices[i] = GetVertex(i, circumradius);
            return vertices;
        }

        public static bool IsPointInsideHex(Vector3 point, float circumradius)
        {
            // Flatten to XZ plane
            var p = new Vector2(point.x, point.z);

            for (int i = 0; i < EdgeCount; i++)
            {
                var v0 = GetVertex(i, circumradius);
                var v1 = GetVertex((i + 1) % EdgeCount, circumradius);

                var a = new Vector2(v0.x, v0.z);
                var b = new Vector2(v1.x, v1.z);

                // Cross product: if negative, point is outside this edge
                var edge = b - a;
                var toPoint = p - a;
                float cross = edge.x * toPoint.y - edge.y * toPoint.x;

                if (cross < 0f)
                    return false;
            }

            return true;
        }

        public static Vector3 ClampToHex(Vector3 point, float circumradius, float margin = 1f)
        {
            float effectiveRadius = circumradius - margin;
            if (effectiveRadius <= 0f)
                return Vector3.zero;

            if (IsPointInsideHex(new Vector3(point.x, 0f, point.z), effectiveRadius))
                return point;

            // Project onto nearest edge
            float bestDist = float.MaxValue;
            var bestPoint = point;

            for (int i = 0; i < EdgeCount; i++)
            {
                var v0 = GetVertex(i, effectiveRadius);
                var v1 = GetVertex((i + 1) % EdgeCount, effectiveRadius);

                var closest = ClosestPointOnSegment(
                    new Vector2(point.x, point.z),
                    new Vector2(v0.x, v0.z),
                    new Vector2(v1.x, v1.z)
                );

                float dist = Vector2.Distance(new Vector2(point.x, point.z), closest);
                if (dist < bestDist)
                {
                    bestDist = dist;
                    bestPoint = new Vector3(closest.x, point.y, closest.y);
                }
            }

            return bestPoint;
        }

        public static Vector3 GetEdgePointAtFraction(int edgeIndex, float fraction, float circumradius)
        {
            var v0 = GetVertex(edgeIndex, circumradius);
            var v1 = GetVertex((edgeIndex + 1) % EdgeCount, circumradius);
            return Vector3.Lerp(v0, v1, fraction);
        }

        private static Vector2 ClosestPointOnSegment(Vector2 point, Vector2 a, Vector2 b)
        {
            var ab = b - a;
            float t = Vector2.Dot(point - a, ab) / Vector2.Dot(ab, ab);
            t = Mathf.Clamp01(t);
            return a + ab * t;
        }
    }
}
