--------------------------------------------------------------------------------
-- MapName: (4) Die Tore der Stadt
--
-- Author: ???
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Die Tore der Stadt "
gvMapVersion = " v1.1 "
p5_troop_slots = 2
p5_troop_level = 1
--1 = swordsmen+lancers,2 = bowmen+snipers added,3 = cavalry added,4 = cannons added
p5_troop_types = 1
p5_troop_technologies = 0
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,0,-3,1)
	StartTechnologies()

	--Init local map stuff
	Mission_InitGroups()

	-- Init  global MP stuff
	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	end

	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag(PlayerID, 1)
		Logic.PlayerSetGameStateToPlaying(PlayerID)
		for i = 2, 4 do
			Logic.ChangeAllEntitiesPlayerID(i, 1)
		end
	end
	--
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	--
	SetHumanPlayerDiplomacyToAllAIs()
	for i = 6,8 do
		SetHostile(5,i)
	end
	SetPlayerDiplomacy({1,2,3,4,5},Diplomacy.Friendly)
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,4)
	SetFriendly(3,2)
	SetFriendly(3,4)
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(1,4,true)
	ActivateShareExploration(2,3,true)
	ActivateShareExploration(2,4,true)
	ActivateShareExploration(3,4,true)
	--
	LocalMusic.UseSet = MEDITERANEANMUSIC

	StartSimpleJob("VictoryJob")
	StartCountdown(1,AnfangsBriefing,false)
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 2.0

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 1.4

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 1.0

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function StartInitialize()

	for i = 1,4 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
		if GetWood(i) > 0 then
			AddWood(i,-(GetWood(i)))
		end
		if GetStone(i) > 0 then
			AddStone(i,-(GetStone(i)))
		end
	end
	Mission_InitLocalResources()
	--
	TributeP1_1()
	TributeP2_1()
	TributeP3_1()
	TributeP4_1()
	for i = 1,4 do
		P5_Troops(i)
		ActivateShareExploration(i, 5, true)
	end
	MapEditor_SetupAI(6,3,8500,1,"p6",3,20*60*gvDiffLVL) SetupPlayerAi( 6, {constructing = true, extracting = 1, repairing = true, serfLimit = round(4/gvDiffLVL)} )
	MapEditor_SetupAI(7,3,10000,1,"p7",3,20*60*gvDiffLVL) SetupPlayerAi( 7, {constructing = true, extracting = 1, repairing = true, serfLimit = round(4/gvDiffLVL)} )
	for i = 6,7 do
		MapEditor_Armies[i].offensiveArmies.strength = round(45/gvDiffLVL)
	end
	for i = 1,13 do
		_G["CreateArmyP8_"..i]()
	end
	--
	StartCountdown(30*60*gvDiffLVL,UpgradeKIa,false)
	StartCountdown(5*60*gvDiffLVL,NV_Attack,false)
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function TributeP1_1()
	local TrP1_1 =  {}
	TrP1_1.playerId = 1
	TrP1_1.text = "Erhöht die Truppenslots Eurer Verbündeten auf 3/8 @cr Kosten: 3000 Taler"
	TrP1_1.cost = { Gold = 3000 }
	TrP1_1.Callback = TributePaid_P1_1
	TP1_1 = AddTribute(TrP1_1)
end
function TributeP1_2()
	local TrP1_2 =  {}
	TrP1_2.playerId = 1
	TrP1_2.text = "Erhöht die Truppenslots Eurer Verbündeten auf 4/8 @cr Kosten: 4000 Taler"
	TrP1_2.cost = { Gold = 4000 }
	TrP1_2.Callback = TributePaid_P1_2
	TP1_2 = AddTribute(TrP1_2)
end
function TributeP1_3()
	local TrP1_3 =  {}
	TrP1_3.playerId = 1
	TrP1_3.text = "Erhöht die Truppenslots Eurer Verbündeten auf 5/8 @cr Kosten: 5000 Taler"
	TrP1_3.cost = { Gold = 5000 }
	TrP1_3.Callback = TributePaid_P1_3
	TP1_3 = AddTribute(TrP1_3)
end
function TributeP1_4()
	local TrP1_4 =  {}
	TrP1_4.playerId = 1
	TrP1_4.text = "Erhöht die Truppenslots Eurer Verbündeten auf 6/8 @cr Kosten: 8000 Taler, 2000 Eisen"
	TrP1_4.cost = { Gold = 8000, Iron = 2000 }
	TrP1_4.Callback = TributePaid_P1_4
	TP1_4 = AddTribute(TrP1_4)
