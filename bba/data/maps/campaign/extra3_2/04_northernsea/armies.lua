function CreateArmies()
	CreateArmyP6_0()
	CreateArmyP6_1()
	CreateArmyP6_2()
	CreateArmyP6_3()
	CreateArmyP6_4()
	CreateArmyP6_5()
	CreateArmyP6_6()
	CreateArmyP6_7()
	CreateArmyP6_8()
	CreateArmyP7_0()
	CreateArmyP7_1()
	CreateArmyP7_2()
	CreateArmyP7_3()
	CreateArmyP7_4()
	CreateArmyP7_5()
	CreateArmyP7_6()
	CreateArmyP7_7()
	--
	for i = 1,8 do
		local id
		CreateMilitaryGroup(6,Entities.PU_LeaderBow4,12,GetPosition("p6_bows" .. i), "p6_def_bow" .. i)
		Logic.GroupStand(GetID("p6_def_bow" .. i))
	end
	StartCamps()
end
CampTroopTypes = {Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities["PU_LeaderBow" .. 4 - gvDiffLVL], Entities["PU_LeaderSword" .. 5- gvDiffLVL], Entities["PU_LeaderSword" .. 4- gvDiffLVL],
	Entities.CU_BanditLeaderSword2, Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderMace2, Entities.CU_BlackKnight_LeaderSword3}
function StartCamps()
	local army = {}
	army.player = 3
	army.id = 1
	army.strength = 11 - round(3*gvDiffLVL)
	army.position = GetPosition("camp1")
	army.rodeLength = 4200 - round(200*gvDiffLVL)
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = CampTroopTypes[math.random(table.getn(CampTroopTypes))]})
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlCampArmies",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 3
	army.id = 2
	army.strength = 12 - round(3*gvDiffLVL)
	army.position = GetPosition("camp2")
	army.rodeLength = 4200 - (200*gvDiffLVL)
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = CampTroopTypes[math.random(table.getn(CampTroopTypes))]})
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlCampArmies",1,{},{army.player, army.id})
end
function ControlCampArmies(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		for i = 1, 8 do
			StartCountdown(60, DestroyEntity("camp" .. _id .. "_" .. i), false)
		end
		return true
	else
		Defend(army)
	end
end
function ControlRespawningArmies(_player, _id, _building, _behaviortype, ...)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) and IsDestroyed(_building) then
		return true
	end
	if IsVeryWeak(army) and IsExisting(_building) then
		if Counter.Tick2("RespawnArmy_" .. _player .. "_" .. _id .. "_" .. _building .. "_Counter", round(45 * gvDiffLVL)) then
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
function IncreaseP2Range()
	MapEditor_Armies[2].offensiveArmies.rodeLength = Logic.WorldGetSize()
	MapEditor_Armies[2].offensiveArmies.baseDefenseRange = Logic.WorldGetSize()/3
	MapEditor_Armies[5].offensiveArmies.rodeLength = Logic.WorldGetSize()
end
function CreateArmyP6_0()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn1")
    army.rodeLength = 2500
	army.building	= GetID("BanditTower1")
	army.trooptypes	= {Entities.CU_Barbarian_LeaderClub2}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,army.strength,1 do
	    EnlargeArmy(army,troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 1, unpack(army.trooptypes)})
end

function CreateArmyP6_1()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn2")
    army.rodeLength = 5000
	army.building 	= GetID("BanditTower2")
	army.trooptypes	= {Entities.PU_LeaderSword3}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword3

    for i = 1,army.strength,1 do
	    EnlargeArmy(army,troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP6_2()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn2")
    army.rodeLength = 5000
	army.building	= GetID("BanditTower2")
	army.trooptypes = {Entities.PU_LeaderBow4, Entities.PU_LeaderRifle2}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderRifle2
    for i = 1,(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
		EnlargeArmy(army,troopDescription2)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP6_3()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(5-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn3")
    army.rodeLength = 4200
	army.building	= GetID("BanditTower3")
	army.trooptypes = {Entities.CU_Barbarian_LeaderClub2}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_Barbarian_LeaderClub2

    for i = 1,army.strength,1 do
	    EnlargeArmy(army,troopDescription)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 1, unpack(army.trooptypes)})
end

function CreateArmyP6_4()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn4")
    army.rodeLength = 6000
	army.building 	= GetID("BanditTower4")
	army.trooptypes = {Entities.PU_LeaderCavalry2, Entities.PU_LeaderHeavyCavalry2}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2

	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderHeavyCavalry2

    for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(army,troopDescription2)
	end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP6_5()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn5")
    army.rodeLength = 6000
	army.building 	= GetID("BanditTower5")
	army.trooptypes = {Entities.PU_LeaderPoleArm4, Entities.PU_LeaderPoleArm3}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm3
    for i = 1,3,1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription2)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP6_6()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("Eisenspawn")
    army.rodeLength = 4000
	army.building 	= GetID("Eisenmine")
	army.trooptypes = {Entities.PU_LeaderBow3, Entities.PU_LeaderBow4}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderBow3

    for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(army,troopDescription2)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP6_7()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn6")
    army.rodeLength = 13000
	army.building 	= GetID("BanditTower6")
	army.trooptypes = {Entities.PU_LeaderRifle2, Entities.PU_LeaderBow4}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderBow4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderRifle2

    for i = 1,round(5-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription2)
	end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP6_8()

	local army		= {}
    army.player 	= 6
    army.id 		= GetFirstFreeArmySlot(6)
    army.strength 	= round(8-gvDiffLVL)
    army.position 	= GetPosition("BanditSpawn7")
    army.rodeLength = 12000
	army.building 	= GetID("BanditTower7")
	army.trooptypes = {Entities.PU_LeaderSword4, Entities.PU_LeaderPoleArm4, Entities.CU_Barbarian_LeaderClub2}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 6
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 8
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.CU_Barbarian_LeaderClub2
    for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription2)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription3)
	end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP7_0()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("KerberosSpawn3")
    army.rodeLength = 12500
	army.building 	= GetID("KerberosTower3")
	army.trooptypes = {Entities.CU_BlackKnight_LeaderMace2, Entities.CU_BlackKnight_LeaderSword3}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 4
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace2
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 8
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderSword3
    for i = 1,round(5-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	EnlargeArmy(army,troopDescription2)
	--
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 1, unpack(army.trooptypes)})
end

