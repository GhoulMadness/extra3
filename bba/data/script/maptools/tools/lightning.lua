--------------------------------------------------------------------------------------------------------------------
------------------------------------------------- Blitzeinschläge & Unwetter ---------------------------------------
--------------------------------------------------------------------------------------------------------------------
if not gvLastTimeLightningRodUsed then
	gvLastTimeLightningRodUsed = -240000
end
Mapsize = Logic.WorldGetSize()
gvLightning = { Range = 245, BaseDamage = 25, DamageAmplifier = 1, AdditionalStrikes = 0,
	--Menge an Blitzen pro Sekunde abhängig von der Fläche der Map
	Amount = math.floor((((Mapsize/100)^2)/70000)+0.5),
	RecentlyDamaged =
	{
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false
	},

	RodProtected =
	{
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false
	}
, 	DamageProofBuildings = {
		[Entities.CB_OldKingsCastleRuin] = true,
		[Entities.CB_Mercenary] = true,
		[Entities.CB_Abbey01] = true,
		[Entities.CB_Abbey02] = true,
		[Entities.CB_Abbey03] = true,
		[Entities.CB_Abbey04] = true,
		[Entities.CB_BarmeciaCastle] = true,
		[Entities.CB_Bastille1] = true,
		[Entities.CB_Camp01] = true,
		[Entities.CB_Camp02] = true,
		[Entities.CB_Camp03] = true,
		[Entities.CB_Camp04] = true,
		[Entities.CB_Camp05] = true,
		[Entities.CB_Camp06] = true,
		[Entities.CB_Camp07] = true,
		[Entities.CB_Camp08] = true,
		[Entities.CB_Camp09] = true,
		[Entities.CB_Camp10] = true,
		[Entities.CB_Camp11] = true,
		[Entities.CB_Camp12] = true,
		[Entities.CB_Camp13] = true,
		[Entities.CB_Camp14] = true,
		[Entities.CB_Camp15] = true,
		[Entities.CB_Camp16] = true,
		[Entities.CB_Camp17] = true,
		[Entities.CB_Camp18] = true,
		[Entities.CB_Camp19] = true,
		[Entities.CB_Camp20] = true,
		[Entities.CB_Camp21] = true,
		[Entities.CB_Camp22] = true,
		[Entities.CB_Camp23] = true,
		[Entities.CB_Camp24] = true,
		[Entities.CB_Castle1] = true,
		[Entities.CB_CleycourtCastle] = true,
		[Entities.CB_CrawfordCastle] = true,
		[Entities.CB_DarkCastle] = true,
		[Entities.CB_DestroyAbleRuinHouse1] = true,
		[Entities.CB_DestroyAbleRuinMonastery1] = true,
		[Entities.CB_DestroyAbleRuinResidence1] = true,
		[Entities.CB_DestroyAbleRuinSmallTower1] = true,
		[Entities.CB_DestroyAbleRuinSmallTower3] = true,
		[Entities.CB_FolklungCastle] = true,
		[Entities.CB_HermitHut1] = true,
		[Entities.CB_InventorsHut1] = true,
		[Entities.CB_KaloixCastle] = true,
		[Entities.CB_MinerCamp1] = true,
		[Entities.CB_MinerCamp2] = true,
		[Entities.CB_MinerCamp3] = true,
		[Entities.CB_MinerCamp4] = true,
		[Entities.CB_MinerCamp5] = true,
		[Entities.CB_MinerCamp6] = true,
		[Entities.CB_MonasteryBuildingSite1] = true,
		[Entities.CB_OldKingsCastle] = true,
		[Entities.CB_RobberyTower1] = true,
		[Entities.CB_Tower1] = true,
		[Entities.CB_SteamMashine] = true,
		[Entities.CB_TechTrader] = true,
		[Entities.XD_WallCorner] = true,
		[Entities.XD_WallDistorted] = true,
		[Entities.XD_WallStraight] = true,
		[Entities.XD_WallStraightGate] = true,
		[Entities.XD_WallStraightGate_Closed] = true,
		[Entities.XD_DarkWallCorner] = true,
		[Entities.XD_DarkWallDistorted] = true,
		[Entities.XD_DarkWallStraight] = true,
		[Entities.XD_DarkWallStraightGate] = true,
		[Entities.XD_DarkWallStraightGate_Closed] = true,
		[Entities.XD_OSO_Wall_Straight1] = true,
		[Entities.XD_OSO_Wall_Straight2] = true,
		[Entities.XD_OSO_Wall_Straight2_90] = true,
		[Entities.XD_OSO_Wall_Straight2_180] = true,
		[Entities.XD_OSO_Wall_Straight2_270] = true,
		[Entities.XD_OSO_Wall_Distorted1] = true,
		[Entities.XD_OSO_Wall_Distorted2] = true,
		[Entities.XD_OSO_Wall_Corner1] = true,
		[Entities.XD_OSO_Wall_Corner2] = true,
		[Entities.XD_OSO_Wall_Corner_Small1] = true,
		[Entities.XD_OSO_Wall_Corner_Small2] = true,
		[Entities.XD_OSO_Wall_Corner_Small3] = true,
		[Entities.XD_OSO_Wall_Tower2] = true,
		[Entities.ZB_ConstructionSite1] = true,
		[Entities.ZB_ConstructionSite2] = true,
		[Entities.ZB_ConstructionSite3] = true,
		[Entities.ZB_ConstructionSite4] = true,
		[Entities.ZB_ConstructionSite5] = true,
		[Entities.ZB_ConstructionSiteArchery1] = true,
		[Entities.ZB_ConstructionSiteBarracks1] = true,
		[Entities.ZB_ConstructionSiteStables1] = true,
		[Entities.ZB_ConstructionSiteBlacksmith1] = true,
		[Entities.ZB_ConstructionSiteFarm1] = true,
		[Entities.ZB_ConstructionSiteResidence1] = true,
		[Entities.ZB_ConstructionSiteMarket1] = true,
		[Entities.ZB_ConstructionSiteMint1] = true,
		[Entities.ZB_ConstructionSiteMonastery1] = true,
		[Entities.ZB_ConstructionSiteIronMine1] = true,
		[Entities.ZB_ConstructionSiteStoneMine1] = true,
		[Entities.ZB_ConstructionSiteSulfurMine1] = true,
		[Entities.ZB_ConstructionSiteStonemason1] = true,
		[Entities.ZB_ConstructionSiteTower1] = true,
		[Entities.ZB_ConstructionSiteUniversity1] = true,
		[Entities.ZB_ConstructionSiteVillageCenter1] = true,
		[Entities.ZB_ConstructionSiteDome1] = true,
		[Entities.ZB_ConstructionSiteCastle1] = true
	},
	IgnoreIDs = {}
}
function gvLightning.IsLightningProofBuilding(_entityID)
	return gvLightning.DamageProofBuildings[Logic.GetEntityType(_entityID)]
