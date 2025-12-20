--------------------------------------------------------------------------------
-- MapName: (4) Belagerung von Velborg
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"TopMainMenuTextButton", "@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Belagerung von Velborg"
gvMapVersion = " v1.0 "

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
	TributeP1_Insane()

	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
		Logic.SetPlayerPaysLeaderFlag(i, 0)
	end
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID)
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
	XGUIEng.ShowWidget("ChangeIntoSerf",0)


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
	local TrP1_C =  {}
	TrP1_C.playerId = 1
	TrP1_C.text = "Klickt hier, um den @color:255,0,0 irrsinningen @color:255,255,255 Spielmodus zu spielen"
	TrP1_C.cost = { Gold = 0 }
	TrP1_C.Callback = TributePaid_P1_Insane
	TP1_C = AddTribute(TrP1_C)
end

function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_C)
	--
	gvDiffLVL = 2.2
	--
	XGUIEng.SetText(gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,4 do
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
	Logic.RemoveTribute(1,TP1_C)
	--
	gvDiffLVL = 1.8
	--
	XGUIEng.SetText(gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,4 do
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
	Logic.RemoveTribute(1,TP1_C)
	--
	gvDiffLVL = 1.4
	--
	XGUIEng.SetText(gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,4 do
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
	Message("Ihr habt euch für den @color:255,0,0 Herausforderungs-	@color:255,255,255 Spielmodus entschieden! Achtung: Auf dieser Stufe ist diese Karte extrem schwer!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	gvDiffLVL = 1.0
	--
	XGUIEng.SetText(gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,4 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
	end
	StartInitialize()
end
function StartInitialize()

	local centerpos = Logic.WorldGetSize()/2
	for i = 1,4 do
		Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity, centerpos + (i/100), centerpos, 0, i), 10000)
	end
	Mission_InitLocalResources()

	IncludeGlobals("Tools\\ArmyCreator")
	ArmyCreator.BasePoints = 200
	ArmyCreator.PlayerPoints = 200 * gvDiffLVL
	if not CNetwork then
		ArmyCreator.PlayerPoints = ArmyCreator.PlayerPoints * 4
		ArmyCreator.BasePoints = ArmyCreator.BasePoints * 4
	end
	StartSimpleHiResJob("AnfangsBriefingInitialize")

	local tab = ChestRandomPositions.CreateChests(2)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	function ArmyCreator.OnSetupFinished()

		StartWinter(24*60*60)

		StartSimpleJob("DefeatJob")
		StartSimpleJob("VictoryJob")

		StartSimpleJob("AreaCheck1")
		StartSimpleJob("AreaCheck2")
		StartSimpleJob("AreaCheck3")

		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "CatapultRangeExploitNoDamage", 1)

		StartCountdown(5*60*gvDiffLVL,UpgradeKIa,false)
		StartCountdown(13*60*gvDiffLVL,AIIncreaseAggressiveness,false)
		StartCountdown(30*60,DefeatTimer,true)

		if CNetwork then
			SetHumanPlayerDiplomacyToAllAIs({1,2,3,4},Diplomacy.Hostile)
			SetFriendly(1,8)
			SetFriendly(2,8)
			SetFriendly(3,8)
			SetFriendly(4,8)
		else
			SetHostile(1,6)
			SetHostile(1,7)
			SetFriendly(1,8)
		end
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(1,4)
		SetFriendly(2,3)
		SetFriendly(2,4)
		SetFriendly(3,4)

		StartCountdown(10,CreateArmies,false)
	end

end

function AnfangsBriefingInitialize()

	AnfangsBriefing()
	return true
end
function UpgradeKIa()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown(10*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 5,8 do
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
	StartCountdown(12*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 5,8 do
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
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Gut euch zu sehen, mein Herr. @cr Eine wahrlich frostige Gegend, in die Ihr Euch da begeben habt.",
		position = {X = 4700, Y = 10300}
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Die Festung des Barbarenführers Varg liegt hier ganz in der Nähe.",
		position = GetPosition("VargFortress")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Nun liegt es an Euch, die Stadt zu erobern und alle Feinde zu besiegen. @cr Doch Achtung: Innerhalb von 30 Minuten werden Verstärkungstruppen eintreffen und ihr werdet keinerlei Chance mehr haben.",
		position = GetPosition("BanditSpawn7"),
		action = function()
			StartCountdown(3,ShowArmyCreatorGUI,false)
			StartCountdown(6,Mission_InitGroups,false)
			for i = 1,4 do
				Logic.SetEntityExplorationRange(({Logic.GetPlayerEntities(i, Entities.XD_ScriptEntity, 1)})[2],0)
			end
		end

    }

    StartBriefing(briefing)

end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()

	local idtable = {	[1] = {},
						[2] = {},
						[3] = {}
					}
	do
		local pos = GetPosition("guard_gate1")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(4-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderPoleArm"..(4-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 11700, 9500)
		end
	end
	do
		local pos = GetPosition("guard_gate2")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderSword"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 14500, 15500)
		end
	end
	do
		local pos = GetPosition("guard_gate3")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(4-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = GetPosition("guard_gate4")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderPoleArm"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 18900, 9500)
		end
	end
	do
		local pos = GetPosition("guard_gate5")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(4-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = GetPosition("guard_gate6")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderRifle"..math.max((3-math.ceil(gvDiffLVL)), 1)], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
			idtable[3][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderPoleArm"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[3][k], 16950, 12800)
		end
	end
	do
		local pos = GetPosition("guard_gate7")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderCavalry"..math.max((3-math.ceil(gvDiffLVL)), 1)], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	do
		local pos = GetPosition("guard_gate8")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderRifle"..math.max((3-math.ceil(gvDiffLVL)), 1)], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderCavalry"..math.max((3-math.ceil(gvDiffLVL)), 1)], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	do
		local pos = GetPosition("guard_gate9")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, math.ceil(8/gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderCavalry"..math.max((3-math.ceil(gvDiffLVL)), 1)], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	---
	Mission_InitTechnologies()

	local mercenaryId1 = Logic.GetEntityIDByName("merchant")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Serf, 4 + round(gvDiffLVL), ResourceType.Gold, round(500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Scout, 2 + round(gvDiffLVL), ResourceType.Gold, round(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Thief, 4 * round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))

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
function CreateArmies()
	ArmiesDeathTimer = {}
	ArmiesRespawnTime = round(60*gvDiffLVL)
	for i = 1, 9 do
		_G["CreateArmyP6_"..i]()
	end
end
function CreateArmyP6_1()

	armyP6_1	= {}
    armyP6_1.player 	= 6
    armyP6_1.id = 0
    armyP6_1.strength = math.ceil(6/gvDiffLVL)
    armyP6_1.position = GetPosition("BanditSpawn5")
    armyP6_1.rodeLength = 2500/gvDiffLVL
	SetupArmy(armyP6_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP6_1.strength, 1 do
	    EnlargeArmy(armyP6_1,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_1")

end
function ControlArmyP6_1()

    if IsDead(armyP6_1) and IsExisting("BanditTower5") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_1()
			return true
		end
    else
		Defend(armyP6_1)
    end
end
function CreateArmyP6_2()

	armyP6_2	= {}
    armyP6_2.player 	= 6
    armyP6_2.id = 1
    armyP6_2.strength = math.ceil(4/gvDiffLVL)
    armyP6_2.position = GetPosition("BanditSpawn5")
    armyP6_2.rodeLength = 2300/gvDiffLVL
	SetupArmy(armyP6_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP6_2.strength, 1 do
	    EnlargeArmy(armyP6_2,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_2")

end
function ControlArmyP6_2()

    if IsDead(armyP6_2) and IsExisting("BanditTower5") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_2()
			return true
		end
    else
		Defend(armyP6_2)
    end
end
function CreateArmyP6_3()

	armyP6_3	= {}
    armyP6_3.player 	= 6
    armyP6_3.id = 2
    armyP6_3.strength = math.ceil(6/gvDiffLVL)
    armyP6_3.position = GetPosition("BanditSpawn7")
    armyP6_3.rodeLength = 3000/gvDiffLVL
	SetupArmy(armyP6_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP6_3.strength, 1 do
	    EnlargeArmy(armyP6_3,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_3")

end
function ControlArmyP6_3()

    if IsDead(armyP6_3) and IsExisting("BanditTower7") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_3()
			return true
		end
    else
		Defend(armyP6_3)
    end
end
function CreateArmyP6_4()

	armyP6_4	= {}
    armyP6_4.player 	= 6
    armyP6_4.id = 3
    armyP6_4.strength = math.ceil(6/gvDiffLVL)
    armyP6_4.position = GetPosition("BanditSpawn7")
    armyP6_4.rodeLength = 2700/gvDiffLVL
	SetupArmy(armyP6_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, armyP6_4.strength, 1 do
	    EnlargeArmy(armyP6_4,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_4")

end
function ControlArmyP6_4()

    if IsDead(armyP6_4) and IsExisting("BanditTower7") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_4()
			return true
		end
    else
		Defend(armyP6_4)
    end
end
function CreateArmyP6_5()

	armyP6_5	= {}
    armyP6_5.player 	= 6
    armyP6_5.id = 4
    armyP6_5.strength = math.ceil(8/gvDiffLVL)
    armyP6_5.position = GetPosition("BanditSpawn6")
    armyP6_5.rodeLength = 4800/gvDiffLVL
	SetupArmy(armyP6_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, armyP6_5.strength, 1 do
	    EnlargeArmy(armyP6_5,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_5")

end
function ControlArmyP6_5()

    if IsDead(armyP6_5) and IsExisting("BanditTower6") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_5()
			return true
		end
    else
		Defend(armyP6_5)
    end
end
function CreateArmyP6_6()

	armyP6_6	= {}
    armyP6_6.player 	= 6
    armyP6_6.id = 5
    armyP6_6.strength = math.ceil(12/gvDiffLVL)
    armyP6_6.position = GetPosition("BanditSpawn4")
    armyP6_6.rodeLength = 5800/gvDiffLVL
	SetupArmy(armyP6_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, armyP6_6.strength, 1 do
	    EnlargeArmy(armyP6_6,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_6")

end
function ControlArmyP6_6()

    if IsDead(armyP6_6) and IsExisting("VargHQ") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_6()
			return true
		end
    else
		Defend(armyP6_6)
    end
end
function CreateArmyP6_7()

	armyP6_7	= {}
    armyP6_7.player 	= 6
    armyP6_7.id = 6
    armyP6_7.strength = math.ceil(6/gvDiffLVL)
    armyP6_7.position = GetPosition("VargFortressDefense")
    armyP6_7.rodeLength = 4600/gvDiffLVL
	SetupArmy(armyP6_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 2
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranLieutenant

    for i = 1, armyP6_7.strength, 1 do
	    EnlargeArmy(armyP6_7,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_7")

end
function ControlArmyP6_7()

    if IsDead(armyP6_7) and IsExisting("VargFortress") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_7()
			return true
		end
    else
		Defend(armyP6_7)
    end
end
function CreateArmyP6_8()

	armyP6_8	= {}
    armyP6_8.player 	= 6
    armyP6_8.id = 7
    armyP6_8.strength = math.ceil(4/gvDiffLVL)
    armyP6_8.position = GetPosition("VargFortressDefense")
    armyP6_8.rodeLength = 5100/gvDiffLVL
	SetupArmy(armyP6_8)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderBow".. math.ceil(5-gvDiffLVL)]

    for i = 1, armyP6_8.strength, 1 do
	    EnlargeArmy(armyP6_8,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_8")

end
function ControlArmyP6_8()

    if IsDead(armyP6_8) and IsExisting("VargFortress") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_8()
			return true
		end
    else
		Defend(armyP6_8)
    end
end
function CreateArmyP6_9()

	armyP6_9	= {}
    armyP6_9.player 	= 6
    armyP6_9.id = 8
    armyP6_9.strength = math.ceil(4/gvDiffLVL)
    armyP6_9.position = GetPosition("VargFortressDefense")
    armyP6_9.rodeLength = 5100/gvDiffLVL
	SetupArmy(armyP6_9)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderCavalry".. math.max(math.ceil(3-gvDiffLVL), 1)]

    for i = 1, armyP6_9.strength, 1 do
	    EnlargeArmy(armyP6_9,troopDescription)
	end
    StartSimpleJob("ControlArmyP6_9")

end
function ControlArmyP6_9()

    if IsDead(armyP6_9) and IsExisting("VargFortress") then
		if not ArmiesDeathTimer[1] then
			ArmiesDeathTimer[1] = Logic.GetTime()
		end
		if ArmiesDeathTimer[1] < Logic.GetTime() + ArmiesRespawnTime then
			CreateArmyP6_9()
			return true
		end
    else
		Defend(armyP6_9)
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

	SetPlayerName(6, "Velborg")
	SetPlayerName(7, "Vargs Getreue")

	Display.SetPlayerColorMapping(6,10)
	Display.SetPlayerColorMapping(7,10)
	Display.SetPlayerColorMapping(8,NPC_COLOR)

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	for i = 1,4 do
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

	Message("Ihr habt es nicht geschafft, alle Feinde innerhalb von 30 Minuten zu besiegen... @cr Versucht es erneut!")
	Defeat()

end
function DefeatJob()
	local t1,t2,t3,t4 = {},{},{},{}
	for i = 1, 4 do
		local tab = _G["t"..i]
		Logic.GetHeroes(i, tab)
		if tab and next(tab) then
			for k = 1, table.getn(tab) do
				if not Logic.IsEntityAlive(tab[k]) then
					table.remove(tab, k)
				end
			end
		end
	end
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + Logic.GetNumberOfLeader(3) + Logic.GetNumberOfLeader(4)
	+ table.getn(t1) + table.getn(t2) + table.getn(t3) + table.getn(t4)) == 0 then
		Defeat()
		return true
	end
end
function VictoryJob()

	if (AI.Player_GetNumberOfLeaders(6) + AI.Player_GetNumberOfLeaders(7)) == 0 and (Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.PB_Headquarters2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.CB_FolklungCastle) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.CB_Bastille1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.PB_DarkTower3) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.PB_DarkTower2)) == 0 then
		Victory()
		return true
	end

end
function AIIncreaseAggressiveness()
	for i = 1,9 do
		_G["armyP6_"..i].rodeLength = _G["armyP6_"..i].rodeLength * 2
		ArmyTable[6][i].rodeLength = ArmyTable[6][i].rodeLength * 2
	end

end
function AreaCheck1()

	local count = 0
	local pos = {X = 11700, Y = 9500}
	for i = 1, 4 do
		if ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon1, pos.X, pos.Y, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon2, pos.X, pos.Y, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon3, pos.X, pos.Y, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon4, pos.X, pos.Y, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Catapult, pos.X, pos.Y, 1500, 1)})[1] > 0 then
			count = count + 1
		end
	end
	if count > 0 then
		for i = 1,(5-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 2600, 7450, 0, 1, 4-math.ceil(gvDiffLVL), 0), 16950, 12800)
		end
		return true
	end
end
function AreaCheck2()

	local count = 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2,3,4), CEntityIterator.IsSettlerFilter(), CEntityIterator.InCircleFilter(16950, 12800, 1200)) do
		count = count + 1
	end
	if count > 0 then
		for i = 1,(8-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 2600, 7450, 0, 1, 4-math.ceil(gvDiffLVL), 0), 18000, 12700)
			Logic.GroupAttackMove(AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 6/math.min(math.ceil(gvDiffLVL),2), 2600, 7450, 0, 1, 4-math.ceil(gvDiffLVL), 0), 18000, 12700)
		end
		return true
	end
end
function AreaCheck3()

	local count = 0
	for i = 1,4 do
		if ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Catapult, 27000, 11000, 1500, 1)})[1] > 0 then
			count = count + 1
		end
	end
	if count > 0 then
		for i = 1,(6-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 18900, 22500, 0, 1, 4-math.ceil(gvDiffLVL), 0), 10000, 2500)
			Logic.GroupAttackMove(AI.Entity_CreateFormation(7, _G["Entities"]["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 6, 18900, 22500, 0, 1, 4-math.ceil(gvDiffLVL), 0), 10000, 2500)
		end
		return true
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

end
function ActivateBriefingsExpansion()
    if not unpack{true} then
        local unpack2
        unpack2 = function( _table, i )
                            i = i or 1;
                            assert(type(_table) == "table")
                            if i <= table.getn(_table) then
                                return _table[i], unpack2(_table, i)
                            end
                        end
        unpack = unpack2
    end

    Briefing_ExtraOrig = Briefing_Extra

    Briefing_Extra = function( _v1, _v2 )
		for i = 1, 2 do
			local theButton = "CinematicMC_Button" .. i
			XGUIEng.DisableButton(theButton, 1)
			XGUIEng.DisableButton(theButton, 0)
		end

		if _v1.action then
			assert( type(_v1.action) == "function" )
			if type(_v1.parameters) == "table" then
				_v1.action(unpack(_v1.parameters))
			else
				_v1.action(_v1.parameters)
			end
		end

    Briefing_ExtraOrig( _v1, _v2 )
	end

end