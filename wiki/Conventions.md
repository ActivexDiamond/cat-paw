
# Conventions
## Naming & Code Style
## Name-Cases
Type | Case | Note
:-: | :-: | :-:
Class File | `PascalCase.lua`
Module File | `camelCase.lua` | For non-OOP modules.
Folder | `kebab-case` | All folders, package or otherwise, should follow `kebab-case`.
Asset | `snake_case.*` | Images, videos, sounds, etc...
Data | `snake_case.lua` | Design-oriented data files. E.g. datapacks, files consumed by `Registry`, etc...
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

## Choosing Names
1. Words should be spelled out fully as much as possible.
	- The only exception is prefixes for class-type, except for;
	- Prefixes for class-types and module-types (see list below).
	- Short-lived variables; locals with a small scope, temp-variables, etc...
	- Where an abbreviation (the first letter of each word in a multi-word name, not just cutting out letters rand module-types (see list below).
2omly) is available and commonly known (E.g. `dt`, `Fsm`, `Json`, `Xml`, etc...).
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
34. Methods and functions should begin with a verb and describe an action.
45. Setters should begin with `set`, getters with `get`, and getters-for-booleans with `is` or `can` (for whether they describe *state* or *ability* respectively).

## Prefixes
Prefix | Full Name | Example | Note
:-: | :-: | :-: | :-:
E | Enum | EColors
Ev | Event | EvKeyPressed
C | Component | CEventHandler | Prefix only used for type. Otherwise, the word is spelled fully!
U | Utility| uMath | Prefixes still respect casing for `class` vs `module`.

## Other
1. `require` should only be used at the top of files.
2. When requiring a module - do not rename it unless absolutely necessary (it causes a name collision, etc...)
E.g. `AbstractGame = require "cat-paw.abstract.AbstractGame`
3. `require` should be called without paranthesis.
4. Tabs for indentation (not that important.)
5. No concrete number is defined for line-wrapping; use your best judgmentExtremely short blocks (`if`, functions, loops, etc...) can be written on one line.
64. When hard-wrapping a line;
	- The wrapped-part should be indented with 2-tabs (or what is equal) to differentiate it from normal scope change.
	- If a list of `and`/`or`s, wrapping should come *after* an `and`/`or`.twice of what you normally indent. 
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
U | UtilUnimportant
1. Tabs or spaces - take your pick (unless contributing).
2. No concrete number is defined for line-wrapping; use your best judgment.

## Engine Conventions
Those are only relevant if you are contributing to the source of CatPaw
1. Tabs for indentation.
2. `require` should be called without parenthesis.
3. If you are wrapping a line which contains a list of `and`/`or`s, wrapping should come *after* an `and`/`or`.
*See the example in `#Other/6`.*
4. If a function/method takes an argument that is a table used to hold options/configurations (or to act as *named arguments*) that argument should be named `opt`.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTkwNjcyMTM1OV19
-->