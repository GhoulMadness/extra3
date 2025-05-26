WCutter = WCutter or {}
-- max range woodcutter can find trees (s-cm)
WCutter.MaxRange = 2500
-- min time woodcutter needs to chop tree (sec)
WCutter.BaseTimeNeeded = 2
-- bonus time needed for chopping tree per ressource of respective tree (sec)
WCutter.TimeNeededPerRess = 0.3
-- maximum duration woodcutter needs to chop tree (sec)
WCutter.MaxTimeNeeded = 25
-- chop anim duration in ticks (sec/10)
WCutter.ChopSubAnimDuration = 50
-- delay forester needs to wait between work cycles
WCutter.WorkCycleDelayBase = 5
WCutter.WorkCycleDelay = {}
-- range in which the woodcutter needs to be to start chopping tree (s-cm)
WCutter.ApproachRangeBonus = 200
-- default amount of wood per tree
WCutter.DefaultResourceAmount = 75
-- default tree model (in case it's already XD_ResourceTree)
WCutter.DefaultTreeModel = Models.XD_DarkTree1
-- DoorOffset defining where wcutter will go to to start work cycle
WCutter.HomeSpotOffset = {	X = -200,
							Y = -500}
WCutter.BuildingBelongingWorker = {}
WCutter.WorkActiveState = {}
WCutter.TooltipText = {["de"] = "Holz erhalten: ", ["en"] = "Wood earned: ", ["pl"] = "Wood earned", ["ru"] = "Wood earned", ["us"] = "Wood earned", ["gb"] = "Wood earned"}
-- fake entity to replace tree (needs same blocking params)
WCutter.FakeTreeType = {[1] = Entities.XD_Flower1,
						[2] = Entities.XD_BuildBlockScriptEntity,
						[3] = Entities.XD_Signpost1}
-- tree types woodcutter can cut
WCutter.TreeTypes = {Entities.XD_AppleTree1,
					Entities.XD_AppleTree2,
					Entities.XD_CherryTree,
					Entities.XD_Cypress1,
					Entities.XD_Cypress2,
					Entities.XD_DarkTree1,
					Entities.XD_DarkTree2,
					Entities.XD_DarkTree3,
					Entities.XD_DarkTree4,
					Entities.XD_DarkTree5,
					Entities.XD_DarkTree6,
					Entities.XD_DarkTree7,
					Entities.XD_DarkTree8,
					Entities.XD_DeadTree01,
					Entities.XD_DeadTree02,
					Entities.XD_DeadTree04,
					Entities.XD_DeadTree06,
					Entities.XD_DeadTreeEvelance1,
					Entities.XD_DeadTreeEvelance2,
					Entities.XD_DeadTreeEvelance3,
					Entities.XD_DeadTreeMoor1,
					Entities.XD_DeadTreeMoor2,
					Entities.XD_DeadTreeMoor3,
					Entities.XD_DeadTreeNorth1,
					Entities.XD_DeadTreeNorth2,
					Entities.XD_DeadTreeNorth3,
					Entities.XD_Fir1,
					Entities.XD_Fir2,
					Entities.XD_Fir1_small,
					Entities.XD_Fir2_small,
					Entities.XD_OliveTree1,
					Entities.XD_OliveTree2,
					Entities.XD_OrangeTree1,
					Entities.XD_OrangeTree2,
					Entities.XD_Palm1,
					Entities.XD_Palm2,
					Entities.XD_Palm3,
					Entities.XD_Palm4,
					Entities.XD_Pine1,
					Entities.XD_Pine2,
					Entities.XD_Pine3,
					Entities.XD_Pine4,
					Entities.XD_Pine5,
					Entities.XD_Pine6,
					Entities.XD_PineNorth1,
					Entities.XD_PineNorth2,
					Entities.XD_PineNorth3,
					Entities.XD_Tree1,
					Entities.XD_Tree2,
					Entities.XD_Tree3,
					Entities.XD_Tree4,
					Entities.XD_Tree5,
					Entities.XD_Tree6,
					Entities.XD_Tree7,
					Entities.XD_Tree8,
					Entities.XD_Tree1_small,
					Entities.XD_Tree2_small,
					Entities.XD_Tree3_small,
					Entities.XD_TreeEvelance1,
					Entities.XD_TreeMoor1,
					Entities.XD_TreeMoor2,
					Entities.XD_TreeMoor3,
					Entities.XD_TreeMoor4,
					Entities.XD_TreeMoor5,
					Entities.XD_TreeMoor6,
					Entities.XD_TreeMoor7,
					Entities.XD_TreeMoor8,
					Entities.XD_TreeMoor9,
					Entities.XD_TreeNorth1,
					Entities.XD_TreeNorth2,
					Entities.XD_TreeNorth3,
					Entities.XD_Umbrella1,
					Entities.XD_Umbrella2,
					Entities.XD_Umbrella3,
					Entities.XD_Willow1,
					Entities.XD_ResourceTree}
-- table filled with respective trigger type IDs
WCutter.TriggerIDs = {	WorkControl = {	Start = {},
										Inside = {},
										Outside = {},
										Cut = {},
										ArrivedAtDestination = {},
										CarrierModel = {}},
						CutTree = {},
						RemoveTree = {},
						Behavior = {FinishAnim = {},
									WCutterDied = {},
									WaitForVPFree = {}},
						TreeDestroyed = {}
					}
WCutter.WoodEarned = {}
WCutter.TargettedTrees = {}
-- table filled with terrain types wcutter should not find trees on (e.g. mountains)
WCutter.TerrainTypeBlacklist = {[12] = true,
								[15] = true,
								[27] = true,
								[28] = true,
								[29] = true,
								[30] = true,
								[31] = true,
								[107] = true,
								[108] = true,
								[120] = true,
								[133] = true,
								[134] = true,
								[148] = true,
								[149] = true,
								[150] = true,
								[151] = true,
								[157] = true,
								[158] = true,
								[163] = true,
								[165] = true,
								[166] = true,
								[167] = true,
								[168] = true,
								[169] = true,
								[212] = true,
								[213] = true,
								[215] = true,
								[216] = true,
								[217] = true,
								[218] = true,
								[219] = true,
								[220] = true,
								[221] = true,
								[222] = true,
								[74] = true,
								[80] = true,
								[265] = true,
								[266] = true,
								[267] = true,
								[268] = true,
								[269] = true,
								[270] = true}
WCutter.GetWorkerIDByBuildingID = function(_id)
	return WCutter.BuildingBelongingWorker[_id]
end
WCutter.GetBuildingIDByWorkerID = function(_id)
	for k, v in pairs(WCutter.BuildingBelongingWorker) do
		if _id == v then
			return k
		end
	end
end
WCutter.UpdateWorkCycleDelay = function(_id)
	local motivation = Logic.GetAverageMotivation(Logic.EntityGetPlayer(_id))
	WCutter.WorkCycleDelay[_id] = math.max(round(WCutter.WorkCycleDelayBase / (motivation^1.5)),1)
end
OnWCutter_Created = function(_id)

	if IsExisting(_id) then
		local playerID = Logic.EntityGetPlayer(_id)
		local lim = Logic.GetPlayerAttractionLimit(playerID)
		if lim > 0 and Logic.GetPlayerAttractionUsage(playerID) < lim then

			local buildingposX, buildingposY = Logic.GetEntityPosition(_id)
			local distancetable = {}

			for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(playerID), CEntityIterator.OfAnyTypeFilter(Entities.PB_VillageCenter1, Entities.PB_VillageCenter2,
			Entities.PB_VillageCenter3, Entities.CB_Grange, Entities.PB_Castle1, Entities.PB_Castle2, Entities.PB_Castle3, Entities.PB_Castle4, Entities.PB_Castle5,
			Entities.PB_VillageHall1, Entities.PB_Outpost1, Entities.PB_Outpost2, Entities.PB_Outpost3)) do

				local posX, posY = Logic.GetEntityPosition(eID)
				local distance = GetDistance({X = buildingposX, Y = buildingposY}, {X = posX, Y = posY})
				table.insert(distancetable, {id = eID, dist = distance})

			end

			table.sort(distancetable, function(p1, p2)
				return p1.dist < p2.dist
			end)

			local posX, posY = Logic.GetEntityPosition(distancetable[1].id)
			local rotation = Logic.GetEntityOrientation(distancetable[1].id)
			local doorpos = Forester.DoorOffsetByEntityType[Logic.GetEntityType(distancetable[1].id)]
			local r = math.rad(rotation)
			local s = math.sin(r)
			local c = math.cos(r)
			local _X, _Y = posX + (doorpos.X * c - doorpos.Y * s), posY + (doorpos.X * s + doorpos.Y * c)
			if CUtil.GetSector(_X/100, _Y/100) == 0 then
				_X, _Y = EvaluateNearestUnblockedPosition(_X, _Y, 1000, 100)
			end
			local workerID = Logic.CreateEntity(Entities.PU_WoodCutter, _X, _Y, 0, playerID)
			WCutter.BuildingBelongingWorker[_id] = workerID
			WCutter.WoodEarned[workerID] = 0
			Logic.SetEntityScriptingValue(workerID,72,1)
			Logic.SetEntitySelectableFlag(workerID, 0)

			Logic.MoveSettler(workerID, buildingposX + WCutter.HomeSpotOffset.X, buildingposY + WCutter.HomeSpotOffset.Y)

			WCutter.TriggerIDs.WorkControl.Start[workerID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_WorkControl_Start",1,{},{workerID, _id})
			WCutter.TriggerIDs.Behavior.WCutterDied[workerID] = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,"","OnWCutter_Died",1,{},{workerID, _id})
		else
			WCutter.TriggerIDs.Behavior.WaitForVPFree[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_WaitForVPFree",1,{},{playerID, _id})
		end
	end
end
function WCutter_WaitForVPFree(_playerID, _buildingID)
	if IsExisting(_buildingID) then
		local lim = Logic.GetPlayerAttractionLimit(_playerID)
		if lim > 0 and Logic.GetPlayerAttractionUsage(_playerID) < lim then
			WCutter.TriggerIDs.Behavior.WaitForVPFree[_buildingID] = nil
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_DelayedRespawn",1,{},{_buildingID})
			return true
		end
	else
		WCutter.TriggerIDs.Behavior.WaitForVPFree[_buildingID] = nil
		return true
	end
end
function OnWCutter_Died(_id, _buildingID)

	local entityID = Event.GetEntityID()
    if entityID == _id then
		WCutter.BuildingBelongingWorker[_buildingID] = nil
		WCutter.WoodEarned[_id] = nil
		if IsExisting(_buildingID) then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_DelayedRespawn",1,{},{_buildingID})
		else
			WCutter.WorkActiveState[_buildingID] = nil
		end
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.Behavior.WCutterDied[_id])
		return true
	end
	if entityID == _buildingID then
		if IsExisting(_id) then
			SetEntityVisibility(_id, 3)
			Logic.SetEntityScriptingValue(_id, 72, 0)
			Logic.HurtEntity(_id, 100)
		else
			return true
		end
	end
