--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Generic Buttons
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--------------------------------------------------------------------------------
-- Change Windows
--------------------------------------------------------------------------------

function GUIAction_ToggleMenu( _Menu, _Status )
	
	-- Do not go back the main menu, when player hast los / won the game and cancle loading
	if XGUIEng.GetCurrentWidgetID() == XGUIEng.GetWidgetID( "MainMenuLoadWindowCloseButton" ) 
	and Logic.PlayerGetGameState(GUI.GetPlayerID())  ~= 1 then
		_Menu = gvGUI_WidgetID.GameEndScreenWindowHint	
		_Status = 0
	end
	
	if 		XGUIEng.GetCurrentWidgetID() == gvGUI_WidgetID.MainMenuWindow_LoadGame 
		or	_Menu == gvGUI_WidgetID.MainMenuLoadWindow then

		MainWindow_LoadGame_GenerateList()

	end

	if	 	XGUIEng.GetCurrentWidgetID() == gvGUI_WidgetID.MainMenuWindow_SaveGame then
		
		MainWindow_SaveGame_GenerateList()

	end
	
	--if Logic.PlayerGetGameState(GUI.GetPlayerID())  ~= 1 
	--and _Menu ~= gvGUI_WidgetID.MainMenuLoadWindow 
	--and _Menu ~= gvGUI_WidgetID.GameEndScreenWindowHint	then
	--	return
	--end
	

	
	-- Should toggle AND is shown right now? 
	local DoneFlag = 0
	if _Status == -1 then
		if XGUIEng.IsWidgetShown( _Menu ) == 1 then						
			DoneFlag = 1
		end	
	end
	
	
	-- Hide all
	XGUIEng.ShowAllSubWidgets( gvGUI_WidgetID.Windows, 0 )		
	
	-- Check trade			
	if _Menu == gvGUI_WidgetID.TradeWindow then
		local TributIDs =  { Logic.GetAllTributes(GUI.GetPlayerID()) }
		local HasPlayerTributes = TributIDs[1]
		if HasPlayerTributes == 0 then
			DoneFlag = 1
		end
	end
	
	-- Check quest
	if _Menu == gvGUI_WidgetID.QuestWindow then
		local QuestIDs = { Logic.GetAllQuests(GUI.GetPlayerID()) }
		local HasPlayerQuests = QuestIDs[1]
		if HasPlayerQuests == 0 then
			DoneFlag = 1
		end
	end
	
	-- Check network
	if _Menu == gvGUI_WidgetID.NetworkWindow 
	or _Menu == gvGUI_WidgetID.BuyHeroWindow then
		if XNetwork.Manager_DoesExist() == 0 then
			DoneFlag = 1
		end
	end
	
	-- Done?
	if DoneFlag == 1 then		
		return
	end
	
	XGUIEng.ShowWidget( _Menu, _Status )
	
	
	
end


--------------------------------------------------------------------------------
-- Change Serf Menu
--------------------------------------------------------------------------------

function GUIAction_ToggleSerfMenu( _Menu,_status)
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	XGUIEng.ShowAllSubWidgets(gvGUI_WidgetID.SerfMenus,0)
	
	XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "BuildingMenuGroup")
	
	
	if _Menu == gvGUI_WidgetID.SerfConstructionMenu then
		XGUIEng.HighLightButton(gvGUI_WidgetID.ToSerfBeatificationMenu,1)	
	else
		XGUIEng.HighLightButton(gvGUI_WidgetID.ToSerfConstructionMenu,1)	
	end
	
	
	
	XGUIEng.ShowWidget(_Menu,_status)
	
	--Update all buttons in the visible container
	XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
	
end
--------------------------------------------------------------------------------
-- Place Building
--------------------------------------------------------------------------------
function GUIAction_PlaceBuilding( _UpgradeCategory )

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "BuildingGroup")
		
	local PlayerID = GUI.GetPlayerID()
	Logic.FillBuildingCostsTable( Logic.GetBuildingTypeByUpgradeCategory(_UpgradeCategory, PlayerID ), InterfaceGlobals.CostTable )
	
	-- Does the player have enough mones?
	if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then			
		-- YES!
		XGUIEng.HighLightButton(CurrentWidgetID,1)
		GUI.ActivatePlaceBuildingState(_UpgradeCategory)
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )
		
	end
	
end

