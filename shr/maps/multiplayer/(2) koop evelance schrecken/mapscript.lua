-- Mapname: (2) Evelance Schrecken
-- Author: P4F

gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Evelance Schrecken "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

    gvMission = {}
    gvMission.PlayerID = GUI.GetPlayerID()
    TagNachtZyklus(24,1,1,-1,1)
	StartTechnologies()

    Mission_InitGroups()
    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	-- eigene
	_GlobalCounter = 0
	InitTechTables()
	StartSimpleJob("VictoryJob")
	ActivateShareExploration(1,2,true)

	for j = 1,2 do
		CreateWoodPile("Holzi"..j, 140000)
	end

	gvCamera.ZoomDistanceMax = 8000

    if XNetwork.Manager_DoesExist() == 0 then
		Message("Einzelspieler aktiviert!")

        for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )

		Logic.ChangeAllEntitiesPlayerID(2, 1)

    end

    --LocalMusic.UseSet = HIGHLANDMUSIC
    LocalMusic.UseSet = EUROPEMUSIC
    --LocalMusic.UseSet = HIGHLANDMUSIC
    --LocalMusic.UseSet = MEDITERANEANMUSIC
    --LocalMusic.UseSet = DARKMOORMUSIC
    --LocalMusic.UseSet = EVELANCEMUSIC

	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")

	SetupDiplomacy()

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
	end
	Mission_InitLocalResources()
	--
	StartSimpleJob("SJ_Timeline")
	-- Gegner
	SetupP3()
	SetupP4()
	SetupP5()
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupP3()

    MapEditor_SetupAI(3, round(4-gvDiffLVL), 8000, 0, "P3HQ", 3, 30*60*gvDiffLVL)
	SetupPlayerAi(3, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 20}})
	Display.SetPlayerColorMapping(3, ROBBERS_COLOR)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupP4()

    MapEditor_SetupAI(4, round(4-gvDiffLVL), 8000, 0, "P4HQ", 3, 30*60*gvDiffLVL)
	SetupPlayerAi(4, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 20}})
	Display.SetPlayerColorMapping(4, ROBBERS_COLOR)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupP5()

    MapEditor_SetupAI(5, round(4-gvDiffLVL), 9000, 3, "P5HQ", 1, 60*60*gvDiffLVL)
	SetupPlayerAi(5, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 30}})
	Display.SetPlayerColorMapping(5, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(8, ROBBERS_COLOR)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	SetPlayerName(3,"Kerberos Truppen")

	-- Spieler 1 und 2 verbündet
	SetFriendly(1,2)

	-- Spieler 1 feindlich zu 3,4,5
	SetHostile(1,3)
	SetHostile(1,4)
	SetHostile(1,5)
	-- Spieler 2 feindlich zu 3,4,5
	SetHostile(2,3)
	SetHostile(2,4)
	SetHostile(2,5)

	-- Spieler 3,4 und 5 verbündet
	SetFriendly(3,4)
	SetFriendly(3,5)
	SetFriendly(4,5)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitTechTables()

	-- erste Technologien
	_TechTableLow = {
	Technologies.T_SoftArcherArmor,
	Technologies.T_LeatherMailArmor,
	Technologies.T_Fletching,
	Technologies.T_WoodAging
	}

	-- ein paar weitere Techs
	_TechTableMedium = {
	Technologies.T_ChainMailArmor,
	Technologies.T_LeatherArcherArmor,
	Technologies.T_MasterOfSmithery,
	Technologies.T_BodkinArrow,
	Technologies.T_Turnery,
	Technologies.T_BetterTrainingArchery,
	Technologies.T_BetterTrainingBarracks
	}

	-- Technologien für Scharfschützen
	_TechTableRifle = {
	Technologies.T_FleeceArmor,
	Technologies.T_FleeceLinedLeatherArmor,
	Technologies.T_LeadShot,
	Technologies.T_Sights
	}

	-- fortgeschrittene Techs
	_TechTableHigh = {
	Technologies.T_BlisteringCannonballs,
	Technologies.T_BetterChassis,
	Technologies.T_EnhancedGunPowder
	}

	-- Silber-Techs
	_TechTableVeryHigh = {
	Technologies.T_SilverMissiles,
	Technologies.T_SilverBullets,
	Technologies.T_SilverSwords,
	Technologies.T_SilverLance,
	Technologies.T_BloodRush
	}
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- zeitlich festgelegte Events der AI

function SJ_Timeline()
	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == round(36*60*gvDiffLVL) then	-- 36
		AI_ResearchTechnologies(5, _TechTableLow)

	elseif _GlobalCounter == round(45*60*gvDiffLVL) then	-- 45
		AI_ResearchTechnologies(3, _TechTableLow)
		AI_ResearchTechnologies(4, _TechTableLow)
		AI_ResearchTechnologies(5, _TechTableMedium)

	elseif _GlobalCounter == round(58*60*gvDiffLVL) then	-- 58
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderSword)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierSword)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderSword)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierSword)

	elseif _GlobalCounter == round(64*60*gvDiffLVL) then	-- 64
		AI_ResearchTechnologies(3, _TechTableMedium)
		AI_ResearchTechnologies(4, _TechTableMedium)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderSword)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierSword)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderSword)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierSword)
		for i = 3,5 do
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
			MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
		end

	elseif _GlobalCounter == round(78*60*gvDiffLVL) then	-- 78
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierBow)

		AI_ResearchTechnologies(5, _TechTableRifle)
		AI_ResearchTechnologies(5, _TechTableHigh)

	elseif _GlobalCounter == round(121*60*gvDiffLVL) then	-- 121
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierBow)
		AI_ResearchTechnologies(3, _TechTableRifle)
		AI_ResearchTechnologies(4, _TechTableRifle)
		for i = 3,5 do
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
			MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 2
		end

	elseif _GlobalCounter == round(128*60*gvDiffLVL) then	-- 128
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderRifle)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierRifle)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.LeaderRifle)
		AI_UpgradeMilitaryGroup(4, UpgradeCategories.SoldierRifle)
		AI_ResearchTechnologies(3, _TechTableHigh)
		AI_ResearchTechnologies(4, _TechTableHigh)
		AI_ResearchTechnologies(5, _TechTableVeryHigh)

		-- Timeline beenden, sobald alle Events abgearbeitet sind
		return true

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- einige Upgrades für AI ...

-- einige Technologien erforschen
function AI_ResearchTechnologies(_AI, _TechTable)
	local i
	for i = 1, table.getn(_TechTable) do
		ResearchTechnology(_TechTable[i], _AI)
	end
end

-- Einheiten verbessern
function AI_UpgradeMilitaryGroup(_AI, _type)
	Logic.UpgradeSettlerCategory(_type, _AI)
end

function Mission_InitGroups()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
    --no limitation in this map
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set local resources
function Mission_InitLocalResources()
	--local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= 800
	local InitClayRaw	= 1500
	local InitWoodRaw	= 1500
	local InitStoneRaw	= 1200
	local InitIronRaw	= 800
	local InitSulfurRaw	= 600

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)
		if gvDiffLVL > 1 then
			ResearchTechnology(Technologies.GT_Construction, i)	--> Konstruktion
			ResearchTechnology(Technologies.GT_Literacy, i)		--> Bildung
		end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DefeatP1()
	if IsDead("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("P2HQ") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end