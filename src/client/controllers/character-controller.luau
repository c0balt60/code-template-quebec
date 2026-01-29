--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[ Packages ]
local quebec = require("@quebec")
local Signal = require("@packages/signal")

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"start",
		"init",
	},
})

--[ Constants ]
local Player = Players.LocalPlayer :: Player

--[ Types ]

--[ Lifecycles ]
function Controller.init(self: Controller)
	-- utils
	self.CharacterAdded = Signal.new() :: Signal.Signal<Model>
	self.CharacterRemoving = Signal.new()
	self.HumanoidDied = Signal.new()
end
function Controller.start(self: Controller)
	-- Bind to character
	Player.CharacterAdded:Connect(function(char: Model)
		self:_characterAdded(char)
	end)
	Player.CharacterRemoving:Connect(function(char: Model)
		self:_characterRemoving(char)
	end)
end

--[ Controller Functions ]
--[=[
	@param character Model

	Client event for when a character respawns
]=]
function Controller._characterAdded(self: Controller, character: Model)
	-- Run logic before firing to controllers

	-- Send out signal
	self.CharacterAdded:Fire(character)
end

--[=[
	@param character Model

	Client event for when a character is removing
]=]
function Controller._characterRemoving(self: Controller, character: Model)
	-- Logic

	self.CharacterRemoving:Fire(character)
end

type Controller = typeof(Controller)
return Controller
