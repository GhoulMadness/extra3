Script.Load("maps/externalmap/misc.lua")
--------------------------------------------------------------------------------
-- MapName: (4) Winterberge
--
-- Author: Ghoul
--
gvMaxPlayers = 4
if not CNetwork then
	math.randomseed(XGUIEng.GetSystemTime())
end
do
	math.random(3)
	local num = math.random(3)
	if num == 3 then
		for i = 1,20 do
			Logic.DestroyEntity(Logic.GetEntityIDByName("delete"..i))
		end
		Script.Load("maps/externalmap/middle_leftside.lua")
		Script.Load("maps/externalmap/middle_rightside.lua")
	end
	--LuaDebugger.Log(num)
end
--------------------------------------------------------------------------------
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
gvXmasEventFlag = 1
gvXmas2021Flag = 1
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
	Script.Load("maps/externalmap/bridgeright_terrain.lua")
	-- custom Map Stuff
	Mission_InitLocalResources()
	AddPeriodicSummer(10)

	MultiplayerTools.InitCameraPositionsForPlayers()

	gvPresent.Init()
	SetHostile(1,5)
	SetHostile(2,5)
	SetHostile(3,6)
	SetHostile(4,6)
	for i = 1,6 do
		Logic.LeaderGetOneSoldier(Logic.GetEntityIDByName("maj"..i))
		Logic.LeaderGetOneSoldier(Logic.GetEntityIDByName("maj"..i))
	end
	for i = 1,4 do
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

	do
		local num = math.random(2)
		if num == 1 then
			ReplaceEntity("bridgeright",Entities.XD_DrawBridgeOpen2)
		else
			ReplaceEntity("bridgeright",Entities.XD_NeutralBridge2)
			BridgeTerrainAdjustment()
		end
	end
	ChangePlayer("XmasTree1",6)
	MakeInvulnerable("XmasTree1")
	MakeInvulnerable("XmasTree2")
	for i = 1,2 do CUtil.SetEntityDisplayName(Logic.GetEntityIDByName("XmasTree"..i), "Weihnachtsbaum")	end
	InitBanditTroops()
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(5),CEntityIterator.InCircleFilter(28100, 50600, 6000)) do
		if CNetwork then
			ChangePlayer(eID,9)
		else
			ChangePlayer(eID,7)
		end
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(5),CEntityIterator.InCircleFilter(28100, 10300, 6000)) do
		if CNetwork then
			ChangePlayer(eID,9)
		else
			ChangePlayer(eID,7)
		end
	end
	if CNetwork then
		ChangePlayer("mercenary1",9)
		ChangePlayer("mercenary2",9)
		Display.SetPlayerColorMapping(9,NPC_COLOR)
	else
		ChangePlayer("mercenary1",7)
		ChangePlayer("mercenary2",7)
	end
	InitMerchants()
	InitTributes()
	StartSimpleJob("BanditRespawn")
	Logic.SetModelAndAnimSet(GetEntityId("XmasTree1"),Models.XD_Xmastree1)
	Logic.SetModelAndAnimSet(GetEntityId("XmasTree2"),Models.XD_Xmastree1)

	end,

	Callback_OnGameStart = function()
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
		TagNachtZyklus(24,1,1,1,1)
		StartCountdown(30*60,HQDestroyable,false)
		StartCountdown(60*60,SuddenDeath,false)
		CUtilMemory.GetMemory(9002416)[0][16][Entities.PB_VillageHall1 * 8 + 2][44]:SetInt(30)
		for i = 1,4,1 do
			MakeInvulnerable("HQP"..i)
			MakeInvulnerable("rock_p"..i)
			SetHostile(i,8)
		end
		MakeInvulnerable("bridge1")
		MakeInvulnerable("bridge2")

		local pos = GetPosition("BanditChestTower")
		gvXmasChests.Bandit.ID = Logic.CreateEntity(Entities.XD_ChestClose,pos.X,pos.Y,0,0)
		Logic.SetEntityName(gvXmasChests.Bandit.ID,"XmasChestBandit")

		local postop = GetPosition("chesttop"..math.random(3))
		gvXmasChests.Top.ID = Logic.CreateEntity(Entities.XD_ChestGold,postop.X,postop.Y,0,0)
		Logic.SetEntityName(gvXmasChests.Top.ID,"XmasChestTop")

		local postopleft = GetPosition("chesttopleft"..math.random(3))
		gvXmasChests.TopLeft.ID = Logic.CreateEntity(Entities.XD_ChestGold,postopleft.X,postopleft.Y,0,0)
		Logic.SetEntityName(gvXmasChests.TopLeft.ID,"XmasChestTopLeft")

		local postopright = GetPosition("chesttopright"..math.random(3))
		gvXmasChests.TopRight.ID = Logic.CreateEntity(Entities.XD_ChestGold,postopright.X,postopright.Y,0,0)
		Logic.SetEntityName(gvXmasChests.TopRight.ID,"XmasChestTopRight")

		local posbottom = GetPosition("chestbottom"..math.random(3))
		gvXmasChests.Bottom.ID = Logic.CreateEntity(Entities.XD_ChestGold,posbottom.X,posbottom.Y,0,0)
		Logic.SetEntityName(gvXmasChests.Bottom.ID,"XmasChestBottom")

		local posbottomleft = GetPosition("chestbottomleft"..math.random(3))
		gvXmasChests.BottomLeft.ID = Logic.CreateEntity(Entities.XD_ChestGold,posbottomleft.X,posbottomleft.Y,0,0)
		Logic.SetEntityName(gvXmasChests.BottomLeft.ID,"XmasChestBottomLeft")

		local posbottomright = GetPosition("chestbottomright"..math.random(3))
		gvXmasChests.BottomRight.ID = Logic.CreateEntity(Entities.XD_ChestGold,posbottomright.X,posbottomright.Y,0,0)
		Logic.SetEntityName(gvXmasChests.BottomRight.ID,"XmasChestBottomRight")

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
	TowerLimit = 7

};
function SwitchPlayerID()
	local oldID = GUI.GetPlayerID()
	local newID
	if oldID < 4 then
		newID = oldID + 1
		GUI.SetControlledPlayer(newID)
	else
		newID = 1
		GUI.SetControlledPlayer(newID)
	end
	Message("Ihr spielt nun aus der Perspektive von Spieler "..newID)
