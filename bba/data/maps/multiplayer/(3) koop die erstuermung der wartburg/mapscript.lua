--------------------------------------------------------------------------------
-- MapName: (3) Die Erstürmung der Wartburg
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ............ @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (3) Die Erstürmung der Wartburg "
gvMapVersion = " v1.2 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,0,0,0,1)

	-- Init  global MP stuff
	if CNetwork then
		if GUI.GetPlayerID() ~= 17 then
			SetUpGameLogicOnMPGameConfigLight()
		end
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

	for i = 1, 3 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		Logic.SetPlayerPaysLeaderFlag(i, 0)
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	--
	InitPlayerColorMapping()
	--
	LocalMusic.UseSet = MEDITERANEANMUSIC
	ActivateBriefingsExpansion()

	-- nix für Drückeberger : )
	DZTrade_PunishmentJob = function() return true end
	GUIAction_ExpelSettler = function() end
	GUI.SellBuilding = function() end
	GUIAction_ExpelAll = function() end

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
	gvDiffLVL = 2.0
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,3 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_Turnery,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_BlisteringCannonballs,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
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
	gvDiffLVL = 1.6
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,3 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_Turnery,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_BlisteringCannonballs,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
	end
	StartInitialize()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	--
	gvDiffLVL = 1.2
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,3 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
	end
	StartInitialize()
end

function StartInitialize()

	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2,3},Diplomacy.Hostile)
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(2,3)
		for i = 1, 3 do
			SetNeutral(i, 5)
		end
	else
		SetHostile(1,4)
		SetNeutral(1,5)
	end

	IncludeGlobals("Tools\\ArmyCreator")
	ArmyCreator.BasePoints = 150
	ArmyCreator.PlayerPoints = 150 * gvDiffLVL
	if not CNetwork then
		ArmyCreator.PlayerPoints = ArmyCreator.PlayerPoints * 3
		ArmyCreator.BasePoints = ArmyCreator.BasePoints * 3
	end

	TimeLimit = (8+8*gvDiffLVL)*60

	local tab = ChestRandomPositions.CreateChests(5)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	StartCountdown(3,ShowArmyCreatorGUI,false)
	StartCountdown(6,Mission_InitGroups,false)

	function ArmyCreator.OnSetupFinished()

		HideArmyCreatorGUI()
		XGUIEng.ShowWidget("ChangeIntoSerf",0)

		StartSimpleJob("DefeatJob")
		StartSimpleJob("VictoryJob")

		StartSimpleJob("AreaCheck1")
		StartSimpleJob("AreaCheck2")

		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "CatapultRangeExploitNoDamage", 1)

		StartCountdown(5*60*gvDiffLVL,UpgradeKIa,false)
		DefeatCountdown = StartCountdown(TimeLimit,DefeatTimer,true)

		Siege.DefenderIDs = {4}
		Siege.AttackerIDs = {1,2,3}
		Siege.Init()
		StartSimpleHiResJob("AnfangsBriefingInitialize")

		function GUIAction_BuyMerchantOffer(_index)

			local PlayerID = GUI.GetPlayerID()

			Logic.GetMercenaryOffer(SelectedTroopMerchantID,_index, InterfaceGlobals.CostTable)

			if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then
				-- Yes
				GUI.BuyMerchantOffer(SelectedTroopMerchantID, PlayerID, _index)
				GUIUpdate_TroopOffer(_index)
			end

		end
	end

end

