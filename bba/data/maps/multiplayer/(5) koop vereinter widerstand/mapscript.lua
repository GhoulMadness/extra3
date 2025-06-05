--------------------------------------------------------------------------------
-- MapName: (5) Vereinter Widerstand
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (5) Vereinter Widerstand "
gvMapVersion = " v1.1 "
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
	for i = 1, 5 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,5,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
			StartCountdown(2,Wechsel,false)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	--
	SetPlayerDiplomacy({1,2,3,4,5}, Diplomacy.Friendly)
	--
	SetPlayerName(6,"Varg")
	SetPlayerName(7,"Nebelvolk")
	SetPlayerName(8,"Mary de Mortfichet")
	--
	for i = 1, 5 do
		for k = 1, 5 do
			if i ~= k then
				ActivateShareExploration(i, k, true)
			end
		end
	end
	--

	LocalMusic.UseSet = HIGHLANDMUSIC

end
function Wechsel()
	Logic.ChangeAllEntitiesPlayerID(2,1)
	Logic.ChangeAllEntitiesPlayerID(3,1)
	Logic.ChangeAllEntitiesPlayerID(4,1)
	Logic.ChangeAllEntitiesPlayerID(5,1)
end
function Hauptaufgabe()
	TributeIDs = {}
	local tribute =  {}
	tribute.playerId = 8
	tribute.text = " "
	tribute.cost = { Gold = 0 }
	for player = 1, 5 do
		tribute.Callback = AddMainquestForPlayer(player)
		TributeIDs[player] = AddTribute(tribute)
		tribute.Tribute = nil
	end
end
function TributeForMainquest()
	for player = 1, 5 do
		GUI.PayTribute(8, TributeIDs[player])
	end
end
function AddMainquestForPlayer(_player)
	Logic.AddQuest(_player,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt alle Feinde! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
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
	Tribut1()
	Tribut2()
	Tribut3()
end
function Tribut1()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:30,250,30 <<Kooperation/Leicht>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut2()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:0,250,200 <<Kooperation/Normal>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut3()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:250,30,30 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function VictoryJob()
	if IsDead("P6HQ")and IsDead("P7HQ") and IsDead("P8HQ")then
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(6,7,8), CEntityIterator.OfCategoryFilter(EntityCategories.Soldier)) do
			return false
		end
		Victory()
		return true
	end
end
function StartTechnologies()
	for i = 1, 5 do
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
        text	= "@color:230,0,0 Leider gibt es kaum Zeit, um sich hier zu entspannen. Die Nachbarstädte stehen unter Kontrolle von Varg und Mary und haben es auf Eure Ressourcen abgesehen."
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
        title	= "@color:230,120,0 Hinweise und Tipps",
        text	= "@color:230,0,0 Unterstützt Euch gegenseitig so gut es geht. Tauscht Ressourcen untereinander aus! Nicht jeder Spieler verfügt über alle Ressourcentypen!"
    }
	AP{
        title	= "@color:230,120,0 Hinweise und Tipps",
        text	= "@color:230,0,0 Pilgrims Sprengfähigkeit kann Euch zu einem schnelleren Sieg verhelfen, aber auch Euren Untergang besiegeln! Kundschaftet schmale Pfade. @cr So gelingt euch vielleicht ein Überraschungsangriff und ihr könnt Eure Freunde entlasten!"
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
	for i = 1,5 do

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
	for i = 1,5 do

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
	for i = 1,5 do
		ForbidTechnology(Technologies.B_PowerPlant, i)
		ForbidTechnology(Technologies.B_Weathermachine, i)
		ForbidTechnology(Technologies.T_ThiefSabotage, i)
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
	--
	StartCountdown((13+15*gvDiffLVL)*60,AngriffsErinnerung,false)
	StartCountdown((15+15*gvDiffLVL)*60,FelsWeg,true)
	StartCountdown((10+30*gvDiffLVL)*60,NV,false)
	StartCountdown((70*gvDiffLVL-30)*60,NV2,false)
	StartCountdown((120*gvDiffLVL)*60,SurpriseSurprise,false)
	--
	StartSimpleJob("VictoryJob")

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	for i = 1,5 do
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

	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_RockDestroyableMedium1)) do
		MakeInvulnerable(eID)
	end

	Mission_InitLocalResources()

end
function FelsWeg()
	DestroyEntity("Rock1")
	DestroyEntity("Rock2")
	DestroyEntity("Rock3")
	DestroyEntity("Rock4")
	DestroyEntity("Rock5")
	--
	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_RockDestroyableMedium1)) do
		MakeVulnerable(eID)
	end
	for i = 1,5 do
		AllowTechnology(Technologies.B_PowerPlant, i)
		AllowTechnology(Technologies.B_Weathermachine, i)
	end
	--
	StartCountdown((30*gvDiffLVL)*60,UpgradeAI1,false)
