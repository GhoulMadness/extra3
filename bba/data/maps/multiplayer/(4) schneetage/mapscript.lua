--------------------------------------------------------------------------------
-- MapName: (4) Schneetage
--
-- Author: Ghoul
--
gvMaxPlayers = 4
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
gvXmasEventFlag = 1
EMS_CustomMapConfig =
{

	Version = 1.4,

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

	Mission_InitLocalResources()
	AddPeriodicSummer(10)

	MultiplayerTools.InitCameraPositionsForPlayers()

	--[[cnTable = { ["XmasTree1"] = "Weihnachtsbaum", ["XmasTree2"] = "Weihnachtsbaum" }
	S5Hook.SetCustomNames(cnTable)]]
	gvPresent.Init()
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(3,6)
	SetHostile(4,6)
	for i = 1,6 do
		CreateWoodPile("Holz"..i,10000000)
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end
	for i = 5,7,1 do
		Display.SetPlayerColorMapping(i, 10);
	end
	Display.SetPlayerColorMapping(8,14)
	LocalMusic.UseSet = DARKMOORMUSIC

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,4,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	CreateEntity(0,Entities.XD_Present1,GetPosition("T1Present1"),"T1_Present1")
	CreateEntity(0,Entities.XD_Present2,GetPosition("T1Present2"),"T1_Present2")
	CreateEntity(0,Entities.XD_Present3,GetPosition("T1Present3"),"T1_Present3")
	CreateEntity(0,Entities.XD_Present1,GetPosition("T2Present1"),"T2_Present1")
	CreateEntity(0,Entities.XD_Present2,GetPosition("T2Present2"),"T2_Present2")
	CreateEntity(0,Entities.XD_Present3,GetPosition("T2Present3"),"T2_Present3")

	ChangePlayer("XmasTree1",6)
	MakeInvulnerable("XmasTree1")
	MakeInvulnerable("XmasTree2")
	for i = 1,2 do CUtil.SetEntityDisplayName(Logic.GetEntityIDByName("XmasTree"..i), "Weihnachtsbaum")	end
	InitBanditTroops()
	StartSimpleJob("BanditRespawn")
	Logic.SetModelAndAnimSet(GetEntityId("XmasTree1"),Models.XD_Xmastree1)
	Logic.SetModelAndAnimSet(GetEntityId("XmasTree2"),Models.XD_Xmastree1)


	end,

	Callback_OnGameStart = function()
		TagNachtZyklus(40,1,1,2)
		StartCountdown(30*60,HQDestroyable,false)
		StartCountdown(60*60,SuddenDeath,false)
		for i = 1,4,1 do
			MakeInvulnerable("HQP"..i)
			SetHostile(i,8)
		end

		gvXmasChestActive = false
		gvXmasChestDestroyed = false
		gvXmasChestID = Logic.CreateEntity(Entities.XD_ChestClose,27300,20400,0,0)
		Logic.SetEntityName(gvXmasChestID,"XmasChest")
		StartSimpleJob("ChestControl");
	end,

	Peacetime = 0,
	AntiHQRush = 0,

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

function HQDestroyable()
	Message("Zeit f�r Phase 2. Die Burgen aller Spieler sind nun verwundbar!")
	for i = 1,4 do
	MakeVulnerable("HQP"..i)
	end
end

function SuddenDeath()
	if not gvPresent then
		return
	end

	Message("Phase 3 beginnt nun. Ihr k\195\182nnt ab sofort einen Dom sowie eine Dorfhalle errichten!")

	if not gvPresent.SDPaydayFactor then
		return
	end

	for i = 1,4 do
		AllowTechnology(Technologies.B_Dome,i)
		AllowTechnology(Technologies.B_VillageHall,i)
	end
	StartSimpleJob("gvPresent.SDPayday")

end


function Mission_InitLocalResources()

-- Initial Resources
	local InitGoldRaw 		= 1000000
	local InitClayRaw 		= 1000000
	local InitWoodRaw 		= 1000000
	local InitStoneRaw 		= 1000000
	local InitIronRaw 		= 1000000
	local InitSulfurRaw		= 1000000


	--Add Players Resources
	for i = 5,16 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

   end
end
function InitBanditTroops()
	gvBandpos1 = {}
	gvBandpos2 = {}
	gvBandPatPo = {}
	gvBandpos1.X,gvBandpos1.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn1"))
	gvBandpos2.X,gvBandpos2.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn2"))
	gvBandPatPo.X,gvBandPatPo.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditPatrolCenter"))

	troop1 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
	troop2 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
	troop3 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
	troop4 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
	Logic.GroupPatrol(troop1, gvBandPatPo.X, gvBandPatPo.Y)
	Logic.GroupPatrol(troop2, gvBandPatPo.X, gvBandPatPo.Y)
	Logic.GroupPatrol(troop3, gvBandPatPo.X, gvBandPatPo.Y)
	Logic.GroupPatrol(troop4, gvBandPatPo.X, gvBandPatPo.Y)
end
function BanditRespawn()
	if not IsExisting("BanditTower") then
		return true
	end
	if IsDestroyed(troop1) and IsDestroyed(troop2) then
		troop1 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
		troop2 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
		Logic.GroupPatrol(troop1, gvBandPatPo.X, gvBandPatPo.Y)
		Logic.GroupPatrol(troop2, gvBandPatPo.X, gvBandPatPo.Y)
	end
	if IsDestroyed(troop3) and IsDestroyed(troop4) then
		troop3 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
		troop4 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
		Logic.GroupPatrol(troop3, gvBandPatPo.X, gvBandPatPo.Y)
		Logic.GroupPatrol(troop4, gvBandPatPo.X, gvBandPatPo.Y)
	end
end

gvSilverTechTable = {
						[1] = Technologies.T_SilverPlateArmor,
						[2] = Technologies.T_SilverArcherArmor,
						[3] = Technologies.T_SilverArrows,
						[4] = Technologies.T_SilverSwords,
						[5] = Technologies.T_SilverLance,
						[6] = Technologies.T_SilverBullets,
						[7] = Technologies.T_SilverMissiles,
						[8] = Technologies.T_BloodRush

					}
gvSilverTechStringTable = {
						[1] = "T_SilverPlateArmor",
						[2] = "T_SilverArcherArmor",
						[3] = "T_SilverArrows",
						[4] = "T_SilverSwords",
						[5] = "T_SilverLance",
						[6] = "T_SilverBullets",
						[7] = "T_SilverMissiles",
						[8] = "T_BloodRush"

					}

function ChestControl()
	if not IsExisting("BanditTower") then
		gvXmasChestActive = true;
	end
	local entities, pos, randomEvent, randomEventText, randomEventAmount;
	if  gvXmasChestActive and not  gvXmasChestDestroyed then
		pos = 	{
				X = 27300,
				Y = 20400
				}
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 600, 1)};
			if entities[1] > 0 then
				randomEvent = gvXmasChestEvents[Logic.GetRandom(7)+1]
				if randomEvent == "SilverPot" then
					randomEventAmount = 300 + Logic.GetRandom(300)
					randomEventText = randomEventAmount .. "Silber"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Silver,randomEventAmount)
				elseif randomEvent == "DarioInTheBox" then
					if Logic.GetNumberOfEntitiesOfTypeOfPlayer(j, Entities.PU_Hero1c) == 0 then
						randomEventAmount = Entities.PU_Hero1c
						randomEventText = "Dario"
					else
						randomEventAmount = Entities.PU_Hero5
						randomEventText = "Ari"
					end
					Logic.CreateEntity(randomEventAmount,pos.X,pos.Y,j,0)
				elseif randomEvent == "SilverTechMiracle" then
					local tabpos = Logic.GetRandom(7)+1
					randomEventAmount = gvSilverTechTable[tabpos]
					randomEventText = XGUIEng.GetStringTableText("names/"..gvSilverTechStringTable[tabpos])
					Logic.SetTechnologyState(j,randomEventAmount,3)
				elseif randomEvent == "LuckyPayday" then
					randomEventAmount = Logic.GetPlayerPaydayCost(j)*(Logic.GetRandom(2)+1)
					randomEventText = randomEventAmount .. "Taler"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
				elseif randomEvent == "ThunderGodsBlessing" then
					randomEventAmount = 500+Logic.GetRandom(500)
					randomEventText = randomEventAmount .. "Sekunden Immunit\195\164t gegen\195\188ber Blitzeinschl\195\164gen"
					gvLightning.RodProtected[j] = true
					Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","LightningRod_UnProtected",1,{},{j,randomEventAmount})
				elseif randomEvent == "SlipperyThief" then
					randomEventAmount = Technologies.T_Chest_ThiefBuff
					randomEventText = "Noch schnellere Diebe"
					Logic.SetTechnologyState(j, randomEventAmount, 3)
				elseif randomEvent == "WhatIsAVillageHall" then
					randomEventAmount = Technologies.B_VillageHall
					randomEventText = "Bau von Dorfhallen erlaubt"
					Logic.SetTechnologyState(j, randomEventAmount, 2)
				elseif randomEvent == "LovingBuddies" then
					local ally
					if j == 1 then
						ally = 2
					elseif j == 2 then
						ally = 1
					elseif j == 3 then
						ally = 4
					elseif j == 4 then
						ally = 3
					end
					randomEventAmount = round(Logic.GetPlayersGlobalResource(j, ResourceType.GoldRaw)/2)
					randomEventText = "Der Verb\195\188ndete erh\195\164lt" .. randomEventAmount .. "Taler"
					Logic.AddToPlayersGlobalResource(ally,ResourceType.GoldRaw,randomEventAmount)
				end

				Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat die Schatztruhe der Barbaren gepl\195\188ndert. Inhalt: " .. randomEventText );

				gvXmasChestDestroyed = true;
				ReplacingEntity("XmasChest", Entities.XD_ChestOpen);
				return true;
			end
		end
	end
end
gvXmasChestEvents = {
						-- zuf�llige Menge Silber
						[1] = "SilverPot",
						-- Dario als zus�tzlicher Held
						[2] = "DarioInTheBox",
						-- zuf�llige Tech aus der Silberschmelze
						[3] = "SilverTechMiracle",
						-- Taler abh�ngig vom Zahltag
						[4] = "LuckyPayday",
						-- einige Minuten immun gegen Blitzeinschl�ge
						[5] = "ThunderGodsBlessing",
						-- spezielle Tech f�r Diebe, erh�htes Lauftempo
						[6] = "SlipperyThief",
						-- Dorfhalle erlaubt, als Belohnung nur m�glich vor SuddenDeath
						[7] = "WhatIsAVillageHall",
						-- Verb�ndeter erh�lt zuf�llige Ressourcen abh�ngig der eigenen H�he
						[8] = "LovingBuddies"
					}
 