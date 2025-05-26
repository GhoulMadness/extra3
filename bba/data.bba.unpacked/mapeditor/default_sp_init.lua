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
    AddGold  (#RES_GOLD#)
    AddSulfur(#RES_SULFUR#)
    AddIron  (#RES_IRON#)
    AddWood  (#RES_WOOD#)	
    AddStone (#RES_STONE#)	
    AddClay  (#RES_CLAY#)	
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

	local VictoryConditionType = #VICTORY_CONDITION#

	if VictoryConditionType == 1 then
		MapEditor_SetupResourceVictoryCondition(	
													#VICTORY_GOLD#,
													#VICTORY_CLAY#,
													#VICTORY_WOOD#,
													#VICTORY_STONE#,
													#VICTORY_IRON#,
													#VICTORY_SULFUR# ) 
	elseif VictoryConditionType == 2 then
		MapEditor_SetupDestroyVictoryCondition(#VICTORY_PLAYERID#)
	end

	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, #AI2_LEVEL#, #AI2_RANGE#, #AI2_TECHLEVEL#, #AI2_POSITION#, #AI2_AGGRESSIVELEVEL#, #AI2_PEACETIME#)
	MapEditor_SetupAI(3, #AI3_LEVEL#, #AI3_RANGE#, #AI3_TECHLEVEL#, #AI3_POSITION#, #AI3_AGGRESSIVELEVEL#, #AI3_PEACETIME#)
	MapEditor_SetupAI(4, #AI4_LEVEL#, #AI4_RANGE#, #AI4_TECHLEVEL#, #AI4_POSITION#, #AI4_AGGRESSIVELEVEL#, #AI4_PEACETIME#)
	MapEditor_SetupAI(5, #AI5_LEVEL#, #AI5_RANGE#, #AI5_TECHLEVEL#, #AI5_POSITION#, #AI5_AGGRESSIVELEVEL#, #AI5_PEACETIME#)
	MapEditor_SetupAI(6, #AI6_LEVEL#, #AI6_RANGE#, #AI6_TECHLEVEL#, #AI6_POSITION#, #AI6_AGGRESSIVELEVEL#, #AI6_PEACETIME#)
	MapEditor_SetupAI(7, #AI7_LEVEL#, #AI7_RANGE#, #AI7_TECHLEVEL#, #AI7_POSITION#, #AI7_AGGRESSIVELEVEL#, #AI7_PEACETIME#)
	MapEditor_SetupAI(8, #AI8_LEVEL#, #AI8_RANGE#, #AI8_TECHLEVEL#, #AI8_POSITION#, #AI8_AGGRESSIVELEVEL#, #AI8_PEACETIME#)

	-- HQ Defeat Condition
	MapEditor_CreateHQDefeatCondition()

end

-- Quest data
MapEditor_QuestTitle				= #QUEST_TITLE#
MapEditor_QuestDescription 	= #QUEST_DESCRIPTION#