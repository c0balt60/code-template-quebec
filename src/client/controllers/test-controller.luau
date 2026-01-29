--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[ Packages ]
local quebec = require("@quebec")

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"start",
	},
})

--[ Constants ]

--[ Types ]

--[ Lifecycles ]
function Controller.start(self: Controller) end

type Controller = typeof(Controller)
return Controller
