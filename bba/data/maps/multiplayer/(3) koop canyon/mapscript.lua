-- Mapname: (3) Canyon
-- Author: Ghoul
-- Script: Play4FuN/Ghoul

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (3) Canyon "
gvMapVersion = " v1.2 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,1,-1,1)
	StartTechnologies()
    gvMission = {}
    gvMission.PlayerID = GUI.GetPlayerID()

    Mission_InitGroups()
    Mission_InitPlayerColorMapping()
    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()
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
	StartCountdown(1,AnfangsBriefing,false)	--# Intro

    StartSimpleJob("VictoryJob")

	ActivateShareExploration(1, 2, true)
	ActivateShareExploration(1, 3, true)

    if XNetwork.Manager_DoesExist() == 0 then -- wenn offline, dann... --
	Message("Einzelspieler aktiviert!")
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		Logic.ChangeAllEntitiesPlayerID(3, 1)
        for i = 1, 3 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )
    end

    --LocalMusic.UseSet = HIGHLANDMUSIC
    --LocalMusic.UseSet = EUROPEMUSIC
    --LocalMusic.UseSet = HIGHLANDMUSIC
    LocalMusic.UseSet = MEDITERANEANMUSIC
    --LocalMusic.UseSet = DARKMOORMUSIC
    --LocalMusic.UseSet = EVELANCEMUSIC
	--MapEditor_SetupDestroyVictoryCondition(3)

	-- Niederlagebedingungen für menschliche Spieler
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")
	StartSimpleJob("SJ_DefeatP3")
	-- # Spielernamen
	SetPlayerName(6, "Rhodosina")
	SetPlayerName(5, "Neapoliton")
	SetPlayerName(4, "Mikatheneos")

	-- Spieler 1 und 2 verbündet
	SetFriendly(1, 2)
	SetFriendly(1, 3)
	SetFriendly(2, 3)

	-- Spieler 5 und 7 und 4 und 6 gleiche Farben
	Display.SetPlayerColorMapping(5, ENEMY_COLOR1)
	Display.SetPlayerColorMapping(7, ENEMY_COLOR1)
	Display.SetPlayerColorMapping(4, ENEMY_COLOR1)
	Display.SetPlayerColorMapping(6, ENEMY_COLOR1)
	Display.SetPlayerColorMapping(8, NPC_COLOR)
	for i = 1, 3 do
        Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
    end

	-- Spieler 1 feindlich zu 4,5,6 und 7
	SetHostile(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	SetHostile(1,7)
	-- Spieler 2 feindlich zu 4,5,6 und 7
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)
	SetHostile(2,7)
	-- Spieler 3 feindlich zu 4,5,6 und 7
	SetHostile(3,4)
	SetHostile(3,5)
	SetHostile(3,6)
	SetHostile(3,7)
	-- ExtraArmeen
	SetupExtraArmys()

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
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

	for i = 1,3 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
	end
	Mission_InitLocalResources()
	--
	MerchCamp()
	--
		-- Spieler 4

	MapEditor_SetupAI(4, 1, 25000, 1, "P4_HQ", 3, 900*gvDiffLVL)
	SetupPlayerAi(4, {
	serfLimit = 16,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 20, randomTime = 1},
	resources = {
        gold	= 1000,
        clay	= 2000,
        iron	= 800,
        sulfur	= 500,
        stone	= 2000,
        wood	= 2000},
	refresh = {
        gold		= 100,
        clay		= 100,
        iron		= 100,
        sulfur		=  50,
        stone		=  50,
        wood		= 100,
        updateTime	= 60}}
	)
	-- Spieler 5

	MapEditor_SetupAI(5, 1, 25000, 1, "P5_HQ", 3, 900*gvDiffLVL)
	SetupPlayerAi(5, {
	serfLimit = 16,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 20, randomTime = 1},
	resources = {
        gold	= 1000,
        clay	= 2000,
        iron	= 800,
        sulfur	= 500,
        stone	= 2000,
        wood	= 2000},
	refresh = {
        gold		= 1000,
        clay		= 1000,
        iron		= 1000,
        sulfur		=  500,
        stone		=  500,
        wood		= 1000,
        updateTime	= 20}}
	)
	-- Spieler 6

	MapEditor_SetupAI(6, 1, 38000, 1, "P6_HQ", 3, 900*gvDiffLVL)
	SetupPlayerAi(6, {
	serfLimit = 16,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 20, randomTime = 1},
	resources = {
        gold	= 1000,
        clay	= 2000,
        iron	= 800,
        sulfur	= 500,
        stone	= 2000,
        wood	= 2000},
	refresh = {
        gold		= 1000,
        clay		= 1000,
        iron		= 1000,
        sulfur		=  500,
        stone		=  500,
        wood		= 1000,
        updateTime	= 20}}
	)


	----
	StartCountdown( 5*60*gvDiffLVL, UpgradeAISerfs, false)
	StartCountdown(24*60*gvDiffLVL, UpgradeAITroops1, false)

	-- ExtraArmeen
	SetupExtraArmys()
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
-------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitPlayerColorMapping()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Leibeigene
function UpgradeAISerfs()
	AI.Village_SetSerfLimit(5, 24)
	AI.Village_SetSerfLimit(4, 24)
	AI.Village_SetSerfLimit(6, 24)
	StartCountdown(15*60, UpgradeAISerfsAgain, false)
