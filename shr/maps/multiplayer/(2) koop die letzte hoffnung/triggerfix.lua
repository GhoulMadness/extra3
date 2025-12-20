-- #P4F: Warnung für normale + hiRes Trigger deaktiviert
-- Trigger-Fix    mcb      1.1                            Dank an Chromix
-- Funktionen anstelle von Funktionsnamen als Trigger
-- tables als Trigger-Argumente
-- Trigger-Argumente bei StarteSimpleJob, StartSimpleHiResJob, StartJob, StartHiResJob
-- error-handling (Trigger werden nicht gelöscht!)
-- Warnung, wenn Trigger / HiRes-Trigger zusammen länger als 0.03 sec brauchen (ab da ruckelts!)
-- Fügt Events.LOGIC_EVENT_LOW_PRIORITY hinzu, für Jobs die komplizierte Berechnungen durchführen, länger brauchen oder unwichtig sind
--   action wird als coroutine ausgeführt
--   condition bestimmt, ob action diesen tick weiter ausgeführt wird
--   coroutine.yield() Zeitprüfung, fortgesetzt wenn wieder Rechenzeit zur Verfügung steht
--   coroutine.yield(-1) diesen Job erst nächsten Tick weiter ausführen
--   ret = coroutine.yield(func, ...) führt Funktionen außerhalb der coroutine aus (OHNE Zeitprüfung)
--   beenden über return true! / EndJob
--   StartSimpleLowPriorityJob / StartLowPriorityJob
--
-- mcbTrigger.protectedCall(func, ...)	Ruft eine Funktion geschützt auf, und leitet Fehler an mcbTrigger.err
-- mcbTrigger.err(txt)					Standard - Fehlerausgabe (über DebugWindow)
-- mcbTrigger.getPerf()					Gibt die Performance-Werte zurück: HiResJob, Job
-- mcbTrigger.isDebuggerActive()		Prüft, ob der Debugger aktiv ist
--
-- Für Debugger optimiert:
--   Wenn der Debugger aktiv ist, werden Fehler nicht abgefangen, sondern an den Debugger weitergeleitet
--   DEBUG - Funktionen hinzugefügt (die meisten machen nur mit Debugger Sinn)
--
-- mcbTrigger.DEBUG_GetCurrentTID()					Gibt den aktuell aktiven Trigger zurück
-- mcbTrigger.DEBUG_GetInfo(tid)					Schreibt Debug-Infos über den Trigger in den Debugger und gibt das Trigger-table zurück
-- mcbTrigger.DEBUG_KillCurrentTrigger()			Löscht den aktuellen Trigger
-- mcbTrigger.DEBUG_SuspendCurrentTrigger()			Schaltet den aktuellen Trigger inaktiv
-- mcbTrigger.DEBUG_TriggerSetNoDebug(noDebug, tid)	Schaltet die Fehlerausgabe ab.
-- tid ist optional, wenn es nicht angegeben wird, wird mcbTrigger.DEBUG_GetCurrentTID() genommen.
mcbTrigger = {init = function()
		mcbTrigger_action = mcbTrigger.act
		mcbTrigger_contition = mcbTrigger.con
		mcbTrigger.Mission_OnSaveGameLoaded = Mission_OnSaveGameLoaded
		Mission_OnSaveGameLoaded = function()
			mcbTrigger.hackTrigger()
			mcbTrigger.Mission_OnSaveGameLoaded()
		end
		mcbTrigger.hackTrigger()
		
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, nil, function()
			mcbTrigger.perf = XGUIEng.GetSystemTime()
		end, 1, nil, nil)
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, nil, function()
			mcbTrigger.perf2 = XGUIEng.GetSystemTime()
		end, 1, nil, nil)
		
		Events.LOGIC_EVENT_LOW_PRIORITY = "mcb_lpjob"
		
		StartSimpleJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, nil, f, 1, nil, arg)
		end
		StartSimpleHiResJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, nil, f, 1, nil, arg)
		end
		StartJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, "Condition_"..f, "Action_"..f, 1, arg, arg)
		end
		StartHiResJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, "Condition_"..f, "Action_"..f, 1, arg, arg)
		end
		StartSimpleLowPriorityJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_LOW_PRIORITY, nil, f, 1, nil, arg)
		end
		StartLowPriorityJob = function(f, ...)
			return Trigger.RequestTrigger(Events.LOGIC_EVENT_LOW_PRIORITY, "Condition_"..f, "Action_"..f, 1, arg, arg)
		end
	end,
	trigger = {},
	vtrigger = {},
	vtid = 0,
	perf = 0,
	perfJob = 0,
	perf2 = 0,
	perfJob2 = 0,
	performance = 0,
	performance2 = 0,
	lptrigger = {},
	lptids = {},
	lptid = 0,
	lpnow = 1,
	errtext = {},
	errtid = nil,
}
function mcbTrigger.err(txt)
	-- TODO: removed bc I am dumb sometimes (p4f)
	-- Message("@color:255,0,0 Err:")
	-- Message(txt)
	-- table.insert(mcbTrigger.errtext, txt)
	-- if table.getn(mcbTrigger.errtext) > 15 then
		-- table.remove(mcbTrigger.errtext)
	-- end
	-- XGUIEng.ShowWidget("DebugWindow", 1)
