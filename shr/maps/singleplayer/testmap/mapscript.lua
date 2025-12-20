--------------------------------------------------------------------------------
-- MapName: BS Testmap
--
-- Author: Ghoul
--
--------------------------------------------------------------------------------
gvTestFlag = true
Script.Load( Folders.MapTools.."Main.lua" )
IncludeGlobals("MapEditorTools")
function FirstMapAction()

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
	for i = 2,8 do
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
		TrMod3.text = "Beschleunigt das Spiel"
	else
		TrMod3.text = "Click here to speed up the game"
	end
	TrMod3.cost = { Gold = 0 }
	TrMod3.Callback = AddSpeed
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
	local player = GUI.GetPlayerID()

	AddGold(player,1000000)
	AddStone(player,1000000)
	AddIron(player,1000000)
	AddWood(player,1000000)
	AddSulfur(player,1000000)
	AddClay(player,1000000)
	Logic.AddToPlayersGlobalResource(player,ResourceType.SilverRaw,1000000)
	Logic.AddToPlayersGlobalResource(player,ResourceType.Knowledge,1000000)
end
function AddTechs()
	ResearchAllTechnologies(1, true, true, true, true, true)
end
function AddSpeed()
	Game.GameTimeSetFactor(4)
end
function AddKI()
	do
		local id, tbi, e = nil, table.insert, {}
		id = Logic.CreateEntity(Entities.PB_Headquarters3, 4700.00, 7100.00, 180.00, 2);tbi(e,id);Logic.SetEntityName(id, "p2")
		id = Logic.CreateEntity(Entities.PB_Tower3, 5700.00, 4800.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Foundry2, 7400.00, 8000.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Tower3, 6400.00, 8500.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Tower3, 8500.00, 7900.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Barracks2, 7500.00, 6000.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Archery2, 7900.00, 4000.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Tower3, 9100.00, 4600.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Tower3, 9100.00, 3100.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Stable2, 10700.00, 3500.00, 0.00, 2);tbi(e,id)
		id = Logic.CreateEntity(Entities.PB_Tower3, 4700.00, 8300.00, 0.00, 2);tbi(e,id)
	end
	MapEditor_SetupAI(2,2,32000,3,"p2",3,0)
	SetupPlayerAi( 2, {constructing = true, repairing = true, extracting = 1, serfLimit = 12} )
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then
		SetPlayerName(2,"Test-Gegner")
	else
		SetPlayerName(2,"Test enemy")
	end
	SetHostile(1,2)
end
function AnfangsBriefing()
    local briefing = {}
    local AP = function(_page) table.insert(briefing, _page) return _page end
	local text
	if XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "de" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "DE" or XNetworkUbiCom.Tool_GetCurrentLanguageShortName() == "De" then

		text = {[1] = "Willkommen in diesen idyllischen Gefilden.",
				[2] = "Hier könnt ihr in aller Ruhe sämtliche Änderungen des Balancing Stuffs ausprobieren.",
				[3] = "Über das Tributmenü könnt ihr zusätzlich viele Technologien freischalten, Ressourcen erhalten, das Spieltempo erhöhen sowie eine gegnerische KI hinzufügen!"}

	else

		text = {[1] = "Welcome to these idyllic realms.",
				[2] = "Here you can try out all the balancing stuff changes at your leisure.",
				[3] = "You can also unlock many technologies, get resources, increase the game speed and add an enemy AI via the tribute menu!"}

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
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Testmap @cr "..
		" @color:230,0,240 v1.3 ")
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
