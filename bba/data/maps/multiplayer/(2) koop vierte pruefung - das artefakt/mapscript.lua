--------------------------------------------------------------------------------
-- MapName: (2) Vierte Prüfung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
sub_armies_aggressive = 0
main_armies_aggressive = 0
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Vierte Prüfung - Das Artefakt"
gvMapVersion = " v1.1 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- Include Cutscene control
	Script.Load("maps/externalmap/Cutscene_Control.lua")
	Script.Load("maps/externalmap/armies.lua")
	Script.Load("maps/externalmap/tributes.lua")

	Display.SetPlayerColorMapping(6, KERBEROS_COLOR)		-- Robbers
	Display.SetPlayerColorMapping(7, KERBEROS_COLOR)		-- Attackers from Cave

	Display.SetPlayerColorMapping(4, FRIENDLY_COLOR1)		-- Oberkirch
	Display.SetPlayerColorMapping(5, FRIENDLY_COLOR2)		-- Unterbach

	Display.SetPlayerColorMapping(8, NPC_COLOR)				-- Trader

	SetPlayerName(4, "Oberkirch")
	SetPlayerName(5, "Unterbach")
	SetPlayerName(6, "Räuber")
	SetPlayerName(7, "Kerberos Truppen")

	-- custom Map Stuff
	TagNachtZyklus(24,1,1,-4,1)
	StartTechnologies()

	-- Init  global MP stuff
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SetEntitySelectableFlag(eID, 0)
		Logic.SetEntityUserControlFlag(eID, 0)
	end

	if CNetwork then
		if GUI.GetPlayerID() ~= 17 then
			SetUpGameLogicOnMPGameConfigLight()
		end
	end

	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		Logic.SetPlayerPaysLeaderFlag(i, 0)
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	--
	InitPlayerColorMapping()
	--
	LocalMusic.UseSet = EUROPEMUSIC
	--

	XGUIEng.ShowWidget("SettlerServerInformation", 0)
	XGUIEng.ShowWidget("SettlerServerInformationExtended", 0)

	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	TributeP1_Challenge()

end
function AnfangsBriefingInitialize()
	ActivateBriefingsExpansion()
	AnfangsBriefing()
	Cutscene_Intro_CreateArmySiege()
	return true
end
function IsUsingRules(_requiredPairs, _optionalPairs, _minPatchLevel)
    local dec = CustomStringHelper.FromString(XNetwork.EXTENDED_GameInformation_GetCustomString())
    local keys = CustomStringHelper.GetKeys(dec)
    local wrong = {}

    if keys then

        local patchlevel = keys["PATCHLEVEL"] or 0
        keys["PATCHLEVEL"] = nil

        if patchlevel < _minPatchLevel then
            table.insert(wrong, "patchlevel mismatch: minimum required: " .. _minPatchLevel .. " got: " .. patchlevel)
        end

        for key, value in pairs(_requiredPairs) do
            if keys[key] == value then
                keys[key] = nil
            else
                table.insert(wrong, "pair: " .. key .. " value: " .. tostring(value) .. " expected: " .. tostring(keys[key]))
                keys[key] = nil
            end
            _requiredPairs[key] = nil
        end

        for key, value in pairs(_requiredPairs) do
            table.insert(wrong, "missing required pair: " .. key .. "" .. key .. " " .. tostring(value))
        end

        for key, value in pairs(_optionalPairs) do
            if keys[key] == value then
                keys[key] = nil
            elseif keys[key] ~= nil then
                keys[key] = nil
                table.insert(wrong, "mismatched optional pair: " .. key .. " value: " .. tostring(value) .. " expected: " .. tostring(keys[key]))
            end
        end

        for key, value in pairs(keys) do
            table.insert(wrong, "additional pair: " .. tostring(key))
        end
    end
    return table.getn(wrong) > 0, wrong
end

local required = {
    ["RELOAD_FIX"] = true
}
local optional = {
    ["CHAIN_CONSTRUCTION"] = true
}

