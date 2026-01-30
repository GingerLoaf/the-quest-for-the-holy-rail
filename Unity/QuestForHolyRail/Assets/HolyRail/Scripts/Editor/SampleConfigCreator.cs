using UnityEngine;
using UnityEditor;
using HolyRail.Scripts.LevelGeneration;

namespace HolyRail.Editor
{
    public class SampleConfigCreator
    {
        [MenuItem("HolyRail/Create Sample Hex Config")]
        public static void CreateSampleConfig()
        {
            var config = ScriptableObject.CreateInstance<HexSectionConfig>();
            
            // Basic Settings
            config.Circumradius = 50f;
            config.RandomizeEntryExit = true;
            config.EntryEdge = 0;
            config.ExitEdge = 3;

            // Rails
            config.MinRailCount = 2;
            config.MaxRailCount = 3;
            config.PointsPerRail = 30; // Smooth curves
            config.RailMinHeight = 2f;
            config.RailMaxHeight = 15f;
            config.MinRailSpacing = 8f;
            config.RailNoiseFrequency = new Vector2(0.3f, 0.2f);
            config.RailNoiseAmplitude = new Vector2(5f, 4f);

            // Ramps
            config.MinRampCount = 2;
            config.MaxRampCount = 4;
            config.RampLengthMin = 15f;
            config.RampLengthMax = 25f;
            config.RampWidthMin = 8f;
            config.RampWidthMax = 12f;
            config.RampAngleMin = 15f;
            config.RampAngleMax = 25f;

            // Obstacles (Sparser but larger)
            config.MinCubeObstacleCount = 3;
            config.MaxCubeObstacleCount = 6;
            config.CubeObstacleSizeMin = new Vector3(8f, 5f, 8f);
            config.CubeObstacleSizeMax = new Vector3(15f, 15f, 15f);

            // Wall Rides
            config.MinGrafittiWallCount = 2;
            config.MaxGrafittiWallCount = 4;
            config.GrafittiWallDepth = 1f;

            // Walls
            config.BoundaryWallHeight = 10f;
            config.BoundaryWallThickness = 2f;

            string path = "Assets/HolyRail/Resources/SampleHexConfig.asset";
            
            // Ensure Resources folder exists
            if (!System.IO.Directory.Exists("Assets/HolyRail/Resources"))
            {
                System.IO.Directory.CreateDirectory("Assets/HolyRail/Resources");
            }

            AssetDatabase.CreateAsset(config, path);
            AssetDatabase.SaveAssets();

            EditorUtility.FocusProjectWindow();
            Selection.activeObject = config;

            Debug.Log($"Created Sample Config at {path}");
        }
    }
}
