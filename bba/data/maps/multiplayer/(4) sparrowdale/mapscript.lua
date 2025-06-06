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
-- ************************************************************************************************
-- *                                                                                              *
-- *                                                                                              *
-- *                                              EMS                                             *
-- *                                         CONFIGURATION                                        *
-- *                                                                                              *
-- *                                                                                              *
-- ************************************************************************************************

EMS_CustomMapConfig = {
    -- ********************************************************************************************
    -- * Configuration File Version
    -- * A version check will make sure every player has the same version of the configuration file
    -- ********************************************************************************************
    Version = 1.1,

    -- ********************************************************************************************
    -- * Callback_OnMapStart
    -- * Called directly after the loading screen vanishes and works as your entry point.
    -- * Similar use to FirstMapAction/GameCallback_OnGameSart
    -- ********************************************************************************************

    Callback_OnMapStart = function()
		IncludeGlobals("Tools\\BSinit")
		TagNachtZyklus(24,1,0,-1,1)
        LocalMusic.UseSet = DARKMOORMUSIC;

        StartSimpleJob("OutpostPitFiller");
        MakeBlockRocksInvisible();
        CreateWoodpilesForPlayers();

        Display.SetPlayerColorMapping(7, 14);
        Display.SetPlayerColorMapping(8, 14);

		for i= 1, 4 do
            VictoryConditionQuestDomincance(i);
            VictoryConditionQuestTactical(i);
            VictoryConditionQuestThievery(i);
        end
        -- Deliver resource to the players
        function GameCallback_User_OutpostProduceResource(_ScriptName, _SpawnPoint, _OwningTeam, _ResourceType, _Amount)
			if _OwningTeam == 0 then
                return;
            end
            local Sender = WT2022.Outpost.Teams[_OwningTeam].Deliverer;
            local TeamData = WT2022.Outpost.Teams[_OwningTeam];
            local Amount1 = (IsExisting("HQ" ..TeamData[2]) and _Amount/2) or _Amount;
            local Amount2 = (IsExisting("HQ" ..TeamData[1]) and _Amount/2) or _Amount;
            if IsExisting("HQ" ..TeamData[1]) then
                WT2022.Delivery.SendCart(Sender, TeamData[1], _SpawnPoint, _ResourceType, Amount1);
            end
            if IsExisting("HQ" ..TeamData[2]) then
                WT2022.Delivery.SendCart(Sender, TeamData[2], _SpawnPoint, _ResourceType, Amount2);
            end
        end

        -- A resource has been stohlen
        function GameCallback_User_PlayerStoleResource(_Receiver, _Team, _ResourceType, _Amount)
            WT2022.Victory.RegisterTheft(_Team, _Amount);
        end

        -- An outpost was claimed
        function GameCallback_User_OutpostClaimed(_ScriptName, _OldPlayer, _NewPlayer, _TeamOfCapturer, _OutpostPlayerID)
            GUIQuestTools.ToggleStopWatch(0, 0);
            WT2022.Victory.SetTimer(-1);
            WT2022.Victory.RegisterClaim(_NewPlayer, _ScriptName);
            if WT2022.Victory:DoesOneTeamControllAllOutposts() then
                GUIQuestTools.ToggleStopWatch(5*60, 1);
                WT2022.Victory.SetTimer(5*60);
            end
            WT2022.Victory:CreateCompensationHeap(_ScriptName, _OldPlayer, _NewPlayer);
        end

        -- Upgrade of outpost has started
        function GameCallback_User_OutpostUpgradeStarted(_ScriptName, _UpgradeType, _NextUpgradeLevel)
            OnOutpostUpgradeStarted(_ScriptName, _UpgradeType, _NextUpgradeLevel);
        end

        -- Upgrade of outpost has finished
        function GameCallback_User_OutpostUpgradeFinished(_ScriptName, _UpgradeType, _NewUpgradeLevel)
            OnOutpostUpgradeFinished(_ScriptName, _UpgradeType, _NewUpgradeLevel);
        end

        -- A player was defeated
        function GameCallback_User_PlayerDefeated(_PlayerID, _Team)
            if not WT2022.Victory.Teams[_Team] then
                return;
            end

            -- change outpost player
            local NewPlayer = 7;
            for i= 1, 8 do
                if Logic.EntityGetPlayer(GetID("OP" ..i)) == _PlayerID then
                    WT2022.Outpost.Claim("OP" ..i, NewPlayer);
                    WT2022.Victory.RegisterClaim(NewPlayer, "OP" ..i);
                    WT2022.Outpost:EnlargeGuardianArmy("OP" ..i);
                end
            end

            -- standard victory condition
            if  Logic.PlayerGetGameState(WT2022.Victory.Teams[_Team][1]) > 1
            and Logic.PlayerGetGameState(WT2022.Victory.Teams[_Team][2]) > 1 then
                local OtherTeam = (_Team == 1 and 2) or 1;
                Logic.PlayerSetGameStateToWon(WT2022.Victory.Teams[OtherTeam][1]);
                Logic.PlayerSetGameStateToWon(WT2022.Victory.Teams[OtherTeam][2]);
            end
        end
    end,

    -- ********************************************************************************************
    -- * Callback_OnGameStart
    -- * Called at the end of the 10 seconds delay, after the host chose the rules and started
    -- ********************************************************************************************
    Callback_OnGameStart = function()
		function gvLightning.Damage(_posX,_posY,_range,_damage,_buildingdamage)

			for eID in CEntityIterator.Iterator(CEntityIterator.OfAnyPlayerFilter(1,2,3,4), CEntityIterator.IsSettlerOrBuildingFilter(), CEntityIterator.InCircleFilter(_posX, _posY, _range)) do

				-- wenn Serf, dann...
				if Logic.IsSerf(eID) == 1 then
					Logic.HurtEntity(eID, _damage)
				-- wenn Held oder Kanone, dann...
				elseif Logic.IsHero(eID) == 1 or Logic.IsEntityInCategory(eID, EntityCategories.Cannon) == 1 then
					if Logic.IsEntityAlive(eID) then
						local damage = _damage + math.floor(Logic.GetEntityMaxHealth(eID) * 0.8)
						if ExtendedStatistics then
							if damage >= Logic.GetEntityHealth(eID) then
								ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning + 1
							end
							ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning + damage
						end
						Logic.HurtEntity(eID, damage)
					end
				-- wenn Leader, dann...
				elseif Logic.IsLeader(eID) == 1 and Logic.IsHero(eID) == 0 and Logic.IsSettler(eID) == 1 then
					local Soldiers = {Logic.GetSoldiersAttachedToLeader(eID)}
					if Soldiers[1] > 0 then
						for i = 2, math.floor(Soldiers[1]/2) do
							if ExtendedStatistics then
								ExtendedStatistics.Players[Logic.EntityGetPlayer(Soldiers[i])].UnitsLostThroughLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(Soldiers[i])].UnitsLostThroughLightning + 1
								ExtendedStatistics.Players[Logic.EntityGetPlayer(Soldiers[i])].DamageTakenByLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(Soldiers[i])].DamageTakenByLightning + Logic.GetEntityHealth(Soldiers[i])
							end
							ChangeHealthOfEntity(Soldiers[i],0)
						end
					else
						local damage = _damage + math.floor(Logic.GetEntityMaxHealth(eID) * 0.6)
						if ExtendedStatistics then
							if damage >= Logic.GetEntityHealth(eID) then
								ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning + 1
							end
							ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning + damage
						end
						Logic.HurtEntity(eID, damage)
					end
				-- wenn Gebäude, dann...
				elseif Logic.IsBuilding(eID) == 1 then
					if gvLightning.IsLightningProofBuilding(eID) ~= true then
						if Logic.IsConstructionComplete(eID) == 1 then
							local PID = Logic.EntityGetPlayer(eID)
							if gvLightning.RodProtected[PID] == false then
								if ExtendedStatistics then
									ExtendedStatistics.Players[PID].DamageTakenByLightning = ExtendedStatistics.Players[PID].DamageTakenByLightning + _buildingdamage
								end
								Logic.HurtEntity(eID, _buildingdamage)
								if Logic.GetTechnologyState(PID,Technologies.T_LightningInsurance) == 4 then
									if _buildingdamage ~= nil then
										local InsuranceCash = math.floor(_buildingdamage)
										Logic.AddToPlayersGlobalResource(PID,ResourceType.GoldRaw,InsuranceCash)
										if GUI.GetPlayerID() == PID then
											GUI.AddNote("Durch die abgeschlossene Blitzschlag-Versicherung erhaltet ihr ".. InsuranceCash .." zusätzliche Taler")
										end
									end
								end
							end
						end
					end

				-- wenn alles andere (Soldier), dann...
				else
					if Logic.IsEntityAlive(eID) then
						if ExtendedStatistics then
							if _damage >= Logic.GetEntityHealth(eID) then
								ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].UnitsLostThroughLightning + 1
							end
							ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].DamageTakenByLightning + _damage
						end
						Logic.HurtEntity(eID, _damage)
					end
				end
				-- Signal für den Spieler + Begrenzung Ton nur 1/sek
				if GUI.GetPlayerID() == Logic.EntityGetPlayer(eID) then
					gvLightning.RecentlyDamaged[Logic.EntityGetPlayer(eID)] = true
					GUI.ScriptSignal(_posX, _posY, 0)
				end
				local count
				if ExtendedStatistics then
					if not count then
						ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].AmountOfLightningStrikes = ExtendedStatistics.Players[Logic.EntityGetPlayer(eID)].AmountOfLightningStrikes + 1
						count = true
					end
				end
			end
		end
		 -- Can not make snow during peacetime
        for i= 1, 4 do
            ForbidTechnology(Technologies.T_MakeSnow, i);
        end

        AI.Player_EnableAi(7);
		for i= 1, 8 do
            MakeInvulnerable("OP" ..i);
        end
		RemoveBlockRocksToMakeOutpostsAccessable();


        -- Get teams
        local Teams = {[1] = {1, 2}, [2] = {3, 4}};
        -- Setup outposts
        WT2022.Delivery.Init(Teams[1][1], Teams[1][2], 5, Teams[2][1], Teams[2][2], 6);
        WT2022.Outpost.Init(Teams[1][1], Teams[1][2], 5, Teams[2][1], Teams[2][2], 6);
        WT2022.Outpost.Create("OP1", ResourceType.SulfurRaw, "Oxford");
        WT2022.Outpost.Create("OP2", ResourceType.IronRaw,   "Cheltenham");
        WT2022.Outpost.Create("OP3", ResourceType.IronRaw,   "Cambridge");
        WT2022.Outpost.Create("OP4", ResourceType.SulfurRaw, "Norwich");
        WT2022.Outpost.Create("OP5", ResourceType.StoneRaw,  "Reading");
        WT2022.Outpost.Create("OP6", ResourceType.ClayRaw,   "Southampton");
        WT2022.Outpost.Create("OP7", ResourceType.ClayRaw,   "Birmingham");
        WT2022.Outpost.Create("OP8", ResourceType.StoneRaw,  "Peterborough");

        -- Setup victory conditions
        WT2022.Victory.Init(Teams[1][1], Teams[1][2], 5, Teams[2][1], Teams[2][2], 6);
        WT2022.Victory:SetMaximumOutpostAmount(8);
        WT2022.Victory:SetResourceAmount(5000);
    end,

    -- ********************************************************************************************
    -- * Callback_OnPeacetimeEnded
    -- * Called when the peacetime counter reaches zero
    -- ********************************************************************************************
    Callback_OnPeacetimeEnded = function()
		RemoveBlockRocksToMakePlayersAccessEachother();
        RemoveBlockRocksToOpenCenter();
        -- Change weather for blocking reasons
        if Logic.GetWeatherState() == 1 then
            StartRain(30);
        else
            StartSummer(30);
        end
		-- Allow make snow
        for i= 1, 4 do
            AllowTechnology(Technologies.T_MakeSnow, i);
        end

		-- Silver
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSilverPileDestroyed", 1)
		local posX, posY = Logic.WorldGetSize()
		local id = Logic.CreateEntity(Entities.CU_AggressiveWolf, posX/2, posY/2, 0, 7)
		MakeInvulnerable(id)
		SVLib.SetInvisibility(id, 1)
		Logic.SetEntityName(id, "fakedamager")
		Logic.SuspendEntity(id)
    end,

    -- ********************************************************************************************
    -- * Peacetime
    -- * Number of minutes the players will be unable to attack each other
    -- ********************************************************************************************
    Peacetime = 30,

    -- ********************************************************************************************
    -- * GameMode
    -- * GameMode is a concept of a switchable option, that the scripter can freely use
    -- *
    -- * GameModes is a table that contains the available options for the players, for example:
    -- * GameModes = {"3vs3", "2vs2", "1vs1"},
    -- *
    -- * GameMode contains the index of selected mode by default - ranging from 1 to X
    -- *
    -- * Callback_GameModeSelected
    -- * Lets the scripter make changes, according to the selected game mode.
    -- * You could give different ressources or change the map environment accordingly
    -- * _gamemode contains the index of the selected option according to the GameModes table
    -- ********************************************************************************************
    GameMode = 1,
    GameModes = {"2vs2"},
    Callback_GameModeSelected = function(_gamemode)
    end,

    -- ********************************************************************************************
    -- * Resource Level
    -- * Determines how much ressources the players start with
    -- * 1 = Normal
    -- * 2 = FastGame
    -- * 3 = SpeedGame
    -- * See the ressources table below for configuration
    -- ********************************************************************************************
    ResourceLevel = 1,

    -- ********************************************************************************************
    -- * Resources
    -- * Order:
    -- * Gold, Clay, Wood, Stone, Iron, Sulfur
    -- * Rules:
    -- * 1. If no player is defined, default values are used
    -- * 2. If player 1 is defined, these ressources will be used for all other players too
    -- * 3. Use the players index to give ressources explicitly
    -- ********************************************************************************************
    Ressources =
    {
        -- * Normal default: 1k, 1.8k, 1.5k, 0.8k, 50, 50
        Normal = {
            [1] = {
                1200,
                2000,
                1500,
                1200,
                150,
                150,
            },
        },
        -- * FastGame default: 2 x Normal Ressources
        FastGame = {},

        -- * SpeedGame default: 20k, 12k, 14k, 10k, 7.5k, 7.5k
        SpeedGame = {},
    },

    -- ********************************************************************************************
    -- * Callback_OnFastGame
    -- * Called together with Callback_OnGameStart if the player selected ResourceLevel 2 or 3
    -- * (FastGame or SpeedGame)
    -- ********************************************************************************************
    Callback_OnFastGame = function()

    end,

    -- ********************************************************************************************
    -- * AI Players
    -- * Player Entities that belong to an ID that is also present in the AIPlayers table won't be
    -- * removed
    -- ********************************************************************************************
    AIPlayers = {
        5, 6, 7, 8
    },

    -- ********************************************************************************************
    -- * DisableInitCameraOnHeadquarter
    -- * Set to true if you don't want the camera to be set to the headquarter automatically
    -- * (default: false)
    -- ********************************************************************************************
    DisableInitCameraOnHeadquarter = false,

    -- ********************************************************************************************
    -- * DisableSetZoomFactor
    -- * If set to false, ZoomFactor will be set to 2 automatically
    -- * Set to true if nothing should be done
    -- * (default: false)
    -- ********************************************************************************************
    DisableSetZoomFactor = false,

    -- ********************************************************************************************
    -- * DisableStandardVictoryCondition
    -- * Set to true if you want to implement your own victory condition
    -- * Otherwise the player will lose upon losing his headquarter
    -- * (default: false)
    -- ********************************************************************************************
    DisableStandardVictoryCondition = true,

    -- ********************************************************************************************
    -- * Units
    -- * Various units can be allowed or forbidden
    -- * A 0 means the unit is forbidden - a higher number represents the maximum allowed level
    -- * Example:
    -- * Sword = 0, equals Swords are forbidden
    -- * Sword = 2, equals the maximum level for swords is 2 = Upgrading once
    -- ********************************************************************************************
    Sword        = 4,
    Bow          = 4,
    PoleArm      = 4,
    HeavyCavalry = 2,
    LightCavalry = 2,
    Rifle        = 2,
    Thief        = 1,
    Scout        = 1,
    Cannon1      = 1,
    Cannon2      = 1,
    Cannon3      = 1,
    Cannon4      = 1,

    -- * Buildings
    Bridge = 1,

    -- * Markets
    -- * -1 = Building markets is forbidden
    -- * 0 = Building markets is allowed
    -- * >0 = Markets are allowed and limited to the number given
    Markets = 0,

    -- * Trade Limit
    -- * 0 = no trade limit
    -- * greater zero = maximum amount that you can buy in one single trade
    TradeLimit = 0,

    -- * TowerLevel
    -- * 0 = Towers forbidden
    -- * 1 = Watchtowers
    -- * 2 = Balistatowers
    -- * 3 = Cannontowers
    TowerLevel = 3, -- 0-3

    -- * TowerLimit
    -- * 0  = no tower limit
    -- * >0 = towers are limited to the number given
    TowerLimit = 0,

    -- * WeatherChangeLockTimer
    -- * Minutes for how long the weather can't be changed directly again after a weatherchange happened
    WeatherChangeLockTimer =  3,

    MakeSummer = 1,
    MakeRain   = 1,
    MakeSnow   = 1,

    -- * Fixes the DestrBuild bug
    AntiBug    = 1,

    -- * HQRush
    -- * If set to true, Headquarters are invulernerable as long the player still has village centers
    HQRush     = 1,
    BlessLimit = 2,

    Heroes = {3,3,3,3},

    -- * Heroes
    Dario              = 1,
    Pilgrim            = 1,
    Ari                = 1,
    Erec               = 1,
    Salim              = 1,
    Helias             = 1,
    Drake              = 1,
    Yuki               = 1,
    Kerberos           = 1,
    Varg               = 1,
    Mary_de_Mortfichet = 1,
    Kala               = 1,
};

