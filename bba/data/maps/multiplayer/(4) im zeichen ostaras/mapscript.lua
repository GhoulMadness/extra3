initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not initEMS() then
	local errMsgs =
	{
		["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr Überprüfe ob alle Dateien am richtigen Ort sind!",
		["eng"] = "Attention: Enhanced Multiplayer Script could not be found! @cr Make sure you placed all the files in correct place!",
	}
	local lang = "de";
	if XNetworkUbiCom then
		lang = XNetworkUbiCom.Tool_GetCurrentLanguageShortName();
		if lang ~= "eng" and lang ~= "de" then
			lang = "eng";
		end
	end
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	GUI.AddStaticNote("@color:255,0,0 " .. errMsgs[lang]);
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	return;
end
gvEMSFlag = 1
gvDiffLVL = 1
EMS_CustomMapConfig =
{

	Version = 1.02,

	Callback_OnMapStart = function()

		Script.Load(Folders.MapTools.."Ai\\Support.lua")
		Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua" )
		Script.Load( "Data\\Script\\MapTools\\Tools.lua" )
		Script.Load( "Data\\Script\\MapTools\\WeatherSets.lua" )
		IncludeGlobals("Comfort")
		Script.Load( Folders.MapTools.."Main.lua" )
		IncludeGlobals("MapEditorTools")
		Script.Load( "Data\\Script\\MapTools\\Counter.lua" )

		IncludeGlobals("Tools\\BSinit")
		IncludeGlobals("Tools\\recalculate_bridge_height")
		-- custom Map Stuff
		SetEntityName(Logic.CreateEntity(Entities.CU_AggressiveWolf, 0, 0, 0, 7), "fakedamager")
		for i = 1, 2 do
			local id = Logic.GetEntityIDByName("NV_Castle" .. i)
			CUtil.SetEntityDisplayName(id, "Schlossruine")
			Logic.SetModelAndAnimSet(id, Models.CB_OldKingsCastleRuin)
		end
		local fakers = {"fakedamager"}
		for i = 1, table.getn(fakers) do
			SetEntityVisibility(Logic.GetEntityIDByName(fakers[i]), 0)
		end

		AddPeriodicSummer(10)

		MultiplayerTools.InitCameraPositionsForPlayers()

		LocalMusic.UseSet = HIGHLANDMUSIC
		for i = 1, 4 do
			Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
			ForbidTechnology(Technologies.T_MakeSnow, i)
		end
		Display.SetPlayerColorMapping(8, 14)
		Display.SetPlayerColorMapping(7, 9)

		InitializeArmySelection()

		if XNetwork.Manager_DoesExist() == 0 then
			math.randomseed(Game.RealTimeGetMs())
			for i=1,4,1 do
				MultiplayerTools.DeleteFastGameStuff(i)
			end
			local PlayerID = GUI.GetPlayerID()
			Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
			Logic.PlayerSetGameStateToPlaying( PlayerID )
		end
		InitMerchants()

	end,

	Callback_OnGameStart = function()

		if XNetwork.Manager_DoesExist() == 0 then
			local InitGoldRaw 		= 1000
			local InitClayRaw 		= 1800
			local InitWoodRaw 		= 1500
			local InitStoneRaw 		= 800
			local InitIronRaw 		= 50
			local InitSulfurRaw		= 50
			for i = 2,4 do
				--Add Players Resources
				Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
			end
			Logic.ActivateUpdateOfExplorationForAllPlayers()
			Input.KeyBindDown(Keys.ModifierAlt+Keys.P, "SwitchPlayerID()", 2)
		end
		TagNachtZyklus(24,1,0,-3,1)
		function GetEMSCounterValue()
			for k, v in pairs(Counter) do
				if type(v) == "table" and v.Show then
					return v.Limit
				end
			end
			LuaDebugger.Break()
		end
		StartSimpleJob("DelayedActions")
		-- register bandits and evil stuff in statistics
		Logic.SetPlayerRawName(5, "Silverdale")
		Logic.PlayerSetIsHumanFlag(5, 1)
		Logic.PlayerSetPlayerColor(5, GUI.GetPlayerColor(5))
		Logic.SetPlayerRawName(6, "Silverville")
		Logic.PlayerSetIsHumanFlag(6, 1)
		Logic.PlayerSetPlayerColor(6, GUI.GetPlayerColor(6))
		Logic.SetPlayerRawName(7, "???")
		Logic.PlayerSetIsHumanFlag(7, 1)
		Logic.PlayerSetPlayerColor(7, GUI.GetPlayerColor(7))
		--
		InitEggs(40, 1)
		InitEggs(40, 2)
		StartSimpleJob("RespawnEggsJob")
		--
		for i = 1, 4 do
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "OutpostControl", 1, {}, {i})
		end
		InitNV()
	end,

	Callback_OnPeacetimeEnded = function()
		for ID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_Rock7)) do
			DestroyEntity(ID)
		end
		local i = 0
		for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XA_Rabbit_Evil)) do
			i = i + 1
			Logic.SetEntityName(eID, "rabbit"..i)
		end
		StartSimpleJob("ControlRabbits")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSpecialRabbitDied", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "_2SmallYetBigger", 1)
		StartSimpleJob("SuddenDeathCounter")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "WebControl", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "CheckEntityDrowned", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_WEATHER_STATE_CHANGED, "", "WeatherChangedTrigger", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","PawnPromotionControl",1,{},{1, 2, 58200, 30450, "BanditTowerP6_1", "BanditTowerP6_2"})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","PawnPromotionControl",1,{},{2, 1, 58200, 30450, "BanditTowerP6_1", "BanditTowerP6_2"})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","PawnPromotionControl",1,{},{3, 4, 3200, 30450, "BanditTowerP5_1", "BanditTowerP5_2"})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","PawnPromotionControl",1,{},{4, 3, 3200, 30450, "BanditTowerP5_1", "BanditTowerP5_2"})
		for i = 1, 2 do
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "TrackEntityDrownedCount", 1, {}, {i})
		end
		for i = 1, 4 do
			AllowTechnology(Technologies.T_MakeSnow, i)
		end
	end,

	Peacetime = 40,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 2,
	WeatherChangeLockTimer = 1,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1
}
function DelayedActions()
	StartCountdown(round(GetEMSCounterValue() * 0.75), DrawBridgeTributes, false)
	return true
