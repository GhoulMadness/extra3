Victory = function()

	--Message("Victory")

	--mark player as winner
	if Logic.PlayerGetGameState(gvMission.PlayerID) == 1 then
		Logic.PlayerSetGameStateToWon(gvMission.PlayerID)
	end


	-- Set flag to GDB that this map has been won
	do

		-- Get map name
		local MapName = Framework.GetCurrentMapName()

		-- Create key
		local KeyName = "Game\\WonMap_" .. MapName

		-- Set GDB key
		GDB.SetValue( KeyName, 1 )

	end

end