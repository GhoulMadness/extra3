--------------------------------------------------------------------------------
-- MapName: (2) Fünfte Prüfung - Die dunkle Bedrohung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 .......... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Fünfte Prüfung - Die dunkle Bedrohung "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(32,0,1,-1,1)

	main_armies_aggressive = 0

	-- Init  global MP stuff
	if CNetwork then
		if GUI.GetPlayerID() ~= 17 then
			SetUpGameLogicOnMPGameConfigLight()
		end
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	TributeP1_Challenge()

	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		Logic.SetPlayerPaysLeaderFlag(i, 0)
	end
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	--
	InitPlayerColorMapping()
	--
	LocalMusic.UseSet = DARKMOORMUSIC
	ActivateBriefingsExpansion()

	-- nix für Drückeberger : )
	DZTrade_PunishmentJob = function() return true end
	GUIAction_ExpelSettler = function() end
	GUI.SellBuilding = function() end
	GUIAction_ExpelAll = function() end

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
	gvDiffLVL = 2.4
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,2 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
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
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
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
	gvDiffLVL = 1.8
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,2 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
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
	gvDiffLVL = 1.3
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,2 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
	end
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
	gvDiffLVL = 1.0
	gvChallengeFlag = 1
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 HERAUSFORDERUNG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	for i = 1,2 do
		ResearchTechnology(Technologies.T_ThiefSabotage,i)
		ResearchTechnology(Technologies.GT_StandingArmy,i)
		ResearchTechnology(Technologies.GT_Tactics,i)
		--
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
	end

	StartInitialize()
end
NPCs = {["Major"] = {true, "Major"},
		["serf"] = {true, "Serf"},
		["hermit"] = {true, "Hermit"},
		["scout"] = {true, "Scout"},
		["miner"] = {true, "Miner"},
		["miner2"] = {true, "Miner2"},
		["wanderer"] = {true, "Wanderer"}
		}

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
							LookAt(entities[2], name)
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
function StartInitialize()

	Mission_InitLocalResources()

	Script.Load("maps\\user\\Balancing_Stuff_in_Dev\\ArmyCreator.lua")
	ArmyCreator.BasePoints = 150
	ArmyCreator.PlayerPoints = 150 * gvDiffLVL
	if not CNetwork then
		ArmyCreator.PlayerPoints = ArmyCreator.PlayerPoints * 2
		ArmyCreator.BasePoints = ArmyCreator.BasePoints * 2
	end

	TimeLimit = round(60*60/gvDiffLVL)
	StartSimpleHiResJob("AnfangsBriefingInitialize")

	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	function ArmyCreator.OnSetupFinished()

		XGUIEng.ShowWidget("ChangeIntoSerf",0)

		StartSimpleJob("DefeatJob")
		StartSimpleJob("VictoryJob")

		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "CatapultRangeExploitNoDamage", 1)

		StartCountdown(10*60*gvDiffLVL,UpgradeKIa,false)
		StartCountdown(15*60*gvDiffLVL,ThiefAttack,false)
		StartCountdown(TimeLimit,Timer,true)

		CreateArmyP4_1()
		CreateArmyP4_2()
		CreateArmyP4_3()
		CreateArmyP4_4()
		CreateArmyP4_5()
		CreateArmyP4_6()
		CreateArmyP4_7()
		CreateArmyP4_8()
		CreateArmyP4_9()
		CreateArmyP4_10()
		CreateArmyP4_11()
		CreateArmyP4_12()
		CreateArmyP4_13()
		CreateArmyP4_14()
		CreateArmyNV_1()
		CreateArmyNV_2()
		--
		MapEditor_SetupAI(3,round(gvDiffLVL),8500,round(gvDiffLVL),"p3",round(gvDiffLVL),0)
		MapEditor_SetupAI(4,3-round(gvDiffLVL),7000,4-round(gvDiffLVL),"p4",3-round(gvDiffLVL),0)
		MapEditor_SetupAI(6,3-round(gvDiffLVL),7000,4-round(gvDiffLVL),"MountainFortress",3-round(gvDiffLVL),0)
		--
		MapEditor_Armies[3].offensiveArmies.strength	=	3 + round(15*gvDiffLVL)
		MapEditor_Armies[3].defensiveArmies.strength 	= 	0
		MapEditor_Armies[4].offensiveArmies.strength	=	round(25/gvDiffLVL)
		MapEditor_Armies[6].offensiveArmies.strength	=	round(25/gvDiffLVL)
		--
		ConnectLeaderWithArmy(Logic.GetEntityIDByName("Dario"), nil, "offensiveArmies")
		--
		Init_Merchant()
		--
		Init_Diplomacy()
		--
		ActivateShareExploration(1,3,true)
		ActivateShareExploration(2,3,true)
		--
		StartSimpleJob("NPCControl")
		EnableNpcMarker(GetEntityId("Major"))
		EnableNpcMarker(GetEntityId("serf"))
		EnableNpcMarker(GetEntityId("hermit"))
		EnableNpcMarker(GetEntityId("scout"))
		EnableNpcMarker(GetEntityId("miner"))
		EnableNpcMarker(GetEntityId("miner2"))
		EnableNpcMarker(GetEntityId("wanderer"))
		--
		ResearchTechnology(Technologies.T_ThiefSabotage, 4)
		StartCountdown(2*60*gvDiffLVL,TroopSpawnVorb,false)
		if not ThiefSpawnPos then
			ThiefSpawnPos = {[1] = {X = 7500, Y = 10000},
							[2] = GetPosition("Bandit_Tower3"),
							[3] = GetPosition("Bandit_Tower4"),
							[4] = GetPosition("SpawnThiefWest"),
							[5] = GetPosition("Bandit_Tower5")}
			ThiefHidePosByIndex = {[1] = {X = 4100, Y = 14600},
									[2] = {X = 15500, Y = 14700},
									[3] = {X = 15500, Y = 14700},
									[4] = {X = 10400, Y = 22000},
									[5] = {X = 10400, Y = 22000}}
		end
	end