end
function DrawBridgeTributes()
	for player = 1, 4 do
		for variant = 1, 2 do
			TributeDrawBridge(player, variant)
		end
	end
end
TributeDataByVariant = {
	{Text = "Zahlt 500 Taler, um Eure äußere Zugbrücke herunter zu lassen.",
	Cost = {Gold = 500},
	Callback = "TributePaid_DB",
	DelaySeconds = 12*60},
	{Text = "Zahlt 2500 Taler, um Eure äußere Zugbrücke herunter zu lassen. Der Zugbrückenwärter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird.",
	Cost = {Gold = 2500},
	Callback = "TributePaid_DB",
	DelaySeconds = 1*60}
}
function TributeDrawBridge(_player, _variant)
	local Tribute =  {}
	Tribute.pId = _player
	Tribute.variant = _variant
	Tribute.text = TributeDataByVariant[_variant].Text
	Tribute.cost = TributeDataByVariant[_variant].Cost
	Tribute.Callback = _G[TributeDataByVariant[_variant].Callback]
	Tribute.DelaySeconds = TributeDataByVariant[_variant].DelaySeconds
	Tribute = AddTribute(Tribute)
end

function TributePaid_DB(_data)
	local player = _data.player or _data.pId
	local show = false
	if GUI.GetPlayerID() == player then
		show = true
	end
	local id = ReplaceEntity("bridge_p" .. player, Entities.PB_DrawBridgeClosed1)
	MakeInvulnerable(id)
	local tr = {Logic.GetAllTributes(player)}
	for i = 2, tr[1]+1 do
		Logic.RemoveTribute(player, tr[i])
	end
	StartCountdown(_data.DelaySeconds, DelayedDrawBridgeActions, show, nil, player, _data.variant, id)
end
function DelayedDrawBridgeActions(_player, _variant, _id)
	MakeVulnerable(_id)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,"","CheckForDrawBridgeDestroyed",1,{},{_id, _player, _variant})
end
function CheckForDrawBridgeDestroyed(_id, _player, _variant)
	local entityID = Event.GetEntityID()
	if entityID == _id then
		local posX, posY = Logic.GetEntityPosition(entityID)
		Logic.SetEntityName(Logic.CreateEntity(Entities.XD_DrawBridgeOpen1, posX, posY, 0, 0), "bridge_p" .. _player)
		TributeDrawBridge(_player, 1)
		TributeDrawBridge(_player, 2)
		return true
	end
end
function ShowArmyCreatorGUI()
	XGUIEng.SetText("BS_ArmyCreator_Title", "@center Erstelle die Armee für deine verbündete Siedlung")
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("EMSMenu",0)
		XGUIEng.ShowWidget("EMSRuleOverview",0)
		--
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
	end
end
function InitializeArmySelection()
	Script.Load("maps\\user\\Balancing_Stuff_in_Dev\\ArmyCreator.lua")
	ArmyCreator.TroopLimit = 3
	ArmyCreator.BasePoints = 75
	ArmyCreator.PlayerPoints = 75
	ArmyCreator.SpawnPos[1] = GetPosition("BanditSpawnP6_1")
	ArmyCreator.SpawnPos[2] = GetPosition("BanditSpawnP6_2")
	ArmyCreator.SpawnPos[3] = GetPosition("BanditSpawnP5_1")
	ArmyCreator.SpawnPos[4] = GetPosition("BanditSpawnP5_2")

	StartCountdown(1,ShowArmyCreatorGUI,false)

	function ArmyCreator.OnSetupFinished()

		Message("Jeder Spieler hat seine Armeeauswahl getroffen.")
		if GUI.GetPlayerID() ~= 17 then
			XGUIEng.ShowWidget("EMSMenu",1)
			XGUIEng.ShowWidget("EMSRuleOverview",1)
		end

		-- all standard techs for all AI units, enough vc places for miners, remove ai heroes when dead
		for i = 5,6 do
			ResearchAllTechnologies(i, false, false, false, true, false)
			CLogic.SetAttractionLimitOffset(i, 999)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","CheckForAIHeroesDead",1,{},{i})
		end

		for i = 1,2 do
			ActivateShareExploration(i, 6, true)
			SetHostile(i, 5)
		end
		for i = 3,4 do
			ActivateShareExploration(i, 5, true)
			SetHostile(i, 6)
		end

	end

	AlliedAIByPlayerID = {[1] = 6,
						[2] = 6,
						[3] = 5,
						[4] = 5}
	ArmyCreator.CreateTroops = function(_playerID, _trooptable)

		local players = {_playerID}
		if XNetwork.Manager_DoesExist() == 0 then
			for i = 2, 4 do
				table.insert(players, i)
			end
		end
		for i = 1, table.getn(players) do
			local playerID = players[i]
			local ai = AlliedAIByPlayerID[playerID]
			local playerinteam = math.mod(playerID, 2) + 1
			local army = {}
			army.player = ai
			army.id	= GetFirstFreeArmySlot(ai)
			army.position = GetPosition("BanditSpawnP" .. ai .. "_" .. playerinteam)
			army.building = GetID("BanditTowerP" .. ai .. "_" .. playerinteam)
			army.rodeLength	= 3800

			local IDs = {}
			for k,v in pairs(_trooptable) do

				if ArmyCreator.TroopException[k] and v == 1 then

					table.insert(IDs, Logic.CreateEntity(k, ArmyCreator.SpawnPos[playerID].X, ArmyCreator.SpawnPos[playerID].Y, math.random(360), ai))

				elseif ArmyCreator.TroopOnlyLeader[k] then

					if v >= 1 then
						for i = 1,v do
							table.insert(IDs, Logic.CreateEntity(k, ArmyCreator.SpawnPos[playerID].X, ArmyCreator.SpawnPos[playerID].Y, math.random(360), ai))
						end
					end

				else

					if v >= 1 then
						for i = 1,v do
							table.insert(IDs, AI.Entity_CreateFormation(ai, k, 0, LeaderTypeGetMaximumNumberOfSoldiers(k), ArmyCreator.SpawnPos[playerID].X, ArmyCreator.SpawnPos[playerID].Y, 0, 0, 0, 0))
						end
					end

				end
			end
			army.strength = table.getn(IDs)
			SetupArmy(army)
			ArmyTable[army.player][army.id + 1].troopdata = _trooptable
			ArmyTable[army.player][army.id + 1].IDs = {}
			for i = 1, army.strength do
				ConnectLeaderWithArmy(IDs[i], army)
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id, army.building})
		end
	end

