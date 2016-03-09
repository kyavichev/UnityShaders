Shader "Lumosity/Sprite/Steve"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,0,0,1)
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
                float2 savedVertices : TEXCOORD1;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
            };
           
            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _MainTex_ST;
            float _Edge;
            float _Strength;

  
            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
                OUT.texcoord = IN.texcoord - half2( 0.5, 0.5 );
                OUT.color = IN.color * _Color;
                //OUT.texUV = IN.savedVertices * _MainTex_ST.xy + _MainTex_ST.w;
                #ifdef PIXELSNAP_ON
                OUT.vertex = UnityPixelSnap (OUT.vertex);
                #endif
                return OUT;
            }
            
//            v2f vert (appdata_t v)
//            {
//                v2f o;
//                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
//                o.texcoord = v.texcoord - half2(0.5,0.5);
////                v.color = new Color(0.3f, 0.3f, 0.3f, 0.3f);
//                o.color = (.2,.5,.7,1);
//                o.texUV = v.savedVertices * _MainTex_ST.xy + _MainTex_ST.w;
//               
//                return o;
//            }
// 
           
//            fixed4 frag(v2f IN) : COLOR
//            {
//	            fixed4 result = tex2D(_MainTex, IN.texcoord); // * IN.color;
//	            
//	            float dist = distance(result.rgb, _ColorToReplace1);
//	            if ( dist < _Threashold )
//	            {
//	            	float factor = saturate(1.0 - dist / _Threashold);
//	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith1, factor);
//	            	return result;
//	           	}
//	           	
//	           	dist = distance(result.rgb, _ColorToReplace2);
//	            if ( dist < _Threashold )
//	            {
//	            	float factor = saturate(1.0 - dist / _Threashold);
//	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith2, factor);
//	            	return result;
//	           	}
//	           	
//	           	dist = distance(result.rgb, _ColorToReplace3);
//	            if ( dist < _Threashold )
//	            {
//	            	float factor = saturate(1.0 - dist / _Threashold);
//	            	result.rgb = lerp(result.rgb, _ColorToReplaceWith3, factor);
//	            	return result;
//	           	}
//	           	
//	           	return result;
//            }
            
            
            fixed4 frag(v2f IN) : COLOR
            {
                fixed4 col = fixed4(0,0,0,1); 
                fixed4 transparent = fixed4( 1, 1, 1, 0.2 );
                float l = length(IN.texcoord);
                float thresholdWidth = length(float2(ddx(l),ddy(l))) * _Edge;
 
                float antialiasedCircle = saturate(((1.0 - ( thresholdWidth * 0.25) - (l * 2)) / thresholdWidth) + 0.5) ;
                return lerp( transparent, col, antialiasedCircle);
            }
        ENDCG
        }
    }
}