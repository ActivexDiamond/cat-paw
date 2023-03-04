local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local Object = require "cat-paw.core.patterns.component.Object"
local Component = require "cat-paw.core.patterns.component.Component"

------------------------------ CTransform ------------------------------
local CTransform = middleclass("CTransform", Component)
function CTransform:initialize(x, y, w, h)
	Component.initialize(self)
	self.x, self.y = x, y
	self.w = w or 16
	self.h = h or 16
end
function CTransform:updatePosition(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

------------------------------ CSprite ------------------------------
local CSprite = middleclass("CSprite", Component)
CSprite.DEPENDENCIES = {CTransform}

------------------------------ CMove ------------------------------
local CMove = middleclass("CMove", Component)
CMove.DEPENDENCIES = {CTransform}

------------------------------ CMove ------------------------------
local CWeaponUser = middleclass("CWeaponUser", Component)
CWeaponUser.DEPENDENCIES = {CTransform, CSprite}

------------------------------ Execution ------------------------------
local player = Object({
	CTransform(42, 3, 32, 32),
	CSprite(),
	CMove(),
})

for k, v in pairs(player:getComponents()) do
	print(k, v)
end
print()

print(player:has(Component))
print(player:has(CTransform))
print(player:has(CWeaponUser))
print()

print(player:hasAllOf({CTransform, Component}))
print(player:hasAllOf({CTransform, CWeaponUser}))
--[[
Expected output:

1	instance of class CTransform
2	instance of class CSprite
3	instance of class CMove

true
true
false

true
false

--]]