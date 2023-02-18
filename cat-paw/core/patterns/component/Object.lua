local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local uTable = require "cat-paw.core.utilities.uTable"

------------------------------ Helpers ------------------------------

------------------------------ Constructor ------------------------------
local Object = middleclass("Object")
function Object:initialize(comps)
	comps = comps or {}
	
	self.components = {}
	
	for k, v in ipairs(comps) do
		if v.DEPENDENCIES then
			assert(uTable.hasAllOf(comps, v.DEPENDENCIES, self._componentEqualityChecker),
					"Depedencies for " .. tostring(v) .. " not satisfied!")
		end
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
function Object:has(comp)
	return uTable.has(self.components, comp, self._componentEqualityChecker)
end

function Object:hasAllOf(comps)
	return uTable.hasAllOf(self.components, comps, self._componentEqualityChecker)
end

------------------------------ Internals ------------------------------
--IMPORTANT: This does NOT take a self parameter! Only included inside `Object` to allow
--	its children to override its behavior.
function Object._componentEqualityChecker(a, b)
	return a:isInstanceOf(b)
end

function Object:_addComponent(comp)
	table.insert(self.components, comp)
	comp:onAdd(self)
end

------------------------------ Getters / Setters ------------------------------
function Object:getComponents() return self.components end

return Object