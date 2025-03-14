
# Conventions
## Naming & Code Style
## Name-Cases
Type | Case | Note
:-: | :-: | :-:
Class File | `PascalCase.lua`
Module File | `camelCase.lua` | For non-OOP modules.
Global State File | `SCREAMING_CASE.lua` | For globally-accessible **state-holding** instances of classes or tables, such as singletons, services (a default soundManager or eventSystem, etc...).
Folder | `kebab-case` | All folders, package or otherwise, should follow `kebab-case`.
Asset File | `snake_case.*` | Images, videos, sounds, etc...
Data File | `snake_case.lua` | Design-oriented data files. E.g. datapacks, files consumed by `Registry`, etc...
Class | `PascalCase`
Object | `camelCase`
Public Method | `camelCase`
Protected Method | `_underCamelCase`
Private Method | `camelCase` | Declared local in script.
Public Member | *Use Accessor* | All public member access should be wrapped behind `getters/setters`. The `getters/setters` use `camelCase` as well as the members.
Protected Member | `camelCase`
Private Member | `camelCase` | Declared local in script.
Local/Temp Var | `camelCase`
Function/Method Arguments | `camelCase`
Constant | `SCREAMING_CASE`

## Choosing Names
1. Words should be spelled out fully as much as possible, except;
	- Prefixes for class-types and module-types (see list below).
	- Short-lived variables; locals with a small scope, temp-variables, etc...
	- Where an abbreviation (the first letter of each word in a multi-word name, not just cutting out random letters) is available and commonly known (E.g. `dt`, `Fsm`, `Json`, `Xml`, etc...).
	- If the full word is a Lua keyword. E.g. `function` as `func`.
	- Practicality over purity - do what makes your code more readable, but try to be as stingy as possible with abbreviations. E.g.
```
if self.boundingBox.x < other.boundingBox.width and
		self.boundingBox. y < other.boundingBox.height then
	...
end
```
Versus
```
if self.bbox.x < other.bbox.w and self.bbox.y < other.bbox.h then
	...
end
```
2. Abbreviations should not be all-caps; capitalize based on the name-case rules above.
3. Variables and members should begin with a noun.
3. Methods and functions should begin with a verb and describe an action.
4. Setters should begin with `set`, getters with `get`, and getters-for-booleans with `is` or `can` (for whether they describe *state* or *ability* respectively).

## Prefixes
Prefix | Full Name | Example | Note
:-: | :-: | :-: | :-:
E | Enum | EColors
Ev | Event | EvKeyPressed
C | Component | CEventHandler | Prefix only used for type. Otherwise, the word is spelled fully!
U | Utility| uMath | Prefixes still respect casing for `class` vs `module`.

## Globally Accessible State
Note that this section deals not only deal with global variables but also any state-holding object which can be accessed from any script. For example, a `Foo.lua` singleton which holds state that can be accessed by any file `require`ing it's file. While this is not technically a global variable, it is functionally similar.

Having a file `DEFAULT_FOO.lua` return an instance of `Foo` instead of simply assinging it to a global variable (`FOO = Foo()`) somewhere is much preferable, as while this state is still globally-accessible, any file which uses it must state so at the top of it (by way of needing to `require` it).

In the case where `Foo` is a singleton, the `Foo.lua` file can be emitted and only `FOO.lua` is needed, where it will both declare the class and return a singleton instance of it. In those cases, it's best to make sure you first `require` `FOO.lua` somewhere in your game init code, as to ensure Foo runs its init code at the correct time.

1. Keep global state to a minimum.
2. Try to bundle global state into objects or tables as much as possible to reduce global namespace clutter. E.g. `DEBUG.DRAW_OUTLINES` and `DEBUG.SHOW_FPS` instead of `DRAW_OUTLINES` and `SHOW_FPS`.
3. Global variables should always be constant. This does however include pointers to objects and Lua tables, the contents of which may be mutable. So that a global object such as a `GAME` instance can be mutable but the instance which `GAME` refers to should never change.
4. Global variables should always be declared in a localized section of your code. 
	- This can either be something such as a single `globals.lua` file if you are using global-variables directly instead of the method described in the intro of this section (and/or for smaller projects).
	- Or a `globals/` directory for larger projects where not only is the aforementioned method more useful long-term, but some of those globals also need a lot of initialization code.

### Clean Global State Examples
A `GAME` constant global variable pointing to an instance of Game (Game is mutable), which holds methods and state needed by most of your game code. This would be declared in src/globals.lua. This could possibly be declared alongside a `DEBUG` global table that is used for dev builds.

For another example, consider you have multiple Classes (Window, EventSystem, SoundManager) that are needed by most sections of your game. You'd have the following setup:
```
src/
  somewhere/
    Window.lua		--Those provide access to the classes themselves,
    EventSystem.lua	-- not setting up any state whatsovever.
    --There's no SoundManager.lua because it's a singleton. No file may ever create a new instance of it anyways.
  ...  
  globals/
    DEFAULT_WINDOW.lua		--Those will init instances (sometimes multiple of each)
    USER_INPUT_EVENT_SYSTEM.lua	-- of those classes, set up any needed state,
    GAMEPLAY_EVENT_SYSTEM.lua	-- and provide a clean way to access them globally.
    DEFAULT_SOUND_MANAGER.lua	--This one declares the SoundManager class AND initializes it.
    ...
```
In the above example, any file which needs to listen to events from either (or both) global eventSystems, must `require` them at the top.

And if a file needs to create a new instance of `EventSystem`, it can require the `EventSystem.lua` class file. This is impossible to do with `SoundManager`, serving as both a way to communicate that it is a singleton and a safety measure against accidentally having two instances of it (which, presumably, would not work).

## Other
1. `require` should only be used at the top of files (unless absolutely necessary).
2. When requiring a module - do not rename it unless absolutely necessary (it causes a name collision, etc...)
E.g. `AbstractGame = require "cat-paw.engine.AbstractGame`
3. `require` should be called without parenthesis.
4. Tabs for indentation (not that important.)
5. No concrete number is defined for line-wrapping; use your best judgment. Extremely short blocks (plain getters, quick loops, etc...) can be written on one line.
64. When hard-wrapping a line;
	- The wrapped-part should be indented with 2-tabs (or what is equal) to differentiate it from normal scope change.
	- If a list of `and`/`or`s; wrapping should come *after* an `and`/`or`.twice of what you normally indent. 
E.g.
```lua
function foo(a, b, c, d, f)
    if a == "hello" and b == "world" and c == 100 and
            d == 1 and f == -1 then
        return 1
    end
end
```

## Prefixes
Prefix | Full Name
:-: | :-:
E | Enum
Ev | Event
C | Component
U | Util

## Engine Conventions
Those are only relevant if you are contributing to the source of CatPaw
1. Tabs for indentation.
2. `require` should be called without parenthesis.
3. If you are wrapping a line which contains a list of `and`/`or`s, wrapping should come *after* an `and`/`or`.
*See the example in `#Other/6`.*
4. If a function/method takes an argument that is a table used to hold options/configurations (or to act as *named arguments*) that argument should be named `opt`.

