// Copyright (c) 2022 Nuno Cruces
//
// Formula:
//	Blend < 0.5 :  1 - (1-Target) / (2 × Blend)
//	Blend > 0.5 :  Target / (2 × (1-Blend))
//
// Note:
//	Combines Color Dodge and Color Burn.

Shader "Blend Modes/Vivid Light" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_Opacity ("Opacity", Range (0, 1)) = 1
	}

	// B < 0.5 :  (1-(1-T)/(2×B))×a + T×(1-a)  =  1 - (1-T) × (a/(2×B)+1-a)
	// B > 0.5 :  (T/(2×(1-B)))×a + T×(1-a)    =  T × (a/(2×(1-B))+1-a)
	SubShader {
		Tags { "Queue" = "Transparent" }

		// B < 0.5 :  P1  =  (1-T)×1 + T×(1-0)  =  (1-T)
		// B > 0.5 :  P1  =  (1-T)×0 + T×(1-1)  =  T
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
				color.rgb = step(color.rgb, 0.5);
				return color;
			}
			ENDCG
		}

		// The next 5 passes multiply by repeated doubling:
		// B < 0.5 :  P6  =  P1 × (a/(2×B)+1-a)      =  (1-T) × (a/(2×B)+1-a)
		// B > 0.5 :  P6  =  P1 × (a/(2×(1-B))+1-a)  =  T × (a/(2×(1-B))+1-a)

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
				color.rgb = 2 * min(color.rgb, 1 - color.rgb);
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
				color.rgb = 2 * min(color.rgb, 1 - color.rgb);
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
				color.rgb = 2 * min(color.rgb, 1 - color.rgb);
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
				color.rgb = 2 * min(color.rgb, 1 - color.rgb);
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
				color.rgb = 2 * min(color.rgb, 1 - color.rgb);
				color.rgb = color.a / color.rgb - color.a;
				color.rgb = log2(1 + color.rgb);
				color.rgb = max(frac(color.rgb), color.rgb - 4);
				color.rgb = (0.3443 * color.rgb + 0.6557) * color.rgb;
				return color;
			}
			ENDCG
		}

		// B < 0.5 :  P7  =  (1-P6)  =  1 - (1-T) × (a/(2×B)+1-a)
		// B > 0.5 :  P7  =  P6      =  T × (a/(2×(1-B))+1-a)
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
				color.rgb = step(color.rgb, 0.5);
				return color;
			}
			ENDCG
		}
	}
}
