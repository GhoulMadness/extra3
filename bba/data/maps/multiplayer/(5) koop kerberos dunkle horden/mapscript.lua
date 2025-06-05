--------------------------------------------------------------------------------
-- MapName: (5) Kerberos dunkle Horden
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (5) Kerberos dunkle Horden "
gvMapVersion = " v1.2"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	MAXPLAYERS = 8
	if CNetwork then
		MAXPLAYERS = 11
	end
	TagNachtZyklus(24,0,0,0,1)

	--Init local map stuff
	Mission_InitGroups()
	Mission_InitLocalResources()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	SetHumanPlayerDiplomacyToAllAIs()
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(7,TributeForMainquest,false)
	StartCountdown(8,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)

	if XNetwork.Manager_DoesExist() == 0 then
		StartCountdown(3,Dipl,false)
		ExtraHeld()
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(3,4,5,6)) do
			DestroyEntity(eID)
		end

		for i=1,5,1 do
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

	LocalMusic.UseSet = EVELANCEMUSIC
	for i = 1, 5 do Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i)); end;

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end


function Mission_InitLocalResources()

end
function Dipl()
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
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
end
function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
	GUI.PayTribute(8,TributMainquestP3)
end
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer3() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
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
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos,120)
	Tribut6()
	Tribut7()
	Tribut8()
	return true
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:200,80,60 <<Kooperation/Normal>>! "
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
	TrMod2.text = "Spielmodus @color:0,250,200 <<Kooperation/Irrsinnig>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
--
function VictoryJob()
	if IsDead("VargHQ")and IsDead("CastleP8") and IsDead("P7HQ") and IsDead("P8HQ")and IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ")then
		Victory()
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
function SJ_DefeatP3()
	if IsDead("P4HQ") then
		Logic.PlayerSetGameStateToLost(4)
		return true
	end
end
function SJ_DefeatP3()
	if IsDead("P5HQ") then
		Logic.PlayerSetGameStateToLost(5)
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
        text	= "@color:230,0,0 Leider gibt es keine Zeit, um sich hier zu entspannen. Kerberos und seine Schergen werden immer stärker und sind kaum noch aufzuhalten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Er und seine mordenden Truppen verbreiten überall wo sie vorbeikommen, großes Elend! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Viel Erfolg beim Besiegen von Kerberos und seinen Truppen!"
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
function Auswahl()
	Message("@color:230,100,0 Ihr könnt nun im Tributmenu auswählen, ob ihr mit oder ohne verbündete KI spielen wollt!")
	TributKI1()
	TributKI2()
end
function TributKI1()
	local TrKI1 =  {}
	TrKI1.playerId = 1
	TrKI1.text = "Spiele @color:0,250,200 <<MIT KI IM TEAM>>! "
	TrKI1.cost = { Gold = 0 }
	TrKI1.Callback = SpielKI1
	TKI1 = AddTribute(TrKI1)
end
function TributKI2()
	local TrKI2 =  {}
	TrKI2.playerId = 1
	TrKI2.text = "Spiele @color:0,250,200 <<OHNE KI IM TEAM>>! "
	TrKI2.cost = { Gold = 0 }
	TrKI2.Callback = SpielKI2
	TKI2 = AddTribute(TrKI2)
end
--
function SpielKI1()
	Logic.RemoveTribute(1,TKI2)
	SetPlayerName(2,"Erec")
	StartSimpleJob("AllyAbfrageP2")
	SetupKi2()
end
function SpielKI2()
	Logic.RemoveTribute(1,TKI1)
	DestroyEntity("P2VC")
	DestroyEntity("P2HQ")
	ChangePlayer("P2T1",1)
  	ChangePlayer("P2T2",1)
	ChangePlayer("P2T3",1)
	ChangePlayer("P2T4",1)
  	ChangePlayer("P2T5",1)
	ChangePlayer("P2T6",1)
	ChangePlayer("Erec",1)
	DestroyEntity("ShareAbfrage")
	StartCountdown(5,KI2Wechsel,false)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(2,5)
	SetFriendly(2,6)
	SetFriendly(2,7)
	SetFriendly(2,8)