-- -------------------------------------------------------------------------- --

function OutpostPitFiller()
    for i= 1, 8 do
        if IsExisting("OP" ..i.. "_Pit") then
            if IsExisting("OP" ..i.. "_Mine") then
                local ID = GetID("OP" ..i.. "_Pit");
                if Logic.GetResourceDoodadGoodAmount(ID) < 999999 then
                    Logic.SetResourceDoodadGoodAmount(ID, 999999);
                end
            else
                DestroyEntity("OP" ..i.. "_Pit");
            end
        end
    end
end

function CreateWoodpilesForPlayers()
    for i= 1, 4 do
        CreateWoodPile("WoodPile1_P"..i, 25000);
        CreateWoodPile("WoodPile2_P"..i, 25000);
    end
end

function MakeBlockRocksInvisible()
    Logic.SetModelAndAnimSet(GetID("RockBlock0_1"), Models.Effects_XF_ExtractStone);
    Logic.SetModelAndAnimSet(GetID("RockBlock0_2"), Models.Effects_XF_ExtractStone);
    for i= 1, 4 do
        for j= 1, 6 do
            Logic.SetModelAndAnimSet(GetID("RockBlock" ..i.. "_" ..j), Models.Effects_XF_ExtractStone);
        end
    end
end

function RemoveBlockRocksToMakeOutpostsAccessable()
    DestroyEntity("RockBlock1_2");
    DestroyEntity("RockBlock1_3");
    DestroyEntity("RockBlock1_5");
    DestroyEntity("RockBlock1_6");
    DestroyEntity("RockBlock2_2");
    DestroyEntity("RockBlock2_3");
    DestroyEntity("RockBlock2_4");
    DestroyEntity("RockBlock2_5");
    DestroyEntity("RockBlock3_1");
    DestroyEntity("RockBlock3_2");

    DestroyEntity("RockBlock3_4");
    DestroyEntity("RockBlock3_5");
    DestroyEntity("RockBlock4_1");
    DestroyEntity("RockBlock4_3");
    DestroyEntity("RockBlock4_5");
    DestroyEntity("RockBlock4_6");



end

function RemoveBlockRocksToMakePlayersAccessEachother()
    DestroyEntity("RockBlock0_1");
    DestroyEntity("RockBlock0_2");
    DestroyEntity("RockBlock1_1");
    DestroyEntity("RockBlock2_1");
    DestroyEntity("RockBlock3_6");
    DestroyEntity("RockBlock4_2");
end

function RemoveBlockRocksToOpenCenter()
    DestroyEntity("RockBlock1_4");

    DestroyEntity("RockBlock2_6");


    DestroyEntity("RockBlock3_3");
    DestroyEntity("RockBlock4_4");

end

function OnOutpostUpgradeStarted(_ScriptName, _UpgradeType, _NextUpgradeLevel)

end

function OnOutpostUpgradeFinished(_ScriptName, _UpgradeType, _NewUpgradeLevel)

end

function VictoryConditionQuestDomincance(_PlayerID)
    local Title = "Siegbedingung: AUSLÖSCHUNG";
    local Text  = "Das Team dem es gelingt, das gegnerische Team zu "..
                  "vernichten, hat gewonnen. @cr @cr Hinweise: @cr @cr "..
                  "1) Ob schnelle Siege wie z.B. durch Rush möglich sind "..
                  "oder nicht, hängt von den EMS-Einstellungen ab. @cr "..
                  "2) Gebäude in der Basis können nicht zerstört werden, "..
                  "solange noch Außenposten kontrolliert werden.";
    Logic.AddQuest(_PlayerID, 1, MAINQUEST_OPEN, Title, Text, 1);
end

function VictoryConditionQuestTactical(_PlayerID)
    local Title = "Siegbedingung: VORHERRSCHAFT";
    local Text  = "Das Team dem es gelingt, alle Außenposten zu erobern "..
                  "und 5 Minuten zu halten, hat gewonnen."..
                  " @cr @cr Hinweise: @cr @cr "..
                  "1) Außenposten werden beansprucht, in dem sie zu einem "..
                  " gewissen Grad beschädigt werden. @cr "..
                  "2) Gebäude in der Basis können nicht zerstört werden, "..
                  "solange noch Außenposten kontrolliert werden. @cr "..
                  "3) Außenposten produzieren veredelbare Rohstoffe und"..
                  " können durch Upgrades verbessert werden. @cr "..
                  "4) Eine Lieferung umfasst 250 Rohstoffe (oder 500 wenn "..
                  "der Teampartner bereits verloren hat).";
    Logic.AddQuest(_PlayerID, 2, MAINQUEST_OPEN, Title, Text, 1);
end

function VictoryConditionQuestThievery(_PlayerID)
    local Title = "Siegbedingung: DIEBESKUNST";
    local Text  = "Das Team dem es gelingt, Warenlieferungen von 10000 "..
                  "Einheiten zu erbeuten, hat gewonnen."..
                  " @cr @cr Hinweise: @cr @cr "..
                  "1) Diebe können Handelskarren angreifen, wodurch diese "..
                  "den Besitzer und ihr Ziel wechseln. @cr "..
                  "2) Eine Lieferung umfasst 250 Rohstoffe (oder 500 wenn "..
                  "der Teampartner bereits verloren hat).";
    Logic.AddQuest(_PlayerID, 3, MAINQUEST_OPEN, Title, Text, 1);
end

---
--- Outpost Control Script
---
--- Implements claimable outposts that produce resources.
---
--- <b>Important:</b> This script is ONLY designed vor 2vs2 games!
---
--- <b>Important:</b> For each of the players a headquarters with the
--- scriptname "HQ" + PlayerID and a script entity wit the scriptname
--- "HQ" + PlayerID + "_DoorPos" must both exist! Also for each outpost
--- der must also exist a script entity with the same script name but
--- extending "_DoorPos"!
---
--- Claiming an outpost will trigger:
--- <pre>GameCallback_User_OutpostClaimed(_ScriptName, _CapturingPlayer, _TeamOfCapturer, _OutpostPlayerID)</pre>
---
--- This triggers every time an outpost would produce resources:
--- <pre>GameCallback_User_OutpostProduceResource(_ScriptName, _SpawnPoint, _OwningTeam, _ResourceType, _Amount)</pre>
---
--- Starting an upgrade will trigger:
--- <pre>GameCallback_User_OutpostUpgradeStarted(_ScriptName, _UpgradeType, _NextUpgradeLevel)</pre>
---
--- A finished upgrade will trigger:
--- <pre>GameCallback_User_OutpostUpgradeFinished(_ScriptName, _UpgradeType, _NewUpgradeLevel)</pre>
---

WT2022 = WT2022 or {};

WT2022.Outpost = {
    SequenceID = 0,
    Outposts = {},
    Teams = {};
}

--- Initalizes the outpost system. Must be called once on game start.
--- @param _T1P1 number Member 1 of team 1
--- @param _T1P2 number Member 2 of team 1
--- @param _DP1  number Delivery NPC player for team 1
--- @param _T2P1 number Member 1 of team 2
--- @param _T2P2 number Member 2 of team 2
--- @param _DP2  number Delivery NPC player for team 2
function WT2022.Outpost.Init(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    WT2022.Outpost:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2);
end

--- Creates an new Outpost for a resource type.
--- @param _ScriptName   string Script name of outpost
--- @param _ResourceType number Resource type to produce
--- @param _DisplayName  string Displayed name
function WT2022.Outpost.Create(_ScriptName, _ResourceType, _DisplayName)
    WT2022.Outpost:CreateOutpost(_ScriptName, _ScriptName.. "_DoorPos", _ResourceType, _DisplayName);
end

--- Starts the given type of upgrade if possible.
--- @param _ScriptName string Script name of outpost
--- @param _Type       number Type of upgrade (1 = production, 2 = defence, 3 = health)
--- @param _Duration   number Time until completion
function WT2022.Outpost.StartUpgrade(_ScriptName, _Type, _Duration)
    WT2022.Outpost:InitiateUpgrade(_ScriptName, _Type, _Duration);
end

--- Checks if the outpost can be upgraded.
--- @param _ScriptName string Script name of outpost
--- @param _Type       number Type of upgrade
--- @return boolean Upgradable Can be upgraded
function WT2022.Outpost.CanUpgrade(_ScriptName, _Type)
    return WT2022.Outpost:CanBeUpgraded(_ScriptName, _Type);
end

--- Claims the outpost for the given player.
--- @param _ScriptName string Script name of outpost
--- @param _NewPlayer  number New owner
function WT2022.Outpost.Claim(_ScriptName, _NewPlayer)
    local OldPlayer = GetPlayer(_ScriptName);
    local TeamID = WT2022.Outpost:GetTeamOfPlayer(_NewPlayer);
    WT2022.Outpost:ClaimOutpost(_ScriptName, OldPlayer, _NewPlayer, TeamID);
end

--- Returns the resource type produced by the outpost.
--- @param _ScriptName string Script name of outpost
--- @return number ResourceType Type of produced Resource
function WT2022.Outpost.GetResourceType(_ScriptName)
    if WT2022.Outpost.Outposts[_ScriptName] then
        return WT2022.Outpost.Outposts[_ScriptName].ResourceType;
    end
    return -1;
end

-- -------------------------------------------------------------------------- --

function WT2022.Outpost:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    -- Setup diplomacy
    self.Teams[1] = {_T1P1, _T1P2, Deliverer = _DP1};
    self.Teams[2] = {_T2P1, _T2P2, Deliverer = _DP2};
    SetHostile(self.Teams[1][1], self.Teams[2].Deliverer);
    SetHostile(self.Teams[1][2], self.Teams[2].Deliverer);
    SetHostile(self.Teams[2][1], self.Teams[1].Deliverer);
    SetHostile(self.Teams[2][2], self.Teams[1].Deliverer);
    SetHostile(self.Teams[1][1], 7);
    SetHostile(self.Teams[1][2], 7);
    SetHostile(self.Teams[2][1], 7);
    SetHostile(self.Teams[2][2], 7);

    -- Controller Job
    if not self.ControllerJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_EVERY_SECOND,
            "",
            "Outpost_Internal_OnEverySecond",
            1
        );
        self.ControllerJobID = JobID;
    end
    -- Attacked Job
    if not self.DamageJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
            "",
            "Outpost_Internal_OnEntityHurt",
            1
        );
        self.DamageJobID = JobID;
    end

    self:OverwriteEntityStatsDisplay();
    self:OverwriteCommonCallbacks();
    self:OverwriteChuirchMenu();
    self:BackupChuirchButtons();
    self:CreateSyncEvent();
