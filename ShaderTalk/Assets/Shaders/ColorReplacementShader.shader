Shader "Lumosity/Sprite/ColorChanger"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ( "Tint", Color ) = ( 1, 1, 1, 1 )
        _ColorToReplace1 ( "Color To Replace 1", Color ) = ( 1, 1, 1, 1 )
        _ColorToReplace2 ( "Color To Replace 2", Color ) = ( 1, 0, 0, 1 )
        _ColorToReplace3 ( "Color To Replace 3", Color ) = ( 0, 1, 0, 1 )
        _ColorToReplaceWith1 ( "Color To Replace With 1", Color ) = ( 1, 0, 0, 1 )
        _ColorToReplaceWith2 ( "Color To Replace With 2", Color ) = ( 0, 1, 0, 1 )
        _ColorToReplaceWith3 ( "Color To Replace With 3", Color ) = ( 0, 0, 1, 1 )
        _Threashold ( "Color Threshold", Range ( 0.02, 0.9 ) ) = 0.5
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
    }
 
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
 
        Cull Off
        Lighting Off
        ZWrite Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
        
        
        Pass
        {
        	
       
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#pragma multi_compile DUMMY PIXELSNAP_ON
            #include "UnityCG.cginc"
            
            
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
            };
           
            fixed4 _Color;
            fixed4 _ColorToReplace1;
            fixed4 _ColorToReplace2;
            fixed4 _ColorToReplace3;
            fixed4 _ColorToReplaceWith1;
            fixed4 _ColorToReplaceWith2;
            fixed4 _ColorToReplaceWith3;
            float _Threashold;
            
            sampler2D _MainTex;

  
            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color;
                #ifdef PIXELSNAP_ON
                OUT.vertex = UnityPixelSnap (OUT.vertex);
                #endif
                return OUT;
            }
 
           
            fixed4 frag(v2f IN) : COLOR
            {
	            fixed4 result = tex2D(_MainTex, IN.texcoord); // * IN.color;
	            
	            float dist = distance(result.rgb, _ColorToReplace1);
	            if ( dist < _Threashold )
	            {
	            	float factor = saturate(1.0 - dist / _Threashold);
	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith1, factor);
	            	return result;
	           	}
	           	
	           	dist = distance(result.rgb, _ColorToReplace2);
	            if ( dist < _Threashold )
	            {
	            	float factor = saturate(1.0 - dist / _Threashold);
	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith2, factor);
	            	return result;
	           	}
	           	
	           	dist = distance(result.rgb, _ColorToReplace3);
	            if ( dist < _Threashold )
	            {
	            	float factor = saturate(1.0 - dist / _Threashold);
	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith3, factor);
	            	return result;
	           	}
	           	
	           	return result;
            }
        ENDCG
        }
    }
}