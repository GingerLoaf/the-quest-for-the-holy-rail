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
        }

        public void OnSpawn(Vector3 direction, BaseEnemyBot sourceBot = null)
        {
            _direction = direction.normalized;
            _lifetime = 0f;
            _sourceBot = sourceBot;
            _isDeflected = false;
            _inParryThreshold = false;
            SetBrightness(1f);
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
            _propertyBlock.SetColor(EmissionColorID, _originalEmissionColor * multiplier);
            _renderer.SetPropertyBlock(_propertyBlock);
        }

        public void SetInParryThreshold(bool inThreshold)
        {
            if (_inParryThreshold == inThreshold) return;
            _inParryThreshold = inThreshold;
            Debug.Log($"EnemyBullet: SetInParryThreshold({inThreshold})");
            // Brightness is now handled in Update via sine wave when in threshold
            if (!_isDeflected && !inThreshold)
            {
                SetBrightness(1f);
            }
        }

        private void Update()
        {
            if (!_spawner)
            {
                Debug.LogWarning("EnemyBullet: No spawner reference!");
                return;
            }

            // If deflected, home toward source bot (full homing)
            if (_isDeflected && _sourceBot != null && _sourceBot.gameObject.activeInHierarchy)
            {
                _direction = (_sourceBot.transform.position - transform.position).normalized;
            }
            // If not deflected and homing is enabled, gradually turn toward player
            else if (!_isDeflected && _spawner.BulletHomingAmount > 0f && _spawner.Player != null)
            {
                Vector3 toPlayer = (_spawner.Player.position - transform.position).normalized;
                _direction = Vector3.Slerp(_direction, toPlayer, _spawner.BulletHomingAmount * Time.deltaTime * 5f).normalized;
            }

            Vector3 movement = _direction * (_spawner.BulletSpeed * Time.deltaTime);
            transform.position += movement;

            _lifetime += Time.deltaTime;

            // Sine wave flash when in parry threshold
            if (_inParryThreshold && !_isDeflected)
            {
                float t = (Mathf.Sin(Time.time * _spawner.ParryFlashSpeed * Mathf.PI * 2f) + 1f) * 0.5f;
                float brightness = Mathf.Lerp(_spawner.ParryFlashMin, _spawner.ParryFlashMax, t);
                SetBrightness(brightness);
            }

            // Debug: Log position every 0.5 seconds
            if (Mathf.FloorToInt(_lifetime * 2) != Mathf.FloorToInt((_lifetime - Time.deltaTime) * 2))
            {
                Debug.Log($"EnemyBullet: pos={transform.position}, dir={_direction}, speed={_spawner.BulletSpeed}, lifetime={_lifetime:F1}s");
            }

            float maxLifetime = _spawner.BulletLifetime;
            if (_lifetime >= maxLifetime)
            {
                Debug.Log($"EnemyBullet: Recycling after {maxLifetime}s lifetime");
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
