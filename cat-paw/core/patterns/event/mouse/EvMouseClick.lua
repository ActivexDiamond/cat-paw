local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EvMouse = require "cat-paw.core.patterns.event.mouse.EvMouse"

local EvMouseClick = middleclass("EvMouseClick", EvMouse)
function EvMouseClick:initialize(x, y, button, touch, direction)
	EvMouse.initialize(self)
	self.x, self.y, self.button, self.touch, self.direction = 
			x, y, button, touch, direction
end

return EvMouseClick