end
GUI.SellBuildingOrig = GUI.SellBuilding
GUI.SellBuilding = function(_id)
	-- Abriss von Aussichtstürmen und Ballistatürmen erst nach 30 Minuten möglich
	if Logic.GetTime() <= 30*60 then
		if Logic.GetEntityType(_id) == Entities.PB_Tower2 then
			if GUI.GetPlayerID() == Logic.EntityGetPlayer(_id) then
				GUI.AddNote("Abriss dieses Gebäudetyps auf dieser Karte zu dieser Zeit nicht möglich")
				local soundpaths = {[1] =	"Sounds\\voicesmentor\\comment_badplay_rnd_06.wav",
									[2] = 	"Sounds\\voicesworker\\worker_funnyno_rnd_10.wav",
									[3]	= 	"Sounds\\voicesworker\\worker_funnyno_rnd_05.wav",
									[4] = 	"Sounds\\voicesworker\\worker_funnyno_rnd_02.wav"
									}
				Stream.Start(soundpaths[XGUIEng.GetRandom(3)+1],150)
			end
		else
			GUI.SellBuildingOrig(_id)
		end
	else
		GUI.SellBuildingOrig(_id)
	end
end
function HQDestroyable()
	Message("Zeit für Phase 2. Die Burgen aller Spieler sind nun verwundbar!")
	for i = 1,4 do
	MakeVulnerable("HQP"..i)
	end
	if Logic.GetEntityType(Logic.GetEntityIDByName("bridgeright")) == Entities.XD_DrawBridgeOpen2 then
		ReplaceEntity("bridgeright",Entities.PB_DrawBridgeClosed2)
		MakeInvulnerable("bridgeright")
	end
end

function SuddenDeath()
	if not gvPresent then
		return
	end

	Message("Phase 3 beginnt nun. Ihr könnt ab sofort einen Dom sowie eine Dorfhalle errichten!")

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
	local InitGoldRaw 		= 100000
	local InitClayRaw 		= 100000
	local InitWoodRaw 		= 100000
	local InitStoneRaw 		= 100000
	local InitIronRaw 		= 100000
	local InitSulfurRaw		= 100000


	--Add Players Resources
	for i = 5,16 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)

   end
