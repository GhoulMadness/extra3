--------------------------------------------------------------------------------
-- MapName: (2) Dritte Prüfung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
sub_armies_aggressive = 0
main_armies_aggressive = 0
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 .......... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Dritte Prüfung - Gesandter des Himmels "
gvMapVersion = " v1.21"
AttackTarget = {X = 49100,
				Y = 39200}
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- Include Cutscene control
	Script.Load("maps/externalmap/Cutscene_Control.lua")


	SetPlayerName(3, "Barmecia")
	SetPlayerName(4, "Cleycourt")
	SetPlayerName(5, "Räuber")
	SetPlayerName(6, "Invasoren")
	SetPlayerName(8, "Coleshill")

	-- custom Map Stuff
	TagNachtZyklus(24,1,0,-4,1)
	StartTechnologies()
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

	if not CNetwork then
		Logic.ChangeAllEntitiesPlayerID(2, 1)
	end

	-- Init  global MP stuff
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end

	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	end

	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
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
	Logic.SetCurrentMaxNumWorkersInBuilding(Logic.GetEntityIDByName("Trader1"), 0)
	Logic.SetCurrentMaxNumWorkersInBuilding(Logic.GetEntityIDByName("Trader2"), 0)
	Logic.SetCurrentMaxNumWorkersInBuilding(Logic.GetEntityIDByName("Trader3"), 0)
	Logic.SetCurrentMaxNumWorkersInBuilding(Logic.GetEntityIDByName("Trader4"), 0)

	XGUIEng.ShowWidget("SettlerServerInformation", 0)
	XGUIEng.ShowWidget("SettlerServerInformationExtended", 0)

	StartTechnologies()

	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	TributeP1_Challenge()

	local pos = GetPlayerStartPosition()
	Camera.ScrollSetLookAt(pos.X, pos.Y)

end
function AnfangsBriefingInitialize()
	ActivateBriefingsExpansion()
	AnfangsBriefing()
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
function TributeP1_Challenge()
	local TrP1_C =  {}
	TrP1_C.playerId = 1
	TrP1_C.text = "Klickt hier, um den @color:255,0,0 Herausforderungs- @color:255,255,255 Spielmodus zu spielen"
	TrP1_C.cost = { Gold = 0 }
	TrP1_C.Callback = TributePaid_P1_Challenge
	TP1_C = AddTribute(TrP1_C)
end
function IsUsingRules(_requiredPairs, _optionalPairs, _minPatchLevel)
    local dec = CustomStringHelper.FromString(XNetwork.EXTENDED_GameInformation_GetCustomString());
    local keys = CustomStringHelper.GetKeys(dec);
    local wrong = {};

    if keys then

        local patchlevel = keys["PATCHLEVEL"] or 0;
        keys["PATCHLEVEL"] = nil;

        if patchlevel < _minPatchLevel then
            table.insert(wrong, "patchlevel mismatch: minimum required: " .. _minPatchLevel .. " got: " .. patchlevel);
        end;

        for key, value in pairs(_requiredPairs) do
            if keys[key] == value then
                keys[key] = nil;
            else
                table.insert(wrong, "pair: " .. key .. " value: " .. tostring(value) .. " expected: " .. tostring(keys[key]));
                keys[key] = nil;
            end;
            _requiredPairs[key] = nil;
        end;

        for key, value in pairs(_requiredPairs) do
            table.insert(wrong, "missing required pair: " .. key .. "" .. key .. " " .. tostring(value));
        end;

        for key, value in pairs(_optionalPairs) do
            if keys[key] == value then
                keys[key] = nil;
            elseif keys[key] ~= nil then
                keys[key] = nil;
                table.insert(wrong, "mismatched optional pair: " .. key .. " value: " .. tostring(value) .. " expected: " .. tostring(keys[key]));
            end;
        end;

        for key, value in pairs(keys) do
            table.insert(wrong, "additional pair: " .. tostring(key));
        end;
    end;
    return table.getn(wrong) > 0, wrong;
end;


local required = {
    ["RELOAD_FIX"] = true;
};
local optional = {
    ["CHAIN_CONSTRUCTION"] = true;
};
function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 3.0

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
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 2.2

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
	gvDiffLVL = 1.6

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
function TributePaid_P1_Challenge()
	Message("Ihr habt euch für den @color:255,0,0 Herausforderungs-	@color:255,255,255 Spielmodus entschieden! Achtung: Auf dieser Stufe ist diese Karte extrem schwer!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	gvDiffLVL = 1.1
	gvChallengeFlag = 1

	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 HERAUSFORDERUNG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function StartInitialize()
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero2", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero5", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero6", 0)

	ChestsInit()
	StartSimpleJob("ChestControl")

	local tab = ChestRandomPositions.CreateChests(15)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	do
		for i = 1,6 do
			Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc"..i), 1)
		end
	end

	StartSimpleJob("NPCControl")

	StartSimpleJob("ColeshillAggressionCheck")

	SetupPlayerAi( 5, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	--
	ChangePlayer(({Logic.GetEntities(Entities.CB_RuinDome, 1)})[2], 5)
	--
	CreateArmyP5_1()
	CreateArmyP5_2()
	CreateArmyP5_3()
	CreateArmyP5_4()
	CreateArmyP5_5()
	CreateArmyP5_6()
	CreateArmyP5_7()
	CreateArmyP5_8()
	CreateArmyP5_9()
	MapEditor_SetupAI(3, 1, 7500, 1, "Barmecia_HQ", 1, 0)
	MapEditor_SetupAI(4, 1, 6000, 1, "CleycourtCastle", 3, 0)
	MapEditor_SetupAI(8, math.ceil(4 - gvDiffLVL), math.ceil(4000/gvDiffLVL), math.ceil(3 - gvDiffLVL), "HQP8", math.ceil(4 - gvDiffLVL), 1200*gvDiffLVL)
	SetupPlayerAi( 3, {constructing = true, extracting = 0, repairing = true, serfLimit = 15} )
	SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 12} )
	SetupPlayerAi( 6, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 7, {constructing = true, extracting = false, repairing = true, serfLimit = 0} )
	SetupPlayerAi( 8, {constructing = true, extracting = false, repairing = true, serfLimit = 12} )
	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
		SetFriendly(1,2)
		for i = 1,2 do
			SetFriendly(i,3)
			SetNeutral(i,4)
			SetNeutral(i,7)
			SetNeutral(i,8)
		end
	else
		SetHostile(1,5)
		SetFriendly(1,3)
		SetNeutral(1,4)
		SetNeutral(1,7)
		SetNeutral(1,8)
	end
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	Mission_InitGroups()

	StartSimpleJob("DefeatJob")

	Terrain_Pointer = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, Logic.GetEntityPosition(Logic.GetEntityIDByName("Dome_Pos")))

	StartCountdown(10*60*gvDiffLVL,UpgradeKIa,false)
	DefeatTimerID = StartCountdown((40 + 30 * gvDiffLVL)*60, DefeatTimer, true)
	CleycourtPrepareTroopsTimerID = StartCountdown((20 + 25 * gvDiffLVL)*60, CleycourtPrepareTroopsTimer, false)

	SetPlayerName(3, "Barmecia")
	SetPlayerName(4, "Cleycourt")
	SetPlayerName(5, "Räuber")
	SetPlayerName(6, "Invasoren")
	SetPlayerName(8, "Coleshill")

	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end

	GameCallback_OnBuildingConstructionCompleteOrig2 = GameCallback_OnBuildingConstructionComplete
	---------------- function override on this map ------------------
	function GameCallback_OnBuildingConstructionComplete(_BuildingID, _PlayerID)

		local eType = Logic.GetEntityType(_BuildingID)

		if eType == Entities.PB_Dome then
			GameCallback_OnBuildingConstructionCompleteOrig(_BuildingID, _PlayerID)
			local MotiHardCap = CUtil.GetPlayersMotivationHardcap(_PlayerID)
			CUtil.AddToPlayersMotivationHardcap(_PlayerID, 1)
			local pos = GetPosition(_BuildingID)
			if GetDistance(pos, GetPosition("Dome_Pos")) <= 1000 then
				Message("Sehr gut! Ihr habt den Dom rechtzeitig errichtet! @cr Haltet ihn nun mindestens 10 Minuten gegenüber allen einfallenden Feinden!")
				gvDomePos = pos
				Sound.PlayGUISound(Sounds.Misc_Chat2,100)
				for i = 1,999 do
					if Counter["counter"..i] then
						if Counter["counter"..i].Show then
							timeb4end = (Counter["counter"..i].Limit - Counter["counter"..i].TickCount)
							break
						end
					end
				end
				StopCountdown(DefeatTimerID)
				StartSimpleHiResJob("StartDomeBuiltActions")
			end

		elseif eType == Entities.PB_SilverMine1 then
			GameCallback_OnBuildingConstructionCompleteOrig(_BuildingID,_PlayerID)
			BanditsPrepareAttack(GetPosition(_BuildingID))

		else
			GameCallback_OnBuildingConstructionCompleteOrig2(_BuildingID, _PlayerID)

		end
	end
	function DomePlaced(_posX,_posY)

		if GetDistance({X = _posX, Y = _posY}, GetPosition("Dome_Pos")) <= 1000 then
			DomeVision(_posX,_posY)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "DomeFallen", 1)
			Logic.DestroyEffect(Terrain_Pointer)
			return true
		else
			return true
		end

	end
	function DomeVictory()
		if Logic.GetNumberOfEntitiesOfType(Entities.PB_Dome) == 0 then
			return
		end
		StopCountdown(SpawnCounter)
		StartSimpleJob("VictoryJob")
		Message("Hervorragend! Ihr habt den Dom 10 Minuten lang halten können. @cr Besiegt nun alle verbleibenden Invasoren und Banditen, um die Karte zu gewinnen!")
	end

	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
	end

	if not gvChallengeFlag then
		StartCutscene("Intro", AnfangsBriefingInitialize)
	else
		AnfangsBriefingInitialize()
	end
