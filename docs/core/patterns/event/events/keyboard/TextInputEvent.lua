local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local TextInputEvent = class("TextInputEvent", Event)
function TextInputEvent:init(char)
	Event.init(self)
	self.char = char
end

return TextInputEvent
