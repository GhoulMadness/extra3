----------------------------------
-- CUTSCENES
--
-- Map: 	01_Journey
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
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text5()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text6()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text7()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text8()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text4")
end
function Cutscene_Intro_Text9()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text4")
end
function Cutscene_Intro_Text10()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Intro_Text4")
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
--	CUTSCENE: "LARINA"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_Start()
	Cutscene_Larina_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Larina_Text1()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Larina_Text1")
end
function Cutscene_Larina_Text2()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Larina_Text1")
end
function Cutscene_Larina_Text3()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Larina_Text2")
end
function Cutscene_Larina_Text4()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Larina_Text2")
end
function Cutscene_Larina_Text5()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Larina_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_Finished()
	Cutscene_Larina_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_Cancel()
	Cutscene_Larina_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Larina_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "EASTERNSIDE"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_Start()
	Cutscene_Larina_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_EasternSide_Text1()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_EasternSide_Text1")
end
function Cutscene_EasternSide_Text2()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_EasternSide_Text2")
end
function Cutscene_EasternSide_Text3()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_EasternSide_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_Finished()
	Cutscene_EasternSide_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_Cancel()
	Cutscene_EasternSide_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_SetView()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_EasternSide_End()
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
	Cutscene_Larina_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Outro_Text1()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Outro_Text1")
end
function Cutscene_Outro_Text2()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Outro_Text2")
end
function Cutscene_Outro_Text3()
	GUIAction_DisplayCinematicText("CM09_01_Journey/Cutscene_Outro_Text2")
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

