using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Splines;

namespace HolyRail.Scripts.LevelGeneration
{
    public class LevelGenerationManager : MonoBehaviour
    {
        [Header("Generation Settings")]
        [Tooltip("Prefabs to use for generation. Must have HexSection component.")]
        [SerializeField] private HexSection[] _sectionPrefabs;

        [Tooltip("Spline paths that define the level layout. Sections are placed along these splines on a hex grid.")]
        [SerializeField] private SplineContainer[] _guideSplines;

        [Tooltip("If true, generates on Start.")]
        [SerializeField] private bool _generateOnStart = true;

        [Header("Runtime Data")]
        [SerializeField] private List<HexSection> _spawnedSections = new();

        private float _circumradius = HexConstants.DefaultCircumradius;

        private void Start()
        {
            if (_generateOnStart)
            {
                GenerateLevel();
            }
        }

        [ContextMenu("Generate Level")]
        public void GenerateLevel()
        {
            ClearLevel();

            if (_sectionPrefabs == null || _sectionPrefabs.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No section prefabs assigned.");
                return;
            }

            if (_guideSplines == null || _guideSplines.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No guide splines assigned.");
                return;
            }

            // Use circumradius from the first prefab
            _circumradius = _sectionPrefabs[0].Circumradius;

            var occupiedCells = new HashSet<Vector2Int>();
            int sectionIndex = 0;

            foreach (var splineContainer in _guideSplines)
            {
                if (splineContainer == null) continue;

                var hexCells = PlotHexCellsAlongSpline(splineContainer);
                if (hexCells.Count < 2) continue;

                sectionIndex = PlaceSectionsForPath(hexCells, occupiedCells, sectionIndex);
            }
        }

        [ContextMenu("Clear Level")]
        public void ClearLevel()
        {
            foreach (var section in _spawnedSections)
            {
                if (section != null)
                {
#if UNITY_EDITOR
                    if (Application.isPlaying) Destroy(section.gameObject);
                    else DestroyImmediate(section.gameObject);
#else
                    Destroy(section.gameObject);
#endif
                }
            }
            _spawnedSections.Clear();

            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i).gameObject;
#if UNITY_EDITOR
                if (Application.isPlaying) Destroy(child);
                else DestroyImmediate(child);
#else
                Destroy(child);
#endif
            }
        }

        private List<Vector2Int> PlotHexCellsAlongSpline(SplineContainer splineContainer)
        {
            var cells = new List<Vector2Int>();
            float stepDist = _circumradius * Mathf.Sqrt(3f);

            for (int s = 0; s < splineContainer.Splines.Count; s++)
            {
                float splineLength = splineContainer.CalculateLength(s);
                if (splineLength < stepDist) continue;

                int sampleCount = Mathf.Max(2, Mathf.CeilToInt(splineLength / stepDist) + 1);

                for (int i = 0; i < sampleCount; i++)
                {
                    float t = (float)i / (sampleCount - 1);
                    splineContainer.Evaluate(s, t, out var pos, out _, out _);
                    var worldPos = splineContainer.transform.TransformPoint(pos);
                    var axial = HexConstants.WorldToAxial(worldPos, _circumradius);

                    if (cells.Count == 0 || cells[cells.Count - 1] != axial)
                    {
                        cells.Add(axial);
                    }
                }
            }

            return cells;
        }

        private int PlaceSectionsForPath(
            List<Vector2Int> hexCells, HashSet<Vector2Int> occupiedCells, int startIndex)
        {
            int sectionIndex = startIndex;

            for (int i = 0; i < hexCells.Count; i++)
            {
                var cell = hexCells[i];
                if (occupiedCells.Contains(cell)) continue;

                // Determine entry/exit edges from neighbor direction
                int entryEdge = 3; // default
                int exitEdge = 0;  // default

                if (i > 0)
                {
                    int edge = HexConstants.GetEdgeFromDirection(hexCells[i - 1], cell);
                    if (edge >= 0)
                        entryEdge = HexConstants.GetOppositeEdge(edge);
                }

                if (i < hexCells.Count - 1)
                {
                    int edge = HexConstants.GetEdgeFromDirection(cell, hexCells[i + 1]);
                    if (edge >= 0)
                        exitEdge = edge;
                }

                // Skip if entry and exit are the same or adjacent (invalid hex section)
                if (entryEdge == exitEdge) continue;
                if (HexConstants.AreEdgesAdjacent(entryEdge, exitEdge)) continue;

                var prefab = _sectionPrefabs[Random.Range(0, _sectionPrefabs.Length)];
                if (prefab == null) continue;

                var section = Instantiate(prefab, transform);
                section.gameObject.name = $"Section_{sectionIndex}_{prefab.name}";
                section.EntryEdge = entryEdge;
                section.ExitEdge = exitEdge;

                var worldPos = HexConstants.AxialToWorld(cell, _circumradius);
                AlignSectionToGrid(section, worldPos, entryEdge);

                section.SectionIndex = sectionIndex;
                _spawnedSections.Add(section);
                occupiedCells.Add(cell);
                sectionIndex++;
            }

            return sectionIndex;
        }

        private void AlignSectionToGrid(HexSection section, Vector3 gridWorldPos, int entryEdge)
        {
            // The entry edge normal in local space points outward from the hex center.
            // On the hex grid, the entry edge normal must point toward the previous cell.
            // Since the hex grid is axis-aligned (no global rotation), we rotate the section
            // so its entry edge normal matches the expected grid direction.
            var entryLocalNormal = HexConstants.GetEdgeNormal(entryEdge, section.Circumradius);
            var entryLocalMid = HexConstants.GetEdgeMidpoint(entryEdge, section.Circumradius);

            // The grid direction for this entry edge
            var gridEntryNormal = HexConstants.GetEdgeNormal(entryEdge, _circumradius).normalized;

            // Rotate section so its local entry normal aligns with the grid entry normal
            float gridAngle = Mathf.Atan2(gridEntryNormal.x, gridEntryNormal.z) * Mathf.Rad2Deg;
            float localAngle = Mathf.Atan2(entryLocalNormal.x, entryLocalNormal.z) * Mathf.Rad2Deg;
            float deltaAngle = gridAngle - localAngle;

            section.transform.rotation = Quaternion.Euler(0f, deltaAngle, 0f);

            // Position so the hex center lands on the grid position
            var currentEntryWorld = section.transform.TransformPoint(entryLocalMid);
            var targetEntryWorld = gridWorldPos + Quaternion.Euler(0f, deltaAngle, 0f) * entryLocalMid;

            // Simpler: just place the section center at the grid position
            section.transform.position = gridWorldPos;
        }
    }
}
