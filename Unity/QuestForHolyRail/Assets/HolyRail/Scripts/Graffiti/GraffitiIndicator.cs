using UnityEngine;

namespace HolyRail.Graffiti
{
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public class GraffitiIndicator : MonoBehaviour
    {
        [Header("Settings")]
        [field: SerializeField] public float BobAmplitude { get; private set; } = 0.3f;
        [field: SerializeField] public float BobSpeed { get; private set; } = 2f;
        [field: SerializeField] public float RotationSpeed { get; private set; } = 45f;

        private float _bobPhase;
        private Vector3 _basePosition;

        private void Start()
        {
            _basePosition = transform.localPosition;
            _bobPhase = Random.value * Mathf.PI * 2f;
        }

        private void Update()
        {
            float bobOffset = Mathf.Sin(Time.time * BobSpeed + _bobPhase) * BobAmplitude;
            transform.localPosition = _basePosition + Vector3.up * bobOffset;

            transform.Rotate(Vector3.up, RotationSpeed * Time.deltaTime, Space.World);
        }
    }
}
