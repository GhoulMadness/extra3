function CreateArmies()
	SetHostile(1,6)
	SetHostile(6,8)
	NVTroopTypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSkirmisher1, Entities.CU_Evil_LeaderSpearman1}

	ArmyData = {
		[6] = {
			{id = 0, position = GetPosition("ev_spawn1"), building = GetID("ev_tower1"),
			troops = {}, rodeLength = 3500, strength = round(5-gvDiffLVL)},
			{id = 1, position = GetPosition("ev_spawn2"), building = GetID("ev_tower2"),
			troops = {}, rodeLength = 2600, strength = round(5-gvDiffLVL)},
			{id = 2, position = GetPosition("ev_spawn3"), building = GetID("ev_tower3"),
			troops = {}, rodeLength = 2500, strength = round(8-(2*gvDiffLVL))},
			{id = 3, position = GetPosition("ev_spawn4"), building = GetID("ev_tower4"),
			troops = {}, rodeLength = 3200, strength = round(8-(1.5*gvDiffLVL))},
			{id = 4, position = GetPosition("ev_spawn5"), building = GetID("ev_tower5"),
			troops = {}, rodeLength = 2400, strength = round(5-gvDiffLVL)},
			{id = 5, position = GetPosition("ev_spawn6"), building = GetID("ev_tower6"),
			troops = {}, rodeLength = 3000, strength = round(10-(2.5*gvDiffLVL))},
			{id = 5, position = GetPosition("ev_spawn7"), building = GetID("ev_tower7"),
			troops = {}, rodeLength = 2200, strength = round(8-(2*gvDiffLVL))},
			{id = 5, position = GetPosition("ev_spawn8"), building = GetID("ev_tower8"),
			troops = {}, rodeLength = 3000, strength = round(8-(2*gvDiffLVL))},
			{id = 5, position = GetPosition("ev_spawn9"), building = GetID("ev_tower9"),
			troops = {}, rodeLength = 2500, strength = round(8-(2*gvDiffLVL))}
		}
	}
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
function RefreshArmy(_player, _id, _building, _types)
	local army = ArmyTable[_player][_id + 1]
	local trooptypes = _types or NVTroopTypes
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
				RefreshArmy(_player, _id, _hq, army.types)
				return true
			end
		end
	end
	Defend(army)
end