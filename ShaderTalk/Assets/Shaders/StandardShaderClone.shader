Shader "Lumosity/StandardShaderClone" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_FilledColor ("Filled Color", Color) = (0,0,0,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MaskTex ("Mask (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Power ( "Power", Range ( 0, 20 )) = 4
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		//sampler2D _MaskTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _FilledColor;
		half _Power;
		
		int isSierpinskiCarpetPixelFilled (int x, int y)
		{
		    while ( x > 0 || y > 0)
		    {
		        if ( x%3 == 1 && y%3 == 1 )
		        {
		            return 0;
		        }
		        
		        x /= 3;
		        y /= 3;
		    }
		    return 1;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float size = pow ( 3, floor ( _Power ) );
			
			if ( IN.uv_MainTex.x > 0.5 )
			{		
				if ( isSierpinskiCarpetPixelFilled ( IN.uv_MainTex.x * size, IN.uv_MainTex.y * size ) )
				{
				
					o.Albedo = _FilledColor.rgb;
					o.Albedo.r = 1;
					//o.Emissions = 
				}
				else
				{
					o.Albedo = _Color.rgb;
				}
			}
//			else
//			{
//				o.Albedo = 
//			}
			
//			fixed4 e = tex2D (_MaskTex, IN.uv_MainTex);
//			o.Albedo = o.Albedo * e.rgb;
//			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			//o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
