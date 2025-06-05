gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (4) Marys Intrige "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	for i = 1,8 do
		CreateWoodPile("Holz"..i,990000)
	end

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

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

	for i = 5,10 do
		Display.SetPlayerColorMapping(i,ROBBERS_COLOR)
	end

	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(1,4)
	SetFriendly(2,3)
	SetFriendly(2,4)
	SetFriendly(3,4)
	SetHostile(5,1)
	SetHostile(5,2)
	SetHostile(5,3)
	SetHostile(5,4)
	SetHostile(1,6)
	SetHostile(2,6)
	SetHostile(3,6)
	SetHostile(4,6)
	SetHostile(5,1)
	SetHostile(5,2)
	SetHostile(5,3)
	SetHostile(5,4)
	SetHostile(7,1)
	SetHostile(7,2)
	SetHostile(7,3)
	SetHostile(7,4)
	SetHostile(8,1)
	SetHostile(8,2)
	SetHostile(8,3)
	SetHostile(8,4)
	SetHostile(9,4)
	SetHostile(9,1)
	SetHostile(9,2)
	SetHostile(9,3)
	SetHostile(10,1)
	SetHostile(10,2)
	SetHostile(10,3)
	SetHostile(10,4)

	StartCountdown(1,AnfangsBriefing,false)
	StartSimpleJob("Sieg")

	LocalMusic.UseSet = MEDITERANEANMUSIC

	for i = 1,30 do
		ChangePlayer("P9_"..i,9)
	end
	ChangePlayer("P9HQ",9)
	ChangePlayer("P10HQ",10)
	for i = 1,50 do
		ChangePlayer("P10_"..i,10)
	end

	for i = 1,4 do
		ForbidTechnology(Technologies.T_MakeSnow, i)
		--
		ForbidTechnology(Technologies.T_ThiefSabotage, i)
		ResearchTechnology(Technologies.B_Barracks, i)
	end

