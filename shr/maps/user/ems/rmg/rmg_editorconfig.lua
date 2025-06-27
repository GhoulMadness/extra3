--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- RMG für den Karteneditor
-- by RobbiTheFox
--
-- Öffne den Editor mit LuaDebugger und öffne rmg_editor.lua
-- Diese und alle anderen wichtigen Dateien werden automatisch mitgeladen
--
-- in EditorConfig könnt ihr dieverse Einstellungen vornehemn
--
-- in GetPlayersAndTeams könnt ihr die Anzahl und Verteilung von Spielern einstellen
--
-- Danach kommt beispielhaft noch das Templat für Gezeiten, welches aber nicht genauer erklärt wird. Wer eine modifizierte Karte erstellen möchte, kann mich direkt fragen.
--
-- Der Generator sollte auf einer LEEREN Karte generiert werden. Der Kartengenerator löscht keine Entities!
-- Wenn du bereit bist, die Karte zu generieren, gib RMG.GenerateMap() in die Konsole ein.
-- Die Generierung sollte zwischen 4s und 30s in Anspurch nehmen - ja nach Größe und Komplexität der Karte und deinem System.
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
RMG.TEAMBORDERTYPES = {
	NONE  = 1,
	FENCE = 2,
	RIVER = 3,
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------
RMG.GATESIZES = {
	VERYSMALL = 1,
	SMALL = 2,
	MEDIUM = 3,
	LARGE = 4,
	VERYLARGE = 5,
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------
RMG.LANDSCAPESETS = {
	NORMAL = "Normal",
	NORTH = "North",
	EVELANCE = "Evelance",
	MEDI = "Mediterran",
	MOOR = "Moor",
	TIDELAND = "Tideland",
	STEPPE = "Steppe",
}
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
RMG.EditorConfig = {
	
	-- Kartenseed
	Seed = 123456789,
	
	-- Landschaftsset
	LandscapeSet = "Tideland",
	
	-- Abgrenzung zwischen den Teams
	TeamBorderType = RMG.TEAMBORDERTYPES.RIVER,
	
	-- Größe der Tore, wenn Zaun als Abgrenzung gewählt wurde
	GateSize = RMG.GATESIZES.MEDIUM,
	
	-- Sollen Wege zu anderen Spielern generiert werden?
	-- sollte bei Abgrenzung Fluss true sein
	GenerateRoads = true,
	
	-- Soll die Karte gespiegelt werden?
	MirrorMap = true,
	
	-- Sollen Spieler in einem Ring (false) oder willkürlich (true) platziert werden? 
	RandomPlayerPosition = false,
	
	-- Inhalt von Rohstoffvorkommen
	ContentClayPit = 50000,
	ContentClayPile = 4000,
	ContentStonePit = 50000,
	ContentStonePile = 4000,
	ContentIronPit = 30000,
	ContentIronPile = 4000,
	ContentSulfurPit = 30000,
	ContentSulfurPile = 4000,
	ContentWoodPile = 15000,
	
	-- Anzahl von Rohstoffvorkommen pro Spieler
	AmountClayPit = 1,
	AmountClayPile = 4,
	AmountStonePit = 1,
	AmountStonePile = 4,
	AmountIronPit = 2,
	AmountIronPile = 4,
	AmountSulfurPit = 2,
	AmountSulfurPile = 4,
	AmountWoodPile = 2,
	
	-- Anzahl von Dorfzentren pro Spieler
	AmountVC = 3,
	
	-- Sollen Rohstoffvorkommen / Dorfzentren zu Spielstart aufgedeckt werden?
	ShowResources = true,
	ShowVillageCenters = true,
	
	-- Soll es Waffenstillstand auf der Karte geben?
	-- Bestimmt zB, ob Tore geöffnet oder geschlossen generiert werden.
	Peacetime = 0,
}
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetPlayersAndTeams()
	
	local nplayers = 0
	local players = {}
	local nteams = 0
	local teams = {}
	
	-- Hier kannst du einstellen, für wie viele Spieler die Karte generiert werden soll, welcher Spieler zu welchem Team gehört und ob Startgebäude für den Spieler generiert werden sollen.
	players[1] = { Id = 1, Team = 1, IsHuman = 1 }
	players[2] = { Id = 2, Team = 1, IsHuman = 1 }
	players[3] = { Id = 3, Team = 2, IsHuman = 1 }
	players[4] = { Id = 4, Team = 2, IsHuman = 1 }
	--players[5] = { Id = 5, Team = 5, IsHuman = 1 }
	--players[6] = { Id = 6, Team = 6, IsHuman = 1 }
	--players[7] = { Id = 7, Team = 7, IsHuman = 1 }
	--players[8] = { Id = 8, Team = 8, IsHuman = 1 }
	--players[9] = { Id = 1, Team = 9, IsHuman = 1 }
	--players[10]= { Id = 2, Team = 10, IsHuman = 1 }
	--players[11]= { Id = 3, Team = 11, IsHuman = 1 }
	--players[12]= { Id = 4, Team = 12, IsHuman = 1 }
	--players[13]= { Id = 5, Team = 4, IsHuman = 1 }
	--players[14]= { Id = 6, Team = 4, IsHuman = 1 }
	--players[15]= { Id = 7, Team = 4, IsHuman = 1 }
	--players[16]= { Id = 8, Team = 4, IsHuman = 1 }
	
	-- Hier musst du jede Team Id, die du oben bei den Spielern verwendest genau 1x eintragen.
	teams[1] = 1
	teams[2] = 2
	--teams[3] = 3
	--teams[4] = 4
	--teams[5] = 5
	--teams[6] = 6
	--teams[7] = 7
	--teams[8] = 8
	--teams[9] = 9
	--teams[10] = 10
	--teams[11] = 11
	--teams[12] = 12
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- AB HIER FINGER WEG !
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	nplayers = table.getn( players )
	nteams = table.getn( teams )
	
	-- sort MUST be done here !
	-- sort team by id
	table.sort( teams,
	function( a, b )
		return a < b
	end
	)
	
	-- sort players by team
	table.sort( players,
	function( a, b )
		return ( a.Team < b.Team ) --or (a.Team == b.Team and a.Id < b.Id)
	end
	)

	return nplayers, players, nteams, teams
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- Das ist das Template für (4) EMS RMG Gezeiten
-- Hier könnt ihr sehen, was verändert wurde.
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.Gezeiten()
	
	-- this is temporary until I figure out a better way to disable certein features
	RMG.IsCustomMap = true
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	RMG.InitGenerationData_Orig = RMG.InitGenerationData
	function RMG.InitGenerationData()
		
		RMG.InitGenerationData_Orig()
		
		-- custom stuff here
		RMG.GenerationData.WaterBaseHeight = 2500 -- start a little higher
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- define fix resource and village placement here
	function RMG.GetPlayerStruct()
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		local noiseMin = RMG.GenerationData.ThresholdCoast
		local noiseMax = RMG.GenerationData.ThresholdHill
		
		return {
			Childs = {
				-- first island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 112.50, 0.75 ),
						AbsolutY = GetYFromAngleAndRelDist( 112.50, 0.75 ),
					},
					-- Headquarter
					Data = {
						Blocking = 12,
						Entities = {
							{Type = Entities.PB_Headquarters1, SkipDummy = true},
						},
						TerrainHeights = {
						Area = {X = 18, Y = 18,},
						},
						TerrainTextures = {
							Area = {X = 8, Y = 8,},
							TextureList = "Road",
						},
					},
					-- clay mine, stone mine, village
					Childs = {},
				},
				-- seccond island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 67.50, 0.75 ),
						AbsolutY = GetYFromAngleAndRelDist( 67.50, 0.75 ),
					},
					-- 2x iron mine, 2x sulfur mine, village
					Childs = {},
				},
				-- third island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 75.00, 0.45 ),
						AbsolutY = GetYFromAngleAndRelDist( 75.00, 0.45 ),
					},
					-- village
					Childs = {},
				},
			},
		}
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- define additional resource and village placement here
	function RMG.FillPlayerStruct()
		
		local noiseMin = RMG.GenerationData.ThresholdCoast
		local noiseMax = RMG.GenerationData.ThresholdHill
		
		local noiseIron = RMG.GenerationData.ThresholdHill
		local noiseSulfur = RMG.GenerationData.ThresholdCoast

		local resoff = 10
		local dist = 40
		
		--vc
		for i = 1, 3 do
			
			local placement
			
			-- the 3rd vc will have a fix location on the small island
			if i < 3 then
				placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.TerrainBaseHeight,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
				}
			else
				placement = {
					AreaMin = 0,
					AreaMax = 12,
					Noise = RMG.GenerationData.TerrainBaseHeight,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
				}
			end
			
			local child = {
				Placement = placement,
				Data = RMG.StructureSets.NeutralVillageCenter,
			}
			if i == 1 then
				child.Childs = {{Data = {Entities = {{Type = Entities.PB_VillageCenter1, SkipDummy = true}}}}}
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[i].Childs, child)
		end
		
		-- clay
		for i = 1, 1 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.ThresholdCoast,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.ClayPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.ClayPile,
						Childs = {},
					},
				},
			}
			
			for j = 1, 3 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.ClayPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs, child)
		end
		
		-- stone
		for i = 1, 1 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.ThresholdHill,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.StonePit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.StonePile,
						Childs = {},
					},
				},
			}
			
			for j = 1, 3 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.StonePile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs, child)
		end
		
		-- wood
		for i = 2, 3 do
			
			-- 1 = first island, i = clay or stone pit, 1 = first pile, Childs = other piles
			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs[i].Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.WoodPileExplored,})
		end
		
		-- iron
		for i = 1, 2 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = noiseIron,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.IronPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.IronPile,
						Childs = {},
					}
				},
			}
			
			for j = 1, 1 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.IronPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[2].Childs, child)
		end
		
		-- sulfur
		for i = 1, 2 do

			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = noiseSulfur,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.SulfurPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.SulfurPile,
						Childs = {},
					}
				},
			}
			
			for j = 1, 1 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.SulfurPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[2].Childs, child)
		end
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	RMG.FillNoiseTable_Orig = RMG.FillNoiseTable
	function RMG.FillNoiseTable( _generationdata )
		
		RMG.FillNoiseTable_Orig( _generationdata )
		
		-- custom stuff here
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		-- flatten middle and main connectors
		local innerrange = Round( maphalf * 0.15 ) - 15
		local outerrange = innerrange + 45
		
		RMG.FlattenArea( _generationdata, maphalf, maphalf, innerrange, outerrange )
		RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 135.00, 0.55 ), GetYFromAngleAndRelDist( 135.00, 0.55 ), innerrange, outerrange )
		RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 315.00, 0.55 ), GetYFromAngleAndRelDist( 315.00, 0.55 ), innerrange, outerrange )
		
		-- flatten corners
		local innerrange = Round( maphalf * 0.20 ) - 15
		local outerrange = innerrange + 45
		
		local low, high = 0.175, 0.825
		
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * low  ), Round( mapsize * low  ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * high ), Round( mapsize * low  ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * low  ), Round( mapsize * high ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * high ), Round( mapsize * high ), innerrange, outerrange, -0.352147606136882, 0.10 )
		
		-- flatten outer connectors
		--local innerrange = Round( maphalf * 0.1 ) - 15
		--local outerrange = innerrange + 30
		
		--RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist(  70.00, 0.57 ), GetYFromAngleAndRelDist(  70.00, 0.57 ), innerrange, outerrange )
		--RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 200.00, 0.57 ), GetYFromAngleAndRelDist( 200.00, 0.57 ), innerrange, outerrange )
		--RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 250.00, 0.57 ), GetYFromAngleAndRelDist( 250.00, 0.57 ), innerrange, outerrange )
		--RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist(  20.00, 0.57 ), GetYFromAngleAndRelDist(  20.00, 0.57 ), innerrange, outerrange )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	RMG.SetTerrainTextures_Orig = RMG.SetTerrainTextures
	function RMG.SetTerrainTextures( _generationdata )
		
		local maphalf = Logic.WorldGetSize() / 200
		
		-- flatten outer connectors
		local innerrange = Round( maphalf * 0.1 ) - 15
		local outerrange = innerrange + 30
		
		-- this needs to be done after rivers and roads have been calculated
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist(  70.00, 0.57 ), GetYFromAngleAndRelDist(  70.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist( 200.00, 0.57 ), GetYFromAngleAndRelDist( 200.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist( 250.00, 0.57 ), GetYFromAngleAndRelDist( 250.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist(  20.00, 0.57 ), GetYFromAngleAndRelDist(  20.00, 0.57 ), innerrange, outerrange, 2356 )
		
		RMG.SetTerrainTextures_Orig( _generationdata )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FlattenArea( _generationdata, _X, _Y, _InnerRange, _OuterRange )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		-- flatten middle
		local _InnerRange = Round( maphalf * 0.15 ) - 15
		local _OuterRange = _InnerRange + 45
		
		local minnoise, maxnoise = 1, -1
		local noiseaverage = 0
		local n = 0
		
		for x = -_InnerRange, _InnerRange do
			for y = -_InnerRange, _InnerRange do
				
				local noise = _generationdata.TerrainNodes[ x + _X ][ y + _Y ].HeightNoise
				
				minnoise = math.min( minnoise, noise )
				maxnoise = math.max( maxnoise, noise )
				
				noiseaverage = noiseaverage + noise
				n = n + 1
			end
		end
		
		noiseaverage = noiseaverage / n
		
		local noiserange = maxnoise - minnoise
		local func =	function( _noise, _targetrange, _targetnoise, _offset )
							return math.min( ( _noise - _offset ) * _targetrange + _targetnoise, -0.396626934498992 )
						end
		
		RMG.SimpleNoiseOverride( _generationdata, _X, _Y, _InnerRange, _OuterRange, -0.399297853124962, 0.10 / noiserange, nil, nil, func, noiseaverage )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FillRiverLocationTable( _generationData )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2

		_generationData.Rivers.StartPoints = {
			{ X = maphalf * 1.00 * math.cos( math.rad(  45.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad(  45.00 ) ) + maphalf },
			{ X = maphalf * 1.00 * math.cos( math.rad(  90.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad(  90.00 ) ) + maphalf },
			
			{ X = maphalf * 1.00 * math.cos( math.rad( 180.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad( 180.00 ) ) + maphalf },
			{ X = maphalf * 0.67 * math.cos( math.rad(  45.00 ) ) + maphalf, Y = maphalf * 0.67 * math.sin( math.rad(  45.00 ) ) + maphalf },
			
			{ X = maphalf * 0.60 * math.cos( math.rad(  57.50 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad(  57.50 ) ) + maphalf }, -- -10
			{ X = maphalf * 0.60 * math.cos( math.rad(  90.00 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad(  90.00 ) ) + maphalf },
			
			{ X = maphalf * 0.59 * math.cos( math.rad( 123.75 ) ) + maphalf, Y = maphalf * 0.59 * math.sin( math.rad( 123.75 ) ) + maphalf },
			{ X = maphalf * 0.59 * math.cos( math.rad( 146.25 ) ) + maphalf, Y = maphalf * 0.59 * math.sin( math.rad( 146.25 ) ) + maphalf },

			{ X = maphalf * 0.60 * math.cos( math.rad( 180.00 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad( 180.00 ) ) + maphalf },
			{ X = maphalf * 0.60 * math.cos( math.rad( 212.50 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad( 212.50 ) ) + maphalf }, -- +10
			-- technically a double, but is required
			{ X = maphalf * 0.67 * math.cos( math.rad( 225.00 ) ) + maphalf, Y = maphalf * 0.67 * math.sin( math.rad( 225.00 ) ) + maphalf },
			
			{ X = maphalf * 0.15 * math.cos( math.rad(  68.75 ) ) + maphalf, Y = maphalf * 0.15 * math.sin( math.rad(  68.75 ) ) + maphalf }, -- -10
			{ X = maphalf * 0.15 * math.cos( math.rad( 201.25 ) ) + maphalf, Y = maphalf * 0.15 * math.sin( math.rad( 201.25 ) ) + maphalf }, -- +10
			
		}
		for _,v in ipairs( _generationData.Rivers.StartPoints ) do
			v.X, v.Y = SnapToGrid( 4, v.X, v.Y )
		end
		
		_generationData.Rivers.Paths = 
		{
			{  4,  1 },
			{  6,  2 },
			{  9,  3 },
			
			{  4,  5 },
			{  5,  6 },
			
			{  6,  7 },
			{ 11, 10 },
			{ 10,  9 },
			
			{  9,  8 },
			
			{  5, 12 },
			{  6, 12 },
			
			{  9, 13 },
			{ 10, 13 },
		}
		_generationData.Rivers.MirrorRadea = { math.rad( 180 ) }
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FillRoadLocationTable( _generationData )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		_generationData.Roads.StartPoints = {
			-- player 1
			{ X = maphalf * 0.75 * math.cos( math.rad( 112.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 112.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad(  67.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad(  67.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad(  75.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad(  75.00 ) ) + maphalf }, -- -15
			-- player 2
			{ X = maphalf * 0.75 * math.cos( math.rad( 157.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 157.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad( 202.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad( 202.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad( 195.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad( 195.00 ) ) + maphalf }, -- +15
			-- team 1
			{ X = maphalf * 0.37 * math.cos( math.rad( 135.00 ) ) + maphalf, Y = maphalf * 0.37 * math.sin( math.rad( 135.00 ) ) + maphalf },
			-- player 3
			{ X = maphalf * 0.75 * math.cos( math.rad( 292.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 292.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad( 247.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad( 247.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad( 255.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad( 255.00 ) ) + maphalf }, -- -15
			-- player 4
			{ X = maphalf * 0.75 * math.cos( math.rad( 337.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 337.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad(  22.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad(  22.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad(  15.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad(  15.00 ) ) + maphalf }, -- +15
			-- team 2
			{ X = maphalf * 0.37 * math.cos( math.rad( 315.00 ) ) + maphalf, Y = maphalf * 0.37 * math.sin( math.rad( 315.00 ) ) + maphalf },
		}
		for _,v in ipairs( _generationData.Roads.StartPoints ) do
			v.X, v.Y = SnapToGrid( 4, v.X, v.Y )
		end
		
		_generationData.Roads.Paths = {
			{ 1, 2 },
			{ 2, 3 },
			{ 4, 5 },
			{ 5, 6 },
			{ 3, 7 },
			{ 6, 7 },
			
			{  8,  9 },
			{  9, 10 },
			{ 11, 12 },
			{ 12, 13 },
			{ 10, 14 },
			{ 13, 14 },
		}
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.DeleteBridges()
		
		local bridges = {}
		
		for bridge in CEntityIterator.Iterator() do
			if Logic.IsEntityInCategory( EntityCategories.Bridge ) == 1 then
				table.insert( bridges, bridge )
			end
		end
		
		-- sort by distance to middle
		table.sort( bridges,
			function ( a, b )
				local maphalf = Logic.WorldGetSize() / 2
				local xa, ya = Logic.GetEntityPosition( a )
				local xb, yb = Logic.GetEntityPosition( b )
				return ( ( xa - maphalf ) ^ 2 + ( ya - maphalf ) ^ 2 ) < ( ( xb - maphalf ) ^ 2 + ( yb - maphalf ) ^ 2 )
			end
		)
		
		-- delete the 8 closest bridges - lazy but it works
		for i = 1, 8 do
			Logic.DestroyEntity( bridges[ i ] )
		end
	end

	RMG.LandscapeSets.Tideland.Water = WaterTypes.European_NonFreezing_Shorewave
end

function RMG.GezeitenBS()
	
	-- this is temporary until I figure out a better way to disable certein features
	RMG.IsCustomMap = true
	
	RMG.InitGenerationData_Orig = RMG.InitGenerationData
	function RMG.InitGenerationData()
		
		RMG.InitGenerationData_Orig()
		
		-- custom stuff here
		RMG.GenerationData.WaterBaseHeight = 2500 -- start a little higher
		
		local exploreres = Bool2Num( RMG.EditorConfig.ShowResources )
		local explorevc = Bool2Num( RMG.EditorConfig.ShowVillageCenters )
	
		RMG.StructureSets.SilverPit = {
			Entities = {{Type = Entities.XD_SilverPit1, Resource = 1000,}, {Type = Entities.XD_ScriptEntity, Explore = exploreres * 5, Name = "white"},},
			Blocking = 16,
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
				TextureList = RMG.TextureSets.NormalMudDarkSmooth,
				Area = 10,
			},
			Water = {},
		}
		RMG.StructureSets.GoldPit = {
			Entities = {{Type = Entities.XD_GoldPit1, Resource = 50000,}, {Type = Entities.XD_ScriptEntity, Explore = exploreres * 5, Name = "white"},},
			Blocking = 16,
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
				TextureList = RMG.TextureSets.NorthSand,
				Area = 10,
			},
			Water = {},
		}
		RMG.StructureSets.NeutralVillageHall = {
			Blocking = 18,
			Entities = {
				{Type = Entities.XD_VillageCenter_Ruin, Player = 0,}, {Type = Entities.XD_ScriptEntity, Explore = explorevc * 6, Name = "green"},
			},
			TerrainHeights = {
				Area = {X = 18, Y = 18,},
			},
			TerrainTextures = {
				Area = {X = 8, Y = 8,},
				TextureList = "Road",
			},
		}
		RMG.StructureSets.NeutralLighthouse = {
			Blocking = 16,
			Entities = {
				{Type = Entities.XD_Lighthouse_Ruin, Player = 0,}, {Type = Entities.XD_ScriptEntity, Explore = explorevc * 6, Name = "green"},
			},
			TerrainHeights = {
				Area = {X = 16, Y = 16,},
			},
			TerrainTextures = {
				Area = {X = 8, Y = 8,},
				TextureList = "Road",
			},
		}

	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.GetNeutralStruct()
		
		local mapsize = Logic.WorldGetSize() / 100
		local silverminelocation = math.random( 2 ) == 1 and 0.33 or 0.67
		
		
		return {
			Childs = {
				-- village halls
				{
					Placement = {
						AbsolutX = Round( mapsize * 0.175 ),
						AbsolutY = Round( mapsize * 0.825 ),
					},
					Data = RMG.StructureSets.NeutralVillageHall,
				},
				{
					Placement = {
						AbsolutX = Round( mapsize * 0.825 ),
						AbsolutY = Round( mapsize * 0.175 ),
					},
					Data = RMG.StructureSets.NeutralVillageHall,
				},
				-- silver mines
				{
					Placement = {
						AbsolutX = Round( mapsize * silverminelocation ), 
						AbsolutY = Round( mapsize * silverminelocation ),
					},
					Data = RMG.StructureSets.SilverPit,
				},
			},
		}
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- define fix resource and village placement here
	function RMG.GetPlayerStruct()
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		local noiseMin = RMG.GenerationData.ThresholdCoast
		local noiseMax = RMG.GenerationData.ThresholdHill
		
		return {
			Childs = {
				-- first island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 112.50, 0.75 ),
						AbsolutY = GetYFromAngleAndRelDist( 112.50, 0.75 ),
					},
					-- Headquarter
					Data = {
						Blocking = 12,
						Entities = {
							{Type = Entities.PB_Headquarters1, SkipDummy = true},
						},
						TerrainHeights = {
						Area = {X = 18, Y = 18,},
						},
						TerrainTextures = {
							Area = {X = 8, Y = 8,},
							TextureList = "Road",
						},
					},
					-- clay mine, stone mine, village
					Childs = {},
				},
				-- seccond island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 67.50, 0.75 ),
						AbsolutY = GetYFromAngleAndRelDist( 67.50, 0.75 ),
					},
					-- 2x iron mine, 2x sulfur mine, village
					Childs = {},
				},
				-- third island
				{
					Placement = {
						AbsolutX = GetXFromAngleAndRelDist( 75.00, 0.45 ),
						AbsolutY = GetYFromAngleAndRelDist( 75.00, 0.45 ),
					},
					-- village
					Childs = {},
				},
			},
		}
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- define additional resource and village placement here
	function RMG.FillPlayerStruct()
		
		local noiseMin = RMG.GenerationData.ThresholdCoast
		local noiseMax = RMG.GenerationData.ThresholdHill
		
		local noiseIron = RMG.GenerationData.ThresholdHill
		local noiseSulfur = RMG.GenerationData.ThresholdCoast

		local resoff = 10
		local dist = 40
		
		--vc
		for i = 1, 3 do
			
			local placement
			
			-- the 3rd vc will have a fix location on the small island
			if i < 3 then
				placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.TerrainBaseHeight,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
				}
			else
				placement = {
					AreaMin = 0,
					AreaMax = 12,
					Noise = RMG.GenerationData.TerrainBaseHeight,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
				}
			end
			
			local child = {
				Placement = placement,
				Data = RMG.StructureSets.NeutralVillageCenter,
			}
			if i == 1 then
				child.Childs = {{Data = {Entities = {{Type = Entities.PB_VillageCenter1, SkipDummy = true}}}}}
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[i].Childs, child)
		end
		
		-- clay
		for i = 1, 1 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.ThresholdCoast,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.ClayPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.ClayPile,
						Childs = {},
					},
				},
			}
			
			for j = 1, 3 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.ClayPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs, child)
		end
		
		-- stone
		for i = 1, 1 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.ThresholdHill,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.StonePit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.StonePile,
						Childs = {},
					},
				},
			}
			
			for j = 1, 3 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.StonePile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs, child)
		end
		
		-- wood
		for i = 2, 3 do
			
			-- 1 = first island, i = clay or stone pit, 1 = first pile, Childs = other piles
			table.insert(RMG.StructureSets.PlayerStruct.Childs[1].Childs[i].Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.WoodPileExplored,})
		end
		
		-- iron
		for i = 1, 2 do
		
			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = noiseIron,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.IronPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.IronPile,
						Childs = {},
					}
				},
			}
			
			for j = 1, 1 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.IronPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[2].Childs, child)
		end
		
		-- sulfur
		for i = 1, 1 do

			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = noiseSulfur,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.SulfurPit,
				Childs = {
					{
						Placement = RMG.StructureSets.Placement.PileAtPit,
						Data = RMG.StructureSets.SulfurPile,
						Childs = {},
					}
				},
			}
			
			for j = 1, 1 do
				table.insert(child.Childs[1].Childs, {Placement = RMG.StructureSets.Placement.PileAtPile, Data = RMG.StructureSets.SulfurPile,})
			end

			table.insert(RMG.StructureSets.PlayerStruct.Childs[2].Childs, child)
		end
		
		-- gold
		for i = 1, 1 do

			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = noiseSulfur,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
					Grid = 4,
				},
				Data = RMG.StructureSets.GoldPit,
			}
			
			table.insert(RMG.StructureSets.PlayerStruct.Childs[2].Childs, child)
		end
		
		-- lighthouse
		for i = 1, 1 do

			local child = {
				Placement = {
					AreaMin = dist - resoff,
					AreaMax = dist + resoff,
					Noise = RMG.GenerationData.TerrainBaseHeight,
					NoiseMin = noiseMin,
					NoiseMax = noiseMax,
				},
				Data = RMG.StructureSets.NeutralLighthouse,
			}
			
			table.insert(RMG.StructureSets.PlayerStruct.Childs[3].Childs, child)
		end
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	RMG.FillNoiseTable_Orig = RMG.FillNoiseTable
	function RMG.FillNoiseTable( _generationdata )
		
		RMG.FillNoiseTable_Orig( _generationdata )
		
		-- custom stuff here
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		-- flatten middle and main connectors
		local innerrange = Round( maphalf * 0.15 ) - 15
		local outerrange = innerrange + 45
		
		RMG.FlattenArea( _generationdata, maphalf, maphalf, innerrange, outerrange )
		RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 135.00, 0.55 ), GetYFromAngleAndRelDist( 135.00, 0.55 ), innerrange, outerrange )
		RMG.FlattenArea( _generationdata, GetXFromAngleAndRelDist( 315.00, 0.55 ), GetYFromAngleAndRelDist( 315.00, 0.55 ), innerrange, outerrange )
		
		-- flatten corners
		local innerrange = Round( maphalf * 0.20 ) - 15
		local outerrange = innerrange + 45
		
		local low, high = 0.175, 0.825
		
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * low  ), Round( mapsize * low  ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * high ), Round( mapsize * low  ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * low  ), Round( mapsize * high ), innerrange, outerrange, -0.352147606136882, 0.10 )
		RMG.SimpleNoiseOverride( _generationdata, Round( mapsize * high ), Round( mapsize * high ), innerrange, outerrange, -0.352147606136882, 0.10 )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	RMG.SetTerrainTextures_Orig = RMG.SetTerrainTextures
	function RMG.SetTerrainTextures( _generationdata )
		
		local maphalf = Logic.WorldGetSize() / 200
		
		-- flatten outer connectors
		local innerrange = Round( maphalf * 0.1 ) - 15
		local outerrange = innerrange + 30
		
		-- this needs to be done after rivers and roads have been calculated
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist(  70.00, 0.57 ), GetYFromAngleAndRelDist(  70.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist( 200.00, 0.57 ), GetYFromAngleAndRelDist( 200.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist( 250.00, 0.57 ), GetYFromAngleAndRelDist( 250.00, 0.57 ), innerrange, outerrange, 2356 )
		RMG.SimpleHeightOverride( _generationdata, GetXFromAngleAndRelDist(  20.00, 0.57 ), GetYFromAngleAndRelDist(  20.00, 0.57 ), innerrange, outerrange, 2356 )
		
		RMG.SetTerrainTextures_Orig( _generationdata )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FlattenArea( _generationdata, _X, _Y, _InnerRange, _OuterRange )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		-- flatten middle
		local _InnerRange = Round( maphalf * 0.15 ) - 15
		local _OuterRange = _InnerRange + 45
		
		local minnoise, maxnoise = 1, -1
		local noiseaverage = 0
		local n = 0
		
		for x = -_InnerRange, _InnerRange do
			for y = -_InnerRange, _InnerRange do
				
				local noise = _generationdata.TerrainNodes[ x + _X ][ y + _Y ].HeightNoise
				
				minnoise = math.min( minnoise, noise )
				maxnoise = math.max( maxnoise, noise )
				
				noiseaverage = noiseaverage + noise
				n = n + 1
			end
		end
		
		noiseaverage = noiseaverage / n
		
		local noiserange = maxnoise - minnoise
		local func =	function( _noise, _targetrange, _targetnoise, _offset )
							return math.min( ( _noise - _offset ) * _targetrange + _targetnoise, -0.396626934498992 )
						end
		
		RMG.SimpleNoiseOverride( _generationdata, _X, _Y, _InnerRange, _OuterRange, -0.399297853124962, 0.10 / noiserange, nil, nil, func, noiseaverage )
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FillRiverLocationTable( _generationData )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2

		_generationData.Rivers.StartPoints = {
			{ X = maphalf * 1.00 * math.cos( math.rad(  45.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad(  45.00 ) ) + maphalf },
			{ X = maphalf * 1.00 * math.cos( math.rad(  90.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad(  90.00 ) ) + maphalf },
			
			{ X = maphalf * 1.00 * math.cos( math.rad( 180.00 ) ) + maphalf, Y = maphalf * 1.00 * math.sin( math.rad( 180.00 ) ) + maphalf },
			{ X = maphalf * 0.67 * math.cos( math.rad(  45.00 ) ) + maphalf, Y = maphalf * 0.67 * math.sin( math.rad(  45.00 ) ) + maphalf },
			
			{ X = maphalf * 0.60 * math.cos( math.rad(  57.50 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad(  57.50 ) ) + maphalf }, -- -10
			{ X = maphalf * 0.60 * math.cos( math.rad(  90.00 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad(  90.00 ) ) + maphalf },
			
			{ X = maphalf * 0.59 * math.cos( math.rad( 123.75 ) ) + maphalf, Y = maphalf * 0.59 * math.sin( math.rad( 123.75 ) ) + maphalf },
			{ X = maphalf * 0.59 * math.cos( math.rad( 146.25 ) ) + maphalf, Y = maphalf * 0.59 * math.sin( math.rad( 146.25 ) ) + maphalf },

			{ X = maphalf * 0.60 * math.cos( math.rad( 180.00 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad( 180.00 ) ) + maphalf },
			{ X = maphalf * 0.60 * math.cos( math.rad( 212.50 ) ) + maphalf, Y = maphalf * 0.60 * math.sin( math.rad( 212.50 ) ) + maphalf }, -- +10
			-- technically a double, but is required
			{ X = maphalf * 0.67 * math.cos( math.rad( 225.00 ) ) + maphalf, Y = maphalf * 0.67 * math.sin( math.rad( 225.00 ) ) + maphalf },
			
			{ X = maphalf * 0.15 * math.cos( math.rad(  68.75 ) ) + maphalf, Y = maphalf * 0.15 * math.sin( math.rad(  68.75 ) ) + maphalf }, -- -10
			{ X = maphalf * 0.15 * math.cos( math.rad( 201.25 ) ) + maphalf, Y = maphalf * 0.15 * math.sin( math.rad( 201.25 ) ) + maphalf }, -- +10
			
		}
		for _,v in ipairs( _generationData.Rivers.StartPoints ) do
			v.X, v.Y = SnapToGrid( 4, v.X, v.Y )
		end
		
		_generationData.Rivers.Paths = 
		{
			{  4,  1 },
			{  6,  2 },
			{  9,  3 },
			
			{  4,  5 },
			{  5,  6 },
			
			{  6,  7 },
			{ 11, 10 },
			{ 10,  9 },
			
			{  9,  8 },
			
			{  5, 12 },
			{  6, 12 },
			
			{  9, 13 },
			{ 10, 13 },
		}
		_generationData.Rivers.MirrorRadea = { math.rad( 180 ) }
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.FillRoadLocationTable( _generationData )
		
		local mapsize = Logic.WorldGetSize() / 100
		local maphalf = mapsize / 2
		
		_generationData.Roads.StartPoints = {
			-- player 1
			{ X = maphalf * 0.75 * math.cos( math.rad( 112.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 112.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad(  67.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad(  67.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad(  75.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad(  75.00 ) ) + maphalf }, -- -15
			-- player 2
			{ X = maphalf * 0.75 * math.cos( math.rad( 157.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 157.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad( 202.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad( 202.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad( 195.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad( 195.00 ) ) + maphalf }, -- +15
			-- team 1
			{ X = maphalf * 0.37 * math.cos( math.rad( 135.00 ) ) + maphalf, Y = maphalf * 0.37 * math.sin( math.rad( 135.00 ) ) + maphalf },
			-- player 3
			{ X = maphalf * 0.75 * math.cos( math.rad( 292.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 292.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad( 247.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad( 247.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad( 255.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad( 255.00 ) ) + maphalf }, -- -15
			-- player 4
			{ X = maphalf * 0.75 * math.cos( math.rad( 337.50 ) ) + maphalf, Y = maphalf * 0.75 * math.sin( math.rad( 337.50 ) ) + maphalf },
			{ X = maphalf * 0.90 * math.cos( math.rad(  22.50 ) ) + maphalf, Y = maphalf * 0.90 * math.sin( math.rad(  22.50 ) ) + maphalf },
			{ X = maphalf * 0.35 * math.cos( math.rad(  15.00 ) ) + maphalf, Y = maphalf * 0.35 * math.sin( math.rad(  15.00 ) ) + maphalf }, -- +15
			-- team 2
			{ X = maphalf * 0.37 * math.cos( math.rad( 315.00 ) ) + maphalf, Y = maphalf * 0.37 * math.sin( math.rad( 315.00 ) ) + maphalf },
		}
		for _,v in ipairs( _generationData.Roads.StartPoints ) do
			v.X, v.Y = SnapToGrid( 4, v.X, v.Y )
		end
		
		_generationData.Roads.Paths = {
			{ 1, 2 },
			{ 2, 3 },
			{ 4, 5 },
			{ 5, 6 },
			{ 3, 7 },
			{ 6, 7 },
			
			{  8,  9 },
			{  9, 10 },
			{ 11, 12 },
			{ 12, 13 },
			{ 10, 14 },
			{ 13, 14 },
		}
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.SetCameraStart( _player )
		
		local _, hq = Logic.GetPlayerEntities( _player.Id, Entities.PB_Headquarters1, 1 )
		local pos = GetPosition( hq )
		
		Camera.ScrollSetLookAt( pos.X, pos.Y)
	end
	------------------------------------------------------------------------------------------------------------------------------------------------------------
	function RMG.DeleteBridges()
		
		local bridges = {}
		
		for bridge in CEntityIterator.Iterator() do
			if Logic.IsEntityInCategory( EntityCategories.Bridge ) == 1 then
				table.insert( bridges, bridge )
			end
		end
		
		-- sort by distance to middle
		table.sort( bridges,
			function ( a, b )
				local maphalf = Logic.WorldGetSize() / 2
				local xa, ya = Logic.GetEntityPosition( a )
				local xb, yb = Logic.GetEntityPosition( b )
				return ( ( xa - maphalf ) ^ 2 + ( ya - maphalf ) ^ 2 ) < ( ( xb - maphalf ) ^ 2 + ( yb - maphalf ) ^ 2 )
			end
		)
		
		-- delete the 8 closest bridges - lazy but it works
		for i = 1, 8 do
			Logic.DestroyEntity( bridges[ i ] )
		end
	end
	
	RMG.LandscapeSets.Tideland.Water = WaterTypes.European_NonFreezing_Shorewave
end