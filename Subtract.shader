// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Target - Blend

Shader "Blend Modes/Subtract" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// (T-B)×a + T×(1-a)  =  T - a×B
	SubShader {
		Tags { "Queue" = "Transparent" }

		Pass {
			BlendOp RevSub
			Blend SrcAlpha One

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
				return color;
			}
			ENDCG
		}
	}
}