end
function Lightning_Job()
	--Blitzeinschläge nur bei Regen
	if Logic.GetWeatherState() == 2 then
		local range = gvLightning.Range + math.random(gvLightning.Range)
		local damage = gvLightning.BaseDamage + math.random(gvLightning.BaseDamage)
		local buildingdamage = (((gvLightning.BaseDamage + math.random(gvLightning.BaseDamage))*3) + math.min(GetCurrentWeatherGfxSet()*5,55)*gvLightning.DamageAmplifier)
		local amount = gvLightning.Amount
		local x,y
		--noch mehr Blitze bei Unwetter und nächtlichem Unwetter (Gfx-Set 11 und 28)
		if GetCurrentWeatherGfxSet() == 11 or GetCurrentWeatherGfxSet() == 28 then
			amount = amount + (gvLightning.Amount *2) + gvLightning.AdditionalStrikes
		end

		for i = 1,amount do
			x = math.random(Mapsize)
			y = math.random(Mapsize)
			if GetDistance({X = x, Y = y},{X = Mapsize/2, Y = Mapsize/2}) <= Mapsize/2 then
				Logic.CreateEffect(GGL_Effects.FXLightning_PerformanceMode,x,y)
				gvLightning.Damage(x,y,range,damage,buildingdamage)
			end
		end

		local pID = GUI.GetPlayerID()
		if gvLightning.RecentlyDamaged[pID] == true then
			Sound.PlayGUISound( Sounds.OnKlick_Select_varg, 92 )
			Sound.PlayGUISound( Sounds.OnKlick_PB_Tower3, 94 )
			Sound.PlayGUISound( Sounds.OnKlick_PB_PowerPlant1, 82 )
			Sound.PlayGUISound(Sounds.AmbientSounds_rainmedium,120)
			Stream.Start("Sounds\\Misc\\SO_buildingdestroymedium.wav",72)
			gvLightning.RecentlyDamaged[pID] = false
		end
    end
end

