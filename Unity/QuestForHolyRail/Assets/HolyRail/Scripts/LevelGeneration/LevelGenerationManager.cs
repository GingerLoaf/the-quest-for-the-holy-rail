using System.Collections.Generic;
using UnityEngine;

namespace HolyRail.Scripts.LevelGeneration
{
    public class LevelGenerationManager : MonoBehaviour
    {
        [Header("Generation Settings")]
        [Tooltip("Prefabs to use for generation. Must have HexSection component.")]
        [SerializeField] private HexSection[] sectionPrefabs;

        [Tooltip("Number of sections to generate.")]
        [SerializeField] private int sectionCount = 5;

        [Tooltip("Where the first section connects. If null, uses World Origin.")]
        [SerializeField] private Transform startPoint;

        [Tooltip("If true, generates on Start.")]
        [SerializeField] private bool generateOnStart = true;

        [Header("Runtime Data")]
        [SerializeField] private List<HexSection> spawnedSections = new List<HexSection>();

        private void Start()
        {
            if (generateOnStart)
            {
                GenerateLevel();
            }
        }

        [ContextMenu("Generate Level")]
        public void GenerateLevel()
        {
            ClearLevel();

            if (sectionPrefabs == null || sectionPrefabs.Length == 0)
            {
                Debug.LogWarning("[LevelGenerationManager] No section prefabs assigned!");
                return;
            }

            Vector3 nextPosition;
            Quaternion nextRotation;
            
            // Determine start point
            if (startPoint != null)
            {
                nextPosition = startPoint.position;
                nextRotation = startPoint.rotation;
            }
            else
            {
                nextPosition = Vector3.zero;
                nextRotation = Quaternion.identity;
            }
            
            // Keep track of the 'previous' exit data to snap to
            // For the VERY first section, we might want to align its Entry to 'startPoint'
            // or just place it at 'startPoint'.
            // The request says: "based on either world origin, or the pivot of the previous section's pivot of the exit edge"
            // And "always spawning a new section from the pivot of the entry edge"
            
            HexSection previousSection = null;

            for (int i = 0; i < sectionCount; i++)
            {
                // Pick a random prefab
                var prefab = sectionPrefabs[Random.Range(0, sectionPrefabs.Length)];
                if (prefab == null) continue;

                var newSection = Instantiate(prefab, transform);
                newSection.gameObject.name = $"Section_{i}_{prefab.name}";
                
                // Align Entry Edge
                if (previousSection == null)
                {
                    // First section: Align Entry Edge Pivot to Start Point
                    AlignToPoint(newSection, nextPosition, nextRotation);
                }
                else
                {
                    // Snap to previous exit
                    SnapToPrevious(newSection, previousSection);
                }

                newSection.SectionIndex = i;
                spawnedSections.Add(newSection);
                previousSection = newSection;
            }
        }

        [ContextMenu("Clear Level")]
        public void ClearLevel()
        {
            foreach (var section in spawnedSections)
            {
                if (section != null)
                {
#if UNITY_EDITOR
                    if (Application.isPlaying) Destroy(section.gameObject);
                    else DestroyImmediate(section.gameObject);
#else
                    Destroy(section.gameObject);
#endif
                }
            }
            spawnedSections.Clear();
            
            // Also clean up any children that might have been left if list was lost
            for (int i = transform.childCount - 1; i >= 0; i--)
            {
                var child = transform.GetChild(i).gameObject;
#if UNITY_EDITOR
                if (Application.isPlaying) Destroy(child);
                else DestroyImmediate(child);
#else
                Destroy(child);
#endif
            }
        }

        private void AlignToPoint(HexSection section, Vector3 point, Quaternion rotation)
        {
            // Enforce strict Hex Grid tessellation by only rotating around Y axis and aligning to grid vectors.

            // 1. Get Entry Info (Local) - Projected to 2D
            var entryEdge = section.EntryEdge;
            var circumradius = section.Circumradius;
            
            var entryLocalPos = HexConstants.GetEdgeMidpoint(entryEdge, circumradius);
            var entryLocalNormal = HexConstants.GetEdgeNormal(entryEdge, circumradius);

            // 2. Calculate Target Rotation (strictly Y-axis)
            // We want the Entry Normal to align with "Backwards" relative to the target rotation
            // (i.e., we enter FROM the direction the previous piece was pointing)
            Vector3 targetDirection = rotation * Vector3.back;

            float targetAngle = Mathf.Atan2(targetDirection.x, targetDirection.z) * Mathf.Rad2Deg;
            float entryAngle = Mathf.Atan2(entryLocalNormal.x, entryLocalNormal.z) * Mathf.Rad2Deg;
            
            float deltaAngle = targetAngle - entryAngle;
            
            // Apply strict Y rotation
            section.transform.rotation = Quaternion.Euler(0f, deltaAngle, 0f);
            
            // 3. Move Section
            // Now that rotation is locked, position the Entry Point at the target point
            var currentEntryWorld = section.transform.TransformPoint(entryLocalPos);
            var displacement = point - currentEntryWorld;
            section.transform.position += displacement;
        }

        private void SnapToPrevious(HexSection current, HexSection previous)
        {
            // Previous Exit Info (World Space)
            var prevExitEdge = previous.ExitEdge;
            var prevRad = previous.Circumradius;
            
            var prevExitLocalMid = HexConstants.GetEdgeMidpoint(prevExitEdge, prevRad);
            var prevExitLocalNormal = HexConstants.GetEdgeNormal(prevExitEdge, prevRad);
            
            var prevExitWorldPos = previous.transform.TransformPoint(prevExitLocalMid);
            var prevExitWorldNormal = previous.transform.TransformDirection(prevExitLocalNormal);
            
            // Current Entry Info (Local Space)
            var currEntryEdge = current.EntryEdge;
            var currRad = current.Circumradius;
            
            var currEntryLocalMid = HexConstants.GetEdgeMidpoint(currEntryEdge, currRad);
            var currEntryLocalNormal = HexConstants.GetEdgeNormal(currEntryEdge, currRad);
            
            // 1. Align Rotation (Strict Y-Axis)
            // Target direction is OPPOSITE to Previous Exit Normal
            Vector3 targetDirection = -prevExitWorldNormal;

            float targetAngle = Mathf.Atan2(targetDirection.x, targetDirection.z) * Mathf.Rad2Deg;
            float entryAngle = Mathf.Atan2(currEntryLocalNormal.x, currEntryLocalNormal.z) * Mathf.Rad2Deg;

            float deltaAngle = targetAngle - entryAngle;
            
            // Apply strict Y rotation
            current.transform.rotation = Quaternion.Euler(0f, deltaAngle, 0f);
            
            // 2. Align Position
            var newEntryWorldPos = current.transform.TransformPoint(currEntryLocalMid);
            var displacement = prevExitWorldPos - newEntryWorldPos;
            current.transform.position += displacement;
        }
    }
}
