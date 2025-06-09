-- extra 3 campaign

SPMenu.AO3Campaign_Maps= {	"01_Journey",
							"02_Kafarna",
							"03_Keshet",
							"04_Dunnotar"}
SPMenu.CurrentAO3Campaign_Map = "01_Journey"


----------------------------------------------------------------------------------------------------
-- Start campaign map
--
function SPMenu.StartAO3CampaignMap()

	Framework.StartMap( SPMenu.CurrentAO3Campaign_Map, -1, "Extra3" )
	LoadScreen_Init( 0, SPMenu.CurrentAO3Campaign_Map, -1, "Extra3" )

end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign3Map(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO3Campaign_Maps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end

	-- Hilight Selected Map
	local HilightBG = "AO3_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S70_UpdateMapDescription(_MapName)
	SPMenu.S70_UpdateMapTitle(_MapName)

	SPMenu.CurrentAO3Campaign_Map = _MapName
end

----------------------------------------------------------------------------------------------------
--
--
function SPMenu.S70_UpdateCampaign3_Maps()

	XGUIEng.ShowAllSubWidgets( "SPM60_CampaignMaps", 0 )

	local AmountOfMaps = table.getn(SPMenu.AO3Campaign_Maps)
	local latestMap = 0

	for i=1,AmountOfMaps,1
	do
		if i <= 1 then

			local CampaignBG = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )

			XGUIEng.ShowWidget("AO3_"..SPMenu.AO3Campaign_Maps[i],1)

			local CampaignButton = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )

			local HideCampaignContainerNamer = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Extra3\\WonMap_" .. string.lower(SPMenu.AO3Campaign_Maps[i-1])
			if GDB.GetValue( GDBKeyName) == 1 then

				local CampaignBG = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )

				XGUIEng.ShowWidget("AO3_"..SPMenu.AO3Campaign_Maps[i],1)

				local CampaignButton = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )

				local HideCampaignContainerNamer = "AO3_" .. SPMenu.AO3Campaign_Maps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i
			end
		end

	end

	if latestMap <= 1 then
		latestMap = 1
	end
	local LatestCampainContainerNamer = "AO3_" .. SPMenu.AO3Campaign_Maps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )

	-- set selected map to latest Campaign Map
	SPMenu.CurrentAO3Campaign_Map = SPMenu.AO3Campaign_Maps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S70_UpdateMapDescription(SPMenu.AO3Campaign_Maps[latestMap])
	SPMenu.S70_UpdateMapTitle(SPMenu.AO3Campaign_Maps[latestMap])

	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO3_" .. SPMenu.AO3Campaign_Maps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end


----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.S70_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra3" )

	-- Set text
	XGUIEng.SetText( "SPM60_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function SPMenu.S70_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra3" )

	-- Set text
	XGUIEng.SetText( "SPM60_MapDetailsTitle", MapNameString )

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function SPMenu.S70_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO3MapCheats/WonMap_" .. string.lower(_MapName)
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )

	if Cheat == nil or Cheat == "" then
		return
	end

	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Extra3\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )
	SPMenu.S70_UpdateCampaign3_Maps()

	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )

end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback

function SPGame_S70_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )

	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO3Campaign_Maps)

	for i=1,AmountOfMaps,1
	do
		SPMenu.S70_CheckMapCheat( _Message, SPMenu.AO3Campaign_Maps[i] )
	end

end



