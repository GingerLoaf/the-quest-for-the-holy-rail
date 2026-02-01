using System.Collections;
using UnityEngine;

namespace Art.PickUps
{
    /// <summary>
    /// Component that animates a door downward and deactivates it when complete.
    /// Added dynamically to doors by AbilityPickUp when collected.
    /// </summary>
    public class DoorAnimator : MonoBehaviour
    {
        private float _duration;
        private AudioClip _sfx;
        private float _audioMaxDistance;

        public void AnimateDown(float duration, AudioClip sfx, float audioMaxDistance)
        {
            _duration = duration;
            _sfx = sfx;
            _audioMaxDistance = audioMaxDistance;
            StartCoroutine(AnimateCoroutine());
        }

        private IEnumerator AnimateCoroutine()
        {
            // Calculate door height from renderer bounds or scale
            float doorHeight = transform.localScale.y;
            var renderer = GetComponent<Renderer>();
            if (renderer != null)
            {
                doorHeight = renderer.bounds.size.y;
            }

            Vector3 startPos = transform.position;
            Vector3 endPos = startPos - Vector3.up * doorHeight;

            // Create 3D audio source on the door
            AudioSource doorAudio = null;
            if (_sfx != null)
            {
                doorAudio = gameObject.AddComponent<AudioSource>();
                doorAudio.clip = _sfx;
                doorAudio.loop = true;
                doorAudio.spatialBlend = 1f; // Full 3D
                doorAudio.rolloffMode = AudioRolloffMode.Linear;
                doorAudio.minDistance = 1f;
                doorAudio.maxDistance = _audioMaxDistance;
                doorAudio.Play();
            }

            // Animate door down
            float elapsed = 0f;
            while (elapsed < _duration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / _duration;
                transform.position = Vector3.Lerp(startPos, endPos, t);

                // Fade audio in last 25% of animation
                if (doorAudio != null && t > 0.75f)
                {
                    doorAudio.volume = Mathf.Lerp(1f, 0f, (t - 0.75f) / 0.25f);
                }

                yield return null;
            }

            // Clean up
            gameObject.SetActive(false);
        }
    }
}
