
local overload = {}

--See usage inside `printTypes` for explanation.
local MAX_ARGS_TO_PRINT = 15

--[[
Note: While this module does provide some limited paramter-validation,
	those functions are much slower than just overloading.
And even with just overloading; an overloaded function is slower to call than a normal one.
--]]

------------------------------ Helpers ------------------------------
--Those are written here instead of just using the `uTable` ones to allow `uTable`
--	to include `overload` without causing a circular dependency.

local function isArray(t)
	for k, v in pairs(t) do
		if type(k) ~= 'number' then 
			return false
		end
	end
	return true
end

local function isHashMap(t)
	--Use ipairs instead of just checking t[1] so that if t override it's __len operator
	--	this function will still account for it.
	for k, v in ipairs(t) do
		return false
	end
	return true
end

local function nextBatch(t, pos)
	pos = pos or 1
	
	local rt = {}
	for i = pos, #t do
		local v = t[i]
		rt[#rt + 1] = v
		if type(v) == 'function' then
			return rt, i + 1
		end
	end
end

--IMPORTANT: Cannot differntiate between a class (e.g. Event) and its isntance (e.g. Event())
local function checkTypes(args, params)
	local i = 1
	local iOff = 0
	while i + iOff < #params do
		local param = params[i + iOff]
		local arg = args[i]
		
		--If optional, increment our offset to account for that, and update `param`.
		if param == 'optional' then
			iOff = iOff + 1
			param = params[i + iOff]
			if arg == nil then
				--It happens to be nil, and is optional, so we're good!
				--Else; check to make sure its the valid type.
				goto continue
			end
		end
		--print(param, arg, arg.class, arg.isInstanceOf, arg.isSubclassOf)

		--Built-in or defined by overload.
		if type(param) == 'string' and overload.types[param](arg) then
			--print("Overload found match for built-in or library-defined argument (string identifier).")
		--Instance of class (checks inheritance)
		elseif type(arg) == 'table' and arg.isInstanceOf and
					arg:isInstanceOf(param) then
			--print("Overload found match for instance argument (identifier could be instance or class).")
		--Class (checks inheritance)
 		elseif type(arg) == 'table' and arg.isSubclassOf and
				(arg:isSubclassOf(param) or arg == param) then
			--print("Overload found match for class argument (identifier could be instance or class).")
		else
			--print("Overload found no match for argument.")
			return false
		end
		
		::continue::
		i = i + 1
	end
	--Check for overflowing args.
	for k, v in pairs(args) do
		if k >= i and v ~= nil then
			return false
		end
	end
	return true
end

--The performance of this also does not matter much,
--	as it is only called to throw an error.
local function printTypes(args)
	local t = {}
	--This function fails with nil-holes. The rest of the module works fine
	--	as it can check off-of the `params` list, so this dirty hack is used.
	--This imposes an arbitary length-limit, however as this is only used for printing errors
	--	in the case of invalid-overload calls, that is not much of an issue.
	for i = 1, MAX_ARGS_TO_PRINT do
		local v = args[i]
		if v == nil then
			t[i] = "nil"
		--elseif type(v) == 'table' and v.class or (getmetatable(v) or {}).__tostring then
		elseif type(v) == 'table' and v.class then
			t[i] = v.class.name 
		else
			t[i] = type(v)
		end
	end

	-- Clean trailing nils.
	for i = #t, 0, -1 do
		if t[i] ~= "nil" then break end
		t[i] = nil 
	end

	return string.format("{%s}", table.concat(t, ", "))
end

------------------------------ Supported Types ------------------------------
overload.types = {
	--Default Lua types
	number = function(val) return type(val) == 'number' end,
	boolean = function(val) return type(val) == 'boolean' end,
	string = function(val) return type(val) == 'string' end,

	table = function(val) return type(val) == 'table' end,
	["function"] = function(val) return type(val) == 'function' end,
	
	userdata = function(val) return type(val) == 'userdata' end,
	thread = function(val) return type(val) == 'thread' end,
	
	--Numbers
	int = function(val) return type(val) == 'number' and math.floor(val) == val end,
	float = function(val) return type(val) == 'number' and math.floor(val) ~= val end,
	positiveNumber = function(val) return type(val) == 'number' and val >= 0 end,
	negativeNumber = function(val) return type(val) == 'number' and val < 0 end,
	positiveInt = function(val) return type(val) == 'number' and math.floor(val) == val and val >= 0 end,
	negativeInt = function(val) return type(val) == 'number' and math.floor(val) == val and val < 0 end,
	positiveFloat = function(val) return type(val) == 'number' and math.floor(val) ~= val and val >= 0 end,
	negativeFloat = function(val) return type(val) == 'number' and math.floor(val) ~= val and val < 0 end,
	
	--Strings
	char = function(val) return type(val) == 'string' and #val == 1 end,
	
	--Tables
	array = function(val) return type(val) == 'table' and isArray(val) end,
	hashMap = function(val) return type(val) == 'table' and isHashMap(val) end,
	
	--Other
}
------------------------------ API ------------------------------
--IMPORTANT: Cannot differntiate between a class (e.g. Event) and its isntance (e.g. Event())
function overload.createOverload(_, opt)
	--Have to ignore the first arg is it will be `self` due to `mt.__call`.
	return function(...)
		local args = {...}
		local batch, i
		repeat
			batch, i = nextBatch(opt, i)
			if batch and checkTypes(args, batch) then
				return batch[#batch](...)
			end
		until not batch	
		error("No overload found for: " .. printTypes(args))
	end
end

-------------------------------- Metatable ------------------------------
setmetatable(overload, {
	__call = overload.createOverload
})


return overload
