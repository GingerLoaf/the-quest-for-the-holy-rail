using UnityEngine;

public class EnemyBot : MonoBehaviour
{
    private EnemySpawner _spawner;
    private Vector3 _velocity;
    private float _fireTimer;
    private float _noiseOffsetX;
    private float _noiseOffsetY;
    private float _noiseOffsetZ;

    private static readonly Collider[] _overlapResults = new Collider[16];

    private float BotRadius => _spawner != null ? _spawner.BotCollisionRadius : 1.5f;

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

        // Apply avoidance from other bots and world
        var botAvoidance = CalculateBotAvoidance();
        var worldAvoidance = CalculateWorldAvoidance();
        _velocity += (botAvoidance + worldAvoidance) * Time.deltaTime;

        float time = Time.time * _spawner.BotNoiseSpeed;
        var noise = new Vector3(
            Mathf.PerlinNoise(_noiseOffsetX + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetY + time, 0f) - 0.5f,
            Mathf.PerlinNoise(_noiseOffsetZ + time, 0f) - 0.5f
        ) * _spawner.BotNoiseAmount * 2f;

        // Calculate desired movement
        var desiredMove = (_velocity + noise) * Time.deltaTime;

        // Apply movement with collision prevention
        transform.position = MoveWithCollision(transform.position, desiredMove);
    }

    private Vector3 MoveWithCollision(Vector3 currentPos, Vector3 movement)
    {
        float moveDistance = movement.magnitude;
        if (moveDistance < 0.001f)
        {
            return currentPos;
        }

        var moveDir = movement.normalized;

        // SphereCast to check for obstacles
        if (Physics.SphereCast(currentPos, BotRadius, moveDir, out RaycastHit hit, moveDistance, ~0, QueryTriggerInteraction.Ignore))
        {
            // Check if we hit something we should avoid
            if (!hit.collider.CompareTag("Player") &&
                hit.collider.GetComponent<EnemyBot>() == null &&
                hit.collider.GetComponent<EnemyBullet>() == null)
            {
                // Move up to the hit point minus some buffer
                float safeDistance = Mathf.Max(0f, hit.distance - 0.05f);
                var safePos = currentPos + moveDir * safeDistance;

                // Slide along the surface
                var remainder = moveDistance - safeDistance;
                if (remainder > 0.01f)
                {
                    var slideDir = Vector3.ProjectOnPlane(moveDir, hit.normal).normalized;
                    if (slideDir.sqrMagnitude > 0.01f)
                    {
                        // Recursive slide with reduced distance
                        return MoveWithCollision(safePos, slideDir * remainder * 0.5f);
                    }
                }

                return safePos;
            }
        }

        return currentPos + movement;
    }

    private Vector3 CalculateBotAvoidance()
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
                float strength = (avoidRadius - distance) / avoidRadius;
                avoidance -= toOther.normalized * strength * avoidStrength;
            }
        }

        return avoidance;
    }

    private Vector3 CalculateWorldAvoidance()
    {
        var avoidance = Vector3.zero;
        float avoidRadius = _spawner.BotAvoidanceRadius;
        float avoidStrength = _spawner.BotAvoidanceStrength;

        if (avoidRadius <= 0f)
        {
            return avoidance;
        }

        int hitCount = Physics.OverlapSphereNonAlloc(
            transform.position,
            avoidRadius,
            _overlapResults,
            ~0,
            QueryTriggerInteraction.Ignore
        );

        for (int i = 0; i < hitCount; i++)
        {
            var col = _overlapResults[i];

            // Skip self, other bots, bullets, and player
            if (col.transform == transform ||
                col.GetComponent<EnemyBot>() != null ||
                col.GetComponent<EnemyBullet>() != null ||
                col.CompareTag("Player"))
            {
                continue;
            }

            // Find closest point on collider
            var closestPoint = col.ClosestPoint(transform.position);
            var toObstacle = closestPoint - transform.position;
            float distance = toObstacle.magnitude;

            if (distance < avoidRadius && distance > 0.01f)
            {
                float strength = (avoidRadius - distance) / avoidRadius;
                avoidance -= toObstacle.normalized * strength * avoidStrength * 3f;
            }
        }

        // Push out if inside a collider
        PushOutOfColliders();

        return avoidance;
    }

    private void PushOutOfColliders()
    {
        int hitCount = Physics.OverlapSphereNonAlloc(
            transform.position,
            BotRadius,
            _overlapResults,
            ~0,
            QueryTriggerInteraction.Ignore
        );

        for (int i = 0; i < hitCount; i++)
        {
            var col = _overlapResults[i];

            if (col.transform == transform ||
                col.GetComponent<EnemyBot>() != null ||
                col.GetComponent<EnemyBullet>() != null ||
                col.CompareTag("Player"))
            {
                continue;
            }

            // Compute penetration and push out
            if (Physics.ComputePenetration(
                GetComponent<Collider>(), transform.position, transform.rotation,
                col, col.transform.position, col.transform.rotation,
                out Vector3 pushDir, out float pushDist))
            {
                transform.position += pushDir * (pushDist + 0.01f);
            }
        }
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
