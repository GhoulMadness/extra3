--------------------------------------------------------------------------------
-- MapName: Die Invasion Im Norden - Epilog: Gebirge des Todes
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Epilog: Gebirge des Todes @cr "
gvMapVersion = " v1.00"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetNeutral(1,2)
	SetNeutral(1,3)
	SetNeutral(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	SetHostile(1,8)
	SetHostile(2,5)
	SetHostile(2,6)
	SetHostile(2,8)
	SetHostile(3,5)
	SetHostile(3,6)
	SetHostile(3,8)
	SetHostile(4,5)
	SetHostile(4,6)
	SetHostile(4,8)
	SetPlayerName(2,"Dreadstone")
	SetPlayerName(3,"Hronthal")
	SetPlayerName(4,"Murkal")
	SetPlayerName(5,"Banditen")
	SetPlayerName(6,"Banditen")
	SetPlayerName(7,"Landvolk")
	SetPlayerName(8,"Nebelvolk")
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
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
	ForbidTechnology(Technologies.GT_Mercenaries,1)
	ResearchTechnology(Technologies.GT_Construction,1)
	ResearchTechnology(Technologies.GT_Alloying,1)
	ResearchTechnology(Technologies.B_Blacksmith,1)
	ResearchTechnology(Technologies.UP1_Farm,1)
	ForbidTechnology(Technologies.GT_PulledBarrel,1)
	ForbidTechnology(Technologies.B_Tower,1)
	ForbidTechnology(Technologies.B_GunsmithWorkshop,1)
	ForbidTechnology(Technologies.B_PowerPlant,1)
	ForbidTechnology(Technologies.B_WeatherMachine,1)
	ForbidTechnology(Technologies.B_Foundry,1)
	ForbidTechnology(Technologies.B_MasterBuilderWorkshop,1)
	ForbidTechnology(Technologies.B_Bridge,1)
	ForbidTechnology(Technologies.UP1_Tavern,1)
	ForbidTechnology(Technologies.T_UpgradeHeavyCavalry1,1)
	ForbidTechnology(Technologies.T_Fletching,1)
	ForbidTechnology(Technologies.MU_Thief,1)
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
	Display.SetPlayerColorMapping(5,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(2,FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(6,NEPHILIM_COLOR)
	Display.SetPlayerColorMapping(4,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(3,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(7,NPC_COLOR)
	Display.SetPlayerColorMapping(8,EVIL_GOVERNOR_COLOR)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	IncludeLocals("armies")
	--
	LocalMusic.UseSet = DARKMOORMUSIC
	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, 1, 200, 2, "Player1", 2, 0)
	SetupPlayerAi( 2, {constructing = false, extracting = 0, repairing = true} )
	MapEditor_SetupAI(3, 1, 5000, 2, "Player2", 2, 0)
	SetupPlayerAi( 3, {constructing = false, extracting = 0, repairing = true} )
	MapEditor_SetupAI(4, 2, 6000, 3, "Player3", 2, 0)

    ActivateBriefingsExpansion()
    Start()
    Siedlung = 0   --wechselt von 0 bis 3, wenn Aufträge für verbündete Siedlungen erledigt werden
	gvDayCycleStartTime = Logic.GetTime()
	TagNachtZyklus(24,1,1,(0-gvDiffLVL),1)
end
function FarbigeNamen()
	orange 	= " @color:255,127,0 "
	lila 	= " @color:250,0,240 "
	weiss	= " @color:255,255,255 "

  	ment	= ""..orange.." Mentor "..lila..""
	dario	= ""..orange.." Dario "..lila..""
	drake	= ""..orange.." Drake "..lila..""
	ari		= ""..orange.." Ari "..lila..""
	pil    	= ""..orange.." Pilgrim "..lila..""
	er     	= ""..orange.." Erec "..lila..""
	ma1   	= ""..orange.." Siedler "..lila..""
	ma2   	= ""..orange.." Bürgermeister "..lila..""
	ma3    	= ""..orange.." Kommandant "..lila..""
	twa    	= ""..orange.." Torwächter "..lila..""
	sch    	= ""..orange.." Schmied "..lila..""
	ser   	= ""..orange.." Einsamer Leibeigener "..lila..""
	far   	= ""..orange.." Genervter Bauer "..lila..""
	ctr    	= ""..orange.." Söldner - Händler "..lila..""
	al     	= ""..orange.." Sonderbarer Alchemist "..lila..""
	se     	= ""..orange.." Verschollener verrückter Einsiedler "..lila..""
	WTM    	= ""..orange.." Wilder Tollwut - Mensch "..lila..""
	rei    	= ""..orange.." Kavallerist von Hronthal "..lila..""
	he     	= ""..orange.." Kauziger Einsiedler "..lila..""
end
function Start()
	CreateInitialArmies()
	--
	MakeInvulnerable("Turm1")
	MakeInvulnerable("Turm2")
	MakeInvulnerable("NebelTurm")
	MakeInvulnerable("P4Lehm")
	Jobs()
	StartCutscene("Intro", Prolog)
	BriefVorb()
end
function Jobs()
	StartSimpleJob("MaryTor")
end
function InitCaves()
	CaveData = {In = {"Hin",
			"Runter",
			"CaveNV",
			"GrottenAusgang",
			"BergAusgang",
			"Bandit3",
			"SchatzTunnel",
			"Bandit26",
			"SteinY",
			"Bandit9",
			"HighlandZugang",
			"TurmWeg",
			"NVZurueck"},
		Out = {"BurgCave",
			"CaveBack",
			"GrottenEingang",
			"BergEingang",
			"WiederDa",
			"Schatz",
			"Bandit14",
			"SteinX",
			"Bandit10",
			"LehmBack",
			"HighlandCave",
			"NVLager",
			"NVWeg"}
	}
	CavesEntered = {}
	CavesSolAmount = {}
	for i = 1, table.getn(CaveData.In) do
		CavesEntered[i] = false
		CavesSolAmount[i] = 0
	end
	RealCaveIndexes = {1, 3, 6, 8, 11, 12}
end
function Caves()
	for i = 1, table.getn(CaveData.In) do
		local posX, posY = Logic.GetEntityPosition(GetID(CaveData.In[i]))
		local data = {Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 200, 16)}
		if data[1] > 0 then
			for j = 2, data[1] + 1 do
				if Logic.IsLeader(data[j]) == 1 then
					CavesEntered[i] = true
					local newposX, newposY = Logic.GetEntityPosition(GetID(CaveData.Out[i]))
					if Logic.LeaderGetNumberOfSoldiers(data[j]) > 0 then
						local sol = {Logic.GetSoldiersAttachedToLeader(data[j])}
						TeleportSettler(data[j], newposX, newposY)
						CavesSolAmount[i] = CavesSolAmount[i] + sol[1]
						for k = 2, sol[1] + 1 do
							TeleportSettler(sol[k], newposX, newposY)
						end
					else
						TeleportSettler(data[j], newposX, newposY)
					end
				end
			end
			break
		end
	end
end

function SpezStein()
	if IsNear("Dario","SteinZ",400) then
		Message("Hmm, was ist das denn für ein komischer Stein?")
		Message("Dario entscheidet sich, den Stein mitzunehmen")
		DestroyEntity("SpeStein")
		DestroyEntity("Fackel1")
		DestroyEntity("Fackel2")
		DestroyEntity("Fackel3")
		gvMission.SteinBack = StartSimpleJob("SteinBack")
		Gate2()
		return true
	end
end

function MaryTor()
	if IsDestroyed("TorTurm") then
		Message("Nanu, das Tor hat sich geöffnet")
		ReplaceEntity ("GateMary", Entities.XD_WallStraightGate)
		return true
	end
end
function Teleport()
	SetPosition("Dario",ZurEntity("Teleport",0))
	SetPosition("Pilgrim",ZurEntity("Teleport",0))
	SetPosition("Ari",ZurEntity("Teleport",0))
	SetPosition("Erec",ZurEntity("Teleport",0))
	SetPosition("Drake",ZurEntity("Teleport",0))
    Move("Dario","Ende")
    Move("Ari","Ende")
    Move("Erec","Ende")
    Move("Pilgrim","Ende")
    Move("Drake","Ende")
end

function BriefVorb()
	EnableNpcMarker(GetEntityId("Major1"))
	EnableNpcMarker(GetEntityId("Major2"))
	EnableNpcMarker(GetEntityId("Major3"))
	EnableNpcMarker(GetEntityId("Guard"))
	EnableNpcMarker(GetEntityId("Schmied"))
	EnableNpcMarker(GetEntityId("Serf"))
	EnableNpcMarker(GetEntityId("Farmer"))
	EnableNpcMarker(GetEntityId("CampTrader"))
	EnableNpcMarker(GetEntityId("Alchemist"))
	EnableNpcMarker(GetEntityId("Settler"))
	EnableNpcMarker(GetEntityId("Hermit"))
	Hermit()
	Alchemist()
	Settler()
	Soeldner()
	Schmied()
	Serf()
	Farmer()
	Guard()
	Major1()
	Major2()
	Major3()
end
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Pilgrim",pil,"Warum hast du uns hierher geschleppt Dario?? Ich dachte die Invasion sei vorbei und es bestehe keine Gefahr mehr.", false)
	ASP("Dario",dario,"Die Leute hier wurden Ewigkeiten von den Königen unseres Reiches im Stich gelassen. Wir müssen ihnen in ihrer Not helfen.", true)
	ASP("Ari",ari,"Und wie stellen wir das an?? Ich kann mir nicht vorstellen, dass sie uns sonderlich willkommen heißen, wo wir ihnen doch sonst nie geholfen haben.", true)
	ASP("Dario",dario,"Ja, daran habe ich auch schon gedacht... Sie werden sich trotzdem bestimmt über jede Hilfe freuen, die sie bekommen können.", false)
	ASP("Drake",drake,"Im Notfall helfe ich mal ein wenig nach. Haha, ich liebe mein Gewehr.",true)
	ASP("Dario",dario,"Und dann noch was, das mir täglich neue Sorgen bereitet.",true)
	ASP("Dario",dario,"Ich verstehe immer noch nicht, was Kerberos in Nuamon vorhatte. Und ja, es war zweifellos Kerberos, alles trug seine Handschrift.",true)
	ASP("Pilgrim",pil,"Ist doch vollkommen egal, das ist alles Vergangenheit.",true)
	ASP("Dario",dario,"Dennoch, ich habe dabei immer wieder ein mulmiges Gefühl, wenn ich daran auch nur denke.",true)
	ASP("Erec",er,"Ich kann Dario nur zustimmen, mir geht es genauso, vor allem als Regent von Nuamon.",true)
	ASP("Erec",er,"Ich kann es mir schlicht nicht vorstellen - Kerberos @color:252,0,240 OHNE @color:255,255,255 fiese Hintergedanken und Intrigen?? Nein, @color:252,0,240 UNMÖGLICH.",true)
	ASP("Ari",ari,"Ich unterbreche euch nur ungern in eurem Gespräch, aber sollten wir uns nicht beeilen und die Dörfer suchen?",true)
	ASP("Dario",dario,"Du hast Recht Ari, lasst uns beeilen meine Freunde.",true)
	ASP("Drake",drake,"Wir sollten die Moor- und Sumpfgebiete meiden, dort haust bestimmt das Nebelvolk.",false)
	ASP("Drake",drake,"Und bei deren Stärke und unserer Schwäche ohne Siedlung sind wir ihnen viel zu sehr unterlegen.",true)
    briefing.finished = function()
		ChangePlayer("Beauty",7)
		Truhen()
		InitCaves()
		gvMission.Caves = StartSimpleJob("Caves")
		StartSimpleJob("Verloren")
		StartSimpleJob("Gewonnen")
		--
		InitAchievementChecks()
	end
	Quests()
	StartBriefing(briefing)
end
function Quests()
	DarioQuest()
end
function DarioQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Auf der Suche",
		text	= "Findet die Siedlungen im Gebirge. @cr Meidet die Moorregionen. @cr Achtung, nicht alle Siedlungen sind euch wohlgesonnen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarQuest = quest.id
end
function Major1()
	local BeiMa1 = {
	EntityName = "Dario",
    TargetName = "Major1",
    Distance = 300,
    Callback = function()
		LookAt("Major1","Dario");LookAt("Dario","Major1")
		DisableNpcMarker(GetEntityId("Major1"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major1",ma1,"Hmm... @cr Gäste hatten wir hier schon ewig nicht mehr.", true)
		ASP("Dario",dario,"Wir sind hier, um euch gegen die Banditen und das Nebelvolk zu unterstützen.", false)
		ASP("Major1",ma1,"WAS BILDET IHR EUCH EIN?? @cr KOMMT EINFACH SO IN DIESE SIEDLUNG, OBWOHL DAS KÖNIGREICH UNS SONST IMMER VERNACHLÄSSIGT HAT UND ERWARTET VON UNS, DAS WIR EUCH TRAUEN????", true)
		ASP("Dario",dario,"Ich weiß, die letzten Jahre waren schwer für euch, aber wir wollen euch wirklich helfen und es tut uns aufrichtig leid.", true)
		ASP("Major1",ma1,"Beweist erst einmal, das ihr uns @color:252,0,240 WIRKLICH @color:255,255,255 helfen wollt. @cr Wenn ihr wahre Absichten habt, merkt ihr schon, was ich damit meine.", true)
		ASP("Major1",ma1,"Erst dann reden wir weiter. @cr Bis dahin bleibt die Siedlung für euch verschlossen", true)
		briefing.finished = function()
			StartSimpleJob("Maj1Auftrag")
			Maj1Quest()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa1)
end
function Maj1Auftrag()
	if IsNear("Dario","Steinhaufen",100) then
		BandStoneArmy()
		Message("Wo kommen diese fiesen Banditen her?")
		StartSimpleJob("SteinBanditen")
		return true
	end
end
function SteinBanditen()
	if IsDead(SteinBanditArmy) then
		Message("Hmm, wieder so ein komischer Stein.")
		Message("Da werden sich diese Stein-Fanatiker bestimmt drüber freuen.")
		Message("Wir sollten einige dieser Steine abbauen und ihnen schicken!")
		SteinTribut()
		return true
	end
end
function SteinTribut()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 100 Spezialsteine an die Stein-Fanatiker im Nordwesten. Sie werden sich bestimmt wahnsinnig darüber freuen.";
	tribute.cost = {Stone = 100};
	tribute.Callback = AbfrageRichtigeSteine;
	AddTribute( tribute )
end
function AbfrageRichtigeSteine()
    if IsExisting("Steinhaufen") then
		Message("Wollt ihr mich verarschen? @cr "..
	        "Ich will die Spezialsteine und keine gewöhnlichen!")
		SteinTribut()
		Refresh()
        return true
    else
		Message("Woah, sehen die eigenartig aus!")
		PayedStein()
		return true
	end
end
function Refresh()
	AddStone(100)
end
function PayedStein()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Major1",maj1,"Ohh, was sind das denn für schöne Steine? @cr Bitte kommt sofort zu mir, wir müssen reden!", false)
	briefing.finished = function()
		ActivateShareExploration(1,2,true)
		SetFriendly(1,2)
	end;
	EnableNpcMarker("Major1")
	Major1Final()
	StartBriefing(briefing);
	return true
end
function Major1Final()
	local BeiMa1F = {
	EntityName = "Dario",
    TargetName = "Major1",
    Distance = 300,
    Callback = function()
		LookAt("Major1","Dario");LookAt("Dario","Major1")
		DisableNpcMarker(GetEntityId("Major1"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major1",ma1,"Hey was sind @color:252,0,240 DAS @color:255,255,255 denn für Steine, so was haben wir ja noch nie gesehen.", true)
		ASP("Dario",dario,"Ich fand es nur ein wenig komisch, das in der Nähe Blutspuren und Knochenreste zu sehen waren.", false)
		ASP("Major1",ma1,"Was sagt ihr da???? @cr Oh nein, das waren die verfluchten Steine dieser Wilden...", true)
		ASP("Major1",ma1,"Macht euch schon mal angriffsbereit.", true)
		ASP("Major1",ma1,"Zu den Schwertern meine Krieger.", true)
		briefing.finished = function()
			NVSteinArmy()
			NVAttackBriefing()
			StartSimpleJob("NVTotem")
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa1F)
end
function NVAttackBriefing()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Player1",WTM,"@color:250,0,0 Kra Tah Bagwrah Kra Lac Morthak", true)
	briefing.finished = function()
	end;
	StartBriefing(briefing);
end
function NVTotem()
	if IsDead(NVSteinArmy1) and IsDead(NVSteinArmy2) then
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Major1",maj1,"Das Nebelvolk ist besiegt. @cr Jetzt besitzen wir einen dieser mächtigen Steine. @cr Danke, ihr seid jetzt hier jederzeit willkommen.", true)
	briefing.finished = function()
		EndlichFertig()
	end;
	StartBriefing(briefing);
	return true
	end
end
function EndlichFertig()
	Message("Dreadstone wurde erfolgreich geholfen")
	Siedlung = Siedlung + 1
	Logic.RemoveQuest(1,Maj1Quest)
end
function Soeldner()
	local BeiSoe = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "CampTrader",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("CampTrader"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("CampTrader",id);LookAt(id,"CampTrader")
		DisableNpcMarker(GetEntityId("CampTrader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("CampTrader",ctr,"Guten Tag der Herr. @cr Auf der Suche nach günstigen Söldnern?", true)
		ASP("CampTrader",ctr,"Sie kämpfen ausgezeichnet. @cr Vorausgesetzt, ihr bezahlt sie gut.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich denke darüber nach.", false)
		briefing.finished = function()
			Trade()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSoe)
end
function Trade()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 3000 Taler, um eine Gruppe Söldner anzuheuern.";
	tribute.cost = {Gold = 3000};
	tribute.Callback = PayedTribute;
	AddTribute( tribute )
end
function PayedTribute()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("CampTrader",ctr,"Hehe, gute Entscheidung. Ihr werdet sie nicht bereuen! ", false)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderSword2,10,GetPosition("Soeldner"))
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderSword2,10,GetPosition("Soeldner"))
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderSword2,10,GetPosition("Soeldner"))
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderSword2,10,GetPosition("Soeldner"))
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderBow1,8,GetPosition("Soeldner"))
		CreateMilitaryGroup(1,Entities.CU_BanditLeaderBow1,8,GetPosition("Soeldner"))
	end;
    EnableNpcMarker("CampTrader")
    Soeldner()
	StartBriefing(briefing);
end
function Settler()
	local BeiSet = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "Settler",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Settler"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Settler",id);LookAt(id,"Settler")
		DisableNpcMarker(GetEntityId("Settler"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Settler",se,"Na, der Herr? @cr Auf der Suche nach arbeitswütigen Helfern??", true)
		ASP("Settler",se,"Garantiert @color:252,0,240 KEINE @color:255,255,255 Zwangsarbeiter der Banditen. Sie wurden auch überhaupt @color:252,0,240 NICHT @color:255,255,255 verschleppt hehe ?!", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das glaubt ihr doch selbst nicht, oder?.", false)
		ASP("Settler",se,"Ich sags mal so: @cr Es kommen immer Neue dazu. @cr Macht euch euer eigenes Bild dazu.", false)
		briefing.finished = function()
			SerfHandel()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSet)
end

function SerfHandel()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 1000 Taler, um ein paar Arbeiter zu ergattern.";
	tribute.cost = {Gold = 1000};
	tribute.Callback = PayedSerfTribute;
	AddTribute( tribute )
end
function PayedSerfTribute()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Settler",se,"Hier, eure Arbeiter. @cr Behandelt sie gut und kommt bald wieder für weitere tüchtige Arbeitskräfte.", false)
	briefing.finished = function()
		CreateEntity(1,Entities.PU_Serf,GetPosition("SettlerSpawn"))
		CreateEntity(1,Entities.PU_Serf,GetPosition("SettlerSpawn2"))
		CreateEntity(1,Entities.PU_Serf,GetPosition("SettlerSpawn3"))
		CreateEntity(1,Entities.PU_Serf,GetPosition("SettlerSpawn4"))
	end;
    EnableNpcMarker("Settler")
    Settler()
	StartBriefing(briefing);
end

function Alchemist()
	local BeiAlc = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Alchemist",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Alchemist"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Alchemist",id);LookAt(id,"Alchemist")
		DisableNpcMarker(GetEntityId("Alchemist"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was seid ihr denn für ein verrückter Kauz, so nahe am Nebelvolk zu leben?", true)
		ASP("Alchemist",al,"Häh, wie war nochmal die Frage?? @cr Ah ja, hier gibt es viel Schwefel, also auch viel zu experimentieren.", false)
		ASP("Alchemist",al,"Ich glaube, deshalb haben @color:252,0,240 DIE @color:255,255,255 mich auch aus ihrem Dorf verjagt...", false)
		ASP("Alchemist",al,"Wie dem auch sei, kommen wir zum Geschäftlichen, deshalb seid ihr bestimmt hier.", false)
		ASP("Alchemist",al,"Ich kann diese Wilden auch überhaupt nicht leiden. @cr Gebt mir ein wenig @color:252,0,240 SCHWEEEEEFEL @color:255,255,255 und ich überlasse euch ein paar sehr effektive Mittel gegen das Nebelvolk.", false)
		ASP("Alchemist",al,"Und beeilt euch, ich brauche ihn noch heute!!!!", false)
		briefing.finished = function()
			SchwefelHandel1()
			SchwefelHandel2()
			SchwefelHandel3()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiAlc)
end
function SchwefelHandel1()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 1000 Schwefel, um ein moderates Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = 1000};
	tribute.Callback = PayedTribute1;
	AddTribute( tribute )
end
function SchwefelHandel2()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 1500 Schwefel, um ein besseres Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = 1500};
	tribute.Callback = PayedTribute2;
	AddTribute( tribute )
end
function SchwefelHandel3()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 5000 Schwefel, um ein hochwertiges Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = 5000};
	tribute.Callback = PayedTribute3;
	AddTribute( tribute )
end

function PayedTribute1()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer kleines Mittel gegen die Wilden!", false)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle1,4,GetPosition("NVMittel"))
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle1,4,GetPosition("NVMittel"))
  	end;
  	StartBriefing(briefing);
end
function PayedTribute2()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer gutes Mittel gegen die Wilden!", false)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon3,GetPosition("NVMittel"))
  	end;
  	StartBriefing(briefing);
end
function PayedTribute3()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer hervorragendes Mittel gegen die Wilden!", false)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("NVMittel"))
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("NVMittel"))
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon3,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon3,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon3,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon5,GetPosition("NVMittel"))
		SchwefelHandel3()
  	end;
  	StartBriefing(briefing);
