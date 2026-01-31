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

        [Header("Audio")]
        [Tooltip("Sound played when player takes damage")]
        [SerializeField] private AudioClip _damageClip;
        [Tooltip("Sound played when player dies")]
        [SerializeField] private AudioClip _deathClip;
        [Tooltip("Sound played when player acquires an upgrade")]
        [SerializeField] private AudioClip _upgradeClip;
        [SerializeField] private float _audioVolume = 2f;

        public int MaxHealth
        {
            get
            {
                var val = GetUpgradeValue(UpgradeType.PlayerHealth);
                return val > 0 ? Mathf.RoundToInt(val) : 5;
            }
        }

        public int CurrentHealth { get; private set; }

        public int Money
        {
            get => _money;
            set
            {
                _money = value;

                try
                {
                    OnMoneyChanged?.Invoke(_money);
                }
                catch (Exception ex)
                {
                    Debug.LogException(ex);
                }
            }
        }

        private int _money = 0;

        public IReadOnlyList<PlayerUpgrade> Upgrades => new List<PlayerUpgrade>(_upgradeTiers.Keys);

        private readonly Dictionary<PlayerUpgrade, int> _upgradeTiers = new Dictionary<PlayerUpgrade, int>();

        private readonly List<ItemPickup> _activePickups = new List<ItemPickup>();



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
                // Play death sound (limited to 0.5 seconds)
                if (_deathClip != null)
                {
                    PlayClipForDuration(_deathClip, 0.5f, _audioVolume);
                }

                OnPlayerDeath?.Invoke();
            }
            else
            {
                // Play damage sound (only if not dead) - limited to 0.25 seconds, pitched down
                if (_damageClip != null)
                {
                    PlayClipForDuration(_damageClip, 0.25f, _audioVolume, 0.75f);
                }
            }
        }

        private void PlayClipForDuration(AudioClip clip, float duration, float volume, float pitch = 1f)
        {
            var tempGO = new GameObject("TempAudio");
            tempGO.transform.position = Camera.main != null ? Camera.main.transform.position : Vector3.zero;
            var audioSource = tempGO.AddComponent<AudioSource>();
            audioSource.clip = clip;
            audioSource.volume = volume;
            audioSource.pitch = pitch;
            audioSource.Play();
            Destroy(tempGO, duration);
        }

        public void Heal(int amount)
        {
            CurrentHealth = Mathf.Min(CurrentHealth + amount, MaxHealth);
            Debug.Log($"[GameSessionManager] Player healed {amount}. Current Health: {CurrentHealth}");
            OnHealthChanged?.Invoke(CurrentHealth);
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
                _upgradeTiers.Add(upgrade, initialTier);
            }

            // Load audio clips from Resources (since this object is created dynamically)
            if (_damageClip == null)
            {
                _damageClip = Resources.Load<AudioClip>("DamageSound");
            }
            if (_deathClip == null)
            {
                _deathClip = Resources.Load<AudioClip>("DeathSound");
            }
            if (_upgradeClip == null)
            {
                _upgradeClip = Resources.Load<AudioClip>("UpgradeSound");
            }
        }

        public IReadOnlyList<PlayerUpgrade> CurrentShopInventory => _currentShopInventory;

        private List<PlayerUpgrade> _currentShopInventory = new List<PlayerUpgrade>();

        private void Start()
        {
            // Initialize health to max
            ResetHealth();

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
            if (upgrade != null && _upgradeTiers.TryGetValue(upgrade, out int tier))
            {
                return tier;
            }

            return 0;
        }

        public float GetUpgradeValue(UpgradeType upgrade)
        {
            var amount = 0f;
            foreach (var kvp in _upgradeTiers)
            {
                if (kvp.Key.Type != upgrade)
                {
                    continue;
                }
                
                amount += kvp.Key.GetValueForTier(kvp.Value);
            }
            
            return amount;
        }

        public bool UpdatePlayerUpgradeTier(PlayerUpgrade playerUpgrade, int tierLevel)
        {
            if (!playerUpgrade || tierLevel < 0)
            {
                return false;
            }

            if (!_upgradeTiers.ContainsKey(playerUpgrade) || tierLevel > playerUpgrade.MaxTier)
            {
                return false;
            }

            _upgradeTiers[playerUpgrade] = tierLevel;
            
            try
            {
                OnUpgradeListChanged?.Invoke(new List<PlayerUpgrade>(_upgradeTiers.Keys).ToArray());
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

            if (_upgradeTiers.ContainsKey(upgrade))
            {
                // Already owned, try to increase tier
                if (_upgradeTiers[upgrade] < upgrade.MaxTier)
                {
                    _upgradeTiers[upgrade]++;
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
                _upgradeTiers[upgrade] = 1;
            }
        
            try
            {
                OnUpgradeListChanged?.Invoke(new List<PlayerUpgrade>(_upgradeTiers.Keys).ToArray());
            }
            catch(Exception ex)
            {
                Debug.LogException(ex);
            }

            // Play upgrade acquisition sound (limited to 0.5 seconds)
            if (_upgradeClip != null)
            {
                PlayClipForDuration(_upgradeClip, 0.5f, _audioVolume);
            }

            return true;
        }

        public void AddPickup(ItemPickup pickup)
        {
            if (pickup == null) return;
            _activePickups.Add(pickup);
            Debug.Log($"[GameSessionManager] Collected pickup: {pickup.displayName}");
        }

        public void ClearPickups()
        {
            _activePickups.Clear();
            Debug.Log("[GameSessionManager] Cleared all temporary pickups.");
        }
    }
}