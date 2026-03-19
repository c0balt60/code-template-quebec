local charm_sync = require("@packages/charm-sync")
local net = require("@client-net")

local atoms = require("./atoms")

local syncer = charm_sync.client({ atoms = atoms })

net.Replication.sync.On(function(payload: charm_sync.SyncPayload)
	syncer:sync(payload)
end)

net.Replication.init.Fire()
