using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;
using System.Collections.Generic;

namespace HolyRail.Vines
{
    /// <summary>
    /// Generates tapered tube meshes along splines with customizable end and distance-based tapering.
    /// </summary>
    public static class TaperedVineMesh
    {
        /// <summary>
        /// Settings for mesh tapering.
        /// </summary>
        public struct TaperSettings
        {
            /// <summary>Enable tapering to a point at branch endpoints.</summary>
            public bool EnableEndTaper;

            /// <summary>Distance in meters from the end where tapering begins.</summary>
            public float EndTaperDistance;

            /// <summary>How much branches thin based on distance from root (0=none, 1=full).</summary>
            public float DistanceTaperStrength;

            /// <summary>Normalized distance from root (0=at root, 1=far from root).</summary>
            public float DistanceFromRoot;

            /// <summary>
            /// Creates default settings with no tapering.
            /// </summary>
            public static TaperSettings None => new TaperSettings
            {
                EnableEndTaper = false,
                EndTaperDistance = 0f,
                DistanceTaperStrength = 0f,
                DistanceFromRoot = 0f
            };
        }

        /// <summary>
        /// Generates a tapered tube mesh along a spline.
        /// </summary>
        /// <param name="spline">The spline to extrude along.</param>
        /// <param name="radius">Base radius of the tube.</param>
        /// <param name="sides">Number of sides around the tube circumference.</param>
        /// <param name="segmentsPerUnit">Number of segments per unit length along the spline.</param>
        /// <param name="taperSettings">Tapering configuration.</param>
        /// <param name="capped">Whether to cap the ends.</param>
        /// <returns>The generated mesh.</returns>
        public static Mesh Generate(
            Spline spline,
            float radius,
            int sides,
            int segmentsPerUnit,
            TaperSettings taperSettings,
            bool capped = true)
        {
            var mesh = new Mesh();
            mesh.name = "TaperedVineMesh";

            if (spline == null || spline.Count < 2)
            {
                return mesh;
            }

            float splineLength = spline.GetLength();
            if (splineLength < 0.001f)
            {
                return mesh;
            }

            // Calculate segment count
            int segments = Mathf.Max(2, Mathf.CeilToInt(splineLength * segmentsPerUnit));
            int ringCount = segments + 1;

            // Prepare vertex data
            var vertices = new List<Vector3>();
            var normals = new List<Vector3>();
            var uvs = new List<Vector2>();
            var triangles = new List<int>();

            // Calculate end taper start point (normalized t value)
            float endTaperStartT = 1f;
            if (taperSettings.EnableEndTaper && taperSettings.EndTaperDistance > 0f && splineLength > 0f)
            {
                endTaperStartT = math.max(0f, 1f - (taperSettings.EndTaperDistance / splineLength));
            }

            // Generate rings along the spline
            for (int ring = 0; ring < ringCount; ring++)
            {
                float t = (float)ring / (ringCount - 1);

                // Evaluate spline at t
                SplineUtility.Evaluate(spline, t, out float3 position, out float3 tangent, out float3 up);

                // Handle degenerate tangent
                if (math.lengthsq(tangent) < 0.0001f)
                {
                    tangent = new float3(0, 0, 1);
                }
                tangent = math.normalize(tangent);

                // Calculate right vector
                float3 right = math.normalize(math.cross(up, tangent));
                up = math.normalize(math.cross(tangent, right));

                // Calculate taper multiplier for this ring
                float taperMultiplier = CalculateTaper(t, endTaperStartT, taperSettings);
                float ringRadius = radius * taperMultiplier;

                // Generate vertices around the ring
                for (int side = 0; side <= sides; side++)
                {
                    float angle = (float)side / sides * math.PI * 2f;
                    float cos = math.cos(angle);
                    float sin = math.sin(angle);

                    // Calculate vertex position
                    float3 offset = (right * cos + up * sin) * ringRadius;
                    float3 vertexPos = position + offset;

                    // Calculate normal (pointing outward)
                    float3 normal = math.normalize(right * cos + up * sin);

                    vertices.Add(vertexPos);
                    normals.Add(normal);
                    // UV mapping to match SplineMesh:
                    // U = 1 - (side / sides) — reversed to match SplineMesh direction
                    // V = t * splineLength   — world-space distance for proper tiling
                    float u = 1f - (float)side / sides;
                    float v = t * splineLength;
                    uvs.Add(new Vector2(u, v));
                }
            }

            // Generate triangles
            int vertsPerRing = sides + 1;
            for (int ring = 0; ring < segments; ring++)
            {
                int ringStart = ring * vertsPerRing;
                int nextRingStart = (ring + 1) * vertsPerRing;

                for (int side = 0; side < sides; side++)
                {
                    int current = ringStart + side;
                    int next = ringStart + side + 1;
                    int currentNext = nextRingStart + side;
                    int nextNext = nextRingStart + side + 1;

                    // Two triangles per quad
                    triangles.Add(current);
                    triangles.Add(currentNext);
                    triangles.Add(next);

                    triangles.Add(next);
                    triangles.Add(currentNext);
                    triangles.Add(nextNext);
                }
            }

            // Generate caps if requested
            if (capped)
            {
                // Start cap (if not fully tapered)
                float startTaper = CalculateTaper(0f, endTaperStartT, taperSettings);
                if (startTaper > 0.01f)
                {
                    AddCap(vertices, normals, uvs, triangles, spline, 0f, radius * startTaper, sides, false);
                }

                // End cap (if not fully tapered to a point)
                float endTaper = CalculateTaper(1f, endTaperStartT, taperSettings);
                if (endTaper > 0.01f)
                {
                    AddCap(vertices, normals, uvs, triangles, spline, 1f, radius * endTaper, sides, true);
                }
            }

            mesh.SetVertices(vertices);
            mesh.SetNormals(normals);
            mesh.SetUVs(0, uvs);
            mesh.SetTriangles(triangles, 0);
            mesh.RecalculateBounds();

            return mesh;
        }

