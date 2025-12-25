--------------------------------------------------------------------------------
-- MapName: Darkpyramide
--------------------------------------------------------------------------------

gvDiffLVL = 0
gvMapText = ""..
		"@color:0,0,0,0 .............. @color:255,0,10 Menü @cr "..
		" @cr @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr (2) Die dunklen Pyramiden "
gvMapVersion = " v1.1 "
-- Include main function
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()
	-- custom Map Stuff
	TagNachtZyklus(24,0,0,0,1)
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

	-- Init  global MP stuff
	--MultiplayerTools.InitResources("normal")
	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	Hauptaufgabe()
	StartCountdown(1,CreatePreludeBriefing,false)
	StartCountdown(10,TributeForMainquest,false)
	StartCountdown(12,DifficultyVorbereitung,false)
	--
	StartTechnologies()
	SetPlayerEntitiesNonSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.SuspendEntity(eID)
	end
	Erinnerung = StartCountdown(45,Denkanstoss,false)
	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
			StartCountdown(2,Wechsel,false)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	--
	SetPlayerDiplomacy({1,2}, Diplomacy.Friendly)
	--
	for i = 1, 2 do
		for k = 1, 2 do
			if i ~= k then
				ActivateShareExploration(i, k, true)
			end
		end
	end
	--
	LocalMusic.UseSet = EVELANCEMUSIC
	--
	Display.SetPlayerColorMapping(8, NPC_COLOR)
	Display.SetPlayerColorMapping(3, ROBBERS_COLOR)
	Display.SetPlayerColorMapping(4, KERBEROS_COLOR)
	Display.SetPlayerColorMapping(5, 2)

end
function Wechsel()
	Logic.ChangeAllEntitiesPlayerID(2,1)
end
function Hauptaufgabe()
	TributeIDs = {}
	local tribute =  {}
	tribute.playerId = 8
	tribute.text = " "
	tribute.cost = { Gold = 0 }
	for player = 1, 2 do
		tribute.Callback = AddMainquestForPlayer(player)
		TributeIDs[player] = AddTribute(tribute)
		tribute.Tribute = nil
	end
end
function TributeForMainquest()
	for player = 1, 2 do
		GUI.PayTribute(8, TributeIDs[player])
	end
end
function AddMainquestForPlayer(_player)
	Logic.AddQuest(_player,1,MAINQUEST_OPEN,"Missionsziele","Baut Eure Siedlungen auf und verteidigt sie gegen mögliche Angriffe! @cr @cr Zerst\195\182re die 3 Dark Castles von Kerbereos, Varg und Mary de Mortfichet! @cr @cr @color:230,100,0 Spieler 1 kann den Spielmodus über das Tributmenü bestimmen!",1)
end
function DifficultyVorbereitung()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde!")
	Schwierigkeitsgradbestimmer()
end
--
function Denkanstoss()
	Message("@color:230,100,0 Bestimme den Spielmodus für diese Runde, damit das Spiel endlich starten kann!")
end
--
function Schwierigkeitsgradbestimmer()
	Tribut1()
	Tribut2()
	Tribut3()
end
function Tribut1()
	local TrMod0 =  {}
	TrMod0.playerId = 1
	TrMod0.text = "Spielmodus @color:30,250,30 <<Kooperation/Leicht>>! "
	TrMod0.cost = { Gold = 0 }
	TrMod0.Callback = SpielmodKoop0
	TMod0 = AddTribute(TrMod0)
end
function Tribut2()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	TrMod1.text = "Spielmodus @color:0,250,200 <<Kooperation/Normal>>! "
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = SpielmodKoop1
	TMod1 = AddTribute(TrMod1)
end
function Tribut3()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	TrMod2.text = "Spielmodus @color:250,30,30 <<Kooperation/Schwer>>! "
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = SpielmodKoop2
	TMod2 = AddTribute(TrMod2)
