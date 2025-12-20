--[[
	Author: Play4FuN
	Date: 29.09.2022
	
	Description: A collection of some (minor) functionalities to enhance gameplay look/feeling etc
	Note: Some features are not persistent (savegame)
	Note: Some required functions are NOT included; see p4f_tools or S5Hook for that!
	Note: These functions SHOULD not use col.(...) but the color codes instead!
	
	Contents:
	
	(allow other comforts to add a function that will be executed after a load game)
	AddOnSaveGameLoaded
	
	(overwrite)BuyHeroWindow_Action_BuyHero
	(overwrite)GUI.MPTrade_ChangeResourceAmount
	(overwrite)GetPlayer
	(overwrite)Action_ChestJob
	
	P4FComforts_ImprovedWeatherSets
	P4FComforts_SelectionFix
	P4FComforts_FindButtonFix
	P4FComforts_GroupStrengthFix
	P4FComforts_SoldierCostFix
	P4FComforts_FormationsTechFix
	P4FComforts_FormationsAlwaysEnabled
	P4FComforts_UpgradeHints
	P4FComforts_MarketInfo
	P4FComforts_HeroHealthDisplay
	P4FComforts_HealthRegeneration
	P4FComforts_FreeCamera
	P4FComforts_FormationsMod
	P4FComforts_AutoRefill
	P4FComforts_GroupRefill
	P4FComforts_ReplaceTreeStumps
	P4FComforts_RemoveDroppedEntities
	P4FComforts_CreateDecalsForResourcePiles
	P4FComforts_GrowingTrees
	P4FComforts_Autosave
	P4FComforts_PauseCameraRotation
	P4FComforts_EnableGlobalTroopSelection
	P4FComforts_SerfMenuVideoPreview
	P4FComforts_RefinedResourceView
	P4FComforts_SetRefinedResourceTooltipsMode
	P4FComforts_EnhancedMusic
	P4FComforts_ExtendMusicSetEuropean
	
--]]

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- globals
gvMission = gvMission or {}
--gvMission.PlayerID = gvMission.PlayerID or GUI.GetPlayerID()	-- unhandled crash because this script is loaded after other internal scripts

-- "replace" (re-reference?) first village center technology
Technologies.T_TownGuard = Technologies.T_CityGuard

-- adjust widget positions
XGUIEng.SetWidgetPosition( "Build_PowerPlant", 256, 40 )
XGUIEng.SetWidgetPosition( "Build_Weathermachine", 220, 40 )
XGUIEng.SetWidgetPosition( "Command_Attack", 76, 4 )
XGUIEng.SetWidgetPosition( "Hero1_LookAtHawk", 76, 40 )

-- Build_Stables position: 361, 40
--> it looks like all buttons on the right (including expell unit) should be moved to the right a bit?
XGUIEng.SetWidgetPosition( "Build_Tower", 324, 4 )
XGUIEng.SetWidgetPosition( "Build_Barracks", 361, 4 )
XGUIEng.SetWidgetPosition( "Build_Archery", 398, 4 )

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- add a function to be executed on Mission_OnSaveGameLoaded
-- idea from hero inventory sample map (bobby)
function AddOnSaveGameLoaded( func )
	
	if not OnSaveGameLoaded then
		-- init
		OnSaveGameLoaded = {
			Functions = {},
			OrigFunction = Mission_OnSaveGameLoaded,
		}
		Mission_OnSaveGameLoaded = function()
			OnSaveGameLoaded.OrigFunction()
			for i = 1, table.getn( OnSaveGameLoaded.Functions ) do
				OnSaveGameLoaded.Functions[i]()
			end
		end
	end
	
	table.insert( OnSaveGameLoaded.Functions, func )
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

AddOnSaveGameLoaded( function()
	
	-- "replace" (re-reference?) first village center technology
	Technologies.T_TownGuard = Technologies.T_CityGuard
	
	-- adjust widget positions
	XGUIEng.SetWidgetPosition( "Build_PowerPlant", 256, 40 )
	XGUIEng.SetWidgetPosition( "Build_Weathermachine", 220, 40 )
	XGUIEng.SetWidgetPosition( "Command_Attack", 76, 4 )
	XGUIEng.SetWidgetPosition( "Hero1_LookAtHawk", 76, 40 )
	XGUIEng.SetWidgetPosition( "Build_Tower", 324, 4 )
	XGUIEng.SetWidgetPosition( "Build_Barracks", 361, 4 )
	XGUIEng.SetWidgetPosition( "Build_Archery", 398, 4 )
	
end )

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- avoid assertion
function GetPlayer( _entity )
	local entityId = GetID( _entity )
	if IsValid( entityId ) then
		return Logic.EntityGetPlayer( entityId )
	else
		return 0
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

BuyHeroWindow_Action_BuyHero_Orig = BuyHeroWindow_Action_BuyHero_Orig or BuyHeroWindow_Action_BuyHero
BuyHeroWindow_Action_BuyHero = function(_hero)
	BuyHeroWindow_Action_BuyHero_Orig(_hero)
	if Logic.GetNumberOfBuyableHerosForPlayer( GUI.GetPlayerID() ) < 2 then	-- amount to buy is updated very late!
		XGUIEng.ShowWidget("Buy_Hero", 0)	-- hide it after last hero has been bought (usually hides when HQ is selected again)
	else
		XGUIEng.ShowWidget(gvGUI_WidgetID.BuyHeroWindow, 1)	-- new: keep the menu open for as long as heroes can be bought
	end
end
	
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- press control to add 250 instead of 50
GUI_MPTrade_ChangeResourceAmount_Orig = GUI_MPTrade_ChangeResourceAmount_Orig or GUI.MPTrade_ChangeResourceAmount
GUI.MPTrade_ChangeResourceAmount = function(_destinationPlayer, _deltaAmount)
	if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 1 then
		-- increase amount!
		_deltaAmount = _deltaAmount * 5
	end
	GUI_MPTrade_ChangeResourceAmount_Orig(_destinationPlayer, _deltaAmount)
end
	
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- overwrite action function for ChestJob
-- bugfix: it is possible to have two heroes (chest openers) open the same chest at the same time
--> effectively opening the chest twice + callback
Action_ChestJob = function()
	for i = 1 , table.getn(chestControl.list) , 1 do
		if chestControl.list[i].state == CHEST_CLOSED then
			for j = 1 , table.getn(chestOpener) , 1 do
				if IsNear(chestOpener[j],chestControl.list[i].name,250) then
					chestControl.list[i].callback()
					chestControl.list[i].state = CHEST_OPENED
					ReplaceEntity(chestControl.list[i].name,Entities.XD_ChestOpen)
					Sound.PlayGUISound( Sounds.OnKlick_Select_erec, 0 )
					-- Sound.PlayGUISound(Sounds.Misc_Chat,65)
					break	-- stop right there!
					end
				end
			end
		end
	return false
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- add more weather sets (types) that can also be started non periodic; rain is less annoying
-- adopted from european weather sets
-- added: night (dark and full of terrors); darkness (even darker); snow/rain mixtures

