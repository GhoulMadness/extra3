--------------------------------------------------------------------------------
-- MapName: (3) Dunkelheit
--
-- Author: ???
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (3) Dunkelheit "
gvMapVersion = " v1.1 "
sub_armies_aggressive = 0
main_armies_aggressive = 0

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,1,1,3)
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
	do
	local pos = GetPosition("p3_hq_1")
	CreateEntity(1,Entities.XD_ScriptEntity,{X = pos.X , Y = pos.Y},"p1_enemy_view")
	CreateEntity(2,Entities.XD_ScriptEntity,{X = pos.X -1/100, Y = pos.Y},"p2_enemy_view")
	CreateEntity(3,Entities.XD_ScriptEntity,{X = pos.X, Y = pos.Y - 1/100},"p3_enemy_view")
	Logic.SetEntityExplorationRange(GetID("p1_enemy_view"), 28)
	Logic.SetEntityExplorationRange(GetID("p2_enemy_view"), 28)
	Logic.SetEntityExplorationRange(GetID("p3_enemy_view"), 28)
	end
	for i = 1, 3 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		Logic.ChangeAllEntitiesPlayerID(3, 1)
	end
	--
	SetHostile(1,8)
	SetHostile(2,8)
	SetHostile(3,8)
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(3,5)
	SetHostile(1,4)
	SetHostile(2,4)
	SetHostile(3,4)
	SetHostile(1,6)
	SetHostile(2,6)
	SetHostile(3,6)
	SetHostile(1,7)
	SetHostile(2,7)
	SetHostile(3,7)
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
	--
	SetPlayerName(8,"Darios Truppen")
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(3,2,true)
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

	for i = 1,3 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
		if GetWood(i) > 0 then
			AddWood(i,-(GetWood(i)))
		end
	end
	Mission_InitLocalResources()
	SetupPlayerAi( 8, {constructing = true, extracting = 1, repairing = true, serfLimit = 15} )
	AI.Village_SetResourceFocus(8, ResourceType.Wood)
	AI.Village_SetResourceFocus(8, ResourceType.Wood)
	AI.Village_SetResourceFocus(8, ResourceType.Wood)
	AI.Village_SetResourceFocus(8, ResourceType.Wood)
	SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 5, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 6, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 7, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	CreateArmyP4_1()
	CreateArmyP4_2()
	CreateArmyP5_1()
	CreateArmyP5_2()
	CreateArmyP6_1()
	CreateArmyP6_2()
	CreateArmyP7_1()
	CreateArmyP8_0()
	CreateArmyP8_1()
	CreateArmyP8_2()
	CreateArmyP8_3()
	CreateArmyP8_4()
	CreateArmyP8_5()
	CreateArmyP8_6()
	CreateArmyP8_7()
	CreateArmyP8_8()
	--
	Init_Merchant()
	--
	StartSimpleJob("VictoryJob")
	StartCountdown(40*60*gvDiffLVL,UpgradeKIa,false)
	StartCountdown(35*60*gvDiffLVL,Attack_1,false)
	StartCountdown(90*60*gvDiffLVL,Attack_2,false)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function Attack_1()

	sub_armies_aggressive = 1

end
function Attack_2()

	main_armies_aggressive = 1

