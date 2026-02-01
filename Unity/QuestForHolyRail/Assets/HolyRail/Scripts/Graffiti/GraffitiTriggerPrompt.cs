using StarterAssets;
using UnityEngine;

namespace HolyRail.Graffiti
{
    public class GraffitiTriggerPrompt : MonoBehaviour
    {
        [field: SerializeField] public GameObject PromptUI { get; private set; }

        private ThirdPersonController_RailGrinder _player;
        private bool _isPlayerInRange;
        private bool _hasBeenDismissed;

        private void Awake()
        {
            if (PromptUI != null)
            {
                PromptUI.SetActive(false);
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (_hasBeenDismissed)
            {
                return;
            }

            if (other.CompareTag("Player"))
            {
                _player = other.GetComponent<ThirdPersonController_RailGrinder>();
                _isPlayerInRange = true;
                ShowPrompt();
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                _isPlayerInRange = false;
                _player = null;
                HidePrompt();
            }
        }

        private void Update()
        {
            if (!_isPlayerInRange || _player == null || _hasBeenDismissed)
            {
                return;
            }

            if (_player.IsSprayInputPressed)
            {
                _hasBeenDismissed = true;
                HidePrompt();
            }
        }

        private void ShowPrompt()
        {
            if (PromptUI != null)
            {
                PromptUI.SetActive(true);
            }
        }

        private void HidePrompt()
        {
            if (PromptUI != null)
            {
                PromptUI.SetActive(false);
            }
        }

        public void ResetForPoolReuse()
        {
            _hasBeenDismissed = false;
            _isPlayerInRange = false;
            _player = null;
            HidePrompt();
        }
    }
}
