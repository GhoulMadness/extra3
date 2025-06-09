--------------------------------------------------------------------------------
-- MapName: Aufbruch ins Ungewisse
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Aufbruch ins Ungewisse @cr "
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
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	--SetupNormalWeatherGfxSet()
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

	Display.SetPlayerColorMapping(3,2)
	Display.SetPlayerColorMapping(2,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(7,NPC_COLOR)
	Display.SetPlayerColorMapping(8,NPC_COLOR)
	--
	SetPlayerName(2, "Steppenräuber")
	SetPlayerName(3, "???")
	SetPlayerName(7, "Nomaden")
	SetPlayerName(8, "Larina")

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
	wan 	= ""..orange.." Einstiger Brückenwärter "..lila..""
	mjP8 	= ""..orange.." Bürgermeister von Larina "..lila..""
	weir	= ""..orange.." Toller des Wüstensands "..lila..""
	herm  	= ""..orange.." Einsiedler "..lila..""
	gu1     = ""..orange.." Mürrischer Torwächter Kafarnas"..lila..""
	gu2		= ""..orange.." Träger Torwächter Kafarnas"..lila..""
	myn     = ""..orange.." Rätselmeister Mhüs - Thikk "..lila..""
	hwa		= ""..orange.." Eremit "..lila..""
	tra		= ""..orange.." Einstmaliger Handelsvorsitzender von Larina "..lila..""
	p3tr	= ""..orange.." Verschleppter Händler Kafarnas "..lila..""
	p3al	= ""..orange.." Verschleppter Alchemist Kafarnas "..lila..""
	p3se	= ""..orange.." verschleppter Siedler Kafarnas "..lila..""
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	IncludeLocals("armies")
	LocalMusic.UseSet = MEDITERANEANMUSIC

	CreateArmies()
	ActivateBriefingsExpansion()
	StartCutscene("Intro", Prolog)
end
function Prolog()
	TagNachtZyklus(32,0,0,0,1)
end
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("dario",dario,"Meine Freunde. @cr Wir sollten schnellstens weiter nach Osten vorstoßen, um den in der Prophezeiung erwähnten Weisen aufzufinden.", true)
    ASP("erec",erec,"Wir sollten aber Vorsicht walten lassen. @cr Jenseits des großen Stroms endet das alte Reich Kerons. @cr Wir hatten schon lange keinen Kontakt mehr zu ihnen, ja wissen nicht einmal den Namen des Reiches.", true)
	ASP("dario",dario,"Das spielt nun keine Rolle mehr. @cr Wir müssen einfach weiter nach Osten. @cr Die Bewohner unseres Reiches zählen auf uns.", true)
	ASP("ari",ari,"Eile hin oder her, Dario. @cr Das Risiko ist einfach zu groß, dass wir Räuberbanden zum Opfer fallen. @cr Hier in der Nähe soll sich die letzte Handelsbastion unseres Reiches befinden. @cr Wir sollten uns dort zunächst mit Vorräten eindecken.", true)
	ASP("dario",dario,"Nein Ari, die Überquerung des großen Stroms hat oberste Priorität. @cr Wir können uns auch im fremden benachbarten Reich eindecken. @cr Und nun los meine Freunde, wir haben schon genug Zeit verloren.", true)
	briefing.finished = function()
		DarioQuest()
		AriQuest()
		Logic.SetGlobalInvulnerability(1)
		StartSimpleJob("CheckForRobbersSpotted")
		HeroesDeadJob = StartSimpleJob("DefeatJob")
		--
		InitAchievementChecks()
	end
    StartBriefing(briefing)
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
	text	= "Reist möglichst weit in den Osten. @cr Überquert hierzu zunächst den großen Strom. @cr Achtet auf etwaige Räuberbanden.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarioQID = quest.id
end
function AriQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Der Handelsposten",
	text	= "Findet den Handelsposten. @cr Er ist die letzte Siedlung des alten Reiches und befindet sich diesseits des großen Stroms. @cr Ihr könnt euch dort sicherlich mit Vorräten eindecken.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	AriQID = quest.id
end
function CheckForRobbersSpotted()
	local cond = false
	for i = 1, 5 do
		local posX, posY = Logic.GetEntityPosition(GetID("enemiesSpotted" .. i))
		if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2200, 1) > 0 then
			cond = true
			break
		end
	end
	if cond then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("LarinaView",ment,"Herr seht doch. @cr Der alte Handelsposten wird überfallen. @cr Ihr solltet die Stadt vor der Vernichtung bewahren.", false)
		ASP("dario",dario,"Wir sollten keine Zeit verlieren und zunächst diese Räuber vertreiben. @cr Wir können nicht zulassen, dass unser Volk noch mehr Leid erfährt.", true)
		briefing.finished = function()
			Logic.SetGlobalInvulnerability(0)
			Logic.RemoveQuest(1, AriQID)
			FreeLarinaQuest()
			StartSimpleJob("LarinaFreedJob")
		end
		StartBriefing(briefing)
		return true
	end
end
function FreeLarinaQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Befreit den Handelsposten",
	text	= "Der Handelsposten wird von Räubern überfallen. @cr Schützt die Bewohner und vernichtet alle Angreifer!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	FreeLarinaQID = quest.id
