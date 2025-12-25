----------------------------------------------------------------------------------------------------
-- MapName: (3) Die großen Drei
-- Author: Play4FuN
-- 04/2018
-- v 1.2
----------------------------------------------------------------------------------------------------

gvMapText = ""..
		"@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @cr @color:166,212,35 P4F @color:230,0,240 @cr (3) Die großen Drei "
gvMapVersion = " v1.1 "

-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

	local R, G, B = GUI.GetPlayerColor(1)
	local rnd = R + G + B
	math.randomseed(rnd)	-- now we should get the same "random" results for every player

	TagNachtZyklus(24,0,0,0,1)
	StartTechnologies()

	UserTool_GetPlayerNameOrig = UserTool_GetPlayerName
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()
	gvMission.PlayerNames = {}
	local _pID
	for _pID = 1, 8 do
		gvMission.PlayerNames[_pID] = UserTool_GetPlayerNameOrig(_pID)
	end
	function UserTool_GetPlayerName(_PlayerID)
		if (_PlayerID > 0) and (_PlayerID < 9) then
			return gvMission.PlayerNames[_PlayerID]
	--	else
	--		return UserTool_GetPlayerNameOrig(_PlayerID)
		end
	end

	-- Init  global MP stuff
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()
--	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	if XNetwork.Manager_DoesExist() == 0 then
		--for i = 1, 3 do
			--MultiplayerTools.DeleteFastGameStuff(i)
		--end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	LocalMusic.UseSet = EUROPEMUSIC

	-- map stuff
	ActivateShareExploration(1, 2, true)
	ActivateShareExploration(1, 3, true)
	ActivateShareExploration(2, 3, true)

	_GlobalCounter = 0
	EEfound = false
	StartSimpleJob("VictoryJob")
	StartSimpleJob("SJ_DefeatP1")
	StartSimpleJob("SJ_DefeatP2")
	StartSimpleJob("SJ_DefeatP3")

	--[[Camera.ZoomSetFactorMax(2)	-- better zoom
	Camera.RotSetFlipBack(0)		-- free rotation
	Camera.RotSetAngle(-45)			-- standard value	--> without this command the map would start with the last used camera angle! (as flip back is turned off)
	Input.KeyBindDown(Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2)]]

	local n
	for n = 1, 6 do
		CreateWoodPile("Holzstapel"..n, 140000)
	end

	-- disable Mary, Varg, Kerberos
	BuyHeroWindow_Update_BuyHeroOrig = BuyHeroWindow_Update_BuyHero
	BuyHeroWindow_Update_BuyHero = function(_ent)
		BuyHeroWindow_Update_BuyHeroOrig(_ent)
		XGUIEng.DisableButton("BuyHeroWindowBuyHero7", 1)
		XGUIEng.DisableButton("BuyHeroWindowBuyHero8", 1)
		XGUIEng.DisableButton("BuyHeroWindowBuyHero9", 1)
	end

	BuyHeroWindow_Action_BuyHero_Orig = BuyHeroWindow_Action_BuyHero
	BuyHeroWindow_Action_BuyHero = function(_hero)
		BuyHeroWindow_Action_BuyHero_Orig(_hero)
		if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) < 2 then	-- amount to buy is updated very late!
			XGUIEng.ShowWidget("Buy_Hero", 0)	-- hide it after last hero has been bought (usually hides when HQ is selected again)
		else
			XGUIEng.ShowWidget(gvGUI_WidgetID.BuyHeroWindow, 1)	-- new: keep the menu open for as long as heroes can be bought
		end
	end

	InitColors()

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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 4 )
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
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
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

	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
	end
	Mission_InitLocalResources()
	--
	local tab = ChestRandomPositions.CreateChests(25)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	--
	PEACETIME = 35*60*gvDiffLVL
	MapLocal_StartCountDown(PEACETIME)	-- display a cooldown, no callback needed
	GUI.AddNote((PEACETIME/60).." Minuten Nichtangriffszeit!", 15)
	--
	StartSimpleJob("SJ_Timeline")	-- for (AI upgrades) and map stuff
	--
	for i = 4, 6 do
		MapEditor_SetupAI(i, round(4-gvDiffLVL), 99999, 0, "P".. i .."_HQ", 3, PEACETIME)
	end
	--(_pID, _pName, _HQ, _strength, _position, _armyCount(max possible), _aggressiveness (0 - ~20), _peacetime, _allies, _enemies)
	SetupKI(4, "Kerberos", "P4_HQ", 3, "P4_HQ", 6, 14, PEACETIME, {5,6}, {1,2,3})
	SetupKI(5, "Varg", "P5_HQ", 3, "P5_HQ", 6, 12, PEACETIME, {4,6}, {1,2,3})
	SetupKI(6, "Mary De Mortfichet", "P6_HQ", 6, "P6_HQ", 12, 6, PEACETIME, {4,5}, {1,2,3})
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
function InitColors()
	col = {}
	-- Reihenfolge: Rot,GrÃ¼n,Blau
	col.w		= " @color:255,255,255 "
	col.gruen	= " @color:0,255,0 "
	col.blau	= " @color:20,20,240 "
	col.P4F		= " @color:166,212,35 "
	col.grau	= " @color:180,180,180 "
	col.dgrau	= " @color:120,120,120 "
	col.beig	= " @color:240,220,200 "
	col.gelb 	= " @color:255,200,0 "
	col.hgelb 	= " @color:238,221,130 "
	col.orange 	= " @color:255,127,0 "
	col.rot		= " @color:255,0,0 "
	col.hgruen	= " @color:173,255,47 "
	col.hblau 	= " @color:0,255,255 "
	col.pink	= " @color:200,100,200 "
	col.transp	= " @color:0,0,0,0 "
	col.keyb	= " @color:220,220,150 "
	col.schwarz	= " @color:40,40,40 "
	col.blauFIX	= " @color:50,50,220 "
	col.gruenFIX= " @color:0,200,0 "

