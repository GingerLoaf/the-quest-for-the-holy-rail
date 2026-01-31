using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;

namespace HolyRail.PostProcessing
{
    public class MatrixRainDeathRenderFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class Settings
        {
            public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
            public Material deathMaterial;
            public Texture2D characterAtlas;
            public Texture2D noiseTexture;
            public Texture2D wipeNoiseTexture;
        }

        public Settings settings = new();
        private MatrixRainDeathRenderPass _renderPass;

        public override void Create()
        {
            _renderPass = new MatrixRainDeathRenderPass(settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (settings.deathMaterial == null)
            {
                return;
            }

            var volume = VolumeManager.instance.stack.GetComponent<MatrixRainDeathVolume>();
            if (volume == null || !volume.IsActive())
            {
                return;
            }

            _renderPass.Setup(volume);
            renderer.EnqueuePass(_renderPass);
        }

        protected override void Dispose(bool disposing)
        {
            _renderPass?.Dispose();
        }
    }

    public class MatrixRainDeathRenderPass : ScriptableRenderPass
    {
        private readonly MatrixRainDeathRenderFeature.Settings _settings;
        private Material _material;

        private static readonly int WipePositionId = Shader.PropertyToID("_WipePosition");
        private static readonly int CharColorId = Shader.PropertyToID("_CharColor");
        private static readonly int BackgroundColorId = Shader.PropertyToID("_BackgroundColor");
        private static readonly int SpeedId = Shader.PropertyToID("_Speed");
        private static readonly int ScaleId = Shader.PropertyToID("_Scale");
        private static readonly int BrightnessId = Shader.PropertyToID("_Brightness");
        private static readonly int TrailLengthId = Shader.PropertyToID("_TrailLength");
        private static readonly int CharChangeSpeedId = Shader.PropertyToID("_CharChangeSpeed");
        private static readonly int CharTexId = Shader.PropertyToID("_CharTex");
        private static readonly int NoiseTexId = Shader.PropertyToID("_NoiseTex");
        private static readonly int WipeNoiseTexId = Shader.PropertyToID("_WipeNoiseTex");
        private static readonly int WipeNoiseScaleId = Shader.PropertyToID("_WipeNoiseScale");
        private static readonly int WipeNoiseStrengthId = Shader.PropertyToID("_WipeNoiseStrength");

        public MatrixRainDeathRenderPass(MatrixRainDeathRenderFeature.Settings settings)
        {
            _settings = settings;
            renderPassEvent = settings.renderPassEvent;
            _material = settings.deathMaterial;

            requiresIntermediateTexture = true;
        }

        public void Setup(MatrixRainDeathVolume volume)
        {
            if (_material == null)
            {
                return;
            }

            _material.SetFloat(WipePositionId, volume.wipePosition.value);
            _material.SetColor(CharColorId, volume.charColor.value);
            _material.SetColor(BackgroundColorId, volume.backgroundColor.value);
            _material.SetFloat(SpeedId, volume.speed.value);
            _material.SetFloat(ScaleId, volume.scale.value);
            _material.SetFloat(BrightnessId, volume.brightness.value);
            _material.SetFloat(TrailLengthId, volume.trailLength.value);
            _material.SetFloat(CharChangeSpeedId, volume.charChangeSpeed.value);
            _material.SetFloat(WipeNoiseScaleId, volume.wipeNoiseScale.value);
            _material.SetFloat(WipeNoiseStrengthId, volume.wipeNoiseStrength.value);

            if (_settings.characterAtlas != null)
            {
                _material.SetTexture(CharTexId, _settings.characterAtlas);
            }

            if (_settings.noiseTexture != null)
            {
                _material.SetTexture(NoiseTexId, _settings.noiseTexture);
            }

            if (_settings.wipeNoiseTexture != null)
            {
                _material.SetTexture(WipeNoiseTexId, _settings.wipeNoiseTexture);
            }
        }

        public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
        {
            var resourceData = frameData.Get<UniversalResourceData>();

            if (resourceData.isActiveTargetBackBuffer)
            {
                return;
            }

            var source = resourceData.activeColorTexture;

            var destinationDesc = renderGraph.GetTextureDesc(source);
            destinationDesc.name = "_MatrixRainDeathTexture";
            destinationDesc.clearBuffer = false;
            var destination = renderGraph.CreateTexture(destinationDesc);

            var blitParams = new RenderGraphUtils.BlitMaterialParameters(source, destination, _material, 0);
            renderGraph.AddBlitPass(blitParams, passName: "MatrixRainDeath");

            resourceData.cameraColor = destination;
        }

        public void Dispose()
        {
        }
    }
}
