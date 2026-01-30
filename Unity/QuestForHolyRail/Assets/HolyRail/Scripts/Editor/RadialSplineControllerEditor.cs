using UnityEngine;
using UnityEditor;
using HolyRail.Splines;

namespace HolyRail.Splines.Editor
{
    [CustomEditor(typeof(RadialSplineController))]
    public class RadialSplineControllerEditor : UnityEditor.Editor
    {
        private bool _showStatistics = true;

        public override void OnInspectorGUI()
        {
            var controller = (RadialSplineController)target;

            DrawDefaultInspector();

            EditorGUILayout.Space(20);

            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("RADIAL SPLINE CLONING", headerStyle);

            EditorGUILayout.Space(10);

            // Check for missing references
            bool hasMasterSpline = controller.MasterSpline != null;
            bool hasMaterial = controller.SplineMaterial != null;
            bool hasMesh = controller.SourceMesh != null;

            if (!hasMasterSpline)
            {
                EditorGUILayout.HelpBox("Assign a Master Spline to clone.", MessageType.Warning);
                EditorGUILayout.Space(5);
            }

            if (!hasMaterial)
            {
                EditorGUILayout.HelpBox("Assign the SplineCurvatureInstanced material for GPU rendering.", MessageType.Info);
            }

            if (!hasMesh && hasMasterSpline)
            {
                EditorGUILayout.HelpBox(
                    "Source Mesh not set. Will auto-extract from SplineExtrude's MeshFilter if available.",
                    MessageType.Info);
            }

            EditorGUILayout.Space(5);

            // Regenerate Button
            EditorGUI.BeginDisabledGroup(!hasMasterSpline);
            GUI.backgroundColor = new Color(0.3f, 0.8f, 1f);
            if (GUILayout.Button("REGENERATE CLONES", GUILayout.Height(35)))
            {
                Undo.RecordObject(controller, "Regenerate Radial Spline Clones");
                controller.Regenerate();
                EditorUtility.SetDirty(controller);
                SceneView.RepaintAll();
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();

            // Statistics Section
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            _showStatistics = EditorGUILayout.Foldout(_showStatistics, "STATISTICS", true, headerStyle);

            if (_showStatistics)
            {
                EditorGUILayout.Space(5);
                DrawStatistics(controller);
            }

            EditorGUILayout.EndVertical();

            // Help Box
            EditorGUILayout.Space(10);
            EditorGUILayout.HelpBox(
                "Radial Spline Cloning:\n" +
                "1. Assign a SplineContainer as Master Spline\n" +
                "2. Set radius and clone count\n" +
                "3. Configure mirroring and symmetry as desired\n" +
                "4. Assign SplineCurvatureInstanced material\n" +
                "5. Clones auto-update when master spline is edited\n\n" +
                "Grinding: Each clone creates a child SplineContainer for\n" +
                "the grinding system to detect.",
                MessageType.None);
        }

        private void DrawStatistics(RadialSplineController controller)
        {
            var labelStyle = new GUIStyle(EditorStyles.label);
            var valueStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Active Clones:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(controller.ActiveCloneCount.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Circle Radius:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField($"{controller.CircleRadius:F1}m", valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Symmetry Mode:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(controller.SymmetryMode.ToString(), valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Mirroring info
            string mirrorInfo = "None";
            if (controller.MirrorX && controller.MirrorZ)
                mirrorInfo = "X + Z (alternating)";
            else if (controller.MirrorX)
                mirrorInfo = "X axis (alternating)";
            else if (controller.MirrorZ)
                mirrorInfo = "Z axis (alternating)";

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Mirror Mode:", labelStyle, GUILayout.Width(140));
            EditorGUILayout.LabelField(mirrorInfo, valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.Space(5);

            // Source info
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Master Spline:", labelStyle, GUILayout.Width(140));
            string splineName = controller.MasterSpline != null ? controller.MasterSpline.name : "Not assigned";
            EditorGUILayout.LabelField(splineName, valueStyle);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Source Mesh:", labelStyle, GUILayout.Width(140));
            string meshName = controller.SourceMesh != null ? controller.SourceMesh.name : "Auto-extract";
            EditorGUILayout.LabelField(meshName, valueStyle);
            EditorGUILayout.EndHorizontal();

            // GPU rendering status
            EditorGUILayout.Space(5);
            bool gpuReady = controller.SplineMaterial != null && controller.SourceMesh != null;
            EditorGUILayout.HelpBox(
                gpuReady
                    ? "GPU instanced rendering: ACTIVE"
                    : "GPU instanced rendering: INACTIVE (missing material or mesh)",
                gpuReady ? MessageType.Info : MessageType.Warning);
        }

        private void OnSceneGUI()
        {
            var controller = (RadialSplineController)target;

            if (!controller.ShowGizmos)
                return;

            // Draw handles for each clone position
            var cloneData = controller.CloneData;
            if (cloneData == null || cloneData.Count == 0)
                return;

            Handles.color = new Color(1f, 0.5f, 0.2f, 0.8f);

            for (int i = 0; i < cloneData.Count; i++)
            {
                var clone = cloneData[i];

                // Draw disc at clone position
                Handles.DrawWireDisc(clone.Position, Vector3.up, 0.3f);

                // Draw label
                Handles.Label(
                    clone.Position + Vector3.up * 0.5f,
                    $"#{i}",
                    new GUIStyle
                    {
                        normal = { textColor = Color.white },
                        fontStyle = FontStyle.Bold,
                        alignment = TextAnchor.MiddleCenter
                    });
            }

            // Draw center marker
            Handles.color = Color.yellow;
            Handles.DrawWireDisc(controller.transform.position, Vector3.up, 1f);
            Handles.DrawWireDisc(controller.transform.position, Vector3.up, 0.5f);
        }
    }
}
