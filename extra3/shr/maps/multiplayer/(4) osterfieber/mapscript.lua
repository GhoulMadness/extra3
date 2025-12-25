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

	Version = 1.25,

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
		local fakers = {"fakedamager", "fakebuilding5", "fakebuilding6"}
		for i = 1, table.getn(fakers) do
			SetEntityVisibility(Logic.GetEntityIDByName(fakers[i]), 0)
		end
		AddPeriodicSummer(10)

		MultiplayerTools.InitCameraPositionsForPlayers()

		LocalMusic.UseSet = HIGHLANDMUSIC
		for i = 1, 4 do
			Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
		end
		Display.SetPlayerColorMapping(8, 14)
		Display.SetPlayerColorMapping(7, 11)
		InitMerchants()

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
		XGUIEng.ShowWidget("OP_AIUpgradesShowWindow", 1)
		ET.Setup()
		for i = 1,4 do
			ForbidTechnology(Technologies.T_MakeSnow,i)
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.PB_DrawBridgeClosed1, Entities.PB_Bridge2)) do
			MakeInvulnerable(eID)
		end
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
			SetHostile(i, 6)
			SetFriendly(i, 5)
			ActivateShareExploration(i, 5)
		end
		for i = 3,4 do
			SetHostile(i, 5)
			SetFriendly(i, 6)
			ActivateShareExploration(i, 6)
		end
		SetHostile(5, 6)
		for i = 5,6 do
			SetHostile(i,7)
		end
		ET.CreateAllyAI()
		for i = 1,4 do
			AllowTechnology(Technologies.T_MakeSnow,i)
			SetHostile(i,7)
		end
		local i = 0
		for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XA_Rabbit_Evil)) do
			i = i + 1
			Logic.SetEntityName(eID, "rabbit"..i)
		end
		for ID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_Rock7), CEntityIterator.InCircleFilter(SilverminePosByName.North.X, SilverminePosByName.North.Y, 3000)) do
			DestroyEntity(ID)
		end
		for ID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_Rock7), CEntityIterator.InCircleFilter(SilverminePosByName.South.X, SilverminePosByName.South.Y, 3000)) do
			DestroyEntity(ID)
		end
		StartSimpleJob("ControlRabbits")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSilvermineEmpty", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSpecialRabbitDied", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnOuterOutpostDestroyed", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "_300EggyAckEggs", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "TreesToUpvoteDovbar4President", 1)
		StartSimpleJob("CheckSheepGates")
		StartSimpleJob("SuddenDeathCounter")
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
	ET.UpdateRespawnTroops(ET.GetPlayersAI(newID), ET.GetPlayersAIIndex(newID))
	ET.UpdateSlots(ET.GetPlayersAI(newID), ET.GetPlayersAIIndex(newID))
	local pos = GetPlayerStartPosition(newID)
	Camera.ScrollSetLookAt(pos.X, pos.Y)
	Message("Ihr spielt nun aus der Perspektive von Spieler "..newID)
end
function InitMerchants()
	for i = 1,2 do
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.CU_VeteranLieutenant, 4, ResourceType.Gold, 2500)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merc"..i), Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
	end
end
CenterPosByTeam = {	[1] = {X = 49200, Y = 30400},
					[2] = {X = 11400, Y = 30400}}
EggyAckEggsPosByPlayer = { 	[1] = {X = 28300, Y = 54800},
							[2] = {X = 28300, Y = 6100},
							[3] = {X = 32600, Y = 6100},
							[4] = {X = 32600, Y = 54800}}
EggyAckOpsPosByPlayer = {	[1] = {X = 22900, Y = 58000},
							[2] = {X = 22900,Y = 2900},
							[3] = {X = 38000,Y = 2900},
							[4] = {X = 38000,Y = 58000}}
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
RabbitFleeCounter = {}
for i = 1,12 do
	RabbitFleeCounter[i] = 0
end
RabbitFleeCounter.North = 0
RabbitFleeCounter.South = 0
SilvermineSpawned = {}
function ControlRabbits()
	for i = 1,12 do
		if IsValid("rabbit"..i) then
			if GetEntityCurrentTask(Logic.GetEntityIDByName("rabbit"..i)) == TaskLists.TL_ANIMAL_FLEE then
				RabbitFleeCounter[i] = RabbitFleeCounter[i] + 1
			else
				RabbitFleeCounter[i] = 0
			end
			if RabbitFleeCounter[i] >= 12 then
				local pos = GetPosition("rabbit"..i)
				if GetDistance(pos, GetPosition("merc1")) < 12000 then
					RabbitFleeCounter.North = RabbitFleeCounter.North + 1
				elseif GetDistance(pos, GetPosition("merc2")) < 12000 then
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
	if RabbitFleeCounter.North >= Logic.GetTime()/300 and not SilvermineSpawned.North then
		CreateSilvermine("North")
	elseif RabbitFleeCounter.South >= Logic.GetTime()/300 and not SilvermineSpawned.South then
		CreateSilvermine("South")
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

SilverminePosByName = {	["North"] = {X = 30450, Y = 55800},
						["South"] = {X = 30450, Y = 4500}}
function CreateSilvermine(_name)
	SilvermineSpawned[_name] = true
	local pos = SilverminePosByName[_name]
	CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,3000,1600)
	Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
	for i = 1, 4 do
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X + i * 400, pos.Y + i * 400)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X + i * 400, pos.Y - i * 400)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X + i * 400, pos.Y)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y + i * 400)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X - i * 400, pos.Y)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y - i * 400)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X - i * 400, pos.Y + i * 400)
		Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X - i * 400, pos.Y - i * 400)
	end
	--
	Script.Load("maps/externalmap/silvermine_".._name..".lua")
end
function OnSilvermineEmpty()

	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XD_SilverPit1 then
		local pos = GetPosition(entityID)
		if GetDistance(pos, SilverminePosByName.North) < 1000 then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueInit",1,{},{"North"})
		elseif GetDistance(pos, SilverminePosByName.South) < 1000 then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueInit",1,{},{"South"})
		end

	end

end
RabbitStatueIDs = RabbitStatueIDs or {}
function RabbitStatueInit(_name)

	if Counter.Tick2("RabbitStatueInit_Counter".._name, 2*60) then
		Script.Load("maps/externalmap/mysterious_statue_".._name..".lua")
		local pos = SilverminePosByName[_name]
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{_name, pos.X, pos.Y})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","RabbitStatueMadness",1,{},{_name, RabbitStatueIDs[_name]})
		return true
	end
end

function ControlRabbitStatue(_name, _posX, _posY)

	if ({Logic.GetEntitiesInArea(Entities.XA_Rabbit_Evil, _posX, _posY, 2500, 2)})[1] == 2 then
		InitRabbitStatueEggs(_name, _posX, _posY)
		return true
	end

end

function InitRabbitStatueEggs(_name, _posX, _posY)

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
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"RabbitStatue_EasterEgg_".._name.."_"..count)
		end
	end
	RabbitStatue_EasterEggposTable = RabbitStatue_EasterEggposTable or {}
	RabbitStatue_EasterEggposTable[_name] = RabbitStatue_EasterEggposTable[_name] or {}
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
						local randomEventAmount = round(10 + math.random(10) * (1 + Logic.GetTime()/600))
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
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{_name, _posX, _posY})
		return true
	end
end
effIDs = {	["North"] = {},
			["South"] = {}}
function RabbitStatueMadness(_name, _id)

	if Score.Player[7].battle > 1500 then

		local eID = ReplaceEntity(_id, Entities.CB_RabbitStatue)
		newID = ChangePlayer(eID, 7)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueMadness", 1, {}, {_name, newID})
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnRabbitStatueDamaged", 1, {}, {newID})
		local pos = SilverminePosByName[_name]
		effIDs[_name].eff_flakes = Logic.CreateEffect(GGL_Effects.FXAshFlakes, pos.X, pos.Y)
		effIDs[_name].eff_embers = Logic.CreateEffect(GGL_Effects.FXEmbers, pos.X, pos.Y)
		return true
	end

end
function ControlRabbitStatueMadness(_name, _eID)

	local range = gvLightning.Range + 2 * math.random(gvLightning.Range)
	local damage = gvLightning.BaseDamage + 5 * math.random(gvLightning.BaseDamage)
	local buildingdamage = (((gvLightning.BaseDamage + math.random(gvLightning.BaseDamage))*6) + math.min(GetCurrentWeatherGfxSet()*5,55)*gvLightning.DamageAmplifier)
	local pos = SilverminePosByName[_name]
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
	for i = 1,12 do
		if IsValid("rabbit"..i) then
			local posi = GetPosition("rabbit"..i)
			if GetDistance(posi, pos) <= 12000 then
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
	local pos = SilverminePosByName[_name]
	for i = 1, 5 do
		local posX, posY = EvaluateNearestUnblockedPosition(pos.X, pos.Y, 5000, 100)
		if posX and posY then
			local amount = 10 + round(Logic.GetTime() / 90)
			Logic.SetResourceDoodadGoodAmount(Logic.CreateEntity(Entities.XD_Silver1, posX, posY, math.random(360), 0), math.random(round(amount*0.7), amount))
		end
	end
end

SheepAreaCount = { }
for i = 1,2 do
	if not SheepAreaCount[i] then
		SheepAreaCount[i] = 0
	end
end
SheepGateArea = {   [1] = {X = 30450, Y = 49460},
					[2] = {X = 30450, Y = 11500}
						}
