
--------------------------------------------------------------------------------
-- MapName: Sechste Prüfung - Der böse Graf
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
-- Orig Map Antrium by
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Map Name 				: 	(1)Antrium
-- Author 					: 	Janos Toth
-- Script 					: 	Janos Toth
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Sechste Prüfung - Der böse Graf "
gvMapVersion = " v1.23 "
winterTimer 		= 0
TMR_ArmyPL2Assault	= 0
TMR_ArmyPL4Assault	= 0
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	if CNetwork then
		TributePID = 1
		AllyPID = 2
	else
		TributePID = 1
		AllyPID = 1
		Logic.ChangeAllEntitiesPlayerID(2,1)
	end

	-- Init  global MP stuff
	if CNetwork then
		if GUI.GetPlayerID() ~= 17 then
			SetUpGameLogicOnMPGameConfigLight()
		end
	end
	InitDiplomacy()

	-- custom Map Stuff
	TagNachtZyklus(24,0,1,-4,1)
	StartTechnologies()

	-- Init  global MP stuff
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	function GUIAction_ExpelSettler()
		local SelectedEntityID = GUI.GetSelectedEntity()
		if Logic.IsHero(SelectedEntityID) == 1 or Logic.GetEntityType(SelectedEntityID) == Entities.PU_Priest then
			--Sound.PlayFeedbackSound( Sounds.Leader_LEADER_NO_rnd_01, 0 )
		else
			GUI.ExpelSettler(SelectedEntityID)
		end

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

	XGUIEng.ShowWidget("SettlerServerInformation", 0)
	XGUIEng.ShowWidget("SettlerServerInformationExtended", 0)
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer(4)
	gvDiffLVL = 2.5

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,2 do
		ResearchTechnology(Technologies.GT_Construction,i)
		ResearchTechnology(Technologies.GT_Literacy,i)
	end
	ResearchAllTechnologies(AllyPID, false, false, false, true, false)
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer(3)
	gvDiffLVL = 1.8

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer(2)
	gvDiffLVL = 1.3

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
	--
	for i = 3,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer(1)
	gvDiffLVL = 1.0
	gvChallengeFlag = 1

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 HERAUSFORDERUNG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
	--
	for i = 3,8 do
		ResearchAllTechnologies(i, false, false, false, true, false)
	end
	for i = 1, 2 do
		ForbidTechnology(Technologies.B_Dome, i)
	end
end
function FarbigeNamen()
	orange 	= "@color:255,127,0"
	lila 	= "@color:250,0,240"

    QB    	= ""..orange.." Quest - Beschreibung "..lila..""
    serf    = ""..orange.." Geflüchteter Siedler "..lila..""
    monk    = ""..orange.." Niedergeschlagener Mönch "..lila..""
	alch 	= ""..orange.." Alchemist "..lila..""
	sm 		= ""..orange.." Deprimierter Schmied "..lila..""
	wan 	= ""..orange.." Bergsteiger ... oder doch nur ein verrückter Wanderer? "..lila..""
	joh 	= ""..orange.." Bruder Johannes "..lila..""
	bui 	= ""..orange.." Brückenarchitekt "..lila..""
	af_alch = ""..orange.." Verängstigter Alchemist "..lila..""

end
NPCs = {["serf"] = {true, "Serf"},
		["monk"] = {true, "Monk"},
		["alchemist"] = {true, "alchemist"},
		["smith"] = {true, "smith"},
		["wanderer"] = {true, "wanderer"},
		["johannes"] = {true, "johannes"},
		["builder"] = {true, "builder"},
		["afraid_alchemist"] = {true, "afraid_alchemist"}
		}
--
function NPCControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, name
		for k, v in pairs(NPCs) do
			if v[1] then
				pos = GetPosition(k)
				name = k
				for j = 1, 2 do
					entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)}
					if entities[1] > 0 then
						if Logic.IsHero(entities[2]) == 1 then
							v[1] = false
							Logic.SetOnScreenInformation(Logic.GetEntityIDByName(name), 0)
							_G[v[2]]()
							break
						end
					end
				end
			end
		end
	end
end
function InitDiplomacy()
	SetPlayerName(3,"Nerlon der Ältere")
	SetPlayerName(4,"Nerlon der Jüngere")
	SetPlayerName(5,"Wikinger")
	SetFriendly(1,2)
    SetHostile(1,3)
    SetHostile(1,4)
    SetHostile(1,5)
	SetHostile(2,3)
	SetHostile(2,4)
	SetHostile(2,5)
end
function InitResources()

	for i = 1,2 do
		AddGold(i,900)
		AddClay(i,800)
		AddWood(i,1200)
		AddStone(i,800)
		AddIron(i,300)
		AddSulfur(i,150)
	end
	AddGold(AllyPID, dekaround(8000*gvDiffLVL))
	AddIron(AllyPID, dekaround(8000*gvDiffLVL))
	AddWood(AllyPID, dekaround(8000*gvDiffLVL))
end
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
function InitTechnologies()
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSword1,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear1,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeBow1,0)
	Logic.SetTechnologyState(2,Technologies.B_Tower,0)
	Logic.SetTechnologyState(2,Technologies.B_University,0)
	Logic.SetTechnologyState(2,Technologies.B_Barracks,0)
	Logic.SetTechnologyState(2,Technologies.B_Archery,0)
	Logic.SetTechnologyState(2,Technologies.B_Lighthouse,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Lighthouse,0)
	Logic.SetTechnologyState(2,Technologies.B_Mercenary,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Barracks,0)
	Logic.SetTechnologyState(2,Technologies.B_Stables,0)
	Logic.SetTechnologyState(2,Technologies.MU_LeaderRifle,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Archery,0)
	Logic.SetTechnologyState(2,Technologies.B_Foundry,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Tower,0)
	Logic.SetTechnologyState(2,Technologies.B_Grange,0)
	--
	Logic.SetTechnologyState(2,Technologies.T_LeatherMailArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_SoftArcherArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_MasterOfSmithery,0)
	Logic.SetTechnologyState(2,Technologies.T_Fletching,0)
	Logic.SetTechnologyState(2,Technologies.T_WoodAging,0)
	Logic.SetTechnologyState(2,Technologies.T_Masonry,0)
	Logic.SetTechnologyState(2,Technologies.T_FleeceArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_LeadShot,0)
	Logic.SetTechnologyState(2,Technologies.B_Castle,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Stables,0)
	Logic.SetTechnologyState(2,Technologies.UP1_Foundry,0)
	Logic.SetTechnologyState(2,Technologies.UP2_Tower,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSword2,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear2,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeBow2,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeLightCavalry1,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeRifle1,0)
	--
	Logic.SetTechnologyState(2,Technologies.T_ChainMailArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_PlateMailArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_PaddedArcherArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_LeatherArcherArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_IronCasting,0)
	Logic.SetTechnologyState(2,Technologies.T_BodkinArrow,0)
	Logic.SetTechnologyState(2,Technologies.T_Turnery,0)
	Logic.SetTechnologyState(2,Technologies.T_EnhancedGunPowder,0)
	Logic.SetTechnologyState(2,Technologies.T_BlisteringCannonballs,0)
	Logic.SetTechnologyState(2,Technologies.T_FleeceLinedLeatherArmor,0)
	Logic.SetTechnologyState(2,Technologies.T_Sights,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeHeavyCavalry1,0)
	Logic.SetTechnologyState(2,Technologies.T_Joust,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSword3,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear3,0)
	Logic.SetTechnologyState(2,Technologies.T_UpgradeBow3,0)

	Logic.SetTechnologyState(2,Technologies.UP1_Castle,0)
	--
	Logic.SetTechnologyState(2,Technologies.UP2_Castle,0)
	Logic.SetTechnologyState(2,Technologies.UP3_Castle,0)
	Logic.SetTechnologyState(2,Technologies.UP4_Castle,0)
	for i = 1,2 do
		Logic.SetTechnologyState(i,Technologies.B_Weathermachine,0)
	end
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
function InitWeatherGfxSets()
end
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
function InitWeather()
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

	for i = 3,4 do
		Display.SetPlayerColorMapping(i, 2)
	end
	Display.SetPlayerColorMapping(5, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(6, 3)
	Display.SetPlayerColorMapping(8, NPC_COLOR)
end
function AnfangsBriefing()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("RD_ArmyPL2Assault","Übersicht der Lage","@color:230,0,0 Eine äußerst wichtige Pilgerstätte, die Kapelle von Antrium ist bedroht. @cr Verteidigt das Bauwerk mit Euren Truppen aus dem nahegelegen Militärlager.", false)
	ASP("P4","Übersicht der Lage","@color:230,0,0 Der skrupellose Graf Nerlon der Jüngere sendet ständig neue Truppen aus seiner Burg aus, um die Kapelle zu zerstören. @cr Anscheinend hat er etwas gegen sie...", false)
	ASP("Spawn_1_PL1","Übersicht der Lage","@color:230,0,0 Die Stadt Antrium ist die Quelle Eurer wirtschaftlichen Macht. Sie ist von dem südwestlich gelegenen Landesteil abgeschnitten. Nur kleinere Scharmützel sind hier an der Tagesordnung. @cr Denkt daran, dass Eure Burg nicht fallen darf.", false)
	ASP("HQ_PL3","Übersicht der Lage","@color:230,0,0 Sobald die See zufriert, wird Graf Nerlon der Ältere mit seiner Streitmacht auf Eure Stadt zustürmen.", false)
	ASP("HQ_PL3","Missionsziele","@color:230,0,0 Zerstört die Burg Graf Nerlons des Älteren sowie die Burg seines jüngeren Bruders! @cr Vernichtet alle restlichen Feinde! @cr Doch vergesst nicht, Eure Stadt und die Kapelle vor Angriffen zu schützen und sie zu verteidigen.", false)

	briefing.finished = function()
		Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
		TributeP1_Easy()
		TributeP1_Normal()
		TributeP1_Hard()
		TributeP1_Challenge()
	end
    StartBriefing(briefing)
end
function StartInitialize()
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero1", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero2", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero5", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero9", 0)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
		if GetClay(i) > 0 then
			AddClay(i,-(GetClay(i)))
		end
		if GetIron(i) > 0 then
			AddIron(i,-(GetIron(i)))
		end
		if GetStone(i) > 0 then
			AddStone(i,-(GetStone(i)))
		end
	end
	InitResources()
	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end
	Merchant()
	InitTechnologies()
	Beeildich = StartCountdown((30+20*gvDiffLVL)*60,WinterIsComing,true)
	FarbigeNamen()
	StartSimpleJob("NPCControl")
	EnableNpcMarker(GetEntityId("serf"))
	EnableNpcMarker(GetEntityId("monk"))
	EnableNpcMarker(GetEntityId("alchemist"))
	EnableNpcMarker(GetEntityId("smith"))
	EnableNpcMarker(GetEntityId("wanderer"))
	EnableNpcMarker(GetEntityId("johannes"))
	EnableNpcMarker(GetEntityId("builder"))
	EnableNpcMarker(GetEntityId("afraid_alchemist"))

	CreatePlayer3()
	CreatePlayer4()
	CreatePlayer5()

	StartSimpleJob("VictoryJob")
	StartSimpleJob("ControlDefeat")
	StartSimpleJob("KillScoreBonus1")

	CreateDefendingArmies()
	SetFriendly(1,2)
	Logic.SetPlayerPaysLeaderFlag(2, 0)

end

function WinterIsComing()

	StartWinter(60*60*60)
	StartCountdown(30, TroopSpawnVorb, false)
	SetHostile(1,6)
	SetHostile(2,6)
	StartCountdown(10*60*gvDiffLVL, CaveAttack, false)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChanger", 1)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "AntiSpawnCampTrigger", 1)
	StartCountdown(6*60*gvDiffLVL, UpgradeAI3, false)
end
function AntiSpawnCampTrigger()

	local attacker = Event.GetEntityID1()
    local target = Event.GetEntityID2()
	local targetpos = GetPosition(target)
	local pID = GetPlayer(target)

	if pID == 6 then
		if math.abs(GetDistance(targetpos,GetPosition("cave"))) <= 2000 then
			CEntity.TriggerSetDamage(0)
		end
	end

end
function WeatherChanger()
	local newWeather = Event.GetNewWeatherState()
	if newWeather ~= 3 then
		StartWinter(60*60*60)
	end
end

function Merchant()

	local mercenaryId = Logic.GetEntityIDByName("merc1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderRifle2, 9, ResourceType.Sulfur, dekaround(900/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PV_Cannon3, 5, ResourceType.Gold, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, 15, ResourceType.Iron, dekaround(600/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow4, 9, ResourceType.Iron, dekaround(900/gvDiffLVL))

	local mercenaryId = Logic.GetEntityIDByName("merc2")
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BanditLeaderSword2, 9, ResourceType.Gold, dekaround(600/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BanditLeaderBow1, 5, ResourceType.Wood, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderMace2, 9, ResourceType.Iron, dekaround(600/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.CU_Barbarian_LeaderClub2, 16, ResourceType.Gold, dekaround(700/gvDiffLVL))

end

function CreateDefendingArmies()

	local army	 = {}
	army.player 	= AllyPID
	army.id			= 1
	army.strength	= round(2*gvDiffLVL)
	army.position	= GetPosition("Spawn_2_PL1")
	army.rodeLength	= 100

	SetupArmy(army)

	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType          = Entities.PU_LeaderBow3
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	local army	 = {}
	army.player 	= AllyPID
	army.id			= 2
	army.strength	= round(3*gvDiffLVL)
	army.position	= GetPosition("Spawn_3_PL1")
	army.rodeLength	= 100

	SetupArmy(army)

	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType          = Entities.PU_LeaderSword3
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	ArmyData = {
				[3] = {{strength = round(6/gvDiffLVL), position = GetPosition("P3_Spawn1"), rodeLength = 7000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "P3_Tower1"},
					{strength = round(4/gvDiffLVL), position = GetPosition("P3_Spawn2"), rodeLength = 11000, leaderType = Entities["PU_LeaderSword" .. round(5 - gvDiffLVL)], building = "P3_Tower2"},
					{strength = round(8/gvDiffLVL), position = GetPosition("P3_Spawn2"), rodeLength = 12000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "P3_Tower2"},
					{strength = round(6/gvDiffLVL), position = GetPosition("SP_ArmyPL3Assault1"), rodeLength = 10000, leaderType = Entities.PU_LeaderCavalry2, building = "P3_Tower2"},
					{strength = round(6/gvDiffLVL), position = GetPosition("SP_ArmyPL3DefHQ"), rodeLength = 14000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "HQ_PL3"},
					{strength = round(4/gvDiffLVL), position = GetPosition("P3_Lighthouse_Guard"), rodeLength = 5000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "Lighthouse_P3"}
				},
				[4] = {{strength = round(6/gvDiffLVL), position = GetPosition("SP_ArmyPL2DefHQ"), rodeLength = 10000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "P4HQ"},
					{strength = round(4/gvDiffLVL), position = GetPosition("SP_ArmyPL2DefHQ"), rodeLength = 10000, leaderType = Entities["PU_LeaderSword" .. round(5 - gvDiffLVL)], building = "P4HQ"},
					{strength = round(4/gvDiffLVL), position = GetPosition("SP_ArmyPL2DefHQ"), rodeLength = 10000, leaderType = Entities["PU_LeaderPoleArm" .. round(5 - gvDiffLVL)], building = "P4HQ"},
					{strength = round(4/gvDiffLVL), position = GetPosition("P4_Spawn1"), rodeLength = 5000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "P4_Tower1"},
					{strength = round(7/gvDiffLVL), position = GetPosition("P4_Spawn2"), rodeLength = 5200, leaderType = Entities.PU_LeaderUlan1, building = "P4_Tower1"},
					{strength = round(4/gvDiffLVL), position = GetPosition("P4_Spawn3"), rodeLength = 6600, leaderType = Entities.PU_LeaderCavalry2, building = "P4_Tower2"},
					{strength = round(5/gvDiffLVL), position = GetPosition("P4_Spawn3"), rodeLength = 6600, leaderType = Entities.CU_BlackKnight_LeaderSword3, building = "P4_Tower2"}
				},
				[5] = {{strength = round(7/gvDiffLVL), position = GetPosition("SP_ArmyPL4DefHQ"), rodeLength = 6500, leaderType = Entities.CU_Barbarian_LeaderClub2, building = "HQ_PL5"},
					{strength = round(3/gvDiffLVL), position = GetPosition("SP_ArmyPL4DefHQ"), rodeLength = 6500, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "HQ_PL5"},
					{strength = round(4/gvDiffLVL), position = GetPosition("P5_Spawn2"), rodeLength = 10000, leaderType = Entities["PU_LeaderBow" .. round(5 - gvDiffLVL)], building = "P5_Tower2"},
					{strength = round(6/gvDiffLVL), position = GetPosition("P5_Spawn3"), rodeLength = 10000, leaderType = Entities.CU_Barbarian_LeaderClub2, building = "P5_Tower3"}
				}
			}

	for player = 3,5 do
		for index = 1, table.getn(ArmyData[player]) do
			CreateEnemyArmy(player, index)
		end
	end
end

function CreateEnemyArmy(_player, _index)

	local army	 	= {}
	army.player 	= _player
	army.id			= GetFirstFreeArmySlot(_player)
	army.strength	= ArmyData[_player][_index].strength
	army.position	= ArmyData[_player][_index].position
	army.rodeLength	= ArmyData[_player][_index].rodeLength

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType          = ArmyData[_player][_index].leaderType
	}
	for i = 1, army.strength do
		EnlargeArmy(army,troopDescription)
	end
	local building = ArmyData[_player][_index].building
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{_player, army.id, building, _index})
end

