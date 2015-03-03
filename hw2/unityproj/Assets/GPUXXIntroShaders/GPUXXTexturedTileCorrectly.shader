// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/TexturedStructTileCorrectly" {
	Properties {
		_BaseTex ("Base (RGB)", 2D) = "white" {}
	}
		
    SubShader {
        Pass {
        	CGPROGRAM
			#include "UnityCG.cginc"
			// includes #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw) 
			 
            #pragma vertex vert_texturedstruct
            #pragma fragment frag_texturedstruct
           
           	uniform sampler2D _BaseTex;		// uniform keyword optional
           	uniform float4 _BaseTex_ST;     // Unity provides this 
           	
           	struct a2v {    			// application to vertex
           		float4 v: POSITION;
           		float2 tc: TEXCOORD0;	// not same as TEXCOORD0 below
           	};
           	
			struct v2f {				// vertex to fragment
           		float4 sv: SV_POSITION;
           		float2 tc: TEXCOORD0;   // not same as TEXCOORD0 above
           		float depthFactor: TEXCOORD1;
           	};
 
            v2f vert_texturedstruct(a2v input) {
                v2f output;           
                output.sv = mul(UNITY_MATRIX_MVP, input.v);
                float e = 2.8;
                float s = 2;
                output.depthFactor = max(0,min(1,(e-output.sv.z)/(e-s)));
                // Make sure you TRANSFORM_TEX the vertex shader, not the fragment shader!
                output.tc = TRANSFORM_TEX(input.tc, _BaseTex);
                return output;
            }

     		float4 frag_texturedstruct(v2f input) : COLOR {
                  return(tex2D(_BaseTex, input.tc) * input.depthFactor);
            }

            ENDCG
        }
    }
}
