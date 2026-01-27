using UnityEngine;

public abstract class BaseEnemyBot : MonoBehaviour
{
    protected EnemySpawner _spawner;
    protected Vector3 _velocity;
    protected float _noiseOffsetX;
    protected float _noiseOffsetY;
    protected float _noiseOffsetZ;

    [Header("Bot Settings")]
    [field: Tooltip("How quickly bots accelerate toward the player")]
    [field: SerializeField]
    public float BotAcceleration { get; private set; } = 8f;

    [field: Tooltip("Maximum movement speed of bots")]
    [field: SerializeField]
    public float BotMaxSpeed { get; private set; } = 6f;

    [field: Tooltip("The speed for smooth damping")]
    [field: SerializeField]
    public float SmoothTime { get; private set; } = 0.3f;
    
    [field: Tooltip("The speed for smooth rotation")]
    [field: SerializeField]
    public float RotationSmoothTime { get; private set; } = 0.12f;

    [field: Tooltip("Perlin noise magnitude for organic drift movement")]
    [field: SerializeField]
    public float BotNoiseAmount { get; private set; } = 1.5f;

    [field: Tooltip("Perlin noise frequency - higher = faster drift")]
    [field: SerializeField]
    public float BotNoiseSpeed { get; private set; } = 2f;
    
    [field: Tooltip("Bots within this distance will push away from each other")]
    [field: SerializeField]
    public float BotAvoidanceRadius { get; private set; } = 3f;

    [field: Tooltip("How strongly bots repel each other when too close")]
    [field: SerializeField]
    public float BotAvoidanceStrength { get; private set; } = 5f;
    
    [field: Tooltip("Collision radius of the bot for physics queries")]
    [field: SerializeField]
    public float BotCollisionRadius { get; private set; } = 1.5f;
    
    [field: Tooltip("The offset from the player to position the bot")]
    [field: SerializeField]
    public Vector3 DesiredOffsetFromPlayer { get; private set; } = new Vector3(0, 2, 15);


    private static readonly Collider[] _overlapResults = new Collider[16];
    private Camera _mainCamera;
    
    private float BotRadius => BotCollisionRadius;

    public void Initialize(EnemySpawner spawner)
    {
        _spawner = spawner;
    }

    protected virtual void Awake()
    {
        _mainCamera = Camera.main;
        if (_mainCamera == null)
        {
            Debug.LogError("Main Camera not found. Make sure a camera is tagged as 'Main Camera'");
        }
    }

    public virtual void OnSpawn()
    {
        _velocity = Vector3.zero;
        _noiseOffsetX = Random.Range(0f, 1000f);
        _noiseOffsetY = Random.Range(0f, 1000f);
        _noiseOffsetZ = Random.Range(0f, 1000f);
    }

    public virtual void OnRecycle()
    {
        _velocity = Vector3.zero;
    }

    protected virtual void Update()
    {
        if (_spawner == null || _spawner.Player == null)
        {
            return;
        }

        UpdateMovement();
    }

    protected virtual void UpdateMovement()
    {
        if (_mainCamera == null || _spawner == null || _spawner.Player == null)
        {
            return;
        }
        
        var playerTransform = _spawner.Player;
        var camTransform = _mainCamera.transform;

        // Desired position calculations based on camera view
        Vector3 forwardDirection = Vector3.ProjectOnPlane(camTransform.forward, Vector3.up).normalized;
        Vector3 targetPosition = playerTransform.position +
                                 (camTransform.right * DesiredOffsetFromPlayer.x) +
                                 (Vector3.up * DesiredOffsetFromPlayer.y) +
                                 (forwardDirection * DesiredOffsetFromPlayer.z);


        // Smoothly move towards the target position
        transform.position = Vector3.SmoothDamp(transform.position, targetPosition, ref _velocity, SmoothTime, BotMaxSpeed);

        // Smoothly rotate to face the player
        var toPlayer = playerTransform.position - transform.position;
        if (toPlayer.sqrMagnitude > 0.001f)
        {
            Quaternion targetRotation = Quaternion.LookRotation(toPlayer);
            transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, Time.deltaTime / RotationSmoothTime);
        }
    }
}