end
function StartDomeBuiltActions()
	StartCountdown(10*60,DomeVictory,true,"Dome_Victory")
	StartWinter(999)
	for i = 1,2 do
		ForbidTechnology(Technologies.T_MakeSummer, i)
		ForbidTechnology(Technologies.T_MakeRain, i)
		ForbidTechnology(Technologies.T_MakeThunderstorm, i)
		SetHostile(i,6)
	end
	if not gvVillage8MissionsSolved then
		for i = 1,2 do
			SetHostile(i,8)
		end
		SetHostile(3,8)
		MapEditor_Armies[8].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
		MapEditor_Armies[8].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{8, 30 / gvDiffLVL})
	end
	if not gvVillage4MissionsSolved then
		for i = 1,2 do
			SetHostile(i,4)
			Logic.SetShareExplorationWithPlayerFlag(i, 4, 0)
		end
		SetHostile(3,4)
		MapEditor_Armies[4].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
		MapEditor_Armies[4].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{4, 30 / gvDiffLVL})
	else
		SetHostile(6,4)
	end

	SetHostile(3,5)
	SetHostile(3,6)

	TroopSpawnVorb()
	StartSimpleJob("AIIdleScan")
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{6, 10 / gvDiffLVL})
	for i = 1,9 do
		_G["armyP5_"..i].rodeLength = Logic.WorldGetSize()
	end
	return true
end
function VictoryJob()
	if Logic.GetNumberOfEntitiesOfType(Entities.PB_Dome) == 0 then
		return true
	end
	if (AI.Player_GetNumberOfLeaders(5) + AI.Player_GetNumberOfLeaders(6)) == 0 then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map3_won", 2)
				end
			end
		end
		Victory()
		return true
	end
end
function ChestsInit()
	Chests = {}
	for i = 1,12 do
		Chests[i] = false
	end
	Chests[13] = true
	do
		local count = 0
		while count < 5 do
			local randval = math.random(1,12)
			if not Chests[randval] then
				Chests[randval] = true
				count = count + 1
			end
		end
	end
	do
		local pos = {}
		for i = 1,12 do
			if Chests[i] then
				pos[i] = GetPosition("RandomChest"..i)
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold,pos[i].X,pos[i].Y,0,0), "Chest"..i)
			end
		end
		pos[13] = GetPosition("hidden_chest")
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold,pos[13].X,pos[13].Y,0,0), "HiddenChest")
	end
end

function ChestControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, randomEventAmount
		for i = 1,13 do
			if  Chests[i] then
				if i ~= 13 then
					pos = 	GetPosition("Chest"..i)
					for j = 1, 2 do
						entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
						if entities[1] > 0 then
							if Logic.IsHero(entities[2]) == 1 then
								randomEventAmount = round((750 + math.random(350)) * gvDiffLVL)
								Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
								Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" )
								Sound.PlayGUISound(Sounds.Misc_Chat2,100)
								Chests[i] = false
								ReplacingEntity("Chest"..i, Entities.XD_ChestOpen)
							end
						end
					end
				else
					pos = 	GetPosition("HiddenChest")
					for j = 1, 2 do
						entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
						if entities[1] > 0 then
							if Logic.IsHero(entities[2]) == 1 then
								randomEventAmount = round((350 + math.random(150)) * gvDiffLVL)
								Logic.AddToPlayersGlobalResource(j,ResourceType.Silver,randomEventAmount)
								Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Silber" )
								Sound.PlayGUISound(Sounds.Misc_Chat2,100)
								Chests[i] = false
								ReplacingEntity("Chest"..i, Entities.XD_ChestOpen)
								StartCountdown(10, ColeshillChestPlundered, false)
							end
						end
					end
				end
			end
		end
	end
end
function ColeshillAggressionCheck()
	local minescount = 0
	local treecount = 0
	local unitscount = 0
	local aggressionpointsneeded = 15000 * gvDiffLVL
	if ({Logic.GetEntitiesInArea(Entities.PB_ClayMine1, 41500, 59600, 6500, 1)})[1] >= 1 or ({Logic.GetEntitiesInArea(Entities.PB_ClayMine2, 41500, 59600, 6500, 1)})[1] >= 1 or ({Logic.GetEntitiesInArea(Entities.PB_ClayMine3, 41500, 59600, 6500, 1)})[1] >= 1 then
		minescount = minescount + 1
	end
	if ({Logic.GetEntitiesInArea(Entities.PB_IronMine1, 41500, 59600, 6500, 1)})[1] >= 1 or ({Logic.GetEntitiesInArea(Entities.PB_IronMine2, 41500, 59600, 6500, 1)})[1] >= 1 or ({Logic.GetEntitiesInArea(Entities.PB_IronMine3, 41500, 59600, 6500, 1)})[1] >= 1 then
		minescount = minescount + 1
	end

	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_TreeStump1), CEntityIterator.InCircleFilter(41500, 59600, 6500)) do
		treecount = treecount + 1
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1, 2), CEntityIterator.IsSettlerOrBuildingFilter(), CEntityIterator.InCircleFilter(52000, 55700, 6000)) do
		unitscount = unitscount + 1
	end
	if (minescount * 7000) + (treecount * 40) + (unitscount * 5000) + (Score.Player[1].all + Score.Player[2].all) >= aggressionpointsneeded then
		Message("Coleshill ist durch Euer Expansionsgehabe erzürnt!")
		Sound.PlayGUISound(Sounds.OnKlick_Select_varg , 140)
		NPCs[7] = true
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc7"), 1)
		ColeshillTimerID = StartCountdown(6 * 60 * gvDiffLVL, ColeshillTimer, false)
		return true
	end
end
function ColeshillTimer()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Outpost2) == 0 then
		return
	end
	for i = 1,2 do
		SetHostile(i, 8)
	end
	if CNetwork then
		Logic.RemoveTribute(2, TNPC7_1)
	else
		Logic.RemoveTribute(1, TNPC7_1)
	end
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Anführer von Coleshill",
        text	= "@color:230,0,0 All Eure Aggressionen... @cr @cr Wir lassen das nun nicht länger auf uns sitzen. @cr Männer, lasst uns ihnen eine Lektion erteilen!",
		position = GetPosition("npc7"),
		action = function()
			NPCs[7] = false
			Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc7"), 0)
			if gvVillage8MissionsSolved then
				gvVillage8MissionsSolved = nil
			end
			for i = 1,2 do
				SetHostile(i, 8)
			end
			MapEditor_Armies[8].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
			MapEditor_Armies[8].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
			MapEditor_Armies[8].offensiveArmies.strength = MapEditor_Armies[8].offensiveArmies.strength + round(6/gvDiffLVL)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{8, 30 / gvDiffLVL})
		end
	}

    StartBriefing(briefing)
end
function ColeshillChestPlundered()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Outpost2) == 0 then
		return
	end
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Anführer von Coleshill",
        text	= "@color:230,0,0 Männer, zu den Waffen! @cr Fremde haben unsere Schätze dreist geplündert.",
		position = GetPosition("npc7"),
		action = function()
			NPCs[7] = false
			Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc7"), 0)
			if gvVillage8MissionsSolved then
				gvVillage8MissionsSolved = nil
			end
			StopCountdown(ColeshillTimerID)
			for i = 1,2 do
				SetHostile(i, 8)
			end
			for i = 1,2 do
				Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,8)
				Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,8)
			end
			MapEditor_Armies[8].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
			MapEditor_Armies[8].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
			MapEditor_Armies[8].offensiveArmies.strength = MapEditor_Armies[8].offensiveArmies.strength + round(8/gvDiffLVL)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{8, 40 / gvDiffLVL})
		end
	}

    StartBriefing(briefing)

end
NPCs = {}
for i = 1,6 do
	NPCs[i] = true
end
--
NPCs[7] = false --Anführer von Coleshill
NPCs[8] = false --entführter Händler
NPCs[9] = false	--Pilgrim
NPCs[10] = false	--Ari
NPCs[11] = false	--Bürgermeister von Barmecia
function NPCControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, name
		for i = 1,11 do
			if  NPCs[i] then
				if i <= 8 then
					pos = 	GetPosition("npc"..i)
					name = "npc"..i
				else
					if i == 9 then
						pos = GetPosition("Pilgrim")
						name = "Pilgrim"
					elseif i == 10 then
						pos = GetPosition("Ari")
						name = "Ari"
					elseif i == 11 then
						pos = GetPosition("BarmeciaMayor")
						name = "BarmeciaMayor"
					end
				end
				for j = 1, 2 do
					entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)}
					if entities[1] > 0 then
						if Logic.IsHero(entities[2]) == 1 then
							NPCs[i] = false
							Logic.SetOnScreenInformation(Logic.GetEntityIDByName(name), 0)
							_G["NPCBriefing"..i]()
							break
						end
					end
				end
			end
		end
	end