function PrepareForStart()
	SetupPlayerAi( 7, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	local id
	local pos = GetPosition("spawn")
	for i = 1, round(2 + gvDiffLVL) do
		id = AI.Entity_CreateFormation(1, Entities.PU_LeaderSword2, 0, 4, pos.X, pos.Y, 0, 0, 0, 0)
		Move(id,"briefing1")
	end
	local pos = GetPosition("erecspawn")
	erectroops = {}
	for i = 1, round(1 + gvDiffLVL) do
		erectroops[i] = AI.Entity_CreateFormation(2, Entities.PU_LeaderSword3, 0, 8, pos.X, pos.Y, 0, 0, 0, 0)
	end
	Move("Dario","briefing3")
	do
	local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.PB_Bank1, 38600.00, 2600.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2bank")
		id = Logic.CreateEntity(Entities.PB_Headquarters1, 39200.00, 4400.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2hq")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 38377.09, 3491.01, 202.44, 2);tbi(e,id);Logic.SetEntityName(id, "defender7")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 37643.19, 2792.91, 202.44, 2);tbi(e,id);Logic.SetEntityName(id, "defender5")
		id = Logic.CreateEntity(Entities.PB_Tower1, 36400.00, 3600.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2tower")
		id = Logic.CreateEntity(Entities.PB_Residence1, 36800.00, 5400.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2residence1")
		id = Logic.CreateEntity(Entities.PB_VillageCenter1, 37500.00, 6400.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2vc")
		id = Logic.CreateEntity(Entities.PB_Residence2, 38100.00, 5400.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2residence2")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 38006.82, 4713.68, 202.44, 2);tbi(e,id);Logic.SetEntityName(id, "defender6")
		id = Logic.CreateEntity(Entities.PB_Market1, 39900.00, 6400.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2market")
		id = Logic.CreateEntity(Entities.PB_Residence2, 40300.00, 4200.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2residence3")
		id = Logic.CreateEntity(Entities.PB_University1, 42000.00, 5500.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2uni")
		id = Logic.CreateEntity(Entities.PB_Farm1, 41900.00, 3800.00, 0.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2farm")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 39694.73, 3433.07, 202.44, 2);tbi(e,id);Logic.SetEntityName(id, "defender8")
		id = Logic.CreateEntity(Entities.PB_University1, 27900.00, 40000.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1uni")
		id = Logic.CreateEntity(Entities.PB_Residence2, 28900.00, 38600.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1residence2")
		id = Logic.CreateEntity(Entities.PB_Headquarters1, 30300.00, 39800.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1hq")
		id = Logic.CreateEntity(Entities.PB_VillageCenter1, 30400.00, 41500.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1vc")
		id = Logic.CreateEntity(Entities.PB_Residence1, 31500.00, 41200.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1residence1")
		id = Logic.CreateEntity(Entities.PB_Farm1, 32400.00, 41000.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1farm")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 31446.40, 39174.80, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "defender3")
		id = Logic.CreateEntity(Entities.PB_Market1, 32500.00, 39400.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1market")
		id = Logic.CreateEntity(Entities.PU_BrickMaker, 31816.00, 40140.80, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler1")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 32770.40, 40181.90, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "defender1")
		id = Logic.CreateEntity(Entities.PB_Residence3, 32100.00, 38000.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1residence3")
		id = Logic.CreateEntity(Entities.PB_Brickworks1, 31300.00, 37700.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1brickworks")
		id = Logic.CreateEntity(Entities.PB_Residence1, 32100.00, 37200.00, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "p1residence4")
		id = Logic.CreateEntity(Entities.PU_Trader, 30580.40, 37950.70, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler2")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 30627.20, 38399.50, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "defender2")
		id = Logic.CreateEntity(Entities.PU_Trader, 30381.70, 38171.20, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler3")
		id = Logic.CreateEntity(Entities.PU_Scholar, 28523.60, 39016.30, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler6")
		id = Logic.CreateEntity(Entities.PU_Scholar, 28208.50, 38776.60, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler4")
		id = Logic.CreateEntity(Entities.PU_BrickMaker, 28913.60, 39410.80, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler5")
		id = Logic.CreateEntity(Entities.PU_BrickMaker, 29385.00, 40850.10, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler7")
		id = Logic.CreateEntity(Entities.PU_Scholar, 29400.00, 41528.10, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "Settler8")
		id = Logic.CreateEntity(Entities.PU_LeaderPoleArm1, 32830.30, 38169.60, 0.00, 1);tbi(e,id);Logic.SetEntityName(id, "defender4")
	end
	SetHostile(1, 7)
	SetHostile(2, 7)
	if not CNetwork then
		local t = {}
		for i = 1, table.getn(erectroops) do
			t[i] = GetPosition(erectroops[i])
		end
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		for i = 1, table.getn(erectroops) do
			erectroops[i] = Logic.GetEntityAtPosition(t[i].X, t[i].Y)
		end
	end
	if not gvChallengeFlag then
		StartCutscene("Intro", AnfangsBriefingInitialize)
	else
		AnfangsBriefingInitialize()
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerOrBuildingFilter()) do
			Logic.SetEntitySelectableFlag(eID, 0)
			Logic.SetEntityUserControlFlag(eID, 0)
			if Logic.IsBuilding(eID) == 1 then
				ChangeHealthOfEntity(eID, math.random(20*gvDiffLVL, 30 + 10*gvDiffLVL))
			end
		end
	end
end
function StartInitialize()

	function BuyHeroWindow_Update_BuyHero( _HeroEntityType )
		local PlayerID = GUI.GetPlayerID()
		local NumberOfHerosToBuy = Logic.GetNumberOfBuyableHerosForPlayer( PlayerID )
		local DisableFlag = 0
		if NumberOfHerosToBuy == 0 then
			DisableFlag = 1
		end
		if Logic.GetPlayerEntities( PlayerID, _HeroEntityType, 1 ) ~= 0 then
			DisableFlag = 1
		end
		if _HeroEntityType == Entities.PU_Hero1c or _HeroEntityType == Entities.PU_Hero4 then
			DisableFlag = 1
		end
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableFlag )
	end

	local tab = ChestRandomPositions.CreateChests(25)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	SetupPlayerAi( 6, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	--
	CreateArmyP6_1()
	CreateArmyP6_2()
	CreateArmyP6_3()
	CreateArmyP6_4()
	CreateArmyP6_5()
	CreateArmyP6_6()
	CreateArmyP6_7()
	CreateArmyP6_8()
	CreateArmyP6_9()
	CreateArmyP6_10()
	CreateArmyP6_11()
	CreateArmyNV()
	--MapEditor_SetupAI(4, 1, 3000, 1, "stables", 1, 0)
	--MapEditor_SetupAI(5, 1, 3000, 1, "village2", 1, 0)
	MapEditor_SetupAI(6, 1, 3500, 1, "BanditsSpawn3", 1, 0)
	MapEditor_Armies[6].defensiveArmies.strength = 0
	MapEditor_Armies[6].offensiveArmies.strength = round(6/gvDiffLVL)
	--SetupPlayerAi( 3, {constructing = true, extracting = 0, repairing = true, serfLimit = 15} )
	--SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 12} )
	--SetupPlayerAi( 8, {constructing = true, extracting = false, repairing = true, serfLimit = 12} )
	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
		SetFriendly(1,2)
		for i = 1,2 do
			SetNeutral(i,4)
			SetNeutral(i,5)
			SetNeutral(i,8)
		end
	else
		for i = 1,2 do
			SetNeutral(i,4)
			SetNeutral(i,5)
			SetNeutral(i,8)
		end
		SetHostile(1,6)
		SetHostile(1,7)
	end
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitGroups()
	MakeInvulnerable("BanditsTower8")
	StartSimpleJob("DefeatJob")

	StartCountdown(10*60*gvDiffLVL,UpgradeKIa,false)

	SetPlayerName(4, "Oberkirch")
	SetPlayerName(5, "Unterbach")
	SetPlayerName(6, "Räuber")
	SetPlayerName(7, "Kerberos Truppen")

	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerFilter()) do
		if Logic.GetEntityName(eID) == nil or string.find(Logic.GetEntityName(eID), "Settler") == nil or string.find(Logic.GetEntityName(eID), "defender") == nil then
			Logic.SetEntitySelectableFlag(eID, 1)
			Logic.SetEntityUserControlFlag(eID, 1)
		end
	end

	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end

	StartCountdown((20+(10*gvDiffLVL))*60, TroopSpawnVorbVorb, false)
	StartCountdown((17+(10*gvDiffLVL))*60, OberkirchCallsForHelpBriefing, false)

end
function TroopSpawnVorbVorb()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "AntiSpawnCampTrigger", 1)
	TroopSpawnVorb()
end
function DefeatJob()
	if (Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters1) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters2) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters3)) < 2 or IsDestroyed("village1") or IsDestroyed("village2") then
		Defeat()
		Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01, 100)
		return true
	end
end
function GetHeroPositionByPlayer()
	local player = GUI.GetPlayerID()
	if player == 1 then
		return GetPosition("Dario")
	else
		return GetPosition("Erec")
	end
end
armySiegeWestDefeated = function()
	RidgewoodFreed = true
	gvarmyWestDone = 1
	-- Initial Resources
	local InitGoldRaw 		= math.floor(600*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitClayRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitWoodRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitStoneRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitIronRaw 		= math.floor(800*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitSulfurRaw		= math.floor(500*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))

	Tools.GiveResouces(1, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(1), CEntityIterator.IsBuildingFilter()) do
		Logic.SetEntitySelectableFlag(eID, 1)
		Logic.SetEntityUserControlFlag(eID, 1)
	end
	RidgewoodFreedBriefing()
end
armySiegeEastDefeated = function()
	DarkinwoodFreed = true
	gvarmyEastDone = 1
	-- Initial Resources
	local InitGoldRaw 		= math.floor(600*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitClayRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitWoodRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitStoneRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitIronRaw 		= math.floor(800*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))
	local InitSulfurRaw		= math.floor(500*(math.sqrt(gvDiffLVL)) - round(Logic.GetTime()/4))

	Tools.GiveResouces(2, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(2), CEntityIterator.IsBuildingFilter()) do
		Logic.SetEntitySelectableFlag(eID, 1)
		Logic.SetEntityUserControlFlag(eID, 1)
	end
	DarkinwoodFreedBriefing()
end
function VillagesFreed()
	if RidgewoodFreed and DarkinwoodFreed then
		StartCountdown(2 * 60 * gvDiffLVL, ArtefactStolenScene, false)
		NPCInit()
		SetHostile(4,7)
		SetHostile(5,7)
		return true
	end
end
NPCs = {}
--[[NPCData:
	1 -> Miner Iron/Stonemine
	2 -> Trader
	3 -> Miner Claymine
	4 -> Leonardo
	5 -> Mayor Oberkirch
	6 -> Mayor Unterbach
	7 -> Hermit seeing thief flee
	8 -> Farmer seeing group burying artefact
	9 -> Afraid miner showing bandit camps
	10 -> Settler showing gold mine and fog people
	11 -> Hermit behind waterfall
	]]
function NPCInit()
	TalkedToUselessNPC = 0
	for i = 1,3 do
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc"..i), 1)
		NPCs[i] = true
	end
	for i = 9,11 do
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc"..i), 1)
		NPCs[i] = true
	end
	StartSimpleJob("NPCControl")
end

function NPCControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, name
		for i = 1,11 do
			if  NPCs[i] then
				pos = 	GetPosition("npc"..i)
				name = "npc"..i
				for j = 1, 2 do
					entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)};
					if entities[1] > 0 then
						if Logic.IsHero(entities[2]) == 1 then
							LookAt(entities[2], name)
							NPCs[i] = false
							Logic.SetOnScreenInformation(Logic.GetEntityIDByName(name), 0)
							_G["NPCBriefing"..i]()
						end
					end
				end
			end
		end
	end
end

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Nehmt Eure Truppen und eilt nach Ridgewood.  @cr Doch seht Euch vor! Bruder Johannes hatte Euch gewarnt, dass die Gegend unsicher sei.",
		position = GetPosition("briefing3")
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Ihr müsst hier mit Wegelagerern rechnen!  @cr Sendet Darios Falken aus, um zu sehen, welcher der beiden Pfade sicher ist.",
		position = GetPosition("hawk")
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Oh Herr! Die Banditen sind bereits da! Sie brennen die Stadt nieder! @cr Helft den armen Bürgern! Schnell!",
		position = GetPosition("p1hq"),
		action = function()
			Move("Erec","erecEnd")
			for i = 1, table.getn(erectroops) do
				Move(erectroops[i], "erecStart"..i)
			end
		end
	}
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Endlich! Heerführer Ercec ist mit seinen Truppen aus Crawford zurückgekehrt!  @cr Nun dürften die Raubritter schlechte Karten haben!",
		position = GetPosition("erecEnd")
	}

	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Er kommt gerade zur rechten Zeit. @cr Auch Darkinwood im Osten wird attackiert! @cr Kennen Kerberos Schergen denn kein Erbarmen?",
		position = GetPosition("eastattack"),
	}
	AP{
        title	= "@color:230,120,0 Auftragsziele",
        text	= "@color:230,0,0 1) Eilt nach Ridgewood! @cr 2) Verteidigt das Dorf und vertreibt die Banditen! @cr 3) Auch Darkinwood im Osten wird überfallen. Beeilt Euch und vertreibt auch hier alle Feinde!",
		position = GetHeroPositionByPlayer(),
		action = function()
			StartInitialize()
		end

    }

    StartBriefing(briefing)
end
--
function RidgewoodFreedBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Ihr habt die Angreifer abwehren können, aber um welchen Preis... @cr Zahlreiche Gebäude sind zerstört, viele Dorfbewohner geflohen. @cr Als Dario in das Haus seiner Mutter stürzt, erwartet ihn eine böse Überraschung...",
		position = GetPosition("defenderTarget1")
    }
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Auf einem Hügel nahe der Stadt haben die Banditen ein Lager eingerichtet. @cr Ihr müsst damit rechnen, dass sie Eure Siedlung angreifen werden.",
		position = GetPosition("HQ2_CampFire")
    }
	    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Dort halten sie einige Dorfbewohner gefangen. Und auch Leonardo, den Erfinder. @cr Ihr müsst alles daran setzen, sie aus der Hand dieser Halunken zu befreien!",
		position = GetPosition("npc1")
    }
	    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Auch im Süden haben die Banditen ein Lager errichtet. Von dort droht Euch ebenfalls Gefahr!",
		position = GetPosition("HQ1_CampFire")
    }
	    AP{
        title	= "@color:230,120,0 Auftragsziele",
        text	= "@color:230,0,0 1) Verteidigt Ridgewood! Fällt die Burg, ist die Mission verloren. @cr 2) Bereitet Euch auf Angriffe der Räuber vor. Sucht nach Rohstoffen und baut das Dorf aus.",
		position = GetPosition("defenderTarget2"),
		action = function()
			StartCountdown(5 * 60 * gvDiffLVL, SettlerWarnsRidgewoodBriefing, false)
			StartCountdown(20 * 60 * gvDiffLVL, MentorWarnsRidgewoodBriefing, false)
		end
    }

    StartBriefing(briefing)
end
--
function ArtefactStolenScene()
	StartCutscene("Thief", ArtefactStolenBrief)
end
function ArtefactStolenBrief()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Herr! Das Artefakt. Es wurde gestohlen. @cr Ihm nach!",
		position = GetPosition("siege")
    }
    AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 1. Findet den Dieb und beschafft Euch das Artefakt. @cr 2. Bringt das Artefakt sicher ins Dorf zurück.",
		position = GetPosition("siege"),
		action = function()
			ArtefactAdditionalBriefings()
		end
    }

    StartBriefing(briefing)
end
function ArtefactAdditionalBriefings()
	do
		local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.CU_Wanderer, 44377.19, 38510.85, 160.00, 8);tbi(e,id);Logic.SetEntityName(id, "npc7")
		Logic.SetOnScreenInformation(id, 1)
	end
	NPCs[7] = true
end
function NPCBriefing7()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Dubioser Wanderer",
        text	= "@color:230,0,0 Ich habe hier kürzlich einen in Schwarz gehüllten Mann entlanglaufen sehen. Der schien es sehr eilig zu haben.",
		position = GetPosition("npc7")
    }
    AP{
        title	= "@color:230,120,0 Dubioser Wanderer",
        text	= "@color:230,0,0 Für eine kleine Aufbesserung meiner Rente erzähle ich euch, wo er hingelaufen ist. @cr Man muss ja schließlich sehen, wo man bleibt.",
		position = GetPosition("npc7"),
		action = function()
			TributeNPC7()
		end
    }

    StartBriefing(briefing)
end
function CreateThiefs()
	ThiefPosT = {}
	do
		local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.CU_Thief, 58737.95, 23034.69, 202.44, 8);tbi(e,id);Logic.SetEntityName(id, "thief1")
		id = Logic.CreateEntity(Entities.CU_Thief, 3174.22, 28813.68, 192.44, 8);tbi(e,id);Logic.SetEntityName(id, "thief2")
		id = Logic.CreateEntity(Entities.CU_Thief, 17955.22, 56384.22, 267.44, 8);tbi(e,id);Logic.SetEntityName(id, "thief3")
	end
	for i = 1, 3 do
		ThiefPosT[i] = GetPosition("thief" .. i)
	end
end
function CheckForThiefs()
	for i = 1, 3 do
		if not AreEntitiesOfDiplomacyStateInArea(1, ThiefPosT[i], 3000, Diplomacy.Hostile) then
			ThiefCapturedBrief(i)
			ThiefsRemaining = {1,2,3}
			return true
		end
	end
end
function ThiefCapturedBrief(_index)
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Das Artefakt? Was für ein Artefakt? @cr Ihr habt den falschen erwischt. @ Ich habe nur ein wenig Kleingeld mitgehen lassen.",
		position = GetPosition("thief" .. _index)
    }
    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Hier, nehmt es, aber verschont dafür mein Leben!",
		position = GetPosition("thief" .. _index),
		action = function()
			AddGold(1, dekaround(2000 * gvDiffLVL))
			AddGold(2, dekaround(2000 * gvDiffLVL))
			ChangePlayer("thief" .. _index, 6)
			table.remove(ThiefsRemaining, _index)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "CheckForRemainingThiefs",1,{},{_index})
		end
    }

    StartBriefing(briefing)

end
function CheckForRemainingThiefs(_index)
	local num = table.getn(ThiefsRemaining)
	for i = 1, num do
		local thief = ThiefsRemaining[i]
		if not AreEntitiesOfDiplomacyStateInArea(1, ThiefPosT[thief], 3500, Diplomacy.Hostile) then
			if num >= 2 then
				local rand = math.random(1,2)
				if rand == 1 then
					ThiefCaptured2Brief(thief)
					return true
				else
					RealThiefCaptured(thief)
					return true
				end
			else
				RealThiefCaptured(thief)
				return true
			end
		end
	end
end
function ThiefCaptured2Brief(_index)
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Ich soll das Artefakt zurückgeben? Welches Artefakt? @cr Ihr habt den falschen erwischt. @ Ich habe nur das Wenige, das es zu holen gab, mitgehen lassen.",
		position = GetPosition("thief" .. _index)
    }
    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Das könnt ihr haben. Aber lasst mich im Gegenzug in Frieden!",
		position = GetPosition("thief" .. _index),
		action = function()
			AddGold(1, dekaround(3000 * gvDiffLVL))
			AddGold(2, dekaround(3000 * gvDiffLVL))
			ChangePlayer("thief" .. _index, 6)
			table.remove(ThiefsRemaining, _index)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "CheckForRemainingThiefs",1,{},{_index})
		end
    }

    StartBriefing(briefing)

