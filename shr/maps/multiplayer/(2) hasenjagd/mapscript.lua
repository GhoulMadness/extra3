initEMS = function()return false end;
Script.Load("maps\\user\\EMS\\load.lua");
if not CNetwork then
	math.randomseed(XGUIEng.GetSystemTime())		
end
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
	--
	IncludeGlobals("tools\\BSinit")
	-- custom Map Stuff
	AddPeriodicSummer(10)	

	MultiplayerTools.InitCameraPositionsForPlayers()	

	--[[for i = 1,16 do
		CreateWoodPile("Holz"..i,10000000)
	end]]

	LocalMusic.UseSet = HIGHLANDMUSIC
	for i = 1, 2 do 
		Display.SetPlayerColorMapping(i, XNetwork.GameInformation_GetLogicPlayerColor(i)); 
	end; 		
	InitMerchants()
	
	if XNetwork.Manager_DoesExist() == 0 then	
		math.randomseed(Game.RealTimeGetMs())
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i)
		end
		local PlayerID = GUI.GetPlayerID()
		Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
		Logic.PlayerSetGameStateToPlaying( PlayerID )
	end
	
	
	end,
	
	Callback_OnGameStart = function()
		for i = 1,2 do
			ForbidTechnology(Technologies.B_Bridge,i)
			ForbidTechnology(Technologies.T_MakeSnow,i)
		end
		if XNetwork.Manager_DoesExist() == 0 then
			local InitGoldRaw 		= 1000
			local InitClayRaw 		= 1800
			local InitWoodRaw 		= 1500
			local InitStoneRaw 		= 800
			local InitIronRaw 		= 50
			local InitSulfurRaw		= 50
			for i = 2,4 do
				--Add Players Resources
				Tools.GiveResouces(i, InitGoldRaw , InitClayRaw,InitWoodRaw, InitStoneRaw,InitIronRaw,InitSulfurRaw)
			end	
			Logic.ActivateUpdateOfExplorationForAllPlayers()
			Input.KeyBindDown(Keys.ModifierAlt+Keys.P, "SwitchPlayerID()", 2)
		end
		TagNachtZyklus(24,1,0,-3,1)
		InitBanditTroops()
		-- register bandits and evil stuff in statistics
		Logic.SetPlayerRawName(7, "???")
		Logic.PlayerSetIsHumanFlag(7, 1)
		Logic.PlayerSetPlayerColor(7, GUI.GetPlayerColor(7))										  
		InitEggs()
	end,
	
	Callback_OnPeacetimeEnded = function()
		for i = 1,2 do
			AllowTechnology(Technologies.B_Bridge,i)								 
		end
		for i = 1,4 do
			DestroyEntity("barrier"..i)
		end
		StartSimpleJob("ControlRabbits")
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSilvermineEmpty", 1) 
		Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_DESTROYED, "", "OnSpecialRabbitDied", 1)
	end,
 
	Peacetime = 40,
	
	TowerLevel = 3,
	Markets = 0,
	NumberOfHeroesForAll = 2,
	HeavyCavalry = 2,
	LightCavalry = 2,
	Cannon1 = 1,
	Cannon2 = 1,
	Cannon3 = 1,
	Cannon4 = 1,
	--[[Cannon5 = 1,
	Cannon6 = 1,
	Dome = 0,
	Scaremonger = 0,
	Silversmith = 0,
	Lighthouse = 0,
	MercenaryTower = 0,
	Mint = 0,
	Tradepost = 0
	
	]]
};
function SwitchPlayerID()
	local oldID = GUI.GetPlayerID()
	local newID 
	if oldID < 2 then
		newID = oldID + 1
		GUI.SetControlledPlayer(newID)
	else
		newID = 1
		GUI.SetControlledPlayer(newID)
	end
	Message("Ihr spielt nun aus der Perspektive von Spieler "..newID)
