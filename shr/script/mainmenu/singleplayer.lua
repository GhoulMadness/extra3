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
	["MapSetting"] 			= {"Europäisch", "Hochland", "Evelance", "Mediterran", "Moor", "Küste", "Steppe", "Wüste"},
	["MapHeroes"]			= {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	["MapSize"]				= {384, 480, 576, 672, 768},
	["MapKey"]				= {function() math.randomseed(XGUIEng.GetSystemTime()); return math.floor(math.ldexp(math.random(), math.random(10,20))*math.random(1,99))  end},
	["MapVC"]				= {"Wenige", "Moderat", "Viele"},
	["MapResources"]		= {"Wenige", "Moderat", "Viele"},
	["MapResourceWealth"]	= {"Knapp", "Unterdurchschnittlich", "Gewöhnlich", "Überdurchschnittlich", "Üppig"},
	["MapStart"]			= {"Wenige", "Moderat", "Viele", "Enorm viele"},
	["MapMirror"]			= {"Nein", "Ja"},
	["MapWeather"]			= {"Rau", "Unbeständig", "Gewöhnlich", "Stabil", "Dürre", "Monsun", "Blizzard"},
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
	["MapStart"]			= 2,
	["MapWeather"]			= 3
}
-- indexed by category (general settings, ai1, ai2, ...)
-- sorted by number of possibilities (largest to smallest num)
SPMenu.S21_SettingsOrder = {
	[1] = {
		"MapHeroes",
		"MapSetting",
		"MapWeather",
		"MapSize",
		"MapResourceWealth",
		"MapStart",
		"MapResources",
		"MapVC",
		"MapMirror"
	}
}
for AI = 1, 7 do
	SPMenu.S21_SettingsOrder[AI + 1] = {
		"MapAI_" .. AI .. "_Peacetime",
		"MapAI_" .. AI .. "_Team",
		"MapAI_" .. AI .. "_TechLVL",
		"MapAI_" .. AI .. "_Strength",
		"MapAI_" .. AI .. "_Active"
	}
end
function SPMenu.S21_UpdateConfigurationDisplayFields(_updateGenerics, _updateMapKey, _updateHexString)

	if _updateGenerics or _updateMapKey then
		for k, v in pairs(SPMenu.S21_CurrSetting) do
			local widget = "SPM21_" .. k .. "_Title"
			if XGUIEng.IsWidgetExisting(widget) == 1 then
				local text = SPMenu.S21_SettingData[k][v]
				if type(text) == "function" then
					if _updateMapKey then
						text = SPMenu.S21_SettingData[k][v]()
						text = "@center " .. text
						XGUIEng.SetText(widget, text)
					end
				else
					if _updateGenerics then
						if not text then
							LuaDebugger.Break()
						end
						text = "@center " .. text
						XGUIEng.SetText(widget, text)
					end
				end
			end
		end
	end
	if _updateHexString then
		XGUIEng.SetText("SPM21_MapConfigID_Title", SPMenu.S21_GetCurrConfigInHex())
	end
