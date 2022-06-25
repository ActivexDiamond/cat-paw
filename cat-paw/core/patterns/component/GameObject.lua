local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local Object = require "cat-paw.core.patterns.component.Object"

local EventSystem = require "cat-paw.core.patterns.event.EventSystem"
------------------------------ Helpers ------------------------------

------------------------------ Constructor ------------------------------
local GameObject = middleclass("GameObject", Object)
--If `comps` is nil, get it from registry!
function GameObject:initialize(id, comps)
	error "WIP"
	self.eventSystem = EventSystem()
end

------------------------------ Core API ------------------------------

------------------------------ API ------------------------------

------------------------------ Getters / Setters ------------------------------
function GameObject:getEventSystem() return self.eventSystem end

return GameObject