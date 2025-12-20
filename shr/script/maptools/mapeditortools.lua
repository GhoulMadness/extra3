---------------------------------------------------------------------------------------------------------------
-- Resource Victory Condition
---------------------------------------------------------------------------------------------------------------
function MapEditor_SetupResourceVictoryCondition(_gold, _clay, _wood, _stone, _iron, _sulfur)

	MapEditor_QuestResourceVictoryData 			=	{}
	MapEditor_QuestResourceVictoryData.gold		=	_gold
	MapEditor_QuestResourceVictoryData.clay 	= 	_clay
	MapEditor_QuestResourceVictoryData.wood 	=	_wood
	MapEditor_QuestResourceVictoryData.stone	=	_stone
	MapEditor_QuestResourceVictoryData.iron		=	_iron
	MapEditor_QuestResourceVictoryData.sulfur	=	_sulfur

	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND,
							nil,
							"MapEditor_QuestResourceVictory",
							1,
							nil,
							{ _gold, _clay, _wood, _stone, _iron, _sulfur })

	MapEditor_CreateQuestInfo()

end
function MapEditor_QuestResourceVictory(_gold, _clay, _wood, _stone, _iron, _sulfur)

	if 	GetGold()	>= _gold	and
		GetClay()	>= _clay	and
		GetWood()	>= _wood	and
		GetStone()	>= _stone	and
		GetIron()	>= _iron	and
		GetSulfur()	>= _sulfur 	then
			
			Victory()
			
			return true
	end

end
---------------------------------------------------------------------------------------------------------------
-- Destroy player condition
---------------------------------------------------------------------------------------------------------------
function MapEditor_SetupDestroyVictoryCondition(_playerId)

	Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND,
							nil,
							"MapEditor_QuestDestroyVictory",
							1,
							nil,
							{ _playerId })

	MapEditor_CreateQuestInfo()

end
function MapEditor_QuestDestroyVictory(_playerId)

	if Counter.Tick2("MapEditor_QuestDestroyVictory",10) then

		if Logic.GetPlayerEntitiesInArea(_playerId,0,0,0,0,1,2) == 0 then
			
			local Count, Id = Logic.GetPlayerEntitiesInArea(_playerId,0,0,0,0,1,8) 
			
			if Count <= 1 then
			
				if Id ~= nil then
					
					if Logic.IsConstructionComplete(Id) == 1 then
						return false
					end
					
				end
			
				Victory()
			
				return true
			
			end
			
		end

	end

end
---------------------------------------------------------------------------------------------------------------
-- Create Quest info for player
---------------------------------------------------------------------------------------------------------------
function MapEditor_CreateQuestInfo()

	if MapEditor_QuestTitle ~= nil and MapEditor_QuestDescription ~= nil then

		Logic.AddQuest(	1,									
						1,						
						MAINQUEST_OPEN,		
						MapEditor_QuestTitle,
						MapEditor_QuestDescription,
						1	
					)

	end
	
end
---------------------------------------------------------------------------------------------------------------
-- Default Defeat Condition...no HQ left
---------------------------------------------------------------------------------------------------------------
function MapEditor_CreateHQDefeatCondition()

	StartSimpleJob("MapEditor_DefeatCondition")

end
function MapEditor_DefeatCondition()

	local HQCount = 0
	local HQId

	for i=1,3 do

		local Count, Id = Logic.GetPlayerEntities(1,Entities["PB_Headquarters"..i],10)

		HQCount = HQCount + Count
		
		if Id ~= nil then
			HQId = Id
		end

	end

	-- One Left
	if HQCount == 1 then
		
		SetEntityName(HQId, "MapEditor_LastHQ")
		
		-- Create Defeat Condition
		AddDefeatEntity("MapEditor_LastHQ")
		
		return true
		
	end

end