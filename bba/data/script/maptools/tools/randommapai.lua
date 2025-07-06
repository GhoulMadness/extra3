Script.Load("extra2/shr/maps/user/ems/tools/s5communitylib/comfort/table/copytable.lua")

RandomMapAI = {}

RandomMapAI.PlayerNames = {
	"(AI) Wolf-Ram",
	"(AI) Guybrush",
	"(AI) Support",
	"(AI) Elektra",
	"(AI) Magic",
	"(AI) Contact",
	"(AI) Wicki"
}
---------------------------------------------------------------------------------------------------
---------------------------------- Construction position logic ------------------------------------
---------------------------------------------------------------------------------------------------
RandomMapAI.blockedGrid = {}
RandomMapAI.cellSize = 1
-- Raster initialisieren
RandomMapAI.InitializeGrid = function(width, height)
    local cols = math.ceil(width / RandomMapAI.cellSize)
    local rows = math.ceil(height / RandomMapAI.cellSize)
    for x = 1, cols do
        RandomMapAI.blockedGrid[x] = {}
        for y = 1, rows do
            RandomMapAI.blockedGrid[x][y] = false
        end
    end
end
-- Position blockieren oder freigeben
RandomMapAI.UpdateGrid = function(x, y, blocked)
    local cellX = math.floor(x / RandomMapAI.cellSize) + 1
    local cellY = math.floor(y / RandomMapAI.cellSize) + 1
    if RandomMapAI.blockedGrid[cellX] and RandomMapAI.blockedGrid[cellX][cellY] ~= nil then
        RandomMapAI.blockedGrid[cellX][cellY] = blocked
    end
end
-- Created trigger, um Grid aktuell zu halten
RandomMapAI_EntityWithBlockingCreated = function()
	local id = Event.GetEntityID()
	-- e.g. trees placed by forester
	if CUtil.GetEntityClass(id) == 7880308 then
		local etype = Logic.GetEntityType(id)
		local blockingSize = GetEntityTypeNumBlockedPoints(etype)
		if blockingSize > 0 then
			local posX, posY = Logic.GetEntityPosition(id)
			local posXm, posYm = round(posX/100), round(posY/100)
			RandomMapAI.UpdateGrid(posXm, posYm, true)
			if blockingSize > 1 then
				for i = 1, blockingSize - 1 do
					if posX/100 < posXm then
						RandomMapAI.UpdateGrid(posXm - i, posYm, true)
					else
						RandomMapAI.UpdateGrid(posXm + i, posYm, true)
					end
					if posY/100 < posYm then
						RandomMapAI.UpdateGrid(posXm, posYm - i, true)
					else
						RandomMapAI.UpdateGrid(posXm, posYm + i, true)
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
			local posXm, posYm = round(posX/100), round(posY/100)
			RandomMapAI.UpdateGrid(posXm, posYm, true)
			for X = math.min(x1, x2), math.max(x1, x2), 100 do
				for Y = math.min(y1, y2), math.max(y1, y2), 100 do
					RandomMapAI.UpdateGrid(posXm + math.ceil(X/100), posYm + math.ceil(Y/100), true)
				end
			end
		end
	end
end
-- Destroyed trigger, um Grid aktuell zu halten
RandomMapAI_EntityWithBlockingDestroyed = function()
	local id = Event.GetEntityID()
	-- e.g. trees placed by forester
	if CUtil.GetEntityClass(id) == 7880308 then
		local etype = Logic.GetEntityType(id)
		local blockingSize = GetEntityTypeNumBlockedPoints(etype)
		if blockingSize > 0 then
			local posX, posY = Logic.GetEntityPosition(id)
			local posXm, posYm = round(posX/100), round(posY/100)
			RandomMapAI.UpdateGrid(posXm, posYm, false)
			if blockingSize > 1 then
				for i = 1, blockingSize - 1 do
					if posX/100 < posXm then
						RandomMapAI.UpdateGrid(posXm - i, posYm, false)
					else
						RandomMapAI.UpdateGrid(posXm + i, posYm, false)
					end
					if posY/100 < posYm then
						RandomMapAI.UpdateGrid(posXm, posYm - i, false)
					else
						RandomMapAI.UpdateGrid(posXm, posYm + i, false)
					end
				end
			end
		end
	-- ignore csites
	elseif CUtil.GetEntityClass(id) ~= 7798844 then
		if Logic.IsBuilding(id) == 1 then
			local posX, posY = Logic.GetEntityPosition(id)
			-- was it just some building upgrade?
			local newID = Logic.GetEntityAtPosition(posX, posY)
			if newID > 0 and Logic.IsBuilding(newID) then
				-- do nothing, blocking stays the same
			else
				local etype = Logic.GetEntityType(id)
				local x1, y1, x2, y2 = GetBuildingTypeTerrainPosArea(etype)

				local posXm, posYm = round(posX/100), round(posY/100)
				RandomMapAI.UpdateGrid(posXm, posYm, true)
				for X = math.min(x1, x2), math.max(x1, x2), 100 do
					for Y = math.min(y1, y2), math.max(y1, y2), 100 do
						RandomMapAI.UpdateGrid(posXm + math.ceil(X/100), posYm + math.ceil(Y/100), false)
					end
				end
			end
		end
	end