end

function UpgradeAISerfsAgain()
	AI.Village_SetSerfLimit(5, 32)
	AI.Village_SetSerfLimit(4, 32)
	AI.Village_SetSerfLimit(6, 32)
	StartCountdown(45*60, DecreaseAISerfs, false)
end

function DecreaseAISerfs()
	AI.Village_SetSerfLimit(5, 16)
	AI.Village_SetSerfLimit(4, 16)
	AI.Village_SetSerfLimit(6, 16)
end

-- Truppen upgrades ...
function UpgradeAITroops1()
	for i = 4,6 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
	end

	StartCountdown(12*60*gvDiffLVL,UpgradeAITroops2,false)
end

function UpgradeAITroops2()
	for i = 4,6 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength			=	(Logic.WorldGetSize()*2)/3
		MapEditor_Armies[i].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize()/3
	end

	StartCountdown(10*60*gvDiffLVL,UpgradeAITroops3,false)
end

function UpgradeAITroops3()
	for i = 4,6 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)

		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
	end

	StartCountdown(10*60*gvDiffLVL,UpgradeAITroops4,false)
end

function UpgradeAITroops4()
	for i = 4,6 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		MapEditor_Armies[i].offensiveArmies.strength			=	MapEditor_Armies[i].offensiveArmies.strength + round(8/gvDiffLVL)
	end

	StartCountdown(10*60*gvDiffLVL,UpgradeAITroops5,false)
end

function UpgradeAITroops5()
	for i = 4,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)

		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
	end

	StartCountdown(12*60*gvDiffLVL,UpgradeAITroops6,false)
end

function UpgradeAITroops6()
	for i = 4,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
	end

end

function Mission_InitGroups()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
    --no limitation in this map
end
function StartTechnologies()
	for i = 1,3 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set local resources
function Mission_InitLocalResources()	--# Rohstoffe
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= dekaround(1200*gvDiffLVL)
	local InitClayRaw	= 1000
	local InitWoodRaw	= 1000
	local InitStoneRaw	= 800
	local InitIronRaw	= 800
	local InitSulfurRaw	= 500

	for i = 1,3 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

        --ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P3_HQ") and IsDead("P4_HQ") and IsDead("P5_HQ") then
		StartCountdown(5, Victory, false)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DefeatP1()
	if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Headquarters1)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Headquarters2)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Headquarters3)) < 1 then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(2, Entities.PB_Headquarters1)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(2, Entities.PB_Headquarters2)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(2, Entities.PB_Headquarters3)) < 1 then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

function SJ_DefeatP3()
	if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(3, Entities.PB_Headquarters1)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(3, Entities.PB_Headquarters2)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(3, Entities.PB_Headquarters3)) < 1 then
		Logic.PlayerSetGameStateToLost(3)
		return true
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function AnfangsBriefing()	--# Intro, noch fast leer
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,0,0 Intro",
        text	= "@color:230,255,0 Wilkommen in diesen herrlichen Ländereien! Hier gibt es Rohstoffe zur Genüge. @cr @color:150,150,150 (Weiter mit Esc)"
    }
    AP{
        title	= "@color:230,0,200 Intro",
        text	= "@color:20,255,50 Ihr seid hier aber nicht alleine. Drei ferne Städte sind Fremden nicht gerade freundlich aufgeschlossen. @cr @color:150,150,150 (Weiter mit Esc)"
    }
    AP{
        title	= "@color:230,0,0 Intro",
        text	= "@color:230,255,0 Baut in Ruhe eure Siedlung in diesem schmalen Canyon-Wegen auf, aber achtet darauf, dass der Feind euer Lager nicht entdeckt. @cr @color:150,150,150 (Weiter mit Esc)"
    }
    AP{
        title	= "@color:230,0,200 Intro",
        text	= "@color:20,255,0 Viel Spass mit der Map wünschen @color:230,255,0 Play4Fun @color:20,255,50 und @color:230,0,200 Ghoul! @cr @color:150,150,150 (Weiter mit Esc)"
    }

    StartBriefing(briefing)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
