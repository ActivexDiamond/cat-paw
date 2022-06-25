local uDebug = {}

function uDebug.printAllLocals(level, opt)
	level = level or 2
	opt = opt or {}
	local equal = opt.equal or " = "
	local seperator = opt.seperator or "\n"
	local leading = opt.leading or "===> Echoing all locals in: <%s/%s>.\n"
	local trailing = opt.trailing or "\n===== Done =====\n"

	if not opt.leading then
		local t = debug.getinfo(2, "nS")
		leading = leading:format(t.short_src, t.name)	
	end
	
	local i = 1
	local name, val = debug.getlocal(level, i)
	io.write(leading)
	while name do
		io.write(name, equal, tostring(val), seperator)
		i = i + 1
		name, val = debug.getlocal(level, i)
	end
	io.write(trailing)		
end

return uDebug