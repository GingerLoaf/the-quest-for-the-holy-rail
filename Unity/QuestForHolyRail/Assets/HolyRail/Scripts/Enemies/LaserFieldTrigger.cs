using UnityEngine;

namespace HolyRail.Scripts.Enemies
{
    public class LaserFieldTrigger : MonoBehaviour
    {
        private LaserBot _laserBot;

        private void Awake()
        {
            _laserBot = GetComponentInParent<LaserBot>();
            if (_laserBot == null)
            {
                Debug.LogError($"LaserFieldTrigger [{name}]: No LaserBot found in parent hierarchy.");
            }
        }

        public LaserBot GetLaserBot() => _laserBot;

        private void OnCollisionEnter(Collision collision)
        {
            if (_laserBot != null)
            {
                _laserBot.HandleLaserFieldCollision(collision);
            }
        }

        private void OnCollisionStay(Collision collision)
        {
            if (_laserBot != null)
            {
                _laserBot.HandleLaserFieldCollision(collision);
            }
        }
    }
}
