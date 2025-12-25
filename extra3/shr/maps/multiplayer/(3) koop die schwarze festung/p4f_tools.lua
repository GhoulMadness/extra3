--[[
	Author: Play4FuN
	Date: 10.08.2022
	
	Description: A collection of various tools which are used in many maps ...
	Note: some of these functions were written by other authors - this is nothing more than a collection
	
	Contents:
	InitColors
	GetHealth
	-Umlaute-	-- removed! put this function in the main mapscript, otherwise it will not work (ANSI vs. UTF-8 encoding I guess)
	HasPlayerEnoughResources
	GetNumberOfPlayerEntitiesInArea
	AreEnemiesInArea
	AreAlliesInArea
	AreHeroesInArea
	AddTribute
	StartCountdown
	GetCostString
	Round
	RoundTo
	RoundEx
	AreAllDead
	GetPos
	GetDistance
	GetDistancePrecise
	GetDistanceSquared
	IsValidPosition
	GetRandomPositionNearby
	IsValueInTable
	GetRandomFromTable
	ShuffleTable
	GetClosestFromTable
	IsEntityInUpgradeCategory
	GetPlayerHQLevel
	GetPlayerHQLevelEx
	IsBuildingUpgrading
	IsBuildingUpgradable
	TableOnlyZeros
	Camera_JumpTo
	MakeInvulnerable
	MakeVulnerable
	IsEntityOnScreen
	IsEntityOnScreenS5Hook
	GetPlayerRecruitBuildings
	GetPlayerLeaders
	GetPlayerCannons
	CreateWoodPile
	SpawnSoldiersForLeader
	
--]]

-- globals
col = {}
gvMission = gvMission or {}

----------------------------------------------------------------------------------------------------

function InitColors()
--	col = {}
	-- Rot,Grün,Blau
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

function GetHealth( _entity )
    local entityID = GetEntityId( _entity )
    if not Tools.IsEntityAlive( entityID ) then
        return 0
    end
    local MaxHealth = Logic.GetEntityMaxHealth( entityID )
    local Health = Logic.GetEntityHealth( entityID )
    return ( Health / MaxHealth ) * 100
end

----------------------------------------------------------------------------------------------------

--[[
function Umlaute(_text)
	local texttype = type(_text)
	if texttype == "string" then
		_text = string.gsub( _text, "ä", "\195\164" )
		_text = string.gsub( _text, "ö", "\195\182" )
		_text = string.gsub( _text, "ü", "\195\188" )
		_text = string.gsub( _text, "ß", "\195\159" )
		_text = string.gsub( _text, "Ä", "\195\132" )
		_text = string.gsub( _text, "Ö", "\195\150" )
		_text = string.gsub( _text, "Ü", "\195\156" )
		return _text
	elseif texttype == "table" then
		for k, v in _text do
			_text[k] = Umlaute( v )
		end
		return _text
	else return _text
	end
end
--]]

----------------------------------------------------------------------------------------------------

-- bug fix: from Tools.HasPlayerEnoughResources but uses wood instead of silver!
function HasPlayerEnoughResources(_PlayerID, _Costs)

	-- get resources
	local Wood = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Wood )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.WoodRaw)
	local Clay = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Clay )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.ClayRaw)
	local Gold   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Gold )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.GoldRaw)
	local Iron   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Iron )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.IronRaw)
	local Stone  = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Stone )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.StoneRaw)
	local Sulfur = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Sulfur )
		+ Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.SulfurRaw)
	
	-- has enough?
	return (not _Costs[ResourceType.Wood] or Wood >= _Costs[ResourceType.Wood])
	and (not _Costs[ResourceType.Gold] or Gold >= _Costs[ResourceType.Gold])
	and (not _Costs[ResourceType.Iron] or Iron >= _Costs[ResourceType.Iron])
	and (not _Costs[ResourceType.Stone] or Stone >= _Costs[ResourceType.Stone])
	and (not _Costs[ResourceType.Sulfur] or Sulfur >= _Costs[ResourceType.Sulfur])
	and (not _Costs[ResourceType.Clay] or Clay >= _Costs[ResourceType.Clay])
	
end

----------------------------------------------------------------------------------------------------