--------------------------------------------------------------------------------
-- Give a command to a military unit
--------------------------------------------------------------------------------
function GUIAction_Command(_CommandType)
	
	local SelectedEntityIDs = { GUI.GetSelectedEntities() }
	
	GUI.CancelState() 	
	
	--Attack Move
	if _CommandType == 1 then
		GUI.ActivateAttackMoveCommandState()		
	
	elseif 	_CommandType == 2
		or	_CommandType == 3 
		or	_CommandType == 6 then				
		
			for i=1, 20, 1 do
				local SelectedEntityID = SelectedEntityIDs[ i ]
				if SelectedEntityID ~= nil and SelectedEntityID > 0 then
					--Stand
					if _CommandType == 2 then
						GUI.SettlerStand(SelectedEntityID)
				
					--Defend
					elseif _CommandType == 3 then
						GUI.SettlerDefend(SelectedEntityID)
							--Set agressivemode (not used yet)
					elseif _CommandType == 6 then
						GUI.SettlerAggressive(SelectedEntityID)
					end
				end
			end

	--Patrol
	elseif 	_CommandType == 4 then				
		GUI.ActivatePatrolCommandState()
	--Guard
	elseif 	_CommandType == 5 then				
		GUI.ActivateGuardCommandState()
	end
end

--------------------------------------------------------------------------------
-- Change Formation
--------------------------------------------------------------------------------
function GUIAction_ChangeFormation(_formationtype)

	-- Get entities
	local SelectedEntityIDs = { GUI.GetSelectedEntities() }

	-- Do action
	do
		for i=1, 20, 1 do
			local SelectedEntityID = SelectedEntityIDs[ i ]
			if SelectedEntityID ~= nil and SelectedEntityID > 0 then
				if _formationtype == 1 then
					GUI.LeaderChangeFormationType( SelectedEntityID, 1 )		
				elseif _formationtype == 2 then
					GUI.LeaderChangeFormationType( SelectedEntityID, 2 )
				elseif _formationtype == 3 then
					GUI.LeaderChangeFormationType( SelectedEntityID, 3 )
				elseif _formationtype == 4 then
					GUI.LeaderChangeFormationType( SelectedEntityID, 4 )
				end			
			end
		end
	end
		
	GUI.SendChangeFormationFeedbackEvent(_formationtype)
--	Sound.PlayFeedbackSound( Sounds.Leader_LEADER_Formation_rnd_01, 0 )
	
	return
end

--------------------------------------------------------------------------------
-- Expel settler
--------------------------------------------------------------------------------
function GUIAction_ExpelSettler()
	local SelectedEntityID = GUI.GetSelectedEntity()
	if Logic.IsHero(SelectedEntityID) == 1 then
		--Sound.PlayFeedbackSound( Sounds.Leader_LEADER_NO_rnd_01, 0 )
	else
		GUI.ExpelSettler(SelectedEntityID)
	end
	
end

--------------------------------------------------------------------------------
-- Send the hawk
--------------------------------------------------------------------------------
function GUIAction_Hero1SendHawk()
	GUI.ActivateSendHawkCommandState()
	GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID())
	--Sound.PlayFeedbackSound( Sounds.Hero1_HERO1_Special_1, 0 )
end

--------------------------------------------------------------------------------
-- Look at hawk
--------------------------------------------------------------------------------
function
GUIAction_Hero1LookAtHawk()
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local PlayerID = GUI.GetPlayerID()			
	local HeroID = GUI.GetSelectedEntity()
	local Dummy, HawkEntity = Logic.GetPlayerEntities(PlayerID, Entities.PU_Hero1_Hawk,1)
	
	
	if gvGUI.HawkIsFlying == 0 then
		if HawkEntity ~= nil then
			Camera.ZoomSetAngle(90)	
			Camera.ZoomSetDistance(4700)
			Camera.FollowEntity(HawkEntity)
			GUI.SetSelectedEntity(HawkEntity)		
			
			-- Cameramode
			--Camera.ScrollUpdateZMode( 1 ) 
	
			gvCamera.DefaultFlag = 0
			
			gvGUI.HawkIsFlying = 1
			XGUIEng.HighLightButton(CurrentWidgetID,1)	
				
		end
	else
		GUIAction_GoBackFromHawkViewInNormalView()		
		local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( HeroID )
		Camera.ScrollSetLookAt(IDPosX, IDPosY)
		XGUIEng.HighLightButton(CurrentWidgetID,0)	
	end
