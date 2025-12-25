
--------------------------------------------------------------------------------
-- MapName: (6) Aufstieg des B�sen - Vargs Raubzug
--
-- Author: Ghoul
--
if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Men� @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (6) Vargs Raubzug "
gvMapVersion = " v1.2"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,0,1)

	Mission_InitGroups()
	Mission_InitLocalResources()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	--
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(4,Dipl,false)
	StartCountdown(10,TributeForMainquest,false)
	StartCountdown(12,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)

	if XNetwork.Manager_DoesExist() == 0 then
		StartSimpleJob("AllyAbfrageP2")
		StartSimpleJob("AllyAbfrageP3")
		StartSimpleJob("AllyAbfrageP4")
		StartSimpleJob("AllyAbfrageP5")
		StartSimpleJob("AllyAbfrageP6")

		SetupKi2()
		SetupKi3()
		SetupKi4()
		SetupKi5()
		SetupKi6()
		ExtraHeld()

		SetPlayerName(2,"Erec")
     	SetPlayerName(3,"Ari")
        SetPlayerName(4,"Drake")
        SetPlayerName(5,"Yuki")
        SetPlayerName(6,"Helias")

		for i=1,6,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")
	StartSimpleJob("SJ_DefeatP3")
    StartSimpleJob("SJ_DefeatP4")
    StartSimpleJob("SJ_DefeatP5")
    StartSimpleJob("SJ_DefeatP6")

	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
	end

	LocalMusic.UseSet = HIGHLANDMUSIC
	for i = 1, 6 do
        Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
    end;
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function Mission_InitLocalResources()
end
function Dipl()
	SetNeutral(1,2)
	SetNeutral(1,3)
	SetNeutral(1,4)
	SetNeutral(1,5)
	SetNeutral(1,6)
	SetNeutral(2,3)
	SetNeutral(2,4)
	SetNeutral(2,5)
	SetNeutral(2,6)
	SetNeutral(3,4)
	SetNeutral(3,5)
	SetNeutral(3,6)
	SetNeutral(4,5)
	SetNeutral(4,6)
	SetNeutral(5,6)
	--
end
function Hauptaufgabe()
	local tribute =  {}
	tribute.playerId = 8
	tribute.text = " "
	tribute.cost = { Gold = 0 }
	tribute.Callback = AddMainquestForPlayer1
	TributMainquestP1 = AddTribute(tribute)

	local tribute2 =  {}
	tribute2.playerId = 8
	tribute2.text = " "
	tribute2.cost = { Gold = 0 }
	tribute2.Callback = AddMainquestForPlayer2
	TributMainquestP2 = AddTribute(tribute2)

	local tribute3 =  {}
	tribute3.playerId = 8
	tribute3.text = " "
	tribute3.cost = { Gold = 0 }
	tribute3.Callback = AddMainquestForPlayer3
	TributMainquestP3 = AddTribute(tribute3)

	local tribute4 =  {}
	tribute4.playerId = 8
	tribute4.text = " "
	tribute4.cost = { Gold = 0 }
	tribute4.Callback = AddMainquestForPlayer4
	TributMainquestP4 = AddTribute(tribute4)

	local tribute5 =  {}
	tribute5.playerId = 8
	tribute5.text = " "
	tribute5.cost = { Gold = 0 }
	tribute5.Callback = AddMainquestForPlayer5
	TributMainquestP4 = AddTribute(tribute5)

	local tribute6 =  {}
	tribute6.playerId = 8
	tribute6.text = " "
	tribute6.cost = { Gold = 0 }
	tribute6.Callback = AddMainquestForPlayer6
	TributMainquestP6 = AddTribute(tribute6)

end
function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
	GUI.PayTribute(8,TributMainquestP3)
	GUI.PayTribute(8,TributMainquestP4)
	GUI.PayTribute(8,TributMainquestP5)
	GUI.PayTribute(8,TributMainquestP6)
