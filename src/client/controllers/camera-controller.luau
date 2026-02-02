--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--[ Packages ]
local quebec = require("@quebec")

-- [ Constants ]
local Player = Players.LocalPlayer :: Player
local Camera = workspace.CurrentCamera

-- Tilt
local TiltConstant = 2
local Frequency = 0.25
local Amplitude = 0.1
-- Lean
local MaxTiltAngle = 10

-- [ Import ]
local CharacterController = require("@controllers/character-controller")

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"init",
		"start",
	},
})

--[ Constants ]

--[ Types ]

--[ Lifecycles ]
function Controller.init(self: Controller)
	-- vars
	self.Rot = CFrame.new()
	self.Tilt = CFrame.new()
	self.Delta = 0
end
function Controller.start(self: Controller)
	-- Bind camera to hrp
	CharacterController.CharacterAdded:Connect(function(character)
		self._char = character

		-- Decompose
		self.RootPart = character.HumanoidRootPart :: BasePart
		self.RootJoint = character.LowerTorso.Root :: Motor6D
		self.RootC0 = self.RootJoint.C0

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

		self:_cameraBob(dt)
		self:_lean(dt)
	end)
end

--[=[
	@param dt number

	Returns the roll dot product
]=]
function Controller._lean(self: Controller, delta: number)
	-- Leaning
	local MoveDirection = self.RootPart.CFrame:VectorToObjectSpace(self._char.Humanoid.MoveDirection)
	self.Tilt = self.Tilt:Lerp(CFrame.Angles(0, 0, math.rad(-MoveDirection.X) * MaxTiltAngle), 0.2 ^ (1 / (delta * 60)))
	self.RootJoint.C0 = self.RootC0 * self.Tilt
end

--[=[
	returns the roll angle
]=]
function Controller._getRollAngle(self: Controller)
	assert(self._char)
	return -Camera.CFrame.RightVector:Dot(self._char.Humanoid.MoveDirection)
end

--[=[
	rotate the camera
]=]
function Controller._cameraRotate(self: Controller)
	local Roll = self:_getRollAngle() * TiltConstant
	self.Rot = self.Rot:Lerp(CFrame.Angles(0, 0, math.rad(Roll)), 0.075)

	Camera.CFrame *= self.Rot
end

--[=[
	@param delta number

	bob the camera
]=]
function Controller._cameraBob(self: Controller, delta: number)
	self.Delta += delta
	local humanoid = self._char.Humanoid

	if not (humanoid.MoveDirection.Magnitude > 0) then
		return
	end

	local verticalOffset = math.sin(self.Delta * Frequency * math.pi) * Amplitude
	humanoid.CameraOffset = humanoid.CameraOffset:Lerp(Vector3.new(0, verticalOffset, 0), 0.5)
end

type Controller = typeof(Controller)
return Controller
