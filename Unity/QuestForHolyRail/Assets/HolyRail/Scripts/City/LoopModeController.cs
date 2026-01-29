using System.Collections.Generic;
using UnityEngine;
using HolyRail.Vines;

namespace HolyRail.City
{
    /// <summary>
    /// Runtime controller for loop mode that tracks player progress through the corridor
    /// and triggers leapfrog swaps when the player reaches the threshold.
    /// </summary>
    public class LoopModeController : MonoBehaviour
    {
        [Header("References")]
        [field: SerializeField] public CityManager CityManager { get; set; }
        [field: SerializeField] public VineGenerator VineGenerator { get; set; }
        [field: SerializeField] public Transform PlayerTransform { get; set; }

        [Header("Leapfrog Settings")]
        [field: SerializeField, Range(0.1f, 0.5f)]
        public float LeapfrogTriggerProgress { get; set; } = 0.33f;

        [field: SerializeField]
        public float JunctionBufferDistance { get; set; } = 5f;

        [Header("Debug")]
        [field: SerializeField] public bool ShowDebugInfo { get; set; } = false;

        // Internal state
        private LoopModeState _loopState;
        private bool _isActive;
        private float _lastPlayerProgress;
        private int _leapfrogCount;

        // Cached values for progress calculation
        private List<float> _frontHalfDistances = new List<float>();
        private List<float> _backHalfDistances = new List<float>();
        private float _frontHalfTotalLength;
        private float _backHalfTotalLength;

        // Simpler distance-based tracking (more robust at distance)
        private float _totalDistanceTraveled;
        private Vector3 _lastPlayerPosition;
        private bool _hasLastPosition;

        public bool IsActive => _isActive;
        public float PlayerProgress => _lastPlayerProgress;
        public int LeapfrogCount => _leapfrogCount;

        private void Start()
        {
            if (CityManager == null)
            {
                CityManager = FindAnyObjectByType<CityManager>();
            }

            if (VineGenerator == null)
            {
                VineGenerator = FindAnyObjectByType<VineGenerator>();
            }

            // Try to find player if not assigned
            if (PlayerTransform == null)
            {
                var player = GameObject.FindWithTag("Player");
                if (player != null)
                {
                    PlayerTransform = player.transform;
                }
            }

            Initialize();
        }

        private void Update()
        {
            if (!_isActive || PlayerTransform == null)
                return;

            // Initialize last position on first frame if needed
            if (!_hasLastPosition)
            {
                _lastPlayerPosition = PlayerTransform.position;
                _hasLastPosition = true;
                return;
            }

            // Track forward progress using dot product with corridor direction
            // This is more robust than path-based tracking at large distances
            Vector3 currentPos = PlayerTransform.position;
            Vector3 movement = currentPos - _lastPlayerPosition;
            float forwardMovement = Vector3.Dot(movement, _loopState.ForwardDirection);

            // Only count forward movement (ignore backwards or lateral movement)
            if (forwardMovement > 0)
            {
                _totalDistanceTraveled += forwardMovement;
            }
            _lastPlayerPosition = currentPos;

            // Calculate progress within the current "lap" of the back half
            // Each leapfrog moves the player conceptually back by HalfLength
            float progressInBackHalf = _totalDistanceTraveled / _loopState.HalfLength;

            // Also calculate path-based progress for debug visualization
            float pathProgress = CalculatePlayerProgress();
            _lastPlayerProgress = pathProgress;

            // Trigger leapfrog when we've traveled past the first half and into the second
            // progressInBackHalf > 1.0 means we've traveled more than one half-length
            // Add LeapfrogTriggerProgress as buffer (e.g., 1.33 = 33% into second half)
            if (progressInBackHalf > 1.0f + LeapfrogTriggerProgress)
            {
                // Check buffer zone around junction to avoid visual glitches
                if (!IsNearJunction())
                {
                    PerformLeapfrog();
                    // Reduce by one half-length, not reset to 0
                    // This maintains correct tracking for subsequent leapfrogs
                    _totalDistanceTraveled -= _loopState.HalfLength;
                }
            }

            if (ShowDebugInfo)
            {
                Debug.Log($"LoopMode: DistanceTraveled={_totalDistanceTraveled:F2}, ProgressInHalf={progressInBackHalf:F2}, PathProgress={pathProgress:F2}, LeapfrogCount={_leapfrogCount}");
            }
        }

        public void Initialize()
        {
            if (CityManager == null || !CityManager.IsLoopMode)
            {
                _isActive = false;
                return;
            }

            _loopState = CityManager.LoopState;
            if (_loopState == null || !_loopState.IsActive)
            {
                _isActive = false;
                return;
            }

            // Precalculate distances along each half for progress calculation
            CachePathDistances();

            _isActive = true;
            _leapfrogCount = 0;

            // Initialize distance tracking
            if (PlayerTransform != null)
            {
                _lastPlayerPosition = PlayerTransform.position;
                _hasLastPosition = true;
            }
            _totalDistanceTraveled = 0f;

            Debug.Log($"LoopModeController: Initialized. Front half has {_loopState.HalfA.PathPoints.Count} points, " +
                      $"Back half has {_loopState.HalfB.PathPoints.Count} points");
        }

