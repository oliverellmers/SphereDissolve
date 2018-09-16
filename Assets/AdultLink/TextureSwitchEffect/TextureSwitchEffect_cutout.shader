// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdultLink/TextureSwitchEffect_cutout"
{
	Properties
	{
		[NoScaleOffset]_Set1_albedo("Set1_albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_Set1_normal("Set1_normal", 2D) = "white" {}
		[NoScaleOffset]_Set1_emission("Set1_emission", 2D) = "black" {}
		_Falloffvalue("Falloff value", Float) = 0.08
		_Radius("Radius", Float) = 2.16
		_Bordernoisescale("Border noise scale", Range( 0 , 20)) = 0
		_Borderradius("Border radius", Range( 0 , 2)) = 0
		[HDR]_Bordercolor("Border color", Color) = (0.8602941,0.2087478,0.2087478,0)
		_Noisespeed("Noise speed", Vector) = (0,0,0,0)
		[HDR]_Set1_emissionColor("Set1_emissionColor", Color) = (1,1,1,1)
		_Set1_tiling("Set1_tiling", Vector) = (0,0,0,0)
		_Set1_offset("Set1_offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Set1_normal;
		uniform float2 _Set1_tiling;
		uniform float2 _Set1_offset;
		uniform float3 _Position;
		uniform float _Radius;
		uniform float _Bordernoisescale;
		uniform float3 _Noisespeed;
		uniform float _Falloffvalue;
		uniform sampler2D _Set1_albedo;
		uniform float4 _Set1_emissionColor;
		uniform sampler2D _Set1_emission;
		uniform float4 _Bordercolor;
		uniform float _Borderradius;
		uniform float _Cutoff = 0.5;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord90 = i.uv_texcoord * _Set1_tiling + _Set1_offset;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = distance( _Position , ase_worldPos );
			float simplePerlin3D26 = snoise( ( _Bordernoisescale * ( ase_worldPos + ( _Noisespeed * _Time.y ) ) ) );
			float temp_output_39_0 = ( _Radius + simplePerlin3D26 );
			float temp_output_5_0 = step( ( 1.0 - saturate( ( temp_output_15_0 / temp_output_39_0 ) ) ) , _Falloffvalue );
			float Set1Mask51 = temp_output_5_0;
			o.Normal = ( tex2D( _Set1_normal, uv_TexCoord90 ) * Set1Mask51 ).rgb;
			o.Albedo = ( tex2D( _Set1_albedo, uv_TexCoord90 ) * Set1Mask51 ).rgb;
			float Border49 = ( temp_output_5_0 - step( ( 1.0 - saturate( ( temp_output_15_0 / ( _Borderradius + temp_output_39_0 ) ) ) ) , _Falloffvalue ) );
			o.Emission = ( ( _Set1_emissionColor * tex2D( _Set1_emission, uv_TexCoord90 ) * Set1Mask51 ) + ( _Bordercolor * Border49 ) ).rgb;
			o.Alpha = 1;
			float temp_output_78_0 = Set1Mask51;
			clip( temp_output_78_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15301
771;92;728;500;-1025.218;-233.3784;1;True;False
Node;AmplifyShaderEditor.Vector3Node;41;-2521.422,422.9358;Float;False;Property;_Noisespeed;Noise speed;10;0;Create;True;0;0;False;0;0,0,0;0,0.2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;42;-2514.172,582.2572;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-2258.387,276.4377;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2315.857,450.455;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-2004.914,353.5768;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2211.601,177.9753;Float;False;Property;_Bordernoisescale;Border noise scale;7;0;Create;True;0;0;False;0;0;0.8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1858.591,330.9357;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1581.167,180.0159;Float;False;Property;_Radius;Radius;6;0;Create;True;0;0;False;0;2.16;5.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-1614.839,325.7608;Float;False;Simplex3D;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1372.697,238.9016;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-1774.278,-2.898107;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;19;-1225.662,31.59209;Float;False;Property;_Borderradius;Border radius;8;0;Create;True;0;0;False;0;0;0.27;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;10;-1725.007,-198.3264;Float;False;Global;_Position;_Position;4;0;Create;True;0;0;False;0;0,2.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-932.5296,43.48309;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;15;-1511.926,17.7578;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-1094.045,226.1726;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-1166.897,-202.5804;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-1006.065,-213.8931;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-979.2128,227.8599;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-844.9251,228.1008;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-792.2949,-76.98935;Float;False;Property;_Falloffvalue;Falloff value;5;0;Create;True;0;0;False;0;0.08;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-805.776,-212.6522;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;248.3361,173.864;Float;False;Property;_Set1_tiling;Set1_tiling;12;0;Create;True;0;0;False;0;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;92;247.036,310.3633;Float;False;Property;_Set1_offset;Set1_offset;13;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;5;-574.1523,25.52099;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-574.3254,-210.5628;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;442.0364,205.0634;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-314.7035,-233.816;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;876.0349,653.056;Float;False;49;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-341.2661,43.12219;Float;False;Set1Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-171.7947,-238.9316;Float;False;Border;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;857.3165,471.6254;Float;False;Property;_Bordercolor;Border color;9;1;[HDR];Create;True;0;0;False;0;0.8602941,0.2087478,0.2087478,0;2.323001,0.3844966,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;839.2489,-28.19606;Float;False;Property;_Set1_emissionColor;Set1_emissionColor;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;891.1077,354.3461;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;821.8247,152.777;Float;True;Property;_Set1_emission;Set1_emission;4;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;802.6385,-681.5815;Float;True;Property;_Set1_albedo;Set1_albedo;0;1;[NoScaleOffset];Create;True;0;0;False;0;None;312c93ed564bd8840ab4818e3db14d8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;819.2783,-334.6191;Float;True;Property;_Set1_normal;Set1_normal;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;c208f128e624c474bb2241affee1c866;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1125.598,554.1989;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;924.3142,-132.6616;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;1180.158,159.1718;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;907.6737,-479.6245;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;1415.181,336.2189;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;1137.295,-546.2795;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;850.0312,819.5994;Float;True;Property;_Set1_metallic;Set1_metallic;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;65;955.0667,1021.558;Float;False;51;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1184.688,954.9017;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1153.934,-199.3167;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1595.024,289.5317;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;AdultLink/TextureSwitchEffect_cutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;41;0
WireConnection;89;1;42;0
WireConnection;40;0;27;0
WireConnection;40;1;89;0
WireConnection;28;0;29;0
WireConnection;28;1;40;0
WireConnection;26;0;28;0
WireConnection;39;0;13;0
WireConnection;39;1;26;0
WireConnection;18;0;19;0
WireConnection;18;1;39;0
WireConnection;15;0;10;0
WireConnection;15;1;16;0
WireConnection;12;0;15;0
WireConnection;12;1;39;0
WireConnection;31;0;15;0
WireConnection;31;1;18;0
WireConnection;32;0;31;0
WireConnection;11;0;12;0
WireConnection;14;0;11;0
WireConnection;33;0;32;0
WireConnection;5;0;14;0
WireConnection;5;1;3;0
WireConnection;23;0;33;0
WireConnection;23;1;3;0
WireConnection;90;0;91;0
WireConnection;90;1;92;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;51;0;5;0
WireConnection;49;0;24;0
WireConnection;80;1;90;0
WireConnection;1;1;90;0
WireConnection;61;1;90;0
WireConnection;35;0;34;0
WireConnection;35;1;50;0
WireConnection;83;0;87;0
WireConnection;83;1;80;0
WireConnection;83;2;78;0
WireConnection;84;0;83;0
WireConnection;84;1;35;0
WireConnection;8;0;1;0
WireConnection;8;1;53;0
WireConnection;62;1;90;0
WireConnection;66;0;62;0
WireConnection;66;1;65;0
WireConnection;56;0;61;0
WireConnection;56;1;59;0
WireConnection;0;0;8;0
WireConnection;0;1;56;0
WireConnection;0;2;84;0
WireConnection;0;10;78;0
ASEEND*/
//CHKSM=2BE125A30DB102B889671B1DA3D34ADA75B474FC