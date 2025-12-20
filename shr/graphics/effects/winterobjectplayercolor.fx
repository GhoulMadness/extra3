
// Includes...

#include "Common.fx"


// Effect properties...

const int    EffectProperty_Priority        = 10;
const bool   EffectProperty_OcclusionCaster = true;
const string EffectProperty_ShadowEffect    = "ShadowSimpleObject";


// Parameters set by the application...


shared float4x4 g_MatViewProjection : ViewProjection;

shared float g_SnowStatus;

texture g_TexDiffuse : Diffuse0;
texture g_TexSnow : Diffuse1;

float4x4 g_MatWorld : World : register(c0);
shared float4x4 g_MatWorldView : WorldView : register(c4);
shared float4x4 g_MatProjection : Projection;

shared float4 g_LightAmbient : LIGHT_AMBIENT;
shared float4 g_LightDiffuse0 : LIGHT_DIRECT_DIFFUSE_0;
shared float4 g_LightDirection0 : LIGHT_DIRECT_DIR_0;

float4   g_PlayerColor            : PlayerColor;


// Vertex declarations...

struct SVertexInput
{
	float4 m_Position  : POSITION;
	float4 m_Normal    : NORMAL;
	float2 m_TexCoord0 : TEXCOORD0;
};

struct SVertexOutput
{
    float4 m_Position  : POSITION;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
	float4 m_Color     : COLOR;
    float  m_Fog       : FOG;
};


// Samplers...

sampler DiffuseSampler = sampler_state
{
    Texture = <g_TexDiffuse>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

sampler SnowSampler = sampler_state
{
    Texture = <g_TexSnow>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = NONE;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

// Vertex shaders...

SVertexOutput VertexShaderSnow(SVertexInput _In)
{
	SVertexOutput _rOut;

    float4 ViewPosition = mul(_In.m_Position, g_MatWorldView);
    float3 WorldNormal = normalize(mul(_In.m_Normal, (float3x3) g_MatWorld));	
	float4 Diffuse = tex2D(DiffuseSampler, _In.m_TexCoord0);
    float4 Snow = tex2D(SnowSampler, _In.m_TexCoord0);

	_rOut.m_Position = mul(ViewPosition, g_MatProjection);
	_rOut.m_TexCoord0 = _In.m_TexCoord0;
	_rOut.m_TexCoord1 = _In.m_TexCoord0;
    _rOut.m_Color = g_LightAmbient + g_LightDiffuse0 * max(dot(WorldNormal, -g_LightDirection0), 0);

    _rOut.m_Fog = length((float3) ViewPosition);

	return _rOut;
}

// Pixel shaders...

float4 PixelShaderSnow(SVertexOutput _In) : COLOR
{
    float4 Diffuse = tex2D(DiffuseSampler, _In.m_TexCoord0);
    float4 Snow = tex2D(SnowSampler, _In.m_TexCoord1);

	if (Diffuse.a != 1.0f)
		return float4((float3) _In.m_Color * lerp((float3) g_PlayerColor, (float3) Diffuse, Diffuse.a), 1);
	else
		return float4((float3) _In.m_Color * lerp((float3) Diffuse, (float3) Snow, Snow.a * g_SnowStatus), Diffuse.a);

}

// Techniques...


technique PixelShader
{

	pass Default
	{

		VertexShader = compile vs_1_1 VertexShaderSnow();
		PixelShader = compile ps_2_0 PixelShaderSnow();

	}

}