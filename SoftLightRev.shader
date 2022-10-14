// Copyright (c) 2022 Nuno Cruces
//
// Formula:
//	(1-Blend) × Multiply + Blend × Screen
//
// Note:
//	For this mode, layers must be reversed.

Shader "Blend Modes/Soft Light (Reversed)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// ((1-B)×B×T + B×(1-(1-T)×(1-B)))×a + T×(1-a)  =  a×B² + (1-a + 2×a×(B-B²)) × T
	SubShader {
		Tags { "Queue" = "Transparent" }

		// P1  =  (1-a + 2×a×(B-B²)) × T
		Pass {
			BlendOp Add
			Blend DstColor Zero

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
				color.rgb = color.rgb - color.rgb * color.rgb;
				color.rgb = 1 - color.a + 2 * color.a * color.rgb;
				return color;
			}
			ENDCG
		}

		// P2  =  a×B² + P1  =  a×B² + (1-a + 2×a×(B-B²)) × T
		Pass {
			BlendOp Add
			Blend One One

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
				color.rgb = color.a * color.rgb * color.rgb;
				return color;
			}
			ENDCG
		}
	}
}
