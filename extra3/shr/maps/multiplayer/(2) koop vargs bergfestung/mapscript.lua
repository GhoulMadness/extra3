--------------------------------------------------------------------------------
-- MapName: (2) Vargs Bergfestung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
sub_armies_aggressive = 0
main_armies_aggressive = 0
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Vargs Bergfestung "
gvMapVersion = " v1.3"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()
	
	-- custom Map Stuff		
	TagNachtZyklus(24,0,1,0,1)
	P1StartTechnologies()
	
	-- Init  global MP stuff
	--RemoveVillageCenters()
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	if CNetwork then 
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	end

	for i = 1, 2 do 
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i)); 
	end; 	
	if XNetwork.Manager_DoesExist() == 0 then		
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	
	SetupPlayerAi( 5, {constructing = true, extracting = false, repairing = true, serfLimit = 8} )
	AI.Village_SetResourceFocus(5, ResourceType.Wood)
	AI.Village_SetResourceFocus(5, ResourceType.Wood)
	AI.Village_SetResourceFocus(5, ResourceType.Wood)
	AI.Village_SetResourceFocus(5, ResourceType.Wood)
	SetupPlayerAi( 6, {constructing = false, extracting = false, repairing = true, serfLimit = 9} )	
	SetupPlayerAi( 7, {constructing = false, extracting = 1, repairing = true, serfLimit = 15} )
	AI.Village_SetResourceFocus(7, ResourceType.Wood)
	AI.Village_SetResourceFocus(7, ResourceType.Wood)
	AI.Village_SetResourceFocus(7, ResourceType.Wood)
	AI.Village_SetResourceFocus(7, ResourceType.Wood)
	SetupPlayerAi( 8, {constructing = true, extracting = false, repairing = true, serfLimit = 12} )
	MakeInvulnerable("VargHaupt")
	do
		local pos = GetPosition("LighthouseDefend")
		for i = 1,6 do
			CreateMilitaryGroup(7,Entities.PU_LeaderBow4,12,{X = pos.X - i*50, Y = pos.Y - i*50},"LGuard_Bow"..i)
			CreateMilitaryGroup(7,Entities.PU_LeaderCavalry2,6,{X = pos.X + i*50, Y = pos.Y + i*50},"LGuard_Cav"..i)
			Logic.GroupPatrol(GetID("LGuard_Bow"..i), 61300-i*30, 30600-i*30)
			Logic.GroupPatrol(GetID("LGuard_Cav"..i), 61300+i*30, 30600+i*30)
		end
	end
	do
		local pos = GetPosition("Barbaren")
		for i = 1,5 do
			CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub2,8,{X = pos.X - i*50, Y = pos.Y - i*50},"VargGuard_Sword"..i)
			CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X + i*50, Y = pos.Y + i*50},"VargGuard_Elite"..i)
			Logic.GroupPatrol(GetID("VargGuard_Elite"..i), 40900-i*30, 51900-i*30)
			Logic.GroupPatrol(GetID("VargGuard_Sword"..i), 40900+i*30, 51900+i*30)
		end
	end
	do
		local pos = GetPosition("VargHQDefense")
		for i = 1,7 do
			CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub2,8,{X = pos.X - i*50, Y = pos.Y - i*50},"VargHQGuard_Sword"..i)
			CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X + i*50, Y = pos.Y + i*50},"VargHQGuard_Elite"..i)
			Logic.GroupPatrol(GetID("VargHQGuard_Elite"..i), 55000-i*30, 7400-i*30)
			Logic.GroupPatrol(GetID("VargHQGuard_Sword"..i), 55000+i*30, 7400+i*30)
		end
	end
	
	--
	for i = 1,2 do
		SetNeutral(i,4)
	end
	--
	SetPlayerName(5,"Kerberos Vorposten")
	SetPlayerName(6,"Varg")
	SetPlayerName(7,"Kerberos")
	SetPlayerName(8,"Vargs Vorposten")
	--
	InitPlayerColorMapping()
	--
	for i = 1,4 do
		CreateWoodPile("Holz"..i,10000000)
	end
	LocalMusic.UseSet = HIGHLANDMUSIC
	
	StartSimpleJob("VictoryJob_Step1")
	ActivateBriefingsExpansion()
	
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
	TrP1_H.text = "Klickt hier, um den @color:255,0,0 schweren @color:255,255,255 Spielmodus zu spielen"
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
	gvDiffLVL = 1
	
	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--Countdowns
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(30,CreateArmies,false)
	StartCountdown(60*60,IncreaseP5Range,false)
	StartCountdown(80*60,UpgradeKIa,false)  
	StartCountdown(90*60,Attack_1,true)
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	Mission_InitGroups()	
	Mission_InitLocalResources()
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
	gvDiffLVL = 2
	
	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--Countdowns
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(30,CreateArmies,false)
	StartCountdown(45*60,IncreaseP5Range,false)
	StartCountdown(60*60,UpgradeKIa,false)  
	StartCountdown(70*60,Attack_1,true)
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	Mission_InitGroups()	
	Mission_InitLocalResources()
	--
	StartInitialize()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:255,0,0 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 3
	
	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--Countdowns
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(30,CreateArmies,false)
	StartCountdown(30*60,IncreaseP5Range,false)
	StartCountdown(40*60,UpgradeKIa,false)  
	StartCountdown(50*60,Attack_1,true)
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	Mission_InitGroups()	
	Mission_InitLocalResources()
	--
	StartInitialize()
