local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local EventSystem = require "cat-paw.core.patterns.event.EventSystem"
local Event = require "cat-paw.core.patterns.event.Event"
local EvMouse = require "cat-paw.core.patterns.event.mouse.EvMouse"
local EvMouseClick = require "cat-paw.core.patterns.event.mouse.EvMouseClick"
local EvMousePress = require "cat-paw.core.patterns.event.mouse.EvMousePress"

--local inspect = require "quick-tests.event.inspect"

------------------------------ EventSystem ------------------------------
local aSys = EventSystem()
local bSys = EventSystem()

------------------------------ Constructor ------------------------------
local Foo = middleclass("Foo")
function Foo:initialize()
	--aSys:attach(self, {EvMouse, EvMouseClick, EvMousePress})
	aSys:attach(self)
	bSys:attach(self, {EvMouse})
end

------------------------------ A Events ------------------------------
Foo[EvMouse] = function(self, e)
	print("Got mouse", e)
end

Foo[EvMouseClick] = function(self, e)
	print("Got mouse click", e, e.button, e.direction)
end

Foo[EvMousePress] = function(self, e)
	print("Got mouse press", e, e.button, e.direction)
end

--[[
-- Case 1
evSys:attach(self, EvMouse)

-- Case 2
evSys:attach(self, {EvMouse, EvKeyboard)

-- Case 3
evSys:attach(obj, EvMouse, obj.onMouseDoStuff)
evSys:attach(obj, EvMouse, function()
	--do stuff
end)
--]]
	
------------------------------ Test ------------------------------

--Should do nothing.
aSys:queue(EvMouse())
aSys:queue(EvMouseClick(0, 0, EvMouse.LEFT, false, EvMouse.PRESS))
aSys:queue(EvMousePress(0, 0, EvMouse.LEFT, false))
aSys:poll()

local foo = Foo()

aSys:queue(EvMousePress(0, 0, EvMouse.LEFT, false))
aSys:queue(EvMouse())
aSys:queue(EvMouseClick(0, 0, EvMouse.LEFT, false, EvMouse.PRESS))
aSys:queue(EvMousePress(0, 0, EvMouse.LEFT, false))
aSys:poll()

print()
bSys:poll()
aSys:queue(EvMouse())
bSys:queue(EvMouse())
aSys:poll()
bSys:poll()

--[[
Expected output:

Got mouse press	instance of class EvMousePress	1	nil
Got mouse click	instance of class EvMousePress	1	nil
Got mouse	instance of class EvMousePress
Got mouse	instance of class EvMouse
Got mouse click	instance of class EvMouseClick	1	0
Got mouse	instance of class EvMouseClick
Got mouse press	instance of class EvMousePress	1	nil
Got mouse click	instance of class EvMousePress	1	nil
Got mouse	instance of class EvMousePress

Got mouse	instance of class EvMouse
Got mouse	instance of class EvMouse

--]]
