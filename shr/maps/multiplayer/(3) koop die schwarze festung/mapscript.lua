----------------------------------------------------------------------------------------------------
-- MapName: (3) Die schwarze Festung
-- Author: Play4FuN
-- Date: 12.11.2022
-- Version: 1.1
----------------------------------------------------------------------------------------------------

-- TODO: see InitAllyControlTributes

-- idea: human player(s) can use a tribute to signal all allies to attack
-- AI allies attack once all human players OR one gave the command
-- tribute is available again after a certain time

-- idea: instead of a constant resource refresh for AI...
-- give the AI some initial resources, and at certain points during the mission
-- also possible: manually refresh resources but do so based on how many buildings
-- this AI player currently has (blacksmith etc. or tax income)
--> difficulty can still be adjusted by the amount of resources per building or the frequency

-- idea: big bad boy in the center starts to attack once one of the outposts gets destroyed
-- central enemy chooses one target player from a list:
-- outpost destroyed --> insert both neighbour players into that list
--> eventually each player can be present in this list twice (double chance to get picked for an attack)
-- during such a (large) attack, the other players have a chance to attack the central enemy

----------------------------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (3) Die schwarze Festung "
gvMapVersion = " v1.10"

-- to avoid problems on Kimichura's MP Server this must be called inside GameCallback_OnGameStart
function LoadAllTheScripts()

	do
		-- local path = "maps\\user\\"
		local path = "Data\\Maps\\ExternalMap\\"

		Script.Load( path.."p4f_tools.lua" )
		Script.Load( path.."p4f_comforts_general.lua" )
		Script.Load( path.."p4f_comforts_mpcoop.lua" )
		Script.Load( path.."p4f_army.lua" )
	end

end

----------------------------------------------------------------------------------------------------

if XNetwork then
	XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
	XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end

----------------------------------------------------------------------------------------------------

Umlaute = function( _text )
	local texttype = type( _text )
	if texttype == "string" then
		_text = string.gsub( _text, "ä", "\195\164" )
		_text = string.gsub( _text, "ö", "\195\182" )
		_text = string.gsub( _text, "ü", "\195\188" )
		_text = string.gsub( _text, "ß", "\195\159" )
		_text = string.gsub( _text, "Ä", "\195\132" )
		_text = string.gsub( _text, "Ö", "\195\150" )
		_text = string.gsub( _text, "Ü", "\195\156" )
		return _text
	elseif texttype == "table" then
		for k, v in _text do
			_text[k] = Umlaute( v )
		end
		return _text
	else
		return _text
	end
end

----------------------------------------------------------------------------------------------------
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	DIFFICULTY_NORMAL = 1
	DIFFICULTY_HARD = 2

	LoadAllTheScripts()

	gvMission = gvMission or {}
	gvMission.PlayerID = GUI.GetPlayerID()
	UserTool_GetPlayerNameOrig = UserTool_GetPlayerName
	gvMission.PlayerNames = {}

	for _pID = 1, 8 do
		gvMission.PlayerNames[_pID] = UserTool_GetPlayerNameOrig(_pID)
	end
	function UserTool_GetPlayerName(_PlayerID)
		if (_PlayerID > 0) and (_PlayerID < 9) then
			return gvMission.PlayerNames[_PlayerID]
	--	else
	--		return UserTool_GetPlayerNameOrig(_PlayerID)
		end
	end

	gvMission.Player7AttackAllowed = false
	gvMission.Player7TargetPlayers = {}
	gvMission.AlliesAllowedToAttack = false

	Message = function ( text, duration )
		GUI.AddNote( Umlaute(text), duration )
	end

	StartTechnologies()

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2,3), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end

	Message("Spieler 1 kann nun den Schwierigkeitsgrad im Tributmenü auswählen", 20)
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()


	--Init local map stuff
	TagNachtZyklus(24,1,0,-2,1)
	ActivateBriefingsExpansion()

	-- Mission_InitLocalResources()

	-- Init global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()

	-- do not remove player entities if one player is playing alone in MP mode
	MultiplayerTools_RemoveAllPlayerEntities_Backup = MultiplayerTools.RemoveAllPlayerEntities
	MultiplayerTools.RemoveAllPlayerEntities = function() end
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	MultiplayerTools.RemoveAllPlayerEntities = MultiplayerTools_RemoveAllPlayerEntities_Backup

	-- MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	if XNetwork.Manager_DoesExist() == 0 then

		InitSingleplayerMode()

	else

		-- multiplayer

		-- obtain the same "random" results for every player
		local R, G, B = GUI.GetPlayerColor(1)
		local rnd = R + G + B
		math.randomseed(rnd)

	end

	LocalMusic.UseSet = EVELANCEMUSIC

	-- map stuff

	for p1 = 1, 3 do
		for p2 = 1, 3 do
			if p1 ~= p2 then
				Logic.SetShareExplorationWithPlayerFlag( p1, p2, 1 )
			end
		end
	end

	-- Tools.ExploreArea(1,1,900)	-- debug
	-- Game.GameTimeSetFactor(2)
	-- Display.SetRenderFogOfWar(0)

	Display.SetPlayerColorMapping( 4, KERBEROS_COLOR )
	Display.SetPlayerColorMapping( 5, KERBEROS_COLOR )
	Display.SetPlayerColorMapping( 6, KERBEROS_COLOR )
	Display.SetPlayerColorMapping( 7, ROBBERS_COLOR )

	InitP4FComforts()

	-- SetupEnemies()	--> after difficulty selection

	_GlobalCounter = 0
	-- StartSimpleJob("SJ_Timeline")	--> after difficulty selection

	StartSimpleJob("VictoryJob")

