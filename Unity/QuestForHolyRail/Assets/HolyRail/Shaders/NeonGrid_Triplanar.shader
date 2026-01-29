Shader "HolyRail/NeonGrid_Triplanar"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.02, 0.02, 0.05, 1)
        _GridColor ("Grid Color", Color) = (0, 1, 1, 1)
        _GridColor2 ("Grid Color 2 (Major Lines)", Color) = (1, 0, 0.5, 1)
        _GridScale ("Grid Scale", Range(0.1, 10)) = 1
        _LineWidth ("Line Width", Range(0.001, 0.1)) = 0.02
        _MajorLineWidth ("Major Line Width", Range(0.001, 0.15)) = 0.04
        _MajorLineFrequency ("Major Line Frequency", Range(2, 20)) = 5
        _GlowIntensity ("Glow Intensity", Range(0, 10)) = 2
        _GlowFalloff ("Glow Falloff", Range(0.1, 10)) = 2
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 2, 2, 1)
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
                float _MajorLineWidth;
                float _MajorLineFrequency;
                float _GlowIntensity;
                float _GlowFalloff;
                float _TriplanarSharpness;
                float4 _EmissionColor;
            CBUFFER_END

            float GridLine(float coord, float lineWidth, float glowFalloff)
            {
                float dist = abs(frac(coord - 0.5) - 0.5);
                float edgeLine = smoothstep(lineWidth, 0, dist);
                float glow = exp(-dist * glowFalloff);
                return edgeLine + glow * 0.5;
            }

            float2 Grid(float2 uv, float lineWidth, float majorWidth, float majorFreq, float glowFalloff)
            {
                float minorX = GridLine(uv.x, lineWidth, glowFalloff);
                float minorY = GridLine(uv.y, lineWidth, glowFalloff);
                float minor = max(minorX, minorY);

                float majorX = GridLine(uv.x / majorFreq, majorWidth, glowFalloff * 0.5);
                float majorY = GridLine(uv.y / majorFreq, majorWidth, glowFalloff * 0.5);
                float major = max(majorX, majorY);

                return float2(minor, major);
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

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // Sample grid on each plane
                float2 gridXY = Grid(worldPos.xy, _LineWidth, _MajorLineWidth, _MajorLineFrequency, _GlowFalloff);
                float2 gridXZ = Grid(worldPos.xz, _LineWidth, _MajorLineWidth, _MajorLineFrequency, _GlowFalloff);
                float2 gridYZ = Grid(worldPos.yz, _LineWidth, _MajorLineWidth, _MajorLineFrequency, _GlowFalloff);

                // Blend grids
                float2 grid = gridXY * blend.z + gridXZ * blend.y + gridYZ * blend.x;

                // Combine colors
                float3 minorColor = _GridColor.rgb * grid.x * _GlowIntensity;
                float3 majorColor = _GridColor2.rgb * grid.y * _GlowIntensity;

                float3 finalColor = _BaseColor.rgb + minorColor + majorColor;
                float3 emission = (minorColor + majorColor) * _EmissionColor.rgb;

                finalColor += emission;
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