function CheckSheepGates()

	for i = 1,2 do
		local mercid = Logic.GetEntityIDByName("merc"..i)
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.XA_Sheep1,Entities.XA_Sheep2,Entities.XA_Sheep3),CEntityIterator.InCircleFilter(SheepGateArea[i].X, SheepGateArea[i].Y, 300)) do
			local slot = math.random(0, 3)
			DestroyEntity(eID)
			SheepAreaCount[i] = SheepAreaCount[i] + 1
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, SheepGateArea[i].X, SheepGateArea[i].Y)
			SetMercenaryOfferLeft(mercid, slot, GetMercenaryOfferLeft(mercid, slot) + 1)
		end
		if SheepAreaCount[i] > Logic.GetTime()/600 then
			local id = Logic.CreateEntity(Entities.XD_ChestIron, SheepGateArea[i].X, SheepGateArea[i].Y, 90, 0)
			if not SheepRewardChestJob then
				SheepRewardChestJob = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlSheepRewardChest", 1, {}, {id})
				SheepAreaCount[i] = 0
			end
		end
	end

end
function ControlSheepRewardChest(_id)

	local pos = GetPosition(_id)
	for j = 1,4 do
		entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)}
		if entities[1] > 0 then
			if Logic.IsHero(entities[2]) == 1 then
				randomEvent = gvChestEvents[j][math.random(table.getn(gvChestEvents[j]))]
				if randomEvent == "SilverPot" then
					randomEventAmount = round(300 + math.random(300) ^ (1 + Logic.GetTime()/ 36000))
					randomEventText = randomEventAmount .. " Silber"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Silver,randomEventAmount)
				elseif randomEvent == "HeroInTheBox" then
					local heroes, herotypes, tpos = {}, {}, 0
					Logic.GetHeroes(j,heroes)
					for i = 1,table.getn(heroes) do
						herotypes[i] = Logic.GetEntityType(heroes[i])
					end
					for i = 1,table.getn(herotypes) do
						tpos = table_findvalue(gvHeroesTablePlayer[j], herotypes[i])
						if tpos ~= 0 then
							table.remove(gvHeroesTablePlayer[j], tpos)
						end
					end
					randomEventAmount = gvHeroesTablePlayer[j][math.random(table.getn(gvHeroesTablePlayer[j]))]
					local heroname = Logic.GetEntityTypeName(randomEventAmount)
					randomEventText = XGUIEng.GetStringTableText("names/"..heroname)
					pos.X, pos.Y = EvaluateNearestUnblockedPosition(pos.X, pos.Y, 300, 50)
					Logic.CreateEntity(randomEventAmount,pos.X,pos.Y,j,0)
				elseif randomEvent == "SilverTechMiracle" then
					local tabpos = math.random(8)
					randomEventAmount = gvSilverTechTable[tabpos]
					randomEventText = XGUIEng.GetStringTableText("names/"..gvSilverTechStringTable[tabpos])
					Logic.SetTechnologyState(j,randomEventAmount,3)
				elseif randomEvent == "LuckyPayday" then
					randomEventAmount = Logic.GetPlayerPaydayCost(j)*(math.random(8))
					randomEventText = randomEventAmount .. " Taler"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
				elseif randomEvent == "ThunderGodsBlessing" then
					randomEventAmount = 800+math.random(800)
					randomEventText = randomEventAmount .. " Sekunden Immunität gegenüber Blitzeinschlägen"
					gvLightning.RodProtected[j] = true
					Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","LightningRod_UnProtected",1,{},{j,randomEventAmount})
					removetablekeyvalue(gvChestEvents[j], randomEvent)
				elseif randomEvent == "SlipperyThief" then
					randomEventAmount = Technologies.T_Chest_ThiefBuff
					randomEventText = "Noch schnellere Diebe"
					Logic.SetTechnologyState(j, randomEventAmount, 3)
					removetablekeyvalue(gvChestEvents[j], randomEvent)
				elseif randomEvent == "DivineProvidence" then
					local ally
					if j == 1 then
						ally = 2
					elseif j == 2 then
						ally = 1
					elseif j == 3 then
						ally = 4
					elseif j == 4 then
						ally = 3
					end
					randomEventAmount = 80 + math.random(160)
					randomEventText = "Sichtbarkeit der gesamten Map für ".. randomEventAmount .." Sekunden"
					exploreID1 = Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X,pos.Y,j,0)
					exploreID2 = Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X-100,pos.Y-100,ally,0)
					Logic.SetEntityExplorationRange(exploreID1,10000)
					Logic.SetEntityExplorationRange(exploreID2,10000)
					StartCountdown(randomEventAmount,function() DestroyEntity(exploreID1);	DestroyEntity(exploreID2) end,false)
				elseif randomEvent == "LovingBuddies" then
					local ally
					if j == 1 then
						ally = 2
					elseif j == 2 then
						ally = 1
					elseif j == 3 then
						ally = 4
					elseif j == 4 then
						ally = 3
					end
					randomEventAmount = round(Logic.GetPlayersGlobalResource(j, ResourceType.GoldRaw)/1.5)
					randomEventText = "Der Verbündete erhält " .. randomEventAmount .. " Taler"
					Logic.AddToPlayersGlobalResource(ally,ResourceType.GoldRaw,randomEventAmount)
				elseif randomEvent == "IronPot" then
					randomEventAmount = round(5000 + math.random(5000) ^ (1 + Logic.GetTime()/ 36000))
					randomEventText = randomEventAmount .. " Eisen"
					Logic.AddToPlayersGlobalResource(j,ResourceType.IronRaw,randomEventAmount)
				elseif randomEvent == "CrazyWoodenPot" then
					randomEventAmount = round(3000 + math.random(3000) ^ (1 + Logic.GetTime()/ 36000))
					randomEventText = randomEventAmount .. " Holz und Schwefel"
					Logic.AddToPlayersGlobalResource(j,ResourceType.WoodRaw,randomEventAmount)
					Logic.AddToPlayersGlobalResource(j,ResourceType.SulfurRaw,randomEventAmount)
				elseif randomEvent == "ForbiddenSpell" then
					local enemy1, enemy2
					if j == 1 or j == 2 then
						enemy1, enemy2 = 3,4
					elseif j == 3 or j == 4 then
						enemy1, enemy2 = 1,2
					end
					randomEventText = UserTool_GetPlayerName(enemy1) .. " und ".. UserTool_GetPlayerName(enemy2) ..  " velieren all ihre Truppentechnologien und können diese nicht wieder erforschen!"
					for i = 1,table.getn(gvTechTable.TroopUpgrades) do
						Logic.SetTechnologyState(enemy1, gvTechTable.TroopUpgrades[i], 0)
						Logic.SetTechnologyState(enemy2, gvTechTable.TroopUpgrades[i], 0)
					end
					for i = 1,table.getn(gvTechTable.SilverTechs) do
						Logic.SetTechnologyState(enemy1, gvTechTable.TroopUpgrades[i], 0)
						Logic.SetTechnologyState(enemy2, gvTechTable.TroopUpgrades[i], 0)
					end
					removetablekeyvalue(gvChestEvents[j], randomEvent)
				end
				Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine geheimnisvolle Schatztruhe geplündert. Inhalt: " .. randomEventText )
				DestroyEntity(_id)
				SheepRewardChestJob = nil
				return true
			end
		end
	end
end
gvHeroesTablePlayer = 	{[1] = {
							[1] = Entities.PU_Hero1c,
							[2] = Entities.PU_Hero2,
							[3] = Entities.PU_Hero3,
							[4] = Entities.PU_Hero4,
							[5] = Entities.PU_Hero5,
							[6] = Entities.PU_Hero6,
							[7] = Entities.CU_Barbarian_Hero,
							[8] = Entities.CU_BlackKnight,
							[9] = Entities.CU_Mary_de_Mortfichet,
							[10] = Entities.PU_Hero10,
							[11] = Entities.PU_Hero11,
							[12] = Entities.CU_Evil_Queen,
							[13] = Entities.PU_Hero13,
							[14] = Entities.PU_Hero14},
						[2] = {
							[1] = Entities.PU_Hero1c,
							[2] = Entities.PU_Hero2,
							[3] = Entities.PU_Hero3,
							[4] = Entities.PU_Hero4,
							[5] = Entities.PU_Hero5,
							[6] = Entities.PU_Hero6,
							[7] = Entities.CU_Barbarian_Hero,
							[8] = Entities.CU_BlackKnight,
							[9] = Entities.CU_Mary_de_Mortfichet,
							[10] = Entities.PU_Hero10,
							[11] = Entities.PU_Hero11,
							[12] = Entities.CU_Evil_Queen,
							[13] = Entities.PU_Hero13,
							[14] = Entities.PU_Hero14},
						[3] = {
							[1] = Entities.PU_Hero1c,
							[2] = Entities.PU_Hero2,
							[3] = Entities.PU_Hero3,
							[4] = Entities.PU_Hero4,
							[5] = Entities.PU_Hero5,
							[6] = Entities.PU_Hero6,
							[7] = Entities.CU_Barbarian_Hero,
							[8] = Entities.CU_BlackKnight,
							[9] = Entities.CU_Mary_de_Mortfichet,
							[10] = Entities.PU_Hero10,
							[11] = Entities.PU_Hero11,
							[12] = Entities.CU_Evil_Queen,
							[13] = Entities.PU_Hero13,
							[14] = Entities.PU_Hero14},
						[4] = {
							[1] = Entities.PU_Hero1c,
							[2] = Entities.PU_Hero2,
							[3] = Entities.PU_Hero3,
							[4] = Entities.PU_Hero4,
							[5] = Entities.PU_Hero5,
							[6] = Entities.PU_Hero6,
							[7] = Entities.CU_Barbarian_Hero,
							[8] = Entities.CU_BlackKnight,
							[9] = Entities.CU_Mary_de_Mortfichet,
							[10] = Entities.PU_Hero10,
							[11] = Entities.PU_Hero11,
							[12] = Entities.CU_Evil_Queen,
							[13] = Entities.PU_Hero13,
							[14] = Entities.PU_Hero14}
					}
