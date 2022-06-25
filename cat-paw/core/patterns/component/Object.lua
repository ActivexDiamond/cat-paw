local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local uTable = require "cat-paw.core.utility.uTable"

------------------------------ Helpers ------------------------------

------------------------------ Constructor ------------------------------
local Object = middleclass("Object")
function Object:initialize(comps)
	comps = comps or {}
	
	self.components = {}
	
	for k, v in ipairs(comps) do
		assert(uTable.hasAllOf(comps, unpack(v.DEPENDENCIES)),
				"Depedencies for " .. k .. " not satisfied!")
		self:_addComponent(v)
	end
	
	for k, v in ipairs(self.components) do
		v:onReady()
	end
end

------------------------------ Core API ------------------------------
function Object:update(dt)
	for k, v in ipairs(self.components) do
		v:update(dt)
	end
end

function Object:fixedUpdate(dt)
	for k, v in ipairs(self.components) do
		v:fixedUpdate(dt)
	end
end

function Object:draw(g2d)
	for k, v in ipairs(self.components) do
		v:draw(g2d)
	end
end

------------------------------ API ------------------------------
function Object:attach(listener, event, callback)
	error "WIP"
end

function Object:queue(event)
	error "WIP"
end

function Object:has(dt)
	error "WIP"
end

function Object:hasAllOf(dt)
	error "WIP"
end

------------------------------ Internals ------------------------------
function Object:_addComponent(comp)
	table.insert(self.components, comp)
	comp:onAdd(self)
end

------------------------------ Getters / Setters ------------------------------

return Object