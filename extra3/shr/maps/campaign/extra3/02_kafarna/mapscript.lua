--------------------------------------------------------------------------------
-- MapName: Kafarna
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Kafarna @cr "
gvMapVersion = " v1.00"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
	ForbidTechnology(Technologies.T_MakeSnow,1)
	ForbidTechnology(Technologies.T_MarketSulfur,1)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
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

	Display.SetPlayerColorMapping(6, EVIL_GOVERNOR_COLOR)
	Display.SetPlayerColorMapping(7, NPC_COLOR)
	Display.SetPlayerColorMapping(8, 2)
	--
	SetPlayerName(6, "Nebelvolk")
	SetPlayerName(7, "???")
	SetPlayerName(8, "Kafarna")

end
---------------------------------------------------------------------------------------------
function FarbigeNamen()
	orange 	= " @color:255,127,0 "
	lila 	= " @color:250,0,240 "
	weiss	= " @color:255,255,255 "

  	ment 	= ""..orange.." Mentor "..lila..""
	dario	= ""..orange.." Dario "..lila..""
	erec    = ""..orange.." Erec "..lila..""
	ari		= ""..orange.." Ari "..lila..""
	gu1		= ""..orange.." Mürrischer Torwächter "..lila..""
	gu2		= ""..orange.." Entnervte Torwache "..lila..""
	set 	= ""..orange.." Niedergeschlagener Siedler "..lila..""
	al 		= ""..orange.." Alchemist Kafarnas "..lila..""
	mj		= ""..orange.." Bürgermeister Kafarnas "..lila..""
	gup8_1	= ""..orange.." Andi, Torwächter Kafarnas "..lila..""
	gup8_2	= ""..orange.." Bernd, Torwächter Kafarnas "..lila..""
	gup8_3	= ""..orange.." Detlef, Torwächter Kafarnas "..lila..""
	gup8_4	= ""..orange.." Gert, Torwächter Kafarnas "..lila..""
	gup8_5	= ""..orange.." Henning, Torwächter Kafarnas "..lila..""
	thi 	= ""..orange.." Dietbert, notorischer Herumtreiber "..lila..""
	merch 	= ""..orange.." Arno, Handelsmeister Kafarnas "..lila..""
	sminer 	= ""..orange.." Vorarbeiter des westlichen Bergarbeiterviertels "..lila..""
	afserf 	= ""..orange.." Verängstigter Siedler "..lila..""
	mine 	= ""..orange.." In Vergangenheit schwelgender Bergmann "..lila..""
	herm 	= ""..orange.." Einsiedler "..lila..""
	chi 	= ""..orange.." Obertaktiker Kafarnas "..lila..""
	sc		= ""..orange.." Oberobservierer Kafarnas "..lila..""
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	IncludeLocals("armies")
	LocalMusic.UseSet = MEDITERANEANMUSIC

	Logic.SetCurrentMaxNumWorkersInBuilding(Logic.GetEntityIDByName("kafarnaSM"), 1)

	TagNachtZyklus(28,0,0,0,1)
	CreateArmies()
	ActivateBriefingsExpansion()
	StartCutscene("Intro", Prolog)
	table.insert(ChestRandomPositions.ForbiddenSectors, 34)

	gvKafarnaBuildingDamageTaken = 0
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnKafarnaBuildingDamaged", 1)
end
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("dario",dario,"Meine Freunde. @cr Wir sollten uns beeilen und weiter nach Osten aufbrechen.", true)
	ASP("dario",dario,"Kafarna scheint uns freundlich gesinnt. @cr Wir sollten dennoch nicht allzu lange hier verweilen...", true)
    ASP("erec",erec,"Ich stimme dir zu, Dario. @cr Lasst uns dennoch nicht unachtsam werden. @cr Wir befinden uns hier nicht mehr im alten Reich Kerons. @cr Wer weiß, was uns hier noch erwartet...", true)
	ASP("ari",ari,"Auch hier wird es Ausgestoßene und Vertriebene geben, die ich zur Not zur Unterstützung rufen kann. @cr Aber ich stimme dir zu, Erec. @cr Wir sollten bei all unserer Eile die Vorsichtsmaßnahmen nicht zu kurz kommen lassen. @cr Dario, mein Liebster, du solltest deinen Falken gen Osten schicken und schauen, ob der Weg sicher ist.", true)
	briefing.finished = function()
		Truhen()
		DarioQuest()
		HeroesDeadJob = StartSimpleJob("DefeatJob")
		DefeatCounterID = StartCountdown(2*60, Defeat, true)
		--
		StartSimpleJob("ArrivedAtBridgeCheck")
		InitAchievementChecks()
	end
    StartBriefing(briefing)
end
function Truhen()
	gvTotalChestAmount = 11
	for i = 1, gvTotalChestAmount do
		if math.random(1,3) == 1 then
			CreateRandomGoldChest(GetPosition("chest"..i))
		end
	end
  	CreateChestOpener("dario")
  	CreateChestOpener("erec")
  	CreateChestOpener("ari")
	StartChestQuest()
