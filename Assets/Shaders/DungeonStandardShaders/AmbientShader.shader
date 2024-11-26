Shader "Custom/StandardTextureShader"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0) // Base color
        _MainTex("Albedo Texture", 2D) = "white" {} // Albedo texture
        _MetallicTex("Metallic Texture", 2D) = "white" {} // Metallic texture
        _HeightTex("Height Texture", 2D) = "white" {} // Height texture
        _NormalTex("Normal Map", 2D) = "bump" {} // Normal map
        _Smoothness("Smoothness", Range(0, 1)) = 0.5 // Smoothness slider
        _HeightScale("Height Scale", Range(0, 1)) = 0.1 // Height scale

        // Emission properties
        _EmissionEnabled("Enable Emission", Float) = 0 // 0 = off, 1 = on
        _EmissionColor("Emission Color", Color) = (0, 0, 0, 1) // Default emission color

        // Outline properties
        _OutlineColor("Outline Color", Color) = (0.0, 0.0, 0.0, 1.0) // Outline color
        _OutlineThickness("Outline Thickness", Range(0.01, 0.1)) = 0.02 // Outline thickness
        _OutlineEnabled("Enable Outline", Float) = 1 // 0 = off, 1 = on
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        // Main Pass
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            // User-defined variables
            uniform float4 _Color;
            uniform sampler2D _MainTex;
            uniform sampler2D _MetallicTex;
            uniform sampler2D _HeightTex;
            uniform sampler2D _NormalTex;
            uniform float _Smoothness;
            uniform float _HeightScale;

            uniform float _EmissionEnabled;
            uniform float4 _EmissionColor;

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct vertexOutput 
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.uv = v.uv;
                return o;
            }

            float4 frag(vertexOutput i) : SV_Target
            {
                float4 albedoSample = tex2D(_MainTex, i.uv) * _Color;
                float metallic = tex2D(_MetallicTex, i.uv).r;
                float height = tex2D(_HeightTex, i.uv).r * _HeightScale;
                float3 normalSample = tex2D(_NormalTex, i.uv).rgb;
                normalSample = normalize(normalSample * 2.0 - 1.0);

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0;

                float3 diffuseReflection = atten * albedoSample.rgb * max(0.0, dot(normalSample, lightDirection));
                float3 emission = _EmissionEnabled > 0 ? _EmissionColor.rgb : float3(0, 0, 0);
                float3 finalColor = diffuseReflection * metallic + albedoSample.rgb * (1.0 - metallic) + emission;

                return float4(finalColor, albedoSample.a);
            }

            ENDCG
        }

        // Outline Pass
        Pass
        {
            Tags { "LightMode" = "Always" }
            Cull Front
            ZWrite On
            ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vertOutline
            #pragma fragment fragOutline

            uniform float _OutlineThickness;
            uniform float4 _OutlineColor;
            uniform float _OutlineEnabled;

            struct vertexInput 
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
            };

            vertexOutput vertOutline(vertexInput v)
            {
                vertexOutput o;
                if (_OutlineEnabled > 0)
                {
                    float3 offset = normalize(mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz) * _OutlineThickness;
                    v.vertex.xyz += offset;
                }
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 fragOutline(vertexOutput i) : SV_Target
            {
                return _OutlineEnabled > 0 ? _OutlineColor : float4(0, 0, 0, 0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}