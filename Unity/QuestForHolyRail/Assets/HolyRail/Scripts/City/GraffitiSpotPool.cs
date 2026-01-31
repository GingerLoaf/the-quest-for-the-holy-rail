using System.Collections.Generic;
using HolyRail.Graffiti;
using UnityEngine;

namespace HolyRail.City
{
    [ExecuteInEditMode]
    public class GraffitiSpotPool : MonoBehaviour
    {
        private const float DefaultCellSize = 50f;

        [Header("References")]
        [field: SerializeField] public CityManager CityManager { get; private set; }
        [field: SerializeField] public Transform TrackingTarget { get; private set; }

        [Header("Pool Settings")]
        [field: SerializeField] public float ActivationRadius { get; private set; } = 100f;
        [field: SerializeField] public float UpdateDistanceThreshold { get; private set; } = 25f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowDebugGizmos { get; private set; }

        private static readonly Vector3 InactivePosition = new(0, -1000f, 0);

        private SpatialGrid<GraffitiSpotData> _spatialGrid;
        private readonly List<GraffitiSpot> _pool = new();
        private readonly List<int> _activeIndices = new();
        private readonly List<int> _queryResults = new();
        private readonly HashSet<int> _assignedSpotIndices = new();

        // Tracks which graffiti spots have been completed by the player.
        // DESIGN NOTE: This set is intentionally never cleared across Clear() calls or leapfrogs
        // to preserve player completion state during gameplay. In extended sessions with loop mode,
        // this may grow unboundedly (~12 bytes per entry). For typical gameplay this is negligible,
        // but consider implementing a size cap with LRU eviction if extended sessions cause issues.
        private readonly HashSet<int> _completedSpotIndices = new();
        private GameObject _poolContainer;
        private Vector3 _lastUpdatePosition;
        private bool _initialized;

        public int ActiveSpotCount { get; private set; }
        public int TotalPoolSize => _pool.Count;
        public bool Initialized => _initialized;

        private void Start()
        {
            if (CityManager != null && CityManager.HasGraffitiData)
            {
                Initialize();
            }
        }

        private void Update()
        {
            // Initialize if needed
            if (!_initialized)
            {
                if (CityManager != null && CityManager.HasGraffitiData)
                    Initialize();
            }

            // Detect when graffiti data has been cleared
            if (_initialized && (CityManager == null || !CityManager.HasGraffitiData))
            {
                Clear();
                return;
            }

            if (TrackingTarget == null)
                return;

            var currentPosition = TrackingTarget.position;
            var delta = currentPosition - _lastUpdatePosition;
            var distanceMovedSq = delta.sqrMagnitude;
            var thresholdSq = UpdateDistanceThreshold * UpdateDistanceThreshold;

            if (distanceMovedSq >= thresholdSq)
            {
                if (_initialized)
                    UpdateActiveSpots(currentPosition);
                _lastUpdatePosition = currentPosition;
            }
        }

        public void Initialize()
        {
            if (CityManager == null || !CityManager.HasGraffitiData)
            {
                Debug.LogWarning("GraffitiSpotPool: Cannot initialize - CityManager has no graffiti data.");
                return;
            }

            if (CityManager.GraffitiSpotPrefab == null)
            {
                Debug.LogWarning("GraffitiSpotPool: Cannot initialize - GraffitiSpotPrefab is not assigned on CityManager.");
                return;
            }

            _spatialGrid = new SpatialGrid<GraffitiSpotData>(
                DefaultCellSize,
                CityManager.transform.position,
                g => g.Position);
            _spatialGrid.Initialize(CityManager.GraffitiSpots);

            CreatePool();

            _initialized = true;

            if (TrackingTarget != null)
            {
                _lastUpdatePosition = TrackingTarget.position;
                UpdateActiveSpots(_lastUpdatePosition);
            }

            Debug.Log($"GraffitiSpotPool: Initialized with spatial grid of {_spatialGrid.CellCount} cells for {CityManager.GraffitiSpots.Count} graffiti spots.");
        }

        public void RefreshSpots()
        {
            if (!_initialized && CityManager != null && CityManager.HasGraffitiData)
            {
                Initialize();
                return;
            }

            if (!_initialized)
                return;

            var position = TrackingTarget != null ? TrackingTarget.position : transform.position;
            UpdateActiveSpots(position);
            _lastUpdatePosition = position;
        }

        public void ResyncAfterLeapfrog()
        {
            if (CityManager == null || !CityManager.LoopState.IsActive)
            {
                _spatialGrid?.ClearQueryOffset();
                return;
            }

            var loopState = CityManager.LoopState;

            if (_initialized && _spatialGrid != null)
            {
                var offset = loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset;
                _spatialGrid.SetQueryOffset(offset, loopState.HalfB.GraffitiStartIndex);
            }

            // Force update active spots if we have a tracking target
            if (TrackingTarget != null)
            {
                var currentPosition = TrackingTarget.position;
                if (_initialized)
                    UpdateActiveSpots(currentPosition);
                _lastUpdatePosition = currentPosition;
            }
        }

