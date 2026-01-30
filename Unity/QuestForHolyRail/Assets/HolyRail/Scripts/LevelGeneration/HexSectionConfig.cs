using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    [CreateAssetMenu(fileName = "HexSectionConfig", menuName = "Holy Rail/Hex Section Config")]
    public class HexSectionConfig : ScriptableObject
    {
        [Header("Hex Geometry")]
        [field: SerializeField] public float Circumradius { get; set; } = HexConstants.DefaultCircumradius;
        [field: SerializeField] public int EntryEdge { get; set; } = 3;
        [field: SerializeField] public int ExitEdge { get; set; } = 0;
        [field: Tooltip("Allow entry/exit edges to vary from the defaults by +/- 1 edge")]
        [field: SerializeField] public GameObject RampPrefab { get; set; }
        [field: SerializeField] public bool RandomizeEntryExit { get; set; } = false;

        [Header("Rail Splines")]
        [field: SerializeField] public int MinRailCount { get; set; } = 3;
        [field: SerializeField] public int MaxRailCount { get; set; } = 7;
        [field: SerializeField] public float RailMinHeight { get; set; } = 1f;
        [field: SerializeField] public float RailMaxHeight { get; set; } = 12f;
        [field: SerializeField] public int PointsPerRail { get; set; } = 12;
        [field: SerializeField] public Vector3 RailNoiseAmplitude { get; set; } = new(8f, 4f, 0f);
        [field: SerializeField] public Vector3 RailNoiseFrequency { get; set; } = new(0.2f, 0.15f, 0f);
        [field: Tooltip("Minimum horizontal distance between any two rails")]
        [field: SerializeField] public float MinRailSpacing { get; set; } = HexConstants.DefaultMinRailSpacing;

        [Header("Ramps")]
        [field: SerializeField] public int MinRampCount { get; set; } = 2;
        [field: SerializeField] public int MaxRampCount { get; set; } = 5;
        [field: SerializeField] public float RampLengthMin { get; set; } = 5f;
        [field: SerializeField] public float RampLengthMax { get; set; } = 15f;
        [field: SerializeField] public float RampWidthMin { get; set; } = 3f;
        [field: SerializeField] public float RampWidthMax { get; set; } = 8f;
        [field: SerializeField] public float RampAngleMin { get; set; } = 10f;
        [field: SerializeField] public float RampAngleMax { get; set; } = 35f;

        [Header("Cube Obstacles")]
        [field: SerializeField] public int MinCubeObstacleCount { get; set; } = 1;
        [field: SerializeField] public int MaxCubeObstacleCount { get; set; } = 4;
        [field: SerializeField] public Vector3 CubeObstacleSizeMin { get; set; } = new(2f, 2f, 2f);
        [field: SerializeField] public Vector3 CubeObstacleSizeMax { get; set; } = new(6f, 8f, 6f);

        [Header("Grafitti Surfaces")]
        [field: SerializeField] public int MinGrafittiWallCount { get; set; } = 1;
        [field: SerializeField] public int MaxGrafittiWallCount { get; set; } = 3;
        [field: SerializeField] public float GrafittiWallDepth { get; set; } = 0.3f;

        [Header("Boundary Walls")]
        [field: Tooltip("Height of walls placed on non-entry/exit edges")]
        [field: SerializeField] public bool useBoundaryWalls { get; set; } = false;
        [field: SerializeField] public float BoundaryWallHeight { get; set; } = HexConstants.DefaultBoundaryWallHeight;
        [field: SerializeField] public float BoundaryWallThickness { get; set; } = HexConstants.DefaultBoundaryWallThickness;

        [Header("Shop")]
        [field: SerializeField] public float ShopChance { get; set; } = HexConstants.DefaultShopChance;

        [Header("Materials")]
        [field: SerializeField] public Material RailMaterial { get; set; }
        [field: SerializeField] public Material RampMaterial { get; set; }
        [field: SerializeField] public Material WallMaterial { get; set; }
        [field: SerializeField] public Material ObstacleMaterial { get; set; }
        [field: SerializeField] public Material GroundMaterial { get; set; }
        [field: SerializeField] public Material BoundaryWallMaterial { get; set; }

        [Header("Prefab References")]
        [field: SerializeField] public GameObject ShopZonePrefab { get; set; }
        [field: SerializeField] public GameObject PickUpPrefab { get; set; }
        [field: SerializeField] public GameObject GrafittiWallPrefab { get; set; }

        [Header("Pickup Spawning")]
        [field: SerializeField] public int PickUpCount { get; set; } = 5;
        [field: SerializeField] public float MinPickUpSpacing { get; set; } = 0.1f;
        [field: SerializeField] public float PickUpHeightOffset { get; set; } = 1f;
    }
}
