-- Kartenname: Im Graben der Verdammnis
-- Author:     totalwarANGEL, [insert name here]
-- Version:    1.0

initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not initEMS() then
	local errMsgs =
	{
		["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr \195\156berpr\195\188fe ob alle Dateien am richtigen Ort sind!",
		["eng"] = "Attention: Enhanced Multiplayer Script could not be found! @cr Make sure you placed all the files in correct place!",
	}
	local lang = "de";
	if XNetworkUbiCom then
		lang = XNetworkUbiCom.Tool_GetCurrentLanguageShortName();
		if lang ~= "eng" and lang ~= "de" then
			lang = "eng";
		end
	end
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	GUI.AddStaticNote("@color:255,0,0 " .. errMsgs[lang]);
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	return;
end
gvEMSFlag = 1
gvXmas2021ExpFlag = 1
-- ************************************************************************************************
-- *                                                                                              *
-- *                                                                                              *
-- *                                              EMS                                             *
-- *                                         CONFIGURATION                                        *
-- *                                                                                              *
-- *                                                                                              *
-- ************************************************************************************************

EMS_CustomMapConfig =
{
	Version = 1.2,
	ActivateDebug = false,

	Callback_OnMapStart = function()
		AddPeriodicSummer(10);
		LocalMusic.UseSet = EVELANCEMUSIC;
		IncludeGlobals("Tools\\BSinit")
		local resourceTable = {
			{Entities.XD_Stone1, 4000},
			{Entities.XD_Iron1, 4000},
			{Entities.XD_Clay1, 4000},
			{Entities.XD_Sulfur1, 4000}
		}
		MapTools.SetMapResource(resourceTable);
		WT21.Setup();
	end,

	Callback_OnGameStart = function()
		StartSimpleJob("WT21_KerbeRevive");
		WT21.CountdownId = EMS.T.StartCountdown( 60*60, WT21.TimeEnd, true );
		for i = 1,4 do
			ForbidTechnology(Technologies.B_Dome,i)
		end
		TagNachtZyklus(24,0,0,0,1)
		do
			local posleft = GetPosition("OuterSpawn2")
			local posright = GetPosition("OuterSpawn1")
			Logic.CreateEffect(GGL_Effects.FXAshFlakes,posleft.X,posleft.Y)
			Logic.CreateEffect(GGL_Effects.FXEmbers,posleft.X,posleft.Y)
			Logic.CreateEffect(GGL_Effects.FXAshFlakes,posright.X,posright.Y)
			Logic.CreateEffect(GGL_Effects.FXEmbers,posright.X,posright.Y)
			Logic.CreateEffect(GGL_Effects.FXAshFlakes,35250,1450)
			Logic.CreateEffect(GGL_Effects.FXEmbers,35250,1450)
			Logic.CreateEffect(GGL_Effects.FXAshFlakes,35250,69000)
			Logic.CreateEffect(GGL_Effects.FXEmbers,35250,69000)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,30100,66900)
			Logic.CreateEffect(GGL_Effects.FXFireLo,30090,66890)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,28030,69100)
			Logic.CreateEffect(GGL_Effects.FXFireLo,28020,69090)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,31200,64900)
			Logic.CreateEffect(GGL_Effects.FXFireLo,31190,64890)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,30650,68400)
			Logic.CreateEffect(GGL_Effects.FXFireLo,30640,68390)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,39800,68400)
			Logic.CreateEffect(GGL_Effects.FXFireLo,39790,68390)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,40400,66900)
			Logic.CreateEffect(GGL_Effects.FXFireLo,40390,66890)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,42500,69100)
			Logic.CreateEffect(GGL_Effects.FXFireLo,42490,69090)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,39300,64900)
			Logic.CreateEffect(GGL_Effects.FXFireLo,39290,64890)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,31200,5600)
			Logic.CreateEffect(GGL_Effects.FXFireLo,31190,5590)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,30100,3600)
			Logic.CreateEffect(GGL_Effects.FXFireLo,30090,3590)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,28030,1400)
			Logic.CreateEffect(GGL_Effects.FXFireLo,28020,1390)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,30650,2070)
			Logic.CreateEffect(GGL_Effects.FXFireLo,30640,2060)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,39800,2070)
			Logic.CreateEffect(GGL_Effects.FXFireLo,39790,2060)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,40400,3600)
			Logic.CreateEffect(GGL_Effects.FXFireLo,40390,3590)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,42500,1370)
			Logic.CreateEffect(GGL_Effects.FXFireLo,42490,1360)

			Logic.CreateEffect(GGL_Effects.FXFireSmall,39300,5600)
			Logic.CreateEffect(GGL_Effects.FXFireLo,39290,5590)
			--
			--Monastery attacker army techs
			ResearchTechnology(Technologies.T_WoodAging,5)
			ResearchTechnology(Technologies.T_Turnery,5)
			ResearchTechnology(Technologies.T_MasterOfSmithery,5)
			ResearchTechnology(Technologies.T_IronCasting,5)
			ResearchTechnology(Technologies.T_Fletching,5)
			ResearchTechnology(Technologies.T_BodkinArrow,5)
			ResearchTechnology(Technologies.T_EnhancedGunPowder,5)
			ResearchTechnology(Technologies.T_BlisteringCannonballs,5)
			ResearchTechnology(Technologies.T_PaddedArcherArmor,5)
			ResearchTechnology(Technologies.T_LeatherArcherArmor,5)
			ResearchTechnology(Technologies.T_ChainMailArmor,5)
			ResearchTechnology(Technologies.T_PlateMailArmor,5)
		end
	end,

	Callback_OnPeacetimeEnded = function()
	end,

	Peacetime = 0,

	GameMode = 1,
	GameModes = {"Standard"},
	Callback_GameModeSelected = function(_gamemode)
	end,

	Ressources =
	{
		Normal = {
			[1] = {
				500,
				2750,
				2400,
				900,
				50,
				50,
			},
		},
	},

	Callback_OnFastGame = function()
	end,

	HeavyCavalry = 2,
	LightCavalry = 2,
	Rifle = 2,
	Thief = 1,
	Scout = 1,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,
	Markets = 0,

	TowerLevel = 3,

	TowerLimit = 8,

};

WT21 = {};

function WT21.Setup()
    if not CEntity then
        Message("This map needs to be started in extended singleplayer");
    end
	-- explore mid
	for i = 1,4 do
		Logic.SetEntityExplorationRange(Logic.CreateEntity(Entities.XD_ScriptEntity,  35000+i, 35000+i, 0, i), 20);
        SetHostile(i,5);
	end

	WT21.TotalHitpoints =
	{
		1, -- team1
		1, -- team2
		2, -- total
	};
	-- innerhalb dieser Reichweite kann in der Mitte nichts außer Dario Statuen gebaut werden
	WT21.CenterBlockRange = 5000

	-- kerbe
	--InstallS5Hook()
   SW.SV.Init()
   MeteorSys.Init()
   local pos = GetPosition("center")
   Raidboss.Init(Logic.CreateEntity(Entities.CU_BlackKnight, pos.X, pos.Y, 0 , 5))

	WT21.ChurchBonus = {[1]=0,[2]=0}; -- church bonus, number of churches

	WT21.InitChurchControl()
	WT21.InitDario()
	WT21.SetupKerbeHPBar();

	WT21.UnlimitedArmies();

	Display.SetPlayerColorMapping(5,12);
	Display.SetPlayerColorMapping(8,12);

	-- defense
	SW.SetCannonReloadTime(Entities.PB_DarkTower3_Cannon, 200);
	SW.SetCannonDamage(Entities.PB_DarkTower3_Cannon, 1000);
	SW.SetCannonDamageRange(Entities.PB_DarkTower3_Cannon, 1000);
	SW.SetCannonRotationSpeedRad(Entities.PB_DarkTower3_Cannon, 3);
	for i = 1,20 do
		MakeInvulnerable("t" ..i);
	end
	for i = 1,4 do
		SetHostile(i,8);
	end

	WT21.FinalCountdown = 60*60;
	WT21.KerbeReviveCounterMax = 3*60;
	WT21.KerbeReviveCounter = WT21.KerbeReviveCounterMax;
end

function WT21.TimeEnd()
	WT21.LeadCounter = 30*60; -- max 60 more minutes
	EMS.T.StopCountdown(WT21.CountdownId);
	WT21.CountdownId = EMS.T.StartCountdown( WT21.LeadCounter, function() end, true );
	if WT21.Has10kLead() then
		WT21.EndTheGame();
		return;
	else
		Message("@color:255,165,0 Kampf bis ein Team 10.000 Punkte Fortschritt hat!");
	end
	StartSimpleJob("WT21_Need10kLead");
end

function WT21.Has10kLead()
	local dmgTeam1 = Raidboss.DamageTracker[1] + Raidboss.DamageTracker[2];
	local dmgTeam2 = Raidboss.DamageTracker[3] + Raidboss.DamageTracker[4];
	return math.abs(dmgTeam1-dmgTeam2) >= 10000;
end

function WT21_Need10kLead()
	WT21.LeadCounter = WT21.LeadCounter - 1;
	if WT21.LeadCounter <= 0 then
		WT21.EndTheGame();
		return true;
	end
	if WT21.Has10kLead() then
		WT21.EndTheGame();
		return true;
	end
end

function WT21.EndTheGame()
	EMS.T.StopCountdown(WT21.CountdownId);
	WT21.Ended = true;
	local dmgTeam1 = Raidboss.DamageTracker[1] + Raidboss.DamageTracker[2];
	local dmgTeam2 = Raidboss.DamageTracker[3] + Raidboss.DamageTracker[4];
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
		winningTeam = WT21.TeamString2;
		losingTeam = WT21.TeamString1;
		winnerDmg = dmgTeam2;
		loserDmg = dmgTeam1;
		diff = dmgTeam2-dmgTeam1;
	end
	GUI.AddStaticNote("@color:0,255,0 Team " .. winningTeam .. " gewinnt mit " .. winnerDmg .. " Schaden an Kerberos!");
	GUI.AddStaticNote("@color:0,255,0 Sie haben damit " .. diff .. " mehr Schaden angerichtet als " .. losingTeam .. " mit " .. loserDmg .. " Schaden!");
end

function WT21_KerbeRevive()
	WT21.FinalCountdown = WT21.FinalCountdown - 1;
	if Logic.GetEntityHealth(Raidboss.eId) <= 0 then
		if WT21.KerbeReviveCounter > 0 then
			WT21.KerbeReviveCounter = WT21.KerbeReviveCounter - 1;
		else
			--S5Hook.GetEntityMem(Raidboss.eId)[31][3][5]:SetInt(11000)
			--S5Hook.GetEntityMem(Raidboss.eId)[31][3][7]:SetInt(1)
			local pos = GetPosition(Raidboss.eId);
			DestroyEntity(Raidboss.eId);
			Raidboss.eId = Logic.CreateEntity(Entities.CU_BlackKnight, pos.X, pos.Y, 0, Raidboss.pId);
			Logic.HurtEntity(Raidboss.eId, Raidboss.MaxHealth/2);
			S5Hook.GetEntityMem( Raidboss.eId)[25]:SetFloat( Raidboss.Scale);
			S5Hook.GetEntityMem( Raidboss.eId)[31][1][5]:SetFloat( Raidboss.MovementSpeed);
			WT21.KerbeReviveCounter = WT21.KerbeReviveCounterMax;
		end
	end
end

-- Test(GUI.Debug_GetMapPositionUnderMouse())
Field = {};

function Test(_x,_y) -- effekte
    XX = _x; YY = _y;
    StartSimpleHiResJob("produceballs");
    StartSimpleHiResJob("LowerBalls")
end
function produceballs()
    SpawnFireBall(XX,YY);
    if(Logic.GetRandom(1) == 1) then
        SpawnFireBall(XX,YY);
    end
    if(Logic.GetRandom(1) == 1) then
        SpawnFireBall(XX,YY);
    end
    if(Logic.GetRandom(1) == 1) then
        SpawnFireBall(XX,YY);
    end
end

function SpawnFireBall(_x, _y)
        e = Logic.CreateEntity(Entities.CB_Camp23, _x+Logic.GetRandom(500), _y+Logic.GetRandom(500), 0, 0);
        Logic.SetModelAndAnimSet(e, Models.XD_CannonBall)
        S5Hook.GetEntityMem(e)[76]:SetFloat(400); -- height
		S5Hook.GetEntityMem(e)[25]:SetFloat(4);

        CUtil.SetEntityDisplayName(e, "");
        Field[e] = {Entity=e,Height=400};
end

function LowerBalls()
    for k,v in pairs(Field) do
        v.Height = v.Height - 8;
        if v.Height <= -3 then
            DestroyEntity(v.Entity);
            Field[k] = nil;
        else
            S5Hook.GetEntityMem(v.Entity)[76]:SetFloat(v.Height);
        end
    end
end


function start()
	areaX, areaY = GUI.Debug_GetMapPositionUnderMouse();
	local offsetx = math.floor(areaX/100);
	local offsety = math.floor(areaY/100);
	local range = 100;
	Map = {}
	for x = 1, range do
		Map[x] = {}
		for y = 1, range do
			Map[x][y] = CUtil.GetTerrainInfo((offsetx + x)*100,(offsety + y)*100);
		end
	end
	StartSimpleHiResJob("areaWave")
end

-- areaWave(GUI.Debug_GetMapPositionUnderMouse())
function areaWave()
	local offsetx = math.floor(areaX/100);
	local offsety = math.floor(areaY/100);
	local range = 100;
	for x = 1, range do
		for y = 1, range do
			--local currHeight = CUtil.GetTerrainInfo((offsetx + x)*100,(offsety + y)*100);

			Logic.SetTerrainNodeHeight(offsetx+x, offsety+y, Map[x][y]+math.cos(x+Logic.GetTime())*100); -- waves
		end
	end
end

function ScanMap()
	MovingAreas = {};
	for x = 1, Logic.WorldGetSize()/100 do
		for y = 1, Logic.WorldGetSize()/100 do
			if CUtil.GetTerrainNodeType(x,y) == 138 then
				table.insert(MovingAreas,{x,y,CUtil.GetTerrainInfo(x*100,y*100)});
			end
		end
	end
	StartSimpleHiResJob("MoveLava")
end

function MoveLava()
	local data;
	local heightvalue;
	local speed = 1.0;
	local wavelengthModifier = 3; -- the bigger, the longer a wave
	local magnitude = 30;
	for i = 1, table.getn(MovingAreas) do
		data = MovingAreas[i];
		heightvalue = (math.cos(data[1]/wavelengthModifier + Logic.GetTime()*speed)+math.cos( (data[2]+1)/wavelengthModifier + Logic.GetTime()*speed)) * magnitude;
		Logic.SetTerrainNodeHeight(data[1], data[2], data[3] + heightvalue );
	end
end


function erd()
	erdBeben, erdBeben = GUI.Debug_GetMapPositionUnderMouse();
	local offsetx = math.floor(areaX/100);
	local offsety = math.floor(areaY/100);
	local range = 20;
	Map = {}
	for x = -range, range do
		Map[x] = {}
		for y = -range, range do
			Map[x][y] = CUtil.GetTerrainInfo((offsetx + x)*100,(offsety + y)*100);
		end
	end
	StartSimpleHiResJob("circleWave")
end

function circleWave()
	local data;
	local heightvalue;
	local speed = 1.0;
	local wavelengthModifier = 3; -- the bigger, the longer a wave
	local magnitude = 20;
	for i = 1, table.getn(MovingAreas) do
		data = MovingAreas[i];
		Logic.SetTerrainNodeHeight(data[1], data[2], data[3] + heightvalue );
	end
end