end
GUIUpdate_UpdateDebugInfo = function()
	-- TODO: removed bc I am dumb sometimes (p4f)
	-- local txt = ""
	-- for k,v in ipairs(mcbTrigger.errtext) do
		-- txt = txt.." @color:255,0,0 "..v.." @cr "
	-- end
	-- XGUIEng.SetText("DebugWindow", txt)
end
mcbTrigger.perfJ = function()
	local p2 = XGUIEng.GetSystemTime()
	if p2-mcbTrigger.perf < 0.025 and mcbTrigger.lptids[1] then
		local forceRun = false
		while true do
			p2 = XGUIEng.GetSystemTime()
			if p2-mcbTrigger.perf > 0.025 and not forceRun then
				break
			end
			forceRun = false
			if not mcbTrigger.lptids[mcbTrigger.lpnow] then
				mcbTrigger.lpnow = 1
			end
			if not mcbTrigger.lptids[mcbTrigger.lpnow] then
				break
			end
			local t = mcbTrigger.lptrigger[mcbTrigger.lptids[mcbTrigger.lpnow]]
			local run = false
			if t.con then
				local f = t.con
				if type(f)=="string" then
					f = _G[f]
				end
				if type(f)~="function" then
					mcbTrigger.err("Trigger "..mcbTrigger.lptids[mcbTrigger.lpnow].." condition "..tostring(t.con).." invalid! action not called!")
					run = false
				else
					local r = {xpcall(function() return f(unpack(t.acon)) end, mcbTrigger.err)}
					local e = table.remove(r, 1)
					if not e then
						run = false
					else
						run = r[1]
					end
				end
			else
				run = true
			end
			if run then
				if not t.corot or coroutine.status(t.corot)=="dead" then
					local f = t.act
					if type(f)=="string" then
						f = _G[f]
					end
					if type(f)~="function" then
						mcbTrigger.err("Trigger "..mcbTrigger.lptids[mcbTrigger.lpnow].." action "..tostring(t.act).." invalid!")
						run = false
					else
						t.corot = coroutine.create(f)
						--Message("corot create")
					end
				end
				if t.corot then
					local argu = t.aact
					if t.aact2 then
						argu = t.aact2
						t.aact2 = nil
					end
					local r = {coroutine.resume(t.corot, unpack(argu))}
					if not table.remove(r, 1) then
						mcbTrigger.err(r[1])
						run = false
					else
						if type(r[1])=="function" then
							t.aact2 = {mcbTrigger.protectedCall(unpack(r))}
							forceRun = true
						elseif r[1] == -1 then
							run = false
						elseif r[1] == true then
							mcbTrigger.lptrigger[mcbTrigger.lptids[mcbTrigger.lpnow]] = nil
							table.remove(mcbTrigger.lptids, mcbTrigger.lpnow)
							run = true
						end
					end
				else
					run = false
				end
			end
			if not run then
				mcbTrigger.lpnow = mcbTrigger.lpnow + 1
			end
		end
	end
	p2 = XGUIEng.GetSystemTime()
	mcbTrigger.performance = p2-mcbTrigger.perf
--	if mcbTrigger.performance > 0.03 then
--		Message("@color:255,0,0 HiRes-Trigger runtime too long: "..mcbTrigger.performance)
--	end
end
mcbTrigger.perfJ2 = function()
	local p2 = XGUIEng.GetSystemTime()
	mcbTrigger.performance2 = p2-mcbTrigger.perf2
--	if mcbTrigger.performance2 > 0.03 then
--		Message("@color:255,0,0 Trigger runtime too long: "..mcbTrigger.performance2)
--	end
end
function mcbTrigger.hackTrigger()
	if not unpack{true} then
		unpack = function(t, i)
			i = i or 1
			if i <= table.getn(t) then
				return t[i], unpack(t, i+1)
			end
		end
	end
	mcbTrigger.RequestTrigger = Trigger.RequestTrigger
	Trigger.RequestTrigger = function(typ, con, act, active, acon, aact)
		local tid = mcbTrigger.add(typ, con, act, active, acon, aact)
		if typ == Events.LOGIC_EVENT_EVERY_TURN then
			EndJob(mcbTrigger.perfJob)
			mcbTrigger.perfJob = mcbTrigger.add(Events.LOGIC_EVENT_EVERY_TURN, nil, mcbTrigger.perfJ, 1, nil, nil)
		end
		if typ == Events.LOGIC_EVENT_EVERY_SECOND then
			EndJob(mcbTrigger.perfJob2)
			mcbTrigger.perfJob2 = mcbTrigger.add(Events.LOGIC_EVENT_EVERY_SECOND, nil, mcbTrigger.perfJ2, 1, nil, nil)
		end
		return tid
	end
	mcbTrigger.UnrequestTrigger = Trigger.UnrequestTrigger
	Trigger.UnrequestTrigger = function(tid)
		if not tid then
			return	-- added: check for valid id (nil?)
		end
		if tid < 0 then
			mcbTrigger.lptrigger[tid] = nil
			for i=table.getn(mcbTrigger.lptids),1,-1 do
				if mcbTrigger.lptids[i] == tid then
					table.remove(mcbTrigger.lptids, i)
					return
				end
			end
			return
		end
		
		tab = mcbTrigger.trigger[tid]
		if tab then
			mcbTrigger.trigger[tab.tid] = nil
			mcbTrigger.vtrigger[tab.vtid] = nil
		end
		return mcbTrigger.UnrequestTrigger(tid)
	end