end
function SPMenu.S21_Init()

	SPMenu.S21_CurrSetting = {}
	for k, v in pairs(SPMenu.S21_SettingData) do
		if SPMenu.S21_SettingDefaultIndex[k] then
			SPMenu.S21_CurrSetting[k] = SPMenu.S21_SettingDefaultIndex[k]
		else
			SPMenu.S21_CurrSetting[k] = 1
		end
	end
	SPMenu.S21_UpdateConfigurationDisplayFields(true, true, true)

	SPMenu.S21_CustomTextInputWidgetInUse = false
	SPMenu.S21_CustomTextInputWidgetData = {
		["SPM21_MapKey_Input"] = {
			Validate = function(self, _str)
				if _str == nil or _str == "" then
					return false
				end
				local number = tonumber(_str)
				if number == nil then
					return false
				end
				if number <= 0 then
					return false
				end
				if math.mod(number, 1) > 0 then
					return false
				end
				if string.len(_str) > 10 then
					return false
				end
				return true
			end
		},
		["SPM21_MapConfigID_Input"] = {
			MaxLength = {6,3},
			MinValue = {969086, 1371},
			MaxValue = {2279485, 3290},
			Validate = function(self, _str)
				if _str == nil or _str == "" then
					return false
				end
				local count = 0
				for part in string.gfind(_str, "[^%-]+") do
					if string.len(part) > (self.MaxLength[count + 1] or self.MaxLength[2]) then
						return false
					end
					local number = tonumber(part, 16)
					if number == nil then
						return false
					end
					if number < (self.MinValue[count + 1] or self.MinValue[2])
					or number <= 0 then
						return false
					end
					if number > (self.MaxValue[count + 1] or self.MaxValue[2]) then
						return false
					end
					count = count + 1
				end
				if count ~= table.getn(SPMenu.S21_SettingsOrder) then
					return false
				end
				return true
			end,
			PostAction = function()
				local hexstr = XGUIEng.GetText("SPM21_MapConfigID_Title")
				if string.find(hexstr, "@center") ~= nil then
					hexstr = string.sub(hexstr, 9)
				end
				SPMenu.S21_SetCurrConfigFromHex(hexstr)
			end
		}
	}
	SPMenu.S21_CustomTextInputsActivate = function(_keyName)
		if not SPMenu.S21_CustomTextInputWidgetInUse then
			SPMenu.S21_CustomTextInputWidgetInUse = true
			local widget = "SPM21_" .. _keyName .. "_Input"
			if XGUIEng.IsWidgetShown(widget) == 0 then
				XGUIEng.ShowWidget(widget, 1)
				--
				local rootName = CWidget.GetName(XGUIEng.GetWidgetsMotherID(widget))
				SPMenu.S21_CustomTextInputWidgetData[widget].Fallback = XGUIEng.GetText(rootName .. "_Title")
			end
		end
	end
	GameCallback_CustomWidgetInput = function(str)
		for widget, data in pairs(SPMenu.S21_CustomTextInputWidgetData) do
			if XGUIEng.IsWidgetShown(widget) == 1 then
				local rootWidget = XGUIEng.GetWidgetsMotherID(widget)
				local rootName = CWidget.GetName(rootWidget)
				XGUIEng.ShowWidget(rootName .. "_Title", 0)
				XGUIEng.SetText(rootName .. "_Title", str)
				--XGUIEng.SetStringInputCustomWidgetString(widget, str);
			end
		end
	end
	GameCallback_CustomWidgetEnter = function()
		for widget, data in pairs(SPMenu.S21_CustomTextInputWidgetData) do
			if XGUIEng.IsWidgetShown(widget) == 1 then
				local rootWidget = XGUIEng.GetWidgetsMotherID(widget)
				XGUIEng.ShowWidget(widget, 0)
				XGUIEng.ShowWidget(rootWidget, 1)
				local textWidget = CWidget.GetName(rootWidget) .. "_Title"
				local text = XGUIEng.GetText(textWidget)
				--local text = XGUIEng.GetStringInputCustomWidgetString(widget)
				if not SPMenu.S21_CustomTextInputWidgetData[widget]:Validate(text) then
					text = SPMenu.S21_CustomTextInputWidgetData[widget].Fallback
				else
					text = "@center " .. text
				end
				XGUIEng.SetText(textWidget, text)
				XGUIEng.ShowWidget(textWidget, 1)
				if SPMenu.S21_CustomTextInputWidgetData[widget].PostAction then
					SPMenu.S21_CustomTextInputWidgetData[widget].PostAction()
				end
				SPMenu.S21_CustomTextInputWidgetInUse = false
			end
		end
	end
	InputCallback_KeyDown = function(_ctrl, _shift, _alt, _key)

		local isCtrlOnlyModifier = _ctrl and not _alt and not _shift

		local isCopy = isCtrlOnlyModifier and  _key == Keys.C
		local isPaste = isCtrlOnlyModifier and _key == Keys.V

		if _key == Keys.Escape or isCopy or isPaste then
			for widget, data in pairs(SPMenu.S21_CustomTextInputWidgetData) do
				if XGUIEng.IsWidgetShown(widget) == 1 then
					local rootWidget = XGUIEng.GetWidgetsMotherID(widget)
					local textWidget = CWidget.GetName(rootWidget) .. "_Title"
					if _key == Keys.Escape then
						XGUIEng.ShowWidget(widget, 0)
						XGUIEng.ShowWidget(rootWidget, 1)
						XGUIEng.SetText(textWidget, SPMenu.S21_CustomTextInputWidgetData[widget].Fallback)
						XGUIEng.ShowWidget(textWidget, 1)
						--
						SPMenu.S21_CustomTextInputWidgetInUse = false

					elseif isCopy then
						local text = XGUIEng.GetText(textWidget)
						if string.find(text, "@center") ~= nil then
							text = string.sub(text, 9)
						end

						local success = CUtil.SetClipboardText(text)

						if success then
							LuaDebugger.Log("Copied '" .. text .. "' into clipboard!")
						else
							LuaDebugger.Log("Copy into clipboard failed!")
						end
						return true

					elseif isPaste then
						local text = CUtil.GetClipboardText()
						XGUIEng.ShowWidget(textWidget, 0)
						if text then
							-- das hier ist kein "paste" sondern ein replace...
							XGUIEng.SetStringInputCustomWidgetString(widget, text)
							XGUIEng.SetText(textWidget, text)
						else
							LuaDebugger.Log("Failed to paste text!")
						end
						return true
					end
				end
			end
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
	--
	SPMenu.S21_UpdateMapAlertHint()
	SPMenu.S21_UpdateConfigurationDisplayFields(false, false, true)
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
	--
	SPMenu.S21_UpdateMapAlertHint()
	SPMenu.S21_UpdateConfigurationDisplayFields(false, false, true)
