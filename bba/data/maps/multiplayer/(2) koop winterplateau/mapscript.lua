----------------------------------------------------------------------------------------------------
-- MapName: (2) Winterplateau v2
-- Author: Play4FuN
-- 08/2018
-- recent changes: weather clearer, fixed random
----------------------------------------------------------------------------------------------------

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Winterplateau "
gvMapVersion = " v1.2 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	TagNachtZyklus(24,1,1,-3,1)
	StartTechnologies()

	Mission_InitGroups()

	-- Init  global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	if XNetwork.Manager_DoesExist() == 0 then
		for i = 1, 2 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )

		-- no player 2 here? give it all to player 1
		Logic.ChangeAllEntitiesPlayerID(1, PlayerID)
		Logic.ChangeAllEntitiesPlayerID(2, PlayerID)
		-- and add some gold
		AddGold(1, 200)

		NewOnGameLoaded()

	end

	LocalMusic.UseSet = EUROPEMUSIC

	-- map stuff

	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player

	InitColors()
	HackAutoRefill(2)
	Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
	Logic.SetShareExplorationWithPlayerFlag(2, 1, 1)
	SetupDiplomacy()

	StartSimpleJob("VictoryJob")
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")

	local n
	for n = 1, 4 do
		CreateWoodPile("Holz"..n, 500000)
	end

	-- zoom and free rotation
	Camera.ZoomSetFactorMax(2)		-- better zoom
	Camera.RotSetFlipBack(0)		-- free rotation
	Camera.RotSetAngle(-45)			-- standard value	--> without this command the map would start with the last used camera angle! (as flip back is turned off)
	Input.KeyBindDown(Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2)

	-- health display
	gvMission.UseHeroHealthDisplay = true
	HackHeroHealthDisplay()
	Input.KeyBindDown(Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2)

	Trigger.RequestTrigger(Events.LOGIC_EVENT_TRIBUTE_PAID, nil, "Trade_TributePaid_Action", 1, nil, nil)

	-- init change formation for troops
	InitFormationsMod()

	-- buy hero comfortable
	BuyHeroWindow_Action_BuyHero_Orig = BuyHeroWindow_Action_BuyHero
	BuyHeroWindow_Action_BuyHero = function(_hero)
		BuyHeroWindow_Action_BuyHero_Orig(_hero)
		if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) < 2 then	-- amount to buy is updated very late!
			XGUIEng.ShowWidget("Buy_Hero", 0)	-- hide it after last hero has been bought (usually hides when HQ is selected again)
		else
			XGUIEng.ShowWidget(gvGUI_WidgetID.BuyHeroWindow, 1)	-- new: keep the menu open for as long as heroes can be bought
		end
	end

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
end
function TributeP1_Easy()
	local TrP1_E =  {}
	TrP1_E.playerId = 1
	TrP1_E.text = "Klickt hier, um den @color:0,255,0 leichten @color:255,255,255 Spielmodus zu spielen"
	TrP1_E.cost = { Gold = 0 }
	TrP1_E.Callback = TributePaid_P1_Easy
	TP1_E = AddTribute(TrP1_E)
end
function TributeP1_Normal()
	local TrP1_N =  {}
	TrP1_N.playerId = 1
	TrP1_N.text = "Klickt hier, um den @color:200,115,90 normalen @color:255,255,255 Spielmodus zu spielen"
	TrP1_N.cost = { Gold = 0 }
	TrP1_N.Callback = TributePaid_P1_Normal
	TP1_N = AddTribute(TrP1_N)
end
function TributeP1_Hard()
	local TrP1_H =  {}
	TrP1_H.playerId = 1
	TrP1_H.text = "Klickt hier, um den @color:200,60,60 schweren @color:255,255,255 Spielmodus zu spielen"
	TrP1_H.cost = { Gold = 0 }
	TrP1_H.Callback = TributePaid_P1_Hard
	TP1_H = AddTribute(TrP1_H)
