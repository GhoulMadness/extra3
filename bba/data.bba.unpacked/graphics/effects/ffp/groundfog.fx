
// Effect properties...

const int EffectProperty_Priority = 250;


// Parameters set by the application...

texture g_TexDiffuse0 : Diffuse0 = NULL;
texture g_TexDiffuse1 : Diffuse1 = NULL;

float4 g_MaterialDiffuseAmbient : MaterialDiffuseAmbient;


// Techniques...

technique Default
{
    pass Default
    {
		DiffuseMaterialSource = COLOR1;
		AmbientMaterialSource = COLOR1;
		SpecularMaterialSource = COLOR1;
		
        ColorVertex = true;

        sampler[0] = sampler_state 
        {
            Texture = (g_TexDiffuse1); 
        	AddressU = WRAP;
        	AddressV = WRAP;
            MipFilter = LINEAR;
            MinFilter = LINEAR;
            MagFilter = LINEAR;
        };
        
        TextureFactor = (0x7F000000 * g_MaterialDiffuseAmbient.a);
        
        Texture[1] = NULL;
        
        ColorOp[0]   = SELECTARG2;
        ColorArg1[0] = DIFFUSE;
        ColorArg2[0] = TEXTURE;

        AlphaOp[0]   = MODULATE;
        AlphaArg1[0] = DIFFUSE;
        AlphaArg2[0] = TEXTURE;
        
        ColorOp[1]   = SELECTARG1;
        ColorArg1[1] = CURRENT;
        ColorArg2[1] = TFACTOR;
        
        AlphaOp[1]   = MODULATE;
        AlphaArg1[1] = CURRENT;
        AlphaArg2[1] = TFACTOR;
		
        ColorOp[2]   = DISABLE;
        AlphaOp[2]   = DISABLE;
	}
}