end
function UpgradeAI1()
	ResearchTechnology(Technologies.T_EvilArmor1, 7)
	ResearchTechnology(Technologies.T_EvilSpears1, 7)
	--
	ResearchTechnology(Technologies.T_PickAxe, 8)
	--
	StartCountdown((40*gvDiffLVL)*60,UpgradeAI2,false)
end
function UpgradeAI2()
	ResearchTechnology(Technologies.T_EvilArmor2, 7)
	ResearchTechnology(Technologies.T_EvilSpears2, 7)
	ResearchTechnology(Technologies.T_EvilFists, 7)
	ResearchTechnology(Technologies.T_EvilRange1, 7)
	--
	StartCountdown((50*gvDiffLVL)*60,UpgradeAI3,false)
end
function UpgradeAI3()
	Message("ACHTUNG!")
	Message("Die Gegner verfügen nun über wahrhaft mächtige Technologien!")
	ResearchTechnology(Technologies.T_EvilArmor3, 7)
	ResearchTechnology(Technologies.T_EvilArmor4, 7)
	ResearchTechnology(Technologies.T_EvilRange2, 7)
	ResearchTechnology(Technologies.T_EvilSpeed, 7)
	--
	for AI = 6, 8 do
		ResearchAllTechnologies(AI, false, false, false, false, true)
	end
end
function NV()
	CreateNVArmy1()
	CreateNVArmy2()
	CreateNVArmyDef1()
	CreateNVArmyDef2()
	--
	ConnectLeaderWithArmy(GetID("Kala"), ArmyTable[7][3])
end
function NV2()
	CreateNVArmy3()
	CreateNVArmy4()
end
function MiscArmies()
	CreateArmy5()
	CreateArmy7()
	--
	CreateArmyMary()
	CreateArmyVarg()
	--
	for i = 1,2 do
		CreateArmyMaryOutpost(i)
	end
end
function AngriffsErinnerung()
	Message("Die Vorbereitungszeit ist fast vorbei!")
	Message("Weitere Feinde werden Euch schon bald angreifen!")
	Sound.PlayGUISound(Sounds.VoicesMentor_VC_OnlySomeMinutesLeft_rnd_01, 120)
	MapEditor_SetupAI(6, round(3/gvDiffLVL), Logic.WorldGetSize(), round(3.4/(math.sqrt(gvDiffLVL))), "P6", 3, 0)
	MapEditor_SetupAI(8, 3, Logic.WorldGetSize(), 3, "P8HQ", 3, 0)
	MapEditor_Armies[8].defensiveArmies.strength = round(25/gvDiffLVL)
	MapEditor_Armies[8].defensiveArmies.baseDefenseRange = 7500 - 500 * gvDiffLVL
	--
	for AI = 6, 8 do
		ResearchAllTechnologies(AI, false, false, false, true, false)
	end
	--
	MiscArmies()
	--
	SetHumanPlayerDiplomacyToAllAIs({1,2,3,4,5}, Diplomacy.Hostile)
end
function CreateNVArmy1()

	army1	 = {}

	army1.player 		= 7
	army1.id			= 1
	army1.strength		= round(15 - 3 * gvDiffLVL)
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
	army2.strength		= round(14 - 3 * gvDiffLVL)
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


    if IsDead(army1) and IsExisting("P7HQ") then

        CreateNVArmy1()
        return true

    else

       Defend(army1)

    end

end

function ControlArmy2()

	if IsDead(army2) and IsExisting("P7HQ") then

		CreateNVArmy2()
		return true
	else

		Defend(army2)

	end

end
function CreateNVArmy3()

	army3	 = {}

	army3.player 		= 7
	army3.id			= 3
	army3.strength		= round(18 - 4 * gvDiffLVL)
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
	army4.strength		= round(16 - 4 * gvDiffLVL)
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

    if IsDead(army3) and IsExisting("P7HQ") then
        CreateNVArmy3()
        return true
    else
       Defend(army3)

    end

end

function ControlArmy4()

	if IsDead(army4) and IsExisting("P7HQ") then
		CreateNVArmy4()
		return true
	else
		Defend(army4)
	end

end
function CreateNVArmyDef1()

	local army	 = {}

	army.player 	= 7
	army.id			= 0
	army.strength	= round(11 - 2 * gvDiffLVL)
	army.position	= GetPosition("NVDef_Spawn")
	army.rodeLength	= 4200

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderBearman1
	}
	for i = 1, army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlNVArmyDef1", 1, {}, {army.id})

