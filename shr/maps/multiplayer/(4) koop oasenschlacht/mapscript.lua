--------------------------------------------------------------------------------
-- MapName: (4) Oasenschlacht
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Oasenschlacht "
gvMapVersion = " v1.0"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(16,0,0,0,1)
--

	Mission_InitGroups()	
	Mission_InitLocalResources()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	--
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(5,TributeForMainquest,false)
	StartCountdown(6,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)

	if XNetwork.Manager_DoesExist() == 0 then

		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	LocalMusic.UseSet = MEDITERANEANMUSIC
	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end

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
function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Erobert die Oase in der Mitte der Karte! @cr @cr Vertreibt alle Räuber und vernichtet die Stadt Ksar Ghilane! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Erobert die Oase in der Mitte der Karte! @cr @cr Vertreibt alle Räuber und vernichtet die Stadt Ksar Ghilane! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer3()
	Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Erobert die Oase in der Mitte der Karte! @cr @cr Vertreibt alle Räuber und vernichtet die Stadt Ksar Ghilane! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer4()
	Logic.AddQuest(4,4,MAINQUEST_OPEN,"Missionsziele","Erobert die Oase in der Mitte der Karte! @cr @cr Vertreibt alle Räuber und vernichtet die Stadt Ksar Ghilane! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
end
--
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
end
--
function Schwierigkeitsgradbestimmer()
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos,120)
	Tribut1()
	Tribut2()
	Tribut3()
end
function Tribut1()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:50,220,50 <<Kooperation/Normal>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut2()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:0,250,200 <<Kooperation/Schwer>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut3()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:250,40,40 <<Kooperation/Irrsinnig>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
--

function VictoryJob()
	if IsDead("HQP5")and IsDead("HQP6") and IsDead("HQP7") and Logic.GetNumberOfEntitiesOfTypeOfPlayer(5, Entities.CB_Bastille1) == 0 then
		Victory()
		return true
	end
end

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Willkommen in der wunderschönen, aber kargen und ausgedörrten Region Jebil.",
		position = GetPlayerStartPosition()
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Inmitten dieser Steppengegend liegt die Lebensader der Region, die Oase Ksar Rhilane.",
		position = {X = 35010, Y = 38890}
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Ihr seid aber leider nicht zum Entspannen hier. @cr Ein machthungriger Statthalter hat die umliegenden Dörfer von der Wasserversorgung abgeschnitten.",
		position = {X = 53000, Y = 52100}
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Noch weiß er nichts von Eurer Anwesenheit. @cr Ihr solltet diesen Umstand nutzen, und möglichst schnell eine Armee ausheben.",
		position = GetPlayerStartPosition()
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Doch Achtung: Räuber machen die Gegend ebenfalls unsicher und werden Euch sicher nicht freundlich gesinnt sein.",
		position = {X = 25500, Y = 43600}
    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 1) Vernichtet alle Räuberlager! @cr 2) Vernichtet die Stadt Ksar Ghilane!",
		position = GetPlayerStartPosition()
    }

    StartBriefing(briefing)
end

