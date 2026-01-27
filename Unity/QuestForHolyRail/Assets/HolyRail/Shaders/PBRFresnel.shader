Shader "HolyRail/PBR Fresnel"
{
    Properties
    {
        [Header(Base)]
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _BaseMap("Base Map", 2D) = "white" {}

        [Header(Metallic Smoothness)]
        _Metallic("Metallic", Range(0, 1)) = 0.0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _MetallicGlossMap("Metallic Map", 2D) = "white" {}

        [Header(Normal)]
        [Normal] _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Float) = 1.0

        [Header(Emission)]
        [HDR] _EmissionColor("Emission Color", Color) = (0, 0, 0, 1)
        _EmissionMap("Emission Map", 2D) = "white" {}
        _EmissionIntensity("Emission Intensity", Range(0, 10)) = 1.0

        [Header(Fresnel)]
        [HDR] _FresnelColor("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower("Fresnel Power", Range(0.1, 10)) = 3.0
        _FresnelIntensity("Fresnel Intensity", Range(0, 5)) = 1.0
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
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 tangentWS : TEXCOORD3;
                float3 bitangentWS : TEXCOORD4;
                float3 viewDirWS : TEXCOORD5;
                float fogFactor : TEXCOORD6;
            };

            TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);
            TEXTURE2D(_BumpMap); SAMPLER(sampler_BumpMap);
            TEXTURE2D(_MetallicGlossMap); SAMPLER(sampler_MetallicGlossMap);
            TEXTURE2D(_EmissionMap); SAMPLER(sampler_EmissionMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4 _BaseColor;
                half _Metallic;
                half _Smoothness;
                half _BumpScale;
                half4 _EmissionColor;
                half _EmissionIntensity;
                half4 _FresnelColor;
                half _FresnelPower;
                half _FresnelIntensity;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);
                output.normalWS = normInputs.normalWS;
                output.tangentWS = normInputs.tangentWS;
                output.bitangentWS = normInputs.bitangentWS;
                output.viewDirWS = GetWorldSpaceNormalizeViewDir(posInputs.positionWS);
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Sample textures
                half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);
                half4 albedo = baseMap * _BaseColor;

                half4 metallicGloss = SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, input.uv);
                half metallic = metallicGloss.r * _Metallic;
                half smoothness = metallicGloss.a * _Smoothness;

                // Normal mapping
                half3 normalTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, input.uv), _BumpScale);
                half3x3 tangentToWorld = half3x3(input.tangentWS, input.bitangentWS, input.normalWS);
                half3 normalWS = normalize(mul(normalTS, tangentToWorld));

                // View direction
                half3 viewDirWS = normalize(input.viewDirWS);

                // Fresnel
                half fresnel = pow(1.0 - saturate(dot(normalWS, viewDirWS)), _FresnelPower);
                half3 fresnelColor = _FresnelColor.rgb * fresnel * _FresnelIntensity;

                // Emission
                half3 emission = SAMPLE_TEXTURE2D(_EmissionMap, sampler_EmissionMap, input.uv).rgb;
                emission *= _EmissionColor.rgb * _EmissionIntensity;

                // Setup surface data
                SurfaceData surfaceData = (SurfaceData)0;
                surfaceData.albedo = albedo.rgb;
                surfaceData.metallic = metallic;
                surfaceData.smoothness = smoothness;
                surfaceData.normalTS = normalTS;
                surfaceData.emission = emission + fresnelColor;
                surfaceData.occlusion = 1.0;
                surfaceData.alpha = albedo.a;

                // Setup input data
                InputData inputData = (InputData)0;
                inputData.positionWS = input.positionWS;
                inputData.normalWS = normalWS;
                inputData.viewDirectionWS = viewDirWS;
                inputData.shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                inputData.fogCoord = input.fogFactor;
                inputData.bakedGI = SampleSH(normalWS);
                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);

                // Calculate lighting
                half4 color = UniversalFragmentPBR(inputData, surfaceData);

                // Apply fog
                color.rgb = MixFog(color.rgb, input.fogFactor);

                return color;
            }
            ENDHLSL
        }

        // Shadow caster pass
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            ZWrite On
            ZTest LEqual
            ColorMask 0

            HLSLPROGRAM
            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

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
            };

            float3 _LightDirection;

            Varyings ShadowPassVertex(Attributes input)
            {
                Varyings output;
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

                #if UNITY_REVERSED_Z
                    positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                    positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif

                output.positionCS = positionCS;
                return output;
            }

            half4 ShadowPassFragment(Varyings input) : SV_Target
            {
                return 0;
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
