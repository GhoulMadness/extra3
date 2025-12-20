--[[
	Author: Play4FuN
	Date: 29.12.2020
	Version: 1.1
	
	Description: A collection of some (minor) functionalities to enhance gameplay look/feeling etc for MULTIPLAYER COOP
	Note: Some features are not persistent (savegame)
	Note: Some required functions are NOT included; see p4f_tools for that!
	
	Contents:
	(overwrite)TributePaid_Action (called from SetupTributePaid)
	
	(TODO: chests, NPCs)
	
--]]

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

TributePaid_Action = function(_Index)

	-- Is same tribute
	if Event.GetTributeUniqueID() == DataTable[_Index].Tribute then

		-- added: if the tribute has been paid by the local player; play the sound and close the window
		if (DataTable[_Index].playerId or 0) == (gvMission.PlayerID or -1) then
			Sound.PlayGUISound(Sounds.OnKlick_Select_helias, 70)
			if Logic.GetAllTributes(gvMission.PlayerID) == 1	-- this is the last tribute for this player
			and not DataTable[_Index].doNotCloseWindow then
				GUIAction_ToggleMenu( gvGUI_WidgetID.TradeWindow, 0 )
			end
		end
		
		-- Is Spawn table valid
		if DataTable[_Index].Spawn ~= nil then

			-- Get spawn player
			local PlayerID = gvMission.PlayerID
			if DataTable[_Index].SpawnPlayer ~= nil then
				PlayerID = DataTable[_Index].SpawnPlayer
			end

			-- For every element in table
			local i
			for i=1,table.getn(DataTable[_Index].Spawn) do
				-- Get position
				local PosX, PosY = Tools.GetPosition(DataTable[_Index].Spawn[i].Pos)

				-- Create troop
				local LeaderID = AI.Entity_CreateFormation(
					PlayerID,
					DataTable[_Index].Spawn[i].LeaderType,
					0,
					DataTable[_Index].Spawn[i].Soldiers,
					PosX,PosY,
					0,0,
					LOW_EXPERIENCE,
					0
				)

				-- Valid local ralley point
				if DataTable[_Index].Spawn[i].Ralleypoint ~= nil then

					-- Send group to this position
					Move(LeaderID, DataTable[_Index].Spawn[i].Ralleypoint)

				-- Valid ralley point
				elseif DataTable[_Index].Ralleypoint ~= nil then
					-- Send group to this position
					Move(LeaderID, DataTable[_Index].Ralleypoint)
				end

				-- Valid local ralley point
				if DataTable[_Index].Spawn[i].AttackRalleypoint ~= nil then

					-- Send group to this position
					Attack(LeaderID, DataTable[_Index].Spawn[i].AttackRalleypoint)

				-- Valid ralley point
				elseif DataTable[_Index].AttackRalleypoint ~= nil then
					-- Send group to this position
					Attack(LeaderID, DataTable[_Index].AttackRalleypoint)
				end

			end
		end

		-- Any technologies there
		if DataTable[_Index].Technologies ~= nil then

			-- Give technologies
			local i
			for i = 1, table.getn(DataTable[_Index].Technologies) do
				-- Research tech
				Logic.SetTechnologyState(gvMission.PlayerID, DataTable[_Index].Technologies[i], 3)
			end

		end

		-- Resource table
		if DataTable[_Index].Resources ~= nil then

			-- Give resources
			Tools.GiveResouces(	gvMission.PlayerID,
						DataTable[_Index].Resources.gold,
						DataTable[_Index].Resources.clay,
						DataTable[_Index].Resources.wood,
						DataTable[_Index].Resources.stone,
						DataTable[_Index].Resources.iron,
						DataTable[_Index].Resources.sulfur)

		end

		-- Any entities
		if DataTable[_Index].Entities ~= nil then

			-- Change player
			local i = 1
			while true do

				-- Get name
				local Name = DataTable[_Index].Entities..i

				-- Is existing
				if not ChangeAndMove(Name,DataTable[_Index]) then

					-- no entity there, stop searching
					break

				end

				-- Next entity
				i = i + 1
			end
		end

		-- Any entity
		if DataTable[_Index].Entity ~= nil then
			ChangeAndMove(DataTable[_Index].Entity, DataTable[_Index])
		end

		return QuestCallback(_Index)

	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
