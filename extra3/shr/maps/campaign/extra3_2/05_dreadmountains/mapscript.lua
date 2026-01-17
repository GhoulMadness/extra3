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
	ResearchTechnology(Technologies.UP1_Blacksmith,1)
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
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),100,640,500,30)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"), 0, 2400, 3200, 140)
	XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,600,100)
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
	MapEditor_Armies[3].offensiveArmies.strength = 10
	MapEditor_Armies[3].defensiveArmies.strength = 2
	SetupPlayerAi( 3, {constructing = false, extracting = 0, repairing = true} )
	MapEditor_SetupAI(4, 1, 6000, 3, "Player3", 2, 0)
	MapEditor_Armies[4].defensiveArmies.strength = 2

    ActivateBriefingsExpansion()
	VolcanoExplosions()
    Start()
    Siedlung = 0   --wechselt von 0 bis 3, wenn Aufträge für verbündete Siedlungen erledigt werden
	gvDayCycleStartTime = Logic.GetTime()
	TagNachtZyklus(24,1,1,(0-gvDiffLVL),1)

	EvilTempleAuraEffect = Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect, 33690, 2390)
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
	rm     	= ""..orange.." Rätselmeister Mhüs - Thikk "..lila..""
	fap2	= ""..orange.." Dreadstoner Almschäfer "..lila..""
	mip3	= ""..orange.." Hronthaler Bergmann "..lila..""
	mop3	= ""..orange.." Niedergeschlagener Mönch Hronthals "..lila..""
	sep3	= ""..orange.." Hronthaler Siedler "..lila..""
	smg 	= ""..orange.." Schmuggler "..lila..""
	gup4	= ""..orange.." Murkaler Wachposten "..lila..""
	mip4	= ""..orange.." Murkaler Bergmann "..lila..""
	mtl		= ""..orange.." Anführer der Söldnerbande "..lila..""
	mtKM	= ""..orange.." Blassbleicher Bergmann "..lila..""
	mtRH	= ""..orange.." Schräger Kauz "..lila..""
end
function Start()
	CreateInitialArmies()
	--
	MakeInvulnerable("Turm1")
	MakeInvulnerable("Turm2")
	MakeInvulnerable("NebelTurm")
	MakeInvulnerable("P4Lehm")
	MakeInvulnerable("merc_tower_leader")
	StartSimpleJob("MaryTor")
	StartCutscene("Intro", Prolog)
	BriefVorb()
end
function InitCaves()
	CaveData = {In = {
			[1] = "Hin",
			[2] = "Runter",
			[3] = "CaveNV",
			[4] = "GrottenAusgang",
			[5] = "BergAusgang",
			[6] = "Bandit3",
			[7] = "Schatz_2",
			[8] = "SchatzTunnel",
			[9] = "Bandit14_2",
			[10] = "Bandit10",
			[11] = "SteinX_2",
			[12] = "SteinY",
			[13] = "Bandit26",
			[14] = "Bandit9",
			[15] = "LehmBack_2",
			[16] = "HighlandZugang",
			[17] = "HighlandCave_2",
			[18] = "TurmWeg",
			[19] = "NVLager_2",
			[20] = "NVZurueck",
			[21] = "NVWeg_2",
			[22] = "mountTaho1",
			[23] = "mountTaho2",
			[24] = "mountTahoi1",
			[25] = "mountTahoi2",
			[26] = "mountKeto1",
			[27] = "mountKeto2",
			[28] = "mountTate1",
			[29] = "mountTate2",
			[30] = "mountRoku1",
			[31] = "mountRoku2",
			[32] = "mountKego1",
			[33] = "mountKego2"},
		Out = {
			[1] = "BurgCave",
			[2] = "CaveBack",
			[3] = "GrottenEingang",
			[4] = "BergEingang",
			[5] = "WiederDa",
			[6] = "Schatz",
			[7] = "Bandit3_2",
			[8] = "Bandit14",
			[9] = "SchatzTunnel_2",
			[10] = "SteinX",
			[11] = "Bandit10_2",
			[12] = "Bandit26_2",
			[13] = "SteinY_2",
			[14] = "LehmBack",
			[15] = "Bandit9_2",
			[16] = "HighlandCave",
			[17] = "HighlandZugang_2",
			[18] = "NVLager",
			[19] = "TurmWeg_2",
			[20] = "NVWeg",
			[21] = "NVZurueck_2",
			[22] = "mountTaho1_2",
			[23] = "mountTaho2_2",
			[24] = "mountTahoi1_2",
			[25] = "mountTahoi2_2",
			[26] = "mountKeto1_2",
			[27] = "mountKeto2_2",
			[28] = "mountTate1_2",
			[29] = "mountTate2_2",
			[30] = "mountRoku1_2",
			[31] = "mountRoku2_2",
			[32] = "mountKego1_2",
			[33] = "mountKego2_2"}
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
		local data = {Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 300, 16)}
		if data[1] > 0 then
			for j = 2, data[1] + 1 do
				if Logic.IsLeader(data[j]) == 1 and Logic.GetEntityType(data[j]) ~= Entities.PU_BattleSerf then
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
	local posX, posY = Logic.GetEntityPosition(GetID("SteinZ"))
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 400, EntityCategories.Hero)
	if id then
		Message("Hmm, was ist das denn für ein komischer Stein?")
		Message(GetNPCDefaultNameByID(id) .. " entscheidet sich, den Stein mitzunehmen")
		DestroyEntity("SpeStein")
		DestroyEntity("Fackel1")
		DestroyEntity("Fackel2")
		DestroyEntity("Fackel3")
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
	--
	EnableNpcMarker(GetID("mountRokuHermit"))
	EnableNpcMarker(GetID("mountKegoMiner"))
	MtRokuHermit()
	MtKegoMiner()
