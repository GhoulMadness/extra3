initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not CNetwork then
	math.randomseed(XGUIEng.GetSystemTime())
end
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

	Version = 1.03,

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
	IncludeGlobals("Tools\\recalculate_bridge_height")

	-- custom Map Stuff
	AddPeriodicSummer(10)

	MultiplayerTools.InitCameraPositionsForPlayers()

	--[[for i = 1,16 do
		CreateWoodPile("Holz"..i,10000000)
	end]]

	LocalMusic.UseSet = HIGHLANDMUSIC
	for i = 1, 4 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
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
			ForbidTechnology(Technologies.B_Bridge,i)
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
		InitBanditTroops()
		-- register bandits and evil stuff in statistics
		Logic.SetPlayerRawName(7, "???")
		Logic.PlayerSetIsHumanFlag(7, 1)
		Logic.PlayerSetPlayerColor(7, GUI.GetPlayerColor(7))
		--
		InitEggs()
		StartSimpleJob("CheckSheepGates")
	end,

	Callback_OnPeacetimeEnded = function()
		InitTributes()
		for i = 1,4 do
			AllowTechnology(Technologies.B_Bridge,i)
			AllowTechnology(Technologies.T_MakeSnow,i)
		end
		StartSimpleJob("ControlRabbits")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSilvermineEmpty", 1)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSpecialRabbitDied", 1)
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
function InitMerchants()
	for i = 1,4 do
		_G["mercenaryId"..i] = Logic.GetEntityIDByName("merc"..i)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_Thief, 2, ResourceType.Gold, 500)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)
	end
end
function InitTributes()
	TributeGateT1_P1_1()
	TributeGateT1_P1_2()
	TributeGateT1_P2_1()
	TributeGateT1_P2_2()
	TributeGateT2_P3_1()
	TributeGateT2_P3_2()
	TributeGateT2_P4_1()
	TributeGateT2_P4_2()
end
--
function TributeGateT1_P1_1()
	local TrGT1_P1_1 =  {}
	TrGT1_P1_1.pId = 1
	TrGT1_P1_1.text = "Zahlt 500 Taler, um die Tore der großen Mauer zu öffnen!"
	TrGT1_P1_1.cost = { Gold = 500 }
	TrGT1_P1_1.Callback = TributePaid_GT1_P1_1
	TGT1_P1_1 = AddTribute(TrGT1_P1_1)
end
function TributeGateT1_P1_2()
	local TrGT1_P1_2 =  {}
	TrGT1_P1_2.pId = 1
	TrGT1_P1_2.text = "Zahlt 5000 Taler, um die Tore der großen Mauer zu öffnen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrGT1_P1_2.cost = { Gold = 5000 }
	TrGT1_P1_2.Callback = TributePaid_GT1_P1_2
	TGT1_P1_2 = AddTribute(TrGT1_P1_2)
end
function TributeGateT1_P2_1()
	local TrGT1_P2_1 =  {}
	TrGT1_P2_1.pId = 2
	TrGT1_P2_1.text = "Zahlt 500 Taler, um die Tore der großen Mauer zu öffnen!"
	TrGT1_P2_1.cost = { Gold = 500 }
	TrGT1_P2_1.Callback = TributePaid_GT1_P2_1
	TGT1_P2_1 = AddTribute(TrGT1_P2_1)
end
function TributeGateT1_P2_2()
	local TrGT1_P2_2 =  {}
	TrGT1_P2_2.pId = 2
	TrGT1_P2_2.text = "Zahlt 5000 Taler, um die Tore der großen Mauer zu öffnen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrGT1_P2_2.cost = { Gold = 5000 }
	TrGT1_P2_2.Callback = TributePaid_GT1_P2_2
	TGT1_P2_2 = AddTribute(TrGT1_P2_2)
end
--
function TributeGateT2_P3_1()
	local TrGT2_P3_1 =  {}
	TrGT2_P3_1.pId = 3
	TrGT2_P3_1.text = "Zahlt 500 Taler, um die Tore der großen Mauer zu öffnen!"
	TrGT2_P3_1.cost = { Gold = 500 }
	TrGT2_P3_1.Callback = TributePaid_GT2_P3_1
	TGT2_P3_1 = AddTribute(TrGT2_P3_1)
end
function TributeGateT2_P3_2()
	local TrGT2_P3_2 =  {}
	TrGT2_P3_2.pId = 3
	TrGT2_P3_2.text = "Zahlt 5000 Taler, um die Tore der großen Mauer zu öffnen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrGT2_P3_2.cost = { Gold = 5000 }
	TrGT2_P3_2.Callback = TributePaid_GT2_P3_2
	TGT2_P3_2 = AddTribute(TrGT2_P3_2)
end
function TributeGateT2_P4_1()
	local TrGT2_P4_1 =  {}
	TrGT2_P4_1.pId = 4
	TrGT2_P4_1.text = "Zahlt 500 Taler, um die Tore der großen Mauer zu öffnen!"
	TrGT2_P4_1.cost = { Gold = 500 }
	TrGT2_P4_1.Callback = TributePaid_GT2_P4_1
	TGT2_P4_1 = AddTribute(TrGT2_P4_1)
end
function TributeGateT2_P4_2()
	local TrGT2_P4_2 =  {}
	TrGT2_P4_2.pId = 4
	TrGT2_P4_2.text = "Zahlt 5000 Taler, um die Tore der großen Mauer zu öffnen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrGT2_P4_2.cost = { Gold = 5000 }
	TrGT2_P4_2.Callback = TributePaid_GT2_P4_2
	TGT2_P4_2 = AddTribute(TrGT2_P4_2)
