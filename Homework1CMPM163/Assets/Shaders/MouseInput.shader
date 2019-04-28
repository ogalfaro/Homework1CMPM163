// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MouseInput"
{
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
        _mX("Mouse X", Float) = 0
        _mY("Mouse Y", Float) = 0
    }

    
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _Color;
            uniform float _mX;
            uniform float _mY;

			sampler2D _MainTex;
			float4 _MainTex_ST;

            
            struct VertexShaderInput
            {
                float4 vertex: POSITION;
				float2 uv: TEXCOORD0;
            };
            
            struct VertexShaderOutput
            {
                float4 pos: SV_POSITION;
				float2 uv: TEXCOORD0;
            };
            
            VertexShaderOutput vert(VertexShaderInput v)
            {
                VertexShaderOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }
            
            float4 frag(VertexShaderOutput i):COLOR
            {
                float val =abs((_mX/_ScreenParams.x) * tex2D(_MainTex, i.uv));
                return float4(val, val, val, 1);
            }
       
            
            ENDCG
        }
    }
}