end
--------------------------------------------------------------------------------
-- Protect Units by fear the enemies
--------------------------------------------------------------------------------
function
GUIAction_Hero1ProtectUnits() 
	GUI.SettlerInflictFear(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Place the bomb
--------------------------------------------------------------------------------
function GUIAction_Hero2PlaceBomb()
	GUI.ActivatePlaceBombCommandState() 
	GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID())
	--Sound.PlayFeedbackSound( Sounds.Hero2_HERO2_Special_1, 0 )	
end

--------------------------------------------------------------------------------
-- Build cannon
--------------------------------------------------------------------------------
function
GUIAction_Hero2BuildCannon() 
	GUI.ActivatePlaceCannonState(Entities.PU_Hero2_Foundation1, Entities.PU_Hero2_Cannon1)
	GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Build Trap
--------------------------------------------------------------------------------
function GUIAction_Hero3BuildTrap()
	GUI.ActivatePlaceCannonState(Entities.PU_Hero3_Trap, Entities.PU_Hero3_TrapCannon)
	GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID())
	--Sound.PlayFeedbackSound( Sounds.Hero3_HERO3_Special_1, 0 )
end

--------------------------------------------------------------------------------
-- Heal units
--------------------------------------------------------------------------------
function
GUIAction_Hero3Heal()
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())	
end

--------------------------------------------------------------------------------
-- Circular Attack
--------------------------------------------------------------------------------
function
GUIAction_Hero4CircularAttack()
	GUI.SettlerCircularAttack(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Range Effect
--------------------------------------------------------------------------------
function
GUIAction_Hero4AuraOfWar()  
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Camouflage
--------------------------------------------------------------------------------
function GUIAction_Hero5Camouflage()
	GUI.SettlerCamouflage(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Summon Entities
--------------------------------------------------------------------------------
function GUIAction_Hero5Summon()
	GUI.SettlerSummon(HeroSelection_GetCurrentSelectedHeroID())	
end

--------------------------------------------------------------------------------
-- Convert Settlers
--------------------------------------------------------------------------------
function
GUIAction_Hero6ConvertSettlers()
	--GUI.ActivateConvertBuildingCommandState()
	GUI.ActivateConvertSettlerCommandState()
	GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Bless Settlers
--------------------------------------------------------------------------------
function
GUIAction_Hero6Bless() 
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())
end
--------------------------------------------------------------------------------
-- Inflict Fear
--------------------------------------------------------------------------------
function
GUIAction_Hero7InflictFear()
	GUI.SettlerInflictFear(HeroSelection_GetCurrentSelectedHeroID())
end
--------------------------------------------------------------------------------
-- Inflict Fear
--------------------------------------------------------------------------------
function
GUIAction_Hero7Madness() 
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())
end

--------------------------------------------------------------------------------
-- Poison units in range
--------------------------------------------------------------------------------
function
GUIAction_Hero8Poison() 
	local HeroID = HeroSelection_GetCurrentSelectedHeroID()
	--local x,y = Logic.GetEntityPosition(HeroID)
	--Logic.CreateEffect(GGL_Effects.FXExplosionPilgrim ,x,y)
	GUI.SettlerCircularAttack(HeroID)
end

--------------------------------------------------------------------------------
-- Morale Damage
--------------------------------------------------------------------------------
function
GUIAction_Hero8MoraleDamage() 
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())
end
--------------------------------------------------------------------------------
-- Summon wolfs
--------------------------------------------------------------------------------
function
GUIAction_Hero9CallWolfs() 
	GUI.SettlerSummon(HeroSelection_GetCurrentSelectedHeroID())	
end
--------------------------------------------------------------------------------
-- Berserker
--------------------------------------------------------------------------------
function
GUIAction_Hero9Berserk()
	GUI.SettlerAffectUnitsInArea(HeroSelection_GetCurrentSelectedHeroID())
end


--------------------------------------------------------------------------------
-- Buy a Leader
--------------------------------------------------------------------------------
function GUIAction_BuyMilitaryUnit(_UpgradeCategory)

	
	local BarracksID = GUI.GetSelectedEntity()
	
	if Logic.GetRemainingUpgradeTimeForBuilding(BarracksID ) ~= Logic.GetTotalUpgradeTimeForBuilding (BarracksID) then		
		return
	end
	
	local PlayerID = GUI.GetPlayerID()
	
	local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
	local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
	
	if AverageMotivation < VCThreshold then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))		
		return
	end
	
	

	-- Maximum number of settlers attracted?
	if Logic.GetPlayerAttractionUsage( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID ) then
		GUI.SendPopulationLimitReachedFeedbackEvent( PlayerID )
