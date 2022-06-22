local class = require "libs.cruxclass"
local MouseClickEvent = require "evsys.input.MouseClickEvent"

local MousePressEvent = class("MousePressEvent", MouseClickEvent)
function MousePressEvent:init(x, y, button, touch)
	MouseClickEvent.init(self, x, y, button, touch, 
		MouseClickEvent.PRESS)
end

return MousePressEvent