end
function RealThiefCaptured(_index)
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Das Artefakt? @cr Ach, ihr meintet die Kette. @ Die habe ich nicht mehr bei mir. Die sollte ich sicherheitshalber abgeben.",
		position = GetPosition("thief" .. _index)
    }
    AP{
        title	= "@color:230,120,0 Dieb",
        text	= "@color:230,0,0 Da werdet ihr alle Truhen in den Räuberlagern durchsuchen müssen. @cr Mehr weiß ich auch nicht. Und nun lasst mich gehen!",
		position = GetPosition("thief" .. _index),
		action = function()
			ChangePlayer("thief" .. _index, 6)
			table.remove(ThiefsRemaining, _index)
			StartSimpleJob("CheckForChests")
		end
    }

    StartBriefing(briefing)

end
function CheckForChests()
	local check = true
	if not Chests then
		UselessNPCsReward()
	end
	if not closed_chests then
		closed_chests = GetClosedChestsAmount()
		ChestCountQuestGUI()
	end
	for i = 1,18 do
		if Chests[i] then
			check = false
			break
		end
	end
	if check then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end

		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Dieser Dieb muss uns angelogen haben. @cr Alle Truhen wurden geplündert und in keiner war das Artefakt. @cr Ihr werdet an anderer Stelle weiter suchen müssen.",
			position = GetPlayerStartPosition()
		}
		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Vielleicht hat ja einer der Dörfler etwas verdächtiges beobachtet...",
			position = GetPlayerStartPosition(),
			action = function()
				do
					local id, tbi, e = nil, table.insert, {};
					id = Logic.CreateEntity(Entities.CU_FarmerIdle, 41715.77, 26039.16, 175.00, 5);tbi(e,id);Logic.SetEntityName(id, "npc8")
					Logic.SetOnScreenInformation(id, 1)
					NPCs[8] = true
				end
			end
		}

		StartBriefing(briefing)

		return true
	end