--		Speech_StartExternal( "Speech_INFO_NoMoreSettlersInVC_2", 3 )
		return
	end
	
	
	--currently researching
	if Logic.GetTechnologyResearchedAtBuilding(BarracksID) ~= 0 then
		return
	end	
	
	Logic.FillSoldierCostsTable( PlayerID, _UpgradeCategory, InterfaceGlobals.CostTable )
	
	if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then	
		-- Yes
		
		
		GUI.BuyLeader(BarracksID, _UpgradeCategory)
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )
	end
		
end

--------------------------------------------------------------------------------
-- Buy a cannon
--------------------------------------------------------------------------------
function GUIAction_BuyCannon(_CannonType, _UpgradeCategory)


	-- Get barrack
	local FoundryID = GUI.GetSelectedEntity()		
	
	if InterfaceTool_IsBuildingDoingSomething( FoundryID ) == true then		
		return
	end
	
	local PlayerID = GUI.GetPlayerID()
	
	local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
	local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
	
	if AverageMotivation < VCThreshold then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))		
		return
	end

	-- Maximum number of settlers attracted?
	if Logic.GetPlayerAttractionUsage( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID ) then
		GUI.SendPopulationLimitReachedFeedbackEvent( PlayerID )
--		Speech_StartExternal( "Speech_INFO_NoMoreSettlersInVC_2", 3 )
		return
	end
	
	Logic.FillSoldierCostsTable( PlayerID, _UpgradeCategory, InterfaceGlobals.CostTable )
	
	if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then	
		-- Yes
		
		GUI.BuyCannon(FoundryID, _CannonType)
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )		
		XGUIEng.ShowWidget(gvGUI_WidgetID.CannonInProgress,1)
	end
end

--------------------------------------------------------------------------------
-- Set the new amount of workers in a selected building: CHANGE THIS! We have balancing Data here!
--------------------------------------------------------------------------------
function GUIAction_SetAmountOfWorkers(_amount)
	
	local BuildingID = GUI.GetSelectedEntity()
	local MaxNumberOfworkers = Logic.GetMaxNumWorkersInBuilding(BuildingID)
	local NewAmount = 0

	if _amount == "few" then
		NewAmount = 0	
	elseif _amount == "half" then
		NewAmount = math.ceil( MaxNumberOfworkers/2 )	
	elseif _amount == "full" then
		NewAmount = MaxNumberOfworkers	
	end
	
	GUI.SetCurrentMaxNumWorkersInBuilding(BuildingID,NewAmount)
	
	InterfaceTool_UpdateWorkerAmountButtons()
end


--------------------------------------------------------------------------------
-- Force Settlers to work
--------------------------------------------------------------------------------
function GUIAction_ForceSettlersToWork()
	
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local BuildingID = GUI.GetSelectedEntity()
	
	if Logic.IsAlarmModeActive(BuildingID) == true then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_StoptAlarmFirst"))				
		return
	end
	
	if Logic.GetRemainingUpgradeTimeForBuilding(BuildingID) ~= Logic.GetTotalUpgradeTimeForBuilding (BuildingID) then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_BuildingUnderConstruction"))				
		return
	end
	
	
	local BuildingType =  Logic.GetEntityType( BuildingID )
	local BuildingCategory = Logic.GetUpgradeCategoryByBuildingType( BuildingType )
	
	local SettlersTable = {}
	
	
	--Force Settlers 
	if BuildingCategory == UpgradeCategories.Residence then
		SettlersTable = {Logic.GetAttachedResidentsToBuilding(BuildingID)}	
		for i= 1, SettlersTable[1], 1 
		do
			GUI.ForceSettlerToWork(SettlersTable[i+1])
		end
		
	elseif BuildingCategory == UpgradeCategories.Farm then
		SettlersTable = {Logic.GetAttachedEaterToBuilding(BuildingID)}
		for i= 1, SettlersTable[1], 1 
		do
			GUI.ForceSettlerToWork(SettlersTable[i+1])
		end
			
	else
		GUI.ToggleOvertimeAtBuilding(BuildingID)		
	end
		
	
	
end


--------------------------------------------------------------------------------
-- Set level of taxes
--------------------------------------------------------------------------------

function GUIAction_SetTaxes(_level)	
	GUI.SetTaxLevel(_level)
end

--------------------------------------------------------------------------------
-- Acitavte Alarm
--------------------------------------------------------------------------------

function GUIAction_ActivateAlarm()
	
	Sound.PlayFeedbackSound( Sounds.VoicesMentor_ALARM_ActivateAlarm, 0 )	
	GUI.EnterWorkerAlarmMode()
	