end

----------------------------------------------------------------------------------------------------
-- Limit the Technologies here. For example Weathermashine.
function Mission_InitTechnologies()
end
function StartTechnologies()
	for i = 1,2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end

----------------------------------------------------------------------------------------------------
-- Set local resources
function Mission_InitLocalResources()

	--local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	-- Initial Resources
	local InitGoldRaw 		= dekaround(800*gvDiffLVL)
	local InitClayRaw 		= dekaround(1200*gvDiffLVL)
	local InitWoodRaw 		= dekaround(1200*gvDiffLVL)
	local InitStoneRaw 		= dekaround(800*gvDiffLVL)
	local InitIronRaw 		= dekaround(500*gvDiffLVL)
	local InitSulfurRaw		= dekaround(500*gvDiffLVL)


	--Add Players Resources
	local i
	for i = 1, 3 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
		--ForbidTechnology(Technologies.UP2_Village, i)
		--ResearchTechnology(Technologies.T_Shoes, i)
	end
end

----------------------------------------------------------------------------------------------------
-- trigger some events
function SJ_Timeline()
	_GlobalCounter = _GlobalCounter + 1

	if _GlobalCounter == 3 then
		-- 0 = not in the game
		local m
		for m = 1, 3 do
			if Logic.PlayerGetGameState(m) == 0 then
				EnableAIforPlayer(m)
			else
				RenamePlayer(m, UserTool_GetPlayerName(m), true)
			end
		end
		SetFriendly(1, 2)
		SetFriendly(1, 3)
		SetFriendly(2, 3)

		local a, b
		for a = 1, 3 do
			for b = 4, 6 do
				SetHostile(a, b)
			end
		end

	elseif _GlobalCounter == 30 then
		local p
		for p = 4, 6 do
			AddGold(p, 500)
			AddWood(p, 500)
			AddClay(p, 500)
			AddStone(p, 500)
			AddIron(p, 500)
			AddSulfur(p, 500)
		end

	elseif _GlobalCounter == 10*60 then
		local m
		for m = 1, 3 do
			if Logic.PlayerGetGameState(m) == 0 then
				AI.Village_SetSerfLimit(m, 32)
			end
			AI.Village_SetSerfLimit(m+3, 32)
		end

	elseif _GlobalCounter == 15*60 then
		local m
		for m = 1, 3 do
			if Logic.PlayerGetGameState(m) == 0 then
				AI.Village_SetSerfLimit(m, 40)
			end
			AI.Village_SetSerfLimit(m+3, 40)
		end

	elseif _GlobalCounter == 20*60 then
		local m
		for m = 1, 3 do
			if Logic.PlayerGetGameState(m) == 0 then
				AI.Village_SetSerfLimit(m, 60)
			end
			AI.Village_SetSerfLimit(m+3, 60)
		end

	elseif _GlobalCounter == PEACETIME then
		RemoveBarriers()

	elseif _GlobalCounter == 31*60 then	-- do not use the same time as PEACETIME!
		local p
		for p = 4, 6 do
			AddGold(p, 100)
			AddWood(p, 1000)
			AddClay(p, 1000)
			AddStone(p, 1000)
			AddIron(p, 1000)
			AddSulfur(p, 1000)
		end

	elseif _GlobalCounter == 40*60 then
		local p
		for p = 4, 6 do
			AddGold(p, 100)
			AddWood(p, 1000)
			AddClay(p, 1000)
			AddStone(p, 1000)
			AddIron(p, 1000)
			AddSulfur(p, 1000)
		end

	elseif _GlobalCounter == 48*60 then
		local m
		for m = 1, 3 do
			if Logic.PlayerGetGameState(m) == 0 then
				AI.Village_SetSerfLimit(m, 30)
			end
			AI.Village_SetSerfLimit(m+3, 30)
		end

	elseif _GlobalCounter == 50*60 then
		local p
		for p = 4, 6 do
			AddGold(p, 1000)
			AddWood(p, 2000)
			AddClay(p, 2000)
			AddStone(p, 2000)
			AddIron(p, 2000)
			AddSulfur(p, 2000)
		end

	elseif _GlobalCounter == round(75*60*gvDiffLVL) then
		local p
		for p = 4, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(8/gvDiffLVL)
		end

	elseif _GlobalCounter == round(120*60*gvDiffLVL) then
		local p
		for p = 4, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(8/gvDiffLVL)
		end

	elseif _GlobalCounter == round(180*60*gvDiffLVL) then
		local p
		for p = 4, 6 do
			MapEditor_Armies[p].offensiveArmies.strength = MapEditor_Armies[p].offensiveArmies.strength + round(8/gvDiffLVL)
		end

		return true
	end

	if XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer() == 3 then
		if (Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PU_Serf) == 42)
		and (Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PU_Serf) == 42)
		and (Logic.GetNumberOfEntitiesOfTypeOfPlayer(1, Entities.PU_Serf) == 42) then
			if not EEfound then
				EEfound = true
				SpecialTribute()
			end
		end
	end

