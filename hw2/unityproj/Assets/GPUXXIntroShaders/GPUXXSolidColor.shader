// Aaron Lanterman, June 14, 2014
// Modified version of SolidColor shader from
// http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
Shader "GPUXX/SolidColor" {
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert_solidcolor
            #pragma fragment frag_solidcolor

            float4 vert_solidcolor(float4 v:POSITION) : SV_POSITION {
                return mul (UNITY_MATRIX_MVP, v);
            }

            float4 frag_solidcolor() : COLOR {
                return float4(1.0,0.0,0.0,1.0);
            }

            ENDCG
        }
    }
}