end
function NPCBriefing1()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Geselle",
        text	= "@color:230,0,0 Bitte hilf mir! Mein Meister wurde von Räubern gefangen genommen!",
		position = GetPosition("npc1")
    }
	AP{
        title	= "@color:230,120,0 Geselle",
        text	= "@color:230,0,0 Bitte sucht die Räuber und befreit meinen Meister. @cr Ich alleine komme gegen sie nicht an!",
		position = GetPosition("npc1")

    }
	AP{
        title	= "@color:230,120,0 Aufgabe des Gesellen",
        text	= "@color:230,0,0 Aufgabe: @cr 1) Rettet den Händler @cr  @cr Hinweise: @cr - Die Räuber sind sehr brutal - Seit vorsichtig wenn Ihr Euch Ihnen nähert. @cr - Der Geselle hat beobachtet wie sein Meister aus einem nahen Räuberlager verschleppt wurde...",
		position = GetPosition("npc1"),
		action = function()
			StartSimpleJob("RescueMerchantJob")
		end

    }

    StartBriefing(briefing)
end
function RescueMerchantJob()
	if ({Logic.GetEntities(Entities.CB_Tower1, 1)})[1] == 0 then
		if IsDead(armyP5_6) and IsDead(armyP5_7) then
			CreateEntity(7, Entities.CU_Trader, {X = 32200, Y = 62800}, "npc8")
			TraderRescuedBriefing()
			return true
		end
	end
end
function TraderRescuedBriefing()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Habt vielen Dank - Ihr habt mir das Leben gerettet. Ich stehe tief in Eurer Schuld!",
		position = GetPosition("npc8")
    }
	AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Besucht mich erneut an meinem Markt und schauet meine Waren!",
		position = GetPosition("npc8"),
		action = function()
			Move("npc8","npc1")
			StartSimpleJob("RescuedMerchantArrivedJob")
		end

    }

    StartBriefing(briefing)
end
function RescuedMerchantArrivedJob()
	if IsNear("npc8","npc1",500) then
		NPCs[8] = true
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc8"),1)
		return true
	end
end
function NPCBriefing2()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Guten Tag der Herr! @cr Auf der Suche nach Preisen, die es sonst nirgends gibt?",
		position = GetPosition("npc2")
    }
	 AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Schaut in Euer Tributmenü, um meine Angebote zu sehen!",
		position = GetPosition("npc2"),
		action = function()
			TributeNPC2_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC2_1()
	local TrNPC2_1 =  {}
	TrNPC2_1.playerId = 1
	TrNPC2_1.text = "Zahlt ".. round(1000/gvDiffLVL) .." Taler für 500 Schwefel"
	TrNPC2_1.cost = { Gold = round(1000/gvDiffLVL) }
	TrNPC2_1.Callback = TributePaid_NPC2_1
	TNPC2_1 = AddTribute(TrNPC2_1)
end
function TributePaid_NPC2_1()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Sulfur, 500)
	TributeNPC2_2()
end
function TributeNPC2_2()
	local TrNPC2_2 =  {}
	TrNPC2_2.playerId = 1
	TrNPC2_2.text = "Zahlt ".. round(2000/gvDiffLVL) .." Taler für 600 Schwefel"
	TrNPC2_2.cost = { Gold = round(2000/gvDiffLVL) }
	TrNPC2_2.Callback = TributePaid_NPC2_2
	TNPC2_2 = AddTribute(TrNPC2_2)
end
function TributePaid_NPC2_2()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Sulfur, 600)
	TributeNPC2_2()
end
function NPCBriefing3()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 MoinMoin! @cr Benötigt ihr Steine? Ich mache Euch gute Preise!",
		position = GetPosition("npc3")
    }
	 AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Schaut in Euer Tributmenü, um meine Angebote zu sehen!",
		position = GetPosition("npc3"),
		action = function()
			TributeNPC3_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC3_1()
	local TrNPC3_1 =  {}
	TrNPC3_1.playerId = 1
	TrNPC3_1.text = "Zahlt ".. round(1800/gvDiffLVL) .." Lehm für 1000 Steine"
	TrNPC3_1.cost = { Clay = round(1800/gvDiffLVL) }
	TrNPC3_1.Callback = TributePaid_NPC3_1
	TNPC3_1 = AddTribute(TrNPC3_1)
end
function TributePaid_NPC3_1()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Stone, 1000)
	TributeNPC3_2()
end
function TributeNPC3_2()
	local TrNPC3_2 =  {}
	TrNPC3_2.playerId = 1
	TrNPC3_2.text = "Zahlt ".. round(3000/gvDiffLVL) .." Lehm für 1200 Steine"
	TrNPC3_2.cost = { Clay = round(3000/gvDiffLVL) }
	TrNPC3_2.Callback = TributePaid_NPC3_2
	TNPC3_2 = AddTribute(TrNPC3_2)
end
function TributePaid_NPC3_2()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Stone, 1200)
	TributeNPC3_2()
end
function NPCBriefing4()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Zwielichtiger Händler",
        text	= "@color:230,0,0 Kundschaft seehr gut! @cr Habt ihr Holz über? Ich gebe Euch dafür feinstes Eisen!",
		position = GetPosition("npc4")
    }
	 AP{
        title	= "@color:230,120,0 Zwielichtiger Händler",
        text	= "@color:230,0,0 Schaut in Euer Tributmenü, um meine Angebote zu sehen!",
		position = GetPosition("npc4"),
		action = function()
			TributeNPC4_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC4_1()
	local TrNPC4_1 =  {}
	TrNPC4_1.playerId = 1
	TrNPC4_1.text = "Zahlt ".. round(800/gvDiffLVL) .." Holz für 400 Eisen"
	TrNPC4_1.cost = { Wood = round(800/gvDiffLVL) }
	TrNPC4_1.Callback = TributePaid_NPC4_1
	TNPC4_1 = AddTribute(TrNPC4_1)
end
function TributePaid_NPC4_1()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Iron, 400)
	TributeNPC4_2()
end
function TributeNPC4_2()
	local TrNPC4_2 =  {}
	TrNPC4_2.playerId = 1
	TrNPC4_2.text = "Zahlt ".. round(1200/gvDiffLVL) .." Holz für 500 Eisen"
	TrNPC4_2.cost = { Wood = round(1200/gvDiffLVL) }
	TrNPC4_2.Callback = TributePaid_NPC4_2
	TNPC4_2 = AddTribute(TrNPC4_2)
end
function TributePaid_NPC4_2()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Iron, 500)
	TributeNPC4_3()
end
function TributeNPC4_3()
	local TrNPC4_3 =  {}
	TrNPC4_3.playerId = 1
	TrNPC4_3.text = "Zahlt ".. round(2200/gvDiffLVL) .." Holz für 800 Eisen"
	TrNPC4_3.cost = { Wood = round(2200/gvDiffLVL) }
	TrNPC4_3.Callback = TributePaid_NPC4_3
	TNPC4_3 = AddTribute(TrNPC4_3)
end
function TributePaid_NPC4_3()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Iron, 800)
	TributeNPC4_3()
end
function NPCBriefing5()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Helias",
        text	= "@color:230,0,0 Gut Euch zu sehen mein alter Freund!",
		position = GetPosition("npc5")
    }
	AP{
        title	= "@color:230,120,0 Helias",
        text	= "@color:230,0,0 Wo ihr schonmal hier seid: @cr Sichert doch bitte unsere Handelsrouten und besiegt das Räuberlager im Nordosten.",
		position = GetPosition("npc5")
    }
	AP{
        title	= "@color:230,120,0 Aufgaben von Helias",
        text	= "@color:230,0,0 Besiegt das Räuberlager im Nordosten von Barmecia!",
		position = GetPosition("npc5"),
		action = function()
			StartSimpleJob("RobbersCampNortheast")
		end
    }

    StartBriefing(briefing)
end
function RobbersCampNortheast()
	if IsDestroyed("BanditsTower9") and IsDead(armyP5_9) then
		ActivateShareExploration(1, 3, true)
		ActivateShareExploration(2, 3, true)
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end
		AP{
			title	= "@color:230,120,0 Helias",
			text	= "@color:230,0,0 Habt Dank! @cr Die Handelsroute zu den Steinbrüchen ist nun wieder sicher.",
			position = GetPosition("npc5")
		}
		AP{
			title	= "@color:230,120,0 Helias",
			text	= "@color:230,0,0 Tut ihr mir bitte noch einen Gefallen? @cr Geht zu den Steinbrüchen und schaut nach dem Rechten!",
			position = GetPosition("npc5")
		}
		AP{
			title	= "@color:230,120,0 Aufgaben von Helias",
			text	= "@color:230,0,0 1) Sucht einen Mann namens Pilgrim. @cr Ihr findet ihn bei den Steinbrüchen im Südosten.",
			position = GetPosition("npc5"),
			action = function()
				NPCs[9] = true
				Logic.SetOnScreenInformation(Logic.GetEntityIDByName("Pilgrim"), 1)
				if CNetwork then
					ChangePlayer("npc5", 2)
				else
					ChangePlayer("npc5", 1)
				end
			end
		}

		StartBriefing(briefing)

		return true
	end