end
function KI2Wechsel()
	ChangePlayer("StableP9",2)
	ChangePlayer("BarracksP9",2)
	ChangePlayer("FoundryP9",2)
	ChangePlayer("ArcheryP9",2)
	ChangePlayer("P9Stein1",2)
	ChangePlayer("P9Stein2",2)
	ChangePlayer("P9Eisen1",2)
	ChangePlayer("P9Eisen2",2)
	ChangePlayer("P9VC",2)
	ChangePlayer("P9Haus1",2)
	ChangePlayer("P9Haus2",2)
	ChangePlayer("P9Haus3",2)
	ChangePlayer("P9Haus4",2)
	ChangePlayer("P9Farm1",2)
	ChangePlayer("P9Farm2",2)
	ChangePlayer("P9Farm3",2)
	ChangePlayer("P9Farm4",2)
	AddGold(2,100000)
	MapEditor_SetupAI(2,3,Logic.WorldGetSize(),3,"P9",3,0)
	SetupPlayerAi( 8, {constructing = false, repairing = true, serfLimit = 9} )
	SetHostile(1,2)
	Display.SetPlayerColorMapping(2,KERBEROS_COLOR)
	EndJob("Wechsel")
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
function ExtraHeld()
	CreateEntity(1,Entities.PU_Hero2,GetPosition("H1"),"Pilgrim")
	CreateEntity(2,Entities.PU_Hero4,GetPosition("H2"),"Erec")
	Truhen()
end
function SpielmodKoop0()
	Message("Ihr habt den @color:200,80,60 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	KerbTicker = StartCountdown(65*60,KerbVorbereitung,true)
	StartCountdown(62*60,AngriffsErinnerung,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod1)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	SetFriendly(1,2)
	SetFriendly(2,1)
	--
	gvTechLVL = 2
	--
	for i = 1,5 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
		--
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		--
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 900
	local InitClayRaw 		= 1400
	local InitWoodRaw 		= 1400
	local InitStoneRaw 		= 900
	local InitIronRaw 		= 250
	local InitSulfurRaw		= 250


	--Add Players Resources
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	if XNetwork.Manager_DoesExist() == 0 then
		StartCountdown(5,Auswahl,false)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	KerbTicker = StartCountdown(55*60,KerbVorbereitung,true)
	StartCountdown(52*60,AngriffsErinnerung,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod0)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	SetFriendly(1,2)
	SetFriendly(2,1)
	--
	gvTechLVL = 3
	--
	for i = 1,5 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
		--
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		--
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 800
	local InitClayRaw 		= 1000
	local InitWoodRaw 		= 1000
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 250
	local InitSulfurRaw		= 250


	--Add Players Resources
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	if XNetwork.Manager_DoesExist() == 0 then
		StartCountdown(5,Auswahl,false)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	KerbTicker = StartCountdown(45*60,KerbVorbereitung,true)
	StartCountdown(53*60,ExtraTruppen, false)
	StartCountdown(42*60,AngriffsErinnerung,false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,200)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod0)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	gvTechLVL = 3
	--
	SetFriendly(1,2)
	SetFriendly(2,1)
	--
	for i = 1,5 do
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		--
	end
	for i = 6,8 do
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 700
	local InitWoodRaw 		= 700
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	--Add Players Resources
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	if XNetwork.Manager_DoesExist() == 0 then
		StartCountdown(5,Auswahl,false)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SetupKi2()
    MapEditor_SetupAI(2,2,Logic.WorldGetSize(),1,"Player2",3,0)
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

		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2Lehm"), level = 2 },		-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein1"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P2Eisen"), level = 2 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P2Schwefel"), level = 2 },		-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2Holz1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },		-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P2Clay"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2},				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P2Iron"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Archery1, pos = GetPosition("P2Kaserne"), level = 1 },	-- Schießanlage
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
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
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },

		}
	FeedAiWithConstructionPlanFile(2,constructionplanP2)

	SetFriendly(1,2)
	StartCountdown(5*60,UpgradeP2a,false)