end
--
function TributeCloseGateT1_P1_1()
	local TrCGT1_P1_1 =  {}
	TrCGT1_P1_1.pId = 1
	TrCGT1_P1_1.text = "Zahlt 1000 Taler, um die Tore der großen Mauer zu schließen!"
	TrCGT1_P1_1.cost = { Gold = 1000 }
	TrCGT1_P1_1.Callback = TributePaid_CGT1_P1_1
	TCGT1_P1_1 = AddTribute(TrCGT1_P1_1)
end
function TributeCloseGateT1_P1_2()
	local TrCGT1_P1_2 =  {}
	TrCGT1_P1_2.pId = 1
	TrCGT1_P1_2.text = "Zahlt 7500 Taler, um die Tore der großen Mauer zu schließen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrCGT1_P1_2.cost = { Gold = 7500 }
	TrCGT1_P1_2.Callback = TributePaid_CGT1_P1_2
	TCGT1_P1_2 = AddTribute(TrCGT1_P1_2)
end
function TributeCloseGateT1_P2_1()
	local TrCGT1_P2_1 =  {}
	TrCGT1_P2_1.pId = 2
	TrCGT1_P2_1.text = "Zahlt 1000 Taler, um die Tore der großen Mauer zu schließen!"
	TrCGT1_P2_1.cost = { Gold = 1000 }
	TrCGT1_P2_1.Callback = TributePaid_CGT1_P2_1
	TCGT1_P2_1 = AddTribute(TrCGT1_P2_1)
end
function TributeCloseGateT1_P2_2()
	local TrCGT1_P2_2 =  {}
	TrCGT1_P2_2.pId = 2
	TrCGT1_P2_2.text = "Zahlt 7500 Taler, um die Tore der großen Mauer zu schließen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrCGT1_P2_2.cost = { Gold = 7500 }
	TrCGT1_P2_2.Callback = TributePaid_CGT1_P2_2
	TCGT1_P2_2 = AddTribute(TrCGT1_P2_2)
end
--
function TributeCloseGateT2_P3_1()
	local TrCGT2_P3_1 =  {}
	TrCGT2_P3_1.pId = 3
	TrCGT2_P3_1.text = "Zahlt 1000 Taler, um die Tore der großen Mauer zu schließen!"
	TrCGT2_P3_1.cost = { Gold = 1000 }
	TrCGT2_P3_1.Callback = TributePaid_CGT2_P3_1
	TCGT2_P3_1 = AddTribute(TrCGT2_P3_1)
end
function TributeCloseGateT2_P3_2()
	local TrCGT2_P3_2 =  {}
	TrCGT2_P3_2.pId = 3
	TrCGT2_P3_2.text = "Zahlt 7500 Taler, um die Tore der großen Mauer zu schließen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrCGT2_P3_2.cost = { Gold = 7500 }
	TrCGT2_P3_2.Callback = TributePaid_CGT2_P3_2
	TCGT2_P3_2 = AddTribute(TrCGT2_P3_2)
end
function TributeCloseGateT2_P4_1()
	local TrCGT2_P4_1 =  {}
	TrCGT2_P4_1.pId = 4
	TrCGT2_P4_1.text = "Zahlt 1000 Taler, um die Tore der großen Mauer zu schließen!"
	TrCGT2_P4_1.cost = { Gold = 1000 }
	TrCGT2_P4_1.Callback = TributePaid_CGT2_P4_1
	TCGT2_P4_1 = AddTribute(TrCGT2_P4_1)
end
function TributeCloseGateT2_P4_2()
	local TrCGT2_P4_2 =  {}
	TrCGT2_P4_2.pId = 4
	TrCGT2_P4_2.text = "Zahlt 7500 Taler, um die Tore der großen Mauer zu schließen! Der Torwächter ist Euch so dankbar, dass er früher weitere Geschäfte mit Euch abschließen wird!"
	TrCGT2_P4_2.cost = { Gold = 7500 }
	TrCGT2_P4_2.Callback = TributePaid_CGT2_P4_2
	TCGT2_P4_2 = AddTribute(TrCGT2_P4_2)
end
--
-- minutes needed when cheap tribute is payed
gvTimeNeededLowMoney = 8*60
-- minutes needed when expensive tribute is payed
gvTimeNeededHighMoney = 1*60
--
-- open gate tribute paid callbacks
function TributePaid_GT1_P1_1()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(1,TGT1_P1_2)
	Logic.RemoveTribute(2,TGT1_P2_1)
	Logic.RemoveTribute(2,TGT1_P2_2)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P1_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P1_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P2_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P2_2,false)
end
function TributePaid_GT1_P1_2()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(1,TGT1_P1_1)
	Logic.RemoveTribute(2,TGT1_P2_1)
	Logic.RemoveTribute(2,TGT1_P2_2)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P1_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P1_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P2_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P2_2,false)
end
function TributePaid_GT1_P2_1()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(1,TGT1_P1_1)
	Logic.RemoveTribute(2,TGT1_P1_2)
	Logic.RemoveTribute(2,TGT1_P2_2)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P1_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P1_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P2_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT1_P2_2,false)
end
function TributePaid_GT1_P2_2()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(1,TGT1_P1_1)
	Logic.RemoveTribute(2,TGT1_P1_2)
	Logic.RemoveTribute(2,TGT1_P2_1)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P1_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P1_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P2_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT1_P2_2,false)
end
--
function TributePaid_GT2_P3_1()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(3,TGT2_P3_2)
	Logic.RemoveTribute(4,TGT2_P4_1)
	Logic.RemoveTribute(4,TGT2_P4_2)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P3_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P3_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P4_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P4_2,false)
end
function TributePaid_GT2_P3_2()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(3,TGT2_P3_1)
	Logic.RemoveTribute(4,TGT2_P4_1)
	Logic.RemoveTribute(4,TGT2_P4_2)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P3_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P3_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P4_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P4_2,false)
