--[[
	Author: Play4FuN
	Date: 28.09.2022
	
	Description: AI troop recruiting and control behavior, well recruiting primarily
	Note: Some required tools are NOT included; see p4f_tools or S5Hook for that!
	
	important: use GUI.BuySoldier (or SendEvent) to buy soldiers for leaders, or the army controller will get stuck
	
--]]

----------------------------------------------------------------------------------------------------

assert( GetRandomFromTable )
assert( IsValueInTable )
assert( HasPlayerEnoughResources )
assert( IsBuildingUpgrading )
assert( GetPos )
assert( GetDistance )

Log = function(arg)
	-- if not LuaDebugger or not LuaDebugger.Log then
		-- return
	-- end
	-- LuaDebugger.Log(arg)
end

----------------------------------------------------------------------------------------------------


EntityTypesInUpCat = {}
EntityTypesInUpCat[UpgradeCategories.LeaderSword] = { Entities.PU_LeaderSword1, Entities.PU_LeaderSword2, Entities.PU_LeaderSword3, Entities.PU_LeaderSword4, }
EntityTypesInUpCat[UpgradeCategories.LeaderPoleArm] = { Entities.PU_LeaderPoleArm1, Entities.PU_LeaderPoleArm2, Entities.PU_LeaderPoleArm3, Entities.PU_LeaderPoleArm4, }
EntityTypesInUpCat[UpgradeCategories.LeaderBow] = { Entities.PU_LeaderBow1, Entities.PU_LeaderBow2, Entities.PU_LeaderBow3, Entities.PU_LeaderBow4, }
EntityTypesInUpCat[UpgradeCategories.LeaderRifle] = { Entities.PU_LeaderRifle1, Entities.PU_LeaderRifle2, }
EntityTypesInUpCat[UpgradeCategories.LeaderCavalry] = { Entities.PU_LeaderCavalry1, Entities.PU_LeaderCavalry2, }
EntityTypesInUpCat[UpgradeCategories.LeaderHeavyCavalry] = { Entities.PU_LeaderHeavyCavalry1, Entities.PU_LeaderHeavyCavalry2, }
EntityTypesInUpCat[UpgradeCategories.Cannon1] = { Entities.PV_Cannon1, }
EntityTypesInUpCat[UpgradeCategories.Cannon2] = { Entities.PV_Cannon2, }
EntityTypesInUpCat[UpgradeCategories.Cannon3] = { Entities.PV_Cannon3, }
EntityTypesInUpCat[UpgradeCategories.Cannon4] = { Entities.PV_Cannon4, }

-- also reverse this mapping
MapEntityTypeToUpCat = {}
-- MapEntityTypeToUpCat[Entities.PU_LeaderSword1] = UpgradeCategories.LeaderSword
for upCat, entityTypes in EntityTypesInUpCat do
	for i, entityType in entityTypes do
		MapEntityTypeToUpCat[entityType] = upCat
	end
end

-- which buildings to look for to recruit a certain leader (or cannon) category
MapLeaderCategoryToBuildingCategory = {}
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderBow] = UpgradeCategories.Archery
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderRifle] = UpgradeCategories.Archery
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderSword] = UpgradeCategories.Barracks
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderPoleArm] = UpgradeCategories.Barracks
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderCavalry] = UpgradeCategories.Stable
MapLeaderCategoryToBuildingCategory[UpgradeCategories.LeaderHeavyCavalry] = UpgradeCategories.Stable
MapLeaderCategoryToBuildingCategory[UpgradeCategories.Cannon1] = UpgradeCategories.Foundry
MapLeaderCategoryToBuildingCategory[UpgradeCategories.Cannon2] = UpgradeCategories.Foundry
MapLeaderCategoryToBuildingCategory[UpgradeCategories.Cannon3] = UpgradeCategories.Foundry
MapLeaderCategoryToBuildingCategory[UpgradeCategories.Cannon4] = UpgradeCategories.Foundry

----------------------------------------------------------------------------------------------------

