----------------------------------
-- CUTSCENES
--
-- Map: 	05_DreadMountains
-- Author: 	Ghoul
-- Status: 	done
----------------------------------

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
	--empty
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM08_05_DreadMountains/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM08_05_DreadMountains/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM08_05_DreadMountains/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text5()
	GUIAction_DisplayCinematicText("CM08_05_DreadMountains/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text6()
	GUIAction_DisplayCinematicText("CM08_05_DreadMountains/Cutscene_Intro_Text2")
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
    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000, 10000)
    Display.SetRenderFog (1)
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_End()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--*********************************************************************************************
function Mission_InitMovie()

	--[[SetInternalClippingLimitMax(40000)
	normales Limit liegt bei 20.000
	Display.SetFogStartAndEnd (35000, 40000)
	Display.SetRenderFog (1)]]
	Display.SetFarClipPlaneMinAndMax(0, 20000)
	Display.GfxSetSetFogParams(7, 0.0, 1.0, 1, 152,172,182, 2500,22000)
	Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152,172,182, 2500,22000)
	Interface_SetCinematicMode(1)

end
function Mission_EndMovie()

	Display.SetRenderUseGfxSets(1)
	Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152,172,182, 5000,32000)
	Display.GfxSetSetFogParams(7, 0.0, 1.0, 1, 152,172,182, 3500,32000)
	Interface_SetCinematicMode(0)
	Display.SetFarClipPlaneMinAndMax(0, 0)

	CutsceneDone()
end

