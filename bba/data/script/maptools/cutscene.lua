function Start_Cutscene(_Cutscene)
	
	local length = 0
	local i
	for i = 1, table.getn(_Cutscene.Flights) do
	length = length + _Cutscene.Flights[i].duration + (_Cutscene.Flights[i].delay or 0)
	end
	gv_Cutscene = {
	Page      = 1,
	Flights   = _Cutscene.Flights,
	EndTime   = Logic.GetTime() + length,
	Callback  = _Cutscene.Callback,
	Music     = Music.GetVolumeAdjustment(),
	} 
	cutscene_IsActive = true
	--XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 100)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"), 0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"), 0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"), 0)
	Logic.SetGlobalInvulnerability(1)
	Interface_SetCinematicMode(1)
	Display.SetFarClipPlaneMinAndMax(0, 50000)	-- Standard: 14000
	Music.SetVolumeAdjustment(gv_Cutscene.Music * 0.6)
	Sound.PlayFeedbackSound(0,0)
	GUI.SetFeedbackSoundOutputState(0)
	--Sound.StartMusic(1,1)
	LocalMusic.SongLength = 0	-- !!!
	Camera.StopCameraFlight()
	Camera.ZoomSetDistance(_Cutscene.StartPosition.zoom)
	Camera.RotSetAngle(_Cutscene.StartPosition.rotation)
	Camera.ZoomSetAngle(_Cutscene.StartPosition.angle)
	Camera.ScrollSetLookAt(_Cutscene.StartPosition.position.X,_Cutscene.StartPosition.position.Y)  
	Counter.SetLimit("Cutscene_", -1)
	StartSimpleJob("Control_Cutscene")
end

function Control_Cutscene()
  if not gv_Cutscene then return true end
    if Logic.GetTime() >= gv_Cutscene.EndTime then
      Cutscene_Done()
      return true
    else
     if Counter.Tick("Cutscene_") then
        local page = gv_Cutscene.Flights[gv_Cutscene.Page]
          if not page then CutsceneDone() return true end
             Camera.InitCameraFlight()
             Camera.ZoomSetDistanceFlight(page.zoom, page.duration)
             Camera.RotFlight(page.rotation, page.duration)
             Camera.ZoomSetAngleFlight(page.angle, page.duration)
             Camera.FlyToLookAt(page.position.X, page.position.Y, page.duration)
			 
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
			
            Counter.SetLimit("Cutscene_", page.duration + (page.delay or 0))
            gv_Cutscene.Page = gv_Cutscene.Page + 1
        end
    end
end

function Cutscene_Done()
	if not gv_Cutscene then return true end
    Logic.SetGlobalInvulnerability(0)
    Interface_SetCinematicMode(0)
	XGUIEng.ShowWidget("Cinematic_Headline", 0)
	XGUIEng.SetMaterialColor(XGUIEng.GetWidgetID("CinematicBar02"), 0, 0, 0, 0, 160)	-- ?
	Display.SetFarClipPlaneMinAndMax(0, 0)
	Music.SetVolumeAdjustment(gv_Cutscene.Music)
    GUI.SetFeedbackSoundOutputState(1)
    if gv_Cutscene.Callback ~= nil then
        gv_Cutscene.Callback()
    end
    Counter.Cutscene_ = nil
    gv_Cutscene = nil
    cutscene_IsActive = false
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
