// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Blend

Shader "Blend Modes/Normal" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// B×a + T×(1-a)
	SubShader {
		Tags { "Queue" = "Transparent" }

		Pass {
			BlendOp Add
			Blend SrcAlpha OneMinusSrcAlpha

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
