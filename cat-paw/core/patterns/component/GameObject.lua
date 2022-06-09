shallow_copy = function(tbl)
  local retval = {}
  for k, v in pairs(tbl) do
    retval[k] = v
  end
  return retval
end

local function new(class, ...)
	local inst = shallow_copy(class)
	class.init(inst, ...)
	return inst
end

---@class Rect
local Rect = {}

---@return Rect
Rect.new = new

Rect.w = 0
Rect.h = 0

function Rect:init(w, h)
  self.w = w
  self.h = h
end

function Rect:getArea()
  return self.w * self.h
end


r1 = Rect:new(10, 20)
print(r1.w)