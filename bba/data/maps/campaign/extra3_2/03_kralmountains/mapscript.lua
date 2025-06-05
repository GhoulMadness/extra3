--------------------------------------------------------------------------------
-- MapName: Die Invasion Im Norden - Das Kralgebirge
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Das Kralgebirge @cr "
gvMapVersion = " v1.00"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(1,"Dario")
	SetPlayerName(3,"Kerberos Aussenposten")
	SetPlayerName(2,"Kerberos Truppen")
	SetPlayerName(4,"Wikinger")
	SetPlayerName(6,"Kloster Newhoumpton")
	SetPlayerName(7,"Fort Wulfilar")
	SetPlayerName(8,"Stonesdale")
	SetFriendly(1,6)
	SetFriendly(1,7)
	SetFriendly(6,7)
	SetHostile(2,7)
	SetHostile(3,7)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (round(500*gvDiffLVL))
    AddSulfur(0)
    AddIron  (0)
    AddWood  (1000)
    AddStone (1000)
    AddClay  (1000)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
	ForbidTechnology(Technologies.GT_PulledBarrel,1)
	ForbidTechnology(Technologies.GT_Mathematics,1)
	ForbidTechnology(Technologies.GT_Binocular,1)
	ForbidTechnology(Technologies.GT_Matchlock,1)
	ForbidTechnology(Technologies.GT_Chemistry,1)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start you should setup your weather periods here
function InitWeather()
	AddPeriodicSummer(10)
	--Logic.AddWeatherElement(1, 400, 1, 1, 5, 10)
	--Logic.AddWeatherElement(2, 80, 1, 2, 5, 10)
	--Logic.AddWeatherElement(1, 520, 1, 1, 5, 10)
	--Logic.AddWeatherElement(2, 90, 1, 2, 5, 10)
	--Logic.AddWeatherElement(3, 300, 1 , 3, 4, 10)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game to initialize player colors
