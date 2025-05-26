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
	Start()
	Truhen()
	LocalMusic.UseSet = DARKMOORMUSIC
	gvDayCycleStartTime = Logic.GetTime()
	TagNachtZyklus(24,0,1,(2-gvDiffLVL),1)
end
function FarbigeNamen()
	orange 	= "@color:255,127,0 "
	lila 	= "@color:250,0,240 "
	weiss   = "@color:255,255,255 "

	ker  	= ""..orange.." Kerberos "..lila..""
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
	--**
	do
		local pos = GetPosition("LighthouseDefend")
		for i = 1,6 do
			CreateMilitaryGroup(7,Entities.PU_LeaderBow4,12,{X = pos.X - i*50, Y = pos.Y - i*50},"LGuard_Bow"..i)
			CreateMilitaryGroup(7,Entities.PU_LeaderCavalry2,6,{X = pos.X + i*50, Y = pos.Y + i*50},"LGuard_Cav"..i)
			Logic.GroupPatrol(GetID("LGuard_Bow"..i), 61300-i*30, 30600-i*30)
			Logic.GroupPatrol(GetID("LGuard_Cav"..i), 61300+i*30, 30600+i*30)
		end
	end
	do
		local pos = GetPosition("Barbaren")
		for i = 1,5 do
			CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub2,8,{X = pos.X - i*50, Y = pos.Y - i*50},"VargGuard_Sword"..i)
			CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X + i*50, Y = pos.Y + i*50},"VargGuard_Elite"..i)
			Logic.GroupPatrol(GetID("VargGuard_Elite"..i), 40900-i*30, 51900-i*30)
			Logic.GroupPatrol(GetID("VargGuard_Sword"..i), 40900+i*30, 51900+i*30)
		end
	end
	do
		local pos = GetPosition("VargHQDefense")
		for i = 1,7 do
			CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub2,8,{X = pos.X - i*50, Y = pos.Y - i*50},"VargHQGuard_Sword"..i)
			CreateMilitaryGroup(6,Entities.CU_VeteranLieutenant,4,{X = pos.X + i*50, Y = pos.Y + i*50},"VargHQGuard_Elite"..i)
			Logic.GroupPatrol(GetID("VargHQGuard_Elite"..i), 55000-i*30, 7400-i*30)
			Logic.GroupPatrol(GetID("VargHQGuard_Sword"..i), 55000+i*30, 7400+i*30)
		end
	end
	CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderSword3,6,GetPosition("Barbaren"),"EliteSword")
	local posX, posY = Logic.GetEntityPosition(GetID("VargHaupt"))
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
		DarioQuest()

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

function DarioQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Errichtet euer Lager",
		text	= "Sucht euch einen geeigneten Platz zum Siedeln und unterstützt dann die Nordfeste im Kampf gegen Kerberos und Varg.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	DarQuest = quest.id
end
function KerQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
		title	= "Kerberos",
		text	= "Vernichtet Kerberos Truppen und nehmt dann Kerberos in Gefangenschaft.",
	}
	Logic.AddQuest(1, quest.id, quest.type, quest.title, quest.text,1)
	KeQuest = quest.id
end
function VarQuest()
	quest	= {
		id		= GetQuestId(),
		type	= SUBQUEST_OPEN,
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
		ASP("Erec",er,"Sobald sich die Verteidigung stabilisiert hat, sollten wir in den Angriff übergehen und zunächst die Außenposten von Kerberos und Varg vernichten.", false)
		AP{
			title = er,
			text = "Kerberos Außenposten befindet sich gut geschützt an dieser Stelle. @cr Unsere Späher haben saubere Arbeit geleistet.",
			position = GetPosition("KerberosBurg"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}
		AP{
			title = er,
			text = "Die von Varg war da schon ein wenig umständlicher zu finden. @cr Sie liegt weit oben in den Kralbergen und ist nur über einen schmalen Pfad zu erreichen.",
			position = GetPosition("VargHaupt"),
			marker = STATIC_MARKER,
			dialogCamera = false,
		}

		ASP("Erec",er,"Ich werde euch im Kampf eigenhändig zur Seite stehen.", true)
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
			ChangePlayer("Erec",1)
			QuestSieg()
			KerQuest()
			VarQuest()
			ActivateShareExploration( 1,5, true )
			EnableNpcMarker(GetEntityId("Reiter"))
			EnableNpcMarker(GetEntityId("Farmer"))
			EnableNpcMarker(GetEntityId("scout"))
			EnableNpcMarker(GetEntityId("monk"))
			EnableNpcMarker(GetEntityId("thief"))
			EnableNpcMarker(GetEntityId("miner"))
			EnableNpcMarker(GetEntityId("trader"))
			Reiter()
			Farmer()
			Scout()
			Monk()
			Thief()
			Miner()
			Trader()
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
function Vorbereitung()
    StartSimpleJob("VictoryJob_Step1")
    StartSimpleJob("Ruinen")
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
			Move("Kerb","KerberosBaseSpawn")
		end

    }

    StartBriefing(briefing)
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
			Move("Varg","VargCave")
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
			army.strength = round(12/gvDiffLVL)
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
function Reiter()
	local BeiRei = {
	--EntityName = "Dario",
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
  		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiRei)
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
	--EntityName = "Dario",
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
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMo)
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
	UpgradeBuilding("monastery_p5")
	StartSimpleJob("P5MonasteryUpgradeDone")
