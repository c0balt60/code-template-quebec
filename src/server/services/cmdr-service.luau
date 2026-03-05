--!strict

--[ Packages ]
local quebec = require("@quebec")
local cmdr = require("@packages/cmdr")

--[ Service ]
local Service = quebec.singleton({
	lifecycles = {
		"start",
	},
})

--[ Lifecycle Hooks ]
function Service.start(self: Service)
	cmdr:RegisterDefaultCommands()
end

type Service = typeof(Service)
return Service
