--------------------------------------------------------------------------------
-- MapName: Achte Prüfung - Shering in Gefahr
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Achte Prüfung - Shering in Gefahr "
gvMapVersion = " v1.73"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	if CNetwork then
		TributePID = 2
	else
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		TributePID = 1
	end
	--
	--Init_TrackAndLogMovements()
	-- Init  global MP stuff
	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	end
	InitDiplomacy()

	-- custom Map Stuff
	AddPeriodicSummer(10)
	StartTechnologies()
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

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
function Init_TrackAndLogMovements()

	ENTITY_LIST_FOR_TRACKING = {}
	for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerFilter()) do
		table.insert(ENTITY_LIST_FOR_TRACKING, eID)
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfClassFilter(7835516)) do
		table.insert(ENTITY_LIST_FOR_TRACKING, eID)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "OnSettlerOrAnimalCreated", 1)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSettlerOrAnimalDestroyed", 1)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "LogPositions", 1)
end
function OnSettlerOrAnimalCreated()

	local entityID = Event.GetEntityID()

	if Logic.IsSettler(entityID) == 1 or CUtil.GetEntityClass(entityID) == 7835516 then
		table.insert(ENTITY_LIST_FOR_TRACKING, entityID)
	end
end
function OnSettlerOrAnimalDestroyed()

	local entityID = Event.GetEntityID()

	if Logic.IsSettler(entityID) == 1 or CUtil.GetEntityClass(entityID) == 7835516 then
		removetablekeyvalue(ENTITY_LIST_FOR_TRACKING, entityID)
	end
end
function LogPositions()
	if next(ENTITY_LIST_FOR_TRACKING) then
		for i = 1, table.getn(ENTITY_LIST_FOR_TRACKING) do
			local id = ENTITY_LIST_FOR_TRACKING[i]
			local x, y = Logic.GetEntityPosition(id)
			CLogger.Log(id, x, y, Logic.GetEntityTypeName(Logic.GetEntityType(id)))
		end
	end
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
	gvDiffLVL = 2.7

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
	ResearchAllTechnologies(8, false, false, false, true, false)
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
	gvDiffLVL = 1.9

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
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
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function FarbigeNamen()
	orange 	= "@color:255,127,0"
	lila 	= "@color:250,0,240"

    QB    	= ""..orange.." Quest - Beschreibung "..lila..""
    Dario   = ""..orange.." Dario "..lila..""
    Fa      = ""..orange.." Dubioser Farmer Korni "..lila..""
    Jo      = ""..orange.." Bruder Johannes "..lila..""
    Di      = ""..orange.." Samy der Meisterdieb "..lila..""
	He		= ""..orange.." Helias "..lila..""
	SC 		= ""..orange.." Anführer der Ausgestoßenen "..lila..""
	GG		= ""..orange.." Torwächter "..lila..""
	set 	= ""..orange.."	Siedler "..lila..""
	miner	= ""..orange.." Verängstigter Bergmann "..lila..""
	saw		= ""..orange.." Verängstigter Sägewerker "..lila..""
	men  	= ""..orange.." Erzähler "..lila..""
	tr		= ""..orange.." Händler "..lila..""
	monk 	= ""..orange.." Mönch "..lila..""
	alch 	= ""..orange.." Alchemist "..lila..""
	--
	cap 	= ""..orange.." Anführer der Streitkräfte Sherings "..lila..""
	sc 		= ""..orange.." Spähtruppe E13A67 "..lila..""

end
NPCs = {["Farmer"] = {false, "Farmer"},
		["Johannes"] = {false, "Johannes"},
		["Dieb"] = {false, "Dieb"},
		["Helias"] = {true, "Helias"},
		["south_chief"] = {false, "south_chief"},
		["GateGuard"] = {false, "GateGuard"},
		["settler"] = {false, "settler"},
		["afraid_miner"] = {false, "afraid_miner"},
		["afraid_sawmiller"] = {false, "afraid_sawmiller"},
		["settler2"] = {false, "settler2"},
		["Trader1"] = {false, "Trader1"},
		["Trader2"] = {false, "Trader2"},
		["monk"] = {false, "Monk"},
		["alchemist"] = {false, "alchemist"},
		["captain"] = {false, "captain"}
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
function AnfangsBriefing()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("SherBurg",QB,"@color:230,0,0 Im hohen Norden befinden sich mehrere Grafschaften Darios Bekannter im Krieg!", false)
	ASP("Village",QB,"@color:230,0,0 Steht ihnen bei und vernichtet die beiden feindlichen Burgen.", false)
	AP{
		title = QB,
		text = "@color:230,0,0 Die eine liegt im Banditenlager im Süden!",
		position = GetPosition("Burg2"),
		marker = STATIC_MARKER,
		dialogCamera = false,
	}
	AP{
		title = QB,
		text = "@color:230,0,0 Und die andere liegt auf einem Plateau im Südosten!",
		position = GetPosition("Burg1"),
		marker = STATIC_MARKER,
		dialogCamera = false,
	}
	ASP("Dario",Dario,"@color:230,0,0 Lasst uns beeilen, bevor die Siedlungen unserer Freunde vollständig vernichtet werden!", false)

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

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero1", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero6", 0)
	XGUIEng.ShowWidget("BuyHeroWindowBuyHero9", 0)
	MapEditor_SetupAI(3, 3, 15000, 3, "SherBurg", 3, 0)
	StartSimpleJob("NPCControl")
	SetFriendly(1,3)
	SetFriendly(2,3)
	CreateShering()
	StartSimpleJob("Sieg")
	StartSimpleJob("Niederlage")
	Ally = 0
	StartCountdown((15*gvDiffLVL-5)*60, FriedensEnde, true)
	StartCountdown((15*gvDiffLVL-5)*0.8*60, AIStart, false)
	EnableNpcMarker(GetEntityId("Helias"))
	StartSimpleJob("NewAlly")
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
	end
	InitResources()
	InitTechnologies()
	if gvChallengeFlag and CNetwork then
		local ischeating, desc = IsUsingRules(required, optional, 3);
		if ischeating then
			Message("Mit diesen in der Lobby eingestellten Regeln ist der Erhalt der Belohnung nicht möglich! @cr @cr "..unpack(desc))
		end
	end
	for i = 1,4 do
		CreateArmyP4(i)
	end
	for i = 1,6 do
		CreateArmyNV(i)
	end
	for i = 1,2 do
		Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity, 47100-i, 5200-i, 0, i), 7)
		Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity, 18400-i, 8000-i, 0, i), 7)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(3,"Burg Shering")
	SetPlayerName(4,"Bergvolk")
	SetPlayerName(5,"Burg Banheim")
	SetPlayerName(7,"Landvolk")
	--
	SetHostile(1,4)
	SetHostile(2,4)
	SetHostile(3,4)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
	for i = 1,2 do
		AddGold  (i, dekaround(800*gvDiffLVL))
		AddSulfur(i, 0)
		AddIron  (i, 0)
		AddWood  (i, dekaround(1000*gvDiffLVL))
		AddStone (i, dekaround(800*gvDiffLVL))
		AddClay  (i, dekaround(1000*gvDiffLVL))
	end
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.GT_Mathematics, i)
		ForbidTechnology(Technologies.GT_Binocular, i)
		ForbidTechnology(Technologies.GT_Matchlock, i)
		ForbidTechnology(Technologies.GT_PulledBarrel, i)
		ForbidTechnology(Technologies.GT_Chemistry, i)
		ForbidTechnology(Technologies.GT_Library, i)
		ForbidTechnology(Technologies.GT_Banking, i)
		ForbidTechnology(Technologies.GT_Laws, i)
		ForbidTechnology(Technologies.GT_Gilds, i)
	end
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

	for i = 4,6 do
		Display.SetPlayerColorMapping(i, 2)
	end
	Display.SetPlayerColorMapping(7, NPC_COLOR)
	Display.SetPlayerColorMapping(8, 3)
	FarbigeNamen()

