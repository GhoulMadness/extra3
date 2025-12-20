if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Die Smaragdebene "
gvMapVersion = " v1.4"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,0,0,0,1)

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
	for i = 1,8 do
		CreateWoodPile("Holz"..i,10000000)
	end

	LocalMusic.UseSet = MEDITERANEANMUSIC
	for i = 1, 4 do Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i)); end;
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		Logic.ChangeAllEntitiesPlayerID(3, 1)
		Logic.ChangeAllEntitiesPlayerID(4, 1)
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
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer3() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer4() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Kerberos! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
end
function Schwierigkeitsgradbestimmer()
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos,120)
	Tribut6()
	Tribut7()
	Tribut8()
	Tribut9()
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:30,220,30 <<Kooperation/Leicht>>! "
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
	TrMod2.text = "Spielmodus @color:200,80,90 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function Tribut9()
	local TrMod3 =  {}
	TrMod3.playerId = 1
	TrMod3.text = "Spielmodus @color:250,0,0 <<Kooperation/Irrsinnig>>! "
	TrMod3.cost = { Gold = 0 }
	TrMod3.Callback = SpielmodKoop3
	TMod3 = AddTribute(TrMod3)
end
--
function VictoryJob()
	if IsDead("HQP5") and IsDead("HQP6") and IsDead("HQP7") and IsDead("HQP8") and IsDead("EnemyMainHQ") then
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		Logic.PlayerSetGameStateToWon(4)
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
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Die Hauptstadt der Smaragdebene...hier würde die endgültige Entscheidung über Sieg oder Niederlage fallen."
    }
	AP{
        title	= "@color:230,120,0 Erzähler",
        text	= "@color:230,0,0 Die Stadt war eine schwer einzunehmende Festung. Doch Hoffnung nahte: Ari, Drake und Erec bezogen Stellung, um den Barbaren gemeinsam entgegenzutreten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Wir haben uns für den entscheidenden Moment versammelt. Hier wird sich unser aller Schicksal entscheiden."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Wir müssen die Festung erobern, oben auf dem Plateau, wo Scorillo sich verschanzt hat."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Das wird kein Spaziergang, aber wir werden uns bewähren!"
    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Um die Smaragdebene zurückzuerobern, müssen wir die Hauptstadt Stück für Stück wieder unter unsere Kontrolle bringen. Die Festung ist unser Ziel."
    }


    StartBriefing(briefing)
end
function SpielmodKoop0()
	Message("Ihr habt den @color:30,220,30 <<LEICHTEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 3
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	gvTechLVL = 1
	--
	StartInitialize()
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 2
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	gvTechLVL = 2
	--
	StartInitialize()
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop2()
	Message("Ihr habt den @color:200,80,90 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 1
	StartCountdown(60*60,ExtraTruppen, false)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod3)
	--
	gvTechLVL = 3
	--
	StartInitialize()
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop3()
	Message("Ihr habt den @color:250,0,0 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	gvDiffLVL = 0.7
	StartCountdown(30*60,ExtraTruppen, false)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	gvTechLVL = 3
	--
	StartInitialize()
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function StartInitialize()
	AttackVorb = StartCountdown((20+10*gvDiffLVL)*60,Vorbereitung,true)
	StartCountdown((15+10*gvDiffLVL)*60,AIStart,false)
	StartCountdown((30+20*gvDiffLVL)*60,UpgradeKI,false)

	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( round(gvDiffLVL) )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= round(500*gvDiffLVL)
	local InitClayRaw 		= 600 + round(300*gvDiffLVL)
	local InitWoodRaw 		= 600 + round(300*gvDiffLVL)
	local InitStoneRaw 		= 300 + round(300*gvDiffLVL)
	local InitIronRaw 		= 150*gvDiffLVL
	local InitSulfurRaw		= 150*gvDiffLVL


	--Add Players Resources
	for i = 1,4 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end
function AIStart()
	for i = 5,8 do
		MapEditor_SetupAI(i,3,Logic.WorldGetSize(),gvTechLVL,"P"..i,3,0) SetupPlayerAi( i, {constructing = false, extracting = 0, repairing = true, serfLimit = 12} )
		MapEditor_Armies[i].offensiveArmies.strength = 10 + round(20/gvDiffLVL)
	end
end
function Vorbereitung()
	for i = 1,4 do
		ReplaceEntity("gate"..i,Entities.XD_WallStraightGate)
		DestroyEntity("barrier"..i)
		AllowTechnology(Technologies.T_MakeSnow,i)
	end
end
function ExtraTruppen()
	CreateKerbArmy5()
	CreateKerbArmy3()
	CreateKerbArmy1()
end
function CreateKerbArmy5()
	army5	 = {}
	army5.player 		= 8
	army5.id			= 5
	army5.strength		= 6
	army5.position		= GetPosition("ExtraSpawn")
	army5.rodeLength	= Logic.WorldGetSize()
	SetupArmy(army5)
	local troopDescription = {
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderHeavyCavalry2
	}
	for i = 1,army5.strength do
		EnlargeArmy(army5,troopDescription)
	end
	StartSimpleJob("ControlArmy5")
end
function CreateKerbArmyFive()
	armyFive	 = {}

	armyFive.player 		= 8
	armyFive.id				= 6
	armyFive.strength		= 4
	armyFive.position		= GetPosition("ExtraSpawn")
	armyFive.rodeLength		= Logic.WorldGetSize

	SetupArmy(armyFive)

	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.PU_LeaderPoleArm4
	}
	for i = 1,armyFive.strength do
		EnlargeArmy(armyFive,troopDescription)
	end

	StartSimpleJob("ControlArmyFive")

end
function ControlArmy5()


    if IsDead(army5) and IsExisting("HQP5") then

        CreateKerbArmyFive()

        return true

    else

		Defend(army5)

    end

end

function ControlArmyFive()

	if IsDead(armyFive) and IsExisting("HQP5") then

		CreateKerbArmy5()
		return true
	else

		Defend(armyFive)

	end

end

function CreateKerbArmy1()

	army1	 = {}

	army1.player 		= 8
	army1.id			= 1
	army1.strength		= 6
	army1.position		= GetPosition("ExtraSpawn")
	army1.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army1)


	local troopDescription = {

		maxNumberOfSoldiers	= 12,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType          = Entities.PU_LeaderSword4
	}
	for i = 1,army1.strength do
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

	for i = 1,armyTwo.strength do
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
function CreateKerbArmy3()

	army3	 = {}

	army3.player 		= 8
	army3.id			= 3
	army3.strength		= 6
	army3.position		= GetPosition("ExtraSpawn")
	army3.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army3)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         	= Entities.CU_Barbarian_LeaderClub2
	}
	for i = 1,army3.strength do
	EnlargeArmy(army3,troopDescription)

	end


	StartSimpleJob("ControlArmy3")

