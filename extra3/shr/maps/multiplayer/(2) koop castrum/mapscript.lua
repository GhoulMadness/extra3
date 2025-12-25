--------------------------------------------------------------------------------
-- MapName: (2) Castrum
--
-- Author: Janos Toth (Edited by Ghoul)
--
--------------------------------------------------------------------------------
KoopFlag = 1
gvMapText = ""..
		"@color:0,0,0,0 ................... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Castrum "
gvMapVersion = " v1.3 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()
	-- custom Map Stuff

	TagNachtZyklus(24,0,0,0,1)
    gvMission = {}
    gvMission.PlayerID = GUI.GetPlayerID()
	Mission_InitGroups()
	Mission_InitLocalResources()

	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
	Camera.ScrollSetLookAt(2220, 3650)
	for i = 1,4 do
		Logic.SetEntityScriptingValue(GetEntityId("Invis"..i),-30,257)
	end
	for i = 1,8 do
		SetHostile(i,1)
	end
	for i = 1,2 do
		CreateWoodPile("Holz"..i,10000000)
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end
	Hauptaufgabe()
	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(7,TributeForMainquest,false)
	StartCountdown(8,DifficultyVorbereitung,false)
	--
	Erinnerung = StartCountdown(45,Denkanstoss,false)

	--alle Gegnergebäude unverwundbar
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfAnyPlayerFilter(3, 4, 5, 6, 7, 8) ) do
		MakeInvulnerable(eID)
	end
	LocalMusic.UseSet = MEDITERANEANMUSIC

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		Logic.ChangeAllEntitiesPlayerID(2, 1)
		for i = 1,3 do
			DestroyEntity("Invis"..i)
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
end
function TributeForMainquest()
	GUI.PayTribute(8,TributMainquestP1)
	GUI.PayTribute(8,TributMainquestP2)
end
function AddMainquestForPlayer1() Logic.AddQuest(1,1,MAINQUEST_OPEN,"Missionsziele","Verteidigt die Festung gegen alle Angriffswellen! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function AddMainquestForPlayer2() Logic.AddQuest(2,2,MAINQUEST_OPEN,"Missionsziele","Verteidigt die Festung gegen alle Angriffswellen! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1) end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
end
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus f\195\188r diese Runde, damit das Spiel endlich starten kann!")
	local r = Logic.GetRandom(4)+1
	Stream.Start("Voice\\cm01_06_cleycourt_txt\\leonardoangry"..r..".mp3",190)
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
	TrMod0.text = "Spielmodus @color:0,255,0 <<Kooperation/Leicht>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut7()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:200,115,90 <<Kooperation/Normal>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut8()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:200,60,60 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function Tribut9()
	local TrMod3 =  {}
	TrMod3.playerId = 1
	TrMod3.text = "Spielmodus @color:255,0,0 <<Kooperation/Irrsinnig>>! "
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
        text	= "@color:230,0,0 Ein verdorbener Mann, genannt der rote Baron, plant ein neues Königreich zu errrichten. Hierzu sind ihm alle Mittel recht und er wird seine ihm unterlegenen Nachbarn unterjochen und ausbeuten.",
		position = GetPosition("P6")
	}
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Der Baron hat am Fusse eines grossen Berges gleich vier Militärlager errichtet, aus denen er stets neuen Nachschub an Truppen schöpft.",
		position = GetPosition("P13")
	}
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Sein Ziel ist die Festung von Lermonto auf der Spitze des Berges. Verteidigt sie mit Leib und Leben!",
		position = GetPosition("Citadell_PL1")
    }
	AP{
        title	= "@color:230,120,0 Missionsziele",
        text	= "@color:230,0,0 Haltet die Zitadelle der Bergfestung gegen die Streitmacht des roten Barons bis Verstärkung eintrifft!",
		position = GetPosition("RD_ArmyPL2Assault4")
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 Hinweis: Eilt euch, es wird sicher nicht lange dauern, bis die Truppen Lermonto erreicht haben!",
		position = GetPosition("CameraSpot_2")
    }
	AP{
        title	= "@color:230,120,0 Ghoul",
        text	= "@color:230,0,0 Bitte schreibt einen Kommentar zu der Map, wenn ihr Verbesserungsvorschläge, Anregungen, Kritik oder Lob zu der Map habt!",
		position = GetPlayerStartPosition(GUI.GetPlayerID())
    }


    StartBriefing(briefing)
