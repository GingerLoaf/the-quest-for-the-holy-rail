using UnityEngine;

public class AttachmentPoint : MonoBehaviour
{
    [Tooltip("Whether this attachment point connects to something")]
    public bool IsPopulated;

    [Tooltip("True for ground-level points, false for air points")]
    public bool IsGround;
    
    private void OnDrawGizmos()
    {
        Gizmos.color = IsPopulated ? Color.green : Color.red;
        Gizmos.DrawSphere(transform.position, 0.2f);
    }
}