end

function WT2022.Outpost:CreateOutpost(_ScriptName, _DoorPos, _ResourceType, _DisplayName)
    if self.Outposts[_ScriptName] then
        return;
    end
    self.SequenceID = self.SequenceID +1;
    self.Outposts[_ScriptName] = {
        Name = _DisplayName or ("Province " ..self.SequenceID),
		Army = nil,
        Health = 3000,
        MaxHealth = 3000,
        ArmorFactor = 6,
        DoorPos = _DoorPos,
        ResourceType = _ResourceType,
        OwningTeam = 0,
        ProductCount = 0,
        ProductionValue = 4,
        DeliverThreshold = 500,
        Explorer = 0,

        Defenders = {},
        Upgrades = {
            -- Productivity
            [1] = {
                Level = 0,
                [1] = {
                    Costs = {[ResourceType.Iron] = 150, [ResourceType.Wood] = 250},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ProductionValue = Data.ProductionValue + 4;
                    end
                },
                [2] = {
                    Costs = {[ResourceType.Iron] = 200, [ResourceType.Wood] = 300},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ProductionValue = Data.ProductionValue + 4;
                    end
                },
                [3] = {
                    Costs = {[ResourceType.Sulfur] = 300, [ResourceType.Wood] = 400},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ProductionValue = Data.ProductionValue + 4;
                    end
                },
            },
            -- Defence
            [2] = {
                Level = 0,
                [1] = {
                    Costs = {[ResourceType.Gold] = 200, [ResourceType.Wood] = 300},
                    Action = function(_ScriptName, _Level)
                        local X, Y = 100, 0;
                        WT2022.Outpost:CreateDefender(_ScriptName, X, Y);
                    end
                },
                [2] = {
                    Costs = {[ResourceType.Gold] = 250, [ResourceType.Wood] = 400},
                    Action = function(_ScriptName, _Level)
                        local X, Y = -100, 0;
                        WT2022.Outpost:CreateDefender(_ScriptName, X, Y);
                    end
                },
                [3] = {
                    Costs = {[ResourceType.Gold] = 300, [ResourceType.Iron] = 500},
                    Action = function(_ScriptName, _Level)
                        local X, Y = 0, 100;
                        WT2022.Outpost:CreateDefender(_ScriptName, X, Y);
                    end
                },
            },
            -- Health
            [3] = {
                Level = 0,
                [1] = {
                    Costs = {[ResourceType.Stone] = 150, [ResourceType.Clay] = 250},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ArmorFactor = Data.ArmorFactor + 2;
                        WT2022.Outpost.Outposts[_ScriptName].MaxHealth = math.ceil(Data.MaxHealth + 250);
                        WT2022.Outpost.Outposts[_ScriptName].Health = Data.MaxHealth;
                        SVLib.SetHPOfEntity(GetID(_ScriptName), 600);
                    end
                },
                [2] = {
                    Costs = {[ResourceType.Stone] = 200, [ResourceType.Clay] = 300},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ArmorFactor = Data.ArmorFactor + 2;
                        WT2022.Outpost.Outposts[_ScriptName].MaxHealth = math.ceil(Data.MaxHealth + 250);
                        WT2022.Outpost.Outposts[_ScriptName].Health = Data.MaxHealth;
                        SVLib.SetHPOfEntity(GetID(_ScriptName), 600);
                    end
                },
                [3] = {
                    Costs = {[ResourceType.Stone] = 400, [ResourceType.Clay] = 400},
                    Action = function(_ScriptName, _Level)
                        local Data = WT2022.Outpost.Outposts[_ScriptName];
                        WT2022.Outpost.Outposts[_ScriptName].ArmorFactor = Data.ArmorFactor + 2;
                        WT2022.Outpost.Outposts[_ScriptName].MaxHealth = math.ceil(Data.MaxHealth + 250);
                        WT2022.Outpost.Outposts[_ScriptName].Health = Data.MaxHealth;
                        SVLib.SetHPOfEntity(GetID(_ScriptName), 600);
                    end
                },
            },
        },

        IsUpgrading = false,
        UpgradeType = 0,
        UpgradeDuration = 0,
        UpgradeStarted = 0,
    }
    local Position = GetPosition(_ScriptName);
    GUI.CreateMinimapMarker(Position.X, Position.Y, 0);
    ChangePlayer(_ScriptName, 7);
    MakeInvulnerable(_ScriptName);
    self:CreateExplorerEntity(_ScriptName, 7);
	self:CreateGuardianArmy(_ScriptName);
end

function WT2022.Outpost:CreateSyncEvent()
    function SyncCallback_StartOutpostUpgrade(_PlayerID, _ScriptName, _Type, _Time)
        WT2022.Outpost:InitiateUpgrade(_ScriptName, _Type, _Time);
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("SyncCallback_StartOutpostUpgrade",
            function(name, _PlayerID, _ScriptName, _Type, _Time)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    SyncCallback_StartOutpostUpgrade(_PlayerID, _ScriptName, _Type, _Time);
                end;
            end
        );
    end;
end

function WT2022.Outpost:CreateGuardianArmy(_ScriptName)
    local ArmyID = self.SequenceID;

    local Army = {
		player 				= 7,
		id 					= ArmyID,
		strength 			= 8,
		position 			= GetPosition("OP" ..ArmyID.. "_DoorPos"),
		rodeLength 			= 2000,
	}
	SetupArmy(Army);
    for i = 1, 4 do
        EnlargeArmy(Army, {
            maxNumberOfSoldiers = 4,
            minNumberOfSoldiers = 4,
            experiencePoints = VERYHIGH_EXPERIENCE,
            leaderType = Entities.PU_LeaderPoleArm2
        });
        EnlargeArmy(Army, {
            maxNumberOfSoldiers = 4,
            minNumberOfSoldiers = 4,
            experiencePoints = VERYHIGH_EXPERIENCE,
            leaderType = Entities.PU_LeaderBow2
        });
    end
	Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_SECOND,
        "",
        "Outpost_Internal_ControlArmy",
        1,
        {},
        {_ScriptName}
    );

    self.Outposts[_ScriptName].Army = Army;
end

function WT2022.Outpost:EnlargeGuardianArmy(_ScriptName)
    local Army = self.Outposts[_ScriptName].Army;
    if Army then
        for i = 1, 4 do
            EnlargeArmy(Army, {
                maxNumberOfSoldiers = 8,
                minNumberOfSoldiers = 8,
                experiencePoints = VERYHIGH_EXPERIENCE,
                leaderType = Entities.PU_LeaderPoleArm3
            });
            EnlargeArmy(Army, {
                maxNumberOfSoldiers = 4,
                minNumberOfSoldiers = 4,
                experiencePoints = VERYHIGH_EXPERIENCE,
                leaderType = Entities.PU_LeaderRifle1
            });
        end
    end
end
function WT2022.Outpost:CreateExplorerEntity(_ScriptName, _PlayerID)
    if not self.Outposts[_ScriptName] then
        return;
    end
    if IsExisting(self.Outposts[_ScriptName].Explorer) then
        DestroyEntity(self.Outposts[_ScriptName].Explorer);
    end
    local Position = GetPosition(_ScriptName);
    local ID = Logic.CreateEntity(Entities.XD_ScriptEntity, Position.X, Position.Y, 0, _PlayerID);
    Logic.SetEntityExplorationRange(ID, 65);
    self.Outposts[_ScriptName].Explorer = ID;
end

function WT2022.Outpost:InitiateUpgrade(_ScriptName, _Type, _Duration)
    if self:CanBeUpgraded(_ScriptName, _Type) then
        -- Deco
        if not self.Outposts[_ScriptName].UpgradeTrestle then
            local Position = GetPosition(_ScriptName);
            local Orientation = Logic.GetEntityOrientation(GetID(_ScriptName));
            local OffsetX = (Orientation == 0 and -100) or 0;
            local OffsetY = (Orientation == 0 and -100) or 0;
            local ID = Logic.CreateEntity(Entities.XD_Rock3, Position.X+OffsetX, Position.Y+OffsetY, 0, 0);
            Logic.SetModelAndAnimSet(ID, Models.ZB_ConstructionSiteResidence1);
            self.Outposts[_ScriptName].UpgradeTrestle = ID;
        end
        -- Logic
        local Costs = self:GetUpgradeCosts(_ScriptName, _Type);
		local PlayerID = Logic.EntityGetPlayer(GetID(_ScriptName));
        self.Outposts[_ScriptName].IsUpgrading = true;
        self.Outposts[_ScriptName].UpgradeType = _Type;
        self.Outposts[_ScriptName].UpgradeDuration = _Duration;
        self.Outposts[_ScriptName].UpgradeStarted = Logic.GetTime();
        self:DisplayUpgradeStartMessage(_ScriptName, PlayerID);
        RemoveResourcesFromPlayer(PlayerID, Costs);
        GameCallback_GUI_SelectionChanged();
        if GameCallback_User_OutpostUpgradeStarted then
            local Level = self.Outposts[_ScriptName].Upgrades[_Type].Level +1;
            GameCallback_User_OutpostUpgradeStarted(_ScriptName, _Type, Level);
        end
    end
end

function WT2022.Outpost:ConcludeUpgrade(_ScriptName, _Type, _Level)
    -- Deco
    if self.Outposts[_ScriptName].UpgradeTrestle then
        DestroyEntity(self.Outposts[_ScriptName].UpgradeTrestle);
        self.Outposts[_ScriptName].UpgradeTrestle = nil;
    end
    -- Logic
	local PlayerID = Logic.EntityGetPlayer(GetID(_ScriptName));
    self:DisplayUpgradeEndMessage(_ScriptName, PlayerID);
    self:DisplayChuirchMenu(GetID(_ScriptName));
    self:UpgradeRate(_ScriptName, _Type);
    self.Outposts[_ScriptName].IsUpgrading = false;
    self.Outposts[_ScriptName].UpgradeType = 0;
    self.Outposts[_ScriptName].UpgradeDuration = 0;
    self.Outposts[_ScriptName].UpgradeStarted = 0;
    GameCallback_GUI_SelectionChanged();
    if GameCallback_User_OutpostUpgradeFinished then
        GameCallback_User_OutpostUpgradeFinished(_ScriptName, _Type, _Level);
    end
end

function WT2022.Outpost:GetUpgradeCosts(_ScriptName, _Type)
    if not self.Outposts[_ScriptName] then
        return {};
    end
    local Level = self.Outposts[_ScriptName].Upgrades[_Type].Level+1;
    if not self.Outposts[_ScriptName].Upgrades[_Type][Level] then
        return {};
    end
    local Costs = self.Outposts[_ScriptName].Upgrades[_Type][Level].Costs;
    return Costs;
end

function WT2022.Outpost:ClaimOutpost(_ScriptName, _OldPlayer, _NewPlayer, _TeamID)
    local MaxHealth = Logic.GetEntityMaxHealth(GetID(_ScriptName));
    local NewPlayer = _OldPlayer;

    if _TeamID == 0 then
        NewPlayer = 7;
    end
    if self.Teams[_TeamID] then
        NewPlayer = _NewPlayer;
        self:DisplayClaimMessage(_ScriptName, _NewPlayer);
    end

    if _OldPlayer == 7 then
        local Army = self.Outposts[_ScriptName].Army
        if Army then
            DestroyArmy(_OldPlayer, Army.id);
        end
    end
    SVLib.SetHPOfEntity(GetID(_ScriptName), MaxHealth);
    ChangePlayer(_ScriptName, NewPlayer);
    MakeInvulnerable(_ScriptName);
    for k, v in pairs(self.Outposts[_ScriptName].Defenders) do
        ChangePlayer(v, NewPlayer);
        SVLib.SetInvisibility(GetID(v), true);
        MakeInvulnerable(v);
    end
    self.Outposts[_ScriptName].OwningTeam = _TeamID;
    self.Outposts[_ScriptName].Health = self.Outposts[_ScriptName].MaxHealth;
    self:CreateExplorerEntity(_ScriptName, NewPlayer);
    if GameCallback_User_OutpostClaimed then
        GameCallback_User_OutpostClaimed(_ScriptName, _OldPlayer, _NewPlayer, NewPlayer);
    end
end

function WT2022.Outpost:CreateDefender(_ScriptName, _OffsetX, _OffsetY)
    if not self.Outposts[_ScriptName] then
        return;
    end
    local PlayerID = Logic.EntityGetPlayer(GetID(_ScriptName));
    local TeamID = WT2022.Outpost:GetTeamOfPlayer(PlayerID);
    if TeamID == 0 then
        return;
    end
    local Count = table.getn(self.Outposts[_ScriptName].Defenders) +1;
    local ScriptName = _ScriptName.. "_Defender" ..Count;
    local Position = GetPosition(_ScriptName);
    local ID = Logic.CreateEntity(Entities.CB_Evil_Tower1, Position.X+_OffsetX, Position.Y+_OffsetY, 0, PlayerID);
    Logic.SetEntityName(ID, ScriptName);
    SVLib.SetInvisibility(ID, true);
    MakeInvulnerable(ID);
    table.insert(self.Outposts[_ScriptName].Defenders, ScriptName);
end

function WT2022.Outpost:GetUpgradeProgress(_ScriptName)
    if not self.Outposts[_ScriptName].IsUpgrading then
        return 0;
    end
    local Started  = self.Outposts[_ScriptName].UpgradeStarted;
    local Duration = self.Outposts[_ScriptName].UpgradeDuration;
    return math.min((Logic.GetTime()-Started) / Duration, 1);
end

function WT2022.Outpost:UpgradeRate(_ScriptName, _Type)
    local Level = self.Outposts[_ScriptName].Upgrades[_Type].Level +1;
    self.Outposts[_ScriptName].Upgrades[_Type].Level = Level;
    self.Outposts[_ScriptName].Upgrades[_Type][Level].Action(_ScriptName, Level);
end

function WT2022.Outpost:CanBeUpgraded(_ScriptName, _Type)
    if self.Outposts[_ScriptName] then
        local Data = self.Outposts[_ScriptName];
        return Data.IsUpgrading == false and Data.Upgrades[_Type].Level < table.getn(Data.Upgrades[_Type]);
    end
    return false;
