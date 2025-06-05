-- MapName: Drakonien
-- Author: Ghoul
-- Zeichen:
-- ä -- Ã¤
-- ö -- Ã¶
-- ü -- ü
-- Ü -- Ãœ
-- Ö -- Ã-
-- Ä -- Ã„
--
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Drakonien @cr "
gvMapVersion = " v1.00"
--
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

gvCaravanWave = 1
caravans_arrived = 0
-- Startwerte für die "Beliebtheit" bei den Bergdörfern sowie kritische Werte für Diplo-Veränderungen
gvMoti ={Villages = {[5] = 100,[6] = 100,[7] = 100}, Critical = {Ally = 200, Enemy = 50}, DecreasePerTime = {[5] = 0.8, [6] = 0.7, [7] = 0.6},
	VillageNames = {[5] = "Güldfurt", [6] = "Ehernberg", [7] = "Hohenberge"},
	ProgressBarByPlayer = {[5] = "VCMP_Team1Progress", [6] = "VCMP_Team2Progress", [7] = "VCMP_Team3Progress"}}
gvLastTimeVillageHelped = {[5] = 0, [6] = 0, [7] = 0}
gvVillagesDiploChanged = {[5] = false, [6] = false, [7] = false}

function InitDiplomacy()
	SetPlayerName(8,"Drakon")
	SetPlayerName(2,"Kerberos")
	SetPlayerName(3,"Varg")
	SetPlayerName(4,"Mary de Morfichet")
	SetPlayerName(5,"Güldfurt")
	SetPlayerName(6,"Ehernberg")
	SetPlayerName(7,"Hohenberge")
	SetHostile(2,8)
	SetHostile(3,8)
	SetHostile(4,8)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	SetFriendly(1,8)

end
--**
function InitResources()
end
--**
function InitTechnologies()
	ForbidTechnology(Technologies.GT_PulledBarrel,1)
	ForbidTechnology(Technologies.GT_Mathematics,1)
	ForbidTechnology(Technologies.GT_Binocular,1)
	ForbidTechnology(Technologies.GT_Matchlock,1)
	--
end
--**
function InitWeatherGfxSets()
	--SetupNormalWeatherGfxSet()
end
--**
function InitWeather()
	AddPeriodicSummer(10)
end
--**
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
	InitBriefingData()
	Display.SetPlayerColorMapping(2,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(4,NEPHILIM_COLOR)
	Display.SetPlayerColorMapping(3,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(7,EVIL_GOVERNOR_COLOR)
	Display.SetPlayerColorMapping(6,NPC_COLOR)

end
--**
function FirstMapAction()
	IncludeGlobals("Cutscene")
	IncludeLocals("armies")
	MapEditor_SetupAI(2, 4-gvDiffLVL, 11500, 3, "KerberosBurg", 3, 0)
	SetupPlayerAi( 2, {constructing = true, extracting = false, repairing = true, serfLimit = 9} )
	MapEditor_SetupAI(3, math.max(1, 3-gvDiffLVL), 9100, 3-gvDiffLVL, "Varg", 3, 0)
	SetupPlayerAi( 3, {constructing = true, extracting = false, repairing = true, serfLimit = 2} )
	ConnectLeaderWithArmy(GetID("varg"), nil, "offensiveArmies")
	MapEditor_SetupAI(4, math.max(1, 3-gvDiffLVL), 7500, 4-gvDiffLVL, "Mary", 3, 0)
	SetupPlayerAi( 4, {constructing = true, extracting = false, repairing = true, serfLimit = 7} )
	ConnectLeaderWithArmy(GetID("mary"), nil, "offensiveArmies")
	SetupPlayerAi( 5, {constructing = true, extracting = false, repairing = true, serfLimit = 3} )
	SetupPlayerAi( 6, {constructing = true, extracting = false, repairing = true, serfLimit = 3} )
	SetupPlayerAi( 7, {constructing = true, extracting = false, repairing = true, serfLimit = 3} )
	--**
	--MapEditor_SetupAI(8, 0, 5000, 3, "Drakon", 1, 0)
	for i = 2,7 do
		AI.Village_SetResourceFocus(i, Entities.XD_ResourceTree)
	end
	--**
	ActivateBriefingsExpansion()
	NoArmyRespawnJob = StartSimpleJob("Re")
	StartSimpleJob("Gewonnen")
	StartSimpleJob("Verloren")
	StartSimpleJob("Techs")
	SetFriendly(1,8)
	SetNeutral(1,5)
	SetNeutral(1,6)
	SetNeutral(1,7)
    StarteSpiel()
	if gvDiffLVL > 1 then
		ReplaceEntity("P2bridge", Entities.XD_DrawBridgeOpen2)
		StartCountdown(20 + (20*gvDiffLVL)*60, KerberosReachable, false)
	end
	CaravanPerWave = 0
	if gvDiffLVL == 3 then
		CaravanPerWave = 5
	elseif gvDiffLVL == 2 then
		CaravanPerWave = 6
	elseif gvDiffLVL == 1 then
		CaravanPerWave = 8
	end
end
function KerberosReachable()
	ReplaceEntity("P2bridge", Entities.PB_DrawBridgeClosed2)
end
--**
function FarbigeNamen()
	orange 	= " @color:255,127,0 "
	weiss 	= " @color:255,255,255 "

	men 	= ""..orange.." Erzähler "..weiss..""
	kdA		= ""..orange.." Kommandant der drakonischen Armee "..weiss..""
	leo		= ""..orange.." Leo, drakonischer Kundschafter "..weiss..""
	alf	    = ""..orange.." Alfred, der Leibeigene "..weiss..""
	igor	= ""..orange.." Igor, der Leibeigene "..weiss..""
	mina	= ""..orange.." Minenvorarbeiter "..weiss..""
	bgm  	= ""..orange.." Bürgermeister "..weiss..""
	wan		= ""..orange.." Wanderer "..weiss..""
	kerbe	= ""..orange.." Kerberos "..weiss..""
	ment	= ""..orange.." Mentor "..weiss..""
	dari	= ""..orange.." Dario "..weiss..""
	dr		= ""..orange.." Drake "..weiss..""
	ari		= ""..orange.." Ari "..weiss..""
	--
	mjP5 	= ""..orange.." Anführer von Güldfurt "..weiss..""
	ser_p5 	= ""..orange.." Siedlungsplaner von Güldfurt "..weiss..""
	set_p5 	= ""..orange.." Wohnplaner von Güldfurt "..weiss..""
	far_p5 	= ""..orange.." Bauernvorsteher von Güldfurt "..weiss..""
	min_p5 	= ""..orange.." Minenvorarbeiter von Güldfurt "..weiss..""
	cav_p5 	= ""..orange.." Oberbefehlshaber von Güldfurt "..weiss..""
	cl_tr	= ""..orange.." Händler "..weiss..""
	--
	mjP6 	= ""..orange.." Anführer von Ehernberg "..weiss..""
	gu_p6 	= ""..orange.." Leif Keulenschwinger "..weiss..""
	set_p6  = ""..orange.." Olaf Olafsson "..weiss..""
	far_p6  = ""..orange.." Harald der Zermalmer "..weiss..""
	--
	mjP7 	= ""..orange.." Anführer von Hohenberge "..weiss..""
	gu_p7 	= ""..orange.." Thordal Hammerschlag "..weiss..""
	set_p7  = ""..orange.." Bjarn der Zornige "..weiss..""
	thi_p7  = ""..orange.." Rolf der Schreckliche "..weiss..""
	--
	trp8	= ""..orange.." Drakonischer Händler "..weiss..""
	gu_p8	= ""..orange.." Gallanter Wächter "..weiss..""
	set_p8	= ""..orange.." Ambitionierter Siedlungsplaner "..weiss..""
end
function InitBriefingData()
	gvBriefingLinesByBriefAndHero = {
		Settler_P6_1 = {
			Dario = {
				{"settler_p6",set_p6,"Was hat euch denn hierher verschlagen? @cr Männer gekleidet in edlem Zwirn sieht man hier nicht alle Tage.", true},
				{"Dario",set_p6,"Ihr solltet auf euer Hab und Gut Acht geben. @cr Würde mich nicht wundern, wenn ihr hier ausgeraubt würdet...", false},
				{"Dario",dari,"Ich kann schon auf mich aufpassen. Ich bin schließlich der König.", true},
				{"settler_p6",set_p6,"Hier gibt es keinen König. @cr Macht hat hier nur der Meistbietende.", false},
				{"Dario",dari,"Diesen Zeitgenossen werden wir wohl nur auf unsere Seite ziehen können, wenn wir ihn mit ein paar Goldmünzen bestechen...", true}
			},
			Ari = {
				{"settler_p6",set_p6,"Was hat euch denn hierher verschlagen? @cr Gut aussehende Frauen sollten in dieser Gegend nicht alleine reisen.", true},
				{"Ari",set_p6,"Ihr solltet euch besser bedecken. @cr Würde mich nicht wundern, wenn auf einmal eine Horde sabbernder Krieger hinter euch her ist...", false},
				{"Ari",ari,"Ich kann schon auf mich aufpassen. @cr Wäre nicht die erste Meute lechzender Männer, die ich zähmen muss.", true},
				{"settler_p6",set_p6,"Uns könnt ihr nicht zähmen, versucht es erst gar nicht. @cr Wahrlich mächtig ist hier nur der Meistbietende.", false},
				{"Ari",ari,"Mir scheint, dass dieser Zeitgenosse es auf Goldmünzen abgesehen hat. @cr Meine ... Argumente ... ließen ihn zumindest kalt...", true}
			}
		},
		Farmer_P6_1 = {
			Dario = {
				{"Dario",dari,"Guten Tag der Herr. @cr Gibt es irgendetwas, das wir tun können, damit ihr ein gutes Wort beim Dorfältesten für uns einlegt?", false},
				{"farmer_p6",far_p6,"Ich glaube ich träume. @cr Solche Worte... @cr von einem Hochwohlgeborenen wie euch?", true},
				{"sheep_gateP6",far_p6,"Aber ja, da gibt es tatsächlich was. @cr Wir vermissen zwei unserer Schafe. @cr Diese Schweine, äh Schafe, sind vor einigen Nächsten ausgebüxt...", false},
				{"farmer_p6",far_p6,"Findet die Schafe und treibt sie zum Gatter. @cr Dann werde ich ein gutes Wort für euch einlegen.", true}
			},
			Ari = {
				{"Ari",ari,"Guten Tag der Herr. @cr Gibt es irgendetwas, das wir tun können, damit ihr ein gutes Wort beim Dorfältesten für uns einlegt?", false},
				{"farmer_p6",far_p6,"Ich glaube ich träume. @cr Solche Worte... @cr von einer Schönheit wie euch? @cr Ihr seht nicht grade aus, als würdet ihr euch die Fingernägel für das einfache Volk abbrechen.", true},
				{"sheep_gateP6",far_p6,"Aber ja, da gibt es tatsächlich was. @cr Wir vermissen zwei unserer Schafe. @cr Diese Schweine, äh Schafe, sind vor einigen Nächsten ausgebüxt...", false},
				{"farmer_p6",far_p6,"Findet die Schafe und treibt sie zum Gatter. @cr Dann werde ich ein gutes Wort für euch einlegen.", true}
			}
		},
		Settler_P7_1 = {
			Dario = {
				{"settler_p7",set_p7,"Oh, ein König - so fernab des Palastes? @cr Was verschlägt euch in unser ärmliches Bergdorf?", false},
				{"Dario",dari,"Eine Allianz des Schreckens bestehend aus Kerberos, Mary und Varg belagern die Stadt Drakon. @cr Wir sind auf der Suche nach Verbündeten, um ihrer Invasion Herr zu werden.", true},
				{"settler_p7",gu_p7,"Gut geredet, das muss man euch lassen. @cr Worte alleine reichen hier aber nicht aus. @cr Wir leiden noch immer unter den Gebietsverlusten des letzten Krieges mit unseren netten Nachbarn.", false},
				{"Major",gu_p7,"Auch Drakon hat sich dabei ehemalige unsrige Gebiete einverleibt. @cr Das stößt bei uns entsprechend bitter auf, dass AUSGERECHNET Drakon nun Hilfe erbittet.", false},
				{"ironmine_p7",gu_p7,"Erschließt für uns wichtige Kriegsressourcen aus Drakons Gebieten. @cr Ihr könnt mit dieser Eisenmine beginnen.", false},
				{"sulfurmine_p7",gu_p7,"Auch diese Schwefelmine etwas weiter im Süden begehren wir. @cr Errichtet jeweils mindestens Stollen und in unmittelbarer Nähe Mühlen sowie mittlere Wohnhäuser, damit die Arbeiter auch gut versorgt sind.", false}
			},
			Ari = {
				{"settler_p7",set_p7,"Oh, ein leicht bekleidetes Frauenzimmer - so fernab vom rosa Plüsch? @cr Was verschlägt euch in unser ärmliches Bergdorf?", false},
				{"Ari",ari,"Eine Allianz des Schreckens bestehend aus Kerberos, Mary und Varg belagern die Stadt Drakon. @cr Wir sind auf der Suche nach Verbündeten, um ihrer Invasion Frau - äh Herr - zu werden.", true},
				{"settler_p7",gu_p7,"Gut geredet, das muss man euch lassen. @cr Worte alleine reichen hier aber nicht aus. @cr Wir leiden noch immer unter den Gebietsverlusten des letzten Krieges mit unseren netten Nachbarn.", false},
				{"Major",gu_p7,"Auch Drakon hat sich dabei ehemalige unsrige Gebiete einverleibt. @cr Das stößt bei uns entsprechend bitter auf, dass AUSGERECHNET Drakon nun Hilfe erbittet.", false},
				{"ironmine_p7",gu_p7,"Erschließt für uns wichtige Kriegsressourcen aus Drakons Gebieten. @cr Ihr könnt mit dieser Eisenmine beginnen.", false},
				{"sulfurmine_p7",gu_p7,"Auch diese Schwefelmine etwas weiter im Süden begehren wir. @cr Errichtet jeweils mindestens Stollen und in unmittelbarer Nähe Mühlen sowie mittlere Wohnhäuser, damit die Arbeiter auch gut versorgt sind.", false}
			}
		},
		MajorP8_P7Province = {
			Dario = {
				{"Major",bgm,"Dario. @cr Gut dich zu sehen. @cr Konntest du die benachbarten Bergdörfer überzeugen?", false},
				{"Dario",dari,"Wir sind auf gutem Weg. @cr Allerdings verlangt Hohenberge nach einigen Eurer westlichen Gebiete, die wohl im letzten Krieg den Besitzer gewechselt hatten.", true},
				{"ironmine_p7",bgm,"Die haben wir mit Blut und Schweiß unserer Soldaten erobert. @cr Einfach aufgeben können wir die Minen nicht. @cr Vor allem, da wir selbst mehr Ressourcen für den Kampf gegen die dunklen Horden benötigen.", false},
				{"Dario",dari,"Wie wäre es denn, wenn wir euch mit Kampfressourcen versorgen und ihr im Gegenzug die Gebiete an Hohenberge abtretet. @cr Wir benötigen dringend die Unterstützung der Bergdörfer und Hohenberge wird sich sicherlich nicht ohne diese Gebiete überzeugen lassen.", false},
				{"Major",bgm,"Nun, das wäre eine Überlegung wert. @cr Ihr müsst uns aber den Segen geben, dass wir diese Gebiete nach Beendigung der Invasion von Hohenberge zurückverlangen können - zur Not mit Gewalt. @cr Für den Fall, dass wir die Invasion zurückschlagen können...", true},
				{"Dario",dari,"Gutheißen kann ich das nicht. @cr Aber wenn das der einzig mögliche Kompromiss ist...", false}
			},
			Ari = {
				{"Major",bgm,"Ihr müsst Ari sein. @cr Gut Euch kennenzulernen. @cr Doch kommen wir gleich zum Punkt: @cr Konntet ihr die benachbarten Bergdörfer überzeugen?", false},
				{"Ari",ari,"Wir sind auf gutem Weg. @cr Allerdings verlangt Hohenberge nach einigen Eurer westlichen Gebiete, die wohl im letzten Krieg unfreiwillig den Besitzer gewechselt hatten...", true},
				{"ironmine_p7",bgm,"Die haben wir mit Blut und Schweiß unserer Soldaten erobert. @cr Einfach aufgeben können wir die Minen nicht. @cr Vor allem, da wir selbst mehr Ressourcen für den Kampf gegen die dunklen Horden benötigen.", false},
				{"Ari",ari,"Nun, ich hatte mit Dario gesprochen und wir könnten Euch wohl mit Kampfressourcen versorgen. @cr Im Gegenzug könntet ihr die Gebiete an Hohenberge abtreten. @cr Wir benötigen dringend die Unterstützung der Bergdörfer und Hohenberge wird sich sicherlich nicht ohne diese Gebiete überzeugen lassen.", false},
				{"Major",bgm,"Nun, das wäre eine Überlegung wert. @cr Ihr müsst uns aber den Segen geben, dass wir diese Gebiete nach Beendigung der Invasion von Hohenberge zurückverlangen können - zur Not mit Gewalt. @cr Für den Fall, dass wir die Invasion zurückschlagen können...", true},
				{"Ari",ari,"Gutheißen wird Dario das nicht. @cr Und ich ebenso wenig. @cr Aber wenn das der einzig mögliche Kompromiss ist...", false}
			}
		}
	}
end
--**
function StarteSpiel()
	CreateMilitaryGroup(1,Entities.PU_LeaderBow3,8,GetPosition("Support"),"Bogen")
	Logic.RotateEntity(Logic.GetEntityIDByName("Bogen"),150)
	--**
	MakeInvulnerable("Drake"); MakeInvulnerable("Major")
	MakeInvulnerable("miner"); MakeInvulnerable("Comm")
	MakeInvulnerable("Kerberos")
	--**
	SetHealth("hqSP",50)
	--**
	--Prolog()
	SetupNPCSystem()
	IntroCutscene()
	SetHostile(1,2)
	SetHostile(1,3)
	SetHostile(1,4)
	--
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(2,3,4,6,8), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		if Logic.IsLeader(eID) == 1 then
			table.insert(gvLightning.IgnoreIDs, eID)
			Logic.GroupStand(eID)
		end
	end
end
--**
function IntroCutscene()
	local cutsceneTable = {
		StartPosition = {
		position = GetPosition("cutscene_start1"), angle = 25, zoom = 1900, rotation = 135},
		Flights = 	{
			{
				position = GetPosition("cutscene_start2"),
				angle = 23,
				zoom = 1900,
				rotation = 120,
				duration = 13,
				action 	=	function()

							end,
				title = " @color:180,0,240 Mentor",
				text = " @color:230,0,0 So erreichten Ari und Dario nach wochenlangem Marsch Drakon... ",
			},
			{
				position = GetPosition("cutscene_start3"),
				angle = 25,
				zoom = 1700,
				rotation = 105,
				duration = 15,
				action 	=	function()

							end,
				title = " @color:180,0,240 Mentor",
				text = " @color:230,0,0 Noch schien alles ruhig zu sein... @cr Doch wie lange würde es dabei bleiben?",
			},
			{
				position = GetPosition("cutscene_start4"),
				angle = 27,
				zoom = 1700,
				rotation = 90,
				duration = 14,
				action 	=	function()

							end,
				title = " @color:180,0,240 Mentor",
				text = " @color:230,0,0 Finstere Machenschaften scheinen ihren Lauf zu nehmen... @cr Kann die einstmalige Idylle bestehen?",
			}
		},
		Callback = function()
			IntroBrief()
		end,
	}
	Start_Cutscene(cutsceneTable)
end
function IntroBrief()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("start_pos",ment,"Dario und Ari sind in den Norden des Königreiches aufgebrochen, um dort nach dem Rechten zu sehen.", true)
	ASP("start_pos",ment,"Im Königreich geht das Gerücht um, das Kerberos, Varg und Mary wieder einmal vereint sind.", true)
	ASP("start_pos",ment,"Sie würden erneut versuchen, die Macht über das Reich von Norden her an sich zu reißen...", true)
	ASP("Ari",ari,"Wir sollten uns zunächst bei den Leuten hier in der Nähe informieren, sie wissen bestimmt mehr als wir.", true)
	ASP("Dario",dari,"Wir wissen jedoch nicht was uns erwartet. Wir sollten auch eine Siedlung errichten, um auf alles gefasst zu sein.",true)
	ASP("Ari",ari,"Dann lass uns aufbrechen und einen Siedlungsplatz suchen.",true)
	ASP("start_pos",ment,"Herr, gebt gut auf diese Leibeigenen Acht. @cr Ihr werdet so schnell keine weiteren bekommen können.",true)
	briefing.finished = function()
		Truhen()
		QuestVillageSearch()
		EnableNpcMarker(GetEntityId("intro_hermit"))
		Intro_Hermit()
		InitNPC("serf1")
		InitNPC("serf2")
		InitNPC("Serf")
		InitNPC("Settler")
		SetNPCFollow("serf1","Ari",500,10000,nil)
		SetNPCFollow("serf2","Ari",500,10000,nil)
		SetNPCFollow("Serf","Ari",500,10000,nil)
		SetNPCFollow("Settler","Ari",500,10000,nil)
		SerfJob = StartSimpleJob("SerfDied")
		InitAchievementChecks()
		if gvDiffLVL == 3 then
			DefCount = StartCountdown(2.4*60,Defeat,true)
			CreateMilitaryGroup(3,Entities.CU_BanditLeaderBow1,6,GetPosition("Wegelagerer2"))
			CreateMilitaryGroup(3,Entities.CU_BanditLeaderSword2,6,GetPosition("Wegelagerer1"))
		elseif gvDiffLVL == 2 then
			DefCount = StartCountdown(2.2*60,Defeat,true)
			CreateMilitaryGroup(3,Entities.CU_BanditLeaderBow1,10,GetPosition("Wegelagerer2"))
			CreateMilitaryGroup(3,Entities.CU_BanditLeaderSword2,8,GetPosition("Wegelagerer1"))
		elseif gvDiffLVL == 1 then
			DefCount = StartCountdown(1.7*60,Defeat,true)
			for i = 1,2 do
				CreateMilitaryGroup(3,Entities.CU_BanditLeaderBow1,10,GetPosition("Wegelagerer2"))
				CreateMilitaryGroup(3,Entities.CU_BanditLeaderSword2,8,GetPosition("Wegelagerer1"))
			end
		end
		gvDayCycleStartTime = Logic.GetTime()
		TagNachtZyklus(32,1,1,(1+gvDiffLVL),1)
	end
	StartBriefing(briefing)
end
function SerfDied()
	if IsDead("serf1") or IsDead("serf2") or IsDead("Serf") or IsDead("Settler") then
		Defeat()
		return true
	end
end
function QuestVillageSearch()
	quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Findet einen geeigneten Siedlungsplatz",
	text	= "Sucht einen geeigneten Siedlungsplatz. @cr Vielleicht kann Euch ja jemand bei der Suche helfen?",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	VilSearchQuest = quest.id
end
function Intro_Hermit()
	local BeiWan = {
	EntityName = "Dario",
    TargetName = "intro_hermit",
    Distance = 300,
    Callback = function()
		LookAt("Dario","intro_hermit");LookAt("intro_hermit","Dario")
		local briefing = {}
		DisableNpcMarker(GetEntityId("intro_hermit"))
		local AP, ASP = AddPages(briefing)
		ASP("intro_hermit",wan,"Guten Tag der Herr. @cr Was ist Euer Begehr?", true)
		ASP("Dario",dari,"Wir sind auf der Suche nach einem geeigneten Platz zum Siedeln. @cr Wisst ihr ob es einen solchen hier in der Nähe gibt?", false)
		AP{
			title = wan,
			text = "Aber ja doch. @cr Wie es der Zufall so will, befindet sich hier ganz in der Nähe eine alte, längst verlassene Burg.",
			position = GetPosition("hqSP"),
			dialogCamera = false,
			}
		AP{
			title = wan,
			text = "Sie ist zwar ein wenig baufällig, aber wie ich sehe, habt ihr ja Leibeigene dabei, die sie wieder in alten Glanz erstrahlen lassen können.",
			position = GetPosition("hqSP"),
			dialogCamera = false,
			}
		ASP("Ari",ari,"Vielen Dank der Herr. Genau nach so etwas haben wir Ausschau gehalten. Könntet ihr noch so nett sein und uns den Weg dahin verraten?", true)
		ASP("intro_hermit",wan,"Natürlich, meine Dame. @cr Folgt dem Weg hinter mir ein kurzes Stück zur nächsten Weggabelung. Nehmt dann den südlichen Weg. Ihr stoßt dann auf eine alte Steinbrücke. Überquert diese und ihr erreicht die Siedlung.", true)
		briefing.finished = function()
			StopCountdown(DefCount)
			SetPosition("Dario",GetPosition("start_step1"))
			SetPosition("Ari",GetPosition("start_pos_ari"))
			Briefing_Split()
			MoveAndVanish("intro_hermit","Wald")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiWan)
end
function Briefing_Split()
	LookAt("Dario","Ari");LookAt("Ari","Dario")
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Dario",dari,"Ari, ich erwähne das nur ungern, aber es wäre besser, wenn wir uns trennen. @cr Ich eile nach Drakon, während du dich um den Siedlungsbau kümmerst.", true)
	ASP("Ari",ari,"Du hast ja schon Recht, aber ich bin nur ungern von dir getrennt. Pass auf dich auf, wer weiß was in diesen Wäldern noch alles lauert...", true)
	briefing.finished = function()
	ChangePlayer("Dario",8)
	Move("Dario","dario_drakon")
	StartSimpleJob("VillageApproached")
	DefCount = StartCountdown(1.5*gvDiffLVL*60,Defeat,true)

	end;
	StartBriefing(briefing)
end
function VillageApproached()
	if IsNear("Ari","hqSP",1200) then
		Briefing_VillageApproached()
		return true
	end
end
function Briefing_VillageApproached()
	LookAt("Ari","hqSP")
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Ari",ari,"Seehr gut, wir haben den Siedlungsplatz gefunden. @cr Nun lasst uns hier eine ordentliche Siedlung errichten.", false)
	ASP("hqSP",ari,"Wir sollten zunächst die Burg reparieren und die Ruinen beseitigen.", false)
	briefing.finished = function()
		StopCountdown(DefCount)
		Logic.RemoveQuest(1,VilSearchQuest)
		ChangePlayer("hqSP",1)
		ChangePlayer("serf1",1)
		ChangePlayer("serf2",1)
		ChangePlayer("Serf",1)
		ChangePlayer("Settler",1)
		SetNPCFollow("serf1",nil)
		SetNPCFollow("serf2",nil)
		SetNPCFollow("Serf",nil)
		SetNPCFollow("Settler",nil)
		local barrpos = GetPosition("bridge")
		BridgeBarrier = Logic.CreateEntity(Entities.XD_SnowBarrier1, barrpos.X, barrpos.Y, 0, 0)
		SetEntityVisibility(BridgeBarrier, 0)
		CreateEntity(6,Entities.PU_Thief,GetPosition("thief_pos"),"thief")
		MakeInvulnerable("thief")
		Move("thief","bridge_pos")
		StartSimpleJob("BridgeApproached")
		SetupPlayerAi( 8, {constructing = true, extracting = 1, repairing = true, serfLimit = 9} )
		AI.Village_EnableConstructing(8, 1)
		AI.Entity_ActivateRebuildBehaviour(8,30,5)
		AI.Village_LimitExpansionRadius(8, 5000)
		AI.Village_SetResourceFocus(8,ResourceType.Wood)
		AddGold(round(500*gvDiffLVL))
		AddSulfur(round(75*gvDiffLVL))
		AddIron(round(100*gvDiffLVL))
		AddWood(round(500*gvDiffLVL))
		AddStone(round(500*gvDiffLVL))
		AddClay(round(500*gvDiffLVL))
	end
	StartBriefing(briefing)
end
function BridgeApproached()
	if IsExisting("thief") then
		if IsNear("thief","bridge_pos",500) then
			StartCountdown(5+gvDiffLVL,BridgeDestroy,false)
			return true
		end
	else
		return true
	end
end
function BridgeDestroy()
	if IsExisting("thief") then
		local pos = GetPosition("bridge_pos")
		Logic.CreateEffect(GGL_Effects.FXExplosion,pos.X,pos.Y)
		Logic.CreateEffect(GGL_Effects.FXExplosion,pos.X+200,pos.Y+100)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,pos.X,pos.Y)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,pos.X+200,pos.Y+100)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,pos.X,pos.Y)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,pos.X+200,pos.Y+100)
		Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge,pos.X,pos.Y)
		local bridgeTable = {Logic.GetEntitiesInArea(Entities.PB_Bridge2, pos.X, pos.Y, 2500,1)}
		DestroyEntity(bridgeTable[2])
		DestroyEntity(BridgeBarrier)
		GUI.ExpelSettler(GetEntityId("thief"))
		Message("Hmm, was war das für ein lautes Geräusch?")
		if gvDiffLVL >= 2 then
			for i = 2,8 do
				ResearchTroopUpgrades(i,true,true,true,false)
			end
		elseif gvDiffLVL == 1 then
			for i = 2,4 do
				ResearchTroopUpgrades(i,true,true,true,true)
			end
			for i = 5,7 do
				ResearchTroopUpgrades(i,true,true,true,false)
			end
		end
		StartCountdown(2*(gvDiffLVL^3)*60,CreateArmies,false)
		EnableNpcMarker(GetEntityId("Serf")) --Igor
		IgorBrief_1()
	end
