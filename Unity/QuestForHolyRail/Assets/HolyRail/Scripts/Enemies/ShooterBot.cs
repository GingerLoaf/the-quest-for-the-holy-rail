using System;
using UnityEngine;
using Random = UnityEngine.Random;

namespace HolyRail.Scripts.Enemies
{
    public class ShooterBot : BaseEnemyBot
    {
        private float? _fireTimer = null;

        private float EffectiveFireRate => Spawner ? Spawner.ShooterBotFireRate : 1.5f;
        private float EffectiveFiringRange => Spawner ? Spawner.ShooterBotFiringRange : 30f;

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

        [Header("Movement")]
        [field: Tooltip("How quickly bots catch up to target position (higher = snappier)")]
        [field: SerializeField]
        public float FollowSpeed { get; private set; } = 15f;

        [Header("Wall Avoidance")]
        [field: Tooltip("Layer mask for wall collision")]
        [field: SerializeField]
        public LayerMask WallLayerMask { get; private set; } = ~0; // Default to all layers

        [Header("Lead Targeting")]
        [field: Tooltip("How much to lead the target (0 = aim at current position, 1 = full prediction)")]
        [field: SerializeField]
        [field: Range(0f, 1.5f)]
        public float LeadFactor { get; private set; } = 0.8f;

        [Header("Audio")]
        [Tooltip("Looping motor/hover sound")]
        [SerializeField] private AudioClip _motorLoopClip;
        [Tooltip("Warning beep before firing")]
        [SerializeField] private AudioClip _warningClip;
        [Tooltip("Sound when firing")]
        [SerializeField] private AudioClip _fireClip;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 0.6f;
        [Range(0, 1)] [SerializeField] private float _warningAudioVolume = 0.3f;

        private AudioSource _motorAudioSource;
        private Vector3 _lastPlayerPos;
        private Vector3 _playerVelocity;
        private Renderer _renderer;
        private MaterialPropertyBlock _propertyBlock;
        private static readonly int EmissionColorID = Shader.PropertyToID("_EmissionColor");
        private static readonly int FresnelPowerID = Shader.PropertyToID("_FresnelPower");

        // Fresnel power values for warning flash
        private const float WarningFresnelPower = 0.1f;
        private const float NormalFresnelPower = 6f;

        // Update-based flash system (replaces coroutines for reliability)
        private bool _isFlashing;
        private float _flashTimer;
        private bool _isFresnelFlash; // true = fresnel warning flash, false = emission fire flash

        protected override void Awake()
        {
            base.Awake();
            // Find the first enabled renderer (skip disabled placeholder renderers)
            foreach (var r in GetComponentsInChildren<Renderer>())
            {
                if (r.enabled)
                {
                    _renderer = r;
                    break;
                }
            }
            if (_renderer != null)
            {
                _propertyBlock = new MaterialPropertyBlock();
            }

            // Initialize motor audio source
            _motorAudioSource = gameObject.AddComponent<AudioSource>();
            _motorAudioSource.loop = true;
            _motorAudioSource.playOnAwake = false;
            _motorAudioSource.spatialBlend = 1f; // 3D sound
        }

        public override void OnSpawn()
        {
            base.OnSpawn();

            Debug.Log($"ShooterBot [{name}]: Spawned with FireRate={EffectiveFireRate}s, FiringRange={EffectiveFiringRange}m");

            // Randomize position offset within configured ranges
            _targetOffset = new Vector3(
                Random.Range(OffsetRangeX.x, OffsetRangeX.y),
                Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                Random.Range(OffsetRangeZ.x, OffsetRangeZ.y)
            );

            // Initialize player position tracking for velocity-based lead targeting
            if (Spawner && Spawner.Player)
            {
                _lastPlayerPos = Spawner.Player.position;
                _playerVelocity = Vector3.zero;
            }

            // Clear any property block overrides to use material's default emission
            if (_renderer != null && _propertyBlock != null)
            {
                _propertyBlock.Clear();
                _renderer.SetPropertyBlock(_propertyBlock);
            }

            // Start motor loop sound
            if (_motorLoopClip != null && _motorAudioSource != null)
            {
                _motorAudioSource.clip = _motorLoopClip;
                _motorAudioSource.volume = _audioVolume;
                _motorAudioSource.Play();
            }
        }

