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

        [Header("Obstacle Avoidance")]
        [field: Tooltip("Layer mask for obstacles to avoid (walls, floors, etc.)")]
        [field: SerializeField]
        public LayerMask ObstacleLayerMask { get; private set; } = 1; // Default layer

        [field: Tooltip("How far ahead to look for obstacles")]
        [field: SerializeField]
        public float ObstacleLookAheadDistance { get; private set; } = 5f;

        [field: Tooltip("How strongly to steer away from obstacles (higher = more aggressive)")]
        [field: SerializeField]
        public float ObstacleAvoidanceStrength { get; private set; } = 3f;

        [field: Tooltip("Number of feeler rays to cast when finding alternate paths")]
        [field: SerializeField]
        public int AvoidanceRayCount { get; private set; } = 8;

        [field: Tooltip("How smoothly to transition to avoidance direction (higher = smoother but slower to react)")]
        [field: SerializeField]
        public float AvoidanceSmoothTime { get; private set; } = 0.3f;

        [field: Tooltip("Force applied to push bot away from obstacles it's touching")]
        [field: SerializeField]
        public float SeparationForce { get; private set; } = 8f;

        [field: Tooltip("Upward bias when stuck to help bot rise over obstacles")]
        [field: SerializeField]
        public float StuckUpwardBias { get; private set; } = 5f;

        // Smoothing state for obstacle avoidance
        private Vector3 _smoothedAvoidanceDirection;
        private Vector3 _avoidanceVelocity;
        private bool _wasAvoiding;

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
            ResetAvoidanceState();
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
            ResetAvoidanceState();

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
            ResetAvoidanceState();
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

        /// <summary>
        /// Calculates a movement direction that avoids obstacles.
        /// Returns the adjusted direction, or the original if no obstacles detected.
        /// </summary>
        protected Vector3 GetAvoidanceDirection(Vector3 currentPosition, Vector3 desiredDirection, float speed)
        {
            if (ObstacleLayerMask == 0 || desiredDirection.sqrMagnitude < 0.001f)
            {
                _wasAvoiding = false;
                return desiredDirection;
            }

            float lookDistance = Mathf.Max(ObstacleLookAheadDistance, speed * 0.5f);
            float desiredMagnitude = desiredDirection.magnitude;
            Vector3 desiredNormalized = desiredDirection.normalized;

            // Check if path ahead is blocked
            bool isBlocked = Physics.SphereCast(currentPosition, BotCollisionRadius, desiredNormalized, out RaycastHit hit,
                                                lookDistance, ObstacleLayerMask, QueryTriggerInteraction.Ignore);

            Vector3 targetDirection;

            if (!isBlocked)
            {
                // Path is clear - smoothly return to desired direction
                targetDirection = desiredNormalized;

                // If we were avoiding, keep some momentum to prevent snapping back
                if (_wasAvoiding && _smoothedAvoidanceDirection.sqrMagnitude > 0.1f)
                {
                    float returnBlend = Mathf.Clamp01(Time.deltaTime / (AvoidanceSmoothTime * 0.5f));
                    _smoothedAvoidanceDirection = Vector3.Lerp(_smoothedAvoidanceDirection, targetDirection, returnBlend);

                    // Check if we've mostly returned to desired direction
                    if (Vector3.Dot(_smoothedAvoidanceDirection, desiredNormalized) > 0.95f)
                    {
                        _wasAvoiding = false;
                        _smoothedAvoidanceDirection = desiredNormalized;
                    }
                    return _smoothedAvoidanceDirection * desiredMagnitude;
                }

                _wasAvoiding = false;
                return desiredDirection;
            }

            // Path is blocked - find an alternate direction
            Vector3 avoidanceDirection = FindAvoidanceDirection(currentPosition, desiredNormalized, lookDistance, hit.normal);

            // Blend between desired and avoidance based on how close the obstacle is
            float urgency = 1f - (hit.distance / lookDistance);
            urgency = Mathf.Clamp01(urgency * ObstacleAvoidanceStrength);

            targetDirection = Vector3.Lerp(desiredNormalized, avoidanceDirection, urgency).normalized;

            // Smoothly interpolate toward the target avoidance direction
            if (!_wasAvoiding)
            {
                _smoothedAvoidanceDirection = desiredNormalized;
                _wasAvoiding = true;
            }

            // Use SmoothDamp for natural-feeling movement
            _smoothedAvoidanceDirection = Vector3.SmoothDamp(
                _smoothedAvoidanceDirection,
                targetDirection,
                ref _avoidanceVelocity,
                AvoidanceSmoothTime
            ).normalized;

            return _smoothedAvoidanceDirection * desiredMagnitude;
        }

        /// <summary>
        /// Finds an unobstructed direction to steer toward when the primary path is blocked.
        /// </summary>
        private Vector3 FindAvoidanceDirection(Vector3 origin, Vector3 blockedDirection, float lookDistance, Vector3 hitNormal)
        {
            // Start by trying to slide along the surface
            Vector3 slideDirection = Vector3.ProjectOnPlane(blockedDirection, hitNormal).normalized;
            if (slideDirection.sqrMagnitude > 0.1f &&
                !Physics.SphereCast(origin, BotCollisionRadius, slideDirection, out _, lookDistance * 0.5f, ObstacleLayerMask, QueryTriggerInteraction.Ignore))
            {
                return slideDirection;
            }

            // Cast rays in a fan pattern to find open directions
            Vector3 bestDirection = Vector3.up; // Default to up if all else fails
            float bestScore = -1f;

            // Get perpendicular axes for the fan
            Vector3 right = Vector3.Cross(blockedDirection, Vector3.up).normalized;
            if (right.sqrMagnitude < 0.1f)
            {
                right = Vector3.Cross(blockedDirection, Vector3.forward).normalized;
            }
            Vector3 up = Vector3.Cross(right, blockedDirection).normalized;

            for (int i = 0; i < AvoidanceRayCount; i++)
            {
                float angle = (i / (float)AvoidanceRayCount) * 360f * Mathf.Deg2Rad;
                Vector3 offset = (Mathf.Cos(angle) * right + Mathf.Sin(angle) * up).normalized;

                // Test directions at various angles from blocked direction
                for (float blend = 0.3f; blend <= 1f; blend += 0.35f)
                {
                    Vector3 testDirection = Vector3.Lerp(blockedDirection, offset, blend).normalized;

                    if (!Physics.SphereCast(origin, BotCollisionRadius, testDirection, out RaycastHit testHit,
                                            lookDistance, ObstacleLayerMask, QueryTriggerInteraction.Ignore))
                    {
                        // This direction is clear - score by how close it is to desired direction
                        float score = Vector3.Dot(testDirection, blockedDirection);
                        if (score > bestScore)
                        {
                            bestScore = score;
                            bestDirection = testDirection;
                        }
                    }
                    else if (testHit.distance > lookDistance * 0.5f)
                    {
                        // Partially clear - still usable but lower priority
                        float score = Vector3.Dot(testDirection, blockedDirection) * 0.5f;
                        if (score > bestScore)
                        {
                            bestScore = score;
                            bestDirection = testDirection;
                        }
                    }
                }
            }

            return bestDirection;
        }

        /// <summary>
        /// Applies movement with obstacle avoidance. Use this instead of directly setting transform.position.
        /// Returns the final position after movement.
        /// </summary>
        protected Vector3 MoveWithAvoidance(Vector3 currentPosition, Vector3 targetPosition, float speed)
        {
            Vector3 direction = targetPosition - currentPosition;
            float distance = direction.magnitude;

            // First, check if we're overlapping any colliders and push away
            Vector3 separationOffset = GetSeparationOffset(currentPosition);
            if (separationOffset.sqrMagnitude > 0.001f)
            {
                currentPosition += separationOffset * Time.deltaTime;
            }

            if (distance < 0.001f)
            {
                return currentPosition;
            }

            float moveDistance = speed * Time.deltaTime;
            if (moveDistance > distance)
            {
                moveDistance = distance;
            }

            Vector3 moveDirection = direction.normalized;
            Vector3 avoidedDirection = GetAvoidanceDirection(currentPosition, moveDirection * moveDistance, speed);

            // Final collision check to prevent clipping
            Vector3 newPosition = currentPosition + avoidedDirection;
            if (Physics.SphereCast(currentPosition, BotCollisionRadius * 0.9f, avoidedDirection.normalized, out RaycastHit finalHit,
                                   avoidedDirection.magnitude, ObstacleLayerMask, QueryTriggerInteraction.Ignore))
            {
                // Stop just before the obstacle
                float safeDistance = Mathf.Max(0f, finalHit.distance - 0.1f);
                newPosition = currentPosition + avoidedDirection.normalized * safeDistance;

                // If we're basically stuck (can't move much), add upward bias to escape
                if (safeDistance < 0.05f && StuckUpwardBias > 0f)
                {
                    newPosition += Vector3.up * StuckUpwardBias * Time.deltaTime;
                }
            }

            return newPosition;
        }

        /// <summary>
        /// Checks for overlapping colliders and returns a direction to push away from them.
        /// </summary>
        private Vector3 GetSeparationOffset(Vector3 position)
        {
            if (ObstacleLayerMask == 0 || SeparationForce <= 0f)
            {
                return Vector3.zero;
            }

            // Check for overlapping colliders
            Collider[] overlaps = Physics.OverlapSphere(position, BotCollisionRadius * 1.1f, ObstacleLayerMask, QueryTriggerInteraction.Ignore);

            if (overlaps.Length == 0)
            {
                return Vector3.zero;
            }

            Vector3 totalSeparation = Vector3.zero;

            foreach (var collider in overlaps)
            {
                // Find closest point on the collider
                Vector3 closestPoint = collider.ClosestPoint(position);
                Vector3 toBot = position - closestPoint;
                float dist = toBot.magnitude;

                if (dist < 0.001f)
                {
                    // We're inside the collider - push up and away from collider center
                    toBot = (position - collider.bounds.center).normalized;
                    if (toBot.sqrMagnitude < 0.1f)
                    {
                        toBot = Vector3.up;
                    }
                    totalSeparation += (toBot.normalized + Vector3.up * 0.5f) * SeparationForce;
                }
                else if (dist < BotCollisionRadius)
                {
                    // We're overlapping - push away proportionally
                    float overlap = BotCollisionRadius - dist;
                    float pushStrength = (overlap / BotCollisionRadius) * SeparationForce;
                    totalSeparation += toBot.normalized * pushStrength;
                }
            }

            return totalSeparation;
        }

        /// <summary>
        /// Resets the obstacle avoidance smoothing state.
        /// Called when bot is spawned/recycled.
        /// </summary>
        protected void ResetAvoidanceState()
        {
            _smoothedAvoidanceDirection = Vector3.zero;
            _avoidanceVelocity = Vector3.zero;
            _wasAvoiding = false;
        }

        protected virtual void OnValidate()
        {
            if (Application.isPlaying)
            {
                Debug.Log($"BaseEnemyBot [{name}]: Base parameters updated - BotCollisionRadius={BotCollisionRadius}");
            }
        }
    }
}