end
function StartInitialize()
		SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
	do
		local pos = GetPosition("Kerb")
		local pos2 = GetPosition("VargHaupt")
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X,pos.Y,0,1),"p1_enemy_view_1")
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X-0.01,pos.Y,0,2),"p2_enemy_view_1")
		Logic.SetEntityExplorationRange(GetID("p1_enemy_view_1"), 28)
		Logic.SetEntityExplorationRange(GetID("p2_enemy_view_1"), 28)
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos2.X,pos2.Y,0,1),"p1_enemy_view_2")
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos2.X-0.01,pos2.Y,0,2),"p2_enemy_view_2")
		Logic.SetEntityExplorationRange(GetID("p1_enemy_view_2"), 28)
		Logic.SetEntityExplorationRange(GetID("p2_enemy_view_2"), 28)
		StartCountdown(120,RemoveVision,false)
	end
	do
		local pos = GetPosition("Ruinspawn")
		CreateMilitaryGroup(1,Entities.PU_LeaderSword4,12,{X = pos.X, Y = pos.Y},"P1_StartBrief_Sword")
		CreateMilitaryGroup(1,Entities.PU_LeaderPoleArm4,12,{X = pos.X-30, Y = pos.Y},"P1_StartBrief_PoleArm")
		CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X-50, Y = pos.Y-50},"P6_StartBrief_Veteran")
		CreateMilitaryGroup(7,Entities.CU_VeteranMajor,4,{X = pos.X+50, Y = pos.Y+50},"P7_StartBrief_Veteran")
		CreateMilitaryGroup(7,Entities.PU_LeaderBow4,12,{X = pos.X +1300, Y = pos.Y+300},"P7_StartBrief_Bow")
		Attack("P6_StartBrief_Veteran","P1_StartBrief_Sword")
		Attack("P7_StartBrief_Veteran","P1_StartBrief_PoleArm")
		Attack("P7_StartBrief_Bow","P1_StartBrief_PoleArm")
	end
	MapEditor_SetupAI(5,3,Logic.WorldGetSize()/9.5,1+math.ceil(gvDiffLVL/2),"KerberosBurg",2+math.floor(gvDiffLVL/2),5400/gvDiffLVL)
	MapEditor_SetupAI(8,3,Logic.WorldGetSize(),1+math.floor(gvDiffLVL/2),"Rache",2+math.floor(gvDiffLVL/2),0)
	MapEditor_Armies[5].AllowedTypes				=	{ 	UpgradeCategories.LeaderBow,
															UpgradeCategories.LeaderSword,
															UpgradeCategories.LeaderPoleArm,
															UpgradeCategories.LeaderCavalry,
															UpgradeCategories.LeaderHeavyCavalry,
															UpgradeCategories.LeaderRifle,
															Entities.PV_Cannon3,
															Entities.PV_Cannon4,
															UpgradeCategories.BlackKnightLeaderMace1
														}
	MapEditor_Armies[8].AllowedTypes				=	{ 	UpgradeCategories.LeaderBow,
															UpgradeCategories.LeaderSword,
															UpgradeCategories.LeaderPoleArm,
															UpgradeCategories.LeaderCavalry,
															UpgradeCategories.LeaderHeavyCavalry,
															UpgradeCategories.LeaderRifle,
															UpgradeCategories.LeaderBarbarian,
															UpgradeCategories.BlackKnightLeaderMace1
														}
	for i = 1,2 do
		SetNeutral(i,4)
	end
	
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function CreateArmies()
	CreateArmyP6_0()
	CreateArmyP6_1()
	CreateArmyP6_2()
	CreateArmyP6_3()
	CreateArmyP6_4()
	CreateArmyP6_5()
	CreateArmyP6_6()
	CreateArmyP6_7()
	CreateArmyP6_8()
	CreateArmyP7_0()
	CreateArmyP7_1()
	CreateArmyP7_2()
	CreateArmyP7_3()
	CreateArmyP7_4()
	CreateArmyP7_5()
	CreateArmyP7_6()
	CreateArmyP7_7()
end
function IncreaseP5Range()
	MapEditor_Armies[5].offensiveArmies.rodeLength = Logic.WorldGetSize() * 3/4
	MapEditor_Armies[5].offensiveArmies.baseDefenseRange = Logic.WorldGetSize()/3
end
function RemoveVision()
	for i = 1,2 do
		for j = 1,2 do
			DestroyEntity("p"..i.."_enemy_view_"..j)
		end
	end
