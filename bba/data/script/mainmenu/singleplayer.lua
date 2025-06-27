----------------------------------------------------------------------------------------------------
-- Single player menu page ids:
--
-- 00: Single player main menu screen
-- 10: Camapign screen
-- 20: Custom map screen
-- 21: Random map screen
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
function SPMenu.S00_ToRandomMap()
	-- Show screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu21", 1)
	--
	SPMenu.S21_Init()
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
SPMenu.S21_AISettings = {
	["Strength"] 	= {"Schwach", "Mittel", "Stark"},
	["TechLVL"]		= {"Niedrig", "Mittel", "Hoch", "Sehr hoch"},
	["Peacetime"]	= {0, 10, 20, 30, 40, 50, 60, 70, 80, 90},
	["Team"]		= {1, 2, 3, 4, 5, 6, 7, 8}
}
SPMenu.S21_SettingData = {
	["MapSetting"] 			= {"Europäisch", "Hochland", "Evelance", "Mediterran", "Moor", "Küste", "Steppe"},
	["MapHeroes"]			= {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
	["MapSize"]				= {384, 480, 576, 672, 768},
	["MapKey"]				= {function() math.randomseed(XGUIEng.GetSystemTime()); return math.floor(math.ldexp(math.random(), math.random(10,20))*math.random(1,99))  end},
	["MapVC"]				= {"Wenige", "Moderat", "Viele"},
	["MapResources"]		= {"Wenige", "Moderat", "Viele"},
	["MapResourceWealth"]	= {"Knapp", "Unterdurchschnittlich", "Gewöhnlich", "Überdurchschnittlich", "Üppig"},
	["MapStart"]			= {"Wenige", "Moderat", "Viele"},
	["MapMirror"]			= {"Nein", "Ja"},
	["MapAI_1_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_1_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_1_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_1_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_1_Active"]		= {false, true},
	["MapAI_2_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_2_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_2_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_2_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_2_Active"]		= {false, true},
	["MapAI_3_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_3_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_3_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_3_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_3_Active"]		= {false, true},
	["MapAI_4_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_4_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_4_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_4_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_4_Active"]		= {false, true},
	["MapAI_5_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_5_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_5_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_5_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_5_Active"]		= {false, true},
	["MapAI_6_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_6_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_6_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_6_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_6_Active"]		= {false, true},
	["MapAI_7_Strength"]	= SPMenu.S21_AISettings.Strength,
	["MapAI_7_TechLVL"]		= SPMenu.S21_AISettings.TechLVL,
	["MapAI_7_Peacetime"]	= SPMenu.S21_AISettings.Peacetime,
	["MapAI_7_Team"]		= SPMenu.S21_AISettings.Team,
	["MapAI_7_Active"]		= {false, true}
}
SPMenu.S21_SettingDefaultIndex = {
	["MapSize"]				= 3,
	["MapVC"]				= 2,
	["MapResources"]		= 2,
	["MapResourceWealth"]	= 3,
	["MapStart"]			= 2
}

function SPMenu.S21_Init()
	SPMenu.S21_CurrSetting = {}
	for k, v in pairs(SPMenu.S21_SettingData) do
		if SPMenu.S21_SettingDefaultIndex[k] then
			SPMenu.S21_CurrSetting[k] = SPMenu.S21_SettingDefaultIndex[k]
		else
			SPMenu.S21_CurrSetting[k] = 1
		end
	end
	for k, v in pairs(SPMenu.S21_CurrSetting) do
		local widget = "SPM21_" .. k .. "_Title"
		if XGUIEng.IsWidgetExisting(widget) == 1 then
			local text = SPMenu.S21_SettingData[k][v]
			if type(text) == "function" then
				text = SPMenu.S21_SettingData[k][v]()
			end
			text = "@center " .. text
			XGUIEng.SetText(widget, text)
		end
	end
end
function SPMenu.S21_NextSetting(_Setting)

	local widget = XGUIEng.GetCurrentWidgetID()
	local root = XGUIEng.GetWidgetsMotherID(widget)
	local index = math.min(SPMenu.S21_CurrSetting[_Setting] + 1, table.getn(SPMenu.S21_SettingData[_Setting]))
	SPMenu.S21_CurrSetting[_Setting] = index
	local text = SPMenu.S21_SettingData[_Setting][index]
	if type(text) == "function" then
		text = SPMenu.S21_SettingData[_Setting][index]()
	end
	XGUIEng.SetText(CWidget.GetName(root) .. "_Title", "@center " .. text)
end
function SPMenu.S21_PrevSetting(_Setting)

	local widget = XGUIEng.GetCurrentWidgetID()
	local root = XGUIEng.GetWidgetsMotherID(widget)
	local index = math.max(SPMenu.S21_CurrSetting[_Setting] - 1, 1)
	SPMenu.S21_CurrSetting[_Setting] = index
	local text = SPMenu.S21_SettingData[_Setting][index]
	if type(text) == "function" then
		text = SPMenu.S21_SettingData[_Setting][index]()
	end
	XGUIEng.SetText(CWidget.GetName(root) .. "_Title", "@center " .. text)
end
function SPMenu.S21_EnableAI(_slot)

	XGUIEng.ShowWidget("SPM21_MapAI_" .. _slot, 1)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Enable", 0)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Disable", 1)
	--
	SPMenu.S21_CurrSetting["MapAI_" .. _slot .. "_Active"] = 2
end
function SPMenu.S21_DisableAI(_slot)

	XGUIEng.ShowWidget("SPM21_MapAI_" .. _slot, 0)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Enable", 1)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Disable", 0)
	--
	SPMenu.S21_CurrSetting["MapAI_" .. _slot .. "_Active"] = 1
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
