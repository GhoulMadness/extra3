-- TODO:
-- fix EMS:
-- GUIUpdate functions should use GetRepresentative() instead of GetValue()
-- MapRuleToGUIWidget should only contain tables
-- AllowNegativeNumbers should not count the - sign as digit
-- stdbool should return bool instead of number
-- self:SetValue should not sheck if > 0 by defaul
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GetRandomSeed(_value)
	
	_value = _value or 0
	local seed = _value + 9876543210 + Game.RealTimeGetMs() + Game.RealTimeGetMs() * 100000
	
	while seed >= 1000000000 do
		seed = seed - 1000000000
	end
	
	return seed
	--EMS.GL.SetValueSynced("RMG_Seed", value)
	--oder einfach math.randomseed?
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.GetAmountDescription(_string)
	return "Legt die Anzahl an ".._string.." je Spieler fest. @cr @cr @color:51,204,255,255 TIPP: @color:255,255,255,255 Rohstoffhaufen werden gleichmäßig in der Nähe von Schächten des gleichen Rohstofftyps verteilt."
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.GetContentDescription(_string)
	return "Legt die Anzahl an Rohstoffeinheiten in ".._string.." fest."
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function EMS.GL.GUIUpdate_Dummy(_string)
	--ignore
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.DbgShow_PlayerConfig()
	for i = 1,16 do
		XGUIEng.ShowWidget("RMG6Frame"..i, 1)
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.GUIUpdate_PlayerConfig(_index, _text)
	
	local nplayers, players, nteams = RMG.UnpackPlayerConfig()
	local widget = "RMG6F".._index.."".._text
	
	if nplayers < _index then
		--XGUIEng.ShowWidget("RMG6Frame".._index, 0)
		if _text == "Name" then
			XGUIEng.SetText(widget, "")
		elseif _text == "Player" then
			XGUIEng.SetMaterialColor(widget, 0, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 1, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 2, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 3, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 4, 0, 0, 0, 0)
		elseif _text == "Team" then
			XGUIEng.SetText(widget, "")
		elseif _text == "Add" then
			XGUIEng.DisableButton(widget, 1)
			XGUIEng.ShowWidget("RMG6F".._index.."Remove", 0)
		elseif _text == "Remove" then
			XGUIEng.ShowWidget(widget, 0)
			XGUIEng.ShowWidget("RMG6F".._index.."Add", 1)
		end
		return
	end
	
	local p = players[_index].Id
	local ishuman = players[_index].IsHuman == 1
	
	if _text == "Name" then
		if ishuman then
			if XNetwork.Manager_DoesExist() == 1 then
				XGUIEng.SetText(widget, "@center".." "..XNetwork.GameInformation_GetLogicPlayerUserName(p))
			else
				XGUIEng.SetText(widget, "@center".." "..p)
			end
		else
			XGUIEng.SetText(widget, "@center Dummy")
		end
	elseif _text == "Player" then
		if ishuman then
			local r, g, b = EMS.GL.GEN_GetPlayerColor( XNetwork.GameInformation_GetLogicPlayerColor(p) )
			XGUIEng.SetMaterialColor(widget, 0, r, g, b, 255)
			XGUIEng.SetMaterialColor(widget, 1, r, g, b, 255)
			XGUIEng.SetMaterialColor(widget, 2, r, g, b, 255)
			XGUIEng.SetMaterialColor(widget, 3, r, g, b, 255)
			XGUIEng.SetMaterialColor(widget, 4, r, g, b, 255)
		else
			XGUIEng.SetMaterialColor(widget, 0, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 1, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 2, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 3, 0, 0, 0, 0)
			XGUIEng.SetMaterialColor(widget, 4, 0, 0, 0, 0)
		end
	elseif _text == "Team" then
		XGUIEng.SetText(widget, "@center Team"..players[_index].Team)
	elseif _text == "Add" then
		if ishuman then
			XGUIEng.DisableButton(widget, 0)
			XGUIEng.ShowWidget(widget, 1)
			XGUIEng.ShowWidget("RMG6F".._index.."Remove", 0)
		else
			XGUIEng.ShowWidget(widget, 0)
			XGUIEng.ShowWidget("RMG6F".._index.."Remove", 1)
		end
	elseif _text == "Remove" then
		if not ishuman then
			XGUIEng.DisableButton(widget, 0)
			XGUIEng.ShowWidget(widget, 1)
			XGUIEng.ShowWidget("RMG6F".._index.."Add", 0)
		else
			XGUIEng.ShowWidget(widget, 0)
			XGUIEng.ShowWidget("RMG6F".._index.."Add", 1)
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.AddDummyPlayer(_index)
	
	local nplayers, players = RMG.UnpackPlayerConfig()
	if nplayers < 16 then
		nplayers = nplayers + 1

		for i = nplayers, _index + 2, -1 do
			players[i] = players[i - 1]
		end
		players[_index + 1] = {Id = 1, Team = players[_index].Team, IsHuman = 0}
		
		RMG.PackPlayerConfig( nplayers, players )
		
		XGUIEng.ShowWidget("RMG6Frame"..nplayers, 1)
	end
	
	EMS.GL.DbgShow_PlayerConfig()
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function EMS.GL.RemoveDummyPlayer(_index)
	
	local nplayers, players = RMG.UnpackPlayerConfig()
	nplayers = nplayers - 1
	
	for i = _index, nplayers, 1 do
		players[i] = players[i + 1]
	end
	players[nplayers + 1] = nil
	
	RMG.PackPlayerConfig( nplayers, players )
	
	EMS.GL.DbgShow_PlayerConfig()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function EMS.GL.SetRandomSeed()
	
	if not EMS.CanChangeRules or EMS.GL.GameStarted then
		return;
	end
	
	EMS.GL.SetValue("RMG_Seed", RMG.GetRandomSeed(EMS.RD.Rules.RMG_Seed:GetValue()))
