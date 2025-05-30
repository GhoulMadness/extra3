--------------------------------------------------------------------------------
-- MapName: XXX
--
-- Author: XXX
--
--------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (1000)
    AddSulfur(2000)
    AddIron  (3000)
    AddWood  (4000)	
    AddStone (5000)	
    AddClay  (6000)	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
	AddPeriodicSummer(10)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
end
	
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	local VictoryConditionType = 1

	if VictoryConditionType == 1 then
		MapEditor_SetupResourceVictoryCondition(	
													2000,
													7000,
													5000,
													6000,
													4000,
													3000 ) 
	elseif VictoryConditionType == 2 then
		MapEditor_SetupDestroyVictoryCondition(2)
	end

	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(3, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(4, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(5, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(6, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(7, 0, 0, 0, "", 0, 0)
	MapEditor_SetupAI(8, 0, 0, 0, "", 0, 0)

	-- HQ Defeat Condition
	MapEditor_CreateHQDefeatCondition()

end

-- Quest data
MapEditor_QuestTitle				= ""
MapEditor_QuestDescription 	= "" 