gvSilverTechTable = {
						[1] = Technologies.T_SilverPlateArmor,
						[2] = Technologies.T_SilverArcherArmor,
						[3] = Technologies.T_SilverArrows,
						[4] = Technologies.T_SilverSwords,
						[5] = Technologies.T_SilverLance,
						[6] = Technologies.T_SilverBullets,
						[7] = Technologies.T_SilverMissiles,
						[8] = Technologies.T_BloodRush
					}
gvSilverTechStringTable = {
						[1] = "T_SilverPlateArmor",
						[2] = "T_SilverArcherArmor",
						[3] = "T_SilverArrows",
						[4] = "T_SilverSwords",
						[5] = "T_SilverLance",
						[6] = "T_SilverBullets",
						[7] = "T_SilverMissiles",
						[8] = "T_BloodRush"
					}
gvChestEvents = {[1] = {
						-- zufällige Menge Silber
						[1] = "SilverPot",
						-- ein zufälliger zusätzlicher Held
						[2] = "HeroInTheBox",
						-- zufällige Tech aus der Silberschmelze
						[3] = "SilverTechMiracle",
						-- Taler abhängig vom Zahltag
						[4] = "LuckyPayday",
						-- einige Minuten immun gegen Blitzeinschläge
						[5] = "ThunderGodsBlessing",
						-- spezielle Tech für Diebe, erhöhtes Lauftempo
						[6] = "SlipperyThief",
						-- ganze Karte wird kurzzeitig fürs Team aufgedeckt
						[7] = "DivineProvidence",
						-- Verbündeter erhält zufällige Ressourcen abhängig der eigenen Höhe
						[8] = "LovingBuddies",
						-- zufällige Menge Eisen
						[9] = "IronPot",
						-- zufällige Menge Holz und Schwefel
						[10] = "CrazyWoodenPot",
						-- entfernt gegn. Truppentechs und verhindert jegliche Forschung dieser
						[11] = "ForbiddenSpell"},
				[2] = {	[1] = "SilverPot",
						[2] = "HeroInTheBox",
						[3] = "SilverTechMiracle",
						[4] = "LuckyPayday",
						[5] = "ThunderGodsBlessing",
						[6] = "SlipperyThief",
						[7] = "DivineProvidence",
						[8] = "LovingBuddies",
						[9] = "IronPot",
						[10] = "CrazyWoodenPot",
						[11] = "ForbiddenSpell"},
				[3] = {	[1] = "SilverPot",
						[2] = "HeroInTheBox",
						[3] = "SilverTechMiracle",
						[4] = "LuckyPayday",
						[5] = "ThunderGodsBlessing",
						[6] = "SlipperyThief",
						[7] = "DivineProvidence",
						[8] = "LovingBuddies",
						[9] = "IronPot",
						[10] = "CrazyWoodenPot",
						[11] = "ForbiddenSpell"},
				[4] = {	[1] = "SilverPot",
						[2] = "HeroInTheBox",
						[3] = "SilverTechMiracle",
						[4] = "LuckyPayday",
						[5] = "ThunderGodsBlessing",
						[6] = "SlipperyThief",
						[7] = "DivineProvidence",
						[8] = "LovingBuddies",
						[9] = "IronPot",
						[10] = "CrazyWoodenPot",
						[11] = "ForbiddenSpell"},
					}
function SuddenDeathCounter()
	if Counter.Tick2("SDCounter", 2.5 * 60 * 60) then
		Script.Load("maps/externalmap/center_bandits.lua")
		InitBanditTroops()
		StartSimpleJob("BanditTowerControl")
		return true
	end
end
function InitBanditTroops()
	Display.SetPlayerColorMapping(7,ROBBERS_COLOR)
	for i = 1, table.getn(gvTechTable.TroopUpgrades) do
		ResearchTechnology(gvTechTable.TroopUpgrades[i], 7)
	end
	CreateCenterArmy()
end
function CreateCenterArmy()
	CenterArmy	= {}
    CenterArmy.player 	= 7
    CenterArmy.id = 1
    CenterArmy.strength = 8
    CenterArmy.position = GetPosition("BanditChestTower")
    CenterArmy.rodeLength = 3200
	CenterArmy.RespawnBuilding = "BanditChestTower"
	SetupArmy(CenterArmy)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 3
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranLieutenant

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow4

	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 6
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.CU_BlackKnight_LeaderSword3

    for i = 1, 2 do
	    EnlargeArmy(CenterArmy,troopDescription)
	end
	for i = 1, 3 do
	    EnlargeArmy(CenterArmy,troopDescription2)
	end
	for i = 1, 3 do
	    EnlargeArmy(CenterArmy,troopDescription3)
	end
    StartSimpleJob("ControlCenterArmy")
end
function ControlCenterArmy()

    if IsDead(CenterArmy) and IsExisting(CenterArmy.RespawnBuilding) then
        CreateCenterArmy()
        return true
    else
		Defend(CenterArmy)
    end
end
BanditTowerPos = {X = 30400, Y = 30400}
function BanditTowerControl()
	if not IsExisting(CenterArmy.RespawnBuilding) then
		local pos = BanditTowerPos
		if LastTowerCheckForCircumstances() then
			LastTowerInitStatue(pos, EvaluateFavoredTeamPIDs(pos, 3000))
		else
			local id = Logic.CreateEntity(Entities.XD_ChestGold, pos.X, pos.Y, 0, 0)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlBanditTowerChest", 1, {}, {id})
		end
		return true
	end
