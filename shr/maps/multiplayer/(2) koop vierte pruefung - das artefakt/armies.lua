--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Build Groups and attach Leaders
function Mission_InitGroups()
	for id in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.CU_AggressiveWolf)) do
		local posX, posY = Logic.GetEntityPosition(id)
		Logic.GroupPatrol(id, posX + math.random(500, 1500), posY + math.random(500, 1500))
	end
	for i = 1, round(4/gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BlackKnight_LeaderMace2, 4, GetPosition("hawk"), "fdef"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("fdef"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("defendRoute")))
	end
	for i = 1, round(3/gvDiffLVL) do
		CreateMilitaryGroup(6, Entities["PU_LeaderBow".. 5-math.ceil(gvDiffLVL)], round(12/gvDiffLVL), GetPosition("defendMine"), "mdef"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("mdef"..i), 24000, 50500)
	end
	for i = 1, round(3/gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BlackKnight_LeaderSword3, 6, GetPosition("defendIron"), "idef"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("idef"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("Hint_Mayor_North2")))
	end
	for i = 1, round(3/gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BanditLeaderSword1, 11-round(gvDiffLVL), GetPosition("robbers5"), "robbers5_"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("robbers5_"..i), 7900, 39100)
	end
	for i = 1, round(4 - gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BanditLeaderBow1, 10/round(gvDiffLVL), GetPosition("robbers4"), "robbers4_"..i)
		Logic.GroupStand(Logic.GetEntityIDByName("robbers4_"..i))
	end
	for i = 1, round(4/gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BlackKnight_LeaderMace2, 4, GetPosition("VictoryErec"), "edef"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("edef"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("ErecTroop2")))
	end
	for i = 1, round(4 - gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BanditLeaderBow1, 10/round(gvDiffLVL), GetPosition("VictoryDario"), "robbers_erec_"..i)
		Logic.GroupStand(Logic.GetEntityIDByName("robbers_erec_"..i))
	end
	for i = 1, round(4 - gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BanditLeaderSword1, 11-round(gvDiffLVL), GetPosition("pat1"), "edef2"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("edef2"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("pat2")))
	end
	for i = 1, round(4 - gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_BanditLeaderSword1, 11-round(gvDiffLVL), GetPosition("pat3"), "edef3"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("edef3"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("pat4")))
	end
	for i = 1, round(4 - gvDiffLVL) do
		CreateMilitaryGroup(6, Entities.CU_VeteranMajor, 4-round(gvDiffLVL), GetPosition("SilverGuard"), "silvdef"..i)
		Logic.GroupPatrol(Logic.GetEntityIDByName("silvdef"..i), Logic.GetEntityPosition(Logic.GetEntityIDByName("SilverPatrol")))
	end
	local mercenaryId1 = Logic.GetEntityIDByName("merchant1")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderPoleArm3, 3 * round(gvDiffLVL), ResourceType.Gold, round(1000/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PV_Cannon1, 5 + round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderSword3, 7 * round(gvDiffLVL), ResourceType.Gold, round(1200/gvDiffLVL))
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderBow3, 3 + round(gvDiffLVL), ResourceType.Gold, round(1500/gvDiffLVL))
end

function CreateArmyP6_1()

	armyP6_1	= {}
    armyP6_1.player = 6
    armyP6_1.id = 1
    armyP6_1.strength = math.ceil(8/gvDiffLVL)
    armyP6_1.position = GetPosition("BanditsSpawn1")
    armyP6_1.rodeLength = 6100/gvDiffLVL
	SetupArmy(armyP6_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP6_1.strength-math.ceil(gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_1,troopDescription)
	end
	for i = 1, math.ceil(gvDiffLVL),1 do
		EnlargeArmy(armyP6_1,troopDescription2)
	end
    StartSimpleJob("ControlarmyP6_1")

end

function ControlarmyP6_1()

    if IsDead(armyP6_1) and IsExisting("BanditsTower1") then
        CreateArmyP6_1()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_1)
		else
			Advance(armyP6_1)
		end
    end