end
function Tribute()
	local tribute =  {}
	tribute.playerId = TributePID;
	tribute.text = "@color:230,0,0 Zahlt " .. dekaround(12000/gvDiffLVL) .. " Taler, um die Gesetzlosen eurer befreundeten Grafschaften zu Hilfe zu rufen.";
	tribute.cost = {Gold = dekaround(12000/gvDiffLVL)};
	tribute.Callback = PayedTributeP3;
	BanditT = AddTribute( tribute )
end
function PayedTributeP3()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("south_chief",SC,"@color:230,0,0 Die Gesetzlosen wurden bezahlt. Wir werden euch nun im Kampf zur Seite stehen! ", false)
	briefing.finished = function()
		Gesetzlose()
	end
	StartBriefing(briefing)
end
function Gesetzlose()
	for i = 1,6 do
		CreateArmyP3(i)
	end
end
function CreateArmyP3(_index)
	if not IsExisting("Zelt" .. _index) then
		return
	end
	local army	= {}
    army.player = 3
    army.id 	= _index
    army.strength = math.ceil(3*gvDiffLVL)
    army.position = GetPosition("Zelt" .. _index)
    army.rodeLength = 10000
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, math.ceil(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, math.floor(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local building = "Zelt" .. _index

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyP3",1,{},{army.id, building})

end

function ControlArmyP3(_army, _building)

	local army = ArmyTable[3][_army+1]
    if IsDead(army) and IsExisting(_building) then
		if Counter.Tick2("ArmyP3_Respawn" .. _army, round(60/gvDiffLVL)) then
			CreateArmyP3(_army)
			return true
		end
    else
		Defend(army)
    end
end
function CreateArmyP4(_index)
	local army	= {}
    army.player = 4
    army.id 	= _index
    army.strength = round(6/gvDiffLVL)
    army.position = GetPosition("Bandit_Spawn" .. _index)
    army.rodeLength = 4800-(300*gvDiffLVL)
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, math.ceil(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderBow".. round(5-gvDiffLVL)]

    for i = 1, math.floor(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local building = "Bandit_Tower" .. _index

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyP4",1,{},{army.id, building})

end
function ControlArmyP4(_army, _building)
	local army = ArmyTable[4][_army+1]
    if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("ArmyP4_Respawn" .. _army, round(45*gvDiffLVL)) then
			CreateArmyP4(_army)
			return true
		end
    else
		if not armies_aggresive then
			Defend(army)
		else
			Advance(army)
		end
    end
end
function CreateArmyNV(_index)
	local army	= {}
    army.player = 4
    army.id 	= GetFirstFreeArmySlot(4)
    army.strength = round(6/gvDiffLVL)
    army.position = GetPosition("NV_Spawn" .. _index)
    army.rodeLength = 4800-(300*gvDiffLVL)
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

    for i = 1, math.ceil(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 16
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1, math.floor(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local building = "NV_Tower" .. _index

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyNV",1,{},{army.id, _index, building})

end
function ControlArmyNV(_army, _index, _building)
	local army = ArmyTable[4][_army+1]
    if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("ArmyNV_Respawn" .. _army, round(45*gvDiffLVL)) then
			CreateArmyNV(_index)
			return true
		end
    else
		if not armies_aggresive then
			Defend(army)
		else
			Advance(army)
		end
    end
end
function CreateArmyGate()
	local army	= {}
    army.player = 5
    army.id 	= 1
    army.strength = round(8/gvDiffLVL)
    army.position = GetPosition("Tower1_Spawn")
    army.rodeLength = 6500-(300*gvDiffLVL)
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

    for i = 1, math.ceil(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1, math.floor(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local building = "Tower1"

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyGate",1,{},{army.id, building})

end
function ControlArmyGate(_army, _building)
	local army = ArmyTable[5][_army+1]
    if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("ArmyGate_Respawn" .. _army, round(20*gvDiffLVL)) then
			CreateArmyGate()
			return true
		end
    else
		if not armies_aggresive then
			Defend(army)
		else
			Advance(army)
		end
    end
end
function CreateArmyPrison()
	local army	= {}
    army.player = 6
    army.id 	= 1
    army.strength = round(8/gvDiffLVL)
    army.position = GetPosition("prison_tower_spawn")
    army.rodeLength = 9500-(700*gvDiffLVL)
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

    for i = 1, math.ceil(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranMajor

    for i = 1, math.floor(army.strength/2), 1 do
	    EnlargeArmy(army,troopDescription)
	end

	local building = "prison_tower"

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmyPrison",1,{},{army.id, building})

end
function ControlArmyPrison(_army, _building)
	local army = ArmyTable[6][_army+1]
    if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("ArmyPrison_Respawn" .. _army, round(35*gvDiffLVL)) then
			CreateArmyPrison()
			return true
		end
    else
		Defend(army)
    end
end
function AIStart()
	MapEditor_SetupAI(5, 3, 50000, 3, "p5", 3, 0)
	MapEditor_Armies[5].offensiveArmies.strength = round(25/gvDiffLVL)
	MapEditor_SetupAI(6, 3, 50000, 3, "p6", 3, 0)
	MapEditor_Armies[6].offensiveArmies.strength = round(30/gvDiffLVL)
	table.insert(MapEditor_Armies[6].ForbiddenTypes, Entities.PV_Cannon2)
	for i = 1, 3 do
		SetHostile(i, 5)
		SetHostile(i, 6)
	end
	ConnectLeaderWithArmy(Logic.GetEntityIDByName("Varg"),nil,"offensiveArmies")
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,"","RF_VH_Down",1,{},{})
end
function RF_VH_Down()
	local id = Event.GetEntityID()
	local type = Logic.GetEntityType(id)
	if type == Entities.PB_VillageHall1 and Logic.EntityGetPlayer(id) == 7 then
		if MapEditor_Armies[7] then
			MapEditor_Armies[7].defensiveArmies.strength = 0
			MapEditor_Armies[7].offensiveArmies.strength = 0
		end
		return true
	end
end
function FriedensEnde()
	Message("Die Tore zu den Feinden stehen nun offen!")
	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_PalisadeGate1)) do
		ReplaceEntity(eID, Entities.XD_PalisadeGate2)
	end
	--
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(2,3,true)
	TagNachtZyklus(24,1,1,round(0-(gvDiffLVL^2)),1)
	StartCountdown(25*gvDiffLVL*60, ArmyAttack, false)
	StartCountdown(20*gvDiffLVL*60, IncreaseAIStrength, false)
	Times_AI_Upgraded = 0
	CreateArmyPrison()
	CreateArmyGate()
	StartSimpleJob("CheckForTowerDown")
end
function CheckForTowerDown()
	if not IsExisting("Tower1") then
		EnableNpcMarker(GetEntityId("captain"))
		NPCs.captain[1] = true
		return true
	end
end
function ArmyAttack()
	armies_aggresive = true
end
function IncreaseAIStrength()
	for i = 5,6 do
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(5/gvDiffLVL)
	end
	Times_AI_Upgraded = Times_AI_Upgraded + 1
	if Times_AI_Upgraded == 2 then
		table.remove(MapEditor_Armies[6].ForbiddenTypes, 1)
	elseif Times_AI_Upgraded == 8 then
		ResearchAllTechnologies(5, false, false, false, false, true)
	elseif Times_AI_Upgraded == 12 then
		ResearchAllTechnologies(6, false, false, false, false, true)
	end
	StartCountdown(20*gvDiffLVL*60, IncreaseAIStrength, false)
end
function Sieg()
	if IsDestroyed("Burg2") and IsDestroyed("Burg1") then
		if CNetwork and GUI.GetPlayerID() ~= 17 then
			if gvChallengeFlag then
				if not LuaDebugger or XNetwork.EXTENDED_GameInformation_IsLuaDebuggerDisabled() then
					GDB.SetValue("challenge_map8_won", 2)
				end
			end
		end
		Victory()
		return true
	end
end
function Niederlage()
	if IsDestroyed("SherBurg") then
		Defeat()
		return true
	end
end

function CreateShering()

	local description = {}

	description.serflimit = 9
	description.extracting = 1
	description.constructing = true
	description.repairing = true

	SetupPlayerAi(3,description)
end
function Helias()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Helias",He,"@color:20,255,50 Ah, gut Euch zu sehen mein Freund. @cr Wir haben Euch schon erwartet.", true)
	ASP("Palisade1",He,"@color:20,255,50 Ein böser Fürst hat Burg Banheim besetzt und versucht nun auch, Burg Shering zu erobern. @cr Wir konnten ihren Palisadenmechanismus außer Gefecht setzen und die Tore schließen, aber wer weiß wie lange das noch hält...", false)
	ASP("GoldChest4",He,"@color:20,255,50 Der umlegenden Bevölkerung geht es sehr schlecht. @cr Wir haben einige von ihnen bei uns aufgenommen - auch einige Gesetzesbrecher - aber sie sind mittellos haben keine Perspektiven.", false)
	ASP("Helias",He,"@color:20,255,50 Seid so gut und redet mit ihnen. @cr Vielleicht könnt ihr deren Leiden lindern.", false)

    briefing.finished = function()
		EnableNpcMarker(GetEntityId("Farmer"))
		EnableNpcMarker(GetEntityId("Johannes"))
		EnableNpcMarker(GetEntityId("Dieb"))
		EnableNpcMarker(GetEntityId("south_chief"))
		EnableNpcMarker(GetEntityId("GateGuard"))
		EnableNpcMarker(GetEntityId("afraid_miner"))
		EnableNpcMarker(GetEntityId("afraid_sawmiller"))
		EnableNpcMarker(GetEntityId("settler"))
		EnableNpcMarker(GetEntityId("settler2"))
		EnableNpcMarker(GetEntityId("Trader1"))
		EnableNpcMarker(GetEntityId("Trader2"))
		EnableNpcMarker(GetEntityId("alchemist"))
		EnableNpcMarker(GetEntityId("monk"))
		NPCs.Farmer[1] = true
		NPCs.Johannes[1] = true
		NPCs.Dieb[1] = true
		NPCs.south_chief[1] = true
		NPCs.GateGuard[1] = true
		NPCs.afraid_miner[1] = true
		NPCs.afraid_sawmiller[1] = true
		NPCs.settler[1] = true
		NPCs.settler2[1] = true
		NPCs.Trader1[1] = true
		NPCs.Trader2[1] = true
		NPCs.alchemist[1] = true
		NPCs.monk[1] = true
		local id = Logic.GetEntityIDByName("Helias")
		ConnectLeaderWithArmy(id, nil, "offensiveArmies")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "HeliasDamageReduction", 1, {}, {id})
		StartSimpleJob("CheckForNPCsTalkedTo")
  	end
	StartBriefing(briefing)
end
function CheckForNPCsTalkedTo()
	local count = 0
	for _, v in pairs(NPCs) do
		if not v[1] then
			count = count + 1
		end
	end
	if count >= 15 then
		if IsDead("Helias") then
			DestroyEntity("Helias")
			local pos = GetPosition("PlayerB")
			local id = Logic.CreateEntity(Entities.PU_Hero6, pos.X, pos.Y, 180, 3)
			Logic.SetEntityName(id, "Helias")
			ConnectLeaderWithArmy(id, nil, "offensiveArmies")
			Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "HeliasDamageReduction", 1, {}, {id})
		end
		Logic.SetEntityName(77938, "Wall")
		HeliasBrief2()
		return true
	end
end
function HeliasBrief2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Helias",He,"@color:20,255,50 Dario. @cr Habt Dank. @cr Ihr habt der umliegenden Bevölkerung geholfen.", false)
	ASP("Helias",He,"@color:20,255,50 Hier, nehmt dies als kleines Zeichen unserer Dankbarkeit.", false)

    briefing.finished = function()
		for i = 1,2 do
			ResearchTechnology(gvTechTable.SilverTechs[math.random(1,8)], i)
		end
		local id = Logic.CreateEntity(Entities.PU_Scout, 57000, 19100, 180, 8)
		Logic.SetEntityName(id, "Scout")
		NPCs["Scout"] = {true, "Scout"}
		Logic.SetOnScreenInformation(id, 1)
	end
	StartBriefing(briefing)
end
function Scout()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Scout",sc,"@color:20,255,50 Oh, so weit draußen noch Menschen? @cr Ich dachte, hier hausen nur die Wilden. @cr Wie dem auch sei, von hier oben hat man einen guten Ausblick auf Burg Banheim.", true)
	ASP("Wall",sc,"@color:20,255,50 Seht ihr die Mauern dort hinten? @cr Ich konnte immer wieder Leibeigene sehen, die versuchen, die Mauer dort zu reparieren. @cr Vielleicht reicht ja bereits ein kleiner Sprengsatz, um das Mauerstück dort einzureißen?", false)

    briefing.finished = function()
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "OnBombCreated", 1)
		local newplayer
		if CNetwork then
			newplayer = 2
		else
			newplayer = 1
		end
		ChangePlayer("Scout", newplayer)
	end
	StartBriefing(briefing)
end
function OnBombCreated()
	if not IsExisting("Wall") then
		return true
	end
	local entityID = Event.GetEntityID()
	local etype = Logic.GetEntityType(entityID)
	if etype == Entities.XD_Bomb1 then
		StartSimpleJob("BombDelay")
	end
end
function BombDelay()
	if Counter.Tick2("BombDelayCounter", 2) then
		local id = Logic.GetEntityIDByName("Wall")
		Logic.HurtEntity(id, round(130*gvDiffLVL))
		return true
	end
end
function Monk()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("monk",monk,"@color:20,255,50 Herr, bitte helft uns. @cr Der Krieg kommt über uns und die Leute verlieren ihren Glauben.", false)
	ASP("monk",monk,"@color:20,255,50 Und das in Zeiten, in denen sie den Glauben dringender brauchen als je zuvor.", false)
	ASP("monk",monk,"@color:20,255,50 Seid bitte so gut und errichtet in unserer Stadt im inneren Burgring mindestens fünf verschiedene Ziergebäude. @cr Dies wird unsere Bevölkerung in diesen schweren Zeiten motivieren.", false)

    briefing.finished = function()
		StartSimpleJob("CheckForBeauties")
  	end
	StartBriefing(briefing)
end
function CheckForBeauties()
	local count = 0
	local t = {id = {}, typ = {}}
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Beautification01, Entities.PB_Beautification02, Entities.PB_Beautification03, Entities.PB_Beautification04, Entities.PB_Beautification05,
	Entities.PB_Beautification06, Entities.PB_Beautification07, Entities.PB_Beautification08, Entities.PB_Beautification09, Entities.PB_Beautification10, Entities.PB_Beautification11,
	Entities.PB_Beautification12, Entities.PB_Beautification13, Entities.PB_VictoryStatue1, Entities.PB_VictoryStatue3, Entities.PB_VictoryStatueET22, Entities.PB_VictoryStatueET23),
	CEntityIterator.InCircleFilter(35100, 36500, 7500)) do
		if Logic.IsConstructionComplete(eID) == 1 then
			local typ = Logic.GetEntityType(eID)
			if table_findvalue(t.typ, typ) == 0 then
				table.insert(t.typ, typ)
				table.insert(t.id, eID)
				count = count + 1
			end
		end
	end
	if count >= 5 then
		for i = 1, table.getn(t.id) do
			ChangePlayer(t.id[i], 3)
		end
		MonkHelpedBrief()
		return true
	end
end
function MonkHelpedBrief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("monk",monk,"@color:20,255,50 Vielen, vielen Dank. @cr Nun bekommt unsere Bevölkerung etwas Ablenkung von den Kriegswirren.", false)
	ASP("monk",monk,"@color:20,255,50 Hier, nehmt dies als Zeichen unserer Anerkennung.", false)

    briefing.finished = function()
		for i = 1,2 do
			Logic.AddToPlayersGlobalResource(i, ResourceType.Silver, round(300 * gvDiffLVL))
			AddGold(i, dekaround(3500 * gvDiffLVL))
		end
  	end
	StartBriefing(briefing)
end
function south_chief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("south_chief",SC,"@color:20,255,50 Wer seid ihr und was wollt ihr?", true)
	ASP("south_chief",Dario,"@color:20,255,50 Helias schickt mich. Er meinte, dass er euch trotz eurer Vergehen aufgenommen hat. Ihr solltet euch ein wenig erkenntlich zeigen.", false)
	ASP("south_chief",SC,"@color:20,255,50 Natürlich sind wir dankbar. @cr Aber Dank füllt nicht unsere Börse oder die Mägen unserer Kinder. @cr Versteht mich nicht falsch, auch wir hegen einen Groll gegen den kriegersichen Adligen im Süden.", false)
	ASP("south_chief",SC,"@color:20,255,50 Gebt uns einige Taler, sodass für unsere Familien gesorgt ist, und wir ziehen gerne an eurer Seite in den Krieg.", false)

    briefing.finished = function()
		Tribute()
		StartSimpleJob("CheckForBanditChiefDown")
  	end
	StartBriefing(briefing)
end
function CheckForBanditChiefDown()
	if IsDead("south_chief") then
		Logic.RemoveTribute(TributePID, BanditT)
		return true
	end
end
function GateGuard()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("GateGuard",GG,"@color:20,255,50 Auf Anweisung des Oberbefehlshabers bleibt dieses Tor geschlossen! @cr @cr Gegen einen kleinen Obelus hingegen...", false)

    briefing.finished = function()
		TributeGate()
		StartSimpleJob("CheckForGateGuardDead")
  	end
	StartBriefing(briefing)
end
function TributeGate()
	local tribute =  {}
	tribute.playerId = TributePID;
	tribute.text = "@color:230,0,0 Zahlt " .. dekaround(1000/gvDiffLVL) .. " Taler, um den Torwächter zu bestechen.";
	tribute.cost = {Gold = dekaround(1000/gvDiffLVL)}
	tribute.Callback = PayedTributeGate
	GateT = AddTribute(tribute)
end
function PayedTributeGate()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("GateGuard",GG,"@color:230,0,0 Danke für die Zahlung. @cr Ich werde das Tor umgehend öffnen.", false)
	briefing.finished = function()
		ReplaceEntity("south_gate", Entities.XD_DarkWallStraightGate)
	end
	StartBriefing(briefing)
end
function CheckForGateGuardDead()
	if IsDead("GateGuard") then
		Logic.RemoveTribute(TributePID, GateT)
		return true
	end
end
function Trader1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader1",tr,"@color:20,255,50 He ihr da! Wollt ihr hochwertige Güter zu niedrigen Preisen kaufen?", false)
	ASP("Trader1",tr,"@color:20,255,50 Seht in euer Tributmenü, um mit mir Handel zu treiben.", false)

    briefing.finished = function()
		TraderTribut1a()
  	end
	StartBriefing(briefing)
end
function TraderTribut1a()
	local Tr1atribute =  {}
	Tr1atribute.playerId = TributePID;
	Tr1atribute.text = "Zahlt ".. dekaround(1000/gvDiffLVL) .." Taler , um 1000 Holz zu kaufen!";
	Tr1atribute.cost = {Gold = dekaround(1000/gvDiffLVL)};
	Tr1atribute.Callback = Trader1bezahlt;
	AddTribute( Tr1atribute )
end
function Trader1bezahlt()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader1",tr,"@color:230,0,0 Danke für die Zahlung. Das war doch ein fairer Handel, nicht? Lasst uns weiter handeln.", true)
	briefing.finished = function()
		AddWood(TributePID,1000)
		TraderTribut1b()
	end;
	StartBriefing(briefing);
end
function TraderTribut1b()
	local Tr1btribute =  {}
	Tr1btribute.playerId = TributePID;
	Tr1btribute.text = "Zahlt ".. dekaround(1800/gvDiffLVL) .." Taler , um 1000 Holz zu kaufen!";
	Tr1btribute.cost = {Gold = dekaround(1800/gvDiffLVL)};
	Tr1btribute.Callback = Trader1bezahlt;
	AddTribute( Tr1btribute )
end
function Trader2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
  	ASP("Trader2",tr,"@color:20,255,50 Hereinspaziert, hereinspaziert! @cr Hier gibts den besten Schwefel der Region zu Spottpreisen.", false)
	ASP("Trader2",tr,"@color:20,255,50 Ihr werdet nirgends bessere Qualität finden. Schlagt zu, solange noch was da ist.", false)

    briefing.finished = function()
		TraderTribut2()
	end;
	StartBriefing(briefing)
end
function TraderTribut2()
	local Tr2tribute =  {}
	Tr2tribute.playerId = TributePID;
	Tr2tribute.text = "Zahlt ".. dekaround(1000/gvDiffLVL) .." Taler , um 800 Schwefel zu kaufen!";
	Tr2tribute.cost = {Gold = dekaround(1000/gvDiffLVL)};
	Tr2tribute.Callback = Trader2bezahlt1;
	AddTribute( Tr2tribute )
end
function Trader2bezahlt1()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",tr,"@color:230,0,0 Das war doch mal ein fairer Handel. Noch habe ich was da, handelt gerne wieder mit mir!", false)
	briefing.finished = function()
		AddSulfur(TributePID,800)
		TraderTribut2b()
	end;
	StartBriefing(briefing);
end
function TraderTribut2b()
	local Tr2btribute =  {}
	Tr2btribute.playerId = TributePID;
	Tr2btribute.text = "Zahlt ".. dekaround(1600/gvDiffLVL) .." Taler , um 1000 Schwefel zu kaufen!";
	Tr2btribute.cost = {Gold = dekaround(1600/gvDiffLVL)};
	Tr2btribute.Callback = Trader2bezahlt2;
	AddTribute( Tr2btribute )
end
function Trader2bezahlt2()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",tr,"@color:230,0,0 Ohh, ihr habt erneut mit mir gehandelt. Das ist aber erfreulich. Leider habe ich kaum noch Schwefel hier und muss daher die Preise erhöhen!", false)
	briefing.finished = function()
		AddSulfur(TributePID,1000)
		TraderTribut2c()
	end;
	StartBriefing(briefing);
end
function TraderTribut2c()
	local Tr2ctribute =  {}
	Tr2ctribute.playerId = TributePID;
	Tr2ctribute.text = "Zahlt ".. dekaround(2200/gvDiffLVL) .." Taler, um 800 Schwefel zu kaufen!";
	Tr2ctribute.cost = {Gold = dekaround(2200/gvDiffLVL)};
	Tr2ctribute.Callback = Trader2bezahlt3;
	AddTribute( Tr2ctribute )
end
function Trader2bezahlt3()
    local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("Trader2",tr,"@color:230,0,0 Danke, dass ihr trotz der gestiegenen Preise immer noch mit mir handelt!", false)
	briefing.finished = function()
		AddSulfur(TributePID,800)
		TraderTribut2c()
	end;
	StartBriefing(briefing);
end
function alchemist()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("alchemist",alch,"@color:230,0,0 Seit dem letzten Hochwasser ist der Hang am See abgerutscht und der alte Leuchtturm ist nicht mehr erreichbar.", false)
	ASP("alchemist",alch,"@color:230,0,0 Gebt mir ein wenig Schwefel und ich kann eine Sprengladung am Hang anbringen. @cr Er wird dann wieder erreichbar sein.", false)
	briefing.finished = function()
		TributAlchemist()
		StartSimpleJob("CheckForAlchemistDead")
	end;
	StartBriefing(briefing);
end
function TributAlchemist()
	local Alchtribute =  {}
	Alchtribute.playerId = TributePID;
	Alchtribute.text = "Zahlt ".. dekaround(1200/gvDiffLVL) .." Schwefel für die Sprengladung des Alchemisten, um den Leuchtturm wieder passierbar zu machen!";
	Alchtribute.cost = {Sulfur = dekaround(1200/gvDiffLVL)};
	Alchtribute.Callback = AlchemistPayed
	AlT = AddTribute( Alchtribute )
end
function AlchemistPayed()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("alchemist",alch,"@color:230,0,0 Vielen Dank für den Schwefel. @cr Ich werde die Sprengladung alsbald an dem Hang anbringen.", false)
	briefing.finished = function()
		StartCountdown(10, MakeKawumm, false)
	end;
	StartBriefing(briefing);
end
function CheckForAlchemistDead()
	if IsDead("alchemist") then
		Logic.RemoveTribute(TributePID, AlT)
		return true
	end
end
function MakeKawumm()
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, 19300, 40000)
	Logic.SetTerrainNodeHeight(188, 396,  1539);
	Logic.SetTerrainNodeHeight(189, 396,  1600);
	Logic.SetTerrainNodeHeight(190, 396,  1694);
	Logic.SetTerrainNodeHeight(191, 396,  1810);
	Logic.SetTerrainNodeHeight(192, 396,  1929);
	Logic.SetTerrainNodeHeight(193, 396,  2023);
	Logic.SetTerrainNodeHeight(194, 396,  2066);
	Logic.SetTerrainNodeHeight(195, 396,  2067);
	Logic.SetTerrainNodeHeight(188, 397,  1569);
	Logic.SetTerrainNodeHeight(189, 397,  1627);
	Logic.SetTerrainNodeHeight(190, 397,  1709);
	Logic.SetTerrainNodeHeight(191, 397,  1806);
	Logic.SetTerrainNodeHeight(192, 397,  1903);
	Logic.SetTerrainNodeHeight(193, 397,  1984);
	Logic.SetTerrainNodeHeight(194, 397,  2041);
	Logic.SetTerrainNodeHeight(195, 397,  2050);
	Logic.SetTerrainNodeHeight(188, 398,  1600);
	Logic.SetTerrainNodeHeight(189, 398,  1647);
	Logic.SetTerrainNodeHeight(190, 398,  1722);
	Logic.SetTerrainNodeHeight(191, 398,  1801);
	Logic.SetTerrainNodeHeight(192, 398,  1877);
	Logic.SetTerrainNodeHeight(193, 398,  1942);
	Logic.SetTerrainNodeHeight(194, 398,  1989);
	Logic.SetTerrainNodeHeight(195, 398,  2015);
	Logic.SetTerrainNodeHeight(188, 399,  1619);
	Logic.SetTerrainNodeHeight(189, 399,  1665);
	Logic.SetTerrainNodeHeight(190, 399,  1730);
	Logic.SetTerrainNodeHeight(191, 399,  1798);
	Logic.SetTerrainNodeHeight(192, 399,  1863);
	Logic.SetTerrainNodeHeight(193, 399,  1920);
	Logic.SetTerrainNodeHeight(194, 399,  1964);
	Logic.SetTerrainNodeHeight(195, 399,  1995);
	Logic.SetTerrainNodeHeight(188, 400,  1629);
	Logic.SetTerrainNodeHeight(189, 400,  1672);
	Logic.SetTerrainNodeHeight(190, 400,  1727);
	Logic.SetTerrainNodeHeight(191, 400,  1788);
	Logic.SetTerrainNodeHeight(192, 400,  1849);
	Logic.SetTerrainNodeHeight(193, 400,  1906);
	Logic.SetTerrainNodeHeight(194, 400,  1953);
	Logic.SetTerrainNodeHeight(195, 400,  1985);
	Logic.SetTerrainNodeHeight(188, 401,  1621);
	Logic.SetTerrainNodeHeight(189, 401,  1663);
	Logic.SetTerrainNodeHeight(190, 401,  1717);
	Logic.SetTerrainNodeHeight(191, 401,  1777);
	Logic.SetTerrainNodeHeight(192, 401,  1839);
	Logic.SetTerrainNodeHeight(193, 401,  1900);
	Logic.SetTerrainNodeHeight(194, 401,  1953);
	Logic.SetTerrainNodeHeight(195, 401,  1983);
	Logic.SetTerrainNodeHeight(188, 402,  1601);
	Logic.SetTerrainNodeHeight(189, 402,  1645);
	Logic.SetTerrainNodeHeight(190, 402,  1700);
	Logic.SetTerrainNodeHeight(191, 402,  1764);
	Logic.SetTerrainNodeHeight(192, 402,  1832);
	Logic.SetTerrainNodeHeight(193, 402,  1902);
	Logic.SetTerrainNodeHeight(194, 402,  1964);
	Logic.SetTerrainNodeHeight(195, 402,  1991);
	Logic.SetTerrainNodeHeight(188, 403,  1569);
	Logic.SetTerrainNodeHeight(189, 403,  1615);
	Logic.SetTerrainNodeHeight(190, 403,  1675);
	Logic.SetTerrainNodeHeight(191, 403,  1747);
	Logic.SetTerrainNodeHeight(192, 403,  1825);
	Logic.SetTerrainNodeHeight(193, 403,  1907);
	Logic.SetTerrainNodeHeight(194, 403,  1983);
	Logic.SetTerrainNodeHeight(195, 403,  2004);
	Logic.UpdateBlocking(188, 396, 195, 403)
