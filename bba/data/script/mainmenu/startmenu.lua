----------------------------------------------------------------------------------------------------
-- Start menu stuff
----------------------------------------------------------------------------------------------------
-- Table
Ex3 = {Version = 0.772}
StartMenu = {}
-- only high tex quality supported
if GDB.IsKeyValid( "Config\\Display\\TextureResolution" ) then
	if GDB.GetValue( "Config\\Display\\TextureResolution" ) ~= 0 then
		GDB.SetValue( "Config\\Display\\TextureResolution", 0 )
		Framework.ExitGame()
	end
end

----------------------------------------------------------------------------------------------------
-- Start main menu

function StartMenu.Start( _StartVideoFlag )

	-- Make page active
	XGUIEng.ShowAllSubWidgets("Screens", 0)
	XGUIEng.ShowWidget("StartMenu00", 1)

	if (XGUIEng.GetStringTableText("MainMenu/StartOnlineGame") == "DISABLE") then
	    XGUIEng.ShowWidget( "StartMenu00_StartOnline", 0 )
	end

	-- Set up environment
	StartMenu.DoInitStuff(_StartVideoFlag)

	-- Keys
	Input.KeyBindDown(Keys.ModifierAlt + Keys.F4, "StartMenu_KeyBindings_AltFFour()",2)

	if CNetwork then
		XGUIEng.ShowWidget("StartMenu00_StartOnline", 1)
		XGUIEng.ShowWidget("StartMenu00_StartSinglePlayer", 0)
	else
		XGUIEng.ShowWidget("StartMenu00_StartOnline", 0)
		XGUIEng.ShowWidget("StartMenu00_StartSinglePlayer", 1)
	end

end

----------------------------------------------------------------------------------------------------
-- Init start menu generics - also used by post game screen

function StartMenu.DoInitStuff(_StartVideoFlag)

	local MusicPath = "music\\"
	local SongNumber = XGUIEng.GetRandom(22)

	if SongNumber == 0 then
		MusicPath = MusicPath .. "01_Main_Theme1.mp3"
	elseif SongNumber == 1 then
		MusicPath = MusicPath .. "02_Main_Theme2.mp3"
	elseif SongNumber == 2 then
		MusicPath = MusicPath .. "44_Main_Theme3.mp3"
	elseif SongNumber == 3 then
		MusicPath = MusicPath .. "45_Main_Theme4.mp3"
	elseif SongNumber == 4 then
		MusicPath = MusicPath .. "46_Main_Theme5.mp3"
	elseif SongNumber == 5 then
		MusicPath = MusicPath .. "47_Main_Theme6.mp3"
	elseif SongNumber == 6 then
		MusicPath = MusicPath .. "48_Main_Theme7.mp3"
	elseif SongNumber == 7 then
		MusicPath = MusicPath .. "49_Main_Theme8.mp3"
	elseif SongNumber == 8 then
		MusicPath = MusicPath .. "50_Main_Theme9.mp3"
	elseif SongNumber == 9 then
		MusicPath = MusicPath .. "51_Main_Theme10.mp3"
	elseif SongNumber == 10 then
		MusicPath = MusicPath .. "52_Main_Theme11.mp3"
	elseif SongNumber == 11 then
		MusicPath = MusicPath .. "53_Main_Theme12.mp3"
	elseif SongNumber == 12 then
		MusicPath = MusicPath .. "54_Main_Theme13.mp3"
	elseif SongNumber == 13 then
		MusicPath = MusicPath .. "55_Main_Theme14.mp3"
	elseif SongNumber == 14 then
		MusicPath = MusicPath .. "56_Main_Theme15.mp3"
	elseif SongNumber == 15 then
		MusicPath = MusicPath .. "57_Main_Theme16.mp3"
	elseif SongNumber == 16 then
		MusicPath = MusicPath .. "58_Main_Theme17.mp3"
	elseif SongNumber == 17 then
		MusicPath = MusicPath .. "59_Main_Theme18.mp3"
	elseif SongNumber == 18 then
		MusicPath = MusicPath .. "60_Main_Theme19.mp3"
	elseif SongNumber == 19 then
		MusicPath = MusicPath .. "61_Main_Theme20.mp3"
	elseif SongNumber == 20 then
		MusicPath = MusicPath .. "62_Main_Theme21.mp3"
	elseif SongNumber == 21 then
		MusicPath = MusicPath .. "63_Main_Theme22.mp3"
	elseif SongNumber == 22 then
		MusicPath = MusicPath .. "64_Main_Theme23.mp3"
	end

	Music.Start(MusicPath  , 170, 1)

	Mouse.CursorSet(10)

	-- Init frame counter
	StartMenu.GEN_FrameCounter = 0
	StartMenu.GEN_StartVideoFlag = _StartVideoFlag
	StartMenu.GEN_VideoRunning = 0

