using System.Collections.Generic;
using Art.PickUps;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Splines;
using Unity.Mathematics;
using HolyRail.City;
using HolyRail.Scripts;
using HolyRail.Scripts.Enemies;
using HolyRail.Graffiti;
using Random = UnityEngine.Random;

#if ENABLE_INPUT_SYSTEM 
using UnityEngine.InputSystem;
#endif

/* Note: animations are called via the controller for both the character and capsule using animator null checks
 */

namespace StarterAssets
{
    [RequireComponent(typeof(CharacterController))]
#if ENABLE_INPUT_SYSTEM 
    [RequireComponent(typeof(PlayerInput))]
#endif
    [DefaultExecutionOrder(-1)]
    public class ThirdPersonController_RailGrinder : MonoBehaviour
    {
        public enum SplineTravelDirection
        {
            Unknown,
            StartToEnd,
            EndToStart,
            Stationary
        }

        private struct NearestPointResult
        {
            public float3 Position;
            public float Distance;
            public float SplineParameter;
            public SplineContainer Container;
            public SplineTravelDirection TravelDirection;

            public NearestPointResult(float3 position, float distance, float splineParameter, SplineContainer container, SplineTravelDirection travelDirection = SplineTravelDirection.Unknown)
            {
                Position = position;
                Distance = distance;
                SplineParameter = splineParameter;
                Container = container;
                TravelDirection = travelDirection;
            }
        }

        private struct SplineSamplePoint
        {
            public int ContainerIndex;
            public float T;  // Parameter along spline (0-1)
        }

        private class SplineContainerSpatialGrid
        {
            private readonly Dictionary<Vector2Int, List<SplineSamplePoint>> _cells = new();
            private readonly float _cellSize;
            private readonly float _sampleInterval;
            private readonly HashSet<int> _tempIndices = new();
            private SplineContainer[] _items;

            public SplineContainerSpatialGrid(float cellSize, float sampleInterval = 5f)
            {
                _cellSize = cellSize;
                _sampleInterval = sampleInterval;
            }

            public void Initialize(SplineContainer[] items)
            {
                _cells.Clear();
                _items = items;

                for (int i = 0; i < items.Length; i++)
                {
                    if (items[i] == null) continue;
                    var spline = items[i].Spline;
                    if (spline == null || spline.Count < 2) continue;

                    // Sample spline at regular world-space intervals
                    float length = spline.GetLength();
                    int numSamples = Mathf.Max(2, Mathf.CeilToInt(length / _sampleInterval));

                    for (int s = 0; s <= numSamples; s++)
                    {
                        float t = s / (float)numSamples;
                        var localPos = spline.EvaluatePosition(t);
                        var worldPos = items[i].transform.TransformPoint(localPos);
                        var cellKey = GetCellKey(worldPos);

                        if (!_cells.TryGetValue(cellKey, out var list))
                        {
                            list = new List<SplineSamplePoint>();
                            _cells[cellKey] = list;
                        }
                        list.Add(new SplineSamplePoint { ContainerIndex = i, T = t });
                    }
                }
            }

            public void GetItemsInRadius(Vector3 center, float radius, List<int> results)
            {
                results.Clear();
                if (_items == null) return;

                var minCell = GetCellKey(center - new Vector3(radius, 0, radius));
                var maxCell = GetCellKey(center + new Vector3(radius, 0, radius));

                // Collect unique container indices
                _tempIndices.Clear();
                for (int x = minCell.x; x <= maxCell.x; x++)
                {
                    for (int z = minCell.y; z <= maxCell.y; z++)
                    {
                        if (_cells.TryGetValue(new Vector2Int(x, z), out var samples))
                        {
                            foreach (var sample in samples)
                                _tempIndices.Add(sample.ContainerIndex);
                        }
                    }
                }

                foreach (var idx in _tempIndices)
                    results.Add(idx);
            }

            private Vector2Int GetCellKey(Vector3 pos) =>
                new Vector2Int(Mathf.FloorToInt(pos.x / _cellSize), Mathf.FloorToInt(pos.z / _cellSize));
        }

        /// <summary>
        /// Finds the nearest point on any spline within the provided buffer.
        /// </summary>
        /// <param name="worldPosition">The world position to find nearest point from</param>
        /// <param name="splineContainers">Buffer containing spline containers to search</param>
        /// <param name="count">Number of valid containers in the buffer</param>
        private NearestPointResult GetNearestPointOnSplinesNonAlloc(float3 worldPosition, SplineContainer[] splineContainers, int count)
        {
            var nearestPosition = float3.zero;
            var nearestDistance = float.PositiveInfinity;
            var nearestT = 0f;
            SplineContainer nearestContainer = null;

            for (int i = 0; i < count; i++)
            {
                var container = splineContainers[i];
                if (container == null)
                    continue;

                var splines = container.Splines;
                if (splines == null || splines.Count == 0)
                    continue;

                // Use indexed access instead of foreach to avoid enumerator allocation
                int splineCount = splines.Count;
                for (int j = 0; j < splineCount; j++)
                {
                    var spline = splines[j];
                    if (spline == null || spline.Count < 2)
                        continue;

                    // Early-out: if we already found a spline within grind threshold, skip expensive checks
                    if (nearestDistance <= GrindDistanceThreshold)
                        break;

                    using var native = new NativeSpline(spline, container.transform.localToWorldMatrix);
                    float distance = SplineUtility.GetNearestPoint(native, worldPosition, out float3 point, out float t);

                    if (distance < nearestDistance)
                    {
                        nearestDistance = distance;
                        nearestPosition = point;
                        nearestT = t;
                        nearestContainer = container;
                    }
                }

                // Early-out at container level too
                if (nearestDistance <= GrindDistanceThreshold)
                    break;
            }

            return new NearestPointResult(nearestPosition, nearestDistance, nearestT, nearestContainer);
        }

        /// <summary>
        /// Fallback method that searches all cached spline containers.
        /// Used when the spatial grid doesn't find nearby splines (e.g., spline geometry is far from transform.position).
        /// Also auto-refreshes the spatial grid if it appears stale (with cooldown to prevent spam).
        /// </summary>
        private NearestPointResult GetNearestPointOnAllSplines(float3 worldPosition)
        {
            // Check if we should try to refresh the spline cache (with cooldown)
            if (_splineRefreshCooldown <= 0f)
            {
                _splineRefreshCooldown = SplineRefreshInterval;
                var currentSplines = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);
                if (_splineContainers == null || currentSplines.Length != _splineContainers.Length)
                {
                    // Refresh the cached splines and spatial grid
                    _splineContainers = currentSplines;
                    _splineGrid?.Initialize(_splineContainers);
                }
            }
            else
            {
                _splineRefreshCooldown -= Time.deltaTime;
            }

            if (_splineContainers == null || _splineContainers.Length == 0)
            {
                return new NearestPointResult(float3.zero, float.PositiveInfinity, 0f, null);
            }

            return GetNearestPointOnSplinesNonAlloc(worldPosition, _splineContainers, _splineContainers.Length);
        }

        /// <summary>
        /// Fills the provided buffer with nearby spline containers and returns the count.
        /// This method avoids GC allocations by reusing the buffer.
        /// </summary>
        private int GetNearbySplineContainersNonAlloc(SplineContainer[] buffer)
        {
            _nearbySplineIndices.Clear();
            _splineGrid?.GetItemsInRadius(transform.position, SplineSearchRadius, _nearbySplineIndices);

            int count = _nearbySplineIndices.Count;
            if (count == 0) return 0;

            int copyCount = Mathf.Min(count, buffer.Length);
            for (int i = 0; i < copyCount; i++)
                buffer[i] = _splineContainers[_nearbySplineIndices[i]];

            return copyCount;
        }

        public InputAction grindInput;
        public InputAction lookBackInput;
        public InputAction sprayInput;
        public InputAction jumpBackflipInput;
        public InputAction jumpSideflipInput;
        public bool lookBack;
        private SplineContainer[] _splineContainers;
        private SplineContainerSpatialGrid _splineGrid;
        private List<int> _nearbySplineIndices = new List<int>();
        private SplineContainer[] _nearbyContainersBuffer = new SplineContainer[64];
        private const float SplineSearchRadius = 50f;
        private const float SplineGridCellSize = 30f;

        // Pre-allocated physics buffers to avoid GC allocations
        private static readonly Collider[] _wallRideHitBuffer = new Collider[32];
        private static readonly Collider[] _rampHitBuffer = new Collider[8];

        // Cooldown for auto-refreshing spline cache (prevents expensive FindObjectsByType spam)
        private float _splineRefreshCooldown;
        private const float SplineRefreshInterval = 1f;

        [Header("Player")]
        [Tooltip("Move speed of the character in m/s")]
        public float MoveSpeed = 2.0f;

        [Tooltip("Air control multiplier - lower values preserve momentum better (0 = no air control, 1 = full control)")]
        [SerializeField] private float _airControlMultiplier = 1f;

        [Tooltip("Duration to preserve momentum after exiting a grind (prevents deceleration)")]
        public float MomentumPreservationTime = 0.5f;

        [Tooltip("How fast the character turns to face movement direction")]
        [Range(0.0f, 0.3f)]
        public float RotationSmoothTime = 0.12f;

        [Tooltip("Acceleration and deceleration")]
        public float SpeedChangeRate = 10.0f;

        [Tooltip("Sound effects played when landing (random selection)")]
        public AudioClip[] SkateLandingAudioClips;
        [Tooltip("Looping sound effect while skating")]
        public AudioClip SkateLoopAudioClip;
        [Range(0, 1)] public float SkateAudioVolume = 0.5f;

        [Space(10)]
        [Tooltip("The height the player can jump")]
        public float JumpHeight = 1.2f;

        [Tooltip("The character uses its own gravity value. The engine default is -9.81f")]
        public float Gravity = -15.0f;

        [Space(10)]
        [Tooltip("Time required to pass before being able to jump again. Set to 0f to instantly jump again")]
        public float JumpTimeout = 0f;

        [Tooltip("Time required to pass before entering the fall state. Useful for walking down stairs")]
        public float FallTimeout = 0.15f;

        [Header("Player Grounded")]
        [Tooltip("If the character is grounded or not. Not part of the CharacterController built in grounded check")]
        public bool Grounded = true;

        [Tooltip("Useful for rough ground")]
        public float GroundedOffset = -0.14f;