function AnfangsBriefingInitialize()
	Siege.CreateTraps(4, 3700, 12200, 2000, round(10/gvDiffLVL), 300)
	Siege.CreateTraps(4, 7100, 7200, 2000, round(10/gvDiffLVL), 300)
	Siege.CreateTraps(4, 7600, 15500, 1200, round(8/gvDiffLVL), 300)
	Siege.CreateTraps(4, 10400, 16800, 2700, round(14/gvDiffLVL), 300)
	Siege.CreateTraps(4, 14400, 16100, 2000, round(10/gvDiffLVL), 300)
	Siege.CreateTraps(4, 20300, 13800, 3000, round(15/gvDiffLVL), 300)
	Siege.CreateTraps(4, 23000, 8500, 1800, round(8/gvDiffLVL), 300)
	Siege.CreatePitchFields(3000, 12500, 4000, round(5-gvDiffLVL), round(10/gvDiffLVL))
	Siege.CreatePitchFields(5000, 14600, 1200, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(7800, 15800, 1800, round(5-gvDiffLVL), round(5/gvDiffLVL))
	Siege.CreatePitchFields(11000, 15300, 1200, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(16700, 14900, 2700, round(5-gvDiffLVL), round(7/gvDiffLVL))
	Siege.CreatePitchFields(19000, 11800, 4000, round(5-gvDiffLVL), round(10/gvDiffLVL))
	AnfangsBriefing()
	return true
end
function UpgradeKIa()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown(5*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_Turnery,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_BlisteringCannonballs,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
	end
	StartCountdown(6*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
end

function AnfangsBriefing()

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Anführer",
        text	= "@color:230,0,0 Los Männer. @cr Die Wartburg liegt direkt vor uns. @cr Auf sie mit Gebrüll.",
		position = GetPosition("start_pos_p1")
    }
    StartBriefing(briefing)

end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
		-- no cannons or catapults on this map, battle ram instead
		XGUIEng.ShowWidget("BS_ArmyCreator_Cannon_T1",0)
		XGUIEng.ShowWidget("BS_ArmyCreator_Cannon_T2",0)
		XGUIEng.ShowWidget("BS_ArmyCreator_Cannon_T3",0)
		XGUIEng.ShowWidget("BS_ArmyCreator_Cannon_T4",0)
		XGUIEng.ShowWidget("BS_ArmyCreator_Catapult",0)
		XGUIEng.ShowWidget("BS_ArmyCreator_Ram",1)
		if gvChallengeFlag then
			XGUIEng.ShowWidget("BS_ArmyCreator_Bow_T4",0)
			XGUIEng.ShowWidget("BS_ArmyCreator_Cavalry_T2",0)
			XGUIEng.ShowWidget("BS_ArmyCreator_Hero10",0)
		end
	end
end
function HideArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",1)
		XGUIEng.ShowWidget("BS_ArmyCreator",0)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()

	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(4), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		Logic.GroupStand(eID)
	end
	local idtable = {	[1] = {}
					}
	do
		local pos = {X = 5700, Y = 13600}
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 8100, Y = 13600}
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 10100, Y = 13600}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 12100, Y = 13600}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 14100, Y = 13600}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 15800, Y = 12200}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 17300, Y = 10300}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 19300, Y = 10300}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 15800, Y = 8800}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 14800, Y = 8000}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 12400, Y = 9200}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities.PU_LeaderBow4, 0, 12, pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 8600, Y = 9700}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 6600, Y = 9700}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 5700, Y = 12000}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end

	local army = {}
	army.player 	= 4
	army.id			= 0
	army.strength	= math.max(6-math.ceil(gvDiffLVL), 1)
	army.position	= {X = 10400, Y = 11500}
	army.rodeLength	= 2200

	SetupArmy(army)

	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities.CU_BlackKnight_LeaderSword3
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	Mission_InitTechnologies()

	local mercenaryId = Logic.GetEntityIDByName("merc1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_VeteranMajor, 6, ResourceType.Silver, 200)
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 350)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword3, 12, ResourceType.Gold, 300)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, 5, ResourceType.Gold, 500)

end
function InitPlayerColorMapping()

	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrame"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMapOverlay"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMap"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrameBG"),0)
--**
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Container"),0,0,1400,1000)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Text"),100,669,850,48)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"),0,1000,1200,128)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,600,100)

	SetPlayerName(4, "Wartburg")

	Display.SetPlayerColorMapping(4,2)

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	for i = 1,3 do
		ForbidTechnology(Technologies.B_Residence, i)
		ForbidTechnology(Technologies.B_Farm, i)
		ForbidTechnology(Technologies.B_GenericMine, i)
		ForbidTechnology(Technologies.B_University, i)
		ForbidTechnology(Technologies.B_Village, i)
		ForbidTechnology(Technologies.B_VillageHall, i)
		ForbidTechnology(Technologies.B_Claymine, i)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()
end

function DefeatTimer()

	Message("Ihr habt es nicht geschafft, alle Feinde innerhalb von ".. round(TimeLimit/60) .." Minuten zu besiegen... @cr Versucht es erneut!")
	Defeat()

end
function DefeatJob()
	local t1,t2,t3,t = {},{},{},{}
	Logic.GetHeroes(1, t1)
	Logic.GetHeroes(2, t2)
	Logic.GetHeroes(3, t3)
	for i in t1 do
		local id = t1[i]
		if IsAlive(id) then
			table.insert(t, id)
		end
	end
	for i in t2 do
		local id = t2[i]
		if IsAlive(id) then
			table.insert(t, id)
		end
	end
	for i in t3 do
		local id = t3[i]
		if IsAlive(id) then
			table.insert(t, id)
		end
	end
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + Logic.GetNumberOfLeader(3) + table.getn(t3)) == 0 then
		Defeat()
		return true
	end
end
function VictoryJob()

	if AI.Player_GetNumberOfLeaders(4) == 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.CB_OSO_Castle1) == 0 then
		Victory()
		StopCountdown(DefeatCountdown)
		return true
	end

end
function AreaCheck1()

	if AreEntitiesOfDiplomacyStateInArea(4, {X = 5700, Y = 12000}, 5500, Diplomacy.Hostile) then
		Stream.Start("Sounds\\military\\drumhorn.wav", 152)
		Army0()
		Army1()
		return true
	end
