NVAngriffe = 0 NVTimeline = 0
gvMapText = ""..
		"@color:0,0,0,0 ................ @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Kalas Giftnebel "
gvMapVersion = " v3.6 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,1,3)

	SetFriendly(1,2) SetFriendly(1,3) SetFriendly(1,4) SetFriendly(2,3) SetFriendly(2,4) SetFriendly(3,4) SetHostile(1,8) SetHostile(2,8) SetHostile(3,8) SetHostile(4,8)
	SetHostile(7,1) SetHostile(7,2) SetHostile(7,3) SetHostile(7,4)	 SetHostile(6,1) SetHostile(6,2) SetHostile(6,3) SetHostile(6,4)
	Logic.SuspendAllEntities()

  	Mission_InitGroups()
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	StartSimpleJob("VictoryJob")
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(10,TributeForMainquest,false)
	StartCountdown(12,DifficultyVorbereitung,false)
	Erinnerung = StartCountdown(45,Denkanstoss,false)
	Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,32039,24948,200) Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,31647,25039,200) Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,31685,25578,200) Logic.CreateEffect(GGL_Effects.FXMaryPoison,32039,24948,200) Logic.CreateEffect(GGL_Effects.FXMaryPoison,31647,25039,200) Logic.CreateEffect(GGL_Effects.FXMaryPoison,31685,25578,200) Logic.CreateEffect(GGL_Effects.FXKalaPoison,32039,24948,200) Logic.CreateEffect(GGL_Effects.FXKalaPoison,31647,25039,200) Logic.CreateEffect(GGL_Effects.FXKalaPoison,31685,25578,200)
	if XNetwork.Manager_DoesExist() == 0 then
	Display.SetPlayerColorMapping(2,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(1,FRIENDLY_COLOR3)
	Display.SetPlayerColorMapping(3,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(4,NEPHILIM_COLOR)
	SetPlayerName(1,"Korothon")
	SetPlayerName(2,"Thantyr")
	SetPlayerName(3,"Wheyford")
	SetPlayerName(4,"Zhankorox")
    ExtraHeld()
    SetupKi2S()
    SetupKi3S()
    SetupKi4()
	for i=1,4,1 do MultiplayerTools.DeleteFastGameStuff(i) end
	local PlayerID = GUI.GetPlayerID()
	Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
	Logic.PlayerSetGameStateToPlaying( PlayerID ) end
	StartSimpleJob("SJ_Defeat")
	if IsExisting("P4HQ") then
		StartSimpleJob("SJ_DefeatP4")
	else
		DestroyEntity("P8HQ")
		Logic.SetEntityName(Logic.GetEntityIDByName("P8Neu"), "P8HQ")
	end
	StartCountdown(150*60,MoorFelsen,false)
	StartCountdown(120*60,Pause,false)
	InitDiplomacy()
	InitPlayerColorMapping()
	CreateNVArmy1()
	CreateNVArmyz()
	CreateInitialNV()
	MakeInvulnerable("AlchHut")
	MakeInvulnerable("Alchemist")
	CreateWoodPile("Holz1",300000)
	CreateWoodPile("Holz2",300000)
	CreateWoodPile("Holz3",300000)
    CreateWoodPile("Holz4",300000)
	LocalMusic.UseSet = DARKMOORMUSIC
	NVAngriffe = 0
	ExtraNV = StartSimpleJob("ExtraAngriffe")
	StartSimpleJob("SpezialSpawn")
	for i = 1, 4 do Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i)); end;
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
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
end
function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1) GUI.PayTribute(8,TributMainquestP2) GUI.PayTribute(8,TributMainquestP3) GUI.PayTribute(8,TributMainquestP4)
end
function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Schwierigkeitsgrad über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Schwierigkeitsgrad über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer3()
	Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Schwierigkeitsgrad über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer4()
	Logic.AddQuest(4,4,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Schwierigkeitsgrad über das Tributmenü bestimmen!",1)
end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Schwierigkeitsgrad für dein Team!")
	Schwierigkeitsgradbestimmer()
	Sound.PlaySound(Sounds.Military_SO_Skirmisher_rnd_1)
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Schwierigkeitsgrad für dein Team, damit das Spiel endlich starten kann!")
end
function Schwierigkeitsgradbestimmer()
	Tribut5()
	Tribut6()
	Tribut7()
	Tribut8()
	Tribut9()
	Tribut10()
end
function Tribut5()
	local TrLeicht =  {}
	TrLeicht.playerId = 1
	TrLeicht.text = "Schwierigkeitsgrad @color:0,250,200 <<LEICHT>>! "
	TrLeicht.cost = { Gold = 0 }
	TrLeicht.Callback = SpielmodLeicht TLeicht =
	AddTribute(TrLeicht)
end
function Tribut6()
	local TrNormal =  {}
	TrNormal.playerId = 1
	TrNormal.text = "Schwierigkeitsgrad @color:50,250,50 <<NORMAL>>! "
	TrNormal.cost = { Gold = 0 }
	TrNormal.Callback = SpielmodNormal
	TNormal = AddTribute(TrNormal)
end
function Tribut7()
	local TrSchwer =  {}
	TrSchwer.playerId = 1
	TrSchwer.text = "Schwierigkeitsgrad @color:150,120,0 <<SCHWER>>! "
	TrSchwer.cost = { Gold = 0 }
	TrSchwer.Callback = SpielmodSchwer
	TSchwer = AddTribute(TrSchwer)
end
function Tribut8()
	local Tr_S_Schwer =  {}
	Tr_S_Schwer.playerId = 1
	Tr_S_Schwer.text = "Schwierigkeitsgrad @color:200,100,0 <<SEHR SCHWER>>! "
	Tr_S_Schwer.cost = { Gold = 0 }
	Tr_S_Schwer.Callback = SpielmodSehrSchwer
	TSehrSchwer = AddTribute(Tr_S_Schwer)
end
function Tribut9()
	local Tr_E_Schwer =  {}
	Tr_E_Schwer.playerId = 1
	Tr_E_Schwer.text = "Schwierigkeitsgrad @color:235,50,0 <<IRRSINNIG>>! "
	Tr_E_Schwer.cost = { Gold = 0 }
	Tr_E_Schwer.Callback = SpielmodExtremSchwer
	TExtremSchwer = AddTribute(Tr_E_Schwer)
end
function Tribut10()
	local Tr_Wahn =  {}
	Tr_Wahn.playerId = 1
	Tr_Wahn.text = "Schwierigkeitsgrad @color:250,0,0 <<WAHNSINNIG>>! "
	Tr_Wahn.cost = { Gold = 0 }
	Tr_Wahn.Callback = SpielmodWahn
	TWahn = AddTribute(Tr_Wahn)
end
function SpielmodLeicht()
	Message("Ihr habt den leichten Spielmodus @color:0,250,200 <<LEICHT>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(40*60,NVVorbereitung,true)
	StartCountdown(37*60,AngriffsErinnerung,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,500)
	Logic.RemoveTribute(1,TNormal)
	Logic.RemoveTribute(1,TSchwer)
	Logic.RemoveTribute(1,TSehrSchwer)
	Logic.RemoveTribute(1,TExtremSchwer)
	Logic.RemoveTribute(1,TWahn)
	Logic.ResumeAllEntities()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
		ForbidTechnology(Technologies.MU_Thief, i)
	end
	StopCountdown(Erinnerung)
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	StartCountdown(120*60,Hilfestellung,false)
	TroopTrader()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 2000
	local InitClayRaw 		= 2500
	local InitWoodRaw 		= 2500
	local InitStoneRaw 		= 2000
	local InitIronRaw 		= 1000
	local InitSulfurRaw		= 1000
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodNormal()
	Message("Ihr habt den normalen Spielmodus @color:50,250,50 <<NORMAL>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(25*60,NVVorbereitung,true)
	StartCountdown(22*60,AngriffsErinnerung,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_MP_TauntVeryGood,500)
	Logic.RemoveTribute(1,TLeicht)
	Logic.RemoveTribute(1,TSchwer)
	Logic.RemoveTribute(1,TSehrSchwer)
	Logic.RemoveTribute(1,TExtremSchwer)
	Logic.RemoveTribute(1,TWahn)
	Logic.ResumeAllEntities()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ForbidTechnology(Technologies.MU_Thief, i)
	end
	StopCountdown(Erinnerung)
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	StartCountdown(150*60,Hilfestellung,false)
	TroopTrader()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 1000
	local InitClayRaw 		= 1500
	local InitWoodRaw 		= 1500
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 500
	local InitSulfurRaw		= 500
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodSchwer()
	Message("Ihr habt den schweren Spielmodus @color:150,120,0 <<SCHWER>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(15*60,NVVorbereitung,true)
	StartCountdown(12*60,AngriffsErinnerung,false)
	StartCountdown(50*60,NVUpgrade1,false)
	StartCountdown(120*60,NVUpgrade2,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_02,500)
	Logic.RemoveTribute(1,TLeicht)
	Logic.RemoveTribute(1,TNormal)
	Logic.RemoveTribute(1,TSehrSchwer)
	Logic.RemoveTribute(1,TExtremSchwer)
	Logic.RemoveTribute(1,TWahn)
	Logic.ResumeAllEntities()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	for i = 1,4 do
		ForbidTechnology(Technologies.MU_Thief, i)
	end
	StopCountdown(Erinnerung)
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	TroopTrader()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 700
	local InitClayRaw 		= 800
	local InitWoodRaw 		= 900
	local InitStoneRaw 		= 700
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodSehrSchwer()
	Message("Ihr habt den sehr schweren Spielmodus @color:200,100,0 <<SEHR SCHWER>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(5*60,NVVorbereitung,true)
	SehrHart = StartCountdown(30*60,SchweresNV,false)
	StartCountdown(2*60,AngriffsErinnerung,false)
	StartCountdown(30*60,NVUpgrade1,false)
	StartCountdown(65*60,NVUpgrade2,false)
	StartCountdown(110*60,NVUpgrade3,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_03,500)
	Logic.RemoveTribute(1,TLeicht)
	Logic.RemoveTribute(1,TNormal)
	Logic.RemoveTribute(1,TSchwer)
	Logic.RemoveTribute(1,TExtremSchwer)
	Logic.RemoveTribute(1,TWahn)
	Logic.ResumeAllEntities()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	for i = 1,4 do
		ForbidTechnology(Technologies.MU_Thief, i)
	end
	StopCountdown(Erinnerung)
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	TroopTrader()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 450
	local InitClayRaw 		= 600
	local InitWoodRaw 		= 700
	local InitStoneRaw 		= 500
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,30,30 SEHR SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodExtremSchwer()
	Message("Ihr habt den extrem schweren Spielmodus @color:235,50,0 <<IRRSINNIG>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(1*60,NVVorbereitung,true)
	SehrHart = StartCountdown(15*60,SchweresNV,false)
	ExtremHart = StartCountdown(20*60,ExtremesNV,false)
	StartCountdown(10*60,NVUpgrade1,false)
	StartCountdown(25*60,NVUpgrade2,false)
	StartCountdown(45*60,NVUpgrade3,false)
	StartCountdown(115*60,NVUpgrade4,false)
	InitTimeLineArmy()
	NVTimelineJob = StartSimpleJob("Timeline")
	StartCountdown(20,AngriffsErinnerung,false)
	CreateExtremArmy()
	StartCountdown(25*60,IrrsinnigBonus,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_04,500)
	Logic.RemoveTribute(1,TLeicht)
	Logic.RemoveTribute(1,TNormal)
	Logic.RemoveTribute(1,TSchwer)
	Logic.RemoveTribute(1,TSehrSchwer)
	Logic.RemoveTribute(1,TWahn)
	Logic.ResumeAllEntities()
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	for i = 1,4 do
		ForbidTechnology(Technologies.B_Tower, i)
		ForbidTechnology(Technologies.UP1_Tower, i)
		ForbidTechnology(Technologies.B_Foundry, i)
		ForbidTechnology(Technologies.UP1_Foundry, i)
		ForbidTechnology(Technologies.T_UpgradeRifle1, i)
		ForbidTechnology(Technologies.T_MakeSnow, i	)
		ForbidTechnology(Technologies.T_MakeSummer, i	)
		ForbidTechnology(Technologies.T_MarketSulfur, i	)
		ForbidTechnology(Technologies.MU_Thief, i)
	end
	StopCountdown(Erinnerung)
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24410,66890,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	StartCountdown(30,IrrEffect,false)
	TroopTrader()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 250
	local InitClayRaw 		= 400
	local InitWoodRaw 		= 500
	local InitStoneRaw 		= 200
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:250,20,20 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodWahn()
	Message("Ihr habt den quasi unschaffbar schweren Spielmodus @color:235,50,0 <<WAHNSINNIG>> @color:255,255,255 gewählt")
	NVTicker = StartCountdown(30,NVVorbereitung,true)
	SehrHart = StartCountdown(5*60,SchweresNV,false)
	ExtremHart = StartCountdown(8*60,ExtremesNV,false)
	StartCountdown(1*60,NVUpgrade1,false)
	StartCountdown(6*60,NVUpgrade2,false)
	StartCountdown(12*60,NVUpgrade3,false)
	StartCountdown(22*60,NVUpgrade4,false)
	InitTimeLineArmy()
	NVTimelineJob = StartSimpleJob("Timeline")
	StartCountdown(10,AngriffsErinnerung,false)
	CreateExtremArmy()
	StartCountdown(15*60,IrrsinnigBonus,false)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_04,500)
	Logic.RemoveTribute(1,TLeicht)
	Logic.RemoveTribute(1,TNormal)
	Logic.RemoveTribute(1,TSchwer)
	Logic.RemoveTribute(1,TSehrSchwer)
	Logic.RemoveTribute(1,TExtremSchwer)
	Logic.ResumeAllEntities()

	StopCountdown(Erinnerung)
	for i = 1,4 do
		ForbidTechnology(Technologies.B_Tower, i)
		ForbidTechnology(Technologies.UP1_Tower, i)
		ForbidTechnology(Technologies.B_Foundry, i)
		ForbidTechnology(Technologies.UP1_Foundry, i)
		ForbidTechnology(Technologies.MU_LeaderRifle, i)
		ForbidTechnology(Technologies.T_UpgradeRifle1, i)
		ForbidTechnology(Technologies.T_Sights, i)
		ForbidTechnology(Technologies.T_UpgradeBow3	, i)
		ForbidTechnology(Technologies.B_Castle, i)
		ForbidTechnology(Technologies.T_MakeSnow, i	)
		ForbidTechnology(Technologies.T_MakeSummer, i	)
		ForbidTechnology(Technologies.T_MarketGold, i		)
		ForbidTechnology(Technologies.T_MarketIron, i	)
		ForbidTechnology(Technologies.T_MarketSulfur, i	)
		ForbidTechnology(Technologies.T_MarketWood, i	)
		ForbidTechnology(Technologies.UP1_GunsmithWorkshop, i)
		ForbidTechnology(Technologies.T_ThiefSabotage, i	)
	end
	DestroyEntity("Wegsperre1")
	DestroyEntity("Wegsperre2")
	DestroyEntity("Wegsperre3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60000,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,60250,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,38500,59500,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24410,66890,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,33780,28359,200)
	StartCountdown(30,IrrEffect,false)
	TroopTrader()

	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 150
	local InitClayRaw 		= 300
	local InitWoodRaw 		= 400
	local InitStoneRaw 		= 100
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	local i
	for i=1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 WAHNSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function NVUpgrade1()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_EvilArmor1,i)
		ResearchTechnology(Technologies.T_EvilSpears1,i)
	end
end
function NVUpgrade2()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_EvilArmor2,i)
		ResearchTechnology(Technologies.T_EvilSpears2,i)
		ResearchTechnology(Technologies.T_EvilRange1,i)
	end
end
function NVUpgrade3()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_EvilArmor3,i)
		ResearchTechnology(Technologies.T_EvilRange2,i)
		ResearchTechnology(Technologies.T_EvilSpeed,i)
	end
end
function NVUpgrade4()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_EvilArmor4,i)
		ResearchTechnology(Technologies.T_EvilFists,i)
	end
end
function IrrEffect()
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24410,66890,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,24400,66900,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,32039,24948,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,32039,24948,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,32039,24948,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,32039,24948,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,32039,24948,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,32039,24948,200)
	StartCountdown(30,IrrEffect,false)
end
function ExtraHeld()
	CreateEntity(1,Entities.PU_Hero2,GetPosition("Hero"),"Pilgrim")
	CreateEntity(2,Entities.PU_Hero4,GetPosition("H2"))
	CreateEntity(3,Entities.PU_Hero5,GetPosition("H3"))
	CreateEntity(4,Entities.PU_Hero10,GetPosition("H4"))
	Truhen()
end
function TroopTrader()
	local mercenaryId = Logic.GetEntityIDByName("camp1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderRifle2, 2, ResourceType.Sulfur, 1800)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword4, 8, ResourceType.Iron, 800)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderPoleArm4, 8, ResourceType.Wood, 800)
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow4, 8, ResourceType.Gold, 800)
	local mercenaryId2 = Logic.GetEntityIDByName("camp2")
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderRifle2, 3, ResourceType.Gold, 2000)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon3, 2, ResourceType.Sulfur, 2000)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon4, 2, ResourceType.Iron, 2750)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PV_Cannon5, 1, ResourceType.Knowledge, 3000)
end
function VictoryJob()
	if IsDead("NVHQ") then
		Victory()
		return true
	end