end
function CheckForAIHeroesDead(_player)
	local heroes = {}
	Logic.GetHeroes(_player, heroes)
	for i = 1, table.getn(heroes) do
		if IsDead(heroes[i]) then
			if Counter.Tick2("RemoveDeadHeroCounter_" .. heroes[i], 5) then
				DestroyEntity(heroes[i])
			end
		end
	end
end
function ControlArmies(_player, _id, _building)
	if not IsExisting(_building) then
		if IsDead(ArmyTable[_player][_id + 1]) then
			return true
		end
	else
		if IsVeryWeak(ArmyTable[_player][_id + 1]) and IsExisting(_building) then
			if Counter.Tick2("ControlArmiesDead_" .. _player .. "_" .. _id, 90) then
				RespawnSilvermineDefArmy(_player, _id, _building)
				return true
			end
		end
	end
	Defend(ArmyTable[_player][_id + 1])
end
function RespawnSilvermineDefArmy(_player, _id, _building)
	if IsExisting(_building) then
		local army = ArmyTable[_player][_id + 1]
		local _trooptable = army.troopdata
		for k,v in pairs(_trooptable) do

			if ArmyCreator.TroopException[k] and v == 1 then

				EnlargeArmy(army, {leaderType = k})

			elseif ArmyCreator.TroopOnlyLeader[k] then

				if v >= 1 then
					for i = 1,v do
						EnlargeArmy(army, {leaderType = k})
					end
				end

			else

				if v >= 1 then
					for i = 1,v do
						EnlargeArmy(army, {leaderType = k})
					end
				end

			end
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{_player, _id, _building})
	end
end
function GetPlayerIDsByTeamID(_TeamID)
	if _TeamID == 1 then
		return 1,2
	elseif _TeamID == 2 then
		return 3,4
	else
		return 0,0
	end
end
function GetTeamIDByPlayerID(_playerId)
	return math.ceil(_playerId/2)
end
function GetEnemyTeamIDByPlayerID(_playerId)
	if _playerId <= 2 then
		return 2
	else
		return 1
	end
end

function SwitchPlayerID()
	local oldID = GUI.GetPlayerID()
	local newID
	if oldID < 4 then
		newID = oldID + 1
	else
		newID = 1
	end
	GUI.SetControlledPlayer(newID)
	local pos = GetPlayerStartPosition(newID)
	Camera.ScrollSetLookAt(pos.X, pos.Y)
	Message("Ihr spielt nun aus der Perspektive von Spieler "..newID)
end

function InitMerchants()
	for i = 1,2 do
		--ReplaceEntity("merc"..i, Entities.CB_Evil_Mercenary)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.CU_VeteranLieutenant, 4, ResourceType.Gold, 2500)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
	end
	function CalculateMercenaryOfferCosts(_type, _soldiers)
		local lcost, solcost = {}, {}
		Logic.FillLeaderCostsTable(1, _type + 2 ^ 16, lcost)
		local maxsol = _soldiers or MaxSoldiersByLeaderType[_type] or 0
		if maxsol and maxsol > 0 then
			local soletype = GetEntityTypeSoldierType(_type)
			Logic.FillSoldierCostsTable(1, soletype + 2 ^ 16, solcost)
		end

		local total = 0
		for i = 1, 17 do
			if i == ResourceType.Silver then
				lcost[i] = lcost[i] * 20
			elseif i == ResourceType.Knowledge then
				lcost[i] = lcost[i] * 5
			end
			total = total + lcost[i] + ((solcost[i] and solcost[i] * maxsol) or 0)
		end
		return round(total * 0.75)
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
	MerchantDataReducedProbTypes = {
		[Entities.PV_Cannon6_2] = true
	}
	local len = table.getn(MerchantData)
	for i = 1, len do
		for k, v in pairs(MerchantData[i]) do
			v[ResourceType.Gold] = CalculateMercenaryOfferCosts(k)
			if not MerchantDataReducedProbTypes[k] then
				MerchantData[len+i] = MerchantData[i]
			end
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
function ShuffleMerchantData()
	for i = 0, 3 do
		local amount = math.random(2,6)
		local rdata = MerchantData[math.random(1,table.getn(MerchantData))]
		for j = 1, 2 do
			local id = GetID("merc" .. j)
			for k, v in pairs(rdata) do
				if k == Entities.PV_Cannon6_2 then
					amount = 1
				end
				OverrideMercenarySlotData(id, i, k, amount, v)
			end
		end
	end
	StartCountdown((5 + math.random(10)) * 60, ShuffleMerchantData, false)
