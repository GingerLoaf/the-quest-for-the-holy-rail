using UnityEngine;
using UnityEditor;
using HolyRail.Scripts.LevelGeneration;

namespace HolyRail.Scripts.LevelGeneration.Editor
{
    public static class HexSectionSetupMenu
    {
        [MenuItem("Holy Rail/Create Hex Section")]
        public static void CreateHexSection()
        {
            var go = new GameObject("HexSection");
            go.AddComponent<HexSection>();
            Selection.activeGameObject = go;
            Undo.RegisterCreatedObjectUndo(go, "Create Hex Section");
            SceneView.lastActiveSceneView?.FrameSelected();
        }

        [MenuItem("Holy Rail/Create Hex Section Config")]
        public static void CreateHexSectionConfig()
        {
            var config = ScriptableObject.CreateInstance<HexSectionConfig>();

            string path = EditorUtility.SaveFilePanelInProject(
                "Save Hex Section Config",
                "HexSectionConfig",
                "asset",
                "Choose where to save the config asset",
                "Assets/HolyRail/Prefabs/HexSections"
            );

            if (string.IsNullOrEmpty(path))
                return;

            AssetDatabase.CreateAsset(config, path);
            AssetDatabase.SaveAssets();
            EditorUtility.FocusProjectWindow();
            Selection.activeObject = config;
            EditorGUIUtility.PingObject(config);
        }

        [MenuItem("Holy Rail/Open Hex Section Editor")]
        public static void OpenHexSectionEditor()
        {
            HexSectionEditorWindow.ShowWindow();
        }
    }
}
