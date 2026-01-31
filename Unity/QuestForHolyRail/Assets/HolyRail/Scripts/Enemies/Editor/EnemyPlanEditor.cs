using UnityEngine;
using UnityEditor;
using System;
using System.Linq;
using System.Collections.Generic;
using HolyRail.Scripts.Enemies;
using HolyRail.Scripts.Enemies.Actions;

namespace HolyRail.Scripts.Enemies.Editor
{
    [CustomEditor(typeof(EnemyPlan))]
    public class EnemyPlanEditor : UnityEditor.Editor
    {
        private SerializedProperty _planName;
        private SerializedProperty _spawnWeight;
        private SerializedProperty _loopActions;
        private SerializedProperty _enterDuration;
        private SerializedProperty _exitDuration;
        private SerializedProperty _actions;

        private static readonly Dictionary<string, Type> _actionTypes = new()
        {
            { "Spawn Enemy", typeof(SpawnEnemyAction) },
            { "Wait", typeof(WaitAction) },
            { "Command Enemy", typeof(CommandEnemyAction) },
            { "Spawn Formation", typeof(SpawnFormationAction) }
        };

        private void OnEnable()
        {
            _planName = serializedObject.FindProperty("PlanName");
            _spawnWeight = serializedObject.FindProperty("SpawnWeight");
            _loopActions = serializedObject.FindProperty("LoopActions");
            _enterDuration = serializedObject.FindProperty("EnterDuration");
            _exitDuration = serializedObject.FindProperty("ExitDuration");
            _actions = serializedObject.FindProperty("Actions");
        }

