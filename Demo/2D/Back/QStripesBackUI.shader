Shader "QShaderGraph/QStripesBackUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
        Vector1_47F7ACA7("Rotate", Float) = 45
        Vector1_15CFC491("Blur", Float) = 0.1
        _Count("Count", Float) = 10
        _Interval("Interval", Float) = 0.5
        Vector2_d60465f4888c492c8072ddeb7f5f83df("Offset", Vector) = (0.1, 0, 0, 0)
        Color_088ca070316743738fb6e3f6f9db4dbe("Color", Color) = (1, 0, 0, 1)
        Vector2_3472e8c0d099492a914d4f245377518f("Move", Vector) = (0, 0, 0, 0)
        Vector1_f6cf94e9df274e4fa7cc9d16f93e3869("BlurOffset", Float) = 0
        Vector1_d4a2b14c61f44492a550f288e33f8a5a("WidthDivHeight", Float) = 1
        Color_b4a2e7be4f9843dc8e67f85c86107869("ShadowColor", Color) = (0, 0, 0, 0.5019608)
        _ClipRect("ClipRect", Vector) = (0, 0, 0, 0)
        _UIMaskSoftnessX("UIMaskSoftnessX", Float) = 0
        _UIMaskSoftnessY("UIMaskSoftnessY", Float) = 0
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
            float3 TimeParameters;
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
        float Vector1_47F7ACA7;
        float Vector1_15CFC491;
        float _Count;
        float _Interval;
        float2 Vector2_d60465f4888c492c8072ddeb7f5f83df;
        float4 Color_088ca070316743738fb6e3f6f9db4dbe;
        float2 Vector2_3472e8c0d099492a914d4f245377518f;
        float Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
        float Vector1_d4a2b14c61f44492a550f288e33f8a5a;
        float4 Color_b4a2e7be4f9843dc8e67f85c86107869;
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
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        struct Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a
        {
        };

        void SG_QOffset8_4da89322f12c77d4a89ed7a4cf67121a(float2 Vector2_72a2395e9c314f42b17fe8dddb805b21, float2 Vector2_b6b5026fd3624df78fd6643871513657, Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a IN, out float2 Center_5, out float2 Right_3, out float2 Up_2, out float2 Left_1, out float2 Donw_4, out float2 RU_6, out float2 LU_7, out float2 LD_8, out float2 RD_9)
        {
            float2 _Property_105630cb6ab64abbb2149b40ace92428_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Property_cae2c7a072734db881bcbaea766c4309_Out_0 = Vector2_b6b5026fd3624df78fd6643871513657;
            float2 _Multiply_16fa0fce97294db0919ae61219c07295_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 0), _Multiply_16fa0fce97294db0919ae61219c07295_Out_2);
            float2 _Add_8b992d602b8b4ccb98179a202382e577_Out_2;
            Unity_Add_float2(_Multiply_16fa0fce97294db0919ae61219c07295_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_8b992d602b8b4ccb98179a202382e577_Out_2);
            float2 _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, 1), _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2);
            float2 _Add_329164cae0284725a423dd7a9ec01e8e_Out_2;
            Unity_Add_float2(_Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_329164cae0284725a423dd7a9ec01e8e_Out_2);
            float2 _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 0), _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2);
            float2 _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2;
            Unity_Add_float2(_Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2);
            float2 _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, -1), _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2);
            float2 _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2;
            Unity_Add_float2(_Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2);
            float2 _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 1), _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2);
            float2 _Property_a0f2227860af45f497a5843cf2d8e256_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2;
            Unity_Add_float2(_Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2);
            float2 _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 1), _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2);
            float2 _Add_971908af74f847f0a094d1bccda582e7_Out_2;
            Unity_Add_float2(_Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_971908af74f847f0a094d1bccda582e7_Out_2);
            float2 _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, -1), _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2);
            float2 _Add_e99297a34f54418ab38fc54941a987e4_Out_2;
            Unity_Add_float2(_Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_e99297a34f54418ab38fc54941a987e4_Out_2);
            float2 _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, -1), _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2);
            float2 _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2;
            Unity_Add_float2(_Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2);
            Center_5 = _Property_105630cb6ab64abbb2149b40ace92428_Out_0;
            Right_3 = _Add_8b992d602b8b4ccb98179a202382e577_Out_2;
            Up_2 = _Add_329164cae0284725a423dd7a9ec01e8e_Out_2;
            Left_1 = _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2;
            Donw_4 = _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2;
            RU_6 = _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2;
            LU_7 = _Add_971908af74f847f0a094d1bccda582e7_Out_2;
            LD_8 = _Add_e99297a34f54418ab38fc54941a987e4_Out_2;
            RD_9 = _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2;
        }

        struct Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5
        {
        };

        void SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(UnityTexture2D Texture2D_12575de54bba496f8874f55aff87c674, float2 Vector2_33c1b9041c6e4490b29de89a7bf80778, float2 Vector2_15a231d9767840ecbff1a7b16f6c36a0, Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 IN, out float4 Center_5, out float4 Right_1, out float4 Up_2, out float4 Left_3, out float4 Down_4, out float4 RU_6, out float4 LU_7, out float4 LD_8, out float4 RD_9)
        {
            UnityTexture2D _Property_ff08134fe20a416791b29f6acad07fd6_Out_0 = Texture2D_12575de54bba496f8874f55aff87c674;
            float2 _Property_8bbe98442c294e8e8826ea57748cdaf1_Out_0 = Vector2_33c1b9041c6e4490b29de89a7bf80778;
            float2 _Property_2ddd924c88f546f099b312f2f3304f64_Out_0 = Vector2_15a231d9767840ecbff1a7b16f6c36a0;
            Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a _QOffset8_0873cd0059084739b664769a027f83a5;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Center_5;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Right_3;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Up_2;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Left_1;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_RU_6;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_LU_7;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_LD_8;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_RD_9;
            SG_QOffset8_4da89322f12c77d4a89ed7a4cf67121a(_Property_8bbe98442c294e8e8826ea57748cdaf1_Out_0, _Property_2ddd924c88f546f099b312f2f3304f64_Out_0, _QOffset8_0873cd0059084739b664769a027f83a5, _QOffset8_0873cd0059084739b664769a027f83a5_Center_5, _QOffset8_0873cd0059084739b664769a027f83a5_Right_3, _QOffset8_0873cd0059084739b664769a027f83a5_Up_2, _QOffset8_0873cd0059084739b664769a027f83a5_Left_1, _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4, _QOffset8_0873cd0059084739b664769a027f83a5_RU_6, _QOffset8_0873cd0059084739b664769a027f83a5_LU_7, _QOffset8_0873cd0059084739b664769a027f83a5_LD_8, _QOffset8_0873cd0059084739b664769a027f83a5_RD_9);
            float4 _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Center_5);
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_R_4 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.r;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_G_5 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.g;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_B_6 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.b;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_A_7 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.a;
            float4 _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Right_3);
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_R_4 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.r;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_G_5 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.g;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_B_6 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.b;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_A_7 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.a;
            float4 _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Up_2);
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_R_4 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.r;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_G_5 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.g;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_B_6 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.b;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_A_7 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.a;
            float4 _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Left_1);
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_R_4 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.r;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_G_5 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.g;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_B_6 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.b;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_A_7 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.a;
            float4 _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4);
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_R_4 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.r;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_G_5 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.g;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_B_6 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.b;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_A_7 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.a;
            float4 _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_RU_6);
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_R_4 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.r;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_G_5 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.g;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_B_6 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.b;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_A_7 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.a;
            float4 _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_LU_7);
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_R_4 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.r;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_G_5 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.g;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_B_6 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.b;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_A_7 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.a;
            float4 _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_LD_8);
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_R_4 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.r;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_G_5 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.g;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_B_6 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.b;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_A_7 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.a;
            float4 _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_RD_9);
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_R_4 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.r;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_G_5 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.g;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_B_6 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.b;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_A_7 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.a;
            Center_5 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0;
            Right_1 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0;
            Up_2 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0;
            Left_3 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0;
            Down_4 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0;
            RU_6 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0;
            LU_7 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0;
            LD_8 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0;
            RD_9 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }

        struct Bindings_QBlur_82c178bc71d4d7544903c365250ab883
        {
        };

        void SG_QBlur_82c178bc71d4d7544903c365250ab883(float2 Vector2_f4f81b69e9e24900b2a35165159c5c07, UnityTexture2D Texture2D_47023485, float2 Vector2_103a21721560482aa6c7bc3c67ee7f37, Bindings_QBlur_82c178bc71d4d7544903c365250ab883 IN, out float4 Output_1)
        {
            UnityTexture2D _Property_6ff64ebf61b339818b2070eb58512ab3_Out_0 = Texture2D_47023485;
            float2 _Property_ae789743d9dd45f191ba1fd51b1b69de_Out_0 = Vector2_103a21721560482aa6c7bc3c67ee7f37;
            float2 _Property_bd9c290d23324db9b87633b1574299e6_Out_0 = Vector2_f4f81b69e9e24900b2a35165159c5c07;
            Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9;
            SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(_Property_6ff64ebf61b339818b2070eb58512ab3_Out_0, _Property_ae789743d9dd45f191ba1fd51b1b69de_Out_0, _Property_bd9c290d23324db9b87633b1574299e6_Out_0, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9);
            float4 _Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1, _Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2);
            float4 _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3, _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2);
            float4 _Add_50970554ac867785a41b3978c49b4a5a_Out_2;
            Unity_Add_float4(_Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2, _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2, _Add_50970554ac867785a41b3978c49b4a5a_Out_2);
            float4 _Add_523b939788fcde84ad30524b95fe751b_Out_2;
            Unity_Add_float4(_Add_50970554ac867785a41b3978c49b4a5a_Out_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4, _Add_523b939788fcde84ad30524b95fe751b_Out_2);
            float4 _Add_8f10b57f38914639866ef4583cfa72cf_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7, _Add_8f10b57f38914639866ef4583cfa72cf_Out_2);
            float4 _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9, _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2);
            float4 _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2;
            Unity_Add_float4(_Add_8f10b57f38914639866ef4583cfa72cf_Out_2, _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2, _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2);
            float4 _Add_383025487ae44c1e84f55f43fa7012d0_Out_2;
            Unity_Add_float4(_Add_523b939788fcde84ad30524b95fe751b_Out_2, _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2, _Add_383025487ae44c1e84f55f43fa7012d0_Out_2);
            float4 _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2;
            Unity_Divide_float4(_Add_383025487ae44c1e84f55f43fa7012d0_Out_2, float4(9, 9, 9, 9), _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2);
            Output_1 = _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2;
        }

        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
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

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
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

        struct Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7
        {
        };

        void SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(float2 Vector2_B7353A3E, float Vector1_ECABA087, float Vector1_4CF0998F, float Vector1_E78B2213, Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 IN, out float Output_1)
        {
            float _Property_3381c691d25aa18ea5985ee703881281_Out_0 = Vector1_4CF0998F;
            float _Property_8f9b8f290ab82880b0de0387a111ad33_Out_0 = Vector1_E78B2213;
            float _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2;
            Unity_Divide_float(_Property_8f9b8f290ab82880b0de0387a111ad33_Out_0, 2, _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2);
            float _Add_d858b6bd6a66708bbdda79add23899f3_Out_2;
            Unity_Add_float(_Property_3381c691d25aa18ea5985ee703881281_Out_0, _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2, _Add_d858b6bd6a66708bbdda79add23899f3_Out_2);
            float _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2;
            Unity_Divide_float(_Add_d858b6bd6a66708bbdda79add23899f3_Out_2, 2, _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2);
            float _Float_9e3727bedd1c7e86bc3fdd6bdbd95825_Out_0 = _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2;
            float _Subtract_851e407d7d674e8c9b11de15584d9040_Out_2;
            Unity_Subtract_float(_Divide_e5b419b741936785b8b5ea907d798ba7_Out_2, _Float_9e3727bedd1c7e86bc3fdd6bdbd95825_Out_0, _Subtract_851e407d7d674e8c9b11de15584d9040_Out_2);
            float2 _Property_3fdee8a215f5eb849c9da148c2159a37_Out_0 = Vector2_B7353A3E;
            float _Property_604183ba5d883a86b2db507aebad7916_Out_0 = Vector1_ECABA087;
            float2 _Vector2_bc3754a5c9666587afe082bdebc07932_Out_0 = float2(_Property_604183ba5d883a86b2db507aebad7916_Out_0, 1);
            float2 _TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3;
            Unity_TilingAndOffset_float(_Property_3fdee8a215f5eb849c9da148c2159a37_Out_0, _Vector2_bc3754a5c9666587afe082bdebc07932_Out_0, float2 (0, 0), _TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3);
            float2 _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3, _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1);
            float _Split_35a317782eaec08d85f161f41385fff3_R_1 = _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1[0];
            float _Split_35a317782eaec08d85f161f41385fff3_G_2 = _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1[1];
            float _Split_35a317782eaec08d85f161f41385fff3_B_3 = 0;
            float _Split_35a317782eaec08d85f161f41385fff3_A_4 = 0;
            float _Round_b7f112384dbba186ba940e21e84fb21b_Out_1;
            Unity_Round_float(_Split_35a317782eaec08d85f161f41385fff3_R_1, _Round_b7f112384dbba186ba940e21e84fb21b_Out_1);
            float _Subtract_8627771c222a1082a10ed465716d0c11_Out_2;
            Unity_Subtract_float(_Split_35a317782eaec08d85f161f41385fff3_R_1, _Round_b7f112384dbba186ba940e21e84fb21b_Out_1, _Subtract_8627771c222a1082a10ed465716d0c11_Out_2);
            float _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1;
            Unity_Absolute_float(_Subtract_8627771c222a1082a10ed465716d0c11_Out_2, _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1);
            float _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3;
            Unity_Smoothstep_float(_Subtract_851e407d7d674e8c9b11de15584d9040_Out_2, _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2, _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1, _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3);
            Output_1 = _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }

        void Unity_Saturate_float2(float2 In, out float2 Out)
        {
            Out = saturate(In);
        }

        struct Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3
        {
            float3 ObjectSpacePosition;
        };

        void SG_SoftMask_91d825b81706fe2429ed93b06cfe0ed3(float4 Vector4_9e9a63f94d3b457a9e03db85d6107f59, float Vector1_dddd78b7411b4699855db2341d9a91c8, float Vector1_86ab507b5cff4cb787f36eb94d8985b8, Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3 IN, out float A_1)
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
            float _Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0 = Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
            float _Property_58fa34917fc14fc39025f04bca863067_Out_0 = Vector1_d4a2b14c61f44492a550f288e33f8a5a;
            float _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2;
            Unity_Multiply_float(_Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0, _Property_58fa34917fc14fc39025f04bca863067_Out_0, _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2);
            float2 _Vector2_51212eddbdcd4650a941b3b517d0b777_Out_0 = float2(_Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0, _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2);
            UnityTexture2D _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_e84ed06367d64b298c9f3b90cb971811_Out_0 = Vector2_d60465f4888c492c8072ddeb7f5f83df;
            float4 _UV_35701ab563d84259b185b24755568117_Out_0 = IN.uv0;
            float2 _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2;
            Unity_Add_float2(_Property_e84ed06367d64b298c9f3b90cb971811_Out_0, (_UV_35701ab563d84259b185b24755568117_Out_0.xy), _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2);
            Bindings_QBlur_82c178bc71d4d7544903c365250ab883 _QBlur_a54667eda14a484eab80144e5aadc3d4;
            float4 _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1;
            SG_QBlur_82c178bc71d4d7544903c365250ab883(_Vector2_51212eddbdcd4650a941b3b517d0b777_Out_0, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2, _QBlur_a54667eda14a484eab80144e5aadc3d4, _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1);
            float _Split_51c3ba136f564621b4e73f567fde8e11_R_1 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[0];
            float _Split_51c3ba136f564621b4e73f567fde8e11_G_2 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[1];
            float _Split_51c3ba136f564621b4e73f567fde8e11_B_3 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[2];
            float _Split_51c3ba136f564621b4e73f567fde8e11_A_4 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[3];
            float4 _UV_78cd7cc893894646868bd28c7d22efb7_Out_0 = IN.uv0;
            float2 _Property_5409cc0ce3ce4fa5887720c1b8a4b8a0_Out_0 = Vector2_3472e8c0d099492a914d4f245377518f;
            float _Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0 = _Count;
            float2 _Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2;
            Unity_Divide_float2(_Property_5409cc0ce3ce4fa5887720c1b8a4b8a0_Out_0, (_Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0.xx), _Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2);
            float2 _Multiply_79dc60be511f400da58707cee8cb947c_Out_2;
            Unity_Multiply_float(_Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2, (IN.TimeParameters.x.xx), _Multiply_79dc60be511f400da58707cee8cb947c_Out_2);
            float2 _Add_3db0305b9e5d4adc84272061fa31d423_Out_2;
            Unity_Add_float2((_UV_78cd7cc893894646868bd28c7d22efb7_Out_0.xy), _Multiply_79dc60be511f400da58707cee8cb947c_Out_2, _Add_3db0305b9e5d4adc84272061fa31d423_Out_2);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3;
            Unity_Rotate_Degrees_float(_Add_3db0305b9e5d4adc84272061fa31d423_Out_2, float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3);
            float _Property_234b9571841c4b809298d823466a32b7_Out_0 = _Interval;
            float _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0 = Vector1_15CFC491;
            Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 _QStripesBack_6bd0c9728a9ce984af510be0cf309f09;
            float _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1;
            SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(_Rotate_f758e8e42488608bb8e5636f67264b34_Out_3, _Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0, _Property_234b9571841c4b809298d823466a32b7_Out_0, _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1);
            float _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
            Unity_Multiply_float(_Split_51c3ba136f564621b4e73f567fde8e11_A_4, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1, _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2);
            float4 _Property_10a5ca05efc3418883248c9b482f79db_Out_0 = Color_088ca070316743738fb6e3f6f9db4dbe;
            float4 _Multiply_ac15645f8d7949b398c326cebe513110_Out_2;
            Unity_Multiply_float((_Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2.xxxx), _Property_10a5ca05efc3418883248c9b482f79db_Out_0, _Multiply_ac15645f8d7949b398c326cebe513110_Out_2);
            float _Property_fe24fc6474c14d2387b68e616271cda5_Out_0 = Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
            float _Property_496d491dd1e6496a8cf0917e3c80875d_Out_0 = Vector1_d4a2b14c61f44492a550f288e33f8a5a;
            float _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2;
            Unity_Multiply_float(_Property_fe24fc6474c14d2387b68e616271cda5_Out_0, _Property_496d491dd1e6496a8cf0917e3c80875d_Out_0, _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2);
            float2 _Vector2_5198102118c04dcc85df80b4c35b034e_Out_0 = float2(_Property_fe24fc6474c14d2387b68e616271cda5_Out_0, _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2);
            float2 _Multiply_dcabc38199b74e8abfe6704eff785421_Out_2;
            Unity_Multiply_float(_Vector2_5198102118c04dcc85df80b4c35b034e_Out_0, float2(0.5, 0.5), _Multiply_dcabc38199b74e8abfe6704eff785421_Out_2);
            float2 _Property_9055100a06a64662b3a14826236a287f_Out_0 = Vector2_d60465f4888c492c8072ddeb7f5f83df;
            float2 _Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2;
            Unity_Multiply_float(_Property_9055100a06a64662b3a14826236a287f_Out_0, float2(0.2, 0.2), _Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2);
            float4 _UV_a9f97616ab74489fa84d038eac5fced0_Out_0 = IN.uv0;
            float2 _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2;
            Unity_Add_float2(_Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2, (_UV_a9f97616ab74489fa84d038eac5fced0_Out_0.xy), _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2);
            Bindings_QBlur_82c178bc71d4d7544903c365250ab883 _QBlur_a70ed97f574a4b9fbf802b153f986545;
            float4 _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1;
            SG_QBlur_82c178bc71d4d7544903c365250ab883(_Multiply_dcabc38199b74e8abfe6704eff785421_Out_2, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2, _QBlur_a70ed97f574a4b9fbf802b153f986545, _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1);
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_R_1 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[0];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_G_2 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[1];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_B_3 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[2];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_A_4 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[3];
            float _Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1;
            Unity_Preview_float(_Split_2cc317fb3c584c29aa407f4c8f2c2241_A_4, _Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1);
            float4 _Property_e34c7b37da624685b5cb0ba992a6a210_Out_0 = Color_b4a2e7be4f9843dc8e67f85c86107869;
            float4 _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2;
            Unity_Multiply_float((_Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1.xxxx), _Property_e34c7b37da624685b5cb0ba992a6a210_Out_0, _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2);
            float4 _Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3;
            Unity_Lerp_float4(_Multiply_ac15645f8d7949b398c326cebe513110_Out_2, _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2, (_Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1.xxxx), _Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3);
            float4 _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0 = SAMPLE_TEXTURE2D(_Property_342ae035d6dc66818de2b0f35cd2103a_Out_0.tex, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_R_4 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.r;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_G_5 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.g;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_B_6 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.b;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_A_7 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.a;
            float4 _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3;
            Unity_Lerp_float4(_Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3, _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0, (_SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_A_7.xxxx), _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3);
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_R_1 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[0];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_G_2 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[1];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_B_3 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[2];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_A_4 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[3];
            float4 _Property_e0a35baf762c4512af6d8aecf9c4079c_Out_0 = _ClipRect;
            float _Property_e8dfb6e6078042c28d2846ff87d07c8c_Out_0 = _UIMaskSoftnessX;
            float _Property_65f19de2db9c4dd2a64c3a3281296b73_Out_0 = _UIMaskSoftnessY;
            Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3 _SoftMask_c033882a6f9846d88eb7220ef323b24c;
            _SoftMask_c033882a6f9846d88eb7220ef323b24c.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1;
            SG_SoftMask_91d825b81706fe2429ed93b06cfe0ed3(_Property_e0a35baf762c4512af6d8aecf9c4079c_Out_0, _Property_e8dfb6e6078042c28d2846ff87d07c8c_Out_0, _Property_65f19de2db9c4dd2a64c3a3281296b73_Out_0, _SoftMask_c033882a6f9846d88eb7220ef323b24c, _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1);
            float _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2;
            Unity_Multiply_float(_Split_bf652bd7300f4d62a67ee0fb0a065416_A_4, _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1, _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2);
            surface.BaseColor = (_Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3.xyz);
            surface.Alpha = _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2;
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
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
            float3 TimeParameters;
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
        float Vector1_47F7ACA7;
        float Vector1_15CFC491;
        float _Count;
        float _Interval;
        float2 Vector2_d60465f4888c492c8072ddeb7f5f83df;
        float4 Color_088ca070316743738fb6e3f6f9db4dbe;
        float2 Vector2_3472e8c0d099492a914d4f245377518f;
        float Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
        float Vector1_d4a2b14c61f44492a550f288e33f8a5a;
        float4 Color_b4a2e7be4f9843dc8e67f85c86107869;
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
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        struct Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a
        {
        };

        void SG_QOffset8_4da89322f12c77d4a89ed7a4cf67121a(float2 Vector2_72a2395e9c314f42b17fe8dddb805b21, float2 Vector2_b6b5026fd3624df78fd6643871513657, Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a IN, out float2 Center_5, out float2 Right_3, out float2 Up_2, out float2 Left_1, out float2 Donw_4, out float2 RU_6, out float2 LU_7, out float2 LD_8, out float2 RD_9)
        {
            float2 _Property_105630cb6ab64abbb2149b40ace92428_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Property_cae2c7a072734db881bcbaea766c4309_Out_0 = Vector2_b6b5026fd3624df78fd6643871513657;
            float2 _Multiply_16fa0fce97294db0919ae61219c07295_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 0), _Multiply_16fa0fce97294db0919ae61219c07295_Out_2);
            float2 _Add_8b992d602b8b4ccb98179a202382e577_Out_2;
            Unity_Add_float2(_Multiply_16fa0fce97294db0919ae61219c07295_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_8b992d602b8b4ccb98179a202382e577_Out_2);
            float2 _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, 1), _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2);
            float2 _Add_329164cae0284725a423dd7a9ec01e8e_Out_2;
            Unity_Add_float2(_Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_329164cae0284725a423dd7a9ec01e8e_Out_2);
            float2 _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 0), _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2);
            float2 _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2;
            Unity_Add_float2(_Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2);
            float2 _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, -1), _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2);
            float2 _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2;
            Unity_Add_float2(_Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2, _Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2);
            float2 _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 1), _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2);
            float2 _Property_a0f2227860af45f497a5843cf2d8e256_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2;
            Unity_Add_float2(_Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2);
            float2 _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 1), _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2);
            float2 _Add_971908af74f847f0a094d1bccda582e7_Out_2;
            Unity_Add_float2(_Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_971908af74f847f0a094d1bccda582e7_Out_2);
            float2 _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, -1), _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2);
            float2 _Add_e99297a34f54418ab38fc54941a987e4_Out_2;
            Unity_Add_float2(_Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_e99297a34f54418ab38fc54941a987e4_Out_2);
            float2 _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, -1), _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2);
            float2 _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2;
            Unity_Add_float2(_Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2, _Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2);
            Center_5 = _Property_105630cb6ab64abbb2149b40ace92428_Out_0;
            Right_3 = _Add_8b992d602b8b4ccb98179a202382e577_Out_2;
            Up_2 = _Add_329164cae0284725a423dd7a9ec01e8e_Out_2;
            Left_1 = _Add_a7084e9d3a064d7a9316c83a66d3f146_Out_2;
            Donw_4 = _Add_e7dd77b9b3df47f6a285338cef12835e_Out_2;
            RU_6 = _Add_8cd89a54952e47d4ad5136cca6d979f0_Out_2;
            LU_7 = _Add_971908af74f847f0a094d1bccda582e7_Out_2;
            LD_8 = _Add_e99297a34f54418ab38fc54941a987e4_Out_2;
            RD_9 = _Add_16ace14ca70a46ae8f8f1f4a93fe6db6_Out_2;
        }

        struct Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5
        {
        };

        void SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(UnityTexture2D Texture2D_12575de54bba496f8874f55aff87c674, float2 Vector2_33c1b9041c6e4490b29de89a7bf80778, float2 Vector2_15a231d9767840ecbff1a7b16f6c36a0, Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 IN, out float4 Center_5, out float4 Right_1, out float4 Up_2, out float4 Left_3, out float4 Down_4, out float4 RU_6, out float4 LU_7, out float4 LD_8, out float4 RD_9)
        {
            UnityTexture2D _Property_ff08134fe20a416791b29f6acad07fd6_Out_0 = Texture2D_12575de54bba496f8874f55aff87c674;
            float2 _Property_8bbe98442c294e8e8826ea57748cdaf1_Out_0 = Vector2_33c1b9041c6e4490b29de89a7bf80778;
            float2 _Property_2ddd924c88f546f099b312f2f3304f64_Out_0 = Vector2_15a231d9767840ecbff1a7b16f6c36a0;
            Bindings_QOffset8_4da89322f12c77d4a89ed7a4cf67121a _QOffset8_0873cd0059084739b664769a027f83a5;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Center_5;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Right_3;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Up_2;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Left_1;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_RU_6;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_LU_7;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_LD_8;
            float2 _QOffset8_0873cd0059084739b664769a027f83a5_RD_9;
            SG_QOffset8_4da89322f12c77d4a89ed7a4cf67121a(_Property_8bbe98442c294e8e8826ea57748cdaf1_Out_0, _Property_2ddd924c88f546f099b312f2f3304f64_Out_0, _QOffset8_0873cd0059084739b664769a027f83a5, _QOffset8_0873cd0059084739b664769a027f83a5_Center_5, _QOffset8_0873cd0059084739b664769a027f83a5_Right_3, _QOffset8_0873cd0059084739b664769a027f83a5_Up_2, _QOffset8_0873cd0059084739b664769a027f83a5_Left_1, _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4, _QOffset8_0873cd0059084739b664769a027f83a5_RU_6, _QOffset8_0873cd0059084739b664769a027f83a5_LU_7, _QOffset8_0873cd0059084739b664769a027f83a5_LD_8, _QOffset8_0873cd0059084739b664769a027f83a5_RD_9);
            float4 _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Center_5);
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_R_4 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.r;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_G_5 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.g;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_B_6 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.b;
            float _SampleTexture2D_745d683e309944bea303f60cd4eebf68_A_7 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0.a;
            float4 _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Right_3);
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_R_4 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.r;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_G_5 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.g;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_B_6 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.b;
            float _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_A_7 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0.a;
            float4 _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Up_2);
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_R_4 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.r;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_G_5 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.g;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_B_6 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.b;
            float _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_A_7 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0.a;
            float4 _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Left_1);
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_R_4 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.r;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_G_5 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.g;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_B_6 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.b;
            float _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_A_7 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0.a;
            float4 _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_Donw_4);
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_R_4 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.r;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_G_5 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.g;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_B_6 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.b;
            float _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_A_7 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0.a;
            float4 _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_RU_6);
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_R_4 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.r;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_G_5 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.g;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_B_6 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.b;
            float _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_A_7 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0.a;
            float4 _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_LU_7);
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_R_4 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.r;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_G_5 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.g;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_B_6 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.b;
            float _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_A_7 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0.a;
            float4 _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_LD_8);
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_R_4 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.r;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_G_5 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.g;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_B_6 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.b;
            float _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_A_7 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0.a;
            float4 _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0 = SAMPLE_TEXTURE2D(_Property_ff08134fe20a416791b29f6acad07fd6_Out_0.tex, _Property_ff08134fe20a416791b29f6acad07fd6_Out_0.samplerstate, _QOffset8_0873cd0059084739b664769a027f83a5_RD_9);
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_R_4 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.r;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_G_5 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.g;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_B_6 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.b;
            float _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_A_7 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0.a;
            Center_5 = _SampleTexture2D_745d683e309944bea303f60cd4eebf68_RGBA_0;
            Right_1 = _SampleTexture2D_90dbb02905fb4cb8bd952173e73685b5_RGBA_0;
            Up_2 = _SampleTexture2D_c40c52a5d99f4cbeb42d5719bda82c68_RGBA_0;
            Left_3 = _SampleTexture2D_bc655af5c3974f8fac58b1a66e926622_RGBA_0;
            Down_4 = _SampleTexture2D_d94c96a96fab4c71b63c9b692296c9d4_RGBA_0;
            RU_6 = _SampleTexture2D_fb15393043f540b19dd3b6fb16d56206_RGBA_0;
            LU_7 = _SampleTexture2D_285a3fe569d242d09f6b26a5b3e16569_RGBA_0;
            LD_8 = _SampleTexture2D_9346c927155d4d73b3f2e375a1171b83_RGBA_0;
            RD_9 = _SampleTexture2D_03b523af033b4a769fa6d128357c1be1_RGBA_0;
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A / B;
        }

        struct Bindings_QBlur_82c178bc71d4d7544903c365250ab883
        {
        };

        void SG_QBlur_82c178bc71d4d7544903c365250ab883(float2 Vector2_f4f81b69e9e24900b2a35165159c5c07, UnityTexture2D Texture2D_47023485, float2 Vector2_103a21721560482aa6c7bc3c67ee7f37, Bindings_QBlur_82c178bc71d4d7544903c365250ab883 IN, out float4 Output_1)
        {
            UnityTexture2D _Property_6ff64ebf61b339818b2070eb58512ab3_Out_0 = Texture2D_47023485;
            float2 _Property_ae789743d9dd45f191ba1fd51b1b69de_Out_0 = Vector2_103a21721560482aa6c7bc3c67ee7f37;
            float2 _Property_bd9c290d23324db9b87633b1574299e6_Out_0 = Vector2_f4f81b69e9e24900b2a35165159c5c07;
            Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8;
            float4 _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9;
            SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(_Property_6ff64ebf61b339818b2070eb58512ab3_Out_0, _Property_ae789743d9dd45f191ba1fd51b1b69de_Out_0, _Property_bd9c290d23324db9b87633b1574299e6_Out_0, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9);
            float4 _Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Center_5, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Right_1, _Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2);
            float4 _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Up_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Left_3, _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2);
            float4 _Add_50970554ac867785a41b3978c49b4a5a_Out_2;
            Unity_Add_float4(_Add_6b5116d0ccd97d82828cb7b5b12e4650_Out_2, _Add_483573e101adc1838ed5b2676c9f5a0d_Out_2, _Add_50970554ac867785a41b3978c49b4a5a_Out_2);
            float4 _Add_523b939788fcde84ad30524b95fe751b_Out_2;
            Unity_Add_float4(_Add_50970554ac867785a41b3978c49b4a5a_Out_2, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_Down_4, _Add_523b939788fcde84ad30524b95fe751b_Out_2);
            float4 _Add_8f10b57f38914639866ef4583cfa72cf_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RU_6, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LU_7, _Add_8f10b57f38914639866ef4583cfa72cf_Out_2);
            float4 _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2;
            Unity_Add_float4(_QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_LD_8, _QTex2dOffset8_e8fcb864bb1f455cb3b83c7aa284b4af_RD_9, _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2);
            float4 _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2;
            Unity_Add_float4(_Add_8f10b57f38914639866ef4583cfa72cf_Out_2, _Add_3ddae2a90bed4252b372526cbfbee4fb_Out_2, _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2);
            float4 _Add_383025487ae44c1e84f55f43fa7012d0_Out_2;
            Unity_Add_float4(_Add_523b939788fcde84ad30524b95fe751b_Out_2, _Add_6e3d67f0d3ad48fa9cd79c8866c1e641_Out_2, _Add_383025487ae44c1e84f55f43fa7012d0_Out_2);
            float4 _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2;
            Unity_Divide_float4(_Add_383025487ae44c1e84f55f43fa7012d0_Out_2, float4(9, 9, 9, 9), _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2);
            Output_1 = _Divide_fd7372108b688280b7ef123f1474f2e2_Out_2;
        }

        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }

        void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            Rotation = Rotation * (3.1415926f/180.0f);
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

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Fraction_float2(float2 In, out float2 Out)
        {
            Out = frac(In);
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

        struct Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7
        {
        };

        void SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(float2 Vector2_B7353A3E, float Vector1_ECABA087, float Vector1_4CF0998F, float Vector1_E78B2213, Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 IN, out float Output_1)
        {
            float _Property_3381c691d25aa18ea5985ee703881281_Out_0 = Vector1_4CF0998F;
            float _Property_8f9b8f290ab82880b0de0387a111ad33_Out_0 = Vector1_E78B2213;
            float _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2;
            Unity_Divide_float(_Property_8f9b8f290ab82880b0de0387a111ad33_Out_0, 2, _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2);
            float _Add_d858b6bd6a66708bbdda79add23899f3_Out_2;
            Unity_Add_float(_Property_3381c691d25aa18ea5985ee703881281_Out_0, _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2, _Add_d858b6bd6a66708bbdda79add23899f3_Out_2);
            float _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2;
            Unity_Divide_float(_Add_d858b6bd6a66708bbdda79add23899f3_Out_2, 2, _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2);
            float _Float_9e3727bedd1c7e86bc3fdd6bdbd95825_Out_0 = _Divide_e00eb207e2f7c987bba3500b6d14088c_Out_2;
            float _Subtract_851e407d7d674e8c9b11de15584d9040_Out_2;
            Unity_Subtract_float(_Divide_e5b419b741936785b8b5ea907d798ba7_Out_2, _Float_9e3727bedd1c7e86bc3fdd6bdbd95825_Out_0, _Subtract_851e407d7d674e8c9b11de15584d9040_Out_2);
            float2 _Property_3fdee8a215f5eb849c9da148c2159a37_Out_0 = Vector2_B7353A3E;
            float _Property_604183ba5d883a86b2db507aebad7916_Out_0 = Vector1_ECABA087;
            float2 _Vector2_bc3754a5c9666587afe082bdebc07932_Out_0 = float2(_Property_604183ba5d883a86b2db507aebad7916_Out_0, 1);
            float2 _TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3;
            Unity_TilingAndOffset_float(_Property_3fdee8a215f5eb849c9da148c2159a37_Out_0, _Vector2_bc3754a5c9666587afe082bdebc07932_Out_0, float2 (0, 0), _TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3);
            float2 _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1;
            Unity_Fraction_float2(_TilingAndOffset_9fad7ba0d6ee2d87af00c9d6019241de_Out_3, _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1);
            float _Split_35a317782eaec08d85f161f41385fff3_R_1 = _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1[0];
            float _Split_35a317782eaec08d85f161f41385fff3_G_2 = _Fraction_b3c8b217c8a9598bafdb4298bf7b105e_Out_1[1];
            float _Split_35a317782eaec08d85f161f41385fff3_B_3 = 0;
            float _Split_35a317782eaec08d85f161f41385fff3_A_4 = 0;
            float _Round_b7f112384dbba186ba940e21e84fb21b_Out_1;
            Unity_Round_float(_Split_35a317782eaec08d85f161f41385fff3_R_1, _Round_b7f112384dbba186ba940e21e84fb21b_Out_1);
            float _Subtract_8627771c222a1082a10ed465716d0c11_Out_2;
            Unity_Subtract_float(_Split_35a317782eaec08d85f161f41385fff3_R_1, _Round_b7f112384dbba186ba940e21e84fb21b_Out_1, _Subtract_8627771c222a1082a10ed465716d0c11_Out_2);
            float _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1;
            Unity_Absolute_float(_Subtract_8627771c222a1082a10ed465716d0c11_Out_2, _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1);
            float _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3;
            Unity_Smoothstep_float(_Subtract_851e407d7d674e8c9b11de15584d9040_Out_2, _Divide_e5b419b741936785b8b5ea907d798ba7_Out_2, _Absolute_b63cddcf3398f488b8da73bf5f0ca028_Out_1, _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3);
            Output_1 = _Smoothstep_bba4013aa47ded85a7b9598af3359bfb_Out_3;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Preview_float(float In, out float Out)
        {
            Out = In;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Absolute_float2(float2 In, out float2 Out)
        {
            Out = abs(In);
        }

        void Unity_Saturate_float2(float2 In, out float2 Out)
        {
            Out = saturate(In);
        }

        struct Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3
        {
            float3 ObjectSpacePosition;
        };

        void SG_SoftMask_91d825b81706fe2429ed93b06cfe0ed3(float4 Vector4_9e9a63f94d3b457a9e03db85d6107f59, float Vector1_dddd78b7411b4699855db2341d9a91c8, float Vector1_86ab507b5cff4cb787f36eb94d8985b8, Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3 IN, out float A_1)
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
            float _Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0 = Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
            float _Property_58fa34917fc14fc39025f04bca863067_Out_0 = Vector1_d4a2b14c61f44492a550f288e33f8a5a;
            float _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2;
            Unity_Multiply_float(_Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0, _Property_58fa34917fc14fc39025f04bca863067_Out_0, _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2);
            float2 _Vector2_51212eddbdcd4650a941b3b517d0b777_Out_0 = float2(_Property_49936b2b0aa643ed98bffe70a63cdc71_Out_0, _Multiply_17983f4af4644eea98042c0e28f53aad_Out_2);
            UnityTexture2D _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_e84ed06367d64b298c9f3b90cb971811_Out_0 = Vector2_d60465f4888c492c8072ddeb7f5f83df;
            float4 _UV_35701ab563d84259b185b24755568117_Out_0 = IN.uv0;
            float2 _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2;
            Unity_Add_float2(_Property_e84ed06367d64b298c9f3b90cb971811_Out_0, (_UV_35701ab563d84259b185b24755568117_Out_0.xy), _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2);
            Bindings_QBlur_82c178bc71d4d7544903c365250ab883 _QBlur_a54667eda14a484eab80144e5aadc3d4;
            float4 _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1;
            SG_QBlur_82c178bc71d4d7544903c365250ab883(_Vector2_51212eddbdcd4650a941b3b517d0b777_Out_0, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, _Add_3713d01ba70d4b9e8ad4719f3113db44_Out_2, _QBlur_a54667eda14a484eab80144e5aadc3d4, _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1);
            float _Split_51c3ba136f564621b4e73f567fde8e11_R_1 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[0];
            float _Split_51c3ba136f564621b4e73f567fde8e11_G_2 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[1];
            float _Split_51c3ba136f564621b4e73f567fde8e11_B_3 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[2];
            float _Split_51c3ba136f564621b4e73f567fde8e11_A_4 = _QBlur_a54667eda14a484eab80144e5aadc3d4_Output_1[3];
            float4 _UV_78cd7cc893894646868bd28c7d22efb7_Out_0 = IN.uv0;
            float2 _Property_5409cc0ce3ce4fa5887720c1b8a4b8a0_Out_0 = Vector2_3472e8c0d099492a914d4f245377518f;
            float _Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0 = _Count;
            float2 _Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2;
            Unity_Divide_float2(_Property_5409cc0ce3ce4fa5887720c1b8a4b8a0_Out_0, (_Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0.xx), _Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2);
            float2 _Multiply_79dc60be511f400da58707cee8cb947c_Out_2;
            Unity_Multiply_float(_Divide_5bf58fbf8f5a4b8ebefc9bf08aa8b828_Out_2, (IN.TimeParameters.x.xx), _Multiply_79dc60be511f400da58707cee8cb947c_Out_2);
            float2 _Add_3db0305b9e5d4adc84272061fa31d423_Out_2;
            Unity_Add_float2((_UV_78cd7cc893894646868bd28c7d22efb7_Out_0.xy), _Multiply_79dc60be511f400da58707cee8cb947c_Out_2, _Add_3db0305b9e5d4adc84272061fa31d423_Out_2);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3;
            Unity_Rotate_Degrees_float(_Add_3db0305b9e5d4adc84272061fa31d423_Out_2, float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3);
            float _Property_234b9571841c4b809298d823466a32b7_Out_0 = _Interval;
            float _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0 = Vector1_15CFC491;
            Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 _QStripesBack_6bd0c9728a9ce984af510be0cf309f09;
            float _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1;
            SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(_Rotate_f758e8e42488608bb8e5636f67264b34_Out_3, _Property_84dfadef5d0c4369be1c61c46fa71c64_Out_0, _Property_234b9571841c4b809298d823466a32b7_Out_0, _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1);
            float _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
            Unity_Multiply_float(_Split_51c3ba136f564621b4e73f567fde8e11_A_4, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1, _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2);
            float4 _Property_10a5ca05efc3418883248c9b482f79db_Out_0 = Color_088ca070316743738fb6e3f6f9db4dbe;
            float4 _Multiply_ac15645f8d7949b398c326cebe513110_Out_2;
            Unity_Multiply_float((_Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2.xxxx), _Property_10a5ca05efc3418883248c9b482f79db_Out_0, _Multiply_ac15645f8d7949b398c326cebe513110_Out_2);
            float _Property_fe24fc6474c14d2387b68e616271cda5_Out_0 = Vector1_f6cf94e9df274e4fa7cc9d16f93e3869;
            float _Property_496d491dd1e6496a8cf0917e3c80875d_Out_0 = Vector1_d4a2b14c61f44492a550f288e33f8a5a;
            float _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2;
            Unity_Multiply_float(_Property_fe24fc6474c14d2387b68e616271cda5_Out_0, _Property_496d491dd1e6496a8cf0917e3c80875d_Out_0, _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2);
            float2 _Vector2_5198102118c04dcc85df80b4c35b034e_Out_0 = float2(_Property_fe24fc6474c14d2387b68e616271cda5_Out_0, _Multiply_f8b2a1f90b8642ebac5fb3c8bbba2156_Out_2);
            float2 _Multiply_dcabc38199b74e8abfe6704eff785421_Out_2;
            Unity_Multiply_float(_Vector2_5198102118c04dcc85df80b4c35b034e_Out_0, float2(0.5, 0.5), _Multiply_dcabc38199b74e8abfe6704eff785421_Out_2);
            float2 _Property_9055100a06a64662b3a14826236a287f_Out_0 = Vector2_d60465f4888c492c8072ddeb7f5f83df;
            float2 _Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2;
            Unity_Multiply_float(_Property_9055100a06a64662b3a14826236a287f_Out_0, float2(0.2, 0.2), _Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2);
            float4 _UV_a9f97616ab74489fa84d038eac5fced0_Out_0 = IN.uv0;
            float2 _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2;
            Unity_Add_float2(_Multiply_df39f2c70ee34cb7a134d9a727d8be9f_Out_2, (_UV_a9f97616ab74489fa84d038eac5fced0_Out_0.xy), _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2);
            Bindings_QBlur_82c178bc71d4d7544903c365250ab883 _QBlur_a70ed97f574a4b9fbf802b153f986545;
            float4 _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1;
            SG_QBlur_82c178bc71d4d7544903c365250ab883(_Multiply_dcabc38199b74e8abfe6704eff785421_Out_2, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, _Add_7600f2f09436451fbf96dd3d7ffacb2e_Out_2, _QBlur_a70ed97f574a4b9fbf802b153f986545, _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1);
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_R_1 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[0];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_G_2 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[1];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_B_3 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[2];
            float _Split_2cc317fb3c584c29aa407f4c8f2c2241_A_4 = _QBlur_a70ed97f574a4b9fbf802b153f986545_Output_1[3];
            float _Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1;
            Unity_Preview_float(_Split_2cc317fb3c584c29aa407f4c8f2c2241_A_4, _Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1);
            float4 _Property_e34c7b37da624685b5cb0ba992a6a210_Out_0 = Color_b4a2e7be4f9843dc8e67f85c86107869;
            float4 _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2;
            Unity_Multiply_float((_Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1.xxxx), _Property_e34c7b37da624685b5cb0ba992a6a210_Out_0, _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2);
            float4 _Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3;
            Unity_Lerp_float4(_Multiply_ac15645f8d7949b398c326cebe513110_Out_2, _Multiply_a40d2e80066842ebaddec7b3f4cb8e54_Out_2, (_Preview_f9250dfc5e4c4be9aece1a0345b5409f_Out_1.xxxx), _Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3);
            float4 _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0 = SAMPLE_TEXTURE2D(_Property_342ae035d6dc66818de2b0f35cd2103a_Out_0.tex, _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_R_4 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.r;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_G_5 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.g;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_B_6 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.b;
            float _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_A_7 = _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0.a;
            float4 _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3;
            Unity_Lerp_float4(_Lerp_dd85177633ec4bd593cca3d93989f6d5_Out_3, _SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_RGBA_0, (_SampleTexture2D_52e9aa164ef749f597dc1ce32d85a2cb_A_7.xxxx), _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3);
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_R_1 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[0];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_G_2 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[1];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_B_3 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[2];
            float _Split_bf652bd7300f4d62a67ee0fb0a065416_A_4 = _Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3[3];
            float4 _Property_e0a35baf762c4512af6d8aecf9c4079c_Out_0 = _ClipRect;
            float _Property_e8dfb6e6078042c28d2846ff87d07c8c_Out_0 = _UIMaskSoftnessX;
            float _Property_65f19de2db9c4dd2a64c3a3281296b73_Out_0 = _UIMaskSoftnessY;
            Bindings_SoftMask_91d825b81706fe2429ed93b06cfe0ed3 _SoftMask_c033882a6f9846d88eb7220ef323b24c;
            _SoftMask_c033882a6f9846d88eb7220ef323b24c.ObjectSpacePosition = IN.ObjectSpacePosition;
            float _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1;
            SG_SoftMask_91d825b81706fe2429ed93b06cfe0ed3(_Property_e0a35baf762c4512af6d8aecf9c4079c_Out_0, _Property_e8dfb6e6078042c28d2846ff87d07c8c_Out_0, _Property_65f19de2db9c4dd2a64c3a3281296b73_Out_0, _SoftMask_c033882a6f9846d88eb7220ef323b24c, _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1);
            float _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2;
            Unity_Multiply_float(_Split_bf652bd7300f4d62a67ee0fb0a065416_A_4, _SoftMask_c033882a6f9846d88eb7220ef323b24c_A_1, _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2);
            surface.BaseColor = (_Lerp_89db586f5f5a4698a3dc31bfaddb5608_Out_3.xyz);
            surface.Alpha = _Multiply_5c416c39b8544587a997b52ffe8e3d67_Out_2;
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
            output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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