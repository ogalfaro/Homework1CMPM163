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
			half4 _MainTex_TexelSize;

            
            struct VertexShaderInput
            {
                float4 vertex: POSITION;
				float2 uv: TEXCOORD0;
            };
            
            struct VertexShaderOutput
            {
                float4 vertex: SV_POSITION;
				half2 uv[9] : TEXCOORD0;
            };
            
            VertexShaderOutput vert(VertexShaderInput v)
            {
                VertexShaderOutput o;
			
				o.vertex = UnityObjectToClipPos(v.vertex);

				half2 uv = v.uv;

				o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
				o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, 1);
				o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, 1);
				o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
				o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
				o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
				o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
				o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, -1);
				o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, -1);
                
                return o;
            }
            
            fixed4 frag(VertexShaderOutput i):SV_TARGET
            {
				fixed4 col;

				for (int it = 0; it < 9; it++)
				{
					col += tex2D(_MainTex, i.uv[it]);
				}

				col /= abs((_mX / _ScreenParams.x) * 9);

				return col;
                //float val =abs((_mX/_ScreenParams.x) * tex2D(_MainTex, i.uv));
                //return float4(val, val, val, 1);
            }
       
            
            ENDCG
        }
    }
}