        [Tooltip("The radius of the grounded check. Should match the radius of the CharacterController")]
        public float GroundedRadius = 0.28f;

        [Tooltip("What layers the character uses as ground")]
        public LayerMask GroundLayers;

        [Header("Grinding")]
        public SplineContainer GrindSpline;
        public SplineMeshController SplineMeshController;
        public float GrindSpeed = 8f;
        public float GrindAcceleration = 12f;
        public float GrindRotationSmoothTime = 0.08f;
        public float GrindDistanceThreshold = 2f;
        public bool AutoGrind = false;
        public float GrindExitCooldown = 0.3f;
        [Tooltip("Vertical offset for grind detection. 0 = on rail, negative = below rail allowed")]
        public float GrindTriggerOffset = -0.5f;

        [Tooltip("Multiplier for momentum when jumping off a rail (1.0 = full momentum)")]
        public float GrindJumpMomentumMultiplier = 1.0f;

        [Tooltip("Jump height when automatically hopping off the end of a rail")]
        public float GrindEndJumpHeight = 0.6f;

        [Tooltip("Speed boost applied when starting a grind")]
        public float GrindStartBoost = 4f;

        [Header("Wall Riding")]
        [Tooltip("Enable wall ride mechanics")]
        public bool EnableWallRide = true;
        [Tooltip("Layer mask for billboard colliders")]
        public LayerMask WallRideLayers;
        [Tooltip("Detection radius for wall ride trigger")]
        public float WallRideDetectionRadius = 1.5f;
        [Tooltip("Distance threshold for magnet effect to snap to wall")]
        public float WallRideMagnetThreshold = 1.0f;
        [Tooltip("Horizontal speed while wall riding")]
        public float WallRideSpeed = 10f;
        [Tooltip("Speed boost applied when starting a wall ride")]
        public float WallRideSpeedBoost = 3f;
        [Tooltip("Vertical height gain rate while wall riding (m/s)")]
        public float WallRideHeightGainRate = 2f;
        [Tooltip("Cooldown before player can wall ride again after exiting")]
        public float WallRideExitCooldown = 0.3f;
        [Tooltip("Jump height when exiting wall ride with jump")]
        public float WallRideJumpHeight = 1.2f;
        [Tooltip("Grace period after leaving wall where player can still jump (Coyote Time)")]
        public float WallRideCoyoteTime = 0.3f;
        [Tooltip("Particle systems to enable emission while wall riding (one per foot)")]
        public ParticleSystem[] WallRideParticleSystems;

        [Tooltip("How quickly the start boost decays toward base grind speed")]
        public float GrindBoostDecayRate = 8f;

        [Header("Ramp Boost")]
        [Tooltip("Layer mask for ramp colliders")]
        public LayerMask RampLayers;
        [Tooltip("Speed boost applied when going over a ramp")]
        public float RampBoostAmount = 5f;
        [Tooltip("Cooldown before ramp boost can trigger again")]
        public float RampBoostCooldown = 0.5f;

        [Header("Grind Collision")]
        [Tooltip("Layers that will knock the player off the rail when touched")]
        public LayerMask GrindObstacleLayers;

        [Header("Dash")]
        [Tooltip("Speed boost applied when dashing")]
        public float DashSpeedBoost = 8f;
        [Tooltip("How long the dash boost is sustained before decaying")]
        public float DashDuration = 0.3f;
        [Tooltip("Cooldown before dash can be used again")]
        public float DashCooldown = 1.0f;
        [Tooltip("Sound effect played when dashing")]
        public AudioClip DashAudioClip;

        [Header("Boost")]
        [Tooltip("Speed boost applied when boosting")]
        public float BoostSpeedBoost = 10f;
        [Tooltip("How long the boost lasts")]
        public float BoostDuration = 0.5f;
        [Tooltip("Cooldown before boost can be used again")]
        public float BoostCooldown = 2.0f;
        [Tooltip("Sound effect played when boosting")]
        public AudioClip BoostAudioClip;

        [Header("Jump Audio")]
        [Tooltip("Sound effects played when jumping (random selection)")]
        public AudioClip[] JumpAudioClips;
        [Range(0, 1)] public float JumpAudioVolume = 0.5f;

        [Header("Wall Ride Audio")]
        [Tooltip("Sound effect played when starting a wall ride")]
        public AudioClip WallRideStartAudioClip;
        [Tooltip("Looping sound effect while wall riding")]
        public AudioClip WallRideLoopAudioClip;
        [Range(0, 1)] public float WallRideAudioVolume = 0.5f;

        [Header("Combat Audio")]
        [Tooltip("Sound effect played when taking knockback damage")]
        public AudioClip KnockbackAudioClip;
        [Tooltip("Sound effect played when activating parry")]
        public AudioClip ParryActivateAudioClip;
        [Tooltip("Sound effect played on successful parry deflection")]
        public AudioClip ParrySuccessAudioClip;
        [Range(0, 1)] public float CombatAudioVolume = 0.7f;

        [Header("Ramp Audio")]
        [Tooltip("Sound effect played when getting a ramp boost")]
        public AudioClip RampBoostAudioClip;
        [Range(0, 1)] public float RampBoostAudioVolume = 0.5f;

        [Header("Spray Audio")]
        [Tooltip("Sound effect played when starting to spray")]
        public AudioClip SprayShakeAudioClip;
        [Tooltip("Looping sound effects while spraying (random selection)")]
        public AudioClip[] SprayLoopAudioClips;
        [Range(0, 1)] public float SprayAudioVolume = 0.5f;

        [Space(10)]
        [Tooltip("Sound effects played when landing on a rail (random selection)")]
        public AudioClip[] GrindStartAudioClips;
        [Tooltip("Looping sound effect while grinding")]
        public AudioClip GrindLoopAudioClip;
        [Range(0, 1)] public float GrindAudioVolume = 0.5f;

        [Space(10)]
        [Tooltip("Particle systems to enable emission while grinding")]
        public ParticleSystem[] GrindParticleSystems;

        [Header("Parry VFX")]
        [Tooltip("Trail renderers to enable during parry window")]
        [SerializeField] private TrailRenderer[] _parryTrailRenderers;

        [Header("Spray Graffiti")]
        [Tooltip("Particle system for spray effect")]
        [SerializeField] private ParticleSystem _sprayEffect;
        [Tooltip("Transform used as origin for spray particles and LookAt target")]
        [SerializeField] private Transform _sprayPivot;

        public GrindGlowLight GrindGlowLight;

        private AudioSource _grindLoopAudioSource;
        private AudioSource _skateLoopAudioSource;
        private AudioSource _wallRideLoopAudioSource;
        private AudioSource _sprayLoopAudioSource;
        private bool _wasSprayingLastFrame;
        private bool _isGrinding;
        private float _grindExitCooldownTimer;
        private float _momentumPreservationTimer;
        private float _grindT;                 // Normalized spline position (0–1)
        private float _grindSplineLength;
        private float _grindSpeedCurrent;
        private float _grindRotationVelocity;
        private SplineTravelDirection _grindDirection;

        // Wall ride state
        private bool _isWallRiding;
        private float _wallRideSpeedCurrent;
        private Vector3 _wallRideVelocity;     // Projected velocity on wall plane
        private Vector3 _wallRideNormal;       // Wall surface normal (pointing into corridor)
        private Vector3 _wallRideRight;        // Right direction along wall
        private Vector3 _currentBillboardCenter;
        private Vector3 _currentBillboardScale;
        private float _wallPlaneDistance;        // Distance from origin to wall surface plane
        private float _wallRideExitCooldownTimer;
        private float _wallRideRotationVelocity;
        private float _wallRideCoyoteTimer;
        private float _jumpBufferTimer;
        private const float JumpBufferTime = 0.2f;  // 200ms buffer window for more forgiving input
        private float _wallRideJumpGraceTimer;      // Grace period after starting wall ride before jump is allowed
        private const float WallRideJumpGraceTime = 0.15f;  // 150ms grace period

        // Preserved exit velocity for wall ride detection after grind exit
        private Vector3 _preservedExitVelocity;

        private float _parryWindowTimer;
        private bool _parryWindowActive;

        // Spray graffiti state
        private GraffitiSpot _activeGraffiti;
        private Vector3 _sprayTargetPosition;
        private bool _isSpraying;

        // Ramp boost state
        private float _rampBoostCooldownTimer;

        // Spawn position for soft reset
        private Vector3 _spawnPosition;
        private Quaternion _spawnRotation;

        // Dash state
        private bool _isDashing;
        private float _dashTimer;
        private float _dashCooldownTimer;
        private Vector3 _dashDirection;

        // Boost state
        private bool _isBoosting;
        public bool IsBoosting => _isBoosting;
        private float _boostTimer;
        private float _boostCooldownTimer;
        private Vector3 _boostDirection;

        // Knockback state
        private bool _isKnockedBack;
        private float _knockbackTimer;
        private Vector3 _knockbackVelocity;
        private const float KnockbackDuration = 0.3f;

        // Frame skipping for expensive airborne checks
        private int _airborneCheckFrame;

        [Header("Grind Camera Effects")]
        [Tooltip("Reference to the Cinemachine Virtual Camera")]
        public Cinemachine.CinemachineVirtualCamera VirtualCamera;
        [Tooltip("FOV increase when grinding")]
        public float GrindFOVBoost = 10f;
        [Tooltip("Speed of FOV transition")]
        public float FOVLerpSpeed = 5f;

        [Header("Cinemachine")]
        [Tooltip("The follow target set in the Cinemachine Virtual Camera that the camera will follow")]
        public GameObject CinemachineCameraTarget;

        [Tooltip("How far in degrees can you move the camera up")]
        public float TopClamp = 70.0f;

        [Tooltip("How far in degrees can you move the camera down")]
        public float BottomClamp = -30.0f;

        [Tooltip("Additional degress to override the camera. Useful for fine tuning camera position when locked")]
        public float CameraAngleOverride = 0.0f;

        [Tooltip("For locking the camera position on all axis")]
        public bool LockCameraPosition = false;

        [Tooltip("Smoothing time for camera look movement")]
        public float LookSmoothTime = 0.1f;

        [Tooltip("Camera look sensitivity")]
        public float LookSpeed = 1.0f;

        // cinemachine
        private float _cinemachineTargetYaw;
        private float _cinemachineTargetPitch;

        // Look smoothing
        private float _smoothYaw;
        private float _smoothPitch;
        private float _yawVelocity;
        private float _pitchVelocity;