        public void Clear()
        {
            // Destroy all pooled graffiti spots
            foreach (var spot in _pool)
            {
                if (spot != null)
                {
                    if (Application.isPlaying)
                        Destroy(spot.gameObject);
                    else
                        DestroyImmediate(spot.gameObject);
                }
            }
            _pool.Clear();

            // Destroy the pool container
            if (_poolContainer != null)
            {
                if (Application.isPlaying)
                    Destroy(_poolContainer);
                else
                    DestroyImmediate(_poolContainer);
                _poolContainer = null;
            }

            _activeIndices.Clear();
            _queryResults.Clear();
            _assignedSpotIndices.Clear();
            // Note: Don't clear _completedSpotIndices - we want to remember which were completed
            _spatialGrid = null;
            _initialized = false;
            ActiveSpotCount = 0;
        }

        private void CreatePool()
        {
            const string containerName = "GraffitiSpots_Pool";

            // Clear existing pool
            foreach (var spot in _pool)
            {
                if (spot != null)
                    DestroyImmediate(spot.gameObject);
            }
            _pool.Clear();
            _activeIndices.Clear();

            // Destroy old container if it exists
            if (_poolContainer != null)
            {
                DestroyImmediate(_poolContainer);
                _poolContainer = null;
            }

            // Find and destroy any orphaned containers from domain reloads
            DestroyOrphanedContainers(containerName);

            // Create pool container (starts empty, spots created on-demand)
            _poolContainer = new GameObject(containerName);
            _poolContainer.transform.SetParent(transform);
            _poolContainer.transform.localPosition = Vector3.zero;
        }

        private void UpdateActiveSpots(Vector3 center)
        {
            if (_spatialGrid == null)
                return;

            _spatialGrid.GetItemsInRadius(center, ActivationRadius, _queryResults);
            ActivateSpotsForIndices(_queryResults);
        }

        private void ActivateSpotsForIndices(List<int> spotIndices)
        {
            var graffitiSpots = CityManager.GraffitiSpots;

            // Get loop mode offset info
            var loopState = CityManager?.LoopState;
            var isLoopMode = loopState != null && loopState.IsActive;
            var halfBStartIndex = isLoopMode ? loopState.HalfB.GraffitiStartIndex : int.MaxValue;
            var halfBOffset = isLoopMode ? (loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset) : Vector3.zero;

            // Deactivate all spots first and move them out of the way
            for (int i = 0; i < _pool.Count; i++)
            {
                if (_pool[i] != null)
                {
                    _pool[i].gameObject.SetActive(false);
                    _pool[i].transform.position = InactivePosition;
                }
            }
            _activeIndices.Clear();
            _assignedSpotIndices.Clear();

            // Single pass: assign spots to unique indices, grow pool on demand
            int poolIndex = 0;
            for (int i = 0; i < spotIndices.Count; i++)
            {
                var spotIndex = spotIndices[i];

                // Skip if this spot already has a prefab assigned
                if (!_assignedSpotIndices.Add(spotIndex))
                    continue;

                // Skip if this spot was already completed
                if (_completedSpotIndices.Contains(spotIndex))
                    continue;

                // Grow pool on demand if needed
                if (poolIndex >= _pool.Count)
                {
                    var go = Instantiate(CityManager.GraffitiSpotPrefab, _poolContainer.transform);
                    go.name = $"GraffitiSpot_{poolIndex}";
                    go.transform.position = InactivePosition;
                    go.SetActive(false);
                    var graffitiSpot = go.GetComponent<GraffitiSpot>();
                    if (graffitiSpot == null)
                    {
                        Debug.LogError("GraffitiSpotPool: GraffitiSpotPrefab doesn't have a GraffitiSpot component!");
                        DestroyImmediate(go);
                        continue;
                    }
                    _pool.Add(graffitiSpot);
                }

                var spot = _pool[poolIndex];
                var data = graffitiSpots[spotIndex];

                spot.ResetForPoolReuse();

                // Apply offset for HalfB instances in loop mode
                var position = data.Position;
                if (spotIndex >= halfBStartIndex)
                {
                    position += halfBOffset;
                }

                spot.transform.position = position;
                spot.transform.rotation = data.Rotation;
                spot.gameObject.SetActive(true);

                // Track if this spot gets completed
                if (spot.IsCompleted)
                {
                    _completedSpotIndices.Add(spotIndex);
                }

                _activeIndices.Add(spotIndex);
                poolIndex++;
            }

            ActiveSpotCount = poolIndex;
        }

        private void DestroyOrphanedContainers(string containerName)
        {
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
                Gizmos.color = new Color(1f, 0.5f, 0f, 0.3f);
                DrawCircle(TrackingTarget.position + Vector3.up * 2f, ActivationRadius, 32);

                Gizmos.color = new Color(1f, 0.8f, 0f, 0.3f);
                DrawCircle(TrackingTarget.position + Vector3.up * 2f, UpdateDistanceThreshold, 16);
            }

            // Draw active graffiti spots
            Gizmos.color = new Color(1f, 0f, 0.5f, 0.7f);
            foreach (var spot in _pool)
            {
                if (spot != null && spot.gameObject.activeSelf)
                {
                    Gizmos.DrawWireSphere(spot.transform.position, 1f);
                }
            }
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
            foreach (var spot in _pool)
            {
                if (spot != null)
                    DestroyImmediate(spot.gameObject);
            }
            _pool.Clear();

            if (_poolContainer != null)
            {
                DestroyImmediate(_poolContainer);
                _poolContainer = null;
            }
        }
    }
}
