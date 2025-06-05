--------------------------------------------------------------------------------
-- MapName: BS Testmap
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
function GameCallback_OnGameStart()

	-- Include global tool script functions
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
	TagNachtZyklus(24,1,1,-2,1)
	gvMission = {}
	gvMission.PlayerID = GUI.GetPlayerID()
	--Init local map stuff
	Mission_InitGroups()
	Mission_InitLocalResources()

	MultiplayerTools.InitCameraPositionsForPlayers()
	MultiplayerTools.SetUpGameLogicOnMPGameConfig()

	StartCountdown(1,AnfangsBriefing,false)
	StartCountdown(5,Zusatztribute,false)
	--

	if XNetwork.Manager_DoesExist() == 0 then

		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end

	LocalMusic.UseSet = HIGHLANDMUSIC

	MultiplayerTools.GiveBuyableHerosToHumanPlayer( 14 )

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
	for i = 3,8 do
		Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
	-- Initial Resources
	local InitGoldRaw 		= 500
	local InitClayRaw 		= 1200
	local InitWoodRaw 		= 1500
	local InitStoneRaw 		= 700
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0
	--Add Players Resources
	Tools.GiveResouces(1, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
end

function Zusatztribute()
	Tribut1()
	Tribut2()
	Tribut3()
	Tribut4()
	--
	for k,v in pairs(BS.AchievementNames) do
		XGUIEng.ShowWidget(k,1)
	end
	if CNetwork then
		CommandCallback_PlaceBuilding = function(_name, _player, _upgradeCategory, _x, _y, _rotation, ...)
			return true
		end
		CNetwork.SetNetworkHandler("BuyHero",
			function(name, _playerID, _buildingID, _type)
				if CNetwork.IsAllowedToManipulatePlayer(name, _playerID) then
					(SendEvent or CSendEvent).BuyHero(_playerID, _buildingID, _type)
				end
			end
		)
	end
end

function Tribut1()
	local TrMod1 =  {}
	TrMod1.playerId = 1
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		TrMod1.text = "Erhaltet viele Ressourcen"
	else
		TrMod1.text = "Click here to gain a lot of resources"
	end
	TrMod1.cost = { Gold = 0 }
	TrMod1.Callback = AddResources
	TMod1 = AddTribute(TrMod1)
end
function Tribut2()
	local TrMod2 =  {}
	TrMod2.playerId = 1
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		TrMod2.text = "Schaltet viele Technologien frei"
	else
		TrMod2.text = "Click here to unlock a lot of technologies"
	end
	TrMod2.cost = { Gold = 0 }
	TrMod2.Callback = AddTechs
	TMod2 = AddTribute(TrMod2)
end
function Tribut3()
	local TrMod3 =  {}
	TrMod3.playerId = 1
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		TrMod3.text = "Schaltet alle Silber-Technologien frei"
	else
		TrMod3.text = "Click here to unlock all silver related technologies"
	end
	TrMod3.cost = { Gold = 0 }
	TrMod3.Callback = AddSilverTechs
	TMod3 = AddTribute(TrMod3)
end
function Tribut4()
	local TrMod4 =  {}
	TrMod4.playerId = 1
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		TrMod4.text = "Fügt eine gegnerische KI hinzu"
	else
		TrMod4.text = "Click here to add an hostile AI"
	end
	TrMod4.cost = { Gold = 0 }
	TrMod4.Callback = AddKI
	TMod4 = AddTribute(TrMod4)
end
function AddResources()
	for i = 1, 2 do
		AddGold(i,1000000)
		AddStone(i,1000000)
		AddIron(i,1000000)
		AddWood(i,1000000)
		AddSulfur(i,1000000)
		AddClay(i,1000000)
		Logic.AddToPlayersGlobalResource(i,ResourceType.SilverRaw,1000000)
		Logic.AddToPlayersGlobalResource(i,ResourceType.Knowledge,1000000)
	end
end
function AddTechs()
	for i = 1, 2 do
		ResearchAllTechnologies(i, true, true, true, true, false)
	end
end
function AddSilverTechs()
	for i = 1, 2 do
		ResearchAllTechnologies(i, false, false, false, false, true)
	end
end
function AddKI()
	do
		local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 13600.00, 24900.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Foundry2, 10800.00, 22800.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Residence3, 11400.00, 24100.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 11600.00, 27600.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Barracks2, 10900.00, 25600.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Headquarters3, 14200.00, 23900.00, 0.00, 3);tbi(e,id);Logic.SetEntityName(id, "p3")
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 13300.00, 26900.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Farm3, 10100.00, 20600.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 11700.00, 20300.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 13200.00, 21100.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Stable2, 18800.00, 24100.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Archery2, 16300.00, 24000.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 14900.00, 22900.00, 0.00, 3);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_DarkTower3, 14900.00, 24900.00, 0.00, 3);tbi(e,id)
	end
	MapEditor_SetupAI(3,3,48000,3,"p3",3,0)
	SetupPlayerAi(3, {constructing = true, repairing = true, extracting = 1, serfLimit = 12} )
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		SetPlayerName(3,"Test-Gegner")
	else
		SetPlayerName(3,"Test enemy")
	end
	SetHostile(1,3)
	SetHostile(2,3)
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
	local text
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then

		text = {[1] = "Willkommen in diesen idyllischen Gefilden.",
				[2] = "Hier könnt ihr in aller Ruhe sämtliche Änderungen des Balancing Stuffs ausprobieren.",
				[3] = "Über das Tributmenü könnt ihr zusätzlich viele Technologien freischalten, Ressourcen erhalten, sowie eine gegnerische KI hinzufügen!"}

	else

		text = {[1] = "Welcome to these idyllic realms.",
				[2] = "Here you can try out all the balancing stuff changes at your leisure.",
				[3] = "You can also unlock many technologies, get resources and add an enemy AI via the tribute menu!"}

	end
    AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 "..text[1]
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 "..text[2]
    }
	AP{
        title	= "@color:230,120,0 Intro",
        text	= "@color:230,0,0 "..text[3]
    }

    StartBriefing(briefing)
end


function Mission_InitGroups()
	Start()
end

function Start()
	InitDiplomacy()
	InitPlayerColorMapping()
end
function InitDiplomacy()

end
function InitPlayerColorMapping()
	XGUIEng.SetText(""..
		"TopMainMenuTextButton", "@color:0,0,0,0 ....... @color:255,0,10   Men\195\188 @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr BS Testmap @cr "..
		" @color:230,0,240 v1.1 ")
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrame"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMapOverlay"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMap"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrameBG"),0)
--**
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Container"),0,0,1400,1000)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Text"),100,669,850,48)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"),0,1000,1200,128)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,600,100)

end