function P4FComforts_ImprovedWeatherSets()	--v3
	Display.SetRenderUseGfxSets(1)
	
	-- normal
	Display.GfxSetSetSkyBox(1, 0.0, 1.0, "YSkyBox07")
	Display.GfxSetSetRainEffectStatus(1, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(1, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(1, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 152,172,182, 5000,22000)
	Display.GfxSetSetLightParams(1,  0.0, 1.0, 40, -15, -50,  120,130,110,  205,204,180)
	
	-- Regen
	Display.GfxSetSetSkyBox(2, 0.0, 1.0, "YSkyBox04")
	Display.GfxSetSetRainEffectStatus(2, 0.0, 1.0, 1)
	Display.GfxSetSetSnowStatus(2, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(2, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(2, 0.0, 1.0, 1, 72,102,112, 5000,12000)
	Display.GfxSetSetLightParams(2,  0.0, 1.0, 40, -15, -50,  70,80,70,  205,204,180)
 
	-- Schnee
	Display.GfxSetSetSkyBox(3, 0.0, 1.0, "YSkyBox01")
	Display.GfxSetSetRainEffectStatus(3, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(3, 0, 1.0, 1)
	Display.GfxSetSetSnowEffectStatus(3, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(3, 0.0, 1.0, 1, 108,128,138, 5000,11000)
	Display.GfxSetSetLightParams(3,  0.0, 1.0, 40, -15, -50,  116,164,164, 255,234,202)
	
	-- schnee - schneefall (tauen)  (mit id 3 verwenden)
	Display.GfxSetSetSkyBox(4, 0.0, 1.0, "YSkyBox01")
	Display.GfxSetSetRainEffectStatus(4, 0.0, 1.0, 1)
	Display.GfxSetSetSnowStatus(4, 0, 1.0, 1)
	Display.GfxSetSetSnowEffectStatus(4, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(4, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(4,  0.0, 1.0,  40, -15, -75,  106,154,154, 255,234,202)
	AddPeriodicThaw = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 4, 5, 15)
	end
	StartThaw = function(dauer)
		Logic.AddWeatherElement(3, dauer, 0, 4, 5, 15)
	end
	
	-- regen + schneefall  (mit id 2 verwenden)
	Display.GfxSetSetSkyBox(5, 0.0, 1.0, "YSkyBox04")
	Display.GfxSetSetRainEffectStatus(5, 0.0, 1.0, 1)
	Display.GfxSetSetSnowStatus(5, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(5, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(5, 0.0, 1.0, 1, 102,132,142, 5000,10500)
	Display.GfxSetSetLightParams(5,  0.0, 1.0, 40, -15, -50,  90,100,80,  205,204,180)
	AddPeriodicSleet = function(dauer)
		Logic.AddWeatherElement(2, dauer, 1, 5, 5, 15)
	end
	StartSleet = function(dauer)
		Logic.AddWeatherElement(2, dauer, 0, 5, 5, 15)
	end
	
	-- schnee + regen (mit id 3 verwenden)
	Display.GfxSetSetSkyBox(6, 0.0, 1.0, "YSkyBox01")
	Display.GfxSetSetRainEffectStatus(6, 0.0, 1.0, 1)
	Display.GfxSetSetSnowStatus(6, 0, 1.0, 1)
	Display.GfxSetSetSnowEffectStatus(6, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(6, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(6,  0.0, 1.0,  40, -15, -75,  106,154,154, 255,234,202)
	AddPeriodicWinterrain = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 6, 5, 15)
	end
	StartWinterrain = function(dauer)
		Logic.AddWeatherElement(3, dauer, 0, 6, 5, 15)
	end
	
	-- schneefall ohne textur  (mit id 1 verwenden)
	Display.GfxSetSetSkyBox(7, 0.0, 1.0, "YSkyBox01")
	Display.GfxSetSetRainEffectStatus(7, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(7, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(7, 0.0, 0.8, 1)
	Display.GfxSetSetFogParams(7, 0.0, 1.0, 1, 152,172,182, 5000,28000)
	Display.GfxSetSetLightParams(7,  0.0, 1.0, 40, -15, -50,  120,130,110,  205,204,180)
	AddPeriodicSummersnow = function(dauer)
		Logic.AddWeatherElement(1, dauer, 1, 7, 5, 15)
	end
	StartSummersnow = function(dauer)
		Logic.AddWeatherElement(1, dauer, 0, 7, 5, 15)
	end
	
	-- schneetextur ohne schneefall    (mit id 3)
	Display.GfxSetSetSkyBox(8, 0.0, 1.0, "YSkyBox01")
	Display.GfxSetSetRainEffectStatus(8, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(8, 0, 1.0, 1)
	Display.GfxSetSetSnowEffectStatus(8, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(8, 0.0, 1.0, 1, 152,172,182, 5000,11000)
	Display.GfxSetSetLightParams(8,  0.0, 1.0,  40, -15, -75,  116,164,164, 255,234,202)
	AddPeriodicSnow = function(dauer)
		Logic.AddWeatherElement(3, dauer, 1, 8, 5, 15)
	end
	StartSnow = function(dauer)
		Logic.AddWeatherElement(3, dauer, 0, 8, 5, 15)
	end
	
	-- night
	Display.GfxSetSetSkyBox(9, 0.0, 1.0, "YSkyBox07")
	Display.GfxSetSetRainEffectStatus(9, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(9, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(9, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(9, 0.0, 1.0, 1, 72,102,112, 5000,12000)
	Display.GfxSetSetLightParams(9,  0.0, 1.0, 40, -15, -50,  100,110,100,  95,94,70)
	AddPeriodicNight = function(dauer)
		Logic.AddWeatherElement(1, dauer, 1, 9, 5, 15)
	end
	StartNight = function(dauer)
		Logic.AddWeatherElement(1, dauer, 0, 9, 5, 15)
	end
	
	-- darkness
	Display.GfxSetSetSkyBox(10, 0.0, 1.0, "YSkyBox07")
	Display.GfxSetSetRainEffectStatus(10, 0.0, 1.0, 0)
	Display.GfxSetSetSnowStatus(10, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(10, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(10, 0.0, 1.0, 1, 72,102,112, 2000,8500)
	Display.GfxSetSetLightParams(10,  0.0, 1.0, 40, -15, -50,  50,40,30,  55,34,10)
	AddPeriodicDarkness = function(dauer)
		Logic.AddWeatherElement(1, dauer, 1, 10, 5, 15)
	end
	StartDarkness = function(dauer)
		Logic.AddWeatherElement(1, dauer, 0, 10, 5, 15)
	end
	
	-- thunder (experimental)
	Display.GfxSetSetSkyBox(11, 0.0, 1.0, "YSkyBox07")
	Display.GfxSetSetRainEffectStatus(11, 0.0, 1.0, 1)
	Display.GfxSetSetSnowStatus(11, 0, 1.0, 0)
	Display.GfxSetSetSnowEffectStatus(11, 0.0, 0.8, 0)
	Display.GfxSetSetFogParams(11, 0.0, 1.0, 1, 72,102,112, 2500,12000)
	Display.GfxSetSetLightParams(11,  0.0, 1.0, 40, -15, -50,  70,80,70,  65,64,40)
	StartThunderstorm = function(dauer)
		Logic.AddWeatherElement(2, dauer, 0, 11, 5, 15)
		P4FComforts_ThunderStart( dauer )
	end
	
end

-- experimental thunderstorm
function P4FComforts_ThunderStart( _duration )
	if not gvThunder then
		P4FComforts_ThunderInit()
	end
	
	local duration = _duration or 30
	local time = Round( Logic.GetTime() )
	
	gvThunder.startTime = time
	gvThunder.endTime = time + duration
	gvThunder.active = true
end

function P4FComforts_ThunderInit()
	gvThunder = {
		active = false,
		startTime = 0,
		endTime = 0,
		effects = {},
		jobId = StartSimpleJob( "SJ_ControlThunder" ),
		range = 500,	-- to burn down trees and hurt units
		treeTable = {
			Entities.XD_AppleTree1,
			Entities.XD_AppleTree2,
			Entities.XD_DarkTree1,
			Entities.XD_DarkTree2,
			Entities.XD_DarkTree3,
			Entities.XD_DarkTree4,
			Entities.XD_DarkTree5,
			Entities.XD_DarkTree6,
			Entities.XD_DarkTree7,
			Entities.XD_DarkTree8,
			Entities.XD_Fir1,
			Entities.XD_Fir1_small,
			Entities.XD_Fir2,
			Entities.XD_Fir2_small,
			Entities.XD_Tree1,
			Entities.XD_Tree1_small,
			Entities.XD_Tree2,
			Entities.XD_Tree2_small,
			Entities.XD_Tree3,
			Entities.XD_Tree3_small,
			Entities.XD_Tree4,
			Entities.XD_Tree5,
			Entities.XD_Tree6,
			Entities.XD_Tree7,
			Entities.XD_Tree8,
			Entities.XD_TreeNorth1,
			Entities.XD_TreeNorth2,
			Entities.XD_TreeNorth3,
			Entities.XD_OrangeTree1,
			Entities.XD_OrangeTree2,
		},
	}
end

function SJ_ControlThunder()
	
	-- remove effects (fire)
	for i = table.getn( gvThunder.effects ), 1, -1 do
		gvThunder.effects[i].duration = gvThunder.effects[i].duration - 1
		local effect = gvThunder.effects[i]
		if effect.duration <= 0 then
			Logic.DestroyEffect( effect.id )
			table.remove( gvThunder.effects, i )
		else
			-- hurt entities in area
			P4FComforts_ThunderHurtEntities( effect.pos )
		end
	end
	
	if not gvThunder.active then
		return
	end
	
	local time = Round( Logic.GetTime() )
	local random = math.random
	
	if time > gvThunder.endTime then
		-- stop it
		gvThunder.active = false
		
		return
	end
	
	-- currently active thunderstorm...
	
	-- TODO: needs some refinement...
	
	-- sometimes create a lightning strike
	if time - gvThunder.startTime > 5 and random() > 0.1 then
		--[[
		local x, y = Camera.ScrollGetLookAt()
		local pos = {
			X = x + random(-2000,2000),
			Y = y + random(-2000,2000),
		}
		--]]
		
		local worldSize = Logic.WorldGetSize()
		local pos = {
			X = random(worldSize-1),
			Y = random(worldSize-1),
		}
		if IsValidPosition( pos ) then
			if Logic.IsMapPositionExplored( 1, pos.X, pos.Y ) == 1 then
				-- visual + sound + fire and damage
				P4FComforts_ThunderStrikePosition( pos )
			elseif random() > 0.8 then
				-- visual + sound only
				local x, y = Camera.ScrollGetLookAt()
				local pos = {
					X = math.min(worldSize, x + 4000),
					Y = math.min(worldSize, y + 4000),
				}
				Logic.Lightning( pos.X, pos.Y )
				Sound.PlayGUISound( Sounds.Military_SO_CannonTowerFire_rnd_1, random(16,32) )
			end
		end
	end
	
end

function P4FComforts_ThunderStrikePosition( _pos )
	
	local random = math.random
	local x = _pos.X
	local y = _pos.Y
	
	Logic.Lightning( x, y )
	Logic.CreateEffect( GGL_Effects.FXExplosion, x, y, 1 )
	Sound.PlayGUISound( Sounds.Military_SO_CannonTowerFire_rnd_1, random(16,32) )
	
	-- the duration a fire remains active (and hurts entities) depends on if there are trees around
	local burnDuration = 2
	
	-- burn down trees...
	for i = 1, table.getn(gvThunder.treeTable) do
		local treeData = { Logic.GetEntitiesInArea( gvThunder.treeTable[i], x, y, gvThunder.range, 16 ) }
		if treeData[1] > 0 then
			for j = 2, treeData[1]+1 do
				local replaceEntity = Entities["XD_DeadTree0"..random(1,2)]
				ReplaceEntity( treeData[j], replaceEntity )
			end
			-- also burn longer when trees are being struck
			burnDuration = random(8,16)
		end
	end
	
	-- create a fire (effect) that remains for a few seconds while dealing damage to nearby units
	local fireId = random(1) == 1 and Logic.CreateEffect( GGL_Effects.FXFire, x, y, 1 ) or Logic.CreateEffect( GGL_Effects.FXFireLo, x, y, 1 )
	table.insert( gvThunder.effects, { id = fireId, duration = burnDuration, pos = _pos, } )
	
end

-- do not hurt walls (or headquarters)
-- do not kill entities
function P4FComforts_ThunderHurtEntities( pos )
	for p = 1, 8 do
		-- note: return maximum is 16 entities
		-- AccessCategories 2 = settler
		local data = { Logic.GetPlayerEntitiesInArea( p, 0, pos.X, pos.Y, gvThunder.range, 16, 2 ) }
		for i = 2, data[1] + 1 do
			local entityId = data[i]
			-- do NOT hurt soldiers (Logic.HurtEntity function does not like that...)
			if Logic.IsLeader( entityId ) == 1 or Logic.IsWorker( entityId ) == 1 or Logic.IsSerf( entityId ) == 1 then
				local pos = GetPos( entityId )
				local damage = 20
				local health = Logic.GetEntityHealth( entityId )
				if health > damage then
					Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, p )
					--Logic.CreateEffect( GGL_Effects.FXBuildingSmoke, pos.X, pos.Y, p )
					Logic.HurtEntity( entityId, damage )
				end
			end
		end
		-- AccessCategories 8 = buildings
		local data = { Logic.GetPlayerEntitiesInArea( p, 0, pos.X, pos.Y, gvThunder.range, 16, 8 ) }
		for i = 2, data[1] + 1 do
			local entityId = data[i]
			-- do NOT hurt walls or headquarters
			if Logic.IsEntityInCategory( entityId, EntityCategories.Wall ) == 0
			and Logic.IsEntityInCategory( entityId, EntityCategories.Headquarters ) == 0 then
				local pos = GetPos( entityId )
				local damage = 20
				local health = Logic.GetEntityHealth( entityId )
				if health > damage then
					Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, p )
					Logic.HurtEntity( entityId, damage )
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- selecting a battle serf will no longer disable formation buttons for leaders
-- enable formation buttons for cavarly

function P4FComforts_SelectionFix()
	GameCallback_GUI_SelectionChanged_Orig = GameCallback_GUI_SelectionChanged_Orig or GameCallback_GUI_SelectionChanged
	GameCallback_GUI_SelectionChanged = function()
		
		GameCallback_GUI_SelectionChanged_Orig()
		
		-- Get selected entity
		local EntityId = GUI.GetSelectedEntity()
		local EntityType = Logic.GetEntityType( EntityId )
		-- local EntityTypeName = Logic.GetEntityTypeName( EntityType )
		
		if EntityType == Entities.PU_BattleSerf then
			XGUIEng.ShowWidget("Commands_Leader", 1)
			-- Commands_generic enable to use defend, patrol etc. commands
			-- plus it enabels to expell battle serfs directly
			XGUIEng.ShowWidget("Commands_generic", 1)
			XGUIEng.ShowWidget(gvGUI_WidgetID.SelectionLeader, 0)	-- formation buttons
		end

		if Logic.IsLeader( EntityId ) == 1 then
			if Logic.IsEntityInCategory(EntityId,EntityCategories.CavalryHeavy) == 1
			or Logic.IsEntityInCategory(EntityId,EntityCategories.CavalryLight) == 1 then
				XGUIEng.ShowWidget(gvGUI_WidgetID.SelectionLeader, 1)
			end
		end

	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- display find buttons even if the player tech level is too low (e.g. find LeaderSword4 when the player has not upgraded swordsman yet)
-- overwrites GUIUpdate_FindView function in updatebuttons.lua
function P4FComforts_FindButtonFix()

	GUIUpdate_FindView = function()
		
		local PlayerID = GUI.GetPlayerID()
		
		-- Serfs
		local SerfAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_Serf )
		if SerfAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindIdleSerf, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindIdleSerf, 0 )
		end	
		
		-- Sword
		local PlayerSwordmenAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderSword1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderSword2 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderSword3 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderSword4 )
		if PlayerSwordmenAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindSwordLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindSwordLeader, 0 )
		end
		
		-- Spear
		local PlayerSpearmenAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderPoleArm1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderPoleArm2 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderPoleArm3 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderPoleArm4 )
		if PlayerSpearmenAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindSpearLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindSpearLeader, 0 )
		end
		
		-- Bow
		local PlayerBowmenAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderBow1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderBow2 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderBow3 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderBow4 )
		if PlayerBowmenAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindBowLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindBowLeader, 0 )
		end
		
		-- light Cavalry
		local PlayerCavalryAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderCavalry1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderCavalry2 )
		if PlayerCavalryAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindLightCavalryLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindLightCavalryLeader, 0 )
		end
		
		-- heavy Cavalry
		local PlayerHeavyCavalryAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderHeavyCavalry1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderHeavyCavalry2 )
		if PlayerHeavyCavalryAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindHeavyCavalryLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindHeavyCavalryLeader, 0 )
		end
		
		-- cannons	
		local Cannon1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PV_Cannon1 )
		local Cannon2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PV_Cannon2 )
		local Cannon3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PV_Cannon3 )
		local Cannon4 = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PV_Cannon4 )
		local CannonAmount = Cannon1 + Cannon2 + Cannon3 + Cannon4
		if CannonAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindCannon, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindCannon, 0 )
		end
		
		-- rifle	
		local PlayerRifleAmount = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderRifle1 )
			+ Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_LeaderRifle2 )
		if PlayerRifleAmount > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindRifleLeader, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindRifleLeader, 0 )
		end
		
		-- Scout
		local Scout = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_Scout )	
		if Scout > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindScout, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindScout, 0 )
		end
		
		-- Thief
		local Thief = Logic.GetNumberOfEntitiesOfTypeOfPlayer( PlayerID, Entities.PU_Thief )	
		if Thief > 0 then
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindThief, 1 )
		else
			XGUIEng.ShowWidget( gvGUI_WidgetID.FindThief, 0 )
		end
		
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- fix the issue with the group strength display (see: updatevalues.lua)
-- if all soldiers are dead the buttons are not disabled correctly after selecting another leader with soldiers

function P4FComforts_GroupStrengthFix()
	GUIUpdate_GroupStrength_P4FComforts = GUIUpdate_GroupStrength_P4FComforts or GUIUpdate_GroupStrength
	GUIUpdate_GroupStrength = function()
		local LeaderID = GUI.GetSelectedEntity()
		if LeaderID == nil then
			return
		end
		local AmountOfSoldiers = Logic.LeaderGetNumberOfSoldiers( LeaderID )
		local MaxAmountOfSoldiers = Logic.LeaderGetMaxNumberOfSoldiers( LeaderID )
		
		-- ?
		XGUIEng.ShowAllSubWidgets( gvGUI_WidgetID.DetailsGroupStrengthSoldiersContainer, 0 )
		
		-- ?
		if MaxAmountOfSoldiers > 16 then
			return
		elseif MaxAmountOfSoldiers > 8 then
			MaxAmountOfSoldiers = math.floor(MaxAmountOfSoldiers / 2)
			AmountOfSoldiers = math.floor(AmountOfSoldiers / 2)
		end
		
		for i = 1, MaxAmountOfSoldiers do
			XGUIEng.ShowWidget( gvGUI_WidgetID.DetailsGroupStrengthSoldiers[i], 1 )
		end
		
		--disable buttons for soldiers, that are dead
		for j = 1, 8 do
			if j <= AmountOfSoldiers then
				XGUIEng.DisableButton( gvGUI_WidgetID.DetailsGroupStrengthSoldiers[j], 0 )
			else
				XGUIEng.DisableButton( gvGUI_WidgetID.DetailsGroupStrengthSoldiers[j], 1 )
			end
		end
		
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- buy soldier tooltip shows the wrong cost if the level of the leader does not match the tech level of the player
-- e.g. selecting a tier 3 bowman will show the cost of a level 1 bowman if the player has not upgraded leader bow

