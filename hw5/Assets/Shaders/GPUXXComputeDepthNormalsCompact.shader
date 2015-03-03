// Aaron Lanterman, July 18, 2014
// Cobbled together from numerous sources
Shader "GPUXX/ComputeDepthNormalsCompact" {
	Properties {
		_BaseTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_CameraData ("Camera Data", Vector) = (0,0,0,0)
	}
		
    SubShader {
        Pass {
        	CGPROGRAM
			#include "UnityCG.cginc"
			 
//			#pragma target 3.0
            #pragma vertex vert_computedepthnormalscompact
            #pragma fragment frag_computedepthnormalscompact
           
           	uniform sampler2D _BaseTex;	
           	uniform float4 _BaseTex_ST;
           	uniform float4 _CameraData;
           	
           	struct a2v {    			
           		float4 v: POSITION;
           		float3 n: NORMAL;
           		float2 tc: TEXCOORD0;	
           	};
           	
			struct v2f {				
           		float4 sv: SV_POSITION;
           		float2 tc: TEXCOORD0;
           		float3 vertexViewSpace: TEXCOORD1;
           		float3 normalViewSpace: TEXCOORD2;  
           	};
 
            v2f vert_computedepthnormalscompact(a2v input)  {
                v2f output;           
                output.sv = mul(UNITY_MATRIX_MVP, input.v);
                output.normalViewSpace = normalize(mul((float3x3) UNITY_MATRIX_IT_MV,input.n));
                output.vertexViewSpace = mul(UNITY_MATRIX_MV,input.v).xyz;
                output.tc = TRANSFORM_TEX(input.tc, _BaseTex);
                return output;
            }

     		float4 frag_computedepthnormalscompact(v2f input,
     										       float4 screenPos : WPOS) : COLOR {
     		    float3 normalViewSpace = normalize(input.normalViewSpace);
     		    float z = -input.vertexViewSpace.z;
     		    // _CameraData.z = far - near; _CameraData.w = near;
				float z01mapped = (z - _CameraData.w) / _CameraData.z;
									
			    float4 depthNormalEnc = EncodeDepthNormal(z01mapped,normalViewSpace);
				return(depthNormalEnc);
            }

            ENDCG
        }
    }
}