end
function DefeatJob()
	if IsDead("dario") and IsDead("erec") and IsDead("ari") then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("dario",ment,"Warum habt Ihr Eure Helden nicht beschützt?", false)
		ASP("erec",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
		ASP("ari",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
end
function DarioQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Die Reise nach Osten",
	text	= "Reist möglichst weit in den Osten. @cr Die Stadt Kafarna scheint Euch wohlgesonnen. @cr Ihr sollt dennoch Acht geben, ihr befindet Euch hier nicht mehr im alten Reich Kerons, Sire...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID = quest.id
end
function DarioQuest_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Die Reise nach Osten",
	text	= "Reist möglichst weit in den Osten. @cr Die Stadt Kafarna scheint Euch wohlgesonnen. @cr Ihr sollt dennoch Acht geben, ihr befindet Euch hier nicht mehr im alten Reich Kerons, Sire...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID = quest.id
end
function ArrivedAtBridgeCheck()
	local posX, posY = Logic.GetEntityPosition(GetID("bridge_start_pos"))
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
	if id then
		StopCountdown(DefeatCounterID)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Diese Brücke scheint weiter gen Osten zu führen. @cr Wir sollten sie schnellstmöglich überqueren.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Den Bannern nach endet hier jedoch der Einflussbereich Kafarnas. @cr Wir sollten vorsichtig sein. @cr Wer weiß, wer oder was uns auf der anderen Uferseite erwartet...", true)
		briefing.finished = function()
			Logic.RemoveQuest(1, DarioQID)
			DarioQuest_Finished()
			EnableNpcMarker(GetID("guard1"))
			Guard1()
		end
		StartBriefing(briefing)
		return true
	end
end

function Guard1()
	local NPC = {
		Heroes = true,
		TargetName = "guard1",
		Distance = 300,
		Callback = function()
			local NPCName = "guard1"
			local NPCTitle = gu1
			local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt(NPCName,id);LookAt(id,NPCName)
			DisableNpcMarker(GetID(NPCName))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Lasst uns passieren. @cr Wir müssen möglichst schnell weiter gen Osten.", true)
			ASP(NPCName,gu1,"Nicht den Hauch einer Chance, dass sich dieses Tor öffnen wird. @cr Auf Befehl unseres Königs bleibt dieses Tor geschlossen!", false)
			briefing.finished = function()
				DarioQuest_2()
				--
				EnableNpcMarker(GetID("guard2"))
				Guard2()
			end
			StartBriefing(briefing)
		end
	}
	SetupExpedition(NPC)
end
function DarioQuest_2()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Das verschlossene Tor",
	text	= "Die Reise nach Osten ist durch ein versperrtes Tor blockiert. @cr Dahinter scheint sich eine Euch unbekannte Stadt zu befinden, auf dessen königlichen Erlass das Tor geschlossen bleibt. @cr Ihr müsst einen Weg finden, das Tor passieren zu können!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_2 = quest.id
end
function DarioQuest_2_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Das verschlossene Tor",
	text	= "Die Reise nach Osten ist durch ein versperrtes Tor blockiert. @cr Dahinter scheint sich eine Euch unbekannte Stadt zu befinden, auf dessen königlichen Erlass das Tor geschlossen bleibt. @cr Ihr müsst einen Weg finden, das Tor passieren zu können!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_2 = quest.id
end
function Guard2()
	local NPC = {
		Heroes = true,
		TargetName = "guard2",
		Distance = 300,
		Callback = function()
			local NPCName = "guard2"
			local NPCTitle = gu2
			local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt(NPCName,id);LookAt(id,NPCName)
			DisableNpcMarker(GetID(NPCName))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Lasst uns hindurch. @cr Wir müssen auf dringende Mission weiter gen Osten.", true)
			ASP(NPCName,NPCTitle,"Müssen? @cr Da seid ihr hier falsch! @cr Eher werden hier die Flüsse gefrieren, als dass ich dieses Tor öffnen werde!", false)
			briefing.finished = function()
				StartCountdown(20, DarioMonologue, false)
				DefeatCounterID = StartCountdown(2*60, Defeat, true)
			end
			StartBriefing(briefing)
		end
	}
	SetupExpedition(NPC)
end
function DarioMonologue()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("dario",dario,"Es scheint mir nicht so, als würden uns diese Wachen passieren lassen... @cr Wir müssen wohl einen anderen Weg nach Osten finden. @cr Vielleicht sollten wir einfach dem Flusslauf folgen...", false)
	briefing.finished = function()
		Logic.RemoveQuest(1, DarioQID_2)
		DarioQuest_2_Finished()
		DarioQuest_3()
		StartSimpleJob("StoneBarrierReached")
	end
	StartBriefing(briefing)
end
function DarioQuest_3()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Ein Weg nach Osten",
	text	= "Die Reise nach Osten ist durch ein versperrtes Tor blockiert. @cr Nun gilt es, einen anderen Weg zu finden. @cr Vielleicht kann man ja einfach dem Flusslauf folgen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_3 = quest.id
end
function DarioQuest_3_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Ein Weg nach Osten",
	text	= "Die Reise nach Osten ist durch ein versperrtes Tor blockiert. @cr Nun gilt es, einen anderen Weg zu finden. @cr Vielleicht kann man ja einfach dem Flusslauf folgen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_3 = quest.id
end
function StoneBarrierReached()
	local posX, posY = Logic.GetEntityPosition(GetID("barriers"))
	local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 900, EntityCategories.Hero)
	if id then
		StopCountdown(DefeatCounterID)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ohweh, dieser Weg scheint ebenfalls nicht passierbar...", true)
		ASP("settler",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir sollten den Einsiedler dort hinten bei der Hausruine fragen, ob er uns weiterhelfen kann.", true)
		briefing.finished = function()
			EnableNpcMarker(GetID("settler"))
			Settler()
		end
		StartBriefing(briefing)
		return true
	end
end
function Settler()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "settler",
			Distance = 300,
			Callback = function()
				local NPCName = "settler"
				local NPCTitle = set
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(NPCName,NPCTitle,"Einst hatte ich hier eine prachtvolle Hütte am Hang des Berges. @cr Doch vor einiger Zeit kam es hier zu einem verheerenden Bergrutsch... @cr Ich verlor alles... @cr Mein Haus, mein Leben, einfach alles...", false)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das ist sehr traurig. @cr Doch nun sagt, guter Herr: Gibt es hier einen anderen Weg nach Osten?", true)
				ASP(NPCName,NPCTitle,"Nun, ich fürchte nein. @cr Es gibt hier nur zwei Wege. @cr Diesen Weg, der nun ja leider verschüttet ist und dann noch den Weg über die alte Brücke. @cr Seit sich die beiden Brüder verstritten haben, ist das Tor in die Nachbarstadt jedoch verschlossen...", true)
				briefing.finished = function()
					Logic.RemoveQuest(1, DarioQID_3)
					DarioQuest_3_Finished()
					DarioQuest_4()
					EnableNpcMarker(GetID("alchemist"))
					Alchemist()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("settler"))
	end
end
function DarioQuest_4()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Der versperrte Weg",
	text	= "Der Weg dem Ufer entlang ist durch einen Bergrutsch verschüttet. @cr Ihr solltet einen Weg finden, den Weg wieder frei zu räumen. @cr Vielleicht lässt sich der Weg ja mit etwas Sprengstoff freiräumen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_4 = quest.id
end
function DarioQuest_4_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Der versperrte Weg",
	text	= "Der Weg dem Ufer entlang ist durch einen Bergrutsch verschüttet. @cr Ihr solltet einen Weg finden, den Weg wieder frei zu räumen. @cr Vielleicht lässt sich der Weg ja mit etwas Sprengstoff freiräumen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_4 = quest.id
end
function Alchemist()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "alchemist",
			Distance = 300,
			Callback = function()
				local NPCName = "alchemist"
				local NPCTitle = al
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ihr seht aus wie ein fachkundiger Alchemist. @cr Versteht ihr etwas von Sprengstoff?", true)
				ASP(NPCName,NPCTitle,"Guten Tag, der Herr. @cr Aber natürlich verstehe ich etwas von Sprengstoff. @cr Viele wissen, woraus Sprengstoff besteht, aber nur die wenigsten kennen das Mischungsverhältnis. @cr Und es kommt NUR auf die Mischung an...", true)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Äh ja, so genau wollte ich das gar nicht wissen. @cr Könntet ihr uns dabei helfen, einen verschütteten Weg mithilfe von Sprengstoff wieder frei zu räumen.", true)
				ASP(NPCName,NPCTitle,"Ob ich dazu instande bin? @cr Aber ja doch. Ihr meint sicherlich die massiven Felsblöcke, die beim letzten Erdrutsch bis zum Fluss heruntergepurzelt sind. @cr Für solch massive Felsblöcke benötige ich jedoch große Mengen an Schwefel und Kohle...", true)
				ASP(NPCName,NPCTitle,"Sobald ihr mir die nötigen Ressourcen geschickt habt, kann ich mit der Herstellung des Sprengstoffs beginnen. @cr Und legt noch einige Goldmünzen oben drauf. @cr Auch meine Dienste sind nicht gratis...", true)
				briefing.finished = function()
					StartCountdown(20, DarioMonologue_2, false)
					AlchemistTribute()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("alchemist"))
	end
