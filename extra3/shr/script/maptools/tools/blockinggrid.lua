BlockingGrid = BlockingGrid or {}
BlockingGrid.blockedGrid = {}
BlockingGrid.cellSize = 1
-- Raster initialisieren
BlockingGrid.InitializeGrid = function(width, height)
    local cols = math.ceil(width / BlockingGrid.cellSize)
    local rows = math.ceil(height / BlockingGrid.cellSize)
    for x = 1, cols do
        BlockingGrid.blockedGrid[x] = {}
        for y = 1, rows do
            BlockingGrid.blockedGrid[x][y] = false
        end
    end
end
-- Position blockieren oder freigeben
BlockingGrid.UpdateGrid = function(x, y, blocked)
    local cellX = math.floor(x / BlockingGrid.cellSize)
    local cellY = math.floor(y / BlockingGrid.cellSize)
    if BlockingGrid.blockedGrid[cellX] and BlockingGrid.blockedGrid[cellX][cellY] ~= nil then
        BlockingGrid.blockedGrid[cellX][cellY] = blocked
    end
end
-- Created trigger, um Grid aktuell zu halten
BlockingGrid_EntityWithBlockingCreated = function()
	local id = Event.GetEntityID()
	-- e.g. trees placed by forester
	if CUtil.GetEntityClass(id) == 7880308 then
		local etype = Logic.GetEntityType(id)
		local blockingSize = GetEntityTypeNumBlockedPoints(etype)
		if blockingSize > 0 then
			local posX, posY = Logic.GetEntityPosition(id)
			local posXm, posYm = round(posX/100), round(posY/100)
			BlockingGrid.UpdateGrid(posXm, posYm, true)
			if blockingSize > 1 then
				for i = 1, blockingSize - 1 do
					if posX/100 < posXm then
						BlockingGrid.UpdateGrid(posXm - i, posYm, true)
					else
						BlockingGrid.UpdateGrid(posXm + i, posYm, true)
					end
					if posY/100 < posYm then
						BlockingGrid.UpdateGrid(posXm, posYm - i, true)
					else
						BlockingGrid.UpdateGrid(posXm, posYm + i, true)
					end
				end
			end
		end
	-- ignore csites
	elseif CUtil.GetEntityClass(id) ~= 7798844 then
		if Logic.IsBuilding(id) == 1 then
			local etype = Logic.GetEntityType(id)
			local x1, y1, x2, y2 = GetBuildingTypeTerrainPosArea(etype)
			local posX, posY = Logic.GetEntityPosition(id)
			local rot = Logic.GetEntityOrientation(id)
			if rot ~= 0 then
				x1, y1 = RotateOffset(x1, y1, rot)
				x2, y2 = RotateOffset(x2, y2, rot)
			end
			local px1, px2, py1, py2 = math.ceil(x1/100), math.ceil(x2/100), math.ceil(y1/100), math.ceil(y2/100)
			local posXm, posYm = round(posX/100), round(posY/100)
			BlockingGrid.UpdateGrid(posXm, posYm, true)
			for X = math.min(px1, px2), math.max(px1, px2) do
				for Y = math.min(py1, py2), math.max(py1, py2) do
					BlockingGrid.UpdateGrid(posXm + X, posYm + Y, true)
				end
			end
		end
	end
end
-- Destroyed trigger, um Grid aktuell zu halten
BlockingGrid_EntityWithBlockingDestroyed = function()
	local id = Event.GetEntityID()
	-- e.g. trees placed by forester
	if CUtil.GetEntityClass(id) == 7880308 then
		local etype = Logic.GetEntityType(id)
		local blockingSize = GetEntityTypeNumBlockedPoints(etype)
		if blockingSize > 0 then
			local posX, posY = Logic.GetEntityPosition(id)
			local posXm, posYm = round(posX/100), round(posY/100)
			BlockingGrid.UpdateGrid(posXm, posYm, false)
			if blockingSize > 1 then
				for i = 1, blockingSize - 1 do
					if posX/100 < posXm then
						BlockingGrid.UpdateGrid(posXm - i, posYm, false)
					else
						BlockingGrid.UpdateGrid(posXm + i, posYm, false)
					end
					if posY/100 < posYm then
						BlockingGrid.UpdateGrid(posXm, posYm - i, false)
					else
						BlockingGrid.UpdateGrid(posXm, posYm + i, false)
					end
				end
			end
		end
	-- ignore csites
	elseif CUtil.GetEntityClass(id) ~= 7798844 then
		if Logic.IsBuilding(id) == 1 then
			local posX, posY = Logic.GetEntityPosition(id)
			local etype = Logic.GetEntityType(id)
			local nexteType = GetNextHigherEntityTypeInUpgradeCategory(etype, GetUpgradeCategoryByEntityType(etype, true))
			-- was it just some building upgrade?
			if nexteType and Logic.GetEntitiesInArea(nexteType, posX, posY, 1e-10, 1) > 0 then
				-- do nothing, blocking stays the same
			else
				local x1, y1, x2, y2 = GetBuildingTypeTerrainPosArea(etype)
				local rot = Logic.GetEntityOrientation(id)
				if rot ~= 0 then
					x1, y1 = RotateOffset(x1, y1, rot)
					x2, y2 = RotateOffset(x2, y2, rot)
				end
				local px1, px2, py1, py2 = math.ceil(x1/100), math.ceil(x2/100), math.ceil(y1/100), math.ceil(y2/100)
				local posXm, posYm = round(posX/100), round(posY/100)
				BlockingGrid.UpdateGrid(posXm, posYm, true)
				for X = math.min(px1, px2), math.max(px1, px2) do
					for Y = math.min(py1, py2), math.max(py1, py2) do
						BlockingGrid.UpdateGrid(posXm + X, posYm + Y, false)
					end
				end
			end
		end
	end
end
-- Überprüfen ob ein Bereich unblockiert ist
BlockingGrid.IsAreaUnblocked = function(centerX, centerY, halfWidth, halfLength)
    local startX = math.floor((centerX - halfWidth) / BlockingGrid.cellSize)
    local endX = math.floor((centerX + halfWidth) / BlockingGrid.cellSize)
    local startY = math.floor((centerY - halfLength) / BlockingGrid.cellSize)
    local endY = math.floor((centerY + halfLength) / BlockingGrid.cellSize)

    -- Überprüfen, ob alle beteiligten Zellen nicht geblocked sind
    for x = startX, endX do
        for y = startY, endY do
            if BlockingGrid.blockedGrid[x] and BlockingGrid.blockedGrid[x][y] then
                return false
            end
        end
    end
    return true
end

BlockingGrid.MaxSizeX = (Logic.WorldGetSize()/100) - 1
BlockingGrid.InitializeGrid(BlockingGrid.MaxSizeX, BlockingGrid.MaxSizeX)
for X = 0, BlockingGrid.MaxSizeX do
	for Y = 0, BlockingGrid.MaxSizeX do
		BlockingGrid.UpdateGrid(X, Y, GetPositionBlockingType(X*100, Y*100) ~= 0)
	end
end
Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "BlockingGrid_EntityWithBlockingCreated", 1)
Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "BlockingGrid_EntityWithBlockingDestroyed", 1)