end
function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 6 )
	gvDiffLVL = 2.2

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 5 )
	gvDiffLVL = 1.6

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 1.0

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	for i = 1,2 do
		ForbidTechnology(Technologies.T_MakeSummer, i)
		ForbidTechnology(Technologies.T_MakeRain, i)
		ForbidTechnology(Technologies.T_MakeThunderstorm, i)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function StartInitialize()

	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	--
	SetupAIs()
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end

function Trade_TributePaid_Action()	-- FIX: close tribute menu after selecting an option/trade
	GUIAction_ToggleMenu( gvGUI_WidgetID.TradeWindow, 0)
end

----------------------------------------------------------------------------------------------------
-- Build Groups and attach Leaders
function Mission_InitGroups()
	local i
	for i = 1, 14 do
		Tools.CreateSoldiersForLeader(GetEntityId("bbow"..i), 4)
		Tools.CreateSoldiersForLeader(GetEntityId("bswo"..i), 8)
	end
end

----------------------------------------------------------------------------------------------------
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	--no limitation in this map
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

----------------------------------------------------------------------------------------------------
-- Set local resources
function Mission_InitLocalResources()

	--local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= dekaround(800*gvDiffLVL)
	local InitClayRaw 		= dekaround(1500*gvDiffLVL)
	local InitWoodRaw 		= dekaround(1500*gvDiffLVL)
	local InitStoneRaw 		= dekaround(800*gvDiffLVL)
	local InitIronRaw 		= dekaround(500*gvDiffLVL)
	local InitSulfurRaw		= dekaround(500*gvDiffLVL)


	--Add Players Resources
	local i
	for i = 1, 2
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end

----------------------------------------------------------------------------------------------------
function SJ_DefeatP1()
	if IsDead("HQP1") then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("HQP2") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

----------------------------------------------------------------------------------------------------
-- victory condition
function VictoryJob()
	if IsDead("HQP3") and IsDead("HQP4") and IsDead("HQP5") then
		Victory()
		return true
	end
end

----------------------------------------------------------------------------------------------------
-- ai
function SetupAIs()

	MapEditor_SetupAI(3, round(4-gvDiffLVL), 20000, 3, "HQP3", 3, 30*60*gvDiffLVL)
	MapEditor_SetupAI(4, round(4-gvDiffLVL), 20000, 3, "HQP4", 3, 30*60*gvDiffLVL)
	MapEditor_SetupAI(5, round(4-gvDiffLVL), 25000, 3, "HQP5", 3, 40*60*gvDiffLVL)
	for i = 3,5 do
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength - 10
	end
	InitTechTables()
	--
	StartCountdown(2*60*60*gvDiffLVL, MakeP5MoreAggressive, true)
end
function MakeP5MoreAggressive()
	MapEditor_Armies[5].offensiveArmies.rodeLength = Logic.WorldGetSize()
end
function SetupDiplomacy()
	for p = 1, 2 do
		SetHostile(p, 3)
		SetHostile(p, 4)
		SetHostile(p, 5)
		SetHostile(p, 6)
	end
	SetFriendly(1,2)

	local R, G, B = GUI.GetPlayerColor( 1 )
	SetPlayerName(1, "@color:"..R..","..G..","..B.." "..UserTool_GetPlayerName(1))
	local R, G, B = GUI.GetPlayerColor( 2 )
	SetPlayerName(2, "@color:"..R..","..G..","..B.." "..UserTool_GetPlayerName(2))

	-- colors
	Display.SetPlayerColorMapping(3, NEPHILIM_COLOR)	-- red
	Display.SetPlayerColorMapping(4, NEPHILIM_COLOR)	-- red
	Display.SetPlayerColorMapping(5, ENEMY_COLOR1)		-- violett

	local R, G, B = GUI.GetPlayerColor( 3 )
	SetPlayerName(3, "@color:"..R..","..G..","..B.." Ruttford")
	local R, G, B = GUI.GetPlayerColor( 5 )
	SetPlayerName(5, "@color:"..R..","..G..","..B.." Burg Krähennest")

end