end

----------------------------------------------------------------------------------------------------
function SpecialTribute()
	local tribute =  {}
	tribute.playerId = 1
	tribute.text = "- CHEAT: Deckt alle Gegner auf -"
	tribute.cost = { Gold = 0 }
	tribute.Callback = SpecialTributePaid
	AddTribute(tribute)
end

function SpecialTributePaid()
	for j = 1, 3 do
		for k = 4, 6 do
			Logic.SetShareExplorationWithPlayerFlag(j, k, 1)
		end
	end
	Message("Ihr habt es so gewollt ...")
end

----------------------------------------------------------------------------------------------------
-- remove barriers after peacetime end
function RemoveBarriers()

	local i

	for i = 1, 6 do

		DestroyEntity("Barriere"..i)

	end

	Message("@color:220,64,16,255 Achtung: Der Weg zum Gegner ist nun offen!")
	Sound.PlayGUISound(Sounds.fanfare, 80)

end

----------------------------------------------------------------------------------------------------
-- victory condition
function VictoryJob()
	if IsDead("P4_HQ") and IsDead("P5_HQ") and IsDead("P6_HQ") then
		Victory()
		return true
	end
end

----------------------------------------------------------------------------------------------------
function SetupKI(_pID, _pName, _HQ, _strength, _position, _armyCount, _aggressiveness, _peacetime, _allies, _enemies)

	if KI == nil then
		KI = {}
	end

	if KI[_pID] == nil then
		KI[_pID] = {}
	end

	-- Setup data for KI
	KI[_pID] = {}

	KI[_pID].player		= _pID
	KI[_pID].hq			= _HQ
	KI[_pID].position	= _position
	KI[_pID].strength	= _strength
	KI[_pID].armyCount	= _armyCount
	KI[_pID].aggressivenes	= _aggressiveness
	KI[_pID].range		= _range
	KI[_pID].allies		= _allies
	KI[_pID].enemies	= _enemies
	KI[_pID].peacetime	= _peacetime
	KI[_pID].name		= _pName
	KI[_pID].serfLimit	= 15
	KI[_pID].uptimeLow	= 60*35 + math.random(1, 150)
	KI[_pID].uptimeMedium	= 60*45 + math.random(1, 310)
	KI[_pID].uptimeHigh	= 60*55 + math.random(1, 410)
	KI[_pID].uptimeHQ1	= 60*15 + math.random(1, 450)
	KI[_pID].uptimeHQ2	= 60*25 + math.random(1, 600)
	KI[_pID].helpRequestTime	= 0
	KI[_pID].defeated	= false

	SetupPlayerAi( _pID, {
    serfLimit = KI[_pID].serfLimit,
    extracting = 1,
    rebuild = {
        delay		= 10 * math.ceil((5 - _strength)/2),
        randomTime	=  5 * math.ceil((5 - _strength)/2)
    },
    repairing = true,
    constructing = true
	})
	KI_SetupConstructing(_pID)

	KI_SetupResearch(_pID)

	KI_SetupDefeatCondition(_pID)

	-- Set diplomacy
	RenamePlayer(_pID, _pName, true)
	if _allies ~= nil then
		for index = 1, table.getn(_allies) do
			if index ~= _pID then
				SetFriendly(_pID, _allies[index])
