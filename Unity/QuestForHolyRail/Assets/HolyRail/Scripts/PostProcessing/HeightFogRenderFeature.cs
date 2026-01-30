using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;

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

        private static readonly int BottomColorId = Shader.PropertyToID("_BottomColor");
        private static readonly int MiddleColorId = Shader.PropertyToID("_MiddleColor");
        private static readonly int TopColorId = Shader.PropertyToID("_TopColor");
        private static readonly int BottomHeightId = Shader.PropertyToID("_BottomHeight");
        private static readonly int MiddleHeightId = Shader.PropertyToID("_MiddleHeight");
        private static readonly int TopHeightId = Shader.PropertyToID("_TopHeight");
        private static readonly int BottomMiddleFalloffId = Shader.PropertyToID("_BottomMiddleFalloff");
        private static readonly int MiddleTopFalloffId = Shader.PropertyToID("_MiddleTopFalloff");
        private static readonly int BottomDensityId = Shader.PropertyToID("_BottomDensity");
        private static readonly int MiddleDensityId = Shader.PropertyToID("_MiddleDensity");
        private static readonly int TopDensityId = Shader.PropertyToID("_TopDensity");
        private static readonly int GlobalDensityId = Shader.PropertyToID("_GlobalDensity");
        private static readonly int MinDistanceId = Shader.PropertyToID("_MinDistance");
        private static readonly int MaxDistanceId = Shader.PropertyToID("_MaxDistance");

        private const string PassName = "HeightFog";

        public HeightFogRenderPass(HeightFogRenderFeature.Settings settings)
        {
            _settings = settings;
            renderPassEvent = settings.renderPassEvent;
            _material = settings.fogMaterial;
            profilingSampler = new ProfilingSampler(PassName);
            requiresIntermediateTexture = true;
        }

        private class PassData
        {
            public Material Material;
            public TextureHandle SourceTexture;
        }

        public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
        {
            var resourceData = frameData.Get<UniversalResourceData>();
            var cameraData = frameData.Get<UniversalCameraData>();

            if (resourceData.isActiveTargetBackBuffer)
            {
                return;
            }

            var volume = VolumeManager.instance.stack.GetComponent<HeightFogVolume>();
            if (volume == null || !volume.IsActive())
            {
                return;
            }

            var source = resourceData.activeColorTexture;
            var destinationDesc = renderGraph.GetTextureDesc(source);
            destinationDesc.name = "_HeightFogTexture";
            destinationDesc.clearBuffer = false;

            var tempTexture = renderGraph.CreateTexture(destinationDesc);

            UpdateMaterialProperties(volume);

            // Pass 1: Blit source to temp with fog effect
            using (var builder = renderGraph.AddRasterRenderPass<PassData>(PassName, out var passData, profilingSampler))
            {
                passData.Material = _material;
                passData.SourceTexture = source;

                builder.UseTexture(source, AccessFlags.Read);
                builder.SetRenderAttachment(tempTexture, 0, AccessFlags.Write);
                builder.SetRenderFunc((PassData data, RasterGraphContext context) =>
                {
                    Blitter.BlitTexture(context.cmd, data.SourceTexture, new Vector4(1, 1, 0, 0), data.Material, 0);
                });
            }

            // Pass 2: Copy temp back to active color texture
            using (var builder = renderGraph.AddRasterRenderPass<PassData>(PassName + "_CopyBack", out var passData, profilingSampler))
            {
                passData.SourceTexture = tempTexture;

                builder.UseTexture(tempTexture, AccessFlags.Read);
                builder.SetRenderAttachment(source, 0, AccessFlags.Write);
                builder.SetRenderFunc((PassData data, RasterGraphContext context) =>
                {
                    Blitter.BlitTexture(context.cmd, data.SourceTexture, new Vector4(1, 1, 0, 0), 0, false);
                });
            }
        }

        private void UpdateMaterialProperties(HeightFogVolume volume)
        {
            if (_material == null)
            {
                return;
            }

            _material.SetColor(BottomColorId, volume.bottomColor.value);
            _material.SetColor(MiddleColorId, volume.middleColor.value);
            _material.SetColor(TopColorId, volume.topColor.value);

            _material.SetFloat(BottomHeightId, volume.bottomHeight.value);
            _material.SetFloat(MiddleHeightId, volume.middleHeight.value);
            _material.SetFloat(TopHeightId, volume.topHeight.value);

            _material.SetFloat(BottomMiddleFalloffId, volume.bottomToMiddleFalloff.value);
            _material.SetFloat(MiddleTopFalloffId, volume.middleToTopFalloff.value);

            _material.SetFloat(BottomDensityId, volume.bottomDensity.value);
            _material.SetFloat(MiddleDensityId, volume.middleDensity.value);
            _material.SetFloat(TopDensityId, volume.topDensity.value);

            _material.SetFloat(GlobalDensityId, volume.globalDensity.value);
            _material.SetFloat(MinDistanceId, volume.minDistance.value);
            _material.SetFloat(MaxDistanceId, volume.maxDistance.value);
        }

        public void Dispose()
        {
        }
    }
}