end
function DarioMonologue_2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("dario",dario,"Wie kommen wir denn nur an solch große Mengen Schwefel und Kohle? @cr Und das ganz ohne Siedlung...", false)
	ASP("dario",dario,"Vielleicht kann uns ja der Bürgermeister Kafarnas weiterhelfen... @cr Wir sollten ihn schnellstmöglich aufsuchen.", false)
	briefing.finished = function()
		EnableNpcMarker(GetID("major"))
		Major()
		EnableNpcMarker(GetID("guardP8_1"))
		EnableNpcMarker(GetID("guardP8_2"))
		EnableNpcMarker(GetID("guardP8_3"))
		EnableNpcMarker(GetID("guardP8_4"))
		GuardP8_1()
		GuardP8_2()
		GuardP8_3()
		GuardP8_4()
		TalkedToGuards = 0
		StartSimpleJob("TalkedToAllGuardsJob")
		DarioQuest_5()
	end
	StartBriefing(briefing)
end
function DarioQuest_5()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Eine Audienz",
	text	= "Ohne eine Siedlung werdet ihr nie an genügend Schwefel und Kohle gelangen... @cr Vielleicht kann Euch der Bürgermeister Kafarnas ja behilflich sein. @cr Ihr solltet ihn aufsuchen und mit ihm sprechen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_5 = quest.id
end
function DarioQuest_5_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Eine Audienz",
	text	= "Ohne eine Siedlung werdet ihr nie an genügend Schwefel und Kohle gelangen... @cr Vielleicht kann Euch der Bürgermeister Kafarnas ja behilflich sein. @cr Ihr solltet ihn aufsuchen und mit ihm sprechen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_5 = quest.id
end
function AlchemistTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Gebt dem Alchemisten " .. 5000 + round(3000/gvDiffLVL) .. " Schwefel und " .. 4000 + round(6000/gvDiffLVL) .. " Kohle, damit dieser damit Sprengstoff herstellen kann.";
	tribute.cost = {Sulfur = 5000 + round(3000/gvDiffLVL), Knowledge = 4000 + round(6000/gvDiffLVL)}
	tribute.Callback = AlchemistTributePayed
	AlchemistTributeTID = AddTribute( tribute )
end
function AlchemistTributePayed()
	local NPCName = "alchemist"
	local NPCTitle = al
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Ah, sehr gut, ihr konntet die benötigten Ressourcen auftreiben.", false)
	ASP(NPCName, NPCTitle,"Ich werde nun mit der Herstellung des Sprengstoffs beginnen. @cr Sobald ich fertig bin, werde ich mich auf den Weg machen und den Sprengsatz anbringen.", false)
	briefing.finished = function()
		StartCountdown(2*60, ExplosivesReady, false)
	end
	StartBriefing(briefing)
end
function ExplosivesReady()
	Move("alchemist", "barriers")
	StartSimpleJob("alchemist_reached_barrier")
end
function alchemist_reached_barrier()
	if IsNear("alchemist", "barriers", 300) then
		local posX, posY = Logic.GetEntityPosition(GetID("barriers"))
		Camera.ScrollSetLookAt(posX, posY)
		local effectPosT = {
			{X = 22733.74, Y = 23188.11},
			{X = 23154.75, Y = 23234.92},
			{X = 23123.65, Y = 22749.44},
			{X = 23541.90, Y = 22411.97},
			{X = 22373.12, Y = 23449.32},
			{X = 22159.10, Y = 23639.11}
		}
		for i = 1, table.getn(effectPosT) do
			Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, effectPosT[i].X, effectPosT[i].Y)
			Logic.CreateEffect(GGL_Effects.FXCrushBuildingLarge, effectPosT[i].X, effectPosT[i].Y)
		end
		StartCountdown(1, RemoveBarrierEntities, false)
		return true
	else
		if Logic.GetCurrentTaskList(GetID("alchemist")) == "TL_NPC_IDLE"
		or Counter.Tick2("alchemist_stuck_again", 10) then
			Move("alchemist", "barriers")
		end
	end
end
function RemoveBarrierEntities()
	local posX, posY = Logic.GetEntityPosition(GetID("barriers"))
	local etypes = {Entities.XD_RockKhakiMedium5, Entities.XD_RockMedium5, Entities.XD_RockMedium6, Entities.XD_RockMedium7, Entities.XD_RockDestroyableMedium1, Entities.XD_RockDestroyableMediterranean, Entities.XD_LargeCampFire, Entities.XD_RuinResidence2}
	for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(posX, posY, 1200), CEntityIterator.OfAnyTypeFilter(unpack(etypes))) do
		local X, Y = Logic.GetEntityPosition(eID)
		Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, X, Y)
		DestroyEntity(eID)
	end
	Logic.RemoveQuest(1, DarioQID_4)
	DarioQuest_4_Finished()
	SadSettlerBrief()
end
function SadSettlerBrief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("settler",set,"WAS TUT IHR WAHNSINNIGER DENN DA???", false)
	ASP("settler",set,"Meine Hütte... @cr Meine schöne Hütte... @cr Und mich habt ihr auch fast erwischt...", false)
	ASP("dario",dario,"Schöne Hütte? @cr Das war doch nur noch eine Ruine...", false)
	ASP("settler",set,"Das war mein Lebenswerk... @cr Und ihr habt es einfach so von dieser Erde getilgt... @cr So ein Herrscher seid ihr also... @cr Ich hatte Euch wohl falsch eingeschätzt...", false)
	briefing.finished = function()
		SadSettlerQuest()
		SadSettlerTerrPointer = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, 22255.33, 23635.84)
		StartSimpleJob("SadSettlerResidenceDoneJob")
	end
	StartBriefing(briefing)
end
function SadSettlerQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Die Felsen sind weg. Die Hütte auch...",
	text	= "Die an den Felsen der Wegsperre angebrachten Sprengladungen waren wohl etwas zu stark. @cr Der Weg ist zwar nun frei, jedoch haben die Sprengladungen die bereits baufällige Hütte des Siedlers gänzlich dem Erdboden gleich gemacht. @cr Ihr solltet für ihn ein neues, prunkvolles großes Wohnhaus errichten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SadSettlerQID = quest.id
end
function SadSettlerQuest_Closed()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Die Felsen sind weg. Die Hütte auch...",
	text	= "Die an den Felsen der Wegsperre angebrachten Sprengladungen waren wohl etwas zu stark. @cr Der Weg ist zwar nun frei, jedoch haben die Sprengladungen die bereits baufällige Hütte des Siedlers gänzlich dem Erdboden gleich gemacht. @cr Ihr solltet für ihn ein neues, prunkvolles großes Wohnhaus errichten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SadSettlerQID = quest.id
end
function SadSettlerResidenceDoneJob()
	local posX, posY = 22255.33, 23635.84
	for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(posX, posY, 1000), CEntityIterator.OfPlayerFilter(1), CEntityIterator.OfTypeFilter(Entities.PB_Residence3)) do
		ChangePlayer(eID, 8)
		Logic.DestroyEffect(SadSettlerTerrPointer)
		Logic.RemoveQuest(1, SadSettlerQID)
		SadSettlerQuest_Closed()
		SadSettlerBrief_2()
		return true
	end
