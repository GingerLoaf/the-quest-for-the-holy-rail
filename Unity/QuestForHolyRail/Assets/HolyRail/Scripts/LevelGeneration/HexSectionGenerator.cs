using System.Collections.Generic;
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
            GenerateGrafittiSurfaces(target, config, random, obstacles);
            
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
                float rampHeight = rampLength * Mathf.Sin(rampAngle * Mathf.Deg2Rad);

                // Find valid position inside hex
                var position = Vector3.zero;
                bool valid = false;

                for (int attempt = 0; attempt < 50; attempt++)
                {
                    // Increased spacing check
                    position = RandomPointInHex(random, config.Circumradius * 0.7f);

                    var testBounds = new Bounds(position,
                        new Vector3(rampWidth + 4f, rampHeight, rampLength + 4f)); // Padded bounds
                    
                    if (IsPositionClear(testBounds, obstacles, 0f))
                    {
                        valid = true;
                        break;
                    }
                }

                if (!valid)
                    continue;

                // Orient generally toward exit with random variation
                float yawVariation = (float)(random.NextDouble() * 60.0 - 30.0);
                float yaw = Mathf.Atan2(generalDir.x, generalDir.z) * Mathf.Rad2Deg + yawVariation;
                var rotation = Quaternion.Euler(-rampAngle, yaw, 0f);

                GameObject rampGO;
                if (config.RampPrefab != null)
                {
                    rampGO = Object.Instantiate(config.RampPrefab, rampParent.transform);
                    rampGO.name = $"Ramp_{i}";
                    rampGO.transform.localPosition = position + Vector3.up * (rampHeight * 0.5f); // Adjust if prefab Pivot is bottom
                    rampGO.transform.localRotation = rotation;
                    
                    // We assume prefab is roughly unit sized or we scale it to match logic??
                    // User request "expose a prefab that users can specify to use as ramps"
                    // Usually prefabs have their own art. We might NOT want to stretch them blindly?
                    // BUT, the generator logic fundamentally relies on variable length/width/angle.
                    // For now, let's scale it.
                    rampGO.transform.localScale = new Vector3(rampWidth, 0.3f, rampLength); 
                    // Note: Ramps usually need Y scale? 0.3f is thin thickness.
                }
                else
                {
                    rampGO = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    rampGO.name = $"Ramp_{i}";
                    rampGO.transform.SetParent(rampParent.transform, false);
                    rampGO.transform.localScale = new Vector3(rampWidth, 0.3f, rampLength);
                    rampGO.transform.localPosition = position + Vector3.up * (rampHeight * 0.5f);
                    rampGO.transform.localRotation = rotation;

                    if (config.RampMaterial != null)
                        rampGO.GetComponent<MeshRenderer>().sharedMaterial = config.RampMaterial;
                }
                
                // For obstacles, we use the collider bounds.
                var col = rampGO.GetComponent<Collider>();
                if (col == null) col = rampGO.AddComponent<BoxCollider>(); // Ensure collider
                
                var rampBounds = col.bounds;
                obstacles.Add(new PlacedObstacle { Bounds = rampBounds });

                // Calculate clearance zones (entry/exit of ramp)
                // Bottom of ramp - prevent obstacles here
                Vector3 bottomPos = position - rotation * Vector3.forward * (rampLength * 0.5f);
                clearanceZones.Add(new Bounds(bottomPos, new Vector3(rampWidth + 4f, 4f, 6f)));
                
                // Top flight path - prevent obstacles here
                Vector3 topPos = position + rotation * Vector3.forward * (rampLength * 0.5f);
                clearanceZones.Add(new Bounds(topPos + Vector3.up * 2f, new Vector3(rampWidth + 4f, 10f, 8f)));
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

                var position = Vector3.zero;
                bool valid = false;

                for (int attempt = 0; attempt < 20; attempt++)
                {
                    position = RandomPointInHex(random, config.Circumradius * 0.7f);
                    
                    // Increased clearance for sparsity (was 2f, now 5f)
                    var testBounds = new Bounds(position + Vector3.up * size.y * 0.5f, size);
                    if (!IsPositionClear(testBounds, obstacles, 5f)) 
                        continue;

                    // Check ramp clearance zones
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

                float yaw = (float)(random.NextDouble() * 360.0);
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

                // Force Curve / Winding Logic
                // Instead of straight line from entry to exit, we add a major control point in the middle
                // that pulls the rail strongly to one side or the other.
                // For primary rail, we might keep it straighter, but user wants winding rails.
                // So we always add some "Major Offset".
                
                float windingIntensity = Lerp(10f, config.Circumradius * 0.8f, (float)random.NextDouble());
                if (random.NextDouble() > 0.5) windingIntensity = -windingIntensity;
                
                // If lateral offset already provides spacing, add winding on top
                float majorOffset = lateralOffset + windingIntensity;
                majorOffset = Mathf.Clamp(majorOffset, -maxLateral, maxLateral);

                var controlPoints = GenerateRailPath(
                    entryMid, exitMid, config, random, r, lateralOffset, majorOffset, heightBase, obstacles
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

                // React to obstacles (Wind around or go over)
                foreach (var obs in obstacles)
                {
                    // Simple distance check to obstacle center bounds
                    var obsCenter = obs.Bounds.center;
                    var obsSize = obs.Bounds.size;
                    float checkRadius = Mathf.Max(obsSize.x, obsSize.z) * 0.7f; 

                    Vector2 pt2D = new Vector2(point.x, point.z);
                    Vector2 obs2D = new Vector2(obsCenter.x, obsCenter.z);
                    float dist = Vector2.Distance(pt2D, obs2D);

                    if (dist < checkRadius + 2f) 
                    {
                        if (point.y > obs.Bounds.max.y - 1f || height > obs.Bounds.max.y + 1f)
                        {
                            point.y = Mathf.Max(point.y, obs.Bounds.max.y + 1.5f);
                        }
                        else
                        {
                            Vector2 pushDir = (pt2D - obs2D).normalized;
                            if (pushDir == Vector2.zero) pushDir = Vector2.right; 
                            
                            float pushDist = (checkRadius + 2f) - dist;
                            Vector2 newPos2D = pt2D + pushDir * pushDist;
                            point.x = newPos2D.x;
                            point.z = newPos2D.y;
                        }
                    }
                }

                // Clamp to hex bounds (looser clamping to allow winding)
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
            List<PlacedObstacle> obstacles)
        {
            if (obstacles.Count == 0) return;
            Debug.Log("Obstacles Count= " + obstacles.Count);

            int wallCount = RandomRange(random, config.MinGrafittiWallCount, config.MaxGrafittiWallCount + 1);
            var wallParent = new GameObject("GraffitiWalls");
            wallParent.transform.SetParent(target.transform, false);

            int placedCount = 0;
            // Shuffle obstacles to pick random ones
            var shuffledObstacles = new List<PlacedObstacle>(obstacles);
            // Fisher-Yates shuffle
            for(int i = shuffledObstacles.Count - 1; i > 0; i--) {
                int k = random.Next(i + 1);
                var temp = shuffledObstacles[k];
                shuffledObstacles[k] = shuffledObstacles[i];
                shuffledObstacles[i] = temp;
            }

            foreach (var obs in shuffledObstacles)
            {
                if (placedCount >= wallCount) break;

                // Ensure obstacle is big enough for a wall
                //if (obs.Bounds.size.y < 3f || obs.Bounds.size.x < 3f) continue;

                // Pick a side (faces of cube)
                // 0: Forward, 1: Back, 2: Left, 3: Right
                int side = random.Next(4);
                Vector3 normal = Vector3.forward;
                Vector3 offset = Vector3.zero;

                switch(side)
                {
                    case 0: normal = Vector3.forward; offset = Vector3.forward * obs.Bounds.extents.z; break;
                    case 1: normal = Vector3.back; offset = Vector3.back * obs.Bounds.extents.z; break;
                    case 2: normal = Vector3.left; offset = Vector3.left * obs.Bounds.extents.x; break;
                    case 3: normal = Vector3.right; offset = Vector3.right * obs.Bounds.extents.x; break;
                }
                Debug.Log("Creating a grafitti wall");

                // Create wall panel
                var wallGO = GameObject.CreatePrimitive(PrimitiveType.Cube);
                wallGO.name = $"Graffiti_Attached_{placedCount}";
                wallGO.layer = HexConstants.BillboardLayer;
                wallGO.transform.SetParent(wallParent.transform, false);
                
                // Size: slightly smaller than the obstacle face
                float w = (side < 2) ? obs.Bounds.size.x : obs.Bounds.size.z;
                float h = obs.Bounds.size.y;
                
                wallGO.transform.localScale = new Vector3(w * 0.8f, h * 0.8f, config.GrafittiWallDepth);
                
                // Position: On the face surface
                //Vector3 wallOrientation = obs. + offset + normal * (config.GrafittiWallDepth * 0.5f);
                //wallGO.transform.position = wallPos; // World position, but parent is section... wait, bounds are world space usually? 
                // Wait, Primitive Bounds are world space. But we need local space relative to section. Since section might be at 0,0,0 during gen, it's fine.
                // However, PlacedObstacle.Bounds comes from collider.bounds which IS world space.
                // If section is not at 0,0,0, this breaks.
                // Since this is Editor tool, section is usually at some place.
                // We should convert world bounds center to local space.
                wallGO.transform.position = obs.transform. position + offset * (config.GrafittiWallDepth * 0.5f);
                //Vector3 localPos = target.transform.InverseTransformPoint(wallPos);
                //wallGO.transform.localPosition = localPos;

                wallGO.transform.rotation = obs.transform.rotation;

                if (config.WallMaterial != null)
                    wallGO.GetComponent<MeshRenderer>().sharedMaterial = config.WallMaterial;
                
                placedCount++;
            }
            Debug.Log("Placed Grafitti walls: " + placedCount);
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