function SpielmodKoop0()
	Message("Ihr habt den @color:50,220,50 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 3
	StartInitialize()
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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
	local InitGoldRaw 		= 2000
	local InitClayRaw 		= 1600
	local InitWoodRaw 		= 1600
	local InitStoneRaw 		= 1300
	local InitIronRaw 		= 350
	local InitSulfurRaw		= 350

	
	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 2
	StartInitialize()
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	--
	for i = 1,4 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
	end
	--
	StopCountdown(Erinnerung)
	-- Initial Resources
	local InitGoldRaw 		= 900
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 250
	local InitSulfurRaw		= 250

	
	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end


function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 1
	StartInitialize()
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	StopCountdown(Erinnerung)
	-- Initial Resources
	local InitGoldRaw 		= 700
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0

	
	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
end

function CreateArmy1()

	Army1	 = {}
	
	Army1.player 		= 5
	Army1.id			= 1
	Army1.strength		= 7-gvDiffLVL
	Army1.position		= GetPosition("BanditSpawn1")
	Army1.rodeLength	= 9500 - (gvDiffLVL*500)

	SetupArmy(Army1)

	local troopDescription = {

		experiencePoints	= HIGH_EXPERIENCE,
		leaderType    		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army1.strength do
		EnlargeArmy(Army1,troopDescription)
	end
	
	StartSimpleJob("ControlArmy1")

end
function ControlArmy1()

    if IsDead(Army1) and IsExisting("BanditTower1") then
        CreateArmy1()
        return true
    else
		Defend(Army1)
    end

end

function CreateArmy2()

	Army2	 = {}
	
	Army2.player 		= 5
	Army2.id			= 2
	Army2.strength		= 6-gvDiffLVL
	Army2.position		= GetPosition("BanditSpawn1")
	Army2.rodeLength	= 9200 - (gvDiffLVL*500)

	SetupArmy(Army2)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderBow1
	}
	for i = 1, Army2.strength do
		EnlargeArmy(Army2,troopDescription)
	end
	
	StartSimpleJob("ControlArmy2")

end
function ControlArmy2()

    if IsDead(Army2) and IsExisting("BanditTower1") then
        CreateArmy2()
        return true
    else
		Defend(Army2)
    end

end

function CreateArmy3()

	Army3	 = {}
	
	Army3.player 		= 5
	Army3.id			= 3
	Army3.strength		= 5-gvDiffLVL
	Army3.position		= GetPosition("BanditSpawn2")
	Army3.rodeLength	= 8000 - (gvDiffLVL*500)

	SetupArmy(Army3)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderBow1
	}
	for i = 1, Army3.strength do
		EnlargeArmy(Army3,troopDescription)
	end
	
	StartSimpleJob("ControlArmy3")

end
function ControlArmy3()

    if IsDead(Army3) and IsExisting("BanditTower2") then
        CreateArmy3()
        return true
    else
		Defend(Army3)
    end

end

function CreateArmy4()

	Army4	 = {}
	
	Army4.player 		= 5
	Army4.id			= 4
	Army4.strength		= 8-gvDiffLVL
	Army4.position		= GetPosition("BanditSpawn2")
	Army4.rodeLength	= 8200 - (gvDiffLVL*500)

	SetupArmy(Army4)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army4.strength do
		EnlargeArmy(Army4,troopDescription)
	end
	
	StartSimpleJob("ControlArmy4")

end
function ControlArmy4()

    if IsDead(Army4) and IsExisting("BanditTower2") then
        CreateArmy4()
        return true
    else
		Defend(Army4)
    end

end

function CreateArmy5()

	Army5	 = {}
	
	Army5.player 		= 5
	Army5.id			= 5
	Army5.strength		= 6-gvDiffLVL
	Army5.position		= GetPosition("BanditSpawn3")
	Army5.rodeLength	= 8500 - (gvDiffLVL*500)

	SetupArmy(Army5)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army5.strength do
		EnlargeArmy(Army5,troopDescription)
	end
	
	StartSimpleJob("ControlArmy5")

end
function ControlArmy5()

    if IsDead(Army5) and IsExisting("BanditTower3") then
        CreateArmy5()
        return true
    else
		Defend(Army5)
    end

end
function CreateArmy6()

	Army6	 = {}
	
	Army6.player 		= 5
	Army6.id			= 6
	Army6.strength		= 7-gvDiffLVL
	Army6.position		= GetPosition("BanditSpawn3")
	Army6.rodeLength	= 8200 - (gvDiffLVL*500)

	SetupArmy(Army6)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities["PU_LeaderBow".. 5-gvDiffLVL]
	}
	for i = 1, Army6.strength do
		EnlargeArmy(Army6,troopDescription)
	end
	
	StartSimpleJob("ControlArmy6")

end
function ControlArmy6()

    if IsDead(Army6) and IsExisting("BanditTower3") then
        CreateArmy6()
        return true
    else
		Defend(Army6)
    end

