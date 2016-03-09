Shader "Lumosity/Fractal/SierpinskiCarpetShaderNoEmissions" {
	Properties {
		_Color ( "Color", Color ) = ( 1, 0, 0, 1 )
	    _FilledColor ( "Filled Color", Color ) = ( 0, 1, 0, 1 )
	    _Power ( "Power", Range ( 0, 20 )) = 4
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows
		//#pragma surface surf Standard vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};


		fixed4 _Color;
		fixed4 _FilledColor;
		float _Power;
		half _Glossiness;
		half _Metallic;
		//sampler2D _MainTex;
		
		
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
			if ( isSierpinskiCarpetPixelFilled ( IN.uv_MainTex.x * size, IN.uv_MainTex.y * size ) )
			{
				o.Albedo = _FilledColor.rgb;
			}
			else
			{
				o.Albedo = _Color.rgb;
			}
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
	
		
		ENDCG
	} 
	FallBack "Diffuse"
}
