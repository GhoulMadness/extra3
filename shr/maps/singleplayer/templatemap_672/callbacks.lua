local OnMapStart

local print = function(...)
	if LuaDebugger and LuaDebugger.Log then
		if table.getn(arg) > 1 then
			LuaDebugger.Log(arg)
		else
			LuaDebugger.Log(unpack(arg))
		end
	end
end

function OnMapStart()
	Script.Load("data\\script\\maptools\\tools\\mapload.lua")
	print("Mod: OnMapStart!")
end

local Callbacks = {

	OnMapStart = OnMapStart

}

return Callbacks
