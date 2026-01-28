using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.City
{
    [ExecuteInEditMode]
    public class BuildingColliderPool : MonoBehaviour
    {
        private const float DefaultCellSize = 50f;

        [Header("References")]
        [field: SerializeField] public CityManager CityManager { get; private set; }
        [field: SerializeField] public Transform TrackingTarget { get; private set; }

        [Header("Pool Settings")]
        [field: SerializeField] public float ActivationRadius { get; private set; } = 150f;
        [field: SerializeField] public float UpdateDistanceThreshold { get; private set; } = 25f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowDebugGizmos { get; private set; }

        private static readonly Vector3 InactivePosition = new(0, -1000f, 0);

        private BuildingSpatialGrid _spatialGrid;
        private readonly List<BoxCollider> _colliderPool = new();
        private readonly List<int> _activeIndices = new();
        private readonly List<int> _queryResults = new();
        private readonly HashSet<int> _assignedBuildingIndices = new();
        private GameObject _buildingPoolContainer;
        private Vector3 _lastUpdatePosition;
        private int _buildingsLayer;
        private bool _initialized;

        // Ramp collider pool
        private RampSpatialGrid _rampSpatialGrid;
        private readonly List<BoxCollider> _rampColliderPool = new();
        private readonly List<int> _activeRampIndices = new();
        private readonly List<int> _rampQueryResults = new();
        private readonly HashSet<int> _assignedRampIndices = new();
        private GameObject _rampPoolContainer;
        private bool _rampInitialized;

        // Billboard collider pool
        private BillboardSpatialGrid _billboardSpatialGrid;
        private readonly List<BoxCollider> _billboardColliderPool = new();
        private readonly List<int> _activeBillboardIndices = new();
        private readonly List<int> _billboardQueryResults = new();
        private readonly HashSet<int> _assignedBillboardIndices = new();
        private GameObject _billboardPoolContainer;
        private int _billboardsLayer;
        private bool _billboardInitialized;

        public int ActiveColliderCount { get; private set; }
        public int TotalPoolSize => _colliderPool.Count;
        public bool Initialized => _initialized;

        public int ActiveRampColliderCount { get; private set; }
        public int TotalRampPoolSize => _rampColliderPool.Count;
        public bool RampInitialized => _rampInitialized;

        public int ActiveBillboardColliderCount { get; private set; }
        public int TotalBillboardPoolSize => _billboardColliderPool.Count;
        public bool BillboardInitialized => _billboardInitialized;

        private void Start()
        {
            if (CityManager != null && CityManager.HasData)
            {
                Initialize();
            }
            if (CityManager != null && CityManager.HasRampData)
            {
                InitializeRamps();
            }
            if (CityManager != null && CityManager.HasBillboardData)
            {
                InitializeBillboards();
            }
        }

        private void Update()
        {
            // Initialize buildings if needed
            if (!_initialized)
            {
                if (CityManager != null && CityManager.HasData)
                    Initialize();
            }

            // Initialize ramps if needed
            if (!_rampInitialized)
            {
                if (CityManager != null && CityManager.HasRampData)
                    InitializeRamps();
            }

            // Initialize billboards if needed
            if (!_billboardInitialized)
            {
                if (CityManager != null && CityManager.HasBillboardData)
                    InitializeBillboards();
            }

            // Detect when city data has been cleared (only clear if we were initialized)
            if (_initialized && (CityManager == null || !CityManager.HasData))
            {
                Clear();
                return;
            }

            // Detect when ramp data has been cleared
            if (_rampInitialized && (CityManager == null || !CityManager.HasRampData))
            {
                ClearRamps();
            }

            // Detect when billboard data has been cleared
            if (_billboardInitialized && (CityManager == null || !CityManager.HasBillboardData))
            {
                ClearBillboards();
            }

            if (TrackingTarget == null)
                return;

            var currentPosition = TrackingTarget.position;
            var distanceMoved = Vector3.Distance(currentPosition, _lastUpdatePosition);

            if (distanceMoved >= UpdateDistanceThreshold)
            {
                if (_initialized)
                    UpdateActiveColliders(currentPosition);
                if (_rampInitialized)
                    UpdateActiveRampColliders(currentPosition);
                if (_billboardInitialized)
                    UpdateActiveBillboardColliders(currentPosition);
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

            Debug.Log($"BuildingColliderPool: Initialized with {_colliderPool.Count} building colliders, spatial grid has {_spatialGrid.CellCount} cells.");
        }

        public void InitializeRamps()
        {
            if (CityManager == null || !CityManager.HasRampData)
            {
                return;
            }

            _rampSpatialGrid = new RampSpatialGrid(DefaultCellSize, CityManager.transform.position);
            _rampSpatialGrid.Initialize(CityManager.Ramps);

            CreateRampColliderPool();

            _rampInitialized = true;

            if (TrackingTarget != null)
            {
                UpdateActiveRampColliders(TrackingTarget.position);
            }

            Debug.Log($"BuildingColliderPool: Initialized with {_rampColliderPool.Count} ramp colliders, spatial grid has {_rampSpatialGrid.CellCount} cells.");
        }

        public void InitializeBillboards()
        {
            if (CityManager == null || !CityManager.HasBillboardData)
            {
                return;
            }

            _billboardsLayer = LayerMask.NameToLayer("Billboards");
            if (_billboardsLayer == -1)
            {
                Debug.LogWarning("BuildingColliderPool: 'Billboards' layer not found. Using Default layer. Create a 'Billboards' layer for wall ride detection.");
                _billboardsLayer = 0;
            }

            _billboardSpatialGrid = new BillboardSpatialGrid(DefaultCellSize, CityManager.transform.position);
            _billboardSpatialGrid.Initialize(CityManager.Billboards);

            CreateBillboardColliderPool();

            _billboardInitialized = true;

            if (TrackingTarget != null)
            {
                UpdateActiveBillboardColliders(TrackingTarget.position);
            }

            Debug.Log($"BuildingColliderPool: Initialized with {_billboardColliderPool.Count} billboard colliders, spatial grid has {_billboardSpatialGrid.CellCount} cells.");
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
            // Destroy all building colliders
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                {
                    if (Application.isPlaying)
                        Destroy(collider.gameObject);
                    else
                        DestroyImmediate(collider.gameObject);
                }
            }
            _colliderPool.Clear();

            // Destroy the pool container
            if (_buildingPoolContainer != null)
            {
                if (Application.isPlaying)
                    Destroy(_buildingPoolContainer);
                else
                    DestroyImmediate(_buildingPoolContainer);
                _buildingPoolContainer = null;
            }

            _activeIndices.Clear();
            _queryResults.Clear();
            _assignedBuildingIndices.Clear();
            _spatialGrid = null;
            _initialized = false;
            ActiveColliderCount = 0;

            // Also clear ramps and billboards
            ClearRamps();
            ClearBillboards();
        }

        public void ClearRamps()
        {
            // Destroy all ramp colliders
            foreach (var collider in _rampColliderPool)
            {
                if (collider != null)
                {
                    if (Application.isPlaying)
                        Destroy(collider.gameObject);
                    else
                        DestroyImmediate(collider.gameObject);
                }
            }
            _rampColliderPool.Clear();

            // Destroy the ramp pool container
            if (_rampPoolContainer != null)
            {
                if (Application.isPlaying)
                    Destroy(_rampPoolContainer);
                else
                    DestroyImmediate(_rampPoolContainer);
                _rampPoolContainer = null;
            }

            _activeRampIndices.Clear();
            _rampQueryResults.Clear();
            _assignedRampIndices.Clear();
            _rampSpatialGrid = null;
            _rampInitialized = false;
            ActiveRampColliderCount = 0;
        }

        public void ClearBillboards()
        {
            // Destroy all billboard colliders
            foreach (var collider in _billboardColliderPool)
            {
                if (collider != null)
                {
                    if (Application.isPlaying)
                        Destroy(collider.gameObject);
                    else
                        DestroyImmediate(collider.gameObject);
                }
            }
            _billboardColliderPool.Clear();

            // Destroy the billboard pool container
            if (_billboardPoolContainer != null)
            {
                if (Application.isPlaying)
                    Destroy(_billboardPoolContainer);
                else
                    DestroyImmediate(_billboardPoolContainer);
                _billboardPoolContainer = null;
            }

            _activeBillboardIndices.Clear();
            _billboardQueryResults.Clear();
            _assignedBillboardIndices.Clear();
            _billboardSpatialGrid = null;
            _billboardInitialized = false;
            ActiveBillboardColliderCount = 0;
        }

        private void CreateColliderPool()
        {
            const string containerName = "BuildingColliders_Pool";

            // Clear existing pool
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _colliderPool.Clear();
            _activeIndices.Clear();

            // Destroy old container if it exists
            if (_buildingPoolContainer != null)
            {
                DestroyImmediate(_buildingPoolContainer);
                _buildingPoolContainer = null;
            }

            // Find and destroy any orphaned containers from domain reloads
            DestroyOrphanedContainers(containerName);

            // Create pool container (starts empty, colliders created on-demand)
            _buildingPoolContainer = new GameObject(containerName);
            _buildingPoolContainer.transform.SetParent(transform);
            _buildingPoolContainer.transform.localPosition = Vector3.zero;
        }

        private void CreateRampColliderPool()
        {
            const string containerName = "RampColliders_Pool";

            // Clear existing ramp pool
            foreach (var collider in _rampColliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _rampColliderPool.Clear();
            _activeRampIndices.Clear();

            // Destroy old container if it exists
            if (_rampPoolContainer != null)
            {
                DestroyImmediate(_rampPoolContainer);
                _rampPoolContainer = null;
            }

            // Find and destroy any orphaned containers from domain reloads
            DestroyOrphanedContainers(containerName);

            // Create pool container (starts empty, colliders created on-demand)
            _rampPoolContainer = new GameObject(containerName);
            _rampPoolContainer.transform.SetParent(transform);
            _rampPoolContainer.transform.localPosition = Vector3.zero;
        }

        private void CreateBillboardColliderPool()
        {
            const string containerName = "BillboardColliders_Pool";

            // Clear existing billboard pool
            foreach (var collider in _billboardColliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _billboardColliderPool.Clear();
            _activeBillboardIndices.Clear();

            // Destroy old container if it exists
            if (_billboardPoolContainer != null)
            {
                DestroyImmediate(_billboardPoolContainer);
                _billboardPoolContainer = null;
            }

            // Find and destroy any orphaned containers from domain reloads
            DestroyOrphanedContainers(containerName);

            // Create pool container (starts empty, colliders created on-demand)
            _billboardPoolContainer = new GameObject(containerName);
            _billboardPoolContainer.transform.SetParent(transform);
            _billboardPoolContainer.transform.localPosition = Vector3.zero;
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

            // Deactivate all colliders first and move them out of the way
            for (int i = 0; i < _colliderPool.Count; i++)
            {
                if (_colliderPool[i] != null)
                {
                    _colliderPool[i].enabled = false;
                    _colliderPool[i].transform.position = InactivePosition;
                }
            }
            _activeIndices.Clear();
            _assignedBuildingIndices.Clear();

            // Single pass: assign colliders to unique buildings, grow pool on demand
            int colliderIndex = 0;
            for (int i = 0; i < buildingIndices.Count; i++)
            {
                var buildingIndex = buildingIndices[i];

                // Skip if this building already has a collider assigned
                if (!_assignedBuildingIndices.Add(buildingIndex))
                    continue;

                // Grow pool on demand if needed
                if (colliderIndex >= _colliderPool.Count)
                {
                    var go = new GameObject($"BuildingCollider_{colliderIndex}");
                    go.transform.SetParent(_buildingPoolContainer.transform);
                    go.transform.position = InactivePosition;
                    go.layer = _buildingsLayer;
                    var newCollider = go.AddComponent<BoxCollider>();
                    newCollider.enabled = false;
                    _colliderPool.Add(newCollider);
                }

                var collider = _colliderPool[colliderIndex];
                var building = buildings[buildingIndex];

                collider.transform.position = building.Position;
                collider.transform.rotation = building.Rotation;
                collider.size = building.Scale;
                collider.enabled = true;

                _activeIndices.Add(buildingIndex);
                colliderIndex++;
            }

            ActiveColliderCount = colliderIndex;
        }

        private void UpdateActiveRampColliders(Vector3 center)
        {
            if (_rampSpatialGrid == null)
                return;

            _rampSpatialGrid.GetRampsInRadius(center, ActivationRadius, _rampQueryResults);
            ActivateCollidersForRamps(_rampQueryResults);
        }

        private void ActivateCollidersForRamps(List<int> rampIndices)
        {
            var ramps = CityManager.Ramps;

            // Deactivate all ramp colliders first and move them out of the way
            for (int i = 0; i < _rampColliderPool.Count; i++)
            {
                if (_rampColliderPool[i] != null)
                {
                    _rampColliderPool[i].enabled = false;
                    _rampColliderPool[i].transform.position = InactivePosition;
                }
            }
            _activeRampIndices.Clear();
            _assignedRampIndices.Clear();

            // Single pass: assign colliders to unique ramps, grow pool on demand
            int colliderIndex = 0;
            for (int i = 0; i < rampIndices.Count; i++)
            {
                var rampIndex = rampIndices[i];

                // Skip if this ramp already has a collider assigned
                if (!_assignedRampIndices.Add(rampIndex))
                    continue;

                // Grow pool on demand if needed
                if (colliderIndex >= _rampColliderPool.Count)
                {
                    var go = new GameObject($"RampCollider_{colliderIndex}");
                    go.transform.SetParent(_rampPoolContainer.transform);
                    go.transform.position = InactivePosition;
                    go.layer = _buildingsLayer;
                    var newCollider = go.AddComponent<BoxCollider>();
                    newCollider.enabled = false;
                    _rampColliderPool.Add(newCollider);
                }

                var collider = _rampColliderPool[colliderIndex];
                var ramp = ramps[rampIndex];

                collider.transform.position = ramp.Position;
                collider.transform.rotation = ramp.Rotation;
                collider.size = ramp.Scale;
                collider.enabled = true;

                _activeRampIndices.Add(rampIndex);
                colliderIndex++;
            }

            ActiveRampColliderCount = colliderIndex;
        }

        private void UpdateActiveBillboardColliders(Vector3 center)
        {
            if (_billboardSpatialGrid == null)
                return;

            _billboardSpatialGrid.GetBillboardsInRadius(center, ActivationRadius, _billboardQueryResults);
            ActivateCollidersForBillboards(_billboardQueryResults);
        }

        private void ActivateCollidersForBillboards(List<int> billboardIndices)
        {
            var billboards = CityManager.Billboards;

            // Deactivate all billboard colliders first and move them out of the way
            for (int i = 0; i < _billboardColliderPool.Count; i++)
            {
                if (_billboardColliderPool[i] != null)
                {
                    _billboardColliderPool[i].enabled = false;
                    _billboardColliderPool[i].transform.position = InactivePosition;
                }
            }
            _activeBillboardIndices.Clear();
            _assignedBillboardIndices.Clear();

            // Single pass: assign colliders to unique billboards, grow pool on demand
            int colliderIndex = 0;
            for (int i = 0; i < billboardIndices.Count; i++)
            {
                var billboardIndex = billboardIndices[i];

                // Skip if this billboard already has a collider assigned
                if (!_assignedBillboardIndices.Add(billboardIndex))
                    continue;

                // Grow pool on demand if needed
                if (colliderIndex >= _billboardColliderPool.Count)
                {
                    var go = new GameObject($"BillboardCollider_{colliderIndex}");
                    go.transform.SetParent(_billboardPoolContainer.transform);
                    go.transform.position = InactivePosition;
                    go.layer = _billboardsLayer;
                    var newCollider = go.AddComponent<BoxCollider>();
                    newCollider.enabled = false;
                    _billboardColliderPool.Add(newCollider);
                }

                var collider = _billboardColliderPool[colliderIndex];
                var billboard = billboards[billboardIndex];

                collider.transform.position = billboard.Position;
                collider.transform.rotation = billboard.Rotation;
                collider.size = billboard.Scale;
                collider.enabled = true;

                _activeBillboardIndices.Add(billboardIndex);
                colliderIndex++;
            }

            ActiveBillboardColliderCount = colliderIndex;
        }

        private void DestroyOrphanedContainers(string containerName)
        {
            // Find all GameObjects with this name and destroy them
            // This handles orphaned containers from domain reloads/script recompilation
            // Note: We collect objects first and rename them to avoid infinite loop,
            // because Destroy() is deferred in play mode and GameObject.Find() would
            // keep finding the same undestroyed object.
            var toDestroy = new List<GameObject>();
            var existing = GameObject.Find(containerName);
            while (existing != null)
            {
                toDestroy.Add(existing);
                existing.name = existing.name + "_MarkedForDestroy";
                existing = GameObject.Find(containerName);
            }

            foreach (var obj in toDestroy)
            {
                if (Application.isPlaying)
                    Destroy(obj);
                else
                    DestroyImmediate(obj);
            }
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

            // Draw active building colliders
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

            // Draw active ramp colliders (in different color)
            Gizmos.color = new Color(0.2f, 0.4f, 0.8f, 0.5f);
            foreach (var collider in _rampColliderPool)
            {
                if (collider != null && collider.enabled)
                {
                    var matrix = Matrix4x4.TRS(collider.transform.position, collider.transform.rotation, Vector3.one);
                    Gizmos.matrix = matrix;
                    Gizmos.DrawWireCube(Vector3.zero, collider.size);
                }
            }

            // Draw active billboard colliders (yellow-orange color to match their emissive look)
            Gizmos.color = new Color(1f, 0.6f, 0.1f, 0.5f);
            foreach (var collider in _billboardColliderPool)
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
            // Destroy building colliders and container
            foreach (var collider in _colliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _colliderPool.Clear();

            if (_buildingPoolContainer != null)
            {
                DestroyImmediate(_buildingPoolContainer);
                _buildingPoolContainer = null;
            }

            // Destroy ramp colliders and container
            foreach (var collider in _rampColliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _rampColliderPool.Clear();

            if (_rampPoolContainer != null)
            {
                DestroyImmediate(_rampPoolContainer);
                _rampPoolContainer = null;
            }

            // Destroy billboard colliders and container
            foreach (var collider in _billboardColliderPool)
            {
                if (collider != null)
                    DestroyImmediate(collider.gameObject);
            }
            _billboardColliderPool.Clear();

            if (_billboardPoolContainer != null)
            {
                DestroyImmediate(_billboardPoolContainer);
                _billboardPoolContainer = null;
            }
        }
    }
}
