-- Mapname: (2) Alte Zeiten
-- Author: P4F

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (2) Alte Zeiten "
gvMapVersion = " v1.1 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	P5attacking = false
	P6attacking = false

    TagNachtZyklus(24,1,0,0,1)
	StartTechnologies()

    Mission_InitGroups()
    MultiplayerTools.InitCameraPositionsForPlayers()
    MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Message("Spieler 1 kann nun die Schwierigkeit im Tributmenü auswählen!")
	TributeP1_Easy()
	TributeP1_Normal()
	TributeP1_Hard()

    StartSimpleJob("SJ_CheckStein")
    StartSimpleJob("VictoryJob")
	StartCountdown(1,AnfangsBriefing,false)
	Hauptaufgabe()
	StartCountdown(10,TributeForMainquest,false)
	ActivateShareExploration(1,2,true)

	CreateWoodPile("Holzstapel_1",400000)
	CreateWoodPile("Holzstapel_2",400000)

    if XNetwork.Manager_DoesExist() == 0 then
		Message("Einzelspieler aktiviert!")

        for i = 1, 2 do    -- Für 2 Spieler eingestellt
            MultiplayerTools.DeleteFastGameStuff(i)
        end
        local PlayerID = GUI.GetPlayerID()
        Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
        Logic.PlayerSetGameStateToPlaying( PlayerID )
    end

    --LocalMusic.UseSet = HIGHLANDMUSIC
    --LocalMusic.UseSet = EUROPEMUSIC
    --LocalMusic.UseSet = HIGHLANDMUSIC
    LocalMusic.UseSet = MEDITERANEANMUSIC
    --LocalMusic.UseSet = DARKMOORMUSIC
    --LocalMusic.UseSet = EVELANCEMUSIC
	--MapEditor_SetupDestroyVictoryCondition(3)

	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")

	-- Namen
	SetPlayerName(1,"Pilgrim")
	SetPlayerName(2,"Salim")
	SetPlayerName(3,"Mary de Morftichet")
	SetPlayerName(4,"Kerberos")
	SetPlayerName(5,"Banditen")
	SetPlayerName(6,"Banditen")
	-- Spieler 1 und 2 verbündet
	SetFriendly(1,2)
	-- Spieler 1 feindlich zu 3,4,5 und 6
	SetHostile(1,3)
	SetHostile(1,4)
	SetHostile(1,5)
	SetHostile(1,6)
	-- Spieler 2 feindlich zu 3,4,5 und 6
	SetHostile(2,3)
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)
	-- Spieler 3 und 4 verbündet
	SetFriendly(3,4)
	-- Spieler 5 und 3,4,6 verbündet
	SetFriendly(3,5)
	SetFriendly(4,5)
	SetFriendly(5,6)
	-- Spieler 6 und 3,4 verbündet
	SetFriendly(3,6)
	SetFriendly(4,6)

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 0 )
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
	if XNetwork.Manager_DoesExist() == 0 then
		SetupKi2()
	end
	-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Spieler 3 - Mary
    MapEditor_SetupAI(3,4-math.floor(gvDiffLVL),99999,1,"P3HQ",3,60)
	SetupPlayerAi(3, {
	serfLimit = 8,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 5, randomTime = 1},
	}
	)

	local constructionplanP3 = {
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P3posDZ"), level = 1 },		-- Dorfzentrum
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3posLehm1"), level = 1 },		-- Lehmmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_University1, pos = GetPosition("P3posUni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Farm1, pos = GetPosition("SMP3"), level = 0 },					-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P3posEisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P3posSchwefel"), level = 1 },	-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P3posLehm2"), level = 1 },		-- Lehmmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 1 },					-- Schiessanlage
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 1 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P3posDZ"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P3posLehm2"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Sawmill1, pos = invalidPosition, level = 1 },					-- Sägemühle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },						-- Bank
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = GetPosition("P3posUni"), level = 2 },			-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P3posSchwefel"), level = 2 },		-- Turm
		{ type = Entities.PB_Beautification09, pos = GetPosition("P3HQ"), level = 0 },		-- Blumen
		{ type = Entities.PB_Beautification08, pos = GetPosition("P3HQ"), level = 0 },		-- Zugbrunnen
		{ type = Entities.PB_Beautification04, pos = GetPosition("P3HQ"), level = 0 },		-- Kameraden
		}
	FeedAiWithConstructionPlanFile(3,constructionplanP3)

	-- Spieler 4 - Kerberos
    MapEditor_SetupAI(4,math.floor(4-gvDiffLVL),99999,1,"P4HQ",3,60)
	--SetAIUnitsToBuild( 4, UpgradeCategories.Evil_LeaderBearman, UpgradeCategories.Evil_LeaderSkirmisher )
	SetupPlayerAi(4, {
	serfLimit = 8,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 5, randomTime = 1},
	}
	)

	local constructionplanP4 = {
		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P4posDZ"), level = 1 },		-- Dorfzentrum
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P4posLehm1"), level = 1 },		-- Lehmmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_University1, pos = GetPosition("P4posUni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Farm1, pos = GetPosition("SMP4"), level = 0 },					-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P4posEisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P4posSchwefel"), level = 1 },	-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P4posLehm2"), level = 1 },		-- Lehmmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 1 },					-- Schiessanlage
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 1 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P4posDZ"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P4posLehm2"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Sawmill1, pos = invalidPosition, level = 1 },					-- Sägemühle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },						-- Bank
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = GetPosition("P4posUni"), level = 2 },			-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P4posSchwefel"), level = 2 },		-- Turm
		{ type = Entities.PB_Beautification09, pos = GetPosition("P4HQ"), level = 0 },		-- Blumen
		{ type = Entities.PB_Beautification08, pos = GetPosition("P4HQ"), level = 0 },		-- Zugbrunnen
		{ type = Entities.PB_Beautification04, pos = GetPosition("P4HQ"), level = 0 },		-- Kameraden
		}
	FeedAiWithConstructionPlanFile(4,constructionplanP4)

	----
	StartCountdown(10*60,BanditAttackLowP5,false)
	StartCountdown(10*60,BanditAttackLowP6,false)
	StartCountdown(25*60,BanditAttackMediumP5,false)
	StartCountdown(25*60,BanditAttackMediumP6,false)
	StartCountdown(50*60*gvDiffLVL,WinterIsHere,true)
	StartCountdown(50*60,AI_NoMoreConstructing,false)
	StartCountdown(90,RespawnBanditsP5,false)
	StartCountdown(90,RespawnBanditsP6,false)
	StartCountdown(5*60,UpgradeAISerfs,false)
	StartCountdown(15*60*gvDiffLVL,UpgradeAITowers,false)
	StartCountdown(40*60*gvDiffLVL,UpgradeAITroops1,false)
	--
	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
