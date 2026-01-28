using UnityEngine;
using UnityEditor;

namespace DSierra.ParameterHub.Editor
{
    public static class ParameterHubMenuItems
    {
        [MenuItem("GameObject/ParameterHub/Parameter Sender", false, 10)]
        private static void CreateParameterSender(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("ParameterSender");
            go.AddComponent<ParameterSender>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }

        [MenuItem("GameObject/ParameterHub/Parameter Receiver", false, 10)]
        private static void CreateParameterReceiver(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("ParameterReceiver");
            go.AddComponent<ParameterReceiver>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }

        [MenuItem("GameObject/ParameterHub/Preset Writer", false, 10)]
        private static void CreatePresetWriter(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("PresetWriter");
            go.AddComponent<PresetWriter>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }

        [MenuItem("GameObject/ParameterHub/Preset Loader", false, 10)]
        private static void CreatePresetLoader(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("PresetLoader");
            go.AddComponent<PresetLoader>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }

        [MenuItem("GameObject/ParameterHub/Serializer", false, 10)]
        private static void CreateSerializer(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("ParameterHubSerializer");
            go.AddComponent<ParameterHubSerializer>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }

        [MenuItem("GameObject/ParameterHub/Example Controller", false, 10)]
        private static void CreateExampleController(MenuCommand menuCommand)
        {
            GameObject go = new GameObject("ParameterHubExample");
            go.AddComponent<ParameterHubExample>();
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            Undo.RegisterCreatedObjectUndo(go, "Create " + go.name);
            Selection.activeObject = go;
        }
    }
}
