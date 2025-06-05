function CreateArmies()
	SetHostile(1,2)
	SetHostile(8,2)
	RobbersTroopTypes = {Entities.CU_Barbarian_LeaderClub2, Entities.CU_BanditLeaderSword1,
		Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderMace2, Entities["PU_LeaderSword" .. 5 - gvDiffLVL],
		Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities.CU_BlackKnight_LeaderSword3, Entities.PV_Cannon1, Entities.PV_Cannon3}
	if gvDiffLVL < 2 then
		table.insert(RobbersTroopTypes, Entities.CU_VeteranMajor)
		table.insert(RobbersTroopTypes, Entities.CU_VeteranCaptain)
		table.insert(KerbTroopTypes, Entities.CU_VeteranLieutenant)
		table.insert(RobbersTroopTypes, Entities.PV_Cannon5)
	end

	ArmyData = {[2] = {{id = 0, position = GetPosition("BanditSpawn1"), building = GetID("tower1"),
		troops = {}, rodeLength = 3100, strength = round(7-gvDiffLVL)},
		{id = 1, position = GetPosition("BanditSpawn2"), building = GetID("tower2"),
		troops = {}, rodeLength = 5200, strength = round(8-gvDiffLVL)},
		{id = 2, position = GetPosition("BanditSpawn3"), building = GetID("tower3"),
		troops = {}, rodeLength = 6200, strength = round(12-(2*gvDiffLVL))},
		{id = 3, position = GetPosition("BanditSpawn4"), building = GetID("tower4"),
		troops = {}, rodeLength = 5400, strength = round(10-(1.5*gvDiffLVL))},
		{id = 4, position = GetPosition("BanditSpawn5"), building = GetID("tower5"),
		troops = {}, rodeLength = 4500, strength = round(8-gvDiffLVL)},
		{id = 5, position = GetPosition("BanditSpawn6"), building = GetID("tower6"),
		troops = {}, rodeLength = 3300, strength = round(12-(2.5*gvDiffLVL))},
		{id = 6, position = GetPosition("start_army1"), building = nil,
		troops = {}, rodeLength = Logic.WorldGetSize(), strength = round(9-(2*gvDiffLVL))},
		{id = 7, position = GetPosition("start_army2"), building = nil,
		troops = {}, rodeLength = Logic.WorldGetSize(), strength = round(6-(1.5*gvDiffLVL))},
		{id = 8, position = GetPosition("start_army3"), building = nil,
		troops = {}, rodeLength = Logic.WorldGetSize(), strength = round(6-(1.5*gvDiffLVL))},
		{id = 9, position = GetPosition("start_army4"), building = nil,
		troops = {}, rodeLength = Logic.WorldGetSize(), strength = round(6-(1.5*gvDiffLVL))}}
	}
	LarinaAttackArmyIDs = {6,7,8,9}
	--
	RobbersQuestArmyIDs = {{0,1,2}, {3,4,5}}
	for player, data in pairs(ArmyData) do
		for i = 1, table.getn(data) do
			local army = {}
			army.player = player
			army.id	= data[i].id
			army.position = data[i].position
			army.rodeLength	= data[i].rodeLength
			army.strength = round(data[i].strength * (1.5/gvDiffLVL))
			army.building = data[i].building
			SetupArmy(army)
			RefreshArmy(army.player, army.id, army.building)
		end
	end
end
function RefreshArmy(_player, _id, _building)
	local army = ArmyTable[_player][_id + 1]
	local trooptypes = RobbersTroopTypes
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = trooptypes[math.random(table.getn(trooptypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlArmies",1,{},{_player, _id, _building})
end
function ControlArmies(_player, _id, _hq)
	local army = ArmyTable[_player][_id + 1]
	if not IsExisting(_hq) then
		if IsDead(army) then
			return true
		end
	else
		if IsVeryWeak(army) and IsExisting(_hq) then
			if Counter.Tick2("ArmyDead_" .. _player .. "_" .. _id, round(60*gvDiffLVL)) then
				RefreshArmy(_player, _id, _hq)
				return true
			end
		end
	end
	Defend(army)
end