        // FOV
        private float _baseFOV;
        private float _targetFOV;

        // player
        private float _speed;
        private float _animationBlend;
        private float _targetRotation = 0.0f;
        private float _rotationVelocity;
        private float _verticalVelocity;
        private float _terminalVelocity = 53.0f;

        // timeout deltatime
        private float _jumpTimeoutDelta;
        private float _fallTimeoutDelta;

        // animation IDs
        private int _animIDSpeed;
        private int _animIDGrounded;
        private int _animIDJump;
        private int _animIDFreeFall;
        private int _animIDMotionSpeed;
        private int _animIDGrinding;
        private int _animIDParry;
        private int _animIDJumpBackflip;
        private int _animIDJumpSideflip;

#if ENABLE_INPUT_SYSTEM 
        private PlayerInput _playerInput;
#endif
        private Animator _animator;
        private CharacterController _controller;
        private StarterAssetsInputs _input;
        private GameObject _mainCamera;

        private const float _threshold = 0.01f;

        private bool _hasAnimator;

        private bool IsCurrentDeviceMouse
        {
            get
            {
#if ENABLE_INPUT_SYSTEM
                return _playerInput.currentControlScheme == "KeyboardMouse";
#else
				return false;
#endif
            }
        }
        
        public static ThirdPersonController_RailGrinder Instance { get; private set; }
        
