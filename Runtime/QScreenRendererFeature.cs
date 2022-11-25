using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace QTool
{
    public class QScreenRendererFeature : ScriptableRendererFeature
    {
        private void OnValidate()
        {
            if (Material != null)
            {
                name = Material.name;
            }
        }
        public QScreenRenderPass Pass;
        [SerializeField]
        public QScreenPassSetting Setting;
        public override void Create()
        {
            if (Pass == null)
            {
                Pass = new QScreenRenderPass();
            }
            if (Setting == null)
            {
                Setting = new QScreenPassSetting();
            }
            Pass.renderPassEvent = Setting.RenderPassEvent;
        }
        protected override void Dispose(bool disposing)
        {

        }
        protected Material Material
        {
            get
            {
                return Pass.Material;
            }
        }
        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (!Pass.Setup(Setting))
            {
                return;
            }
            renderer.EnqueuePass(Pass);
        }

    }
    public class QScreenRenderPass : ScriptableRenderPass
    {
        protected int TempTextureId = Shader.PropertyToID(nameof(QScreenRenderPass));
        protected RenderTargetIdentifier RenderResult = new RenderTargetIdentifier(nameof(QScreenRenderPass));
        public Material Material
        {
            get
            {
                return Setting.material;
            }
        }
        [SerializeField]
        public QScreenPassSetting Setting;
        public string tag;
        public ProfilingSampler ProfilingSampler;
        public QScreenRenderPass()
        {
            tag = GetType().Name;
            Setting = new QScreenPassSetting();
            ProfilingSampler = new ProfilingSampler(tag);
        }
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            if (Setting.downSample > 1)
            {
                renderingData.cameraData.cameraTargetDescriptor.width /= Setting.downSample;
                renderingData.cameraData.cameraTargetDescriptor.height /= Setting.downSample;
            }
            cmd.GetTemporaryRT(TempTextureId, renderingData.cameraData.cameraTargetDescriptor, FilterMode.Point);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get(tag);
            if (renderingData.cameraData.cameraType == CameraType.Game)
            {
                if (Material == null)
                {
                    cmd.Blit(RenderResult, TempTextureId);
                    cmd.Blit(TempTextureId, RenderResult);
                }
                else
                {
                    cmd.Blit(RenderResult, TempTextureId);
                    cmd.Blit(TempTextureId, RenderResult, Material, 0);
                }
            }
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
        public virtual bool Setup(QScreenPassSetting setting)
        {
            this.Setting = setting;
            return true;
        }
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(TempTextureId);
        }
    }
  
    [System.Serializable]
    public class QScreenPassSetting
    {
        public Material material;
        public RenderPassEvent RenderPassEvent = RenderPassEvent.AfterRenderingTransparents;
        public int downSample = 1;
    }
}