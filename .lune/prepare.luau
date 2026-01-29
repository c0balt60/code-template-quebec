-- Prepare for development
local process = require("@lune/process")

local blinkgen = require("./blinkgen")

local function exec(program: string, args: { string })
	local result = process.exec(program, args, { stdio = "forward" })
	if not result.ok then
		process.exit(result.code)
	end
end

exec("rokit", { "install" })
exec("pesde", { "install" })

exec("rojo", { "sourcemap", "-o", "./sourcemap.json" })
exec("darklua", { "process", "--config", "./.darklua.json", "src", "out" })

blinkgen()