end
function InitMerchants()
	local mercenaryId1 = Logic.GetEntityIDByName("mercenary1")
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_Thief, 2, ResourceType.Gold, 500)
	Logic.AddMercenaryOffer(mercenaryId1, Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
	Logic.AddMercenaryOffer(mercenaryId1, Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)

	local mercenaryId2 = Logic.GetEntityIDByName("mercenary2")
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_Thief, 2, ResourceType.Gold, 500)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
	Logic.AddMercenaryOffer(mercenaryId2, Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
end
function InitTributes()
	TributeGateP1()
	TributeGateP2()
	TributeGateP3()
	TributeGateP4()
	TributeVillageP1()
	TributeVillageP2()
	TributeVillageP3()
	TributeVillageP4()
	TributeWarP1()
	TributeWarP2()
	TributeWarP3()
	TributeWarP4()
end
function TributeGateP1()
local TrGP1 =  {}
TrGP1.pId = 1
TrGP1.text = "Zahlt 50 Taler, um die Palisadentore hinter Eurer Burg zu öffnen. @cr Dadurch wird Eure Burg verwundbar!"
TrGP1.cost = { Gold = 50 }
TrGP1.Callback = TributePaid_GP1
TPGP1 = AddTribute(TrGP1)
end
function TributeGateP2()
local TrGP2 =  {}
TrGP2.pId = 2
TrGP2.text = "Zahlt 50 Taler, um die Palisadentore hinter Eurer Burg zu öffnen. @cr Dadurch wird Eure Burg verwundbar!"
TrGP2.cost = { Gold = 50 }
TrGP2.Callback = TributePaid_GP2
TPGP2 = AddTribute(TrGP2)
end
function TributeGateP3()
local TrGP3 =  {}
TrGP3.pId = 3
TrGP3.text = "Zahlt 50 Taler, um die Palisadentore hinter Eurer Burg zu öffnen. @cr Dadurch wird Eure Burg verwundbar!"
TrGP3.cost = { Gold = 50 }
TrGP3.Callback = TributePaid_GP3
TPGP3 = AddTribute(TrGP3)
end
function TributeGateP4()
local TrGP4 =  {}
TrGP4.pId = 4
TrGP4.text = "Zahlt 50 Taler, um die Palisadentore hinter Eurer Burg zu öffnen. @cr Dadurch wird Eure Burg verwundbar!"
TrGP4.cost = { Gold = 50 }
TrGP4.Callback = TributePaid_GP4
TPGP4 = AddTribute(TrGP4)
end
function TributePaid_GP1()
	ReplacingEntity("palisade_p1",Entities.XD_PalisadeGate2)
	MakeVulnerable("rock_p1")
	MakeVulnerable("HQP1")
end
function TributePaid_GP2()
	ReplacingEntity("palisade_p2",Entities.XD_PalisadeGate2)
	MakeVulnerable("rock_p2")
	MakeVulnerable("HQP2")
end
function TributePaid_GP3()
	ReplacingEntity("palisade_p3",Entities.XD_PalisadeGate2)
	MakeVulnerable("rock_p3")
	MakeVulnerable("HQP3")
end
function TributePaid_GP4()
	ReplacingEntity("palisade_p4",Entities.XD_PalisadeGate2)
	MakeVulnerable("rock_p4")
	MakeVulnerable("HQP4")
end
function TributeVillageP1()
local TrVP1 =  {}
TrVP1.pId = 1
TrVP1.text = "Zahlt 2000 Schwefel, um das Dorf Eurer neutralen Nachbarsiedlung zu kaufen"
TrVP1.cost = { Sulfur = 2000 }
TrVP1.Callback = TributePaid_VP1
TPVP1 = AddTribute(TrVP1)
end
function TributeVillageP2()
local TrVP2 =  {}
TrVP2.pId = 2
TrVP2.text = "Zahlt 2000 Schwefel, um das Dorf Eurer neutralen Nachbarsiedlung zu kaufen"
TrVP2.cost = { Sulfur = 2000 }
TrVP2.Callback = TributePaid_VP2
TPVP2 = AddTribute(TrVP2)
end
function TributeVillageP3()
local TrVP3 =  {}
TrVP3.pId = 3
TrVP3.text = "Zahlt 2000 Schwefel, um das Dorf Eurer neutralen Nachbarsiedlung zu kaufen"
TrVP3.cost = { Sulfur = 2000 }
TrVP3.Callback = TributePaid_VP3
TPVP3 = AddTribute(TrVP3)
end
function TributeVillageP4()
local TrVP4 =  {}
TrVP4.pId = 4
TrVP4.text = "Zahlt 2000 Schwefel, um das Dorf Eurer neutralen Nachbarsiedlung zu kaufen"
TrVP4.cost = { Sulfur = 2000 }
TrVP4.Callback = TributePaid_VP4
TPVP4 = AddTribute(TrVP4)
end
function TributePaid_VP1()
	local pID
	if CNetwork then
		pID = 9
	else
		pID = 7
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 50600, 6000)) do
		ChangePlayer(eID,1)
	end
	Logic.RemoveTribute(2,TPVP2)
	Logic.RemoveTribute(1,TPWP1)
	Logic.RemoveTribute(2,TPWP2)
