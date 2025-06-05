-- Mapname: (2) Heldenjagd
-- Author: P4F
-- Version 2
-- 27/12/2018

gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Heldenjagd "
gvMapVersion = " v1.2 "


-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- v3
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()
	UserTool_GetPlayerNameOrig = UserTool_GetPlayerName
	gvMission.PlayerNames = {}
	local _pID
	for _pID = 1, 8 do
		gvMission.PlayerNames[_pID] = UserTool_GetPlayerNameOrig(_pID)
	end
	function UserTool_GetPlayerName(_PlayerID)
		if (_PlayerID > 0) and (_PlayerID < 9) then
			return gvMission.PlayerNames[_PlayerID]
		end
	end

	Mapsize = Logic.WorldGetSize()

    TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

    Mission_InitGroups()
	Mission_InitTechnologies()

    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()	-- calls Logic.PlayerSetIsHumanFlag which in turn will display the player stats and enable taunts etc
--    MultiplayerTools.GiveBuyableHerosToHumanPlayer(0)

	-- eigene
	--
	InitColors()
	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player
	Display.SetPlayerColorMapping(1, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(2, NEPHILIM_COLOR)
	Display.SetPlayerColorMapping(7, EVIL_GOVERNOR_COLOR)
	Logic.PlayerSetPlayerColor(1, R, G, B)
	local R2, G2, B2 = GUI.GetPlayerColor(2)
	Logic.PlayerSetPlayerColor(2, R2, G2, B2)

	InitTechTables()
	InitPlayerQuest1()
	StartCountdown(110, TributeForQuest1, false)
	StartCountdown(1, Intro, false)
	StartCountdown(120, InitFreeCamera, false)

	--

	Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
	Logic.SetShareExplorationWithPlayerFlag(2, 1, 1)

	for j = 1,4 do
		CreateWoodPile("Holzstapel"..j, 50000)
	end

    if XNetwork.Manager_DoesExist() == 0 then
		--Message("SP")	--#
        for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        Logic.PlayerSetIsHumanFlag( gvMission.PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( gvMission.PlayerID )
		ActivateSingleplayerMode()
	else
		-- also when "playalone"
		--Message("MP")	--#

    end


	UpgradeCategories.Tower = UpgradeCategories.DarkTower

	LocalMusic.UseSet = EVELANCEMUSIC

	SetupDiplomacy()

	Trigger.RequestTrigger(Events.LOGIC_EVENT_TRIBUTE_PAID, nil, "Trade_TributePaid_Action", 1, nil, nil)

	HackAutoRefill_v2()

	HackUpgradeHints()

	gvMission.UseHeroHealthDisplay = true
	HackHeroHealthDisplay()
	Input.KeyBindDown(Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2)

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
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
	SetupEnemies()
	StartSimpleJob("SJ_Victory")
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")
	StartSimpleJob("SJ_DestroyHQ6")
	--
	Logic.AddMercenaryOffer(GetEntityId("mercTent1"), Entities.CU_VeteranLieutenant, round(2*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL), ResourceType.Iron, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent1"), Entities.CU_VeteranMajor, round(2*gvDiffLVL), ResourceType.Gold, dekaround(2000/gvDiffLVL), ResourceType.Iron, dekaround(1500/gvDiffLVL))

	Logic.AddMercenaryOffer(GetEntityId("mercTent2"), Entities.CU_VeteranLieutenant, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL), ResourceType.Iron, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent2"), Entities.CU_VeteranLieutenant, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1000/gvDiffLVL), ResourceType.Iron, dekaround(1500/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent2"), Entities.CU_VeteranMajor, round(10*gvDiffLVL), ResourceType.Gold, dekaround(2000/gvDiffLVL), ResourceType.Iron, dekaround(1500/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent2"), Entities.CU_VeteranMajor, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL), ResourceType.Iron, dekaround(2000/gvDiffLVL))

	Logic.AddMercenaryOffer(GetEntityId("mercTent3"), Entities.CU_VeteranLieutenant, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL), ResourceType.Iron, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent3"), Entities.CU_VeteranLieutenant, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1000/gvDiffLVL), ResourceType.Iron, dekaround(1500/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent3"), Entities.CU_VeteranMajor, round(10*gvDiffLVL), ResourceType.Gold, dekaround(2000/gvDiffLVL), ResourceType.Iron, dekaround(1500/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("mercTent3"), Entities.CU_VeteranMajor, round(10*gvDiffLVL), ResourceType.Gold, dekaround(1500/gvDiffLVL), ResourceType.Iron, dekaround(2000/gvDiffLVL))

	StartCountdown(40*60*gvDiffLVL,UpgradeAITroops1,false)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
-- Truppen upgrades ...
function UpgradeAITroops1()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
	end

	StartCountdown(15*60,UpgradeAITroops2,false)
end

function UpgradeAITroops2()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
	end

	StartCountdown(10*60,UpgradeAITroops3,false)
end

function UpgradeAITroops3()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)

		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
	end

	StartCountdown(15*60,UpgradeAITroops4,false)
end

function UpgradeAITroops4()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
	end

	StartCountdown(20*60,UpgradeAITroops5,false)
end

function UpgradeAITroops5()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)

		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
	end

	StartCountdown(30*60,UpgradeAITroops6,false)
