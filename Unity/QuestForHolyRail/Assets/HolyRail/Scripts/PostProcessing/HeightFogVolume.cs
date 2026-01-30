using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace HolyRail.PostProcessing
{
    [VolumeComponentMenu("Custom/Height Fog")]
    public sealed class HeightFogVolume : VolumeComponent, IPostProcessComponent
    {
        [Header("Colors")]
        public ColorParameter bottomColor = new(new Color(0.1f, 0.1f, 0.2f, 1f), true, true, true);
        public ColorParameter middleColor = new(new Color(0.3f, 0.3f, 0.4f, 0.8f), true, true, true);
        public ColorParameter topColor = new(new Color(0.6f, 0.7f, 0.9f, 0.3f), true, true, true);

        [Header("Height Thresholds (World Y)")]
        public FloatParameter bottomHeight = new(0f);
        public FloatParameter middleHeight = new(50f);
        public FloatParameter topHeight = new(150f);

        [Header("Falloff (Blend Distance)")]
        public ClampedFloatParameter bottomToMiddleFalloff = new(20f, 1f, 100f);
        public ClampedFloatParameter middleToTopFalloff = new(30f, 1f, 100f);

        [Header("Density Per Zone")]
        public ClampedFloatParameter bottomDensity = new(1f, 0f, 1f);
        public ClampedFloatParameter middleDensity = new(0.7f, 0f, 1f);
        public ClampedFloatParameter topDensity = new(0.3f, 0f, 1f);

        [Header("Global Settings")]
        public ClampedFloatParameter globalDensity = new(1f, 0f, 1f);
        public FloatParameter minDistance = new(0f);
        public FloatParameter maxDistance = new(500f);

        public bool IsActive() => globalDensity.value > 0f;
        public bool IsTileCompatible() => true;
    }
}
