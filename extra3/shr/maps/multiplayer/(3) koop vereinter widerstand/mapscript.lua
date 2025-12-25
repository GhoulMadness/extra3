--------------------------------------------------------------------------------
-- MapName: (3) Vereinter Widerstand
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (3) Vereinter Widerstand "
gvMapVersion = " v1.2 "
if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff
	TagNachtZyklus(24,1,0,-2,1)

	Mission_InitGroups()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(10,TributeForMainquest,false)
	StartCountdown(12,DifficultyVorbereitung,false)
	--
	StartTechnologies()
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Erinnerung = StartCountdown(45,Denkanstoss,false)
	for i = 1, 3 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,3,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
			StartCountdown(2,Wechsel,false)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	--
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(2,3)
	--
	SetPlayerName(4,"Stoneshire")
	SetPlayerName(5,"Moorheim")
	SetPlayerName(6,"Varg")
	SetPlayerName(7,"Nebelvolk")
	SetPlayerName(8,"Mary de Morfichet")
	--
	ActivateShareExploration(1,2,true)
	ActivateShareExploration(1,3,true)
	ActivateShareExploration(3,2,true)
	--

	LocalMusic.UseSet = HIGHLANDMUSIC

end
function Wechsel()
	Logic.ChangeAllEntitiesPlayerID(2,1)
	Logic.ChangeAllEntitiesPlayerID(3,1)
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
function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt alle Feinde! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt alle Feinde! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function AddMainquestForPlayer3()
	Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt alle Feinde! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
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
	Tribut6()
	Tribut7()
	Tribut8()
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:30,250,30 <<Kooperation/Leicht>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut7()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:0,250,200 <<Kooperation/Normal>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut8()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:250,30,30 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ")and IsDead("P5HQ")and IsDead("P6HQ")and IsDead("P7HQ") and IsDead("P8HQ")then
		Victory()
		return true
	end
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Willkommen in diesen idyllischen nordischen Gefilden."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Leider gibt es kaum Zeit, um sich hier zu entspannen. Eure Nachbarsiedlungen haben es auf Eure Ressourcen abgesehen."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Ihr müsst geschickt zusammen arbeiten, um bestehen zu können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Eilt euch, da auch der Winter bald einsetzt! Im Winter werden euch weitere Feinde angreifen!"
    }
	AP{
        title	= "@color:230,120,0 Hinweise und Tipps",
        text	= "@color:230,0,0 Seid auf frühe Angriffe vorbereitet. Einer Eurer Gegner ist Euch sehr nahe! @cr Unterstützt Euch gegenseitig so gut es geht. Tauscht Ressourcen untereinander aus!"
    }
	AP{
        title	= "@color:230,120,0 Hinweise und Tipps",
        text	= "@color:230,0,0 Pilgrims Sprengfähigkeit kann Euch zu einem schnelleren Sieg verhelfen, aber auch Euren Untergang besiegeln! @cr Versucht Euren ersten Feind bereits zu besiegen, bevor die anderen Gegner zu Euch vorrücken können. So gelangt ihr an ein weiteres Dorfzentrum und Ressourcen!"
    }

	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }


    StartBriefing(briefing)
end
function SpielmodKoop0()
	Message("Ihr habt den @color:30,250,30 <<LEICHTEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	gvDiffLVL = 3
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	--
	for i = 1,3 do

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
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:30,250,30 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
	--

end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod0)
	--
	gvDiffLVL = 2
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	--
	for i = 1,3 do

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
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,250,200 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
	--
end


function SpielmodKoop2()
	Message("Ihr habt den @color:250,30,30 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod0)
	--
	gvDiffLVL = 1
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	for i = 1,3 do

		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.MU_Thief, i)
		--
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:250,30,30 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
end
function StartInitialize()

	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end

	MapEditor_SetupAI(4, 2, Logic.WorldGetSize(), 1, "P3", 3, 0)
	MapEditor_Armies[4].offensiveArmies.strength = MapEditor_Armies[4].offensiveArmies.strength - 4 * gvDiffLVL
	--
	SetHostile(1,4)
	SetHostile(2,4)
	SetHostile(3,4)

	StartCountdown((13+15*gvDiffLVL)*60,AngriffsErinnerung,false)
	StartCountdown((15+15*gvDiffLVL)*60,FelsWeg,true)
	StartCountdown((10+30*gvDiffLVL)*60,NV,false)
	StartCountdown((70*gvDiffLVL-30)*60,NV2,false)
	StartSimpleJob("VictoryJob")

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	for i = 1,3 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
		if GetClay(i) > 0 then
			AddClay(i,-(GetClay(i)))
		end
		if GetIron(i) > 0 then
			AddIron(i,-(GetIron(i)))
		end
		if GetStone(i) > 0 then
			AddStone(i,-(GetStone(i)))
		end
		if GetSulfur(i) > 0 then
			AddSulfur(i,-(GetSulfur(i)))
		end
	end

	Mission_InitLocalResources()
	Mission_InitMerchants()