end

function UpgradeAITroops6()
	for i = 3,7 do
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

	StartCountdown(40*60,UpgradeAITroops7,false)

end
function UpgradeAITroops7()
	for i = 3,7 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
	-- KI fertig aufgerüstet!
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitColors()
	col = {}
	-- Reihenfolge: Rot,Grün,Blau
	col.w		= " @color:255,255,255 "
	col.green	= " @color:0,255,0 "
	col.blue	= " @color:20,20,240 "
	col.P4F		= " @color:166,212,35 "
	col.gray	= " @color:180,180,180 "
	col.dgray	= " @color:120,120,120 "
	col.beig	= " @color:240,220,200 "
	col.yel		= " @color:255,200,0 "
	col.liyel 	= " @color:238,221,130 "
	col.orange 	= " @color:255,127,0 "
	col.red		= " @color:255,0,0 "
	col.ligreen	= " @color:173,255,47 "
	col.liblue 	= " @color:0,255,255 "
	col.pink	= " @color:200,100,200 "
	col.transp	= " @color:0,0,0,0 "
	col.keyb	= " @color:220,220,150 "
	col.black	= " @color:40,40,40 "
	col.blueFIX	= " @color:50,50,220 "
	col.greenFIX= " @color:0,200,0 "

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SetupEnemies()

	SetupAri()

end

function SetupAri()
	MapEditor_SetupAI(6,3,7800,1,"P6HQ",3,0)
	MapEditor_Armies[6].defensiveArmies.strength = round(6/gvDiffLVL)
	MapEditor_Armies[6].offensiveArmies.strength = round(25/gvDiffLVL)
	SetupPlayerAi(6, {
	serfLimit = round(8/gvDiffLVL),
	extracting = 0,
	constructing = true,
	repairing = true,
	rebuild = {delay = round(15*gvDiffLVL), randomTime = 1}
	})
	ConnectLeaderWithArmy(GetID("Ari"), nil, "defensiveArmies")
end

function SetupErec()
	MapEditor_SetupAI(3,3,Mapsize,3,"P3HQ",3,0)
	MapEditor_Armies[3].defensiveArmies.strength = round(9/gvDiffLVL)
	MapEditor_Armies[3].offensiveArmies.strength = round(35/gvDiffLVL)
	SetupPlayerAi(3, {
		serfLimit = round(9/gvDiffLVL),
		extracting = 1,
		constructing = true,
		repairing = true,
		rebuild = {delay = round(12*gvDiffLVL), randomTime = 1}
	})
	ConnectLeaderWithArmy(GetID("Erec"), nil, "defensiveArmies")

	local army = {}
	army.id = 0
	army.player = 7
	army.spawnPos = GetPosition("posP7Outpost")
	army.position = GetPosition("posP7Outpost")
	army.spawnGenerator = "helias_outpost1"
	army.strength = round(6/gvDiffLVL)
	army.spawnTypes = { {Entities.PU_LeaderBow3, 8}, {Entities.PU_LeaderSword3, 8}, {Entities.PU_LeaderPoleArm3, 8}}
	army.endless = true
	army.rodeLength = 6500
	army.respawnTime = round(30*gvDiffLVL)
	army.maxSpawnAmount = 1
	army.refresh = true

	SetupArmy(army)
	SetupAITroopSpawnGenerator("Helias_Army1", army)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmy", 1, {}, {army.player, army.id, army.spawnGenerator})

	local army2 = army
	army2.id = 1
	army2.spawnGenerator = "helias_outpost2"
	army2.spawnTypes = { {Entities.PU_LeaderCavalry2, 6}, {Entities.PU_LeaderHeavyCavalry2, 4}, {Entities.PU_LeaderUlan1, 4}}
	army2.generatorID = nil

	SetupArmy(army2)
	SetupAITroopSpawnGenerator("Helias_Army2", army2)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmy", 1, {}, {army2.player, army2.id, army2.spawnGenerator})
