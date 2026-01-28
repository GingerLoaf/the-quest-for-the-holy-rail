using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class ShooterBot : BaseEnemyBot
    {
        private float _fireTimer;

        [Header("Shooter Settings")]
        [field: Tooltip("Seconds between each shot fired by a bot")]
        [field: SerializeField]
        public float FireRate { get; private set; } = 1.5f;

        [field: Tooltip("Bots only fire when player is within this distance")]
        [field: SerializeField]
        public float FiringRange { get; private set; } = 15f;


        public override void OnSpawn()
        {
            base.OnSpawn();
            _fireTimer = Random.Range(0f, FireRate);
        }

        protected override void Update()
        {
            base.Update();
            UpdateFiring();
        }

        private void UpdateFiring()
        {
            _fireTimer -= Time.deltaTime;

            if (_fireTimer <= 0f)
            {
                var playerPos = Spawner.Player.position;
                float distanceToPlayer = Vector3.Distance(transform.position, playerPos);

                if (distanceToPlayer <= FiringRange)
                {
                    var direction = (playerPos - transform.position).normalized;
                    Spawner.SpawnBullet(transform.position, direction);
                }

                _fireTimer = FireRate;
            }
        }
    }
}