end
function VictoryJob()
	if IsDead("P2_AI_HQ")and IsDead("P3_AI_HQ") and IsDead("P4_AI_HQ") then
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(3,4,5), CEntityIterator.OfCategoryFilter(EntityCategories.Soldier)) do
			return false
		end
		Victory()
		return true
	end
end
function StartTechnologies()
	for i = 1, 2 do
		ForbidTechnology(Technologies.MU_Serf,i)
		ForbidTechnology(Technologies.T_Tracking,i)
	end
end
function SpielmodKoop0()
	Message("Ihr habt den @color:30,250,30 <<LEICHTEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod2)
	--
	gvDiffLVL = 3
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 3 )
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:30,250,30 LEICHT @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
end
function SpielmodKoop1()
	Message("Ihr habt den @color:0,250,200 <<NORMALEN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod2)
	Logic.RemoveTribute(1,TMod0)
	--
	gvDiffLVL = 2
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 2 )
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:0,250,200 NORMAL @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
end


function SpielmodKoop2()
	Message("Ihr habt den @color:250,30,30 <<SCHWEREN KOOPERATIONSMODUS>> @color:255,255,255 gewählt")
	--
	Sound.PlayGUISound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01,120)
	--
	Logic.RemoveTribute(1,TMod1)
	Logic.RemoveTribute(1,TMod0)
	--
	gvDiffLVL = 1
	--
	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 1 )
	--
	XGUIEng.SetText("TopMainMenuTextButton", gvMapText.." @color:250,30,30 SCHWER @cr "..
		" @color:230,0,240 "..gvMapVersion)
	--
	StopCountdown(Erinnerung)
	--
	StartInitialize()
end
function StartInitialize()

	SetPlayerEntitiesSelectable()
	for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerFilter()) do
		Logic.ResumeEntity(eID)
	end
	--
	StartCountdown((70*gvDiffLVL-30)*60,EliteSpawnInit,false)
	--
	StartSimpleJob("VictoryJob")

	local tab = ChestRandomPositions.CreateChests()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"", "ChestRandomPositions_ChestControl",1,{},{unpack(tab)})
	for i = 1,2 do
		AllowTechnology(Technologies.MU_Serf,i)
		AllowTechnology(Technologies.T_Tracking,i)
		if GetGold(i) > 0 then
			AddGold(i,-(GetGold(i)))
		end
		if GetClay(i) > 0 then
			AddClay(i,-(GetClay(i)))
		end
		if GetIron(i) > 0 then
			AddIron(i,-(GetIron(i)))
		end
		if GetStone(i) > 0 then
			AddStone(i,-(GetStone(i)))
		end
		if GetSulfur(i) > 0 then
			AddSulfur(i,-(GetSulfur(i)))
		end
		if GetWood(i) > 0 then
			AddWood(i,-(GetWood(i)))
		end
	end
	SetHumanPlayerDiplomacyToAllAIs({1,2}, Diplomacy.Hostile)
	SetNeutral(1,8)
	SetNeutral(2,8)

	Mission_InitLocalResources()
	Mission_InitTechnologies()
	--
	StartSimpleJob("enablePyramidennebel");
	StartSimpleJob("Help");
	StartSimpleJob("Bonus1");
	StartSimpleJob("Bonus2");
	StartSimpleJob("Kermit");

	-- AI5
	local aiID = 5;
	local strength = round(3/gvDiffLVL);
	local range = 4000;
	local techlevel = 3;
	local position = "P2_AI_HQ";
	local aggressiveness = 3;
	local peacetime = 0;
	MapEditor_SetupAI(aiID, strength, range, techlevel, position, aggressiveness, peacetime);
	MapEditor_Armies[aiID].offensiveArmies.strength = round(MapEditor_Armies[aiID].offensiveArmies.strength * 0.8)
	SetupPlayerAi(aiID, { extracting = 1 });
	SetupPlayerAi(aiID, { repairing = 1 });
	SetPlayerName(aiID, "juja mary");
	ConnectLeaderWithArmy(GetID("Mary"), nil, "offensiveArmies")
	StartCountdown((3+(3*gvDiffLVL))*60, AIAggressive, false, nil, aiID)

	-- AI3
	local aiID = 3;
	local strength = round(3/gvDiffLVL);
	local range = 16500;
	local techlevel = 3;
	local position = "P3_AI_HQ";
	local aggressiveness = 3;
	local peacetime = 0;
	MapEditor_SetupAI( aiID, strength, range, techlevel, position, aggressiveness, peacetime);
	MapEditor_Armies[aiID].offensiveArmies.strength = round(MapEditor_Armies[aiID].offensiveArmies.strength * 0.8)
	SetupPlayerAi(aiID, { extracting = 1 });
	SetupPlayerAi(aiID, { repairing = 1 });
	SetPlayerName(aiID, "Varg SpiderFive");
	StartCountdown(12*60*gvDiffLVL, AIAggressive, false, nil, aiID)

	-- AI4
	local aiID = 4;
	local strength = round(3/gvDiffLVL);
	local range = 13500;
	local techlevel = 3;
	local position = "P4_AI_HQ";
	local aggressiveness = 3;
	local peacetime = 0;
	MapEditor_SetupAI(aiID, strength, range, techlevel, position, aggressiveness, peacetime);
	SetupPlayerAi(aiID, { extracting = 1 });
	SetupPlayerAi(aiID, { repairing = 1 });
	SetPlayerName(aiID, "Kerberos Bangolos");
	StartCountdown(24*60*gvDiffLVL, AIAggressive, false, nil, aiID)

	for i = 3,5 do
		ResearchAllTechnologies(AI, false, false, false, true, false)
	end
	StartCountdown(10*gvDiffLVL*60, IncreaseAIStrength, false)
	-- Mercenary
	InitMerchant()
