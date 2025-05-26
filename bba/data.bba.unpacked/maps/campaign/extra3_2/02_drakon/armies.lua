function CreateArmies()
	CreateArmyP2_1()
	CreateArmyP2_2()
	CreateArmyP2_3()
	CreateArmyP3_1()
	CreateArmyP3_2()
	CreateArmyP4_1()
	CreateArmyP4_2()
	CreateArmyP4_3()
	CreateArmyP5()
	CreateArmyP6()
	CreateArmyP7()
	CreateArmyP8_1()
	CreateArmyP8_2()
	--
	local army = {}
	army.player = 2
	army.id = GetFirstFreeArmySlot(2)
	army.position = GetPosition("Kerberos")
	army.strength = round(5/gvDiffLVL)
	army.rodeLength = 6000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_BlackKnight_LeaderMace2})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--**
	local army = {}
	army.player = 3
	army.id = GetFirstFreeArmySlot(3)
	army.position = GetPosition("Varg")
	army.strength = round(7/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_Barbarian_LeaderClub2})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--**
	local MaryArmyTypes = {Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities["PU_LeaderSword" .. 5 - gvDiffLVL], Entities["PU_LeaderPoleArm" .. 5 - gvDiffLVL],
		Entities["PU_LeaderRifle" .. math.max(3 - gvDiffLVL, 1)], Entities["PV_Cannon" .. 7 - (2*gvDiffLVL)]}
	local army = {}
	army.player = 4
	army.id = GetFirstFreeArmySlot(4)
	army.position = GetPosition("Mary")
	army.strength = round(7/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = MaryArmyTypes[math.random(table.getn(MaryArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,nil,{army.player, army.id})
	--**
	--**
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("Drakon"),"Drakona")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonTor"),"Drakonb")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonA"),"Drakonc")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonB"),"Drakond")
	CreateMilitaryGroup(8,Entities.PU_LeaderSword4,12,GetPosition("DrakonHaupt"),"Drakone")
	CreateMilitaryGroup(8,Entities.PU_LeaderPoleArm4,12,GetPosition("DrakonDef"),"Drakonf")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonC"),"Drakong")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonD"),"Drakonh")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonNord"),"Drakoni")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonExtra"),"Drakonj")
	CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("DrakonExtra"),"Drakonk")
	CreateMilitaryGroup(8,Entities.PU_LeaderRifle2,6,GetPosition("DrakonE"),"Truppen")
