local charm_sync = require("@packages/charm-sync")
local net = require("@server-net")

local atoms = require("./atoms")

local syncer = charm_sync.server({ atoms = atoms })

syncer:connect(function(player, payload)
	net.Replication.sync.Fire(player, payload)
end)

net.Replication.init.On(function(player: Player)
	syncer:hydrate(player)
end)
