// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/Textured" {
	Properties {
		_BaseTex ("Base (RGB)", 2D) = "white" {}
	}
	
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert_textured
            #pragma fragment frag_textured
           
           	uniform sampler2D _BaseTex;
           
            void vert_textured(float4 v:POSITION, float2 tc_in:TEXCOORD0,
                               out float2 tc_out:TEXCOORD0, out float4 sv:SV_POSITION) {
                sv = mul(UNITY_MATRIX_MVP, v);
                tc_out = tc_in;
            }

            float4 frag_textured(float2 tc:TEXCOORD0) : COLOR {
             	return(tex2D(_BaseTex, tc));
            }

            ENDCG
        }
    }
}