end
function WCutter_DelayedRespawn(_buildingID)
	OnWCutter_Created(_buildingID)
	return true
end
WCutter.FindNearestTree = function(_id)

	if not IsExisting(_id) then
		return true
	end
	local distancetable = {}
	local x,y = Logic.GetEntityPosition(_id)
	local sector = Logic.GetSector(_id)
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(unpack(WCutter.TreeTypes)), CEntityIterator.InCircleFilter(x, y, WCutter.MaxRange)) do
		if not Logic.GetEntityName(eID) and not WCutter.TargettedTrees[eID] then
			local x_, y_ = Logic.GetEntityPosition(eID)
			local terrtype = CUtil.GetTerrainNodeType(x_/100, y_/100)
			if not WCutter.TerrainTypeBlacklist[terrtype] then
				local sector2 = EvaluateNearestUnblockedSector(x_, y_, 300, 100)
				if sector == sector2 then
					if CUtil.GetTerrainNodeHeight(x_/100, y_/100) > CUtil.GetWaterHeight(x_/100, y_/100) then
						table.insert(distancetable, {id = eID, dist = GetDistance({X = x, Y = y}, GetPosition(eID))})
					end
				end
			end
		end
	end
	table.sort(distancetable, function(p1, p2) return p1.dist < p2.dist end)
	if distancetable and next(distancetable) then
		if distancetable[1].dist <= WCutter.MaxRange then
			return distancetable[1].id
		end
	end
	return 0
