Shader "QUI/QCircleUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
        Vector1_13DE78A("InCircle", Float) = 0
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
            float Vector1_13DE78A;
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
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Ellipse_float(float2 UV, float Width, float Height, out float Out)
            {
                float d = length((UV * 2 - 1) / float2(Width, Height));
                Out = saturate((1 - d) / fwidth(d));
            }
            
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
            };
            
            struct SurfaceDescription
            {
                float4 Color;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _UV_921D702E_Out_0 = IN.uv0;
                Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_DFEA0CBE;
                float4 _QTexture2D_DFEA0CBE_Output_1;
                float _QTexture2D_DFEA0CBE_R_2;
                float _QTexture2D_DFEA0CBE_G_3;
                float _QTexture2D_DFEA0CBE_B_4;
                float _QTexture2D_DFEA0CBE_A_5;
                SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), TEXTURE2D_ARGS(_MainTex, sampler_MainTex), _MainTex_TexelSize, (_UV_921D702E_Out_0.xy), _QTexture2D_DFEA0CBE, _QTexture2D_DFEA0CBE_Output_1, _QTexture2D_DFEA0CBE_R_2, _QTexture2D_DFEA0CBE_G_3, _QTexture2D_DFEA0CBE_B_4, _QTexture2D_DFEA0CBE_A_5);
                float4 _Multiply_1868DCAA_Out_2;
                Unity_Multiply_float(_QTexture2D_DFEA0CBE_Output_1, float4(2, 2, 2, 2), _Multiply_1868DCAA_Out_2);
                float _Ellipse_18AF478B_Out_4;
                Unity_Ellipse_float(IN.uv0.xy, 1, 1, _Ellipse_18AF478B_Out_4);
                float _Property_45EACCEF_Out_0 = Vector1_13DE78A;
                float _Ellipse_C997E3C5_Out_4;
                Unity_Ellipse_float(IN.uv0.xy, _Property_45EACCEF_Out_0, _Property_45EACCEF_Out_0, _Ellipse_C997E3C5_Out_4);
                float _OneMinus_31CF3654_Out_1;
                Unity_OneMinus_float(_Ellipse_C997E3C5_Out_4, _OneMinus_31CF3654_Out_1);
                float _Multiply_6F6419B7_Out_2;
                Unity_Multiply_float(_Ellipse_18AF478B_Out_4, _OneMinus_31CF3654_Out_1, _Multiply_6F6419B7_Out_2);
                float4 _Multiply_2E280C89_Out_2;
                Unity_Multiply_float(_Multiply_1868DCAA_Out_2, (_Multiply_6F6419B7_Out_2.xxxx), _Multiply_2E280C89_Out_2);
                surface.Color = _Multiply_2E280C89_Out_2;
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
                float4 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
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
                output.interp00.xyzw = input.texCoord0;
                output.interp01.xyzw = input.color;
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
                output.texCoord0 = input.interp00.xyzw;
                output.color = input.interp01.xyzw;
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
