Shader "HolyRail/LaserLattice"
{
    Properties
    {
        [HDR] _LaserColor ("Laser Color", Color) = (1, 0, 0, 1)
        [HDR] _IntersectionColor ("Intersection Color", Color) = (2, 0, 0, 1)
        _Intensity ("Intensity", Range(0, 10)) = 2
        _Frequency ("Frequency", Range(1, 50)) = 10
        _NoiseAmount ("Noise Amount", Range(0, 1)) = 0.1
        _IntersectionIntensity ("Intersection Intensity", Range(0, 10)) = 3
        _IntersectionThreshold ("Intersection Threshold", Range(0.01, 1)) = 0.1
        _EdgeFalloff ("Edge Falloff", Range(0.01, 0.5)) = 0.15
        _AnimationSpeed ("Animation Speed", Range(0, 5)) = 1
        _LineWidth ("Line Width", Range(0.001, 0.2)) = 0.03
        _PatternSpinFront ("Pattern Spin Front", Float) = 0
        _PatternSpinBack ("Pattern Spin Back", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent"
        }

        Pass
        {
            Name "LaserLattice"
            Tags { "LightMode" = "UniversalForward" }

            Blend One One
            ZWrite Off
            Cull Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionOS : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
                float3 normalOS : TEXCOORD3;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _LaserColor;
                float4 _IntersectionColor;
                float _Intensity;
                float _Frequency;
                float _NoiseAmount;
                float _IntersectionIntensity;
                float _IntersectionThreshold;
                float _EdgeFalloff;
                float _AnimationSpeed;
                float _LineWidth;
                float _PatternSpinFront;
                float _PatternSpinBack;
            CBUFFER_END

            float Hash(float2 p)
            {
                return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
            }

            float Noise(float2 p)
            {
                float2 i = floor(p);
                float2 f = frac(p);
                f = f * f * (3.0 - 2.0 * f);

                float a = Hash(i);
                float b = Hash(i + float2(1.0, 0.0));
                float c = Hash(i + float2(0.0, 1.0));
                float d = Hash(i + float2(1.0, 1.0));

                return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
            }

            float2 RotateUV(float2 uv, float angle)
            {
                float s = sin(angle);
                float c = cos(angle);
                return float2(
                    uv.x * c - uv.y * s,
                    uv.x * s + uv.y * c
                );
            }

            float LaserLine(float coord, float lineWidth)
            {
                float dist = abs(frac(coord - 0.5) - 0.5);
                return smoothstep(lineWidth, lineWidth * 0.5, dist);
            }

            float LatticePattern(float2 uv, float frequency, float lineWidth, float time, float noiseAmount)
            {
                float noise = Noise(uv * 2.0 + time * 0.5) * noiseAmount;
                float2 noisyUV = uv * frequency + noise;

                float gridX = LaserLine(noisyUV.x, lineWidth);
                float gridY = LaserLine(noisyUV.y, lineWidth);

                float diag1 = LaserLine((noisyUV.x + noisyUV.y) * 0.707, lineWidth);
                float diag2 = LaserLine((noisyUV.x - noisyUV.y) * 0.707, lineWidth);

                float lattice = max(max(gridX, gridY), max(diag1, diag2) * 0.7);

                float pulse = sin(time * 3.0) * 0.15 + 0.85;
                lattice *= pulse;

                return lattice;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);

                output.positionCS = posInputs.positionCS;
                output.positionOS = input.positionOS.xyz;
                output.positionWS = posInputs.positionWS;
                output.screenPos = ComputeScreenPos(output.positionCS);
                output.normalOS = input.normalOS;

                return output;
            }

            half4 frag(Varyings input, half facing : VFACE) : SV_Target
            {
                float2 uvXZ = input.positionOS.xz;

                // Apply continuous rotation based on which face we're rendering
                // facing > 0 means front face, < 0 means back face
                float spinSpeed = facing > 0 ? _PatternSpinFront : _PatternSpinBack;
                float rotation = _Time.y * spinSpeed;
                uvXZ = RotateUV(uvXZ, rotation);

                // Cylinder mesh has radius 0.5 in object space
                float distFromCenter = length(input.positionOS.xz);
                float edgeStart = 0.5 - _EdgeFalloff;
                float radialFade = 1.0 - smoothstep(edgeStart, 0.5, distFromCenter);

                if (radialFade < 0.01)
                {
                    discard;
                }

                float time = _Time.y * _AnimationSpeed;

                float lattice = LatticePattern(uvXZ, _Frequency, _LineWidth, time, _NoiseAmount);

                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float sceneDepth = LinearEyeDepth(SampleSceneDepth(screenUV), _ZBufferParams);
                float fragDepth = LinearEyeDepth(input.positionCS.z / input.positionCS.w, _ZBufferParams);
                float depthDiff = abs(sceneDepth - fragDepth);
                float intersection = 1.0 - saturate(depthDiff / _IntersectionThreshold);
                intersection = pow(intersection, 2.0);

                float3 laserColor = _LaserColor.rgb * lattice * _Intensity;
                float3 intersectionGlow = _IntersectionColor.rgb * intersection * _IntersectionIntensity;

                float3 finalColor = (laserColor + intersectionGlow) * radialFade;

                float alpha = saturate((lattice * _Intensity + intersection * _IntersectionIntensity) * radialFade);

                return half4(finalColor, alpha);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