end
function ChestCountQuestGUI()
	GUIQuestTools.StartQuestInformation("Chest", "", 1, 1)
	GUIQuestTools.UpdateQuestInformationString(closed_chests)
	GUIQuestTools.UpdateQuestInformationTooltip = function()
		XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Verbleibende Truhen der Räuber @cr Ihr müsst alle Truhen der Räuber durchsuchen, um das Artefakt zu finden!")
	end
	StartSimpleJob("RemainingChestCountCheck")
end
function RemainingChestCountCheck()

	closed_chests = GetClosedChestsAmount()
    GUIQuestTools.UpdateQuestInformationString(closed_chests)

    if closed_chests == 0 then
        GUIQuestTools.DisableQuestInformation()
        return true
    end

end
function GetClosedChestsAmount()
	local count = 0
	for i = 1,18 do
		if Chests[i] then
			count = count + 1
		end
	end
	return count
end
function NPCBriefing8()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Aufmerksamer Bauer",
        text	= "@color:230,0,0 Als ich letztens auf dem Feld arbeitete, habe ich ein paar verdächtig aussehende Leute die Berge im Norden hocheilen sehen.",
		position = GetPosition("npc8")
    }
    AP{
        title	= "@color:230,120,0 Aufmerksamer Bauer",
        text	= "@color:230,0,0 Könnten Räuber gewesen sein...",
		position = {X = 51216.69, Y = 34299.81},
		action = function()
			local pos = GetPosition("GoldChest19")
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold,pos.X,pos.Y,0,0), "Chest19")
			StartSimpleJob("SpecialChestControl")
		end
    }

    StartBriefing(briefing)