function P4F_Army_Init()
	
	if P4F_Army then
		return false
	end
	
	P4F_Army = {}
	
	-- observers
	P4F_Army_Callbacks = {
		onLeaderAttachedToArmy = {},
	}
	
	-- when Logic.UpgradeSettlerCategory is called, all leader IDs from all armys of that player will be invalid
	--> army detects that leaders are "dead" and removes all of them
	-- fix: update their IDs in the army leaders table
	-- GroupSelection_EntityIDChanged gets called when SetPosition, ReplaceEntity or similar (?) is called AND upon Logic.UpgradeSettlerCategory!
	P4F_Army_GroupSelection_EntityIDChanged = GroupSelection_EntityIDChanged
	GroupSelection_EntityIDChanged = function( oldId, newId )
		P4F_Army_GroupSelection_EntityIDChanged( oldId, newId )
		
		if Logic.IsLeader( newId ) == 1 then
			P4F_Army_OnLeaderIdChanged( oldId, newId )
		end
	end
	
	
	-- make sure to disable any entity destroyed trigger before leaving the map!
	P4F_Army_QuickLoad = QuickLoad
	P4F_Army_QuitApplication = QuitApplication
	P4F_Army_QuitGame = QuitGame
	P4F_Army_GUIAction_RestartMap = GUIAction_RestartMap
	P4F_Army_MainWindow_LoadGame_DoLoadGame = MainWindow_LoadGame_DoLoadGame
	
	QuickLoad = function()
		-- Trigger.UnrequestTrigger(  )
		Trigger.DisableTriggerSystem( 1 )
		P4F_Army_QuickLoad()
	end
	
	QuitApplication = function()
		-- Trigger.UnrequestTrigger(  )
		Trigger.DisableTriggerSystem( 1 )
		P4F_Army_QuitApplication()
	end
	
	QuitGame = function()
		-- Trigger.UnrequestTrigger()
		Trigger.DisableTriggerSystem( 1 )
		P4F_Army_QuitGame()
	end
	
	GUIAction_RestartMap = function()
		-- Trigger.UnrequestTrigger()
		Trigger.DisableTriggerSystem( 1 )
		P4F_Army_GUIAction_RestartMap()
	end
	
	MainWindow_LoadGame_DoLoadGame = function(_slot)
		-- Trigger.UnrequestTrigger()
		Trigger.DisableTriggerSystem( 1 )
		P4F_Army_MainWindow_LoadGame_DoLoadGame(_slot)
	end
	
end

----------------------------------------------------------------------------------------------------

function P4F_Army_SetupPlayer( description )
	
	local playerId = description.playerId
	assert( playerId )
	
	if not P4F_Army then
		P4F_Army_Init()
	end
	assert( P4F_Army )
	
	P4F_Army[playerId] = {}
	P4F_Army[playerId].armys = {}
	P4F_Army[playerId].leadersToAssign = {}
	P4F_Army[playerId].leaderToArmyId = {}	-- keep track of the armyId any (assigned) leader of that player belongs to
	P4F_Army[playerId].requestedLeaderCategories = {}
	-- ...
	
	if not description.payLeaders then
		Logic.SetPlayerPaysLeaderFlag( playerId, 0 )
	end
	
	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, "", "P4F_Army_LeaderRecruitController", 1, nil, { playerId } )
	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND, "", "P4F_Army_LeaderAssignmentController", 1, nil, { playerId } )
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, "", "P4F_Army_OnLeaderCreatedEvent", 1, nil, { playerId })
	P4F_Army[playerId].LeaderDestroyedTrigger = Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "P4F_Army_OnLeaderDestroyedEvent", 1, nil, { playerId })
	-- important: disable trigger (system?) before leaving this map!
	
end

----------------------------------------------------------------------------------------------------