end
function SJ_Defeat()
	if IsDead("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.PlayerSetGameStateToLost(3)
		Logic.PlayerSetGameStateToLost(4)
  		return true
	end
end
function SJ_DefeatP4()
	if IsDead("P4HQ") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.PlayerSetGameStateToLost(3)
		Logic.PlayerSetGameStateToLost(4)
  		return true
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Willkommen in dieser Moorregion."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Leider gibt es keine Zeit, um sich hier zu entspannen. Kala wird immer stärker und ist kaum noch aufzuhalten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Sie und ihre Truppen verbreiten überall wo sie vorbeikommen, großes Elend! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Viel Erfolg beim Besiegen von Kala und ihren Truppen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Es gibt viele Möglichkeiten, das immer stärker werdende Nebelvolk zu schwächen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }
    StartBriefing(briefing)
end
function SetupKi2S()
    MapEditor_SetupAI(2,1,999999,1,"Player2",3,0)
	SetupPlayerAi(2, {
	serfLimit = 22,
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
        wood		= 30,
        updateTime	= 300}}
	)
	local constructionplanP2 = {
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2Lehm1"), level = 1 },			-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P2Eisen1"), level = 1 },			-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2Lehm2"), level = 2 },			-- Lehmmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2Holz2"), level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P2Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P2Clay"), level = 1 },			-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P2Iron"), level = 2 },			-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Bank
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },					-- Schiessanlage
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 0 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P2Dorf"), level = 2 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },
		{ type = Entities.PB_Tower1, pos = GetPosition("P2Tower1"), level = 2 },			-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P2Tower2"), level = 2 },			-- Turm
	}
	FeedAiWithConstructionPlanFile(2,constructionplanP2)
	StartCountdown(8*60,UpgradeP2a,false)
	SetFriendly(2,1)
	SetFriendly(2,3)
	SetFriendly(2,4)
