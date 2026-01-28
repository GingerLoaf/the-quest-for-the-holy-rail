using System.Collections;
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
        public float FiringRange { get; private set; } = 30f;

        [Header("Flash Settings")]
        [field: Tooltip("Duration of the flash warning before firing")]
        [field: SerializeField]
        public float FlashDuration { get; private set; } = 0.3f;

        [field: Tooltip("Emission intensity multiplier during flash")]
        [field: SerializeField]
        public float FlashIntensity { get; private set; } = 5f;

        [Header("Position Spread")]
        [field: Tooltip("Random X offset range (left/right spread)")]
        [field: SerializeField]
        public Vector2 OffsetRangeX { get; private set; } = new(-8f, 8f);

        [field: Tooltip("Random Y offset range (height spread)")]
        [field: SerializeField]
        public Vector2 OffsetRangeY { get; private set; } = new(1f, 4f);

        [field: Tooltip("Random Z offset range (distance from player)")]
        [field: SerializeField]
        public Vector2 OffsetRangeZ { get; private set; } = new(10f, 20f);

        private Vector3 _randomizedOffset;
        private Vector3 _velocity;
        private Camera _mainCamera;
        private float _noiseOffsetX;
        private float _noiseOffsetY;
        private float _noiseOffsetZ;

        private Renderer _renderer;
        private Material _material;
        private Color _baseEmissionColor;
        private Coroutine _flashCoroutine;

        protected override void Awake()
        {
            base.Awake();
            _mainCamera = Camera.main;
            _renderer = GetComponentInChildren<Renderer>();
            if (_renderer != null)
            {
                _material = _renderer.material;
                _baseEmissionColor = _material.GetColor("_EmissionColor");
            }
        }

        public override void OnSpawn()
        {
            base.OnSpawn();
            _fireTimer = Random.Range(0f, FireRate);
            _velocity = Vector3.zero;

            // Randomize position offset within configured ranges
            _randomizedOffset = new Vector3(
                Random.Range(OffsetRangeX.x, OffsetRangeX.y),
                Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                Random.Range(OffsetRangeZ.x, OffsetRangeZ.y)
            );

            // Randomize noise seed so each bot drifts independently
            _noiseOffsetX = Random.Range(0f, 1000f);
            _noiseOffsetY = Random.Range(0f, 1000f);
            _noiseOffsetZ = Random.Range(0f, 1000f);
        }

        protected override void UpdateMovement()
        {
            if (!_mainCamera || !Spawner || !Spawner.Player)
            {
                return;
            }

            var playerTransform = Spawner.Player;
            var camTransform = _mainCamera.transform;

            // Calculate target position using randomized offset
            Vector3 forwardDirection = Vector3.ProjectOnPlane(camTransform.forward, Vector3.up).normalized;
            Vector3 targetPosition = playerTransform.position +
                                     (camTransform.right * _randomizedOffset.x) +
                                     (Vector3.up * _randomizedOffset.y) +
                                     (forwardDirection * _randomizedOffset.z);

            // Apply Perlin noise for organic drift movement
            float time = Time.time * BotNoiseSpeed;
            float noiseX = (Mathf.PerlinNoise(time + _noiseOffsetX, 0f) - 0.5f) * 2f * BotNoiseAmount;
            float noiseY = (Mathf.PerlinNoise(time + _noiseOffsetY, 100f) - 0.5f) * 2f * BotNoiseAmount;
            float noiseZ = (Mathf.PerlinNoise(time + _noiseOffsetZ, 200f) - 0.5f) * 2f * BotNoiseAmount;
            targetPosition += new Vector3(noiseX, noiseY, noiseZ);

            // Smoothly move towards the target position with collision check
            Vector3 smoothTarget = Vector3.SmoothDamp(transform.position, targetPosition, ref _velocity, SmoothTime, BotMaxSpeed);
            transform.position = GetCollisionSafePosition(transform.position, smoothTarget);

            // Smoothly rotate to face the player
            var toPlayer = playerTransform.position - transform.position;
            if (toPlayer.sqrMagnitude > 0.001f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(toPlayer);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / RotationSmoothTime);
            }
        }

        public override void OnRecycle()
        {
            base.OnRecycle();
            if (_flashCoroutine != null)
            {
                StopCoroutine(_flashCoroutine);
                _flashCoroutine = null;
            }
            if (_material != null)
            {
                _material.SetColor("_EmissionColor", _baseEmissionColor);
            }
        }

        protected override void Update()
        {
            base.Update();
            UpdateFiring();
        }

        private void UpdateFiring()
        {
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            _fireTimer -= Time.deltaTime;

            // Start flash warning before firing
            if (_fireTimer <= FlashDuration && _flashCoroutine == null)
            {
                float dist = Vector3.Distance(transform.position, Spawner.Player.position);
                if (dist <= FiringRange)
                {
                    _flashCoroutine = StartCoroutine(FlashCoroutine());
                }
            }

            if (_fireTimer <= 0f)
            {
                var playerPos = Spawner.Player.position;
                float distanceToPlayer = Vector3.Distance(transform.position, playerPos);

                Debug.Log($"ShooterBot: Fire timer elapsed. Distance to player: {distanceToPlayer:F1}, FiringRange: {FiringRange}");

                if (distanceToPlayer <= FiringRange)
                {
                    var direction = (playerPos - transform.position).normalized;
                    Debug.Log($"ShooterBot: Attempting to fire bullet!");
                    Spawner.SpawnBullet(transform.position, direction, this);
                }
                else
                {
                    Debug.Log($"ShooterBot: Player out of range, not firing.");
                }

                _fireTimer = FireRate;
                _flashCoroutine = null;
            }
        }

        private IEnumerator FlashCoroutine()
        {
            if (_material == null) yield break;
            _material.SetColor("_EmissionColor", Color.red * FlashIntensity);
            yield return new WaitForSeconds(FlashDuration);
            _material.SetColor("_EmissionColor", _baseEmissionColor);
        }
    }
}