        protected override void UpdateMovement()
        {
            if (!Spawner || !Spawner.Player) return;

            var playerTransform = Spawner.Player;

            // Calculate target position: camera + offset in world space
            Vector3 targetPosition = Camera.main.transform.TransformPoint(_targetOffset);

            // Smoothly interpolate toward target (keeps up with any player speed)
            Vector3 currentPos = transform.position;
            
            var distanceMultiplier = Mathf.Min(Mathf.Max(Vector3.Distance(targetPosition, currentPos), 1f), 3f);
            var adjustedFollowSpeed = FollowSpeed * distanceMultiplier;
            Vector3 newPosition = Vector3.MoveTowards(currentPos, targetPosition, Time.deltaTime * adjustedFollowSpeed);

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

        private Vector3 CalculateLeadPosition(Vector3 playerPos, float distanceToPlayer)
        {
            if (LeadFactor <= 0f || _playerVelocity.sqrMagnitude < 0.1f)
            {
                return playerPos;
            }

            // Calculate time for bullet to reach player (approximate)
            float bulletSpeed = Spawner.BulletSpeed;
            float timeToTarget = distanceToPlayer / bulletSpeed;

            // Predict where player will be, scaled by lead factor
            Vector3 leadOffset = _playerVelocity * timeToTarget * LeadFactor;

            return playerPos + leadOffset;
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

            // Stop motor sound
            if (_motorAudioSource != null && _motorAudioSource.isPlaying)
            {
                _motorAudioSource.Stop();
            }
        }

        public void ResetFireTimer()
        {
            // Use actual fire rate, with FlashDuration as minimum (for warning flash)
            _fireTimer = Mathf.Max(EffectiveFireRate, FlashDuration);
            Debug.Log($"ShooterBot [{name}]: Fire timer reset, will fire in {_fireTimer}s");
        }

        protected override void Update()
        {
            base.Update();
            
            UpdatePlayerVelocity();
            UpdateFlash();
            UpdateFiring();
        }

        private void UpdatePlayerVelocity()
        {
            if (!Spawner || !Spawner.Player) return;

            Vector3 currentPos = Spawner.Player.position;
            if (Time.deltaTime > 0.0001f)
            {
                // Calculate velocity from position delta (works during grinding/wall-riding)
                _playerVelocity = (currentPos - _lastPlayerPos) / Time.deltaTime;
            }
            _lastPlayerPos = currentPos;
        }

        private void UpdateFlash()
        {
            if (!_isFlashing) return;

            _flashTimer -= Time.deltaTime;
            if (_flashTimer <= 0f)
            {
                // Flash complete - clear property block to return to material's default state
                _isFlashing = false;
                if (_renderer != null && _propertyBlock != null)
                {
                    _propertyBlock.Clear();
                    _renderer.SetPropertyBlock(_propertyBlock);
                }
            }
        }

        private void StartWarningFlash(float duration)
        {
            if (_renderer == null || _propertyBlock == null) return;

            _isFlashing = true;
            _flashTimer = duration;
            _isFresnelFlash = true;
            _propertyBlock.SetFloat(FresnelPowerID, WarningFresnelPower);
            _renderer.SetPropertyBlock(_propertyBlock);
        }

        private void StartFireFlash(Color color, float duration)
        {
            if (_renderer == null || _propertyBlock == null) return;

            _isFlashing = true;
            _flashTimer = duration;
            _isFresnelFlash = false;
            _propertyBlock.Clear(); // Clear fresnel override first
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

            if (_botState != BotState.Active)
            {
                return;
            }

            // Skip firing logic if idle
            if (_isIdle)
            {
                return;
            }

            if (!_fireTimer.HasValue)
            {
                return;
            }

            _fireTimer -= Time.deltaTime;

            float effectiveRange = EffectiveFiringRange;
            float effectiveRate = EffectiveFireRate;

            // Start warning flash before firing (only if not already flashing)
            if (_fireTimer <= FlashDuration && !_isFlashing)
            {
                float dist = Vector3.Distance(transform.position, Spawner.Player.position);
                if (dist <= effectiveRange)
                {
                    StartWarningFlash(FlashDuration);

                    // Play warning sound (limited to 0.5 seconds)
                    if (_warningClip != null)
                    {
                        PlayClipForDuration(_warningClip, 0.5f, _warningAudioVolume);
                    }
                }
            }

            if (_fireTimer <= 0f)
            {
                var playerPos = Spawner.Player.position;
                float distanceToPlayer = Vector3.Distance(transform.position, playerPos);

                Debug.Log($"ShooterBot [{name}]: Fire timer elapsed. Distance={distanceToPlayer:F1}m, FiringRange={effectiveRange}m, MyPos={transform.position}");

                if (distanceToPlayer <= effectiveRange)
                {
                    // Calculate lead position based on player velocity
                    Vector3 targetPos = CalculateLeadPosition(playerPos, distanceToPlayer);
                    var direction = (targetPos - transform.position).normalized;
                    Debug.Log($"ShooterBot [{name}]: FIRING bullet toward predicted position {targetPos}");
                    Spawner.SpawnBullet(transform.position, direction, this);

                    // Trigger fire flash at moment of shooting (overrides any current flash)
                    StartFireFlash(FireFlashColor * FireFlashIntensity, FireFlashDuration);

                    // Play fire sound (limited to 0.15 seconds)
                    if (_fireClip != null)
                    {
                        PlayClipForDuration(_fireClip, 0.15f, _audioVolume);
                    }
                }
                else
                {
                    Debug.Log($"ShooterBot [{name}]: Player out of range ({distanceToPlayer:F1}m > {effectiveRange}m), not firing.");
                }

                _fireTimer = EffectiveFireRate;  // Auto-reload for continuous firing
            }
        }

        public override void OnCommandReceived(string command, params object[] args)
        {
            base.OnCommandReceived(command, args);
            
            switch (command)
            {
                case "Attack":
                    _isIdle = false;
                    ResetFireTimer();
                    break;
            }
        }

        protected override void OnValidate()
        {
            base.OnValidate();
            if (Application.isPlaying)
            {
                Debug.Log($"ShooterBot [{name}]: Parameters updated - EffectiveFireRate={EffectiveFireRate}, EffectiveFiringRange={EffectiveFiringRange}");
            }
        }

        private void PlayClipForDuration(AudioClip clip, float duration, float volume)
        {
            var tempGO = new GameObject("TempAudio");
            tempGO.transform.position = transform.position;
            var audioSource = tempGO.AddComponent<AudioSource>();
            audioSource.clip = clip;
            audioSource.volume = volume;
            audioSource.Play();
            Destroy(tempGO, duration);
        }
    }
}
