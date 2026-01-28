using UnityEngine;

public class MusicController : MonoBehaviour
{
    [field: SerializeField] public AudioSource MusicSource { get; private set; }
    [field: SerializeField] public AudioClip[] Songs { get; private set; }
    [field: SerializeField] [field: Range(0f, 1f)] public float Volume { get; private set; } = 1f;

    private int[] _shuffledIndices;
    private int _currentIndex;

    private void Start()
    {
        if (Songs == null || Songs.Length == 0)
            return;

        ShufflePlaylist();
        PlayCurrentTrack();
    }

    private void Update()
    {
        if (MusicSource == null || Songs == null || Songs.Length == 0)
            return;

        if (!MusicSource.isPlaying)
            PlayNextTrack();
    }

    private void ShufflePlaylist()
    {
        _shuffledIndices = new int[Songs.Length];
        for (int i = 0; i < Songs.Length; i++)
            _shuffledIndices[i] = i;

        // Fisher-Yates shuffle
        for (int i = Songs.Length - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            (_shuffledIndices[i], _shuffledIndices[j]) = (_shuffledIndices[j], _shuffledIndices[i]);
        }

        _currentIndex = 0;
    }

    private void PlayCurrentTrack()
    {
        var clip = Songs[_shuffledIndices[_currentIndex]];
        MusicSource.clip = clip;
        MusicSource.volume = Volume;
        MusicSource.Play();
    }

    private void PlayNextTrack()
    {
        _currentIndex++;
        if (_currentIndex >= Songs.Length)
            ShufflePlaylist();

        PlayCurrentTrack();
    }
}