function CaveAttack()

	if CaveBlocked then
		return
	end
	if IsExisting("rock_nv") then
		DestroyEntity("rock_nv")
	end
	local army	 	= {}
	army.player 	= 6
	army.id			= GetFirstFreeArmySlot(6)
	army.strength	= math.min(3 + round(Logic.GetTime()/(60*10*gvDiffLVL)), round(15/gvDiffLVL))
	army.position	= GetPosition("cave")
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType          = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1,math.ceil(army.strength/2) do
		EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType          = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1,math.floor(army.strength/2) do
		EnlargeArmy(army,troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
	StartCountdown(10*60*gvDiffLVL, CaveAttack, false)
end

function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.floor(math.min((3.0+((math.random(1,5)/10))) *60, 8*60/(math.sqrt(gvDiffLVL))))
	TroopSpawn(TimePassed)
	SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
end
trooptypes = {Entities.PU_LeaderBow4,Entities.CU_BlackKnight_LeaderSword3,Entities.PU_LeaderSword4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.CU_BanditLeaderSword2},
				[2] = {Entities.CU_BanditLeaderSword2, Entities.CU_BanditLeaderBow1},
				[3] = {Entities.CU_BanditLeaderSword2, Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2, Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			}
function TroopSpawn(_TimePassed)
	Message("Truppen Nerlons des Älteren versammeln sich, um die Kirche von Antrium zu vernichten!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_varg, 120)
	--local type1,type2,type3,type4
	for i = 1,3 do
		if _TimePassed <= 6 then
			CreateAttackingArmies("InvasionSpawn", i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies("InvasionSpawn", i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 24 then
			CreateAttackingArmies("InvasionSpawn", i, 3)

		elseif _TimePassed > 24 and _TimePassed <= 38 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("InvasionSpawn", i, 4)

		elseif _TimePassed > 38 and _TimePassed <= 50 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("InvasionSpawn", i, 5)

		elseif _TimePassed > 50 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("InvasionSpawn", i, 6)
		end
	end
end
InvasionArmyIDByPattern = {["InvasionSpawn"] = {}}
function CreateAttackingArmies(_name, _poscount, _index)
	local player = 3
	if _poscount == 2 or _poscount == 3 then
		player = 5
	end
	local pos = GetPosition(_name .. _poscount)
	if not ArePlayerBuildingsInArea(player, pos.X, pos.Y, 2000) then
		return
	end
	local army	= {}
	local id = InvasionArmyIDByPattern[_name][_poscount]
	if not id then
		army.player = player
		army.id	  	=  GetFirstFreeArmySlot(player)
		army.strength = table.getn(armytroops[_index])
		army.position = GetPosition(_name .. _poscount)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		InvasionArmyIDByPattern[_name][_poscount] = army.id
	else
		army = ArmyTable[player][id+1]
		army.strength = table.getn(armytroops[_index])
	end
	for i = 1, army.strength do
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = armytroops[_index][i]
		EnlargeArmy(army, troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})

end

function ControlArmies(_player, _id, _building, _index)

    if not _building then
		if IsDead(ArmyTable[_player][_id + 1]) then
			return true
		end
	else
		if IsVeryWeak(ArmyTable[_player][_id + 1]) and IsExisting(_building) then
			if Counter.Tick2("ControlArmies_" .. _player .. "_" .. _id, round(45*gvDiffLVL)) then
				CreateEnemyArmy(_player, _index)
				return true
			end
		end
	end
	Defend(ArmyTable[_player][_id + 1])
end

function VictoryJob()

	local count = 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(3,4,5), CEntityIterator.IsSettlerOrBuildingFilter()) do
		if not IsDead(eID) then
			count = count + 1
			break
		end
	end
	if count == 0 then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map6_won", 2)
				end
			end
		end
		Victory()
	end

end

function ControlDefeat()

	if IsDead("HQ_PL1") or IsDead("Kathedrale") then
		Defeat()
		return true
	end

end

---------------------------------------------------------------------------------------------
-- CREATE AI Player 3 (Graf Nerlon Senior)
---------------------------------------------------------------------------------------------
function CreatePlayer3()

	MapEditor_SetupAI(3, 3, 70000, round(4-gvDiffLVL), "SP_ArmyPL3DefHQ", 3, 0)
	MapEditor_Armies[3].offensiveArmies.strength = round(30/gvDiffLVL)
	MapEditor_Armies[3].defensiveArmies.strength = round(10/gvDiffLVL)
end
---------------------------------------------------------------------------------------------
-- CREATE AI Player 4 (Graf Nerlon Junior)
---------------------------------------------------------------------------------------------
function CreatePlayer4()

	MapEditor_SetupAI(4, 3, 70000, round(4-gvDiffLVL), "P4", 3, 0)
	MapEditor_Armies[4].offensiveArmies.strength = round(12/gvDiffLVL)
	MapEditor_Armies[4].defensiveArmies.strength = round(10/gvDiffLVL)
	table.insert(MapEditor_Armies[4].ForbiddenTypes, UpgradeCategories.LeaderBow)
	StartCountdown(10*60*gvDiffLVL, UpgradeAI4, false)
end
---------------------------------------------------------------------------------------------
-- CREATE AI Player 5 (Raubritter Varg)
---------------------------------------------------------------------------------------------
function CreatePlayer5()

end
---------------------------------------------------------------------------------------------
-- BRIEFINGS
---------------------------------------------------------------------------------------------
function Serf()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("serf",serf,"@color:20,255,50 Ich... @cr Ich konnte entkommen. @cr Aber all meine Kameraden waren weniger glücklich.", false)
	ASP("InvasionSpawn4",serf,"@color:20,255,50 Sie wurden auf diese Insel verschleppt und werden im Leuchtturm festgehalten.", false)
	ASP("serf",serf,"@color:20,255,50 Bitte mein Herr. @cr Befreit sie!", false)

    briefing.finished = function()
		local id = ReplaceEntity("serf", Entities.PU_Serf)
		ChangePlayer(id, AllyPID)
		StartSimpleJob("CheckForPrisonersFreed")
  	end
	StartBriefing(briefing)
end
function CheckForPrisonersFreed()
	if not AreEntitiesOfDiplomacyStateInArea(1, {X = 16400, Y = 30800}, 2000, Diplomacy.Hostile) then
		for i = 1, round(5*gvDiffLVL) do
			Logic.CreateEntity(Entities.PU_Serf, 15600 - 100*i, 31000 - 100*i, math.random(360), AllyPID)
		end
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("InvasionSpawn4",serf,"@color:20,255,50 Danke, dass ihr uns befreit habt. @cr Wir hatten schon kaum noch Hoffnung.", false)

		briefing.finished = function()
		end
		StartBriefing(briefing)
		return true
	end
end
function Monk()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("monk",monk,"@color:20,255,50 Früher stand hier mal eine Abtei. @cr Ihr seht ja, was dieser Bastard Nerlon der Jüngere davon übrig gelassen hat...", false)
	ASP("monk",monk,"@color:20,255,50 Auch, wenn es nur noch Ruinen sind... @cr Ich konnte einige Vetriebene bisher erfolgreich hier verstecken.", false)
	ASP("monk",monk,"@color:20,255,50 Sie dürsten nach Rache. @cr Befehligt sie und erteilt diesem Bastard eine Lektion!", false)

    briefing.finished = function()
		local army	 = {}
		army.player 	= AllyPID
		army.id			= 3
		army.strength	= round(3*gvDiffLVL)
		army.position	= GetPosition("monk")
		army.rodeLength	= 100

		SetupArmy(army)

		local troopDescription = {

			experiencePoints 	= HIGH_EXPERIENCE,
			leaderType          = Entities.CU_BanditLeaderSword1
		}

		for i = 1,army.strength do
			EnlargeArmy(army,troopDescription)
		end
  	end
	StartBriefing(briefing)
end
function alchemist()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("alchemist",alch,"@color:20,255,50 Seht ihr all diese Felsen hinter mir?", false)
	ASP("alchemist",alch,"@color:20,255,50 Gebt mir ein wenig Schwefel und ich werde dort ein paar Sprengsätze anbringen. @cr Das sollte reichen, um die Felsen aus dem Weg zu räumen.", false)

    briefing.finished = function()
		AlchSouthTribute()
  	end
	StartBriefing(briefing)
end
function AlchSouthTribute()
	local tribute =  {}
	tribute.playerId = TributePID;
	tribute.text = "@color:230,0,0 Zahlt " .. dekaround(1000/gvDiffLVL) .. " Schwefel, damit der Alchemist einen Sprengsatz konstruieren kann und die Felsen wegsprengt.";
	tribute.cost = {Sulfur = dekaround(1000/gvDiffLVL)}
	tribute.Callback = PayedTributeAlchSouth
	AddTribute(tribute)
end
function PayedTributeAlchSouth()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("alchemist",alch,"@color:20,255,50 Der Sprengsatz ist fertig. @cr Der Weg wird gleich frei sein.", false)

    briefing.finished = function()
		StartCountdown(5, SouthExplosion, false)
  	end
	StartBriefing(briefing)
end
function SouthExplosion()
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, 12600, 12900)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, 12500, 12000)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, 12600, 11300)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, 12600, 10600)
	for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(11900, 11800, 1200),
	CEntityIterator.OfAnyTypeFilter(Entities.XD_RockMedium3, Entities.XD_RockMedium4, Entities.XD_RockMedium5, Entities.XD_RockKhakiBright5)) do
		DestroyEntity(eID)
	end
	Logic.SetTerrainNodeHeight(115, 104,  2712);
	Logic.SetTerrainNodeHeight(116, 104,  2703);
	Logic.SetTerrainNodeHeight(117, 104,  2699);
	Logic.SetTerrainNodeHeight(118, 104,  2696);
	Logic.SetTerrainNodeHeight(119, 104,  2695);
	Logic.SetTerrainNodeHeight(120, 104,  2696);
	Logic.SetTerrainNodeHeight(121, 104,  2698);
	Logic.SetTerrainNodeHeight(122, 104,  2704);
	Logic.SetTerrainNodeHeight(123, 104,  2707);
	Logic.SetTerrainNodeHeight(124, 104,  2704);
	Logic.SetTerrainNodeHeight(126, 104,  2676);
	Logic.SetTerrainNodeHeight(115, 105,  2714);
	Logic.SetTerrainNodeHeight(116, 105,  2710);
	Logic.SetTerrainNodeHeight(117, 105,  2706);
	Logic.SetTerrainNodeHeight(118, 105,  2703);
	Logic.SetTerrainNodeHeight(119, 105,  2702);
	Logic.SetTerrainNodeHeight(120, 105,  2703);
	Logic.SetTerrainNodeHeight(121, 105,  2707);
	Logic.SetTerrainNodeHeight(122, 105,  2714);
	Logic.SetTerrainNodeHeight(123, 105,  2725);
	Logic.SetTerrainNodeHeight(124, 105,  2725);
	Logic.SetTerrainNodeHeight(125, 105,  2716);
	Logic.SetTerrainNodeHeight(126, 105,  2762);
	Logic.SetTerrainNodeHeight(115, 106,  2721);
	Logic.SetTerrainNodeHeight(116, 106,  2715);
	Logic.SetTerrainNodeHeight(117, 106,  2711);
	Logic.SetTerrainNodeHeight(118, 106,  2708);
	Logic.SetTerrainNodeHeight(119, 106,  2707);
	Logic.SetTerrainNodeHeight(120, 106,  2709);
	Logic.SetTerrainNodeHeight(121, 106,  2712);
	Logic.SetTerrainNodeHeight(122, 106,  2718);
	Logic.SetTerrainNodeHeight(123, 106,  2725);
	Logic.SetTerrainNodeHeight(124, 106,  2726);
	Logic.SetTerrainNodeHeight(125, 106,  2730);
	Logic.SetTerrainNodeHeight(126, 106,  2753);
	Logic.SetTerrainNodeHeight(115, 107,  2722);
	Logic.SetTerrainNodeHeight(116, 107,  2719);
	Logic.SetTerrainNodeHeight(117, 107,  2715);
	Logic.SetTerrainNodeHeight(118, 107,  2713);
	Logic.SetTerrainNodeHeight(119, 107,  2712);
	Logic.SetTerrainNodeHeight(120, 107,  2713);
	Logic.SetTerrainNodeHeight(121, 107,  2716);
	Logic.SetTerrainNodeHeight(122, 107,  2719);
	Logic.SetTerrainNodeHeight(123, 107,  2723);
	Logic.SetTerrainNodeHeight(124, 107,  2726);
	Logic.SetTerrainNodeHeight(125, 107,  2729);
	Logic.SetTerrainNodeHeight(126, 107,  2730);
	Logic.SetTerrainNodeHeight(115, 108,  2724);
	Logic.SetTerrainNodeHeight(116, 108,  2721);
	Logic.SetTerrainNodeHeight(117, 108,  2719);
	Logic.SetTerrainNodeHeight(118, 108,  2716);
	Logic.SetTerrainNodeHeight(119, 108,  2716);
	Logic.SetTerrainNodeHeight(120, 108,  2716);
	Logic.SetTerrainNodeHeight(121, 108,  2718);
	Logic.SetTerrainNodeHeight(122, 108,  2720);
	Logic.SetTerrainNodeHeight(123, 108,  2722);
	Logic.SetTerrainNodeHeight(124, 108,  2724);
	Logic.SetTerrainNodeHeight(125, 108,  2726);
	Logic.SetTerrainNodeHeight(126, 108,  2726);
	Logic.SetTerrainNodeHeight(127, 108,  2726);
	Logic.SetTerrainNodeHeight(128, 108,  2724);
	Logic.SetTerrainNodeHeight(115, 109,  2727);
	Logic.SetTerrainNodeHeight(116, 109,  2724);
	Logic.SetTerrainNodeHeight(117, 109,  2721);
	Logic.SetTerrainNodeHeight(118, 109,  2720);
	Logic.SetTerrainNodeHeight(119, 109,  2719);
	Logic.SetTerrainNodeHeight(120, 109,  2719);
	Logic.SetTerrainNodeHeight(121, 109,  2719);
	Logic.SetTerrainNodeHeight(122, 109,  2721);
	Logic.SetTerrainNodeHeight(123, 109,  2722);
	Logic.SetTerrainNodeHeight(124, 109,  2723);
	Logic.SetTerrainNodeHeight(125, 109,  2724);
	Logic.SetTerrainNodeHeight(126, 109,  2724);
	Logic.SetTerrainNodeHeight(127, 109,  2725);
	Logic.SetTerrainNodeHeight(128, 109,  2725);
	Logic.SetTerrainNodeHeight(114, 110,  2730);
	Logic.SetTerrainNodeHeight(115, 110,  2728);
	Logic.SetTerrainNodeHeight(116, 110,  2726);
	Logic.SetTerrainNodeHeight(117, 110,  2724);
	Logic.SetTerrainNodeHeight(118, 110,  2723);
	Logic.SetTerrainNodeHeight(119, 110,  2722);
	Logic.SetTerrainNodeHeight(120, 110,  2721);
	Logic.SetTerrainNodeHeight(121, 110,  2721);
	Logic.SetTerrainNodeHeight(122, 110,  2722);
	Logic.SetTerrainNodeHeight(123, 110,  2722);
	Logic.SetTerrainNodeHeight(124, 110,  2723);
	Logic.SetTerrainNodeHeight(125, 110,  2723);
	Logic.SetTerrainNodeHeight(126, 110,  2724);
	Logic.SetTerrainNodeHeight(127, 110,  2725);
	Logic.SetTerrainNodeHeight(128, 110,  2726);
	Logic.SetTerrainNodeHeight(113, 111,  2730);
	Logic.SetTerrainNodeHeight(114, 111,  2730);
	Logic.SetTerrainNodeHeight(115, 111,  2730);
	Logic.SetTerrainNodeHeight(116, 111,  2728);
	Logic.SetTerrainNodeHeight(117, 111,  2727);
	Logic.SetTerrainNodeHeight(118, 111,  2726);
	Logic.SetTerrainNodeHeight(119, 111,  2725);
	Logic.SetTerrainNodeHeight(120, 111,  2724);
	Logic.SetTerrainNodeHeight(121, 111,  2724);
	Logic.SetTerrainNodeHeight(122, 111,  2724);
	Logic.SetTerrainNodeHeight(123, 111,  2724);
	Logic.SetTerrainNodeHeight(124, 111,  2724);
	Logic.SetTerrainNodeHeight(125, 111,  2724);
	Logic.SetTerrainNodeHeight(126, 111,  2724);
	Logic.SetTerrainNodeHeight(127, 111,  2725);
	Logic.SetTerrainNodeHeight(128, 111,  2727);
	Logic.SetTerrainNodeHeight(129, 111,  2730);
	Logic.SetTerrainNodeHeight(113, 112,  2730);
	Logic.SetTerrainNodeHeight(114, 112,  2730);
	Logic.SetTerrainNodeHeight(115, 112,  2730);
	Logic.SetTerrainNodeHeight(116, 112,  2730);
	Logic.SetTerrainNodeHeight(117, 112,  2730);
	Logic.SetTerrainNodeHeight(118, 112,  2730);
	Logic.SetTerrainNodeHeight(119, 112,  2729);
	Logic.SetTerrainNodeHeight(120, 112,  2728);
	Logic.SetTerrainNodeHeight(121, 112,  2727);
	Logic.SetTerrainNodeHeight(122, 112,  2726);
	Logic.SetTerrainNodeHeight(123, 112,  2725);
	Logic.SetTerrainNodeHeight(124, 112,  2725);
	Logic.SetTerrainNodeHeight(125, 112,  2725);
	Logic.SetTerrainNodeHeight(126, 112,  2725);
	Logic.SetTerrainNodeHeight(127, 112,  2725);
	Logic.SetTerrainNodeHeight(128, 112,  2727);
	Logic.SetTerrainNodeHeight(129, 112,  2730);
	Logic.SetTerrainNodeHeight(130, 112,  2730);
	Logic.SetTerrainNodeHeight(113, 113,  2730);
	Logic.SetTerrainNodeHeight(114, 113,  2730);
	Logic.SetTerrainNodeHeight(115, 113,  2730);
	Logic.SetTerrainNodeHeight(116, 113,  2730);
	Logic.SetTerrainNodeHeight(117, 113,  2730);
	Logic.SetTerrainNodeHeight(118, 113,  2730);
	Logic.SetTerrainNodeHeight(119, 113,  2729);
	Logic.SetTerrainNodeHeight(120, 113,  2728);
	Logic.SetTerrainNodeHeight(121, 113,  2727);
	Logic.SetTerrainNodeHeight(122, 113,  2726);
	Logic.SetTerrainNodeHeight(123, 113,  2725);
	Logic.SetTerrainNodeHeight(124, 113,  2725);
	Logic.SetTerrainNodeHeight(125, 113,  2725);
	Logic.SetTerrainNodeHeight(126, 113,  2725);
	Logic.SetTerrainNodeHeight(127, 113,  2725);
	Logic.SetTerrainNodeHeight(128, 113,  2727);
	Logic.SetTerrainNodeHeight(129, 113,  2730);
	Logic.SetTerrainNodeHeight(130, 113,  2730);
	Logic.SetTerrainNodeHeight(131, 113,  2730);
	Logic.SetTerrainNodeHeight(113, 114,  2730);
	Logic.SetTerrainNodeHeight(114, 114,  2730);
	Logic.SetTerrainNodeHeight(115, 114,  2730);
	Logic.SetTerrainNodeHeight(116, 114,  2730);
	Logic.SetTerrainNodeHeight(117, 114,  2730);
	Logic.SetTerrainNodeHeight(118, 114,  2730);
	Logic.SetTerrainNodeHeight(119, 114,  2729);
	Logic.SetTerrainNodeHeight(120, 114,  2728);
	Logic.SetTerrainNodeHeight(121, 114,  2727);
	Logic.SetTerrainNodeHeight(122, 114,  2726);
	Logic.SetTerrainNodeHeight(123, 114,  2725);
	Logic.SetTerrainNodeHeight(124, 114,  2725);
	Logic.SetTerrainNodeHeight(125, 114,  2725);
	Logic.SetTerrainNodeHeight(126, 114,  2725);
	Logic.SetTerrainNodeHeight(127, 114,  2725);
	Logic.SetTerrainNodeHeight(128, 114,  2727);
	Logic.SetTerrainNodeHeight(129, 114,  2730);
	Logic.SetTerrainNodeHeight(130, 114,  2730);
	Logic.SetTerrainNodeHeight(131, 114,  2730);
	Logic.SetTerrainNodeHeight(113, 115,  2730);
	Logic.SetTerrainNodeHeight(114, 115,  2730);
	Logic.SetTerrainNodeHeight(115, 115,  2730);
	Logic.SetTerrainNodeHeight(116, 115,  2730);
	Logic.SetTerrainNodeHeight(117, 115,  2730);
	Logic.SetTerrainNodeHeight(118, 115,  2730);
	Logic.SetTerrainNodeHeight(119, 115,  2729);
	Logic.SetTerrainNodeHeight(120, 115,  2728);
	Logic.SetTerrainNodeHeight(121, 115,  2727);
	Logic.SetTerrainNodeHeight(122, 115,  2726);
	Logic.SetTerrainNodeHeight(123, 115,  2725);
	Logic.SetTerrainNodeHeight(124, 115,  2725);
	Logic.SetTerrainNodeHeight(125, 115,  2725);
	Logic.SetTerrainNodeHeight(126, 115,  2725);
	Logic.SetTerrainNodeHeight(127, 115,  2725);
	Logic.SetTerrainNodeHeight(128, 115,  2727);
	Logic.SetTerrainNodeHeight(129, 115,  2730);
	Logic.SetTerrainNodeHeight(130, 115,  2730);
	Logic.SetTerrainNodeHeight(131, 115,  2730);
	Logic.SetTerrainNodeHeight(112, 116,  2730);
	Logic.SetTerrainNodeHeight(113, 116,  2730);
	Logic.SetTerrainNodeHeight(114, 116,  2730);
	Logic.SetTerrainNodeHeight(115, 116,  2730);
	Logic.SetTerrainNodeHeight(116, 116,  2730);
	Logic.SetTerrainNodeHeight(117, 116,  2730);
	Logic.SetTerrainNodeHeight(118, 116,  2730);
	Logic.SetTerrainNodeHeight(119, 116,  2729);
	Logic.SetTerrainNodeHeight(120, 116,  2728);
	Logic.SetTerrainNodeHeight(121, 116,  2728);
	Logic.SetTerrainNodeHeight(122, 116,  2727);
	Logic.SetTerrainNodeHeight(123, 116,  2726);
	Logic.SetTerrainNodeHeight(124, 116,  2726);
	Logic.SetTerrainNodeHeight(125, 116,  2726);
	Logic.SetTerrainNodeHeight(126, 116,  2726);
	Logic.SetTerrainNodeHeight(127, 116,  2726);
	Logic.SetTerrainNodeHeight(128, 116,  2727);
	Logic.SetTerrainNodeHeight(129, 116,  2728);
	Logic.SetTerrainNodeHeight(130, 116,  2728);
	Logic.SetTerrainNodeHeight(131, 116,  2730);
	Logic.SetTerrainNodeHeight(112, 117,  2730);
	Logic.SetTerrainNodeHeight(113, 117,  2730);
	Logic.SetTerrainNodeHeight(114, 117,  2730);
	Logic.SetTerrainNodeHeight(115, 117,  2730);
	Logic.SetTerrainNodeHeight(116, 117,  2730);
	Logic.SetTerrainNodeHeight(117, 117,  2730);
	Logic.SetTerrainNodeHeight(118, 117,  2730);
	Logic.SetTerrainNodeHeight(119, 117,  2730);
	Logic.SetTerrainNodeHeight(120, 117,  2730);
	Logic.SetTerrainNodeHeight(121, 117,  2730);
	Logic.SetTerrainNodeHeight(122, 117,  2730);
	Logic.SetTerrainNodeHeight(123, 117,  2728);
	Logic.SetTerrainNodeHeight(124, 117,  2727);
	Logic.SetTerrainNodeHeight(125, 117,  2726);
	Logic.SetTerrainNodeHeight(126, 117,  2726);
	Logic.SetTerrainNodeHeight(127, 117,  2726);
	Logic.SetTerrainNodeHeight(128, 117,  2726);
	Logic.SetTerrainNodeHeight(129, 117,  2726);
	Logic.SetTerrainNodeHeight(130, 117,  2727);
	Logic.SetTerrainNodeHeight(131, 117,  2728);
	Logic.SetTerrainNodeHeight(112, 118,  2730);
	Logic.SetTerrainNodeHeight(113, 118,  2730);
	Logic.SetTerrainNodeHeight(114, 118,  2730);
	Logic.SetTerrainNodeHeight(115, 118,  2730);
	Logic.SetTerrainNodeHeight(116, 118,  2730);
	Logic.SetTerrainNodeHeight(117, 118,  2730);
	Logic.SetTerrainNodeHeight(118, 118,  2730);
	Logic.SetTerrainNodeHeight(119, 118,  2728);
	Logic.SetTerrainNodeHeight(120, 118,  2727);
	Logic.SetTerrainNodeHeight(121, 118,  2727);
	Logic.SetTerrainNodeHeight(122, 118,  2727);
	Logic.SetTerrainNodeHeight(123, 118,  2726);
	Logic.SetTerrainNodeHeight(124, 118,  2725);
	Logic.SetTerrainNodeHeight(125, 118,  2724);
	Logic.SetTerrainNodeHeight(126, 118,  2724);
	Logic.SetTerrainNodeHeight(127, 118,  2724);
	Logic.SetTerrainNodeHeight(128, 118,  2724);
	Logic.SetTerrainNodeHeight(129, 118,  2725);
	Logic.SetTerrainNodeHeight(130, 118,  2725);
	Logic.SetTerrainNodeHeight(131, 118,  2726);
	Logic.SetTerrainNodeHeight(112, 119,  2730);
	Logic.SetTerrainNodeHeight(113, 119,  2730);
	Logic.SetTerrainNodeHeight(114, 119,  2730);
	Logic.SetTerrainNodeHeight(115, 119,  2729);
	Logic.SetTerrainNodeHeight(116, 119,  2728);
	Logic.SetTerrainNodeHeight(117, 119,  2728);
	Logic.SetTerrainNodeHeight(118, 119,  2728);
	Logic.SetTerrainNodeHeight(119, 119,  2726);
	Logic.SetTerrainNodeHeight(120, 119,  2725);
	Logic.SetTerrainNodeHeight(121, 119,  2724);
	Logic.SetTerrainNodeHeight(122, 119,  2724);
	Logic.SetTerrainNodeHeight(123, 119,  2723);
	Logic.SetTerrainNodeHeight(124, 119,  2723);
	Logic.SetTerrainNodeHeight(125, 119,  2722);
	Logic.SetTerrainNodeHeight(126, 119,  2722);
	Logic.SetTerrainNodeHeight(127, 119,  2723);
	Logic.SetTerrainNodeHeight(128, 119,  2724);
	Logic.SetTerrainNodeHeight(129, 119,  2724);
	Logic.SetTerrainNodeHeight(130, 119,  2724);
	Logic.SetTerrainNodeHeight(131, 119,  2724);
	Logic.SetTerrainNodeHeight(112, 120,  2730);
	Logic.SetTerrainNodeHeight(113, 120,  2730);
	Logic.SetTerrainNodeHeight(114, 120,  2730);
	Logic.SetTerrainNodeHeight(115, 120,  2728);
	Logic.SetTerrainNodeHeight(116, 120,  2727);
	Logic.SetTerrainNodeHeight(117, 120,  2726);
	Logic.SetTerrainNodeHeight(118, 120,  2726);
	Logic.SetTerrainNodeHeight(119, 120,  2724);
	Logic.SetTerrainNodeHeight(120, 120,  2723);
	Logic.SetTerrainNodeHeight(121, 120,  2722);
	Logic.SetTerrainNodeHeight(122, 120,  2721);
	Logic.SetTerrainNodeHeight(123, 120,  2721);
	Logic.SetTerrainNodeHeight(124, 120,  2721);
	Logic.SetTerrainNodeHeight(125, 120,  2720);
	Logic.SetTerrainNodeHeight(126, 120,  2721);
	Logic.SetTerrainNodeHeight(127, 120,  2724);
	Logic.SetTerrainNodeHeight(128, 120,  2725);
	Logic.SetTerrainNodeHeight(112, 121,  2729);
	Logic.SetTerrainNodeHeight(113, 121,  2728);
	Logic.SetTerrainNodeHeight(114, 121,  2728);
	Logic.SetTerrainNodeHeight(115, 121,  2726);
	Logic.SetTerrainNodeHeight(116, 121,  2725);
	Logic.SetTerrainNodeHeight(117, 121,  2725);
	Logic.SetTerrainNodeHeight(118, 121,  2724);
	Logic.SetTerrainNodeHeight(119, 121,  2723);
	Logic.SetTerrainNodeHeight(120, 121,  2721);
	Logic.SetTerrainNodeHeight(121, 121,  2720);
	Logic.SetTerrainNodeHeight(122, 121,  2719);
	Logic.SetTerrainNodeHeight(123, 121,  2718);
	Logic.SetTerrainNodeHeight(124, 121,  2718);
	Logic.SetTerrainNodeHeight(125, 121,  2717);
	Logic.SetTerrainNodeHeight(126, 121,  2719);
	Logic.SetTerrainNodeHeight(127, 121,  2725);
	Logic.SetTerrainNodeHeight(128, 121,  2730);
	Logic.SetTerrainNodeHeight(129, 121,  2732);
	Logic.SetTerrainNodeHeight(130, 121,  2728);
	Logic.SetTerrainNodeHeight(112, 122,  2728);
	Logic.SetTerrainNodeHeight(113, 122,  2726);
	Logic.SetTerrainNodeHeight(114, 122,  2726);
	Logic.SetTerrainNodeHeight(115, 122,  2724);
	Logic.SetTerrainNodeHeight(116, 122,  2724);
	Logic.SetTerrainNodeHeight(117, 122,  2724);
	Logic.SetTerrainNodeHeight(118, 122,  2723);
	Logic.SetTerrainNodeHeight(119, 122,  2722);
	Logic.SetTerrainNodeHeight(120, 122,  2720);
	Logic.SetTerrainNodeHeight(121, 122,  2718);
	Logic.SetTerrainNodeHeight(122, 122,  2716);
	Logic.SetTerrainNodeHeight(123, 122,  2714);
	Logic.SetTerrainNodeHeight(124, 122,  2713);
	Logic.SetTerrainNodeHeight(125, 122,  2712);
	Logic.SetTerrainNodeHeight(126, 122,  2715);
	Logic.SetTerrainNodeHeight(127, 122,  2724);
	Logic.SetTerrainNodeHeight(128, 122,  2741);
	Logic.SetTerrainNodeHeight(129, 122,  2745);
	Logic.SetTerrainNodeHeight(130, 122,  2738);
	Logic.SetTerrainNodeHeight(131, 122,  2726);
	Logic.SetTerrainNodeHeight(112, 123,  2727);
	Logic.SetTerrainNodeHeight(113, 123,  2725);
	Logic.SetTerrainNodeHeight(114, 123,  2724);
	Logic.SetTerrainNodeHeight(115, 123,  2723);
	Logic.SetTerrainNodeHeight(116, 123,  2723);
	Logic.SetTerrainNodeHeight(117, 123,  2723);
	Logic.SetTerrainNodeHeight(118, 123,  2723);
	Logic.SetTerrainNodeHeight(119, 123,  2721);
	Logic.SetTerrainNodeHeight(120, 123,  2719);
	Logic.SetTerrainNodeHeight(121, 123,  2716);
	Logic.SetTerrainNodeHeight(122, 123,  2713);
	Logic.SetTerrainNodeHeight(123, 123,  2709);
	Logic.SetTerrainNodeHeight(124, 123,  2705);
	Logic.SetTerrainNodeHeight(125, 123,  2702);
	Logic.SetTerrainNodeHeight(126, 123,  2705);
	Logic.SetTerrainNodeHeight(127, 123,  2718);
	Logic.SetTerrainNodeHeight(128, 123,  2735);
	Logic.SetTerrainNodeHeight(129, 123,  2743);
	Logic.SetTerrainNodeHeight(130, 123,  2736);
	Logic.SetTerrainNodeHeight(131, 123,  2722);
	Logic.SetTerrainNodeHeight(112, 124,  2725);
	Logic.SetTerrainNodeHeight(113, 124,  2723);
	Logic.SetTerrainNodeHeight(114, 124,  2722);
	Logic.SetTerrainNodeHeight(115, 124,  2721);
	Logic.SetTerrainNodeHeight(116, 124,  2721);
	Logic.SetTerrainNodeHeight(117, 124,  2722);
	Logic.SetTerrainNodeHeight(118, 124,  2722);
	Logic.SetTerrainNodeHeight(119, 124,  2722);
	Logic.SetTerrainNodeHeight(120, 124,  2719);
	Logic.SetTerrainNodeHeight(121, 124,  2715);
	Logic.SetTerrainNodeHeight(122, 124,  2710);
	Logic.SetTerrainNodeHeight(123, 124,  2702);
	Logic.SetTerrainNodeHeight(124, 124,  2694);
	Logic.SetTerrainNodeHeight(125, 124,  2686);
	Logic.SetTerrainNodeHeight(126, 124,  2686);
	Logic.SetTerrainNodeHeight(127, 124,  2697);
	Logic.SetTerrainNodeHeight(128, 124,  2712);
	Logic.SetTerrainNodeHeight(129, 124,  2719);
	Logic.SetTerrainNodeHeight(130, 124,  2715);
	Logic.SetTerrainNodeHeight(131, 124,  2703);
	Logic.SetTerrainNodeHeight(112, 125,  2722);
	Logic.SetTerrainNodeHeight(113, 125,  2720);
	Logic.SetTerrainNodeHeight(114, 125,  2720);
	Logic.SetTerrainNodeHeight(115, 125,  2718);
	Logic.SetTerrainNodeHeight(116, 125,  2719);
	Logic.SetTerrainNodeHeight(117, 125,  2721);
	Logic.SetTerrainNodeHeight(118, 125,  2723);
	Logic.SetTerrainNodeHeight(119, 125,  2724);
	Logic.SetTerrainNodeHeight(120, 125,  2722);
	Logic.SetTerrainNodeHeight(121, 125,  2716);
	Logic.SetTerrainNodeHeight(122, 125,  2707);
	Logic.SetTerrainNodeHeight(123, 125,  2692);
	Logic.SetTerrainNodeHeight(124, 125,  2680);
	Logic.SetTerrainNodeHeight(125, 125,  2664);
	Logic.SetTerrainNodeHeight(126, 125,  2656);
	Logic.SetTerrainNodeHeight(127, 125,  2658);
	Logic.SetTerrainNodeHeight(128, 125,  2669);
	Logic.SetTerrainNodeHeight(129, 125,  2683);
	Logic.SetTerrainNodeHeight(130, 125,  2679);
	Logic.SetTerrainNodeHeight(131, 125,  2673);
	Logic.SetTerrainNodeHeight(112, 126,  2717);
	Logic.SetTerrainNodeHeight(113, 126,  2715);
	Logic.SetTerrainNodeHeight(114, 126,  2716);
	Logic.SetTerrainNodeHeight(115, 126,  2712);
	Logic.SetTerrainNodeHeight(116, 126,  2715);
	Logic.SetTerrainNodeHeight(117, 126,  2720);
	Logic.SetTerrainNodeHeight(118, 126,  2727);
	Logic.SetTerrainNodeHeight(119, 126,  2730);
	Logic.SetTerrainNodeHeight(120, 126,  2730);
	Logic.SetTerrainNodeHeight(121, 126,  2721);
	Logic.SetTerrainNodeHeight(122, 126,  2703);
	Logic.SetTerrainNodeHeight(123, 126,  2681);
	Logic.SetTerrainNodeHeight(124, 126,  2657);
	Logic.SetTerrainNodeHeight(125, 126,  2631);
	Logic.SetTerrainNodeHeight(126, 126,  2606);
	Logic.SetTerrainNodeHeight(127, 126,  2599);
	Logic.SetTerrainNodeHeight(128, 126,  2603);
	Logic.SetTerrainNodeHeight(129, 126,  2609);
	Logic.SetTerrainNodeHeight(130, 126,  2617);
	Logic.SetTerrainNodeHeight(112, 127,  2689);
	Logic.SetTerrainNodeHeight(113, 127,  2696);
	Logic.SetTerrainNodeHeight(114, 127,  2701);
	Logic.SetTerrainNodeHeight(115, 127,  2702);
	Logic.SetTerrainNodeHeight(116, 127,  2709);
	Logic.SetTerrainNodeHeight(117, 127,  2716);
	Logic.SetTerrainNodeHeight(118, 127,  2735);
	Logic.SetTerrainNodeHeight(119, 127,  2753);
	Logic.SetTerrainNodeHeight(120, 127,  2753);
	Logic.SetTerrainNodeHeight(121, 127,  2736);
	Logic.SetTerrainNodeHeight(122, 127,  2701);
	Logic.SetTerrainNodeHeight(123, 127,  2667);
	Logic.SetTerrainNodeHeight(124, 127,  2629);
	Logic.SetTerrainNodeHeight(126, 127,  2563);
	Logic.UpdateBlocking(112, 104, 132, 127)
