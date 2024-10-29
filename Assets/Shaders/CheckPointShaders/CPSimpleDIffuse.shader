Shader "Custom/CPSimpleDIffuse"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0)
        _RimColor("Rim Color", Color) = (1.0, 1.0, 1.0)
        _RimPower("Rim Power", Range(1.0, 8.0)) = 4.0
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
            uniform float4 _LightColor0;
            uniform float4 _RimColor;
            uniform float _RimPower;

            // Base input structs
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

            // Vertex function
            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // Transform the normal to world space
                float3 worldNormal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0;

                // Calculate diffuse reflection
                float3 diffuseReflection = atten * _LightColor0.xyz * _Color.rgb * max(0.0, dot(worldNormal, lightDirection));
                o.col = float4(diffuseReflection, 1.0);

                // Calculate view direction manually
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                o.normal = worldNormal;

                return o;
            }

            // Fragment function
            float4 frag(vertexOutput i) : SV_Target
            {
                // Calculate rim lighting based on the angle between view direction and normal
                float rim = 1.0 - saturate(dot(i.viewDir, i.normal));
                rim = pow(rim, _RimPower);

                // Combine rim lighting with diffuse color
                float3 rimLighting = rim * _RimColor.rgb;
                float3 finalColor = i.col.rgb + rimLighting;

                return float4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}