end
function InitNV()
	NVArmyTypes = {Entities.CU_Evil_LeaderBearman1,
				Entities.CU_Evil_LeaderBearman1,
				Entities.CU_Evil_LeaderSpearman1,
				Entities.CU_Evil_LeaderSkirmisher1,
				Entities.CU_Evil_LeaderSkirmisher1,
				Entities.CU_AggressiveScorpion1,
				Entities.CU_AggressiveScorpion2,
				Entities.CU_AggressiveScorpion3}
	NVPlayer = 7
	NVHQNorth = GetID("NV_Castle1")
	NVHQSouth = GetID("NV_Castle2")
	NVPos = {["North"] = GetPosition(NVHQNorth), ["South"] = GetPosition(NVHQSouth)}
	NVCenterPos = {GetPosition("NVSpawn3"), GetPosition("NVSpawn6")}
	for i = 1, 4 do
		SetHostile(i, NVPlayer)
	end
	for i = 1, 3 do
		SetupNVArmy(i, NVHQNorth)
	end
	for i = 4, 6 do
		SetupNVArmy(i, NVHQSouth)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","NVHQCheck",1,{},{"NV_Castle1"})
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","NVHQCheck",1,{},{"NV_Castle2"})
	--
	PlayerToNVArmyIndex = {
		[1] = 1,
		[2] = 4,
		[3] = 5,
		[4] = 2
	}
	for i = 1, table.getn(gvTechTable.TroopUpgrades) do
		ResearchTechnology(gvTechTable.TroopUpgrades[i], NVPlayer)
	end
end
function SetupNVArmy(_index, _hq)
	local army = {}
	army.player = NVPlayer
	army.id	= _index
	army.position = GetPosition("NVSpawn" .. _index)
	army.rodeLength	= (ArmyTable and ArmyTable[NVPlayer] and ArmyTable[NVPlayer][_index+1] and ArmyTable[NVPlayer][_index+1].rodeLength) or 2800
	army.strength = 5 + round(Logic.GetTime()/60/10)
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlNVArmies",1,{},{_index, _hq})
end
function ControlNVArmies(_index, _hq)
	if not IsExisting(_hq) then
		if IsDead(ArmyTable[NVPlayer][_index + 1]) then
			return true
		end
	else
		if IsVeryWeak(ArmyTable[NVPlayer][_index + 1]) and IsExisting(_hq) then
			if Counter.Tick2("ControlNVArmiesDead_" .. _index, 60) then
				SetupNVArmy(_index, _hq)
				return true
			end
		end
	end
	Defend(ArmyTable[NVPlayer][_index + 1])
end
function NVHQCheck(_hq)
	if IsDestroyed(_hq) then
		local pos
		local loc
		local rot = 90
		if string.sub(_hq, string.len(_hq)) == "1" then
			loc = "North"
		else
			loc = "South"
			rot = 270
		end
		pos = NVPos[loc]
		Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, pos.X, pos.Y)
		CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,700,10000)
		local id = Logic.CreateEntity(Entities.XD_Rabbit_Statue, pos.X, pos.Y, rot, 0)
		StartCountdown(2*60, InitRabbitStatueEggs, false, "InitRabbitStatueEggsCountdown", loc, pos.X, pos.Y)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueMadness",1,{},{loc, id})
		return true
	end
end
function InitRabbitStatueEggs(_name, _posX, _posY)

	Message("Es sind weitere Ostereier aufgetaucht!")
	local totaleggs = 12
	local count = 0
	local posX,posY
	local sec = CUtil.GetSector(_posX /100, _posY /100)
	if sec == 0 then
		sec = EvaluateNearestUnblockedSector(_posX, _posY, 1000, 100)
	end
	local tempid
	local tempsec
	while count < totaleggs do
		posX = math.random(_posX - 2000, _posX + 2000)
		posY = math.random(_posY - 2000, _posY + 2000)
		currsec = CUtil.GetSector(posX/100, posY/100)
		if sec == currsec and GetDistance({X = posX, Y = posY}, {X = _posX, Y = _posY}) < 3000 then
			count = count + 1
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"RabbitStatue_EasterEgg_".._name.."_"..count)
		end
	end
	RabbitStatue_EasterEggposTable = RabbitStatue_EasterEggposTable or {}
	RabbitStatue_EasterEggposTable[_name] = {}
	for i = 1, totaleggs do
		RabbitStatue_EasterEggposTable[_name][i] = GetPosition("RabbitStatue_EasterEgg_".._name.."_"..i)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueEggs",1,{},{_name, _posX, _posY})
end

