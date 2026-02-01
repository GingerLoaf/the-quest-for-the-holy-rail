using UnityEngine;
using UnityEditor;
using HolyRail.Trees;

namespace HolyRail.Trees.Editor
{
    [CustomEditor(typeof(SpaceColonizationTree))]
    public class SpaceColonizationTreeEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;

        public override void OnInspectorGUI()
        {
            var generator = (SpaceColonizationTree)target;
            serializedObject.Update();

            EditorGUI.BeginChangeCheck();

            // Editor settings
            EditorGUILayout.LabelField("Editor", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AutoUpdate>k__BackingField"));

            // Seed
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Seed", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<Seed>k__BackingField"));

            // Algorithm
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Algorithm", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MaxIterations>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<StepSize>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractionRadius>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<KillRadius>k__BackingField"));

            // Volume
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Volume", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorBounds>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorCount>k__BackingField"));

            // Roots
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Roots", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<RootPoints>k__BackingField"));

            // Direction
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Direction", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<BiasDirection>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<BiasStrength>k__BackingField"));

            // Variation
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Variation", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<NoiseStrength>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<NoiseScale>k__BackingField"));

            // Branching
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Branching", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<BranchDensity>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinBranchSpreadAngle>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinBranchSeparation>k__BackingField"));

            // Filtering
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Filtering", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinSplineNodeCount>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<MinSplineWorldLength>k__BackingField"));

            // Smoothing
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Smoothing", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<EnablePathSmoothing>k__BackingField"));
            if (generator.EnablePathSmoothing)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<SmoothingTolerance>k__BackingField"));
                EditorGUI.indentLevel--;
            }

            // Material
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Material", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<TaperedMaterial>k__BackingField"));

            // Mesh
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Mesh", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<TubeRadius>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<TubeSides>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<SegmentsPerUnit>k__BackingField"));

            // Taper
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Taper", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<EnableEndTapering>k__BackingField"));
            if (generator.EnableEndTapering)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("<EndTaperDistance>k__BackingField"));
                EditorGUI.indentLevel--;
            }
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<DistanceTaperStrength>k__BackingField"));

            // Visualization
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Visualization", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ShowAttractors>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<ShowNodes>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<NodeColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<LineColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<AttractorColor>k__BackingField"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("<GizmoSize>k__BackingField"));

            bool propertiesChanged = EditorGUI.EndChangeCheck();
            serializedObject.ApplyModifiedProperties();

            // Auto-update tree (not meshes) when AutoUpdate is enabled
            if (propertiesChanged && generator.AutoUpdate)
            {
                Undo.RecordObject(generator, "Auto Update Tree");
                generator.GenerateTree();
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
            EditorGUILayout.LabelField("TREE GENERATION", headerStyle);

            EditorGUILayout.Space(10);

            // Phase 1: Generate Tree Button (Green)
            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("GENERATE TREE", GUILayout.Height(40)))
            {
                Undo.RecordObject(generator, "Generate Tree");
                generator.GenerateTree();
                EditorUtility.SetDirty(generator);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.Space(5);

            // Phase 2: Generate Meshes Button (Blue) - requires tree data
            EditorGUI.BeginDisabledGroup(!generator.HasTreeData);
            GUI.backgroundColor = new Color(0.3f, 0.6f, 1f);
            if (GUILayout.Button("GENERATE MESHES", GUILayout.Height(35)))
            {
                Undo.RecordObject(generator, "Generate Meshes");
                generator.GenerateMeshes();
                EditorUtility.SetDirty(generator);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(5);

            // Clear Button (Red) - clears both tree and meshes
            EditorGUI.BeginDisabledGroup(!generator.HasData);
            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear Generated Data", GUILayout.Height(25)))
            {
                Undo.RecordObject(generator, "Clear Tree Data");
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
                    EditorGUILayout.HelpBox("No tree data generated yet. Click 'GENERATE TREE' to generate.", MessageType.Info);
                }
                else
                {
                    DrawStatistics(generator);
                }
            }

            EditorGUILayout.EndVertical();

            // Help Box
            EditorGUILayout.Space(10);
            EditorGUILayout.HelpBox(
                "Space Colonization Tree - Two Phase Workflow:\n\n" +
                "Phase 1: GENERATE TREE\n" +
                "  - Runs the algorithm and shows gizmo lines\n" +
                "  - Enable 'Auto Update' to regenerate on parameter changes\n\n" +
                "Phase 2: GENERATE MESHES\n" +
                "  - Creates splines and meshes from tree structure\n" +
                "  - Only runs when explicitly clicked\n\n" +
                "Tips:\n" +
                "  - Root must be within AttractionRadius of attractors\n" +
                "  - Place root at edge of AttractorBounds, not center\n" +
                "  - Generated splines are grindable automatically",
                MessageType.None);
        }

        private void DrawStatistics(SpaceColonizationTree generator)
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

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Attractors Left:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.ActiveAttractorCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Generated Splines:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.SplineCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Status indicators
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Tree Data:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.HasTreeData ? "Ready" : "None", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Mesh Data:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.HasMeshData ? "Generated" : "None", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Seed Used:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.Seed.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.HelpBox(
                "Same seed + same settings = same tree (deterministic)",
                MessageType.None);
        }
    }
}
