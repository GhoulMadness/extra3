--------------------------------------------------------------------------------
-- MapName: (2) Zweite Prüfung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Zweite Prüfung - Taktische Finesse "
gvMapVersion = " v1.4 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,0,0,0,1)

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
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	--
	InitPlayerColorMapping()
	--
	LocalMusic.UseSet = MEDITERANEANMUSIC
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
	gvDiffLVL = 2.0
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
	gvDiffLVL = 1.7
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
	gvDiffLVL = 1.4
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

	if GUI.GetPlayerID() ~= 17 then
		Input.KeyBindDown(Keys.F6, "XGUIEng.ShowWidget(\"SettlerServerInformation\", 0)", 2 )
		Input.KeyBindDown(Keys.ModifierShift + Keys.F6, "XGUIEng.ShowWidget(\"SettlerServerInformation\", 0)", 2 )
		Input.KeyBindUp(Keys.F6, "XGUIEng.ShowWidget(\"SettlerServerInformation\", 0)", 2 )
		XGUIEng.ShowWidget("SettlerServerInformation", 0)
	end
	KeyBindings_TogglePause()
	KeyBindings_TogglePause()

	--Input.KeyBindDown(Keys.Pause, "Message(\"Pause auf diesem Schwierigkeitsgrad nicht möglich\")", 2 )
	function KeyBindings_TogglePause()
		local Speed = Game.GameTimeGetFactor()
		if Speed == 0 then
			Game.GameTimeSetFactor( 1 )
			Stream.Pause(false)
			Sound.Pause3D(false)
		else
			Message("Pause auf diesem Schwierigkeitsgrad nicht möglich")
		end
	end

	StartInitialize()
end
function StartInitialize()

	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
		SetFriendly(1,2)
		SetFriendly(1,6)
		SetFriendly(2,6)
	else
		SetHostile(1,3)
		SetHostile(1,7)
		SetHostile(1,8)
		SetFriendly(1,6)
	end
	local centerpos = Logic.WorldGetSize()/2
	for i = 1,2 do
		ActivateShareExploration(i,6,true)
		SetFriendly(i,6)
		Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity, centerpos + (i/100), centerpos, 0, i), 10000)
	end
	Mission_InitLocalResources()

	IncludeGlobals("Tools\\ArmyCreator")

	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end
	TimeLimit = 35*60*gvDiffLVL
	StartSimpleHiResJob("AnfangsBriefingInitialize")

	local tab = ChestRandomPositions.CreateChests(5)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	function ArmyCreator.OnSetupFinished()

		HideArmyCreatorGUI()
		XGUIEng.ShowWidget("ChangeIntoSerf",0)

		SetFriendly(1,6)
		SetFriendly(2,6)

		local ids = {Logic.GetEntities(Entities.XD_WallStraightGate_Closed, 20)}
		table.remove(ids,1)
		for i = 1,table.getn(ids) do
			ReplaceEntity(ids[i],Entities.XD_WallStraightGate)
		end
		StartSimpleJob("DefeatJob")
		StartSimpleJob("VictoryJob")

		StartSimpleJob("AreaCheck1")
		StartSimpleJob("AreaCheck2")
		StartSimpleJob("AreaCheck3")

		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "CatapultRangeExploitNoDamage", 1);

		StartCountdown(10*60*gvDiffLVL,UpgradeKIa,false)
		StartCountdown(35*60*gvDiffLVL,AIIncreaseAggressiveness,false)
		StartCountdown(TimeLimit,DefeatTimer,true)

		MapEditor_SetupAI(8,3-round(gvDiffLVL),5000,4-round(gvDiffLVL),"P8",3-round(gvDiffLVL),1800*gvDiffLVL)
	end

end

