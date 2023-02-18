local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local Event = require "evsys.Event"

--local Game = require "core.Game"
--local Registry = require "istats.Registry"

local Eventsystem = middleclass("EventSystem")
function Eventsystem:initialize()	
	self.events = {}
	self.queue = {}
end

function Eventsystem:lockOn(class)
	self.lock = class
end

function Eventsystem:attach(event, callback)	
	assert(event:isSubclassOf(Event) or event == Event, "May only attach Event or a subclass of it.")
	assert(type(callback) == 'function', "Callback must be a function.")

	if not self.events[event] then self.events[event] = {} end	--If first time attaching to Event e, create table for it.
	if not self.events[event][self.lock] then 				--If first time attaching this class to said event, craete a table for it. 
		self.events[event][self.lock] = {callback = {}, instances = {}}
	end 
	table.insert(self.events[event][self.lock].callback, callback) 
end

function Eventsystem:subscribe(instance)
	for _, v in pairs(self.events) do
		if v[instance.class] then
			table.insert(v[instance.class].instances, instance)
		end		
	end
end

function Eventsystem:queue(event)
	assert(event.isInstanceOf and event:isInstanceOf(Event), "May only queue Event or a subclass of it.")
	table.insert(self.queue, event)
end


local function fire(self, event)
	for _, class in pairs(self.events[event.class] or {}) do
		for _, inst in pairs(class.instances) do
			for _, callback in pairs(class.callback) do 
				callback(inst, event) 
			end
		end
	end
end

function Eventsystem:poll()
	while #self.queue > 0 do
		fire(self, self.queue[1])
		table.remove(self.queue, 1)
	end
end

return Eventsystem()