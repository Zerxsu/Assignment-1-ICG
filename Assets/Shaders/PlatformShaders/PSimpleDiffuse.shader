Shader "Custom/PSimpleDiffuse"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0)
        _NormalMap("Normal Map", 2D) = "bump" {} // Normal map texture
        _BumpStrength("Bump Strength", Range(0.0, 1.0)) = 1.0 // Strength of the bump mapping
    }
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User defined variables
            uniform float4 _Color;
            uniform float4 _LightColor0;
            uniform sampler2D _NormalMap; // Normal map texture
            uniform float _BumpStrength; // Strength of the bump mapping

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
                float3 normalDir: TEXCOORD0; // Pass normal direction for fragment shader
                float2 uv: TEXCOORD1; // UV coordinates for normal mapping
            };

            // Vertex functions
            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // Transform normal to world space
                float3 normalDirection = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.normalDir = normalDirection; // Pass the normal direction to the fragment shader

                // Calculate UV coordinates (assuming the vertex has UVs)
                o.uv = v.vertex.xy * 0.1; // Adjust scaling based on your UV mapping

                return o;
            }

            // Fragment functions
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample normal map and convert from [0,1] to [-1,1]
                float3 normalMapSample = tex2D(_NormalMap, i.uv).rgb;
                normalMapSample = normalMapSample * 2.0 - 1.0; // Convert to [-1,1]

                // Apply bump strength
                float3 normalDirection = normalize(i.normalDir + normalMapSample * _BumpStrength);

                // Light calculations
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float atten = 1.0;

                // Calculate diffuse reflection
                float3 diffuseReflection = atten * _LightColor0.xyz * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));
                
                // Set output color
                float4 finalColor = float4(diffuseReflection, 1.0);
                return finalColor;
            }

            ENDCG
        }
    }
}
