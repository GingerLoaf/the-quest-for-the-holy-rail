using HolyRail.Scripts.LevelGeneration;
using UnityEngine;
using UnityEngine.EventSystems;

namespace HolyRail.Scripts.Shop
{
    public class ShopZone : MonoBehaviour
    {
        public static ShopZone Instance { get; private set; }

        [Header("Volume References")]
        [field: Tooltip("The outer trigger volume that pauses game systems")]
        [field: SerializeField]
        public Collider OuterVolume { get; private set; }

        [field: Tooltip("The inner trigger volume that opens the shop UI")]
        [field: SerializeField]
        public Collider InnerVolume { get; private set; }

        [Header("Settings")]
        [field: Tooltip("Should the enemy spawner be paused in the shop zone")]
        [field: SerializeField]
        public bool PauseEnemySpawner { get; private set; } = true;

        private bool _playerInOuterZone;
        private bool _playerInInnerZone;
        private bool _showingPrompt;
        private bool _shopOpen;
        private Transform _playerTransform;
        private ShopUI _shopUI;
        private StarterAssets.StarterAssetsInputs _playerInput;

        private void Awake()
        {
            Instance = this;
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void Start()
        {
            // Find the ShopUI in the scene
            _shopUI = FindFirstObjectByType<ShopUI>(FindObjectsInactive.Include);
            if (_shopUI != null)
            {
                _shopUI.gameObject.SetActive(false);
            }
            else
            {
                Debug.LogWarning("<color=yellow>[Shop Zone]</color> No ShopUI found in scene!", gameObject);
            }

            var player = StarterAssets.ThirdPersonController_RailGrinder.Instance;
            if (player != null)
            {
                _playerTransform = player.transform;
                _playerInput = player.GetComponent<StarterAssets.StarterAssetsInputs>();
            }
        }

        private void Update()
        {
            // Check for jump input to open shop when showing prompt
            if (_showingPrompt && !_shopOpen && _playerInput != null && _playerInput.jump)
            {
                _playerInput.jump = false; // Consume the jump input
                OpenShop();
            }
        }

        public void OnOuterVolumeEnter()
        {
            if (_playerInOuterZone)
                return;

            _playerInOuterZone = true;
            PauseGameSystems();
            Debug.Log("<color=cyan>[Shop Zone]</color> Player entered outer zone - game systems paused", gameObject);
        }

        public void OnOuterVolumeExit()
        {
            if (!_playerInOuterZone)
                return;

            _playerInOuterZone = false;
            _playerInInnerZone = false;

            // Close shop if open
            if (_shopOpen)
            {
                CloseShop();
            }
            HidePrompt();

            ResumeGameSystems();
            Debug.Log("<color=cyan>[Shop Zone]</color> Player exited outer zone - game systems resumed", gameObject);
        }

        public void OnInnerVolumeEnter()
        {
            if (_playerInInnerZone)
                return;

            _playerInInnerZone = true;
            ShowPrompt();
            Debug.Log("<color=cyan>[Shop Zone]</color> Player entered inner zone - showing shop prompt", gameObject);
        }

        public void OnInnerVolumeExit()
        {
            if (!_playerInInnerZone)
                return;

            _playerInInnerZone = false;
            
            // Close shop if open
            if (_shopOpen)
            {
                CloseShop();
            }
            HidePrompt();
            Debug.Log("<color=cyan>[Shop Zone]</color> Player exited inner zone - hiding shop prompt", gameObject);
        }

        private void ShowPrompt()
        {
            _showingPrompt = true;
            if (_shopUI != null)
            {
                _shopUI.ShowPrompt();
            }
        }

        private void HidePrompt()
        {
            _showingPrompt = false;
            if (_shopUI != null)
            {
                _shopUI.HidePrompt();
            }
        }

        private void OpenShop()
        {
            _shopOpen = true;
            _showingPrompt = false;

            // Disable player movement
            var player = StarterAssets.ThirdPersonController_RailGrinder.Instance;
            if (player != null)
            {
                player.enabled = false;
                if (_playerInput != null)
                {
                    _playerInput.move = Vector2.zero;
                    _playerInput.look = Vector2.zero;
                }
            }

            // Show cursor for UI interaction
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;

            // Open shop UI
            if (_shopUI != null)
            {
                _shopUI.OpenShop(this);
            }

            Debug.Log("<color=cyan>[Shop Zone]</color> Shop opened - player controls disabled", gameObject);
        }

        public void CloseShop()
        {
            if (!_shopOpen)
                return;

            _shopOpen = false;

            // Re-enable player movement
            var player = StarterAssets.ThirdPersonController_RailGrinder.Instance;
            if (player != null)
            {
                player.enabled = true;
            }

            // Hide cursor and lock it
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;

            // Close shop UI
            if (_shopUI != null)
            {
                _shopUI.CloseShop();
            }

            // Show prompt again if still in inner zone
            if (_playerInInnerZone)
            {
                ShowPrompt();
            }

            Debug.Log("<color=cyan>[Shop Zone]</color> Shop closed - player controls enabled", gameObject);
        }

        private void PauseGameSystems()
        {
            // Pause death wall
            if (DeathWall.Instance != null)
            {
                DeathWall.Instance.Pause();
            }

            // Pause level generation
            if (LevelManager.Instance != null)
            {
                LevelManager.Instance.Pause();
            }

            // Fade out music
            if (MusicController.Instance != null)
            {
                MusicController.Instance.FadeOut();
            }

            // Pause all enemy spawners
            if (PauseEnemySpawner)
            {
                foreach (var spawner in Enemies.EnemySpawner.AllSpawners)
                {
                    spawner.enabled = false;
                }
            }
        }

        private void ResumeGameSystems()
        {
            Vector3 playerPosition = _playerTransform != null ? _playerTransform.position : transform.position;

            // Reset level generation from player's current position
            if (LevelManager.Instance != null)
            {
                LevelManager.Instance.ResetFromPosition(playerPosition);
                LevelManager.Instance.Resume();
            }

            // Reset and resume death wall
            if (DeathWall.Instance != null)
            {
                DeathWall.Instance.ResetToPosition(playerPosition);
                DeathWall.Instance.Resume();
            }

            // Fade in music
            if (MusicController.Instance != null)
            {
                MusicController.Instance.FadeIn();
            }

            // Resume all enemy spawners
            if (PauseEnemySpawner)
            {
                foreach (var spawner in Enemies.EnemySpawner.AllSpawners)
                {
                    spawner.enabled = true;
                }
            }
        }
    }
}