end
function SPMenu.S21_SaveToClipboard(_Setting)

	local widget = "SPM21_" .. _Setting .. "_Title"
	local text = XGUIEng.GetText(widget)
	if string.find(text, "@center") ~= nil then
		text = string.sub(text, 9)
	end

	local success = CUtil.SetClipboardText(text)

	if success then
		LuaDebugger.Log("Copied '" .. text .. "' into clipboard!")
	else
		LuaDebugger.Log("Copy into clipboard failed!")
	end
end
function SPMenu.S21_EnableAI(_slot)

	XGUIEng.ShowWidget("SPM21_MapAI_" .. _slot, 1)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Enable", 0)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Disable", 1)
	--
	SPMenu.S21_CurrSetting["MapAI_" .. _slot .. "_Active"] = 2
	--
	SPMenu.S21_UpdateMapAlertHint()
	SPMenu.S21_UpdateConfigurationDisplayFields(false, false, true)
end
function SPMenu.S21_DisableAI(_slot)

	XGUIEng.ShowWidget("SPM21_MapAI_" .. _slot, 0)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Enable", 1)
	XGUIEng.ShowWidget("SPM21_MapAIs_" .. _slot .. "_Disable", 0)
	--
	SPMenu.S21_CurrSetting["MapAI_" .. _slot .. "_Active"] = 1
	--
	SPMenu.S21_UpdateMapAlertHint()
	SPMenu.S21_UpdateConfigurationDisplayFields(false, false, true)
end
function SPMenu.S21_CheckForUnluckyConstellation()

	local mapSizeKey = SPMenu.S21_CurrSetting.MapSize
	local mapSize = SPMenu.S21_SettingData.MapSize[mapSizeKey]
	local mapStructMinesKey = SPMenu.S21_CurrSetting.MapResources
	local mapStructMiscKey = SPMenu.S21_CurrSetting.MapVC
	local numAI = 0
	local teamsRegistered = {[1] = true}
	local teams = {1}
	for AI = 1, 7 do
		if SPMenu.S21_CurrSetting["MapAI_" .. AI .. "_Active"] == 2 then
			numAI = numAI + 1
			local team = SPMenu.S21_CurrSetting["MapAI_" .. AI .. "_Team"]
			if not teamsRegistered[team] then
				teamsRegistered[team] = true
				table.insert(teams, team)
			end
		end
	end

	local val_mapStructMines = mapStructMinesKey ^ 0.8
	local val_mapStructMisc = math.sqrt(mapStructMiscKey)
	local val_teams = table.getn(teams)/4
	local val_mapSize = mapSize^2/300
	local val = (numAI ^ (val_mapStructMines + val_mapStructMisc + val_teams)) / val_mapSize
	return val > 1
