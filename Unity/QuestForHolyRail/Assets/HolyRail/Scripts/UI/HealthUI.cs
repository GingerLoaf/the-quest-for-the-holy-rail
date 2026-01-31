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

        private void Start()
        {
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnHealthChanged += UpdateHealthDisplay;
                UpdateHealthDisplay(GameSessionManager.Instance.CurrentHealth);
            }
        }

        private void OnDestroy()
        {
            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnHealthChanged -= UpdateHealthDisplay;
            }
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
    }
}