end
WCutter_WorkControl_Start = function(_id, _buildingID)

	if not IsExisting(_id) then
		return true
	end
	local buildingpos = GetPosition(_buildingID)
	local targetpos = {	X = buildingpos.X + WCutter.HomeSpotOffset.X,
						Y = buildingpos.Y + WCutter.HomeSpotOffset.Y}
	if Logic.GetCurrentTaskList(_id) == "TL_NPC_IDLE" then
		if GetDistance(GetPosition(_id), {X = targetpos.X, Y = targetpos.Y}) <= 200 then
			Logic.MoveEntity(_id, buildingpos.X, buildingpos.Y)
			WCutter.UpdateWorkCycleDelay(_id)
		end
	end
	if GetDistance(GetPosition(_id), buildingpos) <= 100 then
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.WorkControl.CarrierModel[_id])
		WCutter.TriggerIDs.WorkControl.CarrierModel[_id] = nil
		SetEntityVisibility(_id, 0)
		WCutter.TriggerIDs.WorkControl.Start[_id] = nil
		WCutter.TriggerIDs.WorkControl.Inside[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_WorkControl_Inside",1,{},{_id, _buildingID})
		return true
	end
end
WCutter_WorkControl_Inside = function(_id, _buildingID)

	if not IsExisting(_id) then
		return true
	end
	if WCutter.WorkActiveState[_buildingID] ~= 0 then
		local buildingpos = GetPosition(_buildingID)
		local targetpos = {	X = buildingpos.X + WCutter.HomeSpotOffset.X,
							Y = buildingpos.Y + WCutter.HomeSpotOffset.Y}
		if GetEntityVisibility(_id) == 0 or GetEntityVisibility(_id) == 1 then
			if Counter.Tick2("WCutter_WorkControl_Inside_Delay_".. _id, WCutter.WorkCycleDelay[_id]) then
				SetEntityModel(_id, Models.U_Woodcutter)
				Logic.MoveEntity(_id, math.floor(targetpos.X), math.floor(targetpos.Y))
				SetEntityVisibility(_id, 3)
				Logic.SetEntityScriptingValue(_id, 72, 1)
				Logic.SetEntitySelectableFlag(_id, 0)
				WCutter.TriggerIDs.WorkControl.Outside[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_WorkControl_Outside",1,{},{_id, _buildingID})
				return true
			end
		end
	else
		return true
	end
end
WCutter_WorkControl_Outside = function(_id, _buildingID)

	if not IsExisting(_id) then
		return true
	end
	local buildingpos = GetPosition(_buildingID)
	local targetpos = {	X = buildingpos.X + WCutter.HomeSpotOffset.X,
						Y = buildingpos.Y + WCutter.HomeSpotOffset.Y}
	if GetDistance(GetPosition(_id), {X = targetpos.X, Y = targetpos.Y}) <= 100 then
		if Counter.Tick2("WCutter_WorkControl_Outside_Delay_".. _id, math.ceil(WCutter.WorkCycleDelay[_id]/3)) then
			local id = WCutter.FindNearestTree(_id)
			if id > 0 then
				WCutter.TriggerIDs.TreeDestroyed[id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED,"","OnTargettedTree_Destroyed",1,{},{_id, id})
				WCutter.TargettedTrees[id] = true
				WCutter.StartCutting(_id, id, _buildingID)
				WCutter.TriggerIDs.WorkControl.Outside[_id] = nil
				return true
			end
		end
	end
end
OnTargettedTree_Destroyed = function(_id, _treeid)

	local entityID = Event.GetEntityID()
	if entityID == _treeid then
		if WCutter.TriggerIDs.TreeDestroyed[_treeid] then
			WCutter.TriggerIDs.TreeDestroyed[_treeid] = nil
			WCutter.TargettedTrees[_treeid] = nil
			WCutter.EndWorkCycle(_id)
		end
		return true
	end
end
WCutter.StartCutting = function(_id, _treeid, _buildingID)

	if not IsExisting(_id) then
		return true
	end

	if not WCutter.TriggerIDs.WorkControl.Cut[_id] and IsExisting(_treeid) then
		Logic.MoveSettler(_id, Logic.GetEntityPosition(_treeid))
		WCutter.TriggerIDs.WorkControl.Cut[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "WCutter_ArrivedAtTreeCheck", 1, {}, {_id, _treeid, _buildingID})
	else
		WCutter.TriggerIDs.WorkControl.Cut[_id] = nil
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.TreeDestroyed[_treeid])
		WCutter.TriggerIDs.TreeDestroyed[_treeid] = nil
		WCutter.TargettedTrees[_treeid] = nil
		WCutter.EndWorkCycle(_id)
		return true
	end
end
WCutter_ArrivedAtTreeCheck = function(_id, _treeid, _buildingID)

	if not IsExisting(_id) then
		return true
	end

	if not IsValid(_treeid) then
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.TreeDestroyed[_treeid])
		WCutter.TriggerIDs.TreeDestroyed[_treeid] = nil
		WCutter.TargettedTrees[_treeid] = nil
		WCutter.EndWorkCycle(_id)
		return true
	end
	local range = GetEntityTypeNumBlockedPoints(Logic.GetEntityType(_treeid)) * 100
	if IsNear(_id, _treeid, math.max(range + WCutter.ApproachRangeBonus, 400)) then
		Logic.SetTaskList(_id, TaskLists.TL_NPC_IDLE)
		Logic.EntityLookAt(_id, _treeid)
		WCutter.TriggerIDs.WorkControl.Cut[_id] = nil
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.WorkControl.Cut[_id])
		WCutter.CutTree(_id, _treeid, _buildingID)
		return true
	else
		if Logic.GetCurrentTaskList(_id) == "TL_NPC_IDLE" then
			Logic.MoveSettler(_id, Logic.GetEntityPosition(_treeid))
		end
	end
