using UnityEngine;
using UnityEditor;

namespace HolyRail.Editor
{
    [CustomEditor(typeof(PathVineGenerator))]
    public class PathVineGeneratorEditor : UnityEditor.Editor
    {
        private bool _settingsFoldout = true;
        private bool _noiseFoldout = true;
        private bool _avoidanceFoldout = true;
        private bool _smoothingFoldout = true;
        private bool _grindingFoldout = true;
        private bool _meshRenderingFoldout = true;

        public override void OnInspectorGUI()
        {
            var generator = (PathVineGenerator)target;

            serializedObject.Update();

            // References section
            EditorGUILayout.LabelField("References", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(serializedObject.FindProperty("_cityManager"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("_splineParent"));
            EditorGUILayout.Space();

            // Live Update toggle
            var liveUpdateProp = serializedObject.FindProperty("_liveUpdate");
            EditorGUILayout.PropertyField(liveUpdateProp, new GUIContent("Live Update"));
            EditorGUILayout.Space();

            // Buttons row 1
            EditorGUILayout.BeginHorizontal();
            GUI.backgroundColor = new Color(0.4f, 0.8f, 0.4f);
            if (GUILayout.Button("Generate", GUILayout.Height(30)))
            {
                generator.Generate();
                EditorUtility.SetDirty(generator);
            }

            GUI.backgroundColor = new Color(0.8f, 0.4f, 0.4f);
            if (GUILayout.Button("Clear", GUILayout.Height(30)))
            {
                generator.Clear();
                EditorUtility.SetDirty(generator);
            }
            GUI.backgroundColor = Color.white;
            EditorGUILayout.EndHorizontal();

            // Generate Meshes button (disabled during live update)
            EditorGUI.BeginDisabledGroup(generator.LiveUpdate);
            GUI.backgroundColor = new Color(0.4f, 0.6f, 0.8f);
            if (GUILayout.Button("Generate Meshes", GUILayout.Height(24)))
            {
                generator.GenerateMeshes();
                EditorUtility.SetDirty(generator);
            }
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.Space();

            // Track changes for live update
            EditorGUI.BeginChangeCheck();

            // Vine Settings foldout
            _settingsFoldout = EditorGUILayout.Foldout(_settingsFoldout, "Vine Settings", true);
            if (_settingsFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_vinesPerCorridor"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_vineLengthRange"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_corridorWidth"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_heightRange"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_minVineSpacing"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_pointSpacing"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_mirrorX"));
                EditorGUI.indentLevel--;
            }

            // Noise Settings foldout
            _noiseFoldout = EditorGUILayout.Foldout(_noiseFoldout, "Noise Settings", true);
            if (_noiseFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_lateralNoiseAmplitude"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_lateralNoiseFrequency"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_verticalNoiseAmplitude"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_verticalNoiseFrequency"));
                EditorGUI.indentLevel--;
            }

            // Avoidance Settings foldout
            _avoidanceFoldout = EditorGUILayout.Foldout(_avoidanceFoldout, "Avoidance Settings", true);
            if (_avoidanceFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_groundPadding"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_rampLayer"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_rampPadding"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_buildingLayer"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_buildingPadding"));
                EditorGUI.indentLevel--;
            }

            // Smoothing foldout
            _smoothingFoldout = EditorGUILayout.Foldout(_smoothingFoldout, "Smoothing", true);
            if (_smoothingFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_enableSmoothing"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_smoothingTolerance"));
                EditorGUI.indentLevel--;
            }

            // Grinding foldout
            _grindingFoldout = EditorGUILayout.Foldout(_grindingFoldout, "Grinding", true);
            if (_grindingFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_makeGrindable"));
                EditorGUI.indentLevel--;
            }

            // Mesh Rendering foldout
            _meshRenderingFoldout = EditorGUILayout.Foldout(_meshRenderingFoldout, "Mesh Rendering", true);
            if (_meshRenderingFoldout)
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_generateMesh"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_vineMaterial"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_vineRadius"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_meshSides"));
                EditorGUILayout.PropertyField(serializedObject.FindProperty("_segmentsPerUnit"));
                EditorGUI.indentLevel--;
            }

            bool changed = EditorGUI.EndChangeCheck();

            serializedObject.ApplyModifiedProperties();

            // Regenerate if live update is enabled and properties changed
            if (changed && generator.LiveUpdate)
            {
                generator.Generate();
                EditorUtility.SetDirty(generator);
            }
        }
    }
}
