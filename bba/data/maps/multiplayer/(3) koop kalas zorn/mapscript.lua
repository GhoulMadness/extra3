--------------------------------------------------------------------------------
-- MapName: (3) Kalas Zorn
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
AttackTarget = {X = 37300,
				Y = 35500}
gvMapText = ""..
		"@color:0,0,0,0 ................ @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (3) Kalas Zorn "
gvMapVersion = " v1.6 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(6,1,1,0)

	Mission_InitGroups()
	Mission_InitLocalResources()

	if CNetwork then
		MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	else
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		Logic.ChangeAllEntitiesPlayerID(3, 1)
	end

	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end
	for i = 4,8 do
		Display.SetPlayerColorMapping(i,3)
		AI.Player_EnableAi(i)
	end
	SetPlayerName(4,"Sepsiskrallen-Stamm")
	SetPlayerName(5,"Stinkefuß-Stamm")
	SetPlayerName(6,"Speerstangen-Tänzer-Stamm")

	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(7,TributeForMainquest,false)
	StartCountdown(8,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)

	LocalMusic.UseSet = DARKMOORMUSIC

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,3,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	gvDiffLVL = 0
	P1HQPos = GetPosition("P1HQ")
	P2HQPos = GetPosition("P2HQ")
	P3HQPos = GetPosition("P3HQ")
end
function Mission_InitLocalResources()

	-- Initial Resources
	local InitGoldRaw 		= 1000000
	local InitClayRaw 		= 1000000
	local InitWoodRaw 		= 1000000
	local InitStoneRaw 		= 1000000
	local InitIronRaw 		= 1000000
	local InitSulfurRaw		= 1000000


	--Add Players Resources
	for i = 4,8 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
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
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Erwehrt Euch gegen alle Angriffswellen und besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Erwehrt Euch gegen alle Angriffswellen und besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer3() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Erwehrt Euch gegen alle Angriffswellen und besiegt Kala! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
	local r = Logic.GetRandom(4)+1
	Stream.Start("Voice\\cm01_06_cleycourt_txt\\leonardoangry"..r..".mp3",190)
end
function Schwierigkeitsgradbestimmer()
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos,130)
	Tribut6()
	Tribut7()
	Tribut8()
	Tribut9()
end
function Tribut6()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:0,120,100 <<Kooperation/Leicht>>! "
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
	TrMod2.text = "Spielmodus @color:150,20,60 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function Tribut9()
	local TrMod3 =  {}
	TrMod3.playerId = 1
	TrMod3.text = "Spielmodus @color:250,20,60 <<Kooperation/Irrsinnig>>! "
	TrMod3.cost = { Gold = 0 }
	TrMod3.Callback = SpielmodKoop3
	TMod3 = AddTribute(TrMod3)
end
--

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
        text	= "@color:230,0,0 Sie und ihre Truppen verbreiten überall wo sie vorbeikommen, grosses Elend! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Viel Erfolg beim Besiegen von Kala und ihren Truppen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }
    StartBriefing(briefing)
end

function SpielmodKoop0()
	Message("Ihr habt den @color:0,250,200 <<LEICHTEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(35*60,Vorb, true)

	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,130)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
	--
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 1200
	local InitClayRaw 		= 1800
	local InitWoodRaw 		= 1800
	local InitStoneRaw 		= 1400
	local InitIronRaw 		= 500
	local InitSulfurRaw		= 500


	--Add Players Resources
	for i = 1,3 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 2.1
	StartSimpleJob("SJ_Defeat")
	StartSimpleJob("SJ_Victory")
	StartInitialize()
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(30*60,Vorb, true)
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,130)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
	--
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 900
	local InitClayRaw 		= 1600
	local InitWoodRaw 		= 1600
	local InitStoneRaw 		= 1200
	local InitIronRaw 		= 350
	local InitSulfurRaw		= 350


	--Add Players Resources
	for i = 1,3 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 1.8
	StartSimpleJob("SJ_Defeat")
	StartSimpleJob("SJ_Victory")
	StartInitialize()
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(25*60,Vorb, true)

	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,130)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
	--
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 800
	local InitClayRaw 		= 1400
	local InitWoodRaw 		= 1400
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 150
	local InitSulfurRaw		= 150
	--Add Players Resources
	for i = 1,3 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 1.5
	StartSimpleJob("SJ_Defeat")
	StartSimpleJob("SJ_Victory")
	StartInitialize()
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop3()
	Message("Ihr habt den @color:0,250,200 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(15*60,Vorb, true)

	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,130)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(3,2)
	--
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 900
	local InitIronRaw 		= 50
	local InitSulfurRaw		= 50
	--Add Players Resources
	for i = 1,3 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 1.1
	StartSimpleJob("SJ_Defeat")
	StartInitialize()
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:250,10,10 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function StartInitialize()
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
function SJ_Defeat()
	if IsDead("P1HQ") and not repos1 then
		P1HQPos = GetPosition("P2HQ")
		repos1 = true
	elseif IsDead("P2HQ") and not repos2 then
		P2HQPos = GetPosition("P3HQ")
		repos2 = true
	elseif IsDead("P3HQ") and not repos3 then
		P3HQPos = GetPosition("P1HQ")
		repos3 = true
	end
	if IsDead("P1HQ") and IsDead("P2HQ") and IsDead("P3HQ") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.PlayerSetGameStateToLost(3)
		return true
	end
