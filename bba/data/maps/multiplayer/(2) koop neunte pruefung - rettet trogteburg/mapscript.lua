
--------------------------------------------------------------------------------
-- MapName: Neunte Prüfung - Rettet Trogteburg
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Neunte Prüfung - Rettet Trogteburg "
gvMapVersion = " v1.1 "
InvasorPID = 2

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	if CNetwork then
		InvasorPID = 9
		TributePID = 2
		Logic.ChangeAllEntitiesPlayerID(2, InvasorPID)
		ChangePlayer("vet", 2)
	else
		ChangePlayer("vet", 1)
		TributePID = 1
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
	--MultiplayerTools.GiveBuyableHerosToHumanPlayer(3)
	gvDiffLVL = 3.0

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
		ResearchTechnology(Technologies.T_HeroicShoes, i)
	end
	ResearchTechnology(Technologies.T_SoftArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherMailArmor,8)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks,8)
	ResearchTechnology(Technologies.T_BetterTrainingArchery,8)
	ResearchTechnology(Technologies.T_Shoeing,8)
	ResearchTechnology(Technologies.T_BetterChassis,8)
	ResearchTechnology(Technologies.T_WoodAging,8)
	ResearchTechnology(Technologies.T_Turnery,8)
	ResearchTechnology(Technologies.T_MasterOfSmithery,8)
	ResearchTechnology(Technologies.T_IronCasting,8)
	ResearchTechnology(Technologies.T_Fletching,8)
	ResearchTechnology(Technologies.T_BodkinArrow,8)
	ResearchTechnology(Technologies.T_EnhancedGunPowder,8)
	ResearchTechnology(Technologies.T_BlisteringCannonballs,8)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,8)
	ResearchTechnology(Technologies.T_ChainMailArmor,8)
	ResearchTechnology(Technologies.T_PlateMailArmor,8)
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
	--MultiplayerTools.GiveBuyableHerosToHumanPlayer(2)
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
	for i = 1,2 do
		ResearchTechnology(Technologies.T_HeroicShoes, i)
	end
	ResearchTechnology(Technologies.T_SoftArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherMailArmor,8)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks,8)
	ResearchTechnology(Technologies.T_BetterTrainingArchery,8)
	ResearchTechnology(Technologies.T_Shoeing,8)
	ResearchTechnology(Technologies.T_BetterChassis,8)
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
	--MultiplayerTools.GiveBuyableHerosToHumanPlayer(1)
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
	for i = 1,2 do
		ResearchTechnology(Technologies.T_HeroicShoes, i)
	end
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
	--MultiplayerTools.GiveBuyableHerosToHumanPlayer(1)
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
	for i = 1, 2 do
		ForbidTechnology(Technologies.B_Dome, i)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(3,"Himendorf")
	SetPlayerName(4,"Burghausen")
	SetPlayerName(5,"Reiterhusen")
	SetPlayerName(6,"Kleinsuhlendorf")
	SetPlayerName(7,"Swammheim")
	SetPlayerName(8,"Trogteburg")
	SetNeutral(1,3)
	SetNeutral(1,4)
	SetNeutral(1,5)
	SetNeutral(1,6)
	SetNeutral(1,7)
	--
	Display.SetPlayerColorMapping(InvasorPID,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(3,FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(4,ENEMY_COLOR2)
	Display.SetPlayerColorMapping(5,NPC_COLOR)
	Display.SetPlayerColorMapping(6,FRIENDLY_COLOR1)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function Mission_InitLocalResources()
    -- set some resources
    AddGold  (0)
    AddSulfur(0)
    AddIron  (0)
    AddWood  (0)
    AddStone (0)
    AddClay  (0)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
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
end

function StartInitialize()
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero2", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero5", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero9", 0)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})

	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2}, Diplomacy.Neutral)
		SetFriendly(1,2)
	else
		SetHumanPlayerDiplomacyToAllAIs({1}, Diplomacy.Neutral)
	end
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf, i)
		AllowTechnology(Technologies.T_Tracking, i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	Mission_InitGroups()
	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end
	Merchant()
	Hauptaufgabe()
	Beeildich = StartCountdown((6.5+gvDiffLVL)*60,Zulangsam,true)
	FarbigeNamen()
	StartSimpleJob("NPCControl")
	EnableNpcMarker(GetEntityId("Scout"))
end
function FarbigeNamen()
	orange 	= "@color:255,127,0"
	lila 	= "@color:250,0,240"

    QB      = ""..orange.." Quest - Beschreibung "..lila..""
    Mj3     = ""..orange.." Kommandant von Himendorf "..lila..""
    Mj4     = ""..orange.." Major von Burghausen "..lila..""
    Mj5     = ""..orange.." Schutzherr von Reiterhusen "..lila..""
    Mj6     = ""..orange.." Gauner von Kleinsuhlendorf "..lila..""
    Mj7     = ""..orange.." Prinzesssin von Swammheim "..lila..""
    Mj8     = ""..orange.." Bürgermeister von Trogteburg "..lila..""
    Chief   = ""..orange.." Kommandant der Armee von Trogteburg "..lila..""
    Ari     = ""..orange.." Ari "..lila..""
    men     = ""..orange.." Mentor "..lila..""
    Sc      = ""..orange.." Kundschafter "..lila..""
    Leo     = ""..orange.." Wetterforscher "..lila..""
    Tr1     = ""..orange.." Händler "..lila..""
    Tr2     = ""..orange.." Händler "..lila..""
    Cannon  = ""..orange.." Meistermechanikus "..lila..""
    Cavalry = ""..orange.." Befehlshaber der Kavallerie "..lila..""
    Monk    = ""..orange.." Verängstigter Mönch "..lila..""
	farmer 	= ""..orange.." Geselliger Bauer "..lila..""
	herm 	= ""..orange.." Schräger Kauz "..lila..""
	miner 	= ""..orange.." Minenarbeiter "..lila..""
	burner 	= ""..orange.." Köhlergeselle "..lila..""
	pilg 	= ""..orange.." Pilgrim "..lila..""
	wman 	= ""..orange.." Weiser aus den Grenzlanden "..lila..""
	cplan	= ""..orange.." Leifsson, Städteplaner von Trogteburg "..lila..""
	coin 	= ""..orange.." Verwalter der Schatzkammer "..lila..""
	joh		= ""..orange.." Bruder Johannes "..lila..""
	sgu		= ""..orange.." Schutzherr der geheiligten Statue "..lila..""

end
NPCs = {["Scout"] = {true, "Scout"},
		["MajorP8"] = {false, "MajorP8"},
		["Chief"] = {false, "Chef"},
		["MajorP3"] = {false, "MajorP3"},
		["MajorP4"] = {false, "MajorP4"},
		["MajorP5"] = {false, "MajorP5"},
		["MajorP6"] = {false, "MajorP6"},
		["MajorP7"] = {false, "MajorP7"},
		["Farmer"] = {false, "Farmer"},
		["Farmer2"] = {false, "Farmer2"},
		["Hermit"] = {false, "Hermit"},
		["LeoSerf"] = {false, "LeoSerf"},
		["Trader1"] = {false, "Trader1"},
		["Trader2"] = {false, "Trader2"},
		["Trader3"] = {false, "Trader3"},
		["Trader4"] = {false, "Trader4"},
		["Monk"] = {false, "Moench"},
		["Monk2"] = {false, "Monk2"},
		["Miner"] = {false, "Miner"},
		["Miner2"] = {false, "Miner2"},
		["CannonTrader"] = {false, "CannonTrader"},
		["Cavalry"] = {false, "Reiter"},
		["settler"] = {false, "Settler"},
		["Pilgrim"] = {false, "Pilgrim"},
		["wiseman"] = {false, "wiseman"},
		["Planner"] = {false, "Planner"},
		["coiner"] = {false, "coiner"},
		["johannes"] = {false, "johannes"},
		["statue_guard"] = {false, "SGuard"}
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
function Mission_InitGroups()
	--[[
	for i = 1, 23 do
		CreateMilitaryGroup(InvasorPID,Entities.CU_BanditLeaderSword2,8,GetPosition("Bandit"..i))
		--
		CreateMilitaryGroup(InvasorPID,Entities.CU_BanditLeaderBow1,10,GetPosition("Bandit"..i))
		--
		CreateMilitaryGroup(InvasorPID,Entities.CU_Barbarian_LeaderClub2,10,GetPosition("Bandit"..i))
	end]]
	SetHostile(1, InvasorPID)
	if CNetwork then
		SetHostile(2, InvasorPID)
	end
	local army	 = {}
	army.player 	= InvasorPID
	army.id			= GetFirstFreeArmySlot(InvasorPID)
	army.strength	= round(2/gvDiffLVL)
	army.position	= GetPosition("GoldChest12")
	army.rodeLength	= 3000

	SetupArmy(army)

	local troopDescription = {

		maxNumberOfSoldiers	= round(9-gvDiffLVL),
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderSword2
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})

	local army	 = {}
	army.player 	= InvasorPID
	army.id			= GetFirstFreeArmySlot(InvasorPID)
	army.strength	= round(3/gvDiffLVL)
	army.position	= {X = 44000, Y = 13300}
	army.rodeLength	= 3000

	SetupArmy(army)

	local troopDescription = {

		maxNumberOfSoldiers	= round(8/math.sqrt(gvDiffLVL)),
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderSword2
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})
end

function Hauptaufgabe()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"@color:20,255,50 Missionsziele","@color:20,255,50 Redet mit dem Bürgermeister von Trogteburg. Es scheint sehr wichtig zu sein, beeilt euch!  ",1)
	Logic.AddQuest(2,1,MAINQUEST_OPEN,"@color:20,255,50 Missionsziele","@color:20,255,50 Redet mit dem Bürgermeister von Trogteburg. Es scheint sehr wichtig zu sein, beeilt euch!  ",1)
end
function AnfangsBriefing()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Ari",men,"@color:230,0,0 Ari reist durch eine europäische Landschaft. Sie erhielt einen Auftrag von Dario, dort mal nach dem Rechten zu sehen.", false)
	ASP("Trogteburg",QB,"@color:230,0,0 Die Stadt Trogteburg, die hier ganz in der Nähe liegt, fragte im Königreich nach Hilfe, sie hätten Probleme, die sie nicht alleine lösen könnten.", false)
	ASP("Ari",Ari,"@color:230,0,0 Dario sagte mir, dass sie gezielt nach mir verlangt haben. Ich frage mich nur, wieso.", false)
	ASP("Ari",Ari,"@color:230,0,0 Ich sollte wohl möglichst schnell den Bürgermeister von Trogteburg aufsuchen.", false)

	briefing.finished = function()
		Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
		TributeP1_Easy()
		TributeP1_Normal()
		TributeP1_Hard()
		TributeP1_Challenge()
	end
    StartBriefing(briefing)
end
function Scout()

	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Ari",Ari,"@color:20,255,50 Guten Tag. Ich suche nach dem Bürgermeister von Trogteburg, weiß aber noch nicht genau, wo ich ihn finden kann.", true)
	ASP("Ari",Ari,"@color:20,255,50 Könntet ihr mir weiterhelfen?", true)
	ASP("Scout",Sc,"@color:20,255,50 Ahh, ihr müsst Ari sein. Wir hofften, dass ihr kommt. Der Bürgermeister ist in letzter Zeit sehr bedrückt.", true)
	ASP("Scout",Sc,"@color:20,255,50 Natürlich kann ich euch sagen, wo er sich befindet. Er ist immer in der Nähe der Zitadelle von Trogteburg.", false)
	AP{
		title = Sc,
		text = "@color:20,255,50 Die liegt da oben. Wartet einen Moment, ich gebe euch eine Karte mit, auf der sie eingezeichnet ist.",
		position = GetPosition("P8Burg"),
		dialogCamera = false,
		}

	ASP("Scout",Sc,"@color:20,255,50 Und jetzt beeilt euch, es scheint wirklich sehr wichtig zu sein.", false)
	ASP("Ari",Ari,"@color:20,255,50 Ist gut, ich bin schon auf dem Weg.", true)

    briefing.finished = function()
		GUI.CreateMinimapPulse(37292,45632,2)
		NPCs.MajorP8[1] = true
		EnableNpcMarker(GetEntityId("MajorP8"))
  	end
	StartBriefing(briefing)
end
function Zulangsam()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Ari",men,"@color:20,255,50 Ihr habt euch zu viel Zeit gelassen...", false)
	ASP("Ari",men,"@color:20,255,50 Versucht es erneut und beeilt euch!", true)
  	briefing.finished = function()
		Defeat()
	end
	StartBriefing(briefing)
end
function MajorP8()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP8",Mj8,"@color:20,255,50 Ari, gut euch zu sehen, ich habe euch bereits erwartet.", true)
	ASP("Ari",Ari,"@color:20,255,50 Ich habe mich so schnell wie nur möglcih auf den Weg gemacht. Worum geht es, was bedrückt euch?", true)
	ASP("MajorP8",Mj8,"@color:20,255,50 Hier ringsum haben sich Banditen breit gemacht. Ihre Lager liegen in fast allen Himmelsrichtungen von hier.", true)
	ASP("MajorP8",Mj8,"@color:20,255,50 Meine Kundschafter haben berichtet, dass sie sich sammeln würden und auf einen baldigen Krieg einstellen würde. Mit meiner schönen Stadt, nehme ich an.", false)
	ASP("Ari",Ari,"@color:20,255,50 So weit ich das beurteilen kann, ist die Stadt doch riesig und hervorragend geschützt. Ihr könntet die Banditen problemlos alleine in die Schranken weisen.", true)
	ASP("MajorP8",Mj8,"@color:20,255,50 Ich weiß Ari. Das weitaus größere Problem liegt darin, dass die insgesamt fünf umliegenden Dörfer und Städte nicht grade unsere Freunde sind, und wir befürchten, dass sie uns auch angreifen werden, wenn die Banditen uns angreifen.", false)

	AP{
		title = Mj8,
		text = "@color:20,255,50 Aber redet für Einzelheiten mit dem Kommandanten der hiesigen Armee. Ich kenne die Gegend hier zwar gut, kann euch aber nichts zu den militärischen Gegebenheiten erzählen.",
		position = GetPosition("Chief"),
		dialogCamera = false,
		}

    briefing.finished = function()
		StopCountdown(Beeildich)
		StartSimpleJob("DelayedAction1")
		NPCs.Chief[1] = true
		GUI.CreateMinimapPulse(42028,27338,2)
		GUI.DestroyMinimapPulse(37292,45632)
		EnableNpcMarker(GetEntityId("Chief"))
		Logic.RemoveQuest(1,1)
		Logic.RemoveQuest(2,1)
		Logic.AddQuest(1,2,MAINQUEST_OPEN,"@color:20,255,50 Ernste Lage","@color:20,255,50 Redet mit dem Kommandanten Trogteburgs und besprecht mit ihm den Ernst der Lage!  ",1)
		Logic.AddQuest(2,2,MAINQUEST_OPEN,"@color:20,255,50 Ernste Lage","@color:20,255,50 Redet mit dem Kommandanten Trogteburgs und besprecht mit ihm den Ernst der Lage!  ",1)
  	end
	StartBriefing(briefing)
