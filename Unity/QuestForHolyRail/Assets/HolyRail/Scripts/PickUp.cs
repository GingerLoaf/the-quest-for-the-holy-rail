using UnityEngine;
using StarterAssets;

namespace HolyRail.Scripts
{
    public class PickUp : MonoBehaviour
    {
        [Header("Pickup Settings")]
        [Tooltip("Distance within which the player can collect this pickup")]
        public float CollectionRadius = 0.25f;

        // Speed boost fields commented out for future repurposing
        // [Tooltip("How much to increase the player's speed")]
        // public float SpeedIncrease = 0.20f;

        // [Tooltip("Duration of the speed boost (-1 uses the player's default)")]
        // public float BoostDuration = -1f;

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

            // Speed boost call commented out for future repurposing
            // if (ThirdPersonController_RailGrinder.Instance != null)
            // {
            //     ThirdPersonController_RailGrinder.Instance.AddTemporarySpeedBoost(SpeedIncrease, BoostDuration);
            // }

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