end
function TributePaid_VP2()
	local pID
	if CNetwork then
		pID = 9
	else
		pID = 7
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 50600, 6000)) do
		ChangePlayer(eID,2)
	end
	Logic.RemoveTribute(1,TPVP1)
	Logic.RemoveTribute(1,TPWP1)
	Logic.RemoveTribute(2,TPWP2)
end
function TributePaid_VP3()
	local pID
	if CNetwork then
		pID = 9
	else
		pID = 7
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 10300, 6000)) do
		ChangePlayer(eID,3)
	end
	Logic.RemoveTribute(4,TPVP4)
	Logic.RemoveTribute(3,TPWP3)
	Logic.RemoveTribute(4,TPWP4)
end
function TributePaid_VP4()
	local pID
	if CNetwork then
		pID = 9
	else
		pID = 7
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 10300, 6000)) do
		ChangePlayer(eID,4)
	end
	Logic.RemoveTribute(3,TPVP3)
	Logic.RemoveTribute(3,TPWP3)
	Logic.RemoveTribute(4,TPWP4)
end
function TributeWarP1()
local TrWP1 =  {}
TrWP1.pId = 1
TrWP1.text = "Für eine Bearbeitungsgebühr von 100 Talern erklärt ihr Eurer neutralen Nachbarsiedlung den Krieg"
TrWP1.cost = { Gold = 100 }
TrWP1.Callback = TributePaid_WP1
TPWP1 = AddTribute(TrWP1)
end
function TributeWarP2()
local TrWP2 =  {}
TrWP2.pId = 2
TrWP2.text = "Für eine Bearbeitungsgebühr von 100 Talern erklärt ihr Eurer neutralen Nachbarsiedlung den Krieg"
TrWP2.cost = { Gold = 100 }
TrWP2.Callback = TributePaid_WP2
TPWP2 = AddTribute(TrWP2)
end
function TributeWarP3()
local TrWP3 =  {}
TrWP3.pId = 3
TrWP3.text = "Für eine Bearbeitungsgebühr von 100 Talern erklärt ihr Eurer neutralen Nachbarsiedlung den Krieg"
TrWP3.cost = { Gold = 100 }
TrWP3.Callback = TributePaid_WP3
TPWP3 = AddTribute(TrWP3)
end
function TributeWarP4()
local TrWP4 =  {}
TrWP4.pId = 4
TrWP4.text = "Für eine Bearbeitungsgebühr von 100 Talern erklärt ihr Eurer neutralen Nachbarsiedlung den Krieg"
TrWP4.cost = { Gold = 100 }
TrWP4.Callback = TributePaid_WP4
TPWP4 = AddTribute(TrWP4)
end
function TributePaid_WP1()
	local pID,enemypID
	local pos = GetPosition("P5_spawn_top")
	if CNetwork then
		pID = 9
		enemypID = 10
	else
		Logic.ChangeAllEntitiesPlayerID(3,4)
		AI.Village_DeactivateRebuildBehaviour(3)
		pID = 7
		enemypID = 3
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 50600, 6000)) do
		ChangePlayer(eID,enemypID)
	end
	for i = 1,6 do
		Logic.CreateEntity(Entities.PU_Serf,pos.X,pos.Y,0,enemypID)
	end
	MapEditor_SetupAI(enemypID,3,10000,2,"P5_spawn_top",3,0) SetupPlayerAi( enemypID, {constructing = true, extracting = 1, repairing = true, serfLimit = 6} )
	SetHostile(1,enemypID)
	SetHostile(2,enemypID)
	SetFriendly(3,enemypID)
	SetFriendly(4,enemypID)
	ActivateShareExploration(3,enemypID,true)
	ActivateShareExploration(4,enemypID,true)
	Logic.RemoveTribute(1,TPVP1)
	Logic.RemoveTribute(2,TPVP2)
	Logic.RemoveTribute(2,TPWP2)