end
function CreateArmyP6_2()

	armyP6_2	= {}
    armyP6_2.player = 6
    armyP6_2.id = 2
    armyP6_2.strength = math.ceil(8/gvDiffLVL)
    armyP6_2.position = GetPosition("BanditsSpawn2")
    armyP6_2.rodeLength = 4800-(200*gvDiffLVL)
	SetupArmy(armyP6_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderBow1

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

    for i = 1, armyP6_2.strength / 3, 1 do
	    EnlargeArmy(armyP6_2,troopDescription)
	end
	for i = 1, armyP6_2.strength / 3, 1 do
	    EnlargeArmy(armyP6_2,troopDescription2)
	end
	for i = 1, armyP6_2.strength / 3, 1 do
	    EnlargeArmy(armyP6_2,troopDescription3)
	end

    StartSimpleJob("ControlarmyP6_2")

end

function ControlarmyP6_2()

    if IsDead(armyP6_2) and IsExisting("BanditsTower2") then
        CreateArmyP6_2()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_2)
		else
			Advance(armyP6_2)
		end
    end
end
function CreateArmyP6_3()

	armyP6_3	= {}
    armyP6_3.player = 6
    armyP6_3.id = 3
    armyP6_3.strength = 8
    armyP6_3.position = GetPosition("BanditsSpawn3")
    armyP6_3.rodeLength = 3500/gvDiffLVL
	SetupArmy(armyP6_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, armyP6_3.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_3,troopDescription)
	end
	for i = 1, round(armyP6_3.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_3,troopDescription2)
	end
    StartSimpleJob("ControlarmyP6_3")

end

function ControlarmyP6_3()

    if IsDead(armyP6_3) and IsExisting("BanditsTower3") then
        CreateArmyP6_3()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_3)
		else
			Advance(armyP6_3)
		end
    end
end
function CreateArmyP6_4()

	armyP6_4	= {}
    armyP6_4.player = 6
    armyP6_4.id = 4
    armyP6_4.strength = 8
    armyP6_4.position = GetPosition("BanditsSpawn4")
    armyP6_4.rodeLength = 6000 - 300 * gvDiffLVL
	SetupArmy(armyP6_4)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, armyP6_4.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_4,troopDescription2)
	end
	for i = 1, round(armyP6_4.strength / gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_4,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_4")

end

function ControlarmyP6_4()

    if IsDead(armyP6_4) and IsExisting("BanditsArchery") then
        CreateArmyP6_4()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_4)
		else
			Advance(armyP6_4)
		end
    end
end

function CreateArmyP6_5()

	armyP6_5	= {}
    armyP6_5.player = 6
    armyP6_5.id = 5
    armyP6_5.strength = math.floor(8/gvDiffLVL)
    armyP6_5.position = GetPosition("BanditsSpawn5")
    armyP6_5.rodeLength = 2600 - 200 * gvDiffLVL
	SetupArmy(armyP6_5)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, math.ceil(armyP6_5.strength/2), 1 do
	    EnlargeArmy(armyP6_5,troopDescription)
	end
	for i = 1, math.floor(armyP6_5.strength/2), 1 do
	    EnlargeArmy(armyP6_5,troopDescription2)
	end
    StartSimpleJob("ControlarmyP6_5")

end

function ControlarmyP6_5()

    if IsDead(armyP6_5) and IsExisting("BanditsTower5") then
        CreateArmyP6_5()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_5)
		else
			Advance(armyP6_5)
		end
    end
end

