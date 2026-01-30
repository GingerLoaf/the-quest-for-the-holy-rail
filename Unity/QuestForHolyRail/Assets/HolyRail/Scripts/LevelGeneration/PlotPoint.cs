using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public class PlotPoint : MonoBehaviour
    {
        [field: SerializeField] public Vector2Int HexCell { get; set; }
        [field: SerializeField] public int PathIndex { get; set; }
        [field: SerializeField] public int PointIndex { get; set; }
        [field: SerializeField] public bool FirstInPath { get; set; }
        [field: SerializeField] public bool LastInPath { get; set; }

        private void OnDrawGizmos()
        {
            if (FirstInPath)
                Gizmos.color = Color.green;
            else if (LastInPath)
                Gizmos.color = Color.red;
            else
                Gizmos.color = Color.yellow;

            Gizmos.DrawSphere(transform.position, 1f);
        }

        private void OnDrawGizmosSelected()
        {
            float circumradius = HexConstants.DefaultCircumradius;

            var parent = GetComponentInParent<LevelGenerationManager>();
            if (parent != null)
            {
                var prefabs = parent.SectionPrefabs;
                if (prefabs != null && prefabs.Length > 0 && prefabs[0] != null)
                    circumradius = prefabs[0].Circumradius;
            }

            var gridPos = HexConstants.AxialToWorld(HexCell, circumradius);

            // Line from plot point to hex center
            Gizmos.color = new Color(1f, 1f, 0f, 0.6f);
            Gizmos.DrawLine(transform.position, gridPos);

            // Hex outline at the grid cell
            Gizmos.color = new Color(1f, 1f, 0f, 0.4f);
            var vertices = HexConstants.GetAllVertices(circumradius);
            for (int v = 0; v < HexConstants.EdgeCount; v++)
            {
                var v0 = gridPos + vertices[v];
                var v1 = gridPos + vertices[(v + 1) % HexConstants.EdgeCount];
                Gizmos.DrawLine(v0, v1);
            }
        }
    }
}
