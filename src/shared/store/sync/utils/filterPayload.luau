local charm_sync = require("@packages/charm-sync")
local Sift = require("@packages/sift")

local function filterPayload(player: Player, payload: charm_sync.SyncPayload)
	if payload.type == "init" then
		return Sift.Dictionary.merge(payload, {
			data = Sift.Dictionary.merge(payload.data, {
				["datastore/players"] = {
					[player.Name] = payload.data["datastore/players"][player.Name],
				},
			}),
		})
	end

	return Sift.Dictionary.merge(payload, {
		data = Sift.Dictionary.merge(payload.data, {
			["datastore/players"] = payload.data["datastore/players"] and {
				[player.Name] = payload.data["datastore/players"][player.Name],
			},
		}),
	})
end

return filterPayload
