local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Helpers ------------------------------

------------------------------ Constructor ------------------------------
local Component = middleclass("Component")
function Component:initialize()
end

------------------------------ Core API ------------------------------
function Component:update(dt)
end

function Component:fixedUpdate(dt)
end

function Component:draw(g2d)
end

------------------------------ Callbacks ------------------------------
function Component:onAdd(obj)
	self.obj = obj
end

function Component:onReady()
end

function Component:onDestroy()
end

------------------------------ Getters / Setters ------------------------------

return Component