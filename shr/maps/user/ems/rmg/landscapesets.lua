RMG.LandscapeSets = {
	
	-- this set will be used as default if data is missing
	-- name of the landscapeset
	Normal = {
		
		-- texture sets ( recomended to be complete )
		Textures = {
			
			-- there are 7 height biomes
			Pike = {
				
				-- the normal texture will be used if no vegetation biome is defined ( must be defined )
				Normal		= { Sets = { RMG.TextureSets.NormalRockDarkSmooth, }, },
				
				-- there are 5 vegetation biomes ( optional )
				Strong		= { Sets = { RMG.TextureSets.NormalRockDarkSmooth, RMG.TextureSets.MiscSnow, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MiscSnow, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.NormalRockDarkSmooth, }, },
				
				-- 2nd param: table weight ( optional )
				Strong		= { Sets = { RMG.TextureSets.NormalRockDarkSmooth, RMG.TextureSets.NormalForestSmooth, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NormalRockDarkSmooth, RMG.TextureSets.NormalForestSmooth, }, Weights = { 2, 1, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.NormalRocky, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NormalRocky, RMG.TextureSets.NormalGrassDarkSmooth, }, },
				Medium		= { Sets = { RMG.TextureSets.NormalRocky, RMG.TextureSets.NormalGrassDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.NormalRocky, RMG.TextureSets.NormalGrassDarkSmooth, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NormalForestSmooth, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.NormalGrassDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NormalGrassBrightSmooth, }, },
				Weak		= { Sets = { RMG.TextureSets.NormalGrassBrightSmooth, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NormalForestSmooth, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.NormalEarthBright, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.NormalEarthAndRocks, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NormalSandBright, }, },
				Weak		= { Sets = { RMG.TextureSets.NormalEarthBright, }, },
				Medium		= { Sets = { RMG.TextureSets.NormalEarthDark, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.NormalEarthAndRocks, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NormalEarthBright, }, },
				Weak		= { Sets = { RMG.TextureSets.NormalEarthDark, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.NormalSeabedSmooth, }, },
			},
		},
		
		-- there is one water type for the whole map ( optional )
		Water = WaterTypes.WaterA,
		
		-- entitiy sets ( optional )
		Entities = {
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.NormalForestFir, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.NormalForestFir, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.NormalRocky, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.NormalRocky, RMG.EntitySets.NormalGrassDark, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.NormalForestFir, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NormalForestMixed, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.NormalGrassBright, }, },
				Weak		= { Sets = { RMG.EntitySets.NormalGrassDark, RMG.EntitySets.NormalGrassBright, }, },
				Medium		= { Sets = { RMG.EntitySets.NormalGrassDark, }, },
				Strong		= { Sets = { RMG.EntitySets.NormalForestMixed, RMG.EntitySets.NormalGrassDark, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NormalForestMixed, RMG.EntitySets.NormalGrassDark, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.NormalRocky, }, },
				Weak		= { Sets = { RMG.EntitySets.NormalEarthBright, }, },
				Medium		= { Sets = { RMG.EntitySets.NormalEarthDark, RMG.EntitySets.MiscReedBush, }, },
				Strong		= { Sets = { RMG.EntitySets.NormalForestBirchAndWillow, RMG.EntitySets.MiscReedBush, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NormalForestBirchAndWillow, RMG.EntitySets.MiscReedBush, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.EntitySets.NormalRockDark, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
				VeryWeak	= { Sets = { RMG.EntitySets.NormalRockDark, }, Density = 6, },
				Strong		= { Sets = { RMG.EntitySets.NormalRockDark, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 2 }, Density = 2, },
				VeryStrong	= { Sets = { RMG.EntitySets.NormalRockDark, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 4 }, Density = 1, },
			},
		},
		
		-- vertex color sets ( optional )
		--VertexColors = {
		--	Sea	= RMG.VertexColorSets.MiscNormal,
		--},
	},
	
	Evelance = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceRockDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.EvelanceRockDarkSmooth, RMG.TextureSets.MiscSnow, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MiscSnow, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceRockDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.EvelanceRockDarkSmooth, RMG.TextureSets.EvelanceForestSmooth, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.EvelanceRockDarkSmooth, RMG.TextureSets.EvelanceForestSmooth, }, Weights = { 2, 1, }, },
			},
			Hill = {
				VeryWeak	= { Sets = { RMG.TextureSets.EvelanceEarthRocky, }, },
				Weak		= { Sets = { RMG.TextureSets.EvelanceEarthRocky, }, },
				Medium		= { Sets = { RMG.TextureSets.EvelanceGrassErosive, }, },
				Strong		= { Sets = { RMG.TextureSets.EvelanceForestSmooth,  }, },
				VeryStrong	= { Sets = { RMG.TextureSets.EvelanceForestSmooth, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceGrassErosive, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.EvelanceEarthDry, }, },
				Weak		= { Sets = { RMG.TextureSets.EvelanceEarthDry, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.EvelanceForestSmooth, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceEarthBright, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.NormalMudDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.EvelanceEarthBright, }, },
				Weak		= { Sets = { RMG.TextureSets.EvelanceEarthBright, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceEarthDark, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.EvelanceEarthDark, }, },
			},
		},
		Water = WaterTypes.Evelance_Swamp,
		Entities = {
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.EvelanceForestFir, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.EvelanceForestFir, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.EvelanceRocky, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.EvelanceRocky, RMG.EntitySets.EvelanceGrass, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.EvelanceForestFir, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.EvelanceForestFir, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.EvelanceEarth, }, },
				Weak		= { Sets = { RMG.EntitySets.EvelanceEarth, }, },
				Medium		= { Sets = { RMG.EntitySets.EvelanceGrass, }, },
				Strong		= { Sets = { RMG.EntitySets.EvelanceForestDead, RMG.EntitySets.EvelanceGrass, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.EvelanceForestFir, RMG.EntitySets.EvelanceGrass, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.EvelanceEarth, }, },
				Weak		= { Sets = { RMG.EntitySets.EvelanceEarth, }, },
				Medium		= { Sets = { RMG.EntitySets.EvelanceGrass, }, },
				Strong		= { Sets = { RMG.EntitySets.EvelanceForestDeadBright, RMG.EntitySets.MiscReedBush, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.EvelanceForestDeadBright, RMG.EntitySets.MiscReedBush, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.EntitySets.EvelanceRockDarkCliff, }, Density = 4, },
			},
		},
	},
	
	North = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.NorthRockDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.NorthRockDarkSmooth, RMG.TextureSets.MiscSnow, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MiscSnow, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.NorthRockDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.NorthRockDarkSmooth, RMG.TextureSets.NorthForestSmooth, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NorthRockDarkSmooth, RMG.TextureSets.NorthForestSmooth, }, Weights = { 2, 1, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.NorthForestSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MiscPebbles, }, },
				Weak		= { Sets = { RMG.TextureSets.NormalRocky, }, },
				Medium		= { Sets = { RMG.TextureSets.NormalRocky, RMG.TextureSets.NorthGrassDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.NorthGrassDarkSmooth,  }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NorthForestSmooth, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.NorthGrassDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NorthGrassBrightSmooth, }, },
				Weak		= { Sets = { RMG.TextureSets.NorthGrassYellowSmooth, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NorthForestSmooth, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.NorthSand, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.NorthEarthBright, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.NorthSand, }, },
				Strong		= { Sets = { RMG.TextureSets.NorthEarthDark, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.NorthEarthDark, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.NorthEarthDark, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.NorthSeabedSmooth, }, },
			},
		},
		Water = WaterTypes.Nordic_Swamp,
		Entities = {
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.NorthForestPine, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.NorthForestPine, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.NorthRockDark, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.NorthRockDark, RMG.EntitySets.NorthGrass, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.NorthForestPine, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NorthForestFir, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.NorthGrass, }, },
				Weak		= { Sets = { RMG.EntitySets.NorthGrassYellow, }, },
				Medium		= { Sets = { RMG.EntitySets.NorthGrass, }, },
				Strong		= { Sets = { RMG.EntitySets.NorthForestFir, RMG.EntitySets.NorthForestBirch, RMG.EntitySets.NorthGrass, }, Weights = { 1, 1, 4, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NorthForestFir, RMG.EntitySets.NorthGrass, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.NorthSand, }, },
				Weak		= { Sets = { RMG.EntitySets.NorthEarthBright, }, },
				Medium		= { Sets = { RMG.EntitySets.NorthEarthDark, }, },
				Strong		= { Sets = { RMG.EntitySets.NorthForestDead, RMG.EntitySets.MiscReedBush, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.NorthForestBirch, RMG.EntitySets.MiscReedBush, }, },
			},
		},
	},
	
	Mediterran = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.MediRockDark, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.MediRockDark, }, },
				Strong		= { Sets = { RMG.TextureSets.MediRockDark, RMG.TextureSets.MediForest, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MediRockDark, RMG.TextureSets.MediForest, }, Weights = { 2, 1, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.MediRockBright, }, },
				Medium		= { Sets = { RMG.TextureSets.MediRockBright, RMG.TextureSets.MediForest, }, },
				Strong		= { Sets = { RMG.TextureSets.MediForest, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MediForest, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.MediForest, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MediGrassSandy, }, },
				Weak		= { Sets = { RMG.TextureSets.MediGrassYellow, }, },
				Medium		= { Sets = { RMG.TextureSets.MediGrassBright, RMG.TextureSets.MediForest, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.NormalEarthBright, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.MediForest, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MediSand, }, },
				Weak		= { Sets = { RMG.TextureSets.MediSand, }, },
				Strong		= { Sets = { RMG.TextureSets.MediForest, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MediForest, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.NormalEarthBright, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MediSand, }, },
				Weak		= { Sets = { RMG.TextureSets.MediSand, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.MediSand, }, },
			},
		},
		Water = WaterTypes.Mediterran_Lake,
		Entities = {
			Pike = {
				VeryWeak	= { Sets = { RMG.EntitySets.MediRockBrightCliff, }, Density = 5, },
				Weak		= { Sets = { RMG.EntitySets.MediRockBrightCliff, }, Density = 5, },
			},
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.MediForestOlive, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediForestPine, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.MediRockyBright, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.MediRockyBright, RMG.EntitySets.MediGrassDark, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.MediForestOlive, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediForestPine, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.MediGrassBright, }, },
				Weak		= { Sets = { RMG.EntitySets.MediGrassBright, }, },
				Medium		= { Sets = { RMG.EntitySets.MediGrassBright, RMG.EntitySets.MediGrassDark, }, },
				Strong		= { Sets = { RMG.EntitySets.MediForestFruit, RMG.EntitySets.MediGrassDark, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediForestFruit, RMG.EntitySets.MediGrassDark, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.MediSand, }, },
				Weak		= { Sets = { RMG.EntitySets.MediSand, }, },
				Medium		= { Sets = { RMG.EntitySets.NormalEarthBright, RMG.EntitySets.MiscReedBush, }, },
				Strong		= { Sets = { RMG.EntitySets.MediForestCypress, RMG.EntitySets.MediGrassDark, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediForestCypress, RMG.EntitySets.MediGrassDark, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.EntitySets.MediRockBright, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 2 }, Density = 2, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 4 }, Density = 1, },
			},
		},
	},
	
	Moor = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.MoorRockDark, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.MoorRockDark, }, },
				Strong		= { Sets = { RMG.TextureSets.MoorRockDark, RMG.TextureSets.MoorGrassDark, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MoorRockDark, RMG.TextureSets.MoorGrassDark, }, Weights = { 2, 1, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.MoorRocky, }, },
				Medium		= { Sets = { RMG.TextureSets.MoorRocky, RMG.TextureSets.MoorGrassDark, }, },
				Strong		= { Sets = { RMG.TextureSets.MoorGrassDark, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MoorGrassDark, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.MoorGrassDark, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MoorEarth, }, },
				Weak		= { Sets = { RMG.TextureSets.MoorEarth, }, },
				Medium		= { Sets = { RMG.TextureSets.MoorGrassBright, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.MoorEarth, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.MoorGrassDark, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.MoorEarth, }, },
				Weak		= { Sets = { RMG.TextureSets.MoorEarth, }, },
				Medium		= { Sets = { RMG.TextureSets.MoorGrassBright, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.MoorEarth, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.MoorEarth, }, },
			},
		},
		Water = WaterTypes.Moor,
		Entities = {
			Pike = {
				VeryWeak	= { Sets = { RMG.EntitySets.MoorRockDarkCliff, }, Density = 5, },
				Weak		= { Sets = { RMG.EntitySets.MoorRockDarkCliff, }, Density = 5, },
			},
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.MoorForestDead, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.MoorForestDead, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.MoorRocky, RMG.EntitySets.MoorFog, }, Weights = { 10, 1, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.MoorRocky, RMG.EntitySets.MediGrassDark, RMG.EntitySets.MoorFog, }, Weights = { 10, 10, 1, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.MoorForestDead, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MoorForest, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.MoorEarth, RMG.EntitySets.MoorFog, }, Weights = { 20, 1, }, },
				Weak		= { Sets = { RMG.EntitySets.MoorEarth, RMG.EntitySets.MoorFog, }, Weights = { 20, 1, }, },
				Medium		= { Sets = { RMG.EntitySets.MoorGrass, RMG.EntitySets.MoorFog, }, Weights = { 20, 1, }, },
				Strong		= { Sets = { RMG.EntitySets.MoorForestDead, RMG.EntitySets.MoorGrass, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MoorForest, RMG.EntitySets.MoorGrass, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.MoorEarth, RMG.EntitySets.MoorFog, }, Weights = { 20, 1, }, },
				Weak		= { Sets = { RMG.EntitySets.MoorEarth, RMG.EntitySets.MoorFog, }, Weights = { 20, 1, }, },
				Medium		= { Sets = { RMG.EntitySets.MoorGrass, RMG.EntitySets.MiscReedBush, RMG.EntitySets.MoorFog, }, Weights = { 10, 10, 1, }, },
				Strong		= { Sets = { RMG.EntitySets.MoorForestBirch, RMG.EntitySets.MiscReedBush, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.MoorForestBirch, RMG.EntitySets.MiscReedBush, }, },
			},
			Lake = {
				Strong		= { Sets = { RMG.EntitySets.MiscWaterLily, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.MiscWaterLily, }, Density = 2, },
			},
		},
	},

	Tideland = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.TidelandRockBright, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.TidelandRockBright, }, },
				Strong		= { Sets = { RMG.TextureSets.TidelandRockBright, RMG.TextureSets.TidelandGrassDarkSmooth, }, Weights = { 2, 1, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.TidelandRockBright, RMG.TextureSets.TidelandGrassDarkSmooth, }, Weights = { 2, 1, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.TidelandSandDark, }, },
				Medium		= { Sets = { RMG.TextureSets.TidelandSandDark, RMG.TextureSets.TidelandGrassDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.TidelandGrassDarkSmooth, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.TidelandGrassDarkSmooth, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.TidelandGrassDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.TidelandGrassBrightSmooth, }, },
				Weak		= { Sets = { RMG.TextureSets.TidelandGrassBrightSmooth, }, },
				Medium		= { Sets = { RMG.TextureSets.TidelandGrassBrightSmooth, RMG.TextureSets.TidelandGrassDarkSmooth, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.TidelandSand, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.TidelandSand, }, },
				Medium		= { Sets = { RMG.TextureSets.TidelandMud, }, },
				Strong		= { Sets = { RMG.TextureSets.TidelandMudDark, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.TidelandMudDark, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.TidelandSand, }, },
				Medium		= { Sets = { RMG.TextureSets.TidelandMud, }, },
				Strong		= { Sets = { RMG.TextureSets.TidelandMudDark, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.TidelandMudDark, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.NormalSeabedSmooth, }, },
			},
		},
		Water = WaterTypes.WaterC,
		Entities = {
			Pike = {
				Strong		= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, },
			},
			Mountain = {
				Strong		= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.TidelandRocky, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.TidelandRocky, RMG.EntitySets.NormalGrassDark, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandForestDarkTree, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.TidelandGrassBright, }, },
				Weak		= { Sets = { RMG.EntitySets.TidelandGrassBright, }, },
				Medium		= { Sets = { RMG.EntitySets.TidelandGrassFlowers, }, },
				Strong		= { Sets = { RMG.EntitySets.TidelandForestBirch, RMG.EntitySets.TidelandGrassDark, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandForestDarkTree, RMG.EntitySets.TidelandGrassDark, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.TidelandSand, }, },
				Weak		= { Sets = { RMG.EntitySets.TidelandSand, }, },
				Medium		= { Sets = { RMG.EntitySets.TidelandMud, RMG.EntitySets.TidelandSand, }, },
				Strong		= { Sets = { RMG.EntitySets.TidelandMud, RMG.EntitySets.MiscReedFlat, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandMud, RMG.EntitySets.MiscReedFlat, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.EntitySets.TidelandRockBright, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.TidelandRockBright, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.TidelandRockBright, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 2 }, Density = 2, },
				VeryStrong	= { Sets = { RMG.EntitySets.TidelandRockBright, RMG.EntitySets.MiscWaterPlants, RMG.EntitySets.MiscWaterLily, }, Weights = { [3] = 4 }, Density = 1, },
			},
			Sea = {
				Normal		= { Sets = { RMG.EntitySets.TidelandCliff, }, Density = 16, },
			},
		},
	},
	
	Steppe = {
		Textures = {
			Pike = {
				Normal		= { Sets = { RMG.TextureSets.SteppeRockDarkSmooth, }, },
				Strong		= { Sets = { RMG.TextureSets.SteppeRockDarkSmooth, RMG.TextureSets.MiscSnow, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.MiscSnow, }, },
			},
			Mountain = {
				Normal		= { Sets = { RMG.TextureSets.SteppeRockDarkSmooth, }, },
			},
			Hill = {
				Normal		= { Sets = { RMG.TextureSets.SteppeEarthDry, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.SteppeRocky, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.SteppeGrassDarkSmooth, }, },
			},
			Normal = {
				Normal		= { Sets = { RMG.TextureSets.SteppeGrassDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.SteppeEarthBright, }, },
				Weak		= { Sets = { RMG.TextureSets.SteppeGrassBrightSmooth, }, },
				Medium		= { Sets = { RMG.TextureSets.SteppeGrassBrightSmooth, RMG.TextureSets.SteppeGrassDarkSmooth, }, },
			},
			Road = {
				Normal		= { Sets = { RMG.TextureSets.SteppeRocky, }, },
			},
			Coast = {
				Normal		= { Sets = { RMG.TextureSets.SteppeRocky, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.SteppeEarthBright, }, },
				Strong		= { Sets = { RMG.TextureSets.SteppeGrassDarkSmooth, }, },
				VeryStrong	= { Sets = { RMG.TextureSets.SteppeGrassDarkSmooth, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.TextureSets.SteppeGrassDarkSmooth, }, },
				VeryWeak	= { Sets = { RMG.TextureSets.SteppeRocky, }, },
				Weak		= { Sets = { RMG.TextureSets.SteppeRocky, }, },
				Medium		= { Sets = { RMG.TextureSets.SteppeGrassBrightSmooth, }, },
			},
			Sea = {
				Normal		= { Sets = { RMG.TextureSets.SteppeRocky, }, },
			},
		},
		Water = WaterTypes.WaterB,
		Entities = {
			Hill = {
				Normal		= { Sets = { RMG.EntitySets.MediRockyDark, }, Density = 6, },
				VeryWeak	= { Sets = { RMG.EntitySets.MediRockyBright, RMG.EntitySets.SteppeRocky, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.SteppeForestDead, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.SteppeForestPine, }, },
			},
			Normal = {
				VeryWeak	= { Sets = { RMG.EntitySets.SteppeEarthBright, }, },
				Weak		= { Sets = { RMG.EntitySets.SteppeGrassBright, }, },
				Medium		= { Sets = { RMG.EntitySets.SteppeGrassBright, RMG.EntitySets.SteppeGrassDark, }, },
				Strong		= { Sets = { RMG.EntitySets.SteppeForestPine, RMG.EntitySets.SteppeGrassDark, }, Weights = { 1, 2, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.SteppeForestPine, RMG.EntitySets.SteppeGrassDark, }, Weights = { 2, 1, }, },
			},
			Coast = {
				VeryWeak	= { Sets = { RMG.EntitySets.SteppeEarthBright, }, },
				Weak		= { Sets = { RMG.EntitySets.SteppeRocky, }, },
				Medium		= { Sets = { RMG.EntitySets.SteppeRocky, }, },
				Strong		= { Sets = { RMG.EntitySets.SteppeForestPine, RMG.EntitySets.SteppeGrassDark, }, },
				VeryStrong	= { Sets = { RMG.EntitySets.SteppeForestPine, RMG.EntitySets.SteppeGrassDark, }, },
			},
			Lake = {
				Normal		= { Sets = { RMG.EntitySets.MediRockBright, }, Density = 6, },
				Medium		= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
				Strong		= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
				VeryStrong	= { Sets = { RMG.EntitySets.MediRockDark, RMG.EntitySets.MiscWaterPlants, }, Density = 4, },
			},
		},
	},
}