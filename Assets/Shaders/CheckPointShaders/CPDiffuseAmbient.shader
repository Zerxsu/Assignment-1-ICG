Shader "Custom/CPDiffuseAmbient"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0)
        _RimColor("Rim Color", Color) = (1.0, 1.0, 1.0)
        _RimPower("Rim Power", Range(1.0, 8.0)) = 4.0

        // Outline properties
        _OutlineColor("Outline Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _OutlineThickness("Outline Thickness", Range(0.01, 0.1)) = 0.02
        _OutlineEnabled("Enable Outline", Float) = 1
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        // Main pass
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User-defined variables
            uniform float4 _Color;
            uniform float4 _LightColor0;
            uniform float4 _RimColor;
            uniform float _RimPower;

            struct vertexInput
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct vertexOutput
            {
                float4 pos: SV_POSITION;
                float4 col: COLOR;
                float3 viewDir: TEXCOORD0;
                float3 normal: TEXCOORD1;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 worldNormal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0;

                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(worldNormal, lightDirection));
                float3 ambientLight = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float3 lightFinal = diffuseReflection + ambientLight;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                o.normal = worldNormal;

                o.col = float4(lightFinal * _Color.rgb, 1.0);
                return o;
            }

            float4 frag(vertexOutput i) : SV_Target
            {
                float rim = 1.0 - saturate(dot(i.viewDir, i.normal));
                rim = pow(rim, _RimPower);

                float3 rimLighting = rim * _RimColor.rgb;
                float3 finalColor = i.col.rgb + rimLighting;

                return float4(finalColor, 1.0);
            }

            ENDCG
        }

        // Outline pass
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
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct vertexOutput
            {
                float4 pos: SV_POSITION;
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
}