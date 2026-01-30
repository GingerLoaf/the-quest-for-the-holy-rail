Shader "HolyRail/SplineCurvature"
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

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

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

            // GPU-efficient simplex noise implementation
            // Uses vectorized operations for SIMD efficiency
            // Branch-free using step(), min(), max()

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

                // First corner
                float3 i = floor(v + dot(v, C.yyy));
                float3 x0 = v - i + dot(i, C.xxx);

                // Other corners (branch-free using step)
                float3 g = step(x0.yzx, x0.xyz);
                float3 l = 1.0 - g;
                float3 i1 = min(g.xyz, l.zxy);
                float3 i2 = max(g.xyz, l.zxy);

                float3 x1 = x0 - i1 + C.xxx;
                float3 x2 = x0 - i2 + C.yyy;
                float3 x3 = x0 - D.yyy;

                // Permutations
                i = mod289(i);
                float4 p = permute(permute(permute(
                    i.z + float4(0.0, i1.z, i2.z, 1.0))
                    + i.y + float4(0.0, i1.y, i2.y, 1.0))
                    + i.x + float4(0.0, i1.x, i2.x, 1.0));

                // Gradients (vectorized)
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

                // Normalise gradients
                float4 norm = taylorInvSqrt(float4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
                p0 *= norm.x;
                p1 *= norm.y;
                p2 *= norm.z;
                p3 *= norm.w;

                // Mix final noise value (vectorized)
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
                // Dot product of normal with direction from center approximates local curvature
                // Positive = convex/stretched, Negative = concave/pinched
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
    }

    FallBack "Universal Render Pipeline/Lit"
}