function WinterIsHere()
	StartWinter(10*60)
	StartCountdown(12*60,WinterIsHere,false)
end
function AI_NoMoreConstructing()
	for i = 3,4 do
		AI.Village_DeactivateRebuildBehaviour(i)
	end
end
-- einige Upgrades ...
function UpgradeAISerfs()
	AI.Village_SetSerfLimit(3,12)
	AI.Village_SetSerfLimit(4,12)
	StartCountdown(15*60,UpgradeAISerfsAgain,false)
end

function UpgradeAISerfsAgain()
	AI.Village_SetSerfLimit(3,20)
	AI.Village_SetSerfLimit(4,20)
	StartCountdown(15*60,UpgradeAISerfsAgainAgain,false)
end

function UpgradeAISerfsAgainAgain()
	AI.Village_SetSerfLimit(3,40)
	AI.Village_SetSerfLimit(4,40)
end

function UpgradeAITowers()
	while GetStone(3) < 1000 do
		AddStone(3,100)
	end

	while GetWood(3) < 400 do
		AddWood(3,100)
	end

	while GetStone(4) < 1000 do
		AddStone(4,100)
	end

	while GetWood(4) < 400 do
		AddWood(4,100)
	end
	for i=1,3 do if IsAlive("P3turm"..i) then UpgradeBuilding("P3turm"..i) end end
	for j=1,3 do if IsAlive("P4turm"..j) then UpgradeBuilding("P4turm"..j) end end

	local researchplan = {
	{ type = Entities.PB_StoneMine1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
    }

	for i = 3,4 do FeedAiWithResearchPlanFile(i,researchplan) end

	StartCountdown(15*60,UpgradeAIHQ,false)
end

function UpgradeAIHQ()
	while GetStone(3) < 500 do
		AddStone(3,100)
	end

	while GetWood(3) < 500 do
		AddWood(3,100)
	end

	while GetStone(4) < 500 do
		AddStone(4,100)
	end

	while GetWood(4) < 500 do
		AddWood(4,100)
	end

	if IsExisting("P3HQ") then UpgradeBuilding("P3HQ") end
	if IsExisting("P4HQ") then UpgradeBuilding("P4HQ") end

	local researchplan = {
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	for i = 3,4 do FeedAiWithResearchPlanFile(i,researchplan) end

	StartCountdown(45*60,UpgradeAIHQagain,false)
end

function UpgradeAIHQagain()
	if IsExisting("P3HQ") then UpgradeBuilding("P3HQ") end
	if IsExisting("P4HQ") then UpgradeBuilding("P4HQ") end
end

-- Truppen upgrades ...
function UpgradeAITroops1()
	for i = 3,4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
	end

	StartCountdown(15*60,UpgradeAITroops2,false)
end

function UpgradeAITroops2()
	for i = 3,4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
	end

	StartCountdown(10*60,UpgradeAITroops3,false)
end

function UpgradeAITroops3()
	for i = 3,4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)

		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_FleeceArmor,i)
		ResearchTechnology(Technologies.T_LeadShot,i)
	end

	StartCountdown(15*60,UpgradeAITroops4,false)
