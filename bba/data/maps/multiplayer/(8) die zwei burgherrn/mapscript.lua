--------------------------------------------------------------------------------
-- MapName: (8) Die zwei Burgherrn
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

	IncludeGlobals("Tools\\BSinit")

	-- custom Map Stuff

	TagNachtZyklus(24,0,0,0,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	LocalMusic.UseSet = MEDITERANEANMUSIC

	ResearchTechnology(Technologies.B_StoneMason,4)
	ResearchTechnology(Technologies.B_StoneMason,8)
	ResearchTechnology(Technologies.B_Alchemist,3)
	ResearchTechnology(Technologies.B_Alchemist,7)
	ResearchTechnology(Technologies.B_Blacksmith,2)
	ResearchTechnology(Technologies.B_Blacksmith,6)
	ResearchTechnology(Technologies.UP1_Blacksmith,2)
	ResearchTechnology(Technologies.UP1_Blacksmith,6)
	for i = 1, 8 do
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
		StartSimpleJob("SJ_DefeatTeam1")
		StartSimpleJob("SJ_DefeatTeam2")
		local t = {2,3,4,6,7,8}
		for k,v in pairs(t) do
			ForbidTechnology(Technologies.B_Castle,v)
		end
	end,
	Callback_OnPeacetimeEnded = function()
		for i = 1,6 do
			ReplacingEntity("gate"..i,Entities.XD_PalisadeGate2)
		end
	end


};

function SJ_DefeatTeam1()
	if not IsExisting("P1HQ") then
		Logic.PlayerSetGameStateToLost(1)
		Logic.PlayerSetGameStateToLost(2)
		Logic.PlayerSetGameStateToLost(3)
		Logic.PlayerSetGameStateToLost(4)
		Logic.PlayerSetGameStateToWon(5)
		Logic.PlayerSetGameStateToWon(6)
		Logic.PlayerSetGameStateToWon(7)
		Logic.PlayerSetGameStateToWon(8)
		return true
	end
end

function SJ_DefeatTeam2()
	if not IsExisting("P5HQ") then
		Logic.PlayerSetGameStateToLost(5)
		Logic.PlayerSetGameStateToLost(6)
		Logic.PlayerSetGameStateToLost(7)
		Logic.PlayerSetGameStateToLost(8)
		Logic.PlayerSetGameStateToWon(1)
		Logic.PlayerSetGameStateToWon(2)
		Logic.PlayerSetGameStateToWon(3)
		Logic.PlayerSetGameStateToWon(4)
		return true
	end
end
 