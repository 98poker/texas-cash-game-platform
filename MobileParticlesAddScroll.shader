Shader "Mobile/Particles/AddScroll"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}


            //-------------------add----------------------
	_MinX ("Min X", Float) = -10
    _MaxX ("Max X", Float) = 10
    _MinY ("Min Y", Float) = -10
    _MaxY ("Max Y", Float) = 10
    //-------------------add----------------------
    }

    Category {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend SrcAlpha One
        Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }

        BindChannels {
            Bind "Color", color
            Bind "Vertex", vertex
            Bind "TexCoord", texcoord
        }

        SubShader {

            Pass{
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                    //-------------------add----------------------
				    float3 vpos : TEXCOORD3;
				    //-------------------add----------------------
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
            //-------------------add----------------------
			float _MinX;
            float _MaxX;
            float _MinY;
            float _MaxY;
            //-------------------add----------------------

                v2f vert (appdata v)
                {
                    v2f o;
                    //-------------------add----------------------
				    o.vpos = v.vertex.xyz;
				    //-------------------add----------------------
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o,o.vertex);
                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                    // apply fog
                    UNITY_APPLY_FOG(i.fogCoord, col);
                     col.a *= (i.vpos.x >= _MinX );
	           	     col.a *= (i.vpos.x <= _MaxX );
	                 col.a *= (i.vpos.y >= _MinY);
	                 col.a *= (i.vpos.y <= _MaxY);
                     col.rgb *= col.a;
                    return col;
                }
                ENDCG
            }

            Pass {
                SetTexture [_MainTex] {
                    combine texture * primary
                }
            }
        }
    }

}
