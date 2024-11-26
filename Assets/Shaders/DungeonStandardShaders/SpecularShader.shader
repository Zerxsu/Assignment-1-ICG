Shader "Custom/SPecularTextures"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1) // Base color
        _SpecColor("Spec Color", Color) = (1.0, 1.0, 1.0) // Specular color
        _Shininess("Shininess", Float) = 10 // Shininess factor
        _MainTex("Albedo Texture", 2D) = "white" {} // Albedo texture
        _MetallicTex("Metallic Texture", 2D) = "white" {} // Metallic texture
        _HeightTex("Height Texture", 2D) = "white" {} // Height texture
        _NormalTex("Normal Map", 2D) = "bump" {} // Normal map
        _Smoothness("Smoothness", Range(0, 1)) = 0.5 // Smoothness slider
        _HeightScale("Height Scale", Range(0, 1)) = 0.1 // Height scale slider

        // Emission properties
        _EmissionEnabled("Enable Emission", Float) = 0 // 0 = off, 1 = on
        _EmissionColor("Emission Color", Color) = (0, 0, 0, 1) // Default emission color
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User Defined Variables
            uniform float4 _Color; // Base color
            uniform float4 _SpecColor; // Specular color
            uniform float _Shininess; // Shininess factor
            uniform sampler2D _MainTex; // Albedo texture
            uniform sampler2D _MetallicTex; // Metallic texture
            uniform sampler2D _HeightTex; // Height texture
            uniform sampler2D _NormalTex; // Normal map
            uniform float _Smoothness; // Smoothness
            uniform float _HeightScale; // Height scale

            // Emission Variables
            uniform float _EmissionEnabled; // Enable emission (0 = off, 1 = on)
            uniform float4 _EmissionColor; // Emission color

            // Unity Defined Variables
            uniform float4 _LightColor0; // Light color

            // Structs
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0; // Use the provided UV coordinates
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD1; // World position
                float3 normalDir : TEXCOORD2; // Normal direction
                float2 uv : TEXCOORD3; // UV coordinates
            };

            // Vertex Functions
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.pos = UnityObjectToClipPos(v.vertex);

                // Use the provided UV coordinates directly
                o.uv = v.uv;

                return o;
            }

            // Fragment Function
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample the albedo texture
                float4 albedoSample = tex2D(_MainTex, i.uv) * _Color; // Combine texture color with base color

                // Sample the metallic texture
                float metallic = tex2D(_MetallicTex, i.uv).r; // Use the red channel for metallic value

                // Sample the height texture
                float height = tex2D(_HeightTex, i.uv).r * _HeightScale; // Use the red channel for height

                // Sample the normal map
                float3 normalSample = tex2D(_NormalTex, i.uv).rgb; // Sample the normal map
                normalSample = normalize(normalSample * 2.0 - 1.0); // Convert from [0,1] to [-1,1]

                // Lighting calculations
                float atten = 1.0; // You can add attenuation calculations if needed
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(i.normalDir, lightDirection));

                // Specular calculations
                float3 lightReflectDirection = reflect(-lightDirection, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);

                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
                float3 lightFinal = diffuseReflection + specularReflection; // Combine diffuse and specular

                // Emission effect
                float3 emission = _EmissionEnabled > 0 ? _EmissionColor.rgb : float3(0, 0, 0);

                // Final color output
                return float4(lightFinal * albedoSample.rgb + emission, albedoSample.a); // Combine the final color with the texture alpha and emission
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}