end
function InitMerchants()
	for i = 1,2 do
		_G["mercenaryId"..i] = Logic.GetEntityIDByName("merc"..i)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_Thief, 2, ResourceType.Gold, 500)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.CU_BlackKnight_LeaderSword3, 5, ResourceType.Gold, 750)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_LeaderSword3, 12, ResourceType.Gold, 700)
		Logic.AddMercenaryOffer(_G["mercenaryId"..i], Entities.PU_LeaderBow3, 5, ResourceType.Gold, 1000)	
	end	
end

function InitBanditTroops()
	for i = 1,2 do
		SetHostile(i,7)
	end
	Display.SetPlayerColorMapping(7,ROBBERS_COLOR)
	ResearchTechnology(Technologies.T_Fletching,7)
	ResearchTechnology(Technologies.T_BodkinArrow,7)
	ResearchTechnology(Technologies.T_SoftArcherArmor,7)
	ResearchTechnology(Technologies.T_PaddedArcherArmor,7)
	ResearchTechnology(Technologies.T_LeatherArcherArmor,7)
	gvBandpos1 = {X = 27250, Y = 53800}
	gvBandpos2 = {X = 27250, Y = 600}
	
	Logic.SetEntityName(Logic.CreateEntity(Entities.CB_Bastille1, gvBandpos1.X, gvBandpos1.Y, 0, 7),"BanditTowerTop")
	Logic.SetEntityName(Logic.CreateEntity(Entities.CB_Bastille1, gvBandpos2.X, gvBandpos2.Y, 180, 7),"BanditTowerBottom")
	
	troop1 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y - 700 ,0 )
	troop2 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y + 700 ,0 )
	troop3 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos1.X , gvBandpos1.Y - 550,0 )
	troop4 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos2.X , gvBandpos2.Y + 550,0 )
	troop5 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos1.X , gvBandpos1.Y - 850,0 )
	troop6 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos2.X , gvBandpos2.Y + 850,0 )
	Logic.GroupStand(troop3)
	Logic.GroupStand(troop4)
	--
	StartSimpleJob("BanditControl")
end
function BanditControl()
	if not IsExisting("BanditTowerTop") and not IsExisting("BanditTowerBottom") then
		if not IsExisting(troop1) and not IsExisting(troop2) and not IsExisting(troop3) and not IsExisting(troop4) and not IsExisting(troop5) and not IsExisting(troop6) then
			return true
		end
	end
	if IsExisting("BanditTowerTop") then
		if IsDestroyed(troop1) then
			if Counter.Tick2("BanditRespawn"..troop1,80) then
				troop1 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos1.X , gvBandpos1.Y - 700 ,0 )
			end
			
		end
		if IsDestroyed(troop3) then
			if Counter.Tick2("BanditRespawn"..troop3,60) then
				troop3 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos1.X , gvBandpos1.Y - 550,0 )
				Logic.GroupStand(troop3)
			end
			
		end
		if IsDestroyed(troop5) then
			if Counter.Tick2("BanditRespawn"..troop5,45) then
				troop5 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos1.X , gvBandpos1.Y - 850,0 )
			end
			
		end
	else
		if not gvBanditTopKilled and not IsExisting(troop1) and not IsExisting(troop3) and not IsExisting(troop5) then
			BanditBaseDestroyed(1)
		end
	end
	if IsExisting("BanditTowerBottom") then
		if IsDestroyed(troop2) then
			if Counter.Tick2("BanditRespawn"..troop2,80) then
				troop2 = CreateGroup(7, Entities.CU_VeteranLieutenant, 3, gvBandpos2.X , gvBandpos2.Y + 700 ,0 )
			end
			
		end
		if IsDestroyed(troop4) then
			if Counter.Tick2("BanditRespawn"..troop4,60) then
				troop4 = CreateGroup(7, Entities.PU_LeaderBow4, 12, gvBandpos2.X , gvBandpos2.Y + 550,0 )
				Logic.GroupStand(troop4)
			end
			
		end
		if IsDestroyed(troop6) then
			if Counter.Tick2("BanditRespawn"..troop6,45) then
				troop6 = CreateGroup(7, Entities.CU_BlackKnight_LeaderSword3, 8, gvBandpos2.X , gvBandpos2.Y + 850,0 )
			end
			
		end
	else
		if not gvBanditBottomKilled and not IsExisting(troop2) and not IsExisting(troop4) and not IsExisting(troop6) then
			BanditBaseDestroyed(2)
		end
	end