end
function Attack_1()

	sub_armies_aggressive = 1
	StartCountdown(2,Attack_2_Vorb,false)	
	StartWinter(5*60)
end
function Attack_2_Vorb()
	StartCountdown(math.floor(87*60/math.sqrt(gvDiffLVL)),Attack_2,true)
end
function Attack_2()

	main_armies_aggressive = 1 
	if IsExisting("fireguard") then		
		LighthouseSupply()
	end
	SnowyDays_Start()
	
	for i = 1,2 do
		ForbidTechnology(Technologies.T_MakeSnow,i)
	end
end
function SnowyDays_Start()
	StartWinter(10*60)
	StartCountdown(15*60,SnowyDays_Start,false)
end
function LighthouseSupply()
	Message("Kerberos hat Verstärkungstruppen erhalten!")
	local posX,posY = 45500,62000
	for i = 1,(1+gvDiffLVL) do
		CreateMilitaryGroup(7,Entities.PU_LeaderHeavyCavalry2,3,GetPosition("LighthouseSpawn"),"LTroops_Cav"..i)
		CreateMilitaryGroup(7,Entities.PU_LeaderSword4,12,GetPosition("LighthouseSpawn"),"LTroops_Sword"..i)
		CreateMilitaryGroup(7,Entities.CU_BlackKnight_LeaderSword3,8,GetPosition("LighthouseSpawn"),"LTroops_DarkSword"..i)
		CreateMilitaryGroup(7,Entities.CU_VeteranMajor,4,GetPosition("LighthouseSpawn"),"LTroops_Elite"..i)
		Logic.GroupPatrol("LTroops_Cav"..i,posX,posY)
		Logic.GroupPatrol("LTroops_Sword"..i,posX,posY)
		Logic.GroupPatrol("LTroops_DarkSword"..i,posX,posY)
		Logic.GroupPatrol("LTroops_Elite"..i,posX,posY)
	end
	if IsExisting("fireguard") then
		StartCountdown(2,LighthouseSupplyVorb,false)
	end
end
function LighthouseSupplyVorb()
	StartCountdown(60*60/gvDiffLVL,LighthouseSupply,true)
end
function CreateArmyP6_0()

	armyP6_0	= {}
    armyP6_0.player 	= 6
    armyP6_0.id = 0
    armyP6_0.strength = 3+gvDiffLVL
    armyP6_0.position = GetPosition("BanditSpawn1")
    armyP6_0.rodeLength = 2500
	SetupArmy(armyP6_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,(3+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_0,troopDescription)
	end

    StartSimpleJob("ControlArmyP6_0")

end

function ControlArmyP6_0()
	
    if IsDead(armyP6_0) and IsExisting("BanditTower1") then
        CreateArmyP6_0()
        return true
    else
		if sub_armies_aggressive == 0 then
			Defend(armyP6_0)
		else
			armyP6_0.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_0)
		end
    end
end
function CreateArmyP6_1()

	armyP6_1	= {}
    armyP6_1.player 	= 6
    armyP6_1.id = 1
    armyP6_1.strength = 3+gvDiffLVL
    armyP6_1.position = GetPosition("BanditSpawn2")
    armyP6_1.rodeLength = 5000
	SetupArmy(armyP6_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword3

    for i = 1,(3+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP6_1")

end

function ControlArmyP6_1()
	
    if IsDead(armyP6_1) and IsExisting("BanditTower2") then
        CreateArmyP6_1()
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP6_1)
		else
			armyP6_1.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_1)
		end
    end
end
function CreateArmyP6_2()

	armyP6_2	= {}
    armyP6_2.player 	= 6
    armyP6_2.id = 2
    armyP6_2.strength = 5+gvDiffLVL
    armyP6_2.position = GetPosition("BanditSpawn2")
    armyP6_2.rodeLength = 5000
	SetupArmy(armyP6_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderRifle2
    for i = 1,(3+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_2,troopDescription)
	end
	for i = 1,2,1 do
		EnlargeArmy(armyP6_2,troopDescription2)
	end

    StartSimpleJob("ControlArmyP6_2")

end

function ControlArmyP6_2()

    if IsDead(armyP6_2) and IsExisting("BanditTower2") then
        CreateArmyP6_2()
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP6_2)
		else
			armyP6_1.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_2)
		end
    end
end
function CreateArmyP6_3()

	armyP6_3	= {}
    armyP6_3.player 	= 6
    armyP6_3.id = 3
    armyP6_3.strength = 2+gvDiffLVL
    armyP6_3.position = GetPosition("BanditSpawn3")
    armyP6_3.rodeLength = 3000
	SetupArmy(armyP6_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP6_3")

end

function ControlArmyP6_3()

    if IsDead(armyP6_3) and IsExisting("BanditTower3") then
        CreateArmyP6_3()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_3)
		else
			armyP6_3.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_3)
		end
    end
