local middleclass = require "cat-paw.core.patterns.oop.middleclass"

local function inspect(target)
	io.write("Checking table of: " .. tostring(target) .. "\n")
	for k, v in pairs(target.events or {}) do
		io.write(k .. "=" .. v .. "\t")
	end
	print()
end

local IEventHandler = {
	included = function(class)
	
	end,
	
	postInit = function(self)
	
	end,
	
	attachCallback = function(class, group, callback)
		if not class.group then class.group = {} end
		assert(type(class.group) == 'table', group .. " (group) is already in use for something else!")
		
	end
}

local EvPlayerDeath, EvPlayerSpawn, EvPlayerRespawn, EvGroundTouch, EvSizeChange

------------------------------ Foo ------------------------------
local Foo = middleclass("Foo")
function Foo:initialize()
	print("initialized Foo.")
	
	Game:getEventSystem():attach(self, EvPlayerDeath)
	
	--EventSystem:attach(object, a, b)
	--Variants:
	-- a=An event.							Attaches object[a] (a function) to event a. 
	-- a=A table of events.					Same as above, but for each v in table a.
	-- a=An Event b=function.				Attaches the function b to the event a.
	
	Game:getEventSystem():attach(self, {EvPlayerDeath, EvPlayerSpawn, EvPlayerRespawn})
	self.object:getEventSystem():attach(self, {EvGroundTouch, EvSizeChange})
end

function Foo:onPlayerDeath(e)
	print(e.name)
end

--Events attached to the global (game-level) EventSystem.
Foo[EvPlayerDeath] = function(self, e)
	print(e.name, "has died.")
end

Foo[EvPlayerSpawn] = function(self, e)
	print(e.name, "has spawned.")
end

Foo[EvPlayerRespawn] = function(self, e)
	print(e.name, "has respawned.")
end

--Events attach to the local (object-specific) EventSystem.
Foo[EvGroundTouch] = function(self, e)
	self.onGround = true
end

Foo[EvSizeChange] = function(self, e)
	self.scale = e.newSize / e.oldSize
end

------------------------------ Component ------------------------------
local CWalker = middleclass("CWalker", Component)

CWalker:attachObjectEvent(EvPlayerDeath, function()

end)

------------------------------ Component ------------------------------
local Component = middleclass("Component")
function Component:initialize()
	print("initialized Component.")
end

Component.static.events = {}

------------------------------ CBase ------------------------------
local CBase = middleclass("CBase", Component)
function CBase:initialize()
	print("initialized CBase.")
end

CBase.static.events.one = 1

------------------------------ CPhysics ------------------------------
local CPhysics = middleclass("CPhysics", CBase)
function CPhysics:initialize()
	print("initialized CPhysics.")
end

CPhysics.static.events.two = 2
------------------------------ CSprite ------------------------------
local CSprite = middleclass("CSprite", CBase)
function CSprite:initialize()
	print("initialized CSprite.")
end

CSprite.static.events.three = 3

inspect(Component)
inspect(Component())

inspect(CBase)
inspect(CBase())

inspect(CPhysics)
inspect(CPhysics())

inspect(CSprite)
inspect(CSprite())