end
function mcbTrigger.add(typ, con, act, active, acon, aact)
	if typ == Events.LOGIC_EVENT_LOW_PRIORITY then
		mcbTrigger.lptid = mcbTrigger.lptid - 1
		local tab = {
			act = act,
			con = con~="" and con or nil,
			acon = acon or {},
			aact = aact or {},
		}
		mcbTrigger.lptrigger[mcbTrigger.lptid] = tab
		table.insert(mcbTrigger.lptids, mcbTrigger.lptid)
		return mcbTrigger.lptid
	end
	
	mcbTrigger.vtid = mcbTrigger.vtid + 1
	local tab = {
		act = act,
		con = con~="" and con or nil,
		acon = acon or {},
		aact = aact or {},
		vtid = mcbTrigger.vtid,
	}
	assert(type(tab.acon)=="table")
	assert(type(tab.aact)=="table")
	assert(type(typ)=="number")
	mcbTrigger.vtrigger[mcbTrigger.vtid] = tab
	tab.tid = mcbTrigger.RequestTrigger(typ, "mcbTrigger_contition", "mcbTrigger_action", active, {tab.vtid}, {tab.vtid})
	mcbTrigger.trigger[tab.tid] = tab
	return tab.tid
end
function mcbTrigger.con(vtid)
	local tab = mcbTrigger.vtrigger[vtid]
	mcbTrigger.errtid = tab.tid
	if tab.con then
		local f = tab.con
		if type(f)=="string" then
			f = _G[f]
		end
		if type(f)~="function" then
			mcbTrigger.err("Trigger "..tab.tid.." condition "..tostring(tab.con).." invalid! action not called!")
			return false
		end
		local r = nil
		if mcbTrigger.isDebuggerActive() and not tab.noDebug then
			r = {true, f(unpack(tab.acon))}
		else
			r = {xpcall(function() return f(unpack(tab.acon)) end, mcbTrigger.err)}
		end
		local e = table.remove(r, 1)
		if not e then
			return false
		end
		return unpack(r)
	else
		return true
	end
end
function mcbTrigger.act(vtid)
	local tab = mcbTrigger.vtrigger[vtid]
	local f = tab.act
	if type(f)=="string" then
		f = _G[f]
	end
	if type(f)~="function" then
		mcbTrigger.err("Trigger "..tab.tid.." action "..tostring(tab.act).." invalid!")
		return false
	end
	local r = nil
	if mcbTrigger.isDebuggerActive() and not tab.noDebug then
		r = {true, f(unpack(tab.aact))}
	else
		r = {xpcall(function() return f(unpack(tab.aact)) end, mcbTrigger.err)}
	end
	local e = table.remove(r, 1)
	if not e then
		return false
	end
	if r[1] == true then
		mcbTrigger.vtrigger[tab.vtid] = nil
		mcbTrigger.trigger[tab.tid] = nil
	end
	mcbTrigger.errtid = nil
	return unpack(r)
end
function mcbTrigger.protectedCall(func, ...)
	local r = nil
	xpcall(function()
		r = {func(unpack(arg))}
	end, function(err)
		mcbTrigger.err("protectedCall: "..err)
	end)
	return unpack(arg)
end
function mcbTrigger.getPerf()
	return mcbTrigger.performance, mcbTrigger.performance2
end
function mcbTrigger.isDebuggerActive()
	return LuaDebugger.Log and true or false
end
function mcbTrigger.DEBUG_GetCurrentTID()
	return mcbTrigger.errtid
end
function mcbTrigger.DEBUG_TriggerSetNoDebug(noDebug, tid)
	tid = mcbTrigger.trigger[tid] and tid or mcbTrigger.errtid
	mcbTrigger.trigger[tid].noDebug = noDebug
end
function mcbTrigger.DEBUG_KillCurrentTrigger()
	EndJob(mcbTrigger.errtid)
end
function mcbTrigger.DEBUG_SuspendCurrentTrigger()
	Trigger.DisableTrigger(mcbTrigger.errtid)
end
function mcbTrigger.DEBUG_GetInfo(tid)
	tid = mcbTrigger.trigger[tid] and tid or mcbTrigger.errtid
	local t = mcbTrigger.trigger[tid]
	LuaDebugger.Log("Trigger-Info: "..t.tid.." / "..t.vtid..", type = "..type(t.con).." / "..type(t.act)..
		", func = "..tostring(t.con).." / "..tostring(t.act)
	)
	return t
end
mcbTrigger.init()