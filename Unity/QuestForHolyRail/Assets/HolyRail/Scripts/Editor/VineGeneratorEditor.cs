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

                    if (generator.CityManager.ConvergenceEndPoint != null)
                    {
                        EditorGUILayout.LabelField("Mode:", "Two-segment (with End Point)");
                    }
                    else
                    {
                        EditorGUILayout.LabelField("Mode:", "Single-segment (waypoints only)");
                    }
                    EditorGUI.indentLevel--;
                }

                EditorGUILayout.PropertyField(serializedObject.FindProperty("<VinesPerCorridor>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<PathLengthRange>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<PathCorridorWidth>k__BackingField"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<PathStartOffset>k__BackingField"));

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
                EditorGUILayout.HelpBox("Vines are clamped to stay above ground (Y >= 0)", MessageType.None);

                // Reuse Free mode noise settings for undulation
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Undulation", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreePointsPerSpline>k__BackingField"), new GUIContent("Points Per Vine"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseAmplitude>k__BackingField"), new GUIContent("Amplitude"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<FreeNoiseFrequency>k__BackingField"), new GUIContent("Frequency"));
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

            // Direction Bias - shown for attractor-based modes and Free mode (Path mode gets direction from CityManager)
            if (generator.AttractorGenerationMode != AttractorMode.Path)
            {
                EditorGUILayout.Space();
                EditorGUILayout.LabelField("Direction Bias", EditorStyles.boldLabel);
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<ForwardDirection>k__BackingField"));
                if (generator.AttractorGenerationMode != AttractorMode.Free)
                {
                    EditorGUILayout.PropertyField(serializedObject.FindProperty("<ForwardBias>k__BackingField"));
                }
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

            bool propertiesChanged = EditorGUI.EndChangeCheck();
            serializedObject.ApplyModifiedProperties();

            // Auto-regenerate if enabled and properties changed
            bool canAutoRegenerate = generator.AttractorGenerationMode == AttractorMode.Free
                || generator.AttractorGenerationMode == AttractorMode.Path
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
                    "1. Set ForwardDirection for spline travel direction\n" +
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
                    "Path Mode Setup:\n" +
                    "1. Assign a CityManager with valid corridor setup\n" +
                    "2. Set VinesPerCorridor for density across each path\n" +
                    "3. Adjust PathCorridorWidth for lateral spread\n" +
                    "4. Configure undulation with Amplitude/Frequency\n" +
                    "5. Enable Obstacle Avoidance to avoid buildings\n" +
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

            if (generator.AttractorGenerationMode != AttractorMode.Free && generator.AttractorGenerationMode != AttractorMode.Path)
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
