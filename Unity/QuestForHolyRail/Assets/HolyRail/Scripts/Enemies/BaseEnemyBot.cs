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

        // Transition movement (world space positions)
        protected Vector3 _targetOffset;
        protected Vector3 _transitionStartWorldPos;
        protected Vector3 _transitionTargetWorldPos;
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
            // Store positions in WORLD SPACE (not camera-relative)
            _transitionStartWorldPos = transform.position;
            _transitionTargetWorldPos = finalPosition;
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

            // Store current position and target exit position in world space
            _transitionStartWorldPos = transform.position;

            // Target is offscreen behind player (negative Z in world space)
            if (Spawner != null && Spawner.Player != null)
            {
                _transitionTargetWorldPos = new Vector3(
                    transform.position.x,
                    transform.position.y,
                    Spawner.Player.position.z - 30f
                );
            }
            else
            {
                _transitionTargetWorldPos = transform.position + Vector3.back * 30f;
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
        /// Uses WORLD SPACE positioning to ensure bots stay ahead of player.
        /// </summary>
        protected virtual void UpdateTransition()
        {
            if (_botState == BotState.Active)
            {
                return;
            }

            // Log transition progress every second to avoid spam
            if (Time.frameCount % 60 == 0)
            {
                Debug.Log($"[{name}] Transition: state={_botState}, progress={_transitionProgress:F2}/{_transitionDuration:F2}");
            }

            _transitionProgress += Time.deltaTime;
            var progressFraction = Mathf.Clamp01(_transitionProgress / _transitionDuration);

            if (progressFraction >= 1f)
            {
                // Transition complete
                Vector3 finalPos = _transitionTargetWorldPos;

                // Ensure final position is ahead of player in world Z
                if (Spawner != null && Spawner.Player != null && _botState == BotState.Entering)
                {
                    float playerZ = Spawner.Player.position.z;
                    if (finalPos.z < playerZ + 5f)
                    {
                        finalPos.z = playerZ + 10f;
                    }
                }

                transform.position = finalPos;

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
                // Smooth lerp to target in world space
                Vector3 newPos = Vector3.Lerp(_transitionStartWorldPos, _transitionTargetWorldPos, progressFraction);

                // During entering transition, ensure bot stays ahead of player
                if (_botState == BotState.Entering && Spawner != null && Spawner.Player != null)
                {
                    float playerZ = Spawner.Player.position.z;
                    if (newPos.z < playerZ + 2f)
                    {
                        newPos.z = playerZ + 2f;
                    }
                }

                transform.position = newPos;
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
            if (!Spawner)
            {
                Debug.LogWarning($"[{name}] BLOCKED: Spawner is null!");
                return;
            }
            if (!Spawner.Player)
            {
                Debug.LogWarning($"[{name}] BLOCKED: Spawner.Player is null!");
                return;
            }

            UpdateTransition();

            // Only update movement if in Active state
            if (_botState == BotState.Active)
            {
                UpdateMovement();
            }
            else
            {
                // Log every second to avoid spam
                if (Time.frameCount % 60 == 0)
                {
                    Debug.Log($"[{name}] State={_botState}, waiting for Active state");
                }
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