function WT21.AddHitpoints(_teamId, _hitpoints)
	WT21.TotalHitpoints[_teamId] = WT21.TotalHitpoints[_teamId] + _hitpoints;
	WT21.TotalHitpoints[3] = WT21.TotalHitpoints[3] + _hitpoints;
end

function WT21.SetupKerbeHPBar()
	XGUIEng.ShowWidget("EMSMAWT21",1);
	WT21.IsBossBarVisible = 1
	WT21.TeamString1 = UserTool_GetPlayerName(1).." & "..UserTool_GetPlayerName(2);
	WT21.TeamString2 = UserTool_GetPlayerName(3).." & "..UserTool_GetPlayerName(4);
	XGUIEng.SetText("EMSMAWT21Text1", WT21.TeamString1);
	XGUIEng.SetText("EMSMAWT21Text2", WT21.TeamString2);
	Input.KeyBindDown( Keys.OemBackslash, "WT21_ToggleBossBar()", 2)
end
function WT21_ToggleBossBar()
	WT21.IsBossBarVisible = 1 - WT21.IsBossBarVisible
	XGUIEng.ShowWidget( "EMSMAWT21", WT21.IsBossBarVisible)
end

function GUIUpdate_WT21_UpdateHealthBar()
	if WT21.Ended then return true end
	local barLengthTotal = 824; -- width defined by gui
	local dmgTeam1 = Raidboss.DamageTracker[1] + Raidboss.DamageTracker[2];
	local dmgTeam2 = Raidboss.DamageTracker[3] + Raidboss.DamageTracker[4];
	local dmgTotal = dmgTeam1 + dmgTeam2;
	local percentage = (dmgTeam1+1)/(dmgTotal+2);
	local width1 = barLengthTotal * percentage;
	local width2 = barLengthTotal * (1-percentage);
	local xOffset2 = 100 + width1;
	XGUIEng.SetWidgetPositionAndSize( "EMSMAWT21Bar1", 100, 0, width1, 10 );
	XGUIEng.SetWidgetPositionAndSize( "EMSMAWT21Bar2", xOffset2, 0, width2, 10 );

	-- info strings
	local churchBonus = {"",""};
	for i = 1,2 do
		if WT21.DariosActive[i] > 0 then
			churchBonus[i] = "@color:255,0,0 (+"..WT21.DariosActive[i]..")"
		end
		if WT21.ChurchBonus[i] > 0 then
			churchBonus[i] = churchBonus[i] .. " @color:255,131,0 (x"..(WT21.ChurchBonus[i]+1)..")";
		end
	end


	XGUIEng.SetText("EMSMAWT21Text1", "@center "..WT21.TeamString1 .. " ".. churchBonus[1]);
	XGUIEng.SetText("EMSMAWT21Text2", "@center "..WT21.TeamString2 .. " ".. churchBonus[2]);

	XGUIEng.SetText("EMSMAWT21Score", "@center "..dmgTeam1 .."  ----|---- "..dmgTeam2.."");
end

function WT21.InitChurchControl()
	WT21.Church={{eId=0,Owner=0},
	{eId=0,Owner=0}};
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, "", "WT21_Church_OnEntityCreated", 1)
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "WT21_Church_OnEntityDestroyed", 1)
	StartSimpleJob("WT21_ChurchCompleteController");
end

function WT21.GetDistance( _p1, _p2)
	local dX = _p1.X - _p2.X
	local dY = _p1.Y - _p2.Y
	return math.sqrt(dX*dX + dY*dY);
end

function WT21_Church_OnEntityCreated()
	local entity = Event.GetEntityID();
	if Logic.GetEntityType(entity) ~= Entities.PB_Monastery1 then
		return;
	end
	local pos = GetPosition(entity);
	local churchRange = 1000;
	if WT21.GetDistance(pos,GetPosition("church1")) < churchRange then
		WT21.Church[1]={eId=entity,Owner=0};
	elseif WT21.GetDistance(pos,GetPosition("church2")) < churchRange then
		WT21.Church[2]={eId=entity,Owner=0};
	end
end

function WT21_Church_OnEntityDestroyed()
	local entity = Event.GetEntityID();
	for i = 1,2 do
		if WT21.Church[i].eId == entity then
			WT21.Church[i]={eId=0,Owner=0};
			WT21.CalculateChurchBonus();
		end
	end
end

function WT21.GetTeam(_Id)
	if _Id == nil then return 0; end
	if _Id > 0 and _Id <= 2 then
		return 1;
	elseif
		_Id <=4 then
		return 2;
	else
		return 0;
	end
end

function WT21_ChurchCompleteController()
	for i = 1,2 do
		if WT21.Church[i].Owner == 0 then
			if Logic.IsConstructionComplete(WT21.Church[i].eId) == 1 then
				WT21.Church[i].Owner = WT21.GetTeam(GetPlayer(WT21.Church[i].eId));
				WT21.CalculateChurchBonus();
			end
		end
	end
end

function WT21.CalculateChurchBonus()
	for teamId = 1,2 do
		WT21.ChurchBonus[teamId] = 0;
		for j = 1,2 do
			if WT21.Church[j].Owner == teamId then
				WT21.ChurchBonus[teamId] = WT21.ChurchBonus[teamId] + 1;
			end
		end
	end
	Raidboss.PlayerMultiplier[1] = WT21.ChurchBonus[1]+1;
	Raidboss.PlayerMultiplier[2] = WT21.ChurchBonus[1]+1;
	Raidboss.PlayerMultiplier[3] = WT21.ChurchBonus[2]+1;
	Raidboss.PlayerMultiplier[4] = WT21.ChurchBonus[2]+1;
	if not WT21.ArmyJob then
		WT21.ArmyJob = StartSimpleJob("WT21_ArmyController");
	end
end

function WT21.InitDario()
	WT21.DariosActive = {0,0}; -- number of darios that count into damage
	WT21.DariosInConstruction = {};
	WT21.Darios = {};
	WT21.DarioEffects = {}
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, "", "WT21_Dario_OnEntityCreated", 1)
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "WT21_Dario_OnEntityDestroyed", 1)
	StartSimpleJob("WT21_DarioCompleteController");
	StartSimpleHiResJob("WT21_DarioEffectHandler")
end

function WT21_Dario_OnEntityCreated()
	local entity = Event.GetEntityID();
	if Logic.GetEntityType(entity) ~= Entities.PB_Beautification01 then
		return;
	end
	local pos = GetPosition(entity);
	local darioRange = 3000;
	--Message("distance " .. WT21.GetDistance(pos,GetPosition("center")));
	if WT21.GetDistance(pos,GetPosition("center")) < darioRange then
		WT21.DariosInConstruction[entity] = true;
	end
end

function WT21_Dario_OnEntityDestroyed()
	local entity = Event.GetEntityID();
	if WT21.DariosInConstruction[entity] then
		WT21.DariosInConstruction[entity] = nil;
	end
	if WT21.Darios[entity] then
		--Logic.DestroyEffect(WT21.Darios[entity].effect);
		WT21.Darios[entity] = nil;
		WT21.CalculateDarioBonus();
	end
	for i = table.getn(WT21.DarioEffects), 1, -1 do
		if WT21.DarioEffects[i].id == entity then
			table.remove(WT21.DarioEffects, i)
		end
	end
end

function WT21_DarioCompleteController()
	local needsUpdate = false;
	for entity,v in pairs(WT21.DariosInConstruction) do
		if Logic.IsConstructionComplete(entity) == 1 then
			local pos = GetPosition(entity);
			WT21.Darios[entity] = true;
			WT21.DariosInConstruction[entity] = nil;
			table.insert(WT21.DarioEffects, {id = entity, lastPulseTime = 0, pos = pos})
			needsUpdate = true;
		end
	end
	if needsUpdate then
		WT21.CalculateDarioBonus();
	end
end

function WT21_DarioEffectHandler()
	local currTime = Logic.GetTimeMs()
	for i = table.getn(WT21.DarioEffects), 1, -1 do
		-- if last pulse is very old => new pulse
		if currTime - 10000 > WT21.DarioEffects[i].lastPulseTime then
			WT21.DarioEffects[i].lastPulseTime = currTime
			local pos = WT21.DarioEffects[i].pos
			Logic.CreateEffect(GGL_Effects.FXDarioFear, pos.X, pos.Y, 0)
		end
	end
end
function WT21.CalculateDarioBonus()
	WT21.DariosActive = {0,0};
	local teamId;
	for entity,v in pairs(WT21.Darios) do
		teamId = WT21.GetTeam(GetPlayer(entity));
		WT21.DariosActive[teamId] = WT21.DariosActive[teamId] + 1;
	end
	Raidboss.PlayerFlatDamage[1] = WT21.DariosActive[1];
	Raidboss.PlayerFlatDamage[2] = WT21.DariosActive[1];
	Raidboss.PlayerFlatDamage[3] = WT21.DariosActive[2];
	Raidboss.PlayerFlatDamage[4] = WT21.DariosActive[2];
end

function WT21.UnlimitedArmies()
	Script.Load("extra2\\shr\\maps\\user\\EMS\\tools\\s5CommunityLib\\packer\\devLoad.lua");
	mcbPacker.Paths[1][1] = "extra2\\shr\\maps\\user\\EMS\\tools\\"

	mcbPacker.require("s5CommunityLib/comfort/other/FrameworkWrapperLight")
	mcbPacker.require("s5CommunityLib/lib/UnlimitedArmy")

	TriggerFix.AllScriptsLoaded();

	local armyData =
	{
		Player=5,
		Area=3000,
		TransitAttackMove=true,
		DoNotNormalizeSpeed=false,
		HiResJob = true,
		--AutoDestroyIfEmpty=true
	};

	WT21.ArmyRespawnTroops =
	{
		Entities.PU_LeaderBow4,
		Entities.PU_LeaderSword4,
		Entities.PV_Cannon3,
		Entities.CU_BlackKnight_LeaderMace2,
		Entities.CU_BlackKnight_LeaderSword3,
		Entities.PV_Cannon3,
		Entities.PV_Cannon4,
		Entities.PV_Cannon2
	};
	WT21.ArmyStrengthIncreaseCounter = 0;

	WT21.ArmyRespawnDelay = 3*60;
	WT21.Armies = {
		{
			Army=LazyUnlimitedArmy:New(armyData, 0, 10),
			Spawn=GetPosition("OuterSpawn1"),
			Target=GetPosition("church1"),
			Delay = 0,
		},
		{
			Army=LazyUnlimitedArmy:New(armyData, 5, 10),
			Spawn=GetPosition("OuterSpawn2"),
			Target=GetPosition("church2"),
			Delay = 0,
		}
	};

	--WT21.Armies[1].Army:CreateLeaderForArmy(Entities.PU_LeaderBow3, 16, WT21.Armies[1].Spawn, 5);

	--StartSimpleJob("WT21_MakeArmiesStronger")
	--StartSimpleJob("WT21_ArmyController")
end

function WT21.RespawnArmy(_index)
	for i = 1,table.getn(WT21.ArmyRespawnTroops) do
		WT21.Armies[_index].Army:CreateLeaderForArmy(WT21.ArmyRespawnTroops[i], 16, WT21.Armies[_index].Spawn, 5);
	end
	WT21.Armies[_index].Army:ClearCommandQueue()
	WT21.Armies[_index].Army:AddCommandMove(WT21.Armies[_index].Target, false);
	WT21.Armies[_index].Army:AddCommandWaitForIdle();
	WT21.Armies[_index].Army:AddCommandDefend(WT21.Armies[_index].Target, 3000);
end

function WT21_MakeArmiesStronger()
	WT21.ArmyStrengthIncreaseCounter = WT21.ArmyStrengthIncreaseCounter + 1;
	if math.mod(WT21.ArmyStrengthIncreaseCounter,10*60) == 0 then -- every 10 minutes
		table.insert(WT21.ArmyRespawnTroops,Entities.PU_LeaderBow4);
	elseif math.mod(WT21.ArmyStrengthIncreaseCounter,15*60) == 0 then
		table.insert(WT21.ArmyRespawnTroops,Entities.CU_BlackKnight_LeaderSword3);
		table.insert(WT21.ArmyRespawnTroops,Entities.PV_Cannon4);
	end
end

function WT21_ArmyController()
	for i = 1,2 do
		if WT21.Armies[i].Army:IsDead() or WT21.Armies[i].Army:GetSize(true, false) <= 4 then
			if WT21.Armies[i].Delay > 0 then
				WT21.Armies[i].Delay = WT21.Armies[i].Delay - 1;
			else
				WT21.RespawnArmy(i);
				WT21.Armies[i].Delay = WT21.ArmyRespawnDelay;
			end
		end
	end
end

-- To complete:

-- A system that transforms a certain entity into a raidboss with special attacks,
-- partial immunity against attacks and a special AI

Raidboss = {}
-- multiplier by entity category
Raidboss.DamageMultipliers = {
    [EntityCategories.Bow] = 1,
    [EntityCategories.Cannon] = 1,
    [EntityCategories.CavalryHeavy] = 1,
    [EntityCategories.CavalryLight] = 1,
    [EntityCategories.Hero] = 1,
    [EntityCategories.Rifle] = 1,
    [EntityCategories.Spear] = 1,
    [EntityCategories.Sword] = 1
}
Raidboss.PlayerMultiplier = {}
Raidboss.PlayerFlatDamage = {}
-- multiplier if no appropriate ECategory was found
Raidboss.FallbackMultiplier = 0.1

Raidboss.CombatRange = 3000
Raidboss.MaxHealth = 100000
Raidboss.Armor = 0
Raidboss.Damage = 100
Raidboss.AttackRange = 800
Raidboss.MovementSpeed = 800
Raidboss.Scale = 4
Raidboss.LastHitTime = 0
Raidboss.Regen = 100

function Raidboss.Init( _eId, _pId)
    Raidboss.CheckHookVersion()
    if SendEvent then CSendEvent = SendEvent end
    -- get control over framework on game closed
    Framework_CloseGame_Orig = Framework.CloseGame
    Framework.CloseGame = function()
        SW.SV.GreatReset()
        Framework_CloseGame_Orig()
    end
    Raidboss.ApplyKerbeConfigChanges()
    Raidboss.Origin = GetPosition( _eId)
    Raidboss.pId = GetPlayer(_eId)

    -- register kerberos in stati
    Logic.SetPlayerRawName( Raidboss.pId, "Kerberos")
    Logic.PlayerSetIsHumanFlag( Raidboss.pId, 1)

    -- force respawn to enforce xml changes
    DestroyEntity(_eId)
    Raidboss.eId = Logic.CreateEntity(Entities.CU_BlackKnight, Raidboss.Origin.X, Raidboss.Origin.Y, 0, Raidboss.pId)
    -- MS and scale
    S5Hook.GetEntityMem( Raidboss.eId)[31][1][5]:SetFloat( Raidboss.MovementSpeed)
    S5Hook.GetEntityMem( Raidboss.eId)[25]:SetFloat( Raidboss.Scale)


    -- setup special attack scheduler
    Raidboss.AttackScheduler = {
        lastAttack = nil,
        timeToNextAttack = 15,
        listOfScheduledAttacks = {}
    }
    Raidboss.InCombat = false
    Raidboss.JobId = StartSimpleJob("Raidboss_Job")
    if Predicate.IsNotSoldier == nil then
        Predicate.IsNotSoldier = function()
            return function(_entity) return Logic.SoldierGetLeaderEntityID(_entity) == 0 end;
        end;
    end

    -- create raidboss arena
    local dx, dy, angle, stoneId
    for i = 1, 72 do
        angle = math.rad(i * 5)
        dx = math.cos(angle)*Raidboss.CombatRange
        dy = math.sin(angle)*Raidboss.CombatRange
        stoneId = Logic.CreateEntity( Entities.XD_ScriptEntity, Raidboss.Origin.X + dx, Raidboss.Origin.Y + dy, i*5+90, Raidboss.pId)
        Logic.SetEntityScriptingValue( stoneId, -30, 65793)
        Logic.SetModelAndAnimSet( stoneId, Models.Banners_XB_StandarteOccupied)
    end

    -- setup damage system
    Raidboss.HurtTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, nil, "Raidboss_OnHit", 1)
    Raidboss.DamageTracker = {}
    for i = 0, 16 do
        Raidboss.DamageTracker[i] = 0
        Raidboss.PlayerMultiplier[i] = 1
        Raidboss.PlayerFlatDamage[i] = 0
    end
    StartSimpleJob("Raidboss_ControlKerbe")

