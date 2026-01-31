Shader "HolyRail/MatrixRainDeath"
{
    Properties
    {
        _CharTex ("Character Atlas", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _WipeNoiseTex ("Wipe Edge Noise", 2D) = "gray" {}
        [HDR] _CharColor ("Character Color", Color) = (0.1, 1.0, 0.35, 1.0)
        _BackgroundColor ("Background Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _Speed ("Animation Speed", Range(0.1, 5.0)) = 1.0
        _Scale ("Character Scale", Range(0.5, 4.0)) = 1.0
        _Brightness ("Brightness", Range(0.1, 3.0)) = 1.0
        _TrailLength ("Trail Length", Range(0.1, 1.0)) = 0.5
        _CharChangeSpeed ("Character Change Speed", Range(0.5, 10.0)) = 3.0
        _WipePosition ("Wipe Position", Range(0, 1)) = 0.0
        _WipeNoiseScale ("Wipe Noise Scale", Range(0.1, 10.0)) = 2.0
        _WipeNoiseStrength ("Wipe Noise Strength", Range(0, 0.5)) = 0.15
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        ZWrite Off
        Cull Off
        ZTest Always

        Pass
        {
            Name "MatrixRainDeath"

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            TEXTURE2D(_CharTex);
            SAMPLER(sampler_CharTex);
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);
            TEXTURE2D(_WipeNoiseTex);
            SAMPLER(sampler_WipeNoiseTex);

            float4 _CharColor;
            float4 _BackgroundColor;
            float _Speed;
            float _Scale;
            float _Brightness;
            float _TrailLength;
            float _CharChangeSpeed;
            float _WipePosition;
            float _WipeNoiseScale;
            float _WipeNoiseStrength;

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

            // Rain effect - creates vertical falling trails, returns intensity
            float Rain(float2 fragCoord, float2 resolution)
            {
                fragCoord /= _Scale;
                fragCoord.x -= mod1(fragCoord.x, 16.0);
                float offset = sin(fragCoord.x * 15.0);
                float speed = cos(fragCoord.x * 3.0) * 0.3 + 0.7;
                float y = frac(fragCoord.y / (resolution.y / _Scale) + _Time.y * _Speed * speed + offset);
                float divisor = y * 20.0 * (2.0 - _TrailLength) + 0.05;
                float intensity = 1.0 / divisor;
                return saturate(intensity);
            }

            float4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                float2 uv = input.texcoord;
                float4 sceneColor = SAMPLE_TEXTURE2D_X(_BlitTexture, sampler_LinearClamp, uv);

                // If wipe position is 0, show scene unmodified (no effect)
                if (_WipePosition < 0.001)
                    return sceneColor;

                // Use actual screen dimensions for correct aspect ratio
                float2 resolution = _ScreenParams.xy;
                float2 fragCoord = uv * resolution;

                // Get rain intensity at this pixel (0-1, higher = brighter/head of trail)
                float rainIntensity = Rain(fragCoord, resolution);

                // wipeY: 0 at bottom of screen, 1 at top
                float wipeY = uv.y;

                // Sample noise for organic edge at the wipe boundary
                float2 noiseUV = float2(uv.x * _WipeNoiseScale, uv.y * _WipeNoiseScale * 0.5);
                float wipeNoise = SAMPLE_TEXTURE2D(_WipeNoiseTex, sampler_WipeNoiseTex, noiseUV).r;
                // Center noise around 0 (-0.5 to 0.5) and apply strength
                float noiseOffset = (wipeNoise - 0.5) * _WipeNoiseStrength;

                // The wipe edge moves DOWN as _WipePosition increases (rain appears from top)
                // At wipePosition=0: wipeEdge is above screen (~1.3), no effect visible
                // At wipePosition=1: wipeEdge is below screen (~-0.2), full effect visible
                float wipeEdge = (1.0 - _WipePosition) * 1.5 - 0.2 + noiseOffset;
                float edgeSoftness = 0.1;

                // Calculate how much this pixel should show the matrix effect
                // Pixels ABOVE the wipe edge show the effect (rain descends from top)
                float baseWipe = smoothstep(wipeEdge - edgeSoftness, wipeEdge + edgeSoftness, wipeY);

                // Rain leads the wipe edge - brighter rain columns extend slightly below the edge
                float rainLead = rainIntensity * 0.15 * _WipePosition;
                float effectMask = saturate(baseWipe + rainLead);

                // Only apply if we're in the effect zone
                if (effectMask < 0.01)
                    return sceneColor;

                // Get text character mask
                float textMask = Text(fragCoord);

                // Calculate matrix rain color
                float3 rainColor = _CharColor.rgb * rainIntensity * _Brightness;
                float3 matrixColor = textMask * rainColor;

                // Add background where there's no text
                matrixColor = max(matrixColor, _BackgroundColor.rgb);

                // Blend between scene and matrix effect based on effectMask
                float3 finalColor = lerp(sceneColor.rgb, matrixColor, effectMask);

                return float4(finalColor, 1.0);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
