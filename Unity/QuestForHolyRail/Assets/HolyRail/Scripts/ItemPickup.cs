using UnityEngine;
using UnityEngine.Serialization;

namespace HolyRail.Scripts
{
    public enum PickupType
    {
        HealthPickup
    }
    
    [CreateAssetMenu(fileName = "ItemPickup.asset", menuName = "Assets/Create Item Pickup")]
    public class ItemPickup : ScriptableObject
    {
        [FormerlySerializedAs("DisplayName")]
        public string displayName;
        
        [FormerlySerializedAs("Icon")]
        public Sprite icon;
        
        [FormerlySerializedAs("Type")]
        public PickupType type;
        
        [FormerlySerializedAs("Value")]
        public float value;
    }
}
