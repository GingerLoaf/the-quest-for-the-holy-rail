using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using HolyRail.Scripts.Enemies.Actions;

namespace HolyRail.Scripts.Enemies
{
    /// <summary>
    /// Central controller that orchestrates enemy behavior via choreographed attack plans.
    /// Manages plan execution, enemy spawning, command dispatch, and state transitions.
    /// </summary>
    public class EnemyController : MonoBehaviour
    {
        public static EnemyController Instance { get; private set; }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
        private static void ClearStaticReferences()
        {
            Instance = null;
        }

        public enum PlanState
        {
            Idle,           // No active plan, cooldown timer running
            EnteringStage,  // Enemies spawned offscreen, flying to positions
            Executing,      // Processing action queue, sending commands
            ExitingStage,   // Plan timeout reached, enemies flying offscreen
            Complete        // All enemies offscreen, return to Idle
        }

        [Header("Plan Library")]
        [Tooltip("Available enemy plans (weighted random selection)")]
        [SerializeField]
        private List<EnemyPlan> _availablePlans = new();

        [Header("Plan Timing")]
        [Tooltip("Cooldown between plans (seconds)")]
        [SerializeField]
        private float _planCooldown = 3f;

        [Header("Debug")]
        [Tooltip("If true, logs detailed state machine transitions")]
        [SerializeField]
        private bool _debugLogging = true;

        private PlanState _state = PlanState.Idle;
        private EnemyPlan _activePlan;
        private List<BaseEnemyBot> _spawnedEnemies = new();
        private HashSet<BaseEnemyBot> _enteredEnemies = new();
        private HashSet<BaseEnemyBot> _exitedEnemies = new();
        private int _currentActionIndex = 0;
        private float _actionTimer = 0f;
        private float _cooldownTimer = 0f;
        private int _totalSpawnWeight = 0;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }
            Instance = this;

            CalculateTotalSpawnWeight();
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void Start()
        {
            if (_availablePlans.Count == 0)
            {
                Debug.LogWarning("EnemyController: No plans available! Add EnemyPlan assets to the AvailablePlans list.");
            }
            else
            {
                Debug.Log($"EnemyController: Initialized with {_availablePlans.Count} plans");
                _state = PlanState.Idle;
                _cooldownTimer = _planCooldown;
            }
        }

        private void Update()
        {
            switch (_state)
            {
                case PlanState.Idle:
                    UpdateIdle();
                    break;

                case PlanState.EnteringStage:
                    UpdateEnteringStage();
                    break;

                case PlanState.Executing:
                    UpdateExecuting();
                    break;

                case PlanState.ExitingStage:
                    UpdateExitingStage();
                    break;

                case PlanState.Complete:
                    UpdateComplete();
                    break;
            }
        }

        private void UpdateIdle()
        {
            _cooldownTimer -= Time.deltaTime;

            if (_cooldownTimer <= 0f)
            {
                StartNewPlan();
            }
        }

        private void UpdateEnteringStage()
        {
            // Check if all enemies have entered their positions
            if (_spawnedEnemies.Count > 0 && _enteredEnemies.Count >= _spawnedEnemies.Count)
            {
                TransitionToExecuting();
            }
        }

        private void UpdateExecuting()
        {
            // Execute action sequence
            _actionTimer -= Time.deltaTime;
            if (_actionTimer <= 0f)
            {
                if (_currentActionIndex < _activePlan.Actions.Count)
                {
                    ExecuteCurrentAction();
                    _currentActionIndex++;

                    // Check if we've reached the end of actions
                    if (_currentActionIndex >= _activePlan.Actions.Count)
                    {
                        if (_activePlan.LoopActions)
                        {
                            // Loop back to beginning
                            _currentActionIndex = 0;
                            if (_debugLogging)
                            {
                                Debug.Log("EnemyController: Looping actions back to start");
                            }
                        }
                        else
                        {
                            // No more actions, wait for timeout
                            if (_debugLogging)
                            {
                                Debug.Log("EnemyController: All actions executed, waiting for plan timeout");
                            }
                        }
                    }

                    // Set timer for next action
                    if (_currentActionIndex < _activePlan.Actions.Count)
                    {
                        _actionTimer = _activePlan.Actions[_currentActionIndex].Delay;
                    }
                }
                else
                {
                    BeginExitStage();
                }
            }
        }

