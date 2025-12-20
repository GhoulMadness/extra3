-- Mapname: (2) Silbertal
-- Author: P4F

gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Silbertal "
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

	for j = 1,4 do
		CreateWoodPile("Holzstapel"..j,400000)
	end

	for k = 5,8 do
		CreateWoodPile("Holzstapel"..k,600000)
	end

	gvCamera.ZoomDistanceMax = 8000

	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,53045,42217,0,1),"posP3")
	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,53063,16245,0,1),"posP4")
	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,4557,15463,0,1),"posP5")
	SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,4604,41677,0,1),"posP6")

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
    --LocalMusic.UseSet = EUROPEMUSIC
    --LocalMusic.UseSet = HIGHLANDMUSIC
    LocalMusic.UseSet = MEDITERANEANMUSIC
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
	SetupMary()
	SetupKerberos()
	SetupVarg()
	SetupKala()

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupMary()

	-- Spieler 3 - Mary
    MapEditor_SetupAI(3,4-round(gvDiffLVL),8000,1,"posP3",3,35*60*gvDiffLVL)
	SetupPlayerAi(3, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1}}
	)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupKerberos()

	-- Spieler 4 - Kerberos
    MapEditor_SetupAI(4,4-round(gvDiffLVL),8000,1,"posP4",3,30*60*gvDiffLVL)
	SetupPlayerAi(4, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1}}
	)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupVarg()

	-- Spieler 5 - Varg
    MapEditor_SetupAI(5,4-round(gvDiffLVL),8000,1,"posP5",3,30*60*gvDiffLVL)
	SetupPlayerAi(5, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1}}
	)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupKala()

	-- Spieler 6 - Kala
    MapEditor_SetupAI(6,4-round(gvDiffLVL),8000,1,"posP6",3,35*60*gvDiffLVL)
	SetupPlayerAi(6, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1}}
	)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	-- Namen, Diplomatie
	--SetPlayerName(1,"")
	--SetPlayerName(2,"")
	SetPlayerName(3,"Mary de Morftichet")
	SetPlayerName(4,"Kerberos")
	SetPlayerName(5,"Varg")
	SetPlayerName(6,"Kala")

	-- Spieler 1 und 2 verbündet
	SetFriendly(1,2)

	-- Spieler 1 feindlich zu 3,4,5 und 6
	SetHostile(1,3)
	SetHostile(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	-- Spieler 2 feindlich zu 3,4,5 und 6
	SetHostile(2,3)
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)
	-- Spieler 3 und 4 verbündet
	SetFriendly(3,4)
	-- Spieler 5 und 3,4,6 verbündet
	SetFriendly(3,5)
	SetFriendly(4,5)
	SetFriendly(5,6)
	-- Spieler 6 und 3,4 verbündet
	SetFriendly(3,6)
	SetFriendly(4,6)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function NewPlayerNames()

	UserTool_GetPlayerNameORIG = UserTool_GetPlayerName
	function UserTool_GetPlayerName(_PlayerID)
		if _PlayerID == 3 then
			return "Mary De Mortfichet"
		elseif _PlayerID == 4 then
			return "Kerberos"
		elseif _PlayerID == 5 then
			return "Varg"
		elseif _PlayerID == 6 then
			return "Kala"
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
	Technologies.T_EnhancedGunPowder
	}

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- zeitlich festgelegte Events der AI

