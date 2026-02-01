using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct ObstacleData
    {
        public Vector3 Position;
        public Vector3 Scale;
        public Quaternion Rotation;
    }
}