end
function DelayedAction1()
	Beeildich = StartCountdown(2*60*gvDiffLVL,Zulangsam,true)
	return true
end
function Chef()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Ari",Ari,"@color:20,255,50 Guten Tag. Der Bürgermeister erzählte mir, dass ihr mir Einzelheiten zu der militärischen Lage erzählen könntet.", true)
	ASP("Chief",Chief,"@color:20,255,50 Korrekt. Ich bin der Kommandant hier und befehlige die Truppen.", false)
	ASP("Trogteburg",Chief,"@color:20,255,50 Wir sind bestens gerüstet, aber gegen eine große Übermacht können auch wir nichts machen.", false)
	ASP("Chief",Chief,"@color:20,255,50 Der Bürgermeister hat euch ja bestimmt bereits erzählt, dass die umliegenden Dörfer im Kriegesfall mit den Banditen uns in den Rücken fallen könnten.", false)
	ASP("Chief",Chief,"@color:20,255,50 Und dann wären wir erledigt. Geht doch bitte zu den Bürgermeistern der Dörfer und Städte und versucht sie mit allen möglichen Mitteln auf unsere Seite zu ziehen.", false)
	ASP("Chief",Chief,"@color:20,255,50 Je mehr Städte ihr auf unsere Seite ziehen könnt, desto höher die Chancen für Trogteburg, die Schlacht siegreich zu überstehen.", false)
	ASP("P1Burg",Chief,"@color:20,255,50 Bezieht solange unseren Außenposten im unteren Stadtbezirk Trogteburgs.", false)
	ASP("Chief",Chief,"@color:20,255,50 Ihr werdet nicht viel Zeit haben, bis die Banditen angreifen. Beeilt euch! Viel Glück!", false)

    briefing.finished = function()
		StopCountdown(Beeildich)
		Siedelanfang()
		GUI.DestroyMinimapPulse(42028,27338)
		DestroyEntity("Sperre")
		StartSimpleJob("DelayedAction2")
	end
	StartBriefing(briefing)
end
function DelayedAction2()
	StartCountdown((17+15*gvDiffLVL)*60,BanditAngriff,true)
	StartCountdown((17+15*gvDiffLVL)*60*0.8, AIPrepare, false)
	StartCountdown(8*60,ExtraBriefing1,false)
	StartCountdown(12*60,ExtraBriefing2,false)
	StartCountdown(16*60,ExtraBriefing3,false)
	StartCountdown(20*60,ExtraBriefing4,false)
	StartCountdown(24*60,ExtraBriefing5,false)
	StartCountdown(28*60,ExtraBriefing6,false)
	StartCountdown(32*60,ExtraBriefing7,false)
	return true
end
function AIPrepare()
	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(3, 3, 76800, 2, "3", 3, 0)
	SetupPlayerAi( 3, { serfLimit = 4, extracting = 1, constructing = false, repairing = false } )
	MapEditor_SetupAI(4, 3, 76800, 3, "4", 3, 0)
	SetupPlayerAi( 4, { serfLimit = 6, extracting = 1, constructing = true, repairing = true } )
	MapEditor_SetupAI(5, 3, 76800, 3, "5", 3, 0)
	SetupPlayerAi( 5, { serfLimit = 7, extracting = 1, constructing = true, repairing = true } )
	MapEditor_SetupAI(6, 3, 76800, 3, "6", 3, 0)
	SetupPlayerAi( 6, { serfLimit = 8, extracting = 1, constructing = true, repairing = true } )
	MapEditor_SetupAI(7, 3, 76800, 3, "7", 3, 0)
	SetupPlayerAi( 7, { serfLimit = 9, extracting = 1, constructing = true, repairing = true } )
	for i = 4, 5 do
		MapEditor_Armies[i].offensiveArmies.strength = 18
		MapEditor_Armies[i].defensiveArmies.strength = 5
	end
	MapEditor_Armies[3].offensiveArmies.strength = 10
	MapEditor_Armies[3].defensiveArmies.strength = 2
	for i = 6,7 do
		MapEditor_Armies[i].offensiveArmies.strength = 12
		MapEditor_Armies[i].defensiveArmies.strength = 3
	end
	if CNetwork then
		SetHumanPlayerDiplomacyToAllAIs({1,2}, Diplomacy.Neutral)
		SetFriendly(1,2)
	else
		SetHumanPlayerDiplomacyToAllAIs({1}, Diplomacy.Neutral)
	end
end
function BanditAngriff()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP8",Mj8,"@color:230,0,0 Ohhwei die Zeit ist vorüber und die Banditen greifen schon in Kürze an.", true)
	ASP("MajorP8",Mj8,"@color:230,0,0 Hoffentlich seid ihr vorbereitet und habt die Zeit gut genutzt, um die umliegenden Dörfer auf unsere Seite zu ziehen!", false)
  	briefing.finished = function()
		AttackPrepare()
	end
	StartBriefing(briefing)
end

function AttackPrepare()
	for i = 1,8 do
		Logic.DestroyEffect(_G["Gebietsmarker"..i])
	end
	ActivateShareExploration(1,8,true)
	if CNetwork then
		ActivateShareExploration(2,8,true)
	end
	DiplomacyCheck()
	for i = 1,30 do
		DestroyEntity("Rock"..i)
	end
	ReplaceEntity("BarbarenGate",Entities.XD_PalisadeGate2)
	--
	Logic.AddQuest(1,9,MAINQUEST_OPEN,"@color:20,255,50 Angriff der Barbaren","@color:20,255,50 Die Barbaren greifen an! Verteidigt Trogteburg und eure Siedlung und vernichtet die Lager der Barbaren!",1)
	Logic.AddQuest(2,9,MAINQUEST_OPEN,"@color:20,255,50 Angriff der Barbaren","@color:20,255,50 Die Barbaren greifen an! Verteidigt Trogteburg und eure Siedlung und vernichtet die Lager der Barbaren!",1)
	Logic.RemoveQuest(1,3)
	Logic.RemoveQuest(2,3)
	GUI.CreateMinimapMarker(37292,45632,2)
	for i = 3, 8 do
		NPCs["MajorP"..i][1] = false
		DisableNpcMarker(GetEntityId("MajorP"..i))
	end
	NPCs.LeoSerf[1] = false
	DisableNpcMarker(GetEntityId("LeoSerf"))
	--
	StartCountdown(10, TroopSpawnVorb, false)
	NumTimesAIStrengthIncreased = 0
	StartCountdown(15*60*gvDiffLVL, IncreaseAIStrength, false)
	for i = 1,14 do
		BanditenArmy(i)
	end
	MapEditor_SetupAI(InvasorPID, 3, 75000, round(4-gvDiffLVL), "KriegerArmy", 3, 0)
	MapEditor_Armies[InvasorPID].offensiveArmies.strength = round(25/gvDiffLVL)
	--
	barbarian_leaders = 0
	barbarian_max_leaders = round(130/math.sqrt(gvDiffLVL))
	BarbariansLeaderGUI()
	--
	StartSimpleJob("Sieg")
	StartSimpleJob("Niederlage")
end
function BarbariansLeaderGUI()
	GUIQuestTools.StartQuestInformation("Attack", "", 1, 1)
	GUIQuestTools.UpdateQuestInformationString(barbarian_leaders .. "/" .. barbarian_max_leaders)
	GUIQuestTools.UpdateQuestInformationTooltip = function()
		XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Angreifende Truppen der Barbaren @cr Wird die angegebene Zahl überschritten, sind die Barbaren nicht mehr aufhaltbar und das Spiel ist verloren!")
	end
	StartSimpleJob("BarbariansLeaderCheck")
end

function BarbariansLeaderCheck()

	if Counter.Tick2("BarbariansLeaderCheck_Counter", 5) then
		barbarian_leaders = GetNumberOfAttackingBarbarianTroops()
		GUIQuestTools.UpdateQuestInformationString(barbarian_leaders .. "/" .. barbarian_max_leaders)

		if barbarian_leaders >= barbarian_max_leaders then
			GUIQuestTools.DisableQuestInformation()
			return true

		end
	end
end
function GetNumberOfAttackingBarbarianTroops()
	local leaders = table.getn(MapEditor_Armies[InvasorPID].offensiveArmies.IDs)
	for k, v in pairs(ArmyTable[InvasorPID]) do
		if v.rodeLength == Logic.WorldGetSize() then
			leaders = leaders + table.getn(v.IDs)
		end
	end
	return leaders
end
VillageDipl = {Friendly = {8},
				Hostile = {}}
function DiplomacyCheck()
	table.insert(VillageDipl.Hostile, InvasorPID)
	for i = 3, 7 do
		if table_findvalue(VillageDipl.Friendly, i) == 0 then
			table.insert(VillageDipl.Hostile, i)
		end
	end
	if CNetwork then
		for i = 1, 2 do
			for j = 1, table.getn(VillageDipl.Hostile) do
				SetHostile(i, VillageDipl.Hostile[j])
			end
		end
		for j = 1, table.getn(VillageDipl.Hostile) do
			for k = 1, table.getn(VillageDipl.Friendly) do
				SetHostile(VillageDipl.Friendly[k], VillageDipl.Hostile[j])
			end
		end
		SetPlayerDiplomacy({1,2,unpack(VillageDipl.Friendly)}, Diplomacy.Friendly)
	else
		for j = 1, table.getn(VillageDipl.Hostile) do
			SetHostile(1, VillageDipl.Hostile[j])
			for k = 1, table.getn(VillageDipl.Friendly) do
				SetHostile(VillageDipl.Friendly[k], VillageDipl.Hostile[j])
			end
		end
		SetPlayerDiplomacy({1,unpack(VillageDipl.Friendly)}, Diplomacy.Friendly)
	end
	InitializeAttackPrioTable()
	SetAttackPriority("Hostile", VillageDipl.Hostile)
	SetAttackPriority("Friendly", VillageDipl.Friendly)
	StartSimpleJob("CheckForAttackPrioRedirectNeeded")
end
function InitializeAttackPrioTable()
	AttackPrioPositionByDiplomacyAndPlayerID = {Friendly = {[3] = GetPosition("BanditSpawn14"),
															[4] = GetPosition("Trader2"),
															[5] = GetPosition("Bandit15"),
															[6] = GetPosition("Trader2"),
															[7] = GetPosition("BanditSpawn6"),
															[8] = GetPosition("Trader2")
															},
												Hostile = {	[3] = GetPosition("Holz3"),
															[7] = GetPosition("P1Burg"),
															[InvasorPID] = GetPosition("Trader2")
															}
												}
	AttackPrioPlayerEntityQueue = {	[3] = {"Turm11", "Turm12", "Turm5", "Turm7"},
									[5] = {"Turm4", "Turm7"}
								}
end
function SetAttackPriority(_type, _playerIDs)
	for i in _playerIDs do
		local player = _playerIDs[i]
		if AttackPrioPositionByDiplomacyAndPlayerID[_type][player] then
			if MapEditor_Armies[player] then
				MapEditor_Armies[player].offensiveArmies.enemySearchPosition = AttackPrioPositionByDiplomacyAndPlayerID[_type][player]
			end
			if ArmyTable[player] then
				for k, v in pairs(ArmyTable[player]) do
					v.enemySearchPosition = AttackPrioPositionByDiplomacyAndPlayerID[_type][player]
				end
			end
		end
	end
end
function CheckForAttackPrioRedirectNeeded()
	local count = 0
	for k,v in pairs(AttackPrioPlayerEntityQueue) do
		if v[1] then
			if IsDestroyed(v[1]) then
				MapEditor_Armies[k].offensiveArmies.enemySearchPosition = (v[2] and GetPosition(v[2])) or MapEditor_Armies[k].offensiveArmies.enemySearchPosition
				table.remove(v, 1)
			end
		else
			count = count + 1
		end
	end
	return count == 2
end
function IncreaseAIStrength()
	local enemies = BS.GetAllEnemyPlayerIDs(1)
	local allies = BS.GetAllAlliedPlayerIDs(1)
	NumTimesAIStrengthIncreased = NumTimesAIStrengthIncreased + 1
	for player in enemies do
		local pID = enemies[player]
		if NumTimesAIStrengthIncreased == round(8*gvDiffLVL) then
			ResearchTechnology(Technologies.T_SilverSwords,pID)
			ResearchTechnology(Technologies.T_SilverBullets,pID)
			ResearchTechnology(Technologies.T_SilverMissiles,pID)
			ResearchTechnology(Technologies.T_SilverPlateArmor,pID)
			ResearchTechnology(Technologies.T_SilverArcherArmor,pID)
			ResearchTechnology(Technologies.T_SilverArrows,pID)
			ResearchTechnology(Technologies.T_SilverLance,pID)
			ResearchTechnology(Technologies.T_BloodRush,pID)
		end
		MapEditor_Armies[pID].offensiveArmies.strength = MapEditor_Armies[pID].offensiveArmies.strength + round(5/gvDiffLVL)
	end
	for player in allies do
		local pID = allies[player]
		if MapEditor_Armies[pID] then
			MapEditor_Armies[pID].offensiveArmies.strength = math.max(MapEditor_Armies[pID].offensiveArmies.strength - round(2/gvDiffLVL), round(6*gvDiffLVL))
		end
	end
	StartCountdown(15*60*gvDiffLVL, IncreaseAIStrength, false)