end

--------------------------------------------------------------------------------
-- Quit alarm
--------------------------------------------------------------------------------

function GUIAction_QuitAlarm()	
	Sound.PlayFeedbackSound( Sounds.VoicesMentor_ALARM_QuitAlarm, 0 )		
	GUI.QuitWorkerAlarmMode()
end


--------------------------------------------------------------------------------
-- Find next idle settler
--------------------------------------------------------------------------------
gvInterface_LastSerfID = 0

function GUIAction_FindIdleSerf(_OnlyIdleSerfs)
	
	local PlayerID = GUI.GetPlayerID()	
	local CurrentSerfID = Logic.GetNextIdleSerf(PlayerID, gvInterface_LastSerfID)	
	local IdleSerfAmount = Logic.GetNumberOfIdleSerfs(PlayerID) 
	
	if IdleSerfAmount > 0 then
		if CurrentSerfID ~= 0 then		
			if XGUIEng.IsModifierPressed( Keys.ModifierShift ) == 0 then
				GUI.ClearSelection()
			end
			
			if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 0 then
				local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( CurrentSerfID )
				Camera.ScrollSetLookAt(IDPosX, IDPosY)	
				--GUIAction_FlyToEntity(CurrentSerfID)
			end
			
			GUI.SelectEntity( CurrentSerfID )	
		end
			
		gvInterface_LastSerfID = CurrentSerfID
	elseif _OnlyIdleSerfs == nil and IdleSerfAmount == 0 then
		KeyBindings_SelectUnit(UpgradeCategories.Serf,0)
	end
end

--------------------------------------------------------------------------------
-- Find players heroes
--------------------------------------------------------------------------------
function GUIAction_FindHero(_hero)
	
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()	
	local EntityID = XGUIEng.GetBaseWidgetUserVariable(CurrentWidgetID, 0)
	
	
	if EntityID  ~= 0 then
		
		GUI.ClearSelection()
		GUI.SelectEntity( EntityID )	
		
		if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 0 then
			local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( EntityID )
			Camera.ScrollSetLookAt(IDPosX, IDPosY)	
			--GUIAction_FlyToEntity(HeroID)
		end		
		
	end
	
end

--------------------------------------------------------------------------------
-- Force Settlers to work
--------------------------------------------------------------------------------
function GUIAction_BuySerf()
	local BuildingID = GUI.GetSelectedEntity()
	local PlayerID = GUI.GetPlayerID()
	
	if Logic.GetRemainingUpgradeTimeForBuilding(BuildingID ) ~= Logic.GetTotalUpgradeTimeForBuilding (BuildingID) then		
		return
	end
	
	local PlayerID = GUI.GetPlayerID()
	
	local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
	local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
	
	if AverageMotivation < VCThreshold then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))		
		return
	end
	
		--currently researching
	if Logic.GetTechnologyResearchedAtBuilding(BuildingID) ~= 0 then
		return
	end	
		
	-- Maximum number of settlers attracted?
	if Logic.GetPlayerAttractionUsage( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID ) then
		GUI.SendPopulationLimitReachedFeedbackEvent( PlayerID )
--		Speech_StartExternal( "Speech_INFO_NoMoreSettlersInVC_2", 3 )
		return
	end
	
	local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
	local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
	
	if AverageMotivation < VCThreshold then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))		
		return
	end
	
	
	Logic.FillSerfCostsTable( InterfaceGlobals.CostTable )
		
	if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then	
		-- Yes
		GUI.BuySerf(BuildingID)
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )
	end
end

--------------------------------------------------------------------------------
-- Buy a soldier for the selected Leader
--------------------------------------------------------------------------------
function GUIAction_BuySoldier()
	
	local LeaderID = GUI.GetSelectedEntity()
	local PlayerID = GUI.GetPlayerID()
	
		
	-- Maximum number of settlers attracted?
	if Logic.GetPlayerAttractionUsage( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID ) then
		GUI.SendPopulationLimitReachedFeedbackEvent( PlayerID )
--		Speech_StartExternal( "Speech_INFO_NoMoreSettlersInVC_2", 3 )
		return
	end
	
	local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
	local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
	
	if AverageMotivation < VCThreshold then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))		
		return
	end
	
	local UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory( LeaderID )
	Logic.FillSoldierCostsTable( PlayerID, UpgradeCategory, InterfaceGlobals.CostTable )
		
	if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then	
		-- Yes
		GUI.BuySoldier(LeaderID)
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )
	end
	
