--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- author:RobbiTheFox,mcb		current maintainer:RobbiTheFox
-- current version: 3.0 ex3
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--
-- supported player-team compositions:
--
-- - ffa with up to 16 players
-- - 4 teams in any composition with up to 8 players
-- - 3 teams in any composition with up to 9 players
-- - 2 teams in any composition with up to 10 players
-- - equal teams up to 16 players (odd numbers above 8 are only supported as ffa)
-- - other compositions can work, depending on the map size
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- TODO:
-- check player config compatibility
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
RMG = {}
s5CommunityLibPathEx3 = "extra3\\shr\\maps\\user\\EMS\\tools\\s5CommunityLib"
RMGPath = "extra3\\shr\\maps\\user\\EMS\\RMG"
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
Script.Load( s5CommunityLibPathEx3 .. "\\comfort\\math\\SimplexNoise.lua" )
Script.Load( s5CommunityLibPathEx3 .. "\\comfort\\math\\astar.lua" )
Script.Load( s5CommunityLibPathEx3 .. "\\tables\\TerrainTypes.lua" )
Script.Load( s5CommunityLibPathEx3 .. "\\tables\\WaterTypes.lua" )
Script.Load( RMGPath .. "\\texturesets.lua" )
Script.Load( RMGPath .. "\\vertexcolorsets.lua" )
Script.Load( RMGPath .. "\\entitysets.lua" )
Script.Load( RMGPath .. "\\landscapesets.lua" )
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- for override purposes
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.Callback_OnGenerationFinished()
	local resTable = RMG.StartResourcesByEnum[GDB.GetValue("Singleplayer\\RandomMapData\\MapStart")]
	for i = 1, 8 do
		Tools.GiveResouces(i, unpack(resTable))
	end
	Logic.SetNumberOfBuyableHerosForPlayer(1, GDB.GetValue("Singleplayer\\RandomMapData\\MapHeroes"))
	IncludeGlobals("tools\\RandomMapAI")
	RandomMapAI.Init(structData)
	--
	LocalMusic.UseSet = RMG.MusicSetByLandscapeSetKey[RMG.GenerationData.LandscapeSetKey]
	local weatherdata = RMG.WeatherSpecsByWeatherEnum[GDB.GetValue("Singleplayer\\RandomMapData\\MapWeather")]
	TagNachtZyklus(unpack(weatherdata))
	--
	RMG = nil
	collectgarbage()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ex3 sp menu21 random map creator custom stuff
function RMG.GetPlayerConfigByGDBData()
	local playert = {{Id = 1, Team = 1, IsHuman = 1}}
	local teams = {1}
	local teamsRegistered = {[1] = true}
	for i = 1, 7 do
		if GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Active") == 2 then
			local team = GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Team")
			table.insert(playert, {Id = i+1, Team = team, IsHuman = 1})
			if not teamsRegistered[team] then
				table.insert(teams, team)
				teamsRegistered[team] = true
			end
		end
	end
	table.sort(playert, function(p1, p2)
		return p1.Team < p2.Team
	end)
	return table.getn(playert), playert, table.getn(teams)
end
-- duration, rainflag, snowflag, bonuscount (rain/snow)
RMG.WeatherSpecsByWeatherEnum = {
	[1] = {12, 1, 1, 6, 1},
	[2] = {18, 1, 1, 3, 1},
	[3] = {24, 1, 1, 0, 1},
	[4] = {24, 1, 1, -3, 0},
	[5] = {32, 0, 0, 0, 1},
	[6] = {32, 1, 0, 12, 1},
	[7] = {32, 0, 1, 12, 1}
}
RMG.MusicSetByLandscapeSetKey = {
	["Normal"] = EUROPEMUSIC,
	["North"] = HIGHLANDMUSIC,
	["Evelance"] = EVELANCEMUSIC,
	["Mediterran"] = MEDITERANEANMUSIC,
	["Moor"] = DARKMOORMUSIC,
	["Tideland"] = HIGHLANDMUSIC,
	["Steppe"] = MEDITERANEANMUSIC,
	["Desert"] = MEDITERANEANMUSIC
}
RMG.StartResourcesByEnum = {
	[1] = {500, 1000, 800, 600, 0, 0},
	[2] = {1000, 1800, 1500, 800, 50, 50},
	[3] = {1500, 2500, 2000, 1200, 200, 200},
	[4] = {3000, 4000, 3200, 2500, 1500, 1000}
}
RMG.ResPitValByTypeAndEnum = {
	["Normal"] = {[1] = 1, [2] = 2, [3] = 2},
	["Combat"] = {[1] = 1, [2] = 1, [3] = 2},
	["Rare"]   = {[1] = 0, [2] = 0, [3] = 1}
}
RMG.ResPitResAmountByTypeAndEnum = {
	["Normal"] = {[1] = 5000, [2] = 15000, [3] = 30000, [4] = 50000, [5] = 100000},
	["Combat"] = {[1] = 3000, [2] = 10000, [3] = 20000, [4] = 30000, [5] = 100000},
	["Rare"]   = {[1] = 300, [2] = 600, [3] = 1000, [4] = 1500, [5] = 3000}
}
RMG.ResPileValByTypeAndEnum = {
	["Normal"] = {[1] = 2, [2] = 3, [3] = 4},
	["Combat"] = {[1] = 1, [2] = 2, [3] = 3},
	["Rare"]   = {[1] = 0, [2] = 0, [3] = 1}
}
RMG.ResPileResAmountByTypeAndEnum = {
	["Normal"] = {[1] = 600, [2] = 1000, [3] = 1500, [4] = 2500, [5] = 4000},
	["Combat"] = {[1] = 400, [2] = 800, [3] = 1200, [4] = 1500, [5] = 3000},
	["Rare"]   = {[1] = 2, [2] = 5, [3] = 10, [4] = 20, [5] = 100}
}
RMG.StructureValByTypeAndEnum = {
	["VillageCenter"] = {[1] = 2, [2] = 3, [3] = 4},
	["VillageHall"]	  = {[1] = 0, [2] = 1, [3] = 2},
	["Lighthouse"]	  = {[1] = 0, [2] = 1, [3] = 1}
}
RMG.LandscapeSetKeys = {
	{id = "Normal",		eval = RMG.SetupLandscapeNormal, representative = "Europa"},
	{id = "North",		eval = RMG.SetupLandscapeNorth, representative = "Skandinavien"},
	{id = "Evelance",	eval = RMG.SetupLandscapeEvelance},
	{id = "Mediterran",	eval = RMG.SetupLandscapeMediterran},
	{id = "Moor",		eval = RMG.SetupLandscapeMoor},
	{id = "Tideland",	eval = RMG.SetupLandscapeTideland, representative = "Küstenland"},
	{id = "Steppe",		eval = RMG.SetupLandscapeSteppe,},
	{id = "Desert"}
}
RMG.MapSettingDefinedStructureSurroundingTexture = {
	["ClayPit"] = {
		["Desert"] = {
			TerrainTypes.EarthRockyDesert03_AT,
			TerrainTypes.EarthRockyDesert04_AT,
		}
	},
	["StonePit"] = {
		["Desert"] = {
			TerrainTypes.SandRockyDesert01_AT,
			TerrainTypes.SandRockyDesert02_AT,
			TerrainTypes.SandRockyDesert03_AT,
		},
		["Mediterran"] = {
			TerrainTypes.RockMedium01B_AT,
		},
		["Steppe"] = {
			TerrainTypes.RockMedium01B_AT,
		}
	},
	["SulfurPit"] = {
		["Desert"] = {
			TerrainTypes.SandEarthDesert01_AT,
			TerrainTypes.SandEarthDesert02_AT,
			TerrainTypes.SandEarthDesert03_AT,
		},
		["Mediterran"] = {
			TerrainTypes.SandMediterrean01_AT,
			TerrainTypes.SandMediterrean02_AT,
			TerrainTypes.SandMediterrean03_AT,
		},
		["Steppe"] = {
			TerrainTypes.SandMediterrean01_AT,
			TerrainTypes.SandMediterrean02_AT,
			TerrainTypes.SandMediterrean03_AT,
		}
	}
}
RMG.MapSettingDefinedStructureEntityType = {
	["StonePit"] = {
		["Desert"] = Entities.XD_StonePit1_Med,
		["Mediterran"] = Entities.XD_StonePit1_Med,
		["Steppe"] = Entities.XD_StonePit1_Med,
	},
	["Stone"] = {
		["Desert"] = Entities.XD_Stone1_Med,
		["Mediterran"] = Entities.XD_Stone1_Med,
		["Steppe"] = Entities.XD_Stone1_Med,
	}
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------
---@param _GenerationData table
function RMG.CustomizeGenerationData(_GenerationData)
	local seed = GDB.GetValue("Singleplayer\\RandomMapData\\MapKey")

	_GenerationData.Seed = seed,
	SimplexNoise.seedP(seed)

	math.randomseed(seed)
	gvRandomseed = true -- prevent GetRandom from reseeding

	_GenerationData.TeamBorderType			= 1
	_GenerationData.GateLayout				= 1
	_GenerationData.GateSize				= 1
	_GenerationData.GenerateRoads 			= true

	_GenerationData.LandscapeSetKey			= RMG.LandscapeSetKeys[GDB.GetValue("Singleplayer\\RandomMapData\\MapSetting")].id
	_GenerationData.MirrorMap				= Num2Bool(GDB.GetValue("Singleplayer\\RandomMapData\\MapMirror") - 1)
	_GenerationData.RandomPlayerPosition	= false

	local EvalMapResourceWealth = GDB.GetValue("Singleplayer\\RandomMapData\\MapResourceWealth")

	_GenerationData.ContentClayPit          = RMG.ResPitResAmountByTypeAndEnum["Normal"][EvalMapResourceWealth]
	_GenerationData.ContentClayPile         = RMG.ResPileResAmountByTypeAndEnum["Normal"][EvalMapResourceWealth]
	_GenerationData.ContentStonePit	        = RMG.ResPitResAmountByTypeAndEnum["Normal"][EvalMapResourceWealth]
	_GenerationData.ContentStonePile	    = RMG.ResPileResAmountByTypeAndEnum["Normal"][EvalMapResourceWealth]
	_GenerationData.ContentIronPit	        = RMG.ResPitResAmountByTypeAndEnum["Combat"][EvalMapResourceWealth]
	_GenerationData.ContentIronPile	        = RMG.ResPileResAmountByTypeAndEnum["Combat"][EvalMapResourceWealth]
	_GenerationData.ContentSulfurPit	    = RMG.ResPitResAmountByTypeAndEnum["Combat"][EvalMapResourceWealth]
	_GenerationData.ContentSulfurPile	    = RMG.ResPileResAmountByTypeAndEnum["Combat"][EvalMapResourceWealth]
	_GenerationData.ContentGoldPit	   		= RMG.ResPitResAmountByTypeAndEnum["Combat"][EvalMapResourceWealth]
	_GenerationData.ContentSilverPit	    = RMG.ResPitResAmountByTypeAndEnum["Rare"][EvalMapResourceWealth]
	_GenerationData.ContentSilverPile	    = RMG.ResPileResAmountByTypeAndEnum["Rare"][EvalMapResourceWealth]
	_GenerationData.ContentWoodPile	        = RMG.ResPitResAmountByTypeAndEnum["Normal"][EvalMapResourceWealth]

	local EvalMapResources = GDB.GetValue("Singleplayer\\RandomMapData\\MapResources")
	local EvalMapVC = GDB.GetValue("Singleplayer\\RandomMapData\\MapVC")

    _GenerationData.AmountClayPit		    = RMG.ResPitValByTypeAndEnum["Normal"][EvalMapResources]
	_GenerationData.AmountClayPile	        = RMG.ResPileValByTypeAndEnum["Normal"][EvalMapResources]
	_GenerationData.AmountStonePit	        = RMG.ResPitValByTypeAndEnum["Normal"][EvalMapResources]
	_GenerationData.AmountStonePile	        = RMG.ResPileValByTypeAndEnum["Normal"][EvalMapResources]
	_GenerationData.AmountIronPit		    = RMG.ResPitValByTypeAndEnum["Combat"][EvalMapResources]
	_GenerationData.AmountIronPile	        = RMG.ResPileValByTypeAndEnum["Combat"][EvalMapResources]
	_GenerationData.AmountSulfurPit	        = RMG.ResPitValByTypeAndEnum["Combat"][EvalMapResources]
	_GenerationData.AmountSulfurPile	    = RMG.ResPileValByTypeAndEnum["Combat"][EvalMapResources]
	_GenerationData.AmountGoldPit	        = RMG.ResPitValByTypeAndEnum["Combat"][EvalMapResources]
	_GenerationData.AmountSilverPit	        = RMG.ResPitValByTypeAndEnum["Rare"][EvalMapResources]
	_GenerationData.AmountSilverPile	    = RMG.ResPileValByTypeAndEnum["Rare"][EvalMapResources]
	_GenerationData.AmountWoodPile	        = 0
	_GenerationData.AmountVillageCenter     = RMG.StructureValByTypeAndEnum["VillageCenter"][EvalMapVC]
	_GenerationData.amountVillageHall		= RMG.StructureValByTypeAndEnum["VillageHall"][EvalMapVC]
	_GenerationData.amountLighthouse		= RMG.StructureValByTypeAndEnum["Lighthouse"][EvalMapVC]

	_GenerationData.ExploreResources        = 0
	_GenerationData.ExploreVCs              = 0

    -- get number of players and number of teams
	local nplayers, players, nteams         = RMG.GetPlayersAndTeams()

	_GenerationData.NumberOfPlayers = nplayers
	_GenerationData.NumberOfTeams = nteams

	for p = 1, nplayers do
		table.insert(_GenerationData.Players, {Id = players[p].Id, Team = players[p].Team, IsHuman = players[p].IsHuman, IsReady = false,})
	end
end
function RMG.CustomizeGenerationData2(_GenerationData)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- override me :)
---@param _PlayerStruct table
function RMG.SetCameraStart(_PlayerStruct)
	Camera.ScrollSetLookAt(_PlayerStruct.X * 100, _PlayerStruct.Y * 100)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.SetupLandscapeNormal()
	SetupNormalWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeNorth()
	SetupHighlandWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeEvelance()
	SetupEvelanceWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeMediterran()
	SetupMediterraneanWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeMoor()
	SetupMoorWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeTideland()
	SetupNormalWeatherGfxSet()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetupLandscapeSteppe()
	SetupSteppeWeatherGfxSet()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