end
function settler()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("settler",set,"@color:20,255,50 Wie der Schein doch trügen kann... @cr @cr ...Hier so idyllisch", false)
	ASP("ruin_claymine",set,"@color:20,255,50 ...und dort hinten liegt alles in Ruinen @cr @cr ...seit diese Wilden kamen", false)
	ASP("settler",men,"@color:20,255,50 Herr, seht doch. @cr @cr Dieser arme Arbeiter hat Euch all seine Talerchen überlassen.", false)
    briefing.finished = function()
		AddGold(1, dekaround(2000*gvDiffLVL))
		AddGold(2, dekaround(2000*gvDiffLVL))
  	end
	StartBriefing(briefing)
end
function settler2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Holz6",set,"@color:20,255,50 Seht doch die alte Sägemühle dort hinten. @cr Wir haben hier ringsrum Wälder, aber produzieren tut sie trotzdem nichts.", false)
	ASP("settler2",set,"@color:20,255,50 Es muss doch etwas geben, um die Bäume in der Gegend zu fällen, sodass die alte Sägemühle Bretter herstellen kann.", false)
	ASP("settler2",QB,"@color:20,255,50 Baut eine Holzfällerhütte nahe der Sägemühle.", false)
    briefing.finished = function()
		StartSimpleJob("CheckForLumberjack")
  	end
	StartBriefing(briefing)