end
-- Überprüfen ob ein Bereich unblockiert ist
RandomMapAI.IsAreaUnblocked = function(centerX, centerY, halfWidth, halfLength)
    local startX = math.floor((centerX - halfWidth) / RandomMapAI.cellSize) + 1
    local endX = math.floor((centerX + halfWidth) / RandomMapAI.cellSize) + 1
    local startY = math.floor((centerY - halfLength) / RandomMapAI.cellSize) + 1
    local endY = math.floor((centerY + halfLength) / RandomMapAI.cellSize) + 1

    -- Überprüfen, ob alle beteiligten Zellen nicht geblocked sind
    for x = startX, endX do
        for y = startY, endY do
            if RandomMapAI.blockedGrid[x] and RandomMapAI.blockedGrid[x][y] then
                return false
            end
        end
    end
    return true
end
RandomMapAI.FindValidRectangleCenter = function(_initialX, _initialY, _width, _length, _additionalCheck)
    local halfWidth = _width / 2
    local halfLength = _length / 2
    if RandomMapAI.IsAreaUnblocked(_initialX, _initialY, halfWidth, halfLength) then
        return _initialX, _initialY
    end
	local maxX = RandomMapAI.MaxSizeX
    local searchRadius = 1
	local time = XGUIEng.GetSystemTime()
    while true do
        -- Um den Bereich systematisch zu erweitern (z.B. wie eine Spirale)
        for offsetX = -searchRadius, searchRadius do
            local checks = {
                {math.max(math.min(_initialX + offsetX, maxX), 0), math.max(math.min(_initialY + searchRadius, maxX), 0)},
                {math.max(math.min(_initialX + offsetX, maxX), 0), math.max(math.min(_initialY - searchRadius, maxX), 0)},
                {math.max(math.min(_initialX + searchRadius, maxX), 0), math.max(math.min(_initialY + offsetX, maxX), 0)},
                {math.max(math.min(_initialX - searchRadius, maxX), 0), math.max(math.min(_initialY + offsetX, maxX), 0)}
            }
            for _, pos in ipairs(checks) do
                if RandomMapAI.IsAreaUnblocked(pos[1], pos[2], halfWidth, halfLength) then
					local sec1 = CUtil.GetSector(_initialX, _initialY)
					if sec1 == 0 then
						sec1 = EvaluateNearestUnblockedSector(_initialX * 100, _initialY * 100, 5000, 100)
					end
					if sec1 == CUtil.GetSector(pos[1], pos[2]) then
						if _additionalCheck then
							local rot = 0
							while rot < 360 do
								if _additionalCheck(pos[1] * 100, pos[2] * 100, rot) then
									return pos[1], pos[2], rot
								end
								rot = rot + 5
							end
						else
							return pos[1], pos[2]
						end
					end
                end
            end
        end

        searchRadius = searchRadius + 1
		-- Abbruchbedingung, wenn zu lange gesucht wird
		if XGUIEng.GetSystemTime() > time + 1 then
			break
		end
    end

end
RandomMapAI.MaxSizeX = (Logic.WorldGetSize()/100) - 1
RandomMapAI.InitializeGrid(RandomMapAI.MaxSizeX, RandomMapAI.MaxSizeX)
for X = 0, RandomMapAI.MaxSizeX do
	for Y = 0, RandomMapAI.MaxSizeX do
		RandomMapAI.UpdateGrid(X, Y, GetPositionBlockingType(X*100, Y*100) ~= 0)
	end