end
function Army0()
	local army	 = {}

	army.player 	= 4
	army.id			= 0
	army.strength	= 8-math.ceil(gvDiffLVL)
	army.position	= {X = 7400, Y = 2600}
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {

		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(round(gvDiffLVL),2)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(round(gvDiffLVL),2)]}
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription[math.random(1,2)])
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
end
function Army1()
	local army	 = {}

	army.player 	= 4
	army.id			= 1
	army.strength	= 12-math.ceil(gvDiffLVL)
	army.position	= GetPosition("start_pos_p1")
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {

		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(round(gvDiffLVL),2)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(round(gvDiffLVL),2)]}
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription[math.random(1,2)])
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
end
function AreaCheck2()

	if AreEntitiesOfDiplomacyStateInArea(4, {X = 8600, Y = 11800}, 2000, Diplomacy.Hostile) then
		Army2()
		Army3()
		return true
	end
end
function Army2()
	local army	 = {}

	army.player 	= 4
	army.id			= 2
	army.strength	= 9-math.ceil(gvDiffLVL)
	army.position	= GetPosition("start_pos_p1")
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {

		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(round(gvDiffLVL),2)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(round(gvDiffLVL),2)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderBow".. 5 - math.min(round(gvDiffLVL),4)]}
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription[math.random(1,3)])
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
end
function Army3()
	local army	 = {}

	army.player 	= 4
	army.id			= 3
	army.strength	= 12-math.ceil(gvDiffLVL)
	army.position	= {X = 10400, Y = 11500}
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {

		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderSword".. 5 - math.min(round(gvDiffLVL),4)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities["PU_LeaderPoleArm".. 5 - math.min(round(gvDiffLVL),4)]},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BlackKnight_LeaderSword3},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BlackKnight_LeaderMace2},
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription[math.random(1,4)])
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
end

function ControlArmies(_player, _id)

    if IsDead(ArmyTable[_player][_id + 1]) then
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
function CatapultRangeExploitNoDamage()

	local attacker = Event.GetEntityID1()

	local attackerpos = GetPosition(attacker)

    local target = Event.GetEntityID2()

	local targetpos = GetPosition(target)

	local attype = Logic.GetEntityType(attacker)

	if attype == Entities.PV_Catapult then

		local maxrange = round(GetEntityTypeMaxAttackRange(attacker, Logic.EntityGetPlayer(attacker)))

		if math.abs(GetDistance(attackerpos,targetpos)) > (maxrange + 100) then

			CEntity.TriggerSetDamage(0)

		end

	end

end
function SetUpGameLogicOnMPGameConfigLight()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Transfer player names
	do
		for PlayerID=1, HumenPlayer, 1 do
			local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
			Logic.SetPlayerRawName( PlayerID, PlayerName )
		end
	end

	-- Set game state & human flag - transfer player color (needed in logic for post game statistics)
	do
		for PlayerID=1, HumenPlayer, 1 do
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 1 then
				Logic.PlayerSetGameStateToPlaying( PlayerID )
				Logic.PlayerSetIsHumanFlag( PlayerID, 1 )

				local PlayerColorR, PlayerColorG, PlayerColorB = GUI.GetPlayerColor( PlayerID )
				Logic.PlayerSetPlayerColor( PlayerID, PlayerColorR, PlayerColorG, PlayerColorB )
			end
		end
	end

	-- Set up FoW
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig()


	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)

	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	--Extra keybings only in MP
	Input.KeyBindDown(Keys.NumPad0, "KeyBindings_MPTaunt(1,1)", 2)  --Yes
	Input.KeyBindDown(Keys.NumPad1, "KeyBindings_MPTaunt(2,1)", 2)  --No
	Input.KeyBindDown(Keys.NumPad2, "KeyBindings_MPTaunt(3,1)", 2)  --Now
	Input.KeyBindDown(Keys.NumPad3, "KeyBindings_MPTaunt(7,1)", 2)  --help
	Input.KeyBindDown(Keys.NumPad4, "KeyBindings_MPTaunt(8,1)", 2)  --clay
	Input.KeyBindDown(Keys.NumPad5, "KeyBindings_MPTaunt(9,1)", 2)  --gold
	Input.KeyBindDown(Keys.NumPad6, "KeyBindings_MPTaunt(10,1)", 2) --iron
	Input.KeyBindDown(Keys.NumPad7, "KeyBindings_MPTaunt(11,1)", 2) --stone
	Input.KeyBindDown(Keys.NumPad8, "KeyBindings_MPTaunt(12,1)", 2) --sulfur
	Input.KeyBindDown(Keys.NumPad9, "KeyBindings_MPTaunt(13,1)", 2) --wood

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "KeyBindings_MPTaunt(5,1)", 2)  --attack here
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "KeyBindings_MPTaunt(6,1)", 2)  --defend here

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "KeyBindings_MPTaunt(4,0)", 2)  --attack you
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad3, "KeyBindings_MPTaunt(14,0)", 2) --VeryGood
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_MPTaunt(15,0)", 2) --Lame
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_MPTaunt(16,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_MPTaunt(17,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_MPTaunt(18,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_MPTaunt(19,0)", 2) --funny comments

end