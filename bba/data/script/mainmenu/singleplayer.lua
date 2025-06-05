----------------------------------------------------------------------------------------------------
-- Single player menu page ids:
--
-- 00: Single player main menu screen
-- 10: Camapign screen
-- 20: Custom map screen
-- 30: Load map screen
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------
-- Table containing ALL multiplayer menu stuff
SPMenu = {}

----------------------------------------------------------------------------------------------------
-- Show custom map screen

function SPMenu.S00_ToCustomMap()

	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu19", 1)
end
function SPMenu.S00_ToCustomMapSP()
	SelectedCustomMapsMode = 1
	LoadMap.Init()
	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu20", 1)
end
function SPMenu.S00_ToCustomMapMPPvP()
	SelectedCustomMapsMode = 2
	LoadMap.Init()
	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu20", 1)
end
function SPMenu.S00_ToCustomMapMPPvE()
	SelectedCustomMapsMode = 3
	LoadMap.Init()
	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu20", 1)
end
--
function SPMenu.S00_ToSingleplayerMenuS19()
	
	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu19", 1)
end

----------------------------------------------------------------------------------------------------
-- Show savegame screen

function SPMenu.S00_ToLoadSaveGame()
	
	-- Show screen	
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu30", 1)
	LoadSaveGame.Init()

end

----------------------------------------------------------------------------------------------------
-- General GUI functions
----------------------------------------------------------------------------------------------------
-- SP canceled

function SPMenu.GEN_Button_Cancel()
		
	-- To start menu
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "StartMenu00", 1 )


end


----------------------------------------------------------------------------------------------------
