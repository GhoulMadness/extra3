--------------------------------------------------------------------------------
-- MapName: (5) Der gro�e Aufstand
--
-- Author: ??? (Edited by Ghoul)
--
--------------------------------------------------------------------------------

if XNetwork then
    XNetwork.GameInformation_GetLogicPlayerTeam = function() return 1 end
    XNetwork.GameInformation_GetFreeAlliancesFlag = function() return 1 end
end
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10 Men� @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (5) Der gro�e Aufstand "
gvMapVersion = " v1.6"
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	-- custom Map Stuff

	TagNachtZyklus(24,1,1,0)

	Mission_InitGroups()
	Mission_InitLocalResources()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	if CNetwork then
		gvTeam1Table = {1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5}
		gvTeam2Table = {6,7,8,9,10,6,7,8,9,10,6,7,8,9,10,6,7,8,9,10,6,7,8,9,10}
		for i = 1,25 do
			SetHostile(gvTeam1Table[i],gvTeam2Table[i])
		end
		for i = 9,10 do
			ChangePlayer("HQP"..i,i)
		end
	end
	for i = 1,5 do
		CreateWoodPile("Holz"..i,10000000)
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(7,TributeForMainquest,false)
	StartCountdown(8,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)


	LocalMusic.UseSet = DARKMOORMUSIC

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,5,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		Logic.ChangeAllEntitiesPlayerID(2,1)
		Logic.ChangeAllEntitiesPlayerID(3,1)
		Logic.ChangeAllEntitiesPlayerID(4,1)
		Logic.ChangeAllEntitiesPlayerID(5,1)
		ChangePlayer("HQP9",4)
		ChangePlayer("HQP10",5)
		for i = 4,8 do
			SetHostile(1,i)
			SetHostile(i,1)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	gvDiffLVL = 0

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
	local tribute5 =  {}
	tribute5.playerId = 8
	tribute5.text = " "
	tribute5.cost = { Gold = 0 }
	tribute5.Callback = AddMainquestForPlayer5
	TributMainquestP5 = AddTribute(tribute5)
end
function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
	GUI.PayTribute(8,TributMainquestP3)
	GUI.PayTribute(8,TributMainquestP4)
	GUI.PayTribute(8,TributMainquestP5)
end
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer3() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer4() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer5() Logic.AddQuest(3,3,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus f\195\188r diese Runde!")
	Schwierigkeitsgradbestimmer()
	return true
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus f\195\188r diese Runde, damit das Spiel endlich starten kann!")
	local r = Logic.GetRandom(4)+1
	Stream.Start("Voice\\cm01_06_cleycourt_txt\\leonardoangry"..r..".mp3",120)
	return true
end
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
	TrMod0.text = "Spielmodus @color:30,220,30 <<Kooperation/Normal>>! "
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
--
function VictoryJob()
	if IsDead("HQP7") and IsDead("HQP8") and IsDead("HQP9") and IsDead("HQP10") and IsDead("HQP11") and IsDead("HQP12") and IsDead("HQP13") and IsDead("HQP14") and IsDead("HQP15") and IsDead("HQP16")then
	Stream.Start("Voice\\cm01_08_barmecia_txt\\notevictory.mp3",120)
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		Logic.PlayerSetGameStateToWon(4)
		Logic.PlayerSetGameStateToWon(5)
		return true
	end
end

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Herr...grosses Unheil! @cr Unsere D\195\182rfer werden von Lord Danaths Truppen...."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Die Unterdr\195\188ckung der D\195\182rfer in dieser Region muss ein Ende haben. @cr Eines der D\195\182rfer wird wiederholt angegriffen. @cr Ihr m\195\188sst die Angreifer zur\195\188ckschlagen und das Dorf retten."
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Die D\195\182rfer haben sich vereint, um gemeinsam bestehen zu k\195\182nnen!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Ich habe aber auch schlechte Neuigkeiten. @cr Der Feind hat von unserem Zusammenschluss geh\195\182rt und schickt eine grosse Armee gegen uns! @cr Die Hauptarmee bewegt sich nur langsam auf uns zu, aber einige Truppen sind vorausgeeilt und haben drei Lager errichtet!"
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Eilt euch, es wird sicher nicht lange dauern, bis die Truppen Eure Siedlungen erreicht haben!"
    }
	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!"
    }


    StartBriefing(briefing)
