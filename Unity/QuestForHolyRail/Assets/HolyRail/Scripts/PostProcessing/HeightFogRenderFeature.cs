using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;

namespace HolyRail.PostProcessing
{
    public class HeightFogRenderFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class Settings
        {
            public RenderPassEvent renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
            public Material fogMaterial;
        }

        public Settings settings = new();
        private HeightFogRenderPass _renderPass;

        public override void Create()
        {
            _renderPass = new HeightFogRenderPass(settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (settings.fogMaterial == null)
            {
                return;
            }

            var volume = VolumeManager.instance.stack.GetComponent<HeightFogVolume>();
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

    public class HeightFogRenderPass : ScriptableRenderPass
    {
        private readonly HeightFogRenderFeature.Settings _settings;
        private Material _material;

        private static readonly int FogColorId = Shader.PropertyToID("_FogColor");
        private static readonly int DensityId = Shader.PropertyToID("_Density");
        private static readonly int StartDistanceId = Shader.PropertyToID("_StartDistance");

        public HeightFogRenderPass(HeightFogRenderFeature.Settings settings)
        {
            _settings = settings;
            renderPassEvent = settings.renderPassEvent;
            _material = settings.fogMaterial;

            // CRITICAL: Tell URP we need the depth texture
            ConfigureInput(ScriptableRenderPassInput.Depth);

            requiresIntermediateTexture = true;
        }

        public void Setup(HeightFogVolume volume)
        {
            if (_material == null)
            {
                return;
            }

            _material.SetColor(FogColorId, volume.fogColor.value);
            _material.SetFloat(DensityId, volume.density.value);
            _material.SetFloat(StartDistanceId, volume.startDistance.value);
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
            destinationDesc.name = "_HeightFogTexture";
            destinationDesc.clearBuffer = false;
            var destination = renderGraph.CreateTexture(destinationDesc);

            // Use the simpler BlitMaterialParameters API
            var blitParams = new RenderGraphUtils.BlitMaterialParameters(source, destination, _material, 0);
            renderGraph.AddBlitPass(blitParams, passName: "HeightFog");

            // Swap so next pass uses our output
            resourceData.cameraColor = destination;
        }

        public void Dispose()
        {
        }
    }
}
