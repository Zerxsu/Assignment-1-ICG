Shader "Custom/WaterShader"
{
    Properties
    {
        _Color("Water Color", Color) = (0.0, 0.5, 1.0, 1.0)
        _WaveSpeed("Wave Speed", Float) = 1.0
        _WaveAmplitude("Wave Amplitude", Float) = 0.1
        _WaveFrequency("Wave Frequency", Float) = 1.0
        _NormalMap("Normal Map", 2D) = "bump" {}
        _NormalStrength("Normal Strength", Float) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            Cull Off
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Properties
            float4 _Color;
            float _WaveSpeed;
            float _WaveAmplitude;
            float _WaveFrequency;
            sampler2D _NormalMap;
            float _NormalStrength;

            // Structs
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };

            // Vertex Shader
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                float time = _Time.y * _WaveSpeed;

                // Calculate wave displacement
                float wave = sin(v.vertex.x * _WaveFrequency + time) + cos(v.vertex.z * _WaveFrequency + time);
                wave *= _WaveAmplitude;

                // Apply wave to vertex position
                float3 displacedPosition = float3(v.vertex.x, v.vertex.y + wave, v.vertex.z);

                // Transform position to clip space
                o.pos = UnityObjectToClipPos(float4(displacedPosition, 1.0));
                o.uv = v.uv;

                // Calculate world position and normal
                o.worldPos = mul(unity_ObjectToWorld, float4(displacedPosition, 1.0)).xyz;
                o.worldNormal = normalize(mul(float4(v.normal, 0.0), unity_ObjectToWorld).xyz);

                return o;
            }

            // Fragment Shader
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample normal map
                float3 normalTex = UnpackNormal(tex2D(_NormalMap, i.uv)) * _NormalStrength;

                // Combine with vertex normal
                float3 normal = normalize(i.worldNormal + normalTex);

                // Basic lighting
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuse = saturate(dot(normal, lightDir)) * _Color.rgb;

                // Return final color
                return float4(diffuse, _Color.a);
            }

            ENDCG
        }
    }
}