end

function UpgradeAITroops4()
	for i = 3,4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)

		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_WoodAging,i)
	end

	StartCountdown(20*60,UpgradeAITroops5,false)
end

function UpgradeAITroops5()
	for i = 3,4 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)

		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
	end

	StartCountdown(30*60,UpgradeAITroops6,false)
end

function UpgradeAITroops6()
	for i = 3,4 do
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
	end

	local researchplan = {
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	for j = 3,4 do FeedAiWithResearchPlanFile(j,researchplan) end

	StartCountdown(40*60,UpgradeAITroops7,false)

end
function UpgradeAITroops7()
	for i = 3,4 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
	-- KI fertig aufgerüstet!
end
-------------------------------------------------------------------------------------------------------------------------------------------------------

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

function AddMainquestForPlayer1()
	Logic.AddQuest(1,1,MAINQUEST_OPEN,"Hauptaufgabe","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Mary De Mortfichet und Kerberos und zerstört ihre Burgen! @cr @cr Hinweise: @cr - Im Winter gefrieren die Flüsse! @cr - Seid beim Erkunden der Umgebung vorsichtig! Banditen hausen nicht weit von Euch.",1)
end

function AddMainquestForPlayer2()
	Logic.AddQuest(2,2,MAINQUEST_OPEN,"Hauptaufgabe","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Besiegt Mary De Mortfichet und Kerberos und zerstört ihre Burgen! @cr @cr Hinweise: @cr - Im Winter gefrieren die Flüsse! @cr - Seid beim Erkunden der Umgebung vorsichtig! Banditen hausen nicht weit von Euch.",1)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitGroups()
	-- P1
	CreateMilitaryGroup(1,Entities.PU_LeaderBow1,4,GetPosition("P1posBogi"))

	-- P2
	CreateMilitaryGroup(2,Entities.PU_LeaderBow1,4,GetPosition("P2posBogi"))

	-- P5
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,8,GetPosition("band_pos_1"),"band_troop_1")
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,10,GetPosition("band_pos_2"),"band_troop_2")
	CreateMilitaryGroup(5,Entities.CU_Barbarian_LeaderClub1,10,GetPosition("band_pos_3"),"band_troop_3")
	CreateMilitaryGroup(5,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("band_pos_4"),"band_troop_4")
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,10,GetPosition("band_pos_5"),"band_troop_5")
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,8,GetPosition("band_pos_6"),"band_troop_6")
	CreateMilitaryGroup(5,Entities.CU_BlackKnight_LeaderMace1,10,GetPosition("band_pos_7"),"band_troop_7")
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,10,GetPosition("band_pos_8"),"band_troop_8")
	CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,8,GetPosition("band_pos_9"),"band_troop_9")

	-- P6
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,8,GetPosition("bband_pos_1"),"bband_troop_1")
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,10,GetPosition("bband_pos_2"),"bband_troop_2")
	CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub1,10,GetPosition("bband_pos_3"),"bband_troop_3")
	CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("bband_pos_4"),"bband_troop_4")
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,10,GetPosition("bband_pos_5"),"bband_troop_5")
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,8,GetPosition("bband_pos_6"),"bband_troop_6")
	CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderMace1,10,GetPosition("bband_pos_7"),"bband_troop_7")
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,10,GetPosition("bband_pos_8"),"bband_troop_8")
	CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,8,GetPosition("bband_pos_9"),"bband_troop_9")
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- P5
function BanditAttackLowP5()
	if IsExisting("P1HQ") then
		P5attacking = true
		StartCountdown(120,EndP5attack,false)
		for i = 1,3 do
			if IsAlive("band_troop_"..i) then
				Attack("band_troop_"..i,"P1HQ")
			end
		end

		if IsExisting("BandTurm1") then
			StartCountdown(10*60,BanditAttackLowP5,false)
		end
	end
