using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class ShooterBot : BaseEnemyBot
    {
        private float _fireTimer;

        [Header("Shooter Settings")]
        [field: Tooltip("Seconds between each shot fired by a bot (can be overridden by EnemySpawner)")]
        [field: SerializeField]
        public float FireRate { get; private set; } = 1.5f;

        [field: Tooltip("Bots only fire when player is within this distance (can be overridden by EnemySpawner)")]
        [field: SerializeField]
        public float FiringRange { get; private set; } = 30f;

        private float EffectiveFireRate => Spawner && Spawner.OverrideFireRate ? Spawner.GlobalFireRate : FireRate;
        private float EffectiveFiringRange => Spawner && Spawner.OverrideFiringRange ? Spawner.GlobalFiringRange : FiringRange;

        [Header("Flash Settings")]
        [field: Tooltip("Duration of the flash warning before firing")]
        [field: SerializeField]
        public float FlashDuration { get; private set; } = 0.3f;

        [field: Tooltip("Emission intensity multiplier during flash")]
        [field: SerializeField]
        public float FlashIntensity { get; private set; } = 5f;

        [Header("Fire Flash Settings")]
        [field: Tooltip("Duration of the flash at moment of firing")]
        [field: SerializeField]
        public float FireFlashDuration { get; private set; } = 0.15f;

        [field: Tooltip("Emission intensity multiplier during fire flash")]
        [field: SerializeField]
        public float FireFlashIntensity { get; private set; } = 8f;

        [field: Tooltip("Color of the flash at moment of firing")]
        [field: SerializeField]
        public Color FireFlashColor { get; private set; } = Color.red;

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
        private Vector3 _smoothedNoiseOffset;
        private Vector3 _noiseVelocity;
        private float _noiseOffsetX;
        private float _noiseOffsetY;
        private float _noiseOffsetZ;

        private Renderer _renderer;
        private MaterialPropertyBlock _propertyBlock;
        private static readonly int EmissionColorID = Shader.PropertyToID("_EmissionColor");
        private Color _originalEmissionColor;

        // Update-based flash system (replaces coroutines for reliability)
        private bool _isFlashing;
        private float _flashTimer;
        private Color _currentFlashColor;

        protected override void Awake()
        {
            base.Awake();
            _renderer = GetComponentInChildren<Renderer>();
            if (_renderer != null)
            {
                _propertyBlock = new MaterialPropertyBlock();
                _originalEmissionColor = _renderer.sharedMaterial.GetColor(EmissionColorID);
            }
        }

        public override void OnSpawn()
        {
            base.OnSpawn();
            _fireTimer = Random.Range(0f, EffectiveFireRate);
            _smoothedNoiseOffset = Vector3.zero;
            _noiseVelocity = Vector3.zero;

            Debug.Log($"ShooterBot [{name}]: Spawned with FireRate={EffectiveFireRate}s, FiringRange={EffectiveFiringRange}m, first shot in {_fireTimer:F1}s");

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
            if (!MainCamera || !Spawner || !Spawner.Player)
            {
                return;
            }

            var playerTransform = Spawner.Player;
            var camTransform = MainCamera.transform;

            // Calculate derived position directly from player (NO LAG)
            Vector3 forwardDirection = Vector3.ProjectOnPlane(camTransform.forward, Vector3.up).normalized;
            Vector3 derivedPosition = playerTransform.position +
                                      (camTransform.right * _randomizedOffset.x) +
                                      (Vector3.up * _randomizedOffset.y) +
                                      (forwardDirection * _randomizedOffset.z);

            // Calculate smoothed noise offset (local organic drift only)
            float time = Time.time * BotNoiseSpeed;
            Vector3 rawNoise = new Vector3(
                (Mathf.PerlinNoise(time + _noiseOffsetX, 0f) - 0.5f) * 2f * BotNoiseAmount,
                (Mathf.PerlinNoise(time + _noiseOffsetY, 100f) - 0.5f) * 2f * BotNoiseAmount,
                (Mathf.PerlinNoise(time + _noiseOffsetZ, 200f) - 0.5f) * 2f * BotNoiseAmount
            );
            _smoothedNoiseOffset = Vector3.SmoothDamp(_smoothedNoiseOffset, rawNoise, ref _noiseVelocity, 0.15f);

            // Apply avoidance velocity
            derivedPosition += AvoidanceVelocity * Time.deltaTime;

            // Final position = derived + smoothed noise
            Vector3 targetPosition = derivedPosition + _smoothedNoiseOffset;

            // Move with collision pathing (slides around obstacles)
            transform.position = GetPositionWithCollisionPathing(transform.position, targetPosition);

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
            _isFlashing = false;
            _flashTimer = 0f;
            _smoothedNoiseOffset = Vector3.zero;
            _noiseVelocity = Vector3.zero;
            // Clear property block to reset to shared material defaults
            if (_renderer != null && _propertyBlock != null)
            {
                _propertyBlock.Clear();
                _renderer.SetPropertyBlock(_propertyBlock);
            }
        }

        public void ResetFireTimer()
        {
            _fireTimer = 0f;
            Debug.Log($"ShooterBot [{name}]: Fire timer reset, will fire immediately");
        }

        protected override void Update()
        {
            base.Update();
            UpdateFlash();
            UpdateFiring();
        }

        private void UpdateFlash()
        {
            if (!_isFlashing) return;

            _flashTimer -= Time.deltaTime;
            if (_flashTimer <= 0f)
            {
                // Flash complete - reset to original color
                _isFlashing = false;
                if (_renderer != null && _propertyBlock != null)
                {
                    _propertyBlock.SetColor(EmissionColorID, _originalEmissionColor);
                    _renderer.SetPropertyBlock(_propertyBlock);
                }
            }
        }

        private void StartFlash(Color color, float duration)
        {
            if (_renderer == null || _propertyBlock == null) return;

            _isFlashing = true;
            _flashTimer = duration;
            _currentFlashColor = color;
            _propertyBlock.SetColor(EmissionColorID, color);
            _renderer.SetPropertyBlock(_propertyBlock);
        }

        private void UpdateFiring()
        {
            if (!Spawner)
            {
                Debug.LogWarning("ShooterBot: No Spawner reference!");
                return;
            }
            if (!Spawner.Player)
            {
                Debug.LogWarning("ShooterBot: No Player reference on Spawner!");
                return;
            }

            _fireTimer -= Time.deltaTime;

            float effectiveRange = EffectiveFiringRange;
            float effectiveRate = EffectiveFireRate;

            // Start flash warning before firing (only if not already flashing)
            if (_fireTimer <= FlashDuration && !_isFlashing)
            {
                float dist = Vector3.Distance(transform.position, Spawner.Player.position);
                if (dist <= effectiveRange)
                {
                    StartFlash(Color.red * FlashIntensity, FlashDuration);
                }
            }

            if (_fireTimer <= 0f)
            {
                var playerPos = Spawner.Player.position;
                float distanceToPlayer = Vector3.Distance(transform.position, playerPos);

                Debug.Log($"ShooterBot [{name}]: Fire timer elapsed. Distance={distanceToPlayer:F1}m, FiringRange={effectiveRange}m, MyPos={transform.position}");

                if (distanceToPlayer <= effectiveRange)
                {
                    var direction = (playerPos - transform.position).normalized;
                    Debug.Log($"ShooterBot [{name}]: FIRING bullet toward player at {playerPos}");
                    Spawner.SpawnBullet(transform.position, direction, this);

                    // Trigger fire flash at moment of shooting (overrides any current flash)
                    StartFlash(FireFlashColor * FireFlashIntensity, FireFlashDuration);
                }
                else
                {
                    Debug.Log($"ShooterBot [{name}]: Player out of range ({distanceToPlayer:F1}m > {effectiveRange}m), not firing.");
                }

                _fireTimer = effectiveRate;
            }
        }

        protected override void OnValidate()
        {
            base.OnValidate();
            if (Application.isPlaying)
            {
                Debug.Log($"ShooterBot [{name}]: Parameters updated - FireRate={FireRate}, FiringRange={FiringRange}");
            }
        }
    }
}