end
function P5MonasteryUpgradeDone()
	if Logic.GetPlayerEntities(5, Entities.PB_Monastery3, 1) > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP("monk",mon,"Habt Dank! @cr Bleibt doch bitte für die Predigt.", true)
		ASP("Dario",dario,"Tut mir leid, aber ich muss weiter. @cr So gerne ich hier verweilen würde, ich habe noch Aufgaben zu erledigen.", false)
		ASP("monk",mon,"Nun, das kann ich verstehen. @cr Gott sei mit Euch. @cr @cr Ich bin überzeugt, dass diese prunkvolle Kathedrale die Kampfkraft der Menschen hier stärken wird.", true)
		briefing.finished = function()
			MapEditor_Armies[5].offensiveArmies.strength = MapEditor_Armies[5].offensiveArmies.strength + round(gvDiffLVL)
		end;
		StartBriefing(briefing)
		return true
	end
end
function Scout()
	local BeiSc = {
	--EntityName = "Dario",
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
			StartSimpleJob("ControlSupplyFire")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiSc)
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
end
function Thief()
	local BeiThi = {
	--EntityName = "Dario",
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
			TributeSappeur()
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiThi)
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
		ASP("miner",mi,"Dieses ständige schlechte Wetter geht mir auf die Nerven. @cr Ich bin hier doch nicht in England!", false)
		ASP("claymine",mi,"Ich kann gar nicht verstehen, was meine Kollegen so toll daran finden, tagein, tagaus in dieser schlammigen Lehmgrube zu ackern wie ein Tier.", false)
		ASP("miner",mi,"Versteht mich nicht falsch, ich bin gerne Bergmann. @cr Aber ich wäre gerne nicht ständig der Witterung ausgesetzt.", false)
		ASP("miner",mi,"Ich hatte mal gehört, dass man tief im Berginneren Kohle abbauen kann. @cr Das wäre doch etwas.", false)
		ASP("mount",mi,"Die Bergflanke nördlich von hier eignet sich doch bestimmt bestens dafür. @cr Seid so gut, und errichtet dort ein Kohlebergwerk.", false)
		briefing.finished = function()
			StartSimpleJob("Built_Coalmine")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiMin)
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
	--EntityName = "Dario",
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
			StartSimpleJob("MarketBuiltJob")
		end;
		StartBriefing(briefing)
	end}
	SetupExpedition(BeiTr)
end
function MarketBuiltJob()
	local num, id = Logic.GetPlayerEntities(1, Entities.PB_Market3, 1)
	if num > 0 then
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		ASP(id,tra,"Habt Dank. @cr Habt Dank. @cr Ich werde mich direkt auf den Weg machen.", true)
		ASP("trader",tra,"Kommt mich jederzeit besuchen und schauet meine Waren. @cr Ach und nehmt dies als Zeichen meiner Dankbarkeit. @cr Die Waren bin ich sowieso nicht losgeworden in dieser Stadt.", false)
		briefing.finished = function()
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
	--EntityName = "Dario",
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
			TributeCoal1()
			NumCoalTributePaid = 1
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

--**
function QuestSieg()
	quest	= {
	id		= GetQuestId(),
	type	= SUBQUEST_OPEN,
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
			ASP("Pilgrim",pil,"Sorry Dario, aber hör bitte einfach auf, über beschwerliche Wege zu reden, lass uns einfach FEIIIEERN!!!!", false)
			ASP("Outpost_Ruin",ment,"Pilgrim war zwar bereits hackedicht voll, dies hinderte ihn und seine Freunde allerdings nicht daran, bis tief in die Nacht zu feiern.", false)
			ASP("Outpost_Ruin",dario,"Mir kommt da grad noch so eine Idee. Nachbardörfer im Kralgebirge werden vom Nebelvolk und Banditen heimgesucht.", true)
			ASP("Outpost_Ruin",dario,"Lasst uns doch mal dort vorbeischauen und ihnen helfen, wir sind sowieso in der Nähe. Zeit für die Heimreise haben wir noch genug.", true)
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
		ASP("Extra",ment,"Was ist das? Banditen stürzen aus den Höhlen und versuchen, die Nordfeste zu zerstören.", false)
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

function Ruinen()
	if IsDestroyed("Ruin_2") then
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		return true
	end
	if IsDestroyed("Ruin_3") then
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		return true
	end
	if IsDestroyed("Ruin_8") then
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		return true
	end
	if IsDestroyed("Ruin_9") then
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		return true
	end
	if IsDestroyed("Ruin_0") then
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		CreateMilitaryGroup(8,Entities.CU_VeteranLieutenant,4,GetPosition("Ruinspawn"))
		return true
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
	ChestSurprise(8, GetPosition("TrBan"), round(4/gvDiffLVL))
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