-- any entity type
-- important: ignores walls and dead heros and stealthed units!
-- added for use in AreEnemiesInArea which would not work properly for query amount > 1
function GetNumberOfPlayerEntitiesInArea( player, pos, range )
	if not IsValidPosition( pos ) then
		return 0
	end
	local Data = { Logic.GetPlayerEntitiesInArea( player, 0, pos.X, pos.Y, range, 64 ) }
	local Counter = 0
	for i = 2, Data[1]+1 do
		local id = Data[i]
		if ( Logic.IsBuilding( id ) == 0 and IsAlive( id ) and Logic.GetCamouflageTimeLeft( id ) == 0 )
		or ( Logic.IsConstructionComplete( id ) == 1 and Logic.IsEntityInCategory( id, EntityCategories.Wall ) == 0 ) then
			Counter = Counter + 1
		end
	end
	return Counter
end

----------------------------------------------------------------------------------------------------

function AreEnemiesInArea( _player, _position, _range, _amount )
	local amount = _amount or 1
	local counter = 0
	for i = 1,8 do
		if Logic.GetDiplomacyState( _player, i) == Diplomacy.Hostile then
			--if AreEntitiesInArea( i, 0, _position, _range, amount ) then
			counter = counter + GetNumberOfPlayerEntitiesInArea( i, _position, _range )
			if counter >= amount then
				return true
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------

function AreAlliesInArea( playerId, position, range, amount, countOwnPlayer )
	local amount = amount or 1
	local counter = 0
	for i = 1,8 do
		if countOwnPlayer and i == playerId
		or i ~= playerId and Logic.GetDiplomacyState( playerId, i) == Diplomacy.Friendly then
			counter = counter + GetNumberOfPlayerEntitiesInArea( i, position, range )
			if counter >= amount then
				return true
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------

function AreHeroesInArea( _player, _position, _range, _amount )
	local amount = _amount or 1
	local range = _range or 2000
	local pos = GetPos( _position )
	-- access category 2 = settlers
	local entities = { Logic.GetPlayerEntitiesInArea( _player, 0, pos.X, pos.Y, range, 64, 2 ) }
	
	local counter = 0
	for i = 2, entities[1]+1 do
		if Logic.IsHero( entities[i] ) == 1 then
			counter = counter + 1
			if counter >= amount then
				return true
			end
		end
	end
	
	return false
end

----------------------------------------------------------------------------------------------------

function AddTribute( _tribute )
	assert( type( _tribute ) == "table", "Tribut muß ein Table sein" )
	assert( type( _tribute.text ) == "string", "Tribut.text muß ein String sein" )
	assert( type( _tribute.cost ) == "table", "Tribut.cost muß ein Table sein" )
	assert( type( _tribute.playerId ) == "number", "Tribut.playerId muß eine Nummer sein" )
	assert( not _tribute.Tribute , "Tribut.Tribute darf nicht vorbelegt sein")
	
	uniqueTributeCounter = uniqueTributeCounter or 1
	_tribute.Tribute = uniqueTributeCounter
	uniqueTributeCounter = uniqueTributeCounter + 1
	
	local tResCost = {}
	for k, v in pairs( _tribute.cost ) do
			assert( ResourceType[k] )
			assert( type( v ) == "number" )
			table.insert( tResCost, ResourceType[k] )
			table.insert( tResCost, v )
	end
	
	Logic.AddTribute( _tribute.playerId, _tribute.Tribute, 0, 0, _tribute.text, unpack( tResCost ) )
	SetupTributePaid( _tribute )

	return _tribute.Tribute
end

----------------------------------------------------------------------------------------------------

-- updated: if a countdown is already visible, a new one can be started without displaying it
-- added: optional parameter (any)
-- bug fix: show countdown again after loading a savegame
function StartCountdown(_Limit, _Callback, _Show, _Parameter)
	
	assert(type(_Limit) == "number")
	
	Counter.Index = (Counter.Index or 0) + 1
	
	if _Show and CountdownIsVisisble() then
			--assert(false, "StartCountdown: A countdown is already visible")
			Message("StartCountdown Error: A countdown is already visible")
	_Show = false
	end
	
	Counter["counter" .. Counter.Index] = {
		Limit = _Limit,
		TickCount = 0,
		Callback = _Callback,
		Show = _Show,
		Finished = false,
		parameter = _Parameter,	-- can be nil
	}
	
	if _Show then
			MapLocal_StartCountDown(_Limit)
	end
	
	if Counter.JobId == nil then
			Counter.JobId = StartSimpleJob("CountdownTick")
	end
	
	if not gvRestoreCountdownFix then
		AddOnSaveGameLoaded( RestoreVisibleCountdown )
		gvRestoreCountdownFix = true
	end
	
	return Counter.Index
