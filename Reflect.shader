// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Target² / (1-Blend)
// Note:	This mode doesn't support opacity/alpha correctly.

Shader "Blend Modes/Reflect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
	}

	// T² × (a/(1-B) + (1-a))
	SubShader {
		Tags { "Queue" = "Transparent" }

		// The next 3 passes multiply by repeated doubling:
		// P3  =  T × Sqrt(a/(1-B)+1-a)

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
				color.rgb = color.a / (1 - color.rgb) - color.a;
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
				color.rgb = color.a / (1 - color.rgb) - color.a;
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
				color.rgb = color.a / (1 - color.rgb) - color.a;
				color.rgb = 0.5 * log2(1 + color.rgb);
				color.rgb = max(frac(color.rgb), color.rgb - 2);
				color.rgb = (0.3443 * color.rgb + 0.6557) * color.rgb;
				return color;
			}
			ENDCG
		}

		// P4  =  P3 × P3  =  T² × [a/(1-B) + (1-a)]
		Pass {
			BlendOp Add
			Blend Zero DstColor
			SetTexture [_MainTex] {}
		}
	}
}