end
function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/(gvDiffLVL^2))
	local TimeNeeded = math.floor(math.min((4.0 + gvDiffLVL + ((math.random(1,5)/10))) *60, 9*60/(math.sqrt(gvDiffLVL))))
	TroopSpawn(TimePassed)
	SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
end
trooptypes = {Entities.PU_LeaderBow4,Entities.CU_BlackKnight_LeaderSword3,Entities.PU_LeaderSword4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.CU_BanditLeaderSword1},
				[2] = {Entities.CU_BanditLeaderSword1, Entities.CU_BanditLeaderBow1},
				[3] = {Entities.CU_BanditLeaderSword1, Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2,
					Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
					trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
					trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)],
					Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[7] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
					trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
					trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,6)],
					Entities["PV_Cannon".. math.random(3,6)], Entities["PV_Cannon".. math.random(4,6)], Entities["PV_Cannon".. math.random(5,6)]}
			}
function TroopSpawn(_TimePassed)
	Message("Barbaren versammeln sich, um Trogteburg zu vernichten!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_varg, 120)
	--local type1,type2,type3,type4
	for i = 1,14 do
		if _TimePassed <= 6 then
			CreateAttackingArmies("BanditSpawn", i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies("BanditSpawn", i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 24 then
			CreateAttackingArmies("BanditSpawn", i, 3)

		elseif _TimePassed > 24 and _TimePassed <= 40 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("BanditSpawn", i, 4)

		elseif _TimePassed > 40 and _TimePassed <= 65 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)],
			Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("BanditSpawn", i, 5)

		elseif _TimePassed > 65 and _TimePassed <= 110 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("BanditSpawn", i, 6)

		elseif _TimePassed > 110 then
			if table.getn(trooptypes) >= 7 then
				table.remove(trooptypes, 6)
				table.remove(trooptypes, 2)
			end
			-- shuffle
			armytroops[7] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			Entities["PV_Cannon".. math.random(2,6)], Entities["PV_Cannon".. math.random(3,6)], Entities["PV_Cannon".. math.random(4,6)], Entities["PV_Cannon".. math.random(5,6)]}
			--
			CreateAttackingArmies("BanditSpawn", i, 7)
		end
	end
end
InvasionArmyIDByPattern = {["BanditSpawn"] = {}}
function CreateAttackingArmies(_name, _poscount, _index)
	if not IsExisting("Turm" .. _poscount) then
		return
	end
	local army	= {}
	local player = InvasorPID
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
function ControlArmies(_player, _id)

    if IsDead(ArmyTable[_player][_id + 1]) then
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
function ControlBanditArmy(_player, _id, _index, _building)
	if IsVeryWeak(ArmyTable[_player][_id + 1]) then
		if IsExisting(_building) then
			if Counter.Tick2("ControlBanditArmy_Counter_" .. _id, round(25*gvDiffLVL)) then
				BanditenArmy(_index)
				return true
			end
		else
			return true
		end
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
function BanditenArmy(_index)

	local army	 = {}

	army.player 	= InvasorPID
	army.id			= GetFirstFreeArmySlot(InvasorPID)
	army.strength	= round((3+(Logic.GetTime()/900))/gvDiffLVL)
	army.position	= GetPosition("BanditSpawn".. _index)
	army.rodeLength	= 5000

	SetupArmy(army)
	local building = "Turm".. _index
	local troopDescription = {

		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderSword1},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderBow1},
		{experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Barbarian_LeaderClub1}
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription[math.random(1,3)])
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlBanditArmy",1,{},{army.player, army.id, _index, building})
end

function Sieg()
	if IsDestroyed("Turm1") and IsDestroyed("Turm2") and IsDestroyed("Turm3") and IsDestroyed("Turm4") and IsDestroyed("Turm5")
	and IsDestroyed("Turm6") and IsDestroyed("Turm7") and IsDestroyed("Turm8") and IsDestroyed("Turm9") and IsDestroyed("Turm10")
	and IsDestroyed("Turm11") and IsDestroyed("Turm12") and IsDestroyed("Turm13") and IsDestroyed("Turm14")
	and Logic.GetNumberOfLeader(InvasorPID) <= 1 then
		SiegBriefing()
		return true
	end
end
function SiegBriefing()

	local briefing = {}
	local AP, ASP = AddPages(briefing)
	AP{
	title = MjP8,
	text = "@color:20,255,50 Woaa, ihr habt es geschafft, mit uns zusammen die Banditen zu vernichten. @cr "..
		   "@color:20,255,50 Ich kann es immer noch gar nicht fassen. Ihr habt uns geholfen, die Invasion durch die Banditen zurückzustoßen und gleichzeitig die umliegenden Dörfer besänftigt! @cr "..
		   "@color:20,255,50 Jetzt kann wieder Frieden einkehren.",
	position = GetPosition("MajorP8"),
	dialogCamera = false,
	action = function()
	Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 37292,45632, 0 )
	Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 37292,45632, 0 )
	end
	}

	ASP("MajorP8",Mj8,"@color:20,255,50 Wir werden euch auf ewig dankbar sein!", true)
	briefing.finished = function()
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map9_won", 2)
				end
			end
		end
		Victory()
	end
	StartBriefing(briefing)
end
function Niederlage()
	if IsDead("P8Burg") or IsDead("FolklungCastle") or IsDead("P8_Statue")
	or IsDead("P1Burg") or IsDead("P2Burg")
	or barbarian_leaders >= barbarian_max_leaders then
		NiederlageBriefing()
		return true
	end
end
function NiederlageBriefing()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP8",Mj8,"@color:20,255,50 Wir wurden von den Banditen und deren Verbündeten regelrecht überrollt...", false)
	ASP("MajorP8",Mj8,"@color:20,255,50 Macht es nächstes Mal besser!", true)
  	briefing.finished = function()
		Defeat()
	end
	StartBriefing(briefing)
end
function Siedelanfang()
	SetupPlayerAi( 8, { serfLimit = 10, extracting = 1, constructing = false, repairing = true } )
	AI.Village_DeactivateRebuildBehaviour(8)
	EnableNpcMarker(GetEntityId("MajorP3"))
	EnableNpcMarker(GetEntityId("MajorP4"))
	EnableNpcMarker(GetEntityId("MajorP5"))
	EnableNpcMarker(GetEntityId("MajorP6"))
	EnableNpcMarker(GetEntityId("MajorP7"))
	EnableNpcMarker(GetEntityId("statue_guard"))
	NPCs.MajorP3[1] = true
	NPCs.MajorP4[1] = true
	NPCs.MajorP5[1] = true
	NPCs.MajorP6[1] = true
	NPCs.MajorP7[1] = true
	NPCs.statue_guard[1] = true
	Logic.RemoveQuest(1,2)
	Logic.RemoveQuest(2,2)
	Logic.AddQuest(1,3,MAINQUEST_OPEN,"@color:20,255,50 Gegen die Zeit","@color:20,255,50 Redet mit den Bürgermeistern der umliegenden Siedlungen Trogteburgs und zieht sie auf eure Seite. Beeilt euch, die Banditen werden bald angreifen!  ",1)
	Logic.AddQuest(2,3,MAINQUEST_OPEN,"@color:20,255,50 Gegen die Zeit","@color:20,255,50 Redet mit den Bürgermeistern der umliegenden Siedlungen Trogteburgs und zieht sie auf eure Seite. Beeilt euch, die Banditen werden bald angreifen!  ",1)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(8)) do
		local name = Logic.GetEntityName(eID)
		if name then
			if string.find(name, "P1") ~= nil then
				ChangePlayer(eID, 1)
			end
			if string.find(name, "P2") ~= nil then
				if CNetwork then
					ChangePlayer(eID, 2)
				else
					ChangePlayer(eID, 1)
				end
			end
		end
	end
	-- Initial Resources
	local InitGoldRaw 		= math.floor(600*(math.sqrt(gvDiffLVL)))
	local InitClayRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitWoodRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitStoneRaw 		= math.floor(1200*(math.sqrt(gvDiffLVL)))
	local InitIronRaw 		= math.floor(800*(math.sqrt(gvDiffLVL)))
	local InitSulfurRaw		= math.floor(500*(math.sqrt(gvDiffLVL)))
	--Add Players Resources
	local i
	for i = 1,8 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	MapEditor_SetupAI(8, 3, 20000, 3, "Trogteburg", 3, 0)
	MapEditor_Armies[8].offensiveArmies.strength = round(20*math.sqrt(gvDiffLVL))
	AI.Village_DeactivateRebuildBehaviour(8)
	StartSimpleJob("SearchForP8TowerPlacement")

	for i = 1,2 do
		SetFriendly(i,8)
	end
end
function SearchForP8TowerPlacement()
	local num, id = Logic.GetPlayerEntitiesInArea(8, Entities.PB_Tower1, 58000, 12000, 2000, 1)
	if num > 0 then
		DestroyEntity(id)
	end
	-- finish job anyway
	return true
end
--
function ExtraBriefing1()
	EnableNpcMarker(GetEntityId("Trader1"))
	NPCs.Trader1[1] = true
end
function ExtraBriefing2()
	EnableNpcMarker(GetEntityId("Trader2"))
	NPCs.Trader2[1] = true
end
function ExtraBriefing3()
	EnableNpcMarker(GetEntityId("CannonTrader"))
	NPCs.CannonTrader[1] = true
	EnableNpcMarker(GetEntityId("wiseman"))
	NPCs.wiseman[1] = true
end
function ExtraBriefing4()
	EnableNpcMarker(GetEntityId("Cavalry"))
	NPCs.Cavalry[1] = true
	EnableNpcMarker(GetEntityId("Farmer"))
	NPCs.Farmer[1] = true
end
function ExtraBriefing5()
	EnableNpcMarker(GetEntityId("Monk"))
	NPCs.Monk[1] = true
	MonksHelpedCount = 0
	EnableNpcMarker(GetEntityId("Miner"))
	NPCs.Miner[1] = true
end
function ExtraBriefing6()
	EnableNpcMarker(GetEntityId("LeoSerf"))
	NPCs.LeoSerf[1] = true
	EnableNpcMarker(GetEntityId("Trader3"))
	NPCs.Trader3[1] = true
	EnableNpcMarker(GetEntityId("Hermit"))
	NPCs.Hermit[1] = true
	EnableNpcMarker(GetEntityId("settler"))
	NPCs.settler[1] = true
	EnableNpcMarker(GetEntityId("Miner2"))
	NPCs.Miner2[1] = true
end
function ExtraBriefing7()
	EnableNpcMarker(GetEntityId("Trader4"))
	NPCs.Trader4[1] = true
	EnableNpcMarker(GetEntityId("Monk2"))
	NPCs.Monk2[1] = true
	StartSimpleJob("MonksHelped")
	EnableNpcMarker(GetEntityId("Farmer2"))
	NPCs.Farmer2[1] = true
end
function Trader1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader1",Tr1,"@color:20,255,50 He ihr da! Wollt ihr hochwertige Güter zu niedrigen Preisen kaufen?", true)
	ASP("Ari",Ari,"@color:20,255,50 Was genau verkauft ihr denn?", true)
	ASP("Trader1",Tr1,"@color:20,255,50 Alles mögliche. Aber vorallem Steine. Seht in euer Tributmenü, um mir welche abzukaufen!", false)

    briefing.finished = function()
		TraderTribut1a()
  	end
	StartBriefing(briefing)
end
function TraderTribut1a()
	local Tr1atribute =  {}
	Tr1atribute.playerId = TributePID;
	Tr1atribute.text = "Zahlt ".. dekaround(1000/gvDiffLVL) .." Taler , um 1000 Steine zu kaufen!";
	Tr1atribute.cost = {Gold = dekaround(1000/gvDiffLVL)};
	Tr1atribute.Callback = Steinebezahlt;
	AddTribute( Tr1atribute )
end
function Steinebezahlt()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader1",Tr1,"@color:230,0,0 Danke für die Zahlung. Das war doch ein fairer Handel, nicht? Lasst uns weiter handeln.", true)
	briefing.finished = function()
		AddStone(TributePID,1000)
		TraderTribut1b()
	end;
	StartBriefing(briefing);
end
function TraderTribut1b()
	local Tr1btribute =  {}
	Tr1btribute.playerId = TributePID;
	Tr1btribute.text = "Zahlt ".. dekaround(1800/gvDiffLVL) .." Taler , um 1000 Steine zu kaufen!";
	Tr1btribute.cost = {Gold = dekaround(1800/gvDiffLVL)};
	Tr1btribute.Callback = Steinebezahlt;
	AddTribute( Tr1btribute )
end
function Trader2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader2",Tr2,"@color:20,255,50 Guten Tag junge Frau! Hier gibts das beste Eisen der Region zu Spottpreisen.", true)
	ASP("Ari",Ari,"@color:20,255,50 Das klingt wirklich verlockend. Ich sehe mich mal um.", true)
	ASP("Trader2",Tr2,"@color:20,255,50 Ihr werdet nirgends bessere Qualität finden. Schlagt zu, solange noch was da ist.", false)

    briefing.finished = function()
		TraderTribut2()
	end;
	StartBriefing(briefing)
end
function TraderTribut2()
	local Tr2tribute =  {}
	Tr2tribute.playerId = TributePID;
	Tr2tribute.text = "Zahlt ".. dekaround(1000/gvDiffLVL) .." Taler , um 800 Eisen zu kaufen!";
	Tr2tribute.cost = {Gold = dekaround(1000/gvDiffLVL)};
	Tr2tribute.Callback = Eisenbezahlt1;
	AddTribute( Tr2tribute )
end
function Eisenbezahlt1()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",Tr2,"@color:230,0,0 Das war doch mal ein fairer Handel. Noch habe ich was da, handelt gerne wieder mit mir!", true)
	briefing.finished = function()
		AddIron(TributePID,800)
		TraderTribut2b()
	end;
	StartBriefing(briefing);
end
function TraderTribut2b()
	local Tr2btribute =  {}
	Tr2btribute.playerId = TributePID;
	Tr2btribute.text = "Zahlt ".. dekaround(1600/gvDiffLVL) .." Taler , um 1000 Eisen zu kaufen!";
	Tr2btribute.cost = {Gold = dekaround(1600/gvDiffLVL)};
	Tr2btribute.Callback = Eisenbezahlt2;
	AddTribute( Tr2btribute )
