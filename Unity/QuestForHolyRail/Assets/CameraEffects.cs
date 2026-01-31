using System.Collections;
using Cinemachine;
using UnityEngine;

public class CameraEffects : MonoBehaviour
{
    private Coroutine m_punchRoutineHandle;

    private float m_startFOV;

    private float m_startShake;
    
    public void PunchTime(float duration, float minScale = 0.05f)
    {
        if (m_punchRoutineHandle != null)
        {
            StopCoroutine(m_punchRoutineHandle);
            m_punchRoutineHandle = null;
            
            // Restore original data (the coroutine will stop suddenly and not finish
            var cinemachineCamera = CinemachineCore.Instance.GetVirtualCamera(0) as CinemachineVirtualCamera;
            if (cinemachineCamera)
            {
                cinemachineCamera.m_Lens.FieldOfView = m_startFOV;
            
                var noiseComponent = cinemachineCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
                if (noiseComponent)
                {
                    noiseComponent.m_FrequencyGain = m_startShake;
                }
            }
        }
        
        m_punchRoutineHandle = StartCoroutine(DoPunchTime(duration, minScale));
    }

    private IEnumerator DoPunchTime(float duration, float minScale)
    {
        Time.timeScale = minScale;
        
        m_startFOV = Camera.main.fieldOfView;

        CinemachineBasicMultiChannelPerlin noiseComponent = null;
        var cinemachineCamera = CinemachineCore.Instance.GetVirtualCamera(0) as CinemachineVirtualCamera;
        if (cinemachineCamera)
        {
            var fovFraction = cinemachineCamera.m_Lens.FieldOfView * .1f;
            cinemachineCamera.m_Lens.FieldOfView -= fovFraction;
            
            noiseComponent = cinemachineCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
            if (noiseComponent)
            {
                m_startShake = noiseComponent.m_FrequencyGain;
                noiseComponent.m_FrequencyGain = 100f;
            }
        }

        yield return new WaitForSecondsRealtime(duration);

        Time.timeScale = 1f;

        // Animate the FOV back in at the end
        var timeLeft = .25f;
        while (timeLeft > 0)
        {
            timeLeft -= Time.deltaTime;
            yield return null;

            if (cinemachineCamera)
            {
                cinemachineCamera.m_Lens.FieldOfView = Mathf.Lerp(cinemachineCamera.m_Lens.FieldOfView, m_startFOV, 1f - (timeLeft / .25f));
            }

            if (noiseComponent)
            {
                noiseComponent.m_FrequencyGain = Mathf.Lerp(noiseComponent.m_FrequencyGain, m_startShake, 1f - (timeLeft / .25f));
            }
        }
    }
}