--				DebugMessage("friendly: ".._pID.." and ".._allies[index])
			end
		end
	end
	if _enemies ~= nil then
		for index = 1, table.getn(_enemies) do
			if index ~= _pID then
				SetHostile(_pID, _enemies[index])
--				DebugMessage("hostile: ".._pID.." and ".._enemies[index])
			end
		end
	end

	Logic.PlayerSetIsHumanFlag(_pID, 1)	-- write statistics
end

-- v3
function RenamePlayer(_pID, _pName, _colorFlag)

	gvMission.PlayerNames[_pID] = _pName
	local R, G, B = GUI.GetPlayerColor( _pID )
	if _colorFlag then
		SetPlayerName(_pID, "@color:"..R..","..G..","..B.." ".._pName)
	end
	Logic.PlayerSetPlayerColor(_pID, R, G, B)
end

----------------------------------------------------------------------------------------------------
function KI_SetupConstructing(_pID)
	if KI[_pID].Buildings == nil then
		KI[_pID].Buildings = {}
		KI[_pID].Buildings[1]	= Entities.PB_University1
		KI[_pID].Buildings[2]	= Entities.PB_Sawmill1
		KI[_pID].Buildings[3]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[4]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[5]	= Entities.PB_StoneMason1
		KI[_pID].Buildings[6]	= Entities.PB_Alchemist1
		KI[_pID].Buildings[7]	= Entities.PB_GunsmithWorkshop1
		KI[_pID].Buildings[8]	= Entities.PB_Bank1
		KI[_pID].Buildings[9]	= Entities.PB_Market1
		KI[_pID].Buildings[10]	= Entities.PB_Monastery1
		KI[_pID].Buildings[11]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[12]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[13]	= Entities.PB_Bank1
		KI[_pID].Buildings[14]	= Entities.PB_Bank1
		KI[_pID].Buildings[15]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[16]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[17]	= Entities.PB_Tower1
		KI[_pID].Buildings[18]	= Entities.PB_Tower1
		KI[_pID].Buildings[19]	= Entities.PB_Tower1
		KI[_pID].Buildings[20]	= Entities.PB_Tower1
		KI[_pID].Buildings[21]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[22]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[23]	= Entities.PB_Bank1
		KI[_pID].Buildings[24]	= Entities.PB_Market1
		KI[_pID].Buildings[25]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[26]	= Entities.PB_Blacksmith1
		KI[_pID].Buildings[27]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[28]	= Entities.PB_Brickworks1
		KI[_pID].Buildings[29]	= Entities.PB_Brickworks1
	end

	if KI[_pID].BuildingsUsed == nil then
		KI[_pID].BuildingsUsed = {}

		local i

		for i = 1, table.getn(KI[_pID].Buildings) do
			KI[_pID].BuildingsUsed[i] = 0
		end
	end

	for j = 1, table.getn(KI[_pID].Buildings) do
		local rnd
		repeat rnd = math.random(1, table.getn(KI[_pID].Buildings)) until
		KI[_pID].BuildingsUsed[rnd] == 0

		if (rnd == 5) or (rnd == 10) then
			KI_BuildMilitaryWithTower(_pID, "Barracks", 1)
		end
		if (rnd == 15) then
			KI_BuildMilitaryWithTower(_pID, "Archery", 1)
		end

		KI_BuildWorkPlace(_pID, KI[_pID].Buildings[rnd])
		KI[_pID].BuildingsUsed[rnd] = 1
	end

	KI_BuildMilitaryWithTower(_pID, "Barracks", 1)
	KI_BuildMilitaryWithTower(_pID, "Archery", 1)

	if KI[_pID].strength > 2 then
		KI_BuildMilitaryWithTower(_pID, "Barracks", 1)
		KI_BuildMilitaryWithTower(_pID, "Archery", 1)
	end

	KI_BuildMilitaryWithTower(_pID, "Stable", 1)
	KI_BuildMilitaryWithTower(_pID, "Foundry", 1)

	if KI[_pID].strength > 2 then
		KI_BuildMilitaryWithTower(_pID, "Stable", 1)
		KI_BuildMilitaryWithTower(_pID, "Foundry", 1)
	end

	--
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_pID, Entities.PB_University1) +
	Logic.GetNumberOfEntitiesOfTypeOfPlayer(_pID, Entities.PB_University2) < 1 then
		KI_StartBuild(_pID, Entities.PB_University1, KI[_pID].position, 0)
		KI_StartBuild(_pID, Entities.PB_Farm1, 0, 0)
		KI_StartBuild(_pID, Entities.PB_Residence1, 0, 0)
	end
	--

	KI_BuildWorkPlace(_pID, Entities.PB_Brickworks1)
	KI_BuildWorkPlace(_pID, Entities.PB_Brickworks1)
	KI_BuildWorkPlace(_pID, Entities.PB_Blacksmith1)
	KI_BuildWorkPlace(_pID, Entities.PB_Sawmill1)

	-- do not rebuild this less important buildings; does it work???
	AI.Village_IgnoreReconstructionForBuildingType(_pID, Entities.PB_Farm1)
	AI.Village_IgnoreReconstructionForBuildingType(_pID, Entities.PB_Residence1)

	KI_SetupUpgradeBehaviour(_pID)