end
function Eisenbezahlt2()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",Tr2,"@color:230,0,0 Ohh, ihr habt erneut mit mir gehandelt. Das ist aber erfreulich. Leider habe ich kaum noch Eisen hier und muss daher die Preise erhöhen!", true)
	briefing.finished = function()
		AddIron(TributePID,1000)
		TraderTribut2c()
	end;
	StartBriefing(briefing);
end
function TraderTribut2c()
	local Tr2ctribute =  {}
	Tr2ctribute.playerId = TributePID;
	Tr2ctribute.text = "Zahlt ".. dekaround(2200/gvDiffLVL) .." Taler, um 800 Eisen zu kaufen!";
	Tr2ctribute.cost = {Gold = dekaround(2200/gvDiffLVL)};
	Tr2ctribute.Callback = Eisenbezahlt3;
	AddTribute( Tr2ctribute )
end
function Eisenbezahlt3()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",Tr2,"@color:230,0,0 Danke, dass ihr trotz der gestiegenen Preise immer noch mit mir handelt!", true)
	briefing.finished = function()
		AddIron(TributePID,800)
		TraderTribut2c()
	end;
	StartBriefing(briefing);
end
function Trader3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader3",Tr1,"@color:20,255,50 Hereinspaziert, hereinspaziert. Hier gibt es die besten Preise in der gesamten Gegend.", true)
	ASP("Ari",Ari,"@color:20,255,50 Was genau verkauft ihr denn?", true)
	ASP("Trader3",Tr1,"@color:20,255,50 Eigentlich habe ich mich auf Holz spezialisiert. Aber durch die Kriegsvorbereitungen wurde mein gesamter Vorrat aufgekauft.", false)
	ASP("Trader3",Tr1,"@color:20,255,50 Verkauft ihr mir ein wenig von Eurem Holz? Ich zahle Euch einen guten Preis!", false)

    briefing.finished = function()
		TraderTribut3a()
  	end
	StartBriefing(briefing)
end
function TraderTribut3a()
	local Tr3atribute =  {}
	Tr3atribute.playerId = TributePID
	Tr3atribute.text = "Verkauft ".. dekaround(1200/gvDiffLVL) .." Holz für 1200 Taler!"
	Tr3atribute.cost = {Wood = dekaround(1200/gvDiffLVL)};
	Tr3atribute.Callback = Holzbezahlt1;
	AddTribute( Tr3atribute )
end
function Holzbezahlt1()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader3",Tr2,"@color:230,0,0 Danke für die Holzlieferung. Kommt gerne wieder und handelt erneut mit mir!", false)
	briefing.finished = function()
		AddGold(TributePID,1200)
		TraderTribut3b()
	end;
	StartBriefing(briefing);
end
function TraderTribut3b()
	local Tr3btribute =  {}
	Tr3btribute.playerId = TributePID
	Tr3btribute.text = "Verkauft ".. dekaround(2200/gvDiffLVL) .." Holz für 1800 Taler!"
	Tr3btribute.cost = {Wood = dekaround(2200/gvDiffLVL)};
	Tr3btribute.Callback = Holzbezahlt2;
	AddTribute( Tr3btribute )
end
function Holzbezahlt2()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader3",Tr2,"@color:230,0,0 Welch hochwertiges Holz. Handelt jederzeit erneut mit mir.", false)
	briefing.finished = function()
		AddGold(TributePID,1800)
		TraderTribut3b()
	end;
	StartBriefing(briefing);
end
function Trader4()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader4",Tr1,"@color:20,255,50 Schweeeefel, seltenen Schweeefel zu verkaufen!", true)
	ASP("Trader4",Tr1,"@color:20,255,50 Schauet und sehet meine Preise!", false)

    briefing.finished = function()
		TraderTribut4a()
  	end
	StartBriefing(briefing)
end
function TraderTribut4a()
	local Tr4atribute =  {}
	Tr4atribute.playerId = TributePID
	Tr4atribute.text = "Kauft 1000 Schwefel für ".. dekaround(1500/gvDiffLVL) .." Taler!"
	Tr4atribute.cost = {Gold = dekaround(1500/gvDiffLVL)}
	Tr4atribute.Callback = Schwefelbezahlt1
	AddTribute( Tr4atribute )
end
function Schwefelbezahlt1()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader4",Tr1,"@color:230,0,0 Das war doch ein fairer Handel, nicht? Noch habe ich Schwefel auf Lager, kommt gerne wieder!", false)
	briefing.finished = function()
		AddSulfur(TributePID,1000)
		TraderTribut4b()
	end;
	StartBriefing(briefing);
end
function TraderTribut4b()
	local Tr4btribute =  {}
	Tr4btribute.playerId = TributePID
	Tr4btribute.text = "Kauft 1400 Schwefel für ".. dekaround(2500/gvDiffLVL) .." Taler!"
	Tr4btribute.cost = {Gold = dekaround(2500/gvDiffLVL)};
	Tr4btribute.Callback = Schwefelbezahlt2
	AddTribute( Tr4btribute )
end
function Schwefelbezahlt2()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader4",Tr1,"@color:230,0,0 Ohh welch funkelnde Goldmünzen. Ich musste die Preise leider leicht erhöhen, aber handelt gerne wieder mit mir.", false)
	briefing.finished = function()
		AddSulfur(TributePID,1400)
		TraderTribut4b()
	end;
	StartBriefing(briefing);
end
function CannonTrader()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("CannonTrader",Cannon,"@color:20,255,50 Guten Tag, Mylady. Seid ihr Ari, die versucht uns im Kampf gegen die Barbaren zu unterstützen?", true)
	ASP("Ari",Ari,"@color:20,255,50 Ja, genau die bin ich. Wo ihr schon so fragt, wobei kann ich euch helfen?", true)
	ASP("CannonTrader",Cannon,"@color:20,255,50 Im Kampf gegen Banditen und mehreren belagernden Städten kann man gar nicht genug Kanonen gegen sie besitzen.", false)
	ASP("CannonTrader",Cannon,"@color:20,255,50 Ich habe es bereits versucht, den Kommandanten zu überreden, mir mehr Ressourcen für die Kanonenproduktion zur Verfügung zu stellen, aber leider war alles vergebens...", true)
	ASP("CannonTrader",Cannon,"@color:20,255,50 Könnt ihr, Ari, mir helfen und mir ein wenig Schwefel zukommen lassen?", false)
    briefing.finished = function()
		CannonTribut()
  	end;
	StartBriefing(briefing)
end
function CannonTribut()
	local Ctribute =  {}
	Ctribute.playerId = TributePID;
	Ctribute.text = "Zahlt " .. dekaround(4000/gvDiffLVL) .. " Schwefel, " .. dekaround(1000/gvDiffLVL) .. " Eisen und " .. dekaround(3500/gvDiffLVL) .. " Taler an den Meistermechanikus, damit dieser mehrere Kanonen zur Verteidigung Trogteburgs anfertigen kann!";
	Ctribute.cost = {Gold = dekaround(3500/gvDiffLVL), Sulfur = dekaround(4000/gvDiffLVL), Iron = dekaround(1000/gvDiffLVL)};
	Ctribute.Callback = Cannonbezahlt;
	AddTribute( Ctribute )
end
function Cannonbezahlt()
     local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("CannonTrader",Cannon,"@color:230,0,0 Danke für die überaus großzügige Menge an Ressourcen. Ich werde den Menschen hier von Eurem großen Herz erzählen. Jetzt mache ich mich an die Kanonenproduktion.", true)
	briefing.finished = function()
		StartCountdown(15*60,KanonenArmy,false)
	end;
	StartBriefing(briefing);
end
function KanonenArmy()
	Message("@color:230,0,0 So, die ersten paar Kanonen sind einsatzbereit!")
	for i = 1, round(3 + gvDiffLVL) do
		ConnectLeaderWithArmy(CreateEntity(8,Entities.PV_Cannon5,GetPosition("Zusatztruppen")), nil, "offensiveArmies")
	end
	StartCountdown(30*60,WeitereKanonen,false)
end
function WeitereKanonen()
	Message("@color:230,0,0 Weitere Kanonen sind nun gefechtbereit!")
	for i = 1, round(gvDiffLVL) do
		ConnectLeaderWithArmy(CreateEntity(8,Entities.PV_Cannon5,GetPosition("Zusatztruppen")), nil, "offensiveArmies")
		ConnectLeaderWithArmy(CreateEntity(8,Entities.PV_Cannon3,GetPosition("Zusatztruppen")), nil, "offensiveArmies")
		ConnectLeaderWithArmy(CreateEntity(8,Entities.PV_Cannon1,GetPosition("Zusatztruppen")), nil, "offensiveArmies")
	end
	StartCountdown(35*60,ExtraCannon,false)
end
function ExtraCannon()
	for i = 1, round(1 + gvDiffLVL) do
		ConnectLeaderWithArmy(CreateEntity(8,Entities.PV_Cannon5,GetPosition("Zusatztruppen")), nil, "offensiveArmies")
	end
	StartCountdown(35*60,ExtraCannon,false)
end
function Reiter()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Cavalry",Cavalry,"@color:20,255,50 Ihr seid also Ari, die Anführerin eines Banditenstammes.", true)
	ASP("Ari",Ari,"@color:20,255,50 Äähhm ja, früher mal - gewesen. Aber das sind längst vergangene Zeiten.", true)
	ASP("Cavalry",Cavalry,"@color:20,255,50 Wenn wir nicht in so einer schlechten Lage wären, würde ich euch nie fragen... Ich spüre, dass ihr immer noch eine Banditin seid. Ich traue euch nicht über den Weg...", true)
	ASP("Cavalry",Cavalry,"@color:20,255,50 ... dennoch benötigen wir eure Hilfe. Wir haben kaum noch Geld und müssen eine weitaus größere Armee ausheben. Helft ihr uns dabei??", false)
    briefing.finished = function()
		Cavalrytribute()
	end;
	StartBriefing(briefing);
end
function Cavalrytribute()
	local Cavtribute =  {}
	Cavtribute.playerId = TributePID;
	Cavtribute.text = "Zahlt " .. dekaround(8000/gvDiffLVL) .. " Taler und " .. dekaround(2000/gvDiffLVL) .. " Eisen an den Kommandanten der Kavallerie, damit dieser mehrere Reiter zur Verteidigung Trogteburgs rekrutieren kann!";
	Cavtribute.cost = {Gold = dekaround(8000/gvDiffLVL), Iron = dekaround(2000/gvDiffLVL)};
	Cavtribute.Callback = Cavalrybezahlt;
	AddTribute( Cavtribute )
end
function Cavalrybezahlt()
     local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Cavalry",Cavalry,"@color:230,0,0 Grrmpf. Das habt ihr gut gemacht. Man scheint sich doch auf euch verlassen zu können. Ich hoffe nur, das Geld stammt aus keinem Überfall.", true)
	briefing.finished = function()
		StartCountdown(15*60,CavalryArmy,false)
	end;
	StartBriefing(briefing);
end
function CavalryArmy()
	local pos = GetPosition("Zusatztruppen")
	Message("@color:230,0,0 Die Stärke unserer Reiterhorde wächst!")
	for i = 1, round(2+gvDiffLVL) do
		ConnectLeaderWithArmy(CreateGroup(8, Entities.PU_LeaderHeavyCavalry2, 3, pos.X, pos.Y, 0), nil, "offensiveArmies")
		ConnectLeaderWithArmy(CreateGroup(8, Entities.PU_LeaderCavalry2, 6, pos.X, pos.Y, 0), nil, "offensiveArmies")
	end
	StartCountdown(20*60,WeitereCavalry,false)
end
function WeitereCavalry()
	local pos = GetPosition("Zusatztruppen")
	Message("@color:230,0,0 Immer mehr Reiter schließen sich uns an!")
	for i = 1, round(1+gvDiffLVL) do
		ConnectLeaderWithArmy(CreateGroup(8, Entities.PU_LeaderHeavyCavalry2, 3, pos.X, pos.Y, 0), nil, "offensiveArmies")
		ConnectLeaderWithArmy(CreateGroup(8, Entities.PU_LeaderCavalry2, 6, pos.X, pos.Y, 0), nil, "offensiveArmies")
	end
	StartCountdown(35*60,WeitereCavalry,false)
end
function Moench()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Monk",Monk,"@color:20,255,50 Schluchz, heul... Mir geht es soo schlecht,ich könnte den Hang dort hinuntespringen... Buhuhuäää.", true)
	ASP("Ari",Ari,"@color:20,255,50 Was ist mit euch los? Warum so deprimiert?", true)
	ASP("Monk",Monk,"@color:20,255,50 Wuuäää. Vor kurzem ist direkt in die <<KIRCHE>> neben mir ein Blitz aus heiterem Himmel eingeschlagen. Heuul... Seitdem hat uns alle der Glaube verlassen.. Schluchzz...", false)
	ASP("Monk",Monk,"@color:20,255,50 Solch schlechte Zeichen hatten wir ... Muäähhh ... noch nie... heulll.. Und jetzt lasst mich bitte ...Prrrff... in meiner Trauer allein...", true)

    briefing.finished = function()
		StartSimpleJob("Kirchenabfrage")
		ChangePlayer("Kirchenruine",InvasorPID)
		SetHealth("Kirchenruine",5)
  	end
	StartBriefing(briefing)