end
function TributePaid_WP2()
	local pID,enemypID
	local pos = GetPosition("P5_spawn_top")
	if CNetwork then
		pID = 9
		enemypID = 10
	else
		Logic.ChangeAllEntitiesPlayerID(3,4)
		AI.Village_DeactivateRebuildBehaviour(3)
		pID = 7
		enemypID = 3
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 50600, 6000)) do
		ChangePlayer(eID,enemypID)
	end
	for i = 1,6 do
		Logic.CreateEntity(Entities.PU_Serf,pos.X,pos.Y,0,enemypID)
	end
	MapEditor_SetupAI(enemypID,3,10000,2,"P5_spawn_top",3,0) SetupPlayerAi( enemypID, {constructing = true, extracting = 1, repairing = true, serfLimit = 6} )
	SetHostile(1,enemypID)
	SetHostile(2,enemypID)
	SetFriendly(3,enemypID)
	SetFriendly(4,enemypID)
	ActivateShareExploration(3,enemypID,true)
	ActivateShareExploration(4,enemypID,true)
	Logic.RemoveTribute(1,TPVP1)
	Logic.RemoveTribute(2,TPVP2)
	Logic.RemoveTribute(1,TPWP1)
end
function TributePaid_WP3()
	local pID,enemypID
	local pos = GetPosition("P5_spawn_bottom")
	if CNetwork then
		pID = 9
		enemypID = 11
	else
		Logic.ChangeAllEntitiesPlayerID(2,1)
		AI.Village_DeactivateRebuildBehaviour(2)
		pID = 7
		enemypID = 2
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 10300, 6000)) do
		ChangePlayer(eID,enemypID)
	end
	for i = 1,6 do
		Logic.CreateEntity(Entities.PU_Serf,pos.X,pos.Y,0,enemypID)
	end
	MapEditor_SetupAI(enemypID,3,10000,2,"P5_spawn_bottom",3,0) SetupPlayerAi( enemypID, {constructing = true, extracting = 1, repairing = true, serfLimit = 6} )
	SetHostile(3,enemypID)
	SetHostile(4,enemypID)
	SetFriendly(1,enemypID)
	SetFriendly(2,enemypID)
	ActivateShareExploration(1,enemypID,true)
	ActivateShareExploration(2,enemypID,true)
	Logic.RemoveTribute(3,TPVP3)
	Logic.RemoveTribute(4,TPVP4)
	Logic.RemoveTribute(4,TPWP4)
end
function TributePaid_WP4()
	local pID,enemypID
	local pos = GetPosition("P5_spawn_bottom")
	if CNetwork then
		pID = 9
		enemypID = 11
	else
		Logic.ChangeAllEntitiesPlayerID(2,1)
		AI.Village_DeactivateRebuildBehaviour(2)
		pID = 7
		enemypID = 2
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(pID),CEntityIterator.InCircleFilter(28100, 10300, 6000)) do
		ChangePlayer(eID,enemypID)
	end
	for i = 1,6 do
		Logic.CreateEntity(Entities.PU_Serf,pos.X,pos.Y,0,enemypID)
	end
	MapEditor_SetupAI(enemypID,3,10000,2,"P5_spawn_bottom",3,0) SetupPlayerAi( enemypID, {constructing = true, extracting = 1, repairing = true, serfLimit = 6} )
	SetHostile(3,enemypID)
	SetHostile(4,enemypID)
	SetFriendly(1,enemypID)
	SetFriendly(2,enemypID)
	ActivateShareExploration(1,enemypID,true)
	ActivateShareExploration(2,enemypID,true)
	Logic.RemoveTribute(3,TPVP3)
	Logic.RemoveTribute(4,TPVP4)
	Logic.RemoveTribute(3,TPWP3)