end

function WT2022.Outpost:CanBeClaimed(_ScriptName, _PlayerID, _AttackerPlayerID)
    if self.Outposts[_ScriptName] then
        local Army = self.Outposts[_ScriptName].Army;
        if not Army or IsDead(Army) then
            if _AttackerPlayerID < 5 then
                local MaxHealth = WT2022.Outpost.Outposts[_ScriptName].MaxHealth;
                local MinHealth = math.ceil(MaxHealth * 0.30);
                local FakeHealth = WT2022.Outpost.Outposts[_ScriptName].Health;
                if FakeHealth <= MinHealth then
                    if not AreAlliesInArea(_PlayerID, GetPosition(_ScriptName), 3000) then
                        return true;
                    end
                end
			end
        end
    end
    return false;
end

function WT2022.Outpost:CanProduceResources(_ScriptName)
    if self.Outposts[_ScriptName] then
        if not self.Outposts[_ScriptName].IsUpgrading then
            return self.Outposts[_ScriptName].OwningTeam == 1 or self.Outposts[_ScriptName].OwningTeam == 2;
        end
    end
    return false;
end

function WT2022.Outpost:GetTeamOfPlayer(_PlayerID)
    for i= 1, 2 do
        if self.Teams[i][1] == _PlayerID or self.Teams[i][2] == _PlayerID then
            return i;
        end
    end
    return 0;
end

function WT2022.Outpost:GetColoredPlayerName(_PlayerID)
    local NameOfAttacker = UserTool_GetPlayerName(_PlayerID);
    local ColorOfAttacker = " @color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
    return ColorOfAttacker.. " " ..NameOfAttacker.. " @color:255,255,255 ";
end

function WT2022.Outpost:GetColoredOutpostName(_ScriptName)
    if not self.Outposts[_ScriptName] then
        return "NAME_NOT_FOUND";
    end
    local NameOfOutpost = self.Outposts[_ScriptName].Name;
    return " @color:120,120,120 " ..NameOfOutpost.. " @color:255,255,255 ";
end

function WT2022.Outpost:DisplayClaimMessage(_ScriptName, _PlayerID)
    Message(string.format(
        "%s hat den Außenposten %s eingenommen!",
        self:GetColoredPlayerName(_PlayerID),
        self:GetColoredOutpostName(_ScriptName)
    ));
end

function WT2022.Outpost:DisplayUpgradeStartMessage(_ScriptName, _PlayerID)
    Message(string.format(
        " %s beginnt den Außenposten %s auszubauen...",
        self:GetColoredPlayerName(_PlayerID),
        self:GetColoredOutpostName(_ScriptName)
    ));
end

function WT2022.Outpost:DisplayUpgradeEndMessage(_ScriptName, _PlayerID)
    Message(string.format(
        "Der Außenposten %s wurde ausgebaut!",
        self:GetColoredOutpostName(_ScriptName)
    ));
end

-- -------------------------------------------------------------------------- --

function WT2022.Outpost:OverwriteCommonCallbacks()
    WT2022.Outpost.GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
	GameCallback_GUI_SelectionChanged = function()
		WT2022.Outpost.GameCallback_GUI_SelectionChanged();
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
	end

	WT2022.Outpost.GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete;
	GameCallback_OnBuildingConstructionComplete = function(_EntityID, _PlayerID)
		WT2022.Outpost.GameCallback_OnBuildingConstructionComplete(_EntityID, _PlayerID);
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
	end

	WT2022.Outpost.GameCallback_OnBuildingUpgradeComplete = GameCallback_OnBuildingUpgradeComplete;
	GameCallback_OnBuildingUpgradeComplete = function(_EntityIDOld, _EntityIDNew)
		WT2022.Outpost.GameCallback_OnBuildingUpgradeComplete(_EntityIDOld, _EntityIDNew);
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
	end

	WT2022.Outpost.GameCallback_OnTechnologyResearched = GameCallback_OnTechnologyResearched;
	GameCallback_OnTechnologyResearched = function(_PlayerID, _Technology, _EntityID)
		WT2022.Outpost.GameCallback_OnTechnologyResearched(_PlayerID, _Technology, _EntityID);
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
	end

	WT2022.Outpost.GameCallback_OnCannonConstructionComplete = GameCallback_OnCannonConstructionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        WT2022.Outpost.GameCallback_OnCannonConstructionComplete(_BuildingID, _null);
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
    end

    WT2022.Outpost.GameCallback_OnTransactionComplete = GameCallback_OnTransactionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        WT2022.Outpost.GameCallback_OnTransactionComplete(_BuildingID, _null);
        WT2022.Outpost:DisplayChuirchMenu(GUI.GetSelectedEntity());
    end
	WT2022.Outpost.Mission_OnSaveGameLoaded = Mission_OnSaveGameLoaded;
	Mission_OnSaveGameLoaded = function()
		WT2022.Outpost.Mission_OnSaveGameLoaded();
        WT2022.Outpost:BackupChuirchButtons();
	end
end

function WT2022.Outpost:OverwriteChuirchMenu()
    WT2022.Outpost.GUIAction_BlessSettlers = GUIAction_BlessSettlers;
    GUIAction_BlessSettlers = function(_BlessCategory)
        WT2022.Outpost:BlessButtonAction(_BlessCategory);
    end

    WT2022.Outpost.GUITooltip_BlessSettlers = GUITooltip_BlessSettlers;
    GUITooltip_BlessSettlers = function(_Disabled, _Normal, _Researched, _Key)
        WT2022.Outpost.GUITooltip_BlessSettlers(_Disabled, _Normal, _Researched, _Key);
        WT2022.Outpost:BlessButtonTooltip(_Disabled, _Normal, _Researched, _Key)
    end

    WT2022.Outpost.GUIUpdate_BuildingButtons = GUIUpdate_BuildingButtons;
    GUIUpdate_BuildingButtons = function(_Button, _Technology)
        WT2022.Outpost.GUIUpdate_BuildingButtons(_Button, _Technology);
        WT2022.Outpost:BlessButtonUpdate(_Button, _Technology, nil)
    end

    WT2022.Outpost.GUIUpdate_GlobalTechnologiesButtons = GUIUpdate_GlobalTechnologiesButtons;
    GUIUpdate_GlobalTechnologiesButtons = function(_Button, _Technology, _Type)
        WT2022.Outpost.GUIUpdate_GlobalTechnologiesButtons(_Button, _Technology, _Type);
        WT2022.Outpost:BlessButtonUpdate(_Button, _Technology, _Type)
    end

    WT2022.Outpost.GUIUpdate_FaithProgress = GUIUpdate_FaithProgress;
    GUIUpdate_FaithProgress = function()
        WT2022.Outpost.GUIUpdate_FaithProgress();
        WT2022.Outpost:FaithBarUpdate();
    end
end

function WT2022.Outpost:OverwriteEntityStatsDisplay()
    WT2022.Outpost.GUIUpdate_DetailsHealthPoints = GUIUpdate_DetailsHealthPoints;
    GUIUpdate_DetailsHealthPoints = function()
        WT2022.Outpost.GUIUpdate_DetailsHealthPoints();
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID();
        local EntityID = GUI.GetSelectedEntity();
        local ScriptName = Logic.GetEntityName(EntityID);
        if WT2022.Outpost.Outposts[ScriptName] == nil then
            return;
        end
        local MaxHealth = WT2022.Outpost.Outposts[ScriptName].MaxHealth;
        local FakeHealth = WT2022.Outpost.Outposts[ScriptName].Health;
        XGUIEng.SetText(CurrentWidgetID, "@center ".. FakeHealth .. "/" .. MaxHealth);
    end

    WT2022.Outpost.GUIUpate_DetailsHealthBar = GUIUpate_DetailsHealthBar;
    GUIUpate_DetailsHealthBar = function()
        WT2022.Outpost.GUIUpate_DetailsHealthBar();
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
        local EntityID = GUI.GetSelectedEntity()
        local ScriptName = Logic.GetEntityName(EntityID);
        if WT2022.Outpost.Outposts[ScriptName] == nil then
            return;
        end
        -- Don't need to set the color again...
        local MaxHealth = WT2022.Outpost.Outposts[ScriptName].MaxHealth;
        local FakeHealth = WT2022.Outpost.Outposts[ScriptName].Health;
        XGUIEng.SetProgressBarValues(CurrentWidgetID, FakeHealth, MaxHealth)
    end

    WT2022.Outpost.GUIUpdate_Armor = GUIUpdate_Armor;
    GUIUpdate_Armor = function()
        WT2022.Outpost.GUIUpdate_Armor();
        local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
        local EntityID = GUI.GetSelectedEntity()
        local ScriptName = Logic.GetEntityName(EntityID);
        if WT2022.Outpost.Outposts[ScriptName] == nil then
            return;
        end
        local Armor = WT2022.Outpost.Outposts[ScriptName].ArmorFactor;
        XGUIEng.SetTextByValue(CurrentWidgetID, Armor, 1);
    end

    WT2022.Outpost.GUIUpdate_SelectionName = GUIUpdate_SelectionName;
    GUIUpdate_SelectionName = function()
        WT2022.Outpost.GUIUpdate_SelectionName();
        local EntityID = GUI.GetSelectedEntity();
        local ScriptName = Logic.GetEntityName(EntityID);
        if WT2022.Outpost.Outposts[ScriptName] == nil then
            return;
        end
        local String = WT2022.Outpost.Outposts[ScriptName].Name;
        XGUIEng.SetText(gvGUI_WidgetID.SelectionName, String);
    end
end

function WT2022.Outpost:BackupChuirchButtons()
    XGUIEng.TransferMaterials("BlessSettlers2", "Research_Debenture");
    XGUIEng.TransferMaterials("BlessSettlers3", "Research_BookKeeping");
    XGUIEng.TransferMaterials("BlessSettlers4", "Research_Scale");
end

function WT2022.Outpost:DisplayChuirchMenu(_EntityID)
    local PlayerID = GUI.GetPlayerID();
    if not IsExisting(_EntityID) or Logic.EntityGetPlayer(_EntityID) ~= PlayerID then
        return;
    end
    local ScriptName = Logic.GetEntityName(_EntityID);
    if not self.Outposts[ScriptName] then
        XGUIEng.TransferMaterials("Research_Debenture", "BlessSettlers2");
        XGUIEng.TransferMaterials("Research_BookKeeping", "BlessSettlers3");
        XGUIEng.TransferMaterials("Research_Scale", "BlessSettlers4");
        return;
    end
    -- Show the castle as video preview because a black field is ugly!
    if GetID(ScriptName) == _EntityID and GUI.GetSelectedEntity() == _EntityID then
        XGUIEng.ShowWidget(gvGUI_WidgetID.VideoPreview, 1);
        local VideoName = "data\\graphics\\videos\\PB_Headquarters3.bik";
        XGUIEng.StartVideoPlayback(gvGUI_WidgetID.VideoPreview, VideoName, 1);
    end

    XGUIEng.TransferMaterials("Upgrade_Monastery1", "BlessSettlers2");
    XGUIEng.TransferMaterials("Upgrade_Monastery1", "BlessSettlers3");
    XGUIEng.TransferMaterials("Upgrade_Monastery1", "BlessSettlers4");
    XGUIEng.ShowWidget("Monastery", 1);
    XGUIEng.ShowWidget("Commands_Monastery", 1);
    XGUIEng.ShowAllSubWidgets("Commands_Monastery", 1);
    XGUIEng.ShowWidget("BlessSettlers1", 0);
    XGUIEng.ShowWidget("BlessSettlers5", 0);
    XGUIEng.ShowWidget("Upgrade_Monastery1", 0);
    XGUIEng.ShowWidget("Upgrade_Monastery2", 0);
    XGUIEng.ShowWidget("DestroyBuilding", 0);

    local Production = (self:CanBeUpgraded(ScriptName, 1) and 1) or 0;
    self:BlessButtonUpdate("BlessSettlers2", Technologies.T_BlessSettlers3, nil)
    XGUIEng.ShowWidget("BlessSettlers2", Production);
    local Security = (self:CanBeUpgraded(ScriptName, 2) and 1) or 0;
    self:BlessButtonUpdate("BlessSettlers3", Technologies.T_BlessSettlers3, Entities.PB_Monastery2)
    XGUIEng.ShowWidget("BlessSettlers3", Security);
    local Resistance = (self:CanBeUpgraded(ScriptName, 3) and 1) or 0;
    self:BlessButtonUpdate("BlessSettlers4", Technologies.T_BlessSettlers4, Entities.PB_Monastery2)
    XGUIEng.ShowWidget("BlessSettlers4", Resistance);
end

