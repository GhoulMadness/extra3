--------------------------------------------------------------------------------
-- MapName: (2) Schwefelwahn
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
	TagNachtZyklus(24,1,1,0)

	MultiplayerTools.InitCameraPositionsForPlayers()

	for i = 1,2 do
		CreateWoodPile("Holz"..i,10000000)
		ForbidTechnology(Technologies.T_MakeSnow, i);
	end

	LocalMusic.UseSet = DARKMOORMUSIC

	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
		ForbidTechnology(Technologies.T_MakeSnow, i);
	end;
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

	end,
	Callback_OnPeacetimeEnded = function()
		for i = 1,2 do
			AllowTechnology(Technologies.T_MakeSnow, i)
		end
		for i = 1,8 do
			ReplaceEntity("gate"..i,Entities.XD_PalisadeGate2)
		end
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


 