end
gvBanditBaseReward = 2500
function ControlBanditTowerChest(_id)
	local pos = GetPosition(_id)
	for j = 1, 4 do
		entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 300, 1)};
		if entities[1] > 0 then
			if Logic.IsHero(entities[2]) == 1 then
				local gvBanditReward = math.floor(math.min(gvBanditBaseReward + ((Logic.GetTime()/2)^(1+Logic.GetTime()/20000)),50000))
				local p1, p2
				if j == 1 or j == 2 then
					p1 = 1
					p2 = 2
				else
					p1 = 3
					p2 = 4
				end
				Message(UserTool_GetPlayerName(p1).." & "..UserTool_GetPlayerName(p2).." haben Schätze der Barbaren geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
				Sound.PlayGUISound( Sounds.OnKlick_Select_pilgrim, 112 )
				DestroyEntity(_id)
				AddGold(p1, gvBanditReward)
				AddWood(p1, gvBanditReward)
				AddGold(p2, gvBanditReward)
				AddWood(p2, gvBanditReward)
			end
		end
	end
end
function LastTowerCheckForCircumstances()

	local GameTime = Logic.GetTime() - (gvDayCycleStartTime or 0)
	local secondsperday = gvDayTimeSeconds or 1440
	local daytimefactor = secondsperday/86400
	local TimeMinutes = math.floor(GameTime/(3600*daytimefactor))
	local currenthour = 8+(TimeMinutes/60)
	while currenthour > 12 do
		currenthour = currenthour - 12
	end
	return (GetCurrentWeatherGfxSet() == 11 or GetCurrentWeatherGfxSet() == 28) and (currenthour >= 3 and currenthour <= 3.5)
end
function LastTowerInitStatue(_posTable, _playerTable)

	local eID = Logic.CreateEntity(Entities.PB_VictoryStatue2, _posTable.X, _posTable.Y, 0, 8)
	MakeInvulnerable(eID)
	InitBeastStatueTributes(_playerTable)
	Message(UserTool_GetPlayerName(_playerTable[1]).." & "..UserTool_GetPlayerName(_playerTable[2]).." haben die Bestienstatue erweckt!")

end
function InitBeastStatueTributes(_playerTable)
	local TrBS_T1_1 =  {}
	TrBS_T1_1.pId = _playerTable[1]
	TrBS_T1_1.text = "Opfert der Bestienstatue 20.000 Holz!"
	TrBS_T1_1.cost = { Wood = 20000 }
	TrBS_T1_1.Callback = TributePaid_TrBS_T1_1
	TrB_T1_1 = AddTribute(TrBS_T1_1)
	local TrBS_T1_2 =  {}
	TrBS_T1_2.pId = _playerTable[2]
	TrBS_T1_2.text = "Opfert der Bestienstatue 20.000 Holz!"
	TrBS_T1_2.cost = { Wood = 20000 }
	TrBS_T1_2.Callback = TributePaid_TrBS_T1_2
	TrB_T1_2 = AddTribute(TrBS_T1_2)
	------------------------------------------------
	local TrBS_T2_1 =  {}
	TrBS_T2_1.pId = _playerTable[1]
	TrBS_T2_1.text = "Opfert der Bestienstatue 5 Schafe. Die Schafe müssen sich in der Nähe der Statue befinden!"
	TrBS_T2_1.cost = { Gold = 0 }
	TrBS_T2_1.Callback = TributePaid_TrBS_T2_1
	TrB_T2_1 = AddTribute(TrBS_T2_1)
	local TrBS_T2_2 =  {}
	TrBS_T2_2.pId = _playerTable[2]
	TrBS_T2_2.text = "Opfert der Bestienstatue 5 Schafe. Die Schafe müssen sich in der Nähe der Statue befinden!"
	TrBS_T2_2.cost = { Gold = 0 }
	TrBS_T2_2.Callback = TributePaid_TrBS_T2_2
	TrB_T2_2 = AddTribute(TrBS_T2_2)
	------------------------------------------------
	local TrBS_T3_1 =  {}
	TrBS_T3_1.pId = _playerTable[1]
	TrBS_T3_1.text = "Opfert der Bestienstatue einen Eurer Helden. Der Held muss sich in der Nähe der Statue befinden und am Leben sein!"
	TrBS_T3_1.cost = { Gold = 0 }
	TrBS_T3_1.Callback = TributePaid_TrBS_T3_1
	TrB_T3_1 = AddTribute(TrBS_T3_1)
	local TrBS_T3_2 =  {}
	TrBS_T3_2.pId = _playerTable[2]
	TrBS_T3_2.text = "Opfert der Bestienstatue einen Eurer Helden. Der Held muss sich in der Nähe der Statue befinden und am Leben sein!"
	TrBS_T3_2.cost = { Gold = 0 }
	TrBS_T3_2.Callback = TributePaid_TrBS_T3_2
	TrB_T3_2 = AddTribute(TrBS_T3_2)
end
function TributePaid_TrBS_T1_1(_tribute)
	local amount = math.floor(math.min(math.random(300,500) + ((Logic.GetTime()/10)^(1+Logic.GetTime()/10000)), 1000))
	Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 20.000 Holz geopfert. @cr Belohnung: "..amount.." Silber!")
	Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
end
function TributePaid_TrBS_T1_2(_tribute)
	local amount = math.floor(math.min(math.random(300,500) + ((Logic.GetTime()/10)^(1+Logic.GetTime()/10000)), 1000))
	Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 20.000 Holz geopfert. @cr Belohnung: "..amount.." Silber!")
	Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
end
function TributePaid_TrBS_T2_1(_tribute)
	if BeastStatueTributes_CheckForSheeps(_tribute.pId) then
		local amount = math.floor(math.min(math.random(600,1000) + ((Logic.GetTime()/5)^(1+Logic.GetTime()/10000)), 3000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 5 Schafe geopfert. @cr Belohnung: "..amount.." Silber und "..amount*10 .." aller anderen Ressourcen!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Gold, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Clay, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Stone, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount*10)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Nicht genug Schafe in der Nähe der Bestienstatue!")
		end
		local TrBS_T2_1 =  {}
		TrBS_T2_1.pId = _tribute.pId
		TrBS_T2_1.text = _tribute.text
		TrBS_T2_1.cost = _tribute.cost
		TrBS_T2_1.Callback = TributePaid_TrBS_T2_1
		TrB_T2_1 = AddTribute(TrBS_T2_1)
	end
end
function TributePaid_TrBS_T2_2(_tribute)
	if BeastStatueTributes_CheckForSheeps(_tribute.pId) then
		local amount = math.floor(math.min(math.random(600,1000) + ((Logic.GetTime()/5)^(1+Logic.GetTime()/10000)), 3000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 5 Schafe geopfert. @cr Belohnung: "..amount.." Silber und "..amount*10 .." aller anderen Ressourcen!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Gold, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Clay, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Stone, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount*10)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Nicht genug Schafe in der Nähe der Bestienstatue!")
		end
		local TrBS_T2_2 =  {}
		TrBS_T2_2.pId = _tribute.pId
		TrBS_T2_2.text = _tribute.text
		TrBS_T2_2.cost = _tribute.cost
		TrBS_T2_2.Callback = TributePaid_TrBS_T2_2
		TrB_T2_2 = AddTribute(TrBS_T2_2)
	end
end
function TributePaid_TrBS_T3_1(_tribute)
	local bool, name = BeastStatueTributes_CheckForHero(_tribute.pId)
	local heroname
	if bool then
		heroname = XGUIEng.GetStringTableText("names/"..Logic.GetEntityTypeName(name))
		local amount = math.floor(math.min(math.random(15000,20000) + ((Logic.GetTime()/3)^(1+Logic.GetTime()/8000)), 50000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue "..heroname.." geopfert. @cr Belohnung: "..amount.." Holz und Eisen und "..amount/2 .." Schwefel!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount/2)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Es befindet sich kein Held in der Nähe der Bestienstatue!")
		end
		local TrBS_T3_1 =  {}
		TrBS_T3_1.pId = _tribute.pId
		TrBS_T3_1.text = _tribute.text
		TrBS_T3_1.cost = _tribute.cost
		TrBS_T3_1.Callback = TributePaid_TrBS_T3_1
		TrB_T3_1 = AddTribute(TrBS_T3_1)
	end
end
function TributePaid_TrBS_T3_2(_tribute)
	local bool, name = BeastStatueTributes_CheckForHero(_tribute.pId)
	local heroname
	if bool then
		heroname = XGUIEng.GetStringTableText("names/"..Logic.GetEntityTypeName(name))
		local amount = math.floor(math.min(math.random(15000,20000) + ((Logic.GetTime()/3)^(1+Logic.GetTime()/8000)), 50000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue "..heroname.." geopfert. @cr Belohnung: "..amount.." Holz und Eisen und "..amount/2 .." Schwefel!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount/2)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Es befindet sich kein Held in der Nähe der Bestienstatue!")
		end
		local TrBS_T3_2 =  {}
		TrBS_T3_2.pId = _tribute.pId
		TrBS_T3_2.text = _tribute.text
		TrBS_T3_2.cost = _tribute.cost
		TrBS_T3_2.Callback = TributePaid_TrBS_T3_2
		TrB_T3_2 = AddTribute(TrBS_T3_2)
	end
end
function BeastStatueTributes_CheckForSheeps(_playerID)
	local pos = BanditTowerPos
	local entities = {}
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.XA_Sheep1,Entities.XA_Sheep2,Entities.XA_Sheep3),CEntityIterator.InCircleFilter(pos.X, pos.Y, 1000)) do
		table.insert(entities, eID)
	end
	if table.getn(entities) >= 5 then
		for i = 1,5,1 do
			local sheeppos = GetPosition(entities[i])
			Logic.CreateEffect(GGL_Effects.FXKalaPoison,sheeppos.X,sheeppos.Y)
			Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,sheeppos.X,sheeppos.Y)
			DestroyEntity(entities[i])
		end
		return true
	else
		return false
	end
end
function BeastStatueTributes_CheckForHero(_playerID)
	local pos = BanditTowerPos
	local entities = {}
	for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Hero),CEntityIterator.OfPlayerFilter(_playerID),CEntityIterator.InCircleFilter(pos.X, pos.Y, 600)) do
		if GetEntityHealth(eID) > 0 then
			table.insert(entities, eID)
		end
	end
	if entities[1] ~= nil then
		local heropos = GetPosition(entities[1])
		local herotype = Logic.GetEntityType(entities[1])
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,heropos.X,heropos.Y)
		Logic.CreateEffect(GGL_Effects.FXDieHero,heropos.X,heropos.Y,_playerID)
		Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,heropos.X,heropos.Y)
		DestroyEntity(entities[1])
		return true, herotype
	else
		return false
	end
end
EvaluateFavoredTeamPIDs = function(_pos, _range)
	local count_t1, count_t2 = 0, 0
	for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Military), CEntityIterator.OfAnyPlayerFilter(1, 2), CEntityIterator.InCircleFilter(_pos.X, _pos.Y, _range)) do
		count_t1 = count_t1 + 1
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Military), CEntityIterator.OfAnyPlayerFilter(3, 4), CEntityIterator.InCircleFilter(_pos.X, _pos.Y, _range)) do
		count_t2 = count_t2 + 1
	end
	if count_t1 > count_t2 then
		return {1, 2}
	elseif count_t2 > count_t1 then
		return {3, 4}
	else
		local mul = math.random(0,1)
		return {1+2*mul, 2+2*mul}
	end
end
function _300EggyAckEggs()
	if not _300BraveScore then
		_300BraveScore = {0, 0, 0, 0}
	end
	local entityID = Event.GetEntityID()
	if Logic.IsSettler(entityID) == 1 and Logic.IsWorker(entityID) == 0 then
		local player = GetPlayer(entityID)
		if _300BraveScore[player] then
			if Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Outpost1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Outpost2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Outpost3) == 0 then
				local pos = EggyAckEggsPosByPlayer[player]
				if GetDistance(GetPosition(entityID), pos) <= 2500 then
					_300BraveScore[player] = _300BraveScore[player] + 1
					if _300BraveScore[player] >= 300 then
						--accomplished
						_300EggyAcksEggsAcc(player)
						_300BraveScore[player] = 0
					end
				end
			end
		end
	end
end
function _300EggyAcksEggsAcc(_playerID)
	local pos = EggyAckOpsPosByPlayer[_playerID]
	Logic.CreateConstructionSite(pos.X, pos.Y, 0, Entities.PB_Outpost1, _playerID)
	if GUI.GetPlayerID() == _playerID then
		Camera.ScrollSetLookAt(pos.X, pos.Y)
		Message("Seht doch! All das vergossene Blut war nicht vergebens. @cr Die Götter selbst erlauben Euch eine erneute Verwendung der Burgruine!")
		Stream.Start("Sounds\\VoicesMentor\\comment_goodfight_rnd_03.wav",112)
	end
end
function TreesToUpvoteDovbar4President()
	if not Trees4DovbarScore then
		Trees4DovbarScore = {0, 0, 0, 0}
	end
	local entityID = Event.GetEntityID()
	local etype = Logic.GetEntityType(entityID)
	if etype == Entities.XD_Rock1 then
		for i = 1, 4 do
			if Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Outpost1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Outpost2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Outpost3) == 0 then
				if Trees4DovbarScore[i] >= 15 then
					TreesToUpvoteDovbar4PresidentMissionAccomplished(i)
					break
				end
				local pos = EggyAckOpsPosByPlayer[i]
				if GetDistance(GetPosition(entityID), pos) <= 4000 then
					Trees4DovbarScore[i] = Trees4DovbarScore[i] + 1
				end
			end
		end
	end
