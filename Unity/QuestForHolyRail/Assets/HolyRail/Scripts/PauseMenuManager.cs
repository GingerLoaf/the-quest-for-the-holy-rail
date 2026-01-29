using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.UI;

namespace HolyRail.Scripts
{
    public class PauseMenuManager : MonoBehaviour
    {
        public static PauseMenuManager Instance { get; private set; }

        private const string VolumePrefsKey = "MasterVolume";
        private const float DefaultVolume = 1f;

        [Header("UI References")]
        [field: SerializeField] public GameObject PausePanel { get; private set; }
        [field: SerializeField] public Slider VolumeSlider { get; private set; }
        [field: SerializeField] public Button ExitButton { get; private set; }
        [field: SerializeField] public TextMeshProUGUI KeyboardControlsText { get; private set; }
        [field: SerializeField] public TextMeshProUGUI GamepadControlsText { get; private set; }

        [Header("Input")]
        [field: SerializeField] public InputActionReference PauseAction { get; private set; }

        private bool _paused;
        private float _previousTimeScale = 1f;

        private void Awake()
        {
            Instance = this;

            if (PausePanel != null)
                PausePanel.SetActive(false);

            // Load volume from PlayerPrefs
            LoadVolume();

            if (VolumeSlider != null)
            {
                VolumeSlider.value = LinearToPerceptual(AudioListener.volume);
                VolumeSlider.onValueChanged.AddListener(OnVolumeChanged);
            }

            if (ExitButton != null)
                ExitButton.onClick.AddListener(OnExitClicked);
        }

        private void OnEnable()
        {
            if (PauseAction != null && PauseAction.action != null)
            {
                PauseAction.action.Enable();
                PauseAction.action.performed += OnPausePerformed;
            }
        }

        private void OnDisable()
        {
            if (PauseAction != null && PauseAction.action != null)
                PauseAction.action.performed -= OnPausePerformed;
        }

        private void OnDestroy()
        {
            // Save volume before destroying
            SaveVolume();

            if (Instance == this)
                Instance = null;

            if (VolumeSlider != null)
                VolumeSlider.onValueChanged.RemoveListener(OnVolumeChanged);

            if (ExitButton != null)
                ExitButton.onClick.RemoveListener(OnExitClicked);
        }

        private void OnPausePerformed(InputAction.CallbackContext context)
        {
            TogglePause();
        }

        public void TogglePause()
        {
            if (_paused)
                Resume();
            else
                Pause();
        }

        public void Pause()
        {
            if (_paused)
                return;

            _paused = true;
            _previousTimeScale = Time.timeScale;
            Time.timeScale = 0f;

            if (PausePanel != null)
                PausePanel.SetActive(true);

            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;

            SelectFirstUI();
        }

        public void Resume()
        {
            if (!_paused)
                return;

            _paused = false;
            Time.timeScale = _previousTimeScale;

            if (PausePanel != null)
                PausePanel.SetActive(false);

            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }

        private void SelectFirstUI()
        {
            if (VolumeSlider != null && EventSystem.current != null)
                EventSystem.current.SetSelectedGameObject(VolumeSlider.gameObject);
            else if (ExitButton != null && EventSystem.current != null)
                EventSystem.current.SetSelectedGameObject(ExitButton.gameObject);
        }

        private void OnVolumeChanged(float sliderValue)
        {
            AudioListener.volume = PerceptualToLinear(sliderValue);
            SaveVolume();
        }

        private void LoadVolume()
        {
            float savedVolume = PlayerPrefs.GetFloat(VolumePrefsKey, DefaultVolume);
            AudioListener.volume = savedVolume;
        }

        private void SaveVolume()
        {
            PlayerPrefs.SetFloat(VolumePrefsKey, AudioListener.volume);
            PlayerPrefs.Save();
        }

        private static float PerceptualToLinear(float perceptual)
        {
            return Mathf.Pow(perceptual, 2f);
        }

        private static float LinearToPerceptual(float linear)
        {
            return Mathf.Sqrt(linear);
        }

        private void OnExitClicked()
        {
#if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
#else
            Application.Quit();
#endif
        }
    }
}
