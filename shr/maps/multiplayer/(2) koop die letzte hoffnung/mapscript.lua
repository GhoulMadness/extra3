----------------------------------------------------------------------------------------------------
-- MapName: (2) Die letzte Hoffnung
-- Author: Play4FuN
-- Date: 17.03.2022
-- MP Server Version
----------------------------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Die letzte Hoffnung "
gvMapVersion = " v1.03"

-- to avoid problems on Kimichura's MP Server this must be called inside GameCallback_OnGameStart
function LoadAllTheScripts()

	do
		-- local path = "maps\\user\\"
		local path = "Data\\Maps\\ExternalMap\\"

		Script.Load( path.."p4f_tools.lua" )
		Script.Load( path.."p4f_comforts_general.lua" )
		Script.Load( path.."p4f_questtools_mp.lua" )
		Script.Load( path.."p4f_comforts_mpcoop.lua" )
		Script.Load( path.."triggerfix.lua" )
	end

end

----------------------------------------------------------------------------------------------------

if XNetwork then
	XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
	XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end

----------------------------------------------------------------------------------------------------

HeroTable = {}	-- for NPCs

pAI = {}
pAI[4] = {}
pAI[6] = {}
pAI[7] = {}


-- quest IDs
QUEST_MAINQUEST_1	= 1
QUEST_MAINQUEST_2	= 2
QUEST_CITYQUEST_1	= 3
QUEST_CITYQUEST_2	= 4
QUEST_DEFEATENEMIESQUEST_1 = 5
QUEST_DEFEATENEMIESQUEST_2 = 6
QUEST_MAPINFORMATION_1 = 7
QUEST_MAPINFORMATION_2 = 8

-- note: MovieWindow title: orange for missions; light blue for NPCs
-- quest texts
QUEST_TEXT_DEFENDVILLAGE = "Verteidigt die Siedlung: Besiegt alle Angreifer!"
QUEST_TEXT_BUILDVC = "Bringt Leben in Eure Siedlung: Errichtet ein Dorfzentrum!"
QUEST_TEXT_DESTROYTENTS = "Vergeltungsschlag: Findet und zerstört das Lager der Angreifer!"
QUEST_TEXT_DESTROYCAMPSOUTH = "Ein weiteres Lager befindet sich in Eurer Nähe. Besiegt alle Gegner!"
--QUEST_TEXT_PROTECTENTRANCES = "Augen auf: @cr Schickt Eure Helden an die Eingänge des Tals!"
QUEST_TEXT_BUILDSETTLEMENT = "Siedlungsaufbau: Erreicht 40 Arbeiter in Eurer Siedlung. Versorgt sie mit Wohnungen und Nahrung!"
QUEST_TEXT_BUILDHOUSEANDFARM = "Bergarbeiter anwerben: Baut den Kumpel ein Wohnhaus und einen Bauernhof neben die Eisengrube!"
QUEST_TEXT_FIGHTOFFWOLVES = "Bergarbeiter beschützen: Bereinigt das Gebiet von wilden Wölfen, die sich in den nahegelegenen Wäldern verstecken!"
QUEST_TEXT_SETUPARMY = "Hebt eine schlagkräftige Armee aus, um Euch der Stadt gegenüber zu beweisen!"
--QUEST_TEXT_SACKCITY = "Zerstört die 4 Außenposten der Stadt! Verschont die Bewohner so gut es geht!"
QUEST_TEXT_DEFENDCITY = "Verteidigt die Stadt! Sendet Truppen zu jedem der vier oberen Stadttore!"
QUEST_TEXT_BUILDTOWERS = "Verteidigungstürme errichten: Sorgt dafür, dass an jedem der 4 Stadttore mindestens 3 Ballistatürme stehen!"
QUEST_TEXT_DESTROYMAGICMACHINE = "Kanonentürme: Zerstört die seltsame Maschine, mit denen die Kanonentürme geschützt werden!"
QUEST_TEXT_FOODSUPPLY = "Nahrungslieferung: Helft der Stadt ihre Vorratskammern wieder aufzufüllen und besorgt Nahrungsmittel!"
--QUEST_TEXT_BUILDHORSESTATUES = "Pferdezucht: Errichtet Reiterstatuen, um den Ordensritter zu überzeugen!"

----------------------------------------------------------------------------------------------------
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	LoadAllTheScripts()

	-- minimap buttons -> quests
	XGUIEng.SetWidgetSize("MinimapButtons_Normal", 18, 18)
	XGUIEng.SetWidgetSize("MinimapButtons_Resource", 18, 18)
	XGUIEng.SetWidgetSize("MinimapButtons_Tactic", 18, 18)
	StartCountdown( 2, DelayedTransferMaterials )

	gvMission = gvMission or {}
	gvMission.PlayerID = GUI.GetPlayerID()

	StartTechnologies()

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end

	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()


	--Init local map stuff
	TagNachtZyklus(24,1,0,-2,1)
	ActivateBriefingsExpansion()

	-- do not activate shared exploration at game start:
	-- must be called before SetUpGameLogicOnMPGameConfig
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig = function() end

	-- Init  global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )

		-- no second player here? give it all to the human player
		Logic.ChangeAllEntitiesPlayerID(1, PlayerID)
		-- TODO: suspend needed again since IDs change
		Logic.ChangeAllEntitiesPlayerID(2, PlayerID)

		NewOnGameLoaded()

		-- heroes in SP mode
		--Logic.SetNumberOfBuyableHerosForPlayer(1, 6)
		GUIUpdate_BuyHeroButton = function()
			if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) > 0 then	-- display button as long as heroes can be bought
				XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),1)
			else
				XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),0)	-- hide it
			end
		end

		gvMission.singleplayerMode = true
	end

	-- map stuff

	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player

end
function TributeP1_Easy()
	local TrP1_I =  {}
	TrP1_I.playerId = 1
	TrP1_I.text = "Klickt hier, um den @color:60,200,60 leichten @color:255,255,255 Spielmodus zu spielen"
	TrP1_I.cost = { Gold = 0 }
	TrP1_I.Callback = TributePaid_P1_Easy
	TP1_I = AddTribute(TrP1_I)
end
function TributeP1_Normal()
	local TrP1_N =  {}
	TrP1_N.playerId = 1
	TrP1_N.text = "Klickt hier, um den @color:200,115,90 normalen @color:255,255,255 Spielmodus zu spielen"
	TrP1_N.cost = { Gold = 0 }
	TrP1_N.Callback = TributePaid_P1_Normal
	TP1_N = AddTribute(TrP1_N)
end
function TributeP1_Hard()
	local TrP1_H =  {}
	TrP1_H.playerId = 1
	TrP1_H.text = "Klickt hier, um den @color:200,60,60 schweren @color:255,255,255 Spielmodus zu spielen"
	TrP1_H.cost = { Gold = 0 }
	TrP1_H.Callback = TributePaid_P1_Hard
	TP1_H = AddTribute(TrP1_H)
end
--
function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:60,200,60 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 3
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:60,200,60 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_I)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	gvDiffLVL = 2
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_I)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 0 )
	gvDiffLVL = 1
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function PrepareForStart()
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
	end
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
    -- Init local map stuff
	Misc()	-- must be called before most of the other stuff

	SetupDiplomacy()
	Mission_InitGroups()

--	StartSimpleJob("VictoryJob")
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")

	Mission_InitLocalResources()
	Mission_InitTechnologies()

	StartFirstChapter()
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function DelayedTransferMaterials()
	XGUIEng.TransferMaterials("MainMenuSaveScrollUp", "MinimapButtons_Normal")
	XGUIEng.TransferMaterials("Hero10_SniperAttack", "MinimapButtons_Resource")	--WorkerBackToBuilding
	XGUIEng.TransferMaterials("MainMenuSaveScrollDown", "MinimapButtons_Tactic")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Debug_ShowArmyPos(_army)
	local enemyId = AI.Army_GetEntityIdOfEnemy(_army.player,_army.id)
	if enemyId ~= 0 then
		local position = GetPosition(enemyId)
		GUI.ScriptSignal(position.X, position.Y, 1)	-- blue
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitGroups()
	CreateMilitaryGroup(1, Entities.PU_LeaderSword1, 4, GetPosition("posSuppP1a"))
	CreateMilitaryGroup(1, Entities.PU_LeaderPoleArm1, 4, GetPosition("posSuppP1b"))
	local player2 = 2
	if XNetwork.Manager_DoesExist() == 0 then
		player2 = 1
		AddGold(1, dekaround(300*gvDiffLVL))
	end
	CreateMilitaryGroup(player2, Entities.PU_LeaderSword1, 4, GetPosition("posSuppP2a"))
	CreateMilitaryGroup(player2, Entities.PU_LeaderPoleArm1, 4, GetPosition("posSuppP2b"))

	for i = 1, 10 do
		Tools.CreateSoldiersForLeader(GetEntityId("bandit"..i), 4)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()

	for i = 1, 2 do
		-- game progress will unlock technologies...
		--ForbidTechnology(Technologies.UP1_University, i)	-- ?
		--ForbidTechnology(Technologies.UP1_Village, i)		-- ?
		--ForbidTechnology(Technologies.UP2_Headquarter, i)
		--ForbidTechnology(Technologies.B_Barracks, i)
		--ForbidTechnology(Technologies.B_Tower, i)
		ForbidTechnology(Technologies.UP2_Village, i)
		ForbidTechnology(Technologies.UP2_Tower, i)
		ForbidTechnology(Technologies.B_Bridge, i)
		ForbidTechnology(Technologies.B_MasterBuilderWorkshop, i)
		ForbidTechnology(Technologies.B_Archery, i)			-- unlocks later
		ForbidTechnology(Technologies.B_Foundry, i)			-- can buy
		ForbidTechnology(Technologies.B_Stables, i)			-- can buy
		ForbidTechnology(Technologies.B_Mercenary, i)			-- can buy

		--ForbidTechnology(Technologies.B_Weathermachine, i)	-- no weather change
		--ForbidTechnology(Technologies.B_PowerPlant, i)		-- no weather change
		--ForbidTechnology(Technologies.T_ChangeWeather, i)		-- no weather change
		--ForbidTechnology(Technologies.T_WeatherForecast, i)	-- no weather change

		ForbidTechnology(Technologies.MU_Thief, i)			-- unlocks in the second/third chapter

		ForbidTechnology(Technologies.UP1_Market, i)		-- unlocks when a bandit camp has been destroyed = trade route free

		--ResearchTechnology(Technologies.T_TownGuard, i)	-- update: replaced by T_CityGuard (1s research time, 100 clay cost)
	end

	InitTechTables()	-- for AI players
end

-------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitLocalResources()

	local InitGoldRaw 		=  dekaround(600*gvDiffLVL)
	local InitClayRaw 		=  dekaround(600*gvDiffLVL)
	local InitWoodRaw 		=  dekaround(600*gvDiffLVL)
	local InitStoneRaw 		=  dekaround(400*gvDiffLVL)
	local InitIronRaw 		=  0
	local InitSulfurRaw		=  0

	for i = 1, 2	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Misc()

	MPQuest_Init()
	GUIAction_ToggleMinimap = function(_index)
		if _index == 0 then	-- 1st/normal
			MPQuest_CycleNextQuest(gvMission.PlayerID, true)	-- cycle reverse
		elseif _index == 1 then	-- 3rd
			MPQuest_CycleNextQuest(gvMission.PlayerID, false)	-- cycle normal
		else	-- 2nd
			local activeQuest = MPQuest_GetActivePlayerQuest(gvMission.PlayerID)
			if activeQuest then
				local pos = MPQuest_GetPosition(activeQuest.id)
				if pos then
					Camera.ScrollSetLookAt(pos.X, pos.Y)
				end
			end
		end
	end

	GUIUpdate_BuildingButtons_Orig = GUIUpdate_BuildingButtons
	GUIUpdate_BuildingButtons = function(_button, _tech)
		if _button == "MinimapButtons_Normal"
		or _button == "MinimapButtons_Resource"
		or _button == "MinimapButtons_Tactic" then
			if MPQuest_GetNumberOfPlayerQuests(gvMission.PlayerID) == 0 then
				XGUIEng.DisableButton("MinimapButtons_Normal", 1)
				XGUIEng.DisableButton("MinimapButtons_Resource", 1)
				XGUIEng.DisableButton("MinimapButtons_Tactic", 1)
			else
				XGUIEng.DisableButton("MinimapButtons_Normal", 0)
				XGUIEng.DisableButton("MinimapButtons_Resource", 0)
				XGUIEng.DisableButton("MinimapButtons_Tactic", 0)
			end
		else
			GUIUpdate_BuildingButtons_Orig(_button, _tech)
		end
	end

	GUITooltip_ResearchTechnologies_OrigQuests = GUITooltip_ResearchTechnologies
	GUITooltip_ResearchTechnologies = function(_tech, _widget, _keybind)
		if _tech == Technologies.T_MinimapNormalView then
			XGUIEng.SetText("TooltipBottomShortCut", " ")
			XGUIEng.SetText("TooltipBottomCosts", " ")
			XGUIEng.SetText("TooltipBottomText", (col.grau.."Vorherige Aufgabe"..col.w.."@cr Seht Euch die vorherige Aufgabe an."))
		elseif _tech == Technologies.T_MinimapResouceView then
			XGUIEng.SetText("TooltipBottomShortCut", " ")
			XGUIEng.SetText("TooltipBottomCosts", " ")
			XGUIEng.SetText("TooltipBottomText", (col.grau.."Zur Aufgabenposition springen"..col.w.."@cr Springt zu der Aufgabenposition, sofern vorhanden."))
		elseif _tech == Technologies.T_MinimapTacticView then
			XGUIEng.SetText("TooltipBottomShortCut", " ")
			XGUIEng.SetText("TooltipBottomCosts", " ")
			XGUIEng.SetText("TooltipBottomText", (col.grau.."Nächste Aufgabe"..col.w.."@cr Seht Euch die nächste Aufgabe an."))
		else
			GUITooltip_ResearchTechnologies_OrigQuests(_tech,_widget,_keybind)
		end
	end

	InitColors()
	P4FComforts_SelectionFix()
	P4FComforts_UpgradeHints()
	P4FComforts_MarketInfo()
	P4FComforts_HeroHealthDisplay()
	P4FComforts_RemoveDroppedEntities()
	P4FComforts_CreateDecalsForResourcePiles()
	P4FComforts_EnhancedMusic()
	P4FComforts_EnableGlobalTroopSelection()

	InitChests()

	LocalMusic.UseSet = EUROPEMUSIC

	-- LocalMusic.SetEurope["summer"] = {{ "40_Extra1_BridgeBuild.mp3", 129 }, { "01_MainTheme1.mp3", 152 }, { "02_MainTheme2.mp3", 127 }, { "06_MiddleEurope_Summer1.mp3", 149 },
		-- { "07_MiddleEurope_Summer2.mp3", 165 }, { "08_MiddleEurope_Summer3.mp3", 168 }, { "09_MiddleEurope_Summer4.mp3", 160 }, { "10_MiddleEurope_Summer5.mp3", 158 },
		-- { "11_MiddleEurope_Summer6.mp3", 153 }, { "12_MiddleEurope_Summer7.mp3", 155 }, { "13_MiddleEurope_Summer8.mp3", 156 }, { "14_MiddleEurope_Summer9.mp3", 138 },
		-- { "15_Mediterranean_Summer1.mp3", 165 }, { "16_Mediterranean_Summer2.mp3", 142 }, { "17_Highland_Summer1.mp3", 150 }, { "18_Highland_Summer2.mp3", 137 }}

	LocalMusic.SetBattle = {{"03_CombatEurope1.mp3", 117}, {"43_Extra1_DarkMoor_Combat.mp3", 120}, {"04_CombatMediterranean1.mp3", 113}, {"05_CombatEvelance1.mp3", 117}}
	LocalMusic.SetEvilBattle = {{"43_Extra1_DarkMoor_Combat.mp3", 120}, {"05_CombatEvelance1.mp3", 117}, {"04_CombatMediterranean1.mp3", 113}, {"03_CombatEurope1.mp3", 117}}

	Logic.SetNumberOfBuyableHerosForPlayer(1, 2)
	Logic.SetNumberOfBuyableHerosForPlayer(2, 2)

	-- (not only NPC) movie window (text)
	gvMission.MovieWindow = {active = false, text = "", counter = 0, limit = 0}
	StartSimpleJob("SJ_MovieWindow")

	-- NPCs
	MP_InitNPCs()

	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, nil, "EV_ON_ENTITY_HURT", 1)

	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, nil, "EV_ON_ENTITY_CREATED", 1)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function StartFirstChapter()

	-- shared exploration is not enabled for now
	MPTools_ExploreArea(1, "HQP2", 2800)
	MPTools_ExploreArea(2, "HQP1", 2800)

	local pos = GetPos("posHQP4")
	MPTools_ExploreArea(1, pos, 3000)
	MPTools_ExploreArea(2, {X = pos.X + 1, Y = pos.Y + 1}, 3000)
	GUI.CreateMinimapPulse(pos.X, pos.Y, 0)	-- green
	MovieWindow_Start(1, col.orange.."Mission", "Der Bürgermeister der Stadt"..col.hgruen.."Flechtingen"..col.w.."hat vor einigen Tagen von heftigen Angriffen auf seine Stadt berichtet."..
	" Seitdem haben wir nichts mehr von ihm gehört. Wir müssen davon ausgehen, dass sich die Stadt in großer Gefahr befindet. Errichtet Eure Siedlung und begebt Euch nach"..col.hgruen.."Flechtingen!", 17)
	MovieWindow_Start(2, col.orange.."Mission", "Der Bürgermeister der Stadt"..col.hgruen.."Flechtingen"..col.w.."hat vor einigen Tagen von heftigen Angriffen auf seine Stadt berichtet."..
	" Seitdem haben wir nichts mehr von ihm gehört. Wir müssen davon ausgehen, dass sich die Stadt in großer Gefahr befindet. Errichtet Eure Siedlung und begebt Euch nach"..col.hgruen.."Flechtingen!", 17)

	MakeStartBuildingsUnselectable()

	InitBanditCamps()

	-- custom quests
	StartCountdown( 2, InitQuest_DefendVillage_P1 )

	if not gvMission.singleplayerMode then
		StartCountdown( 2, InitQuest_DefendVillage_P2 )
	end
	StartCountdown(18, PlayGetWeaponsSound, false)

	-- attack settelements - 1
	AttackSettlement1 = function()
		if Counter.Tick2("tick_attackingBandits1", 15) then
			if AreAllDead({"bandit1", "bandit2", "bandit3"}) then return true end
			for i = 1, 3 do
				if IsAlive("bandit"..i) then Attack("bandit"..i, "posIntro1") end
			end
		end
	end
	-- 2
	AttackSettlement2 = function()
		if Counter.Tick2("tick_attackingBandits2", 15) then
			if AreAllDead({"bandit4", "bandit5", "bandit6"}) then return true end
			for i = 4, 6 do
				if IsAlive("bandit"..i) then Attack("bandit"..i, "posIntro2") end
			end
		end
	end
	StartSimpleJob("AttackSettlement1")
	StartSimpleJob("AttackSettlement2")

	InitWolves()	-- for a (optional) quest

	-- give quests
	StartCountdown(2, SetupQuest_Main, false)

	-- first merc offers
	Logic.AddMercenaryOffer(GetEntityId("merc1"), Entities.PV_Cannon2, 4, ResourceType.Sulfur, 200)

	-- inform players about walls being indestructable except for cannons
	WallsHint = function()
		local Position = GetPos("posWallSouth")
		if Logic.IsMapPositionExplored(1, Position.X, Position.Y) == 1
		or Logic.IsMapPositionExplored(2, Position.X, Position.Y) == 1 then
			--Briefing_InfoWalls()
			MovieWindow_Start(1, col.orange.."Mauern", "... können nur durch Kanonen beschädigt werden! Eure Schwerter und Bögen sind dagegen machtlos.", 13)
			MovieWindow_Start(2, col.orange.."Mauern", "... können nur durch Kanonen beschädigt werden! Eure Schwerter und Bögen sind dagegen machtlos.", 13)
			local pos = GetPos("posWallSouth")
			GUI.ScriptSignal(pos.X, pos.Y, 2)	-- white
			--Camera.ScrollSetLookAt(pos.X, pos.Y)
			return true
		end
	end
	StartSimpleJob("WallsHint")

	-- actually needed later, but to be sure
	gvMission.superTowersActive = true
	for i = 1, 14 do
		CreateSuperTower("sTower"..i)
	end

	MakeInvulnerable("magicMachine")

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayGetWeaponsSound()
	Sound.PlayGUISound(Sounds.VoicesMentor_ALARM_GetWeapons, 100)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function MP_InitNPCs()
	if gvMission.singleplayerMode then
		DestroyEntity("scout1")
		DestroyEntity("scout2")
	else
		CreateNpcMP("scout1", TalkToScout1, 1)	-- new: only allow heros of a certain player to interact (nil = any player)
		CreateNpcMP("scout2", TalkToScout2, 2)
	end

	-- CreateNpcMP("npcEngineer", TalkToEngineer, nil)	-- engineer at the telescope (riddle: "Sternbilder")

	CreateNpcMP("npcMiner1", TalkToMiner1, 1)	-- miner southwest (iron mine, build)
	if gvMission.singleplayerMode then
		CreateNpcMP("npcMiner2", TalkToMiner2, 1)	-- miner southeast (iron mine, kill)
	else
		CreateNpcMP("npcMiner2", TalkToMiner2, 2)	-- miner southeast (iron mine, kill)
	end
	--CreateNpcMP("npcMiner3", TalkToMiner3, {1, 2})	-- miner south (sulfur mine, buy); create later (when big bandit camps are destroyed)

	CreateNpcMP("support1", TalkToSupportTroop1, nil)
	CreateNpcMP("support2", TalkToSupportTroop2, nil)

	CreateNpcMP("npcMerc1", TalkToMerc1, nil)
	CreateNpcMP("npcMerc2", TalkToMerc2, nil)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- merc 1 (wood)