        public override void OnInspectorGUI()
        {
            serializedObject.Update();

            EditorGUILayout.LabelField("Plan Identity", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(_planName);
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Plan Selection", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(_spawnWeight);
            EditorGUILayout.Space();

            EditorGUILayout.LabelField("Plan Timing", EditorStyles.boldLabel);
            EditorGUILayout.PropertyField(_loopActions);
            EditorGUILayout.PropertyField(_enterDuration);
            EditorGUILayout.PropertyField(_exitDuration);
            EditorGUILayout.Space();

            // Custom Actions list
            EditorGUILayout.LabelField("Actions", EditorStyles.boldLabel);
            DrawActionsList();

            serializedObject.ApplyModifiedProperties();
        }

        private void DrawActionsList()
        {
            // Add new action dropdown
            EditorGUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();

            if (EditorGUILayout.DropdownButton(new GUIContent("+ Add Action"), FocusType.Keyboard, GUILayout.Width(120)))
            {
                ShowAddActionMenu();
            }

            EditorGUILayout.EndHorizontal();
            EditorGUILayout.Space(5);

            // Draw existing actions
            var plan = (EnemyPlan)target;
            if (plan.Actions == null || plan.Actions.Count == 0)
            {
                EditorGUILayout.HelpBox("No actions in this plan. Click '+ Add Action' to add one.", MessageType.Info);
                return;
            }

            for (int i = 0; i < plan.Actions.Count; i++)
            {
                DrawAction(i, plan.Actions[i]);
            }
        }

        private void DrawAction(int index, EnemyAction action)
        {
            if (action == null)
            {
                EditorGUILayout.HelpBox($"Action {index} is null", MessageType.Error);
                return;
            }

            EditorGUILayout.BeginVertical(EditorStyles.helpBox);

            // Action header with type name and remove button
            EditorGUILayout.BeginHorizontal();

            string actionTypeName = GetFriendlyActionName(action.GetType());
            EditorGUILayout.LabelField($"{index}. {actionTypeName}", EditorStyles.boldLabel);

            GUILayout.FlexibleSpace();

            // Move up button
            GUI.enabled = index > 0;
            if (GUILayout.Button("↑", GUILayout.Width(25)))
            {
                MoveActionUp(index);
                return;
            }

            // Move down button
            GUI.enabled = index < _actions.arraySize - 1;
            if (GUILayout.Button("↓", GUILayout.Width(25)))
            {
                MoveActionDown(index);
                return;
            }

            GUI.enabled = true;

            // Remove button
            if (GUILayout.Button("✕", GUILayout.Width(25)))
            {
                RemoveAction(index);
                return;
            }

            EditorGUILayout.EndHorizontal();

            EditorGUI.indentLevel++;

            // Draw action properties
            SerializedProperty actionProp = _actions.GetArrayElementAtIndex(index);
            DrawActionProperties(actionProp, action);

            EditorGUI.indentLevel--;

            EditorGUILayout.EndVertical();
            EditorGUILayout.Space(5);
        }

        private void DrawActionProperties(SerializedProperty actionProp, EnemyAction action)
        {
            // Draw Delay field (common to all actions)
            SerializedProperty delayProp = actionProp.FindPropertyRelative("Delay");
            if (delayProp != null)
            {
                EditorGUILayout.PropertyField(delayProp, new GUIContent("Delay Before Next Action"));
            }

            // Draw type-specific fields
            switch (action)
            {
                case SpawnEnemyAction spawnAction:
                    DrawSpawnEnemyActionFields(actionProp);
                    break;

                case CommandEnemyAction commandAction:
                    DrawCommandEnemyActionFields(actionProp);
                    break;

                case SpawnFormationAction formationAction:
                    DrawSpawnFormationActionFields(actionProp);
                    break;

                case WaitAction waitAction:
                    EditorGUILayout.HelpBox("Wait action only uses the Delay field above.", MessageType.Info);
                    break;
            }
        }

        private void DrawSpawnEnemyActionFields(SerializedProperty actionProp)
        {
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("EnemyPrefab"));
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("RelativePosition"));
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("PositionVariance"));
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("StartsIdle"));
        }

        private void DrawCommandEnemyActionFields(SerializedProperty actionProp)
        {
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("TargetEnemyIndex"));
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("Command"));

            // Only show TargetPosition if command is MoveTo
            SerializedProperty commandProp = actionProp.FindPropertyRelative("Command");
            if (commandProp != null && commandProp.enumValueIndex == (int)CommandEnemyAction.CommandType.MoveTo)
            {
                EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("TargetPosition"));
            }
        }

        private void DrawSpawnFormationActionFields(SerializedProperty actionProp)
        {
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("FormationCenter"));
            EditorGUILayout.PropertyField(actionProp.FindPropertyRelative("Formation"), true);
        }

        private void ShowAddActionMenu()
        {
            GenericMenu menu = new GenericMenu();

            foreach (var kvp in _actionTypes)
            {
                menu.AddItem(new GUIContent(kvp.Key), false, () => AddAction(kvp.Value));
            }

            menu.ShowAsContext();
        }

        private void AddAction(Type actionType)
        {
            serializedObject.Update();

            var plan = (EnemyPlan)target;
            var newAction = (EnemyAction)Activator.CreateInstance(actionType);

            Undo.RecordObject(plan, "Add Action");
            plan.Actions.Add(newAction);
            EditorUtility.SetDirty(plan);

            serializedObject.Update();
        }

        private void RemoveAction(int index)
        {
            serializedObject.Update();

            var plan = (EnemyPlan)target;

            Undo.RecordObject(plan, "Remove Action");
            plan.Actions.RemoveAt(index);
            EditorUtility.SetDirty(plan);

            serializedObject.Update();
        }

        private void MoveActionUp(int index)
        {
            if (index <= 0) return;

            serializedObject.Update();

            var plan = (EnemyPlan)target;

            Undo.RecordObject(plan, "Move Action Up");
            var temp = plan.Actions[index];
            plan.Actions[index] = plan.Actions[index - 1];
            plan.Actions[index - 1] = temp;
            EditorUtility.SetDirty(plan);

            serializedObject.Update();
        }

        private void MoveActionDown(int index)
        {
            var plan = (EnemyPlan)target;
            if (index >= plan.Actions.Count - 1) return;

            serializedObject.Update();

            Undo.RecordObject(plan, "Move Action Down");
            var temp = plan.Actions[index];
            plan.Actions[index] = plan.Actions[index + 1];
            plan.Actions[index + 1] = temp;
            EditorUtility.SetDirty(plan);

            serializedObject.Update();
        }

        private string GetFriendlyActionName(Type actionType)
        {
            var entry = _actionTypes.FirstOrDefault(kvp => kvp.Value == actionType);
            return entry.Key ?? actionType.Name;
        }
    }
}