function MerchCamp()     ----Truppenhändler wird eingestellt----

	local mercenaryId = Logic.GetEntityIDByName("camp1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderRifle2, round(2*gvDiffLVL), ResourceType.Sulfur, dekaround(500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword3, round(8*gvDiffLVL), ResourceType.Iron, dekaround(400/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderPoleArm3, round(12*gvDiffLVL), ResourceType.Wood, dekaround(700/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow4, round(8*gvDiffLVL), ResourceType.Gold, dekaround(600/gvDiffLVL))

	local mercenaryId2 = Logic.GetEntityIDByName("camp2")
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderRifle2, round(2*gvDiffLVL), ResourceType.Gold, dekaround(800/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon3, round(3*gvDiffLVL), ResourceType.Sulfur, dekaround(700/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon4, round(3*gvDiffLVL), ResourceType.Iron, dekaround(1250/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderSword4, round(6*gvDiffLVL), ResourceType.Iron, dekaround(700/gvDiffLVL))

end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupExtraArmys()

	ExtraArmy = {}

	SetupPlayerAi(7, {serfLimit = 0, extracting = 0, constructing = false, repairing = false})

	ExtraArmy[7] = {}
	ExtraArmy[7].strength		= 8
	ExtraArmy[7].id          	= 1
	ExtraArmy[7].player			= 7
	ExtraArmy[7].position		= GetPosition("posP7")
	ExtraArmy[7].rodeLength		= Logic.WorldGetSize()

	SetupArmy(ExtraArmy[7])


	-- Truppen

	-- schwach

	troopDescriptionLow = {}

	troopDescriptionLow[1] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderSword2}
	troopDescriptionLow[2] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderSword2}

	troopDescriptionLow[3] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderPoleArm2}
	troopDescriptionLow[4] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderPoleArm2}

	troopDescriptionLow[5] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderBow2}
	troopDescriptionLow[6] = {maxNumberOfSoldiers = 4, leaderType = Entities.PU_LeaderBow2}

	troopDescriptionLow[7] = {maxNumberOfSoldiers = 3, leaderType = Entities.PU_LeaderRifle1}
	troopDescriptionLow[8] = {maxNumberOfSoldiers = 0, leaderType = Entities.PV_Cannon2}

	-- mittel

	troopDescriptionNormal = {}

	troopDescriptionNormal[1] = {maxNumberOfSoldiers = 8, leaderType = Entities.PU_LeaderSword3}
	troopDescriptionNormal[2] = {maxNumberOfSoldiers = 8, leaderType = Entities.PU_LeaderSword3}

	troopDescriptionNormal[3] = {maxNumberOfSoldiers = 3, leaderType = Entities.PU_LeaderRifle1}
	troopDescriptionNormal[4] = {maxNumberOfSoldiers = 3, leaderType = Entities.PU_LeaderRifle1}

	troopDescriptionNormal[5] = {maxNumberOfSoldiers = 12, leaderType = Entities.PU_LeaderBow4}
	troopDescriptionNormal[6] = {maxNumberOfSoldiers = 12, leaderType = Entities.PU_LeaderBow4}

	troopDescriptionNormal[7] = {maxNumberOfSoldiers = 0, leaderType = Entities.PV_Cannon3}
	troopDescriptionNormal[8] = {maxNumberOfSoldiers = 0, leaderType = Entities.PV_Cannon4}

	-- Control Job

	StartSimpleJob("SJ_ControlExtraArmys")

end


function SJ_ControlExtraArmys()

	if Counter.Tick2("SJ_ControlExtraArmys", 15*60) then

		local time = round(Logic.GetTime())

		if time < 40*60 then

			return false

		end

		if time < 70*60 then

			local n

			for n = 1, table.getn(troopDescriptionLow) do

				EnlargeArmy(ExtraArmy[7], troopDescriptionLow[n])

			end

			Advance(ExtraArmy[7])

		else

			local  n

			for n = 1, table.getn(troopDescriptionNormal) do

				EnlargeArmy(ExtraArmy[7], troopDescriptionNormal[n])

			end

			Advance(ExtraArmy[7])

		end

	end

	if IsDead("P5_HQ") and IsDead("P4_HQ") then

		return true

	end
end