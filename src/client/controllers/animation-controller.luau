local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[ Packages ]
local quebec = require("@quebec")
local Promise = require("@packages/promise")
local Signal = require("@packages/signal")
local Janitor = require("@packages/janitor")

--[ Controller ]
local Controller = quebec.singleton({
	lifecycles = {
		"init",
		"start",
	},
})

--[ Constants ]
local Animations = require("@config/animations")
local Tracks = {} :: { [string]: AnimationTrack }

--[ Types ]

--[ Local Functions ]

--[=[
	Loads animations to the character
]=]
local function loadAnimations(character: Model): Promise.TypedPromise<typeof(Tracks)?>
	return Promise.new(function(resolve: (...any) -> (), reject: (...any) -> ())
		if not character then
			reject("No character.")
		end

		local humanoid = character:WaitForChild("Humanoid") :: Humanoid

		local animationController = humanoid:WaitForChild("Animator") :: Animator
		if not animationController then
			reject("No animation controller.")
		end

		-- Look for already loaded animation folder
		local _folder_loaded = humanoid:FindFirstChildOfClass("Folder")
		if _folder_loaded then
			warn("Character already has animation folder")
		end

		-- Animations folder into character
		local _folder = Instance.new("Folder")
		_folder.Name = "LoadedAnimations"
		_folder.Parent = humanoid

		-- Load animations
		print(Animations)
		for name, id in Animations :: any do
			local animation = Instance.new("Animation")
			animation.AnimationId = `rbxassetid://{id}`
			animation.Name = name
			animation.Parent = _folder

			local animationTrack = animationController:LoadAnimation(animation)
			animationTrack.Priority = Enum.AnimationPriority.Action4
			animationTrack.Name = name

			Tracks[name] = animationTrack
		end

		resolve(Tracks)
	end)
end

--[ Lifecycles ]
function Controller.init(self: Controller)
	-- vars
	self._isLoaded = false
	self._current = nil :: AnimationTrack?
	-- util
	self._loaded = Signal.new()
	self._janitor = Janitor.new()
end
function Controller.start(self: Controller) end

--[ Controller Functions ]

--[=[
	Return the amount of loaded tracks
]=]
function Controller._getTracks(self: Controller): typeof(Tracks)?
	return if #{ next(Tracks) } == 0 then nil else Tracks
end

--[=[
	Overwrites the currently playing animation and plays a new one
]=]
function Controller.Play(self: Controller, name: string)
	-- Stop current
	if self._current then
		self._current:Stop()
	end

	-- Yield until everything loads
	if not self._isLoaded then
		self._loaded:wait()
	end

	-- Play new
	local overwrite = Tracks[name]
	if overwrite then
		overwrite:Play()

		-- Track animation events
		-- if self.AnimationEvents[name] then
		-- 	for _, v in self.AnimationEvents[name] do
		-- 		overwrite:GetMarkerReachedSignal(v.Name):Once(function()
		-- 			self.animationEvent:Fire(v.Name, overwrite)
		-- 			--print("FIRE")
		-- 		end)
		-- 	end
		-- end

		-- Send signal
		-- self.animationPlaying:Fire(overwrite)
	end
end

type Controller = typeof(Controller)
return Controller
