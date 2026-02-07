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
gvET23Flag = 1
EMS_CustomMapConfig =
{

	Version = 1.00,

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
		-- custom Map Stuff
		AddPeriodicSummer(10)

		MultiplayerTools.InitCameraPositionsForPlayers()

		LocalMusic.UseSet = HIGHLANDMUSIC
		for i = 1, 4 do
			Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
		end
		Display.SetPlayerColorMapping(7, NPC_COLOR)

		if XNetwork.Manager_DoesExist() == 0 then
			math.randomseed(Game.RealTimeGetMs())
			for i=1,4,1 do
				MultiplayerTools.DeleteFastGameStuff(i)
			end
			local PlayerID = GUI.GetPlayerID()
			Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
			Logic.PlayerSetGameStateToPlaying( PlayerID )
		end


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
		-- register bandits and evil stuff in statistics
		Logic.SetPlayerRawName(7, "???")
		Logic.PlayerSetIsHumanFlag(7, 1)
		Logic.PlayerSetPlayerColor(7, GUI.GetPlayerColor(7))
		--
		InitEggs(40, 1)
		InitEggs(40, 2)
	end,

	Callback_OnPeacetimeEnded = function()
		for i = 1,2 do
			ReplaceEntity("gate" .. i, Entities.XD_PalisadeGate2)
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED,"","SilverminePlaced",1,{},{})
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
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("mercenary"..i), Entities.CU_VeteranLieutenant, 4, ResourceType.Gold, 2500)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("mercenary"..i), Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("mercenary"..i), Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("mercenary"..i), Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
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
			local id = GetID("mercenary" .. j)
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
CenterPosByTeam = {	[1] = {X = 28800, Y = 44900},
					[2] = {X = 28800, Y = 12800}}
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
	end
end
function SilverminePlaced()
	local id = Event.GetEntityID()
	if Logic.GetEntityType(id) == Entities.PB_SilverMine1 then
		StartSimpleJob("DelayedSilverminePlacedActions")
		return true
	end
end
function DelayedSilverminePlacedActions()
	for player = 1, 4 do
		SetHostile(player, 7)
	end
	InitMerchants()
	for i = 3, 6 do
		ReplaceEntity("gate" .. i, Entities.XD_PalisadeGate2)
	end
	local id = Logic.CreateEntity(Entities.CU_AggressiveScorpion1, 0, 0, 0, 7)
	Logic.SetEntityName(id, "fakedamager")
	local maphalf = Logic.WorldGetSize()/2
	SilverminePos = {X = maphalf, Y = maphalf}
	rabbitCount = 0
	for x = -3000, 3000, 2000 do
		for y = -3000, 3000, 2000 do
			rabbitCount = rabbitCount + 1
			local posX, posY = maphalf + x, maphalf + y
			posX, posY = EvaluateNearestUnblockedPosition(_posX, _posY, 5000, 100)
			id = Logic.CreateEntity(Entities.XA_Rabbit_Evil, posX, posY, 0, 0)
			SetEntitySize(id, 2.5)
			Logic.SetEntityName(id, "rabbit" .. rabbitCount)
		end
	end
	RabbitFleeCounter = {}
	for i = 1, rabbitCount do
		RabbitFleeCounter[i] = 0
	end
	StartSimpleJob("ControlRabbits")
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSilvermineEmpty", 1)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSpecialRabbitDied", 1)
	return true
end
function ControlRabbits()
	for i = 1, rabbitCount do
		if IsValid("rabbit" .. i) then
			if GetEntityCurrentTask(Logic.GetEntityIDByName("rabbit" .. i)) == TaskLists.TL_ANIMAL_FLEE then
				RabbitFleeCounter[i] = RabbitFleeCounter[i] + 1
			else
				RabbitFleeCounter[i] = 0
			end
			if RabbitFleeCounter[i] >= 12 then
				local pos = GetPosition("rabbit" .. i)
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
				--[[
				if Counter.SDCounter then
					Counter.SDCounter.TickCount = math.min(Counter.SDCounter.TickCount + 60, Counter.SDCounter.Limit - 1)
				end
				]]
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
function OnSilvermineEmpty()

	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XD_SilverPit1 then
		local pos = GetPosition(entityID)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueInit",1,{},{})
	end

end
function RabbitStatueInit()

	if Counter.Tick2("RabbitStatueInit_Counter", 2*60) then
		Script.Load("maps/externalmap/mysterious_statue.lua")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{SilverminePos.X, SilverminePos.Y})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueMadness",1,{},{RabbitStatueID})
		return true
	end
end