function CreateArmyP6_6()

	armyP6_6	= {}
    armyP6_6.player = 6
    armyP6_6.id = 6
    armyP6_6.strength = math.floor(8/gvDiffLVL)
    armyP6_6.position = GetPosition("BanditsSpawn6")
    armyP6_6.rodeLength = 5400/gvDiffLVL
	SetupArmy(armyP6_6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP6_6.strength, 1 do
	    EnlargeArmy(armyP6_6,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_6")

end

function ControlarmyP6_6()

    if IsDead(armyP6_6) and IsExisting("BanditsTower6") then
        CreateArmyP6_6()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_6)
		else
			Advance(armyP6_6)
		end
    end
end

function CreateArmyP6_7()

	armyP6_7	= {}
    armyP6_7.player = 6
    armyP6_7.id = 7
    armyP6_7.strength = math.ceil(8/gvDiffLVL)
    armyP6_7.position = GetPosition("BanditsSpawn7")
    armyP6_7.rodeLength = 3900 - (200 * gvDiffLVL)
	SetupArmy(armyP6_7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1, armyP6_7.strength, 1 do
	    EnlargeArmy(armyP6_7,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_7")

end

function ControlarmyP6_7()

    if IsDead(armyP6_7) and IsExisting("BanditsTower7") then
        CreateArmyP6_7()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_7)
		else
			Advance(armyP6_7)
		end
    end
end

function CreateArmyP6_8()

	armyP6_8	= {}
    armyP6_8.player = 6
    armyP6_8.id = 8
    armyP6_8.strength = 8
    armyP6_8.position = GetPosition("BanditsSpawn8")
    armyP6_8.rodeLength = 4200 - (200 * gvDiffLVL)
	SetupArmy(armyP6_8)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 10
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 10
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1, round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_8,troopDescription2)
	end
	for i = 1, armyP6_8.strength - round(gvDiffLVL), 1 do
	    EnlargeArmy(armyP6_8,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_8")

end

function ControlarmyP6_8()

    if IsDead(armyP6_8) and IsExisting("BanditsTower8") then
        CreateArmyP6_8()
        return true
    else
        if sub_armies_aggressive == 0 then
			Defend(armyP6_8)
		else
			Advance(armyP6_8)
		end
    end
end

function CreateArmyP6_9()

	armyP6_9	= {}
    armyP6_9.player = 6
    armyP6_9.id = 9
    armyP6_9.strength = 9 - math.ceil(gvDiffLVL)
    armyP6_9.position = GetPosition("MountainSpawn")
    armyP6_9.rodeLength = 3200 - 200 * gvDiffLVL
	SetupArmy(armyP6_9)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow4

    for i = 1, math.floor(armyP6_9.strength / 2), 1 do
	    EnlargeArmy(armyP6_9,troopDescription2)
	end
	for i = 1, math.ceil(armyP6_9.strength / 2), 1 do
	    EnlargeArmy(armyP6_9,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_9")

end

function ControlarmyP6_9()

    if IsDead(armyP6_9) and IsExisting("MountainVillage") then
        CreateArmyP6_9()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_9)
		else
			Advance(armyP6_9)
		end
    end
end

function CreateArmyP6_10()

	armyP6_10	= {}
    armyP6_10.player = 6
    armyP6_10.id = 10
    armyP6_10.strength = math.max(7 - math.ceil(gvDiffLVL),2)
    armyP6_10.position = GetPosition("MountainSpawn2")
    armyP6_10.rodeLength = 3200 - 200 * gvDiffLVL
	SetupArmy(armyP6_10)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow4

    for i = 1, math.floor(armyP6_10.strength / 2), 1 do
	    EnlargeArmy(armyP6_10,troopDescription2)
	end
	for i = 1, math.ceil(armyP6_10.strength / 2), 1 do
	    EnlargeArmy(armyP6_10,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_10")

end

function ControlarmyP6_10()

    if IsDead(armyP6_10) and IsExisting("MountainCamp") then
        CreateArmyP6_10()
        return true
    else
        if main_armies_aggressive == 0 then
			Defend(armyP6_10)
		else
			Advance(armyP6_10)
		end
    end
end

function CreateArmyP6_11()

	armyP6_11	= {}
    armyP6_11.player = 6
    armyP6_11.id = 11
    armyP6_11.strength = 12 - math.ceil(gvDiffLVL)
    armyP6_11.position = GetPosition("SilverMountainSpawn")
    armyP6_11.rodeLength = 4800 - 200 * gvDiffLVL
	SetupArmy(armyP6_11)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow4

    for i = 1, math.floor(armyP6_11.strength / 2), 1 do
	    EnlargeArmy(armyP6_11,troopDescription2)
	end
	for i = 1, math.ceil(armyP6_11.strength / 2), 1 do
	    EnlargeArmy(armyP6_11,troopDescription)
	end
    StartSimpleJob("ControlarmyP6_11")

end

function ControlarmyP6_11()

    if IsDead(armyP6_11) and IsExisting("VillageHall") then
        CreateArmyP6_11()
        return true
    else
		Defend(armyP6_11)
    end
end
function WestHillArmy()
	if IsExisting("BanditsTower8") then
		armyP6_12	= {}
		armyP6_12.player = 6
		armyP6_12.id = GetFirstFreeArmySlot(6)
		armyP6_12.strength = 6 - math.ceil(gvDiffLVL)
		armyP6_12.position = GetPosition("BanditsSpawn8")
		armyP6_12.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyP6_12)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 8
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.CU_BanditLeaderSword1

		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 10
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = HIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

		for i = 1, math.ceil(armyP6_12.strength / 2), 1 do
			EnlargeArmy(armyP6_12,troopDescription2)
		end
		for i = 1, math.floor(armyP6_12.strength / 2), 1 do
			EnlargeArmy(armyP6_12,troopDescription)
		end
		StartSimpleJob("ControlWestHillArmy")
	end

end
function ControlWestHillArmy()

    if IsDead(armyP6_12) then
		StartCountdown(10 * 60 * gvDiffLVL, WestHillAttack, false)
        return true
    else
		Defend(armyP6_12)
    end
end
function WestSouthCampArmy()
	if IsExisting("BanditsTower7") then
		armyP6_13	= {}
		armyP6_13.player = 6
		armyP6_13.id = GetFirstFreeArmySlot(6)
		armyP6_13.strength = 6 - math.ceil(gvDiffLVL)
		armyP6_13.position = GetPosition("BanditsSpawn7")
		armyP6_13.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyP6_13)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 8 / round(gvDiffLVL)
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities["PU_LeaderSword".. 4 - round(gvDiffLVL)]

		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 4
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = HIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderMace2

		for i = 1, math.ceil(armyP6_13.strength / 2), 1 do
			EnlargeArmy(armyP6_13,troopDescription2)
		end
		for i = 1, math.floor(armyP6_13.strength / 2), 1 do
			EnlargeArmy(armyP6_13,troopDescription)
		end
		StartSimpleJob("ControlWestSouthCampArmy")
	end

end
function ControlWestSouthCampArmy()

    if IsDead(armyP6_13) then
		StartCountdown(8 * 60 * gvDiffLVL, WestHillAttack, false)
        return true
    else
		Defend(armyP6_13)
    end
end
function EastWoodArmy()
	if IsExisting("BanditsTower6") then
		armyP6_12	= {}
		armyP6_12.player = 6
		armyP6_12.id = GetFirstFreeArmySlot(6)
		armyP6_12.strength = 6 - math.ceil(gvDiffLVL)
		armyP6_12.position = GetPosition("BanditsSpawn6")
		armyP6_12.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyP6_12)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 8
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.CU_BanditLeaderSword1

		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 10
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = HIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

		for i = 1, math.ceil(armyP6_12.strength / 2), 1 do
			EnlargeArmy(armyP6_12,troopDescription2)
		end
		for i = 1, math.floor(armyP6_12.strength / 2), 1 do
			EnlargeArmy(armyP6_12,troopDescription)
		end
		StartSimpleJob("ControlEastWoodArmy")
	end

