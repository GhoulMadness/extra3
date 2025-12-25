----------------------------------
-- CUTSCENES
--
-- Map: 	03_Kralmountains
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
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Intro_Text1")
end
function Cutscene_Intro_Text3()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Intro_Text2")
end
function Cutscene_Intro_Text4()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Intro_Text3")
end
function Cutscene_Intro_Text5()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Intro_Text3")
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
    --Display.SetFogColor (152,172,182)
	--Display.SetFogStartAndEnd (5000, 10000)
    --Display.SetRenderFog (1)
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_End()
	Mission_EndMovie()
end
-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "FiresOn"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_FiresOn_Init()
	Mission_InitMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_FiresOn_Start()
	Cutscene_FiresOn_Init()
end
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_FiresOn_Text1()
	--empty
	--GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	oldvol = Music.GetVolumeAdjustment()
	Music.SetVolumeAdjustment(oldvol*3)
	Music.Stop()
	Sound.PauseAll()
	--Music.Start("music\\lotr_lighting_the_fires.mp3"  , 120, 0)
	Stream.Start("music\\lotr_lighting_the_fires.mp3"  , 120)
	StartCountdown(2, function() ReplaceEntity("fire1", Entities.XD_SingnalFireOn) end, false)
	StartCountdown(5, function() ReplaceEntity("fire4", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard1", "fire1")
	StartCountdown(2, function() Move("fire_guard4", "fire4") end, false)
end
function Cutscene_FiresOn_Text2()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	StartCountdown(3, function() ReplaceEntity("fire2", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard2", "fire2")
end
function Cutscene_FiresOn_Text3()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	StartCountdown(3, function() ReplaceEntity("fire3", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard3", "fire3")
end
function Cutscene_FiresOn_Text4()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
end
function Cutscene_FiresOn_Text5()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
end
function Cutscene_FiresOn_Text6()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	StartCountdown(3, function() ReplaceEntity("fire5", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard5", "fire5")
end
function Cutscene_FiresOn_Text7()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	StartCountdown(3, function() ReplaceEntity("fire6", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard6", "fire6")
end
function Cutscene_FiresOn_Text8()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
end
function Cutscene_FiresOn_Text9()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
end
function Cutscene_FiresOn_Text10()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	Move("fire_guard7", "fire7")
	StartCountdown(3, function() ReplaceEntity("fire7", Entities.XD_SingnalFireOn) end, false)
end
function Cutscene_FiresOn_Text11()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_FiresOn_Text1")
	StartCountdown(3, function() ReplaceEntity("fire8", Entities.XD_SingnalFireOn) end, false)
	Move("fire_guard8", "fire8")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_FiresOn_Finished()
	Music.SetVolumeAdjustment(oldvol)
	LocalMusic.SongLength = Logic.GetTime()
	LocalMusic_UpdateMusic()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_FiresOn_Cancel()
	Music.SetVolumeAdjustment(oldvol)
	LocalMusic.SongLength = Logic.GetTime()
	LocalMusic_UpdateMusic()
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
--------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Text1()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Outro_Text1")
end
function Cutscene_Outro_Text2()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Outro_Text1")
end
function Cutscene_Outro_Text3()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Outro_Text2")
end
function Cutscene_Outro_Text4()
	GUIAction_DisplayCinematicText("CM08_03_Kralmountains/Cutscene_Outro_Text2")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Finished()
	Mission_EndMovie()
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Outro_Cancel()
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