end
WCutter.CutTree = function(_id, _treeid, _buildingID)

	if not IsExisting(_id) then
		return true
	end
	if not IsExisting(_treeid) then
		WCutter.TargettedTrees[_treeid] = nil
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.TreeDestroyed[_treeid])
		WCutter.TriggerIDs.TreeDestroyed[_treeid] = nil
		WCutter.EndWorkCycle(_id)
		return true
	end

	local posX, posY = Logic.GetEntityPosition(_treeid)
	local num, restree = Logic.GetEntitiesInArea(Entities.XD_ResourceTree, posX, posY, 10, 1)
	local res_amount
	if num > 0 then
		res_amount = Logic.GetResourceDoodadGoodAmount(restree)
	else
		res_amount = WCutter.DefaultResourceAmount
	end
	WCutter.TargettedTrees[_treeid] = nil
	Trigger.UnrequestTrigger(WCutter.TriggerIDs.TreeDestroyed[_treeid])
	WCutter.TriggerIDs.TreeDestroyed[_treeid] = nil
	local newID, etype = WCutter.BlockTree(_treeid, 2)
	_treeid = newID
	WCutter.TriggerIDs.CutTree[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "WCutter_CutTreeDelay", 1, {}, {_id, _treeid, etype, res_amount})
	Logic.SetTaskList(_id, TaskLists.TL_CUT_TREE)