--	MapLocal_StartCountDown(35*60)	-- display a cooldown, no callback needed
--	GUI.AddNote("35 Minuten Nichtangriffszeit!", 15)

	-- for n = 1, 6 do
		-- CreateWoodPile("WoodPile"..n, 20000)
	-- end


	-- test: thief cannon damage
	-- Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, nil, "EV_ON_ENTITY_HURT", 1)


	-- Logic.ActivateUpdateOfExplorationForAllPlayers()
	-- GUI.SetControlledPlayer( 7 )
	-- Logic.SetShareExplorationWithPlayerFlag( 1, 7, 1 )

	-- disable some heroes so the player cannot choose them
	BuyHeroWindow_Update_BuyHeroOrig2 = BuyHeroWindow_Update_BuyHero
	BuyHeroWindow_Update_BuyHero = function(_ent)
		BuyHeroWindow_Update_BuyHeroOrig2(_ent)
		-- note that the button name and GUI call to buy Erec/Salim is wrong
		--> to disable the button for Erec, one must disable the hero3 button
		-- XGUIEng.DisableButton( "BuyHeroWindowBuyHero3", 1 )

		XGUIEng.DisableButton( "BuyHeroWindowBuyHero8", 1 )		-- Kerberos
	end

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
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2,3), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:60,200,60 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
	--
	InitChests()

	-- players can get more heroes when they upgrade their HQ
	gvMission.PlayerHQUpgradeJob = Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, nil, "OnPlayerHqUpgradedEvent", 1 )
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_I)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 2
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2,3), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
	--
	InitChests()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_I)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	gvDiffLVL = 1
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.OfAnyPlayerFilter(1,2,3), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
	--
	for playerId = 1, 3 do
		-- no tier 2 or 3 towers
		ForbidTechnology( Technologies.UP1_Tower, playerId )
		ForbidTechnology( Technologies.UP2_Tower, playerId )
		-- no trading
		ForbidTechnology( Technologies.UP1_Market, playerId )
	end

	-- techs for main enemy and outposts
	for playerId = 4, 7 do
		unlockMilitaryTechs( playerId )
	end

	-- workers are hungry
	InitHungryWorkerMod_Multiplayer()

	-- all basic techs for center enemy; no silver tech though
	ResearchAllTechnologies(7, true, true, true, true, false)
end
function StartTechnologies()
	for i = 1,3 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function PrepareForStart()
	for i = 1,3 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
	end
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
    -- Init local map stuff
	Mission_InitLocalResources()

	SetupEnemies()

	StartSimpleJob( "SJ_Timeline" )

	InitAllyControlTributes()

	InitQuestMapInfo()
end
----------------------------------------------------------------------------------------------------

function Mission_InitWeatherGfxSets()

end


-- not active yet!
function EV_ON_WEATHER_CHANGED()
	--LuaDebugger.Log( "weather changed: "..Event.GetOldWeatherState().."->"..Event.GetNewWeatherState() )

	-- rain: chance to start a thunderstorm
	if Event.GetNewWeatherState() == 2 then
		local timeToNextChange = Logic.GetTimeToNextWeatherPeriod()
		-- do not start a thunderstorm if the rain period is too short
		if timeToNextChange > 30 then--and math.random() < 0.4 then TODO
			local duration = math.random( 30, timeToNextChange )
			--LuaDebugger.Log( duration )
			P4FComforts_ThunderStart( duration )
		end
	end

end

----------------------------------------------------------------------------------------------------

function InitWeather()

	-- not ready for multiplayer right now... TODO later?
	-- Trigger.RequestTrigger( Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "EV_ON_WEATHER_CHANGED", 1 )

end

----------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
end

----------------------------------------------------------------------------------------------------

function Mission_InitLocalResources()

	-- Initial Resources
	local gold = dekaround(600*gvDiffLVL)
	local clay = dekaround(800*gvDiffLVL)
	local wood = dekaround(800*gvDiffLVL)
	local stone = dekaround(600*gvDiffLVL)
	local iron = dekaround(300*gvDiffLVL)
	local sulfur = dekaround(300*gvDiffLVL)

	for playerId = 1, 3 do
		Tools.GiveResouces( playerId, gold, clay, wood, stone, iron, sulfur )
	end

end

----------------------------------------------------------------------------------------------------

function InitP4FComforts()

	P4FComforts_SelectionFix()
	P4FComforts_UpgradeHints()
	P4FComforts_MarketInfo()
	P4FComforts_HeroHealthDisplay()
	P4FComforts_FreeCamera()
	P4FComforts_CreateDecalsForResourcePiles()
	P4FComforts_EnableGlobalTroopSelection()
	P4FComforts_RefinedResourceView()
	P4FComforts_SetRefinedResourceTooltipsMode( 1 )
	P4FComforts_EnhancedMusic()

	if XNetwork.Manager_DoesExist() == 0 then
		-- only use in singleplayer
		P4FComforts_PauseCameraRotation()
	end

end

----------------------------------------------------------------------------------------------------