end
function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function AddMainquestForPlayer3()
	Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function AddMainquestForPlayer4()
	Logic.AddQuest(4,4,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function AddMainquestForPlayer5()
	Logic.AddQuest(5,5,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function AddMainquestForPlayer6()
	Logic.AddQuest(6,6,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Varg! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end

function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
	return true
end
--
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
	return true
end
--
function Schwierigkeitsgradbestimmer()
	Tribut6()
	Tribut7()
	Tribut8()
	Tribut9()
	Tribut10()
	return true
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:0,250,200 <<Kooperation/Normal>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut7()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:0,250,200 <<Kooperation/Schwer>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut8()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:0,250,200 <<Kooperation/Extrem Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function Tribut9()
	local TrMod3 =  {}
	TrMod3.playerId = 1
	TrMod3.text = "Spielmodus @color:0,250,200 <<3vs3/Normal>>! "
	TrMod3.cost = { Gold = 0 }
	TrMod3.Callback = SpielmodVs1
	TMod3 = AddTribute(TrMod3)
end
function Tribut10()
	local TrMod4 =  {}
	TrMod4.playerId = 1
	TrMod4.text = "Spielmodus @color:0,250,200 <<3vs3/Schwer>>! "
	TrMod4.cost = { Gold = 0 }
	TrMod4.Callback = SpielmodVs2
	TMod4 = AddTribute(TrMod4)
end
--

function VictoryJob()
	if IsDead("VargHQ") and IsDead("P7HQ") and IsDead("P8HQ")then
		Victory()
		return true
	end
end
function VictoryJobVsNormal()
	if IsDead("P1HQ") and IsDead("P2HQ") and IsDead("P3HQ") then
		Logic.PlayerSetGameStateToWon(4)
		Logic.PlayerSetGameStateToWon(5)
		Logic.PlayerSetGameStateToWon(6)
		return true
	end
	if IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") then
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		return true
	end
end
function VictoryJobVsSchwer()
	if IsDead("P1HQ") and IsDead("P2HQ") and IsDead("P3HQ") and IsDead("VargHQ") and IsDead("P7HQ") and IsDead("P8HQ") then
		Logic.PlayerSetGameStateToWon(4)
		Logic.PlayerSetGameStateToWon(5)
		Logic.PlayerSetGameStateToWon(6)
	return true
	end
	if IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") and IsDead("VargHQ") and IsDead("P7HQ") and IsDead("P8HQ") then
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		return true
	end
end

function SJ_DefeatP1()
	if IsDead("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
  		return true
	end
end

function SJ_DefeatP2()
	if IsDead("P2HQ") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end
function SJ_DefeatP3()
	if IsDead("P3HQ") then
		Logic.PlayerSetGameStateToLost(3)
		return true
	end
end
function SJ_DefeatP4()
	if IsDead("P4HQ") then
		Logic.PlayerSetGameStateToLost(4)
		return true
	end
end
function SJ_DefeatP5()
	if IsDead("P5HQ") then
		Logic.PlayerSetGameStateToLost(5)
		return true
	end
end
function SJ_DefeatP6()
	if IsDead("P6HQ") then
		Logic.PlayerSetGameStateToLost(6)
		return true
	end
end

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Willkommen in diesen kalten nordischen Gefilden."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Leider gibt es keine Zeit, um sich hier zu entspannen. Varg wird immer stärker und ist kaum noch aufzuhalten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Er und seine mordenden Truppen verbreiten überall wo sie vorbeikommen, großes Elend! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Viel Erfolg beim Besiegen von Varg und seinen Truppen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Eilt euch, der Winter setzt bald ein! Und der kann hier im hohen Norden ewig dauern!"
    }
	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }


    StartBriefing(briefing)
end

function AllyAbfrageP2()
	if not IsExisting("P2HQ") then
		CreateEntity(2,Entities.PU_Serf,GetPosition("P2Serf1"))
		CreateEntity(2,Entities.PU_Serf,GetPosition("P2Serf2"))
		CreateEntity(2,Entities.PU_Serf,GetPosition("P2Serf3"))
		CreateEntity(2,Entities.PU_Serf,GetPosition("P2Serf4"))
		--
		CreateEntity(2, Entities.PB_Headquarters1, GetPosition("P2HQX"), "P2HQ")
		SetupKi2()
		return true
	else
		return true
	end
end
function AllyAbfrageP3()
	if not IsExisting("P3HQ") then
		CreateEntity(3,Entities.PU_Serf,GetPosition("P3Serf1"))
		CreateEntity(3,Entities.PU_Serf,GetPosition("P3Serf2"))
		CreateEntity(3,Entities.PU_Serf,GetPosition("P3Serf3"))
		CreateEntity(3,Entities.PU_Serf,GetPosition("P3Serf4"))
		--
		CreateEntity(3, Entities.PB_Headquarters1, GetPosition("P3HQX"), "P3HQ")
		--
		SetupKi3()
		return true
	else
		return true
	end
end
function AllyAbfrageP4()
	if not IsExisting("P4HQ") then
		CreateEntity(4,Entities.PU_Serf,GetPosition("P4Serf1"))
		CreateEntity(4,Entities.PU_Serf,GetPosition("P4Serf2"))
		CreateEntity(4,Entities.PU_Serf,GetPosition("P4Serf3"))
		CreateEntity(4,Entities.PU_Serf,GetPosition("P4Serf4"))
		--
		CreateEntity(4, Entities.PB_Headquarters1, GetPosition("P4HQX"), "P4HQ")
		SetupKi4()
		return true
	else
		return true
	end
end
function AllyAbfrageP5()
	if not IsExisting("P5HQ") then
		CreateEntity(5,Entities.PU_Serf,GetPosition("P5Serf1"))
		CreateEntity(5,Entities.PU_Serf,GetPosition("P5Serf2"))
		CreateEntity(5,Entities.PU_Serf,GetPosition("P5Serf3"))
		CreateEntity(5,Entities.PU_Serf,GetPosition("P5Serf4"))
		--
		CreateEntity(5, Entities.PB_Headquarters1, GetPosition("P5HQX"), "P5HQ")
		SetupKi5()
		return true
	else
		return true
	end
end
function AllyAbfrageP6()
	if not IsExisting("P6HQ") then
		CreateEntity(6,Entities.PU_Serf,GetPosition("P6Serf1"))
		CreateEntity(6,Entities.PU_Serf,GetPosition("P6Serf2"))
		CreateEntity(6,Entities.PU_Serf,GetPosition("P6Serf3"))
		CreateEntity(6,Entities.PU_Serf,GetPosition("P6Serf4"))
		--
		CreateEntity(6, Entities.PB_Headquarters1, GetPosition("P6HQX"), "P6HQ")
		SetupKi6()
		return true
	else
		return true
	end
end
function ExtraHeld()
	CreateEntity(1,Entities.PU_Hero2,GetPosition("H1"),"Pilgrim")
	CreateEntity(2,Entities.PU_Hero4,GetPosition("H2"))
	CreateEntity(3,Entities.PU_Hero5,GetPosition("H3"))
	CreateEntity(4,Entities.PU_Hero10,GetPosition("H4"))
	CreateEntity(5,Entities.PU_Hero11,GetPosition("H5"))
	CreateEntity(6,Entities.PU_Hero6,GetPosition("H6"))
	Truhen()
end
function SpielmodKoop0()
	Message("Ihr habt den @color:0,250,100 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	VargTicker = StartCountdown(55*60,VargVorbereitung,true)
	StartCountdown(52*60,AngriffsErinnerung,false)
	StartCountdown(95*60,SpezialWeg,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	Logic.RemoveTribute(1,TMod4)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	--
	DestroyEntity("Sperre1")
	DestroyEntity("Sperre2")
	DestroyEntity("Sperre3")
	DestroyEntity("Sperre4")
	DestroyEntity("Sperre5")
	DestroyEntity("Sperre6")
	DestroyEntity("Sperre7")
	DestroyEntity("Sperre8")
	DestroyEntity("Sperre9")
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(1,5)
	SetFriendly(1,6)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(2,5)
	SetFriendly(2,6)
	SetFriendly(3,4)
	SetFriendly(3,5)
	SetFriendly(3,6)
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(1,5,true)
	ActivateShareExploration(1,6,true)
	ActivateShareExploration(2,5,true)
	ActivateShareExploration(2,6,true)
	ActivateShareExploration(3,5,true)
	ActivateShareExploration(3,6,true)
	ActivateShareExploration(4,5,true)
	ActivateShareExploration(4,6,true)
	ActivateShareExploration(5,6,true)
	ActivateShareExploration(2,3,true)
	ActivateShareExploration(4,1,true)
	ActivateShareExploration(4,2,true)
	ActivateShareExploration(4,3,true)
	--
	for i = 1,6 do

		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
		--
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)
		--
	end
	--
	StopCountdown(Erinnerung)
	--
	--

	-- Initial Resources
	local InitGoldRaw 		= 900
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 250
	local InitSulfurRaw		= 250


	--Add Players Resources
	for i = 1,6 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	VargTicker = StartCountdown(45*60,VargVorbereitung,true)
	StartCountdown(42*60,AngriffsErinnerung,false)
	StartCountdown(75*60,SpezialWeg,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	Logic.RemoveTribute(1,TMod4)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	--
	DestroyEntity("Sperre1")
	DestroyEntity("Sperre2")
	DestroyEntity("Sperre3")
	DestroyEntity("Sperre4")
	DestroyEntity("Sperre5")
	DestroyEntity("Sperre6")
	DestroyEntity("Sperre7")
	DestroyEntity("Sperre8")
	DestroyEntity("Sperre9")
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(1,5)
	SetFriendly(1,6)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(2,5)
	SetFriendly(2,6)
	SetFriendly(3,4)
	SetFriendly(3,5)
	SetFriendly(3,6)
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(1,5,true)
	ActivateShareExploration(1,6,true)
	ActivateShareExploration(2,5,true)
	ActivateShareExploration(2,6,true)
	ActivateShareExploration(3,5,true)
	ActivateShareExploration(3,6,true)
	ActivateShareExploration(4,5,true)
	ActivateShareExploration(4,6,true)
	ActivateShareExploration(5,6,true)
	ActivateShareExploration(2,3,true)
	ActivateShareExploration(4,1,true)
	ActivateShareExploration(4,2,true)
	ActivateShareExploration(4,3,true)
	--
	for i = 1,6 do

		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)
		--
	end
	--
	StopCountdown(Erinnerung)
	--
	--

	-- Initial Resources
	local InitGoldRaw 		= 700
	local InitClayRaw 		= 1000
	local InitWoodRaw 		= 1000
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 250
	local InitSulfurRaw		= 250


	--Add Players Resources
	for i = 1,6 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end


function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<EXTREM SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	VargTicker = StartCountdown(35*60,VargVorbereitung,true)
	StartCountdown(45*60,ExtraTruppen, false)
	StartCountdown(32*60,AngriffsErinnerung,false)
	StartCountdown(55*60,SpezialWeg,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod3)
	Logic.RemoveTribute(1,TMod4)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	DestroyEntity("Sperre1")
	DestroyEntity("Sperre2")
	DestroyEntity("Sperre3")
	DestroyEntity("Sperre4")
	DestroyEntity("Sperre5")
	DestroyEntity("Sperre6")
	DestroyEntity("Sperre7")
	DestroyEntity("Sperre8")
	DestroyEntity("Sperre9")
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(1,5)
	SetFriendly(1,6)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(2,5)
	SetFriendly(2,6)
	SetFriendly(3,4)
	SetFriendly(3,5)
	SetFriendly(3,6)
	---
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(1,5,true)
	ActivateShareExploration(1,6,true)
	ActivateShareExploration(2,5,true)
	ActivateShareExploration(2,6,true)
	ActivateShareExploration(3,5,true)
	ActivateShareExploration(3,6,true)
	ActivateShareExploration(4,5,true)
	ActivateShareExploration(4,6,true)
	ActivateShareExploration(5,6,true)
	ActivateShareExploration(2,3,true)
	ActivateShareExploration(4,1,true)
	ActivateShareExploration(4,2,true)
	ActivateShareExploration(4,3,true)
	--
	for i = 1,6 do

		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)
		--
	end
	--
	StopCountdown(Erinnerung)
	--
	--

	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 600
	local InitWoodRaw 		= 600
	local InitStoneRaw 		= 400
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0


	--Add Players Resources
	for i = 1,6 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 EXTREM SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end

function SpielmodVs1()
	Message("Ihr habt den @color:0,250,200 <<NORMALEN 3VS3 MODUS>> @color:255,255,255 gewählt")
	StartCountdown(35*60,VsModus,true)
	VargTicker = StartCountdown(60*60,VargVorbereitung,false)
	StartCountdown(90*60,SpezialWeg,false)
	StartSimpleJob("VictoryJobVsNormal")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod4)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(2,3)
	SetFriendly(4,5)
	SetFriendly(4,6)
	SetFriendly(5,6)
	SetHostile(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)
	SetHostile(3,4)
	SetHostile(3,5)
	SetHostile(3,6)
	---
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(4,5,true)
	ActivateShareExploration(4,6,true)
	ActivateShareExploration(5,6,true)
	ActivateShareExploration(2,3,true)
	--
	Logic.SetShareExplorationWithPlayerFlag(1, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(1, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(1, 6, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 6, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 6, 0)
	--
	Logic.SetShareExplorationWithPlayerFlag(4, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(4, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(4, 3, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 3, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 3, 0)
	Logic.ForceFullExplorationUpdate()
	--
	for i = 1,6 do

		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)

		--
	end
	--
	StopCountdown(Erinnerung)
	--
	--

	-- Initial Resources
	local InitGoldRaw 		= 1400
	local InitClayRaw 		= 900
	local InitWoodRaw 		= 900
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 300
	local InitSulfurRaw		= 200


	--Add Players Resources
	for i = 1,6 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 3vs3 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end

function SpielmodVs2()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN 3VS3 MODUS>> @color:255,255,255 gewählt")
	StartCountdown(20*60,VsModus,true)
	VargTicker = StartCountdown(45*60,VargVorbereitung,false)
	StartCountdown(48*60,ExtraTruppen, false)
	StartCountdown(60*60,SpezialWeg,false)
	StartSimpleJob("VictoryJobVsSchwer")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	---
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(2,3)
	SetFriendly(4,5)
	SetFriendly(4,6)
	SetFriendly(5,6)
	SetHostile(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)
	SetHostile(3,4)
	SetHostile(3,5)
	SetHostile(3,6)
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(4,5,true)
	ActivateShareExploration(4,6,true)
	ActivateShareExploration(5,6,true)
	ActivateShareExploration(2,3,true)
	--
	Logic.SetShareExplorationWithPlayerFlag(1, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(1, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(1, 6, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(2, 6, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 4, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 5, 0)
	Logic.SetShareExplorationWithPlayerFlag(3, 6, 0)
	--
	Logic.SetShareExplorationWithPlayerFlag(4, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(4, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(4, 3, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(5, 3, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 1, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 2, 0)
	Logic.SetShareExplorationWithPlayerFlag(6, 3, 0)
	Logic.ForceFullExplorationUpdate()
	--
	for i = 1,6 do

		ResearchTechnology(Technologies.GT_Mercenaries, i)
		--
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)
		--
	end
	--
	StopCountdown(Erinnerung)
	--
	--

	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 750
	local InitWoodRaw 		= 750
	local InitStoneRaw 		= 500
	local InitIronRaw 		= 200
	local InitSulfurRaw		= 150


	--Add Players Resources
	for i = 1,6 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 3vs3 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end

function SetupKi2()
    MapEditor_SetupAI(2,1,999999,1,"Player2",3,0)
	SetupPlayerAi(2, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 15000,
        clay	= 20000,
        iron	= 8000,
        sulfur	= 5000,
        stone	= 20000,
        wood	= 20000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 300}}
	)

	local constructionplanP2 = {

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2Lehm1"), level = 1 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Archery1, pos = GetPosition("P2Kaserne"), level = 1 },	-- Schie�anlage
		{ type = Entities.PB_University1, pos = GetPosition("P2Uni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P2Eisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P2Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2Lehm2"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus			-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2Holz1"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2Holz3"), level = 1 },		-- S�gem�hle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P2Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P2Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },						-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 1 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P2Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(2,constructionplanP2)


	StartCountdown(8*60,UpgradeP2a,false)

	SetNeutral(2,1)
	SetNeutral(2,3)
	SetNeutral(2,4)
	SetNeutral(2,5)
	SetNeutral(2,6)
end

function UpgradeP2a()
	AI.Village_SetSerfLimit(2,16)

	if IsExisting("P2HQ") then UpgradeBuilding("P2HQ") end

	StartCountdown(15*60,UpgradeP2b,false)
end

function UpgradeP2b()
	AI.Village_SetSerfLimit(2,20)

	while GetStone(2) < 800 do
		AddStone(2,100)
	end

	while GetWood(2) < 800 do
		AddWood(2,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	StartCountdown(25*60,UpgradeP2c,false)
end

function UpgradeP2c()
	AI.Village_SetSerfLimit(2,24)

	if IsExisting("P2HQ") then UpgradeBuilding("P2HQ") end

	while GetStone(2) < 800 do
		AddStone(2,100)
	end

	while GetWood(2) < 800 do
		AddWood(2,100)
	end


	StartCountdown(20*60,UpgradeP2d,false)
end

function UpgradeP2d()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)

	ResearchTechnology(Technologies.T_SoftArcherArmor,2)
	ResearchTechnology(Technologies.T_LeatherMailArmor,2)

	StartCountdown(12*60,UpgradeP2e,false)
end

function UpgradeP2e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)

	ResearchTechnology(Technologies.T_SoftArcherArmor,2)
	ResearchTechnology(Technologies.T_LeatherMailArmor,2)

	StartCountdown(10*60,UpgradeP2f,false)
end

function UpgradeP2f()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)
	ResearchTechnology(Technologies.T_MasterOfSmithery,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(14*60,UpgradeP2g,false)
end

function UpgradeP2g()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)

	ResearchTechnology(Technologies.T_Fletching,2)
	ResearchTechnology(Technologies.T_WoodAging,2)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)

	StartCountdown(20*60,UpgradeP2h,false)
end


function UpgradeP2h()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(15*60,UpgradeP2i,false)
end

function UpgradeP2i()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)


end
function SetupKi3()
    MapEditor_SetupAI(3,1,999999,1,"Player3",3,0)
	SetupPlayerAi(3, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 15000,
        clay	= 20000,
        iron	= 8000,
        sulfur	= 5000,
        stone	= 20000,
        wood	= 20000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 300}}
	)

	local constructionplanP3 = {

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3Lehm1"), level = 1 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P3Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Stable1, pos = GetPosition("P3Kaserne"), level = 1 },	-- Reiterei
		{ type = Entities.PB_University1, pos = GetPosition("P3Uni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P3Eisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P3Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3Lehm2"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus			-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P3Holz1"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P3Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P3Holz3"), level = 1 },		-- S�gem�hle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P3Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P3Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P3Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },						-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P3Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(3,constructionplanP3)


	StartCountdown(8*60,UpgradeP3a,false)

	SetNeutral(3,1)
	SetNeutral(3,2)
	SetNeutral(3,4)
	SetNeutral(3,5)
	SetNeutral(3,6)
end

function UpgradeP3a()
	AI.Village_SetSerfLimit(3,16)

	if IsExisting("P3HQ") then UpgradeBuilding("P3HQ") end

	StartCountdown(15*60,UpgradeP3b,false)
end

function UpgradeP3b()
	AI.Village_SetSerfLimit(3,20)

	while GetStone(3) < 800 do
		AddStone(3,100)
	end

	while GetWood(3) < 800 do
		AddWood(3,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(3,researchplan)

	StartCountdown(25*60,UpgradeP3c,false)
end

function UpgradeP3c()
	AI.Village_SetSerfLimit(3,24)

	if IsExisting("P3HQ") then UpgradeBuilding("P3HQ") end

	while GetStone(3) < 800 do
		AddStone(3,100)
	end

	while GetWood(3) < 800 do
		AddWood(3,100)
	end


	StartCountdown(20*60,UpgradeP3d,false)
end

function UpgradeP3d()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,3)

	ResearchTechnology(Technologies.T_SoftArcherArmor,3)
	ResearchTechnology(Technologies.T_LeatherMailArmor,3)

	StartCountdown(12*60,UpgradeP3e,false)
end

function UpgradeP3e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,3)

	ResearchTechnology(Technologies.T_SoftArcherArmor,3)
	ResearchTechnology(Technologies.T_LeatherMailArmor,3)

	StartCountdown(10*60,UpgradeP3f,false)
