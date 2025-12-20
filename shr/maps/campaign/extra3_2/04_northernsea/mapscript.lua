--------------------------------------------------------------------------------
-- MapName: Das Nordmeer
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Das Nordmeer @cr "
gvMapVersion = " v1.00"
--
sub_armies_aggressive = 0
main_armies_aggressive = 0
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to initialize the diplomacy states
function InitDiplomacy()
	SetPlayerName(1,"Dario")
	SetPlayerName(4,"Landvolk")
	SetPlayerName(5,"Nordfeste")
	SetPlayerName(2,"Kerberos Vorposten")
	SetPlayerName(3,"Räuber")
	SetPlayerName(6,"Varg")
	SetPlayerName(7,"Kerberos")
	SetPlayerName(8,"Vargs Vorposten")
	SetNeutral(1,5)
	SetHostile(1,2)
	SetHostile(1,3)
	SetHostile(1,6)
	SetHostile(1,7)
	SetHostile(1,8)
	SetHostile(2,5)
	SetHostile(3,5)
	SetHostile(7,5)
	SetHostile(6,5)
	SetHostile(5,8)
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
	ResearchTechnology (Technologies.GT_Construction)
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

	Display.SetPlayerColorMapping(2,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(3,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(4,NPC_COLOR)
	Display.SetPlayerColorMapping(6,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(7,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(8,ROBBERS_COLOR)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called on game start after all initialization is done
function FirstMapAction()

	IncludeGlobals("Cutscene")
	-- Include Cutscene control
	IncludeLocals("Cutscene_Control")
	IncludeLocals("armies")
	--
	ActivateBriefingsExpansion()
	StartSimpleJob("Verloren")
	StartSimpleJob("ExtraTr")
	StartSimpleJob("Nachschub")
	HeroSuicidalDrownJobID = StartSimpleJob("HeroSuicidalDrownJob")
	Start()
	Truhen()
	LocalMusic.UseSet = DARKMOORMUSIC
	gvDayCycleStartTime = Logic.GetTime()
	TagNachtZyklus(24,0,1,(2-gvDiffLVL),1)
end
function FarbigeNamen()
	orange 	= " @color:255,127,0 "
	lila 	= " @color:250,0,240 "
	weiss   = " @color:255,255,255 "

	ker  	= ""..orange.." Kerberos "..lila..""
	kerlhg  = ""..orange.." Wolf, Wache des Feuers "..lila..""
	var	 	= ""..orange.." Varg "..lila..""
	rei  	= ""..orange.." Kommandant der Kavallerie "..lila..""
	er   	= ""..orange.." Erec "..lila..""
 	ment	= ""..orange.." Mentor "..lila..""
	dario	= ""..orange.." Dario "..lila..""
	drake	= ""..orange.." Drake "..lila..""
	ari		= ""..orange.." Ari "..lila..""
	pil    	= ""..orange.." Pilgrim "..lila..""
	far    	= ""..orange.." Verängstigter Bauer "..lila..""
	mon     = ""..orange.." Mönch "..lila..""
	sc      = ""..orange.." Eifriger Kundschafter "..lila..""
	thi   	= ""..orange.." Sappeur "..lila..""
	mi     	= ""..orange.." Vorarbeiter des Lehmbergwerks "..lila..""
	tra 	= ""..orange.." Arbeitsloser Händler "..lila..""
	fish  	= ""..orange.." Betrübter Fischer "..lila..""
	alch  	= ""..orange.." Euphorischer Alchemist "..lila..""

	vk_set1 = ""..orange.." Rolf, Siedler Velborgs "..lila..""
	vk_set2 = ""..orange.." Leif, Siedler Velborgs "..lila..""
	vk_set3 = ""..orange.." Floki, Jarl Velborgs "..lila..""
	vk_far1 = ""..orange.." Alvar, Schafhirte Velborgs "..lila..""
	vk_far2 = ""..orange.." Sigrid, Schafhirte Velborgs "..lila..""
	vk_far3 = ""..orange.." Ulf, Schafhirte Velborgs "..lila..""
	vk_far4 = ""..orange.." Borg, Farmer der rauen Küste "..lila..""
end
function Start()
	SetHealth("Turm",55)
	SetHealth("Turm_2",50)
	SetHealth("Ruin_1",30)
	SetHealth("Ruin_2",70)
	SetHealth("Ruin_3",50)
	SetHealth("Ruin_4",20)
	SetHealth("Ruin_5",60)
	SetHealth("Ruin_6",40)
	SetHealth("Ruin_7",30)
	SetHealth("Ruin_8",80)
	SetHealth("Ruin_9",10)
	SetHealth("Ruin_0",35)
	--**
	MakeInvulnerable("Erec")
	--
	MakeInvulnerable("VargHaupt")
	--
	CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderSword3,6,GetPosition("Barbaren"),"EliteSword")
	local posX, posY = Logic.GetEntityPosition(GetID("Varg_Haupt"))
	Logic.GroupPatrol(GetID("EliteSword"), posX, posY)
	MakeInvulnerable("EliteSword")
	--
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(2,5,6,7,8), CEntityIterator.OfCategoryFilter(EntityCategories.Cannon)) do
		if Logic.IsLeader(eID) == 1 then
			table.insert(gvLightning.IgnoreIDs, eID)
			Logic.GroupStand(eID)
		end
	end
	StartCutscene("Intro", Prolog)
end
--**
function Prolog()
	local briefing = {}
	local AP, ASP = AddPages(briefing);
	ASP("Drake",drake,"Endlich ist es soweit, wir ziehen in die finale Schlacht.", true)
	ASP("Dario",dario,"Was haben wir nicht alles gemeinsam durchgestanden. @cr Dies gelingt uns auch noch, werte Freunde.", true)
	ASP("Pilgrim",pil,"Denen werden wir es so richtig einheizen. @cr Keine Gnade.", true)
	ASP("Ari",ari,"Wir sind wieder einmal in der Schlacht vereint, Kerberos und Varg haben keinerlei Chance.", true)
	ASP("Dario",dario,"Genug des Lobens meine Freunde, zuerst sollten wir einen Platz für unsere Siedlung finden.", true)
	ASP("Erec",dario,"Die Nordfeste muss hier ganz in der Nähe sein. @cr Erec kann uns bei der Siedlungssuche bestimmt weiterhelfen.", false)
	ASP("Dario",dario,"Lasst uns Kerberos und Varg schnappen. @cr Sie verkriechen sich bestimmt schon in ihren Burgen.", true)
	AP{
		title = dario,
		text = "Der Eingang zur Nordfeste müsste sich hier irgendwo in der Nähe befinden.",
		position = GetPosition("Eingang"),
		marker = ANIMATED_MARKER,
		dialogCamera = false,
	}

    briefing.finished = function()
		EnableNpcMarker(GetEntityId("Erec"))
		IntroQuest()

		Erec()
		-- Level 0 is deactivated...ignore
		MapEditor_SetupAI(2, round(4-gvDiffLVL), 10000, math.max(round(4-gvDiffLVL),2), "Rache2", 3, 0)
		SetupPlayerAi( 2, {constructing = true, extracting = false, repairing = true, serfLimit = round(8/gvDiffLVL)})
		MapEditor_SetupAI(5, 3, 8500, math.min(round(1+gvDiffLVL),3), "Nordfeste", 3, 0)
		SetupPlayerAi( 5, {constructing = true, extracting = 1, repairing = true, serfLimit = round(3*gvDiffLVL)})
		MapEditor_SetupAI(6, math.max(round(3-gvDiffLVL),1), 12000, math.max(round(3-gvDiffLVL),1), "BanditSpawn2", 3, 0)
		MapEditor_SetupAI(7, math.max(round(4-gvDiffLVL),1), 15000, 3, "KerberosBaseSpawn", 3, 0)
		MapEditor_SetupAI(8, math.max(round(3-gvDiffLVL),1), 6000, math.max(round(3-gvDiffLVL),1), "Varg2", 1, 0)
		--
		CreateArmies()
		--
		InitAchievementChecks()
	end
    StartBriefing(briefing)

end
function RemoveVision()
	for j = 1,2 do
		DestroyEntity("p1_enemy_view_"..j)
	end
end

function IntroQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= MAINQUEST_OPEN,
		title	= "Die Nordfeste",
		text	= "Findet den Eingang zur Nordfeste. @cr Sprecht mit Erec.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	IntQuest = quest.id
end
function DarioQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Errichtet euer Lager",
		text	= "Sucht euch einen geeigneten Platz zum Siedeln. @cr In den Bergen oberhalb der Nordfeste befindet sich eine heruntergekommene Burgruine. " ..
		"Mithilfe einiger fleißiger Arbeiter könnt ihr sie wieder herrichten. @cr Errichtet anschließend @cr zwei Steinstollen, @cr zwei Eisenerzstollen, @cr zwei Schwefelstollen, " ..
		"@cr eine Sägemühle, @cr eine Kohlemine, @cr eine Grobschmiede, @cr eine Kirche @cr sowie zehn mittlere Wohnhäuser @cr und zehn Mühlen. @cr Sprecht anschließend wieder mit Erec. Und eilt Euch...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarQuest = quest.id
end
function KerQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= MAINQUEST_OPEN,
		title	= "Kerberos",
		text	= "Vernichtet Kerberos Truppen und nehmt dann Kerberos in Gefangenschaft.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	KeQuest = quest.id
end
function VarQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= MAINQUEST_OPEN,
		title	= "Varg",
		text	= "Vernichtet Vargs Truppen und nehmt dann Varg in Gefangenschaft.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	VaQuest = quest.id
end

function Erec()
	local BeiEr = {
	EntityName = "Dario",
    TargetName = "Erec",
    Distance = 300,
    Callback = function()
		do
			local pos = GetPosition("Ruinspawn")
			CreateMilitaryGroup(5,Entities.PU_LeaderSword4,12,{X = pos.X, Y = pos.Y},"P1_StartBrief_Sword")
			CreateMilitaryGroup(5,Entities.PU_LeaderPoleArm4,12,{X = pos.X-30, Y = pos.Y},"P1_StartBrief_PoleArm")
			CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X-50, Y = pos.Y-50},"P6_StartBrief_Veteran")
			CreateMilitaryGroup(7,Entities.CU_VeteranMajor,4,{X = pos.X+50, Y = pos.Y+50},"P7_StartBrief_Veteran")
			CreateMilitaryGroup(7,Entities.PU_LeaderBow4,12,{X = pos.X +1300, Y = pos.Y+300},"P7_StartBrief_Bow")
			Attack("P6_StartBrief_Veteran","P1_StartBrief_Sword")
			Attack("P7_StartBrief_Veteran","P1_StartBrief_PoleArm")
			Attack("P7_StartBrief_Bow","P1_StartBrief_PoleArm")
		end
		LookAt("Erec","Dario");LookAt("Dario","Erec")
		DisableNpcMarker(GetEntityId("Erec"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Erec",er,"Hallo Dario. @cr Gut euch zu sehen. @cr Der Krieg zwischen der Nordfeste und Kerberos und Vargs Truppen läuft bereits.", true)
		ASP("Ruinspawn",er,"Alleine gegen zwei Gegnern sind wir ihnen dennoch leider unterlegen.", false)
		ASP("Outpost_Ruin",er,"Dario, bitte steh uns bei und bezieh unsere alte Burg weit oben in den Bergen.", false)
		ASP("Erec",er,"Aber bitte beeil dich, ich weiß nicht wie lange wir sie noch von unserer Burg fernhalten können.", true)
		briefing.finished = function()
			do
				local pos = GetPosition("Eingang")
				GUI.DestroyMinimapPulse(pos.X, pos.Y)
			end
			local sizeX = Logic.WorldGetSize()
			MapEditor_Armies[5].offensiveArmies.rodeLength = 12000
			MapEditor_Armies[6].offensiveArmies.rodeLength = sizeX
			MapEditor_Armies[8].offensiveArmies.rodeLength = sizeX
			--
			Logic.RemoveQuest(1,DarQuest)
			ChangePlayer("Turm",1)
			ChangePlayer("Turm_2",1)
			ChangePlayer("serf1",1)
			ChangePlayer("serf2",1)
			ChangePlayer("serf3",1)
			ChangePlayer("serf4",1)
			--
			Logic.RemoveQuest(1, IntQuest)
			DarioQuest()
			DefCounter = StartCountdown((25 + 5 * gvDiffLVL) * 60, Defeat, true)
			StartSimpleJob("VillageDone")
			--
			Vorbereitung()

			StartCountdown(25*60*gvDiffLVL,IncreaseP2Range,false)
			StartCountdown(40*60,UpgradeKIa,false)
			StartCountdown((30+(20*gvDiffLVL))*60,Attack_1,false)

			AddGold  (round(500*gvDiffLVL))
			AddSulfur(0)
			AddIron  (0)
			AddWood  (1000)
			AddStone (1000)
			AddClay  (1000)
			--
			SetFriendly(1,5)
			--
			TalkedToErec = true
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiEr)
end
function VillageDone()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_StoneMine2) >= 2
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_IronMine2) >= 2
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_SulfurMine2) >= 2
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_CoalMine1) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Sawmill1) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Blacksmith2) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Monastery2) >= 1
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Residence2) >= 10
	and Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PB_Farm2) >= 10 then
		Message("Ihr habt alle geforderten Gebäude errichtet! @cr Sprecht nun erneut mit Erec!")
		EnableNpcMarker(GetID("Erec"))
		Erec2()
		return true
	end
