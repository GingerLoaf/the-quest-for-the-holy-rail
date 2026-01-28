using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace HolyRail.Scripts.LevelGeneration
{
    public class LevelManager : MonoBehaviour
    {
        public static LevelManager Instance { get; private set; }
        [FormerlySerializedAs("ChunkPrefabs")]
        [Header("Level Chunks")]
        [Tooltip("Optional starter chunks that always spawn first in order")]
        public GameObject[] starterChunkPrefabs;

        [Tooltip("Prefabs of level chunks to spawn")]
        public GameObject[] chunkPrefabs;

        [FormerlySerializedAs("SpawnDistanceZ")]
        [Header("Spawning")]
        [Tooltip("Distance in Z to spawn next chunk ahead of current")]
        public float spawnDistanceZ = 30f;

        [Tooltip("Number of chunks ahead of player to keep loaded")]
        public int chunksToKeepAhead = 5;

        [FormerlySerializedAs("ChunksToKeepBehind")] [Tooltip("Number of chunks behind player to keep before despawning")]
        public int chunksToKeepBehind = 5;

        private List<LevelChunk> _activeChunks = new();
        private int _nextChunkIndex;
        private float _nextSpawnZ;
        private bool _isPaused;

        private void Awake()
        {
            Instance = this;
        }

        private void OnDestroy()
        {
            if (Instance == this)
            {
                Instance = null;
            }
        }

        private void Start()
        {
            if (chunkPrefabs == null || chunkPrefabs.Length == 0)
            {
                Debug.LogError("LevelManager: No chunk prefabs assigned!");
                return;
            }

            // Spawn initial chunks to fill the ahead buffer
            // Spawn current chunk + chunksToKeepAhead
            for (int i = 0; i <= chunksToKeepAhead; i++)
            {
                SpawnNextChunk();
            }
        }

        private void SpawnNextChunk()
        {
            if (chunkPrefabs.Length == 0)
                return;

            GameObject prefab;
            bool spawnBackwards = false;

            // Use starter chunks first if available
            if (starterChunkPrefabs != null && _nextChunkIndex < starterChunkPrefabs.Length)
            {
                prefab = starterChunkPrefabs[_nextChunkIndex];
                // Starter chunks always spawn forward (no randomization)
                spawnBackwards = false;
            }
            else
            {
                // Select prefab from regular chunks (cycle through array)
                var regularIndex = _nextChunkIndex - (starterChunkPrefabs?.Length ?? 0);
                prefab = chunkPrefabs[regularIndex % chunkPrefabs.Length];

                // 50% chance to spawn backwards for regular chunks
                spawnBackwards = Random.value < 0.5f;
            }

            // If backwards, rotate 180 and offset by chunk length to compensate for pivot position
            var spawnPosition = new Vector3(0f, 0f, _nextSpawnZ + (spawnBackwards ? spawnDistanceZ : 0f));
            var spawnRotation = spawnBackwards ? Quaternion.Euler(0f, 180f, 0f) : Quaternion.identity;

            var chunk = Instantiate(prefab, spawnPosition, spawnRotation, transform);

            var levelChunk = chunk.GetComponent<LevelChunk>();
            if (levelChunk == null)
            {
                Debug.LogError($"LevelManager: Prefab {prefab.name} is missing LevelChunk component!");
                Destroy(chunk);
                return;
            }

            levelChunk.ChunkIndex = _nextChunkIndex;
            levelChunk.IsFlipped = spawnBackwards;
            levelChunk.PlayerEnteredFirstTime += OnPlayerEnteredChunk;

            levelChunk.InitializeSplineMeshControllers();

            // Align attachment points with previous chunk
            if (_activeChunks.Count > 0)
            {
                AlignChunkPosition(levelChunk, _activeChunks[^1]);
            }

            _activeChunks.Add(levelChunk);
            _nextChunkIndex++;
            _nextSpawnZ += spawnDistanceZ;
        }

        private void AlignChunkPosition(LevelChunk newChunk, LevelChunk previousChunk)
        {
            var previousFarPos = previousChunk.GetProgressionFarEndAveragePosition();
            var newNearPos = newChunk.GetProgressionNearEndAveragePosition();

            if (previousFarPos.HasValue && newNearPos.HasValue)
            {
                // Calculate offset to align new chunk's near end with previous chunk's far end
                Vector3 offset = previousFarPos.Value - newNearPos.Value;
                newChunk.transform.position += offset;
            }
        }

        private void OnPlayerEnteredChunk(LevelChunk enteredChunk)
        {
            if (_isPaused)
                return;

            // Calculate how many chunks we should have ahead
            int targetLastChunkIndex = enteredChunk.ChunkIndex + chunksToKeepAhead;

            // Spawn chunks until we have the required number ahead
            while (_nextChunkIndex <= targetLastChunkIndex)
            {
                SpawnNextChunk();
            }

            // Despawn chunks that are too far behind
            DespawnOldChunks(enteredChunk.ChunkIndex);
        }

        private void DespawnOldChunks(int currentPlayerChunkIndex)
        {
            // Remove chunks that are more than ChunksToKeepBehind behind the player
            int despawnThreshold = currentPlayerChunkIndex - chunksToKeepBehind;

            for (int i = _activeChunks.Count - 1; i >= 0; i--)
            {
                var chunk = _activeChunks[i];
                if (chunk.ChunkIndex < despawnThreshold)
                {
                    chunk.PlayerEnteredFirstTime -= OnPlayerEnteredChunk;
                    Destroy(chunk.gameObject);
                    _activeChunks.RemoveAt(i);
                }
            }
        }

        public void Pause()
        {
            _isPaused = true;
        }

        public void Resume()
        {
            _isPaused = false;
        }

        public void ResetFromPosition(Vector3 playerPosition)
        {
            // Destroy all existing chunks
            foreach (var chunk in _activeChunks)
            {
                if (chunk != null)
                {
                    chunk.PlayerEnteredFirstTime -= OnPlayerEnteredChunk;
                    Destroy(chunk.gameObject);
                }
            }
            _activeChunks.Clear();

            // Reset spawn state from player's current position
            _nextChunkIndex = 0;
            _nextSpawnZ = playerPosition.z;

            // Spawn initial chunks ahead of player
            for (int i = 0; i <= chunksToKeepAhead; i++)
            {
                SpawnNextChunk();
            }
        }
    }
}
