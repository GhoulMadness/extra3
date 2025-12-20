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
EMS_CustomMapConfig =
{

	Version = 1.4,

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

	MapTools_SetMapResourceDefault();

	WT21.Setup();
	MapTools.CreateWoodPiles(50000, Entities.XD_SingnalFireOff);

	TagNachtZyklus(24,0,0,0,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	LocalMusic.UseSet = MEDITERANEANMUSIC
	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end


	end,

	Callback_OnGameStart = function()
		for i = 1,4 do
			ForbidTechnology(Technologies.B_MasterBuilderWorkshop, i);
		end
	end,

	Callback_OnPeacetimeEnded = function()
		for i = 1,4 do
			AllowTechnology(Technologies.B_MasterBuilderWorkshop, i);
			SetHostile(i,5);
		end
		MapTools.OpenWallGates();
		WT21.PeacetimeOver = true;
		--Trigger für Heldentod nahe der Eroberungspositionen
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnHeroNearConquerPosDied", 1)
	end,

	Peacetime = 40,

	GameMode = 1,
	GameModes = {"Standard"},
	Callback_GameModeSelected = function(_gamemode)
	end,
	ResourceLevel = 1,
	Ressources =
	{
		Normal = {
			[1] = {
				500,
				2750,
				2400,
				900,
				50,
				50,
			},
		},
	},
	Callback_OnFastGame = function()
	end,

	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,
	Markets = 0,
	TowerLevel = 3,

	NumberOfHeroesForAll = 2,

};
function MapTools_SetMapResourceDefault()
	local resourceTable = {
		{Entities.XD_StonePit1, 100000},
		{Entities.XD_StonePit1_Med, 100000},
		{Entities.XD_IronPit1, 100000},
		{Entities.XD_ClayPit1, 100000},
		{Entities.XD_SulfurPit1, 100000},
		{Entities.XD_Stone1, 4000},
		{Entities.XD_Stone_BlockPath, 4000},
		{Entities.XD_Stone_BlockPath_Med, 4000},
		{Entities.XD_Iron1, 4000},
		{Entities.XD_Clay1, 4000},
		{Entities.XD_Sulfur1, 4000}
	}
	MapTools.SetMapResource(resourceTable);
end

WT21 = {};
WT21.PeacetimeOver = false;
function WT21.Setup()
	WT21.BuildingNeutralPlayer = 5;
	WT21.VCGiver1 = 0;
	WT21.VCGiver2 = 0;
	WT21.ResourceHutCounter = {[0]=0,[1]=0,[2]=0}; -- per team
	WT21.SupplyCounter = 120;
	local buildingInfoHut1 =
	{
		SpawnInfo =
		{
			Type = Entities.CB_InventorsHut1,
			X = 36800,
			Y = 3600,
			Rotation = 180,
			Owner = WT21.BuildingNeutralPlayer,
		},
		NeutralPlayer = WT21.BuildingNeutralPlayer,
		ConquerConditionCallback = WT21.DefaultConquerCondition,
		RespawnCallback = WT21.ResourceHut_RespawnCallback,
		HealthThresholdPercentage = 0.1, -- health at which building can be conquered
		RespawnHurtPercentage = 0, -- hp to hurt entity with after spawn
	};
	MapTools.AddConquerBuilding(buildingInfoHut1);

	local buildingInfoHut2 =
	{
		SpawnInfo =
		{
			Type = Entities.CB_InventorsHut1,
			X = 37000,
			Y = 69700,
			Rotation = 0,
			Owner = WT21.BuildingNeutralPlayer,
		},
		NeutralPlayer = WT21.BuildingNeutralPlayer,
		ConquerConditionCallback = WT21.DefaultConquerCondition,
		RespawnCallback = WT21.ResourceHut_RespawnCallback,
		HealthThresholdPercentage = 0.1, -- health at which building can be conquered
		RespawnHurtPercentage = 0, -- hp to hurt entity with after spawn
	};
	MapTools.AddConquerBuilding(buildingInfoHut2);

	StartSimpleJob("WT21_ResourceSupplyJob");
	WT21.SellBuilding = GUI.SellBuilding;
	GUI.SellBuilding = function(_bId)
		local bType = Logic.GetEntityType(_bId);
		if bType == Entities.XD_WallStraight
		or bType == Entities.XD_WallStraightGate
		or bType == Entities.XD_WallStraightGate_Closed then
			Sync.Call('WT21.DestroyWall', _bId);
		end
		WT21.SellBuilding(_bId);
	end

	if CNetwork then
		CNetwork.SetNetworkHandler("WT21.DestroyWall", function(_name, _bId)
			if CNetwork.IsAllowedToManipulatePlayer(_name, GetPlayer(_bId)) then
				WT21.DestroyWall(_bId);
			end
		end);
	end
end

function WT21.DestroyWall(_bId)
	if not WT21.PeacetimeOver then
		return;
	end
	local pos = GetPosition(_bId);
	Logic.CreateEffect(GGL_Effects.FXCrushBuilding, pos.X, pos.Y);
	DestroyEntity(_bId);
end
function WT21.GetTeam(_Id)
	if _Id == nil then return 0; end
	if _Id > 0 and _Id <= 2 then
		return 1;
	elseif
		_Id <=4 then
		return 2;
	else
		return 0;
	end
end

function WT21.ResourceHut_RespawnCallback(_prevOwner, _newOwner)
	WT21.ResourceHutCounter[WT21.GetTeam(_newOwner)] = WT21.ResourceHutCounter[WT21.GetTeam(_newOwner)] + 1;
	WT21.ResourceHutCounter[WT21.GetTeam(_prevOwner)] = WT21.ResourceHutCounter[WT21.GetTeam(_prevOwner)] - 1;
	local yourTeam = WT21.GetTeam(GUI.GetPlayerID());
	local prevTeam = WT21.GetTeam(_prevOwner);
	local newTeam = WT21.GetTeam(_newOwner);
	if _newOwner == WT21.BuildingNeutralPlayer then
		return; -- this is currently spammed
	else
		if newTeam > 0 then
			local p1,p2 = 1,2;
			if newTeam == 2 then
				p1,p2 = 3,4;
			end
			local p1Str = (EMS.PlayerList[p1] or {ColorName="Name1"}).ColorName;
			local p2Str = (EMS.PlayerList[p2] or {ColorName="Name2"}).ColorName;
			Message( p1Str .. " @color:255,255,255 und " .. p2Str .. " @color:255,255,255 haben eine Rohstoffhütte erobert!");
		end
	end
end

function WT21.DefaultConquerCondition(_buildingInfo) -- returns the playerId that has the building conquered or false if neutral
	local numEntities = 3;
	local range = 3000;
	local entities;
	local entitiesInArea = {};
	for playerId = 1,4 do
		entities = {Logic.GetPlayerEntitiesInArea(playerId, 0, _buildingInfo.SpawnInfo.X, _buildingInfo.SpawnInfo.Y, range, numEntities)}
		if entities[1] > 0 then
			for i = 2, entities[1] + 1 do
				if IsAlive(entities[i]) then
					entitiesInArea[playerId] = true;
				end
			end
		end
	end
	local t1 = entitiesInArea[1] or entitiesInArea[2];
	local t2 = entitiesInArea[3] or entitiesInArea[4];
	if t1 and t2 then
		return false;
	elseif t1 then
		if entitiesInArea[1] then return 1 else return 2 end;
	elseif t2 then
		if entitiesInArea[3] then return 3 else return 4 end;
	end
	return false;
end

function WT21_ResourceSupplyJob()
	if WT21.SupplyCounter > 0 then
		WT21.SupplyCounter = WT21.SupplyCounter - 1;
		return;
	end

	WT21.SupplyCounter = 120;
	if GUI.GetPlayerID() > 16 then
		if WT21.ResourceHutCounter[1] + WT21.ResourceHutCounter[2] > 0 then
			Message("@color:255,165,80 Die Rohstoffe der Rohstüffhütten werden verteilt!");
		end
	end
	for i = 1,4 do
		local team = WT21.GetTeam(i);
		WT21.SupplyResources(i, WT21.ResourceHutCounter[team]);
	end
end

function WT21.SupplyResources(_pId, _factor)
	if _pId == -1 then
		return;
	end
	if _factor > 0 then
		if GUI.GetPlayerID() == _pId then
			Message("@color:255,165,80 Du hast ".._factor.."x Rohstoffe durch die Rohstoffhütte erhalten!")
		end
	end
	local res =
	{
		400*_factor, -- gold
		200*_factor, -- lehm
		200*_factor, -- wood
		200*_factor, -- stone
		400*_factor, -- iron
		400*_factor, -- sulfur
	};
	Tools.GiveResouces(_pId, unpack(res));
	Logic.AddToPlayersGlobalResource(_pId, ResourceType.Silver, 50*_factor)
end
Hero_RIP_Timer = {}
Hero_RIP_Counter = {0,0,0,0}
function OnHeroNearConquerPosDied()
	local attacker = Event.GetEntityID1()
    local target = Event.GetEntityID2();
	local targetpos = GetPosition(target)
	local health = Logic.GetEntityHealth(target)
	local damage = CEntity.TriggerGetDamage()
    local playerID = Logic.EntityGetPlayer(target)
	if Logic.IsHero(target) == 1 and damage >= health then
		if GetDistance(targetpos,{X = 37000, Y = 69700}) <= 3000 or GetDistance(targetpos,{X = 36800, Y = 3600}) <= 3000 then
			Hero_RIP_Timer[target] = 60
			Hero_RIP_Counter[playerID] = Hero_RIP_Counter[playerID] + 1
			_G["Hero_RIP_Check_Player"..playerID.."_"..Hero_RIP_Counter[playerID].."_TriggerID"] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","Hero_RIP_Check_Player"..playerID.."_"..Hero_RIP_Counter[playerID],1,{},{target,targetpos.X,targetpos.Y,playerID})
		end
	end
end
for i = 1,4 do
	for j = 1,2 do
		_G["Hero_RIP_Check_Player"..i.."_"..j] = function(_EntityID,_posX,_posY,_playerID)
			if Logic.IsEntityAlive(_EntityID) then

				Hero_RIP_Timer[_EntityID] = nil
				Hero_RIP_Counter[_playerID] = Hero_RIP_Counter[_playerID] - 1
				return true
			else
				Hero_RIP_Timer[_EntityID] = Hero_RIP_Timer[_EntityID] - 1
				if Hero_RIP_Timer[_EntityID] <= 0 then
					ReplaceEntity(_EntityID,Entities.XD_GraveComplete6)
					Logic.CreateEffect(GGL_Effects.FXDieHero,_posX,_posY,_playerID)
					Logic.CreateEffect(GGL_Effects.FXMaryDemoralize,_posX,_posY)
					Hero_RIP_Timer[_EntityID] = nil
					return true
				end
			end
		end
	end
end
