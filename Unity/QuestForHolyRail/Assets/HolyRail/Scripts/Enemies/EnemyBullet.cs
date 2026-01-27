using StarterAssets;
using UnityEngine;

public class EnemyBullet : MonoBehaviour
{
    private EnemySpawner _spawner;
    private Vector3 _direction;
    private float _lifetime;
    private const float MaxLifetime = 5f;

    public void Initialize(EnemySpawner spawner)
    {
        _spawner = spawner;
    }

    public void OnSpawn(Vector3 direction)
    {
        _direction = direction.normalized;
        _lifetime = 0f;
    }

    public void OnRecycle()
    {
        _direction = Vector3.zero;
        _lifetime = 0f;
    }

    private void Update()
    {
        if (_spawner == null)
        {
            return;
        }

        transform.position += _direction * _spawner.BulletSpeed * Time.deltaTime;

        _lifetime += Time.deltaTime;
        if (_lifetime >= MaxLifetime)
        {
            _spawner.RecycleBullet(this);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            // Knock player off rail if grinding and toggle is enabled
            if (_spawner != null && _spawner.BulletsKnockOffRail)
            {
                var grinder = other.GetComponentInParent<ThirdPersonController_RailGrinder>();
                if (grinder != null)
                {
                    grinder.StopGrind();
                }
            }

            // TODO: Apply damage to player
            _spawner?.RecycleBullet(this);
        }
    }
}
