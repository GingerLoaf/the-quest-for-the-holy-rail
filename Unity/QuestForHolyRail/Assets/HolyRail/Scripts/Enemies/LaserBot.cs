using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    [ExecuteAlways]
    public class LaserBot : BaseEnemyBot
    {
        [Header("Laser Field Settings")]
        [Tooltip("Radius of the laser field in world units")]
        [SerializeField]
        private float _laserRadius = 5f;

        [Tooltip("Rotation speed of the lattice pattern on the front face (degrees/sec, negative = reverse)")]
        [Range(-180f, 180f)]
        [SerializeField]
        private float _patternSpinFront;

        [Tooltip("Rotation speed of the lattice pattern on the back face (degrees/sec, negative = reverse)")]
        [Range(-180f, 180f)]
        [SerializeField]
        private float _patternSpinBack;

        [Tooltip("Width of the laser lines")]
        [Range(0.001f, 0.2f)]
        [SerializeField]
        private float _lineWidth = 0.03f;

        [Tooltip("Brightness of the laser lattice")]
        [Range(0f, 10f)]
        [SerializeField]
        private float _latticeIntensity = 2f;

        [Tooltip("Pattern density of the lattice")]
        [Range(1f, 50f)]
        [SerializeField]
        private float _latticeFrequency = 10f;

        [Tooltip("Distortion amount for the lattice")]
        [Range(0f, 1f)]
        [SerializeField]
        private float _latticeNoise = 0.1f;

        [Tooltip("Intensity of the red glow at intersections")]
        [Range(0f, 10f)]
        [SerializeField]
        private float _intersectionGlowIntensity = 3f;

        [Header("Damage Settings")]
        [Tooltip("Amount of damage dealt to the player")]
        [SerializeField]
        private int _damageAmount = 1;

        [Tooltip("Cooldown between damage ticks (seconds)")]
        [SerializeField]
        private float _damageCooldown = 1f;

        [Header("References")]
        [Tooltip("The transform for the laser field object")]
        [SerializeField]
        private Transform _laserFieldTransform;

        [Tooltip("The renderer for the laser field mesh")]
        [SerializeField]
        private Renderer _laserFieldRenderer;

        [Tooltip("The collider for the laser field (damage area)")]
        [SerializeField]
        private BoxCollider _laserFieldCollider;

        [Tooltip("The collider for the bot body (boost detection)")]
        [SerializeField]
        private SphereCollider _botCollider;

        private MaterialPropertyBlock _propertyBlock;
        private float _lastDamageTime;

        private static readonly int LineWidthId = Shader.PropertyToID("_LineWidth");
        private static readonly int IntensityId = Shader.PropertyToID("_Intensity");
        private static readonly int FrequencyId = Shader.PropertyToID("_Frequency");
        private static readonly int NoiseAmountId = Shader.PropertyToID("_NoiseAmount");
        private static readonly int IntersectionIntensityId = Shader.PropertyToID("_IntersectionIntensity");
        private static readonly int PatternSpinFrontId = Shader.PropertyToID("_PatternSpinFront");
        private static readonly int PatternSpinBackId = Shader.PropertyToID("_PatternSpinBack");

        private void OnEnable()
        {
            _propertyBlock = new MaterialPropertyBlock();
            FindReferences();
            UpdateLaserField();
        }

        protected override void Awake()
        {
            base.Awake();
            _lastDamageTime = -_damageCooldown;
        }

        public override void OnSpawn()
        {
            base.OnSpawn();
            _lastDamageTime = -_damageCooldown;
            UpdateLaserField();
        }

        protected override void UpdateMovement()
        {
            // LaserBot is stationary - no movement logic needed
        }

        private void OnTriggerStay(Collider other)
        {
            if (!Application.isPlaying)
            {
                return;
            }

            if (!other.CompareTag("Player"))
            {
                return;
            }

            // Skip damage if idle
            if (_isIdle)
            {
                return;
            }

            if (Time.time < _lastDamageTime + _damageCooldown)
            {
                return;
            }

            _lastDamageTime = Time.time;
            ApplyDamageToPlayer(other);
        }

        private void ApplyDamageToPlayer(Collider playerCollider)
        {
            // TODO: Apply actual damage when health system is implemented
            Debug.Log($"LaserBot [{name}]: Would deal {_damageAmount} damage to player");

            GameSessionManager.Instance.TakeDamage(_damageAmount);
        }

        private void FindReferences()
        {
            if (_laserFieldTransform == null)
            {
                var laserField = transform.Find("LaserField");
                if (laserField != null)
                {
                    _laserFieldTransform = laserField;
                }
            }

            if (_laserFieldRenderer == null && _laserFieldTransform != null)
            {
                _laserFieldRenderer = _laserFieldTransform.GetComponent<Renderer>();
            }

            if (_laserFieldCollider == null && _laserFieldTransform != null)
            {
                _laserFieldCollider = _laserFieldTransform.GetComponent<BoxCollider>();
            }

            if (_botCollider == null)
            {
                _botCollider = GetComponent<SphereCollider>();
            }
        }

        private void UpdateLaserField()
        {
            UpdateLaserFieldScale();
            UpdateShaderParameters();
        }

        private void UpdateLaserFieldScale()
        {
            if (_laserFieldTransform == null)
            {
                return;
            }

            float diameter = _laserRadius * 2f;
            _laserFieldTransform.localScale = new Vector3(diameter, 0.1f, diameter);

            if (_laserFieldCollider != null)
            {
                // Box collider size is in local space, so account for the transform scale
                // Cylinder mesh is 1 unit diameter, 2 units tall in local space
                _laserFieldCollider.size = new Vector3(1f, 2f, 1f);
                _laserFieldCollider.center = Vector3.zero;
            }
        }

        private void UpdateShaderParameters()
        {
            if (_laserFieldRenderer == null || _propertyBlock == null)
            {
                return;
            }

            _laserFieldRenderer.GetPropertyBlock(_propertyBlock);
            _propertyBlock.SetFloat(LineWidthId, _lineWidth);
            _propertyBlock.SetFloat(IntensityId, _latticeIntensity);
            _propertyBlock.SetFloat(FrequencyId, _latticeFrequency);
            _propertyBlock.SetFloat(NoiseAmountId, _latticeNoise);
            _propertyBlock.SetFloat(IntersectionIntensityId, _intersectionGlowIntensity);
            _propertyBlock.SetFloat(PatternSpinFrontId, _patternSpinFront * Mathf.Deg2Rad);
            _propertyBlock.SetFloat(PatternSpinBackId, _patternSpinBack * Mathf.Deg2Rad);
            _laserFieldRenderer.SetPropertyBlock(_propertyBlock);
        }

        public override void OnCommandReceived(string command, params object[] args)
        {
            base.OnCommandReceived(command, args);
            
            switch (command)
            {
                case "Attack":
                    _isIdle = false;
                    Debug.Log($"LaserBot [{name}]: Received 'Attack' command, laser field activated");
                    break;
            }
        }

        protected override void OnValidate()
        {
            base.OnValidate();

            _laserRadius = Mathf.Max(0.1f, _laserRadius);

            if (_propertyBlock == null)
            {
                _propertyBlock = new MaterialPropertyBlock();
            }

            FindReferences();
            UpdateLaserField();
        }

        // TODO: Add boost detection when boost ability is implemented
        // public void OnBoostHit()
        // {
        //     if (Spawner != null)
        //     {
        //         Spawner.RecycleBot(this, true);
        //     }
        // }
    }
}