function CreateArmyP7_1()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("KerberosSpawn2")
    army.rodeLength = 15500
	army.building 	= GetID("KerberosTower2")
	army.trooptypes = {Entities.CU_BlackKnight_LeaderSword3, Entities.PU_LeaderSword4}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 8
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderSword3
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderSword4
    for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,3,1 do
	    EnlargeArmy(army,troopDescription2)
	end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP7_2()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength	= round(7-gvDiffLVL)
    army.position	= GetPosition("KerberosSpawn1")
    army.rodeLength = 7200
	army.building 	= GetID("KerberosTower1")
	army.trooptypes = {Entities.PU_LeaderCavalry2, Entities.PU_LeaderHeavyCavalry2, Entities.CU_VeteranMajor}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 6
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderCavalry2
	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderHeavyCavalry2
	local troopDescription3 = {}
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.CU_VeteranMajor
    for i = 1,round(5-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription2)
	end
	EnlargeArmy(army,troopDescription3)

    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP7_3()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(8-gvDiffLVL)
    army.position 	= GetPosition("KerberosBaseSpawn")
    army.rodeLength = 12500
	army.building 	= GetID("KerberosHQ1")
	army.trooptypes = {Entities.PU_LeaderSword4, Entities.PU_LeaderPoleArm4, Entities.PU_LeaderBow4}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.maxNumberOfSoldiers = 12
	troopDescription.minNumberOfSoldiers = 0
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderSword4
	local troopDescription2 = {}
	troopDescription2.maxNumberOfSoldiers = 12
	troopDescription2.minNumberOfSoldiers = 0
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.PU_LeaderPoleArm4
	local troopDescription3 = {}
	troopDescription3.maxNumberOfSoldiers = 12
	troopDescription3.minNumberOfSoldiers = 0
	troopDescription3.experiencePoints = HIGH_EXPERIENCE
	troopDescription3.leaderType = Entities.PU_LeaderBow4
    for i = 1,round(4-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription2)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription3)
	end
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP7_4()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("KerberosBaseSpawn")
    army.rodeLength = 11500
	army.building 	= GetID("KerberosHQ2")
	army.trooptypes = {Entities.PV_Cannon3}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PV_Cannon3
    for i = 1,army.strength,1 do
		EnlargeArmy(army, troopDescription)
	end
	--
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP7_5()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(5-gvDiffLVL)
    army.position 	= GetPosition("KerberosBaseSpawn")
    army.rodeLength = 4500
	army.building 	= GetID("KerberosHQ1")
	army.trooptypes = {Entities["PV_Cannon" .. 8 - (2*gvDiffLVL)]}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities["PV_Cannon" .. 8 - (2*gvDiffLVL)]
    for i = 1,army.strength,1 do
		EnlargeArmy(army, troopDescription)
	end
	--
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 2, unpack(army.trooptypes)})
end

