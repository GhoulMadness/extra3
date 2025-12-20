--------------------------------------------------------------------------------
-- MapName: (2) Schnitters Abenddämmerung
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
	TagNachtZyklus(24,1,1,-1,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	Display.SetPlayerColorMapping(6,NPC_COLOR)
	Display.SetPlayerColorMapping(3,3)
	Display.SetPlayerColorMapping(8,NPC_COLOR)
	SetPlayerName(3,"Schnitters Untergebene")
	SetHostile(1,3)
	SetHostile(2,3)
	--Mission_InitGroups()

	LocalMusic.UseSet = DARKMOORMUSIC


	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
	end
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end


	end,

	Callback_OnGameStart = function()
		CreateNVArmies()
	end,
	Callback_OnPeacetimeEnded = function()

	end,
	Peacetime = 0,

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
		{player = 3, id = 0, strength = 12, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn1"), spawnPos = GetPosition("NV_Spawn1"), spawnGenerator = GetID("NV_Tower1"), respawnTime = 3*60, maxSpawnAmount = 2,
		rodeLength = 12000, endless = true},

		{player = 3, id = 1, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn2"), spawnPos = GetPosition("NV_Spawn2"), spawnGenerator = GetID("NV_Tower2"), respawnTime = 4*60, maxSpawnAmount = 2,
		rodeLength = 12000, endless = true},

		{player = 3, id = 2, strength = 6, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn3"), spawnPos = GetPosition("NV_Spawn3"), spawnGenerator = GetID("NV_Tower3"), respawnTime = 2*60, maxSpawnAmount = 1,
		rodeLength = 9000, endless = true},

		{player = 3, id = 3, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn4"), spawnPos = GetPosition("NV_Spawn4"), spawnGenerator = GetID("NV_Tower4"), respawnTime = 3*60, maxSpawnAmount = 1,
		rodeLength = 5500, endless = true},

		{player = 3, id = 4, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn5"), spawnPos = GetPosition("NV_Spawn5"), spawnGenerator = GetID("NV_Tower5"), respawnTime = 4*60, maxSpawnAmount = 1,
		rodeLength = 12000, endless = true},

		{player = 3, id = 5, strength = 16, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("Evil_Base1"), spawnPos = GetPosition("Evil_Base1"), spawnGenerator = GetID("Evil_HQ1"), respawnTime = 3*60, maxSpawnAmount = 2,
		rodeLength = 10000, endless = true},


		{player = 3, id = 6, strength = 12, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn6"), spawnPos = GetPosition("NV_Spawn6"), spawnGenerator = GetID("NV_Tower6"), respawnTime = 3*60, maxSpawnAmount = 2,
		rodeLength = 12000, endless = true},

		{player = 3, id = 7, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn7"), spawnPos = GetPosition("NV_Spawn7"), spawnGenerator = GetID("NV_Tower7"), respawnTime = 4*60, maxSpawnAmount = 2,
		rodeLength = 12000, endless = true},

		{player = 3, id = 8, strength = 6, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn8"), spawnPos = GetPosition("NV_Spawn8"), spawnGenerator = GetID("NV_Tower8"), respawnTime = 2*60, maxSpawnAmount = 1,
		rodeLength = 9000, endless = true},

		{player = 3, id = 9, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn9"), spawnPos = GetPosition("NV_Spawn9"), spawnGenerator = GetID("NV_Tower9"), respawnTime = 3*60, maxSpawnAmount = 1,
		rodeLength = 5500, endless = true},

		{player = 3, id = 10, strength = 8, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("NV_Spawn10"), spawnPos = GetPosition("NV_Spawn10"), spawnGenerator = GetID("NV_Tower10"), respawnTime = 4*60, maxSpawnAmount = 1,
		rodeLength = 12000, endless = true},

		{player = 3, id = 11, strength = 16, spawnTypes = {{Entities.CU_Evil_LeaderBearman1, 16}, {Entities.CU_Evil_LeaderSkirmisher1, 16}},
		position = GetPosition("Evil_Base2"), spawnPos = GetPosition("Evil_Base2"), spawnGenerator = GetID("Evil_HQ2"), respawnTime = 3*60, maxSpawnAmount = 2,
		rodeLength = 10000, endless = true},
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
end
function Mission_InitGroups()
	CreateMilitaryGroup(1,Entities.PU_LeaderRifle2,8,GetPosition("Spieler1"))
	CreateMilitaryGroup(2,Entities.PU_LeaderRifle2,8,GetPosition("Spieler2"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV1"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV2"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV3"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV4"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV5"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV6"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV7"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV8"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV9"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV10"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV11"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV12"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV13"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV14"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV15"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV16"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV17"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV18"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV19"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV20"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV21"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV22"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV23"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV24"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV25"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV26"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV27"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV28"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV29"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV30"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV31"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV32"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV33"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV34"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV35"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV36"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV37"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV38"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV39"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV40"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV41"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV42"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV43"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV44"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV45"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV46"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV47"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV48"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV49"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV50"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV51"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV52"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV53"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV54"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV55"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV56"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV57"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV58"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV59"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV60"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV55"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV56"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV57"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV58"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV59"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV60"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV61"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV61"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV62"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV62"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV63"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV63"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV64"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV64"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV65"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV65"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV66"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV66"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV67"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV67"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV68"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV68"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV69"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV69"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV69"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV70"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV70"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV6"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV9"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV11"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV14"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV19"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV21"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV31"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV33"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV35"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV39"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV46"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV55"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV59"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV61"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV62"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV63"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV64"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV65"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV66"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV67"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV68"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV69"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV70"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV70"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV70"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV71"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV72"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV73"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV71"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV71"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV72"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV72"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV73"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV74"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV75"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV76"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV74"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV74"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV75"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV75"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV76"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV77"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV78"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV79"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV80"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV81"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV82"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV83"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV84"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV85"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV86"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV87"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV88"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV89"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV90"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV91"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV92"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV93"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV94"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV95"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV96"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV97"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV98"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV99"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV100"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV101"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV102"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV103"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV104"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV105"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV106"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV107"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV108"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV109"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV110"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV111"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV112"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV113"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV114"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV115"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV116"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV117"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV118"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV119"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV120"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV121"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV123"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV124"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV125"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV126"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV127"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV128"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV129"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV130"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV131"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV132"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV133"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV134"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV135"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV136"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV137"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV137"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV137"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderBearman1,16,GetPosition("NV137"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV82"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV85"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV87"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV90"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV95"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV97"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV111"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV113"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV115"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV119"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV125"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV128"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV131"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV135"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV83"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV86"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV100"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV101"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV104"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV107"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV110"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV116"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV120"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV121"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV138"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV138"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV138"))
	CreateMilitaryGroup(3,Entities.CU_Evil_LeaderSkirmisher1,16,GetPosition("NV138"))

end 