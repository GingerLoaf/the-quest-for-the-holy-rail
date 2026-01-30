using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.UI;
using HolyRail.Scripts;
using TMPro;

namespace HolyRail.Scripts.Editor
{
    public static class PauseMenuSetup
    {
        [MenuItem("GameObject/UI/Holy Rail/Pause Menu", false, 10)]
        public static void CreatePauseMenu()
        {
            // Find or create canvas
            var canvas = Object.FindFirstObjectByType<Canvas>();
            if (canvas == null)
            {
                var canvasGo = new GameObject("Canvas");
                canvas = canvasGo.AddComponent<Canvas>();
                canvas.renderMode = RenderMode.ScreenSpaceOverlay;
                canvasGo.AddComponent<CanvasScaler>();
                canvasGo.AddComponent<GraphicRaycaster>();
            }

            // Ensure EventSystem exists
            if (Object.FindFirstObjectByType<EventSystem>() == null)
            {
                var eventSystem = new GameObject("EventSystem");
                eventSystem.AddComponent<EventSystem>();
                eventSystem.AddComponent<UnityEngine.InputSystem.UI.InputSystemUIInputModule>();
            }

            // Create pause menu root
            var pauseMenu = new GameObject("PauseMenu");
            pauseMenu.transform.SetParent(canvas.transform, false);
            var pauseManager = pauseMenu.AddComponent<PauseMenuManager>();

            // Create panel (dark overlay)
            var panel = new GameObject("PausePanel");
            panel.transform.SetParent(pauseMenu.transform, false);
            var panelRect = panel.AddComponent<RectTransform>();
            panelRect.anchorMin = Vector2.zero;
            panelRect.anchorMax = Vector2.one;
            panelRect.offsetMin = Vector2.zero;
            panelRect.offsetMax = Vector2.zero;
            var panelImage = panel.AddComponent<Image>();
            panelImage.color = new Color(0f, 0f, 0f, 0.8f);

            // Create center container
            var container = new GameObject("Container");
            container.transform.SetParent(panel.transform, false);
            var containerRect = container.AddComponent<RectTransform>();
            containerRect.anchorMin = new Vector2(0.5f, 0.5f);
            containerRect.anchorMax = new Vector2(0.5f, 0.5f);
            containerRect.sizeDelta = new Vector2(400f, 300f);
            var containerImage = container.AddComponent<Image>();
            containerImage.color = new Color(0.15f, 0.15f, 0.15f, 1f);

            var containerLayout = container.AddComponent<VerticalLayoutGroup>();
            containerLayout.padding = new RectOffset(40, 40, 40, 40);
            containerLayout.spacing = 30f;
            containerLayout.childAlignment = TextAnchor.MiddleCenter;
            containerLayout.childControlWidth = true;
            containerLayout.childControlHeight = false;
            containerLayout.childForceExpandWidth = true;
            containerLayout.childForceExpandHeight = false;

            // Title
            var title = new GameObject("Title");
            title.transform.SetParent(container.transform, false);
            var titleRect = title.AddComponent<RectTransform>();
            titleRect.sizeDelta = new Vector2(0f, 60f);
            var titleText = title.AddComponent<TextMeshProUGUI>();
            titleText.text = "PAUSED";
            titleText.fontSize = 48f;
            titleText.alignment = TextAlignmentOptions.Center;
            titleText.fontStyle = FontStyles.Bold;

            // Volume section
            var volumeSection = new GameObject("VolumeSection");
            volumeSection.transform.SetParent(container.transform, false);
            var volumeRect = volumeSection.AddComponent<RectTransform>();
            volumeRect.sizeDelta = new Vector2(0f, 50f);
            var volumeLayout = volumeSection.AddComponent<HorizontalLayoutGroup>();
            volumeLayout.spacing = 15f;
            volumeLayout.childAlignment = TextAnchor.MiddleCenter;
            volumeLayout.childControlWidth = false;
            volumeLayout.childControlHeight = true;
            volumeLayout.childForceExpandWidth = false;
            volumeLayout.childForceExpandHeight = true;

            // Volume label
            var volumeLabel = new GameObject("VolumeLabel");
            volumeLabel.transform.SetParent(volumeSection.transform, false);
            var labelRect = volumeLabel.AddComponent<RectTransform>();
            labelRect.sizeDelta = new Vector2(80f, 0f);
            var labelText = volumeLabel.AddComponent<TextMeshProUGUI>();
            labelText.text = "Volume";
            labelText.fontSize = 24f;
            labelText.alignment = TextAlignmentOptions.MidlineRight;
            var labelLayout = volumeLabel.AddComponent<LayoutElement>();
            labelLayout.preferredWidth = 80f;

            // Volume slider
            var sliderGo = CreateSlider("VolumeSlider", volumeSection.transform);
            var sliderLayout = sliderGo.AddComponent<LayoutElement>();
            sliderLayout.preferredWidth = 200f;
            sliderLayout.preferredHeight = 30f;
            var slider = sliderGo.GetComponent<Slider>();

            // Exit button
            var exitButton = CreateButton("ExitButton", "EXIT", container.transform);
            var exitRect = exitButton.GetComponent<RectTransform>();
            exitRect.sizeDelta = new Vector2(0f, 50f);
            var button = exitButton.GetComponent<Button>();

            // --- Keyboard Controls (top-left) ---
            var keyboardPanel = new GameObject("KeyboardControls");
            keyboardPanel.transform.SetParent(panel.transform, false);
            var kbPanelRect = keyboardPanel.AddComponent<RectTransform>();
            kbPanelRect.anchorMin = new Vector2(0f, 1f);
            kbPanelRect.anchorMax = new Vector2(0f, 1f);
            kbPanelRect.pivot = new Vector2(0f, 1f);
            kbPanelRect.anchoredPosition = new Vector2(40f, -30f);
            kbPanelRect.sizeDelta = new Vector2(320f, 300f);

            var kbBgImage = keyboardPanel.AddComponent<Image>();
            kbBgImage.color = new Color(0.1f, 0.1f, 0.1f, 0.7f);

            var kbHeaderGo = new GameObject("Header");
            kbHeaderGo.transform.SetParent(keyboardPanel.transform, false);
            var kbHeaderRect = kbHeaderGo.AddComponent<RectTransform>();
            kbHeaderRect.anchorMin = new Vector2(0f, 1f);
            kbHeaderRect.anchorMax = new Vector2(1f, 1f);
            kbHeaderRect.pivot = new Vector2(0.5f, 1f);
            kbHeaderRect.anchoredPosition = new Vector2(0f, -10f);
            kbHeaderRect.sizeDelta = new Vector2(0f, 35f);
            var kbHeaderText = kbHeaderGo.AddComponent<TextMeshProUGUI>();
            kbHeaderText.text = "KEYBOARD + MOUSE";
            kbHeaderText.fontSize = 22f;
            kbHeaderText.fontStyle = FontStyles.Bold;
            kbHeaderText.alignment = TextAlignmentOptions.Center;
            kbHeaderText.color = new Color(0.8f, 0.2f, 0.8f, 1f);

            var kbControlsGo = new GameObject("Controls");
            kbControlsGo.transform.SetParent(keyboardPanel.transform, false);
            var kbControlsRect = kbControlsGo.AddComponent<RectTransform>();
            kbControlsRect.anchorMin = new Vector2(0f, 0f);
            kbControlsRect.anchorMax = new Vector2(1f, 1f);
            kbControlsRect.offsetMin = new Vector2(20f, 15f);
            kbControlsRect.offsetMax = new Vector2(-20f, -50f);
            var kbControlsText = kbControlsGo.AddComponent<TextMeshProUGUI>();
            kbControlsText.text =
                "WASD          Move\n" +
                "Mouse         Look\n" +
                "Space         Jump\n" +
                "L-Shift       Sprint\n" +
                "L-Click       Spray Paint\n" +
                "R-Click       Parry\n" +
                "Escape        Pause";
            kbControlsText.fontSize = 18f;
            kbControlsText.alignment = TextAlignmentOptions.TopLeft;
            kbControlsText.lineSpacing = 12f;
            kbControlsText.color = new Color(0.85f, 0.85f, 0.85f, 1f);
            kbControlsText.textWrappingMode = TextWrappingModes.Normal;

            // --- Gamepad Controls (top-right) ---
            var gamepadPanel = new GameObject("GamepadControls");
            gamepadPanel.transform.SetParent(panel.transform, false);
            var gpPanelRect = gamepadPanel.AddComponent<RectTransform>();
            gpPanelRect.anchorMin = new Vector2(1f, 1f);
            gpPanelRect.anchorMax = new Vector2(1f, 1f);
            gpPanelRect.pivot = new Vector2(1f, 1f);
            gpPanelRect.anchoredPosition = new Vector2(-40f, -30f);
            gpPanelRect.sizeDelta = new Vector2(320f, 300f);

            var gpBgImage = gamepadPanel.AddComponent<Image>();
            gpBgImage.color = new Color(0.1f, 0.1f, 0.1f, 0.7f);

            var gpHeaderGo = new GameObject("Header");
            gpHeaderGo.transform.SetParent(gamepadPanel.transform, false);
            var gpHeaderRect = gpHeaderGo.AddComponent<RectTransform>();
            gpHeaderRect.anchorMin = new Vector2(0f, 1f);
            gpHeaderRect.anchorMax = new Vector2(1f, 1f);
            gpHeaderRect.pivot = new Vector2(0.5f, 1f);
            gpHeaderRect.anchoredPosition = new Vector2(0f, -10f);
            gpHeaderRect.sizeDelta = new Vector2(0f, 35f);
            var gpHeaderText = gpHeaderGo.AddComponent<TextMeshProUGUI>();
            gpHeaderText.text = "GAMEPAD";
            gpHeaderText.fontSize = 22f;
            gpHeaderText.fontStyle = FontStyles.Bold;
            gpHeaderText.alignment = TextAlignmentOptions.Center;
            gpHeaderText.color = new Color(0.8f, 0.2f, 0.8f, 1f);

            var gpControlsGo = new GameObject("Controls");
            gpControlsGo.transform.SetParent(gamepadPanel.transform, false);
            var gpControlsRect = gpControlsGo.AddComponent<RectTransform>();
            gpControlsRect.anchorMin = new Vector2(0f, 0f);
            gpControlsRect.anchorMax = new Vector2(1f, 1f);
            gpControlsRect.offsetMin = new Vector2(20f, 15f);
            gpControlsRect.offsetMax = new Vector2(-20f, -50f);
            var gpControlsText = gpControlsGo.AddComponent<TextMeshProUGUI>();
            gpControlsText.text =
                "L-Stick       Move\n" +
                "R-Stick       Look\n" +
                "South (A)     Jump\n" +
                "L-Trigger     Sprint\n" +
                "R-Trigger     Spray Paint\n" +
                "North (Y)     Parry\n" +
                "Start         Pause";
            gpControlsText.fontSize = 18f;
            gpControlsText.alignment = TextAlignmentOptions.TopLeft;
            gpControlsText.lineSpacing = 12f;
            gpControlsText.color = new Color(0.85f, 0.85f, 0.85f, 1f);
            gpControlsText.textWrappingMode = TextWrappingModes.NoWrap;

            // Wire up references
            var serializedObject = new SerializedObject(pauseManager);
            serializedObject.FindProperty("<PausePanel>k__BackingField").objectReferenceValue = panel;
            serializedObject.FindProperty("<VolumeSlider>k__BackingField").objectReferenceValue = slider;
            serializedObject.FindProperty("<ExitButton>k__BackingField").objectReferenceValue = button;
            serializedObject.FindProperty("<KeyboardControlsText>k__BackingField").objectReferenceValue = kbControlsText;
            serializedObject.FindProperty("<GamepadControlsText>k__BackingField").objectReferenceValue = gpControlsText;

            // Try to find and assign the Pause action
            var inputActions = AssetDatabase.LoadAssetAtPath<InputActionAsset>("Assets/StarterAssets/InputSystem/StarterAssets.inputactions");
            if (inputActions != null)
            {
                var playerMap = inputActions.FindActionMap("Player");
                if (playerMap != null)
                {
                    var pauseAction = playerMap.FindAction("Pause");
                    if (pauseAction != null)
                    {
                        var actionRef = InputActionReference.Create(pauseAction);
                        serializedObject.FindProperty("<PauseAction>k__BackingField").objectReferenceValue = actionRef;
                    }
                }
            }

            serializedObject.ApplyModifiedProperties();

            // Select the created object
            Selection.activeGameObject = pauseMenu;
            Undo.RegisterCreatedObjectUndo(pauseMenu, "Create Pause Menu");

            Debug.Log("<color=green>[Pause Menu]</color> Created pause menu. Make sure to assign the Pause Action if it wasn't auto-assigned.");
        }

