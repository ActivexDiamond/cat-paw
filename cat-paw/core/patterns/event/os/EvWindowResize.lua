local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvWindowResize = middleclass("EvWindowResize", Event)
function EvWindowResize:initialize(w, h)
	Event.initialize(self)
	self.w, self.h = w, h
end

return EvWindowResize
