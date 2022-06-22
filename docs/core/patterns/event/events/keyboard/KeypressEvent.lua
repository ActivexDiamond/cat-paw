local class = require "libs.cruxclass"
local KeyboardEvent = require "evsys.input.KeyboardEvent"

local KeypressEvent = class("KeypressEvent", KeyboardEvent)
function KeypressEvent:init(k, code, rpt)
	KeyboardEvent.init(self, k, code, rpt, 
		KeyboardEvent.PRESS)
end

return KeypressEvent