end
function MtVillages_SetupMotiGUI()

	local r,g,b;
	local timeProgress;
	GUIUpdate_VCTechRaceProgress = function()
		if gvMoti.Villages[5] >= gvMoti.Critical.Ally then
			r = 0
			g = 255
			b = 0
		elseif gvMoti.Villages[5] <= gvMoti.Critical.Enemy then
			r = 255
			g = 0
			b = 0
		else
			r = 229
			g = 190
			b = 1
		end
		XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 255)
		XGUIEng.SetProgressBarValues(gvMoti.ProgressBarByPlayer[5], gvMoti.Villages[5], gvMoti.Critical.Ally);
		--
		if gvMoti.Villages[6] >= gvMoti.Critical.Ally then
			r = 0
			g = 255
			b = 0
		elseif gvMoti.Villages[6] <= gvMoti.Critical.Enemy then
			r = 255
			g = 0
			b = 0
		else
			r = 229
			g = 190
			b = 1
		end
		XGUIEng.SetMaterialColor("VCMP_Team2Progress", 0, r, g, b, 255)
		XGUIEng.SetProgressBarValues(gvMoti.ProgressBarByPlayer[6], gvMoti.Villages[6], gvMoti.Critical.Ally);
		--
		if gvMoti.Villages[7] >= gvMoti.Critical.Ally then
			r = 0
			g = 255
			b = 0
		elseif gvMoti.Villages[7] <= gvMoti.Critical.Enemy then
			r = 255
			g = 0
			b = 0
		else
			r = 229
			g = 190
			b = 1
		end
		XGUIEng.SetMaterialColor("VCMP_Team3Progress", 0, r, g, b, 255)
		XGUIEng.SetProgressBarValues(gvMoti.ProgressBarByPlayer[7], gvMoti.Villages[7], gvMoti.Critical.Ally);
	end
	GUIUpdate_VCTechRaceColor = function()end

	local barLength = 250
	local textBoxSize = 15
	--local barHeight = 4
	local barHeight = 10
	local heightElement = 25
	XGUIEng.SetWidgetPositionAndSize("VCMP_Window", 0, 112, 252, 294)
	--XGUIEng.SetWidgetSize( "VCMP_Window", 252, 294)
	XGUIEng.ShowWidget( "VCMP_Window", 1)
	XGUIEng.ShowAllSubWidgets( "VCMP_Window",1)
	for i = 1, 8 do
		for j = 1, 8 do
			XGUIEng.ShowWidget( "VCMP_Team"..i.."Player"..j, 0)
		end
		XGUIEng.SetWidgetSize( "VCMP_Team"..i, 252, 32)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."Name", 252, 32)
		XGUIEng.ShowWidget( "VCMP_Team"..i.."_Shade", 0)
		XGUIEng.SetMaterialColor( "VCMP_Team"..i.."Name", 0, 0, 0, 0, 0) --hide BG by using alpha = 0s
		XGUIEng.ShowWidget( "VCMP_Team"..i.."PointGame", 0)


		-- manage progress bars
		XGUIEng.ShowWidget( "VCMP_Team"..i.."TechRace", 1)
		XGUIEng.ShowAllSubWidgets( "VCMP_Team"..i.."TechRace", 1)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."TechRace", barLength, barHeight)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."Progress", barLength, barHeight)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."ProgressBG", barLength, barHeight)

		-- widget positions to set
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i, 0, heightElement*(i-1))
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i.."Name", 0, 0)
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i.."TechRace", 0, textBoxSize)
	end
	for i = 4, 8 do
		XGUIEng.ShowWidget("VCMP_Team"..i, 0);
		XGUIEng.ShowWidget("VCMP_Team"..i.."_Shade", 0);
	end
	local r,g,b;
	r,g,b = GUI.GetPlayerColor(5);
	XGUIEng.SetText("VCMP_Team1Name", "Motivation bei " .. gvMoti.VillageNames[5]);
	XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 150)
	--
	r,g,b = GUI.GetPlayerColor(6);
	XGUIEng.SetText("VCMP_Team2Name", "Motivation bei " .. gvMoti.VillageNames[6]);
	XGUIEng.SetMaterialColor("VCMP_Team2Progress", 0, r, g, b, 150)
	--
	r,g,b = GUI.GetPlayerColor(7);
	XGUIEng.SetText("VCMP_Team3Name", "Motivation bei " .. gvMoti.VillageNames[7]);
	XGUIEng.SetMaterialColor("VCMP_Team3Progress", 0, r, g, b, 150)
