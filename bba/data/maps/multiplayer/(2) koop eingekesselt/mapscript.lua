-- Mapname: (2) Eingekesselt
-- Author: P4F
-- 12/02/2019
-- Version: 1.2 (Comforts/Tools -> external)

HeroTable = {}	-- for NPCs

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Eingekesselt "
gvMapVersion = " v1.3 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	InitColors()
    Mission_InitWeatherGfxSets()
    TagNachtZyklus(24,1,1,-2,1)
	StartTechnologies()

    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player
	ActivateBriefingsExpansion()

	_GlobalCounter = 0
	InitTechTables()
	StartSimpleJob("SJ_VictoryJob")
	StartSimpleJob("SJ_DestroyHQ3Message")
	StartSimpleJob("SJ_DestroyHQ4Message")
	StartSimpleJob("SJ_DestroyHQ5Message")
	StartSimpleJob("SJ_DestroyHQ6Message")
	Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
	Logic.SetShareExplorationWithPlayerFlag(2, 1, 1)

	Display.SetPlayerColorMapping(3, KERBEROS_COLOR)
	Display.SetPlayerColorMapping(4, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(5, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(6, EVIL_GOVERNOR_COLOR)
	Display.SetPlayerColorMapping(7, FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(8, NPC_COLOR)

	CreateWoodPile("woodpile1", 10000)
	CreateWoodPile("woodpile2", 10000)

    if XNetwork.Manager_DoesExist() == 0 then
		Message(col.P4F.."Einzelspieler aktiviert!")

        for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )

		Logic.ChangeAllEntitiesPlayerID(2, PlayerID)

		Logic.ActivateUpdateOfExplorationForAllPlayers()
    end

    LocalMusic.UseSet = EUROPEMUSIC

	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")

	SetupDiplomacy()
	InitMainQuest()	-- with...

	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "EV_ON_ENTITY_CREATED", 1)

	StartSimpleJob("SJ_ControlNpc")	-- NPC for MP
	CreateNpcMP("npcChief", TalkToChief)
	CreateNpcMP("npcHermit", TalkToHermit)
	CreateNpcMP("npcThief", TalkToThief)

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

	-- merc tents
	Logic.AddMercenaryOffer(GetEntityId("merc1"), Entities.PU_LeaderBow3, round(2*gvDiffLVL), ResourceType.Gold, dekaround(700/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc1"), Entities.PU_LeaderSword3, round(2*gvDiffLVL), ResourceType.Gold, dekaround(400/gvDiffLVL), ResourceType.Iron, dekaround(300/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc1"), Entities.PU_Scout, round(1*gvDiffLVL), ResourceType.Gold, dekaround(300/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc2"), Entities.PU_LeaderBow3, round(2*gvDiffLVL), ResourceType.Gold, dekaround(700/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc2"), Entities.PU_LeaderSword3, round(2*gvDiffLVL), ResourceType.Gold, dekaround(400/gvDiffLVL), ResourceType.Iron, dekaround(300/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc2"), Entities.PU_Scout, round(1*gvDiffLVL), ResourceType.Gold, dekaround(300/gvDiffLVL))

	CAMP2TRIBUTEID = AddTribute({ playerId = 1, text = "Zahlt " .. dekaround(1500/gvDiffLVL) .. " Taler an die Wegelagerer, dass sie Euch gegen Lord Bennet unterstützen.", cost = { Gold = dekaround(1500/gvDiffLVL) }, Callback = Camp2Paid })

	--Chests
	InitChests()

	-- Gegner
	SetupEnemies()
	StartSimpleJob("SJ_Timeline")

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function InitColors()
	col = {}
	-- Rot,Grün,Blau
	col.w		= " @color:255,255,255 "
	col.gruen	= " @color:0,255,0 "
	col.blau	= " @color:20,20,240 "
	col.P4F		= " @color:166,212,35 "
	col.grau	= " @color:180,180,180 "
	col.dgrau	= " @color:120,120,120 "
	col.beig	= " @color:240,220,200 "
	col.gelb 	= " @color:255,200,0 "
	col.hgelb 	= " @color:238,221,130 "
	col.orange 	= " @color:255,127,0 "
	col.rot		= " @color:255,0,0 "
	col.hgruen	= " @color:173,255,47 "
	col.hblau 	= " @color:0,255,255 "
	col.pink	= " @color:200,100,200 "
	col.transp	= " @color:0,0,0,0 "
	col.keyb	= " @color:220,220,150 "
	col.schwarz	= " @color:40,40,40 "
	col.blauFIX	= " @color:50,50,220 "
	col.gruenFIX= " @color:0,200,0 "
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function EV_ON_ENTITY_CREATED()
	local ent_ID = Event.GetEntityID()
	local ent_typ = Logic.GetEntityTypeName(Logic.GetEntityType(ent_ID))
	local ent_P = Logic.EntityGetPlayer(ent_ID)
	local ent_pos = GetPosition(ent_ID)

	if	ent_typ == "XD_DroppedSword" or
		ent_typ == "XD_DroppedBow" or
		ent_typ == "XD_DroppedAxeShield" or
		ent_typ == "XD_SoldierRifle1_Rifle" or
		ent_typ == "XD_SoldierRifle2_Rifle" or
		ent_typ == "XD_DroppedShield" or
		ent_typ == "XD_DroppedSwordShield" or
		ent_typ == "XD_DroppedPoleArm" then

		local _rnd = math.random()
			if _rnd > 0.3 then
				DestroyEntity(ent_ID)
			end

	elseif ent_typ == "XD_TreeStump1" then
		if math.random(1, 5) > 1 then
			local plants = {"XD_Bush1", "XD_Bush2", "XD_Bush3", "XD_Bush4", "XD_Plant1", "XD_Plant4", "XD_Flower1", "XD_Flower2", "XD_Flower3", "XD_Flower4", "XD_Flower5", "XD_Driftwood1", "XD_Driftwood2"}
			local newEnt = Entities[plants[math.random(1, table.getn(plants))]]
			Logic.CreateEntity(newEnt, ent_pos.X, ent_pos.Y, math.random(1, 360), 8)
			DestroyEntity(ent_ID)
		end

	end

	if ent_P == 1 or ent_P == 2 then
		--[[
		if ent_typ == "PU_Serf" then
			table.insert(SerfTable, ent_ID)
		elseif ent_typ == "PV_Cannon1" or ent_typ == "PV_Cannon2" or ent_typ == "PV_Cannon3" or ent_typ == "PV_Cannon4" then
			table.insert(CannonTable, ent_ID)
		end
		--]]

		if Logic.IsHero(ent_ID) == 1 then
			table.insert(HeroTable, ent_ID)
		end

		-- todo debug
		--MakeInvulnerable(ent_ID)
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SetupEnemies()


	local camp1 = {
		-- notwendige Angaben
		player = 7,
		id = 0,
		endless = true,
		position = GetPosition("c1s1"),
		spawnPos = GetPosition("c1s1"),
		spawnGenerator = "camp1HQ",
		respawnTime = round(45*gvDiffLVL),
		spawnTypes = {{Entities.CU_BanditLeaderSword1, 10}, {Entities.CU_BanditLeaderBow1, 10}},	-- erlaubte Truppen
		strength = round(8/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		rodeLength = 2700,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
	}
	SetupArmy(camp1)
	SetupAITroopSpawnGenerator("camp1", camp1)
	StartSimpleJob("ControlCamp1")


	local camp2 = {
		-- notwendige Angaben
		player = 7,
		id = 1,
		endless = true,
		position = GetPosition("c2s1"),
		spawnPos = GetPosition("c2s1"),
		spawnGenerator = "camp2HQ",
		spawnTypes = {{Entities.CU_BanditLeaderSword1, 10}, {Entities.CU_BanditLeaderBow1, 10}},	-- erlaubte Truppen
		strength = round(10/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		respawnTime = round(30*gvDiffLVL),
		rodeLength = 2200,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
	}
	SetupArmy(camp2)
	SetupAITroopSpawnGenerator("camp2", camp2)
	StartSimpleJob("ControlCamp2")

	local camp3 = {
		-- notwendige Angaben
		player = 7,
		id = 2,
		position = GetPosition("c3s1"),
		spawnPos = GetPosition("c3s1"),
		spawnGenerator = "camp3HQ",
		spawnTypes = {{Entities.CU_BanditLeaderSword1, 10}, {Entities.CU_BanditLeaderBow1, 10}},	-- erlaubte Truppen
		strength = round(8/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		respawnTime = round(30*gvDiffLVL),
		rodeLength = 2700,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
	}
	SetupArmy(camp3)
	SetupAITroopSpawnGenerator("camp3", camp3)
	StartSimpleJob("ControlCamp3")

	MapEditor_SetupAI(3, round(3-gvDiffLVL), 9000, 1, "P3HQ", 3, 15*60*gvDiffLVL)
	MapEditor_SetupAI(4, 1, 9500, 1, "P4HQ", 3, 18*60*gvDiffLVL)
	MapEditor_SetupAI(5, round(3-gvDiffLVL), 9500, 1, "P5HQ", 3, 18*60*gvDiffLVL)
	MapEditor_SetupAI(6, round(4-gvDiffLVL), 15000, 2, "P6HQ", 3, 24*60*gvDiffLVL)

end
function ControlCamp1()
	if not IsDead(ArmyTable[7][1]) then
		Defend(ArmyTable[7][1])
	end
end
function ControlCamp2()
	if not IsDead(ArmyTable[7][2]) then
		Defend(ArmyTable[7][2])
	end
end
function ControlCamp3()
	if not IsDead(ArmyTable[7][3]) then
		Defend(ArmyTable[7][3])
	end
end
function CampDestroyedMessage()
	Message(col.gruenFIX.. "Ein gegnerisches Lager wurde zerstört!")
end

function Camp2DestroyedMessage()
	Message(col.gruenFIX.. "Ein gegnerisches Lager wurde zerstört!")
	SetNeutral(3, 7)
	Logic.RemoveTribute(1, CAMP2TRIBUTEID)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitMainQuest()
	local tribute =  {}
	tribute.playerId = 8
	tribute.text = " "
	tribute.cost = { Gold = 0 }
	tribute.Callback = AddMainquestForPlayer1
	TributMainquestP1 = AddTribute(tribute)

	local tribute2 =  {}
	tribute2.playerId = 8
	tribute2.text = " "
	tribute2.cost = { Gold = 0 }
	tribute2.Callback = AddMainquestForPlayer2
	TributMainquestP2 = AddTribute(tribute2)

	StartCountdown(4, TributeForMainquest, false)
end

function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
end

function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN, "Hauptaufgabe", "Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr Besiegt die Truppen dieser blutdurstigen Lords und zerstört ihre Burgen!"..
		" @cr @cr Hinweis: Es gibt Siedler, die Euch helfen, sofern Ihr ihnen genug zahlt...", 1)
end

function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN, "Hauptaufgabe", "Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr Besiegt die Truppen dieser blutdurstigen Lords und zerstört ihre Burgen!"..
		" @cr @cr Hinweis: Es gibt Siedler, die Euch helfen, sofern Ihr ihnen genug zahlt...", 1)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SetupDiplomacy()

	-- Namen, Diplomatie
	--SetPlayerName(1,"")
	--SetPlayerName(2,"")
	SetPlayerName(3,"Lord Bennet")
	SetPlayerName(4,"Lord Karreg")
	SetPlayerName(5,"Lord Gwen")
	SetPlayerName(6,"Lord Eisenhard")
	SetPlayerName(7, "Wegelagerer")
	--SetPlayerName(8, "(neutral)")

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

	-- Wegelagerer
	SetHostile(1, 7)
	SetHostile(2, 7)
	SetNeutral(3, 7)

	UserTool_GetPlayerNameORIG = UserTool_GetPlayerName
	function UserTool_GetPlayerName(_PlayerID)
		if _PlayerID == 3 then
			return "Lord Bennet"
		elseif _PlayerID == 4 then
			return "Lord Karreg"
		elseif _PlayerID == 5 then
			return "Lord Gwen"
		elseif _PlayerID == 6 then
			return "Lord Eisenhard"
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

	if _GlobalCounter == 60 then	-- 1

	elseif _GlobalCounter == 607 then	-- 10+
		if IsAlive("P6HQ") then UpgradeBuilding("P6HQ") end

	elseif _GlobalCounter == 633 then	-- 10+
		if IsAlive("P3HQ") then UpgradeBuilding("P3HQ") end

	elseif _GlobalCounter == 675 then	-- 11+
		if IsAlive("P4HQ") then UpgradeBuilding("P4HQ") end

	elseif _GlobalCounter == 730 then	-- 12+
		if IsAlive("P5HQ") then UpgradeBuilding("P5HQ") end

	elseif _GlobalCounter == round(20*60*gvDiffLVL) then	-- 20
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 6)

	elseif _GlobalCounter == round(21*60*gvDiffLVL) then	-- 21
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 3)

	elseif _GlobalCounter == round(22*60*gvDiffLVL) then	-- 22
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 5)

	elseif _GlobalCounter == 32*60 then	-- 52
		if IsAlive("P6HQ") then UpgradeBuilding("P6HQ") end

	elseif _GlobalCounter == 37*60 then	-- 53
		if IsAlive("P3HQ") then UpgradeBuilding("P3HQ") end

	elseif _GlobalCounter == round(40*60*gvDiffLVL) then	-- 32
		for p = 3, 6 do
			AI_ResearchTechnologies(p, _TechTableLow)
		end
		for p = 3, 5 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + 2
			MapEditor_Armies[p].offensiveArmies.rodeLength = MapEditor_Armies[p].offensiveArmies.rodeLength * 1.5
		end

	elseif _GlobalCounter == round(53*60*gvDiffLVL) then	-- 43
		for p = 3, 6 do
			Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, p)
			Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, p)
			AI_ResearchTechnologies(p, _TechTableMedium)
		end
		for p = 3, 5 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(5/gvDiffLVL)
			MapEditor_Armies[p].offensiveArmies.rodeLength = MapEditor_Armies[p].offensiveArmies.rodeLength * 2
		end

	elseif _GlobalCounter == round(54*60*gvDiffLVL) then	-- 54
		if IsAlive("P4HQ") then UpgradeBuilding("P4HQ") end
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 6)

	elseif _GlobalCounter == round(55*60*gvDiffLVL) then	-- 55
		if IsAlive("P5HQ") then UpgradeBuilding("P5HQ") end
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 3)

	elseif _GlobalCounter == round(59*60*gvDiffLVL) then	-- 59
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, 5)

	elseif _GlobalCounter == round(68*60*gvDiffLVL) then	-- 68
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 6)

		-- increase resources for AI
		for p = 3, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(10/gvDiffLVL)
			MapEditor_Armies[p].offensiveArmies.rodeLength = MapEditor_Armies[p].offensiveArmies.rodeLength * 2
		end

	elseif _GlobalCounter == round(72*60*gvDiffLVL) then	-- 72
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 5)
		for p = 3, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(8/gvDiffLVL)
		end

	elseif _GlobalCounter == round(81*60*gvDiffLVL) then	-- 81
		for p = 3, 6 do
			Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, p)
			Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, p)
			AI_ResearchTechnologies(p, _TechTableHigh)
		end

	elseif _GlobalCounter == round(93*60*gvDiffLVL) then	-- 93
		for p = 3, 6 do
			Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, p)
			Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, p)
		end

	elseif _GlobalCounter == round(100*60*gvDiffLVL) then	-- 100
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 6)
		-- resource refresh rates
		for p = 3, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(8/gvDiffLVL)
		end

	elseif _GlobalCounter == round(106*60*gvDiffLVL) then	-- 106
		for p = 3, 6 do
			Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, p)
			Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, p)
			AI_ResearchTechnologies(p, _TechTableRifle)
		end

	elseif _GlobalCounter == round(111*60*gvDiffLVL) then	-- 111
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 6)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 6)

	elseif _GlobalCounter == round(117*60*gvDiffLVL) then	-- 117
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 5)
		for p = 3, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(10/gvDiffLVL)
			MapEditor_Armies[p].offensiveArmies.rodeLength = Logic.WorldGetSize()
		end

	elseif _GlobalCounter == round(120*60*gvDiffLVL) then	-- 120
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 5)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 5)

		-- Timeline beenden, sobald alle Events abgearbeitet sind
		return true

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- AI: einige Technologien erforschen
function AI_ResearchTechnologies(_AI, _TechTable)
local i
	for i = 1, table.getn(_TechTable) do
		ResearchTechnology(_TechTable[i], _AI)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitWeatherGfxSets()
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
	local InitGoldRaw	= 800
	local InitClayRaw	= 1000
	local InitWoodRaw	= 1000
	local InitStoneRaw	= 800
	local InitIronRaw	= 800
	local InitSulfurRaw	= 500

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)

