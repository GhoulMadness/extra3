
// Effect properties...

const int EffectProperty_Priority = 10;
string EffectProperty_ShadowEffect = "ShadowSimpleObject";


// Parameters set by the application...

shared float4x4 g_MatWorldView : WorldView : register(c4);
shared float4x4 g_MatProjection : Projection;

shared float4 g_LightAmbient : LIGHT_AMBIENT;
shared float4 g_LightDiffuse0 : LIGHT_DIRECT_DIFFUSE_0;
shared float4 g_LightDirection0 : LIGHT_DIRECT_DIR_0;

float4   g_MaterialDiffuseAmbient : MaterialDiffuseAmbient;
float4x4 g_MatWorld               : World : register(c0);
texture  g_TexDiffuse0            : Diffuse0;
texture  g_TexDiffuse1            : Diffuse1;


// Vertex declarations...

struct SVertexInput
{
	float4 m_Position  : POSITION;
	float4 m_Normal    : NORMAL;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
};

struct SVertexOutput
{
    float4 m_Position  : POSITION;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
	float4 m_Color0    : COLOR0;
    float  m_Fog       : FOG;
};


// Samplers...

sampler SamplerDiffuse0 = sampler_state 
{
    Texture = <g_TexDiffuse0>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

sampler SamplerDiffuse1 = sampler_state 
{
    Texture = <g_TexDiffuse1>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};


// Vertex shaders...

void VertexShaderDualPass(SVertexInput _In, out SVertexOutput _rOut)
{
    float4 ViewPosition = mul(_In.m_Position, g_MatWorldView);
    float3 WorldNormal = normalize(mul(_In.m_Normal, (float3x3) g_MatWorld));
    
	_rOut.m_Position = mul(ViewPosition, g_MatProjection);
	_rOut.m_TexCoord0 = _In.m_TexCoord0;
	_rOut.m_TexCoord1 = _In.m_TexCoord1;
    _rOut.m_Color0 = g_MaterialDiffuseAmbient * (g_LightAmbient + g_LightDiffuse0 * max(0, dot(WorldNormal, -g_LightDirection0)));
    _rOut.m_Fog = length((float3)ViewPosition);
}


// Pixel shaders...

float4 PixelShaderDualPass(SVertexOutput _In) : COLOR 
{
    float4 Diffuse0 = tex2D(SamplerDiffuse0, _In.m_TexCoord0);
    float4 Diffuse1 = tex2D(SamplerDiffuse1, _In.m_TexCoord1);

    return _In.m_Color0 * float4(lerp((float3)Diffuse0, (float3)Diffuse1, Diffuse1.a), Diffuse0.a);
}


// Techniques...

technique PixelShader
{
    pass Default
    {
        VertexShader = compile vs_1_1 VertexShaderDualPass();
        PixelShader = compile ps_1_1 PixelShaderDualPass();
    }
}