end

function BanditAttackMediumP5()
	if IsExisting("P1HQ") then
		P5attacking = true
		StartCountdown(120,EndP5attack,false)
		for i = 4,7 do
			if IsAlive("band_troop_"..i) then
				Attack("band_troop_"..i,"P1HQ")
			end
		end

		if IsExisting("BandTurm2") then
			StartCountdown(10*60,BanditAttackMediumP5,false)
		end
	end
end

-- P6
function BanditAttackLowP6()
	if IsExisting("P2HQ") then
		P6attacking = true
		StartCountdown(120,EndP6attack,false)
		for j = 1,3 do
			if IsAlive("bband_troop_"..j) then
				Attack("bband_troop_"..j,"P2HQ")
			end
		end

		if IsExisting("bBandTurm1") then
			StartCountdown(10*60,BanditAttackLowP6,false)
		end
	end
end

function BanditAttackMediumP6()
	if IsExisting("P2HQ") then
		P6attacking = true
		StartCountdown(120,EndP6attack,false)
		for i = 4,7 do
			if IsAlive("bband_troop_"..i) then
				Attack("bband_troop_"..i,"P2HQ")
			end
		end

		if IsExisting("bBandTurm2") then
			StartCountdown(10*60,BanditAttackMediumP6,false)
		end
	end
end

function EndP5attack()

	if IsExisting("P1HQ") then

		if not AreEntitiesInArea(5,0,GetPosition("P1HQ"),5400,1) then
			P5attacking = false
		else
			StartCountdown(60,EndP5attack,false)
		end

	else
		BanditAttackLowP5 = function() end

		BanditAttackMediumP5 = function() end
	end
end