end
function CreateNVArmyDef2()

	local army	 = {}

	army.player 	= 7
	army.id			= 5
	army.strength	= round(9 - 2 * gvDiffLVL)
	army.position	= GetPosition("NVDef_Spawn")
	army.rodeLength	= 4200

	SetupArmy(army)

	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_Evil_LeaderSkirmisher1
	}
	for i = 1, army.strength do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlNVArmyDef2", 1, {}, {army.id})

end
function ControlNVArmyDef1(_armyID)

	local army = ArmyTable[7][_armyID+1]
    if IsDead(army) and IsExisting("NVDef") then
        CreateNVArmyDef1()
        return true
    else
		Defend(army)
    end

end
function ControlNVArmyDef2(_armyID)

	local army = ArmyTable[7][_armyID+1]
    if IsDead(army) and IsExisting("NVDef") then
        CreateNVArmyDef2()
        return true
    else
		Defend(army)
    end

end
-- some juicy extra
function SurpriseSurprise()
	Stream.Start("Sounds\\AOVoicesHero12\\HERO12_FunnyComment_rnd_01.wav", 200)
	local army	 = {}
	army.player 	= 7
	army.id			= 10
	army.strength	= round(25 - 5 * gvDiffLVL)
	army.position	= GetPosition("cave_p2")
	army.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army)

	local nvtypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSpearman1, Entities.CU_Evil_LeaderSkirmisher1}
	local troopDescription = {
		experiencePoints = HIGH_EXPERIENCE
	}
	for i = 1, army.strength do
		troopDescription.leaderType = nvtypes[math.random(1, table.getn(nvtypes))]
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlSurprise", 1, {}, {army.id})
end
function ControlSurprise(_armyID)
	local army = ArmyTable[7][_armyID+1]
	if IsDead(army) then
		StartCountdown(45*gvDiffLVL*60, SurpriseSurprise, false)
		return true
	else
		Defend(army)
	end
end
-- non-nv armies
function CreateArmy5()
	army5	 = {}

	army5.player 		= 6
	army5.id			= 5
	army5.strength		= round(12 - 3 * gvDiffLVL)
	army5.position		= GetPosition("P6HQ")
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

    if IsVeryWeak(army5) and IsExisting("P6HQ") then
		if Counter.Tick2("Army5RespawnCounter", 45*gvDiffLVL) then
			CreateArmy6()
			return true
		end
    end
	Defend(army5)

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

    if IsVeryWeak(army6) and IsExisting("P6HQ") then
		if Counter.Tick2("Army6RespawnCounter", 45*gvDiffLVL) then
			CreateArmy5()
			return true
		end
    end
	Defend(army6)

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

	if IsVeryWeak(army7) and IsExisting("P8HQ") then
		if Counter.Tick2("Army7RespawnCounter", 45*gvDiffLVL) then
			CreateArmy8()
			return true
		end
    end
	Defend(army7)

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

    if IsVeryWeak(army8) and IsExisting("P8HQ") then
		if Counter.Tick2("Army8RespawnCounter", 45*gvDiffLVL) then
			CreateArmy7()
			return true
		end
	end
	Defend(army8)

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
		if Counter.Tick2("ControlArmyCounter_8_" .. _armyID, 90*gvDiffLVL) then
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
		if Counter.Tick2("ControlArmyCounter_6_" .. _armyID, 90*gvDiffLVL) then
			CreateArmyVarg()
			return true
		end
    end
	Defend(army)

end
ArmyOutpostTroopTypes = {Entities.CU_BanditLeaderSword1, Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderMace1, Entities.CU_BlackKnight_LeaderSword3, Entities.PU_LeaderBow3, Entities.PU_LeaderSword3, Entities.PV_Cannon2}
function CreateArmyMaryOutpost(_index)

	local army	 = {}

	army.player 	= 8
	army.id			= 0 + _index
	army.strength	= round(16 - 4 * gvDiffLVL)
	army.position	= GetPosition("P8_Spawn" .. _index)
	army.rodeLength	= 10000

	SetupArmy(army)

	local troopDescription = {
		experiencePoints = HIGH_EXPERIENCE
	}
	for i = 1, army.strength do
		troopDescription.leaderType = ArmyOutpostTroopTypes[math.random(1, table.getn(ArmyOutpostTroopTypes))]
		EnlargeArmy(army,troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmyMaryOutpost", 1, {}, {army.id, _index})
end
function ControlArmyMaryOutpost(_armyID, _index)

	local army = ArmyTable[8][_armyID+1]
	if IsVeryWeak(army) and IsExisting("P8_Tower" .. _index) then
		if Counter.Tick2("ControlArmyCounter_8_" .. _armyID, 30*gvDiffLVL) then
			CreateArmyMaryOutpost(_index)
			return true
		end
    end
	Defend(army)

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
	Display.SetPlayerColorMapping(9,NPC_COLOR)
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
end 