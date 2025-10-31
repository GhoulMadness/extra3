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
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
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
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	IncludeLocals("armies")
	LocalMusic.UseSet = MEDITERANEANMUSIC

	TagNachtZyklus(28,0,0,0,1)
	CreateArmies()
	ActivateBriefingsExpansion()
	StartCutscene("Intro", Prolog)

end
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("dario",dario,"Meine Freunde. @cr Wir sollten uns beeilen und weiter nach Osten aufbrechen.", true)
	ASP("dario",dario,"Kafarna scheint uns freundlich gesinnt. @cr Wir sollten dennoch nicht allzu lange hier verweilen...", true)
    ASP("erec",erec,"Ich stimme dir zu, Dario. @cr Lasst uns dennoch nicht unachtsam werden. @cr Wir befinden hier uns hier nicht mehr im alten Reich Kerons. @cr Wer weiß, was uns hier noch erwartet...", true)
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
	local NPCName = "guard1"
	local NPCTitle = gu1
	local NPC = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = NPCName,
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID(NPCName))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt(NPCName,id);LookAt(id,NPCName)
		DisableNpcMarker(GetID(NPCName))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Lasst uns passieren. @cr Wir müssen möglichst schnell weiter gen Osten.", true)
		ASP(NPCName,NPCTitle,"Nicht den Hauch einer Chance, dass sich dieses Tor öffnen wird. @cr Auf Befehl unseres Königs bleibt dieses Tor geschlossen!", false)
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
	local NPCName = "guard2"
	local NPCTitle = gu2
	local NPC = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = NPCName,
	Distance = 300,
	Callback = function()
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
	local posX, posY = Logic.GetEntityPosition(GetID("settler"))
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
	local NPCName = "settler"
	local NPCTitle = set
	local NPC = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = NPCName,
	Distance = 300,
	Callback = function()
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
	local NPCName = "alchemist"
	local NPCTitle = al
	local NPC = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = NPCName,
	Distance = 300,
	Callback = function()
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
end
function DarioMonologue_2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("dario",dario,"Wie kommen wir denn nur an solch große Mengen Schwefel und Kohle? @cr Und das ganz ohne Siedlung...", false)
	ASP("dario",dario,"Vielleicht kann uns ja der Bürgermeister Kafarnas weiterhelfen... @cr Wir sollten ihn schnellstmöglich aufsuchen.", false)
	briefing.finished = function()
		EnableNpcMarker(GetID("major"))
		Major()
	end
	StartBriefing(briefing)
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

end
function Major()
	local NPCName = "major"
	local NPCTitle = mj
	local NPC = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = NPCName,
	Distance = 300,
	Callback = function()
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
			--
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(NPC)
end
function InitAchievementChecks()
	-- TODO: implement this later...
end
--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end