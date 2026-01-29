local process = require("@lune/process")

local function gen()
	process.exec("blink", { "net.blink" }, { stdio = "forward" })
end

return function()
	gen()
end