function ControlRabbitStatueEggs(_name, _posX, _posY)

	for j = 1, 4 do
		for k, v in pairs(RabbitStatue_EasterEggposTable[_name]) do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, v.X, v.Y, 300, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					local randomEvent = math.random(3)
					if randomEvent == 3 then
						Logic.CreateEffect(GGL_Effects.FXMaryPoison, v.X, v.Y)
						Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, v.X, v.Y)
						SetHealth(entities[2], 0)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein faules Osterei gefunden... Wie das stinkt!")
							Sound.PlayGUISound( Sounds.OnKlick_Select_mary_de_mortfichet, 122 )
						end
					else
						local randomEventAmount = round(10 + math.random(10) * (1 + Logic.GetTime()/400))
						Logic.AddToPlayersGlobalResource(j, ResourceType.SilverRaw, randomEventAmount)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein besonders seltenes Osterei gefunden. Inhalt: "..randomEventAmount.." Silber")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 132 )
						end
					end
					DestroyEntity(Logic.GetEntityAtPosition(v.X, v.Y))
					table.remove(RabbitStatue_EasterEggposTable[_name], k)
				end
			end
		end
	end
	if table.getn(RabbitStatue_EasterEggposTable[_name]) == 0 then
		StartCountdown((5+math.random(1,5))*60, InitRabbitStatueEggs, false, "InitRabbitStatueEggsCountdown", _name, _posX, _posY)
		return true
	end
end
effIDs = {	["North"] = {},
			["South"] = {}}
function RabbitStatueMadness(_name, _id)

	if Score.Player[7].battle > 1500 then
		if IsValid(_id) then
			local eID = ReplaceEntity(_id, Entities.CB_RabbitStatue)
			newID = ChangePlayer(eID, 7)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueMadness", 1, {}, {_name, newID})
			Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnRabbitStatueDamaged", 1, {}, {newID})
			local pos = GetPosition(newID)
			effIDs[_name].eff_flakes = Logic.CreateEffect(GGL_Effects.FXAshFlakes, pos.X, pos.Y)
			effIDs[_name].eff_embers = Logic.CreateEffect(GGL_Effects.FXEmbers, pos.X, pos.Y)
		end
		return true
	end

end
function ControlRabbitStatueMadness(_name, _eID)

	local range = gvLightning.Range + 2 * math.random(gvLightning.Range)
	local damage = gvLightning.BaseDamage + 3 * math.random(gvLightning.BaseDamage)
	local buildingdamage = (((gvLightning.BaseDamage + math.random(gvLightning.BaseDamage))*6) + math.min(GetCurrentWeatherGfxSet()*5,55)*gvLightning.DamageAmplifier)
	local pos = GetPosition(_eID)
	for i = 1,(math.ceil(math.min(500/(GetEntityHealth(_eID)+1),30))),1 do
		x = math.max(math.min(math.random(pos.X - 4000, pos.X + 4000), Mapsize - 100), 100)
		y = math.max(math.min(math.random(pos.Y - 4000, pos.Y + 4000), Mapsize - 100), 100)
		Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode, x, y)
		gvLightning.Damage(x, y, range, damage, buildingdamage)
	end

	local pID = GUI.GetPlayerID()
	if gvLightning.RecentlyDamaged[pID] == true then
		Sound.PlayGUISound( Sounds.OnKlick_Select_varg, 92 )
		Sound.PlayGUISound( Sounds.OnKlick_PB_Tower3, 94 )
		Sound.PlayGUISound( Sounds.OnKlick_PB_PowerPlant1, 82 )
		Sound.PlayGUISound(Sounds.AmbientSounds_rainmedium,120)
		Stream.Start("Sounds\\Misc\\SO_buildingdestroymedium.wav",72)
		gvLightning.RecentlyDamaged[pID] = false
	end
	for i = 1,16 do
		if IsValid("rabbit"..i) then
			local posi = GetPosition("rabbit"..i)
			if GetDistance(posi, pos) <= 9000 then
				local count = math.random(GetEntityHealth("rabbit"..i))
				if count < 15 then
					Logic.CreateEffect(GGL_Effects.FXKalaPoison, posi.X, posi.Y)
					CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),posi.X,posi.Y,1000,300)
				end
			end
		end
	end
	if IsDestroyed(_eID) then
		RabbitStatueMadnessFallen(_name)
		Logic.DestroyEffect(effIDs[_name].eff_embers)
		Logic.DestroyEffect(effIDs[_name].eff_flakes)
		return true
	end
end
function OnRabbitStatueDamaged(_id)

	local attacker = Event.GetEntityID1()
    local target = Event.GetEntityID2()
	if target == _id then
		local targettype = Logic.GetEntityType(target)
		local player = GetPlayer(attacker)
		local dmg = CEntity.TriggerGetDamage()

		if targettype == Entities.CB_RabbitStatue then
			Logic.AddToPlayersGlobalResource(player, ResourceType.Silver, math.ceil(dmg/100))
		end
		return dmg > Logic.GetEntityHealth(target)
	end
end
function RabbitStatueMadnessFallen(_name)
	local pos = NVPos[_name]
	local totalpiles = 2 + math.random(round(Logic.GetTime()/(20*60)))
	local count = 0
	local sec = CUtil.GetSector(pos.X /100, pos.Y /100)
	if sec == 0 then
		sec = EvaluateNearestUnblockedSector(pos.X, pos.Y, 1000, 100)
	end
	local currsec
	while count < totalpiles do
		posX = math.random(pos.X - 2000, pos.X + 2000)
		posY = math.random(pos.Y - 2000, pos.Y + 2000)
		currsec = CUtil.GetSector(posX/100, posY/100)
		if sec == currsec and GetDistance({X = posX, Y = posY}, {X = pos.X, Y = pos.Y}) < 3000 then
			count = count + 1
			local amount = 10 + math.random(10) + round(Logic.GetTime() / 60)
			Logic.SetResourceDoodadGoodAmount(Logic.CreateEntity(Entities.XD_Silver1, posX, posY, math.random(360), 0), math.random(round(amount*0.7), amount))
		end
	end
