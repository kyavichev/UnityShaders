Shader "Lumosity/Grass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB) Trans (A)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Cutoff ("Shadow alpha cutoff", Range(0,1)) = 0.5
		_Speed ("Speed", Range (-100,100)) = 1
		_Amplifier ("Amplifier", Range(-10,10)) = 0.5
		_RedMap ( "Red Map", 2D ) = "black" {}
		_RedStrength ( "Red Strength", Range ( -20, 20 )) = 1
		_GreenMap ( "Green Map", 2D ) = "black" {}
		_GreenStrength ( "Green Strength", Range ( -20, 20 )) = 1
		_BlueMap ( "Blue Map", 2D ) = "black" {}
		_BlueStrength ( "Blue Strength", Range ( -20, 20 )) = 1
	}
	SubShader {
	
		Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		Cull Off
		LOD 200
		
      	CGPROGRAM
      	//#pragma surface surf Lambert vertex:vert
      	// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert alphatest:_Cutoff addshadow
      	
      	struct Input 
      	{
      		float4 pos;
          	float2 uv_MainTex;
      	};
      	
      	half _Glossiness;
		half _Metallic;
      	
		float _Amplifier;
		float _Speed;
		sampler2D _MainTex;
		sampler2D _RedMap;
		float _RedStrength;
		sampler2D _GreenMap;
		float _GreenStrength;
		sampler2D _BlueMap;
		float _BlueStrength;
		
		
        
		void vert ( inout appdata_full v ) 
		{		
			float sinValue = sin(_Time.x * _Speed) * _Amplifier;
			
			float2 uv = v.texcoord.xy;
			uv.x = 1 - uv.x;
			uv.y = 1 - uv.y;
			
			float4 redValue = tex2D (_RedMap, uv);
			float4 greenValue = tex2D (_GreenMap, uv);
			float4 blueValue = tex2D (_BlueMap, uv);
			
			v.vertex.z += sinValue * redValue.x * _RedStrength;
			v.vertex.y += sinValue * greenValue.y * _GreenStrength;
			v.vertex.x += sinValue * blueValue.z * _BlueStrength;
		}
		
		
		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 pixelColor = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = pixelColor.rgb;
			//o.Albedo.r *= tex2D (_RedMap, IN.uv_MainTex).r;
			//o.Albedo.g *= tex2D (_GreenMap, IN.uv_MainTex).g;
			//o.Albedo.b *= tex2D (_BlueMap, IN.uv_MainTex).b;
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			
			// Alpha
			o.Alpha = pixelColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
