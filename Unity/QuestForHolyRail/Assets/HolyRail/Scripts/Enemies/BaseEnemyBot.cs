using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    // Extended with state machine and command support for EnemyController
    public abstract class BaseEnemyBot : MonoBehaviour
    {
        public enum BotState
        {
            Entering,   // Flying in from offscreen
            Active,     // In position, executing behavior
            Exiting     // Flying offscreen
        }

        protected EnemySpawner Spawner;

        [Header("Bot Settings")]
        [field: Tooltip("Collision radius of the bot for physics queries")]
        [field: SerializeField]
        public float BotCollisionRadius { get; private set; } = 1.5f;

        [field: Tooltip("The speed for smooth rotation")]
        [field: SerializeField]
        public float RotationSmoothTime { get; private set; } = 0.12f;

        [Header("Transition Audio")]
        [Tooltip("Sound effect played when bot flies in")]
        [SerializeField] protected AudioClip _enterAudioClip;
        [Tooltip("Sound effect played when bot flies out")]
        [SerializeField] protected AudioClip _exitAudioClip;
        [Range(0, 1)] [SerializeField] protected float _transitionAudioVolume = 0.6f;

        protected Camera MainCamera { get; private set; }

        // State management
        protected BotState _botState = BotState.Active;
        protected bool _isIdle = false;

        // Transition movement
        protected Vector3 _targetOffset;
        protected Vector3 _startOffset;
        protected float _transitionProgress = 0f;
        protected float _transitionDuration = 1.5f;

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
            // Legacy overload for backward compatibility
            _botState = BotState.Active;
            _isIdle = false;
        }

        /// <summary>
        /// Called when enemy is spawned by EnemyController.
        /// Enemy starts offscreen and flies to final position.
        /// </summary>
        public virtual void OnSpawn(bool startsIdle, Vector3 finalPosition, float enterDuration)
        {
            _isIdle = startsIdle;
            _startOffset = Camera.main.transform.InverseTransformPoint(transform.position);
            _targetOffset = Camera.main.transform.InverseTransformPoint(finalPosition);
            _transitionDuration = enterDuration;
            _transitionProgress = 0f;
            _botState = BotState.Entering;

            if (EnemyController.Instance != null)
            {
                EnemyController.Instance.OnEnemySpawned(this);
            }

            // Play enter sound
            if (_enterAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(_enterAudioClip, transform.position, _transitionAudioVolume);
            }
        }

        public virtual void OnRecycle()
        {
            if (EnemyController.Instance != null)
            {
                EnemyController.Instance.OnEnemyKilled(this);
            }
        }

        /// <summary>
        /// Begins the exit transition, flying enemy offscreen.
        /// </summary>
        public virtual void BeginExitTransition(float exitDuration)
        {
            _botState = BotState.Exiting;
            _transitionProgress = 0f;
            _transitionDuration = exitDuration;

            // Target is offscreen behind player
            if (Spawner != null && Spawner.Player != null)
            {
                _startOffset = Spawner.Player.InverseTransformPoint(transform.position);
                _targetOffset = Spawner.Player.forward * -30f;
            }

            // Disable attacks while exiting
            _isIdle = true;

            // Play exit sound
            if (_exitAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(_exitAudioClip, transform.position, _transitionAudioVolume);
            }
        }

        /// <summary>
        /// Updates smooth transition movement (entering or exiting).
        /// </summary>
        protected virtual void UpdateTransition()
        {
            if (_botState == BotState.Active)
            {
                return;
            }

            _transitionProgress += Time.deltaTime;
            var progressFraction = _transitionProgress / _transitionDuration;
            if (progressFraction >= 1f)
            {
                transform.position = Camera.main.transform.TransformPoint(_targetOffset);

                if (_botState == BotState.Entering)
                {
                    _botState = BotState.Active;
                    if (EnemyController.Instance != null)
                    {
                        EnemyController.Instance.OnEnemyEnteredStage(this);
                    }
                }
                else if (_botState == BotState.Exiting)
                {
                    if (EnemyController.Instance != null)
                    {
                        EnemyController.Instance.OnEnemyExited(this);
                    }
                    if (Spawner != null)
                    {
                        Spawner.RecycleBot(this, false); // Don't award points for timeout
                    }
                }
            }
            else
            {
                // Smooth lerp to target
                var currentOffset = Vector3.MoveTowards(
                    _startOffset,
                    _targetOffset,
                    progressFraction
                );
                
                transform.position = Camera.main.transform.TransformPoint(currentOffset);
            }
        }

        /// <summary>
        /// Receives commands from EnemyController.
        /// Override in subclasses to handle specific commands.
        /// </summary>
        public virtual void OnCommandReceived(string command, params object[] args)
        {
            switch (command)
            {
                case "MoveTo":
                    if (args.Length > 0 && args[0] is Vector3 pos)
                    {
                        if (Spawner != null && Spawner.Player != null)
                        {
                            _targetOffset = pos;
                            Debug.Log($"ShooterBot [{name}]: Received 'MoveTo' command, new offset={_targetOffset}");
                        }
                    }

                    break;
            }
        }

        protected virtual void Update()
        {
            if (!Spawner || !Spawner.Player)
            {
                return;
            }

            UpdateTransition();

            // Only update movement if in Active state
            if (_botState == BotState.Active)
            {
                UpdateMovement();
            }
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