function P4F_Army_SetupArmy( playerId, armyDescription )
	assert( P4F_Army_IsValidAiPlayer( playerId ) )
	assert( P4F_Army[playerId].armys )
	assert( armyDescription and armyDescription.id )
	
	local armyId = armyDescription.id
	if P4F_Army[playerId].armys[armyId] then
		-- army already exists!
		return false
	end
	
	P4F_Army[playerId].armys[armyId] = {
		id = armyId,
		playerId = playerId,
		maxStrength = armyDescription.maxStrength or 8,	-- TODO: make AI default values table
		strength = 0,	-- current strength
		allowedTypes = armyDescription.allowedTypes or {},
		leaders = {},
		numberOfRequestsPerCategory = {},
		recruitAllowed = armyDescription.recruitAllowed or false,
	}
	return P4F_Army[playerId].armys[armyId]
	
end

----------------------------------------------------------------------------------------------------

function P4F_Army_IsValidAiPlayer( playerId )
	if not P4F_Army then return false end
	return P4F_Army[playerId] ~= nil
end

----------------------------------------------------------------------------------------------------

-- allowed to buy troops from recruit buildings?
-- AI cannot recruit when it has no village space
function P4F_Army_RecruitLeaderVillageSpaceCheck( playerId )
	-- return Logic.GetPlayerAttractionLimit( playerId ) > 0
	return Logic.GetPlayerAttractionUsage( playerId ) < Logic.GetPlayerAttractionLimit( playerId )
end

----------------------------------------------------------------------------------------------------

-- note: this seems to be a bit too specific already, no?
--> maybe it is okay this way, since the flag can be used to toggle recruiting on or off

-- iterate over all armys this player has
-- check if they are allowed to recruit new leaders right now
--> flag that can be toggled on/off in the individual army controller
-- if they could use more leaders, try to recruit one of the allowed types (upCat)
function P4F_Army_LeaderRecruitController( playerId )
	if Counter.Tick2( "P4F_Army_LeaderRecruitController"..playerId, 5 ) then
		for i = 1, table.getn( P4F_Army[playerId].armys ) do
			local army = P4F_Army[playerId].armys[i]
			if army.recruitAllowed and army.allowedTypes then
				local upCat = GetRandomFromTable( army.allowedTypes )
				local numRequestedLeaders = P4F_Army_GetNumberOfRequestedLeadersForArmy( playerId, army.id )
				if upCat and (army.strength + numRequestedLeaders) < army.maxStrength then
					if P4F_Army_TryToRecruitLeaderOfUpgradeCategory( playerId, upCat, army.id ) then
						-- 
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------

function P4F_Army_GetNumberOfRequestedLeadersForArmy( playerId, armyId )
	local army = P4F_Army[playerId].armys[armyId]
	if not army then
		return 0
	end
	local count = 0
	for upCat, amount in pairs( army.numberOfRequestsPerCategory ) do
		count = count + amount
	end
	return count
end

----------------------------------------------------------------------------------------------------

