--------------------------------------------------------------------------------
-- MapName: (4) Der Taktiker
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvDiffLVL = 1.5
DamageTracker = {	[1] = 0,
					[2] = 0,
					[3] = 0,
					[4] = 0
				}
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
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()

	-- Init  global MP stuff
	if CNetwork then
		SetUpGameLogicOnMPGameConfigLight()
	end
	for i = 1, 4 do
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

	Display.SetPlayerColorMapping(8,11)

	function ArmyCreator.OnSetupFinished()

		Message("Jeder Spieler hat seine Truppenauswahl getroffen. @cr Ihr habt nun 1 Minute Zeit, Eure Truppen zu postieren, bevor der Weg zum Feind geöffnet wird!")
		StartCountdown(1*60,StartGame,true)

		-- explore mid
		for i = 1,4 do
			Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity,  11200+i, 11200+i, 0, i), 10);
			SetHostile(i,8);
			ResearchTechnology(Technologies.T_ThiefSabotage,i)
			ResearchTechnology(Technologies.GT_StandingArmy,i)
			ResearchTechnology(Technologies.GT_Tactics,i)
		end

		ActivateShareExploration(1,2,true)
		ActivateShareExploration(3,4,true)

	end
end

function StartGame()

	local ids = {Logic.GetEntities(Entities.XD_SnowBarrier1, 10)}
	table.remove(ids,1)
	for i = 1,table.getn(ids) do
		DestroyEntity(ids[i])
	end
	StartSimpleJob("DefeatJob")

	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnRabbitStatueDamaged", 1)

	SetupFlagGUI()

	SetFriendly(1,2)
	SetFriendly(2,1)
	SetFriendly(3,4)
	SetFriendly(4,3)
	SetHostile(1,3)
	SetHostile(3,1)
	SetHostile(1,4)
	SetHostile(4,1)
	SetHostile(2,3)
	SetHostile(3,2)
	SetHostile(4,2)
	SetHostile(2,4)

	GameCallback_BombExplodesOrig = GameCallback_BombExplodes
	GameCallback_KegExplodesOrig = GameCallback_KegExplodes

end

function ShowArmyCreatorGUI()
	if GUI.GetPlayerID() ~= 17 then
		XGUIEng.ShowWidget("Normal",0)
		XGUIEng.ShowWidget("BS_ArmyCreator",1)
	end
end

function EndTimer()

	MapEnded = true;
	local dmgTeam1 = DamageTracker[1] + DamageTracker[2];
	local dmgTeam2 = DamageTracker[3] + DamageTracker[4];
	local dmgTotal = dmgTeam1 + dmgTeam2;
	local winningTeam = "";
	local losingTeam = "";
	local winnerDmg = 0;
	local loserDmg = 0;
	local diff = 0;
	if dmgTeam1 > dmgTeam2 then
		winningTeam = WT21.TeamString1;
		losingTeam = WT21.TeamString2;
		winnerDmg = dmgTeam1;
		loserDmg = dmgTeam2;
		diff = dmgTeam1-dmgTeam2;
	else
		winningTeam = UserTool_GetPlayerName(1).." & "..UserTool_GetPlayerName(2);
		losingTeam = UserTool_GetPlayerName(3).." & "..UserTool_GetPlayerName(4);
		winnerDmg = dmgTeam2;
		loserDmg = dmgTeam1;
		diff = dmgTeam2-dmgTeam1;
	end
	GUI.AddStaticNote("@color:0,255,0 Team " .. winningTeam .. " gewinnt mit " .. winnerDmg .. " Schaden an der mysteriösen Statue!");
	GUI.AddStaticNote("@color:0,255,0 Sie haben damit " .. diff .. " mehr Schaden angerichtet als " .. losingTeam .. " mit " .. loserDmg .. " Schaden!");

end

function OnRabbitStatueDamaged()

	if MapEnded then

		return true

	end

	local attacker = Event.GetEntityID1()

    local target = Event.GetEntityID2();

	local targettype = Logic.GetEntityType(target)

	local player = GetPlayer(attacker)

    local dmg = CEntity.TriggerGetDamage();

	if targettype == Entities.CB_RabbitStatue then

		if DamageTracker[player] then

			DamageTracker[player] = DamageTracker[player] + dmg

			UpdateScoreBars();

		end

	end