        private static GameObject CreateSlider(string name, Transform parent)
        {
            var sliderGo = new GameObject(name);
            sliderGo.transform.SetParent(parent, false);
            var sliderRect = sliderGo.AddComponent<RectTransform>();
            sliderRect.sizeDelta = new Vector2(200f, 30f);

            var slider = sliderGo.AddComponent<Slider>();
            slider.minValue = 0f;
            slider.maxValue = 1f;
            slider.value = 1f;

            // Background
            var background = new GameObject("Background");
            background.transform.SetParent(sliderGo.transform, false);
            var bgRect = background.AddComponent<RectTransform>();
            bgRect.anchorMin = new Vector2(0f, 0.25f);
            bgRect.anchorMax = new Vector2(1f, 0.75f);
            bgRect.offsetMin = Vector2.zero;
            bgRect.offsetMax = Vector2.zero;
            var bgImage = background.AddComponent<Image>();
            bgImage.color = new Color(0.3f, 0.3f, 0.3f, 1f);

            // Fill Area
            var fillArea = new GameObject("Fill Area");
            fillArea.transform.SetParent(sliderGo.transform, false);
            var fillAreaRect = fillArea.AddComponent<RectTransform>();
            fillAreaRect.anchorMin = new Vector2(0f, 0.25f);
            fillAreaRect.anchorMax = new Vector2(1f, 0.75f);
            fillAreaRect.offsetMin = new Vector2(5f, 0f);
            fillAreaRect.offsetMax = new Vector2(-5f, 0f);

            // Fill
            var fill = new GameObject("Fill");
            fill.transform.SetParent(fillArea.transform, false);
            var fillRect = fill.AddComponent<RectTransform>();
            fillRect.anchorMin = Vector2.zero;
            fillRect.anchorMax = Vector2.one;
            fillRect.offsetMin = Vector2.zero;
            fillRect.offsetMax = Vector2.zero;
            var fillImage = fill.AddComponent<Image>();
            fillImage.color = new Color(0.8f, 0.2f, 0.8f, 1f);

            // Handle Slide Area
            var handleArea = new GameObject("Handle Slide Area");
            handleArea.transform.SetParent(sliderGo.transform, false);
            var handleAreaRect = handleArea.AddComponent<RectTransform>();
            handleAreaRect.anchorMin = Vector2.zero;
            handleAreaRect.anchorMax = Vector2.one;
            handleAreaRect.offsetMin = new Vector2(10f, 0f);
            handleAreaRect.offsetMax = new Vector2(-10f, 0f);

            // Handle
            var handle = new GameObject("Handle");
            handle.transform.SetParent(handleArea.transform, false);
            var handleRect = handle.AddComponent<RectTransform>();
            handleRect.sizeDelta = new Vector2(20f, 0f);
            var handleImage = handle.AddComponent<Image>();
            handleImage.color = Color.white;

            slider.fillRect = fillRect;
            slider.handleRect = handleRect;
            slider.targetGraphic = handleImage;

            return sliderGo;
        }

