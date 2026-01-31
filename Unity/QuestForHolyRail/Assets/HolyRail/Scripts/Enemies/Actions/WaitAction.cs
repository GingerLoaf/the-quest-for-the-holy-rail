using UnityEngine;

namespace HolyRail.Scripts.Enemies.Actions
{
    /// <summary>
    /// A pure delay action that does nothing but wait.
    /// Uses the Delay field from the base class.
    /// </summary>
    [System.Serializable]
    public class WaitAction : EnemyAction
    {
        public override bool Execute(EnemyController controller)
        {
            // No-op action, just uses the Delay field to create a pause
            Debug.Log($"WaitAction: Waiting {Delay}s before next action");
            return true;
        }
    }
}
