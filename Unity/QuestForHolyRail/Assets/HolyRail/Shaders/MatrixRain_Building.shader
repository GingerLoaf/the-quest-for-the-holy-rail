Shader "HolyRail/MatrixRain_Building"
{
    Properties
    {
        _CharTex ("Character Atlas", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        [HDR] _CharColor ("Character Color", Color) = (0.1, 1.0, 0.35, 1.0)
        _BackgroundColor ("Background Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _Speed ("Animation Speed", Range(0.1, 5.0)) = 1.0
        _Scale ("Character Scale", Range(0.5, 4.0)) = 1.0
        _Brightness ("Brightness", Range(0.1, 3.0)) = 1.0
        _TrailLength ("Trail Length", Range(0.1, 1.0)) = 0.5
        _CharChangeSpeed ("Character Change Speed", Range(0.5, 10.0)) = 3.0
        _TriplanarSharpness ("Triplanar Sharpness", Range(1, 10)) = 4
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
            #pragma multi_compile_instancing
            #pragma instancing_options procedural:ConfigureProcedural
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int NeedsCollider;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            TEXTURE2D(_CharTex);
            SAMPLER(sampler_CharTex);
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _CharTex_ST;
                float4 _NoiseTex_ST;
                float4 _CharColor;
                float4 _BackgroundColor;
                float _Speed;
                float _Scale;
                float _Brightness;
                float _TrailLength;
                float _CharChangeSpeed;
                float _TriplanarSharpness;
                float3 _HalfAOffset;
                float3 _HalfBOffset;
                int _HalfBStartIndex;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float fogFactor : TEXCOORD2;
            };

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
                BuildingData building = _BuildingBuffer[instanceID];

                float3 pos = building.Position;
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = building.Scale;
                float4 rot = building.Rotation;

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

            // Custom mod function that handles negative numbers correctly
            float2 mod2(float2 x, float2 y)
            {
                return x - y * floor(x / y);
            }

            float mod1(float x, float y)
            {
                return x - y * floor(x / y);
            }

            // Text layer - returns character mask value
            float Text(float2 fragCoord)
            {
                fragCoord /= _Scale;
                float2 uv = mod2(fragCoord, float2(16.0, 16.0)) * 0.0625;
                float2 block = fragCoord * 0.0625 - uv;
                uv = uv * 0.8 + 0.1;
                float2 noiseUV = block * 0.01 + _Time.y * _CharChangeSpeed * 0.002;
                float4 noiseSample = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, noiseUV);
                uv += floor(noiseSample.xy * 16.0);
                uv *= 0.0625;
                uv.x = -uv.x;
                return SAMPLE_TEXTURE2D(_CharTex, sampler_CharTex, uv).r;
            }

            // Rain effect - creates vertical falling trails
            float3 Rain(float2 fragCoord, float2 resolution)
            {
                fragCoord /= _Scale;
                fragCoord.x -= mod1(fragCoord.x, 16.0);
                float offset = sin(fragCoord.x * 15.0);
                float speed = cos(fragCoord.x * 3.0) * 0.3 + 0.7;
                float y = frac(fragCoord.y / (resolution.y / _Scale) + _Time.y * _Speed * speed + offset);
                float divisor = y * 20.0 * (2.0 - _TrailLength) + 0.05;
                float intensity = 1.0 / divisor;
                return _CharColor.rgb * intensity * _Brightness;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);

                VertexPositionInputs posInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normInputs = GetVertexNormalInputs(input.normalOS);

                output.positionCS = posInputs.positionCS;
                output.positionWS = posInputs.positionWS;
                output.normalWS = normInputs.normalWS;
                output.fogFactor = ComputeFogFactor(posInputs.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                float3 worldPos = input.positionWS;
                float3 normal = normalize(input.normalWS);
                float2 resolution = float2(512.0, 512.0);

                // Triplanar blend weights
                float3 blend = pow(abs(normal), _TriplanarSharpness);
                blend /= (blend.x + blend.y + blend.z);

                // World-space UVs for each plane
                float2 uvXY = worldPos.xy * 32.0;
                float2 uvXZ = worldPos.xz * 32.0;
                float2 uvYZ = worldPos.yz * 32.0;

                // Sample text and rain on each plane
                float textXY = Text(uvXY);
                float textXZ = Text(uvXZ);
                float textYZ = Text(uvYZ);

                float3 rainXY = Rain(uvXY, resolution);
                float3 rainXZ = Rain(uvXZ, resolution);
                float3 rainYZ = Rain(uvYZ, resolution);

                // Blend based on normal
                float textMask = textXY * blend.z + textXZ * blend.y + textYZ * blend.x;
                float3 rainColor = rainXY * blend.z + rainXZ * blend.y + rainYZ * blend.x;

                half3 color = textMask * rainColor;
                color = max(color, _BackgroundColor.rgb);

                half4 finalColor = half4(color, 1.0);
                finalColor.rgb = MixFog(finalColor.rgb, input.fogFactor);

                return finalColor;
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

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int NeedsCollider;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            float3 _LightDirection;
            float3 _HalfAOffset;
            float3 _HalfBOffset;
            int _HalfBStartIndex;

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
                BuildingData building = _BuildingBuffer[instanceID];

                float3 pos = building.Position;
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = building.Scale;
                float4 rot = building.Rotation;

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

        // Depth only pass
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

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int NeedsCollider;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            float3 _HalfAOffset;
            float3 _HalfBOffset;
            int _HalfBStartIndex;

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
                BuildingData building = _BuildingBuffer[instanceID];

                float3 pos = building.Position;
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = building.Scale;
                float4 rot = building.Rotation;

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

        // DepthNormals pass
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

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int NeedsCollider;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            float3 _HalfAOffset;
            float3 _HalfBOffset;
            int _HalfBStartIndex;

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
                BuildingData building = _BuildingBuffer[instanceID];

                float3 pos = building.Position;
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = building.Scale;
                float4 rot = building.Rotation;

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

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
