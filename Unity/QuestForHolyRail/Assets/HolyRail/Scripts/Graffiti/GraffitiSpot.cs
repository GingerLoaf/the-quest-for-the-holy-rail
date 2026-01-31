using HolyRail.Scripts;
using StarterAssets;
using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace HolyRail.Graffiti
{
    public class GraffitiSpot : MonoBehaviour
    {
        private bool _wasSprayingLastFrame;
        [Header("Settings")]
        [field: SerializeField] public float SprayTime { get; private set; } = 2f;

        [Header("References")]
        [field: SerializeField] public DecalProjector DecalProjector { get; private set; }
        [field: SerializeField] public GraffitiProgressUI ProgressUI { get; private set; }
        [field: SerializeField] public ParticleSystem CompletionEffect { get; private set; }

        [Header("Audio")]
        [Tooltip("Sound played when player enters graffiti range")]
        [SerializeField] private AudioClip _enterRangeClip;
        [Tooltip("Sound played when graffiti is completed")]
        [SerializeField] private AudioClip _completionClip;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 0.6f;

        private static readonly int BlendAmountProperty = Shader.PropertyToID("_BlendAmount");
        private static readonly int FrameEnabledProperty = Shader.PropertyToID("_FrameEnabled");

        private Material _decalMaterial;
        private float _currentProgress;
        private bool _isPlayerInRange;
        private bool _isCompleted;
        private Transform _playerTransform;
        private ThirdPersonController_RailGrinder _playerController;
        private ScoreManager _scoreManager;

        private void Awake()
        {
            if (DecalProjector != null && DecalProjector.material != null)
            {
                _decalMaterial = new Material(DecalProjector.material);
                DecalProjector.material = _decalMaterial;
                _decalMaterial.SetFloat(BlendAmountProperty, 0f);
                _decalMaterial.SetFloat(FrameEnabledProperty, 0f);
            }
        }

        private void Start()
        {
            // Cache ScoreManager reference to avoid FindFirstObjectByType allocation in Complete()
            _scoreManager = FindFirstObjectByType<ScoreManager>();

            if (GameSessionManager.Instance != null)
            {
                float radiusBonus = GameSessionManager.Instance.GetUpgradeValue(UpgradeType.SprayPaintRadius);
                if (radiusBonus > 0)
                {
                    var sphereCollider = GetComponent<SphereCollider>();
                    if (sphereCollider != null)
                    {
                        sphereCollider.radius *= (1.0f + radiusBonus);
                    }
                }
            }
        }

        private void OnDestroy()
        {
            if (_decalMaterial != null)
            {
                Destroy(_decalMaterial);
            }
        }

        private void Update()
        {
            if (_isCompleted || !_isPlayerInRange || _playerController == null)
            {
                return;
            }

            bool isSpraying = _playerController.IsSprayInputPressed;

            if (isSpraying)
            {
                // Start haptic feedback when spraying begins
                if (!_wasSprayingLastFrame && GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.StartContinuousHaptic(HapticType.GraffitiProgress);
                }

                _currentProgress += Time.deltaTime / SprayTime;
                _currentProgress = Mathf.Clamp01(_currentProgress);

                if (_decalMaterial != null)
                {
                    _decalMaterial.SetFloat(BlendAmountProperty, _currentProgress);
                }

                if (ProgressUI != null)
                {
                    ProgressUI.SetProgress(_currentProgress);
                }

                if (_playerController != null)
                {
                    _playerController.SetSprayTarget(transform.position, true);
                }

                if (_currentProgress >= 1f)
                {
                    Complete();
                }
            }
            else
            {
                // Stop haptic feedback when spraying stops
                if (_wasSprayingLastFrame && GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.StopContinuousHaptic();
                }

                if (_playerController != null)
                {
                    _playerController.SetSprayTarget(transform.position, false);
                }
            }

            _wasSprayingLastFrame = isSpraying;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (_isCompleted)
            {
                return;
            }

            if (other.CompareTag("Player"))
            {
                _isPlayerInRange = true;
                _playerTransform = other.transform;
                _playerController = other.GetComponent<ThirdPersonController_RailGrinder>();

                if (_decalMaterial != null)
                {
                    _decalMaterial.SetFloat(FrameEnabledProperty, 1f);
                }

                if (ProgressUI != null)
                {
                    ProgressUI.Show();
                }

                if (_playerController != null)
                {
                    _playerController.SetActiveGraffiti(this);
                }

                // Play enter range sound
                if (_enterRangeClip != null)
                {
                    AudioSource.PlayClipAtPoint(_enterRangeClip, transform.position, _audioVolume);
                }
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                _isPlayerInRange = false;

                // Stop haptic feedback if player was spraying when they left
                if (_wasSprayingLastFrame && GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.StopContinuousHaptic();
                }
                _wasSprayingLastFrame = false;

                if (_decalMaterial != null)
                {
                    _decalMaterial.SetFloat(FrameEnabledProperty, 0f);
                }

                if (ProgressUI != null)
                {
                    ProgressUI.Hide();
                }

                if (_playerController != null)
                {
                    _playerController.SetSprayTarget(Vector3.zero, false);
                    _playerController.SetActiveGraffiti(null);
                    _playerController = null;
                }

                _playerTransform = null;

                // Reset progress if player left without completing
                if (!_isCompleted)
                {
                    ResetProgress();
                }
            }
        }

        private void Complete()
        {
            _isCompleted = true;

            if (CompletionEffect != null)
            {
                CompletionEffect.Play();
            }

            if (_decalMaterial != null)
            {
                _decalMaterial.SetFloat(FrameEnabledProperty, 0f);
            }

            if (ProgressUI != null)
            {
                ProgressUI.Hide();
            }

            if (_playerController != null)
            {
                _playerController.SetSprayTarget(Vector3.zero, false);
            }

            if (_scoreManager != null)
            {
                _scoreManager.AddGraffitiScore();
            }

            // Trigger haptic feedback for completion
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StopContinuousHaptic();
                GamepadHaptics.Instance.TriggerHaptic(HapticType.GraffitiComplete);
            }

            // Play completion sound
            if (_completionClip != null)
            {
                AudioSource.PlayClipAtPoint(_completionClip, transform.position, _audioVolume);
            }
        }

        private void ResetProgress()
        {
            _currentProgress = 0f;
            if (_decalMaterial != null)
            {
                _decalMaterial.SetFloat(BlendAmountProperty, 0f);
            }
        }

        public void ResetForPoolReuse()
        {
            _isCompleted = false;
            _currentProgress = 0f;

            if (_decalMaterial != null)
            {
                _decalMaterial.SetFloat(BlendAmountProperty, 0f);
                _decalMaterial.SetFloat(FrameEnabledProperty, 0f);
            }

            if (ProgressUI != null)
            {
                ProgressUI.Hide();
            }

            _isPlayerInRange = false;
            _playerTransform = null;
            _playerController = null;
        }

        public bool IsCompleted => _isCompleted;
        public float Progress => _currentProgress;
    }
}