end
function TributePaid_GT2_P4_1()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(3,TGT2_P3_1)
	Logic.RemoveTribute(3,TGT2_P3_2)
	Logic.RemoveTribute(4,TGT2_P4_2)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P3_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P3_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P4_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeCloseGateT2_P4_2,false)
end
function TributePaid_GT2_P4_2()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate)
	Logic.RemoveTribute(3,TGT2_P3_1)
	Logic.RemoveTribute(3,TGT2_P3_2)
	Logic.RemoveTribute(4,TGT2_P4_1)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P3_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P3_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P4_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeCloseGateT2_P4_2,false)
end
--
-- close gate tribute paid callbacks
function TributePaid_CGT1_P1_1()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(1,TCGT1_P1_2)
	Logic.RemoveTribute(2,TCGT1_P2_1)
	Logic.RemoveTribute(2,TCGT1_P2_2)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P1_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P1_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P2_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P2_2,false)
end
function TributePaid_CGT1_P1_2()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(1,TCGT1_P1_1)
	Logic.RemoveTribute(2,TCGT1_P2_1)
	Logic.RemoveTribute(2,TCGT1_P2_2)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P1_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P1_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P2_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P2_2,false)
end
function TributePaid_CGT1_P2_1()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(1,TCGT1_P1_1)
	Logic.RemoveTribute(2,TCGT1_P1_2)
	Logic.RemoveTribute(2,TCGT1_P2_2)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P1_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P1_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P2_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT1_P2_2,false)
end
function TributePaid_CGT1_P2_2()
	ReplaceEntity("gate_t1_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t1_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(1,TCGT1_P1_1)
	Logic.RemoveTribute(2,TCGT1_P1_2)
	Logic.RemoveTribute(2,TCGT1_P2_1)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P1_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P1_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P2_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT1_P2_2,false)
end
--
function TributePaid_CGT2_P3_1()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(3,TCGT2_P3_2)
	Logic.RemoveTribute(4,TCGT2_P4_1)
	Logic.RemoveTribute(4,TCGT2_P4_2)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P3_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P3_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P4_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P4_2,false)
end
function TributePaid_CGT2_P3_2()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(3,TCGT2_P3_1)
	Logic.RemoveTribute(4,TCGT2_P4_1)
	Logic.RemoveTribute(4,TCGT2_P4_2)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P3_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P3_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P4_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P4_2,false)
end
function TributePaid_CGT2_P4_1()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(3,TCGT2_P3_1)
	Logic.RemoveTribute(3,TCGT2_P3_2)
	Logic.RemoveTribute(4,TCGT2_P4_2)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P3_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P3_2,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P4_1,false)
	StartCountdown(gvTimeNeededLowMoney,TributeGateT2_P4_2,false)
end
function TributePaid_CGT2_P4_2()
	ReplaceEntity("gate_t2_1",Entities.XD_WallStraightGate_Closed)
	ReplaceEntity("gate_t2_2",Entities.XD_WallStraightGate_Closed)
	Logic.RemoveTribute(3,TCGT2_P3_1)
	Logic.RemoveTribute(3,TCGT2_P3_2)
	Logic.RemoveTribute(4,TCGT2_P4_1)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P3_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P3_2,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P4_1,false)
	StartCountdown(gvTimeNeededHighMoney,TributeGateT2_P4_2,false)
end
function InitBanditTroops()
	for i = 1,4 do
		SetHostile(i,7)
	end
	Display.SetPlayerColorMapping(7,ROBBERS_COLOR)
	ResearchTechnology(Technologies.T_Fletching,7)
	ResearchTechnology(Technologies.T_BodkinArrow,7)
	ResearchTechnology(Technologies.T_SoftArcherArmor,7)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,7)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,7)
	gvBandpos1 = {X = 32000, Y = 62700}
	gvBandpos2 = {X = 32000, Y = 1300}

	Logic.SetEntityName(Logic.CreateEntity(Entities.CB_Bastille1, gvBandpos1.X, gvBandpos1.Y, 0, 7),"BanditTowerTop")
	Logic.SetEntityName(Logic.CreateEntity(Entities.CB_Bastille1, gvBandpos2.X, gvBandpos2.Y, 180, 7),"BanditTowerBottom")

	troop1 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y - 700 ,0 )
	troop2 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y + 700 ,0 )
	troop3 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos1.X , gvBandpos1.Y - 550,0 )
	troop4 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos2.X , gvBandpos2.Y + 550,0 )
	troop5 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos1.X , gvBandpos1.Y - 850,0 )
	troop6 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos2.X , gvBandpos2.Y + 850,0 )
	Logic.GroupStand(troop3)
	Logic.GroupStand(troop4)
	--
	StartSimpleJob("BanditControl")