        private void UpdateExitingStage()
        {
            // Check if all enemies have exited
            if (_exitedEnemies.Count >= _spawnedEnemies.Count)
            {
                TransitionToComplete();
            }
        }

        private void UpdateComplete()
        {
            // Cleanup and return to idle
            TransitionToIdle();
        }

        private void StartNewPlan()
        {
            _activePlan = SelectRandomPlan();
            if (_activePlan == null)
            {
                Debug.LogWarning("EnemyController: No plan selected, staying in Idle");
                _cooldownTimer = _planCooldown;
                return;
            }

            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Starting plan '{_activePlan.PlanName}' (Loop: {_activePlan.LoopActions})");
            }

            // Reset state
            _spawnedEnemies.Clear();
            _enteredEnemies.Clear();
            _exitedEnemies.Clear();
            _currentActionIndex = 0;

            // Set initial action delay
            if (_activePlan.Actions.Count > 0)
            {
                _actionTimer = _activePlan.Actions[0].Delay;
            }

            _state = PlanState.EnteringStage;

            // Execute first action immediately if delay is 0
            if (_actionTimer <= 0f && _activePlan.Actions.Count > 0)
            {
                ExecuteCurrentAction();
                _currentActionIndex++;
                if (_currentActionIndex < _activePlan.Actions.Count)
                {
                    _actionTimer = _activePlan.Actions[_currentActionIndex].Delay;
                }
            }
        }

        private void ExecuteCurrentAction()
        {
            if (_currentActionIndex >= _activePlan.Actions.Count)
            {
                return;
            }

            var action = _activePlan.Actions[_currentActionIndex];
            if (action == null)
            {
                Debug.LogWarning($"EnemyController: Action at index {_currentActionIndex} is null");
                return;
            }

            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Executing action {_currentActionIndex}: {action.GetType().Name}");
            }

            bool success = action.Execute(this);
            if (!success && _debugLogging)
            {
                Debug.LogWarning($"EnemyController: Action {_currentActionIndex} ({action.GetType().Name}) failed");
            }
        }

        private void TransitionToExecuting()
        {
            _state = PlanState.Executing;
            if (_debugLogging)
            {
                Debug.Log("EnemyController: All enemies entered, transitioning to Executing");
            }
        }

        private void BeginExitStage()
        {
            _state = PlanState.ExitingStage;
            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Plan timeout reached, beginning exit stage");
            }

            // Command all spawned enemies to exit
            foreach (var enemy in _spawnedEnemies)
            {
                if (enemy != null && enemy.gameObject.activeInHierarchy)
                {
                    enemy.BeginExitTransition(_activePlan.ExitDuration);
                }
            }

            // If no enemies to exit, go straight to complete
            if (_spawnedEnemies.Count == 0 || _spawnedEnemies.All(e => e == null || !e.gameObject.activeInHierarchy))
            {
                TransitionToComplete();
            }
        }

        private void TransitionToComplete()
        {
            _state = PlanState.Complete;
            if (_debugLogging)
            {
                Debug.Log("EnemyController: All enemies exited, plan complete");
            }
        }

        private void TransitionToIdle()
        {
            _state = PlanState.Idle;
            _cooldownTimer = _planCooldown;
            _activePlan = null;

            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Returning to Idle, cooldown: {_planCooldown}s");
            }
        }

        private EnemyPlan SelectRandomPlan()
        {
            if (_availablePlans.Count == 0)
            {
                return null;
            }

            if (_totalSpawnWeight <= 0)
            {
                // No weights set, use sequential selection
                int index = Random.Range(0, _availablePlans.Count);
                return _availablePlans[index];
            }

            // Weighted random selection
            float randomValue = Random.Range(0, _totalSpawnWeight);
            float cumulativeWeight = 0f;

            foreach (var plan in _availablePlans)
            {
                cumulativeWeight += plan.SpawnWeight;
                if (randomValue < cumulativeWeight)
                {
                    return plan;
                }
            }

            return _availablePlans[0]; // Fallback
        }

        private void CalculateTotalSpawnWeight()
        {
            _totalSpawnWeight = _availablePlans.Sum(p => p.SpawnWeight);
            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Total spawn weight = {_totalSpawnWeight}");
            }
        }

        /// <summary>
        /// Spawns an enemy via the EnemySpawner and tracks it in the current plan.
        /// </summary>
        public BaseEnemyBot SpawnEnemy(GameObject enemyPrefab, Vector3 finalPosition, bool startsIdle)
        {
            if (EnemySpawner.Instance == null)
            {
                Debug.LogError("EnemyController: EnemySpawner.Instance is null!");
                return null;
            }

            var bot = EnemySpawner.Instance.SpawnEnemy(enemyPrefab, finalPosition, startsIdle, _activePlan.EnterDuration);
            if (bot != null)
            {
                _spawnedEnemies.Add(bot);
            }

            return bot;
        }

        /// <summary>
        /// Gets a spawned enemy by its index in the spawn order.
        /// </summary>
        public BaseEnemyBot GetSpawnedEnemy(int index)
        {
            if (index < 0 || index >= _spawnedEnemies.Count)
            {
                return null;
            }

            var enemy = _spawnedEnemies[index];
            // Return null if enemy was destroyed
            return enemy != null && enemy.gameObject.activeInHierarchy ? enemy : null;
        }

        /// <summary>
        /// Called by BaseEnemyBot when it completes its enter transition.
        /// </summary>
        public void OnEnemyEnteredStage(BaseEnemyBot enemy)
        {
            _enteredEnemies.Add(enemy);
            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Enemy entered stage ({_enteredEnemies.Count}/{_spawnedEnemies.Count})");
            }
        }

        /// <summary>
        /// Called by BaseEnemyBot when it's spawned by this controller.
        /// </summary>
        public void OnEnemySpawned(BaseEnemyBot enemy)
        {
            // Already tracked in SpawnEnemy, but can be used for additional logic
        }

        /// <summary>
        /// Called by BaseEnemyBot when it completes its exit transition.
        /// </summary>
        public void OnEnemyExited(BaseEnemyBot enemy)
        {
            _exitedEnemies.Add(enemy);
            if (_debugLogging)
            {
                Debug.Log($"EnemyController: Enemy exited stage ({_exitedEnemies.Count}/{_spawnedEnemies.Count})");
            }
        }

        /// <summary>
        /// Called by BaseEnemyBot when it's killed/recycled.
        /// </summary>
        public void OnEnemyKilled(BaseEnemyBot enemy)
        {
            // If in exit stage, count as exited
            if (_state == PlanState.ExitingStage)
            {
                _exitedEnemies.Add(enemy);
            }
        }

        /// <summary>
        /// Resets the controller to idle state for soft reset on death.
        /// </summary>
        public void ResetToIdle()
        {
            _state = PlanState.Idle;
            _cooldownTimer = _planCooldown;
            _activePlan = null;
            _spawnedEnemies.Clear();
            _enteredEnemies.Clear();
            _exitedEnemies.Clear();
            _currentActionIndex = 0;
            _actionTimer = 0f;

            Debug.Log("[EnemyController] Reset to idle state for soft reset.");
        }

        [ContextMenu("Debug: Force Start Plan")]
        public void DebugForceStartPlan()
        {
            if (!Application.isPlaying)
            {
                Debug.LogWarning("Must be in Play mode");
                return;
            }

            _cooldownTimer = 0f;
            Debug.Log("EnemyController: Forcing plan start");
        }

        [ContextMenu("Debug: Log Current State")]
        public void DebugLogCurrentState()
        {
            Debug.Log($"=== EnemyController State ===");
            Debug.Log($"State: {_state}");
            Debug.Log($"Active Plan: {(_activePlan != null ? _activePlan.PlanName : "None")}");
            Debug.Log($"Current Action Index: {_currentActionIndex}");
            Debug.Log($"Action Timer: {_actionTimer:F1}s");
            Debug.Log($"Spawned Enemies: {_spawnedEnemies.Count}");
            Debug.Log($"Entered Enemies: {_enteredEnemies.Count}");
            Debug.Log($"Exited Enemies: {_exitedEnemies.Count}");
            Debug.Log($"Cooldown Timer: {_cooldownTimer:F1}s");
        }

        private void OnValidate()
        {
            if (_availablePlans != null)
            {
                CalculateTotalSpawnWeight();
            }
        }
    }
}