end

function UpgradeP2a()
	AI.Village_SetSerfLimit(2,16)

	if IsExisting("P2HQ") then UpgradeBuilding("P2HQ") end

	StartCountdown(5*60,UpgradeP2b,false)
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
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	StartCountdown(8*60,UpgradeP2c,false)
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


	StartCountdown(5*60,UpgradeP2d,false)
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

	StartCountdown(6*60,UpgradeP2e,false)
end

function UpgradeP2e()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,2)

	ResearchTechnology(Technologies.T_SoftArcherArmor,2)
	ResearchTechnology(Technologies.T_LeatherMailArmor,2)

	StartCountdown(10*60,UpgradeP2f,false)
end

function UpgradeP2f()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)
	ResearchTechnology(Technologies.T_MasterOfSmithery,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(5*60,UpgradeP2g,false)
end

function UpgradeP2g()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)

	ResearchTechnology(Technologies.T_Fletching,2)
	ResearchTechnology(Technologies.T_WoodAging,2)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)

	StartCountdown(5*60,UpgradeP2h,false)
end


function UpgradeP2h()

	local researchplan = {
		{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(2*60,UpgradeP2i,false)
end

function UpgradeP2i()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
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
	CreateKerbArmy5()
end
function CreateKerbArmy5()

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

function CreateKerbArmyFive()

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

        CreateKerbArmyFive()

        return true

    else

       Advance(army5)

    end

end

function ControlArmyFive()

	if IsDead(armyFive) and IsExisting("TurmExtra") then

		CreateKerbArmy5()
		return true
	else

		Advance(armyFive)

	end

end

function CreateKerbArmy1()

	army1	 = {}

	army1.player 		= 7
	army1.id			= 1
	army1.strength		= 6
	army1.position		= GetPosition("Army1")
	army1.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army1)


	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
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

function CreateKerbArmyTwo()

	armyTwo	 = {}

	armyTwo.player 			= 7
	armyTwo.id				= 2
	armyTwo.strength		= 4
	armyTwo.position		= GetPosition("Army2")
	armyTwo.rodeLength		= Logic.WorldGetSize()

	SetupArmy(armyTwo)


	local troopDescription = {

		maxNumberOfSoldiers	= 8,
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

        CreateKerbArmyTwo()


        return true

    else


        Defend(army1)

    end

end


function ControlArmyTwo()


	if IsDead(armyTwo) and IsExisting("Turm1") then

		CreateKerbArmy1()
		return true
	else

		Defend(armyTwo)


	end

end
function CreateKerbArmy3()

	army3	 = {}

	army3.player 		= 7
	army3.id			= 3
	army3.strength		= 6
	army3.position		= GetPosition("Army3")
	army3.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army3)

	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType       	= Entities.CU_Barbarian_LeaderClub2
	}

	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)
	EnlargeArmy(army3,troopDescription)


	StartSimpleJob("ControlArmy3")

end

function CreateKerbArmy4()

	army4	 = {}

	army4.player 		= 7
	army4.id			= 4
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

        CreateKerbArmy4()


        return true

    else

        Defend(army3)

    end

end

function ControlArmy4()

	if IsDead(army4) and IsExisting("Turm2") then

		CreateKerbArmy3()
		return true
	else

		Defend(army4)

	end

end

function Mission_InitGroups()
	Start()
end
function Mission_InitTechnologies()
	for i = 1,5 do
		ForbidTechnology (Technologies.B_PowerPlant, i)
		ForbidTechnology (Technologies.B_Weathermachine, i)
	end
end

function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
	StartCountdown(15,KerbVoice,false)
