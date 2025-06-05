----------------------------------
-- CUTSCENES
--
-- Map: 	04_NorthernSea
-- Author: 	Ghoul
-- Status: 	done
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
	--empty
end
function Cutscene_Intro_Text2()
	GUIAction_DisplayCinematicText("CM08_04_NorthernSea/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM08_04_NorthernSea/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM08_04_NorthernSea/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text5()
	GUIAction_DisplayCinematicText("CM08_04_NorthernSea/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text6()
	GUIAction_DisplayCinematicText("CM08_04_NorthernSea/Cutscene_Intro_Text3")
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