        /// <summary>
        /// Calculates the taper multiplier for a given position along the spline.
        /// </summary>
        private static float CalculateTaper(float t, float endTaperStartT, TaperSettings settings)
        {
            float taper = 1f;

            // 1. End tapering - taper to point at end of branch
            if (settings.EnableEndTaper && t >= endTaperStartT && endTaperStartT < 1f)
            {
                float endFraction = (t - endTaperStartT) / (1f - endTaperStartT);
                // Use smooth step for more natural tapering
                endFraction = endFraction * endFraction * (3f - 2f * endFraction);
                taper *= 1f - endFraction;
            }

            // 2. Distance-from-root tapering
            // Branches further from root are thinner
            if (settings.DistanceTaperStrength > 0f)
            {
                taper *= math.lerp(1f, 1f - settings.DistanceTaperStrength, settings.DistanceFromRoot);
            }

            // Clamp to prevent negative or zero radius issues
            return math.max(taper, 0.001f);
        }

        /// <summary>
        /// Adds a cap to close the tube end.
        /// </summary>
        private static void AddCap(
            List<Vector3> vertices,
            List<Vector3> normals,
            List<Vector2> uvs,
            List<int> triangles,
            Spline spline,
            float t,
            float radius,
            int sides,
            bool isEnd)
        {
            SplineUtility.Evaluate(spline, t, out float3 position, out float3 tangent, out float3 up);

            if (math.lengthsq(tangent) < 0.0001f)
            {
                tangent = new float3(0, 0, 1);
            }
            tangent = math.normalize(tangent);

            float3 right = math.normalize(math.cross(up, tangent));
            up = math.normalize(math.cross(tangent, right));

            // Cap normal points along tangent
            float3 capNormal = isEnd ? tangent : -tangent;

            // Add center vertex
            int centerIndex = vertices.Count;
            vertices.Add(position);
            normals.Add(capNormal);
            uvs.Add(new Vector2(0.5f, 0.5f));

            // Add rim vertices
            int rimStart = vertices.Count;
            for (int side = 0; side <= sides; side++)
            {
                float angle = (float)side / sides * math.PI * 2f;
                float cos = math.cos(angle);
                float sin = math.sin(angle);

                float3 offset = (right * cos + up * sin) * radius;
                vertices.Add(position + offset);
                normals.Add(capNormal);
                uvs.Add(new Vector2(cos * 0.5f + 0.5f, sin * 0.5f + 0.5f));
            }

            // Add triangles (fan from center)
            for (int side = 0; side < sides; side++)
            {
                int current = rimStart + side;
                int next = rimStart + side + 1;

                if (isEnd)
                {
                    triangles.Add(centerIndex);
                    triangles.Add(current);
                    triangles.Add(next);
                }
                else
                {
                    triangles.Add(centerIndex);
                    triangles.Add(next);
                    triangles.Add(current);
                }
            }
        }
    }
}