end;

function GameCallback_KegExplodes(_kegid, _range, _damage)

	DamageTracker[Logic.EntityGetPlayer(_kegid)] = DamageTracker[Logic.EntityGetPlayer(_kegid)] + _damage
	UpdateScoreBars();
	return _range, _damage

end

function GameCallback_BombExplodes(_bombid, _range, _damage)

	DamageTracker[Logic.EntityGetPlayer(_bombid)] = DamageTracker[Logic.EntityGetPlayer(_bombid)] + _damage
	UpdateScoreBars();
	return _range, _damage

end

function DefeatJob()

	if not EndCounter then
		EndCounter = StartCountdown(10*60,EndTimer,true)
	end
	--disabled in SP
	if not CNetwork then
		return true
	end
	local t1,t2,t3,t4 = {},{},{},{}
	for i = 1,4 do
		_G["t"..i] = PlayerGetLivingHeroes(i)
	end
	if (Logic.GetNumberOfLeader(1) + Logic.GetNumberOfLeader(2) + table.getn(t1) + table.getn(t2)) == 0 then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.PlayerSetGameStateToWon(3)
		Logic.PlayerSetGameStateToWon(4)
		return true
	end
	if (Logic.GetNumberOfLeader(3) + Logic.GetNumberOfLeader(4) + table.getn(t3) + table.getn(t4)) == 0 then
		Logic.PlayerSetGameStateToLost(3)
		Logic.PlayerSetGameStateToLost(4)
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
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
function ColorGrade(_c1, _c2, _lambda)
	return math.clamp(math.abs(math.floor(_c1*_lambda + _c2*(1-_lambda))),0,255);
end

function math.clamp(_v, _min, _max)
	return math.max(math.min(_v, _max), _min);
end

-- points needed
ScoreDiffMax = 100000
-- current score difference
ScoreDiff = 0

function UpdateScoreBars()
	 ScoreDiff = math.min(math.abs( (DamageTracker[1] + DamageTracker[2]) - (DamageTracker[3] + DamageTracker[4])), ScoreDiffMax);
	XGUIEng.SetProgressBarValues("VCMP_Team1Progress", ScoreDiff,  ScoreDiffMax);
	if  (DamageTracker[1] + DamageTracker[2]) >  (DamageTracker[3] + DamageTracker[4]) then
		XGUIEng.SetText("VCMP_Team1Name", "(" .. math.floor( ScoreDiff) .. "/" ..  ScoreDiffMax .. ") " ..
		 GetPlayerColorString(1) .. " " .. UserTool_GetPlayerName(1) .. " @color:255,255,255,255 & "
		..  GetPlayerColorString(2) .. " " .. UserTool_GetPlayerName(2));
	elseif  (DamageTracker[1] + DamageTracker[2]) <  (DamageTracker[3] + DamageTracker[4]) then
		XGUIEng.SetText("VCMP_Team1Name", "(" .. math.floor( ScoreDiff) .. "/" ..  ScoreDiffMax .. ") " ..
		 GetPlayerColorString(3) .. " " .. UserTool_GetPlayerName(3) .. " @color:255,255,255,255 & "
		..  GetPlayerColorString(4) .. " " .. UserTool_GetPlayerName(4));
	else
		XGUIEng.SetText("VCMP_Team1Name", "(" ..  ScoreDiff .. "/" ..  ScoreDiffMax .. ")  Gleichstand");
	end
end
function GetPlayerColorString(_playerId)
	local r,g,b = GUI.GetPlayerColor(_playerId);
	return " @color:"..r..","..g..","..b.." ";