function CreateArmyP7_6()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(7-gvDiffLVL)
    army.position 	= GetPosition("KerberosBaseSpawn")
    army.rodeLength = 14500
	army.building 	= GetID("KerberosHQ2")
	army.trooptypes = {Entities.PU_LeaderRifle2, Entities.CU_BlackKnight_LeaderSword3}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.PU_LeaderRifle2
	local troopDescription2 = {}
	troopDescription2.experiencePoints = HIGH_EXPERIENCE
	troopDescription2.leaderType = Entities.CU_BlackKnight_LeaderSword3
    for i = 1,round(5-gvDiffLVL),1 do
	    EnlargeArmy(army,troopDescription)
	end
	for i = 1,2,1 do
	    EnlargeArmy(army,troopDescription2)
	end
    --
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function CreateArmyP7_7()

	local army		= {}
    army.player 	= 7
    army.id 		= GetFirstFreeArmySlot(7)
    army.strength 	= round(6-gvDiffLVL)
    army.position 	= GetPosition("KerberosBaseSpawn")
    army.rodeLength = 11500
	army.building 	= GetID("KerberosHQ1")
	army.trooptypes = {Entities.CU_VeteranMajor}
	SetupArmy(army)

	local troopDescription = {}
	troopDescription.experiencePoints = HIGH_EXPERIENCE
	troopDescription.leaderType = Entities.CU_VeteranMajor

    for i = 1,army.strength,1 do
	    EnlargeArmy(army,troopDescription)
	end
    --
    Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmies",1,{},{army.player, army.id, army.building, 0, unpack(army.trooptypes)})
end

function Extra()
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Extra")
	army.strength = round(16/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_BanditLeaderSword2})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
end
function IronGuardArmy()
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Eisenspawn")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_VeteranLieutenant})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Eisenspawn2")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities.CU_Barbarian_LeaderClub2})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Eisenspawn3")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities["PU_LeaderBow" .. 5 - gvDiffLVL ]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
end
ChestSurpriseTroopTypes = {Entities.CU_VeteranLieutenant, Entities.CU_Barbarian_LeaderClub2}
function ChestSurprise(_player, _pos, _strength)
	local army = {}
	army.player = _player
	army.id = GetFirstFreeArmySlot(8)
	army.position = _pos
	army.strength = _strength
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = ChestSurpriseTroopTypes[math.random(table.getn(ChestSurpriseTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
end
function Attack_1()

	sub_armies_aggressive = 1
	StartCountdown(2,Attack_2_Vorb,false)
	StartWinter(5*60)
end
function Attack_2_Vorb()
	StartCountdown(math.floor(87*60*math.sqrt(gvDiffLVL)),Attack_2,true)
end
function Attack_2()

	main_armies_aggressive = 1
	if IsExisting("fireguard") then
		LighthouseSupply()
	end
	SnowyDays_Start()

	ForbidTechnology(Technologies.T_MakeSnow,1)
end
function SnowyDays_Start()
	StartWinter(10*60)
	StartCountdown(15*60,SnowyDays_Start,false)
end
function LighthouseSupplyVorb()
	StartCountdown(60*60*math.sqrt(gvDiffLVL),LighthouseSupply,true)
end
LighthouseTroopTypes = {Entities.PU_LeaderHeavyCavalry2, Entities.PU_LeaderSword4, Entities.CU_BlackKnight_LeaderSword3, Entities.CU_VeteranMajor, Entities.PU_LeaderBow4}
function LighthouseSupply()
	Message("Kerberos hat Verstärkungstruppen erhalten!")
	local army = {}
	army.player = 7
	army.id = GetFirstFreeArmySlot(7)
	army.strength = 18 - (3*gvDiffLVL)
	army.position = GetPosition("LighthouseSpawn")
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = LighthouseTroopTypes[math.random(table.getn(LighthouseTroopTypes))]})
	end

	if IsExisting("fireguard") then
		StartCountdown(2,LighthouseSupplyVorb,false)
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmies",1,{},{army.player, army.id})
end
function ControlGenericArmies(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end
function UpgradeKIa()
	for i = 2,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)
		ResearchTechnology(Technologies.T_BetterTrainingBarracks,i)
		ResearchTechnology(Technologies.T_BetterTrainingArchery,i)
		ResearchTechnology(Technologies.T_Shoeing,i)
		ResearchTechnology(Technologies.T_BetterChassis,i)
	end
	StartCountdown(90+(30*gvDiffLVL)*60,UpgradeKIb,false)
end
function UpgradeKIb()
	for i = 2,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry,i)

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
	StartCountdown(150+(30*gvDiffLVL)*60,UpgradeKIc,false)
end
function UpgradeKIc()
	for i = 2,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

		ResearchTechnology(Technologies.T_SilverSwords,i)
		ResearchTechnology(Technologies.T_SilverBullets,i)
		ResearchTechnology(Technologies.T_SilverMissiles,i)
		ResearchTechnology(Technologies.T_SilverPlateArmor,i)
		ResearchTechnology(Technologies.T_SilverArcherArmor,i)
		ResearchTechnology(Technologies.T_SilverArrows,i)
		ResearchTechnology(Technologies.T_SilverLance,i)
		ResearchTechnology(Technologies.T_BloodRush,i)
	end
end
function KerberosKI_Relocate()
	MapEditor_Armies[7].offensiveArmies.rodeLength = Logic.WorldGetSize()
end
function VargKI_Relocate()
	for i = 1, table.getn(ArmyTable[6]) do
		ArmyTable[6][i].rodeLength = Logic.WorldGetSize()
	end
end