end
function SadSettlerBrief_2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("settler",set,"Ihr habt mir eine neue Hütte errichtet. @cr Und was für eine schöne, prächtige Hütte. @cr Habt vielen, vielen Dank.", false)
	ASP("dario",dario,"... @cr Nun, meine Freunde. @cr Wir sind hier fertig. @cr Wir sollten schnellstmöglich dem Pfad am Fluss folgen.", false)
	briefing.finished = function()
		DarioQuest_6()
		StartSimpleJob("ReachedVictoryPos")
	end
	StartBriefing(briefing)
end
function DarioQuest_6()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Der Pfad ist nun frei",
	text	= "Der Weg dem Ufer entlang ist nun endlich wieder passierbar. @cr Ihr solltet Euch schnellstmöglich auf den Weg begeben.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_6 = quest.id
end
function DarioQuest_6_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Der Pfad ist nun frei",
	text	= "Der Weg dem Ufer entlang ist nun endlich wieder passierbar. @cr Ihr solltet Euch schnellstmöglich auf den Weg begeben.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID_6 = quest.id
end
function ReachedVictoryPos()
	if IsNear("dario", "endpos", 1000)
	or IsNear("ari", "endpos", 1000)
	or IsNear("erec", "endpos", 1000) then
		EndReached = true
		local x, y = Logic.GetEntityPosition(GetID("endpos"))
		TeleportSettler(GetID("erec"), x - 200, y)
		TeleportSettler(GetID("dario"), x, y)
		TeleportSettler(GetID("ari"), x + 200, y)
		Move("erec", "endErec")
		Move("dario", "endDario")
		Move("ari", "endAri")
		Logic.RemoveQuest(1, DarioQID_6)
		DarioQuest_6_Finished()
		StartCutscene("Outro", Victory)
		return true
	end
end
function GuardP8_1()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_1",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_1"
				local NPCTitle = gup8_1
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = NPCTitle,
					text = "Heh, ihr da. @cr Seht ihr nicht, dass das Tor geschlossen ist? @cr Hier ist für Euch kein Durchkommen!",
					position = GetPosition(NPCName),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(100, 22, 1700)
					end
				}
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir müssen schnell zu eurem Bürgermeister. @cr So lasst uns doch passieren!", true)
				ASP(NPCName,NPCTitle,"Auf Befehl des Königs bleibt das Tor geschlossen!", true)
				briefing.finished = function()
					TalkedToGuards = TalkedToGuards + 1
					SetCameraDefaultParams()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_1"))
	end
end
function GuardP8_2()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_2",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_2"
				local NPCTitle = gup8_2
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
					text = "Lasst uns durch. @cr Wir haben Wichtiges mit eurem Bürgermeister zu besprechen.",
					position = GetPosition(id),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(135, 25, 1200)
					end
				}
				ASP(NPCName,NPCTitle,"Der König hat strikt verordnet, dass die Tore zur oberen Ebene Kafarnas bis auf wenige Ausnahmen geschlossen bleiben! Und ihr steht hier nicht auf der Liste. @cr Eher friert die Hölle zu, als dass ich Euch hier passiere lasse!", true)
				briefing.finished = function()
					TalkedToGuards = TalkedToGuards + 1
					SetCameraDefaultParams()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_2"))
	end
end
function GuardP8_3()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_3",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_3"
				local NPCTitle = gup8_3
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = NPCTitle,
					text = "Heh, ihr da? @cr Was habt ihr hier zu suchen? @cr Seht ihr nicht, dass das Tor geschlossen ist?",
					position = GetPosition(NPCName),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(105, 22, 1700)
					end
				}
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Warum das denn? @cr So macht uns auf die Tore! @cr Wir haben mit eurem Bürgermeister zu sprechen.", true)
				ASP(NPCName,NPCTitle,"Auf königlichen Erlass sollen wir hier niemanden durchlassen, der keinen Passierschein hat. @cr Und ich riskiere doch nicht, dass man mich einen Kopf kürzer macht...", true)
				briefing.finished = function()
					TalkedToGuards = TalkedToGuards + 1
					SetCameraDefaultParams()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_3"))
	end
end
function GuardP8_4()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_4",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_4"
				local NPCTitle = gup8_4
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
					text = "Das Tor. So macht es schon auf. @cr Wir sind auf wichtiger Mission unterwegs!",
					position = GetPosition(id),
					dialogCamera = true,
					action = function()
					end
				}
				ASP(NPCName,NPCTitle,"Auf wichtiger Mission? @cr Pah, wir brauchen hier keine Missionare. Die Zeiten sind längst vorbei. @cr Ihr bleibt draußen!", true)
				briefing.finished = function()
					TalkedToGuards = TalkedToGuards + 1
					SetCameraDefaultParams()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_4"))
	end
end
function TalkedToAllGuardsJob()
	if TalkedToGuards >= 4 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("dario",dario,"Hmm, die Torwächter werden uns wohl nicht so einfach passieren lassen. @cr Vielleicht sollten wir uns zunächst diesen Passierschein besorgen, von dem die eine Wache gesprochen hatte. @cr Aber wie gelangen wir an so einen Passierschein?", false)
		ASP("ari",ari,"Hier wird es doch sicherlich die ein oder andere zwielichtige Gestalt geben, die uns so einen Schein gegen ein paar Taler fälschen kann.", false)
		briefing.finished = function()
			EnableNpcMarker(GetID("thief"))
			Thief()
			GuardsQuest()
		end
		StartBriefing(briefing)
		return true
	end
end
function GuardsQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Verschlossene Tore",
	text	= "Sämtliche Tore zur oberen Ebene Kafarnas sind geschlossen. @cr Die Wachen lassen Euch nicht hindurch, solange ihr keinen Passierschein vorzeigen könnt. @cr So wird das nichts mit der Audienz mit dem Bürgermeister Larinas. @cr Vielleicht gibt es ja abseits der üblichen Pfade einen Weg, an den benötigten Passierschein zu gelangen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	GuardsQID = quest.id
end
function GuardsQuest_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_CLOSED,
	title	= "Verschlossene Tore",
	text	= "Sämtliche Tore zur oberen Ebene Kafarnas sind geschlossen. @cr Die Wachen lassen Euch nicht hindurch, solange ihr keinen Passierschein vorzeigen könnt. @cr So wird das nichts mit der Audienz mit dem Bürgermeister Larinas. @cr Vielleicht gibt es ja abseits der üblichen Pfade einen Weg, an den benötigten Passierschein zu gelangen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	GuardsQID = quest.id
end
function Thief()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "thief",
			Distance = 300,
			Callback = function()
				local NPCName = "thief"
				local NPCTitle = thi
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ihr seht doch aus wie jemand, der für einen kleinen Obelus ein paar zwielichtige Geschäfte für uns erledigt.", true)
				ASP(NPCName,NPCTitle,"Ich bin ganz Ohr. @cr Um welche Geschäfte mag es sich da handeln?", true)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Könnt ihr uns einen Passierschein für die obere Ebene Kafarnas besorgen?", true)
				ASP(NPCName,NPCTitle,"Oh, da möchte jemand noch weit hinaus. @cr Aber nichts leichter als das. @cr Das wird Euch aber einiges kosten!", true)
				briefing.finished = function()
					ThiefTribute()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("thief"))
	end
