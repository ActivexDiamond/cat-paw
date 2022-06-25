local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvMouse = middleclass("EvMouse", Event)
function EvMouse:initilize()
	Event.initilize(self)
end

EvMouse.static.PRESS = 0
EvMouse.static.RELEASE = 1

EvMouse.static.LEFT = 1
EvMouse.static.RIGHT = 2
EvMouse.static.MIDDLE = 3

return EvMouse