end

function UpgradeP3f()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(3,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,3)
	ResearchTechnology(Technologies.T_ChainMailArmor,3)
	ResearchTechnology(Technologies.T_MasterOfSmithery,3)
	ResearchTechnology(Technologies.T_FleeceArmor,3)
	ResearchTechnology(Technologies.T_LeadShot,3)

	StartCountdown(14*60,UpgradeP3g,false)
end

function UpgradeP3g()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(3,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,3)

	ResearchTechnology(Technologies.T_Fletching,3)
	ResearchTechnology(Technologies.T_WoodAging,3)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,3)
	ResearchTechnology(Technologies.T_ChainMailArmor,3)

	StartCountdown(20*60,UpgradeP3h,false)
end


function UpgradeP3h()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(3,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,3)
	ResearchTechnology(Technologies.T_FleeceArmor,3)
	ResearchTechnology(Technologies.T_LeadShot,3)

	StartCountdown(15*60,UpgradeP3i,false)
end

function UpgradeP3i()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(3,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,3)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,3)

end
function SetupKi4()
    MapEditor_SetupAI(4,1,999999,1,"Player4",3,0)
	SetupPlayerAi(4, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 15000,
        clay	= 20000,
        iron	= 8000,
        sulfur	= 5000,
        stone	= 20000,
        wood	= 20000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 300}}
	)

	local constructionplanP4 = {

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P4Lehm1"), level = 1 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P4Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Archery1, pos = GetPosition("P4Kaserne"), level = 1 },	-- Schie�anlage
		{ type = Entities.PB_University1, pos = GetPosition("P4Uni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P4Eisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P4Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P4Lehm2"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus			-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P4Holz1"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P4Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P4Holz3"), level = 1 },		-- S�gem�hle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P4Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P4Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P4Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },						-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P4Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(4,constructionplanP4)


	StartCountdown(8*60,UpgradeP4a,false)

	SetNeutral(4,1)
	SetNeutral(4,2)
	SetNeutral(4,3)
	SetNeutral(4,5)
	SetNeutral(4,6)
