local class = require "libs.cruxclass"
local Event = require "evsys.Event"

local GameQuitEvent = class("GameQuitEvent", Event)
function GameQuitEvent:init(w, h)
	Event.init(self)
end

return GameQuitEvent