end

function CreateArmy7()

	Army7	 = {}
	
	Army7.player 		= 5
	Army7.id			= 7
	Army7.strength		= 12-(3*gvDiffLVL)
	Army7.position		= GetPosition("BanditSpawn4")
	Army7.rodeLength	= 7500 - (gvDiffLVL*500)

	SetupArmy(Army7)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army7.strength do
		EnlargeArmy(Army7,troopDescription)
	end
	
	StartSimpleJob("ControlArmy7")

end
function ControlArmy7()

    if IsDead(Army7) and IsExisting("BanditTower4") then
        CreateArmy7()
        return true
    else
		Defend(Army7)
    end

end

function CreateArmy8()

	Army8	 = {}
	
	Army8.player 		= 5
	Army8.id			= 8
	Army8.strength		= 7-(2*gvDiffLVL)
	Army8.position		= GetPosition("BanditSpawn4")
	Army8.rodeLength	= 6000 - (gvDiffLVL*500)

	SetupArmy(Army8)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.PU_LeaderCavalry2
	}
	for i = 1, Army8.strength do
		EnlargeArmy(Army8,troopDescription)
	end
	
	StartSimpleJob("ControlArmy8")

end
function ControlArmy8()

    if IsDead(Army8) and IsExisting("BanditTower4") then
        CreateArmy8()
        return true
    else
		Defend(Army8)
    end

end

function CreateArmy9()

	Army9	 = {}
	
	Army9.player 		= 5
	Army9.id			= 9
	Army9.strength		= 9-(2*gvDiffLVL)
	Army9.position		= GetPosition("BanditSpawn5")
	Army9.rodeLength	= 7200 - (gvDiffLVL*500)

	SetupArmy(Army9)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderBow1
	}
	for i = 1, Army9.strength do
		EnlargeArmy(Army9,troopDescription)
	end
	
	StartSimpleJob("ControlArmy9")

end
function ControlArmy9()

    if IsDead(Army9) and IsExisting("BanditTower5") then
        CreateArmy9()
        return true
    else
		Defend(Army9)
    end

end

function CreateArmy10()

	Army10	 = {}
	
	Army10.player 		= 5
	Army10.id			= 10
	Army10.strength		= 11-(3*gvDiffLVL)
	Army10.position		= GetPosition("BanditSpawn5")
	Army10.rodeLength	= 7400 - (gvDiffLVL*500)

	SetupArmy(Army10)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army10.strength do
		EnlargeArmy(Army10,troopDescription)
	end
	
	StartSimpleJob("ControlArmy10")

end
function ControlArmy10()

    if IsDead(Army10) and IsExisting("BanditTower5") then
        CreateArmy10()
        return true
    else
		Defend(Army10)
    end

end

function CreateArmy11()

	Army11	 = {}
	
	Army11.player 		= 5
	Army11.id			= 11
	Army11.strength		= 8-(2*gvDiffLVL)
	Army11.position		= GetPosition("BanditSpawn6")
	Army11.rodeLength	= 6800 - (gvDiffLVL*400)

	SetupArmy(Army11)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderSword1
	}
	for i = 1, Army11.strength do
		EnlargeArmy(Army11,troopDescription)
	end
	
	StartSimpleJob("ControlArmy11")

end
function ControlArmy11()

    if IsDead(Army11) and IsExisting("BanditTower6") then
        CreateArmy11()
        return true
    else
		Defend(Army11)
    end

end

function CreateArmy12()

	Army12	 = {}
	
	Army12.player 		= 5
	Army12.id			= 12
	Army12.strength		= 6-gvDiffLVL
	Army12.position		= GetPosition("BanditSpawn6")
	Army12.rodeLength	= 6600 - (gvDiffLVL*400)

	SetupArmy(Army12)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities["PU_LeaderBow".. 5-gvDiffLVL]
	}
	for i = 1, Army12.strength do
		EnlargeArmy(Army12,troopDescription)
	end
	
	StartSimpleJob("ControlArmy12")

