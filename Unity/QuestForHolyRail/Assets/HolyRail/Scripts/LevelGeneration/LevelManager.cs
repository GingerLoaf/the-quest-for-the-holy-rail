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

    [Tooltip("Height adjustment when attachment points indicate elevation change")]
    public float HeightOffset = 5f;

    [Tooltip("Number of chunks behind player to keep before despawning")]
    public int ChunksToKeepBehind = 2;

    private List<LevelChunk> _activeChunks = new();
    private int _nextChunkIndex;
    private float _nextSpawnZ;
    private float _nextSpawnY;

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

        // Check previous chunk's attachment points to adjust height
        if (_activeChunks.Count > 0)
        {
            var previousChunk = _activeChunks[^1];
            AdjustHeightFromAttachmentPoints(previousChunk);
        }

        // Select prefab (cycle through array)
        var prefab = ChunkPrefabs[_nextChunkIndex % ChunkPrefabs.Length];

        // 50% chance to spawn backwards
        bool spawnBackwards = Random.value < 0.5f;

        // If backwards, rotate 180 and offset by chunk length to compensate for pivot position
        var spawnPosition = new Vector3(0f, _nextSpawnY, _nextSpawnZ + (spawnBackwards ? SpawnDistanceZ : 0f));
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

        _activeChunks.Add(levelChunk);
        _nextChunkIndex++;
        _nextSpawnZ += SpawnDistanceZ;
    }

    private void AdjustHeightFromAttachmentPoints(LevelChunk chunk)
    {
        bool airPopulated = chunk.FarEndAirPopulated();
        bool groundEmpty = chunk.FarEndGroundEmpty();
        bool groundPopulated = chunk.FarEndGroundPopulated();
        bool airEmpty = chunk.FarEndAirEmpty();

        // Air populated + ground empty → spawn higher
        if (airPopulated && groundEmpty)
        {
            _nextSpawnY += HeightOffset;
        }
        // Ground populated + air empty → spawn lower
        else if (groundPopulated && airEmpty)
        {
            _nextSpawnY -= HeightOffset;
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
