--------------------------------------------------------------------------------
-- MapName: (2) Eisiger Fjord
--
-- Author: ???
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Eisiger Fjord "
gvMapVersion = " v1.1 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,1,1,2)
	StartTechnologies()
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

	--Init local map stuff
	Mission_InitGroups()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
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
	--
	StartCountdown(1,AnfangsBriefing,false)
	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	--
	SetHostile(1,3)
	SetHostile(2,3)
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(1,4)
	SetHostile(2,4)
	--
	SetFriendly(1,2)
	--
	SetPlayerName(3,"Nordfeste")
	SetPlayerName(5,"Wikinger")
	--
	ActivateShareExploration(1,2,true)
	--
	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
		CreateMilitaryGroup(5,Entities.CU_Barbarian_LeaderClub2,12,GetPosition("P5"))
	end
	LocalMusic.UseSet = HIGHLANDMUSIC

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
	end
	Mission_InitLocalResources()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
  	MapEditor_SetupAI(3, 3, 25000, 2, "P3", 3, 1200+(600*gvDiffLVL))
	MapEditor_Armies[3].offensiveArmies.strength = round(40/gvDiffLVL)
	MapEditor_SetupAI(5, 2, 18000, 1, "P5", 3, 1200+(600*gvDiffLVL))
	SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 7} )
	CreateArmyP4_1()
	CreateArmyP4_2()
	CreateArmyP4_3()
	--
	StartSimpleJob("VictoryJob")
	StartCountdown(20*60*gvDiffLVL,UpgradeKIa,false)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function CreateArmyP4_1()

	armyP4_1	= {}
    armyP4_1.player 	= 4
    armyP4_1.id = 1
    armyP4_1.strength = round(6/gvDiffLVL)
    armyP4_1.position = GetPosition("P3")
    armyP4_1.rodeLength = 10500
	SetupArmy(armyP4_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1,armyP4_1.strength,1 do
	    EnlargeArmy(armyP4_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_1")

end

function ControlArmyP4_1()

    if IsDead(armyP4_1) and IsExisting("HQP3") then
        CreateArmyP4_1()
        return true
    else
        Defend(armyP4_1)
    end
end
function CreateArmyP4_2()

	armyP4_2	= {}
    armyP4_2.player 	= 4
    armyP4_2.id = 2
    armyP4_2.strength = round(4/gvDiffLVL)
    armyP4_2.position = GetPosition("P3")
    armyP4_2.rodeLength = 10500
	SetupArmy(armyP4_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

    for i = 1,armyP4_2.strength,1 do
	    EnlargeArmy(armyP4_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_2")

end

function ControlArmyP4_2()

    if IsDead(armyP4_2) and IsExisting("HQP3") then
        CreateArmyP4_2()
        return true
    else
        Defend(armyP4_2)
    end
end
function CreateArmyP4_3()

	armyP4_3	= {}
    armyP4_3.player 	= 4
    armyP4_3.id = 3
    armyP4_3.strength = round(4/gvDiffLVL)
    armyP4_3.position = GetPosition("P3")
    armyP4_3.rodeLength = 10500
	SetupArmy(armyP4_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_3.strength,1 do
	    EnlargeArmy(armyP4_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_3")

end

function ControlArmyP4_3()

    if IsDead(armyP4_3) and IsExisting("HQP3") then
        CreateArmyP4_3()
        return true
    else
        Defend(armyP4_3)
    end
end
function UpgradeKIa()
	for i = 3,5 do
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

		StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
	end
end
function UpgradeKIb()
	for i = 3,5 do
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

		StartCountdown(15*60*gvDiffLVL,UpgradeKIc,false)
	end
end
function UpgradeKIc()
	for i = 3,5 do
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
function VictoryJob()
	if IsDead("HQP3") then
		Victory()
		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Eine rauhe, unwirtliche Gegend, in der sich Eure Helden befinden. Am Ufer eines eisigen Fjordes erheben sich steile, felsige Hügel. Das Land ist karg und wenig bewachsen."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Am nördlichen Ufer thront die Stadt Nordfeste, deren finsterer Herrscher das Land tyrannisiert und jeden Fremden als Feind betrachtet.",
		position = GetPosition("P3")
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Auf einer kleinen Insel hat sich ein alter Wikinger niedergelassen. Er soll dort große Schätze horten, so erzählt man sich...",
		position = GetPosition("P5")
    }
	AP{
        title	= "@color:230,120,0 Missionsbeschreibung",
        text	= "@color:230,0,0 Spielt wie es Euch gefällt. Achtet nur darauf, dass Ihr Eure Burg nicht verliert."
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

	Display.SetPlayerColorMapping(5,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(3,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(4,KERBEROS_COLOR)

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
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 1000
	local InitWoodRaw 		= 800
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