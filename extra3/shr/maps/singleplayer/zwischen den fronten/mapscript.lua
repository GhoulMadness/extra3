--------------------------------------------------------------------------------
-- MapName: Zwischen den Fronten
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Zwischen den Fronten @cr "
gvMapVersion = " v1.00"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(2,"Karghon")
	SetPlayerName(3,"Kroxos")
	SetPlayerName(8,"Steppenbarbaren")
	SetHostile(2,3)
	SetHostile(2,8)
	SetHostile(3,8)
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (500)
    AddSulfur(0)
    AddIron  (0)
    AddWood  (1000)
    AddStone (1000)
    AddClay  (1000)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start and after save game is loaded, setup your weather gfx
-- sets here
function InitWeatherGfxSets()
	SetupEvelanceWeatherGfxSet()
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
	Display.SetPlayerColorMapping(4,NPC_COLOR)
	Display.SetPlayerColorMapping(8,ROBBERS_COLOR)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, 3, 53000, 3, "1", 3, 0)
	MapEditor_SetupAI(3, 3, 53000, 3, "2", 3, 0)
	MapEditor_SetupAI(8, 3, 53000, 3, "3", 3, 0)

	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,8)
	ActivateBriefingsExpansion()
	Start()
	StartSimpleJob("Felsen")
	TagNachtZyklus(24,1,0,-2,1)
end
function FarbigeNamen()
	orange 	= "@color:255,127,0"
	lila 	= "@color:250,0,240"

	ment   = ""..orange.." Mentor "..lila..""
	maj1   = ""..orange.." B\195\188rgermeister "..lila..""
	maj2   = ""..orange.." Oberbefehlshaber "..lila..""
	maj3   = ""..orange.." W\195\164chter "..lila..""
	sal    = ""..orange.." Salim "..lila..""
	auf    = ""..orange.." Auftragsziele "..lila..""
 end
function Start()
    EnableNpcMarker(GetEntityId("Major1"))
    EnableNpcMarker(GetEntityId("Major2"))
    EnableNpcMarker(GetEntityId("Major3"))
	Prolog()
	Truhen()
end

function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Sicht",ment,"Inmitten einer orientalischen Steppen-und Moorregion herrscht Krieg zwischen drei hochentwickelten Städten.", false)
	ASP("Salim",ment,"Salim hat sich auf den Weg gemacht, den Krieg zwischen den rivalisierenden Städten zu beenden.", false)
	ASP("Burg3",ment,"Der Regent von Karghon befindet sich an seiner Burg, in etwa hier.", false)
	ASP("Burg1",ment,"Der Bürgermeister von Kroxos steht vor seiner Burg herum.", false)
	ASP("Burg2",ment,"Und zu guter letzt die Steppenbanditen. Deren Oberbefehlshaber müsste eigentlich vor deren Hauptgebäude zu finden sein, wenn mich mein Verstand nicht täuscht.", false)
	ASP("Salim",sal,"Mein diplomatisches Geschick wird uns dabei garantiert hilfreich sein. Die werden sich verjagen, wie gut ich mich hier auskenne", true)
	ASP("Teich",sal,"Ist ja schliesslich schon ein gutes Stück Heimat hier für mich.",false)
	ASP("Salim",auf,"Redet mit den drei Bürgermeistern und findet einen bestmöglichen Kompromiss, um den Krieg zu beenden. Falls nötig, müsst ihr euch für eine der drei Seiten entscheiden",true)
	briefing.finished = function()
 	end
    StartBriefing(briefing)
	SalimQuest()
    Major1()
    Major2()
    Major3()
end
function SalimQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	="Beendet den Krieg",
	text	= "Beendet den Krieg zwischen den drei St\195\164dten. Redet dazu mit den Befehlshabern der Siedlungen. Achtung: Eventuell m\195\188sst ihr euch einer der drei St\195\164dte anschliessen, entscheidet euch also bereits vorher.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SalQuest = quest.id