end
function SpecialChestControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, randomEventAmount
		pos = GetPosition("Chest19")
		for j = 1, 2 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					ArtefactFoundBriefing(entities[2])
					Sound.PlayGUISound(Sounds.Misc_Chat2,100)
					ReplacingEntity("Chest19", Entities.XD_ChestOpen)
					return true
				end
			end
		end
	end
end
function ArtefactFoundBriefing(_hero)
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Ihr habt das Artefakt gefunden! @cr Bringt es nun sicher zurück nach Ridgewood.",
		position = GetPosition(_hero),
		action = function()
			CreateAmbushingTroops(_hero)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ArrivedAtVillageCheck",1,{},{_hero})
		end
    }

    StartBriefing(briefing)
end
function ArrivedAtVillageCheck(_hero)
	if IsNear(_hero, "p1hq", 1200) then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end

		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Ihr habt es geschafft. @cr Das Artefakt ist wieder sicher in Ridgewood.",
			position = GetPosition("p1hq")
		}
		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Kerberos wird das gar nicht gefallen. @cr Er wird alles daran setzen, in einem finalen Angriff das Artefakt zurück zu bekommen.",
			position = GetPosition("cave2")
		}
		AP{
			title	= "@color:230,120,0 Missionsziele",
			text	= "@color:230,0,0 1. Verteidigt alle Dörfer. @cr 2. Besiegt alle verbliebenen Feinde, um siegreich zu sein!",
			position = GetPlayerStartPosition(),
			action = function()
				StartCountdown(2*60*gvDiffLVL, LastAttack, true)
			end
		}

		StartBriefing(briefing)
		return true
	end
end
--
function SettlerWarnsRidgewoodBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bewohner von Ridgewood",
        text	= "@color:230,0,0 Herr! Wir konnten die Räuberbande auf dem Hügel ausspionieren!",
		position = GetPosition("HQ2_CampFire")
    }
    AP{
        title	= "@color:230,120,0 Bewohner von Ridgewood",
        text	= "@color:230,0,0 Sie planen in Kürze einen Angriff auf Eure Siedlung!",
		position = GetPosition("defenderTarget2"),
		action = function()
			StartCountdown(2 * 60 * gvDiffLVL, WestHillAttack, false)
			StartCountdown(6 * 60 * gvDiffLVL, LeonardoCallsHelpBriefing, false)
		end
    }

    StartBriefing(briefing)
end
function WestHillAttack()
	WestHillArmy()
end
--
function MentorWarnsRidgewoodBriefing()
	if IsExisting("BanditsTower7") then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end

		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Meister! Ein Wanderer konnte die Räuber in ihrem Lager im Süden belauschen.",
			position = GetPosition("HQ1_CampFire")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Sie planen, in Kürze Eure Siedlung anzugreifen! Ihr müsst mit einigen Trupps rechnen!",
			position = GetPosition("BanditsTower7")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Seht Euch vor und bringt Eure Truppen in Position!",
			position = GetPosition("siege")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Bereitet Euch auf den Angriff vor! Ihr solltet Euren stärksten Truppen die Verteidigung der Stadt übertragen.",
			position = GetPosition("defenderTarget2"),
			action = function()
				StartCountdown(2 * 60 * gvDiffLVL, WestSouthCampAttack, false)
			end
		}

		StartBriefing(briefing)
	end
end
function WestSouthCampAttack()
	WestSouthCampArmy()
end
--
function DarkinwoodFreedBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Ihr habt die Angreifer abwehren können, aber um welchen Preis... @cr Zahlreiche Gebäude sind zerstört, viele Dorfbewohner geflohen. @cr Als Erec in das Haus seines Vaters, Vetter zweiten Grades von Darios Mutter, stürzt, erwartet ihn eine schlimme Überraschung...",
		position = GetPosition("defenderTarget7")
    }
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 In einem Wald nahe der Stadt haben die Banditen ein Lager eingerichtet. @cr Ihr müsst damit rechnen, dass sie Eure Siedlung angreifen werden.",
		position = GetPosition("BanditsSpawn6")
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 In einem weiteren Lager halten sie auch einige Dorfbewohner gefangen, welche gezwungenermaßen den besten Fisch des ganzen Königreiches dort für die Räuber angeln müssen! @cr Ihr müsst alles daran setzen, diese Halunken vom Fischen abzuhalten!",
		position = GetPosition("BanditsSpawn1")
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Auch im Süden haben die Banditen ein Lager errichtet. Von dort droht Euch ebenfalls Gefahr!",
		position = GetPosition("BanditsSpawn2")
    }
	AP{
        title	= "@color:230,120,0 Auftragsziele",
        text	= "@color:230,0,0 1) Verteidigt Darkinwood! Fällt die Burg, ist die Mission verloren. @cr 2) Bereitet Euch auf Angriffe der Waldräuber vor. Sucht nach Rohstoffen und baut das Dorf aus.",
		position = GetPosition("defenderTarget7"),
		action = function()
			StartCountdown(5 * 60 * gvDiffLVL, SettlerWarnsDarkinwoodBriefing, false)
			StartCountdown(20 * 60 * gvDiffLVL, MentorWarnsDarkinwoodBriefing, false)
		end
    }

    StartBriefing(briefing)
end
--
function SettlerWarnsDarkinwoodBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bewohner von Darkinwood",
        text	= "@color:230,0,0 Herr! Wir konnten die Räuberbande im verbotenem Wald ausspionieren!",
		position = GetPosition("BanditsSpawn6")
    }
    AP{
        title	= "@color:230,120,0 Bewohner von Darkinwood",
        text	= "@color:230,0,0 Sie planen in Kürze einen Angriff auf Eure Siedlung!",
		position = GetPosition("defenderTarget6"),
		action = function()
			StartCountdown(2 * 60 * gvDiffLVL, EastWoodAttack, false)
		end
    }

    StartBriefing(briefing)
end
function EastWoodAttack()
	EastWoodArmy()
