
--------------------------------------------------------------------------------
-- MapName: (6) Tropensturm
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

	Version = 1.2,

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
	TagNachtZyklus(24,1,0,0,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	for i = 1,10 do
		CreateWoodPile("Holz"..i,990000)
	end

	LocalMusic.UseSet = MEDITERANEANMUSIC
	for i = 1, 6 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
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
	Peacetime = 40,

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
		StartCountdown(round(EMS_CustomMapConfig.Peacetime*60*0.9),DuerreStart,false)
	end,
	Callback_OnPeacetimeEnded = function()
		Display.SetFarClipPlaneMinAndMax(0, 0)
		Logic.WaterSetAbsoluteHeight(1,1,630,630,1610)
		Logic.UpdateBlocking(10,10,630,630)
		GUI.RebuildMinimapTerrain()
	end


};


function DuerreStart()
	StartSummer(24*60*60)
	Display.SetFarClipPlaneMinAndMax(0, 0)

	Logic.WaterSetAbsoluteHeight(1,1,630,630,1660)
	Logic.UpdateBlocking(10,10,630,630)
	GUI.RebuildMinimapTerrain()
end
	 