end

CenterPosByTeam = {	[1] = {X = 12500, Y = 28800},
					[2] = {X = 45200, Y = 28800}}
SilverminePosByTeam = {	[1] = {X = 2214.44189453125, Y = 30447.19921875},
						[2] = {X = 58685.55859375, Y = 30447.19921875}}
------------------------------------------------------------------------------------
function InitEggs(_amount, _team)

	local totaleggs = _amount
	local count = 0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec = CUtil.GetSector(CenterPosByTeam[_team].X /100, CenterPosByTeam[_team].Y /100)
	local currsec
	EasterEggposTable = EasterEggposTable or {}
	EasterEggposTable[_team] = EasterEggposTable[_team] or {}
	while count < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		currsec = CUtil.GetSector(posX/100, posY/100)
		if sec == currsec and GetDistance({X = posX, Y = posY}, CenterPosByTeam[_team]) < 20000 then
			count = count + 1
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T".._team.."_"..count)
			EasterEggposTable[_team][count] = {X = posX, Y = posY}
		end
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlEggs",1,{},{_team})
end

function ControlEggs(_team)

	if table.getn(EasterEggposTable[_team]) > 0 then
		for j = 1, 4 do
			for k, v in pairs(EasterEggposTable[_team]) do
				entities = {Logic.GetPlayerEntitiesInArea(j, 0, v.X, v.Y, 200, 1)};
				if entities[1] > 0 then
					if Logic.IsHero(entities[2]) == 1 then
						local time = Logic.GetTime()/60
						local randomEventAmount = round(45+math.random(10)*time)
						local rtypetext = "Taler"
						if time < 35 then
							Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
						else
							rtypetext = "Eisen"
							Logic.AddToPlayersGlobalResource(j,ResourceType.IronRaw,randomEventAmount)
						end
						DestroyEntity(Logic.GetEntityAtPosition(v.X, v.Y))
						table.remove(EasterEggposTable[_team], k)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein Osterei gefunden. Inhalt: "..randomEventAmount.." ".. rtypetext)
							Sound.PlayGUISound(Sounds.OnKlick_Select_ari, 142)
						end
					end
				end
			end
		end
	else
		return true
	end
end
function RespawnEggsJob()
	if table.getn(EasterEggposTable[1]) + table.getn(EasterEggposTable[2]) == 0 then
		for i = 1, 2 do
			InitEggs(math.max(round(40 - Logic.GetTime()/300), 5), i)
		end
		return true
	end
end
RabbitFleeCounter = {}
for i = 1,16 do
	RabbitFleeCounter[i] = 0
end
RabbitFleeCounter.North = 0
RabbitFleeCounter.South = 0
function ControlRabbits()
	for i = 1,16 do
		if IsValid("rabbit"..i) then
			if GetEntityCurrentTask(Logic.GetEntityIDByName("rabbit"..i)) == TaskLists.TL_ANIMAL_FLEE then
				RabbitFleeCounter[i] = RabbitFleeCounter[i] + 1
			else
				RabbitFleeCounter[i] = 0
			end
			if RabbitFleeCounter[i] >= 12 then
				local pos = GetPosition("rabbit"..i)
				if GetDistance(pos, GetPosition("NV_Castle1")) < 12000 then
					RabbitFleeCounter.North = RabbitFleeCounter.North + 1
				elseif GetDistance(pos, GetPosition("NV_Castle2")) < 12000 then
					RabbitFleeCounter.South = RabbitFleeCounter.South + 1
				end
				local count = math.random(6)
				if count <= 2 then
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X+math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X-math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y+math.random(50,100), 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y-math.random(50,100), 0, 7)
				elseif count >= 3 and count <= 5 then
					Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
					CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,1000,300)
				elseif count == 6 then
					local height, blockingtype, sector, tempterrType = CUtil.GetTerrainInfo(pos.X, pos.Y)
					if sector ~= 0 and blockingtype == 0 and (height > CUtil.GetWaterHeight(pos.X/100, pos.Y/100)) then
						local amount = 10 + round(Logic.GetTime() / 90)
						Logic.SetResourceDoodadGoodAmount(Logic.CreateEntity(Entities.XD_Silver1, pos.X, pos.Y, 0, 0), math.random(round(amount*0.7), amount))
					end
				end
				RabbitFleeCounter[i] = 0
				if Counter.SDCounter then
					Counter.SDCounter.TickCount = math.min(Counter.SDCounter.TickCount + 60, Counter.SDCounter.Limit - 1)
				end
			end
		end
	end
end

function OnSpecialRabbitDied()

	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XA_Rabbit_Evil then
		local name = Logic.GetEntityName(entityID)
		if name ~= nil then
			local pos = GetPosition(entityID)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RecreateRabbit", 1, nil, {name, pos.X, pos.Y})
		end
	end

end

function RecreateRabbit(_name, _posX, _posY)

	posX, posY = EvaluateNearestUnblockedPosition(_posX, _posY, 1000, 100)

	if posX and posY then
		local id = Logic.CreateEntity(Entities.XA_Rabbit_Evil, posX, posY, 0, 0)
		Logic.SetEntityName(id, _name)
		SetEntitySize(id, 2.5)
	end
	return true
