using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public class AttachmentPoint : MonoBehaviour
    {
        private void OnDrawGizmos()
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawSphere(transform.position, 0.2f);
        }
    }
}
