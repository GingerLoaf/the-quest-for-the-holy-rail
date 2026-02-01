using System.Collections.Generic;
using HolyRail.Graffiti;
using UnityEngine;

namespace HolyRail.City
{
    /// <summary>
    /// Spawns and manages all graffiti spots in the city.
    /// Spots are spawned once and persist - no pooling or activation radius.
    /// </summary>
    [ExecuteInEditMode]
    public class GraffitiSpotPool : MonoBehaviour
    {
        private const string ContainerName = "GraffitiSpots";
        [Header("References")]
        [field: SerializeField] public CityManager CityManager { get; private set; }

        private readonly List<GraffitiSpot> _spots = new();
        private GameObject _container;
        private bool _initialized;

        public int SpotCount => _spots.Count;
        public bool Initialized => _initialized;

        public int CompletedCount
        {
            get
            {
                int count = 0;
                foreach (var spot in _spots)
                {
                    if (spot != null && spot.IsCompleted)
                        count++;
                }
                return count;
            }
        }

        private void Start()
        {
            if (CityManager != null && CityManager.HasGraffitiData)
            {
                Initialize();
            }
        }

        private void Update()
        {
            if (!_initialized && CityManager != null && CityManager.HasGraffitiData)
            {
                Initialize();
            }

            if (_initialized && (CityManager == null || !CityManager.HasGraffitiData))
            {
                Clear();
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
                Debug.LogWarning("GraffitiSpotPool: Cannot initialize - GraffitiSpotPrefab is not assigned.");
                return;
            }

            Clear();
            SpawnAllSpots();
            _initialized = true;

            Debug.Log($"GraffitiSpotPool: Spawned {_spots.Count} graffiti spots.");
        }

        private void SpawnAllSpots()
        {
            _container = new GameObject(ContainerName);
            _container.transform.SetParent(transform);
            _container.transform.localPosition = Vector3.zero;

            var graffitiData = CityManager.GraffitiSpots;
            for (int i = 0; i < graffitiData.Count; i++)
            {
                var data = graffitiData[i];
                var go = Instantiate(CityManager.GraffitiSpotPrefab, _container.transform);
                go.name = $"GraffitiSpot_{i}";
                go.transform.position = data.Position;
                go.transform.rotation = data.Rotation;

                var spot = go.GetComponent<GraffitiSpot>();
                if (spot == null)
                {
                    Debug.LogError($"GraffitiSpotPool: Prefab missing GraffitiSpot component!");
                    DestroyImmediate(go);
                    continue;
                }

                _spots.Add(spot);
            }
        }

        public void ResyncAfterLeapfrog()
        {
            if (CityManager == null || !CityManager.LoopState.IsActive)
                return;

            var loopState = CityManager.LoopState;
            var graffitiData = CityManager.GraffitiSpots;
            var halfBStartIndex = loopState.HalfB.GraffitiStartIndex;
            var halfBOffset = loopState.HalfB.CurrentOffset - loopState.HalfA.CurrentOffset;

            for (int i = 0; i < _spots.Count && i < graffitiData.Count; i++)
            {
                var spot = _spots[i];
                if (spot == null) continue;

                var position = graffitiData[i].Position;
                if (i >= halfBStartIndex)
                {
                    position += halfBOffset;
                }
                spot.transform.position = position;
            }
        }

        public void Clear()
        {
            foreach (var spot in _spots)
            {
                if (spot != null)
                {
                    if (Application.isPlaying)
                        Destroy(spot.gameObject);
                    else
                        DestroyImmediate(spot.gameObject);
                }
            }
            _spots.Clear();

            if (_container != null)
            {
                if (Application.isPlaying)
                    Destroy(_container);
                else
                    DestroyImmediate(_container);
                _container = null;
            }

            // Also destroy any orphaned containers (from domain reloads, etc.)
            DestroyOrphanedContainers();

            _initialized = false;
        }

        private void DestroyOrphanedContainers()
        {
            // Find containers that are children of this transform
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i);
                if (child.name == ContainerName || child.name.StartsWith(ContainerName))
                {
                    if (Application.isPlaying)
                        Destroy(child.gameObject);
                    else
                        DestroyImmediate(child.gameObject);
                }
            }
        }

        /// <summary>
        /// Resets all graffiti spots for soft reset on death.
        /// </summary>
        public void ResetAllGraffiti()
        {
            foreach (var spot in _spots)
            {
                if (spot != null)
                {
                    spot.ResetForPoolReuse();
                }
            }

            Debug.Log("[GraffitiSpotPool] Reset all graffiti for soft reset.");
        }

        private void OnDestroy()
        {
            Clear();
        }
    }
}
