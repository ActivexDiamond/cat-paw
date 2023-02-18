local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local EvMouse = require "cat-paw.core.patterns.event.mouse.EvMouse"

local EvMouseWheel = middleclass("EvMouseWheel", EvMouse)
function EvMouseWheel:initialize(wheelDx, wheelDy)
	EvMouse.initialize(self)
	self.wheelDx, self.wheelDy = wheelDx, wheelDy 
end

return EvMouseWheel