end
function Major1()
	local BeiMj1 = {
		EntityName = "Salim",
		TargetName = "Major1",
		Distance = 300,
		Callback = function()
			LookAt("Major1","Salim");LookAt("Salim","Major1")
			DisableNpcMarker(GetEntityId("Major1"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Salim",sal,"Hallo, werter Bürgermeister von Kroxos. Ich bin hier um zu verhandeln.", true)
			ASP("Major1",maj1,"Das könnt ihr vergessen. Einen Kompromiss schliesse ich mit >>DENEN<< bestimmt nicht.", false)
			ASP("Major1",maj1,"Sie haben uns dafür schon viel zu viel Leid bereitet.", true)
			ASP("2",maj1,"Zahlt mir und meiner Gefolgschaft einen kleinen Spesen und wir vernichten die anderen beiden Siedlungen gemeinsam.", true)
			ASP("Major1",maj1,"Na, wie klingt das für euch??.", true)
			ASP("Salim",sal,"Ich werde darüber nachdenken.", true)
			ASP("Major1",maj1,"Tut das. **Aber ja nicht zulange**.", true)
			briefing.finished = function()
				Tribute1()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMj1)
end
function Major2()
	local BeiMj2 = {
		EntityName = "Salim",
		TargetName = "Major2",
		Distance = 300,
		Callback = function()
			LookAt("Major2","Salim");LookAt("Salim","Major2")
			DisableNpcMarker(GetEntityId("Major2"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Salim",sal,"Guten Tag, ich schätze mal, ihr seid der Befehlshaber der Steppenbanditen. Sagt mir bitte eure Vorstellung, wie der Krieg ein Ende finden kann.", true)
			ASP("Major2",maj2,"Fast. Ich bin der OBER-Befehlshaber hier.", false)
			ASP("Major2",maj2,"Wir sind einfache Leute. Wir waren lediglich früher einmal Banditen und haben uns dann hier niedergelassen, als hier die Städte aus dem Boden geschossen sind.", true)
			ASP("3",maj2,"Meine Truppen bestehen zwar aus den erfahrensten Kriegern, aber wirklich bereit für diesen zermürbenden Krieg sind sie nicht.", true)
			ASP("Dipl",maj2,"Wir haben bereits einige Diplomatengespräche mit Karghon geführt. Einem Frieden zwischen unseren beiden Städten steht nicht mehr all zu viel im Weg", false)
			ASP("Major2",maj2,"Liefert uns erst einmal ordentlich Steine, dass wir sehen, dass ihr in guten Absichten verhandelt.", true)
			ASP("Eisen",maj2,"Ach und wenn ihr damit fertig seid, baut doch bitte ein >>EISENBERGWERK<< für uns.", false)
			briefing.finished = function()
				Tribute3()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMj2)
end
function Major3()
	local BeiMj3 = {
		EntityName = "Salim",
		TargetName = "Major3",
		Distance = 300,
		Callback = function()
			LookAt("Major3","Salim");LookAt("Salim","Major3")
			DisableNpcMarker(GetEntityId("Major3"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("Salim",sal,"Moin, ich bin Salim. Ich versuche, den Frieden hier wiederherzustellen. Sagt mir, was ich tun soll, damit ihr mit dem krieg aufhört", true)
			ASP("Major3",maj3,"Das ist nicht so leicht, wie ihr euch das vermutlich vorgestellt habt.", false)
			ASP("1",maj3,"Ich behaupte zwar nach wie vor, das unsere Truppen die stärksten hier sind und wir den Krieg irgendwann locker gewinnen würden. Seht euch doch mal um, die Leute hier haben kein Problem mit dem Krieg.", false)
			ASP("Salim",sal,"Es gibt doch bestimmt etwas, das ihr schon lange haben wolltet und worum ihr euch mit euren Nachbarstädten drum streitet. Geht es um Rohstoffe? Um Wasser? Sagt es mir einfach.", true)
			ASP("Major3",maj3,"Da mit dem Wasser ist was dran. Wir haben allerdings bereits einen Pakt mit den Steppenbanditen ausgehandelt", false)
			ASP("Major3",maj3,"Wir dürfen dort vor Ort, an ihrer Wasserquelle einen Brunnen bauen und sie dafür im Gegenzug bei uns in der Nähe ein Eisenbergwerk.", true)
			ASP("Moor",maj3,"Das Wasser bei uns ist nämlich viel zu dreckig, um es zu nutzen. Tja, dafür haben wir hier oben in den Bergen jede Menge Eisenvorräte.", false)
			ASP("Brunnen",maj3,"Tut uns doch gleich den Gefallen und baut den Brunnen für uns. Ach ja und als Zeichen der Freundschaft erwarten wir natürlich noch zwei weitere Dinge.", false)
			ASP("Major3",maj3,"Als Erstes könnt ihr uns als Geste der Freundlichkeit 2000 Eisen liefern. Und Zweitens müsst ihr uns natürlich versichern, Kroxos gemeinsam mit uns zu bekämpfen.", true)
			briefing.finished = function()
				Tribute2()
			end;
			StartBriefing(briefing)
		end
	}
	SetupExpedition(BeiMj3)
end

function Tribute1()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 2000 Taler, um euch Kroxos anzuschliessen.";
	tribute.cost = {Gold = 2000};
	tribute.Callback = PayedTribute1;
	AddTribute( tribute )
end
function PayedTribute1()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Major1",maj1,"Danke für die Zahlung. Lasst uns nun gemeinsam die anderen beiden Siedlungen den Erdboden gleichzumachen! ", false)
	briefing.finished = function()
		StartSimpleJob("Gewonnen1")
		StartSimpleJob("Verloren1")
		SetFriendly(1,3)
		SetHostile(1,2)
		SetHostile(1,8)
		ActivateShareExploration(1,3,true)
	end;
	StartBriefing(briefing);
end
function Tribute2()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 2000 Eisen, um euch Karghon anzuschliessen.";
	tribute.cost = {Iron = 2000};
	tribute.Callback = PayedTribute2;
	AddTribute( tribute )
end
function PayedTribute2()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Major3",maj3,"Danke für die Eisenlieferung. Lasst uns nun gemeinsam die anderen Gegner vernichten! ", false)
		briefing.finished = function()
		StartSimpleJob("Gewonnen2")
		StartSimpleJob("Verloren1")
		SetFriendly(1,2)
		SetHostile(1,3)
		ActivateShareExploration(1,2,true)
		StartSimpleJob("Brunnen")
		StartSimpleJob("FertigMeldung")
	end;
	StartBriefing(briefing);
end
function Tribute3()
	local tribute =  {}
	tribute.playerId = 1;
	tribute.text = "Zahlt 2000 Steine, um euch den Steppenbanditen anzuschliessen.";
	tribute.cost = {Stone = 2000};
	tribute.Callback = PayedTribute3;
	AddTribute( tribute )
end
function PayedTribute3()
	local briefing = {}
	BRIEFING_TIMER_PER_CHAR = 1.0
	local AP, ASP = AddPages(briefing);
	ASP("Major2",maj2,"Muhaha ,Danke für die vielen Steine. Lasst uns nun zu zweit diese Sache zu Ende bringen! ", false)
	briefing.finished = function()
		StartSimpleJob("Gewonnen3")
		StartSimpleJob("Verloren1")
		SetFriendly(1,8)
		SetHostile(1,3)
		SetHostile(1,2)
		ActivateShareExploration(1,8,true)
		StartSimpleJob("Eisen")
		StartSimpleJob("FertigMeldung2")
	end;
	StartBriefing(briefing);
end
function Brunnen()
	local idBr = SucheAufDerWelt(1,Entities.PB_Beautification08,2000,GetPosition("Brunnen"))
	if table.getn(idBr) > 0 and Logic.IsConstructionComplete(idBr[1]) == 1 then
		idBr = idBr[1]
		ChangePlayer(idBr,2)
		gvBr = 1
		return true
	end
end
function FertigMeldung()
	if gvBr == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Salim",sal,"Der Brunnen steht jetzt und die Wasserversorgung kann losgehen.", true)
		ASP("Major3",maj3,"Danke, das wird uns sehr weiterhelfen.", true)
		briefing.finished = function()
			CreateMilitaryGroup(2,Entities.CU_BlackKnight_LeaderMace2,4,GetPosition("1"))
			CreateMilitaryGroup(2,Entities.CU_BlackKnight_LeaderMace2,4,GetPosition("1"))
			CreateMilitaryGroup(2,Entities.CU_BlackKnight_LeaderMace2,4,GetPosition("1"))
			CreateMilitaryGroup(2,Entities.CU_BlackKnight_LeaderMace2,4,GetPosition("1"))
			SetFriendly(2,8)
			SetFriendly(1,8)
			ActivateShareExploration(1,8,true)
			ActivateShareExploration(2,8,true)
		end;
		StartBriefing(briefing);
		return true
	end
end

function Eisen()
	local idEi = SucheAufDerWelt(1,Entities.PB_IronMine3,2000,GetPosition("Eisen"))
	if table.getn(idEi) > 0 and Logic.IsConstructionComplete(idEi[1]) == 1 then
		idEi = idEi[1]
		ChangePlayer(idEi,8)
		gvEi = 1
		return true
	end
end
function FertigMeldung2()
	if gvEi == 1 then
		Sound.PlayGUISound(Sounds.fanfare,90)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Salim",sal,"Fantastisch. Das Eisenbergwerk steht. Das wird diesen Krieg zu unseren Gunsten lenken.", true)
		ASP("Major3",maj3,"Danke, das wird uns sehr weiterhelfen.", true)
		briefing.finished = function()
			CreateMilitaryGroup(8,Entities.CU_BanditLeaderSword2,8,GetPosition("3"))
			CreateMilitaryGroup(8,Entities.CU_BanditLeaderSword2,8,GetPosition("3"))
			CreateMilitaryGroup(8,Entities.CU_BanditLeaderSword2,8,GetPosition("3"))
			SetFriendly(2,8)
			SetFriendly(1,2)
			ActivateShareExploration(1,2,true)
			ActivateShareExploration(2,8,true)
		end;
		StartBriefing(briefing);
		return true
	end
end

function Gewonnen1()
	if IsDead("Burg2")and IsDead("Haupt2") and IsDead("Burg3") and IsDead("Haupt3")then
		Logic.RemoveQuest(1,SalQuest)
		Victory()
		return true
	end
end
function Gewonnen2()
	if IsDead("Burg1")and IsDead("Haupt1") and IsDead("Stall") then
		Logic.RemoveQuest(1,SalQuest)
		Victory()
		return true
	end
end
function Gewonnen3()
	if IsDead("Burg1")and IsDead("Haupt1") and IsDead("Stall") then
		Logic.RemoveQuest(1,SalQuest)
		Victory()
		return true
	end
end
function Verloren1()
	if IsDead("Burg") then
		Defeat()
		return true
	end
end
function Truhen()
	CreateChest(GetPosition("chest1"),chestCallbackTruhe1)
	CreateChest(GetPosition("chest2"),chestCallbackTruhe2)
	CreateChest(GetPosition("chest3"),chestCallbackTruhe3)
	CreateChest(GetPosition("chest4"),chestCallbackTruhe4)
	CreateChest(GetPosition("chest5"),chestCallbackTruhe5)
	CreateChest(GetPosition("chest6"),chestCallbackTruhe6)
	CreateChest(GetPosition("chest7"),chestCallbackTruhe7)
	CreateChest(GetPosition("chest8"),chestCallbackTruhe8)
	CreateChest(GetPosition("chest9"),chestCallbackTruhe9)
	CreateChest(GetPosition("chest10"),chestCallbackTruhe10)
	CreateChest(GetPosition("chest11"),chestCallbackTruhe11)
	CreateChest(GetPosition("chest12"),chestCallbackTruhe12)
	CreateChest(GetPosition("chest13"),chestCallbackTruhe13)
	CreateChest(GetPosition("chest14"),chestCallbackTruhe14)
	CreateChest(GetPosition("chest15"),chestCallbackTruhe15)
	CreateChest(GetPosition("chest16"),chestCallbackTruhe16)
	CreateChest(GetPosition("chest17"),chestCallbackTruhe17)
	CreateChest(GetPosition("chest18"),chestCallbackTruhe18)
	CreateChest(GetPosition("chest19"),chestCallbackTruhe19)
	CreateChest(GetPosition("chest20"),chestCallbackTruhe20)
  	CreateChestOpener("Salim")
	StartChestQuest()
end
function chestCallbackTruhe1()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe2()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe3()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe4()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe5()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe6()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe7()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe8()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe9()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe10()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe11()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe12()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe13()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe14()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe15()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe16()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe17()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe18()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe19()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe20()
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Taler.")
	AddGold(1000)
end
function Felsen()
	if IsNear("Salim","Fels2",500) or IsNear("Salim","Fels4",500) then
		DestroyEntity("Fels1")
		DestroyEntity("Fels2")
		DestroyEntity("Fels3")
		DestroyEntity("Fels4")
		DestroyEntity("Fels5")
		DestroyEntity("Fels6")
		return true
	end
end
--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end
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