end
function MtVillagesMotiControl(_player)
	local DiffVal = 1
	if gvDiffLVL == 1 then
		DiffVal = 1.5
	elseif gvDiffLVL == 3 then
		DiffVal = 0.8
	end
	if MtVillagesDiploCheck(_player) then
		local amount
		if Logic.GetTime() - gvLastTimeVillageHelped[_player] >= 60*30/DiffVal then
			amount = 4*gvMoti.DecreasePerTime[_player]*DiffVal
		else
			amount = gvMoti.DecreasePerTime[_player]*DiffVal
		end
		gvMoti.Villages[_player] = gvMoti.Villages[_player] - amount
		Message("Motivationsverlust bei " .. gvMoti.VillageNames[_player] .. ": " .. string.format("%.1f", amount) )
	end

	local root = XGUIEng.GetWidgetsMotherID(gvMoti.ProgressBarByPlayer[_player])
	if gvMoti.Villages[_player] >= gvMoti.Critical.Ally and not gvVillagesDiploChanged[_player] then
		SetFriendly(_player,1)
		SetNeutral(_player,8)
		SetHostile(_player,2)
		SetHostile(_player,3)
		SetHostile(_player,4)
		ActivateShareExploration(1,_player,true)
		Message("Ihr habt " .. gvMoti.VillageNames[_player] .. " für euch gewonnen! Sie werden nun an Eurer Seite kämpfen")
		MapEditor_SetupAI(_player, 1, 57600, math.min(1+gvDiffLVL, 3), "HQP" .. _player, math.min(1+gvDiffLVL, 3), 0)
		SetupPlayerAi( _player, {constructing = true, extracting = 1, repairing = true, serfLimit = 3} )
		gvVillagesDiploChanged[_player] = true
		XGUIEng.ShowWidget(root, 0)
		XGUIEng.ShowWidget(XGUIEng.GetWidgetsMotherID(root), 0)
	elseif gvMoti.Villages[_player] <= gvMoti.Critical.Enemy and gvMoti.Villages[_player] > 0 and not gvVillagesDiploChanged[_player] then
		SetNeutral(_player,1)
		SetNeutral(_player,8)
		SetNeutral(_player,2)
		SetNeutral(_player,3)
		SetNeutral(_player,4)
		Logic.SetShareExplorationWithPlayerFlag(1, _player, 0)
		Message("Euere Beliebtheit bei " .. gvMoti.VillageNames[_player] .. " hat einen kritischen Stand erreicht! Sie werden in Bälde zu Euren Feinden, wenn ihr nichts unternehmt!")
		XGUIEng.ShowWidget(root, 1)
		XGUIEng.ShowWidget(XGUIEng.GetWidgetsMotherID(root), 1)
	elseif gvMoti.Villages[_player] <= 0 and not gvVillagesDiploChanged[_player] then
		SetHostile(_player,1)
		SetHostile(_player,8)
		SetNeutral(_player,2)
		SetNeutral(_player,3)
		SetNeutral(_player,4)
		Logic.SetShareExplorationWithPlayerFlag(1, _player, 0)
		Message("Ihr habt " .. gvMoti.VillageNames[_player] .. " verärgert! Sie sind ab sofort Eure Feinde!")
		MapEditor_SetupAI(_player, 1, 57600, 4-gvDiffLVL, "HQP" .. _player, 3-gvDiffLVL, 0)
		SetupPlayerAi( _player, {constructing = true, extracting = 1, repairing = true, serfLimit = 3} )
		gvVillagesDiploChanged[_player] = true
		XGUIEng.ShowWidget(root, 0)
		XGUIEng.ShowWidget(XGUIEng.GetWidgetsMotherID(root), 0)
	else
		SetNeutral(_player,1)
		SetNeutral(_player,8)
		SetNeutral(_player,2)
		SetNeutral(_player,3)
		SetNeutral(_player,4)
		Logic.SetShareExplorationWithPlayerFlag(1, _player, 0)
		XGUIEng.ShowWidget(root, 1)
		XGUIEng.ShowWidget(XGUIEng.GetWidgetsMotherID(root), 1)
	end
	if gvVillagesDiploChanged[_player] then
		StopCountdown(MtVillagesMotiControlCdID[_player])
	else
		MtVillagesMotiControlCdID[_player] = StartCountdown(2*60,MtVillagesMotiControl,false,nil,_player)
	end
end
function MtVillagesDiploCheck(_pID)
	return Logic.GetDiplomacyState(1, _pID) == Diplomacy.Neutral
end
--**
function IgorBrief_1()
	local BeiIgor = {
	EntityName = "Ari",
    TargetName = "Serf",
    Distance = 300,
    Callback = function()
		LookAt("Ari","Serf");LookAt("Serf","Ari")
		local briefing = {}
		DisableNpcMarker(GetEntityId("Serf"))
		local AP, ASP = AddPages(briefing)
		ASP("Serf",igor,"Wer seid ihr und was wollt ihr von mir?", true)
		ASP("Ari",ari,"Nun, sah so aus, als würdet ihr mit mir sprechen wollen.", true)
		ASP("Serf",igor,"Ähm... aja, nun fällt`s mir wieder ein.....", true)
		ASP("River",igor,"Seht doch mal, wie die Flüsse hier aussehen.", false)
		ASP("Serf",igor,"Hier scheint das Wetter nicht gerade beständig zu sein.", true)
			briefing.finished = function()
			EnableNpcMarker(GetEntityId("Settler")) -- Alfred
			AlfredBrief_1()
			end;
			StartBriefing(briefing)
		end
		}
	SetupExpedition(BeiIgor)
