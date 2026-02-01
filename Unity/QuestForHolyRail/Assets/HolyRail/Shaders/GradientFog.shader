Shader "Custom/GradientFog"
{
    Properties
    {
        [HDR] _Color1 ("Bottom Color", Color) = (0.2, 0.1, 0.3, 1)
        [HDR] _Color2 ("Middle Color", Color) = (0.4, 0.3, 0.5, 1)
        [HDR] _Color3 ("Top Color", Color) = (0.6, 0.5, 0.7, 1)
        _BlendHeight12 ("Blend Height 1-2", Float) = 10
        _BlendHeight23 ("Blend Height 2-3", Float) = 50
        _Falloff12 ("Falloff 1-2", Float) = 10
        _Falloff23 ("Falloff 2-3", Float) = 20
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
            Name "GradientFog"

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            float4 _Color1;
            float4 _Color2;
            float4 _Color3;
            float _BlendHeight12;
            float _BlendHeight23;
            float _Falloff12;
            float _Falloff23;
            float _Density;
            float _StartDistance;

            float3 ReconstructWorldPosition(float2 uv, float rawDepth)
            {
                float2 ndc = uv * 2.0 - 1.0;
                #if UNITY_UV_STARTS_AT_TOP
                ndc.y = -ndc.y;
                #endif
                float4 positionCS = float4(ndc, rawDepth, 1.0);
                float4 positionWS = mul(UNITY_MATRIX_I_VP, positionCS);
                return positionWS.xyz / positionWS.w;
            }

            float3 GetHeightGradientColor(float worldY)
            {
                float blend12 = smoothstep(_BlendHeight12 - _Falloff12 * 0.5, _BlendHeight12 + _Falloff12 * 0.5, worldY);
                float blend23 = smoothstep(_BlendHeight23 - _Falloff23 * 0.5, _BlendHeight23 + _Falloff23 * 0.5, worldY);
                float3 color12 = lerp(_Color1.rgb, _Color2.rgb, blend12);
                return lerp(color12, _Color3.rgb, blend23);
            }

            float4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                float2 uv = input.texcoord;
                float4 sceneColor = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, uv);

                float depth = SampleSceneDepth(uv);

                // Skip skybox (reversed Z: near=1, far=0)
                if (depth < 0.0001)
                    return sceneColor;

                // Reconstruct world position
                float3 worldPos = ReconstructWorldPosition(uv, depth);

                // Get height-based fog color
                float3 fogColor = GetHeightGradientColor(worldPos.y);

                // Convert to linear distance from camera
                float linearDepth = LinearEyeDepth(depth, _ZBufferParams);

                // DEBUG: Return solid red to verify shader is running
                return float4(1, 0, 0, 1);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
