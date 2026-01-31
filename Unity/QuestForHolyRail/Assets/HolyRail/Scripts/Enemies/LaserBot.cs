using HolyRail.Scripts.FX;
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

        [Tooltip("Force applied to knock the player back")]
        [SerializeField]
        private float _knockbackForce = 15f;

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

        // Continuous collision detection
        private Transform _playerTransform;
        private Vector3 _playerLastPosition;
        private ThirdPersonController_RailGrinder _playerController;
        private bool _isDestroyed;

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
            _isDestroyed = false;
            UpdateLaserField();
            CachePlayerReference();
        }

        private void CachePlayerReference()
        {
            if (Spawner != null && Spawner.Player != null)
            {
                _playerTransform = Spawner.Player;
                _playerController = _playerTransform.GetComponent<ThirdPersonController_RailGrinder>();
                if (_playerTransform != null)
                {
                    _playerLastPosition = _playerTransform.position;
                }
            }
            else
            {
                // Fallback: find player by tag
                var playerObj = GameObject.FindGameObjectWithTag("Player");
                if (playerObj != null)
                {
                    _playerTransform = playerObj.transform;
                    _playerController = playerObj.GetComponent<ThirdPersonController_RailGrinder>();
                    _playerLastPosition = _playerTransform.position;
                }
            }
        }

        protected override void UpdateMovement()
        {
            // LaserBot is stationary - no movement logic needed
            // But we do continuous collision detection here
            if (!Application.isPlaying || _isDestroyed || _isIdle)
                return;

            PerformContinuousCollisionDetection();
        }

        private void OnTriggerEnter(Collider other)
        {
            ProcessCenterTrigger(other);
        }

        private void OnTriggerStay(Collider other)
        {
            ProcessCenterTrigger(other);
        }

        public void HandleLaserFieldCollision(Collision collision)
        {
            ProcessForceFieldCollision(collision);
        }

        public void OnPlayerHitForceField(ThirdPersonController_RailGrinder player)
        {
            if (!Application.isPlaying || _isDestroyed || _isIdle)
                return;

            if (Time.time < _lastDamageTime + _damageCooldown)
                return;

            _lastDamageTime = Time.time;

            // Cache player reference if we don't have it
            if (_playerController == null)
            {
                _playerController = player;
                _playerTransform = player.transform;
            }

            // Calculate knockback direction (away from bot)
            Vector3 knockbackDir = (player.transform.position - transform.position).normalized;
            knockbackDir.y = 0;
            if (knockbackDir.sqrMagnitude < 0.01f)
                knockbackDir = -player.transform.forward;

            // Apply BIG knockback
            player.ApplyKnockback(knockbackDir, _knockbackForce);

            // Flash and damage
            if (PlayerHitFlash.Instance != null)
                PlayerHitFlash.Instance.Flash();

            GameSessionManager.Instance.TakeDamage(_damageAmount);

            Debug.Log($"LaserBot [{name}]: Player hit force field via CharacterController - knockback + damage!");
        }

        private void ProcessCenterTrigger(Collider other)
        {
            if (!Application.isPlaying || _isDestroyed)
                return;

            if (!other.CompareTag("Player"))
                return;

            if (_isIdle)
                return;

            // Center trigger only allows boosting players through to destroy the bot
            if (IsPlayerBoosting())
            {
                DestroyWithExplosion();
            }
            // Non-boosting players are blocked by the force field's solid collider
            // so they won't reach the center trigger
        }

        private void ProcessForceFieldCollision(Collision collision)
        {
            if (!Application.isPlaying || _isDestroyed)
                return;

            if (!collision.collider.CompareTag("Player"))
                return;

            if (_isIdle)
                return;

            // Force field ALWAYS damages and knocks back - even if boosting
            // (Only boosting through CENTER destroys the bot)
            ApplyKnockbackAndDamage(collision.collider);
        }

        private void PerformContinuousCollisionDetection()
        {
            if (_playerTransform == null)
            {
                CachePlayerReference();
                if (_playerTransform == null)
                    return;
            }

            Vector3 currentPos = _playerTransform.position;
            Vector3 movement = currentPos - _playerLastPosition;
            float movementDistance = movement.magnitude;

            // Only do raycast check if player moved significantly
            if (movementDistance > 0.5f)
            {
                Vector3 direction = movement.normalized;

                // Check if player passed through center (bot body)
                float centerRadius = _botCollider != null ? _botCollider.radius : 3f;
                if (CheckLineSphereIntersection(_playerLastPosition, currentPos, transform.position, centerRadius))
                {
                    if (IsPlayerBoosting())
                    {
                        DestroyWithExplosion();
                    }
                    else
                    {
                        ApplyKnockbackAndDamage(null);
                    }
                }
                // Check if player passed through force field plane
                else if (CheckLinePlaneIntersection(_playerLastPosition, currentPos))
                {
                    // Force field ALWAYS damages - even if boosting
                    ApplyKnockbackAndDamage(null);
                }
            }

            _playerLastPosition = currentPos;
        }

        private bool CheckLineSphereIntersection(Vector3 lineStart, Vector3 lineEnd, Vector3 sphereCenter, float sphereRadius)
        {
            Vector3 d = lineEnd - lineStart;
            Vector3 f = lineStart - sphereCenter;

            float a = Vector3.Dot(d, d);
            float b = 2f * Vector3.Dot(f, d);
            float c = Vector3.Dot(f, f) - sphereRadius * sphereRadius;

            float discriminant = b * b - 4f * a * c;
            if (discriminant < 0)
                return false;

            discriminant = Mathf.Sqrt(discriminant);
            float t1 = (-b - discriminant) / (2f * a);
            float t2 = (-b + discriminant) / (2f * a);

            // Check if intersection is within the line segment
            return (t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1);
        }

        private bool CheckLinePlaneIntersection(Vector3 lineStart, Vector3 lineEnd)
        {
            // The force field is a horizontal disc at the bot's position
            // Check if the line crosses the Y plane of the bot within the radius
            Vector3 botPos = transform.position;
            float planeY = botPos.y;

            float yDiff = lineEnd.y - lineStart.y;

            // If moving horizontally (no Y change), check if at same Y level
            if (Mathf.Abs(yDiff) < 0.001f)
            {
                // Player is moving horizontally - check if they're at the force field height
                if (Mathf.Abs(lineStart.y - planeY) > 1f) // Allow 1 unit tolerance
                    return false;

                // Check if the horizontal line passes through the disc
                Vector2 startXZ = new Vector2(lineStart.x - botPos.x, lineStart.z - botPos.z);
                Vector2 endXZ = new Vector2(lineEnd.x - botPos.x, lineEnd.z - botPos.z);

                // Check if either endpoint or the line segment passes through the circle
                if (startXZ.magnitude <= _laserRadius || endXZ.magnitude <= _laserRadius)
                    return true;

                // Check line-circle intersection in 2D
                Vector2 d = endXZ - startXZ;
                float a = Vector2.Dot(d, d);
                float b = 2f * Vector2.Dot(startXZ, d);
                float c = Vector2.Dot(startXZ, startXZ) - _laserRadius * _laserRadius;
                float discriminant = b * b - 4f * a * c;
                if (discriminant >= 0 && a > 0.0001f)
                {
                    float sqrtDisc = Mathf.Sqrt(discriminant);
                    float t1 = (-b - sqrtDisc) / (2f * a);
                    float t2 = (-b + sqrtDisc) / (2f * a);
                    if ((t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1))
                        return true;
                }
                return false;
            }

            // Check if line crosses the plane
            if ((lineStart.y - planeY) * (lineEnd.y - planeY) > 0)
                return false; // Both on same side

            // Find intersection point
            float t = (planeY - lineStart.y) / yDiff;
            if (t < 0 || t > 1)
                return false;

            Vector3 intersection = Vector3.Lerp(lineStart, lineEnd, t);

            // Check if within force field radius
            float distXZ = new Vector2(intersection.x - botPos.x, intersection.z - botPos.z).magnitude;
            return distXZ <= _laserRadius;
        }

        private bool IsPlayerBoosting()
        {
            if (_playerController == null)
            {
                CachePlayerReference();
            }
            return _playerController != null && _playerController.IsBoosting;
        }

        private void ApplyKnockbackAndDamage(Collider playerCollider)
        {
            if (_isDestroyed)
                return;

            if (Time.time < _lastDamageTime + _damageCooldown)
                return;

            _lastDamageTime = Time.time;

            // Calculate knockback direction (away from bot center)
            Vector3 knockbackDir;
            if (_playerTransform != null)
            {
                knockbackDir = (_playerTransform.position - transform.position).normalized;
                knockbackDir.y = 0; // Keep horizontal
            }
            else if (playerCollider != null)
            {
                knockbackDir = (playerCollider.transform.position - transform.position).normalized;
                knockbackDir.y = 0;
            }
            else
            {
                knockbackDir = Vector3.back; // Fallback
            }

            // Ensure we have a valid direction
            if (knockbackDir.sqrMagnitude < 0.01f)
            {
                knockbackDir = _playerTransform != null ? -_playerTransform.forward : Vector3.back;
            }

            // Apply knockback (this also cancels boost/dash and exits grind)
            if (_playerController != null)
            {
                _playerController.ApplyKnockback(knockbackDir, _knockbackForce);
            }

            // Flash red
            if (PlayerHitFlash.Instance != null)
            {
                PlayerHitFlash.Instance.Flash();
            }

            // Deal damage
            GameSessionManager.Instance.TakeDamage(_damageAmount);

            Debug.Log($"LaserBot [{name}]: Knocked player back and dealt {_damageAmount} damage");
        }

        private void DestroyWithExplosion()
        {
            if (_isDestroyed)
                return;

            _isDestroyed = true;
            Debug.Log($"LaserBot [{name}]: Destroyed by player boost!");

            if (Spawner != null)
            {
                Spawner.KillBotWithExplosion(this);
            }
            else
            {
                // Fallback if no spawner - just destroy
                Destroy(gameObject);
            }
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

    }
}
