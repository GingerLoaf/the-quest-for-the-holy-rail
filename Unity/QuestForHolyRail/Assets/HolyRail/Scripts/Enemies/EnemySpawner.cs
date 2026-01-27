using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public static EnemySpawner Instance { get; private set; }

    [Header("Prefab References")]
    [field: Tooltip("The enemy bot prefab to spawn")]
    [field: SerializeField]
    public GameObject BotPrefab { get; private set; }

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
    [field: Tooltip("Total bot instances to pre-allocate in the pool")]
    [field: SerializeField]
    public int BotPoolSize { get; private set; } = 20;

    [field: Tooltip("Total bullet instances to pre-allocate in the pool")]
    [field: SerializeField]
    public int BulletPoolSize { get; private set; } = 50;
    
    [Header("Bullet Settings")]
    [field: Tooltip("Travel speed of bullets")]
    [field: SerializeField]
    public float BulletSpeed { get; private set; } = 15f;

    [field: Tooltip("If true, bullets will knock the player off rails when hit")]
    [field: SerializeField]
    public bool BulletsKnockOffRail { get; private set; } = true;

    private Queue<BaseEnemyBot> _botPool;
    private Queue<EnemyBullet> _bulletPool;
    private List<BaseEnemyBot> _activeBots;
    private float _spawnTimer;

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

    private void InitializePools()
    {
        _botPool = new Queue<BaseEnemyBot>();
        _bulletPool = new Queue<EnemyBullet>();
        _activeBots = new List<BaseEnemyBot>();

        for (int i = 0; i < BotPoolSize; i++)
        {
            var botObj = Instantiate(BotPrefab, transform);
            var bot = botObj.GetComponent<BaseEnemyBot>();
            bot.Initialize(this);
            botObj.SetActive(false);
            _botPool.Enqueue(bot);
        }

        for (int i = 0; i < BulletPoolSize; i++)
        {
            var bulletObj = Instantiate(BulletPrefab, transform);
            var bullet = bulletObj.GetComponent<EnemyBullet>();
            bullet.Initialize(this);
            bulletObj.SetActive(false);
            _bulletPool.Enqueue(bullet);
        }
    }

    private void Update()
    {
        if (Player == null)
        {
            return;
        }

        _spawnTimer += Time.deltaTime;

        if (_spawnTimer >= SpawnInterval && _activeBots.Count < MaxActiveEnemies)
        {
            SpawnBot();
            _spawnTimer = 0f;
        }
    }

    public void SpawnBot()
    {
        if (_botPool.Count == 0)
        {
            return;
        }

        var bot = _botPool.Dequeue();
        var spawnPos = GetRandomSpawnPosition();
        bot.transform.position = spawnPos;
        bot.OnSpawn();
        bot.gameObject.SetActive(true);
        _activeBots.Add(bot);
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
        if (bot == null)
        {
            return;
        }

        bot.OnRecycle();
        bot.gameObject.SetActive(false);
        _activeBots.Remove(bot);
        _botPool.Enqueue(bot);
    }

    public void SpawnBullet(Vector3 position, Vector3 direction)
    {
        if (_bulletPool.Count == 0)
        {
            return;
        }

        var bullet = _bulletPool.Dequeue();
        bullet.transform.position = position;
        bullet.OnSpawn(direction);
        bullet.gameObject.SetActive(true);
    }

    public void RecycleBullet(EnemyBullet bullet)
    {
        if (bullet == null)
        {
            return;
        }

        bullet.OnRecycle();
        bullet.gameObject.SetActive(false);
        _bulletPool.Enqueue(bullet);
    }

    public IReadOnlyList<BaseEnemyBot> GetActiveBots()
    {
        return _activeBots;
    }

    private void OnDrawGizmosSelected()
    {
        if (Player == null)
        {
            return;
        }

        Gizmos.color = new Color(1f, 0f, 0f, 0.3f);
        var center = new Vector3(0f, Player.position.y + SpawnHeight / 2f, Player.position.z + SpawnOffsetZ + SpawnDepth / 2f);
        var size = new Vector3(SpawnWidth, SpawnHeight, SpawnDepth);
        Gizmos.DrawCube(center, size);
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(center, size);
    }
}