function SJ_Timeline()
	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == 120 then	-- 2
		local i
		for i = 3,6 do
			IncreaseSerfAmount(i,16)
		end

	elseif _GlobalCounter == 240 then	-- 4
		local i
		for i = 3,6 do
			IncreaseSerfAmount(i,24)
		end

	elseif _GlobalCounter == 8*60 then	-- 8
		local i
		for i = 3,6 do
			IncreaseSerfAmount(i,32)
		end

	elseif _GlobalCounter == 607 then	-- 10+
		AddRessources(3,1)
		UpgradeAI_HQ(3)

	elseif _GlobalCounter == 633 then	-- 10+
		AddRessources(4,1)
		UpgradeAI_HQ(4)

	elseif _GlobalCounter == 685 then	-- 11+
		AddRessources(6,1)
		UpgradeAI_HQ(6)

	elseif _GlobalCounter == 730 then	-- 12+
		AddRessources(5,1)
		UpgradeAI_HQ(5)

	elseif _GlobalCounter == 34*60 then	-- 34
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == 36*60 then	-- 36
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
			MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
		end

	elseif _GlobalCounter == 52*60 then	-- 52
		local i
		for i = 3,6 do
			AI_ResearchTechnologies(i, _TechTableLow)
		end

	elseif _GlobalCounter == 58*60 then	-- 58
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
		end

	elseif _GlobalCounter == 59*60 then	-- 59
		local i
		for i = 3,6 do
			ChangePlayer("Stall"..i, i)
		end

	elseif _GlobalCounter == 61*60 then	-- 61
		AddRessources(4,2)
		UpgradeAI_HQ(4)

	elseif _GlobalCounter == 63*60 then	-- 63
		AddRessources(3,2)
		UpgradeAI_HQ(3)

	elseif _GlobalCounter == 64*60 then	-- 64
		AddRessources(5,2)
		UpgradeAI_HQ(5)

	elseif _GlobalCounter == 67*60 then	-- 67
		AddRessources(6,2)
		UpgradeAI_HQ(6)

	elseif _GlobalCounter == 74*60 then	-- 74
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
		end

	elseif _GlobalCounter == 76*60 then	-- 76
		local i
		for i = 3,6 do
			ChangePlayer("Kan"..i, i)
		end

	elseif _GlobalCounter == 84*60 then	-- 84
		local i
		for i = 3,6 do
			AI_ResearchTechnologies(i, _TechTableRifle)
		end

	elseif _GlobalCounter == round(85*60*gvDiffLVL) then	-- 85
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderRifle)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierRifle)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderPoleArm)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierPoleArm)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
			MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
		end

	elseif _GlobalCounter == round(101*60*gvDiffLVL) then	-- 101
		local i
		for i = 3,6 do
			AI_ResearchTechnologies(i, _TechTableMedium)

			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderCavalry)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierCavalry)
		end

	elseif _GlobalCounter == round(104*60*gvDiffLVL) then	-- 104
		local i
		for i = 3,6 do
			AI_ResearchTechnologies(i, _TechTableHigh)
		end

	elseif _GlobalCounter == round(121*60*gvDiffLVL) then	-- 121
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderSword)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierSword)
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
			MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
		end

	elseif _GlobalCounter == round(128*60*gvDiffLVL) then	-- 128
		local i
		for i = 3,6 do
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.LeaderBow)
			AI_UpgradeMilitaryGroup(i, UpgradeCategories.SoldierBow)
		end

	elseif _GlobalCounter == round(145*60*gvDiffLVL) then	-- 145
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

-- einige Upgrades für AI ...

-- mehr Leibeigene
function IncreaseSerfAmount(_AI, _amount)
	AI.Village_SetSerfLimit(_AI, _amount)
end


-- HQ aufrüsten
function UpgradeAI_HQ(_AI)
	UpgradeBuilding("P".._AI.."HQ")
end

-- Rohstoffe für Ausbau
function AddRessources(_AI, _level)

	if _level == 1 then
		AddGold(_AI, 300)
		AddClay(_AI, 250)
		AddStone(_AI, 300)
	elseif _level == 2 then
		AddGold(_AI, 500)
		AddClay(_AI, 400)
		AddStone(_AI, 500)
	end

end

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

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set local resources
function Mission_InitLocalResources()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= 1500
	local InitClayRaw	= 1500
	local InitWoodRaw	= 1500
	local InitStoneRaw	= 1200
	local InitIronRaw	= 1200
	local InitSulfurRaw	= 500

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)

        ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
        ResearchTechnology(Technologies.GT_Construction, i) --> Konstruktion
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
		Message("Marys Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ4Message()

	if IsDead("P4HQ") then
		Message("Kerberos Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ5Message()

	if IsDead("P5HQ") then
		Message("Vargs Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare,70)
		return true
	end
end

function SJ_DestroyHQ6Message()

	if IsDead("P6HQ") then
		Message("Kalas Burg wurde zerstört!")
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
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end