end
function FelsWeg()
	DestroyEntity("Rock1")
	DestroyEntity("Rock2")
	DestroyEntity("Rock3")
	DestroyEntity("Rock4")
	DestroyEntity("Rock5")
	CreateArmy9()
	CreateArmy10()
	--
	CreateArmyMary()
	CreateArmyVarg()
	--
	for AI = 4, 8 do
		ResearchAllTechnologies(AI, false, false, false, true, false)
	end
end
function NV()
	CreateNVArmy1()
	CreateNVArmy2()
	ConnectLeaderWithArmy(GetID("Kala"), ArmyTable[7][3])
end
function NV2()
	CreateNVArmy3()
	CreateNVArmy4()
	CreateArmy5()
	CreateArmy7()
end
function AngriffsErinnerung()
	Message("Die Vorbereitungszeit ist fast vorbei!")
	Message("Weitere Feinde werden Euch schon bald angreifen!")
	Sound.PlayGUISound(Sounds.VoicesMentor_VC_OnlySomeMinutesLeft_rnd_01,120)
	MapEditor_SetupAI(5, 2, Logic.WorldGetSize(), 1, "P5", 3, 0)
	MapEditor_SetupAI(6, 3, Logic.WorldGetSize(), 3, "P6", 3, 0)
	MapEditor_Armies[6].offensiveArmies.strength = round(MapEditor_Armies[6].offensiveArmies.strength - 4 * gvDiffLVL)
	MapEditor_SetupAI(8, 3, Logic.WorldGetSize(), 3, "P8HQ", 3, 0)
	MapEditor_Armies[8].offensiveArmies.strength = round(MapEditor_Armies[6].offensiveArmies.strength - 4 * gvDiffLVL)
	--
	SetHostile(1,8)
	SetHostile(2,8)
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(1,6)
	SetHostile(2,6)
	SetHostile(1,7)
	SetHostile(2,7)
	SetHostile(3,5)
	SetHostile(3,6)
	SetHostile(3,7)
	SetHostile(3,8)
end
function CreateNVArmy1()

	army1	 = {}

	army1.player 		= 7
	army1.id			= 1
	army1.strength		= round(12 - 2 * gvDiffLVL)
	army1.position		= GetPosition("NVSpawns")
	army1.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army1)

	local troopDescription = {

		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}

	for i = 1,army1.strength do

		EnlargeArmy(army1,troopDescription)
	end


	StartSimpleJob("ControlArmy1")

end

function CreateNVArmy2()

	army2	 = {}

	army2.player 		= 7
	army2.id			= 2
	army2.strength		= round(10 - 2 * gvDiffLVL)
	army2.position		= GetPosition("NVSpawns")
	army2.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army2)

	local troopDescription = {

		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1,army2.strength do

		EnlargeArmy(army2,troopDescription)
	end

	StartSimpleJob("ControlArmy2")

end
function ControlArmy1()


    if IsVeryWeak(army1) and IsExisting("P7HQ") then

        CreateNVArmy1()

        return true

    else

       Advance(army1)

    end

end

function ControlArmy2()

	if IsVeryWeak(army2) and IsExisting("P7HQ") then

		CreateNVArmy2()
		return true
	else

		Advance(army2)

	end

end
function CreateNVArmy3()

	army3	 = {}

	army3.player 		= 7
	army3.id			= 3
	army3.strength		= round(15 - 3 * gvDiffLVL)
	army3.position		= GetPosition("NVSpawns")
	army3.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army3)

	local troopDescription = {

		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1,army3.strength do

		EnlargeArmy(army3,troopDescription)
	end

	StartSimpleJob("ControlArmy3")

end

function CreateNVArmy4()

	army4	 = {}

	army4.player 		= 7
	army4.id			= 4
	army4.strength		= round(13 - 3 * gvDiffLVL)
	army4.position		= GetPosition("NVSpawns")
	army4.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army4)

	local troopDescription = {

		maxNumberOfSoldiers	= 16,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1,army4.strength do

		EnlargeArmy(army4,troopDescription)
	end

	StartSimpleJob("ControlArmy4")

end
function ControlArmy3()


    if IsVeryWeak(army3) and IsExisting("P7HQ") then

        CreateNVArmy3()

        return true

    else

		Defend(army3)

    end

end

function ControlArmy4()

	if IsVeryWeak(army4) and IsExisting("P7HQ") then

		CreateNVArmy4()
		return true
	else

		Defend(army4)

	end

end
function CreateArmy5()
	army5	 = {}

	army5.player 		= 6
	army5.id			= 5
	army5.strength		= round(12 - 3 * gvDiffLVL)
	army5.position		= GetPosition("P6Spawns")
	army5.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army5)

	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderBow4
	}

	for i = 1, army5.strength do

		EnlargeArmy(army5,troopDescription)
	end

	StartSimpleJob("ControlArmy5")

