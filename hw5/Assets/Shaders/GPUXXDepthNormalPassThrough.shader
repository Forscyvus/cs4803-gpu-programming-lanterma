// Aaron Lanterman, July 18, 2014
// Cobbled together from numerous sources

// For debugging; just passes the RGBA-encoded depth/normal map
// directly to the output. Could easily work on other kinds of
// textures; just rename the variables as needed.

Shader "GPUXX/DepthNormalPassThrough" {
	Properties {
		_EncDepthNormalTex ("Encoded Depth/Normal Map", 2D) = "white" {}
	}
		
    SubShader {
    
    Tags { "RenderType"="Opaque" }
	LOD 300
	
        Pass {
        	CGPROGRAM
			#include "UnityCG.cginc"

            #pragma vertex vert_depthnormalpassthrough
            #pragma fragment frag_depthnormalpassthrough
           
           	uniform sampler2D _EncDepthNormalTex;	
           	
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};
 
            v2f vert_depthnormalpassthrough(appdata_t v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

     		float4 frag_depthnormalpassthrough(v2f input,
     							  			   float4 screenPos : WPOS) : COLOR {
     	     	float4 encDepthNormal = tex2D(_EncDepthNormalTex, input.texcoord);
     		   	// Try different swizzlings to visualize the various channels
     		    return encDepthNormal.rgba;
     	    }

            ENDCG
        }
    }
}