RMG.BlockingTypes = {
	None = 0,
	River = 1,
	Road = 2,
	Mountain = 4,
	Structure = 8,
}
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--[[
Structure = {
 Placement = {
  AbsolutX,
  AbsolutY, -- excl.
  RelativX,
  RelativY, -- excl.
  AreaMax, -- excl.
  = Number
  = {x, y}
  = {x1, y1, x2, y2}
  AreaMin, -- excl.
  = Number
  = {x, y}
  = {x1, y1, x2, y2}
  NoiseMin,
  NoiseMax,
  Asymetric,
  Blocking,
},
 Data = {
  Entities = {
   [1] = {
    Type,     -- type or table of types
    RelativX, -- offset
    RelativY,
    Grid,     -- snap position
    Rotation, -- -1 = random
    Angle,    -- snap rotation
    Scale,
    Ambient,
    Volume,
    Resource, -- amount
    Player,
    Name,
    Health,
    Soldiers, -- amount
  },
 },
  TerrainHeights = {
   [x] = {
    [y] = Number,
  },
   Area, -- excl.
   = Number
   = {x, y}
   = {x1, y1, x2, y2}
 },
  TerrainTextures = {
   [1] = {
    Area,
    -- excl.
    = Number
    = {x, y}
    = {x1, y1, x2, y2},
    TextureList = RMG.TextureSets.Name or TerrainTypes.Name, -- excl.
    BiomeKey = String,
  },
 },
  Water = {
   [1] = {
    Area = {x1, y1, x2, y2},
    Height = Number,
    Type = WaterTypes.Name,
  },
 },
  RemoveEntities, -- excl.
  = Number
  = {x, y}
  = {x1, y1, x2, y2}
},
 Childs = {
  -- more structures
},
}
]]
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.InitGenerationData()

	local generationData = {DebugMode = false}

	Score.Player[0] = {buildings = 0, all = 0}

	-- DBG only --
	if generationData.DebugMode then

		Game.GameTimeSetFactor(10)
		Tools.ExploreArea(-1, -1, 900);
		Camera.ZoomSetFactorMax(10);
		Camera.ZoomSetFactor(2);
		GUI.MiniMap_SetRenderFogOfWar(0);
		Display.SetRenderFogOfWar(0);
		Display.SetRenderFog(0);
		Display.SetRenderShadows(0);
		Display.SetRenderLandscapeFogOfWar(0);
		Display.SetRenderInvisibleObjects(1);

		--for k,v in pairs(Technologies) do ResearchTechnology(v) end
	end
	-- DBG only --

	generationData.TerrainBaseHeight		= 2800
	generationData.WaterBaseHeight			= 2300

	local invertedwaterheight = generationData.TerrainBaseHeight + (generationData.TerrainBaseHeight - generationData.WaterBaseHeight)

	generationData.NoiseFactorZ				= 140 * 14
	generationData.NoiseFactorXY			= 102 / 14705

	generationData.ThresholdPike			= invertedwaterheight + 750
	generationData.ThresholdMountain		= invertedwaterheight + 100
	generationData.ThresholdHill			= invertedwaterheight - 200

	generationData.ThresholdSea				= generationData.WaterBaseHeight - 500
	generationData.ThresholdLake			= generationData.WaterBaseHeight - 100
	generationData.ThresholdCoast			= generationData.WaterBaseHeight + 200

	generationData.ThresholdRoad			= 0
	generationData.ForestDensity			= 1 -- in %

	generationData.ThresholdVeryStrongGroth	= 0.4
	generationData.ThresholdStrongGroth		= 0.2
	generationData.ThresholdWeakGroth		= -0.1
	generationData.ThresholdVeryWeakGroth	= -0.3

	-- Node = {x, y, noise, height, blocking}
	generationData.TerrainNodes = {}
 	generationData.Entities = {}
	generationData.Players = {}

	return generationData
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.InitGenerationData2(_GenerationData)

	-- on default maps
	if not RMG.IsCustomMap then
		-- generate no team border in big ffa
		if _GenerationData.NumberOfPlayers <= _GenerationData.NumberOfTeams and _GenerationData.NumberOfPlayers > 10 then
			_GenerationData.TeamBorderType = 1 -- none
		end

		-- generate no rivers if not enough teams
		if _GenerationData.NumberOfTeams <= 1 then
			_GenerationData.TeamBorderType = 1 -- none
			_GenerationData.MirrorMap = false
		end

		-- generate no roads if not enough players
		if _GenerationData.NumberOfPlayers <= 1 then
			_GenerationData.GenerateRoads = false
			_GenerationData.MirrorMap = false
		end
	end

	-- get composition to allow custom overrides for 12+ players
	_GenerationData.Composition = RMG.GetComposition(_GenerationData)

	_GenerationData.NumberOfSlizes = _GenerationData.Composition.NumberOfPlayers + _GenerationData.Composition.NumberOfTeams --nplayers + ((nteams > 1) and nteams or 0)

	-- no additional slize if no teamborder will be generated
	_GenerationData.MirrorRadian = math.rad(360 / _GenerationData.NumberOfSlizes) -- 180° = pi
	_GenerationData.MirrorOffset = math.rad(45)

	-- no mirror offset if bridges will be generated, they look bettes at 90° angle
	if _GenerationData.TeamBorderType == 3 and _GenerationData.GenerateRoads and not RMG.IsCustomMap then
		_GenerationData.MirrorOffset = 0
	end

	-- depends on number of players and teams
	local sizeX = Logic.WorldGetSize()/100
	--_GenerationData.PlayerDistanceToMiddle = math.max(math.min((_GenerationData.NumberOfPlayers * math.sqrt(_GenerationData.NumberOfTeams)) / (sizeX^2/10000), 1-(50000/sizeX^2)), 0.6) -- in percent
	_GenerationData.PlayerDistanceToMiddle = math.max(math.min(((sizeX^0.3)/9) + (_GenerationData.NumberOfPlayers + _GenerationData.NumberOfTeams)/100, 0.95), 0.65)

	-- build misc structure tables
	local waterheight = _GenerationData.WaterBaseHeight + 200
	local heightmin = waterheight
	local heightmax = _GenerationData.ThresholdMountain

	RMG.StructureSets = {
		ClayPit = {
			Entities = {
				{Type = Entities.XD_ClayPit1, Resource = _GenerationData.ContentClayPit, Name = "ClayPit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 6, Name = "white"},},
			Blocking = 22,
			TerrainHeights = {
				Area = 18,
				[-6]={[-6]=  -3,[-5]=  -14,[-4]=  -24,[-3]=  -32,[-2]=  -34,[-1]=  -33,[0]=  -35,[1]=  -40,[2]=  -43,[3]=  -34,[4]=  -21,[5]=  -9},
				[-5]={[-6]= -13,[-5]=  -29,[-4]=  -47,[-3]=  -62,[-2]=  -72,[-1]=  -76,[0]=  -88,[1]=  -95,[2]=  -90,[3]=  -64,[4]=  -33,[5]= -11},
				[-4]={[-6]= -23,[-5]=  -63,[-4]= -102,[-3]= -135,[-2]= -162,[-1]= -183,[0]= -201,[1]= -204,[2]= -182,[3]= -125,[4]=  -62,[5]= -18},
				[-3]={[-6]= -45,[-5]= -105,[-4]= -180,[-3]= -257,[-2]= -294,[-1]= -377,[0]= -377,[1]= -377,[2]= -292,[3]= -214,[4]=  -90,[5]= -28,[6]=  -1},
				[-2]={[-6]= -59,[-5]= -140,[-4]= -249,[-3]= -346,[-2]= -372,[-1]= -377,[0]= -377,[1]= -377,[2]= -360,[3]= -269,[4]= -105,[5]= -26,[6]=  -6},
				[-1]={[-6]= -58,[-5]= -150,[-4]= -263,[-3]= -355,[-2]= -377,[-1]= -377,[0]= -377,[1]= -377,[2]= -361,[3]= -268,[4]= -125,[5]= -39,[6]=  -9},
				[0]={[-6]= -58,[-5]= -150,[-4]= -266,[-3]= -358,[-2]= -377,[-1]= -377,[0]= -377,[1]= -377,[2]= -363,[3]= -266,[4]= -134,[5]= -46,[6]= -14},
				[1]={[-6]= -58,[-5]= -145,[-4]= -263,[-3]= -360,[-2]= -377,[-1]= -377,[0]= -377,[1]= -377,[2]= -357,[3]= -265,[4]= -140,[5]= -52,[6]= -14},
				[2]={[-6]= -50,[-5]= -130,[-4]= -254,[-3]= -358,[-2]= -377,[-1]= -377,[0]= -377,[1]= -377,[2]= -363,[3]= -267,[4]= -137,[5]= -52,[6]= -17},
				[3]={[-6]= -43,[-5]= -115,[-4]= -226,[-3]= -314,[-2]= -353,[-1]= -355,[0]= -351,[1]= -345,[2]= -303,[3]= -232,[4]= -132,[5]= -56,[6]= -16},
				[4]={[-6]= -38,[-5]=  -92,[-4]= -167,[-3]= -233,[-2]= -271,[-1]= -267,[0]= -262,[1]= -249,[2]= -218,[3]= -165,[4]=  -97,[5]= -40,[6]= -12},
				[5]={[-6]= -21,[-5]=  -51,[-4]=  -95,[-3]= -124,[-2]= -125,[-1]= -131,[0]= -133,[1]= -127,[2]= -111,[3]=  -82,[4]=  -49,[5]= -20,[6]=  -6},
				[6]={[-6]=  -9,[-5]=  -16,[-4]=  -32,[-3]=  -43,[-2]=  -39,[-1]=  -44,[0]=  -47,[1]=  -47,[2]=  -39,[3]=  -28,[4]=  -18,[5]= -10,[6]=  -2},
				[7]={[-6]=  -2,[-5]=   -2,[-4]=   -3,[-3]=   -5,[-2]=   -5,[-1]=   -8,[0]=   -9,[1]=  -12,[2]=   -6,[3]=   -4,[4]=   -3,[5]=  -1},
			},
			TerrainTextures = {
				TextureList = RMG.MapSettingDefinedStructureSurroundingTexture.ClayPit[_GenerationData.LandscapeSetKey] or RMG.TextureSets.NormalEarthDark,
				Area = 11,
			},
			Water = {}, -- empty Water table uses preset for resource pits -> lowers water around pit - see CreateStructure(...)
		},
		StonePit = {
			Entities = {
				{Type = RMG.MapSettingDefinedStructureEntityType.StonePit[_GenerationData.LandscapeSetKey] or Entities.XD_StonePit1, Resource = _GenerationData.ContentStonePit, Name = "StonePit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 5, Name = "white"},},
			Blocking = 22,
			TerrainHeights = {
				Area = 18,
				[0] = {[0] = -89, [1] = -103,[-1] = -71,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -112,[-2] = -54,[-20] = 0,[20] = 480,[3] = -126,[-3] = -45,[4] = -126,[-4] = -39,[5] = -110,[-5] = -17,[6] = 17,[-6] = -2,[-7] = 0,[7] = 400,[-8] = 0,[8] = 452,[-9] = 0,[9] = 480,},
				[1] = {[0] = -104,[1] = -107,[-1] = -96,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -117,[-2] = -92,[-20] = 0,[20] = 480,[3] = -126,[-3] = -126,[4] = -126,[-4] = -71,[-5] = -31,[5] = -51,[6] = 162,[-6] = -4,[-7] = -1,[7] = 459,[-8] = 0,[8] = 465,[-9] = 0,[9] = 480,},
				[-1] = {[0] = -60,[-1] = -45,[1] = -82,[-10] = 0,[10] = 472,[-11] = 0,[11] = 475,[-12] = 0,[12] = 477,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -161,[-2] = -26,[-20] = 0,[20] = 480,[3] = -131,[-3] = -18,[4] = -126,[-4] = -14,[-5] = 0,[5] = -126,[-6] = 0,[6] = 46,[-7] = 0,[7] = 321,[-8] = 0,[8] = 409,[-9] = 0,[9] = 460,},
				[-10] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 11,[-11] = 0,[11] = 45,[-12] = 0,[12] = 101,[-13] = 0,[13] = 180,[-14] = 0,[14] = 261,[-15] = 0,[15] = 339,[-16] = 0,[16] = 398,[-17] = 0,[17] = 438,[-18] = 0,[18] = 447,[-19] = 0,[19] = 422,[2] = 0,[-2] = 0,[-20] = 0,[20] = 329,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[10] = {[0] = 480,[-1] = 479,[1] = 480,[-10] = 27,[10] = 480,[-11] = 3,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[-3] = 447,[3] = 480,[-4] = 426,[4] = 480,[-5] = 395,[5] = 480,[-6] = 303,[6] = 480,[-7] = 218,[7] = 480,[-8] = 141,[8] = 480,[9] = 480,[-9] = 76,},
				[-11] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 1,[-11] = 0,[11] = 23,[-12] = 0,[12] = 66,[-13] = 0,[13] = 129,[-14] = 0,[14] = 211,[-15] = 0,[15] = 290,[-16] = 0,[16] = 357,[-17] = 0,[17] = 405,[-18] = 0,[18] = 421,[-19] = 0,[19] = 401,[2] = 0,[-2] = 0,[-20] = 0,[20] = 319,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[11] = {[0] = 480,[1] = 480,[-1] = 480,[10] = 480,[-10] = 55,[11] = 480,[-11] = 6,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[-3] = 468,[3] = 480,[-4] = 457,[4] = 480,[-5] = 439,[5] = 480,[-6] = 360,[6] = 480,[-7] = 284,[7] = 480,[-8] = 210,[8] = 480,[-9] = 130,[9] = 480,},
				[-12] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[-11] = 0,[11] = 8,[-12] = 0,[12] = 37,[-13] = 0,[13] = 87,[-14] = 0,[14] = 156,[-15] = 0,[15] = 235,[-16] = 0,[16] = 307,[-17] = 0,[17] = 358,[-18] = 0,[18] = 381,[-19] = 0,[19] = 366,[2] = 0,[-2] = 0,[-20] = 0,[20] = 284,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[12] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 124,[10] = 480,[11] = 480,[-11] = 57,[-12] = 25,[12] = 480,[13] = 480,[-13] = 7,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[-3] = 473,[3] = 480,[-4] = 467,[4] = 480,[-5] = 461,[5] = 480,[-6] = 414,[6] = 480,[-7] = 364,[7] = 480,[-8] = 311,[8] = 480,[-9] = 213,[9] = 480,},
				[-13] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[-12] = 0,[12] = 17,[-13] = 0,[13] = 52,[-14] = 0,[14] = 106,[-15] = 0,[15] = 177,[-16] = 0,[16] = 249,[-17] = 0,[17] = 312,[-18] = 0,[18] = 343,[-19] = 0,[19] = 328,[2] = 0,[-2] = 0,[-20] = 0,[20] = 239,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[13] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 203,[10] = 480,[-11] = 128,[11] = 480,[12] = 480,[-12] = 76,[-13] = 38,[13] = 480,[-14] = 15,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[-3] = 477,[3] = 480,[-4] = 474,[4] = 480,[-5] = 474,[5] = 480,[-6] = 451,[6] = 480,[-7] = 424,[7] = 480,[-8] = 392,[8] = 480,[-9] = 294,[9] = 480,},
				[-14] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[-12] = 0,[12] = 3,[-13] = 0,[13] = 26,[-14] = 0,[14] = 66,[-15] = 0,[15] = 125,[-16] = 0,[16] = 201,[-17] = 0,[17] = 279,[-18] = 0,[18] = 319,[-19] = 0,[19] = 320,[2] = 0,[-2] = 0,[-20] = 0,[20] = 275,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[14] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 292,[10] = 480,[-11] = 221,[11] = 480,[-12] = 166,[12] = 480,[-13] = 115,[13] = 480,[14] = 480,[-14] = 80,[-15] = 44,[15] = 480,[-16] = 19,[16] = 480,[17] = 480,[-17] = 5,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[-6] = 469,[6] = 480,[-7] = 465,[7] = 480,[-8] = 455,[8] = 480,[-9] = 375,[9] = 480,},
				[-15] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[-13] = 0,[13] = 7,[-14] = 0,[14] = 34,[-15] = 0,[15] = 81,[-16] = 0,[16] = 147,[-17] = 0,[17] = 234,[-18] = 0,[18] = 291,[-19] = 0,[19] = 292,[2] = 0,[-2] = 0,[-20] = 0,[20] = 238,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[15] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 373,[10] = 480,[-11] = 328,[11] = 480,[-12] = 285,[12] = 480,[-13] = 232,[13] = 480,[-14] = 179,[14] = 480,[-15] = 124,[15] = 480,[16] = 480,[-16] = 71,[-17] = 29,[17] = 480,[18] = 480,[-18] = 9,[-19] = 0,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[-9] = 434,[9] = 480,},
				[-16] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[13] = 0,[-13] = 0,[-14] = 0,[14] = 10,[-15] = 0,[15] = 44,[-16] = 0,[16] = 101,[-17] = 0,[17] = 175,[-18] = 0,[18] = 236,[-19] = 0,[19] = 242,[2] = 0,[-2] = 0,[-20] = 0,[20] = 197,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[16] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 435,[10] = 480,[-11] = 412,[11] = 480,[-12] = 389,[12] = 480,[-13] = 347,[13] = 480,[-14] = 291,[14] = 480,[-15] = 231,[15] = 480,[-16] = 151,[16] = 480,[17] = 480,[-17] = 80,[-18] = 33,[18] = 480,[-19] = 12,[19] = 480,[2] = 480,[-2] = 480,[-20] = 0,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[-9] = 463,[9] = 480,},
				[-17] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[13] = 0,[-13] = 0,[-14] = 0,[14] = 1,[-15] = 0,[15] = 23,[-16] = 0,[16] = 66,[-17] = 0,[17] = 130,[-18] = 0,[18] = 186,[-19] = 0,[19] = 202,[2] = 0,[-2] = 0,[-20] = 0,[20] = 175,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[17] = {[0] = 480,[1] = 480,[-1] = 480,[-10] = 471,[10] = 480,[-11] = 467,[11] = 480,[-12] = 462,[12] = 480,[-13] = 432,[13] = 480,[-14] = 382,[14] = 480,[-15] = 329,[15] = 480,[-16] = 252,[16] = 480,[-17] = 160,[17] = 480,[18] = 480,[-18] = 89,[-19] = 41,[19] = 480,[2] = 480,[-2] = 480,[-20] = 13,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[9] = 480,[-9] = 480,},
				[-18] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[13] = 0,[-13] = 0,[14] = 0,[-14] = 0,[-15] = 0,[15] = 7,[-16] = 0,[16] = 36,[-17] = 0,[17] = 89,[-18] = 0,[18] = 149,[-19] = 0,[19] = 185,[2] = 0,[-2] = 0,[-20] = 0,[20] = 161,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[18] = {[0] = 480,[1] = 480,[-1] = 480,[10] = 480,[-10] = 480,[11] = 480,[-11] = 480,[12] = 480,[-12] = 480,[-13] = 467,[13] = 480,[-14] = 433,[14] = 480,[-15] = 399,[15] = 480,[-16] = 343,[16] = 480,[-17] = 265,[17] = 480,[-18] = 190,[18] = 480,[-19] = 115,[19] = 480,[2] = 480,[-2] = 480,[20] = 480,[-20] = 51,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[9] = 480,[-9] = 480,},
				[-19] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[13] = 0,[-13] = 0,[14] = 0,[-14] = 0,[15] = 0,[-15] = 0,[-16] = 0,[16] = 9,[-17] = 0,[17] = 45,[-18] = 0,[18] = 131,[-19] = 0,[19] = 228,[2] = 0,[-2] = 0,[-20] = 0,[20] = 190,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[19] = {[0] = 480,[1] = 480,[-1] = 480,[10] = 480,[-10] = 480,[11] = 480,[-11] = 480,[12] = 480,[-12] = 480,[-13] = 474,[13] = 480,[-14] = 451,[14] = 480,[-15] = 432,[15] = 480,[-16] = 403,[16] = 480,[-17] = 356,[17] = 480,[-18] = 298,[18] = 480,[-19] = 224,[19] = 480,[2] = 480,[-2] = 480,[-20] = 111,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[9] = 480,[-9] = 480,},
				[2] = {[0] = -104,[1] = -112,[-1] = -117,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -126,[-2] = -126,[-20] = 0,[20] = 480,[3] = -126,[-3] = -126,[4] = -107,[-4] = -109,[-5] = -20,[5] = 30,[-6] = -3,[6] = 326,[-7] = -1,[7] = 478,[-8] = 0,[8] = 480,[-9] = 0,[9] = 480,},
				[-2] = {[0] = -39,[-1] = -22,[1] = -64,[-10] = 0,[10] = 459,[-11] = 0,[11] = 472,[-12] = 0,[12] = 475,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -116,[-2] = -9,[-20] = 0,[20] = 480,[3] = -141,[-3] = -4,[-4] = -1,[4] = -126,[-5] = 0,[5] = -126,[-6] = 0,[6] = 50,[-7] = 0,[7] = 246,[-8] = 0,[8] = 345,[-9] = 0,[9] = 425,},
				[-20] = {[0] = 0,[1] = 0,[-1] = 0,[10] = 0,[-10] = 0,[11] = 0,[-11] = 0,[12] = 0,[-12] = 0,[13] = 0,[-13] = 0,[14] = 0,[-14] = 0,[15] = 0,[-15] = 0,[-16] = 0,[16] = 1,[-17] = 0,[17] = 23,[-18] = 0,[18] = 87,[-19] = 0,[19] = 164,[2] = 0,[-2] = 0,[-20] = 0,[20] = 140,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[9] = 0,[-9] = 0,},
				[20] = {[0] = 480,[1] = 480,[-1] = 480,[10] = 480,[-10] = 480,[11] = 480,[-11] = 480,[12] = 480,[-12] = 480,[13] = 480,[-13] = 480,[-14] = 374,[14] = 480,[-15] = 366,[15] = 480,[-16] = 355,[16] = 480,[-17] = 318,[17] = 480,[-18] = 265,[18] = 480,[-19] = 220,[19] = 480,[2] = 480,[-2] = 480,[-20] = 149,[20] = 480,[3] = 480,[-3] = 480,[4] = 480,[-4] = 480,[5] = 480,[-5] = 480,[6] = 480,[-6] = 480,[7] = 480,[-7] = 480,[8] = 480,[-8] = 480,[9] = 480,[-9] = 480,},
				[-3] = {[0] = -11,[1] = -33,[-1] = -6,[-10] = 0,[10] = 426,[-11] = 0,[11] = 462,[-12] = 0,[12] = 471,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = -3,[2] = -76,[-20] = 0,[20] = 480,[-3] = 0,[3] = -97,[-4] = 0,[4] = -101,[-5] = 0,[5] = -126,[-6] = 0,[6] = 51,[-7] = 0,[7] = 204,[-8] = 0,[8] = 267,[-9] = 0,[9] = 310,},
				[3] = {[0] = -126,[1] = -126,[-1] = -126,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -126,[-2] = -126,[-20] = 0,[20] = 480,[3] = -124,[-3] = -126,[-4] = -112,[4] = -57,[5] = 153,[-5] = -17,[-6] = -3,[6] = 416,[-7] = -1,[7] = 480,[-8] = 0,[8] = 480,[-9] = 0,[9] = 480,},
				[-4] = {[0] = 0,[-1] = 0,[1] = -4,[-10] = 0,[10] = 365,[-11] = 0,[11] = 434,[-12] = 0,[12] = 460,[-13] = 0,[13] = 473,[-14] = 0,[14] = 475,[-15] = 0,[15] = 478,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = 0,[2] = -36,[-20] = 0,[20] = 480,[-3] = 0,[3] = -50,[-4] = 0,[4] = -48,[5] = 0,[-5] = 0,[-6] = 0,[6] = 29,[-7] = 0,[7] = 124,[-8] = 0,[8] = 178,[-9] = 0,[9] = 252,},
				[4] = {[0] = -126,[1] = -126,[-1] = -126,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = -126,[-2] = -126,[-20] = 0,[20] = 480,[-3] = -126,[3] = -65,[4] = 101,[-4] = -106,[5] = 336,[-5] = -39,[6] = 480,[-6] = -9,[-7] = -1,[7] = 480,[-8] = 0,[8] = 480,[-9] = 0,[9] = 480,},
				[-5] = {[0] = 0,[-1] = 0,[1] = -1,[-10] = 0,[10] = 298,[-11] = 0,[11] = 392,[-12] = 0,[12] = 438,[-13] = 0,[13] = 467,[-14] = 0,[14] = 469,[-15] = 0,[15] = 477,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = 0,[2] = -7,[-20] = 0,[20] = 480,[-3] = 0,[3] = -18,[-4] = 0,[4] = -12,[5] = 0,[-5] = 0,[-6] = 0,[6] = 5,[-7] = 0,[7] = 57,[-8] = 0,[8] = 106,[-9] = 0,[9] = 179,},
				[5] = {[0] = -126,[1] = -124,[-1] = -126,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = -126,[2] = -77,[-20] = 0,[20] = 480,[-3] = -126,[3] = 78,[4] = 279,[-4] = -88,[-5] = -29,[5] = 439,[-6] = 2,[6] = 480,[-7] = 1,[7] = 480,[-8] = 0,[8] = 480,[-9] = 0,[9] = 480,},
				[-6] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 176,[-11] = 0,[11] = 347,[-12] = 0,[12] = 412,[-13] = 0,[13] = 438,[-14] = 0,[14] = 454,[-15] = 0,[15] = 473,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 0,[-2] = 0,[-20] = 0,[20] = 480,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[-7] = 0,[7] = 11,[-8] = 0,[8] = 40,[-9] = 0,[9] = 89,},
				[6] = {[0] = -75,[-1] = -126,[1] = 8,[-10] = 0,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 101,[-2] = -126,[-20] = 0,[20] = 480,[-3] = -126,[3] = 237,[-4] = -12,[4] = 415,[-5] = 41,[5] = 480,[6] = 480,[-6] = 53,[-7] = 34,[7] = 480,[8] = 480,[-8] = 8,[-9] = 2,[9] = 480,},
				[-7] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 106,[-11] = 0,[11] = 206,[-12] = 0,[12] = 296,[-13] = 0,[13] = 360,[-14] = 0,[14] = 411,[-15] = 0,[15] = 447,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 0,[-2] = 0,[-20] = 0,[20] = 480,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[-8] = 0,[8] = 14,[-9] = 0,[9] = 42,},
				[7] = {[0] = 94,[-1] = -13,[1] = 207,[10] = 480,[-10] = 7,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 331,[-2] = -36,[-20] = 0,[20] = 480,[3] = 439,[-3] = 92,[-4] = 179,[4] = 480,[-5] = 165,[5] = 480,[-6] = 142,[6] = 480,[7] = 480,[-7] = 94,[8] = 480,[-8] = 54,[-9] = 30,[9] = 480,},
				[-8] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 54,[-11] = 0,[11] = 118,[-12] = 0,[12] = 198,[-13] = 0,[13] = 286,[-14] = 0,[14] = 359,[-15] = 0,[15] = 422,[-16] = 0,[16] = 470,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[2] = 0,[-2] = 0,[-20] = 0,[20] = 480,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[-9] = 0,[9] = 19,},
				[8] = {[0] = 322,[-1] = 196,[1] = 424,[-10] = 17,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = 270,[2] = 485,[-20] = 0,[20] = 480,[-3] = 267,[3] = 480,[-4] = 269,[4] = 480,[-5] = 243,[5] = 480,[-6] = 195,[6] = 480,[-7] = 137,[7] = 480,[8] = 480,[-8] = 93,[9] = 480,[-9] = 61,},
				[-9] = {[0] = 0,[1] = 0,[-1] = 0,[-10] = 0,[10] = 29,[-11] = 0,[11] = 69,[-12] = 0,[12] = 142,[-13] = 0,[13] = 229,[-14] = 0,[14] = 309,[-15] = 0,[15] = 381,[-16] = 0,[16] = 432,[-17] = 0,[17] = 461,[-18] = 0,[18] = 463,[-19] = 0,[19] = 442,[2] = 0,[-2] = 0,[-20] = 0,[20] = 343,[3] = 0,[-3] = 0,[4] = 0,[-4] = 0,[5] = 0,[-5] = 0,[6] = 0,[-6] = 0,[7] = 0,[-7] = 0,[8] = 0,[-8] = 0,[-9] = 0,[9] = 4,},
				[9] = {[0] = 485,[-1] = 448,[1] = 485,[-10] = 20,[10] = 480,[-11] = 0,[11] = 480,[-12] = 0,[12] = 480,[-13] = 0,[13] = 480,[-14] = 0,[14] = 480,[-15] = 0,[15] = 480,[-16] = 0,[16] = 480,[-17] = 0,[17] = 480,[-18] = 0,[18] = 480,[-19] = 0,[19] = 480,[-2] = 429,[2] = 480,[-20] = 0,[20] = 480,[-3] = 378,[3] = 480,[-4] = 352,[4] = 480,[-5] = 311,[5] = 480,[-6] = 246,[6] = 480,[-7] = 170,[7] = 480,[-8] = 110,[8] = 480,[9] = 480,[-9] = 62,},
			},
			TerrainTextures = {
				TextureList = RMG.MapSettingDefinedStructureSurroundingTexture.StonePit[_GenerationData.LandscapeSetKey] or RMG.TextureSets.NormalRocky,
				RelativX = 3,
				RelativY = 4,
				Area = {x1 = -8, y1 = -8, x2 = 12, y2 = 12},
			},
			Water = {},
		},
		IronPit = {
			Entities = {
				{Type = Entities.XD_IronPit1, Resource = _GenerationData.ContentIronPit, Name = "IronPit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 5, Name = "white"},},
			Blocking = 20,
			TerrainHeights = {
				Area = 16,
				[-4]={[-4]= 0,[-3]=   0,[-2]=   -5},
				[-3]={[-4]= 0,[-3]=  -2,[-2]=   -2,[-1]=   -2,[0]=   -2},
				[-2]={[-4]= 0,[-3]=  -8,[-2]=  -14,[-1]=  -24,[0]=  -46,[1]=  -44,[2]=  -49,[3]=  -25},
				[-1]={[-4]= 0,[-3]= -23,[-2]=  -58,[-1]= -106,[0]= -172,[1]= -180,[2]= -153,[3]=  -74},
				[0]={[-4]=-4,[-3]= -32,[-2]= -103,[-1]= -337,[0]= -327,[1]= -375,[2]= -264,[3]= -114},
				[1]={[-4]=-5,[-3]= -36,[-2]= -109,[-1]= -308,[0]= -357,[1]= -412,[2]= -296,[3]= -122},
				[2]={[-4]=-1,[-3]= -24,[-2]=  -89,[-1]= -182,[0]= -246,[1]= -268,[2]= -219,[3]=  -70},
				[3]={[-4]= 0,[-3]=  -4,[-2]=  -40,[-1]=  -85,[0]= -109,[1]= -107,[2]=  -64},
				[4]={[-4]= 0,[-3]=   0,[-2]=    0,[-1]=   -2,[0]=   -4},
			},
			TerrainTextures = {
				TextureList = RMG.TextureSets.NormalMudDarkIronSmooth,
				Area = 10,
			},
			Water = {},
		},
		GoldPit = {
			Entities = {
				{Type = Entities.XD_GoldPit1, Resource = _GenerationData.ContentGoldPit, Name = "GoldPit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 5, Name = "white"},},
			Blocking = 20,
			TerrainHeights = {
				Area = 16,
				[-4]={[-4]= 0,[-3]=   0,[-2]=   -5},
				[-3]={[-4]= 0,[-3]=  -2,[-2]=   -2,[-1]=   -2,[0]=   -2},
				[-2]={[-4]= 0,[-3]=  -8,[-2]=  -14,[-1]=  -24,[0]=  -46,[1]=  -44,[2]=  -49,[3]=  -25},
				[-1]={[-4]= 0,[-3]= -23,[-2]=  -58,[-1]= -106,[0]= -172,[1]= -180,[2]= -153,[3]=  -74},
				[0]={[-4]=-4,[-3]= -32,[-2]= -103,[-1]= -337,[0]= -327,[1]= -375,[2]= -264,[3]= -114},
				[1]={[-4]=-5,[-3]= -36,[-2]= -109,[-1]= -308,[0]= -357,[1]= -412,[2]= -296,[3]= -122},
				[2]={[-4]=-1,[-3]= -24,[-2]=  -89,[-1]= -182,[0]= -246,[1]= -268,[2]= -219,[3]=  -70},
				[3]={[-4]= 0,[-3]=  -4,[-2]=  -40,[-1]=  -85,[0]= -109,[1]= -107,[2]=  -64},
				[4]={[-4]= 0,[-3]=   0,[-2]=    0,[-1]=   -2,[0]=   -4},
			},
			TerrainTextures = {
				TextureList = RMG.TextureSets.NormalMudDarkGoldSmooth,
				Area = 10,
			},
			Water = {},
		},
		SilverPit = {
			Entities = {
				{Type = Entities.XD_SilverPit1, Resource = _GenerationData.ContentSilverPit, Name = "SilverPit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 5, Name = "white"},},
			Blocking = 20,
			TerrainHeights = {
				Area = 16,
				[-4]={[-4]= 0,[-3]=   0,[-2]=   -5},
				[-3]={[-4]= 0,[-3]=  -2,[-2]=   -2,[-1]=   -2,[0]=   -2},
				[-2]={[-4]= 0,[-3]=  -8,[-2]=  -14,[-1]=  -24,[0]=  -46,[1]=  -44,[2]=  -49,[3]=  -25},
				[-1]={[-4]= 0,[-3]= -23,[-2]=  -58,[-1]= -106,[0]= -172,[1]= -180,[2]= -153,[3]=  -74},
				[0]={[-4]=-4,[-3]= -32,[-2]= -103,[-1]= -337,[0]= -327,[1]= -375,[2]= -264,[3]= -114},
				[1]={[-4]=-5,[-3]= -36,[-2]= -109,[-1]= -308,[0]= -357,[1]= -412,[2]= -296,[3]= -122},
				[2]={[-4]=-1,[-3]= -24,[-2]=  -89,[-1]= -182,[0]= -246,[1]= -268,[2]= -219,[3]=  -70},
				[3]={[-4]= 0,[-3]=  -4,[-2]=  -40,[-1]=  -85,[0]= -109,[1]= -107,[2]=  -64},
				[4]={[-4]= 0,[-3]=   0,[-2]=    0,[-1]=   -2,[0]=   -4},
			},
			TerrainTextures = {
				TextureList = RMG.TextureSets.NormalMudDarkSilverSmooth,
				Area = 10,
			},
			Water = {},
		},
		SulfurPit = {
			Entities = {
				{Type = Entities.XD_SulfurPit1, Resource = _GenerationData.ContentSulfurPit, Name = "SulfurPit"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 5, Name = "white"},},
			Blocking = 20,
			TerrainHeights = {
				Area = 16,
				[-3]={[-5]= 0,[-4]=  -2,[-3]=   -2,[-2]=   -2,[-1]=   -2},
				[-2]={[-5]= 0,[-4]=  -8,[-3]=  -14,[-2]=  -24,[-1]=  -46,[0]=  -44,[1]=  -49,[2]=  -25},
				[-1]={[-5]= 0,[-4]= -23,[-3]=  -58,[-2]= -106,[-1]= -172,[0]= -180,[1]= -153,[2]=  -74},
				[0]={[-5]=-4,[-4]= -32,[-3]= -103,[-2]= -337,[-1]= -327,[0]= -365,[1]= -264,[2]= -114},
				[1]={[-5]=-5,[-4]= -36,[-3]= -109,[-2]= -308,[-1]= -357,[0]= -412,[1]= -296,[2]= -122},
				[2]={[-5]=-1,[-4]= -24,[-3]=  -89,[-2]= -182,[-1]= -246,[0]= -268,[1]= -219,[2]=  -70},
				[3]={[-5]= 0,[-4]=  -4,[-3]=  -40,[-2]=  -85,[-1]= -109,[0]= -107,[1]=  -64},
			},
			TerrainTextures = {
				TextureList = RMG.MapSettingDefinedStructureSurroundingTexture.SulfurPit[_GenerationData.LandscapeSetKey] or RMG.TextureSets.NorthSand,
				Area = 9,
			},
			Water = {},
		},
		ClayPile = {
			Entities = {{Type = Entities.XD_Clay1, Resource = _GenerationData.ContentClayPile,},},
			Blocking = 5,
		},
		StonePile = {
			Entities = {{Type = RMG.MapSettingDefinedStructureEntityType.Stone[_GenerationData.LandscapeSetKey] or Entities.XD_Stone1, Resource = _GenerationData.ContentStonePile,},},
			Blocking = 7,
		},
		IronPile = {
			Entities = {{Type = Entities.XD_Iron1, Resource = _GenerationData.ContentIronPile,},},
			Blocking = 5,
		},
		SulfurPile = {
			Entities = {{Type = Entities.XD_Sulfur1, Resource = _GenerationData.ContentSulfurPile,},},
			Blocking = 5,
		},
		SilverPile = {
			Entities = {{Type = Entities.XD_Silver1, Resource = _GenerationData.ContentSilverPile,},},
			Blocking = 5,
		},
		WoodPileExplored = {
			Entities = {{Type = Entities.XD_ScriptEntity, Name = "woodpile",}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 2, Name = "white"},},
			Blocking = 5,
		},
		ClayPileExplored = {
			Entities = {{Type = Entities.XD_Clay1, Resource = _GenerationData.ContentClayPile,}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 3, Name = "white"},},
			Blocking = 5,
		},
		StonePileExplored = {
			Entities = {{Type = RMG.MapSettingDefinedStructureEntityType.Stone[_GenerationData.LandscapeSetKey] or Entities.XD_Stone1, Resource = _GenerationData.ContentStonePile,}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 3, Name = "white"},},
			Blocking = 5,
		},
		IronPileExplored = {
			Entities = {{Type = Entities.XD_Iron1, Resource = _GenerationData.ContentIronPile,}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 3, Name = "white"},},
			Blocking = 5,
		},
		SulfurPileExplored = {
			Entities = {{Type = Entities.XD_Sulfur1, Resource = _GenerationData.ContentSulfurPile,}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 3, Name = "white"},},
			Blocking = 5,
		},
		SilverPileExplored = {
			Entities = {{Type = Entities.XD_Silver1, Resource = _GenerationData.ContentSilverPile,}, {Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreResources * 3, Name = "white"},},
			Blocking = 5,
		},
		Bridge1 = {-- x axis
			Blocking = 20,
			Entities = {
				{Type = Entities.XD_Bridge1,},
				{Type = Entities.PB_Bridge1,},
			},
			TerrainHeights = {
				Area = {X = 30, Y = 15},
				LerpDist = 5,
				BaseHeight = _GenerationData.TerrainBaseHeight,
				[-15] = {[15] = -50, [14] = -50, [13] = -50, [12] = -50, [11] = -50, [10] = -50, [9] = -50, [8] = -50, [7] = -50, [6] = -30, [5] = -20, [4] = 0, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = 0, [-5] = -20, [-6] = -30, [-7] = -50, [-8] = -50, [-9] = -50, [-10] = -50, [-11] = -50, [-12] = -50, [-13] = -50, [-14] = -50, [-15] = -50,},
				[-14] = {[15] = -125, [14] = -125, [13] = -125, [12] = -125, [11] = -125, [10] = -125, [9] = -125, [8] = -125, [7] = -125, [6] = -125, [5] = -80, [4] = -20, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = -20, [-5] = -80, [-6] = -125, [-7] = -125, [-8] = -125, [-9] = -125, [-10] = -125, [-11] = -125, [-12] = -125, [-13] = -125, [-14] = -125, [-15] = -125,},
				[-13] = {[15] = -225, [14] = -225, [13] = -225, [12] = -225, [11] = -225, [10] = -225, [9] = -225, [8] = -225, [7] = -225, [6] = -225, [5] = -225, [4] = -180, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = -180, [-5] = -225, [-6] = -225, [-7] = -225, [-8] = -225, [-9] = -225, [-10] = -225, [-11] = -225, [-12] = -225, [-13] = -225, [-14] = -225, [-15] = -225,},
				[-12] = {[15] = -331, [14] = -331, [13] = -331, [12] = -331, [11] = -331, [10] = -331, [9] = -331, [8] = -331, [7] = -331, [6] = -331, [5] = -331, [4] = -331, [3] = -331, [2] = -331, [1] = -331, [0] = -331, [-1] = -331, [-2] = -331, [-3] = -331, [-4] = -331, [-5] = -331, [-6] = -331, [-7] = -331, [-8] = -331, [-9] = -331, [-10] = -331, [-11] = -331, [-12] = -331, [-13] = -331, [-14] = -331, [-15] = -331,},
				[-11] = {[15] = -438, [14] = -438, [13] = -438, [12] = -438, [11] = -438, [10] = -438, [9] = -438, [8] = -438, [7] = -438, [6] = -438, [5] = -438, [4] = -438, [3] = -438, [2] = -438, [1] = -438, [0] = -438, [-1] = -438, [-2] = -438, [-3] = -438, [-4] = -438, [-5] = -438, [-6] = -438, [-7] = -438, [-8] = -438, [-9] = -438, [-10] = -438, [-11] = -438, [-12] = -438, [-13] = -438, [-14] = -438, [-15] = -438,},
				[-10] = {[15] = -538, [14] = -538, [13] = -538, [12] = -538, [11] = -538, [10] = -538, [9] = -538, [8] = -538, [7] = -538, [6] = -538, [5] = -538, [4] = -538, [3] = -538, [2] = -538, [1] = -538, [0] = -538, [-1] = -538, [-2] = -538, [-3] = -538, [-4] = -538, [-5] = -538, [-6] = -538, [-7] = -538, [-8] = -538, [-9] = -538, [-10] = -538, [-11] = -538, [-12] = -538, [-13] = -538, [-14] = -538, [-15] = -538,},
				[-9] = {[15] = -613, [14] = -613, [13] = -613, [12] = -613, [11] = -613, [10] = -613, [9] = -613, [8] = -613, [7] = -613, [6] = -613, [5] = -613, [4] = -613, [3] = -613, [2] = -613, [1] = -613, [0] = -613, [-1] = -613, [-2] = -613, [-3] = -613, [-4] = -613, [-5] = -613, [-6] = -613, [-7] = -613, [-8] = -613, [-9] = -613, [-10] = -613, [-11] = -613, [-12] = -613, [-13] = -613, [-14] = -613, [-15] = -613,},
				[-8] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-7] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-6] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-5] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-4] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-3] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-2] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[-1] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[0] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[1] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[2] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[3] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[4] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[5] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[6] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[7] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[8] = {[15] = -663, [14] = -663, [13] = -663, [12] = -663, [11] = -663, [10] = -663, [9] = -663, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -663, [-10] = -663, [-11] = -663, [-12] = -663, [-13] = -663, [-14] = -663, [-15] = -663,},
				[9] = {[15] = -613, [14] = -613, [13] = -613, [12] = -613, [11] = -613, [10] = -613, [9] = -613, [8] = -613, [7] = -613, [6] = -613, [5] = -613, [4] = -613, [3] = -613, [2] = -613, [1] = -613, [0] = -613, [-1] = -613, [-2] = -613, [-3] = -613, [-4] = -613, [-5] = -613, [-6] = -613, [-7] = -613, [-8] = -613, [-9] = -613, [-10] = -613, [-11] = -613, [-12] = -613, [-13] = -613, [-14] = -613, [-15] = -613,},
				[10] = {[15] = -538, [14] = -538, [13] = -538, [12] = -538, [11] = -538, [10] = -538, [9] = -538, [8] = -538, [7] = -538, [6] = -538, [5] = -538, [4] = -538, [3] = -538, [2] = -538, [1] = -538, [0] = -538, [-1] = -538, [-2] = -538, [-3] = -538, [-4] = -538, [-5] = -538, [-6] = -538, [-7] = -538, [-8] = -538, [-9] = -538, [-10] = -538, [-11] = -538, [-12] = -538, [-13] = -538, [-14] = -538, [-15] = -538,},
				[11] = {[15] = -438, [14] = -438, [13] = -438, [12] = -438, [11] = -438, [10] = -438, [9] = -438, [8] = -438, [7] = -438, [6] = -438, [5] = -438, [4] = -438, [3] = -438, [2] = -438, [1] = -438, [0] = -438, [-1] = -438, [-2] = -438, [-3] = -438, [-4] = -438, [-5] = -438, [-6] = -438, [-7] = -438, [-8] = -438, [-9] = -438, [-10] = -438, [-11] = -438, [-12] = -438, [-13] = -438, [-14] = -438, [-15] = -438,},
				[12] = {[15] = -331, [14] = -331, [13] = -331, [12] = -331, [11] = -331, [10] = -331, [9] = -331, [8] = -331, [7] = -331, [6] = -331, [5] = -331, [4] = -331, [3] = -331, [2] = -331, [1] = -331, [0] = -331, [-1] = -331, [-2] = -331, [-3] = -331, [-4] = -331, [-5] = -331, [-6] = -331, [-7] = -331, [-8] = -331, [-9] = -331, [-10] = -331, [-11] = -331, [-12] = -331, [-13] = -331, [-14] = -331, [-15] = -331,},
				[13] = {[15] = -225, [14] = -225, [13] = -225, [12] = -225, [11] = -225, [10] = -225, [9] = -225, [8] = -225, [7] = -225, [6] = -225, [5] = -225, [4] = -180, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = -180, [-5] = -225, [-6] = -225, [-7] = -225, [-8] = -225, [-9] = -225, [-10] = -225, [-11] = -225, [-12] = -225, [-13] = -225, [-14] = -225, [-15] = -225,},
				[14] = {[15] = -125, [14] = -125, [13] = -125, [12] = -125, [11] = -125, [10] = -125, [9] = -125, [8] = -125, [7] = -125, [6] = -125, [5] = -80, [4] = -20, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = -20, [-5] = -80, [-6] = -125, [-7] = -125, [-8] = -125, [-9] = -125, [-10] = -125, [-11] = -125, [-12] = -125, [-13] = -125, [-14] = -125, [-15] = -125,},
				[15] = {[15] = -50, [14] = -50, [13] = -50, [12] = -50, [11] = -50, [10] = -50, [9] = -50, [8] = -50, [7] = -50, [6] = -30, [5] = -20, [4] = 0, [3] = 0, [2] = 0, [1] = 0, [0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = 0, [-5] = -20, [-6] = -30, [-7] = -50, [-8] = -50, [-9] = -50, [-10] = -50, [-11] = -50, [-12] = -50, [-13] = -50, [-14] = -50, [-15] = -50,},
			},
			TerrainTextures = {
				Area = {X = 18, Y = 6,},
				TextureList = "Coast",
			},
		},
		Bridge2 = {-- y axis
			Blocking = 20,
			Entities = {
				{Type = Entities.XD_Bridge2,},
				{Type = Entities.PB_Bridge2,},
			},
			TerrainHeights = {
				Area = {X = 15, Y = 30},
				LerpDist = 5,
				BaseHeight = _GenerationData.TerrainBaseHeight,
				[-15] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-14] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-13] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-12] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-11] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-10] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-9] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-8] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-7] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-6] = {[15] = -30, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -30, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-5] = {[15] = -20, [14] = -80, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -80, [-15] = -20, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-4] = {[15] = 0, [14] = -20, [13] = -180, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -180, [-14] = -20, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-3] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-2] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[-1] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[0] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[1] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[2] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[3] = {[15] = 0, [14] = 0, [13] = 0, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = 0, [-14] = 0, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[4] = {[15] = 0, [14] = -20, [13] = -180, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -180, [-14] = -20, [-15] = 0, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[5] = {[15] = -20, [14] = -80, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -80, [-15] = -20, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[6] = {[15] = -30, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -30, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[7] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[8] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[9] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[10] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[11] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[12] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[13] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[14] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
				[15] = {[15] = -50, [14] = -125, [13] = -225, [12] = -331, [11] = -438, [10] = -538, [9] = -613, [8] = -663, [7] = -663, [6] = -663, [5] = -663, [4] = -663, [3] = -663, [2] = -663, [1] = -663, [0] = -663, [-1] = -663, [-2] = -663, [-3] = -663, [-4] = -663, [-5] = -663, [-6] = -663, [-7] = -663, [-8] = -663, [-9] = -613, [-10] = -538, [-11] = -438, [-12] = -331, [-13] = -225, [-14] = -125, [-15] = -50, [-16] = 0, [-17] = 0, [-18] = 0, [-19] = 0, [-20] = 0,},
			},
			TerrainTextures = {
				Area = {X = 6, Y = 18,},
				TextureList = "Coast",
			},
		},
		NeutralVillageCenter = {
			Blocking = 18,
			Entities = {
				{Type = Entities.XD_VillageCenter, Name = "VillageCenter"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreVCs * 6, Name = "green"},
			},
			TerrainHeights = {
				Area = 18,
			},
			TerrainTextures = {
				Area = {X = 10, Y = 10,},
				TextureList = "Road",
			},
		},
		NeutralVillageHall = {
			Blocking = 18,
			Entities = {
				{Type = Entities.XD_VillageCenter_Ruin, Name = "VillageHall"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreVCs * 6, Name = "green"},
			},
			TerrainHeights = {
				Area = 18,
			},
			TerrainTextures = {
				Area = {X = 10, Y = 10,},
				TextureList = "Road",
			},
		},
		NeutralLighthouse = {
			Blocking = 14,
			Entities = {
				{Type = Entities.XD_Lighthouse_Ruin, Name = "Lighthouse"},
				{Type = Entities.XD_ScriptEntity, Explore = _GenerationData.ExploreVCs * 6, Name = "green"},
			},
			TerrainHeights = {
				Area = 14,
			},
			TerrainTextures = {
				Area = {X = 8, Y = 8,},
				TextureList = "Road",
			},
		},
		Placement = {
			PileAtPit = {
				AreaMin = 8,
				AreaMax = 12,
				HeightMin = heightmin,
				HeightMax = heightmax,
			},
			PileAtPile = {
				AreaMin = 4,
				AreaMax = 8,
				HeightMin = heightmin,
				HeightMax = heightmax,
			},
		},
	}

	local resoff = math.max(8, _GenerationData.NumberOfPlayers / 2)
	local maphalf = Logic.WorldGetSize() / 200
	local maxdist

	if _GenerationData.NumberOfPlayers > 1 then
		-- triangle calculation for distance between players of same team
		local b = maphalf * _GenerationData.PlayerDistanceToMiddle
		local alpha = _GenerationData.MirrorRadian
		local beta = (math.rad(180) - alpha) / 2
		local a = b / math.sin(beta) * math.sin(alpha)

		maxdist = math.min(a / 2 - 10 - resoff, 120)
		-- maxdist at 12+ players is 89.44 so basicly 90 (a good value in the old generator)
		-- - 10 (blocking) - 5 (resoff) = 75
	else
		maxdist = maphalf / 2
	end

	_GenerationData.ResourceDistanceOffset = resoff
	_GenerationData.MaxStructureDistance = maxdist
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.FillStructs(_GenerationData)
	-- build player structure tables
	RMG.StructureSets.NeutralStruct = RMG.GetNeutralStruct()
	RMG.FillNeutralStruct(_GenerationData)

	RMG.StructureSets.PlayerStruct = RMG.GetPlayerStruct()
	RMG.FillPlayerStruct(_GenerationData)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetComposition(_GenerationData)

	local nplayers = _GenerationData.NumberOfPlayers
	local nteams = _GenerationData.NumberOfTeams

	-- define special compositions for 12+ players
	local distance = math.min((nteams + 13) / 30 * Logic.WorldGetSize() / 200, 0.6 * Logic.WorldGetSize() / 200)
	local compositions = {
		--[[[11] = {
			[2] = {
				NumberOfPlayers = 10, NumberOfTeams = 2, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {2, 3, 4, 5, 7, 8, 9, 10, 11},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  4, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5,},
				[ 6] = {Slize =  3, Distance = distance, Mirror = {},},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  8,},
				[ 9] = {Slize =  9, AxisMirrorFlag = true,},
				[10] = {Slize = 10,},
				[11] = {Slize = 11, AxisMirrorFlag = true,},
				TeamBorderSlizes = {0, 6},
			},
		},]]
		[12] = {
			[2] = {
				NumberOfPlayers = 10, NumberOfTeams = 2, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {2, 3, 4, 5, 7, 8, 9, 10, 11},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  4, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5,},
				[ 6] = {Slize =  3, Distance = distance, Mirror = {12},},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  8,},
				[ 9] = {Slize =  9, AxisMirrorFlag = true,},
				[10] = {Slize = 10,},
				[11] = {Slize = 11, AxisMirrorFlag = true,},
				[12] = {Slize =  9, AxisMirrorFlag = true, Distance = distance,},
				TeamBorderSlizes = {0, 6},
			},
			[ 3] = {
				NumberOfPlayers = 9, NumberOfTeams = 3, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {2, 3, 5, 6, 7, 9, 10, 11},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  2, Distance = distance, Mirror = {8, 12},},
				[ 5] = {Slize =  5, AxisMirrorFlag = true,},
				[ 6] = {Slize =  6,},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  6, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  9,},
				[10] = {Slize = 10, AxisMirrorFlag = true,},
				[11] = {Slize = 11,},
				[12] = {Slize = 10, Distance = distance,},
				TeamBorderSlizes = {0, 4, 8},
			},
			[ 4] = {
				NumberOfPlayers = 8, NumberOfTeams = 4, EqualTeams = true,
				[ 1] = {Slize =    1, Mirror = {2, 4, 5, 7, 8, 10, 11},},
				[ 2] = {Slize =    2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  1.5, Distance = distance, Mirror = {6, 9, 12},},
				[ 4] = {Slize =    4,},
				[ 5] = {Slize =    5, AxisMirrorFlag = true,},
				[ 6] = {Slize =  4.5, Distance = distance,},
				[ 7] = {Slize =    7,},
				[ 8] = {Slize =    8, AxisMirrorFlag = true,},
				[ 9] = {Slize =  7.5, Distance = distance,},
				[10] = {Slize =   10,},
				[11] = {Slize =   11, AxisMirrorFlag = true,},
				[12] = {Slize = 10.5, Distance = distance,},
				TeamBorderSlizes = {0, 3, 6, 9},
			},
			[ 6] = {
				NumberOfPlayers = 6, NumberOfTeams = 6, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {3, 5, 7, 9, 11},},
				[ 2] = {Slize =  1, Distance = distance, Mirror = {4, 6, 8, 10, 12},},
				[ 3] = {Slize =  3, AxisMirrorFlag = true,},
				[ 4] = {Slize =  3, AxisMirrorFlag = true, Distance = distance,},
				[ 5] = {Slize =  5,},
				[ 6] = {Slize =  5, Distance = distance,},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  7, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  9,},
				[10] = {Slize =  9, Distance = distance,},
				[11] = {Slize = 11, AxisMirrorFlag = true,},
				[12] = {Slize = 11, AxisMirrorFlag = true, Distance = distance,},
				TeamBorderSlizes = {0, 2, 4, 6, 8, 10},
			},
			[12] = {
				NumberOfPlayers = 12, NumberOfTeams = 0, EqualTeams = true,
				[ 1] = {Slize =  1, Team = 0, Mirror = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},},
				[ 2] = {Slize =  2, Team = 0, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3, Team = 0,},
				[ 4] = {Slize =  4, Team = 0, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5, Team = 0,},
				[ 6] = {Slize =  6, Team = 0, AxisMirrorFlag = true,},
				[ 7] = {Slize =  7, Team = 0,},
				[ 8] = {Slize =  8, Team = 0, AxisMirrorFlag = true,},
				[ 9] = {Slize =  9, Team = 0,},
				[10] = {Slize = 10, Team = 0, AxisMirrorFlag = true,},
				[11] = {Slize = 11, Team = 0,},
				[12] = {Slize = 12, Team = 0, AxisMirrorFlag = true,},
				TeamBorderSlizes = {},
			},
		},
		[13] = {
			[13] = {
				NumberOfPlayers = 10, NumberOfTeams = 2, EqualTeams = true,
				[ 1] = {Slize =  1, Team = 0, Mirror = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},},
				[ 2] = {Slize =  2, Team = 0, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3, Team = 0,},
				[ 4] = {Slize =  4, Team = 0, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5, Team = 0,},
				[ 6] = {Slize =  6, Team = 0, AxisMirrorFlag = true,},
				[ 7] = {Slize =  7, Team = 0,},
				[ 8] = {Slize =  8, Team = 0, AxisMirrorFlag = true,},
				[ 9] = {Slize =  9, Team = 0,},
				[10] = {Slize = 10, Team = 0, AxisMirrorFlag = true,},
				[11] = {Slize = 11, Team = 0,},
				[12] = {Slize = 12, Team = 0, AxisMirrorFlag = true,},
				[13] = {Slize =  0, Team = 0, Distance = 0.0, Mirror = {},},
				TeamBorderSlizes = {},
			},
		},
		[14] = {
			[ 7] = {
				NumberOfPlayers = 7, NumberOfTeams = 7, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {3, 5, 7, 9, 11, 13},},
				[ 2] = {Slize =  1, Distance = distance, Mirror = {4, 6, 8, 10, 12, 14},},
				[ 3] = {Slize =  3, AxisMirrorFlag = true,},
				[ 4] = {Slize =  3, AxisMirrorFlag = true, Distance = distance,},
				[ 5] = {Slize =  5,},
				[ 6] = {Slize =  5, Distance = distance,},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  7, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  9,},
				[10] = {Slize =  9, Distance = distance,},
				[11] = {Slize = 11, AxisMirrorFlag = true,},
				[12] = {Slize = 11, AxisMirrorFlag = true, Distance = distance,},
				[13] = {Slize = 13,},
				[14] = {Slize = 13, Distance = distance,},
				TeamBorderSlizes = {0, 2, 4, 6, 8, 10, 12},
			},
			[14] = {
				NumberOfPlayers = 14, NumberOfTeams = 0, EqualTeams = true,
				[ 1] = {Slize =  1, Team = 0, Mirror = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},},
				[ 2] = {Slize =  2, Team = 0, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3, Team = 0,},
				[ 4] = {Slize =  4, Team = 0, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5, Team = 0,},
				[ 6] = {Slize =  6, Team = 0, AxisMirrorFlag = true,},
				[ 7] = {Slize =  7, Team = 0,},
				[ 8] = {Slize =  8, Team = 0, AxisMirrorFlag = true,},
				[ 9] = {Slize =  9, Team = 0,},
				[10] = {Slize = 10, Team = 0, AxisMirrorFlag = true,},
				[11] = {Slize = 11, Team = 0,},
				[12] = {Slize = 12, Team = 0, AxisMirrorFlag = true,},
				[13] = {Slize =  0, Team = 0, Distance = 0.3, Mirror = {14},},
				[14] = {Slize =  6, Team = 0, Distance = 0.3,},
				TeamBorderSlizes = {},
			},
		},
		[15] = {
			[ 3] = {
				NumberOfPlayers = 9, NumberOfTeams = 3, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {3, 4, 6, 8, 9, 11, 13, 14},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  1, Distance = distance, Mirror = {2, 5, 7, 10, 12, 15},},
				[ 5] = {Slize =  3, Distance = distance,},
				[ 6] = {Slize =  5, AxisMirrorFlag = true,},
				[ 7] = {Slize =  6,},
				[ 8] = {Slize =  7, AxisMirrorFlag = true,},
				[ 9] = {Slize =  5, AxisMirrorFlag = true, Distance = distance,},
				[10] = {Slize =  7, AxisMirrorFlag = true, Distance = distance,},
				[11] = {Slize =  9,},
				[12] = {Slize = 10, AxisMirrorFlag = true,},
				[13] = {Slize = 11,},
				[14] = {Slize =  9, Distance = distance,},
				[15] = {Slize = 11, Distance = distance,},
				TeamBorderSlizes = {0, 4, 8},
			},
			[ 5] = {
				NumberOfPlayers = 10, NumberOfTeams = 5, EqualTeams = true,
				[ 1] = {Slize =    1, Mirror = {2, 4, 5, 7, 8, 10, 11, 13, 14},},
				[ 2] = {Slize =    2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  1.5, Distance = distance, Mirror = {6, 9, 12, 15},},
				[ 4] = {Slize =    4,},
				[ 5] = {Slize =    5, AxisMirrorFlag = true,},
				[ 6] = {Slize =  4.5, Distance = distance,},
				[ 7] = {Slize =    7,},
				[ 8] = {Slize =    8, AxisMirrorFlag = true,},
				[ 9] = {Slize =  7.5, Distance = distance,},
				[10] = {Slize =   10,},
				[11] = {Slize =   11, AxisMirrorFlag = true,},
				[12] = {Slize = 10.5, Distance = distance,},
				[13] = {Slize =   13,},
				[14] = {Slize =   14, AxisMirrorFlag = true,},
				[15] = {Slize = 13.5, Distance = distance,},
				TeamBorderSlizes = {0, 3, 6, 9, 12},
			},
			[15] = {
				NumberOfPlayers = 15, NumberOfTeams = 0, EqualTeams = true,
				[ 1] = {Slize =  1, Team = 0, Mirror = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},},
				[ 2] = {Slize =  2, Team = 0, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3, Team = 0,},
				[ 4] = {Slize =  4, Team = 0, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5, Team = 0,},
				[ 6] = {Slize =  6, Team = 0, AxisMirrorFlag = true,},
				[ 7] = {Slize =  7, Team = 0,},
				[ 8] = {Slize =  8, Team = 0, AxisMirrorFlag = true,},
				[ 9] = {Slize =  9, Team = 0,},
				[10] = {Slize = 10, Team = 0, AxisMirrorFlag = true,},
				[11] = {Slize = 11, Team = 0,},
				[12] = {Slize = 12, Team = 0, AxisMirrorFlag = true,},
				[13] = {Slize =  0, Team = 0, Distance = 0.3, Mirror = {14, 15},},
				[14] = {Slize =  5, Team = 0, Distance = 0.3, AxisMirrorFlag = true,},
				[15] = {Slize =  7, Team = 0, Distance = 0.3, AxisMirrorFlag = true,},
				TeamBorderSlizes = {},
			},
		},
		[16] = {
			[ 2] = {
				NumberOfPlayers = 12, NumberOfTeams = 2, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {2, 3, 5, 6, 7, 9, 10, 11, 13, 14, 15},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  2, Distance = distance, Mirror = {8, 12, 16},},
				[ 5] = {Slize =  4, AxisMirrorFlag = true,},
				[ 6] = {Slize =  5,},
				[ 7] = {Slize =  6, AxisMirrorFlag = true,},
				[ 8] = {Slize =  5, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  8,},
				[10] = {Slize =  9, AxisMirrorFlag = true,},
				[11] = {Slize = 10,},
				[12] = {Slize =  9, Distance = distance,},
				[13] = {Slize = 11, AxisMirrorFlag = true,},
				[14] = {Slize = 12,},
				[15] = {Slize = 13, AxisMirrorFlag = true,},
				[16] = {Slize = 12, AxisMirrorFlag = true, Distance = distance,},
				TeamBorderSlizes = {0, 7},
			},
			[ 4] = {
				NumberOfPlayers = 12, NumberOfTeams = 4, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {2, 3, 5, 6, 7, 9, 10, 11, 13, 14, 15},},
				[ 2] = {Slize =  2, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3,},
				[ 4] = {Slize =  2, Distance = distance, Mirror = {8, 12, 16},},
				[ 5] = {Slize =  5, AxisMirrorFlag = true,},
				[ 6] = {Slize =  6,},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  6, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  9,},
				[10] = {Slize = 10, AxisMirrorFlag = true,},
				[11] = {Slize = 11,},
				[12] = {Slize = 10, Distance = distance,},
				[13] = {Slize = 13, AxisMirrorFlag = true,},
				[14] = {Slize = 14,},
				[15] = {Slize = 15, AxisMirrorFlag = true,},
				[16] = {Slize = 14, AxisMirrorFlag = true, Distance = distance,},
				TeamBorderSlizes = {0, 4, 8, 12},
			},
			[ 8] = {
				NumberOfPlayers = 8, NumberOfTeams = 8, EqualTeams = true,
				[ 1] = {Slize =  1, Mirror = {3, 5, 7, 9, 11, 13, 15},},
				[ 2] = {Slize =  1, Distance = distance, Mirror = {4, 6, 8, 10, 12, 14, 16},},
				[ 3] = {Slize =  3, AxisMirrorFlag = true,},
				[ 4] = {Slize =  3, AxisMirrorFlag = true, Distance = distance,},
				[ 5] = {Slize =  5,},
				[ 6] = {Slize =  5, Distance = distance,},
				[ 7] = {Slize =  7, AxisMirrorFlag = true,},
				[ 8] = {Slize =  7, AxisMirrorFlag = true, Distance = distance,},
				[ 9] = {Slize =  9,},
				[10] = {Slize =  9, Distance = distance,},
				[11] = {Slize = 11, AxisMirrorFlag = true,},
				[12] = {Slize = 11, AxisMirrorFlag = true, Distance = distance,},
				[13] = {Slize = 13,},
				[14] = {Slize = 13, Distance = distance,},
				[15] = {Slize = 15, AxisMirrorFlag = true,},
				[16] = {Slize = 15, AxisMirrorFlag = true, Distance = distance,},
				TeamBorderSlizes = {0, 2, 4, 6, 8, 10, 12, 14},
			},
			[16] = {
				NumberOfPlayers = 16, NumberOfTeams = 0, EqualTeams = true,
				[ 1] = {Slize =  1, Team = 0, Mirror = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},},
				[ 2] = {Slize =  2, Team = 0, AxisMirrorFlag = true,},
				[ 3] = {Slize =  3, Team = 0,},
				[ 4] = {Slize =  4, Team = 0, AxisMirrorFlag = true,},
				[ 5] = {Slize =  5, Team = 0,},
				[ 6] = {Slize =  6, Team = 0, AxisMirrorFlag = true,},
				[ 7] = {Slize =  7, Team = 0,},
				[ 8] = {Slize =  8, Team = 0, AxisMirrorFlag = true,},
				[ 9] = {Slize =  9, Team = 0,},
				[10] = {Slize = 10, Team = 0, AxisMirrorFlag = true,},
				[11] = {Slize = 11, Team = 0,},
				[12] = {Slize = 12, Team = 0, AxisMirrorFlag = true,},
				[13] = {Slize =  0, Team = 0, Distance = 0.3, Mirror = {14, 15, 16},},
				[14] = {Slize =  3, Team = 0, Distance = 0.3, AxisMirrorFlag = true,},
				[15] = {Slize =  6, Team = 0, Distance = 0.3,},
				[16] = {Slize =  9, Team = 0, Distance = 0.3, AxisMirrorFlag = true,},
				TeamBorderSlizes = {},
			},
		},
	}

	-- no team borders in big ffa
	if nteams < nplayers and nteams > 8 then
		nteams = 0
	end

	-- return special composition if it fits the setup
	if compositions[nplayers] then

		local composition = compositions[nplayers][nteams]

		if composition then

			-- set teams, but not for ffa
			if nteams > 0 then
				for player = 1, nplayers do
					composition[player].Team = _GenerationData.Players[player].Team
				end
			end

			return compositions[nplayers][nteams]
		end
	end

	local currentteam = 0
	local slize = 0
	local composition = {NumberOfPlayers = nplayers, NumberOfTeams = nteams, TeamBorderSlizes = {},}

	-- create default generic composition
	for player = 1, nplayers do

		-- teamborder gets it own slize
		if nteams > 0 and _GenerationData.Players[player].Team > currentteam then

			currentteam = _GenerationData.Players[player].Team
			table.insert(composition.TeamBorderSlizes, slize)

			slize = slize + 1
		end

		composition[player] = {Slize = slize, Team = currentteam, AxisMirrorFlag = math.mod(player, 2) == 0,}

		-- setup mirroring
		if _GenerationData.MirrorMap then
			if player == 1 then
				composition[player].Mirror = {}
			else
				table.insert(composition[1].Mirror, player)
			end
		end

		slize = slize + 1
	end

	return composition
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetNeutralStruct()
	return nil
	--[[{
		Childs = {
			-{
				Placement = {
					RelativY = 20,
				},
				Data = RMG.StructureSets.ClayPit,
			},
			{
				Placement = {
					RelativY = -20,
				},
				Data = RMG.StructureSets.StonePit,
			},
		},
	}]]
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.FillNeutralStruct(_GenerationData)
	-- for modding
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetPlayerStruct()
	return {
		Childs = {
			{
				Data = {
					Blocking = 18,
					Entities = {
						{Type = Entities.PB_Headquarters1, SkipDummy = true, Name = "HQP"},
						--{Type = Entities.PU_Serf, RelativX = -900, RelativY = -300, Rotation = 180,},
						--{Type = Entities.PU_Serf, RelativX = -900, RelativY = -100, Rotation = 180,},
						--{Type = Entities.PU_Serf, RelativX = -900, RelativY =  100, Rotation = 180,},
						--{Type = Entities.PU_Serf, RelativX = -900, RelativY =  300, Rotation = 180,},
					},
					TerrainHeights = {
					Area = 18,
					},
					TerrainTextures = {
						Area = {X = 10, Y = 10,},
						TextureList = "Road",
					},
				},
			},
		},
	}
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.FillPlayerStruct(_GenerationData)

	local resoff = _GenerationData.ResourceDistanceOffset
	local maxdist = _GenerationData.MaxStructureDistance

	local heightmin = -100
	local heightmax = 100

	local currentindex = 1

	-- village
	currentindex = RMG.AddResourcePitToPlayerStruct(1, "NeutralVillageCenter", 0, "", maxdist - 25, maxdist - 25, resoff, _GenerationData.TerrainBaseHeight, heightmin, heightmax, currentindex)
	RMG.StructureSets.PlayerStruct.Childs[2].Childs = {{Data = {Entities = {{Type = Entities.PB_VillageCenter1, SkipDummy = true}}}}}
	currentindex = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountVillageCenter - 1, "NeutralVillageCenter", 0, "", maxdist - 5, maxdist - 5, resoff, _GenerationData.TerrainBaseHeight, heightmin, heightmax, currentindex)

	-- village hall
	currentindex = RMG.AddResourcePitToPlayerStruct(_GenerationData.amountVillageHall, "NeutralVillageHall", 0, "", maxdist, maxdist + 5, resoff, _GenerationData.TerrainBaseHeight, heightmin, heightmax, currentindex)

	-- Lighthouse
	currentindex = RMG.AddResourcePitToPlayerStruct(_GenerationData.amountLighthouse, "NeutralLighthouse", 0, "", maxdist - 20, maxdist - 20, resoff, _GenerationData.ThresholdCoast, 0, heightmax, currentindex)

	local woodpileindexbuffer, possiblewoodpileindices = {}, {}

	heightmin = -200
	heightmax = 200

	-- clay
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountClayPit, "ClayPit", _GenerationData.AmountClayPile, "ClayPile", maxdist - 20, maxdist - 20, resoff, _GenerationData.ThresholdCoast, 0, heightmax, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	-- stone
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountStonePit, "StonePit", _GenerationData.AmountStonePile, "StonePile", maxdist - 15, maxdist - 15, resoff, _GenerationData.ThresholdHill, heightmin, 0, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	-- iron
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountIronPit, "IronPit", _GenerationData.AmountIronPile, "IronPile", maxdist - 5, maxdist - 5, resoff, _GenerationData.ThresholdHill, 0, heightmax, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	-- sulfur
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountSulfurPit, "SulfurPit", _GenerationData.AmountSulfurPile, "SulfurPile", maxdist - 0, maxdist, resoff, _GenerationData.ThresholdCoast, heightmin, 0, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	-- gold
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountGoldPit, "GoldPit", 0, nil, maxdist - 5, maxdist + 5, resoff, _GenerationData.ThresholdHill, 0, heightmax, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	-- silver
	currentindex, woodpileindexbuffer = RMG.AddResourcePitToPlayerStruct(_GenerationData.AmountSilverPit, "SilverPit", _GenerationData.AmountSilverPile, "SilverPile", maxdist + 5, maxdist + 15, resoff/2, _GenerationData.TerrainBaseHeight, heightmin, heightmax, currentindex)
	for _,v in ipairs(woodpileindexbuffer) do
		table.insert(possiblewoodpileindices, v)
	end

	currentindex = 0

	-- wood
	if table.getn(possiblewoodpileindices) == 0 then
		for i = 1, _GenerationData.AmountWoodPile do

			table.insert(RMG.StructureSets.PlayerStruct.Childs, {Placement = RMG.StructureSets.Placement.PileAtPit, Data = RMG.StructureSets.WoodPileExplored,})
		end
	else
		for i = 1, _GenerationData.AmountWoodPile do

			currentindex = currentindex + 1
			if currentindex > table.getn(possiblewoodpileindices) then
				currentindex = 1
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[possiblewoodpileindices[currentindex]].Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.WoodPileExplored,})
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AddResourcePitToPlayerStruct(_PitAmount, _PitType, _PileAmount, _PileType, _DistMin, _DistMax, _ResOff, _Noise, _NoiseMin, _NoiseMax, _Index)

	local possiblewoodpileindices = {}

	if _PitAmount > 0 then

		local pileamount, pileamountleft = math.floor(_PileAmount / _PitAmount), math.mod(_PileAmount, _PitAmount)

		for i = 1, _PitAmount do

			local dist = math.random(_DistMin, _DistMax)
			local noise = math.random (_NoiseMin, _NoiseMax)
			local child = {
				Placement = {
					AreaMin = dist - _ResOff,
					AreaMax = dist + _ResOff,
					Height = _Noise + noise,
					Grid = 4,
				},
				Data = RMG.StructureSets[_PitType],
				Childs = {},
			}
			local n = 1

			for j = n, pileamount do
				if j == 1 then
					table.insert(child.Childs, {Placement = RMG.StructureSets.Placement.PileAtPit, Data = RMG.StructureSets[_PileType], Childs = {},})
					table.insert(possiblewoodpileindices, _Index + i)
				else
					table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets[_PileType],})
				end
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs, child)
		end

		_Index = _Index + _PitAmount
	else
		local mainpileindex

		for i = 1, _PileAmount do
			if i == 1 then

				local dist = math.random(_DistMin, _DistMax)
				local noise = math.random(_NoiseMin, _NoiseMax)
				local child = {
					Placement = {
						AreaMin = dist - _ResOff,
						AreaMax = dist + _ResOff,
						Height = _Noise + noise,
					},
					Data = RMG.StructureSets[_PileType .. "Explored"],
					Childs = {},
				}
				table.insert(RMG.StructureSets.PlayerStruct.Childs, child)
				mainpileindex = table.getn(RMG.StructureSets.PlayerStruct.Childs)
			else
				table.insert(RMG.StructureSets.PlayerStruct.Childs[mainpileindex].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets[_PileType],})
			end
		end

		_Index = _Index + _PileAmount
	end

	return _Index, possiblewoodpileindices
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetPlayersAndTeams()
	return RMG.GetPlayerConfigByGDBData()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.FinalizeGenerationData(_GenerationData)

	-- set landscapeSet if not existing or key is valid
	if not _GenerationData.LandscapeSet or RMG.LandscapeSets[_GenerationData.LandscapeSetKey] then
		_GenerationData.LandscapeSet = RMG.LandscapeSets[_GenerationData.LandscapeSetKey]
	end

	_GenerationData.Structures = {-- level 0 = world
		Childs = {}, -- level 1
		Current = {
			Levels = {[0] = 1, [1] = 0}, -- 2nd is player to start with (set to 0 or 1)
			Players = {[0] = 0},
			Structs = {
				Placement = {
					X = 0,
					Y = 0,
				},
				Childs = {},
			},
		},
	}
	_GenerationData.PlayerStruct = RMG.StructureSets.PlayerStruct
	_GenerationData.NeutralStruct = RMG.StructureSets.NeutralStruct
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.StartGenerateMap(_GenerationData)

	--FixVillageCenters()

	RMG.FillNoiseTable(_GenerationData)
	RMG.FillPlayerLocationTable(_GenerationData)

	if _GenerationData.TeamBorderType == 2 then
		RMG.CreateFences(_GenerationData)
	elseif _GenerationData.TeamBorderType == 3 then
		RMG.InitRivers(_GenerationData)
		RMG.FillRiverLocationTable(_GenerationData)
		RMG.CreateRivers(_GenerationData)
		RMG.ApplyNoiseOverride(_GenerationData, RMG.BlockingTypes.River, math.min)
	end

	if _GenerationData.GenerateRoads then
		RMG.InitRoads(_GenerationData)
		RMG.FillRoadLocationTable(_GenerationData)
		RMG.CreateRoads(_GenerationData)
		RMG.ApplyNoiseOverride(_GenerationData, RMG.BlockingTypes.Road)
	end

	RMG.SetTerrainTextures(_GenerationData)

	if RMG.GenerateStructures(_GenerationData) or _GenerationData.DebugMode then
		RMG.SetTerrainHeights(_GenerationData)
		RMG.UpdateBlocking(_GenerationData)
		RMG.CreateEntities(_GenerationData)
		RMG.Finalize(_GenerationData)
		return true
	end

	return false
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GenerateMap()
	local generationData = RMG.InitGenerationData()
	RMG.CustomizeGenerationData(generationData)
	RMG.InitGenerationData2(generationData)
	RMG.CustomizeGenerationData2(generationData)
	RMG.FillStructs(generationData)
	RMG.FinalizeGenerationData(generationData)
	RMG.GenerationData = generationData
	return RMG.StartGenerateMap(generationData)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Noise Calculation
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.FillNoiseTable(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	local lerpRadius = maphalf - 16

	local heightnoise
	local vegetationnoise

	-- set heightnoise for map border
	local bordernoise

	if _GenerationData.TeamBorderType == 3 then -- river
		bordernoise = -0.5
	--elseif _GenerationData.TeamBorderType == 4 then -- mountain (WIP)
		--bordernoise = 0.75
	else
		bordernoise = _GenerationData.ThresholdRoad
	end

	local composition = _GenerationData.Composition

	-- if we need this once more, write this to RMG.GenerationData.Composition
	local currentteam = 0
	local slize = 0
	local slizes = {}
	local mirror = 0

	local mirroroffset = _GenerationData.MirrorOffset - _GenerationData.MirrorRadian / 2

	for player = 1, _GenerationData.NumberOfPlayers do

		-- TODO: not very modding compatible solution
		-- only for players on the outer ring
		if not composition[player].Distance then
			if composition[player].Team > currentteam then

				currentteam = composition[player].Team
				slizes[slize] = {T = currentteam} -- can also be true or 1 or whatever

				slize = slize + 1
			end

			slizes[slize] = {M = mirror}
			slize = slize + 1

			-- mirror every seccond player slize on the outer ring
			mirror = (1 - mirror)
		end
	end

	-- do the main grid
	for x = 0, mapsize, 2 do

		_GenerationData.TerrainNodes[x] = {}

		for y = 0, mapsize, 2 do

			local distance = math.sqrt((maphalf - x) ^ 2 + (maphalf - y) ^ 2)

			if distance < maphalf then

				local mx, my = x, y
				if _GenerationData.MirrorMap then

					local sourceindex, axismirrorflag = RMG.GetMirrorSlize(_GenerationData, x, y, maphalf, mirroroffset)
					local targetindex = 1

					-- is team border slize
					if slizes[sourceindex].T then

						-- first slize must be mirrored, if number of players on outer ring is odd
						if sourceindex == 0 and math.mod(composition.NumberOfPlayers, 2) ~= 0 then
							axismirrorflag = true
						end

						mx, my = RMG.MirrorNode(_GenerationData, mx, my, sourceindex * _GenerationData.MirrorRadian + mirroroffset, (sourceindex + 1) * _GenerationData.MirrorRadian + mirroroffset, axismirrorflag)
						sourceindex = sourceindex + 1
					end

					-- a check on slizes[sourceindex].M is not neccessary, since we always increased source index to a player slize and last valid slize is allways a player slize
					-- mirror every seccond player slize on the outer ring
					axismirrorflag = slizes[sourceindex].M == 1

					mx, my = RMG.MirrorNode(_GenerationData, mx, my, sourceindex * _GenerationData.MirrorRadian + mirroroffset, targetindex * _GenerationData.MirrorRadian, axismirrorflag)
				end

				heightnoise = RMG.GetSimplexNoise(4, mx, my, 0.5, _GenerationData.NoiseFactorXY)
				vegetationnoise = RMG.GetSimplexNoise(4, mx + mapsize, my, 0.5, _GenerationData.NoiseFactorXY * 2.35)

				-- modify heightnoise if close to map border
				if distance > lerpRadius then
					heightnoise = Lerp(bordernoise, heightnoise, (distance - lerpRadius) / 16)
				end

			else
				heightnoise = bordernoise
				vegetationnoise = 0
			end

			_GenerationData.TerrainNodes[x][y] = RMG.CreateTerrainNode(_GenerationData, x, y, heightnoise, vegetationnoise)
		end
	end

	-- not every node needs the expensive noise calculation, average values of neighboring nodes create no visible difference but are much faster
	for x = 1, mapsize, 2 do

		_GenerationData.TerrainNodes[x] = {}

		for y = 0, mapsize, 2 do

			heightnoise = (_GenerationData.TerrainNodes[x-1][y].HeightNoise + _GenerationData.TerrainNodes[x+1][y].HeightNoise) / 2
			vegetationnoise = (_GenerationData.TerrainNodes[x-1][y].VegetationNoise + _GenerationData.TerrainNodes[x+1][y].VegetationNoise) / 2

			_GenerationData.TerrainNodes[x][y] = RMG.CreateTerrainNode(_GenerationData, x, y, heightnoise, vegetationnoise)

		end
	end

	for x = 0, mapsize do
		for y = 1, mapsize, 2 do

			heightnoise = (_GenerationData.TerrainNodes[x][y-1].HeightNoise + _GenerationData.TerrainNodes[x][y+1].HeightNoise) / 2
			vegetationnoise = (_GenerationData.TerrainNodes[x][y-1].VegetationNoise + _GenerationData.TerrainNodes[x][y+1].VegetationNoise) / 2

			_GenerationData.TerrainNodes[x][y] = RMG.CreateTerrainNode(_GenerationData, x, y, heightnoise, vegetationnoise)

		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Noise Utility
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetSimplexNoise(_octaves, _x, _y, _persistence, _scale)

	local maxAmp = 0
	local amp = 1
	local freq = _scale
	local noise = 0

	--add successively smaller, higher-frequency terms
	for i = 1, _octaves do
		noise = noise + SimplexNoise.Noise2D(SimplexNoise.perm[i], _x * freq, _y * freq) * amp
		maxAmp = maxAmp + amp
		amp = amp * _persistence
		freq = freq * 2
	end

	--take the average value of the iterations
	noise = noise / maxAmp

	return noise
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateTerrainNode(_GenerationData, _x, _y, _heightnoise, _vegetaionnoise)

	return {X = _x, Y = _y, HeightNoise = _heightnoise, Height = RMG.GetTerrainHeightFromNoise(_GenerationData, _heightnoise), VegetationNoise = _vegetaionnoise, Blocking = 0}
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Player Locations
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.FillPlayerLocationTable(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2
	local distancetomiddle = math.min(maphalf - 30, maphalf * _GenerationData.PlayerDistanceToMiddle)

	_GenerationData.Players[0] = {X = maphalf, Y = maphalf, Id = 0, Team = 0}

	local nplayers = _GenerationData.NumberOfPlayers
	local slize = 0

	for p = 1, nplayers do

		local composition = _GenerationData.Composition[p]
		local delta, x, y, distance

		if _GenerationData.RandomPlayerPosition then
			delta = math.random(0, math.rad(360))
			distance = math.random(5, maphalf - 15)
		else
			delta = composition.Slize * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset
			distance = composition.Distance or distancetomiddle
		end

		x = distance * math.cos(delta) + maphalf
		y = distance * math.sin(delta) + maphalf

		if _GenerationData.RandomPlayerPosition then
			x, y = SnapToGrid(4, x, y)
		else
			x, y = RMG.FindBestPoint(_GenerationData, x, y, 8, 4)
		end

		_GenerationData.Players[p].X = x
		_GenerationData.Players[p].Y = y

		if composition.Mirror or not _GenerationData.MirrorMap then

			-- lookup table for player id
			table.insert(_GenerationData.Structures.Current.Players, p)

			-- actual structure must be continuous
			table.insert(_GenerationData.Structures.Childs,
				{
					Placement = {
						AbsolutX = x,
						AbsolutY = y,
					},
					Childs = {_GenerationData.PlayerStruct,},
				}
			)
		end

		slize = slize + 1
	end

	_GenerationData.Structures.Childs[0] = {
		Placement = {
			AbsolutX = 0,
			AbsolutY = 0,
		},
		Childs = {_GenerationData.NeutralStruct},
	}

	return true
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.MirrorPosition(_GenerationData, _x, _y, _sourceindex, _targetindex, _mirror)
	return RMG.Mirror(_GenerationData, _x, _y, _sourceindex, _targetindex, Logic.WorldGetSize(), _mirror)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.MirrorNode(_GenerationData, _x, _y, _sourceindex, _targetindex, _mirror)
	return RMG.Mirror(_GenerationData, _x, _y, _sourceindex, _targetindex, Logic.WorldGetSize() / 100, _mirror)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.Mirror(_GenerationData, _x, _y, _sourceindex, _targetindex, _mapsize, _mirror)

	local maphalf = _mapsize / 2
	local sourceradian = _sourceindex -- * _GenerationData.MirrorRadian
	local targetradian = _targetindex -- * _GenerationData.MirrorRadian

	-- allign position to map center as 0,0
	_x, _y = _x - maphalf, _y - maphalf
	local dist = math.sqrt(_x ^ 2 + _y ^ 2)

	-- point mirror
	_x, _y = RMG.GetMirrorPosition(dist, sourceradian, targetradian, math.atan2(_y, _x), maphalf, 0, _offset)

	if _mirror then --math.mod(_sourceindex - _targetindex, 2) ~= 0 then

		-- set mirror axis to middle of point mirrored area
		_x, _y = _x - maphalf, _y - maphalf
		sourceradian = targetradian + _GenerationData.MirrorRadian * 0.5
		targetradian = sourceradian + 180

		-- axis mirror
		_x, _y = RMG.GetMirrorPosition(dist, sourceradian, targetradian, math.atan2(_y, _x), maphalf, 1, _offset)
	end

	-- do not round the outcome
	--_x, _y = round(_x), round(_y)

	return _x, _y
end
----------------------------------------------------------------------------------------------------------------
-- this is a copy from MTT in rad not deg - but the params are switched somehow !?
function RMG.GetMirrorPosition(_Dist, _SourceRadian, _TargetRadian, _Radian, _Maphalf, _Mode, _Offset)

	if _Mode == 1 then
		_Radian = -(_Radian - _SourceRadian * 2)
	else
		_Radian = _TargetRadian + (_Radian - _SourceRadian)
	end

	local x = _Dist * math.cos(_Radian) + _Maphalf
	local y = _Dist * math.sin(_Radian) + _Maphalf

	return x, y
end
----------------------------------------------------------------------------------------------------------------
-- returns:
-- int: slize index, bool: radian lies in 2nd half of slize
function RMG.GetMirrorSlize(_GenerationData, _x, _y, _maphalf, _offset)

	local radian = math.atan2(_y - _maphalf, _x - _maphalf)

	if radian < 0 then
		radian = radian + math.rad(360)
	end

	local slize = math.floor((radian - _offset) / _GenerationData.MirrorRadian)

	if slize < 0 then
		slize = slize + _GenerationData.NumberOfSlizes
	elseif slize >= _GenerationData.NumberOfSlizes then
		slize = slize - _GenerationData.NumberOfSlizes
	end

	return slize, (radian - _offset) >= (slize + 0.5) * _GenerationData.MirrorRadian
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.FindBestPoint(_GenerationData, _x, _y, _dist, _grid, _heightnoise)

	_heightnoise = _heightnoise or 0
	_grid = _grid or 1
	_x, _y, _dist = SnapToGrid(_grid, _x, _y, _dist)

	local mapsize = Logic.WorldGetSize() / 100
	local px, py = _x, _y
	local noise = _GenerationData.TerrainNodes[_x][_y].HeightNoise

	for x = math.max(_x -_dist, 0), math.min(_x + _dist, mapsize), _grid do
		for y = math.max(_y - _dist, 0), math.min(_y + _dist, mapsize), _grid do

			if math.abs(_GenerationData.TerrainNodes[x][y].HeightNoise - _heightnoise) < math.abs(noise - _heightnoise) then

				noise = _GenerationData.TerrainNodes[x][y].HeightNoise
				px, py = x, y
			end
		end
	end

	return px, py
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Teamborders
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.CreateFences(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	-- circle radius
	local r = 50

	local currentTeam = 0

	local radea = {}
	local composition = _GenerationData.Composition

	-- create fence lines from circle radius to map border
	for _, slize in ipairs(composition.TeamBorderSlizes) do

		local delta = slize * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset

		table.insert(radea, delta)

		local x, y = (maphalf + 2) * math.cos(delta) + maphalf, (maphalf + 2) * math.sin(delta) + maphalf
		local offset = ((x >= 2 and y >= 2 and x <= mapsize and y <= mapsize) and 0) or 2

		for i = r + 2, maphalf - offset, 2 do
			local x = (i - 1) * math.cos(delta) + maphalf
			local y = (i - 1) * math.sin(delta) + maphalf

			Logic.CreateEntity(Entities["XD_WoodenFence0"..math.random(1, 8)], x * 100, y * 100, math.deg(delta), 0)
		end
	end
	--[[local slize = 0

	for player = 1, composition.NumberOfPlayers do

		local delta = slize * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset

		-- per player
		if _GenerationData.GateLayout == 2 then
			table.insert(radea, delta)
		end

		if _GenerationData.Players[player].Team > currentTeam then
			currentTeam = _GenerationData.Players[player].Team

			-- per team
			if _GenerationData.GateLayout == 1 then
				table.insert(radea, delta)
			end

			for i = r + 2, maphalf - 2, 2 do
				local x = (i - 1) * math.cos(delta) + maphalf
				local y = (i - 1) * math.sin(delta) + maphalf

				Logic.CreateEntity(Entities["XD_WoodenFence0"..math.random(1, 8)], x * 100, y * 100, math.deg(delta), 0)
			end

			slize = slize + 1
		end

		slize = slize + 1
	end]]

	local currentRadius = 1
	local a = math.rad(360) / ((math.pi * r * 2) / 2) -- 360° / (umfang / Zaunlänge)
	local b = radea[currentRadius + 1]
	local c = radea[currentRadius] -- should always be 0

	-- create fence circle
	for delta = 0, math.rad(360), a do

		if delta > b then
			currentRadius = currentRadius + 1
			c = b

			if currentRadius >= table.getn(radea) then
				b = radea[1] + math.rad(360)
			else
				b = radea[currentRadius + 1]
			end
		end

		-- difference
		-- defines the entry size: <= 2 = closed, 2.5 = small, 3 = medium, 4 = large, 6 = very large
		local d = (b - c) / _GenerationData.GateSize

		local x = r * math.cos(delta) + maphalf
		local y = r * math.sin(delta) + maphalf

		-- create fence or gate
		if delta > c + d and delta < b - d then

			-- leave gap or create gate
			--if EMS_CustomMapConfig.Peacetime > 0 then
				Logic.CreateEntity(Entities.XD_WoodenFence15, x * 100, y * 100, math.deg(delta) + 90, 0)
			--end

		else
			Logic.CreateEntity(Entities["XD_WoodenFence0"..math.random(1, 8)], x * 100, y * 100, math.deg(delta) + 90, 0)
		end
	end

	-- flatten middle
	r = r + 10
	local l = 10 -- lerp

	for x = -r - l, r + l do
		for y = -r - l, r + l do

			local distance = math.sqrt(x ^ 2 + y ^ 2)

			if distance < r + l then

				-- the lazy aproach ...
				local heightnoise = _GenerationData.TerrainNodes[maphalf + x][maphalf + y].HeightNoise
				local heightnoise2 = heightnoise / 1.8

				local vegetationnoise = _GenerationData.TerrainNodes[maphalf + x][maphalf + y].VegetationNoise + 1
				local vegetationnoise2 = vegetationnoise / 1.4 - 1

				if distance > r then

					heightnoise2 = Lerp(heightnoise, heightnoise2, (distance - r) / l)
					vegetationnoise2 = Lerp(vegetationnoise, vegetationnoise2, (distance - r) / l)
				end

				_GenerationData.TerrainNodes[maphalf + x][maphalf + y] = RMG.CreateTerrainNode(_GenerationData, x + maphalf, y + maphalf, heightnoise2, vegetationnoise2)
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SimpleNoiseOverride(_GenerationData, _x, _y, _innerrange, _outerrange, _targetheightnoise, _targetheightrange, _targetvegetationnoise, _targetvegetationrange, _overrideheightfunc, _offsetheight, _overridevegetationfunc, _offsetvegetation)

	_overrideheightfunc = _overrideheightfunc or function(_noise, _targetrange, _targetnoise)
		return _noise * _targetrange + _targetnoise
	end
	_overridevegetationfunc = _overridevegetationfunc or function(_noise, _targetrange, _targetnoise)
		return _noise * _targetrange + _targetnoise
	end

	local mapsize = Logic.WorldGetSize() / 100
	local x1, y1, x2, y2 = math.max(_x - _outerrange, 0), math.max(_y - _outerrange, 0), math.min(_x + _outerrange, mapsize), math.min(_y + _outerrange, mapsize)

	for x = x1, x2 do
		for y = y1, y2 do

			local distance = SimpleGetDistance(x, y, _x, _y)

			if distance < _outerrange then

				-- override height
				if _targetheightnoise then

					local heightnoise = _GenerationData.TerrainNodes[x][y].HeightNoise
					local heightnoiseoverride = _overrideheightfunc(heightnoise, _targetheightrange, _targetheightnoise, _offsetheight)

					if distance > _innerrange then
						heightnoiseoverride = Lerp(heightnoise, heightnoiseoverride, (distance - _innerrange) / (_outerrange - _innerrange))
					end

					_GenerationData.TerrainNodes[x][y].HeightNoise = heightnoiseoverride
					_GenerationData.TerrainNodes[x][y].Height = RMG.GetTerrainHeightFromNoise(_GenerationData, heightnoiseoverride)
				end

				-- override
				if _targetvegetationnoise then

					local vegetationnoise =  _GenerationData.TerrainNodes[x][y].VegetationNoise
					local vegetationnoiseoverride = _overridevegetationfunc(vegetationnoise, _targetvegetationrange, _targetvegetationnoise, _offsetvegetation)

					if distance > _innerrange then
						vegetationnoiseoverride = Lerp(vegetationnoise, vegetationnoiseoverride, (distance - _innerrange) / (_outerrange - _innerrange))
					end

					_GenerationData.TerrainNodes[x][y].VegetationNoise = vegetationnoiseoverride
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SimpleHeightOverride(_GenerationData, _x, _y, _innerrange, _outerrange, _targetheight)

	local mapsize = Logic.WorldGetSize() / 100
	local x1, y1, x2, y2 = math.max(_x - _outerrange, 0), math.max(_y - _outerrange, 0), math.min(_x + _outerrange, mapsize), math.min(_y + _outerrange, mapsize)

	for x = x1, x2 do
		for y = y1, y2 do

			local distance = SimpleGetDistance(x, y, _x, _y)

			if distance < _outerrange then

				local height = _GenerationData.TerrainNodes[x][y].Height
				local heightoverride = _targetheight

				if distance > _innerrange then
					heightoverride = Lerp(height, heightoverride, (distance - _innerrange) / (_outerrange - _innerrange))
				end

				_GenerationData.TerrainNodes[x][y].Height = heightoverride
			end
		end
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.InitRivers(_GenerationData)

	_GenerationData.Rivers = {}
	_GenerationData.Rivers.StartPoints = {} -- start points
	_GenerationData.Rivers.Paths = {} -- connections

	_GenerationData.Rivers.Nodes = {}
	_GenerationData.Rivers.MirrorRadea = {}
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.FillRiverLocationTable(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	local composition = _GenerationData.Composition

	-- find the points at the egde of the map between different teams
	for i, slize in ipairs(composition.TeamBorderSlizes) do

		local delta = slize * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset

		-- add mirror angles
		if _GenerationData.MirrorMap and delta ~= _GenerationData.MirrorOffset then

			table.insert(_GenerationData.Rivers.MirrorRadea, delta - _GenerationData.MirrorOffset)
		end

		if not _GenerationData.MirrorMap or i == 1 then

			local x = maphalf * math.cos(delta) + maphalf
			local y = maphalf * math.sin(delta) + maphalf

			-- dont use FindBestPoint here, since the river might not touch the map border then
			x, y = SnapToGrid(4, x, y)
			_GenerationData.Rivers.StartPoints[i] = {X = x, Y = y}

			-- start at the middle, since this is much cheaper due to negative side effects of water as map border
			_GenerationData.Rivers.Paths[i] = {_GenerationData.NumberOfTeams + 1, i}
		end
	end
	--[[local currentTeam = 0
	local teamIndex = 0
	local slize = 0

	for player = 1, _GenerationData.NumberOfPlayers do
		if _GenerationData.Players[player].Team > currentTeam then

			currentTeam = _GenerationData.Players[player].Team
			teamIndex = teamIndex + 1

			local delta = (slize) * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset

			-- add mirror angles
			if _GenerationData.MirrorMap and delta ~= _GenerationData.MirrorOffset then

				table.insert(_GenerationData.Rivers.MirrorRadea, delta - _GenerationData.MirrorOffset)
			end

			if not _GenerationData.MirrorMap or teamIndex == 1 then

				local x = maphalf * math.cos(delta) + maphalf
				local y = maphalf * math.sin(delta) + maphalf

				-- dont use FindBestPoint here, since the river might not touch the map border then
				x, y = SnapToGrid(4, x, y)
				_GenerationData.Rivers.StartPoints[teamIndex] = {X = x, Y = y}

				-- start at the middle, since this is much cheaper due to negative side effects of water as map border
				_GenerationData.Rivers.Paths[teamIndex] = {_GenerationData.NumberOfTeams + 1, teamIndex}
			end

			slize = slize + 1
		end

		slize = slize + 1
	end]]

	-- add the central point in the middle of the map, where all rivers merge together
	-- must be the exact center if rivers will be mirrored
	local x, y = maphalf, maphalf

	if not _GenerationData.MirrorMap then
		x, y = RMG.FindBestPoint(_GenerationData, maphalf, maphalf, 16, 4, -1)
	end

	_GenerationData.Rivers.StartPoints[_GenerationData.NumberOfTeams + 1] = {X = x, Y = y}
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateRivers(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	for i = 1, table.getn(_GenerationData.Rivers.Paths) do

		local a, b = _GenerationData.Rivers.Paths[i][1], _GenerationData.Rivers.Paths[i][2]
		local x1, y1, x2, y2 = _GenerationData.Rivers.StartPoints[a].X, _GenerationData.Rivers.StartPoints[a].Y, _GenerationData.Rivers.StartPoints[b].X, _GenerationData.Rivers.StartPoints[b].Y

		local river = AStar.FindPath(_GenerationData.TerrainNodes[x1][y1], _GenerationData.TerrainNodes[x2][y2], _GenerationData.TerrainNodes, RMG.AStar_GetNeighborNodes_River, RMG.AStar_GetPathCost_River)

		if river then

			local riverheight = _GenerationData.TerrainBaseHeight - 663

			local currNode = river[1]
			RMG.AddRiverNodes(_GenerationData, currNode.X, currNode.Y, riverheight)

 			local prevNode = currNode

			for j = 2, table.getn(river) do

				currNode = river[j]
				RMG.AddRiverNodes(_GenerationData, currNode.X, currNode.Y, riverheight)

				-- add the middle between two nodes so rivers and roads do not miss each other with two diagonals
				RMG.AddRiverNodes(_GenerationData, (currNode.X + prevNode.X) / 2, (currNode.Y + prevNode.Y) / 2)

				prevNode = currNode
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- _height, _heightnoise, _vegetaionnoise are optional
function RMG.AddRiverNodes(_GenerationData, _x, _y, _height, _heightnoise, _vegetaionnoise)

	RMG.AddRiverNode(_GenerationData, _x, _y, 0, _height, _heightnoise, _vegetaionnoise)

	for _, targetradian in ipairs(_GenerationData.Rivers.MirrorRadea) do
		RMG.AddRiverNode(_GenerationData, _x, _y, targetradian, _height, _heightnoise, _vegetaionnoise)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AddRiverNode(_GenerationData, _x, _y, _targetradian, _height, _heightnoise, _vegetaionnoise)

	local maphalf = Logic.WorldGetSize() / 200

	_x, _y = _x - maphalf, _y - maphalf
	_x, _y = RMG.GetMirrorPosition(math.sqrt(_x ^ 2 + _y ^ 2), 0, _targetradian, math.atan2(_y, _x), maphalf, 0)
	_x, _y = round(_x), round(_y)

	table.insert(_GenerationData.Rivers.Nodes, {X = _x, Y = _y})

	if _height then
		RMG.SetNoiseOverride(_GenerationData, _x, _y, 20, 4, _height, _heightnoise, _vegetaionnoise)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.InitRoads(_GenerationData)

	_GenerationData.Roads = {}
	_GenerationData.Roads.StartPoints = {}
	_GenerationData.Roads.Paths = {}
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO: add road system to composition
function RMG.FillRoadLocationTable(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2
	local distance = math.min(maphalf - 50, maphalf * 0.8)
	local delta, x, y

	-- check for specific case with only 2 players on 2 teams
	if _GenerationData.NumberOfPlayers == 2 and _GenerationData.NumberOfTeams == 2 then

		_GenerationData.Roads.Paths = {{1, 2}, {3, 1}, {4, 1}, {3, 2}, {4, 2}} -- from player 1 to player 2 and from imaginary player 3 and 4 to each player 1 and 2

		_GenerationData.Roads.StartPoints[1] = _GenerationData.Players[1]
		_GenerationData.Roads.StartPoints[2] = _GenerationData.Players[2]

		delta = _GenerationData.MirrorRadian / 2 -- 90°
		x = distance * math.cos(delta) + maphalf
		y = distance * math.sin(delta) + maphalf

		x, y = RMG.FindBestPoint(_GenerationData, x, y, 16, 4, 0)
		_GenerationData.Roads.StartPoints[3] = {X = x, Y = y}

		delta = delta * 3 -- 270°
		x = distance * math.cos(delta) + maphalf
		y = distance * math.sin(delta) + maphalf

		x, y = RMG.FindBestPoint(_GenerationData, x, y, 16, 4, 0)
		_GenerationData.Roads.StartPoints[4] = {X = x, Y = y}

	-- otherwise use the generic system
	else

		-- players
		for p = 1, _GenerationData.NumberOfPlayers do

			_GenerationData.Roads.StartPoints[p] = _GenerationData.Players[p]
			--table.insert(_GenerationData.Roads.Paths, {_GenerationData.NumberOfPlayers + 1, p}) -- from middle to player is faster than player to middle when rivers are generated, without its equal fast

			if p < _GenerationData.NumberOfPlayers then

				table.insert(_GenerationData.Roads.Paths, {p, p + 1})
			else

				table.insert(_GenerationData.Roads.Paths, {1, p})
			end
		end

		-- center of map
		if _GenerationData.MirrorMap then
			x, y = maphalf, maphalf
		else
			x, y = RMG.FindBestPoint(_GenerationData, maphalf, maphalf, 16, 4, 0)
		end

		_GenerationData.Roads.StartPoints[_GenerationData.NumberOfPlayers + 1] = {X = x, Y = y}
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateRoads(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local bridges = {}

	for i = 1, table.getn(_GenerationData.Roads.Paths) do

		local a, b = _GenerationData.Roads.Paths[i][1], _GenerationData.Roads.Paths[i][2]
		local x1, y1, x2, y2 = _GenerationData.Roads.StartPoints[a].X, _GenerationData.Roads.StartPoints[a].Y, _GenerationData.Roads.StartPoints[b].X, _GenerationData.Roads.StartPoints[b].Y

		local road = AStar.FindPath (_GenerationData.TerrainNodes[x1][y1], _GenerationData.TerrainNodes[x2][y2], _GenerationData.TerrainNodes, RMG.AStar_GetNeighborNodes_Road, RMG.AStar_GetPathCost_Road)

		if road then

			local nodeA, nodeB
			local n = 0

			for j = 2, table.getn(road) do

				if n ~= 0 then
					break
				end

				nodeA = road[j]
				nodeB = road[j-1]

				x1, y1, x2, y2 = nodeA.X, nodeA.Y, (nodeA.X + nodeB.X) / 2, (nodeA.Y + nodeB.Y) / 2

				if _GenerationData.Rivers then

					for k = 1, table.getn(_GenerationData.Rivers.Nodes) do

						nodeB = _GenerationData.Rivers.Nodes[k]

						if (x1 == nodeB.X or x2 == nodeB.X) and (y1 == nodeB.Y or y2 == nodeB.Y) then

							n = j
							--x, y = nodeA.X, nodeA.Y
							break
						end
					end
				end
			end

			-- reroute road to bridge entry points
			if n ~= 0 then

				nodeB = road[math.max(n - 4, 1)]
				local nodeC = road[math.min(n + 4, table.getn(road))]

				local x, y = math.abs(nodeB.X - nodeC.X), math.abs(nodeB.Y - nodeC.Y)
				local b, c = math.max(n - 8, 1), math.min(n + 8, table.getn(road))

				local nodeB = road[b]
				local nodeC = road[c]

				local ax, ay, bridge

				if x > y then

					ax, ay = 16, 0
					bridge = {Placement = {AbsolutX = nodeA.X, AbsolutY = nodeA.Y,}, Data = RMG.StructureSets.Bridge1,}
				else

					ax, ay = 0, 16
					bridge = {Placement = {AbsolutX = nodeA.X, AbsolutY = nodeA.Y,}, Data = RMG.StructureSets.Bridge2,}
				end

				local isblocked = false

				for _,v in pairs(bridges) do

					if IsInRange(v.Placement.AbsolutX, v.Placement.AbsolutY, bridge.Placement.AbsolutX, bridge.Placement.AbsolutY, 28.14) then -- sqrt(20 ^ 2 + 20 ^ 2) = 28.28
						isblocked = true
					end
				end

				if not isblocked then
					table.insert(bridges, bridge)
				end
				--table.insert(_GenerationData.Structures.Childs[0].Childs, bridge)
			end

				--[[x, y = nodeA.X - ax, nodeA.Y - ay

				if (x - nodeB.X) ^ 2 + (y - nodeB.Y) ^ 2 > (x - nodeC.X) ^ 2 + (y - nodeC.Y) ^ 2 then
					nodeA = nodeB -- save
					nodeB = nodeC -- switch
					nodeC = nodeA -- nodeB
					--local a = b
					--b = c
					--c = a
				end

				-- now B is the lower node
				local raod1 = AStar.FindPath (_GenerationData.TerrainNodes[x][y], _GenerationData.TerrainNodes[nodeB.X][nodeB.Y], _GenerationData.TerrainNodes, RMG.AStar_GetNeighborNodes_Road, RMG.AStar_GetPathCost_Road)

				x, y = x + ax * 2, y + ay * 2

				local road2 = AStar.FindPath (_GenerationData.TerrainNodes[x][y], _GenerationData.TerrainNodes[nodeC.X][nodeC.Y], _GenerationData.TerrainNodes, RMG.AStar_GetNeighborNodes_Road, RMG.AStar_GetPathCost_Road)
			end

			for i = c, b, -1 do
				table.remove(road, i)
			end

			for i = 1, table.getn(road1) do
				table.insert(road, {X = road1[i].X, Y = road1[i].Y})
			end

			for i = 1, table.getn(road2) do
				table.insert(road, {X = road2[i].X, Y = road2[i].Y})
			end]]

			local currNode = road[1]

			local height = _GenerationData.TerrainNodes[currNode.X][currNode.Y].Height - 100
			local heightnoise = _GenerationData.ThresholdRoad

			if _GenerationData.TerrainNodes[currNode.X][currNode.Y].Blocking ~= RMG.BlockingTypes.River then
				RMG.SetNoiseOverride(_GenerationData, currNode.X, currNode.Y, 6, 1, height, heightnoise)
			end

			local prevNode = currNode

			for j = 2, table.getn(road) do

				currNode = road[j]

				-- same as for rivers we need at least the middle node to make shure river and road dont miss each other at a diagonal
				for k = 4, 1, -1 do

					local x, y = Lerp(currNode.X, prevNode.X, k / 4), Lerp(currNode.Y, prevNode.Y, k / 4)
					height = _GenerationData.TerrainNodes[x][y].Height - 100

					-- do not override rivers
					if _GenerationData.TerrainNodes[x][y].Blocking ~= RMG.BlockingTypes.River then
						RMG.SetNoiseOverride(_GenerationData, x, y, 6, 1, height, heightnoise)
					end
				end

				prevNode = currNode
			end
		end
	end

	for _,v in pairs(bridges) do
		table.insert(_GenerationData.Structures.Childs[0].Childs, v)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- _height, _heightnoise, _vegetaionnoise are optional
function RMG.SetNoiseOverride(_GenerationData, _nodeX, _nodeY, _radius, _lerpRadius, _height, _heightnoise, _vegetationnoise)

	local mapsize = Logic.WorldGetSize() / 100

	local x1, x2, y1, y2 = math.max(_nodeX - _radius , 0), math.min(_nodeX + _radius, mapsize), math.max(_nodeY - _radius, 0), math.min(_nodeY + _radius, mapsize)
	local radiusSq = _radius ^ 2

	for x = x1, x2 do
		for y = y1, y2 do
			if IsInRangeSq(x, y, _nodeX, _nodeY, radiusSq) then

				local dist = SimpleGetDistance(x, y, _nodeX, _nodeY)
				local factor = 0 -- 1 = old, 0 = new

				-- is outside of inner radius
				if dist > _lerpRadius then
					factor = (dist - _lerpRadius) / (_radius - _lerpRadius)
				end

				local override = _GenerationData.TerrainNodes[x][y].Override

				if override then
					_GenerationData.TerrainNodes[x][y].Override.Factor = math.min(override.Factor, factor)
				else
					_GenerationData.TerrainNodes[x][y].Override = {HeightNoise = _heightnoise, Height = _height, VegetationNoise = _vegetationnoise, Factor = factor}
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.ApplyNoiseOverride(_GenerationData, _blockingtype, _heightfunc, _heightnoisefunc, _vegetationnoisefunc)

	local mapsize = Logic.WorldGetSize() / 100
	local keys = {"Height", "HeightNoise", "VegetationNoise"}
	local funcs = {_heightfunc, _heightnoisefunc, _vegetationnoisefunc}

	for x = 0, mapsize do
		for y = 0, mapsize do

			local override = _GenerationData.TerrainNodes[x][y].Override

			if override then

				local updateblocking = false

				for i, key in ipairs(keys) do
					if override[key] then

						local value = CurvedLerp(_GenerationData.TerrainNodes[x][y][key], override[key], override.Factor)

						if funcs[i] then
							value = funcs[i](_GenerationData.TerrainNodes[x][y][key], value)
						end

						_GenerationData.TerrainNodes[x][y][key] = value
						updateblocking = true
					end
				end

				-- set blocking if weight is more than 50%
				-- note that factor is inverted
				if updateblocking and override.Factor < 0.5 then
					_GenerationData.TerrainNodes[x][y].Blocking = _blockingtype
				end

				_GenerationData.TerrainNodes[x][y].Override = nil
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- AStar Utility
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetNeighborNodes(_thisnode, _nodes, _steps)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2
	local neighbors = {}
	local node
	local x1, x2, y1, y2 = math.max(_thisnode.X - _steps, 0), math.min(_thisnode.X + _steps, mapsize), math.max(_thisnode.Y - _steps, 0), math.min(_thisnode.Y + _steps, mapsize)

	for x = x1, x2, _steps do
		for y = y1, y2, _steps do
			node = _nodes[x][y]
			if (node.X ~= _thisnode.X or node.Y ~= _thisnode.Y) and IsValidMapIndex(0, node.X, node.Y) then
				table.insert (neighbors, node)
			end
		end
	end

	return neighbors
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetNeighborNodes_Road(_thisnode, _nodes)
	return RMG.AStar_GetNeighborNodes(_thisnode, _nodes, 4)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetNeighborNodes_River(_thisnode, _nodes)
	return RMG.AStar_GetNeighborNodes(_thisnode, _nodes, 4)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- fast distance calculation for neighboring nodes
 -- if x or y values are equal, subtraction is zero resultig in multiplication with zero so dist = 1 + 0 * 0.414 = 1.0
 -- where if both are not equal, the result is eather 1 or -1 which results in 1 so dist = 1 + 1 * 0.414 = 1.414
 -- river nodes have a higher distance since only every 4th node is used so 4 + 16 * 0.104 = 5.657 = 4 * 1.414
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetPathDist(_nodeA, _nodeB, _straight, _diagonalfraction)
	return _straight + math.abs((_nodeA.X - _nodeB.X) * (_nodeA.Y - _nodeB.Y)) * _diagonalfraction
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetPathCost_Road (_nodeA, _nodeB)
	 -- adjust factor by needs, be carefull this has heavy impact on performance
	 -- higher factor = better result but slower vs lower factor = worse result but faster
	local cost = math.abs((_nodeA.Height + _nodeB.Height) / 2 - RMG.GenerationData.TerrainBaseHeight) * 0.04
	return RMG.AStar_GetPathDist (_nodeA, _nodeB, 1.0, 1.41421353816986083984375) * cost
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.AStar_GetPathCost_River (_nodeA, _nodeB)
	 -- adjust factor by needs, be carefull this has heavy impact on performance
	 -- higher factor = better result but slower vs lower factor = worse result but faster
	local cost = ((_nodeA.HeightNoise + _nodeB.HeightNoise) / 4 + 0.5) * 2.5
	return RMG.AStar_GetPathDist (_nodeA, _nodeB, 4.0, 0.103553391993045806884765625) * cost
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Set Terrain Textures
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.SetTerrainTextures(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	-- set terrain textures
 	for x = 0, mapsize, 4 do
		for y = 0, mapsize, 4 do
			if math.sqrt((x - maphalf) ^ 2 + (y - maphalf) ^ 2) < maphalf then

				RMG.SetRandomTexture(x, y, RMG.GetTerrainNodeLandscapeSetData(_GenerationData, _GenerationData.TerrainNodes[x][y], "Textures", true))
			end
		end
	end

	-- set water textures
	local watertype = _GenerationData.LandscapeSet.Water

	if watertype then
		Logic.WaterSetType(0, 0, mapsize, mapsize, watertype)
	end

	-- set water height
	Logic.WaterSetAbsoluteHeight(0, 0, mapsize, mapsize, _GenerationData.WaterBaseHeight)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetRandomTexture(_nodeX, _nodeY, _textures)

	if _textures then

		Logic.SetTerrainNodeType(_nodeX, _nodeY, RMG.GetRandomValueFromTable(_textures))
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetRandomVertexColor(_nodeX, _nodeY, _colors)

	if _colors then

		local color = RMG.GetRandomValueFromTable(_colors)
		Logic.SetTerrainVertexColor(_nodeX, _nodeY, color.R, color.G, color.B)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetTerrainNodeLandscapeSetData(_GenerationData, _terrainnode, _tablekey, _usedefaults)

	local heightkey, vegetationkey = RMG.GetBiomeKeys(_GenerationData, _terrainnode)

	return RMG.GetLandscapeSetData(_GenerationData, _tablekey, heightkey, vegetationkey, _usedefaults)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- generic getter function for landscape set data
-- note that the output can still be nil
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetLandscapeSetData(_GenerationData, _tablekey, _heightkey, _vegetationkey, _usedefaults)

	local datatable = _GenerationData.LandscapeSet[_tablekey]

	-- no landscapset is defined
	if not datatable then

		if not _usedefaults then
			return
		end

		-- use default landscape set
		datatable = RMG.LandscapeSets.Normal[_tablekey]
	end

	local heighttable = datatable[_heightkey]

	-- landscape set is missing requested height table
	if not heighttable then

		if not _usedefaults then
			return
		end

		-- try with default height table
		heighttable = datatable["Normal"]

		if not heighttable then

			if not _usedefaults then
				return
			end

			-- use default landscape set
			heighttable = RMG.LandscapeSets.Normal[_tablekey]
		end
	end

	local vegetationtable = heighttable[_vegetationkey]
	-- heighttable is mission requested vegetation table
	if not vegetationtable then

		-- use default vegetation key, no matter what
		vegetationtable = heighttable["Normal"]
	end

	return vegetationtable
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetRandomValueFromTable(_table)
	return GetRandomValueFromTable(GetRandomValueFromTable(_table.Sets or _table, _table.Weights))
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function GetRandomValueFromTable(_table, _weights)

	if type(_table) == "table" then

		if type(_weights) == "table" then

			local totalweight = 0

			for i = 1, table.getn(_table) do
				totalweight = totalweight + (_weights[i] or 1)
			end

			local randomvalue = math.random(1, totalweight)
			local weight = 0

			for i = 1, table.getn(_table) do

				weight = weight + (_weights[i] or 1)

				if weight >= randomvalue then
					return _table[i]
				end
			end
		end

		return _table[math.random(1, table.getn(_table))]
	end

	return _table
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 -- this way, we can use the same biome logic for terrain and entities
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetBiomeKeys(_GenerationData, _terrainnode)

	return RMG.GetHeightKey(_GenerationData, _terrainnode), RMG.GetVegetationKey(_GenerationData, _terrainnode)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetHeightKey(_GenerationData, _terrainnode)

	-- height noise equals threshold road indicates a road, no matter the actual height
	local heightnoise = _terrainnode.HeightNoise

	if heightnoise == _GenerationData.ThresholdRoad then
		return "Road"
	end

	-- otherwise get key from terrain height
	local height= _terrainnode.Height
	local heightkey = "Normal"

	if height > _GenerationData.ThresholdPike then
		heightkey = "Pike"
	elseif height > _GenerationData.ThresholdMountain then
		heightkey = "Mountain"
	elseif height > _GenerationData.ThresholdHill then
		heightkey = "Hill"
	elseif height < _GenerationData.ThresholdSea then
		heightkey = "Sea"
	elseif height < _GenerationData.ThresholdLake then
		heightkey = "Lake"
	elseif height < _GenerationData.ThresholdCoast then
		heightkey = "Coast"
	end

	return heightkey
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetVegetationKey(_GenerationData, _terrainnode)

	local vegetationnoise = _terrainnode.VegetationNoise
	local vegetationkey = "Medium"

	if vegetationnoise > _GenerationData.ThresholdVeryStrongGroth then
		vegetationkey = "VeryStrong"
	elseif vegetationnoise > _GenerationData.ThresholdStrongGroth then
		vegetationkey = "Strong"
	elseif vegetationnoise < _GenerationData.ThresholdVeryWeakGroth then
		vegetationkey = "VeryWeak"
	elseif vegetationnoise < _GenerationData.ThresholdWeakGroth then
		vegetationkey = "Weak"
	end

	return vegetationkey
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Set Terrain Heights
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.SetTerrainHeights(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	local maphalf = mapsize / 2

	for x = 0, mapsize do
		for y = 0, mapsize do

			Logic.SetTerrainNodeHeight(x, y, _GenerationData.TerrainNodes[x][y].Height)

			-- this is more a textures thing but since textures use a 4 stepped loop we do it here
			if math.sqrt((x - maphalf) ^ 2 + (y - maphalf) ^ 2) < maphalf then

				RMG.SetRandomVertexColor(x, y, RMG.GetTerrainNodeLandscapeSetData(_GenerationData, _GenerationData.TerrainNodes[x][y], "VertexColors"))
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetTerrainHeightFromNoise(_GenerationData, _noise)

	-- experimental
	--[[if _noise > 0 then
		_noise = math.sin((_noise - 1) * math.pi / 2) + 1
	else
		_noise = math.sin((_noise + 0.5) * math.pi) / 2 - 0.5
	end]]

	--[[if _noise < 0 then --_GenerationData.ThresholdRoad then
		_noise = math.min(_noise - _GenerationData.ThresholdLowFlatland, 0) / (1 + _GenerationData.ThresholdLowFlatland)
	else
		_noise = math.max(math.min(_noise, _GenerationData.ThresholdPlateau) - _GenerationData.ThresholdFlatland, 0) / (1 - _GenerationData.ThresholdFlatland) * (2 - _GenerationData.ThresholdPlateau)
	end]]

	local noise = (_noise * 1.2) ^ 2

	if _noise < 0.0 then
		noise = -noise
	end

	return math.max(noise * _GenerationData.NoiseFactorZ + _GenerationData.TerrainBaseHeight, 0)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Generate Structures
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GenerateStructures(_GenerationData)

	local success = false
	local failure = false

	while not success and not failure do
		success, failure = RMG.GenerateStructure(_GenerationData)
	end

	if failure then
		GUI.AddStaticNote("@color:255,0,0,255 RMG ERROR: Auf der Karte ist nicht genug Platz um alle Strukturen platzieren zu können. @cr @color:255,255,255 Ändert den Seed oder verwendet eine größere Karte.")-- oder verringert die Anzahl an Strukturen.")
		return false
	end

	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GenerateStructure(_GenerationData)

	local struct = RMG.GetCurrentStruct(_GenerationData)
	local parent = RMG.GetCurrentParentData(_GenerationData)

	local placement, x, y, forcePlacement

	if not struct.Placement then

		x, y = parent.X, parent.Y
		forcePlacement = true
	else
		placement = struct.Placement

		if placement.AbsolutX then

			x, y = placement.AbsolutX, placement.AbsolutY
			forcePlacement = true

		elseif placement.RelativX then

			x, y = placement.RelativX + parent.X, placement.RelativY + parent.Y
			forcePlacement = true
		else

			forcePlacement = false
		end
	end

	local blocking = 0

	if struct.Data and struct.Data.Blocking then

		blocking = struct.Data.Blocking
	end

	local node = false

	if not forcePlacement then

		local areamax = placement.AreaMax

		if placement.AreaMax then

			node = RMG.GetRandomPosition(_GenerationData, struct, parent, placement.Grid)

			if node then
				x, y = node.X, node.Y
			end

		else
			x, y = parent.X, parent.Y
			forcePlacement = true
		end
	end

	if forcePlacement or node then

		local playerindex = RMG.StructGetCurrentPlayer(_GenerationData)

		if playerindex > 0 and _GenerationData.MirrorMap then

			local composition = _GenerationData.Composition
			local player = composition[playerindex]

			if player.Mirror then

				-- mirror offset + 0.5 would be source of player 1, but we need it 0 based and this is an optimized version to write
				local offset = -0.5 * _GenerationData.MirrorRadian + _GenerationData.MirrorOffset
				local sourceradian = player.Slize * _GenerationData.MirrorRadian + offset

				for _, mirror in ipairs(player.Mirror) do

					local targetradian = composition[mirror].Slize * _GenerationData.MirrorRadian + offset
					local mx, my = RMG.MirrorNode(_GenerationData, x, y, sourceradian, targetradian, composition[mirror].AxisMirrorFlag)

					RMG.CreateStructure(_GenerationData, struct, round(mx), round(my), _GenerationData.Players[mirror])
				end
			end
		end

		-- if MirrorMap is true, this is player 1 and needs to be the last call to get the positioning for mirror sources right
		RMG.CreateStructure(_GenerationData, struct, x, y, _GenerationData.Players[playerindex])

		-- never change anything in the following lines !!!
		local level = _GenerationData.Structures.Current.Levels[0]

		if struct.Childs and table.getn(struct.Childs) > 0 then

			level = level + 1
			_GenerationData.Structures.Current.Levels[0] = level
			_GenerationData.Structures.Current.Levels[level] = 1

			return false, false
		else

			while level > 0 do
				if _GenerationData.Structures.Current.Levels[level] < table.getn(RMG.GetStructByLevel(_GenerationData, level - 1).Childs) then

					_GenerationData.Structures.Current.Levels[level] = _GenerationData.Structures.Current.Levels[level] + 1

					return false, false
				else

					_GenerationData.Structures.Current.Levels[level] = 1
					_GenerationData.Structures.Current.Levels[0] = _GenerationData.Structures.Current.Levels[0] - 1
					level = level - 1
					-- do not call return here, there could be more levels finished
				end
			end

			 -- this is only called if level reaches 0, so the generation is finished
			return true, false
		end
	end

	return false, true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetCurrentStruct(_GenerationData)
	return RMG.GetStructByLevel(_GenerationData, _GenerationData.Structures.Current.Levels[0])
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetStructByLevel(_GenerationData, _level)

	local struct = _GenerationData.Structures

	for l = 1, _level do
		struct = struct.Childs[_GenerationData.Structures.Current.Levels[l]]
	end

	return struct
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetCurrentParentData(_GenerationData)
	return RMG.GetStructDataByLevel(_GenerationData, _GenerationData.Structures.Current.Levels[0] - 1)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetStructDataByLevel(_GenerationData, _level)

	local struct = _GenerationData.Structures.Current.Structs

	for l = 1, _level do
		struct = struct.Childs[_GenerationData.Structures.Current.Levels[l]]
	end

	return struct
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetCurrentStructData(_GenerationData, _nodeX, _nodeY, _radius)

	local mapsize = Logic.WorldGetSize() / 100
	local x1, x2, y1, y2 = math.max(_nodeX - _radius, 0), math.min(_nodeX + _radius, mapsize), math.max(_nodeY - _radius, 0), math.min(_nodeY + _radius, mapsize)

	for x = x1, x2 do
		for y = y1, y2 do

			if SimpleGetDistance(x, y, _nodeX, _nodeY) < _radius then

				_GenerationData.TerrainNodes[x][y].Blocking = RMG.BlockingTypes.Structure
			end
		end
	end

	RMG.SetStructDataBylevel(_GenerationData, _GenerationData.Structures.Current.Levels[0], _nodeX, _nodeY, _radius)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.SetStructDataBylevel(_GenerationData, _level, _x, _y, _blocking)

	local struct = _GenerationData.Structures.Current.Structs

	for l = 1, _level do

		if not struct.Childs then
			struct.Childs = {}
		end

		if not struct.Childs[_GenerationData.Structures.Current.Levels[l]] then
			struct.Childs[_GenerationData.Structures.Current.Levels[l]] = {}
		end

		struct = struct.Childs[_GenerationData.Structures.Current.Levels[l]]
	end

	struct.X = _x
	struct.Y = _y

	struct.Blocking = _blocking
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.StructGetCurrentPlayer(_GenerationData)
	return _GenerationData.Structures.Current.Players[_GenerationData.Structures.Current.Levels[1]] --math.min(_GenerationData.Structures.Current.Levels[1], 16)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.IsAvailableMapIndex(_GenerationData, _nodeX, _nodeY, _radius)

	local mapsize = Logic.WorldGetSize() / 100
	local x1, x2, y1, y2 = _nodeX - _radius, _nodeX + _radius, _nodeY - _radius, _nodeY + _radius

	if x1 < 0 or x2 > mapsize or y1 < 0 or y2 > mapsize then
		return false
	end

	local radiussq = _radius ^ 2

	for x = x1, x2 do
		for y = y1, y2 do

			if IsInRangeSq(x, y, _nodeX, _nodeY, radiussq) and _GenerationData.TerrainNodes[x][y].Blocking ~= 0 then
				return false
			end
		end
	end

	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateStructure(_GenerationData, _struct, _x, _y, _player, _doNotRegister)

	-- Data
	if _struct.Data then
		local data = _struct.Data

		if not _doNotRegister then
			RMG.SetCurrentStructData(_GenerationData, _x, _y, data.Blocking or 0)
		end

		-- Entities
		if data.Entities then
			for i = 1, table.getn(data.Entities) do

				local entity = {}
				entity.Data = data.Entities[i]
				entity.X = _x * 100
				entity.Y = _y * 100
				entity.P = data.Entities[i].Player or _player.Id

				if _player.IsHuman == 1 or ((not entity.Data.SkipDummy) and (not entity.Data.Explore)) then
					table.insert(_GenerationData.Entities, entity)
				end
			end
		end

		-- Terrain Heights
		if data.TerrainHeights then

			local heights = data.TerrainHeights
			local area = heights.Area or 10
			local lerpdist = heights.LerpDist or 8
			local x1, y1, x2, y2, areasq, isrect = RMG.GetAreaData(area)

			local height, dist
			local baseheight = heights.BaseHeight or math.max(_GenerationData.WaterBaseHeight + 100, _GenerationData.TerrainNodes[_x][_y].Height)--_GenerationData.TerrainBaseHeight--

			for x = x1, x2 do
				for y = y1, y2 do
					if IsValidMapIndex(0, x + _x, y + _y) and (isrect or IsInRangeSq(0, 0, x, y, areasq)) then

						if heights[x] then
							height = heights[x][y] or 0
						else
							height = 0
						end

						height = height + baseheight

						if isrect then
							dist = math.min(math.abs(x1 - x), math.abs(y1 - y), math.abs(x2 - x), math.abs(y2 - y)) -- shortest dist to border
						else
							dist = area - SimpleGetDistance(0, 0, x, y) -- 0 because its a relativ index
						end

						if dist < lerpdist then
							height = CurvedLerp(height, _GenerationData.TerrainNodes[x + _x][y + _y].Height, (dist) / (lerpdist))
						end

						_GenerationData.TerrainNodes[x + _x][y + _y].Height = height
					end
				end
			end
		end

		-- Terrain Textures
		if data.TerrainTextures then

			local textures = data.TerrainTextures

			local area = textures.Area or 10
			local x, y = textures.RelativX or 0, textures.RelativY or 0
			local x1, y1, x2, y2, areasq, isrect = RMG.GetAreaData(area)

			local px, py = SnapToGrid(4, _x + x, _y + y)
			x1, y1 = FloorToGrid(4, px + x1, py + y1)
			x2, y2 = CeilToGrid(4, px + x2, py + y2)

			local textureList = textures.TextureList or TerrainTypes.EdgeColor01_AT

			if type(textureList) == "string" then
				textureList = _GenerationData.LandscapeSet.Textures[textureList].Normal
			end

			for x = x1, x2, 4 do
				for y = y1, y2, 4 do
					if isrect or IsInRangeSq(x, y, _x, _y, areasq) then
						RMG.SetRandomTexture(x, y, textureList)
					end
				end
			end
		end

		-- Water
		if data.Water then

			local water = data.Water

			local area = water.Area or 4 -- default for resource pits
			local x1, y1, x2, y2, areasq, isrect = RMG.GetAreaData(area)

			local px, py = SnapToGrid(4, _x, _y)
			x1, y1 = FloorToGrid(4, px + x1, py + y1)
			x2, y2 = CeilToGrid(4, px + x2, py + y2)

			local height = water.Height or 0
			Logic.WaterSetAbsoluteHeight(x1, y1, x2, y2, height)

			if water.Type then
				Logic.WaterSetType(x1, y1, x2, y2, water.Type)
			end
		end

	else
		RMG.SetCurrentStructData(_GenerationData, _x, _y, 0)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetAreaData(_area)

	local x1, y1, x2, y2, areasq, isrect

	if type(_area) == "number" then

		x1, y1, x2, y2 = -_area, -_area, _area, _area
		areasq = _area ^ 2
		isrect = false
	else --if type(_area) == "table" then

		areasq = 0--2 * _area ^ 2
		isrect = true

		if _area.X then
			x1, y1, x2, y2 = -_area.X, -_area.Y, _area.X, _area.Y
		else --if _area.x1 then
			x1, y1, x2, y2 = _area.x1, _area.y1, _area.x2, _area.y2
		end
	end

	return x1, y1, x2, y2, areasq, isrect
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- this function must only be called if _struct.Placemant is valid
function RMG.GetRandomPosition(_GenerationData, _struct, _parent, _grid)

	-- important for indexing
	_grid = _grid or 1

	-- get the overall area
	local x1, y1, x2, y2, areasq1, isrect1 = RMG.GetAreaData(_struct.Placement.AreaMax)

	-- and the excluded inner area
	local x3, y3, x4, y4, areasq2, isrect2 = 0,0,0,0,0,isrect1

	if _struct.Placement.AreaMin then
		x3, y3, x4, y4, areasq2, isrect2 = RMG.GetAreaData(_struct.Placement.AreaMin)
	end

	local bestheight = _struct.Placement.Height

	if not bestheight then
		local heightmax = _struct.Placement.HeightMax or 1
		local heightmin = _struct.Placement.HeightMin or -heightmax
		bestheight = (heightmin + heightmax) / 2
	end

	local blocking = 0

	if _struct.Data.Blocking then
		blocking = _struct.Data.Blocking
	end

	local maphalf = Logic.WorldGetSize() / 200
	local nodes = {}

	x1, y1 = CeilToGrid(_grid, x1, y1)
	x2, y2 = FloorToGrid(_grid, x2, y2)

	local step = _grid or 1

	for x = x1, x2, step do
		for y = y1, y2, step do

			-- is inside outer area ?
			local nx, ny = round(x + _parent.X), round(y + _parent.Y)
			if (isrect1 or IsInRangeSq(0, 0, x, y, areasq1)) and SimpleGetDistance(nx, ny, maphalf, maphalf) <= maphalf - blocking then --IsValidMapIndex(0, xn, yn) and

				-- is outside inner area ?
				if not ((isrect2 and x > x3 and y > y3 and x < x4 and y < y4) or (not isrect2 and IsInRangeSq(0, 0, x, y, areasq2))) then

					local node = _GenerationData.TerrainNodes[nx][ny]
					local cost = RMG.GetNodeBlockingCost(_GenerationData, nx, ny, blocking) * 100

					local dif = math.abs(node.Height - bestheight) + cost
					table.insert(nodes, {Dif = dif, X = nx, Y = ny})
				end
			end
		end
	end

	table.sort(nodes,
    function(e, e2)
        return e.Dif < e2.Dif
    end
	)

	return nodes[1]

	--for _,v in pairs(nodes) do
	--	if RMG.IsAvailableMapIndex(_GenerationData, v.X, v.Y, blocking) then
	--		return v
	--	end
	--end

	--return false
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.GetNodeBlockingCost(_GenerationData, _nodeX, _nodeY, _radius)

	local mapsize = Logic.WorldGetSize() / 100
	local x1, x2, y1, y2 = _nodeX - _radius, _nodeX + _radius, _nodeY - _radius, _nodeY + _radius

	local cost = 0
	local radiussq = _radius ^ 2

	for x = x1, x2 do
		for y = y1, y2 do

			if IsInRangeSq(x, y, _nodeX, _nodeY, _radius) and _GenerationData.TerrainNodes[x][y].Blocking ~= 0 then
				cost = cost + 1
			end
		end
	end

	return cost
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Update Blocking
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.UpdateBlocking(_GenerationData)

	local mapsize = Logic.WorldGetSize() / 100
	Logic.UpdateBlocking(1, 1, mapsize - 1, mapsize - 1)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Create Entities
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.CreateEntities(_GenerationData)

	-- structural entities
	for _, entity in ipairs(_GenerationData.Entities) do
		RMG.CreateEntity(_GenerationData, entity)
	end

	-- environmental entities
	-- skip if density is 0
	local entitydensity = _GenerationData.ForestDensity

	if entitydensity > 0 then

		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		local maphalfsqared = maphalf ^ 2

		-- do not generate close to the border, to prevent blocking of lareg entities outside the map, which would crash the game
		for x = 8, mapsize - 8 do
			for y = 8, mapsize - 8 do

				local blocking = _GenerationData.TerrainNodes[x][y].Blocking

				if blocking ~= RMG.BlockingTypes.Structure and blocking ~= RMG.BlockingTypes.Road and IsInRangeSq(x, y, maphalf, maphalf, maphalfsqared) then

					local landscapesetdata = RMG.GetTerrainNodeLandscapeSetData(_GenerationData, _GenerationData.TerrainNodes[x][y], "Entities")

					if landscapesetdata then

						local density = landscapesetdata.Density or 3

						if math.mod(x, density) == 0 and math.mod(y, density) == 0 then

							RMG.CreateRandomEntity(x * 100, y * 100, landscapesetdata, density * 33)
						end
					end
				end
			end
		end
	end

	-- crate wood piles
	local woodpilecounter = 1

	for id in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_ScriptEntity)) do

		local name = GetEntityName(id)

		if name == "woodpile" then

			Logic.SetEntityName(id, "woodpile"..woodpilecounter)
			CreateWoodPile("woodpile"..woodpilecounter, _GenerationData.ContentWoodPile)
			woodpilecounter = woodpilecounter + 1
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateRandomEntity(_x, _y, _entities, _offset)

	_offset = _offset or 100

	if _entities then
		Logic.CreateEntity(RMG.GetRandomValueFromTable(_entities), _x + math.random(-_offset, _offset), _y + math.random(-_offset, _offset), math.random(0, 360), 0)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.CreateEntity(_GenerationData, _entity)

	local entity = _entity.Data
	local etype = GetRandomValueFromTable(entity.Type)
	local x, y = _entity.X, _entity.Y

	if entity.Grid then
		x, y = SnapToGrid(entity.Grid, x, y)
	end

	x = x + (entity.RelativX or 0)
	y = y + (entity.RelativY or 0)

	local rotation = entity.Rotation or 0

	if rotation == -1 then
		rotation = math.random(0, 360)
	end

	if entity.Angle then
		rotation = SnapToGrid(entity.Angle, rotation)
	end

	local player = _entity.P
	local id

	if entity.Soldiers and type(entity.Soldiers) == "number" then
		id = Tools.CreateGroup(player, etype, entity.Soldiers, x, y, rotation)
	else
		id = Logic.CreateEntity(etype, x, y, rotation, player)
	end

	if entity.Explore then
		local name = entity.Name or ""
		Logic.SetEntityExplorationRange(id, entity.Explore)
		Logic.SetEntityName(id, "rmg_explore")--..player.."_"..name) -- TODO: this is ugly
		return
	end

	--if entity.Scale then
		--SCV.SetScale(id, entity.Scale)
	--end

	if entity.Resource then
		Logic.SetResourceDoodadGoodAmount(id, entity.Resource)
	end

	if entity.Name then
		if entity.Name == "HQP" then
			Logic.SetEntityName(id, entity.Name .. player)
		elseif string.find(entity.Name, "Pit") ~= nil
		or string.find(entity.Name, "Village") ~= nil
		or string.find(entity.Name, "Lighthouse") ~= nil then
			local count = 1
			local name = ""
			while true do
				name = entity.Name .. "_" .. player .. "_" .. count
				if Logic.GetEntityIDByName(name) == 0 then
					break
				else
					count = count + 1
				end
			end
			Logic.SetEntityName(id, name)
		else
			Logic.SetEntityName(id, entity.Name)
		end
	end

	if entity.Health then
		SetHealth(id, entity.Health)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Finalize
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.Finalize(_GenerationData)

	GUI.RebuildMinimapTerrain()
	local playerindex = 0

	-- set initial camera position
	if GUI.GetPlayerID() == 17 then -- observer
		Camera.ScrollSetLookAt(Logic.WorldGetSize() / 2, Logic.WorldGetSize() / 2)
	else
		for i = 1, _GenerationData.NumberOfPlayers do

			local player = _GenerationData.Players[i]

			if player.Id == GUI.GetPlayerID() then

				playerindex = i

				RMG.SetCameraStart(player)
				break
			end
		end
	end

	-- update blocking
	CUtil.UpdateBlockingWholeMapWithHeight()

	-- peacetime with rivers
	if EMS then
		RMG.DeleteBridges(_GenerationData)
	end

	-- debug
	if _GenerationData.DebugMode then

		function RMG.Debug()

			if Counter.Tick2("RMG_Debug", 11) then
				Game.GameTimeSetFactor(1)
				for i = 1,18 do Display.GfxSetSetFogParams(i,0,0,0,0,0,0,0) end

				XGUIEng.ShowWidget("GameClock", 1)
				Display.SetRenderFogOfWar(0)
				Camera.ZoomSetFactorMax(5)

				local mapsize = Logic.WorldGetSize() / 100
				for x = 0, mapsize do
					for y = 0, mapsize do
						if _GenerationData.TerrainNodes[x][y].Blocking ~= 0 then
							--Logic.SetTerrainVertexColor(x, y, 191, 63, 63)
						end
					end
				end

				return true
			end
		end

		Game.GameTimeSetFactor(10)
		StartSimpleJob(RMG.Debug)
	else

		-- clear _GenerationData
		_GenerationData.Entities = nil
		_GenerationData.Rivers = nil
		_GenerationData.Roads = nil
		_GenerationData.Structures = nil
		_GenerationData.TerrainNodes = nil

		RMG.TextureSets = nil
		RMG.VertexColorSets = nil
		RMG.EntitySets = nil
		RMG.LandscapeSets = nil
	end

	structData = {
		NumClayPits = _GenerationData.AmountClayPit,
		NumStonePits = _GenerationData.AmountStonePit,
		NumIronPits = _GenerationData.AmountIronPit,
		NumSulfurPits = _GenerationData.AmountSulfurPit,
		NumGoldPits = _GenerationData.AmountGoldPit,
		NumSilverPits = _GenerationData.AmountSilverPit,
		NumVillageCenter = _GenerationData.AmountVillageCenter,
		NumVillageHall = _GenerationData.amountVillageHall,
		NumLighthouse = _GenerationData.amountLighthouse
	}
	if CNetwork then
		if EMS then
			EMS.GL.HideMainMenu()
		end
		GUI.AddStaticNote("RMG: Das Spiel startet automatisch, sobald die Karte bei allen Spielern fertig generiert wurde.")
		CNetwork.SendCommand("RMG.PlayerFeedbackReady", playerindex)
	else
		RMG.Callback_OnGenerationFinished()
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function RMG.PlayerFeedbackReady(_name, _playerindex)

	RMG.GenerationData.Players[_playerindex].IsReady = true

	-- check if every human player is ready
	for i, player in ipairs(RMG.GenerationData.Players) do
		if player.IsHuman == 1 and not player.IsReady then
			return
		end
	end

	GUI.ClearNotes()

	-- for EMS in MP only call if player is host, since the ems start func is synced
	-- maybe i will find a better way, but for now it works like this
	if not CNetwork or not RMG.EMS or GUI.GetPlayerID() == EMS.GV.HostId then
		RMG.Callback_OnGenerationFinished()
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Game Start Callback
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.Callback_OnGameStart()

	for id in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_ScriptEntity)) do

		local name = GetEntityName(id)

		if not name or name == "rmg_explore" then

			DestroyEntity(id)

			-- code for minimap markers
			--[[if Logic.GetEntityExplorationRange(id) > 0 and string.find(name, "rmg_explore" .. GUI.GetPlayerID() .. "_") then

				local pos = GetPosition(id)
				local col = 0

				if string.find(name, "blue") then
					col = 1
				elseif string.find(name, "white") then
					col = 2
				end

				GUI.CreateMinimapMarker(pos.X, pos.Y, col)
			end]]
		end
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Peacetime Callback
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.Callback_OnPeacetimeEnded(_GenerationData)

	if _GenerationData.TeamBorderType == 2 then

		for id in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_WoodenFence15)) do
			DestroyEntity(id)
		end

	elseif _GenerationData.TeamBorderType == 3 then

		for p = 1, _GenerationData.NumberOfPlayers do
			AllowTechnology(Technologies.B_Bridge, _GenerationData.Players[p].Id)
		end
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Utility
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- linear interpolation of two values
function Lerp(_a, _b, _factor)
	return _a * _factor + _b * (1.0 - _factor)
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- curved interpolation of two values
function CurvedLerp(_a, _b, _factor)
 return Lerp(_a, _b, math.sin((_factor - 0.5) * math.pi) / 2.0 + 0.5)
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- faster distance check than using math.sqrt
function IsInRange(_x1, _y1, _x2, _y2, _range)
 return IsInRangeSq(_x1, _y1, _x2, _y2, _range ^ 2)
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- faster distance check than using math.sqrt
function IsInRangeSq(_x1, _y1, _x2, _y2, _rangesqared)
 return (_x1 - _x2) ^ 2 + (_y1 - _y2) ^ 2 < _rangesqared
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- aligns values to a given grid size
function SnapToGrid(_grid, ...)
 for i,v in ipairs(arg) do
  arg[i] = math.floor(v / _grid + 0.5) * _grid
 end
 return unpack(arg)
end

function FloorToGrid(_grid, ...)
 for i,v in ipairs(arg) do
  arg[i] = math.floor(v / _grid) * _grid
 end
 return unpack(arg)
end

function CeilToGrid(_grid, ...)
 for i,v in ipairs(arg) do
  arg[i] = math.ceil(v / _grid) * _grid
 end
 return unpack(arg)
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- converts a position to an index aligned to a given grid size
function PositionToIndex(_grid, _x, _y)
 local mapsize = Logic.WorldGetSize() / 100
 _x, _y = SnapToGrid(_grid, _x, _y)
 return math.max(math.min(_x / 100, mapsize), 0), math.max(math.min(_y / 100, mapsize), 0) -- 100 not _grid is correct
end

--- author:RobbiTheFox		current maintainer:RobbiTheFox		v1.0
-- checks if position is within distance to map center
-- if no distance is given, the intended circular map is checked
function IsValidMapPosition(_x, _y, _dist)
 _dist = _dist or 0

 local maphalf = Logic.WorldGetSize() / 2
 return IsInRange(_x, _y, maphalf, maphalf, maphalf - _dist)
end

function IsValidMapIndex(_dist, ...)--_x, _y)
 local mapsize = Logic.WorldGetSize() / 100
 for i,v in ipairs(arg) do
  if arg[i] < _dist or arg[i] > mapsize - _dist then
   return false
  end
 end
 return true
 --return _x >= 0 and _x <= mapsize and _y >= 0 and _y <= mapsize
end

function MakePositionValid(...)
 local mapsize = Logic.WorldGetSize()
 for i,v in ipairs(arg) do
  arg[i] = math.max(math.min(v, mapsize), 0)
 end
 return unpack(arg)
end

function MakeIndexValid(...)
 local mapsize = Logic.WorldGetSize() / 100
 for i,v in ipairs(arg) do
  arg[i] = math.max(math.min(v, mapsize), 0)
 end
 return unpack(arg)
end

function SimpleGetDistance(_x1, _y1, _x2, _y2)
	return math.sqrt((_x1 - _x2)^2 + (_y1 - _y2)^2)
end
-- bool <-> number conversion
function Bool2Num(_b)
 if _b then
  return 1;
 end
 return 0;
end
function Num2Bool(_n)
 if _n == 0 then
  return false;
 end
 return true;
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
if CNetwork then
	CNetwork.SetNetworkHandler("RMG.GenerateMap", RMG.GenerateMap)
	CNetwork.SetNetworkHandler("RMG.PlayerFeedbackReady", RMG.PlayerFeedbackReady)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function FixVillageCenters()

	RMG.GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete
	function GameCallback_OnBuildingConstructionComplete(_BuildingId, _PlayerId)

		RMG.GameCallback_OnBuildingConstructionComplete(_BuildingId, _PlayerId)

		if Logic.GetEntityType(_BuildingId) == Entities.PB_VillageCenter1 then

			S5Hook.GetEntityMem(_BuildingId)[66]:SetFloat(-400)
			S5Hook.GetEntityMem(_BuildingId)[67]:SetFloat(-600)
			S5Hook.GetEntityMem(_BuildingId)[68]:SetFloat(-500)
			S5Hook.GetEntityMem(_BuildingId)[69]:SetFloat(-600)
		end
	end

	RMG.GameCallback_OnBuildingUpgradeComplete = GameCallback_OnBuildingUpgradeComplete
	function GameCallback_OnBuildingUpgradeComplete(_OldId, _NewId)

		RMG.GameCallback_OnBuildingUpgradeComplete(_OldId, _NewId)

		if Logic.GetEntityType(_NewId) == Entities.PB_VillageCenter2 or Logic.GetEntityType(_NewId) == Entities.PB_VillageCenter3 then

			S5Hook.GetEntityMem(_NewId)[66]:SetFloat(-400)
			S5Hook.GetEntityMem(_NewId)[67]:SetFloat(-600)
			S5Hook.GetEntityMem(_NewId)[68]:SetFloat(-500)
			S5Hook.GetEntityMem(_NewId)[69]:SetFloat(-600)
		end
	end

	--[[RMG.Logic_CreateEntity = Logic.CreateEntity
	function Logic.CreateEntity(_EntityType, _X, _Y, _Rotation, _Player)

		local id = RMG.Logic_CreateEntity(_EntityType, _X, _Y, _Rotation, _Player)

		if _EntityType == Entities.PB_VillageCenter1 or _EntityType == Entities.PB_VillageCenter2 or _EntityType == Entities.PB_VillageCenter3 then

			S5Hook.GetEntityMem(id)[66]:SetFloat(-400)
			S5Hook.GetEntityMem(id)[67]:SetFloat(-600)
			S5Hook.GetEntityMem(id)[68]:SetFloat(-500)
			S5Hook.GetEntityMem(id)[69]:SetFloat(-600)
		end
	end]]
end