end
WCutter.BlockTree = function(_treeid, _flag)
	--[[ _flag param: 0: unblock
					1: soft block - tree cannot be cut but approached
					2: hard block - tree can neither be approached nor cut
					]]
	local etype = Logic.GetEntityType(_treeid)
	local model = Models[Logic.GetEntityTypeName(etype)] or WCutter.DefaultTreeModel
	local newID = ReplaceEntity(_treeid, WCutter.FakeTreeType[_flag + 1])

	SetEntityModel(newID, model)
	return newID, etype
end
WCutter_CutTreeDelay = function(_id, _treeid, _tree_type, _res_amount)

	if not IsExisting(_id) then
		return true
	end

	if Counter.Tick2("WCutter_CutTreeDelay_".._id.."_".._treeid, math.min(WCutter.BaseTimeNeeded + WCutter.TimeNeededPerRess * _res_amount, WCutter.MaxTimeNeeded)) then
		local tempID, newID
		if IsValid(_treeid) then
			tempID = ReplaceEntity(_treeid, _tree_type)
			newID = WCutter.BlockTree(tempID, 1)
		end
		if newID then
			Logic.SetModelAndAnimSet(newID, Models.XD_Trunk1)
			if Logic.GetWeatherState() ~= 3 then
				Logic.CreateEffect(GGL_Effects.FXChopTree, Logic.GetEntityPosition(newID))
			else
				Logic.CreateEffect(GGL_Effects.FXChopTreeInWinter, Logic.GetEntityPosition(newID))
			end
			WCutter.TriggerIDs.CutTree[_id] = nil
			Trigger.UnrequestTrigger(WCutter.TriggerIDs.CutTree[_id])
			WCutter.TriggerIDs.RemoveTree[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, "", "WCutter_RemoveTree", 1, {}, {_id, newID, _res_amount})
			Logic.SetTaskList(_id, TaskLists.TL_CUT_TREE_END)
			return true
		end
	end
