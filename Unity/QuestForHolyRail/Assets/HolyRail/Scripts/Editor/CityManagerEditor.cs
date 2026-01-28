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
            bool hasAllReferences = manager.BuildingMesh != null &&
                                    manager.BuildingMaterial != null;

            bool hasMissingCorridorReferences = !manager.HasValidCorridorSetup;

            // Check ramp references if ramps are enabled
            bool hasMissingRampReferences = manager.EnableRamps &&
                                            (manager.RampMesh == null || manager.RampMaterial == null);

            // Check billboard references if billboards are enabled
            bool hasMissingBillboardReferences = manager.EnableBillboards &&
                                                  (manager.BillboardMesh == null || manager.BillboardMaterial == null);

            if (!hasAllReferences)
            {
                EditorGUILayout.HelpBox(
                    "Missing references! Assign the following:\n" +
                    (manager.BuildingMesh == null ? "- Building Mesh\n" : "") +
                    (manager.BuildingMaterial == null ? "- Building Material" : ""),
                    MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            if (hasMissingCorridorReferences)
            {
                string missingMsg = "Corridor layout not configured! ";

                if (manager.ConvergencePoint == null)
                    missingMsg += "\n- Convergence Point (start plaza)";

                // Check enabled corridors for missing waypoints (only if no end point)
                if (manager.ConvergenceEndPoint == null)
                {
                    if (manager.EnableCorridorA && manager.EndpointA == null)
                        missingMsg += "\n- Endpoint A (waypoint)";
                    if (manager.EnableCorridorB && manager.EndpointB == null)
                        missingMsg += "\n- Endpoint B (waypoint)";
                    if (manager.EnableCorridorC && manager.EndpointC == null)
                        missingMsg += "\n- Endpoint C (waypoint)";
                }

                if (!manager.EnableCorridorA && !manager.EnableCorridorB && !manager.EnableCorridorC)
                    missingMsg += "\n- Enable at least one corridor";

                EditorGUILayout.HelpBox(missingMsg, MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            if (hasMissingRampReferences)
            {
                EditorGUILayout.HelpBox(
                    "Ramps enabled but missing references:\n" +
                    (manager.RampMesh == null ? "- Ramp Mesh (cube)\n" : "") +
                    (manager.RampMaterial == null ? "- Ramp Material" : ""),
                    MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            if (hasMissingBillboardReferences)
            {
                EditorGUILayout.HelpBox(
                    "Billboards enabled but missing references:\n" +
                    (manager.BillboardMesh == null ? "- Billboard Mesh (cube)\n" : "") +
                    (manager.BillboardMaterial == null ? "- Billboard Material" : ""),
                    MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            // Generate Button (Green)
            bool canGenerate = hasAllReferences && !hasMissingCorridorReferences;
            EditorGUI.BeginDisabledGroup(!canGenerate);
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
                Undo.RecordObject(manager, "Clear City Data");
                manager.Clear();
                EditorUtility.SetDirty(manager);
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
                "Corridor-Based City Setup:\n" +
                "1. Create GameObjects for Convergence Point (start plaza)\n" +
                "2. Create Endpoint A/B/C as corridor waypoints\n" +
                "3. (Optional) Create Convergence End Point (destination plaza)\n" +
                "4. Toggle corridors A/B/C on/off as needed\n" +
                "5. Assign building mesh and material\n" +
                "6. Click GENERATE CITY\n" +
                "7. Adjust corridor parameters and regenerate as needed",
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
            EditorGUILayout.LabelField("Enabled Corridors:", labelStyle, GUILayout.Width(140));
            string corridorList = "";
            if (manager.EnableCorridorA) corridorList += "A ";
            if (manager.EnableCorridorB) corridorList += "B ";
            if (manager.EnableCorridorC) corridorList += "C ";
            EditorGUILayout.LabelField($"{manager.EnabledCorridorCount} ({corridorList.Trim()})", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Corridor settings info
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Corridor Width:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.CorridorWidth:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Building Spacing:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.BuildingSpacing:F0}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Convergence Radius:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.ConvergenceRadius:F0}m (plaza)", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Building Rows:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{manager.BuildingRows} per side", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Start Plaza Ring:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(manager.EnablePlazaRing ? $"{manager.PlazaRingRows} row(s)" : "Disabled", valueStyle);
            EditorGUILayout.EndHorizontal();

            // End plaza info
            if (manager.ConvergenceEndPoint != null)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("End Plaza Radius:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField($"{manager.ConvergenceEndRadius:F0}m", valueStyle);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("End Plaza Ring:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(manager.EnableConvergenceEndPlaza ? $"{manager.EndPlazaRingRows} row(s)" : "Disabled", valueStyle);
                EditorGUILayout.EndHorizontal();
            }

            EditorGUILayout.Space(5);

            // Ramp statistics
            if (manager.EnableRamps)
            {
                EditorGUILayout.LabelField("Ramps", EditorStyles.boldLabel);

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Ramps Generated:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(manager.ActualRampCount.ToString("N0"), valueStyle);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Ramp Target:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(manager.RampCount.ToString("N0"), valueStyle);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.Space(5);
            }

            // Billboard statistics
            if (manager.EnableBillboards)
            {
                EditorGUILayout.LabelField("Billboards", EditorStyles.boldLabel);

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Billboards Generated:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(manager.ActualBillboardCount.ToString("N0"), valueStyle);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Billboard Target:", labelStyle, GUILayout.Width(140));
                EditorGUILayout.LabelField(manager.BillboardCount.ToString("N0"), valueStyle);
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.Space(5);
            }

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
