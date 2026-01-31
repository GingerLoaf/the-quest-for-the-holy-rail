using UnityEngine;

namespace HolyRail.Scripts.Enemies.Actions
{
    /// <summary>
    /// Spawns multiple enemies in a formation pattern.
    /// Convenience action for spawning groups of enemies at once.
    /// </summary>
    [System.Serializable]
    public class SpawnFormationAction : EnemyAction
    {
        [System.Serializable]
        public class FormationSlot
        {
            public GameObject EnemyPrefab;
            public Vector3 RelativeOffset;
            public bool StartsIdle = true;
        }

        [Tooltip("Center position of the formation (relative to player)")]
        public Vector3 FormationCenter = new Vector3(0f, 2f, 20f);

        [Tooltip("Enemies in this formation")]
        public FormationSlot[] Formation;

        public override bool Execute(EnemyController controller)
        {
            if (Formation == null || Formation.Length == 0)
            {
                Debug.LogWarning("SpawnFormationAction: Formation array is empty!");
                return false;
            }

            if (EnemySpawner.Instance == null || EnemySpawner.Instance.Player == null)
            {
                Debug.LogError("SpawnFormationAction: EnemySpawner or Player not found!");
                return false;
            }

            int spawnedCount = 0;
            foreach (var slot in Formation)
            {
                if (slot.EnemyPrefab == null)
                {
                    Debug.LogWarning("SpawnFormationAction: FormationSlot has null prefab, skipping");
                    continue;
                }

                Vector3 finalPosition = EnemySpawner.Instance.Player.position + FormationCenter + slot.RelativeOffset;
                var bot = controller.SpawnEnemy(slot.EnemyPrefab, finalPosition, slot.StartsIdle);

                if (bot != null)
                {
                    spawnedCount++;
                }
            }

            Debug.Log($"SpawnFormationAction: Spawned {spawnedCount}/{Formation.Length} enemies in formation");
            return spawnedCount > 0;
        }
    }
}