end
function ThiefTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt der zwielichtigen Gestalt " .. 800 .. " Taler, damit dieser Euch einen gefälschten Passierschein für die obere Ebene Kafarnas ausstellt.";
	tribute.cost = {Gold = 800}
	tribute.Callback = ThiefTributePayed
	ThiefTributeTID = AddTribute( tribute )
end
function ThiefTributePayed()
	local NPCName = "thief"
	local NPCTitle = thi
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Ah, sehr gut, die Moneten sind durchgesickert.", false)
	ASP(NPCName, NPCTitle,"Hier ist Euer Passierschein. Schön mit Euch Geschäfte zu machen. @cr Aber ihr habt den Schein nicht von mir!", false)
	briefing.finished = function()
		EnableNpcMarker(GetID("guardP8_3"))
		GuardP8_3_2()
		Logic.RemoveQuest(1, GuardsQID)
		GuardsQuest_Finished()
	end
	StartBriefing(briefing)
end
function GuardP8_3_2()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_3",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_3"
				local NPCTitle = gup8_3
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = NPCTitle,
					text = "Was wollt ihr denn schon wieder hier? @cr Ich sagte Euch doch bereits, dass hier niemand ohne Passierschein hindurch darf!",
					position = GetPosition(NPCName),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(105, 22, 1700)
					end
				}
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun, wie der Zufall so will haben wir aber einen Passierschein. @cr Hier bitte. Und nun lasst uns durch!", true)
				ASP(NPCName,NPCTitle,"<<Schaut sich den Passierschein an, berät sich kurz mit seinem Kollegen und kommt dann nach einer Weile wieder zurück>> @cr ... Ihr dürft passieren, Sire. @cr Aber zeigt den Schein beim nächsten Mal am besten direkt vor!", true)
				briefing.finished = function()
					ReplaceEntity("gateP8_3", Entities.XD_WallStraightGate)
					SetCameraDefaultParams()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_3"))
	end
end
function Major()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "major",
			Distance = 300,
			Callback = function()
				local NPCName = "major"
				local NPCTitle = mj
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = NPCTitle,
					text = "Fremde hier, in dieser Gegend? @cr Nun, das sieht man auch nicht alle Tage. @cr In den Straßen erzählt man sich so einige Gerüchte über euch...",
					position = GetPosition(NPCName),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(20, 29, 2900)
					end
				}
				ASP(NPCName,NPCTitle,"Nun, sind diese Gerüchte übertrieben? @cr Man erzählt sich, ihr stammt aus einem fernen Königreich im Westen. @cr Und, dass ihr die Räuberbanden vor unserer Stadt aufgerieben und verschleppte Bürger heimgebracht habt.", true)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun, was man sich über uns erzählt - das entspricht der Wahrheit. @cr Wir sind ein wenig in Eile und müssen so schnell es möglich ist nach Osten vorstoßen. @cr Doch die Nachbarstadt lässt uns nicht passieren und der Pfad entlang des Flusses ist verschüttet...", true)
				ASP(NPCName,NPCTitle,"Nach Osten? @cr Nachbarstadt? @cr Nun, da habt ihr kein leichtes Unterfangen vor euch.", true)
				ASP("p7_view",NPCTitle,"Die Nachbarstadt im Osten, Lesthortho, hat ihre westlichen Tore gänzlich verriegelt. @cr Einst lebten wir in Harmonie. @cr Wir, die Handelsstadt und das Tor nach Westen und Lesthortho, das Juwel des alten Königreichs.", false)
				ASP(NPCName,NPCTitle,"Doch dann starb unser allseits beliebter und weiser König. @cr Vier seiner Söhne waren berüchtigt dafür, enorm machthungrig zu sein. @cr Daher überließ der König das Reich seinem jünsten Sohn, Theredhal.", true)
				ASP(NPCName,NPCTitle,"Ihr könnt euch sicherlich denken, was dann geschah...", true)
				ASP(NPCName,NPCTitle,"Die vier verschmähten Söhne schmiedeten einen Komplett und ließen den jungen König ermorden. @cr Auf das darauf hervorgehende Machtvakuum war niemand vorbereitet...", true)
				ASP(NPCName,NPCTitle,"Die Prinzen wollten allesamt Alleinherrscher über das Reich werden. @cr Ein Krieg war unausweichlich. @cr Doch keiner der vier Prinzen ging siegreich hervor.", true)
				ASP(NPCName,NPCTitle,"Und nun liegt das Reich in Scherben... @cr Jeder der vier Söhne nennt sich selbst König und wahrt seinen eigenen Einflussbereich.", true)
				ASP(NPCName,NPCTitle,"Thorodin, der jüngste der Könige, floh in die Berge des Nordens. @cr Niemand weiß, wo genau er sich aufhält, da er sich seit einigen Mordversuchen versteckt hält. @cr Er soll jedoch aus dem Untergrund große Macht ausüben, seit also vorsichtig, wenn ihr gen Norden reist.", true)
				ASP(NPCName,NPCTitle,"Der zweitjüngste - Khanghir - ist unser König. @cr Er hat die Stadt wacker gegen Leartes, den König Lesthorthos, verteidigt. @cr Wir können wohl froh sein, denn Leartes hat es wohl aufgegeben und die Angriffe auf unsere Siedlung gehören bereits der Vergangenheit an.", true)
				ASP(NPCName,NPCTitle,"Der älteste der Könige - Fhafnir - hat seine Einflusssphäre ganz im Osten des alten Reiches. @cr Er soll derjenige sein, der den Mord auf den jungen König geplant hatte. @cr Er ist wohl der machthungrigste und erbarmungsloseste der vier Könige.", true)
				ASP(NPCName,NPCTitle,"Gerüchten zufolge versammelt er im Osten eine gewaltige Armee aus Söldnern, um die alte Hauptstadt - Lesthortho - zu belagern.", true)
				ASP(NPCName,NPCTitle,"Nun, das ist jetzt aber genug in Geschichtskunde dieses Landes. @cr Ihr seid doch bestimmt aus einem Grund zu mir persönlich gekommen...", true)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Natürlich. @cr Um den verschütteten Pfad nahe des Flusses freizusprengen, benötigen wir große Mengen an Schwefel und Kohle. @cr Ihr könnt euch aber sicherlich denken, dass wir diese Ressourcen auf unserer Reise nicht mit uns herumschleppen. @cr Könnt ihr uns da ein wenig unterstützen?", true)
				ASP(NPCName,NPCTitle,"Ressourcen kann ich euch keine einfach so zur Verfügung stellen. @cr Allerdings sind die Gerüchte, dass ihr Dörfler befreit habt, bis zu unserem König getragen wurden.", true)
				ASP("HQP1",NPCTitle,"Als Belohnung für eure Taten stellt er euch einen alten Außenposten in den Bergen zur Verfügung. @cr Ihr könnt dort eure Siedlung aufschlagen. @cr Doch bedenkt, dass die Ressourcen der Gegend karg sind.", false)
				briefing.finished = function()
					SetCameraDefaultParams()
					ChangePlayer("HQP1", 1)
					ChangePlayer("VCP1", 1)
					EnableNpcMarker(GetID("hermit"))
					Hermit()
					EnableNpcMarker(GetID("miner"))
					Miner()
					EnableNpcMarker(GetID("afraid_serf"))
					AfraidSerf()
					EnableNpcMarker(GetID("merchant"))
					Merchant()
					EnableNpcMarker(GetID("guardP8_5"))
					GuardP8_5()
					EnableNpcMarker(GetID("stone_miner"))
					StoneMiner()
					Logic.RemoveQuest(1, DarioQID_5)
					DarioQuest_5_Finished()
					--
					AI.Village_SetSerfLimit(8,8)
					--
					SetPlayerName(7, "Lesthortho")
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("major"))
	end