end
function Raidboss.CheckHookVersion()
    local version = "Not found"
	if CppLogic then
		GUI.AddStaticNote("@color:255,0,0 mcbs hook was found! You will get kicked in 15 seconds.")
		StartSimpleJob("Raidboss_VersioncheckerKickJob")
	end
end
function Raidboss_VersioncheckerKickJob()
	if Counter.Tick2("Raidboss_KickPlayer", 15) then
		QuitGame()
	end
end
function Raidboss_ControlKerbe()
    local posKerbe = GetPosition(Raidboss.eId)
    -- if kerberos is in his arena? no need to do smth
    if Raidboss.GetDistanceSq( posKerbe, Raidboss.Origin) < 2700*2700 then return end

    local pOrigin = Raidboss.Origin
    local listOfValidTargets = S5Hook.EntityIteratorTableize(Predicate.InCircle(pOrigin.X, pOrigin.Y, 2500), Predicate.OfCategory(EntityCategories.Military), Predicate.IsNotSoldier())

    local myTargetHero, myTargetMelee, myTargetRanged
    local eId
    for i = 1, table.getn(listOfValidTargets) do
        eId = listOfValidTargets[i]
        if eId == Raidboss.eId then -- do nothing here, DONT ATTACK YOURSELF
        elseif Logic.IsEntityInCategory( eId, EntityCategories.Hero) == 1 and not IsDead(eId) then
            myTargetHero = myTargetHero or eId
        elseif Logic.IsEntityInCategory( eId, EntityCategories.LongRange) == 1 then
            myTargetMelee = myTargetMelee or eId
        elseif Logic.IsEntityInCategory( eId, EntityCategories.Melee) == 1 then
            myTargetRanged = myTargetRanged or eId
        end
    end
    --LuaDebugger.Log(myTargetHero)
    --LuaDebugger.Log(myTargetMelee)
    --LuaDebugger.Log(myTargetRanged)
    if myTargetHero ~= nil then
        Logic.GroupAttack( Raidboss.eId, myTargetHero)
    elseif myTargetMelee ~= nil then
        Logic.GroupAttack( Raidboss.eId, myTargetMelee)
    elseif myTargetRanged ~= nil then
        Logic.GroupAttack( Raidboss.eId, myTargetRanged)
    else
        Logic.MoveSettler( Raidboss.eId, pOrigin.X, pOrigin.Y)
    end
    -- idle? lauf zurück zu faules stück
    if Logic.GetCurrentTaskList(Raidboss.eId) == "TL_MILITARY_IDLE" then
        Logic.MoveSettler( Raidboss.eId, pOrigin.X, pOrigin.Y)
    end
    -- nicht im kampf? regeneriere dich
    if not Raidboss.InCombat then
        local curHealth = Logic.GetEntityHealth( Raidboss.eId)
        local maxHealth = Logic.GetEntityMaxHealth( Raidboss.eId)
        local toHeal = math.min( maxHealth - curHealth, Raidboss.Regen)
    end
end
function Raidboss.ApplyKerbeConfigChanges()
    -- armor and max health
    SW.SetSettlerMaxHealth( Entities.CU_BlackKnight, Raidboss.MaxHealth)
    SW.SetSettlerArmor( Entities.CU_BlackKnight, Raidboss.Armor)

    -- changes to the fear
    SW.SetHeroFearRecharge( Entities.CU_BlackKnight, 0)
    SW.SetHeroFearDuration( Entities.CU_BlackKnight, 20)
    SW.SetHeroFearFlightDistance( Entities.CU_BlackKnight, 3000)
    SW.SetHeroFearRange( Entities.CU_BlackKnight, 800)

    -- changes to the aura
    SW.SetHeroAuraRecharge( Entities.CU_BlackKnight, 0)
    SW.SetHeroAuraRange( Entities.CU_BlackKnight, 3000)
    SW.SetHeroAuraDuration( Entities.CU_BlackKnight, 15)
    SW.SetHeroAuraArmorMultiplier( Entities.CU_BlackKnight, -100)

    -- regen, attack range and attack damage
    SW.SetLeaderDamage( Entities.CU_BlackKnight, Raidboss.Damage)
    SW.SetLeaderMaxRange( Entities.CU_BlackKnight, Raidboss.AttackRange)
    SW.SetLeaderRegen( Entities.CU_BlackKnight, 0)

    -- changes to the bomb
    SW.SetBombDamage( Entities.XD_Bomb1, 300)
    SW.SetBombRange( Entities.XD_Bomb1, 600)
end

function Raidboss_OnHit()
    local attacker = Event.GetEntityID1()
    local attacked = Event.GetEntityID2()
    if attacker == Raidboss.eId then
        Raidboss.InCombat = true
        Raidboss.LastHitTime = Logic.GetTime()
        Raidboss.OnKerbeDealsDamage( attacked)
    end
    if attacked == Raidboss.eId then
        Raidboss.LastHitTime = Logic.GetTime()
        Raidboss.InCombat = true
        if Raidboss.IsAttackerInvalid(attacker) then
            CEntity.TriggerSetDamage(0) -- the dead dont deal damage
            return
        end
        Raidboss.ManipulateTrigger( attacker)
    end
end
function Raidboss.IsAttackerInvalid( _eId)
    if IsDead( _eId) then return true end
    local pos = GetPosition( _eId)
    if Raidboss.GetDistanceSq( pos, Raidboss.Origin) > Raidboss.CombatRange^2 then
        return true
    end
    return false
end
function Raidboss.GetDistanceSq( p1, p2)
    return (p1.X - p2.X)^2 + (p1.Y - p2.Y)^2
end
function Raidboss.OnKerbeDealsDamage( _victimId)
    -- only consider valid victims
    if IsDead(_victimId) then return end
    -- manipulate damage iff target is melee
    if Logic.IsEntityInCategory( _victimId, EntityCategories.Melee) == 0 then return end

    -- get armor of obj
    local armor = Logic.GetEntityArmor( _victimId)
    local rawDamage = CEntity.TriggerGetDamage()
    local multiplier = math.min(math.max(1 - armor / 16, 0), 1)
    --LuaDebugger.Log(multiplier)

    -- set damage of trigger
    CEntity.TriggerSetDamage(math.ceil(rawDamage * multiplier))
end
function Raidboss.ManipulateTrigger( _attackerId)

	local playerID = Logic.EntityGetPlayer(_attackerId)
    local rawDamage = Logic.GetEntityDamage(_attackerId)
    local factor = Raidboss.FallbackMultiplier
    local factor2 = Raidboss.PlayerMultiplier[playerID]
    local flatDamage = Raidboss.PlayerFlatDamage[playerID]
    for k,v in pairs(Raidboss.DamageMultipliers) do
        if Logic.IsEntityInCategory( _attackerId, k) == 1 then
            factor = v
            break
        end
    end
    local newDamage = math.floor(rawDamage*factor*factor2 + flatDamage)

    Raidboss.DamageTracker[playerID] = Raidboss.DamageTracker[playerID] + newDamage
	Logic.AddToPlayersGlobalResource(playerID,ResourceType.SilverRaw,newDamage/200)
	Logic.AddToPlayersGlobalResource(playerID,ResourceType.Silver,newDamage/200)
    CEntity.TriggerSetDamage( newDamage)
end

function Raidboss_Job()
    if Logic.GetTime() - 8 > Raidboss.LastHitTime then
        Raidboss.InCombat = false
    end
    if Raidboss.InCombat then
        Raidboss.TickScheduler()
    end
end
function Raidboss.TickScheduler()
    t = Raidboss.AttackScheduler
    t.timeToNextAttack = math.max(t.timeToNextAttack - 1,0)
    if t.timeToNextAttack == 0 then
        if table.getn(t.listOfScheduledAttacks) > 0 then -- is there already some command supposed to be executed?
            Raidboss.ExecuteAttack(t.listOfScheduledAttacks[1])
            table.remove(t, 1)
        else
            local totalWeight = 0
            local isLastAttackForbidden = false
            if t.lastAttack ~= nil then
                isLastAttackForbidden = Raidboss.AttackSchemes[t.lastAttack].disallowRepeatedCasting
            end
            -- sum up all admissable weights
            admissableScenarios = {}
            for k,v in pairs(Raidboss.AttackSchemes) do
                if not( k == t.lastAttack and isLastAttackForbidden) then
                    table.insert(admissableScenarios, {k = k, w = v.weight})
                    totalWeight = totalWeight + v.weight
                end
            end
            local rndNumber = math.random(totalWeight)
            local attackName
            for i = 1, table.getn(admissableScenarios) do
                rndNumber = rndNumber - admissableScenarios[i].w
                if rndNumber <= 0 then
                    attackName = admissableScenarios[i].k
                    break
                end
            end
            --LuaDebugger.Log("Selected "..attackName)
            Raidboss.ExecuteAttack( attackName)
        end
    end
end
function Raidboss.ExecuteAttack( _attackName)
    local myAttack = Raidboss.AttackSchemes[_attackName]
    local  t = Raidboss.AttackScheduler
    t.lastAttack = _attackName
    t.timeToNextAttack = myAttack.duration
    local targetPos = Raidboss.FindNiceTarget()
    --LuaDebugger.Log(targetPos)
    myAttack.callback( myAttack, targetPos)
end
Raidboss.MaxSoundRange = 7500
function Raidboss.PlaySound( _soundId, _pos)
    local x,y = GUI.Debug_GetMapPositionUnderMouse()
    local dis = math.sqrt(Raidboss.GetDistanceSq( _pos, {X = x, Y = y}))
    local factor = math.min(dis/Raidboss.MaxSoundRange, 1)
    if factor == 1 then
        return; -- playsound doesnt like 0
    end
    Sound.PlayGUISound( _soundId, 100 * (1-factor))
end

function Raidboss.DistanceEval( disSq)
    return math.exp( -disSq / 1000000)
end
function Raidboss.FindNiceTarget()
    local pos = GetPosition(Raidboss.eId)
    local leaders = S5Hook.EntityIteratorTableize( Predicate.InCircle( pos.X, pos.Y, 3000), Predicate.OfCategory(EntityCategories.Leader))
    local n = table.getn(leaders)
    if n == 0 then
        return pos
    end
    local posis = {}
    for i = 1, n do
        table.insert( posis, GetPosition(leaders[i]))
    end
    local evals = {}
    for i = 1, n do
        local evaluation = 0
        for j = 1, n do
            evaluation = evaluation + Raidboss.DistanceEval(Raidboss.GetDistanceSq(posis[i], posis[j]))
        end
        table.insert( evals, evaluation)
    end
    local highestValue = -1
    local highestIndex = -1
    for i = 1, n do
        if highestValue < evals[i] then
            highestValue = evals[i]
            highestIndex = i
        end
    end
    if highestIndex == -1 then
        return pos
    else
        return posis[highestIndex]
    end
end


function Raidboss.MeteorStrike( _schemeTable, _targetPos)
    Raidboss.PlaySound( Sounds.Military_SO_CannonTowerFire_rnd_1, _targetPos)
    --local rX, rY
    local spread = _schemeTable.randomSpread
    local timeSpread = 2
    local dmg = _schemeTable.damage
    local range = _schemeTable.radius
    for i = 1, _schemeTable.numMeteors do
        local rX = math.random(-spread, spread)
        local rY = math.random(-spread, spread)
        MeteorSys.Add( _targetPos.X + rX, _targetPos.Y + rY, function()
            if not IsDead(Raidboss.eId) then
                CEntity.DealDamageInArea( Raidboss.eId, _targetPos.X + rX, _targetPos.Y + rY, range, dmg)
            end
            Logic.CreateEffect( GGL_Effects.FXExplosionShrapnel,  _targetPos.X + rX, _targetPos.Y + rY, 0)
        end, 6 + math.random(-timeSpread*5, timeSpread*5)/5)
        Logic.CreateEffect(GGL_Effects.FXSalimHeal, _targetPos.X + rX, _targetPos.Y + rY, 0)
    end
end
function Raidboss.FearStrike( _schemeTable, _targetPos)
    StartSimpleJob("Raidboss_FearStrike")
    Raidboss.FearStrikeCounter = _schemeTable.windUp
    local pos = GetPosition(Raidboss.eId)
    local angle, sin, cos
    for i = 1, 6 do
        angle = i*60
        cos = math.cos(math.rad(angle))
        sin = math.sin(math.rad(angle))
        Logic.CreateEffect(GGL_Effects.FXDie, pos.X + 800*cos, pos.Y + 800*sin, 0)
    end
end
function Raidboss_FearStrike()
    Raidboss.FearStrikeCounter = Raidboss.FearStrikeCounter - 1
    if Raidboss.FearStrikeCounter == 0 then
        CSendEvent.HeroInflictFear( Raidboss.eId)
        local pos = GetPosition(Raidboss.eId)
        Raidboss.PlaySound( Sounds.VoicesHero7_HERO7_InflictFear_rnd_02, pos)
        Logic.CreateEffect( GGL_Effects.FXKerberosFear, pos.X, pos.Y, 0)
        return true
    else
        local angle, cos, sin, r
        local pos = GetPosition(Raidboss.eId)
        r = Raidboss.FearStrikeCounter * 800 / Raidboss.AttackSchemes.FearInducingStrike.windUp
        for i = 1, 6 do
            angle = (i + Raidboss.FearStrikeCounter/2) *60
            cos = math.cos(math.rad(angle))
            sin = math.sin(math.rad(angle))
            Logic.CreateEffect(GGL_Effects.FXDie, pos.X + r*cos, pos.Y + r*sin, 0)
        end
    end
end
function Raidboss.ArmorShred( _schemeTable, _targetPos)
    local pos = GetPosition(Raidboss.eId)
    local angle, sin, cos, r
    for i = 1, 3 do
        r = i*1000
        for j = 1, 6*i do
            angle = (j + i/2)*60/i
            sin = math.sin(math.rad(angle))
            cos = math.cos(math.rad(angle))
            Logic.CreateEffect( GGL_Effects.FXMaryDemoralize, pos.X + sin*r, pos.Y + cos*r, 0)
        end
    end
    Logic.CreateEffect( GGL_Effects.FXMaryDemoralize, pos.X, pos.Y, 0)
    CSendEvent.HeroActivateAura( Raidboss.eId)
    Raidboss.PlaySound( Sounds.VoicesHero7_HERO7_Madness_rnd_01, pos)
end
function Raidboss.ReflectArrow( _schemeTable, _targetPos)
    local pos = GetPosition(Raidboss.eId)
    local leaders = S5Hook.EntityIteratorTableize( Predicate.NotOfPlayer0(), Predicate.IsNotSoldier(), Predicate.InCircle( pos.X, pos.Y, 3000))
    local eType, posLeader
    for i = table.getn(leaders), 1, -1 do
        if Logic.IsEntityInCategory( leaders[i], EntityCategories.LongRange) == 0 then
            table.remove(leaders, i)
        elseif Logic.IsEntityInCategory( leaders[i], EntityCategories.Soldier) == 1 then
            table.remove(leaders, i)
        else
            posLeader = GetPosition(leaders[i])
            Logic.CreateEffect( GGL_Effects.FXMaryDemoralize, posLeader.X, posLeader.Y, 0)
        end
    end
    StartSimpleHiResJob("Raidboss_ReflectArrow_Job")
    Raidboss.ReflectArrowCounter = _schemeTable.windUp*10+1
    Raidboss.PlaySound( Sounds.Coiner01, pos)
    Raidboss.ReflectArrowLeaders = leaders
