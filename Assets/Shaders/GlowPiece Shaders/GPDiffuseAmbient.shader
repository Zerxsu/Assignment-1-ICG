Shader "Custom/GPDiffuseAmbient"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0)
        _NormalMap("Normal Map", 2D) = "bump" {}
        _EmissionColor("Emission Color", Color) = (0, 0, 0)
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

            uniform float4 _Color;
            uniform float4 _LightColor0;
            uniform sampler2D _NormalMap;
            uniform float4 _EmissionColor;
            uniform float _EmissionIntensity;

            struct vertexInput 
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float2 uv: TEXCOORD0;
            };

            struct vertexOutput 
            {
                float4 pos: SV_POSITION;
                float4 col: COLOR;
                float3 normal: TEXCOORD1;
                float2 uv: TEXCOORD0;
            };

            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;
                float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.normal = normalDirection;
                o.uv = v.uv;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample normal map and adjust normal direction
                float3 normalMap = tex2D(_NormalMap, i.uv).rgb * 2.0 - 1.0;
                float3 normalDirection = normalize(i.normal + normalMap);

                // Diffuse lighting calculation
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
                float3 ambientLight = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                // Emission calculation
                float3 emissiveGlow = _EmissionColor.rgb * _EmissionIntensity;

                // Combine final color with emission
                float3 lightFinal = (diffuseReflection + ambientLight) * _Color.rgb + emissiveGlow;

                return float4(lightFinal, 1.0);
            }

            ENDCG
        }
    }
}