end
function CheckForLumberjack()
	local num, id = Logic.GetEntitiesInArea(Entities.PB_WoodcuttersHut1, 50000, 33200, 2000, 1)
	if num > 0 then
		if Logic.IsConstructionComplete(id) == 1 then
			local worker = WCutter.GetWorkerIDByBuildingID(id)
			local player = Logic.EntityGetPlayer(id)
			ChangePlayer(id, 7)
			DestroyEntity(worker)
			LumberjackReward(player)
			return true
		end
	end
end
function LumberjackReward(_player)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("settler2",set,"@color:20,255,50 Vielen Dank für den Bau der Holzfällerhütte. @cr Nun kann die alte Sägemühle endlich in Betrieb gehen.", false)
    briefing.finished = function()
		for i = 1,2 do
			AllowTechnology(Technologies.GT_Banking, i)
			AllowTechnology(Technologies.GT_Laws, i)
			AllowTechnology(Technologies.GT_Gilds, i)
		end
		Ally = Ally + 1
		Message("Neue Technologien sind nun erforschbar!")
		AddWood(_player, dekaround(1200*gvDiffLVL))
  	end
	StartBriefing(briefing)
end
function afraid_miner()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("afraid_miner",miner,"@color:20,255,50 Gebt gut auf euch Acht, wenn ihr diesem Pfad weiter folgen wollt.", false)
	ASP("Bandit_Spawn4",miner,"@color:20,255,50 Oben in den Bergen haben sich Räuber breit gemacht. Sie werden euch sicherlich nicht passieren lassen. @cr Die Steinbrüche in den Bergen mussten bereits aufgegeben werden.", false)
    ASP("NV_Path",miner,"@color:20,255,50 Und der andere Pfad ist auch nicht mehr sicher. Da haben sich grausige Kreaturen niedergelassen.", false)
	ASP("village",miner,"@color:20,255,50 Früher war dort mal eine kleine Siedlung, aber seit diese Kreaturen dort aufgetaucht sind, traue ich micht nicht mehr dort hin.", false)
	briefing.finished = function()
  	end
	StartBriefing(briefing)