-- cost per soldier, values by mcb
-- confirmed for all listed PU units
SoldierCostTable = {
	[Entities.PU_SoldierSword1] = {[ResourceType.Gold] = 30, [ResourceType.Iron] = 20},
	[Entities.PU_SoldierSword2] = {[ResourceType.Gold] = 40, [ResourceType.Iron] = 30},
	[Entities.PU_SoldierSword3] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 40},
	[Entities.PU_SoldierSword4] = {[ResourceType.Gold] = 60, [ResourceType.Iron] = 50},
	
	[Entities.PU_SoldierPoleArm1] = {[ResourceType.Gold] = 30, [ResourceType.Wood] = 20},
	[Entities.PU_SoldierPoleArm2] = {[ResourceType.Gold] = 40, [ResourceType.Wood] = 30},
	[Entities.PU_SoldierPoleArm3] = {[ResourceType.Gold] = 50, [ResourceType.Wood] = 40},
	[Entities.PU_SoldierPoleArm4] = {[ResourceType.Gold] = 60, [ResourceType.Wood] = 50},
	
	[Entities.PU_SoldierBow1] = {[ResourceType.Gold] = 30, [ResourceType.Wood] = 30},
	[Entities.PU_SoldierBow2] = {[ResourceType.Gold] = 40, [ResourceType.Wood] = 40},
	[Entities.PU_SoldierBow3] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 40},
	[Entities.PU_SoldierBow4] = {[ResourceType.Gold] = 60, [ResourceType.Iron] = 50},
	
	[Entities.PU_SoldierRifle1] = {[ResourceType.Gold] = 50, [ResourceType.Sulfur] = 40},
	[Entities.PU_SoldierRifle2] = {[ResourceType.Gold] = 60, [ResourceType.Sulfur] = 50},
	
	[Entities.PU_SoldierCavalry1] = {[ResourceType.Gold] = 80, [ResourceType.Iron] = 30},
	[Entities.PU_SoldierCavalry2] = {[ResourceType.Gold] = 100, [ResourceType.Iron] = 40},
	
	[Entities.PU_SoldierHeavyCavalry1] = {[ResourceType.Gold] = 120, [ResourceType.Iron] = 40},
	[Entities.PU_SoldierHeavyCavalry2] = {[ResourceType.Gold] = 150, [ResourceType.Iron] = 50},
	
	[Entities.CU_Barbarian_SoldierClub1] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 10},
	[Entities.CU_Barbarian_SoldierClub2] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 10},
	[Entities.CU_BlackKnight_SoldierMace1] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 10},
	[Entities.CU_BlackKnight_SoldierMace2] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 10},
	[Entities.CU_BanditSoldierSword1] = {[ResourceType.Gold] = 30, [ResourceType.Iron] = 20},
	[Entities.CU_BanditSoldierSword2] = {[ResourceType.Gold] = 30, [ResourceType.Iron] = 20},
	
	[Entities.CU_BanditSoldierBow1] = {[ResourceType.Gold] = 30, [ResourceType.Wood] = 30},
	
	[Entities.CU_Evil_SoldierBearman1] = {[ResourceType.Gold] = 50, [ResourceType.Iron] = 10},
	[Entities.CU_Evil_SoldierSkirmisher1] = {[ResourceType.Gold] = 30, [ResourceType.Wood] = 30},
}

function P4FComforts_SoldierCostFix()
	
	GUITooltip_BuySoldier_Orig = GUITooltip_BuySoldier_Orig or GUITooltip_BuySoldier
	GUITooltip_BuySoldier = function( _NormalTooltip, _DisabledTooltip,_ShortCut )
		
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
		local LeaderID = GUI.GetSelectedEntity()
		local PlayerID = GUI.GetPlayerID()
		
		local SoldierType = Logic.LeaderGetSoldiersType( LeaderID )
		local CostString = " "
		if SoldierCostTable[SoldierType] then
			CostString = InterfaceTool_CreateCostString( SoldierCostTable[SoldierType] )
		else
			local UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory( LeaderID )
			Logic.FillSoldierCostsTable( PlayerID, UpgradeCategory, InterfaceGlobals.CostTable )
			CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
		end
		
		if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then
			TooltipText =  _DisabledTooltip
		elseif XGUIEng.IsButtonDisabled(CurrentWidgetID) == 0 then
			TooltipText = _NormalTooltip
		end
		
		local ShortCutToolTip = " "
		if _ShortCut ~= nil then
			ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
		end
		
		XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, CostString )
		XGUIEng.SetTextKeyName( gvGUI_WidgetID.TooltipBottomText, TooltipText )
		XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip )
		
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE ONLY ONE
-- either P4FComforts_FormationsTechFix OR P4FComforts_FormationsAlwaysEnabled
-- orig: Technologies.GT_Tactics is checked for availability, NOT whether it is researched!
--> does not match the tooltip in the university

-- formation buttons are enabled depending on the standing army tech researched state
function P4FComforts_FormationsTechFix()
	
	GUIUpdate_BuildingButtons_Orig = GUIUpdate_BuildingButtons_Orig or GUIUpdate_BuildingButtons
	GUIUpdate_BuildingButtons = function( button, technology )
		if button == "Formation01" or button == "Formation02" or button == "Formation03" or button == "Formation04" then
			
			-- local TechState = Logic.GetTechnologyState( GUI.GetPlayerID(), Technologies.GT_StandingArmy )
			-- if TechState == 4 then
			
			if Logic.IsTechnologyResearched( GUI.GetPlayerID(), Technologies.GT_StandingArmy ) == 1 then
				-- XGUIEng.ShowWidget( button, 1 )
				XGUIEng.DisableButton( button, 0 )
			else
				XGUIEng.DisableButton( button, 1 )
			end
			return -- !
		end
		GUIUpdate_BuildingButtons_Orig( button, technology )
	end
	
end

-- formations are always available, ignore tech state
function P4FComforts_FormationsAlwaysEnabled()
	
	GUIUpdate_BuildingButtons_Orig = GUIUpdate_BuildingButtons_Orig or GUIUpdate_BuildingButtons
	GUIUpdate_BuildingButtons = function( button, technology )
		if button == "Formation01" or button == "Formation02" or button == "Formation03" or button == "Formation04" then
			-- orig: Technologies.GT_Tactics
			--> does not match the tooltip in the university
			XGUIEng.ShowWidget( button, 1 )
			XGUIEng.DisableButton( button, 0 )
			return	-- !
		end
		GUIUpdate_BuildingButtons_Orig( button, technology )
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- display a blue script signal on the minimap to notify about a building upgrade
-- can be turned on and off using Shift + U
function P4FComforts_UpgradeHints()
	
	gvUpgradeHints = {}
	gvUpgradeHints.enabled = true
	
	Input.KeyBindDown( Keys.U + Keys.ModifierShift, "ToggleUpgradeHints()", 2 )
	
	AddOnSaveGameLoaded( function() Input.KeyBindDown( Keys.U + Keys.ModifierShift, "ToggleUpgradeHints()", 2 ) end )
	
	gvUpgradeHints.GameCallback_OnBuildingUpgradeComplete = GameCallback_OnBuildingUpgradeComplete
	GameCallback_OnBuildingUpgradeComplete = function(_oldID, _newID)
		gvUpgradeHints.GameCallback_OnBuildingUpgradeComplete(_oldID, _newID)
		
		if gvUpgradeHints.enabled and GetPlayer(_newID) == gvMission.PlayerID then
			local _position = GetPosition(_newID)
			GUI.ScriptSignal(_position.X, _position.Y, 1)	-- blue
		end
	end
	
end

function ToggleUpgradeHints()
	gvUpgradeHints.enabled = not gvUpgradeHints.enabled
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- when a market is selected where a trade is active the cancel button displays information about the transaction resources
-- note: uses a GLOBAL variable gvMission.Trades

function P4FComforts_MarketInfo()
	gvMission.Trades = {}
	gvMission.TradeTotalResourcesBought = 0	-- note that this counts only for the local player, even if this script is used in MP!
	
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "P4fComforts_OnMarketDestroyed", 1)
	
	GUAction_MarketAcceptDealOrig = GUAction_MarketAcceptDealOrig or GUAction_MarketAcceptDeal
	GUAction_MarketAcceptDeal = function(_SellResourceType)
		GUAction_MarketAcceptDealOrig(_SellResourceType)
		
		local _SellAmount = InterfaceTool_MarketGetSellAmount(_SellResourceType)
		local BuildingID = GUI.GetSelectedEntity()
		local BuyResourceType, BuyResourceAmount = InterfaceTool_MarketGetBuyResourceTypeAndAmount()
		table.insert(gvMission.Trades, {building = BuildingID, sellAmount = _SellAmount, sellType = _SellResourceType, buyAmount = BuyResourceAmount, buyType = BuyResourceType})
		--LuaDebugger.Log("add trade:")
		--LuaDebugger.Log(gvMission.Trades)
	end
	
	GUIAction_CancelTrade_OrigMarket = GUIAction_CancelTrade
	GUIAction_CancelTrade = function()
		GUIAction_CancelTrade_OrigMarket()
		local BuildingID = GUI.GetSelectedEntity()
		for k, v in ipairs(gvMission.Trades) do
			if v.building == BuildingID then
				--LuaDebugger.Log("cancel trade:")
				--LuaDebugger.Log(v)
				table.remove(gvMission.Trades, k)
				break
			end
		end
	end
	
	GUITooltip_Generic_OrigMarket = GUITooltip_Generic_OrigMarket or GUITooltip_Generic
	GUITooltip_Generic = function(a)
		GUITooltip_Generic_OrigMarket(a)
		if a == "menumarket/trade_canceltrade" then
			local BuildingID = GUI.GetSelectedEntity() 
			local data = P4FComforts_TradeGetData(BuildingID)	-- note: performance OK when calling this so often (TT) ?
			if data ~= nil then
				local Player = GetPlayer(BuildingID)
				local text = "@color:180,180,180 Aktuellen Handel abbrechen: @color:240,220,200 @cr Kauf: "..data.buyAmount..
					" "..P4FComforts_TradeGetResourceName(data.buyType).. " @cr Verkauf: "..data.sellAmount.." "..P4FComforts_TradeGetResourceName(data.sellType)
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Umlaute(text))
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		end
	end
	
	-- remove the entry when the transaction is completed
	GameCallback_OnTransactionComplete_Orig = GameCallback_OnTransactionComplete_Orig or GameCallback_OnTransactionComplete
	GameCallback_OnTransactionComplete = function( _BuildingID, _empty )
		-- store information about how many resources have been bought (total; local player only!)
		local data = P4FComforts_TradeGetData(_BuildingID)
		
		if data then
			gvMission.TradeTotalResourcesBought = gvMission.TradeTotalResourcesBought + data.buyAmount
			--LuaDebugger.Log(gvMission.TradeTotalResourcesBought)
			
			for k, v in ipairs(gvMission.Trades) do
				if v.building == _BuildingID then
					--LuaDebugger.Log("trade completed:")
					--LuaDebugger.Log(v)
					table.remove(gvMission.Trades, k)
					break
				end
			end
			
			-- inform the player which resources are available now
			if GUI.GetPlayerID() == GetPlayer( _BuildingID ) then
				Message( string.format("Rohstoffe gekauft: %d %s. Verkauft: %d %s",
					data.buyAmount, P4FComforts_TradeGetResourceName(data.buyType),
					data.sellAmount, P4FComforts_TradeGetResourceName(data.sellType)) )
			end
		end
		
		GameCallback_OnTransactionComplete_Orig( _BuildingID, _empty )
	end
	
end

function P4FComforts_TradeGetResourceName(_resType)
	if _resType == ResourceType.Gold then
		return "Taler"
	elseif _resType == ResourceType.Wood then
		return "Holz"
	elseif _resType == ResourceType.Clay then
		return "Lehm"
	elseif _resType == ResourceType.Stone then
		return "Stein"
	elseif _resType == ResourceType.Iron then
		return "Eisen"
	elseif _resType == ResourceType.Sulfur then
		return "Schwefel"
	end
end

function P4FComforts_TradeGetData(_building)
	for k,v in ipairs(gvMission.Trades) do
		if v.building == _building then
			return v
		end
	end	
	return nil
end

function P4fComforts_OnMarketDestroyed()
	local ent_ID = Event.GetEntityID()
	local ent_typ = Logic.GetEntityType(ent_ID)
	if ent_typ == Entities.PB_Market2 then
		for k, v in ipairs(gvMission.Trades) do
			if v.building == ent_ID then
				--LuaDebugger.Log("market destroyed, cancel trade:")
				--LuaDebugger.Log(v)
				table.remove(gvMission.Trades, k)
				break
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- find hero buttons change color depending on the health of the hero
-- note: needs function GetHealth
-- note: uses GLOBAL variable gvMission.UseHeroHealthDisplay

function P4FComforts_HeroHealthDisplay()
	
	assert( GetHealth, "missing function: GetHealth" )
	
	gvMission.UseHeroHealthDisplay = true
	
	Input.KeyBindDown( Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2 )
	
	AddOnSaveGameLoaded( function() Input.KeyBindDown( Keys.H + Keys.ModifierShift, "ToggleHeroDisplay()", 2 ) end )
	
	
	GUIUpdate_HeroButtonOrig = GUIUpdate_HeroButtonOrig or GUIUpdate_HeroButton
	GUIUpdate_HeroButton = function()
	
		if not gvMission.UseHeroHealthDisplay then
			GUIUpdate_HeroButtonOrig()
			return
		end
	
		local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()	
		local EntityID = XGUIEng.GetBaseWidgetUserVariable(CurrentWidgetID, 0)
		local health = GetHealth(EntityID)
		local R, G, B
		B = 0
		if health == 100 then
			R, G, B = 255, 255, 255
		elseif health > 50 then
			G = 255
			R = 255 - health * 5.1
		else
			R = 255
			G = health * 5.1
		end
		
		local SourceButton
		if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero1) == 1 then	
			SourceButton = "FindHeroSource1"
			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)
			
			if Logic.SentinelGetUrgency(EntityID) == 1 then					
			
			if gvGUI.DarioCounter < 50 then
				
				XGUIEng.SetMaterialColor(CurrentWidgetID,0, 100,100,200,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID,1, 100,100,200,255)
				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end		
			if gvGUI.DarioCounter >= 50 then			
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)		
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)
				
				gvGUI.DarioCounter = gvGUI.DarioCounter +1
			end
			if gvGUI.DarioCounter == 100 then
				gvGUI.DarioCounter= 0
			end
			else	
				--XGUIEng.SetMaterialColor(CurrentWidgetID,0, 255,255,255,255)
				XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)	
				XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)	
			end
			
		else

			if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero2) == 1 then
				SourceButton = "FindHeroSource2"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero3) == 1 then
				SourceButton = "FindHeroSource3"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero4) == 1 then
				SourceButton = "FindHeroSource4"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero5) == 1 then
				SourceButton = "FindHeroSource5"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero6) == 1 then
				SourceButton = "FindHeroSource6"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_BlackKnight then
				SourceButton = "FindHeroSource7"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Mary_de_Mortfichet then
				SourceButton = "FindHeroSource8"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Barbarian_Hero then
				SourceButton = "FindHeroSource9"
			
			--AddOn
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero10) == 1 then
				SourceButton = "FindHeroSource10"
			elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero11) == 1 then
				SourceButton = "FindHeroSource11"
			elseif Logic.GetEntityType( EntityID )	== Entities.CU_Evil_Queen then
				SourceButton = "FindHeroSource12"
			
			else
				SourceButton = "FindHeroSource9"
			end
			
			XGUIEng.TransferMaterials(SourceButton, CurrentWidgetID)
			
			XGUIEng.SetMaterialColor(CurrentWidgetID, 0, R,G,B,255)	
			XGUIEng.SetMaterialColor(CurrentWidgetID, 1, R,G,B,255)	

		end
	
	end
	