function EndP6attack()

	if IsExisting("P2HQ") then

		if not AreEntitiesInArea(6,0,GetPosition("P2HQ"),5400,1) then
			P6attacking = false
		else
			StartCountdown(60,EndP6attack,false)
		end

	else
		BanditAttackLowP6 = function() end

		BanditAttackMediumP6 = function() end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function RespawnBanditsP5()

	if IsExisting("BandTurm1") or IsExisting("BandTurm2") or IsExisting("P5HQ") then
		StartCountdown(40,RespawnBanditsP5,false)
	end

	if P5attacking == false then
		if IsExisting("BandTurm1") then
			if not IsAlive("band_troop_1") then
				CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,4,GetPosition("band_pos_1"),"band_troop_1")
			end

			if not IsAlive("band_troop_2") then
				CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,8,GetPosition("band_pos_2"),"band_troop_2")
			end

			if not IsAlive("band_troop_3") then
				CreateMilitaryGroup(5,Entities.CU_Barbarian_LeaderClub1,4,GetPosition("band_pos_3"),"band_troop_3")
			end
		end
	end

	if P5attacking == false then
		if IsExisting("BandTurm2") then
			if not IsAlive("band_troop_4") then
				CreateMilitaryGroup(5,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("band_pos_4"),"band_troop_4")
			end

			if not IsAlive("band_troop_5") then
				CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,8,GetPosition("band_pos_5"),"band_troop_5")
			end

			if not IsAlive("band_troop_6") then
				CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,4,GetPosition("band_pos_6"),"band_troop_6")
			end

			if not IsAlive("band_troop_7") then
				CreateMilitaryGroup(5,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("band_pos_7"),"band_troop_7")
			end
		end
	end

	if IsExisting("P5HQ") then
		if not IsAlive("band_troop_8") then
			CreateMilitaryGroup(5,Entities.CU_BanditLeaderSword1,8,GetPosition("band_pos_8"),"band_troop_8")
		end

		if not IsAlive("band_troop_9") then
			CreateMilitaryGroup(5,Entities.CU_BanditLeaderBow1,4,GetPosition("band_pos_9"),"band_troop_9")
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function RespawnBanditsP6()

	if IsExisting("bBandTurm1") or IsExisting("bBandTurm2") or IsExisting("P6HQ") then
		StartCountdown(40,RespawnBanditsP6,false)
	end

	if P6attacking == false then
		if IsExisting("bBandTurm1") then
			if not IsAlive("bband_troop_1") then
				CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,4,GetPosition("bband_pos_1"),"bband_troop_1")
			end

			if not IsAlive("bband_troop_2") then
				CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,8,GetPosition("bband_pos_2"),"bband_troop_2")
			end

			if not IsAlive("bband_troop_3") then
				CreateMilitaryGroup(6,Entities.CU_Barbarian_LeaderClub1,4,GetPosition("bband_pos_3"),"bband_troop_3")
			end
		end
	end

	if P6attacking == false then
		if IsExisting("bBandTurm2") then
			if not IsAlive("bband_troop_4") then
				CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("bband_pos_4"),"bband_troop_4")
			end

			if not IsAlive("bband_troop_5") then
				CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,8,GetPosition("bband_pos_5"),"bband_troop_5")
			end

			if not IsAlive("bband_troop_6") then
				CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,4,GetPosition("bband_pos_6"),"bband_troop_6")
			end

			if not IsAlive("bband_troop_7") then
				CreateMilitaryGroup(6,Entities.CU_BlackKnight_LeaderMace1,4,GetPosition("bband_pos_7"),"bband_troop_7")
			end
		end
	end

	if IsExisting("P6HQ") then
		if not IsAlive("bband_troop_8") then
			CreateMilitaryGroup(6,Entities.CU_BanditLeaderSword1,8,GetPosition("bband_pos_8"),"bband_troop_8")
		end

		if not IsAlive("bband_troop_9") then
			CreateMilitaryGroup(6,Entities.CU_BanditLeaderBow1,4,GetPosition("bband_pos_9"),"bband_troop_9")
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function Mission_InitTechnologies()
    --no limitation in this map
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Set local resources
function Mission_InitLocalResources()
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	local InitGoldRaw	= 1500
	local InitClayRaw	= 1000
	local InitWoodRaw	= 1000
	local InitStoneRaw	= 800
	local InitIronRaw	= 800
	local InitSulfurRaw	= 500

	for i = 1,2 do
        Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

        ResearchTechnology(Technologies.GT_Mercenaries, i) --> Wehrpflicht
    end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_CheckStein()
	if IsDead("SteinSpreng") then
		DestroyEntity("SteinWeg1")
		DestroyEntity("SteinWeg2")
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function VictoryJob()
	if IsDead("P3HQ") and IsDead("P4HQ") and IsDead("P5HQ") and IsDead("P6HQ") then
		Victory()
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function SJ_DefeatP1()
	if IsDead("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("P2HQ") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
    AP{
        title	= "Intro",
        text	= "Wilkommen in diesen herrlichen Ländereien! Hier gibt es Rohstoffe zur Genüge. @cr @color:150,150,150 (Weiter mit Esc)"
    }
	AP{
        title	= "Intro",
        text	= "Leider haben Pilgrim und Salim sich einen unpassenden Moment ausgesucht, um über alte Zeiten zu plaudern - Mary de Mortfichet hat sich mit Kerberos verbündet. @cr @color:150,150,150 (Weiter mit Esc)"
    }
	AP{
        title	= "Intro",
        text	= "Die beiden sind wohl ebenso an den Rohstoffen interessiert, wie Ihr! Die Situation ist brenzlig für uns, doch gemeinsam solltet Ihr Euch behaupten können! @cr @color:150,150,150 (Weiter mit Esc)"
    }
	AP{
        title	= "Intro",
        text	= "Achtet auch auf nahegelegene Lager von Banditen und Wegelagerern! @cr @color:150,150,150 (Weiter mit Esc)"
    }
	AP{
        title	= "Intro",
        text	= "Viel Erfolg und vor allem: viel Spaß! @cr @cr @color:150,150,150 (Weiter mit Esc)"
    }
    StartBriefing(briefing)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Einzelspieler --------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function SetupKi2()
	-- Spieler 2 - Salim, nur für SP!
    MapEditor_SetupAI(2,1,999999,1,"P2HQ",3,0)
	SetupPlayerAi(2, {
	serfLimit = 12,
	extracting = 1,
	constructing = true,
	repairing = true,
	rebuild = {delay = 30, randomTime = 1},
	resources = {
        gold	= 1500,
        clay	= 2000,
        iron	= 800,
        sulfur	= 500,
        stone	= 2000,
        wood	= 2000},
	refresh = {
        gold		= 0,
        clay		= 0,
        iron		= 0,
        sulfur		= 0,
        stone		= 0,
        wood		= 10,
        updateTime	= 600}}
	)

	local constructionplanP2 = {
--		{ type = Entities.PB_VillageCenter1, pos = GetPosition("P2posDZ"), level = 1 },		-- Dorfzentrum
		{ type = Entities.PB_ClayMine1, pos = GetPosition("P2posLehm"), level = 1 },		-- Lehmmine
--		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
--		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_University1, pos = GetPosition("P2posUni"), level = 0 },		-- Hochschule
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_IronMine1, pos = GetPosition("P2posEisen"), level = 1 },		-- Eisenmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Sawmill1, pos = GetPosition("P2posUni"), level = 0 },			-- Sägemühle
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Brickworks1, pos = GetPosition("P2posLehm"), level = 1 },		-- Ziegelei
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 1 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Blacksmith1, pos = GetPosition("P2posEisen"), level = 2 },		-- Schmiede
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 1 },						-- Bank
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 1 },					-- Kaserne
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 2 },				-- Kathedrale
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 2 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 2 },				-- Haus
		{ type = Entities.PB_Beautification05, pos = invalidPosition, level = 0 },			-- Obelisk
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },					-- Schiessanlage
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 0 },					-- Reiterei
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_SulfurMine1, pos = GetPosition("P2posSchwefel"), level = 1 },	-- Schwefelmine
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 2 },					-- Turm
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 1 },					-- Kanonenm.
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },						-- Farm
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 1 },				-- Haus
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = GetPosition("P2HQ"), level = 2 },				-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },					-- Turm
		}
	FeedAiWithConstructionPlanFile(2,constructionplanP2)

	SetFriendly(1,2)
	SetHostile(2,3)
	SetHostile(2,4)
	SetHostile(2,5)
	SetHostile(2,6)

	StartCountdown(8*60,UpgradeSalim1,false)