end

function SuddenDeathCounter()
	if Counter.Tick2("SDCounter", 3.0 * 60 * 60) then
		for i = 1, 2 do
			local id = Logic.GetEntityAtPosition(SilverminePosByTeam[i].X, SilverminePosByTeam[i].Y)
			if not id or id == 0 then
				AdjustTerrainHeightByTeam(i)
				Logic.CreateEntity(Entities.XD_VillageCenter_Ruin, SilverminePosByTeam[i].X, SilverminePosByTeam[i].Y, 0, 0)
			end
			if IsDestroyed("NV_Castle" .. i) then
				local loc = "North"
				if i == 2 then
					loc = "South"
				end
				if Logic.GetEntitiesInArea(Entities.CB_RabbitStatue, NVPos[loc].X, NVPos[loc].Y, 2000, 1) == 0 then
					local num, id = Logic.GetEntitiesInArea(Entities.XD_Rabbit_Statue, NVPos[loc].X, NVPos[loc].Y, 2000, 1)
					if num > 0 then
						Logic.DestroyEntity(id)
					end
					local id = Logic.CreateEntity(Entities.CB_Evil_Mercenary, NVPos[loc].X, NVPos[loc].Y, 0, 8)
					Logic.AddMercenaryOffer(id, Entities.CU_Evil_LeaderSpearman1, 12, ResourceType.Gold, 200, ResourceType.Wood, 250)
					Logic.AddMercenaryOffer(id, Entities.CU_Evil_LeaderCavalry1, 6, ResourceType.Gold, 800, ResourceType.Iron, 600)
					--Logic.AddMercenaryOffer(id, Entities.CU_Evil_Uruk1, 2, ResourceType.Gold, 3500, ResourceType.Sulfur, 2000)
					Logic.AddMercenaryOffer(id, Entities.CU_Evil_Troll1, 1, ResourceType.Gold, 5000, ResourceType.Knowledge, 1250)
					Logic.AddMercenaryOffer(id, Entities["CU_AggressiveScorpion" .. math.random(1,3)], 18, ResourceType.Sulfur, 50)
				end
			end
		end
		return true
	end
end

function AdjustTerrainHeightByTeam(_team)
	local height = 2008
	if _team == 1 then
		for x = 17, 27 do
			for y = 299, 308 do
				Logic.SetTerrainNodeHeight(x, y, height)
			end
		end
	elseif _team == 2 then
		for x = 582, 591 do
			for y = 299, 308 do
				Logic.SetTerrainNodeHeight(x, y, height)
			end
		end
	end
end

function OutpostControl(_player)
	local id = Logic.GetEntityIDByName("OutpostP" .. _player)
	local posX, posY = Logic.GetEntityPosition(id)
	local num, id = Logic.GetEntitiesInArea(Entities.PU_WoodCutter, posX, posY, 2000, 1)
	if num > 0 then
		amount = WCutter.WoodEarned[id] or 0
		if amount > 500 then
			Logic.CreateConstructionSite(posX, posY, 0, Entities.PB_Outpost1, _player)
			if GUI.GetPlayerID() == _player then
				Camera.ScrollSetLookAt(posX, posY)
				Message("Seht doch! Euer Holzfäller hat die Burgruine von ihrer Überwucherung befreit und ihr könnt sie nun beziehen!")
				Stream.Start("Sounds\\VoicesMentor\\comment_goodfight_rnd_03.wav",112)
			end
			ArmyTable[7][PlayerToNVArmyIndex[_player] + 1].rodeLength = 7500
			return true
		end
	end
end

function _2SmallYetBigger()
	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.CU_Evil_Troll1 then
		SetEntitySize(entityID, 3)
	end
end

function WebControl()
	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XD_Cobweb1
	or entityType == Entities.XD_Cobweb2
	or entityType == Entities.XD_Cobweb3
	or entityType == Entities.XD_Cobweb4 then
		local pos = GetPosition(entityID)
		if GetDistance(pos, NVCenterPos[1]) <= 4000 or GetDistance(pos, NVCenterPos[2]) <= 4000 then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, "", "DelayedWebDestroyedAction", 1, {}, {pos.X, pos.Y})
		end
	end
end
function DelayedWebDestroyedAction(_x, _y)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison, _x, _y)
	CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"), _x, _y, 800, 200)
	local army = {}
	army.player = NVPlayer
	army.id	= GetFirstFreeArmySlot(NVPlayer)
	army.position = {X = _x, Y = _y}
	army.strength = 1 + round(Logic.GetTime()/1200)
	army.rodeLength	= 4000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities["CU_AggressiveScorpion" .. math.random(1,3)]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlWebArmies",1,{},{army.player, army.id, _x, _y})
	return true
end
function ControlWebArmies(_player, _id, _x, _y)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, _x, _y)
		CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"), _x, _y, 800, 200)
		local amount = 10 + math.random(10) + round(Logic.GetTime() / 600)
		Logic.SetResourceDoodadGoodAmount(Logic.CreateEntity(Entities.XD_Silver1, _x, _y, math.random(360), 0), math.random(round(amount*0.7), amount))
		return true
	else
		Defend(army)
	end
