using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.Scripts.FX
{
    public class OrbitalPickupDisplay : MonoBehaviour
    {
        [Header("Orbit Settings")]
        [field: SerializeField] public float OrbitRadius { get; private set; } = 1.2f;
        [field: SerializeField] public float OrbitSpeed { get; private set; } = 90f;
        [field: SerializeField] public float VerticalOffset { get; private set; } = 1.0f;

        [Header("Orb Appearance")]
        [field: SerializeField] public float OrbScale { get; private set; } = 0.15f;
        [field: SerializeField] public Color OrbColor { get; private set; } = new Color(1f, 0.85f, 0.2f, 1f);
        [field: SerializeField] public Material OrbMaterial { get; private set; }

        private readonly List<Transform> _orbs = new();
        private float _orbitAngle;

        public void AddOrb()
        {
            var orb = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            orb.name = $"PickupOrb_{_orbs.Count}";
            orb.transform.localScale = Vector3.one * OrbScale;

            // Remove collider so it doesn't interfere with gameplay
            var collider = orb.GetComponent<Collider>();
            if (collider != null)
            {
                Destroy(collider);
            }

            // Apply material
            var renderer = orb.GetComponent<Renderer>();
            if (renderer != null)
            {
                if (OrbMaterial != null)
                {
                    renderer.material = OrbMaterial;
                }
                else
                {
                    var mat = new Material(Shader.Find("Universal Render Pipeline/Lit"));
                    mat.SetColor("_BaseColor", OrbColor);
                    mat.SetColor("_EmissionColor", OrbColor * 2f);
                    mat.EnableKeyword("_EMISSION");
                    renderer.material = mat;
                }
            }

            _orbs.Add(orb.transform);
        }

        private void Update()
        {
            if (_orbs.Count == 0)
                return;

            _orbitAngle += OrbitSpeed * Time.deltaTime;

            float angleStep = 360f / _orbs.Count;
            var center = transform.position + Vector3.up * VerticalOffset;

            for (int i = 0; i < _orbs.Count; i++)
            {
                if (_orbs[i] == null)
                    continue;

                float angle = (_orbitAngle + angleStep * i) * Mathf.Deg2Rad;
                var offset = new Vector3(Mathf.Cos(angle), 0f, Mathf.Sin(angle)) * OrbitRadius;
                _orbs[i].position = center + offset;
            }
        }
    }
}
