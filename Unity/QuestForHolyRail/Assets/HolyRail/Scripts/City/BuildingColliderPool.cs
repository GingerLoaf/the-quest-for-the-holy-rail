using System.Collections;
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
        [field: SerializeField] public Transform TrackingTarget { get; set; }

        [Header("Pool Settings")]
        [field: SerializeField] public float ActivationRadius { get; private set; } = 150f;
        [field: SerializeField] public float UpdateDistanceThreshold { get; private set; } = 25f;

        [Header("Layer Settings")]
        [field: SerializeField] public int BillboardLayerFallback { get; private set; } = 7;

        [Header("Debug")]
        [field: SerializeField] public bool ShowDebugGizmos { get; private set; }

        private static readonly Vector3 InactivePosition = new(0, -1000f, 0);

        private SpatialGrid<BuildingData> _spatialGrid;
        private readonly List<BoxCollider> _colliderPool = new();
        private readonly List<int> _activeIndices = new();
        private readonly List<int> _queryResults = new();
        private readonly HashSet<int> _assignedBuildingIndices = new();
        private GameObject _buildingPoolContainer;
        private Vector3 _lastUpdatePosition;
        private int _buildingsLayer;
        private bool _initialized;
        private int _playerSearchFrame; // Throttle player search

        // Ramp collider pool
        private SpatialGrid<RampData> _rampSpatialGrid;
        private readonly List<BoxCollider> _rampColliderPool = new();
        private readonly List<int> _activeRampIndices = new();
        private readonly List<int> _rampQueryResults = new();
        private readonly HashSet<int> _assignedRampIndices = new();
        private GameObject _rampPoolContainer;
        private int _rampLayer;
        private bool _rampInitialized;

        // Billboard collider pool
        private SpatialGrid<BillboardData> _billboardSpatialGrid;
        private readonly List<BoxCollider> _billboardColliderPool = new();
        private readonly List<int> _activeBillboardIndices = new();
        private readonly List<int> _billboardQueryResults = new();
        private readonly HashSet<int> _assignedBillboardIndices = new();
        private GameObject _billboardPoolContainer;
        private int _billboardsLayer;
        private bool _billboardInitialized;
        private bool _subscribedToEvents;

        public int ActiveColliderCount { get; private set; }
        public int TotalPoolSize => _colliderPool.Count;
        public bool Initialized => _initialized;

        public int ActiveRampColliderCount { get; private set; }
        public int TotalRampPoolSize => _rampColliderPool.Count;
        public bool RampInitialized => _rampInitialized;

        public int ActiveBillboardColliderCount { get; private set; }
        public int TotalBillboardPoolSize => _billboardColliderPool.Count;
        public bool BillboardInitialized => _billboardInitialized;

        private void OnEnable()
        {
            SubscribeToEvents();
        }

        private void OnDisable()
        {
            UnsubscribeFromEvents();
        }

        private void SubscribeToEvents()
        {
            if (_subscribedToEvents)
                return;

            if (CityManager != null)
            {
                CityManager.OnCityRegenerated += HandleCityRegenerated;
                _subscribedToEvents = true;
                Debug.Log("BuildingColliderPool: Subscribed to CityManager.OnCityRegenerated");
            }
            else
            {
                Debug.LogWarning("BuildingColliderPool: CityManager is null, cannot subscribe to events");
            }
        }

        private void UnsubscribeFromEvents()
        {
            if (CityManager != null && _subscribedToEvents)
            {
                CityManager.OnCityRegenerated -= HandleCityRegenerated;
                _subscribedToEvents = false;
            }
        }

        private void HandleCityRegenerated()
        {
            Debug.Log($"BuildingColliderPool: City regenerated - HasData:{CityManager?.HasData}, HasRampData:{CityManager?.HasRampData}, HasBillboardData:{CityManager?.HasBillboardData}");

            // Clear and reinitialize all collider pools when city regenerates
            Clear();

            if (CityManager != null)
            {
                if (CityManager.HasData)
                    Initialize();
                if (CityManager.HasRampData)
                    InitializeRamps();
                if (CityManager.HasBillboardData)
                    InitializeBillboards();
            }
        }

        private void Start()
        {
            // Ensure we're subscribed (in case CityManager was assigned after OnEnable)
            SubscribeToEvents();

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
            // Ensure we're subscribed to events (handles case where CityManager was assigned after OnEnable)
            if (!_subscribedToEvents && CityManager != null)
            {
                SubscribeToEvents();
            }

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

            // Auto-find player if TrackingTarget not assigned (throttle search to every 30 frames)
            if (TrackingTarget == null)
            {
                _playerSearchFrame++;
                if (_playerSearchFrame < 30)
                    return;

                _playerSearchFrame = 0;
                var player = GameObject.FindGameObjectWithTag("Player");
                if (player != null)
                {
                    TrackingTarget = player.transform;
                    Debug.Log($"BuildingColliderPool: Auto-assigned TrackingTarget to {player.name}");
                }
                else
                {
                    return;
                }
            }

            var currentPosition = TrackingTarget.position;
            var delta = currentPosition - _lastUpdatePosition;
            var distanceMovedSq = delta.sqrMagnitude;
            var thresholdSq = UpdateDistanceThreshold * UpdateDistanceThreshold;

            if (distanceMovedSq >= thresholdSq)
            {
                if (_initialized)
                    UpdateActiveColliders(currentPosition);
                if (_rampInitialized)
                    UpdateActiveRampColliders(currentPosition);
                if (_billboardInitialized)
                    UpdateActiveBillboardColliders(currentPosition);
                _lastUpdatePosition = currentPosition;

#if UNITY_EDITOR
                Debug.Log($"BuildingColliderPool: Updated colliders at {currentPosition} - Buildings:{ActiveColliderCount}, Ramps:{ActiveRampColliderCount}, Billboards:{ActiveBillboardColliderCount}");
#endif
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

            _spatialGrid = new SpatialGrid<BuildingData>(
                DefaultCellSize,
                CityManager.transform.position,
                b => b.Position,
                b => b.NeedsCollider != 0);
            _spatialGrid.Initialize(CityManager.Buildings);

            CreateColliderPool();

            _initialized = true;

            // Use tracking target position, or fallback to CityManager position
            var queryPosition = TrackingTarget != null ? TrackingTarget.position : CityManager.transform.position;
            _lastUpdatePosition = queryPosition;
            UpdateActiveColliders(queryPosition);

            Debug.Log($"BuildingColliderPool: Initialized with {_colliderPool.Count} building colliders at {queryPosition}, spatial grid has {_spatialGrid.CellCount} cells.");
        }

        public void InitializeRamps()
        {
            if (CityManager == null)
            {
                Debug.LogWarning("BuildingColliderPool.InitializeRamps: CityManager is null");
                return;
            }
            if (!CityManager.HasRampData)
            {
                Debug.Log($"BuildingColliderPool.InitializeRamps: No ramp data (Ramps count: {CityManager.Ramps?.Count ?? 0})");
                return;
            }

            // Use dedicated Ramp layer for ramp colliders (allows player controller to detect and boost)
            var rampLayer = LayerMask.NameToLayer("Ramp");
            if (rampLayer == -1)
            {
                Debug.LogWarning("BuildingColliderPool: 'Ramp' layer not found. Using Buildings layer as fallback.");
                rampLayer = LayerMask.NameToLayer("Buildings");
                if (rampLayer == -1)
                    rampLayer = 0;
            }
            _rampLayer = rampLayer;

            Debug.Log($"BuildingColliderPool.InitializeRamps: Initializing with {CityManager.Ramps.Count} ramps, layer={_rampLayer}");

            _rampSpatialGrid = new SpatialGrid<RampData>(
                DefaultCellSize,
                CityManager.transform.position,
                r => r.Position);
            _rampSpatialGrid.Initialize(CityManager.Ramps);

            CreateRampColliderPool();

            _rampInitialized = true;

            // Use tracking target position, or fallback to CityManager position
            var queryPosition = TrackingTarget != null ? TrackingTarget.position : CityManager.transform.position;
            UpdateActiveRampColliders(queryPosition);
            _lastUpdatePosition = queryPosition;
            Debug.Log($"BuildingColliderPool.InitializeRamps: Updated active colliders at {queryPosition}, ActiveRampColliderCount={ActiveRampColliderCount}");

            Debug.Log($"BuildingColliderPool: Initialized with {_rampColliderPool.Count} ramp colliders, spatial grid has {_rampSpatialGrid.CellCount} cells.");
        }

        public void InitializeBillboards()
        {
            if (CityManager == null)
            {
                Debug.LogWarning("BuildingColliderPool.InitializeBillboards: CityManager is null");
                return;
            }
            if (!CityManager.HasBillboardData)
            {
                Debug.Log($"BuildingColliderPool.InitializeBillboards: No billboard data (Billboards count: {CityManager.Billboards?.Count ?? 0})");
                return;
            }

            // Billboards use WallRide layer so player can wall-ride on them
            _billboardsLayer = LayerMask.NameToLayer("WallRide");
            if (_billboardsLayer == -1)
            {
                _billboardsLayer = BillboardLayerFallback;
                Debug.LogWarning($"BuildingColliderPool: 'WallRide' layer not found, using fallback layer {_billboardsLayer}");
            }

            Debug.Log($"BuildingColliderPool.InitializeBillboards: Initializing with {CityManager.Billboards.Count} billboards, layer={_billboardsLayer}");

            _billboardSpatialGrid = new SpatialGrid<BillboardData>(
                DefaultCellSize,
                CityManager.transform.position,
                b => b.Position);
            _billboardSpatialGrid.Initialize(CityManager.Billboards);

            CreateBillboardColliderPool();

            _billboardInitialized = true;

            // Use tracking target position, or fallback to CityManager position
            var queryPosition = TrackingTarget != null ? TrackingTarget.position : CityManager.transform.position;
            UpdateActiveBillboardColliders(queryPosition);
            _lastUpdatePosition = queryPosition;
            Debug.Log($"BuildingColliderPool.InitializeBillboards: Updated active colliders at {queryPosition}, ActiveBillboardColliderCount={ActiveBillboardColliderCount}");

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

            _spatialGrid.GetItemsInBounds(bounds, _queryResults);
            ActivateCollidersForBuildings(_queryResults);
        }

        /// <summary>
        /// Updates spatial grid query offsets after a loop mode leapfrog operation.
        /// Uses offset-based approach instead of rebuilding grids for better performance.
        /// Called by CityManager when half offsets have changed.
        /// </summary>
        public void ResyncAfterLeapfrog()
        {
            var sw = System.Diagnostics.Stopwatch.StartNew();

            if (CityManager == null || !CityManager.LoopState.IsActive)
            {
                // Clear any existing offsets if loop mode is not active
                _spatialGrid?.ClearQueryOffset();
                _rampSpatialGrid?.ClearQueryOffset();
                _billboardSpatialGrid?.ClearQueryOffset();
                return;
            }

            var loopState = CityManager.LoopState;

            // Update building spatial grid offset
            if (_initialized && _spatialGrid != null)
            {
                var offset = loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset;
                _spatialGrid.SetQueryOffset(offset, loopState.HalfB.BuildingStartIndex);
            }

            // Update ramp spatial grid offset
            if (_rampInitialized && _rampSpatialGrid != null)
            {
                var offset = loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset;
                _rampSpatialGrid.SetQueryOffset(offset, loopState.HalfB.RampStartIndex);
            }

            // Update billboard spatial grid offset
            if (_billboardInitialized && _billboardSpatialGrid != null)
            {
                var offset = loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset;
                _billboardSpatialGrid.SetQueryOffset(offset, loopState.HalfB.BillboardStartIndex);
            }

            var offsetTime = sw.ElapsedMilliseconds;

            // Force update active colliders if we have a tracking target
            if (TrackingTarget != null)
            {
                var currentPosition = TrackingTarget.position;
                if (_initialized)
                    UpdateActiveColliders(currentPosition);
                if (_rampInitialized)
                    UpdateActiveRampColliders(currentPosition);
                if (_billboardInitialized)
                    UpdateActiveBillboardColliders(currentPosition);
                _lastUpdatePosition = currentPosition;
            }

            var totalTime = sw.ElapsedMilliseconds;
            Debug.Log($"BuildingColliderPool: Resync after leapfrog - Offsets:{offsetTime}ms, Colliders:{totalTime - offsetTime}ms, Total:{totalTime}ms");
        }

        /// <summary>
        /// Async version - now instant since we use offset-based approach.
        /// Kept for API compatibility but simply calls the synchronous version.
        /// </summary>
        public void ResyncAfterLeapfrogAsync()
        {
            // With offset-based approach, this is instant - no need for coroutine
            ResyncAfterLeapfrog();
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

            _spatialGrid.GetItemsInRadius(center, ActivationRadius, _queryResults);
            ActivateCollidersForBuildings(_queryResults);
        }

        private void ActivateCollidersForBuildings(List<int> buildingIndices)
        {
            var buildings = CityManager.Buildings;

            // Get loop mode offset info
            var loopState = CityManager?.LoopState;
            var isLoopMode = loopState != null && loopState.IsActive;
            var halfBStartIndex = isLoopMode ? loopState.HalfB.BuildingStartIndex : int.MaxValue;
            var halfBOffset = isLoopMode ? (loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset) : Vector3.zero;

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

                // Apply offset for HalfB instances in loop mode
                var position = building.Position;
                if (buildingIndex >= halfBStartIndex)
                {
                    position += halfBOffset;
                }

                collider.transform.position = position;
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

            _rampSpatialGrid.GetItemsInRadius(center, ActivationRadius, _rampQueryResults);
            ActivateCollidersForRamps(_rampQueryResults);
        }

        private void ActivateCollidersForRamps(List<int> rampIndices)
        {
            var ramps = CityManager.Ramps;

            // Get loop mode offset info
            var loopState = CityManager?.LoopState;
            var isLoopMode = loopState != null && loopState.IsActive;
            var halfBStartIndex = isLoopMode ? loopState.HalfB.RampStartIndex : int.MaxValue;
            var halfBOffset = isLoopMode ? (loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset) : Vector3.zero;

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
                    go.layer = _rampLayer;
                    var newCollider = go.AddComponent<BoxCollider>();
                    newCollider.enabled = false;
                    _rampColliderPool.Add(newCollider);
                }

                var collider = _rampColliderPool[colliderIndex];
                var ramp = ramps[rampIndex];

                // Apply offset for HalfB instances in loop mode
                var position = ramp.Position;
                if (rampIndex >= halfBStartIndex)
                {
                    position += halfBOffset;
                }

                collider.transform.position = position;
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

            _billboardSpatialGrid.GetItemsInRadius(center, ActivationRadius, _billboardQueryResults);
            ActivateCollidersForBillboards(_billboardQueryResults);
        }

        private void ActivateCollidersForBillboards(List<int> billboardIndices)
        {
            var billboards = CityManager.Billboards;

            // Get loop mode offset info
            var loopState = CityManager?.LoopState;
            var isLoopMode = loopState != null && loopState.IsActive;
            var halfBStartIndex = isLoopMode ? loopState.HalfB.BillboardStartIndex : int.MaxValue;
            var halfBOffset = isLoopMode ? (loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset) : Vector3.zero;

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

                // Apply offset for HalfB instances in loop mode
                var position = billboard.Position;
                if (billboardIndex >= halfBStartIndex)
                {
                    position += halfBOffset;
                }

                collider.transform.position = position;
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
