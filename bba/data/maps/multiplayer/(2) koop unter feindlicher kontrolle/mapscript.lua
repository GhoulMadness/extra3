----------------------------------------------------------------------------------------------------
-- Mapname: (2) Unter feindlicher Kontrolle
-- Author: P4F
-- Date: 23.03.2022
-- Version 1
----------------------------------------------------------------------------------------------------

gvMapText = ""..
		"@color:0,0,0,0 ........... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Unter feindlicher Kontrolle "
gvMapVersion = " v1.0 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

	Mission_InitGroups()
	Mission_InitTechnologies()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()


	-- disable some heroes so the player cannot choose them
	BuyHeroWindow_Update_BuyHeroOrig = BuyHeroWindow_Update_BuyHero
	BuyHeroWindow_Update_BuyHero = function(_ent)
		BuyHeroWindow_Update_BuyHeroOrig(_ent)
		-- note that the button name and GUI call to buy Erec/Salim is wrong
		--> to disable the button for Erec, one must disable the hero3 button
		-- XGUIEng.DisableButton( "BuyHeroWindowBuyHero3", 1 )

		XGUIEng.DisableButton( "BuyHeroWindowBuyHero7", 1 )		-- Mary
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero8", 1 )		-- Kerberos
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero9", 1 )		-- Varg
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero10", 1 )	-- Drake
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero12", 1 )	-- Kala
	end


	-- no randomseed for MP?

	if XNetwork.Manager_DoesExist() == 0 then
		for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	InitDiplomacy()

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
	IntroBriefing()
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	--
	InitPlayers()
	--
	StartSimpleJob("SJ_Defeat")
	StartSimpleJob("VictoryJob")
	StartCountdown(35*60*gvDiffLVL,UpgradeAITroops1,false)
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
-- Truppen upgrades ...
function UpgradeAITroops1()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
	end

	StartCountdown(15*60,UpgradeAITroops2,false)
end

function UpgradeAITroops2()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
	end

	StartCountdown(10*60,UpgradeAITroops3,false)
end

function UpgradeAITroops3()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)

		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.5
	end

	StartCountdown(15*60,UpgradeAITroops4,false)
end

function UpgradeAITroops4()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.2
	end

	StartCountdown(20*60,UpgradeAITroops5,false)
end

function UpgradeAITroops5()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)

		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.2
	end

	StartCountdown(30*60,UpgradeAITroops6,false)
end

function UpgradeAITroops6()
	for i = 3,7 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = MapEditor_Armies[i].offensiveArmies.rodeLength * 1.2
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(5/gvDiffLVL)
	end

	StartCountdown(40*60,UpgradeAITroops7,false)

end
function UpgradeAITroops7()
	for i = 3,7 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
		MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + round(10/gvDiffLVL)
	end
	-- KI fertig aufgerüstet!
end
----------------------------------------------------------------------------------------------------

function InitDiplomacy()

	SetFriendly( 1, 2 )
	SetFriendly( 1, 3 )
	SetFriendly( 2, 3 )

	SetFriendly( 4, 5 )
	SetFriendly( 6, 7 )

	SetHostile( 4, 6 )
	SetHostile( 4, 7 )
	SetHostile( 5, 6 )
	SetHostile( 5, 7 )

	for playerId = 1, 3 do
		SetHostile( playerId, 4 )
		SetHostile( playerId, 5 )
		SetHostile( playerId, 6 )
		SetHostile( playerId, 7 )
	end

	SetPlayerName( 3, "Brugge" )
	SetPlayerName( 4, "Hagen" )
	SetPlayerName( 5, "Sulza" )
	SetPlayerName( 6, "Altenau" )
	SetPlayerName( 7, "Rahden" )

end

----------------------------------------------------------------------------------------------------

