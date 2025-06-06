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

	TagNachtZyklus(48,0,0,0,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	MacheEntities()

	-- nix f�r Dr�ckeberger : )
	DZTrade_PunishmentJob = function() return true end
	GUIAction_ExpelSettler = function() end
	GUI.SellBuilding = function() end
	GUIAction_ExpelAll = function() end

	LocalMusic.UseSet = EUROPEMUSIC
	for i = 1, 2 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
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
		--Storyscript
		for k,v in Technologies do
			ResearchTechnology(Technologies[k],1)
			ResearchTechnology(Technologies[k],2)
		end
		 MacheSoldaten()

	end,
	ResourceLevel = 1,
	Ressources =
	{
		Normal = {
			[1] = {
				0,
				0,
				0,
				0,
				0,
				0,
			},
		},
	},

	Peacetime = 0,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 1,
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

----------------------------
function MacheSoldaten()
	for i=1,2 do
		for s=1,4 do
			CreateMilitaryGroup(i,Entities.PU_LeaderPoleArm4,12,GetPosition("P"..i.."_BSoldiers"..s))
		end
		for s=1,4 do
			CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Schutzen"..s))
		end
		for s=1,5 do
			CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Arb"..s))
		end
		for s=1,10 do
			CreateMilitaryGroup(i,Entities.PU_LeaderHeavyCavalry2,3,GetPosition("P"..i.."_Caval"..s))
		end
		for s=1,5 do
			CreateMilitaryGroup(i,Entities.PU_LeaderCavalry2,6,GetPosition("P"..i.."_BCaval"..s))
		end
		local pos = GetPosition("mainArmy"..i)
		for y=-1600,1600,600 do
			for x=-1500,0,600 do
				CreateMilitaryGroup(i,Entities.PU_LeaderSword4,12,{X = pos.X+x,Y = pos.Y+y})
			end
		end
	   CreateMilitaryGroup(i,Entities.PU_LeaderSword4,12,GetPosition("P"..i.."_Wache1"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderSword4,12,GetPosition("P"..i.."_Wache2"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Wache3"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Wache4"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderHeavyCavalry2,3,GetPosition("P"..i.."_Wache5"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderHeavyCavalry2,3,GetPosition("P"..i.."_Wache6"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderRifle2,6,GetPosition("P"..i.."_Wache7"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderRifle2,6,GetPosition("P"..i.."_Wache8"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Wache9"))
	   CreateMilitaryGroup(i,Entities.PU_LeaderBow4,12,GetPosition("P"..i.."_Wache10"))
	end
end
function MacheEntities()
	local pos = GetPosition("P1_Kraftwerk1")
	Tools.CreateGroup(1,Entities.PB_PowerPlant1,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Kraftwerk2")
	Tools.CreateGroup(1,Entities.PB_PowerPlant1,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Kraftwerk3")
	Tools.CreateGroup(1,Entities.PB_PowerPlant1,0,pos.X,pos.Y,270.00)
	local pos = GetPosition("P1_Gutshof")
	Tools.CreateGroup(1,Entities.PB_Farm3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Wohnhaus")
	Tools.CreateGroup(1,Entities.PB_Residence3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Leuchtturm")
	Tools.CreateGroup(1,Entities.CB_LighthouseActivated,0,pos.X,pos.Y,90.00)
	local pos = GetPosition("P1_Wetterturm")
	Tools.CreateGroup(1,Entities.PB_WeatherTower1,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Burg")
	Tools.CreateGroup(1,Entities.PB_Headquarters2,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm1")
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm2")
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm3")
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm4")
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm5")
	Tools.CreateGroup(1,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm6")
	Tools.CreateGroup(1,Entities.PB_Tower2,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P1_Turm7")
	Tools.CreateGroup(1,Entities.PB_Tower2,0,pos.X,pos.Y,0.00)
	------------------------------------
	local pos = GetPosition("P2_Kraftwerk1")
	Tools.CreateGroup(2,Entities.PB_PowerPlant1,0,pos.X,pos.Y,180.00)
	local pos = GetPosition("P2_Kraftwerk2")
	Tools.CreateGroup(2,Entities.PB_PowerPlant1,0,pos.X,pos.Y,180.00)
	local pos = GetPosition("P2_Kraftwerk3")
	Tools.CreateGroup(2,Entities.PB_PowerPlant1,0,pos.X,pos.Y,270.00)
	local pos = GetPosition("P2_Gutshof")
	Tools.CreateGroup(2,Entities.PB_Farm3,0,pos.X,pos.Y,180.00)
	local pos = GetPosition("P2_Wohnhaus")
	Tools.CreateGroup(2,Entities.PB_Residence3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Leuchtturm")
	Tools.CreateGroup(2,Entities.CB_LighthouseActivated,0,pos.X,pos.Y,90.00)
	local pos = GetPosition("P2_Wetterturm")
	Tools.CreateGroup(2,Entities.PB_WeatherTower1,0,pos.X,pos.Y,180.00)
	local pos = GetPosition("P2_Burg")
	Tools.CreateGroup(2,Entities.PB_Headquarters2,0,pos.X,pos.Y,180.00)
	local pos = GetPosition("P2_Turm1")
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm2")
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm3")
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm4")
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm5")
	Tools.CreateGroup(2,Entities.PB_Tower3,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm6")
	Tools.CreateGroup(2,Entities.PB_Tower2,0,pos.X,pos.Y,0.00)
	local pos = GetPosition("P2_Turm7")
	Tools.CreateGroup(2,Entities.PB_Tower2,0,pos.X,pos.Y,0.00)
end

 