------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Tables and misc Stuff --------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
if XNetwork.Manager_DoesExist() == 0 then
	XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer = function()
		return 1
	end
	XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID = function(_PlayerID)
		if _PlayerID == 1 then
			return 1
		else
			return 0
		end
	end
	MultiplayerTools.RemoveAllPlayerEntities = function( _PlayerID)
	end
	GUIUpdate_BuyHeroButton = function()
		if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) > 0 then
			XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),1)
		else
			XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),0)
		end
	end
	GUIAction_ToggleMenu_Orig = GUIAction_ToggleMenu
	GUIAction_ToggleMenu = function(_menu, _status)
		if _menu == gvGUI_WidgetID.BuyHeroWindow then
			XGUIEng.ShowWidget(gvGUI_WidgetID.BuyHeroWindow, 1)
		else
			GUIAction_ToggleMenu_Orig(_menu, _status)
		end
	end
else

	if GUI.GetPlayerID() == BS.SpectatorPID then
		Input.KeyBindDown(Keys.ModifierAlt + Keys.G, "HideGUI()", 2)
	end
	Logic.SetTechnologyState(BS.SpectatorPID, Technologies.GT_Tactics, 3)
end
for i = 1, XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer() do
	if gvXmasEventFlag or gvTutorialFlag then
		Logic.SetTechnologyState(i, Technologies.B_VillageHall, 0)
	end

end
-----------------------------------------------------------------------------------------------
-- Added Castles to win condition -------------------------------------------------------------
-----------------------------------------------------------------------------------------------
MultiplayerTools.EntityTableHeadquarters = {Entities.PB_Headquarters1, Entities.PB_Headquarters2, Entities.PB_Headquarters3,
											Entities.PB_Castle1,Entities.PB_Castle2,Entities.PB_Castle3,Entities.PB_Castle4,Entities.PB_Castle5,
											Entities.PB_Outpost1, Entities.PB_Outpost2, Entities.PB_Outpost3}
-- needed for GameCallback_PlaceBuildingAdditionalCheck
HostileTroopBuildBlockWhitelist = {	[Entities.PU_Hero3_Trap] = true,
									[Entities.PB_GenericBridge] = true,
									[Entities.PB_Bridge1] = true,
									[Entities.PB_Bridge2] = true,
									[Entities.PB_Bridge3] = true,
									[Entities.PB_Bridge4] = true,
									[Entities.PB_WoodenBridge1] = true}
-- needed for outpost taxes update
gvGUI_WidgetID.TaxesButtonsOP = {}
gvGUI_WidgetID.TaxesButtonsOP[0] = 	"SetVeryLowTaxes_OP"
gvGUI_WidgetID.TaxesButtonsOP[1] = 	"SetLowTaxes_OP"
gvGUI_WidgetID.TaxesButtonsOP[2] = 	"SetNormalTaxes_OP"
gvGUI_WidgetID.TaxesButtonsOP[3] = 	"SetHighTaxes_OP"
gvGUI_WidgetID.TaxesButtonsOP[4] = 	"SetVeryHighTaxes_OP"
--
if CUtil then

	refined_resource_gold = {
        [Entities.PB_Bank1] = 3,
        [Entities.PB_Bank2] = 3,
        [Entities.PB_Bank3] = 4,
		[Entities.CB_Mint1] = 3
    }

	gained_resource_clay = {
	    [Entities.PB_ClayMine1] = 5,
		[Entities.PB_ClayMine2] = 7,
		[Entities.PB_ClayMine3] = 9
	}

	gained_resource_iron = {
		[Entities.PB_IronMine1] = 5,
		[Entities.PB_IronMine2] = 7,
		[Entities.PB_IronMine3] = 9
	}

	gained_resource_stone = {
		[Entities.PB_StoneMine1] = 5,
		[Entities.PB_StoneMine2] = 7,
		[Entities.PB_StoneMine3] = 9
	}

	gained_resource_sulfur = {
		[Entities.PB_SulfurMine1] = 5,
		[Entities.PB_SulfurMine2] = 7,
		[Entities.PB_SulfurMine3] = 9
	}

	gained_resource_silver = {
		[Entities.PB_SilverMine1] = 2,
		[Entities.PB_SilverMine2] = 2,
		[Entities.PB_SilverMine3] = 3
	}

	gained_resource_gold = {
		[Entities.PB_GoldMine1] = 5,
		[Entities.PB_GoldMine2] = 10,
		[Entities.PB_GoldMine3] = 15
	}

	-- base values; needed for challenge maps
	basevalue_refined_resources = {
        [Entities.PB_Bank1] = 2,
        [Entities.PB_Bank2] = 3,
        [Entities.PB_Bank3] = 4,
		[Entities.CB_Mint1] = 3,
		[Entities.PB_Brickworks1] = 4,
		[Entities.PB_Brickworks2] = 5,
		[Entities.PB_StoneMason1] = 4,
		[Entities.PB_StoneMason2] = 5,
		[Entities.PB_Sawmill1] = 4,
		[Entities.PB_Sawmill2] = 6,
		[Entities.PB_Blacksmith1] = 4,
		[Entities.PB_Blacksmith2] = 5,
		[Entities.PB_Blacksmith3] = 6,
		[Entities.PB_Alchemist1] = 4,
		[Entities.PB_Alchemist2] = 5,
		[Entities.PB_GunsmithWorkshop1] = 4,
		[Entities.PB_GunsmithWorkshop2] = 5
		}

