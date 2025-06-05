----------------------------------
-- CUTSCENES
--
-- Map: 	Village Attack
-- Author: 	Thomas Friedmann
-- Status: 	finished
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



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Finished()
	Cutscene_Intro_End()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Cancel()
	Cutscene_Intro_End()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_Text1()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Intro_Text1")
end


function Cutscene_Intro_Text2()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Intro_Text2")
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_SetView()
    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000, 10000)
    Display.SetRenderFog (1)
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_End()

	for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2), CEntityIterator.IsSettlerOrBuildingFilter()) do
		Logic.SetEntitySelectableFlag(eID, 0)
		Logic.SetEntityUserControlFlag(eID, 0)
		if Logic.IsBuilding(eID) == 1 then
			ChangeHealthOfEntity(eID, math.random(20*gvDiffLVL, 30 + 10*gvDiffLVL))
		end
	end
	Mission_EndMovie()

end

-----------------------------------------------------------------------------------------------------------------------
--
--	CUTSCENE: "THIEF"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_Init()
	do
		local id, tbi, e = nil, table.insert, {};
		id = Logic.CreateEntity(Entities.CU_Thief, 31454.27, 40786.93, 270.00, 8);tbi(e,id);Logic.SetEntityName(id, "scene_thief")
		Logic.MoveSettler(id, 41000, 38000)
	end
	Mission_InitMovie()
end


-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_Start()
	Cutscene_Thief_Init()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_Finished()
	Cutscene_Thief_End()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_Cancel()
	Cutscene_Thief_End()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_Text1()

end


function Cutscene_Thief_Text2()

end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_SetView()
    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000, 10000)
    Display.SetRenderFog (1)
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Thief_End()

	DestroyEntity("scene_thief")
	Mission_EndMovie()

end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Intro_CreateArmySiege()

	StartSimpleJob("VillagesFreed")
	createArmySiegeWest = function()

	--	set up

		armySiegeWest				= {}

		armySiegeWest.player 		= 7
		armySiegeWest.id			= 0
		armySiegeWest.strength		= 5 - round(gvDiffLVL)
		armySiegeWest.position		= GetPosition("siege")
		armySiegeWest.rodeLength	= 1000

		SetupArmy(armySiegeWest)

	end

	-------------------------------------------------------------------------------------------------------------------
	Condition_ControlArmySiegeWest = function()
	-------------------------------------------------------------------------------------------------------------------

		return Counter.Tick2("ControlArmySiegeWest",3)

	end

	-------------------------------------------------------------------------------------------------------------------
	Action_ControlArmySiegeWest = function()
	-------------------------------------------------------------------------------------------------------------------

		if IsDead(armySiegeWest) then

			armySiegeWestDefeated()
			return true

		end

		FrontalAttack(armySiegeWest)

		return false

	end
	createArmySiegeEast = function()

	--	set up

		armySiegeEast				= {}

		armySiegeEast.player 		= 7
		armySiegeEast.id			= 1
		armySiegeEast.strength		= 5 - round(gvDiffLVL)
		armySiegeEast.position		= GetPosition("eastattack")
		armySiegeEast.rodeLength	= 1000

		SetupArmy(armySiegeEast)

	end

	-------------------------------------------------------------------------------------------------------------------
	Condition_ControlArmySiegeEast = function()
	-------------------------------------------------------------------------------------------------------------------

		return Counter.Tick2("ControlArmySiegeEast",3)

	end

	-------------------------------------------------------------------------------------------------------------------
	Action_ControlArmySiegeEast = function()
	-------------------------------------------------------------------------------------------------------------------

		if IsDead(armySiegeEast) then

			armySiegeEastDefeated()
			return true

		end

		FrontalAttack(armySiegeEast)

		return false

	end
-----------------------------------------------------------------------------------------------------------------------
	createArmySiegeWest()
	createArmySiegeEast()
-- create siege army
	local troopDescription = {

		maxNumberOfSoldiers	= 5 - round(gvDiffLVL),
		minNumberOfSoldiers	= 0,
		experiencePoints 	= 0 + math.floor(gvDiffLVL),
	}

	troopDescription.leaderType = Entities.CU_BlackKnight_LeaderMace1
