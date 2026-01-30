using System.Collections.Generic;
using System.Linq;
using HolyRail.City;
using UnityEngine;
using UnityEngine.Splines;
using Random = UnityEngine.Random;

namespace HolyRail.Scripts.LevelGeneration
{
    public enum PlotPointSource
    {
        GuideSplines,
        CityCorridors
    }

    public class LevelGenerationManager : MonoBehaviour
    {
        [Header("Generation Settings")]
        [Tooltip("Prefabs to use for generation. Must have HexSection component.")]
        [SerializeField] private HexSection[] _sectionPrefabs;
        public HexSection[] SectionPrefabs => _sectionPrefabs;

        [Tooltip("Source for plot point generation.")]
        [SerializeField] private PlotPointSource _plotPointSource;

        [Tooltip("Spline paths that define the level layout. Used when source is GuideSplines.")]
        [SerializeField] private SplineContainer[] _guideSplines;

        [Tooltip("City manager to read corridor paths from. Used when source is CityCorridors.")]
        [SerializeField] private CityManager _cityManager;

        [Tooltip("If true, generates on Start.")]
        [SerializeField] private bool _generateOnStart = true;

        [Header("Plot Points")]
        [SerializeField] private PlotPoint[] _plotPoints = new PlotPoint[0];

        [Header("Runtime Data")]
        [SerializeField] private List<HexSection> _spawnedSections = new();

        private float _circumradius = HexConstants.DefaultCircumradius;

        private const int ArcLengthTableSamples = 256;

        private void Start()
        {
            if (_generateOnStart)
            {
                GenerateLevel();
            }
        }

        public void ComputePlotPoints()
        {
            if (_sectionPrefabs == null || _sectionPrefabs.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No section prefabs assigned.");
                return;
            }

            ClearPlotPoints();

            _circumradius = _sectionPrefabs[0].Circumradius;

            List<PlotPoint> allPoints;

            switch (_plotPointSource)
            {
                case PlotPointSource.CityCorridors:
                    allPoints = ComputePointsFromCorridors();
                    break;
                default:
                    allPoints = ComputePointsFromSplines();
                    break;
            }

            _plotPoints = allPoints.ToArray();
        }

        private List<PlotPoint> ComputePointsFromSplines()
        {
            var allPoints = new List<PlotPoint>();

            if (_guideSplines == null || _guideSplines.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No guide splines assigned.");
                return allPoints;
            }

            for (int g = 0; g < _guideSplines.Length; g++)
            {
                var splineContainer = _guideSplines[g];
                if (splineContainer == null) continue;

                var samples = SampleSplineWorldPositions(splineContainer);
                if (samples.Count < 2) continue;

                AddPathPoints(allPoints, samples, g);
            }

            return allPoints;
        }

        private List<PlotPoint> ComputePointsFromCorridors()
        {
            var allPoints = new List<PlotPoint>();

            if (_cityManager == null)
            {
                Debug.LogWarning("[LevelGenerationManager] No CityManager assigned.");
                return allPoints;
            }

            var corridors = new List<(IReadOnlyList<Vector3> path, bool enabled)>
            {
                (_cityManager.CorridorPathA, _cityManager.EnableCorridorA),
                (_cityManager.CorridorPathB, _cityManager.EnableCorridorB),
                (_cityManager.CorridorPathC, _cityManager.EnableCorridorC),
            };

            int pathIndex = 0;
            for (int c = 0; c < corridors.Count; c++)
            {
                if (!corridors[c].enabled) continue;

                var corridorPath = corridors[c].path;
                if (corridorPath == null || corridorPath.Count < 2)
                {
                    Debug.LogWarning($"[LevelGenerationManager] Corridor {(char)('A' + c)} has no path data. Generate the city first.");
                    continue;
                }

                var samples = ResamplePath(corridorPath);
                if (samples.Count < 2) continue;

                AddPathPoints(allPoints, samples, pathIndex);
                pathIndex++;
            }

            return allPoints;
        }

        private void AddPathPoints(List<PlotPoint> allPoints, List<Vector3> samples, int pathIndex)
        {
            for (int i = 0; i < samples.Count; i++)
            {
                var worldPos = samples[i];
                var axial = HexConstants.WorldToAxial(worldPos, _circumradius);

                // Skip duplicate hex cells from consecutive samples
                if (allPoints.Count > 0)
                {
                    var prev = allPoints[allPoints.Count - 1];
                    if (prev.PathIndex == pathIndex && prev.HexCell == axial)
                        continue;
                }

                var plotPoint = CreatePlotPointGameObject(worldPos, axial, pathIndex, allPoints.Count);
                plotPoint.FirstInPath = !allPoints.Any(p => p.PathIndex == pathIndex);
                allPoints.Add(plotPoint);
            }

            // Mark the last point in this path
            if (allPoints.Count > 0 && allPoints[allPoints.Count - 1].PathIndex == pathIndex)
                allPoints[allPoints.Count - 1].LastInPath = true;
        }

