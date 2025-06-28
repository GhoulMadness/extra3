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
---------------------------------- Construction Plan Logic ----------------------------------------
---------------------------------------------------------------------------------------------------
RandomMapAI.ConstructionPlanSnippets = {
	["Research"] = {
		{ type = Entities.PB_University1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Faith"] = {
		{ type = Entities.PB_Monastery1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Market"] = {
		{ type = Entities.PB_Market1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Entertainment"] = {
		{ type = Entities.PB_Tavern1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Beautification_Anniversary20, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Beautification08, pos = invalidPosition, level = 0 }
	},
	["Wood"] = {
		{ type = Entities.PB_Sawmill1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_ForestersHut1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_WoodcuttersHut1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_WoodcuttersHut1, pos = invalidPosition, level = 0 }
	},
	["Coal"] = {
		{ type = Entities.PB_CoalMine1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_CoalmakersHut1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_CoalmakersHut1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Clay"] = {
		{ type = Entities.PB_ClayMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Brickworks1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Stone"] = {
		{ type = Entities.PB_StoneMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_StoneMason1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Iron"] = {
		{ type = Entities.PB_IronMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Blacksmith1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Sulfur"] = {
		{ type = Entities.PB_SulfurMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Alchemist1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_GunsmithWorkshop1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Silver"] = {
		{ type = Entities.PB_SilverMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Silversmith1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["Gold"] = {
		{ type = Entities.PB_GoldMine1, pos = invalidPosition, level = 0 },
    	{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Bank1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.CB_Mint1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Farm1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 }
	},
	["VillageCenter"] = {
		{ type = Entities.PB_VillageCenter1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["VillageHall"] = {
		{ type = Entities.PB_VillageHall1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Lighthouse"] = {
		{ type = Entities.CB_Lighthouse, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Barracks"] = {
		{ type = Entities.PB_Barracks1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Archery"] = {
		{ type = Entities.PB_Archery1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Stables"] = {
		{ type = Entities.PB_Stable1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Foundry"] = {
		{ type = Entities.CB_Grange, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Foundry1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Residence1, pos = invalidPosition, level = 0 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 },
		{ type = Entities.PB_Tower1, pos = invalidPosition, level = 1 }
	},
	["Beauty"] = {
		{ type = Entities["PB_Beautification0" .. math.random(1,9)], pos = invalidPosition, level = 0 },
		{ type = Entities["PB_Beautification0" .. math.random(1,9)], pos = invalidPosition, level = 0 },
		{ type = Entities["PB_Beautification1" .. math.random(0,3)], pos = invalidPosition, level = 0 },
		{ type = Entities["PB_VictoryStatueET2" .. math.random(2,5)], pos = invalidPosition, level = 0 },
	},
	["VictoryStatue"] = {
		{ type = Entities["PB_VictoryStatue" .. math.random(1,9)], pos = invalidPosition, level = 0 },
	},
	["Scaremonger"] = {
		{ type = Entities["PB_Scaremonger0" .. math.random(1,6)], pos = invalidPosition, level = 0 }
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
RandomMapAI.GenerateConstructionPlan = function(_AI)
	local pos = GetPosition("HQP" .. _AI.PlayerID)
	local cplan = {}
	local typesplan = RandomMapAI.ConstructionSnippetTypesByPeacetime[_AI.PeaceTime]
	-- duplicate to manipulate
	local SnippetNamesByTypes = RandomMapAI.ConstructionSnippetTypesToSnippetNames
	local maxNumStruct = _AI.Structures
	local currNumStruct = {NumClayPits = 0, NumStonePits = 0, NumIronPits = 0, NumSulfurPits = 0, NumGoldPits = 0, NumSilverPits = 0, NumVillageCenter = 0, NumVillageHall = 0, NumLighthouse = 0}
	for i = 1, table.getn(typesplan) do
		local snipnames = SnippetNamesByTypes[typesplan[i]]
		local num_snipnames = table.getn(snipnames)
		while num_snipnames == 0 do
			if i >= table.getn(typesplan) then
				return RandomMapAI.ModifyConstructionPlanPreferredPos(cplan, pos)
			end
			i = i + 1
			snipnames = SnippetNamesByTypes[typesplan[i]]
			num_snipnames = table.getn(snipnames)
		end
		local snip = snipnames[math.random(1, table.getn(snipnames))]
		local snipplan = RandomMapAI.ConstructionPlanSnippets[snip]
		for j = 1, table.getn(snipplan) do
			table.insert(cplan, snipplan[j])
		end
		if RandomMapAI.SnippetTypesWithLimit[typesplan[i]] then
			local limitname = RandomMapAI.SnippetNameToLimitName[snip]
			currNumStruct[limitname] = currNumStruct[limitname] + 1
			if currNumStruct[limitname] >= maxNumStruct[limitname] then
				removetablekeyvalue(SnippetNamesByTypes[typesplan[i]], snip)
			end
		end
	end
	return RandomMapAI.ModifyConstructionPlanPreferredPos(cplan, pos)
end
RandomMapAI.ModifyConstructionPlanPreferredPos = function(_cPlan, _pos)
	for i = 1, table.getn(_cPlan) do
		_cPlan[i].pos = _pos
	end
	table.insert(_cPlan, { type = Entities.PB_Castle1, pos = _pos, level = 0 })
	return _cPlan
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
		UpgradeCategories.CoalMine,
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
		for j = 2, math.min(types[2], maxBuildingLVL) do
			table.insert(etypes, types[j])
		end
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.IsBuildingFilter(), CEntityIterator.OfPlayerFilter(_AI.PlayerID), CEntityIterator.OfAnyTypeFilter(unpack(etypes))) do
		local currLVL = Logic.GetUpgradeLevelForBuilding(eID) + 1
		if currLVL < maxBuildingLVL then
			(CSendEvent or SendEvent).UpgradeBuilding(eID)
		end
	end
	StartCountdown((5+(15/_AI.Strength))*60, RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, _AI)
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
	for i = 1, table.getn(AIData) do
		local AI = AIData[i]
		local strength = AI.Strength
		MapEditor_SetupAI(AI.PlayerID, strength, mapsizeX, AI.TechLVL - 1, "HQP" .. AI.PlayerID, 3, AI.PeaceTime * 60, true, 5000)
		local description = {
			serfLimit				=	(strength^2)+2,
			extracting				=	1,
			resources = {
				gold				=	strength*15000,
				clay				=	strength*12500,
				iron				=	strength*12500,
				sulfur				=	strength*12500,
				stone				=	strength*12500,
				wood				=	strength*12500
			},
			refresh = {
				gold				=	strength*1300,
				clay				=	strength*400,
				iron				=	strength*1100,
				sulfur				=	strength*550,
				stone				=	strength*400,
				wood				=	strength*750,
				updateTime			=	math.floor(30/strength)
			},
			constructing			=	true,
			rebuild = {
				delay				=	10*(5-strength),
				randomTime			=	5*(5-strength)
			},
		}
		SetupPlayerAi(AI.PlayerID, description)
		StartCountdown((5/strength)*60, RandomMapAI.IncreaseSerfs, false, nil, AI.PlayerID, strength, description.serfLimit)
		StartCountdown((5+(15/strength))*60, RandomMapAI.UpgradeBuilding.UpgradeCommand, false, nil, AI)
		SetPlayerName(AI.PlayerID, RandomMapAI.PlayerNames[AI.PlayerID - 1])
		local cplan = RandomMapAI.GenerateConstructionPlan(AI)
		FeedAiWithConstructionPlanFile(AI.PlayerID, cplan)
		--
		local team = AI.Team
		if team == 1 then
			ActivateShareExploration(1, AI.PlayerID, true)
			SetFriendly(AI.PlayerID, 1)
		else
			SetHostile(AI.PlayerID, 1)
		end
		for j = 1, table.getn(AIData) do
			local AI2 = AIData[j]
			if i ~= j then
				if team ~= AIData[j].Team then
					SetHostile(AI.PlayerID, AI2.PlayerID)
				end
			end
		end
		Logic.PlayerSetIsHumanFlag(AI.PlayerID, 1)
		Logic.PlayerSetPlayerColor(AI.PlayerID, GUI.GetPlayerColor(AI.PlayerID))
	end
end
function RandomMapAI.IncreaseSerfs(_player, _strength, _serfLimit)
	local serfLimit = _serfLimit + 1
	AI.Village_SetSerfLimit(_player, serfLimit)
	StartCountdown((5/_strength)*60, RandomMapAI.IncreaseSerfs, false, nil, _player, _strength, serfLimit)
end