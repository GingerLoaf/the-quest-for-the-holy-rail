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
        public Vector2 OffsetRangeX { get; private set; } = new(-4f, 4f);

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
        [field: Tooltip("Layer mask for wall collision (leave empty to disable wall avoidance)")]
        [field: SerializeField]
        public LayerMask WallLayerMask { get; private set; } = 0; // Default to nothing - enable specific layers as needed

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

            // Randomize initial fire timer to desynchronize bots that spawn together
            // Range is 50%-150% of fire rate so bots fire at different times
            _fireTimer = EffectiveFireRate * Random.Range(0.5f, 1.5f);

            Debug.Log($"ShooterBot [{name}]: Spawned with FireRate={EffectiveFireRate}s, FiringRange={EffectiveFiringRange}m, InitialTimer={_fireTimer:F2}s");

            // Calculate target offset for following the player
            if (Spawner && Spawner.Player)
            {
                Vector3 playerPos = Spawner.Player.position;
                Vector3 spawnPos = transform.position;

                // Randomize target position within offset ranges
                _targetOffset = new Vector3(
                    Random.Range(OffsetRangeX.x, OffsetRangeX.y),
                    Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                    Random.Range(OffsetRangeZ.x, OffsetRangeZ.y)
                );

                _lastPlayerPos = playerPos;
                _playerVelocity = Vector3.zero;

                Debug.Log($"[{name}] SPAWN: playerPos={playerPos}, myPos={spawnPos}, targetOffset={_targetOffset}, state={_botState}");
            }
            else
            {
                // Fallback if no player reference
                _targetOffset = new Vector3(
                    Random.Range(-2f, 2f),
                    Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                    OffsetRangeZ.x
                );
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

        public override void OnSpawn(bool startsIdle, Vector3 finalPosition, float enterDuration)
        {
            base.OnSpawn(startsIdle, finalPosition, enterDuration);

            // Randomize initial fire timer to desynchronize bots that spawn together
            // Range is 50%-150% of fire rate so bots fire at different times
            _fireTimer = EffectiveFireRate * Random.Range(0.5f, 1.5f);

            // Calculate target offset for following the player
            if (Spawner && Spawner.Player)
            {
                Vector3 playerPos = Spawner.Player.position;

                // Randomize target position within offset ranges
                _targetOffset = new Vector3(
                    Random.Range(OffsetRangeX.x, OffsetRangeX.y),
                    Random.Range(OffsetRangeY.x, OffsetRangeY.y),
                    Random.Range(OffsetRangeZ.x, OffsetRangeZ.y)
                );

                _lastPlayerPos = playerPos;
                _playerVelocity = Vector3.zero;

                Debug.Log($"[{name}] SPAWN (EnemyController): playerPos={playerPos}, myPos={transform.position}, finalPos={finalPosition}, targetOffset={_targetOffset}, state={_botState}");
            }

            // Clear any property block overrides
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

            Debug.Log($"ShooterBot [{name}]: Spawned via EnemyController with FireRate={EffectiveFireRate}s, FiringRange={EffectiveFiringRange}m, StartsIdle={startsIdle}, InitialTimer={_fireTimer:F2}s");
        }

        protected override void UpdateMovement()
        {
            if (!Spawner || !Spawner.Player) return;

            Vector3 playerPos = Spawner.Player.position;
            Vector3 currentPos = transform.position;

            // Target position: constant Z distance ahead, follow player X, maintain Y offset
            Vector3 targetPosition = new Vector3(
                playerPos.x + _targetOffset.x,
                playerPos.y + _targetOffset.y,
                playerPos.z + _targetOffset.z
            );

            // Calculate speed: at minimum match player Z velocity, plus extra to close the gap
            float playerZSpeed = Mathf.Max(0f, _playerVelocity.z);
            float distanceToTarget = Vector3.Distance(currentPos, targetPosition);
            float catchUpSpeed = distanceToTarget * 2f; // Close gap over ~0.5 seconds
            float moveSpeed = Mathf.Max(FollowSpeed, playerZSpeed + catchUpSpeed);

            // Smooth movement toward target
            Vector3 newPosition = Vector3.MoveTowards(currentPos, targetPosition, moveSpeed * Time.deltaTime);

            // DEBUG: Log every second
            if (Time.frameCount % 60 == 0)
            {
                Debug.Log($"[{name}] MOVE: pos={currentPos:F1} -> target={targetPosition:F1}, speed={moveSpeed:F1}, playerVel={_playerVelocity:F1}");
            }

            Vector3 preWallPos = newPosition;

            // Check for wall collision and resolve
            newPosition = ResolveWallCollision(currentPos, newPosition);

            // Check if wall blocked us
            if (Vector3.Distance(preWallPos, newPosition) > 0.01f)
            {
                Debug.LogWarning($"[{name}] WALL BLOCKED movement!");
            }

            transform.position = newPosition;

            // Face the player
            Vector3 toPlayer = playerPos - transform.position;
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
