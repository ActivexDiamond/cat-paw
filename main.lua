local version = require "cat-paw.version"

print("Setting stdout's vbuf mode to 'no'. This is needed for some consoles to work properly.")
io.stdout:setvbuf("no")
print("============================================================")
print("Running Lua version:      ", _VERSION)
if jit then
	print("Running Luajit version:   ", jit.version)
end
print("Running Love2d version: ", love.getVersion())
print("Running CatPaw version: ", version)
print("\nCurrently using the following 3rd-party libraries (and possibly more):")
print("middleclass\tBy Kikito\tSingle inheritance OOP in Lua\t[MIT License]")
print("bump\t\tBy Kikito\tSimple platformer physics.\t[MIT License]")
print("suit\t\tBy vrld\t\tImGUIs for Lua/Love2D\t\t[MIT License]")
print("Huge thanks to (Kikito and vrld) for their wonderful contributions to the community; and for releasing their work under such open licenses!")
print("============================================================")	
print("Example & Test Runner")
print("============================================================")

--TODO: Make a test runner here.
--Should that just be a stand-alone program that launches and manages love- (test-) instances?

function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		love.event.quit()
	end
end

--require "quick-tests.overload.all"
--require "quick-tests.instanceOfCheck.main"
--require "quick-tests.event.eventSystem"
--require "quick-tests.component.objectFunctionality"
--require "quick-tests.uTable.all"

