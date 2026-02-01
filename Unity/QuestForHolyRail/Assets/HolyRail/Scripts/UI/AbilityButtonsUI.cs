using Art.PickUps;
using StarterAssets;
using UnityEngine;
using UnityEngine.UI;

namespace HolyRail.UI
{
    public class AbilityButtonsUI : MonoBehaviour
    {
        [System.Serializable]
        public class AbilityButton
        {
            [Tooltip("The background image of the button")]
            public Image Background;
            [Tooltip("The cooldown overlay image (should use Filled image type with Radial360)")]
            public Image CooldownOverlay;
            [Tooltip("Icon image for the ability")]
            public Image Icon;
        }

        [Header("Ability Buttons")]
        [SerializeField] private AbilityButton _jumpButton = new();
        [SerializeField] private AbilityButton _dashButton = new();
        [SerializeField] private AbilityButton _parryButton = new();
        [SerializeField] private AbilityButton _boostButton = new();

        [Header("Auto-Find Settings")]
        [Tooltip("If true, automatically finds button references by searching for child objects named JumpButton, DashButton, ParryButton, BoostButton")]
        [SerializeField] private bool _autoFindReferences = true;

        [Header("Colors")]
        [SerializeField] private Color _normalColor = new Color(0.2f, 0.2f, 0.2f, 0.8f);
        [SerializeField] private Color _pressedColor = new Color(0.8f, 0.8f, 0.8f, 1f);
        [SerializeField] private Color _activeColor = new Color(0.3f, 0.8f, 0.3f, 1f);
        [SerializeField] private Color _cooldownColor = new Color(0.5f, 0.5f, 0.5f, 0.9f);
        [SerializeField] private Color _lockedColor = new Color(0.1f, 0.1f, 0.1f, 0.4f);
        [SerializeField] private Color _cooldownOverlayColor = new Color(0f, 0f, 0f, 0.7f);

        private ThirdPersonController_RailGrinder _controller;
        private StarterAssetsInputs _input;

        private void Awake()
        {
            if (_autoFindReferences)
            {
                AutoFindButtonReferences();
            }
        }

        private void Start()
        {
            FindController();
            InitializeCooldownOverlays();
        }

        private void AutoFindButtonReferences()
        {
            FindButtonReferences("JumpButton", _jumpButton);
            FindButtonReferences("DashButton", _dashButton);
            FindButtonReferences("ParryButton", _parryButton);
            FindButtonReferences("BoostButton", _boostButton);
        }

        private void FindButtonReferences(string buttonName, AbilityButton button)
        {
            var buttonTransform = transform.Find("ButtonsContainer/" + buttonName);
            if (buttonTransform == null)
            {
                buttonTransform = FindDeepChild(transform, buttonName);
            }

            if (buttonTransform == null) return;

            var backgroundTransform = buttonTransform.Find("Background");
            if (backgroundTransform != null && button.Background == null)
            {
                button.Background = backgroundTransform.GetComponent<Image>();
            }

            var cooldownTransform = buttonTransform.Find("CooldownOverlay");
            if (cooldownTransform != null && button.CooldownOverlay == null)
            {
                button.CooldownOverlay = cooldownTransform.GetComponent<Image>();
            }

            var iconTransform = buttonTransform.Find("Icon");
            if (iconTransform != null && button.Icon == null)
            {
                button.Icon = iconTransform.GetComponent<Image>();
            }
        }

        private Transform FindDeepChild(Transform parent, string name)
        {
            foreach (Transform child in parent)
            {
                if (child.name == name)
                    return child;

                var result = FindDeepChild(child, name);
                if (result != null)
                    return result;
            }
            return null;
        }

        private void FindController()
        {
            _controller = ThirdPersonController_RailGrinder.Instance;
            if (_controller != null)
            {
                _input = _controller.InputState;
            }
        }

        private void InitializeCooldownOverlays()
        {
            SetupCooldownOverlay(_jumpButton);
            SetupCooldownOverlay(_dashButton);
            SetupCooldownOverlay(_parryButton);
            SetupCooldownOverlay(_boostButton);
        }