end
function TreesToUpvoteDovbar4PresidentMissionAccomplished(_playerID)
	Trees4DovbarScore[_playerID] = 0
	local pos = EggyAckOpsPosByPlayer[_playerID]
	Logic.CreateConstructionSite(pos.X, pos.Y, 0, Entities.PB_Outpost1, _playerID)
	if GUI.GetPlayerID() == _playerID then
		Camera.ScrollSetLookAt(pos.X, pos.Y)
		Message("Herr, seht doch! @cr Ein Wunder ist geschehen! @cr Die Natur gibt Euch eine weitere Chance, Euren Außenposten wieder in Besitz zu nehmen!")
		Stream.Start("Sounds\\VoicesMentor\\comment_goodplay_rnd_08.wav",112)
	end
end
-- Outpost AI stuff; von Mad's Winterzauber geklaut und angepasst
function OP_TroopUpgradeToggleWindowButton()
	local widget = "EasterT23"
	if XGUIEng.IsWidgetShown(widget) == 0 then
		XGUIEng.ShowWidget(widget, 1)
	else
		XGUIEng.ShowWidget(widget, 0)
	end
end
ET = {}
ET.TroopTypes =
{
	Sword = 1,
	PoleArm = 2,
	Bow = 3,
	Rifle = 4,
	CavalryLight = 5,
	Cavalry = 6,
	Cannon1 = 7,
	Cannon2 = 8
}

ET.TroopTypeMapping =
{
	"PU_LeaderSword",
	"PU_LeaderPoleArm",
	"PU_LeaderBow",
	"PU_LeaderRifle",
	"PU_LeaderCavalry",
	"PU_LeaderHeavyCavalry",
	"PV_Cannon",
	"PV_Cannon",
}


ET.TroopBaseCosts = {
	{ResourceType.Iron, 400},
	{ResourceType.Wood, 350},
	{ResourceType.Wood, 500},
	{ResourceType.Sulfur, 450},
	{ResourceType.Wood, 1000},
	{ResourceType.Iron, 1100},
	{ResourceType.Iron, 850},
	{ResourceType.Sulfur, 600}
}

ET.TroopPriceIncreasePerUpgrade = {
	300,
	250,
	350,
	500,
	500,
	600,
	1200,
	900
}

ET.AI1 = 5
ET.AI2 = 6

ET.RespawnTimerDecrease = 30
ET.BonusCostPerSlot = 200

function ET.Setup()

	-- Ally computer
	local respawnMinutes = 8
	local availableSlots = 2
	ET.AI = {}

	ET.AI[ET.AI1] = {{}, {}}
	ET.AI[ET.AI2] = {{}, {}}

	for i = ET.AI1, ET.AI2 do
		ET.AI[i].TroopDefUpgrades = 0
		ET.AI[i].TroopOffUpgrades = 0
		for k = 1, 2 do
			ET.AI[i][k].RespawnTimeMax = respawnMinutes*60
			ET.AI[i][k].RespawnTime = 0
			ET.AI[i][k].SlotsAvailable = availableSlots
			ET.AI[i][k].BonusSlotsAvailable = 0
			ET.AI[i][k].RespawnTroops = {} -- troops that will be spawned every respawn
			ET.AI[i][k].UpgradeLevel = 1 -- levels 1-4 of troops
			ET.AI[i][k].SpawnPosition = ET.GetSpawnPosition(i, k)
			ET.AI[i][k].BonusRodeLength = 0
			ET.AI[i][k].RangeLevel = 0
			ET.AI[i][k].IDs = {}
		end
	end

	-- hide other slots
	for i = availableSlots+1, 16 do
		XGUIEng.ShowWidget("EasterT23S"..i, 0)
	end
	for i = 7, 8 do
		XGUIEng.ShowWidget("EasterT23O"..i, 0)
	end

	ET.TroopPricePerCount = 500

	ET.ResourceNames = {
		[ResourceType.Gold] = ET.TextTable.Gold,
		[ResourceType.Clay] = ET.TextTable.Clay,
		[ResourceType.Wood] = ET.TextTable.Wood,
		[ResourceType.Stone] = ET.TextTable.Stone,
		[ResourceType.Iron] = ET.TextTable.Iron,
		[ResourceType.Sulfur] = ET.TextTable.Sulfur,
		[ResourceType.Silver] = ET.TextTable.Silver
	}
	ET.GameCallback_OnSettlerKilled = GameCallback_SettlerKilled
	function GameCallback_SettlerKilled(_HurterPlayerID, _HurtPlayerID)
		ET.GameCallback_OnSettlerKilled(_HurterPlayerID, _HurtPlayerID)
		if _HurterPlayerID == 5 or _HurterPlayerID == 6 then
			if Score.Player[_HurterPlayerID].battle >= 5000 then
				local pIDs = ET.PlayersByAI[_HurterPlayerID]
				for i = 1, table.getn(pIDs) do
					if GUI.GetPlayerID() == pIDs[i] then
						for i = 7, 8 do
							if XGUIEng.IsWidgetShown("EasterT23O"..i) == 0 then
								XGUIEng.ShowWidget("EasterT23O"..i, 1)
							end
						end
					end
				end
			end
		end
	end
	StartSimpleHiResJob("ET_HideSecondTooltip")

	ET.PlayerHQLevels = {1,1,1,1}
	ET.GameCallback_OnBuildingUpgradeComplete = GameCallback_OnBuildingUpgradeComplete
	GameCallback_OnBuildingUpgradeComplete = function(_oId, _nId)
		if Logic.GetEntityType(_nId) == Entities.PB_Outpost2 then
			ET.PlayerHQLevels[GetPlayer(_nId)] = 2
		elseif Logic.GetEntityType(_nId) == Entities.PB_Outpost3 then
			ET.PlayerHQLevels[GetPlayer(_nId)] = 3
		end
		ET.GameCallback_OnBuildingUpgradeComplete(_oId, _nId)
	end

	if CNetwork then
		CNetwork.SetNetworkHandler("ET.AddRespawnTroop", function(name, _troopType, _playerId)
			if CNetwork.IsAllowedToManipulatePlayer(name, _playerId) then
				CLogger.Log("ET_AddRespawnTroop", name, _troopType, _playerId)
				ET.AddRespawnTroop(_troopType, _playerId)
			end
		end)

		CNetwork.SetNetworkHandler("ET.SlotButton_Synced", function(name, _index, _playerId)
			if CNetwork.IsAllowedToManipulatePlayer(name, _playerId) then
				CLogger.Log("ET_SlotButton", name, _index, _playerId)
				ET.SlotButton_Synced(_index, _playerId)
			end
		end)

		CNetwork.SetNetworkHandler("ET.OptionButton_Synced", function(name, _index, _playerId)
			if CNetwork.IsAllowedToManipulatePlayer(name, _playerId) then
				CLogger.Log("ET_OptionButton", name, _index, _playerId)
				ET.OptionButton_Synced(_index, _playerId)
			end
		end)
	end
end
function OnOuterOutpostDestroyed()

	local entityID = Event.GetEntityID()
	local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.PB_Outpost1 or entityType == Entities.PB_Outpost2 or entityType == Entities.PB_Outpost3 then
		local playerID = GetPlayer(entityID)
		if Logic.GetNumberOfEntitiesOfTypeOfPlayer(playerID, Entities.PB_Outpost1) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(playerID, Entities.PB_Outpost2) + Logic.GetNumberOfEntitiesOfTypeOfPlayer(playerID, Entities.PB_Outpost3) == 0 then
			local army = ET.GetPlayersAI(playerID)
			local index = ET.GetPlayersAIIndex(playerID)
			ET.PlayerHQLevels[playerID] = 1
			ET.AI[army][index].SpawnPosition = ET.GetRetreatSpawnPosition(army, index)
			if table.getn(ET.AI[army][index].IDs) and table.getn(ET.AI[army][index].IDs) > 0 then
				for i = 1, table.getn(ET.AI[army][index].IDs) do
					local id = ET.AI[army][index].IDs[i]+1
					Redeploy(ArmyTable[army][id], ET.AI[army][index].SpawnPosition)
				end
			end
			if GUI.GetPlayerID() == playerID then
				XGUIEng.ShowWidget("EasterT23", 0)
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "OnOuterOutpostCreated", 1, {}, {playerID})
		end
	end
end
function OnOuterOutpostCreated(_player)

	local entityID = Event.GetEntityID()
	local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.PB_Outpost1 and GetPlayer(entityID) == _player then
		local army = ET.GetPlayersAI(_player)
		local index = ET.GetPlayersAIIndex(_player)
		ET.AI[army][index].SpawnPosition = ET.GetSpawnPosition(army, index)
		if table.getn(ET.AI[army][index].IDs) and table.getn(ET.AI[army][index].IDs) > 0 then
			for i = 1, table.getn(ET.AI[army][index].IDs) do
				local id = ET.AI[army][index].IDs[i]+1
				Redeploy(ArmyTable[army][id], ET.AI[army][index].SpawnPosition)
			end
		end
		return true
	end
end
ET.PlayersAI = {
	[1] = ET.AI1,
	[2] = ET.AI1,
	[3] = ET.AI2,
	[4] = ET.AI2,
}
ET.PlayersByAI = {
	[5] = {1,2},
	[6] = {3,4}
}
ET.PlayersIndex = {
	[1] = 1,
	[2] = 2,
	[3] = 1,
	[4] = 2,
}

function ET.GetPlayersAI(_playerId)
	if _playerId == 17 then
		local id = GUI.GetSelectedEntity()
		if id and id > 0 then
			_playerId = GetPlayer(id)
		else
			_playerId = 1
		end
	end
	return ET.PlayersAI[_playerId]
end
function ET.GetPlayersAIIndex(_playerID)
	if _playerID == 17 then
		local id = GUI.GetSelectedEntity()
		if id and id > 0 then
			_playerID = GetPlayer(id)
		else
			_playerID = 1
		end
	end
	return ET.PlayersIndex[_playerID]