end

function KI_SetupUpgradeBehaviour(_pID)
	Trigger.RequestTrigger(
					Events.LOGIC_EVENT_EVERY_SECOND,		-- 131077 (trigger type)
					"",										-- condition function
					"KI_UpgradeJob",						-- action function
					1,										-- is active
					nil,									-- table for condition function
					{_pID}									-- table for action function
					)
end

function KI_UpgradeJob(_pID)
	if Counter.Tick2("KI_UpgradeJob".._pID, 20) then
		local _time = round(Logic.GetTime())
		if _time < 10*60 then	-- 10 min
			return
		elseif _time < 40*60 then	-- 40 min
			-- try to upgrade a building
			KI_TryUpgrade(_pID, KI_UpgradeBuildingsSecondary[math.random(1, table.getn(KI_UpgradeBuildingsSecondary))])
		elseif _time < 60*60 then	-- 60 min
			KI_TryUpgrade(_pID, KI_UpgradeBuildingsImportant[math.random(1, table.getn(KI_UpgradeBuildingsImportant))])
		elseif _time < 90*60 then	-- 90 min
			KI_TryUpgrade(_pID, KI_UpgradeBuildingsLateGame[math.random(1, table.getn(KI_UpgradeBuildingsLateGame))])
		else
			return true
		end
	end
end

----------------------------------------------------------------------------------------------------
function KI_TryUpgrade(_pID, _type)
	if KI[_pID] == nil then
		return
	end
	local buildings = {Logic.GetPlayerEntities(_pID, _type, 40)}
	if buildings[1] == 0 then
		return
	end
	for i = 1, buildings[1] do
		if Logic.IsConstructionComplete(buildings[i+1]) == 1 then
			AI.Village_StartResearch(_pID, _type, 100, 0)
		-- Param1: Player Id. Param2: Building Type Id / Technology Id. Param3: Probability (0-100%). Param4: Command(0-Upgrade Building,1-Technology). Param5: Upgrade Category(=Location).
