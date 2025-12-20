
--[[
	Author: Play4FuN
	Date: 06.03.2019
	
	Goal: quest system for multiplayer (?)
	allow multiple quests to be active at a time; "interface" allows to customize the way the player can interact with his quests
	
--]]

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

function MPQuest_Init()
	
	gvMission.PlayerID = gvMission.PlayerID or GUI.GetPlayerID()
	
	gvQuests = gvQuests or {}
	gvQuests.Quests = {}			-- contains all quests
	gvQuests.QuestId = 0
	gvQuests.DisplayQuestId = {}	-- for every player individually
	gvQuests.MPQuest_DISABLED = 0
	gvQuests.MPQuest_ACTIVE = 1
	gvQuests.MPQuest_WAITING = 2
	gvQuests.MPQuest_DONE = 3
	
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, nil, "MPQuest_Job", 1, nil, nil)
	--StartSimpleJob("MPQuest_Job")
	
	for i = 0,4 do
		XGUIEng.SetMaterialTexture("QuestInformationIcon",i, "Data\\Graphics\\Textures\\GUI\\QuestInformation\\Serf.png")		
	end
	
	GUIQuestTools.UpdateQuestInformationTooltip = function()
		XGUIEng.SetText(XGUIEng.GetWidgetID("QuestInformationTooltipText"), (MPQuest_GetTooltipText(gvMission.PlayerID)))
	end
	
	GUIQuestTools.UpdateQuestInformationCounter = function()
		XGUIEng.SetText("QuestInformationCounter", (MPQuest_GetCounterString(gvMission.PlayerID)))
	end
	
	Mission_OnSaveGameLoaded_OrigMPQuest = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_OrigMPQuest()
		MPQuest_UpdateGUI(gvMission.PlayerID)
	end
	
end


function MPQuest_Job()
	for k, quest in pairs(gvQuests.Quests) do
		
		if quest.status == gvQuests.MPQuest_ACTIVE then
			if quest.condition(quest.id) then
				--quest.status = MPQuest_DONE
				MPQuest_EndQuest(quest)
			end
		end
	end
end


function MPQuest_GetTooltipText(_player)
	local quest = MPQuest_GetActivePlayerQuest(_player)
	if quest == nil then return " " end
	return quest.text
end


function MPQuest_GetUniqueQuestId()
	gvQuests.QuestId = gvQuests.QuestId + 1
	return gvQuests.QuestId
end


function MPQuest_SetText(_player, _text)
	local quest = MPQuest_GetActivePlayerQuest(_player)
	if quest == nil then return end
	quest.text = _text
	return true
end


function MPQuest_SetCounter(_questID, _counter)
	local quest = MPQuest_GetQuestByID(_questID)
	if quest then
		quest.counter = _counter
	end
end


function MPQuest_GetQuestByID(_questID)
	return gvQuests.Quests[_questID]-- or nil
end


function MPQuest_SetLimit(_player, _limit)
	local quest = MPQuest_GetActivePlayerQuest(_player)
	if quest == nil then return end
	quest.limit = _limit
	return true
end


function MPQuest_SetImage(_player, _image)
	if gvMission.PlayerID ~= _player then return false end
	--XGUIEng.ShowWidget("QuestInformation", 1)
	XGUIEng.TransferMaterials(_image, "QuestInformationIcon")
	return true
end


function MPQuest_GetActivePlayerQuest(_player)
	return gvQuests.Quests[ gvQuests.DisplayQuestId[_player] ]
end


function MPQuest_GetCompletedPlayerQuestID()
	for k, quest in pairs(gvQuests.Quests) do
		--if quest.player == _player
		if quest.status == gvQuests.MPQuest_DONE then
			return quest.id
		end
	end
	return nil
end


function MPQuest_GetWaitingPlayerQuestIDs()
	local quests = {}
	for k, quest in pairs(gvQuests.Quests) do
		--if quest.player == _player
		if quest.status == gvQuests.MPQuest_WAITING then
			quests[table.getn(quests) + 1] = quest.id
		end
	end
	if table.getn(quests) > 0 then
		return quests
	else
		return nil
	end
end


function MPQuest_GetCounterString(_player)
	local quest = MPQuest_GetActivePlayerQuest(_player)
	if quest == nil or quest.limit == nil or quest.counter == nil then
		return " - "
	end
	return quest.counter .. "/" .. quest.limit
end


function MPQuest_AddQuest(_questTable, _playSound)
	--local _id = MPQuest_GetUniqueQuestId()
	--_questTable.id = _id
	
	if not _questTable.player then
		Message("MPQuest Error (addquest): questtable needs player ID!")
		return false
	end
	
	local id = _questTable.id
	gvQuests.Quests[id] = _questTable
	gvQuests.Quests[id].status = gvQuests.MPQuest_ACTIVE
	
	if _playSound and gvMission.PlayerID == _questTable.player then
		Sound.Play2DQueuedSound(Sounds.VoicesMentor_QUEST_NewQuest_rnd_01, 80)
	end
	
	MPQuest_SetDisplayedQuestID(_questTable.player, id)
	
	return true