end
function smith()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("smith",sm,"@color:20,255,50 Diese Schweine nahmen mir alles... @cr Meine Familie... @cr Meine Arbeit... @cr Mein Leben...", false)
	ASP("smith",sm,"@color:20,255,50 Und all das nur, weil ich mich weigerte, Waffen für diesen Nerlon herzustellen. @cr Diese Waffen verbreiten aber nichts als Elend...", false)
	ASP("smith",sm,"@color:20,255,50 Hier, nehmt. @cr Diese Waffen konnte ich verstecken. Erteilt diesem Bastard damit eine Lektion.", false)
	ASP("smith",sm,"@color:20,255,50 Nehmt auch die verbliebene Kohle. @cr Ich werde nie wieder etwas schmieden...", false)

    briefing.finished = function()
		for i = 1,2 do
			Logic.AddToPlayersGlobalResource(i, ResourceType.Knowledge, dekaround(600*gvDiffLVL))
			AddIron(i, dekaround(1500*gvDiffLVL))
		end
  	end
	StartBriefing(briefing)
end
function wanderer()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("wanderer",wan,"@color:20,255,50 Von hier aus hat man einen wunderbaren Blick auf die See.", false)
	ASP("InvasionSpawn2",wan,"@color:20,255,50 An der Küste haben sich aber kürzlich ein paar Räuber niedergelassen. @cr Schade eigentlich, da war ein schöner Badestrand.", false)
	ASP("P5_Tower3",wan,"@color:20,255,50 Auch auf der Insel dahinten haben die ihr Lager aufgeschlagen. @cr Zum Glück scheinen die keine guten Schwimmer zu sein...", false)

    briefing.finished = function()
  	end
	StartBriefing(briefing)
