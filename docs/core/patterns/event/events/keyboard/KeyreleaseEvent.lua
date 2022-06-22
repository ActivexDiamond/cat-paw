local class = require "libs.cruxclass"
local KeyboardEvent = require "evsys.input.KeyboardEvent"

local KeyreleaseEvent = class("KeyreleaseEvent", KeyboardEvent)
function KeyreleaseEvent:init(k, code, rpt)
	KeyboardEvent.init(self, k, code, rpt, 
		KeyboardEvent.RELEASE)
end

return KeyreleaseEvent
