Script.Load( Folders.MapTools.."Main.lua" )

function GameCallback_OnGameStart()
	if not CUtil then
		Framework.CloseGame()
	end

	IncludeGlobals("MapEditorTools")

	CutsceneIntro()
	StartCountdown(34,GameStarting,false)

	gvMission.HighlightButton 			= {0,0,0,0,0}
	gvMission.HighlightButtonCounter 	= 1
	StartSimpleJob("Mission_EverySecond")
	for eID in CEntityIterator.Iterator(CEntityIterator.OfPlayerFilter(2), CEntityIterator.IsBuildingFilter() ) do
		MakeInvulnerable(eID)
	end

	LocalMusic.UseSet = EUROPEMUSIC
	AddPeriodicNight(50)


	local InitGoldRaw 		= 1000
	local InitClayRaw 		= 2000
	local InitWoodRaw 		= 2000
	local InitStoneRaw 		= 1000
	local InitIronRaw 		= 0
	local InitSulfurRaw		= 0


	Logic.AddToPlayersGlobalResource(1, ResourceType.GoldRaw, InitGoldRaw)
	Logic.AddToPlayersGlobalResource(1, ResourceType.ClayRaw, InitClayRaw)
	Logic.AddToPlayersGlobalResource(1, ResourceType.WoodRaw, InitWoodRaw)
	Logic.AddToPlayersGlobalResource(1, ResourceType.StoneRaw, InitStoneRaw)
	Logic.AddToPlayersGlobalResource(2, ResourceType.GoldRaw, InitGoldRaw*50)
	Logic.AddToPlayersGlobalResource(2, ResourceType.ClayRaw, InitClayRaw*10)
	Logic.AddToPlayersGlobalResource(2, ResourceType.WoodRaw, InitWoodRaw*10)
	Logic.AddToPlayersGlobalResource(2, ResourceType.StoneRaw, InitStoneRaw*20)
	Logic.AddToPlayersGlobalResource(2, ResourceType.IronRaw, 10000)
	Logic.AddToPlayersGlobalResource(2, ResourceType.SulfurRaw, 10000)

	Logic.SetTechnologyState(1,Technologies.B_Ironmine, 	0)
	Logic.SetTechnologyState(1,Technologies.B_Stonemine, 	0)
	Logic.SetTechnologyState(1,Technologies.B_Sulfurmine, 	0)
	Logic.SetTechnologyState(1,Technologies.B_Claymine, 	0)
	ForbidTechnology(Technologies.B_University,1)
	ForbidTechnology(Technologies.B_Farm,1)
	ForbidTechnology(Technologies.B_Residence,1)
	ForbidTechnology(Technologies.B_Village,1)
	ForbidTechnology(Technologies.B_Monastery,1)
	ForbidTechnology(Technologies.B_Market,1)
	ForbidTechnology(Technologies.GT_Trading,1)
	ForbidTechnology(Technologies.UP1_Headquarter,1)
	ForbidTechnology(Technologies.UP2_Headquarter,1)
	ForbidTechnology(Technologies.T_CityGuard,1)
	ForbidTechnology(Technologies.T_Tracking,1)
	ForbidTechnology(Technologies.GT_Construction,1)
	Logic.SetTechnologyState(1,Technologies.GT_Banking, 	0)
	ForbidTechnology(Technologies.GT_Alchemy,1)
	ForbidTechnology(Technologies.GT_Mathematics,1)
	ForbidTechnology(Technologies.GT_Mercenaries,1)
	ForbidTechnology(Technologies.T_MakeSnow,1)
	ResearchTechnology(Technologies.UP1_Lighthouse,1)
	ForbidTechnology(Technologies.MU_Cannon5)
	ForbidTechnology(Technologies.MU_Cannon6)

	XGUIEng.SetText(""..
		"TopMainMenuTextButton", "@color:0,0,0,0 ....... @color:255,0,10   Menü @cr "..
		" @cr @cr @color:150,0,255 Ghoul @color:230,0,240 @cr Aufbruch ins Ungewisse @cr "..
		" @color:230,0,240 v1.0")
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

---------------------------------------------------------------------------------------------
function VictoryJob()

	if IsDestroyed("player2") then
		CutsceneOutro()
	return true
	end
