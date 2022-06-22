local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Helper Methods ------------------------------
local getTime = love.timer.getTime
local ins = table.insert
local rem = table.remove
local modf = math.modf
local floor = math.floor

local function findIndex(t, obj)
	for k, v in ipairs(t) do
		if obj == v then return k end
	end
	return false
end

local function execute(t, dt, i, interval, timeout, func, args)
	args = type(args) == 'table' and args or {args}
	if dt then 
		t.totalDt[i] = t.totalDt[i] + dt
		local r = interval == -1 and 0 or interval
		local per = math.min(t.totalDt[i] / (timeout - r), 1)
		func(dt, per, unpack(args))
	else func(unpack(args)) end
end

local function remove(t, i)
	rem(t.wait,       i)
	rem(t.interval,   i)
	rem(t.timeout,    i)
	rem(t.stamp,      i)
	rem(t.totalDt,    i)
	rem(t.flag,       i)
	rem(t.last,       i)
	rem(t.runs,       i)
	rem(t.func,       i)
	rem(t.args,       i)
	rem(t.wrapUp,     i)
	rem(t.wrapUpArgs, i)
end

local function yield(t, i)
	if t.wrapUp[i] then execute(nil, nil, nil, nil, nil, t.wrapUp[i], t.wrapUpArgs[i]) end
	remove(t, i)
end

local function process(t, dt, i, wait, interval, timeout, stamp, flag, last, runs, func, args)
	local time = getTime()
	
	if time >= stamp + wait then								--If (at or post 'wait'); proceed 
		if interval == 0 then									--	If 'interval' == 0; single execution
			local dt = time - stamp								--
			execute(t, dt, i, interval, timeout, func, args)	--		Execute once; 'fdt' = time since initial scheduling
			return true											--		Yield
		elseif timeout == 0 or time <= stamp + timeout then		--	If (no timeout is set) or (within timeout); proceed
			if interval == -1 then								--		If interval == -1; execute every tick
				local fdt = flag == 0 and dt or time - stamp	--			'fdt' = (first run) ? tick-dt : time since initial scheduling 
				t.flag[i] = 0									--			Set 'first run' flag
				execute(t, fdt, i, interval, timeout, func, args)--			Execute
			else												--		If 'interval' set (not 0 and not -1); execute every 'interval' for 'timeout'
				local fdt, dif, reruns							--			[1]elaborated below
				if flag == -1 then								--
					fdt = time - stamp							--
					dif = time - stamp - wait					--
				else											--
					fdt = time - last							--
					dif = time - flag							--
				end												--
																--
				reruns = floor(dif / interval)					--
				dif = dif % interval							--
				if flag == -1 then reruns = reruns + 1 end		--
																--
--				print('dt', dt, 'fdt', fdt, 'dif', dif, 'flag', flag, 'reruns', reruns, 'interval', interval)
				for _i = 1, reruns do							--
					execute(t, _i == 1 and fdt or 0, i, interval, timeout, func, args)
					t.runs[i] = t.runs[i] + 1					--
--					if i == reruns then flag = time end			--
					if _i == reruns then						-- 
						dif = 0 								--
						t.last[i] = time						--
						t.flag[i] = time - dif					--						
					end											--
				end												--
--				print('dt', dt, 'fdt', fdt, 'dif', dif, 'flag', flag, 'reruns', reruns, 'interval', interval)
			end													--
		else													-- 
			if last ~= -1 then									--
				for _ = 1, (timeout / interval) - runs do		-- 
					execute(t, 0, i, interval, timeout, func, args)
				end												--
			end													--
			return true 										--
		end														--	If timed out; yield
	end
end

--[[
Execution:
once at or post 'wait':
	if interval == 0 -> execute then remove; //dt equals time - stamp  
	elseif interval == -1
		if timeout == 0 or within timeout, execute;	//dt if first time equals time - stamp
		else remove;								//else equals tick dt
		(repeat the above 'if' once every tick)
	else;
		execute every INTERVAL for TIMEOUT ; 
		if ticks took longer than INTERVAL -> execute multiple times per tick
		[1][elaborated below]

[1]
if timed out; yield
if flag == -1
	fdt = time - stamp
	dif = time - stamp - wait
else
	fdt = time - last
	dif = time - flag
	
reruns = floor(dif / interval)
dif = dif % interval

if flag == -1 then reruns++ end

for i = 1, reruns do
	execute(i == 1 and fdt or 0)		--if multiple executions in a row, the first is passed dt the rest are passed 0
	if i + 1 == reruns then flag = time end
end
last = flag
flag = flag - dif

[2] examples !!! outdated !!!
stamp = 30
wait = 5
interval = 1
flag = -1

------------ first run [time = 35.3] //since stamp = 5.3	;	since first run 0.3
fdt = 5.3
dif = 0.3
	reruns, dif = 0++, 0.3 [0.3 / 1 ; ++]
	
flag = 35.0

------------ second run [time = 36.8] //since stamp = 6.8	;	since first run 1.8
fdt = 1.8
dif 1.8
	reruns, dif = 1, 0.8 [1.8 / 1]
	
flag = 36.0

------------ third run [time = 38.3] //since stamp = 8.3	;	since first run 3.3
fdt = 1.8
dif = 2.3
	reruns, dif = 2, 0.3 [2.3 / 1]

flag = 38.0

------------ fourth run [time = 39.8] //since stamp = 9.8	;	since first run 4.8
fdt = 1.8
dif 1.8
	reruns, dif = 1, 0.8 [1.8 / 1]
	
flag = 39.0	
--]]
------------------------------ Constructor ------------------------------
local Scheduler = middleclass("Scheduler")
function Scheduler:initialize()
	self.tasks = {wait = {}, interval = {}, timeout = {}, stamp = {}, totalDt = {},
			flag = {}, last = {}, runs = {}, func = {}, args = {}, wrapUp = {}, wrapUpArgs = {}}
		
	self.graphicalTasks = {wait = {}, interval = {}, timeout = {}, stamp = {}, totalDt = {},
			flag = {}, last = {}, runs = {}, func = {}, args = {}, wrapUp = {}, wrapUpArgs = {}}		
