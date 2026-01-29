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

        [Header("Expiration Visual Feedback")]
        [field: SerializeField] public float WarningThreshold { get; private set; } = 2f;
        [field: SerializeField] public float PulseSpeed { get; private set; } = 8f;
        [field: SerializeField] public float MinPulseScale { get; private set; } = 0.5f;
        [field: SerializeField] public Color ExpiringColor { get; private set; } = new Color(1f, 0.3f, 0.1f, 1f);
        [field: SerializeField] public float FadeOutDuration { get; private set; } = 0.3f;

        private class OrbData
        {
            public Transform Transform;
            public Renderer Renderer;
            public Material Material;
            public int BoostId;
            public float TimeRemaining;
            public float Duration;
            public bool IsExpiring;
            public float FadeTimer;
        }

        private readonly List<OrbData> _orbs = new();
        private float _orbitAngle;

        public int AddOrb(int boostId, float duration)
        {
            var orb = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            orb.name = $"PickupOrb_{boostId}";
            orb.transform.localScale = Vector3.one * OrbScale;

            var collider = orb.GetComponent<Collider>();
            if (collider != null)
            {
                Destroy(collider);
            }

            var renderer = orb.GetComponent<Renderer>();
            Material mat = null;
            if (renderer != null)
            {
                if (OrbMaterial != null)
                {
                    mat = new Material(OrbMaterial);
                    renderer.material = mat;
                }
                else
                {
                    mat = new Material(Shader.Find("Universal Render Pipeline/Lit"));
                    mat.SetColor("_BaseColor", OrbColor);
                    mat.SetColor("_EmissionColor", OrbColor * 2f);
                    mat.EnableKeyword("_EMISSION");
                    renderer.material = mat;
                }
            }

            var orbData = new OrbData
            {
                Transform = orb.transform,
                Renderer = renderer,
                Material = mat,
                BoostId = boostId,
                TimeRemaining = duration,
                Duration = duration,
                IsExpiring = false,
                FadeTimer = 0f
            };

            _orbs.Add(orbData);
            return boostId;
        }

        public void UpdateBoostTime(int boostId, float timeRemaining)
        {
            foreach (var orb in _orbs)
            {
                if (orb.BoostId == boostId)
                {
                    orb.TimeRemaining = timeRemaining;
                    break;
                }
            }
        }

        public void RemoveOrb(int boostId)
        {
            for (int i = _orbs.Count - 1; i >= 0; i--)
            {
                if (_orbs[i].BoostId == boostId)
                {
                    _orbs[i].IsExpiring = true;
                    _orbs[i].FadeTimer = FadeOutDuration;
                    break;
                }
            }
        }

        public int ActiveOrbCount => _orbs.FindAll(o => !o.IsExpiring).Count;

        private void Update()
        {
            if (_orbs.Count == 0)
                return;

            _orbitAngle += OrbitSpeed * Time.deltaTime;

            int activeCount = 0;
            foreach (var orb in _orbs)
            {
                if (!orb.IsExpiring) activeCount++;
            }

            float angleStep = activeCount > 0 ? 360f / activeCount : 360f;
            var center = transform.position + Vector3.up * VerticalOffset;

            int activeIndex = 0;
            for (int i = _orbs.Count - 1; i >= 0; i--)
            {
                var orb = _orbs[i];
                if (orb.Transform == null)
                {
                    _orbs.RemoveAt(i);
                    continue;
                }

                if (orb.IsExpiring)
                {
                    orb.FadeTimer -= Time.deltaTime;
                    if (orb.FadeTimer <= 0f)
                    {
                        Destroy(orb.Transform.gameObject);
                        _orbs.RemoveAt(i);
                        continue;
                    }

                    float fadeProgress = orb.FadeTimer / FadeOutDuration;
                    orb.Transform.localScale = Vector3.one * OrbScale * fadeProgress;
                    if (orb.Material != null)
                    {
                        var fadeColor = OrbColor;
                        fadeColor.a = fadeProgress;
                        orb.Material.SetColor("_BaseColor", fadeColor);
                    }
                    continue;
                }

                float angle = (_orbitAngle + angleStep * activeIndex) * Mathf.Deg2Rad;
                var offset = new Vector3(Mathf.Cos(angle), 0f, Mathf.Sin(angle)) * OrbitRadius;
                orb.Transform.position = center + offset;

                bool isWarning = orb.TimeRemaining <= WarningThreshold && orb.TimeRemaining > 0f;
                if (isWarning)
                {
                    float pulseT = (Mathf.Sin(Time.time * PulseSpeed) + 1f) * 0.5f;
                    float urgency = 1f - (orb.TimeRemaining / WarningThreshold);
                    float minScale = Mathf.Lerp(1f, MinPulseScale, urgency);
                    float scale = Mathf.Lerp(minScale, 1f, pulseT);
                    orb.Transform.localScale = Vector3.one * OrbScale * scale;

                    if (orb.Material != null)
                    {
                        var lerpedColor = Color.Lerp(OrbColor, ExpiringColor, urgency);
                        orb.Material.SetColor("_BaseColor", lerpedColor);
                        orb.Material.SetColor("_EmissionColor", lerpedColor * (2f + urgency * 2f));
                    }
                }
                else
                {
                    orb.Transform.localScale = Vector3.one * OrbScale;
                    if (orb.Material != null)
                    {
                        orb.Material.SetColor("_BaseColor", OrbColor);
                        orb.Material.SetColor("_EmissionColor", OrbColor * 2f);
                    }
                }

                activeIndex++;
            }
        }

        [System.Obsolete("Use AddOrb(int boostId, float duration) instead for temporary boost system")]
        public void AddOrb()
        {
            AddOrb(-1, float.MaxValue);
        }
    }
}