end
--**
function AlfredBrief_1()
	local BeiAlf = {
	EntityName = "Ari",
    TargetName = "Settler",
    Distance = 300,
    Callback = function()
		LookAt("Ari","Settler");LookAt("Settler","Ari")
		local briefing = {}
		DisableNpcMarker(GetEntityId("Settler"))
		local AP, ASP = AddPages(briefing)
		ASP("Settler",alf,"Schönes Wetter Heute, nicht?", true)
		ASP("Settler",alf,"Dem Anschein nach sitzen wir hier auf einer Insel fest.", true)
		ASP("Settler",alf,"Von dieser Insel kommen wir vermutlich nur im Winter weg.", true)
		ASP("bridge",alf,"Es scheint jemand die Brücke zerstört zu haben... Wenn wir doch nur Brückenbaupläne hätten...", false)
		briefing.finished = function()
			EnableNpcMarker(GetEntityId("Hermit"))
			WandererBrief_1()
			EndJob(SerfJob)
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiAlf)
end
--**
function WandererBrief_1()
	local BeiWan = {
	EntityName = "Ari",
    TargetName = "Hermit",
    Distance = 300,
    Callback = function()
		LookAt("Ari","Hermit");LookAt("Hermit","Ari")
		local briefing = {}
		DisableNpcMarker(GetEntityId("Hermit"))
		local AP, ASP = AddPages(briefing)
		ASP("Hermit",wan,"Guten Tag, schöne Frau.", true)
		ASP("Mauer",wan,"Seht ihr die Mauern dort hinten?", false)
		AP{
			title = wan,
			text = "Innerhalb dieser Mauern befindet sich die Stadt Drakon.",
			position = GetPosition("Mauer"),
			dialogCamera = false,
			}
		AP{
			title = wan,
			text = "Leider herrscht dort zur Zeit Krieg.",
			position = GetPosition("Mary"),
			dialogCamera = false,
			}
		ASP("Ari",ari,"Dann sollten wir Drakon schleunigst zu Hilfe eilen, bevor es zu spät ist.", true)
		ASP("Dario",dari,"Ok, wir sollten aber zunächst eine florierende Siedlung aufbauen.", true)
		ASP("Dario",dari,"Im Winter und mit genügend Truppen können wir Drakon dann zu Hilfe eilen.", true)
		ASP("Bogen",ari,"Gute Idee. Eines meiner Trupps kann uns bei dieser Aufgabe helfen.", true)
		briefing.finished = function()
			Move("Scout", "Dario")
			ScoutBrief_1()
		end;
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiWan)
end
--**
function ScoutBrief_1()
	local BeiDari = {
	EntityName = "Scout",
    TargetName = "Dario",
    Distance = 300,
    Callback = function()
		ChangePlayer("Dario",1)
		LookAt("Scout","Dario");LookAt("Dario","Scout")
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Scout",leo,"Phuuu..... Endlich finde ich Euch.", true)
		ASP("Dario",dari,"Beruhigt euch doch erst einmal. @cr Ihr seid ja völlig ausser Atem.", true)
		ASP("Dario",dari,"Was gibt es denn so wichtiges ?", true)
		ASP("Scout",leo,"Herr, der Bürgermeister von Drakon schickt mich zu Euch.", true)
		ASP("Scout",leo,"Er möchte dringend mit euch sprechen. @cr Scheint sehr wichtig zu sein.", true)
		ASP("Dario",dari,"Und wo finde ich den Bürgermeister von Drakon ?", true)
		ASP("Major",leo,"Bei seiner Burg natürlich.", true)
		AP{
			title = leo,
			text = "Ich werde seine Position auf Eurer Karte markieren, @cr "..
				   "damit Ihr ihn auch später leicht finden könnt.",
			position = GetPosition("Major"),
			marker = STATIC_MARKER,
			dialogCamera = true,
		}
		briefing.finished = function()
			EnableNpcMarker(GetEntityId("Major"))
			EnableNpcMarker(GetEntityId("ClayTrader"))
			BuergermeisterBrief_1()
			QuestBuergermeister()
			DefCount = StartCountdown(5*60,Defeat,true)
			ClayTrader()
			InitMerchants()
		end;
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiDari)
end
function ClayTrader()
	local BeiCT = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "ClayTrader",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("ClayTrader"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("ClayTrader",id);LookAt(id,"ClayTrader")
		DisableNpcMarker(GetEntityId("ClayTrader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("ClayTrader",cl_tr,"Ah, Kundschaft. @cr Das sieht man hier auch nicht alle Tage. @cr Seit hier Krieg herrscht, laufen die Geschäfte nicht mehr allzu gut.", false)
		ASP("ClayTrader",cl_tr,"Schaut Euch ruhig um und begutachtet meine Waren.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was habt ihr denn anzubieten?", true)
		ASP("ClayTrader",cl_tr,"Lehm, feinsten Lehm. @cr Den besten der Gegend.", false)
		briefing.finished = function()
			NumsClayTraded = 1
			TributeClay1()
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiCT)
end
function TributeClay1()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Zahlt ".. round((1000/gvDiffLVL + (NumsClayTraded * 500 / gvDiffLVL)) * (1+(NumsClayTraded/10))) .." Taler für 2000 Lehm."
	tribute.cost = { Gold = round((1000/gvDiffLVL + (NumsClayTraded * 500 / gvDiffLVL)) * (1+(NumsClayTraded/10))) }
	tribute.Callback = TributePaidClay1
	TributeClay1ID = AddTribute(tribute)
end
function TributePaidClay1()
	NumsClayTraded = NumsClayTraded + 1
	Logic.AddToPlayersGlobalResource(1, ResourceType.Clay, 2000)
	TributeClay1()
end
function TraderP8()
	local BeiTP8 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Trader",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Trader"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Trader",id);LookAt(id,"Trader")
		DisableNpcMarker(GetEntityId("Trader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Trader",trp8,"Ah, endlich wieder Kundschaft. @cr Ich hatte schon befürchtet, meinen kleinen Laden schließen zu müssen.", false)
		ASP("Trader",trp8,"Schaut Euch in Ruhe um und begutachtet meine Waren.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was habt ihr denn im Angebot?", true)
		ASP("Trader",trp8,"Steine, handgeschlagene Steine. @cr Die besten weit und breit.", false)
		briefing.finished = function()
			NumsStoneTraded = 1
			TributeStone1()
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiTP8)
end
function TributeStone1()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Zahlt ".. round((1500/gvDiffLVL + (NumsStoneTraded * 500 / gvDiffLVL)) * (1+(NumsStoneTraded/10))) .." Taler für 3000 Steine."
	tribute.cost = { Gold = round((1500/gvDiffLVL + (NumsStoneTraded * 500 / gvDiffLVL)) * (1+(NumsStoneTraded/10))) }
	tribute.Callback = TributePaidStone1
	TributeClay1ID = AddTribute(tribute)
end
function TributePaidStone1()
	NumsStoneTraded = NumsStoneTraded + 1
	Logic.AddToPlayersGlobalResource(1, ResourceType.Stone, 3000)
	TributeStone1()
end
--**
function QuestBuergermeister()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Eine Audienz mit Drakons Bürgermeister",
		text	= "Geht mit Dario nach Drakon und sprecht dort mit dem Bürgermeister.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BuergermeisterQuest = quest.id
end
--**
function BuergermeisterBrief_1()
	local BeiBM = {
	EntityName = "Dario",
    TargetName = "Major",
    Distance = 300,
    Callback = function()
		LookAt("Major","Dario");LookAt("Dario","Major")
		DisableNpcMarker(GetEntityId("Major"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Major",bgm,"Hallo Dario, gut dass ihr gekommen seid.", true)
		ASP("Major",bgm,"Wie ihr seht, haben wir ein Problem.", true)
		ASP("Major",bgm,"Invasoren belagern unsere schöne Stadt.", true)
		ASP("caravan_start1",bgm,"Wir werden von hier aus in Kürze zusätzliche Ressourcen aus den Nachbarstädten erhalten.", false)
		ASP("Wald",bgm,"In den Wäldern sollen jedoch Wegelagerer ihr Unwesen treiben. Achtet darauf, dass die Karavanen ihre Reise unbeschadet überstehen", false)
		ASP("Major",bgm,"Wenn uns mindestens ".. round(30/gvDiffLVL).." der Karavanen unbeschadet erreichen werden, sollten wir eine Chance haben.", true)
		briefing.finished = function()
			StopCountdown(DefCount)
			Logic.RemoveQuest(1,BuergermeisterQuest)
			GUI.DestroyMinimapPulse(Logic.GetEntityPosition(Logic.GetEntityIDByName("Major")))
			QuestBuergermeister2()
			gvCaravanCounters[1] = StartCountdown(2.5*60*gvDiffLVL,CaravanStart,false)
			ActivateCaravanQuestGUI()
			table.insert(gvFuncsToBeReloadedOnMapLoad, {fname = ActivateCaravanQuestGUI, params = {}})
			EnableNpcMarker(GetEntityId("Trader"))
			TraderP8()
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiBM)
end
function ActivateCaravanQuestGUI()
	if caravans_arrived < 30/gvDiffLVL then
		GUIQuestTools.StartQuestInformation("Caravan", "", 1, 1)
		GUIQuestTools.UpdateQuestInformationString(caravans_arrived .. "/" .. round(30/gvDiffLVL) )
		GUIQuestTools.UpdateQuestInformationTooltip = function()
			XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Eskortierte Karavanen")
		end
	end
end
function QuestBuergermeister2()
	quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Gefährdete Karavanen",
	text	= "Karavanen nähern sich bald dem nordöstlichen Weg. @cr Ihr müsst sie sicher nach Drakon eskortieren.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BuergermeisterQuest2 = quest.id
end
gvCaravanCounters = {}
function CaravanStart()
	EndJob(CaravanTriggerID)
	for i = 1,CaravanPerWave do
		CreateEntity(8,Entities.PU_Travelling_Salesman,GetPosition("caravan_start"..i),"caravan_"..i)
		Move("caravan_"..i,"caravan_step1_"..i)
	end
	CaravanTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","CaravanStep",1,nil,{1})
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	if gvCaravanWave == 1 then
		ASP("caravan_start1",men,"Die Karavanen sind endlich eingetroffen.", true)
		ASP("caravan_start1",men,"Ihr solltet Eure Truppen versammeln und die Karavanen sicher eskortieren.", false)
		briefing.finished = function()
			gvCaravanWave = gvCaravanWave + 1
			gvCaravanCounters[gvCaravanWave] = StartCountdown(45*60/CaravanPerWave,CaravanStart,false)
		end;
	elseif gvCaravanWave >= 5 then
		ASP("caravan_start1",men,"Die letzten Karavanen sind eingetroffen.", true)
		ASP("caravan_start1",men,"Ihr solltet Eure Truppen versammeln und diese Karavanen besonders gut beschützen; es werden keine weiteren mehr eintreffen können...", false)
		briefing.finished = function()
		end;
	else
		ASP("caravan_start1",men,"Weitere Karavanen sind eingetroffen.", false)
		briefing.finished = function()
			gvCaravanWave = gvCaravanWave + 1
			gvCaravanCounters[gvCaravanWave] = StartCountdown(40*60/CaravanPerWave,CaravanStart,false)
		end;
	end
	StartBriefing(briefing);
end
function CaravanArrived()

	GUIQuestTools.UpdateQuestInformationString(caravans_arrived .. "/" .. round(30/gvDiffLVL) )
	if caravans_arrived >= 30/gvDiffLVL then
		GUIQuestTools.DisableQuestInformation()
		Logic.RemoveQuest(1,BuergermeisterQuest2)
		for i = 1, table.getn(gvCaravanCounters) do
			StopCountdown(gvCaravanCounters[i])
		end
		StopCountdown(CaravanEndCountdown)
		BuergermeisterBrief_2()
	end
	if gvCaravanWave == 5 and caravans_arrived < 30/gvDiffLVL then
		CaravanBriefingDefeat()
	end
end
function CaravanVanish()
	CaravanIDTable = {Logic.GetPlayerEntities(8, Entities.PU_Travelling_Salesman, 8)}
	caravans_arrived = caravans_arrived + CaravanIDTable[1]
	for i = 2,table.getn(CaravanIDTable) do
		DestroyEntity(CaravanIDTable[i])
	end
	CaravanArrived()
	if gvCaravanWave == 5 then
		CaravanEndCountdown = StartCountdown(1.5*60*gvDiffLVL,Briefing_CaravanEnd,false)
	end
end
function CaravanStep(_step)
	local posX,posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("caravan_step".._step.."_1"))
	local IDTable = {Logic.GetEntitiesInArea(Entities.PU_Travelling_Salesman,posX ,posY, 2000, 1)}
	if IDTable[1] > 0 then
		if _step < 8 then
			StartCountdown(30/gvDiffLVL,CaravanMoveToStep,false,nil,(_step+1))
			if _step < 4 then
				_G["WolfAttack".._step]()
			end
		else
			StartCountdown(6,CaravanVanish,false)
		end
		return true
	else

	end
end
function CaravanMoveToStep(_step)
	local pos = GetPosition("caravan_step"..(_step-1).."_1")
	local CaravanIDTable = {Logic.GetEntitiesInArea(Entities.PU_Travelling_Salesman, pos.X, pos.Y,2000,8)}
	table.remove(CaravanIDTable,1)
	for i = 1,table.getn(CaravanIDTable) do
		--Logic.MoveSettler(CaravanIDTable[i], Logic.GetEntityPosition(Logic.GetEntityIDByName("caravan_step".._step)))
		Move(CaravanIDTable[i],"caravan_step".._step.."_"..i)
	end
	CaravanTriggerID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","CaravanStep",1,nil,{_step})
end
function WolfAttack1()
	local attackersperwave
	local pos1 = GetPosition("WolfSpawn1")
	local pos2 = GetPosition("WolfSpawn2")

	if gvDiffLVL == 3 then
		attackersperwave = 5
	elseif gvDiffLVL == 2 then
		attackersperwave = 8
	elseif gvDiffLVL == 1 then
		attackersperwave = 14
	end
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos1
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos2
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave/2
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
end
function WolfAttack2()
	local attackersperwave
	local pos1 = GetPosition("WolfSpawn2")
	local pos2 = GetPosition("WolfSpawn3")
	if gvDiffLVL == 3 then
		attackersperwave = 5
	elseif gvDiffLVL == 2 then
		attackersperwave = 8
	elseif gvDiffLVL == 1 then
		attackersperwave = 11
	end
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos1
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos2
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave/2
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
end
function WolfAttack3()
	local attackersperwave
	local pos1 = GetPosition("WolfSpawn3")
	local pos2 = GetPosition("WolfSpawn4")
	if gvDiffLVL == 3 then
		attackersperwave = 5
	elseif gvDiffLVL == 2 then
		attackersperwave = 8
	elseif gvDiffLVL == 1 then
		attackersperwave = 14
	end
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos1
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = pos2
	army.rodeLength = Logic.WorldGetSize()
	army.strength = attackersperwave/2
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
end

function Briefing_CaravanEnd()
	if caravans_arrived < 30/gvDiffLVL then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Bergrutsch",men,"Oh nein! Das schlechte Wetter der letzten Woche hat die Wege zu den Nachbarstädten unpassierbar gemacht...", true)
		ASP("Bergrutsch",men,"Es werden wohl keine weiteren Karavanen mehr durchkommen..", true)
		briefing.finished = function()
			for i = 1, table.getn(gvCaravanCounters) do
				StopCountdown(gvCaravanCounters[i])
			end
		end;
		StartBriefing(briefing)
	end
end
function CaravanBriefingDefeat()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Major",bgm,"Oh weh das wird nicht reichen... Ihr habt nicht genügend Karavanen sicher zu uns eskortiert...", true)
	ASP("Major",bgm,"Mit so wenig Ressourcen können wir diesen Krieg nicht gewinnnen...", true)
	briefing.finished = function()
		Defeat()
	end;
	StartBriefing(briefing)
end
function BuergermeisterBrief_2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Major",bgm,"Seehr gut. Es sind genügend Karavanen eingetroffen. Nun sollten wir über genügend Ressourcen verfügen, um militärisch aktiv zu werden.", true)
	ASP("Bergrutsch",bgm,"Zumindest fürs Erste. Durch den Bergrutsch werden wir ja keine weiteren Lieferungen mehr erhalten...", true)
	ASP("MajorP5",bgm,"Ihr solltet mit den Befehlshabern der umliegenden Bergdörfern reden.", false)
	ASP("MajorP6",bgm,"Vielleicht können diese uns weitere für den Krieg benötigte Ressourcen schicken.", false)
	ASP("MajorP7",bgm,"Doch seid vorsichtig. Sie gelten Fremden gegenüber nicht als allzu freundlich...", false)
	ASP("Major",bgm,"Ach, hätte ich beinahe vergessen...", false)
	ASP("Drake",bgm,"...Sprecht außerdem mit Drake im Süden der Stadt.", true)
	AP{
		title = bgm,
		text = "Er befehligt die Truppen Drakons und wird euch die nächsten militärischen Schritte weiter erläutern.",
		position = GetPosition("Drake"),
		marker = STATIC_MARKER,
		dialogCamera = true,
	}
	briefing.finished = function()
		StopCountdown(CaravanEndCountdown)
		Logic.RemoveQuest(1,Buergermeister2Quest)
		MtVillagesMotiControlCdID = {}
		table.insert(gvFuncsToBeReloadedOnMapLoad, {fname = MtVillages_SetupMotiGUI, params = {}})
		MtVillages_SetupMotiGUI()
		MtVillagesMotiControlCdID[5] = StartCountdown(2*60,MtVillagesMotiControl,false,nil,5)
		MtVillagesMotiControlCdID[6] = StartCountdown(2*60,MtVillagesMotiControl,false,nil,6)
		MtVillagesMotiControlCdID[7] = StartCountdown(2*60,MtVillagesMotiControl,false,nil,7)
		EnableNpcMarker(GetEntityId("Drake"))
		EnableNpcMarker(GetEntityId("p8_guard1"))
		EnableNpcMarker(GetEntityId("p8_sett"))
		EnableNpcMarker(GetEntityId("MajorP5"))
		EnableNpcMarker(GetEntityId("MajorP6"))
		EnableNpcMarker(GetEntityId("MajorP7"))
		ActivateShareExploration( 1,8, true )
		MajorP5_1()
		MajorP6_1()
		MajorP7_1()
		P8_Guard_1()
		P8_Sett1()
		DrakeBrief_1()
		QuestDrake()
	end
	StartBriefing(briefing)
end

function P8_Guard_1()
	local BeiP8G = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "p8_guard1",
	Distance = 500,
	Callback = function()
		LookAt("p8_guard1","Dario");LookAt("Dario","p8_guard1")
		DisableNpcMarker(GetEntityId("p8_guard1"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("p8_guard1",gu_p8,"Einst war ich der wichtigste Brückenwärter der ganzen Gegend. @cr Ich trug den nobelsten Zwirn, verkehrte mit den wichtigsten Persönlichkeiten und hatte die schönste Frau weit und breit.", false)
		ASP("bridge_south",gu_p8,"Doch dann kam der Krieg und die Brücke wurde gesprengt. @cr Ich verlor meine Arbeit... @cr meine Frau... @cr mein Leben...", false)
		ASP("p8_guard1",gu_p8,"Durch meine Beziehungen bekam ich zumindest diese Arbeit hier als Wache des Bürgermeisters. @cr Aber es ist nicht mehr dasselbe...", false)
		ASP("xtrachest",gu_p8,"Einige meiner alten Reichtümer konnte ich verstecken. @cr Unerreichbar über normale Wege... @cr Unerreichbar für die dunklen Horden...", false)
		ASP("p8_guard1",gu_p8,"Nur erreichbar über einen unterirdischen Tunnel, den ich im alten Geräteschuppen gebuddelt habe. @cr Nun, wenn ihr den Schatz hebt, dürft ihr ihn behalten. @cr Ich habe dafür auf meinen alten Tagen keine Verwendung mehr.", false)
		briefing.finished = function()
			InitCaveData()
			StartSimpleJob("Caves")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiP8G)
end
function InitCaveData()
	CaveData = {In = {"secret",
			"isle_back"},
		Out = {"isle_start",
			"sec_back"}
	}
end
function Caves()
	for i = 1, table.getn(CaveData.In) do
		local posX, posY = Logic.GetEntityPosition(GetID(CaveData.In[i]))
		local data = {Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 200, 16)}
		if data[1] > 0 then
			for j = 2, data[1] + 1 do
				if Logic.IsHero(data[j]) == 1 then
					local newposX, newposY = Logic.GetEntityPosition(GetID(CaveData.Out[i]))
					TeleportSettler(data[j], newposX, newposY)
				end
			end
			break
		end
	end
end
function P8_Sett1()
	local BeiP8S = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "p8_sett",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("p8_sett"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("p8_sett",id);LookAt(id,"p8_sett")
		DisableNpcMarker(GetEntityId("p8_sett"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("p8_sett",set_p8,"Ihr seht so aus, als könntet ihr mir helfen.", false)
		ASP("valley",set_p8,"Etwas entfernt von hier liegt das wunderschöne Draketal. @cr Es liegt direkt hinter dem kleinen Fluss, der Drake.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Draketal? @cr Wirklich? @cr So heißt das Tal? Und wie heißt der Fluss?", true)
		ASP("p8_sett",set_p8,"Ob der Name Zufall ist oder unserem Heerführer nachempfunden ist? @cr Nun, wer weiß... @cr In jedem Fall trug die Stadt bereits vor Drakes Ankunft den Namen Drakon.", false)
		ASP("p8_sett",set_p8,"Aber ich schweife ab. @cr Nominell gehört das Tal noch zu unserer Einflusssphäre. @cr Daher wäre es wünschenswert, es als Siedlungsraum zu nutzen.", false)
		ASP("valley",set_p8,"Seid doch bitte so gut und errichtet dort ein Steinbergwerk, ein Lehmbergwerk sowie je zwei Gemüseplantagen und große Wohnhäuser.", false)
		briefing.finished = function()
			QuestSettlerP8()
			SettlerP8_BuildingsDone = 0
			StartSimpleJob("QuestSettlerP8DoneJob")
			StartSimpleJob("StonemineP8Job")
			StartSimpleJob("ClaymineP8Job")
			StartSimpleJob("ResidencesP8Job")
			StartSimpleJob("GrangeP8Job")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiP8S)
end
function QuestSettlerP8()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Die Erschließung des Draketals",
	text	= "Errichtet im Draketal ein Steinbergwerk, ein Lehmbergwerk sowie je zwei Gemüseplantagen und große Wohnhäuser. @cr @cr Das Draketal befindet sich direkt hinter dem kleinen Fluss, der durch Drakon fließt, der Drake.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SetP8Quest = quest.id
end
function StonemineP8Job()
	local posX, posY = Logic.GetEntityPosition(GetID("p8_stone"))
	local num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_StoneMine3, posX, posY, 500, 1)
	if num > 0 then
		ChangePlayer(id, 8)
		SettlerP8_BuildingsDone = SettlerP8_BuildingsDone + 1
		Message("Das Steinbergwerk im Draketal wurde erfolgreich fertiggestellt!")
		return true
	end
end
function ClaymineP8Job()
	local posX, posY = Logic.GetEntityPosition(GetID("p8_clay"))
	local num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_ClayMine3, posX, posY, 500, 1)
	if num > 0 then
		ChangePlayer(id, 8)
		SettlerP8_BuildingsDone = SettlerP8_BuildingsDone + 1
		Message("Das Lehmbergwerk im Draketal wurde erfolgreich fertiggestellt!")
		return true
	end
end
function ResidencesP8Job()
	local posX, posY = Logic.GetEntityPosition(GetID("valley"))
	local num, id1, id2 = Logic.GetPlayerEntitiesInArea(1, Entities.PB_Residence3, posX, posY, 3300, 2)
	if num > 1 then
		ChangePlayer(id1, 8)
		ChangePlayer(id2, 8)
		SettlerP8_BuildingsDone = SettlerP8_BuildingsDone + 2
		Message("Die Wohnhäuser im Draketal wurde erfolgreich fertiggestellt!")
		return true
	elseif num == 1 then
		local posX, posY = Logic.GetEntityPosition(GetID("p8_clay"))
		local num2, id2 = Logic.GetPlayerEntitiesInArea(1, Entities.PB_Residence3, posX, posY, 1600, 1)
		if num2 > 0 then
			ChangePlayer(id1, 8)
			ChangePlayer(id2, 8)
			SettlerP8_BuildingsDone = SettlerP8_BuildingsDone + 2
			Message("Die Wohnhäuser im Draketal wurde erfolgreich fertiggestellt!")
			return true
		end
	end
end
function GrangeP8Job()
	local posX, posY = Logic.GetEntityPosition(GetID("valley"))
	local num, id1, id2 = Logic.GetPlayerEntitiesInArea(1, Entities.CB_Grange, posX, posY, 3300, 2)
	if num > 1 and Logic.IsConstructionComplete(id1) == 1 and Logic.IsConstructionComplete(id2) == 1 then
		ChangePlayer(id1, 8)
		ChangePlayer(id2, 8)
		SettlerP8_BuildingsDone = SettlerP8_BuildingsDone + 2
		Message("Die Gemüseplantagen im Draketal wurde erfolgreich fertiggestellt!")
		return true
	end
end
function QuestSettlerP8DoneJob()
	if SettlerP8_BuildingsDone >= 6 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("p8_sett",set_p8,"Habt vielen Dank für die Erschließung des Draketals.", false)
		ASP("p8_sett",set_p8,"Die Stadtbewohner sind euch so dankbar, dass sie die Verteidiger überzeugen konnten, gemeinsam mit Euch in die Offensive zu gehen.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1, SetP8Quest)
			AttachNoArmyDefendersToNewArmy()
		end;
		StartBriefing(briefing)
		return true
	end
end

--**
function QuestDrake()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Ein alter Bekannter",
	text	= "Geht mit Dario zu Drake. @cr "..
	          "Möglicherweise kennt Drake einen Ausweg aus diesem Dilemma.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DrakeQuest = quest.id
end
--**
function MajorP5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiMj5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "MajorP5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("MajorP5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("MajorP5",id);LookAt(id,"MajorP5")
			DisableNpcMarker(GetEntityId("MajorP5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr...", true)
			ASP("MajorP5",mjP5,"Gut?.. Guuut?!?! Bis ihr hier aufgetaucht seid, war er das vielleicht.. Doch jetzt...", true)
			briefing.finished = function()
				Cutscene_P5(id)
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiMj5_1)
	end
end
function Cutscene_P5(_id)
	local cutsceneTable = {
		StartPosition = {
		position = GetPosition("MajorP5"), angle = 21, zoom = 2500, rotation = 10},
		Flights = 	{
			{
				position = GetPosition("MajorP5"),
				angle = 23,
				zoom = 2600,
				rotation = 50,
				duration = 5,
				action 	=	function()

				end,
				title = " @color:180,0,240 " .. GetNPCDefaultNameByID(_id),
				text = " @color:230,0,0 Was für ein unfreundlicher Kerl... Wir sollten dennoch versuchen, Kontakt zu den Einwohnern dieses Dorfes aufzunehmen ",
			},
			{
				position = GetPosition("cutscene_p5end"),
				angle = 27,
				zoom = 2800,
				rotation = 130,
				duration = 15,
				action 	=	function()

				end,
				title = " @color:180,0,240 " .. GetNPCDefaultNameByID(_id),
				text = " @color:230,0,0 Wenn nur Pilgrim hier wäre... Er schien immer einen guten Draht zu diesen Bergbewohnern zu haben...",
			}
		},
		Callback = function()
			if MtVillagesDiploCheck(5) == true then
				EnableNpcMarker(GetEntityId("serf_p5"))
				EnableNpcMarker(GetEntityId("settler_p5"))
				EnableNpcMarker(GetEntityId("farmer_p5"))
				EnableNpcMarker(GetEntityId("miner_p5"))
				EnableNpcMarker(GetEntityId("cavalry_p5"))
				Serf_P5_1()
				Settler_P5_1()
				Farmer_P5_1()
				Miner_P5_1()
				Cavalry_P5_1()
			end
		end
	}
	Start_Cutscene(cutsceneTable)
end
function Serf_P5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiSerf_P5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "serf_p5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("serf_p5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("serf_p5",id);LookAt(id,"serf_p5")
			DisableNpcMarker(GetEntityId("serf_p5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("serf_p5",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Kann man euch oder den anderen Dörfern irgendwie behilflich sein?", true)
			ASP("serf_p5",ser_p5,"Aber ja doch, gut dass ihr fragt. @cr Ich bin für den Siedlungsbau unseres Dorfes zuständig.", true)
			ASP("stonemine_p5",ser_p5,"Seht ihr diesen Steinbruch dort hinten? @cr Er ist ein zwar ein wenig abgelegen, würde uns aber zu wirtschaftlichem Aufschwung verhelfen.", false)
			ASP("stonemine_p5",ser_p5,"Errichtet dort für uns ein Steinbergwerk sowie einen Gutshof und ein großes Wohnhaus. @cr @cr Das würde euren Ruf in diesem Dorf sicherlich deutlich verbessern.", true)
			briefing.finished = function()
				QuestBauFuerSerfP5()
				VorbereitungSerfP5()
			end;
		StartBriefing(briefing)
		end}
		SetupExpedition(BeiSerf_P5_1)
	end
end
function QuestBauFuerSerfP5()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Siedlungspläne von Güldfurt",
	text	= "Der Siedlungsplaner von Güldfurt bittet Euch darum, im südwestlichen Tal ein Steinbergwerk sowie einen Gutshof und ein großes Wohnhaus zu errichten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BauFuerSerfP5Quest = quest.id
end
--**
function VorbereitungSerfP5()
	StartSimpleJob("FertigMeldungSerfP5")
	StartSimpleJob("AbfrageHausSerfP5")
	StartSimpleJob("AbfrageFarmSerfP5")
	StartSimpleJob("AbfrageMineSerfP5")
	local pos = GetPosition("stonemine_p5")
	GUI.CreateMinimapMarker(pos.X, pos.Y, 2)
	--TPointerP5Haus = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,11500,26200)
	--TPointerP5Farm = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,11500,26200)
end
function AbfrageHausSerfP5()
		idResP5 = SucheAufDerWelt(1,Entities.PB_Residence3,3000,GetPosition("stonemine_p5"))
		if table.getn(idResP5) > 0 and Logic.IsConstructionComplete(idResP5[1]) == 1 then
		idResP5 = idResP5[1]
		--Logic.DestroyEffect(TPointerP5Haus)
		ChangePlayer(idResP5,5)
		gvResP5 = 1
		return true
	end
end
--**
function AbfrageFarmSerfP5()
	idFarP5 = SucheAufDerWelt(1,Entities.PB_Farm3,3000,GetPosition("stonemine_p5"))
	if table.getn(idFarP5) > 0 and Logic.IsConstructionComplete(idFarP5[1]) == 1 then
		idFarP5 = idFarP5[1]
		--Logic.DestroyEffect(TPointerP5Farm)
		ChangePlayer(idFarP5,5)
		gvFarP5 = 1
		return true
	end
end
--**
function AbfrageMineSerfP5()
		idMinP5 = SucheAufDerWelt(1,Entities.PB_StoneMine3,3000,GetPosition("stonemine_p5"))
		if table.getn(idMinP5) > 0 and Logic.IsConstructionComplete(idMinP5[1]) == 1 then
		idMinP5 = idMinP5[1]
		ChangePlayer(idMinP5,5)
		gvMinP5 = 1
		return true
	end
end
--**
function FertigMeldungSerfP5()
	if gvResP5 == 1 and gvFarP5 == 1 and gvMinP5 == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local pos = GetPosition("stonemine_p5")
		GUI.DestroyMinimapPulse(pos.X,pos.Y)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dari,"Die gewünschten Gebäude wurden fertiggestellt.", true)
		ASP("serf_p5",ser_p5,"Vielen Dank für Eure Hilfe. Ich werde den anderen Dorfbewohnern von Eurem Großmut berichten.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,BauFuerSerfP5Quest)
			gvMoti.Villages[5] = gvMoti.Villages[5] + round(15*gvDiffLVL)
			gvLastTimeVillageHelped[5] = Logic.GetTime()
			Message("Motivationsgewinn bei Güldfurt: ".. round(15*gvDiffLVL).."")
		end;
		StartBriefing(briefing);
		return true
	end
end
function Settler_P5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiSettler_P5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "settler_p5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("settler_p5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("settler_p5",id);LookAt(id,"settler_p5")
			DisableNpcMarker(GetEntityId("settler_p5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p5",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Kann man euch oder den anderen Dörfern irgendwie behilflich sein?", true)
			ASP("settler_p5",set_p5,"Aber ja doch, gut dass ihr fragt. @cr Ich bin für den Wohnungsbau unseres Dorfes zuständig.", true)
			ASP("settler_p5",set_p5,"Ihr könntet uns helfen, indem ihr uns Holz und Steine schickt, sodass wir unsere Häuser ausbauen können.", false)
			briefing.finished = function()
				QuestAusbauFuerSettlerP5()
				TributAusbauSettlerP5()
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiSettler_P5_1)
	end
end
function QuestAusbauFuerSettlerP5()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Wohnungs-Ausbaupläne von Güldfurt",
	text	= "Der Wohnplaner von Güldfurt bittet Euch darum, Holz und Steine an Güldfurt zu senden, sodass sie ihre Wohnhäuser ausbauen können.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestAusbauFuerSettlerP5Quest = quest.id
end
function TributAusbauSettlerP5()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(6000/gvDiffLVL).." Holz und ".. round(12000/gvDiffLVL).." Steine an Güldfurt"
	tribute.cost = {Wood = round(6000/gvDiffLVL), Stone = round(12000/gvDiffLVL)}
	tribute.Callback = TributePaidAusbauSettlerP5
	TributeAusbauSettlerP5 = AddTribute(tribute)
end
function TributePaidAusbauSettlerP5()
	if CaravansOnItsWay then
		AddWood(round(6000/gvDiffLVL))
		AddStone(round(12000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributAusbauSettlerP5()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(6/gvDiffLVL) do
		CreateEntity(5,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P5_res_"..i)
	end

	local questcaravanmovetoP5 = {
	Unit = "caravan_P1_to_P5_res_",
	Waypoint = {
		 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
		 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
		 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
		 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
		 {Name = "P5_end_pos",		WaitTime = 2}
	},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddWood(5,round(6000/gvDiffLVL))
			AddStone(5,round(12000/gvDiffLVL))
			UpgradeBuilding("residence_p5_1")
			UpgradeBuilding("residence_p5_2")
			UpgradeBuilding("residence_p5_3")
			UpgradeBuilding("residence_p5_4")
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p5",set_p5,"Vielen Dank für die Ressourcenlieferung", true)
			ASP("settler_p5",set_p5,"Wir können nun wie geplant unsere Wohnhäuser weiter ausbauen. Ich werde den anderen Dorfbewohnern von Eurer Hilfsbereitschaft berichten.", true)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestAusbauFuerSettlerP5Quest)
				gvMoti.Villages[5] = gvMoti.Villages[5] + round(15*gvDiffLVL)
				gvLastTimeVillageHelped[5] = Logic.GetTime()
				Message("Motivationsgewinn bei Güldfurt: ".. round(15*gvDiffLVL).."")
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p5",set_p5,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributAusbauSettlerP5()
			end;
			StartBriefing(briefing);
		end
	end,
	ArrivedCount = 0,
	NumCaravan = round(6/gvDiffLVL),
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP5)

end
function Farmer_P5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiFarmer_P5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "farmer_p5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("farmer_p5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("farmer_p5",id);LookAt(id,"farmer_p5")
			DisableNpcMarker(GetEntityId("farmer_p5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("farmer_p5",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Kann man euch oder den anderen Dörfern irgendwie behilflich sein?", true)
			ASP("farmer_p5",far_p5,"Es gibt hier immer genug zu tun. @cr Ich bin für die Nahrungsversorgung unseres schönen Dorfes zuständig.", true)
			ASP("farmer_p5",far_p5,"Unsere Siedlung wächst und gedeiht. Damit wir auch in Zukunft unabhängig von fremden Nahrungslieferungen sein können, müssen wir auch unsere Bauernhöfe und Mühlen ausbauen.", false)
			ASP("farmer_p5",far_p5,"Schickt uns doch bitte etwas Holz und Stein.", true)
			briefing.finished = function()
				QuestAusbauFuerFarmerP5()
				TributAusbauFarmerP5()
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiFarmer_P5_1)
	end
end
function QuestAusbauFuerFarmerP5()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Farm-Ausbaupläne von Güldfurt",
	text	= "Der Bauernvorsteher von Güldfurt bittet Euch darum, Holz und Steine an Güldfurt zu senden, sodass sie ihre Bauernhöfe und Mühlen ausbauen können.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestAusbauFuerFarmerP5Quest = quest.id
end
function TributAusbauFarmerP5()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(6000/gvDiffLVL).." Holz und ".. round(9000/gvDiffLVL).." Steine an Güldfurt"
	tribute.cost = {Wood = round(6000/gvDiffLVL), Stone = round(9000/gvDiffLVL)}
	tribute.Callback = TributePaidAusbauFarmerP5
	TributeAusbauFarmerP5 = AddTribute(tribute)
end
function TributePaidAusbauFarmerP5()
	if CaravansOnItsWay then
		AddWood(round(6000/gvDiffLVL))
		AddStone(round(9000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributAusbauFarmerP5()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(6/gvDiffLVL) do
		CreateEntity(5,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P5_farm_"..i)
	end

	local questcaravanmovetoP5_farm = {
	Unit = "caravan_P1_to_P5_farm_",
	Waypoint = {
		 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
		 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
		 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
		 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
		 {Name = "P5_end_pos",		WaitTime = 2}
	},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddWood(5,round(6000/gvDiffLVL))
			AddStone(5,round(9000/gvDiffLVL))
			UpgradeBuilding("farm_p5_1")
			UpgradeBuilding("farm_p5_2")
			UpgradeBuilding("farm_p5_3")
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("farmer_p5",far_p5,"Vielen Dank für die Ressourcenlieferung", true)
			ASP("farmer_p5",far_p5,"Wir können nun wie geplant unsere Bauernhöfe weiter ausbauen. Eure Großzügigkeit wird sich hier im Dorf sicher schnell rumsprechen.", true)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestAusbauFuerFarmerP5Quest)
				gvMoti.Villages[5] = gvMoti.Villages[5] + round(15*gvDiffLVL)
				gvLastTimeVillageHelped[5] = Logic.GetTime()
				Message("Motivationsgewinn bei Güldfurt: ".. round(15*gvDiffLVL).."")
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("farmer_p5",far_p5,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributAusbauFarmerP5()
			end;
			StartBriefing(briefing);
		end
	end,
	ArrivedCount = 0,
	NumCaravan = round(6/gvDiffLVL),
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP5_farm)

end
function Miner_P5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiMiner_P5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "miner_p5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("miner_p5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("miner_p5",id);LookAt(id,"miner_p5")
			DisableNpcMarker(GetEntityId("miner_p5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("miner_p5",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Kann man euch oder den anderen Dörfern irgendwie behilflich sein?", true)
			ASP("miner_p5",min_p5,"Nun... sicher... Unsere Ressourcenproduktion läuft in letzter Zeit eher schleppend...", true)
			ASP("miner_p5",min_p5,"Liefert uns Holz, Lehm und Steine, sodass wir unsere Gruben zu Stollen ausbauen können.", false)
			briefing.finished = function()
				QuestAusbauFuerMinerP5()
				TributAusbauMinerP5()
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiMiner_P5_1)
	end
end
function QuestAusbauFuerMinerP5()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Grubenausbauten von Güldfurt",
	text	= "Der Minenvorarbeiter von Güldfurt bittet Euch darum, Holz, Lehm und Steine an Güldfurt zu senden, sodass sie ihre Gruben zu Stollen ausbauen können.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestAusbauFuerMinerP5Quest = quest.id
end
function TributAusbauMinerP5()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(6000/gvDiffLVL).." Holz, ".. round(6000/gvDiffLVL).." Lehm und ".. round(6000/gvDiffLVL).." Steine an Güldfurt"
	tribute.cost = { Wood = round(6000/gvDiffLVL), Clay = round(6000/gvDiffLVL), Stone = round(6000/gvDiffLVL) }
	tribute.Callback = TributePaidAusbauMinerP5
	TributeAusbauMinerP5 = AddTribute(tribute)
end
function TributePaidAusbauMinerP5()
	if CaravansOnItsWay then
		AddWood(round(6000/gvDiffLVL))
		AddClay(round(6000/gvDiffLVL))
		AddStone(round(6000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributAusbauMinerP5()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(6/gvDiffLVL) do
		CreateEntity(5,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P5_mine_"..i)
	end

	local questcaravanmovetoP5_mine = {
	Unit = "caravan_P1_to_P5_mine_",
	Waypoint = {
		 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
		 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
		 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
		 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
		 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
		 {Name = "P5_end_pos",		WaitTime = 2}
	},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddWood(5,round(6000/gvDiffLVL))
			AddClay(5,round(6000/gvDiffLVL))
			AddStone(5,round(6000/gvDiffLVL))
			UpgradeBuilding("ironmine_p5")
			UpgradeBuilding("goldmine_p5")
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("miner_p5",min_p5,"Vielen Dank für die Ressourcenlieferung", true)
			ASP("miner_p5",min_p5,"Wir können nun wie geplant unsere Gruben weiter ausbauen. Ich werde den anderen Dörflern von Euren Taten berichten.", true)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestAusbauFuerMinerP5Quest)
				gvMoti.Villages[5] = gvMoti.Villages[5] + round(15*gvDiffLVL)
				gvLastTimeVillageHelped[5] = Logic.GetTime()
				Message("Motivationsgewinn bei Güldfurt: ".. round(15*gvDiffLVL).."")
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("miner_p5",min_p5,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributAusbauMinerP5()
			end;
			StartBriefing(briefing);
		end
	end,
	NumCaravan = round(6/gvDiffLVL),
	ArrivedCount = 0,
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP5_mine)

end
function Cavalry_P5_1()
	if MtVillagesDiploCheck(5) == true then
		local BeiCavalry_P5_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "cavalry_p5",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("cavalry_p5"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("cavalry_p5",id);LookAt(id,"cavalry_p5")
			DisableNpcMarker(GetEntityId("cavalry_p5"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("cavalry_p5",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Kann man euch oder den anderen Dörflern irgendwie behilflich sein?", true)
			ASP("cavalry_p5",cav_p5,"Das kommt ganz darauf an...", true)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Worauf denn?", true)
			ASP("cavalry_p5",cav_p5,"So lasst mich doch ausreden...", true)
			ASP("cavalry_p5",cav_p5,"Unsere Armee könnte ein wenig Zuwachs vertragen. Entsendet uns einige Eurer besten Reiter und ein paar große Kanonen wären auch ganz fein.", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Geht das auch etwas konkreter? Und habt ihr nicht einen Stall und eine Kanonengießerei?", true)
			ASP("cavalry_p5",cav_p5,"Wollt ihr uns nun helfen oder nicht? Zeigt uns wie man die Reiter ausbildet und die Kanonen rekrutiert und entsendet uns dann die nötigen Ressourcen.", true)
			briefing.finished = function()
				QuestTruppenFuerCavalryP5()
				VorbereitungCavalryP5()
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiCavalry_P5_1)
	end
end
function QuestTruppenFuerCavalryP5()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Eine Armee für Güldfurt",
	text	= "Der Oberbefehlshaber der Armee von Güldfurt bittet Euch darum, je ein Trupp schwere und leichte Kavallerie (Stufe 1) zu Trainingszwecken sowie eine Eisenkanone zu entsenden.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestTruppenFuerCavalryP5Quest = quest.id
end
function VorbereitungCavalryP5()
	local trooptable = {
		AreaPos = "cavalry_p5",
		AreaSize = 2000,
		TroopTypes = {
			{UpgradeCategories.LeaderCavalry,1},
			{UpgradeCategories.LeaderHeavyCavalry,1},
			{UpgradeCategories.Cannon3,1}
		},
		Callback = function()
			AddSulfur(5,5000)
			AddWood(5,5000)
			GUI.BuyCannon(Logic.GetEntityIDByName("foundry_p5"), Entities.PV_Cannon3)
			GUI.ActivateAutoFillAtBarracks(Logic.GetEntityIDByName("stable_p5"))
			GUI.BuyLeader(Logic.GetEntityIDByName("stable_p5"), UpgradeCategories.LeaderCavalry)
			GUI.BuyLeader(Logic.GetEntityIDByName("stable_p5"), UpgradeCategories.LeaderHeavyCavalry)
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("cavalry_p5",cav_p5,"Vielen Dank für Eure Truppenentsendung.", true)
			ASP("cavalry_p5",cav_p5,"Unsere Armee trainiert nun mit euren Truppen und wir können nun auch Reiter ausbilden und Kanonen konstruieren. @cr @cr Ich werde den anderen Soldaten unverzüglich verkünden, wem wir den Zuwachs zu verdanken haben.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestTruppenFuerCavalryP5Quest)
				gvMoti.Villages[5] = gvMoti.Villages[5] + round(15*gvDiffLVL)
				gvLastTimeVillageHelped[5] = Logic.GetTime()
				Message("Motivationsgewinn bei Güldfurt: ".. round(15*gvDiffLVL).."")
			end;
			StartBriefing(briefing);
			return true
		end}

	SetupBuildTroops(trooptable)
end

function MajorP6_1()
	local BeiMj6_1 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "MajorP6",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("MajorP6"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("MajorP6",id);LookAt(id,"MajorP6")
		DisableNpcMarker(GetEntityId("MajorP6"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag der Herr. @cr Wir suchen nach Verbündeten gegen die wieder erstarkenden dunklen Horden, die das Land terrorisieren.", false)
		ASP("MajorP6",mjP6,"Stellt euch das mal nicht so leicht vor. @cr Wir sind einfache Söldner.", true)
		ASP("MajorP6",mjP6,"... Und es lief in letzter Zeit nicht allzu gut für uns. @cr Schlechte Auftragslage... @cr Missernten ... @cr Keine Beute mehr zu holen ...", false)
		ASP("MajorP6",mjP6,"Kommt den Bitten unsrer Dörfler nach und wir überdenken Euer Ansinnen.", true)
		briefing.finished = function()
			Cutscene_P6()
		end;
		StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMj6_1)
end
function Cutscene_P6()
	local cutsceneTable = {
    StartPosition = {
		position = GetPosition("MajorP6"), angle = 21, zoom = 2500, rotation = 0},
		Flights = {
			{
			position = GetPosition("MajorP6"),
			angle = 23,
			zoom = 2900,
			rotation = 0,
			duration = 4,
			action 	=	function()

			end,
			title = " @color:180,0,240 Dario",
			text = " @color:230,0,0 Hmm, auch andere haben wohl schwere Zeiten erlebt... Wir sollten versuchen, den Einwohnern dieses Dorfes zu helfen ",
			},
			{
			position = GetPosition("cutscene_p6end"),
			angle = 27,
			zoom = 3100,
			rotation = 0,
			duration = 15,
			action 	=	function()

			end,
			title = " @color:180,0,240 Dario",
			text = " @color:230,0,0 Wir sollten aber Vorsicht walten. @cr Die Siedler hier wirken wie Krieger der Barbaren, die uns jederzeit in den Rücken fallen könnten.",
			}
		},
		Callback = function()
			if MtVillagesDiploCheck(6) == true then
				EnableNpcMarker(GetEntityId("guard_p6"))
				EnableNpcMarker(GetEntityId("settler_p6"))
				EnableNpcMarker(GetEntityId("farmer_p6"))
				Guard_P6_1()
				Settler_P6_1()
				Farmer_P6_1()
			end
		end

	}
	Start_Cutscene(cutsceneTable)
end
function Guard_P6_1()
	if MtVillagesDiploCheck(6) == true then
		local BeiGuard_P6_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "guard_p6",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("guard_p6"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("guard_p6",id);LookAt(id,"guard_p6")
			DisableNpcMarker(GetEntityId("guard_p6"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("guard_p6",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Guten Tag, der Herr. @cr "..
				"Wieso das langgezogene Gesicht?", true)
			ASP("guard_p6",gu_p6,"Wieso ich so mies dreinschaue? @cr nun das kann ich euch sagen.", false)
			ASP("guard_p6",gu_p6,"Wir bekommen kaum noch Aufträge... Viele können hier kaum noch ihre Familien versorgen...", true)
			ASP("cutscene_start1",gu_p6,"Und wenn das nicht schon genug wäre, hat ein schweres Unwetter auch noch unseren Steinbruch unweit der Siedlung verwüstet...", false)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wir sollten die alte Steinmine wieder aufbauen und mit Haus und Hof versorgen. @cr Über die mittlere Ausbaustufe werden sich die Dörfler sicherlich freuen.", true)
			briefing.finished = function()
				QuestStonemineP6()
				ConditionsQuestStonemineP6()
			end;
			StartBriefing(briefing)
		end
		}
		SetupExpedition(BeiGuard_P6_1)
	else
		DisableNpcMarker(GetEntityId("guard_p6"))
	end
end
function QuestStonemineP6()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Ein Steinstollen für Ehernberg",
	text	= "Der Keulenschwinger von Ehernberg klagte, dass ein schweres Unwetter den Steinbruch unweit der Siedlung verwüstet hatte. @cr Wir sollten dort einen Steinstollen sowie eine Mühle und ein mittleres Wohnhaus errichten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestStonemineP6Quest = quest.id
end
function ConditionsQuestStonemineP6()
	GuardQuestP6Counter = 0
	StartSimpleJob("ControlStonemineBuiltP6")
	StartSimpleJob("ControlFarmBuiltP6")
	StartSimpleJob("ControlResidenceBuiltP6")
	--
	StartSimpleJob("ControlP6StonemineQuestFullfilled")
end
function ControlStonemineBuiltP6()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_StoneMine2, Entities.PB_StoneMine3),CEntityIterator.InCircleFilter(56000, 29600, 500)) do
		Message("Der Steinstollen für Ehernberg wurde erfolgreich errichtet.")
		ChangePlayer(eID, 6)
		GuardQuestP6Counter = GuardQuestP6Counter + 1
		return true
	end
end
function ControlFarmBuiltP6()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Farm2, Entities.PB_Farm3),CEntityIterator.InCircleFilter(56000, 29600, 3500)) do
		Message("Die Mühle für Ehernberg nahe des Steinbruchs wurde erfolgreich errichtet.")
		ChangePlayer(eID, 6)
		GuardQuestP6Counter = GuardQuestP6Counter + 1
		return true
	end
end
function ControlResidenceBuiltP6()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Residence2, Entities.PB_Residence3),CEntityIterator.InCircleFilter(56000, 29600, 3500)) do
		Message("Das Wohnhaus für Ehernberg nahe des Steinbruchs wurde erfolgreich errichtet.")
		ChangePlayer(eID, 6)
		GuardQuestP6Counter = GuardQuestP6Counter + 1
		return true
	end
end
function ControlP6StonemineQuestFullfilled()
	if GuardQuestP6Counter >= 3 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("cutscene_start1",dari,"Wir haben Euren Steinbruch wieder im alten Glanz erscheinen lassen. @cr Ihr könnt ihn jederzeit beziehen.", false)
		ASP("guard_p6",gu_p6,"Habt vielen Dank. @cr Nun müssen wir unsere Steine nicht mehr von unseren netten Nachbarn ... ähem beziehen...", true)
		briefing.finished = function()
			Logic.RemoveQuest(1,QuestStonemineP6Quest)
			gvMoti.Villages[6] = gvMoti.Villages[6] + round(20*gvDiffLVL)
			gvLastTimeVillageHelped[6] = Logic.GetTime()
			Message("Motivationsgewinn bei Ehernberg: ".. round(20*gvDiffLVL).."")
		end;
		StartBriefing(briefing);
		return true
	end
end
function Settler_P6_1()
	if MtVillagesDiploCheck(6) == true then
		local BeiSet_P6_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "settler_p6",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("settler_p6"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("settler_p6",id);LookAt(id,"settler_p6")
			DisableNpcMarker(GetEntityId("settler_p6"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			local briefingData = gvBriefingLinesByBriefAndHero.Settler_P6_1[Logic.GetEntityName(id)]
			for i = 1, table.getn(briefingData) do
				ASP(unpack(briefingData[i]))
			end
			briefing.finished = function()
				QuestSettlerP6_1()
				TributSettlerP6_1()
			end;
			StartBriefing(briefing)
		end
		}
		SetupExpedition(BeiSet_P6_1)
	else
		DisableNpcMarker(GetEntityId("settler_p6"))
	end
end
function QuestSettlerP6_1()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Der Meistbietende von Ehernberg",
	text	= "Olaf Olafsson ist wohl nur mit Goldmünzen zu überzeugen. @cr Wir sollten ihm einige schicken.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestSettlerP6_1ID = quest.id
end
function TributSettlerP6_1()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(18000/gvDiffLVL).." Taler an Ehernberg"
	tribute.cost = { Gold = round(18000/gvDiffLVL) }
	tribute.Callback = TributePaidSettlerP6_1
	TributeSettlerP6_1 = AddTribute(tribute)
end
function TributePaidSettlerP6_1()
	if CaravansOnItsWay then
		AddGold(round(18000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributSettlerP6_1()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(6/gvDiffLVL) do
		CreateEntity(6,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P6_settler_"..i)
	end

	local questcaravanmovetoP6_settler = {
	Unit = "caravan_P1_to_P6_settler_",
	Waypoint = {
				 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
				 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
				 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
				 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
				 {Name = "caravan_start5",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "settler_p6",		WaitTime = 2}
				},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddGold(6,round(18000/gvDiffLVL))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p6",set_p6,"Oh, schön viele glitzernde Münzen", true)
			ASP("settler_p6",set_p6,"Nun, das ging aber zu leicht. @cr Ich bin noch nicht überzeugt. Und unserer Dorfältester ebenfalls nicht. @cr Ihr habt doch sicherlich noch mehr in der Tasche!", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestSettlerP6_1ID)
				QuestSettlerP6_2()
				TributSettlerP6_2()
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p6",set_p6,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributSettlerP6_1()
			end;
			StartBriefing(briefing);
		end
	end,
	NumCaravan = round(6/gvDiffLVL),
	ArrivedCount = 0,
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP6_settler)

end
function QuestSettlerP6_2()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Der Meistbietende von Ehernberg?",
	text	= "Olaf Olafsson konnte mit unserer Lieferung noch nicht überzeugt werden. @cr Vielleicht können wir ja noch mehr Goldmünzen entbehren...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestSettlerP6_2ID = quest.id
end
function TributSettlerP6_2()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(30000/gvDiffLVL).." Taler an Ehernberg"
	tribute.cost = { Gold = round(30000/gvDiffLVL) }
	tribute.Callback = TributePaidSettlerP6_2
	TributeSettlerP6_2 = AddTribute(tribute)
end
function TributePaidSettlerP6_2()
	if CaravansOnItsWay then
		AddGold(round(30000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributSettlerP6_2()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(8/gvDiffLVL) do
		CreateEntity(6,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P6_settler_"..i)
	end

	local questcaravanmovetoP6_settler = {
	Unit = "caravan_P1_to_P6_settler_",
	Waypoint = {
				 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
				 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
				 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
				 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
				 {Name = "caravan_start5",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "settler_p6",		WaitTime = 2}
				},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddGold(6,round(30000/gvDiffLVL))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p6",set_p6,"Ihr konntet tatsächlich noch mehr Münzen auftreiben. @cr Nun, ich will gar nicht wissen, wie...", true)
			ASP("settler_p6",set_p6,"Ihr habt mich überzeugt. @cr Ich werde ein gutes Wort für euch beim Dorfältesten einlegen.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,QuestSettlerP6_2ID)
				gvMoti.Villages[6] = gvMoti.Villages[6] + round(30*gvDiffLVL)
				gvLastTimeVillageHelped[6] = Logic.GetTime()
				Message("Motivationsgewinn bei Ehernberg: ".. round(30*gvDiffLVL).."")
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("settler_p6",set_p6,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributSettlerP6_2()
			end;
			StartBriefing(briefing);
		end
	end,
	NumCaravan = round(8/gvDiffLVL),
	ArrivedCount = 0,
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP6_settler)

end
function Farmer_P6_1()
	if MtVillagesDiploCheck(6) == true then
		local BeiFar_P6_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "farmer_p6",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("farmer_p6"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("farmer_p6",id);LookAt(id,"farmer_p6")
			DisableNpcMarker(GetEntityId("farmer_p6"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			local briefingData = gvBriefingLinesByBriefAndHero.Farmer_P6_1[Logic.GetEntityName(id)]
			for i = 1, table.getn(briefingData) do
				ASP(unpack(briefingData[i]))
			end
			briefing.finished = function()
				QuestFarmerP6()
				ConditionQuestFarmerP6()
			end;
			StartBriefing(briefing)
		end}
		SetupExpedition(BeiFar_P6_1)
	else
		DisableNpcMarker(GetEntityId("farmer_p6"))
	end
end
function QuestFarmerP6()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Der vermissten Schafe von Ehernberg",
	text	= "Harald der Zermalmer beklagt das Fehlen zweier Schafe. @cr Ihr sollt sie für ihn einfangen und bis zum Gatter treiben.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestFarmerP6 = quest.id
end
function ConditionQuestFarmerP6()
	SheepsGatheredP6Quest = 0
	StartSimpleJob("HeroGatherSheep1")
	StartSimpleJob("HeroGatherSheep2")
	StartSimpleJob("Sheep1ArrivedAtGate")
	StartSimpleJob("Sheep2ArrivedAtGate")
	StartSimpleJob("AllSheepsGatheredP6Check")
end
function HeroGatherSheep1()
	if IsNear("Dario", "sheep1", 300) then
		if Counter.Tick2("HeroSheepGathering_1_Counter_1", round(10/gvDiffLVL)) then
			local rng = math.random(1,4)
			if rng == 1 then
				ReplaceEntity("sheep1", Entities.CU_Sheep3_Idle)
				InitNPC("sheep1")
				SetNPCFollow("sheep1","Dario",500,10000,nil)
				return true
			end
		end
	end
	if IsNear("Ari", "sheep1", 300) then
		if Counter.Tick2("HeroSheepGathering_1_Counter_2", round(10/gvDiffLVL)) then
			local rng = math.random(1,4)
			if rng == 1 then
				ReplaceEntity("sheep1", Entities.CU_Sheep3_Idle)
				InitNPC("sheep1")
				SetNPCFollow("sheep1","Ari",500,10000,nil)
				return true
			end
		end
	end
end
function HeroGatherSheep2()
	if IsNear("Dario", "sheep2", 300) then
		if Counter.Tick2("HeroSheepGathering_2_Counter_1", round(10/gvDiffLVL)) then
			local rng = math.random(1,4)
			if rng == 1 then
				ReplaceEntity("sheep2", Entities.CU_Sheep1_Idle)
				InitNPC("sheep2")
				SetNPCFollow("sheep2","Dario",500,10000,nil)
				return true
			end
		end
	end
	if IsNear("Ari", "sheep2", 300) then
		if Counter.Tick2("HeroSheepGathering_2_Counter_2", round(10/gvDiffLVL)) then
			local rng = math.random(1,4)
			if rng == 1 then
				ReplaceEntity("sheep2", Entities.CU_Sheep3_Idle)
				InitNPC("sheep2")
				SetNPCFollow("sheep2","Ari",500,10000,nil)
				return true
			end
		end
	end
end
function Sheep1ArrivedAtGate()
	if IsNear("sheep1", "sheep_gateP6", 400) then
		if Logic.GetEntityType(GetID("sheep1")) == Entities.CU_Sheep3_Idle then
			SetNPCFollow("sheep1",nil)
			ReplaceEntity("sheep1", Entities.XA_Sheep3_S6)
		end
		Message("Es wurde erfolgreich ein Schaf ins Gatter getrieben!")
		SheepsGatheredP6Quest = SheepsGatheredP6Quest + 1
		CUtil.EntitySetPosition(GetID("sheep1"), 53115, 41703)
		return true
	end
end
function Sheep2ArrivedAtGate()
	if IsNear("sheep2", "sheep_gateP6", 400) then
		if Logic.GetEntityType(GetID("sheep2")) == Entities.CU_Sheep1_Idle then
			SetNPCFollow("sheep2",nil)
			ReplaceEntity("sheep2", Entities.XA_Sheep1_S6)
		end
		Message("Es wurde erfolgreich ein Schaf ins Gatter getrieben!")
		SheepsGatheredP6Quest = SheepsGatheredP6Quest + 1
		CUtil.EntitySetPosition(GetID("sheep1"), 53405, 42055)
		return true
	end
end
function AllSheepsGatheredP6Check()
	if SheepsGatheredP6Quest >= 2 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("farmer_p6",far_p6,"Alle Schafe sind wieder wo sie hingehören. @cr Vielen Dank für Eure Hilfe", true)
		ASP("farmer_p6",far_p6,"Wie versprochen, werde ich ein gutes Wort für Euch beim Dorfältesten einlegen.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,QuestFarmerP6)
			gvMoti.Villages[6] = gvMoti.Villages[6] + round(30*gvDiffLVL)
			gvLastTimeVillageHelped[6] = Logic.GetTime()
			Message("Motivationsgewinn bei Ehernberg: ".. round(30*gvDiffLVL).."")
		end;
		StartBriefing(briefing);
		return true
	end
end

function MajorP7_1()
	local BeiMj7_1 = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "MajorP7",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("MajorP7"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("MajorP7",id);LookAt(id,"MajorP7")
		DisableNpcMarker(GetEntityId("MajorP7"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Werter Herr. @cr Wir ersuchen eure Unterstützung gegen die wiederaufflackernde Bedrohung der dunklen Horden. @cr Varg, Mary und Kerberos Horden belagern Drakon und wir benötigen eure Hilfe.", false)
		ASP("MajorP7",mjP7,"Soso unsere Hilfe wird vom edlen Herr erbeten. @cr Nun, das wird nicht ganz günstig werden, so viel ist wohl klar.", true)
		ASP("MajorP7",mjP7,"Wir wurden von unseren Nachbarn - und ja, auch von Drakon - im Laufe der letzten Konflikte tiefer in die Berge verdrängt. @cr Dabei verloren wir fast sämtliche Rohstoffansprüche naher Ländereien.", false)
		ASP("MajorP7",mjP7,"Diese fordern wir wieder ein. @cr Aber redet für die Einzelheiten mit den zuständigen Dörflern. @cr Ihr werdet alle ihre Aufgaben erfüllen müssen, damit wir an Eurer Seite kämpfen werden.", true)

		briefing.finished = function()
			Cutscene_P7()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMj7_1)
end
function Cutscene_P7()
	local cutsceneTable = {
    StartPosition = {
		position = GetPosition("MajorP7"), angle = 21, zoom = 1900, rotation = 120},
		Flights = {
			{
			position = GetPosition("MajorP7"),
			angle = 23,
			zoom = 2400,
			rotation = 140,
			duration = 5,
			action 	=	function()

						end,
			title = " @color:180,0,240 Dario",
			text = " @color:230,0,0 Die Siedler dieses Dorfes wurden in diese schroffen und kargen Berge vertrieben. @cr Wir sollten versuchen, ihren Anspruch auf die Ländereien im Tal wieder geltend zu machhen.",
			},
			{
			position = GetPosition("cutscene_p7end"),
			angle = 27,
			zoom = 2800,
			rotation = 130,
			duration = 15,
			action 	=	function()

						end,
			title = " @color:180,0,240 Dario",
			text = " @color:230,0,0 Wir dürfen dabei aber nicht die Nachbarn erzürnen, die diese Gebiete ebenfalls für sich beanspruchen. @cr Wir können hier keinen weiteren Krieg gebrauchen und müssen äußerst diplomatisch vorgehen.",
			}
		},
		Callback = function()
			if MtVillagesDiploCheck(7) == true then
				EnableNpcMarker(GetEntityId("guard_p7"))
				EnableNpcMarker(GetEntityId("settler_p7"))
				EnableNpcMarker(GetEntityId("thief_p7"))
				Guard_P7_1()
				Settler_P7_1()
				Thief_P7_1()
			end
		end

	}
	Start_Cutscene(cutsceneTable)
end
function Guard_P7_1()
	if MtVillagesDiploCheck(7) == true then
		local BeiGuaP7_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "guard_p7",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("guard_p7"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("guard_p7",id);LookAt(id,"guard_p7")
			DisableNpcMarker(GetEntityId("guard_p7"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Könnt ihr ein gutes Wort für mich bei eurem Dorfältesten einlegen? @cr Wir ersuchen im ganzen Land Unterstützung gegen den Vormarsch der dunklen Horden.", false)
			ASP("guard_p7",gu_p7,"Dafür werdet ihr erst einiges für mich erledigen müssen. @cr Ihr hattet sicherlich schon gehört, dass wir als Ergebnis der letzten Kriege hier hoch in die Berge vertrieben wurden.", true)
			ASP("guard_p7",gu_p7,"Damit die Geschichte sich nicht wiederholt, benötigen wir mächtige Soldaten, die in unsere Dienste gestellt werden.", false)
			ASP("guard_p7",gu_p7,"Entsendet uns einige Bataillone Bastardenschwertkämpfer und unterstellt sie unserem Kommando. @cr Dann reden wir weiter.", true)

			briefing.finished = function()
				QuestSwordsmenP7()
				CheckSwordsmenQuestP7()
			end;
			StartBriefing(briefing)
		end
		}
		SetupExpedition(BeiGuaP7_1)
	else
		DisableNpcMarker(GetEntityId("guard_p7"))
	end
end
function QuestSwordsmenP7()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Bastardenschwertkämpfer für Hohenberge",
	text	= "Der Oberbefehlshaber der Armee von Hohenberge bittet Euch darum, " .. round(6/gvDiffLVL) .. " Truppen Bastardenschwertkämpfer nach Hohenberge zu entsenden und in ihre Dienste zu stellen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestSwordsmenP7Quest = quest.id
end
function CheckSwordsmenQuestP7()
	local trooptable = {
		AreaPos = "guard_p7",
		AreaSize = 2000,
		TroopTypes = {
						{UpgradeCategories.LeaderSword,round(6/gvDiffLVL)}
					},
		Callback = function()
			local pos = GetPosition("guard_p7")
			local IDs = {}
			local needed = round(6/gvDiffLVL)
			for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerFilter(), CEntityIterator.OfPlayerFilter(1),
			CEntityIterator.OfTypeFilter(Entities.PU_LeaderSword4), CEntityIterator.InCircleFilter(pos.X, pos.Y, 2500)) do
				if Logic.LeaderGetNumberOfSoldiers(eID) == 12 then
					table.insert(IDs, eID)
				end
			end
			if table.getn(IDs) == needed then
				local army = {}
				army.player 		= 7
				army.id 			= GetFirstFreeArmySlot(7)
				army.position 		= GetPosition("SpawnP7")
				army.rodeLength 	= Logic.WorldGetSize()
				army.strength 		= needed
				army.building 		= GetID("TowerP7")
				army.respawnDelay 	= round(120/gvDiffLVL)
				army.types 			= {Entities.PU_LeaderSword4}
				SetupArmy(army)
				for i = 1, table.getn(IDs) do
					ChangePlayer(IDs[i], 7)
					ConnectLeaderWithArmy(IDs[i], army)
				end
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, army.respawnDelay, unpack(army.types)})

				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP("guard_p7",gu_p7,"Vielen Dank für Eure Truppenentsendung. @cr So werden es sich unsere Nachbarn zweimal überlegen, uns erneut zu bekämpfen.", false)
				ASP("guard_p7",cav_p5,"Ich werde unserem Dorfältesten von eure Taten berichten. @cr Wir werden uns bestimmt schon bald auf dem Schlachtfeld erneut begegnen.", false)
				briefing.finished = function()
					Logic.RemoveQuest(1,QuestSwordsmenP7Quest)
					gvMoti.Villages[7] = gvMoti.Villages[7] + round(25*gvDiffLVL)
					Message("Motivationsgewinn bei Hohenberge: ".. round(25*gvDiffLVL).."")
				end;
				StartBriefing(briefing);
				return true
			else
				local briefing = {}
				local AP, ASP = AddPages(briefing)
				ASP("guard_p7",gu_p7,"Ihr habt versucht, uns zu bescheißen, indem ihr uns minderwertige Truppen entsandt habt. @cr Was habt ihr euch nur dabei gedacht?", false)
				ASP("guard_p7",cav_p5,"So wird das nichts mit dem Bündnis. @cr Ich werde unserem Dorfältesten von eurer schändlichen Täuschung berichten.", false)
				briefing.finished = function()
					Logic.RemoveQuest(1,QuestSwordsmenP7Quest)
					gvMoti.Villages[7] = gvMoti.Villages[7] - round(20/gvDiffLVL)
					gvLastTimeVillageHelped[7] = Logic.GetTime()
					Message("Motivationsverlust bei Hohenberge: ".. round(20/gvDiffLVL).."")
				end;
				StartBriefing(briefing);
				return true
			end
		end}

	SetupBuildTroops(trooptable)
end
function Settler_P7_1()
	if MtVillagesDiploCheck(7) == true then
		local BeiSetP7_1 = {
		--EntityName = "Dario",
		Heroes = true,
		TargetName = "settler_p7",
		Distance = 300,
		Callback = function()
			local posX, posY = Logic.GetEntityPosition(GetID("settler_p7"))
			local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
			LookAt("settler_p7",id);LookAt(id,"settler_p7")
			DisableNpcMarker(GetEntityId("settler_p7"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			local briefingData = gvBriefingLinesByBriefAndHero.Settler_P7_1[Logic.GetEntityName(id)]
			for i = 1, table.getn(briefingData) do
				ASP(unpack(briefingData[i]))
			end
			briefing.finished = function()
				QuestMinesP7()
				EnableNpcMarker(GetID("Major"))
				MajorP8_RegionForP7Brief()
			end;
			StartBriefing(briefing)
		end
		}
		SetupExpedition(BeiSetP7_1)
	else
		DisableNpcMarker(GetEntityId("settler_p7"))
	end
end
function QuestMinesP7()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Gebietsabtretung für Hohenberge",
	text	= "Hohenberge verlangt nach dem Bau von einem Eisenstollen sowie einem Schwefelstollen samt mittlerem Wohnhaus sowie Mühle im Tal unterhalb des Berges. @cr Diese Gebiete fielen im letzten großen Krieg jedoch an Drakon. @cr Ihr solltet zunächst mit dem Bürgermeister von Drakon sprechen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestMinesP7Quest = quest.id
end
function MajorP8_RegionForP7Brief()
	local BeiMjP8_2 = {
	--EntityName = "Dario",
	Heroes = true,
	TargetName = "Major",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Major"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Major",id);LookAt(id,"Major")
		DisableNpcMarker(GetEntityId("Major"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		local briefingData = gvBriefingLinesByBriefAndHero.MajorP8_P7Province[Logic.GetEntityName(id)]
		for i = 1, table.getn(briefingData) do
			ASP(unpack(briefingData[i]))
		end
		briefing.finished = function()
			TributeRessourcesP8()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMjP8_2)

end
function TributeRessourcesP8()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(18000/gvDiffLVL).." Eisen an Drakon"
	tribute.cost = { Iron = round(18000/gvDiffLVL) }
	tribute.Callback = TributePaidIronP8
	TributeIronP8 = AddTribute(tribute)
end
function TributePaidIronP8()
	if CaravansOnItsWay then
		AddIron(round(18000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributeRessourcesP8()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(8/gvDiffLVL) do
		CreateEntity(8,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P8_major_"..i)
	end

	local questcaravanmovetoP8_major = {
	Unit = "caravan_P1_to_P8_major_",
	Waypoint = {
				 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
				 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
				 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
				 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
				 {Name = "caravan_step2_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step3_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step4_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step5_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step6_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step7_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "Drakon",			WaitTime = round(6/gvDiffLVL)},
				 {Name = "RE",				WaitTime = 2}
	},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddIron(8,round(18000/gvDiffLVL))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Major",bgm,"Die Eisenlieferung ist eingetroffen. @cr Ihr könnt nun mit dem Bau der Minen für Hohenberge beginnen, ich gestatte es Euch.", false)
			briefing.finished = function()
				ConditionsQuestMinesP7()
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Major",bgm,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributeRessourcesP8()
			end;
			StartBriefing(briefing);
		end
	end,
	NumCaravan = round(8/gvDiffLVL),
	ArrivedCount = 0,
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP8_major)
end
function ConditionsQuestMinesP7()
	MinesForP7 = 0
	StartSimpleJob("CheckForIronmineP7")
	StartSimpleJob("CheckForResidenceIronmineP7")
	StartSimpleJob("CheckForFarmIronmineP7")
	--
	StartSimpleJob("CheckForSulfurmineP7")
	StartSimpleJob("CheckForResidenceSulfurmineP7")
	StartSimpleJob("CheckForFarmSulfurmineP7")
	--
	StartSimpleJob("CheckForExpansionMinesBuiltP7")
end
function CheckForIronmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_IronMine2, Entities.PB_IronMine3),CEntityIterator.InCircleFilter(9225, 38250, 500)) do
		Message("Der Eisenstollen für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForResidenceIronmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Residence2, Entities.PB_Residence3),CEntityIterator.InCircleFilter(9225, 38250, 2500)) do
		Message("Das Wohnhaus nahe des Eisenerzvorkommens für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForFarmIronmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Farm2, Entities.PB_Farm3),CEntityIterator.InCircleFilter(9225, 38250, 2500)) do
		Message("Die Mühle nahe des Eisenerzvorkommens für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForSulfurmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_SulfurMine2, Entities.PB_SulfurMine3),CEntityIterator.InCircleFilter(1425, 32350, 500)) do
		Message("Der Schwefelstollen für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForResidenceSulfurmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Residence2, Entities.PB_Residence3),CEntityIterator.InCircleFilter(1425, 32350, 2500)) do
		Message("Das Wohnhaus nahe des Schwefelvorkommens für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForFarmSulfurmineP7()
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
	CEntityIterator.OfAnyTypeFilter(Entities.PB_Farm2, Entities.PB_Farm3),CEntityIterator.InCircleFilter(1425, 32350, 2500)) do
		Message("Die Mühle nahe des Schwefelvorkommens für Hohenberge wurde erfolgreich errichtet.")
		ChangePlayer(eID, 7)
		MinesForP7 = MinesForP7 + 1
		return true
	end
end
function CheckForExpansionMinesBuiltP7()
	if MinesForP7 >= 6 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("ironmine_p7",dari,"Die geforderten Gebiete wurden für euch von Drakon abgetreten und mit Ressourcenabbau erschlossen.", false)
		ASP("settler_p7",gu_p6,"Sehr gut. @cr Mit diesen Ressourcen in der Rückhand und Gebieten im Tal als Sicherheit können wir euch bestimmt schon in Bälde militärisch unterstützen.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1,QuestMinesP7Quest)
			gvMoti.Villages[7] = gvMoti.Villages[7] + round(20*gvDiffLVL)
			gvLastTimeVillageHelped[7] = Logic.GetTime()
			Message("Motivationsgewinn bei Hohenberge: ".. round(20*gvDiffLVL).."")
		end;
		StartBriefing(briefing);
		return true
	end
end
function Thief_P7_1()
	local BeiThi = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "thief_p7",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("thief_p7"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("thief_p7",id);LookAt(id,"thief_p7")
		DisableNpcMarker(GetEntityId("thief_p7"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("thief_p7",thi_p7,"Wir sollten uns vor möglichen Angriffen aus der Nachbarsiedlung schützen und uns unseren alten Gebieten näher bringen.", true)
		ASP("bridge_p7",thi_p7,"Sprengt bitte die Brücke am nördlichen Ende unseres Gebietes. Unsere Nachbarn werden dann keine Verbindung mehr zu unserer Siedlung haben.", false)
		ASP("rock_p7",thi_p7,"Zuvor solltet ihr uns jedoch etwas Schwefel und Kohle schicken, sodass wir die Felsblockade unterhalb unserer Siedlung sprengen können.", false)
		briefing.finished = function()
			QuestP7BridgeAndRock()
			TributSulfurNCoalP7()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiThi)
end
function QuestP7BridgeAndRock()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Neue Wege für Hohenberge",
	text	= "Hohenberge verlangt nach einer Schwefel- und Kohlelieferung, um die Felsblockade auf ihrer südlichen Bergflanke zu sprengen. @cr @cr Im Anschluss sollt ihr die Brücke nördlich ihrer Siedlung sprengen.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	QuestP7BridgeAndRockQuest = quest.id
end
function TributSulfurNCoalP7()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Sendet ".. round(12000/gvDiffLVL).." Schwefel und ".. round(6000/gvDiffLVL).." Kohle an Hohenberge"
	tribute.cost = { Sulfur = round(12000/gvDiffLVL), Knowledge = round(6000/gvDiffLVL) }
	tribute.Callback = TributePaidSulfurNCoalP7
	TributeSulfurNCoalP7 = AddTribute(tribute)
end
function TributePaidSulfurNCoalP7()
	if CaravansOnItsWay then
		AddSulfur(round(12000/gvDiffLVL))
		Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, round(6000/gvDiffLVL))
		Message("Es sind bereits Karavanen unterwegs. Wartet, bis diese wieder verfügbar sind!")
		TributSulfurNCoalP7()
		return
	end
	CaravansOnItsWay = true
	for i = 1,round(8/gvDiffLVL) do
		CreateEntity(7,Entities.PU_Travelling_Salesman,GetPosition("caravan_P1_start_"..i),"caravan_P1_to_P7_thief_"..i)
	end

	local questcaravanmovetoP7_thief = {
	Unit = "caravan_P1_to_P7_thief_",
	Waypoint = {
				 {Name = "bridge", 			WaitTime = round(6/gvDiffLVL)},
				 {Name = "start_step2", 	WaitTime = round(10/gvDiffLVL)},
				 {Name = "start_step1",		WaitTime = round(10/gvDiffLVL)},
				 {Name = "route_step1",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "route_step2",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_step1_1",	WaitTime = round(10/gvDiffLVL)},
				 {Name = "caravan_step2_1",	WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_wroute1_1",WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_wroute2_1",WaitTime = round(6/gvDiffLVL)},
				 {Name = "P5_end_pos",		WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_wroute3_1",WaitTime = round(6/gvDiffLVL)},
				 {Name = "caravan_wroute4_1",WaitTime = round(6/gvDiffLVL)},
				 {Name = "thief_p7",		WaitTime = 2}
	},
	Remove = true,
	Callback = function(_Quest)
		if _Quest.ArrivedCount >= _Quest.NumCaravan then
			CaravansOnItsWay = false
			AddSulfur(7,round(12000/gvDiffLVL))
			Logic.AddToPlayersGlobalResource(7, ResourceType.Knowledge, round(6000/gvDiffLVL))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("thief_p7",thi_p7,"Die Ressourcen sind eingetroffen. @cr Wir werden nun die Felsen unterhalb unsres Berges sprengen. @cr Bitte sprengt ihr für uns die Brücke nördlich unsrer Siedlung.", false)
			briefing.finished = function()
				StartCountdown(60, P7VillageExplosion, false)
				ConditionsQuestBridgeP7()
			end;
			StartBriefing(briefing);
		else
			CaravansOnItsWay = false
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("thief_p7",thi_p7,"Einige der Karavanen wurden abgefangen. @cr Ihr werdet uns die Ressourcen erneut schicken und die Karavanen besser schützen müssen.", false)
			briefing.finished = function()
				TributePaidSulfurNCoalP7()
			end;
			StartBriefing(briefing);
		end
	end,
	NumCaravan = round(8/gvDiffLVL),
	ArrivedCount = 0,
	ArrivedCallback = function(_Quest)
	end}

	SetupCaravan(questcaravanmovetoP7_thief)
end
function P7VillageExplosion()
	local posX, posY = Logic.GetEntityPosition(GetID("rock_p7"))
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim, posX, posY)
	DestroyEntity(GetID("rock_p7"))
	ReplaceEntity("palisade_p7", Entities.XD_PalisadeGate2)
end
function ConditionsQuestBridgeP7()
	StartSimpleJob("BridgeP7DownCheck")
end
function BridgeP7DownCheck()
	if IsDestroyed("bridge_p7") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("thief_p7",thi_p7,"Habt Dank für Eure Hilfe. @cr Der alte Weg über die Brücke ist nun unpassierbar und der Bergpass zu unseren südlichen Gebieten frei. @cr Ich werde eine Empfehlung für unseren Dorfältesten ausstellen.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,QuestP7BridgeAndRockQuest)
			gvMoti.Villages[7] = gvMoti.Villages[7] + round(25*gvDiffLVL)
			gvLastTimeVillageHelped[7] = Logic.GetTime()
			Message("Motivationsgewinn bei Hohenberge: ".. round(25*gvDiffLVL).."")
		end;
		StartBriefing(briefing);
		return true
	end
end

function DrakeBrief_1()
	local BeiDr = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "Drake",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Drake"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Drake",id);LookAt(id,"Drake")
		DisableNpcMarker(GetEntityId("Drake"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Drake",dr,"Gut dich zu sehen " .. GetNPCDefaultNameByID(id) .. ". @cr Schön, dass Du mich mal besuchen kommst.", false)
		ASP("Drake",dr,"Schade, dass gerade ein unpassender Moment zum Feiern ist.", false)
		ASP("Invasoren",dr,"Die Invasoren sind weitaus mächtiger, als wir befürchtet hatten.", false)
		ASP("Invasoren",dr,"Und die schlechten Nachrichten nehmen kein Ende... @cr Wir werden Euch im Kampf leider nicht unterstützen können. @cr Unsere Truppen halten nur die Stellung und werden nicht in die Offensive gehen.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Warum das denn nicht? @cr Sind die Verteidiger Drakons Feiglinge oder wie?", true)
		ASP("Drake",dr,"Nein, das ist es nicht.", false)
		ASP("Drake",dr,"Die Moral meiner Truppen ist durch die vielen Verluste inzwischen "..
	        "so weit in den Keller gerutscht, dass sie sich weigern zu kämpfen. @cr Die Stellungen halten sie nur zur Not, weil sonst ihre Familien bedroht wären.", false)
		briefing.finished = function()
			EnableNpcMarker(GetEntityId("miner"))
			Logic.RemoveQuest(1,DrakeQuest)
			GUI.DestroyMinimapPulse(Logic.GetEntityPosition(Logic.GetEntityIDByName("Drake")))
			QuestMinenarbeiter()
			MinerBrief_1()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiDr)
end
--**
function QuestMinenarbeiter()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Minenarbeiter",
	text	= "Mit seinen letzten Worten murmelte sich Drake noch etwas über Minenarbeiter "..
	          "in den Bart. Dario weiß im Moment nichts damit anzufangen, oder was es bedeuten "..
			  "könnte. Dario beschliesst daher, dem Gemurmel über angebliche Minenarbeiter "..
			  "auf den Grund zu gehen. @cr @cr Finde mit Dario den Minenvorarbeiter und sprich mit ihm.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	MinenarbeiterQuest = quest.id
end
--**
function MinerBrief_1()
	local BeiMiner = {
	--EntityName = "Dario",
	Heroes = true,
    TargetName = "miner",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("miner"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("miner",id);LookAt(id,"miner")
		DisableNpcMarker(GetEntityId("miner"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("miner",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Was steht ihr hier herum und dreht Däumchen ? @cr "..
	        "Habt ihr nichts besseres zu tun ?", false)
		ASP("miner",mina,"Wonach siehts denn aus? @cr Drake hat uns damit beauftragt, ein Eisenerzstollen für die Waffenproduktion zu bauen.", false)
		ASP("miner",mina,"Aber wir sind geschulte Bergarbeiter und keine Bauarbeiter.", false)
		ASP("miner",mina,"Keinen blassen Schimmer, wie und wo man Eisenerzstollen baut.", false)
		ASP("miner",mina,"Bitte helft uns dabei und errichtet ein Eisenerzstollen.", false)
		ASP("Eisen",mina,"Ich schätze, sie auf diesem Stollen zu errichten, wäre gar "..
	        "keine so schlechte Idee, oder ?", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Hmm... wenn ihr meint.... @cr Versuchen können wir es ja mal.", false)
		ASP("miner",mina,"Super! Und wenn Ihr schon mal dabei seid......", false)
		ASP("Eisen",mina,"Ein mittleres Wohnhaus und eine Mühle für mich und meine Kollegen wäre auch nicht schlecht.", false)
		ASP("miner",mina,"Die normale Ausführung würde uns schon reichen.", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wie bescheiden.... @cr Sonst noch einen Wunsch ?", false)
		ASP("miner",mina,"Öhm..... naja, würde vorschlagen, die alte Hausruine und die alte Farmruine "..
	        "abzureissen und jeweils genau dort neue Gebäude zu errichten.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,MinenarbeiterQuest )
			QuestBauFuerMiner()
			Vorbereitung()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMiner)
end
--**
function QuestBauFuerMiner()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Minenarbeitern helfen",
	text	= "Hilf den Minenarbeitern und bau ihnen an folgenden Positionen folgende Gebäude: @cr @cr "..
	          "1. Ein MITTLERES WOHNHAUS anstelle der Hausruine ( Hausruine abreissen ) @cr "..
			  "2. Eine MÜHLE anstelle der Farmruine ( Farmruine abreissen ) @cr "..
			  "3. Ein EISENSTOLLEN auf dem Eisenschacht bei den Ruinen." ,
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BauFuerMinerQuest = quest.id
end
--**
function Vorbereitung()
	--AllowTechnology(Technologies.B_Ironmine,1)
	StartSimpleJob("FertigMeldung")
	StartSimpleJob("AbfrageHaus")
	StartSimpleJob("AbfrageFarm")
	StartSimpleJob("AbfrageMine")
	ChangePlayer("mruin_1",2)
	ChangePlayer("mruin_2",2)
	SetHealth("mruin_1", 8)
	SetHealth("mruin_2", 8)
	StartSimpleJob("Ruin1Down")
	StartSimpleJob("Ruin2Down")
end
--**
function Ruin1Down()
	if IsDestroyed("mruin_1") then
		TPointer1 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,11500,26200)
	return true
	end
end
function Ruin2Down()
	if IsDestroyed("mruin_2") then
		TPointer2 = Logic.CreateEffect(GGL_Effects.FXTerrainPointer,12700,24700)
	return true
	end
end
function AbfrageHaus()
	idRes = SucheAufDerWelt(1,Entities.PB_Residence2,1000,{X=11500,Y=26200})
	if table.getn(idRes) > 0 and Logic.IsConstructionComplete(idRes[1]) == 1 then
		idRes = idRes[1]
		Logic.DestroyEffect(TPointer1)
		ChangePlayer(idRes,8)
		gvRes = 1
		return true
	end
end
--**
function AbfrageFarm()
	idFar = SucheAufDerWelt(1,Entities.PB_Farm2,1000,{X=12700,Y=24700})
	if table.getn(idFar) > 0 and Logic.IsConstructionComplete(idFar[1]) == 1 then
		idFar = idFar[1]
		Logic.DestroyEffect(TPointer2)
		ChangePlayer(idFar,8)
		gvFar = 1
		return true
	end
end
--**
function AbfrageMine()
	idMin = SucheAufDerWelt(1,Entities.PB_IronMine2,2000,GetPosition("neubau"))
	if table.getn(idMin) > 0 and Logic.IsConstructionComplete(idMin[1]) == 1 then
		idMin = idMin[1]
		ChangePlayer(idMin,8)
		gvMin = 1
		return true
	end
end
--**
function FertigMeldung()
	if gvRes == 1 and gvFar == 1 and gvMin == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Dario",dari,"Die gewünschten Gebäude wurden fertiggestellt.", true)
		ASP("miner",mina,"Perfekt! Ihr seid der geborene Architekt.", false)
		ASP("miner",mina,"Ich danke Euch im Namen aller Minenarbeiter dieser Welt.", false)
		ASP("miner",mina,"Drake wird sicherlich sehr zufrieden mit diesen Fortschritten sein.", false)
		ASP("Drake",dr,"Hervorragend, was Ihr da vollbracht habt. Ich danke Euch.", false)
		ASP("Drake",dr,"Kommt bitte noch mal zu mir. @cr Ich habe einen wichtigen Auftrag für Euch.", false)
		briefing.finished = function()
			Logic.RemoveQuest(1,BauFuerMinerQuest)
			EnableNpcMarker(GetEntityId("Drake"))
			DrakeBrief_2()
		end;
		StartBriefing(briefing);
		return true
	end
end
--**
function DrakeBrief_2()
	local BeiDr = {
	--EntityName = "Dario",
    TargetName = "Drake",
	Heroes = true,
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Drake"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Drake",id);LookAt(id,"Drake")
		DisableNpcMarker(GetEntityId("Drake"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Drake",dr,"Gut, dass Ihr gekommen seid.", true)
		ASP("Drake",dr,"Geht bitte zu meinem Kommandanten.", true)
		ASP("Drake",dr,"Mein Kommandant wird Euch erklären, was nun zu tun ist.", true)
		ASP("Comm",dr,"Ihr findet ihn beim südlichen Tor zu unserer Festungsanlage.", true)
		briefing.finished = function()
			EnableNpcMarker(GetEntityId("Comm"))
			ConnectLeaderWithArmy(GetID("Drake"), ArmyTable[8][1])
			MakeVulnerable("Drake")
			KommandantBrief_1()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiDr)
end
--**
function KommandantBrief_1()
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
		ASP("Comm",""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Drake schickt mich. @cr Er sagte, ihr wüsstet wie es weiter geht.", true)
		ASP("Comm",kdA,"Das ist wahr. Wir müssen die Invasoren zurückschlagen. @cr Koste es was es wolle.", true)
		ASP("Comm",kdA,"Ach ja, bevor ich es vergesse.....", true)
		ASP("Comm",kdA,"Ich möchte Euch noch einen Ratschlag mit auf den Weg geben.", true)
		AP{
			title = kdA,
			text = "Kerberos sitzt auf einer Insel fest. @cr Ihr solltet also im Sommer angreifen und zunächst die Lager von Varg und Mary vernichten.",
			position = GetPosition("KerberosBurg"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		ASP(id,ment,"Es scheint, als könntet ihr Euch nun vollkommen auf den Angriff konzentrieren. @cr Es wird nun nicht mehr spielentscheidend sein, wenn einer Eurer Helden in Ohnmacht fällt!", false)
		briefing.finished = function()
			Chapter1Done = true
			QuestBelagerung()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiCo)
end
--**
function QuestBelagerung()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Die Belagerung",
	text	= "Vernichtet die Invasoren Kerberos, Varg und Mary de Mortfichet. @cr @cr "..
	          "Siegentscheidend ist die Zerstörung der Festungsanlage von Kerberos. @cr "..
			  "Ihr könnt also selbst entscheiden, wie schwer der Endkampf ausfallen soll. @cr @cr "..
			  "1. Entweder direkt auf die Festungsanlage von Kerberos losstürmen, oder @cr "..
			  "2. Erst alle anderen Gegner vernichten und zum Schluss Kerberos.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	BelagerungQuest = quest.id
end
--**
function Gewonnen()
	if GetHealth("KerBurg") <= 10 then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.2
		local AP, ASP = AddPages(briefing);
		AP{
			title = bgm,
			text = "Die Belagerung hat endlich ein Ende. @cr "..
				   "Die Burg von Kerberos wurde zerstört. @cr "..
				   "Wir werden Euch ewig dankbar sein.",
			position = GetPosition("posHQSP"),
			dialogCamera = false,
			action = function()
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
				CreateEntity(2, Entities.CU_BlackKnight, GetPosition("Kerberos"), "KerbRos")
				Move("KerbRos", "KerberosEndPos")
			end
			}
		AP{
			title = ment,
			text = "Ihr habt Drakonien erfolgreich vom Übel befreit und damit das Spiel gewonnen.",
			position = GetPosition("posHQSP"),
			dialogCamera = false,
			action = function()
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 39700,15100, 0 );
				Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 39700,15100, 0 );
			end
			}
		ASP("Kerberos",ment,"Aber was ist das? @cr Kerberos kann mit letzter Kraft in die Berge flüchten.", false)
		ASP("Ende",dari,"Wir werden Kerberos in die Berge folgen. @cr Er darf unter keinen Umständen entkommen.", true)
		ASP("Ende",dari,"Boten berichteten, dass andere Dörfer und Städte im Norden noch immer unter Kerberos Kontrolle sind..", true)
		ASP("Drake",dari,"Lasst sie uns gemeinsam befreien; Drake sicherte uns seine Unterstützung zu.", false)
		briefing.finished = function()
			DestroyEntity("KerbRos")
			Logic.RemoveQuest(1,BelagerungQuest)
			Victory()
		end;
		StartBriefing(briefing);
		return true
	end
end
--**
function Verloren()
	if IsDead("hqSP") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("posHQSP",ment,"Warum habt Ihr Eure Burg nicht beschützt ?", false)
		ASP("posHQSP",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
		ASP("posHQSP",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
	if ((IsDead("Dario") or IsDead("Ari")) and not Chapter1Done) then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("posHQSP",ment,"Warum habt Ihr Eure Helden nicht beschützt ?", false)
		ASP("posHQSP",ment,"Jetzt sind sie gefallen und damit habt ihr auch das Spiel verloren.", false)
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
function Techs()
	if IsDestroyed("Turm") then
		AllowTechnology(Technologies.GT_PulledBarrel,1)
		AllowTechnology(Technologies.GT_Mathematics,1)
		AllowTechnology(Technologies.GT_Binocular,1)
		AllowTechnology(Technologies.GT_Matchlock,1)
		Message("Hmm komisch, in dem Turm lagen tatsächlich Brückenbaupläne und jede Menge andere nützliche Aufzeichnungen")
		return true
	end
end

function Truhen()
	CreateRandomGoldChest(GetPosition("chest1"))
	CreateRandomGoldChest(GetPosition("chest2"))
	CreateRandomGoldChest(GetPosition("chest3"))
	CreateRandomGoldChest(GetPosition("chest4"))
	CreateRandomGoldChest(GetPosition("chest5"))
	CreateRandomGoldChest(GetPosition("chest6"))
	CreateRandomGoldChest(GetPosition("chest7"))
	CreateRandomGoldChest(GetPosition("chest8"))
	CreateRandomGoldChest(GetPosition("chest9"))
	CreateRandomGoldChest(GetPosition("chest10"))
	CreateRandomGoldChest(GetPosition("chest11"))
	CreateRandomGoldChest(GetPosition("chest12"))
	CreateRandomGoldChest(GetPosition("chest13"))
	CreateChest(GetPosition("chest14"),chestCallbackExtra)
	CreateChest(GetPosition("xtrachest"),chestCallbackBridgeGuardianTreasure)
	CreateChestOpener("Dario")
	CreateChestOpener("Ari")
	StartChestQuest()
end
function chestCallbackLeer()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " hat eine Schatztruhe geplündert. Leider war nichts drin...")
	AddGold(0)
end
function chestCallbackGold()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 2000 Taler.")
	AddGold(2000)
end
function chestCallbackIron1()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 2500 Eisen.")
	AddIron(2500)
end
function chestCallbackIron2()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1000 Eisen.")
	AddIron(1000)
end
function chestCallbackIron3()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1500 Eisen.")
	AddIron(1500)
end
function chestCallbackClay()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 600 Lehm.")
	AddClay(600)
end
function chestCallbackStone()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 800 Steine.")
	AddStone(800)
end
function chestCallbackWood()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1200 Holz.")
	AddWood(1200)
end
function chestCallbackSulfur()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 900 Schwefel.")
	AddSulfur(900)
end
function chestCallbackExtra()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 3000 Eisen.")
	AddIron(3000)
	--
	local army = {}
	army.player = 2
	army.id = GetFirstFreeArmySlot(2)
	army.position = GetPosition("Falle")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_BlackKnight_LeaderMace2})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
end
function chestCallbackBridgeGuardianTreasure()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Silver"] .. " Inhalt: " .. round(15000 * gvDiffLVL) .. " Taler und " .. round(350 * gvDiffLVL) .." Silber.")
	Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, round(350*gvDiffLVL))
	AddGold(1, round(15000*gvDiffLVL))
end
function ControlGenericArmies(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end
function InitMerchants()
	MerchantIDs = {GetID("merc1")}
	-- fill with dummy data
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
		return round(total * 1.15 - (0.2*gvDiffLVL))
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
	ShuffleMerchantData()
end
function ShuffleMerchantData()
	for i = 0, 3 do
		local amount = round(math.random(1,4) * gvDiffLVL)
		local rdata = MerchantData[math.random(1,table.getn(MerchantData))]
		for j = 1, table.getn(MerchantIDs) do
			local id = MerchantIDs[j]
			for k, v in pairs(rdata) do
				OverrideMercenarySlotData(id, i, k, amount, v)
			end
		end
	end
	StartCountdown((5 + math.random(20)) * 60, ShuffleMerchantData, false)
end
function InitAchievementChecks()
	StartSimpleJob("CheckForAllChestsOpened")
	StartSimpleJob("CheckForAllCaravansArrived")
	StartSimpleJob("CheckForAriSummon")
	TimesAriSummoned = 0
	GUIAction_Hero5SummonOrig = GUIAction_Hero5Summon
	GUIAction_Hero5Summon = function()
		GUIAction_Hero5SummonOrig()
		TimesAriSummoned = TimesAriSummoned + 1
	end
	StartSimpleJob("CheckForAllVillagesConvinced")
end
function CheckForAllChestsOpened()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_ChestGold) == 0 then
		Message("Ihr habt alle Schatztruhen gefunden. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\drakonchests", 1)
		return true
	end
end
function CheckForAllCaravansArrived()
	if caravans_arrived >= (CaravanPerWave * 4) then
		Message("Ihr habt alle Karavanen erfolgreich beschützt. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\drakoncaravans", 1)
		return true
	end
end
function CheckForAriSummon()
	if TimesAriSummoned >= 10 then
		Message("Ihr habt Aris <<Banditen rufen>> mindestens zehn mal verwendet. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\drakonarisummon", 1)
		return true
	end
end
function CheckForAllVillagesConvinced()
	local done = true
	for player = 5, 7 do
		if Logic.GetDiplomacyState(1, player) ~= Diplomacy.Friendly then
			done = false
			break
		end
	end
	if done then
		Message("Ihr habt alle umliegenden Bergdörfer erfolgreich für Euch gewinnen können. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\drakonvillages", 1)
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