-- return true if the action was successful, false if not
function P4F_Army_TryToRecruitLeaderOfUpgradeCategory( playerId, upCat, armyId )	-- nil after load
	
	if not P4F_Army_IsValidAiPlayer( playerId ) then
		return false
	end
	
	-- village space check
	if not P4F_Army_RecruitLeaderVillageSpaceCheck( playerId ) then
		return false
	end
	
	local army = P4F_Army[playerId].armys[armyId]
	if not army then
		return false
	end
	
	-- (optional?) respect maxStrength of the army
	--> also consider troops that are requested for this army, but not assigned yet
	local numRequestedUnits = army.numberOfRequestsPerCategory[upCat] or 0
	if (army.strength + numRequestedUnits) >= army.maxStrength then
		return false
	end
	
	-- (optional?) respect if upCat is allowed for this army
	if not IsValueInTable( upCat, army.allowedTypes ) then
		return false
	end
	
	-- resource check
	local CostTable = {}
	-- apparently this works with the leader upCat, too
	Logic.FillSoldierCostsTable( playerId, upCat, CostTable )
	if not HasPlayerEnoughResources( playerId, CostTable ) then
		-- LuaDebugger.Break()
		return false
	end
	
	-- fetch a building to recruit from
	local recruitBuildingId
	for i, buildingId in pairs( P4F_Army_GetRecruitBuildingsForLeaderUpgradeCategory( playerId, upCat ) ) do
		
		-- can start to train there?
		if P4F_Army_IsBuildingReadyToRecruit( buildingId ) then
			recruitBuildingId = buildingId
			break
		end
		
	end
	
	if not IsExisting( recruitBuildingId ) then
		return false
	end
	
	-- all checks okay, buy / start to train
	if upCat == UpgradeCategories.Cannon1 or upCat == UpgradeCategories.Cannon2
	or upCat == UpgradeCategories.Cannon3 or upCat == UpgradeCategories.Cannon4 then
		
		-- ensure that the worker is still alive (and at his workplace)
		-- TODO: needs testing
		local numWorkers, workerId = Logic.GetAttachedWorkersToBuilding( recruitBuildingId )
		if IsDead( workerId ) or Logic.IsSettlerAtWork( workerId ) ~= 1 then
			return false
		end
		
		-- note: distance when starting to work is about 640 (?)
		-- if (numWorkers ~= 1) or (not IsNear(workerId, recruitBuildingId, 1200)) then
			-- LuaDebugger.Break()
			-- return false
		-- end
		
		-- GUI.BuyCannon uses the entity type of the cannon, not the upCat!
		local entityType = EntityTypesInUpCat[upCat][1]
		GUI.BuyCannon( recruitBuildingId, entityType )
		
	else
		
		Logic.BarracksBuyLeader( recruitBuildingId, upCat )
		
	end
	
	Log( "AI recruit leader of category for player" )
	Log( "-- player: "..playerId )
	Log( "-- upCat: "..upCat )
	Log( "-- recruitBuildingId: "..recruitBuildingId )
	
	-- important! store the upCat in requestedLeaderCategories if successful
	P4F_Army_ArmyRequestLeaderUpgradeCategory( playerId, armyId, upCat )
	return true
	
end

----------------------------------------------------------------------------------------------------

-- check if leader training or cannon construction can start at the passed in building
function P4F_Army_IsBuildingReadyToRecruit( buildingId )
	if Logic.IsBuilding( buildingId ) == 0
	or IsBuildingUpgrading( buildingId )
	or Logic.IsConstructionComplete( buildingId ) == 0 then
		return false
	end
	
	local entityType = Logic.GetEntityType( buildingId )
	if entityType == Entities.PB_Foundry1 or entityType == Entities.PB_Foundry2 then
		-- "The returned value will always be 100 if no cannon is currently in production"
		return Logic.GetCannonProgress( buildingId ) == 100
	else
		return P4F_Army_CountLeadersTrainingAtBuilding( buildingId ) < 3
	end
end

----------------------------------------------------------------------------------------------------

function P4F_Army_GetRecruitBuildingsForLeaderUpgradeCategory( playerId, upCat )
	
	local buildingUpCat = MapLeaderCategoryToBuildingCategory[upCat]
	if not buildingUpCat then
		return {}
	end
	
	-- TODO: Predicate not implemented (MP server)
	if S5Hook and not SendEvent then
		return S5Hook.EntityIteratorTableize( Predicate.OfUpgradeCategory( buildingUpCat ), Predicate.OfPlayer( playerId ) )
	else
		-- requires position and search radius (and maximum amount of entities to retrieve)
		return { Logic.GetBuildingsByUpgradeCategory( buildingUpCat, playerId, 0, 0, 0, 16 ) }
	end
	
end

----------------------------------------------------------------------------------------------------

-- check for all leaders of a certain player if they are currently training at the specified barracks (or archery, or stable)
function P4F_Army_CountLeadersTrainingAtBuilding( buildingId )
	
	if IsDead( buildingId )
	or Logic.IsEntityInCategory( buildingId, EntityCategories.MilitaryBuilding ) == 0 then
		return 0
	end
	
	-- does not matter if it is 3 or more, since we do not start to train in either case
	local stopAtCount = 3
	
	local playerId = GetPlayer( buildingId )
	local training = {}	-- avoid counting leaders twice (can happen if player has cannons which are also leaders)
	local count = 0
	
	local LastLeaderID = 0
	for n = 1, Logic.GetNumberOfLeader( playerId ) do
		LeaderID = Logic.GetNextLeader( playerId, LastLeaderID )
		
		if training[LeaderID] then
			-- already counted this one
			break
		elseif Logic.LeaderGetBarrack( LeaderID ) == buildingId then
			count = count + 1
			training[LeaderID] = true
			if count >= stopAtCount then
				return count
			end
		end
		
		LastLeaderID = LeaderID
	end
	
	return count
	
