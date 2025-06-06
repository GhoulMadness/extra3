-- Load support file
Script.Load(Folders.MapTools.."Ai\\Support.lua")

-- Load mission script libs
IncludeGlobals("Quests")
IncludeGlobals("Comfort")
IncludeGlobals("NPC")
IncludeGlobals("Information")
IncludeGlobals("PlayerColors")
IncludeGlobals("CutsceneNames")
IncludeGlobals("DynamicFog")
IncludeGlobals("Extra2Comfort")
Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua")
if not CNetwork then
	gvDiffLVL = GDB.GetValue("Game\\Extra3\\CampaignDifficulty")
end
function GameCallback_OnGameStart()

	-- Include global tool script functions
	IncludeGlobals("GlobalMissionScripts")

	-- Load trigger conditions
	IncludeGlobals("Conditions")

	-- Load String table tool
	IncludeGlobals("String")


	-- Load timer functions
	IncludeGlobals("Counter")

	-- Load explore functions
	IncludeGlobals("Explore")

	-- Load weather sets
	IncludeGlobals("WeatherSets")

	IncludeGlobals("tools\\BSinit")

	--preload all models
	Display.LoadAllModels()

	--Stop the music still played by the main menu
	Music.Stop()

	-- Global mission initializing
	GlobalMissionScripting.OnGameStart()

	-- Init mission main data table
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

	--Set Human Player flag
	Logic.PlayerSetIsHumanFlag(gvMission.PlayerID, 1)
	Logic.PlayerSetGameStateToPlaying(gvMission.PlayerID)

	-- Init diplomacy
	if Mission_InitDiplomacy ~= nil then
		Mission_InitDiplomacy()
	elseif InitDiplomacy ~= nil then
		InitDiplomacy()
	end

	-- Init resources
	if Mission_InitResources ~= nil then
		Mission_InitResources()
	elseif InitResources ~= nil then
		InitResources()
	end

	-- Init technologies
	if Mission_InitTechnologies ~= nil then
		Mission_InitTechnologies()
	elseif InitTechnologies ~= nil then
		InitTechnologies()
	end

	-- Init ai of mission
	if Mission_InitAI ~= nil then
		Mission_InitAI()
	end

	--Setup weather gfx sets for all maps is needed for the weathermachine
	--Mission_InitWeatherGfxSetsForAllMaps()

	-- Setup weather gfx sets
	if InitWeatherGfxSets ~= nil then
		InitWeatherGfxSets()
	elseif Mission_InitWeatherGfxSets ~= nil then
		Mission_InitWeatherGfxSets()
	end

	-- Init weather periods
	if InitWeather ~= nil then
		InitWeather()
	elseif Mission_InitWeather ~= nil then
		Mission_InitWeather()
	end


	if Mission_InitPlayerColorMapping ~= nil then
		Mission_InitPlayerColorMapping()
	elseif InitPlayerColorMapping ~= nil then
		InitPlayerColorMapping()
	end

	-- Tribute Jingle sound
	SetupTributeJingle()

	-- Call first action
	if Mission_FirstMapAction ~= nil then
		Mission_FirstMapAction()
	elseif FirstMapAction ~= nil then
		FirstMapAction()
	end

	if not CNetwork then
		math.randomseed(Game.RealTimeGetMs())
		local tab = ChestRandomPositions.CreateChests()
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	end
	if not gvTestFlag then
		InitGeneralAchievementsCheck()
	end
end

function Mission_OnSaveGameLoaded()
	--first re init gfx sets for all maps
	Mission_InitWeatherGfxSetsForAllMaps()

	-- Re init weather gfx sets in the map script (can overwrite Mission_InitWeatherGfxSetsForAllMaps)
	if InitWeatherGfxSets ~= nil then
		InitWeatherGfxSets()
	elseif Mission_InitWeatherGfxSets ~= nil then
		Mission_InitWeatherGfxSets()
	end

	if Mission_InitPlayerColorMapping ~= nil then
		Mission_InitPlayerColorMapping()
	elseif InitPlayerColorMapping ~= nil then
		InitPlayerColorMapping()
	end

	MainWindow_LoadGame_Done()

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function Mission_InitWeather()

	-- Init with gfx set 1
	Logic.SetupGfxSet(1)

	-- Only summer weather period
	Logic.AddWeatherElement(1, 5, 1, 1, 5, 10)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Dummy function to allow tribute in maps
function GameCallback_FulfillTribute(_PlayerID, _TributeID )
	-- Tribute is allowed
	return 1
end
