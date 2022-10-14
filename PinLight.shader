// Copyright (c) 2022 Nuno Cruces
//
// Formula:
//	Blend < 0.5 :  Min(Target, 2 × Blend)
//	Blend > 0.5 :  Max(Target, 2 × Blend - 1))
//
// Note:
//	This mode doesn't support opacity/alpha.
//	Combines Lighten and Darken.

Shader "Blend Modes/Pin Light" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "gray" {}
	}

	// B < 0.5 :  Min(T, 2×B)
	// B > 0.5 :  Max(T, 2×B-1)
	SubShader {
		Tags { "Queue" = "Transparent" }

		// B < 0.5 :  P1  =  Max(T, 0)      =  T
		// B > 0.5 :  P1  =  Max(T, 2×B-1)
		Pass {
			BlendOp Max
			Blend One One

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				half4 test = step(0.5, color);
				color = (2 * color - 1) * test;
				return color;
			}
			ENDCG
		}

		// B < 0.5 :  P2  =  Min(P2, 2×B)  =  Min(T, 2×B)
		// B > 0.5 :  P2  =  Min(P2, 1)    =  Max(T, 2×B-1)
		Pass {
			BlendOp Min
			Blend One One

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				half4 test = step(color, 0.5);
				color = 2 * color * test - test + 1;
				return color;
			}
			ENDCG
		}
	}
}
