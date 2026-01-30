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

        // --- Hex Grid Coordinate Helpers ---

        // Axial neighbor offsets indexed by edge (matches GetEdgeMidpoint/GetEdgeNormal ordering)
        // Edge 0: NE(1,0), Edge 1: N(0,1), Edge 2: NW(-1,1),
        // Edge 3: SW(-1,0), Edge 4: S(0,-1), Edge 5: SE(1,-1)
        public static readonly Vector2Int[] AxialNeighborOffsets =
        {
            new(1, 0), new(0, 1), new(-1, 1),
            new(-1, 0), new(0, -1), new(1, -1)
        };

        public static Vector3 AxialToWorld(Vector2Int axial, float circumradius)
        {
            float x = circumradius * 1.5f * axial.x;
            float z = circumradius * Mathf.Sqrt(3f) * (axial.y + axial.x * 0.5f);
            return new Vector3(x, 0f, z);
        }

        public static Vector2Int WorldToAxial(Vector3 worldPos, float circumradius)
        {
            // Convert to fractional axial coordinates
            float q = worldPos.x * 2f / (3f * circumradius);
            float r = (-worldPos.x / 3f + worldPos.z * Mathf.Sqrt(3f) / 3f) / circumradius;

            // Round using cube coordinate algorithm
            float s = -q - r;
            int rq = Mathf.RoundToInt(q);
            int rr = Mathf.RoundToInt(r);
            int rs = Mathf.RoundToInt(s);

            float dq = Mathf.Abs(rq - q);
            float dr = Mathf.Abs(rr - r);
            float ds = Mathf.Abs(rs - s);

            if (dq > dr && dq > ds)
                rq = -rr - rs;
            else if (dr > ds)
                rr = -rq - rs;

            return new Vector2Int(rq, rr);
        }

        public static int GetEdgeFromDirection(Vector2Int from, Vector2Int to)
        {
            var delta = to - from;
            for (int i = 0; i < AxialNeighborOffsets.Length; i++)
            {
                if (AxialNeighborOffsets[i] == delta)
                    return i;
            }
            return -1;
        }

        public static int GetBestEdgeForWorldDirection(Vector3 direction)
        {
            float bestDot = float.MinValue;
            int bestEdge = 0;
            for (int i = 0; i < EdgeCount; i++)
            {
                var normal = GetEdgeNormal(i, 1f);
                float dot = normal.x * direction.x + normal.z * direction.z;
                if (dot > bestDot)
                {
                    bestDot = dot;
                    bestEdge = i;
                }
            }
            return bestEdge;
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
