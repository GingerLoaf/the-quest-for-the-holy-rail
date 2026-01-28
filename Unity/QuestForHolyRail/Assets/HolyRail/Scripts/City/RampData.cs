using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct RampData
    {
        public Vector3 Position;
        public Vector3 Scale;      // (width, height/length along slope, depth)
        public Quaternion Rotation;
        public float Angle;        // Tilt angle in degrees (for reference, actual rotation is baked into Rotation)
    }
}
