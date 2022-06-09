local class = require "libs.cruxclass"
local MouseEvent = require "evsys.input.MouseEvent"

local MouseWheelEvent = class("MouseMoveEvent", MouseEvent)
function MouseWheelEvent:init(x, y)
	MouseEvent.init(self)
	self.x, self.y = x, y 
end

return MouseWheelEvent
