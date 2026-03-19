local process = require("@lune/process")
local blinkgen = require("../blinkgen")

local function prepare()
	process.exec("rokit", { "install" }, { stdio = "forward" })
	process.exec("pesde", { "install" }, { stdio = "forward" })
	-- Asphalt sync if needed

	-- Regenerate sourcemap
	process.create("rojo", {
		"sourcemap",
		"default.project.json",
		"-o",
		"sourcemap.json",
		"--watch",
	}, { stdio = "forward" })

	blinkgen()
end

return prepare