end

ControlArmy = function(_player, _id, _spawnGenerator)

	local army = ArmyTable[_player][_id + 1]
	if not IsDead(army) then
		Defend(army)
	else
		if IsDestroyed(_spawnGenerator) then
			return true
		end
	end
end

function SetupSalim()
	-- remove peacetime param
	MapEditor_SetupAI(4,3,Mapsize,3,"P4HQ",3,0)
	MapEditor_Armies[4].defensiveArmies.strength = round(9/gvDiffLVL)
	MapEditor_Armies[4].offensiveArmies.strength = round(30/gvDiffLVL)
	SetupPlayerAi(4, {
		serfLimit = round(10/gvDiffLVL),
		extracting = 1,
		constructing = true,
		repairing = true,
		rebuild = {delay = round(10*gvDiffLVL), randomTime = 1}
	})
	ConnectLeaderWithArmy(GetID("Salim"), nil, "defensiveArmies")
end

function SetupPilgrim()
	MapEditor_SetupAI(5,3,Mapsize,3,"P5HQ",3,0)
	MapEditor_Armies[5].defensiveArmies.strength = round(10/gvDiffLVL)
	MapEditor_Armies[5].offensiveArmies.strength = round(40/gvDiffLVL)
	SetupPlayerAi(5, {
		serfLimit = round(6/gvDiffLVL),
		extracting = 0,
		constructing = true,
		repairing = true,
		rebuild = {delay = round(10*gvDiffLVL), randomTime = 1}
	})
	ConnectLeaderWithArmy(GetID("Pilgrim"), nil, "defensiveArmies")
end

function SetupHelias()
	if not IsExisting("posP7Outpost") then
		SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity, 23845, 46925, 0, 7), "posP7Outpost")
--		Message("recreate p7outpos!")	--#
	end
	if not IsExisting("posP7") then
		SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity, 4255, 32923, 0, 7), "posP7")
--		Message("recreate p7pos!")	--#
	end
	MapEditor_SetupAI(7,3,Mapsize,3,"P7HQ",3,0)
	MapEditor_Armies[7].defensiveArmies.strength = round(12/gvDiffLVL)
	MapEditor_Armies[7].offensiveArmies.strength = round(50/gvDiffLVL)
	SetupPlayerAi(7, {
		serfLimit = round(6/gvDiffLVL),
		extracting = 0,
		constructing = true,
		repairing = true,
		rebuild = {delay = round(10*gvDiffLVL), randomTime = 1}
	})
	ConnectLeaderWithArmy(GetID("Helias"), nil, "defensiveArmies")
	--
	local army = {}
	army.id = 2
	army.player = 7
	army.spawnPos = GetPosition("posP7Silvermine")
	army.position = GetPosition("posP7Silvermine")
	army.spawnGenerator = "P7OuterRealm"
	army.strength = round(12/gvDiffLVL)
	army.spawnTypes = { {Entities.PU_LeaderBow4, 12}, {Entities.PU_LeaderSword4, 12}, {Entities.PU_LeaderPoleArm4, 12}, {Entities.PU_LeaderCavalry2, 6}, {Entities.PV_Cannon5, 0} }
	army.endless = true
	army.rodeLength = 7500
	army.respawnTime = round(20*gvDiffLVL)
	army.maxSpawnAmount = 2
	army.refresh = true

	SetupArmy(army)
	SetupAITroopSpawnGenerator("Helias_Army3", army)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmy", 1, {}, {army.player, army.id, army.spawnGenerator})
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SetupDiplomacy()

	RenamePlayer(1, "Kerberos", true)
	RenamePlayer(2, "Mary De Mortfichet", true)

	-- Spieler 1 und 2 verbündet
	SetFriendly(1, 2)

	local i, j
	for i = 1, 2 do
		for j = 3, 7 do
			SetHostile(i, j)
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function Intro()

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= col.orange.."Missionsbeschreibung",
        text	= col.gray.."Kerberos und Mary befinden sich auf einem gemeinsamen Rachefeldzug gegen Darios Freunde. @cr @cr @color:150,150,150 (Weiter mit Esc)"
    }
    AP{
        title	= col.orange.."Missionsbeschreibung",
        text	= col.gray.."Ari, Erec, Helias, Pilgrim und Salim gilt es dazu zu besiegen. @cr @cr Viel Erfolg! @cr @cr @color:150,150,150 (Weiter mit Esc)"
    }
    StartBriefing(briefing)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitFreeCamera()
	Camera.RotSetFlipBack(0)		-- free rotation
	Camera.RotSetAngle(-45)			-- standard value	--> without this command the map would start with the last used camera angle! (as flip back is turned off)
	Input.KeyBindDown(Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2)

	New_Online_Help_Button()	-- restore camera angle
	XGUIEng.TransferMaterials( "Scout_UseBinocular", "OnlineHelpButton" )
