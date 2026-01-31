using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class KamikazeBot : BaseEnemyBot
    {
        [Header("Kamikaze Settings")]
        [Tooltip("Movement speed when chasing the player")]
        public float ChaseSpeed = 6f;

        [Tooltip("The distance at which the bot explodes.")]
        public float ExplosionRadius = 3f;

        [Tooltip("The amount of damage dealt to the player.")]
        public int DamageAmount = 1;

        [Tooltip("A GameObject for the explosion particle effect.")]
        public GameObject ExplosionEffect;

        private bool _isExploding;

        protected override void UpdateMovement()
        {
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            // Skip movement if idle
            if (_isIdle)
            {
                return;
            }

            // Move directly toward player position
            Vector3 targetPosition = Spawner.Player.position;
            Vector3 direction = (targetPosition - transform.position).normalized;

            // Move toward player at chase speed
            transform.position += direction * ChaseSpeed * Time.deltaTime;

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
            base.Update();
            
            if (_isExploding) return;
            if (_isIdle) return;

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
                GameSessionManager.Instance.TakeDamage(DamageAmount);
            }

            if(Spawner) Spawner.RecycleBot(this, true);
        }

        public override void OnCommandReceived(string command, params object[] args)
        {
            switch (command)
            {
                case "Attack":
                    _isIdle = false;
                    Debug.Log($"KamikazeBot [{name}]: Received 'Attack' command, beginning chase");
                    break;
            }
        }

        protected override void OnValidate()
        {
            base.OnValidate();
            if (Application.isPlaying)
            {
                Debug.Log($"KamikazeBot [{name}]: Parameters updated - ChaseSpeed={ChaseSpeed}, ExplosionRadius={ExplosionRadius}, DamageAmount={DamageAmount}");
            }
        }
    }
}
