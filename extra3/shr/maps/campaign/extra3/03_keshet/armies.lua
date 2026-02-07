function CreateArmies()
	AI.Player_EnableAi(7)
	--
	SetHostile(1,2)
	SetHostile(1,8)
	--
	RobbersTroopTypes = {Entities.CU_Barbarian_LeaderClub2, Entities.CU_BanditLeaderSword1,
		Entities.CU_BanditLeaderBow1, Entities.CU_BlackKnight_LeaderMace2, Entities["PU_LeaderSword" .. 5 - gvDiffLVL],
		Entities["PU_LeaderBow" .. 5 - gvDiffLVL], Entities.CU_BlackKnight_LeaderSword3, Entities.PV_Cannon1, Entities.PV_Cannon3}
	if gvDiffLVL < 2 then
		table.insert(RobbersTroopTypes, Entities.PV_Cannon5)
	end
	--
	NVTroopTypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSkirmisher1, Entities.CU_Evil_LeaderSpearman1}
	if gvDiffLVL < 2 then
		table.insert(NVTroopTypes, Entities.CU_Evil_LeaderCavalry1)
	elseif gvDiffLVL > 2 then
		table.insert(NVTroopTypes, Entities.CU_AggressiveScorpion1)
	end

	ArmyData = {
		[2] = {
			{id = 0, position = GetPosition("BanditSpawn1"), building = GetID("BanditTower1"),
			troops = {}, rodeLength = 5600, strength = round(7-gvDiffLVL)},
			{id = 1, position = GetPosition("BanditSpawn2"), building = GetID("BanditTower2"),
			troops = {}, rodeLength = 6600, strength = round(8-gvDiffLVL)},
			{id = 2, position = GetPosition("BanditSpawn3"), building = GetID("BanditTower3"),
			troops = {}, rodeLength = 7000, strength = round(12-(2*gvDiffLVL))},
			{id = 3, position = GetPosition("BanditSpawn4"), building = GetID("BanditTower4"),
			troops = {}, rodeLength = 6800, strength = round(10-(1.5*gvDiffLVL))},
			{id = 4, position = GetPosition("BanditSpawn5"), building = GetID("BanditTower5"),
			troops = {}, rodeLength = 7700, strength = round(8-gvDiffLVL)},
			{id = 5, position = GetPosition("BanditSpawn6"), building = GetID("BanditTower6"),
			troops = {}, rodeLength = 8400, strength = round(12-(2.5*gvDiffLVL))},
			{id = 6, position = GetPosition("BanditSpawn7"), building = GetID("BanditTower7"),
			troops = {}, rodeLength = 7700, strength = round(10-(1.5*gvDiffLVL))},
			{id = 7, position = GetPosition("BanditSpawn8"), building = GetID("BanditTower8"),
			troops = {}, rodeLength = 9900, strength = round(12-(2*gvDiffLVL))},
			{id = 8, position = GetPosition("BanditSpawn9"), building = GetID("BanditTower9"),
			troops = {}, rodeLength = 9500, strength = round(12-(2.5*gvDiffLVL))},
			{id = 9, position = GetPosition("BanditSpawn10"), building = GetID("BanditTower10"),
			troops = {}, rodeLength = 4700, strength = round(7-gvDiffLVL)},
			{id = 10, position = GetPosition("BanditSpawn11"), building = GetID("BanditTower11"),
			troops = {}, rodeLength = 8800, strength = round(12-(1.5*gvDiffLVL))}
		},
		[8] = {
			{id = 0, position = GetPosition("NVSpawn"), building = GetID("NVBase"),
			troops = {}, rodeLength = 5100, strength = round(7-gvDiffLVL), troopTypes = NVTroopTypes},
			{id = 1, position = GetPosition("NVBaseSpawn"), building = GetID("NVHQ"),
			troops = {}, rodeLength = 7000, strength = round(8-gvDiffLVL), troopTypes = NVTroopTypes},
			{id = 2, position = GetPosition("NVBaseSpawn"), building = GetID("NVHQ"),
			troops = {}, rodeLength = 5800, strength = round(12-(2*gvDiffLVL)), troopTypes = NVTroopTypes}
		}
	}
	--
	for player, data in pairs(ArmyData) do
		for i = 1, table.getn(data) do
			local army = {}
			army.player = player
			army.id	= data[i].id
			army.position = data[i].position
			army.rodeLength	= data[i].rodeLength
			army.strength = round(data[i].strength)
			army.building = data[i].building
			army.troopTypes = data[i].troopTypes or RobbersTroopTypes
			SetupArmy(army)
			RefreshArmy(army.player, army.id, army.building, army.troopTypes)
		end
	end
	if gvDiffLVL < 2 then
		table.insert(RobbersTroopTypes, Entities.CU_VeteranMajor)
		table.insert(RobbersTroopTypes, Entities.CU_VeteranCaptain)
		table.insert(RobbersTroopTypes, Entities.CU_VeteranLieutenant)
	end
end
function RefreshArmy(_player, _id, _building, _types)
	local army = ArmyTable[_player][_id + 1]
	local trooptypes = _types
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
				RefreshArmy(_player, _id, _hq, army.troopTypes)
				return true
			end
		end
	end
	Defend(army)
end