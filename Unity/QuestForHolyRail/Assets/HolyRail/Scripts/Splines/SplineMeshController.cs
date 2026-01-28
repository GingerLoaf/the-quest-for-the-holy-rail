using HolyRail.Scripts.LevelGeneration;
using UnityEngine;
using UnityEngine.Splines;

[ExecuteAlways]
public class SplineMeshController : MonoBehaviour
{
    [field: SerializeField] public MeshRenderer MeshTarget { get; private set; }

    public LevelChunk levelChunk;
    public bool flip = false;
    public float glowLocation;
    public float glowLength = 8f;
    [Range(0f, 1f)] public float glowMix = 1f;
    public float glowBrightness = 1f;
    public float showHideDuration = .25f;

    private float _animTimer;
    private float _animFrom;
    private float _animTo;
    private bool _animating;

    private MaterialPropertyBlock _propertyBlock;

    /// <summary>
    /// Don't call every frame...
    /// </summary>
    /// <returns></returns>
    public float GetSplineLength()
    {
        var spline = GetComponent<SplineContainer>();

        if (spline != null)
        {
            return spline.CalculateLength();
        }

        return 0f;
    }

    private MaterialPropertyBlock PropertyBlock
    {
        get
        {
            _propertyBlock ??= new MaterialPropertyBlock();
            return _propertyBlock;
        }
    }

    public void OnEnable()
    {
        if (MeshTarget == null)
            MeshTarget = GetComponent<MeshRenderer>();
    }
    public void Reset()
    {
        if (MeshTarget == null)
            MeshTarget = GetComponent<MeshRenderer>();
    }

    public void ClearPropertyBlock()
    {
        if (MeshTarget == null)
            return;

        PropertyBlock.Clear();
        MeshTarget.SetPropertyBlock(PropertyBlock);
    }

    public void Show()
    {
        _animFrom = glowMix;
        _animTo = 1f;
        _animTimer = 0f;
        _animating = true;
    }

    public void Hide()
    {
        _animFrom = glowMix;
        _animTo = 0f;
        _animTimer = 0f;
        _animating = true;
    }

    private void Update()
    {
        if (_animating)
        {
            _animTimer += Time.deltaTime;
            var t = Mathf.Clamp01(_animTimer / showHideDuration);
            glowMix = Mathf.Lerp(_animFrom, _animTo, t);

            if (t >= 1f)
                _animating = false;
        }

        if (levelChunk != null)
        {
            flip = levelChunk.IsFlipped;
        }

        float location = glowLocation;

        PropertyBlock.SetFloat("_GlowLocation", location);
        PropertyBlock.SetFloat("_GlowLength", glowLength);
        PropertyBlock.SetFloat("_GlowFlip", flip ? 1f : 0f);
        PropertyBlock.SetFloat("_GlowMix", glowMix);
        PropertyBlock.SetFloat("_GlowBrightness", glowBrightness);
        MeshTarget.SetPropertyBlock(PropertyBlock);
    }
}
