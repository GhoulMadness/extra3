if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Angriff auf Evelance "
gvMapVersion = " v1.3"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,1,-2,1)

	Mission_InitGroups()
	Mission_InitLocalResources()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	SetHumanPlayerDiplomacyToAllAIs({1,2,3,4},Diplomacy.Hostile)
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(7,TributeForMainquest,false)
	StartCountdown(8,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")
     StartSimpleJob("SJ_DefeatP3")
	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
	end

	LocalMusic.UseSet = EVELANCEMUSIC
	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function Mission_InitLocalResources()
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
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
	GUI.PayTribute(8,TributMainquestP3)
	GUI.PayTribute(8,TributMainquestP4)
end
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mÃ¶gliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus Ã¼ber das TributmenÃ¼ bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mÃ¶gliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus Ã¼ber das TributmenÃ¼ bestimmen!",1) end
function AddMainquestForPlayer3() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mÃ¶gliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus Ã¼ber das TributmenÃ¼ bestimmen!",1) end
function AddMainquestForPlayer4() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mÃ¶gliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus Ã¼ber das TributmenÃ¼ bestimmen!",1) end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
	return true
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
	return true
end
function Schwierigkeitsgradbestimmer()
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos,200)
	Tribut5()
	Tribut6()
	Tribut7()
	Tribut8()
	Tribut9()
	return true
end
function Tribut5()
	local TrModW =  {}
	TrModW.playerId = 1
	TrModW.text = "Spielmodus @color:90,255,250 <<Kooperation/Waschlappen>>! "
	TrModW.cost = { Gold = 0 }
	TrModW.Callback = SpielmodKoopWaschlappen
	TModW = AddTribute(TrModW)
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:0,136,0 <<Kooperation/Normal>>! "
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
	TrMod2.text = "Spielmodus @color:250,20,60 <<Kooperation/Irrsinnig>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function Tribut9()
	local TrModVs =  {}
	TrModVs.playerId = 1
	TrModVs.text = "Spielmodus @color:200,150,100 <<2vs2>>! "
	TrModVs.cost = { Gold = 0 }
	TrModVs.Callback = SpielmodVs
	TModVs = AddTribute(TrModVs)
end
--
function VictoryJob()
	if IsDead("HQP5") then
		Victory()
		return true
	end
end
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
function SJ_DefeatP4()
	if IsDead("HQP4") then
		Logic.PlayerSetGameStateToLost(4)
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
        text	= "@color:230,0,0 Hinweis: Eilt euch, es wird sicher nicht lange dauern, bis Kerberos Schergen Euch entdeck haben!"
    }
	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }


    StartBriefing(briefing)
end
function SpielmodKoopWaschlappen()
	Message("Ihr habt den @color:90,255,250 <<WASCHLAPPEN-KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(50*60,PeacetimeOver,true)
	StartCountdown(47*60,ActivateKI,false)
	StartCountdown(90*60,UpgradeKI,false)
	StartCountdown(150*60,ExtraTruppen, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01,200)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TModVs)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 6 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	--
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 3000
	local InitClayRaw 		= 2500
	local InitWoodRaw 		= 2500
	local InitStoneRaw 		= 2000
	local InitIronRaw 		= 800
	local InitSulfurRaw		= 500


	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 WASCHLAPPEN @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop0()
	Message("Ihr habt den @color:0,136,0 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(40*60,PeacetimeOver,true)
	StartCountdown(37*60,ActivateKI,false)
	StartCountdown(60*60,UpgradeKI,false)
	StartCountdown(80*60,ExtraTruppen, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,160)
	--
	Logic.RemoveTribute(1,TModW)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TModVs)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	--
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 1200
	local InitClayRaw 		= 1600
	local InitWoodRaw 		= 1600
	local InitStoneRaw 		= 1200
	local InitIronRaw 		= 500
	local InitSulfurRaw		= 400


	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(30*60,PeacetimeOver,true)
	StartCountdown(27*60,ActivateKI,false)
	StartCountdown(40*60,UpgradeKI,false)
	StartCountdown(60*60,ExtraTruppen, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,170)
	--
	Logic.RemoveTribute(1,TModW)
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TModVs)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	--
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 900
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 800
	local InitIronRaw 		= 350
	local InitSulfurRaw		= 350


	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(20*60,PeacetimeOver,true)
	StartCountdown(17*60,ActivateKI,false)
	StartCountdown(25*60,UpgradeKI,false)
	StartCountdown(40*60,ExtraTruppen, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,180)
	--
	Logic.RemoveTribute(1,TModW)
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TModVs)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 900
	local InitWoodRaw 		= 900
	local InitStoneRaw 		= 600
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodVs()
	Message("Ihr habt den @color:0,200,250 <<2vs2 Modus>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(40*60,PeacetimeOver,true)
	StartCountdown(37*60,ActivateKI,false)
	StartCountdown(60*60,ExtraTruppen, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,190)
	--
	Logic.RemoveTribute(1,TModW)
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	SetFriendly(1,2)
	SetHostile(1,3)
	SetHostile(1,4)
	SetHostile(2,3)
	SetHostile(2,4)
	SetFriendly(3,4)
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 800
	local InitClayRaw 		= 900
	local InitWoodRaw 		= 900
	local InitStoneRaw 		= 800
	local InitIronRaw 		= 300
	local InitSulfurRaw		= 300
	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 2vs2 @cr "..
		" @color:230,200,240 "..gvMapVersion)
