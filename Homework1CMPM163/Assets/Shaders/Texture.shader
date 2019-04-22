Shader "Custom/Texture" {
    Properties {
        _Color("Color",Color) = (1,1,1,1)
      _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members vertex,uv)
#pragma exclude_renderers d3d11
      #pragma vertex vert 
      #pragma fragment frag
      #include "UnityCG.cginc"

      struct appdata {
          float4 vertex = POSITION;
          float2 uv = TEXCOORD0;
      };
      struct v2f{
          float4 pos = POSITION:
      };
      sampler2D _MainTex;
    
      ENDCG
    } 
  }