end

-- ********************************************************************************************
-- ********************************************************************************************
-- AI Army

ET.AllyArmyRodeLength = 3000
ET.AllyArmyBaseTroopLimit = 14

function ET.CreateAllyAI()

	ET_AllyArmySpawnControlJob = StartSimpleJob("ET_AllyArmySpawnControl")
end

function ET.GetSpawnPosition(_ai, _index)
	return GetPosition("AISpawn".. _ai .."_".. _index)
end
function ET.GetRetreatSpawnPosition(_ai, _index)
	return GetPosition("AIRetreat".. _ai .."_".. _index)
end

function ET.SpawnAttackArmy(_ai, _index)

	local currTroops = 0
	local maxtroops = ET.AllyArmyBaseTroopLimit + table.getn(ET.AI[_ai][_index].RespawnTroops)
	local armyIDt = ET.AI[_ai][_index].IDs
	if next(armyIDt) then
		for i = 1, table.getn(armyIDt) do
			currTroops = currTroops + table.getn(ArmyTable[_ai][armyIDt[i] + 1].IDs)
		end
		if currTroops >= maxtroops then
			return
		end
	end
	if table.getn(ET.AI[_ai][_index].RespawnTroops) and table.getn(ET.AI[_ai][_index].RespawnTroops) > 0 then
		-- troops only spawn when player owns at least one vc
		if Logic.GetPlayerAttractionLimit(ET.PlayersByAI[_ai][_index]) >= 70 then
			local armyId = GetFirstFreeArmySlot(_ai)
			if not armyId then
				return
			end
			local army = {}
			army.player = _ai
			army.id = armyId
			army.strength = 16
			army.position = ET.AI[_ai][_index].SpawnPosition
			army.rodeLength = ET.AllyArmyRodeLength + ET.AI[_ai][_index].BonusRodeLength
			SetupArmy(army)
			if table_findvalue(armyIDt, armyId) == 0 then
				table.insert(armyIDt, armyId)
			end

			local leader
			local troopType
			for i = 1, table.getn(ET.AI[_ai][_index].RespawnTroops) do
				troopType = ET.AI[_ai][_index].RespawnTroops[i]
				if troopType == ET.TroopTypes.Cavalry or troopType == ET.TroopTypes.CavalryLight or troopType == ET.TroopTypes.Rifle then
					leader = Entities[ET.TroopTypeMapping[troopType]..(ET.AI[_ai][_index].UpgradeLevel-2)]
				elseif troopType == ET.TroopTypes.Cannon1 then
					if ET.AI[_ai][_index].UpgradeLevel == 4 then
						leader = Entities.PV_Cannon3
					else
						leader = Entities.PV_Cannon1
					end
				elseif troopType == ET.TroopTypes.Cannon2 then
					if ET.AI[_ai][_index].UpgradeLevel == 4 then
						leader = Entities.PV_Cannon4
					else
						leader = Entities.PV_Cannon2
					end
				else
					leader = Entities[ET.TroopTypeMapping[troopType]..ET.AI[_ai][_index].UpgradeLevel]
				end
				EnlargeArmy(army, {leaderType = leader})
				currTroops = currTroops + 1
				if currTroops >= maxtroops then
					break
				end
			end
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "ET_AllyArmyAttackControl", 1, {}, {army.player, army.id + 1})
		end
	end
end
function ET_AllyArmyAttackControl(_player, _id)
	local army = ArmyTable[_player][_id]
	if not IsDead(army) then
		Defend(army)
	else
		return true
	end

end
function ET_AllyArmySpawnControl()
	for ai = ET.AI1, ET.AI2 do
		for i = 1, 2 do
			if ET.AI[ai][i].RespawnTime > 0 then
				ET.AI[ai][i].RespawnTime = ET.AI[ai][i].RespawnTime - 1
			else
				ET.SpawnAttackArmy(ai, i)
				ET.AI[ai][i].RespawnTime = ET.AI[ai][i].RespawnTimeMax
				local player = GUI.GetPlayerID()
				if ET.GetPlayersAI(player) == ai and ET.GetPlayersAIIndex(player) == i then
					if ET.RespawnCountdown then
						EMS.T.StopCountdown(ET.RespawnCountdown)
					end
					ET.RespawnCountdown = EMS.T.StartCountdown(ET.AI[ai][i].RespawnTime, nil, true)
				end
			end
		end
	end
end
-- ********************************************************************************************
-- ********************************************************************************************
-- Troop Buttons

function ET.TroopButton(_troopType)
	if EMS.GV.GameStarted then
		ET.Sync("ET.AddRespawnTroop", _troopType, GUI.GetPlayerID())
	end
end

function ET.UpdateTroopTooltip(_troopType)
	XGUIEng.ShowWidget("EasterT23Tooltip", 1)
	local player = GUI.GetPlayerID()
	local costs = ET.GetTroopCosts(_troopType, ET.GetPlayersAI(player), ET.GetPlayersAIIndex(player))
	XGUIEng.SetText("EasterT23Tooltip", ET.GetCostString(costs, GUI.GetPlayerID()))
end

function ET.AddRespawnTroop(_troopType, _playerId)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)
	if ET.CheckAddTroopConditions(_troopType, _playerId, ai, index) then
		ET.PayTroop(_playerId, _troopType)
		table.insert(ET.AI[ai][index].RespawnTroops, _troopType)
		ET.UpdateRespawnTroops(ai, index)
	end
end

ET.SourceButtons = {
	"MultiSelectionSource_Sword",
	"MultiSelectionSource_Spear",
	"MultiSelectionSource_Bow",
	"MultiSelectionSource_Rifle",
	"MultiSelectionSource_LightCav",
	"MultiSelectionSource_HeavyCav",
	"Buy_Cannon3",
	"MultiSelectionSource_Cannon",
};

function ET.UpdateRespawnTroops(_ai, _index)
	local player = GUI.GetPlayerID()
	local myAI = ET.GetPlayersAI(player)
	local index = ET.GetPlayersAIIndex(player)
	if _ai ~= myAI or _index ~= index then
		return
	end
	local sourceButton
	local widgetId
	local numTroops = table.getn(ET.AI[_ai][_index].RespawnTroops)
	for i = 1, numTroops do
		widgetId = XGUIEng.GetWidgetID("EasterT23S"..i)
		sourceButton = ET.SourceButtons[ET.AI[_ai][_index].RespawnTroops[i]]
		XGUIEng.TransferMaterials(sourceButton, widgetId)
	end
	for i = numTroops + 1, 16 do
		widgetId = XGUIEng.GetWidgetID("EasterT23S"..i)
		XGUIEng.TransferMaterials("EasterT23STemplate", widgetId)
	end
end

function ET.CheckAddTroopConditions(_troopType, _playerId, _ai, _index)
	-- enough resources
	local costs = ET.GetTroopCosts(_troopType, _ai, _index)
	if ET.GetPlayersTotalResources(_playerId, costs[1][1]) < costs[1][2] then
		if GUI.GetPlayerID() == _playerId then
			Message(ET.TextTable.NotEnoughResources)
		end
		return false
	end
	if (_troopType == ET.TroopTypes.Cavalry or _troopType == ET.TroopTypes.CavalryLight or _troopType == ET.TroopTypes.Rifle) and ET.AI[_ai][_index].UpgradeLevel < 3 then
		if GUI.GetPlayerID() == _playerId then
			Message(ET.TextTable.NeedsLVL3)
		end
		return false
	end
	if table.getn(ET.AI[_ai][_index].RespawnTroops) >= (ET.AI[_ai][_index].SlotsAvailable + ET.AI[_ai][_index].BonusSlotsAvailable) then
		if GUI.GetPlayerID() == _playerId then
			Message(ET.TextTable.ArmyLimitReached)
		end
		return false
	end
	return true
end

function ET.GetTroopCosts(_troopType, _ai, _index)
	local count = 0
	for i = 1, table.getn(ET.AI[_ai][_index].RespawnTroops) do
		if ET.AI[_ai][_index].RespawnTroops[i] == _troopType then
			count = count + 1
		end
	end
	local price = ET.TroopBaseCosts[_troopType][2]
	-- increase price for each troop and each upgrade level
	price = price + (count*ET.TroopPricePerCount + (ET.AI[_ai][_index].UpgradeLevel-1)*ET.TroopPriceIncreasePerUpgrade[_troopType])
	return {{ET.TroopBaseCosts[_troopType][1], price}}
end

function ET.PayTroop(_playerId, _troopType)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)
	local costs = ET.GetTroopCosts(_troopType, ai, index)
	ET.Pay(_playerId, costs)
end

function ET.GetCostString(_costs, _playerId)
	local str = ET.TextTable.Costs..": @cr "
	local color = ""
	local playerRes
	if table.getn(_costs) == 0 then
		return ""
	end
	for i = 1, table.getn(_costs) do
		playerRes = ET.GetPlayersTotalResources(_playerId, _costs[i][1])
		if playerRes < _costs[i][2] then
			color = "@color:255,0,0"
		else
			color = "@color:255,255,255"
		end
		str = str .. ET.ResourceNames[_costs[i][1]] .. " : ".. color .. " " .. _costs[i][2] .. " @cr @color:255,255,255 "
	end
	return str
end

-- ********************************************************************************************
-- ********************************************************************************************
-- Slot Buttons

function ET.SlotButton(_index)
	if EMS.GV.GameStarted then
		ET.Sync("ET.SlotButton_Synced", _index, GUI.GetPlayerID())
	end
end

function ET.SlotButton_Synced(_index, _playerId)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)
	if _index > table.getn(ET.AI[ai][index].RespawnTroops) then
		return
	end
	table.remove(ET.AI[ai][index].RespawnTroops, _index)
	ET.UpdateRespawnTroops(ai, index)