end

function StopCountdown(_Id)
	
	if Counter.Index == nil then
			return
	end
	
	if _Id == nil then
			for i = 1, Counter.Index do
					if Counter.IsValid("counter" .. i) then
							if Counter["counter" .. i].Show then
									MapLocal_StopCountDown()
							end
							Counter["counter" .. i] = nil
					end
			end
	else
			if Counter.IsValid("counter" .. _Id) then
					if Counter["counter" .. _Id].Show then
							MapLocal_StopCountDown()
					end
					Counter["counter" .. _Id] = nil
			end
	end
end

function CountdownTick()
	
	local empty = true
	for i = 1, Counter.Index do
			if Counter.IsValid("counter" .. i) then
					if Counter.Tick("counter" .. i) then
							Counter["counter" .. i].Finished = true
					end
					
					if Counter["counter" .. i].Finished and not IsBriefingActive() then
							if Counter["counter" .. i].Show then
									MapLocal_StopCountDown()
							end
							
							if type(Counter["counter" .. i].Callback) == "function" then
									Counter["counter" .. i].Callback( Counter["counter" .. i].parameter )
							end
							
							Counter["counter" .. i] = nil
					end
					
					empty = false
			end
	end
	
	if empty then
			Counter.JobId = nil
			Counter.Index = nil
			return true
	end
end

function CountdownIsVisisble()
	
	if not Counter.Index then
		return false
	end
	
	for i = 1, Counter.Index do
		if Counter.IsValid("counter" .. i) and Counter["counter" .. i].Show and not Counter["counter" .. i].Finished then
			-- LuaDebugger.Break()
			return true
		end
	end
	
	return false
end

function CountdownGetVisisbleCounter()
	
	if not Counter.Index then
		return false
	end
	
	for i = 1, Counter.Index do
			if Counter.IsValid("counter" .. i) and Counter["counter" .. i].Show then
					return Counter["counter" .. i]
			end
	end
	
	return false
end

-- visible countdown disappears after loading a savegame
--> check if a counter should be visible and show it
function RestoreVisibleCountdown()
	local visibleCounter = CountdownGetVisisbleCounter()
	if not visibleCounter then
		return
	end
	
	local ultimatumTime = visibleCounter.Limit - visibleCounter.TickCount
	GUIQuestTools.ToggleStopWatch( ultimatumTime, 1 )
end

----------------------------------------------------------------------------------------------------