end


function MPQuest_SetDisplayedQuestID(_player, _questID)
	gvQuests.DisplayQuestId[_player] = _questID
	MPQuest_UpdateGUI(_player)
end


function MPQuest_EndQuest(_questTable)
	--LuaDebugger.Log("end quest ".._questTable.id.." for player ".._questTable.player)
	if _questTable.callback ~= nil then
		_questTable.callback()
	end
	
	if gvMission.PlayerID == _questTable.player then
		Sound.PlayGUISound(Sounds.Misc_Chat, 90)
		if _questTable.completedSound then
			Sound.Play2DQueuedSound(Sounds.VoicesMentor_COMMENT_GoodPlay_rnd_01, 80)
		end
	end
	
	-- if the completed quest is not currently displayed, do not cycle
	if gvQuests.DisplayQuestId[_questTable.player] == _questTable.id then
		MPQuest_CycleNextQuest(_questTable.player, false)
	end
	
	--gvQuests.Quests[_questTable.id] = nil
	_questTable.status = gvQuests.MPQuest_DONE
	
	MPQuest_UpdateGUI(_questTable.player)
	return true
end


function MPQuest_CycleNextQuest(_player, _reverse)
	--local player = _player or gvQuests.PlayerID
	local openQuestIDs = MPQuest_GetActivePlayerQuestIDs(_player)
	if table.getn(openQuestIDs) == 0 then
		return false
	end
	
	local oldQuest = MPQuest_GetActivePlayerQuest(_player)
	local oldID
	if oldQuest then
		oldID = oldQuest.id
	else
		--LuaDebugger.Log("MPQuest Error - no active quest; cannot cycle")
		Message("MPQuest Error - no active quest (" .. _player .. "); cannot cycle")
		oldID = 1	-- test...
	end
	
	if _reverse then
		local i = oldID
		while true do
			i = i - 1
			if i < 1 then i = table.getn(gvQuests.Quests) end
			
			local quest = gvQuests.Quests[i]
			if quest.player == _player
			and quest.status == gvQuests.MPQuest_ACTIVE then
				MPQuest_SetDisplayedQuestID(_player, quest.id)
				break
			end
		end
	else
		local i = oldID
		while true do
			i = i + 1
			if i > table.getn(gvQuests.Quests) then i = 1 end
			
			local quest = gvQuests.Quests[i]
			if quest.player == _player
			and quest.status == gvQuests.MPQuest_ACTIVE then
				MPQuest_SetDisplayedQuestID(_player, quest.id)
				break
			end
		end
	end
end


function MPQuest_GetPosition(_questID)
	local quest = MPQuest_GetQuestByID(_questID)
	if quest then
		return quest.position
	end
end

-- returns all quests (or not completed ones)
function MPQuest_GetNumberOfPlayerQuests(_player, _countCompleted)
	local quests = 0
	for k, quest in pairs(gvQuests.Quests) do
		if quest.player == gvMission.PlayerID
		and (_countCompleted or quest.status ~= gvQuests.MPQuest_DONE) then
			quests = quests + 1
		end
	end
	
	return quests
	
end


function MPQuest_GetActivePlayerQuestIDs(_player)
	local questIDs = {}
	for k, quest in pairs(gvQuests.Quests) do
		if quest.player == gvMission.PlayerID
		and quest.status == gvQuests.MPQuest_ACTIVE then
			table.insert(questIDs, quest.id)
		end
	end
	return questIDs
end

-- to be called every time a new quest is added; a quest is completed or after cycling to another quest
function MPQuest_UpdateGUI(_player)
	if gvMission.PlayerID ~= _player then return false end
	
	local openQuestIDs = MPQuest_GetActivePlayerQuestIDs(_player)
	
	if table.getn(openQuestIDs) > 0 then
		-- there is still at least one quest to show
		local quest = MPQuest_GetQuestByID( gvQuests.DisplayQuestId[_player] )
		
		--LuaDebugger.Log(MPQuest_GetQuestByID( gvQuests.DisplayQuestId[_player] ))
		if not quest then
			Message("MPQuest Error - no active quest (" .. _player .. "); cannot display")
			return false
		end
		
		XGUIEng.ShowWidget("QuestInformation", 1)
		MPQuest_SetImage(_player, quest.image)
		if quest.counter then
			XGUIEng.ShowWidget("QuestInformationCounter", 1)
		else
			XGUIEng.ShowWidget("QuestInformationCounter", 0)
		end
	
	else
		-- no more quests at all; hide
		XGUIEng.ShowWidget("QuestInformation", 0)
		XGUIEng.ShowWidget("QuestInformationCounter", 0)
	end
end

