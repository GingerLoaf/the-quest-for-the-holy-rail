using UnityEngine;
using UnityEditor;
using HolyRail.City;

namespace HolyRail.City.Editor
{
    [CustomEditor(typeof(CityManager))]
    public class CityManagerEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;

        public override void OnInspectorGUI()
        {
            var manager = (CityManager)target;

            // Draw default inspector
            DrawDefaultInspector();

            EditorGUILayout.Space(20);

            // Action Buttons Section
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("CITY GENERATION", headerStyle);

            EditorGUILayout.Space(10);

            // Check for missing references
            bool hasAllReferences = manager.CityGeneratorShader != null &&
                                    manager.BuildingMesh != null &&
                                    manager.BuildingMaterial != null;

            if (!hasAllReferences)
            {
                EditorGUILayout.HelpBox(
                    "Missing references! Assign the following:\n" +
                    (manager.CityGeneratorShader == null ? "- City Generator Shader (compute)\n" : "") +
                    (manager.BuildingMesh == null ? "- Building Mesh\n" : "") +
                    (manager.BuildingMaterial == null ? "- Building Material" : ""),
                    MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            // Generate Button (Green)
            EditorGUI.BeginDisabledGroup(!hasAllReferences);
            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("GENERATE CITY", GUILayout.Height(40)))
            {
                Undo.RecordObject(manager, "Generate City");
                manager.Generate();
                EditorUtility.SetDirty(manager);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(5);

            // Clear Button (Red) - disabled if not generated
            EditorGUI.BeginDisabledGroup(!manager.IsGenerated);
            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear Generated Data", GUILayout.Height(25)))
            {
                if (EditorUtility.DisplayDialog("Clear City Data",
                    "Are you sure you want to clear all generated city data?\n\nThis action cannot be undone!",
                    "Clear", "Cancel"))
                {
                    Undo.RecordObject(manager, "Clear City Data");
                    manager.Clear();
                    EditorUtility.SetDirty(manager);
                    SceneView.RepaintAll();
                }
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

                if (!manager.IsGenerated)
                {
                    EditorGUILayout.HelpBox("No city data generated yet. Click 'GENERATE CITY' to generate.", MessageType.Info);
                }
                else
                {
                    DrawStatistics(manager);
                }
            }

            EditorGUILayout.EndVertical();

            // Help Box
            EditorGUILayout.Space(10);
            EditorGUILayout.HelpBox(
                "Setup:\n" +
                "1. Use menu HolyRail > Setup City Generator for auto-setup\n" +
                "2. Or manually assign the CityGenerator compute shader\n" +
                "3. Assign a mesh (cube works well) and material\n" +
                "4. Position this GameObject at the desired city center\n" +
                "5. Click GENERATE CITY or enter Play mode\n" +
                "6. Adjust parameters and regenerate as needed",
                MessageType.None);
        }

        private void DrawStatistics(CityManager manager)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Buildings Generated:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(manager.ActualBuildingCount.ToString("N0"), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Building Attempts:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(manager.BuildingCount.ToString("N0"), valueStyle);
            EditorGUILayout.EndHorizontal();

            float successRate = manager.BuildingCount > 0 ?
                (float)manager.ActualBuildingCount / manager.BuildingCount * 100f : 0f;
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Placement Rate:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{successRate:F1}%", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Map Size:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.MapSize:F0}m x {manager.MapSize:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Downtown Radius:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.DowntownRadius:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Seed info for reproducibility
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Seed Used:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(manager.Seed.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.HelpBox(
                "Same seed = same city layout (deterministic)",
                MessageType.None);
        }
    }
}