        public void ClearPlotPoints()
        {
            if (_plotPoints != null)
            {
                foreach (var point in _plotPoints)
                {
                    if (point == null) continue;
#if UNITY_EDITOR
                    if (Application.isPlaying) Destroy(point.gameObject);
                    else DestroyImmediate(point.gameObject);
#else
                    Destroy(point.gameObject);
#endif
                }
            }

            // Also sweep for any orphaned PlotPoint children
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i);
                if (child.GetComponent<PlotPoint>() == null) continue;
#if UNITY_EDITOR
                if (Application.isPlaying) Destroy(child.gameObject);
                else DestroyImmediate(child.gameObject);
#else
                Destroy(child.gameObject);
#endif
            }

            _plotPoints = new PlotPoint[0];
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

            if (_plotPoints == null || _plotPoints.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No plot points computed. Use 'Compute Plot Points' in the inspector first.");
                return;
            }

            _circumradius = _sectionPrefabs[0].Circumradius;

            // Group plot points by path, maintaining order
            var pathGroups = new SortedDictionary<int, List<PlotPoint>>();
            foreach (var point in _plotPoints)
            {
                if (point == null) continue;

                if (!pathGroups.ContainsKey(point.PathIndex))
                    pathGroups[point.PathIndex] = new List<PlotPoint>();

                pathGroups[point.PathIndex].Add(point);
            }

            var occupiedCells = new HashSet<Vector2Int>();
            int sectionIndex = 0;