end
function LarinaFreedJob()
	local freed = true
	for i = 1, table.getn(LarinaAttackArmyIDs) do
		local army = ArmyTable[2][LarinaAttackArmyIDs[i] + 1]
		if not IsDead(army) then
			freed = false
			break
		end
	end
	if freed then
		local posX, posY = Logic.GetEntityPosition(GetID("LarinaMjPos"))
		local id = Logic.CreateEntity(Entities.CU_Major01Idle, posX, posY, 180, 8)
		Logic.SetEntityName(id, "MajorP8")
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("LarinaView",ment,"Hervorragend, mein Herr. @cr Ihr konntet die Räuber zurückschlagen. @cr Doch seht Euch nur die Stadt an. @cr Alles zerstört...", false)
		ASP("MajorP8",ment,"Jetzt, da es wieder sicher ist, hat der Bürgermeister und Schultheiß wieder seine sichere Burg verlassen. @cr Ihr solltet mit ihm reden und das weitere Vorgehen besprechen.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1, FreeLarinaQID)
			LarinaMjVisitQuest()
			EnableNpcMarker(id)
			LarinaMajor()
		end
		StartBriefing(briefing)
		return true
	end
end
function LarinaMjVisitQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Der Bürgermeister des Handelspostens",
	text	= "Findet den Bürgermeister des Handelspostens und redet mit ihm. @cr Er wird Euch sicherlich mehr zur gegenwärtigen Lage erzählen können.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	LarinaMjVisitQID = quest.id
end
function LarinaMajor()
	local BeiLM = {
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
		ASP("MajorP8",mjP8,"Oh, danke Herr, dass ihr uns gerettet habt. @cr Ich hatte schon keine Hoffnung mehr. @cr Willkommen in der einstmals schönen Handelsstadt Larina.", true)
		ASP("LarinaView",mjP8,"Es passiert nicht alle Tage, dass wir hier hochrangigen Besuch erhalten. @cr Was treibt Euch in diese abgelegene Gegend?", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Eine Prophezeiung erzählte von einem Weisen weit im Osten, der von einem jungen, aufstrebenden König aufgesucht wird, um das Leid im Reich zu beenden.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun und daher reisen wir gen Osten. @cr Wir hatten nicht vor, einen Abstecher in Eure Stadt zu machen, aber dann sahen wir die Rauschschwaden und hörten den Tumult.", true)
		ASP("MajorP8",mjP8,"Habt Dank, dass ihr nicht einfach weitergereist seid. @cr Nun, so leid mir das auch tut, das zu erwähnen, aber ihr wärt auch nicht weit gekommen.", true)
		ASP("yeoldbridge",mjP8,"Die Brücke, die weiter nach Osten führt, ist schon seit längerer Zeit unpassierbar. @cr Entsprechend sind auch unsere Handelsbeziehungen mit dem Reich im Osten seit Längerem unterbrochen.", false)
		ASP("MajorP8",mjP8,"Den letzten Kontakt mit dem damaligen Königreich im Osten - Ragalia - hatte mein Urgroßvater. @cr Nun, wir wissen entsprechend nicht mehr über unsere Nachbarn als ihr. @cr Ihr solltet auf der Hut sein, wenn ihr weiter nach Osten reist.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nun darüber gilt es später, den Kopf zu zerbrechen. @cr Viel wichtiger ist, dass wir die andere Flussseite überhaupt erreichen. @cr Habt ihr da eine Idee?", true)
		ASP("MajorP8",mjP8,"Nun, die alte Brücke sieht sehr baufällig aus. Es ist zweifelhaft, ob man sie überhaupt noch reparieren kann. @cr Nahe der Brücke soll hin und wieder der Nachfahre des einstigen Brückenwärters gesehen worden sein. Vielleicht kann er euch ja weiterhelfen...", true)
		ASP("MajorP8",mjP8,"Vielleicht kommt ja auch der Winter. @cr Aber da würde ich mich nicht drauf verlassen, frostige Temperaturen hatten wir hier schon lange nicht mehr.", true)
		ASP("MajorP8",mjP8,"In jedem Falle werdet ihr für Euer Unterfangen Ressourcen benötigen. @cr Ressourcen, die wir hier nicht haben...", true)
		ASP("IronPitView",mjP8,"Und die wenigen Rohstoffschächte in der Gegend liegen allesamt im Einzugsgebiet der Räuber. @cr Ihr werdet also zunächst Handel mit den Städten im Westen treiben müssen. @cr Und das wird sogleich teuer als auch gefährlich, da die Räuber auch diese Route regelmäßig überfallen...", false)
		ASP("BanditSpawn2",mjP8,"Ihr seht schon. @cr Es läuft alles darauf hinaus, dass diese Räuber vernichtet werden müssen. @cr Erst, wenn Euch dies gelungen ist, könnt Ihr Euch Gedanken machen, weiter gen Osten reisen zu können.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1, LarinaMjVisitQID)
			RobbersQuest1()
			StartSimpleJob("RobbersDefeatedJob1")
			ActivateShareExploration(1, 8, true)
			StartCutscene("Larina", LarinaDiscovered)
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiLM)
end
function RobbersQuest1()
	RemainingRobberCamps = 3
	ActivateRobbersQuestGUI()
	table.insert(gvFuncsToBeReloadedOnMapLoad, {fname = ActivateRobbersQuestGUI, params = {}})
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Nieder mit den Räubern",
	text	= "Vernichtet die drei Räuberlager diesseits des großen Stroms. @cr Gebt Acht, sowohl die Rohstoffschächte als auch die Handelswege werden von den Räubern kontrolliert. @cr @cr Vielleicht kann Euch ja jemand Abhilfe verschaffen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Rob1QID = quest.id
end
function ActivateRobbersQuestGUI()
	if RemainingRobberCamps > 0 then
		GUIQuestTools.StartQuestInformation("Attack", "", 1, 1)
		GUIQuestTools.UpdateQuestInformationString(RemainingRobberCamps .. "/" .. table.getn(RobbersQuestArmyIDs[1]) )
		GUIQuestTools.UpdateQuestInformationTooltip = function()
			XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Verbleibende Räuberlager")
		end
	end
end
function RobbersDefeatedJob1()
	RemainingRobberCamps = 0
	local done = true
	for i = 1, table.getn(RobbersQuestArmyIDs[1]) do
		local army = ArmyTable[2][RobbersQuestArmyIDs[1][i] + 1]
		if not IsDead(army) or not IsDestroyed(army.building) then
			RemainingRobberCamps = RemainingRobberCamps + 1
			done = false
		end
	end
	GUIQuestTools.UpdateQuestInformationString(RemainingRobberCamps .. "/" .. table.getn(RobbersQuestArmyIDs[1]) )
	if done then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("IronPitView",ment,"Gut gemacht, die Räuber wurden vertrieben. @cr Nun solltet ihr die Rohstoffschächte in Besitz nehmen.", false)
		briefing.finished = function()
			GUIQuestTools.DisableQuestInformation()
			Logic.RemoveQuest(1, Rob1QID)
			MinesQuest()
			StartSimpleJob("MinesBuiltJob")
		end
		StartBriefing(briefing)
		return true
	end
end
function MinesQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Die Rohstoffschächte",
	text	= "Nun, da die Räuber fort sind, könnt ihr die Rohstoffschächte in Besitz nehmen. @cr Errichtet einen Eisenstollen, einen Steinstollen sowie einen Schwefelstollen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	MinesQID = quest.id
end
function MinesBuiltJob()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_IronMine2) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_StoneMine2) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_SulfurMine2) >= 1 then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("IronPitView",ment,"Sehr gut Sire. @cr Ihr solltet nun gewappnet sein, den Fluss zu überqueren.", false)
		ASP("wanderer",ment,"Sprecht mit dem Nachfahren des Brückenwärters, sobald ihr bereit seid, in das Nachbarkönigreich des Ostens aufzubrechen.", false)
		briefing.finished = function()
			EnableNpcMarker(GetID("wanderer"))
			WandererBrief()
		end
		StartBriefing(briefing)
		return true
	end