end
Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "RandomMapAI_EntityWithBlockingCreated", 1)
Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "RandomMapAI_EntityWithBlockingDestroyed", 1)
---------------------------------------------------------------------------------------------------
---------------------------------- Construction Plan Logic ----------------------------------------
---------------------------------------------------------------------------------------------------
RandomMapAI.ConstructionPlanSnippets = {
	["Research"] = {
		{ type = Entities.PB_University1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Faith"] = {
		{ type = Entities.PB_Monastery1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Market"] = {
		{ type = Entities.PB_Market1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Entertainment"] = {
		{ type = Entities.PB_Tavern1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Beautification_Anniversary20, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Beautification08, pos = "base", dirty = true, level = 0 }
	},
	["Wood"] = {
		{ type = Entities.PB_Sawmill1, pos = "base", dirty = true, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_ForestersHut1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_WoodcuttersHut1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_WoodcuttersHut1, pos = "inherit", dirty = true, level = 0 }
	},
	["Coal"] = {
		{ type = Entities.PB_CoalMine1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_CoalmakersHut1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_CoalmakersHut1, pos = "base", dirty = true, level = 0 }
	},
	["Clay"] = {
		{ type = Entities.PB_ClayMine1, pos = "ClayPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Brickworks1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Stone"] = {
		{ type = Entities.PB_StoneMine1, pos = "StonePit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_StoneMason1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Iron"] = {
		{ type = Entities.PB_IronMine1, pos = "IronPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Sulfur"] = {
		{ type = Entities.PB_SulfurMine1, pos = "SulfurPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Alchemist1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_GunsmithWorkshop1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Silver"] = {
		{ type = Entities.PB_SilverMine1, pos = "SilverPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Silversmith1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Gold"] = {
		{ type = Entities.PB_GoldMine1, pos = "GoldPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Bank1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.CB_Mint1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["VillageCenter"] = {
		{ type = Entities.PB_VillageCenter1, pos = "VillageCenter", dirty = false, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["VillageHall"] = {
		{ type = Entities.PB_VillageHall1, pos = "VillageHall", dirty = false, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Lighthouse"] = {
		{ type = Entities.CB_Lighthouse, pos = "Lighthouse", dirty = false, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Barracks"] = {
		{ type = Entities.PB_Barracks1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Archery"] = {
		{ type = Entities.PB_Archery1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Stables"] = {
		{ type = Entities.PB_Stable1, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Foundry"] = {
		{ type = Entities.CB_Grange, pos = "base", dirty = true, level = 0 },
		{ type = Entities.PB_Foundry1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 },
		{ type = Entities.PB_Tower1, pos = "inherit", dirty = true, level = 1 }
	},
	["Beauty"] = {
		{ type = Entities["PB_Beautification0" .. math.random(1,9)], pos = "base", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification0" .. math.random(1,9)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification1" .. math.random(0,3)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_VictoryStatueET2" .. math.random(2,5)], pos = "inherit", dirty = true, level = 0 },
	},
	["VictoryStatue"] = {
		{ type = Entities["PB_VictoryStatue" .. math.random(1,6)], pos = "base", dirty = true, level = 0 },
		{ type = Entities["PB_VictoryStatue" .. math.random(8,9)], pos = "base", dirty = true, level = 0 }
	},
	["Scaremonger"] = {
		{ type = Entities["PB_Scaremonger0" .. math.random(1,6)], pos = "base", dirty = true, level = 0 }
	}
}
RandomMapAI.ConstructionSnippetTypesToSnippetNames = {
	["Mines"] 			= {"Gold", "Clay", "Stone", "Iron", "Sulfur", "Silver"},
	["Village"] 		= {"VillageCenter", "VillageHall", "Lighthouse"},
	["Military"] 		= {"Barracks", "Archery", "Stables", "Foundry"},
	["Civilization"] 	= {"Research", "Faith", "Market", "Entertainment"},
	["Misc"] 			= {"Beauty", "VictoryStatue", "Scaremonger", "Wood", "Coal"}
}
RandomMapAI.SnippetTypesWithLimit = {
	["Mines"] 	= true,
	["Village"] = true
}
RandomMapAI.SnippetNameToLimitName = {
	["Gold"] 			= "NumGoldPits",
	["Silver"] 			= "NumSilverPits",
	["Clay"] 			= "NumClayPits",
	["Stone"] 			= "NumStonePits",
	["Iron"] 			= "NumIronPits",
	["Sulfur"] 			= "NumSulfurPits",
	["VillageCenter"] 	= "NumVillageCenter",
	["VillageHall"] 	= "NumVillageHall",
	["Lighthouse"] 		= "NumLighthouse"
}
RandomMapAI.ConstructionSnippetTypesByPeacetime = {
	[0] = {
		"Military",
		"Mines",
		"Village",
		"Military",
		"Mines",
		"Civilization",
		"Village",
		"Military",
		"Mines",
		"Mines",
		"Military",
		"Mines",
		"Village",
		"Mines",
		"Civilization",
		"Military",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Military",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Civilization",
		"Misc"
	},
	[10] = {
		"Mines",
		"Military",
		"Village",
		"Military",
		"Mines",
		"Civilization",
		"Village",
		"Military",
		"Mines",
		"Village",
		"Mines",
		"Military",
		"Mines",
		"Mines",
		"Civilization",
		"Military",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Military",
		"Civilization",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc"
	},
	[20] = {
		"Civilization",
		"Mines",
		"Military",
		"Village",
		"Military",
		"Mines",
		"Village",
		"Military",
		"Mines",
		"Mines",
		"Military",
		"Mines",
		"Village",
		"Mines",
		"Civilization",
		"Military",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Civilization",
		"Military",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc"
	},
	[30] = {
		"Civilization",
		"Mines",
		"Village",
		"Mines",
		"Military",
		"Military",
		"Village",
		"Military",
		"Mines",
		"Mines",
		"Military",
		"Civilization",
		"Mines",
		"Village",
		"Mines",
		"Civilization",
		"Military",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Military",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Misc",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc"
	}
}
RandomMapAI.ConstructionSnippetTypesByPeacetime[40] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
RandomMapAI.ConstructionSnippetTypesByPeacetime[50] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
RandomMapAI.ConstructionSnippetTypesByPeacetime[60] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
RandomMapAI.ConstructionSnippetTypesByPeacetime[70] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
RandomMapAI.ConstructionSnippetTypesByPeacetime[80] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
RandomMapAI.ConstructionSnippetTypesByPeacetime[90] = RandomMapAI.ConstructionSnippetTypesByPeacetime[30]
--------------------------------------------------------------------------------------------------------------------------------
RandomMapAI.StructNameToCurrIterationName = {
	["ClayPit"] = "NumClayPits",
	["StonePit"] = "NumStonePits",
	["IronPit"] = "NumIronPits",
	["SulfurPit"] = "NumSulfurPits",
	["GoldPit"] = "NumGoldPits",
	["SilverPit"] = "NumSilverPits",
	["VillageCenter"] = "NumVillageCenter",
	["VillageHall"] = "NumVillageHall",
	["Lighthouse"] = "NumLighthouse"
}
RandomMapAI.GenerateConstructionPlan = function(_AI)
	local pos = GetPosition("HQP" .. _AI.PlayerID)
	local cplan = {}
	local typesplan = RandomMapAI.ConstructionSnippetTypesByPeacetime[_AI.PeaceTime]
	-- duplicate to manipulate
	local SnippetNamesByTypes = CopyTable(RandomMapAI.ConstructionSnippetTypesToSnippetNames)
	local maxNumStruct = _AI.Structures
	local currNumStruct = {NumClayPits = 0, NumStonePits = 0, NumIronPits = 0, NumSulfurPits = 0, NumGoldPits = 0, NumSilverPits = 0, NumVillageCenter = 0, NumVillageHall = 0, NumLighthouse = 0}
	for i = 1, table.getn(typesplan) do
		local snipnames = SnippetNamesByTypes[typesplan[i]]
		local num_snipnames = table.getn(snipnames)
		while num_snipnames == 0 do
			if i >= table.getn(typesplan) then
				return RandomMapAI.VerifyConstructionPlanPreferredPos(cplan)
			end
			i = i + 1
			snipnames = SnippetNamesByTypes[typesplan[i]]
			num_snipnames = table.getn(snipnames)
		end
		local snip = snipnames[math.random(1, table.getn(snipnames))]
		if RandomMapAI.SnippetTypesWithLimit[typesplan[i]] then
			local limitname = RandomMapAI.SnippetNameToLimitName[snip]
			currNumStruct[limitname] = currNumStruct[limitname] + 1
			if currNumStruct[limitname] >= maxNumStruct[limitname] then
				removetablekeyvalue(SnippetNamesByTypes[typesplan[i]], snip)
			end
		end
		local snipplan = CopyTable(RandomMapAI.ConstructionPlanSnippets[snip])
		for j = 1, table.getn(snipplan) do
			if snipplan[j].pos == "base" then
				snipplan[j].pos = pos
			elseif snipplan[j].pos == "inherit" then
				snipplan[j].pos = snipplan[j - 1].pos
			elseif type(snipplan[j].pos) == "string" then
				local typ = snipplan[j].pos
				local itname = RandomMapAI.StructNameToCurrIterationName[typ]
				if maxNumStruct[itname] >= currNumStruct[itname] then
					-- first village center is already built...
					if typ == "VillageCenter" then
						local curr = currNumStruct[itname] + 1
						if curr <= maxNumStruct[itname] then
							snipplan[j].pos = GetPosition(typ .. "_" .. _AI.PlayerID .. "_" .. curr)
						end
					else
						snipplan[j].pos = GetPosition(typ .. "_" .. _AI.PlayerID .. "_" .. (currNumStruct[itname]))
					end
				end
			end
			if type(snipplan[j].pos) == "table" then
				if snipplan[j].pos.X > 0 then
					table.insert(cplan, snipplan[j])
				else
					assert(false, "invalid snipplan position detected")
				end
			end
		end

	end
	-- let the AI build one castle at the very end
	table.insert(cplan, { type = Entities.PB_Castle1, pos = pos, dirty = true, level = 0 })
	return RandomMapAI.VerifyConstructionPlanPreferredPos(cplan)
end
RandomMapAI.VerifyConstructionPlanPreferredPos = function(_cPlan)
	for i = 1, table.getn(_cPlan) do
		assert(type(_cPlan[i].pos) == "table"
		and _cPlan[i].pos.X and type(_cPlan[i].pos.X) == "number" and _cPlan[i].pos.X > 0
		and _cPlan[i].pos.Y and type(_cPlan[i].pos.Y) == "number" and _cPlan[i].pos.Y > 0,
		"invalid position for construction plan")
	end
	return _cPlan
end
RandomMapAI.ProcessConstructionPlan = function(_AIData, _cPlan, _index)
	if _index > table.getn(_cPlan) then
		return
	end
	local player = _AIData.PlayerID
	local strength = _AIData.Strength
	local currTask = _cPlan[_index]
	local posX, posY = currTask.pos.X, currTask.pos.Y
	local rot = 0
	local posDirty = currTask.dirty
	local etype = currTask.type
	if posDirty then
		local x1, y1, x2, y2 = GetBuildingTypeTerrainPosArea(etype)
		local width = math.ceil((math.abs(x1) + math.abs(x2))/100)
		local length = math.ceil((math.abs(y1) + math.abs(y2))/100)
		if etype == Entities.PB_CoalMine1 then
			posX, posY, rot = RandomMapAI.FindValidRectangleCenter(round(posX/100), round(posY/100), width, length, gvCoal.Mine.PlacementCheck)
		else
			posX, posY = RandomMapAI.FindValidRectangleCenter(round(posX/100), round(posY/100), width, length)
		end
		if not (posX and posY) then
			LuaDebugger.Log("measuring valid position failed!")
			StartCountdown(1, RandomMapAI.ProcessConstructionPlan, false, "RandomMapAI_ProcessConstructionPlan_" .. player .. "_" .. _index + 1, _AIData, _cPlan, _index + 1)
		end
		posX, posY = posX * 100, posY * 100
	end
	local level = currTask.level
	local secToNextProcess = MapEditor_Armies[player].description.rebuild.delay + math.random(MapEditor_Armies[player].description.rebuild.randomTime)
	--
	local csite = Logic.CreateConstructionSite(posX, posY, rot, etype, player)
	if level > 0 then
		local id = CEntity.GetReversedAttachedEntities(csite)[20][1]
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade", 1, {}, {id, level})
	end
	StartCountdown(secToNextProcess, RandomMapAI.ProcessConstructionPlan, false, "RandomMapAI_ProcessConstructionPlan_" .. player .. "_" .. _index + 1, _AIData, _cPlan, _index + 1)
end
function RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade(_id, _level)
	if not IsValid(_id) then
		return true
	end
	if Logic.IsConstructionComplete(_id) == 1
	and Logic.GetRemainingUpgradeTimeForBuilding(_id) == Logic.GetTotalUpgradeTimeForBuilding(_id) then
		(CSendEvent or SendEvent).UpgradeBuilding(_id)
		_level = _level - 1
		if _level > 0 then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade", 1, {}, {_id, _level})
		end
		return true
	end
end
---------------------------------------------------------------------------------------------------
RandomMapAI.UpgradeBuilding = {}
RandomMapAI.UpgradeBuilding.MaxUpgradeLVLByTechLVL = {
	[1] = 1,
	[2] = 2,
	[3] = 2,
	[4] = 5
}
RandomMapAI.UpgradeBuilding.UpgradeCategoriesByTechLVL = {
	[1] = {

	},
	[2] = {
		UpgradeCategories.Tower,
		UpgradeCategories.Headquarters,
		UpgradeCategories.VillageCenter,
		UpgradeCategories.Residence,
		UpgradeCategories.Farm,
		UpgradeCategories.Brickworks,
		UpgradeCategories.Blacksmith,
		UpgradeCategories.Monastery,
		UpgradeCategories.IronMine,
		UpgradeCategories.ClayMine,
		UpgradeCategories.StoneMine,
		UpgradeCategories.SulfurMine,
		UpgradeCategories.GoldMine
	},
	[3] = {
		UpgradeCategories.Barracks,
		UpgradeCategories.Archery,
		UpgradeCategories.Foundry,
		UpgradeCategories.Stable,
		UpgradeCategories.Tower,
		UpgradeCategories.Headquarters,
		UpgradeCategories.VillageCenter,
		UpgradeCategories.Residence,
		UpgradeCategories.Farm,
		UpgradeCategories.Brickworks,
		UpgradeCategories.Sawmill,
		UpgradeCategories.StoneMason,
		UpgradeCategories.Blacksmith,
		UpgradeCategories.Alchemist,
		UpgradeCategories.Bank,
		UpgradeCategories.University,
		UpgradeCategories.Monastery,
		UpgradeCategories.IronMine,
		UpgradeCategories.ClayMine,
		UpgradeCategories.StoneMine,
		UpgradeCategories.SulfurMine,
		UpgradeCategories.SilverMine,
		UpgradeCategories.GoldMine,
		UpgradeCategories.Market,
	},
	[4] = {
		UpgradeCategories.Barracks,
		UpgradeCategories.Archery,
		UpgradeCategories.Foundry,
		UpgradeCategories.Stable,
		UpgradeCategories.Tower,
		UpgradeCategories.Headquarters,
		UpgradeCategories.VillageCenter,
		UpgradeCategories.Residence,
		UpgradeCategories.Farm,
		UpgradeCategories.Brickworks,
		UpgradeCategories.Sawmill,
		UpgradeCategories.StoneMason,
		UpgradeCategories.Blacksmith,
		UpgradeCategories.Alchemist,
		UpgradeCategories.GunsmithWorkshop,
		UpgradeCategories.Bank,
		UpgradeCategories.University,
		UpgradeCategories.Monastery,
		UpgradeCategories.Silversmith,
		UpgradeCategories.IronMine,
		UpgradeCategories.ClayMine,
		UpgradeCategories.StoneMine,
		UpgradeCategories.SulfurMine,
		UpgradeCategories.SilverMine,
		UpgradeCategories.GoldMine,
		UpgradeCategories.Coalmine,
		UpgradeCategories.Market,
		UpgradeCategories.Castle,
		UpgradeCategories.Tavern
	}
}
RandomMapAI.UpgradeBuilding.UpgradeCommand = function(_AI)
	local ucatsToUpgrade = RandomMapAI.UpgradeBuilding.UpgradeCategoriesByTechLVL[_AI.TechLVL]
	local numUcats = table.getn(ucatsToUpgrade)
	-- anything to upgrade?
	if numUcats < 1 then
		return
	end
	local maxBuildingLVL = RandomMapAI.UpgradeBuilding.MaxUpgradeLVLByTechLVL[_AI.TechLVL]
	local etypes = {}
	for i = 1, numUcats do
		local types = {Logic.GetBuildingTypesInUpgradeCategory(ucatsToUpgrade[i])}
		for j = 2, math.min(types[1], maxBuildingLVL) do
			table.insert(etypes, types[j])
		end
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(_AI.PlayerID), CEntityIterator.OfAnyTypeFilter(unpack(etypes))) do
		local currLVL = Logic.GetUpgradeLevelForBuilding(eID) + 1
		if currLVL < maxBuildingLVL then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
	StartCountdown((5+(15/_AI.Strength))*60+math.random(0,20), RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, _AI)
end
---------------------------------------------------------------------------------------------------
RandomMapAI.GetAIConfigFromGDBData = function(_structData)
	local AITable = {}
	for i = 1, 7 do
		if GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Active") == 2 then
			local team = GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Team")
			local strength = GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Strength")
			local techLVL = GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_TechLVL")
			local peacetime = GDB.GetValue("Singleplayer\\RandomMapData\\MapAI_" .. i .. "_Peacetime")
			table.insert(AITable, {PlayerID = i+1, Team = team, Strength = strength, TechLVL = techLVL, PeaceTime = peacetime, Structures = _structData})
		end
	end
	return AITable
end
RandomMapAI.Init = function(_structData)
	local AIData = RandomMapAI.GetAIConfigFromGDBData(_structData)
	local mapsizeX = Logic.WorldGetSize()
	local playerInTeam = {[1] = {1}}
	for i = 1, table.getn(AIData) do
		local currAI = AIData[i]
		local strength = currAI.Strength
		local player = currAI.PlayerID
		MapEditor_SetupAI(player, strength, mapsizeX, currAI.TechLVL - 1, "HQP" .. player, 3, currAI.PeaceTime * 60, true, 5000)
		local description = MapEditor_GetArmyDefaultDescription(strength)
		description.extracting = 1
		description.rebuild = {
			delay		= 4*(6-strength),
			randomTime	= 2*(6-strength)
		}
		SetupPlayerAi(player, description)
		MapEditor_Armies[player].description.rebuild.delay = description.rebuild.delay
		MapEditor_Armies[player].description.rebuild.randomTime = description.rebuild.randomTime
		StartCountdown((5/strength)*60+math.random(0,20), RandomMapAI.IncreaseSerfs, false, nil, player, strength, description.serfLimit)
		StartCountdown((5+(15/strength))*60+math.random(0,20), RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, currAI)
		SetPlayerName(player, RandomMapAI.PlayerNames[player - 1])
		local cplan = RandomMapAI.GenerateConstructionPlan(currAI)
		RandomMapAI.ProcessConstructionPlan(currAI, cplan, 1)
		--FeedAiWithConstructionPlanFile(currAI.PlayerID, cplan)
		--
		local team = currAI.Team
		playerInTeam[team] = playerInTeam[team] or {}
		table.insert(playerInTeam[team], player)
		Logic.PlayerSetIsHumanFlag(player, 1)
		Logic.PlayerSetPlayerColor(player, GUI.GetPlayerColor(player))
	end
	-- Diplomacy stuff
	local teams = {}
	for team, _ in playerInTeam do
		table.insert(teams, team)
	end
	for team, players in playerInTeam do
		SetShareView(players, true)
		SetPlayerDiplomacy(players, Diplomacy.Friendly)
		for i = 1, table.getn(teams) do
			if teams[i] ~= team then
				SetPlayerGroupToPlayerGroupDiplomacy(players, playerInTeam[teams[i]], Diplomacy.Hostile)
			end
		end
	end
end
function RandomMapAI.IncreaseSerfs(_player, _strength, _serfLimit)
	local serfLimit = _serfLimit + 1
	AI.Village_SetSerfLimit(_player, serfLimit)
	StartCountdown((5/_strength)*60+math.random(0,20), RandomMapAI.IncreaseSerfs, false, nil, _player, _strength, serfLimit)
end