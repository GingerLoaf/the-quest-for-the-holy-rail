Shader "HolyRail/MatrixRain_Floor"
{
    Properties
    {
        _CharTex ("Character Atlas", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        [HDR] _CharColor ("Character Color", Color) = (0.1, 1.0, 0.35, 1.0)
        [HDR] _WakeColor ("Wake Color", Color) = (0.3, 2.0, 1.5, 1.0)
        _BackgroundColor ("Background Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _Speed ("Animation Speed", Float) = 1.0
        _Scale ("Character Scale", Float) = 1.0
        _Brightness ("Brightness", Float) = 1.0
        _TrailLength ("Trail Length", Float) = 0.5
        _CharChangeSpeed ("Character Change Speed", Float) = 3.0
        _TriplanarSharpness ("Triplanar Sharpness", Float) = 4

        [Header(Wake Trail Settings)]
        _WakeRadius ("Wake Radius", Float) = 3.0
        _WakeIntensity ("Wake Intensity", Float) = 1.5
        _WakeExpansion ("Wake Expansion", Float) = 0.5
        _WakeFalloff ("Wake Falloff Power", Float) = 1.0
        _WakeColorBlend ("Wake Color Blend", Float) = 0.7
        _WakeBrightness ("Wake Brightness Boost", Float) = 0.8
        _WakeSpeedBoost ("Wake Speed Boost", Float) = 1.5
        _WakeCharSpeedBoost ("Wake Char Speed Boost", Float) = 2.0
        _WakeSpeedGlow ("Speed Glow Multiplier", Float) = 0.5

        [Header(Ring Glow Settings)]
        _RingGlow ("Ring Glow", Float) = 0.5
        _RingWidth ("Ring Width", Float) = 0.2
        _RingFalloff ("Ring Falloff", Float) = 3.0
        _RingPulseSpeed ("Ring Pulse Speed", Float) = 0.0

        [Header(Ring Distortion)]
        _RingDistortion ("Ring Distortion Strength", Float) = 0.5
        _RingDistortionFalloff ("Ring Distortion Falloff", Float) = 2.0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }

        ZWrite On
        Cull Back

        Pass
        {
            Name "MatrixRainFloor"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            // Reduced from 32 to 16 for better performance
            #define MAX_WAKE_POSITIONS 16

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
            };

            TEXTURE2D(_CharTex);
            SAMPLER(sampler_CharTex);
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _CharTex_ST;
                float4 _NoiseTex_ST;
                float4 _CharColor;
                float4 _WakeColor;
                float4 _BackgroundColor;
                float _Speed;
                float _Scale;
                float _Brightness;
                float _TrailLength;
                float _CharChangeSpeed;
                float _TriplanarSharpness;
                float _WakeRadius;
                float _WakeIntensity;
                float _WakeExpansion;
                float _WakeFalloff;
                float _WakeColorBlend;
                float _WakeBrightness;
                float _WakeSpeedBoost;
                float _WakeCharSpeedBoost;
                float _WakeSpeedGlow;
                float _RingGlow;
                float _RingWidth;
                float _RingFalloff;
                float _RingPulseSpeed;
                float _RingDistortion;
                float _RingDistortionFalloff;
            CBUFFER_END

            // Global wake properties set from C#
            float4 _WakePositions[MAX_WAKE_POSITIONS]; // xy=worldXZ, z=age (0-1), w=intensity
            int _WakePositionCount;
            float2 _PlayerPositionXZ; // Current player XZ position for ring
            float _PlayerSpeed; // Current player speed (normalized 0-1)

            // Custom mod function that handles negative numbers correctly
            float2 mod2(float2 x, float2 y)
            {
                return x - y * floor(x / y);
            }

            float mod1(float x, float y)
            {
                return x - y * floor(x / y);
            }

            // Calculate wake influence from recorded trail history
            float CalculateWakeInfluence(float2 worldXZ)
            {
                float influence = 0.0;

                int count = min(_WakePositionCount, MAX_WAKE_POSITIONS);

                [loop]
                for (int i = 0; i < count; i++)
                {
                    float2 wakePos = _WakePositions[i].xy;
                    float age = _WakePositions[i].z;
                    float intensity = _WakePositions[i].w;

                    // Skip inactive positions
                    if (intensity <= 0) continue;

                    float2 toPoint = worldXZ - wakePos;
                    float dist = length(toPoint);

                    // Radius expands with age
                    float radius = _WakeRadius * (1.0 + age * _WakeExpansion);

                    if (dist < radius)
                    {
                        float normalizedDist = dist / radius;
                        float ageFade = 1.0 - age;

                        // Main wake influence with configurable falloff (center-focused)
                        float falloff = pow(1.0 - normalizedDist, _WakeFalloff);
                        influence += falloff * ageFade * intensity * _WakeIntensity;
                    }
                }

                return influence;
            }

            // Calculate ring distortion - smooth radial push from player position
            float2 CalculateRingDistortion(float2 worldXZ)
            {
                float2 toPoint = worldXZ - _PlayerPositionXZ;
                float dist = length(toPoint);

                if (dist < 0.01 || dist > _WakeRadius) return float2(0, 0);

                float normalizedDist = dist / _WakeRadius;

                // Smooth falloff from center
                float strength = pow(1.0 - normalizedDist, _RingDistortionFalloff);

                // Push outward from player
                float2 dir = toPoint / dist;
                return dir * strength * _RingDistortion;
            }

            // Calculate ring glow based on current player position only (no history)
            float CalculateRingGlow(float2 worldXZ)
            {
                float2 toPlayer = worldXZ - _PlayerPositionXZ;
                float dist = length(toPlayer);

                if (dist > _WakeRadius) return 0.0;

                float normalizedDist = dist / _WakeRadius;

                // Ring at outer edge
                float edgeDist = 1.0 - normalizedDist;
                float ringMask = smoothstep(_RingWidth, 0.0, edgeDist);
                ringMask *= exp(-edgeDist * _RingFalloff);

                // Optional pulse
                float pulse = 1.0 + sin(_Time.y * _RingPulseSpeed) * 0.2 * step(0.01, _RingPulseSpeed);

                // No saturate - allow overdrive
                return ringMask * _RingGlow * pulse;
            }

            // Text layer - returns character mask value
            float Text(float2 fragCoord, float wakeInfluence, float2 distortion)
            {
                // Apply scale
                fragCoord /= _Scale;

                // Apply ring distortion
                fragCoord += distortion;

                // Position within 16x16 cell
                float2 uv = mod2(fragCoord, float2(16.0, 16.0)) * 0.0625;
                float2 block = fragCoord * 0.0625 - uv;

                uv = uv * 0.8 + 0.1;

                // Character animation speed
                float charSpeed = _CharChangeSpeed * (1.0 + wakeInfluence * _WakeCharSpeedBoost);
                float2 noiseUV = block * 0.01 + _Time.y * charSpeed * 0.002;
                float4 noiseSample = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, noiseUV);
                uv += floor(noiseSample.xy * 16.0);

                uv *= 0.0625;
                uv.x = -uv.x;

                return SAMPLE_TEXTURE2D(_CharTex, sampler_CharTex, uv).r;
            }

            // Rain effect
            float3 Rain(float2 fragCoord, float2 resolution, float wakeInfluence, float2 distortion)
            {
                fragCoord /= _Scale;

                // Apply ring distortion
                fragCoord += distortion;

                fragCoord.x -= mod1(fragCoord.x, 16.0);

                float offset = sin(fragCoord.x * 15.0);
                float speed = cos(fragCoord.x * 3.0) * 0.3 + 0.7;
                speed *= (1.0 + wakeInfluence * _WakeSpeedBoost);

                float y = frac(fragCoord.y / (resolution.y / _Scale) + _Time.y * _Speed * speed + offset);

                float divisor = y * 20.0 * (2.0 - _TrailLength) + 0.05;
                float intensity = 1.0 / divisor;

                // Wake brightness boost
                intensity *= (1.0 + wakeInfluence * _WakeBrightness);

                // Speed-based glow boost
                intensity *= (1.0 + wakeInfluence * _PlayerSpeed * _WakeSpeedGlow);

                // Color blend - wakeInfluence not clamped, allows overdrive
                float3 color = lerp(_CharColor.rgb, _WakeColor.rgb, wakeInfluence * _WakeColorBlend);

                return color * intensity * _Brightness;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.normalWS = normInputs.normalWS;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float3 worldPos = input.positionWS;
                float3 normal = normalize(input.normalWS);
                float2 resolution = float2(512.0, 512.0);

                // Calculate wake influence from trail history (not clamped - allows overdrive)
                float wakeInfluence = CalculateWakeInfluence(worldPos.xz);

                // Calculate ring distortion from current player position
                float2 ringDistortion = CalculateRingDistortion(worldPos.xz);

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // World-space UVs
                float2 uvXY = worldPos.xy * 32.0;
                float2 uvXZ = worldPos.xz * 32.0;
                float2 uvYZ = worldPos.yz * 32.0;

                // Sample text
                float textXY = Text(uvXY, wakeInfluence, ringDistortion);
                float textXZ = Text(uvXZ, wakeInfluence, ringDistortion);
                float textYZ = Text(uvYZ, wakeInfluence, ringDistortion);

                // Sample rain
                float3 rainXY = Rain(uvXY, resolution, wakeInfluence, ringDistortion);
                float3 rainXZ = Rain(uvXZ, resolution, wakeInfluence, ringDistortion);
                float3 rainYZ = Rain(uvYZ, resolution, wakeInfluence, ringDistortion);

                // Blend
                float textMask = textXY * blend.z + textXZ * blend.y + textYZ * blend.x;
                float3 rainColor = rainXY * blend.z + rainXZ * blend.y + rainYZ * blend.x;

                half3 color = textMask * rainColor;
                color = max(color, _BackgroundColor.rgb);

                // Ring glow - multiplies with texture underneath (not recorded, just current position)
                float ringGlow = CalculateRingGlow(worldPos.xz);
                color *= (1.0 + ringGlow);

                half4 finalColor = half4(color, 1.0);

                // Fog
                float4 clipPos = TransformWorldToHClip(worldPos);
                float fogFactor = ComputeFogFactor(clipPos.z);
                finalColor.rgb = MixFog(finalColor.rgb, fogFactor);

                return finalColor;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
