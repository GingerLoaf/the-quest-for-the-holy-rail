Shader "HolyRail/NeonGrid_Pulse"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.02, 0.02, 0.05, 1)
        _GridColor ("Grid Color", Color) = (0, 1, 1, 1)
        _GridColor2 ("Pulse Color", Color) = (1, 0, 1, 1)
        _GridScale ("Grid Scale", Range(0.1, 10)) = 1
        _LineWidth ("Line Width", Range(0.001, 0.1)) = 0.02
        _GlowIntensity ("Glow Intensity", Range(0, 10)) = 2
        _GlowFalloff ("Glow Falloff", Range(0.1, 10)) = 2
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 2, 2, 1)

        [Header(Animation)]
        _PulseSpeed ("Pulse Speed", Range(0.1, 10)) = 1
        _PulseWidth ("Pulse Width", Range(0.1, 5)) = 1
        _PulseDirection ("Pulse Direction (XYZ)", Vector) = (1, 0, 1, 0)
        _WaveAmplitude ("Wave Amplitude", Range(0, 2)) = 0.5
        _WaveFrequency ("Wave Frequency", Range(0.1, 5)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry"
        }

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

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
                float fogFactor : TEXCOORD2;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _GridColor;
                float4 _GridColor2;
                float _GridScale;
                float _LineWidth;
                float _GlowIntensity;
                float _GlowFalloff;
                float _TriplanarSharpness;
                float4 _EmissionColor;
                float _PulseSpeed;
                float _PulseWidth;
                float4 _PulseDirection;
                float _WaveAmplitude;
                float _WaveFrequency;
            CBUFFER_END

            float GridLine(float coord, float lineWidth, float glowFalloff)
            {
                float dist = abs(frac(coord - 0.5) - 0.5);
                float edgeLine = smoothstep(lineWidth, 0, dist);
                float glow = exp(-dist * glowFalloff);
                return edgeLine + glow * 0.5;
            }

            float Grid(float2 uv, float lineWidth, float glowFalloff)
            {
                float lineX = GridLine(uv.x, lineWidth, glowFalloff);
                float lineY = GridLine(uv.y, lineWidth, glowFalloff);
                return max(lineX, lineY);
            }

            float PulseWave(float3 worldPos, float time)
            {
                float3 dir = normalize(_PulseDirection.xyz);
                float dist = dot(worldPos, dir);
                float wave = sin((dist - time * _PulseSpeed) * _WaveFrequency * TWO_PI);
                wave = wave * 0.5 + 0.5;
                wave = pow(wave, _PulseWidth);
                return wave;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.normalWS = normInputs.normalWS;
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float3 worldPos = input.positionWS * _GridScale;
                float3 normal = normalize(input.normalWS);
                float time = _Time.y;

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // Sample grid on each plane
                float gridXY = Grid(worldPos.xy, _LineWidth, _GlowFalloff);
                float gridXZ = Grid(worldPos.xz, _LineWidth, _GlowFalloff);
                float gridYZ = Grid(worldPos.yz, _LineWidth, _GlowFalloff);

                // Blend grids
                float grid = gridXY * blend.z + gridXZ * blend.y + gridYZ * blend.x;

                // Calculate pulse wave
                float pulse = PulseWave(input.positionWS, time);

                // Animated glow intensity
                float animatedGlow = _GlowIntensity * (1 + _WaveAmplitude * sin(time * 2));

                // Color mixing based on pulse
                float3 gridColorMixed = lerp(_GridColor.rgb, _GridColor2.rgb, pulse);
                float3 gridEmission = gridColorMixed * grid * animatedGlow;

                // Add traveling highlight
                float highlight = pulse * grid * 2;
                gridEmission += _GridColor2.rgb * highlight;

                float3 finalColor = _BaseColor.rgb + gridEmission;
                float3 emission = gridEmission * _EmissionColor.rgb;

                finalColor += emission;
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
