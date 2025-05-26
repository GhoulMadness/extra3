----------------------------------
-- CUTSCENES
--
-- Map: 	01_Nuamon
-- Author: 	Ghoul
-- Status: 	done
----------------------------------

-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "NUAMON"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_Start()
	Cutscene_Nuamon_Init()
end
------------------------------------------------------------------------------------
------------------------------ Cutscene Data ---------------------------------------
function Cutscene_Nuamon_Text1()
	--empty
end
function Cutscene_Nuamon_Text2()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text1")
end
function Cutscene_Nuamon_Text3()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text1")
end
function Cutscene_Nuamon_Text4()
	--empty
end
function Cutscene_Nuamon_Text5()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text2")
end
function Cutscene_Nuamon_Text6()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text2")
end
function Cutscene_Nuamon_Text7()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text2")
end
function Cutscene_Nuamon_Text8()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text3")
end
function Cutscene_Nuamon_Text9()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text3")
end
function Cutscene_Nuamon_Text10()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_Nuamon_Text3")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_Finished()
	Cutscene_Nuamon_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_Cancel()
	Cutscene_Nuamon_End()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_SetView()
    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000, 10000)
    Display.SetRenderFog (1)
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Nuamon_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "KRATHOS"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Krathos_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Krathos_Start()
	Cutscene_Krathos_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Krathos_Text1()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text1")
end
function Cutscene_Krathos_Text2()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text2")
end
function Cutscene_Krathos_Text3()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Krathos_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Krathos_Cancel()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "KROXON"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Kroxon_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Kroxon_Start()
	Cutscene_Kroxon_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Kroxon_Text1()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text3")
end
function Cutscene_Kroxon_Text2()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text4")
end
function Cutscene_Kroxon_Text3()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text4")
end
function Cutscene_Kroxon_Text4()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text5")
end
function Cutscene_Kroxon_Text5()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text5")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Kroxon_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Kroxon_Cancel()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "DARKCITY"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_DarkCity_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_DarkCity_Start()
	Cutscene_DarkCity_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_DarkCity_Text1()
	--empty
end
function Cutscene_DarkCity_Text2()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text6")
end
function Cutscene_DarkCity_Text3()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text6")
end
function Cutscene_DarkCity_Text4()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text6")
end
function Cutscene_DarkCity_Text5()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text6")
end
function Cutscene_DarkCity_Text6()
	--empty
end
function Cutscene_DarkCity_Text7()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text7")
end
function Cutscene_DarkCity_Text8()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text7")
end
function Cutscene_DarkCity_Text9()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text7")
end
function Cutscene_DarkCity_Text10()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text7")
end
function Cutscene_DarkCity_Text11()
	--empty
end
function Cutscene_DarkCity_Text12()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text8")
end
function Cutscene_DarkCity_Text13()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text8")
end
function Cutscene_DarkCity_Text14()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text8")
end
function Cutscene_DarkCity_Text15()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text8")
end
function Cutscene_DarkCity_Text16()
	GUIAction_DisplayCinematicText("CM08_01_Nuamyr/Cutscene_DarkCity_Text8")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_DarkCity_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_DarkCity_Cancel()
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

