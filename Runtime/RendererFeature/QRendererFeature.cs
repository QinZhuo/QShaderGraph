using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

[System.Serializable]
public class QFeatureSetting
{
    public Material material;
    public RenderPassEvent RenderPassEvent = RenderPassEvent.AfterRenderingTransparents;
}
public class QPass : QPass<QFeatureSetting>
{

}
public class QRendererFeature:QFeature<QFeatureSetting,QPass>
{

}
public abstract class QFeature<TSetting, TPass> : ScriptableRendererFeature where TSetting : QFeatureSetting, new() where TPass : QPass<TSetting>, new()
{
    public TPass Pass;
    [SerializeField]
    public TSetting Setting;
    public override void Create()
    {
        if (Pass == null)
        {
            Pass = new TPass();
        }
        if (Setting == null)
        {
            Setting = new TSetting();
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
public abstract class QPass<TSetting> : ScriptableRenderPass where TSetting : QFeatureSetting, new()
{
    protected int TempTextureId =Shader.PropertyToID("tempTextureId");
    protected RenderTargetIdentifier RenderResult = new RenderTargetIdentifier("_CameraColorTexture");
    public Material Material {
        get
        {
            return Setting.material;
        }
    }
    [SerializeField]
    public TSetting Setting;
    public string tag;
    public ProfilingSampler ProfilingSampler;
    public QPass()
    {
        tag = GetType().Name;
        Setting =new TSetting();
        ProfilingSampler = new ProfilingSampler(tag);
    }
    public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
    {
        cmd.GetTemporaryRT(TempTextureId, renderingData.cameraData.cameraTargetDescriptor, FilterMode.Point);
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cmd = CommandBufferPool.Get(tag);
        if (renderingData.cameraData.cameraType == CameraType.Game)
        {
            if (Material==null)
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
    public virtual bool Setup(TSetting setting)
    {
        this.Setting = setting;
        return true;
    }
    public override void OnCameraCleanup(CommandBuffer cmd)
    {
        cmd.ReleaseTemporaryRT(TempTextureId);
    }
}