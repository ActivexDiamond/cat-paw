local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local EvMouse = require "cat-paw.core.patterns.event.mouse.EvMouse"

local EvMouseMove = middleclass("EvMouseMove", EvMouse)
function EvMouseMove:initilize(x, y, dx, dy, touch)
	EvMouse.initilize(self) 
	self.x, self.y, self.dx, self.dy, self.dx =
			x, y, dx, dy, touch
end

return EvMouseMove