end

function AnfangsBriefingInitialize()

	AnfangsBriefing()
	return true
end
function UpgradeKIa()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 4,8 do
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
	StartCountdown(30*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 4,8 do
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
function IncreaseHillArmyStrength()
	MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength + round(3/gvDiffLVL)
	MapEditor_Armies[6].offensiveArmies.rodeLength = MapEditor_Armies[6].offensiveArmies.rodeLength + round(3000/gvDiffLVL)
	StartCountdown(10*gvDiffLVL*60, IncreaseHillArmyStrength, false)
end
function Init_Merchant()

  local mercenaryId = Logic.GetEntityIDByName("merc1")
  Logic.AddMercenaryOffer(mercenaryId, Entities.CU_VeteranMajor, 6, ResourceType.Silver, 200)
  Logic.AddMercenaryOffer(mercenaryId, Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 350)
  Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword3, 12, ResourceType.Gold, 300)
  Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, 5, ResourceType.Gold, 500)

end
function AnfangsBriefing()

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Bürgermeister von Hillside",
        text	= "@color:230,0,0 Sir, unsere natürlichen Ressourcen sind beinahe erschöpft und die Spannungen mit dem dunklen Fürsten im Osten nehmen zu. @cr Er wartet nur auf eine Gelegenheit, um uns anzugreifen. @cr Erec im Süden könnte uns mit Armeen und Ressourcen aushelfen, aber für deren Beschaffung benötigt er Zeit.",
		position = GetPosition(70535)
    }
	AP{
        title	= "@color:230,120,0 Bürgermeister von Hillside",
        text	= "@color:230,0,0 Diese Brücke stellt für Erec die einzige Möglichkeit dar, uns zu erreichen. @cr Solange Erec die Truppen aufstellt, müssen wir sie unter allen Umständen verteidigen, oder wir sind verloren!",
		position = GetPosition("BridgeSouth")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 1. Verteidigt Hillside bis Erec eintrifft @cr 2. Vernichtet den dunklen Fürsten und all seine Untergebenen",
		position = GetPosition("start_pos_p1"),
		action = function()
			StartCountdown(3,ShowArmyCreatorGUI,false)
			StartCountdown(6,Mission_InitGroups,false)
		end

    }

    StartBriefing(briefing)

end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
		XGUIEng.ShowWidget("BS_ArmyCreator_Hero1",0)
	end
end
-------------------------------------------------------------------------------
------------------------------ BRIEFINGS --------------------------------------
-------------------------------------------------------------------------------
function Major()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Major","Bürgermeister von Hillside","@color:230,0,0 Guten Tag. @cr Wir haben Euch schon erwartet.", false)
	ASP("support","Bürgermeister von Hillside","@color:230,0,0 Solange Erecs Truppen noch nicht angekommen sind, wird er uns Rohstoffe per Karren senden. @cr Ihr müsst diese unbedingt beschützen!", false)
	ASP("Major","Bürgermeister von Hillside","@color:230,0,0 Wenn genügend Güter angekommen sind, können wir unsere Armee weiter ausbauen.", false)

	briefing.finished = function()
		CaravansArrived = 0
		CaravanCounter = StartCountdown(round(6/gvDiffLVL*60), Caravans, false)
		StartSimpleJob("CheckForCaravans")
	end
    StartBriefing(briefing)
end
function Caravans()
	local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("support"))
	local posX2, posY2 = Logic.GetEntityPosition(Logic.GetEntityIDByName("player3"))
	for i = 1, 5 + (AdditionalCaravans or 0) do
		local id = Logic.CreateEntity(Entities.PU_Travelling_Salesman, posX+(i*30), posY+(i*30), 0, 3)
		Logic.MoveSettler(id, posX2, posY2)
	end
	if not ErecArrived then
		StartCountdown(round(6/gvDiffLVL*60/(CaravanMultiplier or 1)), Caravans, false)
	end
end
function CheckForCaravans()
	local id = Logic.GetEntityIDByName("player3")
	local posX, posY = Logic.GetEntityPosition(id)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.PU_Travelling_Salesman)) do
		if not Logic.IsEntityMoving(eID) then
			if GetDistance(eID, id) <= 1000 then
				CaravansArrived = CaravansArrived + 1
				Logic.DestroyEntity(eID)
			else
				Logic.MoveSettler(eID, posX, posY)
			end
		end
	end
	if CaravansArrived >= 15 then
		CaravansArrived = CaravansArrived - 15
		MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength + round(3 * gvDiffLVL)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,3)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,3)
	end
end
function Serf()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("serf","Überlebender der Verschleppten","@color:230,0,0 Ich... @cr Ich... @cr Ich konnte entkommen.", false)
	ASP("PrisonTower","Überlebender der Verschleppten","@color:230,0,0 Viele der anderen Dorfbewohner werden aber immer noch dort gefangen genommen. @cr Bitte, Herr. Befreit Sie!", false)

	briefing.finished = function()
		StartSimpleJob("PrisonCheck")
	end
    StartBriefing(briefing)
