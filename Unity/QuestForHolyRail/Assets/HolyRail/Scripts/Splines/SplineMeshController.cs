using UnityEngine;

[ExecuteAlways]
public class SplineMeshController : MonoBehaviour
{
    [field: SerializeField] public MeshRenderer MeshTarget { get; private set; }

    public bool flip = false;
    public float glowLocation;
    public float glowLength = 8f;
    [Range(0f, 1f)] public float glowMix = 1f;
    public float glowBrightness = 1f;


    private MaterialPropertyBlock _propertyBlock;

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

    public void Update()
    {
        PropertyBlock.SetFloat("_GlowLocation", glowLocation);
        PropertyBlock.SetFloat("_GlowLength", glowLength);
        PropertyBlock.SetFloat("_GlowMix", glowMix);
        PropertyBlock.SetFloat("_GlowBrightness", glowBrightness);
        MeshTarget.SetPropertyBlock(PropertyBlock);
    }
}
