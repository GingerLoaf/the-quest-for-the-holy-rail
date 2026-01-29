using UnityEngine;
using UnityEngine.UI;

namespace HolyRail.Graffiti
{
    public class GraffitiProgressUI : MonoBehaviour
    {
        [field: SerializeField] public Image FillImage { get; private set; }
        [field: SerializeField] public CanvasGroup CanvasGroup { get; private set; }
        [field: SerializeField] public float FadeSpeed { get; private set; } = 5f;

        private Camera _mainCamera;
        private float _targetAlpha;

        private void Awake()
        {
            _mainCamera = Camera.main;
            if (CanvasGroup != null)
            {
                CanvasGroup.alpha = 0f;
            }
            _targetAlpha = 0f;
        }

        private void LateUpdate()
        {
            if (_mainCamera != null)
            {
                transform.LookAt(transform.position + _mainCamera.transform.forward);
            }

            if (CanvasGroup != null)
            {
                CanvasGroup.alpha = Mathf.MoveTowards(CanvasGroup.alpha, _targetAlpha, FadeSpeed * Time.deltaTime);
            }
        }

        public void SetProgress(float progress)
        {
            if (FillImage != null)
            {
                FillImage.fillAmount = Mathf.Clamp01(progress);
            }
        }

        public void Show()
        {
            _targetAlpha = 1f;
        }

        public void Hide()
        {
            _targetAlpha = 0f;
        }

        public void ResetProgress()
        {
            SetProgress(0f);
        }
    }
}
