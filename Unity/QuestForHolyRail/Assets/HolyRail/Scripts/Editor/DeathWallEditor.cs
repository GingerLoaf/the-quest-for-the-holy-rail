using UnityEngine;
using UnityEditor;
using HolyRail.Scripts;
using System.Linq;

namespace HolyRail.Scripts.Editor
{
    [CustomEditor(typeof(DeathWall))]
    public class DeathWallEditor : UnityEditor.Editor
    {
        private bool _showAnalytics = true;

        public override void OnInspectorGUI()
        {
            // Draw default inspector
            DrawDefaultInspector();

            EditorGUILayout.Space(20);

            // Analytics Section Header
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 14,
                alignment = TextAnchor.MiddleCenter
            };

            _showAnalytics = EditorGUILayout.Foldout(_showAnalytics, "DEATH ANALYTICS & TUNING DATA", true, headerStyle);

            if (_showAnalytics)
            {
                EditorGUILayout.Space(10);

                // Load analytics data
                var analytics = DeathWall.LoadAnalytics();
                int deathCount = analytics.records.Count;

                if (deathCount == 0)
                {
                    EditorGUILayout.HelpBox("No death data recorded yet. Play the game and die to collect analytics!", MessageType.Info);
                }
                else
                {
                    DrawStatisticsSummary(analytics);
                    EditorGUILayout.Space(10);
                    DrawDetailedAnalytics(analytics);
                    EditorGUILayout.Space(10);
                    DrawTuningRecommendations(analytics);
                }

                EditorGUILayout.Space(10);

                // Clear Button
                GUI.backgroundColor = new Color(1f, 0.3f, 0.3f);
                if (GUILayout.Button("CLEAR ALL ANALYTICS DATA", GUILayout.Height(30)))
                {
                    if (EditorUtility.DisplayDialog("Clear Analytics", 
                        $"Are you sure you want to clear all {deathCount} death records?\n\nThis action cannot be undone!", 
                        "Clear", "Cancel"))
                    {
                        DeathWall.ClearAnalytics();
                    }
                }
                GUI.backgroundColor = Color.white;
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawStatisticsSummary(AnalyticsData analytics)
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var titleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 12,
                normal = { textColor = new Color(0.3f, 0.8f, 1f) }
            };
            EditorGUILayout.LabelField("SUMMARY", titleStyle);

            EditorGUILayout.Space(5);

            int deathCount = analytics.records.Count;
            EditorGUILayout.LabelField($"Total Deaths: ", deathCount.ToString(), EditorStyles.boldLabel);

            EditorGUILayout.EndVertical();
        }

        private void DrawDetailedAnalytics(AnalyticsData analytics)
        {
            var records = analytics.records;

            // Calculate key statistics
            float avgPlayerCurrent = records.Average(r => r.playerCurrentSpeed);
            float avgWallSpeed = records.Average(r => r.deathWallSpeed);
            float avgSpeedDelta = avgWallSpeed - avgPlayerCurrent;

            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("KEY METRICS (OVERALL AVERAGES)", EditorStyles.boldLabel);
            EditorGUILayout.Space(3);

            DrawStatRow("Avg Player Speed at Death:", $"{avgPlayerCurrent:F2} m/s", new Color(0.7f, 0.9f, 1f));
            DrawStatRow("Avg Wall Speed at Catch:", $"{avgWallSpeed:F2} m/s", new Color(1f, 0.8f, 0.6f));
            DrawStatRow("Speed Difference:", $"{avgSpeedDelta:F2} m/s", avgSpeedDelta > 2f ? new Color(1f, 0.5f, 0.5f) : new Color(0.5f, 1f, 0.5f));

            EditorGUILayout.EndVertical();

            // Individual Session Information
            EditorGUILayout.Space(10);
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var sessionTitleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 12,
                normal = { textColor = new Color(0.8f, 1f, 0.8f) }
            };
            EditorGUILayout.LabelField("INDIVIDUAL SESSIONS", sessionTitleStyle);
            EditorGUILayout.Space(5);

            for (int i = 0; i < records.Count; i++)
            {
                var record = records[i];

                EditorGUILayout.BeginVertical(EditorStyles.helpBox);
                EditorGUILayout.LabelField($"Session {i + 1}", EditorStyles.boldLabel);
                EditorGUILayout.Space(2);

                DrawStatRow("  Player Max Speed:", $"{record.playerMaxSpeed:F2} m/s", new Color(0.5f, 1f, 0.5f));
                DrawStatRow("  Player Avg Speed:", $"{record.playerAvgSpeed:F2} m/s", new Color(0.7f, 0.9f, 1f));
                DrawStatRow("  Wall Max Speed:", $"{record.deathWallSpeed:F2} m/s", new Color(1f, 0.8f, 0.6f));

                EditorGUILayout.EndVertical();

                if (i < records.Count - 1)
                {
                    EditorGUILayout.Space(3);
                }
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawTuningRecommendations(AnalyticsData analytics)
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            var titleStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 12,
                normal = { textColor = new Color(1f, 0.8f, 0.3f) }
            };
            EditorGUILayout.LabelField("RECOMMENDATIONS", titleStyle);
            EditorGUILayout.Space(5);

            var records = analytics.records;
            int deathCount = records.Count;
            float avgPlayerCurrent = records.Average(r => r.playerCurrentSpeed);
            float avgWallSpeed = records.Average(r => r.deathWallSpeed);
            float speedDelta = avgWallSpeed - avgPlayerCurrent;

            // Sample size warning
            if (deathCount < 10)
            {
                EditorGUILayout.HelpBox($"Need more data ({deathCount} deaths). Play at least 10 times for reliable insights.", MessageType.Warning);
            }

            // Main tuning advice
            if (speedDelta > 3f)
            {
                EditorGUILayout.HelpBox("Wall is too fast! Reduce Acceleration or lower Max Speed.", MessageType.Warning);
            }
            else if (speedDelta > 1.5f)
            {
                EditorGUILayout.HelpBox("Wall speed is balanced. Players are being caught fairly.", MessageType.Info);
            }
            else
            {
                EditorGUILayout.HelpBox("Wall might be too slow. Increase Acceleration slightly.", MessageType.Info);
            }

            EditorGUILayout.EndVertical();
        }

        private void DrawStatRow(string label, string value, Color valueColor)
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(label, GUILayout.Width(100));

            var coloredStyle = new GUIStyle(EditorStyles.label);
            coloredStyle.normal.textColor = valueColor;
            coloredStyle.fontStyle = FontStyle.Bold;

            EditorGUILayout.LabelField(value, coloredStyle);
            EditorGUILayout.EndHorizontal();
        }

        private float CalculateStandardDeviation(System.Collections.Generic.List<float> values)
        {
            if (values.Count == 0) return 0f;

            float average = values.Average();
            float sumOfSquaresOfDifferences = values.Select(val => (val - average) * (val - average)).Sum();
            return Mathf.Sqrt(sumOfSquaresOfDifferences / values.Count);
        }
    }
}
