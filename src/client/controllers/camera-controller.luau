--!strict
local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--[ Packages ]
local quebec = require("@quebec")

-- [ Constants ]
local Player = Players.LocalPlayer :: Player

-- [ Import ]
local CharacterController = require("@controllers/character-controller")

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
	-- Bind camera to hrp
	CharacterController.CharacterAdded:Connect(function()
		self:_bindCamera()
	end)
	CharacterController.CharacterRemoving:Connect(function()
		RunService:UnbindFromRenderStep("CameraOffset")
	end)
end

--[ Controller Functions ]
--[=[
	Binds the camera to players body with an interpolation, smoothing it out.
]=]
function Controller._bindCamera(self: Controller)
	local character = Player.Character
	if not character then
		return
	end

	local humanoidRoot = character:WaitForChild("HumanoidRootPart") :: BasePart
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	local head = character:WaitForChild("Head") :: BasePart

	-- Unbind previous
	RunService:UnbindFromRenderStep("CameraOffset")

	-- Bind smooth camera
	RunService:BindToRenderStep("CameraOffset", Enum.RenderPriority.Camera.Value - 1, function(dt: number)
		-- TweenService:Create(humanoid, TweenInfo.new(0.7), {
		-- 	CameraOffset = (humanoidRoot.CFrame + Vector3.new(0, 1.5, 0)):PointToObjectSpace(head.CFrame.Position),
		-- }):Play()
		humanoid.CameraOffset = humanoid.CameraOffset:lerp(
			(humanoidRoot.CFrame + Vector3.new(0, 1.5, 0)):PointToObjectSpace(head.CFrame.Position),
			0.1 + dt
		)
	end)
end

type Controller = typeof(Controller)
return Controller