end
function CreateArmyP6_4()

	armyP6_4	= {}
    armyP6_4.player 	= 6
    armyP6_4.id = 4
    armyP6_4.strength = 5+gvDiffLVL
    armyP6_4.position = GetPosition("BanditSpawn4")
    armyP6_4.rodeLength = 6000
	SetupArmy(armyP6_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2
	
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 3
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderHeavyCavalry2

    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_4,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(armyP6_4,troopDescription2)
	end
    StartSimpleJob("ControlArmyP6_4")

end

function ControlArmyP6_4()
	
    if IsDead(armyP6_4) and IsExisting("BanditTower4") then
        CreateArmyP6_4()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_4)
		else
			armyP6_4.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_4)
		end
    end
end
function CreateArmyP6_5()

	armyP6_5	= {}
    armyP6_5.player 	= 6
    armyP6_5.id = 5
    armyP6_5.strength = 5+gvDiffLVL
    armyP6_5.position = GetPosition("BanditTower5")
    armyP6_5.rodeLength = 6000
	SetupArmy(armyP6_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm3
    for i = 1,3,1 do
	    EnlargeArmy(armyP6_5,troopDescription)
	end
	for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_5,troopDescription2)
	end

    StartSimpleJob("ControlArmyP6_5")

end

function ControlArmyP6_5()
	
    if IsDead(armyP6_5) and IsExisting("b15") then
        CreateArmyP6_5()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_5)
		else
			armyP6_5.rodeLength = Logic.WorldGetSize()
			Advance(armyP6_5)
		end
    end