end
gvHeroIDs = {}
gvHeroDrownCounter = 0
function HeroSuicidalDrownJob()
	if not next(gvHeroIDs) then
		Logic.GetHeroes(1, gvHeroIDs)
	end
	if Logic.GetWeatherState() == 3 then
		for i = 1, table.getn(gvHeroIDs) do
			local posX, posY, posZ = Logic.EntityGetPos(gvHeroIDs[i])
			local wheight = CUtil.GetWaterHeight(round(posX/100), round(posY/100))
			if wheight > posZ then
				gvHeroDrownCounter = gvHeroDrownCounter + 1
			end
			if gvHeroDrownCounter >= 6+(2*gvDiffLVL) then
				TeleportSettler(gvHeroIDs[i], 29000, 33000)
				Move(gvHeroIDs[i], "Versteck4")
				StartCountdown(10, function() StartSummer(99) end, false)
				StartCutscene("Drown")
				return true
			end
		end
	end
end
function Erec2()
	local BeiEr = {
    TargetName = "Erec",
    Distance = 300,
	Heroes = true,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Erec"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Erec", id);LookAt(id ,"Erec")
		DisableNpcMarker(GetEntityId("Erec"))
		StopCountdown(DefCounter)
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Erec",er,"Sehr gut. @cr Unsere Wirtschaft ist nun stark genug, um eine Armee ausheben zu können, die den Vormarsch der dunklen Horden aufhalten kann.", true)
		ASP("Erec",er,"Wir sollten zunächst die Verteidigung der Nordfeste unterstützen. @cr Aber früher oder später werden wir auch in den Angriff übergehen müssen. " ..
			"@cr Varg und Kerberos verfügen über vorgeschobene Militärbasen, die sie als Ausgangspunkt für die Angriffe auf die Nordfeste nutzen. @cr Diese Außenposten gilt es auszuschalten.", true)
		AP{
			title = er,
			text = "Kerberos Außenposten befindet sich gut geschützt an dieser Stelle. @cr Unsere Späher haben saubere Arbeit geleistet.",
			position = GetPosition("KerberosBurg"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		AP{
			title = er,
			text = "Der von Varg war da schon ein wenig umständlicher zu finden. @cr Der Außenposten liegt weit oben in den Kralbergen und ist nur über einen schmalen Pfad zu erreichen.",
			position = GetPosition("VargHaupt"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}

		ASP("Erec",er,"Ich werde euch im Kampf eigenhändig zur Seite stehen. @cr Meine Fähigkeiten werden sich bestimmt als nützlich erweisen!", true)
		briefing.finished = function()
			do
				local pos = GetPosition("Kerb")
				local pos2 = GetPosition("VargHaupt")
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X,pos.Y,0,1),"p1_enemy_view_1")
				Logic.SetEntityExplorationRange(GetID("p1_enemy_view_1"), 28)
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_ScriptEntity,pos2.X,pos2.Y,0,1),"p1_enemy_view_2")
				Logic.SetEntityExplorationRange(GetID("p1_enemy_view_2"), 28)
				StartCountdown(120,RemoveVision,false)
			end
			ChangePlayer("Erec",1)
			Logic.RemoveQuest(1, DarQuest)
			KerQuest()
			VarQuest()
			--
			ActivateShareExploration( 1,5, true )
			EnableNpcMarker(GetEntityId("Reiter"))
			EnableNpcMarker(GetEntityId("Farmer"))
			EnableNpcMarker(GetEntityId("monk"))
			EnableNpcMarker(GetEntityId("thief"))
			EnableNpcMarker(GetEntityId("miner"))
			EnableNpcMarker(GetEntityId("trader"))
			EnableNpcMarker(GetEntityId("fisherman"))
			Reiter()
			Farmer()
			Monk()
			Thief()
			Miner()
			Trader()
			Fisherman()
			--
			StartSimpleJob("CheckForDarioNearOutpostRuinVarg")
			StartSimpleJob("CheckForDarioNearOutpostRuinKerberos")
			--
			EndJob(HeroSuicidalDrownJobID)
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiEr)
end
function CheckForDarioNearOutpostRuinVarg()
	local pos = GetPosition("OutpostRuinVarg")
	if IsNear("Dario", "OutpostRuinVarg", 700)
	and not AreEntitiesOfCategoriesAndDiplomacyStateInArea(1, {EntityCategories.Leader, EntityCategories.Soldier, EntityCategories.Cannon}, pos, 3000, Diplomacy.Hostile) then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		AP{
			title = dario,
			text = "Wir sollten diesen Außenposten für uns beanspruchen. @cr Wir sollten einige Arbeiter zur Restauration der Ruine abbestellen.",
			position = GetPosition("Dario"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(-45)
				Camera.RotSetFlipBack(0)
			end
		}
		briefing.finished = function()
			Camera.RotSetAngle(-45)
			Camera.RotSetFlipBack(1)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"outpost_repair_varg","OutpostRuinVarg","OutpostRuinVarg_rep1","OutpostRuinVarg_rep2","OutpostRuinVarg_rep3","OutpostRuinVarg_rep4", Entities.PB_Outpost1, round(240*2/gvDiffLVL), 1200, 4})
			StartSimpleJob("OutpostVarg_Done")
		end
		StartBriefing(briefing)
		return true
	end
end
function OutpostVarg_Done()
	local pos = GetPosition("OutpostRuinVarg")
	local op = {Logic.GetPlayerEntitiesInArea(4,Entities.PB_Outpost1,pos.X,pos.Y,1000,1)}

	if op[1] > 0 and Logic.IsConstructionComplete(op[2]) == 1 then
		ChangePlayer(op[2], 1)
		return true
	end
end
function CheckForDarioNearOutpostRuinKerberos()
	local pos = GetPosition("OutpostRuinKerberos")
	if IsNear("Dario", "OutpostRuinKerberos", 700)
	and not AreEntitiesOfCategoriesAndDiplomacyStateInArea(1, {EntityCategories.Leader, EntityCategories.Soldier, EntityCategories.Cannon}, pos, 3000, Diplomacy.Hostile) then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		AP{
			title = dario,
			text = "Wir sollten diesen Außenposten für uns beanspruchen. @cr Wir sollten einige Arbeiter zur Restauration der Ruine abbestellen.",
			position = GetPosition("Dario"),
			dialogCamera = false,
			action = function()
				Camera.RotSetAngle(0)
				Camera.RotSetFlipBack(0)
			end
		}
		briefing.finished = function()
			Camera.RotSetAngle(-45)
			Camera.RotSetFlipBack(1)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "InitRuinRepairing",1,{},{"outpost_repair_kerberos","OutpostRuinKerberos","OutpostRuinKerberos_rep1","OutpostRuinKerberos_rep2","OutpostRuinKerberos_rep3","OutpostRuinKerberos_rep4", Entities.PB_Outpost1, round(240*2/gvDiffLVL), 1200, 4})
			StartSimpleJob("OutpostKerberos_Done")
			Logic.CreateEffect(GGL_Effects.FXCrushBuildingLarge, posX, posY)
			Logic.CreateEffect(GGL_Effects.FXExplosion, posX, posY)
			SetHealth(GetID("KerberosBurg"), 0)
		end
		StartBriefing(briefing)
		return true
	end
end
function OutpostKerberos_Done()
	local pos = GetPosition("OutpostRuinKerberos")
	local op = {Logic.GetPlayerEntitiesInArea(4,Entities.PB_Outpost1,pos.X,pos.Y,1000,1)}

	if op[1] > 0 and Logic.IsConstructionComplete(op[2]) == 1 then
		ChangePlayer(op[2], 1)
		return true
	end
end
function Vorbereitung()
    StartSimpleJob("VictoryJob_Step1")
	--
	StartSimpleJob("Outpost_Ruin_Control")
end
function Outpost_Ruin_Control()
	local posX, posY = Logic.GetEntityPosition(GetID("Outpost_Ruin"))
	if Logic.GetPlayerEntitiesInArea(1, Entities.PU_Serf, posX, posY, 700, 1) > 0 then
		local posX, posY = Logic.GetEntityPosition(GetID("hq_ruin"))
		Logic.CreateConstructionSite(posX, posY, 0, Entities.PB_Outpost1, 1)
		return true
	end
end
function VictoryJob_Step1()
	if GetEntityHealth("KerberosBurg") <= 20 then
		ChangePlayer("KerberosBurg",4)
		SetHealth("KerberosBurg",15)
		Start_Step2()
		MakeVulnerable("VargHaupt")
		return true
	end
end
function VictoryJob_Step2()
	if GetEntityHealth("VargHaupt") <= 20 then
		ChangePlayer("VargHaupt",4)
		SetHealth("VargHaupt",15)
		Start_Step3()
		return true
	end