end
function ControlEastWoodArmy()

    if IsDead(armyP6_12) then
		StartCountdown(10 * 60 * gvDiffLVL, EastWoodAttack, false)
        return true
    else
		Defend(armyP6_12)
    end
end
function EastShoreArmy()
	if IsExisting("BanditsTower2") then
		armyP6_13	= {}
		armyP6_13.player = 6
		armyP6_13.id = GetFirstFreeArmySlot(6)
		armyP6_13.strength = 6 - math.ceil(gvDiffLVL)
		armyP6_13.position = GetPosition("BanditsSpawn2")
		armyP6_13.rodeLength = Logic.WorldGetSize()
		SetupArmy(armyP6_13)

		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 8
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3

		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 4
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = HIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderMace2

		for i = 1, math.ceil(armyP6_13.strength / 2), 1 do
			EnlargeArmy(armyP6_13,troopDescription2)
		end
		for i = 1, math.floor(armyP6_13.strength / 2), 1 do
			EnlargeArmy(armyP6_13,troopDescription)
		end
		StartSimpleJob("ControlEastShoreArmy")
	end

end
function ControlEastShoreArmy()

    if IsDead(armyP6_13) then
		StartCountdown(9 * 60 * gvDiffLVL, WestHillAttack, false)
        return true
    else
		Defend(armyP6_13)
    end