end

function New_Online_Help_Button()

	GUIAction_OnlineHelp = function()
		-- restore camera angle
		Camera.RotSetAngle(-45)
	end

	GUITooltip_Generic_Orig_HelpButton = GUITooltip_Generic
	GUITooltip_Generic = function(a)
		if a == "MenuMap/OnlineHelp" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, col.gray.."Kamera zurücksetzen"..col.ligreen.."@cr Klickt hier um den Standard Kamerawinkel einzustellen."..
			" @cr Ihr könnt die Kamera jederzeit frei drehen, um im Gefecht alles im Blick zu behalten. Anschließend könnt Ihr die Kameraeinstellung zurücksetzen.")
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, col.beig.."Taste: [Shift + C]")
		else
			GUITooltip_Generic_Orig_HelpButton(a)
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
function InitPlayerQuest1()
	local tribute =  {playerId = 8, text = "", cost = {Gold = 0}, Callback = AddQuest1ForPlayer1}
	TributQuest1P1 = AddTribute(tribute)

	local tribute2 =  {playerId = 8, text = "", cost = {Gold = 0}, Callback = AddQuest1ForPlayer2}
	TributQuest1P2 = AddTribute(tribute2)
end

function TributeForQuest1()
	GUI.PayTribute(8, TributQuest1P1)
	GUI.PayTribute(8, TributQuest1P2)
	Message("Schaut in Euer Auftragsbuch!")
	Sound.PlayGUISound(Sounds.VoicesMentor_QUEST_NewQuest_rnd_02, 100)
end

function AddQuest1ForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Aufgabe 1","Besiegt zunächst Ari und zerstört ihre Burg! Sie sollte nur geringfügig befestigt sein...",1)
end

function AddQuest1ForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Aufgabe 1","Besiegt zunächst Ari und zerstört ihre Burg! Sie sollte nur geringfügig befestigt sein...",1)
end

function InitPlayerQuest2()
	Logic.SetQuestType(1, 1, MAINQUEST_CLOSED, 0)
	Logic.SetQuestType(2, 2, MAINQUEST_CLOSED, 0)
	Logic.AddQuest(1,3,MAINQUEST_OPEN,"Aufgabe 2","Besiegt nun Erec und zerstört seine Burg! Achtet dabei auf seine starken Schwertkämpfer.",1)
	Logic.AddQuest(2,4,MAINQUEST_OPEN,"Aufgabe 2","Besiegt nun Erec und zerstört seine Burg! Achtet dabei auf seine starken Schwertkämpfer.",1)
	Sound.PlayGUISound(Sounds.VoicesMentor_QUEST_NewQuest_rnd_02, 100)
end

function InitPlayerQuest3()
	Logic.SetQuestType(1, 3, MAINQUEST_CLOSED, 0)
	Logic.SetQuestType(2, 4, MAINQUEST_CLOSED, 0)
	Logic.AddQuest(1,5,MAINQUEST_OPEN,"Aufgabe 3","Der nächste Gegner ist Helias. Besiegt Ihn und seine Festung auf dem Berg.",1)
	Logic.AddQuest(2,6,MAINQUEST_OPEN,"Aufgabe 3","Der nächste Gegner ist Helias. Besiegt Ihn und seine Festung auf dem Berg.",1)
	Sound.PlayGUISound(Sounds.VoicesMentor_QUEST_NewQuest_rnd_02, 100)
