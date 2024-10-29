Shader "Custom/GPSimpleSpecular"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
        _NormalMap("Normal Map", 2D) = "bump" {}
        _EmissionColor("Emission Color", Color) = (0, 0, 0, 1)
        _EmissionIntensity("Emission Intensity", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User-defined variables
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform sampler2D _NormalMap;
            uniform float4 _EmissionColor;
            uniform float _EmissionIntensity;

            // Unity-defined variables
            uniform float4 _LightColor0;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float3 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float2 uv : TEXCOORD0;
            };

            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.uv = v.uv;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                // Sample the normal map and adjust normal direction
                float3 normalMap = tex2D(_NormalMap, i.uv).rgb * 2.0 - 1.0;
                float3 normalDirection = normalize(i.normalDir + normalMap);

                // Lighting calculations
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = _LightColor0.rgb * max(0.0, dot(normalDirection, lightDirection));

                // Specular calculations
                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);
                float spec = pow(max(0.0, dot(lightReflectDirection, viewDirection)), _Shininess);
                float3 specularReflection = _SpecColor.rgb * spec;

                // Emission calculations
                float3 emissiveGlow = _EmissionColor.rgb * _EmissionIntensity;

                // Ambient light and final color
                float3 ambientLight = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 lightFinal = (diffuseReflection + specularReflection + ambientLight) * _Color.rgb + emissiveGlow;

                return float4(lightFinal, 1.0);
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}
