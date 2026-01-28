using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace HolyRail.Scripts.Shop
{
    public class UpgradeItemUI : MonoBehaviour
    {
        [Header("UI References")]
        [field: Tooltip("Image displaying the upgrade icon")]
        [field: SerializeField]
        public Image IconImage { get; private set; }

        [field: Tooltip("Text displaying the upgrade name")]
        [field: SerializeField]
        public TextMeshProUGUI NameText { get; private set; }

        [field: Tooltip("Text displaying the upgrade cost")]
        [field: SerializeField]
        public TextMeshProUGUI CostText { get; private set; }

        [field: Tooltip("Text displaying the upgrade effect/description")]
        [field: SerializeField]
        public TextMeshProUGUI EffectText { get; private set; }

        [field: Tooltip("Button to purchase the upgrade")]
        [field: SerializeField]
        public Button PurchaseButton { get; private set; }

        [field: Tooltip("Text on the purchase button")]
        [field: SerializeField]
        public TextMeshProUGUI ButtonText { get; private set; }

        [Header("Visual Settings")]
        [field: Tooltip("Color for affordable items")]
        [field: SerializeField]
        public Color AffordableColor { get; private set; } = Color.white;

        [field: Tooltip("Color for unaffordable items")]
        [field: SerializeField]
        public Color UnaffordableColor { get; private set; } = new Color(1f, 0.5f, 0.5f, 1f);

        [field: Tooltip("Color for purchased items")]
        [field: SerializeField]
        public Color PurchasedColor { get; private set; } = new Color(0.5f, 1f, 0.5f, 1f);

        [field: Tooltip("Text to show on button when purchased")]
        [field: SerializeField]
        public string PurchasedButtonText { get; private set; } = "OWNED";

        [field: Tooltip("Text to show on button when available")]
        [field: SerializeField]
        public string AvailableButtonText { get; private set; } = "BUY";

        public PlayerUpgrade Upgrade { get; private set; }
        private ShopUI _shopUI;
        private bool _isMaxed;
        private bool _canAfford;
        private int _currentCost;
        private int _currentTier;

        public void Setup(PlayerUpgrade upgrade, ShopUI shopUI)
        {
            Upgrade = upgrade;
            _shopUI = shopUI;

            if (IconImage != null && upgrade.Icon != null)
            {
                IconImage.sprite = upgrade.Icon;
            }

            if (NameText != null)
            {
                NameText.text = upgrade.DisplayName;
            }
            
            if (PurchaseButton != null)
            {
                PurchaseButton.onClick.RemoveAllListeners();
                PurchaseButton.onClick.AddListener(OnPurchaseClicked);
            }
            
            // Initial state (Tier 0)
            UpdateState(0);
        }

        public void UpdateState(int tier)
        {
            _currentTier = tier;
            _isMaxed = Upgrade != null && tier >= Upgrade.MaxTier;
            
            if (Upgrade != null)
            {
                // Calculate dynamic cost: Base * 2^Tier
                _currentCost = Upgrade.Cost * (int)Mathf.Pow(2, tier);
                
                if (CostText != null)
                {
                     CostText.text = _isMaxed ? "---" : $"${_currentCost:N0}";
                }
                
                if (EffectText != null)
                {
                    EffectText.text = GetEffectDescription(Upgrade, tier);
                }
            }
            
            UpdateButtonText();
            UpdateVisuals();
        }

        private string GetEffectDescription(PlayerUpgrade upgrade, int tier)
        {
            float baseVal = upgrade.Multiplier;
            float val = baseVal * Mathf.Pow(2, tier);
            
            switch (upgrade.Type)
            {
                case UpgradeType.ParryAccuracy:
                    return $"+{val * 100:F0}% Accuracy";
                case UpgradeType.ParryTimeWindow:
                    return $"+{val * 100:F0}% Parry Time";
                case UpgradeType.SprayPaintRadius:
                    return $"+{val * 100:F0}% Radius";
                case UpgradeType.SprayPaintCapacity:
                    return $"+{val:F0} Capacity";
                default:
                    return $"+{val * 100:F0}% Effect";
            }
        }

        public void UpdateAffordability(int currentMoney)
        {
            if (Upgrade == null)
                return;

            _canAfford = currentMoney >= _currentCost;
            UpdateVisuals();
        }

        // SetPurchasedState removed (redundant with UpdateState checks)

        private void UpdateVisuals()
        {
            if (PurchaseButton != null)
            {
                PurchaseButton.interactable = !_isMaxed && _canAfford;
            }

            Color targetColor;
            if (_isMaxed)
            {
                targetColor = PurchasedColor;
            }
            else if (_canAfford)
            {
                targetColor = AffordableColor;
            }
            else
            {
                targetColor = UnaffordableColor;
            }

            if (CostText != null)
            {
                CostText.color = targetColor;
            }
        }

        private void UpdateButtonText()
        {
            if (ButtonText != null)
            {
                if (_isMaxed)
                {
                    ButtonText.text = "MAXED";
                }
                else if (_currentTier > 0)
                {
                    ButtonText.text = $"LVL {_currentTier + 1}";
                }
                else
                {
                    ButtonText.text = AvailableButtonText;
                }
            }
        }

        private void OnPurchaseClicked()
        {
            if (_shopUI != null && Upgrade != null)
            {
                _shopUI.TryPurchaseUpgrade(Upgrade);
            }
        }
    }
}
