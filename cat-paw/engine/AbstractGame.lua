local version = require "cat-paw.version"
local middleclass = require "libs.middleclass"

local Fsm = require "cat-paw.core.patterns.state.Fsm"
local ApiHooks = require "cat-paw.hooks.LoveHooks"

--local suit = require "libs.suit"
local Scheduler = require "cat-paw.core.timing.Scheduler"
local EventSystem = require "cat-paw.core.patterns.event.EventSystem"

------------------------------ Constructor ------------------------------
local AbstractGame = middleclass("AbstractGame", Fsm)
function AbstractGame:initialize(title, targetWindowW, targetWindowH)
	Fsm.initialize(self)
	self.title = title or "Untitled Game"
	love.window.setTitle(title)
	if targetWindowW == -1 and targetWindowH == -1 then
		love.window.setFullscreen(true)
	elseif targetWindowW > 0 and targetWindowH > 0 then
		love.window.setMode(targetWindowW, targetWindowH)
	else
		error(string.format("Invalid window size. w/h must both be -1, for fullscreen,"
		.. "or positive. Current size: " .. targetWindowW .. ", " .. targetWindowH))
	end
	self.windowW, self.windowH = love.window.getMode()
	self:_printToolVersions()
				
	self.scheduler = Scheduler()
	self.eventSystem = EventSystem()
	ApiHooks.hookHandler(self)
end

------------------------------ Constants ------------------------------

------------------------------ Core ------------------------------
function AbstractGame:load(args)
end

function AbstractGame:update(dt)
	Fsm.update(self, dt)
	
	self.scheduler:update(dt)
	self.eventSystem:poll()
end

------------------------------ Other ------------------------------
--Wrapper so AbstractGame can be directly passed to ApiHooks. Shouldn't be used anywhere else.
--If you want to queue stuff, use game:getEventSystem():queue(event)
--TODO: Find a better way to make this class and ApiHooks work nicely.
function AbstractGame:queue(...)
	self.eventSystem:queue(...)
end

------------------------------ Internals ------------------------------
function AbstractGame:_printToolVersions()
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
	print("Game loaded: " .. self.title)
	print(string.format("Set window size to: (%d, %d)", self:getWindowSize()))
	print("============================================================")
end

------------------------------ Getters / Setters ------------------------------
function AbstractGame:getWindowW() return self.windowW end
function AbstractGame:getWindowH() return self.windowH end
function AbstractGame:getWindowSize() return self.windowW, self.windowH end

function AbstractGame:setWindowSize(w, h) 
	self.windowW, self.windowH = w, h
	love.window.setMode(w, h)
end

--TODO: Service locator
function AbstractGame:getEventSystem()
	return self.eventSystem
end

function AbstractGame:getScheduler()
	return self.scheduler
end

return AbstractGame

