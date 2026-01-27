using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public static EnemySpawner Instance { get; private set; }

    [Header("Prefab References")]
    [field: SerializeField]
    public GameObject BotPrefab { get; private set; }

    [field: SerializeField]
    public GameObject BulletPrefab { get; private set; }

    [Header("Player Reference")]
    [field: SerializeField]
    public Transform Player { get; private set; }

    [Header("Spawn Volume")]
    [field: SerializeField]
    public float SpawnOffsetZ { get; private set; } = 30f;

    [field: SerializeField]
    public float SpawnWidth { get; private set; } = 20f;

    [field: SerializeField]
    public float SpawnHeight { get; private set; } = 5f;

    [field: SerializeField]
    public float SpawnDepth { get; private set; } = 10f;

    [Header("Spawn Rate")]
    [field: SerializeField]
    public float SpawnInterval { get; private set; } = 2f;

    [field: SerializeField]
    public int MaxActiveEnemies { get; private set; } = 10;

    [Header("Pool Sizes")]
    [field: SerializeField]
    public int BotPoolSize { get; private set; } = 20;

    [field: SerializeField]
    public int BulletPoolSize { get; private set; } = 50;

    [Header("Bot Settings")]
    [field: SerializeField]
    public float BotExclusionRadius { get; private set; } = 5f;

    [field: SerializeField]
    public float BotAcceleration { get; private set; } = 8f;

    [field: SerializeField]
    public float BotMaxSpeed { get; private set; } = 6f;

    [field: SerializeField]
    public float BotNoiseAmount { get; private set; } = 1.5f;

    [field: SerializeField]
    public float BotNoiseSpeed { get; private set; } = 2f;

    [Header("Bullet Settings")]
    [field: SerializeField]
    public float BulletSpeed { get; private set; } = 15f;

    [field: SerializeField]
    public float BotFireRate { get; private set; } = 1.5f;

    [field: SerializeField]
    public float BotFiringRange { get; private set; } = 15f;

    private Queue<EnemyBot> _botPool;
    private Queue<EnemyBullet> _bulletPool;
    private List<EnemyBot> _activeBots;
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
        _botPool = new Queue<EnemyBot>();
        _bulletPool = new Queue<EnemyBullet>();
        _activeBots = new List<EnemyBot>();

        for (int i = 0; i < BotPoolSize; i++)
        {
            var botObj = Instantiate(BotPrefab, transform);
            var bot = botObj.GetComponent<EnemyBot>();
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

    public void RecycleBot(EnemyBot bot)
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