end
function afraid_sawmiller()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("afraid_sawmiller",saw,"@color:20,255,50 Ich kann den Horror kaum in Worte fassen. @cr @cr Meine Knie sind immer noch am schlottern", false)
	ASP("NV_Path2",saw,"@color:20,255,50 Ich war vor kurzem in den Bergen unterwegs, um ein paar Birken zu fällen, als ich in der Ferne seltsame Lichter sah. @cr Mitten aus dem Nichts erschallten dann Trommeln und mein Herz ist mir fast in die Hose gerutscht.", false)
	ASP("afraid_sawmiller",saw,"@color:20,255,50 Ich bin so schnell gelaufen wie ich konnte und traue mich seit dem nicht mehr in die Berge", false)
    briefing.finished = function()
  	end
	StartBriefing(briefing)
end
function Farmer()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Farmer",Fa,"@color:20,255,50 Hallo. Könntet ihr mir ein wenig behilflich sein?", true)
	ASP("Dario",Dario,"@color:20,255,50 Das kommt ganz drauf an. Was soll denn gemacht werden?", false)
	ASP("Farmer",Fa,"@color:20,255,50 Hier fehlt es eindeutug an einem @color:250,0,0 Wohnhaus @color:20,255,50 . Das alte dort hinten ist schon längst baufällig geworden.", true)
	ASP("Hausruine",Fa,"@color:20,255,50 Reißt es doch bitte für mich ab und baut dann ein neues @color:250,0,0 GROSSES WOHNHAUS @color:20,255,50 an die Stelle.", false)
	AP{
		title = Fa,
		text = "@color:20,255,50 Ich werde auch dafür natürlich auch angemessen entlohnen.",
		position = GetPosition("Hausruine"),
		dialogCamera = false,
	}

    briefing.finished = function()
		StartSimpleJob("Hausruinenkontrolle")
		ChangePlayer("Hausruine",4)
		SetHealth("Hausruine",10)
  	end
	StartBriefing(briefing)