end
function PeacetimeOver()
	for i = 1,4 do
		DestroyEntity("Barrier"..i)
	end
end
function ActivateKI()
	for i = 5,8 do
		MapEditor_SetupAI(i,2,Logic.WorldGetSize(),3,"P"..i,3,20*60) SetupPlayerAi( i, {constructing = true, extracting = 1, repairing = true, serfLimit = 12} )
		SetAIUnitsToBuild(i, UpgradeCategories.LeaderBow, UpgradeCategories.LeaderBarbarian, UpgradeCategories.BlackKnightLeaderMace1,UpgradeCategories.LeaderHeavyCavalry,UpgradeCategories.LeaderCavalry,UpgradeCategories.LeaderSword,UpgradeCategories.LeaderPoleArm,Entities.PV_Cannon3,Entities.PV_Cannon2 )
	end
end
function ExtraTruppen()
	CreateKerbArmy5()
	CreateKerbArmy1()
end
function CreateKerbArmy5()
	army5	 = {}
	army5.player 		= 7
	army5.id			= 5
	army5.strength		= 4
	army5.position		= GetPosition("ExtraSpawn")
	army5.rodeLength	= Logic.WorldGetSize()
	SetupArmy(army5)
	local troopDescription = {
		maxNumberOfSoldiers	= 3,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderHeavyCavalry2
	}
	for i = 1,4 do
		EnlargeArmy(army5,troopDescription)
	end
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
		leaderType       	  = Entities.PU_LeaderPoleArm4
	}
	for i = 1,4 do
		EnlargeArmy(armyFive,troopDescription)
	end

	StartSimpleJob("ControlArmyFive")

end
function ControlArmy5()


    if IsDead(army5) and IsExisting("HQP5") then

        CreateKerbArmyFive()

        return true

    else

		Advance(army5)

    end

end

function ControlArmyFive()

	if IsDead(armyFive) and IsExisting("HQP5") then

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
	army1.strength		= 4
	army1.position		= GetPosition("ExtraSpawn")
	army1.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army1)


	local troopDescription = {

		maxNumberOfSoldiers		= 12,
		minNumberOfSoldiers		= 0,
		experiencePoints 		= LOW_EXPERIENCE,
		leaderType       	  	= Entities.PU_LeaderSword4
	}

	for i = 1,4 do

		EnlargeArmy(army1,troopDescription)

	end


	StartSimpleJob("ControlArmy1")

end

function CreateKerbArmyTwo()

	armyTwo	 = {}

	armyTwo.player 			= 8
	armyTwo.id				= 2
	armyTwo.strength		= 4
	armyTwo.position		= GetPosition("ExtraSpawn")
	armyTwo.rodeLength		= Logic.WorldGetSize()

	SetupArmy(armyTwo)


	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}

	for i = 1,4 do
		EnlargeArmy(armyTwo,troopDescription)
	end

	StartSimpleJob("ControlArmyTwo")

end
function ControlArmy1()


    if IsDead(army1) and IsExisting("HQP5") then

        CreateKerbArmyTwo()


        return true

    else


        Defend(army1)

    end

end


function ControlArmyTwo()


	if IsDead(armyTwo) and IsExisting("HQP5") then

		CreateKerbArmy1()
		return true
	else

		Defend(armyTwo)


	end

end


function Mission_InitGroups()
	Start()
