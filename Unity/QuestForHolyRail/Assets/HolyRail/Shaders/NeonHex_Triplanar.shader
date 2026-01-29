Shader "HolyRail/NeonHex_Triplanar"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.02, 0.02, 0.05, 1)
        _HexColor ("Hex Color", Color) = (0, 1, 1, 1)
        _HexColor2 ("Hex Color 2", Color) = (1, 0, 0.5, 1)
        _HexScale ("Hex Scale", Range(0.1, 10)) = 1
        _LineWidth ("Line Width", Range(0.01, 0.2)) = 0.05
        _GlowIntensity ("Glow Intensity", Range(0, 10)) = 2
        _GlowFalloff ("Glow Falloff", Range(0.1, 10)) = 3
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 2, 2, 1)

        [Header(Animation)]
        _PulseSpeed ("Pulse Speed", Range(0, 5)) = 1
        _ColorShiftSpeed ("Color Shift Speed", Range(0, 2)) = 0.5
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
                float4 _HexColor;
                float4 _HexColor2;
                float _HexScale;
                float _LineWidth;
                float _GlowIntensity;
                float _GlowFalloff;
                float _TriplanarSharpness;
                float4 _EmissionColor;
                float _PulseSpeed;
                float _ColorShiftSpeed;
            CBUFFER_END

            float HexDist(float2 p)
            {
                p = abs(p);
                float c = dot(p, normalize(float2(1, 1.73)));
                c = max(c, p.x);
                return c;
            }

            float4 HexCoords(float2 uv)
            {
                float2 r = float2(1, 1.73);
                float2 h = r * 0.5;

                float2 a = fmod(uv, r) - h;
                float2 b = fmod(uv - h, r) - h;

                float2 gv;
                if (length(a) < length(b))
                    gv = a;
                else
                    gv = b;

                float x = atan2(gv.x, gv.y);
                float y = 0.5 - HexDist(gv);

                float2 id = uv - gv;

                return float4(gv.x, gv.y, id.x, id.y);
            }

            float HexGrid(float2 uv, float lineWidth, float glowFalloff)
            {
                float4 hc = HexCoords(uv);
                float dist = 0.5 - HexDist(hc.xy);

                float edgeLine = smoothstep(lineWidth, 0, dist);
                float glow = exp(-dist * glowFalloff);

                return edgeLine + glow * 0.3;
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
                float3 worldPos = input.positionWS * _HexScale;
                float3 normal = normalize(input.normalWS);
                float time = _Time.y;

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // Sample hex grid on each plane
                float hexXY = HexGrid(worldPos.xy, _LineWidth, _GlowFalloff);
                float hexXZ = HexGrid(worldPos.xz, _LineWidth, _GlowFalloff);
                float hexYZ = HexGrid(worldPos.yz, _LineWidth, _GlowFalloff);

                // Blend hex grids
                float hex = hexXY * blend.z + hexXZ * blend.y + hexYZ * blend.x;

                // Get hex cell IDs for color variation
                float4 hcXY = HexCoords(worldPos.xy);
                float4 hcXZ = HexCoords(worldPos.xz);
                float4 hcYZ = HexCoords(worldPos.yz);

                float cellId = (hcXY.z + hcXY.w) * blend.z +
                               (hcXZ.z + hcXZ.w) * blend.y +
                               (hcYZ.z + hcYZ.w) * blend.x;

                // Animated color shift
                float colorMix = sin(cellId * 0.5 + time * _ColorShiftSpeed) * 0.5 + 0.5;
                float3 hexColor = lerp(_HexColor.rgb, _HexColor2.rgb, colorMix);

                // Pulse animation
                float pulse = sin(time * _PulseSpeed) * 0.3 + 1.0;

                float3 hexEmission = hexColor * hex * _GlowIntensity * pulse;

                float3 finalColor = _BaseColor.rgb + hexEmission;
                float3 emission = hexEmission * _EmissionColor.rgb;

                finalColor += emission;
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
