using System.Collections.Generic;
using UnityEngine;
using HolyRail.Scripts.Enemies.Actions;

namespace HolyRail.Scripts.Enemies
{
    /// <summary>
    /// ScriptableObject defining a choreographed enemy attack pattern.
    /// Plans consist of timed actions that spawn enemies and issue commands.
    /// </summary>
    [CreateAssetMenu(fileName = "EnemyPlan", menuName = "Holy Rail/Enemy Plan")]
    public class EnemyPlan : ScriptableObject
    {
        [Header("Plan Identity")]
        [Tooltip("Descriptive name for this attack plan")]
        public string PlanName = "Unnamed Plan";

        [Header("Plan Selection")]
        [Tooltip("Weight for weighted random selection (higher = more likely)")]
        [Range(1, 100)]
        public int SpawnWeight = 10;

        [Tooltip("If true, actions repeat from the beginning until PlanDuration expires")]
        public bool LoopActions = false;

        [Tooltip("Time for enemies to fly into position from offscreen (seconds)")]
        public float EnterDuration = 1.5f;

        [Tooltip("Time for enemies to fly offscreen when plan ends (seconds)")]
        public float ExitDuration = 1.5f;

        [Header("Actions")]
        [Tooltip("Ordered sequence of actions to execute")]
        [SerializeReference]
        public List<EnemyAction> Actions = new();

        private void OnValidate()
        {
            EnterDuration = Mathf.Max(0.1f, EnterDuration);
            ExitDuration = Mathf.Max(0.1f, ExitDuration);
        }
    }
}
