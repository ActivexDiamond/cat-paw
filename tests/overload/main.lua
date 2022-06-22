local middleclass = require "cat-paw.core.patterns.oop.middleclass"
local overload = require "cat-paw.core.utilities.overload"

local Point = middleclass("Point")
local Rect = middleclass("Rect")
local BetterPoint = middleclass("BetterPoint", Point)

local echo = overload({
	'number',
	function(...)
		print("Got a number!", ...)
	end,

	'string',
	function(...)
		print("Got a string!", ...)
	end,
	
	'number', 'string',
	function(...)
		print("Got a number and string!", ...)
	end,
	
	'string', 'number',
	function(...)
		print("Got a string and number!", ...)
	end,
	
	'string', 'optional';'table', 'string',
	function(...)
		print("Got a string, a table(or nil), and a string!", ...)
	end,
	
	Point,
	function(...)
		print("Got point!", ...)
	end,
	
	'number', Point,
	function(...)
		print("Got number and a point!", ...)
	end,
})

echo(1)
echo('hello')
echo(1, "hello")
echo("hello", 1)
echo("hello", {}, "there!")
echo("no one's", nil, "there!")

echo(Point())
echo(BetterPoint())
echo(1, Point())
echo(1, BetterPoint())

echo(Rect())						--Throws an error! No overload found.
echo("hello", 1, "there!")			--Throws an error! No overload found.
echo(1, "hello", 1)					--Throws an error! No overload found.