end
function CreateArmyP6_6()

	armyP6_6	= {}
    armyP6_6.player 	= 6
    armyP6_6.id = 6
    armyP6_6.strength = 5+gvDiffLVL
    armyP6_6.position = GetPosition("Eisenspawn")
    armyP6_6.rodeLength = 4000
	SetupArmy(armyP6_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow3
	
    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_6,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(armyP6_6,troopDescription2)
	end
    StartSimpleJob("ControlArmyP6_6")

end

function ControlArmyP6_6()
	
    if IsVeryWeak(armyP6_6) and IsExisting("Eisenmine") then
        CreateArmyP6_6()
        return true
    else
        Defend(armyP6_6)
    end
end
function CreateArmyP6_7()

	armyP6_7	= {}
    armyP6_7.player 	= 6
    armyP6_7.id = 7
    armyP6_7.strength = 5+gvDiffLVL
    armyP6_7.position = GetPosition("BanditSpawn6")
    armyP6_7.rodeLength = 13000
	SetupArmy(armyP6_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderRifle2
	
    for i = 1,(3+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_7,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(armyP6_7,troopDescription2)
	end
    StartSimpleJob("ControlArmyP6_7")

end

function ControlArmyP6_7()
	
    if IsVeryWeak(armyP6_7) and IsExisting("BanditTower6") then
        CreateArmyP6_7()
        return true
    else
        Defend(armyP6_7)
    end
end
function CreateArmyP6_8()

	armyP6_8	= {}
    armyP6_8.player 	= 6
    armyP6_8.id = 8
    armyP6_8.strength = 5+gvDiffLVL
    armyP6_8.position = GetPosition("BanditSpawn7")
    armyP6_8.rodeLength = 12000
	SetupArmy(armyP6_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 8
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.CU_Barbarian_LeaderClub2
    for i = 1,(0+gvDiffLVL),1 do
	    EnlargeArmy(armyP6_8,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(armyP6_8,troopDescription2)
	end
	for i = 1,2,1 do
	    EnlargeArmy(armyP6_8,troopDescription3)
	end
    StartSimpleJob("ControlArmyP6_8")

end

function ControlArmyP6_8()
	
    if IsVeryWeak(armyP6_8) and IsExisting("BanditTower7") then
        CreateArmyP6_8()
        return true
    else
        Defend(armyP6_8)
    end
end
function CreateArmyP7_0()

	armyP7_0	= {}
    armyP7_0.player 	= 7
    armyP7_0.id = 0
    armyP7_0.strength = 3+gvDiffLVL
    armyP7_0.position = GetPosition("KerberosSpawn3")
    armyP7_0.rodeLength = 12500
	SetupArmy(armyP7_0)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderSword3
    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_0,troopDescription)
	end
		EnlargeArmy(armyP7_0,troopDescription2)
    StartSimpleJob("ControlArmyP7_0")

end

function ControlArmyP7_0()
	
    if IsDead(armyP7_0) and IsExisting("KerberosTower3") then
        CreateArmyP7_0()
        return true
    else
		if sub_armies_aggressive == 0 then
			Defend(armyP7_0)
		else
			armyP7_0.rodeLength = Logic.WorldGetSize()
			Advance(armyP7_0)
		end
    end
end
function CreateArmyP7_1()

	armyP7_1	= {}
    armyP7_1.player 	= 7
    armyP7_1.id = 1
    armyP7_1.strength = 5+gvDiffLVL
    armyP7_1.position = GetPosition("KerberosSpawn2")
    armyP7_1.rodeLength = 15500
	SetupArmy(armyP7_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderSword4
    for i = 1,(1+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_1,troopDescription)
	end
	for i = 1,4,1 do
	    EnlargeArmy(armyP7_1,troopDescription2)
	end
    StartSimpleJob("ControlArmyP7_1")

end

function ControlArmyP7_1()
	
    if IsDead(armyP7_1) and IsExisting("KerberosTower2") then
        CreateArmyP7_1()
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP7_1)
		else
			armyP7_1.rodeLength = Logic.WorldGetSize()
			Advance(armyP7_1)
		end
    end
end
function CreateArmyP7_2()

	armyP7_2	= {}
    armyP7_2.player 	= 7
    armyP7_2.id = 2
    armyP7_2.strength = 5+gvDiffLVL
    armyP7_2.position = GetPosition("KerberosSpawn1")
    armyP7_2.rodeLength = 7200
	SetupArmy(armyP7_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 3
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderHeavyCavalry2
	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 4
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.CU_VeteranMajor
    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_2,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(armyP7_2,troopDescription2)
	end
	EnlargeArmy(armyP7_2,troopDescription3)

    StartSimpleJob("ControlArmyP7_2")

end

function ControlArmyP7_2()
	if IsVeryWeak(armyP7_2) and IsExisting("KerberosTower1") then
		CreateArmyP7_2()
		return true
    else
		Defend(armyP7_2)
    end
end

function CreateArmyP7_3()

	armyP7_3	= {}
    armyP7_3.player 	= 7
    armyP7_3.id = 3
    armyP7_3.strength = 5+gvDiffLVL
    armyP7_3.position = GetPosition("KerberosBaseSpawn")
    armyP7_3.rodeLength = 12500
	SetupArmy(armyP7_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 12
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.PU_LeaderBow4
    for i = 1,(0+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_3,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(armyP7_3,troopDescription2)
	end
	for i = 1,3,1 do
	    EnlargeArmy(armyP7_3,troopDescription3)
	end
    StartSimpleJob("ControlArmyP7_3")

end

function ControlArmyP7_3()

    if IsVeryWeak(armyP7_3) and (IsExisting("KerberosHQ1") or IsExisting("KerberosHQ2")) then
		CreateArmyP7_3()
		return true
    else
		Defend(armyP7_3)
    end
end
function CreateArmyP7_4()

	armyP7_4	= {}
    armyP7_4.player 	= 7
    armyP7_4.id = 4
    armyP7_4.strength = 3+gvDiffLVL
    armyP7_4.position = GetPosition("KerberosBaseSpawn")
    armyP7_4.rodeLength = 11500
	SetupArmy(armyP7_4)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon3
    for i = 1,(3+gvDiffLVL),1 do
		EnlargeArmy(armyP7_4, troopDescription)
	end

    StartSimpleJob("ControlArmyP7_4")

end

function ControlArmyP7_4()

    if Logic.GetNumberOfEntitiesOfTypeOfPlayer(7,Entities.PV_Cannon3) == 0 and IsExisting("KerberosHQ2") then
        CreateArmyP7_4()
        return true
    else
		Defend(armyP7_4)

    end
end
function CreateArmyP7_5()

	armyP7_5	= {}
    armyP7_5.player 	= 7
    armyP7_5.id = 5
    armyP7_5.strength = 2+gvDiffLVL
    armyP7_5.position = GetPosition("KerberosBaseSpawn")
    armyP7_5.rodeLength = 4500
	SetupArmy(armyP7_5)
	
	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon4
    for i = 1,(2+gvDiffLVL),1 do
		EnlargeArmy(armyP7_5, troopDescription)
	end

    StartSimpleJob("ControlArmyP7_5")

end

function ControlArmyP7_5()

    if Logic.GetNumberOfEntitiesOfTypeOfPlayer(7,Entities.PV_Cannon4) == 0 and IsExisting("KerberosHQ1") then
        CreateArmyP7_5()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP7_5)
		else
			armyP7_5.rodeLength = Logic.WorldGetSize()
			Advance(armyP7_5)
		end
    end
end
function CreateArmyP7_6()

	armyP7_6	= {}
    armyP7_6.player 	= 7
    armyP7_6.id = 6
    armyP7_6.strength = 4+gvDiffLVL
    armyP7_6.position = GetPosition("KerberosBaseSpawn")
    armyP7_6.rodeLength = 14500
	SetupArmy(armyP7_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderRifle2
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderSword3
    for i = 1,(2+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_6,troopDescription)
	end
	for i = 1,(1+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_6,troopDescription2)
	end
    StartSimpleJob("ControlArmyP7_6")

end

function ControlArmyP7_6()

    if IsVeryWeak(armyP7_6) and (IsExisting("KerberosHQ1") or IsExisting("KerberosHQ2")) then
        CreateArmyP7_6()
        return true
    else
		Defend(armyP7_6)
    end
end
function CreateArmyP7_7()

	armyP7_7	= {}
    armyP7_7.player 	= 7
    armyP7_7.id = 7
    armyP7_7.strength = 3+gvDiffLVL
    armyP7_7.position = GetPosition("KerberosBaseSpawn")
    armyP7_7.rodeLength = 11500
	SetupArmy(armyP7_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranMajor

    for i = 1,(3+gvDiffLVL),1 do
	    EnlargeArmy(armyP7_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP7_7")

end

function ControlArmyP7_7()

    if IsDead(armyP7_7) and IsExisting("KerberosHQ1") then
        CreateArmyP7_7()
        return true
    else
		Defend(armyP7_7)
    end
end
function UpgradeKIa()
	for i = 5,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown(60*60/gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 5,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry,i)

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
	StartCountdown(180*60/gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 5,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

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
function VictoryJob_Step1()
	if GetEntityHealth("KerberosBurg") <= 20 then
		ChangePlayer("KerberosBurg",4)
		SetHealth("KerberosBurg",15)
		Start_Step2()
		MakeVulnerable("VargHaupt")
		return true
	end
end
function VictoryJob_Step2()
	if GetEntityHealth("VargHaupt") <= 20 then
		ChangePlayer("VargHaupt",4)
		SetHealth("VargHaupt",15)
		Start_Step3()
		return true
	end
end
function VictoryJob_Step3()
	if Counter.Tick2("VictoryJob_Step3_Ticker",40) then
		if GetEntityHealth("VargHaupt") <= 20 and GetEntityHealth("KerberosBurg") <= 20 then
			Start_Step4()
			return true
		end
	end
end
function VictoryJob_Step4_1()
	if GetEntityHealth("KerberosHQ1") <= 5 or GetEntityHealth("KerberosHQ2") <= 5 then
		End_Step4_1()
		return true
	end
end
function VictoryJob_Step4_2()
	if GetEntityHealth("VargFortress") <= 5 and GetEntityHealth("VargHQ") <= 5 then
		End_Step4_2()
		return true
	end
end
function VictoryJob()
	if IsDead("KerberosHQ1") and IsDead("KerberosHQ2") and IsDead("VargFortress") and IsDead("VargHQ") then
		if Counter.Tick2("VictoryJob_Counter",40) then
			Victory()
			return true
		end
	end
end
function Start_Step2()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Kerberos",
        text	= "@color:230,0,0 Harharhar @cr Denkt ihr, dass ich mich so leicht geschlagen gebe? @cr @cr Niemals...",
		position = GetPosition("KerberosBurg"),
		action = function()
			local pos = GetPosition("Kerb")
			for i = 1,(3+gvDiffLVL) do
				CreateMilitaryGroup(7,Entities.CU_VeteranMajor,4,{X = pos.X-i*3, Y = pos.Y-i*3})
			end
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Ein Haufen wütender Elitekrieger hat sich um Kerberos versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Kerb"),
		action = function()
			Move("Kerb","KerberosBaseSpawn")
		end
		
    }

    StartBriefing(briefing)
	StartSimpleJob("VictoryJob_Step2")
	StartCountdown(5*60,KerberosKI_Relocate,false)
end
function Start_Step3()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Varg",
        text	= "@color:230,0,0 Harharhar @cr Noch habt ihr mich nicht erwischt! @cr @cr ...Seid ihr hungrig?",
		position = GetPosition("Varg"),
		action = function()
			local pos = GetPosition("Barbaren")
			for i = 1,(3+gvDiffLVL) do
				CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X-i*3, Y = pos.Y-i*3})
				CreateEntity(6,Entities.CU_AggressiveWolf,{X = pos.X+i*3, Y = pos.Y+i*3})
			end
			ChangePlayer("Wolfa",6)
			ChangePlayer("Wolfb",6)
			ChangePlayer("Wolfc",6)
			ChangePlayer("Wolfd",6)
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Wölfe und Elitekrieger haben sich um Varg versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Varg"),
		action = function()
			Move("Varg","VargCave")
		end
		
    }

    StartBriefing(briefing)
	StartSimpleJob("MoveVargToBase")
	StartSimpleJob("VictoryJob_Step3")
	StartCountdown(5*60,VargKI_Relocate,false)
end
function Start_Step4()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Sehr gut Sire. @cr @cr Ihr habt erfolreich beide Außenposten erobert.",
		position = GetPosition("VargHaupt"),
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Blöd nur, dass sowohl Kerberos als auch Varg sich in ihre Hauptquartiere zurückziehen konnten... @cr @cr Ihr werdet wohl beide verfolgen und ihre Hauptquartiere zerstören müssen.",
		position = GetPosition("VargHaupt"),
    }

    StartBriefing(briefing)

	StartSimpleJob("VictoryJob_Step4_1")
	StartSimpleJob("VictoryJob_Step4_2")
	StartSimpleJob("VictoryJob")
end
function End_Step4_1()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Kerberos",
        text	= "@color:230,0,0 So leicht gebe ich mich nicht geschlagen. @cr @cr Los meine Getreuen. Auf sie mit Gebrüll!",
		position = GetPosition("Kerb"),
		action = function()
			local pos = GetPosition("Kerb")
			for i = 1,(6+gvDiffLVL) do
				CreateMilitaryGroup(7,Entities.CU_VeteranMajor,4,{X = pos.X-i*3, Y = pos.Y-i*3})
				CreateMilitaryGroup(7,Entities.CU_BlackKnight_LeaderSword3,8,{X = pos.X+i*3, Y = pos.Y+i*3})
			end
			ChangePlayer("Kerb",7)
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Nicht schon wieder. Massenhaft Schwarze Ritter und Schwertkämpfer haben sich um Kerberos versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Kerb"),
		
    }

    StartBriefing(briefing)

end
function End_Step4_2()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Varg",
        text	= "@color:230,0,0 Ihr seid also tatsächlich so dämlich, mir bis in meine Basis zu folgen. @cr @cr Hier gelten nur meine Regeln! @cr ...Seid ihr hungrig?",
		position = GetPosition("Varg"),
		action = function()
			local pos = GetPosition("VargFortressDefense")
			for i = 1,(3+gvDiffLVL) do
				CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X-i*3, Y = pos.Y-i*3})
				CreateEntity(6,Entities.CU_AggressiveWolf,{X = pos.X+i*3, Y = pos.Y+i*3})
			end
			local pos2 = GetPosition("VargHQDefense")
			for i = 1,(3+gvDiffLVL) do
				CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X-i*3, Y = pos.Y-i*3},"VargHQDefense_Elite"..i)
				CreateEntity(6,Entities.CU_AggressiveWolf,{X = pos.X+i*3, Y = pos.Y+i*3},"VargHQDefense_Wolf"..i)
				Logic.GroupPatrol(GetID("VargHQDefense_Elite"..i),pos.X-i*3,pos.Y-i*3)
				Logic.GroupPatrol(GetID("VargHQDefense_Wolf"..i),pos.X+i*3,pos.Y+i*3)
			end
			ChangePlayer("Varg",6)
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Nicht schoooon wieder... @cr @cr Wölfe und Elitekrieger haben sich um Varg für ein letztes Gefecht versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Varg"),
		
    }

    StartBriefing(briefing)

