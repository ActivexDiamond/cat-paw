local middleclass = require "cat-paw.core.patterns.oop.middleclass"

------------------------------ Constructor ------------------------------
local Camera = middleclass("Camera")
function Camera:initialize(window, opt)
	self.window = window
	self.world = opt.world

	--Just to make the default delcarations below look cleaner.
	opt = opt or {}
	opt.view = opt.view or {}
	opt.port = opt.port or {}
	opt.bbox = opt.bbox or {}
	opt.bounds = opt.bounds or {}
	
	--drawing target				--nil defaults to true ; false stays false.
	self.drawObjects = opt.drawObjects == nil and true or opt.drawObjects			--Whether to fetch objs from the world/view or not.
	self.drawGuis = opt.drawGuis == nil and true or opt.drawGuis			--Whether to fetch GUIs from the world/view or not.
	self.drawableObjects = opt.drawableObjects or {}								--A list of dedicated objs to draw.
	self.drawableGuis = opt.drawableGuis or {}								--A list of dedicated GUIs to draw.
	--view
	self.view = {}
	self.view.x = opt.view.x or 0
	self.view.y = opt.view.y or 0
	self.view.w = opt.view.w or self.view:getW()
	self.view.h = opt.view.h or self.view.getH()
	--port
	self.port = {}
	self.port.x = opt.port.x or 0
	self.port.y = opt.port.y or 0
	self.port.w = opt.port.w or self.view:getW()
	self.port.h = opt.port.h or self.view:getH()
	--follow behavior data
	self.target = opt.target
	--FIXME: What should `bbox` be named (in general - not just here)?
	self.bbox = {}
	self.bbox.top = opt.bbox.top or 50
	self.bbox.bottom = opt.bbox.bottom or 50
	self.bbox.left = opt.bbox.left or 50
	self.bbox.right = opt.bbox.right or 50
	--The boundaries that the camera is nota llowed to cross.
	--bounds.left is used to compares against the x-value of the left side of the port, etc...
	--nil = unbounded
	self.bounds = {}
	self.bounds.top = opt.bounds.top or -math.huge
	self.bounds.bottom = opt.bounds.bottom or math.huge
	self.bounds.left = opt.bounds.left or -math.huge
	self.bounds.right = opt.bounds.right or math.huge
end

------------------------------ Core API ------------------------------
function Camera:update(dt)
	local view = self.view
	local target = self.target
	local bounds = self.bounds
	local bbox = self.bbox
	
	if target then
		--Follow the target, but only if he's crossing outside the camera's bbox.	
		--    temp            if any            cx/cy                     targetHalf w/h      bbox-dims
		local bboxLeft		= bbox.left		and view.x + view.w / 2		- target.w / 2		- bbox.left
		local bboxRight		= bbox.right	and view.x + view.w / 2		+ target.w / 2		+ bbox.right
		local bboxTop		= bbox.top		and view.y + view.h / 2		- target.h / 2		- bbox.top
		local bboxBottom	= bbox.bottom	and view.y + view.h / 2		+ target.h / 2		+ bbox.bottom
		
		view.x = (bbox.left		and	target.x 			< bboxLeft		and	view.x + (target.x - bboxLeft))					or	view.x
		view.x = (bbox.right	and	target.x + target.w > bboxRight		and	view.x + (target.x + target.w - bboxRight))		or	view.x
		view.y = (bbox.top		and	target.y 			< bboxTop		and	view.y + (target.y - bboxTop))					or	view.y
		view.y = (bbox.bottom	and	target.y + target.h	> bboxBottom	and	view.y + (target.y + target.h - bboxBottom))	or	view.y
	end
	--Bind against the min/max's of the camera's movement.
	view.x = (bounds.left	and	view.x			< bounds.left	and	bounds.left)			or view.x
	view.x = (bounds.right	and	view.x + view.w	> bounds.right	and	bounds.right - view.w)	or view.x
	view.y = (bounds.top	and	view.y			< bounds.top	and	bounds.top)				or view.y
	view.y = (bounds.bottom	and	view.y + view.h	> bounds.bottom	and	bounds.bottom - view.h)	or view.y	
end