function ControlRabbitStatue(_posX, _posY)

	if ({Logic.GetEntitiesInArea(Entities.XA_Rabbit_Evil, _posX, _posY, 2500, 2)})[1] == 2 then
		InitRabbitStatueEggs(_posX, _posY)
		return true
	end

end

function InitRabbitStatueEggs(_posX, _posY)

	Message("Es sind weitere Ostereier aufgetaucht!")
	local totaleggs = 12
	local count = 0
	local posX,posY
	local sec = CUtil.GetSector(_posX /100, _posY /100)
	local tempid
	local tempsec
	while count < totaleggs do
		posX, posY = EvaluateNearestUnblockedPosition(_posX, _posY, 5000, 100)
		if posX and posY then
			count = count + 1
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"RabbitStatue_EasterEgg_" .. count)
		end
	end
	RabbitStatue_EasterEggposTable = RabbitStatue_EasterEggposTable or {}
	for i = 1, totaleggs do
		RabbitStatue_EasterEggposTable[i] = GetPosition("RabbitStatue_EasterEgg_" .. i)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueEggs",1,{},{_posX, _posY})
end

function ControlRabbitStatueEggs(_posX, _posY)

	for j = 1, 4 do
		for k, v in pairs(RabbitStatue_EasterEggposTable) do
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
						local randomEventAmount = round(10 + math.random(10) * (1 + Logic.GetTime()/600))
						Logic.AddToPlayersGlobalResource(j, ResourceType.SilverRaw, randomEventAmount)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein besonders seltenes Osterei gefunden. Inhalt: "..randomEventAmount.." Silber")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 132 )
						end
					end
					DestroyEntity(Logic.GetEntityAtPosition(v.X, v.Y))
					table.remove(RabbitStatue_EasterEggposTable, k)
				end
			end
		end
	end
	if table.getn(RabbitStatue_EasterEggposTable) == 0 then
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{_posX, _posY})
		return true
	end
end
function RabbitStatueMadness(_id)

	if Score.Player[7].battle > 1500 then

		local eID = ReplaceEntity(_id, Entities.CB_RabbitStatue)
		newID = ChangePlayer(eID, 7)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueMadness", 1, {}, {newID})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnRabbitStatueDamaged", 1, {}, {newID})
		eff_flakes = Logic.CreateEffect(GGL_Effects.FXAshFlakes, SilverminePos.X, SilverminePos.Y)
		eff_embers = Logic.CreateEffect(GGL_Effects.FXEmbers, SilverminePos.X, SilverminePos.Y)
		return true
	end

end
function ControlRabbitStatueMadness(_eID)

	local range = gvLightning.Range + 2 * math.random(gvLightning.Range)
	local damage = gvLightning.BaseDamage + 5 * math.random(gvLightning.BaseDamage)
	local buildingdamage = (((gvLightning.BaseDamage + math.random(gvLightning.BaseDamage))*6) + math.min(GetCurrentWeatherGfxSet()*5,55)*gvLightning.DamageAmplifier)
	local pos = SilverminePos
	for i = 1,(math.ceil(math.min(500/(GetEntityHealth(_eID)+1),100))),1 do
		x = math.max(math.min(math.random(pos.X - 5000, pos.X + 5000), Mapsize - 100), 100)
		y = math.max(math.min(math.random(pos.Y - 5000, pos.Y + 5000), Mapsize - 100), 100)
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
	for i = 1, rabbitCount do
		if IsValid("rabbit"..i) then
			local posi = GetPosition("rabbit"..i)
			if GetDistance(posi, pos) <= 12000 then
				local count = math.random(GetEntityHealth(_eID))
				if count < 15 then
					Logic.CreateEffect(GGL_Effects.FXKalaPoison, posi.X, posi.Y)
					CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),posi.X,posi.Y,1000,300)
				end
			end
		end
	end
	if IsDestroyed(_eID) then
		RabbitStatueMadnessFallen()
		Logic.DestroyEffect(eff_embers)
		Logic.DestroyEffect(eff_flakes)
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
function RabbitStatueMadnessFallen()
	local pos = SilverminePos
	for x = -300, 300, 200 do
		for y = -300, 300, 200 do
			local posX, posY = pos.X + x, pos.Y + y
			local posX, posY = EvaluateNearestUnblockedPosition(posX, posY, 5000, 100)
			if posX and posY then
				local amount = 10 + round(Logic.GetTime() / 90)
				Logic.SetResourceDoodadGoodAmount(Logic.CreateEntity(Entities.XD_Silver1, posX, posY, math.random(360), 0), math.random(round(amount*0.7), amount))
			end
		end
	end
end
 