function InitQuestMapInfo()

	local title = "Karteninfo"
	local text = "Eure Aufgabe:"..
	" @cr Besiegt den Anführer der schwarzen Festung und zerstört alle Haupthäuser!"..
	" @cr @cr Hinweise:"..
	" @cr - Es gibt mehrere Außenposten, welche wertvolle Rohstoffe kontrollieren"..
	" @cr - Seid beim Aufbau Eurer Siedlung achtsam! Gegner könnten auf Euch aufmerksam werden..."

	-- AI allies present?
	if not IsValidHumanPlayer( 1 ) or not IsValidHumanPlayer( 2 ) or not IsValidHumanPlayer( 3 ) then
		text = text .. " @cr - AI-Verbündete werden erst angreifen, sobald Ihr es erlaubt (F3-Menü)"
	end

	Logic.AddQuest( 1, 1, MAINQUEST_OPEN, title, text, 1 )
	Logic.AddQuest( 2, 2, MAINQUEST_OPEN, title, text, 1 )
	Logic.AddQuest( 3, 3, MAINQUEST_OPEN, title, text, 1 )

end

----------------------------------------------------------------------------------------------------

function InitAllyControlTributes()

	gvMission.allyControlTributes = {}

	-- currently ONE player is enough to command ALL allied AI to be allowed to attack
	for playerId = 1, 3 do
		if IsValidHumanPlayer( playerId ) then
			gvMission.allyControlTributes[playerId] = AddTribute{
				playerId = playerId,
				text = Umlaute("Angriffsbefehl: Eure Verbündeten (AI) sollen angreifen."),
				cost = { Gold = 0 },
				Callback = TributeToggleAllyAttackAllowedPaid,
				beAggressive = true,
			}
		end
	end

end

-- maybe add later: toggle aggressive on and off?
--> switch to defensive behavior -> set army.attackCountdown to 0
function TributeToggleAllyAttackAllowedPaid( tribute )

	for playerId = 1, 3 do
		Logic.RemoveTribute( playerId, gvMission.allyControlTributes[playerId] )
	end

	Message( "Von nun an verhalten sich alle AI-Verbündeten offensiv." )

	for i = 2,3 do
		MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
	end

end

----------------------------------------------------------------------------------------------------

function InitSingleplayerMode()

	Message("Einzelspieler aktiviert.")

	local PlayerID = GUI.GetPlayerID()
	Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
	Logic.PlayerSetGameStateToPlaying( PlayerID )

	-- Logic.ChangeAllEntitiesPlayerID(2, PlayerID)
	-- Logic.ChangeAllEntitiesPlayerID(3, PlayerID)

	-- StartSimpleJob( "SJ_DefeatSingleplayerMode" )

	-- Helden auswählen im SP

	GUIUpdate_BuyHeroButton = function()
		-- display button as long as heroes can be bought
		if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) > 0 then
			XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),1)
		else
			XGUIEng.ShowWidget(XGUIEng.GetCurrentWidgetID(),0)
		end
	end

end

----------------------------------------------------------------------------------------------------

-- entity created event
-- human player upgraded his HQ?
--> allow him to buy more heroes
function OnPlayerHqUpgradedEvent()
	local entityId = Event.GetEntityID()
	local playerId = GetPlayer( entityId )
	local entityType = Logic.GetEntityType( entityId )
	if Logic.PlayerGetGameState( playerId ) ~= 1 then
		return
	end

	if entityType == Entities.PB_Headquarters2
	or entityType == Entities.PB_Headquarters3 then
		AddNumberOfBuyableHeroesForPlayer( playerId, 1 )

		if GUI.GetPlayerID() == playerId then
			Message( Umlaute("Ihr könnt nun einen weiteren Helden auswählen!") )
		end
	end
end

----------------------------------------------------------------------------------------------------

function InitChests()
	-- for every human player (that is actually present) create X out of Y chests in the area
	--> pick the first X from Y indicies
	local amount = 3
	local indices = ShuffleTable( {1,2,3,4,5} )
	for playerId = 1, 3 do
		if Logic.PlayerGetGameState(playerId) == 1 then
			for i = 1, amount do
				local index = indices[i]
				CreateChestMP( "ChestP"..playerId.."_"..index, ChestCallbackRandom )
			end
		end
	end
end

-- randomly give either some gold, clay or wood
function ChestCallbackRandom( entityId )
	local playerId = GetPlayer( entityId )
	local random = math.random
	local text = "Ihr habt eine Schatztruhe gefunden! Sie enthielt: "
	local amount = 0

	if random() < 0.5 then	-- 50% gold
		amount = 400 * gvDiffLVL
		AddGold( playerId, amount )
		text = text .. amount .. " Taler"

	elseif random() < 0.75 then	-- 25% clay
		amount = 600 * gvDiffLVL
		AddClay( playerId, amount )
		text = text .. amount .. " Lehm"

	else	-- 25% wood
		amount = 600 * gvDiffLVL
		AddWood( playerId, amount )
		text = text .. amount .. " Holz"

	end

	if GUI.GetPlayerID() == playerId then
		Message( text )
	end
end

----------------------------------------------------------------------------------------------------

