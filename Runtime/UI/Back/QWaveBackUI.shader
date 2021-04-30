Shader "QShaderGraph/QWaveBackUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
        Vector2_6A46D00F("Scale", Vector) = (10, 10, 0, 0)
        Vector1_47F7ACA7("Rotate", Float) = 0.6
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
	{
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}
		ColorMask[_ColorMask]
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Off
         Blend SrcAlpha OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            #define UNIVERSAL_USELEGACYSPRITEBLOCKS
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEUNLIT
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float4 texCoord0;
            float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 Vector2_6A46D00F;
        float Vector1_47F7ACA7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        float4 _MainTex_TexelSize;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Step_float2(float2 Edge, float2 In, out float2 Out)
        {
            Out = step(Edge, In);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
        {
        };

        void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, UnityTexture2D Texture2D_CA72CD38, float2 Vector2_F19B6F36, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1, out float R_2, out float G_3, out float B_4, out float A_5)
        {
            UnityTexture2D _Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0 = Texture2D_CA72CD38;
            float2 _Property_10f7dba9ddb54aba84adb08a27e022b0_Out_0 = Vector2_F19B6F36;
            float4 _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0 = Vector4_19C7703B;
            float _Split_117dfb2a277c4a979671228912a2d2f1_R_1 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[0];
            float _Split_117dfb2a277c4a979671228912a2d2f1_G_2 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[1];
            float _Split_117dfb2a277c4a979671228912a2d2f1_B_3 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[2];
            float _Split_117dfb2a277c4a979671228912a2d2f1_A_4 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[3];
            float2 _Vector2_9c22647769ea4c96af77199c7f700b00_Out_0 = float2(_Split_117dfb2a277c4a979671228912a2d2f1_R_1, _Split_117dfb2a277c4a979671228912a2d2f1_G_2);
            float2 _Vector2_729da08c140e4f0db6fd3c2399651a00_Out_0 = float2(_Split_117dfb2a277c4a979671228912a2d2f1_B_3, _Split_117dfb2a277c4a979671228912a2d2f1_A_4);
            float2 _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3;
            Unity_TilingAndOffset_float(_Property_10f7dba9ddb54aba84adb08a27e022b0_Out_0, _Vector2_9c22647769ea4c96af77199c7f700b00_Out_0, _Vector2_729da08c140e4f0db6fd3c2399651a00_Out_0, _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3);
            float4 _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0.tex, _Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0.samplerstate, _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3);
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_R_4 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.r;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_G_5 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.g;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_B_6 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.b;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_A_7 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.a;
            float _Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1;
            Unity_Preview_float(_SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_A_7, _Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1);
            float2 _Step_74b80af085fb44dab793b8aebd02e674_Out_2;
            Unity_Step_float2(float2(0, 0), _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3, _Step_74b80af085fb44dab793b8aebd02e674_Out_2);
            float2 _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2;
            Unity_Step_float2(_TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3, float2(1, 1), _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2);
            float2 _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2;
            Unity_Multiply_float(_Step_74b80af085fb44dab793b8aebd02e674_Out_2, _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2, _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2);
            float _Split_41b59f89add144378ab7e9985e715d68_R_1 = _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2[0];
            float _Split_41b59f89add144378ab7e9985e715d68_G_2 = _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2[1];
            float _Split_41b59f89add144378ab7e9985e715d68_B_3 = 0;
            float _Split_41b59f89add144378ab7e9985e715d68_A_4 = 0;
            float _Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2;
            Unity_Multiply_float(_Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1, _Split_41b59f89add144378ab7e9985e715d68_R_1, _Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2);
            float _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2;
            Unity_Multiply_float(_Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2, _Split_41b59f89add144378ab7e9985e715d68_G_2, _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2);
            Output_1 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0;
            R_2 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_R_4;
            G_3 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_G_5;
            B_4 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_B_6;
            A_5 = _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2;
        }

        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Round_float(float In, out float Out)
        {
            Out = round(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        struct Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da
        {
        };

        void SG_QWaveBack_08a913e1b4ae3e342a78aa488653d6da(float2 Vector2_7C225E21, float2 Vector2_85052A8F, Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da IN, out float OutVector1_1)
        {
            float2 _Property_54a14c25195a3c86a689d49986f1212e_Out_0 = Vector2_7C225E21;
            float2 _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3;
            Unity_TilingAndOffset_float(_Property_54a14c25195a3c86a689d49986f1212e_Out_0, float2 (1, 1), float2 (0, 0), _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3);
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_R_1 = _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3[0];
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_G_2 = _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3[1];
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_B_3 = 0;
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_A_4 = 0;
            float2 _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0 = Vector2_85052A8F;
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_R_1 = _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0[0];
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_G_2 = _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0[1];
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_B_3 = 0;
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_A_4 = 0;
            float _Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2;
            Unity_Multiply_float(_Split_0fd2f5c53cc80d899e631ff367b5d8e4_G_2, _Split_489e4ed0020dbe85b4535e2ca64277f3_G_2, _Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2);
            float _Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2;
            Unity_Multiply_float(_Split_0fd2f5c53cc80d899e631ff367b5d8e4_R_1, _Split_489e4ed0020dbe85b4535e2ca64277f3_R_1, _Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2);
            float _Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2;
            Unity_Multiply_float(_Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2, 6.283185, _Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2);
            float _Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1;
            Unity_Sine_float(_Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2, _Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1);
            float _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3;
            Unity_Remap_float(_Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3);
            float _Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2;
            Unity_Subtract_float(_Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2, _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3, _Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2);
            float _Round_51fe680732c14c86b5184256fc275258_Out_1;
            Unity_Round_float(_Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2, _Round_51fe680732c14c86b5184256fc275258_Out_1);
            float _Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2;
            Unity_Subtract_float(_Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2, _Round_51fe680732c14c86b5184256fc275258_Out_1, _Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2);
            float _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1;
            Unity_Absolute_float(_Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2, _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1);
            float _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3;
            Unity_Smoothstep_float(0.25, 0.3, _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1, _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3);
            OutVector1_1 = _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float4 SpriteColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_160d343efd900f83805bd5bf910c3e2e_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_f414611e2633ce8eae3ae8d0ebd61ef0_Out_0 = IN.uv0;
            Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_861f84dfebbb74859b02411b2da06a9f;
            float4 _QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_R_2;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_G_3;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_B_4;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_A_5;
            SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), _Property_160d343efd900f83805bd5bf910c3e2e_Out_0, (_UV_f414611e2633ce8eae3ae8d0ebd61ef0_Out_0.xy), _QTexture2D_861f84dfebbb74859b02411b2da06a9f, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_R_2, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_G_3, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_B_4, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_A_5);
            float4 _ScreenPosition_596f54782917158c8ca15d4a2728b708_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3;
            Unity_Rotate_Radians_float((_ScreenPosition_596f54782917158c8ca15d4a2728b708_Out_0.xy), float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3);
            float2 _Property_89ae66dc2a550d8fa955888a474246f3_Out_0 = Vector2_6A46D00F;
            Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da _QWaveBack_99926a5b23c2b58ca1ae6285d890172d;
            float _QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1;
            SG_QWaveBack_08a913e1b4ae3e342a78aa488653d6da(_Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3, _Property_89ae66dc2a550d8fa955888a474246f3_Out_0, _QWaveBack_99926a5b23c2b58ca1ae6285d890172d, _QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1);
            float4 _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2;
            Unity_Multiply_float(_QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1, (_QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1.xxxx), _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2);
            surface.BaseColor = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.SpriteColor = _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            #define UNIVERSAL_USELEGACYSPRITEBLOCKS
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SPRITEFORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float4 texCoord0;
            float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float4 uv0;
        };
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            float3 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
            float4 interp2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

            PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float2 Vector2_6A46D00F;
        float Vector1_47F7ACA7;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        float4 _MainTex_TexelSize;

            // Graph Functions
            
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Step_float2(float2 Edge, float2 In, out float2 Out)
        {
            Out = step(Edge, In);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
        {
        };

        void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, UnityTexture2D Texture2D_CA72CD38, float2 Vector2_F19B6F36, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1, out float R_2, out float G_3, out float B_4, out float A_5)
        {
            UnityTexture2D _Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0 = Texture2D_CA72CD38;
            float2 _Property_10f7dba9ddb54aba84adb08a27e022b0_Out_0 = Vector2_F19B6F36;
            float4 _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0 = Vector4_19C7703B;
            float _Split_117dfb2a277c4a979671228912a2d2f1_R_1 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[0];
            float _Split_117dfb2a277c4a979671228912a2d2f1_G_2 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[1];
            float _Split_117dfb2a277c4a979671228912a2d2f1_B_3 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[2];
            float _Split_117dfb2a277c4a979671228912a2d2f1_A_4 = _Property_15c92b40551a40d6a2f78b35caabd18e_Out_0[3];
            float2 _Vector2_9c22647769ea4c96af77199c7f700b00_Out_0 = float2(_Split_117dfb2a277c4a979671228912a2d2f1_R_1, _Split_117dfb2a277c4a979671228912a2d2f1_G_2);
            float2 _Vector2_729da08c140e4f0db6fd3c2399651a00_Out_0 = float2(_Split_117dfb2a277c4a979671228912a2d2f1_B_3, _Split_117dfb2a277c4a979671228912a2d2f1_A_4);
            float2 _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3;
            Unity_TilingAndOffset_float(_Property_10f7dba9ddb54aba84adb08a27e022b0_Out_0, _Vector2_9c22647769ea4c96af77199c7f700b00_Out_0, _Vector2_729da08c140e4f0db6fd3c2399651a00_Out_0, _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3);
            float4 _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0.tex, _Property_c20210f75e5841c8b4b7250cc2e4321e_Out_0.samplerstate, _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3);
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_R_4 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.r;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_G_5 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.g;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_B_6 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.b;
            float _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_A_7 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0.a;
            float _Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1;
            Unity_Preview_float(_SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_A_7, _Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1);
            float2 _Step_74b80af085fb44dab793b8aebd02e674_Out_2;
            Unity_Step_float2(float2(0, 0), _TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3, _Step_74b80af085fb44dab793b8aebd02e674_Out_2);
            float2 _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2;
            Unity_Step_float2(_TilingAndOffset_b05b63825f704a14b2b9d1484b21393e_Out_3, float2(1, 1), _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2);
            float2 _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2;
            Unity_Multiply_float(_Step_74b80af085fb44dab793b8aebd02e674_Out_2, _Step_cfc0107733af4fbab0e5b4ffd1a8c95b_Out_2, _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2);
            float _Split_41b59f89add144378ab7e9985e715d68_R_1 = _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2[0];
            float _Split_41b59f89add144378ab7e9985e715d68_G_2 = _Multiply_daacb5e105374afab1c4f7ac68f4c3ae_Out_2[1];
            float _Split_41b59f89add144378ab7e9985e715d68_B_3 = 0;
            float _Split_41b59f89add144378ab7e9985e715d68_A_4 = 0;
            float _Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2;
            Unity_Multiply_float(_Preview_49bd68e7bd714c78ab709ed19049b7ff_Out_1, _Split_41b59f89add144378ab7e9985e715d68_R_1, _Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2);
            float _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2;
            Unity_Multiply_float(_Multiply_4a5f7cee40424bd4968573d70b63d22d_Out_2, _Split_41b59f89add144378ab7e9985e715d68_G_2, _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2);
            Output_1 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_RGBA_0;
            R_2 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_R_4;
            G_3 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_G_5;
            B_4 = _SampleTexture2D_0c8b2fbf56fc4753ad68f3c49c1b895d_B_6;
            A_5 = _Multiply_9c1d6ef3beeb45f9ae8fc5f2c61ead2a_Out_2;
        }

        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);

            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;

            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;

            Out = UV;
        }

        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Round_float(float In, out float Out)
        {
            Out = round(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        struct Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da
        {
        };

        void SG_QWaveBack_08a913e1b4ae3e342a78aa488653d6da(float2 Vector2_7C225E21, float2 Vector2_85052A8F, Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da IN, out float OutVector1_1)
        {
            float2 _Property_54a14c25195a3c86a689d49986f1212e_Out_0 = Vector2_7C225E21;
            float2 _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3;
            Unity_TilingAndOffset_float(_Property_54a14c25195a3c86a689d49986f1212e_Out_0, float2 (1, 1), float2 (0, 0), _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3);
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_R_1 = _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3[0];
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_G_2 = _TilingAndOffset_e6a722605303a2829ee27007189d2f2c_Out_3[1];
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_B_3 = 0;
            float _Split_0fd2f5c53cc80d899e631ff367b5d8e4_A_4 = 0;
            float2 _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0 = Vector2_85052A8F;
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_R_1 = _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0[0];
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_G_2 = _Property_ac931a0f440fed8a841f89d5b698cbf7_Out_0[1];
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_B_3 = 0;
            float _Split_489e4ed0020dbe85b4535e2ca64277f3_A_4 = 0;
            float _Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2;
            Unity_Multiply_float(_Split_0fd2f5c53cc80d899e631ff367b5d8e4_G_2, _Split_489e4ed0020dbe85b4535e2ca64277f3_G_2, _Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2);
            float _Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2;
            Unity_Multiply_float(_Split_0fd2f5c53cc80d899e631ff367b5d8e4_R_1, _Split_489e4ed0020dbe85b4535e2ca64277f3_R_1, _Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2);
            float _Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2;
            Unity_Multiply_float(_Multiply_dc559f7a4353ab8f94a19e6c23d9c039_Out_2, 6.283185, _Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2);
            float _Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1;
            Unity_Sine_float(_Multiply_32a166c2de17d78cabfce46eae3d77d8_Out_2, _Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1);
            float _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3;
            Unity_Remap_float(_Sine_b9118bfcdbcd3682ac95d6039e0733f8_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3);
            float _Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2;
            Unity_Subtract_float(_Multiply_54a8199f837ee788ab00a47f40299b8e_Out_2, _Remap_ac60059380dc5d8f8d3db879ae929ee3_Out_3, _Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2);
            float _Round_51fe680732c14c86b5184256fc275258_Out_1;
            Unity_Round_float(_Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2, _Round_51fe680732c14c86b5184256fc275258_Out_1);
            float _Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2;
            Unity_Subtract_float(_Subtract_2c6b3c82b8904d8aaa88b05d7bf23fda_Out_2, _Round_51fe680732c14c86b5184256fc275258_Out_1, _Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2);
            float _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1;
            Unity_Absolute_float(_Subtract_ca44801eeef22784aa7899c11a768bc0_Out_2, _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1);
            float _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3;
            Unity_Smoothstep_float(0.25, 0.3, _Absolute_ef0c80beff9ace8bbad059632ed57917_Out_1, _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3);
            OutVector1_1 = _Smoothstep_9435ae35d1ce928e85a27010cb35bc32_Out_3;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float4 SpriteColor;
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_160d343efd900f83805bd5bf910c3e2e_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_f414611e2633ce8eae3ae8d0ebd61ef0_Out_0 = IN.uv0;
            Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_861f84dfebbb74859b02411b2da06a9f;
            float4 _QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_R_2;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_G_3;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_B_4;
            float _QTexture2D_861f84dfebbb74859b02411b2da06a9f_A_5;
            SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), _Property_160d343efd900f83805bd5bf910c3e2e_Out_0, (_UV_f414611e2633ce8eae3ae8d0ebd61ef0_Out_0.xy), _QTexture2D_861f84dfebbb74859b02411b2da06a9f, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_R_2, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_G_3, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_B_4, _QTexture2D_861f84dfebbb74859b02411b2da06a9f_A_5);
            float4 _ScreenPosition_596f54782917158c8ca15d4a2728b708_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3;
            Unity_Rotate_Radians_float((_ScreenPosition_596f54782917158c8ca15d4a2728b708_Out_0.xy), float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3);
            float2 _Property_89ae66dc2a550d8fa955888a474246f3_Out_0 = Vector2_6A46D00F;
            Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da _QWaveBack_99926a5b23c2b58ca1ae6285d890172d;
            float _QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1;
            SG_QWaveBack_08a913e1b4ae3e342a78aa488653d6da(_Rotate_ed566af72281ce8e9ff6e7ae74afab24_Out_3, _Property_89ae66dc2a550d8fa955888a474246f3_Out_0, _QWaveBack_99926a5b23c2b58ca1ae6285d890172d, _QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1);
            float4 _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2;
            Unity_Multiply_float(_QTexture2D_861f84dfebbb74859b02411b2da06a9f_Output_1, (_QWaveBack_99926a5b23c2b58ca1ae6285d890172d_OutVector1_1.xxxx), _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2);
            surface.BaseColor = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.SpriteColor = _Multiply_98011d8908604685baaf5d2836a89bcb_Out_2;
            surface.Alpha = 1;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





            output.WorldSpacePosition =          input.positionWS;
            output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 =                         input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"

            ENDHLSL
        }
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}