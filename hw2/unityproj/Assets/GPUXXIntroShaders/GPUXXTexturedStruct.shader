// Modified version of SolidColor shader from
// http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/TexturedStruct" {
	Properties {
		_BaseTex ("Base (RGB)", 2D) = "white" {}
	}
		
    SubShader {
        Pass {
        	CGPROGRAM

            #pragma vertex vert_texturedstruct
            #pragma fragment frag_texturedstruct
           
           	uniform sampler2D _BaseTex;	// uniform keyword optional
           	
           	struct a2v {    			// application to vertex
           		float4 v: POSITION;
           		float2 tc: TEXCOORD0;	// not same as TEXCOORD0 below
           	};
           	
			struct v2f {				// vertex to fragment
           		float4 sv: SV_POSITION;
           		float2 tc: TEXCOORD0;   // not same as TEXCOORD0 above
           	};
 
            v2f vert_texturedstruct(a2v input) {
                v2f output;           
                output.sv = mul(UNITY_MATRIX_MVP, input.v);
                output.tc = input.tc;
                float AA = 1;
                float B = 10;
                float C = .5;
                float D = 1;
                float E = 10;
                float F = .5;
                output.tc.x += AA*sin(B*input.tc.y)*sin(C*_Time.x);
                output.tc.y += D*sin(E*input.tc.x)*sin(F*_Time.x);
                return output;
            }

     		float4 frag_texturedstruct(v2f input) : COLOR {
                  return(tex2D(_BaseTex, input.tc));
            }

            ENDCG
        }
    }
}