end
function Raidboss_ReflectArrow_Job()
    Raidboss.ReflectArrowCounter = Raidboss.ReflectArrowCounter - 1
    local windUp = Raidboss.AttackSchemes.ReflectArrows.windUp
    if math.mod(Raidboss.ReflectArrowCounter, windUp) == 0 then
        local myIndex = Raidboss.ReflectArrowCounter / windUp
        if myIndex > 0 then
            Raidboss.PlaySound( Sounds["Misc_Countdown"..myIndex], GetPosition(Raidboss.eId))
        end
    end
    if Raidboss.ReflectArrowCounter <= 0 then
        Raidboss.ReflectArrowActivateShield()
        StartSimpleJob("Raidboss_ReflectArrow_Job2")
        Raidboss.ReflectArrowCounter = Raidboss.AttackSchemes.ReflectArrows.curseDuration
        return true
    end
end
function Raidboss_ReflectArrow_Job2()
    Raidboss.ReflectArrowCounter = Raidboss.ReflectArrowCounter - 1
    if Raidboss.ReflectArrowCounter <= 0 then
        Raidboss.ReflectArrowDeactivateShield()
        return true
    end
    local pos
    --if Counter.Tick2("Raidboss_ReflectArrow", 2) then
    for k,v in pairs(Raidboss.ReflectArrowLeaders) do
        if not IsDead(v) then
            pos = GetPosition(v)
            Logic.CreateEffect(GGL_Effects.FXMaryDemoralize, pos.X, pos.Y, 0)
        end
    end
    --end
end
function Raidboss.ReflectArrowActivateShield()
    Raidboss.ReflectArrowTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, nil, "Raidboss_ReflectArrowOnHurt", 1)
end
function Raidboss_ReflectArrowOnHurt()
    if Event.GetEntityID2() ~= Raidboss.eId then return end
    local attacker = Event.GetEntityID1()
    if IsDead(attacker) then return end
    local leader = attacker
    if Logic.IsEntityInCategory( attacker, EntityCategories.Soldier) == 1 then
        leader = Logic.GetEntityScriptingValue(attacker, 69)
    end

    local dmg = Raidboss.AttackSchemes.ReflectArrows.damage
    local radius = 0
    for k,v in pairs(Raidboss.ReflectArrowLeaders) do
        if v == leader then
            local sPos = GetPosition(Raidboss.eId)
            local tPos = GetPosition(attacker)
            CUtil.CreateProjectile( GGL_Effects.FXKalaArrow, sPos.X, sPos.Y, tPos.X, tPos.Y, dmg, radius, attacker, Raidboss.eId, GetPlayer(Raidboss.eId), nil, nil)
            return
        end
    end
end
function Raidboss.ReflectArrowRevengeAttack( _attackerId)
	if not (JobIsRunning(Raidboss.ReflectArrowRevengeJobID) == 1) then
		Raidboss.ReflectArrowRevengeJobID = StartSimpleHiResJob("Raidboss_ReflectArrowRevengeAttackJob")
		Raidboss.ReflectArrowRevengeAttackTable = {}
	end
	table.insert( Raidboss.ReflectArrowRevengeAttackTable, {attacker = _attackerId})
end
Raidboss.ReflectArrowLightningSound = {
	{soundId = Sounds.OnKlick_PB_PowerPlant1, delay = 0},
	{soundId = Sounds.Military_SO_CannonHit_rnd_1, delay = 0},
	{soundId = Sounds.Military_SO_Bearman_rnd_1, delay = 0},
	-- thunder
	{soundId = Sounds.Military_SO_Rifleman_rnd_1, delay = 1},
	{soundId = Sounds.OnKlick_PB_Tower3, delay = 2},
	{soundId = Sounds.OnKlick_PB_Brickworks1, delay = 4},
}
function Raidboss_ReflectArrowRevengeAttackJob()
	for i = 1, table.getn(Raidboss.ReflectArrowRevengeAttackTable) do
		local eId = Raidboss.ReflectArrowRevengeAttackTable[i].attacker
		if not IsDead(eId) then
			local pos = GetPosition(eId)
			Logic.Lightning( pos.X, pos.Y)
			CEntity.DealDamageInArea( Raidboss.eId, pos.X, pos.Y, 10, Raidboss.AttackSchemes.ReflectArrows.damage)
		end
	end
	if table.getn(Raidboss.ReflectArrowRevengeAttackTable) > 0 then
		StaggeredSounds.PlayStaggered( Raidboss.ReflectArrowLightningSound, GetPosition(Raidboss.eId))
	end
	return true
end
function Raidboss.ReflectArrowDeactivateShield()
    EndJob(Raidboss.ReflectArrowTrigger)
end
function Raidboss.SummonAdds( _schemeTable, _targetPos) --TODO
end
function Raidboss.SummonBomb( _schemeTable, _targetPos)
    local bombId = Logic.CreateEntity(Entities.XD_Bomb1, _targetPos.X, _targetPos.Y, 0, Raidboss.pId)
	if bombId == 0 then return end
    Raidboss.PlaySound( Sounds.VoicesHero2_HERO2_PlaceBomb_rnd_01, _targetPos)
	S5Hook.GetEntityMem(bombId)[31][0][4]:SetInt(_schemeTable.explosionTime*10) --wait 8 seconds
	S5Hook.GetEntityMem(bombId)[25]:SetFloat(8)
end
function Raidboss.MeteorRain( _schemeTable, _targetPos)
    -- idea for trajectory:
    -- map space around kerberos in polar coordinates, spawn at time t a ball at position
    --  (p(t), t*omega)
    -- p(t) = sum_{j=1}^6 w_j * (0.5*sin(j * 2pi / duration * t)+0.5)
    -- omega = 4 pi / duration
    _schemeTable.omega = 2 * _schemeTable.numRotations * math.pi / _schemeTable.duration
    local weights = {}
    local sumOfWeights = 0
    _schemeTable.phaseShifts = {}
    for i = 1, 6 do
        weights[i] = math.random()
        sumOfWeights = sumOfWeights + weights[i]
        _schemeTable.phaseShifts[i] = 2*math.pi*math.random()
    end
    -- apply to rescaling
    for i = 1, 6 do
        weights[i] = weights[i] / sumOfWeights * _schemeTable.range
    end

    _schemeTable.weights = weights
    _schemeTable.p = function(t)
        local ret = 0
        local rad = 2*math.pi / _schemeTable.duration * t
        for j = 1, 6 do
            ret = ret + _schemeTable.weights[j]*(0.5 + 0.5*math.sin(rad*j + _schemeTable.phaseShifts[j]))
        end
        return ret
    end
    _schemeTable.internalTicker = 0
    StartSimpleHiResJob("Raidboss_MeteorRainJob")
end
function Raidboss_MeteorRainJob()
    --if not Counter.Tick2("MeteorRain", 2) then return end
    local t = Raidboss.AttackSchemes.MeteorRain
    t.internalTicker = t.internalTicker + 0.1

    if t.internalTicker > t.duration then return true end

    local angle = t.internalTicker * t.omega
    local radius = t.p(t.internalTicker)
    local pos = GetPosition(Raidboss.eId)

    local x = pos.X + radius*math.sin(angle)
    local y = pos.Y + radius*math.cos(angle)
    local range = Raidboss.AttackSchemes.MeteorRain.damageRange
    local dmg = Raidboss.AttackSchemes.MeteorRain.damage
    MeteorSys.Add( x, y, function()
        if not IsDead(Raidboss.eId) then
            CEntity.DealDamageInArea( Raidboss.eId, x, y, range, dmg)
        end
        Logic.CreateEffect( GGL_Effects.FXExplosionShrapnel, x, y, 0)
    end, 6)
    Logic.CreateEffect(GGL_Effects.FXSalimHeal, x, y, 0)
    Raidboss.PlaySound(Sounds.Military_SO_CannonTowerFire_rnd_1, {X = x, Y = y})
end

-- table concerning the attack schemes
-- attacks:
--  spawn adds
--  meteor shower, multiple meteors spawn
Raidboss.AttackSchemes = {
    MeteorStrike = {
        -- determines the probability of using this attack next
        weight = 35,
        -- the function that will be called if this function was selected
        callback = Raidboss.MeteorStrike,
        -- the system assumes that this is the duration of the attack, e.g. the next attack will be selected after this time
        duration = 10,
        -- parameters of the attack that will be used internally
        disallowRepeatedCasting = true,
        -- internal stuff
        randomSpread = 500, -- meteors can spawn at x plusminus randomSpread, same in y direction
        damage = 100, -- damage of each meteor
        radius = 350, -- damage radius of each meteor
        numMeteors = 10 -- number of meteors spawned
    },
    FearInducingStrike = {
        weight = 15,
        callback = Raidboss.FearStrike,
        duration = 16,
        disallowRepeatedCasting = true,
        windUp = 8 -- wind up time for the fear in seconds
    },
    ArmorShred = {
        weight = 15,
        callback = Raidboss.ArmorShred,
        duration = 2,
        disallowRepeatedCasting = true
    },
    ReflectArrows = {
        weight = 15,
        callback = Raidboss.ReflectArrow,
        duration = 15,
        disallowRepeatedCasting = true,
        windUp = 4, -- wind up time for the curse, HAS TO BE INT
        curseDuration = 8, -- duration of the curse
        damage = 75 -- damage per reflected arrow
    },
    SummonAdds = { -- not implemented, LOL
        weight = 0,
        callback = Raidboss.SummonAdds,
        duration = 5,
        disallowRepeatedCasting = true
    },
    SummonBomb = { -- if you wish to change damage / radius, use SW.SetBombDamage/SW.SetBombRange
        weight = 15,
        callback = Raidboss.SummonBomb,
        duration = 3,
        disallowRepeatedCasting = true,
        explosionTime = 8 -- time in seconds until it explodes
    },
    MeteorRain = {
        weight = 5,
        callback = Raidboss.MeteorRain,
        duration = 10,
        disallowRepeatedCasting = true,
        numRotations = 2, -- the rain goes this number of full circles around kerberos
        range = 4500, -- the theoretical maximum distance of meteor to kerberos, mean distance is half of this
        damageRange = 250, -- aoe range of the meteor impact
        damage = 250 -- damage of each meteor
    }
}

StaggeredSounds = {}
StaggeredSounds.JobId = -1
StaggeredSounds.Data = {}
-- sounds is a table
-- each entry is a table itself of form
-- {soundId = ..., delay = ...}
function StaggeredSounds.PlayStaggered( sounds, pos)
	if not (JobIsRunning(StaggeredSounds.JobId) == 1) then
		StaggeredSounds.JobId = StartSimpleHiResJob("StaggeredSounds_Job")
	end
	table.insert( StaggeredSounds.Data, {sounds = sounds, pos = pos, counter = 0})
end
function StaggeredSounds_Job()
	for i = table.getn(StaggeredSounds.Data), 1, -1 do
		local t = StaggeredSounds.Data[i]
		local isDone = true
		for k,v in pairs(t.sounds) do
			if v.delay == t.counter then
				StaggeredSounds.PlaySound(v.soundId, t.pos)
			elseif v.delay > t.counter then
				isDone = false
			end
		end
		t.counter = t.counter + 1
		if isDone then
			table.remove(StaggeredSounds.Data, i)
		end
	end
	if table.getn(StaggeredSounds.Data) == 0 then return true end
end
function StaggeredSounds.PlaySound( _soundId, _pos)
	if _pos == nil then
		Sound.PlayGUISound( _soundId, 100)
	else
		local vol = StaggeredSounds.GetVolume( _pos)
		if vol ~= 0 then
			Sound.PlayGUISound( _soundId, vol)
		end
	end
end
function StaggeredSounds.GetVolume(_pos)
	local x,y = GUI.Debug_GetMapPositionUnderMouse()
    local dis = math.sqrt(Raidboss.GetDistanceSq( _pos, {X = x, Y = y}))
    local factor = math.min(dis/Raidboss.MaxSoundRange, 1)
    return 100 * (1-factor)
end
MeteorSys = {}
MeteorSys.Meteors = {}
MeteorSys.InitialHeight = 400
function MeteorSys.Init()
    StartSimpleHiResJob("MeteorSys_HiResJob")
end
function MeteorSys.Add( _x, _y, _callback, _time)
    local mId = MeteorSys.SpawnBall( _x, _y)
    table.insert( MeteorSys.Meteors, {
        eId = mId,
        currHeight = MeteorSys.InitialHeight,
        flightTime = _time*10,
        fullTime = _time*10,
        callback = _callback
    })
end

function MeteorSys_HiResJob()
    local t, currHeight
    for i = table.getn(MeteorSys.Meteors), 1, -1 do
        t = MeteorSys.Meteors[i]
        t.flightTime = t.flightTime - 1
        currHeight = MeteorSys.InitialHeight*t.flightTime / t.fullTime
        if t.flightTime < 0 then
            t.callback()
            DestroyEntity(t.eId)
            table.remove( MeteorSys.Meteors, i)
        else
            S5Hook.GetEntityMem(t.eId)[76]:SetFloat(currHeight);
        end
    end
end
function MeteorSys.SpawnBall( _x, _y)
    local e = Logic.CreateEntity(Entities.CB_Camp23, _x, _y, 0, 8)
    Logic.SetModelAndAnimSet(e, Models.XD_CannonBall)
    S5Hook.GetEntityMem(e)[76]:SetFloat(MeteorSys.InitialHeight) -- height

    CUtil.SetEntityDisplayName(e, "")
    return e
end

function InstallHook(installedCallback) -- for compatability with v0.10 or older
    if InstallS5Hook() then installedCallback() end
end


