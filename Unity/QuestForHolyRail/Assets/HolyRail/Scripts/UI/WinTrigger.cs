using System.Collections;
using HolyRail.City;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace HolyRail.Scripts.UI
{
    public class WinTrigger : MonoBehaviour
    {
        private const string StartSceneName = "StartScene";

        [field: SerializeField] public Image FadeOverlay { get; private set; }
        [field: SerializeField] public GameObject WinText { get; private set; }
        [field: SerializeField] public TextMeshProUGUI ScoreText { get; private set; }
        [field: SerializeField] public TextMeshProUGUI GraffitiText { get; private set; }
        [field: SerializeField] public float FadeDuration { get; private set; } = 2f;
        [field: SerializeField] public float DisplayDuration { get; private set; } = 5f;

        private bool _triggered;
        private BoxCollider _collider;

        private void Awake()
        {
            _collider = GetComponent<BoxCollider>();
        }

        private void Start()
        {
            if (FadeOverlay != null)
                FadeOverlay.color = new Color(0, 0, 0, 0);

            if (WinText != null)
                WinText.SetActive(false);

            if (ScoreText != null)
                ScoreText.gameObject.SetActive(false);

            if (GraffitiText != null)
                GraffitiText.gameObject.SetActive(false);
        }

        private void Update()
        {
            if (_triggered || _collider == null)
                return;

            // Distance-based check for grinding (CharacterController disabled during grind)
            if (StarterAssets.ThirdPersonController_RailGrinder.Instance != null)
            {
                var playerPos = StarterAssets.ThirdPersonController_RailGrinder.Instance.transform.position;
                var bounds = _collider.bounds;

                if (bounds.Contains(playerPos))
                {
                    TriggerWin();
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player") && !_triggered)
            {
                TriggerWin();
            }
        }

        private void TriggerWin()
        {
            if (_triggered)
                return;

            _triggered = true;
            Debug.Log("<color=green>[WIN]</color> Player reached the end! Loading StartScene...", gameObject);

            // Pause death wall if present
            if (DeathWall.Instance != null)
                DeathWall.Instance.Pause();

            StartCoroutine(WinSequence());
        }

        private IEnumerator WinSequence()
        {
            // Fade to black (if overlay exists)
            if (FadeOverlay != null)
            {
                float elapsed = 0f;
                while (elapsed < FadeDuration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / FadeDuration);
                    FadeOverlay.color = new Color(0, 0, 0, t);
                    yield return null;
                }
                FadeOverlay.color = Color.black;
            }

            // Show win text (if exists)
            if (WinText != null)
                WinText.SetActive(true);

            // Show final score
            if (ScoreText != null)
            {
                int finalScore = ScoreManager.Instance != null ? ScoreManager.Instance.CurrentScore : 0;
                ScoreText.text = $"Score: ${finalScore:N0}";
                ScoreText.gameObject.SetActive(true);
            }

            // Show graffiti count
            if (GraffitiText != null)
            {
                var graffitiPool = FindFirstObjectByType<GraffitiSpotPool>();
                var cityManager = FindFirstObjectByType<CityManager>();
                int collected = graffitiPool != null ? graffitiPool.CompletedCount : 0;
                int total = cityManager != null ? cityManager.ActualGraffitiCount : 0;
                GraffitiText.text = $"Graffiti: {collected}/{total}";
                GraffitiText.gameObject.SetActive(true);
            }

            // Hold for display duration (or brief pause if no UI)
            float waitTime = (FadeOverlay != null || WinText != null) ? DisplayDuration : 1f;
            yield return new WaitForSeconds(waitTime);

            // Load start scene
            SceneManager.LoadScene(StartSceneName);
        }
    }
}
