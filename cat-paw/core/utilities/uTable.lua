local uTable = {}

function uTable.copy(t, dest, copyMetatable)
	dest = dest or {}
	for k, v in pairs(t) do
		dest[k] = v
	end
	
	if copyMetatable then
		setmetatable(dest, getmetatable(t))
	end
end


function uTable.deepCopy(t, dest, copyMetatable)
	error "WIP"	
end

function uTable.has(t, other, equalityFunction)
	for k, v in pairs(t) do
		if equalityFunction and equalityFunction(v, other) or v == other then
			return true
		end
	end
	return false
end

function uTable.hasAllOf(t, other, equalityFunction)
	local found = {}
	for k, v in pairs(t) do
		for _k, _v in pairs(other) do
			if equalityFunction and equalityFunction(v, _v) or v == _v then 
				found[_k] = true
				--Can't continue because `compare` might have duplicates or functionally-equal objects!
			end
		end
	end
	
	for k, v in pairs(other) do
		if not found[k] then
			return false
		end
	end
	
	return true
end

return uTable