function InstallS5Hook()
    if nil == string.find(Framework.GetProgramVersion(), "1.06.0217") then
        Message("Error: S5Hook requires version patch 1.06!")
        return false
    end

    if not __mem then __mem = {}; end
    __mem.__index = function(t, k) return __mem[k] or __mem.cr(t, k); end

    local loader     = { 4202752, 4258997, 0, 5809871, 6455758, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4199467, 7737432, 4761371, 4198400, 6598656, 64, 8743464, 4203043, 8731292, 7273523, 4199467, 5881260, 6246939, 6519628, 0, 3, 4203648, 6045570, 6037040, 4375289, 6519628, 6268672, 4199467, 6098484, 6281915, 6282334, 4659101, 10616832, 0, 0 }
    local S5HookData = "jeDkcAkoblAAfddfeigpgpglAfggfhchdgjgpgoAdccodcAcfhdKAcfhdfmcfhdcohddfhiAekblkcAHffgogmgpgbgeAegblkcAGechcgfgbglAkdEkcAOfagbhegdgienhfhdgjgdeggjhiAhfEkcAQffgohagbhegdgienhfhdgjgdeggjhiAijFkcANepfdejemgpgbgeejgngbghgfAnjFkcAQepfdejehgfheejgngbghgffdgjhkgfAPGkcANepfdejeehcgbhhejgngbghgfAggGkcAMepfdejeehcgbhhfegfhiheAmcGkcASepfdejfdgfheeehcgbhhfehcgjghghgfhcAoiGkcAVepfdejfcgfgngphggfeehcgbhhfehcgjghghgfhcAipHkcANfchfgohegjgngffdhegphcgfAmlHkcAMfchfgohegjgngfemgpgbgeAIIkcANedgigbgoghgffdhehcgjgoghAefIkcAEemgpghAgcIkcALebgegeebhcgdgigjhggfAnaIkcAOfcgfgngphggfebhcgdgigjhggfAAJkcAQfcgfgmgpgbgeedhfhehdgdgfgogfhdAchJkcAIemgpgbgeehffejAehJkcAFefhggbgmAgoJkcAPfdgfheedhfhdhegpgneogbgngfhdAjiJkcASfcgfgngphggfedhfhdhegpgneogbgngfhdAggKkcAPfdgfheedgigbhcfehcgjghghgfhcAdgKkcASfcgfgngphggfedgigbhcfehcgjghghgfhcACLkcAOfdgfheelgfhjfehcgjghghgfhcAncKkcARfcgfgngphggfelgfhjfehcgjghghgfhcAlkLkcAUfdgfheengphfhdgfeegphhgofehcgjghghgfhcAiaLkcAXfcgfgngphggfengphfhdgfeegphhgofehcgjghghgfhcAddMkcAVfdgfhefdgfhehegmgfhcengphegjhggbhegjgpgoAhiMkcAPfcgfgmgpgbgeefgohegjhegjgfhdAlkMkcASehgfhefhgjgeghgfhefagphdgjhegjgpgoAnpMkcAOehgfhefhgjgeghgfhefdgjhkgfAecNkcARedhcgfgbhegffahcgpgkgfgdhegjgmgfAlnOkcAOejhdfggbgmgjgeefgggggfgdheAcdPkcAPehgfhefegfhchcgbgjgoejgogggpAJRkcANehgfheefgohegjhehjengfgnAdbRkcAKehgfhefcgbhhengfgnAncSkcALfcgfebgmgmgpgdengfgnApoSkcAIeghcgfgfengfgnAmkSkcAOfdgfhefahcgfgdgjhdgfegfaffApfTkcAPefgohegjhehjejhegfhcgbhegphcAoaUkcAXefgohegjhehjejhegfhcgbhegphcfegbgcgmgfgjhkgfAMYkcATebgegeechfgjgmgegjgoghffhaghhcgbgegfAllbkkcAOehgfheeggpgoheedgpgogggjghAogbkkcAOfdgfheeggpgoheedgpgogggjghAAAAAAAAAAAAAAAAAAAAAAAAAAAAAinimcehmpoppppilgbMidmeMgakapenpkbAiemahfSppVieShgAkdpanpkbAmgFpenpkbABilbnjmdkifAgiIAkcAgicjAkcAoigjAAAoilnXAAgiIAkcAfdoidllklhppgiopnippppfdppViaShgAgiPAkcAfdoicelklhppgiXAkcAfdoibjlklhppgkpnfdppVfeShgAgkpofdppVlaShgAidmeYlibpkkeaAmgAojmheaBpdhagbAlihgkkeaAmgAojmheaBlehagbAgbmcEAfgfhilheceMilhmceQgkAppdgidmgFfgPlgegppBmgfhfdoinbknlhppiddoAhfogfpfomcIAppheceEfdppVcaShgAidmeImcEAkbhiDkcAifmahecckdkeUhgAmhFhiDkcAAAAAmhFjoggejAilpaifpgggmhFkcggejAhehgdbmamdiddnhiDkcAAhfchkbkeUhgAkdhiDkcAmhFkeUhgAgmFkcAlijoggejAmgAojeamhAddjofiAmgeaEjadbmamdijmgifpgPifmegbkhppilheceIgaibomcmBAAijofilNiipaiiAilBffinfnEfdfgppfaUifmahefofgoikllfjoppflfapphfApphfEgiAnghgAgiABAAinhfIfgoijfhhlcppidmeYgkAfgkbMjpifApphaMppViiUhgAijmgifpghebmpphfEgkCfgppVUVhgAibmecmBAAijheceEgbojelgbkhppfaoiinoelcppfiibmecmBAAgbojkogbkhppgkCppheceIppVcaVhgAifmaheHfaoigkoelcppfippcfhiDkcAloppAAAfgfgfgfgidomQnjoinjfmceMnjoinjfmceInjoonjfmceEnjoonjbmcegkBfdppVmmShgAidmeIfagkcioimbdllkppfjijmboilakdldppfafdppVmaShgAidmeIijnodbmaeamdidomIijofgkBfdppVnaShgAidmeIijmbffidmfEffoifmkeldppnjefpmnjefAoikhGAAoikcGAAidmeIliCAAAmdidomQijofgkCfdppVcaShgAgkDfdppVcaShgAgkEfdppVcaShgAgkFfdppVcaShgAnjfnMnjfnInjfnEnjfnAffgkAgkBfdppVnaShgAidmeIfaoiCgjldppijmboiHglldppidmedadbmamdidomQijofgkCfdppVcaShgAppeeceEidhmceEJhfopidmeInlfnMnlfnInlfnEnlfnAgkAgkAffgkAfanjbmcefanjbmcegkAfanlbmcegkBfdppVmmShgAidmeIfaoikggildppijmboicfhbldppidmeQdbmamdgipanippppfdppVdeShgAkdhmDkcAidmeIlihlWfeAmgAojeamhAkcpaenAdbmamdkbhmDkcAifmahecofagipanippppfdppVdmShgAidmeMmhFhlWfeAffilomfgmhFhpWfeAfhilhnMmhFhmDkcAAAAAdbmamdffijoffgfhgailbnjmdkifAppdfhmDkcAgipanippppfdppVdiShgAilefMnleaeeoifnFAAdbmadiifHCAAPjfmafafdppVkiShgAilefInjeaEnjAoidnFAAoidiFAAgkAgkAgkEfdppVmiShgAgkAfdppVlaShgAidmecmgbojpbOlcppfgildfpanpkbAgkBfdppVmmShgAfafgppVfmShgAgkCfdppVmmShgAfafgppVfmShgAgipanippppfgppVfeShgAidmecifodbmamdfgildfpanpkbAgkBfdppVmmShgAfafgppVfmShgAgipanippppfgppVliShgAgkppfgppVmmShgAfafdppVfmShgAidmecifodbmaeamdgkCfdppVmmShgAidmeIfagkBfdppVmmShgAidmeIfaoiHgfldppifmafkfiheVilfeceomilfcYinUikfcfaoiefibllppfkfkijCdbmamdgkBfdppVmmShgAidmeIfagiblAkcAoiMhklcppidmeIdbmamdgailfmceceibomABAAijofgkBfdoidflflhppifmahfdnilNgaopieAidhjcmQhcFilejYolDidmbYfbgiiijphhAgibpAkcAffoihbcelkppidmeQffinkniaAAAffilNiipaiiAilRppfcdaijoigkBfailNiipaiiAilRppfcYibmeABAAgbdbmamdgailfmceceildfiipaiiAilegIilAileaMgifidahgAfaoipcchlkppidmeIifmaheHijpbilRppfccigbdbmamdgkBfdppVmmShgAidmeIifmaheDfaolFgipmjphhAkbemdekaAilIilBppfaMdbmamdgagkAgkBfdppVmmShgAidmeIfaoijafkldppijmboicbflldppgbdbmamdgkAgkBfdppVmmShgAidmeIfafaoieeUlkppijeeceEfdppVkeShgAidmeQdbmaeamdliRpjfdAmgAojmheaBllQeoAmgeaonolgipanippppfdppVdeShgAkdiaDkcAidmeIdbmamdkbiaDkcAifmahecnfagipanippppfdppVdmShgAidmeMliRpjfdAmgAoimheaBGpfpoppmgeaonhemhFiaDkcAAAAAdbmamdiliamiAAAifmaheelfhijmhilbnjmdkifAgkAfdppVlaShgAppdfiaDkcAgipanippppfdppVdiShgAfhfdppVfmShgAgkpofdppVliShgAgkppfdppVmmShgAidmecmfpllAAAAdjnihfKoikeoflappojonoolbppfjojohoolbppkbieDkcAifmahecefagipanippppfdppVdmShgAidmeMmhFenhfeaApihaUAmhFieDkcAAAAAdbmamdgipanippppfdppVdeShgAkdieDkcAidmeIlienhfeaAmhAdhjfgbAdbmamdgailbnjmdkifAppdfieDkcAgipanippppfdppVdiShgAnleeceMnnfmcepiidomIfdppVmeShgAgkAgkAgkBfdppVmiShgAgkAfdppVlaShgAidmedagbojhhnllcppkbiiDkcAifmahecefagipanippppfdppVdmShgAidmeMmhFhohfeaAknhcUAmhFiiDkcAAAAAdbmamdgipanippppfdppVdeShgAkdiiDkcAidmeIlihohfeaAmhAkcjfgbAdbmamdgaijmpilbnjmdkifAppdfiiDkcAgipanippppfdppVdiShgAnleeceMnnfmcepiidomIfdppVmeShgAijpilbCpgpbiioafafdppVkiShgAgkAgkAgkCfdppVmiShgAgkAfdppVlaShgAidmedigbojkpnmlcppkbimDkcAifmahecofagipanippppfdppVdmShgAidmeMmhFiokfffAmhegECmhFjckfffAAAAolmhFimDkcAAAAAdbmamdgipanippppfdppVdeShgAkdimDkcAidmeIliiokfffAmgAojeamhAenggemAdbmamdmhegECAAAgailbnjmdkifAppdfimDkcAgipanippppfdppVdiShgAilefQnleaQnnfmcepiidomIfdppVmeShgAgkAgkAgkBfdppVmiShgAgkAfdppVlaShgAidmedagbojgcjjldppgagkBfdoieflblhppfaoihcbjlgppifmahecoiniileAAAllHdaBAfdfdijodfdidmdEfdoinpddlgppilhjQilhpEgkCfgppVcaShgAnjfpYidmeQgbdbmamdkbgaopieAiliafiCAAileaMfaoiLioljppdbmamdgkBfdoihlkbldppfaoinghhldppijmboimchmldppidmeImdnnfmcepiidomIfdppVmeShgAidmeMmdgailfmceceoimlppppppifmahedmnjeaYnjeaUoinfppppppoinappppppgbliCAAAmdgailfmceceoikgppppppifmaheXnjeacanjeabmoilappppppoiklppppppgbliCAAAmdgbdbmamdideaBYggmheaFolEmdlikhXfgAiahiFolhecdoiofppppppidmaRoinnppppppidmaRoinfppppppidmaRoimnppppppggmheaLifpgmdgailfmceceidomeiijofdbmaljeiAAAiieeNppejhfpjmhefAjieghhAfdppVlmShgAfoijmggkBoileAAAgkCoiknAAAgkDoikgAAAgkEoijpAAAgkFoijiAAAnjfncenjfncanjffbmnjfnUnjffYnjfnQnlfnEidooFheddgkGoihhAAAnlfndeeohecggkHoigkAAAnjfndieohecagkIoifnAAAnlfndaeoheTgkJoifaAAAnlfncmolHmhefdiAAialpffilNkmfnijAilBppfafmfaidooChibpilhecenmgipanippppfdppVdeShgAijegfiidmeIppdgoicgAAAijGnlEceoiinpoppppfiidmeeigbliBAAAmdppheceEfdppVcaShgAidmeImcEAfgilheceIgkdaoidoddlkppfpijhacmijmhljcmAAApdkemheaceflOkcAfomcEAgailbnjmdkifAfbpphbfigipanippppfdppVdiShgAppVdmShgAgkAgkBgkAfdppVmiShgAgkppfdppVkmShgAijmggkAfdppVlaShgAidmecmfjilBilhicmijdjfaoiidbplkppfiifpghfGgbilBppgacegbilBgkBppQmdgailfmcecegkBfdoilhkolhppfailNeeibijAoiohjlknppPlgmafafdppVkiShgAidmeIgbliBAAAmdkbkmfnijAilhacegkBfdoijokolhppnjfnAgkCfdoijdkolhppnjfnEinenIffoiPenlgpppphfMpphfIileoEoidciokcppifmamdgailfmceceidomQijofoiljppppppPiejmAAAileobmilefMeaPkpebbmDefIilfbIineeecCPlhAfafdoijekolhppkbomibifAileaYileiEilefMPkpFheilijADefIPlgEBfafdoihbkolhpppphfMpphfIoinmgelfppfafdoifpkolhppfgkbkmfnijAileaceilhacaljEAAAilefIjjphpjfailefMjjphpjijmcecPkpfgcmfiBmcglncEileoIidmbEBnbPlgBfafdoicckolhppfoidmeQgbliEAAAmdidmeQgbdbmamdhddfgmhfgbdfAgmhfgbfphdgfhegngfhegbhegbgcgmgfAgmhfgbfpgogfhhhfhdgfhcgegbhegbAgmhfgbemfpgfhchcgphcAginlPkcAppVniQhgAgiDQkcAfagipdPkcAfagiocPkcAfappVniRhgAkdAnlkbAppVniRhgAkdEnlkbAppVniRhgAkdInlkbAmdekSkcAHehgfheejgoheAdaSkcAJehgfheeggmgpgbheAgfSkcAIehgfheechjhegfATSkcAHfdgfheejgoheApgRkcAJfdgfheeggmgpgbheAilSkcAIfdgfheechjhegfAkpSkcAKehgfhefdhehcgjgoghAkkRkcADgdhcAnaRkcAHepgggghdgfheAAAAAfpfpgngfgnAhfhdgfcadkAgimcQkcAgienQkcAoifopdppppgimcQkcAfdoidfknlhppgiopnippppfdppViaShgAgipanippppfdppVdeShgAkdjaDkcAidmeQmdgailfmcecegkBfdoiglkmlhppfaoijiUlgppifmahfEgbdbmamdfaoicbAAAgbliBAAAmdgailfmcecegkBfdoiedkmlhppfaoiHAAAgbliBAAAmdilheceEgkIfdppVEnlkbAinfaEijQijdcolPilheceEgkEfdppVEnlkbAijdappdfjaDkcAgipanippppfdppVdiShgAgkpofdppVAnlkbAidmebmmcEAgkBfdoicgkmlhppifmaheBmdgimiQkcAfdppVInlkbAgailfmceceoinnppppppildaildggkCfdoimbkllhppinEigfaoijippppppgbliBAAAmdgailfmceceoilhppppppildaildggkCfdoijlkllhppinEigfaoifmppppppgbliBAAAmdgailfmceceoijbppppppildagkCfdoiipkllhppnjbogbliAAAAmdgailfmceceoiheppppppildagkCfdoifkkllhppijGgbliAAAAmdgailfmceceoifhppppppilAnjAoigfpkppppgbliBAAAmdgailfmceceoidnppppppilAppdafdoiinkllhppgbliBAAAmdgailfmceceoiccppppppildagkCfdoiIkllhppPlgEdafafdoighkllhppgbliBAAAmdgailfmceceoipmpoppppildagkCfdoiockklhppBmggkDfdoinikklhppiiGgbdbmamdgailfmceceoinipoppppilAppdafdoifkkllhppgbliBAAAmdoiichblkppdbmamdgailfmcecegkCfdoikckklhppfagkBfdoijjkklhppfaoikfcolkppfjfjfafdoipekklhppgbliBAAAmdgailfmcecegkBfdoihgkklhppfaoibmbllkppfjgbdbmamdbpVkcAJejgoedgjhcgdgmgfAghVkcAHejgofcgfgdheAmeVkcAJepggfagmgbhjgfhcAolVkcAHepggfehjhagfAcmWkcALepggedgbhegfghgphchjAfdWkcASepggffhaghhcgbgegfedgbhegfghgphchjASWkcALejhdechfgjgmgegjgoghAkbWkcAJejgofdgfgdhegphcAmiWkcANeogpheepggfagmgbhjgfhcdaAGXkcAMepggebgohjfagmgbhjgfhcAijXkcAKepggebgohjfehjhagfAhkWkcARfahcgphggjgegfhdfcgfhdgphfhcgdgfAAAAAfahcgfgegjgdgbhegfAginlTkcAgiWTkcAoiehpappppmdgafdppVlmShgAfjfappEceijmhinEifIAAAfafdppVEnlkbAijmgidmeImhGAAAAmheeloEAAAAifppheTfhfdppVhmShgAoiiikjlhppijEloepolojgiliUkcAfdppVfiShgAidmeMijheceYgbliBAAAmdfgfhffilheceQildnfihfijAilgpEidmhYincmopDdodjophnckilehEifmaheboinfgEilKifmjhebofcilRfappfcEiemaileecepmfkheFidmcEolofidmhIolncdbmaolGilehEileaIidopQcldnfihfijAijdofnfpfomcEAgagioonippppfdoiplkilhppfaoiinppppppifmaheOfafdoiWkjlhppgbliBAAAmdgbdbmamdgaoiPppppppijmolpBAAAfdppVgiShgAidmeEfgoifkppppppifmaheXfafdoiodkilhppfhgkpofdppVgeShgAidmeMeholnpgbliBAAAmdgagkBoidnopppppgkCoidgopppppgkDoicpopppppidomMijofnjfnAnjfnInjfnEgkQfdppVEnlkbAijmbidmeIpphfAinefEfaoidniklfppidmeMgbliBAAAmdgagkBoipfooppppgkDoiooooppppgkCoiohooppppgkEoioaooppppidomQijofnlpbhcCnjmjnjfnEnjfnMnlpbhcCnjmjnjfnAnjfnIgkUfdppVEnlkbAijmbidmeIffidEceIffoidoijlfppidmeQgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGAljhhAgkBfdoikakhlhppijegEgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGkagmhgAgkBfdoihjkhlhppijegEgbliBAAAmdgagkEfdppVEnlkbAidmeImhAgmEhhAgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGieeohhAgkBfdoidikhlhppijegEgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGgehjhhAgkBfdoiRkhlhppijegEgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGeepphgAgkBfdoiokkglhppijegEgbliBAAAmdgagkIfdppVEnlkbAijmgidmeImhGceclhhAgkBfdoimdkglhppijegEgbliBAAAmdgagkIfdppVEnlkbAijmgidmeIijdgmhegEohWkcAgbliBAAAmdgailfmceceilelYidpjAhfJgbliAAAAmcEAgbliBAAAmcEAgafdppVlmShgAflijmbfbglmaEidmaMfafdppVEnlkbAijmgidmeIfjijdgmhegEfgXkcAijeoIlkAAAAdjmkheUidmcBfcfbfcfdoidkkglhppfjfkijeejgIoloigbliBAAAmdgailfmceceilflYliAAAAilfbIdjmcheNilfeibMdjndheOidmaBolomgbliAAAAmcEAgbliBAAAmcEAgafdppVlmShgAflijmbfbglmaEidmaMfafdppVEnlkbAijmgidmeIfjijdgmhegEnjXkcAijeoIlkAAAAdjmkheUidmcBfcfbfcfdoilhkflhppfjfkijeejgIoloigbliBAAAmdgailfmceceilflQliAAAAilfbIdjmcheNilfeibMdjndheOidmaBolomgbliAAAAmcEAgbliBAAAmcEAgagkCfdoigmkflhppfagkBfdoigdkflhppfaijmgilNkakdifAilejcigkBoiilhjkippiliiYDAAijmpoiEcfkjppinepcafgfeoifkinkkppmhABAAAmheaEAAAAfigbdbmamdkoYkcADhihcApnYkcADgfdcAdmbjkcADgfhaAiebjkcACgfAlibjkcAEgfhagmAphbjkcADgfgjAdgbkkcADgdhaAAAAAfpfpgfhggfgoheAgijgYkcAgifkYkcAoiioolppppmdgailfmceceidomYijofmhefAbmGhhAmhefEbjQBAgkBfdoildkelhppijefIgkCfdoikikelhppijefMgkDoiibolppppnjfnQgkEoihholppppnjfnUffoiibeelappidmebmgbdbmamdgailfmceceidomQijofmhefAgannhgAgkBfdoiglkelhppijefEgkCfdoigakelhppijefIgkDfdoiffkelhppijefMffoieceelappidmeUgbdbmamdgailfmceceidomUijofmhefAfannhgAgkBfdoicmkelhppijefEgkCfdoicbkelhppijefIgkDoipkokppppnjfnMgkEoipaokppppnjfnQffoipkedlappidmeYgbdbmamdgailfmceceidomMijofmhefAcigmhgAgkBfdoioekdlhppijefEgkCfdoinjkdlhppijefIffoimgedlappidmeQgbdbmamdgailfmceceidomQijofmhefAdigmhgAgkBfdoilakdlhppijefEgkCfdoikfkdlhppijefIgkDfdoijkkdlhppijefMffoiihedlappidmeUgbdbmamdgailfmceceidomQijofmhefAeigmhgAgkBfdoihbkdlhppijefEgkCfdoiggkdlhppijefIgkDfdoiflkdlhppijefMffoieiedlappidmeUgbdbmamdgailfmceceidomciijofmhefAomFhhAmhefEcpQBAgkBfdoiclkdlhppijefIgkCfdoicakdlhppijefMgkDfdoiVkdlhppijefQgkEoiooojppppnjfnUilefUijefcagkFoinoojppppnjfnYilefYijefcemhefbmAAAAffoinleclappidmecmgbdbmamdgkBfdoingkclhppfaoipmhildppijmboiPhnldppifmamdgailfmceceoinoppppppheemnjeaMnjeaInjeaEoindpbppppoimopbppppoimjpbppppgbliDAAAmdgailfmcecegkCfdoikgkclhppgkDfdoijokclhppgkEfdoijgkclhppoijlppppppheJnjfiMnjfiInjfiEgbdbmamdinlokeCAAgailbnjmdkifAoiemAAAgbojpgiojopplimakchcAgailbnjmdkifAoidfAAAgbojdfipjopppbdbmamdgaoicfAAAgiIAkcAfdoimckclhppfdppVhaShgAgiopnippppfdppVfeShgAidmeMgbdbmamdoiploippppoigjolppppoiUooppppoiknooppppoieeopppppoionopppppmdoihkpbppppoihapeppppoiclpfppppoidnpippppoipbpmppppmd"

    local shrink = function(cc)
        local o, i = {}, 1
        for n = 1, string.len(cc) do
            local b = string.byte(cc, n)
            if b >= 97 then n=n+1; b=16*(b-97)+string.byte(cc, n)-97; else b=b-65; end
            o[i] = string.char(b); i = i + 1
        end
        return table.concat(o)
    end

    Mouse.CursorHide()
    for i = 1, 37 do Mouse.CursorSet(i); end
    Mouse.CursorSet(10)
    Mouse.CursorShow()

    local eID = Logic.CreateEntity(Entities.XD_Plant1, 0, 0, 0, 0)
    local d, w, r = {}, Logic.SetEntityScriptingValue, Logic.GetEntityScriptingValue
    for o, v in loader do
        d[o] = r(eID, -59+o)
        if v ~= 0 then w(eID, -59+o, v); end
    end
    Logic.HeroSetActionPoints(eID, 7517305, shrink(S5HookData))
    for o, v in d do w(eID, -59+o, v); end
    Logic.DestroyEntity(eID)

    if S5Hook ~= nil then
        S5HookEventSetup();
        return true;
    end
