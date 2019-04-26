Shader "Custom/Frg" {
    Properties {

    }
    SubShader {
        Pass{
            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag 

            struct appdata {
                float4 pos : POSITION;
            };

            struct v2f {
                float4 pos : SV_POSITION; 
                float3 vertex: POSITION1;    
            };

            v2f vert(appdata i ){
                v2f o;
                o.pos = UnityObjectToClipPos(i.pos);
                o.vertex = mul(unity_ObjectToWorld, i.pos).xyz;
                return o;
            }

            half frag(v2f i) : COLOR{
                return half4(abs((i.vertex - floor(i.vertex)) - 0.5) * 2,1.0f);
            }
            ENDCG
        }
    }
}