end
function Kirchenabfrage()
	idKi = SucheAufDerWelt(1,Entities.PB_Monastery2,1000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		ChangePlayer(idKi[1],8)
		KircheFertig(1)
		return true
	end
	idKi = SucheAufDerWelt(2,Entities.PB_Monastery2,1000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		ChangePlayer(idKi[1],8)
		KircheFertig(2)
		return true
	end
end
function KircheFertig(_player)
	Sound.PlayGUISound(Sounds.fanfare,90)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Monk",Monk,"Schluchzz...heul... nanu, wo kommt denn die Kirche plötzlich her??", true)
	ASP("Monk",Monk,"Das ist ein Zeichen Gottes! Jetzt kann ich voller Elan wieder den Glauben hier verbreiten.", true)
	ASP("Monk",Monk,"Und das hier ist für Euch. Erst nach der Begegnung mit Euch wurden mir die Augen geöffnet!", false)
	briefing.finished = function()
		AddGold(_player,dekaround(5000*gvDiffLVL))
		MonksHelpedCount = MonksHelpedCount + 1
	end;
	StartBriefing(briefing);
end
function Monk2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Monk2",Monk,"@color:20,255,50 Seht euch einer diese Ketzerei an. Und ich bin machtlos dagegen...", true)
	ASP("Monk2",Monk,"@color:20,255,50 Seit unser Gärtner für den Militärdienst eingezogen wurde, überwuchert unser Friedhof. Bestimmt drehen sich die Toten schon im Grab um...", true)
	ASP("Monk2",Monk,"@color:20,255,50 Ich fürchte, wenn das so weiter geht, erwachen sie aus ihrem Schlaf und suchen uns heim. @cr @cr Bitte. Ihr müsste das unbedingt verhindern.", false)
	ASP("Monk2",QB,"@color:20,255,50 Entfernt sämtliche Spinnweben nahe der Abtei.", false)

    briefing.finished = function()
		StartSimpleJob("CobwebCheck")
  	end
	StartBriefing(briefing)
end
function CobwebCheck()
	if Logic.GetEntitiesInArea(Entities.XD_Cobweb3, 26200, 34500, 500, 1) == 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Monk2",Monk,"Ohh, wie schön. Alles erstrahlt wieder im alten Glanz", true)
		ASP("Monk2",Monk,"Und alle Toten sind unter der Erde geblieben. Der Herr sei Dank!", true)
		ASP("Monk2",Monk,"Das wäre ohne Euch alles nicht möglich gewesen. Hier nehmt diesen alten Silberreif als Entlohnung. Ich kann damit eh nichts anfangen.", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, dekaround(300*gvDiffLVL))
			MonksHelpedCount = MonksHelpedCount + 1
		end
		StartBriefing(briefing)
		return true
	end
end
function MonksHelped()
	if MonksHelpedCount == 2 then
		EnableNpcMarker(GetEntityId("johannes"))
		NPCs.johannes[1] = true
		return true
	end
end
function johannes()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("johannes",joh,"@color:20,255,50 Ari. @cr Gut euch zu sehen, in dieser schweren Zeit.", false)
	ASP("johannes",joh,"@color:20,255,50 Ich hörte, dass ihr meinen Brüdern geholfen habt. @cr Habt Dank. @cr Auch ich habe ein Anliegen an Euch.", false)
	ASP("BanditAbbey",joh,"@color:20,255,50 Brennt die Abtei der Banditen nieder. @cr Diese kriegslüsternen Verbrecher dürfen nicht denselben Glauben teilen wie wir.", false)

    briefing.finished = function()
		StartSimpleJob("AbbeyCheck")
  	end
	StartBriefing(briefing)
end
function AbbeyCheck()
	if IsDestroyed("BanditAbbey") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("johannes",joh,"Sehr gut, Ari. @cr Nun können diese Barbaren unseren Glauben nicht mehr länger in den Schmutz ziehen.", false)
		ASP("johannes",joh,"Hier, nehmt dies als Zeichen unserer Dankbarkeit!", true)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, dekaround(500*gvDiffLVL))
			AddGold(1, dekaround(5000*gvDiffLVL))
		end
		StartBriefing(briefing)
		return true
	end
end
function LeoSerf()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("LeoSerf",Leo,"@color:20,255,50 Moin, ihr müsst Ari sein?! Ihr seid bestimmt auf der Suche nach weiteren Dorfzentren, nicht wahr?", true)
	ASP("LeoSerf",Leo,"@color:20,255,50 Als ich kürzlich auf dem Weg zu meinem Lieblingshügel war, um dort die Sterne zu beobachten, hab ich gesehen, dass sich dort in der Nähe eines befindet.", true)
	ASP("BanditenSicht",Leo,"@color:20,255,50 Nur leider haben sich dort kürzlich Banditen niedergelassen.", false)
	ASP("Rock20",Leo,"@color:20,255,50 Und der Weg dorthin ist auch verschüttet...", false)

    briefing.finished = function()
  	end;
	StartBriefing(briefing)
end
function Farmer()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Farmer",farmer,"@color:20,255,50 Alles wurde uns in Vorbereitung auf den Krieg genommen...", false)
	ASP("VHRuin",farmer,"@color:20,255,50 Seht ihr diese Ruinen dort drüben? @cr Dort habe ich einst gelebt. Es war eine glücklichere und unbeschwertere Zeit.", false)
	ASP("Farmer",farmer,"@color:20,255,50 Sie haben sogar unsere Dorfhalle in Schutt und Asche gelegt, damit niemand sie wieder verwenden kann... @cr @cr Hach, wenn man doch die Zeit zurück drehen könnte...", false)
    briefing.finished = function()
		EnableNpcMarker(GetEntityId("Pilgrim"))
		NPCs.Pilgrim[1] = true
  	end;
	StartBriefing(briefing)
end
function Pilgrim()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Ari",Ari,"@color:20,255,50 Pilgrim, alter Knabe. @cr @cr Wir könnten deine Hilfe gebrauchen.", false)
	ASP("Pilgrim",pilg,"@color:20,255,50 Hicks.. Klar doch. @cr Lass uns gleich zur nächsten Kneipe gehen. @cr Aber nicht zu der unten am Waldrand. @cr Da haben die mich gestern rausgeworfen.", false)
	ASP("Ari",Ari,"@color:20,255,50 Saufen kannste später weiter. Wir brauchen dich, um einige Ruinen wegzusprengen.", false)
	ASP("Pilgrim",pilg,"@color:20,255,50 Sag das doch gleich. @cr Ist ja auch fast so gut wie Bier.", false)
	ASP("Pilgrim",pilg,"@color:20,255,50 Gib mir ein wenig Schwefel und sag mir, wo gesprengt werden soll. @cr @cr Wenn auf dem Weg dahin ne Kneipe liegt, kann's aber ein wenig länger dauern. @cr Hicks", false)
    briefing.finished = function()
		Pilgrimtribute()
  	end;
	StartBriefing(briefing)

end
function Pilgrimtribute()
	local Piltribute =  {}
	Piltribute.playerId = TributePID;
	Piltribute.text = "Gebt Pilgrim " .. dekaround(2000/gvDiffLVL) .. " Schwefel, damit er die Ruinen im südlichen Bauerndorf sprengen kann";
	Piltribute.cost = {Sulfur = dekaround(2000/gvDiffLVL)};
	Piltribute.Callback = Pilgrimbezahlt;
	AddTribute( Piltribute )
end
function Pilgrimbezahlt()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Pilgrim",pilg,"@color:230,0,0 Das sollte reichen. Ich mache mich gleich auf den Weg.", true)
	briefing.finished = function()
		StartSimpleJob("PilgrimIsDestinationReachable")
		PilgrimNote = 0
	end;
	StartBriefing(briefing);
end
function PilgrimIsDestinationReachable()
	if Logic.GetSector(GetEntityId("Pilgrim")) ~= Logic.GetSector(GetEntityId("VHRuin")) then
		if PilgrimNote == 0 then
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Pilgrim",pilg,"@color:230,0,0 Ihr wollt mich doch verarschen oder? @cr Der von Euch angegebene Ort ist gar nicht erreichbar. @cr @cr Ich genehmige mir erst einmal ein kühles Blondes.", false)
			briefing.finished = function()
				Move("Pilgrim", "Wirtshaus")
				PilgrimNote = PilgrimNote + 1
			end;
			StartBriefing(briefing)
		end
	else
		Move("Pilgrim", "VHRuin")
		StartSimpleJob("PilgrimCheckForArrival")
		PilgrimNote = nil
		return true
	end
end
function PilgrimCheckForArrival()
	if IsNear("Pilgrim", "VHRuin", 500) then
		local ruinpos = {}
		for i = 1, 6 do
			ruinpos[i] = GetPosition("ruin"..i)
		end
		for i = 1, 6 do
			Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, ruinpos[i].X, ruinpos[i].Y)
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, ruinpos[i].X, ruinpos[i].Y)
			DestroyEntity("ruin"..i)
		end
		ConnectLeaderWithArmy(Logic.GetEntityIDByName("Pilgrim"), nil, "offensiveArmies")
		FarmerFinishBrief()
		return true
	else
		if not Logic.IsEntityMoving(Logic.GetEntityIDByName("Pilgrim")) then
			Move("Pilgrim", "VHRuin")
		end
	end
end
function FarmerFinishBrief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("VHRuin",farmer,"@color:20,255,50 Oh, was sehe ich da mit meinen alten Augen? @cr Die grässlichen Ruinen @cr sie sind weg?", false)
	ASP("Farmer",farmer,"@color:20,255,50 Gebt mir ein wenig Zeit und ich werde die alte Dorfhalle wieder herrichten", false)
	briefing.finished = function()
		StartCountdown(3*60, RecreateVillageHall, false)
  	end;
	StartBriefing(briefing)
end
function RecreateVillageHall()
	ReplaceEntity("VHRuin", Entities.XD_VillageCenter_Ruin)
end
function Farmer2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Farmer2",farmer,"@color:20,255,50 Lust auf ein kleines Spielchen? @cr @cr Irgendwie muss man die Kriegswirren ja verdrängen...", true)
	ASP("Farmer2",farmer,"@color:20,255,50 Zählt die Schafe hinter mir. @cr Fangt mit der dunkelsten Sorte an; bis zur hellsten und legt die Anzahl Schafe pro Sorte nebeneinander.", false)
    ASP("Farmer2",farmer,"@color:20,255,50 Wenn ihr beide zusammen so viele arme Seelen besitzt wie ein Fünftel der Rechenaufgabe, gebe ich Euch eine Belohnung.", true)
	briefing.finished = function()
		StartSimpleJob("CheckForSerfs")
  	end;
	StartBriefing(briefing)
end
function CheckForSerfs()
	if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PU_Serf) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(2, Entities.PU_Serf)) == 75 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Farmer2",farmer,"@color:20,255,50 Seehr gute Leistung. Ich bin schwer beeindruckt", true)
		ASP("Farmer2",farmer,"@color:20,255,50 Hier. Wie versprochen Eure Belohnung.", false)
		ASP("Farmer2",men,"@color:20,255,50 Herr, seht doch. @cr Der Bauer hat Euch all seine Besitztümer überlassen.", false)
		briefing.finished = function()
			AddGold(1, dekaround(3000*gvDiffLVL))
			AddGold(2, dekaround(3000*gvDiffLVL))
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, round(250*gvDiffLVL))
			Logic.AddToPlayersGlobalResource(2, ResourceType.Silver, round(250*gvDiffLVL))
		end;
		StartBriefing(briefing)
		return true
	end
end
function Settler()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("settler",burner,"@color:20,255,50 Ihr habt nicht zufällig ein wenig Holz über?", true)
	ASP("settler",burner,"@color:20,255,50 Gebt meinem Meister ein wenig und er wird daraus die beste Kohle weit und breit herstellen.", false)

    briefing.finished = function()
		CoalBurnerTribut()
  	end
	StartBriefing(briefing)
end
function CoalBurnerTribut()
	local TrCbtribute =  {}
	TrCbtribute.playerId = TributePID
	TrCbtribute.text = "Gebt dem Gesellen des Köhlers " .. dekaround(1500/gvDiffLVL) .. " Holz, um diese zu Kohle zu verkoken!"
	TrCbtribute.cost = {Wood = dekaround(1500/gvDiffLVL)}
	TrCbtribute.Callback = BurnerPayed
	AddTribute( TrCbtribute )
end
function BurnerPayed()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("settler",burner,"@color:230,0,0 Im Namen meines Meisters soll ich mich bei Euch bedanken. Das waren feinste Eichenstämme. @cr @cr Und hier, die erhaltene Kohle. @cr Kommt gerne jederzeit mit weiteren Stämmen zurück!", false)
	briefing.finished = function()
		Logic.AddToPlayersGlobalResource(TributePID, ResourceType.Knowledge, 1000)
		CoalBurnerTribut()
	end;
	StartBriefing(briefing);
end
function Miner()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Miner",miner,"@color:20,255,50 Schöner Ausblick von hier oben, nicht wahr?", true)
	ASP("Bandit1",miner,"@color:20,255,50 Ich konnte beobachten, wie die Banditen dort hinten ihre Schätze vergraben haben. @cr Die waren dabei ganz unbekümmert.", false)
	ASP("Miner",miner,"@color:20,255,50 Sind eben auch nur Banditen, nicht wahr? @cr @cr Wie dem auch sei, ich hörte, dass einige Dörfer den Schatz für sich beanspruchen.", true)
	ASP("Miner",miner,"@color:20,255,50 Was ich damit nur sagen wollte: @cr Seid auf der Hut, wenn ihr ihn ausgraben wollt.", false)
    briefing.finished = function()
		BanditChests()
		StartSimpleJob("ChestControl")
  	end
	StartBriefing(briefing)
end
function BanditChests()
	Chests = {}
	for i = 25,35 do
		Chests[i] = true
	end
	do
		local pos = {}
		for i = 25,35 do
			if Chests[i] then
				pos[i] = GetPosition("GoldChest"..i)
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ChestGold,pos[i].X,pos[i].Y,0,0), "Chest"..i)
			end
		end
	end
end
function ChestControl()
	if not cutsceneIsActive and not briefingIsActive then
		local entities, pos, randomEventAmount
		for i = 25,35 do
			if Chests[i] then
				pos = 	GetPosition("Chest"..i)
				for j = 1, 2 do
					entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)}
					if entities[1] > 0 then
						if Logic.IsHero(entities[2]) == 1 or Logic.GetEntityType(entities[2]) == Entities.CU_VeteranCaptain then
							randomEventAmount = round((750 + math.random(350)) * gvDiffLVL)
							Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
							Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" )
							Sound.PlayGUISound(Sounds.Misc_Chat2,100)
							Chests[i] = false
							ReplacingEntity("Chest"..i, Entities.XD_ChestOpen)
							if not P6Triggered and Logic.GetDiplomacyState(1,6) ~= Diplomacy.Hostile then
								SetHostile(1, 6)
								SetHostile(2, 6)
								Logic.SetShareExplorationWithPlayerFlag(1, 6, 0)
								Logic.SetShareExplorationWithPlayerFlag(2, 6, 0)
								MakePlayerEntitiesInvulnerableLimitedTimeNearPosition(6, GetPosition("6"), 7000, round(120/gvDiffLVL))
								MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength + round(10/gvDiffLVL)
								MapEditor_Armies[6].defensiveArmies.strength = MapEditor_Armies[6].defensiveArmies.strength + round(5/gvDiffLVL)
								P6Triggered = true
							end
						end
					end
				end
			end
		end
	end
