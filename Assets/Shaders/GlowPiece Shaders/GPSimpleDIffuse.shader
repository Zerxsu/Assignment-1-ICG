Shader "Custom/GPSimpleDiffuse"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0)
        _NormalMap("Normal Map", 2D) = "bump" {}
        _EmissionColor("Emission Color", Color) = (0, 0, 0)
        
        // Added this line for emission intensity
        _EmissionIntensity("Emission Intensity", Range(0, 5)) = 1.0
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

            // Added this line for emission intensity
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
                float3 normal: NORMAL;
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
                float3 normalMap = tex2D(_NormalMap, i.uv).rgb * 2.0 - 1.0;
                normalMap = normalize(normalMap);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightIntensity = max(0.0, dot(i.normal, lightDirection)) * _LightColor0.rgb * _Color.rgb;
                
                float4 emissiveGlow = _EmissionColor * _EmissionIntensity; // Modified line to use emission intensity
                float4 finalColor = float4(lightIntensity, 1.0) + emissiveGlow;
                return finalColor;
            }

            ENDCG
        }
    }
}