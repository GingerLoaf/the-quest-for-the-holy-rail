using UnityEngine;

namespace HolyRail.Scripts.FX
{
    public class ExplosionEffect : MonoBehaviour
    {
        public float Duration = 2f;

        private void Start()
        {
            Destroy(gameObject, Duration);
        }
    }
}
