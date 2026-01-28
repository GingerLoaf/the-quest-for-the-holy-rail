using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace HolyRail.City
{
    [ExecuteInEditMode]
    public class CityManager : MonoBehaviour
    {
        [Header("Building Rendering")]
        [field: SerializeField] public Mesh BuildingMesh { get; set; }
        [field: SerializeField] public Material BuildingMaterial { get; set; }

        [Header("Ramp Settings")]
        [field: SerializeField] public bool EnableRamps { get; set; } = true;
        [field: SerializeField] public Mesh RampMesh { get; set; }
        [field: SerializeField] public Material RampMaterial { get; set; }
        [field: SerializeField] public int RampCount { get; set; } = 50;
        [field: SerializeField] public float RampLengthMin { get; set; } = 5f;
        [field: SerializeField] public float RampLengthMax { get; set; } = 15f;
        [field: SerializeField] public float RampWidthMin { get; set; } = 3f;
        [field: SerializeField] public float RampWidthMax { get; set; } = 8f;
        [field: SerializeField] public float RampAngleMin { get; set; } = 10f;
        [field: SerializeField] public float RampAngleMax { get; set; } = 35f;
        [field: SerializeField] public float RampYOffset { get; set; } = -1f;

        [Header("Generation Parameters")]
        [field: SerializeField] public int Seed { get; set; } = 12345;

        [Header("Corridor Layout")]
        [field: SerializeField] public Transform ConvergencePoint { get; private set; }
        [field: SerializeField] public Transform EndpointA { get; private set; }
        [field: SerializeField] public Transform EndpointB { get; private set; }
        [field: SerializeField] public Transform EndpointC { get; private set; }

        [Header("Corridor Settings")]
        [field: SerializeField] public float CorridorWidth { get; set; } = 30f;
        [field: SerializeField] public float BuildingSetback { get; set; } = 2f;
        [field: SerializeField] public float BuildingSpacing { get; set; } = 15f;
        [field: SerializeField] public float ConvergenceRadius { get; set; } = 50f;
        [field: SerializeField, Range(1, 10)] public int BuildingRows { get; set; } = 1;
        [field: SerializeField] public bool EnablePlazaRing { get; set; } = true;
        [field: SerializeField, Range(1, 3)] public int PlazaRingRows { get; set; } = 1;

        [Header("Corridor Curve")]
        [field: SerializeField] public float CorridorNoiseAmplitude { get; set; } = 20f;
        [field: SerializeField] public float CorridorNoiseFrequency { get; set; } = 0.02f;

        [Header("Building Heights")]
        [field: SerializeField] public float BuildingHeightMin { get; set; } = 20f;
        [field: SerializeField] public float BuildingHeightMax { get; set; } = 80f;
        [field: SerializeField] public float BuildingWidthMin { get; set; } = 8f;
        [field: SerializeField] public float BuildingWidthMax { get; set; } = 15f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowBounds { get; set; } = true;
        [field: SerializeField] public bool AutoGenerateOnStart { get; set; } = true;
        [field: SerializeField] public bool AutoGenerateInEditor { get; set; } = false;

        // Serialized generated data (persists through play mode)
        [SerializeField, HideInInspector]
        private List<BuildingData> _generatedBuildings = new List<BuildingData>();

        [SerializeField, HideInInspector]
        private List<RampData> _generatedRamps = new List<RampData>();

        // Cached corridor paths for gizmo visualization
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathA = new List<Vector3>();
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathB = new List<Vector3>();
        [SerializeField, HideInInspector]
        private List<Vector3> _corridorPathC = new List<Vector3>();

        // Runtime GPU buffers (recreated from serialized data as needed)
        private GraphicsBuffer _buildingBuffer;
        private GraphicsBuffer _argsBuffer;

        // Ramp GPU buffers
        private GraphicsBuffer _rampBuffer;
        private GraphicsBuffer _rampArgsBuffer;
        private MaterialPropertyBlock _rampPropertyBlock;
        private bool _rampBuffersInitialized;

        // Render state
        private Bounds _renderBounds;
        private MaterialPropertyBlock _propertyBlock;
        private bool _buffersInitialized;

        // Random number generator for deterministic generation
        private System.Random _random;

        public int ActualBuildingCount => _generatedBuildings.Count;
        public int ActualRampCount => _generatedRamps.Count;
        public bool HasData => _generatedBuildings.Count > 0;
        public bool HasRampData => _generatedRamps.Count > 0;
        public bool IsGenerated => HasData;
        public IReadOnlyList<BuildingData> Buildings => _generatedBuildings;
        public IReadOnlyList<RampData> Ramps => _generatedRamps;

        public bool HasValidCorridorSetup =>
            ConvergencePoint != null &&
            EndpointA != null &&
            EndpointB != null &&
            EndpointC != null;

        private void OnEnable()
        {
            // Recreate GPU buffers from serialized data if we have it
            if (HasData && !_buffersInitialized)
            {
                InitializeBuffersFromSerializedData();
            }
            if (HasRampData && !_rampBuffersInitialized)
            {
                InitializeRampBuffersFromSerializedData();
            }
        }

        private void Start()
        {
            if (AutoGenerateOnStart && Application.isPlaying && !HasData)
            {
                Generate();
            }
        }

        private void Update()
        {
            // Ensure buffers exist if we have data
            if (HasData && !_buffersInitialized)
            {
                InitializeBuffersFromSerializedData();
            }

            if (HasRampData && !_rampBuffersInitialized)
            {
                InitializeRampBuffersFromSerializedData();
            }

            if (HasData && BuildingMesh != null && BuildingMaterial != null && _buffersInitialized)
            {
                RenderBuildings();
            }

            if (HasRampData && RampMesh != null && RampMaterial != null && _rampBuffersInitialized)
            {
                RenderRamps();
            }
        }

        [ContextMenu("Generate City")]
        public void Generate()
        {
            if (!HasValidCorridorSetup)
            {
                Debug.LogError("CityManager: Corridor transforms not assigned! Assign ConvergencePoint and all three Endpoints.");
                return;
            }

            if (BuildingMesh == null)
            {
                Debug.LogError("CityManager: Building mesh is not assigned!");
                return;
            }

            if (BuildingMaterial == null)
            {
                Debug.LogError("CityManager: Building material is not assigned!");
                return;
            }

            Clear();

            // Initialize random generator with seed
            _random = new System.Random(Seed);

            // Generate corridor paths
            var convergencePos = ConvergencePoint.position;
            _corridorPathA = GenerateCurvedPath(convergencePos, EndpointA.position, 0);
            _corridorPathB = GenerateCurvedPath(convergencePos, EndpointB.position, 1);
            _corridorPathC = GenerateCurvedPath(convergencePos, EndpointC.position, 2);

            // Collect all paths for overlap checking
            var allPaths = new List<List<Vector3>> { _corridorPathA, _corridorPathB, _corridorPathC };

            // Generate buildings along corridors (with overlap checking)
            GenerateCorridorBuildings(_corridorPathA, allPaths, 0);
            GenerateCorridorBuildings(_corridorPathB, allPaths, 1);
            GenerateCorridorBuildings(_corridorPathC, allPaths, 2);

            // Generate plaza ring around convergence point
            if (EnablePlazaRing)
            {
                GeneratePlazaRing(allPaths);
            }

            // Now initialize the rendering buffers from serialized data
            InitializeBuffersFromSerializedData();

            // Generate ramps if enabled
            if (EnableRamps)
            {
                if (RampMesh == null)
                {
                    Debug.LogWarning("CityManager: Ramps enabled but RampMesh is not assigned! Assign a cube mesh.");
                }
                if (RampMaterial == null)
                {
                    Debug.LogWarning("CityManager: Ramps enabled but RampMaterial is not assigned! Assign the RampMaterial from Assets/HolyRail/Materials/");
                }

                GenerateCorridorRamps(_corridorPathA);
                GenerateCorridorRamps(_corridorPathB);
                GenerateCorridorRamps(_corridorPathC);
                InitializeRampBuffersFromSerializedData();
            }

            var rampInfo = EnableRamps ? $", {_generatedRamps.Count} ramps" : "";
            Debug.Log($"CityManager: Generated {_generatedBuildings.Count} buildings across 3 corridors{rampInfo}");
        }

        private List<Vector3> GenerateCurvedPath(Vector3 start, Vector3 end, int corridorIndex)
        {
            var path = new List<Vector3>();
            var baseDirection = (end - start);
            baseDirection.y = 0; // Keep paths horizontal
            var distance = baseDirection.magnitude;
            baseDirection = baseDirection.normalized;

            var right = Vector3.Cross(Vector3.up, baseDirection).normalized;
            float noiseOffset = corridorIndex * 1000f; // Unique noise per corridor

            for (float d = 0; d <= distance; d += BuildingSpacing)
            {
                float t = d / distance;
                var basePoint = start + baseDirection * d;
                basePoint.y = start.y; // Maintain convergence point height

                // Perlin noise for organic curve (zero at endpoints for smooth connection)
                float envelope = Mathf.Sin(t * Mathf.PI); // 0 at start/end, 1 at middle
                float noise = (Mathf.PerlinNoise(d * CorridorNoiseFrequency + noiseOffset, 0f) * 2f - 1f);
                float offset = noise * CorridorNoiseAmplitude * envelope;

                path.Add(basePoint + right * offset);
            }

            // Ensure we include the endpoint
            if (path.Count > 0 && Vector3.Distance(path[path.Count - 1], end) > BuildingSpacing * 0.5f)
            {
                var endPoint = end;
                endPoint.y = start.y;
                path.Add(endPoint);
            }

            return path;
        }

        private void GenerateCorridorBuildings(List<Vector3> path, List<List<Vector3>> allPaths, int currentPathIndex)
        {
            var convergencePos = ConvergencePoint.position;

            for (int i = 0; i < path.Count; i++)
            {
                var point = path[i];

                // Skip buildings near convergence (open plaza)
                if (Vector3.Distance(point, convergencePos) < ConvergenceRadius)
                    continue;

                // Calculate tangent direction from path
                Vector3 tangent;
                if (i < path.Count - 1)
                    tangent = (path[i + 1] - point).normalized;
                else if (i > 0)
                    tangent = (point - path[i - 1]).normalized;
                else
                    continue; // Single point path, skip

                var right = Vector3.Cross(Vector3.up, tangent).normalized;

                // Place multiple rows of buildings on both sides
                float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                for (int row = 0; row < BuildingRows; row++)
                {
                    // Only innermost row (row 0) needs colliders
                    bool needsCollider = (row == 0);

                    float rowOffset = CorridorWidth / 2 + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                    // Check left side doesn't overlap with other corridors
                    var leftPos = point - right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(leftPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(leftPos, tangent, needsCollider);
                    }

                    // Check right side doesn't overlap with other corridors
                    var rightPos = point + right * rowOffset;
                    if (!IsPositionTooCloseToOtherCorridors(rightPos, allPaths, currentPathIndex))
                    {
                        PlaceBuilding(rightPos, tangent, needsCollider);
                    }
                }
            }
        }

        private bool IsPositionTooCloseToOtherCorridors(Vector3 position, List<List<Vector3>> allPaths, int excludePathIndex)
        {
            // Minimum distance from another corridor's center to place a building
            float minDistance = CorridorWidth / 2 + BuildingSetback;

            for (int pathIndex = 0; pathIndex < allPaths.Count; pathIndex++)
            {
                if (pathIndex == excludePathIndex)
                    continue;

                var otherPath = allPaths[pathIndex];
                float distToPath = GetDistanceToPath(position, otherPath);

                if (distToPath < minDistance)
                    return true;
            }

            return false;
        }

        private float GetDistanceToPath(Vector3 position, List<Vector3> path)
        {
            float minDist = float.MaxValue;

            for (int i = 0; i < path.Count - 1; i++)
            {
                float dist = DistanceToLineSegment(position, path[i], path[i + 1]);
                minDist = Mathf.Min(minDist, dist);
            }

            return minDist;
        }

        private float DistanceToLineSegment(Vector3 point, Vector3 lineStart, Vector3 lineEnd)
        {
            // Project point onto line segment (in XZ plane)
            var line = lineEnd - lineStart;
            line.y = 0;
            var toPoint = point - lineStart;
            toPoint.y = 0;

            float lineLengthSq = line.sqrMagnitude;
            if (lineLengthSq < 0.0001f)
                return toPoint.magnitude;

            float t = Mathf.Clamp01(Vector3.Dot(toPoint, line) / lineLengthSq);
            var closest = lineStart + line * t;
            closest.y = point.y;

            return Vector3.Distance(new Vector3(point.x, 0, point.z), new Vector3(closest.x, 0, closest.z));
        }

        private void GeneratePlazaRing(List<List<Vector3>> allPaths)
        {
            var convergencePos = ConvergencePoint.position;
            float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;

            // Calculate angular positions of corridor exits to leave gaps
            var corridorAngles = new List<float>();
            foreach (var path in allPaths)
            {
                if (path.Count >= 2)
                {
                    // Get direction from convergence toward corridor (use second point to get direction)
                    var dir = path[1] - convergencePos;
                    dir.y = 0;
                    float angle = Mathf.Atan2(dir.x, dir.z);
                    corridorAngles.Add(angle);
                }
            }

            // Place buildings in a ring, skipping corridor exits
            float circumference = 2 * Mathf.PI * ConvergenceRadius;
            int buildingCount = Mathf.FloorToInt(circumference / (avgBuildingWidth + BuildingSetback));
            float angleStep = 2 * Mathf.PI / buildingCount;

            // Half-width of corridor gap in radians
            float corridorGapAngle = Mathf.Atan2(CorridorWidth / 2 + BuildingSetback, ConvergenceRadius);

            for (int row = 0; row < PlazaRingRows; row++)
            {
                float ringRadius = ConvergenceRadius + BuildingSetback + row * (avgBuildingWidth + BuildingSetback);

                for (int i = 0; i < buildingCount; i++)
                {
                    float angle = i * angleStep;

                    // Check if this angle is within a corridor exit gap
                    bool inCorridorGap = false;
                    foreach (float corridorAngle in corridorAngles)
                    {
                        float angleDiff = Mathf.Abs(Mathf.DeltaAngle(angle * Mathf.Rad2Deg, corridorAngle * Mathf.Rad2Deg)) * Mathf.Deg2Rad;
                        if (angleDiff < corridorGapAngle)
                        {
                            inCorridorGap = true;
                            break;
                        }
                    }

                    if (inCorridorGap)
                        continue;

                    // Place building facing inward toward plaza center (no collider needed for plaza ring)
                    var pos = convergencePos + new Vector3(Mathf.Sin(angle), 0, Mathf.Cos(angle)) * ringRadius;
                    var facingDir = (convergencePos - pos).normalized;
                    PlaceBuilding(pos, facingDir, needsCollider: false);
                }
            }
        }

        private void PlaceBuilding(Vector3 position, Vector3 corridorDirection, bool needsCollider = true)
        {
            // Random height and width
            float height = RandomRange(BuildingHeightMin, BuildingHeightMax);
            float width = RandomRange(BuildingWidthMin, BuildingWidthMax);

            // Rotation: face perpendicular to corridor (so building faces into corridor)
            // Add some random variation (0, 90, 180, or 270 degrees offset for variety)
            float baseAngle = Mathf.Atan2(corridorDirection.x, corridorDirection.z) * Mathf.Rad2Deg;
            int rotationVariation = _random.Next(0, 4) * 90;
            var rotation = Quaternion.Euler(0, baseAngle + rotationVariation, 0);

            // Style variation
            int styleIndex = _random.Next(0, 8);

            var building = new BuildingData
            {
                Position = new Vector3(position.x, position.y + height * 0.5f, position.z),
                Scale = new Vector3(width, height, width),
                Rotation = rotation,
                NeedsCollider = needsCollider ? 1 : 0,
                StyleIndex = styleIndex
            };

            _generatedBuildings.Add(building);
        }

        private void GenerateCorridorRamps(List<Vector3> path)
        {
            if (path.Count < 2)
                return;

            var convergencePos = ConvergencePoint.position;

            // Calculate total path length for ramp distribution
            float totalLength = 0f;
            for (int i = 1; i < path.Count; i++)
            {
                totalLength += Vector3.Distance(path[i], path[i - 1]);
            }

            // Distribute ramps evenly along this corridor (1/3 of total ramps per corridor)
            int rampsPerCorridor = Mathf.Max(1, RampCount / 3);
            float rampSpacing = totalLength / (rampsPerCorridor + 1);

            float accumulatedDistance = rampSpacing; // Start offset from convergence
            int pathIndex = 0;
            float segmentProgress = 0f;

            for (int rampNum = 0; rampNum < rampsPerCorridor && pathIndex < path.Count - 1; rampNum++)
            {
                // Find the point along the path at this distance
                while (pathIndex < path.Count - 1)
                {
                    float segmentLength = Vector3.Distance(path[pathIndex], path[pathIndex + 1]);
                    float remaining = segmentLength - segmentProgress;

                    if (accumulatedDistance <= remaining)
                    {
                        // Ramp position is within this segment
                        float t = (segmentProgress + accumulatedDistance) / segmentLength;
                        var rampPos = Vector3.Lerp(path[pathIndex], path[pathIndex + 1], t);

                        // Skip if too close to convergence
                        if (Vector3.Distance(rampPos, convergencePos) < ConvergenceRadius)
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                            continue;
                        }

                        // Calculate tangent at this point
                        var tangent = (path[pathIndex + 1] - path[pathIndex]).normalized;

                        // Try to place ramp
                        if (TryPlaceRamp(rampPos, tangent))
                        {
                            accumulatedDistance = rampSpacing;
                            segmentProgress += accumulatedDistance;
                        }
                        else
                        {
                            // Skip this position, try next
                            accumulatedDistance = rampSpacing * 0.5f;
                            segmentProgress += accumulatedDistance;
                        }
                        break;
                    }
                    else
                    {
                        // Move to next segment
                        accumulatedDistance -= remaining;
                        segmentProgress = 0f;
                        pathIndex++;
                    }
                }
            }
        }

        private bool TryPlaceRamp(Vector3 position, Vector3 direction)
        {
            // Random dimensions
            float length = RandomRange(RampLengthMin, RampLengthMax);
            float width = RandomRange(RampWidthMin, RampWidthMax);
            float angle = RandomRange(RampAngleMin, RampAngleMax);
            float depth = 0.5f; // Thickness of the ramp

            // Calculate vertical rise based on angle and length
            float angleRad = angle * Mathf.Deg2Rad;
            float rampRun = length * Mathf.Cos(angleRad);

            // Ramp faces along corridor direction
            float yaw = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
            var finalRotation = Quaternion.Euler(-angle, yaw, 0f);

            // Position Y: Place ramp so back-bottom edge sits flush with ground
            float yOffset = (depth * 0.5f * Mathf.Cos(angleRad)) + (length * 0.5f * Mathf.Sin(angleRad));
            yOffset += RampYOffset;

            var rampPosition = new Vector3(position.x, position.y + yOffset, position.z);

            // Create bounds for collision checks
            float rampPadding = 1.5f;
            var rampMin = new Vector3(
                rampPosition.x - width * 0.5f - rampPadding,
                0f,
                rampPosition.z - rampRun * 0.5f - rampPadding
            );
            var rampMax = new Vector3(
                rampPosition.x + width * 0.5f + rampPadding,
                10f,
                rampPosition.z + rampRun * 0.5f + rampPadding
            );

            // Check if ramp intersects any buildings
            foreach (var building in _generatedBuildings)
            {
                var buildingMin = new Vector3(
                    building.Position.x - building.Scale.x * 0.5f,
                    0f,
                    building.Position.z - building.Scale.z * 0.5f
                );
                var buildingMax = new Vector3(
                    building.Position.x + building.Scale.x * 0.5f,
                    building.Position.y + building.Scale.y * 0.5f,
                    building.Position.z + building.Scale.z * 0.5f
                );

                if (rampMin.x < buildingMax.x && rampMax.x > buildingMin.x &&
                    rampMin.z < buildingMax.z && rampMax.z > buildingMin.z)
                {
                    return false;
                }
            }

            // Check if ramp intersects any existing ramps
            foreach (var existingRamp in _generatedRamps)
            {
                float existingAngleRad = existingRamp.Angle * Mathf.Deg2Rad;
                float existingRun = existingRamp.Scale.z * Mathf.Cos(existingAngleRad);
                float existingWidth = existingRamp.Scale.x;

                var existingMin = new Vector3(
                    existingRamp.Position.x - existingWidth * 0.5f - rampPadding,
                    0f,
                    existingRamp.Position.z - existingRun * 0.5f - rampPadding
                );
                var existingMax = new Vector3(
                    existingRamp.Position.x + existingWidth * 0.5f + rampPadding,
                    10f,
                    existingRamp.Position.z + existingRun * 0.5f + rampPadding
                );

                if (rampMin.x < existingMax.x && rampMax.x > existingMin.x &&
                    rampMin.z < existingMax.z && rampMax.z > existingMin.z)
                {
                    return false;
                }
            }

            var ramp = new RampData
            {
                Position = rampPosition,
                Scale = new Vector3(width, depth, length),
                Rotation = finalRotation,
                Angle = angle
            };

            _generatedRamps.Add(ramp);
            return true;
        }

        private float RandomRange(float min, float max)
        {
            return min + (float)_random.NextDouble() * (max - min);
        }

        private void InitializeBuffersFromSerializedData()
        {
            if (_generatedBuildings.Count == 0)
                return;

            if (BuildingMesh == null || BuildingMaterial == null)
                return;

            // Release any existing buffers
            ReleaseBuffers();

            int buildingStride = Marshal.SizeOf<BuildingData>();

            // Create and populate building buffer from serialized data
            _buildingBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, _generatedBuildings.Count, buildingStride);
            _buildingBuffer.SetData(_generatedBuildings.ToArray());

            // Create indirect args buffer for RenderMeshIndirect
            // Args: [indexCount, instanceCount, startIndex, baseVertex, startInstance]
            _argsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, 5 * sizeof(uint));
            uint[] args = new uint[]
            {
                BuildingMesh.GetIndexCount(0),
                (uint)_generatedBuildings.Count,
                BuildingMesh.GetIndexStart(0),
                BuildingMesh.GetBaseVertex(0),
                0
            };
            _argsBuffer.SetData(args);

            // Calculate render bounds based on all corridor endpoints
            float maxExtent = 0f;
            if (HasValidCorridorSetup)
            {
                var convergencePos = ConvergencePoint.position;
                maxExtent = Mathf.Max(maxExtent, Vector3.Distance(convergencePos, EndpointA.position));
                maxExtent = Mathf.Max(maxExtent, Vector3.Distance(convergencePos, EndpointB.position));
                maxExtent = Mathf.Max(maxExtent, Vector3.Distance(convergencePos, EndpointC.position));
            }
            maxExtent = Mathf.Max(maxExtent, 500f); // Minimum bounds

            _renderBounds = new Bounds(
                transform.position + Vector3.up * BuildingHeightMax * 0.5f,
                new Vector3(maxExtent * 2 + 100f, BuildingHeightMax + 100f, maxExtent * 2 + 100f)
            );

            // Create property block for material
            _propertyBlock = new MaterialPropertyBlock();
            _propertyBlock.SetBuffer("_BuildingBuffer", _buildingBuffer);

            _buffersInitialized = true;
        }

        private void RenderBuildings()
        {
            if (_argsBuffer == null || _propertyBlock == null)
                return;

            // Update material buffer reference
            _propertyBlock.SetBuffer("_BuildingBuffer", _buildingBuffer);

            var renderParams = new RenderParams(BuildingMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _propertyBlock,
                shadowCastingMode = ShadowCastingMode.On,
                receiveShadows = true
            };

            Graphics.RenderMeshIndirect(renderParams, BuildingMesh, _argsBuffer);
        }

        private void InitializeRampBuffersFromSerializedData()
        {
            if (_generatedRamps.Count == 0)
            {
                Debug.Log("CityManager: No ramps to initialize buffers for.");
                return;
            }

            if (RampMesh == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize ramp buffers - RampMesh is null. Assign a cube mesh.");
                return;
            }

            if (RampMaterial == null)
            {
                Debug.LogWarning("CityManager: Cannot initialize ramp buffers - RampMaterial is null. Assign RampMaterial from Assets/HolyRail/Materials/");
                return;
            }

            Debug.Log($"CityManager: Initializing ramp buffers for {_generatedRamps.Count} ramps...");

            // Release any existing ramp buffers
            ReleaseRampBuffers();

            int rampStride = Marshal.SizeOf<RampData>();

            // Create and populate ramp buffer from serialized data
            _rampBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, _generatedRamps.Count, rampStride);
            _rampBuffer.SetData(_generatedRamps.ToArray());

            // Create indirect args buffer for RenderMeshIndirect
            _rampArgsBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, 5 * sizeof(uint));
            uint[] args = new uint[]
            {
                RampMesh.GetIndexCount(0),
                (uint)_generatedRamps.Count,
                RampMesh.GetIndexStart(0),
                RampMesh.GetBaseVertex(0),
                0
            };
            _rampArgsBuffer.SetData(args);

            // Create property block for ramp material
            _rampPropertyBlock = new MaterialPropertyBlock();
            _rampPropertyBlock.SetBuffer("_RampBuffer", _rampBuffer);

            _rampBuffersInitialized = true;
            Debug.Log($"CityManager: Ramp buffers initialized successfully. Mesh: {RampMesh.name}, Material: {RampMaterial.name}");
        }

        private void RenderRamps()
        {
            if (_rampArgsBuffer == null || _rampPropertyBlock == null)
                return;

            // Update material buffer reference
            _rampPropertyBlock.SetBuffer("_RampBuffer", _rampBuffer);

            var renderParams = new RenderParams(RampMaterial)
            {
                worldBounds = _renderBounds,
                matProps = _rampPropertyBlock,
                shadowCastingMode = ShadowCastingMode.On,
                receiveShadows = true
            };

            Graphics.RenderMeshIndirect(renderParams, RampMesh, _rampArgsBuffer);
        }

        private void ReleaseRampBuffers()
        {
            _rampBuffer?.Release();
            _rampArgsBuffer?.Release();

            _rampBuffer = null;
            _rampArgsBuffer = null;

            _rampBuffersInitialized = false;
        }

        private void ReleaseBuffers()
        {
            _buildingBuffer?.Release();
            _argsBuffer?.Release();

            _buildingBuffer = null;
            _argsBuffer = null;

            _buffersInitialized = false;
        }

        [ContextMenu("Clear")]
        public void Clear()
        {
            ReleaseBuffers();
            ReleaseRampBuffers();
            _generatedBuildings.Clear();
            _generatedRamps.Clear();
            _corridorPathA.Clear();
            _corridorPathB.Clear();
            _corridorPathC.Clear();

            // Find and clear any BuildingColliderPools that reference this CityManager
            var colliderPools = FindObjectsByType<BuildingColliderPool>(FindObjectsSortMode.None);
            foreach (var pool in colliderPools)
            {
                if (pool.CityManager == this)
                {
                    pool.Clear();
                }
            }
        }

        private void OnDisable()
        {
            // Only release GPU buffers, keep serialized data for persistence
            ReleaseBuffers();
            ReleaseRampBuffers();
        }

        private void OnDestroy()
        {
            ReleaseBuffers();
            ReleaseRampBuffers();
        }

        private void OnValidate()
        {
            // Auto-regenerate in editor when properties change
            if (AutoGenerateInEditor && !Application.isPlaying && HasValidCorridorSetup)
            {
                // Delay the generation to avoid issues during serialization
                #if UNITY_EDITOR
                UnityEditor.EditorApplication.delayCall += () =>
                {
                    if (this != null && AutoGenerateInEditor && !Application.isPlaying)
                    {
                        Generate();
                    }
                };
                #endif
            }
        }

        private void OnDrawGizmosSelected()
        {
            if (!ShowBounds)
                return;

            // Draw convergence point and radius
            if (ConvergencePoint != null)
            {
                // Inner plaza radius (open area)
                Gizmos.color = new Color(1f, 0.8f, 0f, 0.8f);
                Gizmos.DrawWireSphere(ConvergencePoint.position, ConvergenceRadius);
                Gizmos.color = new Color(1f, 0.8f, 0f, 0.3f);
                Gizmos.DrawSphere(ConvergencePoint.position, 5f);

                // Plaza ring outer edge (if enabled)
                if (EnablePlazaRing)
                {
                    float avgBuildingWidth = (BuildingWidthMin + BuildingWidthMax) * 0.5f;
                    float outerRingRadius = ConvergenceRadius + BuildingSetback + (PlazaRingRows - 1) * (avgBuildingWidth + BuildingSetback) + avgBuildingWidth;
                    Gizmos.color = new Color(1f, 0.5f, 0f, 0.5f);
                    Gizmos.DrawWireSphere(ConvergencePoint.position, outerRingRadius);
                }
            }

            // Draw endpoints
            Gizmos.color = new Color(0f, 1f, 0.5f, 0.8f);
            if (EndpointA != null)
            {
                Gizmos.DrawSphere(EndpointA.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointA.position);
            }
            if (EndpointB != null)
            {
                Gizmos.DrawSphere(EndpointB.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointB.position);
            }
            if (EndpointC != null)
            {
                Gizmos.DrawSphere(EndpointC.position, 3f);
                if (ConvergencePoint != null)
                    Gizmos.DrawLine(ConvergencePoint.position, EndpointC.position);
            }

            // Draw generated corridor paths with width
            Gizmos.color = new Color(0.2f, 0.6f, 1f, 0.5f);
            DrawCorridorPath(_corridorPathA);
            DrawCorridorPath(_corridorPathB);
            DrawCorridorPath(_corridorPathC);
        }

        private void DrawCorridorPath(List<Vector3> path)
        {
            if (path == null || path.Count < 2)
                return;

            for (int i = 0; i < path.Count - 1; i++)
            {
                var current = path[i];
                var next = path[i + 1];

                // Draw center line
                Gizmos.DrawLine(current + Vector3.up * 2f, next + Vector3.up * 2f);

                // Draw corridor width
                var direction = (next - current).normalized;
                var right = Vector3.Cross(Vector3.up, direction).normalized;
                float halfWidth = CorridorWidth * 0.5f;

                Gizmos.DrawLine(current + right * halfWidth + Vector3.up, next + right * halfWidth + Vector3.up);
                Gizmos.DrawLine(current - right * halfWidth + Vector3.up, next - right * halfWidth + Vector3.up);
            }
        }
    }
}