end
function TributeP1_5()
	local TrP1_5 =  {}
	TrP1_5.playerId = 1
	TrP1_5.text = "Erhöht die Truppenslots Eurer Verbündeten auf 7/8 @cr Kosten: 10000 Taler, 3500 Eisen, 2000 Schwefel"
	TrP1_5.cost = { Gold = 10000, Iron = 3500, Sulfur = 2000}
	TrP1_5.Callback = TributePaid_P1_5
	TP1_5 = AddTribute(TrP1_5)
end
function TributeP1_6()
	local TrP1_6 =  {}
	TrP1_6.playerId = 1
	TrP1_6.text = "Erhöht die Truppenslots Eurer Verbündeten auf 8 (Maximalstufe) @cr Kosten: 15000 Taler, 6000 Eisen, 5000 Schwefel"
	TrP1_6.cost = { Gold = 15000, Iron = 6000, Sulfur = 5000 }
	TrP1_6.Callback = TributePaid_P1_6
	TP1_6 = AddTribute(TrP1_6)
end
-----------------------------------------------------------------------------
function TributeP2_1()
	local TrP2_1 =  {}
	TrP2_1.playerId = 2
	TrP2_1.text = "Erhöht die Truppenstufe Eurer Verbündeten auf 2/4 @cr Kosten: 2000 Eisen"
	TrP2_1.cost = { Iron = 2000 }
	TrP2_1.Callback = TributePaid_P2_1
	TP2_1 = AddTribute(TrP2_1)
end
function TributeP2_2()
	local TrP2_2 =  {}
	TrP2_2.playerId = 2
	TrP2_2.text = "Erhöht die Truppenstufe Eurer Verbündeten auf 3/4 @cr Kosten: 5000 Taler, 5000 Eisen"
	TrP2_2.cost = { Iron = 5000, Gold = 5000 }
	TrP2_2.Callback = TributePaid_P2_2
	TP2_2 = AddTribute(TrP2_2)
end
function TributeP2_3()
	local TrP2_3 =  {}
	TrP2_3.playerId = 2
	TrP2_3.text = "Erhöht die Truppenstufe Eurer Verbündeten auf 4 (Maximalstufe) @cr Kosten: 8000 Taler, 8000 Eisen"
	TrP2_3.cost = { Iron = 8000, Gold = 8000 }
	TrP2_3.Callback = TributePaid_P2_3
	TP2_3 = AddTribute(TrP2_3)
end
--------------------------------------------------------------------------------
function TributeP3_1()
	local TrP3_1 =  {}
	TrP3_1.playerId = 3
	TrP3_1.text = "Fügt Euren verbündeten Truppen Bogenschützen und Scharfschützen hinzu @cr Kosten: 4000 Holz, 1000 Schwefel"
	TrP3_1.cost = { Wood = 4000, Sulfur = 1000 }
	TrP3_1.Callback = TributePaid_P3_1
	TP3_1 = AddTribute(TrP3_1)
end
function TributeP3_2()
	local TrP3_2 =  {}
	TrP3_2.playerId = 3
	TrP3_2.text = "Fügt Euren verbündeten Truppen Kavallerie hinzu @cr Kosten: 3000 Holz, 3000 Eisen"
	TrP3_2.cost = { Wood = 3000, Iron = 3000 }
	TrP3_2.Callback = TributePaid_P3_2
	TP3_2 = AddTribute(TrP3_2)
end
function TributeP3_3()
	local TrP3_3 =  {}
	TrP3_3.playerId = 3
	TrP3_3.text = "Fügt Euren Verbündeten Truppen Kanonen hinzu (Maximalstufe) @cr Kosten: 4000 Eisen, 10000 Schwefel"
	TrP3_3.cost = { Iron = 4000, Sulfur = 10000 }
	TrP3_3.Callback = TributePaid_P3_3
	TP3_3 = AddTribute(TrP3_3)
end
--------------------------------------------------------------------------------
function TributeP4_1()
	local TrP4_1 =  {}
	TrP4_1.playerId = 4
	TrP4_1.text = "Verbessert die Rüstung und Waffen Eurer Verbündeten (weitere Upgrades verbleibend: 3) @cr Kosten: 2000 Holz, 1500 Eisen"
	TrP4_1.cost = { Iron = 1500, Wood = 2000 }
	TrP4_1.Callback = TributePaid_P4_1
	TP4_1 = AddTribute(TrP4_1)
end
function TributeP4_2()
	local TrP4_2 =  {}
	TrP4_2.playerId = 4
	TrP4_2.text = "Verbessert die Rüstung und Waffen Eurer Verbündeten (weitere Upgrades verbleibend: 2) @cr Kosten: 3000 Holz, 2500 Eisen"
	TrP4_2.cost = { Iron = 2500, Wood = 3000 }
	TrP4_2.Callback = TributePaid_P4_2
	TP4_2 = AddTribute(TrP4_2)