end
function SJ_Victory()
	if IsDead("HQP4") and IsDead("HQP5") and IsDead("HQP6") and IsDead("HQP7") and IsDead("HQP8") and IsDead("HQP9") and IsDead("HQP10") and IsDead("HQP11") and IsDead("HQP12") and IsDead("HQP13") and IsDead("HQP14") and IsDead("HQP15") and IsDead("HQP16") then
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		return true
	end
end
function Vorb()
	StartCountdown(3*gvDiffLVL,TroopSpawnVorb,false)
	StartCountdown(2*gvDiffLVL,AIStart,false)
	StartCountdown(math.floor(40*60*(gvDiffLVL^2)),NVUpgrade1,false)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_CliffGrey1)) do
		DestroyEntity(eID)
	end
	SetHumanPlayerDiplomacyToAllAIs()
	SetFriendly(1,2)
	SetFriendly(1,3)
	SetFriendly(2,3)
end

function AIStart()
	NumSpawns = {[4] = 3, [5] = 6, [6] = 4}
	Armies = {}
	for i = 4, 6 do
		Armies[i] = {}
		for k = 1, NumSpawns[i] do
			Armies[i][k] = {}
			Armies[i][k].player = i
			Armies[i][k].id = k - 1
			Armies[i][k].position = GetPosition("SpawnP" .. i .. "_" ..k)
			Armies[i][k].strength = 99
			Armies[i][k].rodeLength = Logic.WorldGetSize()
			--
			SetupArmy(Armies[i][k])
			--
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmy",1,{},{i, k - 1})
		end
	end
	StartCountdown((3*60*60/gvDiffLVL), Sieg, true)
end
function ControlArmy(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if not IsDead(army) then
		Defend(army)
	end
end
function Sieg()
	for i = 1,3 do
		Logic.PlayerSetGameStateToWon(i)
	end
end

function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.min(math.floor(2.0+(math.random(1,5)/10)*60*gvDiffLVL*(1+(Logic.GetTime()/40))),6*60/math.sqrt(gvDiffLVL))
	if (AI.Player_GetNumberOfLeaders(4)	+ AI.Player_GetNumberOfLeaders(5) + AI.Player_GetNumberOfLeaders(6)) <= (150/gvDiffLVL) then
		TroopSpawn(TimePassed)
		SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
	else
		SpawnCounter = StartCountdown(TimeNeeded/2,TroopSpawnVorb,false)
	end
end

function TroopSpawn(_TimePassed)
	Message("Weitere Nebelkrieger greifen bald an!")
	if _TimePassed <= 5 then
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
			end
		end

	elseif _TimePassed > 5 and _TimePassed <= 14 then
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
			end
		end

	elseif _TimePassed > 14 and _TimePassed <= 32 then
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
			end
		end

	elseif _TimePassed > 32 and _TimePassed <= 52 then
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
			end
		end

	elseif _TimePassed > 52 and _TimePassed <= 70 then
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
			end
		end

	else
		for i = 4, 6 do
			for k = 1, NumSpawns[i] do
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderBearman1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
				EnlargeArmy(ArmyTable[i][k], {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
			end
		end
	end
end
function AIIdleScan()
	if Counter.Tick2("IdleScan_Ticker",10) then
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(4), CEntityIterator.OfCategoryFilter(EntityCategories.Leader)) do
			if Logic.GetCurrentTaskList(eID) == "TL_MILITARY_IDLE" then
				Logic.GroupAttackMove(eID, P1HQPos.X, P1HQPos.Y)
			end
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(5), CEntityIterator.OfCategoryFilter(EntityCategories.Leader)) do
			if Logic.GetCurrentTaskList(eID) == "TL_MILITARY_IDLE" then
				Logic.GroupAttackMove(eID, P2HQPos.X, P2HQPos.Y)
			end
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(6), CEntityIterator.OfCategoryFilter(EntityCategories.Leader)) do
			if Logic.GetCurrentTaskList(eID) == "TL_MILITARY_IDLE" then
				Logic.GroupAttackMove(eID, P3HQPos.X, P3HQPos.Y)
			end
		end
	end
end
function NVUpgrade1()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_EvilArmor1,i)
		ResearchTechnology(Technologies.T_EvilSpears1,i)
	end
	StartCountdown((25*60*(gvDiffLVL^2)),NVUpgrade2,false)
end
function NVUpgrade2()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_EvilArmor2,i)
		ResearchTechnology(Technologies.T_EvilSpears2,i)
		ResearchTechnology(Technologies.T_EvilRange1,i)
	end
	StartCountdown((22*60*(gvDiffLVL^2)),NVUpgrade3,false)
end
function NVUpgrade3()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_EvilArmor3,i)
		ResearchTechnology(Technologies.T_EvilRange2,i)
		ResearchTechnology(Technologies.T_EvilSpeed,i)
	end
	StartCountdown((20*60*(gvDiffLVL^2)),NVUpgrade4,false)
end
function NVUpgrade4()
	for i = 4,8 do
		ResearchTechnology(Technologies.T_EvilArmor4,i)
		ResearchTechnology(Technologies.T_EvilFists,i)
	end
end
function Mission_InitGroups()
	InitPlayerColorMapping()
end
function Mission_InitTechnologies()
end

function InitPlayerColorMapping()
	for i = 4,8 do
	   Display.SetPlayerColorMapping(i,3)
	end

end