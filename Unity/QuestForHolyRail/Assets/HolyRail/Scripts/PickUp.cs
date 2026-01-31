using UnityEngine;
using StarterAssets;
using UnityEngine.Serialization;

namespace HolyRail.Scripts
{
    public enum PickupPersistence
    {
        Permanent,
        Temporary
    }

    public class PickUp : MonoBehaviour
    {
        [FormerlySerializedAs("Persistence")] [Header("Classification")]
        public PickupPersistence persistence = PickupPersistence.Temporary;

        [FormerlySerializedAs("PermanentUpgrade")]
        [Header("Data Assets")]
        [Tooltip("Assign for Permanent upgrades (persists between levels)")]
        public PlayerUpgrade permanentUpgrade;
        
        [FormerlySerializedAs("TemporaryPickup")] [Tooltip("Assign for Temporary upgrades (reset per run). Health drops should be Temporary.")]
        public ItemPickup temporaryPickup;

        [FormerlySerializedAs("CollectionRadius")]
        [Header("Pickup Settings")]
        [Tooltip("Distance within which the player can collect this pickup")]
        public float collectionRadius = 0.5f;

        [FormerlySerializedAs("VisualObject")] [Tooltip("Visual object to disable on collection")]
        public Renderer visualObject;

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
            if (_collected || !_playerTransform)
                return;

            float distance = Vector3.Distance(transform.position, _playerTransform.position);

            if (distance <= collectionRadius)
            {
                Collect();
            }
        }

        private void Collect()
        {
            _collected = true;
            var session = GameSessionManager.Instance;

            if (session)
            {
                if (persistence == PickupPersistence.Permanent && permanentUpgrade)
                {
                    session.AddUpgrade(permanentUpgrade);
                }
                else if (persistence == PickupPersistence.Temporary && temporaryPickup)
                {
                    // Add to temporary stats
                    session.AddPickup(temporaryPickup);

                    // Special Case: Health Pickup restores current health immediately
                    if (temporaryPickup.type == PickupType.HealthPickup)
                    {
                        session.Heal(Mathf.RoundToInt(temporaryPickup.value));
                    }
                }
            }

            // Trigger haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.Pickup);
            }

            // Hide or destroy the pickup
            if (visualObject)
            {
                visualObject.enabled = false;
            }

            // Destroy the pickup after a short delay to allow any effects to play
            Destroy(gameObject, 0.1f);
        }

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = persistence == PickupPersistence.Permanent ? Color.magenta : Color.yellow;
            Gizmos.DrawWireSphere(transform.position, collectionRadius);
        }
    }
}