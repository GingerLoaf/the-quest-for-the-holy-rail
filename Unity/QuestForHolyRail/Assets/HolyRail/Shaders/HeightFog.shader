Shader "Custom/HeightFog"
{
    Properties
    {
        [HDR] _FogColor ("Fog Color", Color) = (0.5, 0.5, 0.7, 1)
        _Density ("Density", Float) = 0.01
        _StartDistance ("Start Distance", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        ZWrite Off
        Cull Off
        ZTest Always

        Pass
        {
            Name "HeightFog"

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            float4 _FogColor;
            float _Density;
            float _StartDistance;

            float4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                float2 uv = input.texcoord;
                float4 sceneColor = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, uv);

                float depth = SampleSceneDepth(uv);

                // Skip skybox (reversed Z: near=1, far=0)
                if (depth < 0.0001)
                    return sceneColor;

                // Convert to linear distance from camera
                float linearDepth = LinearEyeDepth(depth, _ZBufferParams);

                // Exponential fog
                float dist = max(0, linearDepth - _StartDistance);
                float fogAmount = 1.0 - exp(-dist * _Density);

                return float4(lerp(sceneColor.rgb, _FogColor.rgb, fogAmount), sceneColor.a);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