end
function MoveVargToBase()
	if IsNear("Varg","VargCave",500) then
		SetPosition("Varg",GetPosition("VargFortressDefense"))
		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Gut euch zu sehen, mein Herr. @cr Der Krieg zwischen der Nordfeste und Kerberos und Vargs Truppen läuft bereits.",
		position = GetPosition("Ruinspawn")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Varg und Kerberos sind nicht zu unterschätzen. @cr Ihr müsst Euer Bestes geben, um die Nordfeste gegen sie zu verteidigen.",
		position = GetPosition("Ruinspawn")
		
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Zunächst solltet ihr die Außenposten von Varg und Kerberos vernichten. Allein aufgrund ihrer Nähe zur Nordfeste stellen diese eine große Gefahr für Euch dar.",
		position = GetPosition("Ruinspawn")
	
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Kerberos Außenposten ist Euch sehr nahe. Er befindet sich direkt hinter dem Ruinenfeld und ist gut geschützt.",
		position = GetPosition("Kerb")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Vargs Außenposten ist ebenfalls in der Nähe und nur über einen schmalen Bergpass erreichbar. @cr Hier werdet ihr ebenfalls auf starken Widerstand stoßen.",
		position = GetPosition("VargHaupt")
    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Verteidigt die Nordfeste und vernichtet die Außenposten von Kerberos und Varg! @cr Achtung: Die Nordfeste darf nicht fallen!",
		position = GetPlayerStartPosition()
    }

    StartBriefing(briefing)