function GetCostString(_player, _Costs)
	if not _Costs then
		_Costs = _player
		_player = GUI.GetPlayerID()
	end
	local PlayerGold = GetGold(_player)
	local PlayerWood = GetWood(_player)
	local PlayerClay = GetClay(_player)
	local PlayerIron = GetIron(_player)
	local PlayerStone = GetStone(_player)
	local PlayerSulfur = GetSulfur(_player)
	local CostString = ""
	
	-- workaround: costs can either be in the form of "gold = 100" or "[ResourceType.Gold] = 100" or "Gold = 100"
	_Costs.gold = _Costs.gold or _Costs[ResourceType.Gold] or _Costs.Gold
	_Costs.wood = _Costs.wood or _Costs[ResourceType.Wood] or _Costs.Wood
	_Costs.clay = _Costs.clay or _Costs[ResourceType.Clay] or _Costs.Clay
	_Costs.stone = _Costs.stone or _Costs[ResourceType.Stone] or _Costs.Stone
	_Costs.iron = _Costs.iron or _Costs[ResourceType.Iron] or _Costs.Iron
	_Costs.sulfur = _Costs.sulfur or _Costs[ResourceType.Sulfur] or _Costs.Sulfur
	
	if _Costs.gold and _Costs.gold > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameMoney") .. ": " 
		if PlayerGold >= _Costs.gold then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.gold .. " @color:255,255,255,255 @cr "
	end
	
	if _Costs.wood and _Costs.wood > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameWood") .. ": " 
		if PlayerWood >= _Costs.wood then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.wood .. " @color:255,255,255,255 @cr "
	end
	
	if _Costs.clay and _Costs.clay > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameClay") .. ": " 
		if PlayerClay >= _Costs.clay then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.clay .. " @color:255,255,255,255 @cr "
	end
			
	if _Costs.stone and _Costs.stone > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameStone") .. ": " 
		if PlayerStone >= _Costs.stone then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.stone .. " @color:255,255,255,255 @cr "
	end
	
	if _Costs.iron and _Costs.iron > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameIron") .. ": " 
		if PlayerIron >= _Costs.iron then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.iron .. " @color:255,255,255,255 @cr "
	end
		
	if _Costs.sulfur and _Costs.sulfur > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameSulfur") .. ": " 
		if PlayerSulfur >= _Costs.sulfur then
			CostString = CostString .. " @color:255,255,255,255 "
		else
			CostString = CostString .. " @color:220,64,16,255 "
		end
		CostString = CostString .. _Costs.sulfur .. " @color:255,255,255,255 @cr "
	end

	return CostString
	-- see: Data\Script\Interface\interfacetools.lua
end

----------------------------------------------------------------------------------------------------

function Round(_number)
	return math.floor(_number + 0.5)
end

----------------------------------------------------------------------------------------------------

function RoundTo( number, multiple )
  return math.floor ( ( number / multiple ) + 0.5 ) * multiple
end

----------------------------------------------------------------------------------------------------

-- TODO: does not work...
-- round a given number with digits decimal places
function RoundEx(number, digits)
	if not digits then
		return Round(number)
	end
	
	assert(digits > 0, "RoundEx: invalid digits count")
	
	local shift = math.pow(10, digits)
	local val = number * shift
	return Round(val) / shift
end

----------------------------------------------------------------------------------------------------

function AreAllDead(_table)

	if table.getn(_table) == 0 then
		return true
	end
	
	for n = 1, table.getn(_table) do
		if not IsDead(_table[n]) then
			return false
		end
	end
	
	return true
end

----------------------------------------------------------------------------------------------------

function GetPos(_position)
	if (type(_position) == "table") then
		if (IsValidPosition(_position)) then
			return _position
		end
	else
		return GetPosition(_position)
	end
end

----------------------------------------------------------------------------------------------------
-- use the round value because this should be precise enough and is probably more performant(?)
function GetDistance(_a, _b)
    if type(_a) ~= "table" then
        _a = GetPos(_a)
    end
    if type(_b) ~= "table" then
        _b = GetPos(_b)
    end
	local a = { X = Round(_a.X), Y = Round(_a.Y) }
	local b = { X = Round(_b.X), Y = Round(_b.Y) }
    return math.sqrt((a.X - b.X)*(a.X - b.X) + (a.Y - b.Y)*(a.Y - b.Y))
end

----------------------------------------------------------------------------------------------------
-- the original GetDistance with exact values
function GetDistancePrecise(_a, _b)
    if type(_a) ~= "table" then
        _a = GetPos(_a)
    end
    if type(_b) ~= "table" then
        _b = GetPos(_b)
    end
    return math.sqrt((_a.X - _b.X)*(_a.X - _b.X) + (_a.Y - _b.Y)*(_a.Y - _b.Y))
end

----------------------------------------------------------------------------------------------------

function GetDistanceSquared(_a, _b)
    if type(_a) ~= "table" then
        _a = GetPos(_a)
    end
    if type(_b) ~= "table" then
        _b = GetPos(_b)
    end
    return (_a.X - _b.X)*(_a.X - _b.X) + (_a.Y - _b.Y)*(_a.Y - _b.Y)
end

----------------------------------------------------------------------------------------------------

