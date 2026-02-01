using StarterAssets;
using UnityEngine;
using Random = UnityEngine.Random;

namespace HolyRail.Scripts.Enemies
{
    public class KamikazeBot : BaseEnemyBot
    {
        [Header("Kamikaze Settings")]
        [Tooltip("Movement speed when chasing the player")]
        public float ChaseSpeed = 12f;

        [Tooltip("The distance at which the bot explodes.")]
        public float ExplosionRadius = 3f;

        [Tooltip("The amount of damage dealt to the player.")]
        public int DamageAmount = 1;

        [Tooltip("A GameObject for the explosion particle effect.")]
        public GameObject ExplosionEffect;

        [field: Tooltip("Prefab for explosion radius visualization")]
        [field: SerializeField]
        public GameObject ExplosionRadiusPrefab { get; private set; }

        [Header("Countdown Settings")]
        [field: Tooltip("Distance at which the countdown begins")]
        [field: SerializeField]
        public float TriggerDistance { get; private set; } = 3.5f;

        [field: Tooltip("Speed multiplier when armed/flashing")]
        [field: SerializeField]
        public float ArmedSpeedBoost { get; private set; } = 1.5f;

        [field: Tooltip("Speed multiplier when player is grinding")]
        [field: SerializeField]
        public float GrindingSpeedBoost { get; private set; } = 1.4f;

        [field: Tooltip("How far ahead of the player to target when grinding (for head-on attacks)")]
        [field: SerializeField]
        public float GrindingLeadDistance { get; private set; } = 8f;

        [field: Tooltip("Minimum distance from player - bot will stop approaching when this close")]
        [field: SerializeField]
        public float MinDistanceFromPlayer { get; private set; } = 2f;

        [field: Tooltip("Duration of ramping flash phase (seconds)")]
        [field: SerializeField]
        public float FlashDuration { get; private set; } = 0.5f;

        [field: Tooltip("Duration of solid red before explosion (seconds)")]
        [field: SerializeField]
        public float SolidRedDuration { get; private set; } = 0f;

        [field: Tooltip("Flash speed at start of countdown (cycles per second)")]
        [field: SerializeField]
        public float FlashSpeedStart { get; private set; } = 1.5f;

        [field: Tooltip("Flash speed at end of flash phase (cycles per second)")]
        [field: SerializeField]
        public float FlashSpeedEnd { get; private set; } = 12f;

        [field: Tooltip("Fresnel/emission color when flashing")]
        [field: SerializeField]
        public Color FlashColor { get; private set; } = Color.red;

        [field: Tooltip("Emission intensity multiplier")]
        [field: SerializeField]
        public float FlashIntensity { get; private set; } = 3f;

        [Header("Audio")]
        [Tooltip("Looping charge/flyby sound while chasing")]
        [SerializeField] private AudioClip _chargeLoopClip;
        [Tooltip("Looping sound when armed/flashing (about to explode)")]
        [SerializeField] private AudioClip _armedLoopClip;
        [Tooltip("Explosion sounds (random selection)")]
        [SerializeField] private AudioClip[] _explosionClips;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 1f;
        [Range(0, 1)] [SerializeField] private float _chargeAudioVolume = 0.3f;
        [SerializeField] private float _armedAudioVolume = 3f;

        private AudioSource _chargeAudioSource;
        private AudioSource _armedAudioSource;
        private bool _isExploding;
        private Renderer _renderer;
        private MaterialPropertyBlock _propBlock;
        private static readonly int FresnelPowerId = Shader.PropertyToID("_FresnelPower");
        private static readonly int FresnelColorId = Shader.PropertyToID("_FresnelColor");
        private static readonly int EmissionColorId = Shader.PropertyToID("_EmissionColor");

        // Fresnel power values (lower = more intense glow)
        private const float NormalFresnelPower = 6f;
        private const float FlashFresnelPower = 0.1f;

        // Countdown state
        private bool _isArmed;
        private float _countdownTimer;

        // Player controller reference for grinding detection
        private StarterAssets.ThirdPersonController_RailGrinder _playerController;

