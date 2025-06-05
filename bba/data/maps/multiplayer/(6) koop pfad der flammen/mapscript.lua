--------------------------------------------------------------------------------
-- MapName: (6) Pfad der Flammen
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ............ @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (6) Pfad der Flammen "
gvMapVersion = " v1.2 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,0,1,0,1)

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
	TributeP1_Insane()

	for i = 1, 6 do
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
	LocalMusic.UseSet = HIGHLANDMUSIC
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
function TributeP1_Insane()
	local TrP1_I =  {}
	TrP1_I.playerId = 1
	TrP1_I.text = "Klickt hier, um den @color:255,30,30 irrsinnigen @color:255,255,255 Spielmodus zu spielen"
	TrP1_I.cost = { Gold = 0 }
	TrP1_I.Callback = TributePaid_P1_Insane
	TP1_I = AddTribute(TrP1_I)
end

function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_I)
	--
	gvDiffLVL = 2.2
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,6 do
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
	Logic.RemoveTribute(1,TP1_I)
	--
	gvDiffLVL = 1.7
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,6 do
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
	Logic.RemoveTribute(1,TP1_I)
	--
	gvDiffLVL = 1.3
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,6 do
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
function TributePaid_P1_Insane()
	Message("Ihr habt euch für den @color:255,30,30 irrsinnigen @color:255,255,255 Spielmodus entschieden! Seid ihr verrückt?! @cr Nun denn, ihr wollt es ja nicht anders...")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	gvChallengeFlag = 1
	gvDiffLVL = 1.0
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,30,30 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,6 do
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
		SetHumanPlayerDiplomacyToAllAIs({1,2,3,4,5,6},Diplomacy.Hostile)
		SetPlayerDiplomacy({1,2,3,4,5,6}, Diplomacy.Friendly)
		for i = 1, 6 do
			SetNeutral(i, 7)
		end
	else
		SetHostile(1,8)
	end

	IncludeGlobals("Tools\\ArmyCreator")
	ArmyCreator.TroopLimit = 15
	ArmyCreator.BasePoints = 200
	ArmyCreator.PlayerPoints = 200 * gvDiffLVL
	if not CNetwork then
		ArmyCreator.TroopLimit = 90
		ArmyCreator.PlayerPoints = ArmyCreator.PlayerPoints * 6
		ArmyCreator.BasePoints = ArmyCreator.BasePoints * 6
	end

	TimeLimit = (10+15*gvDiffLVL)*60

	local tab = ChestRandomPositions.CreateChests(8)
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

		StartCountdown(8*60*gvDiffLVL,UpgradeKIa,false)
		DefeatCountdown = StartCountdown(TimeLimit,DefeatTimer,true)

		Siege.DefenderIDs = {8}
		Siege.AttackerIDs = {1,2,3,4,5,6}
		Siege.Init()
		StartSimpleHiResJob("AnfangsBriefingInitialize")
	end

end