end
function Hausruinenkontrolle()
	if IsDestroyed("Hausruine") then
		Gebietsmarker1 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,48000,46200)
		StartSimpleJob("Hauserbaut")
		StartSimpleJob("MarkerWeg")
		return true
	end
end
function MarkerWeg()
	idResi = SucheAufDerWelt(1,Entities.PB_Residence1,1000,GetPosition("Haus"))
	if table.getn(idResi) > 0 and Logic.IsConstructionComplete(idResi[1]) == 1 then
		Logic.DestroyEffect( Gebietsmarker1 )
		return true
	end
	idResi = SucheAufDerWelt(2,Entities.PB_Residence1,1000,GetPosition("Haus"))
	if table.getn(idResi) > 0 and Logic.IsConstructionComplete(idResi[1]) == 1 then
		Logic.DestroyEffect( Gebietsmarker1 )
		return true
	end
end
function Hauserbaut()
	idRes = SucheAufDerWelt(1,Entities.PB_Residence3,1000,GetPosition("Haus"))
	if table.getn(idRes) > 0 and Logic.IsConstructionComplete(idRes[1]) == 1 then
		idRes = idRes[1]
		ChangePlayer(idRes,7)
		Belohnung(1)
		return true
	end
	idRes = SucheAufDerWelt(2,Entities.PB_Residence3,1000,GetPosition("Haus"))
	if table.getn(idRes) > 0 and Logic.IsConstructionComplete(idRes[1]) == 1 then
		idRes = idRes[1]
		ChangePlayer(idRes,7)
		Belohnung(2)
		return true
	end
