using System;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class LevelChunk : MonoBehaviour
{
    public event Action<LevelChunk> PlayerEnteredFirstTime;

    [Header("Attachment Points - Near End (at pivot)")]
    [Tooltip("Ground attachment points at the near end (2 expected)")]
    public AttachmentPoint[] NearEndGround = new AttachmentPoint[2];
    [Tooltip("Air attachment points at the near end (2 expected)")]
    public AttachmentPoint[] NearEndAir = new AttachmentPoint[2];

    [Header("Attachment Points - Far End (away from pivot)")]
    [Tooltip("Ground attachment points at the far end (2 expected)")]
    public AttachmentPoint[] FarEndGround = new AttachmentPoint[2];
    [Tooltip("Air attachment points at the far end (2 expected)")]
    public AttachmentPoint[] FarEndAir = new AttachmentPoint[2];

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
    public void GetProgressionFarEnd(out AttachmentPoint[] ground, out AttachmentPoint[] air)
    {
        if (IsFlipped)
        {
            ground = NearEndGround;
            air = NearEndAir;
        }
        else
        {
            ground = FarEndGround;
            air = FarEndAir;
        }
    }

    /// <summary>
    /// Checks if all ground points at the progression far end are populated.
    /// </summary>
    public bool FarEndGroundPopulated()
    {
        GetProgressionFarEnd(out var ground, out _);
        foreach (var point in ground)
        {
            if (point == null || !point.IsPopulated)
                return false;
        }
        return true;
    }

    /// <summary>
    /// Checks if all air points at the progression far end are populated.
    /// </summary>
    public bool FarEndAirPopulated()
    {
        GetProgressionFarEnd(out _, out var air);
        foreach (var point in air)
        {
            if (point == null || !point.IsPopulated)
                return false;
        }
        return true;
    }

    /// <summary>
    /// Checks if all ground points at the progression far end are NOT populated.
    /// </summary>
    public bool FarEndGroundEmpty()
    {
        GetProgressionFarEnd(out var ground, out _);
        foreach (var point in ground)
        {
            if (point != null && point.IsPopulated)
                return false;
        }
        return true;
    }

    /// <summary>
    /// Checks if all air points at the progression far end are NOT populated.
    /// </summary>
    public bool FarEndAirEmpty()
    {
        GetProgressionFarEnd(out _, out var air);
        foreach (var point in air)
        {
            if (point != null && point.IsPopulated)
                return false;
        }
        return true;
    }
}
