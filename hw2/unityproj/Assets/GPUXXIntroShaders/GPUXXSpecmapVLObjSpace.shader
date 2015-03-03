// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/TexturedSpecmapVLObjSpace" {
	Properties {
		_BaseTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_SpecColor ("Spec Color", Color) = (1,1,1,1)
	    _Shininess ("Shininess", Range(0.01,1)) = 0.7
	}
		
    SubShader {
    	// Directional light colors aren't exposed in "ForwardBase" mode, so we try "Vertex" mode,
    	// which really should be called "Simple" mode, as we can still do custom per-pixel lighting
        Tags { "LightMode" = "Vertex" }
    	 
        Pass {
        	CGPROGRAM
			#include "UnityCG.cginc"
			 
            #pragma vertex vert_specmapvlobjspace
            #pragma fragment frag_specmapvlobjspace
           
           	uniform sampler2D _BaseTex;	
           	uniform float4 _BaseTex_ST;
           	
           	uniform float4 _SpecColor;
           	uniform float _Shininess;
           	
           	struct a2v {    			
           		float4 v: POSITION;
           		float3 n: NORMAL;
           		float2 tc: TEXCOORD0;	
           	};
           	
			struct v2f {				
           		float4 sv: SV_POSITION;
           		float2 tc: TEXCOORD0;   
           		float3 diff_almost: TEXCOORD1;     
           		float3 spec_almost: TEXCOORD2;  
           	};
 
            v2f vert_specmapvlobjspace(a2v input)  {
                v2f output;     
                output.sv = mul(UNITY_MATRIX_MVP, input.v);

                float3 lightDir = normalize(ObjSpaceLightDir(input.v));
                float3 eyeDir = normalize(ObjSpaceViewDir(input.v));
   				float3 h = normalize(lightDir + eyeDir);
				output.diff_almost = 2*unity_LightColor0.rgb * max(0, dot(input.n, lightDir));
				float ndoth = max(0, dot(input.n, h));
				output.spec_almost = 2*unity_LightColor0.rgb * _SpecColor.rgb * pow(ndoth, _Shininess*128.0);
				
            	output.tc = TRANSFORM_TEX(input.tc, _BaseTex);
                return output;
            }

     		float4 frag_specmapvlobjspace(v2f input) : COLOR {
     			float4 base = tex2D(_BaseTex, input.tc);
     			float3 output = (input.diff_almost + 2*UNITY_LIGHTMODEL_AMBIENT.rgb) * base.rgb
     				  			 + input.spec_almost.rgb * base.a;
     		 	return(float4(output.rgb,1));		   
            }

            ENDCG
        }
    }
}