end

function InitPlayerQuest4()
	Logic.SetQuestType(1, 5, MAINQUEST_CLOSED, 0)
	Logic.SetQuestType(2, 6, MAINQUEST_CLOSED, 0)
	Logic.AddQuest(1,7,MAINQUEST_OPEN,"Aufgabe 4","Zu guter Letzt müsst Ihr Euch gegen Pilgrm und Salim behaupten. Lasst Euch nicht von deren großen Kanonen in die Flucht schlagen...",1)
	Logic.AddQuest(2,8,MAINQUEST_OPEN,"Aufgabe 4","Zu guter Letzt müsst Ihr Euch gegen Pilgrm und Salim behaupten. Lasst Euch nicht von deren großen Kanonen in die Flucht schlagen...",1)
	Sound.PlayGUISound(Sounds.VoicesMentor_QUEST_NewQuest_rnd_02, 100)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitGroups()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function Mission_InitTechnologies()
    -- first disable HQ upgrade
	local i
	for i = 1,2 do
		--ForbidTechnology(Technologies.MU_LeaderSword, i)
		--ForbidTechnology(Technologies.T_UpgradeSword1, i)
		ForbidTechnology(Technologies.UP2_Headquarter, i)
		ForbidTechnology(Technologies.B_Beautification01, i)	-- statue of dario
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Set local resources
function Mission_InitLocalResources()
--	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= dekaround(1000*gvDiffLVL)
	local InitClayRaw	= dekaround(1500*gvDiffLVL)
	local InitWoodRaw	= dekaround(1500*gvDiffLVL)
	local InitStoneRaw	= dekaround(1000*gvDiffLVL)
	local InitIronRaw	= dekaround(1000*gvDiffLVL)
	local InitSulfurRaw	= dekaround(500*gvDiffLVL)

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw, InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)
        ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
        ResearchTechnology(Technologies.GT_Construction, i) --> Konstruktion
        ResearchTechnology(Technologies.GT_Literacy, i) --> Bildung
		--#