function SetupEnemies()

	function ControlArmies(_player, _id, _building)
		local army = ArmyTable[_player][_id + 1]
		if IsDead(army) then
			if IsDestroyed(_building) then
				return true
			end
		else
			if gvMission.Player7AttackAllowed then
				Advance(army)
			else
				Defend(army)
			end
		end
	end
	-- two armys per outpost: 1x def only and 1x def + occasional attack only if the neighbour player extends too far
	for playerId = 4, 6 do
		MapEditor_SetupAI(playerId, round(3/gvDiffLVL), 8000, round(3-gvDiffLVL), "HQP".. playerId, 3, 0)
		MapEditor_Armies[playerId].offensiveArmies.strength = round(MapEditor_Armies[playerId].offensiveArmies.strength / 2)
	end

	local playerId = 7
	MapEditor_SetupAI(playerId, round(3/gvDiffLVL), 8500, round(3/math.sqrt(gvDiffLVL)), "HQP" .. playerId, 3, 0)
	for armyId = 1, 3 do
		local pos = GetPosition("TowerP7_" .. armyId)
		local newposX, newposY = EvaluateNearestUnblockedPosition(pos.X, pos.Y, 1200, 100)
		local army = {
			id = armyId,
			player = playerId,
			strength = round(12/gvDiffLVL),
			position = GetPosition("defPos" .. armyId),
			spawnPos = {X = newposX, Y = newposY},
			spawnGenerator = "TowerP7_" .. armyId,
			spawnTypes = {{Entities["PU_LeaderBow" .. round(3/math.sqrt(gvDiffLVL))], LeaderTypeGetMaximumNumberOfSoldiers(Entities["PU_LeaderBow" .. round(3/math.sqrt(gvDiffLVL))])},
				{Entities["PU_LeaderSword" .. round(3/math.sqrt(gvDiffLVL))], LeaderTypeGetMaximumNumberOfSoldiers(Entities["PU_LeaderSword" .. round(3/math.sqrt(gvDiffLVL))])},
				{Entities.CU_BlackKnight_LeaderSword3, 6}},
			endless = true,
			noEnemy = true,
			noEnemyDistance = round(3000*gvDiffLVL),
			rodeLength = 5000,
			respawnTime = round(40*gvDiffLVL),
			maxSpawnAmount = 1
		}
		SetupArmy(army)
		SetupAITroopSpawnGenerator("SpawnArmy" .. armyId, army)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmies", 1, {}, {playerId, armyId, army.spawnGenerator})
	end
	ConnectLeaderWithArmy(GetID("Kerberos"), nil, "offensiveArmies")

	-- when to start player 7 attacks...
	StartSimpleJob("Player7AttackControl")

	function Player7AttackControl()
		if Counter.Tick2("Player7AttackControlCounter", 70 + (20 * gvDiffLVL) * 60) then
			gvMission.Player7AttackAllowed = true
			Logic.AddWeatherElement(1, 600, 0, 9, 5, 15)
			MapEditor_Armies[7].offensiveArmies.rodeLength = Logic.WorldGetSize()
			MapEditor_Armies[7].offensiveArmies.strength = MapEditor_Armies[7].offensiveArmies.strength + round(6/gvDiffLVL)
			return true
		end
		if not gvMission.Player7AttackAllowed then
			if IsDead( "HQP4" ) or IsDead( "HQP5" ) or IsDead( "HQP6" )
			or GetPlayerHQLevel( 1 ) == 3
			or GetPlayerHQLevel( 2 ) == 3
			or GetPlayerHQLevel( 3 ) == 3 then
				gvMission.Player7AttackAllowed = true
				Logic.AddWeatherElement(1, 600, 0, 9, 5, 15)
			end
		end
	end

end

function RenamePlayer(_pID, _pName, _colorFlag)

	gvMission.PlayerNames[_pID] = _pName
	local R, G, B = GUI.GetPlayerColor( _pID )
	if _colorFlag then
		SetPlayerName(_pID, "@color:"..R..","..G..","..B.." ".._pName)
	end
	-- for statistics menu (post game screen)
	Logic.PlayerSetPlayerColor( _pID, R, G, B )

end

-- trigger some events
function SJ_Timeline()

	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == 3 then

		local numberOfHumanPlayers = 0
		for playerId = 1, 3 do
			if Logic.PlayerGetGameState(playerId) == 0 then
				EnableAIforPlayer(playerId)
			else
				RenamePlayer(playerId, UserTool_GetPlayerName(playerId), true)

				numberOfHumanPlayers = numberOfHumanPlayers + 1

				-- defeat conditions for players
				StartSimpleJob("SJ_DefeatP"..playerId)	--SJ_DefeatP1

			end
		end

		if numberOfHumanPlayers == 3 then
			-- gvMission.EntityDestroyedTrigger = Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSecretEntityDestroyed", 1 )
			StartSimpleJob( "SJ_CheckSecretRockDestroyed" )
		end

		InitDiplomacy()

		return true
	end

end

----------------------------------------------------------------------------------------------------

function InitDiplomacy()

	SetFriendly( 1, 2 )
	SetFriendly( 1, 3 )
	SetFriendly( 2, 3 )

	for a = 1, 3 do
		for b = 4, 7 do
			SetHostile( a, b )
		end
	end

	SetPlayerName( 4, "Außenposten" )
	SetPlayerName( 5, "Außenposten" )
	SetPlayerName( 6, "Außenposten" )
	SetPlayerName( 7, "Schwarze Festung" )

end

----------------------------------------------------------------------------------------------------

