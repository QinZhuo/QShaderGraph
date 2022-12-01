Shader "QShaderGraph/QinearImageUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
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
            float3 ObjectSpacePosition;
            float4 uv0;
            float4 VertexColor;
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
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        float4 _MainTex_TexelSize;
        float4 _ClipRect;
        float _UIMaskSoftnessX;
        float _UIMaskSoftnessY;

            // Graph Functions
            
        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }

        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float2(float2 In, out float2 Out)
        {
            Out = saturate(In);
        }

        struct Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3
        {
            float3 ObjectSpacePosition;
        };

        void SG_QUIMask_91d825b81706fe2429ed93b06cfe0ed3(float4 Vector4_9e9a63f94d3b457a9e03db85d6107f59, float Vector1_dddd78b7411b4699855db2341d9a91c8, float Vector1_86ab507b5cff4cb787f36eb94d8985b8, Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3 IN, out float A_1)
        {
            float4 _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0 = Vector4_9e9a63f94d3b457a9e03db85d6107f59;
            float _Split_3586f1b88ce9496794eb839812ba56a6_R_1 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[0];
            float _Split_3586f1b88ce9496794eb839812ba56a6_G_2 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[1];
            float _Split_3586f1b88ce9496794eb839812ba56a6_B_3 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[2];
            float _Split_3586f1b88ce9496794eb839812ba56a6_A_4 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[3];
            float2 _Vector2_93616aa0a1394f5292488bc5729ccdb6_Out_0 = float2(_Split_3586f1b88ce9496794eb839812ba56a6_B_3, _Split_3586f1b88ce9496794eb839812ba56a6_A_4);
            float2 _Vector2_c9ee43b862d0402caf7f8710daed5268_Out_0 = float2(_Split_3586f1b88ce9496794eb839812ba56a6_R_1, _Split_3586f1b88ce9496794eb839812ba56a6_G_2);
            float2 _Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2;
            Unity_Subtract_float2(_Vector2_93616aa0a1394f5292488bc5729ccdb6_Out_0, _Vector2_c9ee43b862d0402caf7f8710daed5268_Out_0, _Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2);
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_R_1 = IN.ObjectSpacePosition[0];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_G_2 = IN.ObjectSpacePosition[1];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_B_3 = IN.ObjectSpacePosition[2];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_A_4 = 0;
            float2 _Vector2_de5dd766be354c8796f84929c5c149de_Out_0 = float2(_Split_7f08b0f377784fa4ab751c03a9ff18b1_R_1, _Split_7f08b0f377784fa4ab751c03a9ff18b1_G_2);
            float2 _Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2;
            Unity_Multiply_float(_Vector2_de5dd766be354c8796f84929c5c149de_Out_0, float2(2, 2), _Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2);
            float _Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2;
            Unity_Power_float(10, 10, _Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2);
            float _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2;
            Unity_Multiply_float(_Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2, 2, _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2);
            float _Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2;
            Unity_Multiply_float(-1, _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2, _Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2);
            float4 _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3;
            Unity_Clamp_float4(_Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0, (_Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2.xxxx), (_Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2.xxxx), _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3);
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_R_1 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[0];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_G_2 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[1];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_B_3 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[2];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_A_4 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[3];
            float2 _Vector2_e6ad121ba16f4b82b04b58c01152ff31_Out_0 = float2(_Split_ce3eb7b3317d45b2a83bd71b9f9940c8_R_1, _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_G_2);
            float2 _Vector2_4dc0c74f639a47b9a98e9ec9b2c92d33_Out_0 = float2(_Split_ce3eb7b3317d45b2a83bd71b9f9940c8_B_3, _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_A_4);
            float2 _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2;
            Unity_Add_float2(_Vector2_e6ad121ba16f4b82b04b58c01152ff31_Out_0, _Vector2_4dc0c74f639a47b9a98e9ec9b2c92d33_Out_0, _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2);
            float2 _Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2;
            Unity_Subtract_float2(_Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2, _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2, _Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2);
            float2 _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1;
            Unity_Absolute_float2(_Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2, _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1);
            float2 _Subtract_8dab3d33d983411f80880b5665b65594_Out_2;
            Unity_Subtract_float2(_Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2, _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1, _Subtract_8dab3d33d983411f80880b5665b65594_Out_2);
            float _Float_60f6cb6d96d54528a8d0474d21c87136_Out_0 = 0.25;
            float _Property_25347efbb3b2430182a09c6da463acff_Out_0 = Vector1_dddd78b7411b4699855db2341d9a91c8;
            float _Property_3991f5a389c949d2b481c1757ef9ef3b_Out_0 = Vector1_86ab507b5cff4cb787f36eb94d8985b8;
            float2 _Vector2_a0346c4779b94d4d9cbe2b7d30248e9d_Out_0 = float2(_Property_25347efbb3b2430182a09c6da463acff_Out_0, _Property_3991f5a389c949d2b481c1757ef9ef3b_Out_0);
            float2 _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2;
            Unity_Multiply_float(_Vector2_a0346c4779b94d4d9cbe2b7d30248e9d_Out_0, (_Float_60f6cb6d96d54528a8d0474d21c87136_Out_0.xx), _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2);
            float2 _Divide_a0cbda8637d94274aa41849290c55218_Out_2;
            Unity_Divide_float2((_Float_60f6cb6d96d54528a8d0474d21c87136_Out_0.xx), _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2, _Divide_a0cbda8637d94274aa41849290c55218_Out_2);
            float2 _Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2;
            Unity_Multiply_float(_Subtract_8dab3d33d983411f80880b5665b65594_Out_2, _Divide_a0cbda8637d94274aa41849290c55218_Out_2, _Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2);
            float2 _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1;
            Unity_Saturate_float2(_Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2, _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1);
            float _Split_db05b4da577c4593ab99b5634913ec67_R_1 = _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1[0];
            float _Split_db05b4da577c4593ab99b5634913ec67_G_2 = _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1[1];
            float _Split_db05b4da577c4593ab99b5634913ec67_B_3 = 0;
            float _Split_db05b4da577c4593ab99b5634913ec67_A_4 = 0;
            float _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2;
            Unity_Multiply_float(_Split_db05b4da577c4593ab99b5634913ec67_R_1, _Split_db05b4da577c4593ab99b5634913ec67_G_2, _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2);
            A_1 = _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2;
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
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0.tex, _Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_R_4 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.r;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_G_5 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.g;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_B_6 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.b;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_A_7 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.a;
            float4 _Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2;
            Unity_Multiply_float(IN.VertexColor, _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0, _Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2);
            float _Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2;
            Unity_Power_float(_SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_A_7, 2.2, _Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2);
            float4 _Property_5999e6927e9f42bdb6c1e38acd18ebd3_Out_0 = _ClipRect;
            float _Property_26d10539e3784c989c193436fa725a2d_Out_0 = _UIMaskSoftnessX;
            float _Property_8a41145eb4b84e16908d1ad555bf58bb_Out_0 = _UIMaskSoftnessY;
            Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3 _QUIMask_f38f9e4239fa491195505e7f33ee5637;
            _QUIMask_f38f9e4239fa491195505e7f33ee5637.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1;
            SG_QUIMask_91d825b81706fe2429ed93b06cfe0ed3(_Property_5999e6927e9f42bdb6c1e38acd18ebd3_Out_0, _Property_26d10539e3784c989c193436fa725a2d_Out_0, _Property_8a41145eb4b84e16908d1ad555bf58bb_Out_0, _QUIMask_f38f9e4239fa491195505e7f33ee5637, _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1);
            float _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2;
            Unity_Multiply_float(_Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2, _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1, _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2);
            surface.BaseColor = (_Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2.xyz);
            surface.Alpha = _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2;
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





            output.ObjectSpacePosition =         TransformWorldToObject(input.positionWS);
            output.uv0 =                         input.texCoord0;
            output.VertexColor =                 input.color;
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
            float3 ObjectSpacePosition;
            float4 uv0;
            float4 VertexColor;
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
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        float4 _MainTex_TexelSize;
        float4 _ClipRect;
        float _UIMaskSoftnessX;
        float _UIMaskSoftnessY;

            // Graph Functions
            
        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }

        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float2(float2 In, out float2 Out)
        {
            Out = saturate(In);
        }

        struct Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3
        {
            float3 ObjectSpacePosition;
        };

        void SG_QUIMask_91d825b81706fe2429ed93b06cfe0ed3(float4 Vector4_9e9a63f94d3b457a9e03db85d6107f59, float Vector1_dddd78b7411b4699855db2341d9a91c8, float Vector1_86ab507b5cff4cb787f36eb94d8985b8, Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3 IN, out float A_1)
        {
            float4 _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0 = Vector4_9e9a63f94d3b457a9e03db85d6107f59;
            float _Split_3586f1b88ce9496794eb839812ba56a6_R_1 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[0];
            float _Split_3586f1b88ce9496794eb839812ba56a6_G_2 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[1];
            float _Split_3586f1b88ce9496794eb839812ba56a6_B_3 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[2];
            float _Split_3586f1b88ce9496794eb839812ba56a6_A_4 = _Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0[3];
            float2 _Vector2_93616aa0a1394f5292488bc5729ccdb6_Out_0 = float2(_Split_3586f1b88ce9496794eb839812ba56a6_B_3, _Split_3586f1b88ce9496794eb839812ba56a6_A_4);
            float2 _Vector2_c9ee43b862d0402caf7f8710daed5268_Out_0 = float2(_Split_3586f1b88ce9496794eb839812ba56a6_R_1, _Split_3586f1b88ce9496794eb839812ba56a6_G_2);
            float2 _Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2;
            Unity_Subtract_float2(_Vector2_93616aa0a1394f5292488bc5729ccdb6_Out_0, _Vector2_c9ee43b862d0402caf7f8710daed5268_Out_0, _Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2);
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_R_1 = IN.ObjectSpacePosition[0];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_G_2 = IN.ObjectSpacePosition[1];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_B_3 = IN.ObjectSpacePosition[2];
            float _Split_7f08b0f377784fa4ab751c03a9ff18b1_A_4 = 0;
            float2 _Vector2_de5dd766be354c8796f84929c5c149de_Out_0 = float2(_Split_7f08b0f377784fa4ab751c03a9ff18b1_R_1, _Split_7f08b0f377784fa4ab751c03a9ff18b1_G_2);
            float2 _Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2;
            Unity_Multiply_float(_Vector2_de5dd766be354c8796f84929c5c149de_Out_0, float2(2, 2), _Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2);
            float _Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2;
            Unity_Power_float(10, 10, _Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2);
            float _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2;
            Unity_Multiply_float(_Power_e263bebe48a54ce4a3a131f1dee0baba_Out_2, 2, _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2);
            float _Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2;
            Unity_Multiply_float(-1, _Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2, _Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2);
            float4 _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3;
            Unity_Clamp_float4(_Property_09f77b14cff54f978fd350dea3ccc4e6_Out_0, (_Multiply_b34d1a94090b4b4b8822d7b47e3f4f86_Out_2.xxxx), (_Multiply_ccd3cf18bc1d41dba16e36b3406c590f_Out_2.xxxx), _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3);
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_R_1 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[0];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_G_2 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[1];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_B_3 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[2];
            float _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_A_4 = _Clamp_7eea23aa825747138cbcb6e33f9ee670_Out_3[3];
            float2 _Vector2_e6ad121ba16f4b82b04b58c01152ff31_Out_0 = float2(_Split_ce3eb7b3317d45b2a83bd71b9f9940c8_R_1, _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_G_2);
            float2 _Vector2_4dc0c74f639a47b9a98e9ec9b2c92d33_Out_0 = float2(_Split_ce3eb7b3317d45b2a83bd71b9f9940c8_B_3, _Split_ce3eb7b3317d45b2a83bd71b9f9940c8_A_4);
            float2 _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2;
            Unity_Add_float2(_Vector2_e6ad121ba16f4b82b04b58c01152ff31_Out_0, _Vector2_4dc0c74f639a47b9a98e9ec9b2c92d33_Out_0, _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2);
            float2 _Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2;
            Unity_Subtract_float2(_Multiply_e11b9ae6576f45608cb94ff403c0a09d_Out_2, _Add_5be7bd38fb6043e7a49439da010f31b0_Out_2, _Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2);
            float2 _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1;
            Unity_Absolute_float2(_Subtract_4460f373cd4646a1aa3348201ab69aec_Out_2, _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1);
            float2 _Subtract_8dab3d33d983411f80880b5665b65594_Out_2;
            Unity_Subtract_float2(_Subtract_6f4b80a88ac64e9193517b40a0dc2501_Out_2, _Absolute_e1fd693e0ad94e71bab0b24c2adc23a1_Out_1, _Subtract_8dab3d33d983411f80880b5665b65594_Out_2);
            float _Float_60f6cb6d96d54528a8d0474d21c87136_Out_0 = 0.25;
            float _Property_25347efbb3b2430182a09c6da463acff_Out_0 = Vector1_dddd78b7411b4699855db2341d9a91c8;
            float _Property_3991f5a389c949d2b481c1757ef9ef3b_Out_0 = Vector1_86ab507b5cff4cb787f36eb94d8985b8;
            float2 _Vector2_a0346c4779b94d4d9cbe2b7d30248e9d_Out_0 = float2(_Property_25347efbb3b2430182a09c6da463acff_Out_0, _Property_3991f5a389c949d2b481c1757ef9ef3b_Out_0);
            float2 _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2;
            Unity_Multiply_float(_Vector2_a0346c4779b94d4d9cbe2b7d30248e9d_Out_0, (_Float_60f6cb6d96d54528a8d0474d21c87136_Out_0.xx), _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2);
            float2 _Divide_a0cbda8637d94274aa41849290c55218_Out_2;
            Unity_Divide_float2((_Float_60f6cb6d96d54528a8d0474d21c87136_Out_0.xx), _Multiply_cc4af999df8348e090be958493f3f3f0_Out_2, _Divide_a0cbda8637d94274aa41849290c55218_Out_2);
            float2 _Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2;
            Unity_Multiply_float(_Subtract_8dab3d33d983411f80880b5665b65594_Out_2, _Divide_a0cbda8637d94274aa41849290c55218_Out_2, _Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2);
            float2 _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1;
            Unity_Saturate_float2(_Multiply_4e4d0d6aded749c0bd82fa42bd61aaac_Out_2, _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1);
            float _Split_db05b4da577c4593ab99b5634913ec67_R_1 = _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1[0];
            float _Split_db05b4da577c4593ab99b5634913ec67_G_2 = _Saturate_b7418df615be46ef87c1fcaafe40d4a7_Out_1[1];
            float _Split_db05b4da577c4593ab99b5634913ec67_B_3 = 0;
            float _Split_db05b4da577c4593ab99b5634913ec67_A_4 = 0;
            float _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2;
            Unity_Multiply_float(_Split_db05b4da577c4593ab99b5634913ec67_R_1, _Split_db05b4da577c4593ab99b5634913ec67_G_2, _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2);
            A_1 = _Multiply_fb98873734e94ca3b1ff2bf524a1f838_Out_2;
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
            float Alpha;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0.tex, _Property_58c45f8de8cd4e058e536cc75c5a9a68_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_R_4 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.r;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_G_5 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.g;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_B_6 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.b;
            float _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_A_7 = _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0.a;
            float4 _Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2;
            Unity_Multiply_float(IN.VertexColor, _SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_RGBA_0, _Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2);
            float _Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2;
            Unity_Power_float(_SampleTexture2D_7b7c4a2e559f401bb9fbd4af5770d46c_A_7, 2.2, _Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2);
            float4 _Property_5999e6927e9f42bdb6c1e38acd18ebd3_Out_0 = _ClipRect;
            float _Property_26d10539e3784c989c193436fa725a2d_Out_0 = _UIMaskSoftnessX;
            float _Property_8a41145eb4b84e16908d1ad555bf58bb_Out_0 = _UIMaskSoftnessY;
            Bindings_QUIMask_91d825b81706fe2429ed93b06cfe0ed3 _QUIMask_f38f9e4239fa491195505e7f33ee5637;
            _QUIMask_f38f9e4239fa491195505e7f33ee5637.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1;
            SG_QUIMask_91d825b81706fe2429ed93b06cfe0ed3(_Property_5999e6927e9f42bdb6c1e38acd18ebd3_Out_0, _Property_26d10539e3784c989c193436fa725a2d_Out_0, _Property_8a41145eb4b84e16908d1ad555bf58bb_Out_0, _QUIMask_f38f9e4239fa491195505e7f33ee5637, _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1);
            float _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2;
            Unity_Multiply_float(_Power_0433151c52e34aeab5a53aa5413cbf0c_Out_2, _QUIMask_f38f9e4239fa491195505e7f33ee5637_A_1, _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2);
            surface.BaseColor = (_Multiply_e305952d12b249e2a6a74cde79cc88b9_Out_2.xyz);
            surface.Alpha = _Multiply_65f44f9beaa64eae817dd20189a7ced2_Out_2;
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





            output.ObjectSpacePosition =         TransformWorldToObject(input.positionWS);
            output.uv0 =                         input.texCoord0;
            output.VertexColor =                 input.color;
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