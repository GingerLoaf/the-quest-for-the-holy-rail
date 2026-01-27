using System;
using StarterAssets;
using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public class LevelChunk : MonoBehaviour
    {
        public event Action<LevelChunk> PlayerEnteredFirstTime;

        [Header("Attachment Points")]
        [Tooltip("Attachment points at the near end (at pivot)")]
        public AttachmentPoint[] NearEnd = new AttachmentPoint[2];
        [Tooltip("Attachment points at the far end (away from pivot)")]
        public AttachmentPoint[] FarEnd = new AttachmentPoint[2];

        [Header("Flip-Dependent Objects")]
        [Tooltip("Objects that should only be enabled if the chunk is not flipped")]
        public GameObject[] EnabledOnlyWhenNotFlipped;

        public bool PlayerIsInside { get; private set; }
        public bool HasBeenVisited { get; private set; }
        public int ChunkIndex { get; set; }
        public bool IsFlipped { get; set; }

        private Transform _playerTransform;
        private float _chunkStartZ;
        private float _chunkEndZ;
        private bool _previousIsFlipped;

        private void Awake()
        {
            if (ThirdPersonController_RailGrinder.Instance != null)
            {
                _playerTransform = ThirdPersonController_RailGrinder.Instance.transform;
            }

            CalculateChunkBounds();

            _previousIsFlipped = IsFlipped;
            UpdateFlipDependentObjects();
        }

        private void Update()
        {
            if (_playerTransform == null)
                return;

            float playerLocalZ = transform.InverseTransformPoint(_playerTransform.position).z;
            bool wasInside = PlayerIsInside;
            PlayerIsInside = playerLocalZ >= _chunkStartZ && playerLocalZ <= _chunkEndZ;

            if (PlayerIsInside && !wasInside)
            {
                if (!HasBeenVisited)
                {
                    HasBeenVisited = true;
                    PlayerEnteredFirstTime?.Invoke(this);
                }
            }

            // Check if flip state has changed
            if (IsFlipped != _previousIsFlipped)
            {
                _previousIsFlipped = IsFlipped;
                UpdateFlipDependentObjects();
            }
        }

        private void UpdateFlipDependentObjects()
        {
            if (EnabledOnlyWhenNotFlipped == null)
                return;

            bool shouldBeEnabled = !IsFlipped;

            foreach (var obj in EnabledOnlyWhenNotFlipped)
            {
                if (obj != null)
                {
                    obj.SetActive(shouldBeEnabled);
                }
            }
        }

        private void CalculateChunkBounds()
        {
            Vector3? nearPos = GetProgressionNearEndAveragePosition();
            Vector3? farPos = GetProgressionFarEndAveragePosition();

            if (nearPos.HasValue && farPos.HasValue)
            {
                Vector3 nearLocal = transform.InverseTransformPoint(nearPos.Value);
                Vector3 farLocal = transform.InverseTransformPoint(farPos.Value);

                _chunkStartZ = Mathf.Min(nearLocal.z, farLocal.z);
                _chunkEndZ = Mathf.Max(nearLocal.z, farLocal.z);
            }
            else
            {
                _chunkStartZ = 0f;
                _chunkEndZ = 100f;
            }
        }

        /// <summary>
        /// Gets the attachment points at the end facing the next chunk in progression.
        /// Accounts for whether the chunk was spawned flipped.
        /// </summary>
        public AttachmentPoint[] GetProgressionFarEnd()
        {
            return IsFlipped ? NearEnd : FarEnd;
        }

        /// <summary>
        /// Gets the attachment points at the end facing the previous chunk in progression.
        /// Accounts for whether the chunk was spawned flipped.
        /// </summary>
        public AttachmentPoint[] GetProgressionNearEnd()
        {
            return IsFlipped ? FarEnd : NearEnd;
        }

        /// <summary>
        /// Gets the average world position of populated points at the progression far end.
        /// Returns null if no populated points exist.
        /// </summary>
        public Vector3? GetProgressionFarEndAveragePosition()
        {
            return GetAveragePosition(GetProgressionFarEnd());
        }

        /// <summary>
        /// Gets the average world position of populated points at the progression near end.
        /// Returns null if no populated points exist.
        /// </summary>
        public Vector3? GetProgressionNearEndAveragePosition()
        {
            return GetAveragePosition(GetProgressionNearEnd());
        }

        private Vector3? GetAveragePosition(AttachmentPoint[] points)
        {
            Vector3 sum = Vector3.zero;
            int count = 0;

            foreach (var point in points)
            {
                if (!point) continue;
                
                sum += point.transform.position;
                count++;
            }

            return count > 0 ? sum / count : null;
        }
    }
}
