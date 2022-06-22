local overload, optional = require "cat-paw.core.utilities.overload"
local over
local uTable = {}

--- @function 
-- dasda
-- dasd
-- das
-- dasd
overload(uTable, "copy", {'table', 'table', 'bool'}, function(t, dest, copyMetatable)
	dest = dest or {}
	for k, v in pairs(t) do
		dest[k] = v
	end
	
	if copyMetatable then
		setmetatable(dest, getmetatable(t))
	end
	return dest
end)

overload(uTable, "copy", {'table', 'bool'}, function(t, copyMetatable)
	local rt = {}
	for k, v in pairs(t) do
		rt[k] = v
	end
	
	if copyMetatable then
		setmetatable(rt, getmetatable(t))
	end
	return rt
end)

uTable.copy = overload({
	'table', 'table', 'nil', 'boolean', 'nil',
	function(t, dest, copyMetatable)
		dest = dest or {}
		for k, v in pairs(t) do
			dest[k] = v
		end
		
		if copyMetatable then
			setmetatable(dest, getmetatable(t))
		end
		return dest	
	end,
	'table', 'boolean', 'nil',
	function (t, copyMetatable)
		local rt = {}
		for k, v in pairs(t) do
			rt[k] = v
		end
		if copyMetatable then
			setmetatable(rt, getmetatable(t))
		end
		return rt
	end
})

uTable.copy = overload({
	'table', optional('table', {}), optional('boolean'),
	function(t, dest, copyMetatable)
		--dest = dest or {}		Not needed anymore!
		for k, v in pairs(t) do
			dest[k] = v
		end
		
		if copyMetatable then
			setmetatable(dest, getmetatable(t))
		end
		return dest	
	end,
	'table', optional('boolean'),
	function (t, copyMetatable)
		local rt = {}
		for k, v in pairs(t) do
			rt[k] = v
		end
		if copyMetatable then
			setmetatable(rt, getmetatable(t))
		end
		return rt
	end
})


uTable.copy = over({
	over.TABLE, over.optional(over.TABLE), over.optional(over.BOOLEAN),
	over.TABLE, over.TABLE, over.BOOLEAN,
	'table', over.optional('table'), over.optional('boolean'),
	function(t, dest, copyMetatable)
		--dest = dest or {}		Not needed anymore!
		for k, v in pairs(t) do
			dest[k] = v
		end
		
		if copyMetatable then
			setmetatable(dest, getmetatable(t))
		end
		return dest	
	end,
	'table', optional('boolean'),
	function (t, copyMetatable)
		local rt = {}
		for k, v in pairs(t) do
			rt[k] = v
		end
		if copyMetatable then
			setmetatable(rt, getmetatable(t))
		end
		return rt
	end
})

overload({uTable, "copy",
	'table', optional('table', {}), optional('boolean'),
	function(t, dest, copyMetatable)
		--dest = dest or {}		Not needed anymore!
		for k, v in pairs(t) do
			dest[k] = v
		end
		
		if copyMetatable then
			setmetatable(dest, getmetatable(t))
		end
		return dest	
end})

overload({uTable, "copy",
	'table', optional('boolean'),
	function (t, copyMetatable)
		local rt = {}
		for k, v in pairs(t) do
			rt[k] = v
		end
		if copyMetatable then
			setmetatable(rt, getmetatable(t))
		end
		return rt
	end
})

return uTable
