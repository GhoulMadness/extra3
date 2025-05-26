BanditTroopTypes = {Entities.CU_BanditLeaderSword1,
	Entities.CU_BanditLeaderSword2,
	Entities.CU_BanditLeaderBow1,
	Entities["PU_LeaderSword" .. 4 - gvDiffLVL],
	Entities["PU_LeaderBow" .. 4 - gvDiffLVL]}
NVArmyTypes = {Entities.CU_Evil_LeaderBearman1,
	Entities.CU_Evil_LeaderBearman1,
	Entities.CU_Evil_LeaderSpearman1,
	Entities.CU_Evil_LeaderSkirmisher1,
	Entities.CU_Evil_LeaderSkirmisher1,
	Entities.CU_Evil_LeaderCavalry1,
	Entities.CU_AggressiveScorpion1,
	Entities.CU_AggressiveScorpion2,
	Entities.CU_AggressiveScorpion3}
MurkalTroopTypes = {Entities.PU_LeaderSword4,
	Entities["PU_LeaderSword" .. math.min(2 + gvDiffLVL, 4)],
	Entities["PU_LeaderSword" .. 1 + gvDiffLVL],
	Entities.PU_LeaderPoleArm4,
	Entities["PU_LeaderPoleArm" .. math.min(2 + gvDiffLVL, 4)],
	Entities["PU_LeaderPoleArm" .. 1 + gvDiffLVL]}
function CreateInitialArmies()
	Logic.GroupStand(GetID("howitzer"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit1")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 3000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit2")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4000
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower1"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit3")
	army.strength = round(2/gvDiffLVL)
	army.rodeLength = 4000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit4")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit5")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 5000
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower2"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit6")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 3500
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower3"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit7")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit8")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit9")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit10")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit11")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 4500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit12")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit13")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit14")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 4000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit15")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower4"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit16")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit17")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 4800
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower5"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit18")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit19")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4900
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit20")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 6200
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower6"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit21")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 4500
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower7"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit22")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 5000
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower8"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit23")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4300
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit24")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 6500
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("BanditTower9"))
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit25")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit26")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2700
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("Bandit27")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("BanditSpawn")
	army.strength = round(12/gvDiffLVL)
	army.rodeLength = 25000
	army.enemySearchPosition = GetPosition("Bridge")
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("MaryBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVSpawn")
	army.strength = round(12/gvDiffLVL)
	army.rodeLength = 35000
	army.enemySearchPosition = GetPosition("NVMittel")
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV1")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 5500
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV2")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 5200
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV3")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5000
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV4")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 6000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV5")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV6")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 5700
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV7")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 5000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV8")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 6000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV9")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4800
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV10")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 6500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV11")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 6200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV12")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 6300
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV13")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 6000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV14")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = 6500
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVTower1"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV15")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV16")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2300
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV17")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2300
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV18")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV19")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV20")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4100
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV21")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 5100
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV22")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2200
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV23")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 4600
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV24")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 7000
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV25")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2800
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte1")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 2800
	SetupArmy(army)
	ArmyCave1_1 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte2")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3200
	SetupArmy(army)
	ArmyCave1_2 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte3")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3100
	SetupArmy(army)
	ArmyCave1_3 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte4")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3100
	SetupArmy(army)
	ArmyCave2_1 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte5")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = 3400
	SetupArmy(army)
	ArmyCave2_2 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVGrotte6")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = 3400
	SetupArmy(army)
	ArmyCave2_3 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NVCave")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVBurg"))
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("WohnSpawn")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("Wohn"))
	--
	local army = {}
	army.player = 2
	army.id = GetFirstFreeArmySlot(2)
	army.position = GetPosition("Dreadstone1")
	army.strength = 1
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities["PU_LeaderSword" .. 1 + gvDiffLVL]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 2
	army.id = GetFirstFreeArmySlot(2)
	army.position = GetPosition("Dreadstone2")
	army.strength = 1
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities["PU_LeaderSword" .. 1 + gvDiffLVL]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 2
	army.id = GetFirstFreeArmySlot(2)
	army.position = GetPosition("Dreadstone3")
	army.strength = 1
	army.rodeLength = 3500
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = Entities["PU_LeaderSword" .. 1 + gvDiffLVL]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end
function ControlGenericArmy(_player, _id)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(army) then
		return true
	else
		Defend(army)
	end
end
PlayerToTroopPool = {[4] = MurkalTroopTypes,
					[5] = BanditTroopTypes,
					[6] = BanditTroopTypes,
					[8] = NVArmyTypes
}
function RefreshArmy(_player, _id, _building, _delay)
	if not _delay then
		_delay = round(60 * gvDiffLVL)
	end
	local army = ArmyTable[_player][_id + 1]
	local trooptypes = PlayerToTroopPool[_player]
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = trooptypes[math.random(table.getn(trooptypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRespawningArmy",1,{},{_player, _id, _building, _delay})
end
function ControlRespawningArmy(_player, _id, _hq, _delay)
	local army = ArmyTable[_player][_id + 1]
	if not IsExisting(_hq) then
		if IsDead(army) then
			return true
		end
	else
		if IsVeryWeak(army) and IsExisting(_hq) then
			if Counter.Tick2("ArmyDead_" .. _player .. "_" .. _id, _delay) then
				RefreshArmy(_player, _id, _hq)
				return true
			end
		end
	end
	Defend(army)
end
function MurkalATK()
	local army = {}
	army.player = 4
	army.id = GetFirstFreeArmySlot(4)
	army.position = GetPosition("Player3")
	army.strength = round(5*gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	RefreshArmy(army.player, army.id, GetID("NVAttack"), round(60/gvDiffLVL))
end
function WohnReactArmy()
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("WohnSpawn")
	army.strength = round(8/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end
function MaryReactArmy()
	local army = {}
	army.player = 6
	army.id = GetFirstFreeArmySlot(6)
	army.position = GetPosition("BanditSpawn")
	army.strength = round(10/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	ChangePlayer("Mary", 6)
	ConnectLeaderWithArmy(GetID("Mary"), army)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end
function KalaReactArmy()
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("NV1")
	army.strength = round(12/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	ChangePlayer("Kala", 8)
	ConnectLeaderWithArmy(GetID("Kala"), army)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end
function BandStoneArmy()
	local army = {}
	army.player = 5
	army.id = GetFirstFreeArmySlot(5)
	army.position = GetPosition("SteinBandit")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	SteinBanditArmy = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = BanditTroopTypes[math.random(table.getn(BanditTroopTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end
function NVSteinArmy()
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Player1")
	army.strength = round(6/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	NVSteinArmy1 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
	--
	local army = {}
	army.player = 8
	army.id = GetFirstFreeArmySlot(8)
	army.position = GetPosition("Player1NV")
	army.strength = round(4/gvDiffLVL)
	army.rodeLength = Logic.WorldGetSize()
	SetupArmy(army)
	NVSteinArmy2 = army
	for i = 1, army.strength do
		EnlargeArmy(army, {leaderType = NVArmyTypes[math.random(table.getn(NVArmyTypes))]})
	end
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlGenericArmy",1,{},{army.player, army.id})
end