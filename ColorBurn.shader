// Copyright (c) 2022 Nuno Cruces
//
// Formula:	1 - (1-Target) / Blend

Shader "Blend Modes/Color Burn" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// (1-(1-T)/B)×a + T×(1-a)  =  1 - (1-T) × (a/B+1-a)
	SubShader {
		Tags { "Queue" = "Transparent" }

		// P1  =  1-T
		Pass {
			BlendOp Add
			Blend OneMinusDstColor Zero
			SetTexture [_MainTex] {
				ConstantColor (1,1,1,1)
				Combine Constant
			}
		}

		// The next 5 passes multiply by repeated doubling:
		// P6  =  P1 × (a/B+1-a)  =  (1-T) × (a/B+1-a)

		Pass {
			BlendOp Add
			Blend DstColor One

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
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = step(1, color.rgb);
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
			uniform float _Opacity;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = _Opacity * color.a;
				color.rgb = color.a / color.rgb - color.a;
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
			uniform float _Opacity;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = _Opacity * color.a;
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = step(7, color.rgb);
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
			uniform float _Opacity;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = _Opacity * color.a;
				color.rgb = color.a / color.rgb - color.a;
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
			uniform float _Opacity;

			half4 frag(v2f_img i) : COLOR
			{
				half4 color = tex2D(_MainTex, i.uv);
				color.a = _Opacity * color.a;
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = log2(1 + color.rgb);
				color.rgb = max(frac(color.rgb), color.rgb - 4);
				color.rgb = (0.3443 * color.rgb + 0.6557) * color.rgb;
				return color;
			}
			ENDCG
		}

		// P7  =  1-P6  =  1 - (1-T) × (a/B+1-a)
		Pass {
			BlendOp Add
			Blend OneMinusDstColor Zero
			SetTexture [_MainTex] {
				ConstantColor (1,1,1,1)
				Combine Constant
			}
		}
	}
}
