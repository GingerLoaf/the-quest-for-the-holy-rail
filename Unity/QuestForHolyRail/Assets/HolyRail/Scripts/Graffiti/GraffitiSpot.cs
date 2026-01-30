using HolyRail.Scripts;
using StarterAssets;
using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace HolyRail.Graffiti
{
    public class GraffitiSpot : MonoBehaviour
    {
        [Header("Settings")]
        [field: SerializeField] public float SprayTime { get; private set; } = 2f;

        [Header("References")]
        [field: SerializeField] public DecalProjector DecalProjector { get; private set; }
        [field: SerializeField] public GameObject Reticle { get; private set; }
        [field: SerializeField] public GraffitiProgressUI ProgressUI { get; private set; }
        [field: SerializeField] public ParticleSystem CompletionEffect { get; private set; }

        private static readonly int BlendAmountProperty = Shader.PropertyToID("_BlendAmount");

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
            }

            if (Reticle != null)
            {
                Reticle.SetActive(false);
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
                if (_playerController != null)
                {
                    _playerController.SetSprayTarget(transform.position, false);
                }
            }
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

                if (Reticle != null)
                {
                    Reticle.SetActive(true);
                }

                if (ProgressUI != null)
                {
                    ProgressUI.Show();
                }

                if (_playerController != null)
                {
                    _playerController.SetActiveGraffiti(this);
                }
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                _isPlayerInRange = false;

                if (Reticle != null)
                {
                    Reticle.SetActive(false);
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

            if (Reticle != null)
            {
                Reticle.SetActive(false);
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
            }

            if (ProgressUI != null)
            {
                ProgressUI.Hide();
            }

            if (Reticle != null)
            {
                Reticle.SetActive(false);
            }

            _isPlayerInRange = false;
            _playerTransform = null;
            _playerController = null;
        }

        public bool IsCompleted => _isCompleted;
        public float Progress => _currentProgress;
    }
}