-- human player slots that are empty will be filled with an allied AI player
function EnableAIforPlayer( playerId )

	MapEditor_SetupAI(playerId, round(gvDiffLVL), 8500, 1, "HQP" .. playerId, 3, 0)
	MapEditor_Armies[playerId].offensiveArmies.strength = round(MapEditor_Armies[playerId].offensiveArmies.strength / 2)
	AI.Village_SetSerfLimit( playerId, 8 )
	AI.Village_EnableExtracting( playerId, 1 )
	AI.Village_EnableRepairing( playerId, 1 )
	AI.Entity_ActivateRebuildBehaviour( playerId, 10, 60 )
	AI.Village_EnableConstructing( playerId, 1 )

	RenamePlayer( playerId, "Verbündeter", true )

	KI_SetupDefeatCondition( playerId )

	local posMain = GetPosition( "HQP"..playerId )
	local posAny = invalidPosition

	KI_StartBuild( playerId, Entities.PB_University1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Residence1, posAny, 0 )

	KI_StartBuild( playerId, Entities.PB_Brickworks1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Sawmill1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Residence1, posAny, 0 )

	KI_StartBuild( playerId, Entities.PB_StoneMason1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Blacksmith1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Blacksmith1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Residence1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )

	KI_StartBuild( playerId, Entities.PB_Barracks1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Archery1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Tower1, posMain, 1 )

	--> current village space usage is 44 (until here)
	--> about 200 places can be used for military when 2 level 3 village centers are available

	KI_StartBuild( playerId, Entities.PB_Monastery1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Residence1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Bank1, posMain, 0 )
	KI_StartBuild( playerId, Entities.PB_Farm1, posAny, 0 )
	KI_StartBuild( playerId, Entities.PB_Residence1, posAny, 0 )

	KI_StartBuild( playerId, Entities.PB_Tower1, posMain, 1 )

	-- create resource pit and village center
	--> make sure the positions are valid or the game crashes (at least for the village centers)
	local posClay = GetPos( "ClayPitP"..playerId )
	Logic.CreateConstructionSite( posClay.X, posClay.Y, 0, Entities.PB_ClayMine1, playerId )
	local posStone = GetPos( "StonePitP"..playerId )
	Logic.CreateConstructionSite( posStone.X, posStone.Y, 0, Entities.PB_StoneMine1, playerId )
	local posVillage = GetPos( "VillageCenterP"..playerId )
	Logic.CreateConstructionSite( posVillage.X, posVillage.Y, 0, Entities.PB_VillageCenter1, playerId )

	Message( "KI für Spieler "..playerId.." aktiviert.", 10 )

	Logic.PlayerSetIsHumanFlag( playerId, 1 )	-- write statistics

	local random = math.random

	-- upgrade HQ
	StartCountdown( random(15*60, 25*60), UpgradeBuilding, false, "HQP"..playerId )	-- HQ upgrade 1
	StartCountdown( random(35*60, 50*60), UpgradeBuilding, false, "HQP"..playerId )	-- HQ upgrade 2

	-- more upgrades (settlement, village center)
	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, nil, "KI_UpgradeJob", 1, nil, { playerId } )

	-- troop upgrades
	StartCountdown( random(20*60, 30*60), AiTroopUpgrade1, false, playerId )

end

----------------------------------------------------------------------------------------------------

function KI_UpgradeJob( playerId )

	-- check only every 20 seconds
	if not Counter.Tick2( "KI_UpgradeJob"..playerId, 20 ) then
		return
	end

	-- player defeated?
	if GetPlayerHQLevel( playerId ) == 0 then
		return true
	end

	local gametime = Round(Logic.GetTime())
	if gametime < 10 * 60 then
		return
	end

	-- village space
	local limit = Logic.GetPlayerAttractionLimit( playerId )
	local usage = Logic.GetPlayerAttractionUsage( playerId )
	local freeVillageSpace = limit - usage
	if limit < 250 and freeVillageSpace < 20 then
		if not TryUpgradeBuildingOfPlayerOfType( playerId, Entities.PB_VillageCenter1 ) then
			TryUpgradeBuildingOfPlayerOfType( playerId, Entities.PB_VillageCenter2 )
		end
	end

	-- settlement buildings
	local buildingsEarly = {
		Entities.PB_Residence1,
		Entities.PB_Residence1,
		Entities.PB_Residence1,
		Entities.PB_University1,
		Entities.PB_Blacksmith1,
		-- chance to fail / upgrade nothing
		false,
		false,
		false,
		false,
	}
	local buildingsLater = {
		Entities.PB_Monastery1,
		Entities.PB_Monastery2,
		Entities.PB_StoneMason1,
		Entities.PB_Blacksmith2,
		Entities.PB_Brickworks1,
		Entities.PB_Sawmill1,
		-- chance to fail / upgrade nothing
		false,
		false,
		false,
	}
	local entityType
	if gametime < 40 * 60 then
		entityType = GetRandomFromTable( buildingsEarly )
	else
		entityType = GetRandomFromTable( buildingsLater )
	end
	if entityType then
		TryUpgradeBuildingOfPlayerOfType( playerId, entityType )
	end

end

----------------------------------------------------------------------------------------------------

function AiTroopUpgrade1( playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, playerId )

	ResearchTechnology( Technologies.T_LeatherMailArmor, playerId )
	ResearchTechnology( Technologies.T_SoftArcherArmor, playerId )

	StartCountdown( math.random(10*60, 15*60), AiTroopUpgrade2, false, playerId )

end