end
--
function MentorWarnsDarkinwoodBriefing()
	if IsExisting("BanditsTower2") then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end

		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Meister! Ein Waldarbeiter konnte die Räuber in ihrem Lager im Süden belauschen.",
			position = GetPosition("BanditsSpawn2")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Sie planen, in Kürze Eure Siedlung anzugreifen! Ihr müsst mit einigen Trupps rechnen!",
			position = GetPosition("BanditsSpawn2")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Seht Euch vor und bringt Eure Truppen in Position!",
			position = GetPosition("eastattack")
		}
			AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Bereitet Euch auf den Angriff vor! Ihr solltet Euren stärksten Truppen die Verteidigung der Stadt übertragen.",
			position = GetPosition("defenderTarget6"),
			action = function()
				StartCountdown(2 * 60 * gvDiffLVL, EastShoreAttack, false)
			end
		}

		StartBriefing(briefing)
	end
end
function EastShoreAttack()
	EastShoreArmy()
end
--
function OberkirchCallsForHelpBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Der Bürgermeister von Oberkirch hat eine Botschaft geschickt!",
		position = GetPosition("npc5")
    }
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Er bittet Euch, umgehend zu ihm zu kommen. Er braucht dringend Hilfe! @cr Vielleicht kann er Euch auch etwas über die Aktivität der Raubritter, hier in der Gegend, erzählen...",
		position = GetPosition("village1")
    }
	    AP{
        title	= "@color:230,120,0 Auftragsziel",
        text	= "@color:230,0,0 1) Geht mit Eurem Helden zum Bürgermeister von Oberkirch und sprecht mit ihm.",
		position = GetPosition("Dario"),
		action = function()
			for i = 5,6 do
				Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc"..i), 1)
				NPCs[i] = true
			end
			NPC5Reminder = StartCountdown(5 * 60 * gvDiffLVL, OberkirchCallsForHelpRememberBriefing, true)
		end
	}

    StartBriefing(briefing)
end
--
function OberkirchCallsForHelpRememberBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Dario! Erec! Wo bleibt Ihr denn?",
		position = GetPosition("Dario")
    }
    AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Die Zeit wird knapp! Der Bürgermeister ist verzweifelt.",
		position = GetPosition("npc5"),
		action = function()
			NPC5Reminder = StartCountdown(5 * 60 * gvDiffLVL, Defeat, true)
		end
    }

    StartBriefing(briefing)
end
--
function NPCBriefing5()
	StopCountdown(NPC5Reminder)
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Dario! Ich habe das von Eurer Mutter gehört. Tut mir sehr leid... @cr Aber leider haben wir kaum Zeit für Trauer!",
		position = GetPosition("npc5")
    }
    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Was uns sorgt: Seit Tagen machen schwarze Raubritter die Gegend hier unsicher. @cr Wir haben nun herausgefunden, wo sie sich sammeln...",
		position = GetPosition("npc5")
    }
    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 In diesen Höhlen hier bereiten sie einen Angriff auf unsere Stadt vor. @cr Sie kommen auf Pferden, so dass man sie mit Speerträgern aufhalten könnte. @cr Doch mir fehlt das Geld.",
		position = GetPosition("cave1")
    }
    AP{
        title	= "@color:230,120,0 Bürgermeister von Oberkirch",
        text	= "@color:230,0,0 Wenn Ihr mir ".. round(10000 / gvDiffLVL) .." Taler, Holz und Eisen gebt, könnte ich aber Truppen aufstellen. Oder Ihr schickt uns einige Eurer Soldaten... @cr In keinem Fall darf unser Dorfzentrum zerstört werden!",
		position = GetPosition("stables"),
		action = function()
			TributeNPC5()
			ActivateShareExploration(1, 4, true)
			ActivateShareExploration(2, 4, true)
		end
    }
    AP{
        title	= "@color:230,120,0 Auftragsziel",
        text	= "@color:230,0,0 1) Verteidigt Oberkirch gegen die schwarzen Ritter. Schickt Truppen oder gebt dem Bürgermeister Geld!",
		position = GetPosition("village1")
    }

    StartBriefing(briefing)
end
--
function NPCBriefing6()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bürgermeister von Unterbach",
        text	= "@color:230,0,0 Hallo Freunde. Gut, dass Ihr kommt. Wir haben Kunde bekommen, dass sich in den Höhlen schwarze Raubritter sammeln. @cr Bestimmt greifen sie unsere Stadt an!",
		position = GetPosition("npc6")
    }
	AP{
        title	= "@color:230,120,0 Bürgermeister von Unterbach",
        text	= "@color:230,0,0 Sie sind nicht mehr weit. @cr Ihr müsst unser Dorf um jeden Preis beschützen!",
		position = GetPosition("cave2")
    }
	AP{
        title	= "@color:230,120,0 Auftragsziel",
        text	= "@color:230,0,0 1) Verteidigt Unterbach gegen die schwarzen Ritter. Schickt Truppen, um das Dorf zu schützen! @cr Fällt das Stadtzentrum, ist die Mission verloren!",
		position = GetPosition("village2"),
		action = function()
			ActivateShareExploration(1, 5, true)
			ActivateShareExploration(2, 5, true)
		end
    }

    StartBriefing(briefing)
end
--
function LeonardoCallsHelpBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Leonardo",
        text	= "@color:230,0,0 Dario! Erec! Schnell! Holt mich hier raus! Hier ist nur noch ein kleiner Wachposten übrig.  @cr Die restlichen Banditen hatten versucht, Eure Stadt zu stürmen: Die habt Ihr schon besiegt!",
		position = GetPosition("npc4"),
		action = function()
			MakeVulnerable("BanditsTower8")
			StartSimpleJob("CheckForLeonardoFreed")
		end
    }

    StartBriefing(briefing)
end
function CheckForLeonardoFreed()
	if IsDead(armyP6_8) and IsDestroyed("BanditsTower8") then
		NPCBriefing4()
		return true
	end
end
--
function NPCBriefing4()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Leonardo",
        text	= "@color:230,0,0 Ah, mein Retter! Danke, dass Ihr mich befreit habt. @cr Schaut - ich habe eine neue Technologie erfunden. Türme, die automatisch auf Feinde schiessen. Das könnt Ihr sicher brauchen!",
		position = GetPosition("npc4"),
		action = function()
			for i = 1,2 do
				ResearchTechnology(Technologies.UP1_Tower, i)
			end
			for i = 1, 5 do
				ChangePlayer("hostage"..i, 1)
			end
			DestroyEntity("Leonardo_Gate")
		end
    }

    StartBriefing(briefing)
end
--
function NPCBriefing1()
	TalkedToUselessNPC = TalkedToUselessNPC + 1
	if TalkedToUselessNPC >= round(5 /gvDiffLVL) then
		if not ChestReward then
			UselessNPCsReward()
		end
	end
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bergmann",
        text	= "@color:230,0,0 Seid gegrüßt, Herr! @cr Ich habe einen Lehmschacht auf dem Hügel entdeckt! Bitte verratet das aber niemandem.",
		position = {X = 25725, Y = 20950}
    }

    StartBriefing(briefing)
