Shader "HolyRail/ExplosionRadiusFresnel"
{
    Properties
    {
        [HDR] _Color ("Color", Color) = (1, 0.2, 0.1, 0.15)
        _FresnelPower ("Fresnel Power", Range(0.1, 10)) = 2.0
        _FresnelIntensity ("Fresnel Intensity", Range(0, 5)) = 1.0
        _EmissionIntensity ("Emission Intensity", Range(0, 10)) = 2.0

        [Header(Noise Texture 1)]
        _NoiseTex1 ("Noise Texture 1", 2D) = "white" {}
        _Noise1Tiling ("Tiling (X, Y)", Vector) = (1, 1, 0, 0)
        _Noise1ScrollSpeed ("Scroll Speed (X, Y)", Vector) = (0.5, 0.2, 0, 0)

        [Header(Noise Texture 2)]
        _NoiseTex2 ("Noise Texture 2", 2D) = "white" {}
        _Noise2Tiling ("Tiling (X, Y)", Vector) = (2, 2, 0, 0)
        _Noise2ScrollSpeed ("Scroll Speed (X, Y)", Vector) = (-0.3, 0.4, 0, 0)

        _NoiseBlend ("Noise Blend", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "IgnoreProjector" = "True"
        }

        Blend SrcAlpha One
        ZWrite Off
        Cull Off

        Pass
        {
            Name "ExplosionRadiusFresnel"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
                float3 worldNormal : TEXCOORD1;
                float3 worldViewDir : TEXCOORD2;
                float fogFactor : TEXCOORD3;
            };

            TEXTURE2D(_NoiseTex1);
            SAMPLER(sampler_NoiseTex1);
            TEXTURE2D(_NoiseTex2);
            SAMPLER(sampler_NoiseTex2);

            CBUFFER_START(UnityPerMaterial)
                float4 _Color;
                float _FresnelPower;
                float _FresnelIntensity;
                float _EmissionIntensity;
                float4 _Noise1Tiling;
                float4 _Noise1ScrollSpeed;
                float4 _Noise2Tiling;
                float4 _Noise2ScrollSpeed;
                float _NoiseBlend;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);

                output.positionCS = vertexInput.positionCS;
                output.uv = input.uv;
                output.worldNormal = normalInput.normalWS;
                output.worldViewDir = GetWorldSpaceViewDir(vertexInput.positionWS);
                output.fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Sample scrolling noise textures
                float2 uv1 = input.uv * _Noise1Tiling.xy + _Noise1ScrollSpeed.xy * _Time.y;
                float2 uv2 = input.uv * _Noise2Tiling.xy + _Noise2ScrollSpeed.xy * _Time.y;

                half noise1 = SAMPLE_TEXTURE2D(_NoiseTex1, sampler_NoiseTex1, uv1).r;
                half noise2 = SAMPLE_TEXTURE2D(_NoiseTex2, sampler_NoiseTex2, uv2).r;

                // Blend the two noise textures
                half noiseCombined = lerp(noise1, noise2, _NoiseBlend);

                // Calculate fresnel
                float3 worldNormal = normalize(input.worldNormal);
                float3 worldViewDir = normalize(input.worldViewDir);
                float fresnel = pow(1.0 - saturate(dot(worldNormal, worldViewDir)), _FresnelPower);
                fresnel *= _FresnelIntensity;

                // Combine fresnel with noise
                half fresnelNoise = fresnel * (0.5 + noiseCombined * 0.5);

                // Final color
                half4 finalColor;
                finalColor.rgb = _Color.rgb * _EmissionIntensity * fresnelNoise;
                finalColor.a = _Color.a * fresnelNoise;

                // Apply fog
                finalColor.rgb = MixFog(finalColor.rgb, input.fogFactor);

                return finalColor;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