end
function BanditControl()
	if not IsExisting("BanditTowerTop") and not IsExisting("BanditTowerBottom") then
		if not IsExisting(troop1) and not IsExisting(troop2) and not IsExisting(troop3) and not IsExisting(troop4) and not IsExisting(troop5) and not IsExisting(troop6) then
			return true
		end
	end
	if IsExisting("BanditTowerTop") then
		if IsDestroyed(troop1) then
			if Counter.Tick2("BanditRespawn"..troop1,40) then
				troop1 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y - 700 ,0 )
			end

		end
		if IsDestroyed(troop3) then
			if Counter.Tick2("BanditRespawn"..troop3,20) then
				troop3 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos1.X , gvBandpos1.Y - 550,0 )
				Logic.GroupStand(troop3)
			end

		end
		if IsDestroyed(troop5) then
			if Counter.Tick2("BanditRespawn"..troop5,15) then
				troop5 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos1.X , gvBandpos1.Y - 850,0 )
			end

		end
	else
		if not gvBanditTopKilled and not IsExisting(troop1) and not IsExisting(troop3) and not IsExisting(troop5) then
			BanditBaseDestroyed(1)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "LastTowerJob", 1, nil, {"BanditTowerBottom"})
		end
	end
	if IsExisting("BanditTowerBottom") then
		if IsDestroyed(troop2) then
			if Counter.Tick2("BanditRespawn"..troop2,40) then
				troop2 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y + 700 ,0 )
			end

		end
		if IsDestroyed(troop4) then
			if Counter.Tick2("BanditRespawn"..troop4,20) then
				troop4 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos2.X , gvBandpos2.Y + 550,0 )
				Logic.GroupStand(troop4)
			end

		end
		if IsDestroyed(troop6) then
			if Counter.Tick2("BanditRespawn"..troop6,15) then
				troop6 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos2.X , gvBandpos2.Y + 850,0 )
			end

		end
	else
		if not gvBanditBottomKilled and not IsExisting(troop2) and not IsExisting(troop4) and not IsExisting(troop6) then
			BanditBaseDestroyed(2)
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "LastTowerJob", 1, nil, {"BanditTowerTop"})
		end
	end
