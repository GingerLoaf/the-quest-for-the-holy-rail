using Unity.Mathematics;

namespace HolyRail.Splines
{
    public enum SplineNoiseType
    {
        Simplex,    // Smooth, organic - good default
        Perlin,     // Classic, slightly grid-aligned
        Voronoi,    // Cellular, creates angular patterns
        Ridged      // Sharp ridges, dramatic effect
    }

    public static class SplineNoise
    {
        // Permutation table for noise functions
        private static readonly int[] Perm =
        {
            151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
            140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
            247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
            57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
            74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
            60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
            65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
            200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
            52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
            207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
            119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
            218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
            81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
            184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
            222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
        };

        // Gradient vectors for 3D simplex noise
        private static readonly float3[] Grad3 =
        {
            new float3(1, 1, 0), new float3(-1, 1, 0), new float3(1, -1, 0), new float3(-1, -1, 0),
            new float3(1, 0, 1), new float3(-1, 0, 1), new float3(1, 0, -1), new float3(-1, 0, -1),
            new float3(0, 1, 1), new float3(0, -1, 1), new float3(0, 1, -1), new float3(0, -1, -1)
        };

        public static float3 SampleNoise3D(float3 position, SplineNoiseType type, float frequency)
        {
            var p = position * frequency;

            // Sample noise at 3 offset positions for XYZ components
            float noiseX = SampleSingleNoise(p, type);
            float noiseY = SampleSingleNoise(p + new float3(31.416f, 47.853f, 12.793f), type);
            float noiseZ = SampleSingleNoise(p + new float3(73.156f, 19.427f, 56.318f), type);

            return new float3(noiseX, noiseY, noiseZ);
        }

        private static float SampleSingleNoise(float3 p, SplineNoiseType type)
        {
            return type switch
            {
                SplineNoiseType.Simplex => SimplexNoise3D(p),
                SplineNoiseType.Perlin => PerlinNoise3D(p),
                SplineNoiseType.Voronoi => VoronoiNoise3D(p),
                SplineNoiseType.Ridged => RidgedNoise3D(p),
                _ => SimplexNoise3D(p)
            };
        }

        public static float SimplexNoise3D(float3 v)
        {
            // Skew constants for 3D
            const float F3 = 1f / 3f;
            const float G3 = 1f / 6f;

            // Skew the input space to determine simplex cell
            float s = (v.x + v.y + v.z) * F3;
            int i = FastFloor(v.x + s);
            int j = FastFloor(v.y + s);
            int k = FastFloor(v.z + s);

            float t = (i + j + k) * G3;
            float x0 = v.x - (i - t);
            float y0 = v.y - (j - t);
            float z0 = v.z - (k - t);

            // Determine which simplex we're in
            int i1, j1, k1;
            int i2, j2, k2;

            if (x0 >= y0)
            {
                if (y0 >= z0)
                {
                    i1 = 1; j1 = 0; k1 = 0; i2 = 1; j2 = 1; k2 = 0;
                }
                else if (x0 >= z0)
                {
                    i1 = 1; j1 = 0; k1 = 0; i2 = 1; j2 = 0; k2 = 1;
                }
                else
                {
                    i1 = 0; j1 = 0; k1 = 1; i2 = 1; j2 = 0; k2 = 1;
                }
            }
            else
            {
                if (y0 < z0)
                {
                    i1 = 0; j1 = 0; k1 = 1; i2 = 0; j2 = 1; k2 = 1;
                }
                else if (x0 < z0)
                {
                    i1 = 0; j1 = 1; k1 = 0; i2 = 0; j2 = 1; k2 = 1;
                }
                else
                {
                    i1 = 0; j1 = 1; k1 = 0; i2 = 1; j2 = 1; k2 = 0;
                }
            }

            float x1 = x0 - i1 + G3;
            float y1 = y0 - j1 + G3;
            float z1 = z0 - k1 + G3;
            float x2 = x0 - i2 + 2f * G3;
            float y2 = y0 - j2 + 2f * G3;
            float z2 = z0 - k2 + 2f * G3;
            float x3 = x0 - 1f + 3f * G3;
            float y3 = y0 - 1f + 3f * G3;
            float z3 = z0 - 1f + 3f * G3;

            // Calculate contributions from the four corners
            int ii = i & 255;
            int jj = j & 255;
            int kk = k & 255;

            float n0 = CalculateCornerContribution(x0, y0, z0, ii, jj, kk);
            float n1 = CalculateCornerContribution(x1, y1, z1, ii + i1, jj + j1, kk + k1);
            float n2 = CalculateCornerContribution(x2, y2, z2, ii + i2, jj + j2, kk + k2);
            float n3 = CalculateCornerContribution(x3, y3, z3, ii + 1, jj + 1, kk + 1);

            // Scale to [-1, 1]
            return 32f * (n0 + n1 + n2 + n3);
        }