function gvLightning.Damage(_posX, _posY, _range, _damage, _buildingdamage)

    for eID in CEntityIterator.Iterator(CEntityIterator.NotOfPlayerFilter(0), CEntityIterator.IsSettlerOrBuildingFilter(), CEntityIterator.InCircleFilter(_posX, _posY, _range)) do
		if table_findvalue(gvLightning.IgnoreIDs, eID) == 0 then
			local player = Logic.EntityGetPlayer(eID)
			-- damage for serfs
			if Logic.IsSerf(eID) == 1 then
				-- don't touch npcs
				if Logic.GetEntityName(eID) ~= nil and not IsPlayerHuman(player) then
				else
					Logic.HurtEntity(eID, _damage)
				end
			-- damage for heroes and cannons
			elseif Logic.IsHero(eID) == 1 or Logic.IsEntityInCategory(eID, EntityCategories.Cannon) == 1 then
				if Logic.IsEntityAlive(eID) then
					-- don't touch npcs
					if Logic.GetEntityName(eID) ~= nil and not IsPlayerHuman(Logic.EntityGetPlayer(eID)) then
					else
						local damage = _damage + math.floor(Logic.GetEntityMaxHealth(eID) * 0.8)
						-- da viel gejammert wurde, erleiden story-Helden des Spielers reduzierten dmg
						if Logic.GetEntityName(eID) ~= nil then
							damage = damage / 2
						end
						-- Sonderbehandlung für Dovbar...
						if Logic.GetEntityType(eID) == Entities.PU_Hero13 then
							-- Stone Armor aktiv?
							if gvHero13.TriggerIDs.StoneArmor.DamageStoring[player] then
								-- no damage
								Logic.CreateEffect(GGL_Effects.FXSalimHeal, Logic.GetEntityPosition(eID))
								gvHero13.AbilityProperties.StoneArmor.DamageStored[player] = (gvHero13.AbilityProperties.StoneArmor.DamageStored[player] or 0) + damage
								damage = 0
							end
						end
						if damage > 0 then
							if ExtendedStatistics then
								if damage >= Logic.GetEntityHealth(eID) then
									if Logic.GetEntityType(eID) == Entities.PU_Hero13 then
										OnHeroDied_Action(eID)
									end
									ExtendedStatistics.Players[player].UnitsLostThroughLightning = ExtendedStatistics.Players[player].UnitsLostThroughLightning + 1
								end
								ExtendedStatistics.Players[player].DamageTakenByLightning = ExtendedStatistics.Players[player].DamageTakenByLightning + damage
							end
							Logic.HurtEntity(eID, damage)
						end
					end
				end
			-- damage for other leaders
			elseif Logic.IsLeader(eID) == 1 and Logic.IsHero(eID) == 0 and Logic.IsSettler(eID) == 1 then
				-- don't touch npcs
				if Logic.GetEntityName(eID) ~= nil and not IsPlayerHuman(player) then
				else
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
								ExtendedStatistics.Players[player].UnitsLostThroughLightning = ExtendedStatistics.Players[player].UnitsLostThroughLightning + 1
							end
							ExtendedStatistics.Players[player].DamageTakenByLightning = ExtendedStatistics.Players[player].DamageTakenByLightning + damage
						end
						Logic.HurtEntity(eID, damage)
					end
				end
			-- damage for buildings
			elseif Logic.IsBuilding(eID) == 1 then
				if gvLightning.IsLightningProofBuilding(eID) ~= true then
					if Logic.IsConstructionComplete(eID) == 1 then
						local PID = player
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

			-- damage everything else (e.g. soldiers)
			else
				if Logic.IsEntityAlive(eID) then
					-- don't touch npcs
					if Logic.GetEntityName(eID) ~= nil and not IsPlayerHuman(player) or Logic.IsWorker(eID) == 1 then
					else
						if ExtendedStatistics then
							if _damage >= Logic.GetEntityHealth(eID) then
								ExtendedStatistics.Players[player].UnitsLostThroughLightning = ExtendedStatistics.Players[player].UnitsLostThroughLightning + 1
							end
							ExtendedStatistics.Players[player].DamageTakenByLightning = ExtendedStatistics.Players[player].DamageTakenByLightning + _damage
						end
						Logic.HurtEntity(eID, _damage)
					end
				end
			end
			-- signal for player + limitation sound once per sec
			if GUI.GetPlayerID() == player and gvLightning.IsLightningProofBuilding(eID) ~= true and Logic.IsEntityAlive(eID) then
				gvLightning.RecentlyDamaged[player] = true
				GUI.ScriptSignal(_posX, _posY, 0)
			end
			local count
			if ExtendedStatistics then
				if not count and IsValid(eID) and gvLightning.IsLightningProofBuilding(eID) ~= true and Logic.IsEntityAlive(eID) then
					ExtendedStatistics.Players[player].AmountOfLightningStrikes = ExtendedStatistics.Players[player].AmountOfLightningStrikes + 1
					count = true
				end
			end
		end
	end
end