end
function SetupFlagGUI()
	-- gradient 30, 150 to 255,242 to 255,0
	local r,g,b;
	local timeProgress;
	GUIUpdate_VCTechRaceProgress = function()
		if  (DamageTracker[1] + DamageTracker[2]) >  (DamageTracker[3] + DamageTracker[4]) then
			local r1,g1,b1 = GUI.GetPlayerColor(1);
			local r2,g2,b2 = GUI.GetPlayerColor(2);
			timeProgress = math.max(math.min(math.sin(0.25*XGUIEng.GetSystemTime()), 0.5), -0.5) + 0.5;
			r =  ColorGrade(r1,r2, timeProgress);
			g =  ColorGrade(g1,g2, timeProgress);
			b =  ColorGrade(b1,b2, timeProgress);

			XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 255)
		elseif  (DamageTracker[1] + DamageTracker[2]) <  (DamageTracker[3] + DamageTracker[4]) then
			local r1,g1,b1 = GUI.GetPlayerColor(3);
			local r2,g2,b2 = GUI.GetPlayerColor(4);
			timeProgress = math.max(math.min(math.sin(0.25*XGUIEng.GetSystemTime()), 0.5), -0.5) + 0.5;
			r =  ColorGrade(r1,r2, timeProgress);
			g =  ColorGrade(g1,g2, timeProgress);
			b =  ColorGrade(b1,b2, timeProgress);

			XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 255)
		else
			local r1,g1,b1 = GUI.GetPlayerColor(11);
			local r2,g2,b2 = GUI.GetPlayerColor(13);
			timeProgress = math.max(math.min(math.sin(0.25*XGUIEng.GetSystemTime()), 0.5), -0.5) + 0.5;
			r =  ColorGrade(r1,r2, timeProgress);
			g =  ColorGrade(g1,g2, timeProgress);
			b =  ColorGrade(b1,b2, timeProgress);

			XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 255)
		end
	end
	GUIUpdate_VCTechRaceColor = function()end

	-- napo
	local barLength = 250
	local textBoxSize = 15
	--local barHeight = 4
	local barHeight = 10
	local heightElement = 25
	XGUIEng.SetWidgetSize( "VCMP_Window", 252, 294)
	XGUIEng.ShowWidget( "VCMP_Window", 1)
	XGUIEng.ShowAllSubWidgets( "VCMP_Window",1)
	for i = 1, 8 do
		for j = 1, 8 do
			XGUIEng.ShowWidget( "VCMP_Team"..i.."Player"..j, 0)
		end
		XGUIEng.SetWidgetSize( "VCMP_Team"..i, 252, 32)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."Name", 252, 32)
		XGUIEng.ShowWidget( "VCMP_Team"..i.."_Shade", 0)
		XGUIEng.SetMaterialColor( "VCMP_Team"..i.."Name", 0, 0, 0, 0, 0) --hide BG by using alpha = 0s
		XGUIEng.ShowWidget( "VCMP_Team"..i.."PointGame", 0)


		-- manage progress bars
		XGUIEng.ShowWidget( "VCMP_Team"..i.."TechRace", 1)
		XGUIEng.ShowAllSubWidgets( "VCMP_Team"..i.."TechRace", 1)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."TechRace", barLength, barHeight)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."Progress", barLength, barHeight)
		XGUIEng.SetWidgetSize( "VCMP_Team"..i.."ProgressBG", barLength, barHeight)

		-- widget positions to set
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i, 0, heightElement*(i-1))
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i.."Name", 0, 0)
		XGUIEng.SetWidgetPosition( "VCMP_Team"..i.."TechRace", 0, textBoxSize)
	end
	for i = 2, 8 do
		XGUIEng.ShowWidget("VCMP_Team"..i, 0);
		XGUIEng.ShowWidget("VCMP_Team"..i.."_Shade", 0);
	end
	local r,g,b;
	r,g,b = GUI.GetPlayerColor(11);
	XGUIEng.SetText("VCMP_Team1Name", "(" ..  ScoreDiff .. "/" ..  ScoreDiffMax .. ")  Gleichstand");
	XGUIEng.SetMaterialColor("VCMP_Team1Progress", 0, r, g, b, 150)
end
function GetPlayerIDsByTeamID(_TeamID)
	if _TeamID == 1 then
		return 1,2
	elseif _TeamID == 2 then
		return 3,4
	else
		return 0,0
	end
end
function GetTeamIDByPlayerID(_playerId)
	return math.ceil(_playerId/2)
end
function GetEnemyTeamIDByPlayerID(_playerId)
	if _playerId <= 2 then
		return 2
	else
		return 1
	end
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


