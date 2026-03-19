local Players = game:GetService("Players")
local ReactCharm = require("@packages/react-charm")
local datastore = require("@shared/store/datastore")

local function useData()
	return ReactCharm.useAtom(function()
		local data = datastore.getPlayerData(Players.LocalPlayer.UserId)
		return data or nil
	end)
end

return useData