--		ResearchTechnology(Technologies.GT_GearWheel, i)
--		ResearchTechnology(Technologies.GT_Trading, i)
--		ResearchTechnology(Technologies.GT_Printing, i)
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_Victory()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") and IsDead("P7HQ") then
		StartCountdown(5, Victory, false)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DestroyHQ3()	-- Erec

	if IsDead("P3HQ") then
		Msg(col.ligreen.."Erecs Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
		InitPlayerQuest3()
		SetupHelias()
		StartSimpleJob("SJ_DestroyHQ7")
		ReplaceEntity("gate_helias", Entities.XD_WallStraightGate)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DestroyHQ7()	-- Helias

	if IsDead("P7HQ") then
		Msg(col.ligreen.."Helias Burg wurde zerstört!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
		InitPlayerQuest4()
		SetupSalim()
		SetupPilgrim()
		StartSimpleJob("SJ_DestroyHQ45")
		ReplaceEntity("gate_pilgrim", Entities.XD_WallStraightGate)
		TributeDestroyRockKerb()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function TributeDestroyRockKerb()
	local tribute =  {playerId = 1, text = "Zahlt 1000 Taler, um den großen Felsen nördlich der Ruinen zu sprengen", cost = {Gold = 1000}, Callback = TributeRockPaid}
	AddTribute(tribute)
	Msg(col.liyel.."Spieler 1 kann nun den großen Felsen nördlich der Ruinen sprengen! (Tributemenü)")
end

function TributeRockPaid()
	ReplaceEntity("rockKerb", Entities.XD_Bomb1)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DestroyHQ6()	-- Ari

	if IsDead("P6HQ") then
		Msg(col.ligreen.."Aris Burg wurde zerstört! Ihr erhaltet nun weitere Technologien!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
		AllowTechnology(Technologies.UP2_Headquarter, 1)
		AllowTechnology(Technologies.UP2_Headquarter, 2)
		--AllowTechnology(Technologies.MU_LeaderSword, 1)
		--AllowTechnology(Technologies.MU_LeaderSword, 2)
		--AllowTechnology(Technologies.T_UpgradeSword1, 1)
		--AllowTechnology(Technologies.T_UpgradeSword1, 2)

		-- new: Erec
		InitPlayerQuest2()
		SetupErec()
		ReplaceEntity("gate1P3", Entities.XD_PalisadeGate2)
		ReplaceEntity("gate2P3", Entities.XD_PalisadeGate2)
		StartSimpleJob("SJ_DestroyHQ3")
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DestroyHQ45()	-- Pilgrim + Salim

	if IsDead("P4HQ") and IsDead("P5HQ") then
		Msg(col.ligreen.."Pilgrim und Salim sind besiegt!")
		Sound.PlayGUISound(Sounds.fanfare, 80)
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

function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Comforts etc. --------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function Msg(_text, _duration)

	if _duration == nil then
		_duration = 8
	end

	GUI.AddNote(_text, _duration)

end

function RenamePlayer(_pID, _pName, _colorFlag)

	gvMission.PlayerNames[_pID] = _pName
	local R, G, B = GUI.GetPlayerColor( _pID )
	if _colorFlag then
		SetPlayerName(_pID, "@color:"..R..","..G..","..B.." ".._pName)
	end
--	Logic.PlayerSetPlayerColor(_pID, R, G, B)	-- for KI (statistics)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function HackAutoRefill_v2()
	--XGUIEng.SetWidgetPosition(XGUIEng.GetWidgetID("Activate_RecruitSingleLeader"), 44, 4)	--74,4

	GUI.DeactivateAutoFillAtBarracks = function(_entity)
		-- autofill nearby units
		local _PlayerID = GetPlayer(_entity)
		local pos = GetPosition(_entity)
		-- range 2000 is the homerange for (all?) leaders
		for LeaderID in S5Hook.EntityIterator(Predicate.OfPlayer(_PlayerID), Predicate.InCircle(pos.X, pos.Y, 2000)) do
			if Logic.IsLeader(LeaderID) == 1 and Logic.IsHero(LeaderID) == 0 then
				if Logic.LeaderGetBarrack(LeaderID) == 0 then
					MilitaryBuildingID = Logic.LeaderGetNearbyBarracks(LeaderID)
					--if MilitaryBuildingID ~= 0 then
					if MilitaryBuildingID == _entity then	-- only recruit at this building
						UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory(LeaderID)
						Soldiers = Logic.LeaderGetNumberOfSoldiers(LeaderID)
						MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(LeaderID)
						if Soldiers < MaxSoldiers then
							BuyAmount = MaxSoldiers - Soldiers
							for i = 1, BuyAmount do
								if (Logic.GetPlayerAttractionUsage(_PlayerID) < Logic.GetPlayerAttractionLimit(_PlayerID)) then
									local CostTable = {}
									Logic.FillSoldierCostsTable(_PlayerID, UpgradeCategory, CostTable)
									if HasPlayerEnoughResources(_PlayerID, CostTable) == true then	-- costs are ok
										--Message("buy id: "..LeaderID)
										GUI.BuySoldier(LeaderID)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	GUITooltip_Generic_Orig = GUITooltip_Generic
	GUITooltip_Generic = function(a)
		GUITooltip_Generic_Orig(a)

		if a == "MenuBuildingGeneric/RecruitGroups" then
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, col.gray.."Alle Truppen auffüllen @cr "..col.w.."Nahe Hauptmänner nehmen selbstständig neue Soldaten in ihre Gruppe auf, sofern genügend Plätze und Rohstoffe vorhanden sind.")
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "")
		end
	end
end

-- bug fix: from Tools.HasPlayerEnoughResources but uses wood instead of silver!
function HasPlayerEnoughResources(_PlayerID, _Costs)

	-- Get resources
	local Wood = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Wood ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.WoodRaw)
	local Gold   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Gold ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.GoldRaw)
	local Iron   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Iron ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.IronRaw)
	local Stone  = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Stone ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.StoneRaw)
	local Sulfur = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Sulfur ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.SulfurRaw)

	-- Enough
	return (Wood >= _Costs[ResourceType.Wood]) and (Gold >= _Costs[ResourceType.Gold]) and (Iron >= _Costs[ResourceType.Iron])
	and (Stone >= _Costs[ResourceType.Stone]) and (Sulfur >= _Costs[ResourceType.Sulfur])

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- SP only --

