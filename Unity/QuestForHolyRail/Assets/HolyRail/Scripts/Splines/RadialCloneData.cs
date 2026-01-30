using System.Runtime.InteropServices;
using UnityEngine;

namespace HolyRail.Splines
{
    /// <summary>
    /// Radial symmetry modes for spline cloning.
    /// </summary>
    public enum RadialSymmetryMode
    {
        /// <summary>All clones identical, just rotated to face center</summary>
        None,
        /// <summary>Clones mirrored in pairs (0-1 same, 2-3 mirrored, etc.)</summary>
        TwoFold,
        /// <summary>Quadrants mirror each other (0-90 original, 90-180 mirrored X, etc.)</summary>
        FourFold,
        /// <summary>Octants with alternating mirror patterns</summary>
        EightFold
    }

    /// <summary>
    /// Data struct for GPU instanced rendering of radial spline clones.
    /// Must match the shader struct layout exactly.
    /// </summary>
    [StructLayout(LayoutKind.Sequential)]
    public struct RadialCloneData
    {
        public Vector3 Position;    // 12 bytes
        public Vector4 Rotation;    // 16 bytes (quaternion as float4)
        public Vector3 Scale;       // 12 bytes (includes mirror as negative scale)
        public int CloneIndex;      // 4 bytes
        // Total: 44 bytes
    }
}
