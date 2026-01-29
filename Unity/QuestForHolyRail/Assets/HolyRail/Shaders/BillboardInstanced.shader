Shader "HolyRail/BillboardInstanced"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1.0, 0.6, 0.1, 1)
        _ColorVariation ("Color Variation", Range(0, 0.2)) = 0.05
        _EmissionColor ("Emission Color", Color) = (1.0, 0.6, 0.1, 1)
        _EmissionIntensity ("Emission Intensity", Range(0, 5)) = 1.5
        _TextureArray ("Texture Array", 2DArray) = "" {}
        _TextureCount ("Texture Count", Float) = 1
        _UseTextures ("Use Textures", Float) = 0
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
            #pragma require 2darray

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct BillboardData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                float3 Normal;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BillboardData> _BillboardBuffer;
            #endif

            TEXTURE2D_ARRAY(_TextureArray);
            SAMPLER(sampler_TextureArray);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float _ColorVariation;
                float4 _EmissionColor;
                float _EmissionIntensity;
                float _TextureCount;
                float _UseTextures;
                float3 _HalfAOffset;
                float3 _HalfBOffset;
                int _HalfBStartIndex;
            CBUFFER_END

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
                float3 normalWS : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                nointerpolation uint instanceID : TEXCOORD2;
                float fogCoord : TEXCOORD3;
                float2 uv : TEXCOORD4;
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
                BillboardData billboard = _BillboardBuffer[instanceID];

                // Build object-to-world matrix from position, rotation, scale
                float3 pos = billboard.Position;
                // Apply per-half offset for loop mode leapfrog
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = billboard.Scale;
                float4 rot = billboard.Rotation;

                // Create rotation matrix from quaternion
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
                float4 invRot = float4(-rot.xyz, rot.w); // Conjugate for inverse

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

            Varyings vert(Attributes input)
            {
                Varyings output;
                UNITY_SETUP_INSTANCE_ID(input);

                #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
                output.instanceID = unity_InstanceID;
                #else
                output.instanceID = 0;
                #endif

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);

                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.normalWS = normalInput.normalWS;
                output.fogCoord = ComputeFogFactor(vertexInput.positionCS.z);

                // Generate UVs from object space position (works for a cube mesh)
                // Front face: use X and Y
                output.uv = input.uv;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Hash for randomization
                float hash = frac(sin(input.instanceID * 12.9898) * 43758.5453);

                half3 baseColor = _BaseColor.rgb;

                // Sample texture if enabled
                if (_UseTextures > 0.5 && _TextureCount > 0)
                {
                    // Pick texture index based on instance ID
                    uint texIndex = uint(input.instanceID * 7 + 3) % uint(_TextureCount);
                    half4 texColor = SAMPLE_TEXTURE2D_ARRAY(_TextureArray, sampler_TextureArray, input.uv, texIndex);
                    baseColor = texColor.rgb;
                }
                else
                {
                    // Fallback: color variation per instance
                    baseColor = _BaseColor.rgb + (hash - 0.5) * _ColorVariation * 2.0;
                }

                // Simple lighting
                Light mainLight = GetMainLight();
                half NdotL = saturate(dot(input.normalWS, mainLight.direction));
                half3 ambient = half3(0.2, 0.2, 0.25);

                half3 diffuse = baseColor * (ambient + mainLight.color * NdotL * 0.8);

                // Emissive glow (tinted by texture color if using textures)
                half3 emission = _EmissionColor.rgb * _EmissionIntensity;
                if (_UseTextures > 0.5)
                {
                    emission *= baseColor; // Tint emission by texture
                }

                half3 finalColor = diffuse + emission;

                // Apply fog
                finalColor = MixFog(finalColor, input.fogCoord);

                return half4(finalColor, 1);
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

            struct BillboardData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                float3 Normal;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BillboardData> _BillboardBuffer;
            #endif

            float3 _LightDirection;
            float3 _HalfAOffset;
            float3 _HalfBOffset;
            int _HalfBStartIndex;

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
                BillboardData billboard = _BillboardBuffer[instanceID];

                float3 pos = billboard.Position;
                // Apply per-half offset for loop mode leapfrog
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = billboard.Scale;
                float4 rot = billboard.Rotation;

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

            struct BillboardData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                float3 Normal;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BillboardData> _BillboardBuffer;
            #endif

            float3 _HalfAOffset;
            float3 _HalfBOffset;
            int _HalfBStartIndex;

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
                BillboardData billboard = _BillboardBuffer[instanceID];

                float3 pos = billboard.Position;
                // Apply per-half offset for loop mode leapfrog
                pos += (instanceID >= (uint)_HalfBStartIndex) ? _HalfBOffset : _HalfAOffset;
                float3 scale = billboard.Scale;
                float4 rot = billboard.Rotation;

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
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