end 


--------------------------------------------------------------------------------
-- Jump to building of a settler
--------------------------------------------------------------------------------
function GUIAction_JumpToBuildingOfWorker(_type)
	
	local WorkerID = GUI.GetSelectedEntity()	
	local BuildingID 
	
	Camera.FollowEntity(0)
	Camera.SetControlMode( 0 )
	
	if _type == "farm" then
		BuildingID = Logic.GetSettlersFarm(WorkerID)
	elseif _type == "residence" then
		BuildingID = Logic.GetSettlersResidence(WorkerID)
	elseif _type == "work" then
		BuildingID = Logic.GetSettlersWorkBuilding(WorkerID)
	end
	
	
	if BuildingID ~= 0 or BuildingID ~= nil then
		local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( BuildingID )
		Camera.ScrollSetLookAt(IDPosX, IDPosY)	
		--GUIAction_FlyToEntity(BuildingID)		
	else 
		local string = "Worker has no" .. _type
		GUI.AddNote(string)
	end
		
end
--------------------------------------------------------------------------------
-- Change Weather with Weather Tower
--------------------------------------------------------------------------------
function GUIAction_ChangeWeather(_weathertype)
	
	--Ansu: add texkey here!
	if Logic.IsWeatherChangeActive() == true then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_WeatherIsCurrentlyChanging"))		
		return
	end
	
	local PlayerID = GUI.GetPlayerID()
	local CurrentWeatherEnergy = Logic.GetPlayersGlobalResource( PlayerID, ResourceType.WeatherEnergy )	
	local NeededWeatherEnergy = Logic.GetEnergyRequiredForWeatherChange()
	
	if CurrentWeatherEnergy >= NeededWeatherEnergy then		
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_WeathermashineActivated"))		
		GUI.SetWeather(_weathertype)
		
	else
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_WeathermashineNotReady"))
	end
	
end


--------------------------------------------------------------------------------
-- Bless Settlers
--------------------------------------------------------------------------------
function GUIAction_BlessSettlers(_BlessCategory)

	if InterfaceTool_IsBuildingDoingSomething( GUI.GetSelectedEntity() ) == true then		
		return
	end



	local PlayerID = GUI.GetPlayerID()
	local CurrentFaith = Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Faith )	
	local BlessCosts = Logic.GetBlessCostByBlessCategory(_BlessCategory)
	
	
	if BlessCosts <= CurrentFaith then
		GUI.BlessByBlessCategory(_BlessCategory)
		
	else	
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_NotEnoughFaith"))
		Sound.PlayFeedbackSound( Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01, 0 )
		
	end
	
end

--------------------------------------------------------------------------------
-- Support for Bless Settlers: callbacks
--------------------------------------------------------------------------------
function GUICallBack_BlessedSettlers(_PlayerID, _NumberOfBlessedSettlers)

	if _PlayerID == GUI.GetPlayerID() and _NumberOfBlessedSettlers > 0 then
		GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_SettlersBlessed"))			
		Sound.PlayGUISound( Sounds.Buildings_Monastery, 0 ) 
		Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_SettlersBlessed_rnd_01 , 0 )
	end
end


--------------------------------------------------------------------------------
-- Toggle between settlers and command menu
--------------------------------------------------------------------------------
function GUIAction_ChangeBuildingMenu(_Button)

	XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "BuildingMenuGroup")	
	
	Camera.FollowEntity(0)
	Camera.SetControlMode( 0 )
	
	if _Button == gvGUI_WidgetID.ToBuildingCommandMenu then
		--GameCallback_GUI_SelectionChanged()
		GUI.SetSelectedEntity(GUI.GetSelectedEntity())
		XGUIEng.HighLightButton(gvGUI_WidgetID.ToBuildingSettlersMenu,1)
	else
		XGUIEng.ShowAllSubWidgets(gvGUI_WidgetID.SelectionBuilding,0)
		XGUIEng.ShowWidget( gvGUI_WidgetID.WorkerInBuilding, 1 )
		XGUIEng.ShowWidget(gvGUI_WidgetID.BuildingTabs,1)
		XGUIEng.HighLightButton(gvGUI_WidgetID.ToBuildingCommandMenu,1)
	end
			
end


--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function GUIAction_JumpToSettlerAttachedToSelectedBuilding()
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
	local SettlerID = XGUIEng.GetBaseWidgetUserVariable(MotherContainer, 0)
	if SettlerID == 0 then
		return
	end
	
	GUIAction_FlyToEntity(SettlerID)
	
