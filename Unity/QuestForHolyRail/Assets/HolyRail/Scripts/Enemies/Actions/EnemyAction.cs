using UnityEngine;

namespace HolyRail.Scripts.Enemies.Actions
{
    /// <summary>
    /// Base class for all enemy actions in an EnemyPlan.
    /// Actions are executed sequentially by the EnemyController.
    /// </summary>
    [System.Serializable]
    public abstract class EnemyAction
    {
        [Tooltip("Delay in seconds before executing the NEXT action")]
        public float Delay = 0f;

        /// <summary>
        /// Execute this action.
        /// </summary>
        /// <param name="controller">The EnemyController executing this action</param>
        /// <returns>True if action executed successfully, false otherwise</returns>
        public abstract bool Execute(EnemyController controller);
    }
}