end
gvBanditBaseReward = 2500
function BanditBaseDestroyed(_tID)
	local gvBanditReward = math.floor(math.min(gvBanditBaseReward + ((Logic.GetTime()/2)^(1+Logic.GetTime()/10000)),30000))
	Sound.PlayGUISound( Sounds.OnKlick_Select_pilgrim, 112 )
	if _tID == 1 then
		gvBanditTopKilled = true
		Message(UserTool_GetPlayerName(1).." & "..UserTool_GetPlayerName(2).." haben Schätze der Barbaren geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
		AddGold(1,gvBanditReward)
		AddWood(1,gvBanditReward)
		AddGold(2,gvBanditReward)
		AddWood(2,gvBanditReward)
	elseif _tID == 2 then
		gvBanditBottomKilled = true
		Message(UserTool_GetPlayerName(3).." & "..UserTool_GetPlayerName(4).." haben Schätze der Barbaren geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
		AddGold(3,gvBanditReward)
		AddWood(3,gvBanditReward)
		AddGold(4,gvBanditReward)
		AddWood(4,gvBanditReward)
	end
end
function LastTowerJob(_towerName)

	if IsDestroyed(_towerName) then

		if LastTowerCheckForCircumstances() then

			if _towerName == "BanditTowerTop" then

				if not IsExisting(troop1) and not IsExisting(troop3) and not IsExisting(troop5) then

					LastTowerInitStatue(gvBandpos1,{1,2})
					return true
				end

			elseif _towerName == "BanditTowerBottom" then

				if not IsExisting(troop2) and not IsExisting(troop4) and not IsExisting(troop6) then

					LastTowerInitStatue(gvBandpos2,{3,4})
					return true
				end

			else

				LuaDebugger.Log("Invalid Input for <<LastTowerJob>> at line 591")
			end

		else
			return true
		end

	end
end
function LastTowerCheckForCircumstances()

	local GameTime = Logic.GetTime() - (gvDayCycleStartTime or 0)
	local secondsperday = gvDayTimeSeconds or 1440
	local daytimefactor = secondsperday/86400
	local TimeMinutes = math.floor(GameTime/(3600*daytimefactor))
	local currenthour = 8+(TimeMinutes/60)
	while currenthour > 12 do
		currenthour = currenthour - 12
	end
	return (GetCurrentWeatherGfxSet() == 11 or GetCurrentWeatherGfxSet() == 28) and (currenthour >= 3 and currenthour <= 3.5)
end
function LastTowerInitStatue(_posTable,_playerTable)

	local eID = Logic.CreateEntity(Entities.PB_VictoryStatue2, _posTable.X, _posTable.Y, 0, 8)
	MakeInvulnerable(eID)
	InitBeastStatueTributes(_playerTable)
	Message(UserTool_GetPlayerName(_playerTable[1]).." & "..UserTool_GetPlayerName(_playerTable[2]).." haben die Bestienstatue erweckt!")

end
function InitBeastStatueTributes(_playerTable)
	local TrBS_T1_1 =  {}
	TrBS_T1_1.pId = _playerTable[1]
	TrBS_T1_1.text = "Opfert der Bestienstatue 20.000 Holz!"
	TrBS_T1_1.cost = { Wood = 20000 }
	TrBS_T1_1.Callback = TributePaid_TrBS_T1_1
	TrB_T1_1 = AddTribute(TrBS_T1_1)
	local TrBS_T1_2 =  {}
	TrBS_T1_2.pId = _playerTable[2]
	TrBS_T1_2.text = "Opfert der Bestienstatue 20.000 Holz!"
	TrBS_T1_2.cost = { Wood = 20000 }
	TrBS_T1_2.Callback = TributePaid_TrBS_T1_2
	TrB_T1_2 = AddTribute(TrBS_T1_2)
	------------------------------------------------
	local TrBS_T2_1 =  {}
	TrBS_T2_1.pId = _playerTable[1]
	TrBS_T2_1.text = "Opfert der Bestienstatue 5 Schafe. Die Schafe müssen sich in der Nähe der Statue befinden!"
	TrBS_T2_1.cost = { Gold = 0 }
	TrBS_T2_1.Callback = TributePaid_TrBS_T2_1
	TrB_T2_1 = AddTribute(TrBS_T2_1)
	local TrBS_T2_2 =  {}
	TrBS_T2_2.pId = _playerTable[2]
	TrBS_T2_2.text = "Opfert der Bestienstatue 5 Schafe. Die Schafe müssen sich in der Nähe der Statue befinden!"
	TrBS_T2_2.cost = { Gold = 0 }
	TrBS_T2_2.Callback = TributePaid_TrBS_T2_2
	TrB_T2_2 = AddTribute(TrBS_T2_2)
	------------------------------------------------
	local TrBS_T3_1 =  {}
	TrBS_T3_1.pId = _playerTable[1]
	TrBS_T3_1.text = "Opfert der Bestienstatue einen Eurer Helden. Der Held muss sich in der Nähe der Statue befinden und am Leben sein!"
	TrBS_T3_1.cost = { Gold = 0 }
	TrBS_T3_1.Callback = TributePaid_TrBS_T3_1
	TrB_T3_1 = AddTribute(TrBS_T3_1)
	local TrBS_T3_2 =  {}
	TrBS_T3_2.pId = _playerTable[2]
	TrBS_T3_2.text = "Opfert der Bestienstatue einen Eurer Helden. Der Held muss sich in der Nähe der Statue befinden und am Leben sein!"
	TrBS_T3_2.cost = { Gold = 0 }
	TrBS_T3_2.Callback = TributePaid_TrBS_T3_2
	TrB_T3_2 = AddTribute(TrBS_T3_2)
end
function TributePaid_TrBS_T1_1(_tribute)
	local amount = math.floor(math.min(math.random(300,500) + ((Logic.GetTime()/10)^(1+Logic.GetTime()/10000)), 1000))
	Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 20.000 Holz geopfert. @cr Belohnung: "..amount.." Silber!")
	Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
end
function TributePaid_TrBS_T1_2(_tribute)
	local amount = math.floor(math.min(math.random(300,500) + ((Logic.GetTime()/10)^(1+Logic.GetTime()/10000)), 1000))
	Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 20.000 Holz geopfert. @cr Belohnung: "..amount.." Silber!")
	Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
end
function TributePaid_TrBS_T2_1(_tribute)
	if BeastStatueTributes_CheckForSheeps(_tribute.pId) then
		local amount = math.floor(math.min(math.random(600,1000) + ((Logic.GetTime()/5)^(1+Logic.GetTime()/10000)), 3000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 5 Schafe geopfert. @cr Belohnung: "..amount.." Silber und "..amount*10 .." aller anderen Ressourcen!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Gold, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Clay, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Stone, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount*10)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Nicht genug Schafe in der Nähe der Bestienstatue!")
		end
		local TrBS_T2_1 =  {}
		TrBS_T2_1.pId = _tribute.pId
		TrBS_T2_1.text = _tribute.text
		TrBS_T2_1.cost = _tribute.cost
		TrBS_T2_1.Callback = TributePaid_TrBS_T2_1
		TrB_T2_1 = AddTribute(TrBS_T2_1)
	end
end
function TributePaid_TrBS_T2_2(_tribute)
	if BeastStatueTributes_CheckForSheeps(_tribute.pId) then
		local amount = math.floor(math.min(math.random(600,1000) + ((Logic.GetTime()/5)^(1+Logic.GetTime()/10000)), 3000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue 5 Schafe geopfert. @cr Belohnung: "..amount.." Silber und "..amount*10 .." aller anderen Ressourcen!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Silver, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Gold, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Clay, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Stone, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount*10)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount*10)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Nicht genug Schafe in der Nähe der Bestienstatue!")
		end
		local TrBS_T2_2 =  {}
		TrBS_T2_2.pId = _tribute.pId
		TrBS_T2_2.text = _tribute.text
		TrBS_T2_2.cost = _tribute.cost
		TrBS_T2_2.Callback = TributePaid_TrBS_T2_2
		TrB_T2_2 = AddTribute(TrBS_T2_2)
	end
end
function TributePaid_TrBS_T3_1(_tribute)
	local bool, name = BeastStatueTributes_CheckForHero(_tribute.pId)
	local heroname
	if bool then
		heroname = XGUIEng.GetStringTableText("names/"..Logic.GetEntityTypeName(name))
		local amount = math.floor(math.min(math.random(15000,20000) + ((Logic.GetTime()/3)^(1+Logic.GetTime()/8000)), 50000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue "..heroname.." geopfert. @cr Belohnung: "..amount.." Holz und Eisen und "..amount/2 .." Schwefel!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount/2)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Es befindet sich kein Held in der Nähe der Bestienstatue!")
		end
		local TrBS_T3_1 =  {}
		TrBS_T3_1.pId = _tribute.pId
		TrBS_T3_1.text = _tribute.text
		TrBS_T3_1.cost = _tribute.cost
		TrBS_T3_1.Callback = TributePaid_TrBS_T3_1
		TrB_T3_1 = AddTribute(TrBS_T3_1)
	end
end
function TributePaid_TrBS_T3_2(_tribute)
	local bool, name = BeastStatueTributes_CheckForHero(_tribute.pId)
	local heroname
	if bool then
		heroname = XGUIEng.GetStringTableText("names/"..Logic.GetEntityTypeName(name))
		local amount = math.floor(math.min(math.random(15000,20000) + ((Logic.GetTime()/3)^(1+Logic.GetTime()/8000)), 50000))
		Message(UserTool_GetPlayerName(_tribute.pId).." hat der Bestienstatue "..heroname.." geopfert. @cr Belohnung: "..amount.." Holz und Eisen und "..amount/2 .." Schwefel!")
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Wood, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Iron, amount)
		Logic.AddToPlayersGlobalResource(_tribute.pId, ResourceType.Sulfur, amount/2)
	else
		if GUI.GetPlayerID() == _tribute.pId then
			Message("Es befindet sich kein Held in der Nähe der Bestienstatue!")
		end
		local TrBS_T3_2 =  {}
		TrBS_T3_2.pId = _tribute.pId
		TrBS_T3_2.text = _tribute.text
		TrBS_T3_2.cost = _tribute.cost
		TrBS_T3_2.Callback = TributePaid_TrBS_T3_2
		TrB_T3_2 = AddTribute(TrBS_T3_2)
	end
end
function BeastStatueTributes_CheckForSheeps(_playerID)
	local pos
	local entities = {}
	if _playerID <= 2 then
		pos = gvBandpos1
	elseif _playerID >= 3 and _playerID <= 4 then
		pos = gvBandpos2
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.XA_Sheep1,Entities.XA_Sheep2,Entities.XA_Sheep3),CEntityIterator.InCircleFilter(pos.X, pos.Y, 1000)) do
		table.insert(entities, eID)
	end
	if table.getn(entities) >= 5 then
		for i = 1,5,1 do
			local sheeppos = GetPosition(entities[i])
			Logic.CreateEffect(GGL_Effects.FXKalaPoison,sheeppos.X,sheeppos.Y)
			Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,sheeppos.X,sheeppos.Y)
			DestroyEntity(entities[i])
		end
		return true
	else
		return false
	end
