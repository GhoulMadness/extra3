--------------------------------------------------------------------------------
-- MapName: (2) Skal
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

	Version = 1,
	
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
	TagNachtZyklus(34,1,1,0)

	MultiplayerTools.InitCameraPositionsForPlayers()	
	
	LocalMusic.UseSet = EUROPEMUSIC

	for i = 1, 2 do 
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
	
	Callback_OnGameStart = function()
		
	end,
	Callback_OnPeacetimeEnded = function()
		StartWinter(60*60*10)
		for i =1,2 do
			Logic.SetTechnologyState(i,Technologies.T_MakeSummer,0)
			Logic.SetTechnologyState(i,Technologies.T_MakeRain,0)
			Logic.SetTechnologyState(i,Technologies.T_MakeThunderstorm,0)
		end
	end,
	Peacetime = 20,
	
	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 3,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,
	--[[Cannon5 = 1,
	Cannon6 = 1,
	Dome = 0,
	Scaremonger = 0,
	Silversmith = 0,
	Lighthouse = 0,
	MercenaryTower = 0,
	Mint = 0,
	Tradepost = 0
	
	]]
};

 