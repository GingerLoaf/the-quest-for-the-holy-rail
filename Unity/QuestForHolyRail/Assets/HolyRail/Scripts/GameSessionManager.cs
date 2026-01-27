using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;

// Responsible for keeping onto data for the entire game session (from app boot to app close)
// This class will hold onto data that should persist between scene loads like money and upgrades and things of that nature
public class GameSessionManager : MonoBehaviour
{
    public static GameSessionManager Instance { get; private set; }
    
    public Action<PlayerUpgrade[]> OnUpgradeListChanged;
    
    public Action<int> OnMoneyChanged;

    public int Money
    {
        get => m_money;
        set
        {
            m_money = value;
            
            try
            {
                OnMoneyChanged?.Invoke(m_money);
            }
            catch(Exception ex)
            {
                Debug.LogException(ex);
            }
        }
    }

    private int m_money = 0;

    public IReadOnlyList<PlayerUpgrade> Upgrades => m_upgrades;

    public float GetMultiplierFromUpgrades(UpgradeType type)
    {
        var multiplier = 1.0f;
        foreach (var upgrade in m_upgrades)
        {
            if (upgrade.Type != type)
            {
                continue;
            }
            
            multiplier += upgrade.Multiplier;
        }

        return multiplier;
    }
    
    private void Awake()
    {
        // If we already have one in static memory, kill this one
        if (Instance != null)
        {
            enabled = false;
            return;
        }
        
        Instance = this;
        
        // Keep this guy alive through scene loads since it holds all our session state
        DontDestroyOnLoad(this);
    }

    private readonly List<PlayerUpgrade> m_upgrades = new();

    public bool AddUpgrade(PlayerUpgrade upgrade)
    {
        Assert.IsNotNull(upgrade);

        if (m_upgrades.Contains(upgrade))
        {
            return false;
        }
        
        m_upgrades.Add(upgrade);
        
        try
        {
            OnUpgradeListChanged?.Invoke(m_upgrades.ToArray());
        }
        catch(Exception ex)
        {
            Debug.LogException(ex);
        }

        return true;
    }
}