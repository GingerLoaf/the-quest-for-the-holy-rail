using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.City
{
    public class BuildingSpatialGrid
    {
        private readonly Dictionary<Vector2Int, List<int>> _cells = new();
        private readonly List<(int index, float distSq)> _sortBuffer = new();
        private readonly float _cellSize;
        private readonly Vector3 _gridOrigin;
        private IReadOnlyList<BuildingData> _buildings;

        public float CellSize => _cellSize;
        public int CellCount => _cells.Count;

        public BuildingSpatialGrid(float cellSize, Vector3 gridOrigin)
        {
            _cellSize = cellSize;
            _gridOrigin = gridOrigin;
        }

        public void Initialize(IReadOnlyList<BuildingData> buildings)
        {
            _cells.Clear();
            _buildings = buildings;

            for (int i = 0; i < buildings.Count; i++)
            {
                // Only index buildings that need colliders
                if (buildings[i].NeedsCollider == 0)
                    continue;

                var cellKey = GetCellKey(buildings[i].Position);

                if (!_cells.TryGetValue(cellKey, out var list))
                {
                    list = new List<int>();
                    _cells[cellKey] = list;
                }

                list.Add(i);
            }
        }

        public void GetBuildingsInRadius(Vector3 center, float radius, List<int> results)
        {
            results.Clear();
            _sortBuffer.Clear();

            if (_buildings == null)
                return;

            var minCell = GetCellKey(center - new Vector3(radius, 0, radius));
            var maxCell = GetCellKey(center + new Vector3(radius, 0, radius));
            var radiusSq = radius * radius;

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int z = minCell.y; z <= maxCell.y; z++)
                {
                    var cellKey = new Vector2Int(x, z);

                    if (_cells.TryGetValue(cellKey, out var buildingIndices))
                    {
                        foreach (var index in buildingIndices)
                        {
                            var buildingPos = _buildings[index].Position;
                            var dx = buildingPos.x - center.x;
                            var dz = buildingPos.z - center.z;
                            var distSq = dx * dx + dz * dz;

                            if (distSq <= radiusSq)
                            {
                                _sortBuffer.Add((index, distSq));
                            }
                        }
                    }
                }
            }

            // Sort by distance (closest first)
            _sortBuffer.Sort((a, b) => a.distSq.CompareTo(b.distSq));

            // Extract sorted indices
            foreach (var item in _sortBuffer)
            {
                results.Add(item.index);
            }
        }

        public void GetBuildingsInBounds(Bounds bounds, List<int> results)
        {
            results.Clear();

            var minCell = GetCellKey(bounds.min);
            var maxCell = GetCellKey(bounds.max);

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int y = minCell.y; y <= maxCell.y; y++)
                {
                    var cellKey = new Vector2Int(x, y);

                    if (_cells.TryGetValue(cellKey, out var buildingIndices))
                    {
                        results.AddRange(buildingIndices);
                    }
                }
            }
        }

        private Vector2Int GetCellKey(Vector3 worldPosition)
        {
            var localPos = worldPosition - _gridOrigin;
            int x = Mathf.FloorToInt(localPos.x / _cellSize);
            int z = Mathf.FloorToInt(localPos.z / _cellSize);
            return new Vector2Int(x, z);
        }
    }
}
