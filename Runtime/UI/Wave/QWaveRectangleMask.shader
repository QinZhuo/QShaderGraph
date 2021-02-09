Shader "QShaderGraph/QWaveRectangleMaskUI"
{
    Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
				[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
        Height("Height", Range(0, 1)) = 0.3
        Speed("Speed", Float) = 0.1
        Color1("Color1", Color) = (0.8784314, 0.345098, 0.4980392, 1)
        Color2("Color2", Color) = (0, 1, 0.8313726, 1)
        Color3("Color3", Color) = (0.09803922, 0.04705883, 0.09803922, 1)
        HeightOffset("Offset", Float) = 0.05
        RectangleRadius("RectangleRadius", Float) = 0.05
        NoiseScale("NoiseScale", Float) = 2
        SubWave("SubWave", Float) = 0
        Vector1_AB134E35("WidthDivHeight", Float) = 1
    }
    SubShader
	{
		  Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
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
		   ZTest[unity_GUIZTestMode]
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
            float Height;
            float Speed;
            float4 Color1;
            float4 Color2;
            float4 Color3;
            float HeightOffset;
            float RectangleRadius;
            float NoiseScale;
            float SubWave;
            float Vector1_AB134E35;
            CBUFFER_END
            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
            SAMPLER(_SampleTexture2D_4F71E958_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_RoundedRectangle_float(float2 UV, float Width, float Height, float Radius, out float Out)
            {
                Radius = max(min(min(abs(Radius * 2), abs(Width)), abs(Height)), 1e-5);
                float2 uv = abs(UV * 2 - 1) - float2(Width, Height) + Radius;
                float d = length(max(0, uv)) / Radius;
                Out = saturate((1 - d) / fwidth(d));
            }
            
            struct Bindings_QRoundedRectangle_d2bb5940842005d42bf9432e6ef721d0
            {
                half4 uv0;
            };
            
            void SG_QRoundedRectangle_d2bb5940842005d42bf9432e6ef721d0(float Vector1_2899F6BA, float Vector1_48C332C8, Bindings_QRoundedRectangle_d2bb5940842005d42bf9432e6ef721d0 IN, out float Output_1)
            {
                float4 _UV_92C4ECD0_Out_0 = IN.uv0;
                float _Split_4FBCE4CB_R_1 = _UV_92C4ECD0_Out_0[0];
                float _Split_4FBCE4CB_G_2 = _UV_92C4ECD0_Out_0[1];
                float _Split_4FBCE4CB_B_3 = _UV_92C4ECD0_Out_0[2];
                float _Split_4FBCE4CB_A_4 = _UV_92C4ECD0_Out_0[3];
                float _Property_1946A67D_Out_0 = Vector1_2899F6BA;
                float _Vector1_541F2C12_Out_0 = _Property_1946A67D_Out_0;
                float _Multiply_5281594C_Out_2;
                Unity_Multiply_float(_Split_4FBCE4CB_R_1, _Vector1_541F2C12_Out_0, _Multiply_5281594C_Out_2);
                float _OneMinus_A2F83CCD_Out_1;
                Unity_OneMinus_float(_Vector1_541F2C12_Out_0, _OneMinus_A2F83CCD_Out_1);
                float _Divide_D1619CE0_Out_2;
                Unity_Divide_float(_OneMinus_A2F83CCD_Out_1, 2, _Divide_D1619CE0_Out_2);
                float _Add_6E404831_Out_2;
                Unity_Add_float(_Multiply_5281594C_Out_2, _Divide_D1619CE0_Out_2, _Add_6E404831_Out_2);
                float2 _Vector2_2F403A41_Out_0 = float2(_Add_6E404831_Out_2, _Split_4FBCE4CB_G_2);
                float _Property_C4296B06_Out_0 = Vector1_48C332C8;
                float _RoundedRectangle_EFF97CFE_Out_4;
                Unity_RoundedRectangle_float(_Vector2_2F403A41_Out_0, _Vector1_541F2C12_Out_0, 1, _Property_C4296B06_Out_0, _RoundedRectangle_EFF97CFE_Out_4);
                Output_1 = _RoundedRectangle_EFF97CFE_Out_4;
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Preview_float(float In, out float Out)
            {
                Out = In;
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            struct Bindings_QCrossSection_669f76b2bcc712a4fa2fd1a35de8044c
            {
                half4 uv0;
            };
            
            void SG_QCrossSection_669f76b2bcc712a4fa2fd1a35de8044c(float Vector1_6CA7DB8C, Bindings_QCrossSection_669f76b2bcc712a4fa2fd1a35de8044c IN, out float SmoothOutput_0)
            {
                float4 _UV_1F179B5_Out_0 = IN.uv0;
                float _Split_B1D230D0_R_1 = _UV_1F179B5_Out_0[0];
                float _Split_B1D230D0_G_2 = _UV_1F179B5_Out_0[1];
                float _Split_B1D230D0_B_3 = _UV_1F179B5_Out_0[2];
                float _Split_B1D230D0_A_4 = _UV_1F179B5_Out_0[3];
                float _Remap_4C47B1A0_Out_3;
                Unity_Remap_float(_Split_B1D230D0_G_2, float2 (0, 1), float2 (-2.5, 2.5), _Remap_4C47B1A0_Out_3);
                float _Preview_B45DEA51_Out_1;
                Unity_Preview_float(_Remap_4C47B1A0_Out_3, _Preview_B45DEA51_Out_1);
                float _Add_96DD802_Out_2;
                Unity_Add_float(_Preview_B45DEA51_Out_1, -0.03, _Add_96DD802_Out_2);
                float _Property_942C7D08_Out_0 = Vector1_6CA7DB8C;
                float _Smoothstep_F9BF09EC_Out_3;
                Unity_Smoothstep_float(_Preview_B45DEA51_Out_1, _Add_96DD802_Out_2, _Property_942C7D08_Out_0, _Smoothstep_F9BF09EC_Out_3);
                SmoothOutput_0 = _Smoothstep_F9BF09EC_Out_3;
            }
            
            struct Bindings_QWave_fee2201a442919c4dbb0f8b741c2234c
            {
                half4 uv0;
                float3 TimeParameters;
            };
            
            void SG_QWave_fee2201a442919c4dbb0f8b741c2234c(float Vector1_5BE94758, float Vector1_76B57A3B, float Vector1_7EEF1CA7, half2 Vector2_18FD7EA7, float2 Vector2_689368C1, float Vector1_BBCE3EED, Bindings_QWave_fee2201a442919c4dbb0f8b741c2234c IN, out float SmoothOutput_1)
            {
                half2 _Property_E1864690_Out_0 = Vector2_18FD7EA7;
                float2 _Property_65F32296_Out_0 = Vector2_689368C1;
                float _Property_DC74B0E2_Out_0 = Vector1_7EEF1CA7;
                float _Multiply_30556151_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_DC74B0E2_Out_0, _Multiply_30556151_Out_2);
                float2 _TilingAndOffset_5AD9D05C_Out_3;
                Unity_TilingAndOffset_float(_Property_E1864690_Out_0, _Property_65F32296_Out_0, (_Multiply_30556151_Out_2.xx), _TilingAndOffset_5AD9D05C_Out_3);
                float _Property_9AF29ED8_Out_0 = Vector1_5BE94758;
                float _GradientNoise_93F6657D_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_5AD9D05C_Out_3, _Property_9AF29ED8_Out_0, _GradientNoise_93F6657D_Out_2);
                float _Multiply_9A030E6E_Out_2;
                Unity_Multiply_float(_Property_9AF29ED8_Out_0, 2, _Multiply_9A030E6E_Out_2);
                float _GradientNoise_150B7929_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_5AD9D05C_Out_3, _Multiply_9A030E6E_Out_2, _GradientNoise_150B7929_Out_2);
                float _Property_16945E6A_Out_0 = Vector1_BBCE3EED;
                float _Multiply_C42EF7A1_Out_2;
                Unity_Multiply_float(_GradientNoise_150B7929_Out_2, _Property_16945E6A_Out_0, _Multiply_C42EF7A1_Out_2);
                float _Add_B430518F_Out_2;
                Unity_Add_float(_GradientNoise_93F6657D_Out_2, _Multiply_C42EF7A1_Out_2, _Add_B430518F_Out_2);
                float _Add_C341B012_Out_2;
                Unity_Add_float(1, _Property_16945E6A_Out_0, _Add_C341B012_Out_2);
                float _Divide_594B0013_Out_2;
                Unity_Divide_float(_Add_B430518F_Out_2, _Add_C341B012_Out_2, _Divide_594B0013_Out_2);
                float _Property_47E1522_Out_0 = Vector1_76B57A3B;
                float _Add_A1027553_Out_2;
                Unity_Add_float(_Divide_594B0013_Out_2, _Property_47E1522_Out_0, _Add_A1027553_Out_2);
                Bindings_QCrossSection_669f76b2bcc712a4fa2fd1a35de8044c _QCrossSection_E84C9EB3;
                _QCrossSection_E84C9EB3.uv0 = IN.uv0;
                float _QCrossSection_E84C9EB3_SmoothOutput_0;
                SG_QCrossSection_669f76b2bcc712a4fa2fd1a35de8044c(_Add_A1027553_Out_2, _QCrossSection_E84C9EB3, _QCrossSection_E84C9EB3_SmoothOutput_0);
                SmoothOutput_1 = _QCrossSection_E84C9EB3_SmoothOutput_0;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            struct Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d
            {
                half4 uv0;
            };
            
            void SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 Vector4_19C7703B, TEXTURE2D_PARAM(Texture2D_CA72CD38, samplerTexture2D_CA72CD38), float4 Texture2D_CA72CD38_TexelSize, Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d IN, out float4 Output_1)
            {
                float4 _Property_45E375BD_Out_0 = Vector4_19C7703B;
                float _Split_6383091C_R_1 = _Property_45E375BD_Out_0[0];
                float _Split_6383091C_G_2 = _Property_45E375BD_Out_0[1];
                float _Split_6383091C_B_3 = _Property_45E375BD_Out_0[2];
                float _Split_6383091C_A_4 = _Property_45E375BD_Out_0[3];
                float2 _Vector2_FD468521_Out_0 = float2(_Split_6383091C_R_1, _Split_6383091C_G_2);
                float2 _Vector2_2186D72B_Out_0 = float2(_Split_6383091C_B_3, _Split_6383091C_A_4);
                float2 _TilingAndOffset_A66CB0E_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_FD468521_Out_0, _Vector2_2186D72B_Out_0, _TilingAndOffset_A66CB0E_Out_3);
                float4 _SampleTexture2D_4F71E958_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_CA72CD38, samplerTexture2D_CA72CD38, _TilingAndOffset_A66CB0E_Out_3);
                float _SampleTexture2D_4F71E958_R_4 = _SampleTexture2D_4F71E958_RGBA_0.r;
                float _SampleTexture2D_4F71E958_G_5 = _SampleTexture2D_4F71E958_RGBA_0.g;
                float _SampleTexture2D_4F71E958_B_6 = _SampleTexture2D_4F71E958_RGBA_0.b;
                float _SampleTexture2D_4F71E958_A_7 = _SampleTexture2D_4F71E958_RGBA_0.a;
                Output_1 = _SampleTexture2D_4F71E958_RGBA_0;
            }
        
            // Graph Vertex
            // GraphVertex: <None>
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float4 uv0;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float4 Color;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _Property_BB648A73_Out_0 = Vector1_AB134E35;
                float _Property_40A1706D_Out_0 = RectangleRadius;
                Bindings_QRoundedRectangle_d2bb5940842005d42bf9432e6ef721d0 _QRoundedRectangle_7AD79107;
                _QRoundedRectangle_7AD79107.uv0 = IN.uv0;
                float _QRoundedRectangle_7AD79107_Output_1;
                SG_QRoundedRectangle_d2bb5940842005d42bf9432e6ef721d0(_Property_BB648A73_Out_0, _Property_40A1706D_Out_0, _QRoundedRectangle_7AD79107, _QRoundedRectangle_7AD79107_Output_1);
                float4 _Property_5816BCAA_Out_0 = Color3;
                float4 _Property_24EEDF32_Out_0 = Color1;
                float _Property_A9DE2E7A_Out_0 = NoiseScale;
                float _Property_C360A79B_Out_0 = Height;
                float _Remap_824CCF56_Out_3;
                Unity_Remap_float(_Property_C360A79B_Out_0, float2 (0, 1), float2 (-3, 2), _Remap_824CCF56_Out_3);
                float _Property_FFCD933E_Out_0 = Speed;
                float4 _ScreenPosition_1EE7EF86_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
                float _Property_B64CCC58_Out_0 = SubWave;
                Bindings_QWave_fee2201a442919c4dbb0f8b741c2234c _QWave_667ABEE3;
                _QWave_667ABEE3.uv0 = IN.uv0;
                _QWave_667ABEE3.TimeParameters = IN.TimeParameters;
                float _QWave_667ABEE3_SmoothOutput_1;
                SG_QWave_fee2201a442919c4dbb0f8b741c2234c(_Property_A9DE2E7A_Out_0, _Remap_824CCF56_Out_3, _Property_FFCD933E_Out_0, (_ScreenPosition_1EE7EF86_Out_0.xy), float2 (1, 1), _Property_B64CCC58_Out_0, _QWave_667ABEE3, _QWave_667ABEE3_SmoothOutput_1);
                float4 _Lerp_20CE083E_Out_3;
                Unity_Lerp_float4(_Property_5816BCAA_Out_0, _Property_24EEDF32_Out_0, (_QWave_667ABEE3_SmoothOutput_1.xxxx), _Lerp_20CE083E_Out_3);
                float4 _Property_24708B30_Out_0 = Color2;
                float _Property_1A4CA148_Out_0 = HeightOffset;
                float _Add_C9A97DD7_Out_2;
                Unity_Add_float(_Remap_824CCF56_Out_3, _Property_1A4CA148_Out_0, _Add_C9A97DD7_Out_2);
                Bindings_QWave_fee2201a442919c4dbb0f8b741c2234c _QWave_C8D2523B;
                _QWave_C8D2523B.uv0 = IN.uv0;
                _QWave_C8D2523B.TimeParameters = IN.TimeParameters;
                float _QWave_C8D2523B_SmoothOutput_1;
                SG_QWave_fee2201a442919c4dbb0f8b741c2234c(_Property_A9DE2E7A_Out_0, _Add_C9A97DD7_Out_2, _Property_FFCD933E_Out_0, (_ScreenPosition_1EE7EF86_Out_0.xy), float2 (0.95, 0.95), _Property_B64CCC58_Out_0, _QWave_C8D2523B, _QWave_C8D2523B_SmoothOutput_1);
                float _OneMinus_172432C0_Out_1;
                Unity_OneMinus_float(_QWave_C8D2523B_SmoothOutput_1, _OneMinus_172432C0_Out_1);
                float _Multiply_41C57F08_Out_2;
                Unity_Multiply_float(_QWave_667ABEE3_SmoothOutput_1, _OneMinus_172432C0_Out_1, _Multiply_41C57F08_Out_2);
                float4 _Lerp_2516DB8D_Out_3;
                Unity_Lerp_float4(_Lerp_20CE083E_Out_3, _Property_24708B30_Out_0, (_Multiply_41C57F08_Out_2.xxxx), _Lerp_2516DB8D_Out_3);
                float4 _Multiply_D5227EA9_Out_2;
                Unity_Multiply_float((_QRoundedRectangle_7AD79107_Output_1.xxxx), _Lerp_2516DB8D_Out_3, _Multiply_D5227EA9_Out_2);
                float _Split_408C371B_R_1 = _Multiply_D5227EA9_Out_2[0];
                float _Split_408C371B_G_2 = _Multiply_D5227EA9_Out_2[1];
                float _Split_408C371B_B_3 = _Multiply_D5227EA9_Out_2[2];
                float _Split_408C371B_A_4 = _Multiply_D5227EA9_Out_2[3];
                Bindings_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d _QTexture2D_C7CC5C84;
                _QTexture2D_C7CC5C84.uv0 = IN.uv0;
                float4 _QTexture2D_C7CC5C84_Output_1;
                SG_QTexture2D_76f4b07b850ad0a48ab4b91d1fa4734d(float4 (1, 1, 0, 0), TEXTURE2D_ARGS(_MainTex, sampler_MainTex), _MainTex_TexelSize, _QTexture2D_C7CC5C84, _QTexture2D_C7CC5C84_Output_1);
                float _Split_22273341_R_1 = _QTexture2D_C7CC5C84_Output_1[0];
                float _Split_22273341_G_2 = _QTexture2D_C7CC5C84_Output_1[1];
                float _Split_22273341_B_3 = _QTexture2D_C7CC5C84_Output_1[2];
                float _Split_22273341_A_4 = _QTexture2D_C7CC5C84_Output_1[3];
                float _Multiply_6977293C_Out_2;
                Unity_Multiply_float(_Split_22273341_A_4, _Split_408C371B_A_4, _Multiply_6977293C_Out_2);
                float4 _Vector4_5D730FF1_Out_0 = float4(_Split_408C371B_R_1, _Split_408C371B_G_2, _Split_408C371B_B_3, _Multiply_6977293C_Out_2);
                surface.Color = _Vector4_5D730FF1_Out_0;
		#ifdef UNITY_UI_ALPHACLIP
                clip(surface.Color.a - 0.001);
			 #endif
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
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