end
function Belohnung(_player)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Farmer",Fa,"@color:20,255,50 Danke. Hier die euch versprochene Belohnung.", true)
	ASP("Farmer",Fa,"@color:20,255,50 Jetzt kann ich und mein Kollege endlich wieder in einem vernünftigem Bett schlafen.", false)

    briefing.finished = function()
		Geschenk(_player)
  	end
	StartBriefing(briefing)
end
function Geschenk(_player)
	for i = 1, 2 do
		AllowTechnology(Technologies.GT_Mathematics, i)
		AllowTechnology(Technologies.GT_Binocular, i)
	end
	AddWood(_player,dekaround(800*gvDiffLVL))
	AddClay(_player,dekaround(800*gvDiffLVL))
	AddStone(_player,dekaround(800*gvDiffLVL))
	CreateEntity(_player,Entities.PU_Serf,GetPosition("Geschenk"))
	CreateEntity(_player,Entities.PU_Serf,GetPosition("Geschenk"))
	CreateEntity(_player,Entities.PU_Serf,GetPosition("Geschenk"))
	CreateEntity(_player,Entities.PU_Serf,GetPosition("Geschenk"))
	Message("Neue Technologien sind nun erforschbar!")
	Ally = Ally + 1
end
function Johannes()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Johannes",Jo,"@color:20,255,50 Hallo Dario. Wahrlich schwere Zeiten, in denen wir uns hier treffen.", true)
	ASP("Kirchenruine",Jo,"@color:20,255,50 Diese Barbaren haben selbst vor unserer Kirche nicht halt gemacht und sie niedergebrannt!", false)
	ASP("Johannes",Jo,"@color:20,255,50 Viele unserer Brüder sind beim Versuch, die Kirche zu verteidigen, gestorben. Bitte Dario, baut eine prunkvolle neue @color:250,0,0 KIRCHE @color:20,255,50 am Ort der alten Kirche.", true)
	ASP("Johannes",Jo,"@color:20,255,50 So kommt zumindest ein wenig Hoffnung zurück in unsere Herzen.", false)
	AP{
		title = Fa,
		text = "@color:20,255,50 Als Dank werden ich und meine Brüder euch Einblicke in unsere Bibliothek ermöglichen.",
		position = GetPosition("Abtei"),
  		dialogCamera = false,
	}

    briefing.finished = function()
		StartSimpleJob("Kirchenruinenkontrolle")
		ChangePlayer("Kirchenruine",4)
		SetHealth("Kirchenruine",10)
  	end
	StartBriefing(briefing)
