local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EvMouseClick = require "cat-paw.core.patterns.event.mouse.EvMouseClick"

local EvMousePress = middleclass("EvMousePress", EvMouseClick)
function EvMousePress:initilize(x, y, button, touch)
	EvMouseClick.initilize(self, x, y, button, touch, 
			EvMouseClick.PRESS)
end

return EvMousePress