        private void Awake()
        {
            Instance = this;
            // get a reference to our main camera
            if (_mainCamera == null)
            {
                _mainCamera = GameObject.FindGameObjectWithTag("MainCamera");
            }
            _splineContainers = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);
            _splineGrid = new SplineContainerSpatialGrid(SplineGridCellSize, 5f);  // 5 unit sample interval
            _splineGrid.Initialize(_splineContainers);
        }

        /// <summary>
        /// Refresh the cached spline containers array.
        /// Call this when new SplineContainers are created dynamically at runtime
        /// (e.g., by RadialSplineController).
        /// </summary>
        public void RefreshSplineContainers()
        {
            _splineContainers = FindObjectsByType<SplineContainer>(FindObjectsSortMode.None);
            _splineGrid?.Initialize(_splineContainers);
        }

        private void OnEnable()
        {
            // grindInput disabled - auto-grind only
            // grindInput.Enable();
            // grindInput.performed += OnGrindRequested;

            lookBackInput.Enable();
            sprayInput.Enable();
            jumpBackflipInput.Enable();
            jumpSideflipInput.Enable();
        }

        private void OnDisable()
        {
            // grindInput disabled - auto-grind only
            // grindInput.performed -= OnGrindRequested;
            // grindInput.Disable();

            lookBackInput.Disable();
            sprayInput.Disable();
            jumpBackflipInput.Disable();
            jumpSideflipInput.Disable();

            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.OnPlayerDeath -= HandlePlayerDeath;
            }
        }

        private void Start()
        {
            _cinemachineTargetYaw = CinemachineCameraTarget.transform.rotation.eulerAngles.y;
            
            _hasAnimator = TryGetComponent(out _animator);
            _controller = GetComponent<CharacterController>();
            _input = GetComponent<StarterAssetsInputs>();
#if ENABLE_INPUT_SYSTEM 
            _playerInput = GetComponent<PlayerInput>();
#else
			Debug.LogError( "Starter Assets package is missing dependencies. Please use Tools/Starter Assets/Reinstall Dependencies to fix it");
#endif

            AssignAnimationIDs();

            // reset our timeouts on start
            _jumpTimeoutDelta = JumpTimeout;
            _fallTimeoutDelta = FallTimeout;

            // Initialize FOV
            if (VirtualCamera != null)
            {
                _baseFOV = VirtualCamera.m_Lens.FieldOfView;
                _targetFOV = _baseFOV;
            }

            // Initialize grind loop audio source
            _grindLoopAudioSource = gameObject.AddComponent<AudioSource>();
            _grindLoopAudioSource.loop = true;
            _grindLoopAudioSource.playOnAwake = false;
            _grindLoopAudioSource.spatialBlend = 0f; // 2D sound

            // Initialize skate loop audio source
            _skateLoopAudioSource = gameObject.AddComponent<AudioSource>();
            _skateLoopAudioSource.loop = true;
            _skateLoopAudioSource.playOnAwake = false;
            _skateLoopAudioSource.spatialBlend = 0f; // 2D sound

            // Initialize wall ride loop audio source
            _wallRideLoopAudioSource = gameObject.AddComponent<AudioSource>();
            _wallRideLoopAudioSource.loop = true;
            _wallRideLoopAudioSource.playOnAwake = false;
            _wallRideLoopAudioSource.spatialBlend = 0f; // 2D sound

            // Initialize spray loop audio source
            _sprayLoopAudioSource = gameObject.AddComponent<AudioSource>();
            _sprayLoopAudioSource.loop = true;
            _sprayLoopAudioSource.playOnAwake = false;
            _sprayLoopAudioSource.spatialBlend = 0f; // 2D sound

            // Ensure parry trail renderers start disabled
            foreach (var trail in _parryTrailRenderers)
            {
                if (trail != null) trail.emitting = false;
            }

            // Store spawn position for soft reset
            _spawnPosition = transform.position;
            _spawnRotation = transform.rotation;

            if (GameSessionManager.Instance != null)
            {
                GameSessionManager.Instance.ResetHealth();
                GameSessionManager.Instance.ClearPickups();
                GameSessionManager.Instance.OnPlayerDeath += HandlePlayerDeath;
            }
        }

        private void Update()
        {
            bool gamepadLookBack = Gamepad.current != null && Gamepad.current.leftShoulder.isPressed;
            lookBack = gamepadLookBack || Input.GetKey(KeyCode.Q);

            // Buffer jump input for better responsiveness
            // Check multiple input sources to ensure we don't miss the press
            bool jumpPressed = _input.jump;
            jumpPressed |= Input.GetKeyDown(KeyCode.Space);
            jumpPressed |= Gamepad.current != null && Gamepad.current.buttonSouth.wasPressedThisFrame;

            if (jumpPressed)
            {
                _jumpBufferTimer = JumpBufferTime;
            }
            if (_jumpBufferTimer > 0f)
            {
                _jumpBufferTimer -= Time.deltaTime;
            }

            // Fall death check - kill player if they fall below -50
            if (transform.position.y < -50f)
            {
                Debug.Log("<color=red>Player fell off the map!</color>");
                GameSessionManager.Instance.TakeDamage(1000);
                return;
            }

            // Update dash cooldown
            if (_dashCooldownTimer > 0f)
            {
                _dashCooldownTimer -= Time.deltaTime;
            }

            // Update boost cooldown
            if (_boostCooldownTimer > 0f)
            {
                _boostCooldownTimer -= Time.deltaTime;
            }

            // Update dash state (must run every frame regardless of player state)
            UpdateDash();

            // Update boost state (must run every frame regardless of player state)
            UpdateBoost();

            // Update knockback state
            UpdateKnockback();

            // Check for dash input (requires ability unlock)
            if (_input.dash)
            {
                _input.dash = false;
                if (AbilityPickUp.IsAbilityUnlocked(AbilityType.Dash))
                {
                    TryStartDash();
                }
            }

            // Check for boost input (requires ability unlock)
            if (_input.boost)
            {
                _input.boost = false;
                if (AbilityPickUp.IsAbilityUnlocked(AbilityType.Boost))
                {
                    TryStartBoost();
                }
            }

            if (_isGrinding)
            {
                Grind();
            }
            else if (_isWallRiding)
            {
                WallRide();
            }
            else
            {
                if (_grindExitCooldownTimer > 0f)
                {
                    _grindExitCooldownTimer -= Time.deltaTime;
                }

                if (_wallRideExitCooldownTimer > 0f)
                {
                    _wallRideExitCooldownTimer -= Time.deltaTime;
                }

                if (_momentumPreservationTimer > 0f)
                {
                    _momentumPreservationTimer -= Time.deltaTime;
                }

                // Run GroundedCheck FIRST to have accurate grounded state for wall ride detection
                GroundedCheck();

                // Frame skip for expensive airborne checks (every 3 frames)
                _airborneCheckFrame++;
                bool shouldCheckAirborne = _airborneCheckFrame % 3 == 0;

                // Auto-grind: cooldown prevents immediate re-attach after jumping off
                if (shouldCheckAirborne && AutoGrind && !Grounded && _grindExitCooldownTimer <= 0f)
                {
                    if (TryStartGrind())
                    {
                        return; // Exit Update - controller is now disabled for grinding
                    }
                }

                // Wall ride detection: only when airborne and not grinding
                if (shouldCheckAirborne && EnableWallRide && !Grounded && _wallRideExitCooldownTimer <= 0f)
                {
                    if (TryStartWallRide())
                    {
                        return; // Exit Update - controller is now disabled for wall riding
                    }
                }

                // Wall ride coyote time - allow jump even after leaving wall
                if (_wallRideCoyoteTimer > 0f)
                {
                    _wallRideCoyoteTimer -= Time.deltaTime;

                    if (_jumpBufferTimer > 0f)
                    {
                        // Grant a full wall ride jump
                        _verticalVelocity = Mathf.Sqrt(WallRideJumpHeight * -2f * Gravity);
                        _wallRideCoyoteTimer = 0f;
                        _jumpBufferTimer = 0f;
                        _input.jump = false;

                        if (_hasAnimator)
                        {
                            _animator.SetBool(_animIDJump, true);
                        }
                    }
                }

                JumpAndGravity();
                Move();
            }

            // Handle parry input - start parry window (requires ability unlock)
            if (_input.parry)
            {
                _input.parry = false;
                if (_hasAnimator && AbilityPickUp.IsAbilityUnlocked(AbilityType.Parry))
                {
                    _animator.SetTrigger(_animIDParry);
                    _parryWindowActive = true;

                    // Apply parry window multiplier
                    var parryWindowMultiplier = GameSessionManager.Instance.GetUpgradeValue(UpgradeType.ParryTimeWindow);
                    _parryWindowTimer = (EnemySpawner.Instance != null ? EnemySpawner.Instance.ParryWindowDuration : 0.3f) + parryWindowMultiplier;

                    // Enable parry trail effect
                    foreach (var trail in _parryTrailRenderers)
                    {
                        if (trail != null) trail.emitting = true;
                    }

                    // Play parry activate sound
                    if (ParryActivateAudioClip != null)
                    {
                        AudioSource.PlayClipAtPoint(ParryActivateAudioClip, transform.position, CombatAudioVolume);
                    }
                }
            }

            // Handle jump backflip input
            if (jumpBackflipInput.triggered && _hasAnimator)
            {
                _animator.SetTrigger(_animIDJumpBackflip);
            }

            // Handle jump sideflip input
            if (jumpSideflipInput.triggered && _hasAnimator)
            {
                _animator.SetTrigger(_animIDJumpSideflip);
            }

            // Process active parry window
            if (_parryWindowActive)
            {
                _parryWindowTimer -= Time.deltaTime;
                TryDeflectBullet();
                if (_parryWindowTimer <= 0f)
                {
                    _parryWindowActive = false;

                    // Disable parry trail effect
                    foreach (var trail in _parryTrailRenderers)
                    {
                        if (trail != null) trail.emitting = false;
                    }
                }
            }

            // Handle spray input - enable/disable emission based on trigger
            UpdateSprayEffect();
        }

        private void UpdateSprayEffect()
        {
            if (_sprayEffect == null)
            {
                return;
            }

            bool wantSpray = sprayInput.IsPressed();
            var emission = _sprayEffect.emission;
            emission.enabled = wantSpray;

            // Aim at graffiti target if we have one and are spraying
            if (wantSpray && _sprayPivot != null && _sprayTargetPosition != Vector3.zero)
            {
                _sprayPivot.LookAt(_sprayTargetPosition);
            }

            // Handle spray audio
            if (wantSpray && !_wasSprayingLastFrame)
            {
                // Just started spraying - play shake sound and start loop
                if (SprayShakeAudioClip != null)
                {
                    AudioSource.PlayClipAtPoint(SprayShakeAudioClip, transform.position, SprayAudioVolume);
                }

                // Start spray loop sound
                if (SprayLoopAudioClips != null && SprayLoopAudioClips.Length > 0 && _sprayLoopAudioSource != null)
                {
                    _sprayLoopAudioSource.clip = SprayLoopAudioClips[Random.Range(0, SprayLoopAudioClips.Length)];
                    _sprayLoopAudioSource.volume = SprayAudioVolume;
                    _sprayLoopAudioSource.Play();
                }
            }
            else if (!wantSpray && _wasSprayingLastFrame)
            {
                // Just stopped spraying - stop loop
                if (_sprayLoopAudioSource != null && _sprayLoopAudioSource.isPlaying)
                {
                    _sprayLoopAudioSource.Stop();
                }
            }

            _wasSprayingLastFrame = wantSpray;
        }

        private void LateUpdate()
        {
            CameraRotation();
            UpdateGrindFOV();
        }

        private void AssignAnimationIDs()
        {
            _animIDSpeed = Animator.StringToHash("Speed");
            _animIDGrounded = Animator.StringToHash("Grounded");
            _animIDJump = Animator.StringToHash("Jump");
            _animIDFreeFall = Animator.StringToHash("FreeFall");
            _animIDMotionSpeed = Animator.StringToHash("MotionSpeed");
            _animIDGrinding = Animator.StringToHash("Grinding");
            _animIDParry = Animator.StringToHash("Parry");
            _animIDJumpBackflip = Animator.StringToHash("JumpBackflip");
            _animIDJumpSideflip = Animator.StringToHash("JumpSideflip");
        }

        private void GroundedCheck()
        {
            // set sphere position, with offset
            Vector3 spherePosition = new Vector3(transform.position.x, transform.position.y - GroundedOffset,
                transform.position.z);

            // Combine GroundLayers and RampLayers so player can walk on ramps
            LayerMask combinedGroundLayers = GroundLayers | RampLayers;
            Grounded = Physics.CheckSphere(spherePosition, GroundedRadius, combinedGroundLayers,
                QueryTriggerInteraction.Ignore);

            // Check for ramp boost
            CheckRampBoost(spherePosition);

            // update animator if using character
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDGrounded, Grounded);
            }
        }

        private void CheckRampBoost(Vector3 checkPosition)
        {
            // Decrement cooldown
            if (_rampBoostCooldownTimer > 0f)
            {
                _rampBoostCooldownTimer -= Time.deltaTime;
                return;
            }

            // Only check for ramps if we have a valid layer mask
            if (RampLayers == 0)
                return;

            // Check if we're touching a ramp
            if (Physics.CheckSphere(checkPosition, GroundedRadius * 1.5f, RampLayers, QueryTriggerInteraction.Ignore))
            {
                // Apply ramp boost
                ApplyRampBoost();
                _rampBoostCooldownTimer = RampBoostCooldown;
            }
        }

        private void ApplyRampBoost()
        {
            if (RampBoostAmount <= 0f)
                return;

            // Apply boost in the direction the player is moving
            var boostDirection = _controller.velocity.normalized;
            if (boostDirection.sqrMagnitude < 0.1f)
            {
                // If not moving, use forward direction
                boostDirection = transform.forward;
            }

            // Add horizontal boost to current speed
            _speed += RampBoostAmount;

            // Play ramp boost sound
            if (RampBoostAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(RampBoostAudioClip, transform.position, RampBoostAudioVolume);
            }
        }

        private void CameraRotation()
        {
            // if there is an input and camera position is not fixed
            if (_input.look.sqrMagnitude >= _threshold && !LockCameraPosition)
            {
                //Don't multiply mouse input by Time.deltaTime;
                float deltaTimeMultiplier = IsCurrentDeviceMouse ? 1.0f : Time.deltaTime;

                _cinemachineTargetYaw += _input.look.x * deltaTimeMultiplier * LookSpeed;
                _cinemachineTargetPitch += _input.look.y * deltaTimeMultiplier * LookSpeed;
            }

            // clamp our rotations so our values are limited 360 degrees
            _cinemachineTargetYaw = ClampAngle(_cinemachineTargetYaw, float.MinValue, float.MaxValue);
            float prevPitch = _cinemachineTargetPitch;
            _cinemachineTargetPitch = ClampAngle(_cinemachineTargetPitch, BottomClamp, TopClamp);
            if (_cinemachineTargetPitch != prevPitch)
            {
                _pitchVelocity = 0f;
            }

            // Smooth the rotation values
            _smoothYaw = Mathf.SmoothDampAngle(_smoothYaw, _cinemachineTargetYaw, ref _yawVelocity, LookSmoothTime);
            _smoothPitch = Mathf.SmoothDamp(_smoothPitch, _cinemachineTargetPitch, ref _pitchVelocity, LookSmoothTime);

            // Apply 180 degree offset when looking back
            float finalYaw = lookBack ? _smoothYaw + 180f : _smoothYaw;

            // Cinemachine will follow this target
            CinemachineCameraTarget.transform.rotation = Quaternion.Euler(_smoothPitch + CameraAngleOverride,
                finalYaw, 0.0f);
        }

        private void UpdateGrindFOV()
        {
            if (VirtualCamera == null) return;

            _targetFOV = _isGrinding ? (_baseFOV + GrindFOVBoost) : _baseFOV;

            var lens = VirtualCamera.m_Lens;
            lens.FieldOfView = Mathf.Lerp(lens.FieldOfView, _targetFOV, Time.deltaTime * FOVLerpSpeed);
            VirtualCamera.m_Lens = lens;
        }

        private bool TryStartGrind()
        {
            if (_isGrinding) return false;

            int nearbyCount = GetNearbySplineContainersNonAlloc(_nearbyContainersBuffer);

            NearestPointResult result;
            if (nearbyCount > 0)
            {
                // Use spatial grid results
                result = GetNearestPointOnSplinesNonAlloc(
                    transform.position,
                    _nearbyContainersBuffer,
                    nearbyCount);
            }
            else
            {
                // Fallback: spatial grid found nothing, search all splines
                // This handles splines whose transform.position is far from their geometry
                result = GetNearestPointOnAllSplines(transform.position);
            }

            if (result.Container == null)
            {
                return false;
            }

            // Hemisphere check: only grind if player is above the rail (with offset)
            float playerY = transform.position.y;
            float railY = result.Position.y;
            if (playerY < railY + GrindTriggerOffset)
            {
                return false;
            }

            if (result.Distance <= GrindDistanceThreshold)
            {
                var direction = GetVelocityBasedGrindDirection(result.Container, result.SplineParameter);
                StartGrind(result.Container, result.SplineParameter, direction);
                return true;
            }
            return false;
        }

        private SplineTravelDirection GetVelocityBasedGrindDirection(SplineContainer container, float t)
        {
            if (container == null || container.Spline == null)
                return SplineTravelDirection.StartToEnd;

            // Get world-space tangent at the given spline parameter
            Vector3 tangent = container.transform.TransformDirection(
                (Vector3)container.Spline.EvaluateTangent(t)
            ).normalized;

            // Flatten to horizontal plane
            tangent.y = 0f;
            tangent.Normalize();

            // Use player's velocity to determine grind direction
            // If no velocity, use player's facing direction
            Vector3 playerDirection = _controller.velocity;
            playerDirection.y = 0f;
            if (playerDirection.sqrMagnitude < 0.1f)
            {
                playerDirection = transform.forward;
            }
            playerDirection.Normalize();

            // Dot product: positive means same direction as tangent (StartToEnd)
            // negative means opposite direction (EndToStart)
            float dot = Vector3.Dot(playerDirection, tangent);
            return dot >= 0 ? SplineTravelDirection.StartToEnd : SplineTravelDirection.EndToStart;
        }

        void OnGrindRequested(InputAction.CallbackContext context)
        {
            // Only start grind if not already grinding - jump (A) is the only way to exit
            if (!_isGrinding)
            {
                if (!TryStartGrind())
                {
                    Debug.LogWarning("No spline within grind distance threshold.");
                }
            }
        }

        public void StartGrind(SplineContainer spline, float startT, SplineTravelDirection direction = SplineTravelDirection.StartToEnd)
        {
            GrindSpline = spline;
            SplineMeshController = spline.GetComponent<SplineMeshController>();
            _grindT = Mathf.Clamp01(startT);
            _grindSplineLength = spline.CalculateLength();

            _grindSpeedCurrent = GrindSpeed + GrindStartBoost;
            _verticalVelocity = 0f;
            _isGrinding = true;
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, false);
                _animator.SetBool(_animIDGrinding, true);
            }

            if (SplineMeshController != null)
            {
                SplineMeshController.Show();
            }

            if (GrindGlowLight != null)
            {
                GrindGlowLight.Show();
            }

            // Store the direction, defaulting to StartToEnd if Unknown or Stationary
            _grindDirection = (direction == SplineTravelDirection.EndToStart)
                ? SplineTravelDirection.EndToStart
                : SplineTravelDirection.StartToEnd;

            _controller.enabled = false; // important: spline drives position

            // Play grind start sound
            if (GrindStartAudioClips != null && GrindStartAudioClips.Length > 0)
            {
                var index = Random.Range(0, GrindStartAudioClips.Length);
                AudioSource.PlayClipAtPoint(GrindStartAudioClips[index], transform.position, GrindAudioVolume);
            }

            // Start grind loop sound
            if (GrindLoopAudioClip != null && _grindLoopAudioSource != null)
            {
                _grindLoopAudioSource.clip = GrindLoopAudioClip;
                _grindLoopAudioSource.volume = GrindAudioVolume;
                _grindLoopAudioSource.Play();
            }

            // Enable grind particle emission
            SetGrindParticleEmission(true);

            // Notify score manager
            if (ScoreManager.Instance != null)
            {
                ScoreManager.Instance.OnGrindStarted();
            }

            // Trigger haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.GrindStart);
                GamepadHaptics.Instance.StartContinuousHaptic(HapticType.GrindLoop);
            }
        }

        private void SetGrindParticleEmission(bool enabled)
        {
            if (GrindParticleSystems == null) return;

            foreach (var ps in GrindParticleSystems)
            {
                if (ps == null) continue;
                var emission = ps.emission;
                emission.enabled = enabled;
            }
        }

        public void StopGrind()
        {
            if (SplineMeshController != null)
            {
                SplineMeshController.Hide();
            }

            if (GrindGlowLight != null)
            {
                GrindGlowLight.Hide();
            }

            // Calculate exit direction from spline tangent before stopping
            Vector3 exitDirection = Vector3.forward;
            if (GrindSpline != null && GrindSpline.Spline != null)
            {
                exitDirection = GrindSpline.transform.TransformDirection(
                    (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
                ).normalized;

                if (_grindDirection == SplineTravelDirection.EndToStart)
                {
                    exitDirection = -exitDirection;
                }

                exitDirection.y = 0f;
                exitDirection.Normalize();
            }

            _grindExitCooldownTimer = GrindExitCooldown;
            _momentumPreservationTimer = MomentumPreservationTime;
            _isGrinding = false;
            _controller.enabled = true;

            // Update animator if using character
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDGrinding, false);
            }

            // Stop grind loop sound
            if (_grindLoopAudioSource != null && _grindLoopAudioSource.isPlaying)
            {
                _grindLoopAudioSource.Stop();
            }

            // Disable grind particle emission
            SetGrindParticleEmission(false);

            // Notify score manager
            if (ScoreManager.Instance != null)
            {
                ScoreManager.Instance.OnGrindEnded();
            }

            // Stop haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StopContinuousHaptic();
            }

            // Preserve horizontal momentum from grind
            _speed = _grindSpeedCurrent * GrindJumpMomentumMultiplier;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;

            // Store exit velocity for wall ride detection (CharacterController velocity won't be updated yet)
            _preservedExitVelocity = exitDirection * _speed;
        }

        private void ExitGrindWithJump(float? jumpHeight = null)
        {
            if (SplineMeshController != null)
            {
                SplineMeshController.Hide();
            }

            if (GrindGlowLight != null)
            {
                GrindGlowLight.Hide();
            }

            float actualJumpHeight = jumpHeight ?? JumpHeight;

            // Calculate exit direction from spline tangent before stopping
            Vector3 exitDirection = Vector3.forward;
            if (GrindSpline != null && GrindSpline.Spline != null)
            {
                exitDirection = GrindSpline.transform.TransformDirection(
                    (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
                ).normalized;

                // Flip tangent for reverse grinding
                if (_grindDirection == SplineTravelDirection.EndToStart)
                {
                    exitDirection = -exitDirection;
                }

                // Flatten to horizontal
                exitDirection.y = 0f;
                exitDirection.Normalize();
            }

            // Start cooldown timer to prevent immediate re-attach in auto-grind mode
            _grindExitCooldownTimer = GrindExitCooldown;
            _momentumPreservationTimer = MomentumPreservationTime;

            // Re-enable controller
            _controller.enabled = true;
            _isGrinding = false;

            // Stop grind loop sound
            if (_grindLoopAudioSource != null && _grindLoopAudioSource.isPlaying)
            {
                _grindLoopAudioSource.Stop();
            }

            // Disable grind particle emission
            SetGrindParticleEmission(false);

            // Notify score manager
            if (ScoreManager.Instance != null)
            {
                ScoreManager.Instance.OnGrindEnded();
            }

            // Trigger haptic feedback for grind jump
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StopContinuousHaptic();
                GamepadHaptics.Instance.TriggerHaptic(HapticType.GrindJump);
            }

            // Play jump sound
            PlayRandomClip(JumpAudioClips, JumpAudioVolume);

            // Apply jump velocity (vertical)
            _verticalVelocity = Mathf.Sqrt(actualJumpHeight * -2f * Gravity);

            // Preserve horizontal momentum from grind
            _speed = _grindSpeedCurrent * GrindJumpMomentumMultiplier;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;

            // Store exit velocity for wall ride detection (CharacterController velocity won't be updated yet)
            _preservedExitVelocity = exitDirection * _speed;

            // Update animator if using character
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, true);
                _animator.SetBool(_animIDGrinding, false);
            }

            // Clear jump input to prevent double jumping
            _input.jump = false;
        }

        private void Grind()
        {
            if (GrindSpline == null || GrindSpline.Spline == null)
                return;

            // Check for jump input to exit grind early
            if (_input.jump)
            {
                ExitGrindWithJump();
                return;
            }

            // Target speed is just GrindSpeed
            float targetSpeed = GrindSpeed;

            // Use boost decay rate when above target speed (decaying start boost), otherwise use normal acceleration
            float lerpRate = _grindSpeedCurrent > targetSpeed ? GrindBoostDecayRate : GrindAcceleration;

            // Accelerate / decelerate toward target
            _grindSpeedCurrent = Mathf.Lerp(
                _grindSpeedCurrent,
                targetSpeed,
                Time.deltaTime * lerpRate
            );

            // Advance along spline in the detected direction
            float splineLength = GrindSpline.Spline.GetLength();
            float deltaT = (_grindSpeedCurrent / splineLength) * Time.deltaTime;

            // Apply direction: negative deltaT for EndToStart
            if (_grindDirection == SplineTravelDirection.EndToStart)
            {
                deltaT = -deltaT;
            }

            _grindT += deltaT;

            // Auto-exit at end of spline with a smaller jump
            if (_grindT >= 1f || _grindT <= 0f)
            {
                ExitGrindWithJump(GrindEndJumpHeight);
                return;
            }

            // Evaluate spline
            Vector3 position = GrindSpline.transform.TransformPoint(
                GrindSpline.Spline.EvaluatePosition(_grindT)
            );
            Vector3 tangent = GrindSpline.transform.TransformDirection(
                (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
            ).normalized;

            if (SplineMeshController != null)
            {
                SplineMeshController.glowLocation = _grindT * _grindSplineLength;
            }

            if (GrindGlowLight != null)
            {
                GrindGlowLight.transform.position = position;
            }

            // Flip tangent when grinding in reverse direction so character faces movement direction
            if (_grindDirection == SplineTravelDirection.EndToStart)
            {
                tangent = -tangent;
            }

            tangent.y = 0f;
            tangent.Normalize();

            // Move directly (CharacterController disabled)
            transform.position = position;

            // Check for ramp collision while grinding - derail if we hit one
            int rampHitCount = Physics.OverlapSphereNonAlloc(transform.position, _controller.radius, _rampHitBuffer, RampLayers);
            if (rampHitCount > 0)
            {
                // Derail - exit grind with a small hop
                ExitGrindWithJump(JumpHeight * 0.5f);
                return;
            }

            // Check for obstacle collision while grinding - derail if we hit one
            if (GrindObstacleLayers != 0)
            {
                int obstacleHitCount = Physics.OverlapSphereNonAlloc(
                    transform.position,
                    _controller.radius * 1.5f,
                    _rampHitBuffer,
                    GrindObstacleLayers
                );

                if (obstacleHitCount > 0)
                {
                    var obstacle = _rampHitBuffer[0];
                    Vector3 knockbackDir = (transform.position - obstacle.ClosestPoint(transform.position)).normalized;

                    // If direction is too vertical, use grind travel direction instead
                    if (Mathf.Abs(knockbackDir.y) > 0.7f)
                    {
                        knockbackDir = GrindSpline.transform.TransformDirection(
                            (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
                        ).normalized;
                        if (_grindDirection == SplineTravelDirection.EndToStart)
                            knockbackDir = -knockbackDir;
                    }
                    knockbackDir.y = 0f;
                    knockbackDir.Normalize();

                    StopGrind();
                    ApplyKnockback(-knockbackDir, 8f);
                    return;
                }
            }

            // Rotate toward spline direction
            if (tangent.sqrMagnitude > 0.0001f)
            {
                float targetYaw = Mathf.Atan2(tangent.x, tangent.z) * Mathf.Rad2Deg;
                float yaw = Mathf.SmoothDampAngle(
                    transform.eulerAngles.y,
                    targetYaw,
                    ref _grindRotationVelocity,
                    GrindRotationSmoothTime
                );

                transform.rotation = Quaternion.Euler(0f, yaw, 0f);
            }

            // Animator
            if (_hasAnimator)
            {
                _animator.SetFloat(_animIDSpeed, _grindSpeedCurrent);
                _animator.SetFloat(_animIDMotionSpeed, 1f);
            }
        }

        private bool TryStartWallRide()
        {
            if (_isWallRiding || _isGrinding)
                return false;

            // Fallback: if WallRideLayers not configured, try to find WallRide layer
            LayerMask effectiveLayers = WallRideLayers;
            if (effectiveLayers.value == 0)
            {
                int wallRideLayer = LayerMask.NameToLayer("WallRide");
                if (wallRideLayer == -1) wallRideLayer = 6; // hardcoded fallback
                effectiveLayers = 1 << wallRideLayer;
            }

            // SphereCast to find nearby billboard colliders
            int hitCount = Physics.OverlapSphereNonAlloc(transform.position, WallRideDetectionRadius, _wallRideHitBuffer, effectiveLayers);

            if (hitCount == 0)
            {
                return false;
            }

            // Find the closest billboard we can wall ride on
            float closestDistance = float.MaxValue;
            Collider closestCollider = null;
            Vector3 closestNormal = Vector3.zero;
            Vector3 closestCenter = Vector3.zero;
            Vector3 closestScale = Vector3.zero;

            for (int i = 0; i < hitCount; i++)
            {
                var hit = _wallRideHitBuffer[i];
                // Calculate closest point first to determine the wall normal dynamically
                var closestPoint = hit.ClosestPoint(transform.position);
                float distance = Vector3.Distance(transform.position, closestPoint);

                // Skip if too far
                if (distance > WallRideMagnetThreshold)
                {
                    continue;
                }

                // Calculate wall normal from closest point to player (works for any wall orientation)
                var wallNormal = (transform.position - closestPoint).normalized;
                // Flatten to horizontal for consistent wall riding
                wallNormal.y = 0f;
                wallNormal.Normalize();

                // Velocity check: very forgiving - if close to wall and jumping, allow it
                // Skip velocity check entirely if very close to wall (player is touching it)
                bool veryCloseToWall = distance < 0.6f;
                bool justJumped = _verticalVelocity > 0f;

                if (!veryCloseToWall && !justJumped)
                {
                    // Only check velocity if not touching wall and not jumping
                    Vector3 horizontalVelocity;
                    if (_momentumPreservationTimer > 0f && _preservedExitVelocity.sqrMagnitude > 1f)
                    {
                        horizontalVelocity = new Vector3(_preservedExitVelocity.x, 0f, _preservedExitVelocity.z);
                    }
                    else
                    {
                        horizontalVelocity = new Vector3(_controller.velocity.x, 0f, _controller.velocity.z);
                    }

                    if (horizontalVelocity.magnitude < 0.5f)
                    {
                        continue;
                    }
                }

                if (distance < closestDistance)
                {
                    closestDistance = distance;
                    closestCollider = hit;
                    closestNormal = wallNormal;
                    closestCenter = hit.transform.position;

                    // Get world-space bounds size (accounts for transform scale)
                    closestScale = hit.bounds.size;
                }
            }

            if (closestCollider == null)
            {
                return false;
            }

            // Project velocity onto wall plane (remove component perpendicular to wall)
            // Use preserved exit velocity if we just jumped off a rail
            Vector3 horizontalVel;
            if (_momentumPreservationTimer > 0f && _preservedExitVelocity.sqrMagnitude > 1f)
            {
                horizontalVel = new Vector3(_preservedExitVelocity.x, 0f, _preservedExitVelocity.z);
            }
            else
            {
                horizontalVel = new Vector3(_controller.velocity.x, 0f, _controller.velocity.z);
            }
            var projectedVelocity = horizontalVel - Vector3.Dot(horizontalVel, closestNormal) * closestNormal;

            // Need meaningful velocity along wall
            if (projectedVelocity.magnitude < 0.5f)
            {
                return false;
            }

            // Start wall ride
            var surfacePoint = closestCollider.ClosestPoint(transform.position);
            StartWallRide(closestNormal, closestCenter, closestScale, projectedVelocity.normalized, surfacePoint);
            return true;
        }

        private void StartWallRide(Vector3 wallNormal, Vector3 billboardCenter, Vector3 billboardScale, Vector3 travelDirection, Vector3 surfacePoint)
        {
            _isWallRiding = true;

            _wallRideNormal = wallNormal;
            _currentBillboardCenter = billboardCenter;
            _currentBillboardScale = billboardScale;
            _wallRideVelocity = travelDirection;
            _wallRideRight = Vector3.Cross(Vector3.up, wallNormal).normalized;

            // Clear preserved velocity now that it's been used
            _preservedExitVelocity = Vector3.zero;

            // Store the wall plane distance (XZ only) for accurate surface snapping
            _wallPlaneDistance = surfacePoint.x * wallNormal.x + surfacePoint.z * wallNormal.z;

            // Apply speed boost
            _wallRideSpeedCurrent = WallRideSpeed + WallRideSpeedBoost;
            _verticalVelocity = 0f;

            // Clear jump buffer and set grace period to prevent immediate exit from held jump key
            _jumpBufferTimer = 0f;
            _input.jump = false;
            _wallRideJumpGraceTimer = WallRideJumpGraceTime;

            // Disable character controller - wall ride drives position
            _controller.enabled = false;

            // Update animator
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, false);
                _animator.SetBool(_animIDFreeFall, false);
            }

            // Enable grind particle emission for wall riding
            SetGrindParticleEmission(true);

            // Enable wall ride particle emission
            foreach (var ps in WallRideParticleSystems)
            {
                if (ps != null)
                {
                    var emission = ps.emission;
                    emission.enabled = true;
                }
            }

            // Trigger haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.WallRideStart);
                GamepadHaptics.Instance.StartContinuousHaptic(HapticType.WallRideLoop);
            }

            // Play wall ride start sound
            if (WallRideStartAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(WallRideStartAudioClip, transform.position, WallRideAudioVolume);
            }

            // Start wall ride loop sound
            if (WallRideLoopAudioClip != null && _wallRideLoopAudioSource != null)
            {
                _wallRideLoopAudioSource.clip = WallRideLoopAudioClip;
                _wallRideLoopAudioSource.volume = WallRideAudioVolume;
                _wallRideLoopAudioSource.Play();
            }
        }

        private void WallRide()
        {
            // Grace period to prevent immediate exit from held jump key used to initiate wall ride
            if (_wallRideJumpGraceTimer > 0f)
            {
                _wallRideJumpGraceTimer -= Time.deltaTime;
            }
            else
            {
                // Check for jump input to exit - poll directly during wall ride for reliability
                bool jumpThisFrame = _jumpBufferTimer > 0f;
                jumpThisFrame |= Input.GetKey(KeyCode.Space);  // GetKey not GetKeyDown for reliability
                jumpThisFrame |= Gamepad.current != null && Gamepad.current.buttonSouth.isPressed;

                if (jumpThisFrame)
                {
                    _jumpBufferTimer = 0f;
                    _input.jump = false;
                    ExitWallRideWithJump();
                    return;
                }
            }

            // Apply height gain - player rises while wall riding
            var currentPos = transform.position;
            currentPos.y += WallRideHeightGainRate * Time.deltaTime;

            // Move along wall
            currentPos += _wallRideVelocity * _wallRideSpeedCurrent * Time.deltaTime;

            // Snap player to fixed distance from wall surface plane
            float snapDistance = 0.5f;
            float currentDistToPlane = currentPos.x * _wallRideNormal.x + currentPos.z * _wallRideNormal.z - _wallPlaneDistance;
            currentPos += _wallRideNormal * (snapDistance - currentDistToPlane);

            // Edge detection - check if still on billboard
            float localX = Vector3.Dot(currentPos - _currentBillboardCenter, _wallRideRight);
            float localY = currentPos.y - _currentBillboardCenter.y;

            // Pick the correct width axis based on wall orientation
            // _wallRideRight tells us which world axis the width is along
            float halfWidth = (Mathf.Abs(_wallRideRight.x) > Mathf.Abs(_wallRideRight.z)
                ? _currentBillboardScale.x
                : _currentBillboardScale.z) * 0.5f;
            float halfHeight = _currentBillboardScale.y * 0.5f;

            bool onBillboard = Mathf.Abs(localX) <= halfWidth && Mathf.Abs(localY) <= halfHeight;

            if (!onBillboard)
            {
                // Exit at edge with momentum
                ExitWallRideAtEdge();
                return;
            }

            // Apply position
            transform.position = currentPos;

            // Rotate player to face movement direction
            if (_wallRideVelocity.sqrMagnitude > 0.0001f)
            {
                float targetYaw = Mathf.Atan2(_wallRideVelocity.x, _wallRideVelocity.z) * Mathf.Rad2Deg;
                float yaw = Mathf.SmoothDampAngle(
                    transform.eulerAngles.y,
                    targetYaw,
                    ref _wallRideRotationVelocity,
                    GrindRotationSmoothTime
                );
                transform.rotation = Quaternion.Euler(0f, yaw, 0f);
            }

            // Update animator
            if (_hasAnimator)
            {
                _animator.SetFloat(_animIDSpeed, _wallRideSpeedCurrent);
                _animator.SetFloat(_animIDMotionSpeed, 1f);
            }
        }

        private void ExitWallRideWithJump()
        {
            // No coyote time needed - player intentionally jumped
            _wallRideCoyoteTimer = 0f;

            // Re-enable controller
            _controller.enabled = true;
            _isWallRiding = false;

            // Set cooldown
            _wallRideExitCooldownTimer = WallRideExitCooldown;
            _momentumPreservationTimer = MomentumPreservationTime;

            // Apply jump velocity (vertical) - jump away from wall
            _verticalVelocity = Mathf.Sqrt(WallRideJumpHeight * -2f * Gravity);

            // Preserve horizontal momentum in travel direction plus some push away from wall
            var exitDirection = _wallRideVelocity + _wallRideNormal * 0.3f;
            exitDirection.y = 0f;
            exitDirection.Normalize();

            _speed = _wallRideSpeedCurrent;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;

            // Update animator
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, true);
            }

            // Clear jump input
            _input.jump = false;

            // Disable grind particle emission
            SetGrindParticleEmission(false);

            // Disable wall ride particle emission
            foreach (var ps in WallRideParticleSystems)
            {
                if (ps != null)
                {
                    var emission = ps.emission;
                    emission.enabled = false;
                }
            }

            // Trigger haptic feedback for wall ride jump
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StopContinuousHaptic();
                GamepadHaptics.Instance.TriggerHaptic(HapticType.WallRideJump);
            }

            // Stop wall ride loop sound
            if (_wallRideLoopAudioSource != null && _wallRideLoopAudioSource.isPlaying)
            {
                _wallRideLoopAudioSource.Stop();
            }

            // Play jump sound
            PlayRandomClip(JumpAudioClips, JumpAudioVolume);
        }

        private void ExitWallRideAtEdge()
        {
            // Re-enable controller
            _controller.enabled = true;
            _isWallRiding = false;

            // Set cooldown
            _wallRideExitCooldownTimer = WallRideExitCooldown;
            _momentumPreservationTimer = MomentumPreservationTime;

            // Start coyote time - player can still jump for a brief window
            _wallRideCoyoteTimer = WallRideCoyoteTime;

            // Small hop when exiting at edge
            _verticalVelocity = Mathf.Sqrt(0.3f * -2f * Gravity);

            // Preserve momentum in travel direction
            var exitDirection = _wallRideVelocity;
            exitDirection.y = 0f;
            exitDirection.Normalize();

            _speed = _wallRideSpeedCurrent;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;

            // Update animator
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, true);
            }

            // Disable grind particle emission
            SetGrindParticleEmission(false);

            // Disable wall ride particle emission
            foreach (var ps in WallRideParticleSystems)
            {
                if (ps != null)
                {
                    var emission = ps.emission;
                    emission.enabled = false;
                }
            }

            // Stop continuous haptic feedback (edge exit doesn't have a special haptic)
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StopContinuousHaptic();
            }

            // Stop wall ride loop sound
            if (_wallRideLoopAudioSource != null && _wallRideLoopAudioSource.isPlaying)
            {
                _wallRideLoopAudioSource.Stop();
            }
        }

        private void TryStartDash()
        {
            // Check cooldown
            if (_dashCooldownTimer > 0f)
            {
                return;
            }

            // If grinding, detach from rail first
            if (_isGrinding)
            {
                // Get the grind direction before stopping
                Vector3 grindTravelDirection = Vector3.forward;
                if (GrindSpline != null && GrindSpline.Spline != null)
                {
                    grindTravelDirection = GrindSpline.transform.TransformDirection(
                        (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
                    ).normalized;

                    if (_grindDirection == SplineTravelDirection.EndToStart)
                    {
                        grindTravelDirection = -grindTravelDirection;
                    }

                    grindTravelDirection.y = 0f;
                    grindTravelDirection.Normalize();
                }

                StopGrind();
                StartDash(grindTravelDirection);
                return;
            }

            // If wall riding, detach from wall first
            if (_isWallRiding)
            {
                Vector3 wallTravelDirection = _wallRideVelocity;
                wallTravelDirection.y = 0f;
                wallTravelDirection.Normalize();

                ExitWallRideAtEdge();
                StartDash(wallTravelDirection);
                return;
            }

            // Ground or air dash: calculate direction from input or facing
            Vector3 dashDirection;
            if (_input.move != Vector2.zero)
            {
                // Use input direction relative to camera
                Vector3 inputDirection = new Vector3(_input.move.x, 0f, _input.move.y).normalized;
                dashDirection = Quaternion.Euler(0f, _smoothYaw, 0f) * inputDirection;
            }
            else
            {
                // No input - dash in facing direction
                dashDirection = transform.forward;
            }

            dashDirection.y = 0f;
            dashDirection.Normalize();

            StartDash(dashDirection);
        }

        private void StartDash(Vector3 direction)
        {
            _isDashing = true;
            _dashTimer = DashDuration;
            _dashCooldownTimer = DashCooldown;
            _dashDirection = direction;

            // Clear momentum preservation - dash takes over speed control
            _momentumPreservationTimer = 0f;

            // Rotate player to face dash direction
            if (direction.sqrMagnitude > 0.0001f)
            {
                _targetRotation = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
                transform.rotation = Quaternion.Euler(0f, _targetRotation, 0f);
            }

            // Play dash sound
            if (DashAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(DashAudioClip, transform.position, 1f);
            }

            // Trigger haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.Dash);
            }
        }

        private void UpdateDash()
        {
            if (!_isDashing) return;

            _dashTimer -= Time.deltaTime;
            if (_dashTimer <= 0f)
            {
                _isDashing = false;
            }
        }

        private void TryStartBoost()
        {
            // Check cooldown
            if (_boostCooldownTimer > 0f)
            {
                return;
            }

            // If grinding, detach from rail first
            if (_isGrinding)
            {
                // Get the grind direction before stopping
                Vector3 grindTravelDirection = Vector3.forward;
                if (GrindSpline != null && GrindSpline.Spline != null)
                {
                    grindTravelDirection = GrindSpline.transform.TransformDirection(
                        (Vector3)GrindSpline.Spline.EvaluateTangent(_grindT)
                    ).normalized;

                    if (_grindDirection == SplineTravelDirection.EndToStart)
                    {
                        grindTravelDirection = -grindTravelDirection;
                    }

                    grindTravelDirection.y = 0f;
                    grindTravelDirection.Normalize();
                }

                StopGrind();
                StartBoost(grindTravelDirection);
                return;
            }

            // If wall riding, detach from wall first
            if (_isWallRiding)
            {
                Vector3 wallTravelDirection = _wallRideVelocity;
                wallTravelDirection.y = 0f;
                wallTravelDirection.Normalize();

                ExitWallRideAtEdge();
                StartBoost(wallTravelDirection);
                return;
            }

            // Ground or air boost: calculate direction from input or facing
            Vector3 boostDirection;
            if (_input.move != Vector2.zero)
            {
                // Use input direction relative to camera
                Vector3 inputDirection = new Vector3(_input.move.x, 0f, _input.move.y).normalized;
                boostDirection = Quaternion.Euler(0f, _smoothYaw, 0f) * inputDirection;
            }
            else
            {
                // No input - boost in facing direction
                boostDirection = transform.forward;
            }

            boostDirection.y = 0f;
            boostDirection.Normalize();

            StartBoost(boostDirection);
        }

        private void StartBoost(Vector3 direction)
        {
            _isBoosting = true;
            _boostTimer = BoostDuration;
            _boostCooldownTimer = BoostCooldown;
            _boostDirection = direction;

            // Clear momentum preservation - boost takes over speed control
            _momentumPreservationTimer = 0f;

            // Rotate player to face boost direction
            if (direction.sqrMagnitude > 0.0001f)
            {
                _targetRotation = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
                transform.rotation = Quaternion.Euler(0f, _targetRotation, 0f);
            }

            // Play boost sound
            if (BoostAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(BoostAudioClip, transform.position, 1f);
            }

            // Start continuous haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.StartContinuousHaptic(HapticType.Boost);
            }
        }

        private void UpdateBoost()
        {
            if (!_isBoosting) return;

            _boostTimer -= Time.deltaTime;
            if (_boostTimer <= 0f)
            {
                _isBoosting = false;

                // Stop continuous haptic feedback when boost ends
                if (GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.StopContinuousHaptic();
                }
            }
        }

        private void OnControllerColliderHit(ControllerColliderHit hit)
        {
            // Check if we hit a LaserBot's force field
            var laserFieldTrigger = hit.collider.GetComponent<LaserFieldTrigger>();
            if (laserFieldTrigger != null)
            {
                var laserBot = laserFieldTrigger.GetLaserBot();
                if (laserBot != null)
                {
                    laserBot.OnPlayerHitForceField(this);
                }
            }
        }

        /// <summary>
        /// Apply knockback force to the player, pushing them in the specified direction.
        /// Cancels boost/dash and exits grind if active.
        /// </summary>
        public void ApplyKnockback(Vector3 direction, float force)
        {
            // Cancel boost and dash
            _isBoosting = false;
            _isDashing = false;
            _boostTimer = 0f;
            _dashTimer = 0f;

            // Exit grind if grinding
            if (_isGrinding)
            {
                StopGrind();
            }

            // Set knockback state
            _isKnockedBack = true;
            _knockbackTimer = KnockbackDuration;

            // Calculate knockback velocity
            Vector3 knockbackDir = direction.normalized;
            _knockbackVelocity = knockbackDir * force;

            // Add slight upward component for more visible knockback
            _verticalVelocity = force * 0.5f;

            // Reset speed to prevent fighting the knockback
            _speed = 0f;

            // Trigger haptic feedback
            if (GamepadHaptics.Instance != null)
            {
                GamepadHaptics.Instance.TriggerHaptic(HapticType.Knockback);
            }

            // Play knockback sound
            if (KnockbackAudioClip != null)
            {
                AudioSource.PlayClipAtPoint(KnockbackAudioClip, transform.position, CombatAudioVolume);
            }
        }

        private void UpdateKnockback()
        {
            if (!_isKnockedBack) return;

            _knockbackTimer -= Time.deltaTime;
            if (_knockbackTimer <= 0f)
            {
                _isKnockedBack = false;
                _knockbackVelocity = Vector3.zero;
            }
        }

        private void Move()
        {
            // Set target speed based on move speed
            float targetSpeed = _input.move == Vector2.zero ? 0f : MoveSpeed;

            // During active dash, add full boost to target speed
            if (_isDashing)
            {
                targetSpeed += DashSpeedBoost;
            }

            // During active boost, add boost to target speed
            if (_isBoosting)
            {
                targetSpeed += BoostSpeedBoost;
            }

            // a reference to the players current horizontal velocity
            float currentHorizontalSpeed = new Vector3(_controller.velocity.x, 0.0f, _controller.velocity.z).magnitude;

            float speedOffset = 0.1f;
            float inputMagnitude = _input.analogMovement ? _input.move.magnitude : 1f;

            // When airborne, preserve momentum better by reducing speed change rate
            float effectiveSpeedChangeRate = Grounded ? SpeedChangeRate : SpeedChangeRate * _airControlMultiplier;

            // Preserve momentum after exiting grind or during active dash/boost - only allow acceleration, not deceleration
            bool preservingMomentum = _momentumPreservationTimer > 0f || _isDashing || _isBoosting;

            // accelerate or decelerate to target speed
            if (currentHorizontalSpeed < targetSpeed - speedOffset ||
                currentHorizontalSpeed > targetSpeed + speedOffset)
            {
                // If preserving momentum and trying to decelerate, skip the speed change
                if (preservingMomentum && currentHorizontalSpeed > targetSpeed)
                {
                    _speed = currentHorizontalSpeed;
                }
                else
                {
                    // creates curved result rather than a linear one giving a more organic speed change
                    // note T in Lerp is clamped, so we don't need to clamp our speed
                    float effectiveTargetSpeed = targetSpeed * inputMagnitude;
                    _speed = Mathf.Lerp(currentHorizontalSpeed, effectiveTargetSpeed,
                        Time.deltaTime * effectiveSpeedChangeRate);

                    // round speed to 3 decimal places
                    _speed = Mathf.Round(_speed * 1000f) / 1000f;
                }
            }
            else
            {
                _speed = targetSpeed;
            }

            _animationBlend = Mathf.Lerp(_animationBlend, targetSpeed, Time.deltaTime * SpeedChangeRate);
            if (_animationBlend < 0.01f) _animationBlend = 0f;

            // normalise input direction
            Vector3 inputDirection = new Vector3(_input.move.x, 0.0f, _input.move.y).normalized;

            // note: Vector2's != operator uses approximation so is not floating point error prone, and is cheaper than magnitude
            // if there is a move input rotate player when the player is moving
            if (_input.move != Vector2.zero)
            {
                // Use _smoothYaw instead of camera transform to ignore look-back flip
                _targetRotation = Mathf.Atan2(inputDirection.x, inputDirection.z) * Mathf.Rad2Deg + _smoothYaw;
                float rotation = Mathf.SmoothDampAngle(transform.eulerAngles.y, _targetRotation, ref _rotationVelocity,
                    RotationSmoothTime);

                // rotate to face input direction relative to camera position
                transform.rotation = Quaternion.Euler(0.0f, rotation, 0.0f);
            }

            Vector3 targetDirection = Quaternion.Euler(0.0f, _targetRotation, 0.0f) * Vector3.forward;

            // move the player
            if (_isKnockedBack)
            {
                // During knockback, use knockback velocity instead of normal movement
                _controller.Move(_knockbackVelocity * Time.deltaTime +
                                 new Vector3(0.0f, _verticalVelocity, 0.0f) * Time.deltaTime);
            }
            else
            {
                _controller.Move(targetDirection.normalized * (_speed * Time.deltaTime) +
                                 new Vector3(0.0f, _verticalVelocity, 0.0f) * Time.deltaTime);
            }

            // update animator if using character
            if (_hasAnimator)
            {
                _animator.SetFloat(_animIDSpeed, _animationBlend);
                _animator.SetFloat(_animIDMotionSpeed, inputMagnitude);
            }

            // Manage skate loop sound
            UpdateSkateLoopSound();
        }

        private void UpdateSkateLoopSound()
        {
            bool shouldPlaySkateLoop = Grounded && _speed > 0.1f && !_isGrinding;

            if (shouldPlaySkateLoop)
            {
                if (SkateLoopAudioClip != null && _skateLoopAudioSource != null && !_skateLoopAudioSource.isPlaying)
                {
                    _skateLoopAudioSource.clip = SkateLoopAudioClip;
                    _skateLoopAudioSource.volume = SkateAudioVolume;
                    _skateLoopAudioSource.Play();
                }
            }
            else
            {
                if (_skateLoopAudioSource != null && _skateLoopAudioSource.isPlaying)
                {
                    _skateLoopAudioSource.Stop();
                }
            }
        }

        private void JumpAndGravity()
        {
            if (Grounded)
            {
                // reset the fall timeout timer
                _fallTimeoutDelta = FallTimeout;

                // update animator if using character
                if (_hasAnimator)
                {
                    _animator.SetBool(_animIDJump, false);
                    _animator.SetBool(_animIDFreeFall, false);
                }

                // stop our velocity dropping infinitely when grounded
                if (_verticalVelocity < 0.0f)
                {
                    _verticalVelocity = -2f;
                }

                // Jump
                if (_input.jump && _jumpTimeoutDelta <= 0.0f)
                {
                    // the square root of H * -2 * G = how much velocity needed to reach desired height
                    _verticalVelocity = Mathf.Sqrt(JumpHeight * -2f * Gravity);

                    // update animator if using character
                    if (_hasAnimator)
                    {
                        _animator.SetBool(_animIDJump, true);
                    }

                    // Play jump sound
                    PlayRandomClip(JumpAudioClips, JumpAudioVolume);

                    // Trigger haptic feedback for jump
                    if (GamepadHaptics.Instance != null)
                    {
                        GamepadHaptics.Instance.TriggerHaptic(HapticType.Jump);
                    }

                    // Check for wall ride immediately when jumping near a wall
                    if (EnableWallRide && _wallRideExitCooldownTimer <= 0f)
                    {
                        TryStartWallRide();
                    }
                }

                // jump timeout
                if (_jumpTimeoutDelta >= 0.0f)
                {
                    _jumpTimeoutDelta -= Time.deltaTime;
                }
            }
            else
            {
                // reset the jump timeout timer
                _jumpTimeoutDelta = JumpTimeout;

                // fall timeout
                if (_fallTimeoutDelta >= 0.0f)
                {
                    _fallTimeoutDelta -= Time.deltaTime;
                }
                else
                {
                    // update animator if using character
                    if (_hasAnimator)
                    {
                        _animator.SetBool(_animIDFreeFall, true);
                    }
                }

                // if we are not grounded, do not jump
                _input.jump = false;
            }

            // apply gravity over time if under terminal (multiply by delta time twice to linearly speed up over time)
            if (_verticalVelocity < _terminalVelocity)
            {
                _verticalVelocity += Gravity * Time.deltaTime;
            }
        }

        private static float ClampAngle(float lfAngle, float lfMin, float lfMax)
        {
            while (lfAngle < -360f) lfAngle += 360f;
            while (lfAngle > 360f) lfAngle -= 360f;
            return Mathf.Clamp(lfAngle, lfMin, lfMax);
        }

        private void OnDrawGizmosSelected()
        {
            Color transparentGreen = new Color(0.0f, 1.0f, 0.0f, 0.35f);
            Color transparentRed = new Color(1.0f, 0.0f, 0.0f, 0.35f);

            if (Grounded) Gizmos.color = transparentGreen;
            else Gizmos.color = transparentRed;

            // when selected, draw a gizmo in the position of, and matching radius of, the grounded collider
            Gizmos.DrawSphere(
                new Vector3(transform.position.x, transform.position.y - GroundedOffset, transform.position.z),
                GroundedRadius);
        }

        private void HandlePlayerDeath()
        {
            Debug.Log("<color=red>Player died! Performing soft reset...</color>");

            // Reset score
            ScoreManager.Instance?.ResetScore();

            // Stop any grinding
            if (_isGrinding)
            {
                StopGrind();
            }

            // Stop wall riding
            if (_isWallRiding)
            {
                _controller.enabled = true;
                _isWallRiding = false;
                _wallRideExitCooldownTimer = WallRideExitCooldown;

                // Stop wall ride audio
                if (_wallRideLoopAudioSource != null && _wallRideLoopAudioSource.isPlaying)
                {
                    _wallRideLoopAudioSource.Stop();
                }

                // Disable wall ride particles
                foreach (var ps in WallRideParticleSystems)
                {
                    if (ps != null)
                    {
                        var emission = ps.emission;
                        emission.enabled = false;
                    }
                }

                // Stop haptics
                GamepadHaptics.Instance?.StopContinuousHaptic();
            }

            // Teleport to spawn position
            _controller.enabled = false;
            transform.position = _spawnPosition;
            transform.rotation = _spawnRotation;
            _controller.enabled = true;

            // Reset velocity and movement state
            _verticalVelocity = 0f;
            _speed = 0f;
            _grindExitCooldownTimer = 0f;
            _momentumPreservationTimer = 0f;
            _wallRideExitCooldownTimer = 0f;
            _wallRideCoyoteTimer = 0f;
            _jumpBufferTimer = 0f;

            // Reset health
            GameSessionManager.Instance?.ResetHealth();

            // Reset graffiti spots
            var graffitiPool = FindAnyObjectByType<GraffitiSpotPool>();
            graffitiPool?.ResetAllGraffiti();

            // Reset enemies
            EnemySpawner.Instance?.ResetAllEnemies();
            EnemyController.Instance?.ResetToIdle();

            // Reset death wall position
            DeathWall.Instance?.ResetToPosition(_spawnPosition);
        }

        private void OnFootstep(AnimationEvent animationEvent)
        {
            // Footsteps replaced by skate loop sound - this method kept for animation event compatibility
        }

        private void OnLand(AnimationEvent animationEvent)
        {
            if (animationEvent.animatorClipInfo.weight > 0.5f)
            {
                if (SkateLandingAudioClips != null && SkateLandingAudioClips.Length > 0)
                {
                    var index = Random.Range(0, SkateLandingAudioClips.Length);
                    AudioSource.PlayClipAtPoint(SkateLandingAudioClips[index], transform.TransformPoint(_controller.center), SkateAudioVolume);
                }

                // Trigger haptic feedback for landing
                if (GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.TriggerHaptic(HapticType.Land);
                }
            }
        }

        /// <summary>
        /// Increases the player's maximum movement speeds permanently.
        /// </summary>
        /// <param name="amount">Amount to increase speed by</param>
        public void IncreaseMaxSpeed(float amount)
        {
            MoveSpeed += amount;
            GrindSpeed += amount;

        }

        private void TryDeflectBullet()
        {
            var spawner = EnemySpawner.Instance;
            if (spawner == null) return;

            var didDeflect = false;
            var bullets = spawner.GetAllBulletsInParryRange();
            foreach (var bullet in bullets)
            {
                bullet.Deflect();
                didDeflect = true;
            }

            if (didDeflect)
            {
                // Slow down time to emphasize the hit
                if (Camera.main != null && Camera.main.TryGetComponent(out CameraEffects cameraEffects))
                {
                    cameraEffects.PunchTime(.3f);
                }

                // Trigger haptic feedback for successful parry
                if (GamepadHaptics.Instance != null)
                {
                    GamepadHaptics.Instance.TriggerHaptic(HapticType.Parry);
                }

                // Play parry success sound
                if (ParrySuccessAudioClip != null)
                {
                    AudioSource.PlayClipAtPoint(ParrySuccessAudioClip, transform.position, CombatAudioVolume);
                }
            }
        }

        public void SetActiveGraffiti(GraffitiSpot graffiti)
        {
            _activeGraffiti = graffiti;
        }

        public void SetSprayTarget(Vector3 targetPosition, bool isSpraying)
        {
            _sprayTargetPosition = targetPosition;
            _isSpraying = isSpraying;
        }

        public GraffitiSpot ActiveGraffiti => _activeGraffiti;
        public bool IsSpraying => _isSpraying;
        public bool IsSprayInputPressed => sprayInput.IsPressed();

        private void PlayRandomClip(AudioClip[] clips, float volume = 1f)
        {
            if (clips == null || clips.Length == 0) return;
            var clip = clips[Random.Range(0, clips.Length)];
            AudioSource.PlayClipAtPoint(clip, transform.position, volume);
        }
    }
}