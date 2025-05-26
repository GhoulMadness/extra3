
// Includes...

#include "Skinning.fx"


// Effect properties...

const bool   EffectProperty_OcclusionReceiver    = true;
const int    EffectProperty_Priority             = 20;
const bool   EffectProperty_RenderAlphaZOnlyPass = true;
const bool   EffectProperty_RenderReflection     = true;
const string EffectProperty_ShadowEffect         = "ShadowSkinnedObject";
const bool   EffectProperty_IsUnit               = true;


// Consts...

static const float4 SpecularColor = { 2, 2, 2, 1 }; // Alpha must be 1
static const float SpecularReflectionPower = 64;


// Parameters set by the application...

shared float4x4 g_MatView : View;
shared float4x4 g_MatProjection : Projection;

float4x4 g_MatWorld : World;
float4x4 g_MatWorldView : WorldView;
float4x4 g_MatWorldViewProjection : WorldViewProjection;

float4 g_MaterialDiffuseAmbient : MaterialDiffuseAmbient;

shared float4 g_LightAmbient : LIGHT_AMBIENT;
shared float4 g_LightDiffuse0 : LIGHT_DIRECT_DIFFUSE_0;
shared float4 g_LightDirection0 : LIGHT_DIRECT_DIR_0;

texture g_TexDiffuse  : Diffuse0 = NULL;
texture g_TexSpecular : Diffuse1 = NULL;

float4 g_PlayerColor : PlayerColor;


// Vertex declarations...

struct SVertexInput
{
	float4 m_Position     : POSITION;
	float3 m_Normal       : NORMAL;
	float4 m_BlendIndices : BLENDINDICES;
	float2 m_BlendWeights : BLENDWEIGHT;
	float2 m_TexCoord0    : TEXCOORD0;
};

struct SVertexOutput
{
    float4 m_Position  : POSITION;
    float4 m_Color0    : COLOR0;
    float4 m_Color1    : COLOR1;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
};


// VertexShaderSkinnedUnitWithSpecular

SVertexOutput VertexShaderSkinnedUnitWithSpecular(SVertexInput _In)
{
	SVertexOutput Out;

	int4 Indices = D3DCOLORtoUBYTE4(_In.m_BlendIndices);
	float2 Weights = _In.m_BlendWeights;

	float3 Position = { 0, 0, 0 };
	float3 Normal = { 0, 0, 0 };

	for (int i = 0; i < 2; i++)
	{
		int Index = Indices[i];

		float3x4 BoneTranformation = float3x4(g_Bones[Index], g_Bones[Index+1], g_Bones[Index+2]);

		Position += Weights[i] * mul(BoneTranformation, _In.m_Position);
		Normal += Weights[i] * mul((float3x3) BoneTranformation, _In.m_Normal);
	}

    float4 ViewPosition = mul(float4(Position, 1), g_MatWorldView);
    float3 ViewNormal = normalize(mul(Normal, (float3x3) g_MatWorldView));
    float3 ViewLightDir = mul(g_LightDirection0, (float3x3) g_MatView);
    float3 ViewHalf = normalize(float3(0, 0, 1) + ViewLightDir);

    // Does not work with the shadow code
	// Out.m_Position = mul(ViewPosition, g_MatProjection);

	Out.m_Position = mul(float4(Position, 1), g_MatWorldViewProjection);
    Out.m_Color0 = g_MaterialDiffuseAmbient * (g_LightAmbient + g_LightDiffuse0 * max(0, dot(ViewNormal, -ViewLightDir)));
    Out.m_Color1 = float4((float3) SpecularColor * pow(max(0, dot(ViewNormal, -ViewHalf)), SpecularReflectionPower), 0);
    Out.m_TexCoord0 = _In.m_TexCoord0;
    Out.m_TexCoord1 = _In.m_TexCoord0;

	return Out;
}


// Sampler...

sampler DiffuseSampler = sampler_state
{
    Texture = <g_TexDiffuse>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

sampler SpecularSampler = sampler_state
{
    Texture = <g_TexSpecular>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};


// PixelShaderPlayerColorSpecular...

float4 PixelShaderPlayerColorSpecular(SVertexOutput _In) : COLOR
{
    float4 Diffuse = tex2D(DiffuseSampler, _In.m_TexCoord0);
    float4 Specular = tex2D(SpecularSampler, _In.m_TexCoord1);

    //return _In.m_Color0 * lerp(g_PlayerColor, Diffuse, Diffuse.a) + _In.m_Color1 * Specular;
	if (Diffuse.a != 1.0f)
		return float4((float3) _In.m_Color0 * lerp((float3) g_PlayerColor, (float3) Diffuse, Diffuse.a) + _In.m_Color1 * Specular, lerp(0, g_PlayerColor.a, Diffuse.a));
	else
		return float4((float3) _In.m_Color0 * lerp((float3) _In.m_Color1.r, (float3) Diffuse, Diffuse.a), lerp(g_PlayerColor.r, g_PlayerColor.g, g_PlayerColor.b));
}


// Techniques...

technique Default
{
    pass Default
    {
        VertexShader = compile vs_1_1 VertexShaderSkinnedUnitWithSpecular();
        PixelShader = compile ps_2_0 PixelShaderPlayerColorSpecular();

        StencilRef = 0;
        StencilFunc = ALWAYS;
        StencilFail = KEEP;
        StencilPass = REPLACE;
        StencilZFail = INCR;
        StencilWriteMask = 0xFFFFFFFF;
        StencilMask = 0xFFFFFFFF;
    }
}
