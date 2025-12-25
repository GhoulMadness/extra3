--------------------------------------------------------------------------------
-- MapName: (3) Schlacht um Evelance
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Schlacht um Evelance "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	AddPeriodicSummer(10)
	StartTechnologies()

    Mission_InitGroups()

    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()

    SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
		Logic.ChangeAllEntitiesPlayerID(2, 1)
	end

	LocalMusic.UseSet = EVELANCEMUSIC

	Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,44590,51890,0)
	Giftgas()
	for i = 1,8 do
		CreateWoodPile("Holz"..i,400000)
	end

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
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
	end
	Mission_InitLocalResources()
	--
	GegnerStartTruppen()
	StartCountdown(42*60*gvDiffLVL,AIStart,false)
	StartCountdown(45*60*gvDiffLVL,Felsen,true)
	NVSpawns()
	BanditSpawns()
	--
	StartSimpleJob("Sieg")

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function Giftgas()
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,44590,51890,0)
	StartCountdown(20,Giftgas,false)
end

function Sieg()
	if IsDead("P6HQ") and IsDead("P7HQ") and IsDead("P7Burg") and IsDead("P8HQ") then
		Victory()
		return true
	end
end

-- Build Groups and attach Leaders
function Mission_InitGroups()
	Start()
end
function Mission_InitTechnologies()
	--no limitation in this map
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= 1000
	local InitClayRaw 		= 1000
	local InitWoodRaw 		= 1000
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


function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(6,"Lord Draktarh")
	SetPlayerName(5,"Nebelvolk")
	SetPlayerName(4,"Banditen")
	SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
	SetFriendly(1,2)
	ActivateShareExploration(1,2,true)

end



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()

	Display.SetPlayerColorMapping(3,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(7,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(6,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(4,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(5,3)
	Display.SetPlayerColorMapping(8,FRIENDLY_COLOR3)

end
function GegnerStartTruppen()
	CreateMilitaryGroup(4,Entities.PU_LeaderSword3,8,GetPosition("Gegner1"))
	CreateMilitaryGroup(4,Entities.PU_LeaderBow3,8,GetPosition("Gegner2"))
	CreateMilitaryGroup(4,Entities.PU_LeaderPoleArm3,8,GetPosition("Gegner3"))
	CreateMilitaryGroup(4,Entities.PU_LeaderSword3,8,GetPosition("Gegner4"))
	CreateMilitaryGroup(4,Entities.PU_LeaderBow3,8,GetPosition("Gegner5"))
	CreateMilitaryGroup(4,Entities.PU_LeaderPoleArm3,8,GetPosition("Gegner6"))
	CreateMilitaryGroup(4,Entities.PU_LeaderBow3,8,GetPosition("Gegner7"))
	--
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart1"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart2"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart3"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart4"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart5"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart6"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart7"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart8"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart9"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart10"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart11"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart12"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart15"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart14"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart15"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart16"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart17"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart18"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart19"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart20"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVStart1"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart1"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart2"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart3"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart4"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart5"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart6"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart7"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart8"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart9"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart10"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart11"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart12"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart15"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart14"))
	CreateMilitaryGroup(5,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVStart15"))

end
function AIStart()
	MapEditor_SetupAI(3, 2, 76800, 2, "P3", 3, 0)
	MapEditor_SetupAI(7, 2, 76800, 3, "Draktarh", 3, 0)
	MapEditor_SetupAI(6, 3, 76800, 3, "Berggegner", 3, 0)
	MapEditor_SetupAI(8, 3, 76800, 3, "P8", 3, 0)
	MapEditor_Armies[3].offensiveArmies.strength = round(25/gvDiffLVL)
	for i = 6,8 do
		MapEditor_Armies[i].offensiveArmies.strength = round(40/gvDiffLVL)
	end
	SetupPlayerAi( 6, {constructing = true, repairing = true, extracting = 1, serfLimit = 7} )
	SetupPlayerAi( 7, {constructing = true, repairing = true, extracting = 1, serfLimit = 7} )
	SetupPlayerAi( 8, {constructing = false, repairing = true, extracting = 1, serfLimit = 3} )
end
function Felsen()
	Message("Der Weg zu Eurer Burg ist Euren Feinden nun nicht mehr versperrt!")
	for i = 1,22 do
		DestroyEntity("Rock"..i)
	end
	TagNachtZyklus(24,1,1,-1,1)
end
function NVSpawns()
	StartCountdown((42+10*gvDiffLVL)*60,NVSpawn,false)
end
function NVSpawn()

	local ttypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSkirmisher1}

	if IsExisting("NVTurm1") then
		local armyNV	= {}
		armyNV.player 	= 5
		armyNV.id = GetFirstFreeArmySlot(5)
		armyNV.strength = round((2+Logic.GetTime()/1200)/gvDiffLVL)
		armyNV.position = GetPosition("NV1")
		armyNV.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyNV)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 1
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,2)]

		for i = 1,armyNV.strength,1 do
			EnlargeArmy(armyNV,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{armyNV.player, armyNV.id})
	end
	--
	if IsExisting("NVTurm2") then
		local armyNV	= {}
		armyNV.player 	= 5
		armyNV.id = GetFirstFreeArmySlot(5)
		armyNV.strength = round((2+Logic.GetTime()/1200)/gvDiffLVL)
		armyNV.position = GetPosition("NV2")
		armyNV.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyNV)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 1
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,2)]

		for i = 1,armyNV.strength,1 do
			EnlargeArmy(armyNV,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{armyNV.player, armyNV.id})
	end
	--
	if IsExisting("NebelBurg") then
		local armyNV	= {}
		armyNV.player 	= 5
		armyNV.id = GetFirstFreeArmySlot(5)
		armyNV.strength = round((4+Logic.GetTime()/600)/gvDiffLVL)
		armyNV.position = GetPosition("NV3")
		armyNV.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyNV)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 1
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,2)]

		for i = 1,armyNV.strength,1 do
			EnlargeArmy(armyNV,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{armyNV.player, armyNV.id})
	end
	StartCountdown(8*60*gvDiffLVL,NVSpawn,false)
