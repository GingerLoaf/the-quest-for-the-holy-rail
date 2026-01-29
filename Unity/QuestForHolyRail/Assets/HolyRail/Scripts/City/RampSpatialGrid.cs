using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.City
{
    public class RampSpatialGrid
    {
        private readonly Dictionary<Vector2Int, List<int>> _cells = new();
        private readonly List<(int index, float distSq)> _sortBuffer = new();
        private readonly float _cellSize;
        private readonly Vector3 _gridOrigin;
        private IReadOnlyList<RampData> _ramps;
        private Vector3 _queryOffset = Vector3.zero;
        private int _halfBStartIndex = int.MaxValue;

        public float CellSize => _cellSize;
        public int CellCount => _cells.Count;

        public RampSpatialGrid(float cellSize, Vector3 gridOrigin)
        {
            _cellSize = cellSize;
            _gridOrigin = gridOrigin;
        }

        public void Initialize(IReadOnlyList<RampData> ramps)
        {
            _cells.Clear();
            _ramps = ramps;

            for (int i = 0; i < ramps.Count; i++)
            {
                var cellKey = GetCellKey(ramps[i].Position);

                if (!_cells.TryGetValue(cellKey, out var list))
                {
                    list = new List<int>();
                    _cells[cellKey] = list;
                }

                list.Add(i);
            }
        }

        public void GetRampsInRadius(Vector3 center, float radius, List<int> results)
        {
            results.Clear();
            _sortBuffer.Clear();

            if (_ramps == null)
                return;

            var minCell = GetCellKey(center - new Vector3(radius, 0, radius));
            var maxCell = GetCellKey(center + new Vector3(radius, 0, radius));
            var radiusSq = radius * radius;

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int z = minCell.y; z <= maxCell.y; z++)
                {
                    var cellKey = new Vector2Int(x, z);

                    if (_cells.TryGetValue(cellKey, out var rampIndices))
                    {
                        foreach (var index in rampIndices)
                        {
                            var rampPos = _ramps[index].Position;
                            // Apply offset for loop mode leapfrog (only for HalfB instances)
                            if (index >= _halfBStartIndex)
                            {
                                rampPos += _queryOffset;
                            }
                            var dx = rampPos.x - center.x;
                            var dz = rampPos.z - center.z;
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

        private Vector2Int GetCellKey(Vector3 worldPosition)
        {
            var localPos = worldPosition - _gridOrigin;
            int x = Mathf.FloorToInt(localPos.x / _cellSize);
            int z = Mathf.FloorToInt(localPos.z / _cellSize);
            return new Vector2Int(x, z);
        }

        public void SetQueryOffset(Vector3 offset, int halfBStartIndex)
        {
            _queryOffset = offset;
            _halfBStartIndex = halfBStartIndex;
        }

        public void ClearQueryOffset()
        {
            _queryOffset = Vector3.zero;
            _halfBStartIndex = int.MaxValue;
        }
    }
}
