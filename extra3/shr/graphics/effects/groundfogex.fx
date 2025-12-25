
// Parameters set by the application...

float4 g_MaterialDiffuseAmbient : MaterialDiffuseAmbient;

texture  g_TexDiffuse0 : Diffuse0 = NULL;
texture  g_TexDiffuse1 : Diffuse1 = NULL;
float4x4 g_TexTrans0 : TextureTransform0;

shared float g_TimeReal : Time;
shared float4x4 g_MatView : View;
shared float4x4 g_MatProjection : Projection;
float4x4 g_MatWorld : World : register(c0);


// Vertex declarations...

struct SVertexInput
{
	float4 m_Position     : POSITION;
	float2 m_TexCoord0    : TEXCOORD0;
	float2 m_TexCoord1    : TEXCOORD1;
};

struct SVertexOutput
{
	float4 m_Position  : POSITION;
    float4 m_Color0    : COLOR0;
	float2 m_TexCoord0 : TEXCOORD0;
	float2 m_TexCoord1 : TEXCOORD1;
};


// Vertex shaders...

SVertexOutput VertexShaderFog(SVertexInput _In)
{
	SVertexOutput Out;
	float4 pos = _In.m_Position;
	
	
	pos.x += MOVEMENT_FACTOR * sin( g_TimeReal * MOVEMENT_SPEED + (_In.m_Position.z + _In.m_Position.y) / WAVELENGTH + (g_MatWorld._41 * 0.56f + g_MatWorld._42 * 0.34f + g_MatWorld._43 * 0.43f) );
	pos.y += MOVEMENT_FACTOR * sin( g_TimeReal * MOVEMENT_SPEED + (_In.m_Position.x + _In.m_Position.z) / WAVELENGTH + (g_MatWorld._41 * 0.26f + g_MatWorld._42 * 0.24f + g_MatWorld._43 * 0.33f) );

	float4 WorldPosition = mul(pos, g_MatWorld);
	
	float4 ViewPosition = mul(WorldPosition, g_MatView);
	
	Out.m_Position = mul(ViewPosition, g_MatProjection);
    Out.m_Color0 = g_MaterialDiffuseAmbient;
  
	Out.m_TexCoord0 = mul(float3(_In.m_TexCoord0, 1), (float3x2) g_TexTrans0);
	Out.m_TexCoord1 = mul(float3(_In.m_TexCoord0.yx, 1), (float3x2) g_TexTrans0);
	
	Out.m_TexCoord0.x += g_MatWorld._41 * 0.56f + g_MatWorld._42 * 0.34f + g_MatWorld._43 * 0.43f;
	Out.m_TexCoord1.x += g_MatWorld._41 * 0.35f + g_MatWorld._42 * 0.73f + g_MatWorld._43 * 0.64f;

  return Out;
}


// Sampler...

sampler Diffuse0Sampler = sampler_state 
{
	Texture = <g_TexDiffuse0>;
	AddressU = WRAP;
	AddressV = WRAP;
	MipFilter = LINEAR;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
};

sampler Diffuse1Sampler = sampler_state 
{
	Texture = <g_TexDiffuse1>;
	AddressU = WRAP;
	AddressV = WRAP;
	MipFilter = LINEAR;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
};


// Pixel shaders...

float4 PixelShaderFog(SVertexOutput _In) : COLOR
{
	float4 Diffuse0 = tex2D(Diffuse0Sampler, _In.m_TexCoord0);
	float4 Diffuse1 = tex2D(Diffuse1Sampler, _In.m_TexCoord1);
	
	return Diffuse0 * Diffuse1 * _In.m_Color0;
}


// Techniques...

technique Default
{
   pass Default
   {
      VertexShader = compile vs_1_1 VertexShaderFog();
      PixelShader = compile ps_1_1 PixelShaderFog();
   }
}
