local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Constructor ------------------------------
local Fsm = middleclass("Fsm")
function Fsm:initialize()
	self.states = {}
	self.currentState = nil
end

------------------------------ Core API ------------------------------
function Fsm:update(dt)
	if not self.currentState then return end
	self.currentState:update(dt)
end

function Fsm:draw(g2d)
	if not self.currentState then return end
	self.currentState:draw(g2d)
end

------------------------------ API ------------------------------
function Fsm:goTo(id, ...)
	local state = self.states[id]
	if not state then return false end
	if not state then 
		error("Attempting to go to invalid state. Did you forget to add it, or is the ID wrong? id=" .. tostring(id)) 
	end
	
	--Would be nil for the first call of `goTo`.
	if self.currentState then self.currentState:leave(state) end
	local previous = self.currentState
	self.currentState = state
	self.currentState.enter(self.currentState, previous, ...)
	return true
end

function Fsm:add(id, state)
	if self.states[id] then return false end
	self.states[id] = state
	state:activate(self)
	return true
end

function Fsm:remove(id)
	local state = self.states[id]
	if not state then return false end
	
	if self.currentState == state then 
		self.currentState:leave()			--`from` will be nil.
		self.currentState = nil 
	end
	state:destroy()
	self.states[id] = nil
	return true
end


------------------------------ Utility ------------------------------
function Fsm:at(id)
	return self.states[id] == self.currentState
end

------------------------------ Getters / Setters ------------------------------
function Fsm:getStates()
	return self.states
end

function Fsm:getCurrentState()
	return self.currentState
end

function Fsm:getId(state)
	for k, v in pairs(self.states) do
		if v == state then return k end
	end
end

return Fsm
