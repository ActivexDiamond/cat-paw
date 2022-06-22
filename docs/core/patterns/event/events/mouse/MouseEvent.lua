local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local MouseEvent = class("MouseEvent", Event)
function MouseEvent:init()
	Event.init(self)
end

MouseEvent.PRESS = 0
MouseEvent.RELEASE = 1

MouseEvent.LEFT = 1
MouseEvent.RIGHT = 2
MouseEvent.MIDDLE = 3

return MouseEvent