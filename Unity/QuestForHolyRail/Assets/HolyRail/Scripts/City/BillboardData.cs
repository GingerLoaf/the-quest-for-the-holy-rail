using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct BillboardData
    {
        public Vector3 Position;
        public Vector3 Scale;        // (width, height, depth)
        public Quaternion Rotation;
        public Vector3 Normal;       // Inward-facing normal for wall ride detection
    }
}