function IsValidPosition( _position )
	if ( type(_position) == "table" ) then
		if ( type(_position.X) == "number" ) and ( type(_position.Y) == "number" ) then
			local x,y = Logic.WorldGetSize()
			if ( (_position.X <= x+100) and (_position.X >= 0) ) and ( (_position.Y <= y+100) and (_position.Y >= 0) ) then
				return GetDistanceSquared( _position, { X = x*0.5, Y = y*0.5 } ) <= x*y
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------

-- note: might run into an infinite loop?
function GetRandomPositionNearby(position, _range)	-- _pos may be string or pos or ID
	if type(position) ~= "table" then
		position = GetPos(position)
	end
	if not IsValidPosition(position) then
		return {X=0, Y=0}	-- TODO?
	end
--	assert(IsValidPosition(position))
	local range = _range or 1000
	local newPos = {X = position.X + math.random(-range, range), Y = position.Y + math.random(-range, range)}
	-- note: not the smartest way to ensure the new position is actually in the desired range, but it should work
	if (IsValidPosition(newPos)) and GetDistanceSquared(position, newPos) < range * range then
		return newPos
	else
		--LuaDebugger.Log("GetRandomPositionNearby: invalid position OR to far away - try again")
		return GetRandomPositionNearby(position, range)
	end
end

----------------------------------------------------------------------------------------------------

function IsValueInTable(_wert, _table)
	if _table == nil then return false end
	for k, v in pairs(_table) do
		if v == _wert then 
			return true
		end 
	end
	return false
end

----------------------------------------------------------------------------------------------------

function GetRandomFromTable(t)
	assert(type(t) == "table")
	local limit = table.getn(t)
	if limit < 1 then return false end
	return t[math.random(1, limit)]
end

----------------------------------------------------------------------------------------------------

-- https://gist.github.com/Uradamus/10323382?permalink_comment_id=2754684#gistcomment-2754684
function ShuffleTable(tbl)
	for i = table.getn(tbl), 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

----------------------------------------------------------------------------------------------------

-- optional: _maxDistance
function GetClosestFromTable(_pos, _t, _maxDistance)
	local worldSize = Logic.WorldGetSize()
	local maxDistance = _maxDistance or worldSize+100
	local bestID, bestDistance2 = 0, maxDistance*maxDistance
	for i = 1, table.getn(_t) do
		local entity = _t[i]
		local entityPosition = GetPos(entity)
		local dist2 = GetDistanceSquared(_pos, entityPosition)
		if dist2 < bestDistance2 then
			bestDistance2 = dist2
			bestID = entity
		end
	end
	
	return bestID
end

----------------------------------------------------------------------------------------------------

-- returns true if a passed in entity is in a given upgrade category
function IsEntityInUpgradeCategory( _entityID, _upCat )
	if not _upCat then
		return false
	end
	if not Tools.IsEntityAlive( _entityID ) then
		return false
	end
	
	local _entityType = Logic.GetEntityType( _entityID )
	local entityTypesInUpCat = {}
	
	if Logic.IsBuilding( _entityID ) == 1 then
		entityTypesInUpCat = { Logic.GetBuildingTypesInUpgradeCategory( _upCat ) }
	else
		entityTypesInUpCat = { Logic.GetSettlerTypesInUpgradeCategory( _upCat ) }
	end
	
	
	-- first table entry = number of (following results)
	if table.remove( entityTypesInUpCat, 1 ) then
		return IsValueInTable( _entityType, entityTypesInUpCat )
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------

-- returns the highest level of the players HQ(s) assuming no HQ is being constructed
function GetPlayerHQLevel(_player)
	local player = _player or 1
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Headquarters3) > 0 then
		return 3
	elseif Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Headquarters2) > 0 then
		return 2
	elseif Logic.GetNumberOfEntitiesOfTypeOfPlayer(player, Entities.PB_Headquarters1) > 0 then
		return 1
	else
		return 0
	end
end

-- returns the highest level of the players HQ(s)
-- also accounts for level 1 HQ being under construction
function GetPlayerHQLevelEx(_player)
	_player = _player or 1
	if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_player, Entities.PB_Headquarters3) > 0 then
		return 3
	elseif Logic.GetNumberOfEntitiesOfTypeOfPlayer(_player, Entities.PB_Headquarters2) > 0 then
		return 2
	else
		local tHQs = {Logic.GetPlayerEntities(_player, Entities.PB_Headquarters1, 40)}
		for i = 1, tHQs[1] do
			if Logic.IsConstructionComplete(tHQs[i+1]) == 1 then
				return 1
			end
		end
		return 0
	end