--        ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
        ResearchTechnology(Technologies.GT_Construction, i) --> Konstruktion
		--ResearchTechnology(Technologies.T_TownGuard, i)	-- useless anyway
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DestroyHQ3Message()

	if IsDead("P3HQ") then
		Message(col.hgruen.. "Lord Bennets Burg wurde zerstört!")
		SetPlayerName(3,"Lord Bennet (besiegt)")
		Sound.PlayGUISound(Sounds.fanfare,70)
		CreateChestMP("chHQ3", CC_HQdest)
		return true
	end
end

function SJ_DestroyHQ4Message()

	if IsDead("P4HQ") then
		Message(col.hgruen.. "Lord Karregs Burg wurde zerstört!")
		SetPlayerName(4,"Lord Karreg (besiegt)")
		Sound.PlayGUISound(Sounds.fanfare,70)
		CreateChestMP("chHQ4", CC_HQdest)
		return true
	end
end

function SJ_DestroyHQ5Message()

	if IsDead("P5HQ") then
		Message(col.hgruen.. "Lord Gwens Burg wurde zerstört!")
		SetPlayerName(5,"Lord Gwen (besiegt)")
		Sound.PlayGUISound(Sounds.fanfare,70)
		CreateChestMP("chHQ5", CC_HQdest)
		return true
	end
