// Copyright (c) 2022 Nuno Cruces
//
// Formula:
//	Blend < 0.5 :  2 × Target × Blend
//	Blend > 0.5 :  1 - 2 × (1-Target) × (1-Blend)

Shader "Blend Modes/Hard Light" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// B < 0.5 :  (2×T×B)×a + T×(1-a)            =  T - a×T + 2×a×T×B
	// B > 0.5 :  (1-2×(1-T)×(1-B))×a + T×(1-a)  =  T + a×T - 2×a×T×B + a×T - a
	SubShader {
		Tags { "Queue" = "Transparent" }

		// B < 0.5 :  P1  =  (1-T)×0 + T×(1-1)  =  T
		// B > 0.5 :  P1  =  (1-T)×1 + T×(1-0)  =  (1-T)
		Pass {
			BlendOp Add
			Blend OneMinusDstColor OneMinusSrcColor

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.rgb = step(0.5, color.rgb);
				return color;
			}
			ENDCG
		}

		// B < 0.5 :  P2  =  ((B-0.5)×a+0.5)×P1 + P1×((B-0.5)×a+0.5)  =  T - a×T + 2×a×T×B
		// B > 0.5 :  P2  =  ((0.5-B)×a+0.5)×P1 + P1×((0.5-B)×a+0.5)  =  1 - (T + a×T - 2×a×T×B + a×T - a)
		Pass {
			BlendOp Add
			Blend DstColor SrcColor

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float _Opacity;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = _Opacity * color.a;
				color.rgb = min(color.rgb - 0.5, 0.5 - color.rgb);
				color.rgb = color.a * color.rgb + 0.5;
				return color;
			}
			ENDCG
		}

		// B < 0.5 :  P3 = P2      =  T - a×T + 2×a×T×B
		// B > 0.5 :  P3 = (1-P2)  =  T + a×T - 2×a×T×B + a×T - a
		Pass {
			BlendOp Add
			Blend OneMinusDstColor OneMinusSrcColor

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.rgb = step(0.5, color.rgb);
				return color;
			}
			ENDCG
		}
	}
}
