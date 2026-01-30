using System.Collections.Generic;
using HolyRail.Graffiti;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Splines;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.Scripts.LevelGeneration
{
    public static class HexSectionGenerator
    {
        private struct PlacedObstacle
        {
            public Bounds Bounds;
            public Transform transform;
        }

        public static void Generate(HexSection target, HexSectionConfig config, int seed)
        {
            Clear(target);

            var random = new System.Random(seed);

            // 1. Randomize Entry/Exit
            int entry = config.EntryEdge;
            int exit = config.ExitEdge;

            if (config.RandomizeEntryExit)
            {
                // +/- 1 edge
                for (int attempt = 0; attempt < 20; attempt++)
                {
                    int entryOffset = random.Next(-1, 2); // -1, 0, 1
                    int exitOffset = random.Next(-1, 2);
                    
                    int testEntry = (config.EntryEdge + entryOffset + 6) % 6;
                    int testExit = (config.ExitEdge + exitOffset + 6) % 6;

                    // Valid if NOT same and NOT neighbors
                    int diff = Mathf.Abs(testEntry - testExit);
                    bool isNeighbor = (diff == 1 || diff == 5);
                    
                    if (testEntry != testExit && !isNeighbor)
                    {
                        entry = testEntry;
                        exit = testExit;
                        break;
                    }
                }
            }

            target.Circumradius = config.Circumradius;
            target.EntryEdge = entry;
            target.ExitEdge = exit;
            target.Seed = seed;
            target.ConfigName = config.name;

            target.PickUpPrefab = config.PickUpPrefab;
            target.PickUpCount = config.PickUpCount;
            target.MinPickUpSpacing = config.MinPickUpSpacing;
            target.PickUpHeightOffset = config.PickUpHeightOffset;

            GenerateGroundPlane(target, config);
            GenerateEdgePoints(target, config);
            GenerateBoundaryWalls(target, config);

            var obstacles = new List<PlacedObstacle>();
            var rampClearanceZones = new List<Bounds>();

            GenerateRamps(target, config, random, obstacles, rampClearanceZones);
            GenerateCubeObstacles(target, config, random, obstacles, rampClearanceZones);
            
            var railEndpoints = GenerateRails(target, config, random, obstacles);
            GenerateGrafittiSurfaces(target, config, random, obstacles, railEndpoints);
            
            TryGenerateShop(target, config, random);

#if UNITY_EDITOR
            if (!Application.isPlaying)
                EditorUtility.SetDirty(target);
#endif
        }

        public static void Clear(HexSection target)
        {
            // Destroy all children
            for (int i = target.transform.childCount - 1; i >= 0; i--)
            {
                var child = target.transform.GetChild(i).gameObject;
#if UNITY_EDITOR
                if (!Application.isPlaying)
                    Object.DestroyImmediate(child);
                else
#endif
                    Object.Destroy(child);
            }

            target.EntryPoints = null;
            target.ExitPoints = null;
            target.HasShop = false;
            target.SplineMeshControllers = null;
        }

        // --- Ground Plane ---

        private static void GenerateGroundPlane(HexSection target, HexSectionConfig config)
        {
            var groundGO = new GameObject("Ground");
            groundGO.transform.SetParent(target.transform, false);

            Mesh mesh = null;
#if UNITY_EDITOR
            // Try to load or create asset for mesh so it saves with prefab
            if (!Application.isPlaying)
            {
                string folder = "Assets/HolyRail/GeneratedMeshes";
                if (!System.IO.Directory.Exists(folder))
                {
                    System.IO.Directory.CreateDirectory(folder);
                    AssetDatabase.Refresh();
                }

                string assetPath = $"{folder}/HexMesh_{config.Circumradius:F0}.asset";
                mesh = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);
                
                if (mesh == null)
                {
                    mesh = CreateHexMesh(config.Circumradius);
                    AssetDatabase.CreateAsset(mesh, assetPath);
                    AssetDatabase.SaveAssets();
                }
            }
#endif
            if (mesh == null)
                mesh = CreateHexMesh(config.Circumradius);

            var meshFilter = groundGO.AddComponent<MeshFilter>();
            meshFilter.sharedMesh = mesh;

            var meshRenderer = groundGO.AddComponent<MeshRenderer>();
            if (config.GroundMaterial != null)
                meshRenderer.sharedMaterial = config.GroundMaterial;
            else
                meshRenderer.sharedMaterial = GetDefaultMaterial();

            groundGO.AddComponent<MeshCollider>().sharedMesh = mesh;
        }

        private static Mesh CreateHexMesh(float circumradius)
        {
            var vertices = new Vector3[HexConstants.EdgeCount + 1];
            vertices[0] = Vector3.zero; // center

            for (int i = 0; i < HexConstants.EdgeCount; i++)
                vertices[i + 1] = HexConstants.GetVertex(i, circumradius);

            var triangles = new int[HexConstants.EdgeCount * 3];
            for (int i = 0; i < HexConstants.EdgeCount; i++)
            {
                int nextVertex = (i + 1) % HexConstants.EdgeCount + 1;
                // Clockwise winding for upward-facing normal
                triangles[i * 3] = 0;
                triangles[i * 3 + 1] = nextVertex;
                triangles[i * 3 + 2] = i + 1;
            }

            var uvs = new Vector2[vertices.Length];
            uvs[0] = new Vector2(0.5f, 0.5f);
            for (int i = 0; i < HexConstants.EdgeCount; i++)
            {
                uvs[i + 1] = new Vector2(
                    (vertices[i + 1].x / circumradius + 1f) * 0.5f,
                    (vertices[i + 1].z / circumradius + 1f) * 0.5f
                );
            }

            var mesh = new Mesh
            {
                name = "HexGround",
                vertices = vertices,
                triangles = triangles,
                uv = uvs
            };
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();
            return mesh;
        }

        // --- Edge Points ---

        private static void GenerateEdgePoints(HexSection target, HexSectionConfig config)
        {
            target.EntryPoints = CreateEdgePoints(
                target.transform, target.EntryEdge, config.Circumradius, true, false
            );
            target.ExitPoints = CreateEdgePoints(
                target.transform, target.ExitEdge, config.Circumradius, false, true
            );
        }

        private static HexEdgePoint[] CreateEdgePoints(
            Transform parent, int edgeIndex, float circumradius, bool isEntry, bool isExit)
        {
            var points = new HexEdgePoint[2];
            var edgeNormal = HexConstants.GetEdgeNormal(edgeIndex, circumradius);
            var forwardDir = isEntry ? -edgeNormal : edgeNormal;

            for (int i = 0; i < 2; i++)
            {
                float fraction = (i + 1) / 3f;
                var localPos = HexConstants.GetEdgePointAtFraction(edgeIndex, fraction, circumradius);

                var label = isEntry ? "EntryPoint" : "ExitPoint";
                var pointGO = new GameObject($"{label}_{edgeIndex}_{i}");
                pointGO.transform.SetParent(parent, false);
                pointGO.transform.localPosition = localPos;
                pointGO.transform.localRotation = Quaternion.LookRotation(forwardDir, Vector3.up);

                var edgePoint = pointGO.AddComponent<HexEdgePoint>();
                edgePoint.EdgeIndex = edgeIndex;
                edgePoint.IsEntry = isEntry;
                edgePoint.IsExit = isExit;

                points[i] = edgePoint;
            }

            return points;
        }

        // --- Boundary Walls ---

        private static void GenerateBoundaryWalls(HexSection target, HexSectionConfig config)
        {
            if(config.useBoundaryWalls == false)
            {
                return;
            }
            var wallParent = new GameObject("BoundaryWalls");
            wallParent.transform.SetParent(target.transform, false);

            for (int i = 0; i < 6; i++)
            {
                if (i == target.EntryEdge || i == target.ExitEdge)
                    continue;

                var wallGO = GameObject.CreatePrimitive(PrimitiveType.Cube);
                wallGO.name = $"BoundaryWall_{i}";
                wallGO.transform.SetParent(wallParent.transform, false);

                var midpoint = HexConstants.GetEdgeMidpoint(i, config.Circumradius);
                var normal = HexConstants.GetEdgeNormal(i, config.Circumradius);
                
                // Align so Z is thickness (along normal), X is width (along edge), Y is height
                wallGO.transform.localScale = new Vector3(config.Circumradius, config.BoundaryWallHeight, config.BoundaryWallThickness);
                
                wallGO.transform.localPosition = midpoint + Vector3.up * (config.BoundaryWallHeight * 0.5f);
                wallGO.transform.localRotation = Quaternion.LookRotation(normal, Vector3.up);

                if (config.BoundaryWallMaterial != null)
                    wallGO.GetComponent<MeshRenderer>().sharedMaterial = config.BoundaryWallMaterial;
                else
                    wallGO.GetComponent<MeshRenderer>().sharedMaterial = GetDefaultMaterial();
            }
        }

        // --- Ramps ---

        private static void GenerateRamps(
            HexSection target, HexSectionConfig config, System.Random random,
            List<PlacedObstacle> obstacles, List<Bounds> clearanceZones)
        {
            int rampCount = RandomRange(random, config.MinRampCount, config.MaxRampCount + 1);
            var rampParent = new GameObject("Ramps");
            rampParent.transform.SetParent(target.transform, false);

            var exitMid = HexConstants.GetEdgeMidpoint(target.ExitEdge, config.Circumradius);
            var entryMid = HexConstants.GetEdgeMidpoint(target.EntryEdge, config.Circumradius);
            var generalDir = (exitMid - entryMid).normalized;

            for (int i = 0; i < rampCount; i++)
            {
                float rampLength = Lerp(config.RampLengthMin, config.RampLengthMax,
                    (float)random.NextDouble());
                float rampWidth = Lerp(config.RampWidthMin, config.RampWidthMax,
                    (float)random.NextDouble());
                float rampAngle = Lerp(config.RampAngleMin, config.RampAngleMax,
                    (float)random.NextDouble());
                float halfLength = rampLength * 0.5f;
                float angleRad = rampAngle * Mathf.Deg2Rad;
                float peakHeight = halfLength * Mathf.Sin(angleRad);
                float cosHalf = halfLength * Mathf.Cos(angleRad) * 0.5f;

                var position = Vector3.zero;
                bool valid = false;

                for (int attempt = 0; attempt < 50; attempt++)
                {
                    position = RandomPointInHex(random, config.Circumradius * 0.7f);

                    var testBounds = new Bounds(position + Vector3.up * peakHeight * 0.5f,
                        new Vector3(rampWidth + 4f, peakHeight + 1f, rampLength + 4f));

                    if (IsPositionClear(testBounds, obstacles, 0f))
                    {
                        valid = true;
                        break;
                    }
                }

                if (!valid)
                    continue;

                float yawVariation = (float)(random.NextDouble() * 60.0 - 30.0);
                float yaw = Mathf.Atan2(generalDir.x, generalDir.z) * Mathf.Rad2Deg + yawVariation;
                var parentRotation = Quaternion.Euler(0f, yaw, 0f);

                GameObject rampGO;
                if (config.RampPrefab != null)
                {
                    rampGO = Object.Instantiate(config.RampPrefab, rampParent.transform);
                    rampGO.name = $"Ramp_{i}";
                    rampGO.transform.localPosition = position;
                    rampGO.transform.localRotation = parentRotation;
                }
                else
                {
                    rampGO = new GameObject($"Ramp_{i}");
                    rampGO.transform.SetParent(rampParent.transform, false);
                    rampGO.transform.localPosition = position;
                    rampGO.transform.localRotation = parentRotation;

                    // Side A: ramps up from -Z toward peak at center
                    var sideA = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    sideA.name = $"Ramp_{i}_SideA";
                    sideA.transform.SetParent(rampGO.transform, false);
                    sideA.transform.localScale = new Vector3(rampWidth, 0.3f, halfLength);
                    sideA.transform.localPosition = new Vector3(0f, peakHeight * 0.5f, -cosHalf);
                    sideA.transform.localRotation = Quaternion.Euler(-rampAngle, 0f, 0f);

                    if (config.RampMaterial != null)
                        sideA.GetComponent<MeshRenderer>().sharedMaterial = config.RampMaterial;

                    // Side B: ramps up from +Z toward peak at center
                    var sideB = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    sideB.name = $"Ramp_{i}_SideB";
                    sideB.transform.SetParent(rampGO.transform, false);
                    sideB.transform.localScale = new Vector3(rampWidth, 0.3f, halfLength);
                    sideB.transform.localPosition = new Vector3(0f, peakHeight * 0.5f, cosHalf);
                    sideB.transform.localRotation = Quaternion.Euler(rampAngle, 0f, 0f);

                    if (config.RampMaterial != null)
                        sideB.GetComponent<MeshRenderer>().sharedMaterial = config.RampMaterial;

                    // Add a box collider encompassing both sides
                    var col = rampGO.AddComponent<BoxCollider>();
                    col.center = Vector3.up * peakHeight * 0.5f;
                    col.size = new Vector3(rampWidth, peakHeight + 0.3f, rampLength);
                }

                var rampBounds = new Bounds(
                    rampGO.transform.TransformPoint(Vector3.up * peakHeight * 0.5f),
                    new Vector3(rampWidth, peakHeight + 0.3f, rampLength)
                );
                obstacles.Add(new PlacedObstacle { Bounds = rampBounds });

                // Clearance zones on both approach sides
                var fwd = parentRotation * Vector3.forward;
                clearanceZones.Add(new Bounds(
                    position - fwd * (halfLength + 2f),
                    new Vector3(rampWidth + 4f, 4f, 6f)));
                clearanceZones.Add(new Bounds(
                    position + fwd * (halfLength + 2f),
                    new Vector3(rampWidth + 4f, 4f, 6f)));
            }
        }

        // --- Cube Obstacles ---

        private static void GenerateCubeObstacles(
            HexSection target, HexSectionConfig config, System.Random random,
            List<PlacedObstacle> obstacles, List<Bounds> clearanceZones)
        {
            int count = RandomRange(random, config.MinCubeObstacleCount, config.MaxCubeObstacleCount + 1);
            var obstacleParent = new GameObject("Obstacles");
            obstacleParent.transform.SetParent(target.transform, false);

            var entryMid = HexConstants.GetEdgeMidpoint(target.EntryEdge, config.Circumradius);
            var exitMid = HexConstants.GetEdgeMidpoint(target.ExitEdge, config.Circumradius);
            var travelDir = (exitMid - entryMid).normalized;
            float baseYaw = Mathf.Atan2(travelDir.x, travelDir.z) * Mathf.Rad2Deg;
            float[] yawOptions = { baseYaw, baseYaw + 90f, baseYaw + 180f, baseYaw + 270f };

            for (int i = 0; i < count; i++)
            {
                var size = new Vector3(
                    Lerp(config.CubeObstacleSizeMin.x, config.CubeObstacleSizeMax.x,
                        (float)random.NextDouble()),
                    Lerp(config.CubeObstacleSizeMin.y, config.CubeObstacleSizeMax.y,
                        (float)random.NextDouble()),
                    Lerp(config.CubeObstacleSizeMin.z, config.CubeObstacleSizeMax.z,
                        (float)random.NextDouble())
                );

                float yaw = yawOptions[random.Next(yawOptions.Length)];

                // Compute world-space AABB after rotation
                float yawRad = yaw * Mathf.Deg2Rad;
                float absC = Mathf.Abs(Mathf.Cos(yawRad));
                float absS = Mathf.Abs(Mathf.Sin(yawRad));
                var rotatedSize = new Vector3(
                    size.x * absC + size.z * absS,
                    size.y,
                    size.x * absS + size.z * absC
                );

                float diagonal = Mathf.Sqrt(rotatedSize.x * rotatedSize.x + rotatedSize.z * rotatedSize.z);
                float minSeparation = diagonal * 0.5f;

                var position = Vector3.zero;
                bool valid = false;

                for (int attempt = 0; attempt < 50; attempt++)
                {
                    position = RandomPointInHex(random, config.Circumradius * 0.7f);

                    var testBounds = new Bounds(
                        position + Vector3.up * rotatedSize.y * 0.5f,
                        rotatedSize
                    );

                    float clearance = Mathf.Max(5f, minSeparation);
                    if (!IsPositionClear(testBounds, obstacles, clearance))
                        continue;

                    bool rampClear = true;
                    foreach (var zone in clearanceZones)
                    {
                        if (zone.Intersects(testBounds))
                        {
                            rampClear = false;
                            break;
                        }
                    }
                    if (!rampClear) continue;

                    valid = true;
                    break;
                }

                if (!valid)
                    continue;

                var cubeGO = GameObject.CreatePrimitive(PrimitiveType.Cube);
                cubeGO.name = $"Obstacle_{i}";
                cubeGO.transform.SetParent(obstacleParent.transform, false);
                cubeGO.transform.localScale = size;
                cubeGO.transform.localPosition = position + Vector3.up * (size.y * 0.5f);
                cubeGO.transform.localRotation = Quaternion.Euler(0f, yaw, 0f);

                if (config.ObstacleMaterial != null)
                    cubeGO.GetComponent<MeshRenderer>().sharedMaterial = config.ObstacleMaterial;

                obstacles.Add(new PlacedObstacle
                {
                    Bounds = cubeGO.GetComponent<Collider>().bounds,
                    transform = cubeGO.transform
                });
            }
        }

        // --- Rail Splines ---

        private static List<Vector3[]> GenerateRails(
            HexSection target, HexSectionConfig config, System.Random random,
            List<PlacedObstacle> obstacles)
        {
            int railCount = RandomRange(random, config.MinRailCount, config.MaxRailCount + 1);
            var entryMid = HexConstants.GetEdgeMidpoint(target.EntryEdge, config.Circumradius);
            var exitMid = HexConstants.GetEdgeMidpoint(target.ExitEdge, config.Circumradius);
            var railParent = new GameObject("Rails");
            railParent.transform.SetParent(target.transform, false);

            var allRailEndpoints = new List<Vector3[]>();
            var usedLateralOffsets = new List<float>();

            for (int r = 0; r < railCount; r++)
            {
                float lateralOffset = 0f;
                float heightBase;
                bool isPrimary = r == 0;
                
                // For non-primary rails, we allow them to wander more near the perimeter
                float maxLateral = config.Circumradius * 0.85f;

                if (isPrimary)
                {
                    heightBase = config.RailMinHeight;
                    usedLateralOffsets.Add(0f);
                }
                else
                {
                    heightBase = Lerp(config.RailMinHeight, config.RailMaxHeight,
                        (float)random.NextDouble());
                    
                    bool validOffset = false;
                    for (int attempt = 0; attempt < 20; attempt++)
                    {
                        lateralOffset = (float)(random.NextDouble() * 2.0 - 1.0) * maxLateral;
                        
                        bool tooClose = false;
                        foreach (var used in usedLateralOffsets)
                        {
                            if (Mathf.Abs(used - lateralOffset) < config.MinRailSpacing)
                            {
                                tooClose = true;
                                break;
                            }
                        }

                        if (!tooClose)
                        {
                            validOffset = true;
                            break;
                        }
                    }
                    usedLateralOffsets.Add(lateralOffset);
                }

                // Determine rail start/end points
                var railStart = entryMid;
                var railEnd = exitMid;

                if (!isPrimary)
                {
                    bool truncateStart = (float)random.NextDouble() < 0.3f;
                    bool truncateEnd = (float)random.NextDouble() < 0.3f;

                    if (truncateStart)
                    {
                        var interiorPoint = RandomPointInHex(random, config.Circumradius * 0.6f);
                        railStart = new Vector3(interiorPoint.x, heightBase, interiorPoint.z);
                    }

                    if (truncateEnd)
                    {
                        var interiorPoint = RandomPointInHex(random, config.Circumradius * 0.6f);
                        railEnd = new Vector3(interiorPoint.x, heightBase, interiorPoint.z);
                    }
                }

                // Force Curve / Winding Logic
                float windingIntensity = Lerp(10f, config.Circumradius * 0.8f, (float)random.NextDouble());
                if (random.NextDouble() > 0.5) windingIntensity = -windingIntensity;

                float majorOffset = lateralOffset + windingIntensity;
                majorOffset = Mathf.Clamp(majorOffset, -maxLateral, maxLateral);

                var controlPoints = GenerateRailPath(
                    railStart, railEnd, config, random, r, lateralOffset, majorOffset, heightBase, obstacles
                );

                CreateRailSpline(
                    railParent.transform, controlPoints, config.RailMaterial, r
                );

                allRailEndpoints.Add(controlPoints);
            }

            return allRailEndpoints;
        }

        private static Vector3[] GenerateRailPath(
            Vector3 entryMid, Vector3 exitMid,
            HexSectionConfig config, System.Random random,
            int railIndex, float lateralOffset, float majorOffset, float heightBase,
            List<PlacedObstacle> obstacles)
        {
            var direction = (exitMid - entryMid).normalized;
            var right = Vector3.Cross(Vector3.up, direction).normalized;
            
            int pointCount = config.PointsPerRail;
            var points = new Vector3[pointCount];

            float noiseSeedX = railIndex * 100f + (float)(random.NextDouble() * 1000.0);
            float noiseSeedY = railIndex * 200f + (float)(random.NextDouble() * 1000.0);

            for (int i = 0; i < pointCount; i++)
            {
                float t = i / (float)(pointCount - 1);
                var basePos = Vector3.Lerp(entryMid, exitMid, t);

                // Quadratic curve for "Major Offset" / Winding
                // Parabola: 4 * t * (1-t) is 0 at ends, 1 at mid
                float arch = 4f * t * (1f - t);
                float majorCurve = majorOffset * arch;

                // Fine noise
                float taper = 1f - Mathf.Pow(2f * t - 1f, 2f);
                float noiseX = Mathf.PerlinNoise(t * config.RailNoiseFrequency.x * 10f + noiseSeedX, 0f) * 2f - 1f;
                // Combine Major Curve + Fine Noise
                // Note: lateralOffset is somewhat redundant if we use majorOffset, but majorOffset is the ARCH.
                // lateralOffset is usually constant shift. 
                // Let's use lateralOffset as the endpoint shifts (which are 0 here since we start/end at midpoints).
                // Actually, rails enter/exit at specific edge points usually?
                // HexSectionGenerator currently forces all to start at Edge Midpoint.
                // That's fine for now.
                
                float totalLateral = majorCurve + (noiseX * config.RailNoiseAmplitude.x) * taper;

                float noiseY = Mathf.PerlinNoise(t * config.RailNoiseFrequency.y * 10f + noiseSeedY, 0f) * 2f - 1f;
                float height = heightBase + noiseY * config.RailNoiseAmplitude.y * taper;
                height = Mathf.Max(height, HexConstants.RailMinClearance);

                var point = basePos + right * totalLateral + Vector3.up * height;

                // React to obstacles using AABB checks
                point = PushPointFromObstacles(point, obstacles, 3f);

                point = HexConstants.ClampToHex(point, config.Circumradius, 1f);
                points[i] = point;
            }

            // Multi-pass smoothing to reduce kinks from obstacle avoidance
            for (int pass = 0; pass < 3; pass++)
            {
                for (int i = 1; i < pointCount - 1; i++)
                {
                    var prev = points[i - 1];
                    var next = points[i + 1];
                    points[i] = new Vector3(
                        (prev.x + points[i].x + next.x) / 3f,
                        (prev.y + points[i].y + next.y) / 3f,
                        (prev.z + points[i].z + next.z) / 3f
                    );
                }
            }

            // Final obstacle check: ensure smoothing did not push points back into obstacles
            for (int i = 1; i < pointCount - 1; i++)
            {
                var point = PushPointFromObstacles(points[i], obstacles, 3f);
                point = HexConstants.ClampToHex(point, config.Circumradius, 1f);
                points[i] = point;
            }

            return points;
        }

        private static GameObject CreateRailSpline(
            Transform parent, Vector3[] controlPoints, Material material, int railIndex)
        {
            var splineGO = new GameObject($"Rail_{railIndex}");
            splineGO.transform.SetParent(parent, false);
            splineGO.transform.localPosition = Vector3.zero;
            splineGO.transform.localRotation = Quaternion.identity;
            splineGO.transform.localScale = Vector3.one;

            var splineContainer = splineGO.AddComponent<SplineContainer>();
            if (splineContainer.Splines.Count > 0)
                splineContainer.RemoveSplineAt(0);

            var spline = splineContainer.AddSpline();

            foreach (var pos in controlPoints)
            {
                var knot = new BezierKnot(new float3(pos.x, pos.y, pos.z));
                spline.Add(knot, TangentMode.AutoSmooth);
            }

            // Add mesh components for visual representation
            var meshFilter = splineGO.AddComponent<MeshFilter>();
            var meshRenderer = splineGO.AddComponent<MeshRenderer>();

            if (material != null)
                meshRenderer.sharedMaterial = material;
            else
                meshRenderer.sharedMaterial = GetDefaultMaterial();

            var splineExtrude = splineGO.AddComponent<SplineExtrude>();
            splineExtrude.Container = splineContainer;
            splineExtrude.Radius = 0.15f;
            splineExtrude.Sides = 8;
            splineExtrude.SegmentsPerUnit = 4;
            splineExtrude.Capped = true;
            splineExtrude.Rebuild();

            // Add glow controller
            var meshController = splineGO.AddComponent<SplineMeshController>();
            meshController.MeshTarget = meshRenderer;
            meshController.glowLength = 8f;
            meshController.glowBrightness = 1f;
            meshController.showHideDuration = 0.25f;
            meshController.glowMix = 0f;
            meshController.glowLocation = 0f;

#if UNITY_EDITOR
            if (!Application.isPlaying)
                EditorUtility.SetDirty(splineContainer);
#endif

            return splineGO;
        }

        // --- Wall Ride Surfaces ---

        private static void GenerateGrafittiSurfaces(
            HexSection target, HexSectionConfig config, System.Random random,
            List<PlacedObstacle> obstacles, List<Vector3[]> allRailPaths)
        {
            var cubeObstacles = new List<PlacedObstacle>();
            foreach (var obs in obstacles)
            {
                if (obs.transform != null)
                    cubeObstacles.Add(obs);
            }

            if (cubeObstacles.Count == 0) return;

            int wallCount = RandomRange(random, config.MinGrafittiWallCount, config.MaxGrafittiWallCount + 1);
            var wallParent = new GameObject("GraffitiWalls");
            wallParent.transform.SetParent(target.transform, false);

            int placedCount = 0;

            // Fisher-Yates shuffle
            for (int i = cubeObstacles.Count - 1; i > 0; i--)
            {
                int k = random.Next(i + 1);
                var temp = cubeObstacles[k];
                cubeObstacles[k] = cubeObstacles[i];
                cubeObstacles[i] = temp;
            }

            Vector3[] localNormals = { Vector3.forward, Vector3.back, Vector3.left, Vector3.right };

            foreach (var obs in cubeObstacles)
            {
                if (placedCount >= wallCount) break;

                var scale = obs.transform.localScale;
                float[] faceWidths = { scale.x, scale.x, scale.z, scale.z };
                float[] faceHeights = { scale.y, scale.y, scale.y, scale.y };

                // Pick the face whose surface is most parallel to the nearest rail
                var railTangent = GetNearestRailTangent(obs.transform.position, allRailPaths);
                int bestSide = 0;
                float bestDot = float.MaxValue;

                for (int s = 0; s < 4; s++)
                {
                    var worldNormalCandidate = obs.transform.rotation * localNormals[s];
                    float dot = Mathf.Abs(Vector3.Dot(worldNormalCandidate, railTangent));
                    if (dot < bestDot)
                    {
                        bestDot = dot;
                        bestSide = s;
                    }
                }

                var localNormal = localNormals[bestSide];
                float faceWidth = faceWidths[bestSide];
                float faceHeight = faceHeights[bestSide];

                var localFaceCenter = Vector3.Scale(localNormal * 0.5f, scale);
                var worldNormal = obs.transform.rotation * localNormal;
                var worldFaceCenter = obs.transform.position + obs.transform.rotation * localFaceCenter;

                var wallPos = worldFaceCenter + worldNormal * (config.GrafittiWallDepth * 0.5f);

                var wallGO = GameObject.CreatePrimitive(PrimitiveType.Cube);
                wallGO.name = $"Graffiti_Attached_{placedCount}";
                wallGO.layer = HexConstants.BillboardLayer;
                wallGO.transform.SetParent(wallParent.transform, false);

                wallGO.transform.localScale = new Vector3(faceWidth, faceHeight, config.GrafittiWallDepth);
                wallGO.transform.position = wallPos;
                wallGO.transform.rotation = Quaternion.LookRotation(worldNormal, Vector3.up);

                if (config.WallMaterial != null)
                    wallGO.GetComponent<MeshRenderer>().sharedMaterial = config.WallMaterial;

                wallGO.AddComponent<GraffitiSpot>();
                var trigger = wallGO.AddComponent<SphereCollider>();
                trigger.isTrigger = true;
                trigger.radius = Mathf.Max(faceWidth, faceHeight) * 0.5f;

                placedCount++;
            }
        }

        // --- Shop ---

        private static void TryGenerateShop(
            HexSection target, HexSectionConfig config, System.Random random)
        {
            float roll = (float)random.NextDouble();
            if (roll >= config.ShopChance)
                return;

            target.HasShop = true;

            if (config.ShopZonePrefab != null)
            {
                var shopGO = Object.Instantiate(config.ShopZonePrefab, target.transform);
                shopGO.name = "ShopZone";
                shopGO.transform.localPosition = Vector3.zero;
                shopGO.transform.localRotation = Quaternion.identity;
            }
            else
            {
                // Create a placeholder marker when no prefab is assigned
                var markerGO = new GameObject("ShopZone_Placeholder");
                markerGO.transform.SetParent(target.transform, false);
                markerGO.transform.localPosition = Vector3.up * 2f;
            }
        }

        // --- Validation ---

        public static bool ValidateSection(HexSection section)
        {
            if (section.EntryEdge == section.ExitEdge)
            {
                Debug.LogWarning("HexSection: Entry and exit edges are the same.", section);
                return false;
            }

            if (section.EntryPoints == null || section.EntryPoints.Length == 0)
            {
                Debug.LogWarning("HexSection: No entry points.", section);
                return false;
            }

            if (section.ExitPoints == null || section.ExitPoints.Length == 0)
            {
                Debug.LogWarning("HexSection: No exit points.", section);
                return false;
            }

            var splineContainers = section.GetComponentsInChildren<SplineContainer>();
            if (splineContainers.Length == 0)
            {
                Debug.LogWarning("HexSection: No rail splines found.", section);
                return false;
            }

            // Verify wall ride surfaces have adjacent rails
            var wallRideParent = section.transform.Find("WallRideSurfaces");
            if (wallRideParent != null)
            {
                for (int i = 0; i < wallRideParent.childCount; i++)
                {
                    var wall = wallRideParent.GetChild(i);
                    if (wall.gameObject.layer != HexConstants.BillboardLayer)
                    {
                        Debug.LogWarning(
                            $"HexSection: Wall ride surface '{wall.name}' is not on Billboards layer.",
                            wall);
                        return false;
                    }
                }
            }

            return true;
        }

        // --- Helpers ---

        private static Vector3 RandomPointInHex(System.Random random, float maxRadius)
        {
            for (int attempt = 0; attempt < 50; attempt++)
            {
                float x = (float)(random.NextDouble() * 2.0 - 1.0) * maxRadius;
                float z = (float)(random.NextDouble() * 2.0 - 1.0) * maxRadius;
                var point = new Vector3(x, 0f, z);

                if (HexConstants.IsPointInsideHex(point, maxRadius))
                    return point;
            }

            return Vector3.zero;
        }

        private static bool IsPositionClear(Bounds testBounds, List<PlacedObstacle> obstacles, float clearance)
        {
            foreach (var obstacle in obstacles)
            {
                var expanded = obstacle.Bounds;
                expanded.Expand(clearance);
                if (expanded.Intersects(testBounds))
                    return false;
            }

            return true;
        }

        private static bool IsBlockingRailPath(Vector3 position, float radius, Vector3[] railPath)
        {
            float blockRadius = radius + HexConstants.GrindDetectionThreshold;

            foreach (var point in railPath)
            {
                float horizontalDist = Vector2.Distance(
                    new Vector2(position.x, position.z),
                    new Vector2(point.x, point.z)
                );

                if (horizontalDist < blockRadius)
                    return true;
            }

            return false;
        }

        private static Vector3 PushPointFromObstacles(
            Vector3 point, List<PlacedObstacle> obstacles, float margin)
        {
            foreach (var obs in obstacles)
            {
                var expanded = obs.Bounds;
                expanded.Expand(margin * 2f);

                if (!expanded.Contains(point))
                    continue;

                // Point is inside the expanded bounds - push it out
                if (point.y > obs.Bounds.max.y - 1f)
                {
                    // Above or near the top: go over
                    point.y = Mathf.Max(point.y, obs.Bounds.max.y + 1.5f);
                }
                else
                {
                    // Push horizontally to the nearest edge of the expanded bounds
                    float distToMinX = Mathf.Abs(point.x - expanded.min.x);
                    float distToMaxX = Mathf.Abs(point.x - expanded.max.x);
                    float distToMinZ = Mathf.Abs(point.z - expanded.min.z);
                    float distToMaxZ = Mathf.Abs(point.z - expanded.max.z);

                    float minDist = Mathf.Min(distToMinX, Mathf.Min(distToMaxX, Mathf.Min(distToMinZ, distToMaxZ)));

                    if (minDist == distToMinX)
                        point.x = expanded.min.x;
                    else if (minDist == distToMaxX)
                        point.x = expanded.max.x;
                    else if (minDist == distToMinZ)
                        point.z = expanded.min.z;
                    else
                        point.z = expanded.max.z;
                }
            }

            return point;
        }

        private static Vector3 GetNearestRailTangent(Vector3 position, List<Vector3[]> allRailPaths)
        {
            float bestDist = float.MaxValue;
            var bestTangent = Vector3.forward;

            foreach (var path in allRailPaths)
            {
                for (int i = 0; i < path.Length - 1; i++)
                {
                    var segDir = path[i + 1] - path[i];
                    float segLenSq = segDir.sqrMagnitude;
                    if (segLenSq < 0.001f) continue;

                    float t = Mathf.Clamp01(Vector3.Dot(position - path[i], segDir) / segLenSq);
                    var closest = path[i] + segDir * t;

                    float dist = Vector3.Distance(position, closest);
                    if (dist < bestDist)
                    {
                        bestDist = dist;
                        bestTangent = segDir.normalized;
                    }
                }
            }

            return bestTangent;
        }

        private static int RandomRange(System.Random random, int min, int maxExclusive)
        {
            return min + random.Next(maxExclusive - min);
        }

        private static float Lerp(float a, float b, float t)
        {
            return a + (b - a) * t;
        }

        private static Material GetDefaultMaterial()
        {
            // Fallback to Unity's default material
            var primitive = GameObject.CreatePrimitive(PrimitiveType.Cube);
            var mat = primitive.GetComponent<MeshRenderer>().sharedMaterial;
#if UNITY_EDITOR
            if (!Application.isPlaying)
                Object.DestroyImmediate(primitive);
            else
#endif
                Object.Destroy(primitive);
            return mat;
        }
    }
}