end
function UpgradeP2a()
	AI.Village_SetSerfLimit(2,16)
	if IsExisting("P2HQ") then
		UpgradeBuilding("P2HQ")
	end
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
	if IsExisting("P2HQ") then
		UpgradeBuilding("P2HQ")
	end
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
	ResearchTechnology(Technologies.T_MasterOfSmithery,2)
end
function SetupKi3S()
    MapEditor_SetupAI(3,1,999999,1,"Player3",3,0)
	SetupPlayerAi(3, {
	serfLimit = 22,
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
        wood		= 30,
        updateTime	= 300}}
	)
	local constructionplanP3 = {
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3Lehm1"), level = 1 },			-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P3Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P3Eisen1"), level = 1 },			-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3Lehm2"), level = 2 },			-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P3Holz3"), level = 1 },			-- Sägemühle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P3Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P3Clay"), level = 1 },			-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P3Iron"), level = 2 },			-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Bank
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },					-- Schiessanlage
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 0 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P3Dorf"), level = 1 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3Tower1"), level = 2 },			-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3Tower2"), level = 2 },
    }
	FeedAiWithConstructionPlanFile(3,constructionplanP3)
	StartCountdown(8*60,UpgradeP3a,false)
	SetFriendly(3,1)
	SetFriendly(3,2)
	SetFriendly(3,4)
end
function UpgradeP3a()
	AI.Village_SetSerfLimit(3,16)
	if IsExisting("P3HQ") then
		UpgradeBuilding("P3HQ")
	end
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
	if IsExisting("P3HQ") then
		UpgradeBuilding("P3HQ")
	end
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
	ResearchTechnology(Technologies.T_MasterOfSmithery,3)