end
function PrisonCheck()
	if IsDestroyed("PrisonTower") and not AreEntitiesOfDiplomacyStateInArea(1, GetPosition("PrisonTower"), 3000, Diplomacy.Hostile) then
		local army	= {}
		army.player    = 3
		army.id = GetFirstFreeArmySlot(3)
		army.strength = round(5*gvDiffLVL)
		army.position = {X = 49100, Y = 12800}
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.PU_LeaderSword4

		for i = 1,army.strength,1 do
			EnlargeArmy(army,troopDescription)
		end
		local id = Logic.CreateEntity(Entities.CU_VeteranCaptain, 49100, 12800, 0, 3)
		ConnectLeaderWithArmy(id, army)

		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,"Anführer der Rebellen","@color:230,0,0 Endlich frei!", false)
		ASP(id,"Anführer der Rebellen","@color:230,0,0 Danke für die Befreiung. @cr Wir werden uns sofort in die Offensive begeben und uns an den Räubern rächen!", false)

		briefing.finished = function()
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyPrison",1,{},{army.id})
		end
		StartBriefing(briefing)
		return true
	end
end
function ControlArmyPrison(_id)
	if IsDead(ArmyTable[3][_id + 1]) then
		return true
    else
		Defend(ArmyTable[3][_id + 1])
    end
end
function Miner()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("AlternativeDetection","In Vergangengeit schwelgender Bergmann","@color:230,0,0 Das war hier mal eine ergiebige Bergbaugegend. @cr Vor langer Zeit einmal...", false)
	ASP("miner","In Vergangengeit schwelgender Bergmann","@color:230,0,0 Und nun gibt es hier nur noch Krieg um die letzten verbliebenen Rohstoffe...", false)
	ASP("miner","In Vergangengeit schwelgender Bergmann","@color:230,0,0 Hier. Nehmt dies. @cr Vielleicht könnt ihr damit ja den Krieg schneller beenden.", false)

	briefing.finished = function()
		for i = 1,2 do
			AddGold(i, dekaround(800*gvDiffLVL))
		end
	end
    StartBriefing(briefing)
end
function Miner2()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("miner2","Pensionierter Bergmann","Früher habe ich hier einmal in der nahen Eisenmine gearbeitet.", false)
	ASP("miner2","Pensionierter Bergmann","Aber die Gier der Menschen hat um die letzten Rohstoffe in der Gegend immer wieder Scharmützel entfacht. @cr Um mich und meine Familie in Sicherheit zu bringen, haben wir sogar einen Zaun errichtet, der den Bergweg nach Osten blockiert.", false)
	ASP("miner2","Pensionierter Bergmann","Ihr wollt dort hindurch, um den Feind zu überraschen? @cr Gebt mir Bescheid und ich beseitige den Zaun.", false)

	briefing.finished = function()
		Miner2Tribute()
	end
    StartBriefing(briefing)
end
function Miner2Tribute()
	local Min2tribute =  {}
	Min2tribute.playerId = 1
	Min2tribute.text = "Klickt hier, damit der Bergmann den Zaun entfernt, sodass der Weg in die östlichen Berge frei wird.";
	Min2tribute.cost = {Gold = 0}
	Min2tribute.Callback = RemoveFence
	AddTribute( Min2tribute )
end
function RemoveFence()
	local t = {Logic.GetEntities(Entities.XD_IronGrid4, 2)}
	for i = 2, t[1] + 1 do
		DestroyEntity(t[i])
	end
end
function Hermit()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("hermit","Einsiedler","Wunderschön hier oben, nicht wahr?", false)
	ASP("hermit","Einsiedler","Von hier hat man eine gute Sicht auf die umliegenden Gegenden.", false)
	ASP("hermit","Einsiedler","Gebt mir ein paar Taler und ich werde die umliegenden Dörfer um Hilfe bitten können.", false)

	briefing.finished = function()
		HermitTribute1()
		HermitTribute2()
	end
    StartBriefing(briefing)
end
function HermitTribute1()
	local Hermtribute =  {}
	Hermtribute.playerId = 1
	Hermtribute.text = "Zahlt ".. dekaround(2000/gvDiffLVL) .. " Taler, damit die umliegenden Dörfer zusätzliche Karavanen mit Hilfsgütern schicken.";
	Hermtribute.cost = {Gold = dekaround(2000/gvDiffLVL)}
	Hermtribute.Callback = CallAdditionalCaravans
	AddTribute( Hermtribute )
end
function CallAdditionalCaravans()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("hermit","Einsiedler","Ich werde den umliegenden Dörfern ein Signal geben. @cr Karren mit zusätzlichen Gütern werden schon bald eintreffen.", false)

	briefing.finished = function()
		CaravanMultiplier = 1.5
		AdditionalCaravans = round(2*gvDiffLVL)
	end
	StartBriefing(briefing)
end
function HermitTribute2()
	local Hermtribute2 =  {}
	Hermtribute2.playerId = 1
	Hermtribute2.text = "Zahlt ".. dekaround(3000/gvDiffLVL) .. " Taler und ".. dekaround(500/gvDiffLVL) .." Silber, damit die umliegenden Dörfer Verstärkungstruppen schicken.";
	Hermtribute2.cost = {Gold = dekaround(3000/gvDiffLVL), Silver = dekaround(500/gvDiffLVL)}
	Hermtribute2.Callback = CallAdditionalTroops
	AddTribute( Hermtribute2 )
end
function CallAdditionalTroops()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("hermit","Einsiedler","Ich werde den umliegenden Dörfern ein Signal geben. @cr Verstärkungstruppen werden schon bald eintreffen.", false)

	briefing.finished = function()
		StartCountdown(round(10/gvDiffLVL)*60, SpawnAdditionalTroops, false)
	end
	StartBriefing(briefing)