end

function UpgradeP4a()
	AI.Village_SetSerfLimit(4,16)

	if IsExisting("P4HQ") then UpgradeBuilding("P4HQ") end

	StartCountdown(15*60,UpgradeP4b,false)
end

function UpgradeP4b()
	AI.Village_SetSerfLimit(4,20)

	while GetStone(4) < 800 do
		AddStone(4,100)
	end

	while GetWood(4) < 800 do
		AddWood(4,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(4,researchplan)

	StartCountdown(25*60,UpgradeP4c,false)
end

function UpgradeP4c()
	AI.Village_SetSerfLimit(4,24)

	if IsExisting("P4HQ") then UpgradeBuilding("P4HQ") end

	while GetStone(4) < 800 do
		AddStone(4,100)
	end

	while GetWood(4) < 800 do
		AddWood(4,100)
	end


	StartCountdown(20*60,UpgradeP4d,false)
end

function UpgradeP4d()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)

	ResearchTechnology(Technologies.T_SoftArcherArmor,4)
	ResearchTechnology(Technologies.T_LeatherMailArmor,4)

	StartCountdown(12*60,UpgradeP4e,false)
end

function UpgradeP4e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)

	ResearchTechnology(Technologies.T_SoftArcherArmor,4)
	ResearchTechnology(Technologies.T_LeatherMailArmor,4)

	StartCountdown(10*60,UpgradeP4f,false)
