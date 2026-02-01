using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace HolyRail.PostProcessing
{
    [VolumeComponentMenu("Custom/Gradient Fog")]
    public sealed class GradientFogVolume : VolumeComponent, IPostProcessComponent
    {
        [Header("Colors")]
        public ColorParameter color1 = new(new Color(0.2f, 0.1f, 0.3f, 1f), true, true, true);
        public ColorParameter color2 = new(new Color(0.4f, 0.3f, 0.5f, 1f), true, true, true);
        public ColorParameter color3 = new(new Color(0.6f, 0.5f, 0.7f, 1f), true, true, true);

        [Header("Height Blending")]
        public FloatParameter blendHeight12 = new(10f);
        public FloatParameter blendHeight23 = new(50f);
        public FloatParameter falloff12 = new(10f);
        public FloatParameter falloff23 = new(20f);

        [Header("Fog Settings")]
        public FloatParameter density = new(0.01f);
        public FloatParameter startDistance = new(0f);

        public bool IsActive() => density.value > 0f;
        public bool IsTileCompatible() => true;
    }
}
