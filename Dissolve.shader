// Copyright (c) 2022 Nuno Cruces
//
// Formula:
//	Random > Alpha : Target
//	Random < Alpha : Blend

Shader "Blend Modes/Dissolve" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

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

			float random(float2 p)
			{
				const float2 r = float2(23.1406926, 2.6651441);
				return frac(fmod(1234567890, 8192 * dot(p,r)));
			}

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = random(i.uv) < color.a * _Opacity;
				return color;
			}
			ENDCG
		}
	}
}
