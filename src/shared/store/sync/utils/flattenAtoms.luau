local charm_sync = require("@packages/charm-sync")
local charm = require("@packages/charm")

local function flattenAtoms(maps)
	local flattened = {}

	for prefix, map in maps do
		for key, atom in map do
			flattened[`{prefix}/{key}`] = atom
		end
	end

	return flattened
end

return flattenAtoms