        private void CachePathDistances()
        {
            // Cache front half distances
            _frontHalfDistances.Clear();
            _frontHalfTotalLength = 0f;

            var frontHalf = CityManager.GetFrontHalf();
            if (frontHalf != null && frontHalf.PathPoints.Count > 0)
            {
                _frontHalfDistances.Add(0f);
                for (int i = 1; i < frontHalf.PathPoints.Count; i++)
                {
                    _frontHalfTotalLength += Vector3.Distance(frontHalf.PathPoints[i - 1], frontHalf.PathPoints[i]);
                    _frontHalfDistances.Add(_frontHalfTotalLength);
                }
            }

            // Cache back half distances
            _backHalfDistances.Clear();
            _backHalfTotalLength = 0f;

            var backHalf = CityManager.GetBackHalf();
            if (backHalf != null && backHalf.PathPoints.Count > 0)
            {
                _backHalfDistances.Add(0f);
                for (int i = 1; i < backHalf.PathPoints.Count; i++)
                {
                    _backHalfTotalLength += Vector3.Distance(backHalf.PathPoints[i - 1], backHalf.PathPoints[i]);
                    _backHalfDistances.Add(_backHalfTotalLength);
                }
            }
        }

        private float CalculatePlayerProgress()
        {
            if (PlayerTransform == null || _loopState == null)
                return 0f;

            var playerPos = PlayerTransform.position;

            // Find nearest point on front half
            float distToFront = GetDistanceToPath(playerPos, CityManager.GetFrontHalf()?.PathPoints);
            float progressInFront = GetProgressAlongPath(playerPos, CityManager.GetFrontHalf()?.PathPoints, _frontHalfDistances, _frontHalfTotalLength);

            // Find nearest point on back half
            float distToBack = GetDistanceToPath(playerPos, CityManager.GetBackHalf()?.PathPoints);
            float progressInBack = GetProgressAlongPath(playerPos, CityManager.GetBackHalf()?.PathPoints, _backHalfDistances, _backHalfTotalLength);

            // Determine which half the player is in
            if (distToFront < distToBack)
            {
                // In front half: progress is 0.0 to 0.5
                return progressInFront * 0.5f;
            }
            else
            {
                // In back half: progress is 0.5 to 1.0
                return 0.5f + progressInBack * 0.5f;
            }
        }

        private float GetDistanceToPath(Vector3 position, List<Vector3> pathPoints)
        {
            if (pathPoints == null || pathPoints.Count == 0)
                return float.MaxValue;

            float minDist = float.MaxValue;

            for (int i = 0; i < pathPoints.Count - 1; i++)
            {
                float dist = DistanceToLineSegment(position, pathPoints[i], pathPoints[i + 1]);
                minDist = Mathf.Min(minDist, dist);
            }

            return minDist;
        }

        private float GetProgressAlongPath(Vector3 position, List<Vector3> pathPoints, List<float> distances, float totalLength)
        {
            if (pathPoints == null || pathPoints.Count < 2 || totalLength <= 0f)
                return 0f;

            // Find the nearest segment
            float minDist = float.MaxValue;
            int nearestSegment = 0;
            float nearestT = 0f;

            for (int i = 0; i < pathPoints.Count - 1; i++)
            {
                float t;
                float dist = DistanceToLineSegmentWithT(position, pathPoints[i], pathPoints[i + 1], out t);

                if (dist < minDist)
                {
                    minDist = dist;
                    nearestSegment = i;
                    nearestT = t;
                }
            }

            // Calculate progress along the path
            float segmentStartDist = distances[nearestSegment];
            float segmentLength = Vector3.Distance(pathPoints[nearestSegment], pathPoints[nearestSegment + 1]);
            float distanceAlongPath = segmentStartDist + nearestT * segmentLength;

            return distanceAlongPath / totalLength;
        }

        private float DistanceToLineSegment(Vector3 point, Vector3 lineStart, Vector3 lineEnd)
        {
            float t;
            return DistanceToLineSegmentWithT(point, lineStart, lineEnd, out t);
        }

        private float DistanceToLineSegmentWithT(Vector3 point, Vector3 lineStart, Vector3 lineEnd, out float t)
        {
            var line = lineEnd - lineStart;
            var toPoint = point - lineStart;

            float lineLengthSq = line.sqrMagnitude;
            if (lineLengthSq < 0.0001f)
            {
                t = 0f;
                return Vector3.Distance(point, lineStart);
            }

            t = Mathf.Clamp01(Vector3.Dot(toPoint, line) / lineLengthSq);
            var closest = lineStart + line * t;

            return Vector3.Distance(point, closest);
        }

        private bool IsInBackHalf(float progress)
        {
            return progress >= 0.5f;
        }