end
function SetupKi4()
    MapEditor_SetupAI(4,1,999999,1,"Player4",3,0)
	SetupPlayerAi(4, {
	serfLimit = 22,
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
        wood		= 30,
        updateTime	= 300}}
	)
	local constructionplanP4 = {
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P4Lehm2"), level = 1 },			-- Lehmmine
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P4Stein1"), level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P4Eisen1"), level = 1 },			-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P4Holz3"), level = 1 },			-- Sägemühle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_StoneMine1, pos = GetPosition("P4Stein2"), level = 2 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P4Clay"), level = 1 },			-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P4Iron"), level = 2 },			-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Bank
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },					-- Schiessanlage
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 0 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P4Dorf"), level = 1 },		-- Dorfzentrum
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4Tower1"), level = 2 },			-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4Tower2"), level = 2 },
     }
	FeedAiWithConstructionPlanFile(4,constructionplanP4)
	StartCountdown(8*60,UpgradeP4a,false)
	SetFriendly(4,1)
	SetFriendly(4,2)
	SetFriendly(4,3)
end
function UpgradeP4a()
	AI.Village_SetSerfLimit(4,16)
	if IsExisting("P4HQ") then
		UpgradeBuilding("P4HQ")
	end
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
	if IsExisting("P4HQ") then
		UpgradeBuilding("P4HQ")
	end
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
	ResearchTechnology(Technologies.T_MasterOfSmithery,4)
