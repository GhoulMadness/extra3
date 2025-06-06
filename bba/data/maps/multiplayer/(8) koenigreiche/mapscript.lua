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
		for i = 1, 8 do
			Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
		end
		if XNetwork.Manager_DoesExist() == 0 then
			for i=1,8,1 do
				MultiplayerTools.DeleteFastGameStuff(i)
			end
			local PlayerID = GUI.GetPlayerID()
			Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
			Logic.PlayerSetGameStateToPlaying( PlayerID )
		end
		for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Wall)) do
			MapTools.ReplaceEntity(eID, Entities[string.gsub(Logic.GetEntityTypeName(Logic.GetEntityType(eID)), "Dark", "")], 0)
		end
	end,

	Callback_OnGameStart = function()
		for i=1,8 do
			ForbidTechnology(Technologies.T_MakeSnow, i)
			ForbidTechnology(Technologies.B_Bridge, i)
		end
		bridgecount = 0
		for eID in CEntityIterator.Iterator(CEntityIterator.OfTypeFilter(Entities.XD_DrawBridgeOpen2)) do
			bridgecount = bridgecount + 1
			SetEntityName(eID , "bridge" .. bridgecount)
			ChangePlayer("bridge" .. bridgecount , 0)
		end
	end,

	Callback_OnPeacetimeEnded = function()
		for i = 1, bridgecount do
			MapTools.ReplaceEntity ("bridge" .. i, Entities.PB_DrawBridgeClosed2, 0)
		end
		for i=1,8 do
			AllowTechnology(Technologies.T_MakeSnow, i)
			AllowTechnology(Technologies.B_Bridge, i)
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