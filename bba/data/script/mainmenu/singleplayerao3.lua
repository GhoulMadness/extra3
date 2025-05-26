
function SPMenu.EasyButton()
	local GDBKeyName = 	"Game\\Extra3\\CampaignDifficulty"
	GDB.SetValue( GDBKeyName, 3 )	
	XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",1)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",0)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",0)
end
function SPMenu.NormalButton()
	local GDBKeyName = 	"Game\\Extra3\\CampaignDifficulty"
	GDB.SetValue( GDBKeyName, 2 )	
	XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",0)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",1)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",0)
end
function SPMenu.HardButton()
	local GDBKeyName = 	"Game\\Extra3\\CampaignDifficulty"
	GDB.SetValue( GDBKeyName, 1 )	
	XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",0)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",0)
	XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",1)
end
----------------------------------------------------------------------------------------------------
-- Show campaign screen

function SPMenu.S00_ToAO2CampaignMenu()	
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu50", 1)
end
function SPMenu.S00_ToAO2exCampaignMenu()	
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu80", 1)
	SPMenu.S80_UpdateCampaign2exMaps()
end
----------------------------------------------------------------------------------------------------
-- Show ex3 campaign screen
function SPMenu.S00_ToAO3CampaignMenu()	
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu70", 1)
	SPMenu.S70_UpdateCampaign3_Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Shores in flames
function
SPMenu.S05_ToAO2Campaign01Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu60", 1)	
	SPMenu.S60_UpdateCampaign2_1Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Emerald Battles
function
SPMenu.S05_ToAO2Campaign02Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu61", 1)	
	SPMenu.S61_UpdateCampaign2_2Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues The Evil lurks within
function
SPMenu.S05_ToAO2Campaign03Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu62", 1)	
	SPMenu.S62_UpdateCampaign2_3Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Vision of Light
function
SPMenu.S05_ToAO2Campaign04Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu63", 1)	
	SPMenu.S63_UpdateCampaign2_4Maps()
end