end
function Miner2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Miner2",miner,"@color:20,255,50 Schwarzes Gold. @cr Was für eine praktische Ressource", false)
	ASP("Miner2",miner,"@color:20,255,50 Findet ihr nicht? @cr Waaas? Das kann ich ja mal so gar nicht verstehen!", false)
	ASP("Miner2",miner,"@color:20,255,50 Hier, nehmt ein wenig und lasst mich in Ruhe!", false)
    briefing.finished = function()
		Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, round(500 * gvDiffLVL))
		Logic.AddToPlayersGlobalResource(2, ResourceType.Knowledge, round(500 * gvDiffLVL))
  	end
	StartBriefing(briefing)
end
function Hermit()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Hermit",herm,"@color:20,255,50 Zeige Er mir eine Siedlung, die so um Obdach scheut, wie meine Kleinen hier!", false)
    briefing.finished = function()
		StartSimpleJob("CheckForWorkerWithoutResidence")
  	end
	StartBriefing(briefing)
end
function CheckForWorkerWithoutResidence()
	if Logic.GetNumberOfWorkerWithoutSleepPlace(1) + Logic.GetNumberOfWorkerWithoutSleepPlace(2) == 32 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Hermit",herm,"@color:20,255,50 Hier, nehmt. @cr Zustände derart desolat!", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Wood, round(2500 * gvDiffLVL))
			Logic.AddToPlayersGlobalResource(2, ResourceType.Wood, round(2500 * gvDiffLVL))
		end
		return true
	end
end
function InitRiddles()
	wisemanriddles = {{text = "Aztds dhmd Jzldqzcdm Rszstd mzgd cdq Adqfedrstmf unm Sqnfsdatqf tmc rbgztds vzr fdrbghdgs", etype = Entities.PB_Beautification04, posentity = "Chief"},
					{text = "Cbvfu fhof Lbnfsbefo Tubuvf obif efs Cfshgftuvoh wpm Usphufcvsh voe tdibvfu xbt hftdijfiu", etype = Entities.PB_Beautification04, posentity = "Chief"},
					{text = "Aztds dhmd Czqhn Rszstd mzgd cdl Atdqfdqldhrsdq unm Sqnfsdatqf tmc rbgztds vzr fdrbghdgs", etype = Entities.PB_Beautification01, posentity = "MajorP8"},
					{text = "Cbvfu fhof Ebsjp Tubuvf obif efn Cvfshfsnfjtufs wpm Usphufcvsh voe tdibvfu xbt hftdijfiu", etype = Entities.PB_Beautification01, posentity = "MajorP8"},
					{text = "Aztds dhmd Qdhsdq Rszstd mzgd cdq Qdhsdqdh unm Sqnfsdatqf tmc rbgztds vzr fdrbghdgs", etype = Entities.PB_Beautification03, posentity = "Cavalry"},
					{text = "Cbvfu fhof Sfjufs Tubuvf obif efs Sfjufsfj wpm Usphufcvsh voe tdibvfu xbt hftdijfiu", etype = Entities.PB_Beautification03, posentity = "Cavalry"}
	}
end
function wiseman()
	if not wisemanriddles then
		InitRiddles()
	end
	local rand = math.random(1,6)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("wiseman", wman, "@color:20,255,50 Löst mein verschobenes Rätsel und ich werde Euch etwas äußerst nützliches zur Verfügung stellen. @cr Oder meinte ich verschroben?", false)
	ASP("wiseman", wman, "@color:20,255,50 " .. wisemanriddles[rand].text, false)
    briefing.finished = function()
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","CheckForRiddle",1,{},{wisemanriddles[rand].etype, wisemanriddles[rand].posentity})
  	end
	StartBriefing(briefing)
end
function CheckForRiddle(_type, _posentity)
	local idBe = SucheAufDerWelt(1,_type,1200,GetPosition(_posentity))
	if table.getn(idBe) > 0 and Logic.IsConstructionComplete(idBe[1]) == 1 then
		ChangePlayer(idBe[1],8)
		WisemanRiddleSolved(1)
		return true
	end
	local idBe = SucheAufDerWelt(2,_type,1200,GetPosition(_posentity))
	if table.getn(idBe) > 0 and Logic.IsConstructionComplete(idBe[1]) == 1 then
		ChangePlayer(idBe[1],8)
		WisemanRiddleSolved(2)
		return true
	end
end
function WisemanRiddleSolved(_player)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("wiseman", wman, "@color:20,255,50 Ihr seid schlauer als ihr ausseht. @cr Es ist zwar kein Dorfzentrum, aber die Wirkung ist ähnlich. @cr Lest diese Seiten und ihr wisst, was ich meine.", false)
	ASP("Ari", men, "@color:20,255,50 Der weise Mann reichte Ari ein altes Manuskript. @cr @cr Es dauerte eine Weile, aber letztendlich erkannte Ari eine alte Weisheit, Siedlungskapazitäten zu erweitern.", false)
    briefing.finished = function()
		CLogic.SetAttractionLimitOffset(_player, round(50 * gvDiffLVL))
  	end
	StartBriefing(briefing)
end
function SGuard()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("statue_guard",sgu,"@color:20,255,50 Seht ihr diese Statue? @cr An ihr hängt unsere gesamte Moral.", false)
	ASP("statue_guard",sgu,"@color:20,255,50 Meine Männer und ich werden ihr Leben dafür geben, dass diese Statue nicht fällt. @cr Ist sie nicht mehr, wird die Armee Trogteburgs zersplittern...", false)

    briefing.finished = function()
		ArmyP8(1)
		ArmyP8(2)
	end
	StartBriefing(briefing)
end
function ArmyP8(_index)
	local army	 = {}
	army.player 	= 8
	army.id			= GetFirstFreeArmySlot(8)
	army.strength	= round(3*gvDiffLVL)
	army.position	= GetPosition("P8_Spawn" .. _index)
	army.rodeLength	= 4000

	SetupArmy(army)

	local building = "P8_Tower" .. _index
	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end
	if _index == 2 then
		Redeploy(army, GetPosition("P8_Spawn1"))
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlP8Armies",1,{},{army.player, army.id, _index, building})
end
function ControlP8Armies(_player, _id, _index, _building)
	if IsDead(ArmyTable[_player][_id + 1]) then
		if IsExisting(_building) then
			if Counter.Tick2("ControlP8Armies_Counter_" .. _id, round(60/gvDiffLVL)) then
				ArmyP8(_index)
				return true
			end
		else
			return true
		end
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
--
function MajorP3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Ari",Ari,"@color:20,255,50 Guten Tag. Ihr scheint der Kommandant von Himendorf zu sein.", true)
	ASP("MajorP3",Mj3,"@color:20,255,50 Korrekt. Meine Truppen gehorchen sämtlichen Befehlen von mir. Aber kommen wir zur Sache: Was wollt ihr hier?", true)
	ASP("Ari",Ari,"@color:20,255,50 Ich hörte, dass ihr nicht gut auf Trogteburg zu sprechen seid und wollte euch davon überzeugen, dass ihr mit Trogteburg als Verbündete viele Probleme lösen könntet!", false)
	ASP("MajorP3",Mj3,"@color:20,255,50 So? Und wie stellt sich das der Bürgermeister Trogteburgs vor? Wir werden uns nicht einfach so ihm anschließen!", true)
	ASP("MajorP3",Mj3,"@color:20,255,50 Zahlt mir in seinem Namen einen Haufen Taler, damit ich meine Armee noch weiter ausbauen kann.", false)
	ASP("MajorP3",Mj3,"@color:20,255,50 Erst dann reden wir weiter. Und jetzt verschwindet!!", true)
	ASP("Ari",Ari,"@color:20,255,50 Wir sollten mit dem Verwalter der Schatzkammer von Trogteburg reden. @cr Vielleicht hilft er uns bei der Zahlung.", false)

    briefing.finished = function()
		Logic.AddQuest(1,4,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Himendorf auf eure Seite","@color:20,255,50 Zahlt den hohen Tribut von " .. dekaround(20000/gvDiffLVL) .. " Taler, damit Himendorf die Seiten wechselt. Redet mit dem Verwalter der Schatzkammer von Trogteburg. Vielleicht hilft er euch bei der Zahlung! ",1)
		Logic.AddQuest(2,4,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Himendorf auf eure Seite","@color:20,255,50 Zahlt den hohen Tribut von " .. dekaround(20000/gvDiffLVL) .. " Taler, damit Himendorf die Seiten wechselt. Redet mit dem Verwalter der Schatzkammer von Trogteburg. Vielleicht hilft er euch bei der Zahlung! ",1)
		HimenTribut()
		EnableNpcMarker("coiner")
		NPCs.coiner[1] = true
  	end
	StartBriefing(briefing)
end
function coiner()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("coiner",coin,"@color:20,255,50 Ah, ihr müsst Ari sein. Unser Bürgermeister hat mir bereits Bescheid gegeben, dass ihr die schwelenden Konflikte mit den umliegenden Dörfer lösen wollt. @cr Wart ihr erfolgreich?", true)
	ASP("Ari",Ari,"@color:20,255,50 Wie manns nimmt. Ich muss Himendorf " .. dekaround(20000/gvDiffLVL) .. " Taler zahlen, um sie freundlich zu stimmen.", true)
	ASP("Ari",Ari,"@color:20,255,50 Aber so viel Geld habe ich bei weitem nicht. Könnt ihr etwas beisteuern?", false)
	ASP("coiner",coin,"@color:20,255,50 Die Vorbereitungen auf den baldigen Krieg haben fast unseren sämtlichen Stadtschatz geraubt. Aber ich werde euch mit soviel wie möglich zur Seite stehen.", false)
	ASP("coiner",coin,"@color:20,255,50 Ich denke, mehr als " .. dekaround(2000*gvDiffLVL) .. " Taler sind wohl nicht drin. Den Rest werdet ihr selbst auftreiben müssen.", true)
	ASP("coiner",coin,"@color:20,255,50 Überall in Trogteburg liegen Vorratskisten rum. Nehmt euch ruhig deren Inhalt. Außerdem hörte ich davon, dass die Banditen einen großen Schatz besitzen. Leider - oder vielleicht doch zum Glück - sind sämtliche Wege versperrt...", false)

    briefing.finished = function()
		AddGold(1,dekaround(2000*gvDiffLVL))
  	end
	StartBriefing(briefing)
end

function HimenTribut()
	local Htribute =  {}
	Htribute.playerId = TributePID;
	Htribute.text = "Zahlt " .. dekaround(20000/gvDiffLVL) .. " Taler an Himendorf, um sie freundlich zu gesinnen!";
	Htribute.cost = {Gold = dekaround(20000/gvDiffLVL)};
	Htribute.Callback = Himenbezahlt;
	AddTribute( Htribute )
end
function Himenbezahlt()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("MajorP3",Mj3,"@color:230,0,0 Danke für die Zahlung. Ich weiß zwar nicht, wo ihr soviele Taler auftreiben konntet, aber das spielt auch keine Rolle..", true)
	ASP("MajorP3",Mj3,"@color:230,0,0 Ich hebe jetzt eine schön große Armee aus, und werde Trogteburg im Kampf zur Seite stehen.", false)
	briefing.finished = function()
		table.insert(VillageDipl.Friendly, 3)
		ActivateShareExploration(1,3,true)
		ActivateShareExploration(2,3,true)
		Logic.RemoveQuest(1,4)
		Logic.RemoveQuest(2,4)
	end
	StartBriefing(briefing)
end
function MajorP4()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("MajorP4",Mj4,"@color:20,255,50 Wer seid ihr und was wollt ihr hier?", true)
	ASP("Ari",Ari,"@color:20,255,50 Ich bin auf der Suche nach dem Kommandanten von Burghausen.", true)
	ASP("MajorP4",Mj4,"@color:20,255,50 Das bin dann wohl ich. Ich bin hier der Major dieser kleinen aber feinen Stadt.", false)
	ASP("Ari",Ari,"@color:20,255,50 Ich hörte, dass ihr so einige Ungereimtheiten mit Trogteburg habt und wollte euch fragen, was ich tun kann, um die Lage ein wenig zu entspannen.", true)
	ASP("MajorP4",Mj4,"@color:20,255,50 Hahaha, meint ihr das echt ernst? So eine Fehde kann man nicht einfach vergessen...", false)
	ASP("MajorP4",Mj4,"@color:20,255,50 ...es sei denn...", false)
	ASP("Eingang",Mj4,"@color:20,255,50 ...ihr baut für mich jeweils 2 Kanonentürme am Eingang ...", false)
	ASP("Ausgang",Mj4,"@color:20,255,50 ... am und Ausgang der Stadt.", false)

    briefing.finished = function()
		Logic.AddQuest(1,5,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Burghausen auf eure Seite","@color:20,255,50 Baut jeweils 2 Kanonentürme am Eingang und Ausgang von Burghausen! ",1)
		Logic.AddQuest(2,5,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Burghausen auf eure Seite","@color:20,255,50 Baut jeweils 2 Kanonentürme am Eingang und Ausgang von Burghausen! ",1)
		Gebietsmarker1 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,31800,3200)
		Gebietsmarker2 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,31800,1900)
		Gebietsmarker3 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,18800,8000)
		Gebietsmarker4 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,18500,6900)
		StartSimpleJob("Turmabfrage1")
		StartSimpleJob("Turmabfrage2")
		StartSimpleJob("Turmabfrage3")
		StartSimpleJob("Turmabfrage4")
		StartSimpleJob("P4Fertig")
  	end
	StartBriefing(briefing)