end

function S5HookEventSetup()
    PostEvent = {}
    function PostEvent.SerfExtractResource(eID, resourceType, posX, posY)   __event.xr(eID, resourceType, posX, posY); end
    function PostEvent.SerfConstructBuilding(serf_eID, building_eID)        __event.e2(69655, serf_eID, building_eID); end
    function PostEvent.SerfRepairBuilding(serf_eID, building_eID)           __event.e2(69656, serf_eID, building_eID); end
    function PostEvent.HeroSniperAbility(heroId, targetId)                  __event.e2(69705, heroId, targetId); end
    function PostEvent.HeroShurikenAbility(heroId, targetId)                __event.e2(69708, heroId, targetId); end
    function PostEvent.HeroConvertSettlerAbility(heroId, targetId)          __event.e2(69695, heroId, targetId); end
    function PostEvent.ThiefStealFrom(thiefId, buildingId)                  __event.e2(69699, thiefId, buildingId); end
    function PostEvent.ThiefCarryStolenStuffToHQ(thiefId, buildingId)       __event.e2(69700, thiefId, buildingId); end
    function PostEvent.ThiefSabotage(thiefId, buildingId)                   __event.e2(69701, thiefId, buildingId); end
    function PostEvent.ThiefDefuse(thiefId, kegId)                          __event.e2(69702, thiefId, kegId); end
    function PostEvent.ScoutBinocular(scoutId, posX, posY)                  __event.ep(69704, scoutId, posX, posY); end
    function PostEvent.ScoutPlaceTorch(scoutId, posX, posY)                 __event.ep(69706, scoutId, posX, posY); end
    function PostEvent.HeroPlaceBombAbility(heroId, posX, posY)             __event.ep(69668, heroId, posX, posY); end
    function PostEvent.LeaderBuySoldier(leaderId)                           __event.e(69644, leaderId); end
    function PostEvent.UpgradeBuilding(buildingId)                          __event.e(69640, buildingId); end
    function PostEvent.CancelBuildingUpgrade(buildingId)                    __event.e(69662, buildingId); end
    function PostEvent.ExpellSettler(entityId)                              __event.e(69647, entityId); end
    function PostEvent.BuySerf(buildingId)                                  __event.epl(69636, GetPlayer(buildingId), buildingId); end
    function PostEvent.SellBuilding(buildingId)                             __event.epl(69638, GetPlayer(buildingId), buildingId); end
    function PostEvent.FoundryConstructCannon(buildingId, entityType)       __event.ei(69684, buildingId, entityType); end
    function PostEvent.HeroPlaceCannonAbility(heroId, bottomType, topType, posX, posY)  __event.cp(heroId, bottomType, topType, posX, posY); end

end


SW = SW or {}


SW.ScriptingValueBackup = SW.ScriptingValueBackup or {};
SW.ScriptingValueBackup.ConstructionCosts = SW.ScriptingValueBackup.ConstructionCosts or {};
SW.ScriptingValueBackup.RecruitingCosts = SW.ScriptingValueBackup.RecruitingCosts or {};
SW.ScriptingValueBackup.UpgradeCosts = SW.ScriptingValueBackup.UpgradeCosts or {};
SW.ScriptingValueBackup.TechCosts = SW.ScriptingValueBackup.TechCosts or {};
SW.ScriptingValueBackup.TechBuildReq = SW.ScriptingValueBackup.TechBuildReq or {}
SW.ScriptingValueBackup.TechTime = SW.ScriptingValueBackup.TechTime or {}
SW.ScriptingValueBackup.SerfExtrAmount = SW.ScriptingValueBackup.SerfExtrAmount or {}
SW.ScriptingValueBackup.SerfExtrDelay = SW.ScriptingValueBackup.SerfExtrDelay or {}
SW.ScriptingValueBackup.DamageClass = SW.ScriptingValueBackup.DamageClass or {}
SW.ScriptingValueBackup.MarketData = SW.ScriptingValueBackup.MarketData or {}

function SW.ResetScriptingValueChanges()
	for k,v in pairs(SW.ScriptingValueBackup.ConstructionCosts) do
		SW.SetConstructionCosts(k, v);
	end;

	for k,v in pairs(SW.ScriptingValueBackup.RecruitingCosts) do
		SW.SetRecruitingCosts(k,v);
	end;

	for k, v in pairs(SW.ScriptingValueBackup.UpgradeCosts) do
		SW.SetUpgradeCosts(k,v);
	end;
	for k, v in pairs(SW.ScriptingValueBackup.TechCosts) do
		SW.SetTechnologyCosts(k,v);
	end;
	for k, v in pairs(SW.ScriptingValueBackup.TechBuildReq) do
		SW.TechnologyRestoreBuildingReqs(k,v);
	end;

	for k,v in pairs(SW.ScriptingValueBackup.SerfExtrAmount) do
		SW.SetSerfExtractionAmount( k, v)
	end
	for k,v in pairs(SW.ScriptingValueBackup.SerfExtrDelay) do
		SW.SetSerfExtractionDelay( k, v)
	end
	for dmgClass,dmgTable in pairs(SW.ScriptingValueBackup.DamageClass) do
		for armClass, val in pairs(dmgTable) do
			SW.SetDamageArmorCoeff( dmgClass, armClass, val)
		end
	end
	if SW.ScriptingValueBackup.MarketSpeed then
		SW.SetGlobalMarketSpeed( SW.ScriptingValueBackup.MarketSpeed)
	end
	for k,v in pairs(SW.ScriptingValueBackup.MarketData) do
		if v.MaxPrice then
			SW.SetMarketMaxPrice( k, v.MaxPrice)
		end
		if v.MinPrice then
			SW.SetMarketMinPrice( k, v.MinPrice)
		end
		if v.WorkAmount then
			SW.SetMarketWorkAmount( k, v.WorkAmount)
		end
	end
	SW.SV.GreatReset()
end;

--HelperFunc: Set Movement speed of given entity
function SW.SetMovementspeed( _eId, _ms)
	S5Hook.GetEntityMem( _eId)[31][1][5]:SetFloat( _ms)
end
--HelperFunc: Get Movement speed of given entity
function SW.GetMovementspeed( _eId)
	return S5Hook.GetEntityMem( _eId)[31][1][5]:GetFloat()
end
--sets remaining time until explosion in ticks
function SW.SetKegTimer( _eId, _time)
	if S5Hook.GetEntityMem( _eId)[31]:GetInt() == 0 then
		return
	end
	if S5Hook.GetEntityMem( _eId)[31][0]:GetInt() == 0 then
		return
	end
	if S5Hook.GetEntityMem( _eId)[31][0][0]:GetInt() ~= 7824600 then
		return
	end
	S5Hook.GetEntityMem( _eId)[31][0][5]:SetInt( _time)
end
function SW.GetKegTimer( _eId)
	if S5Hook.GetEntityMem( _eId)[31]:GetInt() == 0 then
		return
	end
	if S5Hook.GetEntityMem( _eId)[31][0]:GetInt() == 0 then
		return
	end
	if S5Hook.GetEntityMem( _eId)[31][0][0]:GetInt() ~= 7824600 then
		return
	end
	return S5Hook.GetEntityMem( _eId)[31][0][5]:GetInt()
end

--some stuff regarding markets
-- returns type and amount of ressource to buy, type and amount to sell
function SW.GetMarketTransaction( _eId)
	local p = S5Hook.GetEntityMem( _eId)[31][1]
	return p[6]:GetInt(), p[7]:GetFloat(), p[5]:GetInt(), p[8]:GetFloat()
end
function SW.SetMarketTransaction( _eId, _toBuyType, _toBuyAmount)
	local p = S5Hook.GetEntityMem( _eId)[31][1]
	local maxProgress = (p[8]:GetFloat() + p[7]:GetFloat())/10;
	p[6]:SetInt( _toBuyType)
	p[7]:SetFloat( _toBuyAmount)
	p[9]:SetFloat( math.min(p[9]:GetFloat(), maxProgress-1))
end
-- number ranging from 0 to 1
function SW.SetMarketProgress( _eId, _progress)
	local p = S5Hook.GetEntityMem( _eId)[31][1]
	local maxProgress = (p[8]:GetFloat() + p[7]:GetFloat())/10;
	p[9]:SetFloat(math.floor(maxProgress*_progress))