        private static GameObject CreateButton(string name, string text, Transform parent)
        {
            var buttonGo = new GameObject(name);
            buttonGo.transform.SetParent(parent, false);
            var buttonRect = buttonGo.AddComponent<RectTransform>();
            buttonRect.sizeDelta = new Vector2(160f, 50f);

            var buttonImage = buttonGo.AddComponent<Image>();
            buttonImage.color = new Color(0.8f, 0.2f, 0.2f, 1f);

            var button = buttonGo.AddComponent<Button>();
            button.targetGraphic = buttonImage;

            var colors = button.colors;
            colors.normalColor = new Color(0.8f, 0.2f, 0.2f, 1f);
            colors.highlightedColor = new Color(1f, 0.3f, 0.3f, 1f);
            colors.pressedColor = new Color(0.6f, 0.1f, 0.1f, 1f);
            colors.selectedColor = new Color(1f, 0.3f, 0.3f, 1f);
            button.colors = colors;

            var textGo = new GameObject("Text");
            textGo.transform.SetParent(buttonGo.transform, false);
            var textRect = textGo.AddComponent<RectTransform>();
            textRect.anchorMin = Vector2.zero;
            textRect.anchorMax = Vector2.one;
            textRect.offsetMin = Vector2.zero;
            textRect.offsetMax = Vector2.zero;

            var tmpText = textGo.AddComponent<TextMeshProUGUI>();
            tmpText.text = text;
            tmpText.fontSize = 24f;
            tmpText.alignment = TextAlignmentOptions.Center;
            tmpText.fontStyle = FontStyles.Bold;

            return buttonGo;
        }
    }
}