        protected override void Awake()
        {
            base.Awake();

            // Initialize charge audio source
            _chargeAudioSource = gameObject.AddComponent<AudioSource>();
            _chargeAudioSource.loop = true;
            _chargeAudioSource.playOnAwake = false;
            _chargeAudioSource.spatialBlend = 1f; // 3D sound

            // Initialize armed audio source
            _armedAudioSource = gameObject.AddComponent<AudioSource>();
            _armedAudioSource.loop = true;
            _armedAudioSource.playOnAwake = false;
            _armedAudioSource.spatialBlend = 0.5f; // Partial 3D sound for better audibility
            _armedAudioSource.minDistance = 5f;
            _armedAudioSource.maxDistance = 100f;

            // Find the SF_Drone_ZR7 SkinnedMeshRenderer specifically for visual feedback
            foreach (var smr in GetComponentsInChildren<SkinnedMeshRenderer>())
            {
                if (smr.gameObject.name == "SF_Drone_ZR7")
                {
                    _renderer = smr;
                    break;
                }
            }
            if (_renderer != null)
            {
                _propBlock = new MaterialPropertyBlock();
            }
        }

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

            // Cache player controller reference
            if (_playerController == null)
            {
                _playerController = Spawner.Player.GetComponent<StarterAssets.ThirdPersonController_RailGrinder>();
            }

            // Check if player is grinding
            bool playerIsGrinding = _playerController != null && _playerController.IsGrinding;

            // Calculate target position - lead the player when grinding for head-on attacks
            Vector3 targetPosition = Spawner.Player.position;
            if (playerIsGrinding)
            {
                // Target ahead of the player in their movement direction
                Vector3 playerForward = Spawner.Player.forward;
                targetPosition = Spawner.Player.position + playerForward * GrindingLeadDistance;
            }

            Vector3 direction = (targetPosition - transform.position).normalized;
            float distanceToPlayer = Vector3.Distance(transform.position, Spawner.Player.position);

            // Only move if we're farther than minimum distance
            if (distanceToPlayer > MinDistanceFromPlayer)
            {
                // Move toward player at chase speed (with boosts)
                float speed = ChaseSpeed;
                if (playerIsGrinding) speed *= GrindingSpeedBoost;
                if (_isArmed) speed *= ArmedSpeedBoost;

                // Use obstacle avoidance to navigate around walls/floors
                transform.position = MoveWithAvoidance(transform.position, targetPosition, speed);
            }