end
function TributeP1_Easy()
	local TrP1_E =  {}
	TrP1_E.playerId = 1
	TrP1_E.text = "Klickt hier, um den @color:0,255,0 leichten @color:255,255,255 Spielmodus zu spielen"
	TrP1_E.cost = { Gold = 0 }
	TrP1_E.Callback = TributePaid_P1_Easy
	TP1_E = AddTribute(TrP1_E)
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
function TributePaid_P1_Easy()
	Message("Ihr habt euch für den @color:0,255,0 leichten @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
	gvDiffLVL = 2.0

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function TributePaid_P1_Normal()
	Message("Ihr habt euch für den @color:200,115,90 normalen @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_H)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	gvDiffLVL = 1.4

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function TributePaid_P1_Hard()
	Message("Ihr habt euch für den @color:200,60,60 schweren @color:255,255,255 Spielmodus entschieden! Gute Wahl!")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,100)
	--
	Logic.RemoveTribute(1,TP1_E)
	Logic.RemoveTribute(1,TP1_N)
	Logic.RemoveTribute(1,TP1_C)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	gvDiffLVL = 1.0

	--RecreateVillageCenters()
	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StartInitialize()
end
function StartInitialize()

	for i = 1,4 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	--
	for i=1,8,1 do
       Tools.GiveResouces(i, dekaround(1200*gvDiffLVL), dekaround(1000*gvDiffLVL), dekaround(1000*gvDiffLVL), dekaround(700*gvDiffLVL), 0, 0)
    end
	--
	CreateArmy1()
	MapEditor_SetupAI(6,1,10000,1,"P6",2,600)
	MapEditor_SetupAI(7,1,10000,0,"P7",2,600)
	MapEditor_SetupAI(8,1,15000,1,"P8",2,600)
	for i = 6,8 do
		MapEditor_Armies[i].offensiveArmies.strength = round(15/gvDiffLVL)
	end
	--
	StartCountdown(45*60*gvDiffLVL,UpgradeKIa,false)
	StartCountdown(40*60*gvDiffLVL,AIStart,false)
	StartCountdown(45*60*gvDiffLVL,PeaceTimeEnd,true)
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function UpgradeKIa()
	for i = 5,10 do
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

	ResearchTechnology(Technologies.T_SoftArcherArmor,i)
	ResearchTechnology(Technologies.T_LeatherMailArmor,i)

	StartCountdown(25*60*gvDiffLVL,UpgradeKIb,false)
	end
end
function UpgradeKIb()
	for i = 5,10 do
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
	ResearchAllTechnologies(i, false, false, false, true, false)
	end
end
function AIStart()
	if CNetwork then
		MapEditor_SetupAI(9,2,Logic.WorldGetSize(),3,"P9",3,0)
		MapEditor_SetupAI(10,2,Logic.WorldGetSize(),3,"P10",3,0)
		for i = 9,10 do
			MapEditor_Armies[i].offensiveArmies.strength = round(30/gvDiffLVL)
		end
	end
	MapEditor_SetupAI(5,3,Logic.WorldGetSize(),3,"P5",3,0)

end
function PeaceTimeEnd()

	StartWinter(60*60*60)
	for i=1,4 do
		AllowTechnology(Technologies.B_Bridge, i)
		ForbidTechnology(Technologies.T_MakeRain, i)
		ForbidTechnology(Technologies.T_MakeSummer, i)
		ForbidTechnology(Technologies.T_MakeThunderstorm, i)
    end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChanger", 1, {}, {})
end
function WeatherChanger()
	local newWeather = Event.GetNewWeatherState()
	if newWeather ~= 3 then
		StartWinter(60*60*60)
	end
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Willkommen in diesen mediterranen Gefilden."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Leider gibt es keine Zeit, um sich hier zu entspannen. Mary de Morfichet und ihre Schergen werden immer stärker und sind kaum noch aufzuhalten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Sie und ihre mordenden Truppen verbreiten überall wo sie vorbeikommen, großes Elend! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Viel Erfolg beim Besiegen von Mary und ihren Truppen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Eilt euch, Marys Schergen erreichen Euch bereich vor Einsetzen des Winters!"
    }
	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }


    StartBriefing(briefing)

end

function CreateArmy1()

	army1	 = {}

	army1.player 		= 6
	army1.id			= 1
	army1.strength		= 3
	army1.position		= GetPosition("P6army1")
	army1.rodeLength	= 6000

	SetupArmy(army1)

	local troopDescription = {

		maxNumberOfSoldiers	= 10,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderBow1
	}

	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)

	StartSimpleJob("ControlArmy1")

end

function CreateArmyTwo()

	armyTwo	 = {}

	armyTwo.player 		= 6
	armyTwo.id			= 2
	armyTwo.strength	= 2
	armyTwo.position	= GetPosition("P6army1")
	armyTwo.rodeLength	= 7000

	SetupArmy(armyTwo)


	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         = Entities.CU_BanditLeaderSword2
	}

	EnlargeArmy(armyTwo,troopDescription)
	EnlargeArmy(armyTwo,troopDescription)

	StartSimpleJob("ControlArmyTwo")

end
function ControlArmy1()

    if IsDead(army1) and IsExisting("P6Turm") then

        CreateArmyTwo()
        return true

    else
        Defend(army1)

    end

end

function ControlArmyTwo()

	if IsDead(armyTwo) and IsExisting("P6Turm") then

		CreateArmy1()
		return true
	else

		Defend(armyTwo)

	end

end
function Sieg()
	if IsDestroyed("P5HQ") and IsDestroyed("P6HQ") and IsDestroyed("P7HQ") and IsDestroyed("P8HQ") and IsDestroyed("P9HQ") and IsDestroyed("P10HQ") then
		Victory()
		return true
	end
end
function Mission_InitLocalResources()
	--Add Players Resources

end
function StartTechnologies()
	for i = 1,4 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end