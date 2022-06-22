local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Constructor ------------------------------
local Window = middleclass("Window")
function Window:initialize(dat)
	dat = dat or {}
	self.x = dat.x or 0
	self.y = dat.y or 0
	--FIXME: Shouldn't access `love` directly.
	self.w = dat.w or love.graphics.getWidth()
	self.h = dat.h or love.graphics.getHeight()
	
	self.cameras = {}

	--TODO: Window init sequence + configs.
	--TODO: Project init sequence (generally speaking; start doing those).	
end

------------------------------ Core API ------------------------------
function Window:update(dt)
	for cam, state in pairs(self.cameras) do
		if state then cam:tick(dt) end
	end
end

function Window:draw(g2d)
	for cam, state in pairs(self.cameras) do
		if state then cam:draw(g2d) end
	end
end

------------------------------ Camera API ------------------------------ 
--- Convert Coords
function Window:toWorld(screenX, screenY)
	--Note: In the case of overlapping cameras, 
	--the coords are converted using the top-most camera (draw-depth wise)
	local cams = self:getCamerasAtScreenCoords(screenX, screenY)
	if not cams then
		return screenX, screenY, false
	end
	local cam = cams[#cams]
	return cam.view.x + screenX, cam.view.y + screenY, true
end

function Window:toScreen(worldX, worldY)
	--Note: In the case of overlapping cameras, 
	--the coords are converted using the top-most camera (draw-depth wise)
	error "WIP"
end

--- Modify
function Window:setCameraState(cam, newState)
	if self.cameras[cam] == nil then error "Camera must be added first." end
	--If called with no second param, toggles.
	if newState == nil then newState = not self.cameras[cam] end
	
	if self.cameras[cam] == newState then return nil end
	self.cameras[cam] = newState
	return newState
	--Returns nil if no change happened, otherwise, returns the state
	-- that the cam has been set to.

	--TODO: Once a proper Evsys has been added, make this fire camera
	-- state change events.
	-- To the camera itself, all cameras, objects inside the view
	-- (local cam state change) and all objects (global cam state change)
end

--- Add / Remove
function Window:addCamera(cam, state)
	if state == nil then state = true end	--If not passed, default to true.
	
	if self.cameras[cam] == nil then	--Required equals nil as state can be falsey. 
		self.cameras[cam] = state
		return cam
	end			
	return false	
end

function Window:removeCamera(cam)
	if self.cameras[cam] == nil then
		return false
	end
	self.cameras[cam] = nil
	return cam
end

--- Queries
local function queryCamerasAt(self, x, y, w, h, side)
	local rtVal = {}
	for cam, state in pairs(self.cameras) do
		if state and utils.rectIntersects(x, y, w, h,
				cam[side].x, cam[side].y, cam[side].w, cam[side].h) then
			table.insert(rtVal, cam)
		end
	end
	return #rtVal > 0 and rtVal or nil
end

function Window:queryCamerasAtWorldCoords(worldX, worldY, w, h)
	w = w or 1
	h = h or 1
	return queryCamerasAt(self, worldX, worldY, w, h, "view")
end

function Window:queryCamerasAtScreenCoords(screenX, screenY, w, h)
	w = w or 1
	h = h or 1
	return queryCamerasAt(self, screenX, screenY, w, h, "port")
end

--- Getters
function Window:getActiveCameras()
	local t = {}
	for cam, state in pairs(self.cameras) do
		if state then table.insert(t, cam) end
	end
	return #t > 0 and t or nil
end

function Window:isCameraActive(cam)
	return self.cameras[cam]
end

return Window