--			Message("KI ".._pID.." upgrade "..Logic.GetEntityTypeName(_type))
			break
		end
	end

end

----------------------------------------------------------------------------------------------------
function KI_SetupResearch(_pID)	-- dynamic troop upgrades
	Trigger.RequestTrigger(
		Events.LOGIC_EVENT_EVERY_SECOND,		-- 131077 (trigger type)
		"",										-- condition function
		"KI_ResearchJob",						-- action function
		1,										-- is active
		nil,									-- table for condition function
		{_pID}									-- table for action function
		)
end

function KI_ResearchJob(_pID)
	if KI[_pID].defeated == true then
		return true
	end
	-- DONT USE ELSE HERE! RANDOM UPTIME VALUES MIGHT BE THE SAME -> A SECOND HIT AT A TIME WOULD NEVER BE TRIGGERED!
	local _time = round(Logic.GetTime())
	if _time == KI[_pID].uptimeLow then
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, _pID)
	end
	if _time == KI[_pID].uptimeMedium then
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, _pID)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks, _pID)
		ResearchTechnology(Technologies.T_BetterTrainingArchery, _pID)
		ResearchTechnology(Technologies.Research_BetterChassis, _pID)
	end
	if _time == KI[_pID].uptimeHigh then
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry, _pID)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle, _pID)
	end
	if _time == KI[_pID].uptimeHQ1 then
		UpgradeBuilding(KI[_pID].hq)
	end
	if _time == KI[_pID].uptimeHQ2 then
		UpgradeBuilding(KI[_pID].hq)
	end
end

----------------------------------------------------------------------------------------------------
function KI_SetupDefeatCondition(_pID)
	Trigger.RequestTrigger(
		Events.LOGIC_EVENT_EVERY_SECOND,		-- 131077 (trigger type)
		"",										-- condition function
		"KI_DefeatJob",							-- action function
		1,										-- is active
		nil,									-- table for condition function
		{_pID}									-- table for action function
		)
end

function KI_DefeatJob(_pID)
	if IsDead(KI[_pID].hq) then
		KI[_pID].defeated = true
		AI.Village_DeactivateRebuildBehaviour(_pID)
		AI.Village_ClearConstructionQueue(_pID)
		return true
	end
end

----------------------------------------------------------------------------------------------------
-- AI allies
function EnableAIforPlayer(pID)

	HQpos = {}
	HQpos[1] = {X = 23200, Y = 9700}
	HQpos[2] = {X = 42600, Y = 7300}
	HQpos[3] = {X = 12400, Y = 32500}

	-- recreate HQ
	if IsDead("P"..pID.."_HQ") then
		SetEntityName(Logic.CreateEntity(Entities.PB_Headquarters1, HQpos[pID].X, HQpos[pID].Y, 0, pID), "P"..pID.."_HQ")
	end

	-- destroy additional VC;
	DestroyEntity("VC"..pID)
	DestroyEntity("VC"..pID.."b")

	MapEditor_SetupAI(pID, 3, Logic.WorldGetSize(), 1, "P".. pID .."_HQ", 3, PEACETIME)
	SetupKI(pID, "Verbündeter".. pID, "P".. pID .."_HQ", 3, "P".. pID .."_HQ", 6, 14, PEACETIME, {1,2,3}, {4,5,6})
	GUI.AddNote("KI für Spieler "..pID.." aktiviert!", 12)
end

----------------------------------------------------------------------------------------------------
function KI_BuildWorkPlace(_pID, _type)

	KI_StartBuild(_pID, _type, KI[_pID].position, 0)

	KI_StartBuild(_pID, Entities.PB_Farm1, 0, 0)
	KI_StartBuild(_pID, Entities.PB_Residence1, 0, 0)

end

