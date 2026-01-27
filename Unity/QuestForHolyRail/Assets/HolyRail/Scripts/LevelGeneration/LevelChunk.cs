using System;
using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    [RequireComponent(typeof(BoxCollider))]
    public class LevelChunk : MonoBehaviour
    {
        public event Action<LevelChunk> PlayerEnteredFirstTime;

        [Header("Attachment Points")]
        [Tooltip("Attachment points at the near end (at pivot)")]
        public AttachmentPoint[] NearEnd = new AttachmentPoint[2];
        [Tooltip("Attachment points at the far end (away from pivot)")]
        public AttachmentPoint[] FarEnd = new AttachmentPoint[2];

        public bool PlayerIsInside { get; private set; }
        public bool HasBeenVisited { get; private set; }
        public int ChunkIndex { get; set; }
        public bool IsFlipped { get; set; }

        private BoxCollider _collider;

        private void Awake()
        {
            _collider = GetComponent<BoxCollider>();
            _collider.isTrigger = true;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (!other.CompareTag("Player"))
                return;

            PlayerIsInside = true;

            if (!HasBeenVisited)
            {
                HasBeenVisited = true;
                PlayerEnteredFirstTime?.Invoke(this);
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                PlayerIsInside = false;
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
