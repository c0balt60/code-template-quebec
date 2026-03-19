--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

--[ Packages ]
local quebec = require("@quebec")
local react = require("@packages/react")
local react_roblox = require("@packages/react_roblox")

--[ Interfaces ]
local UI = ReplicatedStorage.shared.ui
local MainMenu = require(UI["main-menu"])

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"start",
	},
})

--[ Constants ]
local e = react.createElement

--[ Types ]

--[ Lifecycles ]
function Controller.start(self: Controller)
	local playerGui = Player:WaitForChild("PlayerGui")
	self.playerGui = playerGui

	self:build()
end

--[ Methods ]

function Controller.build(self: Controller)
	local root = react_roblox.createRoot(Instance.new("Folder"))

	root:render(react_roblox.createPortal(
		e(react.Fragment, nil, {
			MainMenu = e(MainMenu),
		}),
		self.playerGui
	))
end

type Controller = typeof(Controller)
return Controller