end
function BeastStatueTributes_CheckForHero(_playerID)
	local pos
	local entities = {}
	if _playerID <= 2 then
		pos = gvBandpos1
	elseif _playerID >= 3 and _playerID <= 4 then
		pos = gvBandpos2
	end
	for eID in CEntityIterator.Iterator(CEntityIterator.OfCategoryFilter(EntityCategories.Hero),CEntityIterator.OfPlayerFilter(_playerID),CEntityIterator.InCircleFilter(pos.X, pos.Y, 600)) do
		if GetEntityHealth(eID) > 0 then
			table.insert(entities, eID)
		end
	end
	if entities[1] ~= nil then
		local heropos = GetPosition(entities[1])
		local herotype = Logic.GetEntityType(entities[1])
		Logic.CreateEffect(GGL_Effects.FXKalaPoison,heropos.X,heropos.Y)
		Logic.CreateEffect(GGL_Effects.FXDieHero,heropos.X,heropos.Y,_playerID)
		Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,heropos.X,heropos.Y)
		DestroyEntity(entities[1])
		return true, herotype
	else
		return false
	end
end
------------------------------------------------------------------------------------
function InitEggs()
	-- this should be a nice number; below divided by 2 since there are 2 teams
	local totaleggs = 60
	local count_t1,count_t2 = 0,0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec1 = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,32000,51000,0,8))
	local sec2 = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,32000,13000,0,8))
	local tempid
	local tempsec
	while (count_t1+count_t2) < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		tempid = Logic.CreateEntity(Entities.XD_Flower1,posX,posY,0,0)
		tempsec = Logic.GetSector(tempid)
		if tempsec == sec1 then
			if count_t1 < (totaleggs/2) then
				count_t1 = count_t1 + 1
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T1_"..count_t1)
			end
		elseif tempsec == sec2 then
			if count_t2 < (totaleggs/2) then
				count_t2 = count_t2 + 1
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T2_"..count_t2)
			end
		end
		Logic.DestroyEntity(tempid)
	end
	EasterEggposTable = {[1] = {},
						[2] = {}}
	for i = 1,2 do
		for k = 1,(Logic.GetNumberOfEntitiesOfType(Entities.XD_EasterEgg1))/2 do
			EasterEggposTable[i][k] = GetPosition("EasterEgg_T"..i.."_"..k)
		end
	end
	StartSimpleJob("ControlEggs")
end

function ControlEggs()

	for j = 1, 4 do
		for i = 1,2 do
			for k,_ in pairs(EasterEggposTable[i]) do
				entities = {Logic.GetPlayerEntitiesInArea(j, 0, EasterEggposTable[i][k].X, EasterEggposTable[i][k].Y, 300, 1)};
				if entities[1] > 0 then
					if Logic.IsHero(entities[2]) == 1 then
						local randomEventAmount = 45+math.random(10)
						Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
						DestroyEntity(Logic.GetEntityAtPosition(EasterEggposTable[i][k].X, EasterEggposTable[i][k].Y))
						table.remove(EasterEggposTable[i],k)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein Osterei gefunden. Inhalt: "..randomEventAmount.." Taler")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 112 )
						end
					end
				end
			end
		end
	end
end
RabbitFleeCounter = {}
for i = 1,4 do
	RabbitFleeCounter[i] = 0
end
function ControlRabbits()
	for i = 1,4 do
		-- 337 = "TL_ANIMAL_FLEE", 331 = "TL_RABBIT_IDLE"
		if IsValid("rabbit"..i) then
			if GetEntityCurrentTask(Logic.GetEntityIDByName("rabbit"..i)) == TaskLists.TL_ANIMAL_FLEE then
				RabbitFleeCounter[i] = RabbitFleeCounter[i] + 1
			else
				RabbitFleeCounter[i] = 0
			end
			if RabbitFleeCounter[i] >= 20 then
				local pos = GetPosition("rabbit"..i)
				local count = math.random(4)
				if count == 1 then
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X+math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X-math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y+math.random(50,100), 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y-math.random(50,100), 0, 7)
				elseif count == 2 or count == 3 then
					Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
					CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,1000,300)
				elseif count == 4 then
					Logic.CreateEntity(Entities.XD_Silver1, pos.X, pos.Y, 0, 0)
				end
				RabbitFleeCounter[i] = 0
			end
		end
	end
end

function OnSpecialRabbitDied()

	local entityID = Event.GetEntityID()

    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XA_Rabbit_Evil then

		if Logic.GetEntityName(entityID) ~= nil then

			local pos = GetPosition(entityID)

			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RecreateRabbit", 1, nil, {Logic.GetEntityName(entityID),pos.X,pos.Y})

		end

	end