end
function WandererBrief()
	local BeiWan = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "wanderer",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("wanderer"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("wanderer",id);LookAt(id,"wanderer")
		DisableNpcMarker(GetEntityId("wanderer"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich hörte, ihr seid der Nachfahre des einstigen Brückenwärters. @cr Könnt ihr uns sagen, wie wir auf die andere Flussseite gelangen?", true)
		ASP("wanderer", wan, "Nun, zumindest nicht mehr über diese Brücke. @cr Die ist gänzlich unpassierbar.", true)
		ASP("yeoldbridge", wan, "Man müsste zunächst hier und da den Schutt wegräumen, bevor man die Brücke restaurieren könnte. @cr Und selbst dann ist zweifelhaft, ob die Brücke überhaupt restauriert werden könnte.", false)
		ASP("wanderer", wan, "Ich würde es erst gar nicht versuchen und alle Reste der alten Brücke wegsprengen. @cr Dann könnte man ein gänzlich neues Brückenfundament errichten. @cr Das ist zwar teurer, sollte aber funktionieren.", true)
		briefing.finished = function()
			BridgeRestoreQuest()
			BridgeDestroyTribute()
			EnableNpcMarker(GetID("Weirdo"))
			Myst_NPC1()
			StartSimpleJob("ArrivedAtOtherKingdownJob")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiWan)
end
function BridgeRestoreQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Die alte Brücke",
	text	= "Findet einen Weg, die alte Brücke wieder passierbar zu machen. @cr Es liegt an Euch, ob ihr die Brücke restaurieren wollt (wenn es denn möglich ist) oder ihr sämtliche Reste der alten Brücke mit Sprengstoff beseitigt und ein neues Fundament errichtet.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BridgeRestoreQID = quest.id
end
function BridgeDestroyTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. 7500 - round(500*gvDiffLVL) .. " Schwefel und " .. 3000 - round(500*gvDiffLVL) .. " Kohle, um sämtliche Reste der alten Brücke mit Sprengstoff zu beseitigen.";
	tribute.cost = {Sulfur = 7500 - round(500*gvDiffLVL), Knowledge = 3000 - round(500*gvDiffLVL)};
	tribute.Callback = BridgeDestroyTributePayed
	BridgeDestroyTributeTID = AddTribute( tribute )
end
function BridgeDestroyTributePayed()
	BridgeRemoveEtypes = {Entities.XD_RuinHouse1, Entities.XD_RuinHouse2, Entities.XD_RuinResidence1, Entities.XD_RuinResidence2, Entities.XD_LargeCampFire,
		Entities.XD_GeyserEvelance1, Entities.XD_RuinSmallTower1, Entities.XD_RuinSmallTower2, Entities.XD_RuinWall1, Entities.XD_RuinTower2,
		Entities.XD_RuinFragment1, Entities.XD_RuinFragment2, Entities.XD_RuinFragment3, Entities.XD_RuinFragment4, Entities.XD_RuinFragment5,
		Entities.XD_RuinFragment6, Entities.XD_Rock6, Entities.XD_Rock7, Entities.XD_Willow1, Entities.XD_AppleTree2, Entities.XD_Stone1, Entities.XD_WoodenFence02
	}
	local posX, posY = Logic.GetEntityPosition(GetID("yeoldbridge"))
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(unpack(BridgeRemoveEtypes)), CEntityIterator.InCircleFilter(posX, posY, 2300)) do
		local X,Y = Logic.GetEntityPosition(eID)
		Logic.CreateEffect(GGL_Effects.FXExplosion, X, Y)
		StartCountdown(1, function() Logic.DestroyEntity(eID) end, false)
	end
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("wanderer", wan, "Oh, ihr habt die alte Brücke fast restlos vernichtet. @cr Nun bleibt nur noch Staub und Schutt von einem einstmalig so bemerkenswertem Bauwerk...", true)
	ASP("yeoldbridge", wan, "Nun ja, mit ein wenig Holz und Lehm und ein paar Steinen könnte man dort bestimmt wieder eine neue, bemerkenswerte Brücke errichten.", false)
	briefing.finished = function()
		Logic.RemoveQuest(1, BridgeRestoreQID)
		NewBridgeQuest()
		StartSimpleJob("CheckForMasterBuilderNearBridge")
	end
	StartBriefing(briefing)
end
function NewBridgeQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Ein neues Fundament muss her",
	text	= "Nun, da die alte Brücke Geschichte ist, bleibt Euch nichts anderes übrig, als viele Ressourcen in den Bau eines neuen Brückenfundaments zu investieren. @cr Errichtet hierzu nahe der alten Brücke eine Architektenstube. @cr Schaut anschließend in Euer Tributmenü.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BridgeRestoreQID = quest.id
end
function CheckForMasterBuilderNearBridge()
	local posX, posY = Logic.GetEntityPosition(GetID("wanderer"))
	if Logic.GetEntitiesInArea(Entities.PB_MasterBuilderWorkshop, posX, posY, 2500, 1) > 0 then
		NewBridgeTribute()
		return true
	end
end
function NewBridgeTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Euer Brückenarchitekt hat die Kosten für die Errichtung eines neuen Brückenfundaments überschlagen." ..
		" @cr Gebt dem Brückenarchitekten " .. 6000 - round(1000*gvDiffLVL) .. " Holz und Steine und " .. 9000 - round(1000*gvDiffLVL) .. " Lehm, damit er ein neues Brückenfundament errichten kann.";
	tribute.cost = {Sulfur = 7500 - round(500*gvDiffLVL), Knowledge = 3000 - round(500*gvDiffLVL)};
	tribute.Callback = NewBridgeTributePayed
	NewBridgeTributeTID = AddTribute( tribute )
end
function NewBridgeTributePayed()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("wanderer", ment, "Hervorragend. @cr Die Ressourcen für die Errichtung eines neuen Brückenfundaments sind beim Brückenarchitekten angekommen. @cr Wir sollten ihm nun für die Errichtung etwas Zeit geben.", false)
	briefing.finished = function()
		Logic.RemoveQuest(1, BridgeRestoreQID)
		StartCountdown((5-gvDiffLVL)*60, NewBridgeFund, true)
	end
	StartBriefing(briefing)
end
function NewBridgeFund()
	local posX, posY = 20913.80, 25422.80
	Logic.SetTerrainNodeHeight(round(posX/100), round(posY/100), 580)
	Logic.CreateEntity(Entities.XD_NeutralBridge3, posX, posY, 0, 0)
	StartSimpleJob("NewBridgeBuilt")
end
function NewBridgeBuilt()
	if Logic.GetNumberOfEntitiesOfType(Entities.PB_Bridge3) > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("yeoldbridge", ment, "Sehr gut. @cr Der Bau der neuen Brücke wurde in Auftrag gegeben. @cr Ihr solltet nun schleunigst weiter nach Osten aufbrechen. @cr Doch gebt Acht: Das Land jenseits dieses Flusses gehört bereits zu einem fremden Königreich.", false)
		briefing.finished = function()
		end
		StartBriefing(briefing)
		return true
	end
end
function LarinaDiscovered()
	StartCountdown((2+math.random(1,4)/gvDiffLVL)*60, LarinaMajorBrief2, false)
end
function LarinaMajorBrief2()
	EnableNpcMarker(GetID("MajorP8"))
	local BeiLM = {
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
		ASP("MajorP8",mjP8,"Und, wie schlagt ihr Euch? @cr Ohne Siedlung und Nachschub ist das vermutlich schwierig oder?", true)
		ASP("MajorP8",mjP8,"Ich ziehe mich wieder in die Burg zurück und überlasse Euch natürlich die Kontrolle über Larina. @cr Ein paar Ressourcen haben die Räuber auch noch da gelassen...", false)
		briefing.finished = function()
			DestroyEntity("MajorP8")
			LarinaToPlayer()
			local posX, posY = 10300, 14900
			local id = Logic.CreateEntity(Entities.CU_Trader, posX, posY, 240, 8)
			Logic.SetEntityName(id, "TraderP8")
			EnableNpcMarker(id)
			TraderBrief()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiLM)
end
function LarinaToPlayer()
	Logic.ChangeAllEntitiesPlayerID(8, 1)
	local baseamount = 200+round(200*gvDiffLVL + (500 - (Logic.GetTime()/2)))
	AddGold(baseamount)
	AddWood(round(baseamount * 0.75))
	AddClay(round(baseamount * 0.85))
	AddStone(round(baseamount * 0.80))
	AddIron(round(baseamount * 0.20))
	--
	EndJob(HeroesDeadJob)
	--
	LarinaFreed = true
end
function TraderBrief()
	local BeiTr = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "TraderP8",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("TraderP8"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("TraderP8",id);LookAt(id,"TraderP8")
		DisableNpcMarker(GetEntityId("TraderP8"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("TraderP8",tra,"Ah, ihr seht so aus, als würdet ihr unserer Stadt wieder zu einstmaliger Blüte verhelfen.", true)
		ASP("path_to_west",tra,"Ich werde den umliegenden Städten im Westen Bescheid geben, dass unser Räuberproblem gelöst und unsere Handelswege wieder sicher sind.", false)
		ASP("BanditSpawn2",tra,"Ihr kümmert Euch doch sicherlich in der Zwischenzeit um die Räuber und sorgt dafür, dass die Wege auch wirklich sicher sind...", false)
		briefing.finished = function()
			local posX, posY = Logic.GetEntityPosition(GetID("LarinaMjPos"))
			local id = Logic.CreateEntity(Entities.PU_Scout, posX, posY, 180, 8)
			Logic.SetEntityName(id, "ScoutP8")
			Move(id, "path_to_west")
			StartSimpleJob("ScoutArrivedJob")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiTr)
end
function ScoutArrivedJob()
	if IsNear("ScoutP8", "path_to_west", 300) then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("path_to_west",tra,"Der Gesandte hat den Pfad nach Westen erreicht. @cr Er wird sich nun auf die weite Reise nach Westen begeben.", false)
		ASP("TraderP8",tra,"Schon bald werden hier wieder Karavanen eintreffen. @cr Beschützt sie gut!", true)
		briefing.finished = function()
			StartCountdown((10 + math.random(0, round(6 - gvDiffLVL))) * 60, CaravanStart, false)
		end
		StartBriefing(briefing)
		return true
	end
end
function CaravanStart()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("path_to_west",tra,"Hervorragend. @cr Der Gesandte hatte Erfolg und die ersten Karavanen sind eingetroffen. @cr Bitte sorgt dafür, dass sie auf ihrem Weg hierher nicht überfallen werden.", false)
	briefing.finished = function()
		caravan_step = 0
		SpawnCaravans()
	end
	StartBriefing(briefing)
end
CaravanPossibleResourceTypes = {
	ResourceType.Gold,
	ResourceType.Clay,
	ResourceType.Wood,
	ResourceType.Stone,
	ResourceType.Iron,
	ResourceType.Sulfur,
	ResourceType.Knowledge
}
function SpawnCaravans()
	caravan_step = caravan_step + 1
	if caravan_step <= round(2.5*gvDiffLVL) then
		local questcaravan = {
		Unit = "caravan_" .. caravan_step,
		Waypoint = {
			 {Name = "path_to_west", 	WaitTime = round(6/gvDiffLVL)},
			 {Name = "caravan_step1", 	WaitTime = round(10/gvDiffLVL)},
			 {Name = "caravan_step2",	WaitTime = round(10/gvDiffLVL)},
			 {Name = "caravan_step3",	WaitTime = round(6/gvDiffLVL)},
			 {Name = "caravan_step4",	WaitTime = round(6/gvDiffLVL)},
			 {Name = "LarinaMjPos",		WaitTime = round(10/gvDiffLVL)}
		},
		Remove = true,
		Callback = function(_Quest)
			if _Quest.ArrivedCount >= _Quest.NumCaravan then
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP("TraderP8",tra,"Alle Karavanen sind unbeschadet angekommen. @cr Sehr gute Arbeit.", false)
				briefing.finished = function()
					StartCountdown((10 + math.random(0, round(6 - gvDiffLVL))) * 60, SpawnCaravans, false)
				end;
				StartBriefing(briefing);
			else
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP("TraderP8",tra,"Ohweh, einige der Karavanen wurden abgefangen. @cr Das wird sich bestimmt herumsprechen. Ihr werdet die Karavanen beim nächsten mal besser schützen müssen.", false)
				briefing.finished = function()
					StartCountdown(round((10 + math.random(0, round(6 - gvDiffLVL))) * 60 * 2), SpawnCaravans, false)
				end;
				StartBriefing(briefing);
			end
		end,
		ArrivedCount = 0,
		NumCaravan = round(2*gvDiffLVL),
		ArrivedCallback = function(_Quest)
			Logic.AddToPlayersGlobalResource(1, CaravanPossibleResourceTypes[math.random(1, table.getn(CaravanPossibleResourceTypes))], round(math.random(5, 30) * 10 * gvDiffLVL))
		end}
		SetupCaravan(questcaravan)
		--
		StartCountdown(25, CreateCaravanArmy, false, nil, caravan_step)
		if caravan_step == round(2.5*gvDiffLVL) then
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("TraderP8",tra,"Das waren erst einmal alle Karavanen. @cr Weitere werden uns wohl nicht in absehbarer Zeit erreichen.", false)
			briefing.finished = function()
			end;
			StartBriefing(briefing);
		end

	end
end
function KafarnaDiscovered()
	SetPlayerName(3, "Kafarna")
end
function Myst_NPC1()
	local BeiMyst = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Weirdo",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Weirdo"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Weirdo",id);LookAt(id,"Weirdo")
		DisableNpcMarker(GetEntityId("Weirdo"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Weirdo",weir,"Ah, neue Herausforderer... @cr Hereinspaziert, hereinspaziert.", false)
		ASP("Weirdo",weir,"Löst meine Rätsel und es soll Euer Schaden nicht sein.", true)
		briefing.finished = function()
			QuestRiddle1()
			SetEntityVisibility(GetID("Weirdo"), 0)
			StartSimpleJob("ControlRiddle1Job")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMyst)
end
function QuestRiddle1()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Das erste Rätsel",
	text	= "Der Tolle des Wüstensands gab Euch eine Schriftrolle mit, damit ihr das aufgetragene Rätsel nicht wieder vergesst. @cr @cr Zu Ersuchen ihr mich müsst mit Dreien. @cr Befinden vor der Hütt im Freien. @cr Formend, denn imitierend einer lunarischen Sichel. @cr Royal gen Nordwest, ärmlich doch beherzt gen West, kühn gen Süd.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Riddle1QID = quest.id
end
function ControlRiddle1Job()
	if IsNighttime() then
		if IsNear("dario", "waypoint1", 500) and IsNear("ari", "waypoint2") and IsNear("erec", "waypoint3") then
			SetEntityVisibility(GetID("Weirdo"), 1)
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Weirdo",weir,"Oh, ihr habt das Rätsel gelöst. @cr Ich bin beeindruckt.", false)
			ASP("Weirdo",weir,"Nun, das nächste Rätsel wird nicht so leicht werden...", true)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das nächste Rätsel? @cr Wie viele Rätsel werden es denn, bevor ihr uns weiterhelft? @cr Ohje, und ich dachte, wir wären hier schnell fertig...", true)
			briefing.finished = function()
				Logic.RemoveQuest(1, Riddle1QID)
				QuestRiddle2()
				SetEntityVisibility(GetID("Weirdo"), 0)
				StartSimpleHiResJob("ControlRiddle2Job")
			end;
			StartBriefing(briefing)
			return true
		end
	end
end
function QuestRiddle2()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Ein weiteres Rätsel...",
	text	= "Der Tolle des Wüstensands gab Euch erneut eine Schriftrolle mit, damit ihr das aufgetragene Rätsel nicht wieder vergesst." ..
		" @cr @cr Diesmal nicht vor der Hütt. @cr Ein Gefährt, es war einst so lütt. @cr Nun so riesig und doch am falschen Ort, @cr mit tosendem Donner bringt es hinfort. @cr Ich warte auf Euch dort.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Riddle2QID = quest.id
end
function ControlRiddle2Job()
	if GetCurrentWeatherGfxSet() == 11 then
		archMoveSteps = archMoveSteps or 0
		local posX, posY = 17000, 32000
		local posX2, posY2 = 19000, 29000
		local dX, dY = (posX2 - posX) / 100, (posY2 - posY) / 100
		posX, posY = posX + (dX * archMoveSteps), posY + (dY * archMoveSteps)
		IDs = IDs or {}
		if table.getn(IDs) == 0 then
			for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(posX, posY, 1000), CEntityIterator.OfPlayerFilter(0)) do
				table.insert(IDs, eID)
			end
		end
		newIDs = {}
		for i = 1, table.getn(IDs) do
			local etype = Logic.GetEntityType(IDs[i])
			local rot = Logic.GetEntityOrientation(IDs[i])
			local X, Y = Logic.GetEntityPosition(IDs[i])
			local size = GetEntitySize(IDs[i])
			DestroyEntity(IDs[i])
			local id = Logic.CreateEntity(etype, X + dX, Y + dY, rot, 0)
			SetEntitySize(id, size)
			table.insert(newIDs, id)
		end
		IDs = newIDs
		archMoveSteps = archMoveSteps + 1
		if archMoveSteps >= 100 then
			DestroyEntity("Weirdo")
			local id = Logic.CreateEntity(Entities.CU_Thief, 18600, 28900, 150, 7)
			Riddle2DoneBrief()
			EnableNpcMarker(id)
			--
			archMoveSteps = nil
			posX, posY = nil, nil
			IDs = nil
			return true
		end
	end
end
function Riddle2DoneBrief()
	local BeiMyst = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Weirdo",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Weirdo"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Weirdo",id);LookAt(id,"Weirdo")
		DisableNpcMarker(GetEntityId("Weirdo"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Weirdo",weir,"Ihr habt auch dieses Rätsel erfolgreich absolviert. @cr Herzlichen Glückwunsch.", false)
		ASP("Weirdo",weir,"Als Belohnung übergebe ich Euch die Weisheit, den Winter kommen zu lassen. @cr Besucht auch meinen Meister auf der anderen Flussseite. @cr Er wird sich irgendwo verstecken und hat sicherlich ebenfalls das ein oder andere Rätsel für Euch parat.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1, Riddle2QID)
			AllowTechnology(Technologies.T_MakeSnow)
			DestroyEntity("Weirdo")
			WesternRiddlesSolved = true
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMyst)
end

function ArrivedAtOtherKingdownJob()
	local posX, posY = Logic.GetEntityPosition(GetID("eastern_side"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 1200, 1) > 0 then
		StartCutscene("EasternSide", ArrivedAtOtherKingdownBrief)
		return true
	end
end
function ArrivedAtOtherKingdownBrief()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("eastern_side",ment,"Die Helden hatten es tatsächlich geschafft. @cr Die andere Flussseite und damit auch das benachbarte Königreich waren erreicht.", false)
	ASP("BanditSpawn5",ment,"Doch auch wenn das Reich fremd ist... @cr Auch hier treiben Räuber ihr Unwesen. @cr Ihr werdet Euch zunächst um dieses Problem kümmern müssen, bevor ihr weiterreisen könnt...", false)
	briefing.finished = function()
		EnableNpcMarker(GetID("guard1"))
		EnableNpcMarker(GetID("hiddenwanderer"))
		Guard1()
		HiddenWanderer()
		ArrivedAtEasternShore = true
	end;
	StartBriefing(briefing)
end
function Guard1()
	local BeiGu1 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "guard1",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("guard1"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("guard1",id);LookAt(id,"guard1")
		DisableNpcMarker(GetEntityId("guard1"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("guard1",gu1,"Der Zutritt nach Kafarna ist Fremden untersagt! @cr Wer seid ihr und was wollt ihr hier?", true)
		briefing.finished = function()
			KafarnaDiscovered()
			StartCountdown(30, function() EnableNpcMarker(GetID("guard2")) end, false)
			Guard2()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiGu1)
end
function Guard2()
	local BeiGu2 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "guard2",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("guard2"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("guard2",id);LookAt(id,"guard2")
		DisableNpcMarker(GetEntityId("guard2"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("guard2",gu2,"Ihr kommt hier nicht durch. @cr Das wäre viel zu gefährlich, das Tor zu öffnen.", true)
		ASP("guard2",gu2,"Räuber haben letztes Mal, als wir dieses Tor öffneten, einige unserer Stadtbewohner entführt. @cr Das riskieren wir sicherlich nicht erneut!", true)
		briefing.finished = function()
			SettlersFreedQuest()
			StartSimpleJob("SettlersFreedJob")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiGu2)
end
function SettlersFreedQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Die verschleppten Städter",
	text	= "Einige Stadtbewohner Kafarnas wurden von Räubern gefangen genommen. @cr Es scheint, als würde die Torwache das Tor nicht öffnen, weil diese Gegend so gefährlich ist. @cr @cr Vielleicht öffnet sie Euch ja das Tor, sobald die Städter gerettet und die Räuber vertrieben wurden.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SettlersFreedQID = quest.id
end
function SettlersFreedJob()
	local posX, posY = Logic.GetEntityPosition(GetID("BanditSpawn4"))
	if IsDestroyed("tower4") and Logic.GetPlayerEntitiesInArea(2, 0, posX, posY, 4500, 1, 2) == 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("p3trader",p3tr,"Endlich sind diese fiesen Räuber Geschichte.", false)
		ASP("PrisonRuin",p3tr,"Bitte seid doch so gut und zerstört diese Ruine. Dann kommen wir endlich hier raus und können wieder in unsere Heimat zurück.", false)
		ASP("PrisonRuin",p3al,"Eure Schwerter werden dagegen wohl nichts ausrichten... @cr Aber mit etwas Sprengstoff oder ein wenig Kanonenfeuer sollte die Ruine in Schutt und Asche zu legen sein...", false)
		briefing.finished = function()
			Logic.RemoveQuest(1, SettlersFreedQID)
			ReplaceEntity("PrisonRuin", Entities.CB_DestroyAbleRuinResidence1)
			StartSimpleJob("PrisonRuinDestroyedJob")
			PrisonRuinSulfurTribute()
			Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,"","PrisonRuinOnlyCannons",1,{},{GetID("PrisonRuin")})
			PrisonRuinDestroyedQuest()
		end
		StartBriefing(briefing)
		return true
	end
end
function PrisonRuinOnlyCannons(_id)
	if IsDestroyed(_id) then
		return true
	end
	local attacker = Event.GetEntityID1()
	local target = Event.GetEntityID2()
	if target == _id then
		if not IsCannonType(Logic.GetEntityType(attacker)) then
			CEntity.TriggerSetDamage(0)
		end
	end
end
function PrisonRuinSulfurTribute()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt " .. 4500 - round(500*gvDiffLVL) .. " Schwefel und " .. 2000 - round(500*gvDiffLVL) .. " Kohle, um die alte Gefängnisruine mit Sprengstoff zu beseitigen.";
	tribute.cost = {Sulfur = 4500 - round(500*gvDiffLVL), Knowledge = 2000 - round(500*gvDiffLVL)};
	tribute.Callback = PrisonRuinSulfurTributePayed
	PrisonRuinSulfurTID = AddTribute( tribute )
end
function PrisonRuinSulfurTributePayed()
	local posX, posY = Logic.GetEntityPosition(GetID("PrisonRuin"))
	for i = 1, 5 do
		Logic.CreateEffect(GGL_Effects.FXExplosion, posX + (i*100), posY + (i*100))
		Logic.CreateEffect(GGL_Effects.FXExplosion, posX - (i*100), posY - (i*100))
		for j = 5, 1, -1 do
			Logic.CreateEffect(GGL_Effects.FXExplosion, posX - (i*100), posY + (j*100))
			Logic.CreateEffect(GGL_Effects.FXExplosion, posX + (j*100), posY - (i*100))
		end
	end
	StartCountdown(1, function() SetHealth(GetID("PrisonRuin"), 0) end, false)
end
function PrisonRuinDestroyedQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Die Gefängnisruine",
	text	= "Eine alte Ruine versperrt den geretteten Städtern Kafarnas den Heimweg. @cr Ihr solltet sie mit Kanonenfeuer oder Sprengstoff beseitigen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	PrisonRuinDestroyedQID = quest.id
end
function PrisonRuinDestroyedJob()
	if IsDestroyed("PrisonRuin") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("p3settler",p3se,"Habt Dank. @cr Nun können wir endlich zurück in die Heimat. @cr Wir werden beim Torwächter ein gutes Wort für Euch einlegen.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1, PrisonRuinDestroyedQID)
			Logic.RemoveTribute(1, PrisonRuinSulfurTID)
			Move("p3settler", "guard2")
			Move("p3alchemist", "guard2")
			Move("p3scout", "guard2")
			Move("p3serf", "guard1")
			Move("p3trader", "guard1")
			Move("p3smelter", "guard1")
			StartSimpleJob("HostagesBackInTownJob")
		end
		StartBriefing(briefing)
		return true
	end
end
function HostagesBackInTownJob()
	if IsNear("p3settler", "gate_kafarna", 600) or IsNear("p3alchemist", "gate_kafarna", 600) or IsNear("p3scout", "gate_kafarna", 600)
	or IsNear("p3serf", "gate_kafarna", 600) or IsNear("p3trader", "gate_kafarna", 600) or IsNear("p3smelter", "gate_kafarna", 600) then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("gate_kafarna",p3se,"Hey Dieter. @cr Wir sind dank diesen Fremden unbeschadet zurück. @cr Nun macht auf, das Tor!", false)
		ASP("guard2",gu2,"Peter? @cr Bist du es, Peter? @cr ... @cr Ist gut, ich mache das Tor auf. Einen Moment bitte...", false)
		ASP("guard2",gu2,"Und ihr Fremdlinge... @cr Ihr dürft natürlich auch passieren. @cr Danke für Eure Hilfe. @cr Ich hatte schon keine Hoffnung mehr...", false)
		ASP("dario",dario,"Nun gut, meine Freunde. @cr Wir sollten schleunigst das Tor passieren und weiter gen Osten reisen.", false)
		briefing.finished = function()
			ReplaceEntity("gate_kafarna", Entities.XD_WallStraightGate)
			DestroyEntity("p3settler")
			DestroyEntity("p3alchemist")
			DestroyEntity("p3scout")
			DestroyEntity("p3serf")
			DestroyEntity("p3trader")
			DestroyEntity("p3smelter")
			--
			ReachEndPosQuest()
			StartSimpleJob("ReachedEndPosJob")
		end
		StartBriefing(briefing)
		return true
	end
end
function ReachEndPosQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Eine fremde Stadt",
	text	= "Durchquert mit Euren Helden das Tor nach Kafarna, um die Reise nach Osten fortzusetzen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	ReachEndPosQID = quest.id
end
function ReachedEndPosJob()
	local posX, posY = Logic.GetEntityPosition(GetID("gate_kafarna"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 500, 1) > 0 then
		Logic.RemoveQuest(1, ReachEndPosQID)
		StartCutscene("Outro", Victory)
		return true
	end
end
function HiddenWanderer()

	local BeiHWa = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "hiddenwanderer",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("hiddenwanderer"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("hiddenwanderer",id);LookAt(id,"hiddenwanderer")
		DisableNpcMarker(GetEntityId("hiddenwanderer"))
		if WesternRiddlesSolved then
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("hiddenwanderer",hwa,"Nun gut, so habt ihr mich wohl gefunden... @cr Mein Schüler war wohl noch nicht so weit.", false)
			ASP("hiddenwanderer",hwa,"Denkt noch nicht, ihr hättet es geschafft. @cr Meine Rätsel werden ein wenig schwieriger sein.", false)
			briefing.finished = function()
				QuestRiddle3()
				StartSimpleJob("ControlRiddle3Job")
				SetEntityVisibility(GetID("hiddenwanderer"), 0)
			end
			StartBriefing(briefing)
		else
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("hiddenwanderer",hwa,"Ihr habt die Rätsel meines Schülers noch nicht lösen können. @cr Nun, so seid ihr meines nicht würdig...", false)
			briefing.finished = function()
				StartCountdown(60, function() EnableNpcMarker(GetID("hiddenwanderer")); HiddenWanderer() end, false)
			end
			StartBriefing(briefing)
		end
	end
	}
	SetupExpedition(BeiHWa)
end
function QuestRiddle3()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Das Rätsel des Rätselmeisters",
	text	= "Ihr habt den Rätselmeister gefunden. @cr Er ist direkt nach dem Gespräch verschwunden und gab Euch ein neues Rätsel auf, wie er gefunden werden kann." ..
		" @cr @cr Rueschen du musst an ersinnet Krise.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	Riddle3QID = quest.id
end
function ControlRiddle3Job()
	local posX, posY = Logic.GetEntityPosition(GetID("mistrock"))
	if Logic.IsPlayerEntityOfCategoryInArea(1, posX, posY, 1200, "Hero") == 1 then
		DestroyEntity("hiddenwanderer")
		Logic.CreateEffect(GGL_Effects.FXExplosion, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, posX, posY)
		DestroyEntity("mistrock")
		local id = Logic.CreateEntity(Entities.CU_Wanderer, posX, posY, 90, 7)
		Logic.SetEntityName(id, "hiddenwanderer")
		EnableNpcMarker(id)
		HiddenWanderer2()
		Logic.RemoveQuest(1, Riddle3QID)
		return true
	end
end
function HiddenWanderer2()
	local BeiHWa = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "hiddenwanderer",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("hiddenwanderer"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("hiddenwanderer",id);LookAt(id,"hiddenwanderer")
		DisableNpcMarker(GetEntityId("hiddenwanderer"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		local riddle, answer = randomRiddle(GetNPCDefaultNameByID(id))
		ASP("hiddenwanderer",hwa,"Nun, ich habe Euch wohl unterschätzt.", false)
		ASP("hiddenwanderer",hwa,"Hier ist ein letztes Rätsel für Euch. @cr Löst es, und ich werde Euch auf Euren kommenden Missionen den einen oder anderen Vorteil verschaffen.", false)
		ASP("hiddenwanderer",hwa,"Ich gebe Euch hierfür ".. round(30 * gvDiffLVL) .." Sekunden Zeit. @cr @cr Hinweis: Gebt Zahlen NICHT ausgeschrieben an!", true)
		ASP("hiddenwanderer",hwa, riddle, false)
		briefing.finished = function()
			LastRiddle_Fail_CD = StartCountdown(30 * gvDiffLVL, LastRiddle_Failed_Brief, true)
			XGUIEng.ShowWidget("ChatInput", 1)
			function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
				StopCountdown(LastRiddle_Fail_CD)
				if _Message == answer or string.find(string.lower(_Message), string.lower(answer)) ~= nil then
					--success
					LastRiddle_Solved_Brief()
				else
					LastRiddle_Failed_Brief()
				end
				XGUIEng.ShowWidget("ChatInput", 0)
			end
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiHWa)
end
function LastRiddle_Failed_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = hwa,
		text = "Die richtige Antwort ward gesucht, die falsch ward gegeben. @cr Eine Wiederkehr? Wird sie kommen?",
		position = GetPosition("hiddenwanderer"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("hiddenwanderer"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("hiddenwanderer")
		end}
	ASP("dario",dario, "Och nö, dieser schräge Kauz ist schon wieder verschwunden...", false)
	briefing.finished = function()
	end
	StartBriefing(briefing)
end
function LastRiddle_Solved_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	AP{
		title = myn,
		text = "Ich habe Euch schon wieder unterschätzt. @cr Nun, wir werden uns sicherlich erneut begegnen...",
		position = GetPosition("mystic_npc"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("mystic_npc")
		end}
	briefing.finished = function()
		GDB.SetValue("myths\\journeyriddlessolved", 1)
	end
	StartBriefing(briefing)
end
function randomRiddle(_hero)
	local count = 5
	local rand = math.random(1, count)
	local quest = XGUIEng.GetStringTableText("cm09_01_journey/Riddle_" .. _hero .. "_Quest_".. rand)
	local answer = XGUIEng.GetStringTableText("cm09_01_journey/Riddle_" .. _hero .. "_Answer_".. rand)
	return quest, answer
end
function InitAchievementChecks()
	StartSimpleJob("CheckForLarinaAllBuildingsIntact")
	StartSimpleJob("CheckForBridgeRuinStillThere")
end
function CheckForLarinaAllBuildingsIntact()
	if LarinaFreed then
		if IsValid("tower1") and IsValid("tower2") and IsValid("sawmill") and IsValid("stonemason") and IsValid("university")
		and IsValid("farm1") and IsValid("farm2") and IsValid("residence1") and IsValid("residence2") and IsValid("beauty")
		and IsValid("HQP1") and IsValid("VCP1") then
			Message("Ihr habt alle Gebäude Larinas vor der Vernichtung bewahrt. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\journeylarinaallbuildings", 1)
		end
		return true
	end
end
function CheckForBridgeRuinStillThere()
	if ArrivedAtEasternShore then
		if Logic.GetEntities(Entities.PB_Bridge3, 1) == 0 then
			Message("Ihr habt das östliche Ufer betreten, ohne die unter Denkmalschutz stehende Brückenruine zu verändern. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\journeybridgeruinstillthere", 1)
		end
		return true
	end
end
--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end