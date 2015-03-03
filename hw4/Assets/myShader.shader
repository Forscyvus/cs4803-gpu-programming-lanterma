Shader "Custom/myShader" {
	Properties {
		_MainTex ("Rando (RGB)", 2D) = "white" {}
		_BaseTex ("Base (RGB)", 2D) = "white" {}
		_DiffMinRed ("Diffuse Min Red", Float) = 20
		_DiffMinGreen ("Diffuse Min Green", Float) = 0
		_DiffMinBlue ("Diffuse Min Blue", Float) = 20
		_DiffMaxRed ("Diffuse Max Red", Float) = 50
		_DiffMaxGreen ("Diffuse Max Green", Float) = 0
		_DiffMaxBlue ("Diffuse Max Blue", Float) = 100
		_PurpleShininess("Purple Shininess", Float) = 2
		_OrangeShininess("Orange Shininess", Float) = 3
		_Sparkliness("Sparkliness", Float) = 2
		_Sparkliness2("Sparkliness2", Float) = 1
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		
		
		
		
		
		
		CGPROGRAM
		#pragma surface surf MyLambert
		
		
		
		

		sampler2D _MainTex;
		sampler2D _BaseTex;
		float _DiffMinRed;
		float _DiffMinGreen;
		float _DiffMinBlue;
		float _DiffMaxRed;
		float _DiffMaxGreen;
		float _DiffMaxBlue;
		float _PurpleShininess;
		float _OrangeShininess;
		float _Sparkliness;
		float _Sparkliness2;
		
		half4 LightingMyLambert (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
			half diff = max (0, dot (s.Normal, lightDir));
			half specishDiff = pow (diff, _PurpleShininess);
			//half diff2 = max (0, dot(s.Normal, viewDir));
			half diff2 = s.Alpha;
			half specishDiff2 = pow(diff2, _OrangeShininess);
			half4 c;
			
			half diffatten2 = diff*atten*2;
			
			//half cutoff = .9;
			
			half r;
			half g;
			half b;
			
			if (s.Albedo.b == .5) {
				r = lerp(_DiffMinRed, _DiffMaxRed, specishDiff);
				g = lerp(_DiffMinGreen, _DiffMaxGreen, specishDiff);
				b = lerp(_DiffMinBlue, _DiffMaxBlue, specishDiff);
				
				
			} else {
				r = lerp(80, 150, specishDiff2);
				g = lerp(0, 100, specishDiff2);
				b = lerp(150, -100, specishDiff2);
				
			}
			c.rgb = (half3(saturate(r/255.0), saturate(g/255.0), saturate(b/255.0)) * diffatten2) ;
			
			//c.rgb = s.Albedo * half3(.3, .3, .6) * diff * atten * 2;
			//c.rgb = s.Albedo * diff * atten * 2;
			
			c.a = s.Alpha;
			return c;
		}

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
			float3 worldPos;
			float3 worldNormal;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float3 viewDir = normalize(IN.viewDir);
			float3 worldNormal = normalize(IN.worldNormal);
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			//float r = lerp(_DiffMinRed, _DiffMaxRed, max(0,dot(viewDir, worldNormal)));
			//float g = lerp(_DiffMinGreen, _DiffMaxGreen, max(0,dot(viewDir, worldNormal)));
			//float b = lerp(_DiffMinBlue, _DiffMaxBlue, max(0,dot(viewDir, worldNormal)));
			//o.Albedo = float3(saturate(r/255.0), saturate(g/255.0), saturate(b/255.0));
			//o.Albedo = float3(saturate(_DiffMaxRed/255.0), saturate(_DiffMaxGreen/255.0), saturate(_DiffMaxBlue/255.0));
			
			half NdotV = dot(viewDir, worldNormal);
			
			float cutoff = max(.85,NdotV);
			
			if (pow(c.r, _Sparkliness2) < pow(cutoff, _Sparkliness)) {
				//o.Albedo = c.rgb;
				o.Albedo = c.rgb;
			} else {
				o.Albedo = half3(.5,.5,.5);
			}
			o.Alpha = NdotV;
		}
		ENDCG
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	} 
	FallBack "Diffuse"
}