end
function AIAggressive(_Player)
	MapEditor_Armies[_Player].offensiveArmies.rodeLength = Logic.WorldGetSize()
end
function IncreaseAIStrength()
	for i = 3,5 do
		MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + 1
	end
	StartCountdown(10*gvDiffLVL*60, IncreaseAIStrength, false)
end
function InitMerchant()
	local mercTent = GetEntityId("MercTent1");
	Logic.AddMercenaryOffer(mercTent, Entities.PU_LeaderBow4, 13, ResourceType.Gold, 750);
	Logic.AddMercenaryOffer(mercTent, Entities.PU_LeaderRifle2, 10, ResourceType.Stone, 1000);
	Logic.AddMercenaryOffer(mercTent, Entities.PU_LeaderRifle2, 10, ResourceType.Wood, 750);
	Logic.AddMercenaryOffer(mercTent, Entities.PU_LeaderHeavyCavalry2, 10, ResourceType.Wood, 750);
	--
	function CalculateMercenaryOfferCosts(_type)
		local lcost, solcost = {}, {}
		Logic.FillLeaderCostsTable(1, _type + 2 ^ 16, lcost)
		local maxsol = MaxSoldiersByLeaderType[_type]
		if maxsol and maxsol > 0 then
			local soletype = GetEntityTypeSoldierType(_type)
			Logic.FillSoldierCostsTable(1, soletype + 2 ^ 16, solcost)
		end

		local total = 0
		for i = 1, 17 do
			if i == ResourceType.Silver then
				lcost[i] = lcost[i] * 20
			end
			total = total + lcost[i] + ((solcost[i] and solcost[i] * maxsol) or 0)
		end
		return round(total * (1-(gvDiffLVL/8)))
	end
	MerchantData = {{[Entities.CU_BlackKnight_LeaderSword3] = {}},
					{[Entities.CU_BanditLeaderSword1] = {}},
					{[Entities.CU_BanditLeaderSword2] = {}},
					{[Entities.CU_BlackKnight_LeaderMace1] = {}},
					{[Entities.CU_BlackKnight_LeaderMace2] = {}},
					{[Entities.CU_Barbarian_LeaderClub1] = {}},
					{[Entities.CU_Barbarian_LeaderClub2] = {}},
					{[Entities.PU_LeaderSword1] = {}},
					{[Entities.PU_LeaderSword2] = {}},
					{[Entities.PU_LeaderSword3] = {}},
					{[Entities.PU_LeaderSword4] = {}},
					{[Entities.PU_LeaderPoleArm1] = {}},
					{[Entities.PU_LeaderPoleArm2] = {}},
					{[Entities.PU_LeaderPoleArm3] = {}},
					{[Entities.PU_LeaderPoleArm4] = {}},
					{[Entities.PU_LeaderBow1] = {}},
					{[Entities.PU_LeaderBow2] = {}},
					{[Entities.PU_LeaderBow3] = {}},
					{[Entities.PU_LeaderBow4] = {}},
					{[Entities.PU_LeaderCavalry1] = {}},
					{[Entities.PU_LeaderCavalry2] = {}},
					{[Entities.PU_LeaderHeavyCavalry1] = {}},
					{[Entities.PU_LeaderHeavyCavalry2] = {}},
					{[Entities.PU_LeaderRifle1] = {}},
					{[Entities.PU_LeaderRifle2] = {}},
					{[Entities.CU_Evil_LeaderBearman1] = {}},
					{[Entities.CU_Evil_LeaderSkirmisher1] = {}},
					{[Entities.CU_BanditLeaderBow1] = {}},
					{[Entities.PU_Scout] = {}},
					{[Entities.PU_Thief] = {}},
					{[Entities.PU_Serf] = {}},
					{[Entities.PU_BattleSerf] = {}},
					{[Entities.PU_LeaderUlan1] = {}},
					{[Entities.CU_VeteranCaptain] = {}},
					{[Entities.CU_VeteranLieutenant] = {}},
					{[Entities.CU_VeteranMajor] = {}},
					{[Entities.PV_Cannon1] = {}},
					{[Entities.PV_Cannon2] = {}},
					{[Entities.PV_Cannon3] = {}},
					{[Entities.PV_Cannon4] = {}},
					{[Entities.PV_Cannon5] = {}},
					{[Entities.PV_Cannon6_2] = {}},
					{[Entities.PV_Ram] = {}}
	}
	for i = 1,table.getn(MerchantData) do
		for k,v in pairs(MerchantData[i]) do
			v[ResourceType.Gold] = CalculateMercenaryOfferCosts(k)
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
function ShuffleMerchantData()
	for i = 0, 3 do
		local amount = math.random(2,8)
		local rdata = MerchantData[math.random(1,table.getn(MerchantData))]
		local id = GetID("MercTent1")
		for k, v in pairs(rdata) do
			OverrideMercenarySlotData(id, i, k, amount, v)
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called from main script to init all resources for player(s)
function Mission_InitLocalResources()

	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Initial Resources
	local InitGoldRaw 		= 5000 + dekaround(5000*gvDiffLVL)
	local InitClayRaw 		= 2000 + dekaround(1000*gvDiffLVL)
	local InitWoodRaw 		= 2500 + dekaround(2500*gvDiffLVL)
	local InitStoneRaw 		= 2000 + dekaround(1200*gvDiffLVL)
	local InitIronRaw 		= 2500 + dekaround(2500*gvDiffLVL)
	local InitSulfurRaw		= 1000 + dekaround(1000*gvDiffLVL)


	--Add Players Resources
	local i
	for i=1,8,1
	do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This function is called to setup Technology states on mission start