end
function ControlArmy5()


    if IsVeryWeak(army5) and IsExisting("P6HQ") and Counter.Tick2("ControlArmy5Counter", round(30*gvDiffLVL)) then

        CreateArmy6()

        return true

    else

		Defend(army5)

    end

end
function CreateArmy6()
	army6	 = {}

	army6.player 		= 6
	army6.id			= 6
	army6.strength		= round(8 - 2*gvDiffLVL)
	army6.position		= GetPosition("P6Spawns")
	army6.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army6)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderHeavyCavalry2
	}

	for i = 1, army6.strength do
		EnlargeArmy(army6,troopDescription)
	end

  StartSimpleJob("ControlArmy6")

end
function ControlArmy6()


    if IsVeryWeak(army6) and IsExisting("P6HQ") and Counter.Tick2("ControlArmy6Counter", round(30*gvDiffLVL)) then

        CreateArmy5()

        return true

    else

		Defend(army6)

    end

end
function CreateArmy7()
	army7	 = {}

	army7.player 		= 8
	army7.id			= 7
	army7.strength		= round(12 - 3 * gvDiffLVL)
	army7.position		= GetPosition("P8Spawns")
	army7.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army7)

	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderSword4
	}

	for i = 1, army7.strength do
		EnlargeArmy(army7,troopDescription)
	end

	StartSimpleJob("ControlArmy7")

end
function ControlArmy7()


    if IsVeryWeak(army7) and IsExisting("P8HQ") and Counter.Tick2("ControlArmy7Counter", round(30*gvDiffLVL)) then

        CreateArmy8()

        return true

    else

		Defend(army7)

    end

end
function CreateArmy8()
	army8	 = {}

	army8.player 		= 8
	army8.id			= 8
	army8.strength		= round(8 - 2*gvDiffLVL)
	army8.position		= GetPosition("P8Spawns")
	army8.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army8)

	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}

	for i = 1, army8.strength do
		EnlargeArmy(army8,troopDescription)
	end

	StartSimpleJob("ControlArmy8")

end
function ControlArmy8()


    if IsVeryWeak(army8) and IsExisting("P8HQ") and Counter.Tick2("ControlArmy8Counter", round(30*gvDiffLVL)) then

        CreateArmy7()

        return true

    else

		Defend(army8)

    end

end

function CreateArmy9()
	army9	 = {}

	army9.player 		= 8
	army9.id			= 9
	army9.strength		= round(8 - 2*gvDiffLVL)
	army9.position		= GetPosition("P8_Spawn1")
	army9.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army9)

	local troopDescription = {

		maxNumberOfSoldiers	= 4,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BlackKnight_LeaderMace2
	}

	for i = 1, army9.strength do
		EnlargeArmy(army9,troopDescription)
	end

	StartSimpleJob("ControlArmy9")

end
function ControlArmy9()


    if IsVeryWeak(army9) and IsExisting("P8_Tower1") and Counter.Tick2("ControlArmy9Counter", round(45*gvDiffLVL)) then

        CreateArmy9()

        return true

    else

		Defend(army9)

    end

end

