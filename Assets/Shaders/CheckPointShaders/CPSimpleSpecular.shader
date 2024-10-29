Shader "Custom/CPSimpleSpecular"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1.0, 1.0, 1.0)
        _Shininess("Shininess", Float) = 10
        _RimColor("Rim Color", Color) = (1.0, 1.0, 1.0)
        _RimPower("Rim Power", Range(1.0, 8.0)) = 4.0
    }

    SubShader
    {
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

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
                float3 normalDir : TEXCOORD1;
            };

            // Vertex function
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // Fragment function
            float4 frag(vertexOutput i) : COLOR
            {
                //Normalize the normal direction and calculate the lighting
                float3 normalDirection = normalize(i.normalDir);
                float atten = 1.0;

                //Lighting
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));

                //Specular reflection
                float3 lightReflectDirection = reflect(-lightDirection, normalDirection);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 specularReflection = atten * _SpecColor.rgb * pow(lightSeeDirection, _Shininess);

                //Ambient lighting
                float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT;

                //Rim lighting
                float rim = 1.0 - saturate(dot(viewDirection, normalDirection));
                rim = pow(rim, _RimPower);
                float3 rimLighting = rim * _RimColor.rgb;

                //Lighting components combined
                float3 finalColor = lightFinal * _Color.rgb + rimLighting;

                return float4(finalColor, 1.0);
            }

            ENDCG
        } 
    }    
    FallBack "Diffuse"
}