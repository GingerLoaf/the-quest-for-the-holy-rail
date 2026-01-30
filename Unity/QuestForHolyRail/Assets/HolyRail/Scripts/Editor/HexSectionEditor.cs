using UnityEngine;
using UnityEditor;
using UnityEngine.Splines;
using HolyRail.Scripts.LevelGeneration;

namespace HolyRail.Scripts.LevelGeneration.Editor
{
    [CustomEditor(typeof(HexSection))]
    public class HexSectionEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;
        private HexSectionConfig _config;
        private int _seed = 12345;

        public override void OnInspectorGUI()
        {
            var section = (HexSection)target;
            DrawDefaultInspector();

            EditorGUILayout.Space(20);

            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("HEX SECTION GENERATION", headerStyle);

            EditorGUILayout.Space(10);

            _config = (HexSectionConfig)EditorGUILayout.ObjectField(
                "Config", _config, typeof(HexSectionConfig), false);

            _seed = EditorGUILayout.IntField("Seed", _seed);

            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("Randomize Seed"))
                _seed = Random.Range(0, int.MaxValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(10);

            // Generate button
            EditorGUI.BeginDisabledGroup(_config == null);
            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("GENERATE", GUILayout.Height(35)))
            {
                Undo.RecordObject(section, "Generate Hex Section");
                HexSectionGenerator.Generate(section, _config, _seed);
                EditorUtility.SetDirty(section);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(5);

            // Clear button
            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear", GUILayout.Height(25)))
            {
                Undo.RecordObject(section, "Clear Hex Section");
                HexSectionGenerator.Clear(section);
                EditorUtility.SetDirty(section);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.Space(5);

            // Validate button
            GUI.backgroundColor = new Color(0.3f, 0.7f, 1f);
            if (GUILayout.Button("Validate", GUILayout.Height(25)))
            {
                bool valid = HexSectionGenerator.ValidateSection(section);
                if (valid)
                    Debug.Log("HexSection: Validation passed.", section);
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.EndVertical();

            // Statistics
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            _showStatistics = EditorGUILayout.Foldout(_showStatistics, "STATISTICS", true, headerStyle);

            if (_showStatistics)
            {
                EditorGUILayout.Space(5);
                DrawStatistics(section);
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawStatistics(HexSection section)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            DrawStatRow("Circumradius:", $"{section.Circumradius:F0}m", labelStyle, valueStyle);
            DrawStatRow("Entry Edge:", section.EntryEdge.ToString(), labelStyle, valueStyle);
            DrawStatRow("Exit Edge:", section.ExitEdge.ToString(), labelStyle, valueStyle);
            DrawStatRow("Seed:", section.Seed.ToString(), labelStyle, valueStyle);

            var splines = section.GetComponentsInChildren<SplineContainer>();
            DrawStatRow("Rail Splines:", splines.Length.ToString(), labelStyle, valueStyle);

            var rampParent = section.transform.Find("Ramps");
            int rampCount = rampParent != null ? rampParent.childCount : 0;
            DrawStatRow("Ramps:", rampCount.ToString(), labelStyle, valueStyle);

            var obstacleParent = section.transform.Find("Obstacles");
            int obstacleCount = obstacleParent != null ? obstacleParent.childCount : 0;
            DrawStatRow("Obstacles:", obstacleCount.ToString(), labelStyle, valueStyle);

            var wallParent = section.transform.Find("WallRideSurfaces");
            int wallCount = wallParent != null ? wallParent.childCount : 0;
            DrawStatRow("Wall Ride Surfaces:", wallCount.ToString(), labelStyle, valueStyle);

            DrawStatRow("Has Shop:", section.HasShop ? "Yes" : "No", labelStyle, valueStyle);
        }

        private void DrawStatRow(string label, string value, GUIStyle labelStyle, GUIStyle valueStyle)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(label, labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(value, valueStyle);
            EditorGUILayout.EndHorizontal();
        }
    }
}