end

function ToggleHeroDisplay()
	gvMission.UseHeroHealthDisplay = not gvMission.UseHeroHealthDisplay
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- allow serfs and cannons to regenerate health points
-- note: needs function GetHealth and IsValueInTable
-- param: true = enable for all, OR table with player IDs
function P4FComforts_HealthRegeneration( _forAllOrTable )
	assert( GetHealth, "missing function: GetHealth" )
	assert( IsValueInTable, "missing function: IsValueInTable" )
	gvMission.SerfTable = {}
	gvMission.CannonTable = {}
	if type(_forAllOrTable) == "boolean" and _forAllOrTable == true then
		gvMission.RegenerationPlayers = { 1, 2, 3, 4, 5, 6, 7, 8 }
	elseif type(_forAllOrTable) == "table" then
		gvMission.RegenerationPlayers = _forAllOrTable
	end
	
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, nil, "HEALTH_REGENERATION_ON_ENTITY_CREATED", 1)
	StartSimpleJob("SJ_P4FComforts_HealthRegeneration")
	
	for i = 1, table.getn(gvMission.RegenerationPlayers) do
		P4FComforts_HealthRegeneration_AddExistingSerfsForPlayer( gvMission.RegenerationPlayers[i] )
	end
end

-- get the already existing serfs
function P4FComforts_HealthRegeneration_AddExistingSerfsForPlayer(_player)
	local tSerfs = {Logic.GetPlayerEntities(_player, Entities.PU_Serf, 16)}
	for i = 2, tSerfs[1]+1 do
		table.insert(gvMission.SerfTable, tSerfs[i])
	end
	-- also add battle serfs
	local tBattleSerfs = {Logic.GetPlayerEntities(_player, Entities.PU_BattleSerf, 16)}
	for i = 2, tBattleSerfs[1]+1 do
		table.insert(gvMission.SerfTable, tBattleSerfs[i])
	end
end

function HEALTH_REGENERATION_ON_ENTITY_CREATED()
	local entityId = Event.GetEntityID()
	local entityType = Logic.GetEntityType( entityId )
	local player = Logic.EntityGetPlayer(entityId)
	if IsValueInTable( player, gvMission.RegenerationPlayers ) then
		if entityType == Entities.PU_Serf or entityType == Entities.PU_BattleSerf then	-- also heal battle serfs
			table.insert( gvMission.SerfTable, entityId )
		elseif entityType == Entities.PV_Cannon1 or entityType == Entities.PV_Cannon2
		or entityType == Entities.PV_Cannon3 or entityType == Entities.PV_Cannon4 then
			table.insert( gvMission.CannonTable, entityId )
		end
	end
end

function SJ_P4FComforts_HealthRegeneration()
	for i = table.getn(gvMission.SerfTable), 1, -1 do
		if IsAlive(gvMission.SerfTable[i]) then
			if GetHealth(gvMission.SerfTable[i]) < 100 then
				SetHealth(gvMission.SerfTable[i], GetHealth(gvMission.SerfTable[i]) + 1 )
			end
		else
			table.remove(gvMission.SerfTable, i)
		end
	end

	for i = table.getn(gvMission.CannonTable), 1, -1 do
		if IsAlive(gvMission.CannonTable[i]) then
			if GetHealth(gvMission.CannonTable[i]) < 100 then
				SetHealth(gvMission.CannonTable[i], GetHealth(gvMission.CannonTable[i]) + 1 )
			end
		else
			table.remove(gvMission.CannonTable, i)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- allow free camera rotation; reset angle with [Shift + C]
-- uses + overwrites the online help button
-- note: needs function Umlaute
-- note: optional parameter to determine whether or not to use the online help button

function P4FComforts_FreeCamera( _zoom, useOnlineHelpButton )
	if gvFreeCamera then
		return
	end
	
	gvFreeCamera = {
		zoom = _zoom or 1.3,
		useOnlineHelpButton = useOnlineHelpButton or false,
	}
	
	AddOnSaveGameLoaded( P4FComforts_FreeCamera_Setup )
	
	EndBriefing_OrigFreeCamera = EndBriefing_OrigFreeCamera or EndBriefing
	EndBriefing = function()
		EndBriefing_OrigFreeCamera()
		
		P4FComforts_FreeCamera_Setup()
	end
	
	P4FComforts_FreeCamera_Setup()
	
end

function P4FComforts_FreeCamera_Setup()
	
	Camera.ZoomSetFactorMax( gvFreeCamera.zoom )	-- better zoom
	Camera.RotSetFlipBack(0)		-- free rotation
	Camera.RotSetAngle(-45)			-- standard value	--> without this command the map would start with the last used camera angle! (as flip back is turned off)
	Input.KeyBindDown( Keys.C + Keys.ModifierShift, "Camera.RotSetAngle(-45)", 2 )
	
	if gvFreeCamera.useOnlineHelpButton then
		P4FComforts_FreeCamera_Button()		-- restore camera angle
		XGUIEng.TransferMaterials( "Scout_UseBinocular", "OnlineHelpButton" )
	end
	
end

function P4FComforts_FreeCamera_Button()
	
	assert( Umlaute, "missing function: Umlaute" )
	GUIAction_OnlineHelp = function()
		-- restore camera angle
		Camera.RotSetAngle(-45)
	end

	GUITooltip_Generic_Orig_HelpButton = GUITooltip_Generic_Orig_HelpButton or GUITooltip_Generic
	GUITooltip_Generic = function(a)
		if a == "MenuMap/OnlineHelp" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute("@color:180,180,180 Kamera zurücksetzen @color:173,255,47 @cr Klickt hier um den Standard Kamerawinkel einzustellen."..
			" @cr Ihr könnt die Kamera jederzeit frei drehen, um im Gefecht alles im Blick zu behalten. Anschließend könnt Ihr die Kameraeinstellung zurücksetzen."))
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "@color:240,220,200 Taste: [Shift + C]")
		else
			GUITooltip_Generic_Orig_HelpButton(a)
		end
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- enable more battle formations for military groups; uses [Shift + (1-9)]

function P4FComforts_FormationsMod()
	AddOnSaveGameLoaded( P4FComforts_FormationsInit )
	
	P4FComforts_FormationsInit()
end

function P4FComforts_FormationsInit()
	-- init change formation for troops
	Input.KeyBindDown(Keys.D1 + Keys.ModifierShift, "P4FComforts_SetFormation(1)", 2)
	Input.KeyBindDown(Keys.D2 + Keys.ModifierShift, "P4FComforts_SetFormation(2)", 2)
	Input.KeyBindDown(Keys.D3 + Keys.ModifierShift, "P4FComforts_SetFormation(3)", 2)
	Input.KeyBindDown(Keys.D4 + Keys.ModifierShift, "P4FComforts_SetFormation(4)", 2)
	Input.KeyBindDown(Keys.D5 + Keys.ModifierShift, "P4FComforts_SetFormation(5)", 2)
	Input.KeyBindDown(Keys.D6 + Keys.ModifierShift, "P4FComforts_SetFormation(6)", 2)
	Input.KeyBindDown(Keys.D7 + Keys.ModifierShift, "P4FComforts_SetFormation(7)", 2)
	Input.KeyBindDown(Keys.D8 + Keys.ModifierShift, "P4FComforts_SetFormation(8)", 2)
	Input.KeyBindDown(Keys.D9 + Keys.ModifierShift, "P4FComforts_SetFormation(9)", 2)
end

function P4FComforts_FormationsAllowed(id)
	local typeName = string.lower( Logic.GetEntityTypeName(Logic.GetEntityType(id)) )

	-- return true if the type name fits to one of these
	return (string.find(typeName, "leadersword") ~= nil)
	or (string.find(typeName, "leaderbow") ~= nil)
	or (string.find(typeName, "leaderpolearm") ~= nil)
	or (string.find(typeName, "leaderrifle") ~= nil)
	or (string.find(typeName, "leaderheavycavalry") ~= nil)
	or (string.find(typeName, "leadercavalry") ~= nil)
	or (string.find(typeName, "evilleader") ~= nil)
	or (string.find(typeName, "evil_leader") ~= nil)
	or (string.find(typeName, "barbarian_leader") ~= nil)
	or (string.find(typeName, "blackknight_leader") ~= nil)
	or (string.find(typeName, "veteranmajor") ~= nil)
	or (string.find(typeName, "veteranlieutenant") ~= nil)
end

function P4FComforts_SetFormation(formation)
	local SelectedEntityIDs = {GUI.GetSelectedEntities()}
	local change = false
	
	if SelectedEntityIDs == nil then
		return false
	end
	
	for n = 1, table.getn(SelectedEntityIDs) do
		local leaderID = SelectedEntityIDs[n]
		if P4FComforts_FormationsAllowed(leaderID) == true
		and Logic.LeaderGetBarrack(leaderID) == 0 then
			--Logic.LeaderChangeFormationType(leaderID, formation)
			GUI.LeaderChangeFormationType(leaderID, formation)	-- for MP
			change = true
		end
	end
	
	-- finally play the sound once if required
	if change == true then
		Sound.PlayGUISound(Sounds.VoicesLeader_LEADER_ChangeFormation_rnd_01, 100)
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- KINDA DEPRECATED
-- let players leaders automatically buy new soldiers when possible (player can toggle this feature on/off)
-- param: number of players to enable
-- note: uses GLOBAL variables gvMission.Autofill and gvMission.PlayerID
-- note: uses function InitColors, Umlaute and HasPlayerEnoughResources
-- note: overwrites function GUI.DeactivateAutoFillAtBarracks

function P4FComforts_AutoRefill(_players)	-- max player amount

	gvMission.Autofill = {}
	StartSimpleJob("SJ_P4FComforts_AutoFill")
	if _players < 1 then
		return
	end
	local i
	for i = 1, _players do
		gvMission.Autofill[i] = true
	end

	-- v2
	
	XGUIEng.SetWidgetPosition(XGUIEng.GetWidgetID("Research_BetterTrainingBarracks"), 74, 4)	--110,4
	GUI.DeactivateAutoFillAtBarracks = function(_entity)
		-- toggle autofill
		gvMission.Autofill[gvMission.PlayerID] = not gvMission.Autofill[gvMission.PlayerID]
	end
	
	GUITooltip_GenericOrigAutoRefill = GUITooltip_Generic
	GUITooltip_Generic = function(a)
		if a == "MenuBuildingGeneric/RecruitGroups" then
			if gvMission.Autofill[gvMission.PlayerID] == true then
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Umlaute("@color:180,180,180 Automatisches Rekrutieren ausschalten @cr @color:255,255,255 Eure Hauptmänner werden nur neue Soldaten in ihre Gruppe aufnehmen, wenn Ihr es ihnen befehlt."))
			else
				XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Umlaute("@color:180,180,180 Automatisches Rekrutieren anschalten @cr @color:255,200,0 ermöglicht: @color:255,255,255 Eure Hauptmänner können selbstständig neue Soldaten in ihre Gruppe aufnehmen, sofern genügend Plätze und Rohstoffe vorhanden sind."))
			end
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "")
		else
			GUITooltip_GenericOrigAutoRefill(a)
		end
	end
	
end