end
function Prolog()
	CustomizeBriefingParams(135, 19, 900)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = pil,
		text = "Warum hast du uns hierher geschleppt Dario?? @cr Ich dachte die Invasion sei vorbei und es bestehe keine Gefahr mehr.",
		position = GetPosition("Pilgrim"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Die Leute hier wurden Ewigkeiten von den Königen unseres Reiches im Stich gelassen. @cr Wir müssen ihnen in ihrer Not helfen.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = ari,
		text = "Und wie stellen wir das an?? @cr Ich kann mir nicht vorstellen, dass sie uns sonderlich willkommen heißen, wo wir ihnen doch sonst nie geholfen haben.",
		position = GetPosition("Ari"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(185, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Ja, daran habe ich auch schon gedacht... @cr Sie werden sich trotzdem bestimmt über jede Hilfe freuen, die sie bekommen können.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = drake,
		text = "Im Notfall helfe ich mal ein wenig nach. @cr Hahaha, ich liebe mein Gewehr.",
		position = GetPosition("Drake"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(95, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Übertreib es nicht, Drake... @cr Wir wissen alle, wohin uns das führt. @cr Zurück zum Thema: Da wäre noch etwas, das mir täglich neue Sorgen bereitet.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Ich verstehe immer noch nicht, was Kerberos in Nuamon vorhatte. @cr Und ja, es war zweifellos Kerberos, alles trug seine Handschrift.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = pil,
		text = "Ist doch vollkommen egal, das ist alles Vergangenheit. @cr Was auch immer er vorhatte, es ist ihm nicht gelungen.",
		position = GetPosition("Pilgrim"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Dennoch, ich habe dabei immer wieder ein mulmiges Gefühl, wenn ich daran auch nur denke.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = er,
		text = "Ich kann Dario nur beipflichten. @cr Mir geht es genauso. @cr Vor allem als Regent von Nuamon.",
		position = GetPosition("Erec"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(155, 19, 900)
		end
	}
	AP{
		title = er,
		text = "Ich kann es mir schlicht nicht vorstellen - Kerberos @color:252,0,240 OHNE @color:255,255,255 fiese Hintergedanken und Intrigen?? @cr Nein, @color:252,0,240 UNMÖGLICH.",
		position = GetPosition("Erec"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(155, 19, 900)
		end
	}
	AP{
		title = ari,
		text = "Ich unterbreche euch nur ungern in eurem Gespräch, aber sollten wir uns nicht beeilen und die Dörfer suchen?",
		position = GetPosition("Ari"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(185, 19, 900)
		end
	}
	AP{
		title = dario,
		text = "Du hast Recht Ari. @cr Lasst uns beeilen meine Freunde.",
		position = GetPosition("Dario"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(60, 19, 900)
		end
	}
	AP{
		title = drake,
		text = "Wir sollten die Moor- und Sumpfgebiete vorerst meiden, dort haust bestimmt das Nebelvolk.",
		position = GetPosition("Drake"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(95, 19, 900)
		end
	}
	AP{
		title = drake,
		text = "Und bei deren Stärke und unserer Schwäche ohne Siedlung sind wir ihnen viel zu sehr unterlegen.",
		position = GetPosition("Drake"),
		dialogCamera = true,
		action = function()
			CustomizeBriefingParams(95, 19, 900)
		end
	}
    briefing.finished = function()
		MakeInvulnerable(GetID("Beauty"))
		Truhen()
		InitCaves()
		gvMission.Caves = StartSimpleJob("Caves")
		StartSimpleJob("Verloren")
		StartSimpleJob("Gewonnen")
		StartSimpleJob("MercTowerLowHP")
		StartCaveJob = StartSimpleJob("HeroNearStartCave")
		--
		StartCountdown(30*60 + math.random(1, 30*60), RiddleMaster_1_Init, false)
		--
		InitAchievementChecks()
		--
		SetCameraDefaultParams()
	end
	DarioQuest()
	StartBriefing(briefing)
end

function HeroNearStartCave()
	local pos = GetPosition("start_cave")
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 300, EntityCategories.Hero)
	if id then
		CustomizeBriefingParams(95, 19, 900)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
			text = "Es ist noch ein wenig verfrüht für eine Rückreise... @cr Wir sollten zunächst den Dörfern dieser Berggegend zu Hilfe eilen...",
			position = GetPosition(id),
			dialogCamera = false,
			action = function()
				CustomizeBriefingParams(95, 19, 900)
			end
		}
		briefing.finished = function()
			TeleportSettler(id, Logic.GetEntityPosition(GetID("start_cave_2")))
			SetCameraDefaultParams()
		end;
		StartBriefing(briefing)
		return true
	end
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
function MercTowerLowHP()
	if GetHealth("merc_tower") <= 20 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("merc_tower",mtl,"Gnade Herr. @cr Wir ergeben uns! @cr So verschont doch unser Leben...", false)
		briefing.finished = function()
			ChangePlayer("merc_tower_leader", 1)
			ChangePlayer("merc_tower", 1)
			MakeVulnerable("merc_tower_leader")
			local army = ArmyTable[5][MercTowerArmyID+1]
			for i = 1, table.getn(army.IDs) do
				ChangePlayer(army.IDs[i], 1)
			end
			ResearchTechnology(Technologies.T_BarbarianCulture)
			ResearchTechnology(Technologies.T_BanditCulture)
			ResearchTechnology(Technologies.T_KnightsCulture)
			ForbidTechnology(Technologies.T_BearmanCulture)
		end;
		StartBriefing(briefing)
		return true
	end
end
function MtKegoMiner()
	local npc = "mountKegoMiner"
	local npc_title = mtKM
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"B-B-Bestien. @cr So viele von ihnen... @cr Die haben meinen Kollegen entführt. @cr Ich konnte mit Müh und Not entkommen...", true)
		ASP(npc,npc_title,"Vor kurzem sind deren Trommeln erloschen... @cr Ich fürchte das Schlimmste... @cr Bitte Herr, rettet meinen Kollegen...", true)
		briefing.finished =	function()
			StartSimpleJob("mountKegoNVDownJob")
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function mountKegoNVDownJob()
	if IsDead(MountKegoNVArmy) then
		EnableNpcMarker(GetID("mountKegoMiner"))
		MtKegoMiner2()
		return true
	end
end
function MtKegoMiner2()
	local npc = "mountKegoMiner"
	local npc_title = mtKM
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir konnten das Nebelvolk besiegen. @cr Von eurem Kollegen war jedoch keine Spur zu finden. @cr Ich fürchte, das Nebelvolk hat ihn für eines ihrer barbarischen Rituale geopfert...", true)
		ASP(npc,npc_title,"Ohje... @cr Ohweh... @cr Diese B-B-Bestien... @cr Ich hoffe, ihr habt sie dafür ordentlich leiden lassen...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir haben sie mit Waffengewalt im Kampf geschlagen. @cr Dass wir keine Gräueltat begangen haben, unterscheidet uns von ihnen. @cr Wir sind zivilisierte Menschen, keine wilden Tiere!", true)
		ASP(npc,npc_title,"Und das bei dem, was die meinem Kollegen angetan haben... @cr Die hätten einen qualvollen Tod verdient... @cr Danken möchte ich euch dennoch für eure Tat - auch wenn ich mir anderes erhofft hätte...", true)
		ASP(npc,npc_title,"Ich bin aber nur ein armer Bergmann. @cr Nehmt all die abgebaute Kohle, die ich angehortet hab. Es ist Euer.", true)
		briefing.finished =	function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, round(5000 + 1500 * gvDiffLVL))
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MtRokuHermit()
	local npc = "mountRokuHermit"
	local npc_title = mtRH
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"So hoch oben in den Bergen Besucher? @cr Nun, das ist aber eine Seltenheit...", true)
		ASP(npc,npc_title,"Ich gebe Euch eine besondere Belohnung, wenn ihr eine einfache Frage beantworten könnt...", true)
		ASP(npc,npc_title,"Einst stellte ich einem wirren, aber zweifellos genialen Alchemisten dieselbe Frage. @cr Er konnte sie nicht beantworten und so ging sein wertvollster Besitz an mich über...", true)
		ASP(npc,npc_title,"Ihr sollt ihn haben, wenn ihr cleverer seid als der Alchemist. @cr Nun, scheitert ihr jedoch, so geht auch euer wertvollster Besitz an mich über...", true)
		local choicePage = AP{
			mc = {
				title			= npc_title,
				text 			= "Nun, werdet ihr es wagen, meine Frage zu hören?",
				firstText  		= " @color:230,20,20 Natürlich. @cr Wäre doch gelacht, wenn ich die Antwort nicht kenne!",
				secondText 	 	= " @color:20,255,50 Ich bin mir nicht sicher...",
				firstSelected  	= 6,
				secondSelected 	= 9,
				position 		= GetPosition("RiddleMaster")
			},
			action = function() end
		}

		AP{title = rm, text = "Nun gut, so sei es. @cr @cr Hier ist die besagte Frage:"}
		AP{title = rm, text = "Was wird nasser, wenn es trocknet?",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function()
			end}
		AP()
		AP{title = rm, text = "Eine weise Wahl. @cr Ihr wäret bestimmt gescheitert...",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function()
			end}

		briefing.finished =	function()
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				XGUIEng.ShowWidget("ChatInput", 1)
				function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
					if string.lower(_Message) == "handtuch" or string.lower(_Message) == "badehandtuch" or string.lower(_Message) == "badetuch" then
						MtRokuHermit_RiddleSolved()
					else
						MtRokuHermit_RiddleFailed()
					end
					XGUIEng.ShowWidget("ChatInput", 0)
				end
    		else
			end
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MtRokuHermit_RiddleSolved()
	local npc = "mountRokuHermit"
	local npc_title = mtRH
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npc_title,"Hervorragend! @cr Ihr habt die korrekte Antwort genannt.", true)
	ASP(npc,npc_title,"Nun, nehmt dies. @cr Dieser Versager von Alchemist hat es hier mit tränenbedecktem Gesicht zurücklassen müssen. @cr Danach ward er ein anderer Mensch...", true)
	briefing.finished =	function()
		CreateEntity(1, Entities.PV_Cannon6, GetPosition("mountRokuHermit"))
	end
	StartBriefing(briefing)
end
function MtRokuHermit_RiddleFailed()
	local npc = "mountRokuHermit"
	local npc_title = mtRH
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npc_title,"Ihr habt versagt! @cr Nun nehme ich Euren wertvollsten Besitz. @cr Nun, was ist es? @cr Kameradschaft? Loyalität? Reichtum? Familie?", true)
	ASP(npc,npc_title,"Ihr seht nach einem sehr gierigen Versager aus. @cr Ich nehme Euch all Euren weltlichen Besitz!", true)
	briefing.finished =	function()
		Logic.SubFromPlayersGlobalResource(1, ResourceType.Knowledge, Logic.GetPlayersGlobalResource(1, ResourceType.Knowledge))
		Logic.SubFromPlayersGlobalResource(1, ResourceType.Silver, Logic.GetPlayersGlobalResource(1, ResourceType.Silver))
		Logic.SubFromPlayersGlobalResource(1, ResourceType.SilverRaw, Logic.GetPlayersGlobalResource(1, ResourceType.SilverRaw))
		AddGold(-GetGold(1))
		AddWood(-GetWood(1))
		AddStone(-GetStone(1))
		AddSulfur(-GetSulfur(1))
		AddIron(-GetIron(1))
		AddClay(-GetClay(1))
	end
	StartBriefing(briefing)
end
RiddleMaster_1_Positions = {
	{X = 10000, Y = 32400},
	{X =  5800, Y = 34700},
	{X =  4600, Y = 21800},
	{X =  8100, Y = 41000},
	{X =  8300, Y = 56400},
	{X = 20900, Y = 51700},
	{X = 10600, Y = 61400},
	{X = 20900, Y = 65800},
	{X = 21100, Y = 55200},
	{X = 26300, Y = 44500},
	{X = 31400, Y = 62200},
	{X = 50100, Y = 73600},
	{X = 48000, Y = 66900},
	{X = 48900, Y = 56000},
	{X = 38300, Y = 53000},
	{X = 41700, Y = 43300},
	{X = 57700, Y = 52500},
	{X = 65800, Y = 49500},
	{X = 63000, Y = 34100},
	{X = 23400, Y = 14300},
	{X = 17700, Y = 24200},
	{X = 15000, Y = 59200},
	{X = 32800, Y = 62800},
	{X = 39000, Y = 66800},
	{X = 41000, Y = 68600},
	{X = 30100, Y = 25000},
	{X = 22700, Y = 36000},
	{X = 45400, Y = 63100}
}
function RiddleMaster_1_Init()
	math.randomseed(XGUIEng.GetSystemTime())
	RiddleMaster_CurrPos = RiddleMaster_1_Positions[math.random(1, table.getn(RiddleMaster_1_Positions))]
	removetablekeyvalue(RiddleMaster_1_Positions, RiddleMaster_CurrPos)
	local id = Logic.CreateEntity(Entities.CU_Hermit, RiddleMaster_CurrPos.X, RiddleMaster_CurrPos.Y, 0, 7)
	Logic.SetEntityName(id, "RiddleMaster")
	EnableNpcMarker(id)
	RiddleMaster_1_Brief()
end
function RiddleMaster_1_Brief()
	local BeiRM1 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "RiddleMaster",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("RiddleMaster",id);LookAt(id,"RiddleMaster")
		DisableNpcMarker(GetEntityId("RiddleMaster"))
		local briefing = {}
		local AP = function( _page ) table.insert( briefing, _page ) return _page end
		local choicePage = AP{
			mc = {
				title			= rm,
				text 			= "Oh ein Herausforderer. @cr Nun, denkt ihr, ihr seid meinen Prüfungen gewachsen?",
				firstText  		= " @color:230,0,0 Na klar, gar kein Problem",
				secondText 	 	= " @color:20,255,50 Ich bin mir nicht sicher...",
				firstSelected  	= 2,
				secondSelected 	= 5,
				position 		= GetPosition("RiddleMaster")
			},
			action = function() BRIEFING_ZOOMANGLE = 38 BRIEFING_ZOOMDISTANCE = 4500 end
		}


		AP{title = rm, text = "Nun gut, so sei es. @cr @cr Hier ist Eure erste Aufgabe:"}
		AP{title = rm, text = "Ersuchet in der Höh meinen Schatten, @cr seltsame Dinge gehen vonstatten. @cr Doch nie am selben Ort, @cr eilt Euch, hört auf mein Wort! @cr Den fünfe mich deucht, nun bin ich hinfort.",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}
		AP()
		AP{title = rm, text = "Eine weise Wahl. @cr Nur Wenige konnten bisher meine Prüfungen bestehen. @cr Etliche habe ich in den Wahnsinn getrieben, hehe.",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}

		briefing.finished =	function()
			Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
			DestroyEntity(GetID("RiddleMaster"))
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				RiddleMaster_Riddle1_FoundCount = 0
				RiddleMaster_1_Start()
    		else
				StartCountdown(10*60 + math.random(1, 10*60), RiddleMaster_1_Init, false)
			end
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRM1)
end
function RiddleMaster_1_Start()
	local pos = RiddleMaster_1_Positions[math.random(1, table.getn(RiddleMaster_1_Positions))]
	while (pos.X == RiddleMaster_CurrPos.X and pos.Y == RiddleMaster_CurrPos.Y) do
		pos = RiddleMaster_1_Positions[math.random(1, table.getn(RiddleMaster_1_Positions))]
	end
	removetablekeyvalue(RiddleMaster_1_Positions, pos)
	RiddleMaster_CurrPos = pos
	local id = Logic.CreateEntity(Entities.CU_Hermit_Shadow, pos.X, pos.Y, 0, 1)
	Logic.SetEntityName(id, "RiddleMaster")
	RiddleMaster_1_Found()
	RiddleMaster_1_CD = StartCountdown((7+gvDiffLVL)*60, RiddleMaster_1_Failed, true)
end
function RiddleMaster_1_Failed()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("RiddleMaster",rm,"Ihr seid kläglich gescheitert. @cr Genau so, wie ich es erwartet hatte... @cr Geht mir aus den Augen, ihr seid meiner nicht würdig!", false)
	briefing.finished = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
		DestroyEntity(GetID("RiddleMaster"))
	end;
	StartBriefing(briefing)
end
function RiddleMaster_1_Found()
	local BeiRM1_n = {
	Heroes = true,
    TargetName = "RiddleMaster",
    Distance = 300,
    Callback = function()
		StopCountdown(RiddleMaster_1_CD)
		RiddleMaster_Riddle1_FoundCount = RiddleMaster_Riddle1_FoundCount + 1
		if RiddleMaster_Riddle1_FoundCount < 5 then
			local posX, posY = RiddleMaster_CurrPos.X, RiddleMaster_CurrPos.Y
			Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
			DestroyEntity(GetID("RiddleMaster"))
			Message("Und weg ist er wieder... @cr Also auf ein Neues...")
			--
			StartCountdown(30 + math.random(30), RiddleMaster_1_Start, false)
		else
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("RiddleMaster",rm,"Ohh, ihr konntet die erste meiner Prüfungen tatsächlich bestehen. @cr Damit hätte ich nicht gerechnet... @cr Nun, ich habe natürlich noch weitere Prüfungen, die es zu bestehen gilt...", false)
			briefing.finished = function()
				RiddleMaster_1_Solved()
				Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
				DestroyEntity(GetID("RiddleMaster"))
			end;
			StartBriefing(briefing)
		end
	end}
	SetupExpedition(BeiRM1_n)
end
function RiddleMaster_1_Solved()
	StartCountdown(30 + math.random(30), RiddleMaster_2_Init, false)
end
function RiddleMaster_2_Init()
	math.randomseed(XGUIEng.GetSystemTime())
	local id = Logic.CreateEntity(Entities.CU_Hermit, 57000, 14500, 0, 7)
	Logic.SetEntityName(id, "RiddleMaster")
	EnableNpcMarker(id)
	RiddleMaster_2_Brief()
end
function RiddleMaster_2_Brief()
	local BeiRM2 = {
	Heroes = true,
    TargetName = "RiddleMaster",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("RiddleMaster",id);LookAt(id,"RiddleMaster")
		DisableNpcMarker(GetEntityId("RiddleMaster"))
		local briefing = {}
		local AP = function( _page ) table.insert( briefing, _page ) return _page end
		local choicePage = AP{
			mc = {
				title			= rm,
				text 			= "Oh da seid ihr ja wieder. @cr Nun, seid ihr bereit für die nächste Prüfung?",
				firstText  		= " @color:230,0,0 Na klar, leg los.",
				secondText 	 	= " @color:20,255,50 Ich komme lieber später wieder...",
				firstSelected  	= 2,
				secondSelected 	= 7,
				position 		= GetPosition("RiddleMaster")
			},
			action = function() BRIEFING_ZOOMANGLE = 38 BRIEFING_ZOOMDISTANCE = 4500 end
		}


		AP{title = rm, text = "Nun gut, so sei es. @cr @cr Hier ist Eure nächste Prüfung:"}
		AP{title = rm, text = "In der Morgensonne, so hell und klar, @cr zog Jäger Heinrich los, das ist doch wahr. @cr Fünf Kilometer südlich, mit festem Schritt, @cr fünf nach Osten, dann nach Norden – und schon ist er fit.", position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}
		AP{title = rm, text = "Er wandert allein, kein Ort, an dem er verweilt, @cr doch der Weg führt zurück, die Route beeilt. @cr Daheim angekommen, oh welch wundersamer Spaß, @cr sieht er einen Bären – ganz stattlich und blass.", position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}
		AP{title = rm, text = "Welche Farbe hat der Bär?"}
		AP()
		AP{title = rm, text = "Eine weise Wahl. @cr Kaum jemand konnte bisher zweie meiner Prüfungen bestehen. @cr Etliche habe ich in den Wahnsinn getrieben, hehe.",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}

		briefing.finished =	function()
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				RiddleMaster_2_Start()
    		else
				Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
				DestroyEntity(GetID("RiddleMaster"))
				StartCountdown(10*60 + math.random(1, 10*60), RiddleMaster_2_Init, false)
			end
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRM2)
end
function RiddleMaster_2_Start()
	RiddleMaster_2_Fail_CD = StartCountdown(30 * gvDiffLVL, RiddleMaster_2_Failed_Brief, true)
	XGUIEng.ShowWidget("ChatInput", 1)
	function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
		StopCountdown(RiddleMaster_2_Fail_CD)
		if _Message == "weiss" or _Message == "weiß" then
			--success
			RiddleMaster_2_Solved()
		else
			RiddleMaster_2_Failed_Brief()
		end
		XGUIEng.ShowWidget("ChatInput", 0)
	end
end
function RiddleMaster_2_Failed_Brief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("RiddleMaster",rm,"Ihr seid kläglich gescheitert. @cr Genau so, wie ich es erwartet hatte... @cr Geht mir aus den Augen, ihr seid meiner nicht würdig!", false)
	briefing.finished = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
		DestroyEntity(GetID("RiddleMaster"))
	end;
	StartBriefing(briefing)
end
function RiddleMaster_2_Solved()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("RiddleMaster",rm,"Ohh, ihr konntet eine weitere meiner Prüfungen tatsächlich bestehen. @cr Damit hätte ich nicht gerechnet... @cr Nun, dann möchte ich mal nicht so sein, und Euch auf Euren Wegen unterstützen.", false)
	ASP("Outpost_Ruin",rm,"Hier, nehmt diese baufällige Ruine in Euren Besitz. @cr Vielleicht hilft sie Euch ja auf Euren Wegen. @cr Ihr solltet jedoch zunächst ungebetene Gäste hinauskomplementieren...", false)
	ASP("RiddleMaster",rm,"Ach und ersucht mich erneut für ein weiteres Rätsel. @cr Wo? Nun, dies ist natürlich ebenfalls ein Rätsel:", true)
	ASP("RiddleMaster",rm,"In einem Tal, vom Nebel umhüllt, @cr wo Blumenwiesen blüh'n, so lieblich und wild. @cr Ein Wasserfall plätschert, sein Gesang so klar, @cr abgeschieden, fern der Welt, ganz wunderbar.", true)
	briefing.finished = function()
		RiddleMaster_1_Solved()
		Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
		DestroyEntity(GetID("RiddleMaster"))
		--
		StartCountdown(60, NVOutpostActions, false)
		StartCountdown(30 + math.random(30), RiddleMaster_3_Init, false)
	end;
	StartBriefing(briefing)
end
function RiddleMaster_3_Init()
	-- Rasenhöhe zu Beginn, Graskonsum/Tag, Gewicht 1cm3 Gras, Wachstum Gras/Woche in cm Frühjahr, Sommer, Herbst, Startdatum, Leinenlänge
	local constellations = {
		{"35cm", "2kg", "3mg", "1.5cm", "1cm", "0.5cm", "01.04.2020", "7.30m"}
	}
	-- teleport riddleMaster to valley and start another riddle
	-- Ein Schaf grast auf einer Weide und ist an einer Leine an einem Pflock gebunden.
	-- Es wurde erst kürzlich dort angebunden, der Rasen steht mit 35cm recht hoch.
	-- Das Schaf verspeist 2kg Gras pro Tag. 1cm3 Gras wiegt 3mg.
	-- Im Frühling wächst das Gras um 1.5cm pro Woche nach, im Sommer um 1cm, im Herbst um 0.5cm und im Winter gar nicht.
	-- Das Schaf befindet sich seit dem 01.04.2020 auf der Weide.
	-- Wann ist die gesamte Weide abgegrast, wenn die Leine 7.30m lang ist?
	-- riddle 3 will port the riddleMaster to bottom "cave valley"; reward? anything nice; silvermine?
	math.randomseed(XGUIEng.GetSystemTime())
	local constellation = constellations[math.random(1, table.getn(constellations))]
	local positions = {{X = 2000, Y = 14000}, {X = 10500, Y = 7300}, {X = 16000, Y = 2400}}
	local pos = positions[math.random(1, table.getn(positions))]
	local id = Logic.CreateEntity(Entities.CU_Hermit, pos.X, pos.Y, 0, 7)
	Logic.SetEntityName(id, "RiddleMaster")
	EnableNpcMarker(id)
	RiddleMaster_3_Brief(constellation)
end
function GetCylinderVolume(_r, _h)
	return math.pi() * _r^2 * _h
end
function GetWeight(_volume, _rho)
	return _volume * _rho
end
function GetInitialGrassWeight(_r, _h, _rho)
	return GetWeight(GetCylinderVolume(_r, _h), _rho)
end
function RiddleMaster_3_Brief(_data)
	local BeiRM3 = {
	Heroes = true,
    TargetName = "RiddleMaster",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("RiddleMaster",id);LookAt(id,"RiddleMaster")
		DisableNpcMarker(GetEntityId("RiddleMaster"))
		local briefing = {}
		local AP = function( _page ) table.insert( briefing, _page ) return _page end
		local choicePage = AP{
			mc = {
				title			= rm,
				text 			= "Oh da seid ihr ja wieder. @cr Nun, seid ihr bereit für die letzte Prüfung?",
				firstText  		= " @color:230,0,0 Die werd ich auch noch schaffen!",
				secondText 	 	= " @color:20,255,50 Schon wieder? @cr Noch bin ich nicht bereit...",
				firstSelected  	= 2,
				secondSelected 	= 7,
				position 		= GetPosition("RiddleMaster")
			},
			action = function() BRIEFING_ZOOMANGLE = 38 BRIEFING_ZOOMDISTANCE = 4500 end
		}


		AP{title = rm, text = "Nun gut, so sei es. @cr @cr Hier ist die letzte Prüfung, die ich dieses mal für Euch habe. @cr Doch Achtung, dieses mal wird es nicht so leicht..."}
		AP{title = rm, text = "Ein Schaf grast auf einer Weide und ist an einer Leine an einem Pflock gebunden. @cr Es wurde erst kürzlich dort angebunden, der Rasen steht mit " .. _data[1] .. " recht hoch. @cr Das Schaf verspeist " .. _data[2] .. " Gras pro Tag. 1cm3 Gras wiegt " .. _data[3] .. ".", position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}
		AP{title = rm, text = "Im Frühling wächst das Gras um " .. _data[4] .. " pro Woche nach, im Sommer um " .. _data[5] .. ", im Herbst um " .. _data[6] .. " und im Winter gar nicht.", position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}
		AP{title = rm, text = "Das Schaf befindet sich seit dem " .. _data[7] .. " auf der Weide. @cr Wann ist die gesamte Weide abgegrast, wenn die Leine " .. _data[8] .. " lang ist?"}
		AP()
		AP{title = rm, text = "Eine weise Wahl. @cr Niemand konnte bisher diese finale Prüfung bestehen. @cr Unzählige arme Seelen habe ich in den Wahnsinn getrieben!",
			position = {X = posX, Y = posY}, dialogCamera = false, action = function() Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY) end}

		briefing.finished =	function()
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				RiddleMaster_3_Start(id)
				local quest	= {
					id		= GetQuestId(),
					type	= SUBQUEST_OPEN,
					title	= "Das letzte Rätsel des Rätselmeisters",
					text	= "Ein Schaf grast auf einer Weide und ist an einer Leine an einem Pflock gebunden. @cr Es wurde erst kürzlich dort angebunden, der Rasen steht mit " .. _data[1] .. " recht hoch. @cr Das Schaf verspeist " .. _data[2] .. " Gras pro Tag. 1cm3 Gras wiegt " .. _data[3] .. "." ..
							" @cr Im Frühling wächst das Gras um " .. _data[4] .. " pro Woche nach, im Sommer um " .. _data[5] .. ", im Herbst um " .. _data[6] .. " und im Winter gar nicht." ..
							" @cr Das Schaf befindet sich seit dem " .. _data[7] .. " auf der Weide. @cr Wann ist die gesamte Weide abgegrast, wenn die Leine " .. _data[8] .. " lang ist?"
				}
				Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
				RM3Quest = quest.id
    		else
				Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
				DestroyEntity(GetID("RiddleMaster"))
				StartCountdown(10*60 + math.random(1, 10*60), RiddleMaster_3_Init, false)
			end
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRM3)
end
function RiddleMaster_3_Start(_id)
	Logic.SetEntitySelectableFlag(_id, 0)
	RiddleMaster_3_Fail_CD = StartCountdown(500 + (100 * gvDiffLVL), RiddleMaster_3_Failed_Brief, true)
	XGUIEng.ShowWidget("ChatInput", 1)
	function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
		StopCountdown(RiddleMaster_3_Fail_CD)
		if string.lower(_Message) == "20. märz 2021"
		or string.lower(_Message) == "20.märz 2021"
		or string.lower(_Message) == "20.märz2021"
		or string.lower(_Message) == "20. märz 21"
		or string.lower(_Message) == "20.03.2021"
		or string.lower(_Message) == "20.3.2021"
		or string.lower(_Message) == "20 03 2021"
		or string.lower(_Message) == "20 3 2021"
		or string.lower(_Message) == "20.03.21"
		or string.lower(_Message) == "20.3.21" then
			--success
			RiddleMaster_3_Solved(_id)
		else
			RiddleMaster_3_Failed_Brief()
		end
		XGUIEng.ShowWidget("ChatInput", 0)
	end
end
function RiddleMaster_3_Failed_Brief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("RiddleMaster",rm,"Wie zu erwarten war, seid ihr gescheitert. @cr Nun ich habe nichts anderes von Euch erwartet... @cr Geht mir aus den Augen, ihr seid meiner nicht würdig!", false)
	briefing.finished = function()
		local posX, posY = Logic.GetEntityPosition(GetID("RiddleMaster"))
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
		DestroyEntity(GetID("RiddleMaster"))
	end;
	StartBriefing(briefing)
end
function RiddleMaster_3_Solved(_id)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("RiddleMaster",rm,"Ihr seid cleverer, als ihr ausseht. @cr Damit hätte ich nicht gerechnet...", false)
	ASP("RiddleMaster",rm,"Ich weiß nicht, ob ihr es wusstet, aber dieses Rätsel hatte leider einen wahren und tragischen Kern als Hintergrund...", true)
	ASP("RiddleMaster",rm,"Das Schaf hatte 89 Tage nach Wintereinbruch nichts mehr zu fressen und ist so auf tragische Weise verstorben. @cr Hätte das Gras einen Tag länger ausgereicht, wäre der Frühling eingetreten und der Rasen wieder gewachsen. @cr Wahrlich tragisch...", true)
	ASP("RiddleMaster",rm,"Nun, ihr fragt Euch sicherlich, wie ich all diese Rätsel konstruiert habe... @cr Nun, ich habe da so meine *räusper* Methoden...", true)
	ASP("RiddleMaster",rm,"Hier, nehmt doch auch einmal einen kräftigen Zug aus meiner speziell konstruierten Pfeife...", true)
	ASP(_id,ment,"Und so nahm " .. GetNPCDefaultNameByID(_id) .. " einen kräftigen Zug aus der Pfeife des Rätselmeisters... @cr Auf einmal wurde ihm ganz schwummrig zumute...", true)
	ASP(_id,ment,"Bis er schließlich in sich zusammensackte. @cr Er hörte dumpfe Stimmen im Hintergrund, und dann ... @cr ... @cr nur noch schwarz...", true)
	briefing.finished = function()
		NightmareHeroID = _id
		Logic.RemoveQuest(1, RM3Quest)
		InTranceSequence = true
		local posX, posY = Logic.GetEntityPosition(_id)
		Logic.CreateEffect(GGL_Effects.FXHero14_Poison, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, posX, posY)
		SetHealth(_id, 0)
		StartSimpleHiResJob("DarkenScene")
		Game.GUIActivate(0)
		Display.SetRenderDecalsSelections(0)
		Logic.AddWeatherElement(1, 99, 0, 1, 2, 5)
	end;
	StartBriefing(briefing)
end
function DarkenScene()
	local gfx = GetCurrentWeatherGfxSet()
	if gfx == 1 then
		darkenDiff = (darkenDiff or 0) + 5
		Display.GfxSetSetLightParams(1,  0.0, 1.0, 40, -15, -50,  120-darkenDiff/2,130-darkenDiff/2,110-darkenDiff/2,  205-darkenDiff,204-darkenDiff,180-darkenDiff)
		Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152-darkenDiff,172-darkenDiff,182-darkenDiff, 5000-(darkenDiff*10),32000-(darkenDiff*70))
		if darkenDiff > 250 then
			-- give some loading screen
			Game.GUIActivate(1)
			Display.SetRenderParticles(0)
			XGUIEng.ShowWidget("LoadScreen1", 1)
			--
			GUI.SetControlledPlayer(7)
			Logic.ActivateUpdateOfExplorationForAllPlayers()
			Trigger.DisableTrigger(MapEditor_Armies[4].RebuildTriggerID)
			BackupData = {}
			--xmin = 46400; xmax = 58400; ymin = 24400; ymax = 34400
			for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(52400, 29400, 7810)) do
				local player = Logic.EntityGetPlayer(eID)
				local eType = Logic.GetEntityType(eID)
				local pos = GetPosition(eID)
				local name = Logic.GetEntityName(eID)
				local rot = Logic.GetEntityOrientation(eID)
				if Logic.IsSettler(eID) == 1 then
					-- player 1 settler? Teleport to base
					if player == 1 then
						local posX, posY = Logic.GetEntityPosition(GetID("Ende"))
						TeleportSettler(eID, posX, posY)
						Logic.GroupStand(eID)
					else
						-- only npcs, no need to back up troops
						if name ~= nil then
							table.insert(BackupData, {eType = eType, pos = pos, name = name, player = player, rot = rot})
						end
						DestroyEntity(eID)
					end
				else
					-- buildings, doodads, animals, ...
					table.insert(BackupData, {eType = eType, pos = pos, name = name, player = player, rot = rot})
					DestroyEntity(eID)
				end
			end
			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(7)) do
				local eType = Logic.GetEntityType(eID)
				local pos = GetPosition(eID)
				local name = Logic.GetEntityName(eID)
				local rot = Logic.GetEntityOrientation(eID)
				table.insert(BackupData, {eType = eType, pos = pos, name = name, player = 7, rot = rot})
				DestroyEntity(eID)
			end
			blockingPaths = {
				{X = 40300, Y = 32200, rot = 270},
				{X = 41300, Y = 23100, rot = 270},
				{X = 43400, Y = 17400, rot = 330},
				{X = 56700, Y = 13600, rot = 0},
				{X = 65300, Y = 26400, rot = 335},
				{X = 55500, Y = 42300, rot = 0},
				{X = 49900, Y = 41100, rot = 45}
			}
			for i = 1, table.getn(blockingPaths) do
				local id = Logic.CreateEntity(Entities.XD_SnowBarrier1, blockingPaths[i].X, blockingPaths[i].Y, blockingPaths[i].rot, 0)
				Logic.SetEntityName(id, "invasion_blocking_" .. i)
			end
			local id = Logic.CreateEntity(Entities.XD_ScriptEntity, 60000, 18000, 0, 7)
			Logic.SetEntityName(id, "start_pos_p7")
			--
			Script.Load(Folders.Map .. "nvinvasion.lua")
			SetHostile(7, 4)
			SetNeutral(7, 8)
			SetNeutral(1, 8)
			Display.SetPlayerColorMapping(7, 9)
			-- army creator stuff
			IncludeGlobals("Tools\\ArmyCreator")
			ArmyCreator.BasePoints = 150
			ArmyCreator.PlayerPoints = 150 * gvDiffLVL
			TimeLimit = (8 + 5 * gvDiffLVL) * 60

			StartCountdown(3,ShowArmyCreatorGUI,false)
			StartCountdown(6,InitDefGroups,false)

			function ArmyCreator.OnSetupFinished()

				HideArmyCreatorGUI()
				XGUIEng.DisableButton("TopDiplomacyMenuTextButton", 1)

				StartSimpleJob("LostEverything")
				StartSimpleJob("KilledEverything")

				StartSimpleJob("AreaCheck1")
				StartSimpleJob("AreaCheck2")

				StartCountdown(5*60*gvDiffLVL,UpgradeKIa,false)
				RevertToMainStoryCountdown = StartCountdown(TimeLimit,RevertToMainStory,true)

				Siege.DefenderIDs = {4}
				Siege.AttackerIDs = {7}
				Siege.Init()
				--
				SetNeutral(7, 8)
				StartSimpleHiResJob("AnfangsBriefingInitialize")
			end
			--
			XGUIEng.ShowWidget("LoadScreen1", 0)
			Display.SetRenderParticles(1)
			Display.SetRenderDecalsSelections(1)
			Logic.AddWeatherElement(1, (8 + 5 * gvDiffLVL) * 60, 0, 9, 0, 0)
			Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152,172,182, 5000,32000)
			Display.GfxSetSetLightParams(1,  0.0, 1.0, 40, -15, -50,  120,130,110,  205,204,180)
			return true
		end
	end
