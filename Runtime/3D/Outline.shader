Shader "Outline"
{
    Properties
    {
        _OutlineColor("Outline Color", Color) = (0,0,0,1)
        _Outline("Outline width", Range(.002, 1)) = .005
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Cull Front
        ZWrite On
        ColorMask RGB
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            Name "OUTLINE"

            HLSLPROGRAM
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            CBUFFER_START(UnityPerMaterial)
            float _Outline;
            float4 _OutlineColor;
            CBUFFER_END

            struct VIn
            {
                float4 pos : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Vin
            {
                float4 pos : SV_POSITION;
                half fogCoord : TEXCOORD0;
                half4 color : COLOR;
                UNITY_VERTEX_OUTPUT_STEREO
            };

			Vin vert(VIn i)
            {
				Vin o = (Vin)0;
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                i.pos.xyz +=  i.normalOS.xyz * _Outline;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(i.pos.xyz);
                o.pos = vertexInput.positionCS;

                o.color = _OutlineColor;
                o.fogCoord = ComputeFogFactor(o.pos.z);
                return o;
            }

            half4 frag(Vin i) : SV_Target
            {
                i.color.rgb = MixFog(i.color.rgb, i.fogCoord);
                return i.color;
            }
            ENDHLSL
        }
    }
}