            // Face the movement direction (or player if not moving much)
            Vector3 lookDirection = (targetPosition - transform.position).normalized;
            if (lookDirection.sqrMagnitude > 0.001f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(lookDirection);
                transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / RotationSmoothTime);
            }
        }

        public override void OnSpawn()
        {
            base.OnSpawn();
            _isExploding = false;
            _isArmed = false;
            _countdownTimer = 0f;
        }

        public override void OnRecycle()
        {
            base.OnRecycle();

            // Reset countdown state
            _isArmed = false;
            _countdownTimer = 0f;

            // Stop armed sound
            if (_armedAudioSource != null && _armedAudioSource.isPlaying)
            {
                _armedAudioSource.Stop();
            }

            // Reset visual state to default
            if (_renderer != null && _propBlock != null)
            {
                _propBlock.Clear();
                _renderer.SetPropertyBlock(_propBlock);
            }
        }

        protected override void Update()
        {
            base.Update();

            if (_isExploding) return;
            if (_isIdle) return;
            if (!Spawner || !Spawner.Player) return;

            float distanceToPlayer = Vector3.Distance(transform.position, Spawner.Player.position);

            // Check if we should arm the countdown
            if (!_isArmed && distanceToPlayer <= TriggerDistance)
            {
                _isArmed = true;
                _countdownTimer = 0f;
                Debug.Log($"KamikazeBot [{name}]: Armed! Starting countdown.");

                // Start armed loop sound
                if (_armedLoopClip != null && _armedAudioSource != null)
                {
                    _armedAudioSource.clip = _armedLoopClip;
                    _armedAudioSource.volume = _armedAudioVolume;
                    _armedAudioSource.Play();
                }
            }

            // Run countdown if armed
            if (_isArmed)
            {
                _countdownTimer += Time.deltaTime;
                UpdateVisualFlash();

                // Check if it's time to explode
                float totalCountdown = FlashDuration + SolidRedDuration;
                if (_countdownTimer >= totalCountdown)
                {
                    Explode();
                }
            }
        }

        private void UpdateVisualFlash()
        {
            if (_renderer == null || _propBlock == null) return;
            if (!_isArmed) return;

            float flash;
            if (_countdownTimer < FlashDuration || SolidRedDuration <= 0f)
            {
                // Flashing phase: speed ramps up over time
                float t = FlashDuration > 0f ? Mathf.Clamp01(_countdownTimer / FlashDuration) : 1f;
                float flashSpeed = Mathf.Lerp(FlashSpeedStart, FlashSpeedEnd, t);

                // Oscillate between 0 and 1
                flash = (Mathf.Sin(Time.time * flashSpeed * Mathf.PI * 2f) + 1f) * 0.5f;
            }
            else
            {
                // Solid red phase (only if SolidRedDuration > 0)
                flash = 1f;
            }

            // Set fresnel power (lower = more glow)
            float fresnelPower = Mathf.Lerp(NormalFresnelPower, FlashFresnelPower, flash);
            _propBlock.SetFloat(FresnelPowerId, fresnelPower);

            // Set fresnel color to red
            _propBlock.SetColor(FresnelColorId, FlashColor);

            // Set emission color scaled by flash intensity
            Color emissionColor = FlashColor * FlashIntensity * flash;
            _propBlock.SetColor(EmissionColorId, emissionColor);

            _renderer.SetPropertyBlock(_propBlock);
        }

        private void Explode()
        {
            _isExploding = true;

            // Stop charge sound
            if (_chargeAudioSource != null && _chargeAudioSource.isPlaying)
            {
                _chargeAudioSource.Stop();
            }

            // Stop armed sound
            if (_armedAudioSource != null && _armedAudioSource.isPlaying)
            {
                _armedAudioSource.Stop();
            }

            // Play explosion sound with large 3D range
            if (_explosionClips != null && _explosionClips.Length > 0)
            {
                var clip = _explosionClips[Random.Range(0, _explosionClips.Length)];
                var tempGO = new GameObject("ExplosionAudio");
                tempGO.transform.position = transform.position;
                var audioSource = tempGO.AddComponent<AudioSource>();
                audioSource.clip = clip;
                audioSource.volume = _audioVolume;
                audioSource.spatialBlend = 1f;
                audioSource.minDistance = 5f;
                audioSource.maxDistance = 500f;
                audioSource.rolloffMode = AudioRolloffMode.Linear;
                audioSource.Play();
                Destroy(tempGO, clip.length);
            }

            if (ExplosionEffect)
            {
                Instantiate(ExplosionEffect, transform.position, Quaternion.identity);
            }

            // Spawn explosion radius visualization
            if (ExplosionRadiusPrefab != null)
            {
                Debug.Log($"KamikazeBot [{name}]: Spawning explosion radius visual at {transform.position}");
                var radiusVisual = Instantiate(ExplosionRadiusPrefab, transform.position, Quaternion.identity);
                var visualScript = radiusVisual.GetComponent<FX.ExplosionRadiusVisual>();
                if (visualScript != null)
                {
                    visualScript.Initialize(ExplosionRadius);
                }
                else
                {
                    Debug.LogWarning($"KamikazeBot [{name}]: ExplosionRadiusVisual script not found on prefab!");
                }
            }
            else
            {
                Debug.LogWarning($"KamikazeBot [{name}]: ExplosionRadiusPrefab is null!");
            }

            if (Spawner && Spawner.Player)
            {
                float distanceToPlayer = Vector3.Distance(transform.position, Spawner.Player.position);
                if (distanceToPlayer <= ExplosionRadius)
                {
                    GameSessionManager.Instance.TakeDamage(DamageAmount);
                }
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

                    // Start charge sound when attacking
                    if (_chargeLoopClip != null && _chargeAudioSource != null)
                    {
                        _chargeAudioSource.clip = _chargeLoopClip;
                        _chargeAudioSource.volume = _chargeAudioVolume;
                        _chargeAudioSource.Play();
                    }
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
