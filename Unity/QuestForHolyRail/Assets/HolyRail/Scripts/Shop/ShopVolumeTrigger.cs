using UnityEngine;

namespace HolyRail.Scripts.Shop
{
    public enum ShopVolumeType
    {
        Outer,
        Inner
    }

    public class ShopVolumeTrigger : MonoBehaviour
    {
        [field: SerializeField]
        public ShopVolumeType VolumeType { get; private set; }

        [field: SerializeField]
        public ShopZone ShopZone { get; private set; }

        private void OnTriggerEnter(Collider other)
        {
            if (!other.CompareTag("Player"))
                return;

            if (ShopZone == null)
                return;

            switch (VolumeType)
            {
                case ShopVolumeType.Outer:
                    ShopZone.OnOuterVolumeEnter();
                    break;
                case ShopVolumeType.Inner:
                    ShopZone.OnInnerVolumeEnter();
                    break;
            }
        }

        private void OnTriggerExit(Collider other)
        {
            if (!other.CompareTag("Player"))
                return;

            if (ShopZone == null)
                return;

            switch (VolumeType)
            {
                case ShopVolumeType.Outer:
                    ShopZone.OnOuterVolumeExit();
                    break;
                case ShopVolumeType.Inner:
                    ShopZone.OnInnerVolumeExit();
                    break;
            }
        }
    }
}
