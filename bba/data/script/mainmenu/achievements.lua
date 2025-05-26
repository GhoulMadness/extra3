----------------------------------------------------------------------------------------------------
-- Achievement menu stuff
----------------------------------------------------------------------------------------------------
-- Table
AchievementMenu = {}
-- starts at page 0, so technically +1 pages in total
AchievementMenu.MaxPages = 2

----------------------------------------------------------------------------------------------------
-- Start achievement menu

function AchievementMenu.S00_Start()

	-- Make page active
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "AchievementMenu01", 0 )
	XGUIEng.ShowWidget( "AchievementMenu02", 0 )

	XGUIEng.ShowWidget( "AchievementMenu00", 1 )

	-- Set up environment
	AchievementMenu.DoInitStuff()

	-- Keys
	Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "StartMenu_KeyBindings_AltFFour()",2)

	-- page 1 general achievs + challenge maps
	-- page 2 campaign Invasion Im Norden
	-- page 3 campaign Mythen
	AchievementMenu.TitleTypes = {	[1] = "general",
									[2] = "campaign1",
									[3] = "campaign2"
	}
	AchievementMenu.Titles = {	[1] =
										{	[1]		=	{Name = "map1won", Preview = true, Key = "challenge_map1_won", Value = 2},
											[2]		=	{Name = "map2won", Preview = true, Key = "challenge_map2_won", Value = 2},
											[3]		=	{Name = "map3won", Preview = true, Key = "challenge_map3_won", Value = 2},
											[4]		=	{Name = "map4won", Preview = true, Key = "challenge_map4_won", Value = 2},
											[5]		=	{Name = "map5won", Preview = true, Key = "challenge_map5_won", Value = 2},
											[6]		=	{Name = "map6won", Preview = true, Key = "challenge_map6_won", Value = 2},
											[7]		=	{Name = "map7won", Preview = true, Key = "challenge_map7_won", Value = 2},
											[8]		=	{Name = "map8won", Preview = true, Key = "challenge_map8_won", Value = 2},
											[9]		=	{Name = "map9won", Preview = true, Key = "challenge_map9_won", Value = 2},
											[10]	=	{Name = "luckychest", Preview = false, Key = "achievements\\luckychest", Value = 1},
											[11]	=	{Name = "silverarmor", Preview = false, Key = "achievements\\silverarmor", Value = 1},
											[12]	=	{Name = "silverweapons", Preview = false, Key = "achievements\\silverweapons", Value = 1},
											[13]	=	{Name = "killingspree", Preview = false, Key = "achievements\\killingspree", Value = 1},
											[14]	=	{Name = "skilledmerchant", Preview = false, Key = "achievements\\skilledmerchant", Value = 1},
											[15]	=	{Name = "mrtalkalot", Preview = false, Key = "achievements\\mrtalkalot", Value = 1},
											[16]	=	{Name = "hugearmy", Preview = false, Key = "achievements\\hugearmy", Value = 1},
											[17]	=	{Name = "maxserfs", Preview = false, Key = "achievements\\maxserfs", Value = 1},
											[18]	=	{Name = "allachievs", Preview = false, Key = "achievements\\allachievs", Value = 1}
										},
								[2]	=
										{	[1]		=	{Name = "wonmaps", Preview = true, Key = "achievements\\wonmaps_campaignExtra3_2", Value = 1},
											[2]		=	{Name = "wonmapshard", Preview = true, Key = "achievements\\wonmapshard_campaignExtra3_2", Value = 1},
											[3]		=	{Name = "nuamonchests", Preview = true, Key = "achievements\\nuamonchests", Value = 1},
											[4]		=	{Name = "drakonchests", Preview = true, Key = "achievements\\drakonchests", Value = 1},
											[5]		=	{Name = "kralmountainschests", Preview = true, Key = "achievements\\kralmountainschests", Value = 1},
											[6]		=	{Name = "northernseachests", Preview = true, Key = "achievements\\northernseachests", Value = 1},
											[7]		=	{Name = "dreadmountainschests", Preview = true, Key = "achievements\\dreadmountainschests", Value = 1},
											[8]		=	{Name = "nuamonfastarrival", Preview = false, Key = "achievements\\nuamonfastarrival", Value = 1},
											[9]		=	{Name = "nuamonbridges", Preview = false, Key = "achievements\\nuamonbridges", Value = 1},
											[10]	=	{Name = "nuamonmystery", Preview = false, Key = "achievements\\nuamonmystery", Value = 1},
											[11]	=	{Name = "drakoncaravans", Preview = false, Key = "achievements\\drakoncaravans", Value = 1},
											[12]	=	{Name = "drakonarisummon", Preview = false, Key = "achievements\\drakonarisummon", Value = 1},
											[13]	=	{Name = "drakonvillages", Preview = false, Key = "achievements\\drakonvillages", Value = 1},
											[14]	=	{Name = "kralmountainssulfur", Preview = false, Key = "achievements\\kralmountainssulfur", Value = 1},
											[15]	=	{Name = "kralmountainssniper", Preview = false, Key = "achievements\\kralmountainssniper", Value = 1},
											[16]	=	{Name = "kralmountainsrocks", Preview = false, Key = "achievements\\kralmountainsrocks", Value = 1},
											[17]	=	{Name = "northernseanofight", Preview = false, Key = "achievements\\northernseanofight", Value = 1},
											[18]	=	{Name = "northernseanosupply", Preview = false, Key = "achievements\\northernseanosupply", Value = 1},
											[19]	=	{Name = "northernseasilver", Preview = false, Key = "achievements\\northernseasilver", Value = 1},
											[20]	=	{Name = "dreadmountainsnodeath", Preview = false, Key = "achievements\\dreadmountainsnodeath", Value = 1},
											[21]	=	{Name = "dreadmountainscaves", Preview = false, Key = "achievements\\dreadmountainscaves", Value = 1},
											[22]	=	{Name = "dreadmountainstroops", Preview = false, Key = "achievements\\dreadmountainstroops", Value = 1},
											[23]	=	{Name = "losttoherodeaths", Preview = false, Key = "achievements\\losttoherodeaths", Value = 25},
											[24]	=	{Name = "masterofthenorth", Preview = true, Key = "achievements\\masterofthenorth", Value = 1}
										},
								[3]	=
										{	[1]		=	{Name = "wonmaps", Preview = true, Key = "achievements\\wonmaps_campaignExtra3", Value = 1},
											[2]		=	{Name = "wonmapshard", Preview = true, Key = "achievements\\wonmapshard_campaignExtra3", Value = 1},
											[3]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[4]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[5]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[6]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[7]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[8]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[9]		=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[10]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[11]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[12]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[13]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[14]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[15]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[16]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[17]	=	{Name = "", Preview = false, Key = "achievements\\", Value = 1},
											[18]	=	{Name = "masterofmyths", Preview = false, Key = "achievements\\masterofmyths", Value = 1}
										}
	}