function SJ_P4FComforts_AutoFill()
	if gvMission.Autofill[gvMission.PlayerID] == true then
		for n = 1, Logic.GetNumberOfLeader(gvMission.PlayerID) do
			LeaderID = Logic.GetNextLeader(gvMission.PlayerID, LastLeaderID)
			if LeaderID ~= 0 then
				if Logic.LeaderGetBarrack(LeaderID) == 0 then
					MilitaryBuildingID = Logic.LeaderGetNearbyBarracks(LeaderID)
					if MilitaryBuildingID ~= 0	then	
						if Logic.GetPlayerAttractionUsage(gvMission.PlayerID) < Logic.GetPlayerAttractionLimit(gvMission.PlayerID) then
							UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory(LeaderID)
							Soldiers = Logic.LeaderGetNumberOfSoldiers(LeaderID)
							MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(LeaderID)
							if Soldiers < MaxSoldiers then
								BuyAmount = MaxSoldiers - Soldiers
								for i = 1, BuyAmount do
									local CostTable = {}
									Logic.FillSoldierCostsTable(gvMission.PlayerID, UpgradeCategory, CostTable)
									if HasPlayerEnoughResources(gvMission.PlayerID, CostTable) == true then	-- costs are ok
										--Message("buy id: "..LeaderID)
										GUI.BuySoldier(LeaderID)
									end
								end
							end
						end
					end
				end
				LastLeaderID = LeaderID
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- NEW VERSION
-- retains the vanilla functionality of selecting to buy groups or single leaders only
function P4FComforts_GroupRefill()
	
	assert( Umlaute )
	assert( GetPlayerLeaders )
	assert( HasPlayerEnoughResources )
	
	-- test: show both buttons in barracks
	--> use one for the original toggle and one for instant leader refill
	GUIUpdate_ToggleGroupRecruitingButtons = function()
		XGUIEng.ShowWidget( gvGUI_WidgetID.RecruitSingleLeader, 1 )
		XGUIEng.ShowWidget( gvGUI_WidgetID.RecruitGroups, 1 )
	end
	
	P4FComforts_GroupRefillGuiHacks()
	AddOnSaveGameLoaded( P4FComforts_GroupRefillGuiHacks )
	
	-- make sure to not overwrite this again!
	GUITooltip_Generic_GroupRefill = GUITooltip_Generic_GroupRefill or GUITooltip_Generic
	GUITooltip_Generic = function( ttString )
		
		GUITooltip_Generic_GroupRefill( ttString )
		
		-- confusing but makes sense:
		-- RecruitGroups tooltip for the button that calls DeactivateAutoFillAtBarracks
		-- and displays the current (old) state: the button with an entire group
		if ttString == "MenuBuildingGeneric/RecruitSingleLeader" then
			local entityId = GUI.GetSelectedEntity()
			local flagDependantText = " Momentan werden nur Hauptmänner rekrutiert."
			if entityId and Logic.IsAutoFillActive( entityId ) == 1 then
				flagDependantText = " Momentan werden Gruppen rekrutiert."
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText,
				Umlaute("@color:180,180,180 Nur Hauptmann/Gruppe rekrutieren"..
				" @cr @color:255,255,255 Wechselt zwischen dem Kauf von einzelnen"..
				" Hauptmännern und Gruppen." .. flagDependantText) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "" )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "" )
			
		elseif ttString == "MenuBuildingGeneric/RecruitGroups" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText,
				Umlaute("@color:180,180,180 Sofort nachrekrutieren"..
				" @cr @color:255,255,255 Nahe Hauptmänner nehmen selbstständig neue"..
				" Soldaten in ihre Gruppe auf, sofern genügend Plätze und Rohstoffe vorhanden sind.") )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "" )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "" )
		end
	end
	
end


function P4FComforts_GroupRefillGuiHacks()
	
	--> need to reposition and resize the parent widget first
	XGUIEng.SetWidgetPositionAndSize( "ToggleRecruitGroups", 236, 88, 160, 40 )
	XGUIEng.SetWidgetPosition( "Activate_RecruitSingleLeader", 4, 4 )
	XGUIEng.SetWidgetPosition( "Activate_RecruitGroups", 132, 4 )	-- button that displays only one leader
	
	-- note that calling Logic.IsAutoFillActive directly inside the GUI callback
	-- will display the old flag, before the change!
	GUI_DeactivateAutoFillAtBarracks_Orig = GUI_DeactivateAutoFillAtBarracks_Orig or GUI.DeactivateAutoFillAtBarracks
	GUI.DeactivateAutoFillAtBarracks = function( entityId )
		P4FComforts_GroupRefill_BuySoldiers( entityId )
	end
	
	GUI_ActivateAutoFillAtBarracks_Orig = GUI_ActivateAutoFillAtBarracks_Orig or GUI.ActivateAutoFillAtBarracks
	GUI.ActivateAutoFillAtBarracks = function( entityId )
		
		local oldFlag = Logic.IsAutoFillActive(entityId)
		if oldFlag == 1 then
			GUI_DeactivateAutoFillAtBarracks_Orig( entityId )
			-- XGUIEng.TransferMaterials( "Activate_RecruitSingleLeader", "Activate_RecruitGroups" )
		else
			GUI_ActivateAutoFillAtBarracks_Orig( entityId )
			-- this would require a "backup" icon...
			-- XGUIEng.TransferMaterials( "Activate_RecruitGroups", "Activate_RecruitGroups" )
		end
	end
	
end

function P4FComforts_GroupRefill_BuySoldiers( selectedBuildingId )
	local playerId = GetPlayer( selectedBuildingId )
	local pos = GetPosition( selectedBuildingId )
	for k, LeaderID in pairs( GetPlayerLeaders( playerId ) ) do
		if LeaderID ~= 0 then
			if Logic.LeaderGetBarrack( LeaderID ) == 0 then
				local MilitaryBuildingID = Logic.LeaderGetNearbyBarracks( LeaderID )
				if MilitaryBuildingID == selectedBuildingId then	-- only recruit at this building
					local UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory( LeaderID )
					local Soldiers = Logic.LeaderGetNumberOfSoldiers( LeaderID )
					local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers( LeaderID )
					if Soldiers < MaxSoldiers then
						local BuyAmount = MaxSoldiers - Soldiers
						for i = 1, BuyAmount do
							if Logic.GetPlayerAttractionUsage( playerId ) < Logic.GetPlayerAttractionLimit( playerId ) then
								local CostTable = {}
								Logic.FillSoldierCostsTable( playerId, UpgradeCategory, CostTable )
								if HasPlayerEnoughResources( playerId, CostTable ) then
									--Message("buy id: "..LeaderID)
									GUI.BuySoldier( LeaderID )
								end
							end
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- do not combine with P4FComforts_GrowingTrees!

-- optional: table with entity types to use for replacement
-- can be either their entity name (string) or entity type ID
function P4FComforts_ReplaceTreeStumps( replaceTypes )
	if replaceTypes then
		P4FComforts_ReplaceTreeStumpEntities = replaceTypes
	else
		P4FComforts_ReplaceTreeStumpEntities = {
			"XD_Bush1",
			"XD_Bush2",
			"XD_Bush3",
			"XD_Bush4",
			"XD_Plant1",
			"XD_Plant4",
			"XD_Flower1",
			"XD_Flower2",
			"XD_Flower3",
			"XD_Flower4",
			"XD_Flower5",
			"XD_Driftwood1",
			"XD_Driftwood2",
		}
	end
	for k, v in P4FComforts_ReplaceTreeStumpEntities do
		if type(v) == "string" then
			P4FComforts_ReplaceTreeStumpEntities[k] = Entities[v]
		end
	end
	assert( type(P4FComforts_ReplaceTreeStumpEntities) == "table" )
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "P4FComforts_OnTreeStumpCreated_Replace", 1)
end

function P4FComforts_OnTreeStumpCreated_Replace()
	local entityId = Event.GetEntityID()
	local entityType = Logic.GetEntityType( entityId )
	local position = GetPosition( entityId )
	
	if entityType == Entities.XD_TreeStump1 then
		local plants = P4FComforts_ReplaceTreeStumpEntities
		local newEnt = Entities[plants[math.random(1, table.getn(plants))]]
		Logic.CreateEntity(newEnt, position.X, position.Y, math.random(1, 360), 8)
		DestroyEntity(entityId)
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function P4FComforts_RemoveDroppedEntities()
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_CREATED, "", "P4FComforts_OnDroppedEntityCreated", 1 )
end

function P4FComforts_OnDroppedEntityCreated()
	local entityId = Event.GetEntityID()
	local entityType = Logic.GetEntityType( entityId )
	
	if entityType == "XD_DroppedSword" or
		entityType == "XD_DroppedBow" or
		entityType == "XD_DroppedAxeShield" or
		entityType == "XD_SoldierRifle1_Rifle" or
		entityType == "XD_SoldierRifle2_Rifle" or
		entityType == "XD_DroppedShield" or
		entityType == "XD_DroppedSwordShield" or
		entityType == "XD_DroppedPoleArm" then
		
		local _rnd = math.random(1, 3)
		if _rnd > 1 then
			DestroyEntity(entityId)
		end
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function P4FComforts_CreateDecalsForResourcePiles()
	Trigger.RequestTrigger( Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "P4fComforts_OnResourcePileDestroyed", 1 )
end

function P4fComforts_OnResourcePileDestroyed()
	local entityId = Event.GetEntityID()
	local entityType = Logic.GetEntityType( entityId )

	if entityType == Entities.XD_Stone_BlockPath
	or entityType == Entities.XD_Stone1
	or entityType == Entities.XD_Clay1
	or entityType == Entities.XD_Iron1
	or entityType == Entities.XD_Sulfur1 then
		local position = GetPosition( entityId )
		Logic.CreateEntity( Entities.XD_PlantDecalLarge3, position.X, position.Y, 0, 8 )
	end

end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- v2
-- sets of similar trees, as before
-- but one table per possible grow sequence (no random entity selection per level)
P4FComforts_GrowingTreeSets = {}
-- fir
P4FComforts_GrowingTreeSets["fir"] = {
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_Fir1_small },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_Fir1_small, Entities.XD_Fir1 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_Fir2_small },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_Fir2_small, Entities.XD_Fir2 },
}
-- dark tree
-- removed (replaced) first stage: Entities.XD_GreeneryBush1
P4FComforts_GrowingTreeSets["dark_tree"] = {
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree4 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree4, Entities.XD_DarkTree5 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree1 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree1, Entities.XD_DarkTree2 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree1, Entities.XD_DarkTree8 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree6 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_DarkTree7 },
}
-- pine
P4FComforts_GrowingTreeSets["pine"] = {
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3, Entities.XD_Pine1 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3, Entities.XD_Pine4 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3, Entities.XD_Pine5 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3, Entities.XD_Pine6 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_Pine3, Entities.XD_Pine1, Entities.XD_Pine2 },
}
-- pine north
P4FComforts_GrowingTreeSets["pine_north"] = {
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_PineNorth3 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_PineNorth3, Entities.XD_PineNorth2 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_PineNorth3, Entities.XD_PineNorth2, Entities.XD_PineNorth1 },
}
-- birch
P4FComforts_GrowingTreeSets["birch"] = {
	{ Entities.XD_GreeneryBush2, Entities.XD_GreeneryBushHigh1, Entities.XD_Tree6 },
	{ Entities.XD_GreeneryBush2, Entities.XD_GreeneryBushHigh1, Entities.XD_Tree6, Entities.XD_Tree4 },
	{ Entities.XD_GreeneryBush2, Entities.XD_GreeneryBushHigh1, Entities.XD_Tree6, Entities.XD_Tree5 },
	{ Entities.XD_GreeneryBush2, Entities.XD_GreeneryBushHigh1, Entities.XD_Tree6, Entities.XD_Tree7 },
}
-- birch north
P4FComforts_GrowingTreeSets["birch_north"] = {
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeNorth3 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeNorth3, Entities.XD_TreeNorth2 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeNorth1 },
}
-- birch moor
P4FComforts_GrowingTreeSets["birch_moor"] = {
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeMoor9 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeMoor9, Entities.XD_TreeMoor8 },
	{ Entities.XD_GreeneryBushHigh3, Entities.XD_GreeneryBushHigh4, Entities.XD_TreeMoor7 },
}
-- small blatty trees
-- yes, XD_Tree1_small -> XD_Tree2 and the other two are correct...
P4FComforts_GrowingTreeSets["small_tree"] = {
	{ Entities.XD_Bush4, Entities.XD_Tree1_small },
	{ Entities.XD_Bush4, Entities.XD_Tree1_small, Entities.XD_Tree2 },
	{ Entities.XD_Bush4, Entities.XD_Tree1_small, Entities.XD_Tree8 },	-- tree2 and tree8 look almost(?) identical
	{ Entities.XD_Bush4, Entities.XD_Tree2_small },
	{ Entities.XD_Bush4, Entities.XD_Tree2_small, Entities.XD_Tree3 },
	{ Entities.XD_Bush4, Entities.XD_Tree3_small },
	{ Entities.XD_Bush4, Entities.XD_Tree3_small, Entities.XD_Tree1 },
}
-- apple trees
P4FComforts_GrowingTreeSets["apple_tree"] = {
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_AppleTree1 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_AppleTree2 },
}

-- orange trees
P4FComforts_GrowingTreeSets["orange_tree"] = {
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_OrangeTree1 },
	{ Entities.XD_GreeneryBushHigh2, Entities.XD_GreeneryBushHigh1, Entities.XD_DarkTree3, Entities.XD_OrangeTree2 },
}

P4FComforts_TreeSetByEntityType = {
	[Entities.XD_Tree1] = "small_tree",
	[Entities.XD_Tree2] = "small_tree",
	[Entities.XD_Tree3] = "small_tree",
	[Entities.XD_Tree4] = "birch",
	[Entities.XD_Tree5] = "birch",
	[Entities.XD_Tree6] = "birch",
	[Entities.XD_Tree7] = "birch",
	[Entities.XD_Tree8] = "small_tree",
	[Entities.XD_Tree1_small] = "small_tree",
	[Entities.XD_Tree2_small] = "small_tree",
	[Entities.XD_Tree3_small] = "small_tree",
	[Entities.XD_AppleTree1] = "apple_tree",
	[Entities.XD_AppleTree2] = "apple_tree",
	[Entities.XD_OrangeTree1] = "orange_tree",
	[Entities.XD_OrangeTree2] = "orange_tree",
	[Entities.XD_Pine1] = "pine",
	[Entities.XD_Pine2] = "pine",
	[Entities.XD_Pine3] = "pine",
	[Entities.XD_Pine4] = "pine",
	[Entities.XD_Pine5] = "pine",
	[Entities.XD_Pine6] = "pine",
	[Entities.XD_PineNorth1] = "pine_north",
	[Entities.XD_PineNorth2] = "pine_north",
	[Entities.XD_PineNorth3] = "pine_north",
	[Entities.XD_DarkTree1] = "dark_tree",
	[Entities.XD_DarkTree2] = "dark_tree",
	[Entities.XD_DarkTree3] = "dark_tree",
	[Entities.XD_DarkTree4] = "dark_tree",
	[Entities.XD_DarkTree5] = "dark_tree",
	[Entities.XD_DarkTree6] = "dark_tree",
	[Entities.XD_DarkTree7] = "dark_tree",
	[Entities.XD_DarkTree8] = "dark_tree",
	[Entities.XD_Fir1] = "fir",
	[Entities.XD_Fir2] = "fir",
	[Entities.XD_Fir1_small] = "fir",
	[Entities.XD_Fir2_small] = "fir",
	[Entities.XD_TreeNorth1] = "birch_north",
	[Entities.XD_TreeNorth2] = "birch_north",
	[Entities.XD_TreeNorth3] = "birch_north",
	[Entities.XD_TreeMoor7] = "birch_moor",
	[Entities.XD_TreeMoor8] = "birch_moor",
	[Entities.XD_TreeMoor9] = "birch_moor",
}

