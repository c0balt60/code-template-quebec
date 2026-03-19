--!strict
--[ Services ]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[ Packages ]
local Quebec = require("@quebec")
local Promise = require("@packages/promise")
local ProfileStore = require("@packages/profile-store")
local Net = require("@server-net")

--[ Config ]
local TEMPLATE = require("@config/profile-template")
local datastore = require(ReplicatedStorage.shared.store.datastore)

--[ Service ]
local Service = Quebec.singleton({
	lifecycles = {
		"start",
		"stop",
		require("../lifecycles/player-added") :: any,
		require("../lifecycles/player-removing") :: any,
	},
})

--[ Constants ]
local PlayerStore = ProfileStore.New("PlayerStore", TEMPLATE)
local Leaderstats: { [Player]: { IntValue } } = {}

--[ Types ]
type ProfileData = TEMPLATE.Template
type Profile = TEMPLATE.Profile

--[ Private Functions ]

--[=[
	@within ProfileService
	@param player Player
	@return Leaderstats {[player]: {IntValue}}

	Creates leaderstats folder for player
]=]
local function createLeaderstats(player: Player): typeof(Leaderstats[Instance.new("Player")])
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player

	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash"
	Cash.Parent = folder

	Leaderstats[player] = {
		Cash = Cash,
	}

	return Leaderstats[player]
end

--[=[
	@within ProfileService
	@param player Player
	@return void

	Loads player data in through profile store, wrapped in promise for async handling
]=]
local PlayerAdded = Promise.promisify(function(player: Player): Profile?
	-- Start a profile session for this player's data:
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

		profile.OnSessionEnd:Connect(function()
			--Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			--Profiles[player] = profile
			return profile
		else
			-- The player has left before the profile session started
			profile:EndSession()
			return nil
		end
	else
		-- This condition should only happen when the Roblox server is shutting down
		player:Kick(`Profile load fail - Please rejoin`)
		return nil
	end
end)

--[ Lifecycle Hooks ]
function Service.start(self: Service)
	print("Started service")
end

function Service.onPlayerAdded(self: Service, player: Player)
	PlayerAdded(player):andThen(function(profile)
		assert(profile, `[profile-service] Failed to load profile for {player.DisplayName}`)
		print(`[profile-service] Profile loaded for {player.DisplayName}`)
		print(profile)

		createLeaderstats(player)

		-- Load player profile into atom
		datastore.setPlayerData(`{player.UserId}`, profile)
	end)
end

type Service = typeof(Service)
return Service
