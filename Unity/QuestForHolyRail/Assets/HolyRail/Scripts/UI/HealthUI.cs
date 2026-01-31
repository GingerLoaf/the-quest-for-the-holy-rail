using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using HolyRail.Scripts;

namespace HolyRail.UI
{
    public class HealthUI : MonoBehaviour
    {
        [field: SerializeField] public Image[] HealthSlots { get; private set; }
        [field: SerializeField] public Color FilledColor { get; private set; } = Color.red;
        [field: SerializeField] public Color EmptyColor { get; private set; } = new Color(0.2f, 0.2f, 0.2f, 0.5f);

        [Header("Flash Effect")]
        [SerializeField] private Color _flashColor = Color.white;
        [SerializeField] private float _flashDuration = 0.3f;

        private int _previousHealth;
        private Coroutine _flashCoroutine;

        private void Start()
        {
            if (GameSessionManager.Instance != null)
            {
                _previousHealth = GameSessionManager.Instance.CurrentHealth;
                GameSessionManager.Instance.OnHealthChanged += OnHealthChanged;
                UpdateHealthDisplay(_previousHealth);
            }
        }

        private void OnDestroy()
        {
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnHealthChanged -= OnHealthChanged;
            }
        }

        private void OnHealthChanged(int currentHealth)
        {
            // Flash if we took damage
            if (currentHealth < _previousHealth)
            {
                if (_flashCoroutine != null)
                {
                    StopCoroutine(_flashCoroutine);
                }
                _flashCoroutine = StartCoroutine(FlashHealthBar());
            }

            _previousHealth = currentHealth;
            UpdateHealthDisplay(currentHealth);
        }

        private void UpdateHealthDisplay(int currentHealth)
        {
            for (int i = 0; i < HealthSlots.Length; i++)
            {
                if (HealthSlots[i] != null)
                {
                    HealthSlots[i].color = i < currentHealth ? FilledColor : EmptyColor;
                }
            }
        }

        private IEnumerator FlashHealthBar()
        {
            // Flash all slots to flash color
            foreach (var slot in HealthSlots)
            {
                if (slot != null)
                {
                    slot.color = _flashColor;
                }
            }

            // Wait for flash duration (use unscaled time in case game is paused)
            float elapsed = 0f;
            while (elapsed < _flashDuration)
            {
                elapsed += Time.unscaledDeltaTime;
                yield return null;
            }

            // Restore proper colors
            if (GameSessionManager.Instance != null)
            {
                UpdateHealthDisplay(GameSessionManager.Instance.CurrentHealth);
            }

            _flashCoroutine = null;
        }
    }
}
