----------------------------------
-- CUTSCENES
--
-- Map: 	03_Keshet
-- Author: 	Ghoul
-- Status: 	in_progress
----------------------------------
SetAdvancedCutsceneClipping()
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "INTRO"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Start()
	Cutscene_Intro_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Intro_Text1()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Intro_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Finished()
	Cutscene_Intro_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Cancel()
	Cutscene_Intro_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "WATCHTOWER"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_Start()
	Cutscene_Watchtower_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Watchtower_Text1()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Watchtower_Text1")
end
function Cutscene_Watchtower_Text2()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Watchtower_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_Finished()
	Cutscene_Watchtower_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_Cancel()
	Cutscene_Watchtower_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Watchtower_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "WATERFALL"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_Start()
	Cutscene_Waterfall_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Waterfall_Text1()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Waterfall_Text1")
end
function Cutscene_Waterfall_Text2()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Waterfall_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_Finished()
	Cutscene_Waterfall_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_Cancel()
	Cutscene_Waterfall_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Waterfall_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "BEGONA"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_Start()
	Cutscene_Begona_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Begona_Text1()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Begona_Text1")
end
function Cutscene_Begona_Text2()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Begona_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_Finished()
	Cutscene_Begona_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_Cancel()
	Cutscene_Begona_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Begona_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "OUTRO"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Start()
	Cutscene_Outro_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Outro_Text1()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Outro_Text1")
end
function Cutscene_Outro_Text2()
	GUIAction_DisplayCinematicText("CM09_03_Keshet/Cutscene_Outro_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Finished()
	Cutscene_Outro_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Cancel()
	Cutscene_Outro_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_End()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--*********************************************************************************************
function Mission_InitMovie()

	--local currGFX = GetCurrentWeatherGfxSet()
	--local dummyGFX = 99
	--Display.GfxSetCloneFogParams(dummyGFX, currGFX)
	Display.SetRenderUseGfxSets(0)
	--Display.SetRenderFog(0)
	Display.SetFogStartAndEnd(500, 60000)
	Display.SetFarClipPlaneMinAndMax(0, 60000)
	Interface_SetCinematicMode(1)

end
function Mission_EndMovie()

	--local currGFX = GetCurrentWeatherGfxSet()
	--local dummyGFX = 99
	--Display.GfxSetCloneFogParams(currGFX, dummyGFX)
	Display.SetRenderUseGfxSets(1)
	--Display.SetRenderFog(1)
	Interface_SetCinematicMode(0)
	Display.SetFarClipPlaneMinAndMax(0, 0)

	CutsceneDone()
end

