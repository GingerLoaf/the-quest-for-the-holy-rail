using System.Linq;
using UnityEngine;
using UnityEditor;
using HolyRail.Scripts.LevelGeneration;

namespace HolyRail.Scripts.LevelGeneration.Editor
{
    [CustomEditor(typeof(LevelGenerationManager))]
    public class LevelGenerationManagerEditor : UnityEditor.Editor
    {
        private SerializedProperty _plotPoints;

        private void OnEnable()
        {
            _plotPoints = serializedObject.FindProperty("_plotPoints");
        }

        public override void OnInspectorGUI()
        {
            var manager = (LevelGenerationManager)target;
            DrawDefaultInspector();

            EditorGUILayout.Space(20);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("PLOT POINTS", headerStyle);

            EditorGUILayout.Space(5);
            DrawPlotPointSummary();
            EditorGUILayout.Space(10);

            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("COMPUTE PLOT POINTS", GUILayout.Height(35)))
            {
                Undo.RegisterFullObjectHierarchyUndo(manager.gameObject, "Compute Plot Points");
                manager.ComputePlotPoints();
                EditorUtility.SetDirty(manager);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.Space(5);

            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear Plot Points", GUILayout.Height(25)))
            {
                Undo.RegisterFullObjectHierarchyUndo(manager.gameObject, "Clear Plot Points");
                manager.ClearPlotPoints();
                EditorUtility.SetDirty(manager);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.EndVertical();
        }

        private void DrawPlotPointSummary()
        {
            serializedObject.Update();

            int totalPoints = _plotPoints.arraySize;

            // Count distinct paths
            int pathCount = 0;
            int validPoints = 0;
            var pathPointCounts = new System.Collections.Generic.Dictionary<int, int>();

            for (int i = 0; i < totalPoints; i++)
            {
                var element = _plotPoints.GetArrayElementAtIndex(i);
                if (element.objectReferenceValue == null) continue;

                validPoints++;
                var plotPoint = (PlotPoint)element.objectReferenceValue;
                int pathIndex = plotPoint.PathIndex;

                if (!pathPointCounts.ContainsKey(pathIndex))
                    pathPointCounts[pathIndex] = 0;

                pathPointCounts[pathIndex]++;
            }

            pathCount = pathPointCounts.Count;

            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Paths:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(pathCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Total Plot Points:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(validPoints.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            foreach (var kvp in pathPointCounts.OrderBy(k => k.Key))
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField($"  Path {kvp.Key}:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField($"{kvp.Value} points", valueStyle);
                EditorGUILayout.EndHorizontal();
            }
        }
    }
}
