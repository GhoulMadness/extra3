initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not initEMS() then
	local errMsgs =
	{
		["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr \195\156berpr\195\188fe ob alle Dateien am richtigen Ort sind!",
		["eng"] = "Attention: Enhanced Multiplayer Script could not be found! @cr Make sure you placed all the files in correct place!",
	}
	local lang = "de";
	if XNetworkUbiCom then
		lang = XNetworkUbiCom.Tool_GetCurrentLanguageShortName();
		if lang ~= "eng" and lang ~= "de" then
			lang = "eng";
		end
	end
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	GUI.AddStaticNote("@color:255,0,0 " .. errMsgs[lang]);
	GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
	return;
end
gvEMSFlag = 1
EMS_CustomMapConfig =
{

	Version = 1.1,

	Callback_OnMapStart = function()

	Script.Load(Folders.MapTools.."Ai\\Support.lua")
	Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua" )
	Script.Load( "Data\\Script\\MapTools\\Tools.lua" )
	Script.Load( "Data\\Script\\MapTools\\WeatherSets.lua" )
	IncludeGlobals("Comfort")
	Script.Load( Folders.MapTools.."Main.lua" )
	IncludeGlobals("MapEditorTools")
	Script.Load( "Data\\Script\\MapTools\\Counter.lua" )

	IncludeGlobals("Tools\\BSinit")

	-- custom Map Stuff

	TagNachtZyklus(34,1,0,-2,1)

	MultiplayerTools.InitCameraPositionsForPlayers()

	for i = 1,8 do
		CreateWoodPile("Holz"..i,10000000)
	end

	LocalMusic.UseSet = MEDITERANEANMUSIC
	for i = 1, 5 do
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i));
	end;
	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,5,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end


	end,

	Callback_OnGameStart = function()
		SetFriendly(1,2)
		SetFriendly(1,3)
		SetFriendly(1,4)
		SetFriendly(2,3)
		SetFriendly(2,4)
		SetFriendly(3,4)
		SetHostile(5,1)
		SetHostile(5,2)
		SetHostile(5,3)
		SetHostile(5,4)
		Display.SetPlayerColorMapping(6,ROBBERS_COLOR)
		Display.SetPlayerColorMapping(7,ROBBERS_COLOR)
		Display.SetPlayerColorMapping(8,ROBBERS_COLOR)

		CreateArmy1()
		MapEditor_SetupAI(6,1,7000,1,"P6",1,0)
		MapEditor_SetupAI(7,1,7500,1,"P7",1,0)
		MapEditor_SetupAI(8,1,13000,1,"P8",1,0)
		SetFriendly(5,6)
		SetFriendly(5,7)
		SetFriendly(5,8)
		SetHostile(1,6)
		SetHostile(2,6)
		SetHostile(3,6)
		SetHostile(4,6)
		SetHostile(5,1)
		SetHostile(5,2)
		SetHostile(5,3)
		SetHostile(5,4)
		SetHostile(7,1)
		SetHostile(7,2)
		SetHostile(7,3)
		SetHostile(7,4)
		SetHostile(8,1)
		SetHostile(8,2)
		SetHostile(8,3)
		SetHostile(8,4)
		ActivateShareExploration(5,6,true)
		ActivateShareExploration(5,7,true)
		ActivateShareExploration(5,8,true)
		AddGold(5,1000)
		AddClay(5,1000)
		AddWood(5,1000)
		AddStone(5,1000)
		for i = 1,5 do
			ForbidTechnology(Technologies.T_MakeSnow, i);
		end
		for j = 1,4 do
			ResearchTechnology(Technologies.B_Barracks, j)
		end
		--
		StartCountdown(30*60,UpgradeKIa,false)
	end,
	Callback_OnPeacetimeEnded = function()
		StartWinter(20*60*60)
		for i=1,5 do
			AllowTechnology(Technologies.T_MakeSnow, i);
		end
		for i = 6,8 do
			MapEditor_Armies[i].offensiveArmies.strength = MapEditor_Armies[i].offensiveArmies.strength + 10
			MapEditor_Armies[i].offensiveArmies.rodeLength = Logic.WorldGetSize()
			ResearchAllTechnologies(i, false, false, false, true, false)
		end
	end,
	Peacetime = 50,

	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 2,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1
};


function UpgradeKIa()
	for i = 6,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)

		ResearchTechnology(Technologies.T_SoftArcherArmor,i)
		ResearchTechnology(Technologies.T_LeatherMailArmor,i)

		StartCountdown(20*60,UpgradeKIb,false)
	end
end
function UpgradeKIb()
	for i = 6,8 do
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierPoleArm,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierBow,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierSword,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierRifle,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.LeaderHeavyCavalry,i)
		Logic.UpgradeSettlerCategory(UpgradeCategories.SoldierHeavyCavalry,i)
	end
end


function CreateArmy1()

	army1	 = {}

	army1.player 		= 6
	army1.id			= 1
	army1.strength		= 3
	army1.position		= GetPosition("P6army1")
	army1.rodeLength	= 2000

	SetupArmy(army1)

	local troopDescription = {

		maxNumberOfSoldiers	= 4,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= LOW_EXPERIENCE,
		leaderType        	= Entities.CU_BanditLeaderBow1
	}

	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)
	EnlargeArmy(army1,troopDescription)

	StartSimpleJob("ControlArmy1")

end

function CreateArmyTwo()

	armyTwo	 = {}

	armyTwo.player 		= 6
	armyTwo.id			= 2
	armyTwo.strength	= 2
	armyTwo.position	= GetPosition("P6army1")
	armyTwo.rodeLength	= 2000

	SetupArmy(armyTwo)


	local troopDescription = {

		maxNumberOfSoldiers	= 8,
		minNumberOfSoldiers	= 0,
		experiencePoints 	= HIGH_EXPERIENCE,
		leaderType         	= Entities.CU_BanditLeaderSword2
	}

	EnlargeArmy(armyTwo,troopDescription)
	EnlargeArmy(armyTwo,troopDescription)

	StartSimpleJob("ControlArmyTwo")

end
function ControlArmy1()

    if IsDead(army1) and IsExisting("P6Turm") then

        CreateArmyTwo()
        return true

    else
        Defend(army1)

    end

end

function ControlArmyTwo()

	if IsDead(armyTwo) and IsExisting("P6Turm") then

		CreateArmy1()
		return true
	else

		Defend(armyTwo)

	end

end
 