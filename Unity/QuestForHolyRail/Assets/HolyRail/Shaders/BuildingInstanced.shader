Shader "HolyRail/BuildingInstanced"
{
    Properties
    {
        _DowntownColor ("Downtown Color", Color) = (0.5, 0.5, 0.55, 1)
        _IndustrialColor ("Industrial Color", Color) = (0.55, 0.4, 0.35, 1)
        _WindowEmission ("Window Emission", Range(0, 2)) = 0.5
        _WindowDensity ("Window Density", Range(1, 20)) = 10
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

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int ZoneType;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            CBUFFER_START(UnityPerMaterial)
                float4 _DowntownColor;
                float4 _IndustrialColor;
                float _WindowEmission;
                float _WindowDensity;
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
                float2 uv : TEXCOORD2;
                float3 scale : TEXCOORD3;
                nointerpolation int zoneType : TEXCOORD4;
                nointerpolation int styleIndex : TEXCOORD5;
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

                // Build object-to-world matrix from position, rotation, scale
                float3 pos = building.Position;
                float3 scale = building.Scale;
                float4 rot = building.Rotation;

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

                // Compute inverse for normals (transpose of inverse for rotation/scale)
                // For uniform scale we can simplify, but for non-uniform we need proper inverse
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
                BuildingData building = _BuildingBuffer[unity_InstanceID];
                output.zoneType = building.ZoneType;
                output.styleIndex = building.StyleIndex;
                output.scale = building.Scale;
                #else
                output.zoneType = 0;
                output.styleIndex = 0;
                output.scale = float3(1, 1, 1);
                #endif

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);

                output.positionCS = vertexInput.positionCS;
                output.positionWS = vertexInput.positionWS;
                output.normalWS = normalInput.normalWS;
                output.uv = input.uv;

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Base color based on zone type
                half4 baseColor = input.zoneType == 0 ? _DowntownColor : _IndustrialColor;

                // Add style variation
                float styleOffset = input.styleIndex * 0.05;
                baseColor.rgb += styleOffset - 0.175;

                // Simple window pattern on vertical faces
                float3 absNormal = abs(input.normalWS);
                bool isVerticalFace = absNormal.y < 0.5;

                half3 emission = half3(0, 0, 0);

                if (isVerticalFace)
                {
                    // Scale UVs based on building dimensions for consistent window sizes
                    float2 windowUV;
                    if (absNormal.x > absNormal.z)
                    {
                        windowUV = float2(input.positionWS.z, input.positionWS.y);
                    }
                    else
                    {
                        windowUV = float2(input.positionWS.x, input.positionWS.y);
                    }

                    // Window grid
                    float2 windowGrid = frac(windowUV * _WindowDensity * 0.1);
                    float windowMask = step(0.2, windowGrid.x) * step(windowGrid.x, 0.8) *
                                       step(0.15, windowGrid.y) * step(windowGrid.y, 0.7);

                    // Random window lit state based on position
                    float windowHash = frac(sin(dot(floor(windowUV * _WindowDensity * 0.1), float2(12.9898, 78.233))) * 43758.5453);
                    float windowLit = step(0.4, windowHash);

                    // Yellow/warm window glow for downtown, dimmer for industrial
                    half3 windowColor = input.zoneType == 0 ?
                        half3(1.0, 0.9, 0.6) : half3(0.8, 0.7, 0.5);

                    emission = windowColor * windowMask * windowLit * _WindowEmission;
                }

                // Simple lighting
                Light mainLight = GetMainLight();
                half NdotL = saturate(dot(input.normalWS, mainLight.direction));
                half3 ambient = half3(0.15, 0.15, 0.2);

                half3 finalColor = baseColor.rgb * (ambient + mainLight.color * NdotL * 0.85) + emission;

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

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int ZoneType;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

            float3 _LightDirection;

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

            struct BuildingData
            {
                float3 Position;
                float3 Scale;
                float4 Rotation;
                int ZoneType;
                int StyleIndex;
            };

            #ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
            StructuredBuffer<BuildingData> _BuildingBuffer;
            #endif

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
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
