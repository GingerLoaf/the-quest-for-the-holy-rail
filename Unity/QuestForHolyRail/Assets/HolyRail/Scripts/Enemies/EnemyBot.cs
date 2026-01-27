using UnityEngine;

public class EnemyBot : MonoBehaviour
{
    private EnemySpawner _spawner;
    private Vector3 _velocity;
    private float _fireTimer;
    private float _noiseOffsetX;
    private float _noiseOffsetY;
    private float _noiseOffsetZ;

    public void Initialize(EnemySpawner spawner)
    {
        _spawner = spawner;
    }

    public void OnSpawn()
    {
        _velocity = Vector3.zero;
        _fireTimer = Random.Range(0f, _spawner.BotFireRate);
        _noiseOffsetX = Random.Range(0f, 1000f);
        _noiseOffsetY = Random.Range(0f, 1000f);
        _noiseOffsetZ = Random.Range(0f, 1000f);
    }

    public void OnRecycle()
    {
        _velocity = Vector3.zero;
    }

    private void Update()
    {
        if (_spawner == null || _spawner.Player == null)
        {
            return;
        }

        UpdateMovement();
        UpdateFiring();
    }

    private void UpdateMovement()
    {
        var playerPos = _spawner.Player.position;
        var toPlayer = playerPos - transform.position;
        float distanceToPlayer = toPlayer.magnitude;

        if (distanceToPlayer > _spawner.BotExclusionRadius)
        {
            var direction = toPlayer.normalized;
            _velocity += direction * _spawner.BotAcceleration * Time.deltaTime;

            if (_velocity.magnitude > _spawner.BotMaxSpeed)
            {
                _velocity = _velocity.normalized * _spawner.BotMaxSpeed;
            }
        }
        else
        {
            _velocity *= 0.95f;
        }

        float time = Time.time * _spawner.BotNoiseSpeed;
        var noise = new Vector3(
            Mathf.PerlinNoise(_noiseOffsetX + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetY + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetZ + time, 0f) - 0.5f
        ) * _spawner.BotNoiseAmount * 2f;

        transform.position += (_velocity + noise) * Time.deltaTime;
    }

    private void UpdateFiring()
    {
        _fireTimer -= Time.deltaTime;

        if (_fireTimer <= 0f)
        {
            var playerPos = _spawner.Player.position;
            float distanceToPlayer = Vector3.Distance(transform.position, playerPos);

            if (distanceToPlayer <= _spawner.BotFiringRange)
            {
                var direction = (playerPos - transform.position).normalized;
                _spawner.SpawnBullet(transform.position, direction);
            }

            _fireTimer = _spawner.BotFireRate;
        }
    }
}