function WT2022.Outpost:BlessButtonAction(_BlessCategory)
    local EntityID = GUI.GetSelectedEntity();
    local ScriptName = Logic.GetEntityName(EntityID);
    local PlayerID = GUI.GetPlayerID();
    if not self.Outposts[ScriptName] then
        WT2022.Outpost.GUIAction_BlessSettlers(_BlessCategory);
        return;
    end

    if _BlessCategory == BlessCategories.Research then
        local Level = self.Outposts[ScriptName].Upgrades[1].Level;
        if self.Outposts[ScriptName].Upgrades[1][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[1][Level+1].Costs;
            if self:AreCostsAffordable(Costs) then
                -- WT2022.Outpost:InitiateUpgrade(ScriptName, 1, 2*60);
                Sync.Call("SyncCallback_StartOutpostUpgrade", PlayerID, ScriptName, 1, 60);
            end
        end
    elseif _BlessCategory == BlessCategories.Weapons then
        local Level = self.Outposts[ScriptName].Upgrades[2].Level;
        if self.Outposts[ScriptName].Upgrades[2][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[2][Level+1].Costs;
            if self:AreCostsAffordable(Costs) then
                -- WT2022.Outpost:InitiateUpgrade(ScriptName, 2, 2*60);
                Sync.Call("SyncCallback_StartOutpostUpgrade", PlayerID, ScriptName, 2, 60);
            end
        end
    elseif _BlessCategory == BlessCategories.Financial then
        local Level = self.Outposts[ScriptName].Upgrades[3].Level;
        if self.Outposts[ScriptName].Upgrades[3][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[3][Level+1].Costs;
            if self:AreCostsAffordable(Costs) then
                -- WT2022.Outpost:InitiateUpgrade(ScriptName, 3, 2*60);
                Sync.Call("SyncCallback_StartOutpostUpgrade", PlayerID, ScriptName, 3, 60);
            end
        end
    end
end

function WT2022.Outpost:BlessButtonTooltip(_Disabled, _Normal, _Researched, _Key)
    local EntityID = GUI.GetSelectedEntity();
    local ScriptName = Logic.GetEntityName(EntityID);
    if not self.Outposts[ScriptName] then
        return;
    end

    local CostString = "";
    local TooltipText = " "..
        "@color:180,180,180 Abgeschlossen @color:255,255,255 "..
        " @cr Ihr habt alle Verbesserungen für den Außenposten erworben.";
    if _Key == "KeyBindings/BlessSettlers2" then
        local Level = self.Outposts[ScriptName].Upgrades[1].Level;
        if self.Outposts[ScriptName].Upgrades[1][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[1][Level+1].Costs;
            CostString = self:GetCostsString(Costs);
            TooltipText = " "..
                "@color:180,180,180 Produktivität erhöhen @color:255,255,255 "..
                " @cr Die Arbeiter der Provinz können schneller produzieren,"..
                " was die Zeit zwischen den Lieferungen verkürzt."
        end
    elseif _Key == "KeyBindings/BlessSettlers3" then
        local Level = self.Outposts[ScriptName].Upgrades[2].Level;
        if self.Outposts[ScriptName].Upgrades[2][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[2][Level+1].Costs;
            CostString = self:GetCostsString(Costs);
            TooltipText = " "..
                "@color:180,180,180 Schützen stationieren @color:255,255,255 "..
                " @cr Im Außenposten werden Schützen stationiert, welche"..
                " unaufhörlich auf Feinde in der Nähe schießen."
        end
    elseif _Key == "KeyBindings/BlessSettlers4" then
        local Level = self.Outposts[ScriptName].Upgrades[3].Level;
        if self.Outposts[ScriptName].Upgrades[3][Level+1] then
            local Costs = self.Outposts[ScriptName].Upgrades[3][Level+1].Costs;
            CostString = self:GetCostsString(Costs);
            TooltipText = " "..
                "@color:180,180,180 Mauern verbessern @color:255,255,255 "..
                " @cr Die Mauern des Außenposten werden widerstandsfähiger"..
                " und können Angriffen besser standhalten."
        end
    else
        return;
    end

    local HotKey = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_Key) .. "]"

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString);
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, TooltipText);
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, HotKey);
end

function WT2022.Outpost:BlessButtonUpdate(_Button, _Technology, _Type)
    local EntityID = GUI.GetSelectedEntity();
    local ScriptName = Logic.GetEntityName(EntityID);
    if not self.Outposts[ScriptName] then
        return;
    end

    local Type = 0;
    if _Button == "BlessSettlers2" then
        Type = 1;
    elseif _Button == "BlessSettlers3" then
        Type = 2;
    elseif _Button == "BlessSettlers4" then
        Type = 3;
    else
        return;
    end

    local Level = self.Outposts[ScriptName].Upgrades[Type].Level;
    if WT2022.Outpost:GetUpgradeProgress(ScriptName) == 0 then
        XGUIEng.DisableButton(_Button, 0);
        if self.Outposts[ScriptName].Upgrades[Type][Level+1] then
            XGUIEng.HighLightButton(_Button, 0);
        else
            XGUIEng.HighLightButton(_Button, 1);
        end
    else
        XGUIEng.DisableButton(_Button, 1);
    end
end

function WT2022.Outpost:FaithBarUpdate()
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local ScriptName = Logic.GetEntityName(EntityID);
    if not self.Outposts[ScriptName] then
        return;
    end

    local Current = self.Outposts[ScriptName].ProductCount;
	local Maximum = 500;
    if self.Outposts[ScriptName].IsUpgrading then
        Current = 100 * WT2022.Outpost:GetUpgradeProgress(ScriptName);
        Maximum = 100;
    end
	XGUIEng.SetProgressBarValues(WidgetID, Current, Maximum);
end

function WT2022.Outpost:AreCostsAffordable(_Costs)
    _Costs[ResourceType.Gold]   = _Costs[ResourceType.Gold]   or 0;
    _Costs[ResourceType.Silver] = _Costs[ResourceType.Silver] or 0;
    _Costs[ResourceType.Clay]   = _Costs[ResourceType.Clay]   or 0;
    _Costs[ResourceType.Wood]   = _Costs[ResourceType.Wood]   or 0;
    _Costs[ResourceType.Stone]  = _Costs[ResourceType.Stone]  or 0;
    _Costs[ResourceType.Iron]   = _Costs[ResourceType.Iron]   or 0;
    _Costs[ResourceType.Sulfur] = _Costs[ResourceType.Sulfur] or 0;
    return InterfaceTool_HasPlayerEnoughResources_Feedback(_Costs) == 1;
end

function WT2022.Outpost:GetCostsString(_Costs)
    _Costs[ResourceType.Gold]   = _Costs[ResourceType.Gold]   or 0;
    _Costs[ResourceType.Silver] = _Costs[ResourceType.Silver] or 0;
    _Costs[ResourceType.Clay]   = _Costs[ResourceType.Clay]   or 0;
    _Costs[ResourceType.Wood]   = _Costs[ResourceType.Wood]   or 0;
    _Costs[ResourceType.Stone]  = _Costs[ResourceType.Stone]  or 0;
    _Costs[ResourceType.Iron]   = _Costs[ResourceType.Iron]   or 0;
    _Costs[ResourceType.Sulfur] = _Costs[ResourceType.Sulfur] or 0;
    return InterfaceTool_CreateCostString(_Costs);
end

-- -------------------------------------------------------------------------- --

function WT2022.Outpost:GuardPlayerEntities(_AttackedID)
    if not IsExisting(_AttackedID) or Logic.GetEntityHealth(_AttackedID) == 0 then
        return;
    end
    local Task = Logic.GetCurrentTaskList(_AttackedID);
    local PlayerID = Logic.EntityGetPlayer(_AttackedID);
    local BaseCenter = GetID("P" ..PlayerID.."_BaseCenter");
    if not Task or not string.find(Task, "DIE") then
        if Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.CB_Bastille1) > 0 then
            if Logic.CheckEntitiesDistance(_AttackedID, BaseCenter, 9000) == 1 then
                MakeInvulnerable(_AttackedID)
            else
                MakeVulnerable(_AttackedID);
                if EMS.PlayerList[PlayerID] then
                    EMS.RF.HQRP.UpdateInvulnerabilityStatus(PlayerID);
                end
            end
        else
            MakeVulnerable(_AttackedID);
            if EMS.PlayerList[PlayerID] then
                EMS.RF.HQRP.UpdateInvulnerabilityStatus(PlayerID);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Outpost is captured when damaged enough and no allies remain.
-- (Outpost can not be destroyed)
function Outpost_Internal_OnEntityHurt()
    local Attacker = Event.GetEntityID1();
    local Attacked = Event.GetEntityID2();
    if Attacker and Attacked then
        local AttackedName = Logic.GetEntityName(Attacked);
        if WT2022.Outpost.Outposts[AttackedName] then
            local AttackingPlayer = Logic.EntityGetPlayer(Attacker);
            local OldPlayer = Logic.EntityGetPlayer(Attacked);


            local RealHealth = Logic.GetEntityMaxHealth(Attacked);
            local FakeHealth = WT2022.Outpost.Outposts[AttackedName].Health;
            local MaxHealth = WT2022.Outpost.Outposts[AttackedName].MaxHealth;
            local MinHealth = math.ceil(MaxHealth * 0.30);

            local Damage = Logic.GetEntityDamage(Attacker);
            local Armor = WT2022.Outpost.Outposts[AttackedName].ArmorFactor;
            for i= 1, Armor do
                Damage = Damage * 0.85;
            end
            FakeHealth = math.max(math.ceil(FakeHealth - Damage), MinHealth);
            WT2022.Outpost.Outposts[AttackedName].Health = math.min(FakeHealth, MaxHealth);
            local RelativeHealth = RealHealth * (FakeHealth/MaxHealth);
            SVLib.SetHPOfEntity(Attacked, math.ceil(RelativeHealth));

            if WT2022.Outpost:CanBeClaimed(AttackedName, OldPlayer, AttackingPlayer) then
                local TeamOfAttacker = WT2022.Outpost:GetTeamOfPlayer(AttackingPlayer);
                WT2022.Outpost:ClaimOutpost(AttackedName, OldPlayer, AttackingPlayer, TeamOfAttacker);
            end
        end
    end
end

-- Control the processes of the outpost
function Outpost_Internal_OnEverySecond()
    for k, v in pairs(WT2022.Outpost.Outposts) do
        -- Heal the outpost
        local EntityID = GetID(k);
        local MaxHealth = WT2022.Outpost.Outposts[k].MaxHealth;
        local Health = WT2022.Outpost.Outposts[k].Health;
        if Health < MaxHealth then
            local FakeHealth = WT2022.Outpost.Outposts[k].Health;
            local RealHealth = Logic.GetEntityMaxHealth(GetID(k));
            local RelativeHealth = RealHealth * ((FakeHealth+5)/MaxHealth);
            WT2022.Outpost.Outposts[k].Health = FakeHealth+5;
            SVLib.SetHPOfEntity(EntityID, RelativeHealth);
        end

        -- Produce resources and trigger delivery
        if WT2022.Outpost:CanProduceResources(k) then
            WT2022.Outpost.Outposts[k].ProductCount = v.ProductCount + v.ProductionValue;
            if v.ProductCount >= v.DeliverThreshold then
                WT2022.Outpost.Outposts[k].ProductCount = v.ProductCount - v.DeliverThreshold;
                if GameCallback_User_OutpostProduceResource then
                    GameCallback_User_OutpostProduceResource(k, v.DoorPos, v.OwningTeam, v.ResourceType, v.DeliverThreshold);
                end
            end
        end

        -- Control upgrades
        if v.IsUpgrading then
            local Progress = WT2022.Outpost:GetUpgradeProgress(k);
            if Progress == 1 then
                SVLib.SetPercentageInBuilding(GetID(k), 0);
                WT2022.Outpost:ConcludeUpgrade(k, v.UpgradeType, v.Upgrades[v.UpgradeType].Level);
            else
                SVLib.SetPercentageInBuilding(GetID(k), WT2022.Outpost:GetUpgradeProgress(k));
            end
        end
    end
end

function Outpost_Internal_ControlArmy(_ScriptName)
    local Army = WT2022.Outpost.Outposts[_ScriptName].Army;
	if Army then
	    if math.mod(Logic.GetTime(), 10) == 0 then
            Defend(Army);
		end
	end
end

---
--- Resource Delivery Script
---
--- This script manages the delivery of resources from a position to the
--- destinated player.
---
--- <b>Important:</b> This script is ONLY designed vor 2vs2 games!
---
--- <b>Important:</b> For each of the players a headquarters with the
--- scriptname "HQ" + PlayerID and a script entity wit the scriptname
--- "HQ" + PlayerID + "_DoorPos" must both exist!
---
--- A delivery can be stohlen by another player. This will trigger:
--- <pre>GameCallback_User_PlayerStoleResource(_Receiver, _Team, _ResourceType, _Amount)</pre>
---

WT2022 = WT2022 or {};

WT2022.Delivery = {
    SequenceID = 0,
    Carts = {},
    Teams = {};
}

--- Initalizes the delivery system. Must be called once on game start.
--- @param _T1P1 number Member 1 of team 1
--- @param _T1P2 number Member 2 of team 1
--- @param _DP1  number Delivery NPC player for team 1
--- @param _T2P1 number Member 1 of team 2
--- @param _T2P2 number Member 2 of team 2
--- @param _DP2  number Delivery NPC player for team 2
function WT2022.Delivery.Init(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    WT2022.Delivery:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2);
end

--- Sends a cart from a position to a player.
--- @param _SenderID     number PlayerID of cart
--- @param _ReceiverID   number Player the cart travels to
--- @param _Position     any    Spawnpoint of cart
--- @param _ResourceType number Resource type to be delivered
--- @param _Amount       number Amount of delivered resource
function WT2022.Delivery.SendCart(_SenderID, _ReceiverID, _Position, _ResourceType, _Amount)
    WT2022.Delivery:CreateCart(_SenderID, _ReceiverID, _Position, _ResourceType, _Amount);
end

-- -------------------------------------------------------------------------- --

function WT2022.Delivery:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    -- Setup diplomacy
    self.Teams[1] = {_T1P1, _T1P2, Deliverer = _DP1};
    self.Teams[2] = {_T2P1, _T2P2, Deliverer = _DP2};
    SetHostile(self.Teams[1][1], self.Teams[2].Deliverer);
    SetHostile(self.Teams[1][2], self.Teams[2].Deliverer);
    SetHostile(self.Teams[2][1], self.Teams[1].Deliverer);
    SetHostile(self.Teams[2][2], self.Teams[1].Deliverer);
    -- Set exploration
    Logic.SetShareExplorationWithPlayerFlag(_T1P1, _DP1, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T1P2, _DP1, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T2P1, _DP2, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T2P2, _DP2, 1);

    -- Controller Job
    if not self.ControllerJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_EVERY_SECOND,
            "",
            "Delivery_Internal_OnEverySecond",
            1
        );
        self.ControllerJobID = JobID;
    end
    -- Attacked Job
    if not self.DamageJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
            "",
            "Delivery_Internal_OnEntityHurt",
            1
        );
        self.DamageJobID = JobID;
    end
end

function WT2022.Delivery:CreateCart(_SenderID, _ReceiverID, _Position, _ResourceType, _Amount)
    if type(_Position) ~= "table" then
        _Position = GetPosition(_Position);
    end
    self.SequenceID = self.SequenceID +1;
    local ID = AI.Entity_CreateFormation(_SenderID, Entities.PU_Serf, nil, 0, _Position.X, _Position.Y, nil, nil, 0, 0);
	Logic.SetEntityName(ID, "WT2022_Delivery" ..self.SequenceID);
    SVLib.SetInvisibility(ID, true);
    MakeInvulnerable("WT2022_Delivery" ..self.SequenceID);
    self.Carts["WT2022_Delivery" ..self.SequenceID] = {
        OriginalReceiver = _ReceiverID,
        Receiver = _ReceiverID,
        Destination = "HQ" .._ReceiverID.. "_DoorPos",
        ResourceType = _ResourceType,
        Amount = _Amount,
    };