end

function RecreateRabbit(_name,_posX,_posY)

	local sweetspot = {X = 33200, Y = 32000}

	local fakeid = Logic.CreateEntity(Entities.XD_Flower1,sweetspot.X,sweetspot.Y,0,0)

	if Logic.GetSector(fakeid) ~= 0 then

		local id = Logic.CreateEntity(Entities.XA_Rabbit_Evil,sweetspot.X,sweetspot.Y,0,0)

		Logic.SetEntityName(id,_name)

		SetEntitySize(id,2.5)

		Logic.DestroyEntity(fakeid)

		return true

	else

		Logic.DestroyEntity(fakeid)

		local x, y = _posX,_posY

		local offset = 3000;

		local xmax, ymax = Logic.WorldGetSize();

		local dmin, xspawn, yspawn;

		for y_ = y - offset, y + offset, 100 do

			for x_ = x - offset, x + offset, 100 do

				if y_ > 0 and x_ > 0 and xmax < x_ and y_ < ymax then

					local d = (x_ - x)^2 + (y_ - y)^2;

					if IsExisting(fakeid) then

						Logic.DestroyEntity(fakeid)

					end

					fakeid = Logic.CreateEntity(Entities.XD_Flower1,x_,y_,0,0)

					if Logic.GetSector(fakeid) ~= 0 then

						if not dmin or dmin > d then
							dmin = d;

							xspawn = x_;
							yspawn = y_;
						end;

					end;

					Logic.DestroyEntity(fakeid)
				end;
			end;
		end;

		if xspawn then

			local id = Logic.CreateEntity(Entities.XA_Rabbit_Evil,xspawn,yspawn,0,0)

			Logic.SetEntityName(id,_name)

			SetEntitySize(id,2.5)

			return true

		else

			LuaDebugger.Log("Recreating Rabbit ".._name.." could not find valid position near ".._posX..", ".._posY)

			Logic.DestroyEntity(fakeid)

			return true

		end;

	end

end

function OnSilvermineEmpty()

	local entityID = Event.GetEntityID()

    local entityType = Logic.GetEntityType(entityID)

	if entityType == Entities.XD_SilverPit1 then

		StartCountdown(2*60,RabbitStatueInit,false)

		Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity,33200,32000,0,7)

	end

end

function RabbitStatueInit()

	Script.Load("maps/externalmap/mysterious_statue.lua")
	local sizeX,sizeY = Logic.WorldGetSize()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{sizeX/2})
	StartSimpleJob("RabbitStatueMadness")
end

function ControlRabbitStatue(_CenterPos)


	if ({Logic.GetEntitiesInArea(Entities.XA_Rabbit_Evil, _CenterPos, _CenterPos, 1500, 4)})[1] == 4 then

		InitRabbitStatueEggs()
		return true

	end

end

function InitRabbitStatueEggs()

	Message("Es sind weitere Ostereier aufgetaucht!")
	local totaleggs = 20
	local count = 0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,sizeX/2,sizeX/2,0,8))
	local tempid
	local tempsec
	while count < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		if GetDistance({X=sizeX/2,Y=sizeY/2},{X=posX,Y=posY}) < 5000 then
			tempid = Logic.CreateEntity(Entities.XD_Flower1,posX,posY,0,0)
			tempsec = Logic.GetSector(tempid)
			if tempsec == sec then
				count = count + 1
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"RabbitStatue_EasterEgg_"..count)
			end
			Logic.DestroyEntity(tempid)
		end
	end
	RabbitStatue_EasterEggposTable = {}
	for i = 1,totaleggs do
		RabbitStatue_EasterEggposTable[i] = GetPosition("RabbitStatue_EasterEgg_"..i)
	end
	StartSimpleJob("ControlRabbitStatueEggs")
end

function ControlRabbitStatueEggs()

	for j = 1, 4 do
		for k,_ in pairs(RabbitStatue_EasterEggposTable) do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y, 300, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					local randomEvent = math.random(3)
					if randomEvent == 3 then
						Logic.CreateEffect(GGL_Effects.FXMaryPoison,RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y)
						Logic.CreateEffect(GGL_Effects.FXMaryDemoralize,RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y)
						SetHealth(entities[2],0)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein faules Osterei gefunden... Wie das stinkt!")
							Sound.PlayGUISound( Sounds.OnKlick_Select_mary_de_mortfichet, 122 )
						end
					else
						local randomEventAmount = 10+math.random(10)
						Logic.AddToPlayersGlobalResource(j,ResourceType.SilverRaw,randomEventAmount)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein besonders seltenes Osterei gefunden. Inhalt: "..randomEventAmount.." Silber")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 112 )
						end
					end
					DestroyEntity(Logic.GetEntityAtPosition(RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y))
					table.remove(RabbitStatue_EasterEggposTable,k)
				end
			end
		end
	end
	local sizeX,sizeY = Logic.WorldGetSize()
	if ({Logic.GetEntitiesInArea(Entities.XD_EasterEgg1, sizeX/2, sizeX/2, 5000, 1)})[1] == 0 then
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{sizeX/2})
		return true
	end
end

function RabbitStatueMadness()

	if Score.Player[7].battle > 500 then

		local eID = ReplaceEntity(({Logic.GetEntities(Entities.XD_Rabbit_Statue,1)})[2], Entities.CB_RabbitStatue)
		newID = ChangePlayer(eID, 7)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatueMadness",1,{},{newID})
		DamageTracker = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_HURT_ENTITY, "", "OnRabbitStatueDamaged", 1)

		eff_flakes = Logic.CreateEffect(GGL_Effects.FXAshFlakes,32000,32000)
		eff_embers = Logic.CreateEffect(GGL_Effects.FXEmbers,32000,32000)
		return true
	end

