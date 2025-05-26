--load widgets
WidgetHelper.AddPreCommitCallback(
function()
	CWidget.Transaction_AddRawWidgetsFromFile("data/script/maptools/tools/ArmyCreator.xml", "Normal")
end)
CWidget.LoadGUINoPreserve("data/script/maptools/tools/BS_GUI.xml")
BS.CheckForAchievements(GUI.GetPlayerID())
--initializing table
ArmyCreator = {TroopLimit = 10, PointCosts = {	[Entities.PU_LeaderSword1] = 4,
												[Entities.PU_LeaderSword2] = 5,
												[Entities.PU_LeaderSword3] = 8,
												[Entities.PU_LeaderSword4] = 11,
												[Entities.PU_LeaderPoleArm1] = 3,
												[Entities.PU_LeaderPoleArm2] = 4,
												[Entities.PU_LeaderPoleArm3] = 7,
												[Entities.PU_LeaderPoleArm4] = 10,
												[Entities.PU_LeaderBow1] = 4,
												[Entities.PU_LeaderBow2] = 5,
												[Entities.PU_LeaderBow3] = 9,
												[Entities.PU_LeaderBow4] = 14,
												[Entities.PU_LeaderRifle1] = 7,
												[Entities.PU_LeaderRifle2] = 12,
												[Entities.PU_LeaderCavalry1] = 7,
												[Entities.PU_LeaderCavalry2] = 12,
												[Entities.PU_LeaderHeavyCavalry1] = 6,
												[Entities.PU_LeaderHeavyCavalry2] = 10,
												[Entities.PU_LeaderUlan1] = 9,
												[Entities.PU_Thief] = 15,
												[Entities.PU_Scout] = 6,
												[Entities.PU_BattleSerf] = 2,
												[Entities.PV_Cannon1] = 8,
												[Entities.PV_Cannon2] = 10,
												[Entities.PV_Cannon3] = 15,
												[Entities.PV_Cannon4] = 18,
												[Entities.PV_Cannon5] = 23,
												[Entities.PV_Cannon6_2] = 75,
												[Entities.PV_Catapult] = 50,
												[Entities.PV_Ram] = 20,
												[Entities.CU_BanditLeaderSword1] = 6,
												[Entities.CU_BanditLeaderBow1] = 8,
												[Entities.CU_Barbarian_LeaderClub1] = 7,
												[Entities.CU_VeteranLieutenant] = 35,
												[Entities.CU_BlackKnight_LeaderMace1] = 7,
												[Entities.CU_BlackKnight_LeaderSword3] = 10,
												[Entities.CU_Evil_LeaderBearman1] = 8,
												[Entities.CU_Evil_LeaderSkirmisher1] = 10,
												[Entities.PU_Hero1c] = 25,
												[Entities.PU_Hero2] = 28,
												[Entities.PU_Hero3] = 28,
												[Entities.PU_Hero4] = 24,
												[Entities.PU_Hero5] = 22,
												[Entities.PU_Hero6] = 30,
												[Entities.CU_Mary_de_Mortfichet] = 28,
												[Entities.CU_Barbarian_Hero] = 24,
												[Entities.CU_BlackKnight] = 20,
												[Entities.CU_Evil_Queen] = 25,
												[Entities.PU_Hero10] = 28,
												[Entities.PU_Hero11] = 23,
												[Entities.PU_Hero13] = 26,
												[Entities.PU_Hero14] = 25
												},
				BasePoints = 100,
				PlayerPoints = 0,
				TroopException = {	[Entities.PU_Hero1c] = true,
									[Entities.PU_Hero2] = true,
									[Entities.PU_Hero3] = true,
									[Entities.PU_Hero4] = true,
									[Entities.PU_Hero5] = true,
									[Entities.PU_Hero6] = true,
									[Entities.CU_Mary_de_Mortfichet] = true,
									[Entities.CU_Barbarian_Hero] = true,
									[Entities.CU_BlackKnight] = true,
									[Entities.CU_Evil_Queen] = true,
									[Entities.PU_Hero10] = true,
									[Entities.PU_Hero11] = true,
									[Entities.PU_Hero13] = true,
									[Entities.PU_Hero14] = true,
									[Entities.PV_Cannon6_2] = true,
									[Entities.PV_Catapult] = true
									},
				TroopOnlyLeader = {	[Entities.PV_Cannon1] = true,
									[Entities.PV_Cannon2] = true,
									[Entities.PV_Cannon3] = true,
									[Entities.PV_Cannon4] = true,
									[Entities.PV_Cannon5] = true,
									[Entities.PV_Cannon6_2] = true,
									[Entities.PV_Catapult] = true,
									[Entities.PV_Ram] = true,
									[Entities.PU_Thief] = true,
									[Entities.PU_BattleSerf] = true,
									[Entities.PU_Scout] = true
									},
				PlayerTroops = { },
				SpawnPos = { },
				Finished = { },
				SpawnDone = false
}
for i = 1,16 do
	ArmyCreator.SpawnPos[i] = {X = 1000, Y = 1000}
	if IsValid("start_pos_p"..i) then
		ArmyCreator.SpawnPos[i] = GetPosition("start_pos_p"..i)
	end
	ArmyCreator.Finished[i] = false
	ArmyCreator.PlayerTroops[i] = { }
	for etype in ArmyCreator.PointCosts do
		ArmyCreator.PlayerTroops[i][etype] = 0
	end