end
function NPCBriefing6()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Bürgermeister von Cleycourt",
        text	= "@color:230,0,0 Guten Tag der Herr. @cr @cr Räuberbanden machen die gesamte Gegend unsicher. Wie uns zu Ohren gekommen ist, werden sie von einer jungen Frau angeführt.",
		position = GetPosition("npc6")
    }
	AP{
        title	= "@color:230,120,0 Bürgermeister von Cleycourt",
        text	= "@color:230,0,0 Tut uns doch bitte den Gefallen und nehmt sie gefangen. @cr Sie soll sich in einem abgelegenen Lager im Süden aufhalten und von dort die Raubzüge planen.",
		position = GetPosition("npc6")
    }
	AP{
        title	= "@color:230,120,0 Aufgaben des Bürgermeisters von Cleycourt",
        text	= "@color:230,0,0 1) Nehmt die Anführerin der Räuber gefangen und bringt sie zum Bürgermeister von Cleycourt.",
		position = GetPosition("npc6"),
		action = function()
			StartSimpleJob("AriCaptured")
		end
    }

    StartBriefing(briefing)
end
function AriCaptured()
	if IsDestroyed("BanditsTower8") and IsDead(armyP5_8) then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end
		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Ausgezeichnet, Sire. @cr Ihr habt die Anführerin der Räuber gefangen genommen.",
			position = GetPosition("Ari")
		}
		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 Nun liegt es an Euch, wie Ihr mit ihr verfahrt... @cr @cr Bringt sie entweder @cr 1) zum Bürgermeister von Cleycourt, wo sie zur Rechenschaft gezogen wird...",
			position = GetPosition("npc6")
		}
		AP{
			title	= "@color:230,120,0 Mentor",
			text	= "@color:230,0,0 ... oder @cr 2) flüchtet mit ihr über den nahen Bergpass. @cr Sie wird sich sicherlich erkenntlich zeigen...",
			position = {X = 15000,
						Y = 7850},
			action = function()
				SetupNPCSystem()
				NPCTable_Heroes = {}
				Logic.SetOnScreenInformation(Logic.GetEntityIDByName("Ari"), 1)
				StartSimpleJob("HeroNearAri")

				function UpdateHeroesTable_Extra()

					local heroes = {Entities.PU_Hero1, Entities.PU_Hero1a, Entities.PU_Hero1b, Entities.PU_Hero1c, Entities.PU_Hero2, Entities.PU_Hero3, Entities.PU_Hero4, Entities.PU_Hero5, Entities.PU_Hero6, Entities.PU_Hero10, Entities.PU_Hero11,
									Entities.PU_Hero12, Entities.PU_Hero13, Entities.CU_Mary_de_Mortfichet, Entities.CU_BlackKnight, Entities.CU_Barbarian_Hero, Entities.CU_Evil_Queen}
					for i = 1,2 do
						for k,v in pairs(heroes) do
							local num, id = Logic.GetPlayerEntities(i, v, 1)
							if num > 0 then
								if table_findvalue(NPCTable_Heroes, id) == 0 then
									table.insert(NPCTable_Heroes, id)
								end
							end
						end
					end
				end
				GetNearestHero = function(_NPC, _MaxDistance)
					-- Get all heroes
					UpdateHeroesTable_Extra()
					local bestDistance
					-- Get distances for valid heroes
					if _MaxDistance == nil then
						bestDistance = 1000000000000000
					else
						bestDistance = _MaxDistance*_MaxDistance
					end
					local bestHero

					-- Get position of NPC
					local PosX,PosY = Tools.GetPosition(_NPC)


					-- for all heroes
					local i
					for i = 1, table.getn(NPCTable_Heroes) do

						-- Valid hero
						if NPCTable_Heroes[i] ~= nil and IsAlive(NPCTable_Heroes[i]) then

							-- Get position of hero
							local HeroPosX,HeroPosY = Tools.GetPosition(NPCTable_Heroes[i])

							local DeltaX = HeroPosX-PosX
							local DeltaY = HeroPosY-PosY
							-- Get distance
							local Distance = (DeltaX*DeltaX)+(DeltaY*DeltaY)

							-- Is better than best
							if Distance < bestDistance then

								bestDistance = Distance
								bestHero = i

							end

						end

					end
					-- Return best hero
					if bestHero ~= nil then
						return NPCTable_Heroes[bestHero]
					else
						return nil
					end
				end
			end
		}

		StartBriefing(briefing)

		return true
	end
end
function HeroNearAri()
	local entities, pos, name
	pos = GetPosition("Ari")
	name = "Ari"

	for j = 1, 2 do
		entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)};
		if entities[1] > 0 then
			if Logic.IsHero(entities[2]) == 1 then
				InitNPC("Ari")
				SetNPCFollow("Ari",entities[2],500,10000,nil)
				StartSimpleJob("AriNearObjective")
				return true
			end
		end
	end
end
function AriNearObjective()
	if GetDistance(GetPosition("Ari"), GetPosition("npc6")) <= 600 then
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end
		AP{
			title	= "@color:230,120,0 Bürgermeister von Cleycourt",
			text	= "@color:230,0,0 Sehr gut. @cr Ihr habt die Anführerin der Räuberbande zu mir gebracht.",
			position = GetPosition("npc6"),
			action = function()
				ActivateShareExploration(1,4, true)
				ActivateShareExploration(2,4, true)
			end
		}
		AP{
			title	= "@color:230,120,0 Bürgermeister von Cleycourt",
			text	= "@color:230,0,0 Sorgen wir dafür, dass die umliegenden Räuberbanden verängstigt werden und statuieren an ihr ein Exempel.",
			position = GetPosition("npc6"),
			action = function()
				ChangePlayer("Ari", 5)
				SetHostile(4, 5)
				CreateMilitaryGroup(4, Entities.PU_LeaderPoleArm4, 12, GetPosition("Ari"), "AriAttacker")
				Attack("AriAttacker","Ari")
				StartSimpleJob("AriDeathCheck")
				StartCountdown(120, CleycourtVillageBrief2, false)
			end
		}

		StartBriefing(briefing)
		return true
	end
	if GetDistance(GetPosition("Ari"), {X = 15900, Y = 11050}) <= 800 then
		ChangePlayer("Ari", 7)
		NPCs[10] = true
		return true
	end

end
function AriDeathCheck()
	if IsDead("Ari") then
		if Counter.Tick2("AriDeathCheck_Counter", 10) then
			DestroyEntity("Ari")
			return true
		end
	end
end
function CleycourtVillageBrief2()
	NPCs[6] = true
	Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc6"), 1)
	NPCBriefing6 = function()
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end
		AP{
			title	= "@color:230,120,0 Bürgermeister von Cleycourt",
			text	= "@color:230,0,0 Guten Tag der Herr. @cr @cr Ich möchte Euch erneut um etwas bitten.",
			position = GetPosition("npc6")
		}
		AP{
			title	= "@color:230,120,0 Bürgermeister von Cleycourt",
			text	= "@color:230,0,0 Wir würden gerne unsere Siedlung ausbauen, jedoch fehlen uns dafür einige Ressourcen...",
			position = GetPosition("npc6")
		}
		AP{
			title	= "@color:230,120,0 Aufgaben des Bürgermeisters von Cleycourt",
			text	= "@color:230,0,0 2) Entsendet Holz und Eisen nach Cleycourt, sodass sie ihre Militärstärke weiter ausbauen können.",
			position = GetPosition("npc6"),
			action = function()
				TributeNPC6_1()
			end
		}

		StartBriefing(briefing)
	end
end
function TributeNPC6_1()
	local TrNPC6_1 =  {}
	if not CNetwork then
		TrNPC6_1.playerId = 1
	else
		TrNPC6_1.playerId = 2
	end
	TrNPC6_1.text = "Zahlt ".. round(8000/gvDiffLVL) .." Eisen und ".. round(12000/gvDiffLVL) .." Holz an Cleycourt!"
	TrNPC6_1.cost = { Wood = round(12000/gvDiffLVL), Iron = round(8000/gvDiffLVL)}
	TrNPC6_1.Callback = TributePaid_NPC6_1
	TNPC6_1 = AddTribute(TrNPC6_1)
end
function TributePaid_NPC6_1()
	if CNetwork then
		if GUI.GetPlayerID() == 2 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	else
		if GUI.GetPlayerID() == 1 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	end
	MapEditor_Armies[4].offensiveArmies.rodeLength			=	MapEditor_Armies[4].offensiveArmies.rodeLength * 2
	MapEditor_Armies[4].offensiveArmies.baseDefenseRange	=	MapEditor_Armies[4].offensiveArmies.baseDefenseRange * 2
	MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(5/gvDiffLVL)
	for i = 1,2 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,4)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,4)
		SetFriendly(i,4)
	end
	AddWood(4,10000)
	AddStone(4,10000)
	AddClay(4,10000)

	AI.Village_EnableConstructing(4, 1)
	gvVillage4MissionsSolved = true
	local P4TowerCreatedTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "TowerCreated", 1, {}, {4})
	Logic.CreateConstructionSite(32700, 8800, 0, Entities.PB_Tower1, 4)
	Logic.CreateConstructionSite(31600, 7900, 0, Entities.PB_Tower1, 4)
	Logic.CreateConstructionSite(30600, 7200, 0, Entities.PB_Tower1, 4)
	Logic.CreateConstructionSite(35200, 19300, 0, Entities.PB_Tower1, 4)
	Logic.CreateConstructionSite(33500, 19100, 0, Entities.PB_Tower1, 4)
	Logic.CreateConstructionSite(32400, 18400, 0, Entities.PB_Tower1, 4)
	Trigger.UnrequestTrigger(P4TowerCreatedTriggerID)
	if not gvChallengeFlag then
		StartCutscene("Cleycourt", UpgradeP4)
	else
		StartCountdown(30,UpgradeP4,false)
	end
