
local GameObject = require "cat-paw.core.patterns.component.GameObject"	
local Component = require "cat-paw.core.patterns.component.Component"

local EventSystem = require "cat-paw.core.patterns.event.EventSystem"
local EvMousePressed = require "cat-paw.core.patterns.event.MousePressed"

local Scheduler = require "cat-paw.core.timing.Scheduler"

local MapLoader = requie "cat-paw.integration.tiled.MapLoader"  --For Tiled, the map editor.

local EColors = "cat-paw.templates.graphics.EColors"
 
local SimpleGame = require "cat-paw.templates.game.SimpleGame"
local SingleScreenWorld = "cat-paw.templates.world.SingleScreenWorld"

local CInventory = require "cat-paw.jammy.inventory.CInventory"

local Player = require "mycutegame.objects.Player"
local EvPlayerDeath = require "mycutegame.events.EvPlayerDeath"
