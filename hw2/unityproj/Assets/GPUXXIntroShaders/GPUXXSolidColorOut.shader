// Aaron Lanterman, June 14, 2014
// Modified version of SolidColor shader from
// http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
Shader "GPUXX/SolidColorOut" {
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert_solidcolorout
            #pragma fragment frag_solidcolorout

            void vert_solidcolorout(float4 v:POSITION, out float4 sv:SV_POSITION) {
                sv = mul(UNITY_MATRIX_MVP, v);
            }

            float4 frag_solidcolorout() : COLOR {
                return float4(0.0,1.0,0.0,1.0);
            }

            ENDCG
        }
    }
}