end


function GameStarting()
	TagNachtZyklus(24,1,0,0)
	Logic.SetGlobalInvulnerability(0)
    Interface_SetCinematicMode(0)
	XGUIEng.ShowWidget("Cinematic_Headline", 0)
	XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)
	Display.SetFarClipPlaneMinAndMax(0, 0)
	Music.SetVolumeAdjustment(gvCutscene.Music)
    GUI.SetFeedbackSoundOutputState(1)
    Counter.Cutscene = nil
    gvCutscene = nil
    cutsceneIsActive = false
	XGUIEng.ShowWidget("MainMenuWindow_NetworkGame",0)
	XGUIEng.ShowWidget("MainMenuWindow_NetworkGameOverlay",0)
end
function GameEnding()
	Logic.SetGlobalInvulnerability(0)
    Interface_SetCinematicMode(0)
	XGUIEng.ShowWidget("Cinematic_Headline", 0)
	XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)
	Display.SetFarClipPlaneMinAndMax(0, 0)
	Music.SetVolumeAdjustment(gvCutscene.Music)
    GUI.SetFeedbackSoundOutputState(1)
    Counter.Cutscene = nil
    gvCutscene = nil
    cutsceneIsActive = false
	Logic.PlayerSetGameStateToWon(1)

 end
--------------------------- Cutscenes -----------------------------------------------------------------------------------
function CutsceneIntro()
	local pos1 = {Logic.GetEntityPosition(Logic.GetEntityIDByName("Cutscene_1"))}
	local pos1a = {Logic.GetEntityPosition(Logic.GetEntityIDByName("Cutscene_1a"))}
	local pos2 = {Logic.GetEntityPosition(Logic.GetEntityIDByName("Cutscene_2"))}
	local pos3 = {Logic.GetEntityPosition(Logic.GetEntityIDByName("Cutscene_3"))}
	local cutsceneTable = {
    StartPosition = {
	position = pos1, angle = 14, zoom = 5400, rotation = 95},
	Flights = 	{
					{
					position = pos1a,
					angle = 16,
					zoom = 4400,
					rotation = 46,
					duration = 17,
					action 	=	function()

								end,
					title = " ",
					text = " "
					},
					{
					position = pos2,
					angle = 18,
					zoom = 3900,
					rotation = 26,
					duration = 5,
					action 	=	function()
					Stream.Start("Voice\\map01_bs_tutorial\\01.wav", 252)

								end,
					title = " @color:180,0,240 Mentor",
					text = " @color:230,0,0 Willkommen zum Balancing Stuff Tutorial!"
					},
					{
					position = pos3,
					angle = 21,
					zoom = 3700,
					rotation = -10,
					duration = 8,
					delay = 3,
					action 	=	function()
					Stream.Start("Voice\\map01_bs_tutorial\\02.wav", 252)

								end,
					title = " @color:180,0,240 Mentor",
					text = " @color:230,0,0 In den n\195\164chsten Minuten werde ich Euch die Neuerungen und \195\132nderungen des Balancing Stuffs n\195\164her bringen!"
					}


				}

	}
	Startcutscene(cutsceneTable)
end

-------------------------------------------------------------------------------------------------------------------------
--------------------------- Comforts ------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

function Startcutscene(_Cutscene)

  local length = 0
  local i
  for i = 1, table.getn(_Cutscene.Flights) do
    length = length + _Cutscene.Flights[i].duration + (_Cutscene.Flights[i].delay or 0)
  end
	gvCutscene = {
    Page      = 1,
    Flights   = _Cutscene.Flights,
    EndTime   = Logic.GetTime() + length,
    Callback  = _Cutscene.Callback,
    Music     = Music.GetVolumeAdjustment()
    }
	cutsceneIsActive = true
	--XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 100)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"), 0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"), 0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"), 0)
	Logic.SetGlobalInvulnerability(1)
	Interface_SetCinematicMode(1)
	Display.SetFarClipPlaneMinAndMax(0, 33000)	-- Standard: 14000
	Music.SetVolumeAdjustment(gvCutscene.Music * 0.6)
	Sound.PlayFeedbackSound(0,0)
	GUI.SetFeedbackSoundOutputState(0)
	--Sound.StartMusic(1,1)
	LocalMusic.SongLength = 0	-- !!!
	Camera.StopCameraFlight()
	Camera.ZoomSetDistance(_Cutscene.StartPosition.zoom)
	Camera.RotSetAngle(_Cutscene.StartPosition.rotation)
	Camera.ZoomSetAngle(_Cutscene.StartPosition.angle)
	Camera.ScrollSetLookAt(_Cutscene.StartPosition.position[1],_Cutscene.StartPosition.position[2])
	Counter.SetLimit("Cutscene", -1)
	StartSimpleJob("ControlCutscene")
