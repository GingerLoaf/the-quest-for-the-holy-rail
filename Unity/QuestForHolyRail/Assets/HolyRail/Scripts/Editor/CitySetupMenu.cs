using UnityEngine;
using UnityEditor;
using HolyRail.City;

namespace HolyRail.City.Editor
{
    public static class CitySetupMenu
    {
        private const string MaterialPath = "Assets/HolyRail/Materials/CityBuildings.mat";
        private const string ShaderPath = "Assets/HolyRail/Shaders/BuildingInstanced.shader";
        private const string ComputePath = "Assets/HolyRail/Shaders/CityGenerator.compute";
        private const string RampMaterialPath = "Assets/HolyRail/Materials/RampMaterial.mat";
        private const string RampShaderPath = "Assets/HolyRail/Shaders/RampInstanced.shader";

        [MenuItem("HolyRail/Setup City Generator")]
        public static void SetupCityGenerator()
        {
            // 1. Load or create material
            var material = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            if (material == null)
            {
                var shader = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
                if (shader == null)
                {
                    Debug.LogError($"CitySetup: Could not find BuildingInstanced shader at {ShaderPath}");
                    return;
                }

                material = new Material(shader);
                material.name = "CityBuildings";

                // Set default material properties
                material.SetColor("_DowntownColor", new Color(0.5f, 0.5f, 0.55f, 1f));
                material.SetColor("_IndustrialColor", new Color(0.55f, 0.4f, 0.35f, 1f));
                material.SetFloat("_WindowEmission", 0.5f);
                material.SetFloat("_WindowDensity", 10f);

                // Ensure Materials folder exists
                if (!AssetDatabase.IsValidFolder("Assets/HolyRail/Materials"))
                {
                    AssetDatabase.CreateFolder("Assets/HolyRail", "Materials");
                }

                AssetDatabase.CreateAsset(material, MaterialPath);
                AssetDatabase.SaveAssets();
                Debug.Log($"CitySetup: Created material at {MaterialPath}");
            }

            // 2. Load or create ramp material
            var rampMaterial = AssetDatabase.LoadAssetAtPath<Material>(RampMaterialPath);
            if (rampMaterial == null)
            {
                var rampShader = AssetDatabase.LoadAssetAtPath<Shader>(RampShaderPath);
                if (rampShader == null)
                {
                    Debug.LogError($"CitySetup: Could not find RampInstanced shader at {RampShaderPath}");
                    return;
                }

                rampMaterial = new Material(rampShader);
                rampMaterial.name = "RampMaterial";

                // Set default ramp material properties
                rampMaterial.SetColor("_BaseColor", new Color(0.2f, 0.4f, 0.8f, 1f));
                rampMaterial.SetFloat("_ColorVariation", 0.05f);

                AssetDatabase.CreateAsset(rampMaterial, RampMaterialPath);
                AssetDatabase.SaveAssets();
                Debug.Log($"CitySetup: Created ramp material at {RampMaterialPath}");
            }

            // 3. Load compute shader
            var computeShader = AssetDatabase.LoadAssetAtPath<ComputeShader>(ComputePath);
            if (computeShader == null)
            {
                Debug.LogError($"CitySetup: Could not find CityGenerator compute shader at {ComputePath}");
                return;
            }

            // 4. Get default cube mesh
            var cubeMesh = GetDefaultCubeMesh();
            if (cubeMesh == null)
            {
                Debug.LogError("CitySetup: Could not find default cube mesh");
                return;
            }

            // 5. Create CityGenerator GameObject
            var cityGO = new GameObject("CityGenerator");
            var cityManager = cityGO.AddComponent<CityManager>();

            // Use SerializedObject to set the private setter properties
            var serializedObject = new SerializedObject(cityManager);

            var computeShaderProp = serializedObject.FindProperty("<CityGeneratorShader>k__BackingField");
            if (computeShaderProp != null)
            {
                computeShaderProp.objectReferenceValue = computeShader;
            }

            var meshProp = serializedObject.FindProperty("<BuildingMesh>k__BackingField");
            if (meshProp != null)
            {
                meshProp.objectReferenceValue = cubeMesh;
            }

            var materialProp = serializedObject.FindProperty("<BuildingMaterial>k__BackingField");
            if (materialProp != null)
            {
                materialProp.objectReferenceValue = material;
            }

            // Set ramp properties
            var enableRampsProp = serializedObject.FindProperty("<EnableRamps>k__BackingField");
            if (enableRampsProp != null)
            {
                enableRampsProp.boolValue = true;
            }

            var rampMeshProp = serializedObject.FindProperty("<RampMesh>k__BackingField");
            if (rampMeshProp != null)
            {
                rampMeshProp.objectReferenceValue = cubeMesh;
            }

            var rampMaterialProp = serializedObject.FindProperty("<RampMaterial>k__BackingField");
            if (rampMaterialProp != null)
            {
                rampMaterialProp.objectReferenceValue = rampMaterial;
            }

            var rampYOffsetProp = serializedObject.FindProperty("<RampYOffset>k__BackingField");
            if (rampYOffsetProp != null)
            {
                rampYOffsetProp.floatValue = -1f;
            }

            serializedObject.ApplyModifiedPropertiesWithoutUndo();

            // 6. Add BuildingColliderPool component
            var colliderPool = cityGO.AddComponent<BuildingColliderPool>();
            var poolSerializedObject = new SerializedObject(colliderPool);

            var cityManagerProp = poolSerializedObject.FindProperty("<CityManager>k__BackingField");
            if (cityManagerProp != null)
            {
                cityManagerProp.objectReferenceValue = cityManager;
            }

            // Try to find a player in the scene for tracking target
            Transform trackingTarget = null;
            var playerArmature = GameObject.Find("PlayerArmature");
            if (playerArmature != null)
            {
                trackingTarget = playerArmature.transform;
            }
            else
            {
                // Try finding by tag (wrapped in try-catch in case tag doesn't exist)
                try
                {
                    var player = GameObject.FindGameObjectWithTag("Player");
                    if (player != null)
                    {
                        trackingTarget = player.transform;
                    }
                }
                catch (UnityException)
                {
                    // Player tag doesn't exist, that's fine
                }
            }

            if (trackingTarget != null)
            {
                var trackingTargetProp = poolSerializedObject.FindProperty("<TrackingTarget>k__BackingField");
                if (trackingTargetProp != null)
                {
                    trackingTargetProp.objectReferenceValue = trackingTarget;
                }
            }

            poolSerializedObject.ApplyModifiedPropertiesWithoutUndo();

            // 7. Register undo and select
            Undo.RegisterCreatedObjectUndo(cityGO, "Create City Generator");
            Selection.activeGameObject = cityGO;

            // 8. Log success
            var trackingInfo = trackingTarget != null
                ? $"  - Tracking Target: {trackingTarget.name}\n"
                : "  - Tracking Target: Not found (assign manually)\n";

            Debug.Log($"CitySetup: Created CityGenerator GameObject\n" +
                      $"  - Compute Shader: {computeShader.name}\n" +
                      $"  - Building Mesh: {cubeMesh.name}\n" +
                      $"  - Building Material: {material.name}\n" +
                      $"  - Ramps: Enabled\n" +
                      $"  - Ramp Mesh: {cubeMesh.name}\n" +
                      $"  - Ramp Material: {rampMaterial.name}\n" +
                      $"  - BuildingColliderPool: Added\n" +
                      trackingInfo +
                      $"\nEnter Play mode to generate the city, or use the context menu 'Generate City'.");
        }

        private static Mesh GetDefaultCubeMesh()
        {
            // Create a temporary cube to get Unity's built-in cube mesh
            var tempCube = GameObject.CreatePrimitive(PrimitiveType.Cube);
            var mesh = tempCube.GetComponent<MeshFilter>().sharedMesh;
            Object.DestroyImmediate(tempCube);
            return mesh;
        }

        [MenuItem("HolyRail/Setup City Generator", true)]
        private static bool ValidateSetupCityGenerator()
        {
            // Can always create a new city generator
            return true;
        }
    }
}
