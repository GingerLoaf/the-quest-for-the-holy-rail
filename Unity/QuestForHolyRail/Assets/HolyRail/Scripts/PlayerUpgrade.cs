using UnityEngine;

namespace HolyRail.Scripts
{
    public enum UpgradeType
    {
        SpeedUp
    }

// Represents an upgrade that the player can purchase. These upgrades will tune the way the game runs
    [CreateAssetMenu(fileName = "Upgrade.asset", menuName = "Assets/Create Upgrade")]
    public class PlayerUpgrade : ScriptableObject
    {
        public Sprite Icon;
        public string DisplayName = string.Empty;
        public int Cost = 100;
        public float Multiplier = 1.0f;
        public UpgradeType Type;
        public bool AllowInShop = true;
    }
}