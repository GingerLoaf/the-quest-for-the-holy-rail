using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [StructLayout(LayoutKind.Sequential)]
    public struct BuildingData
    {
        public Vector3 Position;
        public Vector3 Scale;
        public Quaternion Rotation;
        public int ZoneType;    // 0 = Downtown, 1 = Industrial
        public int StyleIndex;  // Texture/color variation
    }
}