function AnfangsBriefingInitialize()
	Siege.CreateTraps(8, 14700, 11100, 1500, round(6/gvDiffLVL), 300)
	Siege.CreateTraps(8, 15400, 13500, 1200, round(4/gvDiffLVL), 300)
	Siege.CreateTraps(8, 15600, 15800, 1200, round(4/gvDiffLVL), 300)
	Siege.CreateTraps(8, 15300, 18000, 1200, round(4/gvDiffLVL), 300)
	Siege.CreateTraps(8, 16300, 20500, 1500, round(6/gvDiffLVL), 300)
	Siege.CreateTraps(8, 11300, 11600, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 9100, 15900, 1200, round(4/gvDiffLVL), 300)
	Siege.CreateTraps(8, 9900, 20800, 2000, round(8/gvDiffLVL), 300)
	Siege.CreateTraps(8, 9900, 26700, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 9200, 35300, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 14200, 21800, 1200, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 17500, 3700, 2000, round(6/gvDiffLVL), 300)
	Siege.CreateTraps(8, 25400, 8700, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 27500, 8800, 1500, round(5/gvDiffLVL), 300)
	Siege.CreateTraps(8, 29900, 8900, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 36100, 13200, 800, round(2/gvDiffLVL), 300)
	Siege.CreateTraps(8, 21000, 7300, 3000, round(10/gvDiffLVL), 300)
	Siege.CreateTraps(8, 27400, 11000, 600, round(2/gvDiffLVL), 300)
	Siege.CreateTraps(8, 27400, 18000, 1800, round(6/gvDiffLVL), 300)
	Siege.CreateTraps(8, 21900, 16400, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 24300, 22100, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 24400, 27200, 2000, round(8/gvDiffLVL), 300)
	Siege.CreateTraps(8, 13600, 26300, 1000, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 19500, 38800, 800, round(3/gvDiffLVL), 300)
	Siege.CreateTraps(8, 16600, 38600, 2000, round(8/gvDiffLVL), 300)
	Siege.CreateTraps(8, 32600, 33500, 800, round(2/gvDiffLVL), 300)
	Siege.CreateTraps(8, 36400, 20500, 800, round(2/gvDiffLVL), 300)
	Siege.CreateTraps(8, 31100, 20300, 1000, round(3/gvDiffLVL), 300)
	Siege.CreatePitchFields(10100, 21300, 2500, round(5-gvDiffLVL), round(6/gvDiffLVL))
	Siege.CreatePitchFields(9100, 15900, 1400, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(15200, 12900, 2500, round(5-gvDiffLVL), round(6/gvDiffLVL))
	Siege.CreatePitchFields(15500, 19300, 2500, round(5-gvDiffLVL), round(6/gvDiffLVL))
	Siege.CreatePitchFields(19800, 9400, 1000, round(5-gvDiffLVL), round(2/gvDiffLVL))
	Siege.CreatePitchFields(27400, 9500, 2000, round(5-gvDiffLVL), round(5/gvDiffLVL))
	Siege.CreatePitchFields(27200, 14700, 1200, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(27400, 18000, 1800, round(5-gvDiffLVL), round(4/gvDiffLVL))
	Siege.CreatePitchFields(12700, 32000, 2200, round(5-gvDiffLVL), round(4/gvDiffLVL))
	Siege.CreatePitchFields(12000, 35800, 2000, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(24400, 27200, 2500, round(5-gvDiffLVL), round(5/gvDiffLVL))
	Siege.CreatePitchFields(28900, 31700, 1200, round(5-gvDiffLVL), round(2/gvDiffLVL))
	Siege.CreatePitchFields(29500, 36500, 1000, round(5-gvDiffLVL), round(2/gvDiffLVL))
	Siege.CreatePitchFields(16600, 38600, 4000, round(5-gvDiffLVL), round(6/gvDiffLVL))
	AnfangsBriefing()
	return true
end
function UpgradeKIa()
	ResearchTechnology(Technologies.T_SoftArcherArmor, 8)
	ResearchTechnology(Technologies.T_LeatherMailArmor, 8)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks, 8)
	ResearchTechnology(Technologies.T_BetterTrainingArchery, 8)
	ResearchTechnology(Technologies.T_Shoeing, 8)
	ResearchTechnology(Technologies.T_BetterChassis, 8)
	StartCountdown(8*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	ResearchTechnology(Technologies.T_WoodAging, 8)
	ResearchTechnology(Technologies.T_Turnery, 8)
	ResearchTechnology(Technologies.T_MasterOfSmithery, 8)
	ResearchTechnology(Technologies.T_IronCasting, 8)
	ResearchTechnology(Technologies.T_Fletching, 8)
	ResearchTechnology(Technologies.T_BodkinArrow, 8)
	ResearchTechnology(Technologies.T_EnhancedGunPowder, 8)
	ResearchTechnology(Technologies.T_BlisteringCannonballs, 8)
	ResearchTechnology(Technologies.T_PaddedArcherArmor, 8)
	ResearchTechnology(Technologies.T_LeatherArcherArmor, 8)
	ResearchTechnology(Technologies.T_ChainMailArmor, 8)
	ResearchTechnology(Technologies.T_PlateMailArmor, 8)
	StartCountdown(8*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	ResearchTechnology(Technologies.T_SilverSwords, 8)
	ResearchTechnology(Technologies.T_SilverBullets, 8)
	ResearchTechnology(Technologies.T_SilverMissiles, 8)
	ResearchTechnology(Technologies.T_SilverPlateArmor, 8)
	ResearchTechnology(Technologies.T_SilverArcherArmor, 8)
	ResearchTechnology(Technologies.T_SilverArrows, 8)
	ResearchTechnology(Technologies.T_SilverLance, 8)
	ResearchTechnology(Technologies.T_BloodRush, 8)
end

function AnfangsBriefing()

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Anführer",
        text	= "@color:230,0,0 Los Männer. @cr Stirling Castle liegt direkt vor uns. @cr Nehmen wir diese Festung ein und zeigen ihnen, aus welchem Holz Engländer geschnitzt sind.",
		position = GetPosition("start_pos_p" .. GUI.GetPlayerID())
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

	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(8), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		if Logic.IsLeader(eID) == 1 then
			Logic.GroupStand(eID)
		end
	end
	local idtable = {	[1] = {}
					}
	do
		local pos = {X = 12400, Y = 14700}
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 12400, Y = 18700}
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 12400, Y = 22700}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 18400, Y = 12500}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 18400, Y = 15300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18400, Y = 18100}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18400, Y = 22500}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 21200, Y = 12400}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 23200, Y = 12200}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 25200, Y = 12100}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 25200, Y = 14900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities.PU_LeaderBow4, 0, 12, pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 25200, Y = 17300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 25200, Y = 20300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 29700, Y = 20300}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 29700, Y = 17600}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 29700, Y = 14800}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 29700, Y = 12400}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 33700, Y = 14800}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 33700, Y = 16300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 36400, Y = 16300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 36400, Y = 18300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 15700, Y = 24700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18100, Y = 24700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 15700, Y = 27900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18600, Y = 27500}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 22200, Y = 27200}
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 22200, Y = 29600}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 26300, Y = 29700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 27100, Y = 31700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 27200, Y = 34900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 27300, Y = 37700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 27300, Y = 40000}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 20000, Y = 40900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 13900, Y = 39500}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 13900, Y = 35900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 14900, Y = 36300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18300, Y = 36300}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18600, Y = 33100}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 14600, Y = 32700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 15300, Y = 29500}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 16900, Y = 29700}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 18600, Y = 29900}
		idtable[1][1] = AI.Entity_CreateFormation(8, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(12/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end

	local army = {}
	army.player 	= 8
	army.id			= 0
	army.strength	= math.max(6-math.ceil(gvDiffLVL), 1)
	army.position	= GetPosition("Tower1")
	army.rodeLength	= 3300

	SetupArmy(army)

	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities.CU_BlackKnight_LeaderSword3
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	local army = {}
	army.player 	= 8
	army.id			= 1
	army.strength	= math.max(8-math.ceil(gvDiffLVL), 1)
	army.position	= GetPosition("Tower2")
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities["PU_LeaderSword" .. 5 - math.ceil(gvDiffLVL)]
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})

	MapEditor_SetupAI(8,3,99999,4-math.ceil(gvDiffLVL),"P8",3,0)
	MapEditor_Armies[8].defensiveArmies.strength = 0
	MapEditor_Armies[8].offensiveArmies.strength = round(12/gvDiffLVL)

	StartSimpleJob("CheckForInnerGateDown")

	Mission_InitTechnologies()

	local mercenaryId = Logic.GetEntityIDByName("merc1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_VeteranMajor, 6, ResourceType.Silver, 200)
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 350)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword3, 12, ResourceType.Gold, 300)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, 5, ResourceType.Gold, 500)

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
function CheckForInnerGateDown()
	if IsDestroyed("inner_gate") then
		ChangePlayer("Archery", 8)
		local pos = GetPosition("P8_2")
		MapEditor_Armies[8].offensiveArmies.position = pos
		ArmyHomespots[8].recruited = nil
		EvaluateArmyHomespots(8, pos, nil)
		return true
	end
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

	SetPlayerName(8, "Stirling Castle")

	Display.SetPlayerColorMapping(7,NPC_COLOR)
	Display.SetPlayerColorMapping(8,2)

