using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public abstract class BaseEnemyBot : MonoBehaviour
    {
        protected EnemySpawner Spawner;

        [Header("Bot Settings")]
        [field: Tooltip("Collision radius of the bot for physics queries")]
        [field: SerializeField]
        public float BotCollisionRadius { get; private set; } = 1.5f;

        [field: Tooltip("The speed for smooth rotation")]
        [field: SerializeField]
        public float RotationSmoothTime { get; private set; } = 0.12f;

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

        protected virtual void OnValidate()
        {
            if (Application.isPlaying)
            {
                Debug.Log($"BaseEnemyBot [{name}]: Base parameters updated - BotCollisionRadius={BotCollisionRadius}");
            }
        }
    }
}