end
function SPMenu.S21_UpdateMapAlertHint()

	local unluckyConstellation = SPMenu.S21_CheckForUnluckyConstellation()
	if unluckyConstellation then
		XGUIEng.ShowWidget("SPM21_MapAlertHint", 1)
		XGUIEng.SetText("SPM21_MapAlertHint", XGUIEng.GetStringTableText("AO3MainMenu/RandomMap_MapAlertHint"))
	else
		XGUIEng.SetText("SPM21_MapAlertHint", "")
		XGUIEng.ShowWidget("SPM21_MapAlertHint", 0)
	end
end
function SPMenu.S21_GetCurrConfigInHex()

	local config = SPMenu.S21_CurrSetting
    local hexValues = {}
	local factors = {}
	for i = 1, table.getn(SPMenu.S21_SettingsOrder) do
		hexValues[i] = 0
		factors[i] = 1
	end

    -- Iteration über die Einstellungen, um den hexadezimalen Wert zu berechnen
	for i = 1, table.getn(SPMenu.S21_SettingsOrder) do
		for j = 1, table.getn(SPMenu.S21_SettingsOrder[i]) do
			local setting = SPMenu.S21_SettingsOrder[i][j]
			local optionIndex = SPMenu.S21_CurrSetting[setting]
			local optionCount = table.getn(SPMenu.S21_SettingData[setting])
			hexValues[i] = hexValues[i] + (optionIndex * factors[i])
			factors[i] = factors[i] * optionCount
		end
    end
	local hexstr = ""
	for i = 1, table.getn(hexValues) do
		if string.len(hexstr) ~= 0 then
			hexstr = hexstr .. "-"
		end
		hexstr = hexstr .. string.format("%X", hexValues[i])
	end

    return hexstr
end
function SPMenu.S21_CutHexValueOffset(_int, _optionCounts)

	local offset = 1
	local factor = 1
	for i = 1, table.getn(_optionCounts) do
		offset = offset + (factor * _optionCounts[i])
		factor = factor * _optionCounts[i]
	end

	return _int - offset
end
function SPMenu.S21_GetConfigFromHexValue(_int, _index)

	local optionCount = {}
	for i = 1, table.getn(SPMenu.S21_SettingsOrder[_index]) -1, 1 do
		local setting = SPMenu.S21_SettingsOrder[_index][i]
		table.insert(optionCount, table.getn(SPMenu.S21_SettingData[setting]))
	end

	local remaining = SPMenu.S21_CutHexValueOffset(_int, optionCount)

	local factor = 1
	for i = 1, table.getn(optionCount) do
		factor = factor * optionCount[i]
	end

	local config = {}
	for i = table.getn(SPMenu.S21_SettingsOrder[_index]), 1, -1 do
		local setting = SPMenu.S21_SettingsOrder[_index][i]
		local optionIndex = math.floor(remaining / factor) + 1
		remaining = math.mod(remaining, factor)
		local numRemainingOptions = table.getn(optionCount)
		factor = factor / (optionCount[numRemainingOptions] or 1)
		table.remove(optionCount, numRemainingOptions)
		config[setting] = optionIndex
	end

	return config
end
function SPMenu.S21_SetCurrConfigFromHex(_hexstr)

	local index = 1
    -- Zerlege den Hex-String in einzelne Werte
    for part in string.gfind(_hexstr, "[^%-]+") do
		local config = SPMenu.S21_GetConfigFromHexValue(tonumber(part, 16), index)
		for setting, optionIndex in pairs(config) do
			if string.find(setting, "Active") ~= nil then
				if optionIndex == 1 then
					SPMenu.S21_DisableAI(index - 1)
				elseif optionIndex == 2 then
					SPMenu.S21_EnableAI(index - 1)
				end
			else
				SPMenu.S21_CurrSetting[setting] = optionIndex
			end
		end
		index = index + 1
    end

	SPMenu.S21_UpdateMapAlertHint()
	SPMenu.S21_UpdateConfigurationDisplayFields(true, false, true)

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
