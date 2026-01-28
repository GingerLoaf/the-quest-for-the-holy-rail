using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;
using HolyRail.Vines;

namespace HolyRail.Vines.Editor
{
    public static class VineTestSceneSetup
    {
        [MenuItem("HolyRail/Setup Vine Test Scene")]
        public static void SetupVineTestScene()
        {
            // Find VineRoot in scene
            var vineRoot = GameObject.Find("VineRoot");
            if (vineRoot == null)
            {
                Debug.LogError("VineTestSceneSetup: Could not find 'VineRoot' GameObject in scene!");
                return;
            }

            // Add or get VineGenerator component
            var generator = vineRoot.GetComponent<VineGenerator>();
            if (generator == null)
            {
                generator = Undo.AddComponent<VineGenerator>(vineRoot);
                Debug.Log("VineTestSceneSetup: Added VineGenerator component to VineRoot");
            }

            // Find and assign the compute shader
            var shaderGuids = AssetDatabase.FindAssets("DeterministicVines t:ComputeShader");
            if (shaderGuids.Length > 0)
            {
                var shaderPath = AssetDatabase.GUIDToAssetPath(shaderGuids[0]);
                var shader = AssetDatabase.LoadAssetAtPath<ComputeShader>(shaderPath);

                var so = new SerializedObject(generator);
                var shaderProp = so.FindProperty("<VineComputeShader>k__BackingField");
                if (shaderProp != null)
                {
                    shaderProp.objectReferenceValue = shader;
                    so.ApplyModifiedProperties();
                    Debug.Log($"VineTestSceneSetup: Assigned compute shader from {shaderPath}");
                }
            }
            else
            {
                Debug.LogWarning("VineTestSceneSetup: Could not find DeterministicVines.compute shader!");
            }

            // Create root point transforms as children of VineRoot
            CreateRootPoint(vineRoot.transform, "RootPoint_1", new Vector3(0, 0, 0));
            CreateRootPoint(vineRoot.transform, "RootPoint_2", new Vector3(2, -1, 0));
            CreateRootPoint(vineRoot.transform, "RootPoint_3", new Vector3(-2, -1, 0));

            // Assign root points to generator
            var rootPoints = new System.Collections.Generic.List<Transform>();
            foreach (Transform child in vineRoot.transform)
            {
                if (child.name.StartsWith("RootPoint_"))
                {
                    rootPoints.Add(child);
                }
            }

            var serializedObj = new SerializedObject(generator);
            var rootPointsProp = serializedObj.FindProperty("<RootPoints>k__BackingField");
            if (rootPointsProp != null)
            {
                rootPointsProp.arraySize = rootPoints.Count;
                for (int i = 0; i < rootPoints.Count; i++)
                {
                    rootPointsProp.GetArrayElementAtIndex(i).objectReferenceValue = rootPoints[i];
                }
            }

            // Configure bounds based on scene geometry
            var boundsProp = serializedObj.FindProperty("<AttractorBounds>k__BackingField");
            if (boundsProp != null)
            {
                var centerProp = boundsProp.FindPropertyRelative("m_Center");
                var sizeProp = boundsProp.FindPropertyRelative("m_Extent");
                if (centerProp != null && sizeProp != null)
                {
                    centerProp.vector3Value = new Vector3(0, 2, 5);
                    sizeProp.vector3Value = new Vector3(10, 5, 15);
                }
            }

            // Set layer mask to Default (everything)
            var layerMaskProp = serializedObj.FindProperty("<AttractorSurfaceLayers>k__BackingField");
            if (layerMaskProp != null)
            {
                layerMaskProp.intValue = ~0;
            }

            // Configure algorithm settings
            SetFloatProperty(serializedObj, "<StepSize>k__BackingField", 0.4f);
            SetFloatProperty(serializedObj, "<AttractionRadius>k__BackingField", 10.0f);
            SetFloatProperty(serializedObj, "<KillRadius>k__BackingField", 0.5f);
            SetIntProperty(serializedObj, "<AttractorCount>k__BackingField", 3000);
            SetIntProperty(serializedObj, "<MaxIterations>k__BackingField", 200);
            SetFloatProperty(serializedObj, "<NoiseStrength>k__BackingField", 0.1f);
            SetFloatProperty(serializedObj, "<AttractorSurfaceOffset>k__BackingField", 0.05f);

            // Visualization settings
            SetFloatProperty(serializedObj, "<GizmoSize>k__BackingField", 0.08f);

            // Mesh rendering settings
            SetFloatProperty(serializedObj, "<VineRadius>k__BackingField", 0.06f);
            SetIntProperty(serializedObj, "<VineSegments>k__BackingField", 6);
            SetIntProperty(serializedObj, "<VineSegmentsPerUnit>k__BackingField", 12);
            SetBoolProperty(serializedObj, "<GenerateMeshes>k__BackingField", true);

            // Create and assign vine material
            var vineMaterial = GetOrCreateVineMaterial();
            if (vineMaterial != null)
            {
                var materialProp = serializedObj.FindProperty("<VineMaterial>k__BackingField");
                if (materialProp != null)
                {
                    materialProp.objectReferenceValue = vineMaterial;
                    Debug.Log("VineTestSceneSetup: Assigned vine material");
                }
            }

            serializedObj.ApplyModifiedProperties();
            EditorUtility.SetDirty(generator);

            Debug.Log("VineTestSceneSetup: Setup complete! Click 'REGENERATE VINES' then 'CONVERT TO SPLINES' in the VineGenerator inspector.");

            Selection.activeGameObject = vineRoot;
            EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        }