end
function johannes()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("johannes",joh,"@color:20,255,50 Es tut gut euch zu sehen. @cr Vor allem in diesen schweren Zeiten.", false)
	ASP("Kathedrale",joh,"@color:20,255,50 Die Priester der Kathedrale von Antrium hungern. @cr Schon seit Wochen sind keine Warenlieferungen mehr dort angekommen.", false)
	ASP("Kathedrale",joh,"@color:20,255,50 Sie werden sicher hungern. @cr Bitte Herr, eilt ihnen zu Hilfe und versorgt sie mit Nahrung.", false)
	ASP("johannes","Missionsziele","@color:20,255,50 1. Durchbricht die Barrikade und eilt nach Antrium. @cr 2. Errichtet einen Gutshof nahe der Kathedrale von Antrium.", false)

    briefing.finished = function()
		StartSimpleJob("CheckForFarm")
  	end
	StartBriefing(briefing)
end
function CheckForFarm()
	local num, id = Logic.GetEntitiesInArea(Entities.PB_Farm3, 4600, 25000, 3000, 1)
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Kathedrale",joh,"@color:20,255,50 Habt Dank, habt Dank. @cr Ihr nehmt mir damit eine große Last von den Schultern. @cr Hier, nehmt dies als Zeichen meiner Anerkennung.", false)
		briefing.finished = function()
			for i = 1,2 do
				AddGold(i, dekaround(4000*gvDiffLVL))
				Logic.AddToPlayersGlobalResource(i, ResourceType.Silver, round(200*gvDiffLVL))
			end
		end
		StartBriefing(briefing)
		ChangePlayer(id, AllyPID)
		return true
	end
end
function builder()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("bridgepos",bui,"@color:20,255,50 Hier in der Nähe wäre ein guter Bauplatz für eine Brücke.", false)
	ASP("builder",bui,"@color:20,255,50 Gebt mir einige Ressourcen und ich werde für euch einen Brücken-Bauplatz konstruieren.", false)

    briefing.finished = function()
		BridgeTribute()
  	end
	StartBriefing(briefing)
end
function BridgeTribute()
	local tribute =  {}
	tribute.playerId = TributePID;
	tribute.text = "@color:230,0,0 Zahlt " .. dekaround(2000/gvDiffLVL) .. " Holz, Lehm und Stein, damit der Brückenarchitekt ein Gerüst erstellen kann.";
	tribute.cost = {Wood = dekaround(2000/gvDiffLVL), Clay = dekaround(2000/gvDiffLVL), Stone = dekaround(2000/gvDiffLVL)}
	tribute.Callback = BridgeTributePayed
	AddTribute(tribute)