end

function UpgradeSalim1()
	AI.Village_SetSerfLimit(2,16)

	if IsExisting("P2turmA") then UpgradeBuilding("P2turmA") end
	if IsExisting("P2turmB") then UpgradeBuilding("P2turmB") end
	if IsExisting("P2HQ") then UpgradeBuilding("P2HQ") end

	StartCountdown(15*60,UpgradeSalim2,false)
end

function UpgradeSalim2()
	AI.Village_SetSerfLimit(2,20)

	while GetStone(2) < 800 do
		AddStone(2,100)
	end

	while GetWood(2) < 800 do
		AddWood(2,100)
	end

	local researchplan = {
	{ type = Entities.PB_VillageCenter1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_University1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	StartCountdown(25*60,UpgradeSalim3,false)
end

function UpgradeSalim3()
	AI.Village_SetSerfLimit(2,24)

	if IsExisting("P2HQ") then UpgradeBuilding("P2HQ") end

	while GetStone(2) < 800 do
		AddStone(2,100)
	end

	while GetWood(2) < 800 do
		AddWood(2,100)
	end

	if IsExisting("P2turmC") then UpgradeBuilding("P2turmC") end
	if IsExisting("P2turmD") then UpgradeBuilding("P2turmD") end

	StartCountdown(20*60,UpgradeSalim4,false)
end

function UpgradeSalim4()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)

	ResearchTechnology(Technologies.T_SoftArcherArmor,2)
	ResearchTechnology(Technologies.T_LeatherMailArmor,2)

	StartCountdown(12*60,UpgradeSalim5,false)
end

function UpgradeSalim5()

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)

	ResearchTechnology(Technologies.T_SoftArcherArmor,2)
	ResearchTechnology(Technologies.T_LeatherMailArmor,2)

	StartCountdown(10*60,UpgradeSalim6,false)
