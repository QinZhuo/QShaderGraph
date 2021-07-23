namespace UnityEngine.Rendering.Universal
{

  
    [System.Serializable]
    public class PixelSetting : QFeatureSetting
    {
        public enum PixelType
        {
            DownSample,
            Shader
        }
        [SerializeField] internal int pixelCount = 256;
        public PixelType type = PixelType.DownSample;
    }
    public class PixelFeature : QFeature<PixelSetting, PixelPass>
    {
        
    }

    public class PixelPass : QPass<PixelSetting>
    {
      
        public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
        {
            var m_Descriptor = renderingData.cameraData.cameraTargetDescriptor;
            var min = Mathf.Min(m_Descriptor.width, m_Descriptor.height);
            min = min <= 0 ? 1 : min;
            var donwSample = min / Mathf.Clamp(Setting.pixelCount, 1, min);
            var size = new Vector2(Mathf.Max((int)(m_Descriptor.width / donwSample), 1), Mathf.Max((int)(m_Descriptor.height / donwSample), 1));
            m_Descriptor.msaaSamples = 1;
            if(Setting.type== PixelSetting.PixelType.DownSample)
            {
                m_Descriptor.width = (int)size.x;
                m_Descriptor.height = (int)size.y;

            }
            else if(Material!=null)
            {
                Material.SetVector("_Size", size);
            }
            cmd.GetTemporaryRT(TempTextureId, m_Descriptor, FilterMode.Point);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get(tag);
            if (renderingData.cameraData.cameraType == CameraType.Game)
            {
                RenderTargetIdentifier last = RenderResult;
                if (Setting.type == PixelSetting.PixelType.DownSample)
                {
                    cmd.Blit(last, TempTextureId);
                    cmd.Blit(TempTextureId, RenderResult);

                }
                else
                {
                     cmd.Blit(last, TempTextureId);
                    cmd.Blit(TempTextureId, RenderResult, Material,0);

                }

           
            }
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(TempTextureId);
        }

     
    }
}