end
function AnfangsBriefingInitialize()
	Siege.CreateTraps(4, 47700, 29600, 2000, round(8/gvDiffLVL), 200)
	Siege.CreateTraps(4, 51900, 24900, 1200, round(7/gvDiffLVL), 200)
	Siege.CreateTraps(4, 55500, 24400, 1800, round(9/gvDiffLVL), 200)
	Siege.CreateTraps(4, 57500, 25000, 1400, round(7/gvDiffLVL), 200)
	Siege.CreateTraps(4, 57800, 27000, 1200, round(6/gvDiffLVL), 200)
	Siege.CreateTraps(4, 57600, 28700, 1000, round(4/gvDiffLVL), 200)
	Siege.CreateTraps(4, 52700, 33700, 1200, round(6/gvDiffLVL), 200)
	Siege.CreatePitchFields(47700, 29600, 3000, round(5-gvDiffLVL), round(5/gvDiffLVL))
	Siege.CreatePitchFields(51900, 24900, 1800, round(5-gvDiffLVL), round(2/gvDiffLVL))
	Siege.CreatePitchFields(55500, 24400, 2700, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(57500, 25000, 2100, round(5-gvDiffLVL), round(2/gvDiffLVL))
	Siege.CreatePitchFields(57800, 27000, 1800, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(57600, 28700, 1500, round(5-gvDiffLVL), round(3/gvDiffLVL))
	Siege.CreatePitchFields(52700, 33700, 1800, round(5-gvDiffLVL), round(3/gvDiffLVL))
	--
	local typeName = Logic.GetEntityTypeName(Logic.GetEntityType(NightmareHeroID))
	local posX, posY = Logic.GetEntityPosition(GetID("start_pos_p7"))
	local id = Logic.CreateEntity(Entities[typeName .. "_Spectral"], posX, posY, 0, 7)
	AnfangsBriefing()
	return true
end
function UpgradeKIa()
	ResearchTechnology(Technologies.T_SoftArcherArmor, 4)
	ResearchTechnology(Technologies.T_LeatherMailArmor, 4)
	ResearchTechnology(Technologies.T_BetterTrainingBarracks, 4)
	ResearchTechnology(Technologies.T_BetterTrainingArchery, 4)
	ResearchTechnology(Technologies.T_Shoeing, 4)
	ResearchTechnology(Technologies.T_BetterChassis, 4)
	--
	StartCountdown(5*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	ResearchTechnology(Technologies.T_WoodAging, 4)
	ResearchTechnology(Technologies.T_Turnery, 4)
	ResearchTechnology(Technologies.T_MasterOfSmithery, 4)
	ResearchTechnology(Technologies.T_IronCasting, 4)
	ResearchTechnology(Technologies.T_Fletching, 4)
	ResearchTechnology(Technologies.T_BodkinArrow, 4)
	ResearchTechnology(Technologies.T_EnhancedGunPowder, 4)
	ResearchTechnology(Technologies.T_BlisteringCannonballs, 4)
	ResearchTechnology(Technologies.T_PaddedArcherArmor, 4)
	ResearchTechnology(Technologies.T_LeatherArcherArmor, 4)
	ResearchTechnology(Technologies.T_ChainMailArmor, 4)
	ResearchTechnology(Technologies.T_PlateMailArmor, 4)
end

function AnfangsBriefing()

    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Nebelkrieger",
        text	= "@color:230,0,0 Vorrr-wärtss, vorrr-wärtss @cr Die Rache wird unssser sein!",
		position = GetPosition("start_pos_p7")
    }
    StartBriefing(briefing)

end

function ShowArmyCreatorGUI()
	XGUIEng.ShowWidget("Normal",0)
	XGUIEng.ShowWidget("BS_ArmyCreator",1)
	-- no standard units on this map, nv units instead
	XGUIEng.ShowWidget("BS_ArmyCreator_Sword",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Bow",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_PoleArm",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Cavalry",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_HeavyCavalry",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Ulan",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Rifle",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Cannon",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Mercenary",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Hero",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Misc",0)
	XGUIEng.ShowWidget("BS_ArmyCreator_Evil",1)
end
function HideArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",1)
		XGUIEng.ShowWidget("BS_ArmyCreator",0)
	end
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function InitDefGroups()

	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(4,6), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		Logic.GroupStand(eID)
		table.insert(gvLightning.IgnoreIDs, eID)
	end
	local idtable = {{}}
	do
		local pos = {X = 53100, Y = 32000}
		for k = 1,1 do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 50500, Y = 32100}
		for k = 1,1 do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 48700, Y = 28500}
		for k = 1,1 do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 48800, Y = 30400}
		for k = 1,2 do
			idtable[1][k] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(10/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
			Logic.GroupStand(idtable[1][k])
		end
	end
	do
		local pos = {X = 50800, Y = 26300}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 53600, Y = 26300}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 56400, Y = 29800}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 56400, Y = 26300}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(5-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 56400, Y = 28000}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 52200, Y = 26200}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities["PU_LeaderBow"..(4-round(gvDiffLVL))], 0, round(8/(gvDiffLVL)), pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end
	do
		local pos = {X = 54600, Y = 26200}
		idtable[1][1] = AI.Entity_CreateFormation(4, Entities.PU_LeaderRifle2, 0, 7-gvDiffLVL, pos.X, pos.Y, 0, 1,3,0)
		Logic.GroupStand(idtable[1][1])
	end

	local army = {}
	army.player 	= 4
	army.id			= GetFirstFreeArmySlot(4)
	army.strength	= math.max(12-2*math.ceil(gvDiffLVL), 1)
	army.position	= {X = 52900, Y = 29400}
	army.rodeLength	= 9200

	SetupArmy(army)

	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities.PU_LeaderSword4
	}

	for i = 1,army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})