function TalkToMerc1(_player)
	MovieWindow_Start(_player, col.hblau.."Händler", "Seid gegrüßt, Reisende. Habt Ihr zufällig gutes Holz, welches Ihr mir verkaufen würdet?"..
		" @cr Ich zahle gute Preise.", 11)
	AddTribute({ playerId = _player, text = ("Verkauft dem Händler ".. dekaround(3200/gvDiffLVL) .." Holz für 1000 Eisen."), cost = { Wood = dekaround(3200/gvDiffLVL) }, Callback = AcceptTrade1_Merc1 })
	AddTribute({ playerId = _player, text = ("Verkauft dem Händler ".. dekaround(4000/gvDiffLVL) .." Holz für 1200 Steine."), cost = { Wood = dekaround(4000/gvDiffLVL) }, Callback = AcceptTrade2_Merc1 })
	gvMission.merc1Player = _player
end

function AcceptTrade1_Merc1()
	AddIron(gvMission.merc1Player, 1000)
	AddTribute({ playerId = gvMission.merc1Player, text = ("Verkauft dem Händler ".. dekaround(6400/gvDiffLVL) .." Holz für 2000 Eisen."), cost = { Wood = dekaround(6400/gvDiffLVL) }, Callback = AcceptTrade3_Merc1 })
	--PlayTributeSoundForPlayer(gvMission.merc1Player)
end

function AcceptTrade2_Merc1()
	AddStone(gvMission.merc1Player, 1200)
	AddTribute({ playerId = gvMission.merc1Player, text = ("Verkauft dem Händler ".. dekaround(8000/gvDiffLVL) .." Holz für 2400 Steine."), cost = { Wood = dekaround(8000/gvDiffLVL) }, Callback = AcceptTrade4_Merc1 })
	--PlayTributeSoundForPlayer(gvMission.merc1Player)
end

function AcceptTrade3_Merc1()
	AddIron(gvMission.merc1Player, 2000)
	--PlayTributeSoundForPlayer(gvMission.merc1Player)
end

function AcceptTrade4_Merc1()
	AddStone(gvMission.merc1Player, 2400)
	--PlayTributeSoundForPlayer(gvMission.merc1Player)
end

-- merc2 (clay)
function TalkToMerc2(_player)
	MovieWindow_Start(_player, col.hblau.."Händler", "Seid gegrüßt, Reisende. Habt Ihr zufällig hochwertiges Lehm, welches Ihr mir verkaufen würdet?"..
		" @cr Ich zahle gute Preise.", 11)
	AddTribute({ playerId = _player, text = ("Verkauft dem Händler ".. dekaround(2800/gvDiffLVL) .." Lehm für 1000 Eisen."), cost = { Clay = dekaround(2800/gvDiffLVL) }, Callback = AcceptTrade1_Merc2 })
	AddTribute({ playerId = _player, text = ("Verkauft dem Händler ".. dekaround(3200/gvDiffLVL) .." Lehm für 1200 Steine."), cost = { Clay = dekaround(3200/gvDiffLVL) }, Callback = AcceptTrade2_Merc2 })
	gvMission.merc2Player = _player
end

function AcceptTrade1_Merc2()
	AddIron(gvMission.merc2Player, 1000)
	AddTribute({ playerId = gvMission.merc2Player, text = ("Verkauft dem Händler ".. dekaround(2*2800/gvDiffLVL) .." Lehm für 2000 Eisen."), cost = { Clay = dekaround(2*2800/gvDiffLVL) }, Callback = AcceptTrade3_Merc2 })
	--PlayTributeSoundForPlayer(gvMission.merc2Player)
end

function AcceptTrade2_Merc2()
	AddStone(gvMission.merc2Player, 1200)
	AddTribute({ playerId = gvMission.merc2Player, text = ("Verkauft dem Händler ".. dekaround(2*3200/gvDiffLVL) .." Lehm für 2400 Steine."), cost = { Clay = dekaround(2*3200/gvDiffLVL) }, Callback = AcceptTrade4_Merc2 })
	--PlayTributeSoundForPlayer(gvMission.merc2Player)
end

function AcceptTrade3_Merc2()
	AddIron(gvMission.merc2Player, 2000)
	--PlayTributeSoundForPlayer(gvMission.merc2Player)
end

function AcceptTrade4_Merc2()
	AddStone(gvMission.merc2Player, 2400)
	--PlayTributeSoundForPlayer(gvMission.merc2Player)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitPlayer4()
	Logic.SetPlayerPaysLeaderFlag(4, 0)
	AI.Player_EnableAi(4)
	AI.Village_SetSerfLimit(4, 8)
	AI.Village_EnableRepairing(4, 1)
	AI.Village_EnableExtracting(4, false)

	--pAI[4] = {}
	pAI[4].armys = {}
	for i = 1, 4 do
		pAI[4].armys[i] = {
		player = 4,
		id = i,
		strength = 4,
		position = GetPos("posGate"..i.."P4"),	--GetPos("posHQP4"),	-- NOT spawn location anymore
		rodeLength = 2000,
		--attackPosition = GetPos("posGate"..i.."P4"),	-- attack target area
		defensePosition = GetPos("posGate"..i.."P4"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderSword2, position = GetPos("posHQP4")},
		}
		SetupArmy(pAI[4].armys[i])
	end
	-- (inner) defensive army
	pAI[4].armys[5] = {
		player = 4,
		id = 5,
		strength = 4,
		position = GetPos("posHQP4"),	-- NOT spawn location anymore
		rodeLength = 4400,
		defensePosition = GetPos("posHQP4"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderBow2, position = GetPos("posHQP4")},
	}
	SetupArmy(pAI[4].armys[5])

	ControlArmyP4 = function()
		if Counter.Tick2("ArmyControllerP4", 6) then
			for i = 1, 5 do
				local army = pAI[4].armys[i]
				if IsDead(army) and IsAlive("HQP4") then
					for i = 1, army.strength do
						EnlargeArmy(army, army.troopDescription)
					end

					Redeploy(army, army.defensePosition)
				else
					Defend(army)
				end
			end
		end
	end
	StartSimpleJob("ControlArmyP4")
end

function InitPlayer6()
	Logic.SetPlayerPaysLeaderFlag(6, 0)
	AI.Player_EnableAi(6)
	AI.Village_SetSerfLimit(6, 8)
	AI.Village_EnableRepairing(6, 1)
	AI.Village_EnableExtracting(6, false)

	--pAI[6] = {}
	pAI[6].armys = {}
	pAI[6].armys[1] = {
		player = 6,
		id = 1,
		strength = 4,
		position = GetPos("posHQP6"),	-- not spawn location
		rodeLength = 2500,
		attackPosition = GetPos("posGate1P4"),	-- attack target area
		beAgressive = true,
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = MEDIUM_EXPERIENCE, leaderType = Entities.PU_LeaderSword1, position = GetPos("posHQP6")},
	}
	SetupArmy(pAI[6].armys[1])
	--AI.Army_SetScatterTolerance(6, 1, 0)

	pAI[6].armys[2] = {
		player = 6,
		id = 2,
		strength = 4,
		position = GetPos("posHQP6"),	-- not spawn location
		rodeLength = 2500,
		attackPosition = GetPos("posGate4P4"),	-- attack target area
		beAgressive = true,
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = MEDIUM_EXPERIENCE, leaderType = Entities.PU_LeaderPoleArm1, position = GetPos("posHQP6")},
	}
	SetupArmy(pAI[6].armys[2])
	--AI.Army_SetScatterTolerance(6, 2, 4)

	-- defensive armys
	pAI[6].armys[3] = {
		player = 6,
		id = 3,
		strength = 4,
		position = GetPos("posHQP6"),	-- also spawn location
		rodeLength = 1500,
		defensePosition = GetPos("posHQP6"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderBow2, position = GetPos("posHQP6")},
	}
	SetupArmy(pAI[6].armys[3])

	pAI[6].armys[4] = {
		player = 6,
		id = 4,
		strength = 4,
		position = GetPos("posHQP6"),	-- also spawn location
		rodeLength = 1500,
		defensePosition = GetPos("posHQP6"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderSword2, position = GetPos("posHQP6")},
	}
	SetupArmy(pAI[6].armys[4])

	-- army 5 = attacker (south); later!

	ControlArmyP6 = function()
		if Counter.Tick2("ArmyControllerP6", 10) then
			-- offensive
			for i = 1, 2 do
				local army = pAI[6].armys[i]
				if IsDead(army) and IsAlive("HQP6") then
					if not AreEnemiesInArea(6, GetPos("posHQP6"), 1500) then	-- do not spawn when players are too close
						for i = 1, army.strength do
							EnlargeArmy(army, army.troopDescription)
						end
					end

				else
					Advance(army)
				end
			end

			-- defensive
			for i = 3, 4 do
				local army = pAI[6].armys[i]
				if IsDead(army) and IsAlive("HQP6") then
					if not AreEnemiesInArea(6, GetPos("posHQP6"), 1500) then	-- do not spawn when players are too close
						for i = 1, army.strength do
							EnlargeArmy(army, army.troopDescription)
						end
					end

					Redeploy(army, army.defensePosition)
				else
					Defend(army)
				end
			end
		end
	end
	StartSimpleJob("ControlArmyP6")
end

function InitPlayer7()
	Logic.SetPlayerPaysLeaderFlag(7, 0)
	AI.Player_EnableAi(7)
	AI.Village_SetSerfLimit(7, 8)
	AI.Village_EnableRepairing(7, 1)
	AI.Village_EnableExtracting(7, false)

	--pAI[7] = {}
	pAI[7].armys = {}
	pAI[7].armys[1] = {
		player = 7,
		id = 1,
		strength = 4,
		position = GetPos("posHQP7"),	-- not spawn location
		rodeLength = 2500,
		attackPosition = GetPos("posGate3P4"),	-- attack target area
		beAgressive = true,
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = MEDIUM_EXPERIENCE, leaderType = Entities.PU_LeaderSword1, position = GetPos("posHQP7")},
	}
	SetupArmy(pAI[7].armys[1])

	pAI[7].armys[2] = {
		player = 7,
		id = 2,
		strength = 4,
		position = GetPos("posHQP7"),	-- not spawn location
		rodeLength = 2500,
		attackPosition = GetPos("posGate2P4"),	-- attack target area
		beAgressive = true,
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = MEDIUM_EXPERIENCE, leaderType = Entities.PU_LeaderPoleArm1, position = GetPos("posHQP7")},
	}
	SetupArmy(pAI[7].armys[2])

	-- defensive armys
	pAI[7].armys[3] = {
		player = 7,
		id = 3,
		strength = 4,
		position = GetPos("posHQP7"),	-- spawn location
		rodeLength = 1500,
		defensePosition = GetPos("posHQP7"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderBow2, position = GetPos("posHQP7")},
	}
	SetupArmy(pAI[7].armys[3])

	pAI[7].armys[4] = {
		player = 7,
		id = 4,
		strength = 4,
		position = GetPos("posHQP7"),	-- spawn location
		rodeLength = 1500,
		defensePosition = GetPos("posHQP7"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderSword2, position = GetPos("posHQP7")},
	}
	SetupArmy(pAI[7].armys[4])

	-- army 5 = attacker (south); later!

	ControlArmyP7 = function()
		if Counter.Tick2("ArmyControllerP7", 10) then
			-- offensive
			for i = 1, 2 do
				local army = pAI[7].armys[i]
				if IsDead(army) and IsAlive("HQP7") then
					if not AreEnemiesInArea(7, GetPos("posHQP7"), 2200) then	-- do not spawn when players are too close
						for i = 1, army.strength do
							EnlargeArmy(army, army.troopDescription)
						end
					end

				else
					Advance(army)
				end
			end

			-- defensive
			for i = 3, 4 do
				local army = pAI[7].armys[i]
				if IsDead(army) and IsAlive("HQP7") then
					if not AreEnemiesInArea(7, GetPos("posHQP7"), 2200) then	-- do not spawn when players are too close
						for i = 1, army.strength do
							EnlargeArmy(army, army.troopDescription)
						end
					end

					Redeploy(army, army.defensePosition)
				else
					Defend(army)
				end
			end
		end
	end
	StartSimpleJob("ControlArmyP7")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Intro()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	AP{ title = "Wilkommen!", text = "Helft den Dorfbewohnern!", position = GetPos("posIntro"..gvMission.PlayerID), action = function() AddGold(100) end }
		briefing.finished = function()

		end
	StartBriefing(briefing)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Briefing_InfoWalls()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	AP{ title = "", text = "Mauern können nur durch Kanonen beschädigt werden! Eure Schwerter und Bögen sind dagegen zwecklos.", position = GetPos("posWallSouth"), action = function() end }
		briefing.finished = function()

		end
	StartBriefing(briefing)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupQuest_Main()
	AddQuest_Main()
end

function AddQuest_Main()
	Logic.AddQuest(1, QUEST_MAINQUEST_1, MAINQUEST_OPEN, col.orange.."Aufgabe I", ("Der Bürgermeister der Stadt zählt in dieser Gegend zu Euren wichtigsten Partnern, besonders in Handelsangelegenheiten."..
	" Doch bereits seit Tagen ist keine Nachricht mehr aus der Stadt eingetroffen und von dem Bürgermeister fehlt anscheinend jede Spur. Im Westen und im Osten gibt es zwei Städte, die weder Euch"..
	" noch"..col.hgruen.."Flechtingen"..col.w.."freundlich gegenüberstehen. Ihr müsst mit dem Schlimmsten rechnen! "..
	" @cr @cr Eure Aufgabe: @cr @cr - Baut zunächst Eure Siedlung auf."..
	" @cr - Besiegt alle feindlichen Lager."..
	" @cr - Eilt der Stadt"..col.hgruen.."Flechtingen"..col.w.."zu Hilfe!"), 1)
	Logic.AddQuest(2, QUEST_MAINQUEST_2, MAINQUEST_OPEN, col.orange.."Aufgabe I", ("Der Bürgermeister der Stadt zählt in dieser Gegend zu Euren wichtigsten Partnern, besonders in Handelsangelegenheiten."..
	" Doch bereits seit Tagen ist keine Nachricht mehr aus der Stadt eingetroffen und von dem Bürgermeister fehlt anscheinend jede Spur. Im Westen und im Osten gibt es zwei Städte, die weder Euch"..
	" noch"..col.hgruen.."Flechtingen"..col.w.."freundlich gegenüberstehen. Ihr müsst mit dem Schlimmsten rechnen! "..
	" @cr @cr Eure Aufgabe: @cr @cr - Baut zunächst Eure Siedlung auf."..
	" @cr - Besiegt alle feindlichen Lager."..
	" @cr - Eilt der Stadt"..col.hgruen.."Flechtingen"..col.w.."zu Hilfe!"), 1)

	local info_text = "Einige Hinweise zu Besonderheiten dieser Karte: @cr"..
	" @cr - Mauern können ausschließlich von Kannonen beschädigt werden"..
	-- " @cr - Nutzt automatisches Nachrekrutieren um Soldaten auch bei verbündeten Militärgebäuden auffüllen zu können"..

	" @cr "..
	" @cr - Zahlreiche Siedler unterstützen Euch, von manchen könnt Ihr Technologien erwerben"..
	" @cr - Haltet nach Truhen ausschau, sie enthalten oft wertvolle Schätze"..
	" @cr - Bäume sind besonders ertragreich: sie liefern mehr Holz, brauchen aber länger, um abgebaut zu werden"..

	" @cr "..
	" @cr - An Marktplätze könnt Ihr aktuell gehandelte Waren sehen"..
	" @cr - Mit [Steuerung] könnt Ihr schneller die Rohstoffmenge verändern, die Ihr an Verbündete senden wollt"..
	" @cr - Wenn ein Gebäudeausbau abgeschlossen ist, seht Ihr dies durch eine blaue Markierung auf der Karte"..

	" @cr "..
	" @cr - Nutzt die Knöpfe neben der Minimap, um Eure Aufgaben zu betrachten."

	-- also add some map information
	Logic.AddQuest(1, QUEST_MAPINFORMATION_1, SUBQUEST_OPEN, col.beig.."Karteninfos", (info_text), 0)
	Logic.AddQuest(2, QUEST_MAPINFORMATION_2, SUBQUEST_OPEN, col.beig.."Karteninfos", (info_text), 0)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitChests()
	-- start resources (bandit tents)
	CreateChestMP("chest3", CC_StartResources1)
	CreateChestMP("chest4", CC_StartResources2)

	-- random gold chests
	CreateChestMP("chest1", CC_Gold)
	CreateChestMP("chest2", CC_Gold)
	CreateChestMP("chest5", CC_Gold)
	CreateChestMP("chest6", CC_Gold)
	CreateChestMP("chest7", CC_Gold)
	CreateChestMP("chest8", CC_Gold)
	CreateChestMP("chest9", CC_Gold)
	CreateChestMP("chest10", CC_Gold)
	CreateChestMP("chest11", CC_Gold)

	StartSimpleJob("SJ_ControlChests")
