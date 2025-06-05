--------------------------------------------------------------------------------
-- MapName: (2) Kampf oder Flucht
--
-- Author: ???
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Kampf oder Flucht "
gvMapVersion = " v1.5 "
sub_armies_aggressive = 0
main_armies_aggressive = 0
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(48,1,0,-3)
	StartTechnologies()

	--Init local map stuff
	Mission_InitGroups()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	end
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

	StartCountdown(1,AnfangsBriefing,false)
	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ForbidTechnology(Technologies.T_MarketSulfur,i)
		ForbidTechnology(Technologies.B_Bridge,i)
		ForbidTechnology(Technologies.UP1_Tavern,i)
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
		Logic.ChangeAllEntitiesPlayerID(2,1)
	end

	SetupPlayerAi( 3, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 5, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	--
	SetHostile(1,3)
	SetHostile(2,3)
	SetHostile(1,4)
	SetHostile(2,4)
	SetHostile(1,5)
	SetHostile(2,5)
	--
	SetFriendly(1,2)
	--
	SetPlayerName(3,"Nebelvolk")
	--
	ActivateShareExploration(1,2,true)
	--
	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
	end
	LocalMusic.UseSet = DARKMOORMUSIC

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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
	for i = 1,2 do
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
		if GetIron(i) > 0 then
			AddIron(i,-(GetIron(i)))
		end
		if GetClay(i) > 0 then
			AddClay(i,-(GetClay(i)))
		end
		if GetSulfur(i) > 0 then
			AddSulfur(i,-(GetSulfur(i)))
		end
	end
	Mission_InitLocalResources()
	--
	CreateArmyP3_0()
	CreateArmyP3_1()
	CreateArmyP3_2()
	CreateArmyP3_3()
	CreateArmyP3_4()
	CreateArmyP3_5()
	CreateArmyP3_6()
	CreateArmyP3_7()
	CreateArmyP3_8()
	--
	CreateArmyP4_0()
	CreateArmyP4_1()
	CreateArmyP4_2()
	CreateArmyP4_3()
	CreateArmyP4_4()
	CreateArmyP4_5()
	CreateArmyP4_6()
	--
	Init_Merchants()
	--
	StartSimpleJob("VictoryJob")
	StartCountdown(6*60*gvDiffLVL,ForbidSabotage,false)
	StartCountdown(60*60*gvDiffLVL,UpgradeKIa,false)
	StartCountdown(20*60*gvDiffLVL,Attack_1,false)
	StartCountdown(40*60*gvDiffLVL,Attack_2,false)
	StartCountdown(60*60*gvDiffLVL,Wintereinbruch,true)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function ForbidSabotage()
	for i = 1, 2 do
		ForbidTechnology(Technologies.T_ThiefSabotage,i)
		AllowTechnology(Technologies.B_Bridge,i)
		AllowTechnology(Technologies.UP1_Tavern,i)
	end;
end
GUI.SellBuildingOrig = GUI.SellBuilding
GUI.SellBuilding = function(_id)
	if Logic.GetTime() < (10*60) then
		GUI.AddNote("Abriss auf dieser Karte zu dieser Zeit nicht möglich")
	else
		GUI.SellBuildingOrig(_id)
	end
end
function Attack_1()

	sub_armies_aggressive = 1

end
function Attack_2()

	main_armies_aggressive = 1

end
function Wintereinbruch()
	for i = 1,2 do
		ForbidTechnology(Technologies.MakeSummer,i)
		ForbidTechnology(Technologies.MakeRain,i)
	end
	StartWinter(10*60*60)
	StartCountdown(10,ZusatzNV,false)
end
function ZusatzNV()
	CreateArmyP4_7()
	CreateArmyP4_8()
	CreateArmyP5_0()
	CreateArmyP5_1()
	CreateArmyP5_2()
	CreateArmyP5_3()
	CreateArmyP5_4()
	CreateArmyP5_5()
	CreateArmyP5_6()
	CreateArmyP5_7()
	CreateArmyP5_8()
end
function Init_Merchants()

	local mercenaryId1 = Logic.GetEntityIDByName("NPC_Merchant_1")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderSword4, round(6*gvDiffLVL), ResourceType.Gold, dekaround(1400/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderPoleArm4, round(6*gvDiffLVL), ResourceType.Gold, dekaround(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderBow3, round(12*gvDiffLVL), ResourceType.Gold, dekaround(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderBow4, round(5*gvDiffLVL), ResourceType.Gold, dekaround(1800/gvDiffLVL))

	local mercenaryId2 = Logic.GetEntityIDByName("NPC_Merchant_2")
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderSword3, round(20*gvDiffLVL), ResourceType.Gold, dekaround(900/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderRifle2, round(5*gvDiffLVL), ResourceType.Gold, dekaround(2000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon1, round(5*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon3, round(2*gvDiffLVL), ResourceType.Gold, dekaround(3500/gvDiffLVL))


end
function CreateArmyP3_0()

	armyP3_0	= {}
    armyP3_0.player 	= 3
    armyP3_0.id = 0
    armyP3_0.strength = round(6/gvDiffLVL)
    armyP3_0.position = GetPosition("P2_Army_South_SpawnPoint1")
    armyP3_0.rodeLength = 11000
	SetupArmy(armyP3_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP3_0.strength,1 do
	    EnlargeArmy(armyP3_0,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_0")

end
function ControlArmyP3_0()

    if IsDead(armyP3_0) then

        return true
    else
		Advance(armyP3_0)
    end
end
function CreateArmyP3_1()

	armyP3_1	= {}
    armyP3_1.player 	= 3
    armyP3_1.id = 1
    armyP3_1.strength = round(4/gvDiffLVL)
    armyP3_1.position = GetPosition("P2_Army_South_SpawnPoint1_1")
    armyP3_1.rodeLength = 14000
	SetupArmy(armyP3_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP3_1.strength,1 do
	    EnlargeArmy(armyP3_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_1")

end

function ControlArmyP3_1()

    if IsDead(armyP3_1) then

        return true
    else
		Advance(armyP3_1)
    end
end
function CreateArmyP3_2()

	armyP3_2	= {}
    armyP3_2.player 	= 3
    armyP3_2.id = 2
    armyP3_2.strength = round(7/gvDiffLVL)
    armyP3_2.position = GetPosition("P2_Army_South_SpawnPoint2")
    armyP3_2.rodeLength = 14000
	SetupArmy(armyP3_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP3_2.strength,1 do
	    EnlargeArmy(armyP3_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_2")

end

function ControlArmyP3_2()

    if IsDead(armyP3_2) then

        return true
    else

		Advance(armyP3_2)
	end
end
function CreateArmyP3_3()

	armyP3_3	= {}
    armyP3_3.player 	= 3
    armyP3_3.id = 3
    armyP3_3.strength = round(5/gvDiffLVL)
    armyP3_3.position = GetPosition("P2_Army_South_SpawnPoint2_1")
    armyP3_3.rodeLength = 14000
	SetupArmy(armyP3_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP3_3.strength,1 do
	    EnlargeArmy(armyP3_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_3")

end

function ControlArmyP3_3()

    if IsDead(armyP3_3) then
        return true
    else

		Advance(armyP3_3)
    end
end
function CreateArmyP3_4()

	armyP3_4	= {}
    armyP3_4.player 	= 3
    armyP3_4.id = 4
    armyP3_4.strength = round(8/gvDiffLVL)
    armyP3_4.position = GetPosition("P2_Army_West_SpawnPoint")
    armyP3_4.rodeLength = 14000
	SetupArmy(armyP3_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP3_4.strength,1 do
	    EnlargeArmy(armyP3_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_4")

end

function ControlArmyP3_4()

    if IsDead(armyP3_4) and IsExisting("west_spawner") then
        CreateArmyP3_4()
        return true
    else
		Advance(armyP3_4)
    end
end
function CreateArmyP3_5()

	armyP3_5	= {}
    armyP3_5.player 	= 3
    armyP3_5.id = 5
    armyP3_5.strength = round(8/gvDiffLVL)
    armyP3_5.position = GetPosition("P2_Army_West_SpawnPoint_1")
    armyP3_5.rodeLength = 14000
	SetupArmy(armyP3_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP3_5.strength,1 do
	    EnlargeArmy(armyP3_5,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_5")

end

function ControlArmyP3_5()

    if IsDead(armyP3_5) and IsExisting("west_spawner") then
        CreateArmyP3_5()
        return true
    else
		Advance(armyP3_5)

    end
end
function CreateArmyP3_6()

	armyP3_6	= {}
    armyP3_6.player 	= 3
    armyP3_6.id = 6
    armyP3_6.strength = round(5/gvDiffLVL)
    armyP3_6.position = GetPosition("P2_Army_RuinIsle_SpawnPoint")
    armyP3_6.rodeLength = 14000
	SetupArmy(armyP3_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP3_6.strength,1 do
	    EnlargeArmy(armyP3_6,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_6")

end

function ControlArmyP3_6()

    if IsDead(armyP3_6) then
        return true
    else
        Advance(armyP3_6)
    end
end
function CreateArmyP3_7()

	armyP3_7	= {}
    armyP3_7.player 	= 3
    armyP3_7.id = 7
    armyP3_7.strength = round(3/gvDiffLVL)
    armyP3_7.position = GetPosition("P2_Army_RuinIsle_SpawnPoint_1")
    armyP3_7.rodeLength = 14000
	SetupArmy(armyP3_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP3_7.strength,1 do
	    EnlargeArmy(armyP3_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_7")

end

function ControlArmyP3_7()

    if IsDead(armyP3_7) then

        return true
    else
        Advance(armyP3_7)
    end
end

function CreateArmyP3_8()

	armyP3_8	= {}
    armyP3_8.player 	= 3
    armyP3_8.id = 8
    armyP3_8.strength = round(8/gvDiffLVL)
    armyP3_8.position = GetPosition("P2_Army_MerchantIsle_SpawnPoint2")
    armyP3_8.rodeLength = 22000
	SetupArmy(armyP3_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP3_8.strength,1 do
	    EnlargeArmy(armyP3_8,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_8")

end

function ControlArmyP3_8()

    if IsDead(armyP3_8) then

        return true
    else
        Defend(armyP3_8)
    end
end
--
function CreateArmyP4_0()

	armyP4_0	= {}
    armyP4_0.player 	= 4
    armyP4_0.id = 0
    armyP4_0.strength = round(8/gvDiffLVL)
    armyP4_0.position = GetPosition("P2_Army_MerchantIsle_SpawnPoint1")
    armyP4_0.rodeLength = 14000
	SetupArmy(armyP4_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP4_0.strength,1 do
	    EnlargeArmy(armyP4_0,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_0")

end
function ControlArmyP4_0()

    if IsDead(armyP4_0) and IsExisting("north_spawner") then
		CreateArmyP4_0()
        return true
    else
		Advance(armyP4_0)
    end
end
function CreateArmyP4_1()

	armyP4_1	= {}
    armyP4_1.player 	= 4
    armyP4_1.id = 1
    armyP4_1.strength = round(6/gvDiffLVL)
    armyP4_1.position = GetPosition("P2_Army_MerchantIsle_SpawnPoint1_1")
    armyP4_1.rodeLength = 14000
	SetupArmy(armyP4_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP4_1.strength,1 do
	    EnlargeArmy(armyP4_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_1")

end

function ControlArmyP4_1()

    if IsDead(armyP4_1) and IsExisting("north_spawner") then

		CreateArmyP4_1()

        return true
    else
		Advance(armyP4_1)
    end
end
function CreateArmyP4_2()

	armyP4_2	= {}
    armyP4_2.player 	= 4
    armyP4_2.id = 2
    armyP4_2.strength = round(8/gvDiffLVL)
    armyP4_2.position = GetPosition("P2_Army_SouthEast_SpawnPoint")
    armyP4_2.rodeLength = 8000
	SetupArmy(armyP4_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP4_2.strength,1 do
	    EnlargeArmy(armyP4_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_2")

end

function ControlArmyP4_2()

    if IsDead(armyP4_2) and IsExisting("south_east_spawner") then
        CreateArmyP4_2()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_2)
		else
			Advance(armyP4_2)
		end
	end
end
function CreateArmyP4_3()

	armyP4_3	= {}
    armyP4_3.player 	= 4
    armyP4_3.id = 4
    armyP4_3.strength = round(8/gvDiffLVL)
    armyP4_3.position = GetPosition("P2_Army_SouthEast_SpawnPoint_1")
    armyP4_3.rodeLength = 8000
	SetupArmy(armyP4_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP4_3.strength,1 do
	    EnlargeArmy(armyP3_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_3")

end

function ControlArmyP4_3()

    if IsDead(armyP4_3) then
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP4_3)
		else
			Advance(armyP4_3)
		end
    end
end
function CreateArmyP4_4()

	armyP4_4	= {}
    armyP4_4.player 	= 4
    armyP4_4.id = 4
    armyP4_4.strength = round(3/gvDiffLVL)
    armyP4_4.position = GetPosition("P2_Army_SouthEast_SpawnPoint_1")
    armyP4_4.rodeLength = 8000
	SetupArmy(armyP4_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP4_4.strength,1 do
	    EnlargeArmy(armyP4_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_4")

end

function ControlArmyP4_4()

    if IsDead(armyP4_4) and IsExisting("south_east_spawner") then
        CreateArmyP4_4()
        return true
    else
		if sub_armies_aggressive == 0 then
			Defend(armyP4_4)
		else
			Advance(armyP4_4)
		end
    end
end
function CreateArmyP4_5()

	armyP4_5	= {}
    armyP4_5.player 	= 4
    armyP4_5.id = 5
    armyP4_5.strength = round(2/gvDiffLVL)
    armyP4_5.position = GetPosition("P2_Army_SouthEast_SpawnPoint")
    armyP4_5.rodeLength = 8000
	SetupArmy(armyP4_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP4_5.strength,1 do
	    EnlargeArmy(armyP4_5,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_5")

end

function ControlArmyP4_5()

    if IsDead(armyP4_5) and IsExisting("west_spawner") then
        CreateArmyP4_5()
        return true
    else
		if sub_armies_aggressive == 0 then
			Defend(armyP4_5)
		else
			Advance(armyP4_5)
		end

    end
end
function CreateArmyP4_6()

	armyP4_6	= {}
    armyP4_6.player 	= 4
    armyP4_6.id = 6
    armyP4_6.strength = round(6/gvDiffLVL)
    armyP4_6.position = GetPosition("start_island_east_spawn")
    armyP4_6.rodeLength = 23000
	SetupArmy(armyP4_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP4_6.strength,1 do
	    EnlargeArmy(armyP4_6,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_6")

end

function ControlArmyP4_6()

    if IsDead(armyP4_6) then
        return true
    else
        Advance(armyP4_6)
    end
end
function CreateArmyP4_7()

	armyP4_7	= {}
    armyP4_7.player 	= 4
    armyP4_7.id = 7
    armyP4_7.strength = round(8/gvDiffLVL)
    armyP4_7.position = GetPosition("P2_Army_RuinIsle_SpawnPoint")
    armyP4_7.rodeLength = 14000
	SetupArmy(armyP4_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP4_7.strength,1 do
	    EnlargeArmy(armyP4_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_7")

end

function ControlArmyP4_7()

    if IsDead(armyP4_7) then
        return true
    else
        Advance(armyP4_7)
    end
end
function CreateArmyP4_8()

	armyP4_8	= {}
    armyP4_8.player 	= 4
    armyP4_8.id = 8
    armyP4_8.strength = round(8/gvDiffLVL)
    armyP4_8.position = GetPosition("P2_Army_MerchantIsle_SpawnPoint2")
    armyP4_8.rodeLength = 14000
	SetupArmy(armyP4_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP4_8.strength,1 do
	    EnlargeArmy(armyP4_8,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_8")

end

function ControlArmyP4_8()

    if IsDead(armyP4_8) then
        return true
    else
        Advance(armyP4_8)
    end
end
--
function CreateArmyP5_0()

	armyP5_0	= {}
    armyP5_0.player 	= 5
    armyP5_0.id = 0
    armyP5_0.strength = round(8/gvDiffLVL)
    armyP5_0.position = GetPosition("P2_Army_South_SpawnPoint1")
    armyP5_0.rodeLength = 14000
	SetupArmy(armyP5_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP5_0.strength,1 do
	    EnlargeArmy(armyP5_0,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_0")

end
function ControlArmyP5_0()

    if IsDead(armyP5_0) then

        return true
    else
		Advance(armyP5_0)
    end
end
function CreateArmyP5_1()

	armyP5_1	= {}
    armyP5_1.player 	= 5
    armyP5_1.id = 1
    armyP5_1.strength = round(6/gvDiffLVL)
    armyP5_1.position = GetPosition("P2_Army_South_SpawnPoint1_1")
    armyP5_1.rodeLength = 14000
	SetupArmy(armyP5_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP5_1.strength,1 do
	    EnlargeArmy(armyP5_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_1")

end

function ControlArmyP5_1()

    if IsDead(armyP5_1) then

        return true
    else
		Advance(armyP5_1)
    end
end
function CreateArmyP5_2()

	armyP5_2	= {}
    armyP5_2.player 	= 5
    armyP5_2.id = 2
    armyP5_2.strength = round(7/gvDiffLVL)
    armyP5_2.position = GetPosition("P2_Army_South_SpawnPoint2")
    armyP5_2.rodeLength = 14000
	SetupArmy(armyP5_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP5_2.strength,1 do
	    EnlargeArmy(armyP5_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_2")

end

function ControlArmyP5_2()

    if IsDead(armyP5_2) then

        return true
    else

		Advance(armyP5_2)
	end
end
function CreateArmyP5_3()

	armyP5_3	= {}
    armyP5_3.player 	= 5
    armyP5_3.id = 5
    armyP5_3.strength = round(5/gvDiffLVL)
    armyP5_3.position = GetPosition("P2_Army_South_SpawnPoint2_1")
    armyP5_3.rodeLength = 14000
	SetupArmy(armyP5_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP5_3.strength,1 do
	    EnlargeArmy(armyP5_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_3")

end

function ControlArmyP5_3()

    if IsDead(armyP5_3) then
        return true
    else

		Advance(armyP5_3)
    end
end
function CreateArmyP5_4()

	armyP5_4	= {}
    armyP5_4.player 	= 5
    armyP5_4.id = 4
    armyP5_4.strength = round(8/gvDiffLVL)
    armyP5_4.position = GetPosition("P2_Army_West_SpawnPoint")
    armyP5_4.rodeLength = 14000
	SetupArmy(armyP5_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP5_4.strength,1 do
	    EnlargeArmy(armyP5_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_4")

end

function ControlArmyP5_4()

    if IsDead(armyP5_4) and IsExisting("west_spawner") then
        CreateArmyP5_4()
        return true
    else

		Advance(armyP5_4)
    end
end
function CreateArmyP5_5()

	armyP5_5	= {}
    armyP5_5.player 	= 5
    armyP5_5.id = round(5/gvDiffLVL)
    armyP5_5.strength = 8
    armyP5_5.position = GetPosition("P2_Army_West_SpawnPoint_1")
    armyP5_5.rodeLength = 14000
	SetupArmy(armyP5_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP5_5.strength,1 do
	    EnlargeArmy(armyP5_5,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_5")

end

function ControlArmyP5_5()

    if IsDead(armyP5_5) and IsExisting("west_spawner") then
        CreateArmyP5_5()
        return true
    else

		Advance(armyP5_5)

    end
end
function CreateArmyP5_6()

	armyP5_6	= {}
    armyP5_6.player 	= 5
    armyP5_6.id = 6
    armyP5_6.strength = round(5/gvDiffLVL)
    armyP5_6.position = GetPosition("P2_Army_RuinIsle_SpawnPoint")
    armyP5_6.rodeLength = 14000
	SetupArmy(armyP5_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP5_6.strength,1 do
	    EnlargeArmy(armyP5_6,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_6")

end

function ControlArmyP5_6()

    if IsDead(armyP5_6) then
        return true
    else
        Advance(armyP5_6)
    end
end
function CreateArmyP5_7()

	armyP5_7	= {}
    armyP5_7.player 	= 5
    armyP5_7.id = 7
    armyP5_7.strength = round(5/gvDiffLVL)
    armyP5_7.position = GetPosition("P2_Army_RuinIsle_SpawnPoint_1")
    armyP5_7.rodeLength = 14000
	SetupArmy(armyP5_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyP5_7.strength,1 do
	    EnlargeArmy(armyP5_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_7")

end

function ControlArmyP5_7()

    if IsDead(armyP5_7) then

        return true
    else
        Advance(armyP5_7)
    end
end

function CreateArmyP5_8()

	armyP5_8	= {}
    armyP5_8.player 	= 5
    armyP5_8.id = 8
    armyP5_8.strength = round(8/gvDiffLVL)
    armyP5_8.position = GetPosition("P2_Army_MerchantIsle_SpawnPoint2")
    armyP5_8.rodeLength = 14000
	SetupArmy(armyP5_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyP5_8.strength,1 do
	    EnlargeArmy(armyP5_8,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_8")

end

function ControlArmyP5_8()

    if IsDead(armyP5_8) then

        return true
    else
        Advance(armyP5_8)
    end
end
function UpgradeKIa()

	for i = 3,4 do
		ResearchTechnology(Technologies.T_BloodRush,i)
		ResearchTechnology(Technologies.T_EvilArmor1,i)
	end

	StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()

	for i = 3,4 do
		ResearchTechnology(Technologies.T_EvilArmor2,i)
		ResearchTechnology(Technologies.T_EvilSpeed,i)
	end

	StartCountdown(35*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()

	for i = 3,4 do
		ResearchTechnology(Technologies.T_EvilArmor3,i)
		ResearchTechnology(Technologies.T_EvilRange1,i)
		ResearchTechnology(Technologies.T_EvilSpears1,i)
		ResearchTechnology(Technologies.T_EvilFists,i)
	end
	StartCountdown(30*60*gvDiffLVL,UpgradeKId,false)
end
function UpgradeKId()

	for i = 3,4 do
		ResearchTechnology(Technologies.T_EvilArmor4,i)
		ResearchTechnology(Technologies.T_EvilRange2,i)
		ResearchTechnology(Technologies.T_EvilSpears2,i)
	end
end
function VictoryJob()
	if IsDead("west_spawner") and IsDead("north_spawner") and IsDead("south_east_spawner") then
		Victory()
		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Die letzten Sonnenstrahlen des Herbstes begannen langsam, dem herannahenden Winter Platz zu machen.",
		position = GetPosition("P1_Outpost1")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 ...doch niemand bermerkte, dass nicht nur der Winter nahte..",
		position = GetPosition("CUTSCENE_MOVE_START_ATTACK_NEPHILIM05"),
		explore = 1200,

    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Die letzten hastigen Vorbereitungen vor der großen Kälte hatten begonnen. @cr @cr Doch plötzlich legte sich Totenstille über die Stadt...",
		position = GetPosition("P2_Army_Target6")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Schafft Eure Leibeigenen zu Euch auf die Hauptinsel. @cr @cr Schickt, sobald Ihr die Brücke überquert habt, einen Dieb zurück, damit er sie sprengt. So halten wir uns die Angreifer eine Weile vom Leibe.",
		position = GetPosition("ConnectionBridge")
    }

	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Allerdings wird der Winter bald hereinbrechen. Dann hilft uns auch das nicht mehr weiter. @cr @cr Haltet Eure Stellung und vernichtet alle Gegner. @cr  @cr Hinweis: @cr Ihr könnt auch Euerseits angreifen!",
		position = GetPosition("P1_Headquarter")
    }

    StartBriefing(briefing)
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
end

--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	InitPlayerColorMapping()
end
function InitPlayerColorMapping()

	for i = 3,5 do
		Display.SetPlayerColorMapping(i,2)
	end
	Display.SetPlayerColorMapping(8,NPC_COLOR)

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= 700
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 900
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 150


	--Add Players Resources
	local i
	for i=1,8,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end