end

----------------------------------------------------------------------------------------------------

function IsBuildingUpgrading(_entity)
	if (type(_entity) == "string") then
		_entity = GetEntityId(_entity)
	end
	return not (Logic.GetRemainingUpgradeTimeForBuilding(_entity) == Logic.GetTotalUpgradeTimeForBuilding(_entity))
end

----------------------------------------------------------------------------------------------------

function IsBuildingUpgradable(_entity)
	if (type(_entity) == "string") then
		_entity = GetEntityId(_entity)
	end
	if (not IsExisting(_entity)) or (Logic.IsBuilding(_entity) == 0)
	or (Logic.IsConstructionComplete(_entity) == 0)
	or (Logic.GetRemainingUpgradeTimeForBuilding(_entity) ~= Logic.GetTotalUpgradeTimeForBuilding(_entity)) then
		return false
	end
	local EntityType = Logic.GetEntityType(_entity)
	local Costs = {}
	Logic.FillBuildingUpgradeCostsTable(EntityType, Costs)
	return not TableOnlyZeros(Costs)
end

----------------------------------------------------------------------------------------------------

function TableOnlyZeros(_t)

	assert( type( _t ) == "table", "must be a table value" )
	for i = 1, table.getn(_t) do
		if _t[i] ~= 0 then
			return false
		end
	end
	return true
	
end

----------------------------------------------------------------------------------------------------

-- set camera look at to entity position
function Camera_JumpTo(posOrEntity)
	local pos = GetPos(posOrEntity)
	if pos ~= nil then
		Camera.ScrollSetLookAt(pos.X, pos.Y)
	end
end

----------------------------------------------------------------------------------------------------

-- avoid calling the logic function on entities that do not exist
function MakeVulnerable( _entity )
	local id = GetEntityId(_entity)
	if IsExisting( id ) then
		Logic.SetEntityInvulnerabilityFlag( id, 0 )
		return true
	end
	return false
end

function MakeInvulnerable( _entity )
	local id = GetEntityId(_entity)
	if IsExisting( id ) then
		Logic.SetEntityInvulnerabilityFlag( id, 1 )
		return true
	end
	return false
end

----------------------------------------------------------------------------------------------------

-- check whether or not an entity is currently (theoretically) visible
function IsEntityOnScreen( _entity )
	local id = GetEntityId( _entity )
	if IsDead( id ) then
		return false
	end
	
	return Display.GetDistanceToCamera( id ) > 0
end

-- note: to work reliably it needs S5Hook.GetTerrainInfo to determine the z coordinate of the entity
--> otherwise a rough estimate of z = 2000 is used which obviously is not very accurate
function IsEntityOnScreenS5Hook( _entity )
	local id = GetEntityId( _entity )
	if IsDead( id ) then
		return false
	end
	
	local gvScreenSize = { GUI.GetScreenSize() }
	local pos = GetPos( id )
	local z = S5Hook and S5Hook.GetTerrainInfo( pos.X, pos.Y ) or 2000
	local sx, sy = Camera.GetScreenCoord( pos.X, pos.Y, z )
	if sx < 0 or sx > gvScreenSize[1]
	or sy < 0 or sy > gvScreenSize[2] then
		return false
	end
	return true
end

----------------------------------------------------------------------------------------------------

-- returns a table with the building IDs of recruit buildings for a given player
-- param 1: playerId
-- param 2: table with entity types (optional)
function GetPlayerRecruitBuildings( player, eTypes )
	local player = player or GUI.GetPlayerID()
	local buildings = {}
	local eTypes = eTypes or {
		Entities.PB_Archery1,
		Entities.PB_Archery2,
		Entities.PB_Barracks1,
		Entities.PB_Barracks2,
		Entities.PB_Stable1,
		Entities.PB_Stable2,
		Entities.PB_Foundry1,
		Entities.PB_Foundry2,
	}
	for k, entityType in pairs( eTypes ) do
		local t = { Logic.GetPlayerEntities( player, entityType, 64 ) }
		for i = 2, t[1]+1 do
			table.insert( buildings, t[i] )
		end
	end
	return buildings
