local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local Event = require "cat-paw.core.patterns.event.Event"

local EvTextEdit = middleclass("EvTextEdit", Event)
function EvTextEdit:initilize(text, start, length)
	Event.initilize(self)
	self.text, self.start, self.length = text, start, length
end

return EvTextEdit