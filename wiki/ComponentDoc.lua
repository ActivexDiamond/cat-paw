--[[
------------------------------ Pseudo Code ------------------------------
class Object
	init(components)
	
	attach(listener, event, callback)	--Attach an event callback[1][2]
	queue(event)
	
	update(dt)
	fixedUpdate(dt)
	draw(g2d)
	
	has(...)			--Accepts a vararg of components, returns `true` if the object holds at least one of them.
	hasAllOf(...)		--Accepts a vararg of components, returns `true` if the object holds all of them.

class GameObject extends Object
	init(id, components)				--Adds registry injection to the object.
	init(id)							--Create the object based on whatever comps are defined in the registry by the object's id.

--------------- WIP ---------------
class Component
	onAdd(obj)
	onReady()
	onDestroy()
	
	update(dt)
	fixedUpdate(dt)
	draw(g2d)
	
	static.Event						--Inherited


--------------- WIP ---------------
class CBoundingBox:init()


end


------------------------------ Component Overview ------------------------------
Creation:
	onAdd(obj)						--Just added to component.
	onReady()							--All components have been added.
	onDestroy()						--Destructor
	
Updating:								--In order
	Fire event-callbacks
	
	--Other custom update-methods can be defined which also specificy their order of execution (relative to all other update-functions).
	fixedUpdate(dt)
	update(dt)
	
	Execute timer-callbacks
	draw(g2d)

Inter-Coms:
	internal-Evsys
	direct-coupling
	
Extern-Coms:
	Implicit:
		Registries: Data, assets, etc...
	Direct:
		Game, world, logging, etc...
	Indirect:
		Service locators
		
Access:
	Per-instance:
		static.Event / internal-Evsys
		component defined getters
	Global/static						--i.e. all instances of a component class.
		component itself firing the global-Evsys
	
Data:									--(?Separation of (light?) data vs assets?)
	Tweakable:
		datapack/default
	Tweakable + [id-based]:
		datapacks
	Non-tweakable constant:
		per component class
	Non-tweakable + purely-runtime computable:
		per component class				--Tweakable vars are not even "declared" in the component
 		


------------------------------ Component Inter-Coms ------------------------------
Internal-Evsys:
	GameObject has a static.Event field.
	Components can extend it.
	GameObject has queue(ev) and attach(ev, callback) methods.
	
Direct-Coupling:
	Components can optionally define a static.DEPENDENCIES table.
	It lists Component classes.
	After all components are added, i.e. after _onStart's are done.
		1- GameObject asserts that all couples of all components are present.
		2- GameObject reflectively injects references to the instances of all
			couples into the requesting component.
	Example syntax: 
		--In CDrawable def:
			CDrawalble.static.directCouple = {CBoundingBox}
		--Usage, available after _onStart returns (before _onAwake):
			self.cBoundingBox:getX();


------------------------------ Component Extern-Coms ------------------------------
player.C_HEALTH, player.C_HITTABLE, etc...



------------------------------ Component Access ------------------------------
	
	
------------------------------ Component Data Responsibility ------------------------------
Component:
	Declares what fields it requires.
	Defines which are static and which are non-static.
	Does not hard-code values.
	
Datapack:
	Supplies values to the fields the component declared.
	Is indexed per id then per component.  (E.g "zombie_mob"->CWalk->speed)
	
Default:
	Supplies values to the fields the datapack failed to supply.
	Useful for fields which have a very common default that is rarely altered.
	Lightens the verbosity of datapack definitions.


------------------------------ Component Data Types ------------------------------
	
Registry Assets vs Lighter Data:
	Usage: No difference is defined.
	Loading: The loading of data is split into multiple "steps" (not in order):
		Light-Data, recipes, sprites, sfx, music, other.
	
Id-Specific VS Mutable Data:
	Id-Specific:
		Location:	Stored in the Registry.
		Access:		Via getters, using "self.container.id".
		Reflection:	Getters are injected after `GameObject.init` finishes execution.
	Mutable:
		Location:	Copied directly into the instance.
		Access:		Directly, as any native local var. Is mutable per-instance.
		Reflection:	Injected into the instance before "_onStart".
			+ Getters/setters are injected at "compile" time.




------------------------------ Concept: Service Wrapping ------------------------------
For major services,
Components themselves represent a wrapper of a specific service.
Each component wraps a single (or part of a single) service.
E.g. 
	CSfx and CBgm wrap audio
	CBoundingBox wrap physics
	CUserInput wraps part of the global Evsys
	
Exceptions are services along the lines of Logging.




------------------------------ Usage ------------------------------
---Create
player = GameObject(CBoundingBox(x, y), 
		CHealth(min, max, current), 
		CAttack(), 
		CHittable(filter))
-- Wire all to player. Call registry on all.
	1- Wire all to player.
	2- Call registry on all.
	3- Call _onStart in all.
	4- Assert and inject all DEPENDENCIES dependencies
	5- Call _onAwake in all.

 
------------------------------ Other ------------------------------
draw depth defaults:
	-11 = GUI
	-10 = HUD
	-9 - +9 = Reserved
	
	10 = Particles
	11 = Entities
	12 = Blocks
	13 = Tiles/Floor
	14 = World Background




------------------------------ Notes ------------------------------
[1] GameObjects emits Events of their own internals.
Those can be listened to by the GameObject's components wanting to inter-com,
Or by external users wanting to listen to the GameObject.


[2] gameObject:attach() will subscribe to the specific game object.
	Evsys:attach() still exists, and will a




------------------------------ Sketch ------------------------------
Order Of Updating:
	1- Process Input (User input THEN AI)
	
	2- Ticking
		preTick:
			physics (move entities, fire collision events -> damage is done)
		tick:
			most things...
			GUI interaction
			machine logic
			add/remove objects
			etc...
		postTick:
			camera movement
	
	3- Update Clock (Scheduler/Timers), triggering timed execution.
	4- PollEvents
	
	5- Render
	
Explanation: 
	Most of the following is arbitrary. The order needs to be changed and/or
	have more solid reasoning put behind it.


	1- Inputs are processed the start of every frame.
		1.1- Player-made choices (clicking a button, etc...) were decided based on
			the currently visible screen; the state at the very end of last tick.
		1.2- AI is updated right after, for smoother response. 
	
	2- Ticks are separated into 3 steps.
		pre: physics.
		tick: everything else.
		post: camera
		2.1- This does give systems the freedom of choosing, however the choices
			will be spread arbitrarily across systems and make no sense.
		2.2.- Need a better solution.
		2.3- Debate: See if no other system ever needs this advantage, if not;
			hard-code physics (and possibly camera) into the loop.
	
	3- Timers are updated after everything has ticked, this ensures;
		3.1- If the player provided input to cancel any timer-relateed function,
			it takes effect the same tick. 
		3.2- If an object queued a timer, the first tick is counted on the same tick.
		
	4- All events gathered from this tick are then polled.
		4.1- Events decouple in-time so it makes sense to have the poll-step,
			Be either fully after or before everything else in at tick.
		4.2- It seems counter-intuitive to pile events from one tick to another.
			Since events are generated  in the other steps,
			Polling at the end remedies that. 


------------------------------ Terminology ------------------------------
Intern-Coms: Communication between components of a single GameObject.
Extern-Coms: Communication between components and the outside world.
Access: The outside world accessing components.










--]]
