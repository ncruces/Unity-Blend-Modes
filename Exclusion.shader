// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Target + Blend - 2 × Target × Blend

Shader "Blend Modes/Exclusion" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// (T+B-2×T×B)×a + T×(1-a)  =  T + a×B - 2×a×T×B
	SubShader {
		Tags { "Queue" = "Transparent" }

		// P1  =  (1-T)×(a×B) + T/2  =  T/2 + a×B - a×T×B
		Pass {
			BlendOp Add
			Blend OneMinusDstColor SrcAlpha

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

		// P2  =  P1 - a×B/2  =  T/2 + a×B/2 - a×T×B
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
				color.rgb = 0.5 * color.a * color.rgb;
				return color;
			}
			ENDCG
		}

		// P3  =  P2 + P2  =  T + a×B - 2×a×T×B
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