end

----------------------------------------------------------------------------------------------------

function P4F_Army_OnLeaderCreatedEvent( _playerId )	-- nil after load
	local entityId = Event.GetEntityID()
	local playerId = GetPlayer( entityId )
	if playerId ~= _playerId then
		return
	end
	if Logic.IsLeader( entityId ) ~= 1 then
		return
	end
	
	if P4F_Army_IsValidAiPlayer( playerId ) then
		Log( "P4F_Army_OnLeaderCreatedEvent" )
		Log( "-- player: "..playerId )
		Log( "-- entityId: "..entityId )
		Log( "-- entity type: "..Logic.GetEntityTypeName( Logic.GetEntityType(entityId) ) )
		local armyId = P4F_Army_LeaderGetArmyId( entityId )
		if armyId then
			Log( "-- leader is already connected to army " .. armyId )
			return
		end
		P4F_Army_AddLeaderInTraining( playerId, entityId )
	end
end

----------------------------------------------------------------------------------------------------

function P4F_Army_AddLeaderInTraining( playerId, leaderId )
	assert( IsExisting( leaderId ) )
	assert( P4F_Army_IsValidAiPlayer( playerId ) )
	assert( Logic.IsLeader( leaderId ) == 1 )
	assert( P4F_Army[playerId].leadersToAssign )
	-- keep track of all leaders of this player that are not attached to any army yet
	table.insert( P4F_Army[playerId].leadersToAssign, leaderId )
end

----------------------------------------------------------------------------------------------------

-- AI wants to recruit a new leader of a certain upgrade category
-- to be called from a recruit controller (or manually)
function P4F_Army_ArmyRequestLeaderUpgradeCategory( playerId, armyId, upCat )
	assert( P4F_Army[playerId].requestedLeaderCategories )
	table.insert( P4F_Army[playerId].requestedLeaderCategories, { armyId = armyId, upCat = upCat } )
	local army = P4F_Army[playerId].armys[armyId]
	army.numberOfRequestsPerCategory[upCat] = (army.numberOfRequestsPerCategory[upCat] or 0) + 1
end

----------------------------------------------------------------------------------------------------

-- look for an army that requested a leader of the upCat of this leader
-- attach this leader to the army, if possible
function P4F_Army_TryToAttachLeaderToRequesterArmy( playerId, leaderId )
	local entityType = Logic.GetEntityType( leaderId )
	local upCat = MapEntityTypeToUpCat[entityType]
	for i = 1, table.getn( P4F_Army[playerId].requestedLeaderCategories ) do
		local entry = P4F_Army[playerId].requestedLeaderCategories[i]
		if entry.upCat == upCat then
			local armyId = entry.armyId
			local army = P4F_Army[playerId].armys[armyId]
			if P4F_Army_AttachLeaderToArmy( playerId, leaderId, armyId ) then
				table.remove( P4F_Army[playerId].requestedLeaderCategories, i )
				army.numberOfRequestsPerCategory[upCat] = (army.numberOfRequestsPerCategory[upCat] or 0) - 1
				return armyId
			else
				return false
			end
		end
	end
	return false
end

-- actually attach a given leader to the army with the given armyId (if possible)
function P4F_Army_AttachLeaderToArmy( playerId, leaderId, armyId )
	assert( P4F_Army_IsValidAiPlayer( playerId ) )
	assert( P4F_Army[playerId].armys )
	
	if not P4F_Army[playerId].armys[armyId] then
		return false
	end
	
	local army = P4F_Army[playerId].armys[armyId]
	table.insert( army.leaders, leaderId )
	army.strength = army.strength + 1
	P4F_Army[playerId].leaderToArmyId[leaderId] = armyId
	P4F_Army_TriggerEvent( "onLeaderAttachedToArmy", {playerId=playerId, leaderId=leaderId, armyId=armyId} )
	return true
