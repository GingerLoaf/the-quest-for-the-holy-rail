using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.XInput;
using System.Collections;

namespace HolyRail.Scripts
{
    public class GamepadHaptics : MonoBehaviour
    {
        private const string LogPrefix = "[GamepadHaptics] ";

        [field: SerializeField] public float LeftMotorIntensity { get; private set; } = 0.4f;
        [field: SerializeField] public float RightMotorIntensity { get; private set; } = 0.6f;
        [field: SerializeField] public float VibrationDuration { get; private set; } = 0.2f;
        [field: SerializeField] public bool EnableDebugLogging { get; private set; } = true;

        private int _previousHealth;
        private Coroutine _vibrationCoroutine;
        private bool _platformWarningShown;

        private void Awake()
        {
            LogDebug("Awake - Component initializing");
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
            StopVibration();

            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnHealthChanged -= OnHealthChanged;
            }
        }

        private void OnApplicationPause(bool pauseStatus)
        {
            if (pauseStatus)
            {
                StopVibration();
            }
        }

        private void OnHealthChanged(int newHealth)
        {
            LogDebug($"OnHealthChanged fired: {_previousHealth} -> {newHealth}");

            if (newHealth < _previousHealth)
            {
                int damageAmount = _previousHealth - newHealth;
                LogDebug($"Damage detected! Amount: {damageAmount}. Triggering vibration...");
                TriggerDamageVibration();
            }
            else
            {
                LogDebug("Health increased or unchanged - no vibration");
            }

            _previousHealth = newHealth;
        }

        private void TriggerDamageVibration()
        {
            var gamepad = Gamepad.current;
            if (gamepad == null)
            {
                LogDebug("TriggerDamageVibration: No gamepad connected - skipping vibration");
                return;
            }

            string deviceName = gamepad.displayName ?? gamepad.name ?? "Unknown";
            LogDebug($"TriggerDamageVibration: Using gamepad '{deviceName}'");

            if (_vibrationCoroutine != null)
            {
                LogDebug("Stopping existing vibration coroutine");
                StopCoroutine(_vibrationCoroutine);
            }

            LogDebug($"Starting vibration: Left={LeftMotorIntensity}, Right={RightMotorIntensity}, Duration={VibrationDuration}s");
            _vibrationCoroutine = StartCoroutine(VibrationRoutine(gamepad));
        }

        private IEnumerator VibrationRoutine(Gamepad gamepad)
        {
            LogDebug("VibrationRoutine: Setting motor speeds NOW");
            gamepad.SetMotorSpeeds(LeftMotorIntensity, RightMotorIntensity);

            yield return new WaitForSecondsRealtime(VibrationDuration);

            LogDebug("VibrationRoutine: Resetting haptics");
            gamepad.ResetHaptics();
            _vibrationCoroutine = null;
        }

        private void LogDebug(string message)
        {
            if (EnableDebugLogging)
            {
                Debug.Log(LogPrefix + message);
            }
        }

        private void StopVibration()
        {
            if (_vibrationCoroutine != null)
            {
                StopCoroutine(_vibrationCoroutine);
                _vibrationCoroutine = null;
            }

            var gamepad = Gamepad.current;
            if (gamepad != null)
            {
                gamepad.ResetHaptics();
            }
        }
    }
}