end


--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function GUIAction_JumpBackToSelectedWorker()
	
	local SelectedEntityID = GUI.GetSelectedEntity()		
	GUIAction_FlyToEntity(SelectedEntityID)
	
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
function GUIAction_JumpBackToSelectedBuilding()
	
	Camera.FollowEntity(0)
		
	local SelectedEntityID = GUI.GetSelectedEntity()		
	GUIAction_FlyToEntity(SelectedEntityID)
	
end

--------------------------------------------------------------------------------
-- AnSu: NOT THE RIGHT PLACE! MAKE SEPERATE SAVEGAME SCRIPT
--------------------------------------------------------------------------------

function GameCallback_GUI_SaveStringInputDone( _Name, _WidgetID )
	
	if _Name == "" then
		return
	end
	
	local SaveGameName	= "Save_" .. _Name
	
	Framework.SaveGame(SaveGameName)
	
	GUIAction_ToggleMenu( XGUIEng.GetWidgetID("MainMenuWindow"),0)
	
	
	GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_GameSaved"))

end


function
GUIAction_ChangeIntoBattleSerf()

	local SelectedEntityIDs = { GUI.GetSelectedEntities() }
	local AmountOfSelectedEntities = table.getn(SelectedEntityIDs)
	
	local SerfTable = {}
	
	for i= 1, AmountOfSelectedEntities,1
	do
		local EntityType = Logic.GetEntityType( SelectedEntityIDs[i] )
		if EntityType == Entities.PU_Serf then
			table.insert (SerfTable,SelectedEntityIDs[i])
		end
	end
	
	local AmountOfSelectedSerfs = table.getn(SerfTable)
	
	for j= 1, AmountOfSelectedSerfs,1
	do
		GUI.ChangeToBattleSerf(SerfTable[j])	
	end
	
	
end

function
GUIAction_ChangeIntoSerf()

	local SelectedEntityIDs = { GUI.GetSelectedEntities() }
	local AmountOfSelectedEntities = table.getn(SelectedEntityIDs)
	
	local SerfTable = {}
	
	for i= 1, AmountOfSelectedEntities,1
	do
		local EntityType = Logic.GetEntityType( SelectedEntityIDs[i] )
		if EntityType == Entities.PU_BattleSerf then
			table.insert (SerfTable,SelectedEntityIDs[i])
		end
	end
	
	local AmountOfSelectedSerfs = table.getn(SerfTable)
	
	for j= 1, AmountOfSelectedSerfs,1
	do
		GUI.ChangeToSerf(SerfTable[j])	
	end
	
end


function
GUIAction_GoBackFromHawkViewInNormalView()
	Camera.SetControlMode( 0 )
	gvCamera.DefaultFlag = 1				
	Camera.ScrollUpdateZMode( 0 )				
	gvGUI.HawkIsFlying = 0
end


---------------------------------------------------------------------------------------
-- function will be called by a button in the interface
---------------------------------------------------------------------------------------
function 
GUIAction_OnlineHelp()
	
	local CurrentTime = Game.RealTimeGetMs() / 1000		
	if 		gvOnlineHelp_LastTimeStarted == nil 
		or 	( CurrentTime - gvOnlineHelp_LastTimeStarted ) > 2.0
	then			
		--get current selection
		local SelectedEntityID = GUI.GetSelectedEntity()
		
		local EntityType = Logic.GetEntityType( SelectedEntityID )
		
		local UpgradeCategory
		
		if Logic.IsBuilding( SelectedEntityID ) == 1 then	
			UpgradeCategory = Logic.GetUpgradeCategoryByBuildingType(EntityType)
		else
			UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory( SelectedEntityID )
		end
		
		
		
		--get random text and sound
		local RandomHelp = XGUIEng.GetRandom(1+ table.getn(HintTable["global"]))
				
		local SpokenText	= Sounds["VoicesMentorHelp_" .. HintTable["global"][RandomHelp]]
		local Text 			= XGUIEng.GetStringTableText("VoicesMentorHelp/" .. HintTable["global"][RandomHelp])
			
		--is something selected
		if SelectedEntityID ~= nil then	
			--YES!
			if HintTable[UpgradeCategory] ~= nil then
		
				-- use text from Upgradecategory		
				SpokenText	= Sounds["VoicesMentorHelp_" .. HintTable[UpgradeCategory]]
				Text 		= XGUIEng.GetStringTableText("VoicesMentorHelp/" .. HintTable[UpgradeCategory])			
			
			end
			
			if Logic.IsWorker(SelectedEntityID) == 1 then
				SpokenText	= Sounds.VoicesMentorHelp_UNIT_Workers
				Text 		= XGUIEng.GetStringTableText("VoicesMentorHelp/UNIT_Workers")
			end
			
			
			if Logic.IsHero(SelectedEntityID) == 1 then
				SpokenText	= Sounds.VoicesMentorHelp_UNIT_Heroes
				Text 		= XGUIEng.GetStringTableText("VoicesMentorHelp/UNIT_Heroes")
			end
			
			if GUIAction_AOOnlineHelp ~= nil then
				SpokenText, Text = GUIAction_AOOnlineHelp(SelectedEntityID, SpokenText, Text)
			end
		
			
		end
	
		Sound.StartOnlineHelpSound(SpokenText, 0)	
	
		gvOnlineHelp_LastTimeStarted = CurrentTime
	
		--display text
		GUI.ClearNotes()
		GUI.AddNote(Text)
	end
