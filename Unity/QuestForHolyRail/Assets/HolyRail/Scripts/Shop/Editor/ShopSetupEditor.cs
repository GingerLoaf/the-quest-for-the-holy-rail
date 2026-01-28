#if UNITY_EDITOR
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;
using TMPro;

namespace HolyRail.Scripts.Shop.Editor
{
    public static class ShopSetupEditor
    {
        [MenuItem("Holy Rail/Create Shop Zone")]
        public static void CreateShopZone()
        {
            // Create main shop zone object
            var shopZoneObj = new GameObject("ShopZone");
            var shopZone = shopZoneObj.AddComponent<ShopZone>();

            // Create outer volume
            var outerVolumeObj = new GameObject("OuterVolume");
            outerVolumeObj.transform.SetParent(shopZoneObj.transform);
            outerVolumeObj.transform.localPosition = Vector3.zero;
            var outerCollider = outerVolumeObj.AddComponent<BoxCollider>();
            outerCollider.isTrigger = true;
            outerCollider.size = new Vector3(30f, 20f, 50f);
            var outerTrigger = outerVolumeObj.AddComponent<ShopVolumeTrigger>();
            SetPrivateField(outerTrigger, "<VolumeType>k__BackingField", ShopVolumeType.Outer);
            SetPrivateField(outerTrigger, "<ShopZone>k__BackingField", shopZone);

            // Create inner volume
            var innerVolumeObj = new GameObject("InnerVolume");
            innerVolumeObj.transform.SetParent(shopZoneObj.transform);
            innerVolumeObj.transform.localPosition = Vector3.zero;
            var innerCollider = innerVolumeObj.AddComponent<BoxCollider>();
            innerCollider.isTrigger = true;
            innerCollider.size = new Vector3(15f, 10f, 20f);
            var innerTrigger = innerVolumeObj.AddComponent<ShopVolumeTrigger>();
            SetPrivateField(innerTrigger, "<VolumeType>k__BackingField", ShopVolumeType.Inner);
            SetPrivateField(innerTrigger, "<ShopZone>k__BackingField", shopZone);

            // Set references on ShopZone
            SetPrivateField(shopZone, "<OuterVolume>k__BackingField", outerCollider);
            SetPrivateField(shopZone, "<InnerVolume>k__BackingField", innerCollider);

            Selection.activeGameObject = shopZoneObj;
            Debug.Log("Created ShopZone. Don't forget to create and assign the ShopUI canvas!");
        }

