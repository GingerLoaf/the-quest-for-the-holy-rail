Shader "HolyRail/GraffitiBlendDecal"
{
    Properties
    {
        _EnemyTex("Enemy Texture", 2D) = "white" {}
        _PlayerTex("Player Texture", 2D) = "white" {}
        _BlendAmount("Blend Amount", Range(0, 1)) = 0
        [HDR] _EnemyColor("Enemy Color", Color) = (1, 0, 0, 1)
        [HDR] _PlayerColor("Player Color", Color) = (0, 1, 1, 1)
        _EmissionIntensity("Emission Intensity", Range(0, 10)) = 2

        // Decal properties
        [HideInInspector] _DecalMeshDepthBias("Depth Bias", Float) = 0
        [HideInInspector] _DecalMeshViewBias("View Bias", Float) = 0
        [HideInInspector] _DecalMeshBiasType("Bias Type", Float) = 0
        [HideInInspector] _DrawOrder("Draw Order", Float) = 0
        [HideInInspector] _DecalAngleFadeSupported("Angle Fade Supported", Float) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
            "DisableBatching" = "False"
        }

        // Forward Emissive Pass - Renders the decal as emissive on surfaces
        Pass
        {
            Name "DecalProjectorForwardEmissive"
            Tags { "LightMode" = "DecalProjectorForwardEmissive" }

            ZWrite Off
            ZTest LEqual
            Blend One One, Zero One
            BlendOp Add, Add

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile_instancing
            #pragma target 3.5

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            TEXTURE2D(_EnemyTex);
            SAMPLER(sampler_EnemyTex);
            TEXTURE2D(_PlayerTex);
            SAMPLER(sampler_PlayerTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings Vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.screenPos = ComputeScreenPos(output.positionCS);
                return output;
            }

            half4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                // Get screen UV and sample depth
                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float depth = SampleSceneDepth(screenUV);

                // Reconstruct world position from depth
                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);

                // Transform to decal object space
                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                // Clip outside the decal box
                float clipValue = 0.5 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                // Calculate UV from decal projection
                float2 uv = positionOS.xz + 0.5;

                // Sample both textures
                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                // Blend between enemy and player based on blend amount
                half4 blendedTex = lerp(enemySample, playerSample, _BlendAmount);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, _BlendAmount);

                // Calculate final color with emission
                half4 finalColor = blendedTex * blendedColor * _EmissionIntensity;

                // Use texture alpha for transparency
                finalColor.a = blendedTex.a * blendedColor.a;

                // Cutout very dark pixels
                clip(finalColor.a - 0.01);

                return half4(finalColor.rgb * finalColor.a, finalColor.a);
            }
            ENDHLSL
        }

        // Screen Space Decal Pass - Alternative rendering path
        Pass
        {
            Name "DecalScreenSpaceProjector"
            Tags { "LightMode" = "DecalScreenSpaceProjector" }

            ZWrite Off
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha, Zero One
            BlendOp Add, Add

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile_instancing
            #pragma target 3.5

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            TEXTURE2D(_EnemyTex);
            SAMPLER(sampler_EnemyTex);
            TEXTURE2D(_PlayerTex);
            SAMPLER(sampler_PlayerTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings Vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.screenPos = ComputeScreenPos(output.positionCS);
                return output;
            }

            half4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float depth = SampleSceneDepth(screenUV);
                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);
                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                float clipValue = 0.5 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                float2 uv = positionOS.xz + 0.5;

                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                half4 blendedTex = lerp(enemySample, playerSample, _BlendAmount);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, _BlendAmount);

                half4 finalColor = blendedTex * blendedColor * _EmissionIntensity;
                finalColor.a = blendedTex.a * blendedColor.a;

                clip(finalColor.a - 0.01);

                return finalColor;
            }
            ENDHLSL
        }

        // DBuffer Pass for Deferred rendering
        Pass
        {
            Name "DBufferProjector"
            Tags { "LightMode" = "DBufferProjector" }

            ZWrite Off
            ZTest LEqual
            Blend 0 SrcAlpha OneMinusSrcAlpha, Zero One
            BlendOp Add

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile_instancing
            #pragma target 3.5
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            TEXTURE2D(_EnemyTex);
            SAMPLER(sampler_EnemyTex);
            TEXTURE2D(_PlayerTex);
            SAMPLER(sampler_PlayerTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings Vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.screenPos = ComputeScreenPos(output.positionCS);
                return output;
            }

            void Frag(Varyings input,
                out half4 outDBuffer0 : SV_Target0
            #if defined(_DBUFFER_MRT2) || defined(_DBUFFER_MRT3)
                , out half4 outDBuffer1 : SV_Target1
            #endif
            #if defined(_DBUFFER_MRT3)
                , out half4 outDBuffer2 : SV_Target2
            #endif
            )
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                float2 screenUV = input.screenPos.xy / input.screenPos.w;
                float depth = SampleSceneDepth(screenUV);
                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);
                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                float clipValue = 0.5 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                float2 uv = positionOS.xz + 0.5;

                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                half4 blendedTex = lerp(enemySample, playerSample, _BlendAmount);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, _BlendAmount);

                half4 finalColor = blendedTex * blendedColor;
                half alpha = blendedTex.a * blendedColor.a;

                clip(alpha - 0.01);

                // Output to DBuffer
                outDBuffer0 = half4(finalColor.rgb, alpha);
            #if defined(_DBUFFER_MRT2) || defined(_DBUFFER_MRT3)
                outDBuffer1 = half4(0.5, 0.5, 1.0, 0.0); // Normal - pointing up, no blend
            #endif
            #if defined(_DBUFFER_MRT3)
                outDBuffer2 = half4(0.0, 0.0, 0.0, 0.0); // MAOS - no metallic/ao/smoothness contribution
            #endif
            }
            ENDHLSL
        }
    }

    CustomEditor "UnityEditor.Rendering.Universal.DecalShaderGraphGUI"
}