end
function GuardP8_5()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "guardP8_5",
			Distance = 300,
			Callback = function()
				local NPCName = "guardP8_5"
				local NPCTitle = gup8_5
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Heh, ihr da! @cr Öffnet das Tor! @cr Uns wurde der alte Bergfried oben in den Bergen überlassen. Lasst unsere Siedler passieren.", true)
				ASP(NPCName,NPCTitle,"So lauten nicht meine Befehle vom König. @cr Davon steht hier zumindest nichts. @cr Für ein paar Talerchen hingegen...", true)
				briefing.finished = function()
					GuardTribute()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("guardP8_5"))
	end
end
function GuardTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt der Torwache " .. 500 .. " Taler, damit diese Euch das Tor zu Euren Besitztümern in den Bergen öffnet.";
	tribute.cost = {Gold = 500}
	tribute.Callback = GuardTributePayed
	GuardTributeTID = AddTribute( tribute )
end
function GuardTributePayed()
	local NPCName = "guardP8_5"
	local NPCTitle = gup8_5
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Ah, sehr gut, da sind ja meine Talerchen.", false)
	ASP(NPCName, NPCTitle,"Ah ja, hier auf dem Zettel steht doch sogar, dass ich das Tor zum nördlichen Außenposten in den Bergen öffnen soll. @cr Wie dumm von mir. Ich komme dem sofort nach!", false)
	briefing.finished = function()
		ReplaceEntity("gate1", Entities.XD_WallStraightGate)
	end
	StartBriefing(briefing)
end
function Hermit()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "hermit",
			Distance = 300,
			Callback = function()
				local NPCName = "hermit"
				local NPCTitle = herm
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefingData = {}
				if GDB.GetValue("myths\\journeysulfurstored") > 0 then
					briefingData[1] = {pos = NPCName, name = NPCTitle, text = "Ah, ihr seid es wieder. @cr Ich habe Euren Schwefel trocken eingelagert.", dialogCamera = true}
					briefingData[2] = {pos = id, name = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Sehr gut. @cr Nun brauchen wir den Schwefel tatsächlich, um einen alten Steinschlag freizulegen. @cr Könnt ihr uns den Schwefel aushändigen, weiser Mann?", dialogCamera = true}
					briefingData[3] = {pos = NPCName, name = NPCTitle, text = "Natürlich. @cr Der weise Mann scheint ihr zu sein. @cr Es war klug, sich auf spätere Engpässe vorzubereiten.", dialogCamera = true}
				else
					briefingData[1] = {pos = id, name = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Sagt, weiser Mann: Könnt ihr uns bei unserem Schwefelproblem helfen? @cr Ihr habt doch sicherlich Weisheiten kundzutun.", dialogCamera = true}
					briefingData[2] = {pos = NPCName, name = NPCTitle, text = "Nun, zaubern kann ich nicht. @cr Wärt ihr klug gewesen, hättet ihr bereits früher Schwefel angehortet. @cr Nun kann ich Euch auch nicht mehr helfen...", dialogCamera = true}
					briefingData[3] = {pos = NPCName, name = NPCTitle, text = "Ich fürchte, ihr habt den weiten Weg umsonst auf Euch genommen.", dialogCamera = true}
				end
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				for i = 1, table.getn(briefingData) do
					ASP(briefingData[i].pos, briefingData[i].name, briefingData[i].text, briefingData[i].dialogCamera)
				end
				briefing.finished = function()
					if GDB.GetValue("myths\\journeysulfurstored") > 0 then
						AddSulfur(1, GDB.GetValue("myths\\journeysulfurstored"))
					end
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("hermit"))
	end
end
function Miner()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "miner",
			Distance = 300,
			Callback = function()
				local NPCName = "miner"
				local NPCTitle = mine
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(NPCName,NPCTitle,"Einst führte hier ein schmaler Wanderpfad tiefer durch die Berge bis hin zum großen Strom, der das östliche vom westlichen Gefilde trennt.", true)
				ASP(NPCName,NPCTitle,"Einige Händler ließen dort sogar ihre Karren nach Larina langfahren, als das Gebiet im Nordwesten zeitweise von Räubern heimgesucht wurde.", true)
				ASP("ev_spawn1",NPCTitle,"Seit das Nebelvolk sich in den Bergen breit gemacht hat, ist dieser Pfad jedoch sehr gefährlich geworden.", false)
				ASP(NPCName,NPCTitle,"Ich habe sicherheitshalber diese Barrikade aus verdorrten Bäumen errichtet, damit die nicht noch auf den Gedanken kommen, meine Hütte hier einzureißen.", false)
				briefing.finished = function()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("miner"))
	end
end
function AfraidSerf()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "afraid_serf",
			Distance = 300,
			Callback = function()
				local NPCName = "afraid_serf"
				local NPCTitle = afserf
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(NPCName,NPCTitle,"W..W..Wilde. @cr Eine ganze Horde von denen...", true)
				ASP("view1",NPCTitle,"Geht hier vorne bloß nicht weiter. @cr Ich konnte meine Haut grade noch retten. @cr Mein Kollege hatte weniger Glück...", false)
				ASP("ev_spawn9",NPCTitle,"Ich fürchte, der ist mittlerweile einem ihrer Rituale zum Opfer gefallen.", false)
				briefing.finished = function()
					Tools.ExploreArea(3700, 18500, 10)
					StartCountdown(20*60, KafarnaChiefPrep, false)
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("afraid_serf"))
	end
end
function KafarnaChiefPrep()
	if not KafarnaHostile then
		EnableNpcMarker(GetID("chief"))
		Chief()
	end
end
function Chief()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "chief",
			Distance = 300,
			Callback = function()
				local NPCName = "chief"
				local NPCTitle = chi
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ihr seht aus wie der Anführer dieser Truppe. @cr Könnt ihr mir erzählen, wieso hier eine ganze Armee versammelt ist, während sich vor den Toren das Nebelvolk tümmelt? @cr Wieso räuchert ihr die Wilden nicht aus?", true)
				ASP(NPCName,NPCTitle,"Wenn das doch so einfach wäre... @cr Unser letzter Angriff schlug kläglich fehl, wir hatten viele Verluste zu beklagen...", true)
				ASP("ev_tower6",NPCTitle,"Diese Behausungen der Wilden sich einfach zu mächtig, unsere Schwerter, Speere, Pfeile und Kugeln sind dagegen machtlos @cr Ohne Kanonenfeuer haben wir keine Chance.", false)
				ASP(NPCName,NPCTitle,"Ich opfere meine Männer nicht, einen sinnlosen Tod zu sterben. @cr Vernichtet für uns mindestens drei ihrer Behausungen und wir reden weiter. @cr Zeigt uns Eure Macht und wir können gemeinsam vorrücken!", true)
				briefing.finished = function()
					ChiefQuest()
					EvilCampsDestroyed = 0
					EvilCampsToDestroy = 3
					ActivateEvilCampsQuestGUI()
					Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "EvilCampsDestroyedJob", 1)
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("chief"))
	end