end
function CreateArmyP2_1()

	armyP2_1	= {}
    armyP2_1.player 	= 2
    armyP2_1.id = 1
    armyP2_1.strength = math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP2_1.position = GetPosition("Kerberos")
    armyP2_1.rodeLength = 7000
	SetupArmy(armyP2_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4

    for i = 1,armyP2_1.strength do
	    EnlargeArmy(armyP2_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP2_1")

end

function ControlArmyP2_1()

    if IsVeryWeak(armyP2_1) and IsExisting("KerberosBurg") and IsExisting("KerBurg") then
		if Counter.Tick2("ControlArmyP2_1_Counter", 45 * gvDiffLVL) then
			CreateArmyP2_1()
			return true
		end
    end
    Advance(armyP2_1)
end
function CreateArmyP2_2()

	armyP2_2			= {}
    armyP2_2.player 	= 2
    armyP2_2.id 		= 2
    armyP2_2.strength 	= math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP2_2.position 	= GetPosition("Kerberos")
    armyP2_2.rodeLength = 7000
	SetupArmy(armyP2_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderPoleArm4

    for i = 1,armyP2_2.strength do
	    EnlargeArmy(armyP2_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP2_2")

end

function ControlArmyP2_2()

    if IsVeryWeak(armyP2_2) and IsExisting("KerberosBurg") and IsExisting("KerBurg") then
		if Counter.Tick2("ControlArmyP2_2_Counter", 45 * gvDiffLVL) then
			CreateArmyP2_2()
			return true
		end
    end
    Advance(armyP2_2)
end
function CreateArmyP2_3()

	armyP2_3			= {}
    armyP2_3.player 	= 2
    armyP2_3.id 		= 3
    armyP2_3.strength 	= math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP2_3.position 	= GetPosition("Kerberos")
    armyP2_3.rodeLength = 7000
	SetupArmy(armyP2_3)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1,armyP2_3.strength do
	    EnlargeArmy(armyP2_3,troopDescription)
	end

    StartSimpleJob("ControlArmyP2_3")

end

function ControlArmyP2_3()

    if IsVeryWeak(armyP2_3) and IsExisting("KerberosBurg") and IsExisting("KerBurg") then
		if Counter.Tick2("ControlArmyP2_3_Counter", 45 * gvDiffLVL) then
			CreateArmyP2_3()
			return true
		end
    end
    Advance(armyP2_3)
end
function CreateArmyP3_1()

	armyP3_1			= {}
    armyP3_1.player 	= 3
    armyP3_1.id 		= GetFirstFreeArmySlot(3)
    armyP3_1.strength 	= math.min(round(2 + (Logic.GetTime()/(gvDiffLVL*500))), round(14/gvDiffLVL))
    armyP3_1.position 	= GetPosition("Varg")
    armyP3_1.rodeLength = 5000
	SetupArmy(armyP3_1)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1, armyP3_1.strength do
	    EnlargeArmy(armyP3_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_1")

end

function ControlArmyP3_1()

    if IsVeryWeak(armyP3_1) and IsExisting("VargBurg") then
		if Counter.Tick2("ControlArmyP3_1_Counter", 60 * gvDiffLVL) then
			CreateArmyP3_1()
			return true
		end
    end
    Advance(armyP3_1)
end
function CreateArmyP3_2()

	armyP3_2			= {}
    armyP3_2.player 	= 3
    armyP3_2.id 		= GetFirstFreeArmySlot(3)
    armyP3_2.strength	= math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP3_2.position 	= GetPosition("Varg")
    armyP3_2.rodeLength = 5000
	SetupArmy(armyP3_2)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderCavalry" .. math.max(3 - gvDiffLVL,1)]

    for i = 1,armyP3_2.strength do
	    EnlargeArmy(armyP3_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP3_2")

end

function ControlArmyP3_2()

    if IsVeryWeak(armyP3_2) and IsExisting("VargBurg") then
		if Counter.Tick2("ControlArmyP3_2_Counter", 60 * gvDiffLVL) then
			CreateArmyP3_2()
			return true
		end
    end
    Advance(armyP3_2)
end
function CreateArmyP4_1()

	armyP4_1	= {}
    armyP4_1.player 	= 4
    armyP4_1.id = 1
    armyP4_1.strength = math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP4_1.position = GetPosition("Mary")
    armyP4_1.rodeLength = 4000
	SetupArmy(armyP4_1)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderRifle" .. math.max(3 - gvDiffLVL, 1)]

    for i = 1,armyP4_1.strength do
	    EnlargeArmy(armyP4_1,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_1")

end

function ControlArmyP4_1()

    if IsVeryWeak(armyP4_1) and IsExisting("MaryBurg") then
		if Counter.Tick2("ControlArmyP4_1_Counter", 50 * gvDiffLVL) then
			CreateArmyP4_1()
			return true
		end
	end
    Advance(armyP4_1)
end
function CreateArmyP4_2()

	armyP4_2	= {}
    armyP4_2.player 	= 4
    armyP4_2.id = 2
    armyP4_2.strength = math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP4_2.position = GetPosition("Mary")
    armyP4_2.rodeLength = 4500
	SetupArmy(armyP4_2)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PU_LeaderBow" .. math.max(5 - gvDiffLVL,3)]

    for i = 1,armyP4_2.strength do
	    EnlargeArmy(armyP4_2,troopDescription)
	end

    StartSimpleJob("ControlArmyP4_2")

end
function ControlArmyP4_2()

    if IsVeryWeak(armyP4_2) and IsExisting("MaryBurg") then
		if Counter.Tick2("ControlArmyP4_2_Counter", 50 * gvDiffLVL) then
			CreateArmyP4_2()
			return true
		end
    end
    Advance(armyP4_2)
end
function CreateArmyP4_3()

	armyP4_3	= {}
    armyP4_3.player 	= 4
    armyP4_3.id = 3
    armyP4_3.strength = math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*600))), round(12/gvDiffLVL))
    armyP4_3.position = GetPosition("Mary")
    armyP4_3.rodeLength = 4500
	SetupArmy(armyP4_3)

	for i = 1, armyP4_3.strength do
		EnlargeArmy(armyP4_3, {leaderType = Entities["PV_Cannon" .. math.random(1,5)]})
	end
    StartSimpleJob("ControlArmyP4_3")

end
function ControlArmyP4_3()
	if IsVeryWeak(armyP4_3) and IsExisting("MaryBurg") then
		if Counter.Tick2("ControlArmyP4_3_Counter", 50 * gvDiffLVL) then
			CreateArmyP4_3()
			return true
		end
	end
    Advance(armyP4_3)
end
function CreateArmyP5()

	armyP5	= {}
    armyP5.player 	= 5
    armyP5.id = 0
    armyP5.strength = math.min(round(2 + (Logic.GetTime()/(gvDiffLVL*500))), round(14/gvDiffLVL))
    armyP5.position = GetPosition("BanditSpawn")
    armyP5.rodeLength = 4000
	SetupArmy(armyP5)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1,armyP5.strength,1 do
	    EnlargeArmy(armyP5,troopDescription)
	end

    StartSimpleJob("ControlArmyP5")

end

function ControlArmyP5()

    if IsVeryWeak(armyP5) and IsExisting("BanditTower") then
		if Counter.Tick2("ControlArmyP5_Counter", 60 * gvDiffLVL) then
			CreateArmyP5()
			return true
		end
	end
    Advance(armyP5)
end
function CreateArmyP6()

	armyP6	= {}
    armyP6.player 	= 6
    armyP6.id = 0
    armyP6.strength = math.min(round(1 + (Logic.GetTime()/(gvDiffLVL*800))), round(10/gvDiffLVL))
    armyP6.position = GetPosition("spawnP6")
    armyP6.rodeLength = 4000
	SetupArmy(armyP6)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 2
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow3

    for i = 1,armyP6.strength,1 do
	    EnlargeArmy(armyP6,troopDescription)
	end

    StartSimpleJob("ControlArmyP6")

end

function ControlArmyP6()

    if IsVeryWeak(armyP6) and IsExisting("towerP6") then
		if Counter.Tick2("ControlArmyP6_Counter", 60 * gvDiffLVL) then
			CreateArmyP6()
			return true
		end
	end
    Advance(armyP6)
end

function CreateArmyP7()

	armyP7	= {}
    armyP7.player 	= 7
    armyP7.id = 0
    armyP7.strength = math.min(round(2 + (Logic.GetTime()/(gvDiffLVL*500))), round(14/gvDiffLVL))
    armyP7.position = GetPosition("SpawnP7")
    armyP7.rodeLength = 5000
	SetupArmy(armyP7)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2

    for i = 1,armyP7.strength,1 do
	    EnlargeArmy(armyP7,troopDescription)
	end

    StartSimpleJob("ControlArmyP7")

end

function ControlArmyP7()

    if IsVeryWeak(armyP7) and IsExisting("TowerP7") then
		if Counter.Tick2("ControlArmyP7_Counter", 60 * gvDiffLVL) then
			CreateArmyP7()
			return true
		end
    end
    Advance(armyP7)
end
function CreateArmyP8_1()

	armyP8_1	= {}
    armyP8_1.player 	= 8
    armyP8_1.id = 0
    armyP8_1.strength = 2 + (2*gvDiffLVL)
    armyP8_1.position = GetPosition("RE")
    armyP8_1.rodeLength = 3200
	SetupArmy(armyP8_1)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4

    for i = 1,armyP8_1.strength do
	    EnlargeArmy(armyP8_1,troopDescription)
	end
	Redeploy(armyP8_1,GetPosition("DrakonE"))
    StartSimpleJob("ControlArmyP8_1")

end

function ControlArmyP8_1()

    if IsVeryWeak(armyP8_1) then
		if Counter.Tick2("ControlArmyP8_1_Counter", round(80 / gvDiffLVL)) then
			CreateArmyP8_1()
			return true
		end
    end
	Defend(armyP8_1)
end
function CreateArmyP8_2()

	armyP8_2	= {}
    armyP8_2.player 	= 8
    armyP8_2.id = 1
    armyP8_2.strength = 2 + (2*gvDiffLVL)
    armyP8_2.position = GetPosition("RE")
    armyP8_2.rodeLength = 3200
	SetupArmy(armyP8_2)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow3

    for i = 1,armyP8_2.strength do
	    EnlargeArmy(armyP8_2,troopDescription)
	end
	Redeploy(armyP8_2,GetPosition("DrakonDef"))
    StartSimpleJob("ControlArmyP8_2")

end

function ControlArmyP8_2()

    if IsVeryWeak(armyP8_2) then
		if Counter.Tick2("ControlArmyP8_2_Counter", round(70 / gvDiffLVL)) then
			CreateArmyP8_2()
			return true
		end
	end
	Defend(armyP8_2)
end
function Re()
	if IsDestroyed("Truppen") then
		CreateMilitaryGroup(8,Entities.PU_LeaderRifle2,6,GetPosition("RE"),"Truppen")
		Attack("Truppen","DrakonE")
	end

	if IsDestroyed("Drakona") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakona")
		Attack("Drakona","Drakon")
	end

	if IsDestroyed("Drakonb") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakonb")
		Attack("Drakonb","DrakonTor")
	end

	if IsDestroyed("Drakonc") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakonc")
		Attack("Drakonc","DrakonA")
	end

	if IsDestroyed("Drakond") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakond")
		Attack("Drakond","DrakonB")
	end

	if IsDestroyed("Drakone") then
		CreateMilitaryGroup(8,Entities.PU_LeaderSword4,12,GetPosition("RE"),"Drakone")
		Attack("Drakone","DrakonHaupt")
	end

	if IsDestroyed("Drakonf") then
		CreateMilitaryGroup(8,Entities.PU_LeaderPoleArm4,12,GetPosition("RE"),"Drakonf")
		Attack("Drakonf","DrakonDef")
	end

	if IsDestroyed("Drakong") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakong")
		Attack("Drakong","DrakonC")
	end

	if IsDestroyed("Drakonh") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakonh")
		Attack("Drakonh","DrakonD")
	end

	if IsDestroyed("Drakoni") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakoni")
		Attack("Drakoni","DrakonNord")
	end

	if IsDestroyed("Drakonj") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakonj")
		Attack("Drakonj","DrakonExtra")
	end

	if IsDestroyed("Drakonk") then
		CreateMilitaryGroup(8,Entities.PU_LeaderBow4,12,GetPosition("RE"),"Drakonk")
		Attack("Drakonk","DrakonExtra")
	end
end
function AttachNoArmyDefendersToNewArmy()
	EndJob(NoArmyRespawnJob)
	P8NoArmyIDs = {GetID("Truppen"),
		GetID("Drakona"),
		GetID("Drakonb"),
		GetID("Drakonc"),
		GetID("Drakond"),
		GetID("Drakone"),
		GetID("Drakonf"),
		GetID("Drakong"),
		GetID("Drakonh"),
		GetID("Drakoni"),
		GetID("Drakonj"),
		GetID("Drakonk")
	}
	local army 			= {}
	army.player 		= 8
	army.id 			= GetFirstFreeArmySlot(8)
	army.position		= GetPosition("RE")
	army.rodeLength 	= Logic.WorldGetSize()
	army.strength		= 12
	army.building		= GetID("DrakonBurg")
	army.respawnDelay 	= round(90/gvDiffLVL)
	army.types 			= {}
	for i = 1, table.getn(P8NoArmyIDs) do
		army.types[i] = Logic.GetEntityType(P8NoArmyIDs[i])
	end
	SetupArmy(army)
	--
	for i = 1, table.getn(P8NoArmyIDs) do
		ConnectLeaderWithArmy(P8NoArmyIDs[i], army)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, army.respawnDelay, unpack(army.types)})
end
function ControlRespawningArmies(_player, _id, _building, _behaviortype, _delay, ...)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsDestroyed(_building) then
		return true
	end
	if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("RespawnArmy_" .. _player .. "_" .. _id .. "_" .. _building .. "_Counter", _delay) then
			local trooptypes = {}
			for i = 1, arg.n do
				trooptypes[i] = arg[i]
			end
			for i = 1, army.strength do
				EnlargeArmy(army, {leaderType = trooptypes[math.random(table.getn(trooptypes))]})
			end
		end
	end
	if _behaviortype == 0 then
		Defend(army)
	elseif _behaviortype == 1 then
		if sub_armies_aggressive ~= 0 then
			Advance(army)
		else
			Defend(army)
		end
	elseif _behaviortype == 3 then
		if main_armies_aggressive ~= 0 then
			Advance(army)
		else
			Defend(army)
		end
	else
		Defend(army)
	end
end