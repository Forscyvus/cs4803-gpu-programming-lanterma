// Aaron Lanterman, June 14, 2014
// Cobbled together from numerous sources
Shader "GPUXX/GeomColor" {
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert_geomcolor
            #pragma fragment frag_geomcolor

            void vert_geomcolor(float4 v:POSITION, out float4 c:COLOR0, out float4 sv:SV_POSITION) {
                sv = mul(UNITY_MATRIX_MVP, v);
                c = float4(v.x, v.y, v.z, 1);
            }

            float4 frag_geomcolor(float4 c:COLOR0) : COLOR {
                return float4(c); // red
            }

            ENDCG
        }
    }
}