end
function SpawnAdditionalTroops()
	local pos1 = GetPosition("start_pos_p1")
	local pos2 = GetPosition("start_pos_p2")
	for i = 1, round(2*gvDiffLVL) do
		AI.Entity_CreateFormation(1, Entities.PU_LeaderSword4, 0, 12, pos1.X, pos1.Y, 0, 0, 0, 0)
		AI.Entity_CreateFormation(1, Entities.PU_LeaderPoleArm4, 0, 12, pos1.X, pos1.Y, 0, 0, 0, 0)
		AI.Entity_CreateFormation(1, Entities.PU_LeaderPoleRifle2, 0, 6, pos1.X, pos1.Y, 0, 0, 0, 0)
		AI.Entity_CreateFormation(2, Entities.PU_LeaderSword4, 0, 12, pos2.X, pos2.Y, 0, 0, 0, 0)
		AI.Entity_CreateFormation(2, Entities.PU_LeaderPoleArm4, 0, 12, pos2.X, pos2.Y, 0, 0, 0, 0)
		AI.Entity_CreateFormation(2, Entities.PU_LeaderPoleRifle2, 0, 6, pos2.X, pos2.Y, 0, 0, 0, 0)
	end
end
function Scout()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("scout","Ängstlicher Kundschafter","Psst. @cr Ich verstecke mich hier vor den Kriegsparteien. Ich hänge an meinem Leben und scheue die Gefahr.", false)
	ASP("scout","Ängstlicher Kundschafter","Wie meinen? @cr Ihr werdet mich beschützen? @cr Nun gut, dann glaube ich euch mal...", false)
	briefing.finished = function()
		local id = ReplaceEntity("scout", Entities.PU_Scout)
		ChangePlayer(id, 1)
	end
	StartBriefing(briefing)
end
function Wanderer()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("wanderer","Greis mit mittelschwerem Dachschaden","Die sind missverstanden. @cr Einfach nur missverstanden.", false)
	ASP("wanderer","Greis mit mittelschwerem Dachschaden","Ihr wollt mir auch nicht glauben? @cr Pff nur Ignoranten in dieser Welt. Ihr seid die wahren Wilden.", false)
	briefing.finished = function()
		WandererTribute()
	end
	StartBriefing(briefing)
end
function WandererTribute()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Der Greis möchte euch wohl eines der alten Rituale zeigen. Ihr müsst diesem mit einem Helden beiwohnen."
	tribute.cost = {Gold = 0}
	tribute.Callback = WandererTributePayed
	AddTribute( tribute )
end
function WandererTributePayed()
	local t1, t2 = {}, {}
	Logic.GetHeroes(1, t1)
	Logic.GetHeroes(2, t2)
	if next(t1) then
		NVRitual(t1[1])
	elseif next(t2) then
		NVRitual(t2[1])
	else
		WandererTribute()
	end
end
function NVRitual(_id)
	local etyp = Logic.GetEntityType(_id)
	local player = Logic.EntityGetPlayer(_id)
	local name = XGUIEng.GetStringTableText("names/"..Logic.GetEntityTypeName(etyp))
	DestroyEntity(_id)
	for i = 1,3 do
		SetFriendly(i, 5)
		ActivateShareExploration(i, 5, true)
	end
	SetHostile(4,5)
	SetHostile(5,6)
	local id = CreateEntity(player,etyp,{X = 31260, Y = 52600})
	SetHealth(id, 0)
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("NV_Tower1","Schamane","Was für ein würdiges Opfer. @cr ".. name .." wurde dem heiligen Ritual geopfert.", false)
	briefing.finished = function()
		DestroyEntity(id)
		StartSimpleHiResJob("NV_Ritual_Delayed_Action")
	end
	StartBriefing(briefing)

