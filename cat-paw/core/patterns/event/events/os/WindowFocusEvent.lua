local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local WindowFocusEvent = class("WindowFocusEvent", Event)
function WindowFocusEvent:init(focus)
	Event.init(self)
	self.focus = focus
end

return WindowFocusEvent
