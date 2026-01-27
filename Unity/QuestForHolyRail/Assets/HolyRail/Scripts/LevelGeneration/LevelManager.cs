using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{
    [Header("Level Chunks")]
    [Tooltip("Prefabs of level chunks to spawn")]
    public GameObject[] ChunkPrefabs;

    [Header("Spawning")]
    [Tooltip("Distance in Z to spawn next chunk ahead of current")]
    public float SpawnDistanceZ = 30f;

    [Tooltip("Number of chunks behind player to keep before despawning")]
    public int ChunksToKeepBehind = 2;

    private List<LevelChunk> _activeChunks = new();
    private int _nextChunkIndex;
    private float _nextSpawnZ;

    private void Start()
    {
        if (ChunkPrefabs == null || ChunkPrefabs.Length == 0)
        {
            Debug.LogError("LevelManager: No chunk prefabs assigned!");
            return;
        }

        // Spawn initial chunk at origin
        SpawnNextChunk();
    }

    private void SpawnNextChunk()
    {
        if (ChunkPrefabs.Length == 0)
            return;

        // Select prefab (cycle through array)
        var prefab = ChunkPrefabs[_nextChunkIndex % ChunkPrefabs.Length];

        // 50% chance to spawn backwards
        bool spawnBackwards = Random.value < 0.5f;

        // If backwards, rotate 180 and offset by chunk length to compensate for pivot position
        var spawnPosition = new Vector3(0f, 0f, _nextSpawnZ + (spawnBackwards ? SpawnDistanceZ : 0f));
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

        // Align attachment points with previous chunk
        if (_activeChunks.Count > 0)
        {
            AlignChunkPosition(levelChunk, _activeChunks[^1]);
        }

        _activeChunks.Add(levelChunk);
        _nextChunkIndex++;
        _nextSpawnZ += SpawnDistanceZ;
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
        // Spawn next chunk when player enters current one
        SpawnNextChunk();

        // Despawn chunks that are too far behind
        DespawnOldChunks(enteredChunk.ChunkIndex);
    }

    private void DespawnOldChunks(int currentPlayerChunkIndex)
    {
        // Remove chunks that are more than ChunksToKeepBehind behind the player
        int despawnThreshold = currentPlayerChunkIndex - ChunksToKeepBehind;

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
}