end
function Init_Merchant()

	local newPID
	if CNetwork then
		newPID = 9
		Display.SetPlayerColorMapping(9,NPC_COLOR)
	else
		newPID = 2
		Display.SetPlayerColorMapping(2,NPC_COLOR)
	end
	ChangePlayer("merchant",newPID)
	local mercenaryId = Logic.GetEntityIDByName("merchant")
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderMace2, round(6*gvDiffLVL), ResourceType.Gold, dekaround(500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderSword3, round(5*gvDiffLVL), ResourceType.Gold, dekaround(800/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword3, round(12*gvDiffLVL), ResourceType.Gold, dekaround(700/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, round(5*gvDiffLVL), ResourceType.Gold, dekaround(1000/gvDiffLVL))

end

function CreateArmyP4_1()

	armyP4_1	= {}
    armyP4_1.player 	= 4
    armyP4_1.id = 1
    armyP4_1.strength = round(6/gvDiffLVL)
    armyP4_1.position = GetPosition("def3_1")
    armyP4_1.rodeLength = 4500
	SetupArmy(armyP4_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 1
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow3

    for i = 1,armyP4_1.strength,1 do
	    EnlargeArmy(armyP4_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_1")

end

function ControlArmyP4_1()

    if IsDead(armyP4_1) and IsExisting("p4_archery") then
        CreateArmyP4_1()
        return true
    else
		if sub_armies_aggressive == 0 then
			Defend(armyP4_1)
		else
			Advance(armyP4_1)
		end
    end
end
function CreateArmyP4_2()

	armyP4_2	= {}
    armyP4_2.player 	= 4
    armyP4_2.id = 2
    armyP4_2.strength = round(6/gvDiffLVL)
    armyP4_2.position = GetPosition("target2")
    armyP4_2.rodeLength = 5200
	SetupArmy(armyP4_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow2

    for i = 1,armyP4_2.strength,1 do
	    EnlargeArmy(armyP4_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_2")

end

function ControlArmyP4_2()

    if IsDead(armyP4_2) and IsExisting("p4_archery") then
        CreateArmyP4_2()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP4_2)
		else
			Advance(armyP4_2)
		end
    end
end
function CreateArmyP5_1()

	armyP5_1	= {}
    armyP5_1.player 	= 5
    armyP5_1.id = 1
    armyP5_1.strength = round(6/gvDiffLVL)
    armyP5_1.position = GetPosition("def3_2")
    armyP5_1.rodeLength = 6100
	SetupArmy(armyP5_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 3
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry1

    for i = 1,armyP5_1.strength,1 do
	    EnlargeArmy(armyP5_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_1")

end

function ControlArmyP5_1()

    if IsDead(armyP5_1) and IsExisting("p5_stable") then
        CreateArmyP5_1()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_1)
		else
			Advance(armyP5_1)
		end
    end
end
function CreateArmyP5_2()

	armyP5_2	= {}
    armyP5_2.player 	= 5
    armyP5_2.id = 2
    armyP5_2.strength = round(3/gvDiffLVL)
    armyP5_2.position = GetPosition("def3_2")
    armyP5_2.rodeLength = 6600
	SetupArmy(armyP5_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 3
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderHeavyCavalry1

    for i = 1,armyP5_2.strength,1 do
	    EnlargeArmy(armyP5_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_2")

end

function ControlArmyP5_2()

    if IsDead(armyP5_2) and IsExisting("p5_stable") then
        CreateArmyP5_2()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_2)
		else
			Advance(armyP5_2)
		end
    end
end
function CreateArmyP6_1()

	armyP6_1	= {}
    armyP6_1.player 	= 6
    armyP6_1.id = 1
    armyP6_1.strength = round(6/gvDiffLVL)
    armyP6_1.position = GetPosition("def3_4")
    armyP6_1.rodeLength = 3600
	SetupArmy(armyP6_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,armyP6_1.strength,1 do
	    EnlargeArmy(armyP6_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP6_1")

end

function ControlArmyP6_1()

    if IsDead(armyP6_1) and IsExisting("p6_tower") then
        CreateArmyP6_1()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_1)
		else
			Advance(armyP6_1)
		end
    end
end
function CreateArmyP6_2()

	armyP6_2	= {}
    armyP6_2.player 	= 6
    armyP6_2.id = 2
    armyP6_2.strength = round(5/gvDiffLVL)
    armyP6_2.position = GetPosition("def3_4")
    armyP6_2.rodeLength = 3800
	SetupArmy(armyP6_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword2

    for i = 1,armyP6_2.strength,1 do
	    EnlargeArmy(armyP6_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP6_2")

end

function ControlArmyP6_2()

    if IsDead(armyP6_2) and IsExisting("p6_tower") then
        CreateArmyP6_2()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_2)
		else
			Advance(armyP6_2)
		end
    end
end
function CreateArmyP7_1()

	armyP7_1	= {}
    armyP7_1.player 	= 7
    armyP7_1.id = 1
    armyP7_1.strength = round(8/gvDiffLVL)
    armyP7_1.position = GetPosition("way2")
    armyP7_1.rodeLength = 4500
	SetupArmy(armyP7_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword3

    for i = 1,armyP7_1.strength,1 do
	    EnlargeArmy(armyP7_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP7_1")

end

function ControlArmyP7_1()

    if IsDead(armyP7_1) and IsExisting("p7_barracks") then
        CreateArmyP7_1()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP7_1)
		else
			Advance(armyP7_1)
		end
    end
end


function CreateArmyP8_1()

	armyP8_1	= {}
    armyP8_1.player 	= 8
    armyP8_1.id = 1
    armyP8_1.strength = round(6/gvDiffLVL)
    armyP8_1.position = GetPosition("mark2")
    armyP8_1.rodeLength = 14000
	SetupArmy(armyP8_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 1
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP8_1.strength,1 do
	    EnlargeArmy(armyP8_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_1")

end

function ControlArmyP8_1()

    if IsDead(armyP8_1) and IsExisting("b7") then
        CreateArmyP8_1()
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP8_1)
		else
			Advance(armyP8_1)
		end
    end
end
function CreateArmyP8_2()

	armyP8_2	= {}
    armyP8_2.player 	= 8
    armyP8_2.id = 2
    armyP8_2.strength = round(6/gvDiffLVL)
    armyP8_2.position = GetPosition("mark1")
    armyP8_2.rodeLength = 16000
	SetupArmy(armyP8_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,armyP8_2.strength,1 do
	    EnlargeArmy(armyP8_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_2")

end

function ControlArmyP8_2()

    if IsDead(armyP8_2) and IsExisting("b6") then
        CreateArmyP8_2()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP8_2)
		else
			Advance(armyP8_2)
		end
	end
end
function CreateArmyP8_3()

	armyP8_3	= {}
    armyP8_3.player 	= 8
    armyP8_3.id = 3
    armyP8_3.strength = round(6/gvDiffLVL)
    armyP8_3.position = GetPosition("mark8")
    armyP8_3.rodeLength = 14000
	SetupArmy(armyP8_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 1
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP8_3.strength,1 do
	    EnlargeArmy(armyP8_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_3")

end

function ControlArmyP8_3()

    if IsDead(armyP8_3) and IsExisting("b25") then
        CreateArmyP8_3()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP8_3)
		else
			Advance(armyP8_3)
		end
    end
end
function CreateArmyP8_4()

	armyP8_4	= {}
    armyP8_4.player 	= 8
    armyP8_4.id = 4
    armyP8_4.strength = round(6/gvDiffLVL)
    armyP8_4.position = GetPosition("mark7")
    armyP8_4.rodeLength = 16000
	SetupArmy(armyP8_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,armyP8_4.strength,1 do
	    EnlargeArmy(armyP8_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_4")

end

function ControlArmyP8_4()

    if IsDead(armyP8_4) and IsExisting("b22") then
        CreateArmyP8_4()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP8_4)
		else
			Advance(armyP8_4)
		end
    end
end
function CreateArmyP8_5()

	armyP8_5	= {}
    armyP8_5.player 	= 8
    armyP8_5.id = 5
    armyP8_5.strength = round(8/gvDiffLVL)
    armyP8_5.position = GetPosition("mark5")
    armyP8_5.rodeLength = 10000
	SetupArmy(armyP8_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 3
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderHeavyCavalry2

    for i = 1,armyP8_5.strength,1 do
	    EnlargeArmy(armyP8_5,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_5")

end

function ControlArmyP8_5()

    if IsDead(armyP8_5) and IsExisting("b15") then
        CreateArmyP8_5()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP8_5)
		else
			Advance(armyP8_5)
		end
    end
end

function CreateArmyP8_0()

	armyP8_0	= {}
    armyP8_0.player 	= 8
    armyP8_0.id = 0
    armyP8_0.strength = round(6/gvDiffLVL)
    armyP8_0.position = GetPosition("mark6")
    armyP8_0.rodeLength = 9500
	SetupArmy(armyP8_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2

    for i = 1,armyP8_0.strength,1 do
	    EnlargeArmy(armyP8_0,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_0")

end

function ControlArmyP8_0()

    if IsDead(armyP8_0) and IsExisting("stable2") then
        CreateArmyP8_0()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP8_0)
		else
			Advance(armyP8_0)
		end
    end
end

function CreateArmyP8_6()

	armyP8_6	= {}
    armyP8_6.player 	= 8
    armyP8_6.id = 6
    armyP8_6.strength = round(8/gvDiffLVL)
    armyP8_6.position = GetPosition("def1")
    armyP8_6.rodeLength = 18000
	SetupArmy(armyP8_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderRifle2

    for i = 1,armyP8_6.strength,1 do
	    EnlargeArmy(armyP8_6,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_6")

end

function ControlArmyP8_6()

    if IsDead(armyP8_6) and IsExisting("p8_hq_1") then
        CreateArmyP8_6()
        return true
    else
        Defend(armyP8_6)
    end
end
function CreateArmyP8_7()

	armyP8_7	= {}
    armyP8_7.player 	= 8
    armyP8_7.id = 7
    armyP8_7.strength = round(8/gvDiffLVL)
    armyP8_7.position = GetPosition("def1")
    armyP8_7.rodeLength = 22000
	SetupArmy(armyP8_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderPoleArm4

    for i = 1,armyP8_7.strength,1 do
	    EnlargeArmy(armyP8_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP8_7")

end

function ControlArmyP8_7()

    if IsDead(armyP8_7) and IsExisting("p8_hq_2") then
        CreateArmyP8_7()
        return true
    else
        Defend(armyP8_7)
    end
end

function CreateArmyP8_8()

	armyP8_8	= {}
    armyP8_8.player 	= 8
    armyP8_8.id = 8
    armyP8_8.strength = round(8/gvDiffLVL)
    armyP8_8.position = GetPosition("def1")
    armyP8_8.rodeLength = 11000
	SetupArmy(armyP8_8)

	local troopDescription1 = {}
	troopDescription1.experiencePoints = HIGH_EXPERIENCE
	troopDescription1.leaderType = Entities.PV_Cannon1
	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PV_Cannon3
	for i = 1,math.ceil(armyP8_8.strength/2),1 do
		EnlargeArmy(armyP8_8, troopDescription1)
	end
	for i = 1,math.floor(armyP8_8.strength/2),1 do
		EnlargeArmy(armyP8_8, troopDescription2)
	end
    StartSimpleJob("ControlArmyP8_8")

end

function ControlArmyP8_8()

	if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(8,Entities.PV_Cannon1)+Logic.GetNumberOfEntitiesOfTypeOfPlayer(8,Entities.PV_Cannon2)+Logic.GetNumberOfEntitiesOfTypeOfPlayer(8,Entities.PV_Cannon3)+Logic.GetNumberOfEntitiesOfTypeOfPlayer(8,Entities.PV_Cannon4)) == 0 and IsExisting("b9") then
        CreateArmyP8_8()
        return true
    else
        Defend(armyP8_8)
    end
end
--
function UpgradeKIa()
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,8)

	ResearchTechnology(Technologies.T_SoftArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherMailArmor,8)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks,8)
	ResearchTechnology(Technologies.T_BetterTrainingArchery,8)
	ResearchTechnology(Technologies.T_Shoeing,8)
	ResearchTechnology(Technologies.T_BetterChassis,8)

	StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry,8)

	ResearchTechnology(Technologies.T_WoodAging,8)
	ResearchTechnology(Technologies.T_Turnery,8)
	ResearchTechnology(Technologies.T_MasterOfSmithery,8)
	ResearchTechnology(Technologies.T_IronCasting,8)
	ResearchTechnology(Technologies.T_Fletching,8)
	ResearchTechnology(Technologies.T_BodkinArrow,8)
	ResearchTechnology(Technologies.T_EnhancedGunPowder,8)
	ResearchTechnology(Technologies.T_BlisteringCannonballs,8)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,8)
	ResearchTechnology(Technologies.T_ChainMailArmor,8)
	ResearchTechnology(Technologies.T_PlateMailArmor,8)

	StartCountdown(35*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,8)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,8)

	ResearchTechnology(Technologies.T_SilverSwords,8)
	ResearchTechnology(Technologies.T_SilverBullets,8)
	ResearchTechnology(Technologies.T_SilverMissiles,8)
	ResearchTechnology(Technologies.T_SilverPlateArmor,8)
	ResearchTechnology(Technologies.T_SilverArcherArmor,8)
	ResearchTechnology(Technologies.T_SilverArrows,8)
	ResearchTechnology(Technologies.T_SilverLance,8)
	ResearchTechnology(Technologies.T_BloodRush,8)
end
function VictoryJob()
	if IsDead("p8_hq_1") and IsDead("p8_hq_2") then
		Victory()
		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Darios schmerzerfüllte Schreie durchdrangen die Hallen der Burg. Sein Körper versuchte, mit Hilfe von Helias Heilmitteln das Gift zu besiegen. Helias setzte alles daran, seinem Freund zu helfen, doch noch nie hatte er so wenig...",
		position = GetPosition("p8_hq_1")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 ...Hoffnung wie in diesen Stunden.",
		position = GetPosition("p8_hq_2")

    }
	AP{
        title	= "@color:230,120,0 Kerberos",
        text	= "@color:230,0,0 Endlich sind wir wieder vereint! @cr Ich brauche deine tapferen Krieger, um den Plan in die Tat umzusetzen.",
		position = GetPosition("def3_5")

    }
	AP{
        title	= "@color:230,120,0 Varg",
        text	= "@color:230,0,0 Meine Krieger stehen zu Euren Diensten und ich an Eurer Seite! @cr Wir haben unser Lager in den Wäldern aufgeschlagen. Es ist der perfekte Platz, um die Karawanen zu überfallen, @cr um so genug Rohstoffe für unsere Truppen zu haben, bis wir die Minen erobert haben..",
		position = GetPosition("start_village")
    }

	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Nehmt die drei Lagerplätze im Süden, Westen und Osten der Stadt ein, um die Stadt zu isolieren. @cr @cr Zerstört anschließend alle militärischen Gebäude sowie die Burg der Stadt und die Stadt wird sich ergeben!",
		position = GetPosition("my_castle"),
		action = function()
			DestroyEntity("p1_enemy_view")
			DestroyEntity("p2_enemy_view")
			DestroyEntity("p3_enemy_view")
		end
    }

    StartBriefing(briefing)
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	InitPlayerColorMapping()
end
function InitPlayerColorMapping()

	for i = 4,8 do
		Display.SetPlayerColorMapping(i,1)
	end

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	--no limitation in this map
end
function StartTechnologies()
	for i = 1,3 do
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
	local InitSulfurRaw		= 0


	--Add Players Resources
	local i
	for i=1,8,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end