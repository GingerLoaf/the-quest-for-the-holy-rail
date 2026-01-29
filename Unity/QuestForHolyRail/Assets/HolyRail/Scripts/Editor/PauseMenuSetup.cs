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

            // Wire up references
            var serializedObject = new SerializedObject(pauseManager);
            serializedObject.FindProperty("<PausePanel>k__BackingField").objectReferenceValue = panel;
            serializedObject.FindProperty("<VolumeSlider>k__BackingField").objectReferenceValue = slider;
            serializedObject.FindProperty("<ExitButton>k__BackingField").objectReferenceValue = button;

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
