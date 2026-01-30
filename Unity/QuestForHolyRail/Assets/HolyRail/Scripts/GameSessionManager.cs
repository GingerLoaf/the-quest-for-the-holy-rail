using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

// Responsible for keeping onto data for the entire game session (from app boot to app close)
// This class will hold onto data that should persist between scene loads like money and upgrades and things of that nature
namespace HolyRail.Scripts
{
    public class GameSessionManager : MonoBehaviour
    {
        public static GameSessionManager Instance { get; private set; }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        private static void InitializeSubsystem()
        {
            if (Instance != null) return;

            var obj = new GameObject("GameSessionManager");
            obj.AddComponent<GameSessionManager>();
            Debug.Log("[System] GameSessionManager subsystem initialized.");
        }

        public Action<PlayerUpgrade[]> OnUpgradeListChanged;

        public Action<int> OnMoneyChanged;

        public Action<int> OnHealthChanged;
        public Action OnPlayerDeath;

        public int MaxHealth
        {
            get
            {
                var val = GetUpgradeValue(UpgradeType.PlayerHealth);
                return val > 0 ? Mathf.RoundToInt(val) : 3;
            }
        }

        public int CurrentHealth { get; private set; }

        public int Money
        {
            get => m_money;
            set
            {
                m_money = value;

                try
                {
                    OnMoneyChanged?.Invoke(m_money);
                }
                catch (Exception ex)
                {
                    Debug.LogException(ex);
                }
            }
        }

        private int m_money = 0;

        public IReadOnlyList<PlayerUpgrade> Upgrades => new List<PlayerUpgrade>(m_upgradeTiers.Keys);

        private Dictionary<PlayerUpgrade, int> m_upgradeTiers = new Dictionary<PlayerUpgrade, int>();

        private List<ItemPickup> m_activePickups = new List<ItemPickup>();



        public void ResetHealth()
        {
            CurrentHealth = MaxHealth;
            OnHealthChanged?.Invoke(CurrentHealth);
        }

        public void TakeDamage(int amount)
        {
            CurrentHealth -= amount;
            Debug.Log($"[GameSessionManager] Player took {amount} damage. Current Health: {CurrentHealth}");
            OnHealthChanged?.Invoke(CurrentHealth);

            if (CurrentHealth <= 0)
            {
                OnPlayerDeath?.Invoke();
            }
        }

        private void Awake()
        {
            // If we already have one in static memory, kill this one
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;

            // Keep this guy alive through scene loads since it holds all our session state
            DontDestroyOnLoad(this);

            // Default all upgrades to tier 0
            foreach (var upgrade in Resources.LoadAll<PlayerUpgrade>(string.Empty))
            {
                // Health starts at Tier 1 (Base Health)
                int initialTier = upgrade.Type == UpgradeType.PlayerHealth ? 1 : 0;
                m_upgradeTiers.Add(upgrade, initialTier);
            }
        }

        public IReadOnlyList<PlayerUpgrade> CurrentShopInventory => _currentShopInventory;

        private List<PlayerUpgrade> _currentShopInventory = new List<PlayerUpgrade>();

        private void Start()
        {
            // Initial inventory generation
            RegenerateShopInventory();
        }

        public void RegenerateShopInventory()
        {
            _currentShopInventory.Clear();

            // Load all available upgrades
            var allUpgrades = Resources.LoadAll<PlayerUpgrade>(string.Empty);
            if (allUpgrades == null || allUpgrades.Length == 0)
            {
                Debug.LogWarning("[GameSessionManager] No upgrades found in Resources!");
                return;
            }

            // Simple shuffle and take 3
            var shuffled = new List<PlayerUpgrade>(allUpgrades);
            for (int i = 0; i < shuffled.Count; i++)
            {
                var temp = shuffled[i];
                int randomIndex = UnityEngine.Random.Range(i, shuffled.Count);
                shuffled[i] = shuffled[randomIndex];
                shuffled[randomIndex] = temp;
            }

            // Take all available
            int count = shuffled.Count;
            for (int i = 0; i < count; i++)
            {
                _currentShopInventory.Add(shuffled[i]);
            }

            Debug.Log($"[GameSessionManager] Regenerated Shop Inventory with {_currentShopInventory.Count} items.");
        }

        public int GetUpgradeTier(PlayerUpgrade upgrade)
        {
            if (upgrade != null && m_upgradeTiers.TryGetValue(upgrade, out int tier))
            {
                return tier;
            }

            return 0;
        }

        public float GetUpgradeValue(UpgradeType upgrade)
        {
            var amount = 0f;
            foreach (var kvp in m_upgradeTiers)
            {
                if (kvp.Key.Type != upgrade)
                {
                    continue;
                }
                
                amount += kvp.Key.GetValueForTier(kvp.Value);
            }

            foreach (var pickup in m_activePickups)
            {
                if (pickup.Type == upgrade)
                {
                    amount += pickup.Value;
                }
            }
            
            return amount;
        }

        public bool UpdatePlayerUpgradeTier(PlayerUpgrade playerUpgrade, int tierLevel)
        {
            if (!playerUpgrade || tierLevel < 0)
            {
                return false;
            }

            if (!m_upgradeTiers.ContainsKey(playerUpgrade) || tierLevel > playerUpgrade.MaxTier)
            {
                return false;
            }

            m_upgradeTiers[playerUpgrade] = tierLevel;
            
            try
            {
                OnUpgradeListChanged?.Invoke(new List<PlayerUpgrade>(m_upgradeTiers.Keys).ToArray());
            }
            catch(Exception ex)
            {
                Debug.LogException(ex);
            }
            
            return true;
        }
        
        public bool AddUpgrade(PlayerUpgrade upgrade)
        {
            Assert.IsNotNull(upgrade);

            if (m_upgradeTiers.ContainsKey(upgrade))
            {
                // Already owned, try to increase tier
                if (m_upgradeTiers[upgrade] < upgrade.MaxTier)
                {
                    m_upgradeTiers[upgrade]++;
                }
                else
                {
                    // Already at max tier
                    return false;
                }
            }
            else
            {
                // New purchase (Tier 1)
                m_upgradeTiers[upgrade] = 1;
            }
        
            try
            {
                OnUpgradeListChanged?.Invoke(new List<PlayerUpgrade>(m_upgradeTiers.Keys).ToArray());
            }
            catch(Exception ex)
            {
                Debug.LogException(ex);
            }

            return true;
        }

        public void AddPickup(ItemPickup pickup)
        {
            if (pickup == null) return;
            m_activePickups.Add(pickup);
            Debug.Log($"[GameSessionManager] Collected pickup: {pickup.DisplayName}");
        }

        public void ClearPickups()
        {
            m_activePickups.Clear();
            Debug.Log("[GameSessionManager] Cleared all temporary pickups.");
        }
    }
}