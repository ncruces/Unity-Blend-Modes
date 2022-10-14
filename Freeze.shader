// Copyright (c) 2022 Nuno Cruces
//
// Formula:	1 - (1-Target)² / Blend
// Note:	This mode doesn't support opacity/alpha correctly.

Shader "Blend Modes/Freeze" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	// 1 - (1-T)² × (a/B + (1-a))
	SubShader {
		Tags { "Queue" = "Transparent" }

		// P1  =  1-T
		Pass {
			BlendOp Add
			Blend OneMinusDstColor Zero
			SetTexture [_MainTex] {
				ConstantColor (1,1,1,1)
				Combine Constant
			}
		}

		// The next 3 passes multiply by repeated doubling:
		// P4  =  P1 × Sqrt(a/B+1-a)  =  (1-T) × Sqrt(a/B+1-a)

		Pass {
			BlendOp Add
			Blend DstColor One

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = step(3, color.rgb);
				return color;
			}
			ENDCG
		}

		Pass {
			BlendOp Add
			Blend DstColor One

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = step(15, color.rgb);
				return color;
			}
			ENDCG
		}

		Pass {
			BlendOp Add
			Blend DstColor One

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = 0.5 * log2(1 + color.rgb);
				color.rgb = max(frac(color.rgb), color.rgb - 2);
				color.rgb = (0.3443 * color.rgb + 0.6557) * color.rgb;
				return color;
			}
			ENDCG
		}

		// P5  =  (1-P4) + P4×(1-P4)  =  1-P4²  =  1 - (1-T)² × (a/B+1-a)
		Pass {
			BlendOp Add
			Blend OneMinusDstColor OneMinusDstColor
			SetTexture [_MainTex] {
				ConstantColor (1,1,1,1)
				Combine Constant
			}
		}
	}
}