function Mission_InitTechnologies()

	for i = 1,2 do
		ResearchTechnology(Technologies.GT_Mathematics, i)
		ResearchTechnology(Technologies.GT_Construction, i)
	end
end


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function EliteSpawnInit()
	EliteSpawnData = {{leaderType = Entities.CU_VeteranLieutenant, position = GetPosition("P3_AI_HQ"), strength = round(5/gvDiffLVL),
						rodeLength = Logic.WorldGetSize(), player = 3, hero = Entities.CU_Barbarian_Hero, heroSpawned = false,
						heroName = "Varg", spawnBuilding = "P3_AI_HQ"},
					{leaderType = Entities.CU_VeteranCaptain, position = GetPosition("P4_AI_HQ"), strength = round(6/gvDiffLVL),
						rodeLength = Logic.WorldGetSize(), player = 4, hero = Entities.CU_Mary_de_Mortfichet, heroSpawned = false,
						heroName = "Kerberos", spawnBuilding = "P4_AI_HQ"}
	}
	for i = 1,2 do
		EliteSpawns(i)
	end
end
function EliteSpawns(_index)

	local data = EliteSpawnData[_index]
	local army	 = {}
	army.player 	= data.player
	army.id			= _index
	army.strength	= data.strength
	army.position	= data.position
	army.rodeLength	= data.rodeLength
	army.building 	= data.spawnBuilding

	if IsExisting(army.building) then
		SetupArmy(army)

		local troopDescription = {
			experiencePoints 	= HIGH_EXPERIENCE,
			leaderType         = data.leaderType
		}
		for i = 1, army.strength do
			EnlargeArmy(army,troopDescription)
		end
		if not data.heroSpawned then
			--ConnectLeaderWithArmy(Logic.CreateEntity(data.hero, ArmyHomespots[army.player][army.id+1][1].X, ArmyHomespots[army.player][army.id+1][1].Y, 0, army.player), army)
			ConnectLeaderWithArmy(GetID(data.heroName), army)
			data.heroSpawned = true
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ControlArmies", 1, {}, {army.player, _index, army.building})
	end

