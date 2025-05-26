local month = tonumber(string.sub(Framework.GetSystemTimeDateString(), 6, 7))
local day = tonumber(string.sub(Framework.GetSystemTimeDateString(), 9, 10))
if (month == 12 and day >= 20) or (month == 1 and day <= 31) then
	CMod.PushArchive("..\\..\\..\\bba\\xmas.bba")
end
Script.Load("data\\script\\maptools\\tools\\sounddata.lua")
