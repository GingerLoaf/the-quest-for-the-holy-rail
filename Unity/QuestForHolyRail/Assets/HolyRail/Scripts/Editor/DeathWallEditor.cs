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

                EditorGUILayout.Space(5);
                DrawVelocityGraph(record, i + 1);

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

        private void DrawVelocityGraph(SpeedAnalytics record, int sessionIndex)
        {
            if (record.velocityTimeline == null || record.velocityTimeline.Count == 0)
            {
                EditorGUILayout.HelpBox("No velocity timeline data available for this session.", MessageType.Info);
                return;
            }

            EditorGUILayout.Space(5);
            EditorGUILayout.LabelField("Velocity Over Time Graph", EditorStyles.boldLabel);

            // Graph dimensions
            float graphHeight = 150f;
            float graphWidth = EditorGUIUtility.currentViewWidth - 40f;
            float padding = 10f;

            Rect graphRect = GUILayoutUtility.GetRect(graphWidth, graphHeight);
            Rect innerRect = new Rect(
                graphRect.x + padding,
                graphRect.y + padding,
                graphRect.width - padding * 2,
                graphRect.height - padding * 2
            );

            // Draw background
            EditorGUI.DrawRect(graphRect, new Color(0.15f, 0.15f, 0.15f));
            EditorGUI.DrawRect(innerRect, new Color(0.2f, 0.2f, 0.2f));

            // Find min/max values for scaling
            float maxTime = record.velocityTimeline.Max(p => p.timeFromStart);
            float maxVelocity = Mathf.Max(record.velocityTimeline.Max(p => p.velocity), record.playerMaxSpeed);
            float minVelocity = 0f;

            // Draw grid lines
            Handles.color = new Color(0.3f, 0.3f, 0.3f);
            for (int i = 0; i <= 4; i++)
            {
                float y = innerRect.y + (innerRect.height / 4f) * i;
                Handles.DrawLine(new Vector3(innerRect.x, y), new Vector3(innerRect.xMax, y));
            }

            // Draw velocity line
            Handles.color = new Color(0.3f, 0.8f, 1f);
            for (int i = 0; i < record.velocityTimeline.Count - 1; i++)
            {
                var point1 = record.velocityTimeline[i];
                var point2 = record.velocityTimeline[i + 1];

                float x1 = innerRect.x + (point1.timeFromStart / maxTime) * innerRect.width;
                float y1 = innerRect.yMax - ((point1.velocity - minVelocity) / (maxVelocity - minVelocity)) * innerRect.height;

                float x2 = innerRect.x + (point2.timeFromStart / maxTime) * innerRect.width;
                float y2 = innerRect.yMax - ((point2.velocity - minVelocity) / (maxVelocity - minVelocity)) * innerRect.height;

                Handles.DrawLine(new Vector3(x1, y1), new Vector3(x2, y2));
            }

            // Draw data points
            Handles.color = new Color(0.5f, 1f, 0.5f);
            foreach (var point in record.velocityTimeline)
            {
                float x = innerRect.x + (point.timeFromStart / maxTime) * innerRect.width;
                float y = innerRect.yMax - ((point.velocity - minVelocity) / (maxVelocity - minVelocity)) * innerRect.height;
                Handles.DrawSolidDisc(new Vector3(x, y, 0), Vector3.forward, 2f);
            }

            // Draw labels
            var labelStyle = new GUIStyle(EditorStyles.miniLabel);
            labelStyle.normal.textColor = Color.white;

            // Y-axis labels (velocity)
            GUI.Label(new Rect(graphRect.x, innerRect.y - 10, 50, 20), $"{maxVelocity:F1} m/s", labelStyle);
            GUI.Label(new Rect(graphRect.x, innerRect.yMax - 10, 50, 20), $"{minVelocity:F1} m/s", labelStyle);

            // X-axis labels (time)
            GUI.Label(new Rect(innerRect.x, innerRect.yMax + 2, 50, 20), "0s", labelStyle);
            GUI.Label(new Rect(innerRect.xMax - 30, innerRect.yMax + 2, 50, 20), $"{maxTime:F1}s", labelStyle);

            // Legend
            EditorGUILayout.Space(5);
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField($"  Session Duration: {maxTime:F1}s", GUILayout.Width(150));
            EditorGUILayout.LabelField($"  Data Points: {record.velocityTimeline.Count}", GUILayout.Width(120));
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
