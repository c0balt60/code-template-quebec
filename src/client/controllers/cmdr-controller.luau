--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[ Packages ]
local quebec = require("@quebec")
local cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient")) :: any

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"start",
	},
})

--[ Constants ]

--[ Types ]

--[ Lifecycles ]
function Controller.start(self: Controller)
	cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
end

type Controller = typeof(Controller)
return Controller
