-- ###################################################################################################
-- #                                                                                                 #
-- #                                                                                                 #
-- #     Mapname:  (4) EMSBS RMG Gezeiten                                                              #
-- #                                                                                                 #
-- #     Author:   RobbiTheFox                                                                       #
-- #                                                                                                 #
-- #     Script:   Enhanced Multiplayer Script by MadShadow                                          #
-- #                                                                                                 #
-- #                                                                                                 #
-- ###################################################################################################

initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not initEMS() then
		local errMsgs =
		{
			["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr \195\156berpr\195\188fe ob alle Dateien am richtigen Ort sind!",
			["eng"] = "Attention: Enhanced Multiplayer Script could not be found! @cr Make sure you placed all the files in correct place!",
		}
		local lang = "de";
		if XNetworkUbiCom then
			lang = XNetworkUbiCom.Tool_GetCurrentLanguageShortName();
			if lang ~= "eng" and lang ~= "de" then
				lang = "eng";
			end
		end
		GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
		GUI.AddStaticNote("@color:255,0,0 " .. errMsgs[lang]);
		GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
		return;
end
-- ************************************************************************************************
-- *                                                                                              *
-- *                                                                                              *
-- *                                              EMS                                             *
-- *                                         CONFIGURATION                                        *
-- *                                                                                              *
-- *                                                                                              *
-- ************************************************************************************************

gvEMSFlag = 1
EMS_CustomMapConfig =
{
	-- version is set by the generator
	Version = 1.0,
	-- ********************************************************************************************
	-- * Callback_OnMapStart
	-- * this function is called directly after the loading screen vanishes
	-- * it's a replacement for FirstMapAction/GameCallback_OnGameSart
	-- * use for initialisation
	-- ********************************************************************************************

	Callback_OnMapStart = function()
		IncludeGlobals("Tools\\BSinit")
		--TagNachtZyklus(48,0,0,0,1)

		MapTools.RemoveFastGameEntities()

		AddPeriodicSummer(10);
		SetupNormalWeatherGfxSet();
		LocalMusic.UseSet = MEDITERANEANMUSIC;

		Script.Load( "extra2\\shr\\maps\\user\\EMS\\tools\\s5CommunityLib\\fixes\\TriggerFix.lua" )
		Script.Load( "extra2\\shr\\maps\\user\\EMS\\tools\\s5CommunityLib\\comfort\\number\\round.lua" )

		MapTools.CreateWoodPiles(15000);

		function EMS.RD.Rules.Peacetime:SetValue() return end
		function EMS.RD.Rules.AttractionLimitFix:SetValue() return end

		for id in CEntityIterator.Iterator( CEntityIterator.OfTypeFilter( Entities.XD_ScriptEntity ) ) do

			local name = GetEntityName( id )

			if name == "rmg_explore" then
				Logic.SetEntityExplorationRange( id, 10 )
			end
		end

		local resourceamounts = {
			{ Resource = Entities.XD_Clay1,   Amount = 4000 },
			{ Resource = Entities.XD_Stone1,  Amount = 4000 },
			{ Resource = Entities.XD_Iron1,   Amount = 4000 },
			{ Resource = Entities.XD_Sulfur1, Amount = 4000 },
			{ Resource = Entities.XD_Silver1, Amount =   10 },
			{ Resource = Entities.XD_ClayPit1,   Amount = 50000 },
			{ Resource = Entities.XD_StonePit1,  Amount = 50000 },
			{ Resource = Entities.XD_IronPit1,   Amount = 30000 },
			{ Resource = Entities.XD_SulfurPit1, Amount = 50000 },
			{ Resource = Entities.XD_SilverPit1, Amount =  1000 },
			{ Resource = Entities.XD_GoldPit1,   Amount = 50000 },
		}
		for _,v in pairs( resourceamounts ) do
			for id in CEntityIterator.Iterator( CEntityIterator.OfTypeFilter( v.Resource ) ) do
				Logic.SetResourceDoodadGoodAmount( id, v.Amount )
			end
		end
	end,

	-- ********************************************************************************************
	-- * Callback_OnGameStart
	-- * called when the players start the actual game by pressing the start button
	-- * and after the 10 seconds of countdown
	-- ********************************************************************************************
	Callback_OnGameStart = function()

		for id in CEntityIterator.Iterator( CEntityIterator.OfTypeFilter( Entities.XD_ScriptEntity ) ) do

			local name = GetEntityName( id )

			if not name or name == "rmg_explore" then
				DestroyEntity( id )
			end
		end

		-- start timeline
		LowerWater1()
	end,

	-- ********************************************************************************************
	-- * Callback_OnPeacetimeEnded
	-- * Called after the peace time ends
	-- ********************************************************************************************
	Callback_OnPeacetimeEnded = function()
	end,

	Peacetime = 0,

	LightCavalry = 2,
	HeavyCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,

	-- ********************************************************************************************
	--  			GameModes
	-- add as many items as you want = {"3vs3", "2vs2", "1vs1"},
	-- the callback will return you the index of the selected gamemode
	-- between 1 - max nr
	-- allows you to modify the game depending on the chosen gamemode
	-- GameMode determines the preselected value;
	GameMode = 1,
	GameModes = {"Standard"},
	Callback_GameModeSelected = function(_gamemode)
	end,

	-- ********************************************************************************************
	-- * Resource Level ( 1 = Normal, 2 = FastGame, 3 = SpeedGame )
	-- * Setting the resource level to either one, two or three will give the players the ressources
	-- * specified in the table below.
	-- * You can specify the resources for each gamemode
	-- ********************************************************************************************
	--[[
		Ressources
		You can specify the ressources for a player in one of the tables Normal, FastGame, SpeedGame
		by adding a key entry with the playerId containing 6 entries which either contain a number
		or a function that returns a number as amount for the respective ressource
		If a player is not specified, he will get the ressources of player 1
		So if you want to give the same amount of ressources to all players, just specify player 1
	]]
	ResourceLevel = 1,

	Ressources =
	{
		Normal = {
			[1] = {
				500,
				2400,
				1750,
				700,
				50,
				50,
			},
		},
	},

	-- ********************************************************************************************
	-- * Callback_OnFastGame
	-- * this function will be called alongside with Callback_OnGameStart
	-- * if the players selected fastgame or speedgame
	-- ********************************************************************************************
	Callback_OnFastGame = function()
		MapTools.RecreateFastGameEntities()
	end,

	-- ********************************************************************************************
	-- * AI Players
	-- * specify AI players to make sure their entities won't be deleted on game start
	-- ********************************************************************************************
	AIPlayers = {},
};
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- timeline
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- 0 - 50
function LowerWater1()
	ChangeWaterHeight.Start( 2500, 2356, 36 * 60, LowerWater2 )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- raise update speed in the time where its likely that larger areas become walkable at the same time
function LowerWater2()
	ChangeWaterHeight.Start( 2356, 2348, 2 * 60, LowerWater3, nil, 10 )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function LowerWater3()
	ChangeWaterHeight.Start( 2348, 2300, 12 * 60, Wait1 )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 50 - 70
function Wait1()
	StartSimpleJob( Wait1_Job )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Wait1_Job()
	if Counter.Tick2( "Wait1", 20 * 60 ) then
		LowerWater4()
		return true
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 70 - 120
function LowerWater4()
	ChangeWaterHeight.Start( 2300, 2140, 40 * 60, LowerWater5 )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- raise update speed again when rivers are about to dry out
function LowerWater5()
	ChangeWaterHeight.Start( 2140, 2132, 2 * 60, Wait2, nil, 35 )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 120 - 180
function Wait2()
	StartSimpleJob( Wait2_Job )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Wait2_Job()
	if Counter.Tick2( "Wait2", 68 * 60 ) then
		--RaiseWater1()
		return true
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 180 ++
function RaiseWater1()
	ChangeWaterHeight.Start( 2100, 4100, 40 * 60, nil, true )
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- waterheight
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
ChangeWaterHeight = {}
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO: get _StartHeight from terrain info
function ChangeWaterHeight.Start( _StartHeight, _DestinationHeight, _DurationSeconds, _Callback, _FloodMines, _UpdateInterval )

	-- no duration? instant change!
	if not _DurationSeconds or _DurationSeconds <= 0 then
		_DurationSeconds = 1
	end

	-- no heights? no change!
	if not _DestinationHeight or not _StartHeight then
		return
	end

	-- fill table with all blocked nodes
	--if not ChangeWaterHeight.WaterBlockedNodes then
		--ChangeWaterHeight.InitWaterBlocking()
	--end

	-- save current state
	ChangeWaterHeight.ElapsedSeconds = 0
	ChangeWaterHeight.LastHeight = _StartHeight

	StartSimpleJob( ChangeWaterHeight.Job, _StartHeight, _DestinationHeight, ( _DestinationHeight - _StartHeight ) / _DurationSeconds, _Callback, _FloodMines, _UpdateInterval )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ChangeWaterHeight.Job( _StartHeight, _DestinationHeight, _ChangePerSecond, _Callback, _FloodMines, _UpdateInterval )

	ChangeWaterHeight.ElapsedSeconds = ChangeWaterHeight.ElapsedSeconds + 1
	local height = Round( _StartHeight + ( _ChangePerSecond * ChangeWaterHeight.ElapsedSeconds ) )

	if height ~= ChangeWaterHeight.LastHeight then --math.abs( height - ChangeWaterHeight.LastHeight ) >= 10 or height == _DestinationHeight then

		ChangeWaterHeight.LastHeight = height

		local mapsize = Logic.WorldGetSize() / 100
		Logic.WaterSetAbsoluteHeight( mapsize, mapsize, 0, 0, height )

		-- exclude pits from change
		if not _FloodMines then
			for id in CEntityIterator.Iterator( CEntityIterator.OfCategoryFilter( EntityCategories.ResourcePit ) ) do

				local x, y = Logic.GetEntityPosition( id )
				x, y = SnapToGrid( 4, x / 100, y / 100 )

				if Logic.GetEntityType( id ) == Entities.XD_ClayPit1 then
					Logic.WaterSetAbsoluteHeight( x - 4, y - 8, x + 4, y, 0 )
				elseif Logic.GetEntityType( id ) == Entities.XD_StonePit1 then
					Logic.WaterSetAbsoluteHeight( x - 4, y - 8, x + 4, y + 4, 0 )
				else
					Logic.WaterSetAbsoluteHeight( x - 4, y - 4, x, y, 0 )
				end
			end
		end

		CUtil.UpdateBlockingWholeMapNoHeight()
		--ChangeWaterHeight.UpdateWaterBlocking( _UpdateInterval )
		GUI.RebuildMinimapTerrain()

		if ( _DestinationHeight < _StartHeight and height <= _DestinationHeight ) or ( _DestinationHeight >= _StartHeight and height >= _DestinationHeight ) then

			if _Callback then
				_Callback()
			end

			return true
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ChangeWaterHeight.InitWaterBlocking()

	local mapsize = Logic.WorldGetSize() / 100 - 2
	local maphalf = Logic.WorldGetSize() / 200
	local maphalfsq = maphalf ^ 2

	ChangeWaterHeight.WaterBlockedNodes = {}

	for x = 1, mapsize do
		for y = 1, mapsize do
			if (x - maphalf) ^ 2 + (y - maphalf) ^ 2 < maphalfsq and CUtil.GetWaterHeight( x, y ) >= CUtil.GetTerrainNodeHeight( x, y ) then
				table.insert( ChangeWaterHeight.WaterBlockedNodes, { X = x, Y = y } )
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ChangeWaterHeight.UpdateWaterBlocking( _UpdateInterval )
	EndJob( ChangeWaterHeight.UpdateWaterBlockingJobId )
	ChangeWaterHeight.UpdateWaterBlockingJobId = StartSimpleHiResJob( ChangeWaterHeight.UpdateWaterBlockingJob, _UpdateInterval )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ChangeWaterHeight.UpdateWaterBlockingJob( _UpdateInterval )
	if ChangeWaterHeight.UpdateWaterBlockingInternal( _UpdateInterval ) then
		return true
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function ChangeWaterHeight.UpdateWaterBlockingInternal( _UpdateInterval )

	_UpdateInterval = _UpdateInterval or 5
	local n = 0

	for i = table.getn( ChangeWaterHeight.WaterBlockedNodes ), 1, -1 do

		local x, y = ChangeWaterHeight.WaterBlockedNodes[ i ].X, ChangeWaterHeight.WaterBlockedNodes[ i ].Y

		if CUtil.GetWaterHeight( x, y ) < CUtil.GetTerrainNodeHeight( x, y ) then

			Logic.UpdateBlocking( x, y, x + 1, y + 1 )
			table.remove( ChangeWaterHeight.WaterBlockedNodes, i )

			n = n + 1

			if n >= _UpdateInterval then
				return false
			end
		end
	end

	return true
end

function SnapToGrid(_grid, ...)
 for i,v in ipairs(arg) do
  arg[i] = math.floor(v / _grid + 0.5) * _grid
 end
 return unpack(arg)
end