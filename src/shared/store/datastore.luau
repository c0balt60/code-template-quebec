local Charm = require("@packages/charm")
local Sift = require("@packages/sift")
local profile_template = require("@config/profile-template")

type PlayerData = profile_template.Profile

local datastore = {
	players = Charm.atom({}) :: Charm.Atom<{ [string]: PlayerData }>,
}

local function getPlayerData(id: string)
	return datastore.players()[id]
end

local function setPlayerData(id: string, data: PlayerData)
	datastore.players(function(state)
		return Sift.Dictionary.merge(state, { [id] = data })
	end)
end

local function deletePlayerData(id: string)
	datastore.players(function(state)
		return Sift.Dictionary.merge(state, { [id] = nil })
	end)
end

local function updatePlayerData(id: string, updater: (data: PlayerData) -> PlayerData)
	datastore.players(function(state)
		return Sift.Dictionary.merge(state, { [id] = state[id] and updater(state[id]) })
	end)
end

return {
	datastore = datastore,
	getPlayerData = getPlayerData,
	setPlayerData = setPlayerData,
	deletePlayerData = deletePlayerData,
	updatePlayerData = updatePlayerData,
}
