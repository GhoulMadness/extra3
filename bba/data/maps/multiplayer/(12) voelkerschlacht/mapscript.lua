--------------------------------------------------------------------------------
-- MapName: (12) Völkerschlacht
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 2

function GameCallback_OnGameStart()

	-- Include global tool script functions
	Script.Load(Folders.MapTools.."Ai\\Support.lua")
	Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua" )
	Script.Load( "Data\\Script\\MapTools\\Tools.lua" )
	Script.Load( "Data\\Script\\MapTools\\WeatherSets.lua" )
	IncludeGlobals("Comfort")
	Script.Load( Folders.MapTools.."Main.lua" )
	IncludeGlobals("MapEditorTools")
	Script.Load( "Data\\Script\\MapTools\\Counter.lua" )
	IncludeGlobals("Tools\\BSinit")

	-- custom Map Stuff
	TagNachtZyklus(24,0,1,-4,1)

	-- Init  global MP stuff
	if CNetwork then
		SetUpGameLogicOnMPGameConfigLight()
	end
	for i = 1, 12 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		Logic.SetPlayerPaysLeaderFlag(i, 0)
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	LocalMusic.UseSet = EUROPEMUSIC

	-- nix für Drückeberger : )
	DZTrade_PunishmentJob = function() return true end
	GUIAction_ExpelSettler = function() end
	GUI.SellBuilding = function() end
	GUIAction_ExpelAll = function() end
	XGUIEng.ShowWidget("ChangeIntoSerf",0)
	--
	StartInitialize()

end

function StartInitialize()

	IncludeGlobals("Tools\\ArmyCreator")

	StartCountdown(3,ShowArmyCreatorGUI,false)

	function ArmyCreator.OnSetupFinished()

		Message("Jeder Spieler hat seine Truppenauswahl getroffen. @cr Lasst die Schlacht beginnen. Viel Erfolg!")
		StartSimpleJob("DefeatJob")

		for i = 1,12 do
			ResearchTechnology(Technologies.T_ThiefSabotage,i)
			ResearchTechnology(Technologies.GT_StandingArmy,i)
			ResearchTechnology(Technologies.GT_Tactics,i)
		end

		--[[ActivateShareExploration(1,2,true)
		ActivateShareExploration(1,3,true)
		ActivateShareExploration(2,3,true)
		--
		ActivateShareExploration(4,5,true)
		ActivateShareExploration(5,6,true)
		ActivateShareExploration(4,6,true)
		--
		SetHostile(1,4)
		SetHostile(1,5)
		SetHostile(1,6)
		--
		SetHostile(2,4)
		SetHostile(2,5)
		SetHostile(2,6)
		--
		SetHostile(3,4)
		SetHostile(3,5)
		SetHostile(3,6)		]]

	end
end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
	end
end

function DefeatJob()

	--disabled in SP
	if not CNetwork then
		return true
	end
	for i = 1,12 do
		if not _G["t"..i] then
			_G["t"..i] = {}
		end
		_G["t"..i] = PlayerGetLivingHeroes(i)
	end
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + Logic.GetNumberOfLeader(3) + table.getn(t1) + table.getn(t2) + table.getn(t3)) == 0 then
		if not t1_lost then
			t1_lost = true
		end
	end
	if (Logic.GetNumberOfLeader(4) + Logic.GetNumberOfLeader(5) + Logic.GetNumberOfLeader(6) + table.getn(t4) + table.getn(t5) + table.getn(t6)) == 0 then
		if not t2_lost then
			t2_lost = true
		end
	end
	if (Logic.GetNumberOfLeader(7) + Logic.GetNumberOfLeader(8) + Logic.GetNumberOfLeader(9) + table.getn(t7) + table.getn(t8) + table.getn(t9)) == 0 then
		if not t3_lost then
			t3_lost = true
		end
	end
	if (Logic.GetNumberOfLeader(10) + Logic.GetNumberOfLeader(11) + Logic.GetNumberOfLeader(12) + table.getn(t10) + table.getn(t11) + table.getn(t12)) == 0 then
		if not t4_lost then
			t4_lost = true
		end
	end
	if t1_lost and t2_lost and t3_lost then
		for i = 1,9 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 10,12 do
			Logic.PlayerSetGameStateToWon(i)
		end
		return true
	elseif t1_lost and t2_lost and t4_lost then
		for i = 1,6 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 9,12 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 7,9 do
			Logic.PlayerSetGameStateToWon(i)
		end
		return true
	elseif t1_lost and t3_lost and t4_lost then
		for i = 1,3 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 7,12 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 4,6 do
			Logic.PlayerSetGameStateToWon(i)
		end
		return true
	elseif t2_lost and t3_lost and t4_lost then
		for i = 4,12 do
			Logic.PlayerSetGameStateToLost(i)
		end
		for i = 1,3 do
			Logic.PlayerSetGameStateToWon(i)
		end
		return true

	end