end

----------------------------------------------------------------------------------------------------

function P4F_Army_LeaderAssignmentController( playerId )	-- nil after load
	
	if Counter.Tick2( "P4F_Army_LeaderAssignmentController"..playerId, 5 ) then
		for i = table.getn( P4F_Army[playerId].leadersToAssign ), 1, -1 do
			local leaderId = P4F_Army[playerId].leadersToAssign[i]
			if IsDead( leaderId ) then
				table.remove( P4F_Army[playerId].leadersToAssign, i )
			else
				-- not training anymore?
				-- note that a cannon is not created while "in training" like a normal leader
				if Logic.LeaderGetBarrack( leaderId ) == 0
				-- and Logic.IsHero( leaderId ) == 0	-- this would block the entire assignment process in the current state - maybe?
				and not P4F_Army_LeaderCanGetMoreSoldiers( leaderId ) then
					local armyId = P4F_Army_TryToAttachLeaderToRequesterArmy( playerId, leaderId )
					if armyId then	-- the leader has been assigned to an army
						Log( "AI leader was assigned to army" )
						Log( "-- player: "..playerId )
						Log( "-- leaderId: "..leaderId )
						Log( "-- armyId: "..armyId )
						table.remove( P4F_Army[playerId].leadersToAssign, i )
					end
				end
			end
		end
	end
	
end

function P4F_Army_LeaderCanGetMoreSoldiers( leaderId )
	if Logic.IsLeader( leaderId ) == 0
	or Logic.IsHero( leaderId ) == 1
	or Logic.IsEntityInCategory( leaderId, EntityCategories.Cannon ) == 1 then
		return false
	end
	return Logic.LeaderGetNumberOfSoldiers( leaderId ) < Logic.LeaderGetMaxNumberOfSoldiers( leaderId )
end

----------------------------------------------------------------------------------------------------

function P4F_Army_OnLeaderDestroyedEvent( _playerId )	-- nil after load
	local entityId = Event.GetEntityID()
	local playerId = GetPlayer( entityId )
	if playerId ~= _playerId then
		return
	end
	if Logic.IsLeader( entityId ) ~= 1 then
		return
	end
	-- if P4F_Army_IsValidAiPlayer( playerId ) then
	
	Log( "P4F_Army_OnLeaderDestroyedEvent (player "..playerId..")" )
	Log( "-- leaderId: "..entityId )
	
	-- was this leader attached to any army?
	local armyId = P4F_Army_LeaderGetArmyId( entityId )
	if armyId then
		-- remove the leader from the army table
		P4F_Army_RemoveLeaderFromArmy( playerId, entityId, armyId )
		Log( "-- leader belonged to army "..armyId )
		
	else
		Log( "-- leader did not belong to any army" )
		
		-- not attached to any army (yet)
		local entityType = Logic.GetEntityType( entityId )
		local upCat = MapEntityTypeToUpCat[entityType]
		for i = 1, table.getn( P4F_Army[playerId].requestedLeaderCategories ) do
			local entry = P4F_Army[playerId].requestedLeaderCategories[i]
			if entry.upCat == upCat then
				table.remove( P4F_Army[playerId].requestedLeaderCategories, i )
				local army = P4F_Army[playerId].armys[entry.armyId]
				army.numberOfRequestsPerCategory[upCat] = (army.numberOfRequestsPerCategory[upCat] or 0) - 1
				Log( "-- remove leader upCat from request queue. upCat: "..upCat )
				Log( "-- for army: "..entry.armyId )
				break
			end
		end
	end
end

----------------------------------------------------------------------------------------------------

function P4F_Army_LeaderGetArmyId( leaderId )
	local playerId = GetPlayer( leaderId )
	assert( P4F_Army_IsValidAiPlayer( playerId ) )
	return P4F_Army[playerId].leaderToArmyId[leaderId]
end

----------------------------------------------------------------------------------------------------

