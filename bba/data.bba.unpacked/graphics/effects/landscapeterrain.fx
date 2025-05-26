
// Defines...

#define LIGHT_SCALE 0.45


// Consts...

const float LightScale = LIGHT_SCALE;
const float LightScaleTimes2 = 2 * LIGHT_SCALE;


// Parameters set by the application...

shared float4 g_LightAmbient : LIGHT_AMBIENT;
shared float4 g_LightDiffuse0 : LIGHT_DIRECT_DIFFUSE_0;
shared float4 g_LightDirection0 : LIGHT_DIRECT_DIR_0;

shared float4x4 g_MatView : View;
shared float4x4 g_MatProjection : Projection;

texture g_TexSnow : Diffuse0;
shared float g_SnowStatus;


// Vertex declarations...

struct SVertexInput
{
	float4 m_Position  : POSITION;
	float4 m_Normal    : NORMAL;
    float4 m_Color     : COLOR;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
};

struct SVertexOutput
{
    float4 m_Position  : POSITION;
    float4 m_Color     : COLOR;
    float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
    float  m_Fog       : FOG;
};

struct SVertexOutputSnow
{
    float4 m_Position  : POSITION;
    float4 m_Color     : COLOR;
    float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
	float2 m_TexCoord2 : TEXCOORD2;
    float  m_Fog       : FOG;
};

/*
sampler SnowSampler = sampler_state
{
    Texture = <g_TexSnow>;
	AddressU = WRAP;
	AddressV = WRAP;
    MipFilter = NONE;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};
*/

// VertexShaderTerrain(Snow)...

SVertexOutput VertexShaderTerrain(SVertexInput _In)
{
    SVertexOutput Out;
    
    float4 ViewPosition = mul(_In.m_Position, g_MatView);
    
	Out.m_Position = mul(ViewPosition, g_MatProjection);
    Out.m_Color = _In.m_Color * LightScaleTimes2 * (g_LightAmbient + g_LightDiffuse0 * max(0, dot(_In.m_Normal, -g_LightDirection0)));
	Out.m_TexCoord0 = _In.m_TexCoord0;
	Out.m_TexCoord1 = _In.m_TexCoord1;
    Out.m_Fog = length((float3)ViewPosition);
    
    return Out;
}

SVertexOutputSnow VertexShaderTerrainSnow(SVertexInput _In)
{
    SVertexOutputSnow Out;
    
    float4 ViewPosition = mul(_In.m_Position, g_MatView);
    
	Out.m_Position = mul(ViewPosition, g_MatProjection);
	
	Out.m_Color = _In.m_Color * LightScaleTimes2 * (g_LightAmbient + g_LightDiffuse0 * max(0, dot(_In.m_Normal, -g_LightDirection0)));
	
	Out.m_TexCoord0 = _In.m_TexCoord0;
	Out.m_TexCoord1 = _In.m_TexCoord0;
	Out.m_TexCoord2 = _In.m_TexCoord1;
    Out.m_Fog = length((float3)ViewPosition);
    
    return Out;
}

/*
float4 PixelShaderTerrainSnow(SVertexOutputSnow _In) : COLOR
{

	float4 Snow = tex2D(SnowSampler, _In.m_TexCoord1);
	
	if (Snow.a != 1.0f)
		return lerp(_In.m_Color, float4(0.5, 0.5, 0.5, 1.0), g_SnowStatus);
	
	return _In.m_Color;
}
*/


// Techniques...

