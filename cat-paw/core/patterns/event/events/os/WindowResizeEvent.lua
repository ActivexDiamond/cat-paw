local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local WindowResizeEvent = class("WindowResizeEvent", Event)
function WindowResizeEvent:init(w, h)
	Event.init(self)
	self.w, self.h = w, h
end

return WindowResizeEvent
