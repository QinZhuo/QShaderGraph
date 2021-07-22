namespace UnityEngine.Rendering.Universal
{
    [System.Serializable]
    public class DualKawaseBlurSettings
    {
        [SerializeField, Range(0, 5)] internal float Radius = 3;
        [SerializeField, Range(1, 8)] internal int Iteration = 6;
        [SerializeField, Range(1, 8)] internal float DownSample = 2;
        [SerializeField] internal RenderPassEvent RenderPassEvent = RenderPassEvent.AfterRenderingTransparents;
    }

    public class DualKawaseBlurFeature : ScriptableRendererFeature
    {
        [SerializeField, HideInInspector] private Shader m_Shader = null;
        [SerializeField] public DualKawaseBlurSettings m_Settings = new DualKawaseBlurSettings();

        private Material m_Material = null;
        private DualKawaseBlurPass m_DualKawaseBlurPass = null;


        private const string k_ShaderName = "QShaderGraph/QBlur";

        private bool GetMaterial()
        {
            if (m_Material != null)
            {
                return true;
            }

            if (m_Shader == null)
            {
                m_Shader = Shader.Find(k_ShaderName);
                if (m_Shader == null)
                {
                    return false;
                }
            }

            m_Material = CoreUtils.CreateEngineMaterial(m_Shader);
            m_DualKawaseBlurPass.material = m_Material;
            return m_Material != null;
        }
        public override void Create()
        {
            if (m_DualKawaseBlurPass == null)
            {
                m_DualKawaseBlurPass = new DualKawaseBlurPass(name);
            }
            GetMaterial();
            m_DualKawaseBlurPass.renderPassEvent = m_Settings.RenderPassEvent;
        }
        protected override void Dispose(bool disposing)
        {
            CoreUtils.Destroy(m_Material);
        }
        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (!GetMaterial())
            {
                Debug.LogError(
                    $"{GetType().Name}.AddRenderPasses(): Missing material. " +
                    $"{m_DualKawaseBlurPass.profilerTag} render pass will not be added. " +
                    $"Check for missing reference in the renderer resources.");
                return;
            }
            if (!m_DualKawaseBlurPass.Setup(m_Settings))
            {
                return;
            }
            renderer.EnqueuePass(m_DualKawaseBlurPass);
        }

        class DualKawaseBlurPass : ScriptableRenderPass
        {
            internal Material material = null;
            internal string profilerTag;

            private Level[] m_Pyramid;
            private DualKawaseBlurSettings m_Settings;
            private ProfilingSampler m_ProfilingSampler;

            private RenderTargetIdentifier m_DKBTextureTarget = new RenderTargetIdentifier(s_DualKawaseBlurTextureID);
            private RenderTargetIdentifier m_CameraColorTextureTarget = new RenderTargetIdentifier(s_CameraColorTextureID);

            private static readonly int s_CameraColorTextureID = Shader.PropertyToID("_CameraColorTexture");
            private static readonly int s_DualKawaseBlurTextureID = Shader.PropertyToID("_DualKawaseBlurTexture");
            private static readonly int s_DKBOffsetID = Shader.PropertyToID("_Offset");
            private static readonly int s_DKBOSizeID = Shader.PropertyToID("_DualKawaseBlurTexture_Size");

            class Level {
                internal int down;
                internal int up;
                internal Vector2Int size;
            }

            public DualKawaseBlurPass(string tag)
            {
                profilerTag = tag;
                m_Settings = new DualKawaseBlurSettings();
                m_ProfilingSampler = new ProfilingSampler(profilerTag);
            }

            public bool Setup(DualKawaseBlurSettings settings)
            {
                m_Settings = settings;
                m_Pyramid = new Level[m_Settings.Iteration];

                for (int i = 0; i < m_Pyramid.Length; i++)
                {
                    m_Pyramid[i] = new Level { 
                        down = Shader.PropertyToID("_DualKawaseBlurMipDown" + i) ,
                        up = Shader.PropertyToID("_DualKawaseBlurMipUp" + i)
                    };
                }

                return material != null && m_Settings.Radius != 0;
            }

            public override void OnCameraSetup(CommandBuffer cmd, ref RenderingData renderingData)
            {
                var m_Descriptor = renderingData.cameraData.cameraTargetDescriptor;

                m_Descriptor.msaaSamples = 1;
                m_Descriptor.width = (int)(m_Descriptor.width / m_Settings.DownSample);
                m_Descriptor.height = (int)(m_Descriptor.height / m_Settings.DownSample);

                material.SetFloat(s_DKBOffsetID, m_Settings.Radius/1920);

                for (int i = 0; i < m_Settings.Iteration; i++)
                {
                    Level level = m_Pyramid[i];
                    m_Pyramid[i].size = new Vector2Int(m_Descriptor.width, m_Descriptor.height);

                    m_Descriptor.width = Mathf.Max(m_Descriptor.width / 2, 1);
                    m_Descriptor.height = Mathf.Max(m_Descriptor.height / 2, 1);

                    cmd.GetTemporaryRT(level.down, m_Descriptor, FilterMode.Point);
                    cmd.GetTemporaryRT(level.up, m_Descriptor, FilterMode.Point);
                }
            }

            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                CommandBuffer cmd = CommandBufferPool.Get(profilerTag);

                using (new ProfilingScope(cmd, m_ProfilingSampler))
                {
                    if (renderingData.cameraData.cameraType == CameraType.Game)
                    {
                        RenderTargetIdentifier last = m_CameraColorTextureTarget;
                        cmd.SetGlobalTexture(s_DualKawaseBlurTextureID, last);
                        for (int i = 0; i < m_Settings.Iteration; i++)
                        {
                            Level level = m_Pyramid[i];
                            BlitBlur(cmd, last, level.down, level.size, 0);
                            last = level.down;
                        }

                        for (int i = m_Settings.Iteration - 2; i >= 0; i--)
                        {
                            Level level = m_Pyramid[i];
                            BlitBlur(cmd, last, level.up, level.size, 1);
                            last = level.up;
                        }
                        cmd.Blit(last, m_CameraColorTextureTarget);
                    }
                }
                context.ExecuteCommandBuffer(cmd);
                CommandBufferPool.Release(cmd);
            }

            public override void OnCameraCleanup(CommandBuffer cmd)
            {
                cmd.ReleaseTemporaryRT(s_DualKawaseBlurTextureID);
                foreach (var level in m_Pyramid)
                {
                    cmd.ReleaseTemporaryRT(level.down);
                    cmd.ReleaseTemporaryRT(level.up);
                }
            }

            private void BlitBlur(CommandBuffer cmd, RenderTargetIdentifier source, RenderTargetIdentifier dest, Vector2 size, int pass)
            {
                cmd.SetGlobalVector(s_DKBOSizeID, size);
                cmd.Blit(source, dest, material, pass);
                cmd.SetGlobalTexture("_DualKawaseBlurTexture", dest);
            }
        }
    }
}


