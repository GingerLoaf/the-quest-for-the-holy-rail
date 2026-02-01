using UnityEngine;
using UnityEditor;
using HolyRail.Vines;

namespace HolyRail.Vines.Editor
{
    [CustomEditor(typeof(VineGenerator))]
    public class VineGeneratorEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;

        public override void OnInspectorGUI()
        {
            var generator = (VineGenerator)target;
            serializedObject.Update();

            EditorGUI.BeginChangeCheck();

            // Editor settings
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AutoRegenerate>k__BackingField"));

            // Algorithm Settings
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<VineComputeShader>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<Seed>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MaxIterations>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<StepSize>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractionRadius>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<KillRadius>k__BackingField"));

            // Attractor Generation - always show mode selector
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Attractor Generation", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorGenerationMode>k__BackingField"));

            // Conditionally show settings based on mode
            if (generator.AttractorGenerationMode == AttractorMode.Free)
            {
                // Free Mode Settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Free Mode Settings", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeSplineCount>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeLengthRange>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreePointsPerSpline>k__BackingField"));

                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Noise (Right, Up, Forward)", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseAmplitude>k__BackingField"), new GUIContent("Amplitude"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseFrequency>k__BackingField"), new GUIContent("Frequency"));
            }
            else if (generator.AttractorGenerationMode == AttractorMode.Path)
            {
                // Path Mode Settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Path Mode Settings", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<CityManager>k__BackingField"));

                // Show corridor status if CityManager is assigned
                if (generator.CityManager != null)
                {
                    EditorGUI.indentLevel++;
                    string corridorStatus = "";
                    if (generator.CityManager.EnableCorridorA) corridorStatus += "A ";
                    if (generator.CityManager.EnableCorridorB) corridorStatus += "B ";
                    if (generator.CityManager.EnableCorridorC) corridorStatus += "C ";
                    if (string.IsNullOrEmpty(corridorStatus)) corridorStatus = "None";

                    EditorGUILayout.LabelField("Enabled Corridors:", corridorStatus.Trim());
                    EditorGUILayout.LabelField("Mode:", "Volume-based (scattered segments)");
                    EditorGUI.indentLevel--;
                }

                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<VinesPerCorridor>k__BackingField"),
                    new GUIContent("Total Vines", "Number of vine segments to scatter in the volume")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<PathLengthRange>k__BackingField"),
                    new GUIContent("Vine Length Range", "Min/max length of each vine segment")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<PathCorridorWidth>k__BackingField"),
                    new GUIContent("Volume Width", "Lateral extent of spawn volume")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<VolumeHeightRange>k__BackingField"),
                    new GUIContent("Volume Height", "Min/max Y height for vine spawning")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<MinVineSpacing>k__BackingField"),
                    new GUIContent("Min Spacing", "Minimum distance between vine start points (tune for jumpable gaps)")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<GroundVineRatio>k__BackingField"),
                    new GUIContent("Ground Vine Ratio", "Ratio of vines that start at ground and go up (for recovery when falling)")
                );

                // Attraction
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Attraction", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardAttractionStrength>k__BackingField"),
                    new GUIContent("Billboard Attraction", "Strength of vine attraction toward billboards (0=random, 1=fully attracted)")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<GraffitiAttractionStrength>k__BackingField"),
                    new GUIContent("Graffiti Attraction", "Strength of vine attraction toward graffiti spots (0=random, 1=fully attracted)")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<AttractorSearchRadius>k__BackingField"),
                    new GUIContent("Search Radius", "Maximum distance to search for attractor connections")
                );

                // Ground settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Ground Settings", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<StartBelowGround>k__BackingField"));
                if (generator.StartBelowGround)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(serializedObject.FindProperty("<GroundStartDepth>k__BackingField"));
                    EditorGUI.indentLevel--;
                }
                // Ground Avoidance
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Ground Avoidance", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<EnableGroundAvoidance>k__BackingField"),
                    new GUIContent("Enable", "Raycast to detect ground and keep vines above it")
                );
                if (generator.EnableGroundAvoidance)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<GroundLayers>k__BackingField"),
                        new GUIContent("Ground Layers", "Physics layers to detect as ground (auto-detects 'Ground' or 'Default' if not set)")
                    );
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<MinHeightAboveGround>k__BackingField"),
                        new GUIContent("Min Height Above Ground", "Minimum distance vines stay above detected ground")
                    );
                    EditorGUI.indentLevel--;
                }

                // Ramp Avoidance
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Ramp Avoidance", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<EnableRampAvoidance>k__BackingField"),
                    new GUIContent("Enable", "Push vines away from spawned ramps")
                );
                if (generator.EnableRampAvoidance)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<RampAvoidanceDistance>k__BackingField"),
                        new GUIContent("Avoidance Distance", "How far vines stay from ramps")
                    );
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<RampLayers>k__BackingField"),
                        new GUIContent("Ramp Layers", "Physics layers to check for ramp colliders (manual or generated)")
                    );
                    if (generator.CityManager != null && generator.CityManager.HasRampData)
                    {
                        EditorGUILayout.HelpBox($"CityManager has {generator.CityManager.Ramps.Count} ramps", MessageType.Info);
                    }
                    else
                    {
                        EditorGUILayout.HelpBox("No ramp data available. Generate city first.", MessageType.Warning);
                    }
                    EditorGUI.indentLevel--;
                }

                // Reuse Free mode noise settings for undulation
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Undulation", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreePointsPerSpline>k__BackingField"), new GUIContent("Points Per Vine"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseAmplitude>k__BackingField"), new GUIContent("Amplitude"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseFrequency>k__BackingField"), new GUIContent("Frequency"));

                // Level Chunk Influence
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Level Chunk Influence", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<LevelChunkInfluence>k__BackingField"),
                    new GUIContent("Influence", "Blend toward level chunk spline characteristics (0=current, 1=chunk-like)")
                );
                if (generator.LevelChunkInfluence > 0.01f)
                {
                    EditorGUILayout.HelpBox(
                        $"Blending toward level chunk ranges:\n" +
                        $"  Height: {LevelChunkRules.HeightVariationMin:F1}-{LevelChunkRules.HeightVariationMax:F1}m\n" +
                        $"  Lateral: {LevelChunkRules.LateralSpanMin:F1}-{LevelChunkRules.LateralSpanMax:F1}m\n" +
                        $"  Frequency: {LevelChunkRules.FrequencyMin:F2}-{LevelChunkRules.FrequencyMax:F2} (smoother curves)",
                        MessageType.Info
                    );
                }

                // Billboard Vines
                EditorGUILayout.Space();
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<PathEnableBillboardVines>k__BackingField"),
                    new GUIContent("Enable Billboard Vines", "Also generate sagging cable vines connecting billboards")
                );

                // Direction Bias
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Direction Bias", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BiasDirection>k__BackingField"),
                    new GUIContent("Bias Direction", "Direction to bias vine growth toward")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BiasStrength>k__BackingField"),
                    new GUIContent("Bias Strength", "How strongly vines are pushed in the bias direction (0-1)")
                );

                // Rail Connectivity
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Rail Connectivity", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("_enableRailBridges"),
                    new GUIContent("Enable Rail Bridges", "Connect nearby rail endpoints with bridge splines")
                );
                if (generator.EnableRailBridges)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("_bridgeMaxDistance"),
                        new GUIContent("Max Bridge Distance", "Maximum gap to bridge between endpoints")
                    );
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("_bridgeMinDistance"),
                        new GUIContent("Min Bridge Distance", "Minimum gap (avoid overlapping geometry)")
                    );
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("_stitchDistance"),
                        new GUIContent("Stitch Distance", "Endpoints closer than this get a simple straight stitch")
                    );
                    EditorGUI.indentLevel--;
                }
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("_enableConnectorRails"),
                    new GUIContent("Enable Connector Rails", "Create rails to unreachable objectives")
                );

            }
            else if (generator.AttractorGenerationMode == AttractorMode.Billboard)
            {
                // Billboard Mode Settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Billboard Mode Settings", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<CityManager>k__BackingField"));

                // Show billboard status if CityManager is assigned
                if (generator.CityManager != null && generator.CityManager.HasBillboardData)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.LabelField("Billboards:", generator.CityManager.Billboards.Count.ToString());
                    EditorGUI.indentLevel--;
                }

                // Billboard Connection Settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Connection Settings", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardMaxConnectionDistance>k__BackingField"),
                    new GUIContent("Max Connection Distance", "Maximum distance between billboards to connect")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardSameSideOnly>k__BackingField"),
                    new GUIContent("Same Side Only", "Only connect billboards on the same wall")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardInwardOffset>k__BackingField"),
                    new GUIContent("Inward Offset", "How far vines are offset from billboard surface")
                );

                // Sag/Shape Settings
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Vine Shape", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardSagAmount>k__BackingField"),
                    new GUIContent("Sag Amount", "How much vines droop in the middle")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BillboardPointsPerSpline>k__BackingField"),
                    new GUIContent("Points Per Vine", "Resolution of each vine segment")
                );

                // Building Avoidance
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Building Avoidance", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<EnableBuildingAvoidance>k__BackingField"),
                    new GUIContent("Enable", "Push vines away from buildings")
                );
                if (generator.EnableBuildingAvoidance)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<BuildingAvoidanceDistance>k__BackingField"),
                        new GUIContent("Avoidance Distance", "How far vines stay from building surfaces")
                    );
                    EditorGUI.indentLevel--;
                }

                // Billboard Avoidance (for vines not clipping through the billboards themselves)
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Billboard Avoidance", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<EnableBillboardAvoidance>k__BackingField"),
                    new GUIContent("Enable", "Push vines away from billboard surfaces")
                );
                if (generator.EnableBillboardAvoidance)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<BillboardAvoidanceDistance>k__BackingField"),
                        new GUIContent("Avoidance Distance", "How far vines stay from billboard surfaces")
                    );
                    EditorGUI.indentLevel--;
                }
            }
            else
            {
                // Attractor-based settings
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorCount>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorSurfaceLayers>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorBounds>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorSurfaceOffset>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<UseMultiDirectionRaycasts>k__BackingField"));

                // Root Points
                EditorGUILayout.Space();
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<RootPoints>k__BackingField"));

                // Trunk Settings (Volume Mode only)
                if (generator.AttractorGenerationMode == AttractorMode.Volume)
                {
                    EditorGUILayout.Space();
                    EditorGUILayout.LabelField("Trunk Settings", EditorStyles.boldLabel);
                    var trunkHeightProp = serializedObject.FindProperty("<TrunkHeight>k__BackingField");
                    if (trunkHeightProp != null)
                    {
                        EditorGUILayout.PropertyField(
                            trunkHeightProp,
                            new GUIContent("Trunk Height", "Height of the trunk before branches start growing. Set to 0 to disable trunk.")
                        );
                    }
                    else
                    {
                        EditorGUILayout.HelpBox("TrunkHeight property not found", MessageType.Error);
                    }

                    // Rail Connectivity for Volume mode
                    EditorGUILayout.Space();
                    EditorGUILayout.LabelField("Rail Connectivity", EditorStyles.boldLabel);
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("_enableRailBridges"),
                        new GUIContent("Enable Rail Bridges", "Connect nearby rail endpoints with bridge splines")
                    );
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("_enableConnectorRails"),
                        new GUIContent("Enable Connector Rails", "Create rails to unreachable objectives")
                    );
                }

                // Noise
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Noise", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<NoiseStrength>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<NoiseScale>k__BackingField"));

                // Branching
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Branching", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<BranchDensity>k__BackingField"));

                // Branch Separation
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinBranchSeparation>k__BackingField"));
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<MinBranchSpreadAngle>k__BackingField"),
                    new GUIContent("Min Branch Spread Angle", "Minimum angle in degrees between sibling branches")
                );
            }

            // Obstacle Avoidance - shown for all modes
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Obstacle Avoidance", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<EnableObstacleAvoidance>k__BackingField"));

            if (generator.EnableObstacleAvoidance)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<ObstacleAvoidanceDistance>k__BackingField"));
                EditorGUI.indentLevel--;
            }

            // Direction Bias - shown for attractor-based modes and Free mode (Path mode has its own section, Billboard mode doesn't use it)
            if (generator.AttractorGenerationMode != AttractorMode.Path && generator.AttractorGenerationMode != AttractorMode.Billboard)
            {
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Direction Bias", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BiasDirection>k__BackingField"),
                    new GUIContent("Bias Direction", "Direction to bias vine growth toward")
                );
                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<BiasStrength>k__BackingField"),
                    new GUIContent("Bias Strength", "How strongly vines are pushed in the bias direction (0-1)")
                );
            }

            // AttractorBounds is needed for Free mode too (defines generation volume)
            if (generator.AttractorGenerationMode == AttractorMode.Free)
            {
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Generation Volume", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorBounds>k__BackingField"));
            }

            // Visualization
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Visualization", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ShowAttractors>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ShowNodes>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ShowConnections>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<NodeColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ConnectionColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GizmoSize>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorGizmoSize>k__BackingField"));

            // Spline Conversion
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Spline Conversion", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinSplineLength>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MaxSplineCount>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinSplineWorldLength>k__BackingField"));

            // Path Smoothing
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Path Smoothing", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<EnablePathSmoothing>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<SmoothingTolerance>k__BackingField"));

            // Mesh Rendering
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Mesh Rendering", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<VineMaterial>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<VineRadius>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<VineSegments>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<VineSegmentsPerUnit>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GenerateMeshes>k__BackingField"));

            // Mesh Tapering (only shown when mesh generation is enabled)
            if (generator.GenerateMeshes)
            {
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Mesh Tapering", EditorStyles.boldLabel);

                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<EnableEndTapering>k__BackingField"),
                    new GUIContent("Enable End Tapering", "Taper branch endpoints to a point")
                );

                if (generator.EnableEndTapering)
                {
                    EditorGUI.indentLevel++;
                    EditorGUILayout.PropertyField(
                        serializedObject.FindProperty("<EndTaperDistance>k__BackingField"),
                        new GUIContent("Taper Distance", "Distance in meters from the end where tapering begins")
                    );
                    EditorGUI.indentLevel--;
                }

                EditorGUILayout.PropertyField(
                    serializedObject.FindProperty("<DistanceTaperStrength>k__BackingField"),
                    new GUIContent("Distance Taper", "How much branches thin based on distance from root (0=none, 1=full)")
                );

                if (generator.EnableEndTapering || generator.DistanceTaperStrength > 0f)
                {
                    EditorGUILayout.HelpBox(
                        "Tapering uses custom mesh generation instead of SplineExtrude.\n" +
                        "End Taper: Branch tips converge to a point.\n" +
                        "Distance Taper: Branches get thinner the further they are from the root.",
                        MessageType.Info
                    );
                }
            }

            // Pickup Spawning
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Pickup Spawning", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<PickUpPrefab>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<PickUpCount>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinPickUpSpacing>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<PickUpHeightOffset>k__BackingField"));

            // Glow Effects (always uses ScrollingGradient material)
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Glow Effects", EditorStyles.boldLabel);
            EditorGUILayout.HelpBox("Uses ScrollingGradient material automatically", MessageType.None);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GlowLength>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GlowBrightness>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GlowShowHideDuration>k__BackingField"));

            bool propertiesChanged = EditorGUI.EndChangeCheck();
            serializedObject.ApplyModifiedProperties();

            // Auto-regenerate if enabled and properties changed
            bool canAutoRegenerate = generator.AttractorGenerationMode == AttractorMode.Free
                || generator.AttractorGenerationMode == AttractorMode.Path
                || generator.AttractorGenerationMode == AttractorMode.Billboard
                || (generator.VineComputeShader != null && generator.RootPoints.Count > 0);

            if (propertiesChanged && generator.AutoRegenerate && canAutoRegenerate)
            {
                Undo.RecordObject(generator, "Auto Regenerate Vines");
                generator.Regenerate();
                EditorUtility.SetDirty(generator);
                SceneView.RepaintAll();
            }

            EditorGUILayout.Space(20);

            // Action Buttons Section
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("VINE GENERATION", headerStyle);

            EditorGUILayout.Space(10);

            // Regenerate Button (Green)
            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("REGENERATE VINES", GUILayout.Height(40)))
            {
                Undo.RecordObject(generator, "Regenerate Vines");
                generator.Regenerate();
                EditorUtility.SetDirty(generator);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.Space(5);

            // Convert to Splines Button (Blue) - disabled if no data
            EditorGUI.BeginDisabledGroup(!generator.HasData);
            GUI.backgroundColor = new Color(0.3f, 0.6f, 1f);
            if (GUILayout.Button("CONVERT TO SPLINES", GUILayout.Height(30)))
            {
                Undo.RecordObject(generator, "Convert Vines to Splines");
                generator.ConvertToSplines();
                EditorUtility.SetDirty(generator);
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(5);

            // Clear Button (Red) - disabled if no data
            EditorGUI.BeginDisabledGroup(!generator.HasData);
            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear Generated Data", GUILayout.Height(25)))
            {
                Undo.RecordObject(generator, "Clear Vine Data");
                generator.Clear();
                EditorUtility.SetDirty(generator);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();

            // Statistics Section
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            _showStatistics = EditorGUILayout.Foldout(_showStatistics, "GENERATION STATISTICS", true, headerStyle);

            if (_showStatistics)
            {
                EditorGUILayout.Space(5);

                if (!generator.HasData)
                {
                    EditorGUILayout.HelpBox("No vine data generated yet. Click 'REGENERATE VINES' to generate.", MessageType.Info);
                }
                else
                {
                    DrawStatistics(generator);
                }
            }

            EditorGUILayout.EndVertical();

            // Help Box - mode-specific
            EditorGUILayout.Space(10);
            if (generator.AttractorGenerationMode == AttractorMode.Free)
            {
                EditorGUILayout.HelpBox(
                    "Free Mode Setup:\n" +
                    "1. Set Direction Bias for spline travel direction\n" +
                    "2. Set AttractorBounds to define generation volume\n" +
                    "3. Adjust FreeSplineCount and spacing\n" +
                    "4. Configure undulation with variation ranges\n" +
                    "5. Click REGENERATE VINES\n" +
                    "6. Convert to splines for rail grinding",
                    MessageType.None);
            }
            else if (generator.AttractorGenerationMode == AttractorMode.Path)
            {
                EditorGUILayout.HelpBox(
                    "Path Mode (Volume-Based):\n" +
                    "1. Assign a CityManager to define the corridor bounds\n" +
                    "2. Set Total Vines for number of segments to scatter\n" +
                    "3. Set Vine Length Range (e.g., 10-20 for short rails)\n" +
                    "4. Adjust Volume Width for lateral spread\n" +
                    "5. Use Level Chunk Influence to match hand-crafted feel\n" +
                    "6. Click REGENERATE VINES\n" +
                    "7. Convert to splines for rail grinding",
                    MessageType.None);
            }
            else if (generator.AttractorGenerationMode == AttractorMode.Billboard)
            {
                EditorGUILayout.HelpBox(
                    "Billboard Mode:\n" +
                    "1. Assign a CityManager with billboard data\n" +
                    "2. Adjust Max Connection Distance for billboard linking\n" +
                    "3. Enable Same Side Only to restrict connections\n" +
                    "4. Configure Sag Amount for vine droop\n" +
                    "5. Enable Building/Billboard Avoidance as needed\n" +
                    "6. Click REGENERATE VINES\n" +
                    "7. Convert to splines for rail grinding",
                    MessageType.None);
            }
            else
            {
                EditorGUILayout.HelpBox(
                    "Setup:\n" +
                    "1. Assign the DeterministicVines compute shader\n" +
                    "2. Add root point Transform(s) where vines should start\n" +
                    "3. Set AttractorBounds to encompass the growth area\n" +
                    "4. Configure AttractorSurfaceLayers to target geometry\n" +
                    "5. Click REGENERATE VINES\n" +
                    "6. Convert to splines for rail grinding",
                    MessageType.None);
            }
        }

        private void DrawStatistics(VineGenerator generator)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Total Nodes:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.NodeCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            if (generator.AttractorGenerationMode != AttractorMode.Free && generator.AttractorGenerationMode != AttractorMode.Path && generator.AttractorGenerationMode != AttractorMode.Billboard)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Active Attractors:", labelStyle, GUILayout.Width(120));
                EditorGUILayout.LabelField(generator.AttractorCount_Active.ToString(), valueStyle);
                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Generated Splines:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.SplineCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Seed info for reproducibility
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Seed Used:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.Seed.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.HelpBox(
                "Same seed + same settings = same vines (deterministic)",
                MessageType.None);
        }
    }
}
