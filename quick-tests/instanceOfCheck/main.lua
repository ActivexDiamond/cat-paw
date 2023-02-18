local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local inspect = require "quick-tests.misc.instanceOfCheck.inspect"

------------------------------ Constructor ------------------------------
local Foo = middleclass("Foo")
function Foo:initialize()
	
end

print(inspect(Foo))
print()

print(inspect(Foo()))
print()

print(inspect(Foo.class))
print()

print(inspect(Foo().class))
print()

print(Foo().super)
print(Foo.super)