end

function UpgradeP4f()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(4,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,4)
	ResearchTechnology(Technologies.T_ChainMailArmor,4)
	ResearchTechnology(Technologies.T_MasterOfSmithery,4)
	ResearchTechnology(Technologies.T_FleeceArmor,4)
	ResearchTechnology(Technologies.T_LeadShot,4)

	StartCountdown(14*60,UpgradeP4g,false)
end

function UpgradeP4g()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(4,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,4)

	ResearchTechnology(Technologies.T_Fletching,4)
	ResearchTechnology(Technologies.T_WoodAging,4)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,4)
	ResearchTechnology(Technologies.T_ChainMailArmor,4)

	StartCountdown(20*60,UpgradeP4h,false)
end


function UpgradeP4h()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(4,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,4)
	ResearchTechnology(Technologies.T_FleeceArmor,4)
	ResearchTechnology(Technologies.T_LeadShot,4)

	StartCountdown(15*60,UpgradeP4i,false)
end

function UpgradeP4i()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(4,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,4)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,4)

end
function SetupKi5()
    MapEditor_SetupAI(5,1,999999,1,"Player5",3,0)
	SetupPlayerAi(5, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 15000,
        clay	= 20000,
        iron	= 8000,
        sulfur	= 5000,
        stone	= 20000,
        wood	= 20000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 300}}
	)

	local constructionplanP5 = {

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P5Lehm1"), level = 1 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P5Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Barracks1, pos = GetPosition("P5Kaserne"), level = 1 },	-- Kaserne
		{ type = Entities.PB_University1, pos = GetPosition("P5Uni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P5Eisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P5Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P5Lehm2"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus			-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P5Holz1"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P5Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P5Holz3"), level = 1 },		-- S�gem�hle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P5Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P5Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P5Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },						-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 1 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P5HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P5HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P5Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(5,constructionplanP5)

	StartCountdown(8*60,UpgradeP5a,false)

	SetNeutral(5,1)
	SetNeutral(5,2)
	SetNeutral(5,3)
	SetNeutral(5,4)
	SetNeutral(5,6)
