
// Includes...

#include "Skinning.fx"
#include "Common.fx"


// Effect properties...

const string EffectProperty_ShadowEffect = "ShadowSkinnedObject";
const bool   EffectProperty_IsUnit       = true;


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
	float2 m_TexCoord0 : TEXCOORD0;
};


// VertexShaderSkinnedUnit

SVertexOutput VertexShaderSkinnedUnit(SVertexInput _In)
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
	
    float3 WorldNormal = normalize(mul(Normal, (float3x3) g_MatWorld));
    
	Out.m_Position = mul(float4(Position, 1), g_MatWorldViewProjection);
    Out.m_Color0 = g_MaterialDiffuseAmbient * (g_LightAmbient + g_LightDiffuse0 * max(0, dot(WorldNormal, -g_LightDirection0)));
    Out.m_TexCoord0 = _In.m_TexCoord0;
    
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


// PixelShaderPlayerColor...

float4 PixelShaderPlayerColor(SVertexOutput _In) : COLOR
{
    float4 Diffuse = tex2D(DiffuseSampler, _In.m_TexCoord0);
    
    return float4((float3) _In.m_Color0 * lerp((float3) g_PlayerColor, (float3) Diffuse, Diffuse.a), 1);
}


// Techniques...

technique Default
{
   pass Default
   {
      VertexShader = compile vs_1_1 VertexShaderSkinnedUnit();
      PixelShader = compile ps_1_1 PixelShaderSimple();
   }
}


// Old stuff...

/*

FFP version...

technique Default
{
	pass Default
	{
        TexCoordIndex[0] = 0;
        TexCoordIndex[1] = 1;
	
        ColorOp[0]   = BLENDTEXTUREALPHA;
        ColorArg1[0] = TEXTURE;
        ColorArg2[0] = TFACTOR;

        AlphaOp[0]   = SELECTARG1;
        AlphaArg1[0] = TEXTURE;
        AlphaArg2[0] = DIFFUSE;

        ColorOp[1]   = MODULATE;
        ColorArg1[1] = CURRENT;
        ColorArg2[1] = DIFFUSE;
        
        AlphaOp[1]   = SELECTARG1;
        AlphaArg1[1] = DIFFUSE;
        AlphaArg2[1] = TEXTURE;
        
        ColorOp[2]   = DISABLE;
        AlphaOp[2]   = DISABLE;
	}
}

*/