end
function VictoryTimer()
	Victory()
end
function SpielmodKoop0()
	Message("Ihr habt den @color:0,255,0 <<LEICHTEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	StartCountdown(3,Vorb, false)

	StartCountdown(90*60,VictoryTimer,true)
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	StartSimpleJob("KillScoreBonus1")
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
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	gvDiffLVL = 1.9
	StartSimpleJob("SJ_Defeat")
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,255,0 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop1()
	Message("Ihr habt den @color:200,115,90 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	StartCountdown(3,Vorb, false)

	StartCountdown(90*60,VictoryTimer,true)
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	StartSimpleJob("KillScoreBonus1")
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
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	gvDiffLVL = 1.6
	StartSimpleJob("SJ_Defeat")
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,115,90 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop2()
	Message("Ihr habt den @color:200,60,60 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	StartCountdown(3,Vorb, false)

	StartCountdown(90*60,VictoryTimer,true)
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod3)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	StartSimpleJob("KillScoreBonus1")
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
	for i = 1,5 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

	end
	gvDiffLVL = 1.4
	StartSimpleJob("SJ_Defeat")
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:200,60,60 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SpielmodKoop3()
	Message("Ihr habt den @color:255,0,0 <<IRRSINNIGEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	StartCountdown(3,Vorb, false)

	StartCountdown(90*60,VictoryTimer,true)
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod0)
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	SetFriendly(1,2)
	StartSimpleJob("KillScoreBonus1")
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
	gvDiffLVL = 1.1
	StartSimpleJob("SJ_Defeat")
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:255,0,0 IRRSINNIG @cr "..
		" @color:230,0,240 "..gvMapVersion)
end
function SJ_Defeat()
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(1,Entities.CB_OldKingsCastle) < 1 then
		Defeat()
		return true
	end
end
function Vorb()
	StartCountdown(2*60*gvDiffLVL,TroopSpawnVorb,false)

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end

function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	if AI.Player_GetNumberOfLeaders(8)	<= (50/gvDiffLVL) then
		TroopSpawn(TimePassed)
		StartCountdown(2.2*60*gvDiffLVL,TroopSpawnVorb,false)
	else
		StartCountdown(1.2*60*gvDiffLVL,TroopSpawnVorb,false)
	end
end
AIPlayer = 8
trooptypes = {Entities.PU_LeaderBow4,Entities.PU_LeaderRifle2,Entities.PU_LeaderSword4,Entities.PU_LeaderPoleArm4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.PU_LeaderUlan1,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_BlackKnight_LeaderSword3,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1},
				[2] = {Entities.PU_LeaderPoleArm1, Entities.PU_LeaderSword1, Entities.PU_LeaderBow1},
				[3] = {Entities.PU_LeaderPoleArm2, Entities.PU_LeaderSword2, Entities.PU_LeaderBow2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.PU_LeaderHeavyCavalry1, Entities.PU_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2, Entities["PV_Cannon".. math.random(1,2)], Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			}
function TroopSpawn(_TimePassed)
	Message("Weitere Feinde versammeln sich!")
	for i = 3,13 do
		if _TimePassed <= 6 then
			CreateAttackingArmies(i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies(i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 27 then
			CreateAttackingArmies(i, 3)

		elseif _TimePassed > 27 and _TimePassed <= 42 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			armytroops[4][6] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies(i, 4)

		elseif _TimePassed > 42 and _TimePassed <=66 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies(i, 5)

		elseif _TimePassed > 66 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies(i, 6)

		end
	end
end

function CreateAttackingArmies(_poscount, _index)
	local army	= {}
    army.player = AIPlayer
    army.id	  	= GetFirstFreeArmySlot(AIPlayer)
    army.strength = table.getn(armytroops[_index])
    army.position = GetPosition("P".. _poscount)
    army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)

	for i = 1, army.strength do
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = armytroops[_index][i]
		EnlargeArmy(army, troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.id})

end
function ControlArmies(_id)

	local army = ArmyTable[AIPlayer][_id + 1]
    if IsDead(army) then
		return true
    else
		Defend(army)
    end
end

function KillScoreBonus1()
	if Score.GetPlayerScore(1, "battle") >= 1500/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 1 verfügbar!")
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword1,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear1,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow1,3)
		Logic.SetTechnologyState(1,Technologies.B_Tower,3)
		Logic.SetTechnologyState(1,Technologies.B_Barracks,3)
		Logic.SetTechnologyState(1,Technologies.B_Archery,3)
		StartSimpleJob("KillScoreBonus2")
		return true
	end