end
function BridgeTributePayed()
	Logic.CreateEntity(Entities.XD_NeutralBridge1, 34768.61, 60981.50, 0.00, 0)
	--
	Logic.SetTerrainNodeHeight(361, 596,  2420);
	Logic.SetTerrainNodeHeight(362, 596,  2516);
	Logic.SetTerrainNodeHeight(363, 596,  2582);
	Logic.SetTerrainNodeHeight(364, 596,  2624);
	Logic.SetTerrainNodeHeight(365, 596,  2650);
	Logic.SetTerrainNodeHeight(366, 596,  2669);
	Logic.SetTerrainNodeHeight(367, 596,  2685);
	Logic.SetTerrainNodeHeight(368, 596,  2701);
	Logic.SetTerrainNodeHeight(369, 596,  2710);
	Logic.SetTerrainNodeHeight(370, 596,  2714);
	Logic.SetTerrainNodeHeight(361, 597,  2385);
	Logic.SetTerrainNodeHeight(362, 597,  2471);
	Logic.SetTerrainNodeHeight(363, 597,  2537);
	Logic.SetTerrainNodeHeight(364, 597,  2579);
	Logic.SetTerrainNodeHeight(365, 597,  2613);
	Logic.SetTerrainNodeHeight(366, 597,  2641);
	Logic.SetTerrainNodeHeight(367, 597,  2665);
	Logic.SetTerrainNodeHeight(368, 597,  2685);
	Logic.SetTerrainNodeHeight(369, 597,  2700);
	Logic.SetTerrainNodeHeight(370, 597,  2710);
	Logic.SetTerrainNodeHeight(361, 598,  2358);
	Logic.SetTerrainNodeHeight(362, 598,  2432);
	Logic.SetTerrainNodeHeight(363, 598,  2496);
	Logic.SetTerrainNodeHeight(364, 598,  2542);
	Logic.SetTerrainNodeHeight(365, 598,  2582);
	Logic.SetTerrainNodeHeight(366, 598,  2616);
	Logic.SetTerrainNodeHeight(367, 598,  2647);
	Logic.SetTerrainNodeHeight(368, 598,  2676);
	Logic.SetTerrainNodeHeight(369, 598,  2692);
	Logic.SetTerrainNodeHeight(370, 598,  2707);
	Logic.SetTerrainNodeHeight(374, 598,  2712);
	Logic.SetTerrainNodeHeight(375, 598,  2712);
	Logic.SetTerrainNodeHeight(330, 599,  2747);
	Logic.SetTerrainNodeHeight(331, 599,  2718);
	Logic.SetTerrainNodeHeight(332, 599,  2677);
	Logic.SetTerrainNodeHeight(333, 599,  2618);
	Logic.SetTerrainNodeHeight(334, 599,  2547);
	Logic.SetTerrainNodeHeight(335, 599,  2473);
	Logic.SetTerrainNodeHeight(336, 599,  2381);
	Logic.SetTerrainNodeHeight(361, 599,  2337);
	Logic.SetTerrainNodeHeight(362, 599,  2404);
	Logic.SetTerrainNodeHeight(363, 599,  2462);
	Logic.SetTerrainNodeHeight(364, 599,  2512);
	Logic.SetTerrainNodeHeight(365, 599,  2556);
	Logic.SetTerrainNodeHeight(366, 599,  2596);
	Logic.SetTerrainNodeHeight(367, 599,  2632);
	Logic.SetTerrainNodeHeight(368, 599,  2663);
	Logic.SetTerrainNodeHeight(369, 599,  2685);
	Logic.SetTerrainNodeHeight(370, 599,  2702);
	Logic.SetTerrainNodeHeight(373, 599,  2712);
	Logic.SetTerrainNodeHeight(374, 599,  2712);
	Logic.SetTerrainNodeHeight(375, 599,  2712);
	Logic.SetTerrainNodeHeight(329, 600,  2747);
	Logic.SetTerrainNodeHeight(330, 600,  2747);
	Logic.SetTerrainNodeHeight(331, 600,  2734);
	Logic.SetTerrainNodeHeight(332, 600,  2686);
	Logic.SetTerrainNodeHeight(333, 600,  2617);
	Logic.SetTerrainNodeHeight(334, 600,  2519);
	Logic.SetTerrainNodeHeight(335, 600,  2426);
	Logic.SetTerrainNodeHeight(361, 600,  2323);
	Logic.SetTerrainNodeHeight(362, 600,  2382);
	Logic.SetTerrainNodeHeight(363, 600,  2437);
	Logic.SetTerrainNodeHeight(364, 600,  2488);
	Logic.SetTerrainNodeHeight(365, 600,  2534);
	Logic.SetTerrainNodeHeight(366, 600,  2579);
	Logic.SetTerrainNodeHeight(367, 600,  2622);
	Logic.SetTerrainNodeHeight(368, 600,  2657);
	Logic.SetTerrainNodeHeight(369, 600,  2683);
	Logic.SetTerrainNodeHeight(370, 600,  2698);
	Logic.SetTerrainNodeHeight(372, 600,  2712);
	Logic.SetTerrainNodeHeight(373, 600,  2712);
	Logic.SetTerrainNodeHeight(374, 600,  2712);
	Logic.SetTerrainNodeHeight(375, 600,  2712);
	Logic.SetTerrainNodeHeight(328, 601,  2747);
	Logic.SetTerrainNodeHeight(329, 601,  2747);
	Logic.SetTerrainNodeHeight(330, 601,  2747);
	Logic.SetTerrainNodeHeight(331, 601,  2735);
	Logic.SetTerrainNodeHeight(332, 601,  2678);
	Logic.SetTerrainNodeHeight(333, 601,  2603);
	Logic.SetTerrainNodeHeight(334, 601,  2506);
	Logic.SetTerrainNodeHeight(335, 601,  2402);
	Logic.SetTerrainNodeHeight(336, 601,  2314);
	Logic.SetTerrainNodeHeight(361, 601,  2314);
	Logic.SetTerrainNodeHeight(362, 601,  2365);
	Logic.SetTerrainNodeHeight(363, 601,  2416);
	Logic.SetTerrainNodeHeight(364, 601,  2471);
	Logic.SetTerrainNodeHeight(365, 601,  2526);
	Logic.SetTerrainNodeHeight(366, 601,  2578);
	Logic.SetTerrainNodeHeight(367, 601,  2624);
	Logic.SetTerrainNodeHeight(368, 601,  2658);
	Logic.SetTerrainNodeHeight(369, 601,  2689);
	Logic.SetTerrainNodeHeight(370, 601,  2707);
	Logic.SetTerrainNodeHeight(372, 601,  2712);
	Logic.SetTerrainNodeHeight(373, 601,  2712);
	Logic.SetTerrainNodeHeight(374, 601,  2712);
	Logic.SetTerrainNodeHeight(328, 602,  2747);
	Logic.SetTerrainNodeHeight(329, 602,  2747);
	Logic.SetTerrainNodeHeight(330, 602,  2747);
	Logic.SetTerrainNodeHeight(331, 602,  2735);
	Logic.SetTerrainNodeHeight(332, 602,  2682);
	Logic.SetTerrainNodeHeight(333, 602,  2606);
	Logic.SetTerrainNodeHeight(334, 602,  2501);
	Logic.SetTerrainNodeHeight(335, 602,  2389);
	Logic.SetTerrainNodeHeight(336, 602,  2299);
	Logic.SetTerrainNodeHeight(361, 602,  2310);
	Logic.SetTerrainNodeHeight(362, 602,  2363);
	Logic.SetTerrainNodeHeight(363, 602,  2415);
	Logic.SetTerrainNodeHeight(364, 602,  2484);
	Logic.SetTerrainNodeHeight(365, 602,  2545);
	Logic.SetTerrainNodeHeight(366, 602,  2605);
	Logic.SetTerrainNodeHeight(367, 602,  2666);
	Logic.SetTerrainNodeHeight(368, 602,  2690);
	Logic.SetTerrainNodeHeight(369, 602,  2700);
	Logic.SetTerrainNodeHeight(370, 602,  2712);
	Logic.SetTerrainNodeHeight(371, 602,  2712);
	Logic.SetTerrainNodeHeight(372, 602,  2712);
	Logic.SetTerrainNodeHeight(373, 602,  2712);
	Logic.SetTerrainNodeHeight(374, 602,  2712);
	Logic.SetTerrainNodeHeight(375, 602,  2712);
	Logic.SetTerrainNodeHeight(325, 603,  2642);
	Logic.SetTerrainNodeHeight(326, 603,  2640);
	Logic.SetTerrainNodeHeight(327, 603,  2714);
	Logic.SetTerrainNodeHeight(328, 603,  2735);
	Logic.SetTerrainNodeHeight(329, 603,  2741);
	Logic.SetTerrainNodeHeight(330, 603,  2745);
	Logic.SetTerrainNodeHeight(331, 603,  2735);
	Logic.SetTerrainNodeHeight(332, 603,  2694);
	Logic.SetTerrainNodeHeight(333, 603,  2618);
	Logic.SetTerrainNodeHeight(334, 603,  2503);
	Logic.SetTerrainNodeHeight(335, 603,  2380);
	Logic.SetTerrainNodeHeight(336, 603,  2286);
	Logic.SetTerrainNodeHeight(361, 603,  2327);
	Logic.SetTerrainNodeHeight(362, 603,  2389);
	Logic.SetTerrainNodeHeight(363, 603,  2459);
	Logic.SetTerrainNodeHeight(364, 603,  2527);
	Logic.SetTerrainNodeHeight(365, 603,  2594);
	Logic.SetTerrainNodeHeight(366, 603,  2654);
	Logic.SetTerrainNodeHeight(367, 603,  2712);
	Logic.SetTerrainNodeHeight(368, 603,  2712);
	Logic.SetTerrainNodeHeight(369, 603,  2712);
	Logic.SetTerrainNodeHeight(370, 603,  2712);
	Logic.SetTerrainNodeHeight(371, 603,  2712);
	Logic.SetTerrainNodeHeight(372, 603,  2712);
	Logic.SetTerrainNodeHeight(373, 603,  2712);
	Logic.SetTerrainNodeHeight(375, 603,  2712);
	Logic.SetTerrainNodeHeight(324, 604,  2651);
	Logic.SetTerrainNodeHeight(325, 604,  2661);
	Logic.SetTerrainNodeHeight(326, 604,  2677);
	Logic.SetTerrainNodeHeight(327, 604,  2701);
	Logic.SetTerrainNodeHeight(328, 604,  2722);
	Logic.SetTerrainNodeHeight(329, 604,  2734);
	Logic.SetTerrainNodeHeight(330, 604,  2742);
	Logic.SetTerrainNodeHeight(331, 604,  2746);
	Logic.SetTerrainNodeHeight(332, 604,  2713);
	Logic.SetTerrainNodeHeight(333, 604,  2649);
	Logic.SetTerrainNodeHeight(334, 604,  2512);
	Logic.SetTerrainNodeHeight(335, 604,  2370);
	Logic.SetTerrainNodeHeight(336, 604,  2267);
	Logic.SetTerrainNodeHeight(360, 604,  2280);
	Logic.SetTerrainNodeHeight(361, 604,  2364);
	Logic.SetTerrainNodeHeight(362, 604,  2461);
	Logic.SetTerrainNodeHeight(363, 604,  2553);
	Logic.SetTerrainNodeHeight(364, 604,  2612);
	Logic.SetTerrainNodeHeight(365, 604,  2655);
	Logic.SetTerrainNodeHeight(366, 604,  2687);
	Logic.SetTerrainNodeHeight(367, 604,  2712);
	Logic.SetTerrainNodeHeight(368, 604,  2712);
	Logic.SetTerrainNodeHeight(369, 604,  2712);
	Logic.SetTerrainNodeHeight(370, 604,  2712);
	Logic.SetTerrainNodeHeight(371, 604,  2712);
	Logic.SetTerrainNodeHeight(372, 604,  2712);
	Logic.SetTerrainNodeHeight(373, 604,  2712);
	Logic.SetTerrainNodeHeight(374, 604,  2712);
	Logic.SetTerrainNodeHeight(375, 604,  2712);
	Logic.SetTerrainNodeHeight(323, 605,  2655);
	Logic.SetTerrainNodeHeight(324, 605,  2664);
	Logic.SetTerrainNodeHeight(325, 605,  2675);
	Logic.SetTerrainNodeHeight(326, 605,  2689);
	Logic.SetTerrainNodeHeight(327, 605,  2704);
	Logic.SetTerrainNodeHeight(328, 605,  2718);
	Logic.SetTerrainNodeHeight(329, 605,  2730);
	Logic.SetTerrainNodeHeight(330, 605,  2738);
	Logic.SetTerrainNodeHeight(331, 605,  2743);
	Logic.SetTerrainNodeHeight(332, 605,  2728);
	Logic.SetTerrainNodeHeight(333, 605,  2691);
	Logic.SetTerrainNodeHeight(334, 605,  2576);
	Logic.SetTerrainNodeHeight(335, 605,  2362);
	Logic.SetTerrainNodeHeight(336, 605,  2252);
	Logic.SetTerrainNodeHeight(360, 605,  2308);
	Logic.SetTerrainNodeHeight(361, 605,  2408);
	Logic.SetTerrainNodeHeight(362, 605,  2612);
	Logic.SetTerrainNodeHeight(363, 605,  2676);
	Logic.SetTerrainNodeHeight(364, 605,  2698);
	Logic.SetTerrainNodeHeight(365, 605,  2704);
	Logic.SetTerrainNodeHeight(366, 605,  2712);
	Logic.SetTerrainNodeHeight(367, 605,  2712);
	Logic.SetTerrainNodeHeight(368, 605,  2712);
	Logic.SetTerrainNodeHeight(369, 605,  2712);
	Logic.SetTerrainNodeHeight(370, 605,  2712);
	Logic.SetTerrainNodeHeight(371, 605,  2712);
	Logic.SetTerrainNodeHeight(372, 605,  2712);
	Logic.SetTerrainNodeHeight(373, 605,  2712);
	Logic.SetTerrainNodeHeight(374, 605,  2712);
	Logic.SetTerrainNodeHeight(375, 605,  2712);
	Logic.SetTerrainNodeHeight(323, 606,  2665);
	Logic.SetTerrainNodeHeight(324, 606,  2677);
	Logic.SetTerrainNodeHeight(325, 606,  2688);
	Logic.SetTerrainNodeHeight(326, 606,  2698);
	Logic.SetTerrainNodeHeight(327, 606,  2710);
	Logic.SetTerrainNodeHeight(328, 606,  2719);
	Logic.SetTerrainNodeHeight(329, 606,  2729);
	Logic.SetTerrainNodeHeight(330, 606,  2736);
	Logic.SetTerrainNodeHeight(331, 606,  2736);
	Logic.SetTerrainNodeHeight(332, 606,  2736);
	Logic.SetTerrainNodeHeight(333, 606,  2736);
	Logic.SetTerrainNodeHeight(334, 606,  2697);
	Logic.SetTerrainNodeHeight(361, 606,  2712);
	Logic.SetTerrainNodeHeight(362, 606,  2712);
	Logic.SetTerrainNodeHeight(363, 606,  2712);
	Logic.SetTerrainNodeHeight(364, 606,  2712);
	Logic.SetTerrainNodeHeight(365, 606,  2712);
	Logic.SetTerrainNodeHeight(366, 606,  2712);
	Logic.SetTerrainNodeHeight(367, 606,  2712);
	Logic.SetTerrainNodeHeight(368, 606,  2712);
	Logic.SetTerrainNodeHeight(369, 606,  2712);
	Logic.SetTerrainNodeHeight(370, 606,  2712);
	Logic.SetTerrainNodeHeight(371, 606,  2712);
	Logic.SetTerrainNodeHeight(372, 606,  2712);
	Logic.SetTerrainNodeHeight(373, 606,  2712);
	Logic.SetTerrainNodeHeight(374, 606,  2712);
	Logic.SetTerrainNodeHeight(375, 606,  2712);
	Logic.SetTerrainNodeHeight(323, 607,  2672);
	Logic.SetTerrainNodeHeight(324, 607,  2686);
	Logic.SetTerrainNodeHeight(325, 607,  2696);
	Logic.SetTerrainNodeHeight(326, 607,  2705);
	Logic.SetTerrainNodeHeight(327, 607,  2714);
	Logic.SetTerrainNodeHeight(328, 607,  2722);
	Logic.SetTerrainNodeHeight(329, 607,  2736);
	Logic.SetTerrainNodeHeight(330, 607,  2736);
	Logic.SetTerrainNodeHeight(331, 607,  2736);
	Logic.SetTerrainNodeHeight(332, 607,  2736);
	Logic.SetTerrainNodeHeight(333, 607,  2736);
	Logic.SetTerrainNodeHeight(334, 607,  2736);
	Logic.SetTerrainNodeHeight(361, 607,  2712);
	Logic.SetTerrainNodeHeight(362, 607,  2712);
	Logic.SetTerrainNodeHeight(363, 607,  2712);
	Logic.SetTerrainNodeHeight(364, 607,  2712);
	Logic.SetTerrainNodeHeight(365, 607,  2712);
	Logic.SetTerrainNodeHeight(366, 607,  2712);
	Logic.SetTerrainNodeHeight(367, 607,  2712);
	Logic.SetTerrainNodeHeight(368, 607,  2712);
	Logic.SetTerrainNodeHeight(369, 607,  2712);
	Logic.SetTerrainNodeHeight(370, 607,  2712);
	Logic.SetTerrainNodeHeight(371, 607,  2712);
	Logic.SetTerrainNodeHeight(372, 607,  2712);
	Logic.SetTerrainNodeHeight(373, 607,  2712);
	Logic.SetTerrainNodeHeight(374, 607,  2712);
	Logic.SetTerrainNodeHeight(323, 608,  2673);
	Logic.SetTerrainNodeHeight(324, 608,  2692);
	Logic.SetTerrainNodeHeight(325, 608,  2701);
	Logic.SetTerrainNodeHeight(326, 608,  2709);
	Logic.SetTerrainNodeHeight(327, 608,  2718);
	Logic.SetTerrainNodeHeight(328, 608,  2724);
	Logic.SetTerrainNodeHeight(329, 608,  2736);
	Logic.SetTerrainNodeHeight(330, 608,  2736);
	Logic.SetTerrainNodeHeight(331, 608,  2736);
	Logic.SetTerrainNodeHeight(332, 608,  2736);
	Logic.SetTerrainNodeHeight(333, 608,  2736);
	Logic.SetTerrainNodeHeight(334, 608,  2736);
	Logic.SetTerrainNodeHeight(361, 608,  2712);
	Logic.SetTerrainNodeHeight(362, 608,  2712);
	Logic.SetTerrainNodeHeight(363, 608,  2712);
	Logic.SetTerrainNodeHeight(364, 608,  2712);
	Logic.SetTerrainNodeHeight(365, 608,  2712);
	Logic.SetTerrainNodeHeight(366, 608,  2712);
	Logic.SetTerrainNodeHeight(367, 608,  2712);
	Logic.SetTerrainNodeHeight(368, 608,  2712);
	Logic.SetTerrainNodeHeight(369, 608,  2712);
	Logic.SetTerrainNodeHeight(370, 608,  2712);
	Logic.SetTerrainNodeHeight(371, 608,  2712);
	Logic.SetTerrainNodeHeight(372, 608,  2712);
	Logic.SetTerrainNodeHeight(373, 608,  2712);
	Logic.SetTerrainNodeHeight(323, 609,  2675);
	Logic.SetTerrainNodeHeight(324, 609,  2696);
	Logic.SetTerrainNodeHeight(325, 609,  2705);
	Logic.SetTerrainNodeHeight(326, 609,  2713);
	Logic.SetTerrainNodeHeight(327, 609,  2721);
	Logic.SetTerrainNodeHeight(328, 609,  2736);
	Logic.SetTerrainNodeHeight(329, 609,  2736);
	Logic.SetTerrainNodeHeight(330, 609,  2736);
	Logic.SetTerrainNodeHeight(331, 609,  2736);
	Logic.SetTerrainNodeHeight(332, 609,  2736);
	Logic.SetTerrainNodeHeight(333, 609,  2736);
	Logic.SetTerrainNodeHeight(334, 609,  2736);
	Logic.SetTerrainNodeHeight(361, 609,  2712);
	Logic.SetTerrainNodeHeight(362, 609,  2712);
	Logic.SetTerrainNodeHeight(363, 609,  2712);
	Logic.SetTerrainNodeHeight(364, 609,  2712);
	Logic.SetTerrainNodeHeight(365, 609,  2712);
	Logic.SetTerrainNodeHeight(366, 609,  2712);
	Logic.SetTerrainNodeHeight(367, 609,  2712);
	Logic.SetTerrainNodeHeight(368, 609,  2712);
	Logic.SetTerrainNodeHeight(369, 609,  2712);
	Logic.SetTerrainNodeHeight(370, 609,  2712);
	Logic.SetTerrainNodeHeight(371, 609,  2712);
	Logic.SetTerrainNodeHeight(372, 609,  2712);
	Logic.SetTerrainNodeHeight(323, 610,  2676);
	Logic.SetTerrainNodeHeight(324, 610,  2695);
	Logic.SetTerrainNodeHeight(325, 610,  2706);
	Logic.SetTerrainNodeHeight(326, 610,  2715);
	Logic.SetTerrainNodeHeight(327, 610,  2722);
	Logic.SetTerrainNodeHeight(328, 610,  2736);
	Logic.SetTerrainNodeHeight(329, 610,  2736);
	Logic.SetTerrainNodeHeight(330, 610,  2736);
	Logic.SetTerrainNodeHeight(331, 610,  2736);
	Logic.SetTerrainNodeHeight(332, 610,  2736);
	Logic.SetTerrainNodeHeight(333, 610,  2736);
	Logic.SetTerrainNodeHeight(334, 610,  2736);
	Logic.SetTerrainNodeHeight(361, 610,  2712);
	Logic.SetTerrainNodeHeight(362, 610,  2712);
	Logic.SetTerrainNodeHeight(363, 610,  2712);
	Logic.SetTerrainNodeHeight(364, 610,  2712);
	Logic.SetTerrainNodeHeight(365, 610,  2712);
	Logic.SetTerrainNodeHeight(366, 610,  2712);
	Logic.SetTerrainNodeHeight(367, 610,  2712);
	Logic.SetTerrainNodeHeight(368, 610,  2712);
	Logic.SetTerrainNodeHeight(369, 610,  2712);
	Logic.SetTerrainNodeHeight(370, 610,  2712);
	Logic.SetTerrainNodeHeight(371, 610,  2712);
	Logic.SetTerrainNodeHeight(323, 611,  2680);
	Logic.SetTerrainNodeHeight(324, 611,  2696);
	Logic.SetTerrainNodeHeight(325, 611,  2706);
	Logic.SetTerrainNodeHeight(326, 611,  2715);
	Logic.SetTerrainNodeHeight(327, 611,  2722);
	Logic.SetTerrainNodeHeight(328, 611,  2736);
	Logic.SetTerrainNodeHeight(329, 611,  2736);
	Logic.SetTerrainNodeHeight(330, 611,  2736);
	Logic.SetTerrainNodeHeight(331, 611,  2736);
	Logic.SetTerrainNodeHeight(332, 611,  2736);
	Logic.SetTerrainNodeHeight(333, 611,  2736);
	Logic.SetTerrainNodeHeight(334, 611,  2736);
	Logic.SetTerrainNodeHeight(361, 611,  2712);
	Logic.SetTerrainNodeHeight(362, 611,  2712);
	Logic.SetTerrainNodeHeight(363, 611,  2712);
	Logic.SetTerrainNodeHeight(364, 611,  2712);
	Logic.SetTerrainNodeHeight(365, 611,  2712);
	Logic.SetTerrainNodeHeight(366, 611,  2712);
	Logic.SetTerrainNodeHeight(367, 611,  2712);
	Logic.SetTerrainNodeHeight(368, 611,  2712);
	Logic.SetTerrainNodeHeight(369, 611,  2712);
	Logic.SetTerrainNodeHeight(370, 611,  2712);
	Logic.SetTerrainNodeHeight(371, 611,  2712);
	Logic.SetTerrainNodeHeight(372, 611,  2712);
	Logic.SetTerrainNodeHeight(323, 612,  2680);
	Logic.SetTerrainNodeHeight(324, 612,  2691);
	Logic.SetTerrainNodeHeight(325, 612,  2701);
	Logic.SetTerrainNodeHeight(326, 612,  2711);
	Logic.SetTerrainNodeHeight(327, 612,  2719);
	Logic.SetTerrainNodeHeight(328, 612,  2725);
	Logic.SetTerrainNodeHeight(329, 612,  2736);
	Logic.SetTerrainNodeHeight(330, 612,  2736);
	Logic.SetTerrainNodeHeight(331, 612,  2736);
	Logic.SetTerrainNodeHeight(332, 612,  2736);
	Logic.SetTerrainNodeHeight(333, 612,  2736);
	Logic.SetTerrainNodeHeight(334, 612,  2736);
	Logic.SetTerrainNodeHeight(362, 612,  2712);
	Logic.SetTerrainNodeHeight(363, 612,  2712);
	Logic.SetTerrainNodeHeight(364, 612,  2712);
	Logic.SetTerrainNodeHeight(365, 612,  2712);
	Logic.SetTerrainNodeHeight(366, 612,  2712);
	Logic.SetTerrainNodeHeight(367, 612,  2712);
	Logic.SetTerrainNodeHeight(368, 612,  2712);
	Logic.SetTerrainNodeHeight(369, 612,  2712);
	Logic.SetTerrainNodeHeight(370, 612,  2712);
	Logic.SetTerrainNodeHeight(371, 612,  2712);
	Logic.SetTerrainNodeHeight(372, 612,  2712);
	Logic.SetTerrainNodeHeight(323, 613,  2676);
	Logic.SetTerrainNodeHeight(324, 613,  2688);
	Logic.SetTerrainNodeHeight(325, 613,  2699);
	Logic.SetTerrainNodeHeight(326, 613,  2709);
	Logic.SetTerrainNodeHeight(327, 613,  2717);
	Logic.SetTerrainNodeHeight(328, 613,  2732);
	Logic.SetTerrainNodeHeight(329, 613,  2732);
	Logic.SetTerrainNodeHeight(330, 613,  2732);
	Logic.SetTerrainNodeHeight(331, 613,  2732);
	Logic.SetTerrainNodeHeight(332, 613,  2736);
	Logic.SetTerrainNodeHeight(333, 613,  2736);
	Logic.SetTerrainNodeHeight(334, 613,  2684);
	Logic.SetTerrainNodeHeight(362, 613,  2712);
	Logic.SetTerrainNodeHeight(363, 613,  2712);
	Logic.SetTerrainNodeHeight(364, 613,  2712);
	Logic.SetTerrainNodeHeight(365, 613,  2712);
	Logic.SetTerrainNodeHeight(366, 613,  2712);
	Logic.SetTerrainNodeHeight(367, 613,  2712);
	Logic.SetTerrainNodeHeight(368, 613,  2712);
	Logic.SetTerrainNodeHeight(369, 613,  2712);
	Logic.SetTerrainNodeHeight(370, 613,  2712);
	Logic.SetTerrainNodeHeight(371, 613,  2712);
	Logic.SetTerrainNodeHeight(372, 613,  2712);
	Logic.SetTerrainNodeHeight(323, 614,  2672);
	Logic.SetTerrainNodeHeight(324, 614,  2684);
	Logic.SetTerrainNodeHeight(325, 614,  2699);
	Logic.SetTerrainNodeHeight(326, 614,  2708);
	Logic.SetTerrainNodeHeight(327, 614,  2732);
	Logic.SetTerrainNodeHeight(328, 614,  2732);
	Logic.SetTerrainNodeHeight(329, 614,  2732);
	Logic.SetTerrainNodeHeight(330, 614,  2732);
	Logic.SetTerrainNodeHeight(331, 614,  2732);
	Logic.SetTerrainNodeHeight(332, 614,  2730);
	Logic.SetTerrainNodeHeight(333, 614,  2711);
	Logic.SetTerrainNodeHeight(334, 614,  2410);
	Logic.SetTerrainNodeHeight(335, 614,  2355);
	Logic.SetTerrainNodeHeight(357, 614,  2183);
	Logic.SetTerrainNodeHeight(359, 614,  2335);
	Logic.SetTerrainNodeHeight(360, 614,  2383);
	Logic.SetTerrainNodeHeight(361, 614,  2432);
	Logic.SetTerrainNodeHeight(362, 614,  2682);
	Logic.SetTerrainNodeHeight(363, 614,  2712);
	Logic.SetTerrainNodeHeight(364, 614,  2712);
	Logic.SetTerrainNodeHeight(365, 614,  2712);
	Logic.SetTerrainNodeHeight(366, 614,  2712);
	Logic.SetTerrainNodeHeight(367, 614,  2712);
	Logic.SetTerrainNodeHeight(368, 614,  2712);
	Logic.SetTerrainNodeHeight(369, 614,  2712);
	Logic.SetTerrainNodeHeight(370, 614,  2712);
	Logic.SetTerrainNodeHeight(371, 614,  2712);
	Logic.SetTerrainNodeHeight(323, 615,  2665);
	Logic.SetTerrainNodeHeight(324, 615,  2680);
	Logic.SetTerrainNodeHeight(325, 615,  2698);
	Logic.SetTerrainNodeHeight(326, 615,  2708);
	Logic.SetTerrainNodeHeight(327, 615,  2732);
	Logic.SetTerrainNodeHeight(328, 615,  2732);
	Logic.SetTerrainNodeHeight(329, 615,  2732);
	Logic.SetTerrainNodeHeight(330, 615,  2732);
	Logic.SetTerrainNodeHeight(331, 615,  2732);
	Logic.SetTerrainNodeHeight(332, 615,  2705);
	Logic.SetTerrainNodeHeight(333, 615,  2643);
	Logic.SetTerrainNodeHeight(334, 615,  2531);
	Logic.SetTerrainNodeHeight(335, 615,  2432);
	Logic.SetTerrainNodeHeight(336, 615,  2368);
	Logic.SetTerrainNodeHeight(357, 615,  2172);
	Logic.SetTerrainNodeHeight(359, 615,  2378);
	Logic.SetTerrainNodeHeight(360, 615,  2436);
	Logic.SetTerrainNodeHeight(361, 615,  2481);
	Logic.SetTerrainNodeHeight(362, 615,  2686);
	Logic.SetTerrainNodeHeight(363, 615,  2712);
	Logic.SetTerrainNodeHeight(364, 615,  2712);
	Logic.SetTerrainNodeHeight(365, 615,  2712);
	Logic.SetTerrainNodeHeight(366, 615,  2712);
	Logic.SetTerrainNodeHeight(367, 615,  2712);
	Logic.SetTerrainNodeHeight(368, 615,  2712);
	Logic.SetTerrainNodeHeight(369, 615,  2712);
	Logic.SetTerrainNodeHeight(370, 615,  2712);
	Logic.SetTerrainNodeHeight(371, 615,  2712);
	Logic.SetTerrainNodeHeight(323, 616,  2662);
	Logic.SetTerrainNodeHeight(324, 616,  2672);
	Logic.SetTerrainNodeHeight(325, 616,  2687);
	Logic.SetTerrainNodeHeight(326, 616,  2707);
	Logic.SetTerrainNodeHeight(327, 616,  2732);
	Logic.SetTerrainNodeHeight(328, 616,  2732);
	Logic.SetTerrainNodeHeight(329, 616,  2732);
	Logic.SetTerrainNodeHeight(330, 616,  2732);
	Logic.SetTerrainNodeHeight(331, 616,  2732);
	Logic.SetTerrainNodeHeight(332, 616,  2704);
	Logic.SetTerrainNodeHeight(333, 616,  2656);
	Logic.SetTerrainNodeHeight(334, 616,  2579);
	Logic.SetTerrainNodeHeight(335, 616,  2491);
	Logic.SetTerrainNodeHeight(336, 616,  2413);
	Logic.SetTerrainNodeHeight(338, 616,  2326);
	Logic.SetTerrainNodeHeight(357, 616,  2184);
	Logic.SetTerrainNodeHeight(358, 616,  2327);
	Logic.SetTerrainNodeHeight(359, 616,  2442);
	Logic.SetTerrainNodeHeight(360, 616,  2498);
	Logic.SetTerrainNodeHeight(361, 616,  2535);
	Logic.SetTerrainNodeHeight(362, 616,  2688);
	Logic.SetTerrainNodeHeight(363, 616,  2712);
	Logic.SetTerrainNodeHeight(364, 616,  2712);
	Logic.SetTerrainNodeHeight(365, 616,  2712);
	Logic.SetTerrainNodeHeight(366, 616,  2712);
	Logic.SetTerrainNodeHeight(367, 616,  2712);
	Logic.SetTerrainNodeHeight(368, 616,  2712);
	Logic.SetTerrainNodeHeight(369, 616,  2712);
	Logic.SetTerrainNodeHeight(370, 616,  2712);
	Logic.SetTerrainNodeHeight(371, 616,  2712);
	Logic.SetTerrainNodeHeight(324, 617,  2666);
	Logic.SetTerrainNodeHeight(325, 617,  2675);
	Logic.SetTerrainNodeHeight(326, 617,  2692);
	Logic.SetTerrainNodeHeight(327, 617,  2732);
	Logic.SetTerrainNodeHeight(328, 617,  2732);
	Logic.SetTerrainNodeHeight(329, 617,  2732);
	Logic.SetTerrainNodeHeight(330, 617,  2732);
	Logic.SetTerrainNodeHeight(331, 617,  2732);
	Logic.SetTerrainNodeHeight(332, 617,  2707);
	Logic.SetTerrainNodeHeight(333, 617,  2675);
	Logic.SetTerrainNodeHeight(334, 617,  2617);
	Logic.SetTerrainNodeHeight(335, 617,  2539);
	Logic.SetTerrainNodeHeight(336, 617,  2461);
	Logic.SetTerrainNodeHeight(337, 617,  2399);
	Logic.SetTerrainNodeHeight(338, 617,  2354);
	Logic.SetTerrainNodeHeight(357, 617,  2204);
	Logic.SetTerrainNodeHeight(358, 617,  2379);
	Logic.SetTerrainNodeHeight(359, 617,  2508);
	Logic.SetTerrainNodeHeight(360, 617,  2563);
	Logic.SetTerrainNodeHeight(361, 617,  2592);
	Logic.SetTerrainNodeHeight(362, 617,  2622);
	Logic.SetTerrainNodeHeight(363, 617,  2712);
	Logic.SetTerrainNodeHeight(364, 617,  2712);
	Logic.SetTerrainNodeHeight(365, 617,  2712);
	Logic.SetTerrainNodeHeight(366, 617,  2712);
	Logic.SetTerrainNodeHeight(367, 617,  2712);
	Logic.SetTerrainNodeHeight(368, 617,  2712);
	Logic.SetTerrainNodeHeight(369, 617,  2712);
	Logic.SetTerrainNodeHeight(370, 617,  2712);
	Logic.SetTerrainNodeHeight(325, 618,  2673);
	Logic.SetTerrainNodeHeight(326, 618,  2678);
	Logic.SetTerrainNodeHeight(327, 618,  2693);
	Logic.SetTerrainNodeHeight(328, 618,  2732);
	Logic.SetTerrainNodeHeight(329, 618,  2732);
	Logic.SetTerrainNodeHeight(330, 618,  2732);
	Logic.SetTerrainNodeHeight(331, 618,  2732);
	Logic.SetTerrainNodeHeight(332, 618,  2714);
	Logic.SetTerrainNodeHeight(333, 618,  2694);
	Logic.SetTerrainNodeHeight(334, 618,  2652);
	Logic.SetTerrainNodeHeight(335, 618,  2588);
	Logic.SetTerrainNodeHeight(336, 618,  2515);
	Logic.SetTerrainNodeHeight(337, 618,  2447);
	Logic.SetTerrainNodeHeight(338, 618,  2392);
	Logic.SetTerrainNodeHeight(357, 618,  2232);
	Logic.SetTerrainNodeHeight(358, 618,  2428);
	Logic.SetTerrainNodeHeight(359, 618,  2571);
	Logic.SetTerrainNodeHeight(360, 618,  2629);
	Logic.SetTerrainNodeHeight(361, 618,  2652);
	Logic.SetTerrainNodeHeight(365, 618,  2712);
	Logic.SetTerrainNodeHeight(366, 618,  2712);
	Logic.SetTerrainNodeHeight(328, 619,  2747);
	Logic.SetTerrainNodeHeight(329, 619,  2732);
	Logic.SetTerrainNodeHeight(330, 619,  2732);
	Logic.SetTerrainNodeHeight(331, 619,  2732);
	Logic.SetTerrainNodeHeight(332, 619,  2722);
	Logic.SetTerrainNodeHeight(333, 619,  2709);
	Logic.SetTerrainNodeHeight(334, 619,  2687);
	Logic.SetTerrainNodeHeight(335, 619,  2639);
	Logic.SetTerrainNodeHeight(336, 619,  2572);
	Logic.SetTerrainNodeHeight(337, 619,  2507);
	Logic.SetTerrainNodeHeight(338, 619,  2441);
	Logic.SetTerrainNodeHeight(357, 619,  2277);
	Logic.SetTerrainNodeHeight(358, 619,  2482);
	Logic.SetTerrainNodeHeight(359, 619,  2652);
	Logic.SetTerrainNodeHeight(360, 619,  2708);
	Logic.SetTerrainNodeHeight(361, 619,  2708);
	Logic.SetTerrainNodeHeight(362, 619,  2706);
	Logic.SetTerrainNodeHeight(316, 620,  2642);
	Logic.SetTerrainNodeHeight(317, 620,  2623);
	Logic.SetTerrainNodeHeight(318, 620,  2630);
	Logic.SetTerrainNodeHeight(319, 620,  2657);
	Logic.SetTerrainNodeHeight(320, 620,  2673);
	Logic.SetTerrainNodeHeight(321, 620,  2693);
	Logic.SetTerrainNodeHeight(322, 620,  2707);
	Logic.SetTerrainNodeHeight(323, 620,  2712);
	Logic.SetTerrainNodeHeight(324, 620,  2717);
	Logic.SetTerrainNodeHeight(325, 620,  2721);
	Logic.SetTerrainNodeHeight(326, 620,  2720);
	Logic.SetTerrainNodeHeight(327, 620,  2714);
	Logic.SetTerrainNodeHeight(328, 620,  2747);
	Logic.SetTerrainNodeHeight(329, 620,  2732);
	Logic.SetTerrainNodeHeight(330, 620,  2732);
	Logic.SetTerrainNodeHeight(331, 620,  2732);
	Logic.SetTerrainNodeHeight(332, 620,  2732);
	Logic.SetTerrainNodeHeight(333, 620,  2732);
	Logic.SetTerrainNodeHeight(334, 620,  2732);
	Logic.SetTerrainNodeHeight(335, 620,  2732);
	Logic.SetTerrainNodeHeight(336, 620,  2607);
	Logic.SetTerrainNodeHeight(337, 620,  2577);
	Logic.SetTerrainNodeHeight(338, 620,  2502);
	Logic.SetTerrainNodeHeight(339, 620,  2377);
	Logic.SetTerrainNodeHeight(340, 620,  2222);
	Logic.SetTerrainNodeHeight(341, 620,  2091);
	Logic.SetTerrainNodeHeight(342, 620,  2029);
	Logic.SetTerrainNodeHeight(343, 620,  2015);
	Logic.SetTerrainNodeHeight(344, 620,  2015);
	Logic.SetTerrainNodeHeight(345, 620,  2015);
	Logic.SetTerrainNodeHeight(346, 620,  2015);
	Logic.SetTerrainNodeHeight(347, 620,  2015);
	Logic.SetTerrainNodeHeight(348, 620,  2015);
	Logic.SetTerrainNodeHeight(349, 620,  2015);
	Logic.SetTerrainNodeHeight(350, 620,  2015);
	Logic.SetTerrainNodeHeight(351, 620,  2015);
	Logic.SetTerrainNodeHeight(352, 620,  2015);
	Logic.SetTerrainNodeHeight(353, 620,  2015);
	Logic.SetTerrainNodeHeight(354, 620,  2015);
	Logic.SetTerrainNodeHeight(355, 620,  2054);
	Logic.SetTerrainNodeHeight(356, 620,  2170);
	Logic.SetTerrainNodeHeight(357, 620,  2325);
	Logic.SetTerrainNodeHeight(358, 620,  2560);
	Logic.SetTerrainNodeHeight(359, 620,  2802);
	Logic.SetTerrainNodeHeight(360, 620,  2800);
	Logic.SetTerrainNodeHeight(361, 620,  2727);
	Logic.SetTerrainNodeHeight(362, 620,  2720);
	Logic.SetTerrainNodeHeight(363, 620,  2727);
	Logic.SetTerrainNodeHeight(364, 620,  2724);
	Logic.SetTerrainNodeHeight(365, 620,  2715);
	Logic.SetTerrainNodeHeight(366, 620,  2696);
	Logic.SetTerrainNodeHeight(367, 620,  2715);
	Logic.SetTerrainNodeHeight(368, 620,  2689);
	Logic.SetTerrainNodeHeight(369, 620,  2706);
	Logic.SetTerrainNodeHeight(370, 620,  2718);
	Logic.SetTerrainNodeHeight(371, 620,  2699);
	Logic.SetTerrainNodeHeight(372, 620,  2706);
	Logic.SetTerrainNodeHeight(373, 620,  2691);
	Logic.SetTerrainNodeHeight(374, 620,  2727);
	Logic.SetTerrainNodeHeight(375, 620,  2724);
	Logic.SetTerrainNodeHeight(316, 621,  2678);
	Logic.SetTerrainNodeHeight(317, 621,  2647);
	Logic.SetTerrainNodeHeight(318, 621,  2654);
	Logic.SetTerrainNodeHeight(319, 621,  2669);
	Logic.SetTerrainNodeHeight(320, 621,  2678);
	Logic.SetTerrainNodeHeight(321, 621,  2699);
	Logic.SetTerrainNodeHeight(322, 621,  2714);
	Logic.SetTerrainNodeHeight(323, 621,  2726);
	Logic.SetTerrainNodeHeight(324, 621,  2739);
	Logic.SetTerrainNodeHeight(325, 621,  2749);
	Logic.SetTerrainNodeHeight(326, 621,  2757);
	Logic.SetTerrainNodeHeight(327, 621,  2754);
	Logic.SetTerrainNodeHeight(328, 621,  2747);
	Logic.SetTerrainNodeHeight(329, 621,  2747);
	Logic.SetTerrainNodeHeight(330, 621,  2732);
	Logic.SetTerrainNodeHeight(331, 621,  2732);
	Logic.SetTerrainNodeHeight(332, 621,  2732);
	Logic.SetTerrainNodeHeight(333, 621,  2732);
	Logic.SetTerrainNodeHeight(334, 621,  2732);
	Logic.SetTerrainNodeHeight(335, 621,  2732);
	Logic.SetTerrainNodeHeight(336, 621,  2662);
	Logic.SetTerrainNodeHeight(337, 621,  2639);
	Logic.SetTerrainNodeHeight(338, 621,  2554);
	Logic.SetTerrainNodeHeight(339, 621,  2394);
	Logic.SetTerrainNodeHeight(340, 621,  2213);
	Logic.SetTerrainNodeHeight(341, 621,  2060);
	Logic.SetTerrainNodeHeight(342, 621,  2016);
	Logic.SetTerrainNodeHeight(343, 621,  2015);
	Logic.SetTerrainNodeHeight(344, 621,  2015);
	Logic.SetTerrainNodeHeight(345, 621,  2015);
	Logic.SetTerrainNodeHeight(346, 621,  2015);
	Logic.SetTerrainNodeHeight(347, 621,  2015);
	Logic.SetTerrainNodeHeight(348, 621,  2015);
	Logic.SetTerrainNodeHeight(349, 621,  2015);
	Logic.SetTerrainNodeHeight(350, 621,  2015);
	Logic.SetTerrainNodeHeight(351, 621,  2015);
	Logic.SetTerrainNodeHeight(352, 621,  2015);
	Logic.SetTerrainNodeHeight(353, 621,  2015);
	Logic.SetTerrainNodeHeight(354, 621,  2015);
	Logic.SetTerrainNodeHeight(355, 621,  2060);
	Logic.SetTerrainNodeHeight(356, 621,  2201);
	Logic.SetTerrainNodeHeight(357, 621,  2392);
	Logic.SetTerrainNodeHeight(358, 621,  2653);
	Logic.SetTerrainNodeHeight(359, 621,  2853);
	Logic.SetTerrainNodeHeight(360, 621,  2819);
	Logic.SetTerrainNodeHeight(361, 621,  2723);
	Logic.SetTerrainNodeHeight(362, 621,  2724);
	Logic.SetTerrainNodeHeight(363, 621,  2726);
	Logic.SetTerrainNodeHeight(364, 621,  2714);
	Logic.SetTerrainNodeHeight(365, 621,  2708);
	Logic.SetTerrainNodeHeight(366, 621,  2716);
	Logic.SetTerrainNodeHeight(367, 621,  2698);
	Logic.SetTerrainNodeHeight(368, 621,  2690);
	Logic.SetTerrainNodeHeight(369, 621,  2719);
	Logic.SetTerrainNodeHeight(370, 621,  2698);
	Logic.SetTerrainNodeHeight(371, 621,  2717);
	Logic.SetTerrainNodeHeight(372, 621,  2708);
	Logic.SetTerrainNodeHeight(373, 621,  2683);
	Logic.SetTerrainNodeHeight(374, 621,  2717);
	Logic.SetTerrainNodeHeight(375, 621,  2729);
	Logic.SetTerrainNodeHeight(316, 622,  2684);
	Logic.SetTerrainNodeHeight(317, 622,  2689);
	Logic.SetTerrainNodeHeight(318, 622,  2683);
	Logic.SetTerrainNodeHeight(319, 622,  2684);
	Logic.SetTerrainNodeHeight(320, 622,  2692);
	Logic.SetTerrainNodeHeight(321, 622,  2703);
	Logic.SetTerrainNodeHeight(322, 622,  2715);
	Logic.SetTerrainNodeHeight(323, 622,  2737);
	Logic.SetTerrainNodeHeight(324, 622,  2758);
	Logic.SetTerrainNodeHeight(325, 622,  2777);
	Logic.SetTerrainNodeHeight(326, 622,  2784);
	Logic.SetTerrainNodeHeight(327, 622,  2782);
	Logic.SetTerrainNodeHeight(328, 622,  2747);
	Logic.SetTerrainNodeHeight(329, 622,  2747);
	Logic.SetTerrainNodeHeight(330, 622,  2732);
	Logic.SetTerrainNodeHeight(331, 622,  2732);
	Logic.SetTerrainNodeHeight(332, 622,  2732);
	Logic.SetTerrainNodeHeight(333, 622,  2732);
	Logic.SetTerrainNodeHeight(334, 622,  2732);
	Logic.SetTerrainNodeHeight(335, 622,  2732);
	Logic.SetTerrainNodeHeight(336, 622,  2697);
	Logic.SetTerrainNodeHeight(337, 622,  2677);
	Logic.SetTerrainNodeHeight(338, 622,  2593);
	Logic.SetTerrainNodeHeight(339, 622,  2393);
	Logic.SetTerrainNodeHeight(340, 622,  2208);
	Logic.SetTerrainNodeHeight(341, 622,  2015);
	Logic.SetTerrainNodeHeight(342, 622,  2015);
	Logic.SetTerrainNodeHeight(343, 622,  2015);
	Logic.SetTerrainNodeHeight(344, 622,  2015);
	Logic.SetTerrainNodeHeight(345, 622,  2015);
	Logic.SetTerrainNodeHeight(346, 622,  2015);
	Logic.SetTerrainNodeHeight(347, 622,  2015);
	Logic.SetTerrainNodeHeight(348, 622,  2015);
	Logic.SetTerrainNodeHeight(349, 622,  2015);
	Logic.SetTerrainNodeHeight(350, 622,  2015);
	Logic.SetTerrainNodeHeight(351, 622,  2015);
	Logic.SetTerrainNodeHeight(352, 622,  2015);
	Logic.SetTerrainNodeHeight(353, 622,  2015);
	Logic.SetTerrainNodeHeight(354, 622,  2015);
	Logic.SetTerrainNodeHeight(355, 622,  2066);
	Logic.SetTerrainNodeHeight(356, 622,  2214);
	Logic.SetTerrainNodeHeight(357, 622,  2414);
	Logic.SetTerrainNodeHeight(358, 622,  2648);
	Logic.SetTerrainNodeHeight(359, 622,  2785);
	Logic.SetTerrainNodeHeight(360, 622,  2744);
	Logic.SetTerrainNodeHeight(361, 622,  2723);
	Logic.SetTerrainNodeHeight(362, 622,  2724);
	Logic.SetTerrainNodeHeight(363, 622,  2713);
	Logic.SetTerrainNodeHeight(364, 622,  2721);
	Logic.SetTerrainNodeHeight(365, 622,  2705);
	Logic.SetTerrainNodeHeight(366, 622,  2692);
	Logic.SetTerrainNodeHeight(367, 622,  2697);
	Logic.SetTerrainNodeHeight(368, 622,  2718);
	Logic.SetTerrainNodeHeight(369, 622,  2711);
	Logic.SetTerrainNodeHeight(370, 622,  2707);
	Logic.SetTerrainNodeHeight(371, 622,  2718);
	Logic.SetTerrainNodeHeight(372, 622,  2684);
	Logic.SetTerrainNodeHeight(373, 622,  2716);
	Logic.SetTerrainNodeHeight(374, 622,  2732);
	Logic.SetTerrainNodeHeight(375, 622,  2724);
	Logic.SetTerrainNodeHeight(316, 623,  2692);
	Logic.SetTerrainNodeHeight(317, 623,  2706);
	Logic.SetTerrainNodeHeight(318, 623,  2699);
	Logic.SetTerrainNodeHeight(319, 623,  2708);
	Logic.SetTerrainNodeHeight(320, 623,  2710);
	Logic.SetTerrainNodeHeight(321, 623,  2704);
	Logic.SetTerrainNodeHeight(322, 623,  2728);
	Logic.SetTerrainNodeHeight(323, 623,  2746);
	Logic.SetTerrainNodeHeight(324, 623,  2778);
	Logic.SetTerrainNodeHeight(325, 623,  2787);
	Logic.SetTerrainNodeHeight(326, 623,  2796);
	Logic.SetTerrainNodeHeight(327, 623,  2789);
	Logic.SetTerrainNodeHeight(328, 623,  2747);
	Logic.SetTerrainNodeHeight(329, 623,  2747);
	Logic.SetTerrainNodeHeight(330, 623,  2732);
	Logic.SetTerrainNodeHeight(331, 623,  2732);
	Logic.SetTerrainNodeHeight(332, 623,  2732);
	Logic.SetTerrainNodeHeight(333, 623,  2732);
	Logic.SetTerrainNodeHeight(334, 623,  2732);
	Logic.SetTerrainNodeHeight(335, 623,  2713);
	Logic.SetTerrainNodeHeight(336, 623,  2712);
	Logic.SetTerrainNodeHeight(337, 623,  2698);
	Logic.SetTerrainNodeHeight(338, 623,  2613);
	Logic.SetTerrainNodeHeight(339, 623,  2381);
	Logic.SetTerrainNodeHeight(340, 623,  2208);
	Logic.SetTerrainNodeHeight(341, 623,  2015);
	Logic.SetTerrainNodeHeight(342, 623,  2015);
	Logic.SetTerrainNodeHeight(343, 623,  2015);
	Logic.SetTerrainNodeHeight(344, 623,  2015);
	Logic.SetTerrainNodeHeight(345, 623,  2015);
	Logic.SetTerrainNodeHeight(346, 623,  2015);
	Logic.SetTerrainNodeHeight(347, 623,  2015);
	Logic.SetTerrainNodeHeight(348, 623,  2015);
	Logic.SetTerrainNodeHeight(349, 623,  2015);
	Logic.SetTerrainNodeHeight(350, 623,  2015);
	Logic.SetTerrainNodeHeight(351, 623,  2015);
	Logic.SetTerrainNodeHeight(352, 623,  2015);
	Logic.SetTerrainNodeHeight(353, 623,  2015);
	Logic.SetTerrainNodeHeight(354, 623,  2015);
	Logic.SetTerrainNodeHeight(355, 623,  2055);
	Logic.SetTerrainNodeHeight(356, 623,  2212);
	Logic.SetTerrainNodeHeight(357, 623,  2412);
	Logic.SetTerrainNodeHeight(358, 623,  2652);
	Logic.SetTerrainNodeHeight(359, 623,  2735);
	Logic.SetTerrainNodeHeight(360, 623,  2722);
	Logic.SetTerrainNodeHeight(361, 623,  2723);
	Logic.SetTerrainNodeHeight(362, 623,  2724);
	Logic.SetTerrainNodeHeight(363, 623,  2727);
	Logic.SetTerrainNodeHeight(364, 623,  2722);
	Logic.SetTerrainNodeHeight(365, 623,  2729);
	Logic.SetTerrainNodeHeight(366, 623,  2719);
	Logic.SetTerrainNodeHeight(367, 623,  2729);
	Logic.SetTerrainNodeHeight(368, 623,  2713);
	Logic.SetTerrainNodeHeight(369, 623,  2689);
	Logic.SetTerrainNodeHeight(370, 623,  2734);
	Logic.SetTerrainNodeHeight(371, 623,  2702);
	Logic.SetTerrainNodeHeight(372, 623,  2725);
	Logic.SetTerrainNodeHeight(373, 623,  2712);
	Logic.SetTerrainNodeHeight(374, 623,  2723);
	Logic.SetTerrainNodeHeight(375, 623,  2725);

