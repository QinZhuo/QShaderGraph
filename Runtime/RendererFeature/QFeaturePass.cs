using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

[System.Serializable]
public abstract class QFeatureSetting
{
    public RenderPassEvent RenderPassEvent = RenderPassEvent.AfterRenderingTransparents;
}


public abstract class QFeature<TSetting, TPass> : ScriptableRendererFeature where TSetting : QFeatureSetting, new() where TPass : QPass<TSetting>, new()
{
    public TPass Pass;
    [SerializeField]
    public TSetting Setting;
    protected abstract string ShaderName { get; }
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
        CoreUtils.Destroy(MainMaterial);
    }
    protected Material MainMaterial
    {
        get
        {
            if (Pass.material != null)
            {
                return Pass.material;
            }
            var shader = Shader.Find(ShaderName);
            if (shader == null)
            {
                return null;
            }
            Pass.material = CoreUtils.CreateEngineMaterial(shader);
            return Pass.material;
        }
    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (MainMaterial == null&&!string.IsNullOrWhiteSpace( ShaderName))
        {
            return;
        }
        if (!Pass.Setup(Setting))
        {
            return;
        }
        renderer.EnqueuePass(Pass);
    }

}
public abstract class QPass<TSetting> : ScriptableRenderPass where TSetting : new()
{
    public Material material = null;
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
    public virtual bool Setup(TSetting setting)
    {
        this.Setting = setting;
        return true;
    }
}