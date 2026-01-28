using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace HolyRail.Scripts.Shop
{
    public class ShopUI : MonoBehaviour
    {
        [Header("UI References")]
        [field: Tooltip("Panel containing the 'Press Jump to Enter Shop' prompt")]
        [field: SerializeField]
        public GameObject PromptPanel { get; private set; }

        [field: Tooltip("Panel containing the main shop UI")]
        [field: SerializeField]
        public GameObject ShopPanel { get; private set; }

        [field: Tooltip("Text displaying the player's current money")]
        [field: SerializeField]
        public TextMeshProUGUI MoneyText { get; private set; }

        [field: Tooltip("Container transform where upgrade items will be spawned")]
        [field: SerializeField]
        public Transform UpgradeContainer { get; private set; }

        [field: Tooltip("Prefab for individual upgrade items")]
        [field: SerializeField]
        public UpgradeItemUI UpgradeItemPrefab { get; private set; }

        [field: Tooltip("Exit button to close the shop")]
        [field: SerializeField]
        public Button ExitButton { get; private set; }

        [Header("Settings")]
        [field: Tooltip("Format string for money display (use {0} for value)")]
        [field: SerializeField]
        public string MoneyFormat { get; private set; } = "${0:N0}";

        private List<UpgradeItemUI> _upgradeItems = new();
        private PlayerUpgrade[] _availableUpgrades;

        private void Awake()
        {
            // Hide everything on awake
            if (PromptPanel != null)
                PromptPanel.SetActive(false);
            if (ShopPanel != null)
                ShopPanel.SetActive(false);

            // Wire up exit button immediately (canvas may start disabled)
            if (ExitButton != null)
            {
                ExitButton.onClick.AddListener(OnExitClicked);
            }
        }

        private void OnEnable()
        {
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnMoneyChanged += OnMoneyChanged;
                GameSessionManager.Instance.OnUpgradeListChanged += OnUpgradesChanged;
            }
        }

        private void OnDisable()
        {
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnMoneyChanged -= OnMoneyChanged;
                GameSessionManager.Instance.OnUpgradeListChanged -= OnUpgradesChanged;
            }
        }

        /// <summary>
        /// Shows the "Press Jump to Enter Shop" prompt.
        /// </summary>
        public void ShowPrompt()
        {
            gameObject.SetActive(true);
            if (PromptPanel != null)
                PromptPanel.SetActive(true);
            if (ShopPanel != null)
                ShopPanel.SetActive(false);
        }

        /// <summary>
        /// Hides the prompt.
        /// </summary>
        public void HidePrompt()
        {
            if (PromptPanel != null)
                PromptPanel.SetActive(false);
            
            // If shop panel is also hidden, hide the whole canvas
            if (ShopPanel == null || !ShopPanel.activeSelf)
            {
                gameObject.SetActive(false);
            }
        }

        private ShopZone _currentShopZone;

        /// <summary>
        /// Opens the main shop UI.
        /// </summary>
        /// <param name="shopZone">The ShopZone opening this UI</param>
        public void OpenShop(ShopZone shopZone)
        {
            _currentShopZone = shopZone;
            gameObject.SetActive(true);
            if (PromptPanel != null)
                PromptPanel.SetActive(false);
            if (ShopPanel != null)
                ShopPanel.SetActive(true);

            RefreshUI();
            SelectFirstUpgrade();
        }

        /// <summary>
        /// Closes the shop UI.
        /// </summary>
        public void CloseShop()
        {
            if (ShopPanel != null)
                ShopPanel.SetActive(false);
            
            // If prompt is also hidden, hide the whole canvas
            if (PromptPanel == null || !PromptPanel.activeSelf)
            {
                gameObject.SetActive(false);
            }
        }

        /// <summary>
        /// Selects the first upgrade button for UI navigation.
        /// </summary>
        private void SelectFirstUpgrade()
        {
            if (_upgradeItems.Count > 0 && _upgradeItems[0] != null)
            {
                var button = _upgradeItems[0].PurchaseButton;
                if (button != null && EventSystem.current != null)
                {
                    EventSystem.current.SetSelectedGameObject(button.gameObject);
                }
            }
            else if (ExitButton != null && EventSystem.current != null)
            {
                // If no upgrades, select exit button
                EventSystem.current.SetSelectedGameObject(ExitButton.gameObject);
            }
        }

        private void OnExitClicked()
        {
            Debug.Log("<color=cyan>[Shop UI]</color> Exit button clicked", gameObject);
            
            if (_currentShopZone != null)
            {
                _currentShopZone.CloseShop();
            }
            else if (ShopZone.Instance != null)
            {
                Debug.LogWarning("<color=yellow>[Shop UI]</color> No current ShopZone stored, falling back to Instance", gameObject);
                ShopZone.Instance.CloseShop();
            }
            else
            {
                Debug.LogWarning("<color=red>[Shop UI]</color> No ShopZone found to close!", gameObject);
                // Last resort: Close UI locally
                CloseShop();
            }
        }

        public void RefreshUI()
        {
            UpdateMoneyDisplay();
            PopulateUpgrades();
        }

        private void UpdateMoneyDisplay()
        {
            if (MoneyText == null)
                return;

            int money = GameSessionManager.Instance != null ? GameSessionManager.Instance.Money : 0;
            MoneyText.text = string.Format(MoneyFormat, money);
        }

        private void OnMoneyChanged(int newMoney)
        {
            UpdateMoneyDisplay();
            UpdateUpgradeAffordability();
        }

        private void OnUpgradesChanged(PlayerUpgrade[] upgrades)
        {
            UpdateUpgradeStates();
        }

        private void PopulateUpgrades()
        {
            // Clear existing items
            foreach (var item in _upgradeItems)
            {
                if (item != null)
                {
                    Destroy(item.gameObject);
                }
            }
            _upgradeItems.Clear();

            // Get current session inventory
            if (GameSessionManager.Instance == null)
                return;
                
            _availableUpgrades = GameSessionManager.Instance.CurrentShopInventory.ToArray();

            if (UpgradeContainer == null || UpgradeItemPrefab == null)
                return;

            // Create UI items for each upgrade
            foreach (var upgrade in _availableUpgrades)
            {
                var item = Instantiate(UpgradeItemPrefab, UpgradeContainer);
                item.Setup(upgrade, this);
                _upgradeItems.Add(item);
            }

            UpdateUpgradeAffordability();
            UpdateUpgradeStates();
        }

        private void UpdateUpgradeAffordability()
        {
            int currentMoney = GameSessionManager.Instance != null ? GameSessionManager.Instance.Money : 0;

            foreach (var item in _upgradeItems)
            {
                if (item != null)
                {
                    item.UpdateAffordability(currentMoney);
                }
            }
        }

        private void UpdateUpgradeStates()
        {
            if (GameSessionManager.Instance == null)
                return;

            foreach (var item in _upgradeItems)
            {
                if (item != null && item.Upgrade != null)
                {
                    int tier = GameSessionManager.Instance.GetUpgradeTier(item.Upgrade);
                    item.UpdateState(tier);
                }
            }
        }

        public void TryPurchaseUpgrade(PlayerUpgrade upgrade)
        {
            if (upgrade == null)
                return;

            if (GameSessionManager.Instance == null)
                return;

            // Check tier
            int currentTier = GameSessionManager.Instance.GetUpgradeTier(upgrade);
            
            // Check if maxed
            if (currentTier >= upgrade.MaxTier)
            {
                Debug.Log($"<color=yellow>[Shop]</color> Upgrade maxed out: {upgrade.DisplayName}", gameObject);
                return;
            }

            // Calculate cost (doubles every tier: 0->Base, 1->2x, 2->4x)
            int cost = upgrade.Cost * (int)Mathf.Pow(2, currentTier);

            // Check if can afford
            if (GameSessionManager.Instance.Money < cost)
            {
                Debug.Log($"<color=red>[Shop]</color> Cannot afford upgrade: {upgrade.DisplayName} (need ${cost}, have ${GameSessionManager.Instance.Money})", gameObject);
                return;
            }

            // Purchase
            if (GameSessionManager.Instance.AddUpgrade(upgrade))
            {
                GameSessionManager.Instance.Money -= cost;
                Debug.Log($"<color=green>[Shop]</color> Purchased upgrade: {upgrade.DisplayName} (Tier {currentTier + 1}) for ${cost}", gameObject);
            }
        }
    }
}
