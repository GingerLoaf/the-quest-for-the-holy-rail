using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class KamikazeBot : BaseEnemyBot
    {
        [Header("Kamikaze Settings")]
        [Tooltip("The distance at which the bot explodes.")]
        public float ExplosionRadius = 3f;

        [Tooltip("The multiplier to apply to the player's speed (e.g., 0.2f for an 80% slowdown).")]
        public float SlowdownMultiplier = 0.2f;

        [Tooltip("How long the slowdown effect lasts.")]
        public float SlowdownDuration = 3f;

        [Tooltip("A GameObject for the explosion particle effect.")]
        public GameObject ExplosionEffect;

        private bool _isExploding;

        protected override void UpdateMovement()
        {
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            // Move directly toward player position
            Vector3 targetPosition = Spawner.Player.position;
            Vector3 direction = (targetPosition - transform.position).normalized;

            // Move toward player at max speed with collision check
            Vector3 desiredPosition = transform.position + direction * BotMaxSpeed * Time.deltaTime;
            transform.position = GetCollisionSafePosition(transform.position, desiredPosition);

            // Face the player
            if (direction.sqrMagnitude > 0.001f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(direction);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / RotationSmoothTime);
            }
        }

        public override void OnSpawn()
        {
            base.OnSpawn();
            _isExploding = false;
        }

        protected override void Update()
        {
            if (_isExploding) return;

            base.Update();
            
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            float distanceToPlayer = Vector3.Distance(transform.position, Spawner.Player.position);
            if (distanceToPlayer <= ExplosionRadius)
            {
                Explode();
            }
        }

        private void Explode()
        {
            _isExploding = true;
            
            if (ExplosionEffect)
            {
                Instantiate(ExplosionEffect, transform.position, Quaternion.identity);
            }

            if (Spawner && Spawner.Player)
            {
                ThirdPersonController_RailGrinder playerController = Spawner.Player.GetComponent<ThirdPersonController_RailGrinder>();
                if (playerController)
                {
                    playerController.ApplySpeedReduction(SlowdownMultiplier, SlowdownDuration);
                }
            }

            if(Spawner) Spawner.RecycleBot(this, true);
        }
    }
}
