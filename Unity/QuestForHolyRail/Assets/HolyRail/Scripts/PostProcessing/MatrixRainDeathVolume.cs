using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace HolyRail.PostProcessing
{
    [VolumeComponentMenu("Custom/Matrix Rain Death")]
    public sealed class MatrixRainDeathVolume : VolumeComponent, IPostProcessComponent
    {
        [Tooltip("Wipe position from 0 (scene visible) to 1 (fully covered by matrix rain)")]
        public ClampedFloatParameter wipePosition = new(0f, 0f, 1f);

        [Tooltip("Color of the matrix rain characters")]
        public ColorParameter charColor = new(new Color(0.1f, 1.0f, 0.35f, 1f), true, true, true);

        [Tooltip("Background color behind the rain")]
        public ColorParameter backgroundColor = new(new Color(0f, 0f, 0f, 1f));

        [Tooltip("Animation speed of the falling rain")]
        public ClampedFloatParameter speed = new(1f, 0.1f, 5f);

        [Tooltip("Scale of the characters")]
        public ClampedFloatParameter scale = new(1f, 0.5f, 4f);

        [Tooltip("Brightness multiplier for the rain")]
        public ClampedFloatParameter brightness = new(1f, 0.1f, 3f);

        [Tooltip("Length of the trailing fade behind rain heads")]
        public ClampedFloatParameter trailLength = new(0.5f, 0.1f, 1f);

        [Tooltip("Speed at which characters change")]
        public ClampedFloatParameter charChangeSpeed = new(3f, 0.5f, 10f);

        [Tooltip("Scale of the noise pattern on the wipe edge")]
        public ClampedFloatParameter wipeNoiseScale = new(2f, 0.1f, 10f);

        [Tooltip("Strength of the noise displacement on the wipe edge")]
        public ClampedFloatParameter wipeNoiseStrength = new(0.15f, 0f, 0.5f);

        public bool IsActive() => wipePosition.value > 0f;
        public bool IsTileCompatible() => true;
    }
}
