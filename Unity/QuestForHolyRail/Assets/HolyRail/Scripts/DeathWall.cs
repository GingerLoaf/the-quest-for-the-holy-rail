using HolyRail.Scripts.Enemies;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace HolyRail.Scripts
{
    public class DeathWall : MonoBehaviour
    {
        [field: SerializeField]
        public float StartSpeed { get; private set; } = 1.5f;

        [field: SerializeField]
        public float Acceleration { get; private set; } = 0.1f;

        [field: SerializeField]
        public float MaxSpeed { get; private set; } = 10f;

        [field: SerializeField]
        public float CurrentSpeed { get; private set; }

        private float _playerCurrentSpeed;
        private float _playerMaxSpeed;

        private void Awake()
        {
            CurrentSpeed = StartSpeed;
        }

        private void Update()
        {
            CurrentSpeed += Acceleration * Time.deltaTime;
            CurrentSpeed = Mathf.Min(CurrentSpeed, MaxSpeed);

            transform.position += Vector3.forward * CurrentSpeed * Time.deltaTime;

            // Track player speed
            if (StarterAssets.ThirdPersonController_RailGrinder.Instance != null)
            {
                var controller = StarterAssets.ThirdPersonController_RailGrinder.Instance.GetComponent<CharacterController>();
                if (controller != null)
                {
                    _playerCurrentSpeed = new Vector3(controller.velocity.x, 0f, controller.velocity.z).magnitude;
                    if (_playerCurrentSpeed > _playerMaxSpeed)
                    {
                        _playerMaxSpeed = _playerCurrentSpeed;
                    }
                }
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                Debug.Log($"<color=red>Player Killed!</color> <color=yellow>Current Speed: {_playerCurrentSpeed:F2} m/s</color> | <color=cyan>Max Speed Reached: {_playerMaxSpeed:F2} m/s</color>");
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
                return;
            }

            if (other.TryGetComponent<BaseEnemyBot>(out var bot))
            {
                EnemySpawner.Instance?.RecycleBot(bot);
                return;
            }

            if (other.TryGetComponent<EnemyBullet>(out var bullet))
            {
                EnemySpawner.Instance?.RecycleBullet(bullet);
            }
        }
    }
}