end
function ControlArmies(_player, _index, _building)

	local army = ArmyTable[_player][_index+1]
	if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("ControlArmyCounter_" .. _player .. "_" .. _index, 120*gvDiffLVL) then
			EliteSpawns(_index)
			return true
		end
    end
	Defend(army)

end
function CreatePreludeBriefing()

  PreludeBriefing = {}
  PreludeBriefing.finished = PreludeBriefingFinished

  -- pages
  page = 0

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Hiob"
  PreludeBriefing[page].text = "@color:17,207,255 Willkommen, edler Held! Ich bin Hiob."
  PreludeBriefing[page].npc = {}
  PreludeBriefing[page].npc.id = GetEntityId("Kermit")
  CreateEffect(2, GGL_Effects.FXBuildingSmokeLarge, "Kermit");
  CreateEffect(2, GGL_Effects.FXBuildingSmokeLarge, "Kermit");
  CreateEffect(2, GGL_Effects.FXBuildingSmokeLarge, "Kermit");
  CreateEffect(2, GGL_Effects.FXBuildingSmokeLarge, "Kermit");
  PreludeBriefing[page].npc.isObserved = true
  PreludeBriefing[page].dialogCamera = true
  PreludeBriefingShowKermit = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Hiob"
  PreludeBriefing[page].text = "@color:0,255,0 Ihr seid hier in einer recht d\195\188steren Gegend gelandet @cr um Euer Gl\195\188ck als Held zu suchen. @cr Das Land jenseits des Flusses wird von einem recht gef\195\164hrlichen Trio beherrscht."

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Hiob"
  PreludeBriefing[page].text = "@color:0,255,0 Kerbereos, Varg und Mary de Mortfichet @cr Ihre drei m\195\164chtigen Festungen m\195\188sst ihr zerst\195\182ren @cr um das Land von Ihrer Herrschaft zu befreien.."

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 1. Missionsziel"
  PreludeBriefing[page].text = "@color:0,255,0 Hier haust die gef\195\164hrliche Mary de Mortfichet"
  PreludeBriefing[page].position = GetPosition("P2_AI_HQ")
  PreludeBriefing[page].marker = STATIC_MARKER
  PreludeBriefing[page].explore =  BRIEFING_EXPLORATION_RANGE
  PreludeBriefingShowkermit =  PreludeBriefing[page]
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P2_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P2_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P2_AI_HQ");
  BriefingMonkMarker = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 2. Missionsziel"
  PreludeBriefing[page].text = "@color:0,255,0 Hier hat der verschlagene Kerberos sein Domizil!"
  PreludeBriefing[page].position = GetPosition("P4_AI_HQ")
  PreludeBriefing[page].marker = STATIC_MARKER
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P4_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P4_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P4_AI_HQ");
  BriefingMonk1Marker = PreludeBriefing[page]
  PreludeBriefingShowkermit = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 3. Missionsziel"
  PreludeBriefing[page].text = "@color:0,255,0 Die Grosse Pyramidenfestung des m\195\164chtigen Varg"
  PreludeBriefing[page].position = GetPosition("P3_AI_HQ")
  PreludeBriefing[page].marker = STATIC_MARKER
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P3_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P3_AI_HQ");
  CreateEffect(2, GGL_Effects.FXMaryPoison, "P3_AI_HQ");
  BriefingMonk2Marker = PreludeBriefing[page]
  PreludeBriefingShowkermit = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Geheimgang"
  PreludeBriefing[page].text = "@color:0,255,0 Ach ich Schussel, beinahe h\195\164tte ich ja vergessen Euch dies zu zeigen."
  PreludeBriefing[page].position = GetPosition("stone")
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Die Mauer"
  PreludeBriefing[page].text = "@color:0,255,0 Hmm wenn ihr nur die Mauer zerst\195\182ren k\195\182nntet, @cr vielleicht nagt ja der Zahn der Zeit an ihr .."
  PreludeBriefing[page].position = GetPosition("wall5")
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE
  BriefingMonk4Marker = PreludeBriefing[page]
  PreludeBriefingShowkermit = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Emmas L\195\164dchen"
  PreludeBriefing[page].text = "@color:0,255,0 Hier k\195\182nnt ihr Euch mit ein paar Truppen versorgen ..."
  PreludeBriefing[page].position = GetPosition("MercTent1")
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE
  BriefingMonk5Marker = PreludeBriefing[page]

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Hiob"
  PreludeBriefing[page].text = "@color:0,255,0 Und zu guter Letzt: Das hier ist Eure Burg."
  PreludeBriefing[page].position = GetPosition("P1_AI_HQ")
  PreludeBriefing[page].explore = BRIEFING_EXPLORATION_RANGE

  page = page + 1
  PreludeBriefing[page] = {}
  PreludeBriefing[page].title = "@color:255,255,0 Hiob"
  PreludeBriefing[page].text = "@color:0,255,0 Verschwendet nicht soviel Zeit! @cr recht bald werdet ihr Euer Land verteidigen m\195\188ssen."
  PreludeBriefing[page].position = GetPosition("drake")
  PreludeBriefing[page].dialogCamera = true

  -- start briefing
  StartBriefing(PreludeBriefing)

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function PreludeBriefingFinished()

  ResolveBriefing(PreludeBriefingShowKermit)
  ResolveBriefing(BriefingMonkMarker)
  ResolveBriefing(BriefingMonk1Marker)
  ResolveBriefing(BriefingMonk2Marker)
  ResolveBriefing(BriefingMonk4Marker)
  ResolveBriefing(BriefingMonk5Marker)

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function CreateEffect( _player, _type, _position )

  assert(type(_player) == "number" and _player >= 1 and _player <= 8 and type(_type) == "number", "fatal error: wrong input: _player or _type (function CreateEffect())");
  assert((type(_position) == "table" and type(_position.X) == "number" and type(_position.Y) == "number") or type(_position) == "number" or type(_position) == "string", "fatal error: wrong input: _position (function CreateEffect())");

  if type(_position) == "table" then
    assert(_position.X >= 0 and _position.Y >= 0 and _position.X < Logic.WorldGetSize() and _position.Y < Logic.WorldGetSize(), "error: wrong position-statement (function CreateEffect())");
    local effect = Logic.CreateEffect(_type, _position.X, _position.Y, _player);
    return effect;
  elseif type(_position) == "string" then
    local id = GetEntityId(_position);
    assert(not IsDead(id), "error: entity is dead or not existing (function CreateEffect())");
    local position = GetPosition(id);
    local effect = Logic.CreateEffect(_type, position.X, position.Y, _player);
    return effect;
  else
    assert(not IsDead(_position), "error: entity is dead or not existing (function CreateEffect())");
    local position = GetPosition(_position);
    local effect = Logic.CreateEffect(_type, position.X, position.Y, _player);
    return effect;
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function DestroyEffect( _effect )

  assert(type(_effect) == "number", "fatal error: wrong input: _effect (function DestroyEffect()");
  Logic.DestroyEffect( _effect );

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pyramidennebelA()

  if AreEntitiesInArea(1, 0, GetPosition("PyramideA1"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideA2"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideA3"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideA4"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideA5"), 2000, 1) then

    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideA1")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideA2")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideA3")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideA4")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideA5")
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pyramidennebelB()

  if AreEntitiesInArea(1, 0, GetPosition("PyramideB1"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB2"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB3"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB4"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB5"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB6"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB7"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB8"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideB9"), 2000, 1) then

    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB1")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB2")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB3")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB4")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB5")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB6")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB7")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB8")
    CreateEffect( 2, GGL_Effects.FXMaryPoison, "PyramideB9")
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pyramidennebelC()

  if AreEntitiesInArea(1, 0, GetPosition("PyramideC1"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideC2"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideC3"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideC4"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideC5"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideC6"), 2000, 1) then

    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC1")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC2")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC3")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC4")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC5")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideC6")
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pyramidennebelD()

  if AreEntitiesInArea(1, 0, GetPosition("PyramideD1"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD2"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD3"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD4"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD5"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD6"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD7"), 2000, 1) or
    AreEntitiesInArea(1, 0, GetPosition("PyramideD8"), 2000, 1) then

    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD1")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD2")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD3")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD4")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD5")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD6")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD7")
    CreateEffect( 2, GGL_Effects.FXKalaPoison, "PyramideD8")
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function enablePyramidennebel()

  pyramidennebelA();
  pyramidennebelB();
  pyramidennebelC();
  pyramidennebelD();

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Help()

  if Logic.GetTime() == 3600 then
    ChangePlayer("wall1", 4)
    ChangePlayer("wall2", 4)
    ChangePlayer("wall3", 4)
    Message("@color:255,255,0 pssst es scheint die Mauer ist ");
    Message("@color:255,255,0 etwas br\195\188chig geworden ");
    Message("@color:255,255,0 vielleicht k\195\182nnen wir sie nun zerst\195\182ren");
    return true
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Kermit()

  if Logic.GetTime() == 180 then
    DestroyEntity("Kermit")
    Message("@color:255,255,0 Hiob: Ich geh dann mal ");
    return true
  end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Bonus1()

	if IsDead("P3_AI_HQ") or IsDead("P4_AI_HQ") then
		local amount = round(5252 + Logic.GetTime())
		for i = 1,2 do
			AddGold(i, amount)
			AddSulfur(i, amount)
		end
		Message("@color:255,255,0 Ihr habt " .. amount .. " Gold und " .. amount .. " Schwefel f\195\188r die Vernichtung des Hauptquartiers erhalten");
		return true
	end

end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Bonus2()

	if IsDead("P2_AI_HQ") then
		local amount = round(4444 + Logic.GetTime())
		for i = 1,2 do
			AddGold(i, amount)
			AddIron(i, amount)
		end
		Message("@color:255,255,0 Ihr habt " .. amount .. " Gold und " .. amount .. " Eisen f\195\188r die Vernichtung des Hauptquartiers erhalten");
		return true
	end

end