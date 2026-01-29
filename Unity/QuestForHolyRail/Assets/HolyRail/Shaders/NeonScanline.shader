Shader "HolyRail/NeonScanline"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.02, 0.02, 0.05, 1)
        _LineColor ("Line Color", Color) = (0, 1, 1, 1)
        _ScanlineColor ("Scanline Color", Color) = (1, 0, 1, 1)
        _GridScale ("Grid Scale", Range(0.1, 10)) = 1
        _LineWidth ("Line Width", Range(0.001, 0.1)) = 0.02
        _GlowIntensity ("Glow Intensity", Range(0, 10)) = 2
        _GlowFalloff ("Glow Falloff", Range(0.1, 10)) = 2
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
        [HDR] _EmissionColor ("Emission Color", Color) = (0, 2, 2, 1)

        [Header(Scanline)]
        _ScanlineSpeed ("Scanline Speed", Range(0.1, 20)) = 5
        _ScanlineWidth ("Scanline Width", Range(0.01, 2)) = 0.3
        _ScanlineGlow ("Scanline Glow", Range(0, 5)) = 2
        _ScanlineDirection ("Scanline Direction (0=Y, 1=Radial)", Range(0, 1)) = 0

        [Header(Horizon Effect)]
        _HorizonFade ("Horizon Fade", Range(0, 1)) = 0.5
        _HorizonHeight ("Horizon Height", Float) = 0
        _HorizonGlow ("Horizon Glow Intensity", Range(0, 5)) = 1
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
                float4 _LineColor;
                float4 _ScanlineColor;
                float _GridScale;
                float _LineWidth;
                float _GlowIntensity;
                float _GlowFalloff;
                float _TriplanarSharpness;
                float4 _EmissionColor;
                float _ScanlineSpeed;
                float _ScanlineWidth;
                float _ScanlineGlow;
                float _ScanlineDirection;
                float _HorizonFade;
                float _HorizonHeight;
                float _HorizonGlow;
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

            float Scanline(float3 worldPos, float time)
            {
                float coord;
                if (_ScanlineDirection < 0.5)
                {
                    coord = worldPos.y;
                }
                else
                {
                    coord = length(worldPos.xz);
                }

                float scanPos = frac(time * _ScanlineSpeed * 0.1);
                float dist = abs(frac(coord * 0.1) - scanPos);
                dist = min(dist, 1.0 - dist);

                float scan = exp(-dist * dist / (_ScanlineWidth * _ScanlineWidth));
                return scan * _ScanlineGlow;
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

                // Calculate scanline
                float scan = Scanline(input.positionWS, time);

                // Horizon glow effect
                float horizonDist = abs(input.positionWS.y - _HorizonHeight);
                float horizonGlow = exp(-horizonDist * _HorizonFade) * _HorizonGlow;

                // Grid color with horizon fade
                float3 gridEmission = _LineColor.rgb * grid * _GlowIntensity;
                gridEmission *= (1.0 + horizonGlow);

                // Scanline effect
                float3 scanEmission = _ScanlineColor.rgb * scan * grid;

                // Horizon line
                float3 horizonEmission = _ScanlineColor.rgb * horizonGlow * 0.5;

                float3 finalColor = _BaseColor.rgb + gridEmission + scanEmission + horizonEmission;
                float3 emission = (gridEmission + scanEmission + horizonEmission) * _EmissionColor.rgb;

                finalColor += emission;
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
