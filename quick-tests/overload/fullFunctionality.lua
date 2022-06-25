local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local overload = require "cat-paw.core.utilities.overload"

local Point = middleclass("Point")
local Rect = middleclass("Rect")
local BetterPoint = middleclass("BetterPoint", Point)

local echo = overload({
	'string',
	function(...)
		print("Got a string!", ...)
	end,
	
	'number', 'string',
	function(...)
		print("Got a number and string!", ...)
	end,
	
	
	'string', 'optional';'table', 'string',
	function(...)
		print("Got a string, a table(or nil), and a string!", ...)
	end,
	
	Point,
	function(...)
		print("Got a point!", ...)
	end,
	
	'number', Point,
	function(...)
		print("Got a number and a point!", ...)
	end,
	
	'int',
	function(...)
		print("Got an int!", ...)
	end,
	
	'float',
	function(...)
		print("Got a float!", ...)
	end,
	
	'int', 'float',
	function(...)
		print("Got an int and a float!", ...)
	end,
	
	'char', 'positiveInt',
	function(...)
		print("Got a char and a positiveInt!", ...)
	end,
	
	'char', 'negativeInt',
	function(...)
		print("Got a char and a negativeInt!", ...)
	end,	
	
	'char', 'positiveFloat',
	function(...)
		print("Got a char and a positiveFloat!", ...)
	end,	
	
	'char', 'negativeFloat',
	function(...)
		print("Got a char and a negativeFloat!", ...)
	end,		
})

echo(1)
echo('hello')
echo(1, "hello")
echo("hello", {}, "there!")
echo("no one's", nil, "there!")
print(pcall(echo, "hello", 1, "there!"))			--Throws an error! No overload found.
print(pcall(echo, 1, "hello", 1))					--Throws an error! No overload found.

echo(Point())
echo(BetterPoint())
echo(1, Point())
echo(1, BetterPoint())
print(pcall(echo, Rect()))							--Throws an error! No overload found.

echo(42)
echo(0.5)
echo(1, 0.5)
print(pcall(echo, 0.5, 1))

echo('c', 1)
echo('c', 0)
echo('c', -1)
echo('c', 1.5)
echo('c', 0.5)
echo('c', 0)
echo('c', -1)
echo('c', 0)
echo('c', -1.5)