end

function ET.UpdateSlotTooltip(_index)
	XGUIEng.SetText("EasterT23Tooltip", ET.TextTable.Remove)
end

-- ********************************************************************************************
-- ********************************************************************************************
-- Option Buttons

function ET.OptionButton(_index)
	local pId = GUI.GetPlayerID()
	local costs = ET.GetOptionCosts(_index, pId)
	if ET.HasEnoughResources(pId, costs) and ET.OptionConditionFullfilled(_index, pId) then
		if EMS.GV.GameStarted then
			ET.Sync("ET.OptionButton_Synced", _index, pId)
		end
	end
end

function ET.OptionButton_Synced(_index, _playerId)
	local costs = ET.GetOptionCosts(_index, _playerId)
	if ET.HasEnoughResources(_playerId, costs) and ET.OptionConditionFullfilled(_index, _playerId) then
		ET.OptionButtonCallbacks[_index](_playerId)
		ET.Pay(_playerId, costs)
	end
end

function ET.UpdateOptionTooltip(_index)
	XGUIEng.ShowWidget("EasterT23Tooltip", 1)
	ET.SecondTooltipVisible = true
	local pId = GUI.GetPlayerID()
	XGUIEng.SetText("EasterT23Tooltip", ET.GetCostString(ET.GetOptionCosts(_index, pId), pId))
	local ai = ET.GetPlayersAI(pId)
	local index = ET.GetPlayersAIIndex(pId)
	if _index == 6 then
		if ET.AI[ai][index].UpgradeLevel == 2 then
			if ET.PlayerHQLevels[pId] == 1 then
				XGUIEng.SetText("EasterT23Tooltip2", ET.TextTable.NeedsHQ2)
				return
			end
		elseif ET.AI[ai][index].UpgradeLevel == 3 then
			if ET.PlayerHQLevels[pId] == 2 then
				XGUIEng.SetText("EasterT23Tooltip2", ET.TextTable.NeedsHQ3)
				return
			end
		end
	end
	if _index >= 2 and _index <= 6 then
		local field
		local name = ET.IndexToFieldName[_index].name
		if ET.IndexToFieldName[_index].index then
			field = ET.AI[ai][index][name]
		else
			field = ET.AI[ai][name]
		end
		if _index ~= 4 then
			XGUIEng.SetText("EasterT23Tooltip2", ET.TextTable.OT[_index]..field.." / ".. ET.OptionLimitByIndex[_index])
		else
			XGUIEng.SetText("EasterT23Tooltip2", ET.TextTable.OT[_index]..field..ET.OptionLimitByIndex[_index])
		end
	else
		XGUIEng.SetText("EasterT23Tooltip2", ET.TextTable.OT[_index])
	end
end

function ET_HideSecondTooltip()
	if ET.SecondTooltipVisible then
		if XGUIEng.IsWidgetShown("EasterT23Tooltip2") == 0 then
			XGUIEng.ShowWidget("EasterT23Tooltip", 0)
			ET.SecondTooltipVisible = false;
		end
	end
end

function ET.UpgradeMaxed(_index, _ai, _aiindex)
	local player = GUI.GetPlayerID()
	if _ai == ET.GetPlayersAI(player) and (not _aiindex or _aiindex == ET.GetPlayersAIIndex(player)) then
		XGUIEng.HighLightButton("EasterT23O".._index, 1)
	end
end

ET.OptionButtonCallbacks = {

	-- New Slot
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		local index = ET.GetPlayersAIIndex(_playerId)
		ET.AI[ai][index].BonusSlotsAvailable = ET.AI[ai][index].BonusSlotsAvailable + 1
		ET.UpdateSlots(ai, index)
		if ET.AI[ai][index].SlotsAvailable + ET.AI[ai][index].BonusSlotsAvailable == 16 then
			ET.UpgradeMaxed(1, ai, index)
		end
	end,

	-- better armor
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		ET.AI[ai].TroopDefUpgrades = ET.AI[ai].TroopDefUpgrades + 1
		if ET.AI[ai].TroopDefUpgrades == 1 then
			Logic.SetTechnologyState(ai, Technologies.T_LeatherMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_ChainMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_PlateMailArmor, 3)
			Logic.SetTechnologyState(ai, Technologies.T_SoftArcherArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_PaddedArcherArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_LeatherArcherArmor, 3)
		elseif ET.AI[ai].TroopDefUpgrades == 2 then
			--Logic.SetTechnologyState(ai, Technologies.T_LeatherMailArmor, 3)
			Logic.SetTechnologyState(ai, Technologies.T_ChainMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_PlateMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_SoftArcherArmor, 3)
			Logic.SetTechnologyState(ai, Technologies.T_PaddedArcherArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_LeatherArcherArmor, 3)
		elseif ET.AI[ai].TroopDefUpgrades == 3 then
			--Logic.SetTechnologyState(ai, Technologies.T_LeatherMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_ChainMailArmor, 3)
			Logic.SetTechnologyState(ai, Technologies.T_PlateMailArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_SoftArcherArmor, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_PaddedArcherArmor, 3)
			Logic.SetTechnologyState(ai, Technologies.T_LeatherArcherArmor, 3)
			ET.AI[ai].ArmorResearched = true
			ET.UpgradeMaxed(2, ai, nil)
		end
	end,

	-- better weapons
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		ET.AI[ai].TroopOffUpgrades = ET.AI[ai].TroopOffUpgrades + 1
		if ET.AI[ai].TroopOffUpgrades == 1 then
			Logic.SetTechnologyState(ai, Technologies.T_MasterOfSmithery, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_IronCasting, 3)
			Logic.SetTechnologyState(ai, Technologies.T_Fletching, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_BodkinArrow, 3)
			Logic.SetTechnologyState(ai, Technologies.T_WoodAging, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_Turnery, 3)
			Logic.SetTechnologyState(ai, Technologies.T_EnhancedGunPowder, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_BlisteringCannonballs, 3)
		elseif ET.AI[ai].TroopOffUpgrades == 2 then
			--Logic.SetTechnologyState(ai, Technologies.T_MasterOfSmithery, 3)
			Logic.SetTechnologyState(ai, Technologies.T_IronCasting, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_Fletching, 3)
			Logic.SetTechnologyState(ai, Technologies.T_BodkinArrow, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_WoodAging, 3)
			Logic.SetTechnologyState(ai, Technologies.T_Turnery, 3)
			--Logic.SetTechnologyState(ai, Technologies.T_EnhancedGunPowder, 3)
			Logic.SetTechnologyState(ai, Technologies.T_BlisteringCannonballs, 3)
			ET.AI[ai].WeaponsResearched = true
			ET.UpgradeMaxed(3, ai, nil)
		end
	end,

	-- less recruiting time
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		local index = ET.GetPlayersAIIndex(_playerId)
		if ET.AI[ai][index].RespawnTime > ET.RespawnTimerDecrease then
			ET.AI[ai][index].RespawnTime = ET.AI[ai][index].RespawnTime - ET.RespawnTimerDecrease
		else
			ET.AI[ai][index].RespawnTime = 0
		end
		ET.AI[ai][index].RespawnTimeMax = ET.AI[ai][index].RespawnTimeMax - ET.RespawnTimerDecrease

		-- adjust visible counter
		if ET.GetPlayersAI(GUI.GetPlayerID()) == ai and ET.GetPlayersAIIndex(GUI.GetPlayerID()) == ai then
			if GUIQuestTools.UltimatumTime then
				GUIQuestTools.UltimatumTime = GUIQuestTools.UltimatumTime - ET.RespawnTimerDecrease
			end
		end

		ET.AI[ai][index].UpgradeCount_RespawnTime = (ET.AI[ai][index].UpgradeCount_RespawnTime or 0) + 1
		if ET.AI[ai][index].UpgradeCount_RespawnTime >= 8 then
			ET.UpgradeMaxed(4, ai, index)
		end
	end,

	-- increase range
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		local index = ET.GetPlayersAIIndex(_playerId)
		ET.AI[ai][index].RangeLevel = ET.AI[ai][index].RangeLevel + 1
		ET.AI[ai][index].BonusRodeLength = ET.AI[ai][index].BonusRodeLength + 1500
		if table.getn(ET.AI[ai][index].IDs) and table.getn(ET.AI[ai][index].IDs) > 0 then
			for i = 1, table.getn(ET.AI[ai][index].IDs) do
				if ArmyTable[ai][ET.AI[ai][index].IDs[i]+1] then
					ArmyTable[ai][ET.AI[ai][index].IDs[i]+1].rodeLength = ArmyTable[ai][ET.AI[ai][index].IDs[i]+1].rodeLength + 1500
				end
			end
		end
		if ET.AI[ai][index].RangeLevel == 16 then
			ET.UpgradeMaxed(5, ai, index)
		end
	end,

	-- level upgrade
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		local index = ET.GetPlayersAIIndex(_playerId)
		ET.AI[ai][index].UpgradeLevel = ET.AI[ai][index].UpgradeLevel + 1
		if ET.AI[ai][index].UpgradeLevel == 3 then
			if ET.GetPlayersAI(GUI.GetPlayerID()) == ai and ET.GetPlayersAIIndex(GUI.GetPlayerID()) == ai then
				XGUIEng.DisableButton("EasterT23T4", 0)
			end
		end
		if ET.AI[ai][index].UpgradeLevel == 4 then
			ET.UpgradeMaxed(6, ai, index)
		end
	end,

	--silver defense
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		Logic.SetTechnologyState(ai, Technologies.T_SilverArcherArmor, 3)
		Logic.SetTechnologyState(ai, Technologies.T_SilverPlateArmor, 3)
		ET.AI[ai].SilverArmorResearched = true
		ET.UpgradeMaxed(7, ai, nil)
	end,

	--silver offense
	function(_playerId)
		local ai = ET.GetPlayersAI(_playerId)
		Logic.SetTechnologyState(ai, Technologies.T_SilverArrows, 3)
		Logic.SetTechnologyState(ai, Technologies.T_SilverSwords, 3)
		Logic.SetTechnologyState(ai, Technologies.T_SilverLance, 3)
		Logic.SetTechnologyState(ai, Technologies.T_SilverBullets, 3)
		Logic.SetTechnologyState(ai, Technologies.T_SilverMissiles, 3)
		ET.AI[ai].SilverWeaponsResearched = true
		ET.UpgradeMaxed(8, ai, nil)
	end

}

