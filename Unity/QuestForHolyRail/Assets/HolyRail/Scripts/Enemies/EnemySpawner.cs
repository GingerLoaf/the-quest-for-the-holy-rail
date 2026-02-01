using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using HolyRail.Scripts;
using StarterAssets;

namespace HolyRail.Scripts.Enemies
{
    // Trigger-based zone spawner - spawns enemies when player enters trigger zone
    [System.Serializable]
    public class SpawnableEnemy
    {
        public GameObject Prefab;
        public int PoolSize;              // Total count to spawn for this spawner instance
        [Range(0f, 1f)]
        public float SpawnWeight;
        public int MaxActiveEnemies = 3;  // Max concurrent for this enemy type
    }

    [RequireComponent(typeof(BoxCollider))]
    public class EnemySpawner : MonoBehaviour
    {
        // Static registry of all active spawners for cross-spawner queries
        private static readonly List<EnemySpawner> _allSpawners = new();

        // Clear stale references when entering play mode (handles domain reload disabled)
        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
        private static void ClearStaticReferences()
        {
            _allSpawners.Clear();
        }

        /// <summary>
        /// Gets the first active spawner (for backwards compatibility with systems expecting a single spawner).
        /// Prefer using static methods like GetAllBulletsInParryRangeFromAll() for multi-spawner support.
        /// </summary>
        public static EnemySpawner Instance => _allSpawners.Count > 0 ? _allSpawners[0] : null;

        /// <summary>
        /// Gets all active EnemySpawner instances in the scene.
        /// </summary>
        public static IReadOnlyList<EnemySpawner> AllSpawners => _allSpawners;

        [Header("Prefab References")]
        [field: Tooltip("A list of all enemy types that can be spawned.")]
        [field: SerializeField]
        public List<SpawnableEnemy> EnemyTypes { get; private set; }

        [field: Tooltip("The bullet prefab that bots fire")]
        [field: SerializeField]
        public GameObject BulletPrefab { get; private set; }

        [Header("Player Reference")]
        [field: Tooltip("The player transform to track for spawning and targeting")]
        [field: SerializeField]
        public Transform Player { get; private set; }

        [Header("Spawn Volume")]
        [field: Tooltip("How far ahead of the player (in Z) to spawn enemies")]
        [field: SerializeField]
        public float SpawnOffsetZ { get; private set; } = 30f;

        [field: Tooltip("Width of the spawn area (X axis)")]
        [field: SerializeField]
        public float SpawnWidth { get; private set; } = 20f;

        [field: Tooltip("Height of the spawn area (Y axis, above player)")]
        [field: SerializeField]
        public float SpawnHeight { get; private set; } = 5f;

        [field: Tooltip("Depth of the spawn area (Z axis)")]
        [field: SerializeField]
        public float SpawnDepth { get; private set; } = 10f;


        [Header("Pool Sizes")]
        [field: Tooltip("Total bullet instances to pre-allocate in the pool")]
        [field: SerializeField]
        public int BulletPoolSize { get; private set; } = 50;

        [Header("Bullet Settings")]
        [field: Tooltip("Base travel speed of bullets (added to player speed for guaranteed catch-up)")]
        [field: SerializeField]
        public float BulletSpeed { get; private set; } = 20f;

        [field: Tooltip("If true, bullet speed = player speed + base speed (guarantees bullets always catch up)")]
        [field: SerializeField]
        public bool BulletSpeedScalesWithPlayer { get; private set; } = true;

        [field: Tooltip("If true, bullets will knock the player off rails when hit")]
        [field: SerializeField]
        public bool BulletsKnockOffRail { get; private set; } = true;

        [field: Tooltip("Maximum time in seconds before bullets are automatically recycled")]
        [field: SerializeField]
        public float BulletLifetime { get; private set; } = 8f;

        [field: Tooltip("Legacy setting - bullets now always track directly to player")]
        [field: SerializeField, Range(0f, 1f)]
        public float BulletHomingAmount { get; private set; } = 1f;

        [field: Tooltip("How fast bullets flash when in parry zone (cycles per second)")]
        [field: SerializeField]
        public float ParryFlashSpeed { get; private set; } = 10f;

        [field: Tooltip("Minimum brightness multiplier during parry flash")]
        [field: SerializeField]
        public float ParryFlashMin { get; private set; } = 1f;

