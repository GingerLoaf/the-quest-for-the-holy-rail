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
        _BlacknessThreshold("Blackness Threshold", Range(0, 1)) = 0.1

        [Header(Blend Transition)]
        _NoiseTex("Transition Noise", 2D) = "white" {}
        _NoiseScale("Noise Scale", Range(0.1, 10.0)) = 1.0

        [Header(Edge Glow)]
        [HDR] _EdgeGlowColor("Edge Glow Color", Color) = (1, 0.8, 0, 1)
        _EdgeGlowIntensity("Edge Glow Intensity", Range(0, 5)) = 2.0
        _EdgeThickness("Edge Thickness", Range(0.01, 0.3)) = 0.1

        [Header(Frame Outline)]
        _FrameEnabled("Frame Enabled", Float) = 0
        [HDR] _FrameColor("Frame Color", Color) = (0, 1, 0, 1)
        _FrameWidth("Frame Width", Range(0.01, 0.15)) = 0.04

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
            "RenderType" = "Opaque"
            "Queue" = "Geometry+1"
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
            Cull Back
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
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                float4 _NoiseTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                half _BlacknessThreshold;
                half _NoiseScale;
                half4 _EdgeGlowColor;
                half _EdgeGlowIntensity;
                half _EdgeThickness;
                half _FrameEnabled;
                half4 _FrameColor;
                half _FrameWidth;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            // Procedural noise function (value noise)
            half Hash(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return frac((p3.x + p3.y) * p3.z);
            }

            half ProceduralNoise(float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f); // Smoothstep

                half a = Hash(i);
                half b = Hash(i + float2(1.0, 0.0));
                half c = Hash(i + float2(0.0, 1.0));
                half d = Hash(i + float2(1.0, 1.0));

                return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
            }

            half CalculateFrameMask(float2 uv, half frameWidth)
            {
                float distFromLeft = uv.x;
                float distFromRight = 1.0 - uv.x;
                float distFromBottom = uv.y;
                float distFromTop = 1.0 - uv.y;
                float minDistToEdge = min(min(distFromLeft, distFromRight), min(distFromBottom, distFromTop));
                half frameMask = 1.0 - smoothstep(frameWidth * 0.8, frameWidth, minDistToEdge);
                return frameMask;
            }

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

                // Clip if sampling skybox/far plane (no geometry to project onto)
                #if UNITY_REVERSED_Z
                clip(depth - 0.0001);
                #else
                clip(0.9999 - depth);
                #endif

                // Reconstruct world position from depth
                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);

                // Get decal center in world space and compute distances
                float3 decalCenterWS = TransformObjectToWorld(float3(0, 0, 0));
                float distToSampledSurface = length(positionWS - _WorldSpaceCameraPos);
                float distToDecalCenter = length(decalCenterWS - _WorldSpaceCameraPos);

                // Clip if the sampled surface is significantly closer than the decal center
                // This prevents drawing on objects between the camera and the projection surface
                clip(distToSampledSurface - distToDecalCenter * 0.5);

                // Transform to decal object space
                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                // Clip outside the decal box (with small margin for precision)
                float clipValue = 0.49 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                // Calculate UV from decal projection
                float2 uv = positionOS.xz + 0.5;

                // Sample both textures
                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                // Sample noise for transition mask using procedural noise
                float2 noiseUV = uv * _NoiseScale * 8.0;
                // Multi-octave noise for more interesting pattern
                half noise = ProceduralNoise(noiseUV) * 0.6
                           + ProceduralNoise(noiseUV * 2.0) * 0.3
                           + ProceduralNoise(noiseUV * 4.0) * 0.1;

                // Threshold based on blend amount
                half threshold = _BlendAmount;

                // Create blend mask: where noise < threshold, show player
                half blendMask = 1.0 - smoothstep(threshold - 0.01, threshold + 0.01, noise);

                // Blend textures and colors using noise mask
                half4 blendedTex = lerp(enemySample, playerSample, blendMask);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, blendMask);

                // Edge glow: find pixels near blend boundary
                half distanceToEdge = abs(noise - threshold);
                half edgeMask = 1.0 - smoothstep(0.0, _EdgeThickness, distanceToEdge);

                // Only show edge during active transition (not at 0 or 1)
                half transitionActive = step(0.01, _BlendAmount) * step(_BlendAmount, 0.99);
                edgeMask *= transitionActive;

                // Apply edge glow as additive emission
                half3 edgeGlow = _EdgeGlowColor.rgb * edgeMask * _EdgeGlowIntensity;

                // Calculate final color with emission
                half4 finalColor = blendedTex * blendedColor * _EmissionIntensity;
                finalColor.rgb += edgeGlow;

                // Calculate luminance (brightness) of the blended texture
                half luminance = dot(blendedTex.rgb, half3(0.299, 0.587, 0.114));

                // Treat dark pixels as transparent (alpha cutout)
                half blackMask = step(_BlacknessThreshold, luminance);

                // Apply black mask to alpha
                half baseAlpha = blendedTex.a * blendedColor.a * blackMask;

                // Calculate frame outline
                half frameMask = CalculateFrameMask(uv, _FrameWidth) * _FrameEnabled;
                finalColor.rgb = lerp(finalColor.rgb, _FrameColor.rgb * 2.0, frameMask * _FrameColor.a);
                finalColor.a = max(baseAlpha, frameMask * _FrameColor.a);

                // Edge glow also contributes to alpha
                finalColor.a = max(finalColor.a, edgeMask * _EdgeGlowColor.a);

                // Clip fully transparent pixels
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
            Cull Back
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
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                float4 _NoiseTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                half _BlacknessThreshold;
                half _NoiseScale;
                half4 _EdgeGlowColor;
                half _EdgeGlowIntensity;
                half _EdgeThickness;
                half _FrameEnabled;
                half4 _FrameColor;
                half _FrameWidth;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            // Procedural noise function (value noise)
            half Hash(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return frac((p3.x + p3.y) * p3.z);
            }

            half ProceduralNoise(float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f); // Smoothstep

                half a = Hash(i);
                half b = Hash(i + float2(1.0, 0.0));
                half c = Hash(i + float2(0.0, 1.0));
                half d = Hash(i + float2(1.0, 1.0));

                return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
            }

            half CalculateFrameMask(float2 uv, half frameWidth)
            {
                float distFromLeft = uv.x;
                float distFromRight = 1.0 - uv.x;
                float distFromBottom = uv.y;
                float distFromTop = 1.0 - uv.y;
                float minDistToEdge = min(min(distFromLeft, distFromRight), min(distFromBottom, distFromTop));
                half frameMask = 1.0 - smoothstep(frameWidth * 0.8, frameWidth, minDistToEdge);
                return frameMask;
            }

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

                // Clip if sampling skybox/far plane
                #if UNITY_REVERSED_Z
                clip(depth - 0.0001);
                #else
                clip(0.9999 - depth);
                #endif

                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);

                // Get decal center in world space and compute distances
                float3 decalCenterWS = TransformObjectToWorld(float3(0, 0, 0));
                float distToSampledSurface = length(positionWS - _WorldSpaceCameraPos);
                float distToDecalCenter = length(decalCenterWS - _WorldSpaceCameraPos);

                // Clip if the sampled surface is significantly closer than the decal center
                clip(distToSampledSurface - distToDecalCenter * 0.5);

                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                float clipValue = 0.5 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                float2 uv = positionOS.xz + 0.5;

                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                // Sample noise for transition mask using procedural noise
                float2 noiseUV = uv * _NoiseScale * 8.0;
                // Multi-octave noise for more interesting pattern
                half noise = ProceduralNoise(noiseUV) * 0.6
                           + ProceduralNoise(noiseUV * 2.0) * 0.3
                           + ProceduralNoise(noiseUV * 4.0) * 0.1;

                // Threshold based on blend amount
                half threshold = _BlendAmount;

                // Create blend mask: where noise < threshold, show player
                half blendMask = 1.0 - smoothstep(threshold - 0.01, threshold + 0.01, noise);

                // Blend textures and colors using noise mask
                half4 blendedTex = lerp(enemySample, playerSample, blendMask);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, blendMask);

                // Edge glow: find pixels near blend boundary
                half distanceToEdge = abs(noise - threshold);
                half edgeMask = 1.0 - smoothstep(0.0, _EdgeThickness, distanceToEdge);

                // Only show edge during active transition (not at 0 or 1)
                half transitionActive = step(0.01, _BlendAmount) * step(_BlendAmount, 0.99);
                edgeMask *= transitionActive;

                // Apply edge glow as additive emission
                half3 edgeGlow = _EdgeGlowColor.rgb * edgeMask * _EdgeGlowIntensity;

                // Calculate final color with emission
                half4 finalColor = blendedTex * blendedColor * _EmissionIntensity;
                finalColor.rgb += edgeGlow;

                // Calculate luminance (brightness) of the blended texture
                half luminance = dot(blendedTex.rgb, half3(0.299, 0.587, 0.114));

                // Treat dark pixels as transparent (alpha cutout)
                half blackMask = step(_BlacknessThreshold, luminance);

                // Apply black mask to alpha
                half baseAlpha = blendedTex.a * blendedColor.a * blackMask;

                // Calculate frame outline
                half frameMask = CalculateFrameMask(uv, _FrameWidth) * _FrameEnabled;
                finalColor.rgb = lerp(finalColor.rgb, _FrameColor.rgb * 2.0, frameMask * _FrameColor.a);
                finalColor.a = max(baseAlpha, frameMask * _FrameColor.a);

                // Edge glow also contributes to alpha
                finalColor.a = max(finalColor.a, edgeMask * _EdgeGlowColor.a);

                // Clip fully transparent pixels
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
            Cull Off
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
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _EnemyTex_ST;
                float4 _PlayerTex_ST;
                float4 _NoiseTex_ST;
                half _BlendAmount;
                half4 _EnemyColor;
                half4 _PlayerColor;
                half _EmissionIntensity;
                half _BlacknessThreshold;
                half _NoiseScale;
                half4 _EdgeGlowColor;
                half _EdgeGlowIntensity;
                half _EdgeThickness;
                half _FrameEnabled;
                half4 _FrameColor;
                half _FrameWidth;
                float _DecalMeshDepthBias;
                float _DecalMeshViewBias;
                float _DecalMeshBiasType;
            CBUFFER_END

            // Procedural noise function (value noise)
            half Hash(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * 0.1031);
                p3 += dot(p3, p3.yzx + 33.33);
                return frac((p3.x + p3.y) * p3.z);
            }

            half ProceduralNoise(float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                f = f * f * (3.0 - 2.0 * f); // Smoothstep

                half a = Hash(i);
                half b = Hash(i + float2(1.0, 0.0));
                half c = Hash(i + float2(0.0, 1.0));
                half d = Hash(i + float2(1.0, 1.0));

                return lerp(lerp(a, b, f.x), lerp(c, d, f.x), f.y);
            }

            half CalculateFrameMask(float2 uv, half frameWidth)
            {
                float distFromLeft = uv.x;
                float distFromRight = 1.0 - uv.x;
                float distFromBottom = uv.y;
                float distFromTop = 1.0 - uv.y;
                float minDistToEdge = min(min(distFromLeft, distFromRight), min(distFromBottom, distFromTop));
                half frameMask = 1.0 - smoothstep(frameWidth * 0.8, frameWidth, minDistToEdge);
                return frameMask;
            }

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

                // Clip if sampling skybox/far plane
                #if UNITY_REVERSED_Z
                clip(depth - 0.0001);
                #else
                clip(0.9999 - depth);
                #endif

                float3 positionWS = ComputeWorldSpacePosition(screenUV, depth, UNITY_MATRIX_I_VP);

                // Get decal center in world space and compute distances
                float3 decalCenterWS = TransformObjectToWorld(float3(0, 0, 0));
                float distToSampledSurface = length(positionWS - _WorldSpaceCameraPos);
                float distToDecalCenter = length(decalCenterWS - _WorldSpaceCameraPos);

                // Clip if the sampled surface is significantly closer than the decal center
                clip(distToSampledSurface - distToDecalCenter * 0.5);

                float3 positionOS = TransformWorldToObject(positionWS);
                positionOS = positionOS * float3(1.0, -1.0, 1.0);

                float clipValue = 0.5 - max(max(abs(positionOS.x), abs(positionOS.y)), abs(positionOS.z));
                clip(clipValue);

                float2 uv = positionOS.xz + 0.5;

                half4 enemySample = SAMPLE_TEXTURE2D(_EnemyTex, sampler_EnemyTex, uv * _EnemyTex_ST.xy + _EnemyTex_ST.zw);
                half4 playerSample = SAMPLE_TEXTURE2D(_PlayerTex, sampler_PlayerTex, uv * _PlayerTex_ST.xy + _PlayerTex_ST.zw);

                // Sample noise for transition mask using procedural noise
                float2 noiseUV = uv * _NoiseScale * 8.0;
                // Multi-octave noise for more interesting pattern
                half noise = ProceduralNoise(noiseUV) * 0.6
                           + ProceduralNoise(noiseUV * 2.0) * 0.3
                           + ProceduralNoise(noiseUV * 4.0) * 0.1;

                // Threshold based on blend amount
                half threshold = _BlendAmount;

                // Create blend mask: where noise < threshold, show player
                half blendMask = 1.0 - smoothstep(threshold - 0.01, threshold + 0.01, noise);

                // Blend textures and colors using noise mask
                half4 blendedTex = lerp(enemySample, playerSample, blendMask);
                half4 blendedColor = lerp(_EnemyColor, _PlayerColor, blendMask);

                // Edge glow: find pixels near blend boundary
                half distanceToEdge = abs(noise - threshold);
                half edgeMask = 1.0 - smoothstep(0.0, _EdgeThickness, distanceToEdge);

                // Only show edge during active transition (not at 0 or 1)
                half transitionActive = step(0.01, _BlendAmount) * step(_BlendAmount, 0.99);
                edgeMask *= transitionActive;

                // Apply edge glow as additive emission
                half3 edgeGlow = _EdgeGlowColor.rgb * edgeMask * _EdgeGlowIntensity;

                // Calculate final color
                half4 finalColor = blendedTex * blendedColor;
                finalColor.rgb += edgeGlow;

                // Calculate luminance (brightness) of the blended texture
                half luminance = dot(blendedTex.rgb, half3(0.299, 0.587, 0.114));

                // Treat dark pixels as transparent (alpha cutout)
                half blackMask = step(_BlacknessThreshold, luminance);

                // Apply black mask to alpha
                half baseAlpha = blendedTex.a * blendedColor.a * blackMask;

                // Calculate frame outline
                half frameMask = CalculateFrameMask(uv, _FrameWidth) * _FrameEnabled;
                finalColor.rgb = lerp(finalColor.rgb, _FrameColor.rgb * 2.0, frameMask * _FrameColor.a);
                half alpha = max(baseAlpha, frameMask * _FrameColor.a);

                // Edge glow also contributes to alpha
                alpha = max(alpha, edgeMask * _EdgeGlowColor.a);

                // Clip fully transparent pixels
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