end

function CreateKerbArmy4()

	army4	 = {}

	army4.player 		= 8
	army4.id			= 4
	army4.strength		= 6
	army4.position		= GetPosition("ExtraSpawn")
	army4.rodeLength	= Logic.WorldGetSize()

	SetupArmy(army4)

	local troopDescription = {

		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_VeteranLieutenant
	}

	for i = 1,army4.strength do
		EnlargeArmy(army4,troopDescription)
	end
	StartSimpleJob("ControlArmy4")

end
function ControlArmy3()

    if IsDead(army3) and IsExisting("HQP5") then

        CreateKerbArmy4()


        return true

    else

        Defend(army3)

    end

end

function ControlArmy4()
	if IsDead(army4) and IsExisting("HQP5") then
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
	for i = 1,4 do
		ForbidTechnology(Technologies.T_MakeSnow,i)
		ForbidTechnology(Technologies.T_ThiefSabotage,i)
	end
end
function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
	StartCountdown(15,KerbVoice,false)
end
function InitDiplomacy()
  	SetPlayerName(8,"Scorillos Truppen")
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
		Display.SetPlayerColorMapping(i,2)
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
	StartCountdown(120*60*gvDiffLVL,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 5,8 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
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
function Sound1() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_01,120) end
function Sound2() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_01,120) end
function Sound3() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_01,120) end
function Sound4() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_02,120) end
function Sound5() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Madness_rnd_02,120) end
function Sound6() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_InflictFear_rnd_03,120) end
function Sound7() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_FunnyComment_rnd_01,120) end
function Sound8() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_05,120) StartCountdown(4*60,KerbVoice,false) end
function UpgradeBuilding(_EntityName) local EntityID = GetEntityId(_EntityName) if IsValid(EntityID) then local EntityType = Logic.GetEntityType(EntityID) local PlayerID = GetPlayer(EntityID) local Costs = {} Logic.FillBuildingUpgradeCostsTable(EntityType, Costs) for Resource, Amount in Costs do Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)  end GUI.UpgradeSingleBuilding(EntityID)  end end
function AddPages( _briefing )  local AP = function(_page) table.insert(_briefing, _page); return _page; end local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end return AP, ASP; end
function CreateShortPage( _entity, _title, _text, _dialog, _explore)  local page = { title = _title, text = _text,  position = GetPosition( _entity ), action = function ()Display.SetRenderFogOfWar(0) end };
if _dialog then if type(_dialog) == "boolean" then page.dialogCamera = true; elseif type(_dialog) == "number" then page.explore = _dialog; end end
if _explore then if type(_explore) == "boolean" then page.dialogCamera = true; elseif type(_explore) == "number" then page.explore = _explore; end end   return page; end
function SetAIUnitsToBuild( _aiID, ... ) for i = table.getn(DataTable), 1, -1 do if DataTable[i].player == _aiID and DataTable[i].AllowedTypes then  DataTable[i].AllowedTypes = arg; end end end
 