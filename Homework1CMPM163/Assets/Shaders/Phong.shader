Shader "Custom/PhongShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Shininess ("Shininess", Float) = 10 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"

            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess; 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 vertexInWorldCoords : TEXCOORD1;
                float3 normal: NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                    float3 A = normalize(i.normal);
                    float3 B = normalize(_WorldSpaceCameraPos - i.vertexInWorldCoords.xyz);

                    float3 C = _WorldSpaceLightPos0.xyz - i.vertexInWorldCoords.xyz;
                    float D = 1.0 / length(C);
                    float E = lerp(1.0, D, _WorldSpaceLightPos0.w); 
                    float3 F = _WorldSpaceLightPos0.xyz - i.vertexInWorldCoords.xyz * _WorldSpaceLightPos0.w;

                    float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb; 
                    float3 diffuse = E * _LightColor0.rgb * _Color.rgb * max(0.0, dot(A, F)); 
                    float3 specular;
                    if (dot(i.normal, F) < 0.0) 
                    {
                        specular = float3(0.0, 0.0, 0.0);
                	  }
                    else
                    {
                        specular = E * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-F, A), B)), _Shininess);
                    }

                    float3 phong = (ambientLighting + diffuse + specular) * tex2D(_MainTex, i.uv); 
                    return float4(phong, 1.0);
            }
            ENDCG
        }
        Pass
        {  
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
              
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
    
            #include "UnityCG.cginc"

            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess; 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 vertexInWorldCoords : TEXCOORD1;
                float3 normal: NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                    float3 A = normalize(i.normal);
                    float3 B = normalize(_WorldSpaceCameraPos - i.vertexInWorldCoords.xyz);

                    float3 C = _WorldSpaceLightPos0.xyz - i.vertexInWorldCoords.xyz;
                    float D = 1.0 / length(C);
                    float E = lerp(1.0, D, _WorldSpaceLightPos0.w); 
                    float3 F = _WorldSpaceLightPos0.xyz - i.vertexInWorldCoords.xyz * _WorldSpaceLightPos0.w;

                    float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb; 
                    float3 diffuse = E * _LightColor0.rgb * _Color.rgb * max(0.0, dot(A, F)); 
                    float3 specular;
                    if (dot(i.normal, F) < 0.0) 
                    {
                        specular = float3(0.0, 0.0, 0.0);
                	  }
                    else
                    {
                        specular = E * _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-F, A), B)), _Shininess);
                    }

                    float3 phong = (diffuse + specular) * tex2D(_MainTex, i.uv); 
                    return float4(phong, 1.0);
            }
            ENDCG
        }
    
    }
}