        [field: Tooltip("Maximum brightness multiplier during parry flash")]
        [field: SerializeField]
        public float ParryFlashMax { get; private set; } = 8f;

        [Header("ShooterBot Settings")]
        [field: Tooltip("Seconds between each shot fired by ShooterBots")]
        [field: SerializeField]
        public float ShooterBotFireRate { get; private set; } = 1.5f;

        [field: Tooltip("ShooterBots only fire when player is within this distance")]
        [field: SerializeField]
        public float ShooterBotFiringRange { get; private set; } = 30f;

        [Header("Constant Spawn Mode")]
        [field: Tooltip("Enable to spawn enemies continuously without using EnemyController")]
        [field: SerializeField]
        public bool UseConstantSpawnMode { get; private set; } = false;

        [field: Tooltip("Seconds between spawns in constant mode")]
        [field: SerializeField]
        public float SpawnInterval { get; private set; } = 2f;


        [Header("Parry Settings")]
        [field: Tooltip("Distance from player at which bullets can be parried (should be larger than hit radius)")]
        [field: SerializeField]
        public float ParryThresholdDistance { get; private set; } = 12f;

        [field: Tooltip("Duration of the parry window after input (larger = more forgiving)")]
        [field: SerializeField]
        public float ParryWindowDuration { get; private set; } = 0.6f;

        [field: Tooltip("Explosion effect prefab spawned when a bot is killed by deflection")]
        [field: SerializeField]
        public GameObject ExplosionEffectPrefab { get; private set; }

        [Header("On All Defeated")]
        [SerializeField] private bool _moveObjectWhenAllDefeated;
        [SerializeField] private GameObject _objectToMoveOnDefeat;
        [SerializeField] private Vector3 _defeatMovePosition;
        [SerializeField] private GameObject[] _objectsToMoveOnDefeat;
        [SerializeField] private Vector3 _objectsDefeatMovePosition;

        private Dictionary<GameObject, Queue<BaseEnemyBot>> _enemyPools;
        private Dictionary<int, GameObject> _instanceIdToPrefabMap;
        private Queue<EnemyBullet> _bulletPool;
        private List<BaseEnemyBot> _activeBots;
        private List<EnemyBullet> _activeBullets = new();
        private float _totalSpawnWeight;
        private float _spawnTimer;

        // Trigger-based spawning tracking
        private bool _hasBeenTriggered = false;
        private Dictionary<GameObject, int> _totalSpawnedCount;
        private Dictionary<GameObject, int> _activeCount;

        private void Awake()
        {
            // Register this spawner in the static registry
            _allSpawners.Add(this);

            InitializePools();

            // Ensure BoxCollider is set as trigger
            var boxCollider = GetComponent<BoxCollider>();
            if (boxCollider != null)
            {
                boxCollider.isTrigger = true;
            }
        }

        private void OnDestroy()
        {
            // Unregister this spawner from the static registry
            _allSpawners.Remove(this);
        }

