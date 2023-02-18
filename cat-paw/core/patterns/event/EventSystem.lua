local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local overload = require "cat-paw.core.patterns.overload"

local Event = require "cat-paw.core.patterns.event.Event"

------------------------------ Constructor ------------------------------
local EventSystem = middleclass("EventSystem")
function EventSystem:initialize()	
	self.events = {}
	self.eventQueue = {}
end

------------------------------ Core API ------------------------------
function EventSystem:poll()
	while #self.eventQueue > 0 do
		self:_fire(self.eventQueue[1])
		table.remove(self.eventQueue, 1)
	end
end

------------------------------ Internals ------------------------------
function EventSystem:_rawAttach(target, event, callback)
	assert(event:isSubclassOf(Event) or event == Event, "May only attach Event or a subclass of it.")
	assert(type(callback) == 'function', "Callback must be a function.")

	if not self.events[event] then --If first time attaching to Event e, create table for it.
		self.events[event] = setmetatable({}, {__mode = "kv"})
	end	
	self.events[event][target] = callback
end

function EventSystem:_fire(eventInstance)
	local event = eventInstance.class
	local t = {}
	for e, subscribers in pairs(self.events) do
		if event:isSubclassOf(e) or e == event then
			t[#t + 1] = {e, subscribers or {{}, {}}}
		end
	end
	table.sort(t, function(a, b)
--		Returns true when the first is less than the second.
		return a[1]:isSubclassOf(b[1])
	end)
	for _, v in ipairs(t) do
		for target, callback in pairs(v[2]) do
			callback(target, eventInstance)
		end
	end
end

------------------------------ API ------------------------------
EventSystem.attach = overload({
	EventSystem, 'table', Event,
	function (self, target, event)
		self:_rawAttach(target, event, target[event])
	end,
	
	EventSystem, 'table', 'table',
	function (self, target, events)
		for _, e in pairs(events) do
			self:_rawAttach(target, e, target[e])
		end
	end,
	
	EventSystem, 'table', Event, 'function',
	EventSystem._rawAttach,
	
	--Add 4th option, only pass the object. Iterate all its keys and for every;
	--	key.subclassof(Event) and type(val) == 'function' call _rawAttach on it.
	-- This would be very slow so it should cache the class of every object after the first
	-- call, so that subsuquent calls would just read from the cache.
	-- WARN: This does mean changes made to the object (or even class) after the first cache will
	-- not be noticed.
	--EventSystem, 'table',
	--function (self, target)
	--
	--end
})

function EventSystem:queue(event)
	assert(event.isInstanceOf and event:isInstanceOf(Event), "May only queue Event or a subclass of it.")
	table.insert(self.eventQueue, event)
end

return EventSystem
