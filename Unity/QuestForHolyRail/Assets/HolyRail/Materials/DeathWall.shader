Shader "HolyRail/DeathWall"
{
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _Intensity ("Intensity", Float) = 0.4
        _NoiseTex ("Noise Texture", 2D) = "black" {}
        _NoiseIntensity ("Noise Intensity", Float) = 0.5
        _NoiseScrollSpeed ("Noise Scroll Speed", Vector) = (0.5, 0.2, 0, 0)
        _NoiseTiling ("Noise Tiling", Vector) = (1, 1, 0, 0)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Transparent"
        }

        Pass
        {
            Name "DeathWallForward"
            Tags { "LightMode" = "UniversalForward" }

            Blend One One
            ZWrite Off
            Cull Back

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                half4 _Color;
                half _Intensity;
                half _NoiseIntensity;
                half4 _NoiseScrollSpeed;
                half4 _NoiseTiling;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.uv = input.uv;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half2 scrolledUV = input.uv * _NoiseTiling.xy + _Time.y * _NoiseScrollSpeed.xy;
                half noise = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, scrolledUV).r;

                half3 baseColor = _Color.rgb * _Intensity;
                half3 noiseColor = _Color.rgb * noise * _NoiseIntensity;
                half3 finalColor = baseColor + noiseColor;

                return half4(finalColor, 1.0h);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
