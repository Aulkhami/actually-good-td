local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)
local Squash = require(ReplicatedStorage.Packages.Squash)

local function SerializeDeep(table: { [any]: any }): { [any]: any }
	local function mapper(value: any)
		local valueType = typeof(value)

		if valueType == "table" then
			return SerializeDeep(value)
		end

		if valueType == "string" then
			return value
		end

		return Squash[valueType].ser(value)
	end

	if Sift.Array.is(table) then
		return Sift.Array.map(table, mapper)
	else
		return Sift.Dictionary.map(table, mapper)
	end
end

return SerializeDeep
