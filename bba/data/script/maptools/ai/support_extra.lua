function ResearchAllUniversityTechnologies_Extra(_playerId)

	--AddOn Technologies
	Logic.SetTechnologyState(_playerId,Technologies.GT_Mathematics,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_Binocular,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_Matchlock,3)
	Logic.SetTechnologyState(_playerId,Technologies.GT_PulledBarrel,3)

end

----------------------------------------------------------------------------------------
-- Start Countdown
----------------------------------------------------------------------------------------
function MapLocal_StartCountDown(_time)

	GUIQuestTools.ToggleStopWatch(_time, 1)

end


----------------------------------------------------------------------------------------
-- Stop Countdown
----------------------------------------------------------------------------------------
function MapLocal_StopCountDown()

	GUIQuestTools.ToggleStopWatch(0, 0)

end

----------------------------------------------------------------------------------------
-- Set Campaign Flag for Extra campaigns
----------------------------------------------------------------------------------------

function SetGDBFlagForExtraCampaign()
	-- Get map name
	local MapName = string.lower(Framework.GetCurrentMapName())
	local MapType, CName = Framework.GetCurrentMapTypeAndCampaignName()
	if MapType == -1 then
		-- Create key
		local KeyName = "Game\\" .. CName .. "\\WonMap_" .. MapName
		-- Set GDB key
		GDB.SetValue( KeyName, 1 )
		if gvDiffLVL == 1 then
			KeyName = "Game\\" .. CName .. "\\WonMapHard_" .. MapName
			GDB.SetValue( KeyName, 1 )
		end
		local nummaps
		if CName == "Extra3_2" then
			nummaps = 5
		elseif CName == "Extra3" then
			nummaps = 11
		end
		local mapnames = {Framework.GetMapNames(0, nummaps, MapType, CName)}
		table.remove(mapnames, 1)
		local allmapsnormal = true
		for i = 1, nummaps do
			if not GDB.IsKeyValid("Game\\" .. CName .. "\\WonMap_" .. mapnames[i]) then
				allmapsnormal = false
				break
			else
				if GDB.GetValue("Game\\" .. CName .. "\\WonMap_" .. mapnames[i]) ~= 1 then
					allmapsnormal = false
					break
				end
			end
		end
		if allmapsnormal then
			GDB.SetValue("achievements\\wonmaps_campaign" .. CName, 1)
		end
		local allmapshard = true
		for i = 1, nummaps do
			if not GDB.IsKeyValid("Game\\" .. CName .. "\\WonMapHard_" .. mapnames[i]) then
				allmapshard = false
				break
			else
				if GDB.GetValue("Game\\" .. CName .. "\\WonMapHard_" .. mapnames[i]) ~= 1 then
					allmapshard = false
					break
				end
			end
		end
		if allmapshard then
			GDB.SetValue("achievements\\wonmapshard_campaign" .. CName, 1)
		end
	end
end