using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public abstract class BaseEnemyBot : MonoBehaviour
    {
        protected EnemySpawner Spawner;

        // Which side of the player this bot prefers for avoidance (-1 = left, +1 = right)
        public float PreferredSide { get; set; }

        // Avoidance system velocity suggestion (applied by derived classes in UpdateMovement)
        public Vector3 AvoidanceVelocity { get; set; }

        // Whether the bot is currently in the avoidance zone
        public bool IsInAvoidanceZone { get; set; }

        [Header("Bot Settings")]
        [field: Tooltip("How quickly bots accelerate toward the player")]
        [field: SerializeField]
        public float BotAcceleration { get; private set; } = 8f;

        [field: Tooltip("Maximum movement speed of bots")]
        [field: SerializeField]
        public float BotMaxSpeed { get; private set; } = 6f;

        [field: Tooltip("The speed for smooth damping")]
        [field: SerializeField]
        public float SmoothTime { get; private set; } = 0.3f;
    
        [field: Tooltip("The speed for smooth rotation")]
        [field: SerializeField]
        public float RotationSmoothTime { get; private set; } = 0.12f;

        [field: Tooltip("Perlin noise magnitude for organic drift movement")]
        [field: SerializeField]
        public float BotNoiseAmount { get; private set; } = 1.5f;

        [field: Tooltip("Perlin noise frequency - higher = faster drift")]
        [field: SerializeField]
        public float BotNoiseSpeed { get; private set; } = 2f;
    
        [field: Tooltip("Bots within this distance will push away from each other")]
        [field: SerializeField]
        public float BotAvoidanceRadius { get; private set; } = 3f;

        [field: Tooltip("How strongly bots repel each other when too close")]
        [field: SerializeField]
        public float BotAvoidanceStrength { get; private set; } = 5f;
    
        [field: Tooltip("Collision radius of the bot for physics queries")]
        [field: SerializeField]
        public float BotCollisionRadius { get; private set; } = 1.5f;

        protected Camera MainCamera { get; private set; }

        public void Initialize(EnemySpawner spawner)
        {
            Spawner = spawner;
        }

        protected virtual void Awake()
        {
            MainCamera = Camera.main;
            if (MainCamera == null)
            {
                Debug.LogError("Main Camera not found. Make sure a camera is tagged as 'Main Camera'");
            }
        }

        public virtual void OnSpawn()
        {
        }

        public virtual void OnRecycle()
        {
        }

        protected virtual void Update()
        {
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            UpdateMovement();
        }

        protected abstract void UpdateMovement();

        protected Vector3 GetCollisionSafePosition(Vector3 currentPos, Vector3 targetPos)
        {
            Vector3 direction = targetPos - currentPos;
            float distance = direction.magnitude;

            if (distance < 0.01f) return targetPos;

            // Raycast to check for obstacles (ignore triggers)
            if (Physics.SphereCast(currentPos, BotCollisionRadius, direction.normalized, out RaycastHit hit, distance, ~0, QueryTriggerInteraction.Ignore))
            {
                // Stop short of the obstacle with a small buffer
                float safeDistance = Mathf.Max(0f, hit.distance - 0.1f);
                return currentPos + direction.normalized * safeDistance;
            }

            return targetPos;
        }

        protected virtual void OnValidate()
        {
            if (Application.isPlaying)
            {
                Debug.Log($"BaseEnemyBot [{name}]: Base parameters updated - BotMaxSpeed={BotMaxSpeed}, BotCollisionRadius={BotCollisionRadius}");
            }
        }
    }
}