        private void Start()
        {
            if (GameSessionManager.Instance != null)
            {
                float accuracyBonus = GameSessionManager.Instance.GetUpgradeValue(UpgradeType.ParryAccuracy);
                if (accuracyBonus > 0)
                {
                    // Increase threshold by percentage (e.g. 1.0 = +100%)
                    ParryThresholdDistance *= (1.0f + accuracyBonus);
                    Debug.Log($"EnemySpawner: Applied ParryAccuracy upgrade (+{accuracyBonus * 100:F0}%). New Threshold: {ParryThresholdDistance}");
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                _hasBeenTriggered = true;
            }
        }

        private void OnValidate()
        {
            // Recalculate total spawn weight when EnemyTypes are modified
            if (EnemyTypes != null)
            {
                _totalSpawnWeight = EnemyTypes.Sum(e => e.SpawnWeight);
            }

            // Log parameter changes during runtime for debugging
            if (Application.isPlaying)
            {
                Debug.Log($"EnemySpawner: Parameters updated - BulletSpeed={BulletSpeed}, ShooterBotFireRate={ShooterBotFireRate}s, ShooterBotFiringRange={ShooterBotFiringRange}m, TotalSpawnWeight={_totalSpawnWeight}");
            }
        }

        [ContextMenu("Debug: Reset All ShooterBot Fire Timers")]
        public void DebugResetFireTimers()
        {
            if (!Application.isPlaying)
            {
                Debug.LogWarning("Must be in Play mode");
                return;
            }

            int count = 0;
            foreach (var bot in _activeBots)
            {
                if (bot is ShooterBot shooter)
                {
                    shooter.ResetFireTimer();
                    count++;
                }
            }
            Debug.Log($"EnemySpawner: Reset fire timers on {count} ShooterBots - they will fire immediately");
        }

        [ContextMenu("Debug: Log Pool Status")]
        public void DebugLogPoolStatus()
        {
            if (_enemyPools == null)
            {
                Debug.Log("EnemySpawner: Pools not initialized yet");
                return;
            }

            Debug.Log($"=== EnemySpawner Pool Status ===");
            Debug.Log($"Active bots: {_activeBots?.Count ?? 0}");
            Debug.Log($"Active bullets: {_activeBullets?.Count ?? 0}");
            Debug.Log($"Bullet pool available: {_bulletPool?.Count ?? 0}");

            foreach (var kvp in _enemyPools)
            {
                Debug.Log($"Pool [{kvp.Key.name}]: {kvp.Value.Count} available");
            }
        }

        [ContextMenu("Debug: Force Spawn Bullet (Test)")]
        public void DebugForceSpawnBullet()
        {
            if (!Application.isPlaying)
            {
                Debug.LogWarning("Must be in Play mode to test bullet spawning");
                return;
            }

            if (!Player)
            {
                Debug.LogError("No player reference!");
                return;
            }

            Vector3 spawnPos = Player.position + Vector3.forward * 10f + Vector3.up * 2f;
            Vector3 direction = (Player.position - spawnPos).normalized;
            Debug.Log($"DebugForceSpawnBullet: Spawning at {spawnPos} toward {Player.position}");
            SpawnBullet(spawnPos, direction, null);
        }

        private void InitializePools()
        {
            _enemyPools = new Dictionary<GameObject, Queue<BaseEnemyBot>>();
            _instanceIdToPrefabMap = new Dictionary<int, GameObject>();
            _bulletPool = new Queue<EnemyBullet>();
            _activeBots = new List<BaseEnemyBot>();
            _totalSpawnedCount = new Dictionary<GameObject, int>();
            _activeCount = new Dictionary<GameObject, int>();

            foreach (var enemyType in EnemyTypes)
            {
                if (enemyType.Prefab == null)
                {
                    Debug.LogError("EnemySpawner: Enemy prefab is null in EnemyTypes list!");
                    continue;
                }

                var pool = new Queue<BaseEnemyBot>();
                for (int i = 0; i < enemyType.PoolSize; i++)
                {
                    var botObj = Instantiate(enemyType.Prefab, transform);
                    var bot = botObj.GetComponent<BaseEnemyBot>();
                    if (bot == null)
                    {
                        Debug.LogError($"EnemySpawner: Prefab {enemyType.Prefab.name} missing BaseEnemyBot component!");
                        Destroy(botObj);
                        continue;
                    }
                    bot.Initialize(this);
                    botObj.SetActive(false);
                    pool.Enqueue(bot);
                }
                _enemyPools.Add(enemyType.Prefab, pool);
                Debug.Log($"EnemySpawner: Created pool for {enemyType.Prefab.name} with {pool.Count} bots (weight: {enemyType.SpawnWeight})");
            }

            _totalSpawnWeight = EnemyTypes.Sum(e => e.SpawnWeight);
            Debug.Log($"EnemySpawner: Total spawn weight = {_totalSpawnWeight}");

            if (BulletPrefab == null)
            {
                Debug.LogError("EnemySpawner: BulletPrefab is not assigned!");
            }
            else
            {
                for (int i = 0; i < BulletPoolSize; i++)
                {
                    var bulletObj = Instantiate(BulletPrefab, transform);
                    var bullet = bulletObj.GetComponent<EnemyBullet>();
                    bullet.Initialize(this);
                    bulletObj.SetActive(false);
                    _bulletPool.Enqueue(bullet);
                }
                Debug.Log($"EnemySpawner: Created bullet pool with {_bulletPool.Count} bullets");
            }
        }

        private void Update()
        {
            // Auto-find Player reference if null
            if (!Player)
            {
                var playerController = ThirdPersonController_RailGrinder.Instance;
                if (playerController != null)
                {
                    Player = playerController.transform;
                }
                else
                {
                    return; // Still no player, skip this frame
                }
            }

            // Check bullet proximity for parry threshold
            foreach (var bullet in _activeBullets)
            {
                if (bullet == null || !bullet.gameObject.activeInHierarchy) continue;
                float dist = Vector3.Distance(bullet.transform.position, Player.position);
                bullet.SetInParryThreshold(dist <= ParryThresholdDistance);
            }

            // Distance-based trigger fallback (works when CharacterController disabled during grinding)
            if (!_hasBeenTriggered && UseConstantSpawnMode)
            {
                if (Player.position.z >= transform.position.z)
                {
                    _hasBeenTriggered = true;
                    Debug.Log("[EnemySpawner] Triggered via distance check");
                }
            }

            // Constant spawn mode - only spawns after player enters trigger zone
            if (UseConstantSpawnMode && _hasBeenTriggered)
            {
                _spawnTimer -= Time.deltaTime;
                if (_spawnTimer <= 0f && CanSpawnAny())
                {
                    SpawnBot();
                    _spawnTimer = SpawnInterval;
                }
            }
        }

        private bool CanSpawnAny()
        {
            foreach (var enemyType in EnemyTypes)
            {
                if (enemyType.SpawnWeight <= 0f) continue;
                var prefab = enemyType.Prefab;
                int spawned = _totalSpawnedCount.GetValueOrDefault(prefab, 0);
                int active = _activeCount.GetValueOrDefault(prefab, 0);
                if (spawned < enemyType.PoolSize && active < enemyType.MaxActiveEnemies)
                    return true;
            }
            return false;
        }

        public void SpawnBot()
        {
            if (_enemyPools == null) return;

            var chosenPrefab = GetRandomEnemyPrefab();
            if (!chosenPrefab) return;

            if (!_enemyPools.TryGetValue(chosenPrefab, out var pool))
            {
                Debug.LogError($"EnemySpawner: No pool found for prefab {chosenPrefab.name}");
                return;
            }

            if (pool.Count == 0)
            {
                Debug.LogWarning($"EnemySpawner: Pool empty for {chosenPrefab.name}, trying another type");
                // Try other enemy types (respecting spawn weights)
                foreach (var enemyType in EnemyTypes)
                {
                    // Skip enemies with zero weight - they should never spawn
                    if (enemyType.SpawnWeight <= 0f) continue;

                    if (_enemyPools.TryGetValue(enemyType.Prefab, out var altPool) && altPool.Count > 0)
                    {
                        pool = altPool;
                        chosenPrefab = enemyType.Prefab;
                        break;
                    }
                }
                if (pool.Count == 0)
                {
                    Debug.LogWarning("EnemySpawner: All pools empty, cannot spawn");
                    return;
                }
            }

            var bot = pool.Dequeue();
            _instanceIdToPrefabMap.Add(bot.gameObject.GetInstanceID(), chosenPrefab);

            // Track spawn counts for trigger-based limits
            _totalSpawnedCount[chosenPrefab] = _totalSpawnedCount.GetValueOrDefault(chosenPrefab, 0) + 1;
            _activeCount[chosenPrefab] = _activeCount.GetValueOrDefault(chosenPrefab, 0) + 1;

            var spawnPos = GetRandomSpawnPosition();
            bot.transform.position = spawnPos;

            bot.OnSpawn();
            bot.gameObject.SetActive(true);
            _activeBots.Add(bot);
        }

        /// <summary>
        /// Spawns an enemy for the EnemyController at a specified position.
        /// Enemy will fly in from offscreen to the final position.
        /// </summary>
        public BaseEnemyBot SpawnEnemy(GameObject enemyPrefab, Vector3 finalPosition, bool startsIdle, float enterDuration)
        {
            if (!_enemyPools.TryGetValue(enemyPrefab, out var pool))
            {
                Debug.LogError($"EnemySpawner: No pool found for prefab {enemyPrefab.name}");
                return null;
            }

            if (pool.Count == 0)
            {
                Debug.LogWarning($"EnemySpawner: Pool empty for {enemyPrefab.name}");
                return null;
            }

            var bot = pool.Dequeue();
            _instanceIdToPrefabMap.Add(bot.gameObject.GetInstanceID(), enemyPrefab);

            // Calculate offscreen position (behind player)
            Vector3 offscreenPos = finalPosition;
            if (Player != null)
            {
                offscreenPos = finalPosition - Player.forward * 30f;
            }

            bot.transform.position = offscreenPos;
            bot.OnSpawn(startsIdle, finalPosition, enterDuration);
            bot.gameObject.SetActive(true);
            _activeBots.Add(bot);

            return bot;
        }

        private GameObject GetRandomEnemyPrefab()
        {
            // Build list of spawnable types (not exhausted, not at max active)
            var available = new List<(SpawnableEnemy enemy, float weight)>();
            float totalWeight = 0f;

            foreach (var enemyType in EnemyTypes)
            {
                if (enemyType.SpawnWeight <= 0f) continue;
                var prefab = enemyType.Prefab;
                int spawned = _totalSpawnedCount.GetValueOrDefault(prefab, 0);
                int active = _activeCount.GetValueOrDefault(prefab, 0);

                if (spawned < enemyType.PoolSize && active < enemyType.MaxActiveEnemies)
                {
                    available.Add((enemyType, enemyType.SpawnWeight));
                    totalWeight += enemyType.SpawnWeight;
                }
            }

            if (available.Count == 0 || totalWeight <= 0) return null;

            float randomValue = Random.Range(0, totalWeight);
            float cumulative = 0f;
            foreach (var (enemy, weight) in available)
            {
                cumulative += weight;
                if (randomValue < cumulative)
                    return enemy.Prefab;
            }
            return null;
        }

        private Vector3 GetRandomSpawnPosition()
        {
            // Spawn box tracks with player position - always spawns ahead of player
            float x = Player.position.x + Random.Range(-SpawnWidth / 2f, SpawnWidth / 2f);
            float y = Player.position.y + Random.Range(0f, SpawnHeight);
            float z = Player.position.z + SpawnOffsetZ + Random.Range(0f, SpawnDepth);

            return new Vector3(x, y, z);
        }

        public void RecycleBot(BaseEnemyBot bot)
        {
            RecycleBot(bot, false);
        }

        public void RecycleBot(BaseEnemyBot bot, bool killedByPlayer)
        {
            if (!bot)
            {
                return;
            }

            // Award score if killed by player
            if (killedByPlayer && ScoreManager.Instance != null)
            {
                ScoreManager.Instance.AwardEnemyDestroyed();
            }

            bot.OnRecycle();
            bot.gameObject.SetActive(false);
            _activeBots.Remove(bot);

            int instanceId = bot.gameObject.GetInstanceID();
            if (_instanceIdToPrefabMap.TryGetValue(instanceId, out GameObject prefab))
            {
                // Decrement active count for trigger-based limits
                _activeCount[prefab] = Mathf.Max(0, _activeCount.GetValueOrDefault(prefab, 0) - 1);

                _enemyPools[prefab].Enqueue(bot);
                _instanceIdToPrefabMap.Remove(instanceId);
            }
            else
            {
                Debug.LogWarning("Trying to recycle a bot that was not spawned from the pool.", bot.gameObject);
                Destroy(bot.gameObject);
            }

            // Check if all enemies have been defeated
            if (killedByPlayer &&
                _activeBots.Count == 0 &&
                _hasBeenTriggered &&
                !CanSpawnAny())
            {
                // Move the target object if configured
                if (_moveObjectWhenAllDefeated && _objectToMoveOnDefeat != null)
                {
                    _objectToMoveOnDefeat.transform.position = _defeatMovePosition;
                    _moveObjectWhenAllDefeated = false; // Prevent re-triggering
                    Debug.Log($"[EnemySpawner] All enemies defeated! Moved {_objectToMoveOnDefeat.name} to {_defeatMovePosition}");
                }

                // Move all objects in the array to the shared target position
                if (_objectsToMoveOnDefeat != null)
                {
                    foreach (var obj in _objectsToMoveOnDefeat)
                    {
                        if (obj != null)
                        {
                            obj.transform.position = _objectsDefeatMovePosition;
                        }
                    }
                }
            }
        }

        public void SpawnBullet(Vector3 position, Vector3 direction, BaseEnemyBot sourceBot = null)
        {
            if (_bulletPool == null)
            {
                Debug.LogError("EnemySpawner: Bullet pool is null!");
                return;
            }

            if (_bulletPool.Count == 0)
            {
                Debug.LogWarning("EnemySpawner: Bullet pool is empty!");
                return;
            }

            Debug.Log($"EnemySpawner: Spawning bullet from {position} in direction {direction}");
            var bullet = _bulletPool.Dequeue();
            bullet.transform.position = position;
            bullet.OnSpawn(direction, sourceBot);
            bullet.gameObject.SetActive(true);
            _activeBullets.Add(bullet);
        }

        public void RecycleBullet(EnemyBullet bullet)
        {
            if (!bullet)
            {
                return;
            }

            bullet.OnRecycle();
            bullet.gameObject.SetActive(false);
            _bulletPool.Enqueue(bullet);
            _activeBullets.Remove(bullet);
        }

        public EnemyBullet GetNearestBulletInParryRange()
        {
            EnemyBullet nearest = null;
            float nearestDist = float.MaxValue;
            foreach (var bullet in _activeBullets)
            {
                if (bullet == null || !bullet.gameObject.activeInHierarchy || bullet.IsDeflected) continue;
                float dist = Vector3.Distance(bullet.transform.position, Player.position);
                if (dist <= ParryThresholdDistance && dist < nearestDist)
                {
                    nearest = bullet;
                    nearestDist = dist;
                }
            }
            return nearest;
        }

        public List<EnemyBullet> GetAllBulletsInParryRange()
        {
            var result = new List<EnemyBullet>();
            foreach (var bullet in _activeBullets)
            {
                if (bullet == null || !bullet.gameObject.activeInHierarchy || bullet.IsDeflected) continue;
                float dist = Vector3.Distance(bullet.transform.position, Player.position);
                if (dist <= ParryThresholdDistance)
                {
                    result.Add(bullet);
                }
            }
            return result;
        }

        public void KillBotWithExplosion(BaseEnemyBot bot)
        {
            if (bot == null) return;
            if (ExplosionEffectPrefab != null)
            {
                Instantiate(ExplosionEffectPrefab, bot.transform.position, Quaternion.identity);
            }
            RecycleBot(bot, true);
        }

        public IReadOnlyList<BaseEnemyBot> GetActiveBots()
        {
            return _activeBots;
        }

        /// <summary>
        /// Recycles all active enemies and bullets back to their pools for soft reset on death.
        /// </summary>
        public void ResetAllEnemies()
        {
            // Recycle all active bots back to pool
            for (int i = _activeBots.Count - 1; i >= 0; i--)
            {
                var bot = _activeBots[i];
                if (bot != null)
                {
                    RecycleBot(bot);
                }
            }

            // Recycle all active bullets back to pool
            for (int i = _activeBullets.Count - 1; i >= 0; i--)
            {
                var bullet = _activeBullets[i];
                if (bullet != null)
                {
                    RecycleBullet(bullet);
                }
            }

            // Reset spawn timer and trigger-based tracking
            _spawnTimer = SpawnInterval;
            _hasBeenTriggered = false;
            _totalSpawnedCount?.Clear();
            _activeCount?.Clear();

            Debug.Log("[EnemySpawner] Reset all enemies and bullets for soft reset.");
        }

        /// <summary>
        /// Calculates bullet speed that is always at least 10% faster than player's current velocity
        /// </summary>
        public float GetDynamicBulletSpeed(CharacterController playerController)
        {
            if (!BulletSpeedScalesWithPlayer || playerController == null)
            {
                return BulletSpeed;
            }

            // Get player's horizontal velocity magnitude
            Vector3 playerVelocity = playerController.velocity;
            float playerSpeed = new Vector3(playerVelocity.x, 0f, playerVelocity.z).magnitude;

            // Bullet speed is 110% of player's current speed, with minimum of BulletSpeed
            float dynamicSpeed = playerSpeed * 1.1f;
            return Mathf.Max(dynamicSpeed, BulletSpeed);
        }

        private void OnDrawGizmosSelected()
        {
            if (!Player)
            {
                return;
            }

            // Draw spawn volume (tracks with player)
            Gizmos.color = new Color(1f, 0f, 0f, 0.3f);
            var center = new Vector3(Player.position.x, Player.position.y + SpawnHeight / 2f, Player.position.z + SpawnOffsetZ + SpawnDepth / 2f);
            var size = new Vector3(SpawnWidth, SpawnHeight, SpawnDepth);
            Gizmos.DrawCube(center, size);
            Gizmos.color = Color.red;
            Gizmos.DrawWireCube(center, size);
        }
    }
}