end

function WT2022.Delivery:ChangeDeliveryReceiver(_ScriptName, _PlayerID, _ReceiverPlayerID)
    if not self.Carts[_ScriptName] then
        return;
    end
    assert(IsExisting("HQ" .._ReceiverPlayerID.. "_DoorPos"));
    self.Carts[_ScriptName].Receiver = _ReceiverPlayerID;
    self.Carts[_ScriptName].Destination = "HQ" .._ReceiverPlayerID.. "_DoorPos";
    ChangePlayer(_ScriptName, _PlayerID);
    MakeInvulnerable(_ScriptName);
end

function WT2022.Delivery:ConcludeDelivery(_Data)
    if _Data.OriginalReceiver ~= _Data.Receiver then
        if GameCallback_User_PlayerStoleResource then
            GameCallback_User_PlayerStoleResource(
                _Data.Receiver,
                WT2022.Delivery:GetTeamOfPlayer(_Data.Receiver),
                _Data.ResourceType,
                _Data.Amount
            );
        end
    end
    -- Main resource
    Logic.AddToPlayersGlobalResource(_Data.Receiver, _Data.ResourceType, _Data.Amount);
end

function WT2022.Delivery:GetDelivererPlayerID(_PlayerID)
    local Team = WT2022.Delivery:GetTeamOfPlayer(_PlayerID);
    if self.Teams[Team] then
        return self.Teams[Team].Deliverer;
    end
    return 0;
end

function WT2022.Delivery:GetTeamOfPlayer(_PlayerID)
    for i= 1, 2 do
        if self.Teams[i][1] == _PlayerID or self.Teams[i][2] == _PlayerID then
            return i;
        end
    end
    return 0;
end

-- -------------------------------------------------------------------------- --

-- Change the PlayerID of carts when they are attacked aka captured
-- (Only thieves can capture a resource cart. By killing the thieves the
-- receiving team can prevent being robbed.)
function Delivery_Internal_OnEntityHurt()
    local Attacker = Event.GetEntityID1();
    local Attacked = Event.GetEntityID2();
    if Attacker and Attacked then
        local AttackedName = Logic.GetEntityName(Attacked);
        if WT2022.Delivery.Carts[AttackedName] then
			-- Make trader invincible
            local Health = Logic.GetEntityHealth(Attacked)
            local Task = Logic.GetCurrentTaskList(Attacked);
            if Health > 0 and (not Task or not string.find(Task, "DIE")) then
                Logic.HealEntity(Attacked, 700);
            end
            MakeInvulnerable(AttackedName);

            -- Check trader attacked by thieves
            if Logic.GetEntityType(Attacker) == Entities.PU_Thief then
                local AttackerPlayerID = Logic.EntityGetPlayer(Attacker);
                local Position = GetPosition(AttackedName);
                local Deliverer = WT2022.Delivery:GetDelivererPlayerID(AttackerPlayerID);
                if Deliverer > 0 then
                    if Logic.IsEntityMoving(Attacked) == true then
                        Logic.MoveSettler(Attacked, Position.X, Position.Y);
                    end
                    WT2022.Delivery:ChangeDeliveryReceiver(AttackedName, Deliverer, AttackerPlayerID);
                end
            end
        end
    end
end

-- Control delivery of resources
function Delivery_Internal_OnEverySecond()
    for k, v in pairs(WT2022.Delivery.Carts) do
        if not IsExisting(k) then
            WT2022.Delivery.Carts[k] = nil;
        else
            if Logic.GetEntityType(GetID(k)) ~= Entities.PU_Travelling_Salesman then
                local ID = ReplaceEntity(k, Entities.PU_Travelling_Salesman);
                MakeInvulnerable(ID);
            end
            if Logic.IsEntityMoving(GetID(k)) == false then
                local Position = GetPosition(v.Destination);
                Logic.MoveSettler(GetID(k), Position.X, Position.Y);
            end
            if IsNear(k, v.Destination, 300) then
                WT2022.Delivery:ConcludeDelivery(v);
                DestroyEntity(k);
            end
        end
    end
end

---
--- Victory Condition Script
---
--- This script checks if any team has won.
---
--- <b>Important:</b> This script is ONLY designed vor 2vs2 games!
---

WT2022 = WT2022 or {};

WT2022.Victory = {
    Teams = {},
    HeroTagList = {},
    ResHeapList = {},

    StohlenResource = {
        VictoryThreshold = 10000,
    },
    ControlledOutposts = {
        Timer = -1,
        MaxAmount = 0,
    },
}

--- Initalizes the victory conditions. Must be called once on game start.
--- @param _T1P1 number Member 1 of team 1
--- @param _T1P2 number Member 2 of team 1
--- @param _DP1  number Delivery NPC player for team 1
--- @param _T2P1 number Member 1 of team 2
--- @param _T2P2 number Member 2 of team 2
--- @param _DP2  number Delivery NPC player for team 2
function WT2022.Victory.Init(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    WT2022.Victory:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2);
end

--- Registers that a team has stohlen a quantity of resources.
--- @param _TeamID number ID of team
--- @param _Amount number Amount of resource
function WT2022.Victory.RegisterTheft(_TeamID, _Amount)
    WT2022.Victory:AddToStohlenResources(_TeamID, _Amount);
end

--- Registers that a team has conquered an outpost.
--- @param _PlayerID   number ID of team
--- @param _ScriptName string Scriptname of outpost
function WT2022.Victory.RegisterClaim(_PlayerID, _ScriptName)
    local TeamID = WT2022.Victory:GetTeamOfPlayer(_PlayerID);
    WT2022.Victory:SaveClaimedOutpost(_ScriptName, TeamID);
end

--- Changes the total amount of outposts to be claimed.
--- @param _Amount number Amount of outposts
function WT2022.Victory.SetOutpostAmount(_Amount)
    WT2022.Victory:SetMaximumOutpostAmount(_Amount);
end

--- Changes the total amount of resources to be stohlen.
--- @param _Amount number Amount of Resources
function WT2022.Victory:SetResourceAmount(_Amount)
    WT2022.Victory:SetResourceVictoryAmount(_Amount)
end

--- Activates the timer for victory.
--- @param _Time number Max time (-1 to disable)
function WT2022.Victory.SetTimer(_Time)
    WT2022.Victory:SetTimerSeconds(_Time);
end

-- -------------------------------------------------------------------------- --

function WT2022.Victory:Setup(_T1P1, _T1P2, _DP1, _T2P1, _T2P2, _DP2)
    -- Setup diplomacy
    MultiplayerTools.Teams = {
        [1] = {_T1P1, _T1P2},
        [2] = {_T2P1, _T2P2},
    }
    self.Teams[1] = {_T1P1, _T1P2, Deliverer = _DP1};
    self.Teams[2] = {_T2P1, _T2P2, Deliverer = _DP2};
    SetFriendly(_T1P1, _T2P1);
    SetFriendly(_T1P2, _T2P2);
    SetHostile(_T1P1, _T2P1);
    SetHostile(_T1P2, _T2P2);
    -- Set exploration
    Logic.SetShareExplorationWithPlayerFlag(_T1P1, _T1P2, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T1P2, _T1P1, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T2P1, _T2P2, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T2P2, _T2P1, 1);
    Logic.SetShareExplorationWithPlayerFlag(_T1P1, _T2P1, 0);
    Logic.SetShareExplorationWithPlayerFlag(_T1P2, _T2P2, 0);
    Logic.SetShareExplorationWithPlayerFlag(_T2P1, _T1P1, 0);
    Logic.SetShareExplorationWithPlayerFlag(_T2P2, _T1P2, 0);

    for i= 1,8 do
        self.HeroTagList[i] = {};
        self.ResHeapList[i] = {};
    end

    self.StohlenResource[1] = 0;
    self.StohlenResource[2] = 0;

    self.ControlledOutposts[1] = {};
    self.ControlledOutposts[2] = {};

    -- Controller Job
    if not self.ControllerJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_EVERY_SECOND,
            "",
            "Victory_Internal_OnEverySecond",
            1
        );
        self.ControllerJobID = JobID;
    end
    -- Hero Hurt Job
    if not self.HeroHurtTriggerJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
            "",
            "Victory_Internal_OnEntityHurt",
            1
        );
        self.HeroHurtTriggerJobID = JobID;
    end
    -- Hero Placer Job
    if not self.HeroRespawnJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_EVERY_TURN,
            "",
            "Victory_Internal_OnEveryTurn",
            1
        );
        self.HeroRespawnJobID = JobID;
    end
    -- Controller player defeat
    if not self.PlayerDefeatJobID then
        local JobID = Trigger.RequestTrigger(
            Events.LOGIC_EVENT_EVERY_SECOND,
            "",
            "Victory_Internal_OnPlayerDestroyed",
            1
        );
        self.PlayerDefeatJobID = JobID;
    end
    self:OverwriteTechraceInterface();
    self:OverwriteSelfDestruct();
end

function WT2022.Victory:Victory(_WinningTeam)
    for i= 1, 2 do
        if i == _WinningTeam then
            Logic.PlayerSetGameStateToWon(self.Teams[i][1]);
            Logic.PlayerSetGameStateToWon(self.Teams[i][2]);
        else
            Logic.PlayerSetGameStateToLost(self.Teams[i][1]);
            Logic.PlayerSetGameStateToLost(self.Teams[i][2]);
        end
    end
end

function WT2022.Victory:SetTimerSeconds(_Amount)
    self.ControlledOutposts.Timer = _Amount;
end

function WT2022.Victory:SetMaximumOutpostAmount(_Amount)
    self.ControlledOutposts.MaxAmount = _Amount;
end

function WT2022.Victory:SetResourceVictoryAmount(_Amount)
    self.StohlenResource.VictoryThreshold = _Amount;
end

function WT2022.Victory:SaveClaimedOutpost(_ScriptName, _TeamID)
    for i= 1, 2 do
        for j= table.getn(self.ControlledOutposts[i]), 1, -1 do
            if self.ControlledOutposts[i][j] == _ScriptName then
                table.remove(self.ControlledOutposts[i], j);
            end
        end
    end
    if _TeamID > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        table.insert(self.ControlledOutposts[_TeamID], _ScriptName);
    end
end

function WT2022.Victory:AddToStohlenResources(_TeamID, _Amount)
    if _TeamID or _TeamID ~= 0 and self.StohlenResource[_TeamID] then
        self.StohlenResource[_TeamID] = self.StohlenResource[_TeamID] + _Amount;
    end
end

function WT2022.Victory:CheckLastStandingTeam()
    local DeadTeam = 0;
    for i= 1, 2 do
        local AnyLive = false;
        for j= 1, 2 do
            local HQ1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(j, Entities.PB_Headquarters1);
            local HQ2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(j, Entities.PB_Headquarters2);
            local HQ3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(j, Entities.PB_Headquarters3);
            if HQ1 + HQ2 + HQ3 > 0 then
                AnyLive = true;
                break;
            end
        end
        if not AnyLive then
            DeadTeam = i;
            break;
        end
    end
    return 0;
end

function WT2022.Victory:CheckStohlenAmountFavoredTeam()
    if self.StohlenResource[1] - self.StohlenResource[2] >= self.StohlenResource.VictoryThreshold then
        return 1;
    end
    if self.StohlenResource[2] - self.StohlenResource[1] >= self.StohlenResource.VictoryThreshold then
        return 2;
    end
    return 0;
end

function WT2022.Victory:CheckOutpostAmountFavoredTeam()
    if self.ControlledOutposts.MaxAmount > 0 then
        if self.ControlledOutposts[1] then
            local Amount = table.getn(self.ControlledOutposts[1]);
            if Amount >= self.ControlledOutposts.MaxAmount then
                if self:IsTimerVisible() then
                    self.ControlledOutposts.Timer = self.ControlledOutposts.Timer -1;
                    if self.ControlledOutposts.Timer == 0 then
                        return 1;
                    end
                end
            end
        end
        if self.ControlledOutposts[2] then
            local Amount = table.getn(self.ControlledOutposts[2]);
            if Amount >= self.ControlledOutposts.MaxAmount then
                self.ControlledOutposts.Timer = self.ControlledOutposts.Timer -1;
                if self:IsTimerVisible() then
                    self.ControlledOutposts.Timer = self.ControlledOutposts.Timer -1;
                    if self.ControlledOutposts.Timer == 0 then
                        return 2;
                    end
                end
            end
        end
    end
    return 0;
end

function WT2022.Victory:DoesOneTeamControllAllOutposts()
    if self.ControlledOutposts.MaxAmount > 0 then
        if (self.ControlledOutposts[1] and table.getn(self.ControlledOutposts[1]) >= self.ControlledOutposts.MaxAmount)
        or (self.ControlledOutposts[2] and table.getn(self.ControlledOutposts[2]) >= self.ControlledOutposts.MaxAmount) then
            return true;
        end
    end
    return false;
end

function WT2022.Victory:IsTimerVisible()
    if self:DoesOneTeamControllAllOutposts() then
        return self.ControlledOutposts.Timer >= 0;
    end
    return false;
end

function WT2022.Victory:DisplayFavoredTeam()
    local Provinces1 = table.getn(self.ControlledOutposts[1]);
    local Provinces2 = table.getn(self.ControlledOutposts[2]);
    local Resources1 = math.max(self.StohlenResource[1] - self.StohlenResource[2], 0);
    local Resources2 = math.max(self.StohlenResource[2] - self.StohlenResource[1], 0);
    local OutpostMax = self.ControlledOutposts.MaxAmount;
    local ResourceMax = self.StohlenResource.VictoryThreshold;

    self:HideAllPointRatios();
	self:DisplayPointRatio(1, "Eroberte Provinzen", Provinces1, Provinces2, OutpostMax);
    self:DisplayPointRatio(2, "Gestohlene Rohstoffe", Resources1, Resources2, ResourceMax);
