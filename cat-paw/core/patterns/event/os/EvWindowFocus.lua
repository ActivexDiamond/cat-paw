local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvWindowFocus = middleclass("EvWindowFocus", Event)
function EvWindowFocus:initialize(focus)
	Event.initialize(self)
	self.focus = focus
end

return EvWindowFocus
