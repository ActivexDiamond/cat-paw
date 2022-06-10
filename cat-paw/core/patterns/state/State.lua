local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Constructor ------------------------------
local State = middleclass("State")
function State:initialize()
end

------------------------------ Core API ------------------------------
function State:update(dt)
end

function State:draw(g2d)
end

function State:enter(from, ...)
end

function State:leave(to)
end

function State:activate(fsm)
	self.fsm = fsm
end

function State:destroy()
end

------------------------------ Getters / Setters ------------------------------
function State:getFsm()
	return self.fsm
end

return State