end
gvBanditBaseReward = 5000
function BanditBaseDestroyed(_tID)
	local gvBanditReward = math.floor(math.min(gvBanditBaseReward + ((Logic.GetTime()/2)^(1+Logic.GetTime()/7000)),50000))
	Sound.PlayGUISound( Sounds.OnKlick_Select_pilgrim, 112 ) 
	if _tID == 1 then
		gvBanditTopKilled = true		
		Message(UserTool_GetPlayerName(1).." hat Schätze der Barbaren geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
		AddGold(1,gvBanditReward)
		AddWood(1,gvBanditReward)				   
	elseif _tID == 2 then
		gvBanditBottomKilled = true
		Message(UserTool_GetPlayerName(2).." hat Schätze der Barbaren geplündert. Inhalt: "..gvBanditReward.." Taler und Holz")
		AddGold(2,gvBanditReward)
		AddWood(2,gvBanditReward)				   
	end
end
																				
function InitEggs()
	-- this should be a nice number; below divided by 2 since there are 2 teams
	local totaleggs = 40
	local count_t1,count_t2 = 0,0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec1 = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,27000,46000,0,8))
	local sec2 = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,27000,8000,0,8))
	local tempid
	local tempsec
	while (count_t1+count_t2) < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		tempid = Logic.CreateEntity(Entities.XD_Flower1,posX,posY,0,0)
		tempsec = Logic.GetSector(tempid)
		if tempsec == sec1 then
			if count_t1 < (totaleggs/2) then				
				count_t1 = count_t1 + 1
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T1_"..count_t1)
			end
		elseif tempsec == sec2 then
			if count_t2 < (totaleggs/2) then
				count_t2 = count_t2 + 1			
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"EasterEgg_T2_"..count_t2)
			end		
		end		
		Logic.DestroyEntity(tempid)		
	end
	EasterEggposTable = {[1] = {},
						[2] = {}}
	for i = 1,2 do
		for k = 1,(Logic.GetNumberOfEntitiesOfType(Entities.XD_EasterEgg1))/2 do
			EasterEggposTable[i][k] = GetPosition("EasterEgg_T"..i.."_"..k)
		end
	end
	StartSimpleJob("ControlEggs")	
end

function ControlEggs()
	
	for j = 1, 2 do
		for i = 1,2 do
			for k,_ in pairs(EasterEggposTable[i]) do
				entities = {Logic.GetPlayerEntitiesInArea(j, 0, EasterEggposTable[i][k].X, EasterEggposTable[i][k].Y, 300, 1)};
				if entities[1] > 0 then
					if Logic.IsHero(entities[2]) == 1 then
						local randomEventAmount = 45+math.random(10)
						Logic.AddToPlayersGlobalResource(j,ResourceType.Gold,randomEventAmount)
						DestroyEntity(Logic.GetEntityAtPosition(EasterEggposTable[i][k].X, EasterEggposTable[i][k].Y))
						table.remove(EasterEggposTable[i],k)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein Osterei gefunden. Inhalt: "..randomEventAmount.." Taler")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 112 ) 
						end
					end
				end
			end
		end
	end
end
RabbitFleeCounter = {}
for i = 1,4 do 
	RabbitFleeCounter[i] = 0