end
function Schmied()
	local BeiSch = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Schmied",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Schmied"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Schmied",id);LookAt(id,"Schmied")
		DisableNpcMarker(GetEntityId("Schmied"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Schmied",sch,"Ohh, ein Fremder. @cr Das ist aber selten hier in dieser Berggegend.", true)
		ASP("Steinbr",sch,"Wärt ihr so nett, und würdet für mich den Steinbruch und eine Lehmmine dort hinten bauen?.", false)
		ASP("Schmied",sch,"Ich werde mich auch erkenntlich zeigen.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich sehe, was sich tun lässt.", true)
		ASP("Schmied",sch,"Wenn ihr damit fertig seid, könnt ihr auch noch eine @color:252,0,240 GROBSCHMIEDE @color:255,255,255 für mich bauen, dann kann ich endlich wieder arbeiten.",false)
		briefing.finished = function()
			Vorbereitung()
		end;
		StartBriefing(briefing)
		SchmiedQuest()
	end}
	SetupExpedition(BeiSch)
end
function SchmiedQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Aufgaben des Schmieds",
		text	= "Baut den STEINBRUCH am Anfang des Tals. @cr Baut dazu noch eine LEHMGRUBE. @cr Baut optional noch eine GROBSCHMIEDE, der Schmied wird sich bestimmt darüber freuen. ",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SchQuest = quest.id
end
function Serf()
	local BeiSer = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Serf",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Serf"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Serf",id);LookAt(id,"Serf")
		DisableNpcMarker(GetEntityId("Serf"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Serf",ser,"Ich bin so traurig. @cr Buhuähuä. @cr Es ist so einsam und ruhig hier oben.", true)
		ASP("Serf",ser,"Ihr seht aus wie ein fachkundiger Baumeister. @cr Seid doch bitte so nett und baut eine Sägemühle für mich.", false)
		ASP("Wald",ser,"Hier müsste sie eigentlich so gut wie hinpassen. @cr Ich habe in letzter Zeit häufiger aus Langeweile den Wald abgeholzt...", false)
		ASP("Burg",ser,"Ihr bekommt als Gegenleistung auch die Burg hinter mir.", false)
		ASP("Serf",ser,"Sagt mir nur, wie ich die Sägemühle baue. Ich werde sie dann selbst bauen, dann habe ich endlich wieder mal was zu tun.", false)
		ASP("Serf",ser,"Einer meiner Kollegen hilft auch dabei.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das hört sich doch gut an, ich werde euch sofort zeigen, wie ihr sie baut.",true)
		briefing.finished = function()
			ChangePlayer("Serf",1)
			Vorbereitung2()
		end;
		StartBriefing(briefing)
		SerfQuest()
	end}
	SetupExpedition(BeiSer)
end
function SerfQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Aufgabe des einsamen Leibeigenen",
		text	= "Baut eine SÄGEMÜHLE in dem abgeholzten Bereich. ",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SerQuest = quest.id
end
function Farmer()
	local BeiFar = {
	EntityName = "Dario",
    TargetName = "Farmer",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Farmer"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Farmer",id);LookAt(id,"Farmer")
		DisableNpcMarker(GetEntityId("Farmer"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Farmer",far,"Ich bin Bauer von Beruf. @cr Aber hier gibt es nirgends eine Mühle, sondern nur diese blöde Hütte hinter mir.", true)
		ASP("Haus",far,"Baut für mich eine Mühle und ihr könnt das Haus haben.", false)
		briefing.finished = function()
			Vorbereitung3()
		end;
		StartBriefing(briefing)
		FarmerQuest()
	end}
	SetupExpedition(BeiFar)
end
function FarmerQuest()
quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Aufgabe des Bauern",
	text	= "Baut eine MÜHLE in dem passenden Bereich, um den Bauern glücklich zu machen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	FarQuest = quest.id
end

function Vorbereitung()
	StartSimpleJob("AbfrageSteinMine")
	StartSimpleJob("AbfrageLehmMine")
	StartSimpleJob("AbfrageGrobschmiede")
	--
	StartSimpleJob("MineFertig")
	StartSimpleJob("SchmiedeFertig")
	--
	AddWood(300)
	AddClay(400)
end
function Vorbereitung2()
	CreateEntity(1,Entities.PU_Serf,GetPosition("ExtraSerf"))
	--
	StartSimpleJob("AbfrageHolzwerk")
	--
	StartSimpleJob("HolzFertig")
	--
	AddStone(150)
	AddClay(200)
end
function Vorbereitung3()
	StartSimpleJob("AbfrageFarm")
	--
	StartSimpleJob("FarmFertig")
	--
	AddStone(200)
	AddClay(150)
	AddWood(350)
end
function AbfrageSteinMine()
	idSM = SucheAufDerWelt(1,Entities.PB_StoneMine1,2000,GetPosition("Steinbr"))
	if table.getn(idSM) > 0 and Logic.IsConstructionComplete(idSM[1]) == 1 then
		idSM = idSM[1]
		gvSM = 1
		return true
	end
end
function AbfrageLehmMine()
	idLM = SucheAufDerWelt(1,Entities.PB_ClayMine1,2000,GetPosition("Lehmmine"))
	if table.getn(idLM) > 0 and Logic.IsConstructionComplete(idLM[1]) == 1 then
		idLM = idLM[1]
		gvLM = 1
		return true
	end
end
function AbfrageGrobschmiede()
	idGS = SucheAufDerWelt(1,Entities.PB_Blacksmith2,2500,GetPosition("Grobschmiede"))
	if table.getn(idGS) > 0 and Logic.IsConstructionComplete(idGS[1]) == 1 then
		idGS = idGS[1]
		gvGS = 1
		return true
	end
end
function AbfrageHolzwerk()
	idHW = SucheAufDerWelt(1,Entities.PB_Sawmill1,2000,GetPosition("Wald"))
	if table.getn(idHW) > 0 and Logic.IsConstructionComplete(idHW[1]) == 1 then
		idHW = idHW[1]
		gvHW = 1
		return true
	end
end
function AbfrageFarm()
	idFa = SucheAufDerWelt(1,Entities.PB_Farm2,3300,GetPosition("Farm"))
	if table.getn(idFa) > 0 and Logic.IsConstructionComplete(idFa[1]) == 1 then
		idFa = idFa[1]
		gvFa = 1
		return true
	end
end
function FarmFertig()
	if gvFa == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Du kannst jetzt deinem Beruf als Bauer wieder nachgehen.", true)
		ASP("Farmer",far,"Ich danke euch. @cr Hier wie versprochen:", false)
		ASP("Haus",far,"Nehmt das große Wohnhaus als Zeichen meiner Wertschätzung.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,FarQuest)
			ChangePlayer("Haus",1)
		end;
		StartBriefing(briefing);
		return true
	end
end

function HolzFertig()
	if gvHW == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Die Sägemühle kann jetzt in Betrieb genommen werden.", true)
		ASP("Serf",ser,"Perfekt, jetzt habe ich endlich wieder was zu tun.", false)
		ASP("Burg",ser,"Die Burg gehört jetzt euch. @cr Kümmert euch gut darum!", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,SerQuest)
			ChangePlayer("Burg",1)
		end;
		StartBriefing(briefing);
		return true
	end
end
function MineFertig()
	if gvSM == 1 and gvLM == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Die gewünschten Gebäude wurden fertiggestellt.", true)
		ASP("Schmied",sch,"Danke, nehmt das Dorfzentrum als Zeichen meines Dankes.", false)
		ASP("Schmied",sch,"Ach ja und vergesst nicht, für mich bitte noch die Grobschmiede zu errichten.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1,SchQuest)
			ChangePlayer("Dorfz",1)
		end;
		StartBriefing(briefing);
		return true
	end
end
function SchmiedeFertig()
	if gvGS == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Die Grobschmiede steht jetzt.", true)
		ASP("Schmied",sch,"Danke, hier nehmt das hier als Belohnung.", false)
		ASP("CaveBack",sch,"Sie werden euch im Kampf nicht im Stich lassen.", false)
		briefing.finished = function()
			for i = 1, round(gvDiffLVL) do
				CreateMilitaryGroup(1,Entities.PU_LeaderSword4,12,GetPosition("CaveBack"))
			end
		end;
		StartBriefing(briefing);
		return true
	end
end
function Hermit()
	local BeiHe = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Hermit",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Hermit"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Hermit",id);LookAt(id,"Hermit")
		DisableNpcMarker(GetEntityId("Hermit"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Hermit",he,"Fremde hier oben? Habt ihr euch verlaufen?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Kann schon sein. @cr Wir sind auf der Suche nach den Siedlungen hier in der Nähe.", false)
		ASP("Hermit",he,"Hmm, da war ich auch schon lange nicht mehr. @cr Wenn es sie immer noch gibt, liegt die eine im Westen, eine im Norden und dann gibt es da noch eine Militärsiedlung im Moorgebiet.", true)
		ASP("Hermit",he,"Aber da ihr schonmal hier seid, solltet ihr die Aussicht hier genießen.", false)
		ASP("Hermit",he,"Dies hier hinter mir war früher mal ein Aussichtsposten, wurde dann jedoch von den Wilden niedergebrannt.", true)
		ASP("NVBurg",he,"Von @color:252,0,240 HIER @color:255,255,255 oben sieht man einfach alles von dem Lager des Nebelvolkes.", false)
		ASP("NV1",he,"Brr, bedrohlich wie stark deren Truppenstärke in letzter Zeit gewachsen ist.", true)
		ASP("Hermit",he,"Ich kann kaum noch ein Fuß vor dem anderen setzen, ohne tief in der Patsche zu stecken.", false)
		AP{
			title = he,
			text = "Ihr konnt auch ruhig den Tunnel hinter mir durch die Ruine benutzen. @cr Er führt euch recht weit ins Lager des Nebelvolkes herein.",
			position = GetPosition("TurmWeg"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		ASP("Hermit",he,"Aber passt auf euch auf, das Nebelvolk wird immer stärker.", false)
		ASP("Hermit",he,"In jedem Fall solltet ihr erst gehen, nachdem ihr mit den Siedlungen gesprochen habt.", true)
		briefing.finished = function()

  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiHe)
end
function Guard()
	local BeiGa = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Guard",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Guard"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Guard",id);LookAt(id,"Guard")
		DisableNpcMarker(GetEntityId("Guard"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Lasst uns durch. @cr Wir wollen mit eurem Bürgermeister reden.", true)
		ASP("Guard",twa,"Fremde kommen hier @color:252,0,240 NIE @color:255,255,255 vorbei. @cr Mit den wenigen die hier waren, haben wir nur negative Erfahrungen gemacht.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ihr könnt mir glauben, wir kommen in guten Absichten und wollen euch helfen.", true)
		ASP("Guard",twa,"Was könnt ihr schon tun? @cr Ich sehe keine Soldaten und es gibt hier keine neue Siedlung oder geeigneten Siedlungsplatz in der Nähe.", true)
		ASP("Guard",twa,"Ihr bleibt draussen!",false)
		briefing.finished = function()
			GuardQuest()
			gvMission.Steine = StartSimpleJob("Steine")
			StartSimpleJob("SpezStein")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiGa)
end
function GuardQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Das geschlossene Tor",
		text	= "Findet einen Weg in die Siedlung im Nordwesten. @cr Bringt die Wache irgendwie dazu, das Tor zu öffnen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	GuaQuest = quest.id
end
function Gate2()
	local BeiGua = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Guard",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Guard"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Guard",id);LookAt(id,"Guard")
		DisableNpcMarker(GetEntityId("Guard"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Guard",twa,"He? @cr Was habt ihr denn da für einen @color:252,0,240 FUNKELDEN @color:255,255,255 Stein bei euch?", true)
		ASP("Guard",twa,"Das scheint wohl einer dieser extrem seltenen Mondsteine zu sein.", false)
		ASP("Gate",twa,"Gebt ihn mir und ich lasse euch und eure Leute rein.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Mhmm hört sich gut an. Hier, jetzt is es eurer.", true)
		ASP("Guard",twa,"Ihr besitzt nun freien Zugang zu unserer Siedlung. Verscherzt es euch aber nicht.",false)
		briefing.finished = function()
			Logic.RemoveQuest(1,GuaQuest)
			OeffneTor()
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiGua)
end
function OeffneTor()
	ReplaceEntity ("Gate", Entities.XD_WallStraightGate)
end
function Maj1Quest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Die mysteriöse Aufgabe",
		text	= "Findet heraus, was der Bürgermeister damit meinte, ihm wahrhaft zu helfen und erledigt die Aufgabe dann.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Maj1Quest = quest.id
end
function Major2()
	local BeiMa2 = {
	EntityName = "Dario",
    TargetName = "Major2",
    Distance = 300,
    Callback = function()
		LookAt("Major2","Dario");LookAt("Dario","Major2")
		DisableNpcMarker(GetEntityId("Major2"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major2",ma2,"Guten Tag, ich bin der Bürgermeister von Hronthal. @cr Wollt ihr was bestimmtes?", true)
		ASP("Dario",dario,"Komische Frage. @cr Hmm, ja eigentlich wollten wir euch gegen die Banditen und das Nebelvolk helfen, wenn ihr schon so fragt.", false)
		ASP("Major2",ma2,"Gäste haben wir hier @color:252,0,240 SEEEEEHR @color:255,255,255 selten. @cr Daher hat jeder eine genaue Absicht, der hier herkommt.", true)
		ASP("Dario",dario,"Ich weiß, die letzten Jahre waren schwer für euch, aber jetzt sind wir ja hier und zu allem entschlossen.", true)
		ASP("Major2",ma2,"Wir haben zwar schlechte Erfahrungen mit Fremden gemacht, aber Hilfe nehmen wir immer gerne an! @cr Da sind wir nicht so abweisend wie die Leute aus Dreadstone.", true)
		ASP("Dario",dario,"Oh, das klingt aber gar nicht gut... @cr Wüsstet ihr da irgendetwas, womit wir sie davon überzeugen können, das wir ihnen aufrichtig helfen wollen?", true)
		ASP("Major2",ma2,"Mhhm, ja da war tatsächlich was. @cr Versucht es doch mal, ihnen bei irgendwas mit Steinabbauten behilflich zu sein.", true)
		ASP("Major2",ma2,"Die Dreadstoner sind leidenschaftliche Bergbauer und lieben Gesteinsarten über alles.", false)
		AP{
			title = ma2,
			text = "Fast schon verplappert. @cr Die Residenz der Banditen liegt hier. @cr Helft uns doch bitte und beendet damit dieses unnütze Scharmützel.",
			position = GetPosition("MaryBurg"),
			marker = ANIMATED_MARKER,
			dialogCamera = false,
		}
		ASP("Dario",dario,"Mary?!?!?! @cr Was macht @color:252,0,240 DIE @color:255,255,255 denn hier??.", false)
		briefing.finished = function()
			Maj2Quest()
			StartSimpleJob("BanditenBesiegt")
			EnableNpcMarker("Reiter")
			Reiter()
			ActivateShareExploration(1,3,true)
			SetFriendly(1,3)
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa2)
end
function Maj2Quest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Vernichtet das Banditenlager",
		text	= "Besiegt das Banditenlager. @cr Findet nebenbei heraus, was Mary hier zu suchen hat und was sie vorhat.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Maj2Quest = quest.id
end
function Reiter()
	local BeiRei = {
	EntityName = "Dario",
    TargetName = "Reiter",
    Distance = 300,
    Callback = function()
		LookAt("Reiter","Dario");LookAt("Dario","Reiter")
		DisableNpcMarker(GetEntityId("Reiter"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Ihr müsst der Anführer der hiesigen Kavallerie sein, oder?", true)
		ASP("Reiter",rei,"Ja, das bin ich. @cr Kann ich etwas für euch tun?", false)
		ASP("Dario",dario,"Ich habe gerade vom Bürgermeister erfahren, dass Mary de Morfichet die Anführerin der Banditen ist.", true)
		ASP("Reiter",rei,"Wenn ihr so eine Gifthexe mit extremen Temperament meint, dann ja.", true)
		ASP("Dario",dario,"Das hört sich ganz nach Mary an, ja. @cr Und da haben wir uns eben gefragt, was sie hier zu suchen hat.", true)
		ASP("Reiter",rei,"Sie kam vor einigen Tagen hierher und hat sehr schnell das Banditenlager dahinten errichtet.", true)
		ASP("Reiter",rei,"Dann kam sie mit ihrer Horde in die Siedlungen hier und verbreitete die Botschaft: ", true)
		ASP("Major2",rei,"<<Der König ist nicht weit von hier und will eure Männer und Frauen versklaven. Kommt zu uns und lasst ihn uns gemeinsam bekämpfen!>>", false)
		ASP("Reiter",rei,"Daraufhin liefen viele unserer Bauern, Arbeiter, und auch Soldaten zu Marys Banditenbagage über.", true)
		ASP("Dario",dario,"Und was ist mit Kala, der Anführerin des Nebelvolkes? @cr Wisst ihr auch etwas über sie?", false)
		ASP("Reiter",rei,"Hmm, leider nicht allzu viel. @cr Sie war das ein oder andere Mal bei Mary, wie einige unserer Spione im Banditenlager in Erfahrung bringen konnten.", false)
		ASP("Reiter",rei,"Hierher kamen sie allerdings nie. @cr Aus gutem Grund: Wir hätten sie gar nicht erst in unsere Siedlung gelassen. @cr Ich weiß nicht wie sicher die Informationen unsere Spione sind, aber sie übermittelten uns folgendes:", false)
		ASP("Reiter",rei,"Sie berichteten von einem baldig geplanten Angriff auf die Nordfeste am Nordmeer. @cr Wo auch immer das überhaupt liegt.", false)
		ASP("Reiter",rei,"Sie wollten die Soldaten dort mit einem Überraschungsangriff aus dem Rückraum vernichten. @cr Auch Kala wollte sich mit einigen ihrer Nebeltruppen anschließen.", false)
		ASP("Dario",dario,"Uhh, da haben wir aber nochmal Glück gehabt. @cr Wir kommen gerade vom Nordmeer und der besagten Stadt. @cr Es wundert mich aber immer noch wie Mary entkommen konnte.", false)
		ASP("Reiter",rei,"Das kann ich euch sogar beantworten: @cr Am Tag ihrer Ankunft haben Mary und die Banditen ein großes Fest gefeiert, unter anderem auch mit einem Kerkermeister aus Drakonien.", false)
		ASP("Dario",dario,"Diese hinterhältige Schlange, das sieht ihr ähnlich!", true)
		ASP("Dario",dario,"Jetzt weiß ich auch, was Kerberos in Nuamon vorhatte. @cr Er hat Kala irgendwie dazu gebracht, ihm im Kampf gegen uns zu beizustehen...", false)
		ASP("Erec",er,"...und die Angriffe auf Feste Nuamyr und die aufgehetzten Dörfer waren nur ein Ablenkungsmanöver...", false)
		ASP("Erec",er,"Um uns an der Nase herumzuführen und so jede Menge kostbare Zeit zu gewinnen.", false)
		ASP("Dario",dario,"Tja, aber wir waren schneller, als er erwartet hätte.", false)
		ASP("Pilgrim",pil,"Warum redet ihr soviel darüber? @cr Wir haben die Invasion doch erfolgreich abwenden können!", true)
		ASP("Dario",dario,"Ja, aber es war wirklich schon sehr viel Glück dabei. @cr Vor allem nachdem wir jetzt zumindest einen Teil des Plans des gewieften Kerberos gelüftet haben!", true)
		ASP("Erec",er,"Jetzt lasst uns die noch ausstehenden Aufgaben bewältigen. @cr Die Dörfler hier können immer noch nicht alle in Ruhe und Frieden leben!", false)
		briefing.finished = function()
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRei)
end
function Major3()
	local BeiMa3 = {
	EntityName = "Dario",
    TargetName = "Major3",
    Distance = 300,
    Callback = function()
		LookAt("Major3","Dario");LookAt("Dario","Major3")
		DisableNpcMarker(GetEntityId("Major3"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major3",ma3,"Hmmrpf, Fremde, was sucht ihr denn hier?", true)
		ASP("Dario",dario,"Wir wollten euch im Kampf gegen das Nebelvolk unterstützen.", false)
		ASP("Major3",ma3,"Was wollt @color:252,0,240 IHR @color:255,255,255 denn da schon groß ausrichten? @cr Einer mit nem riesen Plappermaul, der den Anführer spielt,", true)
		ASP("Pilgrim",ma3,"Ein halbwüchsiger Zwerg, der kaum seine Axt halten kann,", true)
		ASP("Ari",ma3,"Eine abtrünnige Banditin, die zwar gut aussieht, aber das hilft ihr hier auch nicht weiter. @cr Pass bloß auf, dass dir deine Fingernägel nicht abbrechen.", true)
		ASP("Erec",ma3,"Und dann noch dieser Schwertkrieger hier. @cr Bildet sich ein, er ist der große Kämpfer. @cr Aber alleine kann er absolut @color:252,0,240 NICHTS @color:255,255,255 anrichten.", true)
		ASP("Drake",ma3,"Und zu guter letzt dieser Verrückter, der die ganze Zeit über an seinem Gewehr rumspielt. @cr Seine Eltern haben ihn früher wohl zu häufig fallen gelassen.", true)
		ASP("Drake",drake,"Das reicht!! Wir sind nicht hergekommen, um uns beleidigen zu lassen. @cr Ihr habt uns ja nicht einmal eine Chance gegeben, unsere Stärke zu demonstrieren.", false)
		ASP("Major3",ma3,"Nun gut, ich gebe euch eine einzige Chance. @cr Aber vermasselt ihr es, verlasst diesen Ort für immer. @cr Dass euer Freund König ist, ist hier vollkommen belanglos.", true)
		AP{
			title = ma3,
			text = "Geht durch die Höhle dort hinten und besiegt das Nebelvolk darin. @cr Erst, wenn ihr es besiegt habt, könnt ihr wieder zurückkehren.",
			position = GetPosition("NVCave"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		ASP("Dario",dario,"Kommt Leute, das schaffen wir doch locker. @cr Wär doch gelacht, wenn uns so ein paar Wilde aufhalten könnten.", false)
		ASP("Drake",drake,"Das ist bestimmt eine Falle, um uns loszuwerden. @cr Bist du sicher, das wir da reingehen sollen, Dario?", false)
		ASP("Dario",dario,"Wir müssen es einfach versuchen. @cr Das ist die einzige Chance, ihnen zu zeigen, das wir ihnen helfen wollen. @cr Wir können doch nicht als Feiglinge darstehen.", false)
		briefing.finished = function()
			Maj3Quest()
			StartSimpleJob("NVJob1")
			StartSimpleJob("NVJob2")
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa3)
end
function Maj3Quest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Vernichtet das Nebelvolk in der Grotte",
		text	= "Besiegt das Nebelvolk. @cr Es ist weitaus mächtiger, als ihr denkt. @cr Findet den Weg durch die Grotte bis hin zum Nebelvolk!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Maj3Quest = quest.id
end
function NVJob1()
	if IsDead(ArmyCave1_1) and IsDead(ArmyCave1_2)
	and IsDead(ArmyCave1_3) then
		Message("Die erste Grotte ist abgesichert. Lasst uns weiterreisen!")
		return true
	end
end
function NVJob2()
	if IsDead(ArmyCave2_1) and IsDead(ArmyCave2_2)
	and IsDead(ArmyCave2_3) then
		Message("Die zweite Grotte ist auch abgesichert. Lasst uns heimkehren und Murkal von unserem Erfolg berichten!")
		EnableNpcMarker(GetEntityId("Major3"))
		Major4()
		return true
	end
end
function Major4()
	local BeiMa4 = {
	EntityName = "Dario",
    TargetName = "Major3",
    Distance = 300,
    Callback = function()
		LookAt("Major3","Dario");LookAt("Dario","Major3")
		DisableNpcMarker(GetEntityId("Major3"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major3",ma3,"Nun gut, ihr scheint die Prüfung bestanden zu haben. @cr Hätte ich nicht erwartet.", true)
		ASP("Dario",dario,"Seid ihr jetzt zufrieden und glaubt uns, dass wir euch helfen wollen?.", false)
		ASP("Major3",ma3,"Ja. @cr Das in der Höhle war mit sicherheit nicht ohne, Kompliment. @cr Wenn wir hier etwas respektieren, dann sind das große Krieger und nicht große Redner.", true)
		ASP("Major3",ma3,"Daher auch gleich schon zur Sache:", false)
		AP{
			title = ma3,
			text = "Das Hautquartier des Nebelvolkes liegt hier. @cr Vernichtet es, und es wird hier wieder ein wenig ruhiger werden.",
			position = GetPosition("NVBurg"),
			marker = ANIMATED_MARKER,
			dialogCamera = false,
		}
		ASP("Major3",ma3,"Ich finde den Krieg grade gar nicht mal schlecht, aber meine Truppen werden so langsam müde.", false)
		ASP("Major3",ma3,"Bedenkt noch folgendes: @cr Der Weg ins Lager der Wilden ist lang und schmal. @cr Ich habe aber auch mal von einem anderen Weg dorthin gehört...", false)
		ASP("Major3",ma3,"Er soll wesentlich kürzer sein und fast direkt in deren Lager führen. @cr Allerdings gilt er schon lange als unpassierbar...", false)
		ASP("Major3",ma3,"Einige paar meiner Truppen werden euch gegen das Nebelvolk zur Seite stehen. @cr Aber sie lassen sich dennoch nur von mir befehligen!", true)
		briefing.finished = function()
			Maj4Quest()
			Logic.RemoveQuest(1,Maj3Quest)
			MurkalATK()
			StartSimpleJob("NVVorposten")
			StartSimpleJob("NVFertig")
			ActivateShareExploration(1,4,true)
			SetFriendly(1,4)
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa4)
end
function Maj4Quest()
	quest	= {
		id		= GetQuestId(),
		type	= MAINQUEST_OPEN,
		title	= "Vernichtet das Lager des Nebelvolks",
		text	= "Besiegt das Nebelvolk. Es ist weitaus mächtiger, als ihr denkt. @cr Nehmt dazu entweder den langen, beschwerlichen schmalen Weg oder sucht eine Möglichkeit, den kurzen und sichereren Weg passierbar zu machen!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Maj4Quest = quest.id
end
function NVVorposten()
	if IsDestroyed("Wohn") then
		Message("Der Vorposten des Nebelvolkes ist gefallen.")
		Message("Hmm, was ist das für ein komischer Hebel?")
		Message("Dario betätigt vorsichtig den Hebel... Ein lautes Knacken aus großer Entfernung ist zu hören...")
		Message("Was das wohl zu bedeuten hat")
		DestroyEntity("Rock1")
		DestroyEntity("Rock2")
		DestroyEntity("Rock3")
		WohnReactArmy()
		return true
	end
end
function BanditenBesiegt()
	if IsDestroyed("MaryBurg") then
		Message("Das Lager der Banditen wurde vernichtet.")
		Message("Hronthal wird sicher erfreut darüber sein.")
		Message("Die letzten Banditen scharen sich um Marys Burg.")
		Message("Vernichtet sie!!")
		MaryReactArmy()

		Siedlung = Siedlung + 1
		Logic.RemoveQuest(1,Maj2Quest)
		return true
	end
end
function NVFertig()
	if IsDestroyed("NVBurg") then
		Message("Das Hauptquartier des Nebelvolks wurde zerstört.")
		Message("Murkal wird euch unglaublich dankbar sein.")
		Message("Aber was ist das? Die letzten Wilden sammeln sich und greifen erneut an!")
		Message("Vertreibt sie!")
		KalaReactArmy()

		Siedlung = Siedlung + 1
		Logic.RemoveQuest(1,Maj4Quest)
		return true
	end
end
function Truhen()
	CreateRandomGoldChest(GetPosition("Schatz1"),chestCallbackSchatz1)
	CreateRandomGoldChest(GetPosition("Schatz2"),chestCallbackSchatz2)
	CreateRandomGoldChest(GetPosition("Schatz3"),chestCallbackSchatz3)
	CreateRandomGoldChest(GetPosition("Schatz4"),chestCallbackSchatz4)
	CreateRandomGoldChest(GetPosition("Schatz5"),chestCallbackSchatz5)
	CreateRandomGoldChest(GetPosition("Schatz6"),chestCallbackSchatz6)
	CreateRandomGoldChest(GetPosition("Schatz7"),chestCallbackSchatz7)
	CreateRandomGoldChest(GetPosition("Schatz8"),chestCallbackSchatz8)
	CreateRandomGoldChest(GetPosition("Taler1"),chestCallbackTaler1)
	CreateRandomGoldChest(GetPosition("Taler2"),chestCallbackTaler2)
	CreateRandomGoldChest(GetPosition("Taler3"),chestCallbackTaler3)
	CreateRandomGoldChest(GetPosition("Taler4"),chestCallbackTaler4)
	CreateRandomGoldChest(GetPosition("Taler5"),chestCallbackTaler5)
	CreateRandomGoldChest(GetPosition("Taler6"),chestCallbackTaler6)
	CreateRandomGoldChest(GetPosition("Taler7"),chestCallbackTaler7)
	CreateRandomGoldChest(GetPosition("Taler8"),chestCallbackTaler8)
	CreateRandomGoldChest(GetPosition("Taler9"),chestCallbackTaler9)
	CreateChest(GetPosition("HighlandTruhe"),chestCallbackHigh)
	CreateChest(GetPosition("Schwefel1"),chestCallbackSulfur1)
	CreateChest(GetPosition("Schwefel2"),chestCallbackSulfur2)
	CreateChest(GetPosition("Schwefel3"),chestCallbackSulfur3)
	CreateChest(GetPosition("Schwefel4"),chestCallbackSulfur4)
	CreateChest(GetPosition("Schwefel5"),chestCallbackSulfur5)
	CreateChest(GetPosition("Leer1"),chestCallbackLeer)
	CreateChest(GetPosition("Leer2"),chestCallbackLeer)
	CreateChest(GetPosition("Leer3"),chestCallbackLeer)
	CreateChest(GetPosition("Leer4"),chestCallbackLeer)
	CreateChest(GetPosition("Leer5"),chestCallbackLeer)
	--
	CreateChestOpener("Dario")
	CreateChestOpener("Pilgrim")
	CreateChestOpener("Erec")
	CreateChestOpener("Ari")
	CreateChestOpener("Drake")
	StartChestQuest()
end
function chestCallbackSchatz1()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackSchatz2()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1500 Taler.")
	AddGold(1500)
end
function chestCallbackSchatz3()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackSchatz4()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Taler.")
	AddGold(2000)
end
function chestCallbackSchatz5()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Taler.")
	AddGold(2000)
end
function chestCallbackSchatz6()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1500 Taler.")
	AddGold(1500)
end
function chestCallbackSchatz7()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2500 Taler.")
	AddGold(2500)
end
function chestCallbackSchatz8()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTaler1()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTaler2()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Taler.")
	AddGold(2000)
end
function chestCallbackTaler3()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 3000 Taler.")
	AddGold(3000)
end
function chestCallbackTaler4()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1500 Taler.")
	AddGold(1500)
end
function chestCallbackTaler5()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1500 Taler.")
	AddGold(1500)
end
function chestCallbackTaler6()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1900 Taler.")
	AddGold(1900)
end
function chestCallbackTaler7()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 2000 Taler.")
	AddGold(2000)
end
function chestCallbackTaler8()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1700 Taler.")
	AddGold(1700)
end
function chestCallbackTaler9()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1200 Taler.")
	AddGold(1200)
end
function chestCallbackHigh()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(500*gvDiffLVL) .. " Taler.")
	AddGold(round(500*gvDiffLVL))
	DestroyEntity("Fels1")
	DestroyEntity("Fels2")
end
function chestCallbackSulfur1()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1000 Schwefel.")
	AddSulfur(1000)
end
function chestCallbackSulfur2()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1500 Schwefel.")
	AddSulfur(1500)
end
function chestCallbackSulfur3()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1800 Schwefel.")
	AddSulfur(1800)
end
function chestCallbackSulfur4()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 2000 Schwefel.")
	AddSulfur(2000)
end
function chestCallbackSulfur5()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1600 Schwefel.")
	AddSulfur(1600)
end
function chestCallbackLeer()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " hat eine Schatztruhe geplündert. Leider war nichts drin...")
	AddGold(0)
end

function Gewonnen()
	if Siedlung == 3 then
		AllConditionsMet = true
		SiegBriefing()
		return true
	end
end
function Verloren()
	if IsDead("Dario") or IsDead("Ari") or IsDead("Drake") or IsDead("Pilgrim") or IsDead("Erec") then
		NiederlageBriefing()
		return true
	end
end
function SiegBriefing()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = men,
		text = "Ihr habt erfolgreich allen drei Siedlungen geholfen. @cr "..
		       "Sie können nun wieder in Frieden und Harmonie leben. @cr "..
		       "Aber auch Dario wird ihnen in Erinnerung bleiben.",
		position = GetPosition("Major2"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
		end
		}
	AP{
		title = ment,
		text = "Sie werden von nun an Dario und seine Freunde als Helden feiern.",
		position = GetPosition("Major3"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
		end
		}
	AP{
		title = ment,
		text = "...Und Fremden zukünftig ein wenig netter gegenüber stehen.",
		position = GetPosition("Major1"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
		end
	}

	ASP("Dario",dario,"Das war ein gutes Stück Arbeit für uns, aber es hat sich gelohnt, die Dörfer können nun wieder unbeschwerter leben.", false)
	ASP("Pilgrim",pil,"Dann können wir endlich wieder nach Hause?.", true)
	ASP("Dario",dario,"Warum willst du die ganze Zeit über bereits so dringend nach Hause?", false)
	ASP("Pilgrim",pil,"Mir ist auf dem Weg hierher eingefallen, dass ich meinen ganzen Sprengstoff ungesichert zu Hause liegen gelassen haben.", false)
	ASP("Dario",dario,"Na, da wird Dovbar bestimmt regen Spaß dran haben, wenn ihm das alles direkt vor seiner Nase um die Ohren fliegt.", true)
	ASP("Ari",ari,"Muss ich euch @color:252,0,240 SCHON @color:255,255,255 wieder unterbrechen?? Wir wollten doch so langsam mal los.", true)
	ASP("Dario",dario,"Ari hat Recht, lasst uns endlich wieder nach Hause aufbrechen!", false)
    briefing.finished = function()
		Logic.RemoveQuest(1,DarQuest)
		Teleport()
		Aufbruch()
	end;
	StartBriefing(briefing);
end
function Aufbruch()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Dario",ment,"Und so reisten Dario und seine vier Freunde wieder zurück in die Heimat.", false)
	ASP("Pilgrim",ment,"Ab und zu hörten sie noch das Gemurre von Pilgrim und ständige nervige Fragereien <<Sind wir schon da?>>.", false)
	ASP("Drake",ment,"Aber das schmälerte ihre Freude kein bisschen. @cr Nur einmal musste Dario Drake davon abhalten, seine Schießübungen an Pilgrim durchzuführen.", false)
	ASP("Erec",ment,"Aber selbst die besten Freunde streiten sich nunmal ab und zu. @cr <<Ab und zu?? Was labert der für einen Schwachsinn? Drake wird gleich mal ein wenig Feuer unter seinen Füßen verspüren hehehe, dann läuft er auch gleich besser>>",false)
	ASP("Drake",drake,"<<Wie war das, du kleine stinkende Ratte? Du wirst gleich mal spüren, was es heißt, eine wahrhaftige Bleivergiftung zu verspüren!>>", false)
	ASP("Dario",dario,"Naja wie dem auch sei, die ganze Reise verlief ohne weitere Komplikationen. @cr Sie reisten bis spät in die Nacht und Ari und Dario mussten die derweil gut angetrunkenen Drake und Pilgrim zügeln.", false)
	briefing.finished = function()
		Victory()
	end
	StartBriefing(briefing);
end

function NiederlageBriefing()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("NV1",ment,"Warum habt Ihr Eure Helden nicht beschützt ?", false)
	ASP("NVSpawn",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
	ASP("BanditSpawn",ment,"Versucht es noch mal und macht es dann besser.", false)
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
end
--**
function InitAchievementChecks()
	StartSimpleJob("CheckForAllChestsOpened")
	StartSimpleJob("CheckForNoDeaths")
	StartSimpleJob("CheckForAllCavesEntered")
	StartSimpleJob("CheckForPlentyTroops")
end
function CheckForAllChestsOpened()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_ChestGold) == 0 then
		Message("Ihr habt alle Schatztruhen gefunden. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\dreadmountainschests", 1)
		return true
	end
end
function CheckForNoDeaths()
	if AllConditionsMet then
		if GetPlayerKillStatisticsProperties(1, 1) == 0 then
			Message("Ihr habt alle Aufgaben im Kralgebirge abgeschlossen, ohne einen einzigen Verlust zu erleiden. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\dreadmountainsnodeath", 1)
		end
		return true
	end
end
function CheckForAllCavesEntered()
	local done = true
	for i = 1, table.getn(CavesEntered) do
		if not CavesEntered[i] then
			done = false
			break
		end
	end
	if done then
		Message("Ihr habt alle Höhlen mindestens einmal betreten. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\dreadmountainscaves", 1)
		return true
	end
end
function CheckForPlentyTroops()
	for i = 1, table.getn(RealCaveIndexes) do
		if CavesSolAmount[RealCaveIndexes[i]] >= 50 then
			Message("Ihr habt eine Höhle mit mindestens 50 Soldaten betreten. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\dreadmountainstroops", 1)
			return true
		end
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
function ZurEntity(_entity, _range, _currPos)  -- neu geschrieben
	 --_entity  = die Entity zu deren Winkel  man sich bewegen will
	 --_currPos Die Position auf der man sich befindet
	 --_tRange= die Entfernung zur Entity (im Winkel der Entity) Weiter weg ist dann negativ
	if type (_entity) == "table" then
		Message("Keine Position sondern Entity angeben")
		return nil
	end
	if type (_entity) == "string" then
		_entity = GetEntityId(_entity);
	end
	local tPos = GetPosition(_entity)
	if _currPos == nil then
		_currPos = tPos
	elseif type (_currPos) == "string" or type (_currPos) == "number"  then
		_currPos = GetPosition(_currPos)
	end
	local nEntityAngle=Logic.GetEntityOrientation(_entity);
	local nSin=math.sin((math.rad(nEntityAngle)));
	local nCos=math.cos((math.rad(nEntityAngle)));
	local tPos = GetPosition(_entity)
	return {X = _currPos.X - nCos* _range,Y =_currPos.Y - nSin* _range}; -- RÃ¼ckgabe=neue Position
end

