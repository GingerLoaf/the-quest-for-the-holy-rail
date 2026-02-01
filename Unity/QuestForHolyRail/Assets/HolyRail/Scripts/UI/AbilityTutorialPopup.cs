using System.Collections;
using UnityEngine;

namespace HolyRail.Scripts.UI
{
    public class AbilityTutorialPopup : MonoBehaviour
    {
        [field: SerializeField]
        public float Duration { get; private set; } = 5f;

        private Coroutine _hideCoroutine;

        public void Show()
        {
            gameObject.SetActive(true);

            if (_hideCoroutine != null)
            {
                StopCoroutine(_hideCoroutine);
            }

            _hideCoroutine = StartCoroutine(HideAfterDelay());
        }

        private IEnumerator HideAfterDelay()
        {
            yield return new WaitForSeconds(Duration);
            gameObject.SetActive(false);
            _hideCoroutine = null;
        }
    }
}