end

function UpgradeSalim6()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)

	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)
	ResearchTechnology(Technologies.T_MasterOfSmithery,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(14*60,UpgradeSalim7,false)
end

function UpgradeSalim7()

	local researchplan = {
	{ type = Entities.PB_Sawmill1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,2)

	ResearchTechnology(Technologies.T_Fletching,2)
	ResearchTechnology(Technologies.T_WoodAging,2)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,2)
	ResearchTechnology(Technologies.T_ChainMailArmor,2)

	StartCountdown(20*60,UpgradeSalim8,false)
end


function UpgradeSalim8()

	local researchplan = {
	{ type = Entities.PB_Archery1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Stable1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_VillageCenter2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,2)
	ResearchTechnology(Technologies.T_FleeceArmor,2)
	ResearchTechnology(Technologies.T_LeadShot,2)

	StartCountdown(15*60,UpgradeSalim9,false)
end

function UpgradeSalim9()

	local researchplan = {
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower1, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
	{ type = Entities.PB_Tower2, prob = 100, command = UPGRADE },
    }

	FeedAiWithResearchPlanFile(2,researchplan)

	Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,2)
	Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,2)

	ResearchTechnology(Technologies.T_MasterOfSmithery,2)

end
-------------------------------------------------------------------------------------------------------------------------------------------------------

function UpgradeBuilding(_EntityName)
    -- Get entity's ID
    local EntityID = GetEntityId(_EntityName)
    -- Still existing?
    if IsValid(EntityID) then
        -- Get entity type and player
        local EntityType = Logic.GetEntityType(EntityID)
        local PlayerID = GetPlayer(EntityID)
        -- Get upgrade costs
        local Costs = {}
        Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
        -- Add needed resources
        for Resource, Amount in Costs do
            Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
        end
        -- Start upgrade
        GUI.UpgradeSingleBuilding(EntityID)
    end
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end