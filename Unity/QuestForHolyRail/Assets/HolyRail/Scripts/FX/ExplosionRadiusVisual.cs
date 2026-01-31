using UnityEngine;

namespace HolyRail.Scripts.FX
{
    public class ExplosionRadiusVisual : MonoBehaviour
    {
        [field: SerializeField]
        public float ScaleDuration { get; private set; } = 0.15f;

        private float _targetRadius;
        private float _timer;

        public void Initialize(float radius)
        {
            _targetRadius = radius;
            _timer = 0f;
            transform.localScale = Vector3.zero;
        }

        private void Update()
        {
            _timer += Time.deltaTime;
            float t = Mathf.Clamp01(_timer / ScaleDuration);
            float scale = _targetRadius * 3f * t;  // diameter = radius * 2, plus 50% bigger
            transform.localScale = Vector3.one * scale;

            if (_timer >= ScaleDuration)
            {
                Destroy(gameObject);
            }
        }
    }
}
