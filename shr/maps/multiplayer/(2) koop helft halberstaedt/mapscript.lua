-- Mapname: (2) Helft Halberstädt
-- Author: P4F

gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Helft Halberstädt "
gvMapVersion = " v1.2 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	TagNachtZyklus(24,1,1,-3,1)
	StartTechnologies()

    Mission_InitGroups()

    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()


	-- eigene
	_GlobalCounter = 0
	InitTechTables()
	PlayerMainQuest()
	StartSimpleJob("VictoryJob")
	StartSimpleJob("DefeatJob")
	StartSimpleJob("SJ_DestroyHQ4Message")
	StartSimpleJob("SJ_DestroyHQ5Message")

	Display.SetPlayerColorMapping(4,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(5,ROBBERS_COLOR)

	ActivateShareExploration(1, 2, true)
	ActivateShareExploration(1, 3, true)
	ActivateShareExploration(2, 3, true)

	for j = 1,4 do
		CreateWoodPile("Holzstapel"..j,400000)
	end


	gvCamera.ZoomDistanceMax = 8000

	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,43474,41446,0,1),"posP4")
	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,43474,16254,0,1),"posP5")

	--

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
	--MapEditor_SetupDestroyVictoryCondition(3)

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 0 )
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
	SetupKerberos()
	SetupVarg()

	-- Halberstädt
	SetupHalberstaedt()

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupHalberstaedt()

	-- Spieler 3 - Halberstädt
    MapEditor_SetupAI(3,3,6000,0,"DZ",2,0)
	SetupPlayerAi(3, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 2000,
        clay	= 1000,
        iron	= 2000,
        sulfur	= 1500,
        stone	= 1000,
        wood	= 1500}}
	)
	MapEditor_Armies[3].offensiveArmies.strength = 30 + round(8*gvDiffLVL)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupKerberos()

	-- Spieler 4 - Kerberos
    MapEditor_SetupAI(4,3,11000,0,"posP4",3,0)
	SetupPlayerAi(4, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 2000,
        clay	= 1000,
        iron	= 3000,
        sulfur	= 3000,
        stone	= 1000,
        wood	= 3000}}
	)
	MapEditor_Armies[4].offensiveArmies.strength = round(20/gvDiffLVL)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupVarg()

	-- Spieler 5 - Varg
    MapEditor_SetupAI(5,3,11000,0,"posP5",3,0)
	SetupPlayerAi(5, {
	serfLimit = 8,
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 2000,
        clay	= 1000,
        iron	= 3000,
        sulfur	= 3000,
        stone	= 1000,
        wood	= 3000}}
	)
	MapEditor_Armies[5].offensiveArmies.strength = round(20/gvDiffLVL)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	-- Namen, Diplomatie
	--SetPlayerName(1, "")
	--SetPlayerName(2, "")
	SetPlayerName(3, "Halberstädt")
	SetPlayerName(4, "Kerberos")
	SetPlayerName(5, "Varg")

	-- Spieler 1 und 2 verbündet
	SetFriendly(1, 2)

	-- Spieler 1 und 2 mit 3 verbündet
	SetFriendly(1, 3)
	SetFriendly(2, 3)

	-- Spieler 1 feindlich zu 4 und 5
	SetHostile(1, 4)
	SetHostile(1, 5)

	-- Spieler 2 feindlich zu 4 und 5
	SetHostile(2, 4)
	SetHostile(2, 5)

	-- Spieler 4 und 5 verbündet
	SetFriendly(4, 5)

	-- Spieler 3 feindlich zu 4 und 5
	SetHostile(3, 4)
	SetHostile(3, 5)

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
	Technologies.T_BloodRush,
	Technologies.T_SilverSpears
	}

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- zeitlich festgelegte Events der AI

