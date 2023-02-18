local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvGameQuit = middleclass("EvGameQuit", Event)
function EvGameQuit:initialize()
	Event.initialize(self)
end

return EvGameQuit
