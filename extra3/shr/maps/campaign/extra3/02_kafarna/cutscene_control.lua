----------------------------------
-- CUTSCENES
--
-- Map: 	02_Kafarna
-- Author: 	Ghoul
-- Status: 	complete
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
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Intro_Text2")
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
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Outro_Text1")
end
function Cutscene_Outro_Text2()
	GUIAction_DisplayCinematicText("CM09_02_Kafarna/Cutscene_Outro_Text2")
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

