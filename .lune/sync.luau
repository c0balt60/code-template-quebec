-- Sync for development
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local log = require("./utils/log")

log.info("Generating sourcemap...")
process.create("rojo", {
	"sourcemap",
	"default.project.json",
	"-o",
	"sourcemap.json",
	"--watch",
}, { stdio = "forward" })

log.info("Starting /out processing...")
process.create("darklua", {
	"process",
	"--config",
	"./.darklua.json",
	"--watch",
	"src",
	"out",
}, { stdio = "forward" })

log.info("Starting sync...")
process.exec("rojo", {
	"serve",
	"out.project.json",
}, { stdio = "forward" })