end
--
function NPCBriefing2()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Langoh Schlitzohrius",
        text	= "@color:230,0,0 Seid gegrüßt, edler Herr! Ich komme eben zurück von einer sehr lukrativen Reise nach Crawford.  @cr Die Stadt wird belagert, daher braucht man viel Holz und Eisen für neue Waffen.  @cr Ich konnte dort meine ganzen Bestände verkaufen!",
		position = GetPosition("npc2")
    }
    AP{
        title	= "@color:230,120,0 Langoh Schlitzohrius",
        text	= "@color:230,0,0 Jetzt brauche ich wieder Nachschub...  @cr  @cr Sagt - wollt Ihr mir nicht ein paar Waren verkaufen? Ich zahle gute Preise!",
		position = GetPosition("npc2"),
		action = function()
			TributeNPC2_1()
		end
    }

    StartBriefing(briefing)
end
--
function NPCBriefing3()
	TalkedToUselessNPC = TalkedToUselessNPC + 1
	if TalkedToUselessNPC >= round(5 /gvDiffLVL) then
		if not ChestReward then
			UselessNPCsReward()
		end
	end

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Bergmann",
        text	= "@color:230,0,0 Seid gegrüßt, edler Herr! @cr Eigentlich arbeite ich in der Eisenmine da hinten im Wald, aber seit kurzem treiben sich hier Räuber herum.  @cr Nehmt Euch in acht!",
		position = GetPosition("defendMine")
    }

    StartBriefing(briefing)
end
--
function NPCBriefing9()
	TalkedToUselessNPC = TalkedToUselessNPC + 1
	if TalkedToUselessNPC >= round(5 /gvDiffLVL) then
		if not ChestReward then
			UselessNPCsReward()
		end
	end

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Verängstigter Bergmann",
        text	= "@color:230,0,0 Guten Tag der Herr! @cr Ihr wollt diesem Weg weiter folgen? @cr Seid bloß vorsichtig.",
		position = GetPosition("npc9")
    }
	AP{
        title	= "@color:230,120,0 Verängstigter Bergmann",
        text	= "@color:230,0,0 Seit einigen Wochen treiben hier Räuberhorden ihr Unwesen. @cr Die werden Fremden gegenüber sicherlich nicht freundlich gesonnen sein.",
		position = GetPosition("BanditsSpawn1")
    }

    StartBriefing(briefing)
end
--
function NPCBriefing10()
	TalkedToUselessNPC = TalkedToUselessNPC + 1
	if TalkedToUselessNPC >= round(5 /gvDiffLVL) then
		if not ChestReward then
			UselessNPCsReward()
		end
	end

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Vertriebener",
        text	= "@color:230,0,0 Diese Schweine! @cr Sie nahmen mir alles. @cr Meine Frau... @cr Meine Kinder... @cr Mein Haus...",
		position = GetPosition("GoldMineSpawn")
    }
	AP{
        title	= "@color:230,120,0 Vertriebener",
        text	= "@color:230,0,0 Hier, nehmt dies. @cr Ich kann damit nun nichts mehr anfangen...",
		position = GetPosition("npc10")
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Herr, seht doch. @cr Dieser verzweifelte Siedler hat euch all sein Hab und Gut überlassen!",
		position = GetPosition("npc10"),
		action = function()
			for i = 1,2 do
				AddGold(i, dekaround(3500 * gvDiffLVL))
			end
		end
    }

    StartBriefing(briefing)
end
--
function NPCBriefing11()
	TalkedToUselessNPC = TalkedToUselessNPC + 1
	if TalkedToUselessNPC >= round(5 /gvDiffLVL) then
		if not ChestReward then
			UselessNPCsReward()
		end
	end

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:230,120,0 Einsiedler",
        text	= "@color:230,0,0 Oh, ihr habt mich gefunden... @cr Ich hätte nicht erwartet, dass mich hier jemand findet.",
		position = GetPosition("npc11")
    }
	AP{
        title	= "@color:230,120,0 Einsiedler",
        text	= "@color:230,0,0 Löst mein Rätsel und ihr erhaltet eine hilfreiche Belohnung.",
		position = GetPosition("npc11")
    }
	AP{
        title	= "@color:230,120,0 Einsiedler",
        text	= "@color:230,0,0 Auf der alten Wetterspitz ein Glauben längst vergessen. @cr Frostiger See oder doch nur Zierde?",
		position = GetPosition("npc11"),
		action = function()
			StartSimpleJob("CheckForRiddle")
		end
    }

    StartBriefing(briefing)
end
function CheckForRiddle()
	if Logic.GetWeatherState() == 3 then
		local num, id = Logic.GetEntitiesInArea(Entities.PB_Beautification02, 58100, 34300, 2000, 1)
		if num > 0 and Logic.IsConstructionComplete(id) == 1 then
			local briefing = {}
			local AP = function(_page) table.insert(briefing, _page) return _page end

			AP{
				title	= "@color:230,120,0 Einsiedler",
				text	= "@color:230,0,0 Oh, ihr habt das Rätsel gelöst. @cr Ich habe euch wohl unterschätzt.",
				position = GetPosition("npc11")
			}
			AP{
				title	= "@color:230,120,0 Einsiedler",
				text	= "@color:230,0,0 Nehmt dies als Zeichen meiner Anerkennung.",
				position = GetPosition("npc11"),
				action = function()
					for i = 1,2 do
						CLogic.SetAttractionLimitOffset(i, round(30 * gvDiffLVL))
					end
				end
			}

			StartBriefing(briefing)

			return true
		end
	end
end
function UselessNPCsReward()
	ChestReward = true
	local pos = {}
	for i = 1,18 do
		pos[i] = GetPosition("GoldChest"..i)
	end
	Chests = {}
	for i = 1,18 do
		Chests[i] = false
	end
	do
		local count = 0
		while count < 8 do
			local randval = math.random(1,18)
			if not Chests[randval] then
				Chests[randval] = true
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold,pos[randval].X,pos[randval].Y,0,0), "Chest"..randval)
				count = count + 1
			end
		end
	end
	StartSimpleJob("ChestControl")
end
function ChestControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, randomEventAmount
		for i = 1,18 do
			if  Chests[i] then
				pos = GetPosition("Chest"..i)
				for j = 1, 2 do
					entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
					if entities[1] > 0 then
						if Logic.IsHero(entities[2]) == 1 then
							local randomval = math.random(1, 50-i)
							if randomval ~= 1 then
								randomEventAmount = round((750 + math.random(350)) * gvDiffLVL)
								Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
								Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" )
							else
								randomEventAmount = round((250 + math.random(150)) * gvDiffLVL)
								Logic.AddToPlayersGlobalResource(j,ResourceType.Silver,randomEventAmount)
								Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat einen besonders wertvollen Schatz gefunden. Inhalt: " .. randomEventAmount.." Silber" )
							end
							Sound.PlayGUISound(Sounds.Misc_Chat2,100)
							Chests[i] = false
							ReplacingEntity("Chest"..i, Entities.XD_ChestOpen)
						end
					end
				end
			end
		end
	end