technique Default < string Option = "-NoPixelShader"; >
{
    // Passes must match ETerrainEffectPasses...

	pass Common
	{
		AlphaRef = 0x00;
		AlphaFunc = GREATER;

		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
	
		Sampler[0] = sampler_state
		{
		    Texture = NULL;
			AddressU = WRAP;
			AddressV = WRAP;
		    MipFilter = LINEAR;
		    MinFilter = LINEAR;
		    MagFilter = LINEAR;
		};
		
		Sampler[1] = sampler_state
		{
		    Texture = NULL;
			AddressU = WRAP;
			AddressV = WRAP;
		    MipFilter = LINEAR;
		    MinFilter = LINEAR;
		    MagFilter = LINEAR;
		};
		 
        VertexShader = NULL;
        PixelShader = NULL;
	}
	
	pass BaseLayer
	{
		VertexShader = compile vs_1_1 VertexShaderTerrain();
		
		AlphaTestEnable = false;
		AlphaBlendEnable = false;
		
        ColorOp[0]   = MODULATE2X;
        ColorArg1[0] = DIFFUSE;
        ColorArg2[0] = TEXTURE;

        AlphaOp[0]   = MODULATE;
        AlphaArg1[0] = DIFFUSE;
        AlphaArg2[0] = TEXTURE;

        ColorOp[1]   = DISABLE;
        AlphaOp[1]   = DISABLE;
    }

	pass TransitionsCommon
	{
		AlphaTestEnable = true;
		AlphaBlendEnable = true;

        ColorOp[0]   = MODULATE2X;
        ColorArg1[0] = DIFFUSE;
        ColorArg2[0] = TEXTURE;

        AlphaOp[0]   = SELECTARG1;
        AlphaArg1[0] = DIFFUSE;
        AlphaArg2[0] = TEXTURE;
        
        ColorOp[1]   = SELECTARG1;
        ColorArg1[1] = CURRENT;
        ColorArg2[1] = TEXTURE;
        
        AlphaOp[1]   = SELECTARG2;
        AlphaArg1[1] = CURRENT;
        AlphaArg2[1] = TEXTURE;
	
        ColorOp[2]   = DISABLE;
        AlphaOp[2]   = DISABLE;
	}

	pass TransitionsAlphaOnly
	{
        ColorOp[1]   = SELECTARG1;
	}
	
	pass TransitionsColorModulate
	{
        ColorOp[1]   = MODULATE;
	}
	
	pass CommonSnow
	{
		Sampler[2] = sampler_state
		{
		    Texture = NULL;
			AddressU = WRAP;
			AddressV = WRAP;
		    MipFilter = LINEAR;
		    MinFilter = LINEAR;
		    MagFilter = LINEAR;
		};
	}

	pass BaseLayerSnow
	{
		VertexShader = compile vs_1_1 VertexShaderTerrainSnow();

		AlphaTestEnable = false;
		AlphaBlendEnable = false;
		
        ColorOp[0]   = SELECTARG2;
        ColorArg1[0] = DIFFUSE;
        ColorArg2[0] = TEXTURE;

        AlphaOp[0]   = MODULATE;
        AlphaArg1[0] = TFACTOR;
        AlphaArg2[0] = TEXTURE;
        
        ColorOp[1]   = BLENDCURRENTALPHA;
        ColorArg1[1] = CURRENT;
        ColorArg2[1] = TEXTURE;
        
        AlphaOp[2]   = SELECTARG1;
        AlphaArg1[2] = CURRENT;
        AlphaArg2[2] = CURRENT;
        
        ColorOp[2]   = MODULATE2X;
        ColorArg1[2] = CURRENT;
        ColorArg2[2] = DIFFUSE;

        AlphaOp[2]   = SELECTARG2;
        AlphaArg1[2] = CURRENT;
        AlphaArg2[2] = DIFFUSE;
        
        ColorOp[3]   = DISABLE;
        AlphaOp[3]   = DISABLE;
		
		TexCoordIndex[1] = 0;
		TexCoordIndex[2] = 1;					 
	}
	
	pass TransitionsCommonSnow
	{
		AlphaTestEnable = true;
		AlphaBlendEnable = true;
		
        ColorOp[0]   = SELECTARG2;
        ColorArg1[0] = DIFFUSE;
        ColorArg2[0] = TEXTURE;

        AlphaOp[0]   = MODULATE;
        AlphaArg1[0] = TFACTOR;
        AlphaArg2[0] = TEXTURE;
        
        ColorOp[1]   = BLENDCURRENTALPHA;
        ColorArg1[1] = CURRENT;
        ColorArg2[1] = TEXTURE;
        
        AlphaOp[1]   = SELECTARG2;
        AlphaArg1[1] = CURRENT;
        AlphaArg2[1] = TEXTURE;
	
        ColorOp[2]   = MODULATE2X;
        ColorArg1[2] = CURRENT;
        ColorArg2[2] = TEXTURE;
        
        AlphaOp[2]   = SELECTARG2;
        AlphaArg1[2] = CURRENT;
        AlphaArg2[2] = TEXTURE;
        
        ColorOp[3]   = MODULATE2X;
        ColorArg1[3] = CURRENT;
        ColorArg2[3] = DIFFUSE;

        AlphaOp[3]   = SELECTARG1;
        AlphaArg1[3] = CURRENT;
        AlphaArg2[3] = DIFFUSE;
        
        ColorOp[4]   = DISABLE;
        AlphaOp[4]   = DISABLE;
		
		TexCoordIndex[1] = 0;
        TexCoordIndex[2] = 1;					 
							 
	}

	pass TransitionsAlphaOnlySnow
	{
        ColorOp[2]   = SELECTARG1;
	}
	
	pass TransitionsColorModulateSnow
	{
        ColorOp[2]   = MODULATE;
	}
}