Shader "QShaderGraph/Outline_EdgeUI"
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
        Vector1_45214e7454204e87b0b3eefc7f41b95b("WidthDivHeight", Float) = 1
        Vector1_3f869daddcc44886957070fcce707a50("BlurScale", Float) = 0.01
        Color_35a550d4968a46098fc1c5dce3547961("Color", Color) = (0.9953954, 0.0518868, 1, 0)
        _Scale("Scale", Float) = 1
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
        float Vector1_45214e7454204e87b0b3eefc7f41b95b;
        float Vector1_3f869daddcc44886957070fcce707a50;
        float4 Color_35a550d4968a46098fc1c5dce3547961;
        float _Scale;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

            // Graph Functions
            
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Clamp_float2(float2 In, float2 Min, float2 Max, out float2 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da
        {
        };

        void SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(float2 Vector2_a8999b29d04748569e879dd8a26aaa01, float2 Vector2_7358895314894571943f416ff24193b5, float Boolean_857fe6e5be94414ca3b30f86277797f5, Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da IN, out float2 Out_1)
        {
            float _Property_658e34498c524baabb8912023a427007_Out_0 = Boolean_857fe6e5be94414ca3b30f86277797f5;
            float2 _Property_bacc814aac7549ca9a9bf3fd5c1fc7c7_Out_0 = Vector2_7358895314894571943f416ff24193b5;
            float2 _Property_c8de28152da84993894f9c7f2c0a133b_Out_0 = Vector2_a8999b29d04748569e879dd8a26aaa01;
            float2 _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2;
            Unity_Add_float2(_Property_bacc814aac7549ca9a9bf3fd5c1fc7c7_Out_0, _Property_c8de28152da84993894f9c7f2c0a133b_Out_0, _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2);
            float2 _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3;
            Unity_Clamp_float2(_Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2, float2(0, 0), float2(1, 1), _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3);
            float2 _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3;
            Unity_Branch_float2(_Property_658e34498c524baabb8912023a427007_Out_0, _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3, _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2, _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3);
            Out_1 = _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3;
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
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_a2bd3568735745eeb569120c1d806a78;
            float2 _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_16fa0fce97294db0919ae61219c07295_Out_2, 1, _QUVOffset_a2bd3568735745eeb569120c1d806a78, _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1);
            float2 _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, 1), _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_31460334023b4e33b6169494f3858ba8;
            float2 _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2, 1, _QUVOffset_31460334023b4e33b6169494f3858ba8, _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1);
            float2 _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 0), _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_a0431e6819584870bf01f39a9573f6cc;
            float2 _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2, 1, _QUVOffset_a0431e6819584870bf01f39a9573f6cc, _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1);
            float2 _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, -1), _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_fe1133805de344299143a9138032c8e6;
            float2 _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2, 1, _QUVOffset_fe1133805de344299143a9138032c8e6, _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1);
            float2 _Property_a0f2227860af45f497a5843cf2d8e256_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 1), _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_2624c5024ae94731b29db5143ddc7172;
            float2 _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2, 1, _QUVOffset_2624c5024ae94731b29db5143ddc7172, _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1);
            float2 _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 1), _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_490ffc87693845369b9e5ebf51657ba8;
            float2 _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2, 1, _QUVOffset_490ffc87693845369b9e5ebf51657ba8, _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1);
            float2 _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, -1), _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e;
            float2 _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2, 1, _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e, _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1);
            float2 _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, -1), _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_7831dc8ca93b4425b38e188321602340;
            float2 _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2, 1, _QUVOffset_7831dc8ca93b4425b38e188321602340, _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1);
            Center_5 = _Property_105630cb6ab64abbb2149b40ace92428_Out_0;
            Right_3 = _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1;
            Up_2 = _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1;
            Left_1 = _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1;
            Donw_4 = _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1;
            RU_6 = _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1;
            LU_7 = _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1;
            LD_8 = _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1;
            RD_9 = _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1;
        }

        struct Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5
        {
        };

        void SG_QTexture8_f9b4f47df8d332140881ba23e1ff05c5(UnityTexture2D Texture2D_12575de54bba496f8874f55aff87c674, float2 Vector2_33c1b9041c6e4490b29de89a7bf80778, float2 Vector2_15a231d9767840ecbff1a7b16f6c36a0, Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5 IN, out float4 Center_5, out float4 Right_1, out float4 Up_2, out float4 Left_3, out float4 Down_4, out float4 RU_6, out float4 LU_7, out float4 LD_8, out float4 RD_9)
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

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }

        struct Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e
        {
        };

        void SG_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e(float Vector1_81e118df17b54641ba51df81da2f13a8, float Vector1_988d0c9a0a5549d5a718acf9f24ccaf5, float Vector1_c598cf13cf894154bde24c8a226138eb, float Vector1_efcb5b4a36fb48c9a630de70e79e8b96, Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e IN, out float Output_1)
        {
            float _Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0 = Vector1_81e118df17b54641ba51df81da2f13a8;
            float _Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0 = Vector1_c598cf13cf894154bde24c8a226138eb;
            float _Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2;
            Unity_Subtract_float(_Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0, _Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0, _Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2);
            float _Property_85cf50ff988849d8b96182142361e0d0_Out_0 = Vector1_988d0c9a0a5549d5a718acf9f24ccaf5;
            float _Property_66463f09be7442c9a9b2a17043b68080_Out_0 = Vector1_efcb5b4a36fb48c9a630de70e79e8b96;
            float _Subtract_99ea25ea89214496918db80caf84e46c_Out_2;
            Unity_Subtract_float(_Property_85cf50ff988849d8b96182142361e0d0_Out_0, _Property_66463f09be7442c9a9b2a17043b68080_Out_0, _Subtract_99ea25ea89214496918db80caf84e46c_Out_2);
            float _Maximum_344d6fed840249d2912310ad003c0da0_Out_2;
            Unity_Maximum_float(_Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2, _Subtract_99ea25ea89214496918db80caf84e46c_Out_2, _Maximum_344d6fed840249d2912310ad003c0da0_Out_2);
            float _Subtract_7aa31c546dca4b479a7c33791544327c_Out_2;
            Unity_Subtract_float(_Property_66463f09be7442c9a9b2a17043b68080_Out_0, _Property_85cf50ff988849d8b96182142361e0d0_Out_0, _Subtract_7aa31c546dca4b479a7c33791544327c_Out_2);
            float _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2;
            Unity_Subtract_float(_Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0, _Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0, _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2);
            float _Maximum_798403624ba449f1a126ea08761580df_Out_2;
            Unity_Maximum_float(_Subtract_7aa31c546dca4b479a7c33791544327c_Out_2, _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2, _Maximum_798403624ba449f1a126ea08761580df_Out_2);
            float _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2;
            Unity_Maximum_float(_Maximum_344d6fed840249d2912310ad003c0da0_Out_2, _Maximum_798403624ba449f1a126ea08761580df_Out_2, _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2);
            Output_1 = _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_820f5473de9f417aa3789ce282895530_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ad8b7b7c22b946419e2bf42c8b10493e_Out_0 = IN.uv0;
            float _Property_72b1599812c6481eaf33bcba953265e4_Out_0 = Vector1_3f869daddcc44886957070fcce707a50;
            float _Property_2ab8142cff8d4699aaa3728afb940b16_Out_0 = Vector1_45214e7454204e87b0b3eefc7f41b95b;
            float _Divide_04b6884580e24085ac4576a219fea2b2_Out_2;
            Unity_Divide_float(_Property_72b1599812c6481eaf33bcba953265e4_Out_0, _Property_2ab8142cff8d4699aaa3728afb940b16_Out_0, _Divide_04b6884580e24085ac4576a219fea2b2_Out_2);
            float2 _Vector2_0c998dc9c03b4c12818703cecd243e26_Out_0 = float2(_Property_72b1599812c6481eaf33bcba953265e4_Out_0, _Divide_04b6884580e24085ac4576a219fea2b2_Out_2);
            Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5 _QTexture8_f98b415175de40ed85e2457870c66ef3;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Center_5;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Right_1;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Up_2;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Left_3;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Down_4;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9;
            SG_QTexture8_f9b4f47df8d332140881ba23e1ff05c5(_Property_820f5473de9f417aa3789ce282895530_Out_0, (_UV_ad8b7b7c22b946419e2bf42c8b10493e_Out_0.xy), _Vector2_0c998dc9c03b4c12818703cecd243e26_Out_0, _QTexture8_f98b415175de40ed85e2457870c66ef3, _QTexture8_f98b415175de40ed85e2457870c66ef3_Center_5, _QTexture8_f98b415175de40ed85e2457870c66ef3_Right_1, _QTexture8_f98b415175de40ed85e2457870c66ef3_Up_2, _QTexture8_f98b415175de40ed85e2457870c66ef3_Left_3, _QTexture8_f98b415175de40ed85e2457870c66ef3_Down_4, _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6, _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7, _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8, _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9);
            float _Split_d9265475ac104652b2efc017062d5fb5_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[0];
            float _Split_d9265475ac104652b2efc017062d5fb5_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[1];
            float _Split_d9265475ac104652b2efc017062d5fb5_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[2];
            float _Split_d9265475ac104652b2efc017062d5fb5_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[3];
            float _Split_4cea1cd270ec40d69462184960400a8c_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[0];
            float _Split_4cea1cd270ec40d69462184960400a8c_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[1];
            float _Split_4cea1cd270ec40d69462184960400a8c_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[2];
            float _Split_4cea1cd270ec40d69462184960400a8c_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[3];
            float _Split_94eed81881584245bb42f002728fb017_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[0];
            float _Split_94eed81881584245bb42f002728fb017_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[1];
            float _Split_94eed81881584245bb42f002728fb017_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[2];
            float _Split_94eed81881584245bb42f002728fb017_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[3];
            float _Split_91ac87d6f395415db5df6509660753ed_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[0];
            float _Split_91ac87d6f395415db5df6509660753ed_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[1];
            float _Split_91ac87d6f395415db5df6509660753ed_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[2];
            float _Split_91ac87d6f395415db5df6509660753ed_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[3];
            Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7;
            float _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1;
            SG_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e(_Split_d9265475ac104652b2efc017062d5fb5_A_4, _Split_4cea1cd270ec40d69462184960400a8c_A_4, _Split_94eed81881584245bb42f002728fb017_A_4, _Split_91ac87d6f395415db5df6509660753ed_A_4, _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7, _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1);
            float4 _Property_d0bfce52b7194c2fb7196346e3294410_Out_0 = Color_35a550d4968a46098fc1c5dce3547961;
            float4 _Multiply_316d3bdd084b4f339fef086787ad658f_Out_2;
            Unity_Multiply_float((_QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1.xxxx), _Property_d0bfce52b7194c2fb7196346e3294410_Out_0, _Multiply_316d3bdd084b4f339fef086787ad658f_Out_2);
            float _Property_b2d59c02a5bd42f385c59961f339be44_Out_0 = _Scale;
            float4 _Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2;
            Unity_Multiply_float(_Multiply_316d3bdd084b4f339fef086787ad658f_Out_2, (_Property_b2d59c02a5bd42f385c59961f339be44_Out_0.xxxx), _Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2);
            float4 _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_820f5473de9f417aa3789ce282895530_Out_0.tex, _Property_820f5473de9f417aa3789ce282895530_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_R_4 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.r;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_G_5 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.g;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_B_6 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.b;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.a;
            float4 _Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3;
            Unity_Lerp_float4(_Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2, _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0, (_SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7.xxxx), _Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3);
            float _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2;
            Unity_Multiply_float(_QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1, _Property_b2d59c02a5bd42f385c59961f339be44_Out_0, _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2);
            float _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2;
            Unity_Add_float(_SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7, _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2, _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2);
            surface.BaseColor = (_Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3.xyz);
            surface.Alpha = _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2;
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
        float Vector1_45214e7454204e87b0b3eefc7f41b95b;
        float Vector1_3f869daddcc44886957070fcce707a50;
        float4 Color_35a550d4968a46098fc1c5dce3547961;
        float _Scale;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);

            // Graph Functions
            
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Clamp_float2(float2 In, float2 Min, float2 Max, out float2 Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da
        {
        };

        void SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(float2 Vector2_a8999b29d04748569e879dd8a26aaa01, float2 Vector2_7358895314894571943f416ff24193b5, float Boolean_857fe6e5be94414ca3b30f86277797f5, Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da IN, out float2 Out_1)
        {
            float _Property_658e34498c524baabb8912023a427007_Out_0 = Boolean_857fe6e5be94414ca3b30f86277797f5;
            float2 _Property_bacc814aac7549ca9a9bf3fd5c1fc7c7_Out_0 = Vector2_7358895314894571943f416ff24193b5;
            float2 _Property_c8de28152da84993894f9c7f2c0a133b_Out_0 = Vector2_a8999b29d04748569e879dd8a26aaa01;
            float2 _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2;
            Unity_Add_float2(_Property_bacc814aac7549ca9a9bf3fd5c1fc7c7_Out_0, _Property_c8de28152da84993894f9c7f2c0a133b_Out_0, _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2);
            float2 _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3;
            Unity_Clamp_float2(_Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2, float2(0, 0), float2(1, 1), _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3);
            float2 _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3;
            Unity_Branch_float2(_Property_658e34498c524baabb8912023a427007_Out_0, _Clamp_b4f0bf6cf77f4a4e8fd8cf85b8a56c9e_Out_3, _Add_4241f4b7513a415ea54bbe80e8eb1ff1_Out_2, _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3);
            Out_1 = _Branch_1dcfc6ea1e9f4a088f9dd1618ddc8802_Out_3;
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
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_a2bd3568735745eeb569120c1d806a78;
            float2 _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_16fa0fce97294db0919ae61219c07295_Out_2, 1, _QUVOffset_a2bd3568735745eeb569120c1d806a78, _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1);
            float2 _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, 1), _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_31460334023b4e33b6169494f3858ba8;
            float2 _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_beb77667cb944eecaa7e678ef8fa33cc_Out_2, 1, _QUVOffset_31460334023b4e33b6169494f3858ba8, _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1);
            float2 _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 0), _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_a0431e6819584870bf01f39a9573f6cc;
            float2 _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_1c4dd78290c64293ba81d0dfa22b8d4d_Out_2, 1, _QUVOffset_a0431e6819584870bf01f39a9573f6cc, _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1);
            float2 _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(0, -1), _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_fe1133805de344299143a9138032c8e6;
            float2 _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_105630cb6ab64abbb2149b40ace92428_Out_0, _Multiply_961d9f42490c48e8b25b4aa2e023b677_Out_2, 1, _QUVOffset_fe1133805de344299143a9138032c8e6, _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1);
            float2 _Property_a0f2227860af45f497a5843cf2d8e256_Out_0 = Vector2_72a2395e9c314f42b17fe8dddb805b21;
            float2 _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, 1), _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_2624c5024ae94731b29db5143ddc7172;
            float2 _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_d89bcd83fe7e4bbc8929e72da66f997f_Out_2, 1, _QUVOffset_2624c5024ae94731b29db5143ddc7172, _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1);
            float2 _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, 1), _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_490ffc87693845369b9e5ebf51657ba8;
            float2 _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_4c495b185f124bccb1a08277e0a83f4b_Out_2, 1, _QUVOffset_490ffc87693845369b9e5ebf51657ba8, _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1);
            float2 _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(-1, -1), _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e;
            float2 _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_c5266a5776fd4dfcbc2f71797733db5b_Out_2, 1, _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e, _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1);
            float2 _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2;
            Unity_Multiply_float(_Property_cae2c7a072734db881bcbaea766c4309_Out_0, float2(1, -1), _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2);
            Bindings_QUVOffset_96b2a3897c826fa4ea376558416be5da _QUVOffset_7831dc8ca93b4425b38e188321602340;
            float2 _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1;
            SG_QUVOffset_96b2a3897c826fa4ea376558416be5da(_Property_a0f2227860af45f497a5843cf2d8e256_Out_0, _Multiply_eccdea617a114a46a6b0adbfadaa6359_Out_2, 1, _QUVOffset_7831dc8ca93b4425b38e188321602340, _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1);
            Center_5 = _Property_105630cb6ab64abbb2149b40ace92428_Out_0;
            Right_3 = _QUVOffset_a2bd3568735745eeb569120c1d806a78_Out_1;
            Up_2 = _QUVOffset_31460334023b4e33b6169494f3858ba8_Out_1;
            Left_1 = _QUVOffset_a0431e6819584870bf01f39a9573f6cc_Out_1;
            Donw_4 = _QUVOffset_fe1133805de344299143a9138032c8e6_Out_1;
            RU_6 = _QUVOffset_2624c5024ae94731b29db5143ddc7172_Out_1;
            LU_7 = _QUVOffset_490ffc87693845369b9e5ebf51657ba8_Out_1;
            LD_8 = _QUVOffset_60ed6df2fc4546bbbac3278d84fe911e_Out_1;
            RD_9 = _QUVOffset_7831dc8ca93b4425b38e188321602340_Out_1;
        }

        struct Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5
        {
        };

        void SG_QTexture8_f9b4f47df8d332140881ba23e1ff05c5(UnityTexture2D Texture2D_12575de54bba496f8874f55aff87c674, float2 Vector2_33c1b9041c6e4490b29de89a7bf80778, float2 Vector2_15a231d9767840ecbff1a7b16f6c36a0, Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5 IN, out float4 Center_5, out float4 Right_1, out float4 Up_2, out float4 Left_3, out float4 Down_4, out float4 RU_6, out float4 LU_7, out float4 LD_8, out float4 RD_9)
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

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }

        struct Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e
        {
        };

        void SG_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e(float Vector1_81e118df17b54641ba51df81da2f13a8, float Vector1_988d0c9a0a5549d5a718acf9f24ccaf5, float Vector1_c598cf13cf894154bde24c8a226138eb, float Vector1_efcb5b4a36fb48c9a630de70e79e8b96, Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e IN, out float Output_1)
        {
            float _Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0 = Vector1_81e118df17b54641ba51df81da2f13a8;
            float _Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0 = Vector1_c598cf13cf894154bde24c8a226138eb;
            float _Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2;
            Unity_Subtract_float(_Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0, _Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0, _Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2);
            float _Property_85cf50ff988849d8b96182142361e0d0_Out_0 = Vector1_988d0c9a0a5549d5a718acf9f24ccaf5;
            float _Property_66463f09be7442c9a9b2a17043b68080_Out_0 = Vector1_efcb5b4a36fb48c9a630de70e79e8b96;
            float _Subtract_99ea25ea89214496918db80caf84e46c_Out_2;
            Unity_Subtract_float(_Property_85cf50ff988849d8b96182142361e0d0_Out_0, _Property_66463f09be7442c9a9b2a17043b68080_Out_0, _Subtract_99ea25ea89214496918db80caf84e46c_Out_2);
            float _Maximum_344d6fed840249d2912310ad003c0da0_Out_2;
            Unity_Maximum_float(_Subtract_42b702dacb1d4154b2e0b70e635ac16b_Out_2, _Subtract_99ea25ea89214496918db80caf84e46c_Out_2, _Maximum_344d6fed840249d2912310ad003c0da0_Out_2);
            float _Subtract_7aa31c546dca4b479a7c33791544327c_Out_2;
            Unity_Subtract_float(_Property_66463f09be7442c9a9b2a17043b68080_Out_0, _Property_85cf50ff988849d8b96182142361e0d0_Out_0, _Subtract_7aa31c546dca4b479a7c33791544327c_Out_2);
            float _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2;
            Unity_Subtract_float(_Property_9b9a398b8ca34d90b594b884bf6a07b5_Out_0, _Property_03680ec5cecd43ecb7ce9ff93ae29b1b_Out_0, _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2);
            float _Maximum_798403624ba449f1a126ea08761580df_Out_2;
            Unity_Maximum_float(_Subtract_7aa31c546dca4b479a7c33791544327c_Out_2, _Subtract_4e1d7c0b87a54ed2b083900581d57fec_Out_2, _Maximum_798403624ba449f1a126ea08761580df_Out_2);
            float _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2;
            Unity_Maximum_float(_Maximum_344d6fed840249d2912310ad003c0da0_Out_2, _Maximum_798403624ba449f1a126ea08761580df_Out_2, _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2);
            Output_1 = _Maximum_fb348aa35d544b8c98c108f1e86af244_Out_2;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
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
            UnityTexture2D _Property_820f5473de9f417aa3789ce282895530_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_ad8b7b7c22b946419e2bf42c8b10493e_Out_0 = IN.uv0;
            float _Property_72b1599812c6481eaf33bcba953265e4_Out_0 = Vector1_3f869daddcc44886957070fcce707a50;
            float _Property_2ab8142cff8d4699aaa3728afb940b16_Out_0 = Vector1_45214e7454204e87b0b3eefc7f41b95b;
            float _Divide_04b6884580e24085ac4576a219fea2b2_Out_2;
            Unity_Divide_float(_Property_72b1599812c6481eaf33bcba953265e4_Out_0, _Property_2ab8142cff8d4699aaa3728afb940b16_Out_0, _Divide_04b6884580e24085ac4576a219fea2b2_Out_2);
            float2 _Vector2_0c998dc9c03b4c12818703cecd243e26_Out_0 = float2(_Property_72b1599812c6481eaf33bcba953265e4_Out_0, _Divide_04b6884580e24085ac4576a219fea2b2_Out_2);
            Bindings_QTexture8_f9b4f47df8d332140881ba23e1ff05c5 _QTexture8_f98b415175de40ed85e2457870c66ef3;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Center_5;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Right_1;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Up_2;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Left_3;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_Down_4;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8;
            float4 _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9;
            SG_QTexture8_f9b4f47df8d332140881ba23e1ff05c5(_Property_820f5473de9f417aa3789ce282895530_Out_0, (_UV_ad8b7b7c22b946419e2bf42c8b10493e_Out_0.xy), _Vector2_0c998dc9c03b4c12818703cecd243e26_Out_0, _QTexture8_f98b415175de40ed85e2457870c66ef3, _QTexture8_f98b415175de40ed85e2457870c66ef3_Center_5, _QTexture8_f98b415175de40ed85e2457870c66ef3_Right_1, _QTexture8_f98b415175de40ed85e2457870c66ef3_Up_2, _QTexture8_f98b415175de40ed85e2457870c66ef3_Left_3, _QTexture8_f98b415175de40ed85e2457870c66ef3_Down_4, _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6, _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7, _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8, _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9);
            float _Split_d9265475ac104652b2efc017062d5fb5_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[0];
            float _Split_d9265475ac104652b2efc017062d5fb5_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[1];
            float _Split_d9265475ac104652b2efc017062d5fb5_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[2];
            float _Split_d9265475ac104652b2efc017062d5fb5_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RU_6[3];
            float _Split_4cea1cd270ec40d69462184960400a8c_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[0];
            float _Split_4cea1cd270ec40d69462184960400a8c_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[1];
            float _Split_4cea1cd270ec40d69462184960400a8c_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[2];
            float _Split_4cea1cd270ec40d69462184960400a8c_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LU_7[3];
            float _Split_94eed81881584245bb42f002728fb017_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[0];
            float _Split_94eed81881584245bb42f002728fb017_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[1];
            float _Split_94eed81881584245bb42f002728fb017_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[2];
            float _Split_94eed81881584245bb42f002728fb017_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_LD_8[3];
            float _Split_91ac87d6f395415db5df6509660753ed_R_1 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[0];
            float _Split_91ac87d6f395415db5df6509660753ed_G_2 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[1];
            float _Split_91ac87d6f395415db5df6509660753ed_B_3 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[2];
            float _Split_91ac87d6f395415db5df6509660753ed_A_4 = _QTexture8_f98b415175de40ed85e2457870c66ef3_RD_9[3];
            Bindings_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7;
            float _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1;
            SG_QEdgeRobert_aeeef8bc7995c894aa4d8604c703d90e(_Split_d9265475ac104652b2efc017062d5fb5_A_4, _Split_4cea1cd270ec40d69462184960400a8c_A_4, _Split_94eed81881584245bb42f002728fb017_A_4, _Split_91ac87d6f395415db5df6509660753ed_A_4, _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7, _QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1);
            float4 _Property_d0bfce52b7194c2fb7196346e3294410_Out_0 = Color_35a550d4968a46098fc1c5dce3547961;
            float4 _Multiply_316d3bdd084b4f339fef086787ad658f_Out_2;
            Unity_Multiply_float((_QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1.xxxx), _Property_d0bfce52b7194c2fb7196346e3294410_Out_0, _Multiply_316d3bdd084b4f339fef086787ad658f_Out_2);
            float _Property_b2d59c02a5bd42f385c59961f339be44_Out_0 = _Scale;
            float4 _Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2;
            Unity_Multiply_float(_Multiply_316d3bdd084b4f339fef086787ad658f_Out_2, (_Property_b2d59c02a5bd42f385c59961f339be44_Out_0.xxxx), _Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2);
            float4 _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0 = SAMPLE_TEXTURE2D(_Property_820f5473de9f417aa3789ce282895530_Out_0.tex, _Property_820f5473de9f417aa3789ce282895530_Out_0.samplerstate, IN.uv0.xy);
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_R_4 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.r;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_G_5 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.g;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_B_6 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.b;
            float _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7 = _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0.a;
            float4 _Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3;
            Unity_Lerp_float4(_Multiply_d3792a6d32fd4f39bac2185aad21090a_Out_2, _SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_RGBA_0, (_SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7.xxxx), _Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3);
            float _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2;
            Unity_Multiply_float(_QEdgeRobert_5d7708a82d4f46cab1840adbaf299cf7_Output_1, _Property_b2d59c02a5bd42f385c59961f339be44_Out_0, _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2);
            float _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2;
            Unity_Add_float(_SampleTexture2D_4d39bd1ebd6344489a7ad455f0e00d9d_A_7, _Multiply_833d56a797394aa0ada8e277f48a421d_Out_2, _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2);
            surface.BaseColor = (_Lerp_7c31a23204d34fbb9b16f6094c2ca99f_Out_3.xyz);
            surface.Alpha = _Add_d6ecef4833914c8cb2524f609784dfbe_Out_2;
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