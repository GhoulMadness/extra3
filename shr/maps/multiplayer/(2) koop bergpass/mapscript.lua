----------------------------------------------------------------------------------------------------
    -- Mapname: (2)Bergpass
    -- Author: Play4FuN
	-- Oktober 2017
----------------------------------------------------------------------------------------------------

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Bergpass "
gvMapVersion = " v1.3 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	StartTechnologies()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	StartSimpleJob("VictoryJob")

	-- Festlegung des Diplomatistatus für die Zeit nach der Peacetime
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	for i=1,8 do
		--AllowTechnology(Technologies.B_Bridge, i)
		ForbidTechnology(Technologies.T_ChangeWeather, i)
		ForbidTechnology(Technologies.T_MakeSummer, i)
		ForbidTechnology(Technologies.T_MakeRain, i)
		ForbidTechnology(Technologies.T_MakeSnow, i)
		ForbidTechnology(Technologies.T_MakeThunderstorm, i)
	end

----------------------------------------------------------------------------------------------------

    -- intro briefing
	IntroBriefing()

	TagNachtZyklus(24,0,0,0,1)

----------------------------------------------------------------------------------------------------

    if XNetwork.Manager_DoesExist() == 0 then
        for i = 1,2 do
            MultiplayerTools.DeleteFastGameStuff(i)
		end

        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )

		-- no player 2 here? give it all to player 1
		Logic.ChangeAllEntitiesPlayerID(1, PlayerID)
		Logic.ChangeAllEntitiesPlayerID(2, PlayerID)

    end

	SetFriendly( 1, 2 )
	ActivateShareExploration(1,2, true)
	MapEditor_CreateHQDefeatCondition()

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end

----------------------------------------------------------------------------------------------------

	-- misc

	LocalMusic.UseSet = EUROPEMUSIC
	LocalMusic.SetBattle = {{"03_CombatEurope1.mp3", 117}, {"43_Extra1_DarkMoor_Combat.mp3", 120}, {"04_CombatMediterranean1.mp3", 113}, {"05_CombatEvelance1.mp3", 117}}
	LocalMusic.SetEvilBattle = {{"43_Extra1_DarkMoor_Combat.mp3", 120},    {"05_CombatEvelance1.mp3", 117}, {"04_CombatMediterranean1.mp3", 113}, {"03_CombatEurope1.mp3", 117}}
	--
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Normal()
	TributeP1_Hard()
	TributeP1_Insane()
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
function TributeP1_Insane()
	local TrP1_I =  {}
	TrP1_I.playerId = 1
	TrP1_I.text = "Klickt hier, um den @color:255,0,0 irrsinnigen @color:255,255,255 Spielmodus zu spielen"
	TrP1_I.cost = { Gold = 0 }
	TrP1_I.Callback = TributePaid_P1_Insane
	TP1_I = AddTribute(TrP1_I)
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_H)
	Logic.RemoveTribute(1,TP1_I)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 6 )
	gvDiffLVL = 3
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 2
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
function TributePaid_P1_Insane()
	Message("Ihr habt euch für den @color:255,0,0 irrsinnigen @color:255,255,255 Spielmodus entschieden! Achtung: Auf dieser Stufe ist diese Karte extrem schwer!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 1
	--
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	PrepareForStart()
end
function PrepareForStart()
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
	end
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	--
	StartCountdown((30 + 10*gvDiffLVL)*60, CD_finished, true)
----------------------------------------------------------------------------------------------------
    -- Init local map stuff
	Mission_InitGroups()
	Mission_InitLocalResources()
	--
	SetupAIs()
end
----------------------------------------------------------------------------------------------------

--MapEditor_SetupAI( pID, strength, range, techlevel, position, aggressiveness, peacetime )

function SetupAIs()

	local pID

	for pID = 3, 6 do

		MapEditor_SetupAI( pID, 3, 999999, 3, "P"..pID.."HQ", 3, 0 )
		MapEditor_Armies[pID].offensiveArmies.strength = round(30/gvDiffLVL)

		SetupPlayerAi( pID,
		{
			serfLimit = 8,
			extracting = 0,
			repairing = true,
			constructing = false
		})

		Display.SetPlayerColorMapping(pID, KERBEROS_COLOR)

		-- diplomacy
		--SetNeutral( 1, pID )
		--SetNeutral( 2, pID )
		SetHostile(1, pID)
		SetHostile(2, pID)

	end

	SetPlayerName( 3, "Angreifer" )

end
----------------------------------------------------------------------------------------------------

function Mission_InitGroups()
	-- no groups here
end

----------------------------------------------------------------------------------------------------

function Mission_InitLocalResources()
--	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	local InitGoldRaw	= 1000
	local InitClayRaw	= 2000
	local InitWoodRaw	= 2000
	local InitStoneRaw	= 1000
	local InitIronRaw	= 1000
	local InitSulfurRaw	=  500

	-- Add Players Resources, set tech states
	for i = 1, 2 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw)
		ForbidTechnology(Technologies.T_ChangeWeather, i)
		ForbidTechnology(Technologies.T_MakeSummer, i)
		ForbidTechnology(Technologies.T_MakeRain, i)
		ForbidTechnology(Technologies.T_MakeSnow, i)
		ForbidTechnology(Technologies.T_MakeThunderstorm, i)
	end

end

----------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") and IsDead("DarkCastle") then
		Victory()
		return true
	end
end

function CD_finished()
	local pID

	for pID = 3,6 do
		SetHostile(1, pID)
		SetHostile(2, pID)
	end

	Message("@color:200,20,20 Gebt acht, das Wasser wird bald gefrieren!")

	StartCountdown(60,WinterIsHere,false)
end
function WinterIsHere()
	StartWinter(10*60*60)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChanger", 1, {}, {})
end
function WeatherChanger()
	local newWeather = Event.GetNewWeatherState()
	if newWeather ~= 3 then
		StartWinter(10*60*60)
	end
end
function IntroBriefing()
     local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end

    AP{
        title	= "@color:255,125,20 Mission",
        text	= "Eine beachtlich grosse Armee erwartet Euch. Baut bis zum Wintereinbruch eigene Siedlungen und Armeen auf, um sie zu schlagen, sobald das Wasser gefriert! @cr @cr @color:150,150,150 (Esc - spiel starten)"
    }

    StartBriefing(briefing)
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end