end
function afraid_alchemist()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cave",af_alch,"@color:20,255,50 Diese Höhle ist mir nicht ganz geheuer.", false)
	ASP("afraid_alchemist",af_alch,"@color:20,255,50 Es wäre wohl besser, sie zuschütten zu lassen...", false)
	ASP("afraid_alchemist",af_alch,"@color:20,255,50 Wenn ich nur meinen Zundmechanismus hätte... @cr @cr Den haben mir diese Räuber gestohlen, weil sie ihn für wertvoll hielten...", false)

    briefing.finished = function()
		StartSimpleJob("CheckForRobbersTowerDown")
  	end
	StartBriefing(briefing)
end
function CheckForRobbersTowerDown()
	if IsDestroyed("P5_Tower3") then
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold, 46900, 7200, 0, 0), "ChestIgnition")
		StartSimpleJob("IgnitionChestControl")
		return true
	end
end
function IgnitionChestControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities
		local pos = GetPosition("ChestIgnition")
		for j = 1, 2 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					Sound.PlayGUISound(Sounds.Misc_Chat2,100)
					ReplacingEntity("ChestIgnition", Entities.XD_ChestOpen)
					local briefing = {}
					local AP, ASP = AddPages(briefing)
					ASP("afraid_alchemist",af_alch,"@color:20,255,50 Oh, der Zündmechanismus. Ihr habt ihn gefunden. @cr Bringt ihn bitte zu mir.", false)

					briefing.finished = function()
						Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "CheckForIgnitionDelivered",1,{},{entities[2]})
					end
					StartBriefing(briefing)
					return true
				end
			end
		end
	end
