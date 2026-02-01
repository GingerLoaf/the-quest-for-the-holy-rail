using Art.PickUps;
using UnityEngine;

namespace HolyRail.Scripts
{
    public class DebugCheats : MonoBehaviour
    {
        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
        private static void Initialize()
        {
            var go = new GameObject("DebugCheats");
            go.AddComponent<DebugCheats>();
            DontDestroyOnLoad(go);
        }

        private void Update()
        {
            if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                ToggleInvincibility();
            }

            if (Input.GetKeyDown(KeyCode.Alpha4))
            {
                UnlockAllAbilities();
            }
        }

        private void ToggleInvincibility()
        {
            if (GameSessionManager.Instance == null)
                return;

            GameSessionManager.Instance.IsInvincible = !GameSessionManager.Instance.IsInvincible;
            Debug.Log($"[Cheat] Invincibility: {(GameSessionManager.Instance.IsInvincible ? "ON" : "OFF")}");
        }

        private void UnlockAllAbilities()
        {
            AbilityPickUp.UnlockAllAbilities();
        }
    }
}
