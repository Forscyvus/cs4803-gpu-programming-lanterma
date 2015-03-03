// Aaron Lanterman, July 18, 2014
// Cobbled together from numerous sources
Shader "GPUXX/FancyPostProcTest" {
	Properties {
		_EncDepthNormalTex ("Encoded Depth/Normal Map", 2D) = "white" {}
		_OriginalImageTex ("Original Image", 2D) = "white" {}
		_Thickness ("Thickness", Float) = 0
		_Sensitivity ("Sensitivity", Float) = 0
	}
		
    SubShader {
    
    Tags { "RenderType"="Opaque" }
	LOD 300
	
        Pass {
        	CGPROGRAM
			#include "UnityCG.cginc"

            #pragma vertex vert_fancypostproctest
            #pragma fragment frag_fancypostproctest
            #pragma target 3.0
           
           	uniform sampler2D _EncDepthNormalTex;
           	uniform sampler2D _OriginalImageTex;
            float _Thickness;
            float _Sensitivity;
           		
           	uniform float4 _CameraData;
           	
			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};
 
            v2f vert_fancypostproctest(appdata_t v) {
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

     		float4 frag_fancypostproctest(v2f input,
     							  float4 screenPos : WPOS) : COLOR {
     	     	float4 encDepthNormal = tex2D(_EncDepthNormalTex, input.texcoord);
     	     	float4 originalImage = tex2D(_OriginalImageTex, input.texcoord);
     	     	
     	     	float4 depthUp = tex2D(_EncDepthNormalTex, float2(input.texcoord.x, input.texcoord.y - _Thickness));
     	     	float4 depthDown = tex2D(_EncDepthNormalTex, float2(input.texcoord.x, input.texcoord.y + _Thickness));
     	     	float4 depthLeft = tex2D(_EncDepthNormalTex, float2(input.texcoord.x - _Thickness, input.texcoord.y));
     	     	float4 depthRight = tex2D(_EncDepthNormalTex, float2(input.texcoord.x + _Thickness, input.texcoord.y));
     	     	
     	     	//float4 texUp = tex2D(_OriginalImageTex, float2(input.texcoord.x, input.texcoord.y - _Thickness));
     	     	//float4 texDown = tex2D(_OriginalImageTex, float2(input.texcoord.x, input.texcoord.y + _Thickness));
     	     	//float4 texLeft = tex2D(_OriginalImageTex, float2(input.texcoord.x - _Thickness, input.texcoord.y));
     	     	//float4 texRight = tex2D(_OriginalImageTex, float2(input.texcoord.x + _Thickness, input.texcoord.y));
     	     	
     	     	//float4 ambientOcclusion = ( dot(depth
     	     	
     	     	
     	     	
     	     	float3 normalVS;
     	     	float3 upnormalVS;
     	     	float3 downnormalVS;
     	     	float3 leftnormalVS;
     	     	float3 rightnormalVS;
     		    float z01mapped;
     		    float upz01mapped;
     		    float downz01mapped;
     		    float leftz01mapped;
     		    float rightz01mapped;     		    
     		   
     		    DecodeDepthNormal(encDepthNormal, z01mapped, normalVS);
     		    DecodeDepthNormal(depthUp, upz01mapped, upnormalVS);
     		    DecodeDepthNormal(depthDown, downz01mapped, downnormalVS);
     		    DecodeDepthNormal(depthLeft, leftz01mapped, leftnormalVS);
     		    DecodeDepthNormal(depthRight, rightz01mapped, rightnormalVS);
				normalVS = normalize(normalVS);
				upnormalVS = normalize(upnormalVS);
				downnormalVS = normalize(downnormalVS);
				leftnormalVS = normalize(leftnormalVS);
				rightnormalVS = normalize(rightnormalVS);
				
				float edginess = abs((upz01mapped + downz01mapped + leftz01mapped + rightz01mapped) - (4 * z01mapped));
				
				float ambientOcclusion = ( saturate(dot(upnormalVS, normalVS)) + saturate(dot(downnormalVS, normalVS))
											 + saturate(dot(leftnormalVS, normalVS)) + saturate(dot(rightnormalVS, normalVS)) ) / 4.0;
				//float ambientOcclusion = 1;
				
				
				// _CameraData.z = far - near; _CameraData.w = near;
     		 	float zRecon = z01mapped * _CameraData.z + _CameraData.w;						   	
				float2 xy_minus1to1 = (2 * screenPos.xy / _ScreenParams.xy) - 1;
				float2 xyRecon = xy_minus1to1 * zRecon * _CameraData.xy;
				float3 posVS = float3(xyRecon,zRecon);
				
				// Try this return for a primitive normal-based "edge detector"
     		    //return float4(originalImage.rgb * (abs(normalVS.b) < 0.35),1);
     		    float4 result;
     		    if (edginess > _Sensitivity) {
     		    	result = float4(0,0,0,0);
     		    } else {
     		    	result = originalImage * ambientOcclusion;
     		    	//result = float4(ambientOcclusion, ambientOcclusion, ambientOcclusion, 0);
     		    	//UNCOMMENT ABOVE LINE TO SEE ONLY EFFECTS, NO ORIGINAL IMAGE AT ALL.
     		    }
     		    return result;
     		    //return float4(encDepthNormal.z, encDepthNormal.z, encDepthNormal.z, 1);
     		    
     		    // Try this line for primitive fog effect (background fades to white)
     		    // return float4(lerp(originalImage,float4(1,1,1,1),z01mapped));
     	    }

            ENDCG
        }
    }
}
