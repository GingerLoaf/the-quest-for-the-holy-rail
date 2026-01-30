using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public class HexEdgePoint : MonoBehaviour
    {
        [field: SerializeField] public int EdgeIndex { get; set; }
        [field: SerializeField] public bool IsEntry { get; set; }
        [field: SerializeField] public bool IsExit { get; set; }

        private void OnDrawGizmos()
        {
            if (IsEntry)
                Gizmos.color = Color.green;
            else if (IsExit)
                Gizmos.color = Color.red;
            else
                Gizmos.color = Color.cyan;

            Gizmos.DrawSphere(transform.position, 0.5f);
            Gizmos.DrawRay(transform.position, transform.forward * 2f);
        }
    }
}
