-- Northern Invasion

SPMenu.AO2exCampaignMaps= {	"01_Nuamyr",
							"02_Drakon",
							"03_Kralmountains",
							"04_NorthernSea",
							"05_Dreadmountains"}
SPMenu.CurrentAO2exCampaignMap = "01_Nuamyr"


----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.StartAO2exCampaignMap()

	Framework.StartMap( SPMenu.CurrentAO2exCampaignMap, -1, "Extra3_2" )
	LoadScreen_Init( 0, SPMenu.CurrentAO2exCampaignMap, -1, "Extra3_2" )

end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign8Map(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO2exCampaignMaps)
	for i = 1, AmountOfMaps do
		local DisableHighlightContainerNamer = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_BG"
		XGUIEng.HighLightButton(DisableHighlightContainerNamer, 0)
	end

	-- Hilight Selected Map
	local HighlightBG = "AO2ex_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton(HighlightBG, 1)

	SPMenu.S80_UpdateMapDescription(_MapName)
	SPMenu.S80_UpdateMapTitle(_MapName)

	SPMenu.CurrentAO2exCampaignMap = _MapName
end

----------------------------------------------------------------------------------------------------
--
--
function SPMenu.S80_UpdateCampaign2exMaps()

	XGUIEng.ShowAllSubWidgets( "SPM80_CampaignMaps", 0 )

	local AmountOfMaps = table.getn(SPMenu.AO2exCampaignMaps)
	local latestMap = 0

	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
			local CampaignBG = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )
			XGUIEng.ShowWidget("AO2ex_"..SPMenu.AO2exCampaignMaps[i],1)
			local CampaignButton = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )

			local HideCampaignContainerNamer = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Extra3_2\\WonMap_" .. string.lower(SPMenu.AO2exCampaignMaps[i-1])
			if GDB.GetValue( GDBKeyName) == 1 then

				local CampaignBG = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )
				XGUIEng.ShowWidget("AO2ex_"..SPMenu.AO2exCampaignMaps[i],1)

				local CampaignButton = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )

				local HideCampaignContainerNamer = "AO2ex_" .. SPMenu.AO2exCampaignMaps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i
			end
		end

	end

	if latestMap <= 1 then
		latestMap = 1
	end
	local LatestCampainContainerNamer = "AO2ex_" .. SPMenu.AO2exCampaignMaps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )

	-- set selected map to latest Campaign Map
	SPMenu.CurrentAO2exCampaignMap = SPMenu.AO2exCampaignMaps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S80_UpdateMapDescription(SPMenu.AO2exCampaignMaps[latestMap])
	SPMenu.S80_UpdateMapTitle(SPMenu.AO2exCampaignMaps[latestMap])

	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO2ex_" .. SPMenu.AO2exCampaignMaps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end


----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.S80_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription(_MapName, -1, "Extra3_2")

	-- Set text
	XGUIEng.SetText( "SPM80_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function SPMenu.S80_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription(_MapName, -1, "Extra3_2")

	-- Set text
	XGUIEng.SetText("SPM80_MapDetailsTitle", MapNameString)

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function SPMenu.S80_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO3MapCheats/WonMap" .. _MapName
	local Cheat = XGUIEng.GetStringTableText(StringKeyName)

	if Cheat == nil or Cheat == "" then
		return
	end

	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Extra3_2\\WonMap_" .. string.lower(_MapName)
	GDB.SetValue( GDBKeyName, 1 )
	SPMenu.S80_UpdateCampaign2exMaps()

	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )

end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback

function SPGame_S80_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )

	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO2exCampaignMaps)

	for i=1,AmountOfMaps,1
	do
		SPMenu.S80_CheckMapCheat( _Message, SPMenu.AO2exCampaignMaps[i] )
	end

end