end
function UpgradeP4()
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(4), CEntityIterator.IsBuildingFilter()) do
		if string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "pb") ~= nil and string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "1") ~= nil then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
	StartCountdown(20 * 60 / gvDiffLVL, UpgradeP4_2, false)
end
function UpgradeP4_2()
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(4), CEntityIterator.IsBuildingFilter()) do
		if string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "pb") ~= nil and string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "2") ~= nil then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
end
function TowerCreated(_playerID)

	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)
    local playerID = GetPlayer(entityID)

	if playerID == _playerID and entityType == Entities.PB_Tower1 then

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","TowerReadyForUpgrade",1,{},{entityID})

	end
end
function TowerReadyForUpgrade(_entityID)
	if not IsExisting(_entityID) then
		return true
	end
	if Logic.IsConstructionComplete(_entityID) == 1 then
		(CSendEvent or SendEvent).UpgradeBuilding(_entityID)
		return true
	end
end
function NPCBriefing7()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Outpost2) == 0 then
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc7"), 0)
		return
	end
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Anführer von Coleshill",
        text	= "@color:230,0,0 Hrmpf, ihr seid es... @cr @cr Euer Wahn nach Expansion belastet uns sehr.",
		position = GetPosition("npc7")
    }
	 AP{
        title	= "@color:230,120,0 Anführer von Coleshill",
        text	= "@color:230,0,0 Wenn ihr weiterhin den Frieden bewahren wollt, so müsst ihr uns in regelmäßigen Abständen Tributzahlungen entrichten.",
		position = GetPosition("npc7"),
		action = function()
			TributeNPC7_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC7_1()
	local TrNPC7_1 =  {}
	if CNetwork then
		TrNPC7_1.playerId = 2
	else
		TrNPC7_1.playerId = 1
	end
	TrNPC7_1.text = "Zahlt ".. round(Logic.GetTime() * 4/gvDiffLVL) .." Taler, um Coleshill zu besänftigen!"
	TrNPC7_1.cost = { Gold = round(Logic.GetTime() * 4/gvDiffLVL) }
	TrNPC7_1.Callback = TributePaid_NPC7_1
	TNPC7_1 = AddTribute(TrNPC7_1)
end
function TributePaid_NPC7_1()
	if CNetwork then
		if GUI.GetPlayerID() == 2 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	else
		if GUI.GetPlayerID() == 1 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	end
	StopCountdown(ColeshillTimerID)
	gvVillage8MissionsSolved = true
	StartCountdown(math.ceil(14*60*math.sqrt(gvDiffLVL) - (Logic.GetTime()/45)), ColeshillWantsCashAgain, false)
end
function ColeshillWantsCashAgain()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Outpost2) == 0 then
		return
	end
	Message("Coleshill verlangt nach einer weiteren Tributzahlung!")
	Sound.PlayGUISound(Sounds.Misc_so_signalhorn, 120)
	gvVillage8MissionsSolved = nil
	TributeNPC7_1()
	ColeshillTimerID = StartCountdown(5 * 60 * gvDiffLVL, ColeshillTimer, false)
end
function NPCBriefing8()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Händler",
        text	= "@color:230,0,0 Ah Ihr seid es! @cr Schaut gerne in Euer Tributmenü, um meine Ware zu sehen!",
		position = GetPosition("npc8"),
		action = function()
			TributeNPC1_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC1_1()
	local TrNPC1_1 =  {}
	TrNPC1_1.playerId = 1
	TrNPC1_1.text = "Zahlt ".. round(5000/gvDiffLVL) .." Taler für 200 Silber"
	TrNPC1_1.cost = { Gold = round(5000/gvDiffLVL) }
	TrNPC1_1.Callback = TributePaid_NPC1_1
	TNPC1_1 = AddTribute(TrNPC1_1)
end
function TributePaid_NPC1_1()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 200)
	TributeNPC1_2()
end
function TributeNPC1_2()
	local TrNPC1_2 =  {}
	TrNPC1_2.playerId = 1
	TrNPC1_2.text = "Zahlt ".. round(8000/gvDiffLVL) .." Taler für 100 Silber"
	TrNPC1_2.cost = { Gold = round(8000/gvDiffLVL) }
	TrNPC1_2.Callback = TributePaid_NPC1_2
	TNPC1_2 = AddTribute(TrNPC1_2)
end
function TributePaid_NPC1_2()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 100)
	TributeNPC1_3()
end
function TributeNPC1_3()
	local TrNPC1_3 =  {}
	TrNPC1_3.playerId = 1
	TrNPC1_3.text = "Zahlt ".. round(20000/gvDiffLVL) .." Taler für 80 Silber"
	TrNPC1_3.cost = { Gold = round(20000/gvDiffLVL) }
	TrNPC1_3.Callback = TributePaid_NPC1_3
	TNPC1_3 = AddTribute(TrNPC1_3)
end
function TributePaid_NPC1_3()
	if GUI.GetPlayerID() == 1 then
		Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
	end
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 80)
	TributeNPC1_3()
end
function NPCBriefing9()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Pilgrim",
        text	= "@color:230,0,0 Ihr braucht Stein? Naja, ich könnte Euch Stein besorgen, aber dafür müsst Ihr erst etwas für mich tun.",
		position = GetPosition("Pilgrim")
    }
	AP{
        title	= "@color:230,120,0 Pilgrim",
        text	= "@color:230,0,0 Ich brauche gerade ganz dringend Schwefel - Wenn Ihr ihn mir besorgt, können wir vielleicht zusammen arbeiten...",
		position = GetPosition("Pilgrim")
    }
	AP{
        title	= "@color:230,120,0 Pilgrim",
        text	= "@color:230,0,0 Ach ja - Passt auf diese Räuber in den umliegenden Wäldern auf! @cr Ich habe schlechte Erfahrungen mit ihnen gemacht.",
		position = GetPosition("Pilgrim")
    }
	AP{
        title	= "@color:230,120,0 Aufgaben von Pilgrim",
        text	= "@color:230,0,0 Pilgrim wird sich Euch anschließen, wenn Ihr zwei Schwefelstollen baut. @cr  @cr Aufgabe: @cr 1) Baut zwei Schwefelstollen und versorgt sie mit je einem mittleren Wohnhaus und einer Mühle! @cr  @cr Hinweise: @cr - Pilgrim ist der Chef der Steinbrüche hier und wird Euch die Siedlung überlassen.",
		position = GetPosition("Pilgrim"),
		action = function()
			StartSimpleJob("SulfurMinesBuilt")
		end
    }

    StartBriefing(briefing)

end
function SulfurMinesBuilt()

	local posX, posY = 43400, 6650
	local sulfurmines = {Logic.GetEntitiesInArea(Entities.PB_SulfurMine2, posX, posY, 3000, 2)}
	local houses = {Logic.GetEntitiesInArea(Entities.PB_Residence2, posX, posY, 3000, 2)}
	local farms = {Logic.GetEntitiesInArea(Entities.PB_Farm2, posX, posY, 3000, 2)}

	if sulfurmines[1] >= 2 and houses[1] >= 2 and farms[1] >= 2 then
		local pID = {	[1] = 0,
						[2] = 0
					}
		for i = 2,3 do
			pID[GetPlayer(sulfurmines[i])] = pID[GetPlayer(sulfurmines[i])] + 1
			pID[GetPlayer(houses[i])] = pID[GetPlayer(houses[i])] + 1
			pID[GetPlayer(farms[i])] = pID[GetPlayer(farms[i])] + 1
			ChangePlayer(sulfurmines[i], 7)
			ChangePlayer(houses[i], 7)
			ChangePlayer(farms[i], 7)
		end
		local newowner
		if pID[1] >= pID[2] then
			newowner = 1
		elseif pID[2] > pID[1] then
			newowner = 2
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfPlayerFilter(7), CEntityIterator.IsSettlerOrBuildingFilter(), CEntityIterator.InCircleFilter(50000, 14300, 6000)) do
			ChangePlayer(eID, newowner)
		end
		NPCs[11] = true
		Logic.SetOnScreenInformation(Logic.GetEntityIDByName("BarmeciaMayor"), 1)
		local briefing = {}
		local AP = function(_page) table.insert(briefing, _page) return _page end
		AP{
			title	= "@color:230,120,0 Pilgrim",
			text	= "@color:230,0,0 Vielen Dank. @cr Lasst uns Barmecia von nun an zusammen helfen!",
			position = GetPosition("Pilgrim")
		}

		StartBriefing(briefing)
		if not gvChallengeFlag then
			StartCutscene("Cutscene1")
		end
		return true
	end

