Shader "HolyRail/NeonWireframe_Triplanar"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.01, 0.01, 0.03, 1)
        _WireColor ("Wire Color", Color) = (0, 1, 1, 1)
        _WireColor2 ("Wire Color 2", Color) = (1, 0, 0.5, 1)
        _GridScale ("Grid Scale", Range(0.1, 10)) = 2
        _LineWidth ("Line Width", Range(0.001, 0.15)) = 0.03
        _GlowIntensity ("Glow Intensity", Range(0, 15)) = 3
        _GlowFalloff ("Glow Falloff", Range(0.1, 10)) = 1.5
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 3, 3, 1)

        [Header(Edge Detection)]
        _EdgeFresnel ("Edge Fresnel Power", Range(0.1, 5)) = 2
        _EdgeGlow ("Edge Glow Intensity", Range(0, 5)) = 1

        [Header(Animation)]
        _FlickerSpeed ("Flicker Speed", Range(0, 20)) = 5
        _FlickerIntensity ("Flicker Intensity", Range(0, 1)) = 0.1
        _ColorCycleSpeed ("Color Cycle Speed", Range(0, 2)) = 0.3
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
                float3 viewDirWS : TEXCOORD2;
                float fogFactor : TEXCOORD3;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _WireColor;
                float4 _WireColor2;
                float _GridScale;
                float _LineWidth;
                float _GlowIntensity;
                float _GlowFalloff;
                float _TriplanarSharpness;
                float4 _EmissionColor;
                float _EdgeFresnel;
                float _EdgeGlow;
                float _FlickerSpeed;
                float _FlickerIntensity;
                float _ColorCycleSpeed;
            CBUFFER_END

            float Hash(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return frac((p3.x + p3.y) * p3.z);
            }

            float GridLine(float coord, float lineWidth, float glowFalloff)
            {
                float dist = abs(frac(coord - 0.5) - 0.5);
                float edgeLine = smoothstep(lineWidth, 0, dist);
                float glow = exp(-dist * glowFalloff);
                return edgeLine + glow * 0.5;
            }

            float2 Grid(float2 uv, float lineWidth, float glowFalloff)
            {
                float lineX = GridLine(uv.x, lineWidth, glowFalloff);
                float lineY = GridLine(uv.y, lineWidth, glowFalloff);
                return float2(lineX, lineY);
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.normalWS = normInputs.normalWS;
                output.viewDirWS = GetWorldSpaceNormalizeViewDir(posInputs.positionWS);
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float3 worldPos = input.positionWS * _GridScale;
                float3 normal = normalize(input.normalWS);
                float3 viewDir = normalize(input.viewDirWS);
                float time = _Time.y;

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // Sample grid on each plane (get both X and Y lines)
                float2 gridXY = Grid(worldPos.xy, _LineWidth, _GlowFalloff);
                float2 gridXZ = Grid(worldPos.xz, _LineWidth, _GlowFalloff);
                float2 gridYZ = Grid(worldPos.yz, _LineWidth, _GlowFalloff);

                // Blend grids - separate X and Y components for color variation
                float gridX = gridXY.x * blend.z + gridXZ.x * blend.y + gridYZ.x * blend.x;
                float gridY = gridXY.y * blend.z + gridXZ.y * blend.y + gridYZ.y * blend.x;

                // Fresnel edge glow
                float fresnel = pow(1.0 - saturate(dot(normal, viewDir)), _EdgeFresnel);
                float edgeGlow = fresnel * _EdgeGlow;

                // Flicker effect
                float flicker = 1.0 - _FlickerIntensity * (0.5 + 0.5 * sin(time * _FlickerSpeed + Hash(floor(worldPos.xz)) * 6.28));

                // Color cycling
                float colorPhase = sin(time * _ColorCycleSpeed + length(input.positionWS) * 0.1) * 0.5 + 0.5;

                // Apply colors to different line directions
                float3 color1 = lerp(_WireColor.rgb, _WireColor2.rgb, colorPhase);
                float3 color2 = lerp(_WireColor2.rgb, _WireColor.rgb, colorPhase);

                float3 wireEmission = color1 * gridX + color2 * gridY;
                wireEmission *= _GlowIntensity * flicker;

                // Add edge glow
                float3 edgeEmission = lerp(_WireColor.rgb, _WireColor2.rgb, fresnel) * edgeGlow;

                float3 finalColor = _BaseColor.rgb + wireEmission + edgeEmission;
                float3 emission = (wireEmission + edgeEmission) * _EmissionColor.rgb;

                finalColor += emission;
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