end
function ChiefQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Feuerkraft!",
	text	= "Ihr wundert Euch, wieso die mächtige Armee Kafarnas nicht in die Offensive gegen das Nebelvolk geht, ja sich kaum ihrer Überfälle erwehrt. @cr " ..
		"Der Kommandant erzählte Euch von großen Verlusten, die seinen Mannen durch übermächtige Behausungen beigebracht wurden. @cr Der Schlüssel in der Zerschlagung des Nebelvolks liegt in der Vernichtung eben dieser Behausungen. @cr" ..
		"Bringt die Feuerkraft auf und vernichtet mindestens drei der Behausungen des Nebelvolks. @cr Sobald diese Tat vollbracht ist, wird Kafarna Euch im Kampf gegen das Nebelvolk unterstützen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	ChiefQID = quest.id
end
function ChiefQuest_Finished()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_CLOSED,
	title	= "Feuerkraft!",
	text	= "Ihr wundert Euch, wieso die mächtige Armee Kafarnas nicht in die Offensive gegen das Nebelvolk geht, ja sich kaum ihrer Überfälle erwehrt. @cr " ..
		"Der Kommandant erzählte Euch von großen Verlusten, die seinen Mannen durch übermächtige Behausungen beigebracht wurden. @cr Der Schlüssel in der Zerschlagung des Nebelvolks liegt in der Vernichtung eben dieser Behausungen. @cr" ..
		"Bringt die Feuerkraft auf und vernichtet mindestens drei der Behausungen des Nebelvolks. @cr Sobald diese Tat vollbracht ist, wird Kafarna Euch im Kampf gegen das Nebelvolk unterstützen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	ChiefQID = quest.id
end
function ActivateEvilCampsQuestGUI()
	if EvilCampsDestroyed < EvilCampsToDestroy then
		GUIQuestTools.StartQuestInformation("Nephtower", "", 1, 1)
		GUIQuestTools.UpdateQuestInformationString(EvilCampsDestroyed .. "/" .. EvilCampsToDestroy)
		GUIQuestTools.UpdateQuestInformationTooltip = function()
			XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Vernichtete Wohnstätten")
		end
	end
end
function EvilCampsDestroyedJob()
	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)
	if entityType == Entities.CB_Evil_Tower1 then
		EvilCampsDestroyed = EvilCampsDestroyed + 1
		GUIQuestTools.UpdateQuestInformationString(EvilCampsDestroyed .. "/" .. EvilCampsToDestroy)
		if EvilCampsDestroyed >= EvilCampsToDestroy and not KafarnaHostile then
			local NPCName = "chief"
			local NPCTitle = chi
			local briefing = {}
			local AP, ASP = AddPages(briefing);
			ASP(NPCName,NPCTitle,"Hervorragende Leistung. @cr Meine Männer werden sofort aufbrechen, um Euch im Kampf zur Seite zu stehen!", true)
			briefing.finished = function()
				GUIQuestTools.DisableQuestInformation()
				Logic.RemoveQuest(1, ChiefQID)
				ChiefQuest_Finished()
				ActivateShareExploration(1, 8, true)
				SetFriendly(1,8)
				MapEditor_Armies[8].offensiveArmies.rodeLength = Logic.WorldGetSize()
			end
			StartBriefing(briefing)
			return true
		end
	end
end
function Merchant()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "merchant",
			Distance = 300,
			Callback = function()
				local NPCName = "merchant"
				local NPCTitle = merch
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				AP{
					title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
					text = "Wir sind auf der Suche nach größeren Mengen Schwefel. @cr Ihr habt nicht zufällig Schwefel in eurem Angebot?",
					position = GetPosition(id),
					dialogCamera = true,
					action = function()
						CustomizeBriefingParams(100, 29, 2900)
					end
				}
				ASP(NPCName,NPCTitle,"Schwefel? @cr Nun, viel bekommen wir hier leider nicht herein. @cr Das Schwefelbergwerk Kafarnas wurde in letzter Zeit des Häufigeren überfallen oder gar vernichtet.", true)
				ASP("ev_spawn5",NPCTitle,"Ein Großteil des abgebauten Schwefels wird direkt in Maßnahmen gegen das erstarkende Nebelvolk investiert. @cr Ich fürchte, ich werde Euch keinen guten Preis machen können...", false)
				briefing.finished = function()
					SetCameraDefaultParams()
					MerchantTribute1()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("merchant"))
	end
end
function MerchantTribute1()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Kauft " .. round(600*gvDiffLVL) .. " Schwefel für 2500 Taler.";
	tribute.cost = {Gold = 2500}
	tribute.Callback = MerchantTribute1Payed
	MerchantTribute1TID = AddTribute( tribute )
end
function MerchantTribute1Payed()
	local NPCName = "merchant"
	local NPCTitle = merch
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Habt Dank. @cr Hier ist Euer Schwefel. @cr Ich fürchte aber, dass ich die Preise weiter anziehen muss. @cr Die letzte Schwefellieferung fiel äußerst dürftig aus.", false)
	briefing.finished = function()
		AddSulfur(1, round(600*gvDiffLVL))
		MerchantTribute2()
	end
	StartBriefing(briefing)
end
function MerchantTribute2()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Kauft " .. round(400*gvDiffLVL) .. " Schwefel für 3500 Taler.";
	tribute.cost = {Gold = 3500}
	tribute.Callback = MerchantTribute2Payed
	MerchantTribute2TID = AddTribute( tribute )
end
function MerchantTribute2Payed()
	local NPCName = "merchant"
	local NPCTitle = merch
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Habt Dank. @cr Hier ist Euer Schwefel. @cr Viel mehr Schwefel habe ich leider nicht. Die letzte Schwefellieferung ist schon etwas länger her...", false)
	briefing.finished = function()
		AddSulfur(1, round(400*gvDiffLVL))
		MerchantTribute3()
	end
	StartBriefing(briefing)
end
function MerchantTribute3()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Kauft " .. round(300*gvDiffLVL) .. " Schwefel für 5000 Taler.";
	tribute.cost = {Gold = 5000}
	tribute.Callback = MerchantTribute3Payed
	MerchantTribute3TID = AddTribute( tribute )
end
function MerchantTribute3Payed()
	local NPCName = "merchant"
	local NPCTitle = merch
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Habt Dank. @cr Hier ist Euer Schwefel. @cr Über weiteren Schwefel verfüge ich nun leider nicht mehr.", false)
	briefing.finished = function()
		AddSulfur(1, round(300*gvDiffLVL))
	end
	StartBriefing(briefing)