end
function NPCBriefing10()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Ari",
        text	= "@color:230,0,0 Ihr habt mich nicht ausgeliefert! Vielen Dank.",
		position = GetPosition("Ari"),
		action = function()
			NPCs[6] = false
			Logic.SetOnScreenInformation(Logic.GetEntityIDByName("npc6"), 0)
			gvVillage5MissionsSolved = true
			sub_armies_aggressive = 0
		end
    }
	AP{
        title	= "@color:230,120,0 Ari",
        text	= "@color:230,0,0 Ich werde meine Räuberbanden Euch gegenüber nicht freundlich stimmen können, jedoch werden Sie keine Überfälle auf Eure Siedlung mehr starten. @cr Ach und nehmt einen Teil meiner letzten Beute aus Cleycourt als Dank!",
		position = GetPosition("Ari"),
		action = function()
			ChangePlayer("Ari", 1)
			SetNPCFollow("Ari",nil)
		end
    }
	AP{
        title	= "@color:230,120,0 Mentor",
        text	= "@color:230,0,0 Seht doch, Sire. @cr Ari hat sich Euch angeschlossen. @cr Cleycourt wird das gar nicht gefallen. Lasst Euch dort mit Ari besser nicht blicken...",
		position = GetPosition("Ari"),
		action = function()
			StartSimpleJob("AriNearCleycourt")
			for i = 1,2 do
				Logic.AddToPlayersGlobalResource(i, ResourceType.Gold, round(5000*gvDiffLVL))
				Logic.AddToPlayersGlobalResource(i, ResourceType.Silver, round(300*gvDiffLVL))
			end
		end
    }

    StartBriefing(briefing)
end
function AriNearCleycourt()
	if IsDestroyed("CleycourtCastle") or IsDestroyed("Cleycourt_HQ") then
		return true
	end
	local eIDs = {Logic.GetPlayerEntitiesInArea(1, Entities.PU_Hero5, 27700, 12000, 8000, 1)}
	if eIDs[1] > 0 then
		if Logic.GetCamouflageTimeLeft(eIDs[2]) == 0 then
			local briefing = {}
			local AP = function(_page) table.insert(briefing, _page) return _page end
			AP{
				title	= "@color:230,120,0 Bürgermeister von Cleycourt",
				text	= "@color:230,0,0 Ihr elendiger Verräter! @cr @cr Ihr habt versucht, mit der Anführerin der Räuber zu fliehen anstatt sie zu mir zu bringen!",
				position = GetPosition("npc6")
			}
			AP{
				title	= "@color:230,120,0 Bürgermeister von Cleycourt",
				text	= "@color:230,0,0 Männer, zu den Waffen. @cr @cr Zeigt ihnen wie wir hier mit Verrätern verfahren!",
				position = GetPosition("npc6"),
				action = function()
					for i = 1,2 do
						SetHostile(i,4)
						Logic.SetShareExplorationWithPlayerFlag(i, 4, 0)
						Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,4)
						Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,4)
					end
					MapEditor_Armies[4].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
					MapEditor_Armies[4].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
					MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(15/gvDiffLVL)
					MapEditor_Armies[4].defensiveArmies.strength = MapEditor_Armies[4].defensiveArmies.strength + round(6/gvDiffLVL)
					Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","MakePlayerEntitiesInvulnerableLimitedTime",1,{},{4, 40 / gvDiffLVL})
					for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsBuildingFilter(), CEntityIterator.InCircleFilter(28500, 12500, 6100)) do
						Logic.DestroyEntity(eID)
					end
					for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsBuildingFilter(), CEntityIterator.InCircleFilter(21500, 12700, 4000)) do
						Logic.DestroyEntity(eID)
					end
				end
			}

			StartBriefing(briefing)
			return true
		end
	end
end
function NPCBriefing11()
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Bürgermeister von Barmecia",
        text	= "@color:230,0,0 Ihr habt die Probleme mit den Handelsrouten und der Steinversorgung behoben? @cr Sehr gut, ich stehe tief in Eurer Schuld.",
		position = GetPosition("BarmeciaMayor")
    }
	AP{
        title	= "@color:230,120,0 Bürgermeister von Barmecia",
        text	= "@color:230,0,0 Dennoch muss ich Euch um etwas bitten. @cr @cr Wir fürchten um baldige Angriffe aus Cleycourt. Auch die umliegenden Räuberbanden und das Dorf Coleshill im Norden stellen eine ständige Gefährdung dar.",
		position = GetPosition("BarmeciaMayor")
    }
	AP{
        title	= "@color:230,120,0 Bürgermeister von Barmecia",
        text	= "@color:230,0,0 Wir würden gerne unsere Siedlung verstärken, haben dafür aber leider nicht genügend Ressourcen. Sendet sie uns doch bitte, so dass wir uns besser erwehren können.",
		position = GetPosition("BarmeciaMayor")
    }
	AP{
        title	= "@color:230,120,0 Aufgaben des Bürgermeisters von Barmecia",
        text	= "@color:230,0,0 Aufgabe: @cr 1) Schickt dem Bürgermeister von Barmecia Lehm, Holz und Steine, damit er seine Siedlung verstärken kann!",
		position = GetPosition("BarmeciaMayor"),
		action = function()
			TributeNPC11_1()
		end
    }

    StartBriefing(briefing)
end
function TributeNPC11_1()
	local TrNPC11_1 =  {}
	if not CNetwork then
		TrNPC11_1.playerId = 1
	else
		TrNPC11_1.playerId = 2
	end
	TrNPC11_1.text = "Zahlt ".. round(10000/gvDiffLVL) .." Lehm, ".. round(15000/gvDiffLVL) .." Holz und ".. round(8000/gvDiffLVL) .." Steine an Barmecia!"
	TrNPC11_1.cost = { Wood = round(15000/gvDiffLVL), Clay = round(10000/gvDiffLVL), Stone =  round(8000/gvDiffLVL)}
	TrNPC11_1.Callback = TributePaid_NPC11_1
	TNPC11_1 = AddTribute(TrNPC11_1)
end
function TributePaid_NPC11_1()
	if CNetwork then
		if GUI.GetPlayerID() == 2 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	else
		if GUI.GetPlayerID() == 1 then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias , 120)
		end
	end
	MapEditor_Armies[3].offensiveArmies.rodeLength			=	Logic.WorldGetSize()
	MapEditor_Armies[3].offensiveArmies.baseDefenseRange	=	Logic.WorldGetSize() * 3/4
	MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength + round(5/gvDiffLVL)
	--
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,3)
	AddWood(3,10000)
	AddStone(3,10000)
	AddClay(3,10000)
	AI.Village_EnableConstructing(3, 1)
	local P3TowerCreatedTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "TowerCreated", 1, {}, {3})
	Logic.CreateConstructionSite(49500, 34600, 0, Entities.PB_Tower1, 3)
	Logic.CreateConstructionSite(49400, 33300, 0, Entities.PB_Tower1, 3)
	Logic.CreateConstructionSite(47800, 26700, 0, Entities.PB_Tower1, 3)
	Logic.CreateConstructionSite(38000, 35300, 0, Entities.PB_Tower1, 3)
	Trigger.UnrequestTrigger(P3TowerCreatedTriggerID)
	if not gvChallengeFlag then
		StartCutscene("Barmecia", UpgradeP3)
	else
		StartCountdown(30,UpgradeP3,false)
	end
end

function UpgradeP3()
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(3), CEntityIterator.IsBuildingFilter()) do
		if string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "pb") ~= nil and string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "1") ~= nil then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
	StartCountdown(20 * 60 / gvDiffLVL, UpgradeP3_2, false)
end
function UpgradeP3_2()
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(3), CEntityIterator.IsBuildingFilter()) do
		if string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "pb") ~= nil and string.find(string.lower(Logic.GetEntityTypeName(Logic.GetEntityType(eID))), "2") ~= nil then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
end
function CreateArmyP5_1()

	armyP5_1	= {}
    armyP5_1.player 	= 5
    armyP5_1.id = 1
    armyP5_1.strength = math.ceil(6/gvDiffLVL)
    armyP5_1.position = GetPosition("BanditsHQ1")
    armyP5_1.rodeLength = 6100/gvDiffLVL
	SetupArmy(armyP5_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP5_1.strength, 1 do
	    EnlargeArmy(armyP5_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP5_1")

end

function ControlArmyP5_1()

    if IsDead(armyP5_1) and IsExisting("BanditsTower1") then
        CreateArmyP5_1()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_1)
		else
			Advance(armyP5_1)
		end
    end
end
function CreateArmyP5_2()

	armyP5_2	= {}
    armyP5_2.player 	= 5
    armyP5_2.id = 2
    armyP5_2.strength = math.ceil(8/gvDiffLVL)
    armyP5_2.position = GetPosition("BanditsHQ2")
    armyP5_2.rodeLength = 6100/gvDiffLVL
	SetupArmy(armyP5_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow3

    for i = 1, armyP5_2.strength / 2, 1 do
	    EnlargeArmy(armyP5_2,troopDescription)
	end
	for i = 1, armyP5_2.strength / 2, 1 do
	    EnlargeArmy(armyP5_2,troopDescription2)
	end

    StartSimpleJob("ControlArmyP5_2")

end

function ControlArmyP5_2()

    if IsDead(armyP5_2) and IsExisting("BanditsTower2") then
        CreateArmyP5_2()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_2)
		else
			Advance(armyP5_2)
		end
    end
end
function CreateArmyP5_3()

	armyP5_3	= {}
    armyP5_3.player 	= 5
    armyP5_3.id = 3
    armyP5_3.strength = 8
    armyP5_3.position = GetPosition("BanditsSpawn3")
    armyP5_3.rodeLength = 6100/gvDiffLVL
	SetupArmy(armyP5_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP5_3.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_3,troopDescription)
	end
	for i = 1, round(armyP5_3.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_3,troopDescription2)
	end
	armyP5_3.RespawnBuilding = "BanditsTower3_"..math.random(1,3)
    StartSimpleJob("ControlArmyP5_3")
end

function ControlArmyP5_3()

    if IsDead(armyP5_3) and IsExisting(armyP5_3.RespawnBuilding) then
        CreateArmyP5_3()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_3)
		else
			Advance(armyP5_3)
		end
    end