end
function InitDiplomacy()
	for id in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.PV_Cannon3)) do
		Logic.GroupStand(id)
	end
	SetFriendly(1,3)
	SetFriendly(2,3)
  	SetPlayerName(8,"Kerberos Truppen")
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
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Container"),0,0,1400,1000)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Text"),100,669,850,48)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"),0,1000,1200,128)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,600,100)
	for i = 6,MAXPLAYERS do
	   Display.SetPlayerColorMapping(i,KERBEROS_COLOR)
	end

	if XNetwork.Manager_DoesExist() == 0 then
		Display.SetPlayerColorMapping(1,ENEMY_COLOR1)
		Display.SetPlayerColorMapping(2,FRIENDLY_COLOR2)

	end
end
function KerbVorbereitung()
	Message("Die Friedenszeit ist vorbei! ")
	Message("Bereitet Euch auf baldige Angriffe vor!")
	--
	StartWinter(60*60*60)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChanger", 1, {}, {})
	--
	CreateKerbArmy1()
	CreateKerbArmy3()
	--
	StartSimpleJob("WolfRespawn")
	StartCountdown(60/gvTechLVL*60,SpawnVorb,false)
	StartCountdown(30/gvTechLVL*60,UpgradeKI,false)
end
function WeatherChanger()
	local newWeather = Event.GetNewWeatherState()
	if newWeather ~= 3 then
		StartWinter(60*60*60)
	end
end
function UpgradeKI()
	for i = 6,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
	end
	StartCountdown(30/gvTechLVL*60,UpgradeKIb,false)
end

function UpgradeKIb()

	for i = 6,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,2)
		ResearchTechnology(Technologies.T_LeatherMailArmor,2)
	end
	StartCountdown(30/gvTechLVL*60,UpgradeKIc,false)
end

function UpgradeKIc()

	for i = 6,8 do
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
	end
	StartCountdown(30/gvTechLVL*60,UpgradeKId,false)
end

function UpgradeKId()

	for i = 6,8 do
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
	end
	StartCountdown(30/gvTechLVL*60,UpgradeKIe,false)
end

function UpgradeKIe()

	for i = 6,8 do
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
	end
end

function WolfRespawn()
	if IsExisting("Castle") and IsDestroyed("Wolf1") and IsDestroyed("Wolf2") and IsDestroyed("Wolf3") and IsDestroyed("Wolf4") and IsDestroyed("Wolf5") and IsDestroyed("Wolf6") then
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf1")
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf2")
		CreateEntity(8,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf3")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf4")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf5")
		CreateEntity(7,Entities.CU_AggressiveWolf,GetPosition("Wolves"),"Wolf6")
		return true
	end
end

function SpawnVorb()
	StartSimpleJob("EliteSpawns")
end
function EliteSpawns()
	for i = 6,8 do
		if IsExisting("P"..i.."HQ") then
			if Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.CU_VeteranMajor) <= (gvTechLVL * 2) then
				local id = CreateEntity(i,Entities.CU_VeteranMajor,GetPosition("P"..i.."Elite"))
				if id then
					ConnectLeaderWithArmy(id, nil, "offensiveArmies")
				end
			end
		end
	end
	StartCountdown(30/gvTechLVL*60,SpawnVorb,false)
	return true
end
function AngriffsErinnerung()
	Message("Der Winter steht kurz bevor!")
	Message("Kerberos Horden werden schon bald angreifen!")
	Sound.PlayGUISound(Sounds.VoicesMentor_VC_OnlySomeMinutesLeft_rnd_01,120)
	MapEditor_SetupAI(8,2,99000,gvTechLVL,"P8E",3,0)
	SetupPlayerAi( 8, {constructing = true, repairing = true, extracting = 1, serfLimit = 19} )
	ConnectLeaderWithArmy(GetID("Kerberos"), nil, "defensiveArmies")
	ConnectLeaderWithArmy(GetID("Mary"), nil, "offensiveArmies")
	MapEditor_SetupAI(7,2,99000,gvTechLVL,"P7HQ",3,0)
	SetupPlayerAi( 7, {constructing = true, repairing = true, extracting = 1, serfLimit = 17} )
	ConnectLeaderWithArmy(GetID("Varg"), nil, "offensiveArmies")
	MapEditor_SetupAI(6,2,99000,gvTechLVL,"P3",3,0)
	SetupPlayerAi( 6, {constructing = true, repairing = true, extracting = 1, serfLimit = 19} )
	if CNetwork then
		AdjustToMoreMaxPlayers()
	end