end

function WT2022.Victory:OverwriteTechraceInterface()
    WT2022.Victory.GUIUpdate_VCTechRaceColor = GUIUpdate_VCTechRaceColor;
    GUIUpdate_VCTechRaceColor = function(_Color)
    end

    WT2022.Victory.GUIUpdate_VCTechRaceProgress = GUIUpdate_VCTechRaceProgress;
    GUIUpdate_VCTechRaceProgress = function()
    end

    WT2022.Victory.GUIUpdate_GetTeamPoints = GUIUpdate_GetTeamPoints;
    GUIUpdate_GetTeamPoints = function()
    end
end

function WT2022.Victory:HideAllPointRatios()
    local Screen = {GUI.GetScreenSize()}
    XGUIEng.SetWidgetPositionAndSize("VCMP_Window", 0, 0, Screen[1], Screen[2]);
    XGUIEng.ShowWidget("VCMP_Window", 1);
    for i= 1, 8 do
        XGUIEng.ShowWidget("VCMP_Team" ..i, 0);
        XGUIEng.ShowWidget("VCMP_Team" ..i.. "_Shade", 0);
    end
end

function WT2022.Victory:DisplayPointRatio(_Index, _Name, _Value1, _Value2, _Max)
    local Screen = {GUI.GetScreenSize()}
    local XRatio = (1024/Screen[1]);
    local YRatio = (768/Screen[2]);
    local ScreenX = Screen[1] * XRatio;
    local ScreenY = Screen[2] * YRatio;
    local W = 500 * XRatio;
    local H = 25 * YRatio;
    local H1 = 10 * YRatio;
    local X = (ScreenX/2) - (W/2);
    local Y = 95 + ((30*YRatio) * (_Index-1));
    local X1 = 0;
    local W1 = W * (_Value1/_Max);
    local W2 = W * (_Value2/_Max);
    local X2 = W - W2;

    XGUIEng.SetWidgetPositionAndSize("VCMP_Team" .._Index, X, Y, W, H);
    XGUIEng.SetWidgetPositionAndSize("VCMP_Team" .._Index.. "_Shade", X, Y, W, H);
    XGUIEng.SetWidgetPositionAndSize("VCMP_Team" .._Index.. "Name", X, Y, W, H);
    XGUIEng.SetWidgetPositionAndSize("VCMP_Team" .._Index.. "Player1", X1, H-H1, W1, H1);
    XGUIEng.SetWidgetPositionAndSize("VCMP_Team" .._Index.. "Player2", X2, H-H1, W2, H1);
    XGUIEng.SetMaterialColor("VCMP_Team" .._Index.. "Player1", 0, 125, 45, 45, 255);
    XGUIEng.SetMaterialColor("VCMP_Team" .._Index.. "Player2", 0, 45, 45, 125, 255);
    XGUIEng.SetMaterialColor("VCMP_Team" .._Index.. "Name", 0, 0, 0, 0, 0);

    XGUIEng.ShowWidget("VCMP_Team" .._Index, 1);
    XGUIEng.ShowWidget("VCMP_Team" .._Index.. "_Shade", 1);
    XGUIEng.ShowWidget("VCMP_Team1" .._Index.. "PointBG", 0);
    for i= 3, 8 do
        XGUIEng.ShowWidget("VCMP_Team" .._Index.. "Player" ..i, 0);
    end
    XGUIEng.SetText("VCMP_Team" .._Index.. "Name", "@center " .._Name);
end

function WT2022.Victory:GetTeamOfPlayer(_PlayerID)
    for i= 1, 2 do
        if self.Teams[i][1] == _PlayerID or self.Teams[i][2] == _PlayerID then
            return i;
        end
    end
    return 0;
end

-- -------------------------------------------------------------------------- --

function WT2022.Victory:OverwriteSelfDestruct()
    if Network_Handler_Diplomacy_Self_Destruct_Helper then
        Network_Handler_Diplomacy_Self_Destruct_Helper_Orig_WT2022 = Network_Handler_Diplomacy_Self_Destruct_Helper;
        Network_Handler_Diplomacy_Self_Destruct_Helper = function(pid, type)
            if  type ~= Entities.CB_Bastille1
            and type ~= Entities.CB_Evil_Tower1_ArrowLauncher
            and type ~= Entities.CB_Evil_Tower1 then
                Network_Handler_Diplomacy_Self_Destruct_Helper_Orig_WT2022(pid, type)
            end
        end
    end
end

function WT2022.Victory:ForcedSelfDesctruct(_PlayerID)
    Logic.PlayerSetGameStateToLost(_PlayerID);
    if not Network_Handler_Diplomacy_Self_Destruct_Helper then
        return;
    end

    local destroy_later = {
        [Entities.PB_Headquarters1] = true;
        [Entities.PB_Headquarters2] = true;
        [Entities.PB_Headquarters3] = true;
        [Entities.PB_Market1] = true;
        [Entities.PB_Market2] = true;

        [Entities.PB_ClayMine1] = true;
        [Entities.PB_ClayMine2] = true;
        [Entities.PB_ClayMine3] = true;

        [Entities.PB_IronMine1] = true;
        [Entities.PB_IronMine2] = true;
        [Entities.PB_IronMine3] = true;

        [Entities.PB_StoneMine1] = true;
        [Entities.PB_StoneMine2] = true;
        [Entities.PB_StoneMine3] = true;

        [Entities.PB_SulfurMine1] = true;
        [Entities.PB_SulfurMine2] = true;
        [Entities.PB_SulfurMine3] = true;

        [Entities.PB_Outpost1] = true;
        [Entities.PB_Outpost2] = true;
        [Entities.PB_Outpost3] = true;
    };
    for k,v in pairs(Entities) do
        if not destroy_later[v] then
            Network_Handler_Diplomacy_Self_Destruct_Helper(_PlayerID, v);
        end;
    end;
    for k,v in pairs(destroy_later) do
        Network_Handler_Diplomacy_Self_Destruct_Helper(_PlayerID, k);
    end;
end

-- -------------------------------------------------------------------------- --

function WT2022.Victory:CreateCompensationHeap(_ScriptName, _OldPlayer, _NewPlayer)
    -- Only if just the humans are involved
    if _OldPlayer > 4 or _NewPlayer > 4 then
        return;
    end
    local OldTeam = self:GetTeamOfPlayer(_OldPlayer);
    local NewTeam = self:GetTeamOfPlayer(_NewPlayer);
    -- Only if new owner is other team
    if OldTeam == NewTeam then
        return;
    end

    -- Create heap
    local HeapPos = self:GetCompensationResourceHeapName(_ScriptName, _OldPlayer);
    local ID = GetID(HeapPos.. "Heap");
    if ID == 0 then
        local x,y,z = Logic.EntityGetPos(GetID(HeapPos));
        local EntityType = self:GetCompensationResourceHeapType(_ScriptName);
        ID = Logic.CreateEntity(EntityType, x, y, 0, 0);
        Logic.SetEntityName(ID, HeapPos.. "Heap");
    end
    Logic.SetResourceDoodadGoodAmount(ID, 2000);
end

function WT2022.Victory:GetCompensationResourceHeapType(_ScriptName)
    local Resource = WT2022.Outpost.GetResourceType(_ScriptName);
    if Resource == -1 then
        return;
    end
    local EntityType = Entities.XD_Clay1;
    if Resource == ResourceType.IronRaw then
        EntityType = Entities.XD_Iron1;
    end
    if Resource == ResourceType.SulfurRaw then
        EntityType = Entities.XD_Sulfur1;
    end
    if Resource == ResourceType.StoneRaw then
        EntityType = Entities.XD_Stone1;
    end
    return EntityType;
end

function WT2022.Victory:GetCompensationResourceHeapName(_ScriptName, _OldPlayer)
    local Resource = WT2022.Outpost.GetResourceType(_ScriptName);
    if Resource == -1 then
        return;
    end
    local ScriptName = "P" .._OldPlayer.. "_CompClay";
    if Resource == ResourceType.IronRaw then
        ScriptName = "P" .._OldPlayer.. "_CompIron";
    end
    if Resource == ResourceType.SulfurRaw then
        ScriptName = "P" .._OldPlayer.. "_CompSulfur";
    end
    if Resource == ResourceType.StoneRaw then
        ScriptName = "P" .._OldPlayer.. "_CompStone";
    end
    return ScriptName;
end

-- -------------------------------------------------------------------------- --

function WT2022.Victory:SaveHeroAttacked(_AttackerID, _AttackedID)
    local PlayerID = Logic.EntityGetPlayer(_AttackedID);
    self.HeroTagList[PlayerID][_AttackedID] = 15;
end

function WT2022.Victory:ControlHeroAttacked()
    for i= 1, 8 do
        for k, v in pairs(self.HeroTagList[i]) do
            if not IsExisting(k) then
                self.HeroTagList[i][k] = nil;
            else
                self.HeroTagList[i][k] = v - 1;
                if v <= 0 then
                    self.HeroTagList[i][k] = nil;
                else
                    if Logic.GetEntityHealth(k) == 0 then
                        local x,y,z = Logic.EntityGetPos(k);
                        local Color = " @color:"..table.concat({GUI.GetPlayerColor(i)}, ",");
                        local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(k));
                        local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
                        Message(Color.. " " ..Name.. " @color:255,255,255 muss sich in die Burg zurückziehen!");
                        Logic.CreateEffect(GGL_Effects.FXDieHero, x, y, i);
                        local ID = SetPosition(k, GetPosition("HQ" ..i.. "_DoorPos"));
                        Logic.HurtEntity(ID, Logic.GetEntityHealth(ID));
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Victory_Internal_OnEntityHurt()
    local Attacker = Event.GetEntityID1();
    local Attacked = Event.GetEntityID2();
    if Attacker and Attacked then
        if Logic.IsHero(Attacked) == 1 then
            WT2022.Victory:SaveHeroAttacked(Attacker, Attacked);
        end
    end
end

function Victory_Internal_OnPlayerDestroyed()
    for i= 1, 4 do
        if Logic.PlayerGetGameState(i) == 1 then
            local HQ1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Headquarters1);
            local HQ2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Headquarters2);
            local HQ3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(i, Entities.PB_Headquarters3);
            if HQ1 + HQ2 + HQ3 == 0 then
                WT2022.Victory:ForcedSelfDesctruct(i);
                if GameCallback_User_PlayerDefeated then
                    GameCallback_User_PlayerDefeated(i, WT2022.Victory:GetTeamOfPlayer(i));
                end
            end
        end
    end
end

function Victory_Internal_OnEveryTurn()
    WT2022.Victory:ControlHeroAttacked();
end

function Victory_Internal_OnEverySecond()
    local WinningTeam = 0;

    -- Check opponents defeated
    WinningTeam = WT2022.Victory:CheckLastStandingTeam();
    if WinningTeam ~= 0 then
        WT2022.Victory:Victory(WinningTeam);
        return true;
    end

    WT2022.Victory:DisplayFavoredTeam();

    -- Check stohlen resource amount
    WinningTeam = WT2022.Victory:CheckStohlenAmountFavoredTeam();
    if WinningTeam ~= 0 then
        WT2022.Victory:Victory(WinningTeam);
        return true;
    end

    -- Check has captured all outposts
    WinningTeam = WT2022.Victory:CheckOutpostAmountFavoredTeam();
    if WinningTeam ~= 0 then
        WT2022.Victory:Victory(WinningTeam);
        return true;
    end
end

---
--- Comforts
---

function CopyTable(_Source, _Dest)
    _Dest = _Dest or {};
    assert(_Source ~= nil, "CopyTable: Source is nil!");
    assert(type(_Dest) == "table");

    for k, v in pairs(_Source) do
        if type(v) == "table" then
            _Dest[k] = _Dest[k] or {};
            for kk, vv in pairs(CopyTable(v)) do
                _Dest[k][kk] = _Dest[k][kk] or vv;
            end
        else
            _Dest[k] = _Dest[k] or v;
        end
    end
    return _Dest;
end

function KeyOf(_wert, _table)
    if _table == nil then return false end
    for k, v in pairs(_table) do
        if v == _wert then
            return k
        end
    end
    return nil
end

function Round( _n )
	return math.floor( _n + 0.5 );
end

function AreEnemiesInArea( _player, _position, _range)
    return AreEntitiesOfDiplomacyStateInArea(_player, _position, _range, Diplomacy.Hostile);
end

function AreAlliesInArea( _player, _position, _range)
    return AreEntitiesOfDiplomacyStateInArea(_player, _position, _range, Diplomacy.Friendly);
end

function AreEntitiesOfDiplomacyStateInArea(_player, _Position, _range, _state)
    local Position = _Position;
    if type(Position) ~= "table" then
        Position = GetPosition(Position);
    end
    for i = 1, 8 do
        if i ~= _player and Logic.GetDiplomacyState(_player, i) == _state then
            if Logic.IsPlayerEntityOfCategoryInArea(i, Position.X, Position.Y, _range, "DefendableBuilding", "Military", "MilitaryBuilding") == 1 then
                return true;
            end
        end
    end
    return false;
end

function ConvertSecondsToString(_TotalSeconds)
    local TotalMinutes = math.floor(_TotalSeconds / 60);
    local Minutes = math.mod(TotalMinutes, 60);
    if Minutes == 60 then
        Minutes = Minutes -1;
    end
    local Seconds = math.floor(math.mod(_TotalSeconds, 60));
    if Seconds == 60 then
        Minutes = Minutes +1;
        Seconds = Seconds -1;
    end

    local String = "";
    if Minutes < 10 then
        String = String .. "0" .. Minutes .. ":";
    else
        String = String .. Minutes .. ":";
    end
    if Seconds < 10 then
        String = String .. "0" .. Seconds;
    else
        String = String .. Seconds;
    end
    return String;
end

function GetTeamOfPlayer(_PlayerID)
    if Network.Manager_DoesExist() == 1 then
        return XNetwork.GameInformation_GetPlayerTeam(_PlayerID);
    else
        return _PlayerID;
    end
end