end

function SJ_DestroyHQ6Message()

	if IsDead("P6HQ") then
		Message(col.hgruen.. "Lord Eisenhards Burg wurde zerstört!")
		SetPlayerName(6,"Lord Eisenhard (besiegt)")
		Sound.PlayGUISound(Sounds.fanfare,70)
		CreateChestMP("chHQ6", CC_HQdest)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function SJ_DefeatP1()
	if IsDead("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
		MultiplayerTools.RemoveAllPlayerEntities( 1 )
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("P2HQ") then
		Logic.PlayerSetGameStateToLost(2)
		MultiplayerTools.RemoveAllPlayerEntities( 2 )
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitChests()
	for i = 1, 8 do
		CreateChestMP("ch"..i, CC_Gold)
	end
	--for j = 3, 6 do
		--CreateChestMP("chHQ"..i, CC_HQdest)
	--end

	StartSimpleJob("SJ_ControlChests")
end

function CC_Gold()	-- add a random gold value
	local g = round(math.random(13, 22) * 50 * gvDiffLVL)
	Message(col.beig.. "Ihr habt in dieser truhe "..g.." Gold gefunden!")	-- per player
	AddGold(1, g)
	AddGold(2, g)
end

function CC_HQdest()
	local g = math.random(5, 10) * 250
	local w = math.random(6, 12) * 250
	local s = math.random(4, 11) * 250
	local i = math.random(4, 11) * 250
	Message(col.beig.. "Ihr habt eine Schatztruhe erbeutet! Ihr erhaltet:")
	Message(col.beig.. g .. " Taler")
	AddGold(1, g)
	AddGold(2, g)
	Message(col.beig.. g .. " Holz")
	AddWood(1, w)
	AddWood(2, w)
	Message(col.beig.. s .. " Stein")
	AddStone(1, s)
	AddStone(2, s)
	Message(col.beig.. i .. " Eisen")
	AddIron(1, i)
	AddIron(2, i)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function CreateNpcMP(_name, _callback)
	if npcTable == nil then npcTable = {} end
	table.insert(npcTable, { name = _name, callback = _callback })
	EnableNpcMarker(_name)
end

function SJ_ControlNpc()
	for pid = 1,2 do
		for index = 1, table.getn(npcTable) do
			if npcTable[index] then
				--local pos = GetPosition(npcTable[index].name)
				for i = 1, table.getn(HeroTable) do
					if IsNear(HeroTable[i], npcTable[index].name, 500) then
						npcTable[index].callback()
						DisableNpcMarker(npcTable[index].name)
						table.remove(npcTable, index)
						break
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function TalkToChief()
	Message(col.hblau.. "Siedler: Ich verkaufe Euch dieses Dorfzentrum. Doch gebt Acht, Wegelagerer lagern nicht weit von hier!")
	AddTribute({ playerId = 1, text = "Zahlt " .. dekaround(2000/gvDiffLVL) .. " Taler für das Dorfzentrum", cost = { Gold = dekaround(2000/gvDiffLVL) }, Callback = BuyVCe1 })
	local _position = GetPosition("VCe1")
	GUI.ScriptSignal(_position.X, _position.Y, 0)
end

function BuyVCe1()
	ChangePlayer("VCe1", 1)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function TalkToHermit()
	local player = 2
	if XNetwork.Manager_DoesExist() == 0 then player = 1 end
	Message(col.hblau.. "Siedler: Ich verkaufe Euch dieses Dorfzentrum. Doch gebt Acht, Wegelagerer lagern nicht weit von hier!")
	AddTribute({ playerId = player, text = "Zahlt " .. dekaround(2000/gvDiffLVL) .. " Taler für das Dorfzentrum", cost = { Gold = dekaround(2000/gvDiffLVL) }, Callback = BuyVCe2 })
	local _position = GetPosition("VCe2")
	GUI.ScriptSignal(_position.X, _position.Y, 0)
end

function BuyVCe2()
	local player = 2
	if XNetwork.Manager_DoesExist() == 0 then player = 1 end
	ChangePlayer("VCe2", player)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function TalkToThief()
	local player = 2
	if XNetwork.Manager_DoesExist() == 0 then player = 1 end
	Message(col.hblau.. "Spion: Ich biete Euch folgenden Deal an: Ihr gebt mir 5000 Taler und ich zeige Euch, was der gute Lord Eisenhard so treibt.")
	AddTribute({ playerId = player, text = "Zahlt 5000 Taler um Lord Eisenhard ausspionieren zu lassen", cost = { Gold = 5000 }, Callback = ThiefPaid })
	local _position = GetPosition("npcThief")
	GUI.ScriptSignal(_position.X, _position.Y, 0)
end

function ThiefPaid()
	Logic.SetShareExplorationWithPlayerFlag(1, 6, 1)
	Logic.SetShareExplorationWithPlayerFlag(2, 6, 1)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function Camp2Paid()
	SetHostile(3, 7)
	Message(col.orange.. "Wegelagerer: Wir werden damit zwar keine Freunde ... aber wir werden keinen Mann von diesem Bennet verschonen, der uns zu nahe kommt!")
	Sound.PlayGUISound(Sounds.fanfare, 50)
	local _position = GetPosition("camp2HQ")
	GUI.ScriptSignal(_position.X, _position.Y, 0)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Comforts etc. --------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
function CreateChestMP(_pos, _callback)
	if Chests == nil then Chests = {} end
	assert(type(_pos) == "string", "CreateChestMP: _pos must be a string")
	assert(IsDead("chest_".._pos), "CreateChestMP: a chest is already created there")
	assert(_callback ~= nil, "CreateChestMP: _callback is nil")
	local pos = GetPosition(_pos)
	SetEntityName(Logic.CreateEntity(Entities.XD_ChestClose, pos.X, pos.Y, 0, 8), "chest_".._pos)
	table.insert(Chests, { pos = _pos, callback = _callback })	-- pos is a string
end

function SJ_ControlChests()
	for pid = 1,2 do
		for index = 1, table.getn(Chests) do
			if Chests[index] then
				local pos = GetPosition(Chests[index].pos)
				local entities = {Logic.GetPlayerEntitiesInArea(pid, 0, pos.X, pos.Y, 350, 16)}
					for i = 2, table.getn(entities) do
					if Logic.IsHero(GetEntityId(entities[i])) == 1 then
						ReplaceEntity("chest_"..Chests[index].pos, Entities.XD_ChestOpen)
						Sound.PlayGUISound(Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_01, 90)
						Sound.PlayGUISound(Sounds.OnKlick_Select_erec, 70)
						--Sound.PlayGUISound(Sounds.OnKlick_PB_Residence1, 80)
						Chests[index].callback()
						table.remove(Chests, index)
						break
					end
				end
			end
		end
	end
end

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

function AreAllDead(_table)

	local n
	for n = 1, table.getn(_table) do
		if not IsDead(_table[n]) then
			return false
		end
	end

	return true
end

function GetRandomPositionNearby(_position, _range)	-- _pos may be string or pos or ID
	local position = {}
	if type(_position) == "string" or type(_position) == "number" then
		position = GetPosition(_position)
	else
		position = _position
	end
	local range = _range or 1000
	position.X = position.X + math.random(-range, range)
	position.Y = position.Y + math.random(-range, range)
	return position
end