end
function CreateArmyP5_4()

	armyP5_4	= {}
    armyP5_4.player 	= 5
    armyP5_4.id = 4
    armyP5_4.strength = 8
    armyP5_4.position = GetPosition("BanditsSpawn4")
    armyP5_4.rodeLength = 9000/gvDiffLVL
	SetupArmy(armyP5_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP5_4.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_4,troopDescription2)
	end
	for i = 1, round(armyP5_4.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_4,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_4")

end

function ControlArmyP5_4()

    if IsDead(armyP5_4) and IsExisting("BanditsTower4") then
        CreateArmyP5_4()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_4)
		else
			Advance(armyP5_4)
		end
    end
end

function CreateArmyP5_5()

	armyP5_5	= {}
    armyP5_5.player 	= 5
    armyP5_5.id = 5
    armyP5_5.strength = math.floor(8/gvDiffLVL)
    armyP5_5.position = GetPosition("BanditsSpawn5")
    armyP5_5.rodeLength = 4000/gvDiffLVL
	SetupArmy(armyP5_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP5_5.strength, 1 do
	    EnlargeArmy(armyP5_5,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_5")

end

function ControlArmyP5_5()

    if IsDead(armyP5_5) and IsExisting("BanditsTower5") then
        CreateArmyP5_5()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_5)
		else
			Advance(armyP5_5)
		end
    end
end

function CreateArmyP5_6()

	armyP5_6	= {}
    armyP5_6.player 	= 5
    armyP5_6.id = 6
    armyP5_6.strength = math.floor(8/gvDiffLVL)
    armyP5_6.position = GetPosition("BanditsSpawn6")
    armyP5_6.rodeLength = 6000/gvDiffLVL
	SetupArmy(armyP5_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP5_6.strength, 1 do
	    EnlargeArmy(armyP5_6,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_6")

end

function ControlArmyP5_6()

    if IsDead(armyP5_6) and IsExisting("BanditsTower6") then
        CreateArmyP5_6()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_6)
		else
			Advance(armyP5_6)
		end
    end
end

function CreateArmyP5_7()

	armyP5_7	= {}
    armyP5_7.player 	= 5
    armyP5_7.id = 7
    armyP5_7.strength = math.ceil(8/gvDiffLVL)
    armyP5_7.position = GetPosition("BanditsSpawn7")
    armyP5_7.rodeLength = 7500/gvDiffLVL
	SetupArmy(armyP5_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP5_7.strength, 1 do
	    EnlargeArmy(armyP5_7,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_7")

end

function ControlArmyP5_7()

    if IsDead(armyP5_7) and IsExisting("BanditsTower7") then
        CreateArmyP5_7()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_7)
		else
			Advance(armyP5_7)
		end
    end
end

function CreateArmyP5_8()

	armyP5_8	= {}
    armyP5_8.player 	= 5
    armyP5_8.id = 8
    armyP5_8.strength = 8
    armyP5_8.position = GetPosition("BanditsSpawn8")
    armyP5_8.rodeLength = 4800/gvDiffLVL
	SetupArmy(armyP5_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP5_8.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_8,troopDescription2)
	end
	for i = 1, round(armyP5_8.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_8,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_8")

end

function ControlArmyP5_8()

    if IsDead(armyP5_8) and IsExisting("BanditsTower8") then
        CreateArmyP5_8()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_8)
		else
			Advance(armyP5_8)
		end
    end
end

function CreateArmyP5_9()

	armyP5_9	= {}
    armyP5_9.player 	= 5
    armyP5_9.id = 0
    armyP5_9.strength = 8
    armyP5_9.position = GetPosition("BanditsSpawn9")
    armyP5_9.rodeLength = (9000/gvDiffLVL) + math.random(1500)
	SetupArmy(armyP5_9)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP5_9.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_9,troopDescription2)
	end
	for i = 1, round(armyP5_9.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP5_9,troopDescription)
	end
    StartSimpleJob("ControlArmyP5_9")

end

function ControlArmyP5_9()

    if IsDead(armyP5_9) and IsExisting("BanditsTower9") then
        CreateArmyP5_9()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP5_9)
		else
			Advance(armyP5_9)
		end
    end
end
function BanditsPrepareAttack(_pos)
	if not IsDead(armyP5_4) then
		armyP5_4.rodeLength = armyP5_4.rodeLength * 2
		ArmyTable[5][5].rodeLength = ArmyTable[5][5].rodeLength * 2
	end
	if IsExisting("BanditsTower4") then
		for i = 1, 4-round(gvDiffLVL) do
			CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderSword3,6,GetPosition("BanditsSpawn4"),"BanditAttacker1_"..i)
			CreateMilitaryGroup(5, Entities.PU_LeaderBow4,12,GetPosition("BanditsSpawn4"),"BanditAttacker2_"..i)
			CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderMace2,4,GetPosition("BanditsSpawn4"),"BanditAttacker3_"..i)
			CreateEntity(5, Entities.PV_Cannon2,GetPosition("BanditsSpawn4"),"BanditAttacker4_"..i)
			--
			Logic.GroupAttackMove(Logic.GetEntityIDByName("BanditAttacker1_"..i),_pos.X,_pos.Y)
			Logic.GroupAttackMove(Logic.GetEntityIDByName("BanditAttacker2_"..i),_pos.X,_pos.Y)
			Logic.GroupAttackMove(Logic.GetEntityIDByName("BanditAttacker3_"..i),_pos.X,_pos.Y)
			Logic.GroupAttack(Logic.GetEntityIDByName("BanditAttacker4_"..i), ({Logic.GetEntities(Entities.PB_SilverMine1, 1)})[2])
		end
	end
end
function DefeatJob()
	if Logic.GetEntityAtPosition(18200, 51000) == 0 or Logic.GetEntityAtPosition(28900, 39900) == 0 or Logic.GetNumberOfEntitiesOfType(Entities.CB_BarmeciaCastle) == 0 or IsDestroyed("Barmecia_HQ") then
		Defeat()
		Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01, 100)
		return true
	end
end
function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.floor(math.min((3.0+((math.random(1,5)/10)) + (timeb4end/120)) *60, 8*60/(math.sqrt(gvDiffLVL))))
	TroopSpawn(TimePassed)
	SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
end
trooptypes = {Entities.PU_LeaderBow4,Entities.PU_LeaderRifle2,Entities.PU_LeaderSword4,Entities.PU_LeaderPoleArm4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_Evil_LeaderBearman,Entities.CU_Evil_LeaderSkirmisher,Entities.CU_BlackKnight_LeaderSword3,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1},
				[2] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1, Entities.PU_LeaderBow1},
				[3] = {Entities.PU_LeaderPoleArm2, Entities.PU_LeaderSword2, Entities.PU_LeaderBow2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.PU_LeaderHeavyCavalry1, Entities.PU_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2, Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			}