end
function LostEverything()
	local t1, t = {},{}
	Logic.GetHeroes(7, t1)
	for i in t1 do
		local id = t1[i]
		if IsAlive(id) then
			table.insert(t, id)
		end
	end

	if (Logic.GetNumberOfLeader(7) + table.getn(t)) == 0 then
		StopCountdown(RevertToMainStoryCountdown)
		RevertToMainStory()
		return true
	end
end
function KilledEverything()

	if AI.Player_GetNumberOfLeaders(4) == 0
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.PB_Headquarters2) == 0
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(4, Entities.PB_Barracks2) == 0 then
		StopCountdown(RevertToMainStoryCountdown)
		RevertToMainStory()
		return true
	end

end
function RevertToMainStory()
	XGUIEng.ShowWidget("LoadScreen1", 1)
	for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(52400, 29400, 7810)) do
		if Logic.IsEntityInCategory(eID, EntityCategories.Bridge) == 1 then
			local posX, posY = Logic.GetEntityPosition(eID)
			local areaX, areaY = {}, {}
			areaX[1], areaY[1], areaX[2], areaY[2] = GetBuildingTypeBridgeArea(Logic.GetEntityType(eID))
			table.sort(areaX, function(p1, p2)
				return p1 < p2
			end)
			table.sort(areaY, function(p1, p2)
				return p1 < p2
			end)
			CUtil.OverrideTerrainEntityHeight(round(posX/100), round(posY/100), 2000)
			for x = posX + areaX[1], posX + areaX[2], 100 do
				for y = posY + areaY[1], posY + areaY[2], 100 do
					CUtil.OverrideTerrainEntityHeight(round(x/100), round(y/100), 2000)
				end
			end
		end
		DestroyEntity(eID)
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(7)) do
		DestroyEntity(eID)
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_Wall_Gate_Ruin)) do
		DestroyEntity(eID)
	end
	for i = 1, table.getn(blockingPaths) do
		DestroyEntity("invasion_blocking_" .. i)
	end
	for i = 1, table.getn(BackupData) do
		local id = Logic.CreateEntity(BackupData[i].eType, BackupData[i].pos.X, BackupData[i].pos.Y, BackupData[i].rot, BackupData[i].player)
		if BackupData[i].name ~= nil then
			Logic.SetEntityName(id, BackupData[i].name)
		end
	end
	Trigger.EnableTrigger(MapEditor_Armies[4].RebuildTriggerID)
	SetNeutral(7, 4)
	SetHostile(1, 8)
	GUI.SetControlledPlayer(1)
	Display.SetPlayerColorMapping(7, NPC_COLOR)
	XGUIEng.DisableButton("TopDiplomacyMenuTextButton", 0)
	XGUIEng.ShowWidget("LoadScreen1", 0)
	--
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 " .. GetNPCDefaultNameByID(NightmareHeroID),
        text	= "@color:230,0,0 Wie? @cr Was? @cr Was für ein scheußlicher Albtraum...",
		position = GetPosition(NightmareHeroID)
    }
    StartBriefing(briefing)
end
-------------------------------------------------------------------------------------------------------------------------
function NVOutpostActions()
	CreateNVArmyOutpost()
	for i = 1,3 do
		local id = GetID("rock_op" .. i)
		local posX, posY = Logic.GetEntityPosition(id)
		DestroyEntity(id)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, posX, posY)
	end
	StartSimpleJob("NVOPDown")
end
function NVOPDown()
	if IsDead(NVOPArmy) then
		StartCountdown(600/gvDiffLVL, function()
			local posX, posY = Logic.GetEntityPosition(GetID("Outpost_Ruin")) Logic.CreateConstructionSite(posX, posY, 270, Entities.PB_Outpost1, 1)
		end, false)
		StartCountdown(500 + (100*gvDiffLVL), function()
			for i = 4,5 do
				local id = GetID("rock_op" .. i)
				local posX, posY = Logic.GetEntityPosition(id)
				DestroyEntity(id)
				Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, posX, posY)
			end
		end, false)
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------
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
		ASP("Major1",ma1,"Erst dann reden wir weiter. @cr Bis dahin seid ihr hier nicht willkommen!", true)
		briefing.finished = function()
			for i = 1, 3 do
				DestroyEntity("bloodstone_block" .. i)
			end
			StartSimpleJob("Maj1Auftrag")
			Maj1Quest()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa1)
end
function Maj1Auftrag()
	local pos = GetPosition("Steinhaufen")
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 500, EntityCategories.Hero)
	if id then
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
		Message("Das kann doch nicht Euer Ernst sein! @cr "..
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
		EnableNpcMarker(GetID("farmer_p2"))
		Farmer_P2()
		EndlichFertig()
	end;
	StartBriefing(briefing);
	return true
	end
end
function Farmer_P2()
	local npc = "farmer_p2"
	local npc_title = fap2
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Oh, ein Fremder. @cr Und das in dieser abgeschiedenen Gegend. @cr Das hat man auch nicht alle Tage.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ach, ich war nur zufällig in der Nähe und ihr saht so aus, als hättet ihr ein wenig Gesprächsstoff... @cr Scherz beiseite - wir sind hier, um den Dörfern in ihrer Not beizustehen.", true)
		ASP(npc,npc_title,"Gut gesprochen, das muss man Euch lassen. @cr Nun, dann beweist mir, dass hinter Euren Worten auch Taten stehen!", true)
		ASP("AlmView",npc_title,"Beim letzten Unwetter sind mir meine Schafe ausgebüxt... @cr Seid doch bitte so gut und treibt sie wieder zurück auf die Alm.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ihr wisst nicht zufällig, wohin die Schafe geflohen sein könnten?", true)
		ASP(npc,npc_title,"Nun, die Gegend hier ist recht karg. @cr Ich würde vermuten, dass die Schafe sich auf umliegende Bergalmen verstreut haben.", true)
		briefing.finished = function()
			local mountainAlms = {
				{X = 15000, Y = 59200},
				{X = 8300, Y = 56400},
				{X = 4700, Y = 34300},
				{X = 9200, Y = 30500},
				{X = 4500, Y = 24400},
				{X = 12400, Y = 23000},
				{X = 24200, Y = 42500},
				{X = 21600, Y = 49300},
				{X = 21100, Y = 55100},
				{X = 29700, Y = 56000},
				{X = 38200, Y = 66100},
				{X = 47600, Y = 72100}
			}
			local spotCount = table.getn(mountainAlms)
			gvSheepCount = round(10 - 2 * gvDiffLVL)
			local sheepTypes = {}
			for i = 1, 3 do
				table.insert(sheepTypes, Entities["XA_Sheep" .. i])
				table.insert(sheepTypes, Entities["XA_Sheep" .. i .. "_S6"])
			end
			gvSheepTypeNameToCUAquivalent = {
				["XA_Sheep1"] = Entities.CU_Sheep,
				["XA_Sheep2"] = Entities.CU_Sheep2,
				["XA_Sheep3"] = Entities.CU_Sheep3,
				["XA_Sheep1_S6"] = Entities.CU_Sheep1_Idle,
				["XA_Sheep2_S6"] = Entities.CU_Sheep2_Idle,
				["XA_Sheep3_S6"] = Entities.CU_Sheep3_Idle
			}
			for i = 1, gvSheepCount do
				local id = Logic.CreateEntity(sheepTypes[math.random(1, table.getn(sheepTypes))], mountainAlms[math.random(1, spotCount)].X, mountainAlms[math.random(1, spotCount)].Y, 0, 0)
				Logic.SetEntityName(id, "DisappearedSheep" .. i)
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","SheepApproachedJob",1,{},{i})
			end
			gvSheeps = 0
			GUIQuestTools.StartQuestInformation("Sheep", "", 1, 1)
			GUIQuestTools.UpdateQuestInformationString(gvSheeps .. "/" .. gvSheepCount)
			GUIQuestTools.UpdateQuestInformationTooltip = function()
				XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Eingefangene Schafe @cr Auf die Bergalm Dreadstones heimgebrachte Schafe")
			end
			local quest	= {
				id		= GetQuestId(),
				type	= SUBQUEST_OPEN,
				title	= "Die entflohenen Schafe",
				text	= "Findet alle entflohenen Schafe. @cr Sie sollen sich aller Wahrscheinlichkeit nach auf Bergalmen nahe Dreadstone befinden. @cr Bringt alle Schafe sicher zurück auf die Dreadstoner Bergalm.",
			}
			Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
			FP2Quest = quest.id
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function SheepApproachedJob(_index)
	local sheepID = GetID("DisappearedSheep" .. _index)
	local pos = GetPosition(sheepID)
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 300, EntityCategories.Hero)
	if id then
		if Counter.Tick2("HeroSheepGathering_" .. _index .. "_Counter", round(10/gvDiffLVL)) then
			local rng = math.random(1, 4)
			if rng == 1 then
				local id = ReplaceEntity(sheepID, gvSheepTypeNameToCUAquivalent[Logic.GetEntityTypeName(Logic.GetEntityType(sheepID))])
				ChangePlayer(id, 2)
				InitNPC("DisappearedSheep" .. _index)
				SetNPCFollow("DisappearedSheep" .. _index, id, 500, 10000, nil)
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","SheepReturnedJob",1,{},{_index})
				return true
			end
		end
	end
end
function SheepReturnedJob(_index)
	local sheepID = GetID("DisappearedSheep" .. _index)
	if IsNear(sheepID, "AlmView", 2500) then
		SetNPCFollow("DisappearedSheep" .. _index, nil)
		Move(sheepID, "sheepSpot")
		gvSheeps = gvSheeps + 1
		GUIQuestTools.UpdateQuestInformationString(gvSheeps .. "/" .. gvSheepCount)

		if gvSheeps >= gvSheepCount then
			GUIQuestTools.DisableQuestInformation()
			Logic.RemoveQuest(1, FP2Quest)
			EnableNpcMarker(GetID("farmer_p2"))
			Farmer_P2_2()
			Message("Es wurden alle Schaf zurückgebracht. @cr Ihr solltet nun erneut mit dem Schafhirten sprechen!")
			return true
		else
			Message("Es wurde erfolgreich ein Schaf zurückgebracht")
		end
		return true
	end
end
function Farmer_P2_2()
	local npc = "farmer_p2"
	local npc_title = fap2
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Ihr konntet alle Schafe zurückbringen. @cr Habt Dank, habt Dank. @cr @cr Hier, nehmt dies als Zeichen meiner Dankbarkeit.", true)
		ASP(npc,ment,"Herr, seht doch. @cr Der Schafhirte hat Euch zum Dank einige seiner kostbarsten Edelsteine überlassen. @cr Die sind bestimmt einiges wert.", false)
		briefing.finished = function()
			AddGold(round(7500 + 2500 * gvDiffLVL))
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
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
		ASP("CampTrader",ctr,"Sie kämpfen ausgezeichnet. @cr Vorausgesetzt, ihr bezahlt sie gut.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich denke darüber nach.", true)
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
	tribute.text = "Zahlt " .. round(3500 - 500 * gvDiffLVL) .. " Taler, um eine Gruppe Söldner anzuheuern.";
	tribute.cost = {Gold = round(3500 - 500 * gvDiffLVL)};
	tribute.Callback = PayedTribute;
	AddTribute( tribute )
