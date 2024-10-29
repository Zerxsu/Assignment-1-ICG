Shader "Custom/PSimpleSpecular"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _SpecColor("Spec Color", Color) = (1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
        _NormalMap("Normal Map", 2D) = "bump" {} // Normal map texture
        _BumpStrength("Bump Strength", Range(0.0, 1.0)) = 1.0 // Strength of the bump mapping
    }

    SubShader
    {
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User Defined Variables
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform sampler2D _NormalMap; // Normal map texture
            uniform float _BumpStrength; // Strength of the bump mapping

            // Unity Defined Variables
            uniform float4 _LightColor0;

            // Structs
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
                float2 uv : TEXCOORD2; // UV coordinates for normal mapping
            };

            // Vertex Functions
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.vertex.xy * 0.1; // Adjust UV scaling based on your UV mapping
                return o;
            }

            // Fragment Function
            float4 frag(vertexOutput i) : COLOR
            {
                // Sample the normal map
                float3 normalMapSample = tex2D(_NormalMap, i.uv).rgb;
                normalMapSample = normalMapSample * 2.0 - 1.0; // Convert from [0,1] to [-1,1]

                // Apply bump strength
                float3 normalDirection = normalize(i.normalDir + normalMapSample * _BumpStrength);

                // Lighting calculations
                float atten = 1.0;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                // Specular calculations
                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);

                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
                float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

                return float4(lightFinal * _Color.rgb, 1.0);
            }

            ENDCG
        }
    }    
    FallBack "Diffuse"
}
