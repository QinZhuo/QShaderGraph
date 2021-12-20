Shader "QShaderGraph/MaxWaveUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        Vector1_7120850ac08948e0b4aaf4de0cf92ced("Float", Float) = 5
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
            float4 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
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
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
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
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
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
        float4 _MainTex_TexelSize;
        float Vector1_7120850ac08948e0b4aaf4de0cf92ced;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
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

        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
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
            UnityTexture2D _Property_a1709cb986944697959535b59654db9a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_0b800b5b25a94c96b359223037aca49c_Out_0 = IN.uv0;
            float _Property_c0011610088c4952997c0fc533364fa4_Out_0 = Vector1_7120850ac08948e0b4aaf4de0cf92ced;
            float _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2;
            Unity_Multiply_float(_Property_c0011610088c4952997c0fc533364fa4_Out_0, 0.001, _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2);
            float _Multiply_84246649d30b4138b964c3f018ff9894_Out_2;
            Unity_Multiply_float(IN.TimeParameters.y, _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2, _Multiply_84246649d30b4138b964c3f018ff9894_Out_2);
            Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9;
            SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(_Property_a1709cb986944697959535b59654db9a_Out_0, (_UV_0b800b5b25a94c96b359223037aca49c_Out_0.xy), (_Multiply_84246649d30b4138b964c3f018ff9894_Out_2.xx), _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9);
            float4 _Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3, _Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2);
            float4 _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4, _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2);
            float4 _Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2;
            Unity_Maximum_float4(_Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2, _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2, _Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2);
            float4 _Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7, _Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2);
            float4 _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9, _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2);
            float4 _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2;
            Unity_Maximum_float4(_Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2, _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2, _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2);
            float4 _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2;
            Unity_Maximum_float4(_Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2, _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2, _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2);
            float4 _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5, _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2, _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2);
            float _Split_c17bb57a738d41499108659c8c51cdbe_R_1 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[0];
            float _Split_c17bb57a738d41499108659c8c51cdbe_G_2 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[1];
            float _Split_c17bb57a738d41499108659c8c51cdbe_B_3 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[2];
            float _Split_c17bb57a738d41499108659c8c51cdbe_A_4 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[3];
            surface.BaseColor = (_Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2.xyz);
            surface.Alpha = _Split_c17bb57a738d41499108659c8c51cdbe_A_4;
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
            float4 interp0 : TEXCOORD0;
            float4 interp1 : TEXCOORD1;
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
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
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
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
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
        float4 _MainTex_TexelSize;
        float Vector1_7120850ac08948e0b4aaf4de0cf92ced;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

            // Graph Functions
            
        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
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

        void Unity_Maximum_float4(float4 A, float4 B, out float4 Out)
        {
            Out = max(A, B);
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
            UnityTexture2D _Property_a1709cb986944697959535b59654db9a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_0b800b5b25a94c96b359223037aca49c_Out_0 = IN.uv0;
            float _Property_c0011610088c4952997c0fc533364fa4_Out_0 = Vector1_7120850ac08948e0b4aaf4de0cf92ced;
            float _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2;
            Unity_Multiply_float(_Property_c0011610088c4952997c0fc533364fa4_Out_0, 0.001, _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2);
            float _Multiply_84246649d30b4138b964c3f018ff9894_Out_2;
            Unity_Multiply_float(IN.TimeParameters.y, _Multiply_5d237cb8f39546fc86e6d97b1f615a5b_Out_2, _Multiply_84246649d30b4138b964c3f018ff9894_Out_2);
            Bindings_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8;
            float4 _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9;
            SG_QTex2dOffset8_f9b4f47df8d332140881ba23e1ff05c5(_Property_a1709cb986944697959535b59654db9a_Out_0, (_UV_0b800b5b25a94c96b359223037aca49c_Out_0.xy), (_Multiply_84246649d30b4138b964c3f018ff9894_Out_2.xx), _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9);
            float4 _Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Right_1, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Left_3, _Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2);
            float4 _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Up_2, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Down_4, _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2);
            float4 _Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2;
            Unity_Maximum_float4(_Maximum_02adf2bc640f49568c1e8e407b3a1bd9_Out_2, _Maximum_14668dd7194d4e94ba84b2b2baa69925_Out_2, _Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2);
            float4 _Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RU_6, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LU_7, _Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2);
            float4 _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_LD_8, _QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_RD_9, _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2);
            float4 _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2;
            Unity_Maximum_float4(_Maximum_e21d6f403ff247e089e1e72a96bca42a_Out_2, _Maximum_1fabd7b8c4f34a62a18ca4ec0dae5885_Out_2, _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2);
            float4 _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2;
            Unity_Maximum_float4(_Maximum_e14bcb115bf74ca584ae1727917de5e8_Out_2, _Maximum_6de7d09b2ab34ad5a8c5a598f20702da_Out_2, _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2);
            float4 _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2;
            Unity_Maximum_float4(_QTex2dOffset8_da32f279ca654cf0a5c43a033d8ba346_Center_5, _Maximum_ec416fc0938c45a48c5d8da1c1866133_Out_2, _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2);
            float _Split_c17bb57a738d41499108659c8c51cdbe_R_1 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[0];
            float _Split_c17bb57a738d41499108659c8c51cdbe_G_2 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[1];
            float _Split_c17bb57a738d41499108659c8c51cdbe_B_3 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[2];
            float _Split_c17bb57a738d41499108659c8c51cdbe_A_4 = _Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2[3];
            surface.BaseColor = (_Maximum_f503e3220acb42fa81473ae6eb10c425_Out_2.xyz);
            surface.Alpha = _Split_c17bb57a738d41499108659c8c51cdbe_A_4;
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