end
function InitBanditTroops()
	ResearchTechnology(Technologies.T_Fletching,8)
	ResearchTechnology(Technologies.T_BodkinArrow,8)
	ResearchTechnology(Technologies.T_SoftArcherArmor,8)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,8)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,8)
	gvBandpos1 = {}
	gvBandpos2 = {}
	gvBandpos3 = {}
	gvBandpos4 = {}
	gvBandPatPo1 = {}
	gvBandPatPo2 = {}
	gvBandPatPo3 = {}
	gvBandPatPo4 = {}
	gvBandpos1.X,gvBandpos1.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn1"))
	gvBandpos2.X,gvBandpos2.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn2"))
	gvBandpos3.X,gvBandpos3.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn3"))
	gvBandpos4.X,gvBandpos4.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditSpawn4"))
	gvBandPatPo1.X,gvBandPatPo1.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditPatrolCenter1"))
	gvBandPatPo2.X,gvBandPatPo2.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditPatrolCenter2"))
	gvBandPatPo3.X,gvBandPatPo3.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditPatrolCenter3"))
	gvBandPatPo4.X,gvBandPatPo4.Y = Logic.GetEntityPosition(Logic.GetEntityIDByName("BanditPatrolCenter4"))

	troop1 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
	troop2 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
	troop3 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
	troop4 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
	troop5 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos3.X , gvBandpos3.Y ,0 )
	troop6 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos3.X , gvBandpos3.Y ,0 )
	troop7 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos4.X , gvBandpos4.Y ,0 )
	troop8 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos4.X , gvBandpos4.Y ,0 )
	troop9 = CreateGroup(8, Entities.PU_LeaderBow3, 8, gvBandpos3.X , gvBandpos3.Y ,0 )
	troop10 = CreateGroup(8, Entities.PU_LeaderBow3, 8, gvBandpos4.X , gvBandpos4.Y ,0 )
	Logic.GroupPatrol(troop1, gvBandPatPo1.X, gvBandPatPo1.Y)
	Logic.GroupPatrol(troop2, gvBandPatPo1.X, gvBandPatPo1.Y)
	Logic.GroupPatrol(troop3, gvBandPatPo2.X, gvBandPatPo2.Y)
	Logic.GroupPatrol(troop4, gvBandPatPo2.X, gvBandPatPo2.Y)
	Logic.GroupPatrol(troop5, gvBandPatPo3.X, gvBandPatPo3.Y)
	Logic.GroupPatrol(troop6, gvBandPatPo3.X, gvBandPatPo3.Y)
	Logic.GroupPatrol(troop7, gvBandPatPo4.X, gvBandPatPo4.Y)
	Logic.GroupPatrol(troop8, gvBandPatPo4.X, gvBandPatPo4.Y)
end
function BanditRespawn()
	if not IsExisting("BanditTower") then
		return true
	end
	if IsDestroyed(troop1) and IsDestroyed(troop2) then
		troop1 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
		troop2 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y ,0 )
		Logic.GroupPatrol(troop1, gvBandPatPo1.X, gvBandPatPo1.Y)
		Logic.GroupPatrol(troop2, gvBandPatPo1.X, gvBandPatPo1.Y)
	end
	if IsDestroyed(troop3) and IsDestroyed(troop4) then
		troop3 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
		troop4 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y ,0 )
		Logic.GroupPatrol(troop3, gvBandPatPo2.X, gvBandPatPo2.Y)
		Logic.GroupPatrol(troop4, gvBandPatPo2.X, gvBandPatPo2.Y)
	end
	if IsDestroyed(troop5) and IsDestroyed(troop6) then
		troop5 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos3.X , gvBandpos3.Y ,0 )
		troop6 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos3.X , gvBandpos3.Y ,0 )
		Logic.GroupPatrol(troop5, gvBandPatPo3.X, gvBandPatPo3.Y)
		Logic.GroupPatrol(troop6, gvBandPatPo3.X, gvBandPatPo3.Y)
	end
	if IsDestroyed(troop7) and IsDestroyed(troop8) then
		troop7 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos4.X , gvBandpos4.Y ,0 )
		troop8 = CreateGroup(8, Entities.CU_VeteranLieutenant, 3, gvBandpos4.X , gvBandpos4.Y ,0 )
		Logic.GroupPatrol(troop7, gvBandPatPo4.X, gvBandPatPo4.Y)
		Logic.GroupPatrol(troop8, gvBandPatPo4.X, gvBandPatPo4.Y)
	end
	if IsDestroyed(troop9) then
		troop9 = CreateGroup(8, Entities.PU_LeaderBow3, 8, gvBandpos3.X , gvBandpos3.Y ,0 )
	end
	if IsDestroyed(troop10) then
		troop10 = CreateGroup(8, Entities.PU_LeaderBow3, 8, gvBandpos4.X , gvBandpos4.Y ,0 )
	end