function AiTroopUpgrade2( playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, playerId )

	ResearchTechnology( Technologies.T_ChainMailArmor, playerId )
	ResearchTechnology( Technologies.T_PaddedArcherArmor, playerId )

	ResearchTechnology( Technologies.T_BetterTrainingArchery, playerId )
	ResearchTechnology( Technologies.T_BetterTrainingBarracks, playerId )
	-- ResearchTechnology( Technologies.T_Shoeing, playerId )

	StartCountdown( math.random(15*60, 20*60), AiTroopUpgrade3, false, playerId )

end

function AiTroopUpgrade3( playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, playerId )

	-- ResearchTechnology( Technologies.T_FleeceArmor, playerId )
	-- ResearchTechnology( Technologies.T_LeadShot, playerId )

	StartCountdown( math.random(5*60, 10*60), AiTroopUpgrade4, false, playerId )

end

function AiTroopUpgrade4( playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderCavalry, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierCavalry, playerId )

	Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderHeavyCavalry, playerId )
	Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierHeavyCavalry, playerId )

	ResearchTechnology( Technologies.T_PlateMailArmor, playerId )
	ResearchTechnology( Technologies.T_LeatherArcherArmor, playerId )

end

----------------------------------------------------------------------------------------------------

-- victory condition
function VictoryJob()
	if IsDead("HQP4") and IsDead("HQP5") and IsDead("HQP6") and IsDead("HQP7") and IsDead("CastleP7") then
		Victory()
		return true
	end
end

----------------------------------------------------------------------------------------------------

function KI_StartBuild(_pID, _type, position, _level)

	if IsDestroyed("HQP" .. _pID) then
		return
	end
	assert( type(position) == "table" )

	-- local _constructionplan = {{ type = _type, pos = _position, level = (_level or 0) }}
	-- FeedAiWithConstructionPlanFile(_pID, _constructionplan)
	AI.Village_StartConstruction( _pID, _type, position.X, position.Y, (_level or 0) )

end

----------------------------------------------------------------------------------------------------

function KI_SetupDefeatCondition(_pID)
	Trigger.RequestTrigger(
		Events.LOGIC_EVENT_EVERY_SECOND,
		"",										-- condition function
		"KI_DefeatJob",				-- action function
		1,										-- is active
		nil,									-- table for condition function
		{_pID}								-- table for action function
		)
end

function KI_DefeatJob(_pID)
	if IsDestroyed("HQP" .. _pID) then
		AI.Village_DeactivateRebuildBehaviour(_pID)
		AI.Village_ClearConstructionQueue(_pID)
		return true
	end
end

----------------------------------------------------------------------------------------------------

function SJ_DefeatP1()
	if IsDead("HQP1") then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("HQP2") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

function SJ_DefeatP3()
	if IsDead("HQP3") then
		Logic.PlayerSetGameStateToLost(3)
		return true
	end
end

function SJ_DefeatSingleplayerMode()
	if IsDead("HQP1") and IsDead("HQP2") and IsDead("HQP3") then
		Defeat()
		return true
	end
end


----------------------------------------------------------------------------------------------------

-- check if this player is occupied by a human player (who is currently playing)
function IsValidHumanPlayer( playerId )
	return Logic.PlayerGetGameState( playerId ) == 1
end

----------------------------------------------------------------------------------------------------

