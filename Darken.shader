// Copyright (c) 2022 Nuno Cruces
//
// Formula:	Min(Target, Blend)
// Note:	This mode doesn't support opacity/alpha.

Shader "Blend Modes/Darken" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue" = "Transparent" }

		Pass {
			BlendOp Min
			Blend One One
			SetTexture [_MainTex] {}
		}
	}
}