function SJ_Timeline()
	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == round(15*60*gvDiffLVL) then		-- 15
		AddIron(3, 2000)
		AddWood(3, 2000)
		MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(8/gvDiffLVL)
		MapEditor_Armies[5].offensiveArmies.strength = MapEditor_Armies[5].offensiveArmies.strength + round(8/gvDiffLVL)

	elseif _GlobalCounter == round(25*60*gvDiffLVL) then	-- 25
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
			MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
		end

	elseif _GlobalCounter == round(30*60*gvDiffLVL) then	-- 30
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == round(40*60*gvDiffLVL) then	-- 40
		local i
		for i = 4,5 do
			AI_ResearchTechnologies(i, _TechTableLow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
		end

	elseif _GlobalCounter == round(50*60*gvDiffLVL) then	-- 50

		AI_ResearchTechnologies(3, _TechTableLow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderSword)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierSword)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderPoleArm)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierPoleArm)

		AddIron(3, 2000)
		AddWood(3, 2000)

	elseif _GlobalCounter == round(55*60*gvDiffLVL) then	-- 55
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(4/gvDiffLVL)
		end
		TributeP3_RushForward()
		Message("Ihr könnt Halberstädt nun das Signal geben, mit in die Offensive zu gehen!")

	elseif _GlobalCounter == round(62*60*gvDiffLVL) then	-- 62
		local i
		for i = 4,5 do
			AI_ResearchTechnologies(i, _TechTableRifle)
		end

		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierBow)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.LeaderPoleArm)
		AI_UpgradeMilitaryGroup(3, UpgradeCategories.SoldierPoleArm)

	elseif _GlobalCounter == round(65*60*gvDiffLVL) then	-- 65
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderRifle)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierRifle)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(4/gvDiffLVL)
		end

	elseif _GlobalCounter == round(70*60*gvDiffLVL) then	-- 70
		local i
		for i = 3,5 do
			AI_ResearchTechnologies(i, _TechTableMedium)
		end

		local j
		for j = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierCavalry)
			AddIron(j, 2000)
			AddWood(j, 2000)
			AddSulfur(j, 2000)
		end

	elseif _GlobalCounter == round(75*60*gvDiffLVL) then	-- 75
		local i
		for i = 3,5 do
			AI_ResearchTechnologies(i, _TechTableHigh)
		end

	elseif _GlobalCounter == round(80*60*gvDiffLVL) then	-- 80
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(4/gvDiffLVL)
		end

	elseif _GlobalCounter == round(90*60*gvDiffLVL) then	-- 90
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == round(95*60*gvDiffLVL) then	-- 95
		local i
		for i = 4,5 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderHeavyCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierHeavyCavalry)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(4/gvDiffLVL)
		end


	elseif _GlobalCounter == round(120*60*gvDiffLVL) then	-- 120
		local i
		for i = 4,5 do
			AI_ResearchTechnologies(i, _TechTableVeryHigh)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(4/gvDiffLVL)
		end
		-- Timeline beenden, sobald alle Events abgearbeitet sind
		return true

	end

end

function TributeP3_RushForward()
	local TrP3_R =  {}
	TrP3_R.playerId = 1
	TrP3_R.text = "Zahlt " .. dekaround(8000/gvDiffLVL) .. " Taler, damit Halberstädt mit in die Offensive geht!"
	TrP3_R.cost = { Gold = dekaround(8000/gvDiffLVL) }
	TrP3_R.Callback = TributePaid_P3_R
	TP3_R = AddTribute(TrP3_R)
end
function TributePaid_P3_R()
	MapEditor_Armies[3].offensiveArmies.rodeLength = Logic.WorldGetSize()
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

-------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayerMainQuest()
	quest	= {
	id		= 1,
	type	= MAINQUEST_OPEN,
	title	="Eure Aufgabe",
	text	="Verteidigt Halberstädt! Ihr Dorfzentrum darf nicht fallen. Baut Brücken und schickt der Handelsstadt Unterstützung sobald wie möglich. Zerstört danach die Burgen von Kerberos und Varg!",
	}
	for p = 1,2 do Logic.AddQuest(p, quest.id, quest.type, quest.title, quest.text,1) end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

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
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= dekaround(1200*gvDiffLVL)
	local InitClayRaw	= dekaround(1200*gvDiffLVL)
	local InitWoodRaw	= dekaround(1200*gvDiffLVL)
	local InitStoneRaw	= dekaround(1000*gvDiffLVL)
	local InitIronRaw	= dekaround(1000*gvDiffLVL)
	local InitSulfurRaw	= dekaround(400*gvDiffLVL)

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)

		if gvDiffLVL > 1 then
			ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
			ResearchTechnology(Technologies.GT_Construction, i) --> Konstruktion
		end
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P4HQ") and IsDead("P5HQ") and IsExisting("DZ") then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DestroyHQ4Message()

	if IsDead("P4HQ") then
		Message("Kerberos Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
		return true
	end
end

function SJ_DestroyHQ5Message()

	if IsDead("P5HQ") then
		Message("Vargs Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function DefeatJob()

	if IsDead("DZ") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

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
 