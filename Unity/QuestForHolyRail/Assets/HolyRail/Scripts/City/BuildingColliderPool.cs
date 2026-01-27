using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.City
{
    public class BuildingColliderPool : MonoBehaviour
    {
        private const float DefaultCellSize = 50f;

        [Header("References")]
        [field: SerializeField] public CityManager CityManager { get; private set; }
        [field: SerializeField] public Transform TrackingTarget { get; private set; }

        [Header("Pool Settings")]
        [field: SerializeField] public int PoolSize { get; private set; } = 200;
        [field: SerializeField] public float ActivationRadius { get; private set; } = 150f;
        [field: SerializeField] public float UpdateDistanceThreshold { get; private set; } = 25f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowDebugGizmos { get; private set; }

        private BuildingSpatialGrid _spatialGrid;
        private readonly List<BoxCollider> _colliderPool = new();
        private readonly List<int> _activeIndices = new();
        private readonly List<int> _queryResults = new();
        private Vector3 _lastUpdatePosition;
        private int _buildingsLayer;
        private bool _initialized;

        public int ActiveColliderCount { get; private set; }
        public int TotalPoolSize => _colliderPool.Count;
        public bool Initialized => _initialized;

        private void Start()
        {
            if (CityManager != null && CityManager.HasData)
            {
                Initialize();
            }
        }

        private void Update()
        {
            if (!_initialized)
            {
                if (CityManager != null && CityManager.HasData)
                    Initialize();
                return;
            }

            // Detect when city data has been cleared
            if (CityManager == null || !CityManager.HasData)
            {
                Clear();
                return;
            }

            if (TrackingTarget == null)
                return;

            var currentPosition = TrackingTarget.position;
            var distanceMoved = Vector3.Distance(currentPosition, _lastUpdatePosition);

            if (distanceMoved >= UpdateDistanceThreshold)
            {
                UpdateActiveColliders(currentPosition);
                _lastUpdatePosition = currentPosition;
            }
        }

        public void Initialize()
        {
            if (CityManager == null || !CityManager.HasData)
            {
                Debug.LogWarning("BuildingColliderPool: Cannot initialize - CityManager has no data.");
                return;
            }

            _buildingsLayer = LayerMask.NameToLayer("Buildings");
            if (_buildingsLayer == -1)
            {
                Debug.LogWarning("BuildingColliderPool: 'Buildings' layer not found. Using Default layer.");
                _buildingsLayer = 0;
            }

            _spatialGrid = new BuildingSpatialGrid(DefaultCellSize, CityManager.transform.position);
            _spatialGrid.Initialize(CityManager.Buildings);

            CreateColliderPool();

            _initialized = true;

            if (TrackingTarget != null)
            {
                _lastUpdatePosition = TrackingTarget.position;
                UpdateActiveColliders(_lastUpdatePosition);
            }

            Debug.Log($"BuildingColliderPool: Initialized with {_colliderPool.Count} colliders, spatial grid has {_spatialGrid.CellCount} cells.");
        }

        public void RefreshColliders()
        {
            if (!_initialized && CityManager != null && CityManager.HasData)
            {
                Initialize();
                return;
            }

            if (!_initialized)
                return;

            var position = TrackingTarget != null ? TrackingTarget.position : transform.position;
            UpdateActiveColliders(position);
            _lastUpdatePosition = position;
        }

        public void ActivateCollidersInBounds(Bounds bounds)
        {
            if (!_initialized || _spatialGrid == null)
                return;

            _spatialGrid.GetBuildingsInBounds(bounds, _queryResults);
            ActivateCollidersForBuildings(_queryResults);
        }

        public void Clear()
        {
            // Deactivate all colliders
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                    collider.enabled = false;
            }

            _activeIndices.Clear();
            _queryResults.Clear();
            _spatialGrid = null;
            _initialized = false;
            ActiveColliderCount = 0;
        }

        private void CreateColliderPool()
        {
            // Clear existing pool
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _colliderPool.Clear();
            _activeIndices.Clear();

            // Create pool container
            var poolContainer = new GameObject("BuildingColliders_Pool");
            poolContainer.transform.SetParent(transform);
            poolContainer.transform.localPosition = Vector3.zero;

            for (int i = 0; i < PoolSize; i++)
            {
                var go = new GameObject($"BuildingCollider_{i}");
                go.transform.SetParent(poolContainer.transform);
                go.layer = _buildingsLayer;

                var boxCollider = go.AddComponent<BoxCollider>();
                boxCollider.enabled = false;

                _colliderPool.Add(boxCollider);
            }
        }

        private void UpdateActiveColliders(Vector3 center)
        {
            if (_spatialGrid == null)
                return;

            _spatialGrid.GetBuildingsInRadius(center, ActivationRadius, _queryResults);
            ActivateCollidersForBuildings(_queryResults);
        }

        private void ActivateCollidersForBuildings(List<int> buildingIndices)
        {
            var buildings = CityManager.Buildings;
            var activateCount = Mathf.Min(buildingIndices.Count, _colliderPool.Count);

            // Deactivate all colliders first
            for (int i = 0; i < _colliderPool.Count; i++)
            {
                if (_colliderPool[i] != null)
                    _colliderPool[i].enabled = false;
            }
            _activeIndices.Clear();

            // Activate colliders for nearby buildings
            for (int i = 0; i < activateCount; i++)
            {
                var collider = _colliderPool[i];
                if (collider == null)
                    continue;

                var buildingIndex = buildingIndices[i];
                var building = buildings[buildingIndex];

                collider.transform.position = building.Position;
                collider.transform.rotation = building.Rotation;
                collider.size = building.Scale;
                collider.enabled = true;

                _activeIndices.Add(buildingIndex);
            }

            ActiveColliderCount = activateCount;
        }

        private void OnDrawGizmosSelected()
        {
            if (!ShowDebugGizmos || !_initialized)
                return;

            // Draw activation radius
            if (TrackingTarget != null)
            {
                Gizmos.color = new Color(0f, 1f, 0f, 0.3f);
                DrawCircle(TrackingTarget.position + Vector3.up * 5f, ActivationRadius, 32);

                Gizmos.color = new Color(1f, 1f, 0f, 0.3f);
                DrawCircle(TrackingTarget.position + Vector3.up * 5f, UpdateDistanceThreshold, 16);
            }

            // Draw active colliders
            Gizmos.color = new Color(0f, 0.5f, 1f, 0.5f);
            foreach (var collider in _colliderPool)
            {
                if (collider != null && collider.enabled)
                {
                    var matrix = Matrix4x4.TRS(collider.transform.position, collider.transform.rotation, Vector3.one);
                    Gizmos.matrix = matrix;
                    Gizmos.DrawWireCube(Vector3.zero, collider.size);
                }
            }
            Gizmos.matrix = Matrix4x4.identity;
        }

        private void DrawCircle(Vector3 center, float radius, int segments)
        {
            var angleStep = 360f / segments;
            var prevPoint = center + new Vector3(radius, 0, 0);

            for (int i = 1; i <= segments; i++)
            {
                var angle = i * angleStep * Mathf.Deg2Rad;
                var point = center + new Vector3(Mathf.Cos(angle) * radius, 0, Mathf.Sin(angle) * radius);
                Gizmos.DrawLine(prevPoint, point);
                prevPoint = point;
            }
        }

        private void OnDestroy()
        {
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _colliderPool.Clear();
        }
    }
}