        private void SetupCooldownOverlay(AbilityButton button)
        {
            if (button?.CooldownOverlay != null)
            {
                button.CooldownOverlay.type = Image.Type.Filled;
                button.CooldownOverlay.fillMethod = Image.FillMethod.Radial360;
                button.CooldownOverlay.fillOrigin = (int)Image.Origin360.Top;
                button.CooldownOverlay.fillClockwise = true;
                button.CooldownOverlay.color = _cooldownOverlayColor;
            }
        }

        private void Update()
        {
            if (_controller == null || _input == null)
            {
                FindController();
                if (_controller == null || _input == null)
                {
                    return;
                }
            }

            UpdateJumpButton();
            UpdateDashButton();
            UpdateParryButton();
            UpdateBoostButton();
        }

        private void UpdateJumpButton()
        {
            if (_jumpButton?.Background == null) return;

            bool isPressed = _input.jump;

            // Jump is always available, no unlock required
            _jumpButton.Background.color = isPressed ? _pressedColor : _normalColor;

            // Jump has no cooldown
            if (_jumpButton.CooldownOverlay != null)
            {
                _jumpButton.CooldownOverlay.fillAmount = 0f;
            }
        }

        private void UpdateDashButton()
        {
            if (_dashButton?.Background == null) return;

            bool isUnlocked = AbilityPickUp.IsAbilityUnlocked(AbilityType.Dash);
            bool isActive = _controller.IsDashing;
            bool isOnCooldown = _controller.DashCooldownNormalized > 0f;
            bool isPressed = _input.dash;

            UpdateButtonVisual(_dashButton, isUnlocked, isActive, isOnCooldown, isPressed);

            // Update cooldown overlay
            if (_dashButton.CooldownOverlay != null)
            {
                _dashButton.CooldownOverlay.fillAmount = isUnlocked ? _controller.DashCooldownNormalized : 0f;
            }
        }

        private void UpdateParryButton()
        {
            if (_parryButton?.Background == null) return;

            bool isUnlocked = AbilityPickUp.IsAbilityUnlocked(AbilityType.Parry);
            bool isActive = _controller.IsParryActive;
            bool isPressed = _input.parry;

            // Parry doesn't have a traditional cooldown, just show active state
            UpdateButtonVisual(_parryButton, isUnlocked, isActive, false, isPressed);

            // Parry has no cooldown overlay
            if (_parryButton.CooldownOverlay != null)
            {
                _parryButton.CooldownOverlay.fillAmount = 0f;
            }
        }

        private void UpdateBoostButton()
        {
            if (_boostButton?.Background == null) return;

            bool isUnlocked = AbilityPickUp.IsAbilityUnlocked(AbilityType.Boost);
            bool isActive = _controller.IsBoosting;
            bool isOnCooldown = _controller.BoostCooldownNormalized > 0f;
            bool isPressed = _input.boost;

            UpdateButtonVisual(_boostButton, isUnlocked, isActive, isOnCooldown, isPressed);

            // Update cooldown overlay
            if (_boostButton.CooldownOverlay != null)
            {
                _boostButton.CooldownOverlay.fillAmount = isUnlocked ? _controller.BoostCooldownNormalized : 0f;
            }
        }

        private void UpdateButtonVisual(AbilityButton button, bool isUnlocked, bool isActive, bool isOnCooldown, bool isPressed)
        {
            if (button?.Background == null) return;

            if (!isUnlocked)
            {
                button.Background.color = _lockedColor;
                if (button.Icon != null)
                {
                    button.Icon.color = new Color(1f, 1f, 1f, 0.3f);
                }
                return;
            }

            if (isActive)
            {
                button.Background.color = _activeColor;
            }
            else if (isOnCooldown)
            {
                button.Background.color = _cooldownColor;
            }
            else if (isPressed)
            {
                button.Background.color = _pressedColor;
            }
            else
            {
                button.Background.color = _normalColor;
            }

            if (button.Icon != null)
            {
                button.Icon.color = Color.white;
            }
        }
    }
}
