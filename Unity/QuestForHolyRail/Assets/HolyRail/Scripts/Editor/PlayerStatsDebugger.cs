using UnityEngine;
using UnityEditor;
using HolyRail.Scripts;
using HolyRail.Scripts.Enemies;
using HolyRail.Graffiti;
using StarterAssets;
using UnityEngine.Rendering.Universal;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace HolyRail.Scripts.Editor
{
    public class PlayerStatsDebugger : EditorWindow
    {
        private List<PlayerUpgrade> _upgrades = new List<PlayerUpgrade>();
        private Dictionary<PlayerUpgrade, int> _upgradeTiers = new Dictionary<PlayerUpgrade, int>();
        
        // Base values preservation
        private Dictionary<int, Vector3> _baseDecalSizes = new Dictionary<int, Vector3>(); // InstanceID -> Size

        private EnemySpawner _spawner;
        private bool _initialized;
        private Vector2 _scrollPos;

        [MenuItem("Tools/Player Stats Debugger")]
        public static void ShowWindow()
        {
            GetWindow<PlayerStatsDebugger>("Upgrade Debugger");
        }

        private void OnEnable()
        {
            LoadUpgrades();
            EditorApplication.playModeStateChanged += OnPlayModeStateChanged;
            EditorApplication.hierarchyChanged += OnHierarchyChanged;
        }

        private void OnDisable()
        {
            EditorApplication.playModeStateChanged -= OnPlayModeStateChanged;
            EditorApplication.hierarchyChanged -= OnHierarchyChanged;
        }

        private void OnPlayModeStateChanged(PlayModeStateChange state)
        {
            if (state == PlayModeStateChange.EnteredPlayMode)
            {
                // Reset initialization to capture new runtime base values
                _initialized = false;
                _baseDecalSizes.Clear();
            }
        }

        private void OnHierarchyChanged()
        {
            if (Application.isPlaying)
            {
                // Re-find references if scene changed
                FindReferences();
            }
        }

        private void LoadUpgrades()
        {
            _upgrades.Clear();
            var loaded = Resources.LoadAll<PlayerUpgrade>(string.Empty);
            if (loaded != null)
            {
                _upgrades.AddRange(loaded);
                _upgrades.Sort((a, b) => a.Type.CompareTo(b.Type));
            }

            // Initialize tiers dictionary
            foreach (var up in _upgrades)
            {
                if (!_upgradeTiers.ContainsKey(up))
                {
                    _upgradeTiers[up] = 0;
                }
            }
        }

        private void OnGUI()
        {
            if (!Application.isPlaying)
            {
                EditorGUILayout.HelpBox("Please enter Play Mode to debug stats.", MessageType.Info);
                return;
            }

            if (!_initialized)
            {
                if (GUILayout.Button("Initialize Debugger"))
                {
                    FindReferences();
                }
                return;
            }

            _scrollPos = EditorGUILayout.BeginScrollView(_scrollPos);

            GUILayout.Label("Available Upgrades", EditorStyles.boldLabel);
            EditorGUILayout.Space();

            if (_upgrades.Count == 0)
            {
                EditorGUILayout.HelpBox("No PlayerUpgrade assets found in Resources!", MessageType.Warning);
                if (GUILayout.Button("Reload Upgrades")) LoadUpgrades();
                EditorGUILayout.EndScrollView();
                return;
            }

            EditorGUI.BeginChangeCheck();

            foreach (var upgrade in _upgrades)
            {
                if (upgrade == null) continue;

                EditorGUILayout.BeginVertical(EditorStyles.helpBox);
                
                EditorGUILayout.LabelField(upgrade.DisplayName, EditorStyles.boldLabel);

                int currentTier = _upgradeTiers.ContainsKey(upgrade) ? _upgradeTiers[upgrade] : 0;
                
                // Show raw value for current tier
                float rawValue = upgrade.GetValueForTier(currentTier);
                
                // Also calculate cumulative for information
                float cumulative = 0f;
                for(int i=1; i<=currentTier; i++) cumulative += upgrade.GetValueForTier(i);

                EditorGUILayout.LabelField(string.Format("{0} | Tier: {1}/{2}", 
                    upgrade.Type, currentTier, upgrade.MaxTier), EditorStyles.miniLabel);
                EditorGUILayout.LabelField(string.Format("Raw Value: {0:F3} | Cumulative: {1:F3}", rawValue, cumulative), EditorStyles.miniLabel);
                
                int newTier = EditorGUILayout.IntSlider("Tier", currentTier, 0, upgrade.MaxTier);
                
                if (newTier != currentTier)
                {
                    _upgradeTiers[upgrade] = newTier;
                }

                EditorGUILayout.BeginHorizontal();
                if (GUILayout.Button("Disable (Tier 0)", EditorStyles.miniButtonLeft))
                {
                    _upgradeTiers[upgrade] = 0;
                }
                if (GUILayout.Button(string.Format("Max (Tier {0})", upgrade.MaxTier), EditorStyles.miniButtonRight))
                {
                    _upgradeTiers[upgrade] = upgrade.MaxTier;
                }
                EditorGUILayout.EndHorizontal();

                EditorGUILayout.EndVertical();
                EditorGUILayout.Space(5);
            }

            if (EditorGUI.EndChangeCheck())
            {
                ApplyUpgrades();
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("Reset All to Tier 0"))
            {
                ResetAll();
            }

            EditorGUILayout.Space(10);
            GUILayout.Label("Debug Spawning", EditorStyles.boldLabel);
            if (GUILayout.Button("Spawn Health Pickup"))
            {
                SpawnHealthPickup();
            }

            EditorGUILayout.EndScrollView();
        }

        private void SpawnHealthPickup()
        {
            if (ThirdPersonController_RailGrinder.Instance == null)
            {
                Debug.LogWarning("Player controller not found.");
                return;
            }

            var player = ThirdPersonController_RailGrinder.Instance;
            var field = typeof(ThirdPersonController_RailGrinder).GetField("_healthPickupPrefab", BindingFlags.NonPublic | BindingFlags.Instance);
            if (field != null)
            {
                var prefab = field.GetValue(player) as GameObject;
                if (prefab != null)
                {
                    Vector3 spawnPos = player.transform.position + player.transform.forward * 2f + Vector3.up;
                    Instantiate(prefab, spawnPos, Quaternion.identity);
                    Debug.Log("Spawned Health Pickup via Debugger");
                }
                else
                {
                    Debug.LogWarning("Health Pickup Prefab is missing on the Player Controller.");
                }
            }
        }

        private void FindReferences()
        {
            _spawner = FindFirstObjectByType<EnemySpawner>();
            
            // Capture initial states of any graffiti spots
            var spots = FindObjectsByType<GraffitiSpot>(FindObjectsSortMode.None);
            foreach (var spot in spots)
            {
                if (spot.DecalProjector != null)
                {
                    int id = spot.DecalProjector.GetInstanceID();
                    if (!_baseDecalSizes.ContainsKey(id))
                    {
                        _baseDecalSizes[id] = spot.DecalProjector.size;
                    }
                }
            }

            _initialized = true; // Even if spawner is null, we can still set GameSessionManager
        }

        private void ResetAll()
        {
            var keys = new List<PlayerUpgrade>(_upgradeTiers.Keys);
            foreach (var key in keys)
            {
                _upgradeTiers[key] = 0;
            }
            ApplyUpgrades();
        }

        private void ApplyUpgrades()
        {
            // 1. Sync to GameSessionManager (The Source of Truth)
            if (GameSessionManager.Instance != null)
            {
                var type = typeof(GameSessionManager);
                var field = type.GetField("m_upgradeTiers", BindingFlags.NonPublic | BindingFlags.Instance);
                
                if (field != null)
                {
                    foreach (var kvp in _upgradeTiers)
                    {
                        GameSessionManager.Instance.UpdatePlayerUpgradeTier(kvp.Key, kvp.Value);
                    }
                }
                
                // Trigger event so ShopUI or others update
                if (GameSessionManager.Instance.OnUpgradeListChanged != null)
                {
                     GameSessionManager.Instance.OnUpgradeListChanged.Invoke(_upgradeTiers.Keys.ToArray());
                }
            }

            // 2. Apply Visuals/Logic for things NOT handled by GameSessionManager yet
            
            // SPRAY (Cumulative logic preserved for visual testing)
            Dictionary<UpgradeType, float> cumulativeMultipliers = new Dictionary<UpgradeType, float>();
            foreach (UpgradeType type in System.Enum.GetValues(typeof(UpgradeType)))
            {
                cumulativeMultipliers[type] = 0f;
            }

            foreach (var kvp in _upgradeTiers)
            {
                if (kvp.Value > 0)
                {
                    float bonus = 0f;
                    for(int i=1; i<=kvp.Value; i++) bonus += kvp.Key.GetValueForTier(i);
                    cumulativeMultipliers[kvp.Key.Type] += bonus;
                }
            }

            // Apply SPRAY Upgrades
            var spots = FindObjectsByType<GraffitiSpot>(FindObjectsSortMode.None);
            float radiusBonus = cumulativeMultipliers[UpgradeType.SprayPaintRadius];
            
            foreach (var spot in spots)
            {
                if (spot.DecalProjector == null) continue;
                
                int id = spot.DecalProjector.GetInstanceID();
                if (!_baseDecalSizes.ContainsKey(id))
                {
                    _baseDecalSizes[id] = spot.DecalProjector.size; 
                }

                Vector3 baseSize = _baseDecalSizes[id];
                Vector3 newSize = new Vector3(
                    baseSize.x * (1f + radiusBonus),
                    baseSize.y * (1f + radiusBonus),
                    baseSize.z
                );
                
                spot.DecalProjector.size = newSize;
            }
            
            // Note: Parry is NOT applied here because ThirdPersonController_RailGrinder 
            // reads directly from GameSessionManager.Instance.GetUpgradeValue() on every parry.
        }
    }
}