-- param: old tree entity type
--> get the set which this tree belongs to
function GetTreeSetIndexByEntityType( entityType )
	return P4FComforts_TreeSetByEntityType[entityType] or nil
end

function IsValidTreeEntityType( entityType )
	return P4FComforts_TreeSetByEntityType[entityType] ~= nil
end


-- do not use together with P4FComforts_ReplaceTreeStumps!
function P4FComforts_GrowingTrees( minGrowthTime, maxGrowthTime, initialWaitTime )
	
	gvGrowingTrees = {}
	gvGrowingTrees.trees = {}	-- growing trees
	gvGrowingTrees.choppedTrees = {}	-- entity types of chopped trees with their position as index (x_y)
	gvGrowingTrees.choppedTreeCount = 0	-- avoid the choppedTrees table becomes too big
	gvGrowingTrees.choppedTreeMaximum = 512
	gvGrowingTrees.excludeDestroyedTrees = {}
	gvGrowingTrees.debug = false
	gvGrowingTrees.minTime = minGrowthTime or 120
	gvGrowingTrees.maxTime = maxGrowthTime or 300
	gvGrowingTrees.initialWaitTime = initialWaitTime or 600	-- first stage only (allow the player to clear larger areas for building space)
	gvGrowingTrees.newTreeRadius = 400
	-- map center and radius squared (to avoid entities being placed outside of the map)
	ws = Logic.WorldGetSize()
	gvGrowingTrees.mapRadius2 = (0.5*ws)*(0.5*ws)
	gvGrowingTrees.mapCenter = { X = 0.5*ws, Y = 0.5*ws }
	
	Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED, "", "P4FComforts_OnTreeStumpCreated_Regrow", 1)
	gvGrowingTrees.EntityDestroyedTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "P4FComforts_OnTreeDestroyed", 1)
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "P4FComforts_GrowingTreesJob", 1)
	
	
	-- make sure to disable any entity destroyed trigger before leaving the map!
	QuickLoad_TreeRegrow = QuickLoad
	QuitApplication_TreeRegrow = QuitApplication
	QuitGame_TreeRegrow = QuitGame
	GUIAction_RestartMap_TreeRegrow = GUIAction_RestartMap
	MainWindow_LoadGame_DoLoadGame_TreeRegrow = MainWindow_LoadGame_DoLoadGame
	
	QuickLoad = function()
		Trigger.UnrequestTrigger( gvGrowingTrees.EntityDestroyedTrigger )
		QuickLoad_TreeRegrow()
	end
	
	QuitApplication = function()
		Trigger.UnrequestTrigger( gvGrowingTrees.EntityDestroyedTrigger )
		QuitApplication_TreeRegrow()
	end
	
	QuitGame = function()
		Trigger.UnrequestTrigger( gvGrowingTrees.EntityDestroyedTrigger )
		QuitGame_TreeRegrow()
	end
	
	GUIAction_RestartMap = function()
		Trigger.UnrequestTrigger( gvGrowingTrees.EntityDestroyedTrigger )
		GUIAction_RestartMap_TreeRegrow()
	end
	
	MainWindow_LoadGame_DoLoadGame = function(_slot)
		Trigger.UnrequestTrigger( gvGrowingTrees.EntityDestroyedTrigger )
		MainWindow_LoadGame_DoLoadGame_TreeRegrow(_slot)
	end
	
end

function P4FComforts_OnTreeStumpCreated_Regrow()
	local entityId = Event.GetEntityID()
	local entityType = Logic.GetEntityType(entityId)
	-- local entityTypeName = Logic.GetEntityTypeName(entityType)
	-- if GetPlayer( entityId ) > 0 then return end
	if entityType ~= Entities.XD_TreeStump1 then return end
	local entityPosition = GetPosition( entityId )
	-- LuaDebugger.Log( "tree stump created: " .. tostring(entityTypeName) )
	local index = string.format( "%d_%d", entityPosition.X, entityPosition.Y )
	local oldType = gvGrowingTrees.choppedTrees[index]
	if oldType then
		-- LuaDebugger.Log( "here was a tree of type: " .. tostring(oldType) )
		-- LuaDebugger.Log( entityPosition )
		-- Logic.CreateEffect( GGL_Effects.FXSalimHeal, entityPosition.X, entityPosition.Y, 0 )
		DestroyEntity( entityId )
		gvGrowingTrees.choppedTrees[index] = nil
		gvGrowingTrees.choppedTreeCount = gvGrowingTrees.choppedTreeCount - 1
		
		-- ok, we try to grow a new tree...
		
		-- check new nearby position
		local newPos = GetRandomPositionNearby( entityPosition, gvGrowingTrees.newTreeRadius )
		if GetDistanceSquared( newPos, gvGrowingTrees.mapCenter ) > gvGrowingTrees.mapRadius2 then
			-- position is out of the map circle
			return
		end
		
		-- which group of trees to choose from
		local setIndex = GetTreeSetIndexByEntityType( oldType )
		if not setIndex then
			-- the chopped tree was not part of any set
			return false
		end
		-- chose one sequence at random
		local sequenceIndex = GetRandom( table.getn(P4FComforts_GrowingTreeSets[setIndex]) ) + 1
		local treeType = P4FComforts_GrowingTreeSets[setIndex][sequenceIndex][1]
		if treeType then
			local newID = CreateEntity( 0, treeType, newPos )
			table.insert( gvGrowingTrees.trees, { id = newID, position = newPos,
				counter = gvGrowingTrees.initialWaitTime, level = 0, setID = setIndex, sequenceIndex = sequenceIndex } )
			if gvGrowingTrees.debug then
				Logic.CreateEffect( GGL_Effects.FXSalimHeal, newPos.X, newPos.Y, 0 )
			end
		end
		
	end
end

function P4FComforts_OnTreeDestroyed()
	
	-- avoid a potentially very large table of choppedTrees
	if gvGrowingTrees.choppedTreeCount > gvGrowingTrees.choppedTreeMaximum then
		return
	end
	
	local entityId = Event.GetEntityID()
	if GetPlayer( entityId ) ~= 0 then return end
	local entityType = Logic.GetEntityType(entityId)
	-- local entityTypeName = Logic.GetEntityTypeName(entityType)
	if not IsValidTreeEntityType( entityType ) then return end
	if gvGrowingTrees.excludeDestroyedTrees[entityId] then
		-- LuaDebugger.Log( "ignore destroyed tree, because it was replaced" )
		gvGrowingTrees.excludeDestroyedTrees[entityId] = nil
		return
	end
	local entityPosition = GetPosition( entityId )
	-- LuaDebugger.Log( "tree destroyed: " .. tostring(entityTypeName) )
	local index = string.format( "%d_%d", entityPosition.X, entityPosition.Y )
	gvGrowingTrees.choppedTrees[index] = entityType
	gvGrowingTrees.choppedTreeCount = gvGrowingTrees.choppedTreeCount + 1
end

function P4FComforts_GrowingTreesJob()
	
	-- clear the exclude list on a regular basis
	gvGrowingTrees.excludeDestroyedTrees = {}
	
	local n = table.getn( gvGrowingTrees.trees )
	if n == 0 then return end
	
	for i = n, 1, -1 do
		local tree = gvGrowingTrees.trees[i]
		if Logic.IsEntityDestroyed( tree.id ) then
			table.remove( gvGrowingTrees.trees, i )
		else
			if tree.counter == 0 then
				-- no entity blocking?
				if P4FComforts_GrowingTreesCheckGrowPos( tree.position ) then
					-- try to grow, if unsuccessful, remove from table (e.g. max level reached)
					if not P4FComforts_GrowingTreesUpgradePlant( tree ) then
					-- if max level: remove from table!
					-- if tree.level == table.getn( P4FComforts_GrowingTreeSets[tree.setID] ) then
						table.remove( gvGrowingTrees.trees, i )
					end
				end
				
			else
				tree.counter = tree.counter - 1
			end
		end
	end
end

-- return true if the tree could be replaced by the next stage entity
function P4FComforts_GrowingTreesUpgradePlant( tree )	-- table
	
	tree.level = tree.level + 1
	local newType = P4FComforts_GrowingTreeSets[tree.setID][tree.sequenceIndex][tree.level]
	if not newType then
		-- max level reached
		return false
	end
	gvGrowingTrees.excludeDestroyedTrees[tree.id] = true
	local newID = ReplaceEntity( tree.id, newType )
	tree.counter = math.random( gvGrowingTrees.minTime, gvGrowingTrees.maxTime )
	tree.id = newID
	
	if gvGrowingTrees.debug then
		local pos = GetPos( newID )
		Logic.CreateEffect( GGL_Effects.FXSalimHeal, pos.X, pos.Y, 0 )
	end
	return true
	
end

function P4FComforts_GrowingTreesCheckGrowPos( _position )
	for p = 1, 8 do
		if AreEntitiesInArea( p, 0, _position, 250, 1 ) then
			return false
		end
	end
	return true
end

function ShuffleTable( tbl )
	for i = table.getn( tbl ), 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- allow the user to let the map be auto saved every 5 minutes
-- _useDefaultKey binds P4FComforts_ToggleAutosave to default keypress [Shift + S]
-- use P4FComforts_ToggleAutosave to (de)activate
-- use P4FComforts_TryAutosave to do a quicksave if it has not been saved within the last 3 minutes
-- use P4FComforts_Game_Autoload to quickload, be careful with this!
-- note: key input does not survive savegame
-- note: for some reason the game will be saved again directly after loading it ...

function P4FComforts_Autosave( _useDefaultKey )
	p4f_autosave = {}
	p4f_autosave.LastAutosaveTime = -1
	p4f_autosave.Autosave = false
	p4f_autosave.GameSaved = false
	
	QuickSaveOrig = QuickSaveOrig or QuickSave
	QuickSave = function()
		p4f_autosave.GameSaved = true
		p4f_autosave.LastAutosaveTime = Round( Logic.GetTime() )
		QuickSaveOrig()
	end
	
	-- ignore color string
	MainWindow_SaveGame_CreateSaveGameDescriptionOrig = MainWindow_SaveGame_CreateSaveGameDescriptionOrig or MainWindow_SaveGame_CreateSaveGameDescription
	MainWindow_SaveGame_CreateSaveGameDescription = function()
		-- Create description
		local Description = ""
		-- Get map
		local MapName = Framework.GetCurrentMapName()
		Description = MapName .. " - " .. Framework.GetSystemTimeDateString()
		-- Use it
		return Description
	end
	
	StartSimpleJob("SJ_P4FComforts_Autosave")
	
	-- how to toggle autosave on/off should be selected manually (or default)
	if _useDefaultKey then
		Input.KeyBindDown(Keys.ModifierShift + Keys.S, "P4FComforts_ToggleAutosave()", 2)
	end
end


function P4FComforts_TryAutosave()
	local _time = Round( Logic.GetTime() )
	local gamestate = Logic.PlayerGetGameState( GUI.GetPlayerID() )
	-- make sure the player is still playing (e.g. game is not lost or won already)
	if p4f_autosave.Autosave and gamestate == 1 then
		if _time - p4f_autosave.LastAutosaveTime > 180 then	-- if not saved within 3 minutes: save!
			Message("@color:173,255,47 Spiel wird gespeichert ...")
			StartCountdown(2, P4FComforts_Game_Autosave, false)
		end
	end
end

function SJ_P4FComforts_Autosave()
	if Counter.Tick2("SJ_P4FComforts_Autosave", 300) then	-- check every 5 minutes
		P4FComforts_TryAutosave()
	end
end

function P4FComforts_Game_Autosave()
	if p4f_autosave.Autosave then
		QuickSave()
	end
end

function P4FComforts_Game_Autoload()	-- can be called in the map script, e.g. on failure or similar
	if p4f_autosave.Autosave then
		if p4f_autosave.GameSaved then
			Message("@color:173,255,47 Der letzte Spielstand wird geladen ...")
			QuickLoad()
		else
			Message("@color:255,0,0 Kann nicht Laden: das Spiel wurde noch nicht automatisch gespeichert!")
		end
	end
end

function P4FComforts_ToggleAutosave()
	p4f_autosave.Autosave = not p4f_autosave.Autosave
	if p4f_autosave.Autosave then
		Message("@color:173,255,47 automatisches Speichern an")
	else
		Message("@color:173,255,47 automatisches Speichern aus")
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- slowly rotate the camera while the game is paused
-- must be called again after game loaded! -> moved directly inside this function
function P4FComforts_PauseCameraRotation()
	P4FComforts_PauseCameraRotationInit()
	AddOnSaveGameLoaded( P4FComforts_PauseCameraRotationInit )
end

