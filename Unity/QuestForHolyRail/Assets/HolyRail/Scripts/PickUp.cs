using UnityEngine;
using StarterAssets;
using HolyRail.Scripts.FX;

namespace HolyRail.Scripts
{
    public class PickUp : MonoBehaviour
    {
        [Header("Pickup Settings")]
        [Tooltip("Distance within which the player can collect this pickup")]
        public float CollectionRadius = 0.25f;

        [Tooltip("How much to increase the player's max speed")]
        public float SpeedIncrease = 0.20f;

        [Tooltip("Visual effect or object to disable on collection")]
        public Renderer VisualObject;

        private bool _collected = false;
        private Transform _playerTransform;

        private void Start()
        {
            if (ThirdPersonController_RailGrinder.Instance != null)
            {
                _playerTransform = ThirdPersonController_RailGrinder.Instance.transform;
            }
        }

        private void Update()
        {
            if (_collected || _playerTransform == null)
                return;

            float distance = Vector3.Distance(transform.position, _playerTransform.position);

            if (distance <= CollectionRadius)
            {
                Collect();
            }
        }

        private void Collect()
        {
            _collected = true;

            // Increase player speed
            if (ThirdPersonController_RailGrinder.Instance != null)
            {
                ThirdPersonController_RailGrinder.Instance.IncreaseMaxSpeed(SpeedIncrease);

                var display = ThirdPersonController_RailGrinder.Instance.GetComponent<OrbitalPickupDisplay>();
                if (display != null)
                {
                    display.AddOrb();
                }
            }

            // Hide or destroy the pickup
            if (VisualObject != null)
            {
                VisualObject.enabled = false;
            }

            // Destroy the pickup after a short delay to allow any effects to play
            Destroy(gameObject, 0.1f);
        }

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(transform.position, CollectionRadius);
        }
    }
}
