using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.RenderGraphModule;
using UnityEngine.Rendering.RenderGraphModule.Util;

namespace HolyRail.PostProcessing
{
    public class GradientFogRenderFeature : ScriptableRendererFeature
    {
        [System.Serializable]
        public class Settings
        {
            public RenderPassEvent renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;
            public Material fogMaterial;
        }

        public Settings settings = new();
        private GradientFogRenderPass _renderPass;

        public override void Create()
        {
            _renderPass = new GradientFogRenderPass(settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            Debug.Log($"GradientFog: AddRenderPasses called, material={(settings.fogMaterial != null ? settings.fogMaterial.name : "NULL")}");

            if (settings.fogMaterial == null)
            {
                Debug.LogError("GradientFog: No material assigned!");
                return;
            }

            var volume = VolumeManager.instance.stack.GetComponent<GradientFogVolume>();
            if (volume == null)
            {
                Debug.LogWarning("GradientFog: Volume not found, using material defaults");
            }
            else if (!volume.IsActive())
            {
                Debug.LogWarning("GradientFog: Volume not active");
            }
            else
            {
                _renderPass.Setup(volume);
            }

            // Always enqueue pass for debugging
            renderer.EnqueuePass(_renderPass);
        }

        protected override void Dispose(bool disposing)
        {
            _renderPass?.Dispose();
        }
    }

    public class GradientFogRenderPass : ScriptableRenderPass
    {
        private readonly GradientFogRenderFeature.Settings _settings;

        private static readonly int Color1Id = Shader.PropertyToID("_Color1");
        private static readonly int Color2Id = Shader.PropertyToID("_Color2");
        private static readonly int Color3Id = Shader.PropertyToID("_Color3");
        private static readonly int BlendHeight12Id = Shader.PropertyToID("_BlendHeight12");
        private static readonly int BlendHeight23Id = Shader.PropertyToID("_BlendHeight23");
        private static readonly int Falloff12Id = Shader.PropertyToID("_Falloff12");
        private static readonly int Falloff23Id = Shader.PropertyToID("_Falloff23");
        private static readonly int DensityId = Shader.PropertyToID("_Density");
        private static readonly int StartDistanceId = Shader.PropertyToID("_StartDistance");

        public GradientFogRenderPass(GradientFogRenderFeature.Settings settings)
        {
            _settings = settings;
            renderPassEvent = settings.renderPassEvent;

            ConfigureInput(ScriptableRenderPassInput.Depth);
            requiresIntermediateTexture = true;
        }

        public void Setup(GradientFogVolume volume)
        {
            var material = _settings.fogMaterial;
            if (material == null)
            {
                return;
            }

            material.SetColor(Color1Id, volume.color1.value);
            material.SetColor(Color2Id, volume.color2.value);
            material.SetColor(Color3Id, volume.color3.value);
            material.SetFloat(BlendHeight12Id, volume.blendHeight12.value);
            material.SetFloat(BlendHeight23Id, volume.blendHeight23.value);
            material.SetFloat(Falloff12Id, volume.falloff12.value);
            material.SetFloat(Falloff23Id, volume.falloff23.value);
            material.SetFloat(DensityId, volume.density.value);
            material.SetFloat(StartDistanceId, volume.startDistance.value);
        }

        public override void RecordRenderGraph(RenderGraph renderGraph, ContextContainer frameData)
        {
            var material = _settings.fogMaterial;
            if (material == null)
            {
                Debug.LogError("GradientFog: Material is null in RecordRenderGraph!");
                return;
            }

            var resourceData = frameData.Get<UniversalResourceData>();

            if (resourceData.isActiveTargetBackBuffer)
            {
                Debug.LogWarning("GradientFog: isActiveTargetBackBuffer is true, skipping");
                return;
            }

            var source = resourceData.activeColorTexture;

            var destinationDesc = renderGraph.GetTextureDesc(source);
            destinationDesc.name = "_GradientFogTexture";
            destinationDesc.clearBuffer = false;
            var destination = renderGraph.CreateTexture(destinationDesc);

            var blitParams = new RenderGraphUtils.BlitMaterialParameters(source, destination, material, 0);
            renderGraph.AddBlitPass(blitParams, passName: "GradientFog");

            resourceData.cameraColor = destination;
        }

        public void Dispose()
        {
        }
    }
}