end
--Silver added to resource window
if CNetwork then
	if MP_DiplomacyWindow.resource_to_name then
		MP_DiplomacyWindow.resource_to_name = {
			[ResourceType.GoldRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameMoney") .. " [R]",
			[ResourceType.ClayRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameClay") .. " [R]",
			[ResourceType.WoodRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameWood") .. " [R]",
			[ResourceType.StoneRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameStone") .. " [R]",
			[ResourceType.IronRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameIron") .. " [R]",
			[ResourceType.SulfurRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameSulfur") .. " [R]",
			[ResourceType.SilverRaw] = XGUIEng.GetStringTableText("ingamemessages/GUI_NameSilver") .. " [R]",

			[ResourceType.Gold] = "@color:184,182,90: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameMoney") .. " @color:255,255,255,255: ",
			[ResourceType.Clay] = "@color:115,66,34: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameClay") .. " @color:255,255,255,255: ",
			[ResourceType.Wood] = "@color:85,45,9: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameWood") .. " @color:255,255,255,255: ",
			[ResourceType.Stone] = "@color:147,147,136: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameStone") .. " @color:255,255,255,255: ",
			[ResourceType.Iron] = "@color:98,108,100: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameIron") .. " @color:255,255,255,255: ",
			[ResourceType.Sulfur] = "@color:234,240,68: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameSulfur") .. " @color:255,255,255,255: ",
			[ResourceType.Silver] =  " @color:198,208,200: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameSilver") .. " @color:255,255,255,255: "
		}

		MP_DiplomacyWindow.resource_to_next = {
			[ResourceType.Gold] = ResourceType.Clay,
			[ResourceType.Clay] = ResourceType.Wood,
			[ResourceType.Wood] = ResourceType.Stone,
			[ResourceType.Stone] = ResourceType.Iron,
			[ResourceType.Iron] = ResourceType.Sulfur,
			[ResourceType.Sulfur] = ResourceType.Silver,
			[ResourceType.Silver] = ResourceType.Gold,

			[ResourceType.GoldRaw] = ResourceType.ClayRaw,
			[ResourceType.ClayRaw] = ResourceType.WoodRaw,
			[ResourceType.WoodRaw] = ResourceType.StoneRaw,
			[ResourceType.StoneRaw] = ResourceType.IronRaw,
			[ResourceType.IronRaw] = ResourceType.SulfurRaw,
			[ResourceType.SulfurRaw] = ResourceType.SilverRaw,
			[ResourceType.SilverRaw] = ResourceType.Gold
		}

		MP_DiplomacyWindow.resource_to_check = {
			[ResourceType.Gold] = { ResourceType.Gold, ResourceType.GoldRaw },
			[ResourceType.Clay] = { ResourceType.Clay, ResourceType.ClayRaw },
			[ResourceType.Wood] = { ResourceType.Wood, ResourceType.WoodRaw },
			[ResourceType.Stone] = { ResourceType.Stone, ResourceType.StoneRaw },
			[ResourceType.Iron] = { ResourceType.Iron, ResourceType.IronRaw },
			[ResourceType.Sulfur] = { ResourceType.Sulfur, ResourceType.SulfurRaw },
			[ResourceType.Silver] = { ResourceType.Silver, ResourceType.SilverRaw },

			[ResourceType.GoldRaw] = { ResourceType.GoldRaw },
			[ResourceType.ClayRaw] = { ResourceType.ClayRaw },
			[ResourceType.WoodRaw] = { ResourceType.WoodRaw },
			[ResourceType.StoneRaw] ={ ResourceType.StoneRaw },
			[ResourceType.IronRaw] = { ResourceType.IronRaw },
			[ResourceType.SulfurRaw] = { ResourceType.SulfurRaw },
		}
		if MP_DiplomacyWindow.allowed_resources then
		 MP_DiplomacyWindow.allowed_resources = {
			[ResourceType.Gold] = true,
			[ResourceType.Clay] = true,
			[ResourceType.Wood] = true,
			[ResourceType.Stone] = true,
			[ResourceType.Iron] = true,
			[ResourceType.Sulfur] = true,
			[ResourceType.Silver] = true
		}
		end
		if MP_DiplomacyWindow.raw_resources_allowed then
			MP_DiplomacyWindow.allowed_resources[ResourceType.GoldRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.ClayRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.WoodRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.StoneRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.IronRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.SulfurRaw] = true
			MP_DiplomacyWindow.allowed_resources[ResourceType.SilverRaw] = true

			MP_DiplomacyWindow.resource_to_next[ResourceType.Silver] = ResourceType.GoldRaw

		end

		-- sending coal only allowed on pvp maps
		if EMS then
			MP_DiplomacyWindow.resource_to_name[ResourceType.Knowledge] =  " @color:21,24,22: " .. XGUIEng.GetStringTableText("ingamemessages/GUI_NameCoal") .. " @color:255,255,255,255: "
			MP_DiplomacyWindow.resource_to_next[ResourceType.Silver] = ResourceType.Knowledge
			MP_DiplomacyWindow.resource_to_next[ResourceType.Knowledge] = ResourceType.Gold
			MP_DiplomacyWindow.resource_to_check[ResourceType.Knowledge] = {ResourceType.Knowledge}
			MP_DiplomacyWindow.allowed_resources[ResourceType.Knowledge] = true
			if MP_DiplomacyWindow.raw_resources_allowed then
				MP_DiplomacyWindow.resource_to_next[ResourceType.Silver] = ResourceType.Knowledge
				MP_DiplomacyWindow.resource_to_next[ResourceType.Knowledge] = ResourceType.GoldRaw
			end
		end
	end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------- EXTENDED STATISTICS --------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	ExtendedStatistics.ResourceToKey[ResourceType.Silver] = "Silver"
	ExtendedStatistics.ResourceToKey[ResourceType.SilverRaw] = "Silver"
	ExtendedStatistics.ResourceToKey[ResourceType.Knowledge] = "Coal"
	for player = 1, 16 do
		ExtendedStatistics.Players[player].DamageTakenByLightning = 0
		ExtendedStatistics.Players[player].AmountOfLightningStrikes = 0
		ExtendedStatistics.Players[player].UnitsLostThroughLightning = 0
		ExtendedStatistics.Players[player].Silver = 0
		ExtendedStatistics.Players[player].SilverLast = 0
		ExtendedStatistics.Players[player].ExchangedResources.Silver = 0
		ExtendedStatistics.Players[player].Coal = 0
		ExtendedStatistics.Players[player].CoalLast = 0
		ExtendedStatistics.Players[player].ExchangedResources.Coal = 0
	end
	CUtilStatistics.AddStatistic("DamageTakenByLightning", "Damage Taken By Lightning Strikes", "Damage/Attacks", "ExtendedStatistics_Callback_DamageTakenByLightning")
	CUtilStatistics.SetStatisticWidgetValues("normal",  "DamageTakenByLightning", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 0, 1))
	CUtilStatistics.SetStatisticWidgetValues("hovered", "DamageTakenByLightning", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 1, 1))
	CUtilStatistics.SetStatisticWidgetValues("pressed", "DamageTakenByLightning", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 2, 1))
	function ExtendedStatistics_Callback_DamageTakenByLightning(player)
		return ExtendedStatistics.Players[player].DamageTakenByLightning
	end
	CUtilStatistics.AddStatistic("AmountOfLightningStrikes", "Hit by Lightning Strikes", "Damage/Attacks", "ExtendedStatistics_Callback_AmountOfLightningStrikes")
	CUtilStatistics.SetStatisticWidgetValues("normal",  "AmountOfLightningStrikes", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 0, 4))
	CUtilStatistics.SetStatisticWidgetValues("hovered", "AmountOfLightningStrikes", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 1, 4))
	CUtilStatistics.SetStatisticWidgetValues("pressed", "AmountOfLightningStrikes", "graphics\\textures\\gui\\b_generic_building.png", GetTextureCoordinatesAt(4, 8, 2, 4))
	function ExtendedStatistics_Callback_AmountOfLightningStrikes(player)
		return ExtendedStatistics.Players[player].AmountOfLightningStrikes
	end
	CUtilStatistics.AddStatistic("UnitsLostThroughLightning", "Units Killed By Lightning", "Damage/Attacks", "ExtendedStatistics_Callback_UnitsLostThroughLightning")
	CUtilStatistics.SetStatisticWidgetValues("normal",  "UnitsLostThroughLightning", "graphics\\textures\\gui\\b_small_generic.png", GetTextureCoordinatesAt(128/26, 256/26, 0, 4))
	CUtilStatistics.SetStatisticWidgetValues("hovered", "UnitsLostThroughLightning", "graphics\\textures\\gui\\b_small_generic.png", GetTextureCoordinatesAt(128/26, 256/26, 0, 4))
	CUtilStatistics.SetStatisticWidgetValues("pressed", "UnitsLostThroughLightning", "graphics\\textures\\gui\\b_small_generic.png", GetTextureCoordinatesAt(128/26, 256/26, 0, 4))
	function ExtendedStatistics_Callback_UnitsLostThroughLightning(player)
		return ExtendedStatistics.Players[player].UnitsLostThroughLightning
	end
	CUtilStatistics.AddStatisticWithPM("SilverEarned", "Silver Earned", "Silver Earned Per Minute", "EarnedResources", "ExtendedStatistics_Callback_SilverEarned", "ExtendedStatistics_Callback_SilverEarnedPerMinute")
	CUtilStatistics.SetStatisticWidgetValues("normal",  "SilverEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 0, 23))
	CUtilStatistics.SetStatisticWidgetValues("hovered", "SilverEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 1, 23))
	CUtilStatistics.SetStatisticWidgetValues("pressed", "SilverEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 2, 23))
	function ExtendedStatistics_Callback_SilverEarned(player)
		return ExtendedStatistics.Players[player].Silver
	end
	function ExtendedStatistics_Callback_SilverEarnedPerMinute(player)
		local current = ExtendedStatistics.Players[player].Silver
		local last = ExtendedStatistics.Players[player].SilverLast
		ExtendedStatistics.Players[player].SilverLast = current
		return current - last
	end
	CUtilStatistics.AddStatisticWithPM("CoalEarned", "Coal Earned", "Coal Earned Per Minute", "EarnedResources", "ExtendedStatistics_Callback_CoalEarned", "ExtendedStatistics_Callback_CoalEarnedPerMinute")
	CUtilStatistics.SetStatisticWidgetValues("normal",  "CoalEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 0, 24))
	CUtilStatistics.SetStatisticWidgetValues("hovered", "CoalEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 1, 24))
	CUtilStatistics.SetStatisticWidgetValues("pressed", "CoalEarned", "data\\graphics\\textures\\b_statistics.png", GetTextureCoordinatesAt(4, 32, 2, 24))
	function ExtendedStatistics_Callback_CoalEarned(player)
		return ExtendedStatistics.Players[player].Coal
	end
	function ExtendedStatistics_Callback_CoalEarnedPerMinute(player)
		local current = ExtendedStatistics.Players[player].Coal
		local last = ExtendedStatistics.Players[player].CoalLast
		ExtendedStatistics.Players[player].CoalLast = current
		return current - last
	end
end
-- anti abrissbug; geklaut aus EMS
BS.AC = {}
function BS.AC.Setup()
	-- fix sell building bug, basically only for lan games
	BS.AC.SB = GUI.SellBuilding;
	BS.AC.LastId = 0;
	BS.AC.CheckSellBuilding = true;
	GUI.SellBuilding = function(_id)
		if BS.AC.CheckSellBuilding then
			if _id == BS.AC.LastId then
				return;
			end
		end
		BS.AC.LastId = _id
		BS.AC.SB(_id)
	end
end