end
function ControlRabbits()
	
	for i = 1,4 do
		-- 337 = "TL_ANIMAL_FLEE", 331 = "TL_RABBIT_IDLE"
		if IsValid("rabbit"..i) then
			if GetEntityCurrentTask(Logic.GetEntityIDByName("rabbit"..i)) == TaskLists.TL_ANIMAL_FLEE then
				RabbitFleeCounter[i] = RabbitFleeCounter[i] + 1
			else
				RabbitFleeCounter[i] = 0
			end
			if RabbitFleeCounter[i] >= 20 then
				local pos = GetPosition("rabbit"..i)
				local count = math.random(4)
				if count == 1 then
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X+math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X-math.random(50,100), pos.Y, 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y+math.random(50,100), 0, 7)
					Logic.CreateEntity(Entities.XD_Bomb1, pos.X, pos.Y-math.random(50,100), 0, 7)
				elseif count == 2 or count == 3 then
					Logic.CreateEffect(GGL_Effects.FXKalaPoison, pos.X, pos.Y)
					CEntity.DealDamageInArea(Logic.GetEntityIDByName("fakedamager"),pos.X,pos.Y,1000,300)
				elseif count == 4 then
					Logic.CreateEntity(Entities.XD_Silver1, pos.X, pos.Y, 0, 0)
				end
				RabbitFleeCounter[i] = 0
			end
		end
	end

end


function OnSpecialRabbitDied()

	local entityID = Event.GetEntityID()
	
    local entityType = Logic.GetEntityType(entityID)
	
	if entityType == Entities.XA_Rabbit_Evil then
	
		if Logic.GetEntityName(entityID) ~= nil then
		
			local pos = GetPosition(entityID)
	
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "", "RecreateRabbit", 1, nil, {Logic.GetEntityName(entityID),pos.X,pos.Y})
			
		end
		
	end
	
end

function RecreateRabbit(_name,_posX,_posY)
	
	local sweetspot = {X = 28400, Y = 27250}

	local fakeid = Logic.CreateEntity(Entities.XD_Flower1,sweetspot.X,sweetspot.Y,0,0)
	
	if Logic.GetSector(fakeid) ~= 0 then
		
		local id = Logic.CreateEntity(Entities.XA_Rabbit_Evil,sweetspot.X,sweetspot.Y,0,0)
			
		Logic.SetEntityName(id,_name)
			
		SetEntitySize(id,2.5)
		
		Logic.DestroyEntity(fakeid)
		
		return true
		
	else
	
		Logic.DestroyEntity(fakeid)
	
		local x, y = _posX,_posY

		local offset = 3000;

		local xmax, ymax = Logic.WorldGetSize();

		local dmin, xspawn, yspawn;

		for y_ = y - offset, y + offset, 100 do
		
			for x_ = x - offset, x + offset, 100 do
			
				if y_ > 0 and x_ > 0 and xmax < x_ and y_ < ymax then
					
					local d = (x_ - x)^2 + (y_ - y)^2;
					
					if IsExisting(fakeid) then
					
						Logic.DestroyEntity(fakeid)
					
					end
					
					fakeid = Logic.CreateEntity(Entities.XD_Flower1,x_,y_,0,0)
					
					if Logic.GetSector(fakeid) ~= 0 then
					
						if not dmin or dmin > d then
							dmin = d;
							
							xspawn = x_;
							yspawn = y_;
						end;
						
					end;
					
					Logic.DestroyEntity(fakeid)
				end;
			end;
		end;

		if xspawn then
		
			local id = Logic.CreateEntity(Entities.XA_Rabbit_Evil,xspawn,yspawn,0,0)
			
			Logic.SetEntityName(id,_name)
			
			SetEntitySize(id,2.5)
						
			return true
			
		else
		
			LuaDebugger.Log("Recreating Rabbit ".._name.." could not find valid position near ".._posX..", ".._posY)
			
			Logic.DestroyEntity(fakeid)
			
			return true
			
		end;
		
	end
		
end

function OnSilvermineEmpty()

	local entityID = Event.GetEntityID()
	
    local entityType = Logic.GetEntityType(entityID)
	
	if entityType == Entities.XD_SilverPit1 then
	
		StartCountdown(2*60,RabbitStatueInit,false)
		
		Logic.CreateEntity(Entities.XD_BuildBlockScriptEntity,28400,27250,0,7)																
	end
	