end


----------------------------------------------------------------------------------------------------
-- Button action functions
----------------------------------------------------------------------------------------------------
-- On new game button

function StartMenu.S00_ToSingleplayerMenu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu00", 1)
	-- Kampagnenschwierigkeit
	if not GDB.IsKeyValid("Game\\Extra3\\CampaignDifficulty") then
		GDB.SetValue("Game\\Extra3\\CampaignDifficulty", 2 )
		XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",0)
		XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",1)
		XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",0)
		else
		if GDB.GetValue("Game\\Extra3\\CampaignDifficulty") == 1 then
			XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",0)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",0)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",1)
		elseif GDB.GetValue("Game\\Extra3\\CampaignDifficulty") == 2 then
			XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",0)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",1)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",0)
		else
			XGUIEng.HighLightButton("SPM00_DifficultyButtonEasy",1)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonNormal",0)
			XGUIEng.HighLightButton("SPM00_DifficultyButtonHard",0)
		end
	end
end



----------------------------------------------------------------------------------------------------
-- On load game button

function StartMenu.OnLoadGame()
	LoadSaveGame.Show()
end

----------------------------------------------------------------------------------------------------
-- On start multi player button

function StartMenu.OnStartMP()
	MPMenu.Screen_ToMain()
end

----------------------------------------------------------------------------------------------------
-- End game

function StartMenu.OnEndGame()

	XGUIEng.ShowWidget("QuitGameOverlayScreen", 1)

end


----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------
-- Generic update function

function StartMenu.GEN_Update()

	-- Increment frame counter
	StartMenu.GEN_FrameCounter = StartMenu.GEN_FrameCounter + 1


	-- Start video
	if StartMenu.GEN_FrameCounter == 2 then
		if StartMenu.GEN_StartVideoFlag == 1 then
			if StartMenu.GEN_VideoRunning == 0 then
				XGUIEng.StartVideoPlayback("StartMenu_BG_Video", "data\\graphics\\videos\\Menu\\FightScene.bik", 1)
				StartMenu.GEN_VideoRunning = 1
			end
			StartMenu.GEN_StartVideoFlag = 0
		end
	end

end

----------------------------------------------------------------------------------------------------
-- Update version widget

function StartMenu.S00_Update_VersionInformation()

	--[[ Init text
	local Text = "@center"

	-- Add version string
	-- orig:Text = Text .. " " .. Framework.GetVName() -> liefert nur einen leeren string
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	]]
end


----------------------------------------------------------------------------------------------------
-- Update version widget

function StartMenu.S00_Update_VersionNumber()

	-- Init text
	local Text = "@ra"

	-- Add version string
	--Framework.GetProgramVersion()
	Text = Text .. " " .. Ex3.Version .. " Extra3"

	-- Set text
	XGUIEng.SetText(XGUIEng.GetCurrentWidgetID(), Text)

end

----------------------------------------------------------------------------------------------------

function StartMenu.UpdateNetworkButtons()


	--[[local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

	local GetVersion = Framework.GetVersion()
	if GetVersion == then
		XGUIEng.DisableButton(CurrentWidgetID,0)
	else
		XGUIEng.DisableButton(CurrentWidgetID,1)
	end]]

end

----------------------------------------------------------------------------------------------------
-- Keys
----------------------------------------------------------------------------------------------------
-- Quit

function StartMenu_KeyBindings_AltFFour()

	XGUIEng.ShowWidget("QuitGameOverlayScreen", 1)

end

----------------------------------------------------------------------------------------------------
-- Quit game screen
----------------------------------------------------------------------------------------------------

function QuitGame_Button_Quit()
	Framework.ExitGame()
end

----------------------------------------------------------------------------------------------------

function QuitGame_Button_Cancel()
	XGUIEng.ShowWidget( "QuitGameOverlayScreen", 0)
end