--------------------------------------------------------------------------------
-- MapName: (7) Blutmoor
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
_NVsec = 300
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

	IncludeGlobals("Tools\\BSinit")

	-- custom Map Stuff
	TagNachtZyklus(24,1,0,-1,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	for i = 1,7 do
		ForbidTechnology(Technologies.T_MakeSnow, i)
	end

	LocalMusic.UseSet = DARKMOORMUSIC

	local mercenaryId = Logic.GetEntityIDByName("NVTurm")
	Logic.SetModelAndAnimSet(mercenaryId, Models.XD_RuinResidence2)
	for i = 1, 7 do
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
	Peacetime = 45,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 1,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,

	Callback_OnGameStart = function()

	end,
	Callback_OnPeacetimeEnded = function()
		Display.SetFarClipPlaneMinAndMax(0, 0)

		Logic.WaterSetAbsoluteHeight(1,1,760,760,1810)
		Logic.UpdateBlocking(10,10,760,760)
		GUI.RebuildMinimapTerrain()

		ActivateShareExploration(1,8,true)
		ActivateShareExploration(2,8,true)

		Display.SetPlayerColorMapping(8,3)
		SetHostile(3,8)
		SetHostile(4,8)
		SetHostile(5,8)
		SetHostile(6,8)
		SetHostile(7,8)
		SetFriendly(1,8)
		SetFriendly(2,8)

		local armies = {
		{player = 8, id = 0, strength = 20, spawnTypes = {Entities.CU_Evil_LeaderBearman1, Entities.CU_Evil_LeaderSkirmisher1},
		position = GetPosition("NV"), spawnPos = GetPosition("NV"), spawnGenerator = GetID("NVTurm"), rodeLength = 99000}
		}

		SetupArmy(armies[1])
		EnlargeArmy(armies[1], {leaderType = armies[1].spawnTypes[1]})
		for i = 1,2 do
			EnlargeArmy(armies[1], {leaderType = armies[1].spawnTypes[1]})
			EnlargeArmy(armies[1], {leaderType = armies[1].spawnTypes[2]})
		end
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","Control_NV_Armies",1,{},{armies[1].player, armies[1].id, armies[1].spawnGenerator})
		NVRespawns = StartCountdown(_NVsec,NVRespawn,false)
		NVArmies = armies

		local TrNV1 =  {}
		TrNV1.pId = 1
		TrNV1.text = "Zahlt 5000 Schwefel, damit das Nebelvolk sich schneller wieder erholt! "
		TrNV1.cost = { Sulfur = 5000 }
		TrNV1.Callback = NVUpgrade1
		TNV1 = AddTribute(TrNV1)

	end

};

Control_NV_Armies = function(_player, _id, _building)
	local army = ArmyTable[_player][_id + 1]
	if IsDead(_building) then
		StopCountdown(NVRespawns)
	end
	if not IsDead(army) then
		Defend(army)
	else
		if IsDead(_building) then
			return true
		end
	end
end

function NVUpgrade1()
	Message("Das Nebelvolk wird nun schneller neu spawnen!")
	_NVsec = 180
	--Logic.AddTribute(1, NVUpgrade2, _0, _0, "Zahlt 6000 Taler, damit das Nebelvolk sich noch schneller wieder erholt! ", ResourceType.Gold, 6000)
	local TrNV2 =  {}
	TrNV2.pId = 1
	TrNV2.text = "Zahlt 6000 Taler, damit das Nebelvolk sich noch schneller wieder erholt! "
	TrNV2.cost = { Gold = 6000 }
	TrNV2.Callback = NVUpgrade2
	TNV2 = AddTribute(TrNV2)
end
function NVUpgrade2()
	--Logic.AddTribute(1, NVUpgrade3, _0, _0, "Zahlt 10000 Schwefel und 8000 Taler, damit das Nebelvolk extrem schnell wieder erholt! ", ResourceType.Sulfur, 10000, ResourceType.Gold, 8000)
	Message("Das Nebelvolk wird nun noch schneller neu spawnen!")
	_NVsec = 110
	local TrNV3 =  {}
	TrNV3.pId = 1
	TrNV3.text = "Zahlt 8000 Taler und 10000 Schwefel, damit das Nebelvolk sich extrem schnell wieder erholt! "
	TrNV3.cost = { Gold = 8000 , Sulfur = 10000}
	TrNV3.Callback = NVUpgrade3
	TNV3 = AddTribute(TrNV3)
end
function NVUpgrade3()
	Message("Das Nebelvolk wird nun extrem schnell neu spawnen!")
	_NVsec = 50
end
function NVRespawn()
	local army = NVArmies[1]
	if IsWeak(army) then
		for i = 1,3 do
			EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderBearman1})
			if IsWeak(army) then
				break
			end
		end
	end
	if IsWeak(army) then
		EnlargeArmy(army, {leaderType = Entities.CU_Evil_LeaderSkirmisher1})
	end

	NVRespawns = StartCountdown(_NVsec,NVRespawn,false)
end