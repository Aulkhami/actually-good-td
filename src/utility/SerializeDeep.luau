local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)
local Squash = require(ReplicatedStorage.Packages.Squash)

local function SerializeDeep(table: { [any]: any })
	local function mapper(value: any)
		if typeof(value) == "table" then
			return SerializeDeep(value)
		end

		if typeof(value) == "string" then
			return value
		end

		return Squash[typeof(value)].ser(value)
	end

	if Sift.Array.is(table) then
		return Sift.Array.map(table, mapper)
	else
		return Sift.Dictionary.map(table, mapper)
	end
end

return SerializeDeep