end
function TributeP4_3()
	local TrP4_3 =  {}
	TrP4_3.playerId = 4
	TrP4_3.text = "Verbessert die Rüstung und Waffen Eurer Verbündeten (weitere Upgrades verbleibend: 1) @cr Kosten: 4000 Taler, 3000 Holz, 3500 Eisen"
	TrP4_3.cost = { Iron = 3500, Wood = 3000, Gold = 4000 }
	TrP4_3.Callback = TributePaid_P4_3
	TP4_3 = AddTribute(TrP4_3)
end
function TributeP4_4()
	local TrP4_4 =  {}
	TrP4_4.playerId = 4
	TrP4_4.text = "Verbessert die Rüstung und Waffen Eurer Verbündeten (weitere Upgrades verbleibend: 0) @cr Kosten: 12000 Taler, 6000 Holz, 5000 Eisen"
	TrP4_4.cost = { Iron = 5000, Wood = 6000, Gold = 12000 }
	TrP4_4.Callback = TributePaid_P4_4
	TP4_4 = AddTribute(TrP4_4)
end
---------------------------------------------------------------------------------
function TributePaid_P1_1()
	p5_troop_slots = p5_troop_slots + 1
	TributeP1_2()
end
function TributePaid_P1_2()
	p5_troop_slots = p5_troop_slots + 1
	TributeP1_3()
end
function TributePaid_P1_3()
	p5_troop_slots = p5_troop_slots + 1
	TributeP1_4()
end
function TributePaid_P1_4()
	p5_troop_slots = p5_troop_slots + 1
	TributeP1_5()
end
function TributePaid_P1_5()
	p5_troop_slots = p5_troop_slots + 1
	TributeP1_6()
end
function TributePaid_P1_6()
	p5_troop_slots = p5_troop_slots + 1
end
function TributePaid_P2_1()
	p5_troop_level = p5_troop_level + 1
	TributeP2_2()
end
function TributePaid_P2_2()
	p5_troop_level = p5_troop_level + 1
	TributeP2_3()
end
function TributePaid_P2_3()
	p5_troop_level = p5_troop_level + 1
end
function TributePaid_P3_1()
	p5_troop_types = p5_troop_types + 1
	TributeP3_2()
end
function TributePaid_P3_2()
	p5_troop_types = p5_troop_types + 1
	TributeP3_3()
end
function TributePaid_P3_3()
	p5_troop_types = p5_troop_types + 1
end
function TributePaid_P4_1()
	p5_troop_technologies = p5_troop_technologies + 1
	--
	ResearchTechnology(Technologies.T_SoftArcherArmor,5)
	ResearchTechnology(Technologies.T_LeatherMailArmor,5)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks,5)
	ResearchTechnology(Technologies.T_BetterTrainingArchery,5)
	ResearchTechnology(Technologies.T_Shoeing,5)
	ResearchTechnology(Technologies.T_BetterChassis,5)
	--
	TributeP4_2()
end
function TributePaid_P4_2()
	p5_troop_technologies = p5_troop_technologies + 1
	--
	ResearchTechnology(Technologies.T_WoodAging,5)
	ResearchTechnology(Technologies.T_IronCasting,5)
	ResearchTechnology(Technologies.T_Fletching,5)
	ResearchTechnology(Technologies.T_BlisteringCannonballs,5)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,5)
	ResearchTechnology(Technologies.T_PlateMailArmor,5)
	--
	TributeP4_3()
end
function TributePaid_P4_3()
	p5_troop_technologies = p5_troop_technologies + 1
	--
	ResearchTechnology(Technologies.T_Turnery,5)
	ResearchTechnology(Technologies.T_MasterOfSmithery,5)
	ResearchTechnology(Technologies.T_BodkinArrow,5)
	ResearchTechnology(Technologies.T_EnhancedGunPowder,5)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,5)
	ResearchTechnology(Technologies.T_ChainMailArmor,5)
	--
	TributeP4_4()
end
function TributePaid_P4_4()
	p5_troop_technologies = p5_troop_technologies + 1
	--
	ResearchTechnology(Technologies.T_SilverSwords,5)
	ResearchTechnology(Technologies.T_SilverBullets,5)
	ResearchTechnology(Technologies.T_SilverMissiles,5)
	ResearchTechnology(Technologies.T_SilverPlateArmor,5)
	ResearchTechnology(Technologies.T_SilverArcherArmor,5)
	ResearchTechnology(Technologies.T_SilverArrows,5)
	ResearchTechnology(Technologies.T_SilverLance,5)
	ResearchTechnology(Technologies.T_BloodRush,5)
end