        private float GetProgressInBackHalf(float progress)
        {
            // Convert overall progress (0.5-1.0) to back half progress (0.0-1.0)
            return (progress - 0.5f) * 2f;
        }

        private bool IsNearJunction()
        {
            if (PlayerTransform == null)
                return false;

            var playerPos = PlayerTransform.position;

            // Check distance to front half end (junction with back half)
            var frontHalf = CityManager.GetFrontHalf();
            if (frontHalf != null && frontHalf.PathPoints.Count > 0)
            {
                var junctionPoint = frontHalf.PathPoints[frontHalf.PathPoints.Count - 1];
                if (Vector3.Distance(playerPos, junctionPoint) < JunctionBufferDistance)
                {
                    return true;
                }
            }

            // Check distance to back half start (junction with front half)
            var backHalf = CityManager.GetBackHalf();
            if (backHalf != null && backHalf.PathPoints.Count > 0)
            {
                var junctionPoint = backHalf.PathPoints[0];
                if (Vector3.Distance(playerPos, junctionPoint) < JunctionBufferDistance)
                {
                    return true;
                }
            }

            return false;
        }

        private void PerformLeapfrog()
        {
            if (!_isActive || CityManager == null)
                return;

            Debug.Log($"LoopModeController: Performing leapfrog #{_leapfrogCount + 1}");

            // Determine which half the player is PHYSICALLY in by comparing distance to each half's path
            var playerPos = PlayerTransform.position;
            var halfA = _loopState.HalfA;
            var halfB = _loopState.HalfB;

            float distToA = GetMinDistanceToPath(playerPos, halfA.PathPoints);
            float distToB = GetMinDistanceToPath(playerPos, halfB.PathPoints);

            // Player is in whichever half they're closer to
            bool playerInHalfA = distToA < distToB;

            // Move the OTHER half (the one player is NOT in) ahead
            int halfToMoveId = playerInHalfA ? 1 : 0;

            Vector3 offset = _loopState.ForwardDirection * _loopState.HalfLength * 2f;

            // 1. Move vines for that half
            if (VineGenerator != null)
            {
                VineGenerator.MoveVineHalf(halfToMoveId, offset);
            }

            // 2. Move city geometry for that half
            CityManager.MoveHalf(halfToMoveId, offset);

            // 3. Recache path distances after move
            CachePathDistances();

            _leapfrogCount++;

            Debug.Log($"LoopModeController: Leapfrog complete. Moved half {halfToMoveId} ahead (player in half {(playerInHalfA ? 0 : 1)}). Total leapfrogs: {_leapfrogCount}");
        }

        private float GetMinDistanceToPath(Vector3 pos, List<Vector3> pathPoints)
        {
            if (pathPoints == null || pathPoints.Count == 0)
                return float.MaxValue;

            float minDist = float.MaxValue;
            foreach (var point in pathPoints)
            {
                float dist = Vector3.Distance(pos, point);
                minDist = Mathf.Min(minDist, dist);
            }
            return minDist;
        }

        private void OnDrawGizmosSelected()
        {
            if (!_isActive || _loopState == null)
                return;

            // Draw front half path in green
            var frontHalf = CityManager?.GetFrontHalf();
            if (frontHalf != null && frontHalf.PathPoints.Count > 1)
            {
                Gizmos.color = Color.green;
                for (int i = 0; i < frontHalf.PathPoints.Count - 1; i++)
                {
                    Gizmos.DrawLine(
                        frontHalf.PathPoints[i] + Vector3.up * 3f,
                        frontHalf.PathPoints[i + 1] + Vector3.up * 3f
                    );
                }
            }

            // Draw back half path in yellow
            var backHalf = CityManager?.GetBackHalf();
            if (backHalf != null && backHalf.PathPoints.Count > 1)
            {
                Gizmos.color = Color.yellow;
                for (int i = 0; i < backHalf.PathPoints.Count - 1; i++)
                {
                    Gizmos.DrawLine(
                        backHalf.PathPoints[i] + Vector3.up * 4f,
                        backHalf.PathPoints[i + 1] + Vector3.up * 4f
                    );
                }

                // Draw trigger threshold point
                if (backHalf.PathPoints.Count > 0)
                {
                    int triggerIndex = Mathf.FloorToInt(backHalf.PathPoints.Count * LeapfrogTriggerProgress);
                    triggerIndex = Mathf.Clamp(triggerIndex, 0, backHalf.PathPoints.Count - 1);

                    Gizmos.color = Color.red;
                    Gizmos.DrawSphere(backHalf.PathPoints[triggerIndex] + Vector3.up * 5f, 2f);
                }
            }

            // Draw junction buffer zones
            Gizmos.color = new Color(1f, 0.5f, 0f, 0.3f);
            if (frontHalf != null && frontHalf.PathPoints.Count > 0)
            {
                var junctionPoint = frontHalf.PathPoints[frontHalf.PathPoints.Count - 1];
                Gizmos.DrawWireSphere(junctionPoint + Vector3.up * 3f, JunctionBufferDistance);
            }
        }
    }
}