----------------------------------------------------------------------------------------------------
-- code for formation change
function InitFormationsMod()
	-- init change formation for troops
	Input.KeyBindDown(Keys.D1 + Keys.ModifierShift, "MOD_SetFormation(1)", 2)
	Input.KeyBindDown(Keys.D2 + Keys.ModifierShift, "MOD_SetFormation(2)", 2)
	Input.KeyBindDown(Keys.D3 + Keys.ModifierShift, "MOD_SetFormation(3)", 2)
	Input.KeyBindDown(Keys.D4 + Keys.ModifierShift, "MOD_SetFormation(4)", 2)
	Input.KeyBindDown(Keys.D5 + Keys.ModifierShift, "MOD_SetFormation(5)", 2)
	Input.KeyBindDown(Keys.D6 + Keys.ModifierShift, "MOD_SetFormation(6)", 2)
	Input.KeyBindDown(Keys.D7 + Keys.ModifierShift, "MOD_SetFormation(7)", 2)
	Input.KeyBindDown(Keys.D8 + Keys.ModifierShift, "MOD_SetFormation(8)", 2)
	Input.KeyBindDown(Keys.D9 + Keys.ModifierShift, "MOD_SetFormation(9)", 2)
end

function FormationsAllowed(id)
	local typeName = Logic.GetEntityTypeName(Logic.GetEntityType(id))

	-- return true if the type name fits to one of these
	return (string.find(string.lower(typeName), "leadersword") ~= nil)
	or (string.find(string.lower(typeName), "leaderbow") ~= nil)
	or (string.find(string.lower(typeName), "leaderpolearm") ~= nil)
	or (string.find(string.lower(typeName), "leaderrifle") ~= nil)
	or (string.find(string.lower(typeName), "leaderheavycavalry") ~= nil)
	or (string.find(string.lower(typeName), "leadercavalry") ~= nil)
	or (string.find(string.lower(typeName), "evilleader") ~= nil)
	or (string.find(string.lower(typeName), "evil_leader") ~= nil)
	or (string.find(string.lower(typeName), "barbarian_leader") ~= nil)
	or (string.find(string.lower(typeName), "blackknight_leader") ~= nil)
	or (string.find(string.lower(typeName), "veteranmajor") ~= nil)
	or (string.find(string.lower(typeName), "veteranlieutenant") ~= nil)
end

function MOD_SetFormation(formation)
	local n
	local SelectedEntityIDs = {GUI.GetSelectedEntities()}
	local change = false

	if SelectedEntityIDs == nil then
		return false
	end

	for n = 1, table.getn(SelectedEntityIDs) do
		if FormationsAllowed(SelectedEntityIDs[n]) == true then
			--Logic.LeaderChangeFormationType(SelectedEntityIDs[n], formation)
			GUI.LeaderChangeFormationType(SelectedEntityIDs[n], formation)	-- for MP
			change = true
		end
	end

	-- finally play the sound once if required
	if change == true then
		Sound.PlayGUISound(Sounds.VoicesLeader_LEADER_ChangeFormation_rnd_01, 100)
	end
end


-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitColors()
	col = {}
	-- Reihenfolge: Rot,Grün,Blau
	col.w		= " @color:255,255,255 "
	col.gruen	= " @color:0,255,0 "
	col.blau	= " @color:20,20,240 "
	col.P4F		= " @color:166,212,35 "
	col.grau	= " @color:180,180,180 "
	col.dgrau	= " @color:120,120,120 "
	col.beig	= " @color:240,220,200 "
	col.gelb 	= " @color:255,200,0 "
	col.hgelb 	= " @color:238,221,130 "
	col.orange 	= " @color:255,127,0 "
	col.rot		= " @color:255,0,0 "
	col.hgruen	= " @color:173,255,47 "
	col.hblau 	= " @color:0,255,255 "
	col.pink	= " @color:200,100,200 "
	col.transp	= " @color:0,0,0,0 "
	col.keyb	= " @color:220,220,150 "
	col.schwarz	= " @color:40,40,40 "
	col.blauFIX	= " @color:50,50,220 "
	col.gruenFIX= " @color:0,200,0 "
end

