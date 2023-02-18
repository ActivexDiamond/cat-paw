local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvTextInput = middleclass("EvTextInput", Event)
function EvTextInput:initilize(char)
	Event.initilize(self)
	self.char = char
end

return EvTextInput