function InitHungryWorkerMod_Multiplayer()

	assert( GetHealth )
	assert( Round )
	assert( IsValidHumanPlayer )

	gvHungryWorkerMod = {
		Workers = {},
		Penalties = {},
		PenaltyTime = 180,	-- workplace slot is locked for X seconds
		-- GUIAction_JumpBackToSelectedBuilding = GUIAction_JumpBackToSelectedBuilding,
		-- GUITooltip_NormalButton = GUITooltip_NormalButton,
		-- GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged,
		-- GUIUpdate_SettlersContainer = GUIUpdate_SettlersContainer,
	}

	-- also fetch workers that exist from the start
	for entityId in CEntityIterator.Iterator( CEntityIterator.OfCategoryFilter(EntityCategories.Worker) ) do
		if IsValidHumanPlayer( GetPlayer( entityId ) ) then
			table.insert( gvHungryWorkerMod.Workers, { id = entityId, protectionTime = 20, } )
		end
	end

	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, "", "HungryWorkerModOnWorkerCreated", 1 )

	StartSimpleJob( "SJ_ControlWorkers" )

	StartSimpleJob( "SJ_ControlWorkplacePenalties" )

	-- added: highlight hungry and homeless worker buttons in red
	gvHungryWorkerMod.highlightWorkerButtons = 1
	StartSimpleJob( "SJ_HighlightWorkerButtons" )

	-- fix: check if WorkerTypeName exists
	GUIUpdate_SettlersContainer = function(_number)
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
		local SettlerID = XGUIEng.GetBaseWidgetUserVariable(MotherContainer, 0)

		local FarmWidgetName = "WorkerHasFarm" .. _number
		local ResidenceWidgetName = "WorkerHasResidence" .. _number
		local MotivationIconName = "WorkerMotivation" .. _number
		local ButtonName = "Worker" .. _number

		--Is a settler assigned to container?
		if SettlerID == 0 then
			-- NO!
			for i = 0,4 do
				--empty Textures
				XGUIEng.SetMaterialTexture(ButtonName,i, "Data\\Graphics\\Textures\\GUI\\inHouse\\PU_leer.png")

				--empty motivation
				XGUIEng.SetMaterialTexture(MotivationIconName,i, "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_blank.png")

			end

			--do not show farm
			XGUIEng.ShowWidget(FarmWidgetName,0)

			--do not show residence
			XGUIEng.ShowWidget(ResidenceWidgetName,0)

			return
		end


		local WorkerType = Logic.GetEntityType(SettlerID)
		local WorkerTypeName = Logic.GetEntityTypeName( WorkerType )

		-- FIX: empty WorkerTypeName
		if WorkerTypeName ~= nil then

			--set texture on WorkerButtons
			local TexturePath = "Data\\Graphics\\Textures\\GUI\\inHouse\\" .. WorkerTypeName .. ".png"
			for j = 0,4 do
				XGUIEng.SetMaterialTexture(ButtonName,j, TexturePath)
			end

		end	--

		--set motivation
		local Motivation = Logic.GetSettlersMotivation(SettlerID)
		local TexturePathMotivationIcon = ""

		if Motivation > gvGUI.MotivationThresholds.Happy then
					TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_happy.png"

		elseif Motivation > gvGUI.MotivationThresholds.Sad
			and Motivation < gvGUI.MotivationThresholds.Happy then
				TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_good.png"

		elseif Motivation > gvGUI.MotivationThresholds.Angry
			and Motivation < gvGUI.MotivationThresholds.Sad then
				TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_sad.png"

		elseif Motivation > gvGUI.MotivationThresholds.Leave
			and Motivation < gvGUI.MotivationThresholds.Angry then
				TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_angry.png"

		elseif Motivation < gvGUI.MotivationThresholds.Leave then
				TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_leave.png"
		else
				TexturePathMotivationIcon = "Data\\Graphics\\Textures\\GUI\\inHouse\\motivation_good.png"
		end

		XGUIEng.SetMaterialTexture(MotivationIconName,1,TexturePathMotivationIcon)

		--display Farm icon if player has farm
		if Logic.GetSettlersResidence(SettlerID) ~= 0 then
			XGUIEng.ShowWidget(ResidenceWidgetName,1)
		else
			XGUIEng.ShowWidget(ResidenceWidgetName,0)
		end

		--display residence icon if player has residence
		if Logic.GetSettlersFarm(SettlerID) ~= 0 then
			XGUIEng.ShowWidget(FarmWidgetName,1)
		else
			XGUIEng.ShowWidget(FarmWidgetName,0)
		end
	end

end

function SJ_ControlWorkers()

	for i = table.getn(gvHungryWorkerMod.Workers), 1, -1 do
		local entityId = gvHungryWorkerMod.Workers[i].id
		if IsDead( entityId ) then
			table.remove( gvHungryWorkerMod.Workers, i )
		else
			local health = Round(GetHealth( entityId ))
			if gvHungryWorkerMod.Workers[i].protectionTime then
				gvHungryWorkerMod.Workers[i].protectionTime = gvHungryWorkerMod.Workers[i].protectionTime - 1
				if gvHungryWorkerMod.Workers[i].protectionTime <= 0 then
					gvHungryWorkerMod.Workers[i].protectionTime = nil
				end
			end

			if Logic.GetSettlersFarm( entityId ) == 0 then

				local playerId = GetPlayer( entityId )
				local workplace = Logic.GetSettlersWorkBuilding( entityId )

				-- do not hurt workers within the first few seconds
				if not gvHungryWorkerMod.Workers[i].protectionTime then
					if math.random() < 0.4 then
						SetHealth( entityId, health - 1 )
					end
				end

				if IsDead( entityId ) and IsExisting( workplace ) then

					Logic.SetCurrentMaxNumWorkersInBuilding( workplace, Logic.GetCurrentMaxNumWorkersInBuilding(workplace) - 1 )
					-- store info that this building is missing a worker so the slot is unlocked again later(?)
					table.insert( gvHungryWorkerMod.Penalties, {workplace=workplace, countdown=gvHungryWorkerMod.PenaltyTime} )

					if playerId == gvMission.PlayerID then
						-- inform the player
						Message( "@color:255,0,0 Ein Arbeiter ist verhungert, weil er keinen Platz zum Essen hatte!" )
						local pos = GetPos( workplace )
						GUI.ScriptSignal( pos.X, pos.Y, 2 )	-- white
					end
				end
				--
			else	-- heal if worker has both farm and house
				if health < 100 then
					if Logic.GetSettlersResidence( entityId ) ~= 0 then
						SetHealth( entityId , health + 1)
					end
				end
			end
		end
	end
end

function SJ_ControlWorkplacePenalties()
	for k, v in pairs( gvHungryWorkerMod.Penalties ) do
		local entityId = v.workplace
		if IsDead( entityId ) then
			-- discard workplace if not existing anymore
			table.remove( gvHungryWorkerMod.Penalties, k )
		else
			v.countdown = v.countdown - 1
			if v.countdown < 1 then
				-- unlock the slot again
				if Logic.GetCurrentMaxNumWorkersInBuilding( entityId ) < Logic.GetMaxNumWorkersInBuilding( entityId ) then
					Logic.SetCurrentMaxNumWorkersInBuilding( entityId, Logic.GetCurrentMaxNumWorkersInBuilding( entityId ) + 1 )
				end
				table.remove( gvHungryWorkerMod.Penalties, k )
			end
		end
	end
