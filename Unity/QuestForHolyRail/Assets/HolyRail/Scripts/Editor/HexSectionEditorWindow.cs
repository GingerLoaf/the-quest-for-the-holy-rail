using UnityEngine;
using UnityEditor;
using UnityEngine.Splines;
using HolyRail.Scripts.LevelGeneration;

namespace HolyRail.Scripts.LevelGeneration.Editor
{
    public class HexSectionEditorWindow : EditorWindow
    {
        private HexSectionConfig _config;
        private int _seed = 12345;
        private string _prefabName = "HexSection_001";
        private string _savePath = "Assets/HolyRail/Prefabs/HexSections";
        private int _batchCount = 10;

        private HexSection _previewSection;
        private Vector2 _scrollPosition;

        // Cached statistics
        private int _lastRailCount;
        private int _lastRampCount;
        private int _lastObstacleCount;
        private int _lastWallCount;
        private bool _lastHasShop;

        [MenuItem("Holy Rail/Hex Section Editor")]
        public static void ShowWindow()
        {
            var window = GetWindow<HexSectionEditorWindow>("Hex Section Editor");
            window.minSize = new Vector2(350, 600);
        }

        private void OnGUI()
        {
            _scrollPosition = EditorGUILayout.BeginScrollView(_scrollPosition);

            DrawHeader();
            EditorGUILayout.Space(10);
            DrawConfigSection();
            EditorGUILayout.Space(10);
            DrawSeedSection();
            EditorGUILayout.Space(10);
            DrawGenerationButtons();
            EditorGUILayout.Space(10);
            DrawStatisticsSection();
            EditorGUILayout.Space(10);
            DrawSaveSection();
            EditorGUILayout.Space(10);
            DrawBatchSection();
            EditorGUILayout.Space(10);
            DrawHelpSection();

            EditorGUILayout.EndScrollView();
        }

        private void OnDestroy()
        {
            ClearPreview();
        }

        private void DrawHeader()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 16,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("HEX SECTION EDITOR", headerStyle);
            EditorGUILayout.LabelField("Procedural Level Section Generator", EditorStyles.centeredGreyMiniLabel);
            EditorGUILayout.EndVertical();
        }

