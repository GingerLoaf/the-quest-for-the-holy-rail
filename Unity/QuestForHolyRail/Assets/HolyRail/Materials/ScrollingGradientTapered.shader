Shader "HolyRail/ScrollingGradientTapered"
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

        [Header(Fog)]
        _FogInfluence ("Fog Influence", Range(0, 1)) = 1.0

        [Header(Vertex Tapering)]
        _Radius ("Tube Radius", Float) = 0.1
        _SplineLength ("Spline Length", Float) = 10.0
        _EndTaperDistance ("End Taper Distance", Float) = 0.5
        _DistanceTaperStrength ("Distance Taper Strength", Range(0, 1)) = 0.0
        _DistanceFromRoot ("Distance From Root (normalized)", Range(0, 1)) = 0.0
        _DistanceFromRootStart ("Distance From Root Start", Range(0, 1)) = 0.0
        _DistanceFromRootEnd ("Distance From Root End", Range(0, 1)) = 0.0
        _IsBranchMesh ("Is Branch Mesh", Float) = 0.0
        _StartTaperT ("Start Taper T", Float) = 0.0

        [Header(Distance Culling)]
        _CullDistance ("Cull Distance", Float) = 100.0
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
                float2 uv2 : TEXCOORD1;  // Spline t in x (0-1 along spline)
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;  // Spline t
                half fogFactor : TEXCOORD2;
                float3 normalWS : TEXCOORD3;
                float3 viewDirWS : TEXCOORD4;
                float3 positionWS : TEXCOORD5;
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
                // Fog
                half _FogInfluence;
                // Tapering properties
                float _Radius;
                float _SplineLength;
                float _EndTaperDistance;
                float _DistanceTaperStrength;
                float _DistanceFromRoot;
                float _DistanceFromRootStart;
                float _DistanceFromRootEnd;
                float _IsBranchMesh;
                float _StartTaperT;
                // Distance culling
                float _CullDistance;
            CBUFFER_END

            // Calculate taper factor based on position along spline
            // Uses UV2.x for direct spline t (0-1) passed from vertex data
            float CalculateTaper(float2 uv, float2 uv2)
            {
                float taper = 1.0;

                // UV2.x contains direct spline t (0-1) from vertex data
                float splineT = uv2.x;

                // END tapering - taper to point at end of spline
                if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                {
                    float endTaperStartT = max(0.0, 1.0 - _EndTaperDistance / _SplineLength);
                    if (splineT >= endTaperStartT && endTaperStartT < 1.0)
                    {
                        float endFraction = (splineT - endTaperStartT) / (1.0 - endTaperStartT);
                        // Smoothstep for natural tapering
                        endFraction = endFraction * endFraction * (3.0 - 2.0 * endFraction);
                        taper *= (1.0 - endFraction);
                    }
                }

                // START tapering - different for trunk vs branch
                if (_IsBranchMesh > 0.5)
                {
                    // BRANCH: Taper from 0 at spline start to full radius at _StartTaperT
                    // _StartTaperT is the normalized t where the overlap ends (branch emerges)
                    if (_StartTaperT > 0.0 && splineT < _StartTaperT)
                    {
                        float startFraction = splineT / _StartTaperT;
                        startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                        taper *= startFraction;
                    }
                }
                else
                {
                    // TRUNK: Normal start taper (if enabled)
                    if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                    {
                        float startTaperEndT = min(1.0, _EndTaperDistance / _SplineLength);
                        if (splineT <= startTaperEndT && startTaperEndT > 0.0)
                        {
                            float startFraction = splineT / startTaperEndT;
                            // Smoothstep for natural tapering
                            startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                            taper *= startFraction;
                        }
                    }
                }

                // Distance-from-root tapering - branches further from root are thinner
                // Interpolate between start and end distances based on position along spline
                if (_DistanceTaperStrength > 0.0)
                {
                    // Use new start/end values if set (non-zero end), otherwise fall back to legacy uniform value
                    float distanceFromRoot = (_DistanceFromRootEnd > 0.0 || _DistanceFromRootStart > 0.0)
                        ? lerp(_DistanceFromRootStart, _DistanceFromRootEnd, splineT)
                        : _DistanceFromRoot;
                    taper *= lerp(1.0, 1.0 - _DistanceTaperStrength, distanceFromRoot);
                }

                // Clamp to prevent fully collapsed geometry
                return max(taper, 0.001);
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                // Calculate taper factor using UV2.x for direct spline t
                float taperFactor = CalculateTaper(input.uv, input.uv2);

                // Apply taper by moving vertex toward spline center along negative normal
                // Original vertex = center + normal * radius
                // Tapered vertex = center + normal * radius * taperFactor
                // So: newVertex = vertex - normal * radius * (1 - taperFactor)
                float3 taperOffset = input.normalOS * _Radius * (1.0 - taperFactor);
                float3 taperedPosOS = input.positionOS.xyz - taperOffset;

                VertexPositionInputs posInputs = GetVertexPositionInputs(taperedPosOS);
                output.positionCS = posInputs.positionCS;
                output.uv = input.uv;
                output.uv2 = input.uv2;
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.viewDirWS = GetWorldSpaceViewDir(posInputs.positionWS);
                output.positionWS = posInputs.positionWS;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Distance culling
                float distanceToCamera = length(input.positionWS - _WorldSpaceCameraPos);
                clip(_CullDistance - distanceToCamera);

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

                 // Apply fog with influence control (0 = no fog, 1 = full fog)
                half3 foggedColor = MixFog(finalColor, input.fogFactor);
                finalColor = lerp(finalColor, foggedColor, _FogInfluence);

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
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;  // Spline t in x (0-1 along spline)
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
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
                half _FogInfluence;
                float _Radius;
                float _SplineLength;
                float _EndTaperDistance;
                float _DistanceTaperStrength;
                float _DistanceFromRoot;
                float _DistanceFromRootStart;
                float _DistanceFromRootEnd;
                float _IsBranchMesh;
                float _StartTaperT;
                float _CullDistance;
            CBUFFER_END

            float3 _LightDirection;
            float3 _LightPosition;

            float CalculateTaperShadow(float2 uv, float2 uv2)
            {
                float taper = 1.0;
                // UV2.x contains direct spline t (0-1) from vertex data
                float splineT = uv2.x;

                // END tapering
                if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                {
                    float endTaperStartT = max(0.0, 1.0 - _EndTaperDistance / _SplineLength);
                    if (splineT >= endTaperStartT && endTaperStartT < 1.0)
                    {
                        float endFraction = (splineT - endTaperStartT) / (1.0 - endTaperStartT);
                        endFraction = endFraction * endFraction * (3.0 - 2.0 * endFraction);
                        taper *= (1.0 - endFraction);
                    }
                }

                // START tapering - different for trunk vs branch
                if (_IsBranchMesh > 0.5)
                {
                    // BRANCH: Taper from 0 at spline start to full radius at _StartTaperT
                    if (_StartTaperT > 0.0 && splineT < _StartTaperT)
                    {
                        float startFraction = splineT / _StartTaperT;
                        startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                        taper *= startFraction;
                    }
                }
                else
                {
                    // TRUNK: Normal start taper
                    if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                    {
                        float startTaperEndT = min(1.0, _EndTaperDistance / _SplineLength);
                        if (splineT <= startTaperEndT && startTaperEndT > 0.0)
                        {
                            float startFraction = splineT / startTaperEndT;
                            startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                            taper *= startFraction;
                        }
                    }
                }

                if (_DistanceTaperStrength > 0.0)
                {
                    float distanceFromRoot = (_DistanceFromRootEnd > 0.0 || _DistanceFromRootStart > 0.0)
                        ? lerp(_DistanceFromRootStart, _DistanceFromRootEnd, splineT)
                        : _DistanceFromRoot;
                    taper *= lerp(1.0, 1.0 - _DistanceTaperStrength, distanceFromRoot);
                }

                return max(taper, 0.001);
            }

            float4 GetShadowPositionHClip(Attributes input)
            {
                // Apply taper using UV2.x for direct spline t
                float taperFactor = CalculateTaperShadow(input.uv, input.uv2);
                float3 taperOffset = input.normalOS * _Radius * (1.0 - taperFactor);
                float3 taperedPosOS = input.positionOS.xyz - taperOffset;

                float3 positionWS = TransformObjectToWorld(taperedPosOS);
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

                // Compute tapered world position for distance culling
                float taperFactor = CalculateTaperShadow(input.uv, input.uv2);
                float3 taperOffset = input.normalOS * _Radius * (1.0 - taperFactor);
                float3 taperedPosOS = input.positionOS.xyz - taperOffset;
                output.positionWS = TransformObjectToWorld(taperedPosOS);
                return output;
            }

            half4 ShadowPassFragment(Varyings input) : SV_TARGET
            {
                // Distance culling
                float distanceToCamera = length(input.positionWS - _WorldSpaceCameraPos);
                clip(_CullDistance - distanceToCamera);

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
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;  // Spline t in x (0-1 along spline)
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
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
                half _FogInfluence;
                float _Radius;
                float _SplineLength;
                float _EndTaperDistance;
                float _DistanceTaperStrength;
                float _DistanceFromRoot;
                float _DistanceFromRootStart;
                float _DistanceFromRootEnd;
                float _IsBranchMesh;
                float _StartTaperT;
                float _CullDistance;
            CBUFFER_END

            float CalculateTaperDepth(float2 uv, float2 uv2)
            {
                float taper = 1.0;
                // UV2.x contains direct spline t (0-1) from vertex data
                float splineT = uv2.x;

                // END tapering
                if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                {
                    float endTaperStartT = max(0.0, 1.0 - _EndTaperDistance / _SplineLength);
                    if (splineT >= endTaperStartT && endTaperStartT < 1.0)
                    {
                        float endFraction = (splineT - endTaperStartT) / (1.0 - endTaperStartT);
                        endFraction = endFraction * endFraction * (3.0 - 2.0 * endFraction);
                        taper *= (1.0 - endFraction);
                    }
                }

                // START tapering - different for trunk vs branch
                if (_IsBranchMesh > 0.5)
                {
                    // BRANCH: Taper from 0 at spline start to full radius at _StartTaperT
                    if (_StartTaperT > 0.0 && splineT < _StartTaperT)
                    {
                        float startFraction = splineT / _StartTaperT;
                        startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                        taper *= startFraction;
                    }
                }
                else
                {
                    // TRUNK: Normal start taper
                    if (_EndTaperDistance > 0.0 && _SplineLength > 0.0)
                    {
                        float startTaperEndT = min(1.0, _EndTaperDistance / _SplineLength);
                        if (splineT <= startTaperEndT && startTaperEndT > 0.0)
                        {
                            float startFraction = splineT / startTaperEndT;
                            startFraction = startFraction * startFraction * (3.0 - 2.0 * startFraction);
                            taper *= startFraction;
                        }
                    }
                }

                if (_DistanceTaperStrength > 0.0)
                {
                    float distanceFromRoot = (_DistanceFromRootEnd > 0.0 || _DistanceFromRootStart > 0.0)
                        ? lerp(_DistanceFromRootStart, _DistanceFromRootEnd, splineT)
                        : _DistanceFromRoot;
                    taper *= lerp(1.0, 1.0 - _DistanceTaperStrength, distanceFromRoot);
                }

                return max(taper, 0.001);
            }

            Varyings DepthOnlyVertex(Attributes input)
            {
                Varyings output;

                // Apply taper using UV2.x for direct spline t
                float taperFactor = CalculateTaperDepth(input.uv, input.uv2);
                float3 taperOffset = input.normalOS * _Radius * (1.0 - taperFactor);
                float3 taperedPosOS = input.positionOS.xyz - taperOffset;

                output.positionCS = TransformObjectToHClip(taperedPosOS);
                output.positionWS = TransformObjectToWorld(taperedPosOS);
                return output;
            }

            half DepthOnlyFragment(Varyings input) : SV_TARGET
            {
                // Distance culling
                float distanceToCamera = length(input.positionWS - _WorldSpaceCameraPos);
                clip(_CullDistance - distanceToCamera);

                return input.positionCS.z;
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Unlit"
}
