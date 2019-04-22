// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Phong"
{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white"{}

        _Shine("Shine", Float) = 10
        _SpecColor("Specular Color", Color) = (1,1,1,1) 
    }

    SubShader{
        tags {"RenderType" = "Opaque"}
        LOD 200 

        Pass{
            Tags{"LightMode" = "ForwardAdd"}
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 

            #include "UnityCG.cginc"

            uniform float4 _LightColor0;

            sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shine;


            struct vertexShaderInput{
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float2 uv: TEXCOORD0;
            };
            struct vertexShaderOutput{
                float4 pos: SV_POSITION;
                float3 normal: NORMAL;
                float2 uv: TEXCOORD0;
                float4 posWorld: TEXCOORD1; 
            };
            vertexShaderOutput vert(vertexShaderInput v){
                vertexShaderOutput o;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz); 
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float frag(vertexShaderOutput i): COLOR{

                float3 P = i.posWorld.xyz;
                float3 normalDirection = normalize(i.normal);
                float3 viewDirection = normalize(_WorldSpaceCameraPos - P);
                float3 vert2LightSource = normalize(_WorldSpaceLightPos0.xyz - P);
                float comboviewvert = normalize(viewDirection + vert2LightSource);
                float3 Kd  = _Color.rgb;
                float Ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float Ks = _SpecColor.rgb;
                float K1 = _LightColor0.rgb;

                float3 ambient = Ka;

                float diffuseVal = max(dot(normalDirection,vert2LightSource), 0);
                float3 diffuse = Kd * K1 * diffuseVal;

                float specularVal = pow(max(dot(normalDirection,comboviewvert), 0), _Shine);

                if(diffuseVal <= 0){
                    specularVal = 0;
                }

                float3 specular = Ks * K1 * specularVal;

            

                return float4 ((ambient + diffuse) * tex2D(_MainTex, i.uv) + specular, 1.0);
            }
            ENDCG
        }
    }
}
