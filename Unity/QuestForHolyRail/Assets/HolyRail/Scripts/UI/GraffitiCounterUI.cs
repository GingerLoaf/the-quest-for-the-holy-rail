using TMPro;
using UnityEngine;
using UnityEngine.UI;
using HolyRail.City;

namespace HolyRail.UI
{
    public class GraffitiCounterUI : MonoBehaviour
    {
        [field: SerializeField] public Image Icon { get; private set; }
        [field: SerializeField] public TextMeshProUGUI CountText { get; private set; }

        private GraffitiSpotPool _graffitiPool;
        private CityManager _cityManager;
        private int _lastCollectedCount = -1;
        private int _lastTotalCount = -1;

        private void Start()
        {
            _graffitiPool = FindFirstObjectByType<GraffitiSpotPool>();
            _cityManager = FindFirstObjectByType<CityManager>();
            UpdateDisplay();
        }

        private void Update()
        {
            UpdateDisplay();
        }

        private void UpdateDisplay()
        {
            if (_graffitiPool == null || _cityManager == null) return;

            int collected = _graffitiPool.CompletedCount;
            int total = _cityManager.ActualGraffitiCount;

            if (collected != _lastCollectedCount || total != _lastTotalCount)
            {
                _lastCollectedCount = collected;
                _lastTotalCount = total;
                CountText.text = $"{collected}/{total}";
            }
        }
    }
}