end

function RabbitStatueInit()

	Script.Load("maps/externalmap/mysterious_statue.lua")
	local sizeX,sizeY = Logic.WorldGetSize()
	Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{sizeX/2})
	StartSimpleJob("RabbitStatueMadness")								  
end

function ControlRabbitStatue(_CenterPos)

	
	if ({Logic.GetEntitiesInArea(Entities.XA_Rabbit_Evil, _CenterPos, _CenterPos, 1500, 4)})[1] == 4 then
		
		InitRabbitStatueEggs()
		return true
		
	end
	
end

function InitRabbitStatueEggs()

	Message("Es sind weitere Ostereier aufgetaucht!")
	local totaleggs = 12
	local count = 0
	local sizeX,sizeY = Logic.WorldGetSize()
	local posX,posY
	local sec = Logic.GetSector(Logic.CreateEntity(Entities.XD_ScriptEntity,sizeX/2,sizeX/2,0,8))
	local tempid
	local tempsec
	while count < totaleggs do
		posX = math.random(sizeX)
		posY = math.random(sizeX)
		if GetDistance({X=sizeX/2,Y=sizeY/2},{X=posX,Y=posY}) < 5000 then
			tempid = Logic.CreateEntity(Entities.XD_Flower1,posX,posY,0,0)
			tempsec = Logic.GetSector(tempid)
			if tempsec == sec then			
				count = count + 1
				Logic.SetEntityName(Logic.CreateEntity(Entities.XD_EasterEgg1, posX, posY, math.random(360), 0),"RabbitStatue_EasterEgg_"..count)
			end		
			Logic.DestroyEntity(tempid)		
		end
	end
	RabbitStatue_EasterEggposTable = {}
	for i = 1,totaleggs do
		RabbitStatue_EasterEggposTable[i] = GetPosition("RabbitStatue_EasterEgg_"..i)
	end
	StartSimpleJob("ControlRabbitStatueEggs")	
end

function ControlRabbitStatueEggs()

	for j = 1, 2 do
		for k,_ in pairs(RabbitStatue_EasterEggposTable) do
			entities = {Logic.GetPlayerEntitiesInArea(j, 0, RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y, 300, 1)};
			if entities[1] > 0 then
				if Logic.IsHero(entities[2]) == 1 then
					local randomEvent = math.random(3)
					if randomEvent == 3 then
						Logic.CreateEffect(GGL_Effects.FXMaryPoison,RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y)
						Logic.CreateEffect(GGL_Effects.FXMaryDemoralize,RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y)
						SetHealth(entities[2],0)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein faules Osterei gefunden... Wie das stinkt!")
							Sound.PlayGUISound( Sounds.OnKlick_Select_mary_de_mortfichet, 122 ) 
						end
					else
						local randomEventAmount = 10+math.random(10)
						Logic.AddToPlayersGlobalResource(j,ResourceType.SilverRaw,randomEventAmount)
						if j == GUI.GetPlayerID() then
							Message("Ihr habt ein besonders seltenes Osterei gefunden. Inhalt: "..randomEventAmount.." Silber")
							Sound.PlayGUISound( Sounds.OnKlick_Select_ari, 112 ) 
						end
					end
					DestroyEntity(Logic.GetEntityAtPosition(RabbitStatue_EasterEggposTable[k].X, RabbitStatue_EasterEggposTable[k].Y))
					table.remove(RabbitStatue_EasterEggposTable,k)					
				end
			end
		end
	end
	local sizeX,sizeY = Logic.WorldGetSize()
	if ({Logic.GetEntitiesInArea(Entities.XD_EasterEgg1, sizeX/2, sizeX/2, 5000, 1)})[1] == 0 then
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"","ControlRabbitStatue",1,{},{sizeX/2})
		return true
	end
end


 