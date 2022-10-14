// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Target + 2 × Blend - 1

Shader "Blend Modes/Linear Light" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// (T+2×B-1)×a + T×(1-a)  =  T + 2×a×B - a
	SubShader {
		Tags { "Queue" = "Transparent" }

		// P1  =  a×B + T/2
		Pass {
			BlendOp Add
			Blend One SrcAlpha

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
				color.rgb = color.a * color.rgb;
				color.a = 0.5;
				return color;
			}
			ENDCG
		}

		// P2  =  P1 - a/2  =  (T + 2×a×B - a) / 2
		Pass {
			BlendOp RevSub
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
				color.rgb = 0.5 * color.a;
				return color;
			}
			ENDCG
		}

		// P3  =  P2 + P2  =  T + 2×a×B - a
		Pass {
			BlendOp Add
			Blend DstColor One
			SetTexture [_MainTex] {
				ConstantColor (1,1,1,1)
				Combine Constant
			}
		}
	}
}