end
function AdjustToMoreMaxPlayers()
	ChangePlayer("StableP9",9)
	ChangePlayer("BarracksP9",9)
	ChangePlayer("FoundryP9",9)
	ChangePlayer("ArcheryP9",9)
	ChangePlayer("P9Stein1",9)
	ChangePlayer("P9Stein2",9)
	ChangePlayer("P9Eisen1",9)
	ChangePlayer("P9Eisen2",9)
	ChangePlayer("P9VC",9)
	ChangePlayer("P9Haus1",9)
	ChangePlayer("P9Haus2",9)
	ChangePlayer("P9Haus3",9)
	ChangePlayer("P9Haus4",9)
	ChangePlayer("P9Farm1",9)
	ChangePlayer("P9Farm2",9)
	ChangePlayer("P9Farm3",9)
	ChangePlayer("P9Farm4",9)
	MapEditor_SetupAI(9,3,99999,3,"P9",3,0)
	SetupPlayerAi( 9, {constructing = false, repairing = true, serfLimit = 9} )
	--
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfAnyCategoryFilter(EntityCategories.Headquarters, EntityCategories.MilitaryBuilding), CEntityIterator.InCircleFilter(58000,12000,10000)) do
		ChangePlayer(eID, 10)
	end
	MapEditor_SetupAI(10,3,99999,3,"P10",3,0)
	SetupPlayerAi( 10, {constructing = false, repairing = true, serfLimit = 9} )
	for eID in CEntityIterator.Iterator(CEntityIterator.IsSettlerFilter(), CEntityIterator.OfTypeFilter(Entities.CU_VeteranMajor), CEntityIterator.InCircleFilter(58000,12000,10000)) do
		if Logic.IsLeader(eID) == 1 then
			local newID = ChangePlayer(eID, 10)
			ConnectLeaderWithArmy(newID, nil, "defensiveArmies")
		end
	end
	--
	ChangePlayer("P8Kaserne", 11)
	ChangePlayer("P8Stable", 11)
	ChangePlayer("P8Bow", 11)
	MapEditor_SetupAI(11,3,99999,3,"P8Stable",3,0)
	SetupPlayerAi( 11, {constructing = false, repairing = true, serfLimit = 9} )
	--
	SetHumanPlayerDiplomacyToAllAIs()
end
function KerbVoice()
	StartCountdown(45,Sound1,false)
	StartCountdown(5*60,Sound2,false)
	StartCountdown(10*60,Sound3,false)
	StartCountdown(15*60,Sound4,false)
	StartCountdown(20*60,Sound5,false)
	StartCountdown(25*60,Sound6,false)
	StartCountdown(30*60,Sound7,false)
	StartCountdown(35*60,Sound8,false)
end
function Sound1() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_01,120) end
function Sound2() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_01,120) end
function Sound3() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_01,120) end
function Sound4() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_02,120) end
function Sound5() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_02,120) end
function Sound6() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_03,120) end
function Sound7() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_FunnyComment_rnd_01,120) end
function Sound8() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_05,120) StartCountdown(4*60,KerbVoice,false) end
function UpgradeBuilding(_EntityName) local EntityID = GetEntityId(_EntityName) if IsValid(EntityID) then local EntityType = Logic.GetEntityType(EntityID) local PlayerID = GetPlayer(EntityID) local Costs = {} Logic.FillBuildingUpgradeCostsTable(EntityType, Costs) for Resource, Amount in Costs do Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)  end GUI.UpgradeSingleBuilding(EntityID)  end end