            foreach (var kvp in pathGroups)
            {
                var pathPoints = kvp.Value;
                if (pathPoints.Count < 2) continue;

                sectionIndex = PlaceSectionsForPath(pathPoints, occupiedCells, sectionIndex);
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

            // Destroy non-PlotPoint children (spawned sections)
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i);
                if (child.GetComponent<PlotPoint>() != null) continue;

#if UNITY_EDITOR
                if (Application.isPlaying) Destroy(child.gameObject);
                else DestroyImmediate(child.gameObject);
#else
                Destroy(child.gameObject);
#endif
            }
        }

        private PlotPoint CreatePlotPointGameObject(
            Vector3 worldPosition, Vector2Int hexCell, int pathIndex, int pointIndex)
        {
            var go = new GameObject($"PlotPoint_P{pathIndex}_{pointIndex}");
            go.transform.SetParent(transform, true);
            go.transform.position = worldPosition;

            var plotPoint = go.AddComponent<PlotPoint>();
            plotPoint.HexCell = hexCell;
            plotPoint.PathIndex = pathIndex;
            plotPoint.PointIndex = pointIndex;

#if UNITY_EDITOR
            if (!Application.isPlaying)
                UnityEditor.EditorUtility.SetDirty(plotPoint);
#endif

            return plotPoint;
        }

        private List<Vector3> SampleSplineWorldPositions(SplineContainer splineContainer)
        {
            var worldSamples = new List<Vector3>();
            float stepDist = _circumradius * Mathf.Sqrt(3f);

            for (int s = 0; s < splineContainer.Splines.Count; s++)
            {
                // SplineContainer.Evaluate already returns world-space positions
                // (it applies TransformPoint internally), so no extra transform needed.
                var worldPositions = new Vector3[ArcLengthTableSamples + 1];
                var cumulativeDist = new float[ArcLengthTableSamples + 1];

                splineContainer.Evaluate(s, 0f, out var pos0, out _, out _);
                worldPositions[0] = pos0;
                cumulativeDist[0] = 0f;

                for (int i = 1; i <= ArcLengthTableSamples; i++)
                {
                    float t = (float)i / ArcLengthTableSamples;
                    splineContainer.Evaluate(s, t, out var pos, out _, out _);
                    worldPositions[i] = pos;
                    cumulativeDist[i] = cumulativeDist[i - 1] +
                        Vector3.Distance(worldPositions[i - 1], worldPositions[i]);
                }

                float worldLength = cumulativeDist[ArcLengthTableSamples];
                if (worldLength < stepDist) continue;

                int sampleCount = Mathf.Max(2, Mathf.CeilToInt(worldLength / stepDist) + 1);

                for (int i = 0; i < sampleCount; i++)
                {
                    float targetDist = (float)i / (sampleCount - 1) * worldLength;
                    var worldPos = LookupPositionAtDistance(worldPositions, cumulativeDist, targetDist);
                    worldSamples.Add(worldPos);
                }
            }

            return worldSamples;
        }

        private List<Vector3> ResamplePath(IReadOnlyList<Vector3> path)
        {
            var samples = new List<Vector3>();
            float stepDist = _circumradius * Mathf.Sqrt(3f);

            var cumulativeDist = new float[path.Count];
            cumulativeDist[0] = 0f;
            for (int i = 1; i < path.Count; i++)
            {
                cumulativeDist[i] = cumulativeDist[i - 1] +
                    Vector3.Distance(path[i - 1], path[i]);
            }

            float totalLength = cumulativeDist[path.Count - 1];
            if (totalLength < stepDist)
                return samples;

            int sampleCount = Mathf.Max(2, Mathf.CeilToInt(totalLength / stepDist) + 1);

            var positions = new Vector3[path.Count];
            for (int i = 0; i < path.Count; i++)
                positions[i] = path[i];

            for (int i = 0; i < sampleCount; i++)
            {
                float targetDist = (float)i / (sampleCount - 1) * totalLength;
                samples.Add(LookupPositionAtDistance(positions, cumulativeDist, targetDist));
            }

            return samples;
        }

        private static Vector3 LookupPositionAtDistance(
            Vector3[] positions, float[] cumulativeDist, float targetDist)
        {
            int count = positions.Length - 1;

            int lo = 0;
            int hi = count;
            while (lo < hi)
            {
                int mid = (lo + hi) / 2;
                if (cumulativeDist[mid] < targetDist)
                    lo = mid + 1;
                else
                    hi = mid;
            }

            if (lo == 0) return positions[0];
            if (lo > count) return positions[count];

            float segStart = cumulativeDist[lo - 1];
            float segEnd = cumulativeDist[lo];
            float segLength = segEnd - segStart;

            if (segLength < 0.0001f)
                return positions[lo];

            float t = (targetDist - segStart) / segLength;
            return Vector3.Lerp(positions[lo - 1], positions[lo], t);
        }

        private int PlaceSectionsForPath(
            List<PlotPoint> pathPoints, HashSet<Vector2Int> occupiedCells, int startIndex)
        {
            int sectionIndex = startIndex;

            for (int i = 0; i < pathPoints.Count; i++)
            {
                var cell = pathPoints[i].HexCell;
                if (occupiedCells.Contains(cell)) continue;

                int entryEdge = 3;
                int exitEdge = 0;

                if (i > 0)
                {
                    int edge = HexConstants.GetEdgeFromDirection(pathPoints[i - 1].HexCell, cell);
                    if (edge >= 0)
                        entryEdge = HexConstants.GetOppositeEdge(edge);
                }

                if (i < pathPoints.Count - 1)
                {
                    int edge = HexConstants.GetEdgeFromDirection(cell, pathPoints[i + 1].HexCell);
                    if (edge >= 0)
                        exitEdge = edge;
                }

                if (entryEdge == exitEdge) continue;
                if (HexConstants.AreEdgesAdjacent(entryEdge, exitEdge)) continue;

                var prefab = _sectionPrefabs[Random.Range(0, _sectionPrefabs.Length)];
                if (prefab == null) continue;

                var section = Instantiate(prefab, transform);
                section.gameObject.name = $"Section_{sectionIndex}_{prefab.name}";
                section.EntryEdge = entryEdge;
                section.ExitEdge = exitEdge;

                // Use the plot point's world position (on the spline) rather than hex grid center
                var worldPos = pathPoints[i].transform.position;
                AlignSectionToPlotPoint(section, worldPos, entryEdge);

                section.SectionIndex = sectionIndex;
                _spawnedSections.Add(section);
                occupiedCells.Add(cell);
                sectionIndex++;
            }

            return sectionIndex;
        }

        private void AlignSectionToPlotPoint(HexSection section, Vector3 worldPos, int entryEdge)
        {
            var entryLocalNormal = HexConstants.GetEdgeNormal(entryEdge, section.Circumradius);

            var gridEntryNormal = HexConstants.GetEdgeNormal(entryEdge, _circumradius).normalized;

            float gridAngle = Mathf.Atan2(gridEntryNormal.x, gridEntryNormal.z) * Mathf.Rad2Deg;
            float localAngle = Mathf.Atan2(entryLocalNormal.x, entryLocalNormal.z) * Mathf.Rad2Deg;
            float deltaAngle = gridAngle - localAngle;

            section.transform.rotation = Quaternion.Euler(0f, deltaAngle, 0f);
            section.transform.position = worldPos;
        }
    }
}
