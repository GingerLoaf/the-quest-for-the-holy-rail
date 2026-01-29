using System.Collections;
using UnityEngine;

namespace HolyRail.Scripts.FX
{
    public class PlayerHitFlash : MonoBehaviour
    {
        [Tooltip("The red material to swap to when hit")]
        [SerializeField] private Material _flashMaterial;

        [Tooltip("Duration of the flash in seconds")]
        [SerializeField] private float _flashDuration = 0.25f;

        [Tooltip("Root transform containing all renderers to flash (leave empty to use this object)")]
        [SerializeField] private Transform _rendererRoot;

        private Renderer[] _renderers;
        private Material[][] _originalMaterials;
        private bool _isFlashing;

        public static PlayerHitFlash Instance { get; private set; }

        private void Awake()
        {
            Instance = this;

            var root = _rendererRoot != null ? _rendererRoot : transform;
            _renderers = root.GetComponentsInChildren<Renderer>();

            // Cache original materials for each renderer
            _originalMaterials = new Material[_renderers.Length][];
            for (int i = 0; i < _renderers.Length; i++)
            {
                _originalMaterials[i] = _renderers[i].materials;
            }
        }

        public void Flash()
        {
            if (_isFlashing || _flashMaterial == null)
            {
                return;
            }

            StartCoroutine(FlashCoroutine());
        }

        private IEnumerator FlashCoroutine()
        {
            _isFlashing = true;

            // Swap all materials to flash material
            for (int i = 0; i < _renderers.Length; i++)
            {
                var flashMats = new Material[_originalMaterials[i].Length];
                for (int j = 0; j < flashMats.Length; j++)
                {
                    flashMats[j] = _flashMaterial;
                }
                _renderers[i].materials = flashMats;
            }

            yield return new WaitForSeconds(_flashDuration);

            // Restore original materials
            for (int i = 0; i < _renderers.Length; i++)
            {
                _renderers[i].materials = _originalMaterials[i];
            }

            _isFlashing = false;
        }
    }
}
