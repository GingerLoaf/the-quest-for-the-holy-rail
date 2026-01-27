using System;
using System.Linq;
using UnityEngine;
using UnityEngine.Assertions;

// Responsible for letting the player purchase upgrades to accomodate them in the next round
// It will save it to the session manager so it persists across scene loads
public class ShopManager : MonoBehaviour
{
    private void Start()
    {
        m_storeUpgrades = Resources.LoadAll<PlayerUpgrade>(string.Empty).Where(u => u.AllowInShop).ToArray();
    }

    private PlayerUpgrade[] m_storeUpgrades = Array.Empty<PlayerUpgrade>();

    public bool TryPurchaseUpgrade(PlayerUpgrade upgrade)
    {
        Assert.IsNotNull(upgrade);

        // If not allowed in the shop, fail the purchase
        if (!upgrade.AllowInShop)
        {
            return false;
        }
        
        var remainingMoney = GameSessionManager.Instance.Money - upgrade.Cost;
        if (remainingMoney < 0)
        {
            Debug.LogError($"Not enough money to purchase upgrade {upgrade.DisplayName}");
            return false;
        }

        if (!GameSessionManager.Instance.AddUpgrade(upgrade))
        {
            return false;
        }
        
        GameSessionManager.Instance.Money = remainingMoney;
        
        return true;
    }
}