function RemoveResourcesFromPlayer(_PlayerID, _Costs)
	local Gold   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Gold ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.GoldRaw);
    local Clay   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Clay ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.ClayRaw);
	local Wood   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Wood ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.WoodRaw);
	local Iron   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Iron ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.IronRaw);
	local Stone  = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Stone ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.StoneRaw);
    local Sulfur = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Sulfur ) + Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.SulfurRaw);

    if _Costs[ResourceType.Gold] ~= nil and _Costs[ResourceType.Gold] > 0 and Gold >= _Costs[ResourceType.Gold] then
		AddGold(_PlayerID, _Costs[ResourceType.Gold] * (-1));
    end
	if _Costs[ResourceType.Clay] ~= nil and _Costs[ResourceType.Clay] > 0 and Clay >= _Costs[ResourceType.Clay]  then
		AddClay(_PlayerID, _Costs[ResourceType.Clay] * (-1));
	end
	if _Costs[ResourceType.Wood] ~= nil and _Costs[ResourceType.Wood] > 0 and Wood >= _Costs[ResourceType.Wood]  then
		AddWood(_PlayerID, _Costs[ResourceType.Wood] * (-1));
	end
	if _Costs[ResourceType.Iron] ~= nil and _Costs[ResourceType.Iron] > 0 and Iron >= _Costs[ResourceType.Iron] then
		AddIron(_PlayerID, _Costs[ResourceType.Iron] * (-1));
	end
	if _Costs[ResourceType.Stone] ~= nil and _Costs[ResourceType.Stone] > 0 and Stone >= _Costs[ResourceType.Stone] then
		AddStone(_PlayerID, _Costs[ResourceType.Stone] * (-1));
	end
    if _Costs[ResourceType.Sulfur] ~= nil and _Costs[ResourceType.Sulfur] > 0 and Sulfur >= _Costs[ResourceType.Sulfur] then
		AddSulfur(_PlayerID, _Costs[ResourceType.Sulfur] * (-1));
	end
end

function CreateWoodPile( _posEntity, _resources )
    assert( type( _posEntity ) == "string" );
    assert( type( _resources ) == "number" );
    gvWoodPiles = gvWoodPiles or {
        JobID = StartSimpleJob("ControlWoodPiles"),
    };
    local pos = GetPosition( _posEntity );
    local pile_id = Logic.CreateEntity( Entities.XD_SingnalFireOff, pos.X, pos.Y, 0, 0 );
    SetEntityName( pile_id, _posEntity.."_WoodPile" );
    ReplaceEntity( _posEntity, Entities.XD_ResourceTree );
    Logic.SetResourceDoodadGoodAmount( GetEntityId( _posEntity ), _resources*10 );
    table.insert( gvWoodPiles, { ResourceEntity = _posEntity, PileEntity = _posEntity.."_WoodPile", ResourceLimit = _resources*9 } );
end
function ControlWoodPiles()
    for i = table.getn( gvWoodPiles ),1,-1 do
        if Logic.GetResourceDoodadGoodAmount( GetEntityId( gvWoodPiles[i].ResourceEntity ) ) <= gvWoodPiles[i].ResourceLimit then
            DestroyWoodPile( gvWoodPiles[i], i );
        end
    end
end
function DestroyWoodPile( _piletable, _index )
    local pos = GetPosition( _piletable.ResourceEntity );
    DestroyEntity( _piletable.ResourceEntity );
    DestroyEntity( _piletable.PileEntity );
    Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 0 );
    table.remove( gvWoodPiles, _index )
end

function DestroyArmy(_player,_armyId)
    local leaders = ArmyTable[_player][_armyId + 1].IDs
    for i=1,table.getn(leaders) do
		Logic.DestroyGroupByLeader(leaders[i])
    end
end

function GetAllLeader(_player)
    local leaderIds = {}
    local cannonIds = {}
    local numberOfLeaders = Logic.GetNumberOfLeader(_player)
    local cannonCount = 0
    local prevLeaderId = 0
    local existing = {}
    for i=1,numberOfLeaders do
        local nextLeaderId = Logic.GetNextLeader( _player, prevLeaderId )
        if existing[nextLeaderId] then
            cannonCount = cannonCount + 1
        else
            existing[nextLeaderId] = true;
            table.insert(leaderIds,nextLeaderId)
        end
        prevLeaderId = nextLeaderId
    end
    if cannonCount > 0 then
        local tempCannonIds = {}
        for i=1,4 do
            local counter = 0
            counter = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_player, Entities["PV_Cannon"..i])
            if counter > 0 then
                tempCannonIds = {Logic.GetPlayerEntities(_player, Entities["PV_Cannon"..i], counter)}
                table.remove(tempCannonIds,1)
                for j=1,table.getn(tempCannonIds) do
                    table.insert(leaderIds,tempCannonIds[j])
                    table.insert(cannonIds,tempCannonIds[j])
                end
            end
        end
    end
    return leaderIds, cannonIds
end
---
--- Scripting Values
---
--- Grants access to scripting values regardless if original game or HE.
--- (by schmeling65)
---

SVLib = {}

--Test auf HistoryEdition oder GoldEdition
if XNetwork.Manager_IsNATReady then
	SVLib.HistoryFlag =  1
else
	SVLib.HistoryFlag =  0
end

--Setzt ein Entity unsichtbar/sichtbar
function SVLib.SetInvisibility(_id,_flag)
	if _flag then
		if SVLib.HistoryFlag == 1 then
			Logic.SetEntityScriptingValue(_id, -26, 513)
		elseif SVLib.HistoryFlag == 0 then
			Logic.SetEntityScriptingValue(_id, -30, 513)
		end
	else
		if SVLib.HistoryFlag == 1 then
			Logic.SetEntityScriptingValue(_id, -26, 65793)
		elseif SVLib.HistoryFlag == 0 then
			Logic.SetEntityScriptingValue(_id, -30, 65793)
		end
	end
end

--Gibt zurück ob eine Entity unsichtbar ist
--return true/false
function SVLib.GetInvisibility(_id)
	if SVLib.HistoryFlag == 1 then
		if Logic.GetEntityScriptingValue(_id,-26) == 513 then
			return true
		else
			return false
		end
	elseif SVLib.HistoryFlag == 0 then
		if Logic.GetEntityScriptingValue(_id,-30) == 513 then
			return true
		else
			return false
		end
	end
end

--Setzt die Höhe von Gebäuden in %
function SVLib.SetHightOfBuilding(_id,_float)
	Logic.SetEntityScriptingValue(_id,18,Float2Int(_float))
end

--Gibt die Höhe von Gebäuden zurück in %
--return float
function SVLib.GetHightOfBuilding(_id)
	return Int2Float(Logic.GetEntityScriptingValue(_id,18))
end

--Gibt den Leader eines Soldiers im Trupp zurück
function SVLib.GetLeaderOfSoldier(_SoldierID)
	if SVLib.HistoryFlag == 1 then
		return Logic.GetEntityScriptingValue(_SoldierID, 66)
	elseif SVLib.HistoryFlag == 0 then
		return Logic.GetEntityScriptingValue(_SoldierID, 69)
	end
end

--Setzt die Leben einer Entity. Mehr als maximale HP möglich.
--Funktioniert durch Unverwundbarkeit durch
function SVLib.SetHPOfEntity(_id,_HPNumber)
	Logic.SetEntityScriptingValue(_id,-8,_HPNumber)
end

--Gibt die Leben einer Entity zurück
--return Ganzzahl
function SVLib.GetHPOfEntity(_id)
	return Logic.GetEntityScriptingValue(_id,-8)
end

--Setzt den Index in der Tasklist einer Entity
function SVLib.SetTaskSubIndexNumber(_id,_index)
	if SVLib.HistoryFlag == 1 then
		Logic.SetEntityScriptingValue(_id,-18,_index)
	elseif SVLib.HistoryFlag == 0 then
		Logic.SetEntityScriptingValue(_id,-21,_index)
	end
end

--Gibt den momentanen Index in der Tasklist einer Entity
--return Ganzzahl
function SVLib.GetTaskSubIndexNumber(_id)
	if SVLib.HistoryFlag == 1 then
		return Logic.GetEntityScriptingValue(_id,-18)
	elseif SVLib.HistoryFlag == 0 then
		return Logic.GetEntityScriptingValue(_id,-21)
	end
end

--Setzt die Größe einer Entity in % realtiv zur Normalgröße; Nur das Model, nicht da Blocking
function SVLib.SetEntitySize(_id,_float)
	if SVLib.HistoryFlag == 1 then
		Logic.SetEntityScriptingValue(_id,-29,Float2Int(_float))
	elseif SVLib.HistoryFlag == 0 then
		Logic.SetEntityScriptingValue(_id,-33,Float2Int(_float))
	end
end

--Gibt die Größe einer Entity in % relativ zur Normalgröße zurück
--return float
function SVLib.GetEntitySize(_id)
	if SVLib.HistoryFlag == 1 then
		return Int2Float(Logic.GetEntityScriptingValue(_id,-29))
	elseif SVLib.HistoryFlag == 0 then
		return Int2Float(Logic.GetEntityScriptingValue(_id,-33))
	end
end

--Setzt die Resource, die beim Abbauen erhalten wird (ResourceType = ResourceType.<Resourcenname>)
--Ja, man kann damit z.B. Taler oder Wetterenergie oder Glauben haken.
function SVLib.SetResourceType(_id,_ResourceType)
	Logic.SetEntityScriptingValue(_id,8,_ResourceType)
end

--Gibt den ResourcenTyp der Resource zurück
--return Ganzzahl
function SVLib.GetResourceType(_id)
	return Logic.GetEntityScriptingValue(_id,8)
end

--Setzt die Prozentanzahl welche in der Mitte der Gebäude-Entity sichtbar ist (Forschung, Ausbau, etc)
--float 0 <= _float <= 1
function SVLib.SetPercentageInBuilding(_id,_float)
	Logic.SetEntityScriptingValue(_id,20,Float2Int(_float))
end


--Gibt die Prozentanzeige in der Mitte des Gebäudes bzw. des Balkens unten in der GUI zurück
--return 0 <= float <= 1
function SVLib.GetPercentageAtBuilding(_id)
	return Int2Float(Logic.GetEntityScriptingValue(_id,20))
end

--Setzt die SpielerID einer Entity. Ändert NICHT die EntityID. Farbe der Entity wird nicht verändert, nur Lebensbalkenfarbe
-- _playerID PlayerID 0 <= int <= 8/16(Kimis Server)
-- mcb: verwenden auf eigene gefahr: listen im player object werden nicht aktualisiert, kann zu unvorhergesehenem verhalten führen!
function SVLib.SetPlayerID(_id,_playerID)
	if SVLib.HistoryFlag == 1 then
		return Logic.SetEntityScriptingValue(_id,-44,_playerID)
	else
		return Logic.SetEntityScriptingValue(_id,-52,_playerID)
	end
end

--Gibt den Spieler einer Entity zurück
--return PlayerID 0 <= int <= 8/16(Kimis Server)
function SVLib.GetPlayerID(_id)
	if SVLib.HistoryFlag == 1 then
		return Logic.GetEntityScriptingValue(_id,-44)
	else
		return Logic.GetEntityScriptingValue(_id,-52)
	end
end


--Utility Funktionen

function qmod(a, b)
	return a - math.floor(a/b)*b
end

function Int2Float(num)
	if(num == 0) then
		return 0
	end

	local sign = 1

	if(num < 0) then
		num = 2147483648 + num
		sign = -1
	end

	local frac = qmod(num, 8388608)
	local headPart = (num-frac)/8388608
	local expNoSign = qmod(headPart, 256)
	local exp = expNoSign-127
	local fraction = 1
	local fp = 0.5
	local check = 4194304
	for i = 23, 0, -1 do
		if(frac - check) > 0 then
			fraction = fraction + fp
			frac = frac - check
		end
		check = check / 2
		fp = fp / 2
	end
	return fraction * math.pow(2, exp) * sign
end

function bitsInt(num)
	local t={}
	while num>0 do
		local rest=qmod(num, 2)
		table.insert(t,1,rest)
		num=(num-rest)/2
	end
	table.remove(t, 1)
	return t
end

function bitsFrac(num, t)
	for i = 1, 48 do
		num = num * 2
		if(num >= 1) then
			table.insert(t, 1)
			num = num - 1
		else
			table.insert(t, 0)
		end
		if(num == 0) then
			return t
		end
	end
	return t
end

function Float2Int(fval)
	if(fval == 0) then
		return 0
	end

	local signed = false
	if(fval < 0) then
		signed = true
		fval = fval * -1
	end
	local outval = 0;
	local bits
	local exp = 0
	if fval >= 1 then
		local intPart = math.floor(fval)
		local fracPart = fval - intPart
		bits = bitsInt(intPart)
		exp = table.getn(bits)
		bitsFrac(fracPart, bits)
	else
		bits = {}
		bitsFrac(fval, bits)
		while(bits[1] == 0) do
			exp = exp - 1
			table.remove(bits, 1)
		end
		exp = exp - 1
		table.remove(bits, 1)
	end

	local bitVal = 4194304
	local start = 1

	for bpos = start, 23 do
		local bit = bits[bpos]
		if(not bit) then
			break;
		end

		if(bit == 1) then
			outval = outval + bitVal
		end
		bitVal = bitVal / 2
	end

	outval = outval + (exp+127)*8388608

	if(signed) then
		outval = outval - 2147483648
	end

	return outval;
end
----------------------------------------------------------------------------------------------------
OnSilverPileDestroyed = function()
	local entityID = Event.GetEntityID()
    local entityType = Logic.GetEntityType(entityID)

    if entityType == Entities.XD_Silver1 then
		local pos = GetPosition(entityID)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "SilverPileRespawn", 1,{},{pos.X, pos.Y, 20 + math.random(60)})
	end
end
SilverPileRespawn = function(_posX, _posY, _delay)
	if Counter.Tick2("SilverPileRespawn_".._posX.."_".._posY, _delay) then
		Logic.CreateEntity(Entities.XD_Silver1, _posX, _posY, 0, 0)
		Logic.CreateEffect(GGL_Effects.FXHero14_Poison, _posX, _posY)
		Logic.CreateEffect(GGL_Effects.FXHero14_Fear, _posX, _posY)
		CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"), _posX, _posY, 1000, 300)
		return true
	end
end
 