end

function EMS.GL.GEN_GetPlayerColor( _ColorID )

	if _ColorID == 1 then
		return 15, 64, 255
	elseif _ColorID == 2 then
		return 226, 0, 0
	elseif _ColorID == 3 then
		return 235, 209, 0
	elseif _ColorID == 4 then
		return 0, 235, 209
	elseif _ColorID == 5 then
		return 252, 164, 39
	elseif _ColorID == 6 then
		return 178, 2, 255
	elseif _ColorID == 7 then
		return 178, 176, 154
	elseif _ColorID == 8 then
		return 115, 209, 65
	elseif _ColorID == 9 then
		return 0, 140, 2
	elseif _ColorID == 10 then
		return 184, 184, 184
	elseif _ColorID == 11 then
		return 184, 182, 90
	elseif _ColorID == 12 then
		return 135, 135, 135 
	elseif _ColorID == 13 then
		return 230, 230, 230
	elseif _ColorID == 14 then
		return 57, 57, 57
	elseif _ColorID == 15 then
		return 139, 223, 255
	elseif _ColorID == 16 then
		return 255, 150, 214
	else
		
		if XNetwork.Manager_DoesExist() == 1 then
			return XNetwork.EXTENDED_ColorCodeToRGBA(_ColorID);
		end
		
	end;
	
	return 40, 40, 40
	
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
function RMG.GL_Setup()
	
	XGUIEng.ShowWidget( "RMG2F1Value", 0 )
	XGUIEng.ShowWidget( "RMG2F2Value", 0 )
	XGUIEng.ShowWidget( "RMG2F3Value", 0 )
	XGUIEng.ShowWidget( "RMG2F4Value", 0 )
	XGUIEng.ShowWidget( "RMG2F5Value", 0 )
	
	-- custom text input
	EMS.GL.CustomTextInputs["RMG_Seed"]					= CTI.New({Widget="RMG1F1Value", Before = "@center ", NumbersOnly=true, AllowNegativeNumbers=true, MaxLength=9, Callback=EMS.GL.CustomTextInputCallback});
	--[[
	EMS.GL.CustomTextInputs["RMG_TerrainBaseHeight"]	= CTI.New({Widget="RMG2F1Value", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_WaterBaseHeight"]		= CTI.New({Widget="RMG2F2Value", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_NoiseFactorZ"]			= CTI.New({Widget="RMG2F3Value", Before = "@center ", NumbersOnly=true, MaxLength=3, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_NoiseFactorXY"]		= CTI.New({Widget="RMG2F4Value", Before = "@center ", NumbersOnly=true, MaxLength=3, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ForestDensity"]		= CTI.New({Widget="RMG2F5Value", Before = "@center ", NumbersOnly=true, MaxLength=3, Callback=EMS.GL.CustomTextInputCallback});
	]]
	EMS.GL.CustomTextInputs["RMG_AmountClayPit"]		= CTI.New({Widget="RMG5F1Value1", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentClayPit"]		= CTI.New({Widget="RMG5F1Value2", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountClayPile"]		= CTI.New({Widget="RMG5F2Value1", Before = "@center ", NumbersOnly=true, MaxLength=2, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentClayPile"]		= CTI.New({Widget="RMG5F2Value2", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountStonePit"]		= CTI.New({Widget="RMG5F3Value1", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentStonePit"]		= CTI.New({Widget="RMG5F3Value2", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountStonePile"]		= CTI.New({Widget="RMG5F4Value1", Before = "@center ", NumbersOnly=true, MaxLength=2, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentStonePile"]		= CTI.New({Widget="RMG5F4Value2", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountIronPit"]		= CTI.New({Widget="RMG5F5Value1", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentIronPit"]		= CTI.New({Widget="RMG5F5Value2", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountIronPile"]		= CTI.New({Widget="RMG5F6Value1", Before = "@center ", NumbersOnly=true, MaxLength=2, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentIronPile"]		= CTI.New({Widget="RMG5F6Value2", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountSulfurPit"]		= CTI.New({Widget="RMG5F7Value1", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentSulfurPit"]		= CTI.New({Widget="RMG5F7Value2", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountSulfurPile"]		= CTI.New({Widget="RMG5F8Value1", Before = "@center ", NumbersOnly=true, MaxLength=2, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentSulfurPile"]	= CTI.New({Widget="RMG5F8Value2", Before = "@center ", NumbersOnly=true, MaxLength=4, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountWoodPile"]		= CTI.New({Widget="RMG5F9Value1", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_ContentWoodPile"]		= CTI.New({Widget="RMG5F9Value2", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_AmountVC"]				= CTI.New({Widget="RMG2F7Value", Before = "@center ", NumbersOnly=true, MaxLength=1, Callback=EMS.GL.CustomTextInputCallback});
	
	EMS.GL.CustomTextInputs["RMG_StartResourceGold"]	= CTI.New({Widget="RMG7F1Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_StartResourceClay"]	= CTI.New({Widget="RMG7F2Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_StartResourceWood"]	= CTI.New({Widget="RMG7F3Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_StartResourceStone"]	= CTI.New({Widget="RMG7F4Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_StartResourceIron"]	= CTI.New({Widget="RMG7F5Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	EMS.GL.CustomTextInputs["RMG_StartResourceSulfur"]	= CTI.New({Widget="RMG7F6Value", Before = "@center ", NumbersOnly=true, MaxLength=6, Callback=EMS.GL.CustomTextInputCallback});
	
	-- gui update
	EMS.GL.GUIUpdate["RMG_Seed"]					= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_LandscapeSet"]			= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_GenerateRivers"]			= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_GateLayout"]				= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_GateSize"]				= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_GenerateRoads"]			= EMS.GL.GUIUpdate_TextToggleButton
	EMS.GL.GUIUpdate["RMG_MirrorMap"]				= EMS.GL.GUIUpdate_TextToggleButton
	EMS.GL.GUIUpdate["RMG_RandomPlayerPosition"]	= EMS.GL.GUIUpdate_TextToggleButton
	--[[
	EMS.GL.GUIUpdate["RMG_TerrainBaseHeight"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_WaterBaseHeight"]			= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_NoiseFactorZ"]			= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_NoiseFactorXY"]			= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_ForestDensity"]			= EMS.GL.GUIUpdate_Number
	]]
	EMS.GL.GUIUpdate["RMG_AmountClayPit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentClayPit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountClayPile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentClayPile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountStonePit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentStonePit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountStonePile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentStonePile"]		= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountIronPit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentIronPit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountIronPile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentIronPile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountSulfurPit"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentSulfurPit"]		= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountSulfurPile"]		= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentSulfurPile"]		= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_AmountWoodPile"]			= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ContentWoodPile"]			= EMS.GL.GUIUpdate_Text

	EMS.GL.GUIUpdate["RMG_AmountVC"]				= EMS.GL.GUIUpdate_Text
	EMS.GL.GUIUpdate["RMG_ShowResources"]			= EMS.GL.GUIUpdate_TextToggleButton
	EMS.GL.GUIUpdate["RMG_ShowVillageCenters"]		= EMS.GL.GUIUpdate_TextToggleButton

	EMS.GL.GUIUpdate["RMG_StartResourceGold"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_StartResourceClay"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_StartResourceWood"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_StartResourceStone"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_StartResourceIron"]		= EMS.GL.GUIUpdate_Number
	EMS.GL.GUIUpdate["RMG_StartResourceSulfur"]		= EMS.GL.GUIUpdate_Number

	EMS.GL.GUIUpdate["RMG_PlayerConfig"]			= EMS.GL.GUIUpdate_Dummy
	
	-- map rule to gui widget
	EMS.GL.MapRuleToGUIWidget["RMG_Seed"]					= {"RMG1F1Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_LandscapeSet"]			= {"RMG1F2Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_GenerateRivers"]			= {"RMG1F3Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_GateLayout"]				= {"RMG1F3aValue"}
	EMS.GL.MapRuleToGUIWidget["RMG_GateSize"]				= {"RMG1F3bValue"}
	EMS.GL.MapRuleToGUIWidget["RMG_GenerateRoads"]			= "RMG1F4Value"
	EMS.GL.MapRuleToGUIWidget["RMG_MirrorMap"]				= "RMG1F5Value"
	EMS.GL.MapRuleToGUIWidget["RMG_RandomPlayerPosition"]	= "RMG1F6Value"
	--[[
	EMS.GL.MapRuleToGUIWidget["RMG_TerrainBaseHeight"]		= {"RMG2F1Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_WaterBaseHeight"]		= {"RMG2F2Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_NoiseFactorZ"]			= {"RMG2F3Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_NoiseFactorXY"]			= {"RMG2F4Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_ForestDensity"]			= {"RMG2F5Value"}
	]]
	EMS.GL.MapRuleToGUIWidget["RMG_AmountClayPit"]			= {"RMG5F1Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentClayPit"]			= {"RMG5F1Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountClayPile"]			= {"RMG5F2Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentClayPile"]		= {"RMG5F2Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountStonePit"]			= {"RMG5F3Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentStonePit"]		= {"RMG5F3Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountStonePile"]		= {"RMG5F4Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentStonePile"]		= {"RMG5F4Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountIronPit"]			= {"RMG5F5Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentIronPit"]			= {"RMG5F5Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountIronPile"]			= {"RMG5F6Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentIronPile"]		= {"RMG5F6Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountSulfurPit"]		= {"RMG5F7Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentSulfurPit"]		= {"RMG5F7Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountSulfurPile"]		= {"RMG5F8Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentSulfurPile"]		= {"RMG5F8Value2"}
	EMS.GL.MapRuleToGUIWidget["RMG_AmountWoodPile"]			= {"RMG5F9Value1"}
	EMS.GL.MapRuleToGUIWidget["RMG_ContentWoodPile"]		= {"RMG5F9Value2"}
	
	EMS.GL.MapRuleToGUIWidget["RMG_AmountVC"]				= {"RMG2F7Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_ShowResources"]			= "RMG2F9Value"
	EMS.GL.MapRuleToGUIWidget["RMG_ShowVillageCenters"]		= "RMG2F6Value"
	--EMS.GL.MapRuleToGUIWidget["RMG_PlayerConfig"]			= "RMG6F1Name"
	
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceGold"]		= {"RMG7F1Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceClay"]		= {"RMG7F2Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceWood"]		= {"RMG7F3Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceStone"]		= {"RMG7F4Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceIron"]		= {"RMG7F5Value"}
	EMS.GL.MapRuleToGUIWidget["RMG_StartResourceSulfur"]	= {"RMG7F6Value"}
	
	-- map widget to rule required for CTI
	EMS.GL.MapWidgetToRule["RMG1F1Value"]	= "RMG_Seed"
	--EMS.GL.MapWidgetToRule["RMG1F2Value"]	= "RMG_LandscapeSet"
	--EMS.GL.MapWidgetToRule["RMG1F3Value"]	= "RMG_GenerateRivers"
	--EMS.GL.MapWidgetToRule["RMG1F3aValue"]	= "RMG_GateLayout"
	--EMS.GL.MapWidgetToRule["RMG1F3bValue"]	= "RMG_GateSize"
	--EMS.GL.MapWidgetToRule["RMG1F4Value"]	= "RMG_GenerateRoads"
	--EMS.GL.MapWidgetToRule["RMG1F5Value"]	= "RMG_MirrorMap"
	--EMS.GL.MapWidgetToRule["RMG1F6Value"]	= "RMG_RandomPlayerPosition"
	--[[
	EMS.GL.MapWidgetToRule["RMG2F1Value"]	= "RMG_TerrainBaseHeight"
	EMS.GL.MapWidgetToRule["RMG2F2Value"]	= "RMG_WaterBaseHeight"
	EMS.GL.MapWidgetToRule["RMG2F3Value"]	= "RMG_NoiseFactorZ"
	EMS.GL.MapWidgetToRule["RMG2F4Value"]	= "RMG_NoiseFactorXY"
	EMS.GL.MapWidgetToRule["RMG2F5Value"]	= "RMG_ForestDensity"
	]]
	EMS.GL.MapWidgetToRule["RMG5F1Value1"]	= "RMG_AmountClayPit"
	EMS.GL.MapWidgetToRule["RMG5F1Value2"]	= "RMG_ContentClayPit"
	EMS.GL.MapWidgetToRule["RMG5F2Value1"]	= "RMG_AmountClayPile"
	EMS.GL.MapWidgetToRule["RMG5F2Value2"]	= "RMG_ContentClayPile"
	EMS.GL.MapWidgetToRule["RMG5F3Value1"]	= "RMG_AmountStonePit"
	EMS.GL.MapWidgetToRule["RMG5F3Value2"]	= "RMG_ContentStonePit"
	EMS.GL.MapWidgetToRule["RMG5F4Value1"]	= "RMG_AmountStonePile"
	EMS.GL.MapWidgetToRule["RMG5F4Value2"]	= "RMG_ContentStonePile"
	EMS.GL.MapWidgetToRule["RMG5F5Value1"]	= "RMG_AmountIronPit"
	EMS.GL.MapWidgetToRule["RMG5F5Value2"]	= "RMG_ContentIronPit"
	EMS.GL.MapWidgetToRule["RMG5F6Value1"]	= "RMG_AmountIronPile"
	EMS.GL.MapWidgetToRule["RMG5F6Value2"]	= "RMG_ContentIronPile"
	EMS.GL.MapWidgetToRule["RMG5F7Value1"]	= "RMG_AmountSulfurPit"
	EMS.GL.MapWidgetToRule["RMG5F7Value2"]	= "RMG_ContentSulfurPit"
	EMS.GL.MapWidgetToRule["RMG5F8Value1"]	= "RMG_AmountSulfurPile"
	EMS.GL.MapWidgetToRule["RMG5F8Value2"]	= "RMG_ContentSulfurPile"
	EMS.GL.MapWidgetToRule["RMG5F9Value1"]	= "RMG_AmountWoodPile"
	EMS.GL.MapWidgetToRule["RMG5F9Value2"]	= "RMG_ContentWoodPile"
	
	EMS.GL.MapWidgetToRule["RMG2F7Value"]	= "RMG_AmountVC"
	--EMS.GL.MapWidgetToRule["RMG2F9Value"]	= "RMG_ShowResources"
	--EMS.GL.MapWidgetToRule["RMG2F6Value"]	= "RMG_ShowVillageCenters"
	
	EMS.GL.MapWidgetToRule["RMG7F1Value"]	= "RMG_StartResourceGold"
	EMS.GL.MapWidgetToRule["RMG7F2Value"]	= "RMG_StartResourceClay"
	EMS.GL.MapWidgetToRule["RMG7F3Value"]	= "RMG_StartResourceWood"
	EMS.GL.MapWidgetToRule["RMG7F4Value"]	= "RMG_StartResourceStone"
	EMS.GL.MapWidgetToRule["RMG7F5Value"]	= "RMG_StartResourceIron"
	EMS.GL.MapWidgetToRule["RMG7F6Value"]	= "RMG_StartResourceSulfur"
		
	-- tooltip text
	EMS.L.RMG_RandomSeed 		= "Setzt einen zufälligen Seed."
	
	-- add rule pages
	table.insert(EMS.GV.Pages, "EMSPagesRMG")
	--table.insert(EMS.GV.Pages, "EMSPagesRMG2")

	-- show rule page arrows
	XGUIEng.ShowWidget("EMSPUSCUp", 1)
	XGUIEng.ShowWidget("EMSPUSCDown", 1)
end	
function RMG.SetRulesToDefault()
	
	EMS.GL.SetValueSynced("RMG_Seed", RMG.GetRandomSeed())
	
	local _, _, nteams = RMG.GetPlayersAndTeams()
	-- no team border in big ffa
	if nteams > 8 then
		EMS.GL.SetValueSynced("RMG_GenerateRivers",	1)
		
		-- deactivate input and change tooltip
		function EMS.RD.Rules.RMG_GenerateRivers:SetValue() return end
		function EMS.RD.Rules.RMG_GenerateRivers:GetDescription()
			return "Legt fest, wie rivalisierende Teams räumlich von einander getrennt werden sollen. @cr @cr keine - Die Karte ist für jeden Spieler gleichermaßen zugänglich. @cr @cr @color:51,204,255,255 HINWEIS: @color:255,255,255,255 Bei mehr als 10 Teams sind Team Abgrenzungen nicht verfügbar."
		end
	else
		EMS.GL.SetValueSynced("RMG_GenerateRivers",	2)
	end
	EMS.GL.SetValueSynced("RMG_GateLayout",		1)
	EMS.GL.SetValueSynced("RMG_GateSize",		3)
	EMS.GL.SetValueSynced("RMG_GenerateRoads",	Bool2Num(true))
	EMS.GL.SetValueSynced("RMG_LandscapeSet",	1)
	EMS.GL.SetValueSynced("RMG_MirrorMap",		Bool2Num(true))
	
	EMS.GL.SetValueSynced("RMG_AmountClayPit",        1)
	EMS.GL.SetValueSynced("RMG_ContentClayPit",   50000)
	EMS.GL.SetValueSynced("RMG_AmountClayPile",       3)
	EMS.GL.SetValueSynced("RMG_ContentClayPile",   4000)
	EMS.GL.SetValueSynced("RMG_AmountStonePit",       1)
	EMS.GL.SetValueSynced("RMG_ContentStonePit",  50000)
	EMS.GL.SetValueSynced("RMG_AmountStonePile",      3)
	EMS.GL.SetValueSynced("RMG_ContentStonePile",  4000)
	EMS.GL.SetValueSynced("RMG_AmountIronPit",        2)
	EMS.GL.SetValueSynced("RMG_ContentIronPit",   30000)
	EMS.GL.SetValueSynced("RMG_AmountIronPile",       3)
	EMS.GL.SetValueSynced("RMG_ContentIronPile",   4000)
	EMS.GL.SetValueSynced("RMG_AmountSulfurPit",      2)
	EMS.GL.SetValueSynced("RMG_ContentSulfurPit", 30000)
	EMS.GL.SetValueSynced("RMG_AmountSulfurPile",     3)
	EMS.GL.SetValueSynced("RMG_ContentSulfurPile", 4000)
	EMS.GL.SetValueSynced("RMG_AmountWoodPile",       2)
	EMS.GL.SetValueSynced("RMG_ContentWoodPile",  16000)
	EMS.GL.SetValueSynced("RMG_AmountVC", 3)
	
	--local res = EMS.RD.AdditionalConfig.Ressources.Normal[player]
	EMS.GL.SetValueSynced("RMG_StartResourceGold", 500)
	EMS.GL.SetValueSynced("RMG_StartResourceClay", 2400)
	EMS.GL.SetValueSynced("RMG_StartResourceWood", 1750)
	EMS.GL.SetValueSynced("RMG_StartResourceStone", 700)
	EMS.GL.SetValueSynced("RMG_StartResourceIron", 50)
	EMS.GL.SetValueSynced("RMG_StartResourceSulfur", 50)
end

function RMG.PackPlayerConfig( _nplayers, _players, _nteams, _teams )
	
	local config = ""
	config = AddNumberToString( config, _nplayers, 2 )
	
	for p = 1, _nplayers do
		
		local data = _players[p]
		
		config = AddNumberToString( config, data.Id, 2 )
		config = AddNumberToString( config, data.Team, 2 )
		config = AddNumberToString( config, data.IsHuman, 1 )
	end
	
	EMS.GL.SetValue( "RMG_PlayerConfig", config )
end

function AddNumberToString( _text, _num, _digits )
	
	_digits = _digits or 1
	
	-- the lazy aproach is enough
	if _digits == 2 and _num < 10 then
		_text = _text .. "0"
	end
	_text = _text .. _num
		
	return _text
end

function RMG.UnpackPlayerConfig()
	
	local config = EMS.RD.Rules.RMG_PlayerConfig:GetValue()
	
	local nplayers = 0
	local players = {}
	local nteams = 0
	local teams = {}
	
	config, nplayers = GetNumberFromString( config, 2 )
	
	for p = 1, nplayers do
		
		local id,team, ishuman = 0,0,0
		
		config, id      = GetNumberFromString( config, 2 )
		config, team    = GetNumberFromString( config, 2 )
		config, ishuman = GetNumberFromString( config, 1 )
		
		local isIn = false

		for _,v in pairs(teams) do
			if v == team then
				isIn = true
				break
			end
		end

		if not isIn then
			nteams = nteams + 1
			teams[nteams] = team
		end
		
		players[p] = { Id = id, Team = team, IsHuman = ishuman }
	end
	
	return nplayers, players, nteams, teams
end

function GetNumberFromString( _text, _digits )
	
	_digits = _digits or 1
	
	local num = tonumber( string.sub( _text, 1, _digits ) )
	_text = string.sub( _text, _digits + 1, string.len( _text ) )
	
	return _text, num
end