end
function PayedTribute()
	local briefing = {}
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
		ASP("Settler",se,"Garantiert @color:252,0,240 KEINE @color:255,255,255 Zwangsarbeiter der Banditen. Sie wurden auch überhaupt @color:252,0,240 NICHT @color:255,255,255 verschleppt...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das glaubt ihr doch selbst nicht, oder?", true)
		ASP("Settler",se,"Ich sags mal so: @cr Es kommen immer Neue dazu. @cr Macht Euch Euer eigenes Bild dazu.", true)
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
	tribute.text = "Zahlt " .. round(1200 - 200 * gvDiffLVL) .. " Taler, um ein paar Arbeiter zu ergattern.";
	tribute.cost = {Gold = round(1200 - 200 * gvDiffLVL)};
	tribute.Callback = PayedSerfTribute;
	AddTribute( tribute )
end
function PayedSerfTribute()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Settler",se,"Hier, Eure Arbeiter. @cr Behandelt sie gut und kommt bald wieder für weitere tüchtige Arbeitskräfte.", false)
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
		ASP("Alchemist",al,"Häh, wie war nochmal die Frage?? @cr Ah ja, hier gibt es viel Schwefel, also auch viel zu experimentieren.", true)
		ASP("Alchemist",al,"Ich glaube, deshalb haben @color:252,0,240 DIE @color:255,255,255 mich auch aus ihrem Dorf verjagt...", true)
		ASP("Alchemist",al,"Wie dem auch sei, kommen wir zum Geschäftlichen, deshalb seid ihr bestimmt hier.", true)
		ASP("Alchemist",al,"Ich kann diese Wilden auch überhaupt nicht leiden. @cr Gebt mir ein wenig @color:252,0,240 SCHWEEEEEFEL @color:255,255,255 und ich überlasse euch ein paar sehr effektive Mittel gegen das Nebelvolk.", true)
		ASP("Alchemist",al,"Und beeilt euch, ich brauche ihn noch heute!!!!", true)
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
	tribute.text = "Zahlt " .. round(1200 - 200 * gvDiffLVL) .. " Schwefel, um ein moderates Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = round(1200 - 200 * gvDiffLVL)};
	tribute.Callback = PayedTribute1;
	AddTribute( tribute )
end
function SchwefelHandel2()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. round(1800 - 300 * gvDiffLVL) .. " Schwefel, um ein besseres Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = round(1800 - 300 * gvDiffLVL)};
	tribute.Callback = PayedTribute2;
	AddTribute( tribute )
end
function SchwefelHandel3()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. round(6000 - 1000 * gvDiffLVL) .. " Schwefel, um ein hochwertiges Mittel gegen das Nebelvolk zu erhalten (findet selbst heraus, wobei es sich dabei handelt).";
	tribute.cost = {Sulfur = round(6000 - 1000 * gvDiffLVL)};
	tribute.Callback = PayedTribute3;
	AddTribute( tribute )
end

function PayedTribute1()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer kleines Mittel gegen die Wilden!", true)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle1,4,GetPosition("NVMittel"))
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle1,4,GetPosition("NVMittel"))
  	end;
  	StartBriefing(briefing);
end
function PayedTribute2()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer gutes Mittel gegen die Wilden!", true)
	briefing.finished = function()
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("NVMittel"))
		CreateEntity(1,Entities.PV_Cannon3,GetPosition("NVMittel"))
  	end;
  	StartBriefing(briefing);
end
function PayedTribute3()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Alchemist",al,"Endlich neuen Schwefel. @cr Oh, fast vergessen, hier euer hervorragendes Mittel gegen die Wilden!", true)
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
		CustomizeBriefingParams(135, 29, 800)
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
			SetCameraDefaultParams()
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
		ASP("Serf",ser,"Ihr seht aus wie ein fachkundiger Baumeister. @cr Seid doch bitte so nett und baut eine Sägemühle für mich.", true)
		ASP("Wald",ser,"Hier müsste sie eigentlich so gut wie hinpassen. @cr Ich habe in letzter Zeit häufiger aus Langeweile den Wald abgeholzt...", false)
		ASP("Burg",ser,"Ihr bekommt als Gegenleistung auch die Burg hinter mir.", false)
		ASP("Serf",ser,"Sagt mir nur, wie ich die Sägemühle baue. Ich werde sie dann selbst bauen, dann habe ich endlich wieder mal was zu tun.", true)
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
	--EntityName = "Dario",
	Heroes = true,
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
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Aufgabe des Bauern",
	text	= "Baut eine MÜHLE in dem passenden Bereich, um den Bauern glücklich zu machen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	FarQuest = quest.id
end

function Vorbereitung()
	PointerEffects = PointerEffects or {}
	PointerEffects.Smith = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, Logic.GetEntityPosition(GetID("Grobschmiede")))
	--
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
	PointerEffects = PointerEffects or {}
	PointerEffects.Sawmill = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, Logic.GetEntityPosition(GetID("Wald")))
	--
	StartSimpleJob("AbfrageHolzwerk")
	--
	StartSimpleJob("HolzFertig")
	--
	AddStone(150)
	AddClay(200)
end
function Vorbereitung3()
	PointerEffects = PointerEffects or {}
	PointerEffects.Farm = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, Logic.GetEntityPosition(GetID("Farm")))
	--
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
		Logic.DestroyEffect(PointerEffects.Smith)
		return true
	end
end
function AbfrageHolzwerk()
	idHW = SucheAufDerWelt(1,Entities.PB_Sawmill1,2000,GetPosition("Wald"))
	if table.getn(idHW) > 0 and Logic.IsConstructionComplete(idHW[1]) == 1 then
		idHW = idHW[1]
		gvHW = 1
		Logic.DestroyEffect(PointerEffects.Sawmill)
		return true
	end
end
function AbfrageFarm()
	idFa = SucheAufDerWelt(1,Entities.PB_Farm2,3300,GetPosition("Farm"))
	if table.getn(idFa) > 0 and Logic.IsConstructionComplete(idFa[1]) == 1 then
		idFa = idFa[1]
		gvFa = 1
		Logic.DestroyEffect(PointerEffects.Farm)
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
			ReplaceEntity ("Gate", Entities.XD_WallStraightGate)
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiGua)
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
		Mary_HQ_MarkerPos = GetPosition("MaryBurg")
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
			position = Mary_HQ_MarkerPos,
			marker = ANIMATED_MARKER,
			dialogCamera = false,
		}
		ASP("Dario",dario,"Mary?!?!?! @cr Was macht @color:252,0,240 DIE @color:255,255,255 denn hier??.", false)
		briefing.finished = function()
			Maj2Quest()
			StartSimpleJob("BanditenBesiegt")
			EnableNpcMarker("Reiter")
			EnableNpcMarker("settler_p3")
			EnableNpcMarker("monk_p3")
			EnableNpcMarker("miner_p3")
			Reiter()
			Settler_P3()
			Monk_P3()
			Miner_P3()
			ActivateShareExploration(1,3,true)
			SetFriendly(1,3)
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa2)
end
function Settler_P3()
	local npc = "settler_p3"
	local npc_title = sep3
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Guten Tag, der edle Herr. @cr Ich hörte, ihr werdet uns dabei helfen, Marys marodierenden Räubern ein Ende zu setzen.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Korrekt, genau dies ist unser aktuelles Unterfangen.", true)
		ASP(npc,npc_title,"Nun, einst war dies ein abgeschiedenes und verschlafenes Dorf inmitten der Kralberge. @cr Ich sehne mich wieder nach diesen Tagen zurück. @cr Nun, daher habe ich den ein oder anderen Hinweis für Euch, wie ihr Marys Truppen leichter besiegen könnt.", true)
		ASP("Alchemist",npc_title,"Weit im Osten - inmitten der vom Nebelvolk kontrollierten Gegend - haust ein abgeschiedener Alchemist. @cr Ich hörte, gegen ein wenig Schwefel kann man dort ganz exzellente Kanonen erwerben. @cr Sogar solche mit schier unermesslicher Zerstörungskraft, um die sich zahlreichen Mythen ranken.", false)
		ASP("cannon_view_mary",npc_title,"Nun, leider scheint es diesem Kauz wirklich nur um den Schwefel zu gehen. @cr Denn auch Mary konnte dort einige dieser Kanonen erwerben. @cr Ihr solltet vorsichtig sein und diese als erstes ausschalten.", false)
		briefing.finished = function()
			local id = ChangePlayer("cannon_view_mary", 1)
			Logic.SetEntityExplorationRange(id, 11)
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function Monk_P3()
	local npc = "monk_p3"
	local npc_title = mop3
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Schluchz... @cr Herr, es ist eine wahre Tragödie...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was denn? @cr Meint ihr das Grab hinter euch?", true)
		ASP(npc,npc_title,"Weitaus tragischer... @cr Dies ist ein Massengrab... @cr Alle Toten im Kampf gegen die raubenden Horden Marys werden hier begraben... @cr Nun, zumindest die, die wir vom Schlachtfeld wegkarren können...", false)
		ASP("shrine",npc_title,"Und wenn das nicht schon genug wäre, so haben wir nicht einmal eine Kirche, um den Toten zu gedenken und Predigten abzuhalten. @cr Nur diesen Schrein, an dem lokale mystische Wesen verehrt und gefürchtet werden...", false)
		ASP(npc,npc_title,"Das hatte ich mir damals alles ganz anders vorgestellt, als ich mich in den Bergen zur Ruh setzen wollte...", true)
		ASP(npc,npc_title,"Herr, seid doch bitte so gut und errichtet in den Bergen oberhalb von Hronthal eine Kirche. @cr Ach und gegen einen kleinen Obelus lassen sich bestimmt weitere Mönche überzeugen, für das Seelenheil dieser verzweifelten Dörfler zu beten.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ob sich auf diese Weise wirklich Mönche in dieses geschundene Dorf verirren? @cr Nun, ich werde mein Bestes geben.", true)
		ASP(npc,npc_title,"Ich möchte wahrlich nicht unverschämt klingen, aber das wird leider noch nicht ausreichen. @cr Da wäre ja noch das Problem mit dem Massengrab...", true)
		ASP(npc,npc_title,"Nachdem ihr die Kirche errichtet habt, solltet ihr mithilfe einiger Taler und Steinen weitere Gräber nahe der Kirche ausheben lassen. @cr Ach und seid so gut und errichtet ein mittleres Wohnhaus und eine Mühle für die hoffentlich anreisenden Mönchen.", true)
		briefing.finished = function()
			local quest	= {
				id		= GetQuestId(),
				type	= SUBQUEST_OPEN,
				title	= "Die Bitten des Mönchs",
				text	= "Der Mönch von Hronthal ist niedergeschlagen. @cr In letzter Zeit war bestanden seine Hauptaufgaben aus denen eines Totengräbers. Und dies alles nur wegen Marys marodierenden Horden. "..
					" @cr Wenn das nicht schon schlimm genug wäre, so muss der Mönch alle Leichen in einem einzelnen Grab bestatten und kann keine Andachten halten, da das Dorf über keine Kirche verfügt... " ..
					" @cr Errichtet für den Mönch in den Bergen nordöstlich von Hronthal eine Kirche samt mittlerem Wohnhaus und Mühle. @cr Anschließend solltet ihr per Tributmenü weitere Mönche anwerben sowie mittels Steinen und Talern weitere Gräber nahe der Kirche ausheben lassen.",
			}
			Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
			MP3Quest = quest.id
			MP3_NumBuildingsDone = 0
			StartSimpleJob("MP3_CheckForChurchBuilt")
			StartSimpleJob("MP3_CheckForResidenceBuilt")
			StartSimpleJob("MP3_CheckForMillBuilt")
			StartSimpleJob("MP3_CheckForAllBuildingsDone")
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MP3_CheckForChurchBuilt()
	local id = SucheAufDerWelt(1,Entities.PB_Monastery2,3800,{X = 46600, Y = 72300})
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		local id = ChangePlayer(id[1], 3)
		Logic.SetEntityName(id, "MP3_Church")
		Logic.SetCurrentMaxNumWorkersInBuilding(id, 0)
		MP3_NumBuildingsDone = MP3_NumBuildingsDone + 1
		return true
	end
end
function MP3_CheckForResidenceBuilt()
	local id = SucheAufDerWelt(1,Entities.PB_Residence2,3800,{X = 46600, Y = 72300})
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		ChangePlayer(id[1], 3)
		MP3_NumBuildingsDone = MP3_NumBuildingsDone + 1
		return true
	end
end
function MP3_CheckForMillBuilt()
	local id = SucheAufDerWelt(1,Entities.PB_Farm2,3800,{X = 46600, Y = 72300})
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		ChangePlayer(id[1], 3)
		MP3_NumBuildingsDone = MP3_NumBuildingsDone + 1
		return true
	end
end
function MP3_CheckForAllBuildingsDone()
	if MP3_NumBuildingsDone >= 3 then
		local npc = "monk_p3"
		local npc_title = mop3
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Habt Dank für die Errichtung der Kirche. @cr Denkt aber bitte noch an meine weiteren Bitten...", true)
		briefing.finished = function()
			MonkTribute()
			TombstoneTribute()
			MonkTributesPayed = 0
			StartSimpleJob("MP3_CheckForAllTributesPayed")
 		end;
		StartBriefing(briefing)
		return true
	end
end
function MonkTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. round(5000 + 1000 * gvDiffLVL) .. " Taler, um einige Mönche anzuwerben.";
	tribute.cost = {Gold = round(5000 + 1000 * gvDiffLVL)};
	tribute.Callback = MonkTributePayed;
	AddTribute( tribute )
end
function TombstoneTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. round(5000 + 1000 * gvDiffLVL) .. " Steine und " .. round(2000 + 500 * gvDiffLVL) .. " Taler, um weitere Gräber nahe der errichteten Kirche ausheben zu lassen.";
	tribute.cost = {Stone = round(5000 + 1000 * gvDiffLVL), Gold = round(2000 + 500 * gvDiffLVL)};
	tribute.Callback = TombstoneTributePayed;
	AddTribute( tribute )
end
function MonkTributePayed()
	local npc = "monk_p3"
	local npc_title = mop3
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npc_title,"Eure Anwerbungsprämie scheint gewirkt zu haben. @cr Gleich mehrere Mönche sind in unsere Dienste getreten. Sie werden schon bald hier eintreffen. @cr Habt Dank, mein Herr, habt Dank!", true)
	briefing.finished = function()
		MP3_IncreaseChurchWorkers(1)
		MonkTributesPayed = MonkTributesPayed + 1
	end;
	StartBriefing(briefing)
end
function MP3_IncreaseChurchWorkers(_iteration)
	Logic.SetCurrentMaxNumWorkersInBuilding(GetID("MP3_Church"), _iteration)
	if _iteration < 10 then
		StartCountdown(5*60, MP3_IncreaseChurchWorkers, false, nil, _iteration + 1)
	end
end
function TombstoneTributePayed()
	local npc = "monk_p3"
	local npc_title = mop3
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npc_title,"Habt Dank für die Lieferung. @cr Einige örtliche Arbeiter werden alsbald mit dem Ausheben der Gräber beginnen.", true)
	briefing.finished = function()
		StartSimpleJob("MP3_TombstoneWorkerControl")
		MP3_TombstoneWorkerData = {
			{X = 49100, Y = 73800, rot = 270},
			{X = 49100, Y = 73600, rot = 270},
			{X = 49100, Y = 73400, rot = 270},
			{X = 49100, Y = 73200, rot = 270},
			{X = 49100, Y = 73000, rot = 270},
			{X = 49100, Y = 72800, rot = 270},
			{X = 49100, Y = 72600, rot = 270},
			{X = 49100, Y = 72400, rot = 270}
		}
	end;
	StartBriefing(briefing)