function CreateArmy10()
	army10	 = {}

	army10.player 		= 8
	army10.id			= 10
	army10.strength		= round(8 - 2*gvDiffLVL)
	army10.position		= GetPosition("P8_Spawn2")
	army10.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army10)

	local troopDescription = {

		maxNumberOfSoldiers	= 4,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BlackKnight_LeaderMace2
	}

	for i = 1, army10.strength do
		EnlargeArmy(army10,troopDescription)
	end

	StartSimpleJob("ControlArmy10")

end
function ControlArmy10()


    if IsVeryWeak(army10) and IsExisting("P8_Tower2") and Counter.Tick2("ControlArmy10Counter", round(45*gvDiffLVL)) then

        CreateArmy10()

        return true

    else

		Defend(army10)

    end

end
--
function CreateArmyMary()

	local army	 = {}

	army.player 	= 8
	army.id			= 0
	army.strength	= round(16 - 4 * gvDiffLVL)
	army.position	= GetPosition("P8Spawns")
	army.rodeLength	= 7600

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_VeteranMajor
	}
	for i = 1, army.strength do
		EnlargeArmy(army,troopDescription)
	end
	if not army.mary then
		army.mary = GetID("Mary")
		ConnectLeaderWithArmy(army.mary, army)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmyMary", 1, {}, {army.id})
end
function ControlArmyMary(_armyID)

	local army = ArmyTable[8][_armyID+1]
	if IsVeryWeak(army) and IsExisting("P8HQ") then
		if Counter.Tick2("ControlArmyCounter_8_" .. _armyID, 60*gvDiffLVL) then
			CreateArmyMary()
			return true
		end
    end
	Defend(army)

end
function CreateArmyVarg()

	local army	 = {}

	army.player 	= 6
	army.id			= 0
	army.strength	= round(16 - 4 * gvDiffLVL)
	army.position	= GetPosition("P6")
	army.rodeLength	= 7400

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_VeteranLieutenant
	}
	for i = 1, army.strength do
		EnlargeArmy(army,troopDescription)
	end
	if not army.varg then
		army.varg = GetID("Varg")
		ConnectLeaderWithArmy(army.varg, army)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmyVarg", 1, {}, {army.id})
end
function ControlArmyVarg(_armyID)

	local army = ArmyTable[6][_armyID+1]
	if IsVeryWeak(army) and Logic.GetNumberOfEntitiesOfTypeOfPlayer(6, Entities.CB_FolklungCastle) > 0 then
		if Counter.Tick2("ControlArmyCounter_6_" .. _armyID, 60*gvDiffLVL) then
			CreateArmyVarg()
			return true
		end
    end
	Defend(army)

end

function Mission_InitMerchants()

	local mercenaryId = Logic.GetEntityIDByName("camp1")
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderRifle2, round(3*gvDiffLVL), ResourceType.Sulfur, dekaround(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderSword4, round(5*gvDiffLVL), ResourceType.Iron, dekaround(800/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderPoleArm4, round(5*gvDiffLVL), ResourceType.Wood, dekaround(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId, Entities.PU_LeaderBow4, round(5*gvDiffLVL), ResourceType.Gold, dekaround(1400/gvDiffLVL))

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	InitPlayerColorMapping()
	for i = 1,5 do
		ChangePlayer("P9"..i,9)
	end
	ChangePlayer("camp1",9)
end
function InitPlayerColorMapping()
	Display.SetPlayerColorMapping(6,ROBBERS_COLOR)
	Display.SetPlayerColorMapping(8,KERBEROS_COLOR)
	Display.SetPlayerColorMapping(7,EVIL_GOVERNOR_COLOR)
	Display.SetPlayerColorMapping(4,NPC_COLOR)
	Display.SetPlayerColorMapping(9,NPC_COLOR)
	Display.SetPlayerColorMapping(5,FRIENDLY_COLOR2)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
	--no limitation in this map
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Set local resources
function Mission_InitLocalResources()


	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= 500 + dekaround(200*gvDiffLVL)
	local InitClayRaw 		= 1000 + dekaround(200*gvDiffLVL)
	local InitWoodRaw 		= 800 + dekaround(200*gvDiffLVL)
	local InitStoneRaw 		= 1000 + dekaround(200*gvDiffLVL)
	local InitIronRaw 		= 0 + 300 * (gvDiffLVL - 1)
	local InitSulfurRaw		= 0 + 150 * (gvDiffLVL - 1)


	--Add Players Resources
	local i
	for i=1,8,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end