end

if not CNetwork then
	ArmyCreator.BasePoints = ArmyCreator.BasePoints * 2
end
ArmyCreator.PlayerPoints = ArmyCreator.BasePoints * (gvDiffLVL or 1)

ArmyCreator.CheckForPointsLimitExceeded = function(_trooptable)
	local count = 0
	for k,v in pairs(_trooptable) do
		count = count + (ArmyCreator.PointCosts[k] * v)
		if count > (ArmyCreator.BasePoints * (gvDiffLVL)) then
			return k
		end
	end
end
ArmyCreator.CheckForAchievement = function(_playerID, _entry)
	local allowed
	local mapindex = {}
	local neededKey = BS.AchievementNames[_entry]
	for i = 1, table.getn(neededKey) do
		table.insert(mapindex, tonumber(string.sub(neededKey[i], 14, 14)))
	end
	for i = 1, table.getn(mapindex) do
		allowed = false
		for j = 1, table.getn(BS.AchievementWhitelist[mapindex[i]]) do
			if BS.AchievementWhitelist[mapindex[i]][j] == XNetwork.GameInformation_GetLogicPlayerUserName(_playerID) then
				allowed = true
			end
		end
		if not allowed then
			return false
		end
	end
	return true
end
ArmyCreator.ReadyForTroopCreation = function(_playerID, _trooptable)

	ArmyCreator.Finished[_playerID] = true
	ArmyCreator.PlayerTroops[_playerID] = _trooptable

	if ArmyCreator.OnSetupFinished then

		if CNetwork then

			local count = 0

			for i = 1,XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer() do
				if ArmyCreator.Finished[i] and not ArmyCreator.SpawnDone then
					count = count + 1
				end
			end

			if count == GetNumberOfPlayingHumanPlayer() then

				local playersleft = GetNumberOfPlayingHumanPlayer()

				for i = 1, 16 do

					if XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID(i) ~= 0 then

						ArmyCreator.CreateTroops(i, ArmyCreator.PlayerTroops[i])
						playersleft = playersleft - 1

					end

					if playersleft == 0 then

						ArmyCreator.SpawnDone = true
						break

					end

				end

				ArmyCreator.OnSetupFinished()

			end

		else

			ArmyCreator.CreateTroops(_playerID, _trooptable)
			ArmyCreator.OnSetupFinished()

		end
	end
end
ArmyCreator.CreateTroops = function(_playerID, _trooptable)

	for k,v in pairs(_trooptable) do

		if ArmyCreator.TroopException[k] and v == 1 then

			Logic.CreateEntity(k, ArmyCreator.SpawnPos[_playerID].X, ArmyCreator.SpawnPos[_playerID].Y, math.random(360), _playerID)

		elseif ArmyCreator.TroopOnlyLeader[k] then

			if v >= 1 then
				for i = 1,v do
					Logic.CreateEntity(k, ArmyCreator.SpawnPos[_playerID].X, ArmyCreator.SpawnPos[_playerID].Y, math.random(360), _playerID)
				end
			end

		else

			if v >= 1 then
				for i = 1,v do
					AI.Entity_CreateFormation(_playerID, k, 0, LeaderTypeGetMaximumNumberOfSoldiers(k), ArmyCreator.SpawnPos[_playerID].X, ArmyCreator.SpawnPos[_playerID].Y, 0, 0, 0, 0)
				end
			end

		end
	end
end