Shader "HolyRail/ScrollingGradient"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0, 0, 0, 1)
        _BaseBrightness ("Base Brightness", Float) = .25
        _GradientColor ("Gradient Color", Color) = (0, 1, 1, 1)
        _ScrollSpeed ("Scroll Speed", Float) = 1.0
        _Frequency ("Frequency", Float) = 2.0
        _Power ("Power", Float) = 2.0
        _EmissionIntensity ("Emission Intensity", Float) = 2.0
        _EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
        _EdgeAmount ("Edge Amount", Range(0, 1)) = 1.0
        _EdgePower ("Edge Power", Float) = 2.0
        _GlowLocation ("Spline Location", Float) = 0.0
        _GlowLength ("Glow Length", Float) = 2.0
        [HDR] _UniformGlowColor ("Uniform Glow Color", Color) = (0,0,0,0)


        [Header(Texture)]
        _MainTex ("Texture", 2D) = "white" {}
        _TexTiling ("Texture Tiling (X, Y)", Vector) = (1, 1, 0, 0)
        _TexScrollSpeed ("Texture Scroll Speed (X, Y)", Vector) = (0, 0, 0, 0)
        _TexRotation ("Texture Rotation (Degrees)", Float) = 0.0
        _TexBlend ("Texture Blend", Range(0, 1)) = 0.0
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

            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

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
                half fogFactor : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 viewDirWS : TEXCOORD3;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                half _BaseBrightness;
                half4 _GradientColor;
                half _ScrollSpeed;
                half _Frequency;
                half _Power;
                half _EmissionIntensity;
                half4 _EdgeColor;
                half _EdgeAmount;
                half _EdgePower;
                float4 _MainTex_ST;
                float4 _TexTiling;
                float4 _TexScrollSpeed;
                half _TexRotation;
                half _TexBlend;
                half _GlowLocation;
                half _GlowLength;
                half _GlowFlip;
                half _GlowMix;
                half _GlowBrightness;
                half3 _UniformGlowColor;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = posInputs.positionCS;
                output.uv = input.uv;
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.viewDirWS = GetWorldSpaceViewDir(posInputs.positionWS);
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half2 uv = input.uv;

                // Scrolling gradient on V axis
                half v = uv.y * _Frequency + _Time.y * _ScrollSpeed;
                v = frac(v);

                // Triangle wave: 0->1->0
                half triWave = abs(v - 0.5h) * 2.0h;
                triWave = 1.0h - triWave;
                triWave = pow(max(triWave, 0.001h), _Power);

                // Gradient color
                half3 gradientResult = triWave * _GradientColor.rgb;
                half3 baseResult = gradientResult + _BaseColor.rgb;

                // Sample texture with tiling, scrolling, and rotation
                float2 texUV = uv * _TexTiling.xy + _Time.y * _TexScrollSpeed.xy;

                // Rotate UVs around center (0.5, 0.5)
                float rotRad = _TexRotation * 0.0174533h; // degrees to radians
                float cosRot = cos(rotRad);
                float sinRot = sin(rotRad);
                float2 centeredUV = texUV - 0.5h;
                texUV.x = centeredUV.x * cosRot - centeredUV.y * sinRot + 0.5h;
                texUV.y = centeredUV.x * sinRot + centeredUV.y * cosRot + 0.5h;

                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, texUV);

                // Blend texture with gradient result
                half3 blendedResult = lerp(baseResult, baseResult * texColor.rgb, _TexBlend);

                // Apply emission intensity
                half3 emissionColor = blendedResult * _EmissionIntensity;

                // Fresnel-based edge darkening (view-dependent)
                half3 normalWS = normalize(input.normalWS);
                half3 viewDirWS = normalize(input.viewDirWS);
                half NdotV = saturate(dot(normalWS, viewDirWS));
                half fresnel = 1.0h - NdotV; // 0 at center, 1 at edges
                half edgeFactor = pow(fresnel, _EdgePower) * _EdgeAmount;
                edgeFactor = saturate(edgeFactor);

                // Lerp from emission color to edge color based on edge factor
                half3 baseColor = lerp(emissionColor, _EdgeColor.rgb, edgeFactor);

               

                // Linear fade: normal goes from _GlowLocation down, flipped goes from _GlowLocation up
                half t = uv.y;
                half dist = lerp(_GlowLocation - t, t - _GlowLocation, _GlowFlip);
                half glow = saturate(1.0 - dist / _GlowLength);
                glow *= step(0.0, dist);

                glow *= _GlowBrightness;
                glow *= _GlowMix;

                half3 finalColor = baseColor * _BaseBrightness + baseColor * glow + _UniformGlowColor * glow;

                 // Apply fog
                finalColor = MixFog(finalColor, input.fogFactor);

                return half4(finalColor, 1.0h);
            }
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

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
            float3 _LightPosition;

            float4 GetShadowPositionHClip(Attributes input)
            {
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

                #if _CASTING_PUNCTUAL_LIGHT_SHADOW
                    float3 lightDirectionWS = normalize(_LightPosition - positionWS);
                #else
                    float3 lightDirectionWS = _LightDirection;
                #endif

                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

                #if UNITY_REVERSED_Z
                    positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                    positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif

                return positionCS;
            }

            Varyings ShadowPassVertex(Attributes input)
            {
                Varyings output;
                output.positionCS = GetShadowPositionHClip(input);
                return output;
            }

            half4 ShadowPassFragment(Varyings input) : SV_TARGET
            {
                return 0;
            }
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }

            ZWrite On
            ColorMask R
            Cull Back

            HLSLPROGRAM
            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            Varyings DepthOnlyVertex(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                return output;
            }

            half DepthOnlyFragment(Varyings input) : SV_TARGET
            {
                return input.positionCS.z;
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Unlit"
}
