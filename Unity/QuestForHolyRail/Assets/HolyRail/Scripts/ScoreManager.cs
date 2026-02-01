using System;
using System.Collections;
using UnityEngine;
using TMPro;

namespace HolyRail.Scripts
{
    public class ScoreManager : MonoBehaviour
    {
        public static ScoreManager Instance { get; private set; }

        [Header("Score Values")]
        [field: Tooltip("Points earned per second while grinding")]
        [field: SerializeField]
        public float GrindingPointsPerSecond { get; private set; } = 10f;

        [field: Tooltip("Points earned when landing on a spline")]
        [field: SerializeField]
        public int SplineLandingPoints { get; private set; } = 50;

        [field: Tooltip("Points earned when jumping from one spline to another")]
        [field: SerializeField]
        public int SplineTransferPoints { get; private set; } = 100;

        [field: Tooltip("Points earned for a near miss with the death wall")]
        [field: SerializeField]
        public int NearMissPoints { get; private set; } = 200;

        [field: Tooltip("Points earned for destroying an enemy")]
        [field: SerializeField]
        public int EnemyDestroyedPoints { get; private set; } = 500;

        [field: Tooltip("Points earned for claiming a graffiti spot")]
        [field: SerializeField]
        public int GraffitiClaimedPoints { get; private set; } = 300;

        [Header("Near Miss Settings")]
        [field: Tooltip("Distance from death wall to trigger near miss detection")]
        [field: SerializeField]
        public float NearMissDistance { get; private set; } = 5f;

        [field: Tooltip("Distance player must escape to for near miss to count")]
        [field: SerializeField]
        public float NearMissEscapeDistance { get; private set; } = 15f;

        [field: Tooltip("Cooldown between near miss awards")]
        [field: SerializeField]
        public float NearMissCooldown { get; private set; } = 5f;

        [Header("UI - Score Display")]
        [field: Tooltip("TextMeshProUGUI component to display score")]
        [field: SerializeField]
        public TextMeshProUGUI ScoreText { get; private set; }

        [field: Tooltip("Format string for score display (use {0} for score value)")]
        [field: SerializeField]
        public string ScoreFormat { get; private set; } = "${0:N0}";

        [Header("UI - Popup Text")]
        [field: Tooltip("TextMeshProUGUI component for popup notifications (hidden by default)")]
        [field: SerializeField]
        public TextMeshProUGUI PopupText { get; private set; }

        [field: Tooltip("Text shown when landing on a spline")]
        [field: SerializeField]
        public string SplineLandingPopupText { get; private set; } = "GRIND!";

        [field: Tooltip("Text shown when transferring between splines")]
        [field: SerializeField]
        public string SplineTransferPopupText { get; private set; } = "TRANSFER!";

        [field: Tooltip("Text shown for a near miss")]
        [field: SerializeField]
        public string NearMissPopupText { get; private set; } = "CLOSE CALL!";

        [field: Tooltip("Text shown when destroying an enemy")]
        [field: SerializeField]
        public string EnemyDestroyedPopupText { get; private set; } = "DESTROYED!";

        [field: Tooltip("Text shown when claiming a graffiti spot")]
        [field: SerializeField]
        public string GraffitiClaimedPopupText { get; private set; } = "TAGGED!";

        [Header("Score Animation Settings")]
        [field: Tooltip("Base scale multiplier for score bump animation")]
        [field: SerializeField]
        public float ScoreAnimBaseScale { get; private set; } = 1.2f;

        [field: Tooltip("Maximum scale multiplier for large score additions")]
        [field: SerializeField]
        public float ScoreAnimMaxScale { get; private set; } = 1.5f;

        [field: Tooltip("Base rotation wiggle in degrees")]
        [field: SerializeField]
        public float ScoreAnimBaseRotation { get; private set; } = 5f;

        [field: Tooltip("Maximum rotation wiggle in degrees")]
        [field: SerializeField]
        public float ScoreAnimMaxRotation { get; private set; } = 15f;

        [field: Tooltip("Duration of the score bump animation")]
        [field: SerializeField]
        public float ScoreAnimDuration { get; private set; } = 0.3f;

        [field: Tooltip("Points value that maps to maximum animation intensity")]
        [field: SerializeField]
        public int ScoreAnimMaxPoints { get; private set; } = 500;

        [field: Tooltip("Color to flash the score text during animation")]
        [field: SerializeField]
        public Color ScoreAnimFlashColor { get; private set; } = Color.yellow;

        [Header("Popup Animation Settings")]
        [field: Tooltip("Duration of popup fade in")]
        [field: SerializeField]
        public float PopupFadeInDuration { get; private set; } = 0.15f;

        [field: Tooltip("Duration popup stays visible")]
        [field: SerializeField]
        public float PopupHoldDuration { get; private set; } = 0.8f;