end
function VictoryJob_Step3()
	if Counter.Tick2("VictoryJob_Step3_Ticker",40) then
		if GetEntityHealth("VargHaupt") <= 20 and GetEntityHealth("KerberosBurg") <= 20 then
			Start_Step4()
			return true
		end
	end
end
function VictoryJob_Step4_1()
	if GetEntityHealth("KerberosHQ1") <= 5 or GetEntityHealth("KerberosHQ2") <= 5 then
		End_Step4_1()
		return true
	end
end
function VictoryJob_Step4_2()
	if GetEntityHealth("VargFortress") <= 5 and GetEntityHealth("VargHQ") <= 5 then
		End_Step4_2()
		return true
	end
end
function Start_Step2()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Kerberos",
        text	= "@color:230,0,0 Harharhar @cr Denkt ihr, dass ich mich so leicht geschlagen gebe? @cr @cr Niemals...",
		position = GetPosition("KerberosBurg"),
		action = function()
			local army = {}
			army.player = 7
			army.id = GetFirstFreeArmySlot(7)
			army.position = GetPosition("Kerb")
			army.strength = round(6/gvDiffLVL)
			army.rodeLength = Logic.WorldGetSize()
			SetupArmy(army)
			for i = 1, army.strength do
				EnlargeArmy(army, {leaderType = Entities.CU_VeteranMajor})
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Ein Haufen wütender Elitekrieger hat sich um Kerberos versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Kerb"),
		action = function()
			Logic.RemoveQuest(1, KeQuest)
			GUI.DestroyMinimapPulse(Logic.GetEntityPosition(GetID("KerberosBurg")))
			if IsExisting("KerbBarrier") then
				ReplaceEntity("KerbGate1", Entities.XD_WallStraightGate)
				ReplaceEntity("KerbGate2", Entities.XD_WallStraightGate)
				DestroyEntity("KerbBarrier")
			end
			StartSimpleJob("KerberosSiegeAmbush")
			do
				local id, tbi, e = nil, table.insert, {};
				id = Logic.CreateEntity(Entities.XD_CaveEntry, 50362.55, 61313.70, 238.51, 0);tbi(e,id);Logic.SetEntityScriptingValue(id, -58+25, 1060320050) --[[ Scale: 0.70 ]]
				id = Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity, 50414.54, 61739.31, 0.00, 7);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity, 50103.17, 61692.56, 0.00, 7);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity, 50573.32, 61982.97, 0.00, 7);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity, 50282.55, 61987.46, 0.00, 7);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity, 49998.05, 61997.50, 0.00, 7);tbi(e,id)
				id = Logic.CreateEntity(Entities.XD_ScriptEntity, 50313.06, 61594.48, 0.00, 7);tbi(e,id);Logic.SetEntityName(id, "KerbAmbush")
			end
			Logic.SetTerrainVertexColor(502, 612,  55,  55,  55);
			Logic.SetTerrainVertexColor(503, 612,   0,   0,   0);
			Logic.SetTerrainVertexColor(502, 613,   0,   0,   0);
			Logic.SetTerrainVertexColor(503, 613,   0,   0,   0);
			Logic.SetTerrainVertexColor(502, 614,  31,  31,  31);
			Logic.SetTerrainVertexColor(503, 614,   0,   0,   0);
			Logic.SetTerrainVertexColor(502, 615, 114, 114, 114);
			Logic.SetTerrainVertexColor(503, 615,  78,  78,  78);
			Logic.SetTerrainNodeHeight(502, 612,  2137);
			Logic.SetTerrainNodeHeight(503, 612,  1988);
			Logic.SetTerrainNodeHeight(502, 613,  2058);
			Logic.SetTerrainNodeHeight(503, 613,  1893);
			Logic.SetTerrainNodeHeight(502, 614,  2012);
			Logic.SetTerrainNodeHeight(503, 614,  1898);
			Logic.SetTerrainNodeHeight(502, 615,  1987);
			Logic.SetTerrainNodeHeight(503, 615,  1940);
			Logic.SetTerrainNodeHeight(502, 616,  1996);
			Logic.SetTerrainNodeHeight(503, 616,  1969);
			Logic.SetTerrainNodeHeight(503, 617,  1994);
			Logic.UpdateBlocking(496, 608, 504, 620);
			for i = 1,3 do
				Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, 50400, 61800)
				Logic.CreateEffect(GGL_Effects.FXExplosion, 50400, 61800)
			end
			--
			EnableNpcMarker(GetEntityId("alchemist"))
			Alchemist()
		end

    }

    StartBriefing(briefing)
	--
	ChangePlayer("Kerb", 7)
	local pos = GetPosition("Kerb")
	Logic.CreateEffect(GGL_Effects.FXKerberosFear, pos.X, pos.Y)
	CEntity.DealDamageInArea(GetID("Kerb"), 50400, 61800, 800, 800)
	CEntity.DealDamageInArea(GetID("Kerb"), pos.X, pos.Y, 800, 800)
	ChangePlayer("Kerb", 4)
	Move("Kerb","KerberosBaseSpawn")
	--
	StartSimpleJob("VictoryJob_Step2")
	StartCountdown(5*60,KerberosKI_Relocate,false)
end
function Start_Step3()
	MakeVulnerable("EliteSword")
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Varg",
        text	= "@color:230,0,0 Harharhar @cr Noch habt ihr mich nicht erwischt! @cr @cr ...Seid ihr hungrig?",
		position = GetPosition("Varg"),
		action = function()
			local army = {}
			army.player = 6
			army.id = GetFirstFreeArmySlot(6)
			army.position = GetPosition("Barbaren")
			army.strength = round(12/gvDiffLVL)
			army.rodeLength = Logic.WorldGetSize()
			SetupArmy(army)
			for i = 1, army.strength/2 do
				EnlargeArmy(army, {leaderType = Entities.CU_VeteranLieutenant})
				EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
			--
			ChangePlayer("Wolfa",6)
			ChangePlayer("Wolfb",6)
			ChangePlayer("Wolfc",6)
			ChangePlayer("Wolfd",6)
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Wölfe und Elitekrieger haben sich um Varg versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Varg"),
		action = function()
			Logic.RemoveQuest(1, VaQuest)
			Move("Varg","VargCave")
			GUI.DestroyMinimapPulse(Logic.GetEntityPosition(GetID("VargHaupt")))
		end

    }

    StartBriefing(briefing)
	StartSimpleJob("MoveVargToBase")
	StartSimpleJob("VictoryJob_Step3")
	StartCountdown(5*60,VargKI_Relocate,false)
end
function Start_Step4()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Sehr gut Sire. @cr @cr Ihr habt erfolreich beide Außenposten erobert.",
		position = GetPosition("VargHaupt"),
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Blöd nur, dass sowohl Kerberos als auch Varg sich in ihre Hauptquartiere zurückziehen konnten... @cr @cr Ihr werdet wohl beide verfolgen und ihre Hauptquartiere zerstören müssen.",
		position = GetPosition("VargHaupt"),
    }

    StartBriefing(briefing)

	StartSimpleJob("VictoryJob_Step4_1")
	StartSimpleJob("VictoryJob_Step4_2")
	StartSimpleJob("VictoryJob")

	QuestSieg()
end
function End_Step4_1()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Kerberos",
        text	= "@color:230,0,0 So leicht gebe ich mich nicht geschlagen. @cr @cr Los meine Getreuen. Auf sie mit Gebrüll!",
		position = GetPosition("Kerb"),
		action = function()
			local army = {}
			army.player = 7
			army.id = GetFirstFreeArmySlot(7)
			army.position = GetPosition("Kerb")
			army.strength = round(16 - 2 * gvDiffLVL)
			army.rodeLength = Logic.WorldGetSize()
			SetupArmy(army)
			for i = 1, army.strength/2 do
				EnlargeArmy(army, {leaderType = Entities.CU_VeteranMajor})
				EnlargeArmy(army, {leaderType = Entities.CU_BlackKnight_LeaderSword3})
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
			--
			ChangePlayer("Kerb",7)
			ConnectLeaderWithArmy(GetID("Kerb"), army)
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Nicht schon wieder. Massenhaft Schwarze Ritter und Schwertkämpfer haben sich um Kerberos versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Kerb"),

    }

    StartBriefing(briefing)

end
function End_Step4_2()
	local briefing = {}
    local AP, ASP = AddPages(briefing)
    AP{
        title	= "@color:230,120,0 Varg",
        text	= "@color:230,0,0 Ihr seid also tatsächlich so dämlich, mir bis in meine Basis zu folgen. @cr @cr Hier gelten nur meine Regeln! @cr ...Seid ihr hungrig?",
		position = GetPosition("Varg"),
		action = function()
			local army = {}
			army.player = 6
			army.id = GetFirstFreeArmySlot(6)
			army.position = GetPosition("VargFortressDefense")
			army.strength = round(12/gvDiffLVL)
			army.rodeLength = Logic.WorldGetSize()
			SetupArmy(army)
			for i = 1, army.strength/2 do
				EnlargeArmy(army, {leaderType = Entities.CU_VeteranLieutenant})
				EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
			end
			ChangePlayer("Varg",6)
			ConnectLeaderWithArmy(GetID("Varg"), army)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
			--
			local army = {}
			army.player = 6
			army.id = GetFirstFreeArmySlot(6)
			army.position = GetPosition("VargHQDefense")
			army.strength = round(12/gvDiffLVL)
			army.rodeLength = Logic.WorldGetSize()
			SetupArmy(army)
			for i = 1, army.strength/2 do
				EnlargeArmy(army, {leaderType = Entities.CU_VeteranLieutenant})
				EnlargeArmy(army, {leaderType = Entities.CU_AggressiveWolf})
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
			--
			-- setup varg base villagers npc's
			EnableNpcMarker(GetID("vik_settler1"))
			Vik_Settler1()
		end
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Oh nein. Nicht schoooon wieder... @cr @cr Wölfe und Elitekrieger haben sich um Varg für ein letztes Gefecht versammelt. @cr @cr Ich hoffe Ihr seid vorbereitet Sire.",
		position = GetPosition("Varg"),

    }

    StartBriefing(briefing)

end
function MoveVargToBase()
	if IsNear("Varg","VargCave",500) then
		SetPosition("Varg",GetPosition("VargFortressDefense"))
		return true
	end
end
function KerberosSiegeAmbush()
	if IsDestroyed("StableP7") then
		Stream.Start("Sounds\\VoicesHero7\\HERO7_madness_rnd_01.wav", 250)
		KerbFinalAmbushArmy()
		return true
	end
