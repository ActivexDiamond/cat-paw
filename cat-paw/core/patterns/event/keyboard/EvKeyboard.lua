local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvKeyboard = middleclass("EvKeyboard", Event)
function EvKeyboard:initialize(key, keyCode, repeated, direction)
	Event.initialize(self)
	self.key, self.keyCode, self.repeated, self.direction = key, keyCode, repeated, direction
end

EvKeyboard.static.PRESS = 0
EvKeyboard.static.RELEASE = 1

return EvKeyboard