using UnityEngine;

namespace HolyRail.Scripts.Enemies.Actions
{
    /// <summary>
    /// Spawns an enemy at a position relative to the player.
    /// Enemy flies in from offscreen to the final position.
    /// </summary>
    [System.Serializable]
    public class SpawnEnemyAction : EnemyAction
    {
        [Tooltip("The enemy prefab to spawn")]
        public GameObject EnemyPrefab;

        [Tooltip("Position offset from player (final destination position)")]
        public Vector3 RelativePosition = new Vector3(0f, 2f, 20f);

        [Tooltip("Random variance applied to spawn position")]
        public Vector3 PositionVariance = Vector3.zero;

        [Tooltip("If true, enemy waits idle until commanded to attack")]
        public bool StartsIdle = true;

        public override bool Execute(EnemyController controller)
        {
            if (EnemyPrefab == null)
            {
                Debug.LogError("SpawnEnemyAction: EnemyPrefab is null!");
                return false;
            }

            if (EnemySpawner.Instance == null || EnemySpawner.Instance.Player == null)
            {
                Debug.LogError("SpawnEnemyAction: EnemySpawner or Player not found!");
                return false;
            }

            // Calculate final position with variance
            Vector3 variance = new Vector3(
                Random.Range(-PositionVariance.x, PositionVariance.x),
                Random.Range(-PositionVariance.y, PositionVariance.y),
                Random.Range(-PositionVariance.z, PositionVariance.z)
            );

            Vector3 finalPosition = EnemySpawner.Instance.Player.position + RelativePosition + variance;

            // Spawn enemy (EnemySpawner handles offscreen positioning and transition)
            var bot = controller.SpawnEnemy(EnemyPrefab, finalPosition, StartsIdle);

            if (bot == null)
            {
                Debug.LogError("SpawnEnemyAction: Failed to spawn enemy!");
                return false;
            }

            Debug.Log($"SpawnEnemyAction: Spawned {EnemyPrefab.name} at {finalPosition}, StartsIdle={StartsIdle}");
            return true;
        }
    }
}
