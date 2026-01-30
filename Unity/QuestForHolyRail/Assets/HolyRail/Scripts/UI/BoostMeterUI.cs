using UnityEngine;
using UnityEngine.UI;

namespace HolyRail.UI
{
    public class BoostMeterUI : MonoBehaviour
    {
        [field: SerializeField] public Image FillImage { get; private set; }
        [field: SerializeField] public CanvasGroup CanvasGroup { get; private set; }
        [field: SerializeField] public float FadeSpeed { get; private set; } = 3f;

        public static BoostMeterUI Instance { get; private set; }

        private float _targetAlpha;
        private bool _isBoosting;
        private bool _isCoolingDown;
        private float _boostTimeRemaining;
        private float _boostDuration;
        private float _cooldownTimeRemaining;
        private float _cooldownDuration;

        private void Awake()
        {
            Instance = this;
            if (CanvasGroup != null)
            {
                CanvasGroup.alpha = 0f;
            }
            _targetAlpha = 0f;
        }

        private void Update()
        {
            // Handle fading
            if (CanvasGroup != null)
            {
                CanvasGroup.alpha = Mathf.MoveTowards(CanvasGroup.alpha, _targetAlpha, FadeSpeed * Time.deltaTime);
            }

            // Handle boost depletion
            if (_isBoosting)
            {
                _boostTimeRemaining -= Time.deltaTime;
                float progress = Mathf.Clamp01(_boostTimeRemaining / _boostDuration);
                SetFill(progress);

                if (_boostTimeRemaining <= 0f)
                {
                    _isBoosting = false;
                    _isCoolingDown = true;
                    SetFill(0f);
                }
            }
            // Handle cooldown filling
            else if (_isCoolingDown)
            {
                _cooldownTimeRemaining -= Time.deltaTime;
                float progress = 1f - Mathf.Clamp01(_cooldownTimeRemaining / _cooldownDuration);
                SetFill(progress);

                if (_cooldownTimeRemaining <= 0f)
                {
                    _isCoolingDown = false;
                    _targetAlpha = 0f; // Fade out when cooldown complete
                }
            }
        }

        public void StartBoost(float duration, float cooldown)
        {
            _isBoosting = true;
            _isCoolingDown = false;
            _boostDuration = duration;
            _boostTimeRemaining = duration;
            _cooldownDuration = cooldown;
            _cooldownTimeRemaining = cooldown;

            SetFill(1f);
            _targetAlpha = 1f; // Fade in
        }

        public void OnBoostEnded()
        {
            _isBoosting = false;
            _isCoolingDown = true;
            SetFill(0f);
            // Stay visible during cooldown
        }

        private void SetFill(float amount)
        {
            if (FillImage != null)
            {
                FillImage.fillAmount = Mathf.Clamp01(amount);
            }
        }
    }
}