end
function SpielmodKoop0()
	Message("Ihr habt den @color:30,220,30 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(1*60,Vorb, false)

	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	if CNetwork then
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(1,4)
		SetFriendly(1,5)
		SetFriendly(2,3)
		SetFriendly(2,4)
		SetFriendly(2,5)
		SetFriendly(3,4)
		SetFriendly(3,5)
		SetFriendly(4,5)
	end
	--
	for i = 1,5 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.GT_Construction, i)
		ResearchTechnology(Technologies.B_Archery, i)
		ResearchTechnology(Technologies.B_Foundry, i)
		ResearchTechnology(Technologies.B_Stables, i)
		--
	end
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 1500
	local InitClayRaw 		= 2200
	local InitWoodRaw 		= 2200
	local InitStoneRaw 		= 1600
	local InitIronRaw 		= 550
	local InitSulfurRaw		= 550


	--Add Players Resources
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 3.2
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(1*60,Vorb, false)

	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	if CNetwork then
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(1,4)
		SetFriendly(1,5)
		SetFriendly(2,3)
		SetFriendly(2,4)
		SetFriendly(2,5)
		SetFriendly(3,4)
		SetFriendly(3,5)
		SetFriendly(4,5)
	end
	--
	for i = 1,5 do
		ResearchTechnology(Technologies.GT_Mercenaries, i)
		ResearchTechnology(Technologies.B_Archery, i)
		--
	end
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
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 2.6
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function SpielmodKoop2()
	Message("Ihr habt den @color:0,250,200 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gew\195\164hlt")
	StartCountdown(1*60,Vorb, false)
	StartSimpleJob("VictoryJob")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	if CNetwork then
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(1,4)
		SetFriendly(1,5)
		SetFriendly(2,3)
		SetFriendly(2,4)
		SetFriendly(2,5)
		SetFriendly(3,4)
		SetFriendly(3,5)
		SetFriendly(4,5)
	end
	--
	--
	StopCountdown(Erinnerung)

	-- Initial Resources
	local InitGoldRaw 		= 700
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1200
	local InitStoneRaw 		= 900
	local InitIronRaw 		= 50
	local InitSulfurRaw		= 50
	--Add Players Resources
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 1.8
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
end
function Vorb()
	StartCountdown(10*60*gvDiffLVL,TroopSpawnVorb,true)
	StartCountdown(9*60*gvDiffLVL,AIStart,false)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
PlayerToSpawnPos = {[6] = "SpawnBase3", [7] = "SpawnBase2", [8] = "SpawnBase1"}
PlayerToSpawnBuilding = {[6] = "HQP11", [7] = "HQP7", [8] = "HQP8"}
function AIStart()
	armies = {}
	for i = 6, 8 do
		armies[i] = {}
		armies[i].building = GetID(PlayerToSpawnBuilding[i])
		armies[i].player = i
		armies[i].id	= GetFirstFreeArmySlot(i)
		armies[i].position = GetPosition(PlayerToSpawnBuilding[i])
		armies[i].strength = 99
		armies[i].rodeLength	= Logic.WorldGetSize()
		SetupArmy(armies[i])
		--
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmy", 1, nil, {i})
		--
		-- defense armies
		CreateDefArmy(i)
	end
	--
	for i = 1,3 do
		DestroyEntity("barrier"..i)
	end