        [field: Tooltip("Duration of popup fade out")]
        [field: SerializeField]
        public float PopupFadeOutDuration { get; private set; } = 0.3f;

        [field: Tooltip("Scale the popup starts at")]
        [field: SerializeField]
        public float PopupStartScale { get; private set; } = 0.5f;

        [field: Tooltip("Scale the popup peaks at")]
        [field: SerializeField]
        public float PopupPeakScale { get; private set; } = 1.2f;

        [field: Tooltip("Vertical offset the popup moves during animation")]
        [field: SerializeField]
        public float PopupVerticalOffset { get; private set; } = 30f;

        [field: Tooltip("Color to flash the popup text during animation")]
        [field: SerializeField]
        public Color PopupFlashColor { get; private set; } = Color.yellow;

        [Header("Audio")]
        [Tooltip("Sound played when score popup is shown")]
        [SerializeField] private AudioClip _scorePopupClip;
        [Tooltip("Sound played for near miss bonus")]
        [SerializeField] private AudioClip _nearMissClip;
        [Tooltip("Sound played when enemy is destroyed")]
        [SerializeField] private AudioClip _enemyKillClip;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 0.6f;

        public Action<int> OnScoreChanged;

        public int CurrentScore
        {
            get => _currentScore;
            private set
            {
                int previousScore = _currentScore;
                _currentScore = value;

                // Calculate points added and add to persistent money
                // This ensures money only goes up with score, and doesn't get overwritten or reset
                int pointsAdded = _currentScore - previousScore;
                if (pointsAdded > 0 && GameSessionManager.Instance != null)
                {
                    GameSessionManager.Instance.Money += pointsAdded;
                }

                UpdateUI();

                // Trigger score animation based on points added
                if (pointsAdded > 0)
                {
                    TriggerScoreAnimation(pointsAdded);
                }

                try
                {
                    OnScoreChanged?.Invoke(_currentScore);
                }
                catch (Exception ex)
                {
                    Debug.LogException(ex);
                }
            }
        }

        private int _currentScore;
        private float _grindingAccumulator;
        private bool _isGrinding;
        private bool _inNearMissZone;
        private float _nearMissCooldownTimer;
        private Transform _playerTransform;
        private Transform _deathWallTransform;

        private Coroutine _scoreAnimCoroutine;
        private Coroutine _popupAnimCoroutine;
        private Vector3 _scoreTextBaseScale;
        private Color _scoreTextBaseColor;
        private Vector3 _popupBasePosition;
        private Color _popupBaseColor;

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;
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
            // Find the player
            var player = StarterAssets.ThirdPersonController_RailGrinder.Instance;
            if (player != null)
            {
                _playerTransform = player.transform;
            }

            // Find the death wall
            var deathWall = FindFirstObjectByType<DeathWall>();
            if (deathWall != null)
            {
                _deathWallTransform = deathWall.transform;
            }

            // Cache base values for animations
            if (ScoreText != null)
            {
                _scoreTextBaseScale = ScoreText.transform.localScale;
                _scoreTextBaseColor = ScoreText.color;
            }

            if (PopupText != null)
            {
                _popupBasePosition = PopupText.rectTransform.anchoredPosition;
                _popupBaseColor = PopupText.color;
                SetPopupAlpha(0f);
            }

            // Initialize UI with starting score (0 for new run)
            UpdateUI();
        }

        private void Update()
        {
            // Update grinding score accumulation
            if (_isGrinding)
            {
                _grindingAccumulator += GrindingPointsPerSecond * Time.deltaTime;

                // Award whole points when accumulated
                if (_grindingAccumulator >= 1f)
                {
                    int pointsToAward = Mathf.FloorToInt(_grindingAccumulator);
                    CurrentScore += pointsToAward;
                    _grindingAccumulator -= pointsToAward;
                }
            }

            // Update near miss detection
            UpdateNearMissDetection();

            // Update cooldown timer
            if (_nearMissCooldownTimer > 0f)
            {
                _nearMissCooldownTimer -= Time.deltaTime;
            }
        }

        private void UpdateNearMissDetection()
        {
            if (_playerTransform == null || _deathWallTransform == null)
                return;

            float distanceToWall = _playerTransform.position.z - _deathWallTransform.position.z;

            // Check if entering near miss zone
            if (!_inNearMissZone && distanceToWall <= NearMissDistance && distanceToWall > 0f)
            {
                _inNearMissZone = true;
            }

            // Check if escaped from near miss zone
            if (_inNearMissZone && distanceToWall >= NearMissEscapeDistance)
            {
                if (_nearMissCooldownTimer <= 0f)
                {
                    AwardNearMiss();
                    _nearMissCooldownTimer = NearMissCooldown;
                }
                _inNearMissZone = false;
            }

            // Reset if wall catches up (death will reset score anyway)
            if (_inNearMissZone && distanceToWall <= 0f)
            {
                _inNearMissZone = false;
            }
        }

