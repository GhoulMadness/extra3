----------------------------------------------------------------------------------------------------
-- MapName: (6) Trockenzeit 6er
-- Author: Play4FuN
-- Date: 22.09.2022
-- Version: 1.2

-- TODO:
-- select difficulty
-- decrease resource amount on hard difficulty (pits and or piles)
-- hard: hungry workers

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (6) Trockenzeit "
gvMapVersion = " v1.1 "
----------------------------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	Mission_InitGroups()
	Mission_InitTechnologies()

	TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	StartSimpleJob( "VictoryJob" )

	if XNetwork.Manager_DoesExist() == 0 then

		InitSingleplayerMode()

	else

		local R, G, B = GUI.GetPlayerColor(1)
		local rnd = R + G + B
		math.randomseed(rnd)	-- now we should get the same "random" results for every player

	end

	LocalMusic.UseSet = MEDITERANEANMUSIC

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

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
	gvDiffLVL = 2.2

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
	gvDiffLVL = 1.6

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

	for i = 1,6 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	--
	PEACETIME = 30*60*gvDiffLVL
	--
	StartCountdown(PEACETIME, PeacetimeEnd, true)
	StartCountdown( 2, InitPlayers, false )
	if XNetwork.Manager_DoesExist() == 0 then
		Logic.SetNumberOfBuyableHerosForPlayer(1, 6)
	end
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
----------------------------------------------------------------------------------------------------

function InitPlayers()

	local PlayerGetGameState = Logic.PlayerGetGameState

	gvMission.Players = {}
	for i = 1, 6 do
		-- 0 = player is not in the game at all
		if PlayerGetGameState(i) == 0 then
			gvMission.Players[i] = 0
			RemovePlayerVC(i)
		else
			gvMission.Players[i] = 1	-- is human player: yes
			ColorizePlayerName(i, nil)
			SetupPlayerDefeatCondition(i)
		end
	end

	-- add gold for human players for every other player spot without a human player
	local numActivePlayers = 0
	for i = 1, 6 do
		if PlayerGetGameState(i) == 1 then
			numActivePlayers = numActivePlayers + 1
			for j = 1, 6 do
				if (i~= j) and (PlayerGetGameState(j) == 0) then
					AddGold(i, 50)
				end
			end
		end
	end

	-- more active players = fewer heroes per player
	local numHeroesByPlayerCount = {
		6,	-- 1 player ...
		4,
		4,
		3,
		3,
		3,	-- ... 6 players
	}
	local heroAmount = numHeroesByPlayerCount[numActivePlayers] or 1
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( heroAmount )

	local strength = CalculateKIStrength()
	for p = 7, 8 do
		Display.SetPlayerColorMapping(p, ROBBERS_COLOR)
		MapEditor_SetupAI(p,4-math.ceil(gvDiffLVL),30000,math.ceil(4-gvDiffLVL),"P"..p.."HQ",3,PEACETIME)
		MapEditor_Armies[p].offensiveArmies.strength = round(30/gvDiffLVL)+5*strength
		KI_ResearchAllTechnologies(p)
	end

	StartCountdown(round(PEACETIME*0.4), KI_UpgradesLow, false)
	StartCountdown(round(PEACETIME*1.2), KI_UpgradesMedium, false)
	StartCountdown(round(PEACETIME*1.6), KI_UpgradesHigh, false)

	StartCountdown( round(PEACETIME * 1.5), IncreaseEnemyAggressiveness, false )

	StartSimpleJob( "SJ_Player7Defeated" )
	StartSimpleJob( "SJ_Player8Defeated" )

	SetupDiplomacy()

end

-- 0 = player not present
-- 1 = playing
-- maximum allowed strength value for SetupKI is 4
function CalculateKIStrength()
	local getState = Logic.PlayerGetGameState
	return (getState(1) + getState(2) + getState(3) + getState(4) + getState(5) + getState(6))
end

----------------------------------------------------------------------------------------------------

function InitSingleplayerMode()

	Message("Einzelspieler aktiviert.")

	local PlayerID = GUI.GetPlayerID()
	Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
	Logic.PlayerSetGameStateToPlaying( PlayerID )

end

----------------------------------------------------------------------------------------------------

function SetupPlayerDefeatCondition(_pID)
	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, "", "PlayerDefeatCondition", 1, nil, {_pID} )