end

gvHeroesTable =		{
						[1] = Entities.PU_Hero1c,
						[2] = Entities.PU_Hero2,
						[3] = Entities.PU_Hero3,
						[4] = Entities.PU_Hero4,
						[5] = Entities.PU_Hero5,
						[6] = Entities.PU_Hero6,
						[7] = Entities.CU_Barbarian_Hero,
						[8] = Entities.CU_BlackKnight,
						[9] = Entities.CU_Mary_de_Morfichet,
						[10] = Entities.PU_Hero10,
						[11] = Entities.PU_Hero11,
						[12] = Entities.CU_Evil_Queen,
						[13] = Entities.PU_Hero13
					}
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
	if not IsExisting("BanditChestTower") then
		gvXmasChests.Bandit.Active = true;
	end
	local entities, pos, randomEvent, randomEventText, randomEventAmount;
	if  gvXmasChests.Top.Active and not  gvXmasChests.Top.Destroyed then
		pos = 	GetPosition("XmasChestTop")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 350+math.random(150)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.Top.Destroyed = true;
					gvXmasChests.Top.Active = false;
					ReplacingEntity("XmasChestTop", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.Bottom.Active and not  gvXmasChests.Bottom.Destroyed then
		pos = 	GetPosition("XmasChestBottom")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 350+math.random(150)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.Bottom.Destroyed = true;
					gvXmasChests.Bottom.Active = false;
					ReplacingEntity("XmasChestBottom", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.TopLeft.Active and not  gvXmasChests.TopLeft.Destroyed then
		pos = 	GetPosition("XmasChestTopLeft")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 500+math.random(250)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.TopLeft.Destroyed = true;
					gvXmasChests.TopLeft.Active = false;
					ReplacingEntity("XmasChestTopLeft", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.BottomLeft.Active and not  gvXmasChests.BottomLeft.Destroyed then
		pos = 	GetPosition("XmasChestBottomLeft")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 500+math.random(250)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.BottomLeft.Destroyed = true;
					gvXmasChests.BottomLeft.Active = false;
					ReplacingEntity("XmasChestBottomLeft", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.TopRight.Active and not  gvXmasChests.TopRight.Destroyed then
		pos = 	GetPosition("XmasChestTopRight")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 750+math.random(350)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.TopRight.Destroyed = true;
					gvXmasChests.TopRight.Active = false;
					ReplacingEntity("XmasChestTopRight", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.BottomRight.Active and not  gvXmasChests.BottomRight.Destroyed then
		pos = 	GetPosition("XmasChestBottomRight")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 400, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					randomEventAmount = 750+math.random(350)
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
					Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat eine Schatztruhe geplündert. Inhalt: " .. randomEventAmount.." Taler" );

					gvXmasChests.BottomRight.Destroyed = true;
					gvXmasChests.BottomRight.Active = false;
					ReplacingEntity("XmasChestBottomRight", Entities.XD_ChestOpen);
				end
			end
		end
	end
	if  gvXmasChests.Bandit.Active and not  gvXmasChests.Bandit.Destroyed then
		pos = 	GetPosition("XmasChestBandit")
		for j = 1, 4 do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, pos.X, pos.Y, 500, 1)};
			if entities[1] > 0 then
				randomEvent = gvXmasChestEvents[math.random(8)]
				if randomEvent == "SilverPot" then
					randomEventAmount = 300 + math.random(300)
					randomEventText = randomEventAmount .. "Silber"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Silver,randomEventAmount)
				elseif randomEvent == "HeroInTheBox" then
					local heroes = {}
					Logic.GetHeroes(j,heroes)
					for i = 1,table.getn(heroes) do
						removetablekeyvalue(gvHeroesTable,heroes[i])
					end
					randomEventAmount = gvHeroesTable[math.random(table.getn(gvHeroesTable))]
					local heroname = Logic.GetEntityTypeName(randomEventAmount)
					randomEventText = XGUIEng.GetStringTableText("names/"..heroname)
					Logic.CreateEntity(randomEventAmount,pos.X,pos.Y,j,0)
				elseif randomEvent == "SilverTechMiracle" then
					local tabpos = math.random(8)
					randomEventAmount = gvSilverTechTable[tabpos]
					randomEventText = XGUIEng.GetStringTableText("names/"..gvSilverTechStringTable[tabpos])
					Logic.SetTechnologyState(j,randomEventAmount,3)
				elseif randomEvent == "LuckyPayday" then
					randomEventAmount = Logic.GetPlayerPaydayCost(j)*(math.random(4))
					randomEventText = randomEventAmount .. "Taler"
					Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
				elseif randomEvent == "ThunderGodsBlessing" then
					randomEventAmount = 500+math.random(500)
					randomEventText = randomEventAmount .. "Sekunden Immunität gegenüber Blitzeinschlägen"
					gvLightning.RodProtected[j] = true
					Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","LightningRod_UnProtected",1,{},{j,randomEventAmount})
				elseif randomEvent == "SlipperyThief" then
					randomEventAmount = Technologies.T_Chest_ThiefBuff
					randomEventText = "Noch schnellere Diebe"
					Logic.SetTechnologyState(j, randomEventAmount, 3)
				elseif randomEvent == "DivineProvidence" then
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
					randomEventAmount = 40 + math.random(80)
					randomEventText = "Sichtbarkeit der gesamten Map für".. randomEventAmount .." Sekunden"
					exploreID1 = Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X,pos.Y,j,0)
					exploreID2 = Logic.CreateEntity(Entities.XD_ScriptEntity,pos.X-100,pos.Y-100,ally,0)
					Logic.SetEntityExplorationRange(exploreID1,10000)
					Logic.SetEntityExplorationRange(exploreID2,10000)
					StartCountdown(randomEventAmount,function() DestroyEntity(exploreID1);	DestroyEntity(exploreID2) end,false)
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
					randomEventText = "Der Verbündete erhält" .. randomEventAmount .. "Taler"
					Logic.AddToPlayersGlobalResource(ally,ResourceType.GoldRaw,randomEventAmount)
				end

				Message("@color:0,255,255 " .. UserTool_GetPlayerName(j) ..  " hat die Schatztruhe der Barbaren geplündert. Inhalt: " .. randomEventText );

				gvXmasChests.Bandit.Destroyed = true;
				ReplacingEntity("XmasChestBandit", Entities.XD_ChestOrb);
			end
		end
	end
	if gvXmasChests.Bandit.Destroyed and gvXmasChests.Top.Destroyed and gvXmasChests.TopLeft.Destroyed and gvXmasChests.TopRight.Destroyed and gvXmasChests.Bottom.Destroyed and gvXmasChests.BottomRight.Destroyed and gvXmasChests.BottomLeft.Destroyed then
		return true
	end
end

gvXmasChests =		   {Bandit 		= {	Active = false,
										Destroyed = false,
										ID = 0},
						Top 		= {	Active = true,
										Destroyed = false,
										ID = 0},
						TopLeft		= {	Active = true,
										Destroyed = false,
										ID = 0},
						TopRight 	= {	Active = true,
										Destroyed = false,
										ID = 0},
						Bottom 		=  {Active = true,
										Destroyed = false,
										ID = 0},
						BottomLeft 	= {	Active = true,
										Destroyed = false,
										ID = 0},
						BottomRight = {	Active = true,
										Destroyed = false,
										ID = 0}
						}
gvXmasChestEvents = {
						-- zufällige Menge Silber
						[1] = "SilverPot",
						-- ein zufälliger zusätzlicher Held
						[2] = "HeroInTheBox",
						-- zufällige Tech aus der Silberschmelze
						[3] = "SilverTechMiracle",
						-- Taler abhängig vom Zahltag
						[4] = "LuckyPayday",
						-- einige Minuten immun gegen Blitzeinschläge
						[5] = "ThunderGodsBlessing",
						-- spezielle Tech für Diebe, erhöhtes Lauftempo
						[6] = "SlipperyThief",
						-- ganze Karte wird kurzzeitig fürs Team aufgedeckt
						[7] = "DivineProvidence",
						-- Verbündeter erhält zufällige Ressourcen abhängig der eigenen Höhe
						[8] = "LovingBuddies"
					}
  