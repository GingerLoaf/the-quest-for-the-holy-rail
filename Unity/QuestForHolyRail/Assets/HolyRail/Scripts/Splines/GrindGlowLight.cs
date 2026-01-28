using UnityEngine;

[ExecuteAlways]
public class GrindGlowLight : MonoBehaviour
{
    public Light grindLight;
    public float intensity = 1f;
    public float showHideDuration = 0.25f;

    private float _animTimer;
    private float _animFrom;
    private float _animTo;
    private bool _animating;
    private float _currentIntensity;

    public void Show()
    {
        _animFrom = _currentIntensity;
        _animTo = intensity;
        _animTimer = 0f;
        _animating = true;
    }

    public void Hide()
    {
        _animFrom = _currentIntensity;
        _animTo = 0f;
        _animTimer = 0f;
        _animating = true;
    }

    private void Update()
    {
        if (_animating)
        {
            _animTimer += Time.deltaTime;
            var t = Mathf.Clamp01(_animTimer / showHideDuration);
            _currentIntensity = Mathf.Lerp(_animFrom, _animTo, t);

            if (t >= 1f)
                _animating = false;
        }

        if (grindLight != null)
            grindLight.intensity = _currentIntensity;
    }
}
