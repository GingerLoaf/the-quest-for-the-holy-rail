using System;
using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.City
{
    public class SpatialGrid<T> where T : struct
    {
        private readonly Dictionary<Vector2Int, List<int>> _cells = new();
        private readonly List<(int index, float distSq)> _sortBuffer = new();
        private static readonly Comparison<(int index, float distSq)> DistanceComparison = (a, b) => a.distSq.CompareTo(b.distSq);
        private readonly float _cellSize;
        private readonly Vector3 _gridOrigin;
        private readonly Func<T, Vector3> _positionGetter;
        private readonly Func<T, bool> _indexFilter;
        private IReadOnlyList<T> _items;
        private Vector3 _queryOffset = Vector3.zero;
        private int _halfBStartIndex = int.MaxValue;

        public float CellSize => _cellSize;
        public int CellCount => _cells.Count;

        public SpatialGrid(float cellSize, Vector3 gridOrigin, Func<T, Vector3> positionGetter, Func<T, bool> indexFilter = null)
        {
            _cellSize = cellSize;
            _gridOrigin = gridOrigin;
            _positionGetter = positionGetter;
            _indexFilter = indexFilter;
        }

        public void Initialize(IReadOnlyList<T> items)
        {
            _cells.Clear();
            _items = items;

            for (int i = 0; i < items.Count; i++)
            {
                if (_indexFilter != null && !_indexFilter(items[i]))
                    continue;

                var cellKey = GetCellKey(_positionGetter(items[i]));

                if (!_cells.TryGetValue(cellKey, out var list))
                {
                    list = new List<int>();
                    _cells[cellKey] = list;
                }

                list.Add(i);
            }
        }

        public void GetItemsInRadius(Vector3 center, float radius, List<int> results)
        {
            results.Clear();
            _sortBuffer.Clear();

            if (_items == null)
                return;

            var minCell = GetCellKey(center - new Vector3(radius, 0, radius));
            var maxCell = GetCellKey(center + new Vector3(radius, 0, radius));
            var radiusSq = radius * radius;

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int z = minCell.y; z <= maxCell.y; z++)
                {
                    var cellKey = new Vector2Int(x, z);

                    if (_cells.TryGetValue(cellKey, out var itemIndices))
                    {
                        foreach (var index in itemIndices)
                        {
                            var itemPos = _positionGetter(_items[index]);
                            if (index >= _halfBStartIndex)
                            {
                                itemPos += _queryOffset;
                            }
                            var dx = itemPos.x - center.x;
                            var dz = itemPos.z - center.z;
                            var distSq = dx * dx + dz * dz;

                            if (distSq <= radiusSq)
                            {
                                _sortBuffer.Add((index, distSq));
                            }
                        }
                    }
                }
            }

            _sortBuffer.Sort(DistanceComparison);

            foreach (var item in _sortBuffer)
            {
                results.Add(item.index);
            }
        }

        public void GetItemsInBounds(Bounds bounds, List<int> results)
        {
            results.Clear();

            var minCell = GetCellKey(bounds.min);
            var maxCell = GetCellKey(bounds.max);

            for (int x = minCell.x; x <= maxCell.x; x++)
            {
                for (int y = minCell.y; y <= maxCell.y; y++)
                {
                    var cellKey = new Vector2Int(x, y);

                    if (_cells.TryGetValue(cellKey, out var itemIndices))
                    {
                        results.AddRange(itemIndices);
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