        [MenuItem("Holy Rail/Create Shop UI Canvas")]
        public static void CreateShopUICanvas()
        {
            // Create canvas
            var canvasObj = new GameObject("ShopUI_Canvas");
            var canvas = canvasObj.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            canvas.sortingOrder = 100;
            canvasObj.AddComponent<CanvasScaler>();
            canvasObj.AddComponent<GraphicRaycaster>();

            var shopUI = canvasObj.AddComponent<ShopUI>();

            // ========== PROMPT PANEL ==========
            var promptPanel = new GameObject("PromptPanel");
            promptPanel.transform.SetParent(canvasObj.transform);
            var promptRect = promptPanel.AddComponent<RectTransform>();
            promptRect.anchorMin = Vector2.zero;
            promptRect.anchorMax = Vector2.one;
            promptRect.offsetMin = Vector2.zero;
            promptRect.offsetMax = Vector2.zero;

            // Prompt background
            var promptBg = promptPanel.AddComponent<Image>();
            promptBg.color = new Color(0f, 0f, 0f, 0.5f);

            // Prompt text
            var promptText = CreateUIElement<TextMeshProUGUI>("PromptText", promptPanel.transform);
            promptText.text = "PRESS JUMP TO ENTER SHOP";
            promptText.fontSize = 48;
            promptText.alignment = TextAlignmentOptions.Center;
            promptText.fontStyle = FontStyles.Bold;
            var promptTextRect = promptText.GetComponent<RectTransform>();
            promptTextRect.anchorMin = new Vector2(0.5f, 0.5f);
            promptTextRect.anchorMax = new Vector2(0.5f, 0.5f);
            promptTextRect.pivot = new Vector2(0.5f, 0.5f);
            promptTextRect.anchoredPosition = Vector2.zero;
            promptTextRect.sizeDelta = new Vector2(800f, 100f);

            // ========== SHOP PANEL ==========
            var shopPanel = new GameObject("ShopPanel");
            shopPanel.transform.SetParent(canvasObj.transform);
            var shopPanelRect = shopPanel.AddComponent<RectTransform>();
            shopPanelRect.anchorMin = Vector2.zero;
            shopPanelRect.anchorMax = Vector2.one;
            shopPanelRect.offsetMin = Vector2.zero;
            shopPanelRect.offsetMax = Vector2.zero;

            // Shop background
            var shopBg = shopPanel.AddComponent<Image>();
            shopBg.color = new Color(0f, 0f, 0f, 0.85f);

            // Title
            var titleText = CreateUIElement<TextMeshProUGUI>("Title", shopPanel.transform);
            titleText.text = "SHOP";
            titleText.fontSize = 72;
            titleText.alignment = TextAlignmentOptions.Center;
            titleText.fontStyle = FontStyles.Bold;
            var titleRect = titleText.GetComponent<RectTransform>();
            titleRect.anchorMin = new Vector2(0.5f, 1f);
            titleRect.anchorMax = new Vector2(0.5f, 1f);
            titleRect.pivot = new Vector2(0.5f, 1f);
            titleRect.anchoredPosition = new Vector2(0f, -30f);
            titleRect.sizeDelta = new Vector2(400f, 80f);

            // Money display
            var moneyText = CreateUIElement<TextMeshProUGUI>("MoneyText", shopPanel.transform);
            moneyText.text = "$0";
            moneyText.fontSize = 48;
            moneyText.alignment = TextAlignmentOptions.Center;
            moneyText.color = Color.yellow;
            var moneyRect = moneyText.GetComponent<RectTransform>();
            moneyRect.anchorMin = new Vector2(0.5f, 1f);
            moneyRect.anchorMax = new Vector2(0.5f, 1f);
            moneyRect.pivot = new Vector2(0.5f, 1f);
            moneyRect.anchoredPosition = new Vector2(0f, -120f);
            moneyRect.sizeDelta = new Vector2(300f, 60f);

            // Upgrade container with vertical layout
            var containerObj = new GameObject("UpgradeContainer");
            containerObj.transform.SetParent(shopPanel.transform);
            var containerRect = containerObj.AddComponent<RectTransform>();
            containerRect.anchorMin = new Vector2(0.5f, 0.5f);
            containerRect.anchorMax = new Vector2(0.5f, 0.5f);
            containerRect.pivot = new Vector2(0.5f, 0.5f);
            containerRect.anchoredPosition = new Vector2(0f, -20f);
            containerRect.sizeDelta = new Vector2(600f, 350f);
            var verticalLayout = containerObj.AddComponent<VerticalLayoutGroup>();
            verticalLayout.spacing = 15f;
            verticalLayout.childAlignment = TextAnchor.UpperCenter;
            verticalLayout.childControlWidth = true;
            verticalLayout.childControlHeight = false;
            verticalLayout.childForceExpandWidth = true;
            verticalLayout.childForceExpandHeight = false;

            // Exit button
            var exitBtnObj = new GameObject("ExitButton");
            exitBtnObj.transform.SetParent(shopPanel.transform);
            var exitBtnRect = exitBtnObj.AddComponent<RectTransform>();
            exitBtnRect.anchorMin = new Vector2(0.5f, 0f);
            exitBtnRect.anchorMax = new Vector2(0.5f, 0f);
            exitBtnRect.pivot = new Vector2(0.5f, 0f);
            exitBtnRect.anchoredPosition = new Vector2(0f, 40f);
            exitBtnRect.sizeDelta = new Vector2(200f, 60f);
            var exitBtnImage = exitBtnObj.AddComponent<Image>();
            exitBtnImage.color = new Color(0.6f, 0.2f, 0.2f, 1f);
            var exitBtn = exitBtnObj.AddComponent<Button>();
            exitBtn.targetGraphic = exitBtnImage;
            var exitBtnColors = exitBtn.colors;
            exitBtnColors.highlightedColor = new Color(0.8f, 0.3f, 0.3f, 1f);
            exitBtnColors.pressedColor = new Color(0.5f, 0.15f, 0.15f, 1f);
            exitBtn.colors = exitBtnColors;

            // Exit button text
            var exitBtnText = CreateUIElement<TextMeshProUGUI>("Text", exitBtnObj.transform);
            exitBtnText.text = "EXIT SHOP";
            exitBtnText.fontSize = 28;
            exitBtnText.fontStyle = FontStyles.Bold;
            exitBtnText.alignment = TextAlignmentOptions.Center;
            var exitBtnTextRect = exitBtnText.GetComponent<RectTransform>();
            exitBtnTextRect.anchorMin = Vector2.zero;
            exitBtnTextRect.anchorMax = Vector2.one;
            exitBtnTextRect.offsetMin = Vector2.zero;
            exitBtnTextRect.offsetMax = Vector2.zero;

            // Set ShopUI references
            SetPrivateField(shopUI, "<PromptPanel>k__BackingField", promptPanel);
            SetPrivateField(shopUI, "<ShopPanel>k__BackingField", shopPanel);
            SetPrivateField(shopUI, "<MoneyText>k__BackingField", moneyText);
            SetPrivateField(shopUI, "<UpgradeContainer>k__BackingField", containerRect);
            SetPrivateField(shopUI, "<ExitButton>k__BackingField", exitBtn);

            // Deactivate panels initially
            promptPanel.SetActive(false);
            shopPanel.SetActive(false);

            // Ensure EventSystem exists
            if (Object.FindFirstObjectByType<UnityEngine.EventSystems.EventSystem>() == null)
            {
                var eventSystemObj = new GameObject("EventSystem");
                eventSystemObj.AddComponent<UnityEngine.EventSystems.EventSystem>();
#if ENABLE_INPUT_SYSTEM
                eventSystemObj.AddComponent<UnityEngine.InputSystem.UI.InputSystemUIInputModule>();
#else
                eventSystemObj.AddComponent<UnityEngine.EventSystems.StandaloneInputModule>();
#endif
                Debug.Log("Created EventSystem (required for UI interaction)");
            }

            Selection.activeGameObject = canvasObj;
            Debug.Log("Created ShopUI Canvas with Prompt and Shop panels. Don't forget to create the UpgradeItemUI prefab and assign it!");
        }