function ActivateSingleplayerMode()

	Message(col.red.."diese karte sollte nur mit 2 spielern gestartet werden!")
	--Logic.PlayerSetGameStateToLost(gvMission.PlayerID) -- #TODO: use this?
	NewOnGameLoaded()

end

function Trade_TributePaid_Action()	-- FIX: close tribute menu after selecting an option/trade
	GUIAction_ToggleMenu( gvGUI_WidgetID.TradeWindow, 0)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function GetHealth( _entity )
    local entityID = GetEntityId( _entity )
    if not Tools.IsEntityAlive( entityID ) then
        return 0
    end
    local MaxHealth = Logic.GetEntityMaxHealth( entityID )
    local Health = Logic.GetEntityHealth( entityID )
    return ( Health / MaxHealth ) * 100
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function HackUpgradeHints()
	GameCallback_OnBuildingUpgradeCompleteOrig = GameCallback_OnBuildingUpgradeComplete
	GameCallback_OnBuildingUpgradeComplete = function(_oldID, _newID)
		GameCallback_OnBuildingUpgradeCompleteOrig(_oldID, _newID)
		if GetPlayer(_newID) == gvMission.PlayerID then
			local _position = GetPosition(_newID)
			GUI.ScriptSignal(_position.X, _position.Y, 1)	-- blue
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function NewOnGameLoaded()
	Mission_OnSaveGameLoaded_Orig = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_Orig()

		Display.SetPlayerColorMapping(1, ROBBERS_COLOR)
		Display.SetPlayerColorMapping(2, NEPHILIM_COLOR)
		Display.SetPlayerColorMapping(7, EVIL_GOVERNOR_COLOR)

		-- autofill
		GUI.DeactivateAutoFillAtBarracks = function(_entity)
			-- toggle autofill
			gvMission.Autofill[gvMission.PlayerID] = not gvMission.Autofill[gvMission.PlayerID]
		end

		Input.KeyBindDown(Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2)
		Input.KeyBindDown(Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2)

	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function ToggleHeroDisplay()
	gvMission.UseHeroHealthDisplay = not gvMission.UseHeroHealthDisplay
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function HackHeroHealthDisplay()

	GUIUpdate_HeroButtonOrig = GUIUpdate_HeroButton

	GUIUpdate_HeroButton = function()

		if not gvMission.UseHeroHealthDisplay then
			GUIUpdate_HeroButtonOrig()
			return
		end

		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local EntityID = XGUIEng.GetBaseWidgetUserVariable(CurrentWidgetID, 0)
		local health = GetHealth(EntityID)
		local R, G, B
		B = 0
		if health == 100 then
			R, G, B = 255, 255, 255
		elseif health > 50 then
			G = 255
			R = 255 - health * 5.1
		else
			R = 255
			G = health * 5.1
		end

		local SourceButton
		if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero1) == 1 then
			SourceButton = "FindHeroSource1"
			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)

			if Logic.SentinelGetUrgency(EntityID) == 1 then

			if gvGUI.DarioCounter < 50 then

				XGUIEng.SetMaterialColor(CurrentWidgetID,0, 100,100,200,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID,1, 100,100,200,255)
				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end
			if gvGUI.DarioCounter >= 50 then
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)

				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end
			if gvGUI.DarioCounter == 100 then
				gvGUI.DarioCounter= 0
			end
			else
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)
			end

		else

			if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero2) == 1 then
				SourceButton = "FindHeroSource2"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero3) == 1 then
				SourceButton = "FindHeroSource3"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero4) == 1 then
				SourceButton = "FindHeroSource4"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero5) == 1 then
				SourceButton = "FindHeroSource5"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero6) == 1 then
				SourceButton = "FindHeroSource6"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_BlackKnight then
				SourceButton = "FindHeroSource7"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Mary_de_Mortfichet then
				SourceButton = "FindHeroSource8"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Barbarian_Hero then
				SourceButton = "FindHeroSource9"

			--AddOn
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero10) == 1 then
				SourceButton = "FindHeroSource10"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero11) == 1 then
				SourceButton = "FindHeroSource11"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Evil_Queen then
				SourceButton = "FindHeroSource12"

			else
				SourceButton = "FindHeroSource9"
			end

			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)

			XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
			XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)

		end

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

 