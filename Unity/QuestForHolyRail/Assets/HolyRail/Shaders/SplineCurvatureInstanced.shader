Shader "HolyRail/SplineCurvatureInstanced"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0.05, 0.02, 0.1, 1)
        _CurvatureGradient ("Curvature Gradient", 2D) = "white" {}
        _CurvatureScale ("Curvature Scale", Float) = 1.0
        _CurvatureBias ("Curvature Bias", Float) = 0.0

        _NoiseFrequency ("Noise Frequency", Float) = 2.0
        _NoiseAmplitude ("Noise Amplitude", Float) = 0.3
        _NoiseScrollSpeed ("Noise Scroll Speed", Float) = 1.0
        _NoiseCurvatureInfluence ("Noise Curvature Influence", Float) = 0.5

        [HDR] _EmissionColor ("Emission Color", Color) = (1, 0.3, 0.1, 1)
        _EmissionIntensity ("Emission Intensity", Float) = 1.0
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

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma instancing_options procedural:ConfigureProcedural

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct RadialCloneData
            {
                float3 Position;
                float4 Rotation;
                float3 Scale;
                int CloneIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<RadialCloneData> _CloneBuffer;
            #endif

            TEXTURE2D(_CurvatureGradient);
            SAMPLER(sampler_CurvatureGradient);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _CurvatureGradient_ST;
                float _CurvatureScale;
                float _CurvatureBias;
                float _NoiseFrequency;
                float _NoiseAmplitude;
                float _NoiseScrollSpeed;
                float _NoiseCurvatureInfluence;
                float4 _EmissionColor;
                float _EmissionIntensity;
            CBUFFER_END

            // Rotate vector by quaternion
            float3 rotateByQuaternion(float3 v, float4 q)
            {
                float3 u = q.xyz;
                float s = q.w;
                return 2.0 * dot(u, v) * u
                     + (s * s - dot(u, u)) * v
                     + 2.0 * s * cross(u, v);
            }

            void ConfigureProcedural()
            {
                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                uint instanceID = unity_InstanceID;
                RadialCloneData clone = _CloneBuffer[instanceID];

                float3 pos = clone.Position;
                float4 rot = clone.Rotation;
                float3 scale = clone.Scale;

                // Create rotation matrix from quaternion with scale
                float3 right = rotateByQuaternion(float3(1, 0, 0), rot) * scale.x;
                float3 up = rotateByQuaternion(float3(0, 1, 0), rot) * scale.y;
                float3 forward = rotateByQuaternion(float3(0, 0, 1), rot) * scale.z;

                unity_ObjectToWorld = float4x4(
                    float4(right.x, up.x, forward.x, pos.x),
                    float4(right.y, up.y, forward.y, pos.y),
                    float4(right.z, up.z, forward.z, pos.z),
                    float4(0, 0, 0, 1)
                );

                // Compute inverse for normals
                float3 invScale = 1.0 / scale;
                float4 invRot = float4(-rot.xyz, rot.w);

                float3 invRight = rotateByQuaternion(float3(1, 0, 0), invRot) * invScale.x;
                float3 invUp = rotateByQuaternion(float3(0, 1, 0), invRot) * invScale.y;
                float3 invForward = rotateByQuaternion(float3(0, 0, 1), invRot) * invScale.z;

                unity_WorldToObject = float4x4(
                    float4(invRight.x, invRight.y, invRight.z, -dot(invRight, pos)),
                    float4(invUp.x, invUp.y, invUp.z, -dot(invUp, pos)),
                    float4(invForward.x, invForward.y, invForward.z, -dot(invForward, pos)),
                    float4(0, 0, 0, 1)
                );
                #endif
            }

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float2 uv : TEXCOORD2;
                float curvature : TEXCOORD3;
                float noise : TEXCOORD4;
                float fogFactor : TEXCOORD5;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            // GPU-efficient simplex noise implementation
            float3 mod289(float3 x)
            {
                return x - floor(x * (1.0 / 289.0)) * 289.0;
            }

            float4 mod289(float4 x)
            {
                return x - floor(x * (1.0 / 289.0)) * 289.0;
            }

            float4 permute(float4 x)
            {
                return mod289(((x * 34.0) + 1.0) * x);
            }

            float4 taylorInvSqrt(float4 r)
            {
                return 1.79284291400159 - 0.85373472095314 * r;
            }

            float SimplexNoise3D(float3 v)
            {
                const float2 C = float2(1.0 / 6.0, 1.0 / 3.0);
                const float4 D = float4(0.0, 0.5, 1.0, 2.0);

                float3 i = floor(v + dot(v, C.yyy));
                float3 x0 = v - i + dot(i, C.xxx);

                float3 g = step(x0.yzx, x0.xyz);
                float3 l = 1.0 - g;
                float3 i1 = min(g.xyz, l.zxy);
                float3 i2 = max(g.xyz, l.zxy);

                float3 x1 = x0 - i1 + C.xxx;
                float3 x2 = x0 - i2 + C.yyy;
                float3 x3 = x0 - D.yyy;

                i = mod289(i);
                float4 p = permute(permute(permute(
                    i.z + float4(0.0, i1.z, i2.z, 1.0))
                    + i.y + float4(0.0, i1.y, i2.y, 1.0))
                    + i.x + float4(0.0, i1.x, i2.x, 1.0));

                float n_ = 0.142857142857;
                float3 ns = n_ * D.wyz - D.xzx;

                float4 j = p - 49.0 * floor(p * ns.z * ns.z);

                float4 x_ = floor(j * ns.z);
                float4 y_ = floor(j - 7.0 * x_);

                float4 x = x_ * ns.x + ns.yyyy;
                float4 y = y_ * ns.x + ns.yyyy;
                float4 h = 1.0 - abs(x) - abs(y);

                float4 b0 = float4(x.xy, y.xy);
                float4 b1 = float4(x.zw, y.zw);

                float4 s0 = floor(b0) * 2.0 + 1.0;
                float4 s1 = floor(b1) * 2.0 + 1.0;
                float4 sh = -step(h, 0.0);

                float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
                float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

                float3 p0 = float3(a0.xy, h.x);
                float3 p1 = float3(a0.zw, h.y);
                float3 p2 = float3(a1.xy, h.z);
                float3 p3 = float3(a1.zw, h.w);

                float4 norm = taylorInvSqrt(float4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
                p0 *= norm.x;
                p1 *= norm.y;
                p2 *= norm.z;
                p3 *= norm.w;

                float4 m = max(0.6 - float4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
                m = m * m;
                return 42.0 * dot(m * m, float4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);

                // Calculate scrolling noise coordinate
                float3 noiseCoord = input.positionOS.xyz * _NoiseFrequency;
                noiseCoord.y += _Time.y * _NoiseScrollSpeed;

                // Sample noise (range -1 to 1)
                float noise = SimplexNoise3D(noiseCoord);

                // Apply vertex displacement along normal
                float3 displacedPos = input.positionOS.xyz + input.normalOS * noise * _NoiseAmplitude * 0.1;

                // Calculate curvature approximation
                float3 posOS = input.positionOS.xyz;
                float posLen = length(posOS);
                float3 toCenter = posLen > 0.0001 ? -posOS / posLen : float3(0, 0, 1);
                float curvature = dot(input.normalOS, toCenter);
                curvature = curvature * _CurvatureScale + _CurvatureBias;

                VertexPositionInputs posInputs = GetVertexPositionInputs(displacedPos);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.normalWS = normInputs.normalWS;
                output.uv = input.uv;
                output.curvature = curvature;
                output.noise = noise;
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);

                // Combine curvature with noise for final gradient lookup
                float combinedCurvature = input.curvature + input.noise * _NoiseCurvatureInfluence;

                // Map to 0-1 range for gradient sampling
                float gradientU = saturate(combinedCurvature * 0.5 + 0.5);

                // Sample gradient
                float2 gradientUV = float2(gradientU, 0.5);
                half4 gradientColor = SAMPLE_TEXTURE2D(_CurvatureGradient, sampler_CurvatureGradient, gradientUV);

                // Combine base color with gradient
                half3 color = lerp(_BaseColor.rgb, gradientColor.rgb, gradientColor.a);

                // Add emission based on curvature intensity and noise
                float emissionStrength = abs(combinedCurvature) * (0.5 + abs(input.noise) * 0.5);
                half3 emission = gradientColor.rgb * _EmissionColor.rgb * _EmissionIntensity * emissionStrength;
                color += emission;

                // Apply fog
                color = MixFog(color, input.fogFactor);

                return half4(color, 1.0);
            }
            ENDHLSL
        }

        // Shadow caster pass
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
            #pragma multi_compile_instancing
            #pragma instancing_options procedural:ConfigureProcedural

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

            struct RadialCloneData
            {
                float3 Position;
                float4 Rotation;
                float3 Scale;
                int CloneIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<RadialCloneData> _CloneBuffer;
            #endif

            float3 _LightDirection;

            float3 rotateByQuaternion(float3 v, float4 q)
            {
                float3 u = q.xyz;
                float s = q.w;
                return 2.0 * dot(u, v) * u
                     + (s * s - dot(u, u)) * v
                     + 2.0 * s * cross(u, v);
            }

            void ConfigureProcedural()
            {
                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                uint instanceID = unity_InstanceID;
                RadialCloneData clone = _CloneBuffer[instanceID];

                float3 pos = clone.Position;
                float4 rot = clone.Rotation;
                float3 scale = clone.Scale;

                float3 right = rotateByQuaternion(float3(1, 0, 0), rot) * scale.x;
                float3 up = rotateByQuaternion(float3(0, 1, 0), rot) * scale.y;
                float3 forward = rotateByQuaternion(float3(0, 0, 1), rot) * scale.z;

                unity_ObjectToWorld = float4x4(
                    float4(right.x, up.x, forward.x, pos.x),
                    float4(right.y, up.y, forward.y, pos.y),
                    float4(right.z, up.z, forward.z, pos.z),
                    float4(0, 0, 0, 1)
                );

                float3 invScale = 1.0 / scale;
                float4 invRot = float4(-rot.xyz, rot.w);

                float3 invRight = rotateByQuaternion(float3(1, 0, 0), invRot) * invScale.x;
                float3 invUp = rotateByQuaternion(float3(0, 1, 0), invRot) * invScale.y;
                float3 invForward = rotateByQuaternion(float3(0, 0, 1), invRot) * invScale.z;

                unity_WorldToObject = float4x4(
                    float4(invRight.x, invRight.y, invRight.z, -dot(invRight, pos)),
                    float4(invUp.x, invUp.y, invUp.z, -dot(invUp, pos)),
                    float4(invForward.x, invForward.y, invForward.z, -dot(invForward, pos)),
                    float4(0, 0, 0, 1)
                );
                #endif
            }

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            float4 GetShadowPositionHClip(Attributes input)
            {
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

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
                UNITY_SETUP_INSTANCE_ID(input);

                output.positionCS = GetShadowPositionHClip(input);
                return output;
            }

            half4 ShadowPassFragment(Varyings input) : SV_TARGET
            {
                return 0;
            }
            ENDHLSL
        }

        // Depth only pass for depth prepass
        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }

            ZWrite On
            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment
            #pragma multi_compile_instancing
            #pragma instancing_options procedural:ConfigureProcedural

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct RadialCloneData
            {
                float3 Position;
                float4 Rotation;
                float3 Scale;
                int CloneIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<RadialCloneData> _CloneBuffer;
            #endif

            float3 rotateByQuaternion(float3 v, float4 q)
            {
                float3 u = q.xyz;
                float s = q.w;
                return 2.0 * dot(u, v) * u
                     + (s * s - dot(u, u)) * v
                     + 2.0 * s * cross(u, v);
            }

            void ConfigureProcedural()
            {
                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                uint instanceID = unity_InstanceID;
                RadialCloneData clone = _CloneBuffer[instanceID];

                float3 pos = clone.Position;
                float4 rot = clone.Rotation;
                float3 scale = clone.Scale;

                float3 right = rotateByQuaternion(float3(1, 0, 0), rot) * scale.x;
                float3 up = rotateByQuaternion(float3(0, 1, 0), rot) * scale.y;
                float3 forward = rotateByQuaternion(float3(0, 0, 1), rot) * scale.z;

                unity_ObjectToWorld = float4x4(
                    float4(right.x, up.x, forward.x, pos.x),
                    float4(right.y, up.y, forward.y, pos.y),
                    float4(right.z, up.z, forward.z, pos.z),
                    float4(0, 0, 0, 1)
                );

                float3 invScale = 1.0 / scale;
                float4 invRot = float4(-rot.xyz, rot.w);

                float3 invRight = rotateByQuaternion(float3(1, 0, 0), invRot) * invScale.x;
                float3 invUp = rotateByQuaternion(float3(0, 1, 0), invRot) * invScale.y;
                float3 invForward = rotateByQuaternion(float3(0, 0, 1), invRot) * invScale.z;

                unity_WorldToObject = float4x4(
                    float4(invRight.x, invRight.y, invRight.z, -dot(invRight, pos)),
                    float4(invUp.x, invUp.y, invUp.z, -dot(invUp, pos)),
                    float4(invForward.x, invForward.y, invForward.z, -dot(invForward, pos)),
                    float4(0, 0, 0, 1)
                );
                #endif
            }

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            Varyings DepthOnlyVertex(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);

                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                return output;
            }

            half4 DepthOnlyFragment(Varyings input) : SV_TARGET
            {
                return 0;
            }
            ENDHLSL
        }

        // DepthNormals pass for DBuffer decals
        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }

            ZWrite On
            Cull Back

            HLSLPROGRAM
            #pragma vertex DepthNormalsVertex
            #pragma fragment DepthNormalsFragment
            #pragma multi_compile_instancing
            #pragma instancing_options procedural:ConfigureProcedural

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct RadialCloneData
            {
                float3 Position;
                float4 Rotation;
                float3 Scale;
                int CloneIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<RadialCloneData> _CloneBuffer;
            #endif

            float3 rotateByQuaternion(float3 v, float4 q)
            {
                float3 u = q.xyz;
                float s = q.w;
                return 2.0 * dot(u, v) * u
                     + (s * s - dot(u, u)) * v
                     + 2.0 * s * cross(u, v);
            }

            void ConfigureProcedural()
            {
                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                uint instanceID = unity_InstanceID;
                RadialCloneData clone = _CloneBuffer[instanceID];

                float3 pos = clone.Position;
                float4 rot = clone.Rotation;
                float3 scale = clone.Scale;

                float3 right = rotateByQuaternion(float3(1, 0, 0), rot) * scale.x;
                float3 up = rotateByQuaternion(float3(0, 1, 0), rot) * scale.y;
                float3 forward = rotateByQuaternion(float3(0, 0, 1), rot) * scale.z;

                unity_ObjectToWorld = float4x4(
                    float4(right.x, up.x, forward.x, pos.x),
                    float4(right.y, up.y, forward.y, pos.y),
                    float4(right.z, up.z, forward.z, pos.z),
                    float4(0, 0, 0, 1)
                );

                float3 invScale = 1.0 / scale;
                float4 invRot = float4(-rot.xyz, rot.w);

                float3 invRight = rotateByQuaternion(float3(1, 0, 0), invRot) * invScale.x;
                float3 invUp = rotateByQuaternion(float3(0, 1, 0), invRot) * invScale.y;
                float3 invForward = rotateByQuaternion(float3(0, 0, 1), invRot) * invScale.z;

                unity_WorldToObject = float4x4(
                    float4(invRight.x, invRight.y, invRight.z, -dot(invRight, pos)),
                    float4(invUp.x, invUp.y, invUp.z, -dot(invUp, pos)),
                    float4(invForward.x, invForward.y, invForward.z, -dot(invForward, pos)),
                    float4(0, 0, 0, 1)
                );
                #endif
            }

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS : TEXCOORD0;
            };

            Varyings DepthNormalsVertex(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);

                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                return output;
            }

            half4 DepthNormalsFragment(Varyings input) : SV_TARGET
            {
                float3 normalWS = normalize(input.normalWS);
                return half4(normalWS * 0.5 + 0.5, 0);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