end

function CC_StartResources1()
	Message("ihr habt eine truhe der banditen gefunden, sie enthielt:"..col.orange.." " .. dekaround(900*gvDiffLVL) .. " holz und " .. dekaround(750*gvDiffLVL) .. " lehm!")
	AddWood(1, dekaround(900*gvDiffLVL))
	AddWood(2, dekaround(900*gvDiffLVL))
	AddClay(1, dekaround(750*gvDiffLVL))
	AddClay(2, dekaround(750*gvDiffLVL))
end

function CC_StartResources2()
	Message("ihr habt eine truhe der banditen gefunden, sie enthielt:"..col.grau.." " .. dekaround(600*gvDiffLVL) .. " steine!")
	AddStone(1, dekaround(600*gvDiffLVL))
	AddStone(2, dekaround(600*gvDiffLVL))
end


function CC_Gold()	-- add a random gold value; increases over time
	local _time = round(Logic.GetTime())
	local g = math.random(7, 15) * 30 * gvDiffLVL
	if _time > 7200 then
		g = g * 4
	elseif _time > 3600 then
		g = g * 2
	end
	Message("ihr habt in dieser truhe "..col.hblau..g.." gold gefunden!")	-- per player
	AddGold(1, g)
	AddGold(2, g)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function MakeStartBuildingsUnselectable()
	for i = 1, 6 do
		Logic.SetEntitySelectableFlag(GetEntityId("p1b"..i), 0)
		Logic.SetEntitySelectableFlag(GetEntityId("p2b"..i), 0)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitSneakyAttack()
	DestroyEntity("rock1a")
	DestroyEntity("rock1b")

	-- initiate a sneaky attack on both player HQs
	for p = 1, 2 do
		CreateMilitaryGroup(3, Entities.PU_LeaderBow2, 4, GetPos("spawnCamp5_"..p), "P3sneaky"..p.."_1")
		CreateMilitaryGroup(3, Entities.PU_LeaderBow2, 4, GetPos("spawnCamp5_"..p), "P3sneaky"..p.."_2")
		CreateMilitaryGroup(3, Entities.CU_BanditLeaderSword1, 8, GetPos("spawnCamp5_"..p), "P3sneaky"..p.."_3")
		CreateMilitaryGroup(3, Entities.CU_BanditLeaderSword1, 8, GetPos("spawnCamp5_"..p), "P3sneaky"..p.."_2")
	end

	ControlSneakyAttack = function()
		if Counter.Tick2("ControlSneakyAttackCounter", 6) then
			local alive = 0
			local target1 = "HQP1"
			local target2 = "HQP2"
			if IsDead(target1) and IsDead(target2) then return true end
			if IsDead(target1) then target1 = target2 end
			if IsDead(target2) then target2 = target1 end

			for i = 1, 2 do
				if IsAlive("P3sneaky1_"..i) then
					alive = alive + 1
					Attack("P3sneaky1_"..i, target1)
				end
			end

			for i = 1, 2 do
				if IsAlive("P3sneaky2_"..i) then
					alive = alive + 1
					Attack("P3sneaky2_"..i, target2)
				end
			end

			if alive == 0 then
				return true
			end
		end
	end
	StartSimpleJob("ControlSneakyAttack")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitBanditCamps()
	if gvMission.singleplayerMode then
		DestroyEntity("robTowerP3_2")
	else
		InitCampSouth_2()
	end

	InitCampSouth_1()
	--InitCampSouth_2()
	InitCampSouth_3()
	InitCamp4()
	InitCamp5()
	InitCamp6()

	ControlBanditCamps = function()
		local t = {"robTowerP3_1", "robTowerP3_2", "robTowerP3_3", "robTowerP3_4", "robTowerP3_5", "robTowerP3_6"}
		if AreAllDead(t) then
			-- start chapter 2
			StartCountdown(12, StartSecondChapter, false)
			return true
		end
	end
	StartSimpleJob("ControlBanditCamps")
end


