---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
-- Load sub scripts

Script.LoadFolder("Data\\Script\\MainMenu")


----------------------------------------------------------------------------------------------------
-- Main menu stuff
----------------------------------------------------------------------------------------------------
-- Table
LuaMainMenu = {}


----------------------------------------------------------------------------------------------------
-- Init functions
----------------------------------------------------------------------------------------------------
-- Called at program start

function LuaMainMenu.Init()

	-- Init sub menus
	if CNetwork then
		LoadMap.Init()
	end
	LoadSaveGame.Init()
	OptionsDisplay_Menu.Init()
	OptionsSound_Menu.Init()
	OptionsControls_Menu.Init()
	MPMenu.System_InitMenuStatics()
	OptionsMenu.System_InitMenuStatics()
	PGMenu.System_InitMenuStatics()

	-- Enable this for the demoversion
	-- Demo_Menu.Init()


	-- Play videos
	if Framework.ShouldPlayVideos() then
		Mouse.CursorHide()
		Framework.PlayVideo( "Videos\\UbiSoft_Logo.bik" )
		Framework.PlayVideo( "Videos\\BB_Logo.bik" )
		Mouse.CursorShow()
	end

	-- Start main menu
	StartMenu.Start( 1 )

	--Input.KeyBindDown(Keys.ModifierShift + Keys.F4, 		"LuaMainMenu.AltFFour()",2)

end

----------------------------------------------------------------------------------------------------
-- Called after game ended

function LuaMainMenu.Reinit()

	-- Stop stream
	Stream.Stop()

	-- Init save games
	LoadSaveGame.Init()

	-- Init controls
	OptionsControls_Menu.Init()

	-- Init Sound and display
	OptionsDisplay_Menu.Init()
	OptionsSound_Menu.Init()

	-- Start post game screen
	PGMenu.Start()

	-- Enable this for the demoversion
	-- Demo_Menu.Init()

	--Input.KeyBindDown(Keys.ModifierShift + Keys.F4, 		"KeyBindings_AltFFour()",2)

end


----------------------------------------------------------------------------------------------------
-- Global call backs
----------------------------------------------------------------------------------------------------
-- Callback that is executed to update progress bar

function GameCallback_UpdateProgressBar()

	-- Update network
	do

		-- Work on base network
		do

			-- Update base network if existing
			if XNetwork.Manager_DoesExist() == 1 then
				if XNetwork.Manager_Update() == 0 then
					return
				end
			end

		end


		-- Work on Ubi.com
		do

			-- Update Ubi.com if existing
			if XNetworkUbiCom.Manager_DoesExist() == 1 then
				XNetworkUbiCom.Manager_Update()
			end

		end

	end

end


----------------------------------------------------------------------------------------------------
--Function to end game by pressing ALT F4
function LuaMainMenu.AltFFour()
	StartMenu.OnEndGame()
end