end

----------------------------------------------------------------------------------------------------
-- Init achievement menu generics

function AchievementMenu.DoInitStuff()
	AchievementMenu.CurrPage = 0
	Mouse.CursorSet(10)

end
function AchievementMenu.UpdatePageTitle(_page)
	XGUIEng.SetText( "AchievementMenu0" .. _page .. "_Right_Text_Page", XGUIEng.GetStringTableText("AO3AchievementMenu/Page" .. _page + 1 .. "_Name"))
end
function AchievementMenu.ToNextPage()
	XGUIEng.ShowWidget( "AchievementMenu0" .. AchievementMenu.CurrPage, 0 )
	if AchievementMenu.CurrPage < AchievementMenu.MaxPages then
		AchievementMenu.CurrPage = AchievementMenu.CurrPage + 1
	else
		AchievementMenu.CurrPage = 0
	end
	XGUIEng.ShowWidget( "AchievementMenu0" .. AchievementMenu.CurrPage, 1 )
	AchievementMenu.UpdatePageTitle(AchievementMenu.CurrPage)
end
function AchievementMenu.ToPrevPage()
	XGUIEng.ShowWidget( "AchievementMenu0" .. AchievementMenu.CurrPage, 0 )
	if AchievementMenu.CurrPage > 0 then
		AchievementMenu.CurrPage = AchievementMenu.CurrPage - 1
	else
		AchievementMenu.CurrPage = AchievementMenu.MaxPages
	end
	XGUIEng.ShowWidget( "AchievementMenu0" .. AchievementMenu.CurrPage, 1 )
