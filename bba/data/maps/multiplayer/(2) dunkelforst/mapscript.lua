--------------------------------------------------------------------------------
-- MapName: (2) Dunkelforst
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
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
EMS_CustomMapConfig =
{

	Version = 1.1,

	Callback_OnMapStart = function()

	Script.Load(Folders.MapTools.."Ai\\Support.lua")
	Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua" )
	Script.Load( "Data\\Script\\MapTools\\Tools.lua" )
	Script.Load( "Data\\Script\\MapTools\\WeatherSets.lua" )
	IncludeGlobals("Comfort")
	Script.Load( Folders.MapTools.."Main.lua" )
	IncludeGlobals("MapEditorTools")
	Script.Load( "Data\\Script\\MapTools\\Counter.lua" )
	--
	IncludeGlobals("tools\\BSinit")
	-- custom Map Stuff

	TagNachtZyklus(24,1,1,0,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	LocalMusic.UseSet = HIGHLANDMUSIC
	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end


	end,

	Callback_OnGameStart = function()

	end,
	Callback_OnPeacetimeEnded = function()
		for i = 1,4 do
			ReplacingEntity("gate"..i, Entities.XD_PalisadeGate2)
		end
		for i = 1,2 do
			SetHostile(i, 3)
		end
		CreateNVArmies()
	end,
	Peacetime = 40,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 2,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1
};
CreateNVArmies = function()
	local armies = {
		{player = 3, id = 0, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn1"), spawnPos = GetPosition("NV_Spawn1"), spawnGenerator = GetID("NV_Tower1"), respawnTime = 2*60, maxSpawnAmount = 1,
		rodeLength = 7000, endless = true}
	}
	for i = 1,table.getn(armies) do
		SetupArmy(armies[i])
		EnlargeArmy(armies[i], {leaderType = armies[i].spawnTypes[1][1]})
		EnlargeArmy(armies[i], {leaderType = armies[i].spawnTypes[2][1]})
		SetupAITroopSpawnGenerator("SpawnGenerator" .. i, armies[i])
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","Control_NV_Armies",1,{},{armies[i].player, armies[i].id, armies[i].spawnGenerator})
	end
end
Control_NV_Armies = function(_player, _id, _building)
	local army = ArmyTable[_player][_id + 1]
	if not IsDead(army) then
		Defend(army)
	else
		if IsDead(_building) then
			return true
		end
	end
end 