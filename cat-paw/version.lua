local version = {}

------------------------------ Locals ------------------------------

--The chronological ordering of branches, used for comparing versions to check which is newer.
local branches = {
	alpha = 1,
	beta = 2,
	prerelease = 3,
	none = 10,
}

--TODO: Find a way to properly just pass a relative path to `io.open`. 
local VERSION_PATHS = {
	"version",
	"cat-paw/version",
	"src/cat-paw/version",
	"src/cat-paw/cat-paw/version",
	"cat-paw/cat-paw/version",
	"src/cat-paw/cat-paw/version",
	"src/lib/cat-paw/version",
	"src/libs/cat-paw/version",
	"src/engine/cat-paw/version",
}
------------------------------ Constants ------------------------------

--Both set by `version._readVersionFromFile`.
version.VERSION_FILE_PATH = nil
version.VERSION_STRING = nil

------------------------------ Internals ------------------------------
function version._readVersionFromFile()
	local f, msg, path
	for i, p in ipairs(VERSION_PATHS) do
		local succ
		succ, f = pcall(io.open, p)
		if f then
			path = p 
			break
		end
	end
	
	if f then
		version.VERSION_FILE_PATH = path
		version.VERSION_STRING = f:read("*all")
		f:close()
	else
		version.VERSION_FILE_PATH = "UNKNOWN"
		version.VERSION_STRING = "UNKNOWN"
		print("WARNING: Could not locate version file! Checked the following locations:\n" .. 
				table.concat(VERSION_PATHS,"\n"))
	end
end

------------------------------ Metamethods ------------------------------
function version.__tostring()
	return version.VERSION_STRING
end

------------------------------ Quick Test ------------------------------

--[[
print(version.getVersionString())
version.HOTFIX = 0
print(version.getVersionString())
version.HOTFIX = 42
print(version.getVersionString())

version.HOTFIX = 1.2
print(version.getVersionString())	--Should fail due to invalid HOTFIX.
--]]

------------------------------ Finalize & Returns ------------------------------
setmetatable(version, version)

--The version is expected to never change at runtime, so only computing this once on import should be fine.
version._readVersionFromFile()

return version
