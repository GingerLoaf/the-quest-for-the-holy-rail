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
                if (EditorUtility.DisplayDialog("Clear Vine Data",
                    "Are you sure you want to clear all generated vine data?\n\nThis will remove all nodes, attractors, and generated splines.\n\nThis action cannot be undone!",
                    "Clear", "Cancel"))
                {
                    Undo.RecordObject(generator, "Clear Vine Data");
                    generator.Clear();
                    EditorUtility.SetDirty(generator);
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

            // Help Box
            EditorGUILayout.Space(10);
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

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Active Attractors:", labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(generator.AttractorCount_Active.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

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
                "Same seed + same scene = same vines (deterministic)",
                MessageType.None);
        }
    }
}
