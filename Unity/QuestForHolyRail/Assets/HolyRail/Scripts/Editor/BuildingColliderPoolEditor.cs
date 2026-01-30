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

            // Status Section
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("COLLIDER POOL STATUS", headerStyle);

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

            // Initialization status
            DrawInitializationStatus(pool);

            EditorGUILayout.EndVertical();

            // Statistics Section
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            _showStatistics = EditorGUILayout.Foldout(_showStatistics, "POOL STATISTICS", true, headerStyle);

            if (_showStatistics)
            {
                EditorGUILayout.Space(5);

                if (!pool.Initialized && !pool.RampInitialized && !pool.BillboardInitialized)
                {
                    EditorGUILayout.HelpBox("Pool not initialized. Generate city data to auto-initialize.", MessageType.Info);
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
                "Colliders are auto-initialized when the city generates.\n\n" +
                "Setup:\n" +
                "1. Assign the CityManager reference\n" +
                "2. Assign a Tracking Target (usually the player)\n" +
                "3. Generate city data in CityManager\n" +
                "4. Colliders auto-update as the target moves\n\n" +
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

        private void DrawInitializationStatus(BuildingColliderPool pool)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var initializedStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.9f, 0.3f) }
            };
            var notInitializedStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.7f, 0.7f, 0.7f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Buildings:", labelStyle, GUILayout.Width(80));
            EditorGUILayout.LabelField(
                pool.Initialized ? "Initialized" : "Not Initialized",
                pool.Initialized ? initializedStyle : notInitializedStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Ramps:", labelStyle, GUILayout.Width(80));
            EditorGUILayout.LabelField(
                pool.RampInitialized ? "Initialized" : "Not Initialized",
                pool.RampInitialized ? initializedStyle : notInitializedStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Billboards:", labelStyle, GUILayout.Width(80));
            EditorGUILayout.LabelField(
                pool.BillboardInitialized ? "Initialized" : "Not Initialized",
                pool.BillboardInitialized ? initializedStyle : notInitializedStyle);
            EditorGUILayout.EndHorizontal();
        }

        private void DrawStatistics(BuildingColliderPool pool)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            // Building stats
            if (pool.Initialized)
            {
                EditorGUILayout.LabelField("Buildings", EditorStyles.boldLabel);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("  Active Colliders:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField($"{pool.ActiveColliderCount} / {pool.TotalPoolSize}", valueStyle);
                EditorGUILayout.EndHorizontal();
            }

            // Ramp stats
            if (pool.RampInitialized)
            {
                EditorGUILayout.LabelField("Ramps", EditorStyles.boldLabel);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("  Active Colliders:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField($"{pool.ActiveRampColliderCount} / {pool.TotalRampPoolSize}", valueStyle);
                EditorGUILayout.EndHorizontal();
            }

            // Billboard stats
            if (pool.BillboardInitialized)
            {
                EditorGUILayout.LabelField("Billboards", EditorStyles.boldLabel);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("  Active Colliders:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField($"{pool.ActiveBillboardColliderCount} / {pool.TotalBillboardPoolSize}", valueStyle);
                EditorGUILayout.EndHorizontal();
            }

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