end 
function KerberosKI_Relocate()
	ChangePlayer("BarracksP7",5)
	ChangePlayer("ArcheryP7",5)
	ChangePlayer("FoundryP7",5)
	ChangePlayer("StableP7",5)
	ChangePlayer("KerberosBaseSpawn",5)
	ChangePlayer("KerberosHQ2",5)
	MapEditor_Armies[5].offensiveArmies.position = GetPosition("KerberosBaseSpawn")
	MapEditor_Armies[5].defensiveArmies.position = GetPosition("KerberosBaseSpawn")
end
function VargKI_Relocate()
	if IsExisting("BarracksP6") then
		ChangePlayer("BarracksP6",8)
	end
	if IsExisting("ArcheryP6") then
		ChangePlayer("ArcheryP6",8)
	end
	ChangePlayer("BanditSpawn2",8)
	MapEditor_Armies[8].offensiveArmies.position = GetPosition("BanditSpawn2")
	MapEditor_Armies[8].defensiveArmies.position = GetPosition("BanditSpawn2")
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	local pos = GetPosition("Nordfeste")
	for i = 1,(5-gvDiffLVL) do		
		AI.Entity_CreateFormation(1, Entities.PU_LeaderBow4, 0, 12, pos.X, pos.Y, 0, 1,3,0) 
		AI.Entity_CreateFormation(1, Entities.PU_LeaderSword4, 0, 12, pos.X, pos.Y, 0, 1,3,0) 
		AI.Entity_CreateFormation(1, Entities.PU_LeaderSword3, 0, 8, pos.X, pos.Y, 0, 1,3,0) 
		AI.Entity_CreateFormation(1, Entities.PU_LeaderPoleArm4, 0, 12, pos.X, pos.Y, 0, 1,3,0) 
		AI.Entity_CreateFormation(1, Entities.PU_LeaderCavalry2, 0, 6, pos.X, pos.Y, 0, 1,3,0) 
		AI.Entity_CreateFormation(1, Entities.PU_LeaderHeavyCavalry2, 0, 3, pos.X, pos.Y, 0, 1,3,0) 
	end
	for i = 1,8 do
		CreateMilitaryGroup(6,Entities.PU_LeaderBow4,12,GetPosition("p6_bows"..i))
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
	
	Display.SetPlayerColorMapping(5,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(7,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(6,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(8,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(4,NPC_COLOR)

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function
Mission_InitTechnologies()
	
end

function P1StartTechnologies()
	ResearchTechnology(Technologies.GT_Literacy,1)
	ResearchTechnology(Technologies.GT_Trading,1)
	ResearchTechnology(Technologies.GT_Printing,1)
	--
	ResearchTechnology(Technologies.T_UpgradeSword1,1)
	ResearchTechnology(Technologies.T_UpgradeSword2,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,1)	
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,1)	
	--
	ResearchTechnology(Technologies.T_UpgradeSpear1,1)
	ResearchTechnology(Technologies.T_UpgradeSpear2,1)	
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,1)	
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,1)
	--
	ResearchTechnology(Technologies.T_UpgradeBow1,1)
	ResearchTechnology(Technologies.T_UpgradeBow2,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,1)	
	--GUI.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,1)
	--GUI.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,1)	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function
Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	
	-- Initial Resources
	local InitGoldRaw 		= math.floor(2000*1.7/(math.sqrt(gvDiffLVL)))
	local InitClayRaw 		= math.floor(1600*1.7/(math.sqrt(gvDiffLVL)))
	local InitWoodRaw 		= math.floor(1200*1.7/(math.sqrt(gvDiffLVL)))
	local InitStoneRaw 		= math.floor(1500*1.7/(math.sqrt(gvDiffLVL)))
	local InitIronRaw 		= math.floor(800*1.7/(math.sqrt(gvDiffLVL)))
	local InitSulfurRaw		= 0

	
	--Add Players Resources
	local i
	for i=1,8,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
		Tools.GiveResouces(1, InitGoldRaw*9 , InitClayRaw,InitWoodRaw*7, InitStoneRaw,InitIronRaw*17,InitSulfurRaw+math.floor((2500/(math.sqrt(gvDiffLVL)))))
