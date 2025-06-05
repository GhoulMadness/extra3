--------------------------------------------------------------------------------
-- MapName: (2) Erste Prüfung
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
sub_armies_aggressive = 0
main_armies_aggressive = 0
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Erste Prüfung - Kampfgeschick "
gvMapVersion = " v1.0 "
AttackTarget = {X = 20800,
				Y = 7900}
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	Logic.SetPlayerName(3, "Invasoren")

	-- custom Map Stuff
	TagNachtZyklus(24,1,1,-2,1)
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

	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()
	TributeP1_Challenge()
	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
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
	LocalMusic.UseSet = DARKMOORMUSIC
	ActivateBriefingsExpansion()
	StartCountdown(1,AnfangsBriefing,false)

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
	gvDiffLVL = 2.4

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
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 2.0

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
	gvDiffLVL = 1.6

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
	gvDiffLVL = 1.3
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
	-- if spectator pauses the game before tribute is payed, he gets a desync. So always wait for the tribute to be paid
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
	AI.Player_EnableAi(3)
	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2},Diplomacy.Hostile)
		SetFriendly(1,2)
	else
		SetHostile(1,3)
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

	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "AntiSpawnCampTrigger", 1)

	StartSimpleJob("KillScoreBonus1")

	StartSimpleJob("DefeatJob")

	StartSimpleJob("AIIdleScan")
	StartCountdown(10*60*gvDiffLVL,UpgradeKIa,false)
	StartCountdown(1*60*gvDiffLVL,TroopSpawnVorb,false)
	StartCountdown(60*60,VictoryTimer,true)

	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end

	local tab = ChestRandomPositions.CreateChests(10)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function DefeatJob()
	if (Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters1) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters2) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Headquarters3)) < 2 then
		Defeat()
		return true
	end
end
function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.min(math.floor(2.0+(math.random(1,5)/10)*60*gvDiffLVL*(1+(Logic.GetTime()/40))),6*60/math.sqrt(gvDiffLVL))
	if AI.Player_GetNumberOfLeaders(3)	<= (150/gvDiffLVL) then
		TroopSpawn(TimePassed)
		SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
	else
		SpawnCounter = StartCountdown(TimeNeeded/2,TroopSpawnVorb,false)
	end
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
	Message("Weitere Feinde versammeln sich!")
	--local type1,type2,type3,type4
	for i = 1,8 do
		if _TimePassed <= 6 then
			CreateAttackingArmies("top", i, 1)
			CreateAttackingArmies("bot", i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies("top", i, 2)
			CreateAttackingArmies("bot", i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 22 then
			CreateAttackingArmies("top", i, 3)
			CreateAttackingArmies("bot", i, 3)

		elseif _TimePassed > 22 and _TimePassed <= 35 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("top", i, 4)
			CreateAttackingArmies("bot", i, 4)

		elseif _TimePassed > 35 and _TimePassed <= 45 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("top", i, 5)
			CreateAttackingArmies("bot", i, 5)

		elseif _TimePassed > 45 then
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

function CreateAttackingArmies(_name, _poscount, _index)
	local army	= {}
    army.player = 3
    army.id	  	= GetFirstFreeArmySlot(3)
    army.strength = table.getn(armytroops[_index])
    army.position = GetPosition(_name .."_".. _poscount)
    army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)

	for i = 1, army.strength do
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = armytroops[_index][i]
		EnlargeArmy(army, troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.id})

end
function ControlArmies(_id)

    if IsDead(ArmyTable[3][_id + 1]) then
		return true
    else
		Defend(ArmyTable[3][_id + 1])
    end
end

function AIIdleScan()
	if Counter.Tick2("IdleScan_Ticker",10) then
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(3), CEntityIterator.OfCategoryFilter(EntityCategories.Leader)) do
			if Logic.GetCurrentTaskList(eID) == "TL_MILITARY_IDLE" then
				Logic.GroupAttackMove(eID, AttackTarget.X, AttackTarget.Y)
			end
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(3), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
			if Logic.GetCurrentTaskList(eID) == "TL_VEHICLE_IDLE" then
				Logic.GroupAttackMove(eID, AttackTarget.X, AttackTarget.Y)
			end
		end
	end
