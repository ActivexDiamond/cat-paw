# Conventions
## Naming
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
	- The only exception is prefixes for class-types and module-types (see list below).
2. Variables and members should begin with a noun.
3. Methods and functions should begin with a verb and describe an action.
4. Setters should begin with `set`, getters with `get`, and getters-for-booleans with `is`.

## Other
1. `require` should only be used at the top of files.
2. When requiring a module - do not rename it unless absolutely necessary (it causes a name collision, etc...)
E.g. `AbstractGame = require "cat-paw.abstract.AbstractGame`
3. `require` should be called without paranthesis.
4. Tabs for indentation (not that important.)
5. No concrete number is defined for line-wrapping; use your best judgment.
6. When hard-wrapping a line;
	- The wrapped-part should be indented with 2-tabs (or what is equal) to differentiate it from normal scope change.
	- If a list of `and`/`or`s, wrapping should come *after* an `and`/`or`.
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