--		troopDescription.leaderType = Entities.PU_LeaderSword1

	for i = 1, 5 - round(gvDiffLVL) do
		EnlargeArmy(armySiegeWest,troopDescription)
		EnlargeArmy(armySiegeEast,troopDescription)
	end

	StartJob("ControlArmySiegeWest")
	StartJob("ControlArmySiegeEast")


-- Move defender
	for i=0,8,1 do

		if IsAlive("defender"..i) then

			local defender = Logic.GetEntityIDByName("defender"..i)

			Logic.SetEntitySelectableFlag("defender"..i, 0)
			Logic.SetEntityUserControlFlag("defender"..i, 0)

			Logic.SettlerDefend(defender)

			Move("defender"..i,"defenderTarget"..i)

		end
	end

end


-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

function Cutscene_Mother_Dies_Start()
	Mission_InitMovie()
end


-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Mother_Dies_Finished()
	Cutscene_Mother_Dies_End()
end


-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Mother_Dies_Cancel()
	Cutscene_Mother_Dies_End()
end


-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Mother_Dies_SetView2()
    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000, 10000)
    Display.SetRenderFog (1)
end


-------------------------------------------------------------------------------------------------------------------------
function Cutscene_Mother_Dies_End()
	Logic.StopPrecipitation()

	Mission_EndMovie()

end

-----------------------------------------------------------------------------------------------------------------------
--
--	EXTRO-CUTSCENE: "MissionComplete"
--
-----------------------------------------------------------------------------------------------------------------------
function Cutscene_MissionComplete_Init()

	Logic.DestroyEntity(Logic.GetEntityIDByName("Erec"))
	Logic.DestroyEntity(Logic.GetEntityIDByName("Dario"))

       CreateEntity(1, Entities.PU_Hero4, GetPosition("VictoryErec"), "Erec" )
       CreateEntity(1, Entities.PU_Hero1a, GetPosition("VictoryDario"), "Dario" )

       LookAt("Dario","Erec")
       LookAt("Erec","Dario")
end

function Cutscene_MissionComplete_Move()

	Move("Erec", "VictoryErecMove")
	Move("Dario", "VictoryDarioMove")
end
-------------------------------------------------------------------------------------------------------------------------
function Cutscene_MissionComplete_Start()
	Mission_InitMovie()
end

-------------------------------------------------------------------------------------------------------------------------
function Cutscene_MissionComplete_Finished()

	Logic.DestroyEntity(Logic.GetEntityIDByName("Erec"))
	Logic.DestroyEntity(Logic.GetEntityIDByName("Dario"))

	Mission_EndMovie()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_MissionComplete_Cancel()

	Logic.DestroyEntity(Logic.GetEntityIDByName("Erec"))
	Logic.DestroyEntity(Logic.GetEntityIDByName("Dario"))

	Mission_EndMovie()
end



-------------------------------------------------------------------------------------------------------------------------
function Cutscene_MissionComplete_Text1()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text1")

end


function Cutscene_MissionComplete_Text2()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text2")

end

function Cutscene_MissionComplete_Text3()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text3")

end


function Cutscene_MissionComplete_Text4()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text4")

end

function Cutscene_MissionComplete_Text5()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text5")

end

function Cutscene_MissionComplete_Text6()
	SpokenCinematicText("CM01_02_VillageAttack_Txt/Cutscene_Extro_Text6")

end

--*********************************************************************************************
function Mission_InitMovie()

    Display.SetFogStartAndEnd (5000, 15000)
    Display.SetRenderFog (1)
	Display.SetFarClipPlaneMinAndMax(0, 16000)

	Logic.StopPrecipitation()
	Interface_SetCinematicMode(1)

end


function Mission_EndMovie()
	-- disable Cutscene mode

	Interface_SetCinematicMode(0)
	Display.SetFarClipPlaneMinAndMax(0, 0)

	Logic.StopPrecipitation()

	CutsceneDone()

end