        private void DrawConfigSection()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Configuration", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            _config = (HexSectionConfig)EditorGUILayout.ObjectField(
                "Config Asset", _config, typeof(HexSectionConfig), false);

            if (_config == null)
            {
                EditorGUILayout.HelpBox(
                    "Assign a HexSectionConfig asset to begin.\n" +
                    "Create one via: Holy Rail > Create Hex Section Config",
                    MessageType.Info);
            }
            else
            {
                EditorGUI.indentLevel++;
                EditorGUILayout.LabelField("Circumradius:", $"{_config.Circumradius:F0}m");
                EditorGUILayout.LabelField("Entry Edge:", _config.EntryEdge.ToString());
                EditorGUILayout.LabelField("Exit Edge:", _config.ExitEdge.ToString());
                EditorGUILayout.LabelField("Rails:", $"{_config.MinRailCount}-{_config.MaxRailCount}");
                EditorGUILayout.LabelField("Shop Chance:", $"{_config.ShopChance * 100f:F1}%");
                EditorGUI.indentLevel--;
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawSeedSection()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Seed", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            EditorGUILayout.BeginHorizontal();
            _seed = EditorGUILayout.IntField("Seed", _seed);
            if (GUILayout.Button("Randomize", GUILayout.Width(80)))
                _seed = Random.Range(0, int.MaxValue);
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();
        }

        private void DrawGenerationButtons()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Generation", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            EditorGUI.BeginDisabledGroup(_config == null);

            GUI.backgroundColor = new Color(0.3f, 0.9f, 0.3f);
            if (GUILayout.Button("GENERATE PREVIEW", GUILayout.Height(40)))
                GeneratePreview();
            GUI.backgroundColor = Color.white;

            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(5);

            EditorGUI.BeginDisabledGroup(_previewSection == null);

            GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
            if (GUILayout.Button("Clear Preview", GUILayout.Height(25)))
                ClearPreview();
            GUI.backgroundColor = Color.white;

            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();
        }

        private void DrawStatisticsSection()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Statistics", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            if (_previewSection == null)
            {
                EditorGUILayout.HelpBox("Generate a preview to see statistics.", MessageType.Info);
            }
            else
            {
                var labelStyle = new GUIStyle(EditorStyles.label);
                var valueStyle = new GUIStyle(EditorStyles.boldLabel)
                {
                    normal = { textColor = new Color(0.3f, 0.8f, 1f) }
                };

                DrawStatRow("Rail Splines:", _lastRailCount.ToString(), labelStyle, valueStyle);
                DrawStatRow("Ramps:", _lastRampCount.ToString(), labelStyle, valueStyle);
                DrawStatRow("Obstacles:", _lastObstacleCount.ToString(), labelStyle, valueStyle);
                DrawStatRow("Wall Rides:", _lastWallCount.ToString(), labelStyle, valueStyle);
                DrawStatRow("Has Shop:", _lastHasShop ? "Yes" : "No", labelStyle, valueStyle);
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawSaveSection()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Save", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            _prefabName = EditorGUILayout.TextField("Prefab Name", _prefabName);
            _savePath = EditorGUILayout.TextField("Save Path", _savePath);

            EditorGUILayout.Space(5);

            EditorGUI.BeginDisabledGroup(_previewSection == null);
            GUI.backgroundColor = new Color(0.3f, 0.7f, 1f);
            if (GUILayout.Button("SAVE AS PREFAB", GUILayout.Height(35)))
                SaveAsPrefab();
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();
        }

        private void DrawBatchSection()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Batch Generation", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            _batchCount = EditorGUILayout.IntField("Count", _batchCount);
            _batchCount = Mathf.Max(1, _batchCount);

            EditorGUILayout.Space(5);

            EditorGUI.BeginDisabledGroup(_config == null);
            GUI.backgroundColor = new Color(1f, 0.7f, 0.2f);
            if (GUILayout.Button("BATCH GENERATE & SAVE", GUILayout.Height(30)))
                BatchGenerate(_batchCount);
            GUI.backgroundColor = Color.white;
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.EndVertical();
        }

        private void DrawHelpSection()
        {
            EditorGUILayout.HelpBox(
                "Hex Section Editor Workflow:\n" +
                "1. Create a HexSectionConfig asset (Holy Rail > Create Hex Section Config)\n" +
                "2. Assign the config and set a seed\n" +
                "3. Click GENERATE PREVIEW to see the section in the Scene View\n" +
                "4. Adjust config parameters and regenerate as needed\n" +
                "5. Click SAVE AS PREFAB when satisfied\n" +
                "6. Use Batch Generate to create multiple variations at once",
                MessageType.None);
        }

        // --- Core Operations ---

        private void GeneratePreview()
        {
            ClearPreview();

            var previewGO = new GameObject($"[Preview] {_prefabName}");
            _previewSection = previewGO.AddComponent<HexSection>();

            HexSectionGenerator.Generate(_previewSection, _config, _seed);

            UpdateStatistics();

            // Focus scene view on the generated section
            Selection.activeGameObject = previewGO;
            SceneView.lastActiveSceneView?.FrameSelected();
        }

        private void ClearPreview()
        {
            if (_previewSection != null)
            {
                DestroyImmediate(_previewSection.gameObject);
                _previewSection = null;
            }
        }

        private void SaveAsPrefab()
        {
            if (_previewSection == null)
                return;

            EnsureDirectoryExists(_savePath);

            string path = $"{_savePath}/{_prefabName}.prefab";

            // Remove the [Preview] prefix for the saved prefab
            _previewSection.gameObject.name = _prefabName;

            var prefab = PrefabUtility.SaveAsPrefabAsset(_previewSection.gameObject, path);
            if (prefab != null)
            {
                Debug.Log($"Saved hex section prefab to: {path}");
                EditorGUIUtility.PingObject(prefab);
            }
            else
            {
                Debug.LogError($"Failed to save prefab to: {path}");
            }

            // Restore preview name
            _previewSection.gameObject.name = $"[Preview] {_prefabName}";
        }

        private void BatchGenerate(int count)
        {
            EnsureDirectoryExists(_savePath);

            int startSeed = _seed;
            int savedCount = 0;

            for (int i = 0; i < count; i++)
            {
                int batchSeed = startSeed + i;
                string batchName = $"HexSection_{i + 1:D3}";
                string path = $"{_savePath}/{batchName}.prefab";

                var tempGO = new GameObject(batchName);
                var tempSection = tempGO.AddComponent<HexSection>();
                HexSectionGenerator.Generate(tempSection, _config, batchSeed);

                var prefab = PrefabUtility.SaveAsPrefabAsset(tempGO, path);
                DestroyImmediate(tempGO);

                if (prefab != null)
                    savedCount++;

                // Show progress
                float progress = (i + 1) / (float)count;
                if (EditorUtility.DisplayCancelableProgressBar(
                    "Batch Generating Hex Sections",
                    $"Generating {batchName} ({i + 1}/{count})",
                    progress))
                {
                    break;
                }
            }

            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
            Debug.Log($"Batch generation complete. Saved {savedCount}/{count} hex section prefabs to {_savePath}");
        }

        private void UpdateStatistics()
        {
            if (_previewSection == null)
                return;

            var splines = _previewSection.GetComponentsInChildren<SplineContainer>();
            _lastRailCount = splines.Length;

            var rampParent = _previewSection.transform.Find("Ramps");
            _lastRampCount = rampParent != null ? rampParent.childCount : 0;

            var obstacleParent = _previewSection.transform.Find("Obstacles");
            _lastObstacleCount = obstacleParent != null ? obstacleParent.childCount : 0;

            var wallParent = _previewSection.transform.Find("WallRideSurfaces");
            _lastWallCount = wallParent != null ? wallParent.childCount : 0;

            _lastHasShop = _previewSection.HasShop;
        }

        private void DrawStatRow(string label, string value, GUIStyle labelStyle, GUIStyle valueStyle)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(label, labelStyle, GUILayout.Width(120));
            EditorGUILayout.LabelField(value, valueStyle);
            EditorGUILayout.EndHorizontal();
        }

        private static void EnsureDirectoryExists(string path)
        {
            if (!AssetDatabase.IsValidFolder(path))
            {
                string[] parts = path.Split('/');
                string current = parts[0];

                for (int i = 1; i < parts.Length; i++)
                {
                    string next = current + "/" + parts[i];
                    if (!AssetDatabase.IsValidFolder(next))
                        AssetDatabase.CreateFolder(current, parts[i]);
                    current = next;
                }
            }
        }
    }
}