end
function CreateArmyNV()

	armyNV	= {}
    armyNV.player = 6
    armyNV.id = GetFirstFreeArmySlot(6)
    armyNV.strength = round(6/gvDiffLVL)
    armyNV.position = GetPosition("GoldMineSpawn")
    armyNV.rodeLength = 4200 - 150 * gvDiffLVL
	SetupArmy(armyNV)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = round(16/gvDiffLVL)
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = round(16/gvDiffLVL)
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_Evil_LeaderSkirmisher1

    for i = 1, math.floor(armyNV.strength / 2), 1 do
	    EnlargeArmy(armyNV,troopDescription2)
	end
	for i = 1, math.ceil(armyNV.strength / 2), 1 do
	    EnlargeArmy(armyNV,troopDescription)
	end
    StartSimpleJob("ControlarmyNV")

end

function ControlarmyNV()

    if IsDead(armyNV) then
        return true
    else
		Defend(armyNV)
    end
end
function CreateAmbushingTroops(_id)
	armyAmbush	= {}
	armyAmbush.player = 6
	armyAmbush.id = GetFirstFreeArmySlot(6)
	armyAmbush.strength = 6 - math.ceil(gvDiffLVL)
	armyAmbush.position = {X = 51600, Y = 34500}
	armyAmbush.rodeLength = Logic.WorldGetSize()
	SetupArmy(armyAmbush)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranMajor

	for i = 1, armyAmbush.strength, 1 do
		EnlargeArmy(armyAmbush,troopDescription)
	end
	StartSimpleJob("ControlAmbushArmy")
end
function ControlAmbushArmy()
	if IsDead(armyAmbush) then
        return true
    else
		Defend(armyAmbush)
    end
end
function LastAttack()
	LastAttackDone = true
	TroopSpawn(70/gvDiffLVL)
	StartSimpleJob("VictoryJob")
end
function SouthCaveAttack()
	CreateAttackingArmies("cave", 3, round(7/gvDiffLVL))
	StartCountdown((5 * gvDiffLVL + (math.random(1,10)/10)) * 60, SouthCaveAttack, false)
end
function TroopSpawnVorb()
	local TimePassed = math.floor(Logic.GetTime()/60/gvDiffLVL)
	local TimeNeeded = math.floor(math.min((5.0+((math.random(1,5)/10))) *60, 11*60/(math.sqrt(gvDiffLVL))))
	if not LastAttackDone then
		TroopSpawn(TimePassed)
		SpawnCounter = StartCountdown(TimeNeeded,TroopSpawnVorb,false)
	end
end
trooptypes = {Entities.PU_LeaderBow4,Entities.CU_BlackKnight_LeaderSword3,Entities.PU_LeaderSword4,Entities.PU_LeaderCavalry2,Entities.PU_LeaderHeavyCavalry2,Entities.CU_BlackKnight_LeaderMace2,Entities.CU_VeteranMajor}
armytroops = {	[1] = {Entities.CU_BanditLeaderSword1, Entities.CU_Barbarian_LeaderClub2},
				[2] = {Entities.CU_BanditLeaderSword1, Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2},
				[3] = {Entities.CU_BanditLeaderSword1, Entities.CU_BanditLeaderBow1, Entities.CU_Barbarian_LeaderClub2, Entities.CU_BlackKnight_LeaderMace2},
				[4] = {Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderSword3, Entities.PU_LeaderBow3, Entities.CU_BlackKnight_LeaderMace2,
				Entities["PV_Cannon".. math.random(1,2)]},
				[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
				trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
				trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)],
				Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]},
				[7] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
				trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
				trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(1,6)],
				Entities["PV_Cannon".. math.random(2,6)], Entities["PV_Cannon".. math.random(3,6)], Entities["PV_Cannon".. math.random(4,6)], Entities["PV_Cannon".. math.random(5,6)]}
			}
