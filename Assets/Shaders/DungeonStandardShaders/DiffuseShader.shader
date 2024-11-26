Shader "Custom/DiffuseShader"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0) // Base color
        _MainTex("Albedo Texture", 2D) = "white" {} // Albedo texture
        _MetallicTex("Metallic Texture", 2D) = "white" {} // Metallic texture
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _HeightTex("Height Texture", 2D) = "white" {} // Height texture
        _NormalTex("Normal Map", 2D) = "bump" {} // Normal map
        _HeightScale("Height Scale", Range(0, 1)) = 0.1 // Height scale slider

        // Emission properties
        _EmissionEnabled("Enable Emission", Float) = 0 // 0 = off, 1 = on
        _EmissionColor("Emission Color", Color) = (0, 0, 0, 1) // Default emission color
    }

    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc" // Include Unity's built-in shader functions

            #pragma vertex vert
            #pragma fragment frag

            // User-defined variables
            float4 _Color; // Base color
            sampler2D _MainTex; // Albedo texture
            sampler2D _MetallicTex; // Metallic texture
            sampler2D _HeightTex; // Height texture
            sampler2D _NormalTex; // Normal map
            float _Smoothness; // Smoothness factor
            float _HeightScale; // Height scale factor

            // Emission variables
            float _EmissionEnabled; // Enable emission (0 = off, 1 = on)
            float4 _EmissionColor; // Emission color

            // Light variables
            float4 _LightColor0; // First light color

            // Vertex input structure
            struct vertexInput
            {
                float4 vertex : POSITION; // Vertex position
                float3 normal : NORMAL; // Vertex normal
                float2 uv : TEXCOORD0; // UV coordinates
            };

            // Vertex output structure
            struct vertexOutput
            {
                float4 pos : SV_POSITION; // Clip space position
                float3 normalDir : TEXCOORD1; // Normal direction
                float2 uv : TEXCOORD2; // UV coordinates
            };

            // Vertex shader
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex); // Convert vertex position to clip space
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz); // Transform normal to world space
                o.uv = v.uv; // Use the provided UV coordinates
                return o;
            }

            // Fragment shader
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample the albedo texture
                float4 albedoSample = tex2D(_MainTex, i.uv) * _Color; // Sample the texture and multiply by the color

                // Sample the metallic texture
                float metallic = tex2D(_MetallicTex, i.uv).r; // Use the red channel for metallic value

                // Sample the height texture
                float height = tex2D(_HeightTex, i.uv).r * _HeightScale; // Use the red channel for height

                // Sample the normal map
                float3 normalSample = tex2D(_NormalTex, i.uv).rgb; // Sample the normal map
                normalSample = normalize(normalSample * 2.0 - 1.0); // Convert from [0,1] to [-1,1]

                // Light calculations
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz); // Light direction
                float atten = 1.0; // Attenuation (can be adjusted)

                // Calculate diffuse reflection
                float3 diffuseReflection = atten * _LightColor0.xyz * albedoSample.rgb * max(0.0, dot(i.normalDir, lightDirection));

                // Combine diffuse reflection with metallic and normal effects (simple model)
                float3 finalColor = diffuseReflection * (1.0 - metallic) + metallic * _LightColor0.rgb; // Simple metallic shading

                // Emission effect
                float3 emission = _EmissionEnabled > 0 ? _EmissionColor.rgb : float3(0, 0, 0);

                // Add emission to the final color
                finalColor += emission;

                return float4(finalColor, albedoSample.a); // Output the final color
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}