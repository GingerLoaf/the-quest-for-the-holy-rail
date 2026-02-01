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

        [field: SerializeField] public AudioClip TransitionSfx { get; private set; }
        [field: SerializeField] public Image FadeOverlay { get; private set; }

        private AsyncOperation _loadOperation;
        private AudioSource _sfxSource;
        private bool _isTransitioning;

        private void Start()
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;

            // Ensure fade overlay starts transparent
            if (FadeOverlay != null)
                FadeOverlay.color = new Color(0, 0, 0, 0);

            // Create audio source for SFX
            _sfxSource = gameObject.AddComponent<AudioSource>();
            _sfxSource.playOnAwake = false;

            _loadOperation = SceneManager.LoadSceneAsync(MainSceneName);
            _loadOperation.allowSceneActivation = false;
        }

        private void Update()
        {
            if (_isTransitioning)
                return;

            if (Input.anyKeyDown)
            {
                _isTransitioning = true;
                StartCoroutine(TransitionToGame());
            }
        }

        private IEnumerator TransitionToGame()
        {
            // Play SFX (first 2 seconds)
            if (TransitionSfx != null && _sfxSource != null)
                _sfxSource.PlayOneShot(TransitionSfx);

            // Fade to black
            float elapsed = 0f;
            while (elapsed < FadeDuration)
            {
                elapsed += Time.deltaTime;
                float alpha = Mathf.Clamp01(elapsed / FadeDuration);
                if (FadeOverlay != null)
                    FadeOverlay.color = new Color(0, 0, 0, alpha);
                yield return null;
            }

            // Ensure fully black
            if (FadeOverlay != null)
                FadeOverlay.color = Color.black;

            // Activate scene when ready
            _loadOperation.allowSceneActivation = true;
        }
    }
}
