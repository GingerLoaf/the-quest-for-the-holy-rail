Shader "HolyRail/SkySphere"
{
    Properties
    {
        [Header(Star Field)]
        [HDR] _StarColor ("Star Color", Color) = (1, 1, 1, 1)
        _StarDensity ("Star Density", Float) = 100.0
        _StarSize ("Star Size", Float) = 0.02
        _StarSizeVariation ("Star Size Variation", Range(0, 1)) = 0.5
        _StarColorVariation ("Star Color Variation", Range(0, 1)) = 0.3
        _StarEmission ("Star Emission", Float) = 2.0

        [Header(Background)]
        _BackgroundColor ("Background Color", Color) = (0.0, 0.0, 0.02, 1.0)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            Name "SkySphereForward"
            Tags { "LightMode" = "UniversalForward" }

            Cull Off
            ZWrite On

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float4 _StarColor;
                float _StarDensity;
                float _StarSize;
                float _StarSizeVariation;
                float _StarColorVariation;
                float _StarEmission;
                float4 _BackgroundColor;
            CBUFFER_END

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

            // Hash functions for procedural randomness
            float hash11(float p)
            {
                p = frac(p * 0.1031);
                p *= p + 33.33;
                p *= p + p;
                return frac(p);
            }

            float hash21(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return frac((p3.x + p3.y) * p3.z);
            }

            float3 hash23(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * float3(0.1031, 0.1030, 0.0973));
                p3 += dot(p3, p3.yxz + 33.33);
                return frac((p3.xxy + p3.yzz) * p3.zyx);
            }

            // Convert direction to spherical UV coordinates for star field
            float2 directionToSphericalUV(float3 dir)
            {
                float3 n = normalize(dir);
                float u = atan2(n.x, n.z) / (2.0 * PI) + 0.5;
                float v = asin(n.y) / PI + 0.5;
                return float2(u, v);
            }

            // Calculate star field
            float3 calculateStarField(float3 direction)
            {
                float3 color = _BackgroundColor.rgb;

                // Use spherical coordinates for consistent star distribution
                float2 uv = directionToSphericalUV(direction);

                // Scale UV by density to create grid cells
                float2 scaledUV = uv * _StarDensity;
                float2 cellID = floor(scaledUV);
                float2 cellUV = frac(scaledUV);

                // Check this cell and neighboring cells for stars
                for (int x = -1; x <= 1; x++)
                {
                    for (int y = -1; y <= 1; y++)
                    {
                        float2 neighborCell = cellID + float2(x, y);

                        // Get random values for this cell
                        float3 rand = hash23(neighborCell);
                        float rand2 = hash21(neighborCell + 100.0);
                        float rand3 = hash21(neighborCell + 200.0);

                        // Determine if this cell has a star (roughly 30% of cells)
                        if (rand.x > 0.7)
                        {
                            // Star position within cell (offset from center)
                            float2 starPos = neighborCell + float2(rand.y, rand.z) * 0.8 + 0.1;

                            // Distance from current position to star
                            float2 diff = scaledUV - starPos;

                            // Adjust for spherical wrapping on U coordinate
                            if (diff.x > _StarDensity * 0.5) diff.x -= _StarDensity;
                            if (diff.x < -_StarDensity * 0.5) diff.x += _StarDensity;

                            float dist = length(diff);

                            // Calculate star size with variation
                            float sizeVariation = lerp(1.0, rand2, _StarSizeVariation);
                            float starRadius = _StarSize * sizeVariation;

                            // Star brightness falloff
                            float brightness = smoothstep(starRadius, starRadius * 0.1, dist);

                            if (brightness > 0.0)
                            {
                                // Apply color variation
                                float3 starColor = _StarColor.rgb;
                                float3 colorOffset = (rand - 0.5) * 2.0 * _StarColorVariation;

                                // Subtle hue/saturation shift
                                starColor.r *= 1.0 + colorOffset.x * 0.5;
                                starColor.g *= 1.0 + colorOffset.y * 0.3;
                                starColor.b *= 1.0 + colorOffset.z * 0.5;

                                // Some stars can be slightly warmer or cooler
                                float warmth = (rand3 - 0.5) * _StarColorVariation;
                                starColor.r *= 1.0 + warmth * 0.3;
                                starColor.b *= 1.0 - warmth * 0.3;

                                // Apply emission and add to color
                                color += starColor * brightness * _StarEmission;
                            }
                        }
                    }
                }

                return color;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs positionInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = positionInputs.positionCS;
                output.positionWS = positionInputs.positionWS;
                output.normalWS = normalInputs.normalWS;
                output.fogFactor = ComputeFogFactor(positionInputs.positionCS.z);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                // Get view direction from camera to fragment
                float3 viewDir = normalize(input.positionWS - _WorldSpaceCameraPos);

                // Calculate star field based on view direction
                float3 starField = calculateStarField(viewDir);

                // Force full fog for sky sphere (it represents infinite distance)
                // fogFactor of 0 = full fog in URP
                float3 finalColor = MixFog(starField, 0);

                return float4(finalColor, 1.0);
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
