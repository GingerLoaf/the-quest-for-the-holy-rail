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

        // Apply avoidance from other bots
        var avoidance = CalculateAvoidance();
        _velocity += avoidance * Time.deltaTime;

        float time = Time.time * _spawner.BotNoiseSpeed;
        var noise = new Vector3(
            Mathf.PerlinNoise(_noiseOffsetX + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetY + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetZ + time, 0f) - 0.5f
        ) * _spawner.BotNoiseAmount * 2f;

        transform.position += (_velocity + noise) * Time.deltaTime;
    }

    private Vector3 CalculateAvoidance()
    {
        var avoidance = Vector3.zero;
        float avoidRadius = _spawner.BotAvoidanceRadius;
        float avoidStrength = _spawner.BotAvoidanceStrength;

        if (avoidRadius <= 0f)
        {
            return avoidance;
        }

        var activeBots = _spawner.GetActiveBots();
        foreach (var otherBot in activeBots)
        {
            if (otherBot == this || otherBot == null)
            {
                continue;
            }

            var toOther = otherBot.transform.position - transform.position;
            float distance = toOther.magnitude;

            if (distance < avoidRadius && distance > 0.01f)
            {
                // Push away from other bot, stronger when closer
                float strength = (avoidRadius - distance) / avoidRadius;
                avoidance -= toOther.normalized * strength * avoidStrength;
            }
        }

        return avoidance;
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
