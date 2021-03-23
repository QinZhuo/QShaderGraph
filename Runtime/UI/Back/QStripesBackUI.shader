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
        Vector2_80F5EB39("Scale", Vector) = (3, 0.5, 0, 0)
        Vector1_47F7ACA7("Rotate", Float) = 45
        Vector1_15CFC491("Blur", Float) = 0.1
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
        float2 Vector2_80F5EB39;
        float Vector1_47F7ACA7;
        float Vector1_15CFC491;
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

        struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
        {
        };

        void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, UnityTexture2D Texture2D_CA72CD38, float2 Vector2_F19B6F36, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1, out float R_2, out float G_3, out float B_4, out float A_5)
        {
            UnityTexture2D _Property_c48957278f16b68480a4610fa04852a8_Out_0 = Texture2D_CA72CD38;
            float2 _Property_26c140d9f83e8385a08b4c849f1db62c_Out_0 = Vector2_F19B6F36;
            float4 _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0 = Vector4_19C7703B;
            float _Split_1b16b5375c32e78793936576a4cc5a63_R_1 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[0];
            float _Split_1b16b5375c32e78793936576a4cc5a63_G_2 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[1];
            float _Split_1b16b5375c32e78793936576a4cc5a63_B_3 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[2];
            float _Split_1b16b5375c32e78793936576a4cc5a63_A_4 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[3];
            float2 _Vector2_3155c819a109bb8b859ad7ae374f8856_Out_0 = float2(_Split_1b16b5375c32e78793936576a4cc5a63_R_1, _Split_1b16b5375c32e78793936576a4cc5a63_G_2);
            float2 _Vector2_b34ef76f94222681995d96057a1330e3_Out_0 = float2(_Split_1b16b5375c32e78793936576a4cc5a63_B_3, _Split_1b16b5375c32e78793936576a4cc5a63_A_4);
            float2 _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3;
            Unity_TilingAndOffset_float(_Property_26c140d9f83e8385a08b4c849f1db62c_Out_0, _Vector2_3155c819a109bb8b859ad7ae374f8856_Out_0, _Vector2_b34ef76f94222681995d96057a1330e3_Out_0, _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3);
            float4 _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c48957278f16b68480a4610fa04852a8_Out_0.tex, _Property_c48957278f16b68480a4610fa04852a8_Out_0.samplerstate, _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3);
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_R_4 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.r;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_G_5 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.g;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_B_6 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.b;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_A_7 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.a;
            Output_1 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0;
            R_2 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_R_4;
            G_3 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_G_5;
            B_4 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_B_6;
            A_5 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_A_7;
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
            UnityTexture2D _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_6bc7cf8f6580b789851fd5689b68104b_Out_0 = IN.uv0;
            Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_201c831c4641598185a5aff863e3241a;
            float4 _QTexture2D_201c831c4641598185a5aff863e3241a_Output_1;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_R_2;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_G_3;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_B_4;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_A_5;
            SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, (_UV_6bc7cf8f6580b789851fd5689b68104b_Out_0.xy), _QTexture2D_201c831c4641598185a5aff863e3241a, _QTexture2D_201c831c4641598185a5aff863e3241a_Output_1, _QTexture2D_201c831c4641598185a5aff863e3241a_R_2, _QTexture2D_201c831c4641598185a5aff863e3241a_G_3, _QTexture2D_201c831c4641598185a5aff863e3241a_B_4, _QTexture2D_201c831c4641598185a5aff863e3241a_A_5);
            float4 _ScreenPosition_e6186165f26ada81ba1a0ae5e7f21b83_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3;
            Unity_Rotate_Degrees_float((_ScreenPosition_e6186165f26ada81ba1a0ae5e7f21b83_Out_0.xy), float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3);
            float2 _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0 = Vector2_80F5EB39;
            float _Split_fa97af63d954f784aff32ec773af9bfc_R_1 = _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0[0];
            float _Split_fa97af63d954f784aff32ec773af9bfc_G_2 = _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0[1];
            float _Split_fa97af63d954f784aff32ec773af9bfc_B_3 = 0;
            float _Split_fa97af63d954f784aff32ec773af9bfc_A_4 = 0;
            float _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0 = Vector1_15CFC491;
            Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 _QStripesBack_6bd0c9728a9ce984af510be0cf309f09;
            float _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1;
            SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(_Rotate_f758e8e42488608bb8e5636f67264b34_Out_3, _Split_fa97af63d954f784aff32ec773af9bfc_R_1, _Split_fa97af63d954f784aff32ec773af9bfc_G_2, _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1);
            float4 _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
            Unity_Multiply_float(_QTexture2D_201c831c4641598185a5aff863e3241a_Output_1, (_QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1.xxxx), _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2);
            surface.BaseColor = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.SpriteColor = _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
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
        float2 Vector2_80F5EB39;
        float Vector1_47F7ACA7;
        float Vector1_15CFC491;
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

        struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
        {
        };

        void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, UnityTexture2D Texture2D_CA72CD38, float2 Vector2_F19B6F36, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1, out float R_2, out float G_3, out float B_4, out float A_5)
        {
            UnityTexture2D _Property_c48957278f16b68480a4610fa04852a8_Out_0 = Texture2D_CA72CD38;
            float2 _Property_26c140d9f83e8385a08b4c849f1db62c_Out_0 = Vector2_F19B6F36;
            float4 _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0 = Vector4_19C7703B;
            float _Split_1b16b5375c32e78793936576a4cc5a63_R_1 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[0];
            float _Split_1b16b5375c32e78793936576a4cc5a63_G_2 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[1];
            float _Split_1b16b5375c32e78793936576a4cc5a63_B_3 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[2];
            float _Split_1b16b5375c32e78793936576a4cc5a63_A_4 = _Property_aa91a2672bdb368c8993341b7e08baa3_Out_0[3];
            float2 _Vector2_3155c819a109bb8b859ad7ae374f8856_Out_0 = float2(_Split_1b16b5375c32e78793936576a4cc5a63_R_1, _Split_1b16b5375c32e78793936576a4cc5a63_G_2);
            float2 _Vector2_b34ef76f94222681995d96057a1330e3_Out_0 = float2(_Split_1b16b5375c32e78793936576a4cc5a63_B_3, _Split_1b16b5375c32e78793936576a4cc5a63_A_4);
            float2 _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3;
            Unity_TilingAndOffset_float(_Property_26c140d9f83e8385a08b4c849f1db62c_Out_0, _Vector2_3155c819a109bb8b859ad7ae374f8856_Out_0, _Vector2_b34ef76f94222681995d96057a1330e3_Out_0, _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3);
            float4 _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c48957278f16b68480a4610fa04852a8_Out_0.tex, _Property_c48957278f16b68480a4610fa04852a8_Out_0.samplerstate, _TilingAndOffset_48e1fa86cca7d484a1cd06c8fe10c47d_Out_3);
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_R_4 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.r;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_G_5 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.g;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_B_6 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.b;
            float _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_A_7 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0.a;
            Output_1 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_RGBA_0;
            R_2 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_R_4;
            G_3 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_G_5;
            B_4 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_B_6;
            A_5 = _SampleTexture2D_d748d43eff35f580ad562cc50e1a4b23_A_7;
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
            UnityTexture2D _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _UV_6bc7cf8f6580b789851fd5689b68104b_Out_0 = IN.uv0;
            Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_201c831c4641598185a5aff863e3241a;
            float4 _QTexture2D_201c831c4641598185a5aff863e3241a_Output_1;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_R_2;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_G_3;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_B_4;
            float _QTexture2D_201c831c4641598185a5aff863e3241a_A_5;
            SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), _Property_342ae035d6dc66818de2b0f35cd2103a_Out_0, (_UV_6bc7cf8f6580b789851fd5689b68104b_Out_0.xy), _QTexture2D_201c831c4641598185a5aff863e3241a, _QTexture2D_201c831c4641598185a5aff863e3241a_Output_1, _QTexture2D_201c831c4641598185a5aff863e3241a_R_2, _QTexture2D_201c831c4641598185a5aff863e3241a_G_3, _QTexture2D_201c831c4641598185a5aff863e3241a_B_4, _QTexture2D_201c831c4641598185a5aff863e3241a_A_5);
            float4 _ScreenPosition_e6186165f26ada81ba1a0ae5e7f21b83_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float _Property_09969b4f012ee98d905df377dba8a497_Out_0 = Vector1_47F7ACA7;
            float2 _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3;
            Unity_Rotate_Degrees_float((_ScreenPosition_e6186165f26ada81ba1a0ae5e7f21b83_Out_0.xy), float2 (0.5, 0.5), _Property_09969b4f012ee98d905df377dba8a497_Out_0, _Rotate_f758e8e42488608bb8e5636f67264b34_Out_3);
            float2 _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0 = Vector2_80F5EB39;
            float _Split_fa97af63d954f784aff32ec773af9bfc_R_1 = _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0[0];
            float _Split_fa97af63d954f784aff32ec773af9bfc_G_2 = _Property_1a31b9eb320d9a879dc2c04a086190da_Out_0[1];
            float _Split_fa97af63d954f784aff32ec773af9bfc_B_3 = 0;
            float _Split_fa97af63d954f784aff32ec773af9bfc_A_4 = 0;
            float _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0 = Vector1_15CFC491;
            Bindings_QStripesBack_22adf84759a732142b435ff5654e1fa7 _QStripesBack_6bd0c9728a9ce984af510be0cf309f09;
            float _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1;
            SG_QStripesBack_22adf84759a732142b435ff5654e1fa7(_Rotate_f758e8e42488608bb8e5636f67264b34_Out_3, _Split_fa97af63d954f784aff32ec773af9bfc_R_1, _Split_fa97af63d954f784aff32ec773af9bfc_G_2, _Property_cb51952d8ad0c2838d5ce5a471c2ae24_Out_0, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09, _QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1);
            float4 _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
            Unity_Multiply_float(_QTexture2D_201c831c4641598185a5aff863e3241a_Output_1, (_QStripesBack_6bd0c9728a9ce984af510be0cf309f09_Output_1.xxxx), _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2);
            surface.BaseColor = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.SpriteColor = _Multiply_5dfa7b8d18140586ada61b17cef04528_Out_2;
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