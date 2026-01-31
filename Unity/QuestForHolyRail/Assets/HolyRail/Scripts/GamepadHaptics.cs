using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.XInput;
using System.Collections;
using System.Collections.Generic;

namespace HolyRail.Scripts
{
    public enum HapticType
    {
        // Movement
        GrindStart,
        GrindLoop,
        GrindJump,
        WallRideStart,
        WallRideLoop,
        WallRideJump,
        Jump,
        Land,

        // Abilities
        Dash,
        Boost,

        // Combat
        Parry,
        Damage,
        Knockback,

        // Interactions
        GraffitiProgress,
        GraffitiComplete,
        Pickup,
        AbilityUnlock,
        UpgradePurchase
    }

    public enum HapticPatternType
    {
        OneShot,
        Continuous,
        Pulsing,
        SubtlePulse  // Very light, infrequent ticks - for grinding/wall riding
    }

    [System.Serializable]
    public struct HapticProfile
    {
        public float LeftMotor;
        public float RightMotor;
        public float Duration;
        public HapticPatternType PatternType;
        public int Priority;

        public HapticProfile(float leftMotor, float rightMotor, float duration, HapticPatternType patternType, int priority = 0)
        {
            LeftMotor = leftMotor;
            RightMotor = rightMotor;
            Duration = duration;
            PatternType = patternType;
            Priority = priority;
        }
    }

    public class GamepadHaptics : MonoBehaviour
    {
        private const string LogPrefix = "[GamepadHaptics] ";

        public static GamepadHaptics Instance { get; private set; }

        [Header("Debug")]
        [field: SerializeField] public bool EnableDebugLogging { get; private set; } = true;

        [Header("Global")]
        [field: SerializeField] public float GlobalIntensityMultiplier { get; private set; } = 1f;

        [Header("Grind Loop")]
        [field: SerializeField, Range(0f, 1f)] public float GrindLoopLeftMotor { get; private set; } = 0.01f;
        [field: SerializeField, Range(0f, 1f)] public float GrindLoopRightMotor { get; private set; } = 0.015f;

        [Header("Grind Start")]
        [field: SerializeField, Range(0f, 1f)] public float GrindStartLeftMotor { get; private set; } = 0.1f;
        [field: SerializeField, Range(0f, 1f)] public float GrindStartRightMotor { get; private set; } = 0.15f;
        [field: SerializeField, Range(0f, 1f)] public float GrindStartDuration { get; private set; } = 0.08f;

        [Header("Grind Jump")]
        [field: SerializeField, Range(0f, 1f)] public float GrindJumpLeftMotor { get; private set; } = 0.15f;
        [field: SerializeField, Range(0f, 1f)] public float GrindJumpRightMotor { get; private set; } = 0.2f;
        [field: SerializeField, Range(0f, 1f)] public float GrindJumpDuration { get; private set; } = 0.08f;

        private Dictionary<HapticType, HapticProfile> _profiles;
        private int _previousHealth;
        private Coroutine _oneShotCoroutine;
        private Coroutine _continuousCoroutine;
        private HapticType? _currentContinuousType;
        private int _currentContinuousPriority;
        private bool _platformWarningShown;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }
            Instance = this;