end

function UpgradeP5a()
	AI.Village_SetSerfLimit(5,16)

	if IsExisting("P5HQ") then UpgradeBuilding("P5HQ") end

	StartCountdown(15*60,UpgradeP5b,false)
end

function UpgradeP5b()
	AI.Village_SetSerfLimit(5,20)

	while GetStone(5) < 800 do
		AddStone(5,100)
	end

	while GetWood(5) < 800 do
		AddWood(5,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(5,researchplan)

	StartCountdown(25*60,UpgradeP5c,false)
end

function UpgradeP5c()
	AI.Village_SetSerfLimit(5,24)

	if IsExisting("P5HQ") then UpgradeBuilding("P5HQ") end

	while GetStone(5) < 800 do
		AddStone(5,100)
	end

	while GetWood(5) < 800 do
		AddWood(5,100)
	end

	StartCountdown(20*60,UpgradeP5d,false)
end

function UpgradeP5d()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,5)

	ResearchTechnology(Technologies.T_SoftArcherArmor,5)
	ResearchTechnology(Technologies.T_LeatherMailArmor,5)

	StartCountdown(12*60,UpgradeP5e,false)
end

function UpgradeP5e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,5)

	ResearchTechnology(Technologies.T_SoftArcherArmor,5)
	ResearchTechnology(Technologies.T_LeatherMailArmor,5)

	StartCountdown(10*60,UpgradeP5f,false)
end

function UpgradeP5f()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(5,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,5)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,5)
	ResearchTechnology(Technologies.T_ChainMailArmor,5)
	ResearchTechnology(Technologies.T_MasterOfSmithery,5)
	ResearchTechnology(Technologies.T_FleeceArmor,5)
	ResearchTechnology(Technologies.T_LeadShot,5)

	StartCountdown(14*60,UpgradeP5g,false)
end

function UpgradeP5g()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(5,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,5)

	ResearchTechnology(Technologies.T_Fletching,5)
	ResearchTechnology(Technologies.T_WoodAging,5)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,5)
	ResearchTechnology(Technologies.T_ChainMailArmor,5)

	StartCountdown(20*60,UpgradeP5h,false)
end


function UpgradeP5h()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(5,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,5)
	ResearchTechnology(Technologies.T_FleeceArmor,5)
	ResearchTechnology(Technologies.T_LeadShot,5)

	StartCountdown(15*60,UpgradeP5i,false)
end

function UpgradeP5i()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(5,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,5)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,5)

end
function SetupKi6()
    MapEditor_SetupAI(6,1,999999,1,"Player6",3,0)
	SetupPlayerAi(6, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 15000,
        clay	= 20000,
        iron	= 8000,
        sulfur	= 5000,
        stone	= 20000,
        wood	= 20000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 300}}
	)

	local constructionplanP6 = {

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P6Lehm1"), level = 1 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P6Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
    	{ type = Entities.PB_Barracks1, pos = GetPosition("P6Kaserne"), level = 1 },	-- Kaserne
		{ type = Entities.PB_University1, pos = GetPosition("P6Uni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P6Eisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P6Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P6Lehm2"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus			-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P6Holz1"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P6Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P6Holz3"), level = 1 },		-- S�gem�hle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P6Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P6Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P6Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },						-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },					-- Schiessanlage
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P6HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P6HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P6Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(6,constructionplanP6)


	StartCountdown(8*60,UpgradeP6a,false)

	SetNeutral(6,1)
	SetNeutral(6,3)
	SetNeutral(6,4)
	SetNeutral(6,5)
	SetNeutral(2,6)
end
function UpgradeP6a()
	AI.Village_SetSerfLimit(6,16)

	if IsExisting("P6HQ") then UpgradeBuilding("P6HQ") end

	StartCountdown(15*60,UpgradeP6b,false)
end
function UpgradeP6b()
	AI.Village_SetSerfLimit(6,20)

	while GetStone(6) < 800 do
		AddStone(6,100)
	end

	while GetWood(6) < 800 do
		AddWood(6,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(6,researchplan)

	StartCountdown(25*60,UpgradeP6c,false)
end
function UpgradeP6c()
	AI.Village_SetSerfLimit(6,24)

	if IsExisting("P6HQ") then UpgradeBuilding("P6HQ") end

	while GetStone(6) < 800 do
		AddStone(6,100)
	end

	while GetWood(6) < 800 do
		AddWood(6,100)
	end


	StartCountdown(20*60,UpgradeP6d,false)
end
function UpgradeP6d()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,6)

	ResearchTechnology(Technologies.T_SoftArcherArmor,6)
	ResearchTechnology(Technologies.T_LeatherMailArmor,6)

	StartCountdown(12*60,UpgradeP6e,false)
end
function UpgradeP6e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,6)

	ResearchTechnology(Technologies.T_SoftArcherArmor,6)
	ResearchTechnology(Technologies.T_LeatherMailArmor,6)

	StartCountdown(10*60,UpgradeP6f,false)