end
function Reiter()
	local BeiRei = {
	Heroes = true,
    TargetName = "Reiter",
    Distance = 300,
    Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("Reiter"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("Reiter",id);LookAt(id,"Reiter")
		DisableNpcMarker(GetEntityId("Reiter"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Reiter",rei,"Guten Tag der Herr. Ich bin der Kommandant der hiesigen Kavallerie. @cr Gut dass ich euch hier antreffe " .. GetNPCDefaultNameByID(id) .. ". @cr Ich habe wichtige Neuigkeiten.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Ich bin ganz Ohr, hoffentlich handelt es sich dabei um gute Nachrichten.", true)
		ASP("Reiter",rei,"Bei unserem letzten Ausritt nahe der Küste entdeckten wir eine Insel nahe der Festung von Kerberos.", false)
		ASP("Kuste",rei,"Darauf befindet sich ein Eisenerzbergwerk. @cr Zerstört es und die Eisenversorgung Kerberos und Vargs wird brach liegen.", false)
		AP{
			title = rei,
			text = "Deren Militärversorgung wird nicht mehr so wie vorher sein. @cr Die Truppenstärke wird ohne Eisen kräftig nachlassen.",
			position = GetPosition("Eisen"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Danke für den Hinweis. @cr Wir werden dies bei unserem taktischen Vorgehen berücksichtigen.", true)
		briefing.finished = function()
			StartSimpleJob("Eisenmine")
			P5_CavQuest()
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRei)
end
function P5_CavQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Operation: Gegenschlag!",
		text	= "Vernichtet das Eisenerzbergwerk auf einer Insel unweit der Küste südlich Kerberos Lager. @cr Vielleicht schwächt es ja Kerberos Nachschub...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_CavQ = quest.id
end
function Farmer()
	local BeiFar = {
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
		ASP("Farmer",far,"Brrrr... Geht bloß nicht in Richtung Vargs alter Burgruine...", true)
		ASP("Farmer",far,"Dort haust so eine Bestie, ein Trupp schwerst bewaffneter Soldaten, welches einfach nicht zu übertölpen ist.", true)
		ASP("Farmer",far,"Nehmt euch in Acht, das ist kein normaler Krieger. Meidet ihn, oder ihr werdet dabei euer Leben lassen!", true)
		briefing.finished = function()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiFar)
end
function Monk()
	local BeiMo = {
	Heroes = true,
	TargetName = "monk",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("monk"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("monk",id);LookAt(id,"monk")
		DisableNpcMarker(GetEntityId("monk"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("monk",mon,"Oh noch eine arme Seele. @cr Soll ich Euch die Beichte abnehmen?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nein, kein Interesse. @cr Meine Zeit ist begrenzt.", false)
		ASP("monk",mon,"Oh wie oft habe ich das in letzter Zeit gehört. @cr Seit der Krieg ausgebrochen ist, bin ich ein Schäfer ohne Schafe. @cr Und an jeder Ecke lauern Wölfe.", true)
		ASP("monk",mon,"Seid doch bitte so gut und entsendet uns genügend Baumaterialien zum Ausbau unserer Kirche. @cr Vielleicht kann ja ein wenig Prunk die ein oder andere arme Seele wieder in die Hände der Kirche treiben. @cr Schon zu viele Schafe sind zu Wölfen geworden...", false)
		briefing.finished = function()
			TributeMonk()
			P5_MonkQuest()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMo)
end
function P5_MonkQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Den Glauben wiederherstellen",
		text	= "Entsendet dem Mönch der Nordfeste einige Ressourcen, sodass die Kirche in eine prunkvolle Kathedrale ausgebaut werden kann. @cr Vielleicht lässt dies ja die ein oder andere verlorene Seele über ihre schändlichen Taten nachdenken...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_MonkQ = quest.id
end
function TributeMonk()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Zahlt 600 Steine, 200 Holz und 300 Taler, damit die Kirche zu einer prunkvolleren Kathedrale ausgebaut werden kann."
	tribute.cost = { Gold = 300, Stone = 600, Wood = 200 }
	tribute.Callback = TributePaidMonk
	TributeMoID = AddTribute(tribute)
end
function TributePaidMonk()
	StartCountdown(1, function()
		(SendEvent or CSendEvent).UpgradeBuilding(GetID("monastery_p5"));
		StartSimpleJob("P5MonasteryUpgradeDone")
	end, false)
end
function P5MonasteryUpgradeDone()
	if Logic.GetPlayerEntities(5, Entities.PB_Monastery3, 1) > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("monk",mon,"Habt Dank! @cr Bleibt doch bitte für die Predigt.", true)
		ASP("Dario",dario,"Tut mir leid, aber ich muss weiter. @cr So gerne ich hier verweilen würde, ich habe noch Aufgaben zu erledigen.", false)
		ASP("monk",mon,"Nun, das kann ich verstehen. @cr Gott sei mit Euch. @cr @cr Ich bin überzeugt, dass diese prunkvolle Kathedrale die Kampfkraft der Menschen hier stärken wird.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1, P5_MonkQ)
			MapEditor_Armies[5].offensiveArmies.strength = MapEditor_Armies[5].offensiveArmies.strength + round(gvDiffLVL)
		end;
		StartBriefing(briefing)
		return true
	end
end
function Scout()
	local BeiSc = {
	Heroes = true,
	TargetName = "scout",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("scout"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("scout",id);LookAt(id,"scout")
		DisableNpcMarker(GetEntityId("scout"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("scout",sc,"Guten Tag der Herr. @cr Ich konnte kürzlich bei einer Erkundungstour an der Küste eine interessante Entdeckung machen.", true)
		ASP("fire3",sc,"Kerberos hat seinen benachbarten Stellungen über ein Leuchtfeuer alarmiert und wird wohl regelmäßig von der Küste her Verstärkung erhalten.", false)
		ASP("fireguard",sc,"Nur eine einzelne Wache hält das Feuer am Brennen. @cr Vielleicht sollte man versuchen, sie zu eliminieren und das Feuer zu löschen.", true)
		briefing.finished = function()
			P5_ScoutQuest()
			StartSimpleJob("ControlSupplyFire")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSc)
end
function P5_ScoutQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Löscht die Flamme des bösen Omens!",
		text	= "Kerberos bezieht Verstärkungstruppen über den östlichen Küstenstreifen. @cr Ein Leuchtfeuer weist ihnen den Weg. " ..
			"@cr Dem Kundschafter nach hält eine einzelne Wache auf einer schroffen Insel unweit eines alten Leuchtturms das Feuer am Brennen. @cr Wir sollten sie eliminieren und das Feuer löschen!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_ScoutQ = quest.id
end
function ControlSupplyFire()
	if IsDead("fireguard") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("scout",sc,"Sehr gut. @cr Ihr habt den Wächter eliminiert. @cr Wir sollten nun das Leuchtfeuer löschen.", true)
		briefing.finished = function()
			StartCountdown(20, RemoveFire, false)
		end;
		StartBriefing(briefing)
		return true
	end
end
function RemoveFire()
	ReplaceEntity("fire1", Entities.XD_SingnalFireOff)
	ReplaceEntity("fire2", Entities.XD_SingnalFireOff)
	ReplaceEntity("fire3", Entities.XD_SingnalFireOff)
	--
	StopCountdown(LighthouseSupplyCounter)
	Logic.RemoveQuest(1, P5_ScoutQ)
end
function Thief()
	local BeiThi = {
	Heroes = true,
	TargetName = "thief",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("thief"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("thief",id);LookAt(id,"thief")
		DisableNpcMarker(GetEntityId("thief"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("thief",thi,"Ah, guten Tag der Herr.", true)
		ASP("thief",thi,"Bei kürzlichen Grabenarbeiten konnte ich feststellen, dass der Boden in der Gegend hier sehr weich ist. @cr Liegt wohl daran, dass wir so nah an der Küste sind und das Wetter so unbeständig ist...", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Und was bitte soll ich mit dieser Information anfangen? @cr Seht ihr nicht, dass ich beschäftigt bin?", true)
		ASP("thief",thi,"Nun, mein Herr... @cr Es sollte mir möglich sein, mich bis ins Kerberos Siedlung zu schaufeln und dort ein wenig Sabotage zu betreiben.", false)
		ASP("FoundryP7",thi,"Konkret schwebt mir vor, die Kanonengießerei des Feindes zu sabotieren. @cr Gebt mir ein wenig Schwefel und Kohle, und Kerberos wird eine böse Überraschung erleben.", false)
		ASP("thief",thi,"Ach, und sorgt Euch bitte um meine Familie. @cr Ich würde den Auftrag vermutlich nicht überleben...", false)
		briefing.finished = function()
			P5_ThiefQuest()
			TributeSappeur()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiThi)
end
function P5_ThiefQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Und ab ins Dunkel!",
		text	= "Ein Sappeur hat Euch vorgeschlagen, sich ins Lager von Kerberos zu schaufeln und dort die feindliche Kanonengießerei zu sabotieren. @cr Er benötigt dafür jedoch einige Ressourcen... " ..
			"@cr Doch wie stehen schon die Chancen, dass dieses tollkühne Unterfangen wirklich gelingt...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_ThiefQ = quest.id
end
function TributeSappeur()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Zahlt ".. round(6000/gvDiffLVL) .." Schwefel, ".. round(4200/gvDiffLVL) .." Kohle und ".. round(7800/gvDiffLVL) .." Taler, um den Sappeur einen Tunnel errichten und die feindliche Kanonengießerei sabotieren zu lassen."
	tribute.cost = { Sulfur = round(6000/gvDiffLVL), Knowledge = round(4200/gvDiffLVL), Gold = round(7800/gvDiffLVL) }
	tribute.Callback = TributePaidSap
	TributeSapID = AddTribute(tribute)
end
function TributePaidSap()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("thief",thi,"Ich werde direkt mit dem Graben beginnen", true)
	ASP("thief",thi,"Ich hoffe, ihr haltet Euer Versprechen und kümmert Euch gut und meine Familie.", false)
	briefing.finished = function()
		Logic.RemoveQuest(1, P5_ThiefQ)
		Move("thief", "Leer4")
		StartSimpleJob("CheckForSappeurArrivedAtStartingPoint")
	end;
	StartBriefing(briefing)
end
function CheckForSappeurArrivedAtStartingPoint()
	if IsDead("thief") then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("Kampf",ment,"Ohweh... @cr Der Sappeur hat es nicht lebendig an sein Ziel geschafft. @cr Ihr hättet ihn wohl besser beschützen sollen. @cr Nun haltet Euer Versprechen und kümmert Euch um seine Familie.", false)
		briefing.finished = function()
			TributeWidow()
			WidowCountdown = StartCountdown(20*60, DesperateWidow, false)
		end;
		StartBriefing(briefing)
		return true
	end
	if IsNear("thief", "Leer4", 300) then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("thief",thi,"Ab ins Dunkel...", false)
		briefing.finished = function()
			DestroyEntity("thief")
			local rng = math.random(1,5)
			if rng == 5 then
				StartCountdown((20*60)/gvDiffLVL, SappeurTunnelCollapse, false)
			else
				StartCountdown((30*60)/gvDiffLVL, SappeurArrivedAtTarget, false)
			end
		end;
		StartBriefing(briefing)
		return true
	else
		if Logic.GetCurrentTaskList(GetID("thief")) == "TL_NPC_IDLE" then
			if Counter.Tick2("thief_idle_counter", 5) then
				Move("thief", "Leer4")
			end
		end
	end
end
function SappeurArrivedAtTarget()
	local posX, posY = Logic.GetEntityPosition(GetID("FoundryP7"))
	Logic.CreateEffect(GGL_Effects.FXExplosion, posX, posY)
	Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, posX, posY)
	Logic.CreateEffect(GGL_Effects.FXDieHero, posX, posY, 5)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Extra",ment,"Heureka! @cr Der Sappeur hat sein Ziel erreicht und die Sabotage erfolreich durchgeführt. @cr Leider ließ er dabei sein Leben... @cr Nun haltet Euer Versprechen und kümmert Euch um seine Familie.", false)
	briefing.finished = function()
		TributeWidow()
		P7FoundrySabotaged = true
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED,"","OnSabotagedCannonCreated",1,{},{})
	end;
	StartBriefing(briefing)
end
function OnSabotagedCannonCreated()
	local entityID = Event.GetEntityID()
	local player = GetPlayer(entityID)
	if player == 7 then
		if IsCannonType(Logic.GetEntityType(entityID)) then
			local rng = math.random(1,(5-gvDiffLVL))
			if rng == 1 then
				ChangePlayer(entityID, 1)
			end
		end
	end
end
function SappeurTunnelCollapse()
	local posX, posY = Logic.GetEntityPosition(GetID("Extra"))
	Logic.CreateEffect(GGL_Effects.FXExplosion, posX, posY)
	Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, posX, posY)
	Logic.CreateEffect(GGL_Effects.FXDieHero, posX, posY, 5)
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Extra",ment,"Ohweh... @cr Der vom Sappeur gegrabene Tunnel ist zusammengestürzt. @cr Nun haltet Euer Versprechen und kümmert Euch um seine Familie.", false)
	briefing.finished = function()
		TributeWidow()
	end;
	StartBriefing(briefing)
end
function TributeWidow()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Entsendet ".. round(12000/gvDiffLVL) .." Taler und eine Trauerkarte an die Witwe des Sappeurs."
	tribute.cost = { Gold = round(12000/gvDiffLVL) }
	tribute.Callback = TributePaidWidow
	TributeWiID = AddTribute(tribute)
end
function TributePaidWidow()
	StopCountdown(WidowCountdown)
end
function DesperateWidow()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("Dario",ment,"Ohweh mein Herr... @cr Ihr habt Euch nicht um die Familie des Sappeurs gekümmert.", false)
	ASP("Feste",ment,"Die Frau des Sappeurs hat sich erhängt, seine Kinder sind schwer erkrankt. @cr Nun, eines habt ihr geschafft: @cr Eure Kaltherzigkeit gegenüber der Familie des Sappeurs hat sich herumgesprochen.", false)
	ASP("monk",ment,"Bei der öffentlichen Andacht wurdet IHR, ja nur IHR als Schuldiger erklärt, dass die Kinder nun als Waisen aufwachsen müssen. @cr Es würde mich nicht wundern, wenn die Bewohner der Nordfeste sich nun von Euch abwenden.", false)
	briefing.finished = function()
		Logic.RemoveTribute(1, TributeWiID)
		SetHostile(1, 5)
		SetNeutral(5, 2)
		SetNeutral(5, 3)
		SetNeutral(5, 7)
		SetNeutral(5, 8)
		MapEditor_Armies[5].offensiveArmies.strength = MapEditor_Armies[5].offensiveArmies.strength + round(6/gvDiffLVL)
		MapEditor_Armies[5].defensiveArmies.strength = MapEditor_Armies[5].defensiveArmies.strength + round(4/gvDiffLVL)
		AlliesNowAngry = true
	end;
	StartBriefing(briefing)
end
function Miner()
	local BeiMin = {
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
		ASP("miner",mi,"Dieses ständige schlechte Wetter geht mir auf die Nerven. @cr Ich bin hier doch nicht in England!", false)
		ASP("claymine",mi,"Ich kann gar nicht verstehen, was meine Kollegen so toll daran finden, tagein, tagaus in dieser schlammigen Lehmgrube zu ackern wie ein Tier.", false)
		ASP("miner",mi,"Versteht mich nicht falsch, ich bin gerne Bergmann. @cr Aber ich wäre gerne nicht ständig der Witterung ausgesetzt.", false)
		ASP("miner",mi,"Ich hatte mal gehört, dass man tief im Berginneren Kohle abbauen kann. @cr Das wäre doch etwas.", false)
		ASP("mount",mi,"Die Bergflanke nördlich von hier eignet sich doch bestimmt bestens dafür. @cr Seid so gut, und errichtet dort ein Kohlebergwerk.", false)
		briefing.finished = function()
			P5_MinerQuest()
			StartSimpleJob("Built_Coalmine")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMin)
end
function P5_MinerQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Immer rein in den Dreck!",
		text	= "Ein Bergmann ist empört ob der miesen Arbeitsbedingungen. @cr Ständig in die schlammigen Lehmgrube hinabsteigen und dazu noch das miese Wetter..." ..
			"@cr Das gefällt ihm so gar nicht. @cr Er würde lieber unter Tage knechten. @cr Seid so gut und errichtet für den armen Mann ein Kohlebergwerk an der Bergflanke nördlich seines Arbeitsplatzes.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_MinerQ = quest.id
end
function Built_Coalmine()
	local posX, posY = Logic.GetEntityPosition(GetID("mount"))
	local num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_CoalMine2, posX, posY, 6000, 1)
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("miner",mi,"Habt Dank mein Herr!", false)
		ASP(id,mi,"Nun muss ich mich nicht mehr im Regen und klirrenden Winter zu Tode schuften.", false)
		ASP("miner",mi,"Hier, nehmt diese alte Kette als Zeichen meiner Dankbarkeit. @cr Sie wurde über Generationen in meiner Familie weitergegeben.", false)
		ASP("Dario",ment,"Seht doch, mein Herr. @cr Der Bergmann hat Euch eine prunkvolle Silberkette überreicht. @cr Die lässt sich bestimmt gut einschmelzen. @cr Ihr solltet dem Bergmann nur nichts davon erzählen...", false)
		briefing.finished = function()
			Logic.RemoveQuest(1, P5_MinerQ)
			ReplaceEntity("miner", Entities.PU_Miner)
			ChangePlayer(id, 5)
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, round(200*gvDiffLVL))
		end;
		StartBriefing(briefing)
		return true
	end
end
function Trader()
	local BeiTr = {
	Heroes = true,
	TargetName = "trader",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("trader"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("trader",id);LookAt(id,"trader")
		DisableNpcMarker(GetEntityId("trader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("trader",tra,"Buähh, ich bin so traurig. @cr Kerberos dunkle Horden haben meinen Handelsposten niedergebrannt.", true)
		ASP("Ruin_4",tra,"Ich konnte grade noch mein Leben und einige wenige Güter retten. @cr Sie nahmen mir alles...", false)
		ASP("trader",tra,"Jetzt kann ich nur noch hier meine wenigen Güter anpreisen. @cr Aber niemand hier möchte meine Waren kaufen...", false)
		ASP("trader",tra,"Bitte Herr! @cr Reißt diesen Bastarden den Arsch auf. @cr Und wenn ihr die Kapazitäten habt, errichtet doch bitte einen neuen Handelsposten für mich.", true)
		briefing.finished = function()
			P5_TraderQuest()
			StartSimpleJob("MarketBuiltJob")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiTr)
end
function P5_TraderQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Ein neuer Handelsposten",
		text	= "Der alte Handelsposten des Händlers wurde von Kerberos Horden niedergebrannt." ..
			"@cr Seid so gut und errichtet für den Händler einen neuen Handelsposten.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_TraderQ = quest.id
end
function MarketBuiltJob()
	local num, id = Logic.GetPlayerEntities(1, Entities.PB_Market3, 1)
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,tra,"Habt Dank. @cr Habt Dank. @cr Ich werde mich direkt auf den Weg machen.", false)
		ASP("trader",tra,"Kommt mich jederzeit besuchen und schauet meine Waren. @cr Ach und nehmt dies als Zeichen meiner Dankbarkeit. @cr Die Waren bin ich sowieso nicht losgeworden in dieser Stadt.", true)
		briefing.finished = function()
			Logic.RemoveQuest(1, P5_TraderQ)
			Move("trader", id)
			Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, round(2500*gvDiffLVL))
			StartSimpleJob("TraderArrivedAtMarketJob")
		end;
		StartBriefing(briefing)
		return true
	end
end
function TraderArrivedAtMarketJob()
	local posX, posY = Logic.GetEntityPosition(GetID("trader"))
	local num, id = Logic.GetPlayerEntitiesInArea(1, Entities.PB_Market3, posX, posY, 1000, 1)
	if num > 0 then
		EnableNpcMarker(GetID("trader"))
		Trader2()
		return true
	end
end
function Trader2()
	local BeiTr2 = {
	Heroes = true,
	TargetName = "trader",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("trader"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("trader",id);LookAt(id,"trader")
		DisableNpcMarker(GetEntityId("trader"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("trader",tra,"Ah, ihr seid es. @cr Schaut in Euer Tributmenü, ich mache Euch gute Preise.", false)
		briefing.finished = function()
			NumCoalTributePaid = 1
			TributeCoal1()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiTr2)
end
function TributeCoal1()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Zahlt ".. round(2100/gvDiffLVL) + round(NumCoalTributePaid * 600 / gvDiffLVL) .." Taler für 3000 Kohle."
	tribute.cost = { Gold = round(2100/gvDiffLVL) + round(NumCoalTributePaid * 600 / gvDiffLVL) }
	tribute.Callback = TributePaidCoal1
	TributeCoal1ID = AddTribute(tribute)
end
function TributePaidCoal1()
	NumCoalTributePaid = NumCoalTributePaid + 1
	Logic.AddToPlayersGlobalResource(1, ResourceType.Knowledge, 3000)
	TributeCoal1()
end
function Fisherman()
	local BeiFi = {
	Heroes = true,
	TargetName = "fisherman",
	Distance = 300,
	Callback = function()
		local posX, posY = Logic.GetEntityPosition(GetID("fisherman"))
		local id = GetNearestEntityOfPlayerAndCategoryInArea(1, posX, posY, 300, EntityCategories.Hero)
		LookAt("fisherman",id);LookAt(id,"fisherman")
		DisableNpcMarker(GetEntityId("fisherman"))
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Nanu, hier so weit draußen noch ein einsamer Siedler? @cr Was treibt ihr hier? @cr Seht ihr nicht, dass Krieg herrscht?", true)
		ASP("fisherman",fish,"Nun, mein Herr, für solche Dinge interessiere ich mich nicht. Ich bin nur ein einsamer Fischer. @cr Aber irgendwie wollen die Fische hier nicht so beißen...", true)
		ASP("fisherman_chest",fish,"Einst war ich dort oben tagein, tagaus am angeln und konnte so meine Familie durchbringen. @cr Aber dann bezog ein neuer Regent die Feste und das Übel nahm seinen Lauf...", false)
		ASP("sea_view",fish,"Ressourcen wurden erbarmungslos geplündert, Industrieabfälle und Unrat einfach in den See geschüttet. @cr Meine Familie wurde schwer krank und der See versumpfte zusehends...", false)
		ASP("fisherman",fish,"Als mir dann letztes Jahr mein letztes Kind genommen wurde, verließ ich die Feste und ließ mich hier am Nordmeer nieder. @cr Nichts ist mir geblieben...", false)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Der Regent von dem ihr da spricht, ist bestimmt Kerberos. @cr Das miese Schwein macht nicht einmal vor seinen eigenen Untertanen halt.", true)
		ASP("fisherman_chest",tra,"Oh, ihr steht ihm feindlich gegenüber? @cr In dem Fall könnt ihr Euch gerne an all dem Hab und Gut laben, dass ich zurücklassen musste. @cr Vielleicht hilft es Euch ja...", true)
		briefing.finished = function()
			P5_FishermanQuest()
			StartSimpleJob("Control_Fisherman_Chest")
		end
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiFi)
end
function P5_FishermanQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Zurückgelassene Schätze",
		text	= "Der alte Fischer hat alles - wirklich alles - an Kerberos Untaten verloren. @cr Er hat seine Schätze vor Kerberos Schergen verborgen und ist aus der Stadt geflohen. " ..
			"@cr Nun liegt es an Euch, den Schatz des alten Fischers zu bergen. @cr Er befindet sich in einer alten Holztruhe in der alten Schaluppe des Fischers am Rande von Kerberos Festungsstadt.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_FishMQ = quest.id
end
function Control_Fisherman_Chest()
	local id = GetID("fisherman_chest")
	local pos = GetPosition(id)
	local entities = {Logic.GetPlayerEntitiesInArea(1, 0, pos.X, pos.Y, 300, 1)}
	if entities[1] > 0 then
		if Logic.IsHero(entities[2]) == 1 then
			local amount = round(100 * gvDiffLVL + math.random(300) ^ (1 + Logic.GetTime()/ 36000))
			local text = amount .. " Silber"
			Logic.AddToPlayersGlobalResource(1, ResourceType.Silver, amount)
			Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat die Truhe des Fischers geplündert. Inhalt: " .. text )
			ReplaceEntity(id, Entities.XD_ChestOpen)
			Logic.RemoveQuest(1, P5_FishMQ)
			return true
		end
	end
end
function Alchemist()
	local npc = "alchemist"
	local npcname = alch
	local BeiAl = {
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
		ASP(npc,npcname,"Ihr habt es geschafft! @cr Kerberos Außenposten ist gefallen. @cr Ihr seid wahrlich ein mächtiger Anführer.", true)
		ASP("Ruin_4",npcname,"Wir sollten diesen Triumph feiern und die alten Ruinen der früheren Stadtgrenze beseitigen. @cr Nun, da es wieder etwas sicherer ist, können wir dort wieder neue Gebäude errichten.", false)
		ASP(npc,npcname,"Ihr solltet in der Lage sein, die Ruinen einzureißen. @cr Gebt mir dann ein wenig Schwefel und Kohle und ich beseitige mit einigen gezielten Sprengsätzen die übrigen Trümmer.", true)
		ASP("Ruin_9",npcname,"Seid jedoch vorsichtig. @cr Einige Gesetzlose sollen sich in den Ruinen niedergelassen haben.", false)
		briefing.finished = function()
			for i = 0, 10 do
				ChangePlayer("Ruin_" .. i, 2)
			end
			StartSimpleJob("Ruinen")
			P5_AlchemistQuest()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiAl)
end
function P5_AlchemistQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Diese Trümmer verschandeln mir die Aussicht!",
		text	= "Nun, da die Lage etwas sicherer für die Nordfeste ist, solltet ihr die alten Ruinen am Stadtrand beseitigen. " ..
			"@cr Gebt dem Alchemisten nach Beseitigung der Ruinen etwas Schwefel und Kohle, sodass dieser mithilfe einiger Sprengsätze die restlichen Trümmer beseitigen kann. " ..
			"@cr In den Ruinen sollen sich Gestztlose verstecken, gebt also Acht!",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P5_AlchQ = quest.id
end
RuinSpawnDone = {}
function Ruinen()
	for i = 0, 9 do
		if not RuinSpawnDone[i+1] and IsDestroyed("Ruin_" .. i) then
			CreateRuinAmbushArmy(i)
			RuinSpawnDone[i+1] = true
			break
		end
	end
	if table.getn(RuinSpawnDone) == 10 then
		P5_AlchemistTribute()
		return true
	end
end
function P5_AlchemistTribute()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "Gebt dem Alchemisten ".. round(2100/gvDiffLVL) .." Kohle und " .. round(4200/gvDiffLVL) .. " Schwefel, um die verbliebenen Trümmer am Stadtrand der Nordfeste zu beseitigen."
	tribute.cost = { Knowledge = round(2100/gvDiffLVL), Sulfur = round(4200/gvDiffLVL) }
	tribute.Callback = P5_AlchemistTributePaid
	P5_AlchemistTributeID = AddTribute(tribute)
end
function P5_AlchemistTributePaid()
	local npc = "alchemist"
	local npcname = alch
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npcname,"Habt Dank für die Lieferung. @cr Ich mache mich sofort auf den Weg, um die Trümmer zu beseitigen.", true)
	briefing.finished = function()
		Move("alchemist", "Ruinspawn")
		StartSimpleJob("P5_Alch_Arrived_At_Ruins")
	end;
	StartBriefing(briefing)
end
P5_Alch_ExplosionPositions = {
	{X = 28825.90, Y = 49562.37},
	{X = 29273.78, Y = 49520.00},
	{X = 30720.00, Y = 49920.00},
	{X = 30270.54, Y = 48869.32},
	{X = 27754.36, Y = 47980.00},
	{X = 28429.53, Y = 48020.00},
	{X = 29180.00, Y = 48031.75},
	{X = 30280.00, Y = 47720.00},
	{X = 29520.00, Y = 47330.28},
	{X = 28320.00, Y = 47124.94},
	{X = 27565.69, Y = 47034.85},
	{X = 27420.00, Y = 45823.53},
	{X = 28229.03, Y = 45720.00},
	{X = 28944.85, Y = 45956.61},
	{X = 29573.98, Y = 45955.70},
	{X = 28920.00, Y = 44480.00},
}
function P5_Alch_Arrived_At_Ruins()
	if IsNear("alchemist", "Ruinspawn", 300) then
		for i = 1, table.getn(P5_Alch_ExplosionPositions) do
			local X, Y = P5_Alch_ExplosionPositions[i].X, P5_Alch_ExplosionPositions[i].Y
			Logic.CreateEffect(GGL_Effects.FXBuildingSmokeLarge, X, Y)
			Logic.CreateEffect(GGL_Effects.FXExplosion, X, Y)
			StartCountdown(2, function(_X, _Y) Logic.DestroyEntity(Logic.GetEntityAtPosition(_X, _Y)) end, false, nil, X, Y)
		end
		Logic.RemoveQuest(1, P5_AlchQ)
		DestroyEntity("Ruinspawn")
		return true
	else
		if Logic.GetCurrentTaskList(GetID("alch")) == "TL_NPC_IDLE" then
			Move("alchemist", "Ruinspawn")
		end
	end
end
--
function Vik_Settler1()
	local npc = "vik_settler1"
	local npcname = vk_set1
	local BeiVk_s1 = {
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
		ASP(npc,npcname,"Verschont uns! @cr Wir sind einfache Bergbewohner und haben mit Vargs schändlichen Taten nichts zu tun.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Gut gesprochen. @cr Aber ich kann euch nicht trauen. @cr Lasst mich mit eurem Dorfältesten sprechen. @cr Danach fallen wir ein Urteil, wie wir mit euch verfahren.", true)
		ASP("vik_settler2",npcname,"Ihr meint unseren Jarl? @cr Der befindet sich meist vor seiner Hütte, auf dem Nordhang Velborgs. @cr Doch er wird euch auch nichts anderes erzählen. @cr So glaubt uns doch, wir sind einfache Leute und keine mordenden Barbaren.", true)
		briefing.finished = function()
			EnableNpcMarker(GetID("vik_settler2"))
			Vik_Settler2()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_s1)
end
function Vik_Settler2()
	local npc = "vik_settler2"
	local npcname = vk_set2
	local BeiVk_s2 = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Seid ihr Jarl Floki? @cr Ein Dörfler flehte um sein Leben und schwörte, dass ihr Bergbewohner Velborgs nichts mit Vargs Machenschaften zu tun habt. @cr Ist das wahr?", true)
		ASP(npc,npcname,"Ja, der bin ich. @cr Als Varg sich hier einnistete, hatten wir wenig, was wir dagegenstellen konnten. @cr Was können einige Bergbewohner schon gegen eine marodierende Horde Barbaren ausrichten?", true)
		ASP(npc,npcname,"Als Jarl musste ich eine Entscheidung treffen, die die gesamten Dörfer betrifft. @cr Ich bin nicht stolz darauf, aber ich fügte mich und wir kollaborierten mit Varg. @cr Hätte ich anders entschieden, wären wir sicherlich nicht mehr am Leben...", true)
		local choicePage = AP{
			mc = {
				title			= ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."",
				text 			= "(In Gedanken) Ob man diesen Dörflern wirklich trauen kann? @cr Wir sollten sofort eine eindeutige Entscheidung treffen.",
				firstText  		= " @color:230,20,20 Nun, das kann man nicht beschönigen. @cr Egal, wie man es dreht und wendet, ihr habt Hochverrat gegen den König und das Reich begangen. @cr Darauf steht der Tod!",
				secondText 	 	= " @color:20,255,50 Ich gebe euch eine letzte Chance. @cr Beweist euch als loyale Untergebe Darios.",
				firstSelected  	= 5,
				secondSelected 	= 9,
				position 		= GetPosition(npc)
			},
			action = function() end
		}

		AP{title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Los Männer, statuiert an ihnen ein Exempel. @cr Das soll allen Verrätern eine Warnung sein!"}
		AP{title = npcname, text = "Gnade Herr! @cr So lasst doch Gnade walten...",
			position = GetPosition(npc), dialogCamera = false, action = function()
			end}
		AP{title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Das Recht auf Gnade wird euch verwehrt. @cr Euer Schicksal ist bereits besiegelt."}
		AP()
		AP{title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Ein jeder Erstgeborene, der vierzehn Sommer erlebt hat, muss in unsere Dienste gestellt werden. " ..
			"@cr Solange sie uns getreu im Kampf zur Seite stehen, dürft ihr euer friedliches Dorfleben wieder aufnehmen. @cr Doch wagt es ja nicht, uns zu hintergehen.",
			position = GetPosition(npc), dialogCamera = false, action = function()
			end}
		AP{title = npcname, text = "Unsere Erstgeborenen? @cr Oh weh, ein harter Schlag für unsere Frauen. @cr Aber wenn das die einzige Möglichkeit ist, euch unsere Treue zu beweisen, so haben wir wohl keine andere Wahl... " ..
			"@cr Ihr werdet aber schon selbst mit den Dörflern sprechen müssen. @cr Ich bringe es nicht übers Herz, so schlechte Nachrichten zu verbreiten..."}
		AP{title = ""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."", text = "Nun, ihr bildet da keine Ausnahme. @cr Auch euren Erstgeborenen nehmen wir mit!"}
		briefing.finished = function()
			if GetSelectedBriefingMCButton(choicePage) == 1 then
				ReplaceEntity(ChangePlayer("vik_settler1", 6), Entities.CU_Barbarian_LeaderClub2)
				ReplaceEntity(ChangePlayer("vik_settler2", 6), Entities.CU_VeteranLieutenant)
				ReplaceEntity(ChangePlayer("vik_settler3", 6), Entities.CU_Barbarian_LeaderClub2)
				--
				ReplaceEntity(ChangePlayer("vik_farmer1", 6), Entities.CU_Barbarian_LeaderClub2)
				ReplaceEntity(ChangePlayer("vik_farmer2", 6), Entities.CU_Barbarian_LeaderClub2)
				ReplaceEntity(ChangePlayer("vik_farmer3", 6), Entities.CU_Barbarian_LeaderClub2)
				ReplaceEntity(ChangePlayer("vik_farmer4", 6), Entities.CU_Barbarian_LeaderClub2)
    		else
				FirstbornsDeadJobs = {}
				local pos = GetPosition("vik_settler2")
				Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_settler_2")
				table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"settler", 2}))
				TalkedToVikNPCs = 1
				FirstbornsDead = 0
				--
				P6_JarlQuest()
				EnableNpcMarker(GetID("vik_settler1"))
				Vik_Settler1_2()
				EnableNpcMarker(GetID("vik_settler3"))
				Vik_Settler3()
				EnableNpcMarker(GetID("vik_farmer1"))
				Vik_Farmer1()
				EnableNpcMarker(GetID("vik_farmer2"))
				Vik_Farmer2()
				EnableNpcMarker(GetID("vik_farmer3"))
				Vik_Farmer3()
				EnableNpcMarker(GetID("vik_farmer4"))
				Vik_Farmer4()
				--
				StartSimpleJob("Vik_TalkedToAllNPCsJob")
			end
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_s2)
end
function P6_JarlQuest()
	local quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Die Jarlsqueste",
		text	= "Ihr habt die verräterischen Bergbewohner Velborgs verschont." ..
			"@cr Im Gegenzug müssen die Erstgeborenen einer jeden Familie in Euren Reihen dienen. " ..
			"@cr Der Jarl brachte es jedoch nicht übers Herz, den Müttern diese Nachricht zu überbringen. " ..
			"@cr Ihr werdet dies selbst mit den Familien Velborgs besprechen müssen...",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	P6_JarlQ = quest.id
end
function Vik_Settler1_2()
	local npc = "vik_settler1"
	local npcname = vk_set1
	local BeiVk_s1 = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wo ist euer Erstgeborener. @cr Ihm kommt die Ehre zugute, Ruhm und Glorie für Darios Reich zu erweitern.", true)
		ASP(npc,npcname,"Nicht unseren Björn... @cr Alles, nur das nicht... @cr Wie könnt ihr nur so grausam sein?", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Das ist nur das Ergebnis eurer schändlichen Taten. @cr Seid froh, dass ihr mit dem Leben davonkommt.", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_settler3")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_settler_1")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"settler", 1}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_s1)
end
function Vik_Settler3()
	local npc = "vik_settler3"
	local npcname = vk_set3
	local BeiVk_s3 = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Bringt uns euren Erstgeborenen. @cr Dann dürft ihr trotz eures schändlichen Verrats hier weiter in Frieden leben. @cr Ein wahrlich kleiner Preis für all eure Verfehlungen!", true)
		ASP(npc,npcname,"Unseren ältesten Sohn? @cr Nein, nicht unseren ältesten Sohn. @cr Alles, außer das...", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_settler3")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_settler_3")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"settler", 3}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_s3)
end
function Vik_Farmer1()
	local npc = "vik_farmer1"
	local npcname = vk_far1
	local BeiVk_f1 = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Wo ist euer ältester Sohn. @cr Ihm wird die Ehre zuteil, in Darios glorreichem Heer zu dienen und so die Schandtaten seiner Familie reinzuwaschen.", true)
		ASP(npc,npcname,"Was für Schandtaten? @cr Wir sind einfache Schafhirten. @cr Bitte, lasst uns unseren Sohn. Wer soll uns denn nun im Alter pflegen und unser Erbe weiterführen?... @cr Ihr seid wahrlich grausam.", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_farmer1")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_farmer_1")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"farmer", 1}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_f1)
end
function Vik_Farmer2()
	local npc = "vik_farmer2"
	local npcname = vk_far2
	local BeiVk_f2 = {
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
		ASP(npc,npcname,"Was tut ihr da? @cr Ihr habt kein Recht, unseren Karl mitzunehmen! @cr Lasst ihn frei!", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Auf keinen Fall. @cr Das ist mit dem Jarl abgesprochen. @cr Euer Sohn wird für eure schändliche Kollaboration mit Varg in eurem Namen die Schuld ableisten.", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_farmer2")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_farmer_2")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"farmer", 2}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_f2)
end
function Vik_Farmer3()
	local npc = "vik_farmer3"
	local npcname = vk_far3
	local BeiVk_f3 = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Auf königlichem Befehl nehmen wir uns euren ältesten Sohn. @cr Er wird euren Namen wieder reinwaschen.", true)
		ASP(npc,npcname,"Was habt ihr mit unserem Sohn vor? @cr Nein, wie könnt ihr es wagen? @cr Lasst die Finger von ihm... @cr Er ist doch noch ein Kind...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Er wird in unsere Armeen eingereiht. @cr Ihr werdet ihn nie wieder sehen. @cr Im Gegenzug sehen wir über euren schändlichen Verrat hinweg.", true)
		ASP(npc,npcname,"Verrat? @cr Wir sind nur einfache Schäfer... @cr Wer ist hier der wahre Barbar?", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_farmer3")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_farmer_3")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"farmer", 3}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_f3)
end
function Vik_Farmer4()
	local npc = "vik_farmer4"
	local npcname = vk_far4
	local BeiVk_f4 = {
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
		ASP(npc,npcname,"Thore, lauf! @cr Lauf, so schnell du kannst... @cr Nein, lasst eure dreckigen Hände von unserem Sohn. @cr Er hat euch doch nichts getan...", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Er vielleicht nicht. @cr Ihr jedoch schon. @cr Ihr habt euer Schicksal besiegelt, als ihr gemeinsame Sache mit Varg gemacht habt.", true)
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Seid froh, dass wir uns nur euren Sohn holen. @cr Für euren Hochverrat hättet ihr den Tod verdient!", true)
		briefing.finished = function()
			TalkedToVikNPCs = TalkedToVikNPCs + 1
			local pos = GetPosition("vik_farmer4")
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "firstborn_farmer_4")
			table.insert(FirstbornsDeadJobs, Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "","Firstborn_Dead_Job",1,{},{"farmer", 4}))
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiVk_f4)
end
function Vik_TalkedToAllNPCsJob()
	if TalkedToVikNPCs >= 7 then
		Logic.RemoveQuest(1, P6_JarlQ)
		return true
	end
end
function Firstborn_Dead_Job(_villagerType, _index)
	if IsDead("firstborn_" .. _villagerType .. "_" .. _index) then
		FirstbornsDead = FirstbornsDead + 1
		EnableNpcMarker(GetID("vik_" .. _villagerType .. "" .. _index))
		Generic_Vik_Villager_Firstborn_Dead_Brief(_villagerType, _index)
		return true
	end
end
Vik_Data_ToNPCNameString = {
	["settler"] = "set",
	["farmer"] = "far"
}
function Generic_Vik_Villager_Firstborn_Dead_Brief(_villagerType, _index)
	local npc = "vik_" .. _villagerType "" .. _index
	local npcname = vk_ .. Vik_Data_ToNPCNameString[_villagerType] .. _index
	local Brief = {
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
		ASP(id,""..orange.."" .. GetNPCDefaultNameByID(id) .. ""..weiss.."","Euer ätester Sohn ist im Kampf gefallen. @cr Er hat dem Reich treue Dienste geleistet. @cr Lasst uns gemeinsam seinen Tod rächen und lasst euren jüngeren Sohn seinen Platz einnehmen.", true)
		ASP(npc,npcname,"Unser Junge... @cr Oh nein! @cr Ihr Monster! @cr Wie konntet ihr das nur zulassen...", true)
		briefing.finished = function()
			local pos = GetPosition("vik_" .. _villagerType "" .. _index)
			Logic.SetEntityName(AI.Entity_CreateFormation(1, Entities.CU_VeteranLieutenant, 0, 0, pos.X, pos.Y, 0, 0, 0, 0), "secondborn_" .. _villagerType .. "_" .. _index)
			if math.random(1, (100 - round(FirstbornsDead ^ 2))) < 10 or FirstbornsDead >= 7 then
				Vik_Villager_RevolutionBrief()
			end
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(Brief)
end
Vik_Villager_Etypes = {
	Entities.CB_MinerCamp1, Entities.CB_MinerCamp2, Entities.CB_MinerCamp3,
	Entities.CB_MinerCamp4, Entities.CB_MinerCamp5, Entities.CB_MinerCamp6, Entities.PB_Farm2
}
function Vik_Villager_RevolutionBrief()
	local npc = "vik_settler2"
	local npcname = vk_set2
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP(npc,npcname,"Ihr habt es zu weit getrieben! @cr Wir werden nicht tatenlos mit ansehen, wie ihr unsere Söhne in den sicheren Tod schickt. @cr Los Männer, zu den Waffen!", true)
	briefing.finished = function()
		for i = 1, table.getn(FirstbornsDeadJobs) do
			Trigger.UnrequestTrigger(FirstbornsDeadJobs[i])
		end
		for i = 1, 3 do
			if IsExisting("firstborn_settler_" .. i) then
				ChangePlayer("firstborn_settler_" .. i, 6)
			end
			if IsExisting("secondborn_settler_" .. i) then
				ChangePlayer("secondborn_settler_" .. i, 6)
			end
		end
		for i = 1, 4 do
			if IsExisting("firstborn_farmer_" .. i) then
				ChangePlayer("firstborn_farmer_" .. i, 6)
			end
			if IsExisting("secondborn_farmer_" .. i) then
				ChangePlayer("secondborn_farmer_" .. i, 6)
			end
		end
		ReplaceEntity(ChangePlayer("vik_settler1", 6), Entities.CU_VeteranLieutenant)
		ReplaceEntity(ChangePlayer("vik_settler2", 6), Entities.CU_VeteranLieutenant)
		ReplaceEntity(ChangePlayer("vik_settler3", 6), Entities.CU_VeteranLieutenant)
		--
		ReplaceEntity(ChangePlayer("vik_farmer1", 6), Entities.CU_VeteranLieutenant)
		ReplaceEntity(ChangePlayer("vik_farmer2", 6), Entities.CU_VeteranLieutenant)
		ReplaceEntity(ChangePlayer("vik_farmer3", 6), Entities.CU_VeteranLieutenant)
		ReplaceEntity(ChangePlayer("vik_farmer4", 6), Entities.CU_VeteranLieutenant)
		--
		CreateVikRevolutionArmy()
		--
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(4), CEntityIterator.OfAnyTypeFilter(unpack(Vik_Villager_Etypes))) do
			ChangePlayer(eID, 6)
		end
	end;
	StartBriefing(briefing)
end
--**
function QuestSieg()
	local quest	= {
	id		= GetQuestId(),
	type	= MAINQUEST_OPEN,
	title	= "Der finale Kampf",
	text	= "Stürmt in einem finalen Kampf die Festungen von Kerberos und Varg, damit wieder Frieden im Norden des Reiches einkehren kann.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	SiegQuest = quest.id
end
--**
function VictoryJob()
	if IsDead("KerberosHQ1") and IsDead("KerberosHQ2") and IsDead("VargFortress") and IsDead("VargHQ") then
		if Counter.Tick2("VictoryJob_Counter",20) then
			local briefing = {}
			local AP, ASP = AddPages(briefing);
			ASP("Dario",dario,"Endlich hat die Invasion durch Kerberos ein Ende.", false)
			ASP("Dario",dario,"Dies ist ein wahrer Grund zum Feiern meine Freunde.", false)
			ASP("Outpost_Ruin",dario,"Lasst uns einige Tage den Sieg über Kerberos Unterdrückung zelebrieren und erst dann den Weg zurück in die Hauptstadt antreten!", false)
			ASP("Pilgrim",pil,"Was soll das Dario? @cr Hör bitte einfach auf, über beschwerliche Wege zu reden, lass uns einfach FEIIIEERN!!!!", false)
			ASP("Outpost_Ruin",ment,"Pilgrim war zwar bereits hackedicht voll, dies hinderte ihn und seine Freunde allerdings nicht daran, bis tief in die Nacht zu feiern.", false)
			ASP("Dario",dario,"Mir kommt da grad noch so eine Idee. Nachbardörfer im Kralgebirge werden vom Nebelvolk und Banditen heimgesucht.", true)
			ASP("Dario",dario,"Lasst uns doch mal dort vorbeischauen und ihnen helfen, wir sind sowieso in der Nähe. Zeit für die Heimreise haben wir noch genug.", true)
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, 21700,73200, 0 );
			Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, 21700,73200, 0 );
			briefing.finished = function()
				Victory()
			end
			StartBriefing(briefing);
			return true
		end
	end
end

function Verloren()
	if ((IsDead("Feste") or IsDestroyed("Dorf")) and not AlliesNowAngry) then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Outpost_Ruin",ment,"Warum habt Ihr die Nordfeste nicht beschützt?", false)
		ASP("Dario",ment,"Jetzt habt Ihr sie verloren und damit auch das Spiel verloren.", false)
		ASP("Ruinspawn",ment,"Versucht es noch mal und macht es dann besser.", false)
		briefing.finished = function()
			Defeat()
		end
		StartBriefing(briefing);
		return true
	end
	if ((IsDead("Dario") or IsDead("Ari") or IsDead("Drake") or IsDead("Pilgrim") or IsDead("Erec")) and not Chapter1Done) then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Outpost_Ruin",ment,"Warum habt Ihr eure Helden nicht beschützt?", false)
		ASP("Dario",ment,"Jetzt sind sie gefallen und damit habt ihr das Spiel verloren.", false)
		ASP("Ruinspawn",ment,"Versucht es noch mal und macht es dann besser.", false)
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
function ExtraTr()
	if IsDestroyed("ExtraA") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Extra",ment,"Was ist das? @cr Banditen stürmen aus den Höhlen und versuchen, die Nordfeste zu zerstören.", false)
		briefing.finished = function()
			Extra()
		end
		StartBriefing(briefing);
		return true
	end
end
function Nachschub()
	if IsDestroyed("ExtraB") then
		local briefing = {}
		BRIEFING_TIMER_PER_CHAR = 1.0
		local AP, ASP = AddPages(briefing);
		ASP("Nachschub",ment,"Die Hilfstrupps aus Fort Wulfilar sind nun eingetroffen.", false)
		briefing.finished = function()
			Zusatz()
		end
		StartBriefing(briefing);
		return true
	end
end
function Zusatz()
	for i = 1, round(2+(2*gvDiffLVL)) do
		CreateMilitaryGroup(1,Entities.PU_LeaderSword4,12,GetPosition("Nachschub"))
	end
end

function Eisenmine()
	if IsDestroyed("Eisenmine") then
		local briefing = {}
		local AP, ASP = AddPages(briefing);
		ASP("Reiter",rei,"Sehr gut. @cr Das Eisenbergwerk ist gefallen. @cr Die Truppenstärke Kerberos und Vargs werden spürbar nachlassen.", false)
		ASP("Dario",ment,"Nun, da die Truppenstärke Eurer Feinde nachlassen wird, ist es nicht mehr spielentscheidend, ob einer Eurer Helden in Ohnmacht fällt. @cr Macht Euch keine Sorgen, die Truppen der Nordfeste werden gefallenen Helden früher oder später wiederaufhelfen.", false)
		briefing.finished = function()
			Chapter1Done = true
			Message("Hmm, warum werden diese komischen Manuskripte so stark bewacht??")
			IronGuardArmy()
			ResearchTechnology (Technologies.GT_PulledBarrel)
			MapEditor_Armies[2].offensiveArmies.strength = MapEditor_Armies[2].offensiveArmies.strength - round(2+gvDiffLVL)
			MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength - round(2+gvDiffLVL)
			MapEditor_Armies[7].offensiveArmies.strength = MapEditor_Armies[7].offensiveArmies.strength - round(2+gvDiffLVL)
			MapEditor_Armies[8].offensiveArmies.strength = MapEditor_Armies[8].offensiveArmies.strength - round(2+gvDiffLVL)
			--
			GUI.DestroyMinimapPulse(Logic.GetEntityPosition(GetID("Eisen")))
			Logic.RemoveQuest(1, P5_CavQ)
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
	CreateChest(GetPosition("Leer8"),chestCallbackLeer)
	CreateRandomGoldChest(GetPosition("Gold"))
	CreateRandomGoldChest(GetPosition("Eisen1"))
	CreateRandomGoldChest(GetPosition("Eisen2"))
	CreateRandomGoldChest(GetPosition("Eisen3"))
	CreateRandomGoldChest(GetPosition("Lehm"))
	CreateRandomGoldChest(GetPosition("Stein"))
  	CreateRandomGoldChest(GetPosition("Holz"))
	CreateRandomGoldChest(GetPosition("Schwefel"))
	CreateChest(GetPosition("Versteck1"),chestCallbackVst1)
	CreateChest(GetPosition("Versteck2"),chestCallbackVst2)
	CreateChest(GetPosition("Versteck3"),chestCallbackVst3)
	CreateChest(GetPosition("Versteck4"),chestCallbackVst4)
	CreateRandomGoldChest(GetPosition("Hidden"))
	CreateChest(GetPosition("Truhe"),chestCallbackTruhe)
	CreateChest(GetPosition("chestZ"),chestCallbackZ)
	CreateChest(GetPosition("Ice"),chestCallbackIce)
  	CreateChestOpener("Dario")
	CreateChestOpener("Ari")
	CreateChestOpener("Pilgrim")
	CreateChestOpener("Drake")
	CreateChestOpener("Erec")
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
    Message("@color:240,0,250  Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1600 Eisen.")
	AddIron(1600)
end
function chestCallbackIron2()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Eisen.")
	AddIron(1000)
end
function chestCallbackIron3()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1400 Eisen.")
	AddIron(1400)
end
function chestCallbackClay1()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 600 Lehm.")
	AddClay(600)
end
function chestCallbackStone1()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1000 Steine.")
	AddClay(1000)
end
function chestCallbackWood()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1500 Holz.")
	AddWood(1500)
end
function chestCallbackSulfur()
    Message("@color:240,0,250 Ihr habt eine Schatztruhe gefunden. Ihr Inhalt: 1200 Schwefel.")
	AddSulfur(1200)
end
function chestCallbackVst1()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1500 Taler.")
	AddGold(1500)
end
function chestCallbackVst2()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(2200*gvDiffLVL) .. " Taler.")
	AddGold(round(2200*gvDiffLVL))
	ChestSurprise(8, GetPosition("VersteckSpawn"), round(2/gvDiffLVL))
end
function chestCallbackVst3()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(1800*gvDiffLVL) .. " Taler.")
	AddGold(round(1800*gvDiffLVL))
	ChestSurprise(8, GetPosition("VersteckSpawn"), round(6/gvDiffLVL))
end
function chestCallbackVst4()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(3800*gvDiffLVL) .. " Taler.")
	AddGold(round(3800*gvDiffLVL))
	ChestSurprise(8, GetPosition("VersteckSpawn"), round(4/gvDiffLVL))
end
function chestCallbackHidden()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: 1000 Taler.")
	AddGold(1000)
end
function chestCallbackTruhe()
    Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(3000*gvDiffLVL) .. " Taler.")
	AddGold(round(3000*gvDiffLVL))
	ChestSurprise(8, GetPosition("Truhe"), round(4/gvDiffLVL))
end
function chestCallbackZ()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(5000*gvDiffLVL) .. " Taler.")
	AddGold(round(5000*gvDiffLVL))
	ChestSurprise(8, GetPosition("spawnZ"), round(8/gvDiffLVL))
