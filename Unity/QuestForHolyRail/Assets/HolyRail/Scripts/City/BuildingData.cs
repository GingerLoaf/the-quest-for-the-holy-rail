using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct BuildingData
    {
        public Vector3 Position;
        public Vector3 Scale;
        public Quaternion Rotation;
        public int NeedsCollider;  // 0 = Visual only, 1 = Needs collider (corridor-adjacent)
        public int StyleIndex;     // Texture/color variation
    }
}
