--!strict
--[ Services ]
local Players = game:GetService("Players")

--[ Packages ]
local Quebec = require("@quebec")

--[ Lifecycle ]
local Lifecycle = Quebec.lifecycle({
	defaultMethod = "onPlayerRemoving",
})
type Lifecycle = Quebec.CustomLifecycle<typeof(Lifecycle)>

--[=[
	@lifecycle onPlayerRemoving

	Custom PlayerRemoving lifecycle to be used in services
]=]
function Lifecycle.run(self: Lifecycle)
	for _, player in Players:GetPlayers() do
		self:invokeAll(player)
	end

	Players.PlayerRemoving:Connect(function(player)
		self:invokeAllSameThread(player)
	end)
end

return Lifecycle