end
function ControlRabbitStatueMadness(_eID)

	local range = gvLightning.Range + 2*Logic.GetRandom(gvLightning.Range)
	local damage = gvLightning.BaseDamage + 5*(Logic.GetRandom(gvLightning.BaseDamage) )
	local buildingdamage = (((gvLightning.BaseDamage + Logic.GetRandom(gvLightning.BaseDamage))*6) + math.min(GetCurrentWeatherGfxSet()*5,55)*gvLightning.DamageAmplifier)
	local x,y
	for i = 1,(math.ceil(math.min(500/(GetEntityHealth(_eID)+1),100))),1 do
		x = math.random(26500,37500)
		y = math.random(27500,36500)
		Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,x,y)
		gvLightning.Damage(x,y,range,damage,buildingdamage)
	end

	local pID = GUI.GetPlayerID()
	if gvLightning.RecentlyDamaged[pID] == true then
		Sound.PlayGUISound( Sounds.OnKlick_Select_varg, 92 )
		Sound.PlayGUISound( Sounds.OnKlick_PB_Tower3, 94 )
		Sound.PlayGUISound( Sounds.OnKlick_PB_PowerPlant1, 82 )
		Sound.PlayGUISound(Sounds.AmbientSounds_rainmedium,120)
		Stream.Start("Sounds\\Misc\\SO_buildingdestroymedium.wav",72)
		gvLightning.RecentlyDamaged[pID] = false
	end
	for i = 1,4 do
		local pos = GetPosition("rabbit"..i)
		local count = math.random(GetEntityHealth("rabbit"..i))
		if count < 20 then
			Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
			CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,1000,300)
		end
	end
	if IsDestroyed(_eID) then
		RabbitStatueMadnessFallen()
		Logic.DestroyEffect(eff_embers)
		Logic.DestroyEffect(eff_flakes)
		return true
	end
end
function OnRabbitStatueDamaged()

	local attacker = Event.GetEntityID1()

    local target = Event.GetEntityID2();

	local targettype = Logic.GetEntityType(target)

	local player = GetPlayer(attacker)

    local dmg = CEntity.TriggerGetDamage();

	if targettype == Entities.CB_RabbitStatue then

		Logic.AddToPlayersGlobalResource(player, ResourceType.Silver, math.ceil(dmg/100))

	end

end;
function RabbitStatueMadnessFallen()
	do
		local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.XD_Silver1, 31793.88, 32311.46, 0.00, 0);tbi(e,id)
		id = Logic.CreateEntity(Entities.XD_Silver1, 32272.77, 32280.08, 0.00, 0);tbi(e,id)
		id = Logic.CreateEntity(Entities.XD_Silver1, 32284.77, 31827.77, 0.00, 0);tbi(e,id)
		id = Logic.CreateEntity(Entities.XD_Silver1, 31863.61, 31820.82, 0.00, 0);tbi(e,id)
		id = Logic.CreateEntity(Entities.XD_Silver1, 32035.03, 31981.87, 275.00, 0);tbi(e,id)
	end
	EndJob(DamageTracker)
end

SheepAreaCount = { }
for i = 1,4 do
	if not SheepAreaCount[i] then
		SheepAreaCount[i] = 0
	end
end
SheepGateArea = {   [1] = {X = 21700, Y = 46500},
					[2] = {X = 42400, Y = 46500},
					[3] = {X = 42400, Y = 17500},
					[4] = {X = 21700, Y = 17500}
						}
SheepCenterArea = { [1] = {X = 22000, Y = 45000},
					[2] = {X = 42100, Y = 45000},
					[3] = {X = 42100, Y = 19000},
					[4] = {X = 22000, Y = 19000}
						}

function CheckSheepGates()

	for i = 1,4 do
		for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.XA_Sheep1,Entities.XA_Sheep2,Entities.XA_Sheep3),CEntityIterator.InCircleFilter(SheepGateArea[i].X, SheepGateArea[i].Y, 200)) do
			if Logic.GetEntityName(eID) == nil then
				local type = Logic.GetEntityType(eID)
				DestroyEntity(eID)
				SheepAreaCount[i] = SheepAreaCount[i] + 1
				Logic.SetEntityName(Logic.CreateEntity(type,SheepCenterArea[i].X,SheepCenterArea[i].Y,0,0),"GatheredSheep"..i.."_"..SheepAreaCount[i])
			end
		end

	end

	if Logic.GetTime() >= 60*60 then

		GatheredSheepReward()

		return true

	end

end

function GatheredSheepReward()

	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyTypeFilter(Entities.XD_WoodenFence01,Entities.XD_WoodenFence09)) do

		DestroyEntity(eID)
	end
	for i = 1,4 do

		if SheepAreaCount[i] > 0 then

			for k = 1,SheepAreaCount[i] do

			local pos = GetPosition("GatheredSheep"..i.."_"..k)

			local count = math.random(6)

				if count == 1 then

					Logic.SetResourceDoodadGoodAmount(ReplaceEntity("GatheredSheep"..i.."_"..k,Entities.XD_Silver1),10+math.random(5))

				elseif count == 2 then

					Logic.SetResourceDoodadGoodAmount(ReplaceEntity("GatheredSheep"..i.."_"..k,Entities.XD_Iron1),150+math.random(50))

				elseif count == 3 then

					Logic.SetResourceDoodadGoodAmount(ReplaceEntity("GatheredSheep"..i.."_"..k,Entities.XD_Sulfur1),100+math.random(30))

				else

					ReplaceEntity("GatheredSheep"..i.."_"..k,_G["Entities.XD_Cobweb"..math.random(4)])

				end

			Logic.CreateEffect(GGL_Effects.FXMaryDemoralize,pos.X,pos.Y)

			end

		end

	end

end 