end
function UpgradeP6f()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(6,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,6)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,6)
	ResearchTechnology(Technologies.T_ChainMailArmor,6)
	ResearchTechnology(Technologies.T_MasterOfSmithery,6)
	ResearchTechnology(Technologies.T_FleeceArmor,6)
	ResearchTechnology(Technologies.T_LeadShot,6)

	StartCountdown(14*60,UpgradeP6g,false)
end
function UpgradeP6g()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(6,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,6)

	ResearchTechnology(Technologies.T_Fletching,6)
	ResearchTechnology(Technologies.T_WoodAging,6)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,6)
	ResearchTechnology(Technologies.T_ChainMailArmor,6)

	StartCountdown(20*60,UpgradeP6h,false)
end
function UpgradeP6h()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(6,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,6)
	ResearchTechnology(Technologies.T_FleeceArmor,6)
	ResearchTechnology(Technologies.T_LeadShot,6)

	StartCountdown(15*60,UpgradeP6i,false)
end
function UpgradeP6i()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(6,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,6)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,6)

end
function Truhen()
	CreateRandomGoldChest(GetPosition("Gold1"))
	CreateRandomGoldChest(GetPosition("Gold2"))
	CreateRandomGoldChest(GetPosition("Gold3"))
	CreateRandomGoldChest(GetPosition("Gold4"))
	CreateRandomGoldChest(GetPosition("Gold5"))
	CreateRandomGoldChest(GetPosition("Gold6"))
	CreateRandomGoldChest(GetPosition("Gold7"))
	CreateRandomGoldChest(GetPosition("Gold8"))
	CreateRandomGoldChest(GetPosition("Gold9"))
	CreateRandomGoldChest(GetPosition("Gold10"))

	--
	CreateChestOpener("Pilgrim")
	--
	StartChestQuest()
end
function ExtraTruppen()
	CreateVargArmy5()
end
function CreateVargArmy5()

army5	 = {}

	army5.player 		= 7
	army5.id			= 5
	army5.strength		= 6
	army5.position		= GetPosition("ExtraSpawn")
	army5.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army5)

	local troopDescription = {

		maxNumberOfSoldiers	= 3,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderHeavyCavalry2
	}

	EnlargeArmy(army5,troopDescription)
	EnlargeArmy(army5,troopDescription)
	EnlargeArmy(army5,troopDescription)
	EnlargeArmy(army5,troopDescription)
	EnlargeArmy(army5,troopDescription)
	EnlargeArmy(army5,troopDescription)


  StartSimpleJob("ControlArmy5")

end
function CreateVargArmyFive()

	armyFive	 = {}

	armyFive.player 		= 7
	armyFive.id				= 6
	armyFive.strength		= 4
	armyFive.position		= GetPosition("ExtraSpawn")
	armyFive.rodeLength		= Logic.WorldGetSize()

	SetupArmy(armyFive)

	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}

	EnlargeArmy(armyFive,troopDescription)
	EnlargeArmy(armyFive,troopDescription)
	EnlargeArmy(armyFive,troopDescription)
	EnlargeArmy(armyFive,troopDescription)

	StartSimpleJob("ControlArmyFive")

end
function ControlArmy5()


    if IsDead(army5) and IsExisting("TurmExtra") then

        CreateVargArmyFive()

        return true

    else

       Advance(army5)

    end

end
function ControlArmyFive()

	if IsDead(armyFive) and IsExisting("TurmExtra") then

		CreateVargArmy5()
		return true
	else

		Advance(armyFive)

	end

end
function CreateVargArmy1()

	army1	 = {}

	army1.player 		= 8
	army1.id			= 1
	army1.strength		= 6
	army1.position		= GetPosition("Army1")
	army1.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army1)


	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderSword4
	}

	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)


	StartSimpleJob("ControlArmy1")

end
function CreateVargArmyTwo()

	armyTwo	 = {}

	armyTwo.player 			= 8
	armyTwo.id				= 2
	armyTwo.strength		= 4
	armyTwo.position		= GetPosition("Army2")
	armyTwo.rodeLength		= Logic.WorldGetSize()

	SetupArmy(armyTwo)


	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}

	EnlargeArmy(armyTwo,troopDescription)
	EnlargeArmy(armyTwo,troopDescription)
	EnlargeArmy(armyTwo,troopDescription)
	EnlargeArmy(armyTwo,troopDescription)

	StartSimpleJob("ControlArmyTwo")

end
function ControlArmy1()


    if IsDead(army1) and IsExisting("Turm1") then

        CreateVargArmyTwo()


        return true

    else


        Defend(army1)

    end

end
function ControlArmyTwo()


	if IsDead(armyTwo) and IsExisting("Turm1") then

		CreateVargArmy1()
		return true
	else

		Defend(armyTwo)


	end

end
function CreateVargArmy3()

	army3	 = {}

	army3.player 		= 7
	army3.id				= 3
	army3.strength		= 7
	army3.position		= GetPosition("Army3")
	army3.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army3)

	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Barbarian_LeaderClub2
	}

	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)


  StartSimpleJob("ControlArmy3")

end
function CreateVargArmy4()

	army4	 = {}

	army4.player 		= 7
	army4.id				= 4
	army4.strength		= 6
	army4.position		= GetPosition("Army4")
	army4.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army4)

	local troopDescription = {

		maxNumberOfSoldiers	= 4,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_VeteranLieutenant
	}

	EnlargeArmy(army4,troopDescription)
	EnlargeArmy(army4,troopDescription)
	EnlargeArmy(army4,troopDescription)
	EnlargeArmy(army4,troopDescription)
	EnlargeArmy(army4,troopDescription)
	EnlargeArmy(army4,troopDescription)

	StartSimpleJob("ControlArmy4")

end
function ControlArmy3()

    if IsDead(army3) and IsExisting("Turm2") then

        CreateVargArmy4()


        return true

    else

        Defend(army3)

    end

end
function ControlArmy4()

	if IsDead(army4) and IsExisting("Turm2") then

		CreateVargArmy3()
		return true
	else

		Defend(army4)

	end

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	Start()