end

function ControlCutscene()
  if not gvCutscene then return true end
    if Logic.GetTime() >= gvCutscene.EndTime then
      CutsceneDone()
      return true
    else
     if Counter.Tick("Cutscene") then
        local page = gvCutscene.Flights[gvCutscene.Page]
          if not page then CutsceneDone() return true end
             Camera.InitCameraFlight()
             Camera.ZoomSetDistanceFlight(page.zoom, page.duration)
             Camera.RotFlight(page.rotation, page.duration)
             Camera.ZoomSetAngleFlight(page.angle, page.duration)
             Camera.FlyToLookAt(page.position[1], page.position[2], page.duration)

            if page.title ~= nil then
               PrintBriefingHeadline("@color:255,250,200 " .. page.title)
            end

            if page.text ~= nil then
               PrintBriefingText(page.text)
            end

            if page.action ~= nil then
               page.action()
            end

			if (page.title ~= "") or (page.text ~= "") then
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"), 0)
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"), 0)
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"), 1)
				XGUIEng.SetWidgetPositionAndSize("CinematicBar02", 0, 2400, 3200, 160)
				XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)
			else--if (page.title == "") and (page.text == "") then
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"), 0)
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"), 0)
				XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"), 0)
			end

            Counter.SetLimit("Cutscene", page.duration + (page.delay or 0))
            gvCutscene.Page = gvCutscene.Page + 1
          end
        end
end

function CutsceneDone()
	if not gvCutscene then return true end
    Logic.SetGlobalInvulnerability(0)
    Interface_SetCinematicMode(0)
   XGUIEng.ShowWidget("Cinematic_Headline", 0)
   XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)	-- ?
   Display.SetFarClipPlaneMinAndMax(0, 0)
   Music.SetVolumeAdjustment(gvCutscene.Music)
    GUI.SetFeedbackSoundOutputState(1)
    if gvCutscene.Callback ~= nil then
        gvCutscene.Callback()
    end
    Counter.Cutscene = nil
    gvCutscene = nil
    cutsceneIsActive = false
end
function MovieWindow(_Title,_Text)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Movie"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Cinematic_Text"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieBarTop"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieBarBottom"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CreditsWindowLogo"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("MovieInvisibleClickCatcher"),0)
	XGUIEng.SetText(XGUIEng.GetWidgetID("CreditsWindowTextTitle"),Umlaute(_Title))
	XGUIEng.SetText(XGUIEng.GetWidgetID("CreditsWindowText"),Umlaute(_Text))
end

function CloseMovieWindow()
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("Movie"),0)
end
function SCV_SetVisible(_entity,_flag)
	local id = GetEntityId(_entity)
	if _flag == 0 then
		Logic.SetEntityScriptingValue(id,-30,257)
	elseif _flag == 1 then
		Logic.SetEntityScriptingValue(id,-30,65537)
	end
end
--**
function GetHealth(_entity)
return Logic.GetEntityHealth(GetEntityId(_entity))/Logic.GetEntityMaxHealth(GetEntityId(_entity))*100
end
 ------------------------------------------------------------------------------------------------------------------------

function MuteMentor()
	Sound.PlayFeedbackSound(0,0)
	GUI.SetFeedbackSoundOutputState(0)
	Music.SetVolumeAdjustment(Music.GetVolumeAdjustment() * 0.5)
end
function UnmuteMentor()
	GUI.SetFeedbackSoundOutputState(1)
	Music.SetVolumeAdjustment(Music.GetVolumeAdjustment() * 2)
end
