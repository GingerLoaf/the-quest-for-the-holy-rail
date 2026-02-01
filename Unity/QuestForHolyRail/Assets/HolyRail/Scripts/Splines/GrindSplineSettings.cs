using UnityEngine;

namespace HolyRail.Scripts.Splines
{
    public class GrindSplineSettings : MonoBehaviour
    {
        [field: Header("One Way")]
        [field: SerializeField]
        [field: Tooltip("When enabled, player can only travel in one direction and cannot re-attach after exiting")]
        public bool IsOneWay { get; private set; } = false;

        [field: SerializeField]
        [field: Tooltip("Flip the travel direction (end-to-start instead of start-to-end)")]
        public bool ReverseDirection { get; private set; } = false;

        [field: Header("Grind Block")]
        [field: SerializeField]
        [field: Tooltip("When enabled, player cannot jump off - only exits at spline end")]
        public bool BlockJumpExit { get; private set; } = false;

        [field: Header("Magnetism")]
        [field: SerializeField]
        [field: Tooltip("Custom detection radius. 0 = use global default")]
        public float CustomMagnetismRadius { get; private set; } = 0f;

        [field: Header("Re-attachment Prevention")]
        [field: SerializeField]
        [field: Tooltip("Time before player can be sucked back on after end-exit")]
        public float EndExitCooldown { get; private set; } = 1.0f;
    }
}
