using UnityEngine;
using UnityEditor;
using HolyRail.City;

namespace HolyRail.City.Editor
{
    [CustomEditor(typeof(BuildingColliderPool))]
    public class BuildingColliderPoolEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;

        public override void OnInspectorGUI()
        {
            var pool = (BuildingColliderPool)target;

            DrawDefaultInspector();

            EditorGUILayout.Space(20);

            // Action Buttons Section
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("COLLIDER POOL", headerStyle);

            EditorGUILayout.Space(10);

            // Check for missing references
            bool hasAllReferences = pool.CityManager != null;

            if (!hasAllReferences)
            {
                EditorGUILayout.HelpBox(
                    "Missing references! Assign the following:\n" +
                    "- City Manager",
                    MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            if (pool.TrackingTarget == null)
            {
                EditorGUILayout.HelpBox(
                    "No Tracking Target assigned. Colliders will not auto-update around the player.",
                    MessageType.Info);
                EditorGUILayout.Space(5);
            }

            // Initialize Button
            EditorGUI.BeginDisabledGroup(!hasAllReferences || (pool.CityManager != null && !pool.CityManager.HasData));
            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("INITIALIZE POOL", GUILayout.Height(30)))
            {
                pool.Initialize();
                EditorUtility.SetDirty(pool);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            if (pool.CityManager != null && !pool.CityManager.HasData)
            {
                EditorGUILayout.HelpBox(
                    "CityManager has no generated data. Generate city data first.",
                    MessageType.Warning);
            }

            EditorGUILayout.Space(5);

            // Refresh Button
            EditorGUI.BeginDisabledGroup(!pool.Initialized);
            GUI.backgroundColor = new Color(0.3f, 0.7f, 1f);
            if (GUILayout.Button("Refresh Colliders", GUILayout.Height(25)))
            {
                pool.RefreshColliders();
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();

            // Statistics Section
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            _showStatistics = EditorGUILayout.Foldout(_showStatistics, "POOL STATISTICS", true, headerStyle);

            if (_showStatistics)
            {
                EditorGUILayout.Space(5);

                if (!pool.Initialized)
                {
                    EditorGUILayout.HelpBox("Pool not initialized. Click 'INITIALIZE POOL' to start.", MessageType.Info);
                }
                else
                {
                    DrawStatistics(pool);
                }
            }

            EditorGUILayout.EndVertical();

            // Help Box
            EditorGUILayout.Space(10);
            EditorGUILayout.HelpBox(
                "Setup:\n" +
                "1. Assign the CityManager reference\n" +
                "2. Assign a Tracking Target (usually the player)\n" +
                "3. Generate city data in CityManager\n" +
                "4. Click INITIALIZE POOL or enter Play mode\n" +
                "5. Colliders auto-update as the target moves\n\n" +
                "For VineGenerator:\n" +
                "- Set AttractorSurfaceLayers to include 'Buildings'\n" +
                "- Call ActivateCollidersInBounds() with the vine bounds",
                MessageType.None);

            // Repaint during play mode for live stats
            if (Application.isPlaying)
            {
                Repaint();
            }
        }

        private void DrawStatistics(BuildingColliderPool pool)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Active Colliders:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{pool.ActiveColliderCount} / {pool.TotalPoolSize}", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Pool Utilization:", labelStyle, GUILayout.Width(140));
            float utilization = pool.TotalPoolSize > 0 ? (float)pool.ActiveColliderCount / pool.TotalPoolSize * 100f : 0f;
            EditorGUILayout.LabelField($"{utilization:F1}%", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Activation Radius:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{pool.ActivationRadius:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Update Threshold:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{pool.UpdateDistanceThreshold:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            if (pool.CityManager != null && pool.CityManager.HasData)
            {
                EditorGUILayout.Space(5);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Total Buildings:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(pool.CityManager.ActualBuildingCount.ToString("N0"), valueStyle);
                EditorGUILayout.EndHorizontal();
            }
        }
    }
}