end
function PlayerGetLivingHeroes(_playerID)

	local htable = {}
	Logic.GetHeroes(_playerID, htable)
	for k,v in pairs(htable) do
		if IsDead(v) then
			table.remove(htable,k)
		end
	end
	return htable
end

function SetUpGameLogicOnMPGameConfigLight()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- Transfer player names
	do
		for PlayerID=1, HumenPlayer, 1 do
			local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
			Logic.SetPlayerRawName( PlayerID, PlayerName )
		end
	end

	-- Set game state & human flag - transfer player color (needed in logic for post game statistics)
	do
		for PlayerID=1, HumenPlayer, 1 do
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 1 then
				Logic.PlayerSetGameStateToPlaying( PlayerID )
				Logic.PlayerSetIsHumanFlag( PlayerID, 1 )

				local PlayerColorR, PlayerColorG, PlayerColorB = GUI.GetPlayerColor( PlayerID )
				Logic.PlayerSetPlayerColor( PlayerID, PlayerColorR, PlayerColorG, PlayerColorB )
			end
		end
	end

	-- Set up FoW
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig()


	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)



	--Extra keybings only in MP
	Input.KeyBindDown(Keys.NumPad0, "KeyBindings_MPTaunt(1,1)", 2)  --Yes
	Input.KeyBindDown(Keys.NumPad1, "KeyBindings_MPTaunt(2,1)", 2)  --No
	Input.KeyBindDown(Keys.NumPad2, "KeyBindings_MPTaunt(3,1)", 2)  --Now
	Input.KeyBindDown(Keys.NumPad3, "KeyBindings_MPTaunt(7,1)", 2)  --help
	Input.KeyBindDown(Keys.NumPad4, "KeyBindings_MPTaunt(8,1)", 2)  --clay
	Input.KeyBindDown(Keys.NumPad5, "KeyBindings_MPTaunt(9,1)", 2)  --gold
	Input.KeyBindDown(Keys.NumPad6, "KeyBindings_MPTaunt(10,1)", 2) --iron
	Input.KeyBindDown(Keys.NumPad7, "KeyBindings_MPTaunt(11,1)", 2) --stone
	Input.KeyBindDown(Keys.NumPad8, "KeyBindings_MPTaunt(12,1)", 2) --sulfur
	Input.KeyBindDown(Keys.NumPad9, "KeyBindings_MPTaunt(13,1)", 2) --wood

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "KeyBindings_MPTaunt(5,1)", 2)  --attack here
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "KeyBindings_MPTaunt(6,1)", 2)  --defend here

	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "KeyBindings_MPTaunt(4,0)", 2)  --attack you
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad3, "KeyBindings_MPTaunt(14,0)", 2) --VeryGood
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_MPTaunt(15,0)", 2) --Lame
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_MPTaunt(16,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_MPTaunt(17,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_MPTaunt(18,0)", 2) --funny comments
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_MPTaunt(19,0)", 2) --funny comments

end