end

function BanditSpawns()
	StartCountdown((40+8*gvDiffLVL)*60,BanditSpawn,false)
end
function BanditSpawn()

	local ttypes = {Entities.CU_BanditLeaderSword2, Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2,
	Entities.CU_BlackKnight_LeaderMace2, Entities.CU_BlackKnight_LeaderSword3, Entities.CU_VeteranLieutenant, Entities.PV_Cannon2}

	if IsExisting("BanditTurm1") then
		local army	= {}
		army.player 	= 4
		army.id = GetFirstFreeArmySlot(4)
		army.strength = round((2+Logic.GetTime()/1500)/gvDiffLVL)
		army.position = GetPosition("Bandit1")
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)

		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,table.getn(ttypes))]

		for i = 1,army.strength,1 do
			EnlargeArmy(army,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	end
	--
	if IsExisting("BanditTurm2") then
		local army	= {}
		army.player 	= 4
		army.id = GetFirstFreeArmySlot(4)
		army.strength = round((2+Logic.GetTime()/1500)/gvDiffLVL)
		army.position = GetPosition("Bandit2")
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)

		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,table.getn(ttypes))]

		for i = 1,army.strength,1 do
			EnlargeArmy(army,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	end
	--
	if IsExisting("BanditTurm3") then
		local army	= {}
		army.player 	= 4
		army.id = GetFirstFreeArmySlot(4)
		army.strength = round((2+Logic.GetTime()/1500)/gvDiffLVL)
		army.position = GetPosition("Bandit3")
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)

		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,table.getn(ttypes))]

		for i = 1,army.strength,1 do
			EnlargeArmy(army,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	end
	--
	if IsExisting("BanditTurm4") then
		local army	= {}
		army.player 	= 4
		army.id = GetFirstFreeArmySlot(4)
		army.strength = round((3+Logic.GetTime()/900)/gvDiffLVL)
		army.position = GetPosition("Bandit4")
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 1
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = ttypes[math.random(1,2)]

		for i = 1,army.strength,1 do
			EnlargeArmy(army,troopDescription)
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	end
	StartCountdown(8*60*gvDiffLVL,BanditSpawn,false)
end

function ControlArmies(_player, _id)

   if IsDead(ArmyTable[_player][_id + 1]) then
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end