end
function AchievementMenu.UpdateTooltip(_page, _frame)
	local AchievementType = AchievementMenu.TitleTypes[_page]
	local KeyName = AchievementMenu.Titles[_page][_frame].Name
	if KeyName then
		if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 0 then
			local title = XGUIEng.GetStringTableText("AO3Achievements_" .. AchievementType .. "/AO3Achievements_" .. AchievementType .. "_" .. KeyName .. "_name")
			local desc = XGUIEng.GetStringTableText("AO3Achievements_" .. AchievementType .. "/AO3Achievements_" .. AchievementType .. "_" .. KeyName .. "_desc")
			XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomDesc", 1)
			XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomTitle", 1)
			XGUIEng.SetText("AchievementMenu0" .. _page - 1 .. "_BottomTitle", title)
			XGUIEng.SetText("AchievementMenu0" .. _page - 1 .. "_BottomDesc", desc)
		else
			local title = XGUIEng.GetStringTableText("AO3AchievementMenu/HiddenAchievementTitle")
			XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomDesc", 0)
			XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomTitle", 1)
			XGUIEng.SetText("AchievementMenu0" .. _page - 1 .. "_BottomTitle", title)
		end
	else
		XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomDesc", 0)
		XGUIEng.ShowWidget("AchievementMenu0" .. _page - 1 .. "_BottomTitle", 0)
	end
end
-- Update general achievements window
function AchievementMenu.S00_Update(_frame)
	local AchievementType = AchievementMenu.TitleTypes[1]
	local KeyName = AchievementMenu.Titles[1][_frame].Key
	local needed = AchievementMenu.Titles[1][_frame].Value
	local Preview = AchievementMenu.Titles[1][_frame].Preview
	local widget = XGUIEng.GetCurrentWidgetID()
	if KeyName then
		if GDB.IsKeyValid(KeyName) and GDB.GetValue(KeyName) >= needed then
			XGUIEng.DisableButton(widget, 0)
			XGUIEng.HighLightButton(widget, 1)
		else
			if Preview then
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 0)
				XGUIEng.HighLightButton(widget, 0)
			else
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 1)
				XGUIEng.HighLightButton(widget, 0)
			end
		end
	end
end
-- Update campaign 1 achievements window (Invasion im Norden)
function AchievementMenu.S01_Update(_frame)
	local AchievementType = AchievementMenu.TitleTypes[2]
	local KeyName = AchievementMenu.Titles[2][_frame].Key
	local needed = AchievementMenu.Titles[2][_frame].Value
	local Preview = AchievementMenu.Titles[2][_frame].Preview
	local widget = XGUIEng.GetCurrentWidgetID()
	if KeyName then
		if GDB.IsKeyValid(KeyName) and GDB.GetValue(KeyName) >= needed then
			XGUIEng.DisableButton(widget, 0)
			XGUIEng.HighLightButton(widget, 1)
		else
			if Preview then
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 0)
				XGUIEng.HighLightButton(widget, 0)
			else
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 1)
				XGUIEng.HighLightButton(widget, 0)
			end
		end
	end
end
-- Update campaign 2 achievements window (Mythen)
function AchievementMenu.S02_Update(_frame)
	local AchievementType = AchievementMenu.TitleTypes[3]
	local KeyName = AchievementMenu.Titles[3][_frame].Key
	local needed = AchievementMenu.Titles[3][_frame].Value
	local Preview = AchievementMenu.Titles[3][_frame].Preview
	local widget = XGUIEng.GetCurrentWidgetID()
	if KeyName then
		if GDB.IsKeyValid(KeyName) and GDB.GetValue(KeyName) >= needed then
			XGUIEng.DisableButton(widget, 0)
			XGUIEng.HighLightButton(widget, 1)
		else
			if Preview then
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 0)
				XGUIEng.HighLightButton(widget, 0)
			else
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 1)
				XGUIEng.HighLightButton(widget, 0)
			end
		end
	end
end

function StartMenu_KeyBindings_AltFFour()

	if Demo_Menu.Initialized == nil then
		XGUIEng.ShowWidget( "QuitGameOverlayScreen", 1 )
	else
		XGUIEng.ShowWidget( "DemoPostScreen", 1 )
	end
end
