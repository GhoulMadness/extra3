----------------------------------
-- CUTSCENES
--
-- Map: 	08_Barmecia
-- Author: 	Ralf Angerbauer
-- Status: 	wip
----------------------------------


function Cheat_Intro_Start()
         Cutscene.Start("Intro")
end



function Cheat_Cutscene1_Start()
         Cutscene.Start("Cutscene1")
end



function Cheat_CutsceneComplete_Start()
         Cutscene.Start("CutsceneComplete")
end




-- Init scripting tables
-------------------------------------------------------------------------------------------------------------------------



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


function Cutscene_Intro_Text1()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text1")
end

function Cutscene_Intro_Text2()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text2")
	
end

function Cutscene_Intro_Text3()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text3")
	
end

function Cutscene_Intro_Text4()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text4")
	
end

function Cutscene_Intro_Text5()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text5")
	
end

function Cutscene_Intro_Text6()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text6")
	
end

function Cutscene_Intro_Text7()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Intro_Text7")
	
end

-------------------------------------------------------------------------------------------------------------------------


function Cutscene_Intro_Finished()
	 Cutscene_Intro_End()


--	 Mission_EndMovie()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Cancel()
 
	 Cutscene_Intro_End()

	  
--	 Mission_EndMovie()
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


-----------------------------------------------------------------------------------------------------------------------	
--
--	CUTSCENE: "Cutscene1"
--
-----------------------------------------------------------------------------------------------------------------------	

function Cutscene_Cutscene1_Init()
	 Mission_InitMovie()    
end


-------------------------------------------------------------------------------------------------------------------------


function Cutscene_Cutscene1_Start()
	 Cutscene_Cutscene1_Init()
		   
              
end



-------------------------------------------------------------------------------------------------------------------------

function Cutscene_Cutscene1_Finished()
	 Mission_EndMovie()
	 	  
	 
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Cutscene1_Cancel()
	 Mission_EndMovie()
	 
end





function Cutscene_Cutscene1_Text1()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text1")
	
end


function Cutscene_Cutscene1_Text2()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text2")
	
end

function Cutscene_Cutscene1_Text3()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text3")
	
end


function Cutscene_Cutscene1_Text4()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text4")
	
end


function Cutscene_Cutscene1_Text5()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text5")
	
end


function Cutscene_Cutscene1_Text6()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cutscene1_Text6")
	
end

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


function Cutscene_Barmecia_Start()
	 Mission_InitMovie()     
end

-------------------------------------------------------------------------------------------------------------------------

function Cutscene_Barmecia_Finished()
	 Mission_EndMovie()
end

-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Barmecia_Cancel()
	 Mission_EndMovie()
end

function Cutscene_Barmecia_Text1()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Barmecia_Text1")
end


-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

function Cutscene_Cleycourt_Start()
	 Mission_InitMovie()     
end

-------------------------------------------------------------------------------------------------------------------------

function Cutscene_Cleycourt_Finished()
	 Mission_EndMovie()
end

-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Cleycourt_Cancel()
	 Mission_EndMovie()
end

function Cutscene_Cleycourt_Text1()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Cleycourt_Text1")
end



-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------	
--
--	EXTRO-CUTSCENE: "CutsceneComplete"
--
-----------------------------------------------------------------------------------------------------------------------	

  function Cutscene_CutsceneComplete_Start()
	   Mission_InitMovie()    

			
end	 


function Cutscene_CutsceneComplete_Text1()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text1")
	
end



function Cutscene_CutsceneComplete_Text2()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text2")
	
end




function Cutscene_CutsceneComplete_Text3()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text3")
	
end



function Cutscene_CutsceneComplete_Text4()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text4")
	
end



function Cutscene_CutsceneComplete_Text5()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text5")
	
end



function Cutscene_CutsceneComplete_Text6()
	 SpokenCinematicText("CM01_08_Barmecia_Txt/Cutscene_Extro_Text6")
	
end
-------------------------------------------------------------------------------------------------------------------------


function Cutscene_CutsceneComplete_Finished()
	Mission_EndMovie()	
end


-------------------------------------------------------------------------------------------------------------------------


function Cutscene_CutsceneComplete_Cancel()
	Mission_EndMovie()	
end


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