end

----------------------------------------------------------------------------------------------------

-- fetch all leaders of a player (no heroes)
-- IMPORTANT: avoid fetching leaders twice (can happen if player has cannons which are also leaders but can NOT be obtained from Logic.GetNextLeader)
function GetPlayerLeaders( _player )
	local playerId = _player or gvMission.PlayerID
	local leaders = {}
	local seen = {}
	
	local LeaderID
	local LastLeaderID = 0
	for n = 1, Logic.GetNumberOfLeader( playerId ) do
		LeaderID = Logic.GetNextLeader( playerId, LastLeaderID )
		
		if seen[LeaderID] then
			-- already seen this one
			break
		else
			table.insert( leaders, LeaderID )
			seen[LeaderID] = true
		end
		
		LastLeaderID = LeaderID
	end
	
	return leaders
end

----------------------------------------------------------------------------------------------------

-- fetches all cannons of a given player in a table
-- maximum number of units to find for GetPlayerEntities?
function GetPlayerCannons( _player )
	local player = _player or gvMission.PlayerID
	local all = {}
	local c = {}
	c[1] = { Logic.GetPlayerEntities( player, Entities.PV_Cannon1, 64 ) }
	c[2] = { Logic.GetPlayerEntities( player, Entities.PV_Cannon2, 64 ) }
	c[3] = { Logic.GetPlayerEntities( player, Entities.PV_Cannon3, 64 ) }
	c[4] = { Logic.GetPlayerEntities( player, Entities.PV_Cannon4, 64 ) }
	
	for i = 1, 4 do
		--for j = 2, table.getn(c[i]) do
		for j = 2, c[i][1]+1 do
			table.insert( all, c[i][j] )
		end
	end
	
	return all
end

----------------------------------------------------------------------------------------------------

function CreateWoodPile( _posEntity, _resources )
	assert( type( _posEntity ) == "string" )
	assert( type( _resources ) == "number" )
	gvWoodPiles = gvWoodPiles or {
		JobID = StartSimpleJob("ControlWoodPiles"),
	}
	local pos = GetPosition( _posEntity )
	local pile_id = Logic.CreateEntity( Entities.XD_SingnalFireOff, pos.X, pos.Y, 0, 0 )
	SetEntityName( pile_id, _posEntity.."_WoodPile" )
	ReplaceEntity( _posEntity, Entities.XD_ResourceTree )
	Logic.SetResourceDoodadGoodAmount( GetEntityId( _posEntity ), _resources*10 )
	table.insert( gvWoodPiles,
		{ ResourceEntity = _posEntity,
			PileEntity = _posEntity.."_WoodPile",
			ResourceLimit = _resources*9 } )
end

function ControlWoodPiles()
	for i = table.getn( gvWoodPiles ),1,-1 do
		local entityId = GetEntityId( gvWoodPiles[i].ResourceEntity )
		if Logic.GetResourceDoodadGoodAmount( entityId ) <= gvWoodPiles[i].ResourceLimit then
			DestroyWoodPile( gvWoodPiles[i], i )
		end
	end
end

function DestroyWoodPile( _piletable, _index )
	local pos = GetPosition( _piletable.ResourceEntity )
	DestroyEntity( _piletable.ResourceEntity )
	DestroyEntity( _piletable.PileEntity )
	Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 0 )
	table.remove( gvWoodPiles, _index )
end

----------------------------------------------------------------------------------------------------

-- create soldiers for a given leader
-- if a limit is given, create up to limit soldiers; default: create as many as possible
function SpawnSoldiersForLeader( leaderId, limit )
	local leaderId = GetID(leaderId)
	if not leaderId or IsDead( leaderId ) or Logic.IsLeader( leaderId ) == 0 then
		return 0
	end
	local numSoldiers = Logic.LeaderGetNumberOfSoldiers( leaderId )
	local maxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers( leaderId )
	local soldiers = maxSoldiers - numSoldiers
	if limit then
		soldiers = math.min( limit, soldiers )
	end
	Tools.CreateSoldiersForLeader( leaderId, soldiers )
	return soldiers
end

----------------------------------------------------------------------------------------------------

