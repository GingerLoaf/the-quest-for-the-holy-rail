Shader "Custom/HeightFog"
{
    Properties
    {
        [HDR] _BottomColor ("Bottom Color", Color) = (0.1, 0.1, 0.2, 1)
        [HDR] _MiddleColor ("Middle Color", Color) = (0.3, 0.3, 0.4, 0.8)
        [HDR] _TopColor ("Top Color", Color) = (0.6, 0.7, 0.9, 0.3)

        _BottomHeight ("Bottom Height", Float) = 0
        _MiddleHeight ("Middle Height", Float) = 50
        _TopHeight ("Top Height", Float) = 150

        _BottomMiddleFalloff ("Bottom-Middle Falloff", Float) = 20
        _MiddleTopFalloff ("Middle-Top Falloff", Float) = 30

        _BottomDensity ("Bottom Density", Range(0, 1)) = 1
        _MiddleDensity ("Middle Density", Range(0, 1)) = 0.7
        _TopDensity ("Top Density", Range(0, 1)) = 0.3

        _GlobalDensity ("Global Density", Range(0, 1)) = 1
        _MinDistance ("Min Distance", Float) = 0
        _MaxDistance ("Max Distance", Float) = 500
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

            CBUFFER_START(UnityPerMaterial)
                float4 _BottomColor;
                float4 _MiddleColor;
                float4 _TopColor;
                float _BottomHeight;
                float _MiddleHeight;
                float _TopHeight;
                float _BottomMiddleFalloff;
                float _MiddleTopFalloff;
                float _BottomDensity;
                float _MiddleDensity;
                float _TopDensity;
                float _GlobalDensity;
                float _MinDistance;
                float _MaxDistance;
            CBUFFER_END

            float4 Frag(Varyings input) : SV_Target
            {
                float2 uv = input.texcoord;
                float4 sceneColor = SAMPLE_TEXTURE2D(_BlitTexture, sampler_LinearClamp, uv);

                float depth = SampleSceneDepth(uv);

                // Skip skybox (far plane)
                #if UNITY_REVERSED_Z
                    if (depth <= 0.0001)
                        return sceneColor;
                #else
                    if (depth >= 0.9999)
                        return sceneColor;
                #endif

                // Reconstruct world position using URP's built-in function
                float2 positionNDC = uv;
                #if UNITY_UV_STARTS_AT_TOP
                    positionNDC.y = 1.0 - positionNDC.y;
                #endif
                float3 worldPos = ComputeWorldSpacePosition(positionNDC, depth, UNITY_MATRIX_I_VP);
                float worldHeight = worldPos.y;

                float distanceFromCamera = length(worldPos - _WorldSpaceCameraPos);
                float distanceFactor = saturate((distanceFromCamera - _MinDistance) / (_MaxDistance - _MinDistance));

                float bottomToMiddle = saturate((worldHeight - _BottomHeight) / _BottomMiddleFalloff);
                float middleToTop = saturate((worldHeight - _MiddleHeight) / _MiddleTopFalloff);

                float3 fogColor;
                float fogDensity;

                if (worldHeight < _MiddleHeight)
                {
                    fogColor = lerp(_BottomColor.rgb, _MiddleColor.rgb, bottomToMiddle);
                    fogDensity = lerp(_BottomDensity * _BottomColor.a, _MiddleDensity * _MiddleColor.a, bottomToMiddle);
                }
                else
                {
                    fogColor = lerp(_MiddleColor.rgb, _TopColor.rgb, middleToTop);
                    fogDensity = lerp(_MiddleDensity * _MiddleColor.a, _TopDensity * _TopColor.a, middleToTop);
                }

                float finalFogAmount = fogDensity * _GlobalDensity * distanceFactor;

                float3 finalColor = lerp(sceneColor.rgb, fogColor, finalFogAmount);

                return float4(finalColor, sceneColor.a);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
