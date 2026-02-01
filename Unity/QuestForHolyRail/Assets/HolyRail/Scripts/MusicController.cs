using System.Collections;
using UnityEngine;

public class MusicController : MonoBehaviour
{
    public static MusicController Instance { get; private set; }

    [field: SerializeField] public AudioSource MusicSource { get; private set; }
    [field: SerializeField] public AudioClip[] Songs { get; private set; }
    [field: SerializeField] [field: Range(0f, 1f)] public float Volume { get; private set; } = 1f;
    [field: SerializeField] public float FadeDuration { get; private set; } = 1f;

    private Coroutine _fadeCoroutine;
    private int _currentSongIndex = -1;

    private void Awake()
    {
        Instance = this;
    }

    private void Start()
    {
        PlayRandomSong();
    }

    private void Update()
    {
        if (MusicSource != null && !MusicSource.isPlaying && MusicSource.clip != null)
        {
            PlayRandomSong();
        }
    }

    private void PlayRandomSong()
    {
        if (Songs == null || Songs.Length == 0)
            return;

        int newIndex;
        if (Songs.Length == 1)
        {
            newIndex = 0;
        }
        else
        {
            do
            {
                newIndex = Random.Range(0, Songs.Length);
            } while (newIndex == _currentSongIndex);
        }

        _currentSongIndex = newIndex;
        MusicSource.clip = Songs[newIndex];
        MusicSource.Play();
    }

    private void OnDestroy()
    {
        if (Instance == this)
        {
            Instance = null;
        }
    }

    public void FadeOut()
    {
        if (_fadeCoroutine != null) 
            StopCoroutine(_fadeCoroutine);
        _fadeCoroutine = StartCoroutine(FadeCoroutine(Volume, 0f));
    }

    public void FadeIn()
    {
        if (_fadeCoroutine != null) 
            StopCoroutine(_fadeCoroutine);
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
