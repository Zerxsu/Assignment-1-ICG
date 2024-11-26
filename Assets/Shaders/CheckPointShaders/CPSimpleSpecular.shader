Shader "Custom/CPSimpleSpecular"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
        _RimColor("Rim Color", Color) = (1.0, 1.0, 1.0)
        _RimPower("Rim Power", Range(1.0, 8.0)) = 4.0

        // Outline properties
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness("Outline Thickness", Range(0.01, 0.1)) = 0.02
        _OutlineEnabled("Enable Outline", Float) = 1
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User-defined variables
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform float4 _RimColor;
            uniform float _RimPower;

            // Unity-defined variables
            uniform float4 _LightColor0;

            struct vertexInput
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };

            struct vertexOutput
            {
                float4 pos: SV_POSITION;
                float4 posWorld: TEXCOORD0;
                float3 normalDir: TEXCOORD1;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag(vertexOutput i): COLOR
            {
                float3 normalDirection = normalize(i.normalDir);
                float atten = 1.0;

                // Diffuse lighting
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                // Specular reflection
                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 specularReflection = atten * _SpecColor.rgb * pow(lightSeeDirection, _Shininess);

                // Ambient lighting
                float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

                // Rim lighting
                float rim = 1.0 - saturate(dot(viewDirection, normalDirection));
                rim = pow(rim, _RimPower);
                float3 rimLighting = rim * _RimColor.rgb;

                // Final color
                float3 finalColor = lightFinal * _Color.rgb + rimLighting;

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

            float4 fragOutline(vertexOutput i): SV_Target
            {
                return _OutlineEnabled > 0 ? _OutlineColor : float4(0, 0, 0, 0);
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}