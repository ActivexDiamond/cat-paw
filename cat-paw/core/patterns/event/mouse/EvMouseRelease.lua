local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EvMouseClick = require "cat-paw.core.patterns.event.mouse.EvMouseClick"

local EvMouseRelease = middleclass("EvMouseRelease", EvMouseClick)
function EvMouseRelease:initialize(x, y, button, touch)
	EvMouseClick.initialize(self, x, y, button, touch, 
			EvMouseClick.RELEASE)
end

return EvMouseRelease