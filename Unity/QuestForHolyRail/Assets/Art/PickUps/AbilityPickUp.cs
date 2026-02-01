using System.Collections;
using System.Collections.Generic;
using HolyRail.Scripts;
using StarterAssets;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Art.PickUps
{
    public enum AbilityType
    {
        Dash,
        Parry,
        Boost
    }

    public class AbilityPickUp : MonoBehaviour
    {
        [Header("Ability Configuration")]
        [field: SerializeField] public AbilityType Ability { get; private set; }
        [field: SerializeField] public InputActionReference ActionReference { get; private set; }

        [Header("Materials")]
        [Tooltip("Material applied to the Disc (base) mesh")]
        [SerializeField] private Material _baseMaterial;
        [Tooltip("Material applied to the Rim mesh")]
        [SerializeField] private Material _rimMaterial;

        [Header("Mesh References")]
        [SerializeField] private Transform _meshRoot;
        [SerializeField] private MeshRenderer _discRenderer;
        [SerializeField] private MeshRenderer _rimRenderer;

        [Header("Pickup Settings")]
        [Tooltip("Distance within which the player can collect this pickup")]
        [SerializeField] private float _collectionRadius = 2f;
        [Tooltip("Distance at which the pickup starts reacting to the player")]
        [SerializeField] private float _attractionRadius = 5f;

        [Header("Visual Effects")]
        [Tooltip("Particle system to play on pickup")]
        [SerializeField] private ParticleSystem _pickupVFX;
        [Tooltip("Rotation speed in degrees per second")]
        [SerializeField] private float _rotationSpeed = 90f;
        [Tooltip("Hover amplitude")]
        [SerializeField] private float _hoverAmplitude = 0.15f;
        [Tooltip("Hover frequency")]
        [SerializeField] private float _hoverFrequency = 2f;
        [Tooltip("Scale pulse amount when player is near")]
        [SerializeField] private float _pulseScale = 1.2f;
        [Tooltip("Pulse speed when player is near")]
        [SerializeField] private float _pulseSpeed = 4f;

        [Header("Door/Gate")]
        [Tooltip("Optional GameObject (e.g., a cube) that blocks the path until this ability is collected")]
        [SerializeField] private GameObject _door;
        [Tooltip("Sound to play from the door when unlocking (looped until animation completes)")]
        [SerializeField] private AudioClip _doorUnlockSFX;
        [Tooltip("How long the door takes to animate down")]
        [SerializeField] private float _doorAnimDuration = 1.5f;
        [Tooltip("3D audio max distance for door sound")]
        [SerializeField] private float _doorAudioMaxDistance = 50f;

        [Header("Audio")]
        [SerializeField] private AudioClip _pickupSFX;
        [Range(0f, 1f)]
        [SerializeField] private float _pickupVolume = 1f;

        private static readonly HashSet<AbilityType> UnlockedAbilities = new();

        private Transform _playerTransform;
        private Vector3 _startPosition;
        private Vector3 _baseScale;
        private bool _collected;
        private float _hoverOffset;
        private float _currentPulse = 1f;

        public static bool IsAbilityUnlocked(AbilityType ability) => UnlockedAbilities.Contains(ability);

        public static void UnlockAllAbilities()
        {
            UnlockedAbilities.Add(AbilityType.Dash);
            UnlockedAbilities.Add(AbilityType.Parry);
            UnlockedAbilities.Add(AbilityType.Boost);
            Debug.Log("[Cheat] All abilities unlocked!");
        }

        public static void ResetUnlockedAbilities()
        {
            UnlockedAbilities.Clear();
        }

        private void Awake()
        {
            ApplyMaterials();
        }

        private void Start()
        {
            _startPosition = transform.position;

            if (_meshRoot != null)
                _baseScale = _meshRoot.localScale;

            if (ThirdPersonController_RailGrinder.Instance != null)
                _playerTransform = ThirdPersonController_RailGrinder.Instance.transform;

            // Restore previously unlocked abilities
            RestoreUnlockedAbility();

            // If this ability is already unlocked, hide the pickup and open the door
            if (UnlockedAbilities.Contains(Ability))
            {
                if (_door != null)
                {
                    _door.SetActive(false);
                }
                gameObject.SetActive(false);
            }
        }

        private void Update()
        {
            if (_collected)
                return;

            UpdateVisuals();
            CheckPlayerProximity();
        }

        private void ApplyMaterials()
        {
            if (_discRenderer != null && _baseMaterial != null)
                _discRenderer.material = _baseMaterial;

            if (_rimRenderer != null && _rimMaterial != null)
                _rimRenderer.material = _rimMaterial;
        }

        private void UpdateVisuals()
        {
            if (_meshRoot == null)
                return;

            // Continuous rotation
            _meshRoot.Rotate(Vector3.up, _rotationSpeed * Time.deltaTime, Space.World);

            // Hover up and down
            _hoverOffset += Time.deltaTime * _hoverFrequency;
            float hoverY = Mathf.Sin(_hoverOffset * Mathf.PI * 2f) * _hoverAmplitude;
            transform.position = _startPosition + Vector3.up * hoverY;

            // Pulse scale when player is nearby
            float targetPulse = 1f;
            if (_playerTransform != null)
            {
                float distance = Vector3.Distance(transform.position, _playerTransform.position);
                if (distance <= _attractionRadius)
                {
                    float proximity = 1f - (distance / _attractionRadius);
                    float pulseAmount = Mathf.Lerp(1f, _pulseScale, proximity);
                    targetPulse = 1f + (pulseAmount - 1f) * (0.5f + 0.5f * Mathf.Sin(Time.time * _pulseSpeed));
                }
            }

            _currentPulse = Mathf.Lerp(_currentPulse, targetPulse, Time.deltaTime * 8f);
            _meshRoot.localScale = _baseScale * _currentPulse;
        }

        private void CheckPlayerProximity()
        {
            if (_playerTransform == null)
            {
                if (ThirdPersonController_RailGrinder.Instance != null)
                    _playerTransform = ThirdPersonController_RailGrinder.Instance.transform;
                return;
            }

            float distance = Vector3.Distance(transform.position, _playerTransform.position);
            if (distance <= _collectionRadius)
            {
                Collect();
            }
        }

        private void Collect()
        {
            _collected = true;

            // Unlock the ability
            UnlockAbility();

            // Set this position as the new checkpoint
            if (ThirdPersonController_RailGrinder.Instance != null)
            {
                ThirdPersonController_RailGrinder.Instance.SetCheckpoint(
                    _startPosition,
                    Quaternion.LookRotation(_playerTransform.position - _startPosition)
                );
            }

            // Show checkpoint notification
            ScoreManager.Instance?.ShowPopup("CHECKPOINT!");

            // Unlock the door/gate if one is assigned
            if (_door != null)
            {
                StartCoroutine(AnimateDoorDown());
            }

            // Play VFX
            if (_pickupVFX != null)
            {
                _pickupVFX.transform.SetParent(null);
                _pickupVFX.Play();
                Destroy(_pickupVFX.gameObject, _pickupVFX.main.duration + 1f);
            }

            // Play SFX (limited to 0.5 seconds)
            if (_pickupSFX != null)
            {
                var tempGO = new GameObject("AbilityPickupAudio");
                var audioSource = tempGO.AddComponent<AudioSource>();
                audioSource.clip = _pickupSFX;
                audioSource.volume = _pickupVolume;
                audioSource.spatialBlend = 0f; // 2D sound for clarity
                audioSource.Play();
                Object.Destroy(tempGO, 0.5f);
            }

            // Trigger haptic feedback for ability unlock
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.AbilityUnlock);
            }

            // Hide/destroy the pickup
            Destroy(gameObject);
        }

        private void UnlockAbility()
        {
            // Add to static set for persistence between deaths
            UnlockedAbilities.Add(Ability);

            // Enable the input action
            if (ActionReference != null && ActionReference.action != null)
            {
                ActionReference.action.Enable();
                Debug.Log($"Ability unlocked: {Ability}");
            }
            else
            {
                Debug.LogWarning($"AbilityPickUp: No ActionReference assigned for {Ability}");
            }
        }

        private void RestoreUnlockedAbility()
        {
            // If this ability type was previously unlocked, ensure the action is enabled
            if (UnlockedAbilities.Contains(Ability) && ActionReference != null && ActionReference.action != null)
            {
                ActionReference.action.Enable();
            }
        }

        private IEnumerator AnimateDoorDown()
        {
            if (_door == null)
                yield break;

            // Calculate door height from renderer bounds or scale
            float doorHeight = _door.transform.localScale.y;
            var renderer = _door.GetComponent<Renderer>();
            if (renderer != null)
            {
                doorHeight = renderer.bounds.size.y;
            }

            Vector3 startPos = _door.transform.position;
            Vector3 endPos = startPos - Vector3.up * doorHeight;

            // Create 3D audio source on the door
            AudioSource doorAudio = null;
            if (_doorUnlockSFX != null)
            {
                doorAudio = _door.AddComponent<AudioSource>();
                doorAudio.clip = _doorUnlockSFX;
                doorAudio.loop = true;
                doorAudio.spatialBlend = 1f; // Full 3D
                doorAudio.rolloffMode = AudioRolloffMode.Linear;
                doorAudio.minDistance = 1f;
                doorAudio.maxDistance = _doorAudioMaxDistance;
                doorAudio.Play();
            }

            // Animate door down
            float elapsed = 0f;
            while (elapsed < _doorAnimDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / _doorAnimDuration;
                _door.transform.position = Vector3.Lerp(startPos, endPos, t);

                // Fade audio in last 25% of animation
                if (doorAudio != null && t > 0.75f)
                {
                    doorAudio.volume = Mathf.Lerp(1f, 0f, (t - 0.75f) / 0.25f);
                }

                yield return null;
            }

            // Clean up
            _door.SetActive(false);
        }

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(transform.position, _collectionRadius);

            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(transform.position, _attractionRadius);
        }

#if UNITY_EDITOR
        private void OnValidate()
        {
            ApplyMaterials();
        }
#endif
    }
}