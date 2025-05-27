--------------------------------------------------------------------------------
-- MapName: Prolog: Feste Nuamyr
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Prolog: Feste Nuamyr @cr "
gvMapVersion = " v1.00"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(2,"Krathos")
	SetPlayerName(3,"Schwarze Feste")
	SetPlayerName(4,"Kroxon")
	SetPlayerName(5,"Bollwerk Nuamyr")
	SetPlayerName(6,"Landvolk")
	SetPlayerName(7,"Nebelvolk")
	SetPlayerName(8,"Räuber")
	SetFriendly(1,5)
	SetNeutral(1,4)
	SetHostile(2,5)
	SetHostile(3,5)
	SetHostile(8,5)
	SetHostile(7,5)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function InitResources()
    -- set some resources
    AddGold  (round(600*gvDiffLVL))
    AddSulfur(0)
    AddIron  (0)
    AddWood  (1400)
    AddStone (1200)
    AddClay  (1200)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function InitTechnologies()
	ForbidTechnology(Technologies.B_PowerPlant, 1)
	ForbidTechnology(Technologies.B_Weathermachine, 1)
	if gvDiffLVL > 1 then
		ResearchTechnology(Technologies.GT_Mathematics, 1)
	else
		ForbidTechnology(Technologies.T_MarketIron)
		ForbidTechnology(Technologies.T_MarketSulfur)
	end
	for i = 2, 6 do
		for k,v in pairs(gvTechTable.TroopUpgrades) do
			Logic.SetTechnologyState(i, v, 3)
		end
	end
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

	Display.SetPlayerColorMapping(3,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(4,2)
	Display.SetPlayerColorMapping(2,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(8,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(5,FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(6,NPC_COLOR)
	Display.SetPlayerColorMapping(7,9)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()
	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	LocalMusic.UseSet = MEDITERANEANMUSIC

	-- Level 0 is deactivated...ignore
	MapEditor_SetupAI(2, 4-gvDiffLVL, 8300, math.max(4-gvDiffLVL, 2), "P2Spawn", 3, 0)
	MapEditor_Armies[2].TroopRecruitmentDelay = round(4*gvDiffLVL)
	MapEditor_SetupAI(3, 3, 76800, 3, "Schwarz", 3, 0)
	MapEditor_Armies[3].TroopRecruitmentDelay = round(4*gvDiffLVL)
	if gvDiffLVL > 2 then
		MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength - 6
	end
	SetupPlayerAi( 3, {constructing = false, extracting = false, repairing = true, serfLimit = 1} )
	MapEditor_SetupAI(4, 4-gvDiffLVL, 25000, math.max(4-gvDiffLVL, 2), "Burg2", 3, 0)
	MapEditor_Armies[4].TroopRecruitmentDelay = round(5*gvDiffLVL)
	MapEditor_SetupAI(5, 3, 14000, 3, "Bollwerk", 3, 0)
	MapEditor_Armies[5].TroopRecruitmentDelay = round(3*gvDiffLVL)

	ActivateBriefingsExpansion()
	SetFriendly(1,5)
	SetHostile(1,8)
	Start()
	StartSimpleJob("Gewonnen")
	StartSimpleJob("Verloren")
	BRIEFING_TIMER_PER_CHAR = 1.8
	if gvDiffLVL == 1 then
		DestroyEntity("village")
		do
			local id, tbi, e = nil, table.insert, {};
			id = Logic.CreateEntity(Entities.XD_RockNorth4, 10813.16, 32156.92, 190.61, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066995093) --[[ Scale: 1.20 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth4, 10805.03, 32182.78, 263.57, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1064933672) --[[ Scale: 0.97 ]]
			id = Logic.CreateEntity(Entities.XD_Bush2, 11287.34, 31726.21, 0.00, 0);tbi(e,id)
			id = Logic.CreateEntity(Entities.XD_Bush3, 10722.52, 30735.35, 0.00, 0);tbi(e,id)
			id = Logic.CreateEntity(Entities.XD_GreeneryVertical2, 12134.49, 31078.52, 109.94, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066244069) --[[ Scale: 1.11 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth4, 11349.57, 31972.90, 74.32, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1063750915) --[[ Scale: 0.90 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth7, 11291.12, 30366.61, 144.05, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065808961) --[[ Scale: 1.05 ]]
			id = Logic.CreateEntity(Entities.XD_GreeneryVertical2, 11309.26, 30348.01, 263.63, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065163873) --[[ Scale: 0.99 ]]
			id = Logic.CreateEntity(Entities.XD_GreeneryVertical2, 11003.23, 30601.44, 291.96, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066280736) --[[ Scale: 1.11 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth1, 10993.65, 30613.63, 99.44, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1064987739) --[[ Scale: 0.98 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth5, 10636.40, 30676.83, 122.61, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065952221) --[[ Scale: 1.07 ]]
			id = Logic.CreateEntity(Entities.XD_RockNorth3, 10326.57, 30885.50, 313.22, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066676729) --[[ Scale: 1.16 ]]
			id = Logic.CreateEntity(Entities.XD_PlantNorth3, 10906.05, 31937.53, 183.59, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065390747) --[[ Scale: 1.00 ]]
			id = Logic.CreateEntity(Entities.XD_Tree4, 11130.00, 30495.64, 62.65, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066559473) --[[ Scale: 1.14 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 12083.21, 31202.21, 332.95, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065761448) --[[ Scale: 1.05 ]]
			id = Logic.CreateEntity(Entities.XD_Tree6, 12030.00, 31203.77, 307.32, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065709430) --[[ Scale: 1.04 ]]
			id = Logic.CreateEntity(Entities.XD_Bush1, 11336.75, 30758.90, 157.32, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066072036) --[[ Scale: 1.09 ]]
			id = Logic.CreateEntity(Entities.XD_Tree7, 11530.00, 30776.65, 147.94, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066022677) --[[ Scale: 1.08 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 11673.69, 30939.99, 277.49, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1062207699) --[[ Scale: 0.81 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 11469.92, 30721.79, 214.43, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1067011585) --[[ Scale: 1.20 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 11539.98, 30551.70, 281.45, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065765852) --[[ Scale: 1.05 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 10629.61, 30765.41, 157.23, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1064363489) --[[ Scale: 0.94 ]]
			id = Logic.CreateEntity(Entities.XD_Tree5, 10630.00, 30981.48, 149.32, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066676519) --[[ Scale: 1.16 ]]
			id = Logic.CreateEntity(Entities.XD_Tree6, 11125.38, 30970.00, 248.93, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066727522) --[[ Scale: 1.16 ]]
			id = Logic.CreateEntity(Entities.XD_Tree4, 11619.67, 30730.00, 249.96, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1064234667) --[[ Scale: 0.93 ]]
			id = Logic.CreateEntity(Entities.XD_Bush1, 10797.14, 31445.50, 298.23, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066722606) --[[ Scale: 1.16 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 11049.84, 31654.96, 243.20, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066478682) --[[ Scale: 1.13 ]]
			id = Logic.CreateEntity(Entities.XD_Tree7, 10729.74, 31629.18, 67.44, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065600571) --[[ Scale: 1.03 ]]
			id = Logic.CreateEntity(Entities.XD_Bush4, 10969.85, 31921.49, 294.92, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065351067) --[[ Scale: 1.00 ]]
			id = Logic.CreateEntity(Entities.XD_Rock1, 10833.09, 32108.92, 20.40, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1062167557) --[[ Scale: 0.81 ]]
			id = Logic.CreateEntity(Entities.XD_Tree5, 11213.23, 31388.74, 161.92, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065579784) --[[ Scale: 1.03 ]]
			id = Logic.CreateEntity(Entities.XD_Bush1, 11455.31, 31681.65, 71.56, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065602005) --[[ Scale: 1.03 ]]
			id = Logic.CreateEntity(Entities.XD_Tree5, 10287.07, 31230.00, 3.12, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1063467053) --[[ Scale: 0.89 ]]
			id = Logic.CreateEntity(Entities.XD_Tree6, 10430.00, 31778.85, 2.48, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1065443586) --[[ Scale: 1.01 ]]
			id = Logic.CreateEntity(Entities.XD_Tree4, 11670.00, 30370.00, 126.48, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066673138) --[[ Scale: 1.16 ]]
			id = Logic.CreateEntity(Entities.XD_Tree7, 10328.67, 30770.00, 5.12, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1066086573) --[[ Scale: 1.09 ]]
		end
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(2,3,4,5), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		if Logic.IsLeader(eID) == 1 then
			if gvDiffLVL > 2 and GetPlayer(eID) == 3 and Logic.GetEntityType(eID) == Entities.PV_Cannon6 and math.random(1,2) == 2 then
				DestroyEntity(eID)
			else
				table.insert(gvLightning.IgnoreIDs, eID)
				Logic.GroupStand(eID)
			end
		end
	end
	InitAchievementChecks()
end
function FarbigeNamen()
	orange 	= "@color:255,127,0 "
	lila 	= "@color:250,0,240 "
	weiss	= "@color:255,255,255 "

  	ment 	= ""..orange.." Mentor "..lila..""
	dario	= ""..orange.." Dario "..lila..""
	erec    = ""..orange.." Erec "..lila..""
	PF 		= ""..orange.." Meister Brückbert "..lila..""
	prin	= ""..orange.." Bridget, Tochter von Brückbert "..lila..""
	afm  	= ""..orange.." Clayton, Sohn des Clayertes "..lila..""
	myn     = ""..orange.." Rätselmeister Mhüs - Thikk "..lila..""
	thi		= ""..orange.." Schmieriger Geselle "..lila..""
	p4c   	= ""..orange.." Anführer von Kroxon "..lila..""
	tr     	= ""..orange.." Eisenmogul von Nuamon "..lila..""
	mi		= ""..orange.." Peter Steinnase "..lila..""
	he      = ""..orange.." Der wandernde Bernd "..lila..""
	sm		= ""..orange.." Meistermechanikus "..lila..""
	Ko		= ""..orange.." Kommandant von Nuamon "..lila..""
end
function Start()
	band_armies = {
		[1] =	{strength = math.max(3 - gvDiffLVL, 1),
				position = "BandD",
				etype = Entities.CU_BanditLeaderSword1,
				xpLVL = 3 - gvDiffLVL,
				rodeLength = 4200 - (400*gvDiffLVL)},
		[2] = 	{strength = 4 - gvDiffLVL,
				position = "BandC",
				etype = Entities.CU_BanditLeaderSword1,
				xpLVL = 3 - gvDiffLVL,
				rodeLength = 3800 - (400*gvDiffLVL)},
		[3]	=	{strength = math.max(3 - gvDiffLVL, 1),
				position = "BandC",
				etype = Entities.CU_BanditLeaderBow1,
				xpLVL = 4 - gvDiffLVL,
				rodeLength = 3800 - (400*gvDiffLVL)},
		[4] = 	{strength = 6 / gvDiffLVL,
				position = "BandE",
				etype = Entities["PU_LeaderSword".. 5 - gvDiffLVL],
				xpLVL = 3 - gvDiffLVL,
				rodeLength = 7700 - (500 * gvDiffLVL)},
		[5] = 	{strength = math.max(5 - (2*gvDiffLVL), 1),
				position = "BandE",
				etype = Entities["PU_LeaderBow".. 5 - gvDiffLVL],
				xpLVL = 4 - gvDiffLVL,
				rodeLength = 7700 - (500 * gvDiffLVL)},
		[6] = 	{strength = 4 - gvDiffLVL,
				position = "BandE",
				etype = Entities.CU_BanditLeaderSword1,
				xpLVL = 3 - gvDiffLVL,
				rodeLength = 7700 - (500 * gvDiffLVL)},
		[7] = 	{strength = 4 / gvDiffLVL,
				position = "BanditenA",
				etype = Entities.CU_BanditLeaderBow1,
				xpLVL = round(4 / gvDiffLVL),
				rodeLength = 7000 - (200 * gvDiffLVL)},
		[8] =	{strength = math.max(7 - (3*gvDiffLVL), 1),
				position = "BanditenA",
				etype = Entities.CU_BanditLeaderSword1,
				xpLVL = round(4 / gvDiffLVL),
				rodeLength = 7000 - (200 * gvDiffLVL)},
		[9] = 	{strength = 4 / gvDiffLVL,
				position = "BanditenB",
				etype = Entities.CU_BanditLeaderBow1,
				xpLVL = round(4 / gvDiffLVL),
				rodeLength = 6200 - (200 * gvDiffLVL)},
		[10] =	{strength = math.max(7 - (3*gvDiffLVL), 1),
				position = "BanditenB",
				etype = Entities.CU_BanditLeaderSword1,
				xpLVL = round(4 / gvDiffLVL),
				rodeLength = 6200 - (200 * gvDiffLVL)}
	}
	for i = 1, table.getn(band_armies) do
		local army = {	player = 8,
						id = i - 1,
						strength = band_armies[i].strength,
						position = GetPosition(band_armies[i].position),
						rodeLength = band_armies[i].rodeLength
					}
		SetupArmy(army)
		for j = 1, army.strength do
			EnlargeArmy(army, {leaderType = band_armies[i].etype, experiencePoints = band_armies[i].xpLVL})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ControlBanditArmy",1,{},{army.player, army.id})
	end
	IntroNotes()
end
function ControlBanditArmy(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	end
	Defend(army)
end
function IntroNotes()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Sicht3",ment,"Willkommen, mächtiger Anführer. Bevor das Spiel startet, möchte ich Euch gerne einige Hinweise zu dieser Kampagne zum Besten geben.", false)
	ASP("fake_dario",ment,"Im Laufe der nächsten Karten werdet ihr @color:15,64,255 DARIO @color:255,255,255 als euren Haupthelden haben. (Nur) Mit ihm könnt ihr eine Vielzahl von Interaktionen durchführen wie z.B. Gespräche mit anderen Charakteren führen, Höhlen betreten und außerdem mit einer Vielzahl von Objekten und Hindernissen interagieren. @cr @cr Scheint euch ein Hindernis, Gebäude, Baum oder dergleichen verdächtig, so verzagt nicht und begebt Euch mit @color:15,64,255 DARIO @color:255,255,255 in seine Nähe.", false)
	ASP("Stein",ment,"Achtet auch besonders auf Eure Helden. @cr Fällt einer von ihnen in Ohnmacht, habt ihr das Spiel automatisch verloren! @cr Habt ihr viele Missionen abgeschlossen und nähert Euch dem Endkampf, wird dies aufgehoben. @cr Und nun viel Spaß mit den folgenden Kampagnenkarten.", false)
	briefing.finished = function()
		DestroyEntity("fake_dario")
		IntroCutscene()
	end
    StartBriefing(briefing)
    return true
end
function IntroCutscene()
	local cutsceneTable = {
    StartPosition = {position = GetPosition("Sicht"), angle = 25, zoom = 2800, rotation = 170},
	Flights = 	{
		{
		position = GetPosition("Sicht2"),
		angle = 13,
		zoom = 4600,
		rotation = 120,
		duration = 17,
		action 	=	function()

					end,
		title = " @color:180,0,240 Mentor",
		text = " @color:230,0,0 Nach dem vielen Stress im Reich gönnt sich Dario einen redlich verdienten Urlaub... ",
		},
		{
		position = GetPosition("cutscene_end"),
		angle = 4,
		zoom = 7200,
		rotation = 50,
		duration = 13,
		delay = 2,
		action 	=	function()

					end,
		title = " @color:180,0,240 Mentor",
		text = " @color:230,0,0 Er ist in die friedliche und idyllische Provinz Nuamon gereist, um die Aufgaben als König erst einmal weit hinter sich zu lassen...",
		}
	},
	Callback = function()
		Prolog()
	end,

	}
	Start_Cutscene(cutsceneTable)
end
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Dario",dario,"Wirklich ein schönes Fleckchen Erde hier. @cr Ich muss wohl zukünftig dieser Provinz häufiger einen Besuch abstatten.", true)
	ASP("Dario",dario,"Das Bollwerk Nuamyr soll hier ganz in der Nähe sein. @cr Ich hatte Erec dort als Regenten installieren lassen. @cr Ich sollte ihn beizeiten gebührend begrüßen.", true)
	AP{
		title = dario,
		text = "Er befindet sich dort oben auf dem Felsplateau, auf dem das Bollwerk Nuamyr errichtet worden ist.",
		position = GetPosition("Erec"),
		marker = ANIMATED_MARKER,
		dialogCamera = false,
		}

	ASP("Bridge",dario,"Die starken Regenfälle scheinen die Brücken zerstört zu haben. @cr Wir werden Erec also nicht direkt erreichen können.", true)
	ASP("Dario",dario,"Nun, wir sind im Urlaub und sollten zunächst die schöne Landschaft genießen. @cr Ich denke nicht, dass Erec uns bereits erwartet.", true)
    briefing.finished = function()
		DarioQuest()
		EnableNpcMarker(GetEntityId("Erec"))
		EnableNpcMarker(GetEntityId("PrincessFather"))
		EnableNpcMarker(GetEntityId("princess"))
		EnableNpcMarker(GetEntityId("afraid_miner"))
		Erec()
		PrincessFather()
		Afraid_Miner()
		Truhen()
		StartCountdown(20*60*gvDiffLVL,VikingAttack, false)
		StartCountdown(30*60*gvDiffLVL,KIStep1, false)
		gvDayCycleStartTime = Logic.GetTime()
		TagNachtZyklus(32,1,0,(0-gvDiffLVL),1)
		WolfPatrol()
		StartSimpleJob("MountainPath")
		StartSimpleJob("DarioNearNuamon")
		StartSimpleJob("mystic_npc_Check")
	end
    StartBriefing(briefing)
    return true
end
function DarioQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	="Sucht Erec auf",
	text	= "Findet Erec an seiner Burg. Achtung, die starken Regenschauer scheinen jegliche Brücken nach Feste Nuamyr blockiert zu haben. @cr Tipp: Achtet auf Dario. Wenn er in Ohnmacht fällt, habt ihr das Spiel verloren.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DariQuest = quest.id
end
function KIStep1()
	MapEditor_Armies[2].offensiveArmies.rodeLength = Logic.WorldGetSize()
	MapEditor_Armies[2].offensiveArmies.strength = MapEditor_Armies[2].offensiveArmies.strength + round(4/gvDiffLVL)
	MapEditor_Armies[5].offensiveArmies.rodeLength = MapEditor_Armies[5].offensiveArmies.rodeLength * 2
	StartCountdown(20*60*gvDiffLVL,KIStep2, false)
	--
	MakeInvulnerable("P5VC")
	SetHostile(1,2)
end
function KIStep2()
	MapEditor_Armies[2].offensiveArmies.strength = MapEditor_Armies[2].offensiveArmies.strength + round(2/gvDiffLVL)
	MapEditor_Armies[3].offensiveArmies.strength = MapEditor_Armies[3].offensiveArmies.strength + round(4/gvDiffLVL)
	MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength + round(2/gvDiffLVL)
	MapEditor_Armies[5].offensiveArmies.rodeLength = Logic.WorldGetSize()
	MapEditor_Armies[5].offensiveArmies.strength = MapEditor_Armies[5].offensiveArmies.strength + (round(3*gvDiffLVL))
	StartCountdown(20*60*gvDiffLVL,KIStep2, false)
end
function VikingAttack()
	if IsExisting("rock_barbarian") then
		DestroyEntity("rock_barbarian")
	end
	if IsExisting("VikingTower") then
		local army = {player = 8, id = GetFirstFreeArmySlot(8), position = GetPosition("VikingSpawn"),
			strength = math.min(Logic.GetTime() / 300 / gvDiffLVL, 14 - (4*gvDiffLVL)), rodeLength = 16000}
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = Entities.CU_Barbarian_LeaderClub2, experiencePoints = math.min(5 - (2*gvDiffLVL), 1)})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ControlVikingArmy",1,{},{army.player, army.id})
		StartCountdown(10*60*gvDiffLVL,VikingAttack,false)
		--
		if IsExisting("Viking_CTower1") then
			if GetPlayer("Viking_CTower1") == 3 then
				ChangePlayer("Viking_CTower1", 8)
			end
		end
		if IsExisting("Viking_CTower2") then
			if GetPlayer("Viking_CTower2") == 3 then
				ChangePlayer("Viking_CTower2", 8)
			end
		end
	end
	SetupPlayerAi( 3, {constructing = true, extracting = false, repairing = true, serfLimit = round(8/gvDiffLVL)} )
end
function ControlVikingArmy(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	end
	Defend(army)
end
function MountainPath()
	if IsExisting("rock_barbarian") then
		if IsNear("Dario","rock_barbarian",750) then
			Cutscene_MountainPath()
			return true
		end
	else
		return true
	end
end
function Cutscene_MountainPath()
	local cutsceneTable = {
    StartPosition = {position = GetPosition("Dario"), angle = 35, zoom = 2800, rotation = 170},
	Flights = 	{
		{
		position = GetPosition("Path1"),
		angle = 26,
		zoom = 2400,
		rotation = 150,
		duration = 9,
		action 	=	function()

					end,
		title = " @color:180,0,240 Dario",
		text = " @color:230,0,0 Oh, hier scheint ein alter Pfad zu sein... ",
		},
		{
		position = GetPosition("Path2"),
		angle = 17,
		zoom = 2000,
		rotation = 130,
		duration = 11,
		delay = 3,
		action 	=	function()

					end,
		title = " @color:180,0,240 Dario",
		text = " @color:230,0,0 Er führt wohl weiter in die Berge hinein...",
		}
	},
	Callback = function()
		Path_Clearance_Brief()
	end,

	}
	Start_Cutscene(cutsceneTable)
end
function Path_Clearance_Brief()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("Dario",dario,"Wir sollten das Geröll mit einigen Leibeigenen beseitigen können...", false)
    ASP("Dario",dario,"Doch wer weiß, was uns dahinter erwartet...", false)
    briefing.finished = function()
		local posX, posY = Logic.GetEntityPosition(GetID("DarioRet"))
		TeleportSettler(GetID("Dario"), posX, posY)
		newID = ReplaceEntity("rock_serf",Entities.XD_Stone_BlockPath)
		Logic.SetResourceDoodadGoodAmount(newID,20)
		Logic.SetModelAndAnimSet(newID,Models.XD_RockMedium7)
		Logic.SetEntityName(newID,"Serf_Rock")
		StartSimpleJob("Serf_Rock_Control")
	end
    StartBriefing(briefing)
    return true
end
function Serf_Rock_Control()
	if not IsExisting("Serf_Rock") then
		DestroyEntity("rock_barbarian")
		DestroyEntity("rock_remove1")
		DestroyEntity("rock_remove2")
		DestroyEntity("rock_remove3")
		--
		ChangePlayer("Viking_CTower1", 8)
		ChangePlayer("Viking_CTower2", 8)
		--
		WikingDefenseArmy()
		return true
	end
end
function WikingDefenseArmy()
	local army = {player = 8, id = GetFirstFreeArmySlot(8), position = GetPosition("VikingSpawn"),
		strength = round(4/gvDiffLVL), rodeLength = 3700}
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_Barbarian_LeaderClub2, experiencePoints = math.min(5 - (2*gvDiffLVL), 1)})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ControlVikingArmy",1,{},{army.player, army.id})
end
function WolfPatrol()
	do
		local pos1_start_X,pos1_start_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_1_patrol1"))
		local patrol_1_X,patrol_1_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_1_patrol1"))
		local patrol_2_X,patrol_2_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_1_patrol2"))
		local patrol_3_X,patrol_3_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_1_patrol3"))
		local WolfIDTable = {Logic.GetEntitiesInArea(Entities.CU_AggressiveWolf, pos1_start_X, pos1_start_Y, 2000, 16)}
		for i = 2,table.getn(WolfIDTable) do
			Logic.GroupPatrol(WolfIDTable[i],patrol_3_X-(i*30), patrol_3_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_1_X-(i*30), patrol_1_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_2_X-(i*30), patrol_2_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_3_X-(i*30), patrol_3_Y-(i*30))
		end
	end
	do
		local pos2_start_X,pos2_start_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_2_patrol1"))
		local patrol_1_X,patrol_1_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_2_patrol1"))
		local patrol_2_X,patrol_2_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_2_patrol2"))
		local patrol_3_X,patrol_3_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_2_patrol3"))
		local WolfIDTable = {Logic.GetEntitiesInArea(Entities.CU_AggressiveWolf, pos2_start_X, pos2_start_Y, 2000, 16)}
		for i = 2,table.getn(WolfIDTable) do
			Logic.GroupPatrol(WolfIDTable[i],patrol_3_X-(i*30), patrol_3_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_1_X-(i*30), patrol_1_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_2_X-(i*30), patrol_2_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_3_X-(i*30), patrol_3_Y-(i*30))
		end
	end
	do
		local pos3_start_X,pos3_start_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_3_patrol1"))
		local patrol_1_X,patrol_1_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_3_patrol1"))
		local patrol_2_X,patrol_2_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_3_patrol2"))
		local patrol_3_X,patrol_3_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_3_patrol3"))
		local WolfIDTable = {Logic.GetEntitiesInArea(Entities.CU_AggressiveWolf, pos3_start_X, pos3_start_Y, 2000, 16)}
		for i = 2,table.getn(WolfIDTable) do
			Logic.GroupPatrol(WolfIDTable[i],patrol_3_X-(i*30), patrol_3_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_1_X-(i*30), patrol_1_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_2_X-(i*30), patrol_2_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_3_X-(i*30), patrol_3_Y-(i*30))
		end
	end
	do
		local pos4_start_X,pos4_start_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_4_patrol1"))
		local patrol_1_X,patrol_1_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_4_patrol1"))
		local patrol_2_X,patrol_2_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_4_patrol2"))
		local patrol_3_X,patrol_3_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_4_patrol3"))
		local WolfIDTable = {Logic.GetEntitiesInArea(Entities.CU_AggressiveWolf, pos4_start_X, pos4_start_Y, 2000, 16)}
		for i = 2,table.getn(WolfIDTable) do
			Logic.GroupPatrol(WolfIDTable[i],patrol_3_X-(i*30), patrol_3_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_1_X-(i*30), patrol_1_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_2_X-(i*30), patrol_2_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_3_X-(i*30), patrol_3_Y-(i*30))
		end
	end
	do
		local pos5_start_X,pos5_start_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_5_patrol1"))
		local patrol_1_X,patrol_1_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_5_patrol1"))
		local patrol_2_X,patrol_2_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_5_patrol2"))
		local patrol_3_X,patrol_3_Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("wolf_5_patrol3"))
		local WolfIDTable = {Logic.GetEntitiesInArea(Entities.CU_AggressiveWolf, pos5_start_X, pos5_start_Y, 2000, 16)}
		for i = 2,table.getn(WolfIDTable) do
			Logic.GroupPatrol(WolfIDTable[i],patrol_3_X-(i*30), patrol_3_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_1_X-(i*30), patrol_1_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_2_X-(i*30), patrol_2_Y-(i*30))
			Logic.GroupAddPatrolPoint(WolfIDTable[i], patrol_3_X-(i*30), patrol_3_Y-(i*30))
		end
	end
end
function DarioNearNuamon()
	if IsNear("Dario", "nua_flag", 600) then
		StartCutscene("Nuamon")
		return true
	end
end
function Erec()
	local BeiEr = {
	EntityName = "Dario",
    TargetName = "Erec",
    Distance = 500,
    Callback = function()
		LookAt("Erec","Dario");LookAt("Dario","Erec")
		DisableNpcMarker(GetEntityId("Erec"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Erec",erec,"Dario, schön dich hier zu sehen. Gefällt es dir in Nuamon? @cr Sieh dir nur diese Landschaft an.", true)
		ASP("Sicht3",erec,"Also ich finde es hier wunderschön. @cr Ich könnte bis zu meinem Lebensende hier bleiben. @cr Ist nur jammerschade, dass der Starkregen hier die Brücken immer wieder zerstört.", false)
		ASP("Dario",dario,"Ja in der Tat, werter Freund. @cr Ich finde es hier auch wunderschön, und das mit den Brücken... @cr Tja, nun bin ich ja da.", true)
		ASP("Dario",dario,"Du siehst so bedrückt aus, was gibt es? @cr Das Wetter allein wird es bestimmt nicht sein, dass dir auf den Magen schlägt.", true)
		ASP("Erec",erec,"Ich habe schon immer deine Beobachtungsgabe bewundert, Dario. @cr Wie machst du das nur? @cr Und tatsächlich es gibt da wirklich etwas, das ich versuche, zu verdrängen.", true)
		ASP("Erec",erec,"Hier in der Nähe befinden sich einige Dörfer an den Hängen des Berges dahinten. @cr Sie waren immer freundlich zu uns und es gab auch nie Streitigkeiten zwischen unseren Siedlungen.", true)
		ASP("Erec",erec,"Seit einigen Wochen greifen sie uns jetzt auf einmal an. @cr Sie behaupten auf einmal, die Steuern wären zu hoch.", true)
		ASP("Dario",dario,"Und? @cr Sind sie es denn?", true)
		ASP("Erec",erec,"Nein nein, auf keinen Fall, sie haben sich seit meiner Regentschaft hier vor drei Jahren nie geändert und es gab nie Probleme damit.", true)
		ASP("Erec",erec,"Die Ernte ist dieses Jahr auch gut ausgefallen, sie könnten ihren Tribut also problemlos leisten. @cr Es muss etwas anderes sein, da bin ich mir absolut sicher...", true)
		ASP("Komm",erec,"Der Kommandant und ich haben uns darüber bereits den Kopf zerbrochen und sind zum einzig möglichen Schluss gekommen. @cr Hör genau zu ...", false)
		ASP("Erec",erec,"Die Dörfer wurden mit Sicherheit von irgendjemanden gegen uns aufgehetzt. @cr Nur dadurch könnten sie so überaus aggressiv sein. @cr Jegliche Friedensverhandlungen waren zunichte, selbst nobles Entgegenkommen wie eine Halbierung der Steuern.", true)
		ASP("Truppen",erec,"Es geht zwar keine Gefahr von ihnen aus, unsere Truppen sind ihnen gewachsen, aber doch fordert so ein unnützer Krieg seine Opfer...", false)
		ASP("Erec",erec,"Und das alles hat seinen Anfang genommen, seit dort hoch oben in den Bergen so ein komischer Kauz mit seiner Gefolgschaft eine düstere Festungsanlage errichtet hat.", true)
		ASP("Schwarz2",erec,"Bestimmt stecken die Bastarde dahinter und haben die Dörfer gegen uns aufgehetzt.", false)
		ASP("Angst",erec,"Hier gehen sogar schon die Gerüchte um, dass hinter all dem Kerberos steckt, er angeblich wieder aufgetaucht sei.", false)
		ASP("Dario",dario,"Das kann nicht sein mein alter Freund, wir haben ihn und seinen Truppen doch eigenhändig vernichtet. @cr Aber ich merke schon, aus dem Urlaub wird wohl nichts...", true)
		ASP("Erec",erec,"Nein, gönnt Euch ruhig eure Auszeit, ihr habt sie mehr als jeder andere verdient. @cr Ich werde mich schon selbst darum kümmern.", true)
		ASP("Dario",dario,"Auf gar keinen Fall, ich lasse doch nicht meinen besten Freund im Stich. @cr Ich werde euch bestmöglich beistehen, wenn es sein muss, sogar eigenhändig im Kampf.", true)
		ASP("Erec",erec,"Dachte ich es mir doch, das Wort Urlaub ist für euch ein Fremdwort. @cr Also hier die Einzelheiten.", true)
		AP{
			title = erec,
			text = "Wie schon gesagt, die Schwarze Feste ist uns das größte Dorn im Auge. Sie befindet sich dort oben. @cr Es gibt nichts über gut honorierte Späher.",
			position = GetPosition("Burg1"),
			marker = STATIC_MARKER,
			dialogCamera = false,
			}
		AP{
		 title = erec,
			text = "Das Dorf am Hang des Berges liegt hier. @cr Da beide Siedlungen uns schon recht lange nicht mehr angegriffen haben, gehen wir davon aus, dass auch die Brücke dort zerstört wurde.",
			position = GetPosition("Burg2"),
			marker = STATIC_MARKER,
			dialogCamera = false,
			}
		AP{
		 title = erec,
			text = "Und die dritte und letzte Siedlung, die uns auch immer noch attackiert, liegt dort.",
			position = GetPosition("Burg3"),
			marker = STATIC_MARKER,
			dialogCamera = false,
			}
		ASP("Erec",erec,"Ihr könnt uns gerne dabei helfen, sie alle drei dem Erdboden gleichzumachen.", true)
		ASP("Dario",dario,"Selbstverständlich, mein alter Freund. @cr Wir sehen uns auf dem Schlachtfeld.", true)
		ASP("Dario",ment,"Dario und Erec waren wieder einmal vereint. @cr Erec und Nuamon's Truppen werden sich auf dem Schlachtfeld um Dario's Befinden kümmern. @cr Es ist nun nicht mehr spielentscheidend, wenn Dario in Ohnmacht fällt.", false)
		briefing.finished = function()
			Chapter1Done = true
			StartCutscene("Krathos", Krathos_CutsceneDone)
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiEr)
end
function Krathos_CutsceneDone()
	ChangePlayer("Erec",5)
	Logic.RemoveQuest(1,DariQuest)
	ErecQuest()
	EnableNpcMarker(GetEntityId("thief"))
	EnableNpcMarker(GetEntityId("trader"))
	EnableNpcMarker(GetEntityId("miner"))
	EnableNpcMarker(GetEntityId("hermit"))
	EnableNpcMarker(GetEntityId("smelter"))
	Thief()
	Trader()
	Miner()
	Hermit()
	Smelter()
	ActivateShareExploration(1, 5, true)
	StartSimpleJob("CheckForBridge")
	StartSimpleJob("CheckForKrathosDown")
	ConnectLeaderWithArmy(GetID("Erec"), nil, "offensiveArmies")
	--
	SetHostile(1,2)
end
function Thief()
	local BeiTh = {
	EntityName = "Dario",
    TargetName = "thief",
    Distance = 500,
    Callback = function()
		LookAt("thief","Dario");LookAt("Dario","thief")
		DisableNpcMarker(GetEntityId("thief"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("thief",thi,"Psst ihr, ja genau ihr...", false)
		ASP("Dario",ment,"Herr, seid vorsichtig. @cr Dieser Dieb wirkt nicht grade vertrauenderweckend.", false)
		ASP("thief",thi,"Für ein paar Talerchen verrate ich Euch ein Geheimnis. @cr Informationen aus erster Hand, das garantiere ich Euch.", true)
		briefing.finished = function()
			ThiefTribute()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiTh)
end
function ThiefTribute()
	local TrTh =  {}
	TrTh.playerId = 1
	TrTh.text = "Zahlt ".. round(15000/gvDiffLVL) .." Taler, damit Euch der schmierige Geselle sein Geheimnis verrät."
	TrTh.cost = { Gold = round(15000/gvDiffLVL) }
	TrTh.Callback = TributePaid_Th
	TTh = AddTribute(TrTh)
end
function TributePaid_Th()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("thief",thi,"Vor einiger Zeit bin ich einer Schriftrolle... hüstel ... habhaft geworden.", true)
    ASP("grave",thi,"Sie lag hier nur leicht vergraben herum. @cr Da konnte ich sie doch nicht einfach liegenlassen...", false)
	ASP("thief",thi,"Nun denn; zum Inhalt der Schriftrolle: @cr @cr Seid ihr meines würdig? Zu finden zur rechten Zeit am rechten Ort.", false)
    briefing.finished = function()
		QuestMystic()
	end
    StartBriefing(briefing)
end
function QuestMystic()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Die mysteriöse Schriftrolle",
		text	= "Ein Bewohner Nuamons ist einer mysteriösen Schriftrolle habhaft geworden, in deren Inhalt ihr Leser herausgefordert wird. @cr Ihr Inhalt: @cr @cr Seid ihr meines würdig? Zu finden zur rechten Zeit am rechten Ort.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	MysQuest1 = quest.id
end
function Trader()
	local BeiTr = {
	EntityName = "Dario",
    TargetName = "trader",
    Distance = 500,
    Callback = function()
		LookAt("trader","Dario");LookAt("Dario","trader")
		DisableNpcMarker(GetEntityId("trader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("trader",tr,"Guten Tag der Herr. @cr Ich verkaufe das feinste Eisen dieser Gegend.", false)
		ASP("trader",tr,"Schaut in Euer Tributmenü. @cr Ihr werdet nirgends bessere Qualität zu besseren Preisen bekommen.", false)
		briefing.finished = function()
			IronTribute1()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiTr)
end
function IronTribute1()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(3000/gvDiffLVL) .." Taler für 2000 Eisen."
	Tr.cost = { Gold = round(3000/gvDiffLVL) }
	Tr.Callback = TributePaid_Iron1
	TrI1 = AddTribute(Tr)
end
function TributePaid_Iron1()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("trader",tr,"Danke für die Taler. @cr Hier ist Euer Eisen. @cr Kommt gerne wieder zum Handeln vorbei.", false)
    briefing.finished = function()
		AddIron(2000)
		IronTribute2()
	end
    StartBriefing(briefing)
end
function IronTribute2()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(4000/gvDiffLVL) .." Taler für 2200 Eisen."
	Tr.cost = { Gold = round(4000/gvDiffLVL) }
	Tr.Callback = TributePaid_Iron2
	TrI2 = AddTribute(Tr)
end
function TributePaid_Iron2()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("trader",tr,"Immer schön, mit Euch Geschäfte zu machen. @cr Handelt gerne weiter mit mir.", false)
    briefing.finished = function()
		AddIron(2200)
		IronTribute3()
	end
    StartBriefing(briefing)
end
function IronTribute3()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(5000/gvDiffLVL) .." Taler für 2400 Eisen."
	Tr.cost = { Gold = round(5000/gvDiffLVL) }
	Tr.Callback = TributePaid_Iron3
	TrI3 = AddTribute(Tr)
end
function TributePaid_Iron3()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("trader",tr,"Mein Eisenvorrat geht leider allmählich zur Neige. @cr Ich muss leider die Preise etwas erhöhen, bis mehr Nachschub eintrifft. @cr Ich hoffe, ihr handelt dennoch weiter mit mir.", false)
    briefing.finished = function()
		AddIron(2400)
		IronTribute4()
	end
    StartBriefing(briefing)
end
function IronTribute4()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Zahlt ".. round(7000/gvDiffLVL) .." Taler für 2400 Eisen."
	Tr.cost = { Gold = round(7000/gvDiffLVL) }
	Tr.Callback = TributePaid_Iron3
	TrI4 = AddTribute(Tr)
end
function Miner()
	local BeiMi = {
	EntityName = "Dario",
    TargetName = "miner",
    Distance = 500,
    Callback = function()
		LookAt("miner","Dario");LookAt("Dario","miner")
		DisableNpcMarker(GetEntityId("miner"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("miner",mi,"Guten Tag edler Anführer. @cr Von hier oben hat man einen wunderschönen Ausblick. @cr Ich komme in Pausen von der Arbeit gerne hierher und blicke in die Ferne...", false)
		ASP("goldmine_view",mi,"Es könnte euch vielleicht interessieren, dass dort sich dort unten eine Golderzader befindet. @cr Ihr müsst lediglich den Pfad nahe des Lehmbergwerks folgen und den Pfad von umgestürzten Bäumen befreien. @cr Auch soll dort irgendwo in der Nähe eine verlassene Siedlung liegen...", false)
		briefing.finished = function()

		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiMi)
end
function Hermit()
	local BeiHe = {
	EntityName = "Dario",
    TargetName = "hermit",
    Distance = 500,
    Callback = function()
		LookAt("hermit","Dario");LookAt("Dario","hermit")
		DisableNpcMarker(GetEntityId("hermit"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("hermit",he,"Oh, auf andere Menschen stößt man hier auch nicht alle Tage. @cr Ihr müsst wissen, ich bin einer dieser Aussteiger... @cr ... der Zivilisation um jeden Preis meidet...", false)
		ASP("abandoned_village",he,"Nun, ich kam auf meinen Reisen nicht umher, dort hinten eine verlassene Siedlung zu entdecken. @cr Auch einige Ressourcen wurden dort wohl überhastet zurückgelassen und an der schroffen Felsküste wurde so mancher Schatz angespült...", false)
		ASP("bridges",he,"Der Zahn der Zeit und das schlechte Wetter haben hier wohl alle Brücken unpassierbar gemacht. @cr Früher kam man hier ohne Probleme bis nach Kroxon. @cr Aber ich will nicht klagen, so ist es hier zumindest schön ruhig und die Natur kann sich das Land zurückerobern...", false)
		briefing.finished = function()

		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiHe)
end
function Smelter()
	local BeiSm = {
	EntityName = "Dario",
    TargetName = "smelter",
    Distance = 500,
    Callback = function()
		LookAt("smelter","Dario");LookAt("Dario","smelter")
		DisableNpcMarker(GetEntityId("smelter"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("smelter",sm,"He, ihr da. @cr Ja genau, ihr. @cr Ihr habt nicht zufällig Kohle und Silber über? @cr Unser Statthalter hat mir leider weitere seltene Ressourcen verweigert und das nur, weil ich in der Vergangenheit einmal, ja nur ein einziges Mal...", true)
		ASP("smelter",sm,"...die halbe Siedlung abgefackelt hab. @cr Und dabei ist mir jetzt wirklich ein enormer Durchbruch gelungen. @cr Eine Kanone... @cr So eine Durchschlagskraft... @cr Das habt ihr noch nicht gesehen!", false)
		briefing.finished = function()
			CannonTribute()
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSm)
end
function CannonTribute()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Gebt dem Meistermechanikus ".. 500 .." Kohle und ".. 150 .." Silber für seine Kanonenforschung."
	Tr.cost = { Knowledge = 500, Silver = 150 }
	Tr.Callback = TributePaid_Cannon
	TrCa = AddTribute(Tr)
end
function TributePaid_Cannon()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
    ASP("smelter",sm,"Vielen Dank für die Lieferung. @cr Nun ihr werdet schon in Kürze meine Erfindung bewundern können.", false)
    briefing.finished = function()
		Logic.AddToPlayersGlobalResource(5, ResourceType.Knowledge, 500)
		Logic.AddToPlayersGlobalResource(5, ResourceType.Silver, 150)
		MapEditor_Armies[5].ForbiddenTypes = {Entities.PV_Cannon1}
		CannonTribute2()
	end
    StartBriefing(briefing)
end
function CannonTribute2()
	local Tr =  {}
	Tr.playerId = 1
	Tr.text = "Gebt dem Meistermechanikus ".. 500 .." Kohle und ".. 150 .." Silber für weitere machtvolle Kanonen."
	Tr.cost = { Knowledge = 500, Silver = 150 }
	Tr.Callback = TributePaid_Cannon
	TrCa2 = AddTribute(Tr)
end
--
function CheckForBridge()
	if Logic.GetEntitiesInArea(Entities.PB_Bridge1, 38800, 73800, 500, 1) > 0 then
		StartCutscene("Kroxon", Kroxon_CutsceneDone)
		return true
	end
end
function Kroxon_CutsceneDone()
	SetHostile(1, 3)
	SetHostile(1, 4)
	SetHostile(1, 7)
	SetHostile(5, 4)
	SetHostile(5, 7)
	StartSimpleJob("Caves")
	StartSimpleJob("Kroxon_Fallen")
end
function CheckForKrathosDown()
	if IsDestroyed("Burg3") then
		EnableNpcMarker(GetID("Komm"))
		Chief()
		return true
	end
end
function Chief()
	local BeiCF = {
	EntityName = "Dario",
    TargetName = "Komm",
    Distance = 300,
    Callback = function()
		LookAt("Komm","Dario");LookAt("Dario","Komm")
		DisableNpcMarker(GetEntityId("Komm"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Komm",Ko,"Euch ist sicherlich auch schon aufgefallen, dass jetzt, da Krathos gefallen ist, unsere Rekrutierungswege sehr sehr weit sind.", false)
		ASP("Burg2",Ko,"So werden wir Kroxon und auch die Schwarze Feste nicht effektiv attackieren können. @cr Unsere Truppen werden nicht mehr gesammelt dort eintreffen und ihre Schwerter ohne Wirkung sein...", false)
		ASP("Komm",Ko,"Seid doch bitte so gut und errichtet uns ein Militärgebäude nahe der gefallenen Siedlung Krathos. @cr Ich werde dann veranlassen, dass sich unsere Truppen dort sammeln werden.", false)
		briefing.finished = function()
			P5ArmyTypesByBuildingType = {
				[Entities.PB_Archery2] 	= {Entities.PU_LeaderBow4, Entities.PU_LeaderRifle2},
				[Entities.PB_Barracks2] = {Entities.PU_LeaderSword4, Entities.PU_LeaderPoleArm4},
				[Entities.PB_Stable2]	= {Entities.PU_LeaderCavalry2, Entities.PU_LeaderHeavyCavalry2, Entities.PU_LeaderUlan1},
				[Entities.PB_Foundry2]	= {Entities.PV_Cannon1, Entities.PV_Cannon2, Entities.PV_Cannon3, Entities.PV_Cannon4, Entities.PV_Cannon5, Entities.PV_Cannon6}
			}
			ChiefQuest()
			StartSimpleJob("CheckForMilitaryBuildingNearKrathos")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiCF)
end
function ChiefQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Ein Militärgebäude für den Kommandant Nuamyrs",
	text	= "Errichtet ein Militärgebäude nahe der gefallenen Siedlung Krathos, damit der Kommandant Nuamyrs es übernehmen, dort Truppen rekrutieren und den Sammelpunkt dorthin verlagern kann. @cr @cr Hinweis: Es können nur Militärgebäude der Stufe 2 übergeben werden. @cr Söldnertürme können nicht übergeben werden. @cr @cr Damit ihr nicht versehentlich Militärgebäude übergebt, müsst ihr zum Abschluss dieser Quest das Questmenü geöffnet und das Militärgebäude selektiert haben!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	KoQuest = quest.id
end
function CheckForMilitaryBuildingNearKrathos()
	if XGUIEng.IsWidgetShown("QuestWindow") == 1 then
		for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(1),
		CEntityIterator.OfAnyTypeFilter(Entities.PB_Barracks2, Entities.PB_Archery2, Entities.PB_Stable2, Entities.PB_Foundry2),
		CEntityIterator.InCircleFilter(44000, 72000, 8000)) do
			if GUI.GetSelectedEntity() == eID then
				Logic.RemoveQuest(1, KoQuest)
				local pos = GetPosition(eID)
				Redeploy(MapEditor_Armies[5], pos, nil, "offensiveArmies")
				local id = ChangePlayer(eID, 5)
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","CheckForLostPositionP5",1,{},{id})
				--
				local army 		= {}
				army.player 	= 5
				army.id 		= GetFirstFreeArmySlot(5)
				army.position 	= pos
				army.rodeLength	= Logic.WorldGetSize()
				army.strength	= round(3*gvDiffLVL)
				army.building 	= id
				army.trooptypes = P5ArmyTypesByBuildingType[Logic.GetEntityType(id)]
				SetupArmy(army)
				--
				for i = 1, army.strength do
					EnlargeArmy(army, {leaderType = army.trooptypes[math.random(1, table.getn(army.trooptypes))]})
				end
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRefreshingArmy",1,{},{army.player, army.id})
				return true
			end
		end
	end
end
function ControlRefreshingArmy(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		if IsExisting(army.building) then
			if Counter.Tick2("Player5ArmyRespawn_Counter", 180/gvDiffLVL) then
				for i = 1, army.strength do
					EnlargeArmy(army, {leaderType = army.trooptypes[math.random(1, table.getn(army.trooptypes))]})
				end
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRefreshingArmy",1,{},{army.player, army.id})
				return true
			end
		else
			return true
		end
	end
end
function CheckForLostPositionP5(_id)
	if IsDestroyed(_id) then
		local pos = GetPosition("Bollwerk")
		Redeploy(MapEditor_Armies[5], pos, nil, "offensiveArmies")
		return true
	end
end
function Kroxon_Fallen()
	if not IsExisting("Burg2") then
		do
			local id, tbi, e = nil, table.insert, {}
			id = Logic.CreateEntity(Entities.CU_VeteranCaptain, 39952.75, 62980.17, 110.00, 4);tbi(e,id);Logic.SetEntityName(id, "p4_captain")
		end
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("p4_captain",p4c,"Ihr glaubt doch nicht wirklich, dass es schon vorbei ist.", false)
		ASP("p4_captain",p4c,"Der dunkle Herrscher wird erstarken... @cr @cr ...und ihr könnt nichts, absolut nichts dagegen machen!", false)
		ASP("p4_captain",dario,"Schweig, du elender Rebell. @cr Männer, ergreift ihn und statuiert an ihm ein Exempel!", false)
		briefing.finished = function()
			StartCutscene("DarkCity")
		end
		StartBriefing(briefing)
		return true
	end
end
function PrincessFather()
	local BeiPF = {
	EntityName = "Dario",
    TargetName = "PrincessFather",
    Distance = 500,
    Callback = function()
		LookAt("PrincessFather","Dario");LookAt("Dario","PrincessFather")
		DisableNpcMarker(GetEntityId("PrincessFather"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("PrincessFather",PF,"Zu Hilf... Zu Hilf... Diese dreckigen Rebellen...", false)
		AP{
			title = PF,
			text = "Sie haben meine Tochter Bridget entführt und halten sie nun dort hinten gefangen...",
			position = GetPosition("princess"),
			explore = 10,
			dialogCamera = false,
			}
		ASP("PrincessFather",PF,"Ich bin nur ein armer Schlucker und kann das Lösegeld nicht alleine aufbringen.", false)
		ASP("princess",PF,"Nach dem Tod meiner Frau ist meine Tochter das Letzte, das ich habe. Bitte Herr, helft mir und befreit sie.", true)
		ASP("Dario",ment,"Herr, ihr müsst diesem armen Mann helfen. @cr Es liegt an Euch, ob ihr das Lösegeld auftreibt oder den Kampf mit den Entführern aufnehmt!", false)
		briefing.finished = function()
			PrincessFatherQuest()
			PrincessFatherTribute()
			StartSimpleJob("PrincessFatherJob")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiPF)
end
function PrincessFatherQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Die entführte Tocher",
	text	= "Befreit die entführte Tochter. @cr Es ist Euch überlassen, ob ihr das Lösegeld bezahlt oder die Entführer besiegt. @cr Eskortiert anschließend die Tochter sicher zu ihrem Vater",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	PFQuest = quest.id
end
function PrincessFatherTribute()
	local TrPF =  {}
	TrPF.playerId = 1
	TrPF.text = "Zahlt ".. round(6000/gvDiffLVL) .." Taler, um Bridget, die Tochter von Meister Brückbert, freizukaufen."
	TrPF.cost = { Gold = round(6000/gvDiffLVL) }
	TrPF.Callback = TributePaid_PF
	TPF = AddTribute(TrPF)
end
function TributePaid_PF()
	DestroyEntity("PFgrid")
	DisableNpcMarker(GetEntityId("princess"))
	StartSimpleJob("PrincessArriveJob")
end
function PrincessArriveJob()
	if IsNear("princess","PrincessFather",500) then
		EnableNpcMarker(GetEntityId("princess"))
		PrincessFatherSuccess()
		return true
	else
		Move("princess","princess_movepos")
	end
end
function PrincessFatherJob()
	local pos = GetPosition("princess")
	local enemies = {Logic.GetPlayerEntitiesInArea(8,Entities.CU_BanditLeaderSword1,pos.X,pos.Y,4500,1)}
	if enemies[1] == 0 then
		Logic.RemoveTribute(1,TPF)
		DestroyEntity("PFgrid")
		DisableNpcMarker(GetEntityId("princess"))
		StartSimpleJob("PrincessArriveJob")
		return true
	end
end
function PrincessFatherSuccess()
	local BeiPrin = {
	EntityName = "Dario",
    TargetName = "princess",
    Distance = 500,
    Callback = function()
		LookAt("princess","Dario");LookAt("Dario","princess")
		DisableNpcMarker(GetEntityId("princess"))
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("princess",prin,"Ihr habt mich gerettet. Vielen vielen Dank.", false)
		ASP("PrincessFather",PF,"Danke Herr, ihr habt meine Tochter sicher zurückgebracht. Ich habe nicht viel, aber nehmt doch bitte dies als Zeichen meiner Dankbarkeit.", false)
		ASP("Dario",ment,"Herr, seht doch. @cr Ihr habt von diesem Mann wertvolles Silber erhalten.", false)
		ASP("PrincessFather",PF,"Außerdem kann ich Euch die zerstörten Brücken nach Nuamon auf der Karte einzeichnen. @cr Vielleicht hilft Euch das ja ein wenig weiter.", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1,ResourceType.Silver,round(200+math.random(200)*gvDiffLVL))
			Logic.RemoveQuest(1,PFQuest)
			BridgeCountGUI()
		end
		StartBriefing(briefing);
	end
	}
	SetupExpedition(BeiPrin)
end
function BridgeCountGUI()
	gvBridgeData = {
		{X = 13259.80, Y = 24654.70},
		{X = 21347.05, Y = 33487.93},
		{X = 27091.80, Y = 12074.01},
		{X = 45203.96, Y =  7988.93},
		{X = 49563.09, Y =  4782.25},
		{X = 35559.80, Y = 31554.70}
	}
	gvBridgeBuilt = {
		false,
		false,
		false,
		false,
		false,
		false
	}
	gvBridges = 0
	GUIQuestTools.StartQuestInformation("Bridge", "", 1, 1)
	GUIQuestTools.UpdateQuestInformationString(gvBridges .. "/" .. table.getn(gvBridgeData))
	GUIQuestTools.UpdateQuestInformationTooltip = function()
		XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), "Brücken @cr Nach Nuamon zu errichtende Brücken")
	end
	StartSimpleJob("BridgeBuiltJob")
	for i = 1, table.getn(gvBridgeData) do
		Tools.ExploreArea(gvBridgeData[i].X, gvBridgeData[i].Y, 10)
	end
end

function BridgeBuiltJob()

	if Counter.Tick2("BridgeBuiltJob_Counter", 5) then
		for i = 1, table.getn(gvBridgeBuilt) do
			if gvBridgeBuilt[i] == false then
				for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Bridge), CEntityIterator.InCircleFilter(gvBridgeData[i].X, gvBridgeData[i].Y, 500)) do
					gvBridges = gvBridges + 1
					gvBridgeBuilt[i] = true
					break
				end
			end
		end
		GUIQuestTools.UpdateQuestInformationString(gvBridges .. "/" .. table.getn(gvBridgeData))

		if gvBridges >= table.getn(gvBridgeData) then
			GUIQuestTools.DisableQuestInformation()
			return true
		end
	end
end
function Afraid_Miner()
	local BeiAfM = {
	EntityName = "Dario",
    TargetName = "afraid_miner",
    Distance = 500,
    Callback = function()
		LookAt("afraid_miner","Dario");LookAt("Dario","afraid_miner")
		DisableNpcMarker(GetEntityId("afraid_miner"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("afraid_miner",afm,"... @cr Oh Herr, diese starken Regenfälle nahmen mir alles...", true)
		AP{
		title = afm,
		text = "...mein Haus...",
		position = GetPosition("ruin_residence"),
		explore = 10,
		dialogCamera = false,
		}
		AP{
		title = afm,
		text = "...meinen Arbeitsplatz...",
		position = GetPosition("ruin_claymine"),
		explore = 10,
		dialogCamera = false,
		}
		AP{
		title = afm,
		text = "...meinen Hof...",
		position = GetPosition("ruin_farm"),
		explore = 10,
		dialogCamera = false,
		}
		ASP("afraid_miner",afm,"... ich habe nun nichts mehr. Oh Herr, bitte richtet diese Ruinen wieder her. @cr Ohne ihren alten Glanz habe ich nichts mehr, das mich hier hält...", true)
		ASP("Dario",ment,"Herr, ihr müsst diesem armen Bergmann helfen. @cr Es liegt an Euch, ob ihr die Ruinen repariert und in altem Glanz erstrahlen lasst oder sie einreißt und neue Gebäude errichtet!", false)
		briefing.finished = function()
			Afraid_Miner_Quest()
			afM_count = 0
			StartSimpleJob("Claymine_Done")
			StartSimpleJob("Farm_Done")
			StartSimpleJob("Residence_Done")
			ChangePlayer("ruin_residence", 8)
			ChangePlayer("ruin_claymine", 8)
			ChangePlayer("ruin_farm", 8)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"residence_repair","ruin_residence","ruin_residence_rep1","ruin_residence_rep2","ruin_residence_rep3","ruin_residence_rep4",Entities.PB_Residence3,round(80*2/gvDiffLVL),6})
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"claymine_repair","ruin_claymine","ruin_claymine_rep1","ruin_claymine_rep2","ruin_claymine_rep3","ruin_claymine_rep4",Entities.PB_ClayMine3,round(120*2/gvDiffLVL),6})
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"farm_repair","ruin_farm","ruin_farm_rep1","ruin_farm_rep2","ruin_farm_rep3","ruin_farm_rep4",Entities.PB_Farm3,round(80*2/gvDiffLVL),6})
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiAfM)
end
function Afraid_Miner_Quest()
	local quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
	title	= "Frühjahrsputz",
	text	= "Lasst die Ruinen nahe des Bergmanns wieder in altem Glanz erstrahlen. @cr @cr Es liegt an Euch, ob ihr die Ruinen reparieren lasst oder sie einreißt und neue Gebäude errichtet!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	afMQuest = quest.id
end
function Claymine_Done()
	local pos = GetPosition("ClayMinePos")
	local mine = {Logic.GetPlayerEntitiesInArea(1,Entities.PB_ClayMine3,pos.X,pos.Y,1500,1)}
	if mine[1] == 0 then
		mine = {Logic.GetPlayerEntitiesInArea(6,Entities.PB_ClayMine3,pos.X,pos.Y,1500,1)}
	end
	if mine[1] > 0 and Logic.IsConstructionComplete(mine[2]) == 1 then
		afM_count = afM_count + 1
		ChangePlayer(mine[2], 1)
		if afM_count == 3 then
			Afraid_Miner_Done()
		end
		return true
	end
end
function Farm_Done()
	local pos = GetPosition("afraid_miner")
	local farm = {Logic.GetPlayerEntitiesInArea(1,Entities.PB_Farm3,pos.X,pos.Y,2500,1)}
	if farm[1] == 0 then
		farm = {Logic.GetPlayerEntitiesInArea(6,Entities.PB_Farm3,pos.X,pos.Y,2500,1)}
	end
	if farm[1] > 0 and Logic.IsConstructionComplete(farm[2]) == 1 then
		afM_count = afM_count + 1
		ChangePlayer(farm[2], 1)
		if afM_count == 3 then
			Afraid_Miner_Done()
		end
		return true
	end
end
function Residence_Done()
	local pos = GetPosition("ClayMinePos")
	local res = {Logic.GetPlayerEntitiesInArea(1,Entities.PB_Residence3,pos.X,pos.Y,3000,1)}
	if res[1] == 0 then
		res = {Logic.GetPlayerEntitiesInArea(6,Entities.PB_Residence3,pos.X,pos.Y,3000,1)}
	end
	if res[1] > 0 and Logic.IsConstructionComplete(res[2]) == 1 then
		afM_count = afM_count + 1
		ChangePlayer(res[2], 1)
		if afM_count == 3 then
			Afraid_Miner_Done()
		end
		return true
	end
end
function Afraid_Miner_Done()
	EnableNpcMarker(GetEntityId("afraid_miner"))
	Logic.RemoveQuest(1,afMQuest)
	Afraid_Miner_Done_Brief()
end
function Afraid_Miner_Done_Brief()
	local BeiMi = {
	EntityName = "Dario",
    TargetName = "afraid_miner",
    Distance = 500,
    Callback = function()
		LookAt("afraid_miner","Dario");LookAt("Dario","afraid_miner")
		DisableNpcMarker(GetEntityId("afraid_miner"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("afraid_miner",afm,"Ihr habt die zerstörten Gebäude wieder im alten Glanz erstrahlen lassen. @cr Habt tausendfachen Dank.", false)
		ASP("afraid_miner",afm,"Ich besitze aber leider nicht allzu viel, um Euch zu entlohnen, mein Herr.", true)
		ASP("Dario",ment,"Herr, seht doch. @cr Dieser Bergmann hat Euch sein Altmetall überlassen. @cr Bestimmt könnt Ihr es einschmelzen.", false)
		briefing.finished = function()
			Logic.AddToPlayersGlobalResource(1,ResourceType.IronRaw,round(800+math.random(400)*gvDiffLVL))
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiMi)
end
function ErecQuest()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Die Schwarze Feste",
	text	= "Helft Erec dabei, sowohl die Schwarze Feste als auch die feindlichen Siedlungen zu vernichten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	EreQuest = quest.id
end
function Gewonnen()
	if IsDead("Burg3")
	and IsDead("Burg2")
	and IsDead("Burg1") then
		if Logic.GetNumberOfLeader(3) <= 5 then
			local briefing = {}
			BRIEFING_TIMER_PER_CHAR = 1.0
			local AP, ASP = AddPages(briefing);
			ASP("FinalSpawn",erec,"Perfekt, die Feinde wurden vernichtet und die ursprüngliche Idylle kann wieder aufleben.", false)
			ASP("Haupt",dario,"Die Siedler der Bergdörfer redeten von einem bald bevorstehenden Machtwechsel im Norden, hmmm.", true)
			ASP("Haupt",dario,"Wir sollten wohl besser in den Norden reisen, um zu überprüfen, ob da was dran ist.", true)
			ASP("Erec",dario,"Erec du bleibst hier und lässt deine Verletzungen versorgen, du hast ganz schön was abgekriegt. @cr Ich frage mal Ari, ob sie mich begleitet. @cr In Sachen schnelles Überprüfen von Gerede macht ihr so schnell niemand etwas vor.", false)
			briefing.finished = function()
				Logic.RemoveQuest(1,EreQuest)
				Victory()
			end
			StartBriefing(briefing)
			return true
		end
	end
end

function Verloren()
	if IsDestroyed("Main") or IsDestroyed("Haupt") or IsDestroyed("Burg") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Burg",ment,"Warum habt Ihr die Burg nicht beschützt?", false)
		ASP("Haupt",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
		ASP("Dario",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
	if IsDead("Dario") and not Chapter1Done then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Burg",ment,"Warum habt Ihr Dario nicht beschützt?", false)
		ASP("Haupt",ment,"Jetzt ist er gefallen und damit habt ihr auch das Spiel verloren.", false)
		ASP("Dario",ment,"Versucht es noch mal und macht es dann besser.", false)
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
	gvTotalChestAmount = 24
	for i = 1, gvTotalChestAmount do
		CreateRandomGoldChest(GetPosition("chest"..i))
	end
	CreateChestOpener("Dario")
	StartChestQuest()

end

NVArmyTypes = {Entities.CU_Evil_LeaderBearman1,
	Entities.CU_Evil_LeaderBearman1,
	Entities.CU_Evil_LeaderSpearman1,
	Entities.CU_Evil_LeaderSkirmisher1,
	Entities.CU_Evil_LeaderSkirmisher1,
	Entities.CU_AggressiveScorpion1,
	Entities.CU_AggressiveScorpion2,
	Entities.CU_AggressiveScorpion3}
function Caves()
	local posX, posY = Logic.GetEntityPosition(GetID("CaveNV"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2000, 1) > 0 then
		local army = {}
		army.player = 7
		army.id = GetFirstFreeArmySlot(7)
		army.position = GetPosition("NVCave1")
		army.strength = round(10/gvDiffLVL)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{army.player, army.id})
		StartSimpleJob("Cave2")
		return true
	end
end
function Cave2()
	local posX, posY = Logic.GetEntityPosition(GetID("Cave1"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2000, 1) > 0 then
		local army = {}
		army.player = 7
		army.id = GetFirstFreeArmySlot(7)
		army.position = GetPosition("NVCave2")
		army.strength = round(14/gvDiffLVL)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
		end
		ChangePlayer("Kala", 7)
		ConnectLeaderWithArmy(GetID("Kala"), army)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{army.player, army.id})
		StartSimpleJob("Cave3")
		return true
	end
end
function Cave3()
	local posX, posY = Logic.GetEntityPosition(GetID("Cave2"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2000, 1) > 0 then
		local army = {}
		army.player = 7
		army.id = GetFirstFreeArmySlot(7)
		army.position = GetPosition("NVCave3")
		army.strength = round(10/gvDiffLVL)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{army.player, army.id})
		StartSimpleJob("Cave4")
		return true
	end
end
function Cave4()
	local posX, posY = Logic.GetEntityPosition(GetID("Cave4"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2000, 1) > 0 then
		local army = {}
		army.player = 7
		army.id = GetFirstFreeArmySlot(7)
		army.position = GetPosition("NVCave4")
		army.strength = round(10/gvDiffLVL)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{army.player, army.id})
		StartSimpleJob("Cave5")
		return true
	end
end
function Cave5()
	local posX, posY = Logic.GetEntityPosition(GetID("Cave3"))
	if Logic.GetPlayerEntitiesInArea(1, 0, posX, posY, 2000, 1) > 0 then
		local army = {}
		army.player = 7
		army.id = GetFirstFreeArmySlot(7)
		army.position = GetPosition("NVCave5")
		army.strength = round(10/gvDiffLVL)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{army.player, army.id})
		return true
	end
end
function ControlNVArmies(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end
function mystic_npc_Check()
	if GetDistance("Dario", {X = 66400, Y = 11600}) <= 800 then
		if CheckForTime() then
			Logic.SetEntityName(Logic.CreateEntity(Entities.CU_Hermit, 66400, 11600, 140, 6), "mystic_npc")
			EnableNpcMarker(GetEntityId("mystic_npc"))
			Mystic_NPC()
			StartSimpleJob("mystic_npc_Check_Disappear")
			return true
		end
	end
end
function mystic_npc_Check_Disappear()
	if TalkedToMNPC1 then
		return true
	end
	if IsExisting("mystic_npc") and not CheckForTime() and not briefingIsActive and not cutsceneIsActive and not cutscene_IsActive then
		DestroyEntity("mystic_npc")
		StartSimpleJob("mystic_npc_Check")
		return true
	end
end
function CheckForTime()
	local GameTime = Logic.GetTime() - (gvDayCycleStartTime or 0)
	local secondsperday = gvDayTimeSeconds or 1440
	local daytimefactor = secondsperday/86400
	local TimeMinutes = math.floor(GameTime/(3600*daytimefactor))
	local currenthour = 8+(TimeMinutes/60)
	while currenthour > 12 do
		currenthour = currenthour - 12
	end
	return (currenthour >= 3 and currenthour <= 3.5)
end
function Mystic_NPC()
	if not IsValid("mystic_npc") then
		return
	end
	local BeiMN = {
	EntityName = "Dario",
    TargetName = "mystic_npc",
    Distance = 500,
    Callback = function()
		TalkedToMNPC1 = true
		LookAt("mystic_npc","Dario");LookAt("Dario","mystic_npc")
		DisableNpcMarker(GetEntityId("mystic_npc"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("mystic_npc",myn,"Oh, ihr habt mich gefunden... @cr Ich denke, ihr wisst es bereits, aber ich bin Mhüs-Thikk, der große Rätselmeister. @cr Viele habe ich bereits in den Wahnsinn getrieben.", false)
		ASP("mystic_npc",myn,"Löst meine Rätsel und ich werde Euch wertvolle Belohnungen zukommen lassen.", true)
		AP{
			title = myn,
			text = "Zum ersten Rätsel ihr mich müsst ersuchen. @cr Ein einsames Boot am steinigen Ufer, @cr Glanz im Mondlicht @cr dort ich bin zu finden.",
			position = GetPosition("mystic_npc"),
			dialogCamera = false,
			action = function()
				local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
				Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
				Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
				DestroyEntity("mystic_npc")
			end
		}
		ASP("Dario",ment,"Herr, seht doch! @cr Dieser alte Kauz; er ist einfach verschwunden...", false)
		briefing.finished = function()
			QuestMystic2()
			Logic.RemoveQuest(1, MysQuest1)
			StartSimpleJob("mystic_npc_Check2")
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiMN)
end
function QuestMystic2()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Der verschwundene Rätselmeister",
		text	= "Ihr habt den großen Rätselmeister Mhüs-Thikk gefunden. @cr Kurz nach dem Gespräch ist er jedoch wieder verschwunden und gab Euch ein Rätsel auf. @cr Er versprach große Belohnungen, es sollte sich also lohnen. Dies waren seine Worte: @cr @cr Zum ersten Rätsel ihr mich müsst ersuchen. @cr Ein einsames Boot am steinigen Ufer, @cr Glanz im Mondlicht @cr dort ich bin zu finden.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	MysQuest2 = quest.id
end
function mystic_npc_Check2()
	if GetDistance("Dario", {X = 68900, Y = 42600}) <= 800 then
		if IsNighttime() then
			Logic.SetEntityName(Logic.CreateEntity(Entities.CU_Hermit, 68900, 42600, 140, 6), "mystic_npc")
			EnableNpcMarker(GetEntityId("mystic_npc"))
			Mystic_NPC2()
			StartSimpleJob("mystic_npc_Check_Disappear2")
			return true
		end
	end
end
function mystic_npc_Check_Disappear2()
	if TalkedToMNPC2 then
		return true
	end
	if IsExisting("mystic_npc") and not IsNighttime() and not briefingIsActive and not cutsceneIsActive and not cutscene_IsActive then
		DestroyEntity("mystic_npc")
		StartSimpleJob("mystic_npc_Check2")
		return true
	end
end
function Mystic_NPC2()
	if not IsValid("mystic_npc") then
		return
	end
	local BeiMN2 = {
	EntityName = "Dario",
    TargetName = "mystic_npc",
    Distance = 500,
    Callback = function()
		TalkedToMNPC2 = true
		LookAt("mystic_npc","Dario");LookAt("Dario","mystic_npc")
		DisableNpcMarker(GetEntityId("mystic_npc"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		local riddle, answer = randomRiddle(1)
		ASP("mystic_npc",myn,"Oh, ihr habt mich erneut gefunden... @cr Sehr gut. @cr Vielleicht habe ich Euch unterschätzt...", false)
		ASP("mystic_npc",myn,"Nun dann, kommen wir direkt zum ersten Rätsel. @cr Löst es und ich werde Euch entlohnen.", true)
		ASP("mystic_npc",myn,"Ich gebe Euch hierfür ".. round(30 * gvDiffLVL) .." Sekunden Zeit. @cr @cr Hinweis: Gebt Zahlen NICHT ausgeschrieben an!", true)
		ASP("mystic_npc",myn, riddle, false)
		briefing.finished = function()
			Logic.RemoveQuest(1, MysQuest2)
			Riddle1_Fail_CD = StartCountdown(30 * gvDiffLVL, Riddle1_Failed_Brief, true)
			XGUIEng.ShowWidget("ChatInput", 1)
			function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
				StopCountdown(Riddle1_Fail_CD)
				if _Message == answer or string.find(string.lower(_Message), string.lower(answer)) ~= nil then
					--success
					Riddle1_Solved_Brief()
				else
					Riddle1_Failed_Brief()
				end
				XGUIEng.ShowWidget("ChatInput", 0)
			end
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiMN2)
end
function Riddle1_Failed_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("mystic_npc",myn,"", false)
	AP{
		title = myn,
		text = "Die richtige Antwort ward gesucht, die falsch ward gegeben. @cr Eine Wiederkehr? Wird sie kommen?",
		position = GetPosition("mystic_npc"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("mystic_npc")
		end}
	ASP("Dario",dario, "Och nö, dieser schräge Kauz ist schon wieder verschwunden...", false)
	briefing.finished = function()
	end
	StartBriefing(briefing)
end
function Riddle1_Solved_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("mystic_npc",myn,"", false)
	AP{
		title = myn,
		text = "Ich habe Euch schon wieder unterschätzt. @cr Nun, ein Fehler ward getan, aber nimmermehr erneut.",
		position = GetPosition("mystic_npc"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("mystic_npc")
		end}
	ASP("Dario", dario, "Och nö, dieser schräge Kauz ist schon wieder verschwunden...", false)
	ASP("Dario", ment, "Herr, seht nur! @cr Er hat Euch einen beschmierten Stofffetzen hinterlassen... @cr @cr Die Toten; hier zuhauf @cr lasst sie ruhen. @cr Mich auch... @cr Winde werden erzornen...", false)
	ASP("Dario", ment, "Herr, seht nur! @cr Ach und auf der Rückseite steht auch noch was: @cr Euren Orb... @cr ...dessen würdig. @cr Setzt ihn klug ein!", true)
	briefing.finished = function()
		QuestMystic3()
		AllowTechnology(Technologies.B_PowerPlant, 1)
		AllowTechnology(Technologies.B_Weathermachine, 1)
		StartSimpleJob("mystic_npc_Check3")
	end
	StartBriefing(briefing)
end
function QuestMystic3()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Der Rätselmeister ... ist schon wieder verschwunden",
		text	= "Mhüs-Thikk ist schon wieder verschwunden. @cr Er gab Euch erneut ein Rätsel auf, welches auf einem zurückgelassenen Stofffetzen stand: @cr @cr Die Toten; hier zuhauf @cr lasst sie ruhen. @cr Mich auch... @cr Winde werden erzornen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	MysQuest3 = quest.id
end
function mystic_npc_Check3()
	if GetDistance("Dario", {X = 43500, Y = 69700}) <= 800 then
		if GetCurrentWeatherGfxSet() == 11 or GetCurrentWeatherGfxSet() == 28 then
			Logic.SetEntityName(Logic.CreateEntity(Entities.CU_Hermit, 43500, 69700, 110, 6), "mystic_npc")
			EnableNpcMarker(GetEntityId("mystic_npc"))
			Mystic_NPC3()
			StartSimpleJob("mystic_npc_Check_Disappear3")
			return true
		end
	end
end
function mystic_npc_Check_Disappear3()
	if TalkedToMNPC3 then
		return true
	end
	if IsExisting("mystic_npc") and not (GetCurrentWeatherGfxSet() == 11 or GetCurrentWeatherGfxSet() == 28) and not briefingIsActive and not cutsceneIsActive and not cutscene_IsActive then
		DestroyEntity("mystic_npc")
		StartSimpleJob("mystic_npc_Check3")
		return true
	end
end
function Mystic_NPC3()
	if not IsValid("mystic_npc") then
		return
	end
	local BeiMN3 = {
	EntityName = "Dario",
    TargetName = "mystic_npc",
    Distance = 500,
    Callback = function()
		TalkedToMNPC3 = true
		LookAt("mystic_npc","Dario");LookAt("Dario","mystic_npc")
		DisableNpcMarker(GetEntityId("mystic_npc"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		local riddle, answer = randomRiddle(2)
		ASP("mystic_npc",myn,"Psst, nicht so laut. @cr Die Toten... @cr Sie sind voller Zorn.", false)
		ASP("mystic_npc",myn,">>flüstert leise in seinen ungepflegten und stinkenden Bart<< @cr @cr Ihr seid für das nächste Rätsel hier? @cr Nun gut.", true)
		ASP("mystic_npc",myn,"Ich gebe Euch hierfür ".. round(30 * gvDiffLVL) .." Sekunden Zeit. @cr @cr Hinweis: Gebt Zahlen NICHT ausgeschrieben an!", true)
		ASP("mystic_npc",myn, riddle, false)
		briefing.finished = function()
			Logic.RemoveQuest(1, MysQuest3)
			Riddle2_Fail_CD = StartCountdown(30 * gvDiffLVL, Riddle2_Failed_Brief, true)
			XGUIEng.ShowWidget("ChatInput", 1)
			function GameCallback_GUI_ChatStringInputDone(_Message, _WidgetID)
				StopCountdown(Riddle2_Fail_CD)
				if _Message == answer or string.find(string.lower(_Message), string.lower(answer)) ~= nil then
					--success
					Riddle2_Solved_Brief()
				else
					Riddle2_Failed_Brief()
				end
				XGUIEng.ShowWidget("ChatInput", 0)
			end
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(BeiMN3)
end
function Riddle2_Failed_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("mystic_npc",myn,"", false)
	AP{
		title = myn,
		text = "Die richtige Antwort ward gesucht, die falsch ward gegeben. @cr Wiederkehr? Wohl kaum.",
		position = GetPosition("mystic_npc"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("mystic_npc")
		end}
	ASP("Dario",dario, "Och nö, dieser schräge Kauz ist schon wieder verschwunden...", false)
	briefing.finished = function()
	end
	StartBriefing(briefing)
end
function Riddle2_Solved_Brief()
	XGUIEng.ShowWidget("ChatInput", 0)
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("mystic_npc",myn,"", false)
	AP{
		title = myn,
		text = "Ihr habt erneut die richtige Antwort gegeben. @cr Respekt @cr Weitere Rätsel habe ich diesmal nicht für Euch.",
		position = GetPosition("mystic_npc"),
		dialogCamera = false,
		action = function()
			local posX, posY = Logic.GetEntityPosition(Logic.GetEntityIDByName("mystic_npc"))
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeMedium, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXMaryPoison, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, posX, posY)
			DestroyEntity("mystic_npc")
		end}
	AP{
		title = dario,
		text = "Och nö, dieser schräge Kauz ist schon wieder verschwunden...",
		position = GetPosition("Dario"),
		dialogCamera = false,
		action = function()
			local posX, posY = 44550, 69400
			for id in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(posX, posY, 1500), CEntityIterator.OfPlayerFilter(0)) do
				DestroyEntity(id)
			end
			IncludeLocals("silvermine")
		end}
	ASP("Dario", ment, "Herr, seht nur! @cr Unter all dem Schutt lag ein Silbervorkommen verborgen", false)
	briefing.finished = function()
	end
	StartBriefing(briefing)
end
function randomRiddle(_num)
	local count
	if _num == 1 then
		count = 12
	else
		count = 16
	end
	local rand = math.random(1, count)
	local quest = XGUIEng.GetStringTableText("cm08_01_nuamyr/Riddle".. _num .."_Quest".. rand)
	local answer = XGUIEng.GetStringTableText("cm08_01_nuamyr/Riddle".. _num .."_Answer".. rand)
	return quest, answer
end
function InitAchievementChecks()
	StartSimpleJob("CheckForAllChestsOpened")
	StartSimpleJob("CheckForFastArrival")
	StartSimpleJob("CheckForAllBridges")
	StartSimpleJob("CheckForSuddenWeatherChange")
end
function CheckForAllChestsOpened()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_ChestGold) == 0 then
		Message("Ihr habt alle Schatztruhen gefunden. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\nuamonchests", 1)
		return true
	end
end
function CheckForFastArrival()
	if Chapter1Done then
		if Logic.GetTime() <= 60 * 60 then
			Message("Ihr habt Erec in unter 60 Minuten erreicht. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\nuamonfastarrival", 1)
		end
		return true
	end
end
function CheckForAllBridges()
	if Logic.GetNumberOfEntitiesOfType(Entities.PB_Bridge1) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Bridge2)
	+ Logic.GetNumberOfEntitiesOfType(Entities.PB_Bridge3) + Logic.GetNumberOfEntitiesOfType(Entities.PB_Bridge4) == 17 then
		Message("Ihr habt alle Brücken errichtet. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\nuamonbridges", 1)
		return true
	end
end
function CheckForSuddenWeatherChange()
	if Logic.GetWeatherState() == 3 then
		Message("Ihr habt den Winter kommen lassen. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\nuamonmystery", 1)
		return true
	end
end
--**********Abschnitt  Comfortfunctionen:**********--
function GetQuestId()
    gvMission.QuestId = (gvMission.QuestId or 0) + 1
    return gvMission.QuestId
end
--**
function ActivateBriefingsExpansion()
    if not unpack{true} then
        local unpack2;
        unpack2 = function( _table, i )
                            i = i or 1;
                            assert(type(_table) == "table");
                            if i <= table.getn(_table) then
                                return _table[i], unpack2(_table, i);
                            end
                        end
        unpack = unpack2;
    end

    Briefing_ExtraOrig = Briefing_Extra;

    Briefing_Extra = function( _v1, _v2 )
                         for i = 1, 2 do
                             local theButton = "CinematicMC_Button" .. i;
                             XGUIEng.DisableButton(theButton, 1);
                             XGUIEng.DisableButton(theButton, 0);
                         end

                         if _v1.action then
                             assert( type(_v1.action) == "function" );
                             if type(_v1.parameters) == "table" then
                                 _v1.action(unpack(_v1.parameters));
                             else
                                 _v1.action(_v1.parameters);
                             end
                         end

                         Briefing_ExtraOrig( _v1, _v2 );
                     end;

    GameCallback_EscapeOrig = GameCallback_Escape;
    StartBriefingOrig = StartBriefing;
    EndBriefingOrig = EndBriefing;
    MessageOrig = Message;
    CreateNPCOrig = CreateNPC;

    StartBriefing = function(_briefing)
                        assert(type(_briefing) == "table");
                        if _briefing.noEscape then
                            GameCallback_Escape = function() end;
                            briefingState.noEscape = true;
                        end

                        StartBriefingOrig(Umlaute(_briefing));
                    end

    EndBriefing = function()
                      if briefingState.noEscape then
                          GameCallback_Escape = GameCallback_EscapeOrig;
                          briefingState.noEscape = nil;
                      end

                      EndBriefingOrig();
                  end;

    Message = function(_text)
                  MessageOrig(Umlaute(tostring(_text)));
              end;

	BugUmlaut = function(_text)
                  local texttype = type(_text);
                  if texttype == "string" then
                      _text = string.gsub( _text, "ä", "ae" );
                      _text = string.gsub( _text, "ö", "oe" );
                      _text = string.gsub( _text, "ü", "ue" );
                      _text = string.gsub( _text, "ß", "ss" );
                      _text = string.gsub( _text, "Ä", "Ae" );
                      _text = string.gsub( _text, "Ö", "Oe" );
                      _text = string.gsub( _text, "Ü", "Ue" );
                      return _text;
                  elseif texttype == "table" then
                      for k, v in _text do
                          _text[k] = Umlaute( v );
                      end
                      return _text;
                  else return _text;
                  end
              end;

    CreateNPC = function(_npc)
                    CreateNPCOrig(Umlaute(_npc));
                end;

	Umlaute = function(_text)
                  local texttype = type(_text);
                  if texttype == "string" then
                      _text = string.gsub( _text, "ä", "\195\164" );
                      _text = string.gsub( _text, "ö", "\195\182" );
                      _text = string.gsub( _text, "ü", "\195\188" );
                      _text = string.gsub( _text, "ß", "\195\159" );
                      _text = string.gsub( _text, "Ä", "\195\132" );
                      _text = string.gsub( _text, "Ö", "\195\150" );
                      _text = string.gsub( _text, "Ü", "\195\156" );
                      return _text;
                  elseif texttype == "table" then
                      for k, v in _text do
                          _text[k] = Umlaute( v );
                      end
                      return _text;
                  else return _text;
                  end
              end;
end
--**
function AddPages( _briefing )
    local AP = function(_page) table.insert(_briefing, _page); return _page; end
    local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end
    return AP, ASP;
end
--**
function CreateShortPage( _entity, _title, _text, _dialog, _explore)
    local page = {
        title = _title,
        text = _text,
        position = GetPosition( _entity ),
		action = function ()Display.SetRenderFogOfWar(0) end
    };
    if _dialog then
            if type(_dialog) == "boolean" then
                  page.dialogCamera = true;
            elseif type(_dialog) == "number" then
                  page.explore = _dialog;
            end
      end
    if _explore then
            if type(_explore) == "boolean" then
                  page.dialogCamera = true;
            elseif type(_explore) == "number" then
                  page.explore = _explore;
            end
      end
    return page;
end
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

