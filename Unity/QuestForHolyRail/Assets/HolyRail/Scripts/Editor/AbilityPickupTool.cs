using UnityEngine;
using UnityEditor;
using Art.PickUps;
using System.Collections.Generic;
using System.Linq;

namespace HolyRail.Scripts.Editor
{
    public class AbilityPickupTool : EditorWindow
    {
        private List<AbilityPickUp> _pickups = new List<AbilityPickUp>();
        private Vector2 _scrollPosition;

        [MenuItem("Holy Rail/Ability Pickup Tool")]
        public static void ShowWindow()
        {
            GetWindow<AbilityPickupTool>("Ability Pickups");
        }

        private void OnGUI()
        {
            DrawHeader();
            EditorGUILayout.Space(10);
            DrawControls();
            EditorGUILayout.Space(10);
            DrawList();
        }

        private void DrawHeader()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            var headerStyle = new GUIStyle(EditorStyles.boldLabel)
            {
                fontSize = 16,
                alignment = TextAnchor.MiddleCenter
            };
            EditorGUILayout.LabelField("ABILITY PICKUP TOOL", headerStyle);
            EditorGUILayout.LabelField("Manager for AbilityPickUp components", EditorStyles.centeredGreyMiniLabel);
            EditorGUILayout.EndVertical();
        }

        private void DrawControls()
        {
            EditorGUILayout.BeginVertical(EditorStyles.helpBox);
            EditorGUILayout.LabelField("Actions", EditorStyles.boldLabel);
            EditorGUILayout.Space(5);

            if (GUILayout.Button("Find All in Context", GUILayout.Height(30)))
            {
                RefreshList();
            }

            EditorGUILayout.Space(5);

            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("Enable All"))
            {
                SetAll(true);
            }
            if (GUILayout.Button("Disable All"))
            {
                SetAll(false);
            }
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();
        }

        private void DrawList()
        {
            _scrollPosition = EditorGUILayout.BeginScrollView(_scrollPosition);

            if (_pickups.Count == 0)
            {
                EditorGUILayout.HelpBox("No AbilityPickUp components found. Click 'Find All in Context'.", MessageType.Info);
            }
            else
            {
                for (int i = 0; i < _pickups.Count; i++)
                {
                    var pickup = _pickups[i];
                    if (pickup == null) continue;

                    EditorGUILayout.BeginHorizontal(EditorStyles.helpBox);

                    // Status indicator
                    Color statusColor = pickup.enabled ? Color.green : Color.gray;
                    var style = new GUIStyle(GUI.skin.box);
                    style.normal.background = Texture2D.whiteTexture;
                    var oldColor = GUI.color;
                    GUI.color = statusColor;
                    GUILayout.Box("", style, GUILayout.Width(10), GUILayout.Height(20));
                    GUI.color = oldColor;

                    EditorGUILayout.LabelField(pickup.gameObject.name, GUILayout.Width(200));

                    EditorGUI.BeginChangeCheck();
                    bool newEnabled = EditorGUILayout.Toggle("Enabled", pickup.enabled);
                    if (EditorGUI.EndChangeCheck())
                    {
                        Undo.RecordObject(pickup, "Toggle AbilityPickUp");
                        pickup.enabled = newEnabled;
                        EditorUtility.SetDirty(pickup);
                    }

                    if (GUILayout.Button("Select", GUILayout.Width(60)))
                    {
                        Selection.activeGameObject = pickup.gameObject;
                        EditorGUIUtility.PingObject(pickup.gameObject);
                    }

                    EditorGUILayout.EndHorizontal();
                }
            }

            EditorGUILayout.EndScrollView();
        }

        private void RefreshList()
        {
            _pickups = FindObjectsByType<AbilityPickUp>(FindObjectsInactive.Include, FindObjectsSortMode.InstanceID).OrderBy(p => p.name).ToList();
            Debug.Log($"Found {_pickups.Count} AbilityPickUp components.");
        }

        private void SetAll(bool state)
        {
            foreach (var pickup in _pickups)
            {
                if (pickup != null)
                {
                    Undo.RecordObject(pickup, $"Set AbilityPickUp {state}");
                    pickup.enabled = state;
                    EditorUtility.SetDirty(pickup);
                }
            }
        }
    }
}