end
function chestCallbackIce()
	Message("@color:0,255,255 " .. UserTool_GetPlayerName(1) ..  " " .. ChestRandomPositions.TypeToPretext["Gold"] .. " Inhalt: " .. round(1600*gvDiffLVL) .. " Taler.")
	AddGold(round(1600*gvDiffLVL))
	ChestSurprise(8, GetPosition("Icespawn"), round(2/gvDiffLVL))
end

function InitAchievementChecks()
	StartSimpleJob("CheckForAllChestsOpened")
	StartSimpleJob("CheckForNoKills")
	StartSimpleJob("CheckForLighthouseDenied")
	StartSimpleJob("CheckForSilverGathered")
end
function CheckForAllChestsOpened()
	if Logic.GetNumberOfEntitiesOfType(Entities.XD_ChestGold) == 0 then
		Message("Ihr habt alle Schatztruhen gefunden. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\northernseachests", 1)
		return true
	end
end
function CheckForNoKills()
	if TalkedToErec then
		if Score.Player[1].battle == 0 then
			Message("Ihr habt die Nordfeste erreicht, ohne einen einzigen Feind zu besiegen. Herzlichen Glückwunsch!")
			GDB.SetValue("achievements\\northernseanofight", 1)
		end
		return true
	end
end
function CheckForLighthouseDenied()
	if Logic.GetTime() >= 90 * 60 then
		return true
	end
	if Logic.GetEntityType(GetID("fire3")) == Entities.XD_SingnalFireOff then
		Message("Ihr habt binnen 90 Minuten verhindert, dass Kerberos weitere Verstärkungstruppen erhält. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\northernseanosupply", 1)
		return true
	end
end
function CheckForSilverGathered()
	if (Logic.GetPlayersGlobalResource(1, ResourceType.Silver) + Logic.GetPlayersGlobalResource(1, ResourceType.SilverRaw) >= 5000)
	and (Logic.GetPlayersGlobalResource(1, ResourceType.Gold) + Logic.GetPlayersGlobalResource(1, ResourceType.GoldRaw) >= 250000) then
		Message("Ihr habt jede Menge Taler und Silber gescheffelt. Herzlichen Glückwunsch!")
		GDB.SetValue("achievements\\northernseasilver", 1)
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

