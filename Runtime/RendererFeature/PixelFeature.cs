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
    //    [SerializeField, Range(1, 8)] internal int Iteration = 6;
    }
    public class PixelFeature : QFeature<PixelSetting, PixelPass>
    {

        protected override string ShaderName => "QShaderGraph/QPixel";
     
    
    }

    public class PixelPass : QPass<PixelSetting>
    {
        // private Level[] m_Pyramid;
        private RenderTargetIdentifier TempTexture = new RenderTargetIdentifier("_CameraColorTexture");

        int down = Shader.PropertyToID("a");

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
            else
            {
                material.SetVector("_Size", size);
            }
            cmd.GetTemporaryRT(down, m_Descriptor, FilterMode.Point);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get(tag);
            if (renderingData.cameraData.cameraType == CameraType.Game)
            {
                RenderTargetIdentifier last = TempTexture;
                if (Setting.type == PixelSetting.PixelType.DownSample)
                {
                    cmd.Blit(last, down);
                    cmd.Blit(down, TempTexture);

                }
                else
                {
                     cmd.Blit(last, down);
                    cmd.Blit(down, TempTexture, material,0);

                }

           
            }
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            cmd.ReleaseTemporaryRT(down);
        }

     
    }
}