end

function KillScoreBonus1()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 1500/gvDiffLVL then
		Message("Weitere Technologien sind nun verfügbar!")
		for i = 1,2 do
			Logic.SetTechnologyState(i,Technologies.GT_Construction,3)
			Logic.SetTechnologyState(i,Technologies.GT_Alchemy,3)
			Logic.SetTechnologyState(i,Technologies.GT_Taxation,3)
			Logic.SetTechnologyState(i,Technologies.GT_Mercenaries,3)
		end
		StartSimpleJob("KillScoreBonus2")
		return true
	end
end
function KillScoreBonus2()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 3000/gvDiffLVL then
		Message("Weitere Technologien sind nun verfügbar!")
		for i = 1,2 do
			Logic.SetTechnologyState(i,Technologies.GT_StandingArmy,3)
			Logic.SetTechnologyState(i,Technologies.GT_Tactics,3)
			Logic.SetTechnologyState(i,Technologies.GT_Matchlock,3)
			Logic.SetTechnologyState(i,Technologies.GT_GearWheel,3)
			Logic.SetTechnologyState(i,Technologies.GT_Alloying,3)
			Logic.SetTechnologyState(i,Technologies.GT_Trading,3)
		end
		StartSimpleJob("KillScoreBonus3")
		return true
	end
end
function KillScoreBonus3()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 4500/gvDiffLVL then
		Message("Weitere Technologien sind nun verfügbar!")
		for i = 1,2 do
			Logic.SetTechnologyState(i,Technologies.GT_Banking,3)
			Logic.SetTechnologyState(i,Technologies.GT_Printing,3)
			Logic.SetTechnologyState(i,Technologies.GT_ChainBlock,3)
		end
		StartSimpleJob("KillScoreBonus4")
		return true
	end
end
function KillScoreBonus4()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 6500/gvDiffLVL then
		Message("Weitere Technologien sind nun verfügbar!")
		for i = 1,2 do
			Logic.SetTechnologyState(i,Technologies.GT_Laws,3)
			Logic.SetTechnologyState(i,Technologies.GT_Strategies,3)
			Logic.SetTechnologyState(i,Technologies.GT_Metallurgy,3)
			Logic.SetTechnologyState(i,Technologies.GT_PulledBarrel,3)
		end
		StartSimpleJob("KillScoreBonus5")
		return true
	end
end
function KillScoreBonus5()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 10000/gvDiffLVL then
		Message("Weitere Technologien sind nun verfügbar!")
		for i = 1,2 do
			Logic.SetTechnologyState(i,Technologies.GT_Chemistry,3)
			Logic.SetTechnologyState(i,Technologies.GT_Gilds,3)
			Logic.SetTechnologyState(i,Technologies.GT_Architecture,3)
			Logic.SetTechnologyState(i,Technologies.GT_Library,3)
		end
		StartSimpleJob("KillScoreBonus6")
		return true
	end
end
function KillScoreBonus6()
	if Score.GetPlayerScore(1, "battle") + Score.GetPlayerScore(2, "battle") >= 21000/gvDiffLVL then
		Message("Die besten Technologien sind nun verfügbar!")
		for i = 1,2 do
			ResearchTechnology(Technologies.T_SilverSwords,1)
			ResearchTechnology(Technologies.T_SilverBullets,1)
			ResearchTechnology(Technologies.T_SilverMissiles,1)
			ResearchTechnology(Technologies.T_SilverPlateArmor,1)
			ResearchTechnology(Technologies.T_SilverArcherArmor,1)
			ResearchTechnology(Technologies.T_SilverArrows,1)
			ResearchTechnology(Technologies.T_SilverLance,1)
			ResearchTechnology(Technologies.T_BloodRush,1)
		end
		return true
	end
end