function AnfangsBriefingInitialize()

	AnfangsBriefing()
	return true
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
	StartCountdown(15*60*gvDiffLVL,UpgradeKIb,false)
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
	StartCountdown(9*60*gvDiffLVL,UpgradeKIc,false)
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
        text	= "@color:230,0,0 Gut euch zu sehen, mein Herr. @cr Eine wahrlich karge Steppenlandschaft, in die Ihr Euch da begeben habt.",
		position = GetPosition("chest6")
    }
	AP{
        title	= "@color:230,120,0 major",
        text	= "@color:230,0,0 Der Statthalter einer großen Stadt im Südwesten, Kafarna, ist euch feindlich gesonnen und wurde im Laufe der letzten kriegerischen Auseinandersetzungen zurückgedrängt.",
		position = GetPosition("major")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Nun liegt es an Euch, die Chance zu ergreifen, die Stadt zu erobern und alle Feinde zu besiegen. @cr Doch Achtung: Innerhalb von ".. round(TimeLimit/60) .." Minuten werden Verstärkungstruppen eintreffen und ihr werdet keinerlei Chance mehr haben.",
		position = GetPosition("start_pos_p1"),
		action = function()
			StartCountdown(3,ShowArmyCreatorGUI,false)
			StartCountdown(6,Mission_InitGroups,false)
			for i = 1,2 do
				Logic.SetEntityExplorationRange(({Logic.GetPlayerEntities(i, Entities.XD_ScriptEntity, 1)})[2],0)
			end
		end

    }

    StartBriefing(briefing)

end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
	end
end
function HideArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",1)
		XGUIEng.ShowWidget("BS_ArmyCreator",0)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()

	local idtable = {	[1] = {},
						[2] = {},
						[3] = {}
					}
	do
		local pos = GetPosition("guard_gate1")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(4-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderPoleArm"..(4-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 7600, 21500)
		end
	end
	do
		local pos = GetPosition("guard_gate2")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderSword"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 17478, 13859)
		end
	end
	do
		local pos = GetPosition("guard_gate3")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = GetPosition("guard_gate4")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderPoleArm"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 17478, 13859)
		end
	end
	do
		local pos = GetPosition("guard_gate5")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(4-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = GetPosition("guard_gate6")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderRifle"..(3-math.ceil(gvDiffLVL))], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
			idtable[3][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderPoleArm"..(5-math.ceil(gvDiffLVL))], 0, 8/math.ceil(gvDiffLVL), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[3][k], 12686, 15291)
		end
	end
	do
		local pos = GetPosition("guard_gate7")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderCavalry"..(3-math.ceil(gvDiffLVL))], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	do
		local pos = GetPosition("guard_gate8")
		for k = 1,(4-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderRifle"..(3-math.ceil(gvDiffLVL))], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderCavalry"..(3-math.ceil(gvDiffLVL))], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	do
		local pos = GetPosition("guard_gate9")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderBow"..(5-math.ceil(gvDiffLVL))], 0, (8/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderCavalry"..(3-math.ceil(gvDiffLVL))], 0, (6/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[2][k])
		end
	end
	---
	do
		local pos = GetPosition("ev_spawn2")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, Entities.CU_Evil_LeaderBearman1, 0, (16/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[1][k], 3800, 5590)
		end
	end
	do
		local pos = GetPosition("ev_spawn3")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, Entities.CU_Evil_LeaderSkirmisher1, 0, (16/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = GetPosition("ev_spawn4")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, Entities.CU_Evil_LeaderSkirmisher1, 0, (16/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
			idtable[2][k] = AI.Entity_CreateFormation(7, Entities.CU_Evil_LeaderBearman1, 0, (16/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupPatrol(idtable[2][k], 2900, 14400)
		end
	end
	do
		local pos = GetPosition("ev_spawn7")
		for k = 1,(3-math.ceil(gvDiffLVL)) do
			idtable[1][k] = AI.Entity_CreateFormation(7, Entities.CU_Evil_LeaderSkirmisher1, 0, (16/math.ceil(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	Mission_InitTechnologies()

	local mercenaryId1 = Logic.GetEntityIDByName("merchant")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Serf, 4 + round(gvDiffLVL), ResourceType.Gold, round(500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Scout, 2 + round(gvDiffLVL), ResourceType.Gold, round(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Thief, 4 * round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))

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

	SetPlayerName(3, "Kafarnas Getreue")
	SetPlayerName(7, "Nebelvolk")
	SetPlayerName(8, "Kafarna")

	Display.SetPlayerColorMapping(3,2)
	Display.SetPlayerColorMapping(6,11)
	Display.SetPlayerColorMapping(7,3)
	Display.SetPlayerColorMapping(8,2)

	SetFriendly(1,6)
	SetFriendly(2,6)
	if not CNetwork then
		Display.SetPlayerColorMapping(2,math.random(3,16))
	end
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

function DefeatTimer()

	Message("Ihr habt es nicht geschafft, alle Feinde innerhalb von ".. round(TimeLimit/60) .." Minuten zu besiegen... @cr Versucht es erneut!")
	Defeat()

end
function DefeatJob()
	local t1,t2 = {},{}
	Logic.GetHeroes(1, t1)
	Logic.GetHeroes(2, t2)
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + table.getn(t1) + table.getn(t2)) == 0 then
		Defeat()
		return true
	end
end
function VictoryJob()

	if (AI.Player_GetNumberOfLeaders(3) + AI.Player_GetNumberOfLeaders(8)) == 0 and (Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Headquarters3) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Barracks2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Archery2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(8, Entities.PB_Tower3) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(7, Entities.CB_Evil_Tower1)) == 0 then
		if CNetwork then
			if gvChallengeFlag and GUI.GetPlayerID() ~= 17 then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map2_won", 2)
				end
			end
		end
		Victory()
		return true
	end

end
function AIIncreaseAggressiveness()

	MapEditor_Armies[8].offensiveArmies.rodeLength	=	7500
	MapEditor_Armies[8].offensiveArmies.strength	=	MapEditor_Armies[8].offensiveArmies.strength + round(8/gvDiffLVL)

end
function AreaCheck1()

	local count = 0
	for i = 1,2 do
		if ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon1, 19200, 16500, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon2, 19200, 16500, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon3, 19200, 16500, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Cannon4, 19200, 16500, 1000, 1)})[1] > 0 or ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Catapult, 19200, 16500, 1500, 1)})[1] > 0 then
			count = count + 1
		end
	end
	if count > 0 then
		local army	 = {}

		army.player 	= 8
		army.id			= 0
		army.strength	= 5-math.ceil(gvDiffLVL)
		army.position	= {X = 20600, Y = 26700}
		army.rodeLength	= Logic.WorldGetSize()

		SetupArmy(army)

		local troopDescription = {

			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]},
			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]}
		}

		for i = 1,army.strength do
			EnlargeArmy(army,troopDescription[math.random(1,2)])
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
		--[[for i = 1,(5-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 20600, 26700, 0, 1, 4-math.ceil(gvDiffLVL), 0), 19200, 16500)
		end]]
		return true
	end
