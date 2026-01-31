using StarterAssets;
using UnityEngine;
using Random = UnityEngine.Random;

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

        [field: Tooltip("Prefab for explosion radius visualization")]
        [field: SerializeField]
        public GameObject ExplosionRadiusPrefab { get; private set; }

        [Header("Countdown Settings")]
        [field: Tooltip("Distance at which the countdown begins")]
        [field: SerializeField]
        public float TriggerDistance { get; private set; } = 8f;

        [field: Tooltip("Duration of ramping flash phase (seconds)")]
        [field: SerializeField]
        public float FlashDuration { get; private set; } = 1f;

        [field: Tooltip("Duration of solid red before explosion (seconds)")]
        [field: SerializeField]
        public float SolidRedDuration { get; private set; } = 0.5f;

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
        [Tooltip("Explosion sounds (random selection)")]
        [SerializeField] private AudioClip[] _explosionClips;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 1f;
        [Range(0, 1)] [SerializeField] private float _chargeAudioVolume = 0.3f;

        private AudioSource _chargeAudioSource;
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

        protected override void Awake()
        {
            base.Awake();

            // Initialize charge audio source
            _chargeAudioSource = gameObject.AddComponent<AudioSource>();
            _chargeAudioSource.loop = true;
            _chargeAudioSource.playOnAwake = false;
            _chargeAudioSource.spatialBlend = 1f; // 3D sound

            // Cache renderer for visual feedback (find first enabled renderer)
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
            _isArmed = false;
            _countdownTimer = 0f;
        }

        public override void OnRecycle()
        {
            base.OnRecycle();

            // Reset countdown state
            _isArmed = false;
            _countdownTimer = 0f;

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
            if (_countdownTimer < FlashDuration)
            {
                // Flashing phase: speed ramps up over time
                float t = _countdownTimer / FlashDuration;
                float flashSpeed = Mathf.Lerp(FlashSpeedStart, FlashSpeedEnd, t);

                // Oscillate between 0 and 1
                flash = (Mathf.Sin(Time.time * flashSpeed * Mathf.PI * 2f) + 1f) * 0.5f;
            }
            else
            {
                // Solid red phase
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
