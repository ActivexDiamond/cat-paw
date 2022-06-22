local class = require "libs.cruxclass"
local MouseClickEvent = require "evsys.input.MouseClickEvent"

local MouseReleaseEvent = class("MouseReleaseEvent", MouseClickEvent)
function MouseReleaseEvent:init(x, y, button, touch)
	MouseClickEvent.init(self, x, y, button, touch, 
		MouseClickEvent.RELEASE)
end

return MouseReleaseEvent
