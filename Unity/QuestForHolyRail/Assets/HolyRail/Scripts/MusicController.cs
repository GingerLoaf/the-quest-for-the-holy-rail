using System.Collections;
using UnityEngine;

public class MusicController : MonoBehaviour
{
    public static MusicController Instance { get; private set; }

    [field: SerializeField] public AudioSource MusicSource { get; private set; }
    [field: SerializeField] public AudioClip[] Songs { get; private set; }
    [field: SerializeField] [field: Range(0f, 1f)] public float Volume { get; private set; } = 1f;
    [field: SerializeField] public float FadeDuration { get; private set; } = 1f;

    private int[] _shuffledIndices;
    private int _currentIndex;
    private Coroutine _fadeCoroutine;
    private bool _isPaused;
    private bool _waitingForPlay;

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
        if (Songs == null || Songs.Length == 0)
            return;

        ShufflePlaylist();
        PlayCurrentTrack();
    }

    private void Update()
    {
        if (MusicSource == null || Songs == null || Songs.Length == 0)
            return;

        // Clear waiting flag once audio actually starts
        if (_waitingForPlay && MusicSource.isPlaying)
            _waitingForPlay = false;

        if (!MusicSource.isPlaying && !_isPaused && !_waitingForPlay)
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
        _waitingForPlay = true;
    }

    private void PlayNextTrack()
    {
        _currentIndex++;
        if (_currentIndex >= Songs.Length)
            ShufflePlaylist();

        PlayCurrentTrack();
    }

    public void FadeOut()
    {
        if (_fadeCoroutine != null)
        {
            StopCoroutine(_fadeCoroutine);
        }
        _isPaused = true;
        _fadeCoroutine = StartCoroutine(FadeCoroutine(Volume, 0f));
    }

    public void FadeIn()
    {
        if (_fadeCoroutine != null)
        {
            StopCoroutine(_fadeCoroutine);
        }
        _isPaused = false;
        _fadeCoroutine = StartCoroutine(FadeCoroutine(MusicSource.volume, Volume));
    }

    private IEnumerator FadeCoroutine(float fromVolume, float toVolume)
    {
        if (MusicSource == null)
            yield break;

        float elapsed = 0f;
        while (elapsed < FadeDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / FadeDuration;
            MusicSource.volume = Mathf.Lerp(fromVolume, toVolume, t);
            yield return null;
        }

        MusicSource.volume = toVolume;
        _fadeCoroutine = null;
    }
}
