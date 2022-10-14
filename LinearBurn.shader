// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Target + Blend - 1

Shader "Blend Modes/Linear Burn" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// (T+B-1)×a + T×(1-a)  =  T - a×(1-B)
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
				color.rgb = 1 - color.rgb;
				return color;
			}
			ENDCG
		}
	}
}