end
function MP3_TombstoneWorkerControl()
	if Counter.Tick2("MP3_TombstoneWorkerControl_Counter", 10) then
		if not MP3_TombstoneWorkerControl_SerfIDs then
			MP3_TombstoneWorkerControl_SerfIDs = {}
			MP3_TombstoneWorkerControl_TombIDs = {}
			MP3_TombstoneWorkerControl_Step = 0
			for i = 1, 8 do
				local id = Logic.CreateEntity(Entities.PU_Serf, MP3_TombstoneWorkerData[i].X, MP3_TombstoneWorkerData[i].Y, MP3_TombstoneWorkerData[i].rot, 3)
				local tombStone = Logic.CreateEntity(Entities.XD_Grave1, MP3_TombstoneWorkerData[i].X, MP3_TombstoneWorkerData[i].Y, MP3_TombstoneWorkerData[i].rot, 0)
				Logic.SetTaskList(id, TaskLists.TL_SERF_EXTRACT_RESOURCE)
				table.insert(MP3_TombstoneWorkerControl_SerfIDs, id)
				table.insert(MP3_TombstoneWorkerControl_TombIDs, tombStone)
			end
		end
		for i = 1, 8 do
			Logic.CreateEffect(GGL_Effects.FXBuildingSmoke, MP3_TombstoneWorkerData[i].X, MP3_TombstoneWorkerData[i].Y)
		end
		MP3_TombstoneWorkerControl_Step = MP3_TombstoneWorkerControl_Step + 1
		if MP3_TombstoneWorkerControl_Step > 10 then
			for i = 1, 8 do
				DestroyEntity(MP3_TombstoneWorkerControl_SerfIDs[i])
				ReplaceEntity(MP3_TombstoneWorkerControl_TombIDs[i], Entities["XD_GraveComplete" .. math.random(1,7)])
			end
			MonkTributesPayed = MonkTributesPayed + 1
			return true
		end
	end
end
function MP3_CheckForAllTributesPayed()
	if MonkTributesPayed >= 2 then
		local npc = "monk_p3"
		local npc_title = mop3
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Vielen Dank für all Eure Bemühungen. @cr Nun können wir unseren Gefallenen endlich eine würdige letzte Reise ins Jenseits ermöglichen. @cr Hier, nehmt dies als Zeichen unserer Anerkennung.", true)
		ASP(npc,ment,"Herr, seht doch. @cr Der Mönch hat euch all sein Hab und Gut überlassen. @cr Auch einige andere Dörfler haben wertvolle Besitztümer beigesteuert.", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, round(500 + 300 * gvDiffLVL))
			AddGold(round(10000 + 2500 * gvDiffLVL))
			Logic.RemoveQuest(1, MP3Quest)
		end;
		StartBriefing(briefing)
		return true
	end
end
function Miner_P3()
	local npc = "miner_p3"
	local npc_title = mip3
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Guten Tag der Herr. @cr Ihr könnt mir doch bestimmt weiterhelfen.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Bisher konnten wir noch alle Aufgaben erfüllen. @cr Wo drückt denn der Schuh?", true)
		ASP(npc,npc_title,"Der Schuh? @cr Oh ja, in der Tat. @cr Bei der letzten Wanderung - manche nennen es auch Kraxeln weils so steil ist - in den westlichen Bergen habe ich doch tatsächlich einen meiner Schnürsenkel verloren...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Einen Schnürsenkel? @cr (In Gedanken) Das kann der doch nicht Ernst meinen oder?", true)
		ASP(npc,npc_title,"Ach, wenn es doch nur einer der Schnürsenkel wäre... @cr Damit es mir nicht fröstelt nehme ich stets meinen Flachmann mit auf Wanderungen - müsst ihr wissen. @cr Nun, einiges von dessen Inhalt vermisse ich nun auch... @cr Das Schicksal meint es wirklich schlimm mit mir...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","(In Gedanken) Der Typ hat doch einen Sprung in der Schüssel. Dem wird sein Schluck schon nicht verdunstet sein.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Soso, also ein Schnürsenkel und etwas Schluck. @cr Das lässt sich schon wieder auftreiben.", true)
		ASP(npc,npc_title,"Nein nein, ihr versteht mich nicht. @cr Das ist nicht bloß irgendein Fusel. @cr Das ist ein ganz edler Tropfen von dem mir da einiges fehlt. @cr Normalerweise bin ich gar nicht so, dass ich so wichtige Dinge einfach verliere.", true)
		ASP(npc,npc_title,"Ich fürchte, diese bösen Bergkobolde haben den mir aus der Tasche gesaugt. @cr Das wäre nicht das erste Mal, dass die ihren Schabernack mit mir treiben...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","(In Gedanken) Bergkobolde? @cr Das wird immer wunderlicher. @cr Ob dem Typen überhaupt noch zu helfen ist? @cr Vielleicht sollten wir den zum kalten Entzug zwingen - hat bei Pilgrim auch kurzzeitig gewirkt.", true)
		ASP(npc,npc_title,"Seid doch so gut und schaut für mich mal nach. @cr Ich muss hier so langsam mal weiterarbeiten. @cr Der allmorgendliche Hirnschmerz ist fast vergangen.", true)
		briefing.finished = function()
			MiP3Progress = 0
			local quest	= {
				id		= GetQuestId(),
				type	= SUBQUEST_OPEN,
				title	= "Die Bitten des besoffenen Wanderers",
				text	= "Ein Bergmann von Hronthal hat wahrlich ernste Probleme. @cr Bei der letzten Wanderung in den westlichen Bergen hat er doch tatsächlich einen seiner Schnürsenkel und einen Teil seines guten Schlucks verloren. "..
					" @cr Ein Schnürsenkel, der verloren geht in Kombination mit verschwundenem Alkohol und steilen Bergflanken. @cr Nun, was ist da wohl geschehen?" ..
					" @cr Bergkobolde sollen den Schluck geklaut haben. @cr Nun, die Helden wollen dem armen Irren dennoch helfen. @cr Findet den verschwundenen Schnürsenkel und haltet nach verschüttetem Alkohol Ausschau.",
			}
			Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
			MiP3Quest = quest.id
			MiP3_LacesSpots = {
				{X = 31400, Y = 75600},
				{X = 29300, Y = 74300},
				{X = 24800, Y = 74900},
				{X = 19700, Y = 73500}
			}
			MiP3_BoozeSpots = {
				{X = 6700, Y = 60500},
				{X = 7000, Y = 63300},
				{X = 9400, Y = 66400},
				{X = 7000, Y = 53700}
			}
			local LaceSpot = MiP3_LacesSpots[math.random(1, table.getn(MiP3_LacesSpots))]
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_Sparkles, LaceSpot.X, LaceSpot.Y, 0, 0), "MiP3_Laces")
			local BoozeSpot = MiP3_BoozeSpots[math.random(1, table.getn(MiP3_BoozeSpots))]
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_Sparkles, BoozeSpot.X, BoozeSpot.Y, 0, 0), "MiP3_Booze")
			StartSimpleJob("MiP3_LacesApproached")
			StartSimpleJob("MiP3_BoozeApproached")
			StartSimpleJob("MiP3_AllObjectivesSecured")
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MiP3_LacesApproached()
	local pos = GetPosition("MiP3_Laces")
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 500, EntityCategories.Hero)
	if id then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Da liegen sie ja, die Schnürsenkel des wahnen Bergsteigers.", false)
		briefing.finished = function()
			DestroyEntity("MiP3_Laces")
		end
		StartBriefing(briefing)
		MiP3Progress = MiP3Progress + 1
		return true
	end
end
function MiP3_BoozeApproached()
	local pos = GetPosition("MiP3_Booze")
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 500, EntityCategories.Hero)
	if id then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was riecht denn hier so nach billigem Fusel? @cr Lasst uns hier etwas genauer umschauen.", true)
		AP{
			title = "",
			text = "",
			position = GetPosition("MiP3_Booze"),
			dialogCamera = true,
			action = function()
				local pos = GetPosition("MiP3_Booze")
				local villain = Logic.CreateEntity(Entities.XA_WildBoar1, pos.X, pos.Y, 0, 0)
			end
		}
		ASP("MiP3_Booze",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das ist also der berüchtigte Bergkobold... @cr Nun, wir sollten dem Schluckspecht berichten. Der hat vor lauter Panik bestimmt seinen Schnaps verschüttet.", false)
		briefing.finished = function()
			DestroyEntity("MiP3_Booze")
		end
		StartBriefing(briefing)
		MiP3Progress = MiP3Progress + 1
		return true
	end
end
function MiP3_AllObjectivesSecured()
	if MiP3Progress >= 2 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dario,"Wir haben die Schnürsenkel des Bergsteiger und seinen angeblich schuldigen Bergkobold gefunden. @cr Lasst uns zu ihm gehen und ihm berichten.", false)
		briefing.finished = function()
			EnableNpcMarker(GetID("miner_p3"))
			Miner_P3_2()
			Logic.RemoveQuest(1, MiP3Quest)
		end
		StartBriefing(briefing)
		return true
	end
end
function Miner_P3_2()
	local npc = "miner_p3"
	local npc_title = mip3
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Oh, da seid ihr ja wieder. @cr Und ihr habt meinen Schnürsenkel dabei... @cr Nur wo ist mein edler Tropfen?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ein gutes Stück südlich von hier hat es stark nach Alkohol gerochen. @cr Als ich das näher untersuchen wollte, wurde ich von einem Wildschwein erschrocken.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das wird vermutlich euer Bergkobold sein, von dem ihr gesprochen habt. @cr Vor lauter Panik habt ihr dann wohl etwas von eurem Schluck verschüttet. @cr So was kann schon mal vorkommen...", true)
		ASP(npc,npc_title,"Nein, das ist kein Bergkobold, von dem ihr da spricht. Das ist Larry, den kenne ich schon, seit er ein kleines Ferkel war. @cr Nein, nein, so wenn ich es euch doch sage... @cr Ein wahrhaftiger Bergkobold hat sich an meinem Flachmann gütig getan!", true)
		ASP(npc,npc_title,"Und nun auf auf. @cr Sucht weiter, bis ihr dieses Monster gefunden habt!", true)
		briefing.finished = function()
			local pos = GetPosition("ye_olde_watchtower")
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_Sparkles, pos.X, pos.Y, 0, 0), "MiP3_2_Booze")
			local quest	= {
				id		= GetQuestId(),
				type	= SUBQUEST_OPEN,
				title	= "Der schuckstehlende Bergkobold",
				text	= "Der Wanderer beharrt darauf, dass ein Bergkobold sich an seinem Schluck vergangen hat. Das Wildschwein ist wohl ein alter Bekannter des Schluckspechts."..
					" @cr Wir sollten weiter Ausschau nach diesem Bergkobold halten. @cr Bei der Begegnung mit Larry hatte der Wanderer seinen Schluck wohl noch." ..
					" @cr Das heißt, der Bergkobold ist ihm erst danach begegnet. @cr Es ist wahrscheinlich, dass der Schluckspecht auf dem Rückweg ins Dorf war...",
			}
			Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
			MiP3_2_Quest = quest.id
			StartSimpleJob("MiP3_2_BoozeApproached")
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MiP3_2_BoozeApproached()
	local pos = GetPosition("ye_olde_watchtower")
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, pos.X, pos.Y, 500, EntityCategories.Hero)
	if id then
		DestroyEntity("MiP3_2_Booze")
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Hier ist der Geruch nach billigem Fusel besonders stark. @cr Lasst uns hier etwas genauer umschauen.", true)
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
			text = "(In Gedanken) Das sieht so aus, als wäre hier kürzlich jemand gewesen... @cr @cr Hallo? @cr Ist jemand zu Hause? @cr Ich bin bloß ein Fremder auf der Suche nach gutem Schluck...",
			position = GetPosition("ye_olde_watchtower"),
			dialogCamera = true,
			action = function()
				CustomizeBriefingParams(90, 39, 900)
			end
		}
		AP{
			title = "",
			text = "... @cr ... @cr (krachende und ächzende Geräusche sind zu vernehmen; wie wenn jemand schnell eine alte Holztreppe herunterläuft) @cr ... @cr ...",
			position = GetPosition("ye_olde_watchtower"),
			dialogCamera = true,
			action = function()
				local pos = GetPosition("ye_olde_watchtower")
				local villain = Logic.CreateEntity(Entities.CU_VeteranCaptain, pos.X + 100, pos.Y, 0, 7)
				Logic.SetEntityName(villain, "smuggler")
				LookAt(villain, id); LookAt(id, villain)
				CustomizeBriefingParams(90, 36, 2900)
			end
		}
		ASP(id,"???","Soso, auf der Suche nach gutem Schluck seid ihr? @cr Da kann ich Euch einiges anbieten. @cr Erst kürzlich kam wieder ein edler Tropfen in meinen Besitz.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","(In Gedanken) Da ist doch was faul. Wie soll der hier an neuen hochwertigen Alkohol gelangen? @cr Das ist bestimmt ein Schmuggler, der den Schluckspecht auf seiner Rückreise ausgeraubt hat.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun, das klingt verlockend. @cr Wo kommt der gute Tropfen denn her, in welchem Fass ist der gereift und wie lange? @cr Könnt ihr mir vielleicht mal die Flasche oder das Fass zeigen?", false)
		ASP(id,"???","Ihr stellt zu viele Fragen! @cr So was sehe ich hier nicht gerne. @cr Los, verschwindet!", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Also war mein Verdacht berechtigt. @cr Ihr habt etwas zu verbergen. @cr Nun sagt schon, habt ihr einen Wanderer um seinen Schluck gebracht? @cr Und schmuggelt ihr hier etwa Alkohol?", false)
		ASP(id,smg,"Ihr wolltet ja nicht auf mich hören und seid nicht verschwunden. @cr Nun, wie sagt man so schön: Wer nicht hören will, muss fühlen!", false)
		briefing.finished = function()
			SetCameraDefaultParams()
			ChangePlayer("smuggler", 5)
			Attack("smuggler", id)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN,"","MiP3_CheckForSmugglerNearDeath",1,{},{id})
		end
		StartBriefing(briefing)
		return true
	end
