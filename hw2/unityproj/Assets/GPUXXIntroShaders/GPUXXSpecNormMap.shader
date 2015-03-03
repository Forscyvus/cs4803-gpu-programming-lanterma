// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/TexturedSpecNormMap" {
	Properties {
		_BaseTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "bump" {}
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

            #pragma vertex vert_specmappixellit
            #pragma fragment frag_specmappixellit
           
           	uniform sampler2D _BaseTex;	
           	uniform float4 _BaseTex_ST;
           	uniform sampler2D _NormalMap;
           	uniform float4 _NormalMap_ST;
           	
          	uniform float4 _SpecColor;
           	uniform float _Shininess;
           
           	
           	struct a2v {    			
           		float4 v: POSITION;
           		float3 n: NORMAL;
           		float4 t: TANGENT;
           		float2 tc: TEXCOORD0;	
           	};
           	
			struct v2f {				
           		float4 sv: SV_POSITION;
           		float2 bmap_tc: TEXCOORD0;   
           		float2 nmap_tc: TEXCOORD1;   
           		float3 vWorldPos: TEXCOORD2;     
           		float3 nWorld: TEXCOORD3;  
           		float3 tWorld: TEXCOORD4;  
           		float3 btWorld: TEXCOORD5; // bitangent is the correct term for this; the Unity docs,
           								   // call it a "binormal," which while common, is WRONG.
           	};
 
            v2f vert_specmappixellit(a2v input)  {
                v2f output;           
                output.sv = mul(UNITY_MATRIX_MVP, input.v);
                output.vWorldPos = mul(_Object2World, input.v).xyz;
                // To transform normals, we want to use the inverse transpose of upper left 3x3
                // Putting input.n in first argument is like doing trans((float3x3)_World2Object) * input.n;
                output.nWorld = normalize(mul(input.n, (float3x3) _World2Object));
			    output.tWorld = normalize(mul((float3x3) _Object2World, input.t.xyz));
				output.btWorld = normalize(cross(output.nWorld, output.tWorld)
             				     * input.t.w); // Flip tangents if needed (memory saving trick)
               
                output.bmap_tc = TRANSFORM_TEX(input.tc, _BaseTex);
                output.nmap_tc = TRANSFORM_TEX(input.tc, _NormalMap);
                return output;
            }

     		float4 frag_specmappixellit(v2f input) : COLOR {
				// need to map [0,1] "colors" to [-1,1]
				//float2 nMapXY = 2 * tex2D(_NormalMap, input.nmap_tc).ag - 1;
				//float nMapRecreatedZ = sqrt(1 - saturate(dot(nMapXY,nMapXY)));
				float2 nMapXY = 2 * tex2D(_NormalMap, input.nmap_tc).ag - 1;
				float nMapRecreatedZ = sqrt(1 - saturate(dot(nMapXY,nMapXY)));

				// we are renormalizing because the GPU's interpolator doesn't know these are unit vectors;
				// we can usually get away with not bothering to do it, though
				float3 nW = normalize(input.nWorld); 
				float3 tW = normalize(input.tWorld);
				float3 btW = normalize(input.btWorld);
				
				float3 newNormal = tW * nMapXY.x + btW * nMapXY.y + nW * nMapRecreatedZ;
				newNormal = normalize(newNormal);
				
				// Unity light position convention is:
                // w = 0, directional light, with x y z pointing in opposite of light direction 
                // w = 1, point light, with x y z indicating position coordinates
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - input.vWorldPos * _WorldSpaceLightPos0.w);
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - input.vWorldPos);
   				float3 h = normalize(lightDir + eyeDir);
				float3 diff_almost = 2*unity_LightColor0.rgb * max(0, dot(newNormal, lightDir));
				float ndoth = max(0,dot(newNormal, h));
				float3 spec_almost = 2*unity_LightColor0.rgb * _SpecColor.rgb * pow(ndoth, _Shininess*128.0);
            	
     			float4 base = tex2D(_BaseTex, input.bmap_tc);
     			float3 output = (diff_almost + 2*UNITY_LIGHTMODEL_AMBIENT.rgb) * base.rgb
     				  			 + spec_almost.rgb * base.a;
     			return(float4(output,1));    
            }

            ENDCG
        }
    }
}