function P4FComforts_PauseCameraRotationInit()
	
	Game_GameTimeSetFactor_Orig = Game_GameTimeSetFactor_Orig or Game.GameTimeSetFactor
	Game.GameTimeSetFactor = function(_factor)
		local old = Game.GameTimeGetFactor()
		Game_GameTimeSetFactor_Orig(_factor)
		-- avoid to break the cutscene code
		if gvCutscene then return end
		if (_factor > 0) and (old == 0) then	-- only reset when it was paused before (avoids flip back when speeding the game up/down)
			Camera.RotSetAngle(gvMission.lastCameraAngle or -45)
			--Camera.RotSetFlipBack(1)
			Camera.SetControlMode(0)
		elseif _factor == 0 then
			--Camera.RotSetFlipBack(0)
			Camera.SetControlMode(1)
			gvMission.lastCameraAngle = Camera.RotGetAngle()
		end
	end
	
	-- TODO: the rotation speed depends on the system (FPS?)
	-- maybe use XGUIEng.GetSystemTime() to determine how fast we want to rotate?
	gvMission.lastDeltaTime = 0.01
	gvMission.lastSystemTime = XGUIEng.GetSystemTime()
	GUIUpdate_ResourceAmount_Orig = GUIUpdate_ResourceAmount_Orig or GUIUpdate_ResourceAmount
	GUIUpdate_ResourceAmount = function( _ResourceType, _RefinedFlag )
		GUIUpdate_ResourceAmount_Orig( _ResourceType, _RefinedFlag )
		
		gvMission.lastDeltaTime = XGUIEng.GetSystemTime() - gvMission.lastSystemTime
		gvMission.lastSystemTime = XGUIEng.GetSystemTime()
		if Game.GameTimeGetFactor() == 0 then
			--Camera.RotSetAngle( Camera.RotGetAngle() + 0.0015 )
			Camera.RotSetAngle( Camera.RotGetAngle() + 5 * gvMission.lastDeltaTime )
		end
	end
	
	GameCallback_GameSpeedChanged = function(_Speed)
			if _Speed == 0 then
					XGUIEng.ShowWidget("PauseScreen", 1)
			else
					XGUIEng.ShowWidget("PauseScreen", 0)
			end
	end
	
end
	
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- allow the player to select all his troops of a specific type by pressing control + the button (top icons)

-- note: using IsEntityOnScreen - only select units that are currently in the area that the screen covers
--> this has some erros as of now... plus it moust be implemented for serfs and cannons too

function P4FComforts_EnableGlobalTroopSelection()
	
	GUITooltip_Generic_OrigGlobalSelection = GUITooltip_Generic_OrigGlobalSelection or GUITooltip_Generic
	GUITooltip_Generic = function( ttString )
		GUITooltip_Generic_OrigGlobalSelection( ttString )
		
		local newText
		
		if ttString == "MenuTop/Find_spear" then
			newText = "@color:180,180,180 Speerträger @cr @color:255,255,255 Springt zum nächsten Speerträger und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "MenuTop/Find_sword" then
			newText = "@color:180,180,180 Schwertkämpfer @cr @color:255,255,255 Springt zum nächsten Schwertkämpfer und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "AOMenuTop/Find_rifle" then
			newText = "@color:180,180,180 Scharfschütze @cr @color:255,255,255 Springt zum nächsten Scharfschützen und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "MenuTop/Find_bow" then
			newText = "@color:180,180,180 Schützen @cr @color:255,255,255 Springt zum nächsten Schützen und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "MenuTop/Find_lightcavalry" then
			newText = "@color:180,180,180 Leichte Kavallerie @cr @color:255,255,255 Springt zur nächsten leichten Kavallerie und selektiert sie. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "MenuTop/Find_heavycavalry" then
			newText = "@color:180,180,180 Schwere Kavallerie @cr @color:255,255,255 Springt zur nächsten schweren Kavallerie und selektiert sie. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "MenuTop/Find_cannon" then
			newText = "@color:180,180,180 Kanonen @cr @color:255,255,255 Springt zur nächsten Kanone und selektiert sie. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "AOMenuTop/Find_scout" then
			newText = "@color:180,180,180 Kundschafter @cr @color:255,255,255 Springt zum nächsten Kundschafter und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		elseif ttString == "AOMenuTop/Find_Thief" then
			newText = "@color:180,180,180 Dieb @cr @color:255,255,255 Springt zum nächsten Dieb und selektiert ihn. Haltet gleichzeitig [Steuerung] gedrückt, um alle Einheiten zu selektieren."
			
		end
		
		if newText then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(newText) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "" )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "" )
		end
	end
	
		
	KeyBindings_SelectUnit_Orig = KeyBindings_SelectUnit_Orig or KeyBindings_SelectUnit
	KeyBindings_SelectUnit = function(_UpgradeCategory, _type)
		if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 1 then
			
			local hits = 0
			local entityTable = {}
			
			if _UpgradeCategory == UpgradeCategories.LeaderSword
			or _UpgradeCategory == UpgradeCategories.LeaderPoleArm
			or _UpgradeCategory == UpgradeCategories.LeaderRifle
			or _UpgradeCategory == UpgradeCategories.LeaderCavalry
			or _UpgradeCategory == UpgradeCategories.LeaderHeavyCavalry
			or _UpgradeCategory == UpgradeCategories.LeaderBow
			or _UpgradeCategory == UpgradeCategories.Scout then
				
				-- for all leaders: check if they are in the entity category
				local LastLeaderID
				for n = 1, Logic.GetNumberOfLeader(gvMission.PlayerID) do
					LeaderID = Logic.GetNextLeader(gvMission.PlayerID, LastLeaderID)
					if LeaderID ~= 0 then
						if IsEntityInUpgradeCategory(LeaderID, _UpgradeCategory) then
						--and IsEntityOnScreen( LeaderID ) then
							hits = hits + 1
							entityTable[hits] = LeaderID
						end
					end
					LastLeaderID = LeaderID
				end
				
				if hits == 1 then
					KeyBindings_SelectUnit_Orig(_UpgradeCategory, _type)
					
				elseif hits > 0 then	-- or hits > 1 does not matter...
					GUI.ClearSelection()
					for i = 1, hits do
						GUI.SelectEntity(entityTable[i])
					end
				end
			
			-- cannot catch thief using Logic.GetNextLeader
			elseif _UpgradeCategory == UpgradeCategories.Thief then
				
				local entityTable = { Logic.GetPlayerEntities( gvMission.PlayerID, Entities.PU_Thief, 48 ) }
				
				hits = entityTable[1]
				table.remove( entityTable, 1 )
				
				if hits == 1 then
					KeyBindings_SelectUnit_Orig(_UpgradeCategory, _type)
					
				elseif hits > 0 then	-- or hits > 1 does not matter...
					GUI.ClearSelection()
					for i = 1, hits do
						GUI.SelectEntity(entityTable[i])
					end
				end
				
			else
				KeyBindings_SelectUnit_Orig(_UpgradeCategory, _type)
			end
			
		else
			KeyBindings_SelectUnit_Orig(_UpgradeCategory, _type)
		end
	end
	
	KeyBindings_SelectCannons_Orig = KeyBindings_SelectCannons_Orig or KeyBindings_SelectCannons
	KeyBindings_SelectCannons = function()
		if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 1 then
			local CannonTable = {}
			CannonTable[1] = {Logic.GetPlayerEntities( gvMission.PlayerID, Entities.PV_Cannon1, 20 )}
			CannonTable[2] = {Logic.GetPlayerEntities( gvMission.PlayerID, Entities.PV_Cannon2, 20 )}
			CannonTable[3] = {Logic.GetPlayerEntities( gvMission.PlayerID, Entities.PV_Cannon3, 20 )}
			CannonTable[4] = {Logic.GetPlayerEntities( gvMission.PlayerID, Entities.PV_Cannon4, 20 )}
			if CannonTable[1][1] + CannonTable[2][1] + CannonTable[3][1] + CannonTable[4][1] == 0 then
				return
			end
			-- found cannons ... clear selection and select as many as possible
			GUI.ClearSelection()
			for i = 1, 4 do
				for j = 2, CannonTable[i][1]+1 do
					GUI.SelectEntity(CannonTable[i][j])
				end
			end
		else
			KeyBindings_SelectCannons_Orig()
		end
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- needs triggerfix
function P4FComforts_SerfMenuVideoPreview()
	
	assert( mcbTrigger, "missing triggerfix" )
	
	-- inspired by Noigi (Tribe Neuland)
	-- serf menu: when hovering over a building button, display the corresponding building video at the right
	gvVideoPreview = {
		currentVideo = "",
		nextVideo = "",
		showDefaultVideo = true,
		showDefaultVeto = false,
		[UpgradeCategories.Residence]				= "pb_residence1",
		[UpgradeCategories.Farm]					= "pb_farm1",
		[UpgradeCategories.GenericMine]				= "pb_ironmine1",	-- pb_sulfurmine1, pu_miner
		[UpgradeCategories.VillageCenter]			= "pb_villagecenter1",
		[UpgradeCategories.Blacksmith]				= "pb_blacksmith1",
		[UpgradeCategories.StoneMason]				= "pb_stonemason1",
		[UpgradeCategories.Alchemist]				= "pb_alchemist1",
		[UpgradeCategories.Monastery]				= "pb_monastery1",
		[UpgradeCategories.University]				= "pb_university1",
		[UpgradeCategories.Market]					= "pb_market1",
		[UpgradeCategories.Bank]					= "pb_bank1",
		[UpgradeCategories.Barracks]				= "pb_barracks1",
		[UpgradeCategories.Archery]					= "pb_archery1",
		[UpgradeCategories.Stable]					= "pb_stable1",
		[UpgradeCategories.Foundry]					= "pb_foundry1",
		[UpgradeCategories.Brickworks]				= "pb_brickworks1",
		[UpgradeCategories.Tower]					= "pb_tower1",
		[UpgradeCategories.Sawmill]					= "pb_sawmill1",
		[UpgradeCategories.Weathermachine]			= "pb_weathertower1",
		[UpgradeCategories.PowerPlant]				= "pb_powerplant1",	-- pb_weathermachine also exists (similar image, but not the same)
		[UpgradeCategories.Tavern]					= "pb_tavern1",
		[UpgradeCategories.GunsmithWorkshop]		= "pb_gunsmithworkshop1",
		[UpgradeCategories.MasterBuilderWorkshop]	= "pb_masterbuilderworkshop",
		[UpgradeCategories.GenericBridge]			= "pu_masterbuilder",
		[UpgradeCategories.Outpost]					= "pb_headquarters1",
		[UpgradeCategories.Beautification01]		= "pb_beautification01",
		[UpgradeCategories.Beautification02]		= "pb_beautification02",
		[UpgradeCategories.Beautification03]		= "pb_beautification03",
		[UpgradeCategories.Beautification04]		= "pb_beautification04",
		[UpgradeCategories.Beautification05]		= "pb_beautification05",
		[UpgradeCategories.Beautification06]		= "pb_beautification06",
		[UpgradeCategories.Beautification07]		= "pb_beautification07",
		[UpgradeCategories.Beautification08]		= "pb_beautification08",
		[UpgradeCategories.Beautification09]		= "pb_beautification09",
		[UpgradeCategories.Beautification10]		= "pb_beautification10",
		[UpgradeCategories.Beautification11]		= "pb_beautification11",
		[UpgradeCategories.Beautification12]		= "pb_beautification12",
	}
	
	gvVideoPreview.ActivateVideoPreview = function( video )
		gvVideoPreview.nextVideo = video
		gvVideoPreview.showDefaultVeto = true
	end
	
	gvVideoPreview.GetCurrentDefaultVideoPreview = function()
		local sel = GUI.GetSelectedEntity()
		if sel then
			local entityType = Logic.GetEntityType(sel)
			if entityType and entityType > 0 then
				return Logic.GetEntityTypeName( entityType )
				--return string.lower( Logic.GetEntityTypeName( entityType ) )
			end
		end
		
		return ""
	end
	
	gvVideoPreview.GUIUpdate_SelectionName = GUIUpdate_SelectionName
	GUIUpdate_SelectionName = function()
		gvVideoPreview.GUIUpdate_SelectionName()
		
		local newVideo = gvVideoPreview.showDefaultVideo and gvVideoPreview.GetCurrentDefaultVideoPreview() or gvVideoPreview.nextVideo
		if newVideo ~= gvVideoPreview.currentVideo then
			gvVideoPreview.currentVideo = newVideo
			XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, "data\\graphics\\videos\\" .. newVideo .. ".bik", 1 )
		end
	end
	
	gvVideoPreview.GUITooltip_ConstructBuilding = GUITooltip_ConstructBuilding
	GUITooltip_ConstructBuilding = function( _CategoryType, _NormalTooltip, _DiabledTooltip,_TechnologyType, _ShortCut )
		gvVideoPreview.GUITooltip_ConstructBuilding( _CategoryType, _NormalTooltip, _DiabledTooltip,_TechnologyType, _ShortCut )
		
		if gvVideoPreview[_CategoryType] then
			gvVideoPreview.ActivateVideoPreview( gvVideoPreview[_CategoryType] )
		end
	end
	
	StartSimpleHiResJob( function()
		gvVideoPreview.showDefaultVideo = not gvVideoPreview.showDefaultVeto
		gvVideoPreview.showDefaultVeto = false
	end )
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

