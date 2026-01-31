using UnityEngine;

namespace HolyRail.Scripts.FX
{
    public class ExplosionEffect : MonoBehaviour
    {
        public float Duration = 2f;

        [Header("Audio")]
        [Tooltip("Explosion sounds (random selection)")]
        [SerializeField] private AudioClip[] _explosionClips;
        [Range(0, 1)] [SerializeField] private float _audioVolume = 0.8f;

        private void Start()
        {
            // Play explosion sound with large 3D range
            if (_explosionClips != null && _explosionClips.Length > 0)
            {
                var clip = _explosionClips[Random.Range(0, _explosionClips.Length)];
                var tempGO = new GameObject("ExplosionAudio");
                tempGO.transform.position = transform.position;
                var audioSource = tempGO.AddComponent<AudioSource>();
                audioSource.clip = clip;
                audioSource.volume = _audioVolume;
                audioSource.spatialBlend = 1f; // 3D sound
                audioSource.minDistance = 5f;
                audioSource.maxDistance = 500f;
                audioSource.rolloffMode = AudioRolloffMode.Linear;
                audioSource.Play();
                Destroy(tempGO, clip.length);
            }

            Destroy(gameObject, Duration);
        }
    }
}