end
function MiP3_CheckForSmugglerNearDeath(_heroID)
	if GetHealth("smuggler") <= 30 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		local choicePage = AP{
			mc = {
				title			= smg,
				text 			= "Gnade, Herr. @cr Ich ergebe mich und gestehe. @cr Nur bitte verschont mein Leben.",
				firstText  		= " @color:230,0,0 Üble Verbrecher haben keine Gnade verdient!",
				secondText 	 	= " @color:20,255,50 Gut gewinselt. @cr Ihr dürft leben - vorerst.",
				firstSelected  	= 2,
				secondSelected 	= 4,
				position 		= GetPosition("smuggler")
			},
			action = function() BRIEFING_ZOOMANGLE = 38 BRIEFING_ZOOMDISTANCE = 4500 end
		}
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(_heroID) .. ""..weiss.."",
			text = "Los, machen wir den Scheißkerl fertig und durchsuchen dann den Turm nach Schmuggelware.",
			position = GetPosition(_heroID)
		}
		AP()
		AP{
			title = smg,
			text = "Danke Herr, ihr seid wahrlich ein gütiger Anführer...",
			position = GetPosition("smuggler"),
			action = function()
				local id = ChangePlayer("smuggler", 7)
				Logic.SetEntityName(id, "smuggler")
			end
		}
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(_heroID) .. ""..weiss.."",
			text = "Los und jetzt raus mit der Sprache! @cr Wer seid ihr und was treibt ihr hier? @cr Und habt ihr dem armen Wanderer seinen Schluck entwendet?",
			position = GetPosition(_heroID)
		}
		AP{
			title = smg,
			text = "Nun, wie ihr bereits vermutet hattet, bin ich ein Schmuggler. @cr Durch das ganze Elend hier in der Gegend wurde das zu einem lukrativen Geschäft. @cr In schlechten Zeiten möchte niemand einen guten Schluck missen.",
			position = GetPosition("smuggler")
		}
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(_heroID) .. ""..weiss.."",
			text = "Nun sagt schon. @cr Also wart ihr derjenige, der den Wanderer überfallen hat?",
			position = GetPosition(_heroID)
		}
		AP{
			title = smg,
			text = "Ja, auch das ging auf meine Kappe. @cr Ich wusste ja nicht, dass die Schnapsdrossel so mächtige Bekannte hat... @cr Ihr müsst mir glauben, das war nichts Persönliches. Ich tat das alles nur für das Geschäft...",
			position = GetPosition("smuggler")
		}
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(_heroID) .. ""..weiss.."",
			text = "Hmm, wenig Reue erkennbar. @cr Nun meine Männer. Alles auseinandernehmen. @cr Lasst hier keinen Stein auf den anderen... @cr Und sperrt den Typen weg. Ich will ihn nicht mehr sehen.",
			position = GetPosition(_heroID)
		}
		AP{
			title = smg,
			text = "Aber Herr, das könnt ihr doch nicht tun... @cr Das hier ist mein Lebenswerk...",
			position = GetPosition("smuggler")
		}
		AP{
			title = ""..orange.."" .. GetNPCDefaultNameByID(_heroID) .. ""..weiss.."",
			text = "Nun, dann habt ihr euer Leben verschwendet. @cr Hier ist das letzte Wort gesprochen!",
			position = GetPosition(_heroID)
		}
		briefing.finished =	function()
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				StartSimpleJob("MiP3_CheckForSmugglerDead")
    		else
				DestroyEntity("smuggler")
				StartCountdown(5, MiP3_BlowRuinIntoThinAir, false)
			end
		end
		StartBriefing(briefing)
		return true
	end
end
function MiP3_CheckForSmugglerDead()
	if IsDead("smuggler") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("ye_olde_watchtower",dario,"Der Verbrecher hat für seine Schandtaten gebüßt. @cr Nun, wir sollten den Schmugglerturm durchsuchen und dem Bergmann berichten.", false)
		briefing.finished = function()
			EnableNpcMarker(GetID("miner_p3"))
			Miner_P3_3(1)
			Logic.RemoveQuest(1, MiP3_2_Quest)
		end
		StartBriefing(briefing)
		return true
	end
end
function MiP3_BlowRuinIntoThinAir()
	local pos = GetPosition("ye_olde_watchtower")
	for x = pos.X - 400, pos.X + 400, 100 do
		for y = pos.Y - 400, pos.Y + 400, 100 do
			Logic.CreateEffect(GGL_Effects.FXCrushBuildingLarge, x, y)
			Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, x, y)
		end
	end
	DestroyEntity("smugglers_tower")
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("ye_olde_watchtower",dario,"Der Verbrecher wurde eingekerkert und das alte Schmugglerversteck liegt in Schutt und Asche. @cr Wir sollten dem Bergmann berichten.", false)
	briefing.finished = function()
		EnableNpcMarker(GetID("miner_p3"))
		Miner_P3_3(2)
		Logic.RemoveQuest(1, MiP3_2_Quest)
	end
	StartBriefing(briefing)
end
function Miner_P3_3(_index)
	local indexToText = {
		"Der Schmuggler ist nicht mehr. @cr Als wir ihm auf die Schliche kam, griff er seine Waffe und wir erschlugen ihn im Kampf. @cr Das Schmugglerversteck haben wir von oben bis unten durchsucht, konnten jedoch keine Hinweise auf Komplizen finden. Die Waren haben wir natürlich mitgenommen.",
		"Der Schmuggler wurde nervös, als wir ihn mit Fragen überschütteten und griff seine Waffe. @cr Wir überwältigten ihn und nahmen ihn in Gewahrsam. @cr Er zeigte jedoch keine wirkliche Reue, daher haben wir ihn in das dreckigste Loch geworfen und das Schmugglerversteck gesprengt."
	}
	local npc = "miner_p3"
	local npc_title = mip3
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Oh, da seid ihr ja wieder. @cr Und, habt ihr meinen edlen Tropfen dabei?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Natürlich. @cr Ich würde nicht mit leeren Händen zurückkommen. @cr Und nebenbei haben wir einem Schmuggler das Handwerk gelegt.", true)
		ASP(npc,npc_title,"Schmuggler? @cr Wovon redet ihr denn da?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Eure sogenannten Bergkobolde waren Schmuggler. @cr Ihr wart wohl nicht mehr ganz bei Sinnen, als ihr auf dem Rückweg an dem alten Schmugglerversteck vorbei kamt.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun, einer der Schmuggler nutze euren ...ähem ...Zustand aus und raubte euch aus. @cr Das lief wohl schon häufiger so ab, denn große Teile von deren Inventar bestand aus eurem Schluck.", true)
		ASP(npc,npc_title,"Ohweh. @cr Nun, habt ihr den Schmuggler ordentlich bestraft?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",indexToText[_index], true)
		ASP(npc,npc_title,"Oh, da bin ich aber beruhigt. @cr Dann kann ich die nächsten nächtlichen Wanderungen wieder unberschwert genießen. @cr Hier nehmt zum Dank eine meiner Spezialtechniken, mit der ihr mehr Siedler anlocken könnt. Ihr habt es mehr als verdient!", true)
		briefing.finished = function()
			CLogic.SetAttractionLimitOffset(1, round(40 + 20 * gvDiffLVL))
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function Maj2Quest()
	local quest	= {
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
	local quest	= {
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
		local pos = GetPosition("NVCave")
		GUI.DestroyMinimapPulse(pos.X, pos.Y)
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
			EnableNpcMarker("guard_p4")
			EnableNpcMarker("miner_p4")
			Guard_P4()
			Miner_P4()
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMa4)
end
function Guard_P4()
	local npc = "guard_p4"
	local npc_title = gup4
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Ich hörte, ihr habt Euch unserem Anführer gegenüber bewiesen. @cr Nun, seht gar nicht so aus. @cr Aber ich will mal nicht so sein...", true)
		ASP(npc,npc_title,"Unsere Schatzkammern leeren sich allmählich. @cr Der ständige Kampf gegen das Nebelvolk zehrt massiv an unseren Reserven. @cr Auch wenn der Anführer Euch nie darum beten würde ...oder es sich überhaupt eingestehen würde, aber wir bräuchten ein wenig finanzielle Unterstützung, um uns auch künftig gegen das Nebelvolk behaupten zu können...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich schaue, was sich machen lässt.", true)
		briefing.finished = function()
			MurkalArmyTribute()
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MurkalArmyTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Gebt dem Schatzwächter Murkals " .. round(25000 - 5000 * gvDiffLVL) .. " Taler, damit sie sich auch künftig gegen das Nebelvolk behaupten können.";
	tribute.cost = {Gold = round(25000 - 5000 * gvDiffLVL)};
	tribute.Callback = MurkalTributePayed;
	AddTribute( tribute )
end
function MurkalTributePayed()
	local npc = "guard_p4"
	local npc_title = gup4
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npc_title,"Habt Dank für die Zahlung. @cr Mit volleren Schatzkammern können wir unsere Truppenstärke vergrößern und uns ein wenig offensiver aufstellen. @cr Nun, finanziert uns gerne erneut und wir werden weiter erstarken!", true)
	briefing.finished = function()
		MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(2 + gvDiffLVL)
		MapEditor_Armies[4].offensiveArmies.rodeLength = MapEditor_Armies[4].offensiveArmies.rodeLength * 1.5
		MurkalArmyTribute()
	end;
	StartBriefing(briefing)
end
function Miner_P4()
	local npc = "miner_p4"
	local npc_title = mip4
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Ihr müsst derjenige sein, der Eindruck beim Anführer schinden konnte. @cr Nun, Hut ab; der lässt sich nicht so leicht beeindrucken.", true)
		ASP(npc,npc_title,"Ich aber auch ebenso wenig. @cr Die Arbeit als Bergmann hier ist nicht leicht. @cr Die erstarkenden Horden des Nebelvolks machen die tägliche Arbeit hier immer erschwerlicher. @cr Ich bin bereits zu einem halben Soldaten verkommen... @cr Ich sehne mich nach meinem alten Leben als einfacher Bergmann...", true)
		ASP("NV25",npc_title,"Ein Wanderer erzählte mir einst, dass es südlich von hier einen abgeschiedenen Lehmschacht gibt. @cr Der soll sich zwar ganz in der Nähe vom Lager des Nebelvolks befinden, ist aber durch die Abgeschiedenheit in den Bergen kaum zu erreichen und damit sicher vor Angriffen.", false)
		ASP(npc,npc_title,"Seid doch bitte so gut und errichtet dort ein Lehmbergwerk sowie einen Gutshof und ein großes Wohnhaus. @cr Ach und vernichtet alle Patrouillen des Nebelvolks, die sich auf dem Weg dorthin herumtreiben.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun ich kann euch nichts versprechen, aber ich schaue was sich machen lässt.", true)
		briefing.finished = function()
			MiP4Progress = 0
			StartSimpleJob("MiP4_CheckForFarmBuilt")
			StartSimpleJob("MiP4_CheckForResidenceBuilt")
			StartSimpleJob("MiP4_CheckForMineBuilt")
			StartSimpleJob("MiP4_CheckForAllBuildingsDone")
			--
			local quest	= {
				id		= GetQuestId(),
				type	= SUBQUEST_OPEN,
				title	= "Ein ruhigeres Leben",
				text	= "Errichtet für den Bergmann Murkals südlich der Siedlung ein Lehmbergwerk, einen Gutshof sowie ein großes Wohnhaus. @cr Beseitigt sämtliche patrouillerende Horden des Nebelvolks nahe des Lehmschachts.",
			}
			Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text, 1)
			MiP4Quest = quest.id
 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function MiP4_CheckForFarmBuilt()
	local pos = GetPosition("NV25")
	local id = SucheAufDerWelt(1, Entities.PB_Farm3, 3800, pos)
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		if not AreEntitiesInArea(8, 0, pos, 3800, 1) then
			ChangePlayer(id[1], 4)
			MiP4Progress = MiP4Progress + 1
			return true
		end
	end
end
function MiP4_CheckForResidenceBuilt()
	local pos = GetPosition("NV25")
	local id = SucheAufDerWelt(1, Entities.PB_Residence3, 3800, pos)
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		if not AreEntitiesInArea(8, 0, pos, 3800, 1) then
			ChangePlayer(id[1], 4)
			MiP4Progress = MiP4Progress + 1
			return true
		end
	end
end
function MiP4_CheckForMineBuilt()
	local pos = GetPosition("NV25")
	local id = SucheAufDerWelt(1, Entities.PB_ClayMine3, 1800, pos)
	if table.getn(id) > 0 and Logic.IsConstructionComplete(id[1]) == 1 then
		if not AreEntitiesInArea(8, 0, pos, 3800, 1) then
			ChangePlayer(id[1], 4)
			MiP4Progress = MiP4Progress + 1
			return true
		end
	end
end
function MiP4_CheckForAllBuildingsDone()
	if MiP4Progress >= 3 then
		local npc = "miner_p4"
		local npc_title = mip4
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Vielen Dank für Eure harte Arbeit. @cr Ich begebe mich sofort zur neuen Mine. @cr Sprecht dort erneut mit mir, ich habe etwas für Euch...", true)
		briefing.finished = function()
			Move("miner_p4", "NV25")
			Logic.RemoveQuest(1, MiP4Quest)
			StartSimpleJob("MiP4_ArrivedAtMineJob")
 		end;
		StartBriefing(briefing)
		return true
	end
end
function MiP4_ArrivedAtMineJob()
	if IsNear("miner_p4", "NV25", 500) then
		EnableNpcMarker(GetEntityId("miner_p4"))
		Miner_P4_2()
		return true
	else
		if Counter.Tick2("MiP4_ArrivedAtMineJob_Counter", 5) then
			Move("miner_p4", "NV25")
		end
	end