end
BarbArmyTypes = {Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2, Entities.CU_BlackKnight_LeaderMace2, Entities.CU_VeteranMajor}
function CreateDefArmy(_player)
	local army = {}
	army.building = GetID(PlayerToSpawnBuilding[_player])
	army.player = _player
	army.id = GetFirstFreeArmySlot(_player)
	army.position = GetPosition(PlayerToSpawnPos[_player])
	army.building = PlayerToSpawnBuilding[_player]
	army.strength = round(20/gvDiffLVL)
	army.rodeLength = 7500
	SetupArmy(army)
	for i = 1, table.getn(BarbArmyTypes) do
		EnlargeArmy(army, {leaderType = BarbArmyTypes[math.random(1, table.getn(BarbArmyTypes))]})
	end
	--
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlDefArmy", 1, nil, {army.player, army.id, army.building})
end
function ControlArmy(_player)
	if not IsDead(armies[_player]) then
		Defend(armies[_player])
	end
end
function ControlDefArmy(_player, _id, _building)
	local army = ArmyTable[_player][_id + 1]
	if IsVeryWeak(army) and not IsDestroyed(_building) then
		CreateDefArmy(_player)
		return true
	end
	Defend(army)
end
function TroopSpawnVorb()

	local troopNum
	troopNum = AI.Player_GetNumberOfLeaders(6) + AI.Player_GetNumberOfLeaders(7) + AI.Player_GetNumberOfLeaders(8)

	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	if troopNum	<= (200/gvDiffLVL) then
		TroopSpawn(TimePassed)
		StartCountdown(3*60*gvDiffLVL,TroopSpawnVorb,false)
	else
		StartCountdown(2*60*gvDiffLVL,TroopSpawnVorb,false)
	end
end

function TroopSpawn(_TimePassed)
	Message("Weitere Barbarentruppen versammeln sich!")

	for i = 6,8 do
		if IsExisting(armies[i].building) then
			if AI.Player_GetNumberOfLeaders(i) < 50/gvDiffLVL then
				for k = 1,3 do
					if _TimePassed <= 10 then
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})

					elseif _TimePassed > 10 and _TimePassed <= 18 then
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BanditLeaderBow1})

					elseif _TimePassed > 18 and _TimePassed <= 40 then
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BanditLeaderBow1})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BlackKnight_LeaderMace2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})

					elseif _TimePassed > 40 and _TimePassed <= 70 then
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BanditLeaderBow1})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BlackKnight_LeaderMace2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BlackKnight_LeaderMace2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})

					elseif _TimePassed > 70 then
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_Barbarian_LeaderClub2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_BlackKnight_LeaderMace2})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})
						EnlargeArmy(armies[i], {leaderType = Entities.CU_VeteranMajor})
					end
				end
			end
		end
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
	StartCountdown(15,Voice,false)
end
function InitDiplomacy()
  	SetPlayerName(8,"Lord Danaths Truppen")
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
	if CNetwork then
		for i = 6,10 do
		   Display.SetPlayerColorMapping(i,7)
		end
	else
		for i = 4,8 do
		   Display.SetPlayerColorMapping(i,7)
		   SetHostile(i,1)
		   SetHostile(1,i)
		end
	end

end
function Voice()
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
function Sound8() Sound.PlayGUISound(Sounds.VoicesHero7_HERO7_Attack_rnd_05,120) StartCountdown(4*60,Voice,false) end
function AddPages( _briefing )  local AP = function(_page) table.insert(_briefing, _page); return _page; end local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)); end return AP, ASP; end
function CreateShortPage( _entity, _title, _text, _dialog, _explore)  local page = { title = _title, text = _text,  position = GetPosition( _entity ), action = function ()Display.SetRenderFogOfWar(0) end };
if _dialog then if type(_dialog) == "boolean" then page.dialogCamera = true; elseif type(_dialog) == "number" then page.explore = _dialog; end end
if _explore then if type(_explore) == "boolean" then page.dialogCamera = true; elseif type(_explore) == "number" then page.explore = _explore; end end   return page; end
 