end


function
GUIAction_ToDestroyBuildingWindow()
	XGUIEng.ShowAllSubWidgets(gvGUI_WidgetID.SelectionBuilding,0)	
	XGUIEng.ShowWidget(gvGUI_WidgetID.DestroyBuildingConfirmation ,1)
	
end

function
GUIAction_DoNotDestroyBuilding()
	GUI.SetSelectedEntity(GUI.GetSelectedEntity())
	XGUIEng.HighLightButton(gvGUI_WidgetID.ToBuildingSettlersMenu,1)
end



function
GUIAction_ToggleMinimap(_mode)
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "MinimapButtons")	
	XGUIEng.HighLightButton(CurrentWidgetID,1)
	GUI.SetMiniMapMode(_mode)
	
end

gvInterface_LastWorkerNoResidenceID = 0
gvInterface_LastWorkerNoFarmID = 0

function
GUIAction_ToNextWorkerNoResidence()

	if GDB.GetValue( "Game\\HighlightNewWorkerHaveNoFarmOrResidenceButtonsFlag" ) == 0 then	
		GDB.SetValue( "Game\\HighlightNewWorkerHaveNoFarmOrResidenceButtonsFlag", 1 )
		Trigger.UnrequestTrigger(gvGUI.HighlightNewWorkerHaveNoFarmOrResidenceButtonsTrigger)		
	end

	local PlayerID = GUI.GetPlayerID()	
	local CurrentWorkerID = Logic.GetNextWorkerWithoutResidence(PlayerID, gvInterface_LastWorkerNoResidenceID)		
	local WorkerNoResidenceAmount = Logic.GetNumberOfWorkerWithoutSleepPlace(PlayerID) 


	if WorkerNoResidenceAmount > 0 then
		if CurrentWorkerID ~= 0 then					
			GUI.ClearSelection()
			local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( CurrentWorkerID )
			Camera.ScrollSetLookAt(IDPosX, IDPosY)	
						
			GUI.SelectEntity( CurrentWorkerID )	
		end
			
		gvInterface_LastWorkerNoResidenceID = CurrentWorkerID
		
	end
	
end


function
GUIAction_ToNextWorkerNoFarm()

	if GDB.GetValue( "Game\\HighlightNewWorkerHaveNoFarmOrResidenceButtonsFlag" ) == 0 then	
		GDB.SetValue( "Game\\HighlightNewWorkerHaveNoFarmOrResidenceButtonsFlag", 1 )
		Trigger.UnrequestTrigger(gvGUI.HighlightNewWorkerHaveNoFarmOrResidenceButtonsTrigger)		
	end

	local PlayerID = GUI.GetPlayerID()	
	local CurrentWorkerID = Logic.GetNextWorkerWithoutFarm(PlayerID, gvInterface_LastWorkerNoFarmID)		
	local WorkerNoFarmAmount = Logic.GetNumberOfWorkerWithoutEatPlace(PlayerID) 


	if WorkerNoFarmAmount > 0 then
		if CurrentWorkerID ~= 0 then					
			GUI.ClearSelection()
			local IDPosX, IDPosY, IDPosZ = Logic.EntityGetPos( CurrentWorkerID )
			Camera.ScrollSetLookAt(IDPosX, IDPosY)	
						
			GUI.SelectEntity( CurrentWorkerID )	
		end
			
		gvInterface_LastWorkerNoFarmID = CurrentWorkerID
		
	end

end