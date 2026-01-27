using System.Collections;
 using UnityEngine;
 using UnityEngine.Splines;
 using Unity.Splines.Examples;
 using Unity.Mathematics;
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
        public InputAction grindInput;
        public InputAction lookBackInput;
        public bool lookBack;
        private SplineContainer[] _splineContainers;
        
        [Header("Player")]
        [Tooltip("Move speed of the character in m/s")]
        public float MoveSpeed = 2.0f;

        [Tooltip("Air control multiplier - lower values preserve momentum better (0 = no air control, 1 = full control)")]
        [SerializeField] private float _airControlMultiplier = 1f;

        [Tooltip("Duration to preserve momentum after exiting a grind (prevents deceleration)")]
        public float MomentumPreservationTime = 0.5f;

        [Tooltip("Sprint speed of the character in m/s")]
        public float SprintSpeed = 5.335f;

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

        [Header("Status Effects")] 
        public float SpeedMultiplier = 1.0f;

        [Space(10)]
        [Tooltip("Time required to pass before being able to jump again. Set to 0f to instantly jump again")]
        public float JumpTimeout = 0.50f;

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

        [Tooltip("How quickly the start boost decays toward base grind speed")]
        public float GrindBoostDecayRate = 8f;

        [Space(10)]
        [Tooltip("Sound effects played when landing on a rail (random selection)")]
        public AudioClip[] GrindStartAudioClips;
        [Tooltip("Looping sound effect while grinding")]
        public AudioClip GrindLoopAudioClip;
        [Range(0, 1)] public float GrindAudioVolume = 0.5f;

        private AudioSource _grindLoopAudioSource;
        private AudioSource _skateLoopAudioSource;
        private bool _isGrinding;
        private float _grindExitCooldownTimer;
        private float _momentumPreservationTimer;
        private float _grindT;                 // Normalized spline position (0–1)
        private float _grindSpeedCurrent;
        private float _grindRotationVelocity;
        private SplineTravelDirection _grindDirection;

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
        }

        private void OnEnable()
        {
            grindInput.Enable();
            grindInput.performed += OnGrindRequested;

            lookBackInput.Enable();
        }

        private void OnDisable()
        {
            grindInput.performed -= OnGrindRequested;
            grindInput.Disable();

            lookBackInput.Disable();
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
        }

        private void Update()
        {
            _hasAnimator = TryGetComponent(out _animator);
            bool gamepadLookBack = Gamepad.current != null && Gamepad.current.leftShoulder.isPressed;
            lookBack = gamepadLookBack || Input.GetKey(KeyCode.Q);

            if (_isGrinding)
            {
                Grind();
            }
            else
            {
                if (_grindExitCooldownTimer > 0f)
                {
                    _grindExitCooldownTimer -= Time.deltaTime;
                }

                if (_momentumPreservationTimer > 0f)
                {
                    _momentumPreservationTimer -= Time.deltaTime;
                }

                // Auto-grind: cooldown prevents immediate re-attach after jumping off
                if (AutoGrind && !Grounded && _grindExitCooldownTimer <= 0f)
                {
                    if (TryStartGrind())
                    {
                        return; // Exit Update - controller is now disabled for grinding
                    }
                }

                JumpAndGravity();
                GroundedCheck();
                Move();
            }

            // Handle parry input
            if (_input.parry && _hasAnimator)
            {
                _animator.SetTrigger(_animIDParry);
                _input.parry = false;
            }
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
        }

        private void GroundedCheck()
        {
            // set sphere position, with offset
            Vector3 spherePosition = new Vector3(transform.position.x, transform.position.y - GroundedOffset,
                transform.position.z);
            Grounded = Physics.CheckSphere(spherePosition, GroundedRadius, GroundLayers,
                QueryTriggerInteraction.Ignore);

            // update animator if using character
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDGrounded, Grounded);
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

            var result = ShowNearestPoint.GetNearestPointOnSplines(
                transform.position,
                _splineContainers);

            if (result.Container == null) return false;

            // Hemisphere check: only grind if player is above the rail (with offset)
            float playerY = transform.position.y;
            float railY = result.Position.y;
            if (playerY < railY + GrindTriggerOffset) return false;

            if (result.Distance <= GrindDistanceThreshold)
            {
                var direction = GetZForwardGrindDirection(result.Container, result.SplineParameter);
                StartGrind(result.Container, result.SplineParameter, direction);
                return true;
            }
            return false;
        }

        private SplineTravelDirection GetZForwardGrindDirection(SplineContainer container, float t)
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

            // Check if tangent points in positive Z direction (world forward)
            // If tangent.z > 0, StartToEnd travels in +Z direction
            // If tangent.z < 0, EndToStart travels in +Z direction
            return tangent.z >= 0 ? SplineTravelDirection.StartToEnd : SplineTravelDirection.EndToStart;
        }

        void OnGrindRequested(InputAction.CallbackContext context)
        {
            if (!_isGrinding)
            {
                if (!TryStartGrind())
                {
                    Debug.LogWarning("No spline within grind distance threshold.");
                }
            }
            else
            {
                ExitGrindWithJump();
            }
        }

        public void StartGrind(SplineContainer spline, float startT, SplineTravelDirection direction = SplineTravelDirection.StartToEnd)
        {
            GrindSpline = spline;
            _grindT = Mathf.Clamp01(startT);
            _grindSpeedCurrent = GrindSpeed + GrindStartBoost;
            _verticalVelocity = 0f;
            _isGrinding = true;
            if (_hasAnimator)
            {
                _animator.SetBool(_animIDJump, false);
                _animator.SetBool(_animIDGrinding, true);
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
        }

        public void StopGrind()
        {
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
            _animator.SetBool(_animIDGrinding, false);
            _controller.enabled = true;

            // Stop grind loop sound
            if (_grindLoopAudioSource != null && _grindLoopAudioSource.isPlaying)
            {
                _grindLoopAudioSource.Stop();
            }

            // Preserve horizontal momentum from grind
            _speed = _grindSpeedCurrent * GrindJumpMomentumMultiplier;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;
        }

        private void ExitGrindWithJump(float? jumpHeight = null)
        {
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

            // Apply jump velocity (vertical)
            _verticalVelocity = Mathf.Sqrt(actualJumpHeight * -2f * Gravity);

            // Preserve horizontal momentum from grind
            _speed = _grindSpeedCurrent * GrindJumpMomentumMultiplier;
            _targetRotation = Mathf.Atan2(exitDirection.x, exitDirection.z) * Mathf.Rad2Deg;

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

            // Determine target speed (apply same sprint ratio as ground movement)
            float targetSpeed = (_input.sprint ? GrindSpeed * (SprintSpeed / MoveSpeed) : GrindSpeed) * SpeedMultiplier;

            // Use boost decay rate when above target speed (decaying boost), otherwise use normal acceleration
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

            // Flip tangent when grinding in reverse direction so character faces movement direction
            if (_grindDirection == SplineTravelDirection.EndToStart)
            {
                tangent = -tangent;
            }

            tangent.y = 0f;
            tangent.Normalize();

            // Move directly (CharacterController disabled)
            transform.position = position;

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

        private void Move()
        {
            // set target speed based on move speed, sprint speed and if sprint is pressed
            float targetSpeed = (_input.sprint ? SprintSpeed : MoveSpeed) * SpeedMultiplier;

            // a simplistic acceleration and deceleration designed to be easy to remove, replace, or iterate upon

            // note: Vector2's == operator uses approximation so is not floating point error prone, and is cheaper than magnitude
            // if there is no input, set the target speed to 0
            if (_input.move == Vector2.zero) targetSpeed = 0.0f;

            // a reference to the players current horizontal velocity
            float currentHorizontalSpeed = new Vector3(_controller.velocity.x, 0.0f, _controller.velocity.z).magnitude;

            float speedOffset = 0.1f;
            float inputMagnitude = _input.analogMovement ? _input.move.magnitude : 1f;

            // When airborne, preserve momentum better by reducing speed change rate
            float effectiveSpeedChangeRate = Grounded ? SpeedChangeRate : SpeedChangeRate * _airControlMultiplier;

            // Preserve momentum after exiting grind - only allow acceleration, not deceleration
            bool preservingMomentum = _momentumPreservationTimer > 0f;

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
                    _speed = Mathf.Lerp(currentHorizontalSpeed, targetSpeed * inputMagnitude,
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
            _controller.Move(targetDirection.normalized * (_speed * Time.deltaTime) +
                             new Vector3(0.0f, _verticalVelocity, 0.0f) * Time.deltaTime);

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

        public void ApplySpeedReduction(float multiplier, float duration)
        {
            StopCoroutine("SpeedReductionCoroutine");
            StartCoroutine(SpeedReductionCoroutine(multiplier, duration));
        }

        private IEnumerator SpeedReductionCoroutine(float multiplier, float duration)
        {
            SpeedMultiplier = multiplier;
            yield return new WaitForSeconds(duration);
            SpeedMultiplier = 1.0f;
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
            }
        }

        /// <summary>
        /// Increases the player's maximum movement speeds.
        /// </summary>
        /// <param name="amount">Amount to increase speed by</param>
        public void IncreaseMaxSpeed(float amount)
        {
            MoveSpeed += amount;
            SprintSpeed += amount;
            GrindSpeed += amount;

            Debug.Log($"Speed increased! New speeds - Move: {MoveSpeed}, Sprint: {SprintSpeed}, Grind: {GrindSpeed}");
        }
    }
}