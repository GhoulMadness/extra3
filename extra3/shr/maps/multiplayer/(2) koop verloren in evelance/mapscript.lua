-- Script.Load("E:/Games/Siedler DEdK/SKRIPTE/KARTENSKRIPTE/(2)Verloren in Evelance.lua")
----------------------------------------------------------------------------------------------------
-- Mapname: (2) Verloren in Evelance
-- Author: P4F
-- Date: 20.07.2022
-- Version: 1.1
----------------------------------------------------------------------------------------------------
gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Verloren in Evelance "
gvMapVersion = " v1.0 "

----------------------------------------------------------------------------------------------------

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player

	Mission_InitTechnologies()
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	TagNachtZyklus(24,1,1,-2,1)
	StartTechnologies()

	Timeline_Setup()


	if XNetwork.Manager_DoesExist() == 0 then

		Message("Einzelspieler aktiviert!")

		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )

	end

	LocalMusic.UseSet = EVELANCEMUSIC

	SetupDiplomacy()

	-- victory condition
	StartSimpleJob( function()
		if IsDead( "P3HQ" )
		and IsDead( "P4HQ" )
		and IsDead( "P5HQ" ) then
			Victory()
			return true
		end
	end )

	-- player defeat conditions
	StartSimpleJob( function()
		if IsDead( "P1HQ" ) then
			Logic.PlayerSetGameStateToLost(1)
			return true
		end
	end )

	StartSimpleJob( function()
		if IsDead( "P2HQ" ) then
			Logic.PlayerSetGameStateToLost(2)
			return true
		end
	end )

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
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

	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	--
	SetupEnemies()
	if XNetwork.Manager_DoesExist() == 0 then
		EnableAlliedAIPlayer()
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupEnemies()

	MapEditor_SetupAI(3,3-round(gvDiffLVL),14000,1,"P3HQ",3,32*60*gvDiffLVL)
	MapEditor_SetupAI(4,3-round(gvDiffLVL),14000,1,"P4HQ",3,32*60*gvDiffLVL)
	MapEditor_SetupAI(5,4-round(gvDiffLVL),round(9000/gvDiffLVL),3,"P5HQ",3,0)


	-- simple village constructing for player 3 and 4
	for player = 3, 4 do

		local posHq = GetPosition( "P"..player.."HQ" )
		local posAny = invalidPosition	-- seems to use last building position?
		local posVillage = GetPosition( "posP"..player.."Settlement" )

		AI.Village_StartConstruction( player, Entities.PB_University1, posHq.X, posHq.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Blacksmith1, posHq.X, posHq.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

		AI.Village_StartConstruction( player, Entities.PB_Brickworks1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Sawmill1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_StoneMason1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Blacksmith1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

		AI.Village_StartConstruction( player, Entities.PB_Barracks1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Archery1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Tower1, posAny.X, posAny.Y, 1 )

		AI.Village_StartConstruction( player, Entities.PB_Sawmill1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Brickworks1, posVillage.X, posVillage.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
		AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

		AI.Village_StartConstruction( player, Entities.PB_Tower1, posHq.X, posHq.Y, 1 )
		AI.Village_StartConstruction( player, Entities.PB_Tower1, posHq.X, posHq.Y, 1 )

		-- do not rebuild these building types:
		AI.Village_IgnoreReconstructionForBuildingType( player, Entities.PB_ClayMine1 )
		AI.Village_IgnoreReconstructionForBuildingType( player, Entities.PB_IronMine1 )
		AI.Village_IgnoreReconstructionForBuildingType( player, Entities.PB_StoneMine1 )
		AI.Village_IgnoreReconstructionForBuildingType( player, Entities.PB_SulfurMine1 )

	end

	-- colors
	Display.SetPlayerColorMapping( 3, ROBBERS_COLOR )
	Display.SetPlayerColorMapping( 4, ROBBERS_COLOR )
	Display.SetPlayerColorMapping( 5, ROBBERS_COLOR )
	Display.SetPlayerColorMapping( 6, ROBBERS_COLOR )

	Display.SetPlayerColorMapping( 8, NPC_COLOR )

	-- once an enemy is defeated, this player should not keep on building...
	StartSimpleJob( function()
		if IsDead( "P3HQ" ) then
			AI.Village_DeactivateRebuildBehaviour(3)
			AI.Village_ClearConstructionQueue(3)
			return true
		end
	end )

	StartSimpleJob( function()
		if IsDead( "P4HQ" ) then
			AI.Village_DeactivateRebuildBehaviour(4)
			AI.Village_ClearConstructionQueue(4)
			return true
		end
	end )

	local army = {}
	army.player 	= 6
	army.id			= 0
	army.strength	= math.max(math.ceil(16/gvDiffLVL), 1)
	army.position	= GetPosition("posP6S")
	army.rodeLength	= round(6000/gvDiffLVL)

	SetupArmy(army)

	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities.CU_BlackKnight_LeaderMace1
	}

	for i = 1,math.ceil(army.strength/2) do
		EnlargeArmy(army,troopDescription)
	end
	local troopDescription = {

		experiencePoints = HIGH_EXPERIENCE,
		leaderType       = Entities.CU_BanditLeaderBow1
	}
	for i = 1,math.floor(army.strength/2) do
		EnlargeArmy(army,troopDescription)
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})


	-- AI events (HQ upgrade, change allowed troop types, increase or decrease serf limit and aggressiveness)

	-- player 3 and 4
	for p = 3, 4 do

		-- 1st HQ upgrade
		gvTimeline.Add{
			player = p,
			condition = function( player )
				-- 100% chance as soon as 32 minutes have been played
				if gvTimeline.Counter > 32*60 then
					return true
				end
				-- 2% chance as soon as 20 minutes have been played
				if gvTimeline.Counter > 20*60 then
					return math.random() < 0.02
				end
			end,
			action = function( player )
				UpgradeBuilding( "P"..player.."HQ" )
			end,
		}

		-- 2nd HQ upgrade
		gvTimeline.Add{
			player = p,
			condition = function( player )
				-- 100% chance as soon as 64 minutes have been played
				if gvTimeline.Counter > 64*60 then
					return true
				end
				-- 4% chance as soon as 40 minutes have been played
				if gvTimeline.Counter > 40*60 then
					return math.random() < 0.04
				end
			end,
			action = function( player )
				-- if the building does not exist, simply nothing will happen
				UpgradeBuilding( "P"..player.."HQ" )
			end,
		}

		-- more serfs
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if Logic.GetNumberOfAttractedWorker( player ) > 20 then
					return true
				end
			end,
			action = function( player )
				AI.Village_SetSerfLimit( player, 20 )
			end,
		}

		-- some technologies
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if Logic.GetNumberOfAttractedSoldiers( player ) > 16
				and gvTimeline.Counter > 30 * 60 * gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				--Message( "research low techs - " .. player )
				ResearchTechnology( Technologies.T_SoftArcherArmor, player )
				ResearchTechnology( Technologies.T_LeatherMailArmor, player )
				ResearchTechnology( Technologies.T_Fletching, player )
				ResearchTechnology( Technologies.T_WoodAging, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if Logic.GetPlayerAttractionUsage( player ) > 120
				and gvTimeline.Counter > 40 * 60 * gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				--Message( "research medium techs - " .. player )
				ResearchTechnology( Technologies.T_ChainMailArmor, player )
				ResearchTechnology( Technologies.T_LeatherArcherArmor, player )
				ResearchTechnology( Technologies.T_MasterOfSmithery, player )
				ResearchTechnology( Technologies.T_BodkinArrow, player )
				ResearchTechnology( Technologies.T_Turnery, player )
				ResearchTechnology( Technologies.T_BetterTrainingArchery, player )
				ResearchTechnology( Technologies.T_BetterTrainingBarracks, player )
			end,
		}

		-- unit upgrades
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 20*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 30*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 45*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 55*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 70*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 85*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderCavalry, player )
				Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierCavalry, player )
			end,
		}

		-- village center upgrade
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if Logic.GetPlayerAttractionUsage( player ) > 60 then
					return true
				end
			end,
			action = function( player )
				if Logic.GetPlayerAttractionLimit( player ) > 0 then
					-- only try to upgrade it if it is not destroyed yet
					AI.Village_StartResearch( player, Entities.PB_VillageCenter1, 100, 0 )
				end
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				-- limit can only be reached because the AI does not care much about village center space
				if Logic.GetPlayerAttractionUsage( player ) > 150 then
					return true
				end
			end,
			action = function( player )
				if Logic.GetPlayerAttractionLimit( player ) > 0 then
					-- only try to upgrade it if it is not destroyed yet
					AI.Village_StartResearch( player, Entities.PB_VillageCenter2, 100, 0 )
				end
			end,
		}

		-- higher aggressiveness later in the game
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter > 80*60*gvDiffLVL then
					return true
				end
			end,
			action = function( player )
				MapEditor_Armies[player].offensiveArmies.rodeLength = Logic.WorldGetSize()
			end,
		}

		-- some extra gold (trying to gain a small increase in difficulty as the game progresses...)
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter > 50*60
				and GetGold( player ) < 2000 then
					return true
				end
			end,
			action = function( player )
				AddGold( player, 2000 )
			end,
		}

		-- allow to attack with larger armies
		-- also increase the amount of allowed armies in general
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == round(35*60*gvDiffLVL) then
					return true
				end
			end,
			action = function( player )
				MapEditor_Armies.offensiveArmies.strength = MapEditor_Armies.offensiveArmies.strength + round(6/gvDiffLVL)
			end,
		}
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == round(60*60*gvDiffLVL) then
					return true
				end
			end,
			action = function( player )
				MapEditor_Armies.offensiveArmies.strength = MapEditor_Armies.offensiveArmies.strength + round(8/gvDiffLVL)
			end,
		}

		-- some more buildings later on
		gvTimeline.Add{
			player = p,
			condition = function( player )
				if gvTimeline.Counter == 80*60 then
					return true
				end
			end,
			action = function( player )
				local posAny = invalidPosition	-- seems to use last building position?
				local posVillage = GetPosition( "posP"..player.."Settlement" )
				AI.Village_StartConstruction( player, Entities.PB_StoneMason1, posVillage.X, posVillage.Y, 0 )
				AI.Village_StartConstruction( player, Entities.PB_Blacksmith1, posVillage.X, posVillage.Y, 1 )
				AI.Village_StartConstruction( player, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

				AI.Village_StartResearch( player, Entities.PB_Sawmill1, 100, 0 )
				AI.Village_StartResearch( player, Entities.PB_Brickworks1, 100, 0 )
				AI.Village_StartResearch( player, Entities.PB_University1, 100, 0 )
				AI.Village_StartResearch( player, Entities.PB_Farm1, 100, 0 )
				AI.Village_StartResearch( player, Entities.PB_Residence1, 100, 0 )
			end,
		}

	end

	gvTimeline.Add{
		player = 5,
		condition = function( player )
			if gvTimeline.Counter == round(60*60*gvDiffLVL) then
				return true
			end
		end,
		action = function( player )
			MapEditor_Armies[player].offensiveArmies.rodeLength = Logic.WorldGetSize()
		end,
	}

	gvTimeline.Add{
		player = 5,
		condition = function( player )
			if gvTimeline.Counter == round(75*60*gvDiffLVL) then
				return true
			end
		end,
		action = function( player )
			MapEditor_Armies[player].offensiveArmies.strength = MapEditor_Armies[player].offensiveArmies.strength + round(8/gvDiffLVL)
		end,
	}

end

function ControlArmies(_player, _id)

    if IsDead(ArmyTable[_player][_id + 1]) then
		OnBanditCampDestroyed()
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- singleplayer: allied AI player
-- serfs extract resources, build settlement
-- recruit some military, play relatively defensive
-- do not occupy resource pits and only one village center
function EnableAlliedAIPlayer()

	MapEditor_SetupAI(2,math.ceil(gvDiffLVL),8600,1,"P2HQ",1,0)

	local posHq = GetPosition( "P2HQ" )
	local posAny = invalidPosition	-- seems to use last building position?

	AI.Village_StartConstruction( 2, Entities.PB_University1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Blacksmith1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

	AI.Village_StartConstruction( 2, Entities.PB_Brickworks1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Sawmill1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_StoneMason1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Blacksmith1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

	AI.Village_StartConstruction( 2, Entities.PB_Sawmill1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Brickworks1, posHq.X, posHq.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Farm1, posAny.X, posAny.Y, 0 )
	AI.Village_StartConstruction( 2, Entities.PB_Residence1, posAny.X, posAny.Y, 0 )

	AI.Village_StartConstruction( 2, Entities.PB_Tower1, posHq.X, posHq.Y, 1 )
	AI.Village_StartConstruction( 2, Entities.PB_Tower1, posHq.X, posHq.Y, 1 )

	-- 1st HQ upgrade
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			-- 100% chance as soon as 33 minutes have been played
			if gvTimeline.Counter > 33*60 then
				return true
			end
			-- 2% chance as soon as 20 minutes have been played
			if gvTimeline.Counter > 20*60 then
				return math.random() < 0.02
			end
		end,
		action = function( player )
			UpgradeBuilding( "P"..player.."HQ" )
		end,
	}

	-- 2nd HQ upgrade
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			-- 100% chance as soon as 90 minutes have been played
			if gvTimeline.Counter > 90*60 then
				return true
			end
			-- 4% chance as soon as 60 minutes have been played
			if gvTimeline.Counter > 60*60 then
				return math.random() < 0.04
			end
		end,
		action = function( player )
			-- if the building does not exist, simply nothing will happen
			UpgradeBuilding( "P"..player.."HQ" )
		end,
	}

	-- some military buildings
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter == 25*60 then
				return true
			end
		end,
		action = function( player )
			local posHq = GetPosition( "P2HQ" )
			local posAny = invalidPosition
			AI.Village_StartConstruction( player, Entities.PB_Barracks1, posHq.X, posHq.Y, 0 )
			AI.Village_StartConstruction( player, Entities.PB_Archery1, posHq.X, posHq.Y, 0 )
			AI.Village_StartConstruction( player, Entities.PB_Tower1, posAny.X, posAny.Y, 1 )
		end,
	}

	-- settlement building upgrades
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter == 75*60 then
				return true
			end
		end,
		action = function( player )
			local posHq = GetPosition( "P2HQ" )
			local posAny = invalidPosition
			AI.Village_StartConstruction( player, Entities.PB_Tower1, posAny.X, posAny.Y, 2 )
			AI.Village_StartConstruction( player, Entities.PB_Tower1, posAny.X, posAny.Y, 2 )

			AI.Village_StartResearch( player, Entities.PB_Sawmill1, 100, 0 )
			AI.Village_StartResearch( player, Entities.PB_Blacksmith1, 100, 0 )
			AI.Village_StartResearch( player, Entities.PB_Residence1, 100, 0 )
			AI.Village_StartResearch( player, Entities.PB_Residence1, 100, 0 )
		end,
	}

	-- serf amount
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if Logic.GetNumberOfAttractedWorker( player ) > 20 then
				return true
			end
		end,
		action = function( player )
			AI.Village_SetSerfLimit( player, 20 )
		end,
	}

	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter > 90*60 then
				return true
			end
		end,
		action = function( player )
			AI.Village_SetSerfLimit( player, 8 )
		end,
	}

	-- soldier and army upgrades
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter == 41*60/gvDiffLVL then
				return true
			end
		end,
		action = function( player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )

			MapEditor_Armies[player].offensiveArmies.rodeLength = MapEditor_Armies[player].offensiveArmies.rodeLength * 1.5
		end,
	}

	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter == 55*60 then
				return true
			end
		end,
		action = function( player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )
		end,
	}

	gvTimeline.Add{
		player = 2,
		condition = function( player )
			-- final upgrade for soldiers:
			-- 5% chance after 2 hours passed
			if gvTimeline.Counter > 120*60 then
				return math.random() < 0.05
			end
			-- 1% chance after 1 hour passed
			if gvTimeline.Counter > 60*60 then
				return math.random() < 0.01
			end
		end,
		action = function( player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierSword, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierPoleArm, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.LeaderBow, player )
			Logic.UpgradeSettlerCategory( UpgradeCategories.SoldierBow, player )
		end,
	}

	-- village center upgrade
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if Logic.GetPlayerAttractionUsage( player ) > 60 then
				return true
			end
		end,
		action = function( player )
			if Logic.GetPlayerAttractionLimit( player ) > 0 then
				-- only try to upgrade it if it is not destroyed yet
				AI.Village_StartResearch( player, Entities.PB_VillageCenter1, 100, 0 )
			end
		end,
	}

	gvTimeline.Add{
		player = 2,
		condition = function( player )
			-- limit can only be reached because the AI does not care much about village center space
			if Logic.GetPlayerAttractionUsage( player ) > 150 then
				return true
			end
		end,
		action = function( player )
			if Logic.GetPlayerAttractionLimit( player ) > 0 then
				-- only try to upgrade it if it is not destroyed yet
				AI.Village_StartResearch( player, Entities.PB_VillageCenter2, 100, 0 )
			end
		end,
	}

	-- enable attacks later in the game
	gvTimeline.Add{
		player = 2,
		condition = function( player )
			if gvTimeline.Counter == 100*60/gvDiffLVL then
				return true
			end
		end,
		action = function( player )
			MapEditor_Armies[player].offensiveArmies.rodeLength = Logic.WorldGetSize()
		end,
	}

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupDiplomacy()

	SetPlayerName( 3, "Der Schrecken von Evelance" )

	SetFriendly( 1, 2 )
	Logic.SetShareExplorationWithPlayerFlag( 1, 2, 1 )
	Logic.SetShareExplorationWithPlayerFlag( 2, 1, 1 )

	for enemy = 3, 6 do
		SetHostile( 1, enemy )
		SetHostile( 2, enemy )
	end

	NewPlayerNames()

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function NewPlayerNames()

	UserTool_GetPlayerNameORIG = UserTool_GetPlayerName
	function UserTool_GetPlayerName(_PlayerID)
		if _PlayerID == 3 or _PlayerID == 4 then
			return "Ein Gegner"
		elseif XNetwork.Manager_DoesExist() == 0 and _PlayerID == 2 then
			return "Euer Verbündeter"
		else
			return UserTool_GetPlayerNameORIG(_PlayerID)
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- gold reward
function OnBanditCampDestroyed()
	Message( "Ihr habt in dem lager der banditen 1600 taler gefunden!" )
	AddGold( 1, 1600 )
	AddGold( 2, 1600 )
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set local resources
function Mission_InitLocalResources()
	local InitGoldRaw	= dekaround(500*gvDiffLVL)
	local InitClayRaw	= dekaround(1000*gvDiffLVL)
	local InitWoodRaw	= dekaround(1000*gvDiffLVL)
	local InitStoneRaw	= dekaround(800*gvDiffLVL)
	local InitIronRaw	= dekaround(600*gvDiffLVL)
	local InitSulfurRaw	= dekaround(600*gvDiffLVL)

	for i = 1,2 do
        Tools.GiveResouces( i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw, InitIronRaw, InitSulfurRaw )
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
	for i = 1, 2 do
		ForbidTechnology( Technologies.B_Bridge, i )
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Timeline_Setup()

	gvTimeline = {}
	gvTimeline.Counter = 0
	gvTimeline.Queue = {}

	gvTimeline.JobID = StartSimpleJob( function()
		gvTimeline.Counter = gvTimeline.Counter + 1

		for i = table.getn(gvTimeline.Queue), 1, -1 do
			local event = gvTimeline.Queue[i]
			if event.condition( event.player ) then
				event.action( event.player )
				table.remove( gvTimeline.Queue, i )
			end
		end
	end )

	gvTimeline.Add = function( event )
		assert( event.condition )
		assert( event.action )
		table.insert( gvTimeline.Queue, event )
	end

	gvTimeline.Stop = function()
		EndJob( gvTimeline.JobID )
		gvTimeline = nil
	end

end
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- updated to work with Kimichura's MP Server
function UpgradeBuilding( entity )
	local EntityID = GetID( entity )

	if IsValid(EntityID) and IsBuildingUpgradable(EntityID) then
		local EntityType = Logic.GetEntityType(EntityID)
		local PlayerID = GetPlayer(EntityID)
		local Costs = {}
		Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
		-- Add needed resources
		for Resource, Amount in Costs do
			Logic.AddToPlayersGlobalResource( PlayerID, Resource, Amount )
		end
		-- Start upgrade
		if SendEvent then
			-- networked
			SendEvent.UpgradeBuilding(EntityID)
		else
			-- "normal"
			GUI.UpgradeSingleBuilding(EntityID)
		end
	end
end

function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end