function InitPlayers()

	MapEditor_SetupAI(3,2,14000,math.ceil(0+gvDiffLVL),"PosPlayer3DefendCity",3,0)
	MapEditor_SetupAI(4,4-math.ceil(gvDiffLVL),6000,math.ceil(4-gvDiffLVL),"PosPlayer4DefendOutpost",3,0)
	MapEditor_SetupAI(5,4-math.ceil(gvDiffLVL),15000,math.ceil(4-gvDiffLVL),"PosPlayer5DefendCity",3,0)
	MapEditor_SetupAI(6,4-math.ceil(gvDiffLVL),15000,math.ceil(4-gvDiffLVL),"PosPlayer6DefendCity",3,0)
	MapEditor_SetupAI(7,4-math.ceil(gvDiffLVL),6000,math.ceil(4-gvDiffLVL),"PosPlayer7DefendOutpost",3,0)

	ConnectLeaderWithArmy(CreateEntity( 3, Entities.PU_Hero10, GetPosition( "PosPlayer3DefendCity" ) ), nil, "offensiveArmies")
	ConnectLeaderWithArmy(CreateEntity( 4, Entities.CU_Mary_de_Mortfichet, GetPosition( "PosPlayer4DefendCity" ) ), nil, "offensiveArmies")
	ConnectLeaderWithArmy(CreateEntity( 5, Entities.CU_BlackKnight, GetPosition( "PosPlayer5DefendCity" ) ), nil, "offensiveArmies")
	ConnectLeaderWithArmy(CreateEntity( 6, Entities.CU_Barbarian_Hero, GetPosition( "PosPlayer6DefendCity" ) ), nil, "offensiveArmies")
	ConnectLeaderWithArmy(CreateEntity( 7, Entities.CU_Evil_Queen, GetPosition( "PosPlayer7DefendCity" ) ), nil, "offensiveArmies")

	-- shared view
	Logic.SetShareExplorationWithPlayerFlag( 1, 2, 1 )
	Logic.SetShareExplorationWithPlayerFlag( 1, 3, 1 )
	Logic.SetShareExplorationWithPlayerFlag( 2, 1, 1 )
	Logic.SetShareExplorationWithPlayerFlag( 2, 3, 1 )

end

function VictoryJob()
	local count = 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(4,5,6,7), CEntityIterator.OfAnyCategoryFilter(EntityCategories.MilitaryBuilding, EntityCategories.Leader)) do
		if Logic.IsEntityAlive(eID) then
			count = count + 1
		end
	end
	if count == 0 then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_Defeat()
	local count = 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2,3), CEntityIterator.OfCategoryFilter(EntityCategories.Headquarters)) do
		count = count + 1
	end
	if count < 3 then
		Defeat()
		return true
	end
end

function Mission_InitGroups()

end

----------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()

end

----------------------------------------------------------------------------------------------------

function Mission_InitLocalResources()

	local gold		= dekaround(600*gvDiffLVL)
	local clay		= dekaround(800*gvDiffLVL)
	local wood		= dekaround(800*gvDiffLVL)
	local stone		= dekaround(600*gvDiffLVL)
	local iron		= dekaround(600*gvDiffLVL)
	local sulfur	= dekaround(300*gvDiffLVL)

	for playerId = 1, 2 do
		Tools.GiveResouces( playerId, gold, clay, wood, stone, iron, sulfur )
	end

end

----------------------------------------------------------------------------------------------------

function IntroBriefing()
	local briefing = {}
	local AP = function(_page) table.insert(briefing, _page) return _page end

	AP{
		title	= "@color:255,125,20 Mission",
		text	= "Nachdem mehrere Städte unter feindliche Kontrolle geraten sind, verbündet ihr euch mit dem letzten standhaften Anführer,"..
		" um die Besatzer zu vertreiben. @cr @cr @color:150,150,150 (Esc - Fortsetzen)"
	}
	AP{
		title	= "@color:255,125,20 Mission",
		text	= "Zu Eurem Glück ist auch zwischen den Eroberern ein Konflikt ausgebrochen. Das heißt, ihr werdet nicht einer vereinten Streitmacht"..
		" entgegentreten müssen, sondern mehreren Armeen von geringerer Stärke. @cr @cr @color:150,150,150 (Esc - Fortsetzen)"
	}
	AP{
		title	= "@color:255,125,20 Missionsziel",
		text	= "Befreit die Städte von ihren Besatzern, indem Ihr die Festungen besiegt"..
		" sowie sämtliche Truppen. Es ist nicht erforderlich, ihre Siedlungsgebäude anzugreifen."..
		" @cr @cr @color:150,150,150 (Esc - Spiel starten)"
	}
	briefing.finished = function()
		InitMainQuest()
	end

	StartBriefing(briefing)
end

----------------------------------------------------------------------------------------------------

function InitMainQuest()
	local title = "Hauptaufgabe"
	local text = "Befreit die Städte von ihren Besatzern, indem Ihr die Festungen besiegt"..
	-- " sowie sämtliche Truppen. Ihr solltet dabei möglichst wenige Siedlungsgebäude angreifen."..
	" sowie sämtliche Truppen. Es ist nicht erforderlich, ihre Siedlungsgebäude anzugreifen."..
	" Achtet darauf, weder Euer Haupthaus, noch die Eurer Verbündeten zu verlieren."..
	" @cr @cr Hinweise:"..
	" @cr - Wenn Ihr gegnerische Militärgebäude erobert, achtet darauf, dass der Gegner sie nicht"..
	" zurückgewinnt"
	Logic.AddQuest( 1, 1, MAINQUEST_OPEN, title, text, 1 )
	Logic.AddQuest( 2, 2, MAINQUEST_OPEN, title, text, 1 )
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end