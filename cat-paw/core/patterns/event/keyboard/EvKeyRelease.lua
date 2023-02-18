local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EvKeyboard = require "cat-paw.core.patterns.event.keyboard.EvKeyboard"

local EvKeyRelease = middleclass("EvKeyRelease", EvKeyboard)
function EvKeyRelease:initialize(key, keycode, repeated)
	EvKeyboard.initialize(self, key, keycode, repeated, 
		EvKeyboard.RELEASE)
end

return EvKeyRelease