end
EntityDrownedData = {{types = {}, value = 0}, {types = {}, value = 0}}
function WeatherChangedTrigger()
	local oldweather = Event.GetOldWeatherState()
	local newweather = Event.GetNewWeatherState()
	if oldweather == 3 then
		leaderDataSolAmount = {}
		for entityID in CEntityIterator.Iterator(CEntityIterator.IsSettlerFilter(), CEntityIterator.IsNotSoldierFilter(), CEntityIterator.OfAnyPlayerFilter(1,2,3,4)) do
			if Logic.IsLeader(entityID) == 1 then
				local posX, posY = Logic.GetEntityPosition(entityID)
				local wheight = CUtil.GetWaterHeight(posX/100, posY/100)
				local terrheight = CUtil.GetTerrainNodeHeight(posX/100, posY/100)
				if wheight >= terrheight then
					leaderDataSolAmount[entityID] = Logic.LeaderGetNumberOfSoldiers(entityID) or 0
				end
			end
		end
	end
end
function CheckEntityDrowned()
	local entityID = Event.GetEntityID()
	if Logic.IsLeader(entityID) == 1 then
		local posX, posY = Logic.GetEntityPosition(entityID)
		local wheight = CUtil.GetWaterHeight(posX/100, posY/100)
		local terrheight = CUtil.GetTerrainNodeHeight(posX/100, posY/100)
		if wheight >= terrheight and Logic.IsWeatherChangeActive() then
			local size = Logic.WorldGetSize()
			local etype = Logic.GetEntityType(entityID)
			if etype > 0 then
				local solamount = leaderDataSolAmount[entityID] or 0
				if posY >= size/2 then
					table.insert(EntityDrownedData[1].types, etype)
					EntityDrownedData[1].value = EntityDrownedData[1].value + round(CalculateMercenaryOfferCosts(etype, solamount))
				else
					table.insert(EntityDrownedData[2].types, etype)
					EntityDrownedData[1].value = EntityDrownedData[1].value + round(CalculateMercenaryOfferCosts(etype, solamount))
				end
			end
		end
	end
end
EntityDrownedPos = {{X = 30400, Y = 38400}, {X = 30400, Y = 22500}}
EntityDrownedActive = {false, false}
function TrackEntityDrownedCount(_index)
	local val = EntityDrownedData[_index].value
	if val >= 10000 and not EntityDrownedActive[_index] then
		EntityDrownedActive[_index] = true
		local pos = EntityDrownedPos[_index]
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
		CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"), pos.X, pos.Y, 2000, 10000)
		local army = {}
		army.building = Logic.CreateEntity(Entities.CB_Bastille1, pos.X, pos.Y, 0, NVPlayer)
		army.player = NVPlayer
		army.id	= GetFirstFreeArmySlot(NVPlayer)
		army.position = pos
		army.strength = table.getn(EntityDrownedData[_index].types)
		army.rodeLength	= 4000
		SetupArmy(army)
		for i = 1, army.strength do
			EnlargeArmy(army, {leaderType = EntityDrownedData[_index].types[i]})
		end
		EntityDrownedData[_index].types = {}
		EntityDrownedData[_index].value = 0
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlSpecArmy",1,{},{army.player, army.id, pos.X, pos.Y, army.building, _index})
	end
end
function ControlSpecArmy(_player, _id, _x, _y, _building, _index)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		if IsDestroyed(_building) then
			EntityDrownedActive[_index] = false
			local id = Logic.CreateEntity(Entities.XD_ChestGold, _x, _y, 0, 0)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlSpecArmyChest", 1, {}, {id})
			return true
		end
	else
		Defend(army)
	end
end
gvSpecArmyBaseReward = 2500
function ControlSpecArmyChest(_id)
	local pos = GetPosition(_id)
	for j = 1, 4 do
		entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)};
		if entities[1] > 0 then
			if Logic.IsHero(entities[2]) == 1 then
				local gvBanditReward = math.floor(math.min(gvSpecArmyBaseReward + ((Logic.GetTime()/2)^(1+Logic.GetTime()/20000)),50000))
				local p1, p2
				if j == 1 or j == 2 then
					p1 = 1
					p2 = 2
				else
					p1 = 3
					p2 = 4
				end
				Message(UserTool_GetPlayerName(p1).." & "..UserTool_GetPlayerName(p2).." haben Schätze der Abtrünnigen geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
				Sound.PlayGUISound( Sounds.OnKlick_Select_pilgrim, 112 )
				DestroyEntity(_id)
				AddGold(p1, gvBanditReward)
				AddWood(p1, gvBanditReward)
				AddGold(p2, gvBanditReward)
				AddWood(p2, gvBanditReward)
				return true
			end
		end
	end
end
PawnPromotionMaxRange = 1500
function PawnPromotionControl(_player, _player2, _posX, _posY, _building1, _building2)
	if not IsExisting(_building1) and not IsExisting(_building2) then
		return true
	end
	local enemy1, enemy2 = GetPlayerIDsByTeamID(GetEnemyTeamIDByPlayerID(_player))
	if Score.Player[_player].battle + Score.Player[_player2].battle < (Score.Player[enemy1].battle + Score.Player[enemy2].battle) * 0.7 then
		local num, id = Logic.GetPlayerEntitiesInArea(_player, Entities.PU_Serf, _posX, _posY, PawnPromotionMaxRange, 1)
		if num >= 1 then
			local posX, posY = Logic.GetEntityPosition(id)
			Logic.CreateEffect(GGL_Effects.FXYukiFireworksJoy, posX, posY)
			ReplaceEntity(id, Entities.CU_VeteranCaptain)
			if GUI.GetPlayerID() == _player then
				Message("Einer Eurer Bauern wurde befördert!")
				GUI.ScriptSignal(posX, posY, 2)
			end
		end
	end
end