end
function Turmabfrage1()
	idTu1 = SucheAufDerWelt(1,Entities.PB_Tower3,500,{X = 31800, Y = 3200})
	if table.getn(idTu1) > 0 and Logic.IsConstructionComplete(idTu1[1]) == 1 then
		idTu1 = idTu1[1]
		ChangePlayer(idTu1,4)
		gvTu1 = 1
		Logic.DestroyEffect(Gebietsmarker1)
		return true
	end
	idTu1 = SucheAufDerWelt(2,Entities.PB_Tower3,500,{X = 31800, Y = 3200})
	if table.getn(idTu1) > 0 and Logic.IsConstructionComplete(idTu1[1]) == 1 then
		idTu1 = idTu1[1]
		ChangePlayer(idTu1,4)
		gvTu1 = 1
		Logic.DestroyEffect(Gebietsmarker1)
		return true
	end
end
function Turmabfrage2()
	idTu2 = SucheAufDerWelt(1,Entities.PB_Tower3,500,{X = 31800, Y = 1900})
	if table.getn(idTu2) > 0 and Logic.IsConstructionComplete(idTu2[1]) == 1 then
		idTu2 = idTu2[1]
		ChangePlayer(idTu2,4)
		gvTu2 = 1
		Logic.DestroyEffect(Gebietsmarker2)
		return true
	end
	idTu2 = SucheAufDerWelt(2,Entities.PB_Tower3,500,{X = 31800, Y = 1900})
	if table.getn(idTu2) > 0 and Logic.IsConstructionComplete(idTu2[1]) == 1 then
		idTu2 = idTu2[1]
		ChangePlayer(idTu2,4)
		gvTu2 = 1
		Logic.DestroyEffect(Gebietsmarker2)
		return true
	end
end
function Turmabfrage3()
	idTu3 = SucheAufDerWelt(1,Entities.PB_Tower3,500,{X = 18800, Y = 8000})
	if table.getn(idTu3) > 0 and Logic.IsConstructionComplete(idTu3[1]) == 1 then
		idTu3 = idTu3[1]
		ChangePlayer(idTu3,4)
		gvTu3 = 1
		Logic.DestroyEffect(Gebietsmarker3)
		return true
	end
	idTu3 = SucheAufDerWelt(2,Entities.PB_Tower3,500,{X = 18800, Y = 8000})
	if table.getn(idTu3) > 0 and Logic.IsConstructionComplete(idTu3[1]) == 1 then
		idTu3 = idTu3[1]
		ChangePlayer(idTu3,4)
		gvTu3 = 1
		Logic.DestroyEffect(Gebietsmarker3)
		return true
	end
end
function Turmabfrage4()
	idTu4 = SucheAufDerWelt(1,Entities.PB_Tower3,500,{X = 18500, Y = 6900})
	if table.getn(idTu4) > 0 and Logic.IsConstructionComplete(idTu4[1]) == 1 then
		idTu4 = idTu4[1]
		ChangePlayer(idTu4,4)
		gvTu4 = 1
		Logic.DestroyEffect(Gebietsmarker4)
		return true
	end
	idTu4 = SucheAufDerWelt(2,Entities.PB_Tower3,500,{X = 18500, Y = 6900})
	if table.getn(idTu4) > 0 and Logic.IsConstructionComplete(idTu4[1]) == 1 then
		idTu4 = idTu4[1]
		ChangePlayer(idTu4,4)
		gvTu4 = 1
		Logic.DestroyEffect(Gebietsmarker4)
		return true
	end
end
function P4Fertig()
	if gvTu1 == 1 and gvTu2 == 1 and gvTu3 == 1 and gvTu4 == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		Logic.RemoveQuest(1,5)
		Logic.RemoveQuest(2,5)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("MajorP4",Mj4,"@color:230,0,0 Das habt ihr gut gemacht.", true)
		ASP("MajorP4",Mj4,"@color:230,0,0 Als Dank werden wir Trogteburg nicht belagern.", true)
		briefing.finished = function()
			table.insert(VillageDipl.Friendly, 4)
			ActivateShareExploration(1,4,true)
			ActivateShareExploration(2,4,true)
		end
		StartBriefing(briefing)
		return true
	end
end

function MajorP5()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Ari",Ari,"@color:20,255,50 Guten Tag. Der Bürgermeister von Trogteburg schickt mich, um euch zu helfen.", true)
	ASP("MajorP5",Mj5,"@color:20,255,50 Der Bürgermeister von Trogteburg?...schickt Hilfe??...Und das nachdem er versucht hat, alle unsere Rohstoffe zu stehlen?", false)
	ASP("MajorP5",Mj5,"@color:20,255,50 Bereits seit geraumer Zeit drängt er meine schöne Stadt Meter für Meter in diese Schlucht zurück.", false)
	ASP("MajorP5",Mj5,"@color:20,255,50 Warum sollte ich euch trauen? Das ist doch bestimmt eine dieser Finten des Bürgermeisters, um uns weiter zu verdrängen.", false)
	ASP("Ari",Ari,"@color:20,255,50 Neinnein. Ich bin zwar als Banditin nicht grade die Vertrauenswürdigste, kann euch aber versichern, dass Dario, der König mich entsandt hat, um den Dörfern und Städten hier zu helfen.", true)
	ASP("MajorP5",Mj5,"@color:20,255,50 Nun gut. Ich gebe euch eine Chance, eure Absichten zu beweisen. Baut die Minen des mit Trogteburg heiß umkämpften Steinbruchgebiet, um zu zeigen, dass sie uns wirklich helfen wollen.", false)
	ASP("StoneMine",Mj5,"@color:20,255,50 Die besagte Steinmine liegt dort hinten, gleich nahe unserer Siedlung.", false)

    briefing.finished = function()
		Logic.AddQuest(1,7,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Reiterhusen auf eure Seite","@color:20,255,50 Baut drei Steinbergwerke nahe Reiterhusen! ",1)
		Logic.AddQuest(2,7,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Reiterhusen auf eure Seite","@color:20,255,50 Baut drei Steinbergwerke nahe Reiterhusen! ",1)
		StartSimpleJob("Steinabfrage1")
		StartSimpleJob("Steinabfrage2")
		StartSimpleJob("Steinabfrage3")
		StartSimpleJob("SteinFertig")
		Gebietsmarker5 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,10600,31400)
		Gebietsmarker7 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,11900,33200)
		Gebietsmarker8 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,17100,34400)
		P5Stein = 0
  	end
	StartBriefing(briefing)
end
function Steinabfrage1()
	local idSM = SucheAufDerWelt(1,Entities.PB_StoneMine3,400,GetPosition("StoneMine"))
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker5)
		P5Stein = P5Stein + 1
		return true
	end
	local idSM = SucheAufDerWelt(2,Entities.PB_StoneMine3,400,GetPosition("StoneMine"))
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker5)
		P5Stein = P5Stein + 1
		return true
	end
end
function Steinabfrage2()
	local idSM = SucheAufDerWelt(1,Entities.PB_StoneMine3,400,{X = 11900, Y = 33200})
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker7)
		P5Stein = P5Stein + 1
		return true
	end
	local idSM = SucheAufDerWelt(2,Entities.PB_StoneMine3,400,{X = 11900, Y = 33200})
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker7)
		P5Stein = P5Stein + 1
		return true
	end
end
function Steinabfrage3()
	local idSM = SucheAufDerWelt(1,Entities.PB_StoneMine3,400,{X = 17100, Y = 34400})
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker8)
		P5Stein = P5Stein + 1
		return true
	end
	local idSM = SucheAufDerWelt(2,Entities.PB_StoneMine3,400,{X = 17100, Y = 34400})
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		ChangePlayer(idSM,5)
		Logic.DestroyEffect(Gebietsmarker8)
		P5Stein = P5Stein + 1
		return true
	end
end
function SteinFertig()
	if P5Stein >= 3 then
		P5Fertig()
		return true
	end
end
function P5Fertig()
	Sound.PlayGUISound(Sounds.fanfare,90)
    Logic.RemoveQuest(1,7)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP5",Mj5,"@color:230,0,0 Saubere Arbeit. Da kann man echt nicht motzen", false)
	ASP("MajorP5",Mj5,"@color:230,0,0 Als Dank werden wir unsere Fehde mit Trogteburg erst einmal vergessen.", false)
	briefing.finished = function()
		ActivateShareExploration(1,5,true)
		ActivateShareExploration(2,5,true)
		table.insert(VillageDipl.Friendly, 5)
	end;
	StartBriefing(briefing)
	return true
end

