using UnityEngine;

namespace HolyRail.Scripts.Enemies.Actions
{
    /// <summary>
    /// Sends a command to a specific enemy spawned by the current plan.
    /// </summary>
    [System.Serializable]
    public class CommandEnemyAction : EnemyAction
    {
        public enum CommandType
        {
            TriggerAttack,
            MoveTo,
            SetBehavior
        }

        [Tooltip("The index of the enemy to command (0-based, order spawned in plan)")]
        public int TargetEnemyIndex = 0;

        [Tooltip("The command to send to the enemy")]
        public CommandType Command = CommandType.TriggerAttack;

        [Tooltip("Target position for MoveTo command")]
        public Vector3 TargetPosition = Vector3.zero;

        public override bool Execute(EnemyController controller)
        {
            var enemy = controller.GetSpawnedEnemy(TargetEnemyIndex);
            if (enemy == null)
            {
                Debug.LogWarning($"CommandEnemyAction: Enemy at index {TargetEnemyIndex} not found or already destroyed");
                return false;
            }

            switch (Command)
            {
                case CommandType.TriggerAttack:
                    enemy.OnCommandReceived("Attack");
                    Debug.Log($"CommandEnemyAction: Sent 'Attack' command to enemy {TargetEnemyIndex}");
                    break;

                case CommandType.MoveTo:
                    enemy.OnCommandReceived("MoveTo", TargetPosition);
                    Debug.Log($"CommandEnemyAction: Sent 'MoveTo' command to enemy {TargetEnemyIndex} with position {TargetPosition}");
                    break;

                case CommandType.SetBehavior:
                    enemy.OnCommandReceived("SetBehavior");
                    Debug.Log($"CommandEnemyAction: Sent 'SetBehavior' command to enemy {TargetEnemyIndex}");
                    break;
            }

            return true;
        }
    }
}