        private void UpdateUI()
        {
            if (ScoreText != null)
            {
                ScoreText.text = string.Format(ScoreFormat, _currentScore);
            }
        }

        private void TriggerScoreAnimation(int pointsAdded)
        {
            if (ScoreText == null)
                return;

            if (_scoreAnimCoroutine != null)
            {
                StopCoroutine(_scoreAnimCoroutine);
            }

            _scoreAnimCoroutine = StartCoroutine(ScoreAnimationCoroutine(pointsAdded));
        }

        private IEnumerator ScoreAnimationCoroutine(int pointsAdded)
        {
            float intensity = Mathf.Clamp01((float)pointsAdded / ScoreAnimMaxPoints);

            float targetScale = Mathf.Lerp(ScoreAnimBaseScale, ScoreAnimMaxScale, intensity);
            float targetRotation = Mathf.Lerp(ScoreAnimBaseRotation, ScoreAnimMaxRotation, intensity);
            float halfDuration = ScoreAnimDuration * 0.5f;

            // Animate to peak
            float elapsed = 0f;
            while (elapsed < halfDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / halfDuration;
                float easeT = EaseOutBack(t);

                // Scale
                float currentScale = Mathf.Lerp(1f, targetScale, easeT);
                ScoreText.transform.localScale = _scoreTextBaseScale * currentScale;

                // Rotation wiggle
                float wiggle = Mathf.Sin(t * Mathf.PI * 4f) * targetRotation * (1f - t);
                ScoreText.transform.localRotation = Quaternion.Euler(0f, 0f, wiggle);

                // Color flash
                ScoreText.color = Color.Lerp(_scoreTextBaseColor, ScoreAnimFlashColor, easeT * intensity);

                yield return null;
            }

            // Animate back to normal
            elapsed = 0f;
            while (elapsed < halfDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / halfDuration;
                float easeT = EaseInOutQuad(t);

                // Scale back
                float currentScale = Mathf.Lerp(targetScale, 1f, easeT);
                ScoreText.transform.localScale = _scoreTextBaseScale * currentScale;

                // Rotation settle
                float wiggle = Mathf.Sin((1f - t) * Mathf.PI * 2f) * targetRotation * (1f - t) * 0.3f;
                ScoreText.transform.localRotation = Quaternion.Euler(0f, 0f, wiggle);

                // Color fade back
                ScoreText.color = Color.Lerp(ScoreAnimFlashColor, _scoreTextBaseColor, easeT);

                yield return null;
            }

            // Ensure we're back to base state
            ScoreText.transform.localScale = _scoreTextBaseScale;
            ScoreText.transform.localRotation = Quaternion.identity;
            ScoreText.color = _scoreTextBaseColor;

            _scoreAnimCoroutine = null;
        }

        public void ShowPopup(string text)
        {
            if (PopupText == null)
                return;

            if (_popupAnimCoroutine != null)
            {
                StopCoroutine(_popupAnimCoroutine);
            }

            _popupAnimCoroutine = StartCoroutine(PopupAnimationCoroutine(text));
        }

        private IEnumerator PopupAnimationCoroutine(string text)
        {
            PopupText.text = text;

            // Fade in with scale, position, and color flash
            float elapsed = 0f;
            while (elapsed < PopupFadeInDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / PopupFadeInDuration;
                float easeT = EaseOutBack(t);

                SetPopupColorWithAlpha(Color.Lerp(_popupBaseColor, PopupFlashColor, easeT), t);
                float scale = Mathf.Lerp(PopupStartScale, PopupPeakScale, easeT);
                PopupText.transform.localScale = Vector3.one * scale;

                float yOffset = Mathf.Lerp(-PopupVerticalOffset * 0.5f, 0f, easeT);
                PopupText.rectTransform.anchoredPosition = _popupBasePosition + new Vector3(0f, yOffset, 0f);

                yield return null;
            }

            SetPopupColorWithAlpha(PopupFlashColor, 1f);
            PopupText.transform.localScale = Vector3.one * PopupPeakScale;
            PopupText.rectTransform.anchoredPosition = _popupBasePosition;

            // Scale down to normal during hold, start fading color back
            elapsed = 0f;
            while (elapsed < PopupHoldDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / PopupHoldDuration;

                float scale = Mathf.Lerp(PopupPeakScale, 1f, EaseInOutQuad(t));
                PopupText.transform.localScale = Vector3.one * scale;

                // Fade color back to base during hold
                SetPopupColorWithAlpha(Color.Lerp(PopupFlashColor, _popupBaseColor, EaseInOutQuad(t)), 1f);

                yield return null;
            }

            // Fade out with upward movement
            elapsed = 0f;
            while (elapsed < PopupFadeOutDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / PopupFadeOutDuration;
                float easeT = EaseInQuad(t);

                SetPopupColorWithAlpha(_popupBaseColor, 1f - t);
                float scale = Mathf.Lerp(1f, 0.8f, easeT);
                PopupText.transform.localScale = Vector3.one * scale;

                float yOffset = Mathf.Lerp(0f, PopupVerticalOffset, easeT);
                PopupText.rectTransform.anchoredPosition = _popupBasePosition + new Vector3(0f, yOffset, 0f);

                yield return null;
            }

            SetPopupAlpha(0f);
            PopupText.rectTransform.anchoredPosition = _popupBasePosition;

            _popupAnimCoroutine = null;
        }

