local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local overload = require "cat-paw.core.patterns.overload"

local Event = require "cat-paw.core.patterns.event.Event"

------------------------------ Constructor ------------------------------
local EventSystem = middleclass("EventSystem")
function EventSystem:initialize()	
	self.rootSubscribers = setmetatable({}, {__mode = "kv"})
	self.events = {}
	self.eventQueue = {}
end

------------------------------ Constants ------------------------------
EventSystem.ATTACH_TO_ALL = 0

------------------------------ Core API ------------------------------
function EventSystem:poll()
	while #self.eventQueue > 0 do
		self:_fire(self.eventQueue[1])
		table.remove(self.eventQueue, 1)
	end
end

------------------------------ Internals ------------------------------
function EventSystem:_fetchAllCallbacks(target, code)
	assert(code == EventSystem.ATTACH_TO_ALL, "`attach` got called with invalid code. Should be equal to EventSystem.ATTACH_TO_ALL")
	--If subscriber is already attached to one or more specific events, will crash!
	table.insert(self.rootSubscribers, target) 
end

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

	for _, target in pairs(self.rootSubscribers) do
		local hierarchyPosition = event
		while hierarchyPosition ~= Event.super do
			if type(target[hierarchyPosition]) == 'function' then
				target[hierarchyPosition](target, eventInstance)
			end
			--Go up one step in the hierarchy.
			hierarchyPosition = hierarchyPosition.super
		end
	end

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
function EventSystem:detach(target)
	for i = #self.rootSubscribers, 1, -1 do
		if self.rootSubscribers[i] == target then
			table.remove(self.rootSubscribers, i)
		end
	end
	
	for k, target in pairs(self.rootSubscribers) do
	
	end
	
	for e, subscriber in pairs(self.events) do
		if subscriber == target then
			self.events[e][target] = nil
		end
	end
end

EventSystem.attach = overload({
	EventSystem, 'table', Event,
	function(self, target, event)
		self:_rawAttach(target, event, target[event])
	end,
	
	EventSystem, 'table', 'table',
	function(self, target, events)
		for _, e in pairs(events) do
			self:_rawAttach(target, e, target[e])
		end
	end,

	EventSystem, 'table', 'number',
	function(self, target, getAllCode)
		self:_fetchAllCallbacks(target, getAllCode)
	end,
		
	EventSystem, 'table', Event, 'function',
	EventSystem._rawAttach,
})

function EventSystem:queue(event)
	assert(event.isInstanceOf and event:isInstanceOf(Event), "May only queue Event or a subclass of it.")
	table.insert(self.eventQueue, event)
end

return EventSystem
