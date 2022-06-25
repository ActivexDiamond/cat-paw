local middleclass = require "cat-paw.core.patterns.oop.middleclass"


--[[
local function xlock(self)
	local inv = {}
	for k, v in pairs(self) do
		inv[k] = v
		self[k] = nil
	end
	
	local mt = getmetatable(self)
	local oopindex = mt.__index
	local function index(_, k)
		local o = inv[k] 
		if o and k ~= "class" then return o end
		return oopindex(self, k)
	end
	
	function self:iter()
		return function(_, k)
			local nk, v = next(inv, k)
			if nk == "class" then nk, v = next(inv, nk) end
			return nk, v
		end
	end
	
	mt.__index = index
	mt.__newindex = function() error "All Event fields are read-only." end,
	setmetatable(self, mt)
end
--]]

local function lock(self)
	function self.iterator()
		return function(_, k)
			local _k, _v = next(self, k)
			if _k == "class" or _k == "iterator" then 
				_k, _v = next(self, _k) 
			end
			return _k, _v
		end
	end
		
	return setmetatable({}, {
		__index = self,
		__newindex = function() error "All Event fields are read-only." end,
		__tostring = self.__tostring,
	})
end

local Event = middleclass("Event")
function Event:initialized()
end

local new = Event.new
function Event.static:new(...)
	local inst = new(self, ...)
	return lock(inst)
end

return Event

--[[
local Event = require "evsys.Event"

print(Event)
local e = Event(42)

print(e)
print(e.k)
e:instanceMethod()
print(e.class)
print(e.super)

print(e.iter)
--print(e:iter())
print ' --------- '
for k, v in pairs(e) do print(k, v) end c = next;
print ' --------- '
for k, v in e:iter() do print(k, v) end

e.k = 3
print('k', e.k)
e.y = 3
--]]