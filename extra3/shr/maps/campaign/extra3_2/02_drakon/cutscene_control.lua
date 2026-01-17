----------------------------------
-- CUTSCENES
--
-- Map: 	02_Drakon
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
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Text1()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text5()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text6()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text7()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text8()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text9()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text10()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text11()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Intro_Text3")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Cancel()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "DRAKON"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Drakon_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Drakon_Start()
	Cutscene_Drakon_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Drakon_Text1()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text1")
end
function Cutscene_Drakon_Text2()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text1")
end
function Cutscene_Drakon_Text3()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text2")
end
function Cutscene_Drakon_Text4()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text2")
end
function Cutscene_Drakon_Text5()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text3")
end
function Cutscene_Drakon_Text6()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text3")
end
function Cutscene_Drakon_Text7()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Drakon_Text3")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Drakon_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Drakon_Cancel()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "EHERNBERG"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Ehernberg_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Ehernberg_Start()
	Cutscene_Ehernberg_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Ehernberg_Text1()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Ehernberg_Text1")
end
function Cutscene_Ehernberg_Text2()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Ehernberg_Text1")
end
function Cutscene_Ehernberg_Text3()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Ehernberg_Text2")
end
function Cutscene_Ehernberg_Text4()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Ehernberg_Text2")
end
function Cutscene_Ehernberg_Text5()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Ehernberg_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Ehernberg_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Ehernberg_Cancel()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "GUELDFURT"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_Start()
	Cutscene_Gueldfurt_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Gueldfurt_Text1()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text1")
end
function Cutscene_Gueldfurt_Text2()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text1")
end
function Cutscene_Gueldfurt_Text3()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text1")
end
function Cutscene_Gueldfurt_Text4()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text2")
end
function Cutscene_Gueldfurt_Text5()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text2")
end
function Cutscene_Gueldfurt_Text6()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Gueldfurt_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_Finished()
	Cutscene_Gueldfurt_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_Cancel()
	Cutscene_Gueldfurt_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_SetView()

end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Gueldfurt_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "HOHENBERGE"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Hohenberge_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Hohenberge_Start()
	Cutscene_Hohenberge_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Hohenberge_Text1()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text1")
end
function Cutscene_Hohenberge_Text2()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text1")
end
function Cutscene_Hohenberge_Text3()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text1")
end
function Cutscene_Hohenberge_Text4()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text2")
end
function Cutscene_Hohenberge_Text5()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text2")
end
function Cutscene_Hohenberge_Text6()
	GUIAction_DisplayCinematicText("CM08_02_Drakon/Cutscene_Hohenberge_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Hohenberge_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Hohenberge_Cancel()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--*********************************************************************************************
function Mission_InitMovie()
	Display.SetRenderUseGfxSets(0)
	Display.SetFogStartAndEnd(500, 60000)
	Display.SetFarClipPlaneMinAndMax(0, 60000)
	Interface_SetCinematicMode(1)

end
function Mission_EndMovie()
	Display.SetRenderUseGfxSets(1)
	Interface_SetCinematicMode(0)
	Display.SetFarClipPlaneMinAndMax(0, 0)

	CutsceneDone()
end