end
----------------------------------------------------------------------------------------------------------
function AddPages( _briefing )
    local AP = function(_page) table.insert(_briefing, _page); return _page; end
    local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end
    return AP, ASP;
end
--**
function CreateShortPage( _entity, _title, _text, _dialog, _explore) 
    local page = {
        title = _title,
        text = _text,
        position = GetPosition( _entity ),
		action = function ()Display.SetRenderFogOfWar(0) end
    };
    if _dialog then 
            if type(_dialog) == "boolean" then
                  page.dialogCamera = true; 
            elseif type(_dialog) == "number" then
                  page.explore = _dialog;
            end
      end
    if _explore then 
            if type(_explore) == "boolean" then
                  page.dialogCamera = true; 
            elseif type(_explore) == "number" then
                  page.explore = _explore;
            end
      end
    return page;
end
function ActivateBriefingsExpansion()
    if not unpack{true} then 
        local unpack2;
        unpack2 = function( _table, i )
                            i = i or 1;
                            assert(type(_table) == "table");                         
                            if i <= table.getn(_table) then
                                return _table[i], unpack2(_table, i);
                            end
                        end
        unpack = unpack2;
    end
    
    Briefing_ExtraOrig = Briefing_Extra;
    
    Briefing_Extra = function( _v1, _v2 )
		for i = 1, 2 do
			local theButton = "CinematicMC_Button" .. i;
			XGUIEng.DisableButton(theButton, 1);
			XGUIEng.DisableButton(theButton, 0);
		end
                         
		if _v1.action then
			assert( type(_v1.action) == "function" );
			if type(_v1.parameters) == "table" then 
				_v1.action(unpack(_v1.parameters));                     
			else
				_v1.action(_v1.parameters);
			end
		end
                         
    Briefing_ExtraOrig( _v1, _v2 );
	end;
    
end 