end
function AreaCheck2()

	local count = 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerFilter(), CEntityIterator.InCircleFilter(11000, 11800, 1000)) do
		count = count + 1
	end
	if count > 0 then
		local army	 = {}

		army.player 	= 8
		army.id			= 1
		army.strength	= 8-math.ceil(gvDiffLVL)
		army.position	= {X = 20600, Y = 26700}
		army.rodeLength	= Logic.WorldGetSize()

		SetupArmy(army)

		local troopDescription = {

			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]},
			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]}
		}

		for i = 1,army.strength do
			EnlargeArmy(army,troopDescription[math.random(1,2)])
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
		--[[for i = 1,(6-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 20600, 26700, 0, 1, 4-math.ceil(gvDiffLVL), 0), 11000, 11800)
			Logic.GroupAttackMove(AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 6/math.min(math.ceil(gvDiffLVL),2), 20600, 26700, 0, 1, 4-math.ceil(gvDiffLVL), 0), 11000, 11800)
		end]]
		return true
	end
end
function AreaCheck3()

	local count = 0
	for i = 1,2 do
		if ({Logic.GetPlayerEntitiesInArea(i, Entities.PV_Catapult, 14000, 23500, 1500, 1)})[1] > 0 then
			count = count + 1
		end
	end
	if count > 0 then
		local army	 = {}

		army.player 	= 8
		army.id			= 2
		army.strength	= 4-math.ceil(gvDiffLVL)
		army.position	= {X = 17500, Y = 27800}
		army.rodeLength	= Logic.WorldGetSize()

		SetupArmy(army)

		local troopDescription = {

			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]},
			{experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = Entities["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)]}
		}

		for i = 1,army.strength do
			EnlargeArmy(army,troopDescription[math.random(1,2)])
		end

		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
		--[[for i = 1,(4-math.ceil(gvDiffLVL)) do
			Logic.GroupAttackMove(AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderHeavyCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 3, 17500, 27800, 0, 1, 4-math.ceil(gvDiffLVL), 0), 8800, 21900)
			Logic.GroupAttackMove(AI.Entity_CreateFormation(3, _G["Entities"]["PU_LeaderCavalry".. 3 - math.min(math.ceil(gvDiffLVL),2)], 0, 6, 17500, 27800, 0, 1, 4-math.ceil(gvDiffLVL), 0), 8800, 21900)
		end]]
		return true
	end
end
function ControlArmies(_player, _id)

    if IsDead(ArmyTable[_player][_id + 1]) then
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
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

end
----------------------------------------------------------------------------------------------------------
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

end   