        [MenuItem("Holy Rail/Create Upgrade Item Prefab")]
        public static void CreateUpgradeItemPrefab()
        {
            // Create upgrade item container
            var itemObj = new GameObject("UpgradeItem");
            var itemRect = itemObj.AddComponent<RectTransform>();
            itemRect.sizeDelta = new Vector2(550f, 100f);

            var layoutElement = itemObj.AddComponent<LayoutElement>();
            layoutElement.preferredHeight = 100f;

            // Background
            var bgImage = itemObj.AddComponent<Image>();
            bgImage.color = new Color(0.2f, 0.2f, 0.2f, 0.9f);

            var upgradeItemUI = itemObj.AddComponent<UpgradeItemUI>();

            // Horizontal layout
            var horizontalLayout = itemObj.AddComponent<HorizontalLayoutGroup>();
            horizontalLayout.spacing = 15f;
            horizontalLayout.padding = new RectOffset(15, 15, 10, 10);
            horizontalLayout.childAlignment = TextAnchor.MiddleLeft;
            horizontalLayout.childControlWidth = false;
            horizontalLayout.childControlHeight = false;
            horizontalLayout.childForceExpandWidth = false;
            horizontalLayout.childForceExpandHeight = false;

            // Icon
            var iconObj = new GameObject("Icon");
            iconObj.transform.SetParent(itemObj.transform);
            var iconRect = iconObj.AddComponent<RectTransform>();
            iconRect.sizeDelta = new Vector2(80f, 80f);
            var iconImage = iconObj.AddComponent<Image>();
            iconImage.color = Color.white;

            // Text container
            var textContainer = new GameObject("TextContainer");
            textContainer.transform.SetParent(itemObj.transform);
            var textContainerRect = textContainer.AddComponent<RectTransform>();
            textContainerRect.sizeDelta = new Vector2(280f, 80f);
            var textVertLayout = textContainer.AddComponent<VerticalLayoutGroup>();
            textVertLayout.childAlignment = TextAnchor.MiddleLeft;
            textVertLayout.childControlWidth = true;
            textVertLayout.childControlHeight = true;
            textVertLayout.childForceExpandWidth = true;
            textVertLayout.childForceExpandHeight = true;

            // Name text
            var nameText = CreateUIElement<TextMeshProUGUI>("NameText", textContainer.transform);
            nameText.text = "Upgrade Name";
            nameText.fontSize = 28;
            nameText.fontStyle = FontStyles.Bold;
            nameText.alignment = TextAlignmentOptions.Left;

            // Effect text
            var effectText = CreateUIElement<TextMeshProUGUI>("EffectText", textContainer.transform);
            effectText.text = "+10% Speed";
            effectText.fontSize = 20;
            effectText.color = new Color(0.8f, 0.8f, 0.8f, 1f);
            effectText.alignment = TextAlignmentOptions.Left;

            // Cost text
            var costText = CreateUIElement<TextMeshProUGUI>("CostText", itemObj.transform);
            costText.text = "$100";
            costText.fontSize = 32;
            costText.fontStyle = FontStyles.Bold;
            costText.color = Color.yellow;
            costText.alignment = TextAlignmentOptions.Center;
            var costRect = costText.GetComponent<RectTransform>();
            costRect.sizeDelta = new Vector2(80f, 40f);

            // Purchase button
            var buttonObj = new GameObject("PurchaseButton");
            buttonObj.transform.SetParent(itemObj.transform);
            var buttonRect = buttonObj.AddComponent<RectTransform>();
            buttonRect.sizeDelta = new Vector2(80f, 50f);
            var buttonImage = buttonObj.AddComponent<Image>();
            buttonImage.color = new Color(0.2f, 0.6f, 0.2f, 1f);
            var button = buttonObj.AddComponent<Button>();
            button.targetGraphic = buttonImage;
            var buttonColors = button.colors;
            buttonColors.highlightedColor = new Color(0.3f, 0.8f, 0.3f, 1f);
            buttonColors.pressedColor = new Color(0.15f, 0.5f, 0.15f, 1f);
            buttonColors.disabledColor = new Color(0.3f, 0.3f, 0.3f, 1f);
            button.colors = buttonColors;

            // Button text
            var buttonText = CreateUIElement<TextMeshProUGUI>("Text", buttonObj.transform);
            buttonText.text = "BUY";
            buttonText.fontSize = 24;
            buttonText.fontStyle = FontStyles.Bold;
            buttonText.alignment = TextAlignmentOptions.Center;
            var btnTextRect = buttonText.GetComponent<RectTransform>();
            btnTextRect.anchorMin = Vector2.zero;
            btnTextRect.anchorMax = Vector2.one;
            btnTextRect.offsetMin = Vector2.zero;
            btnTextRect.offsetMax = Vector2.zero;

            // Set UpgradeItemUI references
            SetPrivateField(upgradeItemUI, "<IconImage>k__BackingField", iconImage);
            SetPrivateField(upgradeItemUI, "<NameText>k__BackingField", nameText);
            SetPrivateField(upgradeItemUI, "<CostText>k__BackingField", costText);
            SetPrivateField(upgradeItemUI, "<EffectText>k__BackingField", effectText);
            SetPrivateField(upgradeItemUI, "<PurchaseButton>k__BackingField", button);
            SetPrivateField(upgradeItemUI, "<ButtonText>k__BackingField", buttonText);

            // Save as prefab
            string prefabPath = "Assets/HolyRail/Prefabs/UI/UpgradeItem.prefab";

            // Create directory if it doesn't exist
            if (!AssetDatabase.IsValidFolder("Assets/HolyRail/Prefabs/UI"))
            {
                AssetDatabase.CreateFolder("Assets/HolyRail/Prefabs", "UI");
            }

            PrefabUtility.SaveAsPrefabAsset(itemObj, prefabPath);
            Object.DestroyImmediate(itemObj);

            Debug.Log($"Created UpgradeItem prefab at {prefabPath}");

            // Select the created prefab
            Selection.activeObject = AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        }

        private static T CreateUIElement<T>(string name, Transform parent) where T : Component
        {
            var obj = new GameObject(name);
            obj.transform.SetParent(parent);
            var rect = obj.AddComponent<RectTransform>();
            rect.localScale = Vector3.one;
            return obj.AddComponent<T>();
        }

        private static void SetPrivateField(object obj, string fieldName, object value)
        {
            var field = obj.GetType().GetField(fieldName,
                System.Reflection.BindingFlags.NonPublic |
                System.Reflection.BindingFlags.Instance);
            if (field != null)
            {
                field.SetValue(obj, value);
                EditorUtility.SetDirty(obj as Object);
            }
        }
    }
}
#endif
