using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class EnemyBullet : MonoBehaviour
    {
        private EnemySpawner _spawner;
        private Vector3 _direction;
        private float _lifetime;
        private const float MaxLifetime = 5f;

        private BaseEnemyBot _sourceBot;
        private bool _isDeflected;
        private Renderer _renderer;
        private Material _material;
        private Color _baseEmissionColor;
        private bool _inParryThreshold;

        public bool IsDeflected => _isDeflected;
        public BaseEnemyBot SourceBot => _sourceBot;

        private void Awake()
        {
            _renderer = GetComponentInChildren<Renderer>();
            if (_renderer != null)
            {
                _material = _renderer.material;
                _baseEmissionColor = _material.GetColor("_EmissionColor");
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
            SetBrightness(1f);
        }

        public void Deflect()
        {
            if (_isDeflected || _sourceBot == null) return;
            _isDeflected = true;
            SetBrightness(5f);
        }

        public void SetBrightness(float multiplier)
        {
            if (_material != null)
            {
                _material.SetColor("_EmissionColor", _baseEmissionColor * multiplier);
            }
        }

        public void SetInParryThreshold(bool inThreshold)
        {
            if (_inParryThreshold == inThreshold) return;
            _inParryThreshold = inThreshold;
            if (!_isDeflected)
            {
                SetBrightness(inThreshold ? 5f : 1f);
            }
        }

        private void Update()
        {
            if (!_spawner)
            {
                return;
            }

            // If deflected, home toward source bot
            if (_isDeflected && _sourceBot != null && _sourceBot.gameObject.activeInHierarchy)
            {
                _direction = (_sourceBot.transform.position - transform.position).normalized;
            }

            transform.position += _direction * (_spawner.BulletSpeed * Time.deltaTime);

            _lifetime += Time.deltaTime;
            if (_lifetime >= MaxLifetime)
            {
                _spawner.RecycleBullet(this);
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            // Skip player damage if deflected
            if (_isDeflected && other.CompareTag("Player")) return;

            // Check for bot hit when deflected
            if (_isDeflected)
            {
                var bot = other.GetComponent<BaseEnemyBot>();
                if (bot != null)
                {
                    _spawner?.KillBotWithExplosion(bot);
                    _spawner?.RecycleBullet(this);
                    return;
                }
            }

            if (other.CompareTag("Player"))
            {
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
            }
        }
    }
}
