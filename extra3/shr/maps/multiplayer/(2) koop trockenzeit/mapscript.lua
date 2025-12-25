-- Mapname: (2) Trockenzeit
-- Author: P4F
-- Karte: 12

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Trockenzeit "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

    Mission_InitGroups()

    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()


	-- eigene
	_GlobalCounter = 0
	InitTechTables()
	StartSimpleJob("VictoryJob")
	StartSimpleJob("SJ_DestroyHQ3Message")
	StartSimpleJob("SJ_DestroyHQ4Message")
	StartSimpleJob("SJ_DestroyHQ5Message")
	StartSimpleJob("SJ_DestroyHQ6Message")
	NewPlayerNames()
	ActivateShareExploration(1,2,true)

	local j
	for j = 1,4 do
		CreateWoodPile("Holzstapel"..j, 32000)
	end

	gvCamera.ZoomDistanceMax = 8000

--	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,53045,42217,0,1),"posP3")

    if XNetwork.Manager_DoesExist() == 0 then	-- singleplayer mode
		Message("Einzelspieler aktiviert!")

        for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )

		Logic.ChangeAllEntitiesPlayerID(2, 1)

    end

    LocalMusic.UseSet = MEDITERANEANMUSIC

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 5 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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
	SetupRobbers()

	StartCountdown(30*60*gvDiffLVL, PeacetimeEnd, true)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupRobbers()

	MapEditor_SetupAI(3, round(3-gvDiffLVL), 9500, 1, "P3HQ", 2, 30*60*gvDiffLVL)
	MapEditor_SetupAI(6, round(3-gvDiffLVL), 9500, 1, "P6HQ", 2, 30*60*gvDiffLVL)
	MapEditor_SetupAI(4, round(4-gvDiffLVL), 10500, 1, "P4HQ", 1, 30*60*gvDiffLVL)
	MapEditor_SetupAI(5, round(4-gvDiffLVL), 10500, 1, "P5HQ", 1, 30*60*gvDiffLVL)

	local i
	for i = 3, 6 do
		Display.SetPlayerColorMapping(i, ROBBERS_COLOR)
		AI_ResearchTechnologies(i, _TechTableLow)
		AI_ResearchTechnologies(i, _TechTableMedium)
		AI_ResearchTechnologies(i, _TechTableHigh)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	-- Namen, Diplomatie
	--SetPlayerName(1,"")
	--SetPlayerName(2,"")
	SetPlayerName(3,"Romans Räuber")
	SetPlayerName(4,"Roberts Räuber")
	SetPlayerName(5,"Rolands Räuber")
	SetPlayerName(6,"Richards Räuber")

	-- Spieler 1 und 2 verbündet
	SetFriendly(1,2)

	local i, j
	-- Spieler 1 neutral zu 3,4,5 und 6
	for i = 3, 6 do
		--SetNeutral(1, i)
		SetHostile(1, i)
	end
	-- Spieler 2 neutral zu 3,4,5 und 6
	for j = 3, 6 do
		--SetNeutral(2, j)
		SetHostile(2, j)
	end

	-- Spieler 3 und 4
	SetNeutral(3,4)
	-- Spieler 5 und 3,4,6
	SetNeutral(3,5)
	SetNeutral(4,5)
	SetNeutral(5,6)
	-- Spieler 6 und 3,4
	SetNeutral(3,6)
	SetNeutral(4,6)

end

function PeacetimeEnd()

	--SetupRobbers()
	local i, j
	-- Spieler 1 feindlich zu 3,4,5 und 6
	for i = 3, 6 do
		SetHostile(1, i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
	end
	-- Spieler 2 feindlich zu 3,4,5 und 6
	for j = 3, 6 do
		SetHostile(2, j)
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function NewPlayerNames()

	UserTool_GetPlayerNameORIG = UserTool_GetPlayerName
	function UserTool_GetPlayerName(_PlayerID)
		if _PlayerID == 3 then
			return "Roman"
		elseif _PlayerID == 4 then
			return "Robert"
		elseif _PlayerID == 5 then
			return "Roland"
		elseif _PlayerID == 6 then
			return "Richard"
		else
			return UserTool_GetPlayerNameORIG(_PlayerID)
		end
	end

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
	Technologies.T_EnhancedGunPowder,
	Technologies.T_SilverMissiles
	}

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- zeitlich festgelegte Events der AI

function SJ_Timeline()
	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == round(54*60*gvDiffLVL) then	-- 54
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
		end

	elseif _GlobalCounter == round(85*60*gvDiffLVL) then	-- 85
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == round(90*60+gvDiffLVL) then	-- 90
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
		end

	elseif _GlobalCounter == round(95*60*gvDiffLVL) then	-- 95
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
		end

	elseif _GlobalCounter == round(100*60*gvDiffLVL) then	-- 100
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == round(110*60*gvDiffLVL) then	-- 110
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderHeavyCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierHeavyCavalry)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
		end

		-- Timeline beenden, sobald alle Events abgearbeitet sind
		return true

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
-- Gebäude bauen, ersetzt durch ChangePlayer
function AI_StartBuild(_AI, _type, _pos, _level)
local _constructionplan = {{ type = _type, pos = GetPosition(_pos), level = _level }}
FeedAiWithConstructionPlanFile(_AI, _constructionplan)
end
--]]

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
	local InitGoldRaw	=  800
	local InitClayRaw	= 1400
	local InitWoodRaw	= 1400
	local InitStoneRaw	=  800
	local InitIronRaw	=  600
	local InitSulfurRaw	=  600

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)

        ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
        ResearchTechnology(Technologies.GT_Construction, i) --> Konstruktion
        ResearchTechnology(Technologies.GT_Literacy, i) --> Bildung
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DestroyHQ3Message()

	if IsDead("P3HQ") then
		Message("Romans Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ4Message()

	if IsDead("P4HQ") then
		Message("Roberts Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ5Message()

	if IsDead("P5HQ") then
		Message("Rolands Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ6Message()

	if IsDead("P6HQ") then
		Message("Richards Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
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

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Comforts etc. --------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function UpgradeBuilding(_EntityName)
    -- Get entity's ID
    local EntityID = GetEntityId(_EntityName)
    -- Still existing?
    if IsValid(EntityID) then
        -- Get entity type and player
        local EntityType = Logic.GetEntityType(EntityID)
        local PlayerID = GetPlayer(EntityID)
        -- Get upgrade costs
        local Costs = {}
        Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
        -- Add needed resources
        for Resource, Amount in Costs do
            Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
        end
        -- Start upgrade
        GUI.UpgradeSingleBuilding(EntityID)
    end
end