function P4FComforts_RefinedResourceView()
	
	-- resource view tooltip; show refined resource values
	GUITooltip_Generic_ResourceView = GUITooltip_Generic_ResourceView or GUITooltip_Generic
	GUITooltip_Generic = function( tt )
		GUITooltip_Generic_ResourceView( tt )
		
		local player = gvMission.PlayerID
		
		if tt == "MenuResources/gold" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Gold ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		elseif tt == "MenuResources/clay" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Clay ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		elseif tt == "MenuResources/wood" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Wood ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		elseif tt == "MenuResources/stone" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Stone ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		elseif tt == "MenuResources/iron" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Iron ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		elseif tt == "MenuResources/sulfur" then
			local text = string.format( "%s @cr @cr Veredelt: %d", XGUIEng.GetText( gvGUI_WidgetID.TooltipBottomText ), Logic.GetPlayersGlobalResource( player, ResourceType.Sulfur ) )
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, text )
		end
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- enable or disable refined resource tooltips, inspired by Messoras' idea
-- set mode:
-- 0 = off (normal tooltip)
-- 1 = on, ostentatious (green and white)
-- 2 = on, subtle (white and gray)
-- uses keypress [R + Shift]
function P4FComforts_SetRefinedResourceTooltipsMode( _mode )
	
	local mode = _mode or 1
	
	if not gvMission.RefinedResourceTooltip then
		gvMission.RefinedResourceTooltip = {
			mode = mode,
			InterfaceTool_CreateCostString = InterfaceTool_CreateCostString,
			hasKeybind = false,
		}
	end
	
	-- override function in interfacetools
	InterfaceTool_CreateCostString = P4FComforts_InterfaceTool_CreateCostString
	
	-- if mode > 0 then
		-- InterfaceTool_CreateCostString = P4FComforts_InterfaceTool_CreateCostString
	-- else
		-- InterfaceTool_CreateCostString = gvMission.RefinedResourceTooltip.InterfaceTool_CreateCostString
	-- end
	
	if not gvMission.RefinedResourceTooltip.hasKeybind then
		Input.KeyBindDown( Keys.R + Keys.ModifierShift, "P4FComforts_CycleRefinedResourceTooltipsMode()", 2 )
		gvMission.RefinedResourceTooltip.hasKeybind = true
	end
	
	AddOnSaveGameLoaded( function() Input.KeyBindDown( Keys.R + Keys.ModifierShift, "P4FComforts_CycleRefinedResourceTooltipsMode()", 2 ) end )
	
end

-- cycle through all 3 modes using a keybind
function P4FComforts_CycleRefinedResourceTooltipsMode()
	
	gvMission.RefinedResourceTooltip.mode = gvMission.RefinedResourceTooltip.mode + 1
	if gvMission.RefinedResourceTooltip.mode > 2 then
		gvMission.RefinedResourceTooltip.mode = 0
	end
	P4FComforts_SetRefinedResourceTooltipsMode( gvMission.RefinedResourceTooltip.mode )
	
end

function P4FComforts_InterfaceTool_CreateCostString( _Costs )
	
	-- LuaDebugger.Log( _Costs )
	
	local PlayerID = GUI.GetPlayerID()
	
	local PlayerGold = GetGold(PlayerID)
	local PlayerWood = GetWood(PlayerID)
	local PlayerClay = GetClay(PlayerID)
	local PlayerIron = GetIron(PlayerID)
	local PlayerStone = GetStone(PlayerID)
	local PlayerSulfur = GetSulfur(PlayerID)
	local CostString = ""
	
	-- color scheme
	local cWhite = " @color:255,255,255,255 "
	
	-- mode 0: default (vanilla) white + red
	local cNormal = " @color:255,255,255,255 "
	local cEnoughRefined = " @color:255,255,255,255 "
	local cNotEnough = " @color:220,64,16,255 "
	
	-- mode 1: green + white
	if gvMission.RefinedResourceTooltip.mode == 1 then
		cNormal = " @color:255,255,255,255 "
		cEnoughRefined = " @color:16,200,16,255 "
		cNotEnough = " @color:220,64,16,255 "
		
	-- mode 2: white + gray
	elseif gvMission.RefinedResourceTooltip.mode == 2 then
		cNormal = " @color:180,180,180 "	-- not enough refined, but enough in total
		cEnoughRefined = " @color:255,255,255,255 "
		cNotEnough = " @color:220,64,16,255 "
	end
	
	-- workaround: costs can either be in the form of "gold = 100" or "[ResourceType.Gold] = 100" or "Gold = 100"
	_Costs.gold = _Costs.gold or _Costs[ResourceType.Gold] or _Costs.Gold
	_Costs.wood = _Costs.wood or _Costs[ResourceType.Wood] or _Costs.Wood
	_Costs.clay = _Costs.clay or _Costs[ResourceType.Clay] or _Costs.Clay
	_Costs.stone = _Costs.stone or _Costs[ResourceType.Stone] or _Costs.Stone
	_Costs.iron = _Costs.iron or _Costs[ResourceType.Iron] or _Costs.Iron
	_Costs.sulfur = _Costs.sulfur or _Costs[ResourceType.Sulfur] or _Costs.Sulfur
	
	if _Costs.gold and _Costs.gold > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameMoney") .. ": "
		local color = cNormal
		if PlayerGold >= _Costs.gold then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Gold ) >= _Costs.gold then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.gold .. cWhite .. " @cr "
	end
	
	if _Costs.wood and _Costs.wood > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameWood") .. ": "
		local color = cNormal
		if PlayerWood >= _Costs.wood then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Wood ) >= _Costs.wood then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.wood .. cWhite .. " @cr "
	end
	
	if _Costs.clay and _Costs.clay > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameClay") .. ": "
		local color = cNormal
		if PlayerClay >= _Costs.clay then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Clay ) >= _Costs.clay then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.clay .. cWhite .. " @cr "
	end
			
	if _Costs.stone and _Costs.stone > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameStone") .. ": "
		local color = cNormal
		if PlayerStone >= _Costs.stone then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Stone ) >= _Costs.stone then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.stone .. cWhite .. " @cr "
	end
	
	if _Costs.iron and _Costs.iron > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameIron") .. ": "
		local color = cNormal
		if PlayerIron >= _Costs.iron then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Iron ) >= _Costs.iron then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.iron .. cWhite .. " @cr "
	end
		
	if _Costs.sulfur and _Costs.sulfur > 0 then
		CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NameSulfur") .. ": "
		local color = cNormal
		if PlayerSulfur >= _Costs.sulfur then
			if Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Sulfur ) >= _Costs.sulfur then
				color = cEnoughRefined
			end
		else
			color = cNotEnough
		end
		CostString = CostString .. color .. _Costs.sulfur .. cWhite .. " @cr "
	end
	
	-- operating on the _Costs table also changes this global table - must be reset!
	InterfaceGlobals.CostTable = {}
	
	return CostString
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- combines the previous variants for better combat music and foresee next weather
function P4FComforts_EnhancedMusic()
	
	assert( Round )
	
	-- idea: start battle music only when the player has lost more than one single unit recently
	-- decrease this counter every second (see LocalMusic_UpdateMusic)
	--> experimental values for the threshold and the counter increase on entity death (see LocalMusic.CallbackSettlerKilled)
	LocalMusic.BattleCounter = 0
	LocalMusic.BattleCounterGrowth = 5
	LocalMusic.BattleCounterThreshold = 15
	LocalMusic.ForeseeNextWeatherTime = 25
	-- LocalMusic.LastSettlerDiedTime = nil
	-- if no unit died within X seconds, play normal music again
	LocalMusic.TimeBeforeRevertToNormalMusic = 20
	
	LocalMusic.SetBattle = {
		{"03_CombatEurope1.mp3", 117},
		{"43_Extra1_DarkMoor_Combat.mp3", 120},
		{"04_CombatMediterranean1.mp3", 113},
		{"05_CombatEvelance1.mp3", 117},
	}
	
	-- override
	LocalMusic_UpdateMusic = function()
		
		local currentTime = Round( Logic.GetTime() )
		
		-- GUI.ClearNotes()
		-- Message( "BattleCounter: ".. LocalMusic.BattleCounter )
		-- Message( "LastSettlerDiedTime: ".. (LocalMusic.LastSettlerDiedTime or "-") )
		
		if LocalMusic.BattleCounter > 0 then
			LocalMusic.BattleCounter = LocalMusic.BattleCounter - 1
			
		-- revert back to normal music if no player unit was killed for some time
		else
			if LocalMusic.LastSettlerDiedTime
			and LocalMusic.LastSettlerDiedTime + LocalMusic.TimeBeforeRevertToNormalMusic < currentTime then
				LocalMusic.SongLength = 0
				LocalMusic.LastSettlerDiedTime = nil
				-- LuaDebugger.Log( "back to normal music" )
			end
		end
		
		if LocalMusic.BattlesOnTheMap == 0 then
			--Music is playing?
			if LocalMusic.SongLength > currentTime then
				return
			end
		end
		
		local Weather
		
		-- is the weather going to change soon? use the next weather state instead!
		if Logic.GetTimeToNextWeatherPeriod() < LocalMusic.ForeseeNextWeatherTime then
			-- get the NEXT weather
			Weather = Logic.GetNextWeatherState()
			--LuaDebugger.Log("use NEXT weather for music: " .. Weather)
		else
			--get current Weather
			Weather = Logic.GetWeatherState()
			--LuaDebugger.Log("time to next weather period: " .. Logic.GetTimeToNextWeatherPeriod())
		end
		
		if Weather == 1 then
			--normal
			Weather = "summer"
		elseif Weather == 2 then
			--rain
			Weather = "snow"
		elseif Weather == 3 then
			--snow
			Weather = "snow"
		end
		
		local SetToUse
		
		if LocalMusic.BattlesOnTheMap == 1 then
			SetToUse = LocalMusic.SetBattle
		-- Player was hurt by Evil Tribe - not working anyway
		-- elseif LocalMusic.BattlesOnTheMap == 2 then
			-- SetToUse = LocalMusic.SetEvilBattle
		elseif LocalMusic.BattlesOnTheMap == 0 then
			SetToUse = LocalMusic.UseSet[Weather]
		end
		
		--is briefing running?
		if (IsBriefingActive ~= nil and IsBriefingActive() == true)
		or (IsCutsceneActive ~= nil and IsCutsceneActive() == true) then
			SetToUse = LocalMusic.SetBriefing
		end
		
		local SongAmount = table.getn(SetToUse)
		local Random = 1 + XGUIEng.GetRandom(SongAmount-1)
		local SongToPlay = Folders.Music .. SetToUse[Random][1]
		
		Sound.StartMusic( SongToPlay, 127)
		LocalMusic.SongLength =  currentTime + SetToUse[Random][2] + 2
		--LuaDebugger.Log("start new music for " .. Weather)
		LocalMusic.CurrentSongName = SongToPlay
		
		LocalMusic.BattlesOnTheMap = 0
	end
	
	-- override
	LocalMusic.CallbackSettlerKilled = function( _HurterPlayerID, _HurtPlayerID )
		
		local PlayerID = GUI.GetPlayerID()
		-- for multiplayer: only care about own units
		if PlayerID ~= _HurtPlayerID then
			return
		end
		
		if _HurterPlayerID == _HurtPlayerID then
			return
		end
		
		local currentTime = Round( Logic.GetTime() )
		
		LocalMusic.BattleCounter = LocalMusic.BattleCounter + LocalMusic.BattleCounterGrowth
		LocalMusic.LastSettlerDiedTime = currentTime
		
		if LocalMusic.LastBattleMusicStarted < currentTime
		and LocalMusic.BattleCounter >= LocalMusic.BattleCounterThreshold then
			--LuaDebugger.Log("start battle music")
			LocalMusic.BattlesOnTheMap = 1
			LocalMusic.LastBattleMusicStarted = currentTime + 127
			LocalMusic.SongLength = 0
		end
	end
	
end

-------------------------------------------------------------------------------------------------------------------------------------------------------

-- add additional music tracks to the european summer music playlist
function P4FComforts_ExtendMusicSetEuropean()
	
	-- LocalMusic.UseSet = EUROPEMUSIC
	LocalMusic.SetEurope["summer"] = {
		{ "40_Extra1_BridgeBuild.mp3", 129 },
		{ "01_MainTheme1.mp3", 152 },
		{ "02_MainTheme2.mp3", 127 },
		{ "06_MiddleEurope_Summer1.mp3", 149 },
		{ "07_MiddleEurope_Summer2.mp3", 165 },
		{ "08_MiddleEurope_Summer3.mp3", 168 },
		{ "09_MiddleEurope_Summer4.mp3", 160 },
		{ "10_MiddleEurope_Summer5.mp3", 158 },
		{ "11_MiddleEurope_Summer6.mp3", 153 },
		{ "12_MiddleEurope_Summer7.mp3", 155 },
		{ "13_MiddleEurope_Summer8.mp3", 156 },
		{ "14_MiddleEurope_Summer9.mp3", 138 },
		{ "15_Mediterranean_Summer1.mp3", 165 },
		{ "16_Mediterranean_Summer2.mp3", 142 },
		{ "17_Highland_Summer1.mp3", 150 },
		{ "18_Highland_Summer2.mp3", 137 },
	}
	
end


function P4FComforts_ExtendMusicSetMediterranean()
	
	-- MEDITERANEANMUSIC
	LocalMusic.SetMediterranean["summer"] = {
		{ "40_Extra1_BridgeBuild.mp3", 129 },
		{ "01_MainTheme1.mp3", 152 },
		{ "02_MainTheme2.mp3", 127 },
		{ "15_Mediterranean_Summer1.mp3", 165 },
		{ "15_Mediterranean_Summer1.mp3", 165 },
		{ "16_Mediterranean_Summer2.mp3", 142 },
		{ "16_Mediterranean_Summer2.mp3", 142 },
		{ "09_MiddleEurope_Summer4.mp3", 160 },
		{ "10_MiddleEurope_Summer5.mp3", 158 },
		{ "11_MiddleEurope_Summer6.mp3", 153 },
		{ "12_MiddleEurope_Summer7.mp3", 155 },
		{ "14_MiddleEurope_Summer9.mp3", 138 },
	}
	
end

-- TODO: can do a similar extension for other music sets

-------------------------------------------------------------------------------------------------------------------------------------------------------

