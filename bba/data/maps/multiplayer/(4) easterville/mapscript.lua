initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not initEMS() then
	local errMsgs =
	{
		["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr Überprüfe ob alle Dateien am richtigen Ort sind!",
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
gvET23Flag = 1
EMS_CustomMapConfig =
{

	Version = 1.00,

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
		AddPeriodicSummer(10)

		MultiplayerTools.InitCameraPositionsForPlayers()

		LocalMusic.UseSet = HIGHLANDMUSIC
		for i = 1, 4 do
			Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i))
		end
		Display.SetPlayerColorMapping(7, NPC_COLOR)
		InitMerchants()

		if XNetwork.Manager_DoesExist() == 0 then
			math.randomseed(Game.RealTimeGetMs())
			for i=1,4,1 do
				MultiplayerTools.DeleteFastGameStuff(i)
			end
			local PlayerID = GUI.GetPlayerID()
			Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
			Logic.PlayerSetGameStateToPlaying( PlayerID )
		end


	end,

	Callback_OnGameStart = function()
		for i = 1,4 do
			ForbidTechnology(Technologies.T_MakeSnow,i)
		end
		if XNetwork.Manager_DoesExist() == 0 then
			local InitGoldRaw 		= 1000
			local InitClayRaw 		= 1800
			local InitWoodRaw 		= 1500
			local InitStoneRaw 		= 800
			local InitIronRaw 		= 50
			local InitSulfurRaw		= 50
			for i = 2,4 do
				--Add Players Resources
				Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
			end
			Logic.ActivateUpdateOfExplorationForAllPlayers()
			Input.KeyBindDown(Keys.ModifierAlt+Keys.P, "SwitchPlayerID()", 2)
		end
		TagNachtZyklus(24,1,0,-3,1)
		-- register bandits and evil stuff in statistics
		Logic.SetPlayerRawName(7, "???")
		Logic.PlayerSetIsHumanFlag(7, 1)
		Logic.PlayerSetPlayerColor(7, GUI.GetPlayerColor(7))
		--
		InitEggs(40, 1)
		InitEggs(40, 2)
	end,

	Callback_OnPeacetimeEnded = function()
		for i = 1,4 do
			AllowTechnology(Technologies.T_MakeSnow,i)
			DestroyEntity("rock".. i)
		end
	end,

	Peacetime = 40,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 2,
	WeatherChangeLockTimer = 1,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1
}
function SwitchPlayerID()
	local oldID = GUI.GetPlayerID()
	local newID
	if oldID < 4 then
		newID = oldID + 1
	else
		newID = 1
	end
	GUI.SetControlledPlayer(newID)
	local pos = GetPlayerStartPosition(newID)
	Camera.ScrollSetLookAt(pos.X, pos.Y)
	Message("Ihr spielt nun aus der Perspektive von Spieler "..newID)
end
function InitMerchants()
	for i = 1,2 do
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merchant"..i), Entities.CU_VeteranLieutenant, 4, ResourceType.Gold, 2500)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merchant"..i), Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merchant"..i), Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(Logic.GetEntityIDByName("merchant"..i), Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
	end
end
CenterPosByTeam = {	[1] = {X = 12800, Y = 33600},
					[2] = {X = 54800, Y = 33600}}
------------------------------------------------------------------------------------
function InitEggs(_amount, _team)

	local totaleggs = _amount
	local count = 0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec = CUtil.GetSector(CenterPosByTeam[_team].X /100, CenterPosByTeam[_team].Y /100)
	local currsec
	EasterEggposTable = EasterEggposTable or {}
	EasterEggposTable[_team] = EasterEggposTable[_team] or {}
	while count < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		currsec = CUtil.GetSector(posX/100, posY/100)
		if sec == currsec and GetDistance({X = posX, Y = posY}, CenterPosByTeam[_team]) < 20000 then
			count = count + 1
			Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T".._team.."_"..count)
			EasterEggposTable[_team][count] = {X = posX, Y = posY}
		end
	end

	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlEggs",1,{},{_team})
end

function ControlEggs(_team)

	if table.getn(EasterEggposTable[_team]) > 0 then
		for j = 1, 4 do
			for k, v in pairs(EasterEggposTable[_team]) do
				entities = {Logic.GetPlayerEntitiesInArea(j, 0, v.X, v.Y, 200, 1)};
				if entities[1] > 0 then
					if Logic.IsHero(entities[2]) == 1 then
						local time = Logic.GetTime()/60
						local randomEventAmount = round(45+math.random(10)*time)
						local rtypetext = "Taler"
						if time < 35 then
							Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
						else
							rtypetext = "Eisen"
							Logic.AddToPlayersGlobalResource(j,ResourceType.IronRaw,randomEventAmount)
						end
						DestroyEntity(Logic.GetEntityAtPosition(v.X, v.Y))
						table.remove(EasterEggposTable[_team], k)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein Osterei gefunden. Inhalt: "..randomEventAmount.." ".. rtypetext)
							Sound.PlayGUISound(Sounds.OnKlick_Select_ari, 142)
						end
					end
				end
			end
		end
	else
		return true
	end
end
function RespawnEggsJob()
	if table.getn(EasterEggposTable[1]) + table.getn(EasterEggposTable[2]) == 0 then
		for i = 1, 2 do
			InitEggs(math.max(round(40 - Logic.GetTime()/300), 5), i)
		end
	end
end
 