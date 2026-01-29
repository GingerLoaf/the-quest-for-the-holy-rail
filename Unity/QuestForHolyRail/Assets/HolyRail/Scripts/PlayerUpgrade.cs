using System;
using UnityEngine;

namespace HolyRail.Scripts
{
    public enum UpgradeType
    {
        ParryAccuracy,
        ParryTimeWindow,
        SprayPaintRadius,
        SprayPaintCapacity,
        SpeedBoost
    }

    [Serializable]
    public class UpgradeTier
    {
        public int Tier;
        public float Value;
        public int Cost = 100;
    }

// Represents an upgrade that the player can purchase. These upgrades will tune the way the game runs
    [CreateAssetMenu(fileName = "Upgrade.asset", menuName = "Assets/Create Upgrade")]
    public class PlayerUpgrade : ScriptableObject
    {
        public Sprite Icon;
        public string DisplayName = string.Empty;
        public UpgradeType Type;

        public int MaxTier => GetMaxTier();
        public bool AllowInShop = true;

        public UpgradeTier[] TierData =
        {
            new() { Tier = 1, Value = 1 },
            new() { Tier = 2, Value = 2 },
            new() { Tier = 3, Value = 4 }
        };

        public int GetMaxTier()
        {
            int? maxTier = null;
            for (var i = 0; i < TierData.Length; i++)
            {
                if (!maxTier.HasValue || TierData[i].Tier > maxTier.Value)
                {
                    maxTier = TierData[i].Tier;
                }
            }

            return maxTier ?? 0;
        }

        public int GetCostForTier(int tier)
        {
            if (TierData == null)
            {
                return 0;
            }
            
            for (var i = 0; i < TierData.Length; i++)
            {
                if (TierData[i].Tier == tier)
                {
                    return TierData[i].Cost;
                }
            }

            return 0;
        }

        public float GetValueForTier(int tier)
        {
            if (TierData == null)
            {
                return 0f;
            }
            
            for (var i = 0; i < TierData.Length; i++)
            {
                if (TierData[i].Tier == tier)
                {
                    return TierData[i].Value;
                }
            }

            return 0f;
        }
    }
}