function UpgradeKIa()
	for i = 3,16 do
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
	for i = 3,16 do
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
	for i = 3,16 do

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
        text	= "@color:230,0,0 Gut euch zu sehen, mein Herr. @cr Eine wahrlich düstere Gegend, in die Ihr Euch da begeben habt.",
		position = GetPosition("archers")
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Unzählige Feinde werden versuchen, Euch aus dieser Gegend zu vertreiben.",
		position = GetPosition("melee")

    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Kämpft geschickt und verteidigt Eure Burgen! @cr Haltet ihr lange genug durch, wird die Verstärkung aus den Nachbarsiedlungen eintreffen und Eure Feinde vernichten.",
		position = GetPlayerStartPosition()

    }

    StartBriefing(briefing)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	if CNetwork then
		do
			local pos = GetPosition("archers")
			for k = 1,(2+math.ceil(gvDiffLVL)) do
				for i = 1,2 do
					AI.Entity_CreateFormation(i, Entities.PU_LeaderBow2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
					AI.Entity_CreateFormation(i, Entities.PU_LeaderRifle1, 0, 3, pos.X, pos.Y, 0, 1,3,0)
				end
			end
		end
		do
			local pos = GetPosition("melee")
			for k = 1,(4+math.ceil(gvDiffLVL)) do
				for i = 1,2 do
					AI.Entity_CreateFormation(i, Entities.PU_LeaderSword2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
					AI.Entity_CreateFormation(i, Entities.PU_LeaderPoleArm2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
				end
			end
		end
	else
		do
			local pos = GetPosition("archers")
			for i = 1,((2+math.ceil(gvDiffLVL))*2) do
				AI.Entity_CreateFormation(1, Entities.PU_LeaderBow2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
				AI.Entity_CreateFormation(1, Entities.PU_LeaderRifle1, 0, 3, pos.X, pos.Y, 0, 1,3,0)
			end
		end
		do
			local pos = GetPosition("melee")
			for i = 1,((4+math.ceil(gvDiffLVL))*2) do
				AI.Entity_CreateFormation(1, Entities.PU_LeaderSword2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
				AI.Entity_CreateFormation(1, Entities.PU_LeaderPoleArm2, 0, 4, pos.X, pos.Y, 0, 1,3,0)
			end
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

	for i = 3,16 do
		Display.SetPlayerColorMapping(i,2)
	end
	if not CNetwork then
		Display.SetPlayerColorMapping(2,math.random(3,16))
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function
Mission_InitTechnologies()

end

function StartTechnologies()
	for i = 1,2 do
		ResearchTechnology(Technologies.GT_Literacy,i)
		ResearchTechnology(Technologies.B_Lighthouse,i)
		--
		ForbidTechnology(Technologies.B_University,i)
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function
Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= math.floor(2000*(math.sqrt(gvDiffLVL)))
	local InitClayRaw 		= math.floor(1600*(math.sqrt(gvDiffLVL)))
	local InitWoodRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitStoneRaw 		= math.floor(1500*(math.sqrt(gvDiffLVL)))
	local InitIronRaw 		= math.floor(800*(math.sqrt(gvDiffLVL)))
	local InitSulfurRaw		= math.floor(500*(math.sqrt(gvDiffLVL)))


	--Add Players Resources
	local i
	for i=1,8,1
	do

		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end

function VictoryTimer()

	StopCountdown(SpawnCounter)
	StartSimpleJob("VictoryJob")
	Message("Hervorragend! Ihr habt Euch 60 Minuten lang behaupten können. @cr Besiegt nun alle restlichen Feinde, um die Karte zu gewinnen!")

end

function VictoryJob()

	if AI.Player_GetNumberOfLeaders(3) == 0 then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map1_won", 2)
				end
			end
		end
		Victory()
		return true
	end

end

function AntiSpawnCampTrigger()

	local attacker = Event.GetEntityID1()
    local target = Event.GetEntityID2()
	local targetpos = GetPosition(target)
	local pID = GetPlayer(target)

	if pID == 3 then
		for i = 1,8 do
			if math.abs(GetDistance(targetpos,GetPosition("top_"..i))) <= 2000 or math.abs(GetDistance(targetpos,GetPosition("bot_"..i))) <= 2000 then
				CEntity.TriggerSetDamage(0);
			end
		end
	end

end;

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
		action = function ()Display.SetRenderFogOfWar(0) end
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

end  