----------------------------------------------------------------------------------------------------
function HackAutoRefill(_players)	-- max player amount

	StartSimpleJob("SJ_CheckAutoFill")

	gvMission.Autofill = {}
	if _players < 1 then
		return
	end
	local i
	for i = 1, _players do
		gvMission.Autofill[i] = true
	end

	-- v2

--	XGUIEng.SetWidgetPosition(XGUIEng.GetWidgetID("Research_BetterTrainingBarracks"), 74, 4)	--110,4
	GUI.DeactivateAutoFillAtBarracks = function(_entity)
		-- toggle autofill
		gvMission.Autofill[gvMission.PlayerID] = not gvMission.Autofill[gvMission.PlayerID]
	end

	GUITooltip_GenericOrig = GUITooltip_Generic
	GUITooltip_Generic = function(a)
		if a == "MenuBuildingGeneric/RecruitGroups" then
			if gvMission.Autofill[gvMission.PlayerID] == true then
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, col.grau.."Automatisches Rekrutieren ausschalten @cr "..col.w.."Eure Hauptmänner werden nur neue Soldaten in ihre Gruppe aufnehmen, wenn Ihr es ihnen befehlt.")
			else
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, col.grau.."Automatisches Rekrutieren anschalten @cr "..col.gelb.."ermöglicht:"..col.w.."Eure Hauptmänner können selbstständig neue Soldaten in ihre Gruppe aufnehmen, sofern genügend Plätze und Rohstoffe vorhanden sind.")
			end
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "")
		else
			GUITooltip_GenericOrig(a)
		end
	end

end

function SJ_CheckAutoFill()

	if gvMission.Autofill[gvMission.PlayerID] == true then
		for n = 1, Logic.GetNumberOfLeader(gvMission.PlayerID) do
			LeaderID = Logic.GetNextLeader(gvMission.PlayerID, LastLeaderID)
			if LeaderID ~= 0 then
				if Logic.LeaderGetBarrack(LeaderID) == 0 then
					MilitaryBuildingID = Logic.LeaderGetNearbyBarracks(LeaderID)
					if MilitaryBuildingID ~= 0	then
						if Logic.GetPlayerAttractionUsage(gvMission.PlayerID) < Logic.GetPlayerAttractionLimit(gvMission.PlayerID) then
							UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory(LeaderID)
							Soldiers = Logic.LeaderGetNumberOfSoldiers(LeaderID)
							MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(LeaderID)
							if Soldiers < MaxSoldiers then
								BuyAmount = MaxSoldiers - Soldiers
								for i = 1, BuyAmount do
									local CostTable = {}
									Logic.FillSoldierCostsTable(gvMission.PlayerID, UpgradeCategory, CostTable)
									if HasPlayerEnoughResources(gvMission.PlayerID, CostTable) == true then	-- costs are ok
										--Message("buy id: "..LeaderID)
										GUI.BuySoldier(LeaderID)
									end
								end
							end
						end
					end
				end
				LastLeaderID = LeaderID
			end
		end
	end
end