end
-- _speed is some factor; Vanilla: 4.5
function SW.SetGlobalMarketSpeed( _speed)
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PB_Market2*8+5][2][4]
	SW.ScriptingValueBackup.MarketSpeed = SW.ScriptingValueBackup.MarketSpeed or p:GetFloat()
	p:SetFloat(_speed)
end

--HelperFunc: Set construction cost of given entity type, developed by mcb
function SW.SetConstructionCosts( _eType, _costTable)
	SW.ScriptingValueBackup.ConstructionCosts[_eType] = SW.ScriptingValueBackup.ConstructionCosts[_eType] or SW.GetConstructionCosts(_eType);
	local blankCostTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	local resourceTypes = {
		[ResourceType.Gold] = 57,
		[ResourceType.Silver] = 59,
		[ResourceType.Clay] = 67,
		[ResourceType.Wood] = 69,
		[ResourceType.Stone] = 61,
		[ResourceType.Iron] = 63,
		[ResourceType.Sulfur] = 65,
	};
	for k,v in pairs( blankCostTable) do --Allows incomplete cost tables
		_costTable[k] = _costTable[k] or blankCostTable[k]
	end
	for k,v in pairs( _costTable) do
		S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][resourceTypes[k]]:SetFloat( v);
	end
end
--HelperFunc: Get construction cost of given entity type, developed by mcb
function SW.GetConstructionCosts( _eType)
	local resourceTypes = {
		[ResourceType.Gold] = 57,
		[ResourceType.Clay] = 67,
		[ResourceType.Wood] = 69,
		[ResourceType.Stone] = 61,
		[ResourceType.Iron] = 63,
		[ResourceType.Sulfur] = 65,
	};
	local _costTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	for k,v in pairs( _costTable) do
		_costTable[k] = S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][resourceTypes[k]]:GetFloat();
	end
	_costTable[ResourceType.Silver] = 0
	return _costTable
end
--HelperFunc: Set recruiting costs for given entity type
function SW.SetRecruitingCosts( _eType, _costTable)
	SW.ScriptingValueBackup.RecruitingCosts[_eType] = SW.ScriptingValueBackup.RecruitingCosts[_eType] or SW.GetRecruitingCosts(_eType);
	local blankCostTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	local resourceTypes = {
		[ResourceType.Gold] = 41,
		[ResourceType.Clay] = 51,
		[ResourceType.Wood] = 53,
		[ResourceType.Stone] = 45,
		[ResourceType.Iron] = 47,
		[ResourceType.Sulfur] = 49,
	};
	for k,v in pairs( blankCostTable) do --Allows incomplete cost tables
		_costTable[k] = _costTable[k] or blankCostTable[k]
	end
	for k,v in pairs( resourceTypes) do
		S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][v]:SetFloat( _costTable[k]);
	end
end
--HelperFunc: Get recruiting cost of given entity type
function SW.GetRecruitingCosts( _eType)
	local resourceTypes = {
		[ResourceType.Gold] = 41,
		[ResourceType.Clay] = 51,
		[ResourceType.Wood] = 53,
		[ResourceType.Stone] = 45,
		[ResourceType.Iron] = 47,
		[ResourceType.Sulfur] = 49,
	};
	local _costTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	for k,v in pairs( _costTable) do
		_costTable[k] = S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][resourceTypes[k]]:GetFloat();
	end
	_costTable[ResourceType.Silver] = 0
	return _costTable
end
--HelperFunc: Increases experience of given entity
function SW.AddExperiencePoints( _eId, _exp)
	if Logic.IsLeader(_eId) == 0 then
		return
	end
	--Exp stored in S5Hook.GetEntityMem( _eId)[31][3][32]:GetInt()
	local currExp = S5Hook.GetEntityMem( _eId)[31][3][32]:GetInt()
	if (currExp + _exp) > 1000 then --upper border for reasons beyond human understanding
		S5Hook.GetEntityMem( _eId)[31][3][32]:SetInt( 1000)
		return
	end
	S5Hook.GetEntityMem( _eId)[31][3][32]:SetInt( currExp + _exp)
end
--HelperFunc: Get upgrade costs of building
function SW.GetUpgradeCosts( _eType)
	local resourceTypes = {
		[ResourceType.Gold] = 82,
		[ResourceType.Clay] = 92,
		[ResourceType.Wood] = 94,
		[ResourceType.Stone] = 86,
		[ResourceType.Iron] = 88,
		[ResourceType.Sulfur] = 90,
	};
	local _costTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	for k,v in pairs( _costTable) do
		_costTable[k] = S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][resourceTypes[k]]:GetFloat();
	end
	_costTable[ResourceType.Silver] = 0
	return _costTable
end
--HelperFunc: Set upgrade costs for building
function SW.SetUpgradeCosts( _eType, _costTable)
	SW.ScriptingValueBackup.UpgradeCosts[_eType] = SW.ScriptingValueBackup.UpgradeCosts[_eType] or SW.GetUpgradeCosts(_eType);
	local blankCostTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	local resourceTypes = {
		[ResourceType.Gold] = 82,
		[ResourceType.Clay] = 92,
		[ResourceType.Wood] = 94,
		[ResourceType.Stone] = 86,
		[ResourceType.Iron] = 88,
		[ResourceType.Sulfur] = 90,
	};
	for k,v in pairs( blankCostTable) do --Allows incomplete cost tables
		_costTable[k] = _costTable[k] or blankCostTable[k]
	end
	for k,v in pairs( resourceTypes) do
		S5Hook.GetRawMem(9002416)[0][16][_eType * 8 + 2][v]:SetFloat( _costTable[k]);
	end
end

function SW.GetDamageArmorCoeff( _dmgClass, _armorClass)
	local p = SVTests.GetDamageClassPointer()
	return p[_dmgClass][_armorClass]:GetFloat()
end
function SW.SetDamageArmorCoeff( _dmgClass, _armorClass, _val)
	local p = SVTests.GetDamageClassPointer()
	if SW.ScriptingValueBackup.DamageClass[_dmgClass] == nil then
		SW.ScriptingValueBackup.DamageClass[_dmgClass] = {}
	end
	SW.ScriptingValueBackup.DamageClass[_dmgClass][_armorClass] = SW.ScriptingValueBackup.DamageClass[_dmgClass][_armorClass] or SW.GetDamageArmorCoeff( _dmgClass, _armorClass)
	return p[_dmgClass][_armorClass]:SetFloat(_val)
end

function SW.GetSerfExtractionAmount( _ressSource)
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PU_Serf*8+5][6]
	--local num = ( p[9]:GetInt() - p[8]:GetInt())/12
	local num = 10
	local extractionDataP = p[8]
	for i = 0, num-1 do
		if extractionDataP[3*i]:GetInt() == _ressSource then
			return extractionDataP[3*i+2]:GetInt()
		end
	end
end
function SW.SetSerfExtractionAmount( _ressSource, _amount)
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PU_Serf*8+5][6]
	--local num = ( p[9]:GetInt() - p[8]:GetInt())/12
	local num = 10
	local extractionDataP = p[8]
	for i = 0, num-1 do
		if extractionDataP[3*i]:GetInt() == _ressSource then
			if SW.ScriptingValueBackup.SerfExtrAmount[_ressSource] == nil then
				SW.ScriptingValueBackup.SerfExtrAmount[_ressSource] = SW.GetSerfExtractionAmount( _ressSource)
			end
			extractionDataP[3*i+2]:SetInt(_amount)
			return
		end
	end
end
function SW.GetSerfExtractionDelay( _ressSource)
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PU_Serf*8+5][6]
	--local num = ( p[9]:GetInt() - p[8]:GetInt())/12
	local num = 10
	local extractionDataP = p[8]
	for i = 0, num-1 do
		if extractionDataP[3*i]:GetInt() == _ressSource then
			return extractionDataP[3*i+1]:GetFloat()
		end
	end
end
function SW.SetSerfExtractionDelay( _ressSource, _amount)
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PU_Serf*8+5][6]
	--local num = ( p[9]:GetInt() - p[8]:GetInt())/12
	local num = 10
	local extractionDataP = p[8]
	for i = 0, num-1 do
		if extractionDataP[3*i]:GetInt() == _ressSource then
			if SW.ScriptingValueBackup.SerfExtrDelay[_ressSource] == nil then
				SW.ScriptingValueBackup.SerfExtrDelay[_ressSource] = SW.GetSerfExtractionDelay( _ressSource)
			end
			extractionDataP[3*i+1]:SetFloat(_amount)
			return
		end
	end
end
--Technology stuff
function SW.GetTechnologyCosts( _tId)
	local resourceTypes = {
		[ResourceType.Gold] = 4,
		[ResourceType.Clay] = 14,
		[ResourceType.Wood] = 16,
		[ResourceType.Stone] = 8,
		[ResourceType.Iron] = 10,
		[ResourceType.Sulfur] = 12,
	};
	local _costTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	for k,v in pairs( _costTable) do
		_costTable[k] = S5Hook.GetRawMem(8758176)[0][13][1][ _tId-1][resourceTypes[k]]:GetFloat();
	end
	_costTable[ResourceType.Silver] = 0
	return _costTable
end
function SW.SetTechnologyCosts( _tId, _costTable)
	SW.ScriptingValueBackup.TechCosts[_tId] = SW.ScriptingValueBackup.TechCosts[_tId] or SW.GetTechnologyCosts( _tId);
	local blankCostTable = {
		[ResourceType.Gold] = 0,
		[ResourceType.Clay] = 0,
		[ResourceType.Wood] = 0,
		[ResourceType.Stone] = 0,
		[ResourceType.Iron] = 0,
		[ResourceType.Sulfur] = 0
	}
	local resourceTypes = {
		[ResourceType.Gold] = 4,
		[ResourceType.Clay] = 14,
		[ResourceType.Wood] = 16,
		[ResourceType.Stone] = 8,
		[ResourceType.Iron] = 10,
		[ResourceType.Sulfur] = 12,
	};
	for k,v in pairs( blankCostTable) do --Allows incomplete cost tables
		_costTable[k] = _costTable[k] or blankCostTable[k]
	end
	for k,v in pairs( _costTable) do
		S5Hook.GetRawMem(8758176)[0][13][1][ _tId-1][resourceTypes[k]]:SetFloat( v);
	end
end

function SW.TechnologyVoidBuidingReqs( _tId)
	local memObj = SW.SV.GetTechData( _tId)
	if SW.ScriptingValueBackup.TechBuildReq[_tId] == nil then	-- first change of buildReqs for this tech?
		SW.ScriptingValueBackup.TechBuildReq[_tId] = {
			count = memObj[26]:GetInt(),
			reqStart = memObj[28]:GetInt(),
			reqEnd = memObj[29]:GetInt()
		}
	end
	memObj[26]:SetInt(0)	--set # of req to meet to 0
	memObj[28]:SetInt(0)	--destroy pointer
	memObj[29]:SetInt(0)
	memObj[30]:SetInt(0)
end
-- _count is # of requirements that have to be fulfilled, requirements are encoded as
-- _data = {{1, Entities.PB_Tower3}, {4, Entities.PB_Tower2}}
-- so 1 Tower3 and 4 Tower2 are needed if _count == 2 or one of the conditions if _count == 1
function SW.TechnologyAlterBuildingReqs( _tId, _count, _data)
	local memObj = SW.SV.GetTechData( _tId)
	if SW.ScriptingValueBackup.TechBuildReq[_tId] == nil then	-- first change of buildReqs for this tech?
		SW.ScriptingValueBackup.TechBuildReq[_tId] = {
			count = memObj[26]:GetInt(),
			reqStart = memObj[28]:GetInt(),
			reqEnd = memObj[29]:GetInt()
		}
	end
	local n = table.getn(_data)
	--if n == _count then _count = 0 end
	memObj[26]:SetInt( _count)
	local ptr = S5Hook.ReAllocMem( 0, n*8)
	memObj[28]:SetInt( ptr)
	memObj[29]:SetInt( ptr+n*8)
	memObj[30]:SetInt( ptr+n*8)
	ptr = S5Hook.GetRawMem( ptr)
	for i = 1, n do
		ptr[2*i-2]:SetInt(_data[i][2])
		ptr[2*i-1]:SetInt(_data[i][1])
	end
end
function SW.TechnologyRestoreBuildingReqs( _tId, _data)
	local memObj = SW.SV.GetTechData( _tId)
	memObj[26]:SetInt(_data.count)
	memObj[28]:SetInt(_data.reqStart)
	memObj[29]:SetInt(_data.reqEnd)
	memObj[30]:SetInt(_data.reqEnd)
end

function SW.SetTechnologyTimeToResearch( _tId, _time)
	local p = SW.SV.GetTechData( _tId)
	SW.ScriptingValueBackup.TechTime[_tId] = SW.ScriptingValueBackup.TechTime[_tId] or SW.GetTechnologyTimeToResearch( _tId)
	p[1]:SetFloat( _time)
end
function SW.GetTechnologyTimeToResearch( _tId)
	return SW.SV.GetTechData( _tId)[1]:GetFloat()
end

