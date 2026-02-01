using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace HolyRail.Scripts.UI
{
    public class StartScreenManager : MonoBehaviour
    {
        private const string MainSceneName = "MainProceduralScene";
        private const float FadeDuration = 2f;
        private const float InputCooldown = 0.2f;
        private const float AxisThreshold = 0.5f;

        [field: SerializeField] public AudioClip TransitionSfx { get; private set; }
        [field: SerializeField] public Image FadeOverlay { get; private set; }
        [field: SerializeField] public AudioSource MusicSource { get; private set; }
        [field: SerializeField] public Text NewGameText { get; private set; }
        [field: SerializeField] public Text QuitText { get; private set; }

        private static readonly Color SelectedColor = new Color(0.4f, 0.8f, 1f, 1f);
        private static readonly Color UnselectedColor = new Color(0.2f, 0.4f, 0.6f, 0.7f);

        private AsyncOperation _loadOperation;
        private AudioSource _sfxSource;
        private bool _isTransitioning;
        private int _selectedIndex;
        private float _lastInputTime;
        private bool _axisInUse;

        private void Start()
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;

            if (FadeOverlay != null)
                FadeOverlay.color = new Color(0, 0, 0, 0);

            _sfxSource = gameObject.AddComponent<AudioSource>();
            _sfxSource.playOnAwake = false;

            _loadOperation = SceneManager.LoadSceneAsync(MainSceneName);
            _loadOperation.allowSceneActivation = false;

            _selectedIndex = 0;
            UpdateMenuVisuals();
        }

        private void Update()
        {
            if (_isTransitioning)
                return;

            HandleNavigationInput();
            HandleSelectionInput();
        }

        private void HandleNavigationInput()
        {
            if (Time.time - _lastInputTime < InputCooldown)
                return;

            int direction = 0;

            // Keyboard
            if (Input.GetKeyDown(KeyCode.UpArrow) || Input.GetKeyDown(KeyCode.W))
                direction = -1;
            else if (Input.GetKeyDown(KeyCode.DownArrow) || Input.GetKeyDown(KeyCode.S))
                direction = 1;

            // Gamepad left stick / dpad (with axis deadzone handling)
            float verticalAxis = Input.GetAxisRaw("Vertical");
            if (Mathf.Abs(verticalAxis) > AxisThreshold)
            {
                if (!_axisInUse)
                {
                    direction = verticalAxis > 0 ? -1 : 1;
                    _axisInUse = true;
                }
            }
            else
            {
                _axisInUse = false;
            }

            if (direction != 0)
            {
                _selectedIndex = Mathf.Clamp(_selectedIndex + direction, 0, 1);
                _lastInputTime = Time.time;
                UpdateMenuVisuals();
            }
        }

        private void HandleSelectionInput()
        {
            bool selected = false;

            // Keyboard: Enter or Space
            if (Input.GetKeyDown(KeyCode.Return) || Input.GetKeyDown(KeyCode.Space))
                selected = true;

            // Gamepad: A (joystick button 0), X (joystick button 2), or Submit
            if (Input.GetButtonDown("Submit") ||
                Input.GetKeyDown(KeyCode.JoystickButton0) ||
                Input.GetKeyDown(KeyCode.JoystickButton2))
                selected = true;

            if (selected)
                ExecuteSelectedOption();
        }

        private void UpdateMenuVisuals()
        {
            if (NewGameText != null)
                NewGameText.color = _selectedIndex == 0 ? SelectedColor : UnselectedColor;
            if (QuitText != null)
                QuitText.color = _selectedIndex == 1 ? SelectedColor : UnselectedColor;
        }

        private void ExecuteSelectedOption()
        {
            if (_selectedIndex == 0)
            {
                _isTransitioning = true;
                StartCoroutine(TransitionToGame());
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.EditorApplication.isPlaying = false;
#else
                Application.Quit();
#endif
            }
        }

        private IEnumerator TransitionToGame()
        {
            if (TransitionSfx != null && _sfxSource != null)
                _sfxSource.PlayOneShot(TransitionSfx);

            float startMusicVolume = MusicSource != null ? MusicSource.volume : 0f;

            float elapsed = 0f;
            while (elapsed < FadeDuration)
            {
                elapsed += Time.deltaTime;
                float t = Mathf.Clamp01(elapsed / FadeDuration);
                if (FadeOverlay != null)
                    FadeOverlay.color = new Color(0, 0, 0, t);
                if (MusicSource != null)
                    MusicSource.volume = Mathf.Lerp(startMusicVolume, 0f, t);
                yield return null;
            }

            if (FadeOverlay != null)
                FadeOverlay.color = Color.black;
            if (MusicSource != null)
                MusicSource.volume = 0f;

            _loadOperation.allowSceneActivation = true;
        }
    }
}
