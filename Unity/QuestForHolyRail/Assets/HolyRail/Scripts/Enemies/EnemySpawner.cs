using System.Collections.Generic;
using UnityEngine;
using System.Linq;

namespace HolyRail.Scripts.Enemies
{
    [System.Serializable]
    public class SpawnableEnemy
    {
        public GameObject Prefab;
        public int PoolSize;
        [Range(0f, 1f)]
        public float SpawnWeight;
    }

    public class EnemySpawner : MonoBehaviour
    {
        public static EnemySpawner Instance { get; private set; }

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

        [Header("Spawn Rate")]
        [field: Tooltip("Seconds between each enemy spawn")]
        [field: SerializeField]
        public float SpawnInterval { get; private set; } = 2f;

        [field: Tooltip("Maximum number of enemies active at once")]
        [field: SerializeField]
        public int MaxActiveEnemies { get; private set; } = 10;

        [Header("Pool Sizes")]
        [field: Tooltip("Total bullet instances to pre-allocate in the pool")]
        [field: SerializeField]
        public int BulletPoolSize { get; private set; } = 50;

        [Header("Bullet Settings")]
        [field: Tooltip("Travel speed of bullets (minimum speed when player is stationary)")]
        [field: SerializeField]
        public float BulletSpeed { get; private set; } = 15f;

        [field: Tooltip("If true, bullets will always be at least 10% faster than player's current velocity")]
        [field: SerializeField]
        public bool BulletSpeedScalesWithPlayer { get; private set; } = true;

        [field: Tooltip("If true, bullets will knock the player off rails when hit")]
        [field: SerializeField]
        public bool BulletsKnockOffRail { get; private set; } = true;

        [field: Tooltip("Maximum time in seconds before bullets are automatically recycled")]
        [field: SerializeField]
        public float BulletLifetime { get; private set; } = 5f;

        [field: Tooltip("How much bullets home toward the player (0 = no homing, 1 = full homing)")]
        [field: SerializeField, Range(0f, 1f)]
        public float BulletHomingAmount { get; private set; } = 0f;

        [field: Tooltip("How fast bullets flash when in parry zone (cycles per second)")]
        [field: SerializeField]
        public float ParryFlashSpeed { get; private set; } = 10f;

        [field: Tooltip("Minimum brightness multiplier during parry flash")]
        [field: SerializeField]
        public float ParryFlashMin { get; private set; } = 1f;

        [field: Tooltip("Maximum brightness multiplier during parry flash")]
        [field: SerializeField]
        public float ParryFlashMax { get; private set; } = 8f;

        [Header("ShooterBot Overrides")]
        [field: Tooltip("If enabled, all ShooterBots use the fire rate below instead of their prefab values")]
        [field: SerializeField]
        public bool OverrideFireRate { get; private set; } = false;

        [field: Tooltip("Global fire rate override for all ShooterBots (seconds between shots)")]
        [field: SerializeField]
        public float GlobalFireRate { get; private set; } = 1.5f;

        [field: Tooltip("If enabled, all ShooterBots use the firing range below instead of their prefab values")]
        [field: SerializeField]
        public bool OverrideFiringRange { get; private set; } = false;

        [field: Tooltip("Global firing range override for all ShooterBots")]
        [field: SerializeField]
        public float GlobalFiringRange { get; private set; } = 30f;

        [Header("Parry Settings")]
        [field: Tooltip("Distance from player at which bullets can be parried")]
        [field: SerializeField]
        public float ParryThresholdDistance { get; private set; } = 5f;

        [field: Tooltip("Duration of the parry window after input")]
        [field: SerializeField]
        public float ParryWindowDuration { get; private set; } = 0.3f;

        [field: Tooltip("Explosion effect prefab spawned when a bot is killed by deflection")]
        [field: SerializeField]
        public GameObject ExplosionEffectPrefab { get; private set; }

        private Dictionary<GameObject, Queue<BaseEnemyBot>> _enemyPools;
        private Dictionary<int, GameObject> _instanceIdToPrefabMap;
        private Queue<EnemyBullet> _bulletPool;
        private List<BaseEnemyBot> _activeBots;
        private List<EnemyBullet> _activeBullets = new();
        private float _spawnTimer;
        private float _totalSpawnWeight;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }
            Instance = this;

            InitializePools();
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void OnValidate()
        {
            // Log parameter changes during runtime for debugging
            if (Application.isPlaying)
            {
                Debug.Log($"EnemySpawner: Parameters updated - BulletSpeed={BulletSpeed}, SpawnInterval={SpawnInterval}, MaxActiveEnemies={MaxActiveEnemies}");
                if (OverrideFireRate)
                {
                    Debug.Log($"EnemySpawner: Global FireRate override active = {GlobalFireRate}s");
                }
                if (OverrideFiringRange)
                {
                    Debug.Log($"EnemySpawner: Global FiringRange override active = {GlobalFiringRange}m");
                }
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
            if (!Player)
            {
                return;
            }

            _spawnTimer += Time.deltaTime;

            if (_spawnTimer >= SpawnInterval && _activeBots.Count < MaxActiveEnemies)
            {
                SpawnBot();
                _spawnTimer = 0f;
            }

            // Check bullet proximity for parry threshold
            foreach (var bullet in _activeBullets)
            {
                if (bullet == null || !bullet.gameObject.activeInHierarchy) continue;
                float dist = Vector3.Distance(bullet.transform.position, Player.position);
                bullet.SetInParryThreshold(dist <= ParryThresholdDistance);
            }
        }

        public void SpawnBot()
        {
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
                // Try other enemy types
                foreach (var enemyType in EnemyTypes)
                {
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

            var spawnPos = GetRandomSpawnPosition();
            bot.transform.position = spawnPos;

            bot.OnSpawn();
            bot.gameObject.SetActive(true);
            _activeBots.Add(bot);
        }

        private GameObject GetRandomEnemyPrefab()
        {
            if (_totalSpawnWeight <= 0) return null;

            float randomValue = Random.Range(0, _totalSpawnWeight);
            float cumulativeWeight = 0f;

            foreach (var enemyType in EnemyTypes)
            {
                cumulativeWeight += enemyType.SpawnWeight;
                if (randomValue < cumulativeWeight)
                {
                    return enemyType.Prefab;
                }
            }

            return null; // Should not happen if weights are set up correctly
        }

        private Vector3 GetRandomSpawnPosition()
        {
            float x = Random.Range(-SpawnWidth / 2f, SpawnWidth / 2f);
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
                _enemyPools[prefab].Enqueue(bot);
                _instanceIdToPrefabMap.Remove(instanceId);
            }
            else
            {
                Debug.LogWarning("Trying to recycle a bot that was not spawned from the pool.", bot.gameObject);
                Destroy(bot.gameObject);
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

            // Draw spawn volume
            Gizmos.color = new Color(1f, 0f, 0f, 0.3f);
            var center = new Vector3(0f, Player.position.y + SpawnHeight / 2f, Player.position.z + SpawnOffsetZ + SpawnDepth / 2f);
            var size = new Vector3(SpawnWidth, SpawnHeight, SpawnDepth);
            Gizmos.DrawCube(center, size);
            Gizmos.color = Color.red;
            Gizmos.DrawWireCube(center, size);
        }
    }
}
