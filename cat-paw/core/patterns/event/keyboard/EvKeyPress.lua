local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EvKeyboard = require "cat-paw.core.patterns.event.keyboard.EvKeyboard"

local EvKeyPress = middleclass("EvKeyPress", EvKeyboard)
function EvKeyPress:initialize(key, keyCode, repeated)
	EvKeyboard.initialize(self, key, keyCode , repeated, 
			EvKeyboard.PRESS)
end

return EvKeyPress