end
function KillScoreBonus2()
	if Score.GetPlayerScore(1, "battle") >= 2900/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 1 verfügbar!")
		Logic.SetTechnologyState(1,Technologies.B_Lighthouse,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Lighthouse,3)
		Logic.SetTechnologyState(1,Technologies.B_Mercenary,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Barracks,3)
		Logic.SetTechnologyState(1,Technologies.B_Stables,3)
		Logic.SetTechnologyState(1,Technologies.MU_LeaderRifle,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Archery,3)
		StartSimpleJob("KillScoreBonus3")
		return true
	end
end
function KillScoreBonus3()
	if Score.GetPlayerScore(1, "battle") >= 4000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 1 verfügbar!")
		Logic.SetTechnologyState(1,Technologies.B_Foundry,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Tower,3)
		Logic.SetTechnologyState(1,Technologies.B_Grange,3)
		--
		Logic.SetTechnologyState(1,Technologies.T_LeatherMailArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_SoftArcherArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_MasterOfSmithery,3)
		Logic.SetTechnologyState(1,Technologies.T_Fletching,3)
		Logic.SetTechnologyState(1,Technologies.T_WoodAging,3)
		Logic.SetTechnologyState(1,Technologies.T_Masonry,3)
		Logic.SetTechnologyState(1,Technologies.T_FleeceArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_LeadShot,3)
		StartSimpleJob("KillScoreBonus4")
		return true
	end
end
function KillScoreBonus4()
	if Score.GetPlayerScore(1, "battle") >= 6500/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 1 verfügbar!")
		Logic.SetTechnologyState(1,Technologies.B_Castle,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Stables,3)
		Logic.SetTechnologyState(1,Technologies.UP1_Foundry,3)
		Logic.SetTechnologyState(1,Technologies.UP2_Tower,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword2,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear2,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow2,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeLightCavalry1,3)
		Logic.SetTechnologyState(1,Technologies.T_Joust,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeRifle1,3)
		--
		Logic.SetTechnologyState(1,Technologies.T_ChainMailArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_PlateMailArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_PaddedArcherArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_LeatherArcherArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_IronCasting,3)
		Logic.SetTechnologyState(1,Technologies.T_BodkinArrow,3)
		Logic.SetTechnologyState(1,Technologies.T_Turnery,3)
		Logic.SetTechnologyState(1,Technologies.T_EnhancedGunPowder,3)
		Logic.SetTechnologyState(1,Technologies.T_BlisteringCannonballs,3)
		Logic.SetTechnologyState(1,Technologies.T_FleeceLinedLeatherArmor,3)
		Logic.SetTechnologyState(1,Technologies.T_Sights,3)
		StartSimpleJob("KillScoreBonus5")
		return true
	end
end
function KillScoreBonus5()
	if Score.GetPlayerScore(1, "battle") >= 11000/gvDiffLVL then
		Message("Weitere Technologien sind nun für Spieler 1 verfügbar!")
		Logic.SetTechnologyState(1,Technologies.T_UpgradeHeavyCavalry1,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword3,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear3,3)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow3,3)

		Logic.SetTechnologyState(1,Technologies.UP1_Castle,3)
		StartSimpleJob("KillScoreBonus6")
		return true
	end
