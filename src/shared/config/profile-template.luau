local ProfileStore = require("@packages/profile-store")

local TEMPLATE = {
	Cash = 0,
	Scrap = 0,

	experience = 0,
	level = 1,

	Inventory = {},
	Settings = {},
}

export type Template = typeof(TEMPLATE)
export type Profile = ProfileStore.Profile<Template>

return TEMPLATE
