local class = require "libs.cruxclass"
local MouseEvent = require "evsys.input.MouseEvent"

local MouseMoveEvent = class("MouseMoveEvent", MouseEvent)
function MouseMoveEvent:init(x, y, dx, dy, touch)
	MouseEvent.init(self) 
	self.x, self.y, self.dx, self.dy, self.dx =
			x, y, dx, dy, touch
end

return MouseMoveEvent