end
function Miner_P4_2()
	local npc = "miner_p4"
	local npc_title = mip4
	local NPCData = {
	Heroes = true,
    TargetName = npc,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(npc))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(npc,id);LookAt(id,npc)
		DisableNpcMarker(GetEntityId(npc))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(npc,npc_title,"Ah, ihr seid es, werter Herr. @cr Habt vielen Dank für das Errichten des Lehmbergwerks in dieser abgeschiedenen Gegend. @cr Nun kann ich wieder einem gewöhnlichen Bergmannsleben nachkommen.", true)
		ASP(npc,npc_title,"Ich habe auch eine Belohnung für all Eure Mühen. @cr Nun, da ich Bergmann bin und schon immer war, halten sich meine weltlichen Besitztümer in Grenzen. @cr Ich gebe Euch etwas subtileres...", true)
		ASP(npc,npc_title,"Ich fürchte jedoch, ich muss dazu etwas weiter ausholen... @cr Es gab einmal eine Zeit, in der mich die Reise- und Entdeckerlust packte. @cr So streifte ich durchs Land und hatte die ein oder andere ...interessante Begegnung.", true)
		ASP(npc,npc_title,"Einst traf ich einen verschrobenen Kauz, der sich nur der Rätselmeister nannte. @cr Nun, wenig überraschend stellte er mir prompt ein komplexes Rätsel...", true)
		ASP(npc,npc_title,"So schien es damals zumindest. @cr Meine Belohnung an Euch soll meine Weisheit bezüglich dieser Rätsel sein - sofern dieser Rätselmeister hier noch sein Unwesen treibt... @cr Nun, zurück zum - rückwirkend betrachtet - recht simplen Rätsel.", true)
		ASP(npc,npc_title,"Zunächst ging es um einen Bären und dessen Fellfarbe. @cr Man bekommt recht wenig Informationen und ich dachte damals, dass dieses Rätsel unlösbar sei. @cr Doch einige Jahre später hatte ich eine Erleuchtung und fand die Lösung.", true)
		ASP(npc,npc_title,"Das Rätsel lässt nur einen infragekommenden Punkte auf der Welt zu, in dem sich die Geschehnisse abgespielt haben könnten. @cr Und nur eine Art Bär kommt dort vor...", true)
		ASP(npc,npc_title,"Eine Belohnung gab mir der Rätselmeister nicht, da ich mehrere Jahre für die Lösung brauchte. @cr Er meinte, die Erleuchtung sei Belohung genug und ich dürfe ein weiteres seiner Rätsel hören...", true)
		ASP(npc,npc_title,"Nun, das zweite Rätsel hatte es in sich. @cr Ich kenne bis zum heutigen Tage nicht die Antwort und kann Euch daher nur bedingt Hinweise geben.", true)
		ASP(npc,npc_title,"Es ging bei diesem Rätsel um ein Schaf, welches festgekettet an einem Pflock nach und nach all die Gräser um sich herum vertilgt, um überleben zu können. @cr Es war ein sehr trauriges Rätsel, denn der Rätselmeister stellte die Frage, wann das arme Schaf verhungert...", true)
		ASP(npc,npc_title,"Ich rechnete jahrelang und dennoch fand ich keine Antwort. @cr Mir deucht, komplexe Berechnungen werden hier gar nicht erwartet. @cr Viel mehr scheint es sich um die Randbedigungen wie die Jahreszeiten zu drehen...", true)
		ASP(npc,npc_title,"Nun, mehr kann ich Euch dazu leider auch nicht sagen. @cr Seid doch bitte so gut und erzählt mir die Lösung dieses Rätsels - sofern ihr sie herausfindet...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Vielen Dank für all die Informationen. @cr Ich hoffe, ich kann mir das alles merken...", true)
		briefing.finished = function()

 		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(NPCData)
end
function Maj4Quest()
	local quest	= {
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
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("WohnSpawn",ment,"Der Vorposten des Nebelvolkes ist gefallen.", false)
		ASP("WohnSpawn",dario,"Hmm, was ist das für ein komischer Hebel?", false)
		ASP("WohnSpawn",ment,"Dario betätigt vorsichtig den Hebel... @cr Ein lautes Knacken aus großer Entfernung ist zu hören...", false)
		ASP("WohnSpawn",ment,"Was das wohl zu bedeuten hat...", false)
		briefing.finished = function()
			DestroyEntity("Rock1")
			DestroyEntity("Rock2")
			DestroyEntity("Rock3")
			WohnReactArmy()
 		end;
		StartBriefing(briefing)
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
		GUI.DestroyMinimapPulse(Mary_HQ_MarkerPos.X, Mary_HQ_MarkerPos.Y)
		Siedlung = Siedlung + 1
		MapEditor_Armies[3].offensiveArmies.rodeLength = Logic.WorldGetSize()
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

		StartSimpleJob("CheckForAllNVDown")
		Logic.RemoveQuest(1,Maj4Quest)
		Maj4Quest2()
		return true
	end
end
function Maj4Quest2()
	quest	= {
		id		= GetQuestId(),
		type	= MAINQUEST_OPEN,
		title	= "Vernichtet die verbleibenden Truppen des Nebelvolks",
		text	= "Ihr habt das Lager des Nebelvolks vernichtet! @cr Es haben jedoch einige Nebelkrieger überlebt. Vernichtet sämtliche verbliebene Truppen des Nebelvolks!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Maj4Quest2 = quest.id
end
function CheckForAllNVDown()
	if IsDead("Kala") and Logic.GetNumberOfLeader(8) <= 1 then
		Siedlung = Siedlung + 1
		Logic.RemoveQuest(1,Maj4Quest2)
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
	CreateRandomGoldChest(GetPosition("Taler10"),chestCallbackTaler10)
	CreateRandomGoldChest(GetPosition("Taler11"))
	CreateRandomGoldChest(GetPosition("Taler12"))
	CreateRandomGoldChest(GetPosition("Taler13"))
	CreateRandomGoldChest(GetPosition("Taler14"))
	CreateRandomGoldChest(GetPosition("Taler15"))
	CreateRandomGoldChest(GetPosition("Taler16"))
	CreateRandomGoldChest(GetPosition("Taler17"))
	CreateRandomGoldChest(GetPosition("Taler18"))
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
function chestCallbackTaler10()
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
		EndJob(StartCaveJob)
		AllConditionsMet = true
		StartCountdown(5, SiegBriefing, false)
		return true
	end
end
function Verloren()
	if (IsDead("Dario") or IsDead("Ari") or IsDead("Drake") or IsDead("Pilgrim") or IsDead("Erec")) and not InTranceSequence then
		NiederlageBriefing()
		return true
	end
end
function Teleport()
	TeleportSettler(GetID("Pilgrim"), Logic.GetEntityPosition(GetID("TeleportPilgrim")))
	TeleportSettler(GetID("Dario"), Logic.GetEntityPosition(GetID("TeleportDario")))
	TeleportSettler(GetID("Ari"), Logic.GetEntityPosition(GetID("TeleportAri")))
	TeleportSettler(GetID("Erec"), Logic.GetEntityPosition(GetID("TeleportErec")))
	TeleportSettler(GetID("Drake"), Logic.GetEntityPosition(GetID("TeleportDrake")))
	--
	Logic.RotateEntity(GetID("Pilgrim"), 250)
	Logic.RotateEntity(GetID("Dario"), 245)
	Logic.RotateEntity(GetID("Ari"), 240)
	Logic.RotateEntity(GetID("Erec"), 235)
	Logic.RotateEntity(GetID("Drake"), 230)
end
function SiegBriefing()
	Teleport()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = ment,
		text = "Ihr habt erfolgreich allen drei Siedlungen geholfen. @cr "..
		       "Sie können nun wieder in Frieden und Harmonie leben. @cr "..
		       "Aber auch Dario wird ihnen in Erinnerung bleiben.",
		position = GetPosition("Major2"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 37600, 72300);
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 37600, 72300);
		end
		}
	AP{
		title = ment,
		text = "Sie werden von nun an Dario und seine Freunde als Helden feiern...",
		position = GetPosition("Major1"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 16900, 66500);
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 16900, 66500);
		end
		}
	AP{
		title = ment,
		text = "...Und Fremden zukünftig ein wenig netter gegenüber stehen.",
		position = GetPosition("Major3"),
		dialogCamera = false,
		action = function()
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 53400, 29600);
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 53400, 29600);
		end
	}

	ASP("Dario",dario,"Das war ein gutes Stück Arbeit für uns, aber es hat sich gelohnt, die Dörfer können nun wieder unbeschwerter leben.", false)
	ASP("Pilgrim",pil,"Dann können wir endlich wieder nach Hause?.", true)
	ASP("Dario",dario,"Warum willst du die ganze Zeit über bereits so dringend nach Hause?", false)
	ASP("Pilgrim",pil,"Mir ist auf dem Weg hierher eingefallen, dass ich meinen ganzen Sprengstoff ungesichert zu Hause liegen gelassen habe.", false)
	ASP("Dario",dario,"Na, da wird Dovbar bestimmt regen Spaß dran haben, wenn ihm das alles direkt vor seiner Nase um die Ohren fliegt.", true)
	ASP("Ari",ari,"Muss ich euch @color:252,0,240 SCHON @color:255,255,255 wieder unterbrechen?? Wir wollten doch so langsam mal los.", true)
	ASP("Dario",dario,"Ari hat Recht, lasst uns endlich wieder nach Hause aufbrechen!", false)
    briefing.finished = function()
		Logic.RemoveQuest(1,DarQuest)
		Aufbruch()
	end;
	StartBriefing(briefing);
end
function Aufbruch()
	Move("Dario","EndPosDario")
    Move("Ari","EndPosAri")
    Move("Erec","EndPosErec")
    Move("Pilgrim","EndPosPilgrim")
    Move("Drake","EndPosDrake")
	--
	StartCutscene("Outro", Victory)
	--[[
	CustomizeBriefingParams(135, 19, 900)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = ment,
		text = "Und so reisten Dario und seine vier Freunde wieder zurück in die Heimat.",
		position = GetPosition("Dario"),
		dialogCamera = false,
		follow = GetID("Dario"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = ment,
		text = "Ab und zu hörten sie noch das Gemurre von Pilgrim und ständige nervige Fragereien <<Sind wir bald bei einer Taverne? So unterhopft war ich schon lange nicht mehr...>>",
		position = GetPosition("Pilgrim"),
		dialogCamera = false,
		follow = GetID("Pilgrim"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = ment,
		text = "Aber das schmälerte ihre Freude kein bisschen. @cr Nur einmal musste Dario Drake davon abhalten, seine Schießübungen an Pilgrim durchzuführen.",
		position = GetPosition("Drake"),
		dialogCamera = false,
		follow = GetID("Drake"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = ment,
		text = "Aber selbst die besten Freunde streiten sich nunmal ab und zu. @cr <<Ab und zu?? Was labert der für einen Schwachsinn? Drake wird gleich mal ein wenig Feuer unter seinen Füßen verspüren hehehe, dann läuft er auch gleich besser.>>",
		position = GetPosition("Pilgrim"),
		dialogCamera = false,
		follow = GetID("Pilgrim"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = drake,
		text = "<<Wie war das, du kleine stinkende Ratte? Du wirst gleich mal spüren, was es heißt, eine wahrhaftige Bleivergiftung zu verspüren!>>",
		position = GetPosition("Drake"),
		dialogCamera = false,
		follow = GetID("Drake"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	AP{
		title = ment,
		text = "Nun ja wie dem auch sei, die ganze Reise verlief ohne weitere Komplikationen. @cr Die Heldentruppe reiste bis spät in die Nacht und Ari und Dario mussten die derweil gut in Streitlaune befindlichen Drake und Pilgrim zügeln.",
		position = GetPosition("Dario"),
		dialogCamera = false,
		follow = GetID("Dario"),
		action = function()
			CustomizeBriefingParams(135, 19, 900)
		end
	}
	briefing.finished = function()
		SetCameraDefaultParams()
		Victory()
	end
	StartBriefing(briefing);
	]]
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
VolcanoExplosionsPositions = {
	{X = 22261.76, Y = 18772.57},
	{X = 22065.72, Y = 17661.36},
	{X = 40400.23, Y = 35741.33},
	{X = 41385.05, Y = 37967.02}
}
function VolcanoExplosions()
	local pos = VolcanoExplosionsPositions[math.random(1, table.getn(VolcanoExplosionsPositions))]
	Logic.CreateEffect(GGL_Effects.FXExplosionVolcanic, pos.X, pos.Y)
	StartCountdown(3, VolcanoExplosions, false)
end
--
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
Briefing = function(_page,_firstPage)

	--	by default

	--	disable following camera

	Camera.FollowEntity(0)

	--	quest activated?

	if _page.quest ~= nil then

		assert(_page.quest.id 		~= nil)
		assert(_page.quest.type 	~= nil)
		assert(_page.quest.title 	~= nil)
		assert(_page.quest.text 	~= nil)

		-- position to quest
		if _page.position ~= nil and _page.noScrolling ~= true then

			Logic.AddQuestEx(
				1,
				_page.quest.id,
				_page.quest.type,
				_page.quest.title,
				_page.quest.text,
				_page.position.X,
				_page.position.Y,
				1
			)

		else

			Logic.AddQuest(
				1,
				_page.quest.id,
				_page.quest.type,
				_page.quest.title,
				_page.quest.text,
				1
			)

		end
	end

	--	exploration activated?

	if _page.explore ~= nil then
		assert(_page.position ~= nil)
		assert(_page.exploreId == nil)
		_page.exploreId = GlobalMissionScripting.ExploreArea(_page.position.X,_page.position.Y,_page.explore / 100)
		Logic.ForceFullExplorationUpdate()
		assert(_page.exploreId ~= 0)
	end

	--	create minimap marker?

	if _page.marker ~= nil then

		if type(_page.marker) == "table" then

			table.foreach(_page.marker, function(_,_marker) ShowBriefingMarker(_marker) end)

		else

			ShowBriefingMarker(_page)

		end

	end

	--	position available?

	if _page.position ~= nil then

		--	deploy the camera directly, for the first page of the briefing report

		if _page.noScrolling == nil then

			if _page.dialogCamera == true then

				Camera.ZoomSetDistance(DIALOG_ZOOMDISTANCE)
				Camera.ZoomSetAngle(DIALOG_ZOOMANGLE)

			else

				Camera.ZoomSetDistance(BRIEFING_ZOOMDISTANCE)
				Camera.ZoomSetAngle(BRIEFING_ZOOMANGLE)

			end

			Camera.ScrollSetLookAt(_page.position.X,_page.position.Y)

		end

		--	deploy minimap signal

		GUI.ScriptSignal(_page.position.X,_page.position.Y,0)

	end

	--	npc available?

	if _page.npc ~= nil then

		if _page.npc.id ~= nil then

			if _page.npc.isObserved == true then

				Camera.FollowEntity(_page.npc.id)


				if _page.dialogCamera == true then

					Camera.ZoomSetDistance(DIALOG_ZOOMDISTANCE)
					Camera.ZoomSetAngle(DIALOG_ZOOMANGLE)

				else

					Camera.ZoomSetDistance(BRIEFING_ZOOMDISTANCE)
					Camera.ZoomSetAngle(BRIEFING_ZOOMANGLE)

				end

			end

			EnableNpcMarker(_page.npc.id)

		end

	end

	if _page.follow ~= nil then
		Camera.FollowEntity(_page.follow)

		if not _firstPage then
			Camera.InitCameraFlight()
			Camera.FlyToLookAt(_page.position.X, _page.position.Y, BRIEFING_CAMERA_FLYTIME)
		end
	end

	--	pointer available?

	if _page.pointer ~= nil then

		_page.pointerId = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,_page.pointer.X,_page.pointer.Y,GUI.GetPlayerID())

	end

	--	stop speech
	Stream.Stop()

	-- external function
	if Briefing_Extra ~= nil then
		Briefing_Extra(_page, _firstPage)
	end

	--	title available?

	if _page.title ~= nil then

		local Title = GetBriefingTextFromStringKey(_page.title)

		PrintBriefingHeadline("@color:255,250,200 "..Title)

	end

	--	text available?

	if _page.text ~= nil then

		if type(_page.text) == "table" then

			briefingText = ""

			table.foreach	(
								_page.text,
								function(_,_value)
									local Text = GetBriefingTextFromStringKey(_value)

									briefingText = briefingText..Text.."\n"
								end
							)

			PrintBriefingText(briefingText)
		else

			local Text = GetBriefingTextFromStringKey(_page.text)

			PrintBriefingText(Text)

			--	start speech one tick after displaying text
			Trigger.RequestTrigger(	Events.LOGIC_EVENT_EVERY_TURN,
									nil,
									"StartSpeech_Action",
									1,
									nil,
									{_page.text})

		end

	end

end
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