end

------------------------------ Main Methods ------------------------------
--TODO: pass graphical tasks a 'g' param in place of 'dt'.
local function processAll(t, dt)
	local yielded = {}
	for i = 1, #t.func do	--All subtables of self.tasks should always be of equal length.
		local done = process(t, dt, i, t.wait[i], t.interval[i], t.timeout[i], t.stamp[i], 
				t.flag[i], t.last[i], t.runs[i], t.func[i], t.args[i])
		if done then ins(yielded, i) end
	end
		
	for i = 1, #yielded do	--Remove yielded entries in reverse order (so indices remain consistent during yielding)
		yield(t, yielded[#yielded + 1 - i])
	end
end

function Scheduler:update(dt)
	processAll(self.tasks, dt)
end

local gPrevTime = 0, getTime()
function Scheduler:draw(g)
	local dt = getTime() - gPrevTime
	processAll(self.graphicalTasks, dt)
	gPrevTime = getTime()
end

------------------------------ Schedule Method ------------------------------
function Scheduler:schedule(wait, interval, timeout, stamp, func, args, wrapUp, wrapUpArgs, graphical)
	local t = graphical and self.graphicalTasks or self.tasks
	ins(t.wait,          wait     or 0)
	ins(t.interval,      interval or 0)
	ins(t.timeout,       timeout  or 0)
	ins(t.stamp,         stamp    or getTime())
	ins(t.totalDt,       0)
	ins(t.flag,         -1)
	ins(t.last,         -1)
	ins(t.runs,          0)
	ins(t.func,          func)
	ins(t.args,          args     or {})
	ins(t.wrapUp,        wrapUp)
	ins(t.wrapUpArgs,    wrapUpArgs    or {})
end

------------------------------ Schedule Shortcuts ------------------------------
function Scheduler:callAfter(wait, func, args, wrapUp, wrapUpArgs)
	self:schedule(wait, nil, nil, nil, func, args, wrapUp, wrapUpArgs)
end

function Scheduler:callFor(timeout, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, -1, timeout, nil, func, args, wrapUp, wrapUpArgs)
end

function Scheduler:callEvery(interval, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, interval, nil, nil, func, args, wrapUp, wrapUpArgs)
end

function Scheduler:callEveryFor(interval, timeout, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, interval, timeout, nil, func, args, wrapUp, wrapUpArgs)
end

------------------------------ Schedule Graphical Shortcuts ------------------------------
function Scheduler:drawAfter(wait, func, args, wrapUp, wrapUpArgs)
	self:schedule(wait, nil, nil, nil, func, args, wrapUp, wrapUpArgs, true)
end

function Scheduler:drawFor(timeout, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, -1, timeout, nil, func, args, wrapUp, wrapUpArgs, true)
end

function Scheduler:drawEvery(interval, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, interval, nil, nil, func, args, wrapUp, wrapUpArgs, true)
end

function Scheduler:drawEveryFor(interval, timeout, func, args, wrapUp, wrapUpArgs)
	self:schedule(nil, interval, timeout, nil, func, args, wrapUp, wrapUpArgs, true)
end
------------------------------ Cancel Methods ------------------------------
function Scheduler:cancel(func)
	local i = type(func) == 'number' and func or findIndex(self.tasks.func, func)
	if i then remove(self.tasks, i) end
	--Graphical tasks:
	i = type(func) == 'number' and func or findIndex(self.graphicalTasks.func, func)
	if i then remove(self.graphicalTasks, i) end
end

function Scheduler:cancelAll()
	for i = 1, self.tasks.func do
		remove(self.tasks, i)
	end
	--Graphical tasks:
	for i = 1, self.graphicalTasks.func do
		remove(self.graphicalTasks, i)
	end
end
------------------------------ Yield Methods ------------------------------
function Scheduler:yield(func)
	local i = type(func) == 'number' and func or findIndex(self.tasks.func, func)
	if i then yield(self.tasks, i) end
	--Graphical tasks:
	i = type(func) == 'number' and func or findIndex(self.graphicalTasks.func, func)
	if i then yield(self.graphicalTasks, i) end
end

function Scheduler:yieldAll()
	for i = 1, self.tasks.func do
		yield(self.tasks, i)
	end
	--Graphical tasks:
	for i = 1, self.graphicalTasks.func do
		yield(self.graphicalTasks, i)
	end
end

return Scheduler