-- bug fix: from Tools.HasPlayerEnoughResources but uses wood instead of silver!
function HasPlayerEnoughResources(_PlayerID, _Costs)

	-- Get resources
	local Wood = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Wood ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.WoodRaw)
	local Gold   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Gold ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.GoldRaw)
	local Iron   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Iron ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.IronRaw)
	local Stone  = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Stone ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.StoneRaw)
	local Sulfur = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Sulfur ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.SulfurRaw)

	-- Enough
	return 		(Wood >= _Costs[ResourceType.Wood])
		and 	(Gold >= _Costs[ResourceType.Gold])
		and 	(Iron >= _Costs[ResourceType.Iron])
		and 	(Stone >= _Costs[ResourceType.Stone])
		and 	(Sulfur >= _Costs[ResourceType.Sulfur])
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitTechTables()

	_TechTable = {
	Technologies.T_SoftArcherArmor,
	Technologies.T_LeatherMailArmor,
	Technologies.T_Fletching,
	Technologies.T_WoodAging,
	Technologies.T_ChainMailArmor,
	Technologies.T_LeatherArcherArmor,
	Technologies.T_MasterOfSmithery,
	Technologies.T_BodkinArrow,
	Technologies.T_Turnery,
	Technologies.T_BetterTrainingArchery,
	Technologies.T_BetterTrainingBarracks,
	Technologies.T_FleeceArmor,
	Technologies.T_FleeceLinedLeatherArmor,
	Technologies.T_LeadShot,
	Technologies.T_Sights,
	Technologies.T_BlisteringCannonballs,
	Technologies.T_BetterChassis,
	Technologies.T_EnhancedGunPowder
	}

	for i = 1, table.getn(_TechTable) do
		ResearchTechnology(_TechTable[i], 3)
		ResearchTechnology(_TechTable[i], 4)
		ResearchTechnology(_TechTable[i], 5)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function NewOnGameLoaded()
	Mission_OnSaveGameLoaded_Orig = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_Orig()
		InitFormationsMod()

		-- autofill
		GUI.DeactivateAutoFillAtBarracks = function(_entity)
			-- toggle autofill
			gvMission.Autofill[gvMission.PlayerID] = not gvMission.Autofill[gvMission.PlayerID]
		end

		Input.KeyBindDown(Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2)
		Input.KeyBindDown(Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2)

		-- playercolors
		Display.SetPlayerColorMapping(3, NEPHILIM_COLOR)	-- red
		Display.SetPlayerColorMapping(4, NEPHILIM_COLOR)	-- red
		Display.SetPlayerColorMapping(5, ENEMY_COLOR1)		-- violett
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function ToggleHeroDisplay()
	gvMission.UseHeroHealthDisplay = not gvMission.UseHeroHealthDisplay
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function HackHeroHealthDisplay()

	GUIUpdate_HeroButtonOrig = GUIUpdate_HeroButton

	GUIUpdate_HeroButton = function()

		if not gvMission.UseHeroHealthDisplay then
			GUIUpdate_HeroButtonOrig()
			return
		end

		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local EntityID = XGUIEng.GetBaseWidgetUserVariable(CurrentWidgetID, 0)
		local health = GetHealth(EntityID)
		local R, G, B
		B = 0
		if health == 100 then
			R, G, B = 255, 255, 255
		elseif health > 50 then
			G = 255
			R = 255 - health * 5.1
		else
			R = 255
			G = health * 5.1
		end

		local SourceButton
		if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero1) == 1 then
			SourceButton = "FindHeroSource1"
			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)

			if Logic.SentinelGetUrgency(EntityID) == 1 then

			if gvGUI.DarioCounter < 50 then

				XGUIEng.SetMaterialColor(CurrentWidgetID,0, 100,100,200,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID,1, 100,100,200,255)
				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end
			if gvGUI.DarioCounter >= 50 then
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)

				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end
			if gvGUI.DarioCounter == 100 then
				gvGUI.DarioCounter= 0
			end
			else
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)
			end

		else

			if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero2) == 1 then
				SourceButton = "FindHeroSource2"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero3) == 1 then
				SourceButton = "FindHeroSource3"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero4) == 1 then
				SourceButton = "FindHeroSource4"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero5) == 1 then
				SourceButton = "FindHeroSource5"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero6) == 1 then
				SourceButton = "FindHeroSource6"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_BlackKnight then
				SourceButton = "FindHeroSource7"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Mary_de_Mortfichet then
				SourceButton = "FindHeroSource8"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Barbarian_Hero then
				SourceButton = "FindHeroSource9"

			--AddOn
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero10) == 1 then
				SourceButton = "FindHeroSource10"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero11) == 1 then
				SourceButton = "FindHeroSource11"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Evil_Queen then
				SourceButton = "FindHeroSource12"

			else
				SourceButton = "FindHeroSource9"
			end

			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)

			XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
			XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)

		end

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function GetHealth( _entity )
    local entityID = GetEntityId( _entity )
    if not Tools.IsEntityAlive( entityID ) then
        return 0
    end
    local MaxHealth = Logic.GetEntityMaxHealth( entityID )
    local Health = Logic.GetEntityHealth( entityID )
    return ( Health / MaxHealth ) * 100
end

-------------------------------------------------------------------------------------------------------------------------------------------------------


