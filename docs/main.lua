--TODO: Fix how Love2D handles this.
print("Set stdout's vbuf to 'no'")
io.stdout:setvbuf("no")

print("Running Lua version: ", _VERSION)
print("Running Love2d version: ", love.getVersion())
print("Running CatPaw version: ", "DEV_EXP_BRANCH", "\n")
print("Currently using the following 3rd-party libraries:")
print("middleclass\tBy Kikito\tSingle inheritance OOP in Lua\t[MIT License]")
print("bump\t\tBy Kikito\tSimple platformer physics.\t[MIT License]")
print("suit\t\tBy vrld\t\tImGUIs for Lua/Love2D\t\t[MIT License]")
print("Huge thanks to (Kikito and vrld) for their wonderful contributions to the community; and for releasing their work under such open licenses!")

--TODO: Make a test runner here.
--Should that just be a stand-alone program that launches and manages love- (test-) instances?

function love.keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		love.event.quit()
	end
end

