local class = require "libs.cruxclass"
local MouseEvent = require "evsys.input.MouseEvent"

local MouseClickEvent = class("MouseClickEvent", MouseEvent)
function MouseClickEvent:init(x, y, button, touch, dir)
	MouseEvent.init(self)
	self.x, self.y, self.button, self.touch, self.dir = 
			x, y, button, touch, dir
end

return MouseClickEvent