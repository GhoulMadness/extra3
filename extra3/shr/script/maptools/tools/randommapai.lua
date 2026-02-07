Script.Load("extra3/shr/maps/user/ems/tools/s5communitylib/comfort/table/copytable.lua")

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
RandomMapAI.PossibleHeroes = {
	Entities.PU_Hero1c,
	Entities.PU_Hero2,
	Entities.PU_Hero3,
	Entities.PU_Hero4,
	Entities.PU_Hero5,
	Entities.PU_Hero6,
	Entities.PU_Hero10,
	Entities.PU_Hero11,
	Entities.PU_Hero13,
	Entities.CU_Barbarian_Hero,
	Entities.CU_BlackKnight,
	Entities.CU_Mary_de_Mortfichet,
	Entities.CU_Evil_Queen
}
---------------------------------------------------------------------------------------------------
---------------------------------- Construction position logic ------------------------------------
---------------------------------------------------------------------------------------------------
RandomMapAI.FindValidRectangleCenter = function(_initialX, _initialY, _width, _length, _additionalCheck)
    local halfWidth = _width / 2
    local halfLength = _length / 2
    if BlockingGrid.IsAreaUnblocked(_initialX, _initialY, halfWidth, halfLength) then
        return _initialX, _initialY
    end
	local maxX = BlockingGrid.MaxSizeX
    local searchRadius = 1
	local time = XGUIEng.GetSystemTime()
    while true do
        for offsetX = -searchRadius, searchRadius do
            local checks = {
                {math.max(math.min(_initialX + offsetX, maxX), 0), math.max(math.min(_initialY + searchRadius, maxX), 0)},
                {math.max(math.min(_initialX + offsetX, maxX), 0), math.max(math.min(_initialY - searchRadius, maxX), 0)},
                {math.max(math.min(_initialX + searchRadius, maxX), 0), math.max(math.min(_initialY + offsetX, maxX), 0)},
                {math.max(math.min(_initialX - searchRadius, maxX), 0), math.max(math.min(_initialY + offsetX, maxX), 0)}
            }
            for _, pos in ipairs(checks) do
                if BlockingGrid.IsAreaUnblocked(pos[1], pos[2], halfWidth, halfLength) then
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
		{ type = Entities.PB_Brickworks1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Stone"] = {
		{ type = Entities.PB_StoneMine1, pos = "StonePit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_StoneMason1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Iron"] = {
		{ type = Entities.PB_IronMine1, pos = "IronPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Sulfur"] = {
		{ type = Entities.PB_SulfurMine1, pos = "SulfurPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Alchemist1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_GunsmithWorkshop1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Silver"] = {
		{ type = Entities.PB_SilverMine1, pos = "SilverPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Silversmith1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Gold"] = {
		{ type = Entities.PB_GoldMine1, pos = "GoldPit", dirty = false, level = 0 },
    	{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Bank1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.CB_Mint1, pos = "inherit", dirty = true, level = 0 },
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
	["Beauty1"] = {
		{ type = Entities["PB_Beautification0" .. math.random(1,5)], pos = "base", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification0" .. math.random(6,9)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification1" .. math.random(0,3)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_VictoryStatueET2" .. math.random(2,5)], pos = "inherit", dirty = true, level = 0 },
	},
	["Beauty2"] = {
		{ type = Entities["PB_Beautification0" .. math.random(1,5)], pos = "base", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification0" .. math.random(6,9)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_Beautification1" .. math.random(0,3)], pos = "inherit", dirty = true, level = 0 },
		{ type = Entities["PB_VictoryStatueET2" .. math.random(2,5)], pos = "inherit", dirty = true, level = 0 },
	},
	["VictoryStatue"] = {
		{ type = Entities["PB_VictoryStatue" .. math.random(1,6)], pos = "base", dirty = true, level = 0 },
		{ type = Entities["PB_VictoryStatue" .. math.random(8,9)], pos = "base", dirty = true, level = 0 }
	},
	["Scaremonger"] = {
		{ type = Entities["PB_Scaremonger0" .. math.random(1,6)], pos = "base", dirty = true, level = 0 }
	},
	["Industry1"] = {
		{ type = Entities.PB_Market1, pos = "outer", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = "inherit", dirty = true, level = 0 }
	},
	["Industry2"] = {
		{ type = Entities.PB_Market1, pos = "outer", dirty = true, level = 0 },
		{ type = Entities.PB_Sawmill1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Sawmill1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Sawmill1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	},
	["Industry3"] = {
		{ type = Entities.PB_Market1, pos = "outer", dirty = true, level = 0 },
		{ type = Entities.PB_Bank1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.CB_Mint1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Bank1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Farm1, pos = "inherit", dirty = true, level = 0 },
		{ type = Entities.PB_Residence1, pos = "inherit", dirty = true, level = 0 }
	}
}
RandomMapAI.ConstructionSnippetTypesToSnippetNames = {
	["Mines"] 			= {"Gold", "Clay", "Stone", "Iron", "Sulfur", "Silver"},
	["Industry"]		= {"Industry1", "Industry2", "Industry3"},
	["Village"] 		= {"VillageCenter", "VillageHall", "Lighthouse"},
	["Military"] 		= {"Barracks", "Archery", "Stables", "Foundry"},
	["Civilization"] 	= {"Research", "Faith", "Entertainment"},
	["Motivation"]		= {"Beauty1", "Beauty2"},
	["Misc"] 			= {"VictoryStatue", "Scaremonger", "Wood", "Coal"}
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
		"Industry",
		"Military",
		"Mines",
		"Village",
		"Mines",
		"Civilization",
		"Military",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Military",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Civilization",
		"Misc",
		"Industry",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Industry",
		"Industry"
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
		"Industry",
		"Civilization",
		"Military",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Military",
		"Civilization",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Industry",
		"Industry"
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
		"Industry",
		"Civilization",
		"Military",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Civilization",
		"Military",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Industry",
		"Industry"
	},
	[30] = {
		"Civilization",
		"Mines",
		"Village",
		"Mines",
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
		"Motivation",
		"Mines",
		"Military",
		"Military",
		"Village",
		"Military",
		"Motivation",
		"Military",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Motivation",
		"Mines",
		"Village",
		"Mines",
		"Misc",
		"Mines",
		"Military",
		"Village",
		"Misc",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Industry",
		"Industry"
	},
	[40] = {
		"Mines",
		"Mines",
		"Mines",
		"Mines",
		"Civilization",
		"Village",
		"Mines",
		"Mines",
		"Mines",
		"Mines",
		"Mines",
		"Civilization",
		"Mines",
		"Village",
		"Mines",
		"Civilization",
		"Mines",
		"Motivation",
		"Mines",
		"Mines",
		"Village",
		"Motivation",
		"Industry",
		"Industry",
		"Industry",
		"Industry",
		"Motivation",
		"Industry",
		"Motivation",
		"Industry",
		"Military",
		"Military",
		"Motivation",
		"Motivation",
		"Mines",
		"Misc",
		"Village",
		"Misc",
		"Military",
		"Military",
		"Village",
		"Misc",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Industry",
		"Misc",
		"Military",
		"Industry",
		"Military"
	}
}
RandomMapAI.ConstructionSnippetTypesByPeacetime[50] = RandomMapAI.ConstructionSnippetTypesByPeacetime[40]
RandomMapAI.ConstructionSnippetTypesByPeacetime[60] = RandomMapAI.ConstructionSnippetTypesByPeacetime[40]
RandomMapAI.ConstructionSnippetTypesByPeacetime[70] = RandomMapAI.ConstructionSnippetTypesByPeacetime[40]
RandomMapAI.ConstructionSnippetTypesByPeacetime[80] = RandomMapAI.ConstructionSnippetTypesByPeacetime[40]
RandomMapAI.ConstructionSnippetTypesByPeacetime[90] = RandomMapAI.ConstructionSnippetTypesByPeacetime[40]
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
		local limitname
		if RandomMapAI.SnippetTypesWithLimit[typesplan[i]] then
			limitname = RandomMapAI.SnippetNameToLimitName[snip]
			currNumStruct[limitname] = currNumStruct[limitname] + 1
			if currNumStruct[limitname] >= maxNumStruct[limitname] then
				removetablekeyvalue(SnippetNamesByTypes[typesplan[i]], snip)
			end
		end
		-- only, when minimum 1 of limited types is allowed (e.g no silver eco snippets when there is no silver pit)
		if not limitname
		or (limitname and maxNumStruct[limitname] > 0) then
			local snipplan = CopyTable(RandomMapAI.ConstructionPlanSnippets[snip])
			for j = 1, table.getn(snipplan) do
				if snipplan[j].pos == "base" then
					snipplan[j].pos = pos
				elseif snipplan[j].pos == "inherit" then
					snipplan[j].pos = snipplan[j - 1].pos
				elseif snipplan[j].pos == "outer" then
					local mapSizeX = Logic.WorldGetSize()
					snipplan[j].pos = GetCirclePosInBetween(pos, {X = mapSizeX/2, Y = mapSizeX/2})
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
		local minX, minY = math.min(x1, x2), math.min(y1, y2)
		local maxX, maxY = math.max(x1, x2), math.max(y1, y2)
		local width = dekaround(maxX - minX) + 400
		local length = dekaround(maxY - minY) + 400

		local mapSizeFactor = round(math.min((math.max(Logic.GetTime()/40, 20)), 70))
		if etype == Entities.PB_CoalMine1 then
			posX, posY, rot = EvaluateNearestUnblockedAreaWithAdditionalChecks(player, posX, posY, width, length, MapEditor_Armies[player].Sector, BlockingGrid.MaxSizeX * mapSizeFactor, false, true, false, true, true)
		else
			posX, posY = EvaluateNearestUnblockedAreaWithAdditionalChecks(player, posX, posY, width, length, MapEditor_Armies[player].Sector, BlockingGrid.MaxSizeX * mapSizeFactor/2, false, true, false, false, true)
		end
		if not posX or not posY then
			LuaDebugger.Log("measuring valid position for " .. Logic.GetEntityTypeName(etype) .. " player " .. player .. " failed!")
			StartCountdown(1, RandomMapAI.ProcessConstructionPlan, false, "RandomMapAI_ProcessConstructionPlan_" .. player .. "_" .. _index + 1, _AIData, _cPlan, _index + 1)
			return
		end
	end
	local level = currTask.level
	local secToNextProcess = MapEditor_Armies[player].description.constructionData.delay + math.random(MapEditor_Armies[player].description.constructionData.randomTime)
	--
	local csite = Logic.CreateConstructionSite(posX, posY, rot, etype, player)
	if level > 0 then
		local id = CEntity.GetReversedAttachedEntities(csite)[20][1]
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade", 1, {}, {id, level})
	end
	StartCountdown(secToNextProcess, RandomMapAI.ProcessConstructionPlan, false, "RandomMapAI_ProcessConstructionPlan_" .. player .. "_" .. _index + 1, _AIData, _cPlan, _index + 1)
end
function RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade(_id, _level, _name)
	if _name then
		_id = Logic.GetEntityIDByName(_name)
		if _id == 0 then
			return true
		end
	else
		if not IsValid(_id) then
			return true
		end
		_name = Logic.GetEntityName(_id) or "RandomMapAI_BuildingToUpgrade_" .. Logic.GetEntityTypeName(Logic.GetEntityType(_id)) .. "_" .. _id
		Logic.SetEntityName(_id, _name)
	end
	if Logic.IsConstructionComplete(_id) == 1
	and Logic.GetRemainingUpgradeTimeForBuilding(_id) == Logic.GetTotalUpgradeTimeForBuilding(_id) then
		(CSendEvent or SendEvent).UpgradeBuilding(_id)
		_level = _level - 1
		if _level > 0 then
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RandomMapAI_CheckForBuildingConstructionCompleteToUpgrade", 1, {}, {_id, _level, _name})
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
		local maxLVL = Logic.GetBuildingTypesInUpgradeCategory(Logic.GetUpgradeCategoryByBuildingType(Logic.GetEntityType(eID)))
		if currLVL < maxLVL and currLVL < maxBuildingLVL then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
	StartCountdown((5+(10/_AI.Strength))*60+math.random(0,20), RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, _AI)
end
---------------------------------------------------------------------------------------------------
RandomMapAI.Research = {}

RandomMapAI.Research.BuildingTypeTechs = {
	[Entities.PB_Headquarters1] = {
		Technologies.T_Tracking
	},
	[Entities.PB_Blacksmith1] = {
		Technologies.T_LeatherMailArmor,
		Technologies.T_SoftArcherArmor
	},
	[Entities.PB_Blacksmith2] = {
		Technologies.T_LeatherMailArmor,
		Technologies.T_ChainMailArmor,
		Technologies.T_SoftArcherArmor,
		Technologies.T_PaddedArcherArmor
	},
	[Entities.PB_Blacksmith3] = {
		Technologies.T_LeatherMailArmor,
		Technologies.T_ChainMailArmor,
		Technologies.T_PlateMailArmor,
		Technologies.T_SoftArcherArmor,
		Technologies.T_PaddedArcherArmor,
		Technologies.T_LeatherArcherArmor
	},
	[Entities.PB_Sawmill2] = {
		Technologies.T_Fletching,
		Technologies.T_BodkinArrow,
		Technologies.T_WoodAging,
		Technologies.T_Turnery
	},
	[Entities.PB_Alchemist2] = {
		Technologies.T_EnhancedGunPowder,
		Technologies.T_BlisteringCannonballs
	},
	[Entities.PB_StoneMason2] = {
		Technologies.T_Masonry
	},
	[Entities.PB_Brickworks2] = {
		Technologies.T_LightBricks
	},
	[Entities.PB_Bank2] = {
		Technologies.T_Debenture
	},
	[Entities.PB_Bank3] = {
		Technologies.T_Debenture,
		Technologies.T_BookKeeping
	},
	[Entities.PB_VillageCenter1] = {
		Technologies.T_CityGuard
	},
	[Entities.PB_VillageCenter2] = {
		Technologies.T_CityGuard,
		Technologies.T_Loom
	},
	[Entities.PB_VillageCenter3] = {
		Technologies.T_CityGuard,
		Technologies.T_Loom,
		Technologies.T_Shoes,
		Technologies.T_TownGuard
	},
	[Entities.PB_VillageHall1] = {
		Technologies.T_Foresight,
		Technologies.T_Alacricity
	},
	[Entities.PB_Silversmith2] = {
		Technologies.T_SilverPlateArmor,
		Technologies.T_SilverArcherArmor,
		Technologies.T_SilverArrows,
		Technologies.T_SilverSwords,
		Technologies.T_SilverLance,
		Technologies.T_SilverBullets,
		Technologies.T_SilverMissiles,
		Technologies.T_BloodRush
	},
	[Entities.PB_Barracks2] = {
		Technologies.T_BetterTrainingBarracks
	},
	[Entities.PB_Archery2] = {
		Technologies.T_BetterTrainingArchery
	},
	[Entities.PB_Stable2] = {
		Technologies.T_Shoeing
	},
	[Entities.PB_Foundry2] = {
		Technologies.T_BetterChassis
	},
	[Entities.PB_Castle5] = {
		Technologies.T_HeroicShoes,
		Technologies.T_HeroicArmor,
		Technologies.T_HeroicWeapon
	},
	[Entities.PB_ClayMine3] = {
		Technologies.T_PickAxe
	},
	[Entities.PB_GunsmithWorkshop1] = {
		Technologies.T_FleeceArmor,
		Technologies.T_LeadShot
	},
	[Entities.PB_GunsmithWorkshop2] = {
		Technologies.T_FleeceArmor,
		Technologies.T_FleeceLinedLeatherArmor,
		Technologies.T_LeadShot,
		Technologies.T_Sights
	},
	[Entities.PB_Tavern2] = {
		Technologies.T_ThiefSabotage,
		Technologies.T_Agility,
		Technologies.T_LeatherCoat
	}
}

RandomMapAI.Research.PlayerResearchedTech = {{},{},{},{},{},{},{}}
RandomMapAI.Research.ResearchCommand = function(_AI)
	local player = _AI.PlayerID
	for etype, techs in pairs(RandomMapAI.Research.BuildingTypeTechs) do
		local num, id = Logic.GetPlayerEntities(player, etype, 1)
		if num > 0 then
			if not InterfaceTool_IsBuildingDoingSomething(id) then
				for i = 1, table.getn(techs) do
					local tech = techs[i]
					if not RandomMapAI.Research.PlayerResearchedTech[player - 1][tech] then
						local costs = {}
						Logic.FillTechnologyCostsTable(tech, costs)
						local enough = true
						for res, amount in pairs(costs) do
							if Logic.GetPlayersGlobalResource(player, res) + Logic.GetPlayersGlobalResource(player, res + 1) < amount then
								enough = false
							end
						end
						if enough then
							(CSendEvent or SendEvent).StartResearch(id, tech)
							RandomMapAI.Research.PlayerResearchedTech[player - 1][tech] = true
							break
						end
					end
				end
			end
		end
	end
	local strength = _AI.Strength
	StartCountdown((2+(3/strength))*60+math.random(0,120), RandomMapAI.Research.ResearchCommand, false, nil, _AI)
end
---------------------------------------------------------------------------------------------------
RandomMapAI.CreateHeroArmy = function(_player, _position, _peaceTime, _heroes)
	local army = {}
	army.player 	= _player
	army.id 		= GetFirstFreeArmySlot(_player)
	army.position 	= _position
	army.strength 	= table.getn(_heroes)
	army.rodeLength = 5000
	SetupArmy(army)
	for i = 1, table.getn(_heroes) do
		EnlargeArmy(army, {leaderType = _heroes[i]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RandomMapAI_ControlGenericArmy", 1, {}, {_player, army.id, _peaceTime})
end
RandomMapAI_ControlGenericArmy = function(_player, _id, _peaceTime)
	local army = ArmyTable[_player][_id + 1]
	if Logic.GetTime() < _peaceTime * 60 then
		Defend(army)
	else
		Advance(army)
	end
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
	local numHeroes = GDB.GetValue("Singleplayer\\RandomMapData\\MapHeroes")
	local mapsizeX = Logic.WorldGetSize()
	local lowestPt = AIData[1].PeaceTime
	local playerInTeam = {[1] = {1}}
	for i = 1, table.getn(AIData) do
		local currAI = AIData[i]
		local strength = currAI.Strength
		local player = currAI.PlayerID
		local pt = currAI.PeaceTime
		if pt < lowestPt then
			lowestPt = pt
		end
		MapEditor_SetupAI(player, strength, mapsizeX, currAI.TechLVL - 1, "HQP" .. player, 3, pt * 60, true, 5000)
		local description = MapEditor_GetArmyDefaultDescription(strength)
		description.extractResourcesData.active = true
		description.rebuildData = {
			delay		= 20*(5-strength),
			randomTime	= 12*(5-strength)
		}
		description.serfLimit = 10 + strength
		description.resources = {
			gold		=	2500+strength*2500,
			clay		=	1000+strength*1000,
			iron		=	1250+strength*1250,
			sulfur		=	1000+strength*1000,
			stone		=	1000+strength*1000,
			wood		=	1500+strength*1500
		}
		description.refresh = {
			gold		=	300+strength*300,
			clay		=	100+strength*100,
			iron		=	200+strength*200,
			sulfur		=	125+strength*125,
			stone		=	100+strength*100,
			wood		=	175+strength*175,
			updateTime	=	math.floor(20+20/strength)
		}
		SetupPlayerAi(player, description)
		MapEditor_Armies[player].description.rebuildData.delay = description.rebuildData.delay
		MapEditor_Armies[player].description.rebuildData.randomTime = description.rebuildData.randomTime
		MapEditor_Armies[player].description.constructionData = {delay = 15 - 2 * strength, randomTime = 6 - strength}
		MapEditor_Armies[player].description.extractResourcesData.active = true
		StartCountdown((3/strength)*60+math.random(0,20), RandomMapAI.IncreaseSerfs, false, nil, player, strength, description.serfLimit)
		StartCountdown((5+(14/strength))*60+math.random(0,120), RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, currAI)
		StartCountdown((2+(3/strength))*60+math.random(0,120), RandomMapAI.Research.ResearchCommand, false, nil, currAI)
		SetPlayerName(player, RandomMapAI.PlayerNames[player - 1])
		local cplan = RandomMapAI.GenerateConstructionPlan(currAI)
		RandomMapAI.ProcessConstructionPlan(currAI, cplan, 1)
		--
		local team = currAI.Team
		playerInTeam[team] = playerInTeam[team] or {}
		table.insert(playerInTeam[team], player)
		Logic.PlayerSetIsHumanFlag(player, 1)
		Logic.PlayerSetPlayerColor(player, GUI.GetPlayerColor(player))
		--
		if numHeroes > 0 then
			local possibleHeroes = CopyTable(RandomMapAI.PossibleHeroes)
			local selectedHeroes = {}
			while table.getn(selectedHeroes) < numHeroes do
				local rand = math.random(1, table.getn(possibleHeroes))
				table.insert(selectedHeroes, possibleHeroes[rand])
				table.remove(possibleHeroes, rand)
			end
			--
			RandomMapAI.CreateHeroArmy(player, GetPosition("HQP" .. player), pt, selectedHeroes)
		end
		-- AI should use coal for enhanced refining iron and gold when there are no silver pits
		if Logic.GetNumberOfEntitiesOfType(Entities.XD_SilverPit1) == 0 then
			gvCoal.Usage[player][Entities.PB_Blacksmith1] = true
			gvCoal.Usage[player][Entities.PB_Blacksmith2] = true
			gvCoal.Usage[player][Entities.PB_Blacksmith3] = true
			gvCoal.Usage[player][Entities.CB_Mint1] = true
		end
		-- workaround so forester and woodcutters can spawn despite low village placed provided
		CLogic.SetAttractionLimitOffset(player, 500)
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
	-- show lowest peaceTime as timer
	if lowestPt > 0 then
		StartCountdown(lowestPt * 60, function()
			Message("Die Friendenszeit eines oder mehrerer Spieler ist vorbei! Lasst die Kämpfe beginnen!");
			Sound.PlayGUISound(Sounds.OnKlick_Select_kerberos, 200)
		end, true)
	end
end
function RandomMapAI.IncreaseSerfs(_player, _strength, _serfLimit)
	local serfLimit = _serfLimit + 5
	if serfLimit < 40 + (20 * _strength) then
		AI.Village_SetSerfLimit(_player, serfLimit)
		StartCountdown((5/_strength)*60+math.random(0,20), RandomMapAI.IncreaseSerfs, false, nil, _player, _strength, serfLimit)
	end
end