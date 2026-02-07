--------------------------------------------------------------------------------
-- MapName: Keshet
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Das Keshet-Gebirge @cr "
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
	ForbidTechnology(Technologies.T_MarketIron,1)
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

	Display.SetPlayerColorMapping(2, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(4, 10)
	Display.SetPlayerColorMapping(7, NPC_COLOR)
	Display.SetPlayerColorMapping(8, EVIL_GOVERNOR_COLOR)
	--
	SetPlayerName(2, "Räuber")
	SetPlayerName(3, "???")
	--SetPlayerName(3, "Begona")
	SetPlayerName(4, "???")
	--SetPlayerName(4, "Highfall")
	SetPlayerName(7, "Lesthortho")
	SetPlayerName(8, "Nebelvolk")
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
	Move("dario", "moveDario")
	Move("ari", "moveAri")
	Move("erec", "moveErec")
	StartCutscene("Intro", Prolog)
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
		--DarioQuest()
		--HeroesDeadJob = StartSimpleJob("DefeatJob")
		--
		--InitAchievementChecks()
	end
    StartBriefing(briefing)
end
function Truhen()
	gvTotalChestAmount = 1
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