        private void SetPopupAlpha(float alpha)
        {
            if (PopupText == null)
                return;

            var color = PopupText.color;
            color.a = alpha;
            PopupText.color = color;
        }

        private void SetPopupColorWithAlpha(Color color, float alpha)
        {
            if (PopupText == null)
                return;

            color.a = alpha;
            PopupText.color = color;
        }

        private float EaseOutBack(float t)
        {
            const float c1 = 1.70158f;
            const float c3 = c1 + 1f;
            return 1f + c3 * Mathf.Pow(t - 1f, 3f) + c1 * Mathf.Pow(t - 1f, 2f);
        }

        private float EaseInOutQuad(float t)
        {
            return t < 0.5f ? 2f * t * t : 1f - Mathf.Pow(-2f * t + 2f, 2f) / 2f;
        }

        private float EaseInQuad(float t)
        {
            return t * t;
        }

        public void OnGrindStarted()
        {
            if (!_isGrinding)
            {
                _isGrinding = true;
                CurrentScore += SplineLandingPoints;
                ShowPopup(SplineLandingPopupText);
            }
        }

        public void OnGrindEnded()
        {
            _isGrinding = false;
            _grindingAccumulator = 0f;
        }

        public void OnSplineTransfer()
        {
            CurrentScore += SplineTransferPoints;
            ShowPopup(SplineTransferPopupText);
        }

        public void AwardNearMiss()
        {
            CurrentScore += NearMissPoints;
            ShowPopup(NearMissPopupText);
            Debug.Log($"<color=yellow>[Near Miss!]</color> +{NearMissPoints} points!", gameObject);

            // Play near miss sound
            if (_nearMissClip != null)
            {
                AudioSource.PlayClipAtPoint(_nearMissClip, Camera.main != null ? Camera.main.transform.position : Vector3.zero, _audioVolume);
            }
        }

        public void AwardEnemyDestroyed()
        {
            CurrentScore += EnemyDestroyedPoints;
            ShowPopup(EnemyDestroyedPopupText);
            Debug.Log($"<color=red>[Enemy Destroyed!]</color> +{EnemyDestroyedPoints} points!", gameObject);

            // Play enemy kill sound
            if (_enemyKillClip != null)
            {
                AudioSource.PlayClipAtPoint(_enemyKillClip, Camera.main != null ? Camera.main.transform.position : Vector3.zero, _audioVolume);
            }
        }

        public void AddGraffitiScore()
        {
            CurrentScore += GraffitiClaimedPoints;
            ShowPopup(GraffitiClaimedPopupText);
            Debug.Log($"<color=magenta>[Graffiti Claimed!]</color> +{GraffitiClaimedPoints} points!", gameObject);
        }

        public void ResetScore()
        {
            _currentScore = 0;
            _grindingAccumulator = 0f;
            _isGrinding = false;
            _inNearMissZone = false;
            
            // Reset GameSessionManager money (player loses money on death)
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.Money = 0;
                GameSessionManager.Instance.RegenerateShopInventory();
            }
            
            UpdateUI();

            // Reset animations
            if (_scoreAnimCoroutine != null)
            {
                StopCoroutine(_scoreAnimCoroutine);
                _scoreAnimCoroutine = null;
            }

            if (_popupAnimCoroutine != null)
            {
                StopCoroutine(_popupAnimCoroutine);
                _popupAnimCoroutine = null;
            }

            if (ScoreText != null)
            {
                ScoreText.transform.localScale = _scoreTextBaseScale;
                ScoreText.transform.localRotation = Quaternion.identity;
                ScoreText.color = _scoreTextBaseColor;
            }

            if (PopupText != null)
            {
                SetPopupColorWithAlpha(_popupBaseColor, 0f);
                PopupText.rectTransform.anchoredPosition = _popupBasePosition;
            }
        }

        public void AddScore(int points)
        {
            if (points > 0)
            {
                CurrentScore += points;
            }
        }
    }
}
