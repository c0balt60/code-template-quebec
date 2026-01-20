--!strict
--[ Services ]
local ServerScriptService = game:GetService("ServerScriptService")

--[ Framework ]
local Quebec = require("@quebec")

--[ Initiate ]
Quebec.run(ServerScriptService.services, {
	info = true,
	--debug = true
})
