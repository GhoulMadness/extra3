--[[
	Author: Play4FuN
	Date: 10.08.2022
	
	Description: A collection of some (minor) functionalities to enhance gameplay look/feeling etc for MULTIPLAYER COOP
	Note: Some features are not persistent (savegame)
	Note: Some required functions are NOT included; see p4f_tools for that!
	
	Contents:
	(overwrite)TributePaid_Action (called from SetupTributePaid)
	
	CreateChestMP
	AddNumberOfBuyableHeroesForPlayer
	
	(TODO: NPCs)
	
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

-- create a chest for multiplayer
-- params:
-- chest position (should be a script entity)
-- callback, receives the entity ID of the hero who opened the chest -> can be used to obtain the playerId
-- play a chest found sound only for the player who opened it
-- automatically considers all (up to 8) potential human players
function CreateChestMP(_pos, _callback)
	
	-- init
	if not gvChests then
		gvChests = {}
		gvChests.chests = {}
		gvChests.players = {}
		gvChests.numChestsCreated = 0
		gvChests.numChestsOpened = 0
		for playerId = 1, 8 do
			if Logic.PlayerGetGameState( playerId ) == 1 then
				table.insert( gvChests.players, playerId )
			end
		end
		gvChests.job = StartSimpleJob( "SJ_ControlChests" )
	end
	
	assert(IsDead("ChestEntity_".._pos), "CreateChestMP: a chest is already created there")
	assert(_callback ~= nil, "CreateChestMP: _callback is nil")
	local pos = GetPos(_pos)
	SetEntityName( Logic.CreateEntity(Entities.XD_ChestClose, pos.X, pos.Y, 0, 8), "ChestEntity_".._pos )
	table.insert( gvChests.chests, { pos = _pos, callback = _callback } )	-- pos is a string
	gvChests.numChestsCreated = gvChests.numChestsCreated + 1
	
end

function SJ_ControlChests()
	
	for index = 1, table.getn(gvChests.chests) do
		local Chest = gvChests.chests[index]
		if Chest then
			local pos = GetPos(Chest.pos)
			for _, playerId in gvChests.players do
				local heroes = {}
				Logic.GetHeroes( playerId, heroes )
				for i = 1, table.getn(heroes) do
					local entityId = heroes[i]
					if GetDistance( entityId, pos ) <= 350 and GetHealth( entityId ) > 0 then
						ReplaceEntity( "ChestEntity_"..Chest.pos, Entities.XD_ChestOpen )
						Chest.callback( entityId )	-- callback receives the hero who opened the chest
						table.remove( gvChests.chests, index )
						gvChests.numChestsOpened = gvChests.numChestsOpened + 1
						
						if GUI.GetPlayerID() == playerId then
							Sound.PlayGUISound( Sounds.OnKlick_Select_erec, 80 )
							Sound.Play2DQueuedSound( Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_01, 80 )
						end
						break
					end
				end
			end
		end
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- let the player get more heroes - not depending on how many he already got
function AddNumberOfBuyableHeroesForPlayer( _player, _heroes )
	local old = Logic.GetNumberOfBuyableHerosForPlayer( _player )
	local new = old + (_heroes or 1)
	Logic.SetNumberOfBuyableHerosForPlayer( _player, new )
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