end
function Mission_InitTechnologies()
end
function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
	StartCountdown(15,KerbVoice,false)
end
function InitDiplomacy()
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

	for i = 5,8 do
		Display.SetPlayerColorMapping(i,KERBEROS_COLOR)
	end

end

function UpgradeKI()
	for i = 5,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
	end
	StartCountdown(30*60,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
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
function Sound1() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_01,200) end
function Sound2() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_01,200) end
function Sound3() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_01,200) end
function Sound4() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_02,200) end
function Sound5() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_02,200) end
function Sound6() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_03,200) end
function Sound7() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_FunnyComment_rnd_01,200) end
function Sound8() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_05,200) StartCountdown(4*60,KerbVoice,false) end
function StartCountdown(_Limit, _Callback, _Show) assert(type(_Limit) == "number") Counter.Index = (Counter.Index or 0) + 1 if _Show and CountdownIsVisisble() then assert(false, "StartCountdown: A countdown is already visible") end Counter["counter" .. Counter.Index] = {Limit = _Limit, TickCount = 0, Callback = _Callback, Show = _Show, Finished = false} if _Show then MapLocal_StartCountDown(_Limit) end if Counter.JobId == nil then Counter.JobId = StartSimpleJob("CountdownTick") end return Counter.Index end
function StopCountdown(_Id) if Counter.Index == nil then return end if _Id == nil then for i = 1, Counter.Index do if Counter.IsValid("counter" .. i) then if Counter["counter" .. i].Show then MapLocal_StopCountDown() end Counter["counter" .. i] = nil end end else if Counter.IsValid("counter" .. _Id) then if Counter["counter" .. _Id].Show then MapLocal_StopCountDown() end Counter["counter" .. _Id] = nil end end end
function CountdownTick() local empty = true for i = 1, Counter.Index do if Counter.IsValid("counter" .. i) then if Counter.Tick("counter" .. i) then Counter["counter" .. i].Finished = true end if Counter["counter" .. i].Finished and not IsBriefingActive() then if Counter["counter" .. i].Show then MapLocal_StopCountDown() end if type(Counter["counter" .. i].Callback) == "function" then Counter["counter" .. i].Callback() end
Counter["counter" .. i] = nil end empty = false end end if empty then Counter.JobId = nil Counter.Index = nil return true end end
function CountdownIsVisisble() for i = 1, Counter.Index do  if Counter.IsValid("counter" .. i) and Counter["counter" .. i].Show then  return true end end return false end
function UpgradeBuilding(_EntityName) local EntityID = GetEntityId(_EntityName) if IsValid(EntityID) then local EntityType = Logic.GetEntityType(EntityID) local PlayerID = GetPlayer(EntityID) local Costs = {} Logic.FillBuildingUpgradeCostsTable(EntityType, Costs) for Resource, Amount in Costs do Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)  end GUI.UpgradeSingleBuilding(EntityID)  end end
function AddTribute( _tribute ) uniqueTributeCounter = uniqueTributeCounter or 1; _tribute.Tribute = uniqueTributeCounter; uniqueTributeCounter = uniqueTributeCounter + 1; local tResCost = {}; for k, v in pairs( _tribute.cost ) do  assert( ResourceType[k] ); assert( type( v ) == "number" );
table.insert( tResCost, ResourceType[k] ); table.insert( tResCost, v ); end Logic.AddTribute( _tribute.playerId, _tribute.Tribute, 0, 0, _tribute.text, unpack( tResCost ) ); SetupTributePaid( _tribute ); return _tribute.Tribute; end
function AddPages( _briefing )  local AP = function(_page) table.insert(_briefing, _page); return _page; end local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end return AP, ASP; end
function CreateShortPage( _entity, _title, _text, _dialog, _explore)  local page = { title = _title, text = _text,  position = GetPosition( _entity ), action = function ()Display.SetRenderFogOfWar(0) end };
if _dialog then if type(_dialog) == "boolean" then page.dialogCamera = true; elseif type(_dialog) == "number" then page.explore = _dialog; end end
if _explore then if type(_explore) == "boolean" then page.dialogCamera = true; elseif type(_explore) == "number" then page.explore = _explore; end end   return page; end
function SetAIUnitsToBuild( _aiID, ... ) for i = table.getn(DataTable), 1, -1 do if DataTable[i].player == _aiID and DataTable[i].AllowedTypes then  DataTable[i].AllowedTypes = arg; end end end 