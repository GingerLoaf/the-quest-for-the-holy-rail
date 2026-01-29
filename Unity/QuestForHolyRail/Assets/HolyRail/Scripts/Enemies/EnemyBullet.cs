using HolyRail.Scripts.FX;
using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class EnemyBullet : MonoBehaviour
    {
        [Header("Parry Effects")]
        [Tooltip("Particle system to enable on successful parry (shuriken effect)")]
        public ParticleSystem ParryEffectParticles;

        [Tooltip("Color of the bullet after successful parry (emission color)")]
        public Color DeflectedColor = new Color(0f, 1f, 1f); // Cyan/teal default

        [Tooltip("Color of the bullet when in parry range (flashing)")]
        public Color ParryFlashColor = new Color(1f, 0.5f, 0f); // Orange default

        [Tooltip("Emission intensity multiplier for deflected bullet")]
        public float DeflectedIntensity = 5f;

        private EnemySpawner _spawner;
        private Vector3 _direction;
        private float _lifetime;

        private BaseEnemyBot _sourceBot;
        private bool _isDeflected;
        private MeshRenderer _renderer;
        private MaterialPropertyBlock _propertyBlock;
        private static readonly int EmissionColorID = Shader.PropertyToID("_EmissionColor");
        private Color _originalEmissionColor;
        private bool _inParryThreshold;
        private CharacterController _playerController;
        private Vector3 _lastPlayerPos;
        private float _playerSpeed;

        public bool IsDeflected => _isDeflected;
        public BaseEnemyBot SourceBot => _sourceBot;

        private void Awake()
        {
            _renderer = GetComponentInChildren<MeshRenderer>();
            if (_renderer != null)
            {
                _propertyBlock = new MaterialPropertyBlock();
                _originalEmissionColor = _renderer.sharedMaterial.GetColor(EmissionColorID);
            }
        }

        public void Initialize(EnemySpawner spawner)
        {
            _spawner = spawner;

            // Cache player's CharacterController for velocity access
            if (_spawner != null && _spawner.Player != null)
            {
                _playerController = _spawner.Player.GetComponent<CharacterController>();
            }
        }

        public void OnSpawn(Vector3 direction, BaseEnemyBot sourceBot = null)
        {
            _direction = direction.normalized;
            _lifetime = 0f;
            _sourceBot = sourceBot;
            _isDeflected = false;
            _inParryThreshold = false;

            // Initialize player position tracking for velocity calculation
            if (_spawner != null && _spawner.Player != null)
            {
                _lastPlayerPos = _spawner.Player.position;
                _playerSpeed = 0f;
            }

            // Reset to original emission color (not ParryFlashColor)
            // This ensures bullets spawn with their normal color, making the
            // orange parry flash visible when entering parry range
            if (_renderer != null && _propertyBlock != null)
            {
                _propertyBlock.SetColor(EmissionColorID, _originalEmissionColor);
                _renderer.SetPropertyBlock(_propertyBlock);
            }
        }

        public void OnRecycle()
        {
            _direction = Vector3.zero;
            _lifetime = 0f;
            _sourceBot = null;
            _isDeflected = false;
            _inParryThreshold = false;

            // Clear property block to reset to shared material defaults
            if (_renderer != null && _propertyBlock != null)
            {
                _propertyBlock.Clear();
                _renderer.SetPropertyBlock(_propertyBlock);
            }

            // Disable parry effect particles
            if (ParryEffectParticles != null)
            {
                var emission = ParryEffectParticles.emission;
                emission.enabled = false;
                ParryEffectParticles.Stop();
                ParryEffectParticles.Clear();
            }
        }

        public void Deflect()
        {
            if (_isDeflected || _sourceBot == null) return;
            _isDeflected = true;

            // Set deflected color using MaterialPropertyBlock for per-instance override
            if (_renderer != null && _propertyBlock != null)
            {
                _propertyBlock.SetColor(EmissionColorID, DeflectedColor * DeflectedIntensity);
                _renderer.SetPropertyBlock(_propertyBlock);
            }

            // Enable parry effect particle system
            if (ParryEffectParticles != null)
            {
                var emission = ParryEffectParticles.emission;
                emission.enabled = true;
                ParryEffectParticles.Play();
            }
        }

        public void SetBrightness(float multiplier)
        {
            if (_renderer == null || _propertyBlock == null) return;
            _propertyBlock.SetColor(EmissionColorID, ParryFlashColor * multiplier);
            _renderer.SetPropertyBlock(_propertyBlock);
        }

        private void HitPlayer()
        {
            if (_spawner == null || _spawner.Player == null) return;

            Debug.Log("EnemyBullet: Hit player (distance check)!");

            // Knock player off rail if grinding and toggle is enabled
            if (_spawner.BulletsKnockOffRail)
            {
                var grinder = _spawner.Player.GetComponentInParent<ThirdPersonController_RailGrinder>();
                if (grinder != null)
                {
                    grinder.StopGrind();
                }
            }

            // Flash player red for visual feedback
            if (PlayerHitFlash.Instance != null)
            {
                PlayerHitFlash.Instance.Flash();
            }

            // Recycle this bullet
            _spawner.RecycleBullet(this);
        }

        private float CalculateBulletSpeed()
        {
            // Base speed is always the configured bullet speed
            float baseSpeed = _spawner.BulletSpeed;

            if (!_spawner.BulletSpeedScalesWithPlayer)
            {
                return baseSpeed;
            }

            // Bullet speed is player speed + base speed, ensuring bullets ALWAYS catch up
            // This guarantees the bullet closes distance regardless of player movement
            float dynamicSpeed = _playerSpeed + baseSpeed;

            // Minimum speed is still the base speed (for when player is stationary)
            return Mathf.Max(dynamicSpeed, baseSpeed);
        }

        public void SetInParryThreshold(bool inThreshold)
        {
            if (_inParryThreshold == inThreshold) return;
            _inParryThreshold = inThreshold;
            Debug.Log($"EnemyBullet: SetInParryThreshold({inThreshold})");
            // Brightness is now handled in Update via sine wave when in threshold
            if (!_isDeflected && !inThreshold)
            {
                // Reset to original emission color
                if (_renderer != null && _propertyBlock != null)
                {
                    _propertyBlock.SetColor(EmissionColorID, _originalEmissionColor);
                    _renderer.SetPropertyBlock(_propertyBlock);
                }
            }
        }

        private void Update()
        {
            if (!_spawner)
            {
                Debug.LogWarning("EnemyBullet: No spawner reference!");
                return;
            }

            // Track player speed from position delta (works during grinding when CharacterController is disabled)
            if (_spawner.Player != null && Time.deltaTime > 0.0001f)
            {
                Vector3 currentPlayerPos = _spawner.Player.position;
                Vector3 playerDelta = currentPlayerPos - _lastPlayerPos;
                float instantSpeed = playerDelta.magnitude / Time.deltaTime;
                // Smooth the speed to avoid jitter
                _playerSpeed = Mathf.Lerp(_playerSpeed, instantSpeed, Time.deltaTime * 8f);
                _lastPlayerPos = currentPlayerPos;
            }

            // Calculate target position
            Vector3 targetPos;
            bool targetingPlayer = false;

            if (_isDeflected && _sourceBot != null && _sourceBot.gameObject.activeInHierarchy)
            {
                // Deflected bullets home toward source bot
                targetPos = _sourceBot.transform.position;
            }
            else if (!_isDeflected && _spawner.Player != null)
            {
                // Non-deflected bullets ALWAYS track directly to player's center
                targetPos = _spawner.Player.position;
                targetPos.y += 0.5f; // Slightly above feet, center of capsule
                targetingPlayer = true;
            }
            else
            {
                // No target - continue in current direction
                targetPos = transform.position + _direction * 10f;
            }

            // Calculate direction to target
            Vector3 toTarget = targetPos - transform.position;
            float distanceToTarget = toTarget.magnitude;

            // GUARANTEED HIT: If within hit radius of player, trigger hit immediately
            // This bypasses any collider issues and ensures bullets always hit
            // Hit radius (0.6f) is much smaller than parry threshold (12f) to give time to parry
            if (targetingPlayer && distanceToTarget < 0.6f)
            {
                HitPlayer();
                return;
            }

            if (distanceToTarget > 0.01f)
            {
                // Direct tracking - always face the player exactly
                _direction = toTarget.normalized;
            }

            // Rotate bullet to face movement direction
            if (_direction.sqrMagnitude > 0.01f)
            {
                transform.rotation = Quaternion.LookRotation(_direction);
            }

            // Calculate bullet speed: always significantly faster than player
            float bulletSpeed = CalculateBulletSpeed();

            // Slow down when in parry range to give player reaction time
            if (_inParryThreshold && !_isDeflected)
            {
                bulletSpeed *= 0.5f; // Half speed in parry zone for fair gameplay
            }

            // Move toward target
            Vector3 movement = _direction * (bulletSpeed * Time.deltaTime);
            transform.position += movement;

            _lifetime += Time.deltaTime;

            // Sine wave flash when in parry threshold
            if (_inParryThreshold && !_isDeflected)
            {
                float t = (Mathf.Sin(Time.time * _spawner.ParryFlashSpeed * Mathf.PI * 2f) + 1f) * 0.5f;
                float brightness = Mathf.Lerp(_spawner.ParryFlashMin, _spawner.ParryFlashMax, t);
                SetBrightness(brightness);
            }

            float maxLifetime = _spawner.BulletLifetime;
            if (_lifetime >= maxLifetime)
            {
                _spawner.RecycleBullet(this);
            }
        }

        private void OnDrawGizmos()
        {
            // Draw bullet position and direction in Scene view
            Gizmos.color = _isDeflected ? Color.cyan : Color.red;
            Gizmos.DrawWireSphere(transform.position, 0.5f);
            Gizmos.DrawRay(transform.position, _direction * 3f);
        }

        private void OnTriggerEnter(Collider other)
        {
            // Ignore trigger colliders (pass through trigger volumes like spawn zones, rail triggers, etc.)
            // We only want to react to solid geometry and specific game objects
            if (other.isTrigger)
            {
                // Exception: still handle player even if they have a trigger collider
                if (!other.CompareTag("Player"))
                {
                    return;
                }
            }

            Debug.Log($"EnemyBullet: OnTriggerEnter with '{other.name}' (tag={other.tag}, layer={LayerMask.LayerToName(other.gameObject.layer)}, isTrigger={other.isTrigger})");

            // Ignore other bullets
            if (other.GetComponent<EnemyBullet>() != null) return;

            // Check for bot hit when deflected (must check BEFORE ignoring source bot)
            if (_isDeflected)
            {
                var bot = other.GetComponent<BaseEnemyBot>();
                if (bot != null)
                {
                    Debug.Log($"EnemyBullet: Deflected bullet hit bot '{bot.name}', killing it");
                    _spawner?.KillBotWithExplosion(bot);
                    _spawner?.RecycleBullet(this);
                    return;
                }
            }

            // Ignore the source bot that fired this bullet (only when not deflected)
            if (_sourceBot != null && other.gameObject == _sourceBot.gameObject) return;

            // Ignore all bots when not deflected (fly past them to hit the player)
            if (!_isDeflected && other.GetComponent<BaseEnemyBot>() != null) return;

            // Skip player damage if deflected
            if (_isDeflected && other.CompareTag("Player")) return;

            if (other.CompareTag("Player"))
            {
                Debug.Log("EnemyBullet: Hit player!");
                // Knock player off rail if grinding and toggle is enabled
                if (_spawner && _spawner.BulletsKnockOffRail)
                {
                    var grinder = other.GetComponentInParent<ThirdPersonController_RailGrinder>();
                    if (grinder)
                    {
                        grinder.StopGrind();
                    }
                }

                // Flash player red for visual feedback
                if (PlayerHitFlash.Instance != null)
                {
                    PlayerHitFlash.Instance.Flash();
                }

                // TODO: Apply damage to player
                _spawner?.RecycleBullet(this);
                return;
            }

            // Hit solid world geometry - recycle bullet
            Debug.Log($"EnemyBullet: Hit solid obstacle '{other.name}', recycling");
            _spawner?.RecycleBullet(this);
        }
    }
}