function Camera:draw(g2d)
	--[[
		Prepare canvases.
		TODO: Figure out canvas overlaying and perhaps switch this to use canvases.
	local worldCanvas = g2d.newCanvas(self.view.w, self.view.h)
	local guiCanvas = g2d.newCanvas(self.port.w, self.port.h)
	--]]
	
	--Compute zoom.
	local sx = self.port.w / self.view.w
	local sy = self.port.h / self.view.h
	local objects;									--Declare out here so it can be used for debugging culling.
	--Prepare the the obj drawing state.
	g2d.push('all')
		--g2d.setCanvas(worldCanvas)
		g2d.setScissor(self.port.x, self.port.y, self.port.w, self.port.h)
		g2d.scale(sx, sy)
		g2d.translate(-self.view.x, -self.view.y)
		
		--TODO: Optimize this.
		--Draw objs in view (translated).
		if self.drawObjects then
			--FIXME: What should `world.queryAabb` be named?
			objects = self.world:queryAabb(self.view.x, self.view.y, self.view.w, self.view.h)
			for _, obj in ipairs(objects) do
				if obj.draw then obj:draw(g2d) end
				--if DEBUGGING.BBOXES then self.world:drawBoundingBox(g2d, obj) end
			end
		end
		--Draw drawableObjects (translated).
		for _, obj in ipairs(self.drawableObjects) do
			if obj.draw then obj:draw(g2d) end
			--if DEBUGGING.BBOXES then self.world:drawBoundingBox(g2d, obj) end
		end
		--debug draw view edges.
		--if DEBUGGING.CAMERA_VIEW_EDGES then self:_debugDrawViewEdges(g2d) end
	g2d.pop()
	
	--FIXME: GUIs seem to lag a bit after being clicked on. Does the error originate from here or from Game's events?
	--Prepare the gui drawing state.
	g2d.push('all')
		g2d.setScissor(self.port.x, self.port.y, self.port.w, self.port.h)
		--g2d.setCanvas(guiCanvas)
		
		--Draw guis (raw).
		if self.drawGuis then
			local guis = self.world:getActiveGuis()
			for _, gui in ipairs(guis) do
				if gui.drawGui then gui:drawGui() end
			end
		end
		--Draw drawableGuis (raw).
		for _, gui in ipairs(self.drawableGuis) do
			if gui.drawGui then gui:drawGui() end
		end
		--Debug culling.
		--if DEBUGGING.CAMERA_VIEW_OBJS then g2d.print("objs in view (exc. dedicated): " .. (objs and #objs or 0), 5, self.port.h - 20) end
	g2d.pop()
	
	--g2d.draw(worldCanvas)
	--g2d.draw(guiCanvas)
end

------------------------------ Debug ------------------------------
function Camera:_debugDrawViewEdges(g2d)		
	local viewCx = self.view.x + self.view.w / 2
	local viewCy = self.view.y + self.view.h / 2
	local targetHw = self.target.w / 2
	local targetHh = self.target.h / 2
	local bboxLeft = self.bbox.left and (viewCx - targetHw - self.bbox.left) or self.view.x
	local bboxRight = self.bbox.right and (viewCx + targetHw + self.bbox.right) or (self.view.x + self.view.w)
	local bboxTop = self.bbox.top and (viewCy - targetHh - self.bbox.top) or self.view.y
	local bboxBottom = self.bbox.bottom and (viewCy + targetHh + self.bbox.bottom) or (self.view.y + self.view.h)
	
	g2d.setColor(0, 1, 0.75)
	g2d.setPointSize(4)
	--Center of view
	g2d.points(viewCx, viewCy)
	--Edges of bbox
	g2d.rectangle('line', bboxLeft, bboxTop, bboxRight - bboxLeft, bboxBottom - bboxTop)
	--Edges of view
	g2d.setLineWidth(4)
	g2d.rectangle('line', self.view.x, self.view.y, self.view.w, self.view.h)
end

------------------------------ Accessors ------------------------------
--`f` can be `nil` to clear the filter.
function Camera:setObjectFilter(f)
	--TODO: Implement.
	error "WIP"
end

--`f` can be `nil` to clear the filter.
--Same as abovee but applies to objects gotten from `self.world` instead of `self.drawableObjects`
function Camera:setWorldFilter(f)
	--TODO: Implement.
	error "WIP"
end

function Camera:addObject(obj)
	for _, o in ipairs(self.drawableObjects) do
		if obj.equals(o) then return false end
	end
	table.insert(self.drawableObjects, obj)
	return true
end
function Camera:removeObject(obj)
	for k, o in ipairs(self.drawableObjects) do
		if obj.equals(o) then return table.remove(self.drawableObjects, k) end
	end
	return false
end

function Camera:addGui(gui)
	for _, g in ipairs(self.drawableGuis) do
		if gui == g then return false end
	end
	table.insert(self.drawableObjects, gui)
	return true
end
function Camera:removeGui(gui)
	for k, g in ipairs(self.drawableGuis) do
		if gui == g then return table.remove(self.drawableGuis, k) end
	end
	return false
end

return Camera

--[[
todos
	[DONE] cutting up the window
	ordering/depth
	[DONE] following behavior
	[DONE] bounding behavior
	opt update method
	screenshake? (Not built-in directly but expose some methods that allow for such things.)

much later
	different movement speed
	smooth-movement options
	teleporting sort of stuff for when lagging behind
	other similar fancy features

children
	filteredCamera: Allows for viewing only specific objects.
	nightvisionCamera: Messes with lighting.
--]]