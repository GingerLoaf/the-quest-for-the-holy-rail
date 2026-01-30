using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.City
{
    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct GraffitiSpotData
    {
        public Vector3 Position;
        public Quaternion Rotation;
        public Vector3 Normal;       // Direction decal projects INTO the wall
        public int BillboardIndex;   // Index of billboard this graffiti is on (-1 if on plain wall)
    }
}