function TroopSpawn(_TimePassed)
	Message("Truppen der Raubritter versammeln sich, um die umliegenden Siedlungen zu brandschatzen!")
	Sound.PlayGUISound(Sounds.OnKlick_Select_varg, 120)
	--local type1,type2,type3,type4
	for i = 1,2 do
		if _TimePassed <= 6 then
			CreateAttackingArmies("cave", i, 1)

		elseif _TimePassed > 6 and _TimePassed <= 11 then
			CreateAttackingArmies("cave", i, 2)

		elseif _TimePassed > 11 and _TimePassed <= 24 then
			CreateAttackingArmies("cave", i, 3)

		elseif _TimePassed > 24 and _TimePassed <= 38 then
			-- shuffle
			armytroops[4][5] = Entities["PV_Cannon".. math.random(1,2)]
			--
			CreateAttackingArmies("cave", i, 4)

		elseif _TimePassed > 38 and _TimePassed <= 50 then
			-- shuffle
			armytroops[5] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], Entities["PV_Cannon".. math.random(2,4)],
			Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("cave", i, 5)

		elseif _TimePassed > 50 and _TimePassed <= 65 then
			-- shuffle
			armytroops[6] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)], Entities["PV_Cannon".. math.random(2,4)]}
			--
			CreateAttackingArmies("cave", i, 6)

		elseif _TimePassed > 65 then
			if table.getn(trooptypes) >= 7 then
				table.remove(trooptypes, 6)
				table.remove(trooptypes, 2)
			end
			-- shuffle
			armytroops[7] = {trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))], trooptypes[math.random(1,table.getn(trooptypes))],
			Entities["PV_Cannon".. math.random(1,6)], Entities["PV_Cannon".. math.random(2,6)], Entities["PV_Cannon".. math.random(3,6)],
			Entities["PV_Cannon".. math.random(4,6)], Entities["PV_Cannon".. math.random(5,6)]}
			--
			CreateAttackingArmies("cave", i, 7)
		end
	end
end
InvasionArmyIDByPattern = {["cave"] = {}}
function CreateAttackingArmies(_name, _poscount, _index)

	local player = 7
	local pos = GetPosition(_name .. _poscount)
	local army	= {}
	local id = InvasionArmyIDByPattern[_name][_poscount]
	if not id then
		army.player = player
		army.id	  	=  GetFirstFreeArmySlot(player)
		army.strength = table.getn(armytroops[_index])
		army.position = GetPosition(_name .. _poscount)
		army.rodeLength = Logic.WorldGetSize()
		SetupArmy(army)
		InvasionArmyIDByPattern[_name][_poscount] = army.id
	else
		army = ArmyTable[player][id+1]
		army.strength = table.getn(armytroops[_index])
	end

	for i = 1, army.strength do
		local troopDescription = {}
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = armytroops[_index][i]
		EnlargeArmy(army, troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{army.player, army.id})

end

function ControlArmies(_player, _id, _building)

    if IsDead(ArmyTable[_player][_id + 1]) then
		return true
    else
		Defend(ArmyTable[_player][_id + 1])
    end
end
function UpgradeKIa()
	for i = 3,8 do
		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength + round(4/gvDiffLVL)
	StartCountdown(20*60*gvDiffLVL,UpgradeKIb,false)
end

function UpgradeKIb()
	for i = 3,8 do
		ResearchTechnology(Technologies.T_WoodAging,i)
		ResearchTechnology(Technologies.T_Turnery,i)
		ResearchTechnology(Technologies.T_MasterOfSmithery,i)
		ResearchTechnology(Technologies.T_IronCasting,i)
		ResearchTechnology(Technologies.T_Fletching,i)
		ResearchTechnology(Technologies.T_BodkinArrow,i)
		ResearchTechnology(Technologies.T_EnhancedGunPowder,i)
		ResearchTechnology(Technologies.T_BlisteringCannonballs,i)
		ResearchTechnology(Technologies.T_PaddedArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
		ResearchTechnology(Technologies.T_ChainMailArmor,i)
		ResearchTechnology(Technologies.T_PlateMailArmor,i)
	end
	sub_armies_aggressive = 1
	MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength + round(6/gvDiffLVL)
	StartCountdown(35*60*gvDiffLVL,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 6,7 do
		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
	main_armies_aggressive = 1
	for eID in CEntityIterator.Iterator(CEntityIterator.InCircleFilter(29599.08, 57276.82, 2000), CEntityIterator.OfTypeFilter(Entities.XD_Rock7)) do
		DestroyEntity(eID)
	end
	MapEditor_Armies[6].offensiveArmies.strength = MapEditor_Armies[6].offensiveArmies.strength + round(8/gvDiffLVL)
	SouthCaveAttack()
end