Shader "HolyRail/MatrixRain"
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
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }

        ZWrite On
        Cull Back

        Pass
        {
            Name "MatrixRain"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float fogFactor : TEXCOORD1;
            };

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
            CBUFFER_END

            // Custom mod function that handles negative numbers correctly
            float2 mod2(float2 x, float2 y)
            {
                return x - y * floor(x / y);
            }

            float mod1(float x, float y)
            {
                return x - y * floor(x / y);
            }

            // Text layer - returns character mask value (from ShaderToy)
            // Matches: vec2 uv = mod(fragCoord.xy, 16.)*.0625;
            //          vec2 block = fragCoord*.0625 - uv;
            //          uv = uv*.8+.1;
            //          uv += floor(texture(iChannel1, block/iChannelResolution[1].xy + iTime*.002).xy * 16.);
            //          uv *= .0625;
            //          uv.x = -uv.x;
            //          return texture(iChannel0, uv).r;
            float Text(float2 fragCoord)
            {
                // Apply scale by dividing input coords (larger _Scale = bigger characters)
                fragCoord /= _Scale;

                // Position within 16x16 cell, normalized to 0-1
                float2 uv = mod2(fragCoord, float2(16.0, 16.0)) * 0.0625;

                // Which cell/block we're in
                float2 block = fragCoord * 0.0625 - uv;

                // Scale the letters up a bit (0.8 scale, 0.1 margin)
                uv = uv * 0.8 + 0.1;

                // Randomize letters using noise texture, animated over time
                float2 noiseUV = block * 0.01 + _Time.y * _CharChangeSpeed * 0.002;
                float4 noiseSample = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, noiseUV);
                uv += floor(noiseSample.xy * 16.0);

                // Bring back into 0-1 range for atlas lookup
                uv *= 0.0625;

                // Flip letters horizontally
                uv.x = -uv.x;

                // Sample character atlas
                return SAMPLE_TEXTURE2D(_CharTex, sampler_CharTex, uv).r;
            }

            // Rain effect - creates vertical falling trails (from ShaderToy)
            // Matches: fragCoord.x -= mod(fragCoord.x, 16.);
            //          float offset=sin(fragCoord.x*15.);
            //          float speed=cos(fragCoord.x*3.)*.3+.7;
            //          float y = fract(fragCoord.y/iResolution.y + iTime*speed + offset);
            //          return vec3(.1,1,.35) / (y*20.);
            float3 Rain(float2 fragCoord, float2 resolution)
            {
                // Apply scale
                fragCoord /= _Scale;

                // Snap X to 16-pixel columns
                fragCoord.x -= mod1(fragCoord.x, 16.0);

                // Per-column variation
                float offset = sin(fragCoord.x * 15.0);
                float speed = cos(fragCoord.x * 3.0) * 0.3 + 0.7;

                // Falling gradient - y goes from 0 (head/bright) to 1 (tail/dim)
                float y = frac(fragCoord.y / (resolution.y / _Scale) + _Time.y * _Speed * speed + offset);

                // Trail intensity - bright at head (low y), fading toward tail
                // TrailLength adjusts the divisor (lower = longer brighter trails)
                float divisor = y * 20.0 * (2.0 - _TrailLength) + 0.05;
                float intensity = 1.0 / divisor;

                return _CharColor.rgb * intensity * _Brightness;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.uv = input.uv;
                output.fogFactor = ComputeFogFactor(vertexInput.positionCS.z);

                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Use a virtual resolution for consistent look
                float2 resolution = float2(512.0, 512.0);
                float2 fragCoord = input.uv * resolution;

                // Get the text (character) mask
                float textMask = Text(fragCoord);

                // Get the rain color (includes intensity falloff)
                float3 rainColor = Rain(fragCoord, resolution);

                // Combine: text mask multiplied by rain color (like ShaderToy)
                half3 color = textMask * rainColor;

                // Add background color where there's no text
                color = max(color, _BackgroundColor.rgb);

                half4 finalColor = half4(color, 1.0);

                // Apply fog
                finalColor.rgb = MixFog(finalColor.rgb, input.fogFactor);

                return finalColor;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