end
function CheckForIgnitionDelivered(_id)
	if IsNear(_id, "afraid_alchemist", 500) then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("afraid_alchemist",af_alch,"@color:20,255,50 Ah, da seid ihr ja. @cr Damit werde ich die Höhle zuschütten können.", false)
		briefing.finished = function()
			CaveBlocked = true
			do
				local id, tbi, e = nil, table.insert, {};
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium7, 26245.12, 57651.42, 0.00, 0);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium7, 26179.29, 57235.42, 302.70, 0);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium7, 26557.49, 57543.66, 231.08, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1069128086) --[[ Scale: 1.45 ]]
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium6, 25822.09, 57710.55, 288.38, 0);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium6, 25842.26, 57415.71, 245.41, 0);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_RockKhakiMedium7, 25801.05, 57021.19, 231.08, 0);tbi(e,id)
			end
		end
		StartBriefing(briefing)
		return true
	end
end
--
function UpgradeAI3()
	MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength + round(3/gvDiffLVL)
	StartCountdown(6*60*gvDiffLVL, UpgradeAI3, false)
end
function UpgradeAI4()
	MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(5/gvDiffLVL)
	StartCountdown(10*60*gvDiffLVL, UpgradeAI4, false)
end
function KillScoreBonus1()
	if Score.GetPlayerScore(2, "battle") >= 1000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 2 verfügbar!")
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSword1,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear1,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeBow1,3)
		Logic.SetTechnologyState(2,Technologies.B_Tower,3)
		Logic.SetTechnologyState(2,Technologies.B_Barracks,3)
		Logic.SetTechnologyState(2,Technologies.B_Archery,3)
		StartSimpleJob("KillScoreBonus2")
		table.remove(MapEditor_Armies[4].ForbiddenTypes, 1)
		return true
	end
