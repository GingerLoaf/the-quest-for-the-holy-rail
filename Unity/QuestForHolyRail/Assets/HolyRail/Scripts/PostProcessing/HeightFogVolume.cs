using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace HolyRail.PostProcessing
{
    [VolumeComponentMenu("Custom/Height Fog")]
    public sealed class HeightFogVolume : VolumeComponent, IPostProcessComponent
    {
        public ColorParameter fogColor = new(new Color(0.5f, 0.5f, 0.7f, 1f), true, true, true);
        public FloatParameter density = new(0.01f);
        public FloatParameter startDistance = new(0f);

        public bool IsActive() => density.value > 0f;
        public bool IsTileCompatible() => true;
    }
}