        private static float CalculateCornerContribution(float x, float y, float z, int i, int j, int k)
        {
            float t = 0.6f - x * x - y * y - z * z;
            if (t < 0)
                return 0f;

            t *= t;
            int gi = Perm[(i + Perm[(j + Perm[k & 255]) & 255]) & 255] % 12;
            return t * t * math.dot(Grad3[gi], new float3(x, y, z));
        }

        public static float PerlinNoise3D(float3 p)
        {
            // Layer 2D Perlin samples from multiple planes
            float xy = UnityEngine.Mathf.PerlinNoise(p.x, p.y);
            float xz = UnityEngine.Mathf.PerlinNoise(p.x + 100f, p.z);
            float yz = UnityEngine.Mathf.PerlinNoise(p.y + 200f, p.z + 100f);

            // Remap from [0, 1] to [-1, 1]
            return ((xy + xz + yz) / 3f) * 2f - 1f;
        }

        public static float VoronoiNoise3D(float3 p)
        {
            var cellPos = new int3(FastFloor(p.x), FastFloor(p.y), FastFloor(p.z));
            var fracPos = p - new float3(cellPos.x, cellPos.y, cellPos.z);

            float minDist = float.MaxValue;

            // Check 3x3x3 neighborhood
            for (int x = -1; x <= 1; x++)
            {
                for (int y = -1; y <= 1; y++)
                {
                    for (int z = -1; z <= 1; z++)
                    {
                        var neighbor = new int3(x, y, z);
                        var neighborCell = cellPos + neighbor;

                        // Hash to get random point within cell
                        var randomPoint = Hash3D(neighborCell);
                        var diff = new float3(neighbor.x, neighbor.y, neighbor.z) + randomPoint - fracPos;
                        float dist = math.dot(diff, diff);

                        minDist = math.min(minDist, dist);
                    }
                }
            }

            // Return normalized distance, mapped to [-1, 1]
            return math.sqrt(minDist) * 2f - 1f;
        }

        public static float RidgedNoise3D(float3 p)
        {
            // Sharp ridges using inverted absolute value of simplex
            return 1f - math.abs(SimplexNoise3D(p)) * 2f;
        }

        private static int FastFloor(float x)
        {
            return x >= 0 ? (int)x : (int)x - 1;
        }

        private static float3 Hash3D(int3 cell)
        {
            // Simple hash function for deterministic random per cell
            int n = cell.x * 157 + cell.y * 571 + cell.z * 1063;
            n = (n << 13) ^ n;
            int hash = n * (n * n * 15731 + 789221) + 1376312589;

            float x = (float)(hash & 0x7FFFFFFF) / 0x7FFFFFFF;
            hash = hash * 16807;
            float y = (float)(hash & 0x7FFFFFFF) / 0x7FFFFFFF;
            hash = hash * 16807;
            float z = (float)(hash & 0x7FFFFFFF) / 0x7FFFFFFF;

            return new float3(x, y, z);
        }
    }
}