            InitializeProfiles();
            LogDebug("Awake - Singleton initialized");
        }

        private void InitializeProfiles()
        {
            _profiles = new Dictionary<HapticType, HapticProfile>
            {
                // Movement - Lower priority (0-2)
                // Grind values come from serialized fields for easy tuning
                { HapticType.GrindStart, new HapticProfile(GrindStartLeftMotor, GrindStartRightMotor, GrindStartDuration, HapticPatternType.OneShot, 1) },
                { HapticType.GrindLoop, new HapticProfile(GrindLoopLeftMotor, GrindLoopRightMotor, 0f, HapticPatternType.Continuous, 1) },
                { HapticType.GrindJump, new HapticProfile(GrindJumpLeftMotor, GrindJumpRightMotor, GrindJumpDuration, HapticPatternType.OneShot, 2) },
                // Wall ride uses same values as grind
                { HapticType.WallRideStart, new HapticProfile(GrindStartLeftMotor, GrindStartRightMotor, GrindStartDuration, HapticPatternType.OneShot, 1) },
                { HapticType.WallRideLoop, new HapticProfile(GrindLoopLeftMotor, GrindLoopRightMotor, 0f, HapticPatternType.Continuous, 1) },
                { HapticType.WallRideJump, new HapticProfile(GrindJumpLeftMotor, GrindJumpRightMotor, GrindJumpDuration, HapticPatternType.OneShot, 2) },
                { HapticType.Jump, new HapticProfile(0.15f, 0.2f, 0.08f, HapticPatternType.OneShot, 0) },
                { HapticType.Land, new HapticProfile(0.3f, 0.4f, 0.1f, HapticPatternType.OneShot, 1) },

                // Abilities - Medium priority (3-4)
                { HapticType.Dash, new HapticProfile(0.5f, 0.7f, 0.2f, HapticPatternType.OneShot, 3) },
                { HapticType.Boost, new HapticProfile(0.8f, 1.0f, 0f, HapticPatternType.Continuous, 4) },

                // Combat - High priority (5-7)
                { HapticType.Parry, new HapticProfile(0.6f, 0.8f, 0.15f, HapticPatternType.OneShot, 5) },
                { HapticType.Damage, new HapticProfile(0.6f, 0.8f, 0.2f, HapticPatternType.OneShot, 6) },
                { HapticType.Knockback, new HapticProfile(0.7f, 0.9f, 0.15f, HapticPatternType.OneShot, 7) },

                // Interactions - Low priority (1-3)
                { HapticType.GraffitiProgress, new HapticProfile(0.1f, 0.15f, 0f, HapticPatternType.Pulsing, 1) },
                { HapticType.GraffitiComplete, new HapticProfile(0.5f, 0.6f, 0.25f, HapticPatternType.OneShot, 3) },
                { HapticType.Pickup, new HapticProfile(0.2f, 0.3f, 0.1f, HapticPatternType.OneShot, 2) },
                // Ability unlock and upgrades feel more impactful
                { HapticType.AbilityUnlock, new HapticProfile(0.6f, 0.8f, 0.3f, HapticPatternType.OneShot, 4) },
                { HapticType.UpgradePurchase, new HapticProfile(0.4f, 0.5f, 0.2f, HapticPatternType.OneShot, 3) }
            };
        }

        private void Start()
        {
            LogDebug("Start - Setting up health change listener");

            CheckGamepadAndLogInfo();

            if (GameSessionManager.Instance != null)
            {
                _previousHealth = GameSessionManager.Instance.CurrentHealth;
                GameSessionManager.Instance.OnHealthChanged += OnHealthChanged;
                LogDebug($"Subscribed to OnHealthChanged. Initial health: {_previousHealth}");
            }
            else
            {
                Debug.LogWarning(LogPrefix + "GameSessionManager.Instance is null - cannot subscribe to health changes");
            }
        }

        private void CheckGamepadAndLogInfo()
        {
            var gamepad = Gamepad.current;
            if (gamepad == null)
            {
                LogDebug("No gamepad currently connected");
                return;
            }

            string gamepadType = gamepad.GetType().Name;
            string deviceName = gamepad.displayName ?? gamepad.name ?? "Unknown";

            LogDebug($"Gamepad detected: {deviceName} (Type: {gamepadType})");

#if UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX
            bool isXboxController = gamepad is XInputController ||
                                    deviceName.ToLower().Contains("xbox") ||
                                    gamepadType.Contains("XInput");

            if (isXboxController && !_platformWarningShown)
            {
                Debug.LogWarning(LogPrefix +
                    $"Xbox controller '{deviceName}' detected on macOS. " +
                    "HAPTICS NOT SUPPORTED: Unity Input System does not support rumble for Xbox controllers on macOS. " +
                    "Supported configurations: Xbox on Windows/Xbox consoles, PS4/PS5 on Mac/Windows/consoles, Switch on Switch.");
                _platformWarningShown = true;
            }
#endif
        }

        private void OnDestroy()
        {
            StopAllHaptics();

            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnHealthChanged -= OnHealthChanged;
            }

            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void OnApplicationPause(bool pauseStatus)
        {
            if (pauseStatus)
            {
                StopAllHaptics();
            }
        }

        private void OnHealthChanged(int newHealth)
        {
            LogDebug($"OnHealthChanged fired: {_previousHealth} -> {newHealth}");

            if (newHealth < _previousHealth)
            {
                int damageAmount = _previousHealth - newHealth;
                LogDebug($"Damage detected! Amount: {damageAmount}. Triggering vibration...");
                TriggerHaptic(HapticType.Damage);
            }

            _previousHealth = newHealth;
        }

        /// <summary>
        /// Trigger a one-shot haptic effect.
        /// </summary>
        public void TriggerHaptic(HapticType type)
        {
            if (!_profiles.TryGetValue(type, out var profile))
            {
                LogDebug($"TriggerHaptic: Unknown haptic type {type}");
                return;
            }

            var gamepad = Gamepad.current;
            if (gamepad == null)
            {
                LogDebug($"TriggerHaptic({type}): No gamepad connected - skipping");
                return;
            }

            LogDebug($"TriggerHaptic({type}): Left={profile.LeftMotor}, Right={profile.RightMotor}, Duration={profile.Duration}s, Priority={profile.Priority}");

            // For one-shot haptics, always interrupt the previous one-shot
            if (_oneShotCoroutine != null)
            {
                StopCoroutine(_oneShotCoroutine);
            }

            // If there's a continuous haptic running with higher priority, store and restore it after
            bool shouldRestoreContinuous = _currentContinuousType.HasValue && _currentContinuousPriority > profile.Priority;

            _oneShotCoroutine = StartCoroutine(OneShotRoutine(gamepad, profile, shouldRestoreContinuous));
        }

        /// <summary>
        /// Start a continuous haptic effect that loops until stopped.
        /// </summary>
        public void StartContinuousHaptic(HapticType type)
        {
            if (!_profiles.TryGetValue(type, out var profile))
            {
                LogDebug($"StartContinuousHaptic: Unknown haptic type {type}");
                return;
            }

            var gamepad = Gamepad.current;
            if (gamepad == null)
            {
                LogDebug($"StartContinuousHaptic({type}): No gamepad connected - skipping");
                return;
            }

            // Check priority - don't interrupt higher priority continuous haptics
            if (_currentContinuousType.HasValue && _currentContinuousPriority > profile.Priority)
            {
                LogDebug($"StartContinuousHaptic({type}): Blocked by higher priority {_currentContinuousType} (priority {_currentContinuousPriority})");
                return;
            }

            LogDebug($"StartContinuousHaptic({type}): Left={profile.LeftMotor}, Right={profile.RightMotor}, Pattern={profile.PatternType}, Priority={profile.Priority}");

            // Stop existing continuous haptic
            if (_continuousCoroutine != null)
            {
                StopCoroutine(_continuousCoroutine);
            }

            _currentContinuousType = type;
            _currentContinuousPriority = profile.Priority;

            if (profile.PatternType == HapticPatternType.Pulsing)
            {
                _continuousCoroutine = StartCoroutine(PulsingRoutine(gamepad, profile));
            }
            else if (profile.PatternType == HapticPatternType.SubtlePulse)
            {
                _continuousCoroutine = StartCoroutine(SubtlePulseRoutine(gamepad, profile));
            }
            else
            {
                // Standard continuous - just set motor speeds
                float leftIntensity = profile.LeftMotor * GlobalIntensityMultiplier;
                float rightIntensity = profile.RightMotor * GlobalIntensityMultiplier;
                gamepad.SetMotorSpeeds(leftIntensity, rightIntensity);
            }
        }

        /// <summary>
        /// Stop the current continuous haptic effect.
        /// </summary>
        public void StopContinuousHaptic()
        {
            if (!_currentContinuousType.HasValue)
            {
                return;
            }

            LogDebug($"StopContinuousHaptic: Stopping {_currentContinuousType}");

            if (_continuousCoroutine != null)
            {
                StopCoroutine(_continuousCoroutine);
                _continuousCoroutine = null;
            }

            _currentContinuousType = null;
            _currentContinuousPriority = 0;

            var gamepad = Gamepad.current;
            if (gamepad != null)
            {
                gamepad.ResetHaptics();
            }
        }

        /// <summary>
        /// Stop all haptic effects immediately.
        /// </summary>
        public void StopAllHaptics()
        {
            if (_oneShotCoroutine != null)
            {
                StopCoroutine(_oneShotCoroutine);
                _oneShotCoroutine = null;
            }

            if (_continuousCoroutine != null)
            {
                StopCoroutine(_continuousCoroutine);
                _continuousCoroutine = null;
            }

            _currentContinuousType = null;
            _currentContinuousPriority = 0;

            var gamepad = Gamepad.current;
            if (gamepad != null)
            {
                gamepad.ResetHaptics();
            }
        }

        private IEnumerator OneShotRoutine(Gamepad gamepad, HapticProfile profile, bool restoreContinuousAfter)
        {
            float leftIntensity = profile.LeftMotor * GlobalIntensityMultiplier;
            float rightIntensity = profile.RightMotor * GlobalIntensityMultiplier;

            LogDebug($"OneShotRoutine: Setting motor speeds Left={leftIntensity}, Right={rightIntensity}");
            gamepad.SetMotorSpeeds(leftIntensity, rightIntensity);

            yield return new WaitForSecondsRealtime(profile.Duration);

            _oneShotCoroutine = null;

            // Restore continuous haptic if one was running, otherwise reset
            if (restoreContinuousAfter && _currentContinuousType.HasValue && _profiles.TryGetValue(_currentContinuousType.Value, out var continuousProfile))
            {
                float contLeft = continuousProfile.LeftMotor * GlobalIntensityMultiplier;
                float contRight = continuousProfile.RightMotor * GlobalIntensityMultiplier;
                LogDebug($"OneShotRoutine: Restoring continuous haptic {_currentContinuousType}");
                gamepad.SetMotorSpeeds(contLeft, contRight);
            }
            else if (!_currentContinuousType.HasValue)
            {
                LogDebug("OneShotRoutine: Resetting haptics");
                gamepad.ResetHaptics();
            }
        }

        private IEnumerator PulsingRoutine(Gamepad gamepad, HapticProfile profile)
        {
            float leftIntensity = profile.LeftMotor * GlobalIntensityMultiplier;
            float rightIntensity = profile.RightMotor * GlobalIntensityMultiplier;
            float pulseOnTime = 0.1f;
            float pulseOffTime = 0.08f;

            while (true)
            {
                gamepad.SetMotorSpeeds(leftIntensity, rightIntensity);
                yield return new WaitForSecondsRealtime(pulseOnTime);

                gamepad.SetMotorSpeeds(0f, 0f);
                yield return new WaitForSecondsRealtime(pulseOffTime);
            }
        }

        private IEnumerator SubtlePulseRoutine(Gamepad gamepad, HapticProfile profile)
        {
            // Very light, infrequent ticks - barely noticeable background texture
            // Short tick (0.03s) followed by longer silence (0.18s) = ~4.7 ticks per second
            float leftIntensity = profile.LeftMotor * GlobalIntensityMultiplier;
            float rightIntensity = profile.RightMotor * GlobalIntensityMultiplier;
            float tickDuration = 0.03f;
            float silenceDuration = 0.18f;

            while (true)
            {
                // Brief tick
                gamepad.SetMotorSpeeds(leftIntensity, rightIntensity);
                yield return new WaitForSecondsRealtime(tickDuration);

                // Longer silence
                gamepad.SetMotorSpeeds(0f, 0f);
                yield return new WaitForSecondsRealtime(silenceDuration);
            }
        }

        private void LogDebug(string message)
        {
            if (EnableDebugLogging)
            {
                Debug.Log(LogPrefix + message);
            }
        }
    }
}