end
function NV_Ritual_Delayed_Action()
	ReinitChunkData(5)
	armyNV_1.rodeLength = Logic.WorldGetSize()
	armyNV_2.rodeLength = Logic.WorldGetSize()
	return true
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function CreateArmyP4_1()

	armyP4_1	= {}
    armyP4_1.player    = 4
    armyP4_1.id = 1
    armyP4_1.strength = round(6/gvDiffLVL)
    armyP4_1.position = GetPosition("Bandit_Tower1")
    armyP4_1.rodeLength = 5500
	SetupArmy(armyP4_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_1.strength,1 do
	    EnlargeArmy(armyP4_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_1")

end

function ControlArmyP4_1()

    if IsDead(armyP4_1) and IsExisting("Bandit_Tower1") then
        CreateArmyP4_1()
        return true
    else
		if main_armies_aggressive == 0 then
			Defend(armyP4_1)
		else
			Advance(armyP4_1)
		end
    end
end
function CreateArmyP4_2()

	armyP4_2	= {}
    armyP4_2.player    = 4
    armyP4_2.id = 2
    armyP4_2.strength = round(6/gvDiffLVL)
    armyP4_2.position = GetPosition("Bandit_Tower2")
    armyP4_2.rodeLength = 6000
	SetupArmy(armyP4_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_2.strength,1 do
	    EnlargeArmy(armyP4_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_2")

end

function ControlArmyP4_2()

    if IsDead(armyP4_2) and IsExisting("Bandit_Tower2") then
        CreateArmyP4_2()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_2)
		else
			Advance(armyP4_2)
		end
	end
end
function CreateArmyP4_3()

	armyP4_3	= {}
    armyP4_3.player    = 4
    armyP4_3.id = 3
    armyP4_3.strength = round(6/gvDiffLVL)
    armyP4_3.position = GetPosition("Bandit_Tower3")
    armyP4_3.rodeLength = 6500
	SetupArmy(armyP4_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,armyP4_3.strength,1 do
	    EnlargeArmy(armyP4_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_3")

end

function ControlArmyP4_3()

    if IsDead(armyP4_3) and IsExisting("Bandit_Tower3") then
        CreateArmyP4_3()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_3)
		else
			Advance(armyP4_3)
		end
    end
end
function CreateArmyP4_4()

	armyP4_4	= {}
    armyP4_4.player    = 4
    armyP4_4.id = 4
    armyP4_4.strength = round(5/gvDiffLVL)
    armyP4_4.position = GetPosition("Bandit_Tower4")
    armyP4_4.rodeLength = 5000
	SetupArmy(armyP4_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_4.strength,1 do
	    EnlargeArmy(armyP4_4,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_4")

end

function ControlArmyP4_4()

    if IsDead(armyP4_4) and IsExisting("Bandit_Tower4") then
        CreateArmyP4_4()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_4)
		else
			Advance(armyP4_4)
		end
    end
end
function CreateArmyP4_5()

	armyP4_5	= {}
    armyP4_5.player    = 4
    armyP4_5.id = 5
    armyP4_5.strength = round(8/gvDiffLVL)
    armyP4_5.position = GetPosition("Bandit_Tower5")
    armyP4_5.rodeLength = 6500
	SetupArmy(armyP4_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1,armyP4_5.strength,1 do
	    EnlargeArmy(armyP4_5,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_5")

end

function ControlArmyP4_5()

    if IsDead(armyP4_5) and IsExisting("Bandit_Tower5") then
        CreateArmyP4_5()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_5)
		else
			Advance(armyP4_5)
		end
    end
end

function CreateArmyP4_6()

	armyP4_6	= {}
    armyP4_6.player    = 4
    armyP4_6.id = 6
    armyP4_6.strength = round(5/gvDiffLVL)
    armyP4_6.position = GetPosition("Bandit_Tower6")
    armyP4_6.rodeLength = 4000
	SetupArmy(armyP4_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_6.strength,1 do
	    EnlargeArmy(armyP4_6,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_6")

end

function ControlArmyP4_6()

    if IsDead(armyP4_6) and IsExisting("Bandit_Tower6") then
        CreateArmyP4_6()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_6)
		else
			Advance(armyP4_6)
		end
    end
end

function CreateArmyP4_7()

	armyP4_7	= {}
    armyP4_7.player    = 4
    armyP4_7.id = 7
    armyP4_7.strength = round(5/gvDiffLVL)
    armyP4_7.position = GetPosition("Bandit_Tower7")
    armyP4_7.rodeLength = 5000
	SetupArmy(armyP4_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_7.strength,1 do
	    EnlargeArmy(armyP4_7,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_7")

end

function ControlArmyP4_7()

    if IsDead(armyP4_7) and IsExisting("Bandit_Tower7") then
        CreateArmyP4_7()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_7)
		else
			Advance(armyP4_7)
		end
    end
end

function CreateArmyP4_8()

	armyP4_8	= {}
    armyP4_8.player    = 4
    armyP4_8.id = 8
    armyP4_8.strength = round(5/gvDiffLVL)
    armyP4_8.position = GetPosition("Bandit_Tower8")
    armyP4_8.rodeLength = 5000
	SetupArmy(armyP4_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(6/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

    for i = 1,armyP4_8.strength,1 do
	    EnlargeArmy(armyP4_8,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_8")

end

function ControlArmyP4_8()

    if IsDead(armyP4_8) and IsExisting("Bandit_Tower8") then
        CreateArmyP4_8()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_8)
		else
			Advance(armyP4_8)
		end
    end
end

function CreateArmyP4_9()

	armyP4_9	= {}
    armyP4_9.player    = 4
    armyP4_9.id = 9
    armyP4_9.strength = round(7/gvDiffLVL)
    armyP4_9.position = GetPosition("Bandit_Tower9")
    armyP4_9.rodeLength = 3500
	SetupArmy(armyP4_9)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_9.strength,1 do
	    EnlargeArmy(armyP4_9,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_9")

end

function ControlArmyP4_9()

    if IsDead(armyP4_9) and IsExisting("Bandit_Tower9") then
        CreateArmyP4_9()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_9)
		else
			Advance(armyP4_9)
		end
    end
end

function CreateArmyP4_10()

	armyP4_10	= {}
    armyP4_10.player    = 4
    armyP4_10.id = 10
    armyP4_10.strength = round(4/gvDiffLVL)
    armyP4_10.position = GetPosition("Bandit_Tower10")
    armyP4_10.rodeLength = 3500
	SetupArmy(armyP4_10)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_10.strength,1 do
	    EnlargeArmy(armyP4_10,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_10")

end

function ControlArmyP4_10()

    if IsDead(armyP4_10) and IsExisting("Bandit_Tower10") then
        CreateArmyP4_10()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_10)
		else
			Advance(armyP4_10)
		end
    end
end

function CreateArmyP4_11()

	armyP4_11	= {}
    armyP4_11.player    = 4
    armyP4_11.id = 11
    armyP4_11.strength = round(9/gvDiffLVL)
    armyP4_11.position = GetPosition("Bandit_Tower11")
    armyP4_11.rodeLength = 8500
	SetupArmy(armyP4_11)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,armyP4_11.strength,1 do
	    EnlargeArmy(armyP4_11,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_11")

end

function ControlArmyP4_11()

    if IsDead(armyP4_11) and IsExisting("Bandit_Tower11") then
        CreateArmyP4_11()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_11)
		else
			Advance(armyP4_11)
		end
    end
end

function CreateArmyP4_12()

	armyP4_12	= {}
    armyP4_12.player    = 4
    armyP4_12.id = 12
    armyP4_12.strength = round(4/gvDiffLVL)
    armyP4_12.position = GetPosition("Bandit_Tower12")
    armyP4_12.rodeLength = 2500
	SetupArmy(armyP4_12)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(12/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP4_12.strength,1 do
	    EnlargeArmy(armyP4_12,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_12")

end

function ControlArmyP4_12()

    if IsDead(armyP4_12) and IsExisting("Bandit_Tower12") then
        CreateArmyP4_12()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_12)
		else
			Advance(armyP4_12)
		end
    end
end

function CreateArmyP4_13()

	armyP4_13	= {}
    armyP4_13.player    = 4
    armyP4_13.id = 13
    armyP4_13.strength = round(6/gvDiffLVL)
    armyP4_13.position = GetPosition("Bandit_Tower13")
    armyP4_13.rodeLength = 4000
	SetupArmy(armyP4_13)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(10/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,armyP4_13.strength,1 do
	    EnlargeArmy(armyP4_13,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_13")

end

function ControlArmyP4_13()

    if IsDead(armyP4_13) and IsExisting("Bandit_Tower13") then
        CreateArmyP4_13()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_13)
		else
			Advance(armyP4_13)
		end
    end
end

function CreateArmyP4_14()

	armyP4_14	= {}
    armyP4_14.player    = 4
    armyP4_14.id = 14
    armyP4_14.strength = round(5/gvDiffLVL)
    armyP4_14.position = GetPosition("Bandit_Tower14")
    armyP4_14.rodeLength = 3500
	SetupArmy(armyP4_14)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(10/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,armyP4_14.strength,1 do
	    EnlargeArmy(armyP4_14,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_14")

end

function ControlArmyP4_14()

    if IsDead(armyP4_14) and IsExisting("Bandit_Tower14") then
        CreateArmyP4_14()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP4_14)
		else
			Advance(armyP4_14)
		end
    end
end

function CreateArmyNV_1()

	armyNV_1	= {}
    armyNV_1.player    = 5
    armyNV_1.id = 1
    armyNV_1.strength = round(5/gvDiffLVL)
    armyNV_1.position = GetPosition("NV_Tower1")
    armyNV_1.rodeLength = armyNV_1.rodeLength or 6300
	SetupArmy(armyNV_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(16/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1,armyNV_1.strength,1 do
	    EnlargeArmy(armyNV_1,troopDescription)
	end

    StartSimpleJob("ControlArmyNV_1")

end

function ControlArmyNV_1()

    if IsDead(armyNV_1) and IsExisting("NV_Tower1") then
        CreateArmyNV_1()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyNV_1)
		else
			Advance(armyNV_1)
		end
    end
end

function CreateArmyNV_2()

	armyNV_2	= {}
    armyNV_2.player    = 5
    armyNV_2.id = 2
    armyNV_2.strength = round(3/gvDiffLVL)
    armyNV_2.position = GetPosition("NV_Tower1")
    armyNV_2.rodeLength = armyNV_2.rodeLength or 6300
	SetupArmy(armyNV_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(16/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1,armyNV_2.strength,1 do
	    EnlargeArmy(armyNV_2,troopDescription)
	end

    StartSimpleJob("ControlArmyNV_2")

end

function ControlArmyNV_2()

    if IsDead(armyNV_2) and IsExisting("NV_Tower1") then
        CreateArmyNV_2()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyNV_2)
		else
			Advance(armyNV_2)
		end
    end
end

function CreateArmyErec_1()

	ArmyErec_1	= {}
    ArmyErec_1.player    = 3
    ArmyErec_1.id = 1
    ArmyErec_1.strength = round(12*math.sqrt(gvDiffLVL))
    ArmyErec_1.position = GetPosition("support")
    ArmyErec_1.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,ArmyErec_1.strength-1,1 do
	    EnlargeArmy(ArmyErec_1,troopDescription)
	end
	ConnectLeaderWithArmy(CreateEntity(3,Entities.PU_Hero4,GetPosition("support")), ArmyErec_1)

    StartSimpleJob("ControlArmyErec_1")

end

function ControlArmyErec_1()

    if IsDead(ArmyErec_1) then
        return true
    else
		Defend(ArmyErec_1)
    end
end
function CreateArmyErec_2()

	ArmyErec_2	= {}
    ArmyErec_2.player    = 3
    ArmyErec_2.id = 2
    ArmyErec_2.strength = round(12*math.sqrt(gvDiffLVL))
    ArmyErec_2.position = GetPosition("support")
    ArmyErec_2.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderPoleArm4

    for i = 1,ArmyErec_2.strength,1 do
	    EnlargeArmy(ArmyErec_2,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_2")

end

function ControlArmyErec_2()

    if IsDead(ArmyErec_2) then
        return true
    else
		Defend(ArmyErec_2)
    end
end

function CreateArmyErec_3()

	ArmyErec_3	= {}
    ArmyErec_3.player    = 3
    ArmyErec_3.id = 3
    ArmyErec_3.strength = round(10*math.sqrt(gvDiffLVL))
    ArmyErec_3.position = GetPosition("support")
    ArmyErec_3.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,ArmyErec_3.strength,1 do
	    EnlargeArmy(ArmyErec_3,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_3")

end

function ControlArmyErec_3()

    if IsDead(ArmyErec_3) then
        return true
    else
		Defend(ArmyErec_3)
    end
end
function CreateArmyErec_4()

	ArmyErec_4	= {}
    ArmyErec_4.player    = 3
    ArmyErec_4.id = 4
    ArmyErec_4.strength = round(6*math.sqrt(gvDiffLVL))
    ArmyErec_4.position = GetPosition("support")
    ArmyErec_4.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 3
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderHeavyCavalry2

    for i = 1,ArmyErec_4.strength,1 do
	    EnlargeArmy(ArmyErec_4,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_4")

end

function ControlArmyErec_4()

    if IsDead(ArmyErec_4) then
        return true
    else
		Defend(ArmyErec_4)
    end
end

function CreateArmyErec_5()

	ArmyErec_5	= {}
    ArmyErec_5.player    = 3
    ArmyErec_5.id = 5
    ArmyErec_5.strength = round(6*math.sqrt(gvDiffLVL))
    ArmyErec_5.position = GetPosition("support")
    ArmyErec_5.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2

    for i = 1,ArmyErec_5.strength,1 do
	    EnlargeArmy(ArmyErec_5,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_5")

end

function ControlArmyErec_5()

    if IsDead(ArmyErec_5) then
        return true
    else
		Defend(ArmyErec_5)
    end
end

function CreateArmyErec_6()

	ArmyErec_6	= {}
    ArmyErec_6.player    = 3
    ArmyErec_6.id = 6
    ArmyErec_6.strength = round(6*math.sqrt(gvDiffLVL))
    ArmyErec_6.position = GetPosition("support")
    ArmyErec_6.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_6)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon2

    for i = 1,ArmyErec_6.strength,1 do
	    EnlargeArmy(ArmyErec_6,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_6")

end

function ControlArmyErec_6()

    if IsDead(ArmyErec_6) then
        return true
    else
		Defend(ArmyErec_6)
    end
end
function CreateArmyErec_7()

	ArmyErec_7	= {}
    ArmyErec_7.player    = 3
    ArmyErec_7.id = 7
    ArmyErec_7.strength = round(6*math.sqrt(gvDiffLVL))
    ArmyErec_7.position = GetPosition("support")
    ArmyErec_7.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_7)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon4

    for i = 1,ArmyErec_7.strength,1 do
	    EnlargeArmy(ArmyErec_7,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_7")

end

function ControlArmyErec_7()

    if IsDead(ArmyErec_7) then
        return true
    else
		Defend(ArmyErec_7)
    end
end
function CreateArmyErec_8()

	ArmyErec_8	= {}
    ArmyErec_8.player    = 3
    ArmyErec_8.id = 8
    ArmyErec_8.strength = round(8*math.sqrt(gvDiffLVL))
    ArmyErec_8.position = GetPosition("support")
    ArmyErec_8.rodeLength = Logic.WorldGetSize()
	SetupArmy(ArmyErec_8)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon3

    for i = 1,ArmyErec_8.strength,1 do
	    EnlargeArmy(ArmyErec_8,troopDescription)
	end

    StartSimpleJob("ControlArmyErec_8")

end

function ControlArmyErec_8()

    if IsDead(ArmyErec_8) then
        return true
    else
		Defend(ArmyErec_8)
    end
end
function Mission_InitGroups()


	Mission_InitTechnologies()

	function GUIAction_BuyMerchantOffer(_index)

		local PlayerID = GUI.GetPlayerID()

		Logic.GetMercenaryOffer(SelectedTroopMerchantID,_index, InterfaceGlobals.CostTable)

		if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then
			-- Yes
			GUI.BuyMerchantOffer(SelectedTroopMerchantID, PlayerID, _index)
			GUIUpdate_TroopOffer(_index)
		end

	end
end
function Init_Diplomacy()
	SetFriendly(1,3)
	SetFriendly(2,3)
	SetHostile(1,4)
	SetHostile(2,4)
	SetHostile(3,4)
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(3,5)
	SetHostile(1,6)
	SetHostile(2,6)
	SetHostile(3,6)
end
function InitPlayerColorMapping()

	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),1)
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

	SetPlayerName(3, "Hillside")
	SetPlayerName(4, "Angreifende Truppen")
	Display.SetPlayerColorMapping(4,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(5,EVIL_GOVERNOR_COLOR)
	Display.SetPlayerColorMapping(6,ROBBERS_COLOR)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.B_Residence, i)
		ForbidTechnology(Technologies.B_Farm, i)
		ForbidTechnology(Technologies.B_GenericMine, i)
		ForbidTechnology(Technologies.B_University, i)
		ForbidTechnology(Technologies.B_Village, i)
		ForbidTechnology(Technologies.B_VillageHall, i)
		ForbidTechnology(Technologies.B_Claymine, i)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()
end

function Timer()

	Message("Erecs Verstärkungstruppen sind eingetroffen!")
	for i = 1, 8 do
		_G["CreateArmyErec_" .. i]()
	end
	StartWinter(60*60*60)
	ErecArrived = true
	StopCountdown(CaravanCounter)
	StopCountdown(ThiefSpawn)
	StartCountdown(10*gvDiffLVL*60, IncreaseHillArmyStrength, false)
	--
	MapEditor_Armies[3].offensiveArmies.rodeLength = Logic.WorldGetSize()

end
function DefeatJob()
	local t1,t2 = {},{}
	Logic.GetHeroes(1, t1)
	Logic.GetHeroes(2, t2)
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + table.getn(t1) + table.getn(t2)) == 0
	or IsDead("player3")
	or IsDead("BridgeSouth")
	or Logic.GetNumberOfEntitiesOfTypeOfPlayer(3, Entities.PB_Beautification11) == 0 then
		Defeat()
		return true
	end
end
function VictoryJob()

	if (AI.Player_GetNumberOfLeaders(4) + AI.Player_GetNumberOfLeaders(6)) == 0 and (Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.PB_Outpost1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.PB_Barracks1)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.CB_Castle1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.PB_Archery2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.PB_DarkTower3)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.PB_Tower2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.CB_Bastille1)) == 0
	and IsDead("MountainFortress") and (IsDead("NV_Tower1") or Logic.GetDiplomacyState(1, 5) == Diplomacy.Friendly) then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map5_won", 2)
				end
			end
		end
		Victory()
		return true
	end

end
function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.floor(math.min((3.0+((math.random(1,5)/10))) *60, 8*60/(math.sqrt(gvDiffLVL))))
	TroopSpawn(TimePassed)
	if not ErecArrived then
		SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
	end
end
trooptypes = {Entities.PU_LeaderBow4,Entities.PU_LeaderRifle2,Entities.PU_LeaderSword4,Entities.PU_LeaderPoleArm4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_Evil_LeaderBearman,Entities.CU_Evil_LeaderSkirmisher,Entities.CU_BlackKnight_LeaderSword3,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1},
				[2] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1, Entities.PU_LeaderBow1},
				[3] = {Entities.PU_LeaderPoleArm2, Entities.PU_LeaderSword2, Entities.PU_LeaderBow2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.PU_LeaderHeavyCavalry1, Entities.PU_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2, Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,5)]}
			}
function TroopSpawn(_TimePassed)
	Message("Feindestruppen versammeln sich, um das Dorf Eures Verbündeten zu vernichten!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_varg, 120)
	--local type1,type2,type3,type4
	for i = 1,14 do
		if _TimePassed <= 10 then
			CreateAttackingArmies("Bandit_Tower", i, 1)

		elseif _TimePassed > 10 and _TimePassed <= 18 then
			CreateAttackingArmies("Bandit_Tower", i, 2)

		elseif _TimePassed > 18 and _TimePassed <= 26 then
			CreateAttackingArmies("Bandit_Tower", i, 3)

		elseif _TimePassed > 26 and _TimePassed <= 46 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("Bandit_Tower", i, 4)

		elseif _TimePassed > 46 and _TimePassed <= 55 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("Bandit_Tower", i, 5)

		elseif _TimePassed > 55 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,5)]}
			--
			CreateAttackingArmies("Bandit_Tower", i, 6)

		end
	end
end
InvasionArmyIDByPattern = {["Bandit_Tower"] = {}}
function CreateAttackingArmies(_name, _poscount, _index)
	if not IsExisting("Bandit_Tower" .. _poscount) then
		return
	end
	local player = 4
	local army	= {}
	local id = InvasionArmyIDByPattern[_name][_poscount]
	if not id then
		army.player = player
		army.id	  	=  GetFirstFreeArmySlot(4)
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
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.id})

end
function ControlArmies(_id)

    if IsDead(ArmyTable[4][_id + 1]) then
		return true
    else
		Defend(ArmyTable[4][_id + 1])
    end
end

function ThiefAttack()

	local amount = 1 + round(Logic.GetTime()/60/(10*gvDiffLVL))
	for i = 1, amount do
		local rand = math.random(1, table.getn(ThiefSpawnPos))
		local id = Logic.CreateEntity(Entities.PU_Thief, ThiefSpawnPos[rand].X, ThiefSpawnPos[rand].Y, 0, 4)
		local bridge = Logic.GetEntityIDByName("BridgeSouth");
		(CSendEvent or SendEvent).ThiefSabotage(id, bridge)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlThief",1,{},{id, bridge, rand})
		--
		local army	= {}
		army.player = 4
		army.id	  	=  GetFirstFreeArmySlot(4)
		army.strength = amount
		army.position = ThiefSpawnPos[rand]
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities["PU_LeaderSword" .. round(4 - gvDiffLVL)]
		for j = 1, army.strength do
			EnlargeArmy(army, troopDescription)
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.id})
	end
	if not ErecArrived then
		ThiefSpawn = StartCountdown(round(10*60*math.sqrt(gvDiffLVL)), ThiefAttack, false)
	end
end
function ControlThief(_id, _bridge, _index)
	if not IsValid(_id) or not IsValid(_bridge) then
		return true
	end
	local t = CEntity.GetAttachedEntities(_bridge)
	if t[72] and table.getn(t[72]) then
		if t[72][1] ~= _id then
			local id = GetTurretNearBridgeSabotageSlotFree(_bridge)
			if id then
				(CSendEvent or SendEvent).ThiefSabotage(_id, id)
			else
				local pos = ThiefHidePosByIndex[_index]
				Logic.MoveSettler(_id, pos.X, pos.Y)
			end
		end
	else
		(CSendEvent or SendEvent).ThiefSabotage(_id, _bridge)
	end
end
function GetTurretNearBridgeSabotageSlotFree(_bridge)
	if not IsValid(_bridge) then
		return
	end
	local pos = GetPosition(_bridge)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(3), CEntityIterator.OfTypeFilter(Entities.PB_Tower2), CEntityIterator.InCircleFilter(pos.X, pos.Y, 4000)) do
		local t = CEntity.GetAttachedEntities(eID)
		if not next(t) then
			return eID
		else
			if not t[72] then
				return eID
			end
		end
	end
end
function CatapultRangeExploitNoDamage()

	local attacker = Event.GetEntityID1()

	local attackerpos = GetPosition(attacker)

    local target = Event.GetEntityID2()

	local targetpos = GetPosition(target)

	local attype = Logic.GetEntityType(attacker)

	if attype == Entities.PV_Catapult then

		local maxrange = round(GetEntityTypeMaxAttackRange(attacker, Logic.EntityGetPlayer(attacker)))

		if math.abs(GetDistance(attackerpos,targetpos)) > (maxrange + 100) then

			CEntity.TriggerSetDamage(0)

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