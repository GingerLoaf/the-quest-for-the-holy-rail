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

        private void Awake()
        {
            CurrentSpeed = StartSpeed;
        }

        private void Update()
        {
            CurrentSpeed += Acceleration * Time.deltaTime;
            CurrentSpeed = Mathf.Min(CurrentSpeed, MaxSpeed);

            transform.position += Vector3.forward * CurrentSpeed * Time.deltaTime;
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player"))
            {
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
