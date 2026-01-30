using UnityEngine;

namespace HolyRail.Scripts
{
    [CreateAssetMenu(fileName = "ItemPickup.asset", menuName = "Assets/Create Item Pickup")]
    public class ItemPickup : ScriptableObject
    {
        public string DisplayName;
        public Sprite Icon;
        public UpgradeType Type;
        public float Value;
    }
}