function InitCampSouth_1()

	local camp = {
		-- notwendige Angaben
		id = 1,									-- muss eindeutig sein für jedes Camp!
		player = 3,
		spawnPos = GetPosition("spawnCamp1"),	-- Ort (ScriptEntity) an dem die Truppen spawnen
		position = GetPosition("spawnCamp1"),
		spawnGenerator = "robTowerP3_1",		-- Gebäude, die zerstört werden müssen, damit der Spawn aufhört, mehrere zb. so: spawnBuildings = {"campTower1", "campTower2"}
												-- das erste Gebäude muss jedoch unbedingt die SpielerID haben, die auch die Truppen haben sollen!
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },	-- erlaubte Truppen
		strength = round(5/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 1800,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
		respawnTime = round(30*gvDiffLVL),		-- Zeit in Sekunden zwischen 2 Spawns
		maxSpawnAmount = 1,						-- pro Spawn werden maximal so viele Truppen erzeugt, Standard: 1
		refresh = true,
		destroyCallback = "OnBanditCampDestroyed",		-- sind alle Gebäude in spawnBuildings zerstört, wird diese Funktion aufgerufen, keine "()" hier!
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("CampSouth_1", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

function InitCampSouth_2()

	local camp = {
		-- notwendige Angaben
		id = 2,									-- muss eindeutig sein für jedes Camp!
		player = 3,
		spawnPos = GetPosition("spawnCamp2"),				-- Ort (ScriptEntity) an dem die Truppen spawnen
		position = GetPosition("spawnCamp2"),
		spawnGenerator = "robTowerP3_2",		-- Gebäude, die zerstört werden müssen, damit der Spawn aufhört, mehrere zb. so: spawnBuildings = {"campTower1", "campTower2"}
												-- das erste Gebäude muss jedoch unbedingt die SpielerID haben, die auch die Truppen haben sollen!
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },	-- erlaubte Truppen
		strength = round(5/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 1800,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
		respawnTime = round(30*gvDiffLVL),
		maxSpawnAmount = 1,						-- pro Spawn werden maximal so viele Truppen erzeugt, Standard: 1
		refresh = true,
		destroyCallback = "OnBanditCampDestroyed",		-- sind alle Gebäude in spawnBuildings zerstört, wird diese Funktion aufgerufen, keine "()" hier!
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("CampSouth_2", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

function InitCampSouth_3()

	local camp = {
		-- notwendige Angaben
		id = 3,									-- muss eindeutig sein für jedes Camp!
		player = 3,
		spawnPos = GetPosition("spawnCamp3"),				-- Ort (ScriptEntity) an dem die Truppen spawnen
		position = GetPosition("spawnCamp3"),
		spawnGenerator = "robTowerP3_3",		-- Gebäude, die zerstört werden müssen, damit der Spawn aufhört, mehrere zb. so: spawnBuildings = {"campTower1", "campTower2"}
												-- das erste Gebäude muss jedoch unbedingt die SpielerID haben, die auch die Truppen haben sollen!
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },	-- erlaubte Truppen
		strength = round(8/gvDiffLVL),			-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 2500,						-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
		respawnTime = round(30*gvDiffLVL),		-- Zeit in Sekunden zwischen 2 Spawns, Standard: 20 Sekunden
		maxSpawnAmount = 1,						-- pro Spawn werden maximal so viele Truppen erzeugt, Standard: 1
		refresh = true,
		destroyCallback = "OnCampSouthDestroyed",		-- sind alle Gebäude in spawnBuildings zerstört, wird diese Funktion aufgerufen, keine "()" hier!
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("CampSouth_3", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

ControlCamp = function(_player, _id, _spawnGenerator, _callback)

	local army = ArmyTable[_player][_id + 1]
	if not IsDead(army) then
		Defend(army)
	else
		if IsDestroyed(_spawnGenerator) then
			_G[_callback]()
			return true
		end
	end
end

function OnCampSouthDestroyed()
	-- InitCamp5()
	ReplaceEntity("gate1", Entities.XD_WallStraightGate)
	InitSneakyAttack()

	CreateNpcMP("npcMiner3", TalkToMiner3, nil)
end

-- see quests!
function OnBanditCampDestroyed()
	-- local gold = 300
	Message(col.beig.."sehr gut, ihr habt ein lager der banditen zerstört!")
	-- Message(col.beig.."ihr habt in diesem turm "..col.hblau..gold.." gold gefunden!")
	-- AddGold(1, gold)
	-- AddGold(2, gold)
end

function InitCamp4()
	local camp = {
		-- notwendige Angaben
		id = 4,									-- muss eindeutig sein für jedes Camp!
		player = 3,
		spawnPos = GetPosition("spawnCamp4"),				-- Ort (ScriptEntity) an dem die Truppen spawnen
		position = GetPosition("spawnCamp4"),
		spawnGenerator = "robTowerP3_4",		-- Gebäude, die zerstört werden müssen, damit der Spawn aufhört, mehrere zb. so: spawnBuildings = {"campTower1", "campTower2"}
												-- das erste Gebäude muss jedoch unbedingt die SpielerID haben, die auch die Truppen haben sollen!
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },	-- erlaubte Truppen
		strength = round(9/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 1700,					-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
		respawnTime = round(30*gvDiffLVL),
		maxSpawnAmount = 1,						-- pro Spawn werden maximal so viele Truppen erzeugt, Standard: 1
		refresh = true,
		destroyCallback = "OnCamp4Destroyed",		-- sind alle Gebäude in spawnBuildings zerstört, wird diese Funktion aufgerufen, keine "()" hier!
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("Camp4", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

function OnCamp4Destroyed()
	Message(col.beig.."sehr gut, ihr habt ein lager der banditen zerstört!")
	StartCountdown(4, GiveCannonPlayer1, false)
end

function InitCamp5()
	local camp = {
		-- notwendige Angaben
		id = 5,									-- muss eindeutig sein für jedes Camp!
		player = 3,
		spawnPos = GetPosition("spawnCamp5_1"),				-- Ort (ScriptEntity) an dem die Truppen spawnen
		position = GetPosition("spawnCamp5_1"),
		spawnGenerator = "robTowerP3_5",		-- Gebäude, die zerstört werden müssen, damit der Spawn aufhört, mehrere zb. so: spawnBuildings = {"campTower1", "campTower2"}
												-- das erste Gebäude muss jedoch unbedingt die SpielerID haben, die auch die Truppen haben sollen!
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },	-- erlaubte Truppen
		strength = round(11/gvDiffLVL),		-- so viele Truppen soll das Camp zu einem Zeitpunkt haben; sterben Truppen, werden bis sie zu maxStrength wieder aufgefüllt, Standard: 5
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 3200,						-- Reichweite, in der das Camp verteidigt wird, Standard: 2000
		respawnTime = round(30*gvDiffLVL),		-- Zeit in Sekunden zwischen 2 Spawns, Standard: 20 Sekunden
		maxSpawnAmount = 1,						-- pro Spawn werden maximal so viele Truppen erzeugt, Standard: 1
		refresh = true,
		destroyCallback = "OnCamp5Destroyed"		-- sind alle Gebäude in spawnBuildings zerstört, wird diese Funktion aufgerufen, keine "()" hier!
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("Camp5", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

function OnCamp5Destroyed()
	Message(col.beig.."Ihr habt in diesem Lager Baupläne gefunden: "..col.hblau.."Schießplatz!")
	AllowTechnology(Technologies.B_Archery, 1)
	AllowTechnology(Technologies.B_Archery, 2)

	CreateNpcMP("npcScout3", TalkToScout3, nil)
end


function InitCamp6()
	local camp = {
		-- notwendige Angaben
		id = 6,
		player = 3,
		spawnPos = GetPosition("spawnCamp6"),
		position = GetPosition("spawnCamp6"),
		spawnGenerator = "robTowerP3_6",
		spawnTypes = { {Entities.CU_BanditLeaderSword1, round(10/gvDiffLVL)}, {Entities.PU_LeaderBow2, round(10/gvDiffLVL)} },
		strength = round(9/gvDiffLVL),
		endless = true,
		-- optionale Angaben (wenn nicht benötigt, einfach weglassen)
		rodeLength = 1700,
		respawnTime = round(30/gvDiffLVL),
		maxSpawnAmount = 1,
		refresh = true,
		destroyCallback = "OnCamp6Destroyed"
	}
	SetupArmy(camp)
	SetupAITroopSpawnGenerator("Camp6", camp)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlCamp", 1, {}, {camp.player, camp.id, camp.spawnGenerator, camp.destroyCallback})
end

function OnCamp6Destroyed()
	Message(col.beig.."sehr gut, ihr habt ein lager der banditen zerstört!")
	Logic.AddMercenaryOffer(GetEntityId("merc2"), Entities.PV_Cannon2, 2, ResourceType.Sulfur, dekaround(600/gvDiffLVL))

	-- additionally: a trading route is now available
	CreateNpcMP("npcMerc3", TalkToMerc3, nil)
	-- plus: buy sulfur (in case the players loose the only cannon available now)
	CreateNpcMP("npcMerc5", TalkToMerc5, nil)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToMerc3()
	MovieWindow_Start(1, col.hblau.."Händler", "Ahh, endlich ein bekanntes Gesicht. Nun da das Lager der Banditen zerstört wurde,"..
	" kann diese Handelsroute endlich wieder in Betrieb genommen werden!", 12)
	MovieWindow_Start(2, col.hblau.."Händler", "Ahh, endlich ein bekanntes Gesicht. Nun da das Lager der Banditen zerstört wurde,"..
	" kann diese Handelsroute endlich wieder in Betrieb genommen werden!", 12)

	MovieWindow_Start(1, col.orange.."Mission", "Ihr könnt nun Handel treiben!", 10)
	MovieWindow_Start(2, col.orange.."Mission", "Ihr könnt nun Handel treiben!", 10)

	AllowTechnology(Technologies.UP1_Market, 1)
	AllowTechnology(Technologies.UP1_Market, 2)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- buy sulfur
function TalkToMerc5(_player)
	MovieWindow_Start(_player, col.hblau.."Händler", "Wilkommen, werte Reisende. Ihr benötigt Schwefel?"..
	" Ich kann Euch meine Restposten anbieten ...", 11)
	AddTribute({ playerId = _player, text = ("Kauft 1000 Einheiten Schwefel für " .. dekaround(3000/gvDiffLVL) .. "	Taler."), cost = { Gold = dekaround(3000/gvDiffLVL) }, Callback = AcceptTrade1_Merc5, actionPlayer = _player })
end

function AcceptTrade1_Merc5(parameters)
	local _player = parameters.actionPlayer
	AddSulfur(_player, 1000)
	MovieWindow_Start(_player, col.hblau.."Händler", "Habt vielen Dank. Ein wenig dieses wunderbaren Rohstoffes besitze ich noch,"..
	" leider ist dies mein letzter Bestand.", 12)
	AddTribute({ playerId = _player, text = ("Kauft 1000 Einheiten Schwefel für " .. dekaround(4000/gvDiffLVL) .. " Taler."), cost = { Gold = dekaround(4000/gvDiffLVL) }, Callback = AcceptTrade2_Merc5, actionPlayer = _player })
	--PlayTributeSoundForPlayer(_player)
end

function AcceptTrade2_Merc5(parameters)
	local _player = parameters.actionPlayer
	AddSulfur(_player, 1000)
	MovieWindow_Start(_player, col.hblau.."Händler", "Es war mir eine Freude mit Euch Geschäfte zu machen.", 8)
	--PlayTributeSoundForPlayer(_player)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- unlock spying via tribute
function TalkToScout3( playerId )

	MovieWindow_Start(1, col.hblau.."Spion", "Ahh, endlich frei. Sie haben mich erwischt, als ich mich hier umgesehen habe."..
	" Ich muss nächstes mal besser aufpassen ... denke ich. Wenn Ihr Interesse habt, kann ich Euch helfen, Eure Gegner auszuspionieren.", 14)
	MovieWindow_Start(2, col.hblau.."Spion", "Ahh, endlich frei. Sie haben mich erwischt, als ich mich hier umgesehen habe."..
	" Ich muss nächstes mal besser aufpassen ... denke ich. Wenn Ihr Interesse habt, kann ich Euch helfen, Eure Gegner auszuspionieren.", 14)

	local gold = 500
	gvMission.spying = {
		tributeIDs = {},
		gold = gold,
		active = false,
		tributeText = string.format(("Spionage: deckt für kurze Zeit Eure Gegner auf (%d Taler)"), gold),
	}
	gvMission.spying.tributeIDs[1] = AddTribute({ playerId = 1, text = gvMission.spying.tributeText, cost = { Gold = gvMission.spying.gold }, Callback = ActivateSpy, actionPlayer = 1 })
	gvMission.spying.tributeIDs[2] = AddTribute({ playerId = 2, text = gvMission.spying.tributeText, cost = { Gold = gvMission.spying.gold }, Callback = ActivateSpy, actionPlayer = 2 })

end

function ActivateSpy(parameters)
	local player = parameters.actionPlayer

	-- can increase cost?

	-- share view for both players or only one?
	Logic.SetShareExplorationWithPlayerFlag( player, 6, 1 )
	Logic.SetShareExplorationWithPlayerFlag( player, 7, 1 )

	ControlSpy = function(_player)
		if Counter.Tick2("tick_spy_player".._player, 60) then	-- adjust duration here!
			Logic.SetShareExplorationWithPlayerFlag( _player, 6, 0 )
			Logic.SetShareExplorationWithPlayerFlag( _player, 7, 0 )
			gvMission.spying.tributeIDs[_player] = AddTribute({ playerId = _player, text = gvMission.spying.tributeText,
				cost = { Gold = gvMission.spying.gold }, Callback = ActivateSpy, actionPlayer = _player })
			return true
		end
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlSpy", 1, {}, {player})
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitWolves()
	for i = 1, 6 do
		CreateEntity(3, Entities.CU_AggressiveWolf, GetPos("spawnW1"), "wolf"..i)
	end

	ControlWolves = function()
		if Counter.Tick2("tick_wolves", 6) then
			if AreAllDead({"wolf1", "wolf2", "wolf3", "wolf4", "wolf5", "wolf6"}) then
				return true
			else
				for i = 1, 6 do
					if IsAlive("wolf"..i) then
						if GetPlayer("wolf"..i) == 3 then
							Attack("wolf"..i, "spawnW"..math.random(1,2))
						else
							SetHealth("wolf"..i, 0)	-- Helias converted a wolf? nah ... kill it!
						end
					end
				end
			end
		end
	end
	StartSimpleJob("ControlWolves")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function StartSurpriseAttack()

	MovieWindow_Start(1, col.orange.."Mission", "Seht doch! Einigen gegnerischen Truppen ist es offenbar gelungen einen verborgenen Weg zu durchqueren "..
	" um die Stadt von Süden aus anzugreifen! Herrje, sie brennen ja alles nieder!", 16)
	MovieWindow_Start(2, col.orange.."Mission", "Seht doch! Einigen gegnerischen Truppen ist es offenbar gelungen einen verborgenen Weg zu durchqueren "..
	" um die Stadt von Süden aus anzugreifen! Herrje, sie brennen ja alles nieder!", 16)

	GUI.ScriptSignal(28780, 36000, 2)	-- white
	-- camera jump? nah
	Sound.PlayGUISound(Sounds.VoicesMentor_ALARM_ActivateAlarm, 100)

	DestroyEntity("rockCave1")
	DestroyEntity("rockCave3")

	-- armys
	pAI[6].armys[5] = {
		player = 6,
		id = 5,
		strength = round(15/gvDiffLVL),
		position = GetPos("posCave1"),	-- spawn location
		rodeLength = 2500,
		--attackPosition = GetPos("posGate1P4"),	-- attack target area
		troopDescription = {maxNumberOfSoldiers = 12, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderPoleArm4},
	}
	SetupArmy(pAI[6].armys[5])

	for i = 1, pAI[6].armys[5].strength do
		EnlargeArmy(pAI[6].armys[5], pAI[6].armys[5].troopDescription)
	end

	ControlArmyP6Surprise = function()
		if Counter.Tick2("ArmyControllerP6_Extra", 6) then
			if IsDead(pAI[6].armys[5]) then return true end
			Advance(pAI[6].armys[5])
		end
	end
	StartSimpleJob("ControlArmyP6Surprise")

	pAI[7].armys[5] = {
		player = 7,
		id = 5,
		strength = round(15/gvDiffLVL),
		position = GetPos("posCave3"),	-- spawn location
		rodeLength = 2500,
		--attackPosition = GetPos("posGate1P4"),	-- attack target area
		troopDescription = {maxNumberOfSoldiers = 12, minNumberOfSoldiers = 0, experiencePoints = HIGH_EXPERIENCE, leaderType = Entities.PU_LeaderPoleArm4},
	}
	SetupArmy(pAI[7].armys[5])

	for i = 1, pAI[7].armys[5].strength do
		EnlargeArmy(pAI[7].armys[5], pAI[7].armys[5].troopDescription)
	end

	ControlArmyP7Surprise = function()
		if Counter.Tick2("ArmyControllerP7_Extra", 6) then
			if IsDead(pAI[7].armys[5]) then return true end
			Advance(pAI[7].armys[5])
		end
	end
	StartSimpleJob("ControlArmyP7Surprise")

	StartCountdown(8, StartWildfire, false)
	--StartCountdown(60, EnableCityNpc, false)

	-- farmers leave ...
	DisableFarms_P4()
	--
	StartCountdown((30 + math.random(3,7))*60*gvDiffLVL, StartSurpriseAttack)
end

function StartWildfire()
	-- trees
	Fire_Start("posFire1", 900, 3500, "trees", "tree_replace", 3)
	Fire_Start("posFire2", 900, 3500, "trees", "tree_replace", 2)
	Fire_Start("posFire3", 900, 3500, "trees", "tree_replace", 2)
	Fire_Start("posFire4", 900, 3500, "trees", "tree_replace", 2)
	Fire_Start("posFire5", 900, 3500, "trees", "tree_replace", 2)
	Fire_Start("posFire6", 900, 2500, "trees", "tree_replace", 2)

	-- corn fields
	Fire_Start("posFireC1", 800, 3000, "corn", "corn_replace", 18)	-- speed of 20 is max
	Fire_Start("posFireC2", 800, 3000, "corn", "corn_replace", 18)
	Fire_Start("posFireC3", 800, 3000, "corn", "corn_replace", 18)
	Fire_Start("posFireC4", 800, 3000, "corn", "corn_replace", 18)
	Fire_Start("posFireC5", 800, 3000, "corn", "corn_replace", 18)
	Fire_Start("posFireC6", 800, 3000, "corn", "corn_replace", 18)

	StartSummer(120)	-- make sure its not raining right now
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function EnableCityNpc()
	CreateNpcMP("npcFarmer", TalkToFarmer, nil)
	CreateNpcMP("npcCavalry", TalkToCavalry, nil)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function GiveCannonPlayer1()
	local pos = GetPos("cannon")
	GUI.ScriptSignal(pos.X, pos.Y, 2)	-- white
	if gvMission.PlayerID == 1 then
		Camera.ScrollSetLookAt(pos.X, pos.Y)
	end
	ChangePlayer("cannon", 1)
	Message(col.beig.."Ihr habt eine Kanone erhalten! Gebt gut darauf acht, nur mit Kanonen könnt Ihr Mauern zerstören!")

	Logic.AddMercenaryOffer(GetEntityId("merc3"), Entities.PV_Cannon2, 2, ResourceType.Sulfur, dekaround(400/gvDiffLVL))
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToScout1()
	MovieWindow_Start(1, col.hblau.."Kundschafter", "Hallo, für eine kleine Gegenleistung kann ich Euch helfen, einen besseren Überblick zu bekommen... "..
		" ich kann Euch ermöglichen mit den Augen Eures Verbündeten zu sehen... Sozusagen", 13)
	AddTribute({ playerId = 1, text = ("Für eine kleine Spende von 50 Talern erhaltet Ihr freie Sicht auf Euren Verbündeten."), cost = { Gold = 50 }, Callback = ShareExplorationP1 })
end

function TalkToScout2()
	MovieWindow_Start(2, col.hblau.."Kundschafter", "Hallo, für eine kleine Gegenleistung kann ich Euch helfen, einen besseren Überblick zu bekommen... "..
		" ich kann Euch ermöglichen mit den Augen Eures Verbündeten zu sehen... Sozusagen", 13)
	AddTribute({ playerId = 2, text = ("Für eine kleine Spende von 50 Talern erhaltet Ihr freie Sicht auf Euren Verbündeten."), cost = { Gold = 50 }, Callback = ShareExplorationP2 })
end

function ShareExplorationP1()
	ChangePlayer("scout1", 1)
	Logic.SetShareExplorationWithPlayerFlag(1, 2, 1)
	--PlayTributeSoundForPlayer(1)
end

function ShareExplorationP2()
	ChangePlayer("scout2", 2)
	Logic.SetShareExplorationWithPlayerFlag(2, 1, 1)
	--PlayTributeSoundForPlayer(2)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
function TalkToEngineer(_player)
	MovieWindow_Start(_player, col.hblau.."Ingenieur", "Ich habe ein kleines Rätsel für Euch. Vermögt Ihr es zu lösen, gibt es eine kleine Belohnung, thihihi. Also, sagt mir:"..
	col.hblau.." welche Bilder kann man nur im Dunkeln sehen?", 12)

	gvMission.engineerRiddlePlayer = _player
	if gvMission.PlayerID == _player then
		gvMission.chatInput = true	-- remove
		XGUIEng.ShowWidget(XGUIEng.GetWidgetID("ChatInput"), 1)
	end

end

function EngineerRiddleSolved()
	gvMission.chatInput = false
	MovieWindow_Start(gvMission.engineerRiddlePlayer, col.hblau.."Ingenieur", "Ahh, ganz genau! Das ist es. Hier: als Belohnung dürft Ihr Euch eine meiner Truhen auswählen ...", 11)
	local ch = ReplaceEntity("chestEng", Entities.XD_ScriptEntity)
	CreateChestMP(ch, CC_Gold)
end
--]]

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- build house and farm
function TalkToMiner1()	-- player 1 only!
	--[[
	-- only add this quest if there is no other active quest for this player!
	if MPQuest_GetActivePlayerQuest(1) ~= nil then
		StartSimpleJob(function()
			CreateNpcMP("npcMiner1", TalkToMiner1, 1)
			return true
		end)
		return
	end
	--]]

	MovieWindow_Start(1, col.hblau.."Bergarbeiter", "Die Mine wollt ihr? Nun, ich würde sie Euch überlassen ... "..
		" sofern Ihr mir und meinen Kumpel hier"..col.beig.."ein Haus und einen Bauernhof baut.", 13)
	InitQuest_BuildHouseAndFarmForMiner_P1()
end

function InitQuest_BuildHouseAndFarmForMiner_P1()
	--MPQuest_StartQuest(1, QUEST_TEXT_BUILDHOUSEANDFARM, 0, 2, "Build_Mine")
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_BUILDHOUSEANDFARM
	quest.counter = 0
	quest.limit = 2
	quest.image = "Build_Mine"
	quest.position = GetPos("posIronPit1")
	quest.condition = function(_questID)	-- return true/false
		local done = 0
		if AreEntitiesInArea(1, Entities.PB_Residence1, GetPos("posIronPit1"), 2600, 1) then
			done = done + 1
		end
		if AreEntitiesInArea(1, Entities.PB_Farm1, GetPos("posIronPit1"), 2600, 1) then
			done = done + 1
		end
		MPQuest_SetCounter(_questID, done)

		if done == 2 then
			--ResolveQuest_BuildHouseAndFarmForMiner_P1()
			return true
		end
		return false	-- new
	end
	quest.callback = ResolveQuest_BuildHouseAndFarmForMiner_P1
	quest.completedSound = true

	MPQuest_AddQuest(quest)
end

function ResolveQuest_BuildHouseAndFarmForMiner_P1()
	ChangePlayer("ironMine1", 1)
	DestroyEntity("npcMiner1")
end


-- fight off the wolves
function TalkToMiner2()	-- player 2 only
	--[[
	if MPQuest_GetActivePlayerQuest(2) ~= nil then
		StartSimpleJob(function()
			CreateNpcMP("npcMiner2", TalkToMiner2, 2)
			return true
		end)
		return
	end
	--]]

	MovieWindow_Start(2, col.hblau.."Bergarbeiter", "Bitte oh bitte helft uns! Wölfe! Wölfe! ... "..
		" @cr Sie verstecken sich in den Bäumen und lassen uns nicht in Ruhe ... @cr Könnt Ihr sie für uns beseitigen?"..
		" Wir wären Euch sehr verbunden!", 13)
	InitQuest_FightOffWolves_P2()
end

function InitQuest_FightOffWolves_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	if gvMission.singleplayerMode then
		quest.player = 1
	else
		quest.player = 2
	end
	quest.text = QUEST_TEXT_FIGHTOFFWOLVES
	quest.counter = 0
	quest.limit = 6
	quest.image = "Hero9_CallWolfs"
	quest.position = GetPos("npcMiner2")
	quest.condition = function(_questID)	-- return true/false
		local dead = 0
		for i = 1, 6 do
			if IsDead("wolf"..i) then
				dead = dead + 1
			end
		end
		MPQuest_SetCounter(_questID, dead)

		return dead == 6
	end
	quest.callback = ResolveQuest_FightOffWolves_P2
	quest.completedSound = true

	MPQuest_AddQuest(quest)
end

function ResolveQuest_FightOffWolves_P2()
	local p = 2
	if gvMission.singleplayerMode then
		p = 1
	end
	ChangePlayer("ironMine2", p)
	ChangePlayer("houseMine2", p)
	ChangePlayer("farmMine2", p)
	DestroyEntity("npcMiner2")
end

-- miner that sells the sulfur mine
function TalkToMiner3(_player)
	MovieWindow_Start(_player, col.hblau.."Bergarbeiter", "Früher war das hier ein ruhiges Örtchen ... man konnte im Wald spazieren gehen, wenn man mit der schweren Arbeit in der Grube fertig war. "..
		" Doch nun ... überall Krieger. Überall Lärm und Blut. Ich kann meinen Schwefel nicht mehr verkaufen, da die meisten Händler das Weite gesucht haben."..
		" @cr Sagt, habt Ihr vielleicht Interesse an einer Schwefelgrube?", 15)
	AddTribute({ playerId = _player, text = ("Zahlt dem Bergarbeiter"..col.hgelb.." " .. dekaround(1000/gvDiffLVL) .. " Taler"..col.w.."damit er Euch Schwefel abbauen lässt."), cost = { Gold = dekaround(1000/gvDiffLVL) }, Callback = BuySulfurMine })
	gvMission.miner3Player = _player
end

function BuySulfurMine()
	MovieWindow_Start(gvMission.miner3Player, col.hblau.."Bergarbeiter", "Habt Dank für die Talerchen. Ich bin des Grabens müde und werde mich zur Ruhe setzen. Glück auf!", 12)

	--SetHealth("sulfurMine", 51)
	ChangePlayer("sulfurMine", gvMission.miner3Player)
	--PlayTributeSoundForPlayer(gvMission.miner3Player)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToSupportTroop1(_player)
	MovieWindow_Start(_player, col.hblau.."Soldat", "Ihr macht einen ordentlichen Eindruck. Benötigt Ihr gute Soldaten?"..
		" Dann sind wir genau die richtigen!", 10)
	Tools.CreateSoldiersForLeader(GetEntityId("support1"), 4)
	ChangePlayer("support1", _player)
end

function TalkToSupportTroop2(_player)
	MovieWindow_Start(_player, col.hblau.."Soldat", "Ihr macht einen ordentlichen Eindruck. Benötigt Ihr gute Soldaten?"..
		" Dann sind wir genau die richtigen!", 10)
	Tools.CreateSoldiersForLeader(GetEntityId("support2"), 4)
	ChangePlayer("support2", _player)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest 1: kill the initial attackers
function InitQuest_DefendVillage_P1()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_DEFENDVILLAGE
	quest.counter = 0
	quest.limit = 3
	quest.image = "Command_Guard"
	quest.position = GetPos("p1b5")
	quest.condition = function(_questID)
		local c = 0
		for i = 1, 3 do
			if IsDead("bandit"..i) or GetPlayer("bandit"..i) == 1 or GetPlayer("bandit"..i) == 2 then
				c = c + 1
			end
		end
		MPQuest_SetCounter(_questID, c)
		if c == 3 then
			return true
		end
		return false
	end
	quest.callback = ResolveQuest_DefendVillage_P1
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(1, col.orange.."Alarm!", "Eure Späher berichten von nahenden Banditen. Sie werden Euch angreifen, eilt zu den Waffen! Besiegt alle Angreifer!", 12)

	-- GUI; _player, _text, _counter (nil?), _limit (nil?), _image (predefined or TransferMaterials (included))
	--MPQuest_StartQuest(1, QUEST_TEXT_DEFENDVILLAGE, 0, 3, "Command_Guard")

	-- game logic
	--StartSimpleJob("SJ_Quest_DefendVillage_P1")
end

function InitQuest_DefendVillage_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 2
	quest.text = QUEST_TEXT_DEFENDVILLAGE
	quest.counter = 0
	quest.limit = 3
	quest.image = "Command_Guard"
	quest.position = GetPos("p2b5")
	quest.condition = function(_questID)
		local c = 0
		for i = 4, 6 do
			if IsDead("bandit"..i) or GetPlayer("bandit"..i) == 1 or GetPlayer("bandit"..i) == 2 then
				c = c + 1
			end
		end
		MPQuest_SetCounter(_questID, c)
		if c == 3 then
			return true
		end
		return false
	end
	quest.callback = ResolveQuest_DefendVillage_P2
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(2, col.orange.."Alarm!", "Eure Späher berichten von nahenden Banditen. Sie werden Euch angreifen, eilt zu den Waffen! Besiegt alle Angreifer!", 12)

	-- GUI
	--MPQuest_StartQuest(2, QUEST_TEXT_DEFENDVILLAGE, 0, 3, "Command_Guard")
	-- game logic
	--StartSimpleJob("SJ_Quest_DefendVillage_P2")
end

function ResolveQuest_DefendVillage_P1()
	StartCountdown(5, InitQuest_BuildVillageCenter_P1, false)
	StartCountdown(5, InitQuest_DestroyTents_P1, false)
end

function ResolveQuest_DefendVillage_P2()
	StartCountdown(5, InitQuest_BuildVillageCenter_P2, false)
	StartCountdown(5, InitQuest_DestroyTents_P2, false)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest 2: find their tents and take their resources
function InitQuest_DestroyTents_P1()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_DESTROYTENTS
	quest.counter = 0
	quest.limit = 3
	quest.image = "Command_Attack"
	quest.position = GetPos("chest3")
	quest.condition = function(_questID)
		local c = 0
		for i = 1, 3 do
			if IsDead("P3tent"..i.."a") then
				c = c + 1
			end
		end
		MPQuest_SetCounter(_questID, c)
		if c == 3 then
			return true
		end
		return false
	end
	quest.callback = ResolveQuest_DestroyTents_P1
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(1, col.orange.."Vergeltungsschlag", "Sehr gut, die Angreifer sind besiegt. Ihr solltet nun ihren Unterschlupf aufspüren und ihnen damit Einhalt gebieten!", 12)

	--MPQuest_StartQuest(1, QUEST_TEXT_DESTROYTENTS, 0, 3, "Command_Attack")
	--StartSimpleJob("SJ_Quest_DestroyTents_P1")
	--"P3tent3a"
	gvMission.ExploreID_P1 = MPTools_ExploreArea(1, {X = 2460, Y = 27570}, 1400)	-- _player, _pos, _range
end

function InitQuest_DestroyTents_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 2
	quest.text = QUEST_TEXT_DESTROYTENTS
	quest.counter = 0
	quest.limit = 3
	quest.image = "Command_Attack"
	quest.position = GetPos("chest4")
	quest.condition = function(_questID)
		local c = 0
		for i = 1, 3 do
			if IsDead("P3tent"..i.."b") then
				c = c + 1
			end
		end
		MPQuest_SetCounter(_questID, c)
		if c == 3 then
			return true
		end
		return false
	end
	quest.callback = ResolveQuest_DestroyTents_P2
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(2, col.orange.."Vergeltungsschlag", "Sehr gut, die Angreifer sind besiegt. Ihr solltet nun ihren Unterschlupf aufspüren und ihnen damit Einhalt gebieten!", 12)

	--MPQuest_StartQuest(2, QUEST_TEXT_DESTROYTENTS, 0, 3, "Command_Attack")
	--StartSimpleJob("SJ_Quest_DestroyTents_P2")
	--"P3tent1b"
	gvMission.ExploreID_P2 = MPTools_ExploreArea(2, {X = 27850, Y = 2262}, 1400)
end

function ResolveQuest_DestroyTents_P1()
	--StartCountdown(5, InitQuest_BuildVillageCenter_P1, false)
	DestroyEntity(gvMission.ExploreID_P1)
end

function ResolveQuest_DestroyTents_P2()
	--StartCountdown(5, InitQuest_BuildVillageCenter_P2, false)
	DestroyEntity(gvMission.ExploreID_P2)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest 3: build a vc
-- done: make settlement buildings selectable
function InitQuest_BuildVillageCenter_P1()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_BUILDVC
	--quest.counter = 0
	--quest.limit = 3
	quest.image = "Build_Village"
	quest.position = { X = 15300, Y = 23100 }	-- note: must use capital X and Y!
	quest.condition = function()
		return (Logic.GetPlayerAttractionLimit(1) > 0)
	end
	quest.callback = ResolveQuest_BuildVillageCenter_P1
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(1, col.orange.."Dorfzentrum", "Gute Arbeit. Leider sind alle Arbeiter geflohen. Errichtet ein neues Dorfzentrum, um wieder Arbeiter für Eure Siedlung anzuwerben!", 12)
end

function InitQuest_BuildVillageCenter_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 2
	quest.text = QUEST_TEXT_BUILDVC
	quest.image = "Build_Village"
	quest.position = { X = 22500, Y = 14300 }	-- note: must use capital X and Y!
	quest.condition = function()
		return (Logic.GetPlayerAttractionLimit(2) > 0)
	end
	quest.callback = ResolveQuest_BuildVillageCenter_P2
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(2, col.orange.."Dorfzentrum", "Gute Arbeit. Leider sind alle Arbeiter geflohen. Errichtet ein neues Dorfzentrum, um wieder Arbeiter für Eure Siedlung anzuwerben!", 12)
end

function ResolveQuest_BuildVillageCenter_P1()
	StartCountdown(22, InitQuest_DestroyCampSouth_P1, false)
	-- give player settlement buildings
	for i = 1, 6 do
		--ChangePlayer("p1b"..i, 1)
		if IsExisting("p1b"..i) then
			Logic.SetEntitySelectableFlag(GetEntityId("p1b"..i), 1)
		end
	end
	if gvMission.PlayerID == 1 then
		Sound.Play2DQueuedSound(Sounds.VoicesMentorHelp_BUILDING_VillageCenter, 80)
	end
end

function ResolveQuest_BuildVillageCenter_P2()
	StartCountdown(22, InitQuest_DestroyCampSouth_P2, false)
	-- give player settlement buildings
	for i = 1, 6 do
		--ChangePlayer("p2b"..i, 2)
		if IsExisting("p2b"..i) then
			Logic.SetEntitySelectableFlag(GetEntityId("p2b"..i), 1)
		end
	end
	if gvMission.PlayerID == 2 then
		Sound.Play2DQueuedSound(Sounds.VoicesMentorHelp_BUILDING_VillageCenter, 80)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest 4: clear the bigger bandit camps
function InitQuest_DestroyCampSouth_P1()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_DESTROYCAMPSOUTH
	quest.image = "Command_Attack"
	quest.position = GetPos("robTowerP3_1")
	quest.condition = function()
		return IsDead("robTowerP3_1")
	end
	quest.callback = ResolveQuest_DestroyCampSouth_P1
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(1, col.orange.."Banditenlager", "Einige Eurer Siedler berichten von Banditenlagern im Süden. Bevor Ihr diese zerstört habt,"..
	" werden sich die Arbeiter nicht sicher fühlen in Eurer Siedlung ...", 15)

	DestroyEntity("trolleyP1")
	gvMission.ExploreID_P1 = MPTools_ExploreArea(1, {X = 7400, Y = 14925}, 1400)
end

function InitQuest_DestroyCampSouth_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 2
	quest.text = QUEST_TEXT_DESTROYCAMPSOUTH
	quest.image = "Command_Attack"
	quest.position = GetPos("robTowerP3_2")
	quest.condition = function()
		return IsDead("robTowerP3_2")
	end
	quest.callback = ResolveQuest_DestroyCampSouth_P2
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(2, col.orange.."Banditenlager", "Einige Eurer Siedler berichten von Banditenlagern im Süden. Bevor Ihr diese zerstört habt,"..
	" werden sich die Arbeiter nicht sicher fühlen in Eurer Siedlung ...", 15)

	DestroyEntity("trolleyP2")
	gvMission.ExploreID_P2 = MPTools_ExploreArea(2, {X = 14780, Y = 7171}, 1400)
end

function ResolveQuest_DestroyCampSouth_P1()
	DestroyEntity(gvMission.ExploreID_P1)
	StartCountdown(8, InitQuest_BuildSettlement_P1, false)
end

function ResolveQuest_DestroyCampSouth_P2()
	DestroyEntity(gvMission.ExploreID_P2)
	StartCountdown(8, InitQuest_BuildSettlement_P2, false)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest: build settlement: have at least 40 workers and no hungry + homeless
function InitQuest_BuildSettlement_P1()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_BUILDSETTLEMENT
	quest.counter = 0
	quest.limit = 40
	quest.image = "StatisticsMain_Settlers"
	quest.position = GetPos("HQP1")
	quest.condition = function(_questID)
		local workers = Logic.GetNumberOfAttractedWorker(1)
		local hungry = Logic.GetNumberOfWorkerWithoutEatPlace(1)
		local homeless = Logic.GetNumberOfWorkerWithoutSleepPlace(1)

		MPQuest_SetCounter(_questID, workers)

		if workers >= 40 and hungry == 0 and homeless == 0 then
			return true
		end

		return false
	end
	quest.callback = ResolveQuest_BuildSettlement_P1
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(1, col.orange.."Siedlungsaufbau", "Fabelhaft, Ihr habt die Banditen vernichtend geschlagen! Nun könnt Ihr Euch in Ruhe um Euren Siedlungsaufbau kümmern."..
	" Werbt 40 Arbeiter an und versorgt sie mit Nahrung und einem Dach über dem Kopf!", 15)

end

function InitQuest_BuildSettlement_P2()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 2
	quest.text = QUEST_TEXT_BUILDSETTLEMENT
	quest.counter = 0
	quest.limit = 40
	quest.image = "StatisticsMain_Settlers"
	quest.position = GetPos("HQP2")
	quest.condition = function(_questID)
		local workers = Logic.GetNumberOfAttractedWorker(2)
		local hungry = Logic.GetNumberOfWorkerWithoutEatPlace(2)
		local homeless = Logic.GetNumberOfWorkerWithoutSleepPlace(2)

		MPQuest_SetCounter(_questID, workers)

		if workers >= 40 and hungry == 0 and homeless == 0 then
			return true
		end

		return false
	end
	quest.callback = ResolveQuest_BuildSettlement_P2
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	MovieWindow_Start(2, col.orange.."Siedlungsaufbau", "Fabelhaft, Ihr habt die Banditen vernichtend geschlagen! Nun könnt Ihr Euch in Ruhe um Euren Siedlungsaufbau kümmern."..
	" Werbt 40 Arbeiter an und versorgt sie mit Nahrung und einem Dach über dem Kopf!", 15)

end

function ResolveQuest_BuildSettlement_P1()
	MovieWindow_Start(1, col.orange.."Mission", "Ausgezeichnet, seht nur wie Eure Siedlung wächst und gedeiht! Ihr solltet nun die Gegend vorsichtig erkunden."..
	" Nicht jeder ist Euch freundlich gesinnt...", 13)
end

function ResolveQuest_BuildSettlement_P2()
	MovieWindow_Start(2, col.orange.."Mission", "Ausgezeichnet, seht nur wie Eure Siedlung wächst und gedeiht! Ihr solltet nun die Gegend vorsichtig erkunden."..
	" Nicht jeder ist Euch freundlich gesinnt...", 13)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function StartSecondChapter()
	--LuaDebugger.Log("start 2nd chapter")

	InitPlayer4()
	InitPlayer6()
	InitPlayer7()

	--MovieWindow_Start(1, col.orange.."Mission", "Die Stadt"..col.hgruen.."Flechtingen"..col.w.." hat Euch eine Nachricht zukommen lassen. Schaut in Euer Auftragsbuch!", 15)
	MovieWindow_Start(1, col.orange.."Mission", "Die Räubderbanden sind besiegt! Schaut in Euer Auftragsbuch!", 13)
	MovieWindow_Start(2, col.orange.."Mission", "Die Räubderbanden sind besiegt! Schaut in Euer Auftragsbuch!", 13)

	--gvMission.ExploreID_P1 = MPTools_ExploreArea(1, "posCityGate", 2000)
	--gvMission.ExploreID_P2 = MPTools_ExploreArea(2, "posCityGate", 2000)
	local pos = GetPos("posCityGate")
	gvMission.ExploreID_P2 = MPTools_ExploreArea(2, pos, 2000)
	gvMission.ExploreID_P1 = MPTools_ExploreArea(1, {X = pos.X + 1, Y = pos.Y + 1}, 2000)

	AddQuest_City_1()
	DestroyEntity("rockCave2")
	CreateNpcMP("npcGuardP4", TalkToGuardP4, nil)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- message received from the city
function AddQuest_City_1()
	Logic.AddQuest(1, QUEST_CITYQUEST_1, MAINQUEST_OPEN, col.orange.."Aufgabe II", ("Die Stadt"..col.hgruen.."Flechtingen"..col.w.."scheint der Überzeugung zu sein, dass Ihr zu den Räuberhorden gehört."..
		" Ihr solltet sie alsbald vom Gegenteil überzeugen. Nicht dass sie noch Maßnahmen gegen Euch in die Wege leiten ..."..
		" @cr @cr Eure Aufgabe: @cr @cr - Begebt Euch nach"..col.hgruen.."Flechtingen"..col.w.."und findet einen Weg um die Stadt von Eurer Sache zu überzeugen."..
		" @cr - Redet zunächst mit dem Torwächter."), 1)
	Logic.AddQuest(2, QUEST_CITYQUEST_2, MAINQUEST_OPEN, col.orange.."Aufgabe II", ("Die Stadt"..col.hgruen.."Flechtingen"..col.w.."scheint der Überzeugung zu sein, dass Ihr zu den Räuberhorden gehört."..
		" Ihr solltet sie alsbald vom Gegenteil überzeugen. Nicht dass sie noch Maßnahmen gegen Euch in die Wege leiten ..."..
		" @cr @cr Eure Aufgabe: @cr @cr - Begebt Euch nach"..col.hgruen.."Flechtingen"..col.w.."und findet einen Weg um die Stadt von Eurer Sache zu überzeugen."..
		" @cr - Redet zunächst mit dem Torwächter."), 1)
end

function TalkToGuardP4()
	MovieWindow_Start(1, col.hblau.."Torwächter", "Bis hier hin und nicht weiter! Ich will es ein mal freundlich ausdrücken ... verschwindet! Mit Räubern und Wegelagerern wollen wir nichts zu tun haben!"..
	" Wir kämpfen schon seit Wochen gegen solches Gesindel an ... wir sind es allmählich leid.", 16)
	MovieWindow_Start(2, col.hblau.."Torwächter", "Bis hier hin und nicht weiter! Ich will es ein mal freundlich ausdrücken ... verschwindet! Mit Räubern und Wegelagerern wollen wir nichts zu tun haben!"..
	" Wir kämpfen schon seit Wochen gegen solches Gesindel an ... wir sind es allmählich leid.", 16)

	MovieWindow_Start(1, col.orange.."Mission", col.hgruen.."Flechtingen"..col.w.." scheint Euch für Gesetzlose und Räuber zu halten. Überzeugt sie vom Gegenteil:"..
	" Hebt eine Armee aus, die groß genug ist, um"..col.hgruen.."Flechtingen"..col.w.."davon zu überzeugen, dass Ihr ein ernst zu nehmender Anführer seid!", 16)
	MovieWindow_Start(2, col.orange.."Mission", col.hgruen.."Flechtingen"..col.w.." scheint Euch für Gesetzlose und Räuber zu halten. Überzeugt sie vom Gegenteil:"..
	" Hebt eine Armee aus, die groß genug ist, um"..col.hgruen.."Flechtingen"..col.w.."davon zu überzeugen, dass Ihr ein ernst zu nehmender Anführer seid!", 16)

	DestroyEntity(gvMission.ExploreID_P1)
	DestroyEntity(gvMission.ExploreID_P2)

	StartCountdown(5, InitQuest_SetupArmy_P0, false)	-- one quest for both players (actually two quests but same condition)

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToLeaderP4(_player)
	gvMission.LeaderP4Player = _player
	MovieWindow_Start(gvMission.LeaderP4Player, col.hblau.."Anführer", "Wie es scheint, seid Ihr nicht so inkompetent in Sachen Kriegsführung wie unser Bürgermeister ..."..
	" @cr Falls Ihr uns mit ein paar Talern und gutem Eisen unterstützt, könnten wir bessere Kämpfer ausbilden.", 13)

	AddTribute({ playerId = gvMission.LeaderP4Player, text = ("Zahlt " .. dekaround(2500/gvDiffLVL) .. " Taler und " .. dekaround(5000/gvDiffLVL) .. " Eisen, damit die Stadt bessere Einheiten ausbilden kann."),
	cost = { Gold = dekaround(2500/gvDiffLVL), Iron = dekaround(5000/gvDiffLVL) }, Callback = ImproveLeadersP4 })
end

function ImproveLeadersP4()
	--PlayTributeSoundForPlayer(gvMission.LeaderP4Player)

	-- better armys
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, 4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, 4)
	for i = 1, 4 do
		pAI[4].armys[i].troopDescription.leaderType = Entities.PU_LeaderSword3
		pAI[4].armys[i].troopDescription.maxNumberOfSoldiers = 8
	end

	-- thanks to the players ...
	MovieWindow_Start(1, col.hblau.."Anführer", "Vielen Dank für die Unterstützung! Dank Euch können wir nun stärkere Kämpfer ausbilden. Als Zeichen unserer Dankbarkeit"..
	" erlauben wir Euch, uns Baupläne abzukaufen.", 13)
	MovieWindow_Start(2, col.hblau.."Anführer", "Vielen Dank für die Unterstützung! Dank Euch können wir nun stärkere Kämpfer ausbilden. Als Zeichen unserer Dankbarkeit"..
	" erlauben wir Euch, uns Baupläne abzukaufen.", 13)

	AddTribute({ playerId = 1, text = ("Kauft Baupläne für eine Kanonengießerei (" .. dekaround(4000/gvDiffLVL) .. " Taler)"), cost = { Gold = dekaround(4000/gvDiffLVL) }, Callback = BuyTechFoundryP1 })
	AddTribute({ playerId = 2, text = ("Kauft Baupläne für eine Kanonengießerei (" .. dekaround(4000/gvDiffLVL) .. " Taler)"), cost = { Gold = dekaround(4000/gvDiffLVL) }, Callback = BuyTechFoundryP2 })

end

function BuyTechFoundryP1()
	ResearchTechnology(Technologies.B_Foundry, 1)
	--PlayTributeSoundForPlayer(1)
end

function BuyTechFoundryP2()
	ResearchTechnology(Technologies.B_Foundry, 2)
	--PlayTributeSoundForPlayer(2)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitQuest_SetupArmy_P0()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_SETUPARMY
	quest.counter = 0
	quest.limit = 24
	quest.image = "StatisticsMain_Military"
	quest.position = GetPos("posCityGate")
	quest.condition = function(_questID)
		local leaders1 = Logic.GetNumberOfLeader(1)
		local leaders2 = Logic.GetNumberOfLeader(2)
		local leaders = leaders1 + leaders2

		MPQuest_SetCounter(_questID, leaders)

		if leaders >= 24 then
			return true
		end

		return false
	end
	quest.callback = ResolveQuest_SetupArmy_P0
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	if not gvMission.singleplayerMode then
		local quest2 = {}
		quest2.id = MPQuest_GetUniqueQuestId()
		quest2.player = 2
		quest2.text = QUEST_TEXT_SETUPARMY
		quest2.counter = 0
		quest2.limit = 24
		quest2.image = "StatisticsMain_Military"
		quest2.position = GetPos("posCityGate")
		quest2.condition = function(_questID)
			local leaders1 = Logic.GetNumberOfLeader(1)
			local leaders2 = Logic.GetNumberOfLeader(2)
			local leaders = leaders1 + leaders2

			MPQuest_SetCounter(_questID, leaders)

			if leaders >= 24 then
				return true
			end

			return false
		end
		quest2.callback = nil	-- do not trigger twice!
		quest2.completedSound = true
		MPQuest_AddQuest(quest2)
	end
end

function ResolveQuest_SetupArmy_P0()
	MovieWindow_Start(1, col.orange.."Mission", "Wunderbar, Eure Armee steht! Sendet nun Eure Truppen in die Stadt und unterstützt die Verteidiger!"..
	" Bemannt alle vier der oberen Stadttore. Das Haupthaus und das Gemeindezentrum dürfen nicht zerstört werden!", 16)
	MovieWindow_Start(2, col.orange.."Mission", "Wunderbar, Eure Armee steht! Sendet nun Eure Truppen in die Stadt und unterstützt die Verteidiger!"..
	" Bemannt alle vier der oberen Stadttore. Das Haupthaus und das Gemeindezentrum dürfen nicht zerstört werden!", 16)

	ReplaceEntity("gate5P4", Entities.XD_WallStraightGate)
	StartCountdown(16, InitQuest_DefendCity_P0, false)
	StartCountdown(30*60/gvDiffLVL, AllowVC3, false)
end

function AllowVC3()
	Message("Ihr könnt nun Eure Gemeindezentren zu Stadtzentren ausbauen!")
	for i = 1,2 do
		AllowTechnology(Technologies.UP2_Village, i)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- quest: help to defend the city
function InitQuest_DefendCity_P0()
	SetFriendly(1, 4)
	SetFriendly(2, 4)
	Logic.SetShareExplorationWithPlayerFlag(1, 4, 1)
	Logic.SetShareExplorationWithPlayerFlag(2, 4, 1)

	gvMission.mapEffects = {}
	for i = 1, 4 do
		local pos = GetPos("posGate"..i.."P4")
		gvMission.mapEffects[i] = Logic.CreateEffect(GGL_Effects.FXTerrainPointer, pos.X, pos.Y, 8)
		GUI.CreateMinimapMarker(pos.X, pos.Y, 0)	-- green
	end

	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_DEFENDCITY
	quest.counter = 0
	quest.limit = 4
	quest.image = "Command_Defend"
	quest.position = GetPos("posHQP4")
	quest.condition = function(_questID)
		local done = 0
		for i = 1, 4 do
			if AreEntitiesInArea(1, 0, GetPos("posGate"..i.."P4"), 2000, 1) or AreEntitiesInArea(2, 0, GetPos("posGate"..i.."P4"), 2000, 1) then
				done = done + 1
			end
		end

		MPQuest_SetCounter(_questID, done)

		if done == 4 then
			return true
		end

		return false
	end
	quest.callback = ResolveQuest_DefendCity_P0
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	if not gvMission.singleplayerMode then
		local quest2 = {}
		quest2.id = MPQuest_GetUniqueQuestId()
		quest2.player = 2
		quest2.text = QUEST_TEXT_DEFENDCITY
		quest2.counter = 0
		quest2.limit = 4
		quest2.image = "Command_Defend"
		quest2.position = GetPos("posHQP4")
		quest2.condition = function(_questID)
			local done = 0
			for i = 1, 4 do
				if AreEntitiesInArea(1, 0, GetPos("posGate"..i.."P4"), 2000, 1) or AreEntitiesInArea(2, 0, GetPos("posGate"..i.."P4"), 2000, 1) then
					done = done + 1
				end
			end

			MPQuest_SetCounter(_questID, done)

			if done == 4 then
				return true
			end

			return false
		end
		quest2.callback = nil	-- do not trigger twice!
		quest2.completedSound = true
		MPQuest_AddQuest(quest2)
	end
end

function ResolveQuest_DefendCity_P0()
	--LuaDebugger.Log("resolve defend city quest")

	if IsAlive("barr1_P4") then ChangePlayer("barr1_P4", 1) end
	if IsAlive("barr2_P4") then ChangePlayer("barr2_P4", 2) end
	if IsAlive("arch1_P4") then ChangePlayer("arch1_P4", 2) end
	if IsAlive("arch2_P4") then ChangePlayer("arch2_P4", 1) end

	for i = 1, 4 do
		local pos = GetPos("posGate"..i.."P4")
		Logic.DestroyEffect(gvMission.mapEffects[i])
		GUI.DestroyMinimapPulse(pos.X, pos.Y)
	end
	gvMission.mapEffects = nil
	StartCountdown(10, InitQuest_BuildTowers_P0, false)

	MovieWindow_Start(1, col.orange.."Mission", "Ausgezeichnet, haltet die Feinde an den Stadttoren zurück!"..
	" Verliert nun keine Zeit, verstärkt die Verteidigungsanlagen der Stadt: errichtet Verteidigungstürme!", 14)
	MovieWindow_Start(2, col.orange.."Mission", "Ausgezeichnet, haltet die Feinde an den Stadttoren zurück!"..
	" Verliert nun keine Zeit, verstärkt die Verteidigungsanlagen der Stadt: errichtet Verteidigungstürme!", 14)

	-- finally:
	--ResolveQuest_DefendCity_P0 = function() end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- independent from the previously selected option; this quest comes next!
function InitQuest_BuildTowers_P0()
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_BUILDTOWERS
	quest.counter = 0
	quest.limit = 12
	quest.image = "Build_Tower"
	quest.position = GetPos("posHQP4")
	quest.condition = function(_questID)
		local done = 0
		for i = 1, 4 do
			done = done + math.min(3, GetNumberOfEntitiesInAreaEx({1, 2, 4}, {Entities.PB_Tower2}, "posGate"..i.."P4", 2800))
		end

		MPQuest_SetCounter(_questID, done)

		if done == 12 then
			return true
		end

		return false
	end
	quest.callback = ResolveQuest_BuildTowers_P0
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	if not gvMission.singleplayerMode then
		local quest2 = {}
		quest2.id = MPQuest_GetUniqueQuestId()
		quest2.player = 2
		quest2.text = QUEST_TEXT_BUILDTOWERS
		quest2.counter = 0
		quest2.limit = 12
		quest2.image = "Build_Tower"
		quest2.position = GetPos("posHQP4")
		quest2.condition = function(_questID)
			local done = 0
			for i = 1, 4 do
				done = done + math.min(3, GetNumberOfEntitiesInAreaEx({1, 2, 4}, {Entities.PB_Tower2}, "posGate"..i.."P4", 2800))
			end

			MPQuest_SetCounter(_questID, done)

			if done == 12 then
				return true
			end

			return false
		end
		quest2.callback = nil
		quest2.completedSound = true
		MPQuest_AddQuest(quest2)
	end
end

function ResolveQuest_BuildTowers_P0()

	--LuaDebugger.Log("start 3rd chapter")
	StartThirdChapter()

	--ResolveQuest_BuildTowers_P0 = function() end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

--posArmyNorth

-- chapter 3: now the players have to attack
function StartThirdChapter()
	-- counter attack / defeat the two big enemies
	AddQuest_DefeatEnemies()

	-- give access to village centers (if still existing)
	if IsExisting("vc1P4") then ChangePlayer("vc1P4", 1) end
	if IsExisting("vc2P4") then ChangePlayer("vc2P4", 2) end

	local rnd1 = 360 + math.random(1, 7) * 30
	StartCountdown(rnd1 * gvDiffLVL, UpgradeEnemyArmys1, false)
	local rnd2 = math.random(1, 5) * 30 * gvDiffLVL
	StartCountdown(rnd2, StartSurpriseAttack, false)

	ControlGate = function()
		if IsDead("gateP7") then	-- gate to the northern path
			GUI.DestroyMinimapPulse(62000, 38900)
			StartCountdown(5, InitSupportingArmyNorth, false)
			return true
		end
	end
	StartSimpleJob("ControlGate")

	Logic.AddMercenaryOffer(GetEntityId("merc4"), Entities.PU_Serf, 20, ResourceType.Gold, dekaround(300/gvDiffLVL))
	Logic.AddMercenaryOffer(GetEntityId("merc4"), Entities.PU_Serf, 20, ResourceType.Gold, dekaround(300/gvDiffLVL))

	StartSimpleJob("VictoryJob")

end

function AddQuest_DefeatEnemies()
	local text = "Setzt den Angriffen ein Ende. Dies wird jedoch nur möglich sein, wenn die beiden Angreifer"..
	" vernichtend geschlagen werden. Achtet unbedingt darauf, das Haupthaus der Stadt"..col.hgruen.."Flechtingen"..col.w.."sowie das Gemeindezentrum nicht zu verlieren!"..
	" @cr @cr Eure Aufgabe: @cr @cr - Verteidigt die Stadt. Die Festung und das Gemeindezentrum dürfen nicht fallen! @cr - Besiegt die Burgen von Rikkard dem Furchtlosen im Westen und Thormund dem Starken im Osten!"..
	" @cr Seid jedoch gewarnt: beide Gegner verfügen über äußerst tödliche Kanonentürme. Ihr solltet Euch nach einer Möglichkeit umsehen, diese vor einem Großangriff auszuschalten!"

	Logic.AddQuest(1, QUEST_DEFEATENEMIESQUEST_1, MAINQUEST_OPEN, col.orange.."Aufgabe III", (text), 1)
	Logic.AddQuest(2, QUEST_DEFEATENEMIESQUEST_2, MAINQUEST_OPEN, col.orange.."Aufgabe III", (text), 1)

	CreateNpcMP("npcEngineer2", TalkToEngineer2, nil)	-- info/quest: destroy magicMachine
	CreateNpcMP("npcLeaderP4", TalkToLeaderP4, nil)		-- upgrade troops + buy foundry technology

	local info_text = "Sprecht mit den Bewohnern der Stadt bevor Ihr zum Angriff übergeht!"

	MovieWindow_Start(1, col.orange.."Mission", info_text, 12)
	MovieWindow_Start(2, col.orange.."Mission", info_text, 12)

	StartSimpleJob("SJ_DefeatP4")
	local pos6 = GetPos("HQP6")
	local pos7 = GetPos("HQP7")
	GUI.CreateMinimapPulse(pos6.X, pos6.Y, 3)	-- red
	GUI.CreateMinimapPulse(pos7.X, pos7.Y, 3)	-- red

	for player = 6,7 do
		MapEditor_SetupAI(player, round(2/gvDiffLVL), 35000, round(3/gvDiffLVL), "posHQP" .. player, 3, 0)
	end
	ControlHQP6 = function()
		if IsDead("HQP6") then
			local pos = GetPos("HQP6")
			GUI.DestroyMinimapPulse(pos.X, pos.Y)
		end
	end
	StartSimpleJob("ControlHQP6")

	ControlHQP7 = function()
		if IsDead("HQP7") then
			local pos = GetPos("HQP7")
			GUI.DestroyMinimapPulse(pos.X, pos.Y)
		end
	end
	StartSimpleJob("ControlHQP7")

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitSupportingArmyNorth()
	pAI[4].armys[6] = {
		player = 4,
		id = 6,
		strength = round(12/gvDiffLVL),
		position = GetPos("posArmyNorth"),	-- spawn location
		rodeLength = 12500,
		defensePosition = GetPos("posHQP4"),
		troopDescription = {maxNumberOfSoldiers = 4, minNumberOfSoldiers = 0, experiencePoints = VERYHIGH_EXPERIENCE, leaderType = Entities.PU_LeaderHeavyCavalry2},
	}
	SetupArmy(pAI[4].armys[6])
	for i = 1, 8 do
		EnlargeArmy(pAI[4].armys[6], pAI[4].armys[6].troopDescription)
	end

	ControlArmyP4North = function()
		if Counter.Tick2("ArmyControllerP4_Extra", 4) then
			local army = pAI[4].armys[6]
			if IsDead(army) then
				return true
			else
				Advance(army)
			end
		end
	end
	StartSimpleJob("ControlArmyP4North")

	MovieWindow_Start(1, col.orange.."Mission", "Sehr gut, Ihr habt den Weg nach Norden geöffnet!"..
	" @cr Nun kann die Verstärkung, die der Bürgermeister engagiert hat zu uns stoßen.", 13)
	MovieWindow_Start(2, col.orange.."Mission", "Sehr gut, Ihr habt den Weg nach Norden geöffnet!"..
	" @cr Nun kann die Verstärkung, die der Bürgermeister engagiert hat zu uns stoßen.", 13)

	Sound.PlayGUISound(Sounds.fanfare, 70)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function UpgradeEnemyArmys1()
	if IsDead("HQP6") and IsDead("HQP7") then return end

	--LuaDebugger.Log("Upgrade Enemy Armys (1)")

	for p = 6, 7 do
		pAI[p].armys[1].troopDescription.leaderType = Entities.PU_LeaderSword3
		pAI[p].armys[1].troopDescription.maxNumberOfSoldiers = 8

		pAI[p].armys[2].troopDescription.leaderType = Entities.PU_LeaderPoleArm3
		pAI[p].armys[2].troopDescription.maxNumberOfSoldiers = 8

		pAI[p].armys[3].troopDescription.leaderType = Entities.PU_LeaderBow3
		pAI[p].armys[3].troopDescription.maxNumberOfSoldiers = 8

		pAI[p].armys[4].troopDescription.leaderType = Entities.PU_LeaderBow3
		pAI[p].armys[4].troopDescription.maxNumberOfSoldiers = 8
	end

	local rnd = (300 * gvDiffLVL) + math.random(3, 7) * 30
	StartCountdown(rnd, UpgradeEnemyArmys2, false)
end

function UpgradeEnemyArmys2()
	if IsDead("HQP6") and IsDead("HQP7") then return end

	--LuaDebugger.Log("Upgrade Enemy Armys (2)")

	for p = 6, 7 do
		pAI[p].armys[1].troopDescription.leaderType = Entities.PU_LeaderSword4
		pAI[p].armys[1].troopDescription.maxNumberOfSoldiers = 12

		pAI[p].armys[2].troopDescription.leaderType = Entities.PU_LeaderPoleArm4
		pAI[p].armys[2].troopDescription.maxNumberOfSoldiers = 12

		pAI[p].armys[3].troopDescription.leaderType = Entities.PU_LeaderBow4
		pAI[p].armys[3].troopDescription.maxNumberOfSoldiers = 12

		pAI[p].armys[4].troopDescription.leaderType = Entities.PU_LeaderBow4
		pAI[p].armys[4].troopDescription.maxNumberOfSoldiers = 12
		
		MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(5/gvDiffLVL)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToEngineer2()
	MovieWindow_Start(1, col.hblau.."Ingenieur", "Mächtige Türme oh ja oha ja ... kein Durchkommen. Absolut tödlich!"..
	" @cr Eine Apperatur versorgt sie mit Energie. Sabotiert diese und dann ... am besten schleift Ihr diese steinernen Bestien.", 16)
	MovieWindow_Start(2, col.hblau.."Ingenieur", "Mächtige Türme oh ja oha ja ... kein Durchkommen. Absolut tödlich!"..
	" @cr Eine Apperatur versorgt sie mit Energie. Sabotiert diese und dann ... am besten schleift Ihr diese steinernen Bestien.", 16)

	local pos = GetPos("npcEngineer2")
	GUI.ScriptSignal(pos.X, pos.Y, 2)	-- white

	StartCountdown(17, InitQuest_DestroyMagicMachine_P0, false)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitQuest_DestroyMagicMachine_P0()
	MakeVulnerable("magicMachine")

	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_DESTROYMAGICMACHINE
	quest.image = "PowerPlant_EnergyIcon"
	quest.position = GetPos("magicMachine")
	quest.condition = function()
		return IsDead("magicMachine")
	end
	quest.callback = ResolveQuest_DestroyMagicMachine_P0
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	if not gvMission.singleplayerMode then
		local quest2 = {}
		quest2.id = MPQuest_GetUniqueQuestId()
		quest2.player = 2
		quest2.text = QUEST_TEXT_DESTROYMAGICMACHINE
		quest2.image = "PowerPlant_EnergyIcon"
		quest2.position = GetPos("magicMachine")
		quest2.condition = function()
			return IsDead("magicMachine")
		end
		quest2.callback = nil
		quest2.completedSound = true
		MPQuest_AddQuest(quest2)
	end

	MovieWindow_Start(1, col.orange.."Mission", "Zerstört die seltsame Maschine, welche den Kanonentürmen ihre Kraft verleiht!"..
	" @cr Nutzt dazu am besten eine Einheit, die sich unbemerkt durch gegnerische Reihen schleichen kann.", 15)
	MovieWindow_Start(2, col.orange.."Mission", "Zerstört die seltsame Maschine, welche den Kanonentürmen ihre Kraft verleiht!"..
	" @cr Nutzt dazu am besten eine Einheit, die sich unbemerkt durch gegnerische Reihen schleichen kann.", 15)

	local pos = GetPos("magicMachine")
	gvMission.ExploreID_P2 = MPTools_ExploreArea(2, pos, 1200)
	gvMission.ExploreID_P1 = MPTools_ExploreArea(1, {X = pos.X + 1, Y = pos.Y + 1}, 1200)
	GUI.CreateMinimapMarker(pos.X, pos.Y, 3)	-- red

	AllowTechnology(Technologies.MU_Thief, 1)
	AllowTechnology(Technologies.MU_Thief, 2)
end

function ResolveQuest_DestroyMagicMachine_P0()
	for i = 1, 14 do
		RemoveSuperTower("sTower"..i)
	end
	gvMission.superTowersActive = false
	DestroyEntity(gvMission.ExploreID_P1)
	DestroyEntity(gvMission.ExploreID_P2)
	local pos = GetPos("magicMachine")
	GUI.DestroyMinimapPulse(pos.X, pos.Y)

	MovieWindow_Start(1, col.orange.."Mission", "Wunderbar! Die Türme scheinen sich tatsächlich irgendwie verändert zu haben ... "..
	" @cr Nehmt nun Eure Truppen und heizt den beiden Herrschaften ordentlich ein!", 12)
	MovieWindow_Start(2, col.orange.."Mission", "Wunderbar! Die Türme scheinen sich tatsächlich irgendwie verändert zu haben ... "..
	" @cr Nehmt nun Eure Truppen und heizt den beiden Herrschaften ordentlich ein!", 12)

	EnableCityNpc()	-- v 1.3: now the player can talk to the farmer and the cavalry NPC

	--ResolveQuest_DestroyMagicMachine_P0 = function() end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToCavalry()
	local _text = "Ihr sucht nach einem Weg berittene Einheiten ausbilden zu können? Nun sicher ... ich kenne mich da wohl aus."..
	" Ich mache Euch ein Angebot: Ihr gebt mir ein paar Taler und ich zeige Euren Siedlern, wie man Pferde versorgt und Reiter ausbildet."
	MovieWindow_Start(1, col.hblau.."Reiter", _text, 14)
	MovieWindow_Start(2, col.hblau.."Reiter", _text, 14)

	--MovieWindow_Start(2, col.hblau.."Reiter", "Ihr sucht nach einem Weg berittene Einheiten ausbilden zu können?"..
	--" @cr Baut mir 6 Reiterstatuen. Im Gegenzug zeige ich Euren Siedlern, wie man Pferde versorgt und Reiter ausbildet.", 13)

	AddTribute({ playerId = 1, text = ("Zahlt dem Reiter " .. dekaround(2500/gvDiffLVL) .. " Taler, um Stallungen bauen zu können."), cost = { Gold = dekaround(2500/gvDiffLVL) }, Callback = BuyTechCavalryP1 })
	AddTribute({ playerId = 2, text = ("Zahlt dem Reiter " .. dekaround(2500/gvDiffLVL) .. " Taler, um Stallungen bauen zu können."), cost = { Gold = dekaround(2500/gvDiffLVL) }, Callback = BuyTechCavalryP2 })
	--InitQuest_BuildHorseStatues_P0()
end

function BuyTechCavalryP1()
	ResearchTechnology(Technologies.B_Stables, 1)
	--PlayTributeSoundForPlayer(1)
end

function BuyTechCavalryP2()
	ResearchTechnology(Technologies.B_Stables, 2)
	--PlayTributeSoundForPlayer(2)
end

function GetNumberOfEntitiesOfTypeOfPlayerConstructionComplete(_player, _type)
	local entities = {Logic.GetPlayerEntities(_player, _type, 40)}
	local count = 0
	for i = 1, entities[1] do
		if Logic.IsConstructionComplete(entities[i+1]) == 1 then
			count = count + 1
		end
	end
	return count
end

function InitQuest_BuildHorseStatues_P0()	-- deprecated
	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_BUILDHORSESTATUES
	quest.image = "Build_Beautification03"
	quest.counter = 0
	quest.limit = 6
	quest.condition = function(_questID)
		local build = GetNumberOfEntitiesOfTypeOfPlayerConstructionComplete(1, Entities.PB_Beautification03) + GetNumberOfEntitiesOfTypeOfPlayerConstructionComplete(2, Entities.PB_Beautification03)
		MPQuest_SetCounter(_questID, build)
		return build > 5
	end
	quest.callback = ResolveQuest_BuildHorseStatues_P0
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	local quest2 = {}
	quest2.id = MPQuest_GetUniqueQuestId()
	quest2.player = 2
	quest2.text = QUEST_TEXT_BUILDHORSESTATUES
	quest2.image = "Build_Beautification03"
	quest2.counter = 0
	quest2.limit = 6
	quest2.condition = function(_questID)
		local build = GetNumberOfEntitiesOfTypeOfPlayerConstructionComplete(1, Entities.PB_Beautification03) + GetNumberOfEntitiesOfTypeOfPlayerConstructionComplete(2, Entities.PB_Beautification03)
		MPQuest_SetCounter(_questID, build)
		return build > 5
	end
	quest2.callback = nil
	quest2.completedSound = true
	MPQuest_AddQuest(quest2)
end

function ResolveQuest_BuildHorseStatues_P0()
	AllowTechnology(Technologies.B_Stables, 1)
	AllowTechnology(Technologies.B_Stables, 2)

	MovieWindow_Start(1, col.hblau.."Reiter", "Sind sie nicht hübsch anzusehen? Fast so stattlich wie ihre Vorbilder ..."..
	" @cr Damit habt Ihr mich überzeugt. Eure Arbeiter können nun auch Stallungen bauen sodass Ihr Reiter ausbilden könnt.", 13)
	MovieWindow_Start(2, col.hblau.."Reiter", "Sind sie nicht hübsch anzusehen? Fast so stattlich wie ihre Vorbilder ..."..
	" @cr Damit habt Ihr mich überzeugt. Eure Arbeiter können nun auch Stallungen bauen sodass Ihr Reiter ausbilden könnt.", 13)

	--ResolveQuest_BuildHorseStatues_P0 = function() end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function TalkToFarmer()
	local text = "Sie haben alle Felder zerstört. Unsere ganze Ernte ist dahin!"..
	" Nun müssen wir unsere Vorräte aufzehren ... es sei denn, Ihr findet jemanden, der uns Nahrung verkauft."..
	" @cr "..col.beig.."Hinweis: Es gibt eine Handelsroute im Osten, welche ihr nutzen könntet!"

	MovieWindow_Start(1, col.hblau.."Bauer", text, 15)
	MovieWindow_Start(2, col.hblau.."Bauer", text, 15)

	Move("npcFarmer", "posMarketP4", 800)
	InitQuest_FoodSupply_P0()
	CreateNpcMP("npcMerc4", TalkToMerc4, nil)
end

-- now for both players
function InitQuest_FoodSupply_P0()
	gvMission.foodSupplied = 0

	local quest = {}
	quest.id = MPQuest_GetUniqueQuestId()
	quest.player = 1
	quest.text = QUEST_TEXT_FOODSUPPLY
	quest.image = "Build_Farm"
	quest.counter = 0
	quest.limit = 8
	quest.position = GetPos("posMarketP4")
	quest.condition = function(_questID)
		MPQuest_SetCounter(_questID, gvMission.foodSupplied)
		return gvMission.foodSupplied > 7
	end
	quest.callback = ResolveQuest_FoodSupply
	quest.completedSound = true
	MPQuest_AddQuest(quest)

	local quest2 = {}
	quest2.id = MPQuest_GetUniqueQuestId()
	quest2.player = 2
	quest2.text = QUEST_TEXT_FOODSUPPLY
	quest2.image = "Build_Farm"
	quest2.counter = 0
	quest2.limit = 8
	quest2.position = GetPos("posMarketP4")
	quest2.condition = function(_questID)
		MPQuest_SetCounter(_questID, gvMission.foodSupplied)
		return gvMission.foodSupplied > 7
	end
	quest2.callback = nil
	quest2.completedSound = true
	MPQuest_AddQuest(quest2)
end

function TalkToMerc4()
	local text = "Ihr wollt Nahrungsmittel kaufen? Nun was darf es denn sein?"..
	" Ich habe im Angebot: ganz vortreffliches Brot, das beste Hammelfleisch weit und breit und reichlich Obst und ... "..
	" nun ja, seht Euch ruhig um!"
	MovieWindow_Start(1, col.hblau.."Händler", text, 13)
	MovieWindow_Start(2, col.hblau.."Händler", text, 13)

	gvMission.foodSupplyTributeID = {}
	gvMission.foodSupplyTributeID[1] = AddTribute({ playerId = 1, text = ("Kauft eine Ladung"..col.hgruen.."Nahrungsmittel"..col.w.."für " .. dekaround(1600/gvDiffLVL) .. " Taler."), cost = { Gold = dekaround(1600/gvDiffLVL) }, Callback = AcceptTrade_Merc4 })
	gvMission.foodSupplyTributeID[2] = AddTribute({ playerId = 2, text = ("Kauft eine Ladung"..col.hgruen.."Nahrungsmittel"..col.w.."für " .. dekaround(1600/gvDiffLVL) .. " Taler."), cost = { Gold = dekaround(1600/gvDiffLVL) }, Callback = AcceptTrade_Merc4 })
end

function AcceptTrade_Merc4(parameters)
	local player = parameters.playerId	-- the tribute playerId
	MovieWindow_Start(player, col.hblau.."Händler", "Wunderbar, die Lieferung ist auf dem Weg!"..
	" Sorgt nur dafür, dass sie heil ankommt!", 7)
	if gvMission.foodSupplied < 8 then
		gvMission.foodSupplyTributeID[player] = AddTribute({ playerId = player, text = ("Kauft eine Ladung"..col.hgruen.."Nahrungsmittel"..col.w.."für " .. dekaround(1600/gvDiffLVL) .. " Taler."), cost = { Gold = dekaround(1600/gvDiffLVL) }, Callback = AcceptTrade_Merc4 })
	end

	-- create travelling salesman and move him to the city
	local pos = GetPos("posMerc4")
	local id = Logic.CreateEntity(Entities.PU_Travelling_Salesman, pos.X, pos.Y, 0, 4)
	ControlMerch = function(_id)
		Move(_id, "posMarketP4", 100)
		if IsNear(_id, "posMarketP4", 500) then
			gvMission.foodSupplied = gvMission.foodSupplied + 1
			MovieWindow_Start(1, col.orange.."Mission", col.beig.."Eine Lieferung mit"..col.hgruen.."Nahrung"..col.beig.."ist eingetroffen!", 7)
			MovieWindow_Start(2, col.orange.."Mission", col.beig.."Eine Lieferung mit"..col.hgruen.."Nahrung"..col.beig.."ist eingetroffen!", 7)
			ReplaceEntity(_id, Entities.PU_Trader)
			return true
		end

		if IsDead(_id) then
			MovieWindow_Start(1, col.orange.."Mission", col.beig.."Ein angeheuerter Händler hat es nicht bis ans Ziel geschafft!", 8)
			MovieWindow_Start(2, col.orange.."Mission", col.beig.."Ein angeheuerter Händler hat es nicht bis ans Ziel geschafft!", 8)
			return true
		end
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlMerch", 1, {}, {id})
end

function ResolveQuest_FoodSupply()
	local text_hint_1 = "Seid aufs herzlichste gedankt."..
	" Damit habt Ihr uns einen großen Dienst erwiesen! Wenn ich Euch einen kleinen Hinweis geben darf: ..."
	local text_hint_2 = "Unser Bürgermeister ist nicht sonderlich erfahren in militärischen Fragen ..."..
	" doch pflegt er zahlreiche Kontakte zu unseren Nachbarstädten. Wie ich hörte, ist er nach Norden aufgebrochen um Verstärkung aufzutreiben."..
	" Leider ist der Weg mittlerweile verrammelt worden. Vielleicht findet Ihr ja eine Möglichkeit, dieses Tor zu öffnen."

	local text_nohint =  "Seid aufs herzlichste gedankt."..
	" Damit habt Ihr uns einen großen Dienst erwiesen! Wie ich sehe, habt ihr bereits den Weg im Osten geöffnet, sodass die Verbündeten zur Hilfe eilen können - wunderbar!"

	if IsExisting("gateP7") then
		MovieWindow_Start(1, col.hblau.."Bauer", text_hint_1, 13)
		MovieWindow_Start(2, col.hblau.."Bauer", text_hint_1, 13)

		MovieWindow_Start(1, col.hblau.."Bauer", text_hint_2, 18)
		MovieWindow_Start(2, col.hblau.."Bauer", text_hint_2, 18)

	else
		-- player already found the gate + opened it
		MovieWindow_Start(1, col.hblau.."Bauer", text_nohint, 13)
		MovieWindow_Start(2, col.hblau.."Bauer", text_nohint, 13)
	end

	GUI.ScriptSignal(62000, 38900, 2)	-- white
	MPTools_ExploreArea(1, {X = 62000, Y = 38900}, 1600)
	MPTools_ExploreArea(2, {X = 62001, Y = 38901}, 1600)
	GUI.CreateMinimapMarker(62000, 38900, 2)	-- white

	-- remove existing tributes?
	Logic.RemoveTribute(1, gvMission.foodSupplyTributeID[1])
	Logic.RemoveTribute(2, gvMission.foodSupplyTributeID[2])

	-- now farmers may come again ...
	EnableFarms_P4()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- city (player 4) has not enough food due to the fire ... make farmers stop working (just a little extra detail that no one will notice ... I guess)
function DisableFarms_P4()
	local farms1 = {Logic.GetPlayerEntities(4, Entities.PB_Farm1, 16)}
	local farms2 = {Logic.GetPlayerEntities(4, Entities.PB_Farm2, 16)}
	local farms3 = {Logic.GetPlayerEntities(4, Entities.PB_Farm3, 16)}

	for i = 2, farms1[1] + 1 do
		local id = farms1[i]
		--Message("close farm: " .. id)
		Logic.SetCurrentMaxNumWorkersInBuilding(id, 0)
	end
	for i = 2, farms2[1] + 1 do
		local id = farms2[i]
		Logic.SetCurrentMaxNumWorkersInBuilding(id, 0)
	end
	for i = 2, farms3[1] + 1 do
		local id = farms3[i]
		Logic.SetCurrentMaxNumWorkersInBuilding(id, 0)
	end
end

-- ... and allow them to work again when food is supplied
function EnableFarms_P4()
	local farms1 = {Logic.GetPlayerEntities(4, Entities.PB_Farm1, 16)}
	local farms2 = {Logic.GetPlayerEntities(4, Entities.PB_Farm2, 16)}
	local farms3 = {Logic.GetPlayerEntities(4, Entities.PB_Farm3, 16)}

	for i = 2, farms1[1] + 1 do
		local id = farms1[i]
		local maxNumWorkers = Logic.GetMaxNumWorkersInBuilding(id)
		Logic.SetCurrentMaxNumWorkersInBuilding(id, maxNumWorkers)
	end
	for i = 2, farms2[1] + 1 do
		local id = farms2[i]
		local maxNumWorkers = Logic.GetMaxNumWorkersInBuilding(id)
		Logic.SetCurrentMaxNumWorkersInBuilding(id, maxNumWorkers)
	end
	for i = 2, farms3[1] + 1 do
		local id = farms3[i]
		local maxNumWorkers = Logic.GetMaxNumWorkersInBuilding(id)
		Logic.SetCurrentMaxNumWorkersInBuilding(id, maxNumWorkers)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DefeatP1()
	if IsDead("HQP1") then
		Logic.PlayerSetGameStateToLost(1)
		MultiplayerTools.RemoveAllPlayerEntities( 1 )
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("HQP2") then
		Logic.PlayerSetGameStateToLost(2)
		MultiplayerTools.RemoveAllPlayerEntities( 2 )
		return true
	end
end

-- started later
function SJ_DefeatP4()
	if IsDead("HQP4") or IsDead("vcP4") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.SuspendAllEntities()	-- not perfect: entities that are created after this call will be selectable + buildings are still selectable
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("HQP6") and IsDead("HQP7") then
		StartCountdown(10, Victory, false)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()
	for p = 1, 2 do
		SetHostile(p, 3)
		SetHostile(p, 6)
		SetHostile(p, 7)
	end
	SetFriendly(1, 2)
	SetHostile(4, 3)
	SetHostile(4, 6)
	SetHostile(4, 7)

	local R, G, B = GUI.GetPlayerColor( 1 )
	SetPlayerName(1, "@color:"..R..","..G..","..B.." "..UserTool_GetPlayerName(1))
	local R, G, B = GUI.GetPlayerColor( 2 )
	SetPlayerName(2, "@color:"..R..","..G..","..B.." "..UserTool_GetPlayerName(2))

	SetPlayerName(3, "Banditenlager")			-- first smal camps and later bigger camps
	SetPlayerName(4, "Flechtingen")				-- medium sized castle/city
	SetPlayerName(5, "Dorfbewohner")			-- neutral village buildings
	SetPlayerName(6, "Rikkard der Furchtlose")	-- big boss enemy west
	SetPlayerName(7, "Thormund der Starke")		-- big boss enemy east
	-- 8 = neutral

	Display.SetPlayerColorMapping(3, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(8, NPC_COLOR)

	-- colors
	--[[
	Display.SetPlayerColorMapping(3, NEPHILIM_COLOR)	-- red
	Display.SetPlayerColorMapping(4, NEPHILIM_COLOR)	-- red
	Display.SetPlayerColorMapping(5, ENEMY_COLOR1)		-- violett

	local R, G, B = GUI.GetPlayerColor( 3 )
	SetPlayerName(3, "@color:"..R..","..G..","..B.." Ruttford")
	local R, G, B = GUI.GetPlayerColor( 5 )
	SetPlayerName(5, "@color:"..R..","..G..","..B.." Burg KrÃ¤hennest")
	--]]
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function InitWeather()

	-- no winter!
	AddPeriodicSummer(10)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitTechTables()

	_TechTable = {
	Technologies.T_SoftArcherArmor,
	Technologies.T_LeatherMailArmor,
	Technologies.T_Fletching,
	Technologies.T_WoodAging,
	Technologies.T_ChainMailArmor,
	Technologies.T_LeatherArcherArmor,
	Technologies.T_MasterOfSmithery,
	Technologies.T_BodkinArrow,
	Technologies.T_Turnery,
	Technologies.T_BetterTrainingArchery,
	Technologies.T_BetterTrainingBarracks,
	Technologies.T_FleeceArmor,
	Technologies.T_FleeceLinedLeatherArmor,
	Technologies.T_LeadShot,
	Technologies.T_Sights,
	Technologies.T_BlisteringCannonballs,
	Technologies.T_BetterChassis,
	Technologies.T_EnhancedGunPowder
	}

	for i = 1, table.getn(_TechTable) do
		ResearchTechnology(_TechTable[i], 4)
		ResearchTechnology(_TechTable[i], 6)
		ResearchTechnology(_TechTable[i], 7)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function AddPages( _briefing )
    local AP = function(_page) table.insert(_briefing, _page) return _page end
    local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)) end
    return AP, ASP
end

function CreateShortPage( _entity, _title, _text, _dialog, _explore)
    local page = {
        title = _title,
        text = _text,
        position = GetPosition( _entity ),
		action = function ()Display.SetRenderFogOfWar(0) end
    }
    if _dialog then
            if type(_dialog) == "boolean" then
                  page.dialogCamera = true
            elseif type(_dialog) == "number" then
                  page.explore = _dialog
            end
      end
    if _explore then
            if type(_explore) == "boolean" then
                  page.dialogCamera = true
            elseif type(_explore) == "number" then
                  page.explore = _explore
            end
      end
    return page
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function NewOnGameLoaded()
	Mission_OnSaveGameLoaded_Orig7 = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()

		Mission_OnSaveGameLoaded_Orig7()

		-- playercolors
		Display.SetPlayerColorMapping(3, ROBBERS_COLOR)
		Display.SetPlayerColorMapping(8, NPC_COLOR)

		-- minimap buttons -> quests
		XGUIEng.SetWidgetSize("MinimapButtons_Normal", 18, 18)
		XGUIEng.SetWidgetSize("MinimapButtons_Resource", 18, 18)
		XGUIEng.SetWidgetSize("MinimapButtons_Tactic", 18, 18)
		XGUIEng.TransferMaterials("MainMenuSaveScrollUp", "MinimapButtons_Normal")
		XGUIEng.TransferMaterials("Hero10_SniperAttack", "MinimapButtons_Resource")	--WorkerBackToBuilding
		XGUIEng.TransferMaterials("MainMenuSaveScrollDown", "MinimapButtons_Tactic")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function EV_ON_ENTITY_CREATED()
	local ent_ID = Event.GetEntityID()
	local ent_typ = Logic.GetEntityTypeName(Logic.GetEntityType(ent_ID))
	local ent_P = Logic.EntityGetPlayer(ent_ID)
	local ent_pos = GetPosition(ent_ID)

	-- do not use this while fire is burning
	if ent_typ == "XD_TreeStump1" and not gvMission.fireActive then

		if math.random(1, 5) > 1 then
			local plants = {"XD_Bush1", "XD_Bush2", "XD_Bush3", "XD_Bush4", "XD_Plant1", "XD_Plant4", "XD_Flower1", "XD_Flower2", "XD_Flower3", "XD_Flower4", "XD_Flower5", "XD_Driftwood1", "XD_Driftwood2"}
			local newEnt = Entities[ plants[math.random(1, table.getn(plants))] ]
			Logic.CreateEntity(newEnt, ent_pos.X, ent_pos.Y, math.random(1, 360), 8)
			DestroyEntity(ent_ID)
		end

	-- increase the amount of wood gained from trees
	elseif ent_typ == "XD_ResourceTree" then
		Logic.SetResourceDoodadGoodAmount(ent_ID, (Logic.GetResourceDoodadGoodAmount(ent_ID)*math.random(2,3)))
	end

	if ent_P == 1 or ent_P == 2 then

		if Logic.IsHero(ent_ID) == 1 then
			table.insert(HeroTable, ent_ID)
			--MakeInvulnerable(ent_ID)
		end

	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function EV_ON_ENTITY_HURT()
	local att = Event.GetEntityID1()
	local tar = Event.GetEntityID2()
	local att_type = Logic.GetEntityTypeName(Logic.GetEntityType(att))
	local tar_type = Logic.GetEntityTypeName(Logic.GetEntityType(tar))
	local att_PID = GetPlayer(att)
	local tar_PID = GetPlayer(tar)
	local att_name = Logic.GetEntityName(att)

	-- make walls only vulnerable to cannons (vehicles)
	--if tar == GetEntityId("gate1") then
	if (Logic.IsEntityInCategory(tar, EntityCategories.Wall) == 1) then
		--if (Logic.IsEntityInCategory(att, EntityCategories.Cannon) == 1) then	-- does also include cannon + balista towers
		if att_type == "PV_Cannon2" or att_type == "PV_Cannon4" or att_type == "PV_Cannon6" then
			MakeVulnerable(tar)
			Logic.HurtEntity(tar, 25)
			MakeInvulnerable(tar)
		else
			MakeInvulnerable(tar)
		end
	end

	-- super towers (huge damage)
	-- ?figure out if it is one of these in gvSuperTowers?
	-- see Logic.GetFoundationTop
	-- alternative: all towers are active/inactive -> omit to perform all the table searching...
	if att_type == "PB_DarkTower3_Cannon" then
		if gvMission.superTowersActive then
			if Logic.IsHero(tar) == 1 then
				Logic.HurtEntity(tar, 400)
			else
				if Logic.IsBuilding(tar) == 0 then
					local pos = GetPos(tar)
					Logic.CreateEffect(GGL_Effects.FXDie, pos.X, pos.Y, tar_PID)
				end
				DestroyEntity(tar)
			end
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function GetClosestEnemy(id)	-- for now this is the id of one troop of the army

	local p = GetPlayer(id)
	--local id = 0
	local distance = 0
	local pos = GetPos(id)
	closestOfPlayers = {}
	for i = 1, 8 do
		if p ~= i then
			if Logic.GetDiplomacyState( p, i) == Diplomacy.Hostile then
				--GetClosestBuildingOfPlayer(pos, i)	--> maybe use a global building table here (OnCreatedTrigger)
				local id
				--LuaDebugger.Log("check for "..i)
				id = GetClosestUnitOfPlayer(pos, i)
				if id ~= 0 then
					table.insert(closestOfPlayers, id)
					--LuaDebugger.Log("insert "..id)
				end
			end
		end
	end

	local n = table.getn(closestOfPlayers)
	if n > 0 then
		distance = GetDistance(pos, GetPos(closestOfPlayers[1]))
		id = closestOfPlayers[1]
		--LuaDebugger.Log("id1 "..id)
		for j = 2, n do
			if GetDistance(pos, GetPos(closestOfPlayers[j])) < distance then
				distance = GetDistance(pos, GetPos(closestOfPlayers[j]))
				id = closestOfPlayers[j]
				--LuaDebugger.Log("id2 "..id)
			end
		end
	end

	return id

end

function GetClosestUnitOfPlayer(pos, player)

	local d = 0
	--local id = 0
	for i = 1, Logic.GetNumberOfLeader(player) do
		LeaderID = Logic.GetNextLeader(player, LastLeaderID)
		if LeaderID ~= 0 then
			local leaderPos = GetPos(LeaderID)
			local distance = GetDistance(pos, leaderPos)
			if d == 0 then
				d = distance
				id = LeaderID
			else
				if distance < d then
					d = distance
					id = LeaderID
				end
			end
		end
		LastLeaderID = LeaderID
	end
	local t = {}
	Logic.GetHeroes(player, t)
	if t[1] ~= nil then
		for i = 1, table.getn(t) do
			local heroPos = GetPos(t[i])
			local distance = GetDistance(pos, heroPos)
			if (d == 0) and (not IsDead(t[i])) then
				d = distance
				id = t[i]
			else
				if distance < d then
					d = distance
					id = t[i]
				end
			end
		end
	end

	return id

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function CreateChestMP(_pos, _callback)
	if Chests == nil then Chests = {} end
	gvMission.chests = (gvMission.chests or 0) + 1
	--assert(type(_pos) == "string", "CreateChestMP: _pos must be a string")
	assert(IsDead("chest_".._pos), "CreateChestMP: a chest is already created there")
	assert(_callback ~= nil, "CreateChestMP: _callback is nil")
	local pos = GetPos(_pos)
	SetEntityName(Logic.CreateEntity(Entities.XD_ChestClose, pos.X, pos.Y, 0, 8), "chest_".._pos)
	table.insert(Chests, { pos = _pos, callback = _callback })	-- pos is a string
end

function SJ_ControlChests()
	for pid = 1,2 do
		for index = 1, table.getn(Chests) do
			if Chests[index] then
				local pos = GetPos(Chests[index].pos)
				local entities = {Logic.GetPlayerEntitiesInArea(pid, 0, pos.X, pos.Y, 350, 16)}
				for i = 2, table.getn(entities) do
					if Logic.IsHero(GetEntityId(entities[i])) == 1 then
						ReplaceEntity("chest_"..Chests[index].pos, Entities.XD_ChestOpen)
						Sound.PlayGUISound( Sounds.OnKlick_Select_erec, 70 )
						Sound.Play2DQueuedSound( Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_01, 90 )
						Chests[index].callback()
						table.remove(Chests, index)
						gvMission.chestsFound = (gvMission.chestsFound or 0) + 1
						break
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- v3
function CreateNpcMP(_name, _callback, _player)
	if npcTable == nil then npcTable = {} end
	if npcTable[_name] then
		--LuaDebugger.Log("CreateNpcMP Error - there is already an NPC with this name!")
		--LuaDebugger.Log(_name)
		return false
	end
	npcTable[_name] = { name = _name, callback = _callback, wantPlayer = _player, talkedToPlayers = {}, interactPlayer = 0 }
	--table.insert(npcTable, { name = _name, callback = _callback, player = _player, talkedTo = false })
	EnableNpcMarker(_name)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "NPC_MP_Trigger_Condition", "NPC_MP_Trigger_Action", 1, {_name}, {_name})
end

function NPC_MP_Trigger_Condition(index)	-- condition function; index is now the name string
	if npcTable[index] then
		for i = 1, table.getn(HeroTable) do
			if IsNear(HeroTable[i], npcTable[index].name, 500) then
				local heroPlayer = GetPlayer(HeroTable[i])
				--if npcTable[index].wantPlayer == nil or heroPlayer == npcTable[index].wantPlayer or IsValueInTable(heroPlayer, npcTable[index].wantPlayer) then
				if NPC_MP_PlayerCheck(heroPlayer, npcTable[index].wantPlayer) then
					--LuaDebugger.Log("pass heroPlayer to callback: "..heroPlayer)
					LookAt(npcTable[index].name, HeroTable[i])
					npcTable[index].interactPlayer = heroPlayer
					DisableNpcMarker(npcTable[index].name)
					return true
				else
					-- if the player has not already tried to talk to this NPC ...
					--if not npcTable[index].talkedTo then
					if not IsValueInTable(heroPlayer, npcTable[index].talkedToPlayers) then
						table.insert(npcTable[index].talkedToPlayers, heroPlayer)
						--LuaDebugger.Log("CreateNpcMP player "..heroPlayer.." talked to "..index)
						MovieWindow_Start(heroPlayer, "", col.beig.."Mit euch möchte ich nicht reden...", 6)
					end
				end
			end
		end
	end
end

function NPC_MP_Trigger_Action(index)	-- index is now the name string
	local pid = npcTable[index].interactPlayer
	npcTable[index].callback(pid)
	--LuaDebugger.Log("NPC: execute callback with pid: "..(pid or "nil"))
	npcTable[index] = nil
	return true
end

-- check if the player that interacts with the NPC is supposed to do so
function NPC_MP_PlayerCheck(have, want)
	if want == nil then return true end

	if type(want) == "number" then
		return want == have
	end

	if type(want) == "table" then
		return IsValueInTable(have, want)
	end

	return false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function MovieWindow_Start(_player, _title, _text, _limit)
	if gvMission.PlayerID ~= _player then return false end

	if IsBriefingActive() or gvMission.MovieWindow.active then
		--LuaDebugger.Log("queued movie window; title: "..(_title or "nil"))
		StartSimpleJob(function(_player, _title, _text, _limit)
			if not (IsBriefingActive() or gvMission.MovieWindow.active) then
				MovieWindow_Start(_player, _title, _text, _limit)
				return true
			end
		end, _player, _title, _text, _limit)
		return false
	end

	gvMission.MovieWindow.title		= _title or ""
	gvMission.MovieWindow.text		= _text or ""
	gvMission.MovieWindow.counter	= 0
	gvMission.MovieWindow.limit		= _limit or 12
	gvMission.MovieWindow.active	= true
end

function SJ_MovieWindow()
	if gvMission.MovieWindow.active then
		if gvMission.MovieWindow.counter < gvMission.MovieWindow.limit then
			gvMission.MovieWindow.counter = gvMission.MovieWindow.counter + 1
			MovieWindow_Display(gvMission.PlayerID, gvMission.MovieWindow.title, gvMission.MovieWindow.text)
		else
			gvMission.MovieWindow.counter = 0
			gvMission.MovieWindow.active = false
			MovieWindow_Close(gvMission.PlayerID)
		end
	end
end

function MovieWindow_Display(_player, _Title,_Text)
	if gvMission.PlayerID ~= _player then return false end
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Movie"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Cinematic_Text"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieBarTop"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieBarBottom"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CreditsWindowLogo"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieInvisibleClickCatcher"),0)
	XGUIEng.SetText(XGUIEng.GetWidgetID("CreditsWindowTextTitle"), (_Title))
	XGUIEng.SetText(XGUIEng.GetWidgetID("CreditsWindowText"), (_Text))
end

function MovieWindow_Close(_player)
	if gvMission.PlayerID ~= _player then return false end
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Movie"), 0)
end

FIRE_DATA = {}

FIRE_DATA["trees"] = {
--TREES = {
	Entities.XD_Fir1,
	Entities.XD_Fir2,
	Entities.XD_Tree1,
	Entities.XD_Tree2,
	Entities.XD_Tree3,
	Entities.XD_Tree4,
	Entities.XD_Tree5,
	Entities.XD_Tree6,
	Entities.XD_Tree7,
	Entities.XD_Tree8,
	Entities.XD_Pine1,
	Entities.XD_Pine2,
	Entities.XD_Pine3,
	Entities.XD_Pine4,
	Entities.XD_Pine5,
	Entities.XD_Pine6,
	Entities.XD_Fir1_small,
	Entities.XD_Fir2_small,
	Entities.XD_Tree1_small,
	Entities.XD_Tree2_small,
	Entities.XD_Tree3_small,
	Entities.XD_DarkTree1,
	Entities.XD_DarkTree2,
	Entities.XD_DarkTree3,
	Entities.XD_DarkTree4,
	Entities.XD_DarkTree5,
	Entities.XD_DarkTree6,
	Entities.XD_DarkTree7,
	Entities.XD_DarkTree8,
}

FIRE_DATA["tree_replace"] = {
--TREE_REPLACE = {
	Entities.XD_DeadBush1,
	Entities.XD_DeadBush2,
	Entities.XD_DeadBush3,
	Entities.XD_DeadBush4,
	Entities.XD_DeadBush5,
	Entities.XD_DeadBush6,
	Entities.XD_DeadTree01,
	Entities.XD_DeadTree02,
	Entities.XD_DeadTree03,
	Entities.XD_DeadTree04,
	Entities.XD_DeadTree05,
	Entities.XD_DeadTree06,
}

FIRE_DATA["corn"] = { Entities.XD_Corn1, Entities.XD_MiscHaybale1, Entities.XD_MiscHaybale2, Entities.XD_MiscHaybale3 }
FIRE_DATA["corn_replace"] = { Entities.XD_PlantDecalLarge2, 0 }	-- 0 = do not create an entity

-- note: models, not actual effects!
FIRE_DATA["fire_effects"] = {	--FIRE_EFFECTS = {
	Models.Effects_XF_HouseFire,
	Models.Effects_XF_HouseFireLo,
	Models.Effects_XF_HouseFireMedium,
}

function Fire_GetTrees(_pos, _range, _table)
	local result, data = {}, {}
	local pos = GetPos(_pos)
	for i = 1, table.getn(_table) do
		data = {Logic.GetEntitiesInArea(_table[i], pos.X, pos.Y, _range, 16)}
		if data[1] > 0 then
			for j = 2, data[1]+1 do
				table.insert(result, data[j])
			end
		end
	end
	return result
end

function Fire_Start(_pos, _infectRange, _maxRange, _entityTable, _replaceTable, _speed)
	local pos = GetPos(_pos)
	local speed = _speed or 1
	assert(speed > -1 and speed < 21)
	local fire = {}
	fire.source = pos
	fire.entityTable = FIRE_DATA[_entityTable] or FIRE_DATA["trees"]
	fire.replaceTable = FIRE_DATA[_replaceTable] or FIRE_DATA["tree_replace"]
	fire.effectTable = FIRE_DATA["fire_effects"]	-- models!
	fire.iRange = _infectRange or 800
	fire.mRange = _maxRange or 2000
	fire.trees = {}
	fire.numTrees = 0

	fire.timeMin = 30 - Round(speed * 0.5)
	fire.timeMax = 50 - Round(speed * 0.5)
	--fire.spreadR = 1 - speed * 0.005

	-- search initial trees
	local data = Fire_GetTrees(fire.source, fire.iRange, fire.entityTable)
	for i = 1, table.getn(data) do
		local tree = data[i]
		if not fire.trees[tree] then
			-- found a new tree to burn
			fire.trees[tree] = {}
			fire.numTrees = fire.numTrees + 1
			local pos = GetPos(tree)
			local eff = Logic.CreateEntity(Entities.XD_Rock1, pos.X, pos.Y, 0, 8)	--XD_Rock3
			--SetEntityName(eff, "tree_eff_"..tree)
			--LuaDebugger.Log("new eff: "..tree)
			Logic.SetModelAndAnimSet(eff, GetRandomFromTable(fire.effectTable))

			fire.trees[tree].pos = pos
			fire.trees[tree].eff = eff
			fire.trees[tree].counter = math.random(fire.timeMin, fire.timeMax)
		end
	end

	ControlFire = function(fire)
		if fire.numTrees == 0 then
			-- all trees burned down
			--LuaDebugger.Log("fire is done!")
			gvMission.fireActive = false	-- this may be overwritten if there are other fires active
			return true
		else
			-- there are still trees to burn ...
			gvMission.fireActive = true
			for id, tree in pairs(fire.trees) do
				if tree.counter == 0 then
					-- infect nearby trees
					local data = Fire_GetTrees(id, fire.iRange, fire.entityTable)
					for i = 1, table.getn(data) do
						local newTree = data[i]
						local dist = GetDistance(newTree, fire.source)
						if (not fire.trees[newTree])	-- and (math.random() > fire.spreadR)
						and (dist <= fire.mRange) then
							-- found a new tree to burn
							fire.trees[newTree] = {}
							fire.numTrees = fire.numTrees + 1
							local pos = GetPos(newTree)
							local eff = Logic.CreateEntity(Entities.XD_Rock1, pos.X, pos.Y, 0, 8)	--XD_Rock3
							Logic.SetModelAndAnimSet(eff, GetRandomFromTable(fire.effectTable))

							fire.trees[newTree].pos = pos
							fire.trees[newTree].eff = eff
							fire.trees[newTree].counter = math.random(fire.timeMin, fire.timeMax)
						end
					end

					-- remove this one
					local pos = GetPos(id)
					Logic.CreateEffect(GGL_Effects.FXDestroyTree, pos.X, pos.Y, 8)
					local replaceEntity = GetRandomFromTable(fire.replaceTable)
					if replaceEntity ~= 0
					and Fire_CheckReplacePosition(pos) then
						ReplaceEntity(id, replaceEntity)
					else
						DestroyEntity(id)
					end
					DestroyEntity(tree.eff)	-- now that the effect entity can be destroyed by a placed building, this ID might be invalid already
					fire.numTrees = fire.numTrees - 1
					fire.trees[id] = nil
					Logic.SetTerrainNodeType(math.ceil(pos.X/100), math.ceil(pos.Y/100), GetRandomFromTable({9, 39, 41, 43, 48}))

				else
					tree.counter = tree.counter - 1

					--[[
					-- infect nearby trees
					local data = Fire_GetTrees(id, fire.iRange, fire.entityTable)
					for i = 1, table.getn(data) do
						local newTree = data[i]
						local dist = GetDistance(newTree, id)
						--(math.random() > math.max(dist/fire.iRange, 0.5)) theory: better because fire spreads to closer trees faster; praxis: meh - prematurely stops sometimes
						--(math.random() > fire.spreadR)
						if (not fire.trees[newTree]) and (math.random() > fire.spreadR)
						and (dist <= fire.mRange) then
							-- found a new tree to burn
							fire.trees[newTree] = {}
							fire.numTrees = fire.numTrees + 1
							local pos = GetPos(newTree)
							local eff = Logic.CreateEntity(Entities.XD_Rock3, pos.X, pos.Y, 0, 8)
							Logic.SetModelAndAnimSet(eff, GetRandomFromTable(FIRE_EFFECTS))

							fire.trees[newTree].pos = pos
							fire.trees[newTree].eff = eff
							fire.trees[newTree].counter = math.random(fire.timeMin, fire.timeMax)
						end
					end
					--]]
				end
			end
		end
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ControlFire",1,{},{fire})
end

-- check that there are no entities that might be harmed/destroyed when calling ReplaceEntity
function Fire_CheckReplacePosition(_position)
	for p = 1, 8 do
		if AreEntitiesInArea( p, 0, _position, 500, 1) then
			return false
		end
	end
	return true
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function CreateSuperTower(_tower)
	if gvSuperTowers == nil then gvSuperTowers = {} end
	MakeInvulnerable(_tower)
	table.insert(gvSuperTowers, GetEntityId(_tower))
	if gvControlSuperTowers == nil then
		--LuaDebugger.Log("create supertower job")
		gvControlSuperTowers = StartSimpleJob(function()
			if Counter.Tick2("tick_supertowers", 4) then
				for i = table.getn(gvSuperTowers), 1, -1 do
					local tow = gvSuperTowers[i]
					if IsExisting(tow) then
						local pos = GetPos(tow)
						Logic.CreateEffect(GGL_Effects.FXKerberosFear, pos.X, pos.Y, tar_PID)
					else
						table.remove(gvSuperTowers, i)
					end
				end
			end
		end)
	end
end

function RemoveSuperTower(_tower)
	if IsDead(_tower) then return false end
	MakeVulnerable(_tower)
	for i = table.getn(gvSuperTowers), 1, -1 do
		if gvSuperTowers[i] == GetEntityId(_tower) then
			table.remove(gvSuperTowers, i)
			return true
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- belongs to a certain player...
-- "range in meter", so factor 1/100 should be fine
function MPTools_ExploreArea(_player, _pos, _range)
	local pos = GetPos(_pos)
	local ViewCenter = Logic.CreateEntity(Entities.XD_ScriptEntity, pos.X, pos.Y, 0, _player)
	Logic.SetEntityExplorationRange(ViewCenter, math.ceil(_range/100))
	--LuaDebugger.Log(ViewCenter)
	return ViewCenter
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- extended version: count the entities (multiple types, table) from any of these players (table)
function GetNumberOfEntitiesInAreaEx(_players, _entityTypes, _position, _range)

	assert(type(_players) == "table", "GetNumberOfEntitiesInAreaEx: Parameter Error")
	assert(type(_entityTypes) == "table", "GetNumberOfEntitiesInAreaEx: Parameter Error")

	local counter = 0
	local pos = GetPos(_position)

	for p = 1, table.getn(_players) do
		local pid = _players[p]
		for e = 1, table.getn(_entityTypes) do
			local eType = _entityTypes[e]
			local entities = {Logic.GetPlayerEntitiesInArea(pid, eType, pos.X, pos.Y, _range, 48)}
			for i = 2, entities[1]+1 do
				local ent = entities[i]
				if Logic.IsBuilding(ent) == 1 then
					if Logic.IsConstructionComplete(ent) == 1 then
						counter = counter + 1
					end
				else
					counter = counter + 1
				end
			end
		end
	end

	return counter

end

-------------------------------------------------------------------------------------------------------------------------------------------------------


