using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace HolyRail.FX
{
    [ExecuteAlways]
    public class PlayerWakeTrailController : MonoBehaviour
    {
        private const int MaxWakePositions = 16;
        private const string WakePositionsProperty = "_WakePositions";
        private const string WakePositionCountProperty = "_WakePositionCount";
        private const string PlayerPositionXZProperty = "_PlayerPositionXZ";
        private const string PlayerSpeedProperty = "_PlayerSpeed";

        [Header("Player Reference")]
        [field: SerializeField] public Transform PlayerTransform { get; set; }

        [Header("Wake Recording")]
        [field: SerializeField] public float RecordDistance { get; set; } = 0.5f;
        [field: SerializeField] public float WakeLifetime { get; set; } = 8f;

        [Header("Speed Tracking")]
        [field: SerializeField] public float MaxSpeed { get; set; } = 20f;
        [field: SerializeField] public float SpeedSmoothing { get; set; } = 5f;

        [Header("Editor Preview")]
        [field: SerializeField] public bool EditorPreview { get; set; } = true;
        [field: SerializeField] public float EditorPreviewSpeed { get; set; } = 0.5f;

        private Vector4[] _wakePositions = new Vector4[MaxWakePositions];
        private int _wakeIndex;
        private int _wakeCount;
        private Vector3 _lastRecordedPosition;
        private Vector3 _lastFramePosition;
        private bool _hasRecordedFirst;
        private float _currentSpeed;
        private float _smoothedSpeed;
        private double _lastEditorTime;

        private static readonly int WakePositionsId = Shader.PropertyToID(WakePositionsProperty);
        private static readonly int WakePositionCountId = Shader.PropertyToID(WakePositionCountProperty);
        private static readonly int PlayerPositionXZId = Shader.PropertyToID(PlayerPositionXZProperty);
        private static readonly int PlayerSpeedId = Shader.PropertyToID(PlayerSpeedProperty);

        private void OnEnable()
        {
            InitializeWakePositions();

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                EditorApplication.update += EditorUpdate;
                _lastEditorTime = EditorApplication.timeSinceStartup;
            }
#endif
        }

        private void OnDisable()
        {
            Shader.SetGlobalInt(WakePositionCountId, 0);
            Shader.SetGlobalFloat(PlayerSpeedId, 0f);

#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                EditorApplication.update -= EditorUpdate;
            }
#endif
        }

        private void InitializeWakePositions()
        {
            for (int i = 0; i < MaxWakePositions; i++)
            {
                _wakePositions[i] = new Vector4(0, 0, 1f, 0);
            }
            _wakeIndex = 0;
            _wakeCount = 0;
            _hasRecordedFirst = false;
        }

        private void Start()
        {
            if (Application.isPlaying && PlayerTransform == null)
            {
                var player = GameObject.FindGameObjectWithTag("Player");
                if (player != null)
                {
                    PlayerTransform = player.transform;
                }
            }

            InitializeWakePositions();
            var startPos = PlayerTransform != null ? PlayerTransform.position : transform.position;
            UpdateShaderProperties(startPos);
        }

#if UNITY_EDITOR
        private void EditorUpdate()
        {
            if (Application.isPlaying || !EditorPreview)
                return;

            double currentTime = EditorApplication.timeSinceStartup;
            float deltaTime = (float)(currentTime - _lastEditorTime);
            _lastEditorTime = currentTime;

            // Clamp delta to avoid huge jumps
            deltaTime = Mathf.Min(deltaTime, 0.1f);

            // In editor, create a test wake at the controller's position
            var testPos = transform.position;

            if (!_hasRecordedFirst)
            {
                _lastRecordedPosition = testPos;
                _hasRecordedFirst = true;
            }

            // Record wake if position changed
            float distanceMoved = Vector3.Distance(testPos, _lastRecordedPosition);
            if (distanceMoved >= RecordDistance)
            {
                RecordWakePosition(testPos);
                _lastRecordedPosition = testPos;
            }

            // Age positions
            AgeWakePositionsWithDelta(deltaTime);

            // Set shader properties
            Shader.SetGlobalFloat(PlayerSpeedId, EditorPreviewSpeed);
            Shader.SetGlobalVectorArray(WakePositionsId, _wakePositions);
            Shader.SetGlobalInt(WakePositionCountId, _wakeCount);
            Shader.SetGlobalVector(PlayerPositionXZId, new Vector2(testPos.x, testPos.z));

            // Force scene view to repaint
            SceneView.RepaintAll();
        }
#endif

        private void Update()
        {
            if (!Application.isPlaying)
                return;

            if (PlayerTransform == null)
                return;

            var playerPos = PlayerTransform.position;

            if (!_hasRecordedFirst)
            {
                _lastRecordedPosition = playerPos;
                _lastFramePosition = playerPos;
                _hasRecordedFirst = true;
            }

            // Calculate current speed
            float frameDistance = Vector3.Distance(playerPos, _lastFramePosition);
            _currentSpeed = frameDistance / Time.deltaTime;
            _lastFramePosition = playerPos;

            // Smooth the speed value
            _smoothedSpeed = Mathf.Lerp(_smoothedSpeed, _currentSpeed, Time.deltaTime * SpeedSmoothing);

            // Record wake position if moved enough
            float distanceMoved = Vector3.Distance(playerPos, _lastRecordedPosition);
            if (distanceMoved >= RecordDistance)
            {
                RecordWakePosition(playerPos);
                _lastRecordedPosition = playerPos;
            }

            AgeWakePositions();
            UpdateShaderProperties(playerPos);
        }

        private void RecordWakePosition(Vector3 position)
        {
            _wakePositions[_wakeIndex] = new Vector4(position.x, position.z, 0f, 1f);
            _wakeIndex = (_wakeIndex + 1) % MaxWakePositions;
            _wakeCount = Mathf.Min(_wakeCount + 1, MaxWakePositions);
        }

        private void AgeWakePositions()
        {
            AgeWakePositionsWithDelta(Time.deltaTime);
        }

        private void AgeWakePositionsWithDelta(float deltaTime)
        {
            float ageDelta = deltaTime / WakeLifetime;

            for (int i = 0; i < MaxWakePositions; i++)
            {
                if (_wakePositions[i].w > 0)
                {
                    float age = _wakePositions[i].z + ageDelta;
                    if (age >= 1f)
                    {
                        _wakePositions[i] = new Vector4(0, 0, 1f, 0);
                        _wakeCount = Mathf.Max(0, _wakeCount - 1);
                    }
                    else
                    {
                        _wakePositions[i].z = age;
                    }
                }
            }
        }

        private void UpdateShaderProperties(Vector3 playerPos)
        {
            Shader.SetGlobalVectorArray(WakePositionsId, _wakePositions);
            Shader.SetGlobalInt(WakePositionCountId, _wakeCount);
            Shader.SetGlobalVector(PlayerPositionXZId, new Vector2(playerPos.x, playerPos.z));

            float normalizedSpeed = Mathf.Clamp01(_smoothedSpeed / MaxSpeed);
            Shader.SetGlobalFloat(PlayerSpeedId, normalizedSpeed);
        }

#if UNITY_EDITOR
        private void OnValidate()
        {
            // Force update when properties change in inspector
            if (!Application.isPlaying && EditorPreview)
            {
                UpdateShaderProperties(transform.position);
                SceneView.RepaintAll();
            }
        }
#endif
    }
}
