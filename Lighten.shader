// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Max(Target, Blend)
// Note:	This mode doesn't support opacity/alpha.

Shader "Blend Modes/Lighten" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "black" {}
	}

	SubShader {
		Tags { "Queue" = "Transparent" }

		Pass {
			BlendOp Max
			Blend One One
			SetTexture [_MainTex] {}
		}
	}
}