function SW.SetMarketMaxPrice( _ressType, _price)
	SW.ScriptingValueBackup.MarketData[_ressType] = SW.ScriptingValueBackup.MarketData[_ressType] or {}
	SW.ScriptingValueBackup.MarketData[_ressType].MaxPrice = SW.ScriptingValueBackup.MarketData[_ressType].MaxPrice or SW.GetMarketMaxPrice( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	mp[8*i+4]:SetFloat( _price)
end
function SW.GetMarketMaxPrice( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	return mp[8*i+4]:GetFloat()
end
function SW.SetMarketMinPrice( _ressType, _price)
	SW.ScriptingValueBackup.MarketData[_ressType] = SW.ScriptingValueBackup.MarketData[_ressType] or {}
	SW.ScriptingValueBackup.MarketData[_ressType].MinPrice = SW.ScriptingValueBackup.MarketData[_ressType].MinPrice or SW.GetMarketMinPrice( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	mp[8*i+3]:SetFloat( _price)
end
function SW.GetMarketMinPrice( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	return mp[8*i+3]:GetFloat()
end
function SW.SetMarketWorkAmount( _ressType, _workAmount)
	SW.ScriptingValueBackup.MarketData[_ressType] = SW.ScriptingValueBackup.MarketData[_ressType] or {}
	SW.ScriptingValueBackup.MarketData[_ressType].WorkAmount = SW.ScriptingValueBackup.MarketData[_ressType].WorkAmount or SW.GetMarketWorkAmount( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	mp[8*i+7]:SetFloat( _workAmount)
end
function SW.GetMarketWorkAmount( _ressType)
	local mp = SW.SV.GetLogicXMLPointer()[15]
	local i = SW.SV.GetMarketIndex( mp, _ressType)
	return mp[8*i+7]:GetFloat()
end

SW.SV = {}
-- Entries { type, vtable, index, float/int}
--	false == float, true == int for float/int
--  type:
--  2 == Beh
--	1 == Logic
--  index can be a table, only implemented for behTables atm

-- for each entry, 2 functions are created:
--	SV["Set"..key]( _eType, val), sets key for the entity type
--	SV["Get"..key]( _eType), gets key for the entity
SW.SV.Data = {
	-- some worker logic
	["WorkTimeChangeWork"] = {2, 7809936, 17, true},
	["WorkTimeChangeFarm"] = {2, 7809936, 18, false},
	["WorkTimeChangeResidence"] = {2, 7809936, 19, false},
	["WorkTimeChangeCamp"] = {2, 7809936, 20, false},
	["WorkTimeMaxChangeFarm"] = {2, 7809936, 21, true},
	["WorkTimeMaxChangeResidence"] = {2, 7809936, 22, true},
	["ExhaustedWorkMotivationMalus"] = {2, 7809936, 23, false},
	["WorkerTransportAmount"] = {2, 7809936, 24, true},
	["WorkerResourceToRefine"] = {2, 7809936, 27, true},
    ["WorkerTransportModel"] = {2, 7809936, 25, true},
    ["WorkerTransportAnim"] = {2, 7809936, 24, true},
	-- some other stuff
	["RecruitingTime"] = {2, 7834420, 9, false},
	["RefinedPerTick"] = {2, 7818276, 5, false},
	["AmountToMine"] = {2, 7821340, 4, true},
	-- Logic for buildings, GGL::CGLBuildingProps == 7793784
	["KegFactor"] = {1, 7793784, 124, false},
	["AttractionPlaceProvided"] = {1, 7793784, 44, true},
	["UpgradeTime"] = {1, 7793784, 80, false},
	["Exploration"] = {1, 7793784, 19, false},
	["ConstructionTime"] = {1, 7793784, 55, true},
	["BuildingMaxHealth"] = {1, 7793784, 13, true},
	["MaxWorkers"] = {1, 7793784, 42, true},
	["InitialWorkers"] = {1, 7793784, 43, true},
	-- Logic for entities, GGL::CGLSettlerProps == 7791768
	["SettlerMaxHealth"] = {1, 7791768, 13, true},
	["SettlerExploration"] = {1, 7791768, 19, false},
	["SettlerArmorClass"] = {1, 7791768, 60, true},
	["SettlerArmor"] = {1, 7791768, 61, true},
	["AttractionPlaceNeeded"] = {1, 7791768, 136, true},
	-- BehTable for motivation, 7836116 == GGL::CAffectMotivationBehaviorProps
	["MotivationProvided"] = {2, 7836116, 4, false},
	-- BehTable for residences / farms, 7823028 == GGL::CLimitedAttachmentBehaviorProperties
	["PlacesProvided"] = {2, 7823028, {5,7}, true},
	-- Stuff for thief bombs, use type XD_Keg1
	["ThiefKegDamage"] = {2, 7824728, 5, true},			-- damage against settlers, default 50
	["ThiefKegDmgPercentage"] = {2, 7824728, 7, true},	-- damage against buildings, default 70
	["ThiefKegRange"] = {2, 7824728, 4, false},
	["ThiefKegDelay"] = {2, 7824728, 6, false},
    -- data for the thief itself, use type PU_Thief
    ["ThiefBombRechargeTime"] = {2, 7824308, 4, true}, --default 90
    ["ThiefBombArmTime"] = {2, 7824308, 5, false},  --default 5
    ["ThiefBombDisarmTime"] = {2, 7824308, 6, false},  --default 3
    -- data for stealing goods
    ["ThiefTimeToSteal"] = {2, 7813600, 4, true}, --default 5
    ["ThiefMinimumAmountToSteal"] = {2, 7813600, 5, true}, --default 100
    ["ThiefMaximumAmountToSteal"] = {2, 7813600, 6, true}, --default 200
	-- data for leader stats; CLeaderBehaviorProps
	["LeaderDamage"] = {2, 7823268, 14, true},
	["LeaderRandomDamageBonus"] = {2, 7823268, 15, true},
	["LeaderDamageClass"] = {2, 7823268, 13, true},
	["LeaderAoERange"] = {2, 7823268, 16, false},
	["LeaderMaxRange"] = {2, 7823268, 23, false},
	["LeaderRegen"] = {2, 7823268, 28, true},
	["LeaderAutoRange"] = {2, 7823268, 30, false},
	-- data for soldier stats; CSoldierBehaviorProps
	["SoldierDamage"] = {2, 7814416, 14, true},
	["SoldierRandomDamageBonus"] = {2, 7814416, 15, true},
	["SoldierDamageClass"] = {2, 7814416, 13, true},
	["SoldierMaxRange"] = {2, 7814416, 23, false},
	-- CLimitedAttachmentBehaviorProperties
	["LeaderMaxSoldiers"] = {2, 7823028, {5, 7}, true},
	-- CBombBehaviorProperties
	["BombRange"] = {2, 7832736, 4, false},
	["BombDamage"] = {2, 7832736, 6, true},
	-- CRangedEffectAbility
	["HeroAuraRecharge"] = {2, 7818908, 4, true},
	["HeroAuraRange"] = {2, 7818908, 7, false},
	["HeroAuraDuration"] = {2, 7818908, 8, true},
	["HeroAuraDamageMultiplier"] = {2, 7818908, 9, false},
	["HeroAuraArmorMultiplier"] = {2, 7818908, 10, false},
	["HeroAuraRegenMultiplier"] = {2, 7818908, 11, false},
    -- 12 and 13 appear to be some multipliers aswell?
	-- CInflictFearAbility
	["HeroFearRecharge"] = {2, 7825012, 4, true},
	["HeroFearDuration"] = {2, 7825012, 7, true},
	["HeroFearFlightDistance"] = {2, 7825012, 8, false},
	["HeroFearRange"] = {2, 7825012, 9, false},
	-- CAutoCannonBehavior
	["CannonAmountOfShots"] = {2, 7834836, 4, true},
	["CannonRotationSpeedRad"] = {2, 7834836, 5, false},
	["CannonReloadTime"] = {2, 7834836, 10, true},
	["CannonMaxRange"] = {2, 7834836, 11, false},
	["CannonMinRange"] = {2, 7834836, 12, false},
	["CannonDamageClass"] = {2, 7834836, 13, true},
	["CannonDamage"] = {2, 7834836, 14, true},
	["CannonDamageRange"] = {2, 7834836, 15, false}

}

SW.SV.BackUps = {}
-- Makes heavy use of upvalues!
function SW.SV.Init()
	for k,v in pairs(SW.SV.Data) do
		local c = {type = v[1], vTable = v[2], index = v[3], int = v[4]}	--Create a copy of v for use
		if c.type == 2 then	--Behaviortable
			SW["Get"..k] = function( _eType)
				local behPointer = SW.SV.SearchForBehTable( _eType, c.vTable)
				if behPointer ~= nil then
					if c.int then
						return SW.SV.UnpackIndex( behPointer, c.index):GetInt()
					else
						return SW.SV.UnpackIndex( behPointer, c.index):GetFloat()
					end
				end
			end
			SW.SV.BackUps[k] = {}
			local kCopy = k
			SW["Set"..k] = function( _eType, _val)
				local behPointer = SW.SV.SearchForBehTable( _eType, c.vTable)
				if behPointer ~= nil then
					SW.SV.BackUps[kCopy][_eType] = SW.SV.BackUps[kCopy][_eType] or SW["Get"..kCopy](_eType)
					if c.int then
						SW.SV.UnpackIndex( behPointer, c.index):SetInt( _val)
					else
						SW.SV.UnpackIndex( behPointer, c.index):SetFloat( _val)
					end
				else
					Message("Failed to set "..kCopy.." for ".._eType)
				end
			end
		elseif c.type == 1 then	--Logic table
			SW["Get"..k] = function( _eType)
				local logicPointer = S5Hook.GetRawMem(9002416)[0][16][_eType*8+2]
				if logicPointer[0]:GetInt() == c.vTable then
					if c.int then
						return logicPointer[c.index]:GetInt()
					else
						return logicPointer[c.index]:GetFloat()
					end
				else return -1 end
			end
			SW.SV.BackUps[k] = {}
			local kCopy = k
			SW["Set"..k] = function( _eType, _val)
				local logicPointer = S5Hook.GetRawMem(9002416)[0][16][_eType*8+2]
				if logicPointer[0]:GetInt() == c.vTable then
					SW.SV.BackUps[kCopy][_eType] = SW.SV.BackUps[kCopy][_eType] or SW["Get"..kCopy](_eType)
					if c.int then
						logicPointer[c.index]:SetInt( _val)
					else
						logicPointer[c.index]:SetFloat( _val)
					end
				else
					Message("Failed to set "..kCopy.." for ".._eType)
				end
			end
		end
	end
end
function SW.SV.GreatReset()
	for k,v in pairs(SW.SV.BackUps) do
		for k2,v2 in pairs(v) do	--k2 == eType, v2 == val
			SW["Set"..k]( k2, v2)
		end
		SW.SV.BackUps[k] = {}
	end
end
function SW.SV.SearchForBehTable( _eType, _vTable)
	local typePointer = S5Hook.GetRawMem(9002416)[0][16]
	local behPointer = typePointer[_eType*8+5]
	local upperBorder = typePointer[_eType*8+7]:GetInt()
	local i = 0
	while typePointer[_eType*8+5]:Offset(i):GetInt() < upperBorder do
		--LuaDebugger.Log(behPointer[i]:GetInt())
		if behPointer[i]:GetInt() > 0 then	--adress looks good, check associated vtable
			--LuaDebugger.Log(behPointer[i][0]:GetInt())
			if behPointer[i][0]:GetInt() == _vTable then
				return behPointer[i]
			end
		end
		i = i + 1
	end
end
function SW.SV.UnpackIndex( _p, _t)
	if type(_t) == "number" then
		return _p[_t]
	end
	for i = 1, table.getn(_t) do
		_p = _p[_t[i]]
	end
	return _p
end

SW.SV.ArmorClasses = {
	None = 1,
	Jerkin = 2,
	Leather = 3,
	Iron = 4,
	Fortification = 5,
	Hero = 6,
	Fur = 7
}
function SW.SV.GetTechData( _tId)
	return S5Hook.GetRawMem(8758176)[0][13][1][ _tId-1]
end
function SW.SV.GetDamageXMLPointer()
	return S5Hook.GetRawMem(8758236)[0][2]
end
function SW.SV.GetLogicXMLPointer()
	return S5Hook.GetRawMem(8758240)[0]
end
function SW.SV.GetMarketIndex( _p, _ressType)
	for i = 0, 5 do
		if _p[i*8+1]:GetInt() == _ressType then
			return i
		end
	end
end
SW.SV.MarketData = {
	{
		RessType = ResourceType.Gold,
		BasePrice = 1,
		MinPrice = 1,
		MaxPrice = 1,
		Inflation = 0.00015000000712462,
		Deflation = 0.00015000000712462,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.Clay,
		BasePrice = 1,
		MinPrice = 0.20000000298023,
		MaxPrice = 2.7999999523163,
		Inflation = 9.9999997473788e-005,
		Deflation = 9.9999997473788e-005,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.Wood,
		BasePrice = 1.3999999761581,
		MinPrice = 0.20000000298023,
		MaxPrice = 2.7999999523163,
		Inflation = 0.00019999999494758,
		Deflation = 0.00019999999494758,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.Iron,
		BasePrice = 1,
		MinPrice = 0.20000000298023,
		MaxPrice = 2.7999999523163,
		Inflation = 9.9999997473788e-005,
		Deflation = 9.9999997473788e-005,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.Stone,
		BasePrice = 1,
		MinPrice = 0.20000000298023,
		MaxPrice = 2.7999999523163,
		Inflation = 9.9999997473788e-005,
		Deflation = 9.9999997473788e-005,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.Sulfur,
		BasePrice = 0.60000002384186,
		MinPrice = 0.20000000298023,
		MaxPrice = 2.7999999523163,
		Inflation = 9.9999997473788e-005,
		Deflation = 9.9999997473788e-005,
		WorkAmount = 0.1
	},
	{
		RessType = ResourceType.SulfurRaw,
		BasePrice = 10,
		MinPrice = 6,
		MaxPrice = 15,
		Inflation = 9.9999997473788e-005,
		Deflation = 9.9999997473788e-005,
		WorkAmount = 0.1
	}
}
function SW.SV.TransformTableToMarketData( _t)
	local n = table.getn(_t)
	LuaDebugger.Log(n)
	local p = S5Hook.GetRawMem(S5Hook.ReAllocMem( 0, n*8*4))
	LuaDebugger.Log(p:GetInt())
	for i = 0, n-1 do
		local t = _t[i+1]
		p[8*i]:SetInt(7794472) --set vTable
		p[8*i+1]:SetInt(t.RessType)
		p[8*i+2]:SetFloat(t.BasePrice)
		p[8*i+3]:SetFloat(t.MinPrice)
		p[8*i+4]:SetFloat(t.MaxPrice)
		p[8*i+5]:SetFloat(t.Inflation)
		p[8*i+6]:SetFloat(t.Deflation)
		p[8*i+7]:SetFloat(t.WorkAmount)
	end
	return p
end
function SW.SV.ReplaceMarketData( _newData)
	local n = table.getn( _newData)
	local p1 = SW.SV.TransformTableToMarketData( _newData)
	local p2 = SW.SV.GetLogicXMLPointer()
	LuaDebugger.Log("Old vals: "..p2[15]:GetInt().." "..p2[16]:GetInt())
	p2[15]:SetInt(p1:GetInt())
	p2[16]:SetInt(p1:Offset(8*n):GetInt())
	p2[17]:SetInt(p1:Offset(8*n):GetInt())
end
SVTests = {}
function SVTests.StartWatch()
	SVTests.eId = GUI.GetSelectedEntity()
	SVTests.p = S5Hook.GetEntityMem(SVTests.eId)[31][2][4]
	SVTests.Val = SVTests.p:GetInt()
	LuaDebugger.Log("Start watching with val = "..SVTests.Val)
	SVTests_WatchJob = function()
		if SVTests.p:GetInt() ~= SVTests.Val then
			local newVal = SVTests.p:GetInt()
			LuaDebugger.Log("Regsitered change from "..SVTests.Val.." to "..newVal.."; Diff "..(newVal-SVTests.Val))
			SVTests.Val = newVal
		end
	end
	StartSimpleJob("SVTests_WatchJob")
	Game.GameTimeSetFactor(10)
end
function SVTests.GetBehP()
	local p = S5Hook.GetRawMem(9002416)[0][16][Entities.PU_Serf*8+5][6][8]
	for i = 0, 19 do
		LuaDebugger.Log(i.." "..p[i]:GetInt())
	end
	return p
end
function SVTests.PrintMarketData( _offset)
	local p = SW.SV.GetLogicXMLPointer()[15]
	LuaDebugger.Log("RessType = "..SVTests.GetRessTypeName( p[_offset*8+1]:GetInt())..",")
	LuaDebugger.Log("BasePrice = "..p[_offset*8+2]:GetFloat()..",")
	LuaDebugger.Log("MinPrice = "..p[_offset*8+3]:GetFloat()..",")
	LuaDebugger.Log("MaxPrice = "..p[_offset*8+4]:GetFloat()..",")
	LuaDebugger.Log("Inflation = "..p[_offset*8+5]:GetFloat()..",")
	LuaDebugger.Log("Deflation = "..p[_offset*8+6]:GetFloat()..",")
end
function SVTests.GetRessTypeName( _index)
	for k,v in pairs(ResourceType) do
		if _index == v then
			return "ResourceType."..k
		end
	end
	return _index
end
function SVTests.GetDamageClassPointer()
	return S5Hook.GetRawMem(8758236)[0][2]
end
function SVTests.ScanPInt( _p, _m)
	for i = 0, _m do
		LuaDebugger.Log(i.." ".._p[i]:GetInt())
	end
end
function SVTests.ScanPFloat( _p, _m)
	for i = 0, _m do
		LuaDebugger.Log(i.." ".._p[i]:GetFloat())
	end
end
SVTests.VTable = 7836116 --GGL::CAffectMotivationBehaviorProps
function SVTests.Print( _eType, _lim)
	local pointer = SW.SV.SearchForBehTable( _eType, SVTests.VTable)
	if pointer == nil then return end
	for i = 0, _lim do
		LuaDebugger.Log(i.." "..pointer[i]:GetInt().." "..pointer[i]:GetFloat())
	end
end
 