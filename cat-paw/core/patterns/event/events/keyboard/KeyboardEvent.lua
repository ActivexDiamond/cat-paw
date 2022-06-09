local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local KeyboardEvent = class("KeyboardEvent", Event)
function KeyboardEvent:init(k, code, rpt, dir)
	Event.init(self)
	self.k, self.code, self.rpt, self.dir = k, code, rpt, dir
end

KeyboardEvent.PRESS = 0
KeyboardEvent.RELEASE = 1

return KeyboardEvent