end

function Mission_InitTechnologies()
	for i = 1,6 do
		ForbidTechnology(Technologies.B_Residence, i)
		ForbidTechnology(Technologies.B_Farm, i)
		ForbidTechnology(Technologies.B_GenericMine, i)
		ForbidTechnology(Technologies.B_University, i)
		ForbidTechnology(Technologies.B_Village, i)
		ForbidTechnology(Technologies.B_VillageHall, i)
		ForbidTechnology(Technologies.B_Claymine, i)
	end
end

function Mission_InitLocalResources()
end

function DefeatTimer()

	Message("Ihr habt es nicht geschafft, alle Feinde innerhalb von ".. round(TimeLimit/60) .." Minuten zu besiegen... @cr Versucht es erneut!")
	Defeat()

end
function DefeatJob()
	local pt,t = {},{}
	for i = 1,6 do
		pt[i] = {}
		Logic.GetHeroes(i, pt[i])
		for j in pt[i] do
			local id = pt[i][j]
			if IsAlive(id) then
				table.insert(t, id)
			end
		end
	end

	local count = (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2)
					+ Logic.GetNumberOfLeader(3) + Logic.GetNumberOfLeader(4)
					+ Logic.GetNumberOfLeader(5) + Logic.GetNumberOfLeader(6))
	if count + table.getn(t) == 0 then
		Defeat()
		return true
	end
end
function VictoryJob()

	if AI.Player_GetNumberOfLeaders(8) == 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.CB_OSO_Castle1) == 0 then
		Victory()
		StopCountdown(DefeatCountdown)
		return true
	end

end
function AreaCheck1()

	if AreEntitiesOfDiplomacyStateInArea(8, {X = 24400, Y = 27200}, 2000, Diplomacy.Hostile) then
		Stream.Start("Sounds\\military\\drumhorn.wav", 152)
		Army0()
		Army1()
		return true
	end
end
function Army0()
	local army	 = {}

	army.player 	= 8
	army.id			= 2
	army.strength	= 10-math.ceil(gvDiffLVL)
	army.position	= GetPosition("start_pos_p4")
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

	army.player 	= 8
	army.id			= 3
	army.strength	= 10-math.ceil(gvDiffLVL)
	army.position	= GetPosition("start_pos_p6")
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

	if AreEntitiesOfDiplomacyStateInArea(8, {X = 16600, Y = 38600}, 2000, Diplomacy.Hostile) then
		Army2()
		Army3()
		return true
	end
end
function Army2()
	local army	 = {}

	army.player 	= 8
	army.id			= 4
	army.strength	= 9-math.ceil(gvDiffLVL)
	army.position	= GetPosition("start_pos_p4")
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

	army.player 	= 8
	army.id			= 5
	army.strength	= 12-math.ceil(gvDiffLVL)
	army.position	= {X = 16700, Y = 32600}
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
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)



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

end 