end
WCutter_RemoveTree = function(_id, _treeid, _res_amount)

	if not IsExisting(_id) then
		return true
	end

	if Counter.Tick2("WCutter_RemoveTree_".._id.."_".._treeid, WCutter.ChopSubAnimDuration) then
		Logic.CreateEffect(GGL_Effects.FXDestroyTree, Logic.GetEntityPosition(_treeid))
		ReplaceEntity(_treeid, Entities.XD_TreeStump1)
		if Logic.GetCurrentTaskList(_id) == "TL_NPC_IDLE" then
			Logic.AddToPlayersGlobalResource(Logic.EntityGetPlayer(_id), ResourceType.WoodRaw, _res_amount)
			WCutter.WoodEarned[_id] = WCutter.WoodEarned[_id] + _res_amount
			WCutter.EndWorkCycle(_id)
			WCutter.TriggerIDs.RemoveTree[_id] = nil
			Trigger.UnrequestTrigger(WCutter.TriggerIDs.RemoveTree[_id])
			return true
		end
	end
end
WCutter.EndWorkCycle = function(_id)

	if not IsExisting(_id) then
		return true
	end

	local _buildingID = WCutter.GetBuildingIDByWorkerID(_id)
	if IsExisting(_id) then
		if WCutter.WorkActiveState[_buildingID] ~= 0 then
			local posX, posY = Logic.GetEntityPosition(_buildingID)
			Logic.MoveSettler(_id, posX + WCutter.HomeSpotOffset.X, posY + WCutter.HomeSpotOffset.Y)
			WCutter.TriggerIDs.WorkControl.Start[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_WorkControl_Start",1,{},{_id, _buildingID})
			WCutter.TriggerIDs.WorkControl.CarrierModel[_id] = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","WCutter_SetCarrierModel",1,{},{_id})
		end
	end
end
WCutter_SetCarrierModel = function(_id)

	if not IsValid(_id) then
		Trigger.UnrequestTrigger(WCutter.TriggerIDs.WorkControl.Start[_id])
		WCutter.TriggerIDs.WorkControl.CarrierModel[_id] = nil
		WCutter.TriggerIDs.WorkControl.Start[_id] = nil
		return true
	end
	if GetEntityModel(_id) == Models.U_Woodcutter_Backpack then
		WCutter.TriggerIDs.WorkControl.CarrierModel[_id] = nil
		return true
	end
	SetEntityModel(_id, Models.U_Woodcutter_Backpack)
end
