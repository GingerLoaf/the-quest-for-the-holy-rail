using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.City
{
    [ExecuteInEditMode]
    public class BillboardTextureSetup : MonoBehaviour
    {
        [field: SerializeField] public Material BillboardMaterial { get; set; }
        [field: SerializeField] public List<Texture2D> BillboardTextures { get; set; } = new List<Texture2D>();
        [field: SerializeField] public int TextureSize { get; set; } = 256;
        [field: SerializeField] public bool AutoFindTextures { get; set; } = true;

        private Texture2DArray _textureArray;

        private void OnEnable()
        {
            AutoSetup();
        }

        private void Start()
        {
            AutoSetup();
        }

        private void OnDisable()
        {
            if (_textureArray != null)
            {
                if (Application.isPlaying)
                    Destroy(_textureArray);
                else
                    DestroyImmediate(_textureArray);
                _textureArray = null;
            }
        }

        [ContextMenu("Auto Setup")]
        public void AutoSetup()
        {
            // Auto-find material from CityManager if not assigned
            if (BillboardMaterial == null)
            {
                var cityManager = GetComponent<CityManager>();
                if (cityManager == null)
                    cityManager = FindFirstObjectByType<CityManager>();

                if (cityManager != null && cityManager.BillboardMaterial != null)
                {
                    BillboardMaterial = cityManager.BillboardMaterial;
                }
            }

            // Auto-find textures if enabled and list is empty
            if (AutoFindTextures && (BillboardTextures == null || BillboardTextures.Count == 0))
            {
                FindTextures();
            }

            BuildTextureArray();
        }

        private void FindTextures()
        {
#if UNITY_EDITOR
            BillboardTextures = new List<Texture2D>();

            // Search for textures in HolyRail/Textures folder
            string[] searchFolders = new[] { "Assets/HolyRail/Textures" };
            string[] guids = AssetDatabase.FindAssets("t:Texture2D", searchFolders);

            foreach (string guid in guids)
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);

                // Skip normal maps, mask maps, and other non-albedo textures
                string lowerPath = path.ToLower();
                if (lowerPath.Contains("normal") ||
                    lowerPath.Contains("mask") ||
                    lowerPath.Contains("metallic") ||
                    lowerPath.Contains("roughness") ||
                    lowerPath.Contains("occlusion") ||
                    lowerPath.Contains("height") ||
                    lowerPath.Contains("sss") ||
                    lowerPath.Contains("emissive"))
                    continue;

                var tex = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                if (tex != null)
                {
                    BillboardTextures.Add(tex);
                }
            }

            // Also check the Noise subfolder explicitly
            string[] noiseGuids = AssetDatabase.FindAssets("t:Texture2D", new[] { "Assets/HolyRail/Textures/Noise" });
            foreach (string guid in noiseGuids)
            {
                string path = AssetDatabase.GUIDToAssetPath(guid);
                var tex = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                if (tex != null && !BillboardTextures.Contains(tex))
                {
                    BillboardTextures.Add(tex);
                }
            }

            Debug.Log($"BillboardTextureSetup: Found {BillboardTextures.Count} textures");
#endif
        }

        [ContextMenu("Rebuild Texture Array")]
        public void BuildTextureArray()
        {
            if (BillboardMaterial == null || BillboardTextures == null || BillboardTextures.Count == 0)
            {
                if (BillboardMaterial != null)
                {
                    BillboardMaterial.SetFloat("_UseTextures", 0);
                }
                return;
            }

            // Filter out null textures
            var validTextures = new List<Texture2D>();
            foreach (var tex in BillboardTextures)
            {
                if (tex != null)
                    validTextures.Add(tex);
            }

            if (validTextures.Count == 0)
            {
                BillboardMaterial.SetFloat("_UseTextures", 0);
                return;
            }

            // Clean up old array
            if (_textureArray != null)
            {
                if (Application.isPlaying)
                    Destroy(_textureArray);
                else
                    DestroyImmediate(_textureArray);
            }

            // Create the texture array
            _textureArray = new Texture2DArray(
                TextureSize,
                TextureSize,
                validTextures.Count,
                TextureFormat.RGBA32,
                true
            );
            _textureArray.filterMode = FilterMode.Bilinear;
            _textureArray.wrapMode = TextureWrapMode.Repeat;

            // Copy each texture into the array
            for (int i = 0; i < validTextures.Count; i++)
            {
                var sourceTex = validTextures[i];

                // Create a temporary RenderTexture to resize
                var rt = RenderTexture.GetTemporary(TextureSize, TextureSize, 0, RenderTextureFormat.ARGB32);
                Graphics.Blit(sourceTex, rt);

                // Read back the resized texture
                var resized = new Texture2D(TextureSize, TextureSize, TextureFormat.RGBA32, false);
                var prevActive = RenderTexture.active;
                RenderTexture.active = rt;
                resized.ReadPixels(new Rect(0, 0, TextureSize, TextureSize), 0, 0);
                resized.Apply();
                RenderTexture.active = prevActive;
                RenderTexture.ReleaseTemporary(rt);

                // Copy to array slice
                Graphics.CopyTexture(resized, 0, 0, _textureArray, i, 0);

                if (Application.isPlaying)
                    Destroy(resized);
                else
                    DestroyImmediate(resized);
            }

            _textureArray.Apply();

            // Assign to material
            BillboardMaterial.SetTexture("_TextureArray", _textureArray);
            BillboardMaterial.SetFloat("_TextureCount", validTextures.Count);
            BillboardMaterial.SetFloat("_UseTextures", 1);

            Debug.Log($"BillboardTextureSetup: Created texture array with {validTextures.Count} textures at {TextureSize}x{TextureSize}");
        }
    }
}