end

function HungryWorkerModOnWorkerCreated()
	local entityId = Event.GetEntityID()

	-- if Logic.EntityGetPlayer( entityId ) == 1 then
	if IsValidHumanPlayer( GetPlayer( entityId ) ) then
		if Logic.IsWorker( entityId ) == 1 then
			-- first few seconds after the worker arrives in the settlement he will not lose health when he has no farm
			table.insert( gvHungryWorkerMod.Workers, { id = entityId, protectionTime = 20, } )
		end
	end

end

-- highlight buttons for worker in red if they have no food or no house
function SJ_HighlightWorkerButtons()

	-- switch on and off once per second
	gvHungryWorkerMod.highlightWorkerButtons = math.abs(1 - gvHungryWorkerMod.highlightWorkerButtons)
	local noHouse = Logic.GetNumberOfWorkerWithoutSleepPlace( gvMission.PlayerID ) > 0
	local noFood = Logic.GetNumberOfWorkerWithoutEatPlace( gvMission.PlayerID ) > 0

	if gvHungryWorkerMod.highlightWorkerButtons == 1 then
		for i=0,4 do
			if noFood then
				XGUIEng.SetMaterialColor("NextWorkerNoFarm",i, 215,40,20,255)
			end
			if noHouse then
				XGUIEng.SetMaterialColor("NextWorkerNoResidence",i, 215,40,20,255)
			end
		end
	else
		for i=0,4 do
			XGUIEng.SetMaterialColor("NextWorkerNoFarm",i, 255,255,255,255)
			XGUIEng.SetMaterialColor("NextWorkerNoResidence",i, 255,255,255,255)
		end
	end

end

-- only active if 3 players are present
function SJ_CheckSecretRockDestroyed()
	if not IsExisting( "RockSecret" ) then
		local pos = GetPos( "PosSecret" )
		local stoneId = Logic.CreateEntity( Entities.XD_Stone_BlockPath, pos.X, pos.Y, 0, 0 )
		Logic.SetResourceDoodadGoodAmount( stoneId, 3 )
		Logic.SetModelAndAnimSet( stoneId, Models.XD_Evil_Camp02 )
		SetEntityName( stoneId, "StoneSecret" )
		StartSimpleJob( "SJ_CheckSecretStoneDestroyed" )
		return true
	end
end

function SJ_CheckSecretStoneDestroyed()
	if not IsExisting( "StoneSecret" ) then
		local pos = GetPos( "PosSecret" )
		local chestId = Logic.CreateEntity( Entities.XD_ChestClose, pos.X, pos.Y, 0, 0 )
		SetEntityName( chestId, "ChestSecret" )
		StartSimpleJob( "SJ_ControlSecretChest" )
		return true
	end
end

function SJ_ControlSecretChest()
	-- normal chest open range: 350
	local numPlayerHeroessNearby = 0
	for playerId = 1, 3 do
		if AreHeroesInArea( playerId, "PosSecret", 600, 1 ) then
			numPlayerHeroessNearby = numPlayerHeroessNearby + 1
		end
	end
	if numPlayerHeroessNearby == 3 then
		local pos = GetPos( "PosSecret" )
		ReplaceEntity( "ChestSecret", Entities.XD_ChestOpen )
		Logic.CreateEffect( GGL_Effects.FXNephilimFlowerDestroy, pos.X, pos.Y, 1 )
		OnSecretChestOpened()
		return true
	elseif numPlayerHeroessNearby > 0 then
		local pos = GetPos( "PosSecret" )
		Logic.CreateEffect( GGL_Effects.FXDarioFear, pos.X, pos.Y, 1 )
	end
end


function OnSecretChestOpened()
	Sound.PlayGUISound( Sounds.OnKlick_Select_erec, 100 )
	Sound.Play2DQueuedSound( Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_01, 100 )
	Message( "Gratulation, ihr habt eine supergeheime Truhe gefunden!" )
	Message( "Sie enthielt ganz viel Gold!" )
	for playerId = 1, 3 do
		AddGold( playerId, 12345 )
	end
end

----------------------------------------------------------------------------------------------------

-- updated to work with Kimichura's MP Server
function UpgradeBuilding( entity )

	local EntityID = GetEntityId(entity)
	if not IsValid(EntityID) then
		return false
	end

	local EntityType = Logic.GetEntityType(EntityID)
	local PlayerID = GetPlayer(EntityID)
	local Costs = {}
	Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
	-- Add needed resources
	for Resource, Amount in Costs do
		Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
	end
	-- Start upgrade
	if SendEvent then
		-- networked
		SendEvent.UpgradeBuilding(EntityID)
	else
		-- "normal"
		GUI.UpgradeSingleBuilding(EntityID)
	end

end

----------------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------------

-- look for any building of that type and player that can be upgraded and do so
-- note that the required resources will be added to the player
-- if the building that was randomly selected cannot be upgraded, no new attempt is made
function TryUpgradeBuildingOfPlayerOfType( playerId, entityType )
	local buildings = {Logic.GetPlayerEntities( playerId, entityType, 64 )}
	if buildings[1] == 0 then
		return false
	end
	local index = math.random(2, buildings[1]+1)
	local entityId = buildings[index]
	if not IsBuildingUpgradable( entityId ) then
		return false
	end
	UpgradeBuilding( entityId )
	return true
end

----------------------------------------------------------------------------------------------------