end

function PlayerDefeatCondition(_pID)
	--if IsDead("P".._pID.."HQ") then
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_pID, Entities.PB_Headquarters1)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(_pID, Entities.PB_Headquarters2)
	+ Logic.GetNumberOfEntitiesOfTypeOfPlayer(_pID, Entities.PB_Headquarters3) < 1 then
		Logic.PlayerSetGameStateToLost(_pID)
		return true
	end
end

----------------------------------------------------------------------------------------------------

function RemovePlayerVC(i)

	DestroyEntity("VC"..i.."1")
	DestroyEntity("VC"..i.."2")
end

----------------------------------------------------------------------------------------------------

function ColorizePlayerName(i, _pName)

	local R, G, B = GUI.GetPlayerColor(i)
	if _pName ~= nil then
		SetPlayerName(i, "@color:"..R..","..G..","..B.." ".._pName)
	else
		SetPlayerName(i, "@color:"..R..","..G..","..B.." "..UserTool_GetPlayerName(i))
	end
	-- for statistics menu
	Logic.PlayerSetPlayerColor(i, R, G, B)

end

----------------------------------------------------------------------------------------------------

function KI_ResearchAllTechnologies(p)

	local _TechTable = {
		Technologies.T_SoftArcherArmor,
		Technologies.T_LeatherMailArmor,
		Technologies.T_Fletching,
		Technologies.T_WoodAging,
		Technologies.T_ChainMailArmor,
		Technologies.T_LeatherArcherArmor,
		Technologies.T_MasterOfSmithery,
		Technologies.T_BodkinArrow,
		Technologies.T_Turnery,
		Technologies.T_BetterTrainingArchery,
		Technologies.T_BetterTrainingBarracks,
		Technologies.T_FleeceArmor,
		Technologies.T_FleeceLinedLeatherArmor,
		Technologies.T_LeadShot,
		Technologies.T_Sights,
		Technologies.T_BlisteringCannonballs,
		Technologies.T_BetterChassis,
		Technologies.T_EnhancedGunPowder,
	}

	for i = 1, table.getn(_TechTable) do
		ResearchTechnology(_TechTable[i], p)
	end

end

----------------------------------------------------------------------------------------------------

function KI_UpgradesLow()
	for p = 7,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, p)
	end
end

function KI_UpgradesMedium()
	for p = 7,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, p)

		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, p)
	end
end

function KI_UpgradesHigh()
	for p = 7,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, p)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, p)
	end
end

----------------------------------------------------------------------------------------------------

function IncreaseEnemyAggressiveness()
	for i = 7,8 do
		MapEditor_Armies.offensiveArmies.rodeLength = Logic.WorldGetSize()
	end
end

----------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	for i = 1, 6 do
		if (gvMission.Players[i] == 1) then
			for j = 1, 6 do
				if (i ~= j) and (gvMission.Players[j] == 1) then
					SetFriendly(i, j)
					ActivateShareExploration( i, j )
				end
			end
			SetHostile(i, 7)
			SetHostile(i, 8)
		end
	end

	SetFriendly(7, 8)

end

function PeacetimeEnd()

	Message("@color:220,64,16,255 Eure Gegner werden von nun an sehr aggressiv sein!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos, 90)

end

----------------------------------------------------------------------------------------------------

function Mission_InitGroups()

end

----------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
	for playerId = 1, 6 do
		ResearchTechnology( Technologies.GT_Literacy, playerId ) --> Bildung
	end
end

----------------------------------------------------------------------------------------------------

function Mission_InitLocalResources()

	local gold		=  dekaround(600*gvDiffLVL)
	local clay		= dekaround(1200*gvDiffLVL)
	local wood		= dekaround(1200*gvDiffLVL)
	local stone		=  dekaround(600*gvDiffLVL)
	local iron		=  dekaround(400*gvDiffLVL)
	local sulfur	=  dekaround(300*gvDiffLVL)

	for playerId = 1, 8 do
		Tools.GiveResouces( playerId, gold, clay, wood, stone, iron, sulfur )
	end

end

----------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P7HQ") and IsDead("P8HQ") then
		StartCountdown( 8, Victory )
		return true
	end
end
function StartTechnologies()
	for i = 1,6 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end 