end
function Kirchenruinenkontrolle()
	if IsDestroyed("Kirchenruine") then
		Gebietsmarker2 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,44800,41000)
		StartSimpleJob("Kircheerbaut")
		StartSimpleJob("Marker2Weg")
		return true
	end
end
function Marker2Weg()
	idKir = SucheAufDerWelt(1,Entities.PB_Monastery1,2000,GetPosition("Kirche"))
	if table.getn(idKir) > 0 and Logic.IsConstructionComplete(idKir[1]) == 1 then
		Logic.DestroyEffect( Gebietsmarker2 )
		return true
	end
	idKir = SucheAufDerWelt(2,Entities.PB_Monastery1,2000,GetPosition("Kirche"))
	if table.getn(idKir) > 0 and Logic.IsConstructionComplete(idKir[1]) == 1 then
		Logic.DestroyEffect( Gebietsmarker2 )
		return true
	end
end
function Kircheerbaut()
	idKi = SucheAufDerWelt(1,Entities.PB_Monastery2,2000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		idKi = idKi[1]
		ChangePlayer(idKi,7)
		Belohnung2(1)
		return true
	end
	idKi = SucheAufDerWelt(2,Entities.PB_Monastery2,2000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		idKi = idKi[1]
		ChangePlayer(idKi,7)
		Belohnung2(2)
		return true
	end
end
function Belohnung2(_player)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Johannes",Jo,"@color:20,255,50 Danke Dario. Vielen, vielen Dank.", true)
	ASP("Kirche",Jo,"@color:20,255,50 Jetzt können wir wieder beten und um unsere Gefallenen angemessen trauern.", false)

    briefing.finished = function()
		Geschenk2(_player)
  	end
	StartBriefing(briefing)
end
function Geschenk2(_player)
	AddWood(_player,dekaround(800*gvDiffLVL))
	AddClay(_player,dekaround(800*gvDiffLVL))
	AddStone(_player,dekaround(800*gvDiffLVL))
	for i = 1, 2 do
		AllowTechnology(Technologies.GT_Library, i)
		AllowTechnology(Technologies.GT_Chemistry, i)
	end
	Message("Neue Technologien sind nun erforschbar!")
	Ally = Ally + 1
end
function Dieb()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("DeadTree",Di,"@color:20,255,50 Seht ihr diesen verdorrten Baum dort drüben?", false)
	ASP("Dieb",Di,"@color:20,255,50 Seitdem der dort steht, ist das gesamte Land verflucht worden!", false)
	ASP("Dieb",Di,"@color:20,255,50 Ich selber kann ihn leider nicht fällen, aber ihr doch bestimmt, oder?", true)
	ASP("Dieb",Di,"@color:20,255,50 Danach wird dieses Land endlich wieder erblühen können.", false)

    briefing.finished = function()
		StartSimpleJob("Baumweg")
  	end
	StartBriefing(briefing)
end
function Baumweg()
	if not IsExisting("DeadTree") then
		if IsExisting("Dieb") then
			Belohnung3()
		end
		return true
	end
end
function Belohnung3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Dieb",Di,"@color:20,255,50 Gute Arbeit.", true)
	ASP("Dieb",Di,"@color:20,255,50 Ihr seid fortan mein neuer Meister. Nun, was soll gesprengt werden?", false)

    briefing.finished = function()
		Geschenk3()
  	end
	StartBriefing(briefing)
end
function Geschenk3()
	if IsExisting("Dieb") then
		local newID = ReplaceEntity("Dieb", Entities.PU_Thief)
		ChangePlayer(newID, 1)
		ResearchTechnology(Technologies.T_ThiefSabotage, 1)
		for i = 1, 2 do
			AllowTechnology(Technologies.GT_Matchlock, i)
			AllowTechnology(Technologies.GT_PulledBarrel, i)
		end
		Message("Neue Technologien sind nun erforschbar!")
		Ally = Ally + 1
	end
end
function NewAlly()
	if Ally >= 4 then
		CreateAlly()
		return true
	end
end
function CreateAlly()
	MapEditor_SetupAI(7, 2, 50000, 2, "Ally", 2, 0)
	MapEditor_Armies[7].offensiveArmies.strength = round(15*gvDiffLVL)
	MapEditor_Armies[7].defensiveArmies.baseDefenseRange = 7000
	ActivateShareExploration(1,7,true)
	ActivateShareExploration(2,7,true)
	SetFriendly(1,7)
	SetFriendly(2,7)
	SetHostile(7,4)
	SetHostile(7,5)
	SetHostile(7,6)
	Message("Das Landvolk hat sich Euch angeschlossen!")
end
function captain()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("captain",cap,"@color:20,255,50 Einer der zwei schwarzen Türme ist gefallen. Und nun wollt ihr, dass wir auch mit Euch vorpreschen?", false)
	ASP("CannonSpawn",cap,"@color:20,255,50 Nun, unsere Armee ist ziemlich am Ende. @cr Die wollen nicht mehr kämpfen. @cr Die werden wir nur mit einer massiven Solderhöhung überzeugt bekommen.", false)

    briefing.finished = function()
		ElCapitanoTribut()
  	end
	StartBriefing(briefing)
end
function ElCapitanoTribut()
	local ElCaptribute =  {}
	ElCaptribute.playerId = TributePID;
	ElCaptribute.text = "Zahlt ".. dekaround(Logic.GetTime()*5/gvDiffLVL) .." Taler, damit Shering's Truppen stärker in die Offensive gehen!";
	ElCaptribute.cost = {Gold = dekaround(Logic.GetTime()*5/gvDiffLVL)};
	ElCaptribute.Callback = ElCapitanoPayed
	AddTribute( ElCaptribute )
end
function ElCapitanoPayed()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
	ASP("captain",cap,"@color:230,0,0 Die Taler sind angekommen. @cr Damit werde ich den Sold unserer Truppen massiv erhöhen können. @cr Wir sehen uns auf dem Schlachtfeld.", false)
	briefing.finished = function()
		MapEditor_Armies[3].offensiveArmies.rodeLength = 50000
		MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength + round(5*gvDiffLVL)
	end;
	StartBriefing(briefing);
end
--**********Abschnitt  Comfortfunctionen:**********--
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