end
function ControlArmy12()

    if IsDead(Army12) and IsExisting("BanditTower6") then
        CreateArmy12()
        return true
    else
		Defend(Army12)
    end

end

function CreateArmy13()

	Army13	 = {}
	
	Army13.player 		= 5
	Army13.id			= 13
	Army13.strength		= 7-gvDiffLVL
	Army13.position		= GetPosition("BanditSpawn7")
	Army13.rodeLength	= 9500 - (gvDiffLVL*500)

	SetupArmy(Army13)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities["PU_LeaderSword".. 5-gvDiffLVL]
	}
	for i = 1, Army13.strength do
		EnlargeArmy(Army13,troopDescription)
	end
	
	StartSimpleJob("ControlArmy13")

end
function ControlArmy13()

    if IsDead(Army13) and IsExisting("BanditTower7") then
        CreateArmy13()
        return true
    else
		Defend(Army13)
    end

end

function CreateArmy14()

	Army14	 = {}
	
	Army14.player 		= 5
	Army14.id			= 14
	Army14.strength		= 9-(2*gvDiffLVL)
	Army14.position		= GetPosition("BanditSpawn7")
	Army14.rodeLength	= 9200 - (gvDiffLVL*500)

	SetupArmy(Army14)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType   		= Entities.CU_BanditLeaderBow1
	}
	for i = 1, Army14.strength do
		EnlargeArmy(Army14,troopDescription)
	end
	
	StartSimpleJob("ControlArmy14")

end
function ControlArmy14()

    if IsDead(Army14) and IsExisting("BanditTower7") then
        CreateArmy14()
        return true
    else
		Defend(Army14)
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
	for i = 1,4 do
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.T_MarketWood, i)
	end
end

function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
end
function InitDiplomacy()
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	for i = 1, 4 do
		SetHostile(i,5)
		SetHostile(i,6)
		SetHostile(i,7)
	end
	--
  	SetPlayerName(5,"Steppenräuber")
	SetPlayerName(6,"Ksar Ghilane")
	SetPlayerName(7,"Der schwarze Despot")
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
	
	for i = 5,7 do
		Display.SetPlayerColorMapping(i, ROBBERS_COLOR)
	end
	Display.SetPlayerColorMapping(8, NPC_COLOR)
	
end

function StartInitialize()
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	--
	MapEditor_SetupAI(7,3, 13000,math.min(5-gvDiffLVL,3),"HQP7",3,0)
	SetupPlayerAi( 7, {constructing = true, repairing = true, extracting = 1, serfLimit = 17} )
	MapEditor_SetupAI(6,3, 18500,math.min(5-gvDiffLVL,3),"HQP6",3,0)
	SetupPlayerAi( 6, {constructing = true, repairing = true, extracting = 1, serfLimit = 19} )
	MapEditor_SetupAI(5,3, 11000,math.min(5-gvDiffLVL,3),"HQP5",3,0)
	SetupPlayerAi( 5, {constructing = true, repairing = true, extracting = 1, serfLimit = 17} )
	--
	for i = 1, 14 do
		_G["CreateArmy".. i]()
	end
	--
	for i = 5,7 do
		MapEditor_Armies[i].offensiveArmies.strength = round(50-(10*gvDiffLVL))
		ResearchAllTechnologies(i, false, false, false, true, false)
	end
	StartCountdown(40*gvDiffLVL*60, AIUpgrade, false)
end
function AIUpgrade()
	Message("Ksar Ghilane ist Eure Anwesenheit nun nicht mehr unbekannt. @cr Sie werden Euch bestimmt schon bald angreifen!")
	for i = 5,7 do
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + (12 /gvDiffLVL)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.3
	end
	StartCountdown(20*gvDiffLVL*60, AIUpgrade2, false)
end
function AIUpgrade2()
	for i = 5,7 do
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + (6 /gvDiffLVL)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
	end
	StartCountdown(15*gvDiffLVL*60, AIUpgrade2, false)
end 