end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermachine.
function Mission_InitTechnologies()
	ForbidTechnology (Technologies.B_PowerPlant )
	ForbidTechnology (Technologies.B_Weathermachine )

end

function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
end
function InitDiplomacy()
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(2,3)
	SetFriendly(4,5)
	SetFriendly(4,6)
	SetFriendly(5,6)
	for i = 1,6 do
		SetHostile(i,7)
		SetHostile(i,8)
		SetHostile(i,9)
		SetHostile(i,10)
	end
	--
  	SetPlayerName(8,"Vargs Barbaren")

end
function InitPlayerColorMapping()

	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrame"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMapOverlay"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMap"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrameBG"),0)
	--**
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Container"),0,0,1400,1000)  --90
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Text"),100,669,850,48)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"),0,1000,1200,128)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,600,100)

	for i = 7,10 do
	   Display.SetPlayerColorMapping(i,ROBBERS_COLOR)
	end

end
function VargVorbereitung()
	Message("Die Friedenszeit ist vorbei! ")
	Message("Bereitet Euch auf baldige Angriffe vor!")
	StartWinter(200*60*60)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChanger", 1, {}, {})
	StartSimpleJob("ArmeeWechsel")
	StartSimpleJob("Ruinen")
end
function WeatherChanger()
	local newWeather = Event.GetNewWeatherState()
	if newWeather ~= 3 then
		StartWinter(60*60*60)
	end
end
function ArmeeWechsel()
	if IsDestroyed("P8Bow") and IsDestroyed("P8Bow2") then
		ChangePlayer("P7Bow",8)
		return true
	end
	if IsDestroyed("P8Stable") and IsDestroyed("P8Stable2") then
		ChangePlayer("P7Stable",8)
		return true
	end
	if IsDestroyed("P8Kaserne") and IsDestroyed("P8Kaserne2") then
		ChangePlayer("P7Kaserne",8)
		return true
	end
	if IsDestroyed("P8Foundry") and IsDestroyed("P8Foundry2") then
		ChangePlayer("P7Foundry",8)
		return true
	end
	if IsExisting("Castle") and IsDestroyed("Wolf1") and IsDestroyed("Wolf2") and IsDestroyed("Wolf3") and IsDestroyed("Wolf4") and IsDestroyed("Wolf5") and IsDestroyed("Wolf6") then
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf1")
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf2")
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf3")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf4")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf5")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf6")
		return true
	end
	if IsDestroyed("CastleP7") then
		SetEntityName("P7","CastleP7")
		return true
	end
	if IsDestroyed("CastleP8") then
		SetEntityName("P8","CastleP8")
		return true
	end
end
function Ruinen()
	if IsDestroyed("Ruine1") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		return true
	end
	if IsDestroyed("Ruine2") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		return true
	end
	if IsDestroyed("Ruine3") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn1"))
		return true
	end
	if IsDestroyed("Ruine4") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		return true
	end
	if IsDestroyed("Ruine5") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		return true
	end
	if IsDestroyed("Ruine6") then
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(7,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateMilitaryGroup(8,Entities.CU_Barbarian_LeaderClub2,4,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("RuinSpawn2"))
		return true
	end
end

function VsModus()
	DestroyEntity("Sperre1")
	DestroyEntity("Sperre2")
	DestroyEntity("Sperre3")
	DestroyEntity("Sperre4")
	DestroyEntity("Sperre5")
	DestroyEntity("Sperre6")
	DestroyEntity("Sperre7")
	DestroyEntity("Sperre8")
	DestroyEntity("Sperre9")
	--
end

function AngriffsErinnerung()
	Message("Der Winter steht kurz bevor!")
	Message("Vargs Barbaren werden schon bald angreifen!")
	Sound.PlayGUISound(Sounds.VoicesMentor_VC_OnlySomeMinutesLeft_rnd_01,120)
	CreateVargArmy1()
	CreateVargArmy3()
	MapEditor_SetupAI(8,3,Logic.WorldGetSize(),3,"CastleP8",3,0)
	SetupPlayerAi( 8, {constructing = true, repairing = true, extracting = 1, serfLimit = 9} )
	MapEditor_SetupAI(7,3,Logic.WorldGetSize(),3,"CastleP7",3,0)
	SetupPlayerAi( 7, {constructing = true, repairing = true, extracting = 1, serfLimit = 7} )
	MapEditor_SetupAI(9,3,Logic.WorldGetSize(),3,"p9",3,0)
	SetupPlayerAi( 9, {constructing = true, repairing = true, extracting = 1, serfLimit = 7} )
	MapEditor_SetupAI(10,3,Logic.WorldGetSize(),3,"p10",3,0)
	SetupPlayerAi( 10, {constructing = true, repairing = true, extracting = 1, serfLimit = 7} )
end

function SpezialWeg()
	DestroyEntity("Fels1")
	DestroyEntity("Fels2")
	DestroyEntity("Fels3")
	DestroyEntity("Fels4")
	DestroyEntity("Fels5")
	DestroyEntity("Fels6")
	DestroyEntity("Fels7")
	DestroyEntity("Fels8")
	DestroyEntity("Fels9")
end

function UpgradeBuilding(_EntityName)
    -- Get entity's ID
    local EntityID = GetEntityId(_EntityName)
    -- Still existing?
    if IsValid(EntityID) then
        -- Get entity type and player
        local EntityType = Logic.GetEntityType(EntityID)
        local PlayerID = GetPlayer(EntityID)
        -- Get upgrade costs
        local Costs = {}
        Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
        -- Add needed resources
        for Resource, Amount in Costs do
            Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
        end
        -- Start upgrade
        GUI.UpgradeSingleBuilding(EntityID)
    end
end

function SetAIUnitsToBuild( _aiID, ... )
    for i = table.getn(DataTable), 1, -1 do
        if DataTable[i].player == _aiID and DataTable[i].AllowedTypes then
            DataTable[i].AllowedTypes = arg;
        end
    end
end 