--
function UpgradeKIa()
	for i = 6, 8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, i)

		ResearchTechnology(Technologies.T_SoftArcherArmor, i)
		ResearchTechnology(Technologies.T_LeatherMailArmor, i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks, i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery, i)
		ResearchTechnology(Technologies.T_Shoeing, i)
		ResearchTechnology(Technologies.T_BetterChassis, i)
		ResearchTechnology(Technologies.T_EvilArmor1, i)
	end
	StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 6, 8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry, i)

		ResearchTechnology(Technologies.T_WoodAging, i)
		ResearchTechnology(Technologies.T_Turnery, i)
		ResearchTechnology(Technologies.T_MasterOfSmithery, i)
		ResearchTechnology(Technologies.T_IronCasting, i)
		ResearchTechnology(Technologies.T_Fletching, i)
		ResearchTechnology(Technologies.T_BodkinArrow, i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder, i)
		ResearchTechnology(Technologies.T_BlisteringCannonballs, i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor, i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor, i)
		ResearchTechnology(Technologies.T_ChainMailArmor, i)
		ResearchTechnology(Technologies.T_PlateMailArmor, i)
		ResearchTechnology(Technologies.T_EvilArmor2, i)
		ResearchTechnology(Technologies.T_EvilSpears1, i)
		ResearchTechnology(Technologies.T_EvilRange1, i)
	end
	for i = 6, 7 do
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
	end
	StartCountdown(35*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	Message("Achtung: Die Gegner verfügen nun über die besten Technologien!")
	for i = 6, 8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, i)

		ResearchTechnology(Technologies.T_SilverSwords, i)
		ResearchTechnology(Technologies.T_SilverBullets, i)
		ResearchTechnology(Technologies.T_SilverMissiles, i)
		ResearchTechnology(Technologies.T_SilverPlateArmor, i)
		ResearchTechnology(Technologies.T_SilverArcherArmor, i)
		ResearchTechnology(Technologies.T_SilverArrows, i)
		ResearchTechnology(Technologies.T_SilverLance, i)
		ResearchTechnology(Technologies.T_BloodRush, i)
		ResearchTechnology(Technologies.T_EvilArmor3, i)
		ResearchTechnology(Technologies.T_EvilArmor4, i)
		ResearchTechnology(Technologies.T_EvilSpears2, i)
		ResearchTechnology(Technologies.T_EvilRange2, i)
		ResearchTechnology(Technologies.T_EvilFists, i)
		ResearchTechnology(Technologies.T_EvilSpeed, i)
	end
	for i = 6, 7 do
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
	end
end
function VictoryJob()
	local num = Logic.GetNumberOfEntitiesOfType(Entities.CB_Bastille1) + Logic.GetNumberOfEntitiesOfType(Entities.CB_Castle1)
	if num == 0 and IsDestroyed("HQP7") and IsDestroyed("HQP6") then
		Victory()
		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Herr! Der Feind nähert sich der Brücke! Wir müssen uns verteidigen!",
		position = {X = 33700, Y = 21400}
    }
AP{
        title	= "@color:230,120,0 Bürgermeister",
        text	= "@color:230,0,0 WAS? Wir müssen die Stadttore verteidigen. Schnell, sammelt die Truppen! Die Stadt wird nicht so leicht in ihre schmutzigen Hände fallen!",
		position = GetPlayerStartPosition()

    }
AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Der Feind attackiert die Brücken, die über das Wasser führen, welches die Stadt umgibt. @cr Versucht, den Eingang zu verteidigen. Koste es, was es wolle. Eventuell müßt Ihr sogar die Brücken zerstören.",
		position = {X = 32800, Y = 25000}

    }
AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Zusätzliche Rohstoffe können in der Wüstenregion gefunden werden. Erforscht dieses Gebiet.",
		position = {X = 25000, Y = 12300}

    }
AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Nachdem die Stadttore sicher vor den gegnerischen Angriffen sind, solltet Ihr die feindliche Basis finden und die Gegner für alle Zeiten erledigen!",
		position = GetPlayerStartPosition()

    }

    StartBriefing(briefing)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	InitPlayerColorMapping()
end
function InitPlayerColorMapping()

	for i = 6,8 do
		Display.SetPlayerColorMapping(i,2)
	end

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	--no limitation in this map
end
function StartTechnologies()
	for i = 1,4 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= dekaround(2500*gvDiffLVL)
	local InitClayRaw 		= dekaround(1200*gvDiffLVL)
	local InitWoodRaw 		= dekaround(2000*gvDiffLVL)
	local InitStoneRaw 		= dekaround(1000*gvDiffLVL)
	local InitIronRaw 		= dekaround(1000*gvDiffLVL)
	local InitSulfurRaw		= dekaround(300*gvDiffLVL)


	--Add Players Resources
	local i
	for i=1,8,1 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end