function ET.UpdateSlots(_ai, _index)
	local aiSlots = ET.AI[_ai][_index].SlotsAvailable + ET.AI[_ai][_index].BonusSlotsAvailable
	local player = GUI.GetPlayerID()
	if ET.GetPlayersAI(player) == _ai and ET.GetPlayersAIIndex(player) == _index then
		for i = 1, aiSlots do
			XGUIEng.ShowWidget("EasterT23S"..i, 1)
		end
		for i = aiSlots+1, 16 do
			XGUIEng.ShowWidget("EasterT23S"..i, 0)
			widgetId = XGUIEng.GetWidgetID("EasterT23S"..i)
			XGUIEng.TransferMaterials("EasterT23STemplate", widgetId)
		end
	end
	if table.getn(ET.AI[_ai][_index].RespawnTroops) > aiSlots then
		for i = 1, table.getn(ET.AI[_ai][_index].RespawnTroops)-aiSlots do
			table.remove(ET.AI[_ai][_index].RespawnTroops, table.getn(ET.AI[_ai][_index].RespawnTroops))
		end
	end
end

ET.OptionBaseCosts = {
	{ResourceType.Gold, 1000},
	{ResourceType.Iron, 1200},
	{ResourceType.Iron, 900},
	{ResourceType.Gold, 3000},
	{ResourceType.Sulfur, 1200},
	{},
	{ResourceType.Silver, 600},
	{ResourceType.Silver, 450}
}

function ET.GetOptionCosts(_index, _playerId)
	if _index == 6 then
		return ET.GetAIUpgradeCosts(_playerId)
	elseif _index == 1 then
		return ET.GetAITroopSlotCosts(_playerId, _index)
	else
		return {ET.OptionBaseCosts[_index]}
	end
end

function ET.OptionConditionFullfilled(_index, _playerId)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)

	if _index == 8 then
		if ET.AI[ai].SilverWeaponsResearched then
			return false
		end
	elseif _index == 7 then
		if ET.AI[ai].SilverArmorResearched then
			return false
		end
	elseif _index == 6 then
		-- upgrade level
		if ET.AI[ai][index].UpgradeLevel == 2 then
			if ET.PlayerHQLevels[_playerId] == 1 then
				return false
			end
		elseif ET.AI[ai][index].UpgradeLevel == 3 then
			if ET.PlayerHQLevels[_playerId] == 2 then
				return false
			end
		elseif ET.AI[ai][index].UpgradeLevel == 4 then
			return false
		end
	elseif _index == 5 then
		if ET.AI[ai][index].RangeLevel then
			if ET.AI[ai][index].RangeLevel >= 16 then
				return false
			end
		end
	elseif _index == 4 then
		if ET.AI[ai][index].UpgradeCount_RespawnTime then
			if ET.AI[ai][index].UpgradeCount_RespawnTime >= 8 then
				return false
			end
		end
	elseif _index == 3 then
		if ET.AI[ai].WeaponsResearched then
			return false
		end
	elseif _index == 2 then
		if ET.AI[ai].ArmorResearched then
			return false
		end
	elseif _index == 1 then
		if ET.AI[ai][index].SlotsAvailable + ET.AI[ai][index].BonusSlotsAvailable >= 16 then
			return false
		end
	end
	return true
end

function ET.GetAIUpgradeCosts(_playerId)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)
	local costs = {}
	local troopType, baseCosts, resType
	-- repay for all currently bought troops
	for i = 1, table.getn(ET.AI[ai][index].RespawnTroops) do
		troopType = ET.AI[ai][index].RespawnTroops[i]
		baseCosts = ET.TroopBaseCosts[troopType]
		resType = baseCosts[1]
		if costs[resType] == nil then
			costs[resType] = {resType, ET.TroopPriceIncreasePerUpgrade[troopType]}
		else
			costs[resType][2] = costs[resType][2] + ET.TroopPriceIncreasePerUpgrade[troopType]
		end
	end
	local costs2 = {{ResourceType.Gold, 2000*ET.AI[ai][index].UpgradeLevel}}
	if costs[ResourceType.Gold] then
		costs2[1][2] = costs2[1][2] + costs[ResourceType.Gold][2]
	end
	for i = 1,20 do
		if costs[i] ~= nil and i ~= ResourceType.Gold then
			table.insert(costs2, costs[i])
		end
	end
	return costs2
end
function ET.GetAITroopSlotCosts(_playerId, _index)
	local ai = ET.GetPlayersAI(_playerId)
	local index = ET.GetPlayersAIIndex(_playerId)
	local baseCosts = ET.OptionBaseCosts[_index]
	local slots = ET.AI[ai][index].BonusSlotsAvailable
	local increase = ET.BonusCostPerSlot
	local costs = {{baseCosts[1], baseCosts[2] + (increase * (slots^2))}}
	return costs
end
-- ********************************************************************************************
-- ********************************************************************************************
-- TextTable
ET.IndexToFieldName = {	[2] = {index = false, name = "TroopDefUpgrades"},
						[3] = {index = false, name = "TroopOffUpgrades"},
						[4] = {index = true, name = "RespawnTimeMax"},
						[5] = {index = true, name = "RangeLevel"},
						[6] = {index = true, name = "UpgradeLevel"}}
ET.OptionLimitByIndex = {	[2] = 3,
							[3] = 2,
							[4] = "Sekunden",
							[5] = 16,
							[6] = 4}
ET.Language = string.lower(XNetworkUbiCom.Tool_GetCurrentLanguageShortName())
if ET.Language == "de" then
	ET.TextTable = {
		Costs = "Kosten",
		Gold = "Taler",
		Clay = "Lehm",
		Wood = "Holz",
		Stone = "Stein",
		Iron = "Eisen",
		Sulfur = "Schwefel",
		Silver = "Silber",

		OT = {
			"Kauft einen zusätzlichen Truppenslot!",
			"Verbessert die Rüstung aller Truppen (Rüstung +2)! @cr Upgrades erforscht: ",
			"Verbessert die Angriffskraft aller Truppen (Angriffschaden +2)! @cr Upgrades erforscht: ",
			"Reduziert die Zeit für die Rekrutierung um "..ET.RespawnTimerDecrease.." Sekunden! Aktuelle Intervalldauer: ",
			"Erhöht die Reichweite Eurer verbündeten KI! @cr Aktuelle Reichweitenstufe: ",
			"Verbessert die Einheiten auf die nächste Stufe! @cr Aktuelle Stufe: ",
			"Erforscht für alle Truppen alle Silber-Rüstungstechnologien!",
			"Erforscht für alle Truppen alle Silber-Waffentechnologien!"
		},

		Remove = "Entfernt diese Einheit von der Rekrutierung!",
		NotEnoughResources = "Nicht genügend Rohstoffe vorhanden!",
		ArmyLimitReached = "Maximale Armeegröße erreicht!",

		NeedsHQ2 = "Benötigt Außenposten(Festung)!",
		NeedsHQ3 = "Benötigt Außenposten(Zitadelle)!",
		NeedsLVL3 = "Benötigt Techstufe 3!",
	}
else
	ET.TextTable = {
		Costs = "Costs",
		Gold = "Gold",
		Clay = "Clay",
		Wood = "Wood",
		Stone = "Stone",
		Iron = "Iron",
		Sulfur = "Sulfur",

		OT = {
			"Buy an additional army troop slot!",
			"Improves armor (armor +2)!",
			"Improves attack damage(damage +2)!",
			"Reduces recruiting time by "..ET.RespawnTimerDecrease.." seconds!",
			"Increases the range of your allied AI!",
			"Upgrade unit level!",
			"Research all silver armor technologies for all troops!",
			"Research all silver weapon technologies for all troops!"
		},

		Remove = "Removes this unit from beeing recruited!",
		NotEnoughResources = "Not enough resources!",
		ArmyLimitReached = "Maximum army size reached!",

		NeedsHQ2 = "Needs Outpost Level 2!",
		NeedsHQ3 = "Needs Outpost Level 3!",
		NeedsLVL3 = "Needs TechLVL 3!",
	}
end
function ET.Sync(...)
	if CNetwork then
		CNetwork.SendCommand(unpack(arg))
	else
		ET[string.sub(arg[1],4)](arg[2], arg[3])
	end
end

function ET.GetPlayersTotalResources(_playerId, _resourceType)
	return Logic.GetPlayersGlobalResource( _playerId, _resourceType ) + Logic.GetPlayersGlobalResource( _playerId, _resourceType+1)
end

function ET.Pay(_playerId, _costs)
	for i = 1, table.getn(_costs) do
		Logic.SubFromPlayersGlobalResource(_playerId , _costs[i][1], _costs[i][2])
	end
end

function ET.HasEnoughResources(_playerId, _costs)
	for i = 1, table.getn(_costs) do
		if ET.GetPlayersTotalResources(_playerId, _costs[i][1]) < _costs[i][2] then
			return false
		end
	end
	return true
end
 