function P5_Troops(_num)
	if not armyP5 then
		armyP5 = {}
	end
	armyP5[_num]			= {}
    armyP5[_num].player 	= 5
    armyP5[_num].id 		= _num - 1
    armyP5[_num].strength 	= p5_troop_slots
    armyP5[_num].position 	= GetPosition("p5_spawn")
    armyP5[_num].rodeLength = 2000
	SetupArmy(armyP5[_num])

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = (p5_troop_level*4)-4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = LOW_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderSword"..p5_troop_level]

	EnlargeArmy(armyP5[_num],troopDescription)

	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = (p5_troop_level*4)-4
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = 0
	troopDescription2.leaderType = Entities["PU_LeaderPoleArm"..p5_troop_level]

	EnlargeArmy(armyP5[_num],troopDescription2)

	if p5_troop_slots >= 3 then
		local troopDescription3 = {}
		troopDescription3.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription3.minNumberOfSoldiers = 0
		troopDescription3.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription3.leaderType = Entities["PU_LeaderSword"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription3.leaderType = Entities["PU_LeaderBow"..p5_troop_level]
		elseif p5_troop_types >= 3 then
			troopDescription3.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription3.leaderType = Entities["PU_LeaderCavalry"..math.ceil(p5_troop_level/2)]
		end
		EnlargeArmy(armyP5[_num],troopDescription3)
	end
	if p5_troop_slots >= 4 then
		local troopDescription4 = {}
		troopDescription4.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription4.minNumberOfSoldiers = 0
		troopDescription4.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription4.leaderType = Entities["PU_LeaderPoleArm"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription4.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription4.leaderType = Entities["PU_LeaderRifle"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types >= 3 then
			troopDescription4.maxNumberOfSoldiers = 3 - math.floor(2/p5_troop_level)
			troopDescription4.leaderType = Entities["PU_LeaderHeavyCavalry"..math.ceil(p5_troop_level/2)]
		end
		EnlargeArmy(armyP5[_num],troopDescription4)
	end
	if p5_troop_slots >= 5 then
		local troopDescription5 = {}
		troopDescription5.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription5.minNumberOfSoldiers = 0
		troopDescription5.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription5.leaderType = Entities["PU_LeaderSword"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription5.leaderType = Entities["PU_LeaderBow"..p5_troop_level]
		elseif p5_troop_types >= 3 then
			troopDescription5.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription5.leaderType = Entities["PU_LeaderCavalry"..math.ceil(p5_troop_level/2)]
		end
		EnlargeArmy(armyP5[_num],troopDescription5)
	end
	if p5_troop_slots >= 6 then
		local troopDescription6 = {}
		troopDescription6.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription6.minNumberOfSoldiers = 0
		troopDescription6.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription6.leaderType = Entities["PU_LeaderPoleArm"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription6.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription6.leaderType = Entities["PU_LeaderRifle"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types >= 3 then
			troopDescription6.maxNumberOfSoldiers = 3 - math.floor(2/p5_troop_level)
			troopDescription6.leaderType = Entities["PU_LeaderHeavyCavalry"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types == 4 then
			troopDescription6.maxNumberOfSoldiers = 0
			troopDescription6.leaderType = Entities.PV_Cannon1
		end
		EnlargeArmy(armyP5[_num],troopDescription6)
	end
	if p5_troop_slots >= 7 then
		local troopDescription7 = {}
		troopDescription7.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription7.minNumberOfSoldiers = 0
		troopDescription7.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription7.leaderType = Entities["PU_LeaderSword"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription7.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription7.leaderType = Entities["PU_LeaderBow"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types >= 3 then
			troopDescription7.maxNumberOfSoldiers = 3 - math.floor(2/p5_troop_level)
			troopDescription7.leaderType = Entities["PU_LeaderCavalry"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types == 4 then
			troopDescription7.maxNumberOfSoldiers = 0
			troopDescription7.leaderType = Entities.PV_Cannon3
		end
		EnlargeArmy(armyP5[_num],troopDescription7)
	end
	if p5_troop_slots >= 8 then
		local troopDescription8 = {}
		troopDescription8.maxNumberOfSoldiers = (p5_troop_level*4)-4
		troopDescription8.minNumberOfSoldiers = 0
		troopDescription8.experiencePoints = 0
		if p5_troop_types == 1 then
			troopDescription8.leaderType = Entities["PU_LeaderPoleArm"..p5_troop_level]
		elseif p5_troop_types == 2 then
			troopDescription8.maxNumberOfSoldiers = (p5_troop_level*2)-2
			troopDescription8.leaderType = Entities["PU_LeaderRifle"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types >= 3 then
			troopDescription8.maxNumberOfSoldiers = 3 - math.floor(2/p5_troop_level)
			troopDescription8.leaderType = Entities["PU_LeaderHeavyCavalry"..math.ceil(p5_troop_level/2)]
		elseif p5_troop_types == 4 then
			troopDescription8.maxNumberOfSoldiers = 0
			troopDescription8.leaderType = Entities.PV_Cannon3
		end
		EnlargeArmy(armyP5[_num],troopDescription8)
	end
	Redeploy(armyP5[_num], GetPosition("def_pos".._num), 5000 + round(Logic.GetTime()))
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmiesP5",1,{},{_num})
end
function ControlArmiesP5(_num)
	if IsDead(armyP5[_num]) then
		Redeploy(armyP5[_num], GetPosition("p5_spawn"), 2000)
		P5_Troops(_num)
		return true
	else
		Defend(armyP5[_num])
	end
end

function NV_Attack()
	for i = 1,4 do
		CreateNVArmy(i)
	end
end
function CreateNVArmy(_num)
	if not armyNV then
		armyNV = {}
	end
	armyNV[_num]		= {}
    armyNV[_num].player = 8
    armyNV[_num].id	  	= 12 + _num
    armyNV[_num].strength = math.min(1 + Logic.GetTime()/(600*gvDiffLVL), round(15/gvDiffLVL))
    armyNV[_num].position = GetPosition("nv_spawn".._num)
    armyNV[_num].rodeLength = Logic.WorldGetSize()
	SetupArmy(armyNV[_num])

	if armyNV[_num].strength < 4 then
		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1

		for i = 1, armyNV[_num].strength do
			EnlargeArmy(armyNV[_num],troopDescription)
		end
	else
		local troopDescription = {}
		troopDescription.maxNumberOfSoldiers = 16
		troopDescription.minNumberOfSoldiers = 0
		troopDescription.experiencePoints = HIGH_EXPERIENCE
		troopDescription.leaderType = Entities.CU_Evil_LeaderBearman1
		local troopDescription2 = {}
		troopDescription2.maxNumberOfSoldiers = 16
		troopDescription2.minNumberOfSoldiers = 0
		troopDescription2.experiencePoints = HIGH_EXPERIENCE
		troopDescription2.leaderType = Entities.CU_Evil_LeaderSkirmisher1
		for i = 1, math.ceil(armyNV[_num].strength/2) do
			EnlargeArmy(armyNV[_num],troopDescription)
		end
		for i = 1, math.floor(armyNV[_num].strength/2) do
			EnlargeArmy(armyNV[_num],troopDescription2)
		end
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmiesNV",1,{},{_num})

end
function ControlArmiesNV(_num)

    if IsDead(armyNV[_num]) then
        StartCountdown(5*60*gvDiffLVL, CreateNVArmy, false, nil, _num)
		return true
    else
		Defend(armyNV[_num])
    end
end
----------------------------------------------------------------------------
function CreateArmyP8_1()

	armyP8_1			= {}
    armyP8_1.player 	= 8
    armyP8_1.id 		= 0
    armyP8_1.strength	= 8
    armyP8_1.position	= GetPosition("p8_spawn1")
    armyP8_1.rodeLength = 10000
	SetupArmy(armyP8_1)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_1,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_1,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_1")

end

function ControlArmyP8_1()

    if IsDead(armyP8_1) and IsExisting("p8_tower1") then
        CreateArmyP8_1()
        return true
    else
		Defend(armyP8_1)
    end
end
function CreateArmyP8_2()

	armyP8_2			= {}
    armyP8_2.player 	= 8
    armyP8_2.id 		= 1
    armyP8_2.strength	= 8
    armyP8_2.position	= GetPosition("p8_spawn2")
    armyP8_2.rodeLength = 10000
	SetupArmy(armyP8_2)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_2,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_2,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_2")

end

function ControlArmyP8_2()

    if IsDead(armyP8_2) and IsExisting("p8_tower2") then
        CreateArmyP8_2()
        return true
    else
		Defend(armyP8_2)
    end
end
function CreateArmyP8_3()

	armyP8_3			= {}
    armyP8_3.player 	= 8
    armyP8_3.id			= 2
    armyP8_3.strength	= 8
    armyP8_3.position	= GetPosition("p8_spawn3")
    armyP8_3.rodeLength = 7500
	SetupArmy(armyP8_3)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_3,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_3,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_3")

end

function ControlArmyP8_3()

    if IsDead(armyP8_3) and IsExisting("p8_tower3") then
        CreateArmyP8_3()
        return true
    else
		Defend(armyP8_3)
    end
end
function CreateArmyP8_4()

	armyP8_4			= {}
    armyP8_4.player 	= 8
    armyP8_4.id 		= 3
    armyP8_4.strength 	= 12
    armyP8_4.position 	= GetPosition("p8_spawn4")
    armyP8_4.rodeLength = 5000
	SetupArmy(armyP8_4)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,5,1 do
	    EnlargeArmy(armyP8_4,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,7,1 do
	    EnlargeArmy(armyP8_4,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_4")

end

function ControlArmyP8_4()

    if IsDead(armyP8_4) and IsExisting("p8_tower4") then
        CreateArmyP8_4()
        return true
    else
		Defend(armyP8_4)
    end
end
function CreateArmyP8_5()

	armyP8_5			= {}
    armyP8_5.player 	= 8
    armyP8_5.id 		= 4
    armyP8_5.strength 	= 8
    armyP8_5.position 	= GetPosition("p8_spawn5")
    armyP8_5.rodeLength = 9000
	SetupArmy(armyP8_5)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_5,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_5,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_5")

end

function ControlArmyP8_5()

    if IsDead(armyP8_5) and IsExisting("p8_tower5") then
        CreateArmyP8_5()
        return true
    else
		Defend(armyP8_5)
    end
end
function CreateArmyP8_6()

	armyP8_6			= {}
    armyP8_6.player 	= 8
    armyP8_6.id 		= 5
    armyP8_6.strength 	= 8
    armyP8_6.position 	= GetPosition("p8_spawn6")
    armyP8_6.rodeLength = 6500
	SetupArmy(armyP8_6)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_6,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_6,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_6")

end

function ControlArmyP8_6()

    if IsDead(armyP8_6) and IsExisting("p8_tower6") then
        CreateArmyP8_6()
        return true
    else
		Defend(armyP8_6)
    end
end
function CreateArmyP8_7()

	armyP8_7			= {}
    armyP8_7.player 	= 8
    armyP8_7.id 		= 6
    armyP8_7.strength 	= 8
    armyP8_7.position 	= GetPosition("p8_spawn7")
    armyP8_7.rodeLength = 5200
	SetupArmy(armyP8_7)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_7,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_7,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_7")

end

function ControlArmyP8_7()

    if IsDead(armyP8_7) and IsExisting("p8_tower7") then
        CreateArmyP8_7()
        return true
    else
		Defend(armyP8_7)
    end
end
function CreateArmyP8_8()

	armyP8_8			= {}
    armyP8_8.player 	= 8
    armyP8_8.id 		= 7
    armyP8_8.strength 	= 8
    armyP8_8.position 	= GetPosition("p8_spawn8")
    armyP8_8.rodeLength = 9000
	SetupArmy(armyP8_8)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_8,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_8,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_8")

end

function ControlArmyP8_8()

    if IsDead(armyP8_8) and IsExisting("p8_tower8") then
        CreateArmyP8_8()
        return true
    else
		Defend(armyP8_8)
    end
end
function CreateArmyP8_9()

	armyP8_9			= {}
    armyP8_9.player 	= 8
    armyP8_9.id 		= 8
    armyP8_9.strength 	= 8
    armyP8_9.position 	= GetPosition("p8_spawn9")
    armyP8_9.rodeLength = 5200
	SetupArmy(armyP8_9)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_9,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_9,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_9")

end

function ControlArmyP8_9()

    if IsDead(armyP8_9) and IsExisting("p8_tower9") then
        CreateArmyP8_9()
        return true
    else
		Defend(armyP8_9)
    end
end
function CreateArmyP8_10()

	armyP8_10			= {}
    armyP8_10.player 	= 8
    armyP8_10.id 		= 9
    armyP8_10.strength 	= 8
    armyP8_10.position 	= GetPosition("p8_spawn10")
    armyP8_10.rodeLength = 7000
	SetupArmy(armyP8_10)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_10,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_10,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_10")

end

function ControlArmyP8_10()

    if IsDead(armyP8_10) and IsExisting("p8_tower10") then
        CreateArmyP8_10()
        return true
    else
		Defend(armyP8_10)
    end
end

function CreateArmyP8_11()

	armyP8_11			= {}
    armyP8_11.player 	= 8
    armyP8_11.id 		= 10
    armyP8_11.strength 	= 8
    armyP8_11.position 	= GetPosition("p8_spawn11")
    armyP8_11.rodeLength = 10000
	SetupArmy(armyP8_11)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_11,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_11,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_11")

end

function ControlArmyP8_11()

    if IsDead(armyP8_11) and IsExisting("p8_tower11") then
        CreateArmyP8_11()
        return true
    else
		Defend(armyP8_11)
    end
end
function CreateArmyP8_12()

	armyP8_12			= {}
    armyP8_12.player 	= 8
    armyP8_12.id 		= 11
    armyP8_12.strength 	= 8
    armyP8_12.position 	= GetPosition("p8_spawn12")
    armyP8_12.rodeLength = 11000
	SetupArmy(armyP8_12)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_12,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_12,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_12")

end

function ControlArmyP8_12()

    if IsDead(armyP8_12) and IsExisting("p8_tower12") then
        CreateArmyP8_12()
        return true
    else
		Defend(armyP8_12)
    end
end
function CreateArmyP8_13()

	armyP8_13			= {}
    armyP8_13.player 	= 8
    armyP8_13.id 		= 12
    armyP8_13.strength 	= 8
    armyP8_13.position 	= GetPosition("p8_spawn13")
    armyP8_13.rodeLength = 11000
	SetupArmy(armyP8_13)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BanditLeaderSword1

    for i = 1,6,1 do
	    EnlargeArmy(armyP8_13,troopDescription)
	end

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BanditLeaderBow1

    for i = 1,2,1 do
	    EnlargeArmy(armyP8_13,troopDescription2)
	end

    StartSimpleJob("ControlArmyP8_13")

end

function ControlArmyP8_13()

    if IsDead(armyP8_13) and IsExisting("p8_tower13") then
        CreateArmyP8_13()
        return true
    else
		Defend(armyP8_13)
    end
end