end
function KillScoreBonus2()
	if Score.GetPlayerScore(2, "battle") >= 2000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 2 verfügbar!")
		Logic.SetTechnologyState(2,Technologies.B_Lighthouse,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Lighthouse,3)
		Logic.SetTechnologyState(2,Technologies.B_Mercenary,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Barracks,3)
		Logic.SetTechnologyState(2,Technologies.B_Stables,3)
		Logic.SetTechnologyState(2,Technologies.MU_LeaderRifle,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Archery,3)
		-- needed for formations
		Logic.SetTechnologyState(2,Technologies.GT_Tactics,3)
		-- no free statue though
		Logic.SetTechnologyState(2,Technologies.B_VictoryStatue1, 0)
		Logic.SetTechnologyState(2,Technologies.B_VictoryStatue8, 0)
		Logic.SetTechnologyState(2,Technologies.B_Beautification05, 0)
		StartSimpleJob("KillScoreBonus3")
		return true
	end
end
function KillScoreBonus3()
	if Score.GetPlayerScore(2, "battle") >= 3000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 2 verfügbar!")
		Logic.SetTechnologyState(2,Technologies.B_Foundry,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Tower,3)
		Logic.SetTechnologyState(2,Technologies.B_Grange,3)
		--
		Logic.SetTechnologyState(2,Technologies.T_LeatherMailArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_SoftArcherArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_MasterOfSmithery,3)
		Logic.SetTechnologyState(2,Technologies.T_Fletching,3)
		Logic.SetTechnologyState(2,Technologies.T_WoodAging,3)
		Logic.SetTechnologyState(2,Technologies.T_Masonry,3)
		Logic.SetTechnologyState(2,Technologies.T_FleeceArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_LeadShot,3)
		--
		CLogic.SetAttractionLimitOffset(2, 10 * gvDiffLVL)
		--
		StartSimpleJob("KillScoreBonus4")
		return true
	end
end
function KillScoreBonus4()
	if Score.GetPlayerScore(2, "battle") >= 4000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 2 verfügbar!")
		Logic.SetTechnologyState(2,Technologies.B_Castle,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Stables,3)
		Logic.SetTechnologyState(2,Technologies.UP1_Foundry,3)
		Logic.SetTechnologyState(2,Technologies.UP2_Tower,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSword2,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear2,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeBow2,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeLightCavalry1,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeRifle1,3)
		--
		Logic.SetTechnologyState(2,Technologies.T_ChainMailArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_PlateMailArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_PaddedArcherArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_LeatherArcherArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_IronCasting,3)
		Logic.SetTechnologyState(2,Technologies.T_BodkinArrow,3)
		Logic.SetTechnologyState(2,Technologies.T_Turnery,3)
		Logic.SetTechnologyState(2,Technologies.T_EnhancedGunPowder,3)
		Logic.SetTechnologyState(2,Technologies.T_BlisteringCannonballs,3)
		Logic.SetTechnologyState(2,Technologies.T_FleeceLinedLeatherArmor,3)
		Logic.SetTechnologyState(2,Technologies.T_Sights,3)
		--
		CLogic.SetAttractionLimitOffset(2, 20 * gvDiffLVL)
		--
		StartSimpleJob("KillScoreBonus5")
		return true
	end
end
function KillScoreBonus5()
	if Score.GetPlayerScore(2, "battle") >= 7000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 2 verfügbar!")
		Logic.SetTechnologyState(2,Technologies.T_UpgradeHeavyCavalry1,3)
		Logic.SetTechnologyState(2,Technologies.T_Joust,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSword3,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeSpear3,3)
		Logic.SetTechnologyState(2,Technologies.T_UpgradeBow3,3)

		Logic.SetTechnologyState(2,Technologies.UP1_Castle,3)
		--
		CLogic.SetAttractionLimitOffset(2, 30 * gvDiffLVL)
		--
		StartSimpleJob("KillScoreBonus6")
		return true
	end
end
function KillScoreBonus6()
	if Score.GetPlayerScore(2, "battle") >= 14000/gvDiffLVL then
		Message("Die besten Technologien sind nun für Spieler 2 verfügbar!")
		ResearchTechnology(Technologies.T_SilverSwords,2)
		ResearchTechnology(Technologies.T_SilverBullets,2)
		ResearchTechnology(Technologies.T_SilverMissiles,2)
		ResearchTechnology(Technologies.T_SilverPlateArmor,2)
		ResearchTechnology(Technologies.T_SilverArcherArmor,2)
		ResearchTechnology(Technologies.T_SilverArrows,2)
		ResearchTechnology(Technologies.T_SilverLance,2)
		ResearchTechnology(Technologies.T_BloodRush,2)
		--
		Logic.SetTechnologyState(2,Technologies.UP2_Castle,3)
		Logic.SetTechnologyState(2,Technologies.UP3_Castle,3)
		Logic.SetTechnologyState(2,Technologies.UP4_Castle,3)
		--
		CLogic.SetAttractionLimitOffset(2, 50 * gvDiffLVL)
		--
		return true
	end
end
---------------------------------------------------------------------------------------------
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