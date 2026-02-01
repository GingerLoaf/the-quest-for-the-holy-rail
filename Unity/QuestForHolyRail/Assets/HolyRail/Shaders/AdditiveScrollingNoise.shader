Shader "HolyRail/AdditiveScrollingNoise"
{
    Properties
    {
        [Header(Gradient)]
        _BottomColor ("Bottom Color", Color) = (0, 0, 1, 1)
        _TopColor ("Top Color", Color) = (0, 1, 1, 1)
        [Toggle] _UseObjectSpaceGradient ("Use Object Space Y", Float) = 0
        _GradientMinY ("Gradient Min Y", Float) = 0
        _GradientMaxY ("Gradient Max Y", Float) = 1

        [Header(Noise Texture 1)]
        _NoiseTex1 ("Noise Texture 1", 2D) = "white" {}
        _NoiseScale1 ("Noise Scale 1", Vector) = (1, 1, 0, 0)
        _NoiseScrollSpeed1 ("Noise Scroll Speed 1", Vector) = (0.5, 0.2, 0, 0)

        [Header(Noise Texture 2)]
        _NoiseTex2 ("Noise Texture 2", 2D) = "white" {}
        _NoiseScale2 ("Noise Scale 2", Vector) = (1, 1, 0, 0)
        _NoiseScrollSpeed2 ("Noise Scroll Speed 2", Vector) = (-0.3, 0.1, 0, 0)

        [Header(Fresnel)]
        _FresnelPower ("Fresnel Power", Float) = 2.0
        _FresnelIntensity ("Fresnel Intensity", Float) = 1.0

        [Header(Refraction)]
        _RefractionStrength ("Refraction Strength", Range(0, 0.5)) = 0.0
        _RefractionNoiseInfluence ("Noise Influence", Range(0, 1)) = 1.0

        [Header(Output)]
        _Intensity ("Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            Name "AdditiveScrollingNoise"
            Tags { "LightMode" = "UniversalForward" }

            Blend SrcAlpha One
            ZWrite Off
            Cull Off

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float gradientFactor : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 viewDirWS : TEXCOORD3;
                float4 screenPos : TEXCOORD4;
            };

            TEXTURE2D(_NoiseTex1);
            SAMPLER(sampler_NoiseTex1);
            TEXTURE2D(_NoiseTex2);
            SAMPLER(sampler_NoiseTex2);

            CBUFFER_START(UnityPerMaterial)
                float4 _BottomColor;
                float4 _TopColor;
                float _UseObjectSpaceGradient;
                float _GradientMinY;
                float _GradientMaxY;
                float4 _NoiseScale1;
                float4 _NoiseScrollSpeed1;
                float4 _NoiseScale2;
                float4 _NoiseScrollSpeed2;
                float _FresnelPower;
                float _FresnelIntensity;
                float _RefractionStrength;
                float _RefractionNoiseInfluence;
                float _Intensity;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                output.positionCS = TransformWorldToHClip(positionWS);
                output.uv = input.uv;

                // Screen position for refraction sampling
                output.screenPos = ComputeScreenPos(output.positionCS);

                // World space normal and view direction for fresnel
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.viewDirWS = GetWorldSpaceNormalizeViewDir(positionWS);

                // Calculate gradient factor based on toggle
                if (_UseObjectSpaceGradient > 0.5)
                {
                    // Use object space Y position
                    float yPos = input.positionOS.y;
                    output.gradientFactor = saturate((yPos - _GradientMinY) / (_GradientMaxY - _GradientMinY + 0.0001));
                }
                else
                {
                    // Use UV.y
                    output.gradientFactor = input.uv.y;
                }

                return output;
            }

            half4 frag(Varyings input, half facing : VFACE) : SV_Target
            {
                // Calculate scrolling UVs for both noise textures
                float2 noiseUV1 = input.uv * _NoiseScale1.xy + _Time.y * _NoiseScrollSpeed1.xy;
                float2 noiseUV2 = input.uv * _NoiseScale2.xy + _Time.y * _NoiseScrollSpeed2.xy;

                // Sample both noise textures
                half noise1 = SAMPLE_TEXTURE2D(_NoiseTex1, sampler_NoiseTex1, noiseUV1).r;
                half noise2 = SAMPLE_TEXTURE2D(_NoiseTex2, sampler_NoiseTex2, noiseUV2).r;

                // Combine noise by multiplication
                half combinedNoise = noise1 * noise2;

                // Calculate fresnel (flip normal for back faces)
                float3 normalWS = normalize(input.normalWS) * facing;
                float3 viewDirWS = normalize(input.viewDirWS);
                float NdotV = dot(normalWS, viewDirWS);
                float fresnel = pow(1.0 - saturate(NdotV), _FresnelPower) * _FresnelIntensity;

                // Refraction using scrolling noise
                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                if (_RefractionStrength > 0.001)
                {
                    // Use combined noise to create distortion offset
                    float2 noiseOffset = (combinedNoise - 0.5) * 2.0 * _RefractionStrength;
                    // Blend between pure noise distortion and noise-modulated distortion
                    noiseOffset *= lerp(1.0, combinedNoise, _RefractionNoiseInfluence);

                    float2 distortedUV = screenUV + noiseOffset;
                    half3 refractionColor = SampleSceneColor(distortedUV);

                    // The refraction is shown through the object - we'll blend it additively
                    // This creates a "heat shimmer" or "energy field" effect
                }

                // Lerp between bottom and top color based on gradient factor
                half4 gradientColor = lerp(_BottomColor, _TopColor, input.gradientFactor);

                // Final output: gradient color * combined noise * fresnel * intensity (no saturation)
                half4 finalColor;
                finalColor.rgb = gradientColor.rgb * combinedNoise * fresnel * _Intensity;
                finalColor.a = gradientColor.a * combinedNoise * fresnel;

                // Add refraction distortion to the scene behind
                if (_RefractionStrength > 0.001)
                {
                    float2 noiseOffset = (combinedNoise - 0.5) * 2.0 * _RefractionStrength;
                    noiseOffset *= lerp(1.0, combinedNoise, _RefractionNoiseInfluence);
                    float2 distortedUV = screenUV + noiseOffset;
                    half3 refractionColor = SampleSceneColor(distortedUV);
                    half3 originalColor = SampleSceneColor(screenUV);

                    // Add the difference (distortion effect) to the final color
                    finalColor.rgb += (refractionColor - originalColor) * fresnel;
                }

                return finalColor;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