end
function StoneMiner()
	if not KafarnaHostile then
		local NPC = {
			Heroes = true,
			TargetName = "stone_miner",
			Distance = 300,
			Callback = function()
				local NPCName = "stone_miner"
				local NPCTitle = sminer
				local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
				local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
				LookAt(NPCName,id);LookAt(id,NPCName)
				DisableNpcMarker(GetID(NPCName))
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP(NPCName,NPCTitle,"Auf der Suche nach Steinen? @cr Ich bin hier der Vorarbeiter des Steinbergwerkviertels und mache Euch gute Preise. Die besten Steine weit und breit.", true)
				ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun, ich werde darüber nachdenken.", true)
				briefing.finished = function()
					StoneMinerTribute()
				end
				StartBriefing(briefing)
			end
		}
		SetupExpedition(NPC)
	else
		DisableNpcMarker(GetID("stone_miner"))
	end
end
function StoneMinerTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Kauft " .. 800 + round(200*gvDiffLVL) .. " Steine für 800 Taler.";
	tribute.cost = {Gold = 800}
	tribute.Callback = StoneMinerTributePayed
	StoneMinerTributeTID = AddTribute( tribute )
end
function StoneMinerTributePayed()
	local NPCName = "stone_miner"
	local NPCTitle = sminer
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Hier sind Eure versprochen Steine. @cr Handelt jederzeit erneut mit uns, wir haben noch genügend erstklassige Steine auf Lager.", false)
	briefing.finished = function()
		AddStone(1, 800 + round(200*gvDiffLVL))
		StoneMinerTribute()
	end
	StartBriefing(briefing)
end
function OnKafarnaBuildingDamaged()
	local attacker = Event.GetEntityID1()
	local target = Event.GetEntityID2()
	if GetPlayer(attacker) == 6 and GetPlayer(target) == 8 and Logic.IsBuilding(target) then
		gvKafarnaBuildingDamageTaken = gvKafarnaBuildingDamageTaken + CEntity.TriggerGetDamage()
		if gvKafarnaBuildingDamageTaken >= 500 then
			KafarnaObserverBrief()
			return true
		end
	end
end
function KafarnaObserverBrief()
	local NPCName = "scout"
	local NPCTitle = sc
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Heh, was treibt ihr da? @cr Das hab ich genau gesehen. @cr Ihr habt das Nebelvolk vorsätzlich in unsere Siedlung gelockt.", false)
	ASP("chief", NPCTitle,"Ich werde das meinem Kommandanten melden müssen. @cr Dem wird das so gar nicht gefallen.", false)
	ASP(NPCName, NPCTitle,"Ihr solltet sofort damit aufhören!", false)
	briefing.finished = function()
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnKafarnaBuildingDamagedAgain", 1)
		SetHealth("kafarnaVC", 100)
		SetHealth("kafarnaSM", 100)
		SetHealth("kafarnaIM", 100)
	end
	StartBriefing(briefing)
end
function OnKafarnaBuildingDamagedAgain()
	local attacker = Event.GetEntityID1()
	local target = Event.GetEntityID2()
	if GetPlayer(attacker) == 6 and GetPlayer(target) == 8 and Logic.IsBuilding(target) then
		gvKafarnaBuildingDamageTaken = gvKafarnaBuildingDamageTaken + CEntity.TriggerGetDamage()
		if gvKafarnaBuildingDamageTaken >= 1000 then
			KafarnaObserverBrief2()
			return true
		end
	end
end
function KafarnaObserverBrief2()
	local NPCName = "scout"
	local NPCTitle = sc
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(NPCName, NPCTitle,"Ihr habt es erneut getan! @cr Ihr seid ein dreckiger Verräter. @cr Das wird euch teuer zu stehen kommen!", false)
	ASP("chief", chi,"Männer, zu den Waffen! @cr Wir haben einen neuen Feind. @cr Zeigt keine Gnade. @cr Das sind ein paar ganz üble Verräter, dessen Namen von dieser Erde getilgt gehören!", false)
	briefing.finished = function()
		SetHostile(1,8)
		SetNeutral(6,8)
		MapEditor_Armies[8].offensiveArmies.strength = MapEditor_Armies[8].offensiveArmies.strength + 5
		MapEditor_Armies[8].offensiveArmies.rodeLength = Logic.WorldGetSize()
		KafarnaHostile = true
		ResearchTroopUpgrades(8, true, true, true, true)
		MakeInvulnerable("kafarnaBarracks")
		MakeInvulnerable("kafarnaArchery")
		MakeInvulnerable("kafarnaVC")
		MakeInvulnerable("kafarnaSM")
		SetHealth("kafarnaVC", 100)
		SetHealth("kafarnaSM", 100)
		Logic.RemoveTribute(1,StoneMinerTributeTID)
		Logic.RemoveTribute(1,MerchantTribute1TID)
		Logic.RemoveTribute(1,MerchantTribute2TID)
		Logic.RemoveTribute(1,MerchantTribute3TID)
		Logic.RemoveTribute(1,GuardTributeTID)
		Logic.RemoveTribute(1,ThiefTributeTID)
		Logic.RemoveTribute(1,AlchemistTributeTID)
		--
		Logic.SetShareExplorationWithPlayerFlag(1, 8, 0)
		--
		DisableNpcMarker(GetID("stone_miner"))
		DisableNpcMarker(GetID("guardP8_1"))
		DisableNpcMarker(GetID("guardP8_2"))
		DisableNpcMarker(GetID("guardP8_3"))
		DisableNpcMarker(GetID("guardP8_4"))
		DisableNpcMarker(GetID("guardP8_5"))
		DisableNpcMarker(GetID("settler"))
		DisableNpcMarker(GetID("alchemist"))
		DisableNpcMarker(GetID("thief"))
		DisableNpcMarker(GetID("miner"))
		DisableNpcMarker(GetID("major"))
		DisableNpcMarker(GetID("merchant"))
		DisableNpcMarker(GetID("chief"))
		DisableNpcMarker(GetID("afraid_serf"))
		DisableNpcMarker(GetID("hermit"))
	end
	StartBriefing(briefing)
end
function InitAchievementChecks()
	StartSimpleJob("CheckForNoKills")
	StartSimpleJob("CheckForBloodbath")
	StartSimpleJob("CheckForFastFinish")
end
function CheckForNoKills()
	if EndReached and Score.Player[1].battle == 0 then
		Message("Ihr habt die Karte absolviert, ohne einem einzelnen Feind ein Haar zu krümmen oder ein einzelnes Gebäude zu zerstören. Herzlichen Glückwunsch! Ihr habt eine Errungenschaft freigeschaltet!")
		GDB.SetValue("achievements\\kafarnanobattle", 1)
		return true
	end
end
function CheckForBloodbath()
	if EndReached and Score.Player[6].battle >= 5000 then
		Message("Ihr habt das Nebelvolk ein wahres Blutbad anrichten lassen. Ihr seid wahrlich grausam! Ihr habt eine Errungenschaft freigeschaltet!")
		GDB.SetValue("achievements\\kafarnaevilbloodbath", 1)
		return true
	end
end
function CheckForFastFinish()
	if EndReached and Logic.GetTime() <= 3600 then
		Message("Ihr habt die Mission in weniger als einer Stunde abgeschlossen. Herzlichen Glückwunsch! Ihr habt eine Errungenschaft freigeschaltet!")
		GDB.SetValue("achievements\\kafarnafastvictory", 1)
		return true
	end
end
--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end
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