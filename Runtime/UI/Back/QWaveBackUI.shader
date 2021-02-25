Shader "QUI/QWaveBackUI"
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
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            // Name: <None>
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
             Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite Off
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
        
            // Keywords
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
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
            #define SHADERPASS_SPRITEUNLIT
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float2 Vector2_6A46D00F;
            float Vector1_47F7ACA7;
            CBUFFER_END
            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
            SAMPLER(_SampleTexture2D_4F71E958_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
            {
            };
            
            void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, TEXTURE2D_PARAM(Texture2D_CA72CD38, samplerTexture2D_CA72CD38), float4 Texture2D_CA72CD38_TexelSize, float2 Vector2_F19B6F36, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1, out float R_2, out float G_3, out float B_4, out float A_5)
            {
                float2 _Property_34DAC409_Out_0 = Vector2_F19B6F36;
                float4 _Property_45E375BD_Out_0 = Vector4_19C7703B;
                float _Split_6383091C_R_1 = _Property_45E375BD_Out_0[0];
                float _Split_6383091C_G_2 = _Property_45E375BD_Out_0[1];
                float _Split_6383091C_B_3 = _Property_45E375BD_Out_0[2];
                float _Split_6383091C_A_4 = _Property_45E375BD_Out_0[3];
                float2 _Vector2_FD468521_Out_0 = float2(_Split_6383091C_R_1, _Split_6383091C_G_2);
                float2 _Vector2_2186D72B_Out_0 = float2(_Split_6383091C_B_3, _Split_6383091C_A_4);
                float2 _TilingAndOffset_A66CB0E_Out_3;
                Unity_TilingAndOffset_float(_Property_34DAC409_Out_0, _Vector2_FD468521_Out_0, _Vector2_2186D72B_Out_0, _TilingAndOffset_A66CB0E_Out_3);
                float4 _SampleTexture2D_4F71E958_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_CA72CD38, samplerTexture2D_CA72CD38, _TilingAndOffset_A66CB0E_Out_3);
                float _SampleTexture2D_4F71E958_R_4 = _SampleTexture2D_4F71E958_RGBA_0.r;
                float _SampleTexture2D_4F71E958_G_5 = _SampleTexture2D_4F71E958_RGBA_0.g;
                float _SampleTexture2D_4F71E958_B_6 = _SampleTexture2D_4F71E958_RGBA_0.b;
                float _SampleTexture2D_4F71E958_A_7 = _SampleTexture2D_4F71E958_RGBA_0.a;
                Output_1 = _SampleTexture2D_4F71E958_RGBA_0;
                R_2 = _SampleTexture2D_4F71E958_R_4;
                G_3 = _SampleTexture2D_4F71E958_G_5;
                B_4 = _SampleTexture2D_4F71E958_B_6;
                A_5 = _SampleTexture2D_4F71E958_A_7;
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
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
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
                float2 _Property_B3B4468D_Out_0 = Vector2_7C225E21;
                float2 _TilingAndOffset_C5B9A8BB_Out_3;
                Unity_TilingAndOffset_float(_Property_B3B4468D_Out_0, float2 (1, 1), float2 (0, 0), _TilingAndOffset_C5B9A8BB_Out_3);
                float _Split_885948A7_R_1 = _TilingAndOffset_C5B9A8BB_Out_3[0];
                float _Split_885948A7_G_2 = _TilingAndOffset_C5B9A8BB_Out_3[1];
                float _Split_885948A7_B_3 = 0;
                float _Split_885948A7_A_4 = 0;
                float2 _Property_FB1CDF11_Out_0 = Vector2_85052A8F;
                float _Split_AD6B4873_R_1 = _Property_FB1CDF11_Out_0[0];
                float _Split_AD6B4873_G_2 = _Property_FB1CDF11_Out_0[1];
                float _Split_AD6B4873_B_3 = 0;
                float _Split_AD6B4873_A_4 = 0;
                float _Multiply_8364DDDB_Out_2;
                Unity_Multiply_float(_Split_885948A7_G_2, _Split_AD6B4873_G_2, _Multiply_8364DDDB_Out_2);
                float _Multiply_B2A43FB7_Out_2;
                Unity_Multiply_float(_Split_885948A7_R_1, _Split_AD6B4873_R_1, _Multiply_B2A43FB7_Out_2);
                float _Multiply_2CECDCF9_Out_2;
                Unity_Multiply_float(_Multiply_B2A43FB7_Out_2, 6.283185, _Multiply_2CECDCF9_Out_2);
                float _Sine_BCB4175E_Out_1;
                Unity_Sine_float(_Multiply_2CECDCF9_Out_2, _Sine_BCB4175E_Out_1);
                float _Remap_22C7404F_Out_3;
                Unity_Remap_float(_Sine_BCB4175E_Out_1, float2 (-1, 1), float2 (0, 1), _Remap_22C7404F_Out_3);
                float _Subtract_3643C9BF_Out_2;
                Unity_Subtract_float(_Multiply_8364DDDB_Out_2, _Remap_22C7404F_Out_3, _Subtract_3643C9BF_Out_2);
                float _Round_C06B195B_Out_1;
                Unity_Round_float(_Subtract_3643C9BF_Out_2, _Round_C06B195B_Out_1);
                float _Subtract_F95D908D_Out_2;
                Unity_Subtract_float(_Subtract_3643C9BF_Out_2, _Round_C06B195B_Out_1, _Subtract_F95D908D_Out_2);
                float _Absolute_7949AAB2_Out_1;
                Unity_Absolute_float(_Subtract_F95D908D_Out_2, _Absolute_7949AAB2_Out_1);
                float _Smoothstep_10DA3121_Out_3;
                Unity_Smoothstep_float(0.25, 0.3, _Absolute_7949AAB2_Out_1, _Smoothstep_10DA3121_Out_3);
                OutVector1_1 = _Smoothstep_10DA3121_Out_3;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float4 uv0;
            };
            
            struct SurfaceDescription
            {
                float4 Color;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _UV_37F3ADD2_Out_0 = IN.uv0;
                Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_E1C934C1;
                float4 _QTexture2D_E1C934C1_Output_1;
                float _QTexture2D_E1C934C1_R_2;
                float _QTexture2D_E1C934C1_G_3;
                float _QTexture2D_E1C934C1_B_4;
                float _QTexture2D_E1C934C1_A_5;
                SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), TEXTURE2D_ARGS(_MainTex, sampler_MainTex), _MainTex_TexelSize, (_UV_37F3ADD2_Out_0.xy), _QTexture2D_E1C934C1, _QTexture2D_E1C934C1_Output_1, _QTexture2D_E1C934C1_R_2, _QTexture2D_E1C934C1_G_3, _QTexture2D_E1C934C1_B_4, _QTexture2D_E1C934C1_A_5);
                float4 _ScreenPosition_35F6D667_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
                float _Property_E913EB7D_Out_0 = Vector1_47F7ACA7;
                float2 _Rotate_F70E63BE_Out_3;
                Unity_Rotate_Radians_float((_ScreenPosition_35F6D667_Out_0.xy), float2 (0.5, 0.5), _Property_E913EB7D_Out_0, _Rotate_F70E63BE_Out_3);
                float2 _Property_E905C57F_Out_0 = Vector2_6A46D00F;
                Bindings_QWaveBack_08a913e1b4ae3e342a78aa488653d6da _QWaveBack_8175DC78;
                float _QWaveBack_8175DC78_OutVector1_1;
                SG_QWaveBack_08a913e1b4ae3e342a78aa488653d6da(_Rotate_F70E63BE_Out_3, _Property_E905C57F_Out_0, _QWaveBack_8175DC78, _QWaveBack_8175DC78_OutVector1_1);
                float4 _Multiply_3011F464_Out_2;
                Unity_Multiply_float(_QTexture2D_E1C934C1_Output_1, (_QWaveBack_8175DC78_OutVector1_1.xxxx), _Multiply_3011F464_Out_2);
                surface.Color = _Multiply_3011F464_Out_2;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
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
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float4 texCoord0;
                float4 color;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyzw = input.texCoord0;
                output.interp02.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.texCoord0 = input.interp01.xyzw;
                output.color = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
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
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
