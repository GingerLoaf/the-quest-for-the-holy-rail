using HolyRail.Scripts.Enemies;
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace HolyRail.Scripts
{
    [Serializable]
    public class SpeedAnalytics
    {
        public float playerCurrentSpeed;
        public float playerMaxSpeed;
        public float playerAvgSpeed;
        public float deathWallSpeed;
        public string timestamp;
        public SpeedAnalytics(float playerCurrent, float playerMax, float playerAvg, float wallSpeed)
        {
            playerCurrentSpeed = playerCurrent;
            playerMaxSpeed = playerMax;
            playerAvgSpeed = playerAvg;
            deathWallSpeed = wallSpeed;
            timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }

    [Serializable]
    public class AnalyticsData
    {
        public List<SpeedAnalytics> records = new List<SpeedAnalytics>();
    }

    public class DeathWall : MonoBehaviour
    {
        private const string ANALYTICS_PREFS_KEY = "DeathWall_SpeedAnalytics";
        private const float ACTIVATION_DISTANCE = 30f;

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
        private float _playerSpeedSum;
        private int _playerSpeedSamples;
        private Vector3 _playerStartPosition;
        private bool _isActivated;
        private bool _hasReachedMaxSpeed;

        private void Awake()
        {
            CurrentSpeed = StartSpeed;
            _isActivated = false;
        }

        /// <summary>
        /// Records a death event with all speed analytics data
        /// </summary>
        private void RecordDeathAnalytics()
        {
            var analytics = LoadAnalytics();
            float playerAvgSpeed = _playerSpeedSamples > 0 ? _playerSpeedSum / _playerSpeedSamples : 0f;
            var record = new SpeedAnalytics(_playerCurrentSpeed, _playerMaxSpeed, playerAvgSpeed, CurrentSpeed);
            analytics.records.Add(record);
            SaveAnalytics(analytics);

            Debug.Log($"<color=cyan>[Analytics Recorded]</color> Total Deaths: {analytics.records.Count}", gameObject);
        }

        /// <summary>
        /// Loads analytics data from EditorPrefs
        /// </summary>
        public static AnalyticsData LoadAnalytics()
        {
            string json = UnityEditor.EditorPrefs.GetString(ANALYTICS_PREFS_KEY, "");
            if (string.IsNullOrEmpty(json))
            {
                return new AnalyticsData();
            }

            try
            {
                return JsonUtility.FromJson<AnalyticsData>(json);
            }
            catch
            {
                Debug.LogWarning("Failed to load analytics data. Returning empty dataset.");
                return new AnalyticsData();
            }
        }

        /// <summary>
        /// Saves analytics data to EditorPrefs
        /// </summary>
        private void SaveAnalytics(AnalyticsData data)
        {
            string json = JsonUtility.ToJson(data);
            UnityEditor.EditorPrefs.SetString(ANALYTICS_PREFS_KEY, json);
        }

        /// <summary>
        /// Clears all analytics data (called from custom editor)
        /// </summary>
        public static void ClearAnalytics()
        {
            UnityEditor.EditorPrefs.DeleteKey(ANALYTICS_PREFS_KEY);
            Debug.Log("<color=yellow>[Analytics Cleared]</color> All death records have been reset.");
        }

        private void Update()
        {
            // Track player speed and check activation distance
            if (StarterAssets.ThirdPersonController_RailGrinder.Instance != null)
            {
                var playerTransform = StarterAssets.ThirdPersonController_RailGrinder.Instance.transform;

                // Store player starting position on first frame
                if (_playerSpeedSamples == 0)
                {
                    _playerStartPosition = playerTransform.position;
                }

                var controller = StarterAssets.ThirdPersonController_RailGrinder.Instance.GetComponent<CharacterController>();
                if (controller != null)
                {
                    _playerCurrentSpeed = new Vector3(controller.velocity.x, 0f, controller.velocity.z).magnitude;
                    _playerSpeedSum += _playerCurrentSpeed;
                    _playerSpeedSamples++;
                    if (_playerCurrentSpeed > _playerMaxSpeed)
                    {
                        _playerMaxSpeed = _playerCurrentSpeed;
                    }
                }

                // Check if player has traveled 30 meters to activate the wall
                if (!_isActivated)
                {
                    float distanceTraveled = Vector3.Distance(_playerStartPosition, playerTransform.position);
                    if (distanceTraveled >= ACTIVATION_DISTANCE)
                    {
                        _isActivated = true;
                        Debug.Log($"<color=green>[Death Wall Activated]</color> Player reached {ACTIVATION_DISTANCE}m threshold!", gameObject);
                    }
                }
            }

            // Only move the wall if it has been activated
            if (_isActivated)
            {
                CurrentSpeed += Acceleration * Time.deltaTime;
                CurrentSpeed = Mathf.Min(CurrentSpeed, MaxSpeed);

                // Log when max speed is reached for the first time
                if (!_hasReachedMaxSpeed && CurrentSpeed >= MaxSpeed)
                {
                    _hasReachedMaxSpeed = true;
                    Debug.Log($"<color=magenta>[Death Wall Max Speed]</color> Reached maximum speed of {MaxSpeed:F2} m/s!", gameObject);
                }

                transform.position += Vector3.forward * CurrentSpeed * Time.deltaTime;
            }
        }

        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                Debug.Log($"<color=red>Player Killed!</color> <color=yellow>Current Speed: {_playerCurrentSpeed:F2} m/s</color> | <color=cyan>Max Speed Reached: {_playerMaxSpeed:F2} m/s</color> | <color=orange>Death Wall Speed: {CurrentSpeed:F2} m/s</color>", gameObject);
                RecordDeathAnalytics();
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
