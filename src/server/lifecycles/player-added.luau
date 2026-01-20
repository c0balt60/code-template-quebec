--!strict
--[ Services ]
local Players = game:GetService("Players")

--[ Packages ]
local Quebec = require("@quebec")

--[ Lifecycle ]
local Lifecycle = Quebec.lifecycle({
	defaultMethod = "onPlayerAdded",
})
type Lifecycle = Quebec.CustomLifecycle<typeof(Lifecycle)>

--[=[
	@lifecycle onPlayerAdded

	Custom PlayerAdded lifecycle to be used in services
]=]
function Lifecycle.run(self: Lifecycle)
	for _, player in Players:GetPlayers() do
		self:invokeAll(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:invokeAllSameThread(player)
	end)
end

return Lifecycle