end
function VictoryJob()
	if (AI.Player_GetNumberOfLeaders(6) + AI.Player_GetNumberOfLeaders(7)) == 0 then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map4_won", 2)
				end
			end
		end
		Victory()
		return true
	end
end
function InitPlayerColorMapping()

	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),0)
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
	--
	XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 1, 0, 0, 0, 150)


	Display.SetPlayerColorMapping(6, KERBEROS_COLOR)		-- Robbers
	Display.SetPlayerColorMapping(7, KERBEROS_COLOR)		-- Attackers from Cave

	Display.SetPlayerColorMapping(4, FRIENDLY_COLOR1)		-- Oberkirch
	Display.SetPlayerColorMapping(5, FRIENDLY_COLOR2)		-- Unterbach

	Display.SetPlayerColorMapping(8, NPC_COLOR)				-- Trader
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()

end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
		ForbidTechnology(Technologies.UP1_Tower, i)
		ForbidTechnology(Technologies.UP2_Tower, i)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()

	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	-- Initial Resources
	local InitGoldRaw 		= math.floor(600*(math.sqrt(gvDiffLVL)))
	local InitClayRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitWoodRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitStoneRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitIronRaw 		= math.floor(800*(math.sqrt(gvDiffLVL)))
	local InitSulfurRaw		= math.floor(500*(math.sqrt(gvDiffLVL)))


	--Add Players Resources
	local i
	for i=1,8,1
	do

		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end
BuildingAttackPriorityList = {	[1] = {	"p1brickworks",
										"p1market",
										"p1residence3",
										"p1uni",
										"p1residence2",
										"p1farm",
										"p1residence1",
										"p1residence4",
										"p1vc",
										"p1hq"},
								[2] = {	"p2bank",
										"p2market",
										"p2tower",
										"p2uni",
										"p2residence3",
										"p2residence2",
										"p2farm",
										"p2residence1",
										"p2farm",
										"p2vc",
										"p2hq"}}
GetNextBuildingPriority = function(_player)
	for i = 1, table.getn(BuildingAttackPriorityList[_player]) do
		if IsValid(BuildingAttackPriorityList[_player][i]) then
			return BuildingAttackPriorityList[_player][i]
		end
	end
end
ControlAttackingInvaders = function(_player)
	if not AreEntitiesOfCategoriesAndDiplomacyStateInArea(_player, EntityCategories.Leader, GetPosition("p".. _player .."hq"), 3000, Diplomacy.Hostile) then
		for i = 1, table.getn(Attackers[_player]) do
			local target = GetNextBuildingPriority(_player)
			if target then
				Logic.GroupAttack(Attackers[_player][i], Logic.GetEntityIDByName(target))
			end
		end
	end
end
PlayerEntitiesInvulnerable_IsActive = {}
----------------------------------------------------------------------------------------------------------
function MakePlayerEntitiesInvulnerableLimitedTime(_PlayerID, _Timelimit)
	if not Counter.Tick2("MakePlayerEntitiesInvulnerableLimitedTime_Ticker".. _PlayerID, _Timelimit) then
		if not PlayerEntitiesInvulnerable_IsActive[_PlayerID] then
			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_PlayerID)) do
				MakeInvulnerable(eID)
			end
		PlayerEntitiesInvulnerable_IsActive[_PlayerID] = true
		end
	else
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_PlayerID)) do
			MakeVulnerable(eID)
		end
		PlayerEntitiesInvulnerable_IsActive[_PlayerID] = nil
		return true
	end
end
function AntiSpawnCampTrigger()

	local attacker = Event.GetEntityID1()
    local target = Event.GetEntityID2()
	local targetpos = GetPosition(target)
	local pID = GetPlayer(target)

	if pID == 7 then
		for i = 1,3 do
			if math.abs(GetDistance(targetpos,GetPosition("cave"..i))) <= 2000 then
				CEntity.TriggerSetDamage(0)
			end
		end
	end

end
function SetUpGameLogicOnMPGameConfigLight()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Transfer player names
	do
		for PlayerID=1, HumenPlayer, 1 do
			local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
			Logic.SetPlayerRawName( PlayerID, PlayerName )
		end
	end

	-- Set game state & human flag - transfer player color (needed in logic for post game statistics)
	do
		for PlayerID=1, HumenPlayer, 1 do
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 1 then
				Logic.PlayerSetGameStateToPlaying( PlayerID )
				Logic.PlayerSetIsHumanFlag( PlayerID, 1 )

				local PlayerColorR, PlayerColorG, PlayerColorB = GUI.GetPlayerColor( PlayerID )
				Logic.PlayerSetPlayerColor( PlayerID, PlayerColorR, PlayerColorG, PlayerColorB )
			end
		end
	end

	-- Set up FoW
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig()


	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)

	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	--Extra keybings only in MP
	Input.KeyBindDown(Keys.NumPad0, "KeyBindings_MPTaunt(1,1)", 2)  --Yes
	Input.KeyBindDown(Keys.NumPad1, "KeyBindings_MPTaunt(2,1)", 2)  --No
	Input.KeyBindDown(Keys.NumPad2, "KeyBindings_MPTaunt(3,1)", 2)  --Now
	Input.KeyBindDown(Keys.NumPad3, "KeyBindings_MPTaunt(7,1)", 2)  --help
	Input.KeyBindDown(Keys.NumPad4, "KeyBindings_MPTaunt(8,1)", 2)  --clay
	Input.KeyBindDown(Keys.NumPad5, "KeyBindings_MPTaunt(9,1)", 2)  --gold
	Input.KeyBindDown(Keys.NumPad6, "KeyBindings_MPTaunt(10,1)", 2) --iron
	Input.KeyBindDown(Keys.NumPad7, "KeyBindings_MPTaunt(11,1)", 2) --stone
	Input.KeyBindDown(Keys.NumPad8, "KeyBindings_MPTaunt(12,1)", 2) --sulfur
	Input.KeyBindDown(Keys.NumPad9, "KeyBindings_MPTaunt(13,1)", 2) --wood

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "KeyBindings_MPTaunt(5,1)", 2)  --attack here
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "KeyBindings_MPTaunt(6,1)", 2)  --defend here

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "KeyBindings_MPTaunt(4,0)", 2)  --attack you
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad3, "KeyBindings_MPTaunt(14,0)", 2) --VeryGood
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_MPTaunt(15,0)", 2) --Lame
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_MPTaunt(16,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_MPTaunt(17,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_MPTaunt(18,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_MPTaunt(19,0)", 2) --funny comments

end 