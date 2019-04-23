Shader "Custom/Texture" {
    Properties {
        _Color("Color",Color) = (1,1,1,1)
      _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
        Pass{

        }      
    } 
}
