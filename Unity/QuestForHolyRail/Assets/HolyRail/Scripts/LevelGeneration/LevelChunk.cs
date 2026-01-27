using System;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class LevelChunk : MonoBehaviour
{
    public event Action<LevelChunk> PlayerEnteredFirstTime;

    public bool PlayerIsInside { get; private set; }
    public bool HasBeenVisited { get; private set; }
    public int ChunkIndex { get; set; }

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
}