end
function KillScoreBonus6()
	if Score.GetPlayerScore(1, "battle") >= 22000/gvDiffLVL then
		Message("Die besten Technologien sind nun für Spieler 1 verfügbar!")
		ResearchTechnology(Technologies.T_SilverSwords,1)
		ResearchTechnology(Technologies.T_SilverBullets,1)
		ResearchTechnology(Technologies.T_SilverMissiles,1)
		ResearchTechnology(Technologies.T_SilverPlateArmor,1)
		ResearchTechnology(Technologies.T_SilverArcherArmor,1)
		ResearchTechnology(Technologies.T_SilverArrows,1)
		ResearchTechnology(Technologies.T_SilverLance,1)
		ResearchTechnology(Technologies.T_BloodRush,1)
		--
		Logic.SetTechnologyState(1,Technologies.UP2_Castle,3)
		Logic.SetTechnologyState(1,Technologies.UP3_Castle,3)
		Logic.SetTechnologyState(1,Technologies.UP4_Castle,3)
		return true
	end
end
function Mission_InitGroups()
	Start()
end
function Mission_InitTechnologies()
	if not CNetwork then
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword1,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear1,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow1,0)
		Logic.SetTechnologyState(1,Technologies.B_Tower,0)
		Logic.SetTechnologyState(1,Technologies.B_Barracks,0)
		Logic.SetTechnologyState(1,Technologies.B_Archery,0)
		Logic.SetTechnologyState(1,Technologies.B_Lighthouse,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Lighthouse,0)
		Logic.SetTechnologyState(1,Technologies.B_Mercenary,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Barracks,0)
		Logic.SetTechnologyState(1,Technologies.B_Stables,0)
		Logic.SetTechnologyState(1,Technologies.MU_LeaderRifle,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Archery,0)
		Logic.SetTechnologyState(1,Technologies.B_Foundry,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Tower,0)
		Logic.SetTechnologyState(1,Technologies.B_Grange,0)
		--
		Logic.SetTechnologyState(1,Technologies.T_LeatherMailArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_SoftArcherArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_MasterOfSmithery,0)
		Logic.SetTechnologyState(1,Technologies.T_Fletching,0)
		Logic.SetTechnologyState(1,Technologies.T_WoodAging,0)
		Logic.SetTechnologyState(1,Technologies.T_Masonry,0)
		Logic.SetTechnologyState(1,Technologies.T_FleeceArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_LeadShot,0)
		Logic.SetTechnologyState(1,Technologies.B_Castle,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Stables,0)
		Logic.SetTechnologyState(1,Technologies.UP1_Foundry,0)
		Logic.SetTechnologyState(1,Technologies.UP2_Tower,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword2,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear2,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow2,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeLightCavalry1,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeRifle1,0)
		--
		Logic.SetTechnologyState(1,Technologies.T_ChainMailArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_PlateMailArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_PaddedArcherArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_LeatherArcherArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_IronCasting,0)
		Logic.SetTechnologyState(1,Technologies.T_BodkinArrow,0)
		Logic.SetTechnologyState(1,Technologies.T_Turnery,0)
		Logic.SetTechnologyState(1,Technologies.T_EnhancedGunPowder,0)
		Logic.SetTechnologyState(1,Technologies.T_BlisteringCannonballs,0)
		Logic.SetTechnologyState(1,Technologies.T_FleeceLinedLeatherArmor,0)
		Logic.SetTechnologyState(1,Technologies.T_Sights,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeHeavyCavalry1,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSword3,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeSpear3,0)
		Logic.SetTechnologyState(1,Technologies.T_UpgradeBow3,0)

		Logic.SetTechnologyState(1,Technologies.UP1_Castle,0)
		--
		Logic.SetTechnologyState(1,Technologies.UP2_Castle,0)
		Logic.SetTechnologyState(1,Technologies.UP3_Castle,0)
		Logic.SetTechnologyState(1,Technologies.UP4_Castle,0)
	end
end
function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
	Mission_InitTechnologies()
end
function InitDiplomacy()

  	SetPlayerName(8,"Lord Danaths Truppen")
end
function InitPlayerColorMapping()

	for i = 3,8 do
	   Display.SetPlayerColorMapping(i,2)
	end

end