function TroopSpawn(_TimePassed)
	Message("Feindestruppen versammeln sich, um den Dom zu vernichten!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_varg, 120)
	--local type1,type2,type3,type4
	for i = 1,8 do
		if _TimePassed <= 6 then
			CreateAttackingArmies("top", i, 1)
			CreateAttackingArmies("bot", i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies("top", i, 2)
			CreateAttackingArmies("bot", i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 24 then
			CreateAttackingArmies("top", i, 3)
			CreateAttackingArmies("bot", i, 3)

		elseif _TimePassed > 24 and _TimePassed <= 38 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("top", i, 4)
			CreateAttackingArmies("bot", i, 4)

		elseif _TimePassed > 38 and _TimePassed <= 50 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("top", i, 5)
			CreateAttackingArmies("bot", i, 5)

		elseif _TimePassed > 50 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("top", i, 6)
			CreateAttackingArmies("bot", i, 6)

			if i == 8 then
				CreateAttackingArmies("top", 9, 6)
				CreateAttackingArmies("bot", 9, 6)

			end
		end
	end
end
InvasionArmyIDByPattern = {["top"] = {}, ["bot"] = {}}
function CreateAttackingArmies(_name, _poscount, _index)
	local army	= {}
	local id = InvasionArmyIDByPattern[_name][_poscount]
	if not id then
		army.player = 6
		army.id	  	=  GetFirstFreeArmySlot(6)
		army.strength = table.getn(armytroops[_index])
		army.position = GetPosition(_name .."_".. _poscount)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		InvasionArmyIDByPattern[_name][_poscount] = army.id
	else
		army = ArmyTable[6][id+1]
		army.strength = table.getn(armytroops[_index])
	end
	for i = 1, army.strength do
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = armytroops[_index][i]
		EnlargeArmy(army, troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.id})

end
function ControlArmies(_id)

    if IsDead(ArmyTable[6][_id + 1]) then
		return true
    else
		Defend(ArmyTable[6][_id + 1])
    end
end

function AIIdleScan()
	if Counter.Tick2("IdleScan_Ticker",10) then
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(6), CEntityIterator.OfCategoryFilter(EntityCategories.Leader)) do
			if Logic.GetCurrentTaskList(eID) == "TL_MILITARY_IDLE" then
				Logic.GroupAttackMove(eID, AttackTarget.X, AttackTarget.Y)
			end
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(6), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
			if Logic.GetCurrentTaskList(eID) == "TL_VEHICLE_IDLE" then
				Logic.GroupAttackMove(eID, AttackTarget.X, AttackTarget.Y)
			else
				if Logic.GetEntityType(eID) ~= Entities.PV_Cannon3 then
					if GetDistance(GetPosition(eID), gvDomePos) <= 6000 then
						Logic.GroupAttack(eID, ({Logic.GetEntities(Entities.PB_Dome, 1)})[2])
					else
						Logic.GroupAttackMove(eID, AttackTarget.X, AttackTarget.Y)
					end
				end
			end
		end
	end
end

function UpgradeKIa()
	for i = 3,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown((28+math.random(2,4))*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 3,8 do
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
	end
	if not gvVillage5MissionsSolved then
		sub_armies_aggressive = 1
	end
	for i = 4, 8, 4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		--
		MapEditor_Armies[i].offensiveArmies.rodeLength			=	MapEditor_Armies[i].offensiveArmies.rodeLength * 2
		MapEditor_Armies[i].offensiveArmies.baseDefenseRange	=	MapEditor_Armies[i].offensiveArmies.baseDefenseRange * 2
	end
	StartCountdown((33+math.random(2,4))*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 3,8 do

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

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Gut euch zu sehen, mein Herr. @cr Eine wahrlich üppig bewachsene europäische Wald- und Wiesengegend, in die Ihr Euch da begeben habt.",
		position = GetPosition("forest")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Grund genug für die prächtige Stadt Barmecia, vom König höchstpersönlich den Bau eines Doms zu erbitten.",
		position = GetPosition("BarmeciaMayor")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Baut Barmecia einen Dom auf dem dafür vorgesehenen Ort. Doch eilt Euch, Euch bleibt nicht viel Zeit.",
		position = GetPlayerStartPosition(),
		action = function()

		end

    }

    StartBriefing(briefing)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	local wolves = {Logic.GetEntities(Entities.CU_AggressiveWolf, 30)}
	for i = 1, wolves[1] do
		Logic.GroupPatrol(wolves[i+1], Logic.GetEntityPosition(Logic.GetEntityIDByName("WolfPatrol")))
	end
	for i = 1, round(4/gvDiffLVL) do
		CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderSword3, 6, GetPosition("BanditsSpawn4"), "BKnight"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("BKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolSilver")))
		Logic.GroupAddPatrolPoint(Logic.GetEntityIDByName("BKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolSilver1")))
		Logic.GroupAddPatrolPoint(Logic.GetEntityIDByName("BKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolSilver2")))
		Logic.GroupAddPatrolPoint(Logic.GetEntityIDByName("BKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolSilver3")))
		Logic.GroupAddPatrolPoint(Logic.GetEntityIDByName("BKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolSilver4")))
	end
	for i = 1, round(3/gvDiffLVL) do
		CreateMilitaryGroup(5, Entities.PU_LeaderSword3, round(9-gvDiffLVL), GetPosition("BanditsSpawn5"), "SwordPat"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("SwordPat"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolIron")))
	end
	for i = 1, round(3/gvDiffLVL) do
		CreateMilitaryGroup(5, Entities.CU_BlackKnight_LeaderSword3, 6, GetPosition("BanditsSpawn8"), "BDKnight"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("BDKnight"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditsPatrolVillage")))
	end

	local mercenaryId1 = Logic.GetEntityIDByName("merchant1")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Thief, 2 + round(gvDiffLVL), ResourceType.Gold, round(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PV_Cannon1, 5 + round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderSword3, 9 * round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderBow3, 5 + round(gvDiffLVL), ResourceType.Gold, round(1500/gvDiffLVL))

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


	Display.SetPlayerColorMapping(4,13)
	Display.SetPlayerColorMapping(5,14)
	Display.SetPlayerColorMapping(6,2)
	Display.SetPlayerColorMapping(7,11)
	Display.SetPlayerColorMapping(8,15)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	for i = 1,2 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
	end
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
function CleycourtPrepareTroopsTimer()
	if gvVillage4MissionsSolved or IsDestroyed("Cleycourt_HQ") or IsDestroyed("CleycourtCastle") then
		return
	end
	Message("Oh nein! Cleycourt sammelt bereits seine Truppen! @cr Eilt Euch, sie werden Barmecia in Kürze angreifen!")
	Sound.PlayGUISound(Sounds.Misc_so_signalhorn, 120)
	CleycourtAttackBarmeciaTimerID = StartCountdown(5 * gvDiffLVL * 60, CleycourtAttackBarmeciaTimer, false)
end
function CleycourtAttackBarmeciaTimer()
	if gvVillage4MissionsSolved or IsDestroyed("Cleycourt_HQ") or IsDestroyed("CleycourtCastle") then
		return
	end
	Message("Oh je! Ihr wart zu langsam... @cr Cleycourt hat Barmecia den Krieg erklärt. Möge der Herr Barmecia gnädig sein!")
	Sound.PlayGUISound(Sounds.Misc_so_signalhorn, 120)
	SetHostile(3,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,4)
	--
	MapEditor_Armies[4].offensiveArmies.rodeLength			=	math.min(MapEditor_Armies[4].offensiveArmies.rodeLength * 10, Logic.WorldGetSize())
	MapEditor_Armies[4].offensiveArmies.baseDefenseRange	=	math.min(MapEditor_Armies[4].offensiveArmies.baseDefenseRange * 10, Logic.WorldGetSize())
	MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(20/gvDiffLVL)
	MapEditor_Armies[4].defensiveArmies.strength = MapEditor_Armies[4].defensiveArmies.strength + round(5/gvDiffLVL)
	--
	DestroyEntity(Logic.GetEntityAtPosition(21280, 12876))
	DestroyEntity(Logic.GetEntityAtPosition(21470, 13094.4))
	DestroyEntity(Logic.GetEntityAtPosition(21570, 13761.6))
	if IsExisting(Logic.GetEntityAtPosition(21000, 13400)) then
		ReplaceEntity(Logic.GetEntityAtPosition(21000, 13400), Entities.PB_Foundry1)
	end
end
function DefeatTimer()

	Message("Oh nein! Ihr habt dem Dom nicht rechtzeitig errichtet. Versucht es erneut und macht es dann besser!")
	Defeat()
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01, 100)
end

PlayerEntitiesInvulnerable_IsActive = {}
----------------------------------------------------------------------------------------------------------
function MakePlayerEntitiesInvulnerableLimitedTime(_PlayerID, _Timelimit)
	_Timelimit = round(_Timelimit)
	if not Counter.Tick2("MakePlayerEntitiesInvulnerableLimitedTime_Ticker".. _PlayerID, _Timelimit) then
		if not PlayerEntitiesInvulnerable_IsActive[_PlayerID] then
			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_PlayerID), CEntityIterator.IsSettlerOrBuildingFilter()) do
				if Logic.IsEntityAlive(eID) then
					MakeInvulnerable(eID)
				end
			end
		PlayerEntitiesInvulnerable_IsActive[_PlayerID] = true
		end
	else
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_PlayerID), CEntityIterator.IsSettlerOrBuildingFilter()) do
			if Logic.IsEntityAlive(eID) then
				MakeVulnerable(eID)
			end
		end
		PlayerEntitiesInvulnerable_IsActive[_PlayerID] = nil
		return true
	end
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function AddPages( _briefing )
    local AP = function(_page) table.insert(_briefing, _page); return _page; end
    local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end
    return AP, ASP;
end
--**
function CreateShortPage( _entity, _title, _text, _dialog, _explore)
    local page = {
        title = _title,
        text = _text,
        position = GetPosition( _entity ),
		action = function () end
    };
    if _dialog then
            if type(_dialog) == "boolean" then
                  page.dialogCamera = true;
            elseif type(_dialog) == "number" then
                  page.explore = _dialog;
            end
      end
    if _explore then
            if type(_explore) == "boolean" then
                  page.dialogCamera = true;
            elseif type(_explore) == "number" then
                  page.explore = _explore;
            end
      end
    return page;
end
function ActivateBriefingsExpansion()
    if not unpack{true} then
        local unpack2;
        unpack2 = function( _table, i )
                            i = i or 1;
                            assert(type(_table) == "table");
                            if i <= table.getn(_table) then
                                return _table[i], unpack2(_table, i);
                            end
                        end
        unpack = unpack2;
    end

    Briefing_ExtraOrig = Briefing_Extra;

    Briefing_Extra = function( _v1, _v2 )
		for i = 1, 2 do
			local theButton = "CinematicMC_Button" .. i;
			XGUIEng.DisableButton(theButton, 1);
			XGUIEng.DisableButton(theButton, 0);
		end

		if _v1.action then
			assert( type(_v1.action) == "function" );
			if type(_v1.parameters) == "table" then
				_v1.action(unpack(_v1.parameters));
			else
				_v1.action(_v1.parameters);
			end
		end

    Briefing_ExtraOrig( _v1, _v2 );
	end;

end