function MajorP6()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Ari",Ari,"@color:20,255,50 Guten Tag. Seid ihr der Bürgermeister hier?", true)
	ASP("MajorP6",Mj6,"@color:20,255,50 Psst, nicht zu laut. Ich bin der Oberschurke hier, aber sagt das bloß keinem.", true)
	ASP("Ari",Ari,"@color:20,255,50 Ähh ja, wie auch immer. Ich wollte mich nur zu der Lage zu Trogteburg hier erkundigen.", false)
	ASP("MajorP6",Mj6,"@color:20,255,50 Diese Banausen haben mich und meine Leute bei unserer ehrbaren Arbeit gestört. Nirgends kann man vernüftig seiner Arbeit nachgehen. Wenn die Banditen Trogteburg angreifen, werden wir sie unterstützen und Trogteburg wird brennen!", true)
	ASP("Ari",Ari,"@color:20,255,50 Hmm, ich mache euch einen Vorschlag. Ich habe gehört, dass die Banditen einen großen Schatz horten.", false)
	ASP("Ari",Ari,"@color:20,255,50 Trogteburg hingegen ist fast pleite und wenn ihr uns unterstützt, überlassen wir euch den Schatz.", false)
	ASP("MajorP6",Mj6,"@color:20,255,50 Und wer garantiert mir die Existenz dieses Schatzes?", false)
	ASP("Ari",Ari,"@color:20,255,50 Ihr könnt die Banditen doch problemlos beschatten und euch selber davon überzeugen, dass er existiert.", false)
	ASP("MajorP6",Mj6,"@color:20,255,50 Das klingt in der Tat nach einem Plan. Aber ich traue niemanden. Überredet zuerst den Städteplaner von Trogteburg, dass er mir eines seiner Wirtshäuser überlasst.", false)
	ASP("MajorP6",Mj6,"@color:20,255,50 Quasi als Zeichen der guten Absicht.", false)

    briefing.finished = function()
		Logic.AddQuest(1,6,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Kleinsuhlendorf auf eure Seite","@color:20,255,50 Bringt Trogteburg dazu, eine ihrer Tavernen an den Oberschurken zu verschenken, als Zeichen der guten Absicht!",1)
		Logic.AddQuest(2,6,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Kleinsuhlendorf auf eure Seite","@color:20,255,50 Bringt Trogteburg dazu, eine ihrer Tavernen an den Oberschurken zu verschenken, als Zeichen der guten Absicht!",1)
		EnableNpcMarker(GetEntityId("Planner"))
		NPCs.Planner[1] = true
  	end
	StartBriefing(briefing)
end
function Planner()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Planner",cplan,"@color:20,255,50 Ah, ihr müsst Ari sein. @cr In der Stadt seit ihr aktuell das Gesprächsthema Nr. 1. @cr Aber ich schweife ab. Was führt Euch zu mir?", false)
	ASP("Ari",Ari,"@color:20,255,50 Naja. Kleinsuhlendorfs Anführer, der Oberschurke, scheint nicht gut auf euch zu sprechen zu sein.", false)
	ASP("Ari",Ari,"@color:20,255,50 Ich habe es aber trotzdem geschafft, ihn zu besänftigen und er wäre bereit, einen Deal einzugehen.", false)
	ASP("Planner",cplan,"@color:20,255,50 Das zeigt einmal wieder von eurem Verhandlungsgeschick und eurer Menschenkenntnis. Ihr müsst wissen, dass wir den Oberschurken und einige Untergebenen beim Schmuggeln und Stehlen erwischt haben und mehrere Wochen öffentlich gedemütigt haben...", false)
	ASP("Planner",cplan,"@color:20,255,50 Aber ich schweife erneut ab. Was verlangt er?", false)
	ASP("Ari",Ari,"@color:20,255,50 Ein Wirtshaus als Zeichen euerer Wertschätzung und Untergebung", false)
	ASP("Planner",cplan,"@color:20,255,50 Untergebung niemals, aber über ein Wirtshaus lässt sich reden. Das als Gegenleistung zum Frieden ist ein fairer Deal. Soll er das Wirtshaus bekommen!", false)
    briefing.finished = function()
		ChangePlayer("Wirtshaus",6)
		P6Danksagung()
  	end
	StartBriefing(briefing)
end
function P6Danksagung()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Wirtshaus",Mj6,"@color:230,0,0 Oh, danke für das Wirtshaus. Dort werden wir unsere nächsten Raubzüü...-ähh Trinkabende gestalten.", false)
	ASP("MajorP6",Mj6,"@color:230,0,0 Wenn ich recht drüber nachdenke, reicht uns das aber noch nicht...", false)
	ASP("MajorP6",Mj6,"@color:230,0,0 Nordwestlich von hier befindet sich ein alter verlassener Leuchtturm. Mit dem hätten wir einen wunderbaren Blick auf Trogteburg. @cr Nicht dass die uns noch in den Rücken fallen...", false)
	briefing.finished = function()
		Logic.RemoveQuest(1,6)
		Logic.RemoveQuest(2,6)
		Logic.AddQuest(1,6,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Kleinsuhlendorf auf eure Seite","@color:20,255,50 Baut den Leuchtturm nordwestlich von Kleinsuhlendorf.",1)
		Logic.AddQuest(2,6,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Kleinsuhlendorf auf eure Seite","@color:20,255,50 Baut den Leuchtturm nordwestlich von Kleinsuhlendorf.",1)
		StartSimpleJob("LighthouseCheck")
	end
	StartBriefing(briefing)
end
function LighthouseCheck()
	local idLH = SucheAufDerWelt(1,Entities.CB_LighthouseActivated,1000,{X = 20500, Y = 25600})
	if table.getn(idLH) > 0 and Logic.IsConstructionComplete(idLH[1]) == 1 then
		idLH = idLH[1]
		ChangePlayer(idLH,6)
		P6Danksagung2()
		return true
	end
	local idLH = SucheAufDerWelt(2,Entities.CB_LighthouseActivated,1000,{X = 20500, Y = 25600})
	if table.getn(idLH) > 0 and Logic.IsConstructionComplete(idLH[1]) == 1 then
		idLH = idLH[1]
		ChangePlayer(idLH,6)
		P6Danksagung2()
		return true
	end
end
function P6Danksagung2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP6",Mj6,"@color:230,0,0 Sehr gute Arbeit. @cr So kann uns Trogteburg nicht mehr überraschend in den Rücken fallen. @cr In der Hisicht sollten wir abgesichert sein.", false)
	ASP("MajorP6",Mj6,"@color:230,0,0 Wir werden im Kampf die Banditen bekämpfen. Die Existenz des Schatzes hat sich bewährt. Aber wehe, ihr raubt den Schatz, bevor wirs tun.", true)
	briefing.finished = function()
		Logic.RemoveQuest(1,6)
		Logic.RemoveQuest(2,6)
		ActivateShareExploration(1,6,true)
		ActivateShareExploration(2,6,true)
		table.insert(VillageDipl.Friendly, 6)
	end
	StartBriefing(briefing)
end

function MajorP7()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("MajorP7",Mj7,"@color:20,255,50 Ohh, ein Besucher. Das ist aber echt selten in dieser Gegend.", true)
	ASP("MajorP7",Mj7,"@color:20,255,50 Könntet ihr mir bitte sagen, wer ihr seid und was ihr hier wollt? Schließlich verirren sich nicht viele hierher, da muss man einfach misstrauisch sein.", true)
	ASP("Ari",Ari,"@color:20,255,50 Ich komme in königlicher Mission, um die Gleichgewichte zwischen Trogteburg und den umliegenden Dörfern wiederherzustellen und um den Frieden zu wahren.", false)
	ASP("Ari",Ari,"@color:20,255,50 Es ist euch bestimmt auch schon aufgefallen, dass sie Banditen sich sammeln und Trogteburg vernichten wollen.", true)
	ASP("MajorP7",Mj7,"@color:20,255,50 Wenn ich ehrlich bin, nein. Wir sind in diesem Moorgebiet so abgeschieden, dass ich von Banditen nichts erfahren habe.", false)
	ASP("MajorP7",Mj7,"@color:20,255,50 Allerdings werde ich euch nicht weiterhelfen können. Trogteburg hat uns tief beleidigt, dass sie uns sämtliche Rohstoffe vorenthalten und nicht mit uns handeln wollen. Sie nannten uns sogar mehrfach <<zurückgebliebene Sumpfbarbaren>>", false)
	ASP("Ari",Ari,"@color:20,255,50 Da liegt bestimmt ein Missverständnis vor. Die hinterlistigen Banditen haben sich bestimmt als Gesandte Trogteburgs ausgegeben, um euch hinter dem Rücken des Bürgermeisters zu erzürnen.", false)
	ASP("MajorP7",Mj7,"@color:20,255,50 Das hört sich echt weit hergeholt an! Aber euer Enthusiasmus gefällt mir.", false)
	ASP("LehmMine",Mj7,"@color:20,255,50 Baut die Lehmmine dort hinten und ich werde meine Meinung vielleicht ändern. Dazu muss Trogteburg sich natürlich noch entschuldigen und einige Präsente hinterlassen.", false)
	ASP("Ari",Ari,"@color:20,255,50 Ich werde es ihm ausrichten.", false)

    briefing.finished = function()
		if not NPCs.MajorP8[1] then
			EnableNpcMarker(GetEntityId("MajorP8"))
			NPCs.MajorP8 = {true, "P7Entschuldigung"}
		else
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","QueuedBriefing",1,{},{"MajorP8", "P7Entschuldigung"})
		end
		Logic.AddQuest(1,8,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Swammheim auf eure Seite","@color:20,255,50 Baut ein Lehmbergwerk an der vorgesehenen Stelle nahe Swammheim! Ein Entschudigungsschreiben an die Prinzessin seitens Trogteburg muss verfasst und versendet werden!",1)
		Logic.AddQuest(2,8,SUBQUEST_OPEN,"@color:20,255,50 Gewinnt Swammheim auf eure Seite","@color:20,255,50 Baut ein Lehmbergwerk an der vorgesehenen Stelle nahe Swammheim! Ein Entschudigungsschreiben an die Prinzessin seitens Trogteburg muss verfasst und versendet werden!",1)
		StartSimpleJob("Lehmabfrage")
		StartSimpleJob("P7Fertig")
		Gebietsmarker6 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,48804,57473)
  	end
	StartBriefing(briefing)
end

function P7Entschuldigung()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("MajorP8",Mj8,"@color:20,255,50 Ari, ihr seid erneut da. Wie lief es?", true)
	ASP("Ari",Ari,"@color:20,255,50 Nicht allzu gut. Die Prinzessin von Swammheim erzählte mir, ihr habt sie verhöhnt und sämtlichem Handel ausgeschlossen.", false)
	ASP("MajorP8",Mj8,"@color:20,255,50 Das kann nicht sein. Wir wollten mit ihnen handeln, aber ein Abgesandter erzählte mir, sie wollen nichts mit uns zu tun haben.", false)
	ASP("Ari",Ari,"@color:20,255,50 Das ist doch ein abgekartertes Spiel. Jemand hat sie gegen uns aufgebracht. Bestimmt stecken die Banditen dahinter.", false)
	ASP("MajorP8",Mj8,"@color:20,255,50 Und, was sollen wir jetzt machen Ari, die Zeit läuft gegen uns!?", true)
	ASP("Ari",Ari,"@color:20,255,50 Schicke einen Boten nach Swammheim. Er muss sich unbedingt als Trogteburger Bote erkenntlich machen, geb ihm am Besten ein wertvolles Artefakt von hier als Geschenk mit!", false)
	ASP("Ari",Ari,"@color:20,255,50 Bereite eine Entschuldigungsrede für ihn vor! Ich baue derweil für die Prinzessin ein Lehmbergwerk. Dann können wir nur noch hoffen!", true)
	ASP("MajorP8",Mj8,"@color:20,255,50 Danke, dass du das alles für uns tust, Ari. Ohne dich wären wir verloren. Ich werde mich beeilen.", true)

	briefing.finished = function()
		StartCountdown(30,Schreibenfertig,false)
		StartSimpleJob("Botenabfrage")
  	end
	StartBriefing(briefing)
end
function Schreibenfertig()
	Message("@color:20,255,50 Der Bote macht sich jetzt auf den Weg nach Swammheim")
	Move("Bote","MajorP7")
end
function Botenabfrage()
	if IsNear("Bote","MajorP7",800) then
		Message("@color:20,255,50 Der Bote trägt nun seine Rede vor. Hoffen wir, dass die Prinzessin die Entschuldigung annimmt.")
		StartCountdown(15,Redefertig,false)
		return true
	end
end
function Redefertig()
	Dank = 1
end
function Lehmabfrage()
	idLM = SucheAufDerWelt(1,Entities.PB_ClayMine3,1000,GetPosition("LehmMine"))
	if table.getn(idLM) > 0 and Logic.IsConstructionComplete(idLM[1]) == 1 then
		idLM = idLM[1]
		ChangePlayer(idLM,7)
		gvLM = 1
		Logic.DestroyEffect(Gebietsmarker6)
		return true
	end
	idLM = SucheAufDerWelt(2,Entities.PB_ClayMine3,1000,GetPosition("LehmMine"))
	if table.getn(idLM) > 0 and Logic.IsConstructionComplete(idLM[1]) == 1 then
		idLM = idLM[1]
		ChangePlayer(idLM,7)
		gvLM = 1
		Logic.DestroyEffect(Gebietsmarker6)
		return true
	end
end
function P7Fertig()
	if gvLM == 1 and Dank == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		Logic.RemoveQuest(1,8)
		Logic.RemoveQuest(2,8)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("MajorP7",Mj7,"@color:230,0,0 Ohh, welch eine schöne Mine und so eine tolle Entschuldigungsrede.", true)
		ASP("MajorP7",Mj7,"@color:230,0,0 Als Dankeschön werden wir Trogteburg natürlich nicht nur nicht angreifen, sondern mit euch gemeinsam die Banditen bekämpfen.", true)
		ASP("7",Mj7,"@color:230,0,0 Wundert euch aber nicht, wenn meine Truppen etwas Zeit benötigen. Sie sind nicht allzu kampferfahren.", false)
		briefing.finished = function()
			ActivateShareExploration(1,7,true)
			ActivateShareExploration(2,7,true)
			table.insert(VillageDipl.Friendly, 7)
		end
		StartBriefing(briefing)
		return true
	end
end
function Merchant()

	local mercenaryId = Logic.GetEntityIDByName("camp")
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderRifle2, 9, ResourceType.Sulfur, dekaround(900/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_Thief, 9, ResourceType.Gold, dekaround(500/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow3, 99, ResourceType.Iron, dekaround(600/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow4, 9, ResourceType.Iron, dekaround(900/gvDiffLVL))

end

--**********Abschnitt  Comfortfunctionen:**********--
function QueuedBriefing(_name, _callback)
	if not NPCs[_name][1] then
		EnableNpcMarker("MajorP8")
		NPCs[_name] = {true, _callback}
		return true
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
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end
--**
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
                                 _v1.action(unpack(_v1.parameters));                     --910
                             else
                                 _v1.action(_v1.parameters);
                             end
                         end

                         Briefing_ExtraOrig( _v1, _v2 );
                     end;

    GameCallback_EscapeOrig = GameCallback_Escape;
    StartBriefingOrig = StartBriefing;
    EndBriefingOrig = EndBriefing;
    MessageOrig = Message;
    CreateNPCOrig = CreateNPC;

    StartBriefing = function(_briefing)
                        assert(type(_briefing) == "table");
                        if _briefing.noEscape then
                            GameCallback_Escape = function() end;
                            briefingState.noEscape = false;
                        end

                        StartBriefingOrig(Umlaute(_briefing));
                    end

    EndBriefing = function()
                      if briefingState.noEscape then
                          GameCallback_Escape = GameCallback_EscapeOrig;
                          briefingState.noEscape = nil;
                      end

                      EndBriefingOrig();
                  end;

    Message = function(_text)
                  MessageOrig(Umlaute(tostring(_text)));
              end;

	BugUmlaut = function(_text)
                  local texttype = type(_text);
                  if texttype == "string" then
                      _text = string.gsub( _text, "ä", "ae" );
                      _text = string.gsub( _text, "ö", "oe" );
                      _text = string.gsub( _text, "ü", "ue" );
                      _text = string.gsub( _text, "ß", "ss" );
                      _text = string.gsub( _text, "Ä", "Ae" );
                      _text = string.gsub( _text, "Ö", "Oe" );
                      _text = string.gsub( _text, "Ü", "Ue" );
                      return _text;
                  elseif texttype == "table" then
                      for k, v in _text do
                          _text[k] = Umlaute( v );
                      end
                      return _text;
                  else return _text;
                  end
              end;

    CreateNPC = function(_npc)
                    CreateNPCOrig(Umlaute(_npc));
                end;

Umlaute = function(_text)
                  local texttype = type(_text);
                  if texttype == "string" then
                      _text = string.gsub( _text, "ä", "\195\164" );
                      _text = string.gsub( _text, "ö", "\195\182" );
                      _text = string.gsub( _text, "ü", "\195\188" );
                      _text = string.gsub( _text, "ß", "\195\159" );
                      _text = string.gsub( _text, "Ä", "\195\132" );
                      _text = string.gsub( _text, "Ö", "\195\150" );
                      _text = string.gsub( _text, "Ü", "\195\156" );
                      return _text;
                  elseif texttype == "table" then
                      for k, v in _text do
                          _text[k] = Umlaute( v );
                      end
                      return _text;
                  else return _text;
                  end
              end;
end
--**
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
--**
function SucheAufDerWelt(_player, _entity, _groesse, _punkt)
	local punktX1, punktX2, punktY1, punktY2, data
	local gefunden = {}
	local rueck
	if not _groesse then
		_groesse = Logic.WorldGetSize()
	end
	if not _punkt then
		_punkt = {X = _groesse/2, Y = _groesse/2}
	end
	if _player == 0 then
		data ={Logic.GetEntitiesInArea(_entity, _punkt.X, _punkt.Y, math.floor(_groesse * 0.71), 16)}
	else
		data ={Logic.GetPlayerEntitiesInArea(_player,_entity, _punkt.X, _punkt.Y, math.floor(_groesse * 0.71), 16)}
	end
	if data[1] >= 16 then
		local _klgroesse = _groesse / 2
		local punktX1 = _punkt.X - _groesse / 4
		local punktX2 = _punkt.X + _groesse / 4
		local punktY1 = _punkt.Y - _groesse / 4
		local punktY2 = _punkt.Y + _groesse / 4
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX1,Y=punktY1})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX1,Y=punktY2})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX2,Y=punktY1})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX2,Y=punktY2})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
	else
		table.remove(data,1)
		for i = 1, table.getn(data) do
			if not IstDrin(data[i], gefunden) then
				table.insert(gefunden, data[i])
			end
		end
	end
	return gefunden
end
--**
function IstDrin(_wert, _table)
	for i = 1, table.getn(_table) do
		if _table[i] == _wert then
			return true
		end
	end
	return false
end
PlayerEntitiesInvulnerable_IsActive = {}
function MakePlayerEntitiesInvulnerableLimitedTimeNearPosition(_PlayerID, _Position, _Range, _Timelimit)
	_Timelimit = round(_Timelimit)
	if not Counter.Tick2("MakePlayerEntitiesInvulnerableLimitedTime_Ticker".. _PlayerID, _Timelimit) then
		if not PlayerEntitiesInvulnerable_IsActive[_PlayerID] then
			PlayerEntitiesInvulnerable_IsActive[_PlayerID] = {true, IDs = {}}
			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(_PlayerID), CEntityIterator.IsSettlerOrBuildingFilter(), CEntityIterator.InCircleFilter(_Position.X, _Position.Y, _Range)) do
				if Logic.IsEntityAlive(eID) then
					MakeInvulnerable(eID)
					table.insert(PlayerEntitiesInvulnerable_IsActive[_PlayerID].IDs, eID)
				end
			end
		end
	else
		for i = 1, table.getn(PlayerEntitiesInvulnerable_IsActive[_PlayerID].IDs) do
			local id = PlayerEntitiesInvulnerable_IsActive[_PlayerID].IDs[i]
			if Logic.IsEntityAlive(id) then
				MakeVulnerable(id)
			end
		end
		PlayerEntitiesInvulnerable_IsActive[_PlayerID] = nil
		return true
	end
end