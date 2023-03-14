local middleclass = require "libs.middleclass"


local EvKeyPress = require "cat-paw.core.patterns.event.keyboard.EvKeyPress"
local EvKeyRelease = require "cat-paw.core.patterns.event.keyboard.EvKeyRelease"
local EvTextInput = require "cat-paw.core.patterns.event.keyboard.EvTextInput"
local EvTextEdit = require "cat-paw.core.patterns.event.keyboard.EvTextEdit"


local EvMousePress = require "cat-paw.core.patterns.event.mouse.EvMousePress"
local EvMouseRelease = require "cat-paw.core.patterns.event.mouse.EvMouseRelease"
local EvMouseMove = require "cat-paw.core.patterns.event.mouse.EvMouseMove"
local EvMouseWheel = require "cat-paw.core.patterns.event.mouse.EvMouseWheel"

local EvWindowFocus = require "cat-paw.core.patterns.event.os.EvWindowFocus"
local EvWindowResize = require "cat-paw.core.patterns.event.os.EvWindowResize"
local EvGameQuit = require "cat-paw.core.patterns.event.os.EvGameQuit"

------------------------------ Constructor ------------------------------
local LoveHooks = middleclass("LoveHooks")
function LoveHooks:initialize()
	error("Attempting to initialize static class!" .. LoveHooks)
end

------------------------------ API ------------------------------
-- Can be any object (or even table) with `queue`, `load`, `tick`, and
-- `draw` methods. And optionally a `run` method.
-- `load` can be nil with no issues. `update` and `draw` can technically be null
-- but logic will not process nor will anything be drawn.
function LoveHooks.static.hookHandler(handler)
	LoveHooks._hookLoveCallbacks(handler)
end

------------------------------ Hooks ------------------------------
---------LovEvents->Evsys
function LoveHooks.static._hookLoveCallbacks(handler)
	local wrap = LoveHooks._loveCallbackWrapper
	--Game
	if handler.run then love.run = wrap(handler, handler.run) 
	else
		love.load = wrap(handler, handler.load)
		love.update = wrap(handler, handler.update)
		love.draw = wrap(handler, handler.draw)
	end
	--Evsys
	
	love.keypressed = wrap(handler, LoveHooks._onKeyPressed)
	love.keyreleased = wrap(handler, LoveHooks._onKeyReleased)
	love.textinput = wrap(handler, LoveHooks._nTextInput)
	love.texteditted = wrap(handler, LoveHooks._nTextEdit)
	
	love.mousepressed = wrap(handler, LoveHooks._onMousePressed)
	love.mousereleased = wrap(handler, LoveHooks._onMouseReleased)
	love.mousemoved = wrap(handler, LoveHooks._onMouseMoved)
	love.wheelmoved = wrap(handler, LoveHooks._onMouseWheel)
	
	love.focus = wrap(handler, LoveHooks._onWindowFocus)
	love.resize = wrap(handler, LoveHooks._onWindowResize)
	love.quit = wrap(handler, LoveHooks._onGameQuit)
end

------------------------------ Helpers ------------------------------
function LoveHooks.static._loveCallbackWrapper(handler, f)
	return f and function(...) -- wrapper or nil 
		return f(handler, ...)
	end
end

------------------------------ Evsys ------------------------------
---------Keyboard
function LoveHooks.static._onKeyPressed(handler, k, code, isRepeat)
	handler:queue(EvKeyPress(k, code, isRepeat))
end
function LoveHooks.static._onKeyReleased(handler, k, code, isRepeat)
	handler:queue(EvKeyRelease(k, code, isRepeat))
end
function LoveHooks.static._onTextInput(handler, char)
	handler:queue(EvTextInput(char))
end

function LoveHooks.static._onTextEdit(handler, text, start, length)
	handler:queue(EvTextEdit(text, start, length))
end

---------Mouse
function LoveHooks.static._onMousePressed(handler, x, y, button, touch)
	handler:queue(EvMousePress(x, y, button, touch))
end
function LoveHooks.static._onMouseReleased(handler, x, y, button, touch)
	handler:queue(EvMouseRelease(x, y, button, touch))
end
function LoveHooks.static._onMouseMoved(handler, x, y, dx, dy, touch)
	handler:queue(EvMouseMove(x, y, dx, dy, touch))
end
function LoveHooks.static._onMouseWheel(handler, x, y)
	handler:queue(EvMouseWheel(x, y))
end

---------OS
function LoveHooks.static._onWindowFocus(handler, focus)
	handler:queue(EvWindowFocus(focus))
end
function LoveHooks.static._onWindowResize(handler, w, h)
	handler:queue(EvWindowResize(w, h))
end
function LoveHooks.static._onGameQuit(handler)
	handler:queue(EvGameQuit())
end

return LoveHooks