function P4F_Army_RemoveLeaderFromArmy( playerId, leaderId, armyId )
	assert( P4F_Army_IsValidAiPlayer( playerId ) )
	assert( P4F_Army[playerId].armys )
	
	if not P4F_Army[playerId].armys[armyId] then
		return false
	end
	
	local army = P4F_Army[playerId].armys[armyId]
	for i = 1, table.getn( army.leaders ) do
		if army.leaders[i] == leaderId then
			table.remove( army.leaders, i )
			army.strength = army.strength - 1
			P4F_Army[playerId].leaderToArmyId[leaderId] = nil
			return true
		end
	end
	
	return false
end

----------------------------------------------------------------------------------------------------

function P4F_Army_OnLeaderIdChanged( oldId, newId )	-- nil after load
	local playerId = GetPlayer( newId )
	
	if not P4F_Army_IsValidAiPlayer( playerId ) then return false end
	
	Log( "P4F_Army_OnLeaderIdChanged" )
	Log( "-- playerId: ".. playerId )
	Log( "-- IDs: " .. oldId .. " -> " .. newId )
	
	local self = P4F_Army[playerId]
	local armyCount = table.getn(self.armys)
	
	-- remove the new leaderId from the leadersToAssign list
	for i = table.getn( self.leadersToAssign ), 1, -1 do
		local leaderId = self.leadersToAssign[i]
		if leaderId == newId then
			table.remove( self.leadersToAssign, i )
			Log( "-- remove leader "..newId.." from leadersToAssign list" )
			break
		end
	end
	
	-- update the leaderId entry in the list of leaders for his army (if any)
	local armyId = self.leaderToArmyId[oldId]
	if armyId then
		local army = self.armys[armyId]
		local leaderCount = table.getn(army.leaders)
		for leaderIndex = 1, leaderCount do
			local leaderId = army.leaders[leaderIndex]
			if leaderId == oldId then
				army.leaders[leaderIndex] = newId
				Log( "-- apply change for army:" )
				Log( "-- armyId: ".. armyId )
				
				-- also update the leaderId -> armyId mapping
				self.leaderToArmyId[oldId] = nil
				self.leaderToArmyId[newId] = armyId
				Log( "update leaderToArmyId:" )
				Log( self.leaderToArmyId )
				return true
			end
		end
	else
		Log( "-- this leader did not belong to any army" )
	end
end

----------------------------------------------------------------------------------------------------

function P4F_Army_GetArmyById( playerId, armyId )
	if not P4F_Army_IsValidAiPlayer( playerId ) then
		return false
	end
	return P4F_Army[playerId].armys[armyId]
end

----------------------------------------------------------------------------------------------------

-- iterate over all leaders of this army and check if they are near a location
function P4F_Army_AreAllLeadersNearPosition( playerId, armyId, position, distance )	-- nil after load
	local maxDistance = distance or 3000
	local position = GetPos( position )
	local army = P4F_Army_GetArmyById( playerId, armyId )
	if not army then
		Log( "P4F_Army_AreAllLeadersNearPosition WARN: invalid army" )
		Log( "-- playerId: " .. playerId )
		Log( "-- armyId: " .. armyId )
		return false
	end
	
	local GetDistance = GetDistance
	local leaderCount = table.getn(army.leaders)
	for leaderIndex = 1, leaderCount do
		local leaderId = army.leaders[leaderIndex]
		if GetDistance( leaderId, position ) > maxDistance then
			return false
		end
	end
	return true
end

----------------------------------------------------------------------------------------------------

-- add a listener function to be called when an event occurs
function P4F_Army_AddEventListener( eventType, f )
	assert( type(f) == "function" )
	P4F_Army_Callbacks[eventType] = P4F_Army_Callbacks[eventType] or {}
	table.insert( P4F_Army_Callbacks[eventType], f )
end

-- trigger an event
-- pass in one table with all event related information
function P4F_Army_TriggerEvent( eventType, eventData )
	if not P4F_Army_Callbacks[eventType] then
		return 0
	end
	local num = 0
	for _, observer in P4F_Army_Callbacks[eventType] do
		observer( eventData )
		num = num + 1
	end
	return num
end

----------------------------------------------------------------------------------------------------