        private static void CreateRootPoint(Transform parent, string name, Vector3 localPosition)
        {
            var existing = parent.Find(name);
            if (existing != null)
            {
                Debug.Log($"VineTestSceneSetup: Root point '{name}' already exists");
                return;
            }

            var rootPoint = new GameObject(name);
            Undo.RegisterCreatedObjectUndo(rootPoint, "Create Root Point");
            rootPoint.transform.SetParent(parent, false);
            rootPoint.transform.localPosition = localPosition;
            Debug.Log($"VineTestSceneSetup: Created root point '{name}' at local position {localPosition}");
        }

        private static void SetFloatProperty(SerializedObject so, string propName, float value)
        {
            var prop = so.FindProperty(propName);
            if (prop != null)
            {
                prop.floatValue = value;
            }
        }

        private static void SetIntProperty(SerializedObject so, string propName, int value)
        {
            var prop = so.FindProperty(propName);
            if (prop != null)
            {
                prop.intValue = value;
            }
        }

        private static void SetBoolProperty(SerializedObject so, string propName, bool value)
        {
            var prop = so.FindProperty(propName);
            if (prop != null)
            {
                prop.boolValue = value;
            }
        }

        private static Material GetOrCreateVineMaterial()
        {
            const string materialPath = "Assets/HolyRail/Materials/VineMaterial.mat";

            var existingMaterial = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
            if (existingMaterial != null)
            {
                return existingMaterial;
            }

            var shader = Shader.Find("Universal Render Pipeline/Lit");
            if (shader == null)
            {
                shader = Shader.Find("Standard");
            }

            if (shader == null)
            {
                Debug.LogError("VineTestSceneSetup: Could not find URP Lit or Standard shader!");
                return null;
            }

            var material = new Material(shader);
            material.name = "VineMaterial";
            material.SetColor("_BaseColor", new Color(0.15f, 0.35f, 0.1f));
            material.SetFloat("_Smoothness", 0.2f);
            material.SetFloat("_Metallic", 0f);

            if (!AssetDatabase.IsValidFolder("Assets/HolyRail/Materials"))
            {
                AssetDatabase.CreateFolder("Assets/HolyRail", "Materials");
            }

            AssetDatabase.CreateAsset(material, materialPath);
            AssetDatabase.SaveAssets();

            Debug.Log($"VineTestSceneSetup: Created vine material at {materialPath}");

            return material;
        }
    }
}
