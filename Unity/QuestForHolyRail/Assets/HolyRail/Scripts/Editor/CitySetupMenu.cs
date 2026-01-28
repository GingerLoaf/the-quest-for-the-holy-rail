using UnityEngine;
using UnityEditor;
using HolyRail.City;

namespace HolyRail.City.Editor
{
    public static class CitySetupMenu
    {
        private const string MaterialPath = "Assets/HolyRail/Materials/CityBuildings.mat";
        private const string ShaderPath = "Assets/HolyRail/Shaders/BuildingInstanced.shader";
        private const string RampMaterialPath = "Assets/HolyRail/Materials/RampMaterial.mat";
        private const string RampShaderPath = "Assets/HolyRail/Shaders/RampInstanced.shader";

        [MenuItem("HolyRail/Setup City Generator")]
        public static void SetupCityGenerator()
        {
            // 1. Load or create building material
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

            // 3. Get default cube mesh
            var cubeMesh = GetDefaultCubeMesh();
            if (cubeMesh == null)
            {
                Debug.LogError("CitySetup: Could not find default cube mesh");
                return;
            }

            // 4. Create CityGenerator GameObject with corridor layout children
            var cityGO = new GameObject("CityGenerator");
            var cityManager = cityGO.AddComponent<CityManager>();

            // 5. Create corridor layout GameObjects as children
            var convergenceGO = new GameObject("ConvergencePoint");
            convergenceGO.transform.SetParent(cityGO.transform);
            convergenceGO.transform.localPosition = Vector3.zero;

            var endpointA = new GameObject("EndpointA");
            endpointA.transform.SetParent(cityGO.transform);
            endpointA.transform.localPosition = new Vector3(0, 0, 300); // North

            var endpointB = new GameObject("EndpointB");
            endpointB.transform.SetParent(cityGO.transform);
            endpointB.transform.localPosition = new Vector3(-260, 0, -150); // Southwest

            var endpointC = new GameObject("EndpointC");
            endpointC.transform.SetParent(cityGO.transform);
            endpointC.transform.localPosition = new Vector3(260, 0, -150); // Southeast

            // 6. Use SerializedObject to set the private setter properties
            var serializedObject = new SerializedObject(cityManager);

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

            // Set corridor layout transforms
            var convergenceProp = serializedObject.FindProperty("<ConvergencePoint>k__BackingField");
            if (convergenceProp != null)
            {
                convergenceProp.objectReferenceValue = convergenceGO.transform;
            }

            var endpointAProp = serializedObject.FindProperty("<EndpointA>k__BackingField");
            if (endpointAProp != null)
            {
                endpointAProp.objectReferenceValue = endpointA.transform;
            }

            var endpointBProp = serializedObject.FindProperty("<EndpointB>k__BackingField");
            if (endpointBProp != null)
            {
                endpointBProp.objectReferenceValue = endpointB.transform;
            }

            var endpointCProp = serializedObject.FindProperty("<EndpointC>k__BackingField");
            if (endpointCProp != null)
            {
                endpointCProp.objectReferenceValue = endpointC.transform;
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

            // 7. Add BuildingColliderPool component
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

            // 8. Register undo and select
            Undo.RegisterCreatedObjectUndo(cityGO, "Create City Generator");
            Selection.activeGameObject = cityGO;

            // 9. Log success
            var trackingInfo = trackingTarget != null
                ? $"  - Tracking Target: {trackingTarget.name}\n"
                : "  - Tracking Target: Not found (assign manually)\n";

            Debug.Log($"CitySetup: Created CityGenerator with corridor layout\n" +
                      $"  - Building Mesh: {cubeMesh.name}\n" +
                      $"  - Building Material: {material.name}\n" +
                      $"  - Convergence Point: Created at origin\n" +
                      $"  - Endpoint A: Created at (0, 0, 300)\n" +
                      $"  - Endpoint B: Created at (-260, 0, -150)\n" +
                      $"  - Endpoint C: Created at (260, 0, -150)\n" +
                      $"  - Ramps: Enabled\n" +
                      $"  - Ramp Mesh: {cubeMesh.name}\n" +
                      $"  - Ramp Material: {rampMaterial.name}\n" +
                      $"  - BuildingColliderPool: Added\n" +
                      trackingInfo +
                      $"\nMove the endpoint GameObjects to define corridor destinations, then click 'GENERATE CITY' in the inspector.");
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
