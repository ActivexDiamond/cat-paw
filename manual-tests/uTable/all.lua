local uTable = require "cat-paw.core.utilities.uTable"

------------------------------ *copy ------------------------------

--TODO: uTable.copy

------------------------------ has* ------------------------------
local t = {1, 2, 3, 4}

--has
print("has check")
print(uTable.has(t, 1))
print(uTable.has(t, 3))
print(uTable.has(t, 0))
print()

--hasAllOf
print("hasAllOf check")
print(uTable.hasAllOf(t, {1, 2}))
print(uTable.hasAllOf(t, {1, 2, 3, 4}))

print(uTable.hasAllOf(t, {1, 2, 3, 4, 5}))
print(uTable.hasAllOf(t, {5}))

print(uTable.hasAllOf(t, {}))

--[[
Expected output:
has check
true
true
false

hasAllOf check
true
true
false
false
true

--]]