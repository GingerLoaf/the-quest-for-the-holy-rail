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

        [Header("Movement")]
        [field: Tooltip("How quickly bots catch up to target position (higher = snappier)")]
        [field: SerializeField]
        public float FollowSpeed { get; private set; } = 15f;

        [Header("Wall Avoidance")]
        [field: Tooltip("Layer mask for wall collision")]
        [field: SerializeField]
        public LayerMask WallLayerMask { get; private set; } = ~0; // Default to all layers

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

            Debug.Log($"ShooterBot [{name}]: Spawned with FireRate={EffectiveFireRate}s, FiringRange={EffectiveFiringRange}m, first shot in {_fireTimer:F1}s");

            // Randomize position offset within configured ranges
            _randomizedOffset = new Vector3(
                Random.Range(OffsetRangeX.x, OffsetRangeX.y),
                Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                Random.Range(OffsetRangeZ.x, OffsetRangeZ.y)
            );
        }

        protected override void UpdateMovement()
        {
            if (!Spawner || !Spawner.Player) return;

            var playerTransform = Spawner.Player;

            // Calculate target position: player + offset in world space
            Vector3 targetPosition = playerTransform.position + _randomizedOffset;

            // Smoothly interpolate toward target (keeps up with any player speed)
            Vector3 currentPos = transform.position;
            float t = 1f - Mathf.Exp(-FollowSpeed * Time.deltaTime);
            Vector3 newPosition = Vector3.Lerp(currentPos, targetPosition, t);

            // Check for wall collision and resolve
            newPosition = ResolveWallCollision(currentPos, newPosition);

            transform.position = newPosition;

            // Smoothly rotate to face the player
            var toPlayer = playerTransform.position - transform.position;
            if (toPlayer.sqrMagnitude > 0.001f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(toPlayer);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / RotationSmoothTime);
            }
        }

        private Vector3 ResolveWallCollision(Vector3 from, Vector3 to)
        {
            Vector3 direction = to - from;
            float distance = direction.magnitude;

            if (distance < 0.001f) return to;

            // SphereCast from current position to new position to prevent entering walls
            if (Physics.SphereCast(from, BotCollisionRadius, direction.normalized, out RaycastHit hit,
                                   distance, WallLayerMask, QueryTriggerInteraction.Ignore))
            {
                // Stop just before the wall
                float safeDistance = Mathf.Max(0f, hit.distance - 0.05f);
                return from + direction.normalized * safeDistance;
            }

            return to;
        }

        public override void OnRecycle()
        {
            base.OnRecycle();
            _isFlashing = false;
            _flashTimer = 0f;
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