----------------------------------------------------------------------------------------------------
-- KI baut einzelne GebÃ¤ude, wenn dieser Aufruf einzeln im Skript folgt, sollte Warteschlange fÃ¼r GebÃ¤ude speichern, wenn eines nicht sofort gebaut wird
function KI_StartBuild(_pID, _type, _pos, _level)

	if KI[_pID].defeated == true then
		return
	end
	local _position
	if _pos == 0 then
		_position = invalidPosition
	else
		if type(_pos) == "table" then
			_position = {}
			_position.X = _pos.X
			_position.Y = _pos.Y

		elseif type(_pos) == "string" then
			_position = GetPosition(_pos)
		end
	end

	local _constructionplan = {{ type = _type, pos = _position, level = (_level or 0) }}
	FeedAiWithConstructionPlanFile(_pID, _constructionplan)
end

----------------------------------------------------------------------------------------------------
function KI_BuildMilitaryWithTower(_pID, _type, _amount)

	if _amount == nil then
		_amount = 0
	end

	if _type == "Barracks" then

		KI_StartBuild(_pID, Entities.PB_Barracks1, KI[_pID].position, 0)

	elseif _type == "Archery" then

		KI_StartBuild(_pID, Entities.PB_Archery1, KI[_pID].position, 0)

	elseif _type == "Stable" then

		KI_StartBuild(_pID, Entities.PB_Stable1, KI[_pID].position, 0)

	elseif _type == "Foundry" then

		KI_StartBuild(_pID, Entities.PB_Foundry1, KI[_pID].position, 0)

	end

	if _amount ~= 0 then
		for i = 1, _amount do
			KI_StartBuild(_pID, Entities.PB_Tower1, 0, 1)
		end
	end

end

----------------------------------------------------------------------------------------------------
function SJ_DefeatP1()
	if IsDead("P1_HQ") then
		Logic.PlayerSetGameStateToLost(1)
		return true
	end
end

function SJ_DefeatP2()
	if IsDead("P2_HQ") then
		Logic.PlayerSetGameStateToLost(2)
		return true
	end
end

function SJ_DefeatP3()
	if IsDead("P3_HQ") then
		Logic.PlayerSetGameStateToLost(3)
		return true
	end
end

----------------------------------------------------------------------------------------------------
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
		-- new: check if upgrade possible! (all values 0 = no upgrade for this building; here 17)
		if IsTableNotNull(Costs) then Message("error: ") return end
        -- Add needed resources
        for Resource, Amount in Costs do
            Logic.AddToPlayersGlobalResource(PlayerID, Resource, Amount)
        end
        -- Start upgrade
        GUI.UpgradeSingleBuilding(EntityID)
    end
end

----------------------------------------------------------------------------------------------------
function IsTableNotNull(_t)

	assert( type( _t ) == "table", "must be a table value" )
	for i = 1, table.getn(_t) do
		if _t[i] ~= 0 then
			return false
		end
	end
	return true

end

----------------------------------------------------------------------------------------------------
-- some tables with buildings depending on importance and state of the game
KI_UpgradeBuildingsImportant = {
Entities.PB_Tower1,
Entities.PB_Tower2,
Entities.PB_Barracks1,
Entities.PB_Archery1,
Entities.PB_Stable1,
Entities.PB_Foundry1,
}

KI_UpgradeBuildingsSecondary = {
Entities.PB_Bank1,
Entities.PB_Sawmill1,
Entities.PB_Brickworks1,
Entities.PB_ClayMine1,
Entities.PB_StoneMine1,
Entities.PB_IronMine1,
Entities.PB_SulfurMine1,
Entities.PB_Monastery1,
Entities.PB_Market1,
Entities.PB_Farm1,
Entities.PB_Residence1,
Entities.PB_Blacksmith1,
Entities.PB_Blacksmith1,
Entities.PB_GunsmithWorkshop1,
--Entities.PB_VillageCenter1,	--#?
--Entities.PB_VillageCenter2,
}

KI_UpgradeBuildingsLateGame = {
Entities.PB_Tower1,
Entities.PB_Tower1,
Entities.PB_Tower2,
Entities.PB_Tower2,
Entities.PB_Farm2,
Entities.PB_Residence1,
Entities.PB_Residence2,
Entities.PB_ClayMine2,
Entities.PB_StoneMine2,
Entities.PB_IronMine2,
Entities.PB_SulfurMine2,
Entities.PB_Monastery2,
Entities.PB_Blacksmith1,
Entities.PB_Blacksmith2,
Entities.PB_Blacksmith2,
Entities.PB_Barracks1,
Entities.PB_Archery1,
Entities.PB_Stable1,
}