function InitPlayerColorMapping()
	XGUIEng.SetText(""..
		"TopMainMenuTextButton", gvMapText ..
		" @cr ".. DiffLVLToString(gvDiffLVL) .. " @cr @color:230,0,240 " .. gvMapVersion)
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
	BRIEFING_TIMER_PER_CHAR = 1.0
	FarbigeNamen()
	Display.SetPlayerColorMapping(2,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(6,NPC_COLOR)
	Display.SetPlayerColorMapping(3,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(4,ROBBERS_COLOR)

end
--**
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, 4-gvDiffLVL, 8500, math.max(4-gvDiffLVL,2), "Kerberos", 3, 0)
	SetupPlayerAi( 2, {constructing = true, extracting = 0, repairing = true, serfLimit = 2*gvDiffLVL} )
	--MapEditor_SetupAI(3, 4-gvDiffLVL, 500, 3, "Aussen", 3, 0)
	MapEditor_SetupAI(4, math.max(3-gvDiffLVL,1), 11000, 3-gvDiffLVL, "P4", 1, 0)
	--MapEditor_SetupAI(6, 0, 0, 0, "Kloster", 0, 0)
	MapEditor_SetupAI(7, 0+gvDiffLVL, 7000, 2, "Fort Wulfilar", 1, 0)
	SetupPlayerAi( 7, {constructing = true, extracting = 0, repairing = true, serfLimit = 4*gvDiffLVL} )
	--**
	ActivateBriefingsExpansion()
	StartSimpleJob("Gewonnen")
	StartSimpleJob("Verloren")
	--
	SetFriendly(1,7)
    Start()
    Truhen()
	LocalMusic.UseSet = DARKMOORMUSIC
	gvDayCycleStartTime = Logic.GetTime()
	TagNachtZyklus(32,1,1,(0-gvDiffLVL))
end
function FarbigeNamen()
	orange 	= " @color:255,127,0 "
	lila 	= " @color:250,0,240 "
	weiss	= " @color:255,255,255 "

	sc     	= ""..orange.." Leo, drakonischer Kundschafter "..lila..""
	bi     	= ""..orange.." Priester "..lila..""
	ga     	= ""..orange.." Garek "..lila..""
	pri    	= ""..orange.." Mönch "..lila..""
	comm   	= ""..orange.." Anführer "..lila..""
	dov		= ""..orange.." Dovbar "..lila..""
	kerbe	= ""..orange.." Kerberos "..lila..""
	ment	= ""..orange.." Mentor "..lila..""
	dario	= ""..orange.." Dario "..lila..""
	drake	= ""..orange.." Drake "..lila..""
	ari		= ""..orange.." Ari "..lila..""
	jo      = ""..orange.." Bruder Johannes "..lila..""
	pil    	= ""..orange.." Pilgrim "..lila..""
	mi     	= ""..orange.." Minenarbeiter "..lila..""
	mjP8   	= ""..orange.." Bürgermeister von Stonesdale "..lila..""
	mg1     = ""..orange.." Schläfriger Torwächter "..lila..""
	mg2     = ""..orange.." Mürrischer Wächter "..lila..""
	mg3     = ""..orange.." Einfältiger Wächter "..lila..""
	trP8    = ""..orange.." Jörn, der Spezialitätenhändler "..lila..""
	gu1		= ""..orange.." Peter, Kerberos Späher "..lila..""
	gu2		= ""..orange.." Dieter, Kerberos Späher "..lila..""
	fgu1	= ""..orange.." Thrann, Wache des Feuers "..lila..""
	vtg		= ""..orange.." Rolf, Vargs Späher "..lila..""
	var		= ""..orange.." Varg "..lila..""
	mi_p7	= ""..orange.." Scharfäugiger Bergmann "..lila..""
	fa_p7	= ""..orange.." Gelangweilter Bauer "..lila..""
end

function Start()
	SetHealth("Burg",round(10*gvDiffLVL))
	SetHealth("Ruine",round(40/gvDiffLVL))
	SetHealth("Ruin_1",round(60/gvDiffLVL))
	SetHealth("Ruin_2",round(90/gvDiffLVL))
	SetHealth("Ruin_3",round(80/gvDiffLVL))
	KerbTroopTypes = {Entities.CU_BlackKnight_LeaderMace2, Entities["PU_LeaderSword" .. 5 - gvDiffLVL], Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities.CU_BlackKnight_LeaderSword3, Entities.PV_Cannon3}
	if gvDiffLVL < 2 then
		table.insert(KerbTroopTypes, Entities.CU_VeteranMajor)
		table.insert(KerbTroopTypes, Entities.CU_VeteranCaptain)
		table.insert(KerbTroopTypes, Entities.PV_Cannon5)
	end
	WikTroopTypes = {Entities.CU_Barbarian_LeaderClub2, Entities["PU_LeaderSword" .. 5 - gvDiffLVL], Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities.PV_Cannon1}
	if gvDiffLVL < 2 then
		table.insert(WikTroopTypes, Entities.CU_VeteranLieutenant)
	end

	ArmyData = {[2] = {{id = 0, position = GetPosition("KerberosTr"), building = GetID("KerbTower1"),
		troops = {}, rodeLength = 7000, strength = 6},
		{id = 1, position = GetPosition("P2_Spawn1"), building = GetID("P2Tower1"),
		troops = {}, rodeLength = 6500, strength = 4},
		{id = 2, position = GetPosition("P2_Spawn2"), building = GetID("P2_Tower2"),
		troops = {}, rodeLength = 5200, strength = 8},
		{id = 3, position = GetPosition("P2_Spawn3"), building = GetID("P2_Tower3"),
		troops = {}, rodeLength = 5800, strength = 8},
		{id = 4, position = GetPosition("P2_Spawn4"), building = GetID("P2_Tower4"),
		troops = {}, rodeLength = 6200, strength = 6},
		{id = 5, position = GetPosition("P2_Spawn5"), building = GetID("P2_Tower5"),
		troops = {}, rodeLength = 9000, strength = 4},
		{id = 6, position = GetPosition("P2_Spawn6"), building = GetID("P2_Tower6"),
		troops = {}, rodeLength = 6500, strength = 6}},
		[3] = {{id = 0, position = GetPosition("P3_Spawn1"), building = GetID("P3_Tower1"),
		troops = {}, rodeLength = 5000, strength = 6},
		{id = 1, position = GetPosition("P3_Spawn2"), building = GetID("P3_Tower2"),
		troops = {}, rodeLength = 6000, strength = 6},
		{id = 2, position = GetPosition("P3_Spawn3"), building = GetID("P3_Tower3"),
		troops = {}, rodeLength = 4300, strength = 8},
		{id = 3, position = GetPosition("P3_Spawn4"), building = GetID("KerberosBurg"),
		troops = {}, rodeLength = 5500, strength = 10}},
		[4] = {{id = 0, position = GetPosition("Wik2"), building = GetID("VikTower1"),
		troops = {}, rodeLength = 3700, strength = 8},
		{id = 1, position = GetPosition("VikSpawn2"), building = GetID("VikTower2"),
		troops = {}, rodeLength = 3700, strength = 6},
		{id = 2, position = GetPosition("VikSpawn3"), building = GetID("VikTower3"),
		troops = {}, rodeLength = 7700, strength = 4},
		{id = 3, position = GetPosition("VikSpawn4"), building = GetID("VikTower4"),
		troops = {}, rodeLength = 6800, strength = 4},
		{id = 4, position = GetPosition("VikSpawn5"), building = GetID("VikTower5"),
		troops = {}, rodeLength = 7800, strength = 4},
		{id = 5, position = GetPosition("VikSpawn6"), building = GetID("VikTower6"),
		troops = {}, rodeLength = 9600, strength = 4},
		{id = 6, position = GetPosition("VikSpawn7"), building = GetID("VikTower7"),
		troops = {}, rodeLength = 9000, strength = 6},
		{id = 7, position = GetPosition("VikSpawn8"), building = GetID("VikTower8"),
		troops = {}, rodeLength = 11000, strength = 6},
		{id = 8, position = GetPosition("VikSpawn9"), building = GetID("VikTower9"),
		troops = {}, rodeLength = 5000, strength = 6},
		{id = 9, position = GetPosition("VikSpawn10"), building = GetID("VikTower10"),
		troops = {}, rodeLength = 8500, strength = 8},
		{id = 10, position = GetPosition("VikSpawn11"), building = GetID("VikTower11"),
		troops = {}, rodeLength = 4500, strength = 6}}
	}
	for player, data in pairs(ArmyData) do
		for i = 1, table.getn(data) do
			local army = {}
			army.player = player
			army.id	= data[i].id
			army.position = data[i].position
			army.rodeLength	= data[i].rodeLength
			army.strength = round(data[i].strength * (1.5/gvDiffLVL))
			SetupArmy(army)
			RefreshArmy(army.player, army.id, data[i].building)
		end
	end

	--**
	MakeInvulnerable("Pilgrim"); MakeInvulnerable("Dovbar")
	MakeInvulnerable("Bishop"); MakeInvulnerable("Priester")
	MakeInvulnerable("Comm"); MakeInvulnerable("Johannes")
	MakeInvulnerable("Scout")
	for i = 1,8 do
		MakeInvulnerable("fire_guard" .. i)
	end
	--**
	StartCutscene("Intro", Prolog)
end
function RefreshArmy(_player, _id, _building)
	local army = ArmyTable[_player][_id + 1]
	local trooptypes = KerbTroopTypes
	if _player == 4 then
		trooptypes = WikTroopTypes
	end
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = trooptypes[math.random(table.getn(trooptypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{_player, _id, _building})
end
function ControlArmies(_player, _id, _hq)
	local army = ArmyTable[_player][_id + 1]
	if not IsExisting(_hq) then
		if IsDead(army) then
			return true
		end
	else
		if IsVeryWeak(army) and IsExisting(_hq) then
			if Counter.Tick2("ArmyDead_" .. _player .. "_" .. _id, round(60*gvDiffLVL)) then
				RefreshArmy(_player, _id, _hq)
				return true
			end
		end
	end
	Defend(army)
end
function InitMerchants()
	MerchantIDs = {GetID("merc1"), GetID("mercP8")}
	for i = 1,table.getn(MerchantIDs) do
		Logic.AddMercenaryOffer(MerchantIDs[i], Entities.CU_VeteranLieutenant, 4, ResourceType.Gold, 2500)
		Logic.AddMercenaryOffer(MerchantIDs[i], Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(MerchantIDs[i], Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(MerchantIDs[i], Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
	end
	function CalculateMercenaryOfferCosts(_type, _soldiers)
		local lcost, solcost = {}, {}
		Logic.FillLeaderCostsTable(1, _type + 2 ^ 16, lcost)
		local maxsol = _soldiers or MaxSoldiersByLeaderType[_type] or 0
		if maxsol and maxsol > 0 then
			local soletype = GetEntityTypeSoldierType(_type)
			Logic.FillSoldierCostsTable(1, soletype + 2 ^ 16, solcost)
		end

		local total = 0
		for i = 1, 17 do
			if i == ResourceType.Silver then
				lcost[i] = lcost[i] * 20
			elseif i == ResourceType.Knowledge then
				lcost[i] = lcost[i] * 5
			end
			total = total + lcost[i] + ((solcost[i] and solcost[i] * maxsol) or 0)
		end
		return round(total * 0.75)
	end
	MerchantData = {{[Entities.CU_BlackKnight_LeaderSword3] = {}},
					{[Entities.CU_BanditLeaderSword1] = {}},
					{[Entities.CU_BanditLeaderSword2] = {}},
					{[Entities.CU_BlackKnight_LeaderMace1] = {}},
					{[Entities.CU_BlackKnight_LeaderMace2] = {}},
					{[Entities.CU_Barbarian_LeaderClub1] = {}},
					{[Entities.CU_Barbarian_LeaderClub2] = {}},
					{[Entities.PU_LeaderSword1] = {}},
					{[Entities.PU_LeaderSword2] = {}},
					{[Entities.PU_LeaderSword3] = {}},
					{[Entities.PU_LeaderSword4] = {}},
					{[Entities.PU_LeaderPoleArm1] = {}},
					{[Entities.PU_LeaderPoleArm2] = {}},
					{[Entities.PU_LeaderPoleArm3] = {}},
					{[Entities.PU_LeaderPoleArm4] = {}},
					{[Entities.PU_LeaderBow1] = {}},
					{[Entities.PU_LeaderBow2] = {}},
					{[Entities.PU_LeaderBow3] = {}},
					{[Entities.PU_LeaderBow4] = {}},
					{[Entities.PU_LeaderCavalry1] = {}},
					{[Entities.PU_LeaderCavalry2] = {}},
					{[Entities.PU_LeaderHeavyCavalry1] = {}},
					{[Entities.PU_LeaderHeavyCavalry2] = {}},
					{[Entities.PU_LeaderRifle1] = {}},
					{[Entities.PU_LeaderRifle2] = {}},
					{[Entities.CU_Evil_LeaderBearman1] = {}},
					{[Entities.CU_Evil_LeaderSkirmisher1] = {}},
					{[Entities.CU_BanditLeaderBow1] = {}},
					{[Entities.PU_Scout] = {}},
					{[Entities.PU_Thief] = {}},
					{[Entities.PU_Serf] = {}},
					{[Entities.PU_BattleSerf] = {}},
					{[Entities.PU_LeaderUlan1] = {}},
					{[Entities.CU_VeteranCaptain] = {}},
					{[Entities.CU_VeteranLieutenant] = {}},
					{[Entities.CU_VeteranMajor] = {}},
					{[Entities.PV_Cannon1] = {}},
					{[Entities.PV_Cannon2] = {}},
					{[Entities.PV_Cannon3] = {}},
					{[Entities.PV_Cannon4] = {}},
					{[Entities.PV_Cannon5] = {}},
					{[Entities.PV_Ram] = {}}
	}
	MerchantDataReducedProbTypes = {
		[Entities.CU_VeteranCaptain] = true,
		[Entities.CU_VeteranLieutenant] = true,
		[Entities.CU_VeteranMajor] = true,
		[Entities.PV_Cannon5] = true,
		[Entities.PV_Ram] = true
	}
	local len = table.getn(MerchantData)
	for i = 1, len do
		for k, v in pairs(MerchantData[i]) do
			v[ResourceType.Gold] = CalculateMercenaryOfferCosts(k)
			if not MerchantDataReducedProbTypes[k] then
				MerchantData[len+i] = MerchantData[i]
			end
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
function ShuffleMerchantData()
	for i = 0, 3 do
		local amount = math.random(2,6)
		local rdata = MerchantData[math.random(1,table.getn(MerchantData))]
		for j = 1, table.getn(MerchantIDs) do
			local id = MerchantIDs[j]
			for k, v in pairs(rdata) do
				OverrideMercenarySlotData(id, i, k, amount, v)
			end
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
--**
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Berg",ment,"Dario, Ari und Drake sind weiter in die Kralberge gereist, um Kerberos endlich zu erwischen.", false)
	ASP("Pass",ment,"Kerberos konnte aus seiner brennenden Burg im letzten Moment über diesen Pass in die Berge fliehen.", false)
	ASP("Fort",ment,"Nachdem Drakon endlich von der Belagerung erlöst wurde, versucht Dario nun auch die anderen unterdrückten Regionen wieder zu befreien.", false)
	ASP("Sicht",dario,"Wir werden diese brennende Ruine für den Bau unserer Siedlung benutzen.", true)
	ASP("Ari",dario,"Repariert die Burg und dann suchen wir nach Kerberos.", true)
	ASP("Ruin_1",dario,"Ach ja und reißt die Ruinen ab, die sehen ja grässlich aus.", false)
	ASP("Ari",ari,"Wir sollten dennoch Vorsicht walten lassen. Dies hier sind Landstriche die bereits unter kerberos Kontrolle sind.",true)
    briefing.finished = function()
		ChangePlayer("Burg",1)
		DarioQuest()
		WulfilarQuest()
		Einleitung()
		EnableNpcMarker(GetEntityId("Dovbar"))
		EnableNpcMarker(GetEntityId("Scout"))
		EnableNpcMarker(GetEntityId("ClayMiner"))
		Dovbar_1()
		ClayMiner()
		InitMerchants()
		MakeInvulnerable("guard2")
		--
		StartCountdown(20*60*gvDiffLVL, IncreaseAIStrength, false)
		--
		SetHostile(1,4)
		SetHostile(1,3)
		SetHostile(1,2)
		--
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(2,3,4), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
			if Logic.IsLeader(eID) == 1 then
				table.insert(gvLightning.IgnoreIDs, eID)
				Logic.GroupStand(eID)
			end
		end
		--
		InitAchievementChecks()
	end
    StartBriefing(briefing)
end
function IncreaseAIStrength()
	for i = 2, 4 do
		for k,v in pairs(gvTechTable.TroopUpgrades) do
			Logic.SetTechnologyState(i, v, 3)
		end
	end
	MapEditor_Armies[2].offensiveArmies.strength = MapEditor_Armies[2].offensiveArmies.strength + 2
	StartCountdown(10 + (10*gvDiffLVL), IncreaseAIStrengthAgain, false)
end
function IncreaseAIStrengthAgain()
	MapEditor_Armies[2].offensiveArmies.strength = MapEditor_Armies[2].offensiveArmies.strength + 1
	StartCountdown(10 + (10*gvDiffLVL), IncreaseAIStrengthAgain, false)
end
function DarioQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Aufräumarbeiten",
		text	= "Repariert eure Burg, bevor sie vollständig zerfällt. @cr Zerstört nebenbei die Ruinen in der Nähe der Burg",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarQuest = quest.id
end
function WulfilarQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Fort Wulfilar",
		text	= "Sucht und geht mit Dario nach Fort Wulfilar. @cr Redet mit dessen Befehlshaber.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	WulQuest = quest.id
end

function Einleitung()
	StartSimpleJob("Zita")
	StartSimpleJob("Watchtower")
end

function Zita()
	if IsDestroyed("Ruin_1")
	and IsDestroyed("Ruin_2")
	and IsDestroyed("Ruin_3")
	and GetHealth ("Burg") >= 90 then
		Dario_2()
		return true
	end
end

function Watchtower()
	if not IsExisting("guard1") then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("guard2",gu2,"PETER! @cr @cr Oh mein Gott, Peter... @cr Diese Schweine haben Peter erwischt...", false)
		briefing.finished = function()
			Move("guard2","DarkCastle")
			StartSimpleJob("Guard2ArrivedAtKerberos")
		end
		StartBriefing(briefing)
		return true
	end
	local posX, posY = Logic.GetEntityPosition(GetID("search_pos1"))
	local num = Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 1000, 1)
	posX, posY = Logic.GetEntityPosition(GetID("search_pos2"))
	num = num + Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2200, 1)
	posX, posY = Logic.GetEntityPosition(GetID("search_pos3"))
	num = num + Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2700, 1)
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("guard1",gu1,"EINDRINGLINGE! @cr Los, Dieter, informiere die anderen Stellungen. @cr Ich gebe Kerberos Bescheid.", false)
		ASP("guard2",gu2,"Ist gut, Peter. @cr Ich gebe das Kommando zum Entzünden des Leuchtfeuers.", false)
		briefing.finished = function()
			Move("guard1","DarkCastle")
			StartCountdown(45+(15*gvDiffLVL)*60, LightenFire, false)
			StartSimpleJob("GuardArrivedAtKerberos")
		end
		StartBriefing(briefing)
		return true
	end
end
function GuardArrivedAtKerberos()
	if IsNear("guard1", "DarkCastle", 200) then
		local id = CreateEntity(2, Entities.CU_BlackKnight, GetPosition("DarkCastle"), "TempKerberos")
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		AP{
			title = gu1,
			text = "Kerberos. @cr Eindringlinge sind aufgetaucht. @cr Sie haben den Weg unterhalb des Wachturms in Richtung Fort Wulfilar genommen.",
			position = GetPosition("guard1"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(90)
				Camera.RotSetFlipBack(0)
			end
		}
		AP{
			title = kerbe,
			text = "Diese Eindringlinge wollen Fort Wulfilar sicherlich zur Hilfe kommen. @cr Wir sollten uns auf den Weg machen und Fort Wulfilar vernichten! @cr Los meine Schergen. @cr Vernichtet sie alle!",
			position = GetPosition("TempKerberos"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(90)
				Camera.RotSetFlipBack(0)
			end
		}
		briefing.finished = function()
			Move("guard1","guard1_pos")
			DestroyEntity("TempKerberos")
			MapEditor_Armies[2].offensiveArmies.rodeLength = Logic.WorldGetSize()
			MapEditor_Armies[2].offensiveArmies.enemySearchPosition = GetPosition("P2_Spawn6")
			Camera.RotSetFlipBack(1)
			Camera.RotSetAngle(-45)
		end
		StartBriefing(briefing)
		return true
	end
end
function Guard2ArrivedAtKerberos()
	if IsNear("guard2", "DarkCastle", 200) then
		local id = CreateEntity(2, Entities.CU_BlackKnight, GetPosition("DarkCastle"), "TempKerberos")
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		AP{
			title = gu2,
			text = "Kerberos. @cr Irgendjemand hat Peter erschossen. @cr Peter... @cr Ausgerechnet Peter... @cr Wiiiiiieso nur?",
			position = GetPosition("guard2"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(90)
				Camera.RotSetFlipBack(0)
			end
		}
		AP{
			title = kerbe,
			text = "Wir wissen nicht, wer es war. @cr Wir sollten jedoch die Wachsamkeit erhöhen. @cr Mach dir keine Gedanken, ich schicke dir einen neuen Peter.",
			position = GetPosition("TempKerberos"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(90)
				Camera.RotSetFlipBack(0)
			end
		}
		AP{
			title = kerbe,
			text = "Und nun zurück auf deinen Posten, Soldat.",
			position = GetPosition("TempKerberos"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(90)
				Camera.RotSetFlipBack(0)
			end
		}
		briefing.finished = function()
			Move("guard2","guard2_pos")
			local id = CreateEntity(2, Entities.CU_PoleArmIdle, GetPosition("DarkCastle"), "guard1")
			Move("guard1","guard1_pos")
			DestroyEntity("TempKerberos")
			MapEditor_Armies[2].offensiveArmies.rodeLength = MapEditor_Armies[2].offensiveArmies.rodeLength * 1.5
			MapEditor_Armies[2].offensiveArmies.enemySearchPosition = GetPosition("P2_Spawn6")
			StartSimpleJob("guards_back_at_position")
			Camera.RotSetFlipBack(1)
			Camera.RotSetAngle(-45)
		end
		StartBriefing(briefing)
		return true
	end
end
function guards_back_at_position()
	if IsNear("guard1", "guard1_pos", 200) or IsNear("guard2", "guard2_pos") then
		StartSimpleJob("Watchtower")
		return true
	end
end
function LightenFire()
	ReplaceEntity("fire1", Entities.XD_SingnalFireOn)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("fire_guard1",fgu1,"Ich habe das Leuchtfeuer entzündet. @cr Bald schon wissen alle unsere Militärlager ob der Eindringlinge.", false)
	briefing.finished = function()
		Move("fire_guard1", "fire1")
		Move("fire_guard4", "fire4")
		StartCutscene("FiresOn", FiresOn_CutsceneDone)
	end
	StartBriefing(briefing)
end
function FiresOn_CutsceneDone()
	DestroyEntity("rock_f1")
	DestroyEntity("rock_f2")
	for i = 1, table.getn(ArmyTable[3]) do
		ArmyTable[3][i].rodeLength = Logic.WorldGetSize()
	end
	for i = 1, table.getn(ArmyTable[2]) do
		ArmyTable[2][i].rodeLength = Logic.WorldGetSize()
	end
	StartCountdown(2*60*gvDiffLVL, VargNoticed, false)
end
function VargNoticed()
	if IsDestroyed("WatchTower") then
		return true
	end
	local posVarg = {X = 49500, Y = 20000}
	local posGuard = {X = 49800, Y = 20300}
	CreateEntity(4, Entities.CU_Barbarian_Hero, posVarg, "Varg")
	Logic.RotateEntity(GetID("Varg", 30))
	CreateEntity(4, Entities.CU_PoleArmIdle, posGuard, "TowerGuard")
	Logic.RotateEntity(GetID("TowerGuard", 220))
	--
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("TowerGuard",vtg,"Varg... @cr Das Leuchtfeuer von Thrandu 'El wurde entzündet. @cr Kerberos ersucht unsere Unterstützung.", false)
	ASP("Varg",var,"Ich bin grade erst entkommen. @cr Wir warten ab. @cr Kerberos wird schon ohne uns zurecht kommen. @cr Geb mir erneut Bescheid, wenn es schlecht um Kerberos steht.", false)
	briefing.finished = function()
		DestroyEntity("Varg")
		StartSimpleJob("WatchTowerVargJob")
	end
	StartBriefing(briefing)
end
function WatchTowerVargJob()
	if IsDestroyed("WatchTower") and IsDead("TowerGuard") then
		return true
	end
	local posX, posY = Logic.GetEntityPosition(GetID("gate_outro"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2500, 1) > 0 then
		local posVarg = GetPosition("Pfad")
		CreateEntity(4, Entities.CU_Barbarian_Hero, posVarg, "Varg")
		CreateMilitaryGroup(4, Entities.CU_Barbarian_LeaderClub2, 10, {X = 55450, Y = 10100}, "VargGuard1")
		CreateMilitaryGroup(4, Entities.CU_Barbarian_LeaderClub2, 10, {X = 55750, Y = 10100}, "VargGuard2")
		--
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("TowerGuard",vtg,"Varg... @cr Kerberos Truppen sind bereits auf dem Rückzug und verlieren immer mehr Boden. @cr Sollen wir ihnen zu Hilfe kommen?", false)
		ASP("Varg",var,"Schickt die Hälfte unserer Krieger, um den Vormarsch des Feindes zu verlangsamen. @cr Der Rest folgt mir zur alten Feste am Nordmeer.", false)
		briefing.finished = function()
			for i = 1, table.getn(ArmyTable[4]) do
				ArmyTable[4][i].rodeLength = Logic.WorldGetSize()
				MapEditor_Armies[4].offensiveArmies.rodeLength = Logic.WorldGetSize()
			end
			DestroyEntity("Varg")
			DestroyEntity("TowerGuard")
			Logic.DestroyGroupByLeader(GetID("VargGuard1"))
			Logic.DestroyGroupByLeader(GetID("VargGuard2"))
		end
		StartBriefing(briefing)
		return true
	end
end

function Dario_2()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Dario",dario,"Gute Arbeit, die Burg steht wieder. @cr Nun sollten wir auskundschaften, wo die unterdrückten Dörfer hier liegen und dann können wir dort nach Hinweisen zu Kerberos Verbleiben nachfragen.", false)
    briefing.finished = function()
		Logic.RemoveQuest(1,DarQuest)
		Scout()
		Move("Scout","Dario")
	end
    StartBriefing(briefing)
end
function Scout()
	local BeiSc = {
	EntityName = "Dario",
    TargetName = "Scout",
    Distance = 500,
    Callback = function()
		LookAt("Scout","Dario");LookAt("Dario","Scout")
		DisableNpcMarker(GetEntityId("Scout"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Scout",sc,"*Hust Keuch* Schlechte Nachrichten aus Drakon, werter Herr.", true)
		ASP("Pfad",sc,"Varg konnte zusammen mit einem mies gelaunten Scharfschützen aus seinem Gefängnis fliehen.", false)
		ASP("Scout",sc,"*Keuch Hechel* Sie sind bestimmt bereits zusammen mit Kerberos am Nordmeer angetroffen. *Hust WASSER BITTE MEIN HERR*", true)
		ASP("Dario",dario,"Was sie dort wohl vorhaben? Was steht ihr noch rum, gebt diesem Mann Wasser, er verdurstet ja fast.", true)
		briefing.finished = function()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSc)
end
--**
function ClayMiner()
	local BeiCM = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "ClayMiner",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("ClayMiner"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("ClayMiner",id);LookAt(id,"ClayMiner")
		DisableNpcMarker(GetEntityId("ClayMiner"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("ClayMiner",mi,"Guten Tag, der Herr. Interesse an einem kleinen Deal?", true)
		ASP("Clay",mi,"Meine Kollegen und ich wollten demnächst in Rente gehen. Daher verscherbeln wir unsere Mine für, naja sagen wir eine kleine Provision.", false)
		ASP("ClayMiner",mi,"Was ist heutzutage schon noch kostenlos?!", true)
		ASP("Clay",mi,"Ihr braucht euch keine Sorgen zu machen, wir verkaufen für einen fairen Preis.", false)
		briefing.finished = function()
			Tribute()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiCM)
end
function Tribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. round(2000/gvDiffLVL) .. " Taler, um eine Lehmmine zu ersteigern.";
	tribute.cost = {Gold = round(2000/gvDiffLVL)};
	tribute.Callback = PayedTribute;
	AddTribute( tribute )
end
function PayedTribute()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("ClayMiner",mi,"Danke für die Zahlung. @cr Jetzt können wir mit ordentlich Geld in den Taschen in den Ruhestand gehen und ihr habt eure versprochene Mine! ", false)
	briefing.finished = function()
		ChangePlayer("Clay",1)
	end;
	StartBriefing(briefing);
end

function Dovbar_1()
	local BeiDo = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Dovbar",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Dovbar"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Dovbar",id);LookAt(id,"Dovbar")
		DisableNpcMarker(GetEntityId("Dovbar"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dovbar",dov,"Guten Tag " .. GetNPCDefaultNameByID(id) .. ". @cr Wie ihr seht, versucht Kerberos unser friedliches Bergdorf zu vernichten.", true)
		ASP("Dovbar",dov,"Leider sind unsere Truppen keine erfahrenen Krieger und Kerberos Truppen deutlich unterlegen.", true)
		ASP("Grab",dov,"Dieser sinnlose Krieg hat schon zu viele Opfer gefordert.", true)
		ASP("Dovbar",dov,"Und wenn das nicht schon genug wäre, hat Kerberos ein weiteres Lager in den Bergen aufgeschlagen. @cr Uns droht ein Kampf von zwei Seiten.", true)
		ASP("Dovbar",dov,"Bitte zermalmt Kerberos Außenposten für uns und beendet damit diese zusätzliche Bedrohung.", true)
		AP{
			title = dov,
			text = "Ihr findet ihn dort oben auf dem Berg. Aber passt auf, er ist sehr gut gesichert.",
			position = GetPosition("KerberosBurg"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		ASP("Dovbar",dov,"Um Kerberos Hauptsiedlung kümmern wir uns gemeinsam, wenn die Bedrohung durch den Außenposten nicht mehr gegeben ist.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1,WulQuest)
			QuestBefreiung()
			EnableNpcMarker(GetEntityId("Comm"))
			Kommandant()
			ActivateShareExploration( 1,7, true )
			Vorbereitung_4()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiDo)
end
--**
function QuestBefreiung()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Der Außenposten",
		text	= "Vernichtet den Außenposten Kerberos.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BefreiungQuest = quest.id
end
--**
function Kommandant()
	local BeiCo = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Comm",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Comm"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Comm",id);LookAt(id,"Comm")
			DisableNpcMarker(GetEntityId("Comm"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Comm",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wie ich sehe seid ihr schwer beschäftigt. @cr Der Regent erzählte mir bereits von eurem Problem.", true)
			ASP("Comm",comm,"Ja es ist wirklich schlimm um uns bestellt.", true)
			ASP("Comm",comm,"Kerberos Truppen sind uns weit überlegen...", true)
			ASP("Comm",comm,"Helft uns doch bitte bei der Verteidigung und baut zwei Ballistatürme an den Toren zu unserem Dorf.", true)
			ASP("Rechts",comm,"Einen hier.", true)
			ASP("Links",comm,"Und einen dort!", true)
			briefing.finished = function()
				QuestTurm()
				Vorbereitung()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiCo)
end
--**
function QuestTurm()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Die Verteidigung",
		text	= "Baut zwei Ballistatürme an den vom Anführer vorgegebenen Stellen. @cr Einen rechts und einen links vom Tor.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	TurmQuest = quest.id
end
--**
function Vorbereitung()

	StartSimpleJob("FertigMeldung")
	StartSimpleJob("AbfrageTurm_1")
	StartSimpleJob("AbfrageTurm_2")

end
--**
function AbfrageTurm_1()
	idTw = SucheAufDerWelt(1,Entities.PB_Tower2,1000,GetPosition("Rechts"))
	if table.getn(idTw) > 0 and Logic.IsConstructionComplete(idTw[1]) == 1 then
		idTw = idTw[1]
		ChangePlayer(idTw,7)
		gvTw = 1
		return true
	end
end
--**
function AbfrageTurm_2()
	idTo = SucheAufDerWelt(1,Entities.PB_Tower2,1000,GetPosition("Links"))
	if table.getn(idTo) > 0 and Logic.IsConstructionComplete(idTo[1]) == 1 then
		idTo = idTo[1]
		ChangePlayer(idTo,7)
		gvTo = 1
		return true
	end
end
--**
function FertigMeldung()
	if gvTw == 1 and gvTo == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Die gewünschten Gebäude wurden fertiggestellt.", true)
		ASP("Comm",comm,"Danke, nun müssten wir wenigstens ein wenig geschützt sein.", true)
		ASP("Comm",comm,"Ach ja genau, ich hab da noch einen Tipp für euch. @cr Sozusagen als kleines Dankeschön.", true)
		ASP("Pilgrim",comm,"Schon seit geraumer Zeit haust dort hinten in der Ecke so ein komischer Kauz.", true)
		ASP("Pilgrim",comm,"Der nuschelt immer so ein wirres Zeug in sein Bart und spielt ständig mit Sprengstoff herum.", false)
		ASP("Pilgrim",comm,"Vielleicht kann der euch ja bei eurem schwierigen Unterfangen weiterhelfen.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,TurmQuest)
			EnableNpcMarker(GetEntityId("Pilgrim"))
			Pilgrim()
			Hut()
		end;
		StartBriefing(briefing);
		return true
	end
end
function Hut()
	SetHealth ("Hut",1)
end

function Pilgrim()
	local BeiPi = {
		EntityName = "Dario",
		TargetName = "Pilgrim",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Pilgrim"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Pilgrim",id);LookAt(id,"Pilgrim")
			DisableNpcMarker(GetEntityId("Pilgrim"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Pilgrim",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Es erstaunt mich, euch hier zu sehen Pilgrim. @cr Was tut ihr hier?", true)
			ASP("Pilgrim",pil,"(Nuschelt etwas in seinen Bart) @cr ...Verflixt, wo ist denn schon wieder mein Sprengstoff hin?", true)
			ASP("Hut",pil,"Nanu, warum brennt denn meine Hütte auf einmal lichterloh?", true)
			ASP("Pilgrim",pil,"Ach ihr seid es, werter Freund, warum sagt ihr das nicht gleich? *Angroschem*... ", true)
			ASP("Pilgrim",pil,"Ich war auf der Suche nach Schwefel für neuen Sprengstoff und bin daher in diese Berge gereist.", true)
			ASP("Pilgrim",pil,"Aber hier gibt es fast gar keinen Schwefel, und nun kann ich nicht einmal mehr weiterreisen, weil diese Truppen von Kerberos alle Wege aus diesen Bergen dicht gemacht haben.", true)
			ASP("Pilgrim",pil,"Meine Fresse, was würde ich nicht alles tun, damit diese Bastarde endlich mal wieder mein Axtblatt spüren.", true)
			ASP("Weg",pil,"Hier gibt es mehrere Wege, die direkt in Kerberos Außenposten führen. Leider sind sie seit dem letzten Bergrutsch allesamt verschüttet.", false)
			ASP("Hang",pil,"Gebt mir ein wenig Schwefel, dann werde ich die Wege für euch freisprengen.", false)
			ASP("Pilgrim",pil,"Ach ja in der Ekstase über baldige Sprengungen hab ich eines vollkommen vergessen.", true)
			ASP("Johannes",pil,"Euer Freund aus damaliger Zeit, Bruder Johannes, ist über irgendetwas sehr traurig. Bitte tut mir doch den Gefallen und redet mit ihm.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich sehe, was sich tun lässt.", true)
			briefing.finished = function()
				EnableNpcMarker(GetEntityId("Johannes"))
				QuestPilgrim_1()
				QuestPilgrim_2()
				Johannes()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiPi)
end
function QuestPilgrim_1()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Der Sprengstoff",
		text	= "Liefert 200.000 Schwefel an Pilgrim, damit er die verschütteten Wege freisprengen kann. @cr Hinweis: Vielleicht gibt es ja auch andere Wege...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	PilQuest = quest.id
end
function QuestPilgrim_2()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Tröstet euren alten Freund",
		text	= "Geht zu Bruder Johannes und redet mit ihm. @cr Er scheint ein riesiges Problem zu haben, über das er sehr traurig ist. @cr Hinweis: Er redet wohl nur mit Dario...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	PilgrimQuest = quest.id
end
function Johannes()
	local BeiJo = {
		EntityName = "Dario",
		TargetName = "Johannes",
		Distance = 300,
		Callback = function()
			LookAt("Johannes","Dario");LookAt("Dario","Johannes")
			DisableNpcMarker(GetEntityId("Johannes"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Johannes",dario,"Guten Tag, Johannes, ich hörte ihr seid über etwas sehr traurig und ich wollte euch dabei beistehen.", false)
			ASP("Johannes",jo,"(Mit tränenbedeckter Stimme) Mir geht es gar nicht gut Dario wuhuhuää.", true)
			ASP("Dario",dario,"Erzählt es mir, was stimmt euch so traurig? Eurem treuen Freund könnt ihr vertrauen.", true)
			ASP("Dario",dario,"Ich verspreche euch, dass ich helfen werde, egal was es ist.", true)
			ASP("Johannes",jo,"Nun gut, aber behaltet es für euch, die Leute hier haben genug Probleme und wenn sie auch noch ihr Glaube verlässt, ist alles verloren...", true)
			ASP("Johannes",jo,"Seit bereits geraumer Zeit wurde aus dem Kloster im Süden der Priester entführt.", true)
			ASP("Johannes",jo,"Er hielt Predigten, sich gegen Kerberos Unterdrückung aufzulehnen.", true)
			AP{
				title = jo,
				text = "Er wurde verhaftet und arrestiert, da er angeblich das Volk aufhetze.",
				position = GetPosition("Knast"),
				marker = STATIC_MARKER,
				dialogCamera = false,
			}

			ASP("Bishop",jo,"Mein Glaube ist zurzeit leider nicht stark genug, als dass ich glauben könnte, dass er wohlauf ist.", false)
			ASP("Johannes",jo,"Bitte rächt ihn im Namen unseres Herrn.", true)
			ASP("Dario",dario,"Ich werde mein bestes tun Johannes und gebt eure Hoffnung nie auf, er ist bestimmt noch am Leben.", true)
			ASP("Johannes",jo,"Ach Dario, wenn ich nur euren Enthusiasmus hätte. @cr Gott sei mit euch und gebe euch Kraft. @cr Amen.", true)
			ASP("Johannes",jo,"Nebenbei könnt ihr meinen Brüdern auch noch einen Besuch abstatten und ihnen bei deren Problemen helfen.", true)
			ASP("Priester",jo,"Ich war schon Ewigkeiten nicht mehr da. @cr Seit Kerberos dieses Dorf angreift, kann keiner es mehr sicher verlassen.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,PilgrimQuest)
				EnableNpcMarker(GetEntityId("Bishop"))
				EnableNpcMarker(GetEntityId("Priester"))
				EnableNpcMarker(GetEntityId("Dovbar"))
				QuestJohannes_1()
				QuestJohannes_2()
				Priester()
				Dovbar_2()
				Bishop()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiJo)
end
function QuestJohannes_1()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Sprecht mit dem Mönch im Kloster im Süden",
		text	= "Geht zum Mönch und redet mit ihm. Johannes macht sich Sorgen um ihn.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	JoQuest = quest.id
end
function QuestJohannes_2()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Befreit den Priester",
		text	= "Befreit den Priester aus seinem Gefängnis.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	JohannesQuest = quest.id
end
function Priester()
	local BeiPr = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Priester",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Priester"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Priester",id);LookAt(id,"Priester")
			DisableNpcMarker(GetEntityId("Priester"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, werter Herr, Bruder Johannes schickt mich. Ich soll mich um euer Befinden informieren und mich um euch kümmern.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Er sagte, ihr habt einige Aufgaben für mich. @cr Er erzählte mir auch von dem Verschwinden des Priesters. @cr Das tut mir so unendlich leid.", true)
			ASP("Priester",pri,"Ja in der Tat wir trauern bereits mehrere Tage und beten regelmäßig für sein Wohlbefinden. @cr Bruder Johannes war schon immer gut zu uns. @cr Richtet ihm von uns unsere Dankbarkeit aus.", true)
			ASP("Priester",pri,"Und ja, gut das ihr fragt, wir haben hier wirklich vieles zu tun, seit Kerberos Schergen einen Großteil unseres Klosterdorfes niedergebrannt haben.", true)
			AP{
				title = pri,
				text = "Redet aber für die Einzelheiten mit Garek. @cr Ihr findet ihn an seinem Schloss.",
				position = GetPosition("Garek"),
				marker = STATIC_MARKER,
				dialogCamera = false,
			}

			ASP("Priester",pri,"Und bitte tut auch mir einen Gefallen und befreit den Priester so schnell wie möglich.", true)
			ASP("Sperre",pri,"Ich habe auch noch eine Information für Euch: @cr Ich weiß nicht ob es ein Segen oder ein Fluch ist, aber der Außenposten Kerberos ist seit dem letzten Bergrutsch unerreichbar.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,JoQuest)
				EnableNpcMarker(GetEntityId("Garek"))
				QuestPriester()
				Garek()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiPr)
end
function Dovbar_2()
	local BeiDov = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Dovbar",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Dovbar"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Dovbar",id);LookAt(id,"Dovbar")
			DisableNpcMarker(GetEntityId("Dovbar"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Dovbar",dov,"Gut das ihr mit Bruder Johannes geredet habt. @cr Er hat gleich nach eurem Gespräch seinen Pessimismus verloren.", true)
			ASP("Dovbar",dov,"Seine Depression hat uns alle hier sehr bewegt und unsere Moral noch weiter verringert. @cr Wenn es erlaubt ist, würdet ihr mir bitte sagen, worum es bei seinem Problem ging?", true)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Tut mir leid, das darf ich euch nicht verraten.", true)
			ASP("Comm",dov,"Na ja auch egal, ich wollte mich nur noch einmal für eure Hilfe bedanken. @cr Der Anführer unserer Truppen war wirklich sehr begeistert, wie schnell ihr ihm helfen konntet.", true)
			AP{
				title = dov,
				text = "Seine Truppen haben ein Schwefelbergwerk nahe Kerberos Land entdeckt. @cr Ich hörte von Pilgrim, dass ihr ein Schwefelproblem habt. @cr Vielleicht könnt ihr damit ja Eurem Problem Herr werden.",
				position = GetPosition("Schwefel"),
				marker = STATIC_MARKER,
				dialogCamera = false,
			}
			ASP("Dovbar",dov,"Wir hatten außerdem gehört, dass alle Wege zu Kerberos Außenposten aktuell verschüttet seien. @cr Wir werden diese seltene Gelegenheit nutzen, um in die Offensive zu gehen.", true)
			briefing.finished = function()
				EnableNpcMarker(GetEntityId("Pilgrim"))
				Pilgrim_2()
				local id = ReplaceEntity("Dovbar", Entities.PU_Hero13)
				ConnectLeaderWithArmy(id, nil, "offensiveArmies")
				MapEditor_Armies[7].offensiveArmies.rodeLength = Logic.WorldGetSize()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiDov)
end
function Pilgrim_2()
	local BeiPilg = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Pilgrim",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Pilgrim"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Pilgrim",id);LookAt(id,"Pilgrim")
			DisableNpcMarker(GetEntityId("Pilgrim"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Dovbar erzählte mir gerade von einem Schwefelbergwerk im Süden. @cr Das würde unsere Schwefelprobleme decken.", true)
			ASP("Pilgrim",pil,"Ja, das müsste hinhauen.", true)
			ASP("Pilgrim",pil,"Baut mir die Mine und ich baue dann den benötigten Schwefel eigenhändig ab.", true)
			briefing.finished = function()
				Logic.RemoveQuest(1,PilQuest)
				QuestSchwefel()
				Vorbereitung_2()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiPilg)
end
function QuestPriester()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Sprecht mit Garek",
		text	= "Geht zu Garek und redet mit ihm.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	GarekQuest = quest.id
end
function QuestSchwefel()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Errichtet einen Schwefelstollen",
		text	= "Errichtet einen Schwefelstollen. @cr Befestigt die Stellung, Kerberos Truppen sind ganz nah.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	SchwefQuest = quest.id
end
function Vorbereitung_2()
	StartSimpleJob("AbfrageMine")
end
--**
function AbfrageMine()
	idMi = SucheAufDerWelt(1,Entities.PB_SulfurMine2,1000,GetPosition("Schwefel"))
	if table.getn(idMi) > 0 and Logic.IsConstructionComplete(idMi[1]) == 1 then
		idMi = idMi[1]
		ChangePlayer(idMi,7)
		gvMi = 1
		StartSimpleJob("Gebaut")
		return true
	end
end
--**
function Gebaut()
	if gvMi == 1 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Der Schwefelstollen steht jetzt.", true)
		ASP("Pilgrim",pil,"Ist gut, ich fange gleich mit dem Abbau an.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,SchwefQuest)
			StartSimpleJob("Nah")
			Abbau()
		end;
		StartBriefing(briefing);
		return true
	end
end
function Abbau()
	Move ("Pilgrim","Schwefel")
end
function Nah()
	if IsNear("Pilgrim","Schwefel",600) then
		EnableNpcMarker(GetEntityId("Pilgrim"))
		Pilgrim_3()
		return true
	end
end
function Pilgrim_3()
	local BeiPilgr = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Pilgrim",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Pilgrim"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Pilgrim",id);LookAt(id,"Pilgrim")
			DisableNpcMarker(GetEntityId("Pilgrim"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Schwefel",pil,"Jawoll, das wird erstmal eine Weile reichen.", false)
			ASP("Pilgrim",pil,"Lasst uns anfangen zu SPPPPPPRENGEN, HEYHEYHEEEEEY.", true)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Du wirst ja schon ganz kribbelig Pilgrim. @cr Lasst uns mit den Sprengungen beeilen, bevor er versehentlich noch unsere Häuser hochjagt.", true)
			ASP("Pilgrim",ment,"Nun, da Pilgrim sich den Helden angeschlossen hat, steht eins fest. @cr Es wird nun nur noch stetig voran Richtung Kerberos Niederlage gehen. @cr Es wird nun nicht mehr spielentscheidend sein, wenn einer Eurer Helden in Ohnmacht fällt!", false)
			briefing.finished = function()
				Chapter1Done = true
				MapEditor_Armies[2].offensiveArmies.rodeLength = Logic.WorldGetSize()
				MapEditor_Armies[2].offensiveArmies.enemySearchPosition = GetPosition("P2_Spawn6")
				ChangePlayer("Pilgrim",1)
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiPilgr)
end

function Garek()
	local Beiga = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Garek",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Garek"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Garek",id);LookAt(id,"Garek")
			DisableNpcMarker(GetEntityId("Garek"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Garek",ga,"Hallo " .. GetNPCDefaultNameByID(id) .. ". @cr Der Priester hat euch bestimmt geschickt.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ja das ist wahr, er sagt ihr benötigt meine Hilfe.", true)
			ASP("Garek",ga,"Neinnein da habt ihr euch wohl verhört.", true)
			ASP("Garek",ga,"Seit dem letzten Bergrutsch lassen Kerberos Truppen uns endlich in Ruhe und die Ruinen werden wir selbst wieder aufbauen.", true)
			ASP("Garek",ga,"Unseren alten Randbezirk mussten wir leider aufgeben und die Tore schließen.", true)
			ASP("Gate",ga,"Nun, da es hier wieder einigermaßen sicher ist, können wir das Tor wieder öffnen. @cr Zur Not werdet ihr uns ja hoffentlich mit Euren Truppen verteidigen.", false)
			AP{
				title = ga,
				text = "Passt aber auf, bereits kurz hinter dem Tor befindet sich ein Bergpfad hoch zu Kerberos Außenposten.",
				position = GetPosition("Gate"),
				marker = STATIC_MARKER,
				dialogCamera = false,
			}
			ASP("Ruine",ga,"Aber wenn ihr uns unbedingt helfen wollt, könnt ihr für uns die Kirchenruine dort hinten abreißen und dafür an dieser Stelle eine prunkvolle neue Kirche bauen.", false)
			ASP("Ruine",ga,"Vielleicht eignen sich die Ruinen ja auch für eine Restauration, aber wer weiß das schon...", false)
			ASP("Priester",ga,"Die Bischöfe hier würden sich darüber sicher freuen.", false)

			briefing.finished = function()
				Logic.RemoveQuest(1,GarekQuest)
				Gate()
				RuinQuest()
				Vorbereitung_3()
				StartCountdown((3+math.random(2))*60/gvDiffLVL, Garek2, false)
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(Beiga)
end
function Garek2()
	EnableNpcMarker(GetEntityId("Garek"))
	GarekBrief2()
end
function GarekBrief2()
	local Beiga = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Garek",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Garek"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Garek",id);LookAt(id,"Garek")
			DisableNpcMarker(GetEntityId("Garek"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Garek",ga,"Hallo " .. GetNPCDefaultNameByID(id) .. ". @cr Gut euch erneut wohlauf zu sehen. @cr Ich hatte vorhin noch etwas vergessen.", false)
			ASP("MajorP8",ga,"Der Bürgermeister von Stonesdale steckt in Schwierigkeiten.", false)
			ASP("VikTower9",ga,"Die Siedlung ist komplett umzingelt von marodierenden Wikingerhorden. @cr Ich weiß nicht, wie lange sie noch ausharren können.", false)
			ASP("VikTower10",ga,"Auch die weitere Handelsroute im Norden Stonesdales ist nicht mehr sicher. @cr Auch dort haben die Wikinger ein Lager errichtet.", false)
			ASP("Garek",ga,"Bitte seid so gut und vertreibt die Wikinger. @cr Es soll Euer Schaden nicht sein. @cr Man munkelt, sie horten große Reichtümer.", false)

			briefing.finished = function()
				StonesdaleQuest()
				StartSimpleJob("SdaleVikingTowersDown")
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(Beiga)
end
function StonesdaleQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Befreit Stonesdale",
		text	= "Schafft einen Weg nach Stonesdale. @cr Vernichtet die zwei der Siedlung naheliegenden Wikingerlager.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	SdaleQuest = quest.id
end
function SdaleVikingTowersDown()
	if IsDestroyed("VikTower9") and IsDestroyed("VikTower10") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("MajorP8",mjP8,"Habt Dank, dass ihr die Wikingerlager nahe unserer Siedlung vernichtet habt. @cr Kommt uns gerne besuchen.", false)
    	briefing.finished = function()
			Logic.RemoveQuest(1,SdaleQuest)
			EnableNpcMarker(GetEntityId("MajorP8"))
			EnableNpcMarker(GetEntityId("mountain_guard1"))
			EnableNpcMarker(GetEntityId("mountain_guard2"))
			Mountain_Guard1()
			Mountain_Guard2()
			MajorP8_Brief1()
		end;
		StartBriefing(briefing);
		return true
	end
end
function Mountain_Guard1()
	local BeiMG1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "mountain_guard1",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("mountain_guard1"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("mountain_guard1",id);LookAt(id,"mountain_guard1")
			DisableNpcMarker(GetEntityId("mountain_guard1"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","He, ihr da. @cr Macht, das Tor auf, die Wikinger sind fort!", false)
			ASP("mountain_guard1",MG1,"Zzzzzzz... @cr Wie? Was? @cr ... Häh? @cr Wer seid ihr? @cr Was wollt ihr?", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir haben die Wikinger vor eurer Haustür vertrieben. @cr Ihr müsst die Tore nicht mehr geschlossen halten.", false)
			ASP("mountain_guard1",MG1,"Gähn... @cr Äh ja... @cr OK. @cr Ich mache euch das Tor dann mal ... äh ... wie hieß das Wort noch....?", false)

			briefing.finished = function()
				ReplaceEntity("mountain_gate1", Entities.XD_WallStraightGate)
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMG1)
end
function Mountain_Guard2()
	local BeiMG2 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "mountain_guard2",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("mountain_guard2"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("mountain_guard2",id);LookAt(id,"mountain_guard2")
			DisableNpcMarker(GetEntityId("mountain_guard2"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("mountain_guard2",MG2,"Heh, ihr da! @cr Hier gibts nichts zu sehen! @cr Schert euch fort!", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Redet man so mit seinem Befreier? @cr Schaut doch, wir haben die Wikinger vertrieben.", false)
			ASP("mountain_guard2",MG2,"Ist das wahr? @cr Igor, schau mal durch dein Fernglas und berichte mir.", false)
			ASP("mountain_guard3",MG3,"*Zückt sein Fernglas* @cr Oh, kann das wirklich sein? Nun, ich sehe nur noch Rauch, keine Nordmänner mehr.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","*Hüstel* @cr Ein wenig Dankbarkeit wäre wohl angebracht... @cr Und macht uns endlich das Tor auf.", false)
			ASP("mountain_guard2",MG2,"Jaja, ist ja schon gut. @cr Ist doch wohl Dank genug, dass wir das Tor für euch öffnen!", false)

			briefing.finished = function()
				ReplaceEntity("mountain_gate2", Entities.XD_WallStraightGate)
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMG2)
end
function MajorP8_Brief1()
	local Beimjp8 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "MajorP8",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("MajorP8"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("MajorP8",id);LookAt(id,"MajorP8")
			DisableNpcMarker(GetEntityId("MajorP8"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("MajorP8",mjP8,"Guten Tag der Herr. @cr Vielen Dank, dass ihr den Zugang zu unserer Siedlung wieder ermöglicht habt.", false)
			ASP("TraderP8",mjP8,"Schaut euch gerne in unserer Siedlung um. @cr Der ein oder andere Dörfler hat sicherlich hilfreiche Informationen für euch oder bietet seine Waren zu guten Preisen an.", false)
			ASP("MajorP8",mjP8,"Ach, und nehmt diese Steine als Zeichen unserer Dankbarkeit.", false)
			briefing.finished = function()
				AddStone(round(3000*gvDiffLVL))
				EnableNpcMarker(GetID("TraderP8"))
				TraderP8()
				StartCountdown(round(10/gvDiffLVL) * 60, MajorP8_2, false)
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(Beimjp8)
end
function MajorP8_2()
	EnableNpcMarker(GetID("MajorP8"))
	MajorP8_Brief2()
end
function MajorP8_Brief2()
	local Beimjp8 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "MajorP8",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("MajorP8"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("MajorP8",id);LookAt(id,"MajorP8")
			DisableNpcMarker(GetEntityId("MajorP8"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("MajorP8",mjP8,"Ah ihr seid es wieder. @cr Ich habe Euch bereits erwartet.", false)
			ASP("MajorP8",mjP8,"Nun, der Konflikt mit den Wikingern hat stark an meinen Kräften gezehrt. @cr ... und der Jüngste bin ich auch nicht mehr. @cr Daher unterbreite ich Euch folgenden Auftrag.", false)
			ASP("HQP4",mjP8,"Vernichtet die Wikinger vollständig als Beweis Eurer Stärke. @cr Dann könnt ihr der neue Bürgermeister dieses Dorfes werden.", false)
			briefing.finished = function()
				MajorP8_Quest()
				StartSimpleJob("VikingsDeadJob")
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(Beimjp8)
end
function MajorP8_Quest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Vernichtet die Wikinger",
		text	= "Zerstört alle verbliebenen Lager der Wikinger, um Euch Stonesdale als würdiger künftiger Bürgermeister zu erweisen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	Sdale2Quest = quest.id
end
function VikingsDeadJob()
	if IsDestroyed("HQP4") and IsDestroyed("VikTower1") and IsDestroyed("VikTower2") and IsDestroyed("VikTower3") and IsDestroyed("VikTower4")
	and IsDestroyed("VikTower5") and IsDestroyed("VikTower6") and IsDestroyed("VikTower7") and IsDestroyed("VikTower8") and IsDestroyed("VikTower9")
	and IsDestroyed("VikTower10") and IsDestroyed("VikTower11") and (Logic.GetNumberOfLeader(4) <= 1) then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("MajorP8",mjP8,"Nun gut, ihr habt mich überzeugt. @cr Achtet gut auf die Bewohner Stonesdales.", false)
		briefing.finished = function()
			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(8), CEntityIterator.IsSettlerOrBuildingFilter()) do
				local ename = Logic.GetEntityTypeName(Logic.GetEntityType(eID))
				if string.find(ename, "PB_") ~= nil or string.find(ename, "PU_") ~= nil then
					ChangePlayer(eID, 1)
				end
			end
			Logic.RemoveQuest(1,Sdale2Quest)
		end;
		StartBriefing(briefing);
		return true
	end
end
function TraderP8()
	local Beimjp8 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "TraderP8",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("MajorP8"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("TraderP8",id);LookAt(id,"TraderP8")
			DisableNpcMarker(GetEntityId("TraderP8"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("TraderP8",trP8,"Hereinspaziert, hereinspaziert. @cr Kunden hatten wir hier schon lange nicht mehr.", false)
			ASP("TraderP8",trP8,"Ich habe mich auf besondere Waren spezialisiert. @cr Und nun, da lange niemand mehr hier war, hat sich einiges angesammelt.", true)
			ASP("TraderP8",trP8,"Ich mache euch einen guten Preis als Neukunde. @cr Schaut jederzeit in Euer Tributmenü.", false)
			briefing.finished = function()
				TributeTrP8_1()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(Beimjp8)
end
function TributeTrP8_1()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(2100/gvDiffLVL) .." Taler für 800 Kohle und 100 Silber."
	Tr.cost = { Gold = round(2100/gvDiffLVL) }
	Tr.Callback = TributePaid_P8_1
	TrP8_1 = AddTribute(Tr)
end
function TributePaid_P8_1()
	Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, 800)
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 100)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("TraderP8",trP8,"Handelt gerne erneut mit mir. @cr Ich hoffe, es schreckt Euch nicht ab, dass ich die Preise leicht erhöhen muss.", false)
		briefing.finished = function()
		TributeTrP8_2()
	end;
	StartBriefing(briefing);
end
function TributeTrP8_2()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(3000/gvDiffLVL) .." Taler für 1400 Kohle und 100 Silber."
	Tr.cost = { Gold = round(3000/gvDiffLVL) }
	Tr.Callback = TributePaid_P8_2
	TrP8_2 = AddTribute(Tr)
end
function TributePaid_P8_2()
	Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, 1400)
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 100)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("TraderP8",trP8,"Immer wieder schön, mit Euch Geschäfte zu machen. @cr Hier sind Eure Raritäten. @cr Leider kann ich Euch nun aber keine Rabatte mehr gewähren...", false)
		briefing.finished = function()
		TributeTrP8_3()
	end;
	StartBriefing(briefing);
end
function TributeTrP8_3()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(6000/gvDiffLVL) .." Taler für 2000 Kohle und 80 Silber."
	Tr.cost = { Gold = round(6000/gvDiffLVL) }
	Tr.Callback = TributePaid_P8_3
	TrP8_3 = AddTribute(Tr)
end
function TributePaid_P8_3()
	Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, 2000)
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, 80)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("TraderP8",trP8,"Immer wieder schön, mit Euch Geschäfte zu machen. @cr Hier sind Eure Funkelsteine.", false)
		briefing.finished = function()
		TributeTrP8_3()
	end;
	StartBriefing(briefing);
end
function Gate()
	ReplaceEntity("Gate",Entities.XD_WallStraightGate)
end
function RuinQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Errichtet eine Kirche",
		text	= "Reißt die Kirchenruine ab und baut an derselben Stelle eine neue Kirche. @cr Vielleicht lässt sich die Ruine ja auch restaurieren...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	RuinQuest = quest.id
end
function Vorbereitung_3()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"church_repair","Ruine","ruin_church_rep1","ruin_church_rep2","ruin_church_rep3","ruin_church_rep4",Entities.PB_Monastery2,round(160*2/gvDiffLVL),6})
	StartSimpleJob("AbfrageKirche")
	StartSimpleJob("Errichtet")
	ChangePlayer("Ruine",2)
end
--**
function AbfrageKirche()
	idKi = SucheAufDerWelt(1,Entities.PB_Monastery2,1000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		idKi = idKi[1]
		ChangePlayer(idKi,6)
		gvKi = 1
		return true
	end
	idKi = SucheAufDerWelt(6,Entities.PB_Monastery2,1000,GetPosition("Kirche"))
	if table.getn(idKi) > 0 and Logic.IsConstructionComplete(idKi[1]) == 1 then
		idKi = idKi[1]
		gvKi = 1
		return true
	end
end
--**
function Errichtet()
	if gvKi == 1 then
		Sound.PlayGUISound(Sounds.fanfare,50)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Die Kirche ist fertig, ihr könnt nun wieder mit dem Predigen anfangen.", true)
		ASP("Priester",pri,"Wir stehen tief in Eurer Schuld, hmm wie können wir dir nur danken...", false)
		ASP("Priester",pri,"Redet bitte erneut mit Bruder Johannes, er wird bestimmt sehr erfreut über Eure Hilfe hier sein. @cr Ach ja und bestellt ihm schöne Grüße von uns allen hier.", false)
    	briefing.finished = function()
			Logic.RemoveQuest(1,RuinQuest)
			Geschenk()
			Johannes_2()
			EnableNpcMarker(GetEntityId("Johannes"))
			JohannesQuest_3()
		end;
		StartBriefing(briefing);
		return true
	end
end
function Geschenk()
	CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("Priester"),"Geschenk")
	CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("Priester"),"Geschenk2")
	Move("Geschenk", "Dario")
	Move("Geschenk2", "Dario")
end
function JohannesQuest_3()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Redet erneut mit Bruder Johannes",
		text	= "Geht zu Johannes und berichtet ihm von eurem Treffen mit den Mönchen im Kloster. @cr Bruder Johannes redet nur mit Dario.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	JohannesQuest_3 = quest.id
end

function Johannes_2()
	local BeiJoh = {
		EntityName = "Dario",
		TargetName = "Johannes",
		Distance = 300,
		Callback = function()
			LookAt("Johannes","Dario");LookAt("Dario","Johannes")
			DisableNpcMarker(GetEntityId("Johannes"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Johannes",jo,"Und, wart ihr bei meinen Brüdern und habt ihr auch ihre Aufgaben bewältigt?", false)
			ASP("Dario",dario,"So beruhigt euch doch erst einmal, Johannes.", true)
			ASP("Dario",dario,"Es geht ihnen gut, sie werden nicht mehr von Kerberos angegriffen, der Weg ist verschüttet gewesen.", false)
			ASP("Dario",dario,"Ich habe außerdem die alte Kirche wieder im neuen Glanz erstrahlen lassen, sie haben ihren Glauben wieder zurückgewonnen. @cr Besucht sie doch einmal, der Weg ist jetzt sicher.", false)
			ASP("Johannes",jo,"Danke Dario, danke. @cr Ich habe hier auch noch ein kleines Geschenk für euch parat. @cr Quasi für alles was ihr für uns getan habt. @cr Ihr habt es euch mehr als verdient.", true)
			ASP("Johannes",jo,"Nun gut ich werde mich dann jetzt mal so langsam auf den Weg machen.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,JohannesQuest_3)
				Tech()
				EnableNpcMarker(GetID("miner_p7"))
				EnableNpcMarker(GetID("farmer_p7"))
				Miner_P7()
				Farmer_P7()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiJoh)
end

function Tech()
	ResearchTechnology(Technologies.GT_PulledBarrel,1)
	ResearchTechnology(Technologies.GT_Mathematics,1)
	ResearchTechnology(Technologies.GT_Binocular,1)
	ResearchTechnology(Technologies.GT_Matchlock,1)
	ResearchTechnology(Technologies.GT_Chemistry,1)
	Move("Johannes","Priester")
end

function Miner_P7()
	local BeiMi = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "miner_p7",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("miner_p7"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("miner_p7",id);LookAt(id,"miner_p7")
			DisableNpcMarker(GetEntityId("miner_p7"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("miner_p7",mi_p7,"Guten Tag. @cr Ich hab da ein paar hilfreiche Informationen für euch.", true)
			ASP("gold_mine",mi_p7,"In den Bergen oberhalb unserer schönen Siedlung befindet sich eine ergiebige Golderzader. @cr Der Weg dorthin ist jedoch seit einem Bergrutsch verschüttet.", false)
			ASP("miner_p7",mi_p7,"Nun, vielleicht ist das auch ganz gut so. @cr Einige Dörfler konnten dort eine Räuberbande beobachten, sie sich ansonsten wohl auf unser Hab und Gut gestürzt hätte...", false)
			briefing.finished = function()
				DestroyEntity("goldmine_barrier")
				StartSimpleJob("Goldmine_Robbers_Surprise")
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMi)
end
function Goldmine_Robbers_Surprise()
	local posX, posY = Logic.GetEntityPosition(GetID("gold_mine"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2300, 1) > 0 then
		local army 		= {}
		army.player 	= 4
		army.id 		= GetFirstFreeArmySlot(4)
		army.position 	= GetPosition("spawnZ")
		army.rodeLength	= Logic.WorldGetSize()
		army.strength	= round(8-(2*gvDiffLVL))
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = WikTroopTypes[math.random(table.getn(trooptypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
		return true
	end
end
function ControlGenericArmies(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end

function Farmer_P7()
	local BeiFa = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "farmer_p7",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("farmer_p7"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("farmer_p7",id);LookAt(id,"farmer_p7")
			DisableNpcMarker(GetEntityId("farmer_p7"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("farmer_p7",fa_p7,"Felder? @cr Hier gibt es keine Felder... @cr Und dabei stand in der Stellenanzeige: @cr SAFTIGE GRÜNE WIESEN, SOWEIT DAS AUGE REICHT. KLARE UND FRISCHE BERGLUFT FÜR DAS OPTIMALE WOHLFÜHLKLIMA!", false)
			ASP("farmer_p7",fa_p7,"Und ich Dämel bin darauf reingefallen. @cr Jetzt hänge ich hier fest und bin effektiv nichts als ein stinkender Schlachter, der das unschuldige Vieh verwurstet...", false)
			ASP("farmer_p7",fa_p7,"Wenn ihr eine urbare Wiese findet, so errichtet mir bitte einen Hof und sagt mir Bescheid. @cr Dann kann ich endlich weg von hier...", false)
			briefing.finished = function()
				StartSimpleJob("MeadowFound")
				QuestFarmer()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiFa)
end
function QuestFarmer()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Eine grüne, saftige Wiese",
		text	= "Findet für den Bauern aus Fort Wulfilar eine urbare Wiese. @cr Ihr solltet mit einem Eurer Helden die Urbarkeit der Wiese prüfen. @cr Baut anschließend einen Gutshof nahe der Wiese.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	FarmerQuest = quest.id
end
function MeadowFound()
	local posX, posY = Logic.GetEntityPosition(GetID("meadow_1"))
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 1500, EntityCategories.Hero)
	if not id then
		posX, posY = Logic.GetEntityPosition(GetID("meadow_2"))
		id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 1500, EntityCategories.Hero)
	end
	if id then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das sieht doch nach einem geeigneten Feld für Bewirtschaftung für den Bauern aus Fort Wulfilar aus. @cr Wir sollten hier einen Bauernhof errichten.", false)
		briefing.finished = function()
			StartSimpleJob("FarmBuilt")
		end;
		StartBriefing(briefing)
		return true
	end
end
function FarmBuilt()
	local posX, posY = Logic.GetEntityPosition(GetID("meadow_1"))
	local num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_Farm3, posX, posY, 1700, 1)
	if num < 1 then
		posX, posY = Logic.GetEntityPosition(GetID("meadow_2"))
		num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_Farm3, posX, posY, 1700, 1)
	end
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("farmer_p7",fa_p7,"Habt Dank. @cr Ich hole gleich meine Siebensachen und verlasse dieses Kaff. @cr Hier, nehmt meine Wertsachen. Die kann ich als Bauer eh nicht mehr gebrauchen.", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, round(300*gvDiffLVL))
			Logic.AddToPlayersGlobalResource(1, ResourceType.Gold, round(6000*gvDiffLVL))
			Logic.RemoveQuest(1, FarmerQuest)
		end;
		StartBriefing(briefing)
		return true
	end
end

function Bishop()
	local BeiBi = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "Bishop",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("Bishop"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("Bishop",id);LookAt(id,"Bishop")
			DisableNpcMarker(GetEntityId("Bishop"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Bishop",bi,"Endlich frei. Ihr könnt euch gar nicht vorstellen, wie lange ich hier festgehalten wurde.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Tut mir leid, dass wir so lange gebraucht haben. @cr Wir mussten zunächst den Schlüssel finden und dieser lag gut versteckt in Kerberos Außenposten...", true)
			ASP("P3_Spawn3",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Der Außenposten war aber leider weitaus mächtiger befestigt, als wir es erhofft hatten.", false)
			ASP("Priester",bi,"Jetzt ist ja alles wieder gut. @cr Ich muss jetzt aber auch schleunigst wieder nach Hause und weitere Predigten halten.", false)
			ASP("prison",bi,"Oh da wäre noch eine Sache. @cr Einige unsere Glaubensbrüder werden dort oben im alten Gefängnisturm festgehalten. @cr Seid doch bitte so gut und befreit auch sie.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,JohannesQuest)
				BishopQuest()
				Move("Bishop","Priester")
				StartSimpleJob("MonksFreedJob")
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiBi)
end
function BishopQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Befreit die Glaubensbrüder",
		text	= "Befreit die Glaubensbrüder des Bischofs. @cr Sie werden hoch oben in den Bergen im alten Gefängnisturm festgehalten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	BishopQuest = quest.id
end
function MonksFreedJob()
	if IsDestroyed("prison") then
		local posX, posY = 75000, 31500
		for i = 1, 5 do
			CreateEntity(6,Entities.CU_BenedictineMonkIdle, {X = posX - (i*10), Y = posY - (i*10)}, "FreedMonk" .. i)
		end
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.5
		local AP, ASP = AddPages(briefing);
		ASP("FreedMonk1",bi,"Ihr habt unsere Brüder befreit. @cr Habt Dank. @cr Habt Dank.", false)
		ASP("Bishop",bi,"Möge Gott euch auf all euren Wegen begleiten. @cr Amen.", true)
		AP{
			title = bi,
			text = "Sputet euch jetzt, Kerberos ist bestimmt schon fast entkommen.",
			position = GetPosition("Pfad"),
			marker = ANIMATED_MARKER,
			dialogCamera = false,
		}

		ASP("Pfad",bi,"Über diesen Pfad gelangt ihr bald ans Nordmeer. @cr Kerberos wird bestimmt denselben Weg benutzt haben.", false)

		briefing.finished = function()
			Logic.RemoveQuest(1, BishopQuest)
			ReplaceEntity ("gate_outro", Entities.XD_WallStraightGate)
			for i = 1, 5 do
				Move("FreedMonk" .. i, "Priester")
			end
		end;
		StartBriefing(briefing);
		return true
	end
end
function Vorbereitung_4()
	StartSimpleJob("Fertig")
end

function Fertig()
	if IsDestroyed("KerberosBurg") then

		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.5
		local AP, ASP = AddPages(briefing);
		AP{
			title = ment,
			text = "Der Außenposten wurde zerstört. @cr "..
				"Hey unter diesem Turm lag ein Schlüssel für das Tor. @cr Jetzt lasst uns beeilen und den Priester befreien @cr "..
				"Die Angriffe auf Fort Wulfilar werden nun erschwachen. @cr "..
				"Sie werden schon bald wieder in Freiheit leben können.",
			position = GetPosition("Fort Wulfilar"),
			dialogCamera = false,
			action = function()
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
			end
		}
		AP{
			title = dario,
			text = "Wir sollten auch die Hauptsiedlung Kerberos vernichten. @cr Eine bessere Gelegenheit werden wir nicht bekommen.",
			position = GetPosition("P2OP"),
			dialogCamera = false,
			action = function()
			end
		}

		briefing.finished = function()
			Logic.RemoveQuest(1,BefreiungQuest )
			Tor()
			KerberosVillageDestroyQuest()
			StartSimpleJob("KerberosVillageDestroyJob")
		end;
		StartBriefing(briefing);
		return true
	end
end
function Tor()
	ReplaceEntity ("Tor", Entities.XD_WallStraightGate)
end
function KerberosVillageDestroyQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Vernichtet Kerberos Siedlung",
		text	= "Vernichtet die Hauptsiedlung Kerberos. @cr Besiegt alle seine Schergen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
	KerbQuest = quest.id
end
function KerberosVillageDestroyJob()
	if IsDestroyed("P2OP") and IsDestroyed("DCastle") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.5
		local AP, ASP = AddPages(briefing);
		AP{
			title = dario,
			text = "Kerberos Siedlung wurde vernichtet und seine Schergen zerstreut. @cr Jedoch keine Spur von Kerberos. Er konnte wohl wieder entkommen...",
			position = GetPosition("DarkCastle"),
			dialogCamera = false,
			action = function()
			end
		}
		AP{
			title = dario,
			text = "Wir werden Kerberos weiter verfolgen müssen. @cr Er war nicht mehr hier und ist wahrscheinlich zum Nordmeer geflohen.",
			position = GetPosition("Pfad"),
			dialogCamera = false,
			action = function()
			end
		}
		AP{
			title = dario,
			text = "Er wird uns nicht entkommen, früher oder später haben wir ihn und das Übel aus diesem Land endgültig beseitigt.",
			position = GetPosition("Dario"),
			dialogCamera = false,
			action = function()
			end
		}
		briefing.finished = function()
			Logic.RemoveQuest(1, KerbQuest)
		end;
		StartBriefing(briefing);
		return true
	end
end

--**
function Gewonnen()
	if IsNear("Dario","Pfad",900) then
		StartCutscene("Outro", Victory)
		return true
	end
end

function Verloren()
	if IsDead("Burg") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("posHQSP",ment,"Warum habt Ihr Eure Burg nicht beschützt?", false)
		ASP("posHQSP",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
		ASP("posHQSP",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
	if ((IsDead("Dario") or IsDead("Ari") or IsDead("Drake") or IsDead("Pilgrim")) and not Chapter1Done) then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("posHQSP",ment,"Warum habt Ihr Eure Helden nicht beschützt?", false)
		ASP("posHQSP",ment,"Jetzt sind sie gefallen und damit habt ihr das Spiel verloren.", false)
		ASP("posHQSP",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			if GDB.IsKeyValid("achievements\\losttoherodeaths") then
				local num = GDB.GetValue("achievements\\losttoherodeaths")
				GDB.SetValue("achievements\\losttoherodeaths", num + 1)
			else
				GDB.SetValue("achievements\\losttoherodeaths", 1)
			end
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
end
function Truhen()
	CreateChest(GetPosition("Leer1"),chestCallbackLeer)
	CreateChest(GetPosition("Leer2"),chestCallbackLeer)
	CreateChest(GetPosition("Leer3"),chestCallbackLeer)
	CreateChest(GetPosition("Leer4"),chestCallbackLeer)
	CreateChest(GetPosition("Leer5"),chestCallbackLeer)
	CreateChest(GetPosition("Leer6"),chestCallbackLeer)
	CreateChest(GetPosition("Leer7"),chestCallbackLeer)
	CreateRandomGoldChest(GetPosition("Gold"))
	CreateRandomGoldChest(GetPosition("Eisen1"))
	CreateRandomGoldChest(GetPosition("Eisen2"))
	CreateRandomGoldChest(GetPosition("Eisen3"))
	CreateRandomGoldChest(GetPosition("Lehm"))
	CreateRandomGoldChest(GetPosition("Stein1"))
	CreateRandomGoldChest(GetPosition("Stein2"))
	CreateRandomGoldChest(GetPosition("Stein3"))
	CreateRandomGoldChest(GetPosition("Stein4"))
	CreateRandomGoldChest(GetPosition("Holz"))
	CreateRandomGoldChest(GetPosition("Schwefel2"))
	CreateRandomGoldChest(GetPosition("VikingChest1"))
	CreateRandomGoldChest(GetPosition("VikingChest2"))
	CreateRandomGoldChest(GetPosition("VikingChest3"))
	CreateRandomGoldChest(GetPosition("chestZ"))
	CreateRandomGoldChest(GetPosition("chestX"))
  	CreateChestOpener("Dario")
  	CreateChestOpener("Drake")
  	CreateChestOpener("Ari")
	CreateChestOpener("Pilgrim")
	StartChestQuest()
end
function chestCallbackLeer()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " hat eine Schatztruhe geplündert. Leider war nichts drin...")
	AddGold(0)
end
function chestCallbackGold()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Gold.")
	AddGold(2000)
end
function chestCallbackIron1()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1200 Eisen.")
	AddIron(1200)
end
function chestCallbackIron2()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 900 Eisen.")
	AddIron(900)
end
function chestCallbackIron3()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Eisen.")
	AddIron(1000)
end
function chestCallbackClay1()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 600 Lehm.")
	AddClay(600)
end
function chestCallbackStone1()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 700 Steine.")
	AddStone(700)
end
function chestCallbackStone2()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 400 Steine.")
	AddStone(400)
end
function chestCallbackStone3()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Steine.")
	AddStone(1000)
end

function chestCallbackStone4()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 800 Steine.")
	AddStone(800)
end
function chestCallbackWood()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Holz.")
	AddWood(1000)
end
function chestCallbackSulfur()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 300 Schwefel.")
	AddSulfur(300)
end
function chestCallbackVi1()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Gold.")
	AddGold(1000)
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik1"))
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik1"))
end
function chestCallbackVi2()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Gold.")
	AddGold(2000)
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik2"))
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik2"))
end
function chestCallbackVi3()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 3000 Gold.")
	AddGold(3000)
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik3"))
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("Wik3"))
	CreateMilitaryGroup(4,Entities.CU_VeteranLieutenant,4,GetPosition("Wik4"))
end
function chestCallbackZ()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2500 Gold.")
	AddGold(1000)
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("spawnZ"))
	CreateMilitaryGroup(4,Entities.CU_Barbarian_LeaderClub2,8,GetPosition("spawnZ"))
	CreateMilitaryGroup(4,Entities.CU_VeteranLieutenant,4,GetPosition("spawnZ"))
end
function chestCallbackX()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1600 Gold.")
	AddGold(1600)
end
function InitAchievementChecks()
	StartSimpleJob("CheckForAllChestsOpened")
	StartSimpleJob("CheckForSulfurGathered")
	StartSimpleJob("CheckForSnipes")
	NumDrakeSnipes = 0
	DrakeHeadshotDamageOrig = DrakeHeadshotDamage
	function DrakeHeadshotDamage()
		local attacker = Event.GetEntityID1()
		local attype = Logic.GetEntityType(attacker)
		if attype == Entities.PU_Hero10 then
			local target = Event.GetEntityID2()
			if Logic.GetEntityType(target) == Entities.CU_PoleArmIdle then
				local task = Logic.GetCurrentTaskList(attacker)
				if task == "TL_SNIPE_SPECIAL" then
					NumDrakeSnipes = NumDrakeSnipes + 1
				end
			end
		end
		DrakeHeadshotDamageOrig()
	end
	StartSimpleJob("CheckForRocksDestroyed")
end
function CheckForAllChestsOpened()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_ChestGold) == 0 then
		Message("Ihr habt alle Schatztruhen gefunden. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\kralmountainschests", 1)
		return true
	end
end
function CheckForSulfurGathered()
	if Logic.GetPlayersGlobalResource(1, ResourceType.Sulfur) + Logic.GetPlayersGlobalResource(1, ResourceType.SulfurRaw) >= 200000 then
		Message("Ihr habt über 200.000 Schwefel angesammelt. Unglaublich. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\kralmountainssulfur", 1)
		return true
	end
end
function CheckForSnipes()
	if NumDrakeSnipes >= 3 then
		Message("Ihr habt mindestens drei Späher mit Drakes Meisterschuss erledigt. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\kralmountainssniper", 1)
		return true
	end
end
function CheckForRocksDestroyed()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_RockDestroyableMedium1) + Logic.GetNumberOfEntitiesOfType(Entities.XD_ClosedIronPit1) == 0 then
		Message("Ihr habt alle sprengbaren Felsen sowie Minen freigeräumt. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\kralmountainsrocks", 1)
		return true
	end
end

--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
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
function GetHealth( _entity )
    local entityID = GetEntityId( _entity );
    if not Tools.IsEntityAlive( entityID ) then
        return 0;
    end
    local MaxHealth = Logic.GetEntityMaxHealth( entityID );
    local Health = Logic.GetEntityHealth( entityID );
    return ( Health / MaxHealth ) * 100
end