end
function Mission_InitWeatherGfxSets()
end
function InitWeather()
    Display.GfxSetSetSkyBox(1, 0.0, 1.0, "YSkyBox07")
    Display.GfxSetSetRainEffectStatus(1, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(1, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(1, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152,172,182, 5000,22000)
	Display.GfxSetSetLightParams(1,  0.0, 1.0, 40, -15, -50,  120,130,110,  205,204,180)
    Display.GfxSetSetSkyBox(9, 0.0, 1.0, "YSkyBox07")
    Display.GfxSetSetRainEffectStatus(9, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(9, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(9, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(9, 0.0, 1.0, 1, 72,102,112, 4500,12000)
	Display.GfxSetSetLightParams(9,  0.0, 1.0, 40, -15, -50,  80,90,80,  75,74,50)
	AddPeriodicNacht = function(dauer)
		Logic.AddWeatherElement(1, dauer, 1, 9, 5, 15)
	end
    Display.GfxSetSetSkyBox(2, 0.0, 1.0, "YSkyBox04")
    Display.GfxSetSetRainEffectStatus(2, 0.0, 1.0, 1)
    Display.GfxSetSetSnowStatus(2, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(2, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(2, 0.0, 1.0, 1, 72,102,112, 5000,12000)
	Display.GfxSetSetLightParams(2,  0.0, 1.0, 40, -15, -50,  70,80,70,  205,204,180)
    Display.GfxSetSetSkyBox(3, 0.0, 1.0, "YSkyBox01")
    Display.GfxSetSetRainEffectStatus(3, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(3, 0, 1.0, 1)
    Display.GfxSetSetSnowEffectStatus(3, 0.0, 0.8, 1)
    Display.GfxSetSetFogParams(3, 0.0, 1.0, 1, 108,128,138, 4500,11000)
    Display.GfxSetSetLightParams(3,  0.0, 1.0, 40, -15, -50,  116,164,164, 255,234,202)
    Display.GfxSetSetSkyBox(4, 0.0, 1.0, "YSkyBox01")
    Display.GfxSetSetRainEffectStatus(4, 0.0, 1.0, 1)
    Display.GfxSetSetSnowStatus(4, 0, 1.0, 1)
    Display.GfxSetSetSnowEffectStatus(4, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(4, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(4,  0.0, 1.0,  40, -15, -75,  106,154,154, 255,234,202)
	AddPeriodicTauwetter = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 4, 5, 15)
	end
    Display.GfxSetSetSkyBox(5, 0.0, 1.0, "YSkyBox04")
    Display.GfxSetSetRainEffectStatus(5, 0.0, 1.0, 1)
    Display.GfxSetSetSnowStatus(5, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(5, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(5, 0.0, 1.0, 1, 102,132,142, 5000,10500)
	Display.GfxSetSetLightParams(5,  0.0, 1.0, 40, -15, -50,  90,100,80,  205,204,180)
	AddPeriodicSchneeregen = function(dauer)
		Logic.AddWeatherElement(2, dauer, 1, 5, 5, 15)
	end
    Display.GfxSetSetSkyBox(6, 0.0, 1.0, "YSkyBox01")
    Display.GfxSetSetRainEffectStatus(6, 0.0, 1.0, 1)
    Display.GfxSetSetSnowStatus(6, 0, 1.0, 1)
    Display.GfxSetSetSnowEffectStatus(6, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(6, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(6,  0.0, 1.0,  40, -15, -75,  106,154,154, 255,234,202)
	AddPeriodicWinterregen = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 6, 5, 15)
	end
    Display.GfxSetSetSkyBox(7, 0.0, 1.0, "YSkyBox01")
    Display.GfxSetSetRainEffectStatus(7, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(7, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(7, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(7, 0.0, 1.0, 1, 152,172,182, 5000,22000)
	Display.GfxSetSetLightParams(7,  0.0, 1.0, 40, -15, -50,  120,130,110,  205,204,180)
	AddPeriodicSommerschnee = function(dauer)
		Logic.AddWeatherElement(1, dauer, 1, 7, 5, 15)
	end
	Display.GfxSetSetSkyBox(8, 0.0, 1.0, "YSkyBox01")
    Display.GfxSetSetRainEffectStatus(8, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(8, 0, 1.0, 1)
    Display.GfxSetSetSnowEffectStatus(8, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(8, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(8,  0.0, 1.0,  40, -15, -75,  116,164,164, 255,234,202)
	AddPeriodicSchnee = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 8, 5, 15)
	end
	AddPeriodicSummer(7*60)
	AddPeriodicNacht(60)
	AddPeriodicSchneeregen(75)
	AddPeriodicRain(120)
	AddPeriodicSummer(6*60)
	AddPeriodicSchnee(90)
	AddPeriodicTauwetter(50)
	AddPeriodicRain(120)
	AddPeriodicSummer(300)
	AddPeriodicRain(160)
	AddPeriodicNacht(90)
	AddPeriodicWinter(90)
	AddPeriodicRain(60)
	AddPeriodicWinter(200)
	AddPeriodicRain(120)
	AddPeriodicSchneeregen(145)
	AddPeriodicSchnee(60)
	AddPeriodicTauwetter(60)
	AddPeriodicRain(140)
	AddPeriodicSummer(980)
	AddPeriodicNacht(160)
	AddPeriodicRain(120)
	AddPeriodicWinter(90)
	AddPeriodicRain(100)
	Display.SetRenderUseGfxSets(1)
end
function Mission_InitGroups()
end
function Mission_InitLocalResources()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw 		= 0
	local InitClayRaw 		= 0
	local InitWoodRaw 		= 0
	local InitStoneRaw 		= 0
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	local i
	for i=1,8
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end
function InitDiplomacy()
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	SetHostile(1,8)
	SetHostile(2,8)
	SetHostile(3,8)
	SetHostile(4,8)
	SetHostile(7,1)
	SetHostile(7,2)
	SetHostile(7,3)
	SetHostile(7,4)
	SetHostile(6,1)
	SetHostile(6,2)
	SetHostile(6,3)
	SetHostile(6,4)
	SetPlayerName(6,"Nebelvolk")
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(2,3,true)
	ActivateShareExploration(4,1,true)
	ActivateShareExploration(4,2,true)
	ActivateShareExploration(4,3,true)
end
function InitPlayerColorMapping()
	Display.SetPlayerColorMapping(8,FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(7,FRIENDLY_COLOR2)
	Display.SetPlayerColorMapping(6,FRIENDLY_COLOR2)
end
function CreateExtremArmy()
	armyExt	 = {}
	armyExt.player 		= 6
	armyExt.id			= GetFirstFreeArmySlot(6)
	armyExt.strength	= 6
	armyExt.position	= GetPosition("NVBase")
	armyExt.rodeLength	= Logic.WorldGetSize()

	SetupArmy(armyExt)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1, armyExt.strength do
		EnlargeArmy(armyExt,troopDescription)
	end
	StartSimpleJob("ControlArmyExt")
end
function CreateNVArmyExt2()
	armyExt2	 = {}
	armyExt2.player 		= 6
	armyExt2.id				= GetFirstFreeArmySlot(6)
	armyExt2.strength		= 3
	armyExt2.position		= GetPosition("NVBase")
	armyExt2.rodeLength		= Logic.WorldGetSize()
	SetupArmy(armyExt2)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1, armyExt2.strength do
		EnlargeArmy(armyExt2,troopDescription)
	end
	StartSimpleJob("ControlArmyExt2")
end
function ControlArmyExt()
    if IsDead(armyExt) and IsExisting("NVHQ") then
        CreateNVArmyExt2()
        return true
    else
        Defend(armyExt)
    end
end
function ControlArmyExt2()
	if IsDead(armyExt2) and IsExisting("NVHQ") then
		CreateExtremArmy()
		return true
	else
		Defend(armyExt2)
	end
end
function CreateNVArmy1()
	army1	 = {}
	army1.player 		= 6
	army1.id			= GetFirstFreeArmySlot(6)
	army1.strength		= 12
	army1.position		= GetPosition("ZusatzSpawn")
	army1.rodeLength	= Logic.WorldGetSize()
	army1.enemySearchPosition = GetPosition("Player2")
	SetupArmy(army1)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1, army1.strength do
		EnlargeArmy(army1,troopDescription)
	end
	StartSimpleJob("ControlArmy1")
end
function CreateNVArmyTwo()
	armyTwo	 = {}
	armyTwo.player 		= 6
	armyTwo.id			= GetFirstFreeArmySlot(6)
	armyTwo.strength	= 4
	armyTwo.position	= GetPosition("ZusatzSpawn")
	armyTwo.rodeLength	= Logic.WorldGetSize()
	armyTwo.enemySearchPosition = GetPosition("Player2")
	SetupArmy(armyTwo)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1, armyTwo.strength do
		EnlargeArmy(armyTwo,troopDescription)
	end
	StartSimpleJob("ControlArmyTwo")
end
function ControlArmy1()
    if IsDead(army1) and IsExisting("ZusatzTurm") then
        CreateNVArmyTwo()
        return true
    else
        Defend(army1)
	end
end
function ControlArmyTwo()
	if IsDead(armyTwo) and IsExisting("ZusatzTurm") then
		CreateNVArmy1()
		return true
	else
		Defend(armyTwo)
	end
end
function CreateNVArmyz()
	armyz	 = {}
	armyz.player 		= 7
	armyz.id			= 3
	armyz.strength		= 6
	armyz.position		= GetPosition("NVBase")
	armyz.rodeLength	= Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		armyz.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(armyz)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1, armyz.strength do
		EnlargeArmy(armyz,troopDescription)
	end
	StartSimpleJob("ControlArmyz")
end
function CreateNVArmyz2()
	armyz2	 = {}
	armyz2.player 		= 7
	armyz2.id			= 4
	armyz2.strength		= 3
	armyz2.position		= GetPosition("NVBase")
	armyz2.rodeLength	= Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		armyz2.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(armyz2)
	local troopDescription = {
		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1, armyz2.strength do
		EnlargeArmy(armyz2,troopDescription)
	end
	StartSimpleJob("ControlArmyz2")
end
function ControlArmyz()
    if IsDead(armyz) and IsExisting("NVHQ") then
        CreateNVArmyz2()
        return true
    else
        Defend(armyz)
	end
end
function ControlArmyz2()
	if IsDead(armyz2) and IsExisting("NVHQ") then
		CreateNVArmyz()
		return true
	else
		Defend(armyz2)
	end
end
function NVVorbereitung()
	Message("Das Nebelvolk hat sich zum Angriff bereit gemacht!")
	Message("Es braucht zwar durchaus seine Zeit hierher, wird aber garantiert hier aufkreuzen!")
	Sound.PlayGUISound(Sounds.VoicesMentor_MP_PeaceTimeOver_rnd_01,300)
	StartCountdown(10,NVSpawn1,false)
	for i = 4,9 do
		DestroyEntity("Wegsperre"..i)
	end
	DestroyEntity("Cliff")
	Logic.CreateEffect(GGL_Effects.FXExplosion,46646,55204,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,46646,55204,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,46646,55204,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,46975,55054,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,46975,55054,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,46975,55054,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,47348,54833,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,47348,54833,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,47348,54833,200)
end
function Ansage()
	Message("Die Truppen des Nebelvolkes greifen an!!")
end
NVTypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSkirmisher1, Entities.CU_Evil_LeaderSpearman1}
function CreateInitialNV()
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy1"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy3"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy5"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy7"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy9"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy11"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy13"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy15"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy17"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy19"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy21"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NVEnemy23"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy2"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy4"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy6"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy8"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy10"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy12"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy14"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy16"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy18"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy20"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy22"))
	CreateMilitaryGroup(6,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NVEnemy24"))
end
function NVSpawn1()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSpawn1")
	army.strength = 4
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,3 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	NVRe1 = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmy1",1,{},{army.player, army.id})
	StopCountdown(NVTicker)
	StartCountdown(45,Ansage,false)
	StartCountdown(30*60,NVSpawn2,false)
	StartCountdown(90,KalaMad,false)
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_02,500)
end
function ControlNVArmy1(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsExisting("NVHQ") then
		NVRespawn1(army)
	end
	Defend(army)
end
function NVRespawn1(_army)
	for i = 1,3 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	NVAngriffe = NVAngriffe + 1
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_01,300)
end
function NVSpawn2()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSpawn2")
	army.strength = 9
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,6 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,3 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVRe2 = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmy2",1,{},{army.player, army.id})
	StartCountdown(30*60,NVSpawn3,false)
	StartCountdown(20*60,NVHinterhalt,false)
	StartCountdown(60*60,NVBosheit,false)
end
function ControlNVArmy2(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsExisting("NVHQ") then
		NVRespawn2(army)
	end
	Defend(army)
end
function NVRespawn2(_army)
	for i = 1,6 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,3 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVAngriffe = NVAngriffe + 1
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_01,300)
end
function NVSpawn3()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSpawn3")
	army.strength = 15
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,9 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,6 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVRe3 = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmy3",1,{},{army.player, army.id})
	StartCountdown(30*60,NVSpawn4,false)
end
function ControlNVArmy3(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsExisting("NVHQ") then
		NVRespawn3(army)
	end
	Defend(army)
end
function NVRespawn3(_army)
	for i = 1,9 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,6 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVAngriffe = NVAngriffe + 1
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_01,300)
end
function NVSpawn4()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSpawn3")
	army.strength = 15
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,9 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,6 do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVRe4 = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmy4",1,{},{army.player, army.id})
end
function ControlNVArmy4(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsExisting("NVHQ") then
		NVRespawn4(army)
	end
	Defend(army)
end
function NVRespawn4(_army)
	for i = 1,9 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	for i = 1,6 do
		EnlargeArmy(_army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end
	NVAngriffe = NVAngriffe + 1
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_01,300)
end
function ExtraAngriffe()
	if IsExisting("NVBase") then
		if NVAngriffe == 2 and not ExAng1Done then
			ExtraAngriff1()
			ExAng1Done = true
		end
	end
	if IsExisting("NVAussen") then
		if NVAngriffe == 4 and not ExAng3Done then
			ExtraAngriff3()
			ExAng3Done = true
		end
	end
	if IsExisting("NVBase") then
		if NVAngriffe == 5 then
			ExtraAngriff2()
			NVAngriffe = 0
			ExAng1Done = false
			ExAng3Done = false
		end
	end
end
function ExtraAngriff1()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVBase")
	army.strength = 4
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
end
function ExtraAngriff2()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVBase")
	army.strength = 6
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
end
function ExtraAngriff3()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSpezialSpawn")
	army.strength = 4
	army.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		army.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyEx3",1,{},{army.player, army.id})
end
function ControlNVArmyGeneric(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end
function ControlNVArmyEx3(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		ExAng3Dead = true
		return true
	else
		Defend(army)
	end
end
function SpezialSpawn()
	if IsExisting("NVAussen") and ExAng3Dead then
		ExAng3Dead = false
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("NVSpezialSpawn")
		army.strength = 8
		army.rodeLength = Logic.WorldGetSize()
		local rng = math.random(1,2)
		if rng == 2 then
			army.enemySearchPosition = GetPosition("Player2")
		end
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
		Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonarrows_rnd_01,300)
	end
end
function IrrsinnigBonus()
	DestroyEntity("IrrsinnigFels1")
	DestroyEntity("IrrsinnigFels2")
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("IrrsinnigP1Spawn")
	army.strength = 6
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("IrrsinnigP4Spawn")
	army.strength = 6
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	StartCountdown(20*60,IrrsinnigBonus2,false)
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_FunnyComment_rnd_01,200)
end
function IrrsinnigBonus2()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("IrrsinnigP1Spawn")
	army.strength = 9
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("IrrsinnigP4Spawn")
	army.strength = 9
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	StartCountdown((15+math.random(1,5))*60,IrrsinnigBonus2,false)
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_FunnyComment_rnd_01,200)
end
function NVHinterhalt()
	for i = 1,8 do
		DestroyEntity("NVFels"..i)
	end
	Logic.CreateEffect(GGL_Effects.FXExplosion,32558,66680,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32558,66680,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32558,66680,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32989,66770,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32989,66770,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32989,66770,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32526,67130,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32526,67130,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32526,67130,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32873,67114,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32873,67114,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32873,67114,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32490,67450,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32490,67450,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32490,67450,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32889,67577,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32889,67577,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32889,67577,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32513,67775,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32513,67775,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32513,67775,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,32900,68008,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,32900,68008,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,32900,68008,200)
	--
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVHinterhalt")
	army.strength = 7
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	StartCountdown((15+math.random(1,5))*60,NVHinterhalt2,false)
	Sound.PlayGUISound(Sounds.AOVoicesMentorHelp_UNIT_EvilQueen,200)
end
function NVHinterhalt2()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVHinterhalt")
	army.strength = 9
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	StartCountdown((15+math.random(1,8))*60,NVHinterhalt2,false)
	Sound.PlayGUISound(Sounds.AOVoicesMentorHelp_UNIT_EvilQueen,200)
end
function NVBosheit()
	NVGemein1 = StartSimpleJob("NVFies1")
	NVGemein2 = StartSimpleJob("NVFies2")
	NVGemein3 = StartSimpleJob("NVFies3")
	NVGemein4 = StartSimpleJob("NVFies4")
	Sound.PlayGUISound(Sounds.AOVoicesMentorHelp_UNIT_EvilQueen,500)
end
function NVFies1()
	if IsExisting("P1_FastGame10") and IsExisting("P1HQ") then
		Message("@color:250,0,0 Krah Te Lu Xraktarrh!!")
		Logic.CreateEffect(GGL_Effects.FXExplosion,21500,59100,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,21500,59100,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,21500,59100,200)
		Logic.CreateEffect(GGL_Effects.FXCrushBuilding,21500,59100,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21700,60000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21700,60000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21700,60000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,21200,58500,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,21200,58500,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,21200,58500,200)
		ReplaceEntity("P1_FastGame10",Entities.XD_RuinResidence1)
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P1_NV1")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P1_NV2")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	end
	return true
end
function NVFies2()
	if IsExisting("P2_FastGame10") and IsExisting("P2HQ") then
		Logic.CreateEffect(GGL_Effects.FXExplosion,1500,41800,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,1500,41800,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,1500,41800,200)
		Logic.CreateEffect(GGL_Effects.FXCrushBuilding,1500,41800,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,1700,42000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,1700,42000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,1700,42000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,1200,40500,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,1200,40500,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,1200,40500,200)
		ReplaceEntity("P2_FastGame10",Entities.XD_RuinResidence1)
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P2_NV1")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P2_NV2")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	end
	return true
end
function NVFies3()
	if IsExisting("P3_FastGame11") and IsExisting("P3HQ") then
		Logic.CreateEffect(GGL_Effects.FXExplosion,20800,23600,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,20800,23600,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,20800,23600,200)
		Logic.CreateEffect(GGL_Effects.FXCrushBuilding,20800,23600,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21500,24000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21500,24000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,21500,24000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,20000,23000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,20000,23000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,20000,23000,200)
		ReplaceEntity("P3_FastGame11",Entities.XD_RuinResidence1)
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P3_NV1")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P3_NV2")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	end
	return true
end
function NVFies4()
	if IsExisting("P4_FastGame11") and IsExisting("P4HQ") then
		Logic.CreateEffect(GGL_Effects.FXExplosion,31600,14000,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,31600,14000,200)
		Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,31600,14000,200)
		Logic.CreateEffect(GGL_Effects.FXCrushBuilding,31600,14000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,32200,15000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,32200,15000,200)
		Logic.CreateEffect(GGL_Effects.FXMaryPoison,32200,15000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,31000,13000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,31000,13000,200)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,31000,13000,200)
		ReplaceEntity("P4_FastGame11",Entities.XD_RuinResidence1)
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P4_NV1")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
		--
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("P4_NV2")
		army.strength = 3
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	end
	return true
end
function InitTimeLineArmy()
	TimelineArmy = {}
	TimelineArmy.player = 6
	TimelineArmy.id = GetFirstFreeArmySlot(6)
	TimelineArmy.position = GetPosition("NVTimelineSpawn")
	TimelineArmy.strength = 99
	TimelineArmy.rodeLength = Logic.WorldGetSize()
	local rng = math.random(1,2)
	if rng == 2 then
		TimelineArmy.enemySearchPosition = GetPosition("Player2")
	end
	SetupArmy(TimelineArmy)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyTimeline",1,{},{TimelineArmy.player, TimelineArmy.id})
end
function ControlNVArmyTimeline(_player, _id)
	local army = TimelineArmy
	if not IsDead(army) then
		Defend(army)
	end
end
function Timeline()
	local min = 60
	if IsExisting("ExtremTurm") then
		NVTimeline = NVTimeline + 1
	end
	if NVTimeline == 6*min then
		for i = 1,2 do
			EnlargeArmy(TimelineArmy, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
	elseif NVTimeline == 12*min then
		for i = 1,3 do
			EnlargeArmy(TimelineArmy, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
	elseif NVTimeline == 20*min then
		for i = 1,4 do
			EnlargeArmy(TimelineArmy, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
	elseif NVTimeline == 30*min then
		for i = 1,5 do
			EnlargeArmy(TimelineArmy, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
	elseif NVTimeline == 38*min then
		for i = 1,6 do
			EnlargeArmy(TimelineArmy, {leaderType = NVTypes[math.random(1, table.getn(NVTypes))]})
		end
		NVTimeline = 0
	end
end
function Hilfestellung()
	Message("Ihr könnt nun über das Tributmenü eine Hilfestellung anfordern, wenn es euch zu schwer wird!")
	Message("Dazu muss Spieler 1 den Tribut bezahlen! Damit es nicht zu einfach ist, kostet er euch 10.000 Taler!")
	Message("Tipp: im Diplomatie-Menü können euch verbündete Spieler Taler schicken!")
	TributHilfe()
end
function TributHilfe()
	local TrHilfe =  {}
	TrHilfe.playerId = 1
	TrHilfe.text = "Schaltet ein umfassendes Hilfepaket frei, wenn es euch zu schwierig wird! "
	TrHilfe.cost = { Gold = 10000 }
	TrHilfe.Callback = Hilfe
	THilfe = AddTribute(TrHilfe)
end
function Hilfe()
	Message("Ihr habt das umfassende Hilfspaket freigeschaltet")
	Message("Ihr habt ein riesiges Truppenaufgebot vor der Höhle im Norden erhalten")
	Message("Auch die Angriffswellen des Nebelvolks sollten deutlich abschwellen")
	Message("Ein Rohstoffpaket wird zudem eurer Wirtschaft ein wenig zur Seite stehen")
	Message("Zudem öffnet ein abgelegenes, aber kostengünstiges Söldnerquartier seine Pforten")
	Sound.PlayGUISound(Sounds.VoicesMentor_TRADE_DealClosed_rnd_01,500)
	StartSimpleJob("P1Hilfe")
	StartSimpleJob("P2Hilfe")
	StartSimpleJob("P3Hilfe")
	StartSimpleJob("P4Hilfe")
	ExtraMerchant()
	EndJob("NVRe2")
	EndJob("NVRe3")
	EndJob("NVRe4")
	EndJob("ExtraNV")
	EndJob("NVGemein1")
	EndJob("NVGemein2")
	EndJob("NVGemein3")
	EndJob("NVGemein4")
	DestroyEntity("HilfsRock1")
	DestroyEntity("HilfsRock2")
	DestroyEntity("HilfsRock3")
	Logic.CreateEffect(GGL_Effects.FXExplosion,50421,18504,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,50421,18504,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,50421,18504,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,50306,18872,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,50306,18872,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,50306,18872,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,50015,19105,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,50015,19105,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,50015,19105,200)
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,300)
end
function P1Hilfe()
	if IsExisting("P1HQ") then
		CreateMilitaryGroup(1,Entities.PU_LeaderSword4,12,GetPosition("Hilfe1"))
		CreateMilitaryGroup(1,Entities.PU_LeaderSword4,12,GetPosition("Hilfe1"))
		CreateMilitaryGroup(1,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe1"))
		CreateMilitaryGroup(1,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe1"))
		CreateMilitaryGroup(1,Entities.PU_LeaderBow4,12,GetPosition("Hilfe1"))
		CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,6,GetPosition("Hilfe1"))
		AddSulfur(1,1000)
		AddIron(1,1000)
		AddStone(1,1000)
	end
	return true
end
function P2Hilfe()
	if IsExisting("P2HQ") then
		CreateMilitaryGroup(2,Entities.PU_LeaderSword4,12,GetPosition("Hilfe2"))
		CreateMilitaryGroup(2,Entities.PU_LeaderSword4,12,GetPosition("Hilfe2"))
		CreateMilitaryGroup(2,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe2"))
		CreateMilitaryGroup(2,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe2"))
		CreateMilitaryGroup(2,Entities.PU_LeaderBow4,12,GetPosition("Hilfe2"))
		CreateMilitaryGroup(2,Entities.PU_LeaderRifle2,6,GetPosition("Hilfe2"))
		AddSulfur(2,1000)
		AddIron(2,1000)
		AddStone(2,1000)
	end
	return true
end
function P3Hilfe()
	if IsExisting("P3HQ") then
		CreateMilitaryGroup(3,Entities.PU_LeaderSword4,12,GetPosition("Hilfe3"))
		CreateMilitaryGroup(3,Entities.PU_LeaderSword4,12,GetPosition("Hilfe3"))
		CreateMilitaryGroup(3,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe3"))
		CreateMilitaryGroup(3,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe3"))
		CreateMilitaryGroup(3,Entities.PU_LeaderBow4,12,GetPosition("Hilfe3"))
		CreateMilitaryGroup(3,Entities.PU_LeaderRifle2,6,GetPosition("Hilfe3"))
		AddSulfur(3,1000)
		AddIron(3,1000)
		AddStone(3,1000)
	end
	return true
end
function P4Hilfe()
	if IsExisting("P4HQ") then
		CreateMilitaryGroup(4,Entities.PU_LeaderSword4,12,GetPosition("Hilfe4"))
		CreateMilitaryGroup(4,Entities.PU_LeaderSword4,12,GetPosition("Hilfe4"))
		CreateMilitaryGroup(4,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe4"))
		CreateMilitaryGroup(4,Entities.PU_LeaderPoleArm4,12,GetPosition("Hilfe4"))
		CreateMilitaryGroup(4,Entities.PU_LeaderBow4,12,GetPosition("Hilfe4"))
		CreateMilitaryGroup(4,Entities.PU_LeaderRifle2,6,GetPosition("Hilfe4"))
		AddSulfur(4,1000)
		AddIron(4,1000)
		AddStone(4,1000)
	end
	return true
end
function ExtraMerchant()
	local mercenaryIdExtra = Logic.GetEntityIDByName("hilfscamp")
	Logic.AddMercenaryOffer(mercenaryIdExtra, Entities.PU_LeaderRifle2, 10, ResourceType.Sulfur, 150)
	Logic.AddMercenaryOffer(mercenaryIdExtra, Entities.PV_Cannon4, 8, ResourceType.Iron, 100)
	Logic.AddMercenaryOffer(mercenaryIdExtra, Entities.PU_LeaderBow4, 8, ResourceType.Iron, 150)
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
	CreateRandomGoldChest(GetPosition("Gold11"))
	CreateRandomGoldChest(GetPosition("Gold12"))
	CreateRandomGoldChest(GetPosition("Gold13"))
	CreateRandomGoldChest(GetPosition("Gold14"))
	CreateRandomGoldChest(GetPosition("Gold15"))
	CreateRandomGoldChest(GetPosition("Gold16"))
	CreateRandomGoldChest(GetPosition("Gold17"))
	CreateRandomGoldChest(GetPosition("Gold18"))
	CreateRandomGoldChest(GetPosition("Gold19"))
	CreateRandomGoldChest(GetPosition("Gold20"))
	CreateRandomGoldChest(GetPosition("Gold21"))
	CreateChestOpener("Pilgrim")
	StartChestQuest()
end
function SchweresNV()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSehrHart")
	army.strength = 6
	army.rodeLength = Logic.WorldGetSize()
	army.enemySearchPosition = GetPosition("Player2")
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	local armyid1 = army.id
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("NVSehrHart")
	army.strength = 6
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","SehrSchwer",1,{},{armyid1, army.id})
end
function ExtremesNV()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("ExtremHart")
	army.strength = 5
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	local armyid1 = army.id
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("SehrHart")
	army.strength = 4
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	local armyid2 = army.id
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("IrrsinnigSpawn")
	army.strength = 4
	army.rodeLength = Logic.WorldGetSize()
	army.enemySearchPosition = GetPosition("Player2")
	SetupArmy(army)
	for i = 1,army.strength do
		EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ExtremSchwer",1,{},{armyid1, armyid2, army.id})
end
function SehrSchwer(_armyID1, _armyID2)
	if IsExisting("NVAussen") then
		local army1 = ArmyTable[6][_armyID1 + 1]
		local army2 = ArmyTable[6][_armyID2 + 1]
		if IsDead(army1) and IsDead(army2) then
			SchweresNV()
			return true
		end
	end
end
function ExtremSchwer(_armyID1, _armyID2, _armyID3)
	if IsExisting("NVAussen") then
		local army1 = ArmyTable[6][_armyID1 + 1]
		local army2 = ArmyTable[6][_armyID2 + 1]
		local army3 = ArmyTable[6][_armyID3 + 1]
		if IsDead(army1) and IsDead(army2) and IsDead(army3) then
			ExtremesNV()
			StartCountdown(10 * 60, IrrsinnigRespawn, false)
			return true
		end
	end
end
function IrrsinnigRespawn()
	if IsExisting("IrrsinnigTurm") then
		local army = {}
		army.player = 6
		army.id = GetFirstFreeArmySlot(6)
		army.position = GetPosition("IrrsinnigSpawn")
		army.strength = 6
		army.rodeLength = Logic.WorldGetSize()
		army.enemySearchPosition = GetPosition("Player2")
		SetupArmy(army)
		for i = 1,army.strength do
			EnlargeArmy(army, {leaderType = NVTypes[math.random(1, 2)]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmyGeneric",1,{},{army.player, army.id})
	end
end
function AngriffsErinnerung()
	Message("Die Späher des Nebelvolks haben euch entdeckt! Sie werden sich bald zum Angriff sammeln. Macht euch schon einmal bereit!")
	Message("Bald ist es soweit!")
	Sound.PlayGUISound(Sounds.VoicesMentor_VC_OnlySomeMinutesLeft_rnd_01,500)
end
function KalaMad()
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonarrows_rnd_03,500)
	StartCountdown(90,KalaMad2,false)
end
function KalaMad2()
	Sound.PlayGUISound(Sounds.AOVoicesHero12_HERO12_poisonrange_rnd_03,500)
	StartCountdown(5*60,KalaMad,false)
end
function MoorFelsen()
	Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,22400,70600,200)
	Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,21500,70600,200)
	Logic.CreateEffect(GGL_Effects.FXTemplarAltarEffect,23000,70600,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,22400,70600,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,21500,70600,200)
	Logic.CreateEffect(GGL_Effects.FXMaryPoison,23000,70600,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,22400,70600,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,21500,70600,200)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison,23000,70600,200)
	Logic.CreateEffect(GGL_Effects.FXFireMedium,22400,72000,200)
	Logic.CreateEffect(GGL_Effects.FXFireMedium,21500,72000,200)
	Logic.CreateEffect(GGL_Effects.FXFireMedium,23000,72000,200)
	local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Geheimnisvoller Verhüllter Alchemist",
        text	= "@color:230,0,0 Ich biete euch meine Dienste an, verehrter Gebieter!",
        position = GetPosition("Alchemist"),
        dialogCamera = true,
        explore = 1800
    }
	AP{
        title	= "@color:230,120,0 Geheimnisvoller Verhüllter Alchemist",
        text	= "@color:230,0,0 Es gibt einen Weg direkt in das Hauptquartier des Nebelvolks. @cr Allerdings ist er seit einem starken Bergrutsch unpassierbar geworden.",
        position = GetPosition("RockMoor2"),
        dialogCamera = false,
        explore = 1000
    }
	AP{
        title	= "@color:230,120,0 Geheimnisvoller Verhüllter Alchemist",
        text	= "@color:230,0,0 Liefert mir eine Menge Schwefel. @cr Dann kann ich die Felsen für Euch freisprengen!",
    }
    StartBriefing(briefing)
	MoorTribute()
end
function MoorTribute()
	local MoorTr =  {}
	MoorTr.playerId = 1
	MoorTr.text = "Liefere 25000 Schwefel an den komischen Alchemisten, um den geheimen Weg ins Lager des Nebelvolks freizusprengen! "
	MoorTr.cost = { Sulfur = 25000 }
	MoorTr.Callback = MoorFelsenWeg
	MoorT = AddTribute(MoorTr)
end
function MoorFelsenWeg()
	Message("Danke, ich habe den Schwefel erhalten und werde nun mit der Sprengung beginnen!")
	Logic.CreateEffect(GGL_Effects.FXExplosion,60000,46500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,60000,46500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,60000,46500,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,59900,46100,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,59900,46100,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,59900,46100,200)
	Logic.CreateEffect(GGL_Effects.FXExplosion,59800,45700,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim,59800,45700,200)
	Logic.CreateEffect(GGL_Effects.FXExplosionShrapnel,59800,45700,200)
	DestroyEntity("RockMoor1")
	DestroyEntity("RockMoor2")
	DestroyEntity("RockMoor3")
end
function Pause()
	local briefing = {}
	local AP = function(_page) table.insert(briefing, _page) return _page end
	AP{ title	= "@color:230,120,0 Mentor", text	= "@color:230,0,0 Ihr spielt schon seit geraumer Zeit. Legt doch eine kurze Pause ein." }
	AP{ title	= "@color:230,120,0 Mentor", text	= "@color:230,0,0 Jeder Spieler kann zu beliebiger Zeit das Spiel mit der @color:230,120,0 <<Pause>> @color:230,0,0 Taste pausieren und durch erneutes Klicken der @color:230,120,0 <<Pause>> @color:230,0,0 Taste das Spiel fortfahren lassen." }
	StartBriefing(briefing)
	StartCountdown(2*60*60,Pause,false)
end
function UpgradeBuilding(_EntityName)
	local EntityID = GetEntityId(_EntityName)
	if IsValid(EntityID) then
		local EntityType = Logic.GetEntityType(EntityID)
		local PlayerID = GetPlayer(EntityID)
		local